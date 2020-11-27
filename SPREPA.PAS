{

  File	    : SPREPA.PAS
  Unit	    : SPREPA
  Prefix    :
  Status    :

  DATE'S
  Started   :
  Finished  :

}

Unit SPREPA;

{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface

Procedure REP ( option, DataBase : Integer );

{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation

Uses
    NewClass,
    sortit,
    dialogs,
    SysUtils,
    RcsInv,        { contains form for report filters Invoice,Payment,Credit Note Listing }
    RcsList,       { contains form for report filters Account, Age Of Debt Listing }
    OPENFL,
    clears,
    DbCore,
    params,
    calcs,
    DBRPT,
    abortprg,
    filed,
    vars,
    types,
    Printers,
    Graphics,
    NomRpt,
    Accsdata;

Procedure REP ( Option, DataBase : Integer );
Const
  MAXC	  = 12;
  MAXANAL = 9999; // was 1000

Type
    TSortWork = Packed Array [1..512] Of ^Char;

Var
  ITEMCOL   : PACKED ARRAY[1..MAXC] OF INTEGER;
  AVALS	    : PACKED ARRAY[0..MAXANAL] OF LONG;
  ARECS	    : PACKED ARRAY[0..MAXANAL] OF INTEGER;
  AQty	    : PACKED ARRAY[0..MAXANAL] OF INTEGER;


  Date1,
  Date2     : ShortString{[8]};
  FROMDT    : INTEGER;
  TODT	    : INTEGER;
  FROMNOM   : INTEGER;
  TONOM	    : INTEGER;

  AUTORUN   : BOOLEAN;
  AUTOFIRST : BOOLEAN;
  REPITEMS  : PACKED ARRAY[1..MAXC] OF INTEGER;
  HEADING   : ShortString{[40]};
  FLNAME    : ShortString{[20]};
  ACT	    : INTEGER;
  AMTTOT    : LONG;
  TAXDTOT   : LONG;
  TOTRECS   : INTEGER;
  OKTOPRINT : BOOLEAN;
  NOHEADING : BOOLEAN;
  VERYFIRST : BOOLEAN;
  NUMBERONE : BOOLEAN;
  PAGENO    : INTEGER;
  NEXTCOL   : INTEGER;
  COLHIGH   : INTEGER;
  PLINE	    : ShortSTRING{[255]};
  NEXTLINE  : INTEGER;
  INCLANAL,
  MinimumBalance : BOOLEAN; // TGM AB - Minimum balance for Age of Debt
  DBNO	    : INTEGER;
  ACCTOT    : INTEGER;
  AGETOTS   : PACKED ARRAY[1..4] OF LONG;
  ACCBBF    : LONG;
  ACCTUR    : LONG;
  ACCBAL    : LONG;
  GOODSAMT  : ARRAY[0..10] OF Double{LONG};
  TAXAMT    : ARRAY[0..10] OF Double{LONG};
  TXTOTS    : ARRAY[1..4,1..3] OF Double{LONG};
  ACCMIN    : INTEGER;
  ACCMAX    : INTEGER;
  press	    : char;
  curr_time : ShortString;

  area_from,			{ AreaCode Filter }
  area_to,
  fromanl,
  toanl	    : integer;		{ analysis code report range include controls }

  sortpos,
  sortblk	: Integer;
  sortwork	: Packed Array [1..512] Of Char;
  page_break,
  SortRep	: Boolean;	    { true if using area codes }
  store_area,
  head_area	: Integer;	    { Area Code used for heading }
  TaxAudit      : Boolean;

PROCEDURE REPORTRUN; FORWARD;
PROCEDURE repheadings; FORWARD;

   Procedure next_sort_rec ( var update_read_no : SmallInt );
      Begin
	 if sortpos + 2 > 513 then
	    Begin
	       sortblk := sortblk + 1;
	       sortpos := 1;
//	       if cread ( 10, 1, sortblk ) < 1 then AbortProgram ( seqerr );
	       if cread ( SortFileNo, 1, sortblk ) < 1 then AbortProgram ( seqerr );
	       move ( cblocks[1], sortwork[1], 512 );
	    End;
	 move ( sortwork[sortpos], update_read_no, 2 );

	 sortpos := sortpos + 2;
	 if update_read_no > 30000 then update_read_no := 0;
      End;

   Procedure sort_file ( db : Integer; Var next_Read : SmallInt;
			 sort_fld, start_from : Integer;
			 sort_asc : Boolean );
      Begin
	 tx_start := schrecf;
	 tx_end	  := schrect;
	 SortFile ( db, 10, 9, sort_fld, 999, 0, 0, sort_asc, TRUE, TRUE, TRUE,
                    start_from, 0, false, false );

	 cclose ( 10, 'N' );
	 creset ( 10, sortid );
	 if errorno > 0 then AbortProgram ( seqerr );

	 sortpos := 512;
	 sortblk := -1;

	 { get the next record to read }
	 next_sort_rec ( next_read );
      End;

  PROCEDURE ERR;
  BEGIN							{ begin ERR }
{    DISKERROR;}
    EXIT;
  END;							{ end ERR }

  (*
  PROCEDURE SKIPLINES(NOLINES: INTEGER);
  VAR
    X: INTEGER;
  BEGIN							{ begin SKIPLINES }

    IF NOLINES < 1 THEN EXIT;
    if ( Device[1] in ['C','F','P','S'] ) then
      begin
	for x := 1 to NOLINES do
	  SendLine ( null );
	if esckey then
	  exit;

	linecount := linecount + nolines;
      end;

  END;							{ end SKIPLINES }
  *)

  PROCEDURE BUILDLINE(COL: INTEGER; STRVAL: ShortString);
  BEGIN							{ begin BUILDLINE }
    IF COL = 0 THEN COL := NEXTCOL;
    IF STRVAL = '' THEN EXIT;
    IF COL + LENGTH(STRVAL) - 1 IN [1..255] THEN
      MOVE (STRVAL[1],PLINE[COL],LENGTH(STRVAL));
    NEXTCOL := COL + LENGTH(STRVAL);
    IF NEXTCOL > COLHIGH THEN COLHIGH := NEXTCOL;
  END;							{ end BUILDLINE }

  PROCEDURE BUILDITEM(ITEM,COL: INTEGER);
  BEGIN							{ begin BUILDITEM }
    IF COL=0 THEN COL:=NEXTCOL;
    IF CURRSIZE<1 THEN EXIT;
    IF ITEM IN [1..MAXITEMS] THEN
      IF DB1.DBITEMS[ITEM].DBITYPE[0] IN ['L','*','M'] THEN
	BEGIN
          DoubleToStr(CurrLong, CurrStr,'%f', True, True, 12, True);
	  {LONGSTR(CURRLONG,CURRSTR,'L');
	  FILLCHAR(CURRDISP[1],64,SPACE1);}
	  MOVE(CURRSTR[1],CURRDISP[1],LENGTH(CURRSTR));
	END;
    IF COL+CURRSIZE < 257 THEN
      MOVE(CURRDISP[1],PLINE[COL],CURRSIZE);
    NEXTCOL:=COL+CURRSIZE;
    IF NEXTCOL>COLHIGH THEN COLHIGH:=NEXTCOL;
  END;							 { end BUILDITEM }

  PROCEDURE OUTPUTLINE;
  VAR

    X: INTEGER;
  BEGIN							 { begin OUTPUTLINE }

    (*
    IF Device = 'S' THEN
      BEGIN
	IF LINECOUNT>20 THEN
	  BEGIN
	    CLEARFROM (24);
	    DIS ( 1,24,'PRESS ENTER FOR MORE DETAILS');
	    no_func_key;
	    REC (31,24,0,NULL,0,0,0,0,0);
	    IF ESCKEY THEN EXIT(OUTPUTLINE);
	    CLEARFROM(6);
	    BETALINE;
	    LINECOUNT:=6;
	  END;
	DIS (1,LINECOUNT,COPY(PLINE,1,80));
	LINECOUNT:=LINECOUNT+1;
	EXIT(OUTPUTLINE);
      END;
    *)

    X := COLHIGH;
    IF X > RFarmGate.PLINEWIDTH[1] THEN X := RFarmGate.PLINEWIDTH[1];
    IF X < 1 THEN X := 1;

    if Device = 'S' then		   (* set X to page of 132 wide *)
      X := 132;

    SendLine ( COPY ( PLINE, 1, X ));
(* change REP *)
    IF ESCKEY THEN EXIT;

    {
    LINECOUNT := LINECOUNT + 1;
    }

    COLHIGH:=1;
    NEXTCOL:=1;

  END;							  { end OUTPUTLINE }

  PROCEDURE SKIPSCREEN(LINES: INTEGER);
  BEGIN							  { begin SKIPSCREEN }
    LINECOUNT := LINECOUNT + LINES;
  END;							  { end SKIPSCREEN }

  PROCEDURE BLANKLINE;
  VAR
    X : INTEGER;
  BEGIN							  { begin BLANKLINE }
    if Device <> 'S' then
      begin
	PLINE := NULL;
	FOR X := 1 TO 6 DO PLINE := CONCAT(PLINE,SPACE40);
	PLINE := CONCAT(PLINE,COPY(SPACE40,1,15));
	COLHIGH := 1;
      end;
    {
    else
      FP_new_line ( PLINE );
    }
  End;							  { end BLANKLINE }

  (*
  PROCEDURE DASHLINE;
  var
    ans : char;
  BEGIN							  { begin DASHLINE }

    if Device <> 'S' then
      begin
	BLANKLINE;
	FILLCHAR(PLINE[1],255,'-');
	COLHIGH:=255;
	OUTPUTLINE;

	BLANKLINE;
      end;
    {
    else
      if Device = 'S' then
	begin
	  blankline;
	  FP_dashes ( PLINE );
	  outputline;
	  blankline;
	end;
    }
  END;							  { end DASHLINE }
  *)

  PROCEDURE REPHEADINGS;
  VAR
    SUB	    : INTEGER;
    WORKSTR : ShortString {80};
    ITEM    : INTEGER;
    Page_Heading : ShortString;

  BEGIN							  { begin REPHEADINGS }
    If Device = 'P' Then
       Printer.Canvas.Font.Style := [fsBold];
    IF ( Device[1] in ['C','F','P','S'] ) THEN

      BEGIN
        // Use VeryFirst for Sales/Purchase reports
        // Use ACT = 11 and PROG = Supprep for the IRL VAT Report Purchase side to
        // make sure the program throws a page after printing.
        IF ( NOT VERYFIRST ) Or (( ACT = 11 ) And ( PROG = SUPPREP )) THEN
	  If Device = 'P' Then
	     Printer.NewPage
          Else
	      SKIPLINES(RFarmGate.PLINESPAGE[1]-LINECOUNT);

	LINECOUNT := 1;
	RepDash;
	VERYFIRST:=FALSE;
	PAGENO:=PAGENO+1;
	BLANKLINE;
	BUILDLINE(1,Cash1.XCOMPANY);
	IF Cash1.XCOMPANY<>NULL THEN BUILDLINE(0,'/');
	IF AUTOPROG=10 THEN
	  CASE PROG OF
	    CUSTREP : BUILDLINE(0,'SPECIAL REPORT-12');
	    SUPPREP : BUILDLINE(0,'SPECIAL REPORT-13');
	  END
	ELSE
	IF AUTOPROG=11 THEN
	  CASE PROG OF
	    CUSTREP : BUILDLINE(0,'SPECIAL REPORT-8');
	    SUPPREP : BUILDLINE(0,'SPECIAL REPORT-8');
	  END
	ELSE
	  if act = 13 then
	    Buildline ( 0, 'ANALYSIS REPORT-1' )
	  else
	    BEGIN
	      IF PROG=CUSTREP THEN BUILDLINE(0,'CUSTOMER REPORT-'{'SALES REPORT-'});
	      IF PROG=SUPPREP THEN BUILDLINE(0,'SUPPLIER REPORT-'{'PURCHASE REPORT-'});
	      STR(ACT,WORKSTR);
	      BUILDLINE(0,WORKSTR);
	    END;

	if act = 13 then
	  buildline ( (( RFarmGate.plinewidth[1]-length(heading)) div 2 ), heading )
	else
	  Begin
	    BUILDLINE(0,'     ');
	    BUILDLINE(0,HEADING);
	  End;

	buildline ( RFarmGate.plinewidth[1]-30{28}, curr_time );
	BUILDLINE(RFarmGate.PLINEWIDTH[1]-21,SPACE1);
//	BUILDLINE(RFarmGate.PLINEWIDTH[1]-20,Cash1.XDATE);
	BUILDLINE(RFarmGate.PLINEWIDTH[1]-20,REPXDATE);
	BUILDLINE(RFarmGate.PLINEWIDTH[1]-10,'PAGE ');
	STR(PAGENO,WORKSTR);
	BUILDLINE(0,WORKSTR);
	OUTPUTLINE;
	BLANKLINE;
        If ( PROG = CUSTREP ) And ( ACT = 11 ) Or
           ( PROG = SUPPREP ) And ( ACT = 11 ) Then
           Begin
              Page_Heading := Null;
              Str ( schrecf, WorkStr );
              Page_heading := concat ( 'TRANSACTION ', WorkStr, ' TO ' );
              Str ( schrect, WorkStr );
              Page_heading := concat ( Page_Heading , WorkStr );
              BuildLine ( Trunc (( RFarmGate.plinewidth[1] - length ( page_heading )) / 2 ),
				Page_heading );
           End;
	OUTPUTLINE;
	BLANKLINE;
        If ( PROG = CUSTREP ) And ( ACT = 11 ) Or
           ( PROG = SUPPREP ) And ( ACT = 11 ) Then
	  If (( date1 <> null ) and ( date2 <> null )) then
	     buildline ( trunc (((RFarmGate.plinewidth[1] - 30) DIV 2)),
			   concat ( 'PERIOD RANGE ',date1,' TO ',date2 ));


{	BUILDLINE(1,SYSNAME);

	if autoprog = 11 then
	  if (( date1 <> null ) and ( date2 <> null )) then
	    buildline ( trunc (((plinewidth[1] - 30) DIV 2)),
			   concat ( 'PERIOD RANGE ',date1,' TO ',date2 ));
}
	If ( dbno In [SlFile,PlFile] {1 } ) And ( act In [1,2] ) And ( SortRep ) Then
	   Begin
	      setdb ( dbno );
	      str ( head_area, workstr );
	      buildline ( 58, Concat ( 'AREA CODE : ',workstr ));
	   End
	Else
	   If ( act = 2 ) then
	      setdb ( dbno );

      BUILDLINE(1,SYSNAME);
      buildline ( RFarmGate.plinewidth[1]-length(verno), verno ); 
      OUTPUTLINE;
      BLANKLINE;
      END;
    RepDash;
    BLANKLINE;
    IF NOHEADING THEN Exit;

    if act = 13 then
      buildline ( 3, 'CODE' )
    else
      IF ACT < 5 THEN
	BUILDLINE(1,'ACCOUNT')
      else
	IF ACT > 4 THEN
	  BUILDLINE(1,'RECORD');

    IF ACT=10 THEN
      BEGIN

	if RCSList.ProductReport then BUILDLINE(1,'Product Code and Name')
           else BUILDLINE(1,'Analysis Code and Name');
	WORKSTR:='Quantity';
	BUILDLINE( 28,WORKSTR);        
	WORKSTR:='TURNOVER';
	BUILDLINE( 40,WORKSTR);
	BUILDLINE( 57,'RECORDS	   % OF TOTAL');
      END;
    if act = 13 then
      Begin
	buildline ( 16, 'NAME' );
	buildline ( 55, 'NO OF UNITS' );
	buildline ( 81, 'VALUE' );
      End
    else
      IF ACT <> 10 THEN
	FOR SUB:=1 TO MAXC DO
	  Begin
	    BEGIN
	      ITEM := REPITEMS[SUB];
	      IF ITEM IN [1..102] THEN
		BEGIN
		  IF ITEM = 102 THEN WORKSTR:='NAME';
		  if item = 102 then
		    if (( Prog in [supprep, custrep] ) and ( act in [5..7] )) then
		      Begin
			if prog = supprep then
			  workstr := 'SUPPLIER'
			else
			  workstr := 'CUSTOMER';
			buildline ( itemcol[sub], Workstr );
		      End;
		  IF ITEM IN [1..MAXITEMS] THEN
		    BEGIN
		      WORKSTR:=DB1.DBITEMS[ITEM].DBINAME;
                      // age of debt report change by GM 21/06/04
                      If WorkStr = 'AGE-CURR' then begin
                         case CustSuppListing.AgeByCombo.ItemIndex of
                              0: WorkStr := 'Current ';
                              1: WorkStr := '0-1Mth';
                              2: WorkStr := '0-2Mths';
                              3: WorkStr := '0-5Mths';
                              4: WorkStr := '0-8Mths';
                              5: WorkStr := '0-11Mths';
                         end;
                      end;
                      If WorkStr = 'AGE-1' then begin
                         case CustSuppListing.AgeByCombo.ItemIndex of
                              0: WorkStr := '1Mth';
                              1: WorkStr := '2-3Mths';
                              2: WorkStr := '3-5Mths';
                              3: WorkStr := '6-11Mths';
                              4: WorkStr := '9-17Mths';
                              5: WorkStr := '12-23Mths';
                         end;
                      end;
                      If WorkStr = 'AGE-2' then begin
                         case CustSuppListing.AgeByCombo.ItemIndex of
                              0: WorkStr := '2Mth';
                              1: WorkStr := '4-5Mths';
                              2: WorkStr := '6-8Mths';
                              3: WorkStr := '12-17Mths';
                              4: WorkStr := '18-27Mths';
                              5: WorkStr := '24-35Mths';
                          end;
                      end;
                     If WorkStr = 'AGE-3' then begin
                         case CustSuppListing.AgeByCombo.ItemIndex of
                              0: WorkStr := '3+Mths';
                              1: WorkStr := '6+Mths';
                              2: WorkStr := '9+Mths';
                              3: WorkStr := '18+Mths';
                              4: WorkStr := '28+Mths';
                              5: WorkStr := '36+Mths';
                          end;

                      end;


		      IF DB1.DBITEMS[ITEM].DBITYPE[0] IN ['D','N','L','M','*','%'] THEN
			BEGIN
			  REPEAT
			    IF LENGTH(WORKSTR)<DB1.DBITEMS[ITEM].DBISIZE THEN
			      WORKSTR:=CONCAT(SPACE1,WORKSTR);
			  UNTIL NOT(LENGTH(WORKSTR)<DB1.DBITEMS[ITEM].DBISIZE);
			END;
		      IF DB1.DBITEMS[ITEM].DBITYPE[0] IN ['L','M','*'] THEN
			WORKSTR:=COPY(WORKSTR,4,LENGTH(WORKSTR)-3);
		    END;
		  BUILDLINE(ITEMCOL[SUB],WORKSTR);
		  BUILDLINE(ITEMCOL[SUB]-1,SPACE1);
		END;
	    END;

	  End;

    OUTPUTLINE;

    RepDash;
    SKIPLINES(1);
    If Device = 'P' Then
       Printer.Canvas.Font.Style := [];
  END;							{ end REPHEADINGS }

  PROCEDURE ZEROTOT;
  VAR
    X,Y : INTEGER;
  BEGIN							{ begin ZEROTOT }
    FOR X:=1 TO 4 DO AGETOTS[X]:=0;
    FOR X:=1 TO 4 DO
      FOR Y:=1 TO 3 DO
	TXTOTS[X,Y]:=0;
    ACCTOT:=0;

    ACCBBF:=0;
    ACCTUR:=0;
    ACCBAL:=0;
    FOR X:=0 TO 10 DO
      BEGIN
	GOODSAMT[X]:=0;
	TAXAMT[X]:=0;
      END;
  END;							{ end ZEROTOT }

  PROCEDURE ADDACCTOTS;
  VAR
    SUB : INTEGER;
  BEGIN							{ begin ADDACCTOTS }
    GETITEM(DBNO,6);
    ACCBBF:=ACCBBF+CURRLONG;
    GETITEM(DBNO,7);
    ACCBAL:=ACCBAL+CURRLONG;
    GETITEM(DBNO,8);
    ACCTUR:=ACCTUR+CURRLONG;
    FOR SUB:=1 TO 4 DO
      BEGIN
	GETITEM(DBNO,8+SUB);
	AGETOTS[SUB]:=AGETOTS[SUB]+CURRLONG;
      END;
  END;							{ end ADDACCTOTS }

  PROCEDURE TOTALRECS;
  BEGIN							{ begin TOTALRECS }
    TOTRECS:=TOTRECS+1;
    IF ACT=2 THEN ADDACCTOTS;
    IF ACT IN [5..7] THEN
      BEGIN
	GETITEM(TxFile,1);
	IF CURRINT<>9 THEN
	  BEGIN
	    GETITEM(TxFile,9);
	    AMTTOT:=AMTTOT+CURRLONG;
	    GETITEM(TxFile,11);
	    TAXDTOT:=TAXDTOT+CURRLONG;
	  END;
      END;
  END;							 { end TOTALRECS }

  PROCEDURE PRINTTOTS;
  VAR
    orig_area,
    X	    : INTEGER;
    ST	    : ShortSTRING;
  BEGIN							 { begin PRINTTOTS }

    IF ( Device[1] in ['C','F','P','S'] ) THEN

      BEGIN

	NOHEADING := TRUE;
	IF LINECOUNT + 20 > RFarmGate.PLINESPAGE[1] THEN
	  If ( act = 2 ) And ( page_break ) Then
	    Begin
	      orig_area := head_area;
	      head_area := store_area;
	      repheadings;
	      head_area := orig_area;
	    End
	  Else
	    REPHEADINGS
	ELSE
	  SKIPLINES (RFarmGate.PLINESPAGE[1] - LINECOUNT - 20);
	FOR X := 1 TO 2 DO
	  BEGIN
	    SendLine (NULL);
	    (* change REP *)
	    IF ESCKEY THEN EXIT;
	  END;
	IF ACT IN [5..7] THEN
	  BEGIN
//tgm
	    SendLine ('TRANSACTION STATUS ... E=EDITED ... R=REVERSAL');
	    IF ESCKEY THEN EXIT;
	    SendLine (NULL);
	    IF ESCKEY THEN EXIT;
	    SendLine (NULL);
	    IF ESCKEY THEN EXIT;
	    LINECOUNT:=LINECOUNT+3;
	  END;
	SendLine ('TOTALS ... ');
	IF ESCKEY THEN EXIT;
	SendLine (NULL);
	IF ESCKEY THEN EXIT;
	STR (TOTRECS,ST);
	SendLine (CONCAT('NUMBER OF RECORDS ... ',ST));
	IF ESCKEY THEN EXIT;
	IF ACT=2 THEN
	  BEGIN
	    SendLine (NULL);
	    IF ESCKEY THEN EXIT;
	    LONGSTR(ACCBAL,ST,'L');
	    SendLine (CONCAT('TOTAL BALANCE ...... ',ST));
	    IF ESCKEY THEN EXIT;
	    LONGSTR(AGETOTS[1],ST,'L');
	    SendLine (CONCAT('AGE-CURRENT ........ ',ST));
	    IF ESCKEY THEN EXIT;
	    LONGSTR(AGETOTS[2],ST,'L');
	    SendLine (CONCAT('   -1 MONTH ........ ',ST));
	    IF ESCKEY THEN EXIT;
	    LONGSTR(AGETOTS[3],ST,'L');
	    SendLine (CONCAT('   -2 MONTH ........ ',ST));
	    IF ESCKEY THEN EXIT;
	    LONGSTR(AGETOTS[4],ST,'L');
	    SendLine (CONCAT('   -3 MTHS/OVER .. ',ST));
	    IF ESCKEY THEN EXIT;
	    LONGSTR(ACCTUR,ST,'L');
	    SendLine (CONCAT('TURNOVER ........... ',ST));
	    IF ESCKEY THEN EXIT;

	    LINECOUNT:=LINECOUNT+7;

	  END;
	IF ACT IN [5..7] THEN
	  BEGIN
	    SendLine (NULL);
	    IF ESCKEY THEN EXIT;
	    LONGSTR(AMTTOT,ST,'L');
	    SendLine (CONCAT('AMOUNT TOTAL ....... ',ST));
	    IF ESCKEY THEN EXIT;
	    LONGSTR(TAXDTOT,ST,'L');
	    SendLine (CONCAT('VAT / DISCOUNT ..... ',ST));
	    IF ESCKEY THEN EXIT;
	    LONGSTR(AMTTOT+TAXDTOT,ST,'L');
	    SendLine (CONCAT('GRAND TOTAL ........ ',ST));
	    IF ESCKEY THEN EXIT;

	    LINECOUNT:=LINECOUNT+4;

	  END;
	SendLine (NULL);
	IF ESCKEY THEN EXIT;
	SendLine (NULL);
	IF ESCKEY THEN EXIT;

	LINECOUNT:=LINECOUNT+7;

      END;
    (*
    ELSE
      BEGIN
	CLEARFROM(24);
	DIS ( 1,24,'PRESS ENTER FOR TOTALS ');
	no_func_key;
	REC (25,24,0,NULL,0,0,0,0,0,0);
	IF ESCKEY THEN EXIT;
	BETACLEAR;
	DIS  ( 1,6,'NUMBER OF RECORDS ..... ');
	DISI (25,6,TOTRECS,1);
	IF ACT=2 THEN
	  BEGIN
	    LONGSTR(ACCBAL,ST,'L');
	    DIS	 ( 1, 9,'TOTAL BALANCE ......... ');
	    DIS	 (25, 9,ST);
	    LONGSTR(AGETOTS[1],ST,'L');
	    DIS	 ( 1,11,'AGE-CURRENT ........... ');
	    DIS	 (25,11,ST);
	    LONGSTR(AGETOTS[2],ST,'L');
	    DIS	 ( 1,12,'   -1 MONTH ........... ');
	    DIS	 (25,12,ST);
	    LONGSTR(AGETOTS[3],ST,'L');
	    DIS	 ( 1,13,'   -2 MONTH ........... ');
	    DIS	 (25,13,ST);
	    LONGSTR(AGETOTS[4],ST,'L');
	    DIS	 ( 1,14,'   -3 MONTHS/OVER ..... ');
	    DIS	 (25,14,ST);
	    LONGSTR(ACCTUR,ST,'L');
	    DIS	 ( 1,16,'TURNOVER .............. ');
	    DIS	 (25,16,ST);
	  END;
	IF ACT IN [5..7] THEN
	  BEGIN
	    LONGSTR(AMTTOT,ST,'L');
	    DIS	 ( 1, 9,'AMOUNT TOTAL .......... ');
	    DIS	 (25, 9,ST);
	    LONGSTR(TAXDTOT,ST,'L');
	    DIS	 ( 1,11,'VAT/DISCOUNT .......... ');
	    DIS	 (25,11,ST);
	    LONGSTR(AMTTOT+TAXDTOT,ST,'L');
	    DIS	 ( 1,13,'GRAND TOTAL ........... ');
	    DIS	 (25,13,ST);
	  END;

	LINECOUNT:=18;

      END;
      *)

  END;							{ end PRINTTOTS }

  PROCEDURE PRINTITEM(REPITEM: INTEGER);
  VAR
    DITEM : INTEGER;
    WV	  : LONG;
    ST	  : ShortString;
  BEGIN							{ begin PRINTITEM }
    DITEM:=REPITEMS[REPITEM];
    IF DITEM=102 THEN
      BEGIN
	GETITEM(TxFile,3);
	IF CURRINT>0 THEN
	  BEGIN
	    READREC(DataBase,CURRINT);
	    IF ERRORNO > 0 THEN ERR;
	    IF RECACTIVE(DataBase) THEN
	      BEGIN
		GETITEM(DataBase,1);
		BUILDITEM(2,ITEMCOL[REPITEM]);
	      END;
	    SETDB(TxFile);
	  END;
      END;
    IF NOT(DITEM IN [1..MAXITEMS]) THEN EXIT;
    IF DB1.DBITEMS[DITEM].DBINAME=NULL THEN EXIT;
    IF (DITEM=13) AND (DBNO=TxFile { 2 }) THEN
      BEGIN
	GETITEM(DataBase{TxFile},{1,}9);
	WV:=CURRLONG;
	GETITEM(DataBase{TxFile},{1,}11);
	CURRLONG:=CURRLONG+WV;
      END
    ELSE
      GETITEM(DBNO,DITEM);
    IF (ACT > 4) AND (DITEM=1) THEN
      BEGIN
	STR (CURRINT,ST);
	CASE CURRINT OF
	   1 : ST:='SL-INV';
	   2 : ST:='SL-PAY';
	   3 : ST:='SL-CRN';
	   5 : ST:='PL-INV';
	   6 : ST:='PL-PAY';
	   7 : ST:='PL-CRN';
	END;
	BUILDLINE(ITEMCOL[REPITEM],ST);
      END
    ELSE
      BUILDITEM(DITEM,ITEMCOL[REPITEM]);
  END;							{ end PRINTITEM }

  PROCEDURE PRINTOUT;
  VAR
    SUB	       : INTEGER;
    LINESSPARE : INTEGER;
    PR	       : BOOLEAN;
    WORKSTR    : ShortString {80};
    orig_area  : Integer;
  BEGIN							{ begin PRINTOUT }

    LINESSPARE:=4;

    IF LINECOUNT + LINESSPARE > RFarmGate.PLINESPAGE[1] Then
       REPHEADINGS;
    
    If ( act In [1,2] ) And ( page_break ) Then
	Begin
	   IF LINECOUNT + LINESSPARE > RFarmGate.PLINESPAGE[1] Then
	     Begin
		orig_area := head_area;
		head_area := store_area;
		repheadings;
		head_area := orig_area;
	     End;
	   printtots;
	   noheading := False;
	   repheadings;
	   zerotot;
	   totrecs := 0;
	End;
    
    BLANKLINE;
    STR(CURRREC[DBNO],WORKSTR);
    WHILE LENGTH(WORKSTR)<5 DO WORKSTR:=CONCAT(SPACE1,WORKSTR);
    BUILDLINE(2,WORKSTR);
    IF ACT IN [5..7] THEN
      BEGIN
	GETITEM(TxFile,28);
	BUILDLINE(1,CURRSTR);
      END;
    FOR SUB:=1 TO MAXC DO
      BEGIN
	PR:=TRUE;
	IF (ACT IN [5..7]) AND (REPITEMS[SUB] IN [8,10,12,18,19]) THEN
	  BEGIN
	    GETITEM(TxFile,1);
	    IF CURRINT IN [1,3,4,5,7,8] THEN PR:=FALSE;
	  END;
	IF (ACT IN [5..7]) AND NOT(REPITEMS[SUB] IN [5,8,9,10,11,12,18,19]) THEN
	  BEGIN
	    GETITEM(TxFile,1);
	    IF CURRINT=9 THEN PR:=FALSE;
	  END;
	IF PR THEN PRINTITEM(SUB);
      END;
    TOTALRECS;
    IF ACT IN [5,7] THEN
      BEGIN
	GETITEM(TxFile,1);
	IF (CURRINT IN [1..8]) AND NOT NUMBERONE THEN
	  IF INCLANAL THEN
	    skiplines (1);

      END;
    OUTPUTLINE;

    NUMBERONE:=FALSE;
  END;							{ end PRINTOUT }

  PROCEDURE SKIP(LINES: INTEGER);
  VAR
    X : INTEGER;
  BEGIN							{ begin SKIP }

    LINECOUNT := LINECOUNT + LINES;

    FOR X := 1 TO LINES DO

      IF ( Device[1] in ['C','F','P','S'] ) THEN
	BEGIN	      
	  (*
	  LINECOUNT := LINECOUNT + 1;
	  *)
	  SendLine (NULL);	  
(* change REP *)
	  IF ESCKEY THEN EXIT ;
	END ;

  END;							 { end SKIP }

  PROCEDURE OP(LINENO: INTEGER);
  BEGIN							 { begin OP }

    (*
    IF Device = 'S' THEN
      DIS(1,LINENO,PLINE)
    ELSE
      BEGIN
    *)

    SendLine (PLINE);
(* change REP *)
    IF ESCKEY THEN EXIT ;

      (*  END;	*)

    LINECOUNT := LINECOUNT + 1;
  END;							  { end OP }

  PROCEDURE CUSTTOTALS;
  VAR
    ST	: ShortSTRING;
  BEGIN							  { begin CUSTTOTALS }

    (*
    IF Device = 'S' THEN
      BEGIN
	BETACLEAR;
      END;
    *)

    NOHEADING := TRUE;

    IF ( Device[1] in ['C','F','P','S'] ) THEN
      REPHEADINGS;

    SKIP(3);
    STR(ACCTOT,ST);
    PLINE := CONCAT('NUMBER OF ACCOUNTS ...... ',ST);
    OP(4);
    SKIP(2);
    LONGSTR(ACCBBF,ST,'L');
    PLINE:=CONCAT('TOTAL BALANCE B/F ....... ',ST);
    OP(7);
    SKIP(2);
    LONGSTR(ACCBAL,ST,'L');
    PLINE:=CONCAT('BALANCES OUTSTANDING .... ',ST);
    OP(10);
    SKIP(1);
    LONGSTR(AGETOTS[1],ST,'L');
    PLINE:=CONCAT('	CURRENT MONTH ...... ',ST);
    OP(12);
    SKIP(0);
    LONGSTR(AGETOTS[2],ST,'L');
    PLINE:=CONCAT('	MONTH - 1 .......... ',ST);
    OP(13);
    SKIP(0);
    LONGSTR(AGETOTS[3],ST,'L');
    PLINE:=CONCAT('	MONTH - 2 .......... ',ST);
    OP(14);
    SKIP(0);
    LONGSTR(AGETOTS[4],ST,'L');
    PLINE:=CONCAT('	MONTH - 3 .......... ',ST);
    OP(15);
    SKIP(2);
    LONGSTR(ACCTUR,ST,'L');
    PLINE:=CONCAT('ACCUMULATED TURNOVER .... ',ST);
    OP(18);
    SKIP(2);
    IF ( Device[1] in ['C','F','P'] ) THEN
       SKIPLINES(RFarmGate.PLINESPAGE[1]-LINECOUNT);
END;						       { end CUSTTOTALS }

  PROCEDURE CUSTSUMMARY;
  VAR
    RECNO  : INTEGER;
  BEGIN						   { begin CUSTSUMMARY }
    SETDB(DBNO);
    ZEROTOT;
{
    STR (DB1.DBRECHIGH,TOPREC);
    DIS ( 1,24,'PROCESSING ACCOUNT NUMBER ');
    DIS (32,24,CONCAT('(OF ',TOPREC,')'));
}
    FOR RECNO := SCHRECF TO SCHRECT DO
      BEGIN
{
	DISI (27,24,RECNO,1);
}
	READREC(DBNO,RECNO);
	IF ERRORNO > 0 THEN ERR;
	IF RECACTIVE(DBNO) THEN
	  BEGIN
	    ACCTOT:=ACCTOT+1;
	    ADDACCTOTS;
	  END;
      END;

    (*
    IF Device = 'S' THEN
      BEGIN
	CLEARFROM (24);
	DIS ( 1,24,'PRESS ENTER FOR TOTALS');
	no_func_key;
	REC (25,24,0,NULL,0,0,0,0,0);
	IF ESCKEY THEN EXIT(CUSTSUMMARY);
      END;
     *)

    CUSTTOTALS;
  END;							{ end CUSTSUMMARY }

  { 14/11/94 - M. Cummins.
    Found that if a VAT code was set up ( other than the first ) at 0.00 rate
    the system didn't write a transaction for it, so when the VAT report was
    the Net total for this rate was not being produced.	 The following cahnges
    were made.
    if the txt ( tx-type ) was 9 then
      check the vat code ( item 10 ).
      if code is not code 0 ( first on table ) and the rate is 0.00 then
	store the tax table pos in last_sub.
	store amt
	set type9_active to true.
    end-if.

    if txt <> 0 then
      check last_sub in 1 to 9 and type9_active is true then
	add the net_amt to goodsamt[last_sub]
	reset net_amt to 0
	  "   last_sub to 99
	  "   type9_active to false.
    end-if.

  }
  PROCEDURE TRANSSUMMARY;
  VAR
    last_sub	 : integer;	{ holds the last records vat table position }
    net_amt	 : Double;	{ holds the last records Net total }
    type9_active : boolean;	{ set to true if last records was tx-type 9 }
    RECNO        : INTEGER;
    TXTORIG      : INTEGER;
    TXT	         : INTEGER;
    TAXSUB	 : INTEGER;
    CurrDbl      : Double;

    PROCEDURE XYZ;
    VAR
      X	       : INTEGER;
      TESTCODE : ShortString{[10]};
      AMT      : LONG;
      TAX      : LONG;
      SALESTAX : BOOLEAN;
      PURCHTAX : BOOLEAN;

    BEGIN						 { begin XYZ }
      GETITEM(TxFile,23);
      TXTORIG:=CURRINT;
      GETITEM(TxFile,9);
      AMT:=CURRLONG;
      GETITEM(TxFile,11);
      TAX:=CURRLONG;
      IF TXT=10 THEN
	BEGIN
	  SALESTAX:=TRUE;
	  PURCHTAX:=FALSE;
	END
      ELSE
	BEGIN
	  SALESTAX:=((TXTORIG IN [1,2,4,11,12]) AND (AMT>=0))
		OR  ((TXTORIG IN [3	     ]) AND (AMT<=0))
		OR  ((TXTORIG IN [5,6,8,15,16]) AND (AMT< 0))
		OR  ((TXTORIG IN [7	     ]) AND (AMT> 0));
	  PURCHTAX:=((TXTORIG IN [5,6,8,15,16]) AND (AMT>=0))
		OR  ((TXTORIG IN [7	     ]) AND (AMT<=0))
		OR  ((TXTORIG IN [1,2,4,11,12]) AND (AMT< 0))
		OR  ((TXTORIG IN [3	     ]) AND (AMT> 0));
	END;
      GETITEM (TxFile,8);
      {IF CURRINT IN [XNOMPRVINC,XNOMPRVEXP] THEN}
      IF ( CURRINT >= Cash1.XNOMPRVINC ) And
         ( CurrInt <= Cash1.XNOMPRVEXP+Cash11.xno_of_partners ) THEN
	BEGIN
	  SALESTAX:=FALSE;
	  PURCHTAX:=FALSE;
	END;
      GETITEM (TxFile,28);
      IF CURRDISP[1] IN ['E','R'] THEN
	BEGIN
	  SALESTAX:=FALSE;
	  PURCHTAX:=FALSE;
	END;

      IF TXT = 0 THEN
	Begin
	  { the next line is a vat line type 0 , so reset type9_active and 0
	    net_amt, last_sub to 99 }
	  type9_active := false;
	  net_amt := 0;
	  last_sub := 99;
	  IF ((PROG=CUSTREP) AND (SALESTAX))
	  OR ((PROG=SUPPREP) AND (PURCHTAX)) THEN
	    BEGIN
	      GETITEM(TxFile,10);
	      TESTCODE:=NULL;
	//      FOR X:=0 TO 9 DO TESTCODE:=CONCAT(TESTCODE,Cash1.XTAXIDS[X]);
        //      slimall(TestCode);
        // TGM AB
              For X:=0 to 9 do begin
                  if Cash1.XTAXIDS[X] = ' ' then TESTCODE:=CONCAT(TESTCODE,'_')
                     else if Cash1.XTAXIDS[X] = '' then TESTCODE:=CONCAT(TESTCODE,'_')
                        else TESTCODE:=CONCAT(TESTCODE,Cash1.XTAXIDS[X])
              end;
	      TAXSUB:=POS (CURRSTR,TESTCODE);
	      TAXSUB:=TAXSUB-1;
	      IF TAXSUB<0 THEN TAXSUB:=99;
	      IF TAXSUB IN [0..9] THEN
		BEGIN
		  IF TXT=0 THEN
		    IF ((SALESTAX) AND (TXTORIG IN [5,6,7,8,15,16]))
		    OR ((PURCHTAX) AND (TXTORIG IN [1,2,3,4,11,12])) THEN
		      BEGIN
			AMT:=0-AMT;
			TAX:=0-TAX;
		      END;
		  IF TXT=10 THEN
		    BEGIN
		      GETITEM (TxFile,18);
		      IF CURRINT=Cash1.XNOMTAX THEN
			BEGIN
			  AMT:=0-AMT;
			  TAX:=0-TAX;
			END;
		    END;
		  
		  GOODSAMT[TAXSUB]:=GOODSAMT[TAXSUB]+AMT;
		  GOODSAMT[    10]:=GOODSAMT[	 10]+AMT;
		  TAXAMT  [TAXSUB]:=TAXAMT  [TAXSUB]+TAX;
		  TAXAMT  [    10]:=TAXAMT  [	 10]+TAX;
		END;
	    END;
	End
      else
	{ if next line is not type 0 then store the net_value in the array at
	  position last_sub - reset the control flag/totals }
	if (( last_sub in [1..9] ) and ( type9_active )) then
	  Begin
	    if ( Cash1.xtaxrates[last_sub] = 0 ) then
	      Begin
		GOODSAMT[last_sub] := GOODSAMT[last_sub]+net_amt;
		GOODSAMT[      10] := GOODSAMT[	     10]+net_amt;
		last_sub     := 99;
		type9_active := false;
		net_amt	     := 0;
	      End;
	  End;
      
      { if txt = 9 then check prog & salestax/purchtax set the vat code
	if the code has a rate of 0.00 and is not code 0, then store the
	amt and set the type9_active flag to true. }
      if txt = 9 then
	Begin
	  IF ((PROG=CUSTREP) AND (SALESTAX))
	  OR ((PROG=SUPPREP) AND (PURCHTAX)) THEN
	    Begin
	      GETITEM(TxFile,10);
	      TESTCODE:=NULL;
	  //    FOR X:=0 TO 9 DO TESTCODE:=CONCAT(TESTCODE,Cash1.XTAXIDS[X]);
          //    slimall(TestCode);
          // TGM AB
              For X:=0 to 9 do begin
                  if Cash1.XTAXIDS[X] = ' ' then TESTCODE:=CONCAT(TESTCODE,'_')
                     else if Cash1.XTAXIDS[X] = '' then TESTCODE:=CONCAT(TESTCODE,'_')
                        else TESTCODE:=CONCAT(TESTCODE,Cash1.XTAXIDS[X])
              end;
              
	      last_sub := POS (CURRSTR,TESTCODE);
	      last_sub := last_sub-1;
	      if last_sub < 0 THEN last_sub := 99;
		    
	      if last_sub in [1..9] then
		if ( Cash1.xtaxrates[last_sub] = 0 ) then
		  Begin

		    net_amt := amt;
		    IF ((SALESTAX) AND (TXTORIG IN [5,6,7,8,15,16]))
		    OR ((PURCHTAX) AND (TXTORIG IN [1,2,3,4,11,12])) THEN
		      net_amt := 0-AMT;
		    type9_active := true;
		  End;
	    End;
	End;

    END;						  { end XYZ }

    PROCEDURE RunTransTotals;
    VAR
       ST,S1,S2,S3 : ShortSTRING;
       TAXSUB	: INTEGER;

       PROCEDURE TT1;
       BEGIN						 { begin TT1 }
        SKIP(3);
        STR(ACCTOT,ST);
        PLINE:=CONCAT('NUMBER OF RECORDS ....... ',ST);
        OP(7);
        SKIP(2);

        DoubleToStr(TxTots[1,1], S1, '%f', True, True, 12, False );
        DoubleToStr(TxTots[1,2], S2, '%f', True, True, 12, False );
        DoubleToStr(TxTots[1,3], S3, '%f', True, True, 12, False );
        {
        LONGSTR(TXTOTS[1,1],S1,'L');
        LONGSTR(TXTOTS[1,2],S2,'L');
        LONGSTR(TXTOTS[1,3],S3,'L');
        PadLeft ( s1, 12 );
        PadLeft ( s2, 12 );
        PadLeft ( s3, 12 );
        }
        PLINE:=CONCAT('INVOICES          NET ',S1,
	      		          '      VAT ',S2,
			        '      TOTAL ',S3);
        OP(10);
        SKIP(2);

        DoubleToStr(TxTots[2,1], S1, '%f', True, True, 12, False );
        DoubleToStr(TxTots[2,2], S2, '%f', True, True, 12, False );
        DoubleToStr(TxTots[2,3], S3, '%f', True, True, 12, False );
        {
        LONGSTR(TXTOTS[2,1],S1,'L');
        LONGSTR(TXTOTS[2,2],S2,'L');
        LONGSTR(TXTOTS[2,3],S3,'L');
        PadLeft ( s1, 12 );
        PadLeft ( s2, 12 );
        PadLeft ( s3, 12 );
        }
        PLINE:=CONCAT('PAYMENTS          NET ',S1,
				  '     DISC ',S2,
			        '      TOTAL ',S3);
        OP(12);
        SKIP(2);

        DoubleToStr(TxTots[3,1], S1, '%f', True, True, 12, False );
        DoubleToStr(TxTots[3,2], S2, '%f', True, True, 12, False );
        DoubleToStr(TxTots[3,3], S3, '%f', True, True, 12, False );
        {
        LONGSTR(TXTOTS[3,1],S1,'L');
        LONGSTR(TXTOTS[3,2],S2,'L');
        LONGSTR(TXTOTS[3,3],S3,'L');
        PadLeft ( s1, 12 );
        PadLeft ( s2, 12 );
        PadLeft ( s3, 12 );
        }
        PLINE:=CONCAT('CREDIT NOTES      NET ',S1,
                                  '      VAT ',S2,
                                '      TOTAL ',S3);
        OP(14);
        SKIP(2);
        SKIP(2);
       END;						 { end TT1 }

    BEGIN							 { begin RunTransTotals }

       NOHEADING:=TRUE;
       IF ( Device[1] in ['C','F','P','S'] ) THEN
          REPHEADINGS;
       IF ACT = 8 THEN
          TT1;
       IF ACT=11 THEN
          BEGIN
             SKIP (2);
	     CASE PROG OF
	        CUSTREP : PLINE:='SALES VAT SUMMARY';
	        SUPPREP : PLINE:='PURCHASE VAT SUMMARY';
             END;
	     OP(4);
	     PLINE:=COPY('--------------------',1,LENGTH(PLINE));
	     OP(5);
	     SKIP(1);
	     PLINE:='VAT-CODE     RATE      NET-AMOUNT      VAT-AMOUNT';
	     OP(7);
	     PLINE:='-------------------------------------------------';
	     OP(8);
	     SKIP(1);
	     FOR TAXSUB:=0 TO 10 DO
	         BEGIN
	              IF TAXSUB=10 THEN SKIP(1);
                      PLINE:=CONCAT(SPACE40,SPACE40);
	              IF TAXSUB<>10 THEN
	                 BEGIN
		              MOVE (Cash1.XTAXIDS[TAXSUB][1],PLINE[4],1);
		              CURRDBL:=Cash1.XTAXRATES[TAXSUB];
                              DoubleToStr ( CurrDbl, St, '%f', True, True, 6, True );
		              {LONGSTR(CURRLONG,ST,'L');}
		              MOVE(ST[1],PLINE[12{7}],LENGTH(ST));
                         END
                      ELSE
	                  BEGIN
		               ST:='*** TOTALS *** ';
		               MOVE(ST[1],PLINE[1],LENGTH(ST));
                          END;

                      DoubleToStr(GoodsAmt[TaxSub], ST, '%f', True, True, 12, True );
                      {LONGSTR(GOODSAMT[TAXSUB],ST,'L');}
                      MOVE(ST[1],PLINE[22],LENGTH(ST));
                      DoubleToStr(TaxAmt[TaxSub], ST, '%f', True, True, 12, True );
	              {LONGSTR(TAXAMT[TAXSUB],ST,'L');}
	              MOVE(ST[1],PLINE[38],LENGTH(ST));
	              IF TAXSUB=10 THEN OP(11+TAXSUB)
                      ELSE OP(10+TAXSUB);
                 END;
          END;

       IF (Device='F') THEN SKIPLINES(RFarmGate.PLINESPAGE[1]-LINECOUNT);

       If ( Prog = CUSTREP ) And ( Act = 11 ) Then
          {RepHeadings}
       Else
           If NOT (( ACT = 11 ) And ( TaxAudit )) Then
              EndPrint;
    END;							{ end RunTransTotals }

  BEGIN							  { begin TRANSSUMMARY }
    SETDB(TxFile);

    last_sub	 := 99;
    type9_active := false;
    net_amt	 := 0;

    ZEROTOT;
    FOR RECNO:=SCHRECF TO SCHRECT DO
      BEGIN
        READREC(TxFile,RECNO);
	IF ERRORNO > 0 THEN ERR;
	IF RECACTIVE(TxFile) THEN
	  BEGIN
	    GETITEM(TxFile,2);

	    IF (CURRINT>FROMDT-1) AND (CURRINT<TODT+1) THEN
	      BEGIN

		GETITEM(TxFile,1);
		TXT:=CURRINT;
		IF ACT=8 THEN
		  IF ((TXT IN [1..4]) AND (PROG=CUSTREP))
		  OR ((TXT IN [5..8]) AND (PROG=SUPPREP)) THEN
		    BEGIN
		      GETITEM(TxFile,28);
		      IF (CURRDISP[1]=' ')
		      OR (CURRDISP[1]='I')
		      OR (CURRDISP[1]='P') THEN
			BEGIN
			  ACCTOT:=ACCTOT+1;
			  GETITEM(TxFile,9);
                          IF PROG=CUSTREP THEN
			    BEGIN
			      TXTOTS[TXT,1]:=TXTOTS[TXT,1]+CURRLONG;
			      TXTOTS[TXT,3]:=TXTOTS[TXT,3]+CURRLONG;
			    END;
			  IF PROG=SUPPREP THEN
			    BEGIN
			      TXTOTS[TXT-4,1]:=TXTOTS[TXT-4,1]+CURRLONG;
			      TXTOTS[TXT-4,3]:=TXTOTS[TXT-4,3]+CURRLONG;
			    END;
			  GETITEM(TxFile,11);
			  IF PROG=CUSTREP THEN
			    BEGIN
			      TXTOTS[TXT,2]:=TXTOTS[TXT,2]+CURRLONG;
			      TXTOTS[TXT,3]:=TXTOTS[TXT,3]+CURRLONG;
			    END;
			  IF PROG=SUPPREP THEN
			    BEGIN
			      TXTOTS[TXT-4,2]:=TXTOTS[TXT-4,2]+CURRLONG;
			      TXTOTS[TXT-4,3]:=TXTOTS[TXT-4,3]+CURRLONG;
			    END;
			END;
		    END;
		IF ACT=11 THEN XYZ;
	      END;
	  END;
      END;

    RunTransTotals;

  END;							 { end TRANSSUMMARY }

  PROCEDURE ANALTOTALS;
  VAR
    TempDbl : Double;
    SUB : Integer;
    ST	: ShortString;

    PROCEDURE PRINTIT;
    VAR
      LINESSPARE : INTEGER;
      OLDHIGH	 : INTEGER;
      OLDLINE	 : ShortString;

    BEGIN						  { begin PRINTIT }
      OLDLINE := PLINE;
      OLDHIGH := COLHIGH;
      LINESSPARE := 4;
      IF ((LINECOUNT+LINESSPARE>RFarmGate.PLINESPAGE[1]) AND
	 ( Device[1] in ['C','F','P','S'] )) THEN
	 REPHEADINGS;
      PLINE := OLDLINE;
      COLHIGH := OLDHIGH;

      if Device = 'S' then
	PadRight ( PLINE, 132 );

      OUTPUTLINE;

    END;						  { end PRINTIT }

    PROCEDURE BUILDPERC(COL : INTEGER; PARTVAL,TOTVAL: LONG);
    VAR
      ST    : ShortString;
      Total,
      SubTotal : Double;
    BEGIN						   { begin BUILDPERC }
      Total := TotVal;
      SubTotal := PartVal;
      if Total = 0 then
         DoubleToStr(Total,St,'%4.2f',true,FALSE,6,FALSE)
      else
         DoubleToStr((SubTotal/Total)*100,St,'%4.2f',true,FALSE,6,FALSE);
      ST := ST + '%';

      MOVE(ST[1],PLINE[COL],LENGTH(ST));
    END;						 { end BUILDPERC }

  BEGIN							 { begin ANALTOTALS }

    REPHEADINGS;
    FOR SUB:=0 TO MAXANAL-1 DO
      IF ARECS[SUB]>0 THEN
	BEGIN
	  PLINE:=CONCAT(SPACE40,SPACE40);
	  STR(SUB,ST);
	  REPEAT
	    IF LENGTH(ST)<5 THEN ST:=CONCAT(SPACE1,ST);
	  UNTIL NOT(LENGTH(ST)<5);
	  MOVE(ST[1],PLINE[2],LENGTH(ST));

	  STR(ARECS[SUB],ST);
	  REPEAT
	    IF LENGTH(ST)<5 THEN ST:=CONCAT(SPACE1,ST);
	  UNTIL NOT(LENGTH(ST)<5);
	  MOVE(ST[1],PLINE[58],LENGTH(ST));

          if (( SUB > 0 ) and (not RCSList.ProductReport)) then
	    begin
              AccsDataModule.AnalysisDB.open;
              if AccsdataModule.AnalysisDB.locate('Number',sub,[]) then begin
                 currstr := varToStr(AccsdataModule.AnalysisDB['Description']);
                 Move ( currstr[1], pline[10], length ( currstr ));
              end;
            end;
          if (( SUB > 0 ) and (RCSList.ProductReport)) then
	    begin
              AccsDataModule.Products.open;
              if AccsdataModule.Products.locate('ID',sub,[]) then begin
                 currstr := varToStr(AccsdataModule.Products['Desc1']);
                 Move ( currstr[1], pline[10], length ( currstr ));
              end;
	    end;

            if not (Sub > 0) then
            Begin
	      st := null;
	      st := 'Default Analysis Code';
	      move ( st[1], pline[10], length ( st ));

	    End;

          TempDbl := AVALS[SUB];
          DoubleToStr(TempDbl,St,'%10.2f',true,true,12,true);
	  MOVE(ST[1],PLINE[40],LENGTH(ST));

          TempDbl := AQty[SUB];
          DoubleToStr(TempDbl,St,'%10.2f',true,true,12,true);
	  MOVE(ST[1],PLINE[28],LENGTH(ST));


	  COLHIGH:=32;
	  BUILDPERC(70,AVALS[SUB],AVALS[MAXANAL]);
	  COLHIGH:=78;
	  PRINTIT;
	END;

    SKIPLINES(1);

    PLINE:=CONCAT(SPACE40,SPACE40);
    ST:='TOTALS';
    MOVE(ST[1],PLINE[2],LENGTH(ST));

    TempDbl := AQty[MAXANAL];
    DoubleToStr(TempDbl,St,'%10.2f',true,true,12,true);
    MOVE(ST[1],PLINE[28],LENGTH(ST));




    STR(ARECS[MAXANAL],ST);
    REPEAT
      IF LENGTH(ST)<5 THEN ST:=CONCAT(SPACE1,ST);
    UNTIL NOT(LENGTH(ST)<5);

    MOVE(ST[1],PLINE[58],LENGTH(ST));

    TempDbl := AVALS[MAXANAL];
    DoubleToStr(TempDbl,St,'%10.2f',true,true,12,true);
    MOVE(ST[1],PLINE[40],LENGTH(ST));
    st := '100%';
    MOVE(ST[1],PLINE[73],LENGTH(ST));
    COLHIGH:=76;
    PRINTIT;
    blankline;
    PRINTIT;    
    blankline;
    PrintIt;
    ST := '';
    ST := 'Percentages and totals are in relation to the';
    MOVE(ST[1],PLINE[80],LENGTH(ST));
    Colhigh := 132;
    PRINTIT;
    ST := '';
    if RCSList.ProductReport then ST:= 'selected range of Product Codes               '
    else ST:= 'selected range of Analysis Codes              ';
    MOVE(ST[1],PLINE[80],LENGTH(ST));
    Colhigh := 132;
    PRINTIT;

    IF ( Device[1] in ['C','F','P','S'] ) THEN
       SKIPLINES(RFarmGate.PLINESPAGE[1]-LINECOUNT);
  END;							{ end ANALTOTALS }

  PROCEDURE ANALSUMMARY;
  VAR
    RECNO   : INTEGER;
    SUB	    : INTEGER;
    TOPREC  : ShortString{[6]};

    PROCEDURE ZEROANAL;
    VAR
      X : INTEGER;
    BEGIN						 { begin ZEROANAL }
      FOR X:=0 TO MAXANAL DO
	BEGIN
          AVALS[X]:=0;
	  ARECS[X]:=0;
          AQty[X] := 0;
	END;
    END;						 { end ZEROANAL }

  BEGIN							 { begin ANALSUMMARY }
    // SetUp the filters for this Report
    if RcsList.ProductReport then
    try
       SchRecf := StrToInt(CustSuppListing.eProductTxFrom.Text);
       SchRect := StrToInt(CustSuppListing.eProductTxTo.Text);
       SetDB(TxFile);
       if SchRect > DB1.DBRECHIGH then
          SchRect := DB1.DBRECHIGH;
    except
       SchRecf := 1;
       SetDB(TxFile);
       SchRect := DB1.DBRECHIGH;
    end

    else try
       SchRecf := StrToInt(CustSuppListing.eTxFrom.Text);
       SchRect := StrToInt(CustSuppListing.eTxTo.Text);
       SetDB(TxFile);
       if SchRect > DB1.DBRECHIGH then
          SchRect := DB1.DBRECHIGH;
    except
       SchRecf := 1;
       SetDB(TxFile);
       SchRect := DB1.DBRECHIGH;
    end;

    if RcsList.ProductReport then
    try
       FROMNOM := StrToInt(CustSuppListing.eProductNomFrom.Text);
       TONOM   := StrToInt(CustSuppListing.eProductNomTo.Text);
       SetDB(NlFile);
       if TONOM > DB1.DBRECHIGH then
          TONOM := DB1.DBRECHIGH;
    except
       FROMNOM := 1;
       SetDB(NlFile);
       TONOM := DB1.DBRECHIGH;
    end


    else try
       FROMNOM := StrToInt(CustSuppListing.eNomFrom.Text);
       TONOM   := StrToInt(CustSuppListing.eNomTo.Text);
       SetDB(NlFile);
       if TONOM > DB1.DBRECHIGH then
          TONOM := DB1.DBRECHIGH;
    except
       FROMNOM := 1;
       SetDB(NlFile);
       TONOM := DB1.DBRECHIGH;
    end;

    If Rcslist.ProductReport then
       try
          FROMANL := StrToInt(CustSuppListing.eProductFrom.Text);
          TOANL   := StrToInt(CustSuppListing.eProductTo.Text);
       except
             FROMANL := 1;
             TOANL   := 9999;
       end

    else try
       FROMANL := StrToInt(CustSuppListing.eAnalFrom.Text);
       TOANL   := StrToInt(CustSuppListing.eAnalTo.Text);
    except
       FROMANL := 1;
       TOANL   := 9999;
    end;

    If CustSuppListing.TxDateFrom <> 0 Then
               Begin
                    FROMDT     := CustSuppListing.TxDateFrom;
                    TODT       := CustSuppListing.TxDateTo;
               End;


    SETDB(TXFile);
    ZEROANAL;
    accsdatamodule.ProdsTx.open;
    FOR RECNO:=SCHRECF TO SCHRECT DO
      BEGIN
    	READREC(TxFile,RECNO);
   //     if recno = 249 then begin
   //         showmessage('Now');
   //     end;
        if RCSList.ProductReport then begin
           sub:=0;
           if accsdatamodule.ProdsTx.locate('TxNo',RecNo,[]) then try sub := accsdatamodule.ProdsTx['ProductID']
           except
           end;
           if sub = 0 then begin
                 GetItem(TxFile,7);
                 If Currint > 0 then sub := Currint;
           end;
        end;
	IF ERRORNO > 0 THEN ERR;
	IF RECACTIVE(TxFile) THEN
	  BEGIN
	    GETITEM(TxFile,2);
	    IF (CURRINT>FROMDT-1) AND (CURRINT<TODT+1) THEN
	      BEGIN
		GETITEM(TxFile,8);
		IF (CURRINT>FROMNOM-1) AND (CURRINT<TONOM+1) THEN
		  BEGIN
		    GETITEM(TxFile,28);
		    IF (CURRDISP[1]=' ')
		    OR (CURRDISP[1]='I')
		    OR (CURRDISP[1]='P')
		    or ( CURRDISP[1] IN ['0'..'9'] ) THEN
		      BEGIN
			OKTOPRINT:=TRUE;
			GETITEM(TxFile,1);
			OKTOPRINT:=(CURRINT=9);
			IF OKTOPRINT THEN
			  BEGIN
			    GETITEM(TxFile,23);
			    { MC 06-03-96 removed sales receipts &
			      Purchase payments }
			    IF PROG=CUSTREP THEN
			      OKTOPRINT:= CURRINT IN [1,{2,}3,4,11];
			    IF PROG=SUPPREP THEN
			      OKTOPRINT:= CURRINT IN [5,{6,}7,8,15];
			    IF OKTOPRINT THEN
			      BEGIN
                                if not RCSList.ProductReport then begin
				   GETITEM(TxFile,12);
				   IF CURRINT>9999 THEN CURRINT:=0; // was 999
				   SUB:=CURRINT;
                                end;
                            //    if sub in [fromanl..toanl] then
                                  if ((sub>=fromanl) and (sub<=toanl)) then
				  Begin
				    GETITEM(TxFile,9);

                                    AVALS[SUB]:=AVALS[SUB]+CURRLONG;
				    ARECS[SUB]:=ARECS[SUB]+1;
				    AVALS[MAXANAL]:=AVALS[MAXANAL]+CURRLONG;
				    ARECS[MAXANAL]:=ARECS[MAXANAL]+1;

                                    GETITEM(TxFile,23);

                                    If CURRINT IN [3,7] then begin
                                        GetItem(TxFile,6);
                                        if currlong > 0 then AQty[SUB]:=AQty[SUB]-CURRLONG
                                           else AQty[SUB]:=AQty[SUB]+CURRLONG;
                                        AQty[MAXANAL] := AQty[MAXANAL]-CURRLONG;
                                    end
                                    else begin
                                        GetItem(TxFile,6);
                                        AQty[SUB]:=AQty[SUB]+CURRLONG;
                                        AQty[MAXANAL] := AQty[MAXANAL]+CURRLONG;
                                    end;

				  End;
			      END;
			  END;
		      END;
		  END;
	      END;
	  END;
      END;
    ANALTOTALS;
    EndPrint;
  END;							 { end ANALSUMMARY }


  PROCEDURE PROCESSFILE;
  VAR
    TXT	    : INTEGER;
    TXTORIG : INTEGER;
    DIFFTX  : BOOLEAN;
    RECNO   : SmallInt;
    TOPREC  : ShortString{[6]};
    TXSTAT  : ShortString{[1]};
    last_area : Integer;
    Balance : Long;
    Code : integer;

  BEGIN							{ begin PROCESSFILE }
    ZEROTOT;
    SETDB(DBNO);

    page_break := false;
    last_area  := -1;
    head_area  := 0;
    store_area := 0;


    If ( SortRep ) And ( act In [1,2] ) Then
      Begin
	 sort_file ( dbno, recno, 22, 1, true );
	 If ( recno > 0 ) Then
	    Begin
	       Repeat
		  readrec ( dbno, recno );
		  If errorno > 0 Then err;
		  If recactive ( dbno ) Then
		     Begin
			getitem ( dbno, 22 );
			head_area := currint;
			oktoprint := ( head_area >= area_from ) And
				     ( head_area <= area_to );
		     End;
		  { only read next if the record just read isn't valid }
		  If NOT oktoprint Then
		     next_sort_rec ( recno );
	       Until oktoprint Or ( recno = 0 );
	       If recno <> 0 Then
		  repheadings
	       Else
		  exit;
	    End;
      End
    Else
      RECNO:=SCHRECF;

    IF ( Device[1] in ['F','P','S'] ) THEN
      BEGIN
	SETDB(DBNO);
	STR (DB1.DBRECHIGH,TOPREC);
	{
        IF ACT < 5 THEN
	  DIS ( 1,24,'PROCESSING ACCOUNT NUMBER ')
	ELSE
	  DIS ( 1,24,'PROCESSING TRANSACTION RECORD ');
	IF ACT < 5 THEN
	  DIS (32,24,CONCAT('(OF ',TOPREC,')'))
	ELSE
	  DIS (36,24,CONCAT('(OF ',TOPREC,')'));
        }
      END;

    DIFFTX:=FALSE;
    REPEAT
      {
      If (( Device = 'P' ) or ( Device = 'F' ) or ( Device = 'S')) THEN
	If first_disp then
	  If ACT < 5 THEN
	    DISI (27,24,RECNO,1)
	  Else
	    DISI (31,24,RECNO,1);
      }

      READREC(DBNO,RECNO);
      IF ERRORNO > 0 THEN ERR;
      IF RECACTIVE(DBNO) THEN
	BEGIN
             //getitem ( dbno, 22 );
             //head_area := currint;
             //oktoprint := ( head_area >= area_from ) And
             //             ( head_area <= area_to );     // line below put back in 23/02/04 as payment listing not working as no area set

	  OKTOPRINT:=TRUE; // line remmed out by GM 31/03/03 lines above also added.
	  {
          if TRANS_AMEND then
	    OKTOPRINT := CHECK_EDIT_STAT;
          }
	  IF ACT IN [5..7] THEN
	    BEGIN
	      GETITEM(TxFile,1);
	      TXT:=CURRINT;
	      GETITEM(TxFile,23);
	      TXTORIG:=CURRINT;
	      GETITEM(TxFile,28);
	      TXSTAT   :=SPACE1;
	      TXSTAT[1]:=CURRDISP[1];
	      IF (PROG=CUSTREP) AND NOT(TXT IN [1..4,9]) THEN
		OKTOPRINT:=FALSE;
	      IF (PROG=SUPPREP) AND NOT(TXT IN [5..8,9]) THEN
		OKTOPRINT:=FALSE;
	      IF NOT(TXTORIG IN [1..8]) THEN OKTOPRINT:=FALSE;
	      IF (TXT<>9) AND DIFFTX THEN
		BEGIN
		  DIFFTX:=FALSE;
		  IF (TXT IN [0,10]) AND (TXTORIG IN [1..8]) THEN
		    BEGIN
		      OKTOPRINT:=FALSE;
		      DIFFTX:=TRUE;
		    END;
		END;
	      IF ACT IN [5,7] THEN
		IF TXT=9 THEN
		  IF NOT INCLANAL
		    THEN OKTOPRINT:=FALSE;
	      IF (TXT=9) AND NOT DIFFTX THEN OKTOPRINT:=FALSE;
	      IF OKTOPRINT THEN
		IF PROG=CUSTREP THEN
		  IF (ACT IN [5]) AND NOT(TXT IN [1,9])
		    THEN OKTOPRINT:=FALSE;
	      IF OKTOPRINT THEN
		IF PROG=SUPPREP THEN
		  IF (ACT IN [5]) AND NOT(TXT IN [5,9])
		    THEN OKTOPRINT:=FALSE;
	      IF OKTOPRINT THEN
		IF PROG=CUSTREP THEN
		  IF (ACT IN [6]) AND (TXT<>2)
		    THEN OKTOPRINT:=FALSE;
	      IF OKTOPRINT THEN
		IF PROG=SUPPREP THEN
		  IF (ACT IN [6]) AND (TXT<>6)
		    THEN OKTOPRINT:=FALSE;
	      IF OKTOPRINT THEN
		IF PROG=CUSTREP THEN
		  IF (ACT IN [7]) AND NOT(TXT IN [3,9])
		    THEN OKTOPRINT:=FALSE;
	      IF OKTOPRINT THEN
		IF PROG=SUPPREP THEN
		  IF (ACT IN [7]) AND NOT(TXT IN [7,9])
		    THEN OKTOPRINT:=FALSE;
	      IF OKTOPRINT THEN
		BEGIN
		  GETITEM (TxFile,3);
		  IF (CURRINT<ACCMIN) OR (CURRINT>ACCMAX) THEN OKTOPRINT:=FALSE;
		END;
	    END;
	  IF OKTOPRINT AND (DBNO=TxFile {2} ) THEN
	    BEGIN
	      GETITEM(TxFile,2);
	      IF (CURRINT<FROMDT) OR (CURRINT>TODT) THEN OKTOPRINT:=FALSE;
	    END;

	  If (( oktoprint ) and ( dbno In [SlFile, PlFile] {= 1} ) And
	      ( minimumbalance ) and ( act = 2 )) Then
	      Begin
		getitem (dbno, 7);
                val(rcslist.CustSuppListing.GreaterThanBalance.Text,Balance,code);
                if (currlong < 0) then if (currlong*-1) <= (balance*100) then oktoprint := false;
     		if (currlong >= 0) then if currlong <= (balance*100) then oktoprint := false;
	      End;





	  If (( dbno In [SlFile, PlFile] {= 1} ) And ( act In [1,2] ) And ( SortRep ) And ( oktoprint )) Then
	      Begin
		getitem ( dbno, 22 );
		page_break := (( currint <> last_area ) And ( last_area <> -1 ));
		If currint <> last_area Then
		  store_area := last_area;
		last_area := currint;
		head_area := last_area;
		oktoprint := ( last_area >= area_from ) And
			     ( last_area <= area_to );
	      End;

          if oktoprint then begin
             getitem ( dbno, 22 );
             oktoprint := ( Currint >= area_from ) And
			     ( Currint <= area_to );
          end;

	  IF OKTOPRINT THEN
	    BEGIN
	      PRINTOUT;
	      IF INCLANAL THEN DIFFTX:=TRUE;
	    END;
	  IF ESCKEY THEN EXIT;
	END;


      If ( SortRep ) And ( act In [1,2] ) then
	 next_sort_rec ( recno )
      Else
	 RECNO:=RECNO+1;

      SETDB(DBNO);

    UNTIL ( RECNO>SCHRECT ) Or ( recno = 0 );
  END;							 { end PROCESSFILE }

(*
  Procedure processanl;
  VAR
    RECNO   : INTEGER;
    TOPREC  : STRING[6];

    Procedure print_anl;
    VAR
      SUB	 : INTEGER;
      LINESSPARE : INTEGER;
      PR	 : BOOLEAN;
      WORKSTR	 : STRING80;
    Begin
      LINESSPARE:=4;

      IF LINECOUNT + LINESSPARE > PLINESPAGE[1] THEN
	REPHEADINGS;

      BLANKLINE;

      getitem ( anl_db, 1 );
      builditem ( 1, 3 );
      getitem ( anl_db, 2 );
      builditem ( 2, 16 );
      getitem ( anl_db, 3 );
      builditem ( 3, 52 );
      getitem ( anl_db, 4 );
      builditem ( 4, 76 );

      workstr := null;
      getitem ( anl_db, 5 );
      if currdisp[1] = 'Y' then
	workstr := 'Code in use'
      else
	workstr := 'Code not in use';
      buildline ( 94, workstr );

      OUTPUTLINE;

    End;

  BEGIN							{ begin PROCESSanl }
    SETDB(DBNO);

    IF ( Device in ['F','P','S'] ) THEN
      BEGIN
	SETDB(DBNO);
	STR (DB1.DBRECHIGH,TOPREC);
	CLEARFROM (24);
	DIS ( 1, 24, 'PROCESSING ANALYSIS CODE ');
	DIS (32, 24, CONCAT('(OF ',TOPREC,')'));
      END;
    RECNO := SCHRECF;
    REPEAT
      IF (( Device = 'P' ) or ( Device = 'F' ) or ( Device = 'S')) THEN
	if first_disp then
	  DISI (26,24,RECNO,1);

      READREC ( DBNO, RECNO );
      IF ERRORNO > 0 THEN ERR;
      IF RECACTIVE(DBNO) THEN
	Begin
	  totrecs := totrecs + 1;
	  printanl;
	  IF ESCKEY THEN EXIT(PROCESSFILE);
	End;
      RECNO := RECNO + 1;
      SETDB ( DBNO );
    UNTIL RECNO>SCHRECT;
    
  END;							 { end PROCESSanl }
  *)

  PROCEDURE REP1STR;
  BEGIN							  { begin REP1STR }
    HEADING:=NULL;
    CASE ACT OF
      1 : HEADING:='ACCOUNT LISTING';
      2 : HEADING:='AGE-OF-DEBT SUMMARY';
      3 : HEADING:='ACCOUNT CONTROL SUMMARY';
      5 : HEADING:='INVOICE TRANSACTION LISTING';
      6 : HEADING:='PAYMENT TRANSACTION LISTING';
      7 : HEADING:='CREDIT NOTE TRANSACTION LISTING';
      8 : HEADING:='TRANSACTION CONTROL SUMMARY';
     10 : CASE PROG OF
	    CUSTREP : HEADING:='SALES ANALYSIS SUMMARY';
	    SUPPREP : HEADING:='PURCHASE ANALYSIS SUMMARY';
	  END;
     11 : CASE PROG OF
	    CUSTREP : HEADING:=CONCAT(Cash1.XTAXCODE,' REPORT (SALES)');
	    SUPPREP : HEADING:=CONCAT(Cash1.XTAXCODE,' REPORT (PURCHASES)');
	  END;
     13 : heading := 'ANALYSIS CODE LISTING';
    END;
  END;							 { end REP1STR }

  PROCEDURE REPSTART;
  VAR
    X	    : INTEGER;
  BEGIN							 { begin REPSTART }

      REP1STR;
      FOR X:=1 TO MAXC DO
          REPITEMS[X]:=0;
      NEXTLINE:=6;
  END;							 { end REPSTART }

  PROCEDURE REPDEF;
  BEGIN							  { begin REPDEF }

    REPSTART;
    IF ESCKEY THEN EXIT;
(*
    IF ((AUTORUN) AND (NOT AUTOFIRST)) OR (AUTOPROG=9) THEN
    ELSE
      BEGIN
	DIS (27,NEXTLINE,'Report Date: ');
	SCRIN := XDATE;
	repeat
	  recdat ( 40, nextline, scrin, temp_date, 0,0,0,0,0,0 );
	  if esckey then exit ( repdef );
	  {
	  REPEAT
	    no_func_key;
	    REC (40, NEXTLINE, 8, SCRIN, 0,0,0,0,0,0);
	    IF ESCKEY THEN EXIT(REPDEF);
	  UNTIL DATEVALID(SCRIN,'DD/MM/YY');
	  }
	  error_date ( report, go_on );
	until NOT CHECK_DATE ( SCRIN, DEFAULT_DATE );
	XDATE:=SCRIN;
	NEXTLINE:=NEXTLINE+2;
	CLEARFROM ( 24 );

	DAYTOT:=DAYTOT-32000;
      END;
    INCLANAL:=FALSE;
    IF ACT IN [5,7] THEN
      BEGIN
	IF AUTORUN THEN
	  INCLANAL:=TRUE
	ELSE
	  BEGIN
	    {
	    DIS (6,NEXTLINE,'Include Analysis Breakdown (Y/N): ');
	    }
	    Dis ( 7, nextline, 'Include Invoice Breakdown (Y/N): ');
	    ST:='N';
	    REPEAT
	      no_func_key;
	      REC (40,NEXTLINE,1,ST,0,0,0,0,0,0);
	      IF ESCKEY THEN EXIT(REPDEF);
	      ST:=SCRIN;
	    UNTIL SCRIN[1] IN ['Y','y','N','n'];
	    INCLANAL:= (SCRIN[1] IN ['Y','y']);
	    NEXTLINE:=NEXTLINE+2;
	  END;
      END;
*)
  END;							{ end REPDEF }

  PROCEDURE REPORTRUN;
  VAR
    {
    DAYTOT1,
    DAYTOT2 : long;
    }

    NEXTCOL : INTEGER;
    DISSIZE : INTEGER;
    ITEM    : INTEGER;
    X	    : INTEGER;
    DATASIZE: INTEGER;
{-->>    OFST    : INTEGER;}
{-->>    OK	    : BOOLEAN;}

    PROCEDURE REPSETITEMS;
    BEGIN						 { begin REPSETITEMS }
      CASE ACT OF
	1     : BEGIN
		  REPITEMS[1]:=1;
		  REPITEMS[2]:=6;
		  REPITEMS[3]:=2;
		  REPITEMS[4]:=3;
		  REPITEMS[5]:=4;
		END;
	2     : BEGIN
		  REPITEMS[1]:=1;
		  repitems[2]:=19;
		  REPITEMS[3]:=7;
		  REPITEMS[4]:=9;
		  REPITEMS[5]:=10;
		  REPITEMS[6]:=11;
		  REPITEMS[7]:=12;
		  REPITEMS[8]:=8;
		END;
	5,6,7 : BEGIN
		  {
		  REPITEMS[1]:=3;
		  REPITEMS[2]:=2;
		  REPITEMS[3]:=4;
		  REPITEMS[4]:=12;
		  REPITEMS[5]:=9;
		  REPITEMS[6]:=11;
		  IF NOT (ACT IN [6]) THEN REPITEMS[7]:=10;
		  REPITEMS[8]:=18;
		  REPITEMS[9]:=19;
		  REPITEMS[10]:=5;
		  REPITEMS[11]:=102;
		  }
		  REPITEMS[1] := 2;
		  REPITEMS[2] := 4;
		  REPITEMS[3] := 12;
		  REPITEMS[4] := 9;
		  REPITEMS[5] := 11;
		  if not ( act in [6] ) then REPITEMS[6] := 10;
		  REPITEMS[7] := 5;

		  repitems[8] := 18;
		  repitems[9]:= 19;

		  REPITEMS[10] := 3; { 8 }

		  REPITEMS[11] := 102; { 9 }
		END;
      END;
    END;						{ end REPSETITEMS }

  BEGIN							{ begin REPORTRUN }
{-->>   CASE PROG OF }
{-->>     CUSTREP : OFST:=0;}
{-->>     SUPPREP : OFST:=5;
    END;}
    IF AUTOPROG=9 THEN
      BEGIN
{-->>	OK:=FALSE;}
{	IF ((ACT=2) AND (PICKOPT[1+OFST]))
	OR ((ACT=5) AND (PICKOPT[2+OFST]))
	OR ((ACT=6) AND (PICKOPT[3+OFST]))
	OR ((ACT=7) AND (PICKOPT[4+OFST]))
	OR ((ACT=8) AND (PICKOPT[5+OFST])) THEN OK:=TRUE;
	IF NOT OK THEN EXIT (REPORTRUN);
        }
      END;
    REPDEF;
    IF ESCKEY THEN EXIT;

    If ( PROG = SUPPREP ) And ( Act = 11 ) Then
       {}
    Else
        StartPrint ( False );
(*
    IF AUTORUN THEN
      BEGIN
	IF (AUTOFIRST) AND (AUTOPROG<>9) THEN Device := 'P';
	if act=2 then omit_zero := true;
      END
    ELSE
      BEGIN

	DATA_DEST ( NEXTLINE, WORKSTR );

	IF ESCKEY THEN
	   EXIT ( REPORTRUN );

	NEXTLINE := NEXTLINE + 2;
	Device := WORKSTR[1];

      END;
*)
//  SETDB (1)

    If PROG = CustRep Then
       SETDB (SlFile)
    Else
       SETDB (PlFile);

    ACCMIN:=1;
    ACCMAX:=DB1.DBRECHIGH;
    SETDB(DBNO);

(* change - hold on to previous report range if doing ROI VAT report *)

    if (( DBNO = TxFile {2} ) and ( PROG = 21 ) and
       ( ACT = 11 ) and ( NOT AUTORUN )) then
      begin
	{
        PERIOD1 := 0;
	PERIOD2 := 0;
	}
        TX_START := 0;
	TX_END	 := 0;
	SCHRECF:=1;
	SCHRECT:=DB1.DBRECHIGH;
      end
    else
      if (( DBNO = TxFile {2} ) and ( PROG = 24 ) and
	 ( ACT = 11 ) and ( NOT AUTORUN )) then
	begin
	  SCHRECF := TX_START;
	  SCHRECT := TX_END;
	end
      else
	begin
	  SCHRECF:=1;
	  SCHRECT:=DB1.DBRECHIGH;
	end;

    {
    IF NOT AUTORUN THEN
      BEGIN

        REPEAT
	  IF DBNO=1 THEN
	    BEGIN
	      DIS (19,NEXTLINE,	 'Print Accounts From: ');
	      DIS (36,NEXTLINE+1,'To: ');
	    END;
	  IF DBNO=2 THEN
	    BEGIN
	      DIS (15,NEXTLINE,	 'Print Transactions From: ');
	      DIS (36,NEXTLINE+1,'To: ');
	    END;
	  if act = 13 then
	    begin
	      DIS (19,NEXTLINE,	 'Print Analysis From: ');
	      DIS (36,NEXTLINE+1,'To: ');
	    End;
	  STR(SCHRECF,ST);
	  REPEAT
	    if DBNO = 1 then
	      begin
		case PROG of
		  CUSTREP : search_action := 2;
		  SUPPREP : search_action := 3;
		end;
		search_db := 1;
		window_position := 'L';
		disp_options := true;
		allow_exit := false;
		F2_F3_active := true;
		REC ( 40,NEXTLINE,5,ST,0,40,40,1,-1,all_supp_cust);
	      end
	    else
	      if act = 13 then
		rec ( 40, NEXTLINE, 4, ST, 0, 40, 40, anl_db, -1, all_anl )
	      else
		rec ( 40, NEXTLINE, 5, ST, 0, 0, 0, 0, 0, 0 );

	    IF ESCKEY THEN EXIT(REPORTRUN);
	    ST:=SCRIN;
	  UNTIL NUMERIC (SCRINT);
	  INTVAL(SCHRECF,SCRINT);
	  STR(SCHRECT,ST);
	  REPEAT
	    if DBNO = 1 then
	      begin
		case PROG of
		  CUSTREP : search_action := 2;
		  SUPPREP : search_action := 3;
		end;
		search_db := 1;
		window_position := 'L';
		disp_options := true;
		allow_exit := false;
		F2_F3_active := true;
		REC(40,NEXTLINE+1,5,ST,0,40,40,1,-1,all_supp_cust);
	      end
	    else
	      if act = 13 then
		rec ( 40, NEXTLINE+1, 4, ST, 0, 40, 40, anl_db, -1, all_anl )
	      else
		rec ( 40, NEXTLINE+1, 5, ST, 0, 0, 0, 0, 0, 0 );

	    ST:=SCRIN;
	  UNTIL ESCKEY OR NUMERIC(SCRINT);
	  IF NOT ESCKEY THEN INTVAL(SCHRECT,SCRINT);
	UNTIL NOT ESCKEY AND (SCHRECF>0) AND NOT(SCHRECT<SCHRECF);
        }
	TX_START := SCHRECF;
	TX_END	 := SCHRECT;
	NEXTLINE := NEXTLINE+3;

	{
        IF (( DBNO=1 ) and ( prog in [custrep,supprep] ) and ( act In [1,2] )) THEN
	  Begin
	    area_from := 0;
	    area_to   := 0;

	    Dis ( 18, nextline,	  'Print Area Code From: ' );
	    Dis ( 18, nextline+1, '		     To: ' );

	    Repeat
	       str ( area_from, st );
	       recint ( 40, nextline, st, area_from, 0, 0, 0, 0, 0, 0 );
	       If esckey Then exit ( reportrun );
	       str ( area_to, st );
	       recint ( 40, nextline+1, st, area_To, 0, 0, 0, 0, 0, 0 );
	    Until ( area_to >= area_from ) And ( NOT esckey );

	    SortRep := ( area_to > 0 );

	    If act = 2 Then
	       Begin
		  nextline := nextline + 3;
		  DIS (1,NEXTLINE,  '  Include Zero Balance Accounts (Y/N): ');
		  ST:='Y';
		  REPEAT
		     no_func_key;
		     REC (40,NEXTLINE,1,ST,0,0,0,0,0,0);
		     IF ESCKEY THEN EXIT ( REPORTRUN );
		     ST:=SCRIN;
		   UNTIL SCRIN[1] IN ['Y','y','N','n'];
		   omit_zero:= (SCRIN[1] IN ['N','n']);
		   NEXTLINE := NEXTLINE + 3;
	       End;
	  End;
      END
    ELSE
    }
      IF DBNO=TxFile {2} THEN
	IF (Cash1.XLASTTX>=1) AND (Cash1.XLASTTX<=DB1.DBRECHIGH) THEN SCHRECF:=Cash1.XLASTTX;

    (*
    IF (DBNO=2) AND NOT AUTORUN THEN
      BEGIN
	if (( DBNO = 2 ) and ( PROG in [21, 24] ) and
	   ( ACT = 11 ) and ( NOT AUTORUN )) then
	   begin
             date1 := null;
	     date2 := null;
             get_period ( PERIOD1, PERIOD2, DATE1, DATE2, ACT, NEXTLINE, fromdt, todt );
	     if ESCKEY then EXIT ( REPORTRUN );
	     IF DATE1 = NULL THEN
	       FROMDT := -32765
	     ELSE
	       BEGIN
		 DAYTOT1 := DAYTOT1 - 32000;
		 FROMDT	 := TRUNC ( DAYTOT1 );
	       END;

	     IF DATE2 = NULL THEN
	       TODT := +32765
	     ELSE
	       BEGIN
		 DAYTOT2 := DAYTOT2 - 32000;
		 TODT	 := TRUNC ( DAYTOT2 );
	       END;
             from_date := fromdt;
	     to_date := todt;
	   end

	else

	  begin

	    DIS (11,NEXTLINE,  'Transaction Date Range From: ');
	    DIS (36,NEXTLINE+1,'To: ');
	    REPEAT
	      no_func_key;
	      REC(40,NEXTLINE,8,'	 ',0,0,0,0,0,0);
	      IF ESCKEY THEN EXIT(REPORTRUN);
	    UNTIL (SCRINT=NULL) OR DATEVALID(SCRIN,'DD/MM/YY');
	    IF SCRINT=NULL THEN
	      FROMDT:=-32765
	    ELSE
	      BEGIN
		DAYTOT:=DAYTOT-32000;
		FROMDT:=TRUNC(DAYTOT);
	      END;
	    REPEAT
	      no_func_key;
	      REC(40,NEXTLINE+1,8,'	   ',0,0,0,0,0,0);
	      IF ESCKEY THEN EXIT(REPORTRUN);
	    UNTIL (SCRINT=NULL) OR DATEVALID(SCRIN,'DD/MM/YY');
	    IF SCRINT=NULL THEN
	      TODT:=+32765
	    ELSE
	      BEGIN
		DAYTOT:=DAYTOT-32000;
		TODT:=TRUNC(DAYTOT);
	      END;
	  end;
	NEXTLINE:=NEXTLINE+3;
      END;

    IF (ACT IN [5,6,7]) AND NOT AUTORUN THEN
      BEGIN
//	SETDB (1);

    If PROG = CustRep Then
       SETDB (SlFile)
    Else
       SETDB (PlFile)

	REPEAT
          DIS (19,NEXTLINE,  'Print Accounts From: ');
	  DIS (36,NEXTLINE+1,'To: ');
          STR (ACCMIN,ST);
	  REPEAT
	    window_position := 'L';
	    disp_options := true;
	    allow_exit := false;
	    F2_F3_active := true;
	    case PROG of
	      CUSTREP : search_action := 2;
	      SUPPREP : search_action := 3;
	    end;
	    search_db := 1;

	    REC(40,NEXTLINE,5,ST,0,40,40,1,-1,all_supp_cust);
	    IF ESCKEY THEN EXIT(REPORTRUN);
	    ST:=SCRIN;
	    UNTIL NUMERIC (SCRINT);
	  INTVAL (ACCMIN,SCRINT);
	  STR (ACCMAX,ST);
	  REPEAT
	    window_position := 'L';
	    disp_options := true;
	    allow_exit := false;
	    F2_F3_active := true;
	    case PROG of
	      CUSTREP : search_action := 2;
	      SUPPREP : search_action := 3;
	    end;
	    search_db := 1;

	    REC(40,NEXTLINE+1,5,ST,0,40,40,1,-1,all_supp_cust);
	    ST:=SCRIN;
	    UNTIL ESCKEY OR NUMERIC (SCRINT);
	  IF NOT ESCKEY THEN INTVAL (ACCMAX,SCRINT);
	UNTIL NOT ESCKEY AND (ACCMIN>0) AND NOT(ACCMAX<ACCMIN);
	NEXTLINE:=NEXTLINE+3;
	SETDB (DBNO);
      END;
    IF (ACT=10) AND NOT AUTORUN THEN
      BEGIN
	setdb ( 4 );
	FROMNOM := 1;
	TONOM	:= db1.dbrechigh;

	DIS (12,NEXTLINE,  'Nominal Account Range From: ');
	DIS (36,NEXTLINE+1,'To: ');

	REPEAT
	  IF (FROMNOM>=1) AND (FROMNOM<=9999)
	    THEN STR (FROMNOM,SCRIN)
	    ELSE SCRIN:='    ';
	  REPEAT
	    listto := 0;
	    listfrom := 0;

	    REC( 40, NEXTLINE, 4, SCRIN, 0, 40, 40, 4, -1, all_nom );
	    IF ESCKEY THEN EXIT(REPORTRUN);
	  UNTIL NUMERIC(SCRINT) OR (SCRINT=NULL);
	  IF SCRINT=NULL
	    THEN FROMNOM:=0
	    ELSE INTVAL(FROMNOM,SCRINT);
	  IF (TONOM>=1) AND (TONOM<=9999)
	    THEN STR (TONOM,SCRIN)
	    ELSE SCRIN:='    ';
	  REPEAT
	    REC( 40, NEXTLINE+1, 4, SCRIN, 0, 40, 40, 4, -1, all_nom );
	    IF ESCKEY THEN EXIT(REPORTRUN);
	  UNTIL NUMERIC(SCRINT) OR (SCRINT=NULL);
	  IF SCRINT=NULL
	    THEN TONOM:=9999
	    ELSE INTVAL(TONOM,SCRINT);
	UNTIL (FROMNOM>=0) AND (FROMNOM<=TONOM);
	NEXTLINE:=NEXTLINE+3;

	dis ( 11, NEXTLINE, 'Analysis Account Range From: ');
	DIS (36,NEXTLINE+1,'To: ');
	FROManl:=1;
	TOanl  :=999;
	REPEAT
	  IF (fromanl>=1) AND (fromanl<=999)
	    THEN STR (fromanl,SCRIN)
	    ELSE SCRIN:='    ';
	  REPEAT
	    REC(40,NEXTLINE,3,SCRIN,0,40,40,anl_db,-1,all_anl);
	    IF ESCKEY THEN EXIT(REPORTRUN);
	  UNTIL NUMERIC(SCRINT) OR (SCRINT=NULL);
	  IF SCRINT=NULL
	    THEN fromanl:=0
	    ELSE INTVAL(fromanl,SCRINT);
	  IF (toanl>=1) AND (toanl<=999)
	    THEN STR (toanl,SCRIN)
	    ELSE SCRIN:='    ';
	  REPEAT
	    REC(40,NEXTLINE+1,3,SCRIN,0,40,40,anl_db,-1,all_anl);
	    IF ESCKEY THEN EXIT(REPORTRUN);
	  UNTIL NUMERIC(SCRINT) OR (SCRINT=NULL);
	  IF SCRINT=NULL
	    THEN toanl:=999
	    ELSE INTVAL(toanl,SCRINT);
	UNTIL (fromanl>=0) AND (fromanl<=toanl);
	NEXTLINE:=NEXTLINE+3;
      END;

    IF ((PROG=SUPPREP) AND (ACT=11)) AND (NOT AUTORUN) THEN
      BEGIN
	DIS ( 14-LENGTH(XTAXCODE), NEXTLINE,
	      CONCAT('Print ',XTAXCODE,' Audit Trail (Y/N): '));
	askyes ( 40, nextline, taxaudit, 0 );
	NEXTLINE:=NEXTLINE+2;
      END;
    *)
    NOHEADING:=FALSE;
    {
    PRINTSEL :='N';
    }
    NUMBERONE:=TRUE;
    VERYFIRST:=TRUE;
    NEXTCOL  :=9;

    If ACT In [1,2] Then
       Begin
//            Cash1.xDate      := CustSuppListing.RepDate.Text;
            SchRecF    := StrToInt ( CustSuppListing.AccFrom.Text );
            SchRecT    := StrToInt ( CustSuppListing.AccTo.Text );
            Area_From  := StrToInt ( CustSuppListing.AreaFrom.Text );
            Area_To    := StrToInt ( CustSuppListing.AreaTo.Text );
            SortRep    := False;{( Area_To > 0 );}
            //if Area_To > 0 then SortRep := True
            //   else SortRep := False;
            MinimumBalance  := ( CustSuppListing.Minbalance.Checked );
       End
    Else
        If ( ACT = 11 ) Then
           Begin
              SchRecF  := NominalReportForm.TransFrom;
              SchRecT  := NominalReportForm.TransTo;
              Tx_Start := SchRecF;
              Tx_End   := SchRecT;
              FromDt   := NominalReportForm.TxDateFrom;
              ToDt     := NominalReportForm.TxDateTo;
              If ( FromDt <> CdateFrom ) And ( ToDt <> CDateTo ) Then
                 Begin
                    KDateToStr ( FromDt, Date1 );
                    KDateToStr ( ToDt, Date2 );
                 End
              Else
                 Begin
                    Date1 := Null;
                    Date2 := Null;
                 End;
              TaxAudit := NominalReportForm.VatAuditChecked.Checked;
           End
        Else
           Begin
             {xDate      := CustSuppInvListing.RepDate.Text;}
             If ACT <> 8 Then                              { Tx Control Summary }
               Begin
                    If Numeric ( CustSuppInvListing.AccFrom.Text ) Then
                       Begin
                            AccMin     := StrToInt ( CustSuppInvListing.AccFrom.Text );
                            AccMax     := StrToInt ( CustSuppInvListing.AccTo.Text );
                       End;
               End;
             If Numeric ( CustSuppInvListing.TxFrom.Text ) Then
               Begin
                    SchRecF    := StrToInt ( CustSuppInvListing.TxFrom.Text );
                    SchRecT    := StrToInt ( CustSuppInvListing.TxTo.Text );
               End;

             INCLANAL   := ( CustSuppInvListing.IncludeBreakDown.Checked );
             If CustSuppInvListing.TxDateFrom <> 0 Then
               Begin
                    FROMDT     := CustSuppInvListing.TxDateFrom;
                    TODT       := CustSuppInvListing.TxDateTo;
               End;
           End;

    REPSETITEMS;
     // this bit sets the report column heading to the field names GM 21/06/04
    FOR X:=1 TO MAXC DO
      BEGIN
	SETDB(DBNO);
	IF REPITEMS[X] IN [1..MAXITEMS] THEN
	  BEGIN
	    ITEM:=REPITEMS[X];
	    ITEMCOL[X]:=NEXTCOL;
	    DISSIZE:=LENGTH(DB1.DBITEMS[ITEM].DBINAME);
	    IF DB1.DBITEMS[ITEM].DBITYPE[0] IN ['L','M']
	      THEN DATASIZE:=12
	      ELSE DATASIZE:=DB1.DBITEMS[ITEM].DBISIZE;
	    IF DATASIZE>DISSIZE THEN DISSIZE:=DATASIZE;
	    If (( dbno In [SlFile, PlFile] {=1} ) And ( prog in [custrep, supprep] ) And
		( act = 2 ) and ( x = 2 )) Then
	      dissize := 15;
	    NEXTCOL:=NEXTCOL+DISSIZE+1;
	  END;
	IF REPITEMS[X]=102 THEN
	  BEGIN
	    ITEMCOL[X]:=NEXTCOL;
	    NEXTCOL:=NEXTCOL+35;
	  END;
      END;
    TOTRECS:=0;
    AMTTOT :=0;
    TAXDTOT:=0;
    PAGENO :=0;
    CASE ACT OF
      1,2,5,6,7 : BEGIN
		    If ( NOT SortRep ) Then
		      REPHEADINGS;
		    PROCESSFILE;
		  END;
      3		: CUSTSUMMARY;
      8,11	: TRANSSUMMARY;
     10		: ANALSUMMARY;
{
     13		: Begin
		    repheadings;
		    processanl;
		  End;
}
    END;

    IF ((PROG in [SUPPREP,custrep]) AND (ACT=11) AND
	(NOT AUTORUN) and (esckey)) THEN
      exit ;

    IF NOT ESCKEY AND NOT (ACT IN [3,8,10,11]) THEN
      Begin
          If ( NOT ( ACT In [8,11] )) Then
             PrintTots;
          ENDPRINT;
      End;

    {
    IF NOT AUTORUN THEN CLOSE(PRINTFILE,LOCK);
    IF (( NOT AUTORUN ) and ( Device = 'P' )) THEN
      CLOSE ( PRINTFILE )
    else
      if (( NOT AUTORUN ) and ( Device = 'F' )) then
         close ( PRINTFILE );
      else
	if (( NOT AUTORUN ) and ( Device = 'S' )) then
	  begin
	    if (( line_no > 0 ) and ( line_no < 66 )) then
	      begin
		FP_init_remainder;
		SCR_disp_page;
	      end;
	  end;
    IF (( NOT ESCKEY AND NOT AUTORUN ) and ( Device <> 'S' )) THEN
      CONTINUE;
    }
  END;							{ end REPORTRUN }

  PROCEDURE SHOWMENU;
  BEGIN							 { begin SHOWMENU }
    {
    BETASCREEN(SUBSYS);
    BETAUSER;
    DIS (8, 6,' 1 ... Account Listing');
    DIS (8, 7,' 2 ... Age-of-Debt Summary');
    DIS (8, 8,' 3 ... Account Control Summary');
    DIS (8, 9,' 4 ... Enquire Account Status on Screen');
    DIS (8,11,' 5 ... Invoice Listing');
    DIS (8,12,' 6 ... Payment Listing');
    DIS (8,13,' 7 ... Credit Note Listing');
    DIS (8,14,' 8 ... Transaction Control Summary');
    DIS (8,16,' 9 ... Print End of Month Reports (2,5-8)');
    DIS (8,18,'99 ... Return to Main Menu');
    BETAMENU;
    }
    {
    first_disp := true;
    }
    AUTORUN    :=FALSE;
    AUTOFIRST  :=FALSE;
{
    FROMDT     :=-32765;
    TODT       :=+32765;
}
    FROMNOM    :=1;
    TONOM      :=Cash1.XNOMOPEN;
  END;							{ end SHOWMENU }

  PROCEDURE MAINFLOW;
  BEGIN							{ begin MAINFLOW }
    ACT:=0;
{
    REPEAT
}
      IF AUTOPROG=0 THEN
	BEGIN
	  SHOWMENU;
	  act := option;
	End
      else
	Begin
	  act := autoprog;
	End;
{
	  REPEAT
	    no_func_key;
	    REC (30,24,2,'  ',0);
	    IF ESCKEY OR (SCRINT='M') OR (SCRINT='m') THEN SCRINT:='99';
	    WORKSTR:=SCRIN;
	    ACT:=0;
	    IF NUMERIC(SCRINT) THEN INTVAL(ACT,SCRINT);
	  UNTIL ACT IN [1..9,99];
	END
      ELSE
	ACT:=AUTOPROG;
}
      IF ACT IN [1..4] THEN
	BEGIN
	  FLNAME:='ACCOUNTS';
	  SETDB(DataBase);
	  DBNO:=DataBase; { 1 }
	END
      ELSE
	BEGIN
	  FLNAME:='TRANSACTIONS';
	  SETDB(TxFile);
	  DBNO:=TxFile;
	END;
      IF ACT=99 THEN EXIT;
      AUTORUN:=FALSE;
      IF NOT ESCKEY THEN
	BEGIN
	  IF ACT IN [1..3,5..8,10] THEN
             REPORTRUN
          Else
              If ACT = 11 Then
                 Begin
                      ReportRun;
                      Prog := SUPPREP;
                      ReportRun;
                 End;
	  IF ACT=12 THEN
	    BEGIN
	      AUTORUN  :=TRUE;
	      AUTOFIRST:=FALSE;
	      FLNAME:='TRANSACTIONS';
	      SETDB(TxFile);
	      DBNO:=TxFile;
	      ACT :=11;
	      REPORTRUN;
	    END;
(*
	  if act = 13 then   { * analysis listing }
	    Begin
	      dbno := anl_db;
	      setdb ( anl_db );
	      reportrun;
	    End;
*)
	END;
{
    UNTIL AUTOPROG>0;
}
  END;							 { end MAINFLOW }
       { Procedure declared at top of CBA.SPREPA.TEXT }

BEGIN							{ begin REP }
    {
    OPENFILES;
    IF ESCKEY THEN EXIT;
    }
    NEXTCOL  :=1;
    COLHIGH  :=1;
    AUTORUN  :=FALSE;
    (*
    taxaudit := False;{'N';}
    *)

{
    date1    := null;
    date2    := null;
}
    SortRep   := False;
    Curr_Time := TimeToStr ( Time );
{
    head_areaa := 0;
}
    AUTOFIRST:=FALSE;

    FROMDT   := -32765;
    TODT     :=+32765;
{

    FROMNOM  :=1;
    TONOM    :=XNOMOPEN;
}
    INCLANAL := False;  { Include Invoice breakdown }
    fromanl  := 0;
    toanl    := 9999; // was 999
    BLANKLINE;
    MAINFLOW;

END;							 { end REP }

Begin

End.
