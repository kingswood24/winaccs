unit Nsprint;

interface
         
PROCEDURE BUILDLINE(COL: INTEGER; STRVAL: STRING);
PROCEDURE OUTPUTLINE;
PROCEDURE SKIPSCREEN(LINES: INTEGER);
PROCEDURE BLANKLINE;
Procedure get_cust_supp;
Function CheckNextTx( db, RecTx : Integer ) : Boolean;
PROCEDURE TOTALRECS;

implementation
Uses
    NomReps,
    types,
    util,
    clears,
    DbCore,
    params,
    calcs,
    DBRPT,
    abortprg,
    filed,
    vars,
    dbgen;

  PROCEDURE BUILDLINE;
  BEGIN							{ begin BUILDLINE }
    IF COL=0 THEN COL:=NEXTCOL;
    IF STRVAL='' THEN EXIT;
    IF COL+LENGTH(STRVAL)-1 IN [1..255] THEN
      MOVE(STRVAL[1],PLINE[COL],LENGTH(STRVAL));
    NEXTCOL:=COL+LENGTH(STRVAL);
    IF NEXTCOL>COLHIGH THEN COLHIGH:=NEXTCOL;
  END;							 { end BUILDLINE }

  PROCEDURE OUTPUTLINE;
  VAR
    X : INTEGER;
  BEGIN							 { begin OUTPUTLINE }
    IF (PROG=SPECREP) AND (ACT=4) THEN EXIT;
    X := COLHIGH;
    IF X > RFarmGate.PLINEWIDTH[1] THEN X := RFarmGate.PLINEWIDTH[1];
    If ( act = 121 ) And BalanceSheet Then
      X := 79;
    IF X < 1 THEN X := 1;

    if Device[1] = 'S' then
      X := 132;

    SENDLINE (COPY(PLINE,1,X));
    IF ESCKEY THEN
      EXIT;

    {LINECOUNT := LINECOUNT + 1;}
    COLHIGH := 1;
    NEXTCOL := 1;
  END;						       { end OUTPUTLINE }

  PROCEDURE SKIPSCREEN;
  BEGIN						       { begin SKIPSCREEN }
    LINECOUNT := LINECOUNT + LINES;
  END;						       { end SKIPSCREEN }

  PROCEDURE BLANKLINE;
  VAR
    X : INTEGER;
  BEGIN						       { begin BLANKLINE }
    If Device[1] <> 'S' then
      Begin
	PLINE:=NULL;
	FOR X:=1 TO 6 DO PLINE:=CONCAT(PLINE,SPACE40);
	PLINE:=CONCAT(PLINE,COPY(SPACE40,1,15));
	COLHIGH:=1;
      End;
    {
    else
      FP_new_line ( Pline );
    }

  END;						       { end BLANKLINE }

  (*
  PROCEDURE DASHLINE;
  BEGIN						       { begin DASHLINE }
    if Device[1] <> 'S' then
      begin
	BLANKLINE;
	FILLCHAR(PLINE[1],255,'-');
	COLHIGH:=255;
	OUTPUTLINE;
	BLANKLINE;
      end;
  END;							{ end DASHLINE }
  *)

  (*
  Procedure to read the sales or purchase ledger to locate the customer
  supplier name and also read backwards through the transaction file to
  get the description from the first line of the transaction. The transaction
  file is read if the original type ( item 23 ) is 11 or 15, it is read until
  the first line is reached ie ( item 1 ) is 11 or 15 or 22 records have
  been read.
  *)
  Procedure get_cust_supp;
  var
    all_ok	    : boolean;				       { loop guard }
    i,							  { general counter }
    slpl_rec,				    { sales or purchase account no. }
    tx_type,					  { transaction type item 1 }
    orig_type,				{ transaction original type item 23 }
    read_trans,				{ transaction record number counter }
    store_trans : integer;	    { store the original transaction number }

  Begin	  { get_cust_supp }

    store_trans := currrec[TxFile];	     { store the current transaction record }
    read_trans	:= store_trans - 1;    { set the transaction record to read }
    all_ok := false;
    cust_supp := null;
    if read_trans = 0 then exit;

    getitem ( TxFile, 1 );
{-->>    tx_type := currint;}				   { store transaction type }
    getitem ( TxFile, 23 );
    orig_type := currint;		  { store original transaction type }
    getitem ( TxFile, 3 );
    slpl_rec := currint;       { store the account number ie sales or purch }
    If orig_type in [ 11, 15 ] Then
      Begin
	i := 1;
	Repeat
	  readrec ( TxFile, read_trans );

	  If errorno > 0 Then DbErr;
	  getitem ( TxFile, 1 );
	  tx_type := currint;
	  If tx_type = orig_type Then
	    Begin
	      getitem ( TxFile, 5 );
	      cust_supp := currstr;
	      getitem ( TxFile, 4 );
	      comment_cust_supp := currstr;

	      all_ok := true;
	    End;
	  i := i + 1;
	  read_trans := read_trans - 1;
	Until all_ok or ( i > 22 ) or ( read_trans <= 0 );
	setdb ( TxFile );			      { set db to transaction file }
	readrec ( TxFile, store_trans );	     { read the current transaction }
	if errorno > 0 then DbErr;
      End
    else
      if orig_type in [ 0 ] then
	Begin
	  getitem ( TxFile, 5 );
	  cust_supp := currstr;
	  getitem ( TxFile, 4 );
	  comment_cust_supp := currstr;
{-->>	  all_ok := true;}
	End
      else
	if orig_type in [1..3,5..7] then       // TGM AB was 5..6
	  Begin
	    case orig_type of
	      1,
	      2,
	      3 : Begin				    { setdb to sales ledger }
		    setdb ( SlFile );
		    readrec ( SlFile, slpl_rec );
		    if errorno > 0 then DbErr;
		    getitem ( SlFile, 1 );
		    cust_supp := currstr;

		    i := 1;
		    Setdb ( TxFile );
		    Read_Trans := Store_Trans;

		    repeat
		      readrec ( TxFile, read_trans );

		      if errorno > 0 then DbErr;
		      getitem ( TxFile, 1 );
		      tx_type := currint;
		      if tx_type = orig_type then
			Begin
			  getitem ( TxFile, 5 );
			  comment_cust_supp := currstr;
			  all_ok := true;
			End;
		      i := i + 1;
		      read_trans := read_trans - 1;
		    until all_ok or ( i > 22 ) or ( read_trans <= 0 );
		    setdb ( TxFile );			  { set db to transaction file }
		    readrec ( TxFile, store_trans );		 { read the current transaction }
		    if errorno > 0 then DbErr;
		  End;
	      5,
	      6,
	      7 : Begin
		    setdb ( PlFile );		 { setdb to purchase ledger }
		    readrec ( Plfile, slpl_rec );
		    if errorno > 0 then DbErr;
		    getitem ( PlFile, 1 );
		    cust_supp := currstr;

		    Setdb ( TxFile );
		    i := 1;
		    Read_Trans := Store_Trans;

		    repeat
		      readrec ( TxFile, read_trans );

		      if errorno > 0 then DbErr;
		      getitem ( TxFile, 1 );
		      tx_type := currint;
		      if tx_type = orig_type then
			Begin
			  getitem ( TxFile, 5 );
			  comment_cust_supp := currstr;
			  all_ok := true;
			End;
		      i := i + 1;
		      read_trans := read_trans - 1;
		    until all_ok or ( i > 22 ) or ( read_trans <= 0 );
		    setdb ( TxFile );			  { set db to transaction file }
		    readrec ( TxFile, store_trans );		 { read the current transaction }
		    if errorno > 0 then DbErr;

		  End;
	    End;
{-->>	    all_ok := true;}
	  End;
  End;	  { get_cust_supp }

  Function CheckNextTx;{ ( db, RecTx : Integer ) : Boolean;}
    Var
      ThisType : Integer;

    Begin
      CheckNextTx := False;
      GetItem ( TxFile, 1 );
      ThisType := Currint;
      GetItem ( TxFile, 10 );

      If (( ThisType = 9 ) And ( Length ( Currstr ) = 1 )) Then
	 Begin
	    SetDb ( db );
	    If RecTx+1 <= db1.dbrechigh Then
	       Begin
		  ReadRec ( db, RecTx+1 );
		  If Errorno > 0 Then DbErr;
		  If Recactive ( db ) Then
		     Begin
			GetItem ( TxFile, 10 );
			If ( currstr <> SPACE1 ) Then
			   Begin
			      GetItem ( TxFile, 1 );
			      CheckNextTx := ( Currint <> 0 );
			   End;
		     End;
	       End;
	    { ReRead the Current Record }
	    ReadRec ( db, RecTx );
	    If ErrorNo > 0 Then DbErr;
	 End;
    End;

  PROCEDURE TOTALRECS;
  Begin							 { begin TOTALRECS }
    TOTRECS:=TOTRECS+1;

    {** Specreps Only }
    IF PROG=SPECREP THEN
      BEGIN
	IF ACT IN [6,4,100] THEN
	  BEGIN
	    GETITEM(NlFile,2);
	    IF CURRLONG>0
	      THEN DBTOT:=DBTOT+CURRLONG
	      ELSE CRTOT:=CRTOT-CURRLONG;
	  END;
	IF ACT IN [1,2,11,12] THEN
	  BEGIN
	    IF ACT IN [11,12] THEN SUBREC:=SUBREC+1;
	    GETITEM(TxFile,9);
	    IF (ACT IN [11,12]) AND (NEG)
	      THEN AMTTOT:=AMTTOT-CURRLONG
	      ELSE AMTTOT:=AMTTOT+CURRLONG;
	    IF ACT IN [11,12] THEN
	      IF NEG
		THEN SUBAMT:=SUBAMT-CURRLONG
		ELSE SUBAMT:=SUBAMT+CURRLONG;
	    GETITEM(TxFile,11);
	    IF (ACT IN [11,12]) AND (NEG)
	      THEN TAXDTOT:=TAXDTOT-CURRLONG
	      ELSE TAXDTOT:=TAXDTOT+CURRLONG;
	    IF ACT IN [11,12] THEN
	      IF NEG
		THEN SUBTAX:=SUBTAX-CURRLONG
		ELSE SUBTAX:=SUBTAX+CURRLONG;
	  END;
      END;
  END;						      { end TOTALRECS }

end.
 