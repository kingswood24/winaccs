{ Sorting Unit }
Unit SortIt;

InterFace

PROCEDURE SortFile (SortDb,FLNO,WKNO,FLD1,FLD2,FLD3,FLD4:INTEGER;
				     ASC1,ASC2,ASC3,ASC4:BOOLEAN;
				     start_from, nom_from : integer;
				     nom_pointer, sort_pointers : boolean );

Implementation
Uses
    Printers,
    SysUtils,
    Dialogs,
    DBCore,
    abortprg,
    filed,
    types,
    vars;

PROCEDURE SortFile (SortDb,FLNO,WKNO,FLD1,FLD2,FLD3,FLD4:INTEGER;
				     ASC1,ASC2,ASC3,ASC4:BOOLEAN;
				     start_from, nom_from : integer;
				     nom_pointer, sort_pointers : boolean );

CONST
  MAXSORT   = 14;
  MAXGROUPS = 256;
  MAXBLOCK  = 256;
  LARGEROF2 = 256;
  MAXREPST  = 30000;
  WORKBLK   = 8;
TYPE
  TREPKEY     = PACKED ARRAY[1..MAXSORT] OF CHAR;
  TSEQREC    = PACKED ARRAY[1..256] OF SmallInt;
  TSORTITEM  = PACKED ARRAY[1..4] OF SmallInt;
  TSORTTRUNC = PACKED ARRAY[1..4] OF SmallInt;
  TASCEND    = PACKED ARRAY[1..4] OF BOOLEAN;
  TWORKREF   = PACKED ARRAY[1..MAXBLOCK] OF TREPKEY;
  TWORKREC   = PACKED ARRAY[1..MAXBLOCK] OF SmallInt;
  TSORTS     = PACKED ARRAY[1..LARGEROF2] OF SmallInt;
  TSORTREC   = PACKED ARRAY[1..LARGEROF2] OF SmallInt;
