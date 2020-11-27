unit  UPrintOut;

interface

Procedure PrintOut ( Print : Boolean );

implementation
Uses
    TotalTx,
    SysUtils,
    NominalReports,
    NsRep11,
    NsPrint,
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

  PROCEDURE PRINTOUT (PRINT: BOOLEAN);	  { begin in CBA.NSREPC.TEXT }
  CONST
    STUBTX = 999;
  VAR
    CurrDbl      : Double;   { Used to store currlong if needs to be passed as double }
    save_name,
    overhead_perc : ShortString;	       { store the last 3 chars from ent name }
    perc_over	  : integer;	   { store the converted string overhead_perc }
    
    DEBIT      : INTEGER;
    SUB	       : INTEGER;
    ROW	       : INTEGER;
    LINESSPARE : INTEGER;
    PR	       : BOOLEAN;
    WORKSTR    : ShortSTRING {80};
    TOT	       : INTEGER;
    CURRBAL    : Double{LONG};
    OPENBAL    : Double{LONG};
    X	       : INTEGER;
    AMT	       : Double{LONG};
    TAX	       : Double{LONG};
    TXT	       : INTEGER;
    SAVEREC    : INTEGER;
    TXTRAIL    : PACKED ARRAY [1..STUBTX] OF INTEGER;
    TXTOTAL    : INTEGER;
    STATUS     : STRING{[1]};
    EDITST     : STRING{[1]};
    TXQUAN     : Double{LONG};
    RUNBAL     : Double{LONG};
    STUBTYPE   : STRING{[3]};
    print_inc_tot,
    print_exp_tot : boolean;
    second_run : boolean;	   { bank audit trail 2nd run no sorting flag }

    { used to check EU entered VAT Code from the Invoicer }
    TransType  : Integer;
    VatAmt     : Double{Long};
    VatCode    : String{[1]};
    EditStat   : String{[1]};
    NegSign    : Integer;

    (*
    PROCEDURE SCREENTOP;
    VAR
      NEG : BOOLEAN;
    BEGIN					      { begin SCREENTOP }

      CLEARFROM (4);
      BETALINE;
      NEG:=    (BANKBAL[12]='-');
      DIS   ( 4, 6,'Bank A/c: ');
      HDISI (14, 6, BANKNO,1);
      HDIS  (19, 6, BANKNAME);
      DIS   (50, 6,'Balance: ');
      HDIS  (59, 6, COPY(BANKBAL,2,10));
      IF NEG THEN HDIS (70,6,'(Overdrawn)');
      IDIS  ( 1, 9,CONCAT(SPACE40,SPACE40));
      IDIS  ( 2, 9,'Tran     Receipt	  Payment     Stub-No	Status	  Date	    Comment');
      DIS   ( 1,10,UNDLINE);
      ROW:=10;
    END;					      { end SCREENTOP }
    *)

    PROCEDURE BLANKNEXT;
    VAR
      X : INTEGER;
    BEGIN					      { begin BLANKNEXT }
      if ( Device[1] in ['C','P','S'] ) then
	IF LINECOUNT+4>RFarmGate.PLINESPAGE[1] THEN
	  REPHEADINGS;
      PLINE:=NULL;
      FOR X:=1 TO 6 DO PLINE:=CONCAT(PLINE,SPACE40);
      PLINE:=CONCAT(PLINE,COPY(SPACE40,1,15));
      COLHIGH:=1;
    END;					       { end BLANKNEXT }

    PROCEDURE MINSIZE(VAR ST: ShortSTRING; SZ: INTEGER);
    BEGIN					       { begin MINSIZE }
      REPEAT
	IF LENGTH(ST)<SZ THEN ST:=CONCAT(SPACE1,ST);
      UNTIL NOT(LENGTH(ST)<SZ);
    END;					       { end MINSIZE }

    PROCEDURE PRINTDETAIL (BANKTYPE: STRING);
    VAR
      TxCounter,
      SUB      : INTEGER;
      SUB1     : INTEGER;
      DBAC     : INTEGER;
      CRAC     : INTEGER;
      OK       : BOOLEAN;
      ST       : ShortSTRING;
      TEST     : STRING{[1]};
      t_date,
      l_date,
      TESTSTUB : STRING{[8]};
      TESTTXT  : INTEGER;
      TESTDATE : INTEGER;
      STUB     : LONG;
      STUB1    : SmallInt;
      STUB2    : SmallInt;
      TXSTART  : INTEGER;
      TXDATE   : STRING{[8]};
      TXCOMM   : STRING{[15]};
      ANY      : BOOLEAN;
      BANK_REC : STRING{[1]};   (* temp var to store the bank_rec 'P','U' or 'E'*)
      curr_trans : integer;

      read_next,
      sortpos,
      sortblk  : integer;
      sortwork : packed array [1..512] of char;

      { this procedure sets the next record to read }
      Procedure next_trans ( var update_read_no : integer );
      Begin
	if sortpos + 2 > 513 then
	  Begin
	    sortblk := sortblk + 1;
	    sortpos := 1;
//	    If cread ( 8, 1, sortblk ) < 1 then AbortProgram ( seqerr );
	    If cread ( SortFileNo, 1, sortblk ) < 1 then AbortProgram ( seqerr );
	    Move ( cblocks[1], sortwork[1], 512 );
	  End;
	move ( sortwork[sortpos], update_read_no, 2 );
	sortpos := sortpos + 2;
	if update_read_no > 30000 then update_read_no := 0;
      End;

      PROCEDURE OTHERVALUES;
      VAR
	CURRBAL	   : LONG;
	STYEAR	   : LONG;
	STPERIOD   : LONG;
	MOVEYEAR   : LONG;
	MOVEPERIOD : LONG;
	BUDYEAR	   : LONG;
	BUDYVAR	   : LONG;
	MOVELAST   : LONG;

	PROCEDURE OV1;
	BEGIN					     { begin OV1 }
	  GETITEM(NlFile,2);
	  CURRBAL:=CURRLONG;
	  GETITEM(NlFile,3);
	  STPERIOD:=CURRLONG;
	  GETITEM(NlFile,4);
	  STYEAR:=CURRLONG;
	  MOVEYEAR  :=CURRBAL-STYEAR;
	  MOVEPERIOD:=CURRBAL-STPERIOD;
	  GETITEM(NlFile,7);
	  BUDYEAR:=CURRLONG;
	  BUDYVAR:=BUDYEAR   - (CURRBAL-STYEAR);
	  GETITEM (NlFile,17);
	  MOVELAST:=CURRLONG;
	  IF NOMYS THEN
	    BEGIN
	      BLANKLINE;

	      If ( Device[1] in ['C','F','P','S'] ) then
		IF LINECOUNT+4>RFarmGate.PLINESPAGE[1] THEN
		  REPHEADINGS;
	      CURRLONG:=STYEAR;
              CurrDbl := CurrLong;
              DoubleToStr ( CurrDbl, WorkStr, '%f', True, True, 11, False );
              {
              LONGSTR(CURRLONG,WORKSTR,'L');
	      WORKSTR[12]:=SPACE1;
	      }
              BUILDLINE(25,'-');
	      BUILDLINE(38,'-');
	      IF CURRLONG > 0 THEN BUILDLINE(17,WORKSTR);
	      IF CURRLONG < 0 THEN BUILDLINE(30,WORKSTR);
	      BUILDLINE(1,'YEAR OPENING');
	      OUTPUTLINE;
	      IF ESCKEY THEN EXIT;
	    END;
	END;						{ end OV1 }

	PROCEDURE OV2;
	BEGIN						{ begin OV2 }
	  IF NOMYM THEN
	    BEGIN
	      BLANKLINE;
	      if ( Device[1] in ['C','F','P','S'] ) then
		IF LINECOUNT+4>RFarmGate.PLINESPAGE[1] THEN
		  REPHEADINGS;
	      CURRLONG:=MOVEYEAR;
              CurrDbl := CurrLong;
              DoubleToStr ( CurrDbl, WorkStr, '%f', True, True, 11, False );
              {
	      LONGSTR(CURRLONG,WORKSTR,'L');
	      WORKSTR[12]:=SPACE1;
	      }
              BUILDLINE(25,'-');
	      BUILDLINE(38,'-');
	      IF CURRDBL > 0 THEN BUILDLINE(17,WORKSTR);
	      IF CURRDBL < 0 THEN BUILDLINE(30,WORKSTR);
	      BUILDLINE(1,'YEAR MOVEMENT');
	      OUTPUTLINE;
	      IF ESCKEY THEN EXIT;
	    END;
	  IF NOMPS THEN
	    BEGIN
	      BLANKLINE;

	      if ( Device[1] in ['C','F','P','S'] ) then
		IF LINECOUNT+4>RFarmGate.PLINESPAGE[1] THEN
		  REPHEADINGS;
	      CURRLONG:=STPERIOD;
              CurrDbl := CurrLong;
              DoubleToStr ( CurrDbl, St, '%f', True, True, 11, False );
              {
	      LONGSTR(CURRLONG,WORKSTR,'L');
	      WORKSTR[12]:=SPACE1;
	      }
              BUILDLINE(25,'-');
	      BUILDLINE(38,'-');
	      IF CURRDBL > 0 THEN BUILDLINE(17,ST);
	      IF CURRDBL < 0 THEN BUILDLINE(30,ST);
	      BUILDLINE(1,'PERIOD OPENING');
	      OUTPUTLINE;
	      IF ESCKEY THEN EXIT;
	    END;
	  IF NOMPM THEN
	    BEGIN
	      BLANKLINE;

	      if ( Device[1] in ['C','F','P','S'] ) then
		IF LINECOUNT+4>RFarmGate.PLINESPAGE[1] THEN
		  REPHEADINGS;
	      CURRLONG:=MOVEPERIOD;
              CurrDbl := CurrLong;
              DoubleToStr ( CurrDbl, WorkStr, '%f', True, True, 11, False );
              {
	      LONGSTR(CURRLONG,WORKSTR,'L');
	      WORKSTR[12]:=SPACE1;
	      }
              BUILDLINE(25,'-');
	      BUILDLINE(38,'-');
	      IF CURRDBL > 0 THEN BUILDLINE(17,WORKSTR);
	      IF CURRDBL < 0 THEN BUILDLINE(30,WORKSTR);
	      BUILDLINE(1,'PERIOD MOVEMENT');
	      OUTPUTLINE;
	      IF ESCKEY THEN EXIT;
	    END;
	 END;					       { end OV2 }

       BEGIN					       { begin OTHERVALUES }
	OV1;
	OV2;
	IF NOMYB THEN
	  BEGIN
	    BLANKLINE;

	    if ( Device[1] in ['C','F','P','S'] ) then
	      IF LINECOUNT+4>RFarmGate.PLINESPAGE[1] THEN
		REPHEADINGS;
	    CURRLONG:=BUDYEAR;
            Currdbl := CurrLong;
            DoubleToStr ( CurrDbl, WorkStr, '%f', True, True, 11, False );
            {
	    LONGSTR(CURRLONG,WORKSTR,'L');
	    WORKSTR[12]:=SPACE1;
	    }
            BUILDLINE(25,'-');
	    BUILDLINE(38,'-');
	    IF CURRDBL > 0 THEN BUILDLINE(17,WORKSTR);
	    IF CURRDBL < 0 THEN BUILDLINE(30,WORKSTR);
	    BUILDLINE(1,'YEAR BUDGET');
	    OUTPUTLINE;
	    IF ESCKEY THEN EXIT;
	  END;
	IF NOMLYM THEN
	  BEGIN
	    BLANKLINE;

	    if ( Device[1] in ['C','F','P','S'] ) then
	      IF LINECOUNT+4>RFarmGate.PLINESPAGE[1] THEN
		REPHEADINGS;
	    CURRLONG:=MOVELAST;
            CurrDbl := CurrLong;
            DoubleToStr ( CurrDbl, WorkStr, '%f', True, True, 11, False );
            {
	    LONGSTR(CURRLONG,WORKSTR,'L');
	    WORKSTR[12]:=SPACE1;
	    }
            BUILDLINE(25,'-');
	    BUILDLINE(38,'-');
	    IF CURRDBL > 0 THEN BUILDLINE(17,WORKSTR);
	    IF CURRDBL < 0 THEN BUILDLINE(30,WORKSTR);
	    BUILDLINE(1,'LAST YEAR MOVEMENT');
	    OUTPUTLINE;
	    IF ESCKEY THEN EXIT;
	  END;
	IF NOMYBV THEN
	  BEGIN
	    BLANKLINE;
	    if ( Device[1] in ['C','F','P','S'] ) then
	      IF LINECOUNT+4>RFarmGate.PLINESPAGE[1] THEN
		REPHEADINGS;
	    CURRLONG:=BUDYVAR;
            CurrDbl := CurrLong;
            DoubleToStr ( CurrDbl, WorkStr, '%f', True, True, 11, False );
            {
	    LONGSTR(CURRLONG,WORKSTR,'L');
	    WORKSTR[12]:=SPACE1;
	    }
            BUILDLINE(25,'-');
	    BUILDLINE(38,'-');
	    IF CURRDBL > 0 THEN BUILDLINE(17,WORKSTR);
	    IF CURRDBL < 0 THEN BUILDLINE(30,WORKSTR);
	    BUILDLINE(1,'YEAR BUDGET DIFF');
	    OUTPUTLINE;
	    IF ESCKEY THEN EXIT;
	  END;
      END;					      { end OTHERVALUES }

      PROCEDURE PRINTTRAN;
      BEGIN					      { begin PRINTTRAN }
	{* get transaction number ready to print }
	STR(CURRREC[TxFile],ST);
	MINSIZE(ST,5);
	if act = 5 then
	  buildline ( 79, st )
	Else
	  If act = 7 Then
	    buildline ( 1, st )
	  Else
	    buildline ( 13, ST );

	{* insert dashes for amount }
	BUILDLINE(25,'-');
	BUILDLINE(38,'-');

	{* get nominal amount from transaction }
	GETITEM(TxFile,17);
        CurrDbl := CurrLong;
        DoubleToStr ( CurrDbl, St, '%f', True, True, 11, False );
        {LONGSTR(CURRLONG,ST,'L');}

	{* if current nominal account = nominal debit account on transaction }
	IF DBAC=CURRREC[NlFile] THEN
	  BEGIN
	    TXDEBIT:=TXDEBIT+CURRLONG;
	    RUNBAL :=RUNBAL +CURRLONG;
	    BUILDLINE(18,COPY(ST,2,11));
	    {
	    STR(CRAC,ST);
	    MINSIZE(ST,5);
	    if act <> 5 then
	      Begin
		BUILDLINE(43,'(CR ');
		BUILDLINE(46,ST);
		BUILDLINE(51,')');
	      End;
	    }
	  END;

	{* if current nominal account = nominal credit account on transaction }
	IF CRAC=CURRREC[NlFile] THEN
	  BEGIN
	    TXCREDIT:=TXCREDIT+CURRLONG;
	    RUNBAL  :=RUNBAL  -CURRLONG;
	    BUILDLINE(31,COPY(ST,2,11));
	    {
	    STR(DBAC,ST);
	    MINSIZE(ST,5);
	    if act <> 5 then
	      Begin
		BUILDLINE(43,'(DB ');
		BUILDLINE(46,ST);
		BUILDLINE(51,')');
	      End;
	    }
	  END;

	{* get the transacion date }
	GETITEM(TxFile,2);
	if act = 5 then
	  buildline ( 50, currstr )
	else
	  if act = 7 Then
	    buildline ( 42, currstr )
	  Else
	    BUILDLINE ( 53, CURRSTR );

	{* if running Full Nominal Audit Trail ( act - 7 )}
	IF ACT=7 THEN
	  BEGIN
	    buildline ( 9, stubno );
	    getitem ( TxFile, 4 );
	    buildline ( 51, CURRSTR );

	    BUILDLINE(68,'-');
	    BUILDLINE(81,'-');
            DoubleToStr ( RunBal, St, '%f', True, True, 11, False );
	    {
            LONGSTR(RUNBAL,ST,'L');
	    ST[12]:=SPACE1;
	    }
            IF RUNBAL>0 THEN BUILDLINE(60,ST);
	    IF RUNBAL<0 THEN BUILDLINE(73,ST);
	    GETITEM(TxFile,6);
            CurrDbl := CurrLong;
	    TXQUAN:=TXQUAN+CURRDbl;
            DoubleToStr ( CurrDbl, CurrStr, '%f', True, True, 11, False );
	    {
            LONGSTR(CURRLONG,CURRSTR,'L');
	    }
            BUILDLINE(84,CURRSTR);
	    {
	    buildline ( 43, stubno );
	    GETITEM(2,4);
	    BUILDLINE(62,CURRSTR);
	    BUILDLINE(79,'-');
	    BUILDLINE(92,'-');
	    LONGSTR(RUNBAL,ST,'L');
	    ST[12]:=SPACE1;
	    IF RUNBAL>0 THEN BUILDLINE(71,ST);
	    IF RUNBAL<0 THEN BUILDLINE(84,ST);
	    GETITEM(2,6);
	    TXQUAN:=TXQUAN+CURRLONG;
	    LONGSTR(CURRLONG,CURRSTR,'L');
	    BUILDLINE(97,CURRSTR);
	    }

	    { ** 18-04-94 changed to output the description or Customer/Supplier
	      on the nominal ledger Audit Trail }
	    get_cust_supp;
	    {* remove characters over 20 as not enough room on report }
	    PadRight ( cust_supp, 20 );
	    {
	    if length ( cust_supp ) > 20 Then
	      delete ( cust_supp, 20, length ( cust_supp )-19);
	    }
	    buildline ( 96, cust_supp );
	    getitem ( TxFile, 5 );
	    buildline ( 117, currstr );
	  END
	ELSE
	  BEGIN
	    GETITEM(TxFile,5);
	    if act = 5 then
	      Begin
		comment_cust_supp := '';
		get_cust_supp;
		PadRight ( cust_supp, 20 );
		buildline ( 88, cust_supp {currstr} );
		PadRight ( comment_cust_supp, 20 );
		{
		If length ( comment_cust_supp ) > 19 Then
		   delete ( comment_cust_supp, 18, length ( comment_cust_supp ));
		}
		buildline ( 112, comment_cust_supp );
	      End
	    else
	      BUILDLINE(62,CURRSTR);
	  END;
	OUTPUTLINE;
	IF ESCKEY THEN
	  Begin

	    {
            if act in [5,7] then
	      Begin
		cclose ( 4, 'N' );
		cclose ( 5, 'N' );
	      End;
            }
	    EXIT;
	  End;
      END;					      { end PRINTTRAN }

      (*
      PROCEDURE SHOWTRAN;
      BEGIN					      { begin SHOWTRAN }
	ROW:=ROW+1;
	IF ROW>22 THEN
	  BEGIN

            CONTINUE;
	    SCREENTOP;
	    ROW:=ROW+1;
	  END;
	STR(CURRREC[2],ST);
	MINSIZE(ST,5);
	DIS (1,ROW,ST);
	GETITEM(2,17);
	LONGSTR(CURRLONG,ST,'L');
	IF DBAC=CURRREC[1] THEN
	  BEGIN
	    TXDEBIT:=TXDEBIT+CURRLONG;
	    DIS ( 7,ROW,ST);
	    DIS (28,ROW,'-');
	  END;
	IF CRAC=CURRREC[1] THEN
	  BEGIN
	    TXCREDIT:=TXCREDIT+CURRLONG;
	    DIS (20,ROW,ST);
	    DIS (15,ROW,'-');
	  END;
	GETITEM(2,2);
	DIS (56,ROW,CURRSTR);
	GETITEM(2,5);
	DIS (66,ROW,CURRSTR);
      END;					      { end SHOWTRAN }
      *)

      PROCEDURE PRINTSTUB;
      BEGIN					      { begin PRINTSTUB }
	SUB1:=SUB1+1;
	BLANKLINE;
	BUILDLINE ( {15}1,'STUB-NO ');
	BUILDLINE ( {23}9,LASTSTUB);
	BUILDLINE ({39}25,'-');
	BUILDLINE ({52}38,'-');
	IF STDEBIT>0 THEN
	  BEGIN
            DoubleToStr ( STDEBIT, St, '%f', True, True, 11, False );
	    {LONGSTR (STDEBIT,ST,'L');}
	    BUILDLINE (17,ST);
	  END;
	IF STCREDIT>0 THEN
	  BEGIN
            DoubleToStr ( STCREDIT, St, '%f', True, True, 11, False );
	    {LONGSTR (STCREDIT,ST,'L');}
	    BUILDLINE (30,ST);
	  END;

	{
	if txdetail <> 'Y' then
	  buildline ( 50, l_date );
	}
	if NOT txdetail then
	  buildline ( 50, l_date );

	CASE STATUS[1] OF
	  'U' : BUILDLINE ({76}62,'NOT-PRESENTED');
	  'P' : BUILDLINE ({76}62,'PRESENTED');
	  'E' : BUILDLINE ({76}62,'ERROR-POSTING');
	END;
	if NOT txdetail then
	  Begin
	    str ( curr_trans, st );
	    minsize ( st, 5 );
	    buildline ( 79, st );
	  End;
	curr_trans := currrec[2];
	l_date := t_date;
	LASTSTUB:=STUBNO;
	LASTTXT :=TXT;
	LASTDATE:=THISDATE;
	STDEBIT :=0;
	STCREDIT:=0;
	GETITEM (TxFile,27);
	STATUS	 :=SPACE1;
	STATUS[1]:=CURRDISP[1];
	OUTPUTLINE;
	IF ESCKEY THEN EXIT;
	BLANKLINE;
	OUTPUTLINE;
	IF ESCKEY THEN EXIT;
      END;					     { end PRINTSTUB }

      PROCEDURE SHOWSTUB;
      VAR
	TX : INTEGER;
      BEGIN					     { begin SHOWSTUB }
	IF ANY THEN
	  BEGIN
	    SUB1:=SUB1+1;
	    ROW :=ROW +1;
	    {
            IF ROW>22 THEN
	      BEGIN
		CONTINUE;
		SCREENTOP;
		ROW:=ROW+1;
	      END;
	    }
            {
            IF NOT TXDETAIL THEN
	      BEGIN
		STR (TXSTART,ST);
		MINSIZE (ST,5);
		DIS (1,ROW,ST);
	      END;
	    DIS (36,ROW,LASTSTUB);
	    DIS (15,ROW,'-');
	    DIS (28,ROW,'-');
	    IF STDEBIT>0 THEN
	      BEGIN
		LONGSTR (STDEBIT,ST,'L');
		DIS ( 7,ROW,ST);
	      END;
	    IF STCREDIT>0 THEN
	      BEGIN
		LONGSTR (STCREDIT,ST,'L');
		DIS (20,ROW,ST);
	      END;
	    IF NOT TXDETAIL THEN
	      BEGIN
		DIS (56,ROW,TXDATE);
		DIS (66,ROW,TXCOMM);
	      END;
	    CLEARFROM (24);
	    DIS (1,24,'ENTER U for UNPRESENTED or P for PRESENTED or E for ERROR-POSTING');
	    SCRIN:=STATUS;
	    REPEAT
	      no_func_key;
	      REC (49,ROW,1,SCRIN,0,0,0,0,0,0);
	      IF ESCKEY THEN EXIT (PRINTOUT);
	    UNTIL SCRIN[1] IN ['U','P','E','u','p','e'];
	    CLEARFROM (24);
	    IF SCRIN='p' THEN SCRIN:='P';
	    IF SCRIN='e' THEN SCRIN:='E';
	    IF SCRIN='u' THEN SCRIN:='U';
	    STATUS :=SCRIN;
	    }
            SAVEREC:=CURRREC[2];
	    FOR TX:=1 TO TXTOTAL DO
	      BEGIN
		READREC (2,TXTRAIL[TX]);
		IF ERRORNO>0 THEN DbErr;
		SETITEM;
		CURRDISP[1]:=SCRIN[1];
		PUTITEM (2,27);
		REWRITEREC (2,TXTRAIL[TX]);
		IF ERRORNO>0 THEN DbErr;
	      END;
	    READREC (2,SAVEREC);
	    IF ERRORNO>0 THEN DbErr;
	  END;
	CASE STATUS[1] OF
	  'U' : IF STDEBIT>0
		  THEN UDB:=UDB+STDEBIT
		  ELSE UCR:=UCR+STCREDIT;
	  'P' : IF STDEBIT>0
		  THEN PDB:=PDB+STDEBIT
		  ELSE PCR:=PCR+STCREDIT;
	  'E' : IF STDEBIT>0
		  THEN EDB:=EDB+STDEBIT
		  ELSE ECR:=ECR+STCREDIT;
	END;
	LASTSTUB:=STUBNO;
	LASTTXT :=TXT;
	LASTDATE:=THISDATE;
	FOR TX:=1 TO TXTOTAL DO TXTRAIL[TX]:=0;
	TXTRAIL[1]:=CURRREC[2];
	TXTOTAL	  :=1;
	TXSTART	  :=0;
	TXDATE	  :=NULL;
	TXCOMM	  :=NULL;
	STDEBIT	  :=0;
	STCREDIT  :=0;
	GETITEM (TxFile,27);
	STATUS	 :=SPACE1;
	STATUS[1]:=CURRDISP[1];
	ANY	 :=FALSE;
      END;					     { end SHOWSTUB }

    BEGIN					     { begin PRINTDETAIL }
      IF ( POS ('P',BANKTYPE) > 0 ) or (( act = 5 ) and ( prog = specrep ) and
	 ( which_stub <> 'A' )) then
	OTHERVALUES;
      TXDEBIT :=0;
      TXCREDIT:=0;
      TXQUAN  :=0;
      SUB     :=0;
      SUB1    :=0;
      STDEBIT :=0;
      STCREDIT:=0;
      curr_trans := 0;
      
      CASE ACT OF
	7    : GETITEM(NlFile,15);
	4,5  : BEGIN
		 GETITEM(NlFile,14);
		 IF CURRINT=0 THEN GETITEM(NlFile,15);
	       END;
      END;
      t_date := '	 ';
      l_date := '	 ';
      TESTSTUB:='XXXXXXXX';
      TESTTXT :=0;
      TESTDATE:=0;
      ANY     :=FALSE;
      EDITST  :=SPACE1;

      { if the report is to be sorted then call the sort routine }
      (*
      if (( report_sorted ) and ( NOT ( second_run ))) then
	Begin
	  second_run := true;

	  start_from := currint;
	  SORT ( 2, 8, 10, sort_fld, 999, 0, 0, sort_asc, TRUE, TRUE, TRUE,
				   start_from, which_nominal, true, true );

	  cclose ( 8, 'N' );
	  creset ( 8, sortid );
	  if errorno > 0 then abort ( seqerr );

	  sortpos := 512;
	  sortblk := -1;

	  { get the next record to read }
	  next_trans ( read_next );
	  { set the record to read }
	  currint := read_next;
	End
      else
	if (( report_sorted ) and ( second_run )) then
	  Begin
	    cclose ( 8, 'N' );
	    creset ( 8, sortid );
	    if errorno > 0 then abort ( seqerr );

	    sortpos := 512;
	    sortblk := -1;
	    next_trans ( read_next );
	    currint := read_next;
	  End;
      *)

      WHILE CURRINT>0 DO
	BEGIN
	  {
          if (( Report_Sorted ) and ( prog = specrep ) and ( act = 5 ) and
	      ( first_disp )) then
	    Begin
	      clearfrom ( 24 );
	      dis ( 1, 24, 'PROCESSING TRANSACTION ');
	      disi ( 24, 24, currint, 0 );
	    End;
          }

	  READREC(TxFile,CURRINT);
	  if errorno > 0 then DbErr;
	  CURRINT:=0;
	  OK	 :=RECACTIVE(TxFile);

	  IF OK THEN
	    BEGIN
	      GETITEM (TxFile,18);
	      DBAC    :=CURRINT;
	      GETITEM (TxFile,19);
	      CRAC    :=CURRINT;
	      GETITEM (TxFile,23);
	      TXT     :=CURRINT;
	      GETITEM (TxFile,2);
	      THISDATE:=CURRINT;
	      t_date := currstr;
	      GETITEM (TxFile,26);
	      STUBNO  :=CURRSTR;
	      IF ((TESTSTUB<>STUBNO) OR (TESTDATE<>THISDATE) OR
		  (TESTTXT <>TXT   ) OR (STUBNO='00000000')) THEN
		BEGIN
		  {
		  GETITEM (2,27);
		  TEST	  :=SPACE1;
		  TEST[1] :=CURRDISP[1];
		  }
		  TESTSTUB:=STUBNO;
		  TESTTXT :=TXT;
		  TESTDATE:=THISDATE;
		END;
	      GETITEM (TxFile,27);
	      TEST    :=SPACE1;
	      TEST[1] :=CURRDISP[1];
	      IF POS(TEST,BANKTYPE)=0 THEN OK:=FALSE;
	      GETITEM (TxFile,2);

	      IF CURRINT>TODT THEN OK:=FALSE;
	      IF (ACT IN [5,7]) OR (TEST='P') THEN
		IF CURRINT < FROMDT THEN
		   OK:=FALSE;

	      IF (CURRREC[TxFile]<SCHTXF) OR (CURRREC[Txfile]>SCHTXT) THEN OK:=FALSE;
	      GETITEM (Txfile,28);
	      EDITST   :=SPACE1;
	      EDITST[1]:=CURRDISP[1];
	      IF (ACT IN [4,5,7]) AND (EDITST[1] IN ['R','E']) THEN OK:=FALSE;
	      CURRSTR:=STUBNO;
	      STUB1  :=0;
	      STUB2  :=0;
	      IF NUMERIC(CURRSTR) THEN
		BEGIN
		  WHILE LENGTH(CURRSTR)<8 DO CURRSTR:=CONCAT('0',CURRSTR);
		  INTVAL (STUB1,COPY(CURRSTR,1,4));
		  INTVAL (STUB2,COPY(CURRSTR,5,4));
		END;
	      STUB:=STUB1;
	      STUB:=(STUB*10000)+STUB2;
	      IF (STUB>SCHSTUBT) AND (SCHSTUBT>0) THEN OK:=FALSE;
	      IF (STUB<SCHSTUBF)		  THEN OK:=FALSE;
	    END;

	  if ACT = 4 then
	    begin
	      GETITEM (TxFile, 27);
	      BANK_REC := SPACE1;
	      BANK_REC[1] := CURRDISP[1];
	      if POS ( BANK_REC, BANKTYPE) = 0 then
		OK := false;
	      getitem (TxFile, 2);
	      if (( bank_rec[1] = 'P' ) and ( currint < fromdt )) then
		ok := false;
	    end;

	  IF  (OK) or
	      (( POS (BANK_REC, BANKTYPE ) <> 0 ) and
	      (ACT=4) AND (NOT (EDITST[1] IN ['R','E']))) THEN
	    BEGIN
	      IF SUB=0 THEN
		IF ACT<>4 THEN
		  BEGIN
		    BLANKLINE;
		    OUTPUTLINE;
		    IF ESCKEY THEN EXIT;
		  END;
	      SUB:=SUB+1;
	      if ( Device[1] in ['C','F','P','S'] ) then
		IF LINECOUNT+8>RFarmGate.PLINESPAGE[1] THEN
		  IF ACT<>4 THEN REPHEADINGS;
	      IF (ACT IN [4,5]) AND (SUB=1) THEN
		BEGIN
		  curr_trans := currrec[2];
		  l_date := t_date;
		  LASTSTUB :=STUBNO;
		  LASTTXT  :=TXT;
		  LASTDATE :=THISDATE;
		  FOR TxCounter := 1 TO STUBTX DO TXTRAIL[TxCounter]:=0;
		  TXTOTAL  :=0;
		  TXSTART  :=0;
		  TXDATE   :=NULL;
		  TXCOMM   :=NULL;
		  GETITEM (TxFile,27);
		  STATUS   :=SPACE1;
		  STATUS[1]:=CURRDISP[1];
		END;
	      IF ACT<>4 THEN
		BEGIN
		  BLANKLINE;
		  If (( act <> 5 ) And ( act <> 7 )) THEN
		    IF SUB=1
		      THEN BUILDLINE(1,'TRANSACTION ')
		      ELSE BUILDLINE(1,'........... ');
		END;
	      IF ACT IN [4,5] THEN
		IF TXTOTAL<STUBTX THEN
		  BEGIN
		    TXTOTAL:=TXTOTAL+1;
		    TXTRAIL [TXTOTAL]:=CURRREC[2];
		  END;
	      IF (ACT IN [4,5]) AND (SUB>1) AND
		((LASTSTUB<>STUBNO) OR (LASTDATE<>THISDATE) OR
		 (LASTTXT <>TXT	  ) OR (STUBNO='00000000')) THEN
		BEGIN
		  TXTOTAL:=TXTOTAL-1;
		  CASE ACT OF
		    4 : SHOWSTUB;
		    5 : PRINTSTUB;
		  END;
		END;
	      CASE ACT OF
		5    : IF TXDETAIL THEN PRINTTRAN;
		7    : PRINTTRAN;
		4    : IF OK THEN
			 BEGIN
			   ANY:=TRUE;
			   {
                           IF TXDETAIL THEN
			     SHOWTRAN
			   ELSE
			   }
                             IF TXTOTAL=1 THEN
			       BEGIN
				 TXSTART:=CURRREC[2];
				 GETITEM(TxFile,2);
				 TXDATE :=CURRSTR;
				 GETITEM(TxFile,5);
				 TXCOMM :=CURRSTR;
			       END;
			 END;
	      END;
	      IF (ACT IN [4,5]) AND (OK) THEN
		BEGIN
		  GETITEM(TxFile,17);
                  DoubleToStr ( CurrLong, St, '%f', True, True, 11, False );
		  {LONGSTR(CURRLONG,ST,'L');}
		  IF DBAC=CURRREC[NlFIle] THEN STDEBIT :=STDEBIT +CURRLONG;
		  IF CRAC=CURRREC[NlFile] THEN STCREDIT:=STCREDIT+CURRLONG;
		END;
	    END;
	  CURRINT:=0;
	  IF RECACTIVE(TxFile) THEN
	    BEGIN
	      { if the report is sorted then call next_trans & assign the
		currint to read_next }
	      if report_sorted then
		Begin
		  next_trans ( read_next );
		  currint := read_next;
		End
	      else
		Begin
		  IF CURRREC[NlFile]=DBAC THEN GETITEM(TxFile,13);
		  IF CURRREC[NlFile]=CRAC THEN GETITEM(TxFile,14);
		End;
	    END;
	END;

      IF SUB > 0 THEN
	BEGIN
	  CASE ACT OF
	    4 : SHOWSTUB;
	    5 : PRINTSTUB;
	  END;
	  IF ACT IN [7,5] THEN
	    BEGIN
	      BLANKLINE;
	      BUILDLINE(17,'------------------------');
	      IF ACT=7 THEN BUILDLINE(84,'------------');
	      OUTPUTLINE;
	      BLANKLINE;
	      BUILDLINE(25,'-');
	      BUILDLINE(38,'-');
	      IF TXDEBIT<>0 THEN
		BEGIN
                  DoubleToStr ( TXDEBIT, St, '%f', True, True, 11, False );
		  {LONGSTR(TXDEBIT,ST,'L');}
		  BUILDLINE(17,ST);
		END;
	      IF TXCREDIT<>0 THEN
		BEGIN
                  DoubleToStr ( TXCREDIT, St, '%f', True, True, 11, False );
		  {LONGSTR(TXCREDIT,ST,'L');}
		  BUILDLINE(30,ST);
		END;
	      DBTOT:=DBTOT+TXDEBIT;
	      CRTOT:=CRTOT+TXCREDIT;
	      IF (ACT=7) AND (TXQUAN<>0) THEN
		BEGIN
                  DoubleToStr ( TxQuan, St, '%f', True, True, 11, False );
		  {LONGSTR(TXQUAN,ST,'L');}
		  BUILDLINE(84,ST);
		END;
	      OUTPUTLINE;
	    END;
	END;
	
      if ( Device[1] in ['C','F','P','S'] ) then
	IF POS('U',BANKTYPE)>0 THEN RepDash;
    END;					 { end PRINTDETAIL }

    PROCEDURE ENTDETAIL;
    VAR
      INCF,INCT	   : INTEGER;
      EXPF,EXPT	   : INTEGER;
      COSF,COST	   : INTEGER;
      SUB	   : INTEGER;
      INCTOT	   : LISTCOLS;
      EXPTOT	   : LISTCOLS;
      COSTOT	   : LISTCOLS;
      GROSS	   : LISTCOLS;
      NETTOT	   : LISTCOLS;
      PROFIT	   : LISTCOLS;
      RECTOT	   : INTEGER;
      exp_total_qty,	    { accumulate the quantity toals for each expend }
      exp_this_year,	{ accumulate the total of this year div qty_total }
      inc_total_qty,	    { accumulate the quantity toals for each income }
      inc_this_year,	{ accumulate the total of this year div qty_total }
      expend_tot,
      total_per_units,
      total_over,
      tot_inc_ent,
      tot_EXP_ENT  : double;{biglong;}
      UNITDESC	   : ShortSTRING; {[15]}
      SPLIT	   : BOOLEAN;
      TempUnits,
      TotIncPerUnit,		   { Per Unit for income }
      TotExpPerUnit : double{Long};	   { Per Unit for expenditure }

      Procedure entoverheads ( var over_tot, tot_over_per_unit : double{biglong};
			       percentage : integer );
      Var
	over_from,
	over_to,
	dbnum,
	rec_count : integer;
	local_qty,
	local_amt : double{biglong};
	nombal,
	nomyr	  : Double{long};
	nom_name  : ShortString;

      Begin
	local_amt := 0;
	local_qty := 0;
	over_from := Cash1.xnomohfrom;	    { store the first overhead acc no }
	over_to	  := Cash1.xnomohto;		     { store the last overhead acc no }

	over_tot	  := 0;
	tot_over_per_unit := 0;
{-->>	nombal		  := 0;}
{-->>	nomyr		  := 0;}

	dbnum := 1;
	setdb ( dbnum );

	For rec_count := over_from To over_to Do
	  Begin
	    readrec ( dbnum, rec_count );
	    if errorno > 0 then DbErr;
	    if recactive ( dbnum ) then
	      Begin
		getitem ( dbnum, 2 );
		nombal := currlong;
		getitem ( dbnum, 4 );
		nomyr := nombal - currlong;

		blanknext;
		str ( rec_count, currstr );
		minsize ( currstr, 4 );
		buildline ( 3, currstr );
		getitem ( dbnum, 1 );
		buildline ( 10, currstr );

		If showbreakdown Then
		   Begin
		     If NOT calc_qty ( true, rec_count, Fromdt, ToDt, nom_name,
					local_qty, local_amt, NlFile, TxFile ) then
			 If ( local_qty <= 0 ) then
			    local_qty := 0;
		      nomyr := local_amt;
		   End;

		{ if the percentage rate is 0 then outpot all zeros }
		if percentage = 0 then
		   nomyr := 0;

		if (( nomyr < 0 ) and ( percentage > 0 )) then
		   nomyr := (( nomyr * percentage ) + 50 ) / 100
		else
		   if (( nomyr > 0 ) and ( percentage > 0 )) then
		      nomyr := (( nomyr * percentage ) - 50 ) / 100;

		{ accumulate the totals after the percentage has been deducted }
		over_tot := over_tot + nomyr;

		DoubleToStr ( nomyr, workstr, '%f' , True, True, 11, False);
		buildline ( 47, workstr );

		if nomyr > 0 then
		  begin
		    nomyr := ((( nomyr * 10000 )
			       / no_units) + 50 ) / 100;
		  end
		else
		  if nomyr < 0 then
		    begin
		      nomyr := ((( nomyr * 10000 )
			       / no_units) - 50 ) / 100;
		    end
		  else
		    nomyr := 0;

		{ accumulate the percentage overhead per unit }
		tot_over_per_unit := tot_over_per_unit + nomyr;

                DoubleToStr ( NomYr, WorkStr, '%f', True, True, 11, False );
                {WorkStr := Format ( '%f', [NomYr]);}
		{longstr ( nomyr, workstr, 'L' );}
		buildline ( 61, workstr );

		outputline;

	      End;
	  End;
      End;
      
      PROCEDURE ENTNOMINAL (LINK1,LINK2: INTEGER;
			    VAR SUBTOT,BIGTOT: LISTCOLS; INC,COS: BOOLEAN);
      VAR
        Sub,
	DBNUM	: INTEGER;
	PER	: INTEGER;
	YEARACT : Double{BIGLONG};
	YEARBUD : Double{BIGLONG};
	NOMBAL	: BIGLONG;
	NOMPD	: Double;{BIGLONG;}
	NOMYR	: Double{BIGLONG};
	NOMDIFF : Double{BIGLONG};
	TOTVAL	: Double{BIGLONG};
	ABSMTH	: INTEGER;
	nom_name : ShortString;
	this_year_per_qty,
        HoldQty,
        HoldTotal,
	test_tot    : Double;
	nominal_qty : Double;{biglong;}
	tx_totals : listcols;


	PROCEDURE ENTITEM (SLOT,COL: INTEGER; VAR VAL: Double{LONG});
	BEGIN						{ begin entitem }
	  BIGTOT[SLOT]:=BIGTOT[SLOT]-VAL;
	  IF INC THEN VAL:=0-VAL;
	  SUBTOT[SLOT]:=SUBTOT[SLOT]+VAL;
	  {LONGSTR (VAL,WORKSTR,'L');}
	  DoubleToStr (VAL,WORKSTR,'%f', True,  True,11, True);
	  IF (PROG=ENTREP) AND (ACT in [1,6]) AND (NOT SHOWANNUAL) AND (COL>77) THEN
	    WORKSTR:=COPY(WORKSTR,3,10);
	  BUILDLINE (COL, WORKSTR);
	END;						{ end entitem }

	PROCEDURE ENTVALUE (VAR VALUE: Double; ITEM: INTEGER);
	VAR
	  HALF : INTEGER;
	BEGIN						{ begin entvalue }
          IF ITEM=13 Then
             DoubleToStr (VALUE,WORKSTR,'%8.0f', True,  True,8, True)
          Else
             DoubleToStr (VALUE,WORKSTR,'%7.0f', True,  True,7, True);

          IF ITEM=13
	    THEN BUILDLINE (125,	WORKSTR)
	    ELSE BUILDLINE (34+(ITEM*7),WORKSTR);

	END;						 { end entvalue }


BEGIN						 { begin entnominal }
   AbsMth := 0;
   This_Year_Per_Qty := 0;
   Expend_Tot := 0;

	DBNUM:=NlFile;
	SETDB (DBNUM);
	RECTOT:=DB1.DBRECTOT;
	FOR SUB:=LINK1 TO LINK2 DO
	  IF (INC) OR (COS) OR (SUB<COSF) OR (SUB>COST) THEN
	    IF (SUB>0) AND (SUB<RECTOT) THEN
	      BEGIN
		READREC(DBNUM,SUB);
		IF ERRORNO>0 THEN DbErr;
		IF RECACTIVE(DBNUM) THEN
		  BEGIN
		    BLANKNEXT;
		    STR (SUB,CURRSTR);
		    MINSIZE (CURRSTR,4);
		    BUILDLINE (3,CURRSTR);
		    GETITEM (DBNUM,1);
		    BUILDLINE (10,CURRSTR);
		    IF PROG=ENTREP THEN
		      BEGIN
			GETITEM (DBNUM,2);
			NOMBAL:=CURRLONG;
			GETITEM (DBNUM,4);
			NOMYR:=NOMBAL-CURRLONG;
			CASE ACT OF
			  1,
(* change *)		  6 : BEGIN
				If act = 1 Then
				  ENTITEM (1,47,NOMYR);
				If act <> 6 then
				  IF (MONTH=Cash1.XMONTHNO) OR (NOT Cash1.XNOMTHIS) THEN
				    BEGIN
				      GETITEM (DBNUM,3);
				      NOMPD:=NOMBAL-CURRLONG;
				    END
				  ELSE
				    BEGIN
				      GETITEM (DBNUM,48+MONTH);
				      NOMPD:=CURRLONG;
				    END;
				if act <> 6 then
				  ENTITEM (2,61,NOMPD);
				IF (( SHOWANNUAL ) and NOT ( act IN [6] )) THEN
				  BEGIN
				    GETITEM (DBNUM,7);
                                    CurrDbl := CurrLong;
				    ENTITEM (3,103,CURRDBL);
				    NOMDIFF:=CURRDBL-NOMYR;
				    {LONGSTR (NOMDIFF,WORKSTR,'L');}
				    DoubleToStr (NOMDIFF,WORKSTR,'%f', True, True, 11, False);
				    BUILDLINE (117,WORKSTR);
				    SUBTOT[5]:=SUBTOT[5]+NOMDIFF;
				    IF INC THEN NOMDIFF:=0-NOMDIFF;
				    BIGTOT[5]:=BIGTOT[5]-NOMDIFF;
				    GETITEM (DBNUM,32+MAXMONTH);
                                    CurrDbl := CurrLong;
				    ENTITEM (4,75,CURRDbl);
				    NOMDIFF:=CURRdbl-NOMPD;

				    {LONGSTR (NOMDIFF,WORKSTR,'L');}
				    DoubleToStr (NOMDIFF,WORKSTR,'%f', True, True, 11, False);
				    BUILDLINE (89,WORKSTR);
				    SUBTOT[6]:=SUBTOT[6]+NOMDIFF;
				    IF INC THEN NOMDIFF:=0-NOMDIFF;
				    BIGTOT[6]:=BIGTOT[6]-NOMDIFF;
				  END;
				IF (( INCWEEKLY ) and NOT ( ACT IN [6] )) THEN
				  FOR PER:=MINWEEK TO MAXWEEK DO
				    BEGIN
				      GETITEM (DBNUM,80+PER);
                                      CurrDbl := CurrLong;
				      ENTITEM (3+PER-MINWEEK,
					       79+((PER-MINWEEK)*11),CURRDbl);
				    END;

				(* to output the enterprise by unit *)
				if act = 6 then
				  begin
				    If showbreakdown Then
				      Begin
					this_year_per_qty := 0;
{-->>                                        HoldTotal := 0;}
{-->>                                        HoldQty   := 0;}

					If NOT calc_qty ( true, sub, fromdt, todt, nom_name,
						 nominal_qty, test_tot, NlFile, TxFile ) Then
					  If ( nominal_qty <= 0 ) Then
					    nominal_qty := 0;

                                        If UsePreviousYear Then
                                           Begin
                                              HoldTotal := Test_Tot;
                                              HoldQty   := Nominal_Qty;

                                              If NOT calc_qty ( true, sub, fromdt, todt, nom_name,
					   	              nominal_qty, test_tot, LastNlFile, LastTxFile ) Then
                                              If ( nominal_qty <= 0 ) Then
					         nominal_qty := 0;

                                              HoldTotal := HoldTotal + Test_tot;
                                              HoldQty   := HoldQty + Nominal_Qty;
                                              Nominal_Qty := HoldQty;
                                              nomyr := HoldTotal;
                                           End
                                        Else
					    nomyr := test_tot;

					ENTITEM (1,47,NOMYR);

					If nominal_qty > 0 Then
					  Begin
					    {
                                            this_year_per_qty := ((( nomyr * 10000 )
						   DIV nominal_qty) +50 ) div 100;
					    }
                                            This_Year_Per_Qty := ( NomYr / Nominal_Qty );
                                            If print_inc_tot then
					      Begin
						inc_total_qty := inc_total_qty +
							       nominal_qty;

						inc_this_year := inc_this_year +
							     this_year_per_qty;
					      End
					    Else
					      Begin
						exp_total_qty := exp_total_qty +
							       nominal_qty;
						exp_this_year := exp_this_year +
							     this_year_per_qty;
					      End;
					  End;
				      End
				    Else
				      ENTITEM (1,47,NOMYR);

				    if nomyr > 0 then
				      begin
                                        {
                                        cal_units := ((( nomyr * 10000 )
						   / no_units) +50 ) / 100;
					}
                                        Cal_Units := ( NomYr / No_Units );
                                        if cal_units > 0  then
					  if print_inc_tot then
					    tot_inc_ent :=
							tot_inc_ent + cal_units
					  else
					    tot_EXP_ENT :=
						      tot_EXP_ENT + cal_units;
				      end
				    else
				      if nomyr < 0 then
					begin
					  {
                                          cal_units := ((( nomyr * 10000 )
						   DIV no_units) -50 ) div 100;
                                          }
                                          Cal_Units := ( NomYr / No_Units );
					  if print_inc_tot then
					    tot_inc_ent :=
						      tot_inc_ent + cal_units
					  else
					    tot_EXP_ENT :=
						      tot_EXP_ENT + cal_units;
					end
				      else
					cal_units := 0;

				    DoubleToStr (cal_units, WORKSTR, '%f', True, False, 11, True);
				    BUILDLINE ({75}61, WORKSTR);

				    if showbreakdown then
				      Begin
					DoubleToStr (nominal_qty, WORKSTR, '%f', True, False, 11, True);
					BUILDLINE ( 81, WORKSTR);
					DoubleToStr ( this_year_per_qty, WORKSTR, '%f', True, True, 11, True);
					BUILDLINE ( 97, WORKSTR);
				      End;
				  End;

			      END;
			  2 : BEGIN
				ENTITEM (1,47,NOMYR);
				GETITEM (DBNUM,17);
                                CurrDbl := CurrLong;
				ENTITEM (2,61,CURRDbl);
				GETITEM (DBNUM,18);
                                CurrDbl := CurrLong;
				ENTITEM (3,75,CURRDBL);
				GETITEM (DBNUM,19);
                                CurrDbl := CurrLong;
				ENTITEM (4,89,CURRDBL);
			      END;
			  3 : BEGIN
				ENTITEM (4,82,NOMYR);
				IF (MONTH=Cash1.XMONTHNO) OR (NOT Cash1.XNOMTHIS) THEN
				  BEGIN
				    GETITEM (DBNUM,3);
				    NOMPD:=NOMBAL-CURRLONG;
				  END
				ELSE
				  BEGIN
				    GETITEM (DBNUM,48+MONTH);
				    NOMPD:=CURRLONG;
				  END;
				ENTITEM (1,43,NOMPD);
				GETITEM (DBNUM,64+MONTH);
                                CurrDbl := CurrLong;
				ENTITEM (2,56,CURRDBL);
				GETITEM (DBNUM,32+MONTH);
                                CurrDbl := CurrLong;
				ENTITEM (3,69,CURRDbl);
				YEARACT:=0;
				YEARBUD:=0;
				FOR PER:=1 TO MAXMONTH DO
				  BEGIN
				    ABSMTH:=Cash1.XFINMONTH+PER-1;
				    IF ABSMTH>12 THEN ABSMTH:=ABSMTH-12;
				    GETITEM (DBNUM,64+ABSMTH);
				    YEARACT:=YEARACT+CURRLONG;
				    GETITEM (DBNUM,32+ABSMTH);
				    YEARBUD:=YEARBUD+CURRLONG;
				  END;

				ENTITEM (5, 95,YEARACT);
				ENTITEM (6,108,YEARBUD);
				GETITEM (DBNUM,7);
                                CurrDbl := CurrLong;
				ENTITEM (7,121,CURRDbl);
			      END;
			  4 : If NOT use_tx Then
				 Begin
				    IF (MONTH=Cash1.XMONTHNO) OR (NOT Cash1.XNOMTHIS) THEN
				      BEGIN
					GETITEM (DBNUM,3);
					NOMPD:=NOMBAL-CURRLONG;
				      END
				    ELSE
				      BEGIN
					GETITEM (DBNUM,48+MONTH);
					NOMPD:=CURRLONG;
				      END;
				    BIGTOT[MAXMONTH]:=BIGTOT[MAXMONTH]-NOMPD;
				    IF INC THEN NOMPD:=0-NOMPD;
				    SUBTOT[MAXMONTH]:=SUBTOT[MAXMONTH]+NOMPD;
				    ENTVALUE (NOMPD,MAXMONTH);
				    TOTVAL:=NOMPD;

				    FOR PER:=1 TO MAXMONTH-1 DO
				      BEGIN
					ABSMTH:=Cash1.XFINMONTH+PER-1;
					IF ABSMTH>12 THEN ABSMTH:=ABSMTH-12;
					GETITEM (DBNUM,48+ABSMTH);
					BIGTOT[PER]:=BIGTOT[PER]-CURRLONG;
					IF INC THEN CURRLONG:=0-CURRLONG;
					SUBTOT[PER]:=SUBTOT[PER]+CURRLONG;
                                        CurrDbl := CurrLong;
					ENTVALUE (CURRDBL,PER);
					TOTVAL:=TOTVAL+CURRDBL;
				      END;
				    CURRLONG:=0;
				    FOR PER:=MAXMONTH+1 TO 12 DO
                                        Begin
                                             CurrDbl := CurrLong;
				             ENTVALUE (CURRDBL,PER);
                                        End;
				    ENTVALUE (TOTVAL,13);
				 End
			      Else
				 Begin
                                    totval := 0;
				    total_tx_for_nom ( dbnum, sub, absmth,
						       inc, tx_totals );
				    FOR PER:=1 TO 12 DO
				      BEGIN
					ABSMTH:=Cash1.XFINMONTH+PER-1;
					IF ABSMTH>12 THEN ABSMTH:=ABSMTH-12;
					If inc Then
					  BIGTOT[PER]:=BIGTOT[PER]+tx_totals[absmth]
					Else
					  BIGTOT[PER]:=BIGTOT[PER]-tx_totals[absmth];
					SUBTOT[PER]:=SUBTOT[PER]+tx_totals[absmth];
					CurrDbl := Tx_Totals[absmth];
                                        {currlong := tx_totals[absmth];}
					ENTVALUE (CurrDbl{CURRLONG},PER);
					TOTVAL:=TOTVAL+CurrDbl{CURRLONG};
				      END;
				    entvalue(totval,13);
				 End;
			  5 : BEGIN
				TOTVAL:=0;
				FOR PER:=1 TO MAXMONTH DO
				  BEGIN
				    ABSMTH:=Cash1.XFINMONTH+PER-1;
				    IF ABSMTH>12 THEN ABSMTH:=ABSMTH-12;
				    GETITEM (DBNUM,64+ABSMTH);
				    BIGTOT[PER]:=BIGTOT[PER]-CURRLONG;
				    IF INC THEN CURRLONG:=0-CURRLONG;
				    SUBTOT[PER]:=SUBTOT[PER]+CURRLONG;
                                    CurrDbl := CurrLong;
				    ENTVALUE (CURRDBL,PER);
				    TOTVAL:=TOTVAL+CURRDBL;
				  END;
				CURRLONG:=0;
				FOR PER:=MAXMONTH+1 TO 12 DO
				  Begin
                                       CurrDbl := CurrLong;
                                       ENTVALUE (CURRDbl,PER);
                                  End;
				ENTVALUE (TOTVAL,13);
			      END;
			END;
		      END;
		    OUTPUTLINE;
		    IF ESCKEY THEN EXIT;
		  END;
	      END;
      END;						{ end entnominal }

      PROCEDURE ENTDASH;
      BEGIN						{ begin entdash }
	IF ( Device[1] in ['C','F','P','S'] ) THEN
	  RepDash;
      END;						{ end entdash }

      PROCEDURE ENTSTART;
      Var
        Sub       : Integer;

      BEGIN						{ begin entstart }
	exp_total_qty := 0;
	exp_this_year := 0;
	inc_total_qty := 0;
	inc_this_year := 0;

	tot_inc_ent := 0;
	TOT_EXP_ENT := 0;				 (* initialise total *)
	FOR SUB:=1 TO 13 DO
	  BEGIN
	    INCTOT[SUB]:=0;
	    EXPTOT[SUB]:=0;
	    COSTOT[SUB]:=0;
	    GROSS [SUB]:=0;
	    NETTOT[SUB]:=0;
	    PROFIT[SUB]:=0;
	  END;

	BLANKNEXT;
	OUTPUTLINE;
	IF ( Device[1] in ['C','F','P','S'] ) THEN
	  ENTDASH;
	IF ESCKEY THEN EXIT;
	GETITEM(EntFile,6);
	INCF:=CURRINT;
	GETITEM(EntFile,7);
	INCT:=CURRINT;
	GETITEM(EntFile,8);
	EXPF:=CURRINT;
	GETITEM(EntFile,9);
	EXPT:=CURRINT;
	IF EXTRA THEN
	  BEGIN
	    GETITEM(EntFile,10);
	    COSF:=CURRINT;
	    GETITEM(EntFile,11);
	    COST:=CURRINT;
	    SPLIT:=(COSF>0) AND (COST>0) AND ((COSF<>EXPF) OR (COST<>EXPT));
	  END;
	IF PROG=SPECREP THEN
	  BEGIN
	    BLANKNEXT;
	    OUTPUTLINE;
	    IF ESCKEY THEN EXIT;
	    BLANKNEXT;
	    BUILDLINE (1,'INCOME ACCOUNTS (');
	    STR (INCF,CURRSTR);
	    BUILDLINE (0,CURRSTR);
	    STR (INCT,CURRSTR);
	    BUILDLINE (0,'-');
	    BUILDLINE (0,CURRSTR);
	    BUILDLINE (0,')');
	    OUTPUTLINE;
	    IF ESCKEY THEN EXIT;
	    BLANKNEXT;
	    OUTPUTLINE;
	    IF ESCKEY THEN EXIT;
	  END;

	IF INCF > 0 THEN ENTNOMINAL (INCF, INCT, INCTOT, NETTOT, TRUE, FALSE);
      END;						{ end entstart }

      PROCEDURE ENTTOTAL (TITLE: STRING; VAR TOTAL: LISTCOLS; SUM: BOOLEAN);
      Var
         X : Integer;

      BEGIN						{ begin enttotal }
	BLANKNEXT;
	BUILDLINE (1,TITLE);
	CASE ACT OF
	  4,5 : BEGIN
		  IF SUM THEN TOTAL[13]:=0;
		  FOR X:=1 TO 12 DO
		    BEGIN
		      IF SUM THEN TOTAL[13]:=TOTAL[13]+TOTAL[X];
                      DoubleToStr (TOTAL[X],WORKSTR,'%7.0f', True, True, 7, True);
		      BUILDLINE (34+(X*7),WORKSTR);
		    END;
		  DoubleToStr (TOTAL[13],WORKSTR,'%8.0f', True, True, 8, True);
		  BUILDLINE (125,WORKSTR);
		END;
	  3   : FOR X:=1 TO 7 DO
		  BEGIN
		    DoubleToStr (TOTAL[X],WORKSTR,'%f', True, True, 11, True);
		    BUILDLINE (30+(X*13),WORKSTR);
		  END;
(* change *)
	  1,2,
	  6   : BEGIN
		  DoubleToStr (TOTAL[1],WORKSTR,'%f', True,  True,11, True);
		  BUILDLINE (47,WORKSTR);
		  If act <> 6 then
		    begin
		      DoubleToStr (TOTAL[2],WORKSTR,'%f', True, True, 11, True);
		      BUILDLINE (61,WORKSTR);
		    End;
		  IF (ACT=2) OR ((ACT=1) AND (SHOWANNUAL)) THEN
		    CASE ACT OF
		      1 : BEGIN
			    DoubleToStr (TOTAL[3],WORKSTR,'%f', True, True, 11, False);
			    BUILDLINE (103,WORKSTR);
			    DoubleToStr (TOTAL[4],WORKSTR,'%f', True,  True,11, False);
			    BUILDLINE (75,WORKSTR);
			    DoubleToStr (TOTAL[5],WORKSTR,'%f', True,  True,11, False);
			    BUILDLINE (117,WORKSTR);
			    DoubleToStr (TOTAL[6],WORKSTR,'%f', True,  True,11, False);
			    BUILDLINE (89,WORKSTR);
			  END;
		      2 : BEGIN
			    DoubleToStr (TOTAL[3],WORKSTR,'%f', True,  True,11, False);
			    BUILDLINE (75,WORKSTR);
			    DoubleToStr (TOTAL[4],WORKSTR,'%f', True,  True,11, False);
			    BUILDLINE (89,WORKSTR);
			  END;
		    END;
(* change *)
		  if ( ACT = 6 ) and (( print_inc_tot ) or ( print_exp_tot )) then
		    begin
		      if print_inc_tot then
			Begin
			  DoubleToStr ( tot_inc_ent, workstr, '%f', True,  False, 11, True);
			  buildline ( 61, workstr );
			  if showbreakdown then
			    Begin

			      {
                              DoubleToStr ( inc_total_qty, workstr, '%f' );
			      buildline ( 81, workstr );
                              }
			      DoubletoStr ( inc_this_year, workstr, '%f' , True,  True,11, True);
			      buildline ( 97, workstr );
			    End;
			End
		      else
			Begin
                          DoubleToStr ( tot_EXP_ENT, workstr, '%f', True,  False,11, True);
			  buildline ( 61, workstr );
			  if showbreakdown then
			    Begin
			      {
			      if exp_total_qty <> 0 then
				Begin
				  longstr ( exp_total_qty, workstr, 'L' );
				  buildline ( 81, workstr );
				End;
			      }
			      DoubleToStr ( exp_this_year, workstr, '%f' , True,  True,11, False);
			      buildline ( 97, workstr );
			    End;
			End;


		      (*
		      tot_inc_ent := 0;
		      tot_EXP_ENT := 0;
		      *)

		    end;

		  IF (ACT=1) AND (INCWEEKLY) THEN
		    FOR X:=MINWEEK TO MAXWEEK DO
		      BEGIN
			DoubleToStr (TOTAL[X-MINWEEK+3],WORKSTR,'%f', True, True, 11, False); { 'K' }
			{WORKSTR:=COPY(WORKSTR,3,10);}
			BUILDLINE (79+((X-MINWEEK)*11),WORKSTR);
		      END;
		END;
	END;
	OUTPUTLINE;
	IF ESCKEY THEN EXIT;
      END;						{ end endttotal }

      PROCEDURE ENTDIV (TITLE: STRING; TOTAL: LISTCOLS; UNITS: Double );
      VAR
	WK : Double{Long}; {INTEGER[36];}
	X  : INTEGER;
      BEGIN						{ begin entdiv }
	FOR X:=1 TO 13 DO
	  BEGIN
	    WK:=TOTAL[X];

            IF UNITS>0 THEN
               WK := (WK / UNITS)
            Else
                WK:=0;
            {
            IF UNITS>0 THEN
	      IF WK>0 THEN
                 WK:=(((WK*10000) DIV UNITS)+50) DIV 100
              ELSE
                  WK:=(((WK*10000) DIV UNITS)-50) DIV 100
	    ELSE
	      WK:=0;
            }
            {IF ACT IN [4,5] THEN WK:=(WK / 100)*100;}
	    TOTAL[X]:=WK*100;
	  END;
	ENTTOTAL (TITLE,TOTAL,TRUE);
      END;						{ end entdiv }

    BEGIN						{ begin entdetail }
      TotIncPerUnit := 0;
      TotExpPerUnit := 0;

      ENTSTART;
      IF PROG=ENTREP THEN
	BEGIN
	  ENTDASH;
	  ENTTOTAL (CONCAT('TOTAL ',Cash2.XENTUPPER,' INCOME'),INCTOT,TRUE);
	  ENTDASH;
	END;
      IF PROG=SPECREP THEN
	BEGIN
	  BLANKNEXT;
	  OUTPUTLINE;
	  IF ESCKEY THEN EXIT;
	  BLANKNEXT;
	  BUILDLINE (1,'EXPENDITURE ACCOUNTS (');
	  STR (EXPF,CURRSTR);
	  BUILDLINE (0,CURRSTR);
	  STR (EXPT,CURRSTR);
	  BUILDLINE (0,'-');
	  BUILDLINE (0,CURRSTR);
	  BUILDLINE (0,')');
	  OUTPUTLINE;
	  IF ESCKEY THEN EXIT;
	  BLANKNEXT;
	  OUTPUTLINE;
	  IF ESCKEY THEN EXIT;
	  IF EXPF > 0 THEN
	    ENTNOMINAL (EXPF,EXPT,EXPTOT,NETTOT,FALSE,TRUE);
	END;
      IF PROG=ENTREP THEN
	BEGIN
	  IF EXPF>0 THEN
	    IF EXTRA AND SPLIT THEN
	      BEGIN
		ENTNOMINAL (COSF,COST,COSTOT,NETTOT,FALSE,TRUE);
		ENTDASH;
		ENTTOTAL (CONCAT('TOTAL ',Cash2.XENTUPPER,' COST OF SALES'),COSTOT,TRUE);
		BLANKNEXT;
		OUTPUTLINE;
		IF ESCKEY THEN EXIT;
		FOR SUB:=1 TO 13 DO GROSS[SUB]:=INCTOT[SUB]-COSTOT[SUB];
		ENTTOTAL (CONCAT('TOTAL ',Cash2.XENTUPPER,' GROSS PROFIT'),GROSS,TRUE);
		ENTDASH;
		ENTNOMINAL (EXPF,EXPT,EXPTOT,NETTOT,FALSE,FALSE);
		ENTDASH;
		ENTTOTAL (CONCAT('TOTAL ',Cash2.XENTUPPER,' OVERHEADS'),EXPTOT,TRUE);
		BLANKNEXT;
		OUTPUTLINE;
		IF ESCKEY THEN EXIT;
		FOR SUB:=1 TO 13 DO EXPTOT[SUB]:=EXPTOT[SUB]+COSTOT[SUB];
	      END
	    ELSE
	      BEGIN
		print_exp_tot := true;
		print_inc_tot := false;
		ENTNOMINAL (EXPF,EXPT,EXPTOT,NETTOT,FALSE,TRUE);

		(*    change
		ENTNOMINAL (EXPF,EXPT,EXPTOT,NETTOT,FALSE,TRUE);
		*)

		ENTDASH;
	      END;
	  ENTTOTAL (CONCAT('TOTAL ',Cash2.XENTUPPER,' EXPENSES'),EXPTOT,TRUE);
	  ENTDASH;
	  BLANKNEXT;
	  OUTPUTLINE;
	  IF ESCKEY THEN EXIT;

	  if act = 6 then
	    begin
	      TotIncPerUnit := tot_inc_ent;	{ Total per unit income }
	      TotExpPerUnit := tot_exp_ent;	{ Total per unit Expend }
	      
	      tot_exp_ent := tot_inc_ent - tot_exp_ent;
	      exp_total_qty := 0;{inc_total_qty - exp_total_qty;}
	      exp_this_year := inc_this_year - exp_this_year;
	    end;

	  ENTDASH;
	  {ENTTOTAL (CONCAT('TOTAL ',XENTUPPER,' MARGIN'),NETTOT,TRUE);}
	  ENTTOTAL (CONCAT(Cash2.XENTUPPER,' GROSS MARGIN'),NETTOT,TRUE);
	  ENTDASH;

	  (* change *)
	  if act = 6 then
	    begin
	      print_exp_tot := false;
	      print_inc_tot := false;
	    end;

	  BLANKNEXT;
	  OUTPUTLINE;

	  if (( act = 6 ) and ( perc_over > 0 ) and ( perc_over <= 100 )) then
	    Begin
	      entdash;
	      str ( perc_over, workstr );
	      buildline ( 0, concat ( 'OVERHEAD EXPENSES AT ',workstr,'%' ) );
	      outputline;
	      entdash;

	      { calculate an print the percentage of overheads for this ent }
	      entoverheads ( total_over, total_per_units, perc_over );
	      entdash;
	      buildline ( 0, 'TOTAL OVERHEAD EXPENSES' );
              DoubleToStr ( Total_Over, WorkStr, '%f', True, True, 11, True );
              {WorkStr := Format ( '%f', [Total_Over] );}
	      {longstr ( total_over, workstr, 'L' );}
	      buildline ( 47, workstr );

              DoubleToStr ( Total_Per_Units, WorkStr, '%f', True, True, 11, True );
              {WorkStr := Format ( '%f', [Total_Per_Units] );}
	      {longstr ( total_per_units, workstr, 'L' );}
	      buildline ( 61, workstr );

	      outputline;
	      entdash;
	      buildline ( 0, 'TOTAL PRODUCTION COSTS ' );

	      DoubleToStr ( total_over+exptot[1], workstr, '%f' , True, True, 11, True );
	      buildline ( 47, workstr );

	      { calculate the per unit value for ent expend }
	      if exptot[1] > 0 then
		expend_tot := ( exptot[1] / no_units )
	      else
		expend_tot := ( exptot[1] / no_units );
	      {
              if exptot[1] > 0 then
		expend_tot := ((( exptot[1] * 10000 )
				       div no_units ) + 50 ) div 100
	      else
		expend_tot := ((( exptot[1] * 10000 )
				       div no_units ) - 50 ) div 100;
              }
	      DoubleToStr ( total_per_units+expend_tot, workstr, '%f' , True,  True,11, False);
	      buildline ( 61, workstr );

	      outputline;
	      entdash;

	    End;

	  OUTPUTLINE;

	  IF EXTRA AND SPLIT THEN
	    BEGIN
	      FOR SUB:=1 TO 13 DO
		IF (NETTOT[SUB]+EXPTOT[SUB]-COSTOT[SUB]<>0) AND (INCTOT[SUB]<>0) THEN
		  PROFIT[SUB]:=((NETTOT[SUB]+EXPTOT[SUB]-COSTOT[SUB]) / INCTOT[SUB]);
		  {
                  PROFIT[SUB]:=(((NETTOT[SUB]+EXPTOT[SUB]-COSTOT[SUB])*10000)
				DIV INCTOT[SUB]);
                  }
	      ENTTOTAL (CONCAT(Cash2.XENTUPPER,' GROSS PROFIT %'),PROFIT,FALSE);
	      BLANKNEXT;
	      OUTPUTLINE;
	      FOR SUB:=1 TO 13 DO
		IF (NETTOT[SUB]<>0) AND (INCTOT[SUB]<>0) THEN
		  PROFIT[SUB]:=(NETTOT[SUB] / INCTOT[SUB]);
		  {PROFIT[SUB]:=((NETTOT[SUB]*10000) DIV INCTOT[SUB]);}
	      ENTTOTAL (CONCAT(Cash2.XENTUPPER,' GROSS MARGIN %'),PROFIT,FALSE);
	      BLANKNEXT;
	      OUTPUTLINE;
	      FOR SUB:=1 TO 13 DO
		IF (EXPTOT[SUB]-COSTOT[SUB]<>0) AND (INCTOT[SUB]<>0) THEN
		  PROFIT[SUB]:=((EXPTOT[SUB]-COSTOT[SUB]) / INCTOT[SUB]);
		  {PROFIT[SUB]:=(((EXPTOT[SUB]-COSTOT[SUB])*10000) DIV INCTOT[SUB]);}
	      ENTTOTAL (CONCAT(Cash2.XENTUPPER,' OVERHEADS AS % OF INCOME'),PROFIT,FALSE);
	      BLANKNEXT;
	      OUTPUTLINE;
	    END
	  ELSE
	    BEGIN

              FOR SUB:=1 TO 13 DO
		IF (NETTOT[SUB]<>0) AND (INCTOT[SUB]<>0) THEN
		  PROFIT[SUB]:=((NETTOT[SUB]*10000) / INCTOT[SUB]);
		  {PROFIT[SUB]:=((NETTOT[SUB]*10000) DIV INCTOT[SUB]);}
	      ENTTOTAL (CONCAT(Cash2.XENTUPPER,' GROSS MARGIN %'),PROFIT,FALSE);
              BLANKNEXT;
	      OUTPUTLINE;
	    END;

	  if not SINGLE_ENT then
	    begin
	      SETDB (EntFile);
	      GETITEM (EntFile,4);
	      UNITDESC:=CURRSTR;
	      SLIMRIGHT(UNITDESC);
	      GETITEM (EntFile,3);
	      BLANKNEXT;
	      DoubleToStr ( CurrLong, WorkStr, '%f', True, True, 11, True);
              TempUnits := CurrLong;
              {LONGSTR (CURRLONG,WORKSTR,'L');}
	    end
	  else
	    begin
	      UNITDESC := unit_name;
              DoubleToStr ( No_Units, WorkStr, '%f' , True,  True,11, False);
              TempUnits := No_Units;
              {
              currlong := no_units;
	      longstr ( currlong, workstr, 'L' );
              }
	    end;

	  BUILDLINE ( 1,CONCAT('NUMBER OF ',Cash2.XENTUPPER,' UNITS'));
	  CASE ACT OF
	    4,5 : BUILDLINE (37{39},WORKSTR);
	    3	: BUILDLINE (43,WORKSTR);
	    1,2,
	    6	: BUILDLINE (47,WORKSTR);
	  END;
	  OUTPUTLINE;
	  blankline;

	  outputline;
	  blankline;

	  IF ESCKEY THEN EXIT;

	  ENTDIV (CONCAT('INCOME/',UNITDESC),INCTOT,CURRLONG);
	  ENTDIV (CONCAT('EXPENDITURE/',UNITDESC),EXPTOT,CURRLONG);
          (*
	  buildline ( 0, concat ( 'INCOME/',unitdesc ));
          DoubleToStr ( TotIncPerUnit, WorkStr, '%f', True, False, 11 );
          *)

          {WorkStr := Format ( '%f', [TotIncPerUnit] );}
	  {longstr ( TotIncPerUnit, workstr, 'L' );}
	  (*buildline ( 47, workstr );
	  outputline;
	  blanknext;
	  buildline ( 0, concat ( 'EXPENDITURE/',unitdesc ));

          DoubleToStr ( TotExpPerUnit, WorkStr, '%f', True, False, 11 );
          {WorkStr := Format ( '%f', [TotExpPerUnit] );}
	  {longstr ( TotExpPerUnit, workstr, 'L' );}
	  buildline ( 47, workstr );
	  outputline;*)
	  blanknext;

	  ENTDIV (CONCAT('GROSS MARGIN/',UNITDESC),NETTOT,TempUnits{CURRLONG});
	  BLANKNEXT;
	  OUTPUTLINE;

          if (( act = 6 ) and ( perc_over > 0 ) and ( perc_over <= 100 )) then
	    Begin
	      buildline ( 0, concat ( 'OVERHEADS/',unitdesc ));
              DoubleToStr ( Total_Per_Units, WorkStr, '%f', True, True, 11, True );
	      buildline ( 47, workstr );
	      outputline;

	      blanknext;
	      buildline ( 0, concat ( 'PRODUCTION COSTS/',unitdesc ));
              DoubleToStr ( (Total_Per_Units/100)+Expend_Tot, WorkStr, '%f', True, False, 11, True );
	      buildline ( 47, workstr );
	      outputline;

	      blanknext;
	      buildline ( 0, concat ( 'NET MARGIN/',unitdesc ));
              DoubleToStr ( TotIncPerUnit-((Total_Per_Units/100)+Expend_Tot), WorkStr, '%f', True, False, 11, True );
	      buildline ( 47, workstr );
	    End;

	  OUTPUTLINE;
	END;
    END;						{ end entdetail }

    PROCEDURE BUILDTXNO (DB,ITEM,COL,SIZE: INTEGER);
    BEGIN						{ begin buildtxno }
      GETITEM (DB,ITEM);
      STR (CURRINT,WORKSTR);
      IF SIZE>0 THEN MINSIZE (WORKSTR,SIZE);
      BUILDLINE (COL,WORKSTR);
    END;						{ end buildtxno }

    PROCEDURE BUILDITEM (DB,ITEM,COL,SIZE: INTEGER);
    BEGIN					      { begin builditem }
      GETITEM (DB,ITEM);
      IF SIZE > 0 THEN MINSIZE (CURRSTR,SIZE);
      BUILDLINE (COL,CURRSTR);
    END;						{ end builditem }

    PROCEDURE BUILDLONG (DB,ITEM,COL,SIZE: INTEGER);
    BEGIN						{ begin buildlong }
      GETITEM (DB,ITEM);
      IF (PROG=SPECREP) AND (ACT IN [11,12]) AND (NEG) THEN
	CURRLONG:=0-CURRLONG;
      DoubleToStr ( CurrLong, WorkStr, '%f', True, True, 11, True );
      {LONGSTR (CURRLONG,WORKSTR,'L');}
      IF SIZE>0 THEN WORKSTR:=COPY(WORKSTR,13-SIZE,SIZE);
      BUILDLINE (COL,WORKSTR);
    END;						 { end buildlong }



  PROCEDURE buildname ( DB, ITEM : INTEGER);
  var
    store_type,
    store_acc,
    store_db  : integer;
    name      : ShortString;{[30]}

    BEGIN					   { begin buildname }
      name := '';
      (*
      fillchar ( name, 30, ' ');		   { initialize name }
      *)
      store_db := DB;

      setdb ( DB );
      GETITEM ( DB, ITEM );
      store_type := currint;
      getitem ( DB, 3 );
      store_acc := currint;

      if store_type in [1..3] then
	begin
	  setdb ( SLFile );
	  readrec ( SlFile, store_acc );
	  getitem ( SlFile, 1);
	  name := currstr;
	end
      else
	if store_type in [5..7] then
	  begin
	    setdb ( PLFile );
	    readrec ( PlFile, store_acc );
	    getitem ( PLFile, 1 );
	    name := currstr;
	  end;

      DB := store_db;
      setdb ( db );

      slimright ( name );
      BUILDLINE (22, name);

    END;						{ end buildname }
  
    {* tests for end tx-type if cashbook income/expend report }
    Procedure get_nominal_name;
    Var
      curr_nom,
      trans_count,
      trans_type,
      reading_tx : integer;
      store_st	 : string;
    Begin
      reading_tx  := currrec[2] + 1;
      trans_type  := 0;
      trans_count := 0;
      curr_nom	  := 0;
      store_St	  := '';
      
      repeat
	readrec ( TxFile, reading_tx );
	If errorno > 0 Then DbErr;
	If recactive ( TxFile ) Then
	  Begin
	    getitem ( TxFile, 1 );
	    trans_type := currint;
	    if ( NOT ( trans_type in [12, 16] )) Then
	      Begin
		getitem ( TxFile, 8 );
		curr_nom := currint;
	      End;
	  End;

	trans_count := trans_count + 1;
	reading_tx := reading_tx + 1;
      until ( trans_type in [12, 16] ) Or ( trans_count > 3 );

      If (( trans_type in [12, 16] ) And ( trans_count = 3 )) Then
	Begin
	  if curr_nom > 0 Then
	    Begin
	      readrec ( NlFile, curr_nom );
	      If errorno > 0 Then DbErr;
	      If recactive ( NlFile ) Then
		Begin
		  getitem ( NlFile, 1 );
		  buildline ( 90, currstr );
		End;
	    End;
	End
      Else
	buildline ( 90, '*****' );
    End;

  BEGIN			   { this is the being of PRINTOUT of CBA.NSREPB.TEXT }
    { initialise the percentage of overheads to 0 }
    perc_over := 0;
    Tot := 0;
    CurrBal := 0;

    if (( PROG = ENTREP ) and ( ACT = 6 ) and ( not SINGLE_ENT )) then
      begin
	getitem ( EntFile, 4 );
	unit_name := currstr;
	slimright ( unit_name );
      end;

    LINESSPARE:=4;

    IF ( Device[1] in ['C','F','P','S'] ) AND ( NOT NUMBERONE ) AND (( DBNO = 6 )
      OR ((PROG=SPECREP) AND (ACT IN [7,5]) AND (NEWPAGEACC))) THEN
      LINESSPARE:=999;

    IF (( PROG = SPECREP ) AND ( ACT = 77 )) THEN LINESSPARE := 4;

    IF ( Device[1] IN ['C','F','P','S'] ) THEN
      IF ( LINECOUNT + LINESSPARE > RFarmGate.PLINESPAGE[1] ) THEN
	 REPHEADINGS;
    BLANKLINE;
    IF PROG = SPECREP THEN
      BEGIN
	CASE ACT OF
	  30	: Begin				{ LIST TRANSACTIONS REPORT }
		    {* build??? ( db, item, col, size ) }
		    str ( currrec[dbno], workstr );
		    minsize ( workstr, 4 );
		    buildline ( 1, workstr );	{ Transaction number }
		    builditem ( TxFile, 2, 9, 0 );	{ Date }
		    buildlong ( TxFile, 9, 18, 0 );	{ Amount }
		    buildlong ( TxFile, 11, 30, 0 ); { Vat/Discount }

		    builditem ( TxFile, 4, 43, 0 );	{ Reference }
		    builditem ( TxFile, 5, 52, 0 );	{ Description }
		    builditem ( TxFile, 26, 69, 0 ); { Stub-No }
		    buildline ( 84, tr_desc );	{ set by tx_type in processfile}
		  End;
	  88	: BEGIN
		    STR (CURRREC[DBNO],WORKSTR);
		    MINSIZE (WORKSTR,4);