VAR
{-->>  xC          : LongInt;}
  SEQREC    : ^TSEQREC;
  SEQBLK    : INTEGER;
  SEQMAX    : INTEGER;
  SortItem  : ^TSORTITEM;
  SortTrunc : ^TSORTTRUNC;
  Ascend    : ^TASCEND;
{-->>  SORTSZ    : INTEGER;}
{-->>  SORTTOT   : INTEGER;}
  Count	    : INTEGER;
{-->>  KEYPREC   : INTEGER;}
  WKB	    : INTEGER;
  WorkRef   : TWORKREF; (*Packed Array [1..MAXBLOCK] OF ^TREPKEY;{^TWORKREF;}*)
  WorkRec   : ^TWORKREC;
  REPHIGHVAL: ^TREPKEY;
  REPLOWVAL : ^TREPKEY;
  SORTS     : ^TSORTS;
  SORTREC   : ^TSORTREC;
  SORTVAL   : PACKED ARRAY[1..LARGEROF2] OF ^TREPKEY;{^TSORTVAL;}
  CURRWORK  : INTEGER;
  SORTSUB   : INTEGER;
  BLOCKNO   : INTEGER;
  TOTSORTS  : INTEGER;
  WORKKEY   : ^TREPKEY;
  OFFSET    : INTEGER;
  busy_signal : integer;
  Dcounter    : Integer;


  PROCEDURE MainExit ( Fatal : Boolean; Msg : ShortString );
  Var
     DCounter : Integer;
  BEGIN
        Dispose ( SeqRec );
        Dispose ( SortItem );
        Dispose ( SortTrunc );
        Dispose ( Ascend );
        {
        For DCounter := 1 To MaxBlock Do
            Dispose ( WorkRef[DCounter] );
        }
        Dispose ( WorkRec );
        Dispose ( Sorts );
        Dispose ( SortRec );
        For DCounter := 1 To LargerOf2 Do
            Dispose ( SortVal[DCounter] );
        Dispose ( RepHighVal );
        Dispose ( RepLowVal );
        Dispose ( WorkKey );
        If Fatal Then
           AbortProgram ( Msg );
  END;

  PROCEDURE RECREAD (RECNO: INTEGER);
  VAR
    BLKNO : INTEGER;
    SUB	  : INTEGER;
  BEGIN
    CURROFST[SortDb]:=0;
    IF (RECNO<1) OR (RECNO>DB1.DBRECTOT) THEN EXIT;
    BLKNO:=((RECNO-1) DIV DB1.DBRECBLK);
    SUB	 :=RECNO-(DB1.DBRECBLK*BLKNO);
    IF BLKNO<>CURRDATBLK[SortDb] THEN
      BEGIN
	IF CREAD (SortDb,2,(BLKNO*2)+DB1.DBDATAS)<2 THEN MainExit ( True, SeqErr );
	MOVE (CBLOCKS[1],DATWORK^[1],1024);
	CURRDATBLK[SortDb]:=BLKNO;
      END;
    CURROFST[SortDb]:=((SUB-1)*DB1.DBRECSZ);
  END;

  PROCEDURE BLANKOUT (TOT: INTEGER);
  VAR
    X : INTEGER;
  BEGIN
    FOR X:=1 TO TOT DO
      BEGIN
	SORTVAL[X]^:=REPHIGHVAL^;
	SORTREC^[X]:=32767;
      END;
    FOR X:=1 TO MAXBLOCK DO
      BEGIN
	WORKREF[X]:=REPHIGHVAL^;
	WORKREC^[X]:=32767;
      END;
  END;

  PROCEDURE SORTISU;
  VAR
    SUB : INTEGER;
  BEGIN
    CURRWORK:=999;
    SORTSUB :=0;
    SEQBLK  := 0;
    TOTSORTS:=0;
    BLOCKNO :=0;
    FOR SUB:=1 TO MAXSORT DO
      BEGIN
	REPHIGHVAL^[SUB]:=CHR(127);
	REPLOWVAL^[SUB]:=CHR(0);
      END;
    WKB:=0;
    BLANKOUT (LARGEROF2);
  END;

  PROCEDURE WRITEBLOCK;
  BEGIN
    IF SORTSUB=0 THEN EXIT;
    {
    MOVE (WORKREF[1]^[1],CBLOCKS[1],WORKBLK*512);
    }
    MOVE (WORKREF[1][1],CBLOCKS[1],3584);
    MOVE (WORKREC^[1],CBLOCKS[8],512);

    IF CWRITE (WKNO,WORKBLK,WKB)<WORKBLK THEN MainExit (True,SEQERR);
    WKB:=WKB+WORKBLK;
    BLOCKNO:=BLOCKNO+1;
  END;

  PROCEDURE STACKSORT;
  VAR
    FROMSLOT : INTEGER;
    TOSLOT   : INTEGER;
    TRYSLOT  : INTEGER;
    NoOfMoves,
    MovesTaken : Integer;

    PROCEDURE MAKEREF1;
    VAR
      OFSET : INTEGER;
      SUB,
      MAXS  : INTEGER;

      PROCEDURE INTSORT;
      VAR
	WORD : PACKED ARRAY [1..2] OF CHAR;
      BEGIN
	FILLCHAR (CURRDISP[1],MAXISIZE,CHR(0));
	Move (CURRINT,WORD[1],2);
	Move (WORD[2],CURRDISP[1],1);
	Move (WORD[1],CURRDISP[2],1);
      END;

      PROCEDURE LONGSORT (LEN: INTEGER);
      VAR
	LONGWORD : PACKED ARRAY [1..10] OF CHAR;
	INT	 : INTEGER;
      BEGIN
	FILLCHAR (CURRDISP[1],MAXISIZE,CHR(0));
	IF LEN=6
	  THEN Move (CURRKONG,LONGWORD[1],LEN)
	  ELSE Move (CURRLONG,LONGWORD[1],LEN);
	FOR INT:=1 TO LEN DIV 2 DO
	  BEGIN
	    Move (LONGWORD[ INT*2	],CURRDISP[(INT*2)-1],1);
	    Move (LONGWORD[(INT*2)-1],CURRDISP[ INT*2   ],1);
	  END;
      END;

    BEGIN
      OFSET:=1;
      IF ASCEND^[1]
	THEN FILLCHAR(WORKKEY^[1],MAXSORT,CHR(0))
	ELSE FILLCHAR(WORKKEY^[1],MAXSORT,CHR(127));
      FOR SUB:=1 TO 4 DO
	IF SORTITEM^[SUB]>0 THEN
	  BEGIN
	    IF SORTITEM^[SUB] =999 THEN
	      BEGIN
		CURRINT := CURRREC[SortDb];
		INTSORT;
	      END
	    ELSE
	      BEGIN
		GETITEM(SortDb,SORTITEM^[SUB]);
		CASE DB1.DBITEMS[SORTITEM^[SUB]].DBITYPE[0] OF
		  'C','D','E','F'    : INTSORT;
		  'K'		     : LONGSORT(6);
		  'L','M','*','%'    : LONGSORT(10);
		  'N','T'	     : INTSORT;
		END;
	      END;

	    MAXS:=SORTTRUNC^[SUB];
	    IF OFSET+MAXS>MAXSORT+1 THEN
	      MAXS:=MAXSORT-OFSET+1;
	    Move (CURRDISP[1],WORKKEY^[OFSET],MAXS);
	    OFSET:=OFSET+MAXS;
	  END;
    END;

  BEGIN
    TOTSORTS:=TOTSORTS+1;
    SORTSUB :=SORTSUB +1;
    IF TOTSORTS>MAXREPST THEN EXIT;
    IF SORTSUB >MAXBLOCK THEN
      BEGIN
	WRITEBLOCK;
	BLANKOUT (LARGEROF2);
	SORTSUB:=1;
      END;
    MAKEREF1;
    FROMSLOT:=0;
    IF SORTSUB=1 THEN FROMSLOT:=1;
    IF SORTSUB>1 THEN
      BEGIN
	IF ASCEND^[1] THEN
	  IF WORKKEY^>WORKREF[SORTSUB-1] THEN
	    FROMSLOT:=SORTSUB;
	IF NOT ASCEND^[1] THEN
	  IF WORKKEY^<WORKREF[SORTSUB-1] THEN
	    FROMSLOT:=SORTSUB;
      END;
    IF FROMSLOT=0 THEN
      BEGIN
	FROMSLOT:=1;
	TOSLOT	:=SORTSUB-1;
	REPEAT
	  IF TOSLOT<FROMSLOT THEN TOSLOT:=FROMSLOT;
	  TRYSLOT:=(FROMSLOT+TOSLOT) DIV 2;
	  IF ASCEND^[1] THEN
	    BEGIN
	      IF WORKKEY^>WORKREF[TRYSLOT]
		THEN FROMSLOT:=TRYSLOT+1
		ELSE TOSLOT  :=TRYSLOT;
	    END;
	  IF NOT ASCEND^[1] THEN
	    BEGIN
	      IF WORKKEY^<WORKREF[TRYSLOT]
		THEN FROMSLOT:=TRYSLOT+1
		ELSE TOSLOT  :=TRYSLOT;
	    END;
	UNTIL FROMSLOT=TOSLOT;
        IF FROMSLOT<SORTSUB THEN
	  BEGIN
            {
            Printer.Canvas.TextOut ( 0,xC,'SORTSUB ' + IntToStr ( SortSub) + ' FROMSLOT ' + IntToStr ( FromSlot ));

            Inc ( xC, Printer.Canvas.TextHeight('S')+15 );
            If ( xC+Printer.Canvas.TextHeight('S')+15 >= Printer.PageHeight ) Then
               Begin
                 Printer.NewPage;
                 xC := 0;
               End;
            }

            NoOfMoves := SortSub-FromSlot;
            For MovesTaken := NoOfMoves DownTo 1 Do
                MOVE (WORKREF[FROMSLOT+MovesTaken-1][1],
                    WORKREF[FROMSLOT+MovesTaken][1],MAXSORT );

            NoOfMoves := (SortSub-FromSlot);
            If FromSlot+NoOfMoves <= MAXBLOCK Then
            For MovesTaken := NoOfMoves DownTo 1 Do
                MOVE ( WORKREC^[FROMSLOT+MovesTaken-1],
                   WORKREC^[FROMSLOT+MovesTaken],2 );

            {
            MessageDlg('SORTSUB ' + IntToStr ( SortSub) + ' FROMSLOT ' + IntToStr ( FromSlot ),mtinformation,[mbok],0);
            MOVERIGHT (WORKREF[FROMSLOT]^[1],
		       WORKREF[FROMSLOT+1]^[1],MAXSORT*(SORTSUB-FROMSLOT) );
            }
            (*
            MOVE{RIGHT} (WORKREF[FROMSLOT]^[1],
		       WORKREF[FROMSLOT+1]^[1],MAXSORT*(SORTSUB-FROMSLOT) );
	    MOVE{RIGHT} (WORKREC^[FROMSLOT],
		       WORKREC^[FROMSLOT+1],2*(SORTSUB-FROMSLOT) );
            *)
	  END;
      END;
    WORKREF[FROMSLOT]:=WORKKEY^;
    WORKREC^[FROMSLOT]:=CURRREC[SortDb];
  END;

  PROCEDURE NEXTSORT (X: INTEGER);
{-->>  VAR
    ERR : INTEGER;}
  BEGIN
    IF SORTS^[X]>MAXBLOCK THEN
      BEGIN
	SORTS^  [X]:=MAXBLOCK;
	SORTVAL[X]^:=REPHIGHVAL^;
	SORTREC^[X]:=32767;
	EXIT;
      END;
    IF SORTVAL[X]^=REPHIGHVAL^ THEN EXIT;
{-->>    ERR:=0;}
    IF X<>CURRWORK THEN
      BEGIN
	IF CREAD (WKNO,WORKBLK,(X-1)*WORKBLK)<WORKBLK THEN MainExit ( True,SEQERR);
        MOVE (CBLOCKS[1],WORKREF[1][1],3584);
        MOVE (CBLOCKS[8],WORKREC^[1],512);
	{
        Move (CBLOCKS[1],WORKREF[1]^[1],WORKBLK*512);
        }
      END;
    SORTVAL[X]^:=WORKREF[SORTS^[X]];
    SORTREC^[X]:=WORKREC^[SORTS^[X]];
    CURRWORK:=X;
  END;

  PROCEDURE PUTSEQ (RECNO: INTEGER);
  BEGIN
    OFFSET:=OFFSET+1;
    IF OFFSET>256 THEN
      BEGIN
	Move (SEQREC^[1],CBLOCKS[1],512);
	IF CWRITE (FLNO,1,SEQBLK)<1 THEN MainExit ( True, SeqErr );
	FILLCHAR (SEQREC^[1],512,CHR(0));
	SEQBLK:=SEQBLK+1;
	OFFSET:=1;
      END;
    SEQREC^[OFFSET]:=RECNO;
    SEQMAX:=SEQMAX+1;
  END;

  PROCEDURE PRINTSORT;
  VAR
    NEVER  : BOOLEAN;
{-->>    SUB	   : INTEGER;}
    LOWEST : INTEGER;
    X	   : INTEGER;
  BEGIN
    NEVER:=FALSE;
{-->>    SUB	 :=0;}
    Lowest := 0;
    BLANKOUT (LARGEROF2);
    FOR X:=1 TO BLOCKNO DO SORTVAL[X]^:=REPLOWVAL^;
    IF BLOCKNO <1 THEN EXIT;
    IF TOTSORTS=0 THEN EXIT;
    FOR X:=1 TO LARGEROF2 DO SORTS^[X]:=1;
    FOR X:=1 TO BLOCKNO	  DO NEXTSORT(X);
    REPEAT
      IF ASCEND^[1] THEN WORKKEY^:=REPHIGHVAL^;
      IF NOT ASCEND^[1] THEN WORKKEY^:=REPLOWVAL^;
      FOR X:=1 TO BLOCKNO DO
	BEGIN
	  IF ASCEND^[1] THEN
	    BEGIN
	      IF SORTVAL[X]^<WORKKEY^ THEN
		BEGIN
		  LOWEST :=X;
		  WORKKEY^:=SORTVAL[X]^;
		  CURRREC[SortDb]:=SORTREC^[X];
		END;
	    END;
	  IF NOT ASCEND^[1] THEN
	    BEGIN
	      IF (SORTVAL[X]^>WORKKEY^) AND (SORTVAL[X]^<>REPHIGHVAL^) THEN
		BEGIN
		  LOWEST :=X;
		  WORKKEY^:=SORTVAL[X]^;
		  CURRREC[SortDb]:=SORTREC^[X];
		END;
	    END;
	END;
      IF (WORKKEY^=REPHIGHVAL^) AND     ASCEND^[1] THEN EXIT;
      IF (WORKKEY^=REPLOWVAL^)  AND NOT ASCEND^[1] THEN EXIT;
      SORTS^[LOWEST]:=SORTS^[LOWEST]+1;
      NEXTSORT (LOWEST);
      PUTSEQ (CURRREC[SortDb]);
      {
      DISI (30,24,SUB+1,5);
      }
{-->>      SUB:=SUB+1;}
    UNTIL NEVER;
  END;

  PROCEDURE STARTPROC;

  BEGIN

    {
    DIS	 ( 1,24,'READING/SORTING RECORD	      OF');
    DISI (33,24,DB1.DBRECHIGH,1);
    }
    SORTISU;

  END;

  PROCEDURE INPUTPROC;
  VAR
    START : INTEGER;
  BEGIN
    CURRDATBLK[SortDb]:=-10;
{-->>    START := CURRREC[SortDb];}
{
    FOR START := 1 TO DB1.DBRECHIGH DO
}

    if sort_pointers then
      Begin
	start := start_from;

	while ( START <> 0 ) do
	  BEGIN
	    CURRREC[SortDb] := START;
	    {
	    DISI (24,24,CURRREC[SortDb],5);
	    }
	    RECREAD (CURRREC[SortDb]);

	    if nom_pointer then
	      Begin
		getitem ( SortDb, 18 );
		if currint = nom_from then
		  getitem ( SortDb, 13 )
		else
		  getitem ( SortDb, 14 );
		start := currint;
	      End
	    else
	      Begin
		getitem ( SortDb, 16 );
		start := currint;
	      End;

	    IF RECACTIVE(SortDb) THEN STACKSORT;
	  END
      End
    else
      FOR START := tx_start TO tx_end DO
	BEGIN
	  CURRREC[SortDb] := START;
	  {
	  DISI (24,24,CURRREC[SortDb],5);
	  }

	  RECREAD (CURRREC[SortDb]);
	  IF RECACTIVE(SortDb) THEN STACKSORT;
	END;

    {
    start := tx_start;
    while ( start <> 0 ) DO
      BEGIN
	CURRREC[SortDb] := START;
	DISI (24,24,CURRREC[SortDb],5);

	RECREAD (CURRREC[SortDb]);

	getitem ( SortDb, 13 );
	start := currint;

	IF RECACTIVE(SortDb) THEN STACKSORT;
      END;
    }

  END;

  PROCEDURE OUTPUTPROC;
  BEGIN
    CCLOSE (FLNO,'N');
    CREWRITE (FLNO,SORTID);

(*
    The sort is crashing out after this rewrite the problem willl have to be
    traced at another time. It will only crash if the Development text files
    are loaded.
*)
    IF ERRORNO > 0 THEN MainExit ( True, SeqErr );

    WRITEBLOCK;
    {
    CLEARFROM(24);
    DIS	 ( 1,24,'WRITING SEQUENCE FILE RECORD	    OF');
    DISI (39,24,TOTSORTS,1);
    }
    SEQMAX:=0;
    SEQBLK:=0;
    OFFSET:=0;
    FILLCHAR (SEQREC^[1],512,CHR(0));
    PRINTSORT;
  END;

  PROCEDURE ENDPROC;
  BEGIN
    {
    CLEARFROM (24);
    }
    PUTSEQ (32766);
    Move (SEQREC^[1],CBLOCKS[1],512);
    IF CWRITE (FLNO,1,SEQBLK)<1 THEN MainExit ( True, SeqErr );

    CCLOSE (FLNO,'L');
    CCLOSE (WKNO,'N');

    IF ERRORNO>0 THEN MainExit ( True, SeqErr );
  END;

  PROCEDURE SORTCHECK;
  VAR
    SUB : INTEGER;
  BEGIN
    FOR SUB:=1 TO 4 DO
      BEGIN
	IF SORTITEM^[SUB]>0 THEN
	  IF SORTITEM^[SUB]=999 THEN SORTTRUNC^[SUB]:=2
	  ELSE
	    IF (SORTTRUNC^[SUB]=0)
	    OR (SORTTRUNC^[SUB]>DB1.DBITEMS[SORTITEM^[SUB]].DBISIZE) THEN
	      BEGIN
		CASE DB1.DBITEMS[SORTITEM^[SUB]].DBITYPE[0] OF
		  'C'		     : SORTTRUNC^[SUB]:=2;
		  'D','E','F'	     : SORTTRUNC^[SUB]:=2;
		  'K'		     : SORTTRUNC^[SUB]:=6;
		  'L','M','*','%'    : SORTTRUNC^[SUB]:=10;
		  'N','T'	     : SORTTRUNC^[SUB]:=2;
		  'X','Y','&','?'    : SORTTRUNC^[SUB]:=DB1.DBITEMS[SORTITEM^[SUB]].DBISIZE;
		END;
	      END;
      END;
  END;


Begin
  New ( SeqRec );
  FillChar ( SeqRec^, SizeOf ( SeqRec^), Chr(0));
  New ( SortItem );
  FillChar ( SortItem^, SizeOf ( SortItem^), Chr(0));
  New ( SortTrunc );
  FillChar ( SortTrunc^, SizeOf ( SortTrunc^), Chr(0));
  New ( Ascend );
  FillChar ( Ascend^, SizeOf ( Ascend^), Chr(0));
  {
  For DCounter := 1 To MaxBlock Do
      New ( WorkRef[DCounter] );
  For DCounter := 1 To MaxBlock Do
      FillChar ( WorkRef[DCounter]^, SizeOf(WorkRef[DCounter]^),Chr(0));
  }
  New ( WorkRec );
  FillChar ( WorkRec^, SizeOf ( WorkRec^), Chr(0));
  New ( Sorts );
  FillChar ( Sorts^, SizeOf ( Sorts^), Chr(0));
  New ( SortRec );
  FillChar ( SortRec^, SizeOf ( SortRec^), Chr(0));
  For DCounter := 1 To LargerOf2 Do
      New ( SortVal[DCounter] );
  For DCounter := 1 To LargerOf2 Do
      FillChar ( SortVal[DCounter]^, SizeOf(SortVal[DCounter]^),Chr(0));
  New ( RepHighVal );
  FillChar ( RepHighVal^, SizeOf ( RepHighVal^), Chr(0));
  New ( RepLowVal );
  FillChar ( RepLowVal^, SizeOf ( RepLowVal^), Chr(0));
  New ( WorkKey );
  FillChar ( WorkKey^, SizeOf ( WorkKey^), Chr(0));

  SETDB(SortDb);

  CCLOSE   (WKNO,'N');
  CREWRITE (WKNO,MISCID);
  IF ERRORNO > 0 THEN MainExit ( True, SEQERR );

{-->>  SORTTOT:=DB1.DBRECHIGH;}
{-->>  IF SORTTOT=0 THEN SORTTOT:=1;}
{-->>  KEYPREC:=64;}
{-->>  SORTSZ :=KEYPREC-2;}
{-->>  IF SORTSZ <1 THEN SORTSZ:= 1;}
{-->>  IF SORTSZ>64 THEN SORTSZ:=64;}
  FOR Count:=1 TO 4 DO
    BEGIN
      SORTITEM ^[Count]:=0;
      SORTTRUNC^[count]:=0;
      ASCEND   ^[Count]:=TRUE;
    END;

{-->>  xC := 0;}
  SORTITEM^[1]:= FLD1;
  SORTITEM^[2]:= FLD2;
  SORTITEM^[3]:= FLD3;
  SORTITEM^[4]:= FLD4;
  ASCEND^[1]  := ASC1;
  ASCEND^[2]  := ASC2;
  ASCEND^[3]  := ASC3;
  ASCEND^[4]  := ASC4;
  SORTCHECK;

  STARTPROC;
  INPUTPROC;

  OUTPUTPROC;
  ENDPROC;
  MainExit ( False, ' ' );
End;

Begin

End.