(* change *)
		    if counter <> last_counter then
		      begin
			last_counter := counter;
			blankline;
			outputline;
			buildline ( 55,nom_heading );
		      end;

		    BUILDLINE (1,WORKSTR);
		    BUILDITEM (NlFile,1,17,0);
		    BUILDITEM (NlFile,5,50,0);
		  END;
	  7	: BEGIN
		    GETITEM (NlFile,15);
		    (*
		    IF (CURRINT>0) AND (Device[1] = 'S') AND
		       (ACT=7) AND (NOT NUMBERONE) THEN LINECOUNT:=9999;
		    *)
		    {* output the Nominal Account Number & Name }
		    buildline ( 43, 'ACCOUNT ' );
		    STR (CURRREC[DBNO],WORKSTR);
		    MINSIZE (WORKSTR,4);
		    BUILDLINE (51, Concat ( WORKSTR, ' : ' ));
		    BUILDITEM (NlFile,1,60,0);
		    outputline;
		    blankline;

		    {* output the nominal Account Balance }
		    buildline ( 1, 'CURRENT BALANCE' );
		    GETITEM(NlFile,2);
                    CurrDbl := CurrLong;
                    DoubleToStr ( CurrDbl, WorkStr, '%f', True, True, 11, False );
		    {
                    LONGSTR (CURRLONG,WORKSTR,'L');
		    WORKSTR[12]:=SPACE1;
		    }
                    BUILDLINE (25,'-');
		    BUILDLINE (38,'-');
		    IF CURRDBL>0 THEN BUILDLINE (17,WORKSTR);
		    IF CURRDBL<0 THEN BUILDLINE (30,WORKSTR);
		    {
		    BUILDITEM (1,1,44,0);
		    }
		  END;
	  5	: BEGIN
		    GETITEM (NlFile,15);
		    (*
		    IF (CURRINT>0) AND (Device[1] = 'S') AND
		       (ACT=7) AND (NOT NUMBERONE) THEN LINECOUNT:=9999;
		    *)
		    STR (CURRREC[DBNO],WORKSTR);
		    MINSIZE (WORKSTR,4);
		    BUILDLINE (1,WORKSTR);
		    GETITEM(NlFile,2);
                    DoubleToStr ( CurrLong, WorkStr, '%f', True, True, 11, False );
                    {LONGSTR (CURRLONG,WORKSTR,'L');
		    WORKSTR[12]:=SPACE1;}
		    BUILDLINE (25,'-');
		    BUILDLINE (38,'-');
		    IF CURRLONG>0 THEN BUILDLINE (17,WORKSTR);
		    IF CURRLONG<0 THEN BUILDLINE (30,WORKSTR);
		    BUILDITEM (NlFile,1,44,0);
		  END;
	  4	: BEGIN
		    GETITEM (NlFile,15);
		    BANKNO:=CURRREC[DBNO];
		    GETITEM (NlFile,2);
                    DoubleToStr ( CurrLong, BankBal, '%f', True, True, 11, False );
                    {LONGSTR (CURRLONG,BANKBAL,'L');}
		    GETITEM (NlFile,1);
		    BANKNAME:=CURRSTR;
		    {
                    SCREENTOP;
                    }
		  END;
	  6,21	: BEGIN
		    If act = 6 Then
		      Begin
			if ((( currrec[dbno] > Cash1.xnomprvinc+Cash11.xno_of_partners ) And
			     ( currrec[dbno] < Cash1.xnomprvexp )) Or
			    (( currrec[dbno] > Cash1.xnomprvexp+Cash11.xno_of_partners ) And
			     ( currrec[dbno] < Cash1.xnomtax )) Or
			    (( currrec[dbno] > Cash1.xnomprofit+Cash11.xno_of_partners ) And
			     ( currrec[dbno] < Cash1.xnomopen )) Or
			     ( currrec[dbno] > Cash1.xnomopen+Cash11.xno_of_partners )) Then
			  exit;
		      End;
		    BLANKLINE;
		    GETITEM (NlFile,15);
		    IF (( CURRREC[DBNO] >= Cash1.XNOMINCFROM ) And
			( currrec[dbno] <= Cash1.XNOMINCTO )) THEN TOT:=1;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMNONFROM ) And
			( currrec[dbno] <= Cash1.XNOMNONTO )) THEN TOT:=2;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMEXPFROM ) And
			( currrec[dbno] <= Cash1.XNOMEXPTO )) THEN TOT:=3;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMOHFROM ) And
			( currrec[dbno] <= Cash1.XNOMOHTO ))	THEN TOT:=4;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMCAFROM ) And
			( currrec[dbno] <= Cash1.XNOMCATO ))	THEN TOT:=5;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMFAFROM ) And
			( currrec[dbno] <= Cash1.XNOMFATO ))	THEN TOT:=6;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMLIFROM ) And
			( currrec[dbno] <= Cash1.XNOMLITO ))	THEN TOT:=7;
		    IF (( CURRREC[DBNO] >= Cash1.XBANKMIN ) And
			( currrec[dbno] <= Cash1.XBANKMAX ))	 THEN TOT:=8;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMPRVINC ) And
			( currrec[dbno] <= Cash1.XNOMPRVEXP+Cash11.xno_of_partners )) THEN TOT:=9;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMTAX ) And
			( currrec[dbno] <= Cash1.XNOMOPEN+Cash11.xno_of_partners )) THEN TOT:=10;
		    IF ACT = 21 THEN TOT:=1;
		    IF PRINT THEN
		      BEGIN
			STR (CURRREC[DBNO],WORKSTR);
			MINSIZE (WORKSTR,4);
			BUILDLINE (1,WORKSTR);
			GETITEM (NlFile,1);
			FOR X:=1 TO LENGTH(CURRSTR) DO
			  IF CURRSTR[X]=CHR(0) THEN CURRSTR[X]:=CHR(32);
			BUILDLINE (9,CURRSTR);
		      END;
		    IF (ACT=6) AND (REPTYPE='M') THEN
		      IF MONTH=Cash1.XMONTHNO THEN
			BEGIN
			  GETITEM (NlFile,3);
			  OPENBAL:=CURRLONG;
			END
		      ELSE
		       BEGIN
			 X:=Cash1.XFINMONTH;
			 OPENBAL:=0;
			 WHILE X<>MONTH DO
			   BEGIN
			     GETITEM (NlFile,48+X);
			     OPENBAL:=OPENBAL+CURRLONG;
			     X:=X+1;
			     IF X>12 THEN X:=X-12;
			   END;
		       END
		    ELSE
		      BEGIN
			GETITEM (NlFile,4);
			OPENBAL:=CURRLONG;
		      END;
		    IF (( PRINT ) AND ( EXTENDED )) or
		       (( print ) and ( act = 21 )) THEN
		      BEGIN
                        DoubleToStr ( CurrLong, WorkStr, '%f', True, True, 11, False );
			{LONGSTR (CURRLONG,WORKSTR,'L');
			WORKSTR[12]:=SPACE1;}
			BUILDLINE (53,'-');
			BUILDLINE (65,'-');
			IF CURRLONG>0 THEN BUILDLINE (45,WORKSTR);
			IF CURRLONG<0 THEN BUILDLINE (57,WORKSTR);
		      END;
		    IF CURRLONG>0 THEN BALTOT[TOT][1]:=BALTOT[TOT][1]+CURRLONG;
		    IF CURRLONG<0 THEN BALTOT[TOT][2]:=BALTOT[TOT][2]-CURRLONG;
		    IF (ACT=6) AND (REPTYPE='M') AND (MONTH<>Cash1.XMONTHNO) THEN
		      BEGIN
			GETITEM (NlFile,48+MONTH);
                        CurrDbl := CurrLong;
			{CURRBAL:=OPENBAL+CURRLONG;}
			CurrDbl:=OPENBAL+CurrDbl;
		      END
		    ELSE
		      BEGIN
			GETITEM (NlFile,2);
                        CurrDbl := CurrLong;
			CURRBAL :=CURRDbl;
			CURRDbl:=CURRDbl-OPENBAL;
		      END;
		    IF (( PRINT ) AND ( EXTENDED )) or
		       (( print ) and ( act = 21 )) THEN
		      BEGIN
                        DoubleToStr ( CurrDbl, WorkStr, '%f', True, True, 11, False );
                        NegSign := Pos('-', WorkStr);
                        If NegSign > 0 Then
                           WorkStr[NegSign] := ' ';
{
                        LONGSTR (CURRLONG,WORKSTR,'L');
			WORKSTR[12]:=SPACE1;
			}
                        BUILDLINE (83,'-');
			BUILDLINE (95,'-');
			IF CURRDbl>0 THEN BUILDLINE (75,WORKSTR);
			IF CURRDbl<0 THEN BUILDLINE (87,WORKSTR);
		      END;
		    IF CURRDbl>0 THEN BALTOT[TOT][3]:=BALTOT[TOT][3]+CURRDbl;
		    IF CURRDbl<0 THEN BALTOT[TOT][4]:=BALTOT[TOT][4]-CURRDbl;
		    IF PRINT THEN
		      BEGIN
                        DoubleToStr ( CurrBal, WorkStr, '%f', True, True, 11, False );
                        NegSign := Pos('-', WorkStr);
                        If NegSign > 0 Then
                           WorkStr[NegSign] := ' ';
{
                        LONGSTR (CURRBAL,WORKSTR,'L');
			WORKSTR[12]:=SPACE1;
			}
                        IF ( EXTENDED ) or ( act = 21 ) THEN
			  BEGIN
			    BUILDLINE (113,'-');
			    BUILDLINE (125,'-');
			    IF CURRBAL>0 THEN BUILDLINE (105,WORKSTR);
			    IF CURRBAL<0 THEN BUILDLINE (117,WORKSTR);
			  END
			ELSE
			  BEGIN
			    BUILDLINE (53,'-');
			    BUILDLINE (65,'-');
			    IF CURRBAL>0 THEN BUILDLINE (45,WORKSTR);
			    IF CURRBAL<0 THEN BUILDLINE (57,WORKSTR);
			  END
		      END;
		    IF CURRBAL>0 THEN BALTOT[TOT][5]:=BALTOT[TOT][5]+CURRBAL;
		    IF CURRBAL<0 THEN BALTOT[TOT][6]:=BALTOT[TOT][6]-CURRBAL;
		  END;
	  121	: BEGIN
		    BLANKLINE;
		    GETITEM (NlFile,15);
		    {
		    IF CURRREC[DBNO] IN [XNOMINCFROM..XNOMINCTO] THEN TOT:=1;
		    IF CURRREC[DBNO] IN [XNOMNONFROM..XNOMNONTO] THEN TOT:=2;
		    IF CURRREC[DBNO] IN [XNOMEXPFROM..XNOMEXPTO] THEN TOT:=3;
		    IF CURRREC[DBNO] IN [XNOMOHFROM..XNOMOHTO]	 THEN TOT:=4;
		    IF CURRREC[DBNO] IN [XNOMCAFROM..XNOMCATO]	 THEN TOT:=5;
		    IF CURRREC[DBNO] IN [XNOMFAFROM..XNOMFATO]	 THEN TOT:=6;
		    IF CURRREC[DBNO] IN [XNOMLIFROM..XNOMLITO]	 THEN TOT:=7;
		    IF CURRREC[DBNO] IN [XBANKMIN..XBANKMAX]	 THEN TOT:=8;
		    IF CURRREC[DBNO] IN
			 [XNOMPRVINC..XNOMPRVEXP+xno_of_partners] THEN TOT:=9;
		    IF CURRREC[DBNO] IN
			 [XNOMTAX..XNOMOPEN+xno_of_partners]	 THEN TOT:=10;
		    }
		    IF (( CURRREC[DBNO] >= Cash1.XNOMINCFROM ) And
			( currrec[dbno] <= Cash1.XNOMINCTO )) THEN TOT:=1;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMNONFROM ) And
			( currrec[dbno] <= Cash1.XNOMNONTO )) THEN TOT:=2;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMEXPFROM ) And
			( currrec[dbno] <= Cash1.XNOMEXPTO )) THEN TOT:=3;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMOHFROM ) And
			( currrec[dbno] <= Cash1.XNOMOHTO ))	THEN TOT:=4;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMCAFROM ) And
			( currrec[dbno] <= Cash1.XNOMCATO ))	THEN TOT:=5;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMFAFROM ) And
			( currrec[dbno] <= Cash1.XNOMFATO ))	THEN TOT:=6;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMLIFROM ) And
			( currrec[dbno] <= Cash1.XNOMLITO ))	THEN TOT:=7;
		    IF (( CURRREC[DBNO] >= Cash1.XBANKMIN ) And
			( currrec[dbno] <= Cash1.XBANKMAX ))	 THEN TOT:=8;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMPRVINC ) And
			( currrec[dbno] <= Cash1.XNOMPRVEXP+Cash11.xno_of_partners )) THEN TOT:=9;
		    IF (( CURRREC[DBNO] >= Cash1.XNOMTAX ) And
			( currrec[dbno] <= Cash1.XNOMOPEN+Cash11.xno_of_partners )) THEN TOT:=10;
		    TOT:=1;
		    IF PRINT THEN
		      BEGIN
			STR (CURRREC[DBNO],WORKSTR);
			MINSIZE (WORKSTR,4);
			BUILDLINE (1,WORKSTR);
			GETITEM (NlFile,1);
			FOR X:=1 TO LENGTH(CURRSTR) DO
			  IF CURRSTR[X]=CHR(0) THEN CURRSTR[X]:=CHR(32);
			BUILDLINE (9,CURRSTR);
		      END;
		    GETITEM (NlFile,4);
                    CurrDbl := CurrLong;
		    OPENBAL:=CURRDbl;
                    DoubleToStr ( OpenBal, WorkStr, '%f', True, True, 11, False );
                    NegSign := Pos('-', WorkStr);
                    If NegSign > 0 Then
                       WorkStr[NegSign] := ' ';
		    {
                    LONGSTR (CURRLONG,WORKSTR,'L');
		    WORKSTR[12]:=SPACE1;
		    }
                    BUILDLINE (72,'-');
		    IF CURRDbl>0 THEN BUILDLINE (65,WORKSTR);
		    IF CURRDbl<0 THEN BUILDLINE (64,Concat ('(',workstr,')'));

		    BALTOT[TOT][1]:=BALTOT[TOT][1]+CURRDbl;
		    GETITEM (NlFile,2);
                    CurrDbl := CurrLong;
		    CURRBAL :=CURRDbl;
		    CURRDbl :=CURRDbl-OPENBAL;

                    DoubleToStr ( CurrBal, WorkStr, '%f', True, True, 11, False );
                    NegSign := Pos('-', WorkStr);
                    If NegSign > 0 Then
                       WorkStr[NegSign] := ' ';
		    {
                    LONGSTR (CURRBAL,WORKSTR,'L');
		    WORKSTR[12]:=SPACE1;
		    }
                    BUILDLINE (53,'-');
		    IF CURRBAL>0 THEN BUILDLINE (45,WORKSTR);
		    IF CURRBAL<0 THEN BUILDLINE (44,Concat ('(',workstr,')'));

		    BALTOT[TOT][3]:=BALTOT[TOT][3]+CURRDbl;
		    BALTOT[TOT][5]:=BALTOT[TOT][5]+CURRBAL;
		  END;
	  3	: BEGIN
		    STR (CURRREC[DBNO],WORKSTR);
		    WHILE LENGTH(WORKSTR)<5 DO WORKSTR:=CONCAT(SPACE1,WORKSTR);
		    BUILDLINE (2,WORKSTR);
		    BUILDITEM (TxFile,28, 1,0);
		    BUILDLONG (TxFile,17,12,0);
		    BUILDITEM (TxFile, 2,25,0);
		    BUILDITEM (TxFile, 5,34,0);

		    BUILDITEM (TxFile,18,50,4);

                    getitem ( TxFile, 18 );
		    readrec ( NlFile, currint );
                    builditem ( 1, 1, 59, 0 );

		    BUILDITEM (TxFile,19,81,4);
		    getitem ( Txfile, 19 );
		    readrec ( NlFile, currint );
		    builditem ( NlFile, 1, 90, 0 );

		  END;
	  1,2	: BEGIN
		    STR (CURRREC[DBNO],WORKSTR);
		    WHILE LENGTH(WORKSTR)<5 DO WORKSTR:=CONCAT(SPACE1,WORKSTR);
		    BUILDLINE (2,WORKSTR);
		    BUILDITEM (TxFile,28, 1,0);
		    BUILDITEM (TxFile, 2, 9,0);
		    BUILDITEM (TxFile, 4,18,0);
		    BUILDLONG (TxFile, 9,28,0);
		    BUILDLONG (TxFile,11,43,0);
		    BUILDITEM (TxFile, 5,58,0);
		    BUILDITEM (TxFile,26,79,0);
		  END;

	  8	: BEGIN

		    SUB := 0;
		    GETITEM (TxFile,1);
		    TransType := Currint;
		    IF CURRINT = 0 THEN
		      BEGIN
			GETITEM (TxFile, 23);
			TXT := CURRINT;
			IF TXT IN [1,2,3,4,11,12] THEN SUB := 1;
			IF TXT IN [5,6,7,8,15,16] THEN SUB := 2;
		      END;
		    IF CURRINT = 10 THEN SUB := 1;

		    If TransType = 9 Then
		       If CheckNextTx ( TxFile{2}, currrec[TxFile] ) Then
			  Begin
			    GETITEM (TxFile, 23);
			    TXT := CURRINT;
			    IF TXT IN [1,2,3,4,11,12] THEN SUB := 1;
			    IF TXT IN [5,6,7,8,15,16] THEN SUB := 2;
			  End;

		    GETITEM (TxFile,8);
		    {
		    IF CURRINT IN [XNOMPRVINC,XNOMPRVEXP+xno_of_partners] THEN SUB := 0;
		    }
		    If (( currint >= Cash1.xnomprvinc ) And
			( currint <= Cash1.xnomprvexp+Cash11.xno_of_partners )) Then
		       sub := 0;

		    EditStat := SPACE1;
		    GETITEM (TxFile,28);
		    EditStat[1] := currdisp[1];
		    IF CURRDISP[1] IN ['E','R'] THEN SUB := 0;

		    Getitem ( Txfile, 11 );
		    VatAmt := CurrLong;

		    VatCode := SPACE1;
		    Getitem ( TxFile, 10 );
		    VatCode[1] := CurrDisp[1];

		    IF SUB > 0 THEN
		      BEGIN
			GETITEM (TxFile,9);
			AMT := CURRLONG;

			GETITEM (TxFile,11);
			TAX := CURRLONG;

			GETITEM (TxFile,1);
			IF CURRINT In [0,9] {= 0} THEN
			  IF ((NOT (TXT IN [3,7])) AND ( AMT < 0 ))
			  OR ((	    TXT IN [3,7] ) AND ( AMT > 0 )) THEN
			    BEGIN
			      IF SUB=1 THEN
				SUB:=2
			      ELSE
				SUB:=1;
			      AMT := 0 - AMT;
			      TAX := 0 - TAX;
			    END;

			IF CURRINT = 10 THEN
			  BEGIN
			    GETITEM (TxFile,18);
			    DEBIT := CURRINT;
			    IF DEBIT = Cash1.XNOMTAX THEN
			      BEGIN
				AMT := 0 - AMT;
				TAX := 0 - TAX;
			      END;
			  END;
			TOTTAX[SUB] := TOTTAX[SUB] + TAX;

			GETITEM (TxFile,10);

			IF CURRDISP[1] <> '*' THEN
			  TOTAMT[SUB] := TOTAMT[SUB] + AMT;

			IF CURRDISP[1] = 'E' THEN	  { tot up EC Amounts }
			  EC_TOTAMT[SUB] := EC_TOTAMT[SUB] + AMT;

		      END;
		    {
		    Else
		      If (( TransType = 9 ) And ( VatAmt = 0 ) And
			  ( VatCode[1] = 'E' ) And
			  ( EditStat[1] In ['I','P'] )) Then
			Begin
			  GETITEM (2, 23);
			  TXT := CURRINT;
			  IF TXT IN [1,2,3,4,11,12] THEN SUB := 1;
			  IF TXT IN [5,6,7,8,15,16] THEN SUB := 2;

			  GETITEM (2,9);
			  AMT := CURRLONG;

			  GETITEM (2,11);
			  TAX := CURRLONG;

			  IF ((NOT (TXT IN [3,7])) AND ( AMT < 0 ))
			  OR ((	    TXT IN [3,7] ) AND ( AMT > 0 )) THEN
			    BEGIN
			      IF SUB=1 THEN
				SUB:=2
			      ELSE
				SUB:=1;
			      TAX := 0 - TAX;
			      AMT := 0 - AMT;
			    END;

			  TOTAMT[SUB] := TOTAMT[SUB] + AMT;
			  EC_TOTAMT[SUB] := EC_TOTAMT[SUB] + AMT;

			End;
		     }
		  END;

	  55	: BEGIN
		    STR (CURRREC[DBNO],WORKSTR);
		    MINSIZE (WORKSTR,5);
		    BUILDLINE ( 2,WORKSTR);
		    BUILDLINE (10,'[');
		    BUILDLINE (13,']');
		    BUILDITEM (TxFile,28,  1,1);
		    BUILDITEM (TxFile, 1,  8,2);
		    BUILDITEM (TxFile,23, 11,2);
		    BUILDTXNO (TxFile,13, 15,5);
		    BUILDTXNO (TxFile,14, 21,5);
		    BUILDTXNO (TxFile,16, 27,5);
		    BUILDITEM (TxFile, 2, 33,0);
		    BUILDITEM (TxFile, 4, 42,0);
		    BUILDITEM (TxFile, 3, 51,4);
		    BUILDITEM (TxFile,18, 56,4);
		    BUILDITEM (TxFile,19, 61,4);
		    BUILDLONG (TxFile, 9, 66,10);
		    BUILDITEM (TxFile,10, 78,0);
		    BUILDLONG (TxFile,11, 81,9);
		    BUILDLONG (TxFile,17, 91,10);
		    BUILDITEM (TxFile,24,102,0);
		    BUILDITEM (TxFile, 8,107,3);
		    BUILDITEM (TxFile,26,111,0);
		    BUILDITEM (TxFile,12,120,3);
		    BUILDITEM (TxFile, 5,124,0);
		  END;
	  11,12 : BEGIN
		    STR (CURRREC[DBNO],WORKSTR);
		    MINSIZE (WORKSTR,5);
		    BUILDLINE ( 2,WORKSTR);

		    buildname ( 2, 23 );
	       (*
		    BUILDLINE (13,'[');
		    BUILDLINE (18,']');
		    BUILDITEM (2, 1, 10,2);
		    BUILDITEM (2,23, 15,2);
		*)
		    BUILDITEM (TxFile, 2, 11,0);
		    (*
		    BUILDITEM (2, 3, 32,4);
		    *)
		    BUILDITEM (TxFile, 4, 52,0);
		(*
		    BUILDITEM (2,12, 53,4);
		*)
		    BUILDLONG (Txfile, 9, 61,12);
		    BUILDLONG (TxFile,11, 75,12);
		    BUILDITEM (TxFile,10, 96,0);
		(*
		    BUILDITEM (2,18,100,4);
		    BUILDITEM (2,19,108,4);
		*)
		    BUILDITEM (TxFile, 5,109,0);
		  END;
	END;
      END;
    IF (PROG=ENTREP) OR ((PROG=SPECREP) AND (ACT IN [66,77])) THEN
      BEGIN
	GETITEM(EntFile,1);
	BUILDLINE(5,CURRSTR);	{ Enterprise Code }

	GETITEM(EntFile,2);
	BUILDLINE(9,' - ');

	{* 04-11-94 store the percentage from the string and delete it before
	   displaying/printing }
        If Length ( CurrStr ) > 17 Then
	  Begin
	    Overhead_perc := space40;
            OverHead_Perc := Copy ( CurrStr, 18, 3 );
           //break_string ( currstr, overhead_perc, save_name, 17, 3, 20 );

	    SlimAll ( overhead_perc );

	    if numeric ( overhead_perc ) then
	      intval ( perc_over, overhead_perc )
	    else
	      perc_over := 0;

	    delete ( currstr, 18, length ( currstr ) - 17 );
	  End;
	BUILDLINE(12,CURRSTR);	  { Enterprise Name }

        (* change *)
	If not single_ent Then
	  Begin
	    getitem (EntFile, 3);
	    If currlong <> 0 Then
	       Begin
                   no_units := currlong;
                   {No_Units := ( No_Units / 100 );}
               End
	    Else
	      no_units := 100;
	    getitem ( EntFile, 4 );
	    unit_name := currstr;
	    slimright ( unit_name );
	  End;

	print_inc_tot := true;	    (* set booleans for controling report 6 *)
	print_exp_tot := false;

	IF (PROG=SPECREP) AND (ACT=77) THEN
	  BEGIN
	    GETITEM(EntFile,6);
	    BUILDLINE(41-LENGTH(CURRSTR),CURRSTR);
	    GETITEM(EntFile,7);
	    BUILDLINE(42,'-');
	    BUILDLINE(44,CURRSTR);
	    GETITEM(EntFile,8);
	    BUILDLINE(65-LENGTH(CURRSTR),CURRSTR);
	    GETITEM(EntFile,9);
	    BUILDLINE(66,'-');
	    BUILDLINE(68,CURRSTR);
	    IF EXTRA THEN
	      BEGIN
		GETITEM(EntFile,10);
		BUILDLINE(89-LENGTH(CURRSTR),CURRSTR);
		GETITEM(EntFile,11);
		BUILDLINE(90,'-');
		BUILDLINE(92,CURRSTR);
	      END;
	  END;
      END;
    TOTALRECS;
    IF ((PROG=SPECREP) AND (ACT IN [4,8])) OR
       ((PROG=SPECREP) AND (ACT In [21,121] ) AND (NOT PRINT)) THEN
    ELSE
      Begin
	If (( prog = SPECREP ) And ( act In [1,2] )) Then
	  get_nominal_name;
	OUTPUTLINE;
      End;
    IF ESCKEY THEN EXIT;
    NUMBERONE:=FALSE;
    IF (ACT IN [7,4,5]) AND (PROG=SPECREP) THEN
      BEGIN
	GETITEM(NlFile,22);
	RUNBAL:=CURRLONG;
	CASE ACT OF
	  5   : BEGIN
		  which_nominal := currrec[dbno];
{-->>		  second_run := false;}

		  if (( which_stub = 'A' ) or ( which_stub = 'P' )) then
		    PRINTDETAIL ('P');

		  if (( which_stub = 'A' ) or ( which_stub = 'U' )) then
		    PRINTDETAIL ('UE');

		  { if sorted report purge the temp file from disk }
		  if report_sorted then
		    cclose ( 8, 'P' );

		END;
	  4   : BEGIN
		  STUBTYPE:=NULL;
		  IF STUBP THEN STUBTYPE:=CONCAT(STUBTYPE,'P');
		  IF STUBU THEN STUBTYPE:=CONCAT(STUBTYPE,'U');
		  IF STUBE THEN STUBTYPE:=CONCAT(STUBTYPE,'E');
		  PRINTDETAIL (STUBTYPE);
		  PRINTTOTS;
		END;
	  7   : PRINTDETAIL ('PUE ');
	END;
      END;
    IF (PROG=ENTREP) OR ((PROG=SPECREP) AND (ACT=66)) THEN ENTDETAIL;
  END;						     { end PRINTOUT }

end.
