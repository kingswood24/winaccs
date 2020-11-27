unit Nsrep11;

(* Changes

    31/08/20 - AB - Transaction Listing Report Issues - Bug : Reference not always being shown (marked Ch028)
                                                        Improvement : customer wanted Cust / Supp shown on all ledger transactions - added cust / supp column (marked Ch028)

*)

interface
Uses
    types,
    Printers;

  Function calc_qty ( check_amt : Boolean; nominal_code, Fdt, Tdt : integer;
     var nominal_name : ShortString; var total_qty, total_amt : double;
     NomFile, TransFile, AnalFrom, AnalTo : Integer) : boolean;
  Procedure REPORTRUN;
  Procedure RepHeadings;
  Procedure Printtots;
  Procedure PrintAll;
  Procedure ProcBalanceSheet;

implementation
Uses
    NewClass,
    Dialogs,
    SysUtils,
    UPrintOut,
    NomReps,
    NsPrint,
    util,
    clears,
    DbCore,
    params,
    calcs,
    DBRPT,
    abortprg,
    filed,
    vars,
    dbgen,
    Graphics;


  (*
  This Function readthru the transaction file using the enterprise code
  and the nominal code selected by the user. It calculates the quantity of
  for the particular nominal code. Uses Analysis Code if 0 to 9999

  ** If you call this Function and do not want Analysis Code Filtering pass
  0 as AnalFrom
  9999 as AnalTo
  *)
  Function calc_qty ( check_amt : Boolean; nominal_code, Fdt, Tdt : integer;
           var nominal_name : Shortstring; var total_qty, total_amt : double;
           NomFile, TransFile, AnalFrom, AnalTo : Integer) : boolean;
  var
    amt : Double{long};
    AnalysisCode,
    debit_ac,				     (* store debit account number *)
    credit_ac,
    first_tx,				 (* store first trans from nominal *)
    tx_type,					       (* transaction type *)
    tx_advance : integer;			  (* trans counter advance *)

  Begin
    total_amt	  := 0;
    
    AnalysisCode  := 0;
    amt		  := 0;

    total_qty	   := 0;				    (* assume zero *)
    calc_qty	  := false;
    debit_ac	  := 0;
    credit_ac	  := 0;
    first_tx	  := 0;
    tx_advance	  := 0;
    tx_type	  := 0;
    nominal_name  := null;

    setdb ( NomFile );
    readrec ( NomFile, nominal_code );

    if errorno = 0 then
      if recactive ( NomFile ) then
	Begin
	  getitem ( NomFile, 1 );
	  nominal_name := currstr;
	  slimleft ( nominal_name );
	  slimright ( nominal_name );
	  getitem ( NomFile, 15 );
	  if currint > 0 then
	    first_tx := currint;	   (* get the first transaction no *)
	End
      else
	Begin
	  calc_qty := false;
	  exit;
	End;

    if first_tx > 0 then
      Begin
	tx_advance := first_tx;
	setdb ( TransFile );
	repeat
	  readrec ( TransFile, tx_advance );
//          lasttx := tx_advance;

          getitem ( TransFile, 1 );
          tx_type := currint;

          if ( tx_type = 9 ) then
             Begin
                getitem ( TransFile, 18 );
                debit_ac := currint;
                getitem ( TransFile, 19 );
                credit_ac := currint;
                GetItem ( TransFile, 12 );
                AnalysisCode := CurrInt;

		if nominal_code = debit_ac then
		  Begin
		    getitem ( TransFile, 13 );
		    tx_advance := currint;
		    if tx_advance = 0 then
		      begin
		        tx_advance := -1;
		        calc_qty := true;
		      End;
                    getitem ( TransFile, 2 );
		    If ((currint>=FDT) And (currint<=TDT)) And
                       (( AnalysisCode >= AnalFrom ) And ( AnalysisCode <= AnalTo )) Then
		      If CheckEditStatus Then
		        Begin
		          getitem ( TransFile, 6 );
		          total_qty := currlong + total_qty;
		          If check_amt Then
		            Begin
		      	      getitem ( TransFile, 17 );
			      amt := amt + currlong;
                            End;
                        End;
                  End
                Else
		   if nominal_code = credit_ac then
		      Begin
			getitem ( TransFile, 14 );
			tx_advance := currint;
			if tx_advance = 0 then
			  Begin
			    tx_advance := -1;
			    calc_qty := true;
			  End;
			getitem ( TransFile, 2 );
		        If ((currint>=FDT) And (currint<=TDT)) And
                           (( AnalysisCode >= AnalFrom ) And ( AnalysisCode <= AnalTo )) Then
			  if CheckEditStatus then
			    Begin
			      getitem ( TransFile, 6 );
			      total_qty := currlong + total_qty; (* add to total *)
			      If check_amt Then
				Begin
				  getitem ( TransFile, 17 );
				  amt := amt - currlong;
				End;
			    End;
		      End
                   Else
		      tx_advance := tx_advance + 1;		(* advance *)
             End
          Else
              tx_advance := tx_advance + 1;			(* advance *)

	Until ( tx_advance > DB1.DBRECHIGH ) or ( tx_advance = -1 );

      End;
      { As we're using double the quantity needs to be Divide by 100 to get the decimals }
      Total_Qty := Total_Qty / 100;
      If check_amt Then
	total_amt := amt;
  End;

  { ** 18-04-94 This Procedures main body cannot have any more if, case
       statements added or it will cause a compilation error }
  PROCEDURE REPORTRUN;
  VAR
    X	    : INTEGER;
    SUB	    : INTEGER;
    OK	    : BOOLEAN;
    ENTREC  : INTEGER;
{-->>    PERIOD1,}
{-->>    PERIOD2	: integer;}
    get_nominal : integer;     (* used to search transaction file & get qtys *)

    PROCEDURE RR1;
    BEGIN						 { begin RR1 }
      HEADING:=NULL;
      IF PROG=SPECREP THEN
	CASE ACT OF
	  1  : If Cash11.xuse_inc_exp Then
		 heading := 'STANDING ORDER INCOME LISTING'
	       Else
		 HEADING:='CASHBOOK INCOME LISTING';
	  2  : If Cash11.xuse_inc_exp Then
		 heading := 'STANDING ORDER EXPENDITURE LISTING'
	       Else
		 HEADING:='CASHBOOK EXPENDITURE LISTING';
	  3  : if NOT Cash11.xuse_inc_exp then
		  HEADING:='OTHER TRANSACTION LISTING'
	       else
		  HEADING:='NON-LEDGER TRANSACTION LISTING';
	  4  : HEADING := 'BANK RECONCILIATION';
	  5  : HEADING := 'BANK AUDIT TRAIL';
	  6  : HEADING := 'TRIAL BALANCE';
	  7  : HEADING := 'FULL NOMINAL LEDGER AUDIT TRAIL';
	  8  : HEADING := CONCAT(Cash1.XTAXCODE,' REPORT');
	  21 : HEADING := 'MANAGEMENT BALANCE SHEET';
	  30 : HEADING := 'TRANSACTION LISTING';
	  55 : HEADING := 'TRANSACTION LISTING';
	  66 : HEADING := CONCAT(Cash2.XENTUPPER,' STRUCTURE');
	  77 : HEADING := CONCAT('PRINT ',Cash2.XENTUPPER,'S');
	  88 : HEADING := 'PRINT NOMINAL ACCOUNTS';
	  89 : HEADING := 'PRINT REPORT GROUPS';
         100 : HEADING := 'TRIAL BALANCE BY GROUPS';
         101 : HEADING := 'FULL NOMINAL LEDGER AUDIT TRAIL BY GROUPS';
	END;
      IF PROG = ENTREP THEN
	CASE ACT OF
	  1 : HEADING:=CONCAT(Cash2.XENTUPPER,' COSTING REPORT (THIS YEAR)');
	  2 : HEADING:=CONCAT(Cash2.XENTUPPER,' COSTING REPORT (YEAR COMPARISON)');
	  3 : HEADING:=CONCAT(Cash2.XENTUPPER,' COSTING REPORT (PERIOD COMPARISON)');
	  4 : HEADING:=CONCAT(Cash2.XENTUPPER,' COSTING REPORT (THIS YEAR MONTHLY)');
	  5 : HEADING:=CONCAT(Cash2.XENTUPPER,' COSTING REPORT (LAST YEAR MONTHLY)');
	  6 : HEADING:=CONCAT(Cash2.XENTUPPER,' COST PER UNIT');
	END;
      {
      IF AUTOPROG=22 THEN
	BEGIN
	  IF ( Device[1] in ['F','P','S'] ) THEN
	    BEGIN
	      BETACLEAR;
	      BETATITLE (HEADING);
	    END;
	END
      ELSE
	BEGIN
	  BETACLEAR;
	  BETATITLE (HEADING);
	END;
      }
      NEXTLINE:=6;
      IF AUTOPROG<>22 THEN
	IF (AUTORUN AND NOT AUTOFIRST) OR ((PROG=SPECREP) AND (ACT=4)) THEN
	ELSE
	  BEGIN
	    {
            DIS (27,NEXTLINE,'Report Date: ');
	    SCRIN := XDATE;
	    repeat
	      recdat ( 40, nextline, scrin, temp_date, 0,0,0,0,0,0 );
	      IF ESCKEY THEN EXIT(REPORTRUN);
	      error_date ( report, go_on );
	    until NOT CHECK_DATE ( SCRIN, DEFAULT_DATE );
	    XDATE:=SCRIN;

	    CLEARFROM ( 24 );
	    NEXTLINE:=NEXTLINE+2;
            DAYTOT:=DAYTOT-32000;
            }
	  END;
    END;					       { end RR1 }

    { This procedure test if act is 5. I had to add this new procedure because}
    { the compiler gave an error - back end error to may statements }
    Procedure select_stub_type;
    Begin
      if act = 5 then
	Begin
	  {
          dis ( 2, nextline,'Presented, Un-Presented, All (P/U/A): ');
	  repeat
	    no_func_key;
	    st[1] := 'A';
	    rec ( 40, nextline, 1, st, 0,0,0,0,0,0 );
	    if esckey then exit ( reportrun );

	    if scrin[1] = 'p' then
	      scrin[1] := 'P'
	    else
	      if scrin[1] = 'u' then
		scrin[1] := 'U'
	      else
		if scrin[1] = 'a' then
		  scrin[1] := 'A';
	  until scrin[1] in ['P','U','A'];
	  which_stub	:= space1;
	  which_stub[1] := scrin[1];
	  nextline := nextline + 2;
          }
	End;
    End;

  BEGIN						       { begin REPORTRUN }
    {
    IF AUTOPROG=22 THEN
      BEGIN
	OK:=FALSE;
	IF ((ACT=1) AND (PICKOPT[11]))
	OR ((ACT=2) AND (PICKOPT[12]))
	OR ((ACT=3) AND (PICKOPT[13]))
	OR ((ACT=5) AND (PICKOPT[14]))
	OR ((ACT=6) AND (PICKOPT[15]))
	OR ((ACT=7) AND (PICKOPT[16]))
	OR ((ACT=8) AND (PICKOPT[17])) THEN OK:=TRUE;
	IF NOT OK THEN
	  BEGIN
	    ESCKEY:=TRUE;
	    EXIT;
	  END;
      END;
    }
    StartPrint ( False );

    get_nominal := 0;
{-->>    PERIOD1 := 0;}
{-->>    PERIOD2 := 0;}
    SCHSTUBF:=0;
    SCHSTUBT:=0;
    {MONTH   :=0;}
    BANKNO  :=0;
    BANKNAME:=NULL;
    BANKBAL :=NULL;
    {
    if not autorun then
      TAXAUDIT:=False;
    }
    FOR X:=1 TO	 2 DO TOTAMT[X]:=0;
    FOR X:=1 TO	 2 DO TOTTAX[X]:=0;

    FOR X := 1 TO 2 DO EC_TOTAMT[X] := 0;     { initialize ec amounts }
    EC_TOTTAX := 0;			      { and tax rates }

    FOR X:=1 TO 10 DO
      FOR SUB:=1 TO 6 DO
	BALTOT[X][SUB]:=0;

    RR1;

    {
    IF (PROG=SPECREP) AND (ACT IN [4,5]) THEN
      BEGIN
	SCHRECF:=XBANKMIN;
	SCHRECT:=XBANKMAX;
      END;
    }
    {IF (DBNO<>6) AND (ACT<>21) AND (NOT AUTORUN) THEN}
    (*
    IF (DBNO<>6) AND ( NOT ( ACT IN [21,121] )) AND (NOT AUTORUN) THEN
      BEGIN
	REPEAT
          IF (PROG=SPECREP) AND (ACT In [89, 100,101]) THEN
	    DIS (15,NEXTLINE,'List Report Groups From: ')
	  ELSE
	    IF (PROG=SPECREP) AND (ACT IN [88,6,7,4,5]) THEN
	      IF ACT=4
		THEN DIS (20,NEXTLINE,'List Accounts From: ')
		ELSE DIS (20,NEXTLINE,'List Accounts From: ')
		{ELSE DIS (19,NEXTLINE,'Print Accounts From: ')}
	    ELSE
	      IF (PROG=SPECREP) AND (ACT=8)
		THEN DIS (15,NEXTLINE,'Total Transactions From: ')
		ELSE DIS (16,NEXTLINE,'List Transactions From: ');
		{ELSE DIS (15,NEXTLINE,'Print Transactions From: ');}
	  DIS (36,NEXTLINE+1,'To: ');
	  STR(SCHRECF,ST);
	  REPEAT
	    REPEAT
	      GetRanges ( nextline );
	    UNTIL NUMERIC(SCRINT);
	    INTVAL(SCHRECF,SCRINT);
	    tx_start := schrecf;       { start transaction for sort routine }

	    OK:=TRUE;
	    IF (PROG=SPECREP) AND (ACT IN [4,5]) THEN
	      IF (SCHRECF<XBANKMIN) OR (SCHRECF>XBANKMAX) THEN OK:=FALSE;
	  UNTIL OK;
	  STR(SCHRECT,ST);
	  REPEAT
	    REPEAT
	      GetRanges ( Nextline+1 );
	    UNTIL ESCKEY OR NUMERIC(SCRINT);
	    OK:=TRUE;
	    IF NOT ESCKEY THEN
	      BEGIN
		INTVAL(SCHRECT,SCRINT);
		tx_end := schrect;	  { end transaction sort at this no }
		IF (PROG=SPECREP) AND (ACT IN [4,5]) THEN
		  IF (SCHRECT<XBANKMIN) OR (SCHRECT>XBANKMAX) THEN OK:=FALSE;
	      END;
	  UNTIL OK;
	UNTIL (NOT ESCKEY) AND (SCHRECF>0) AND (SCHRECT>=SCHRECF);
	NEXTLINE:=NEXTLINE+3;
      END
    ELSE
      IF AUTORUN THEN
	IF (PROG=SPECREP) AND (ACT IN [1,2,3]) THEN
	  IF (XLASTTX>=1) AND (XLASTTX<=DB1.DBRECHIGH) THEN SCHRECF:=XLASTTX;
    *)

    (*
    IF ((DBNO=2) OR ((PROG=SPECREP) AND (ACT IN [101,7,4,5]))) AND NOT AUTORUN THEN
      BEGIN
	date1 := null;
	date2 := null;

	get_period ( PERIOD1, PERIOD2, DATE1, DATE2, ACT, NEXTLINE,
		     fromdt, todt );

	from_date := fromdt;
	to_date := todt;

	if ESCKEY then EXIT ( REPORTRUN );

	get_list_all; {* check if prog = specrep and act =30 list transactions }

	IF (PROG=SPECREP) AND (ACT In [7,101]) AND
	   (FROMDT=-32765) AND (TODT=+32765) THEN
	  REPEAT
	    DIS (49,NEXTLINE,'Transaction Numbers From: ');
	    DIS (71,NEXTLINE+1,'To: ');
	    STR(SCHTXF,ST);
	    REPEAT
	      no_func_key;
	      REC (75,NEXTLINE,5,ST,0,0,0,0,0,0);
	      IF ESCKEY THEN EXIT(REPORTRUN);
	      ST:=SCRIN;
	    UNTIL NUMERIC(SCRINT);
	    INTVAL(SCHTXF,SCRINT);
	    STR(SCHTXT,ST);
	    REPEAT
	      no_func_key;
	      REC (75,NEXTLINE+1,5,ST,0,0,0,0,0,0);
	      ST:=SCRIN;
	    UNTIL ESCKEY OR NUMERIC(SCRINT);
	    IF NOT ESCKEY THEN INTVAL(SCHTXT,SCRINT);
	  UNTIL (NOT ESCKEY) AND (SCHTXF>0) AND (SCHTXT>=SCHTXF);
	NEXTLINE:=NEXTLINE+3;
      END;

    IF (PROG=SPECREP) AND (ACT=4) AND (NOT AUTORUN) THEN
      BEGIN
	which_reconcil;
	DIS ( 2,NEXTLINE,  'Include ...... Presented Stubs (Y/N): ');
	DIS (10,NEXTLINE+1,	   '....Un-Presented Stubs (Y/N): ');
	DIS (10,NEXTLINE+2,	   '... Error-Posted Stubs (Y/N): ');
	REPEAT
	  ASKYES(40,NEXTLINE,  STUBP,0);
	  IF ESCKEY THEN EXIT(REPORTRUN);
	  ASKYES(40,NEXTLINE+1,STUBU,0);
	  IF ESCKEY THEN EXIT(REPORTRUN);
	  ASKYES(40,NEXTLINE+2,STUBE,0);
	  IF ESCKEY THEN EXIT(REPORTRUN);
	UNTIL (STUBU) OR (STUBP) OR (STUBE);
	NEXTLINE:=NEXTLINE+4;
	DIS (21,NEXTLINE,'Stub Numbers From: ');
	DIS (36,NEXTLINE+1,'To: ');
	REPEAT
	  IF SCHSTUBF>0
	    THEN STR(SCHSTUBF,ST)
	    ELSE ST:=NULL;
	  REPEAT
	    no_func_key;
	    REC (40,NEXTLINE,8,ST,0,0,0,0,0,0);
	    IF ESCKEY THEN EXIT(REPORTRUN);
	    ST:=SCRIN;
	  UNTIL NUMERIC(SCRINT) OR  (SCRINT=NULL);
	  WHILE LENGTH (SCRINT)<8 DO SCRINT:=CONCAT('0',SCRINT);
	  INTVAL(STUB1,COPY(SCRINT,1,4));
	  INTVAL(STUB2,COPY(SCRINT,5,4));
	  SCHSTUBF:=STUB1;
	  SCHSTUBF:=(SCHSTUBF*10000)+STUB2;
	  IF SCHSTUBT>0
	    THEN STR(SCHSTUBT,ST)
	    ELSE ST:=NULL;
	  REPEAT
	    no_func_key;
	    REC (40,NEXTLINE+1,8,ST,0,0,0,0,0,0);
	    ST:=SCRIN;
	  UNTIL ESCKEY OR NUMERIC(SCRINT) OR (SCRINT=NULL);
	  IF NOT ESCKEY THEN
	    BEGIN
	      WHILE LENGTH (SCRINT)<8 DO SCRINT:=CONCAT('0',SCRINT);
	      INTVAL(STUB1,COPY(SCRINT,1,4));
	      INTVAL(STUB2,COPY(SCRINT,5,4));
	      SCHSTUBT:=STUB1;
	      SCHSTUBT:=(SCHSTUBT*10000)+STUB2;
	    END;
	UNTIL (NOT ESCKEY) AND ((SCHSTUBT=0) OR (SCHSTUBT>=SCHSTUBF));
	NEXTLINE:=NEXTLINE+3;
      END;
    *)
    { Only call if not using new reconciliation }
    (*
    IF ( PROG = SPECREP ) AND ( ACT IN [4,5] ) AND ( NOT AUTORUN ) And
       ( NOT new_rec ) THEN
      BEGIN
	DIS (4,NEXTLINE,'Show Stub Transaction Detail (Y/N): ');
	ASKYES(40,NEXTLINE,TXDETAIL,0);
	IF ESCKEY THEN EXIT(REPORTRUN);
	NEXTLINE:=NEXTLINE+2;
	  { if act = 5 select required stub to print P, U or A }
	select_stub_type;
      End;
    IF (( PROG=SPECREP ) AND ( ACT In [7,101] )) AND NOT AUTORUN THEN
      BEGIN
	DIS  ( 5,NEXTLINE,  'Include ... Start of Year Balance: ');
	DIS  (21,NEXTLINE+1,'Movement for Year: ');
	DIS  (16,NEXTLINE+2,'Movement for Last Year: ');
	DIS  (27,NEXTLINE+3,'Year Budget: ');
	DIS  (51,NEXTLINE,  'Start of Month Balance: ');
	DIS  (55,NEXTLINE+1,'Movement for Month: ');
	DIS  (57,NEXTLINE+3,'Year Budget Diff: ');

	DISB (40,NEXTLINE,  NOMYS);
	DISB (40,NEXTLINE+1,NOMYM);
	DISB (40,NEXTLINE+2,NOMLYM);
	DISB (40,NEXTLINE+3,NOMYB);
	DISB (75,NEXTLINE,  NOMPS);
	DISB (75,NEXTLINE+1,NOMPM);
	DISB (75,NEXTLINE+3,NOMYBV);

	REPEAT
	  ASKYES(40,NEXTLINE,NOMYS,0);
	  IF ESCKEY THEN EXIT(REPORTRUN);
	  ASKYES(75,NEXTLINE,NOMPS,0);
	  IF NOT ESCKEY THEN ASKYES(40,NEXTLINE+1,NOMYM,0);
	  IF NOT ESCKEY THEN ASKYES(75,NEXTLINE+1,NOMPM,0);
	  IF NOT ESCKEY THEN ASKYES(40,NEXTLINE+2,NOMLYM,0);
	  IF NOT ESCKEY THEN ASKYES(40,NEXTLINE+3,NOMYB,0);
	  IF NOT ESCKEY THEN ASKYES(75,NEXTLINE+3,NOMYBV,0);
	UNTIL NOT ESCKEY;
	NEXTLINE := NEXTLINE + 5;
      END;
    IF ((PROG=SPECREP) AND (ACT IN [101,7,5])) AND NOT AUTORUN THEN
      BEGIN
	DIS  ( 5,NEXTLINE,'Start a New Page for Each Account: ');
	DIS  (47,NEXTLINE,'Print Only if Transactions: ');

	DISB (40,NEXTLINE,NEWPAGEACC);
	DISB (75,NEXTLINE,PRINTZERO);

	REPEAT
	  ASKYES(40,NEXTLINE,NEWPAGEACC,0);
	  IF ESCKEY THEN EXIT(REPORTRUN);
	  ASKYES(75,NEXTLINE,PRINTZERO,0);
	UNTIL NOT ESCKEY;

	get_print_Desc_sort;
	NEXTLINE:=NEXTLINE+2;

      END;

    IF ((PROG=SPECREP) AND (ACT=5)) THEN
      BEGIN
	NOMYS :=true;	{'Y';}
	NOMYM :=true;	{'Y';}
	NOMLYM:=false;	{'N';}
	NOMYB :=false;	{'N';}
	NOMPS :=true;	{'Y';}
	NOMPM :=true;	{'Y';}
	NOMYBV:=false;	{'N';}
      END;
    IF ((PROG=SPECREP) AND (ACT=8)) AND NOT AUTORUN THEN
      BEGIN
	DIS ( 14-LENGTH(XTAXCODE), NEXTLINE,
	      CONCAT('Print ',XTAXCODE,' Audit Trail (Y/N): '));
	ASKYES (40,NEXTLINE,TAXAUDIT,0);
	IF ESCKEY THEN EXIT(REPORTRUN);
	NEXTLINE:=NEXTLINE+2;
      END;
    IF ((PROG=SPECREP) AND (ACT In [6,100])) AND NOT AUTORUN THEN
      BEGIN
	DIS    (10, NEXTLINE,'Print Extended Trial Balance: ');
	DISB   ( 40, NEXTLINE, EXTENDED );
	ASKYES ( 40, NEXTLINE, EXTENDED,0 );
	IF ESCKEY THEN EXIT ( REPORTRUN );
	NEXTLINE:=NEXTLINE+2;
	IF EXTENDED THEN
	  BEGIN
	    DIS	   ( 5,NEXTLINE,'Show Year or Month Movement (Y/M): ');
	    HDIS   (40,NEXTLINE,REPTYPE);
	    SCRIN:=REPTYPE;
	    REPEAT
	      no_func_key;
	      REC (40,NEXTLINE,1,SCRIN,0,0,0,0,0,0);
	      IF ESCKEY THEN EXIT(REPORTRUN);
	    UNTIL SCRIN[1] IN ['Y','M','y','m'];
	    IF SCRIN='m' THEN SCRIN:='M';
	    IF SCRIN='y' THEN SCRIN:='Y';
	    REPTYPE:=SCRIN;
	    NEXTLINE:=NEXTLINE+2;
	    IF REPTYPE='M' THEN
	      BEGIN
		month := xmonthno;
		DIS (17,NEXTLINE,'Calendar Month Number: ');
		STR (XMONTHNO,SCRIN);
		askint ( 40, nextline, 2, 1, 12, month, 0 );
		If esckey Then Exit ( reportrun );
		NEXTLINE:=NEXTLINE+2;
	      END;
	  END;
      END;
    *)
    IF DBNO=6 THEN
      BEGIN
	{
        DIS (16-LENGTH(XENTLOWER),NEXTLINE,
	  CONCAT('Which ',XENTLOWER,' (Blank for All): '));
	}
        REPEAT
	  {
          REPEAT
            disp_options := true;
	    allow_exit := false;
	    window_position := 'L';
	    F2_F3_active := true;
	    search_db := 6;
	    search_action := 1;

	    REC (40,NEXTLINE,4,SCHENT,0,40,40,6,1,all_ents);
	    IF ESCKEY THEN EXIT(REPORTRUN);
	    SCHENT:=SCRINT;
	  UNTIL SCRINT<>QUERY;
          }
	  OK:= (SCRINT= NULL);

	  {
          If (( prog = entrep ) and ( ACT = 6 )) then
	    Begin

              nextline := nextline + 2;
	      dis ( 2, nextline, 'Include per Quantity Breakdown (Y/N): ');
	      askyes ( 40, nextline, showbreakdown, 0 );
	      If esckey Then Exit ( reportrun );
	      nextline := nextline + 2;
	      date1 := null;
	      date2 := null;

	      If ( showbreakdown ) Or ( schent <> NULL ) Then
		Begin
		  get_period ( PERIOD1, PERIOD2, DATE1, DATE2, ACT, NEXTLINE,
			       fromdt, todt );
		  from_date := fromdt;
		  to_date := todt;
		  if ESCKEY then EXIT ( REPORTRUN );
		  nextline := nextline + 1;
		End;
	    End;
          }

	  IF NOT OK THEN
	    BEGIN
	      SETDB (DBNO);
	      ENTREC:=1;
	      WHILE ENTREC <= DB1.DBRECHIGH DO
		BEGIN

		  READREC (DBNO,ENTREC);

		  IF ERRORNO = 0 THEN
		    IF RECACTIVE (DBNO) THEN
		      BEGIN
			GETITEM ( DBNO, 1 );

			    (* if name matches the entered Enterprise *)
			IF CURRSTR = schent {SCRINT} THEN
			  Begin

			    if get_nominal = 0 then
			      Begin
				getitem ( dbno, 3 );
				if currlong <> 0 then
				  no_units := currlong 	(* store no of units *)
				else
				  no_units := 100;
				getitem ( dbno, 4 );
				unit_name := currstr; (* store enterprise name*)
				slimright ( unit_name );
				slimleft ( unit_name );
			      End;

			    (*
                            If (( prog = entrep ) and ( act = 6 )) then
			      Begin
				nextline := nextline + 2;
				searchent   := schent {scrint};
				getitem ( dbno, 6 );
				entfrom := currint;
				getitem ( dbno, 7 );
				entto	    := currint;

				select_accounts ( entfrom, entto, no_units );
			      End;
                            *)
			    OK := TRUE;
			    ENTREC := DB1.DBRECHIGH;

			  End;
		      End;

		  ENTREC := ENTREC + 1;
		END;
	    END
	  else
	    unit_name := null;

	UNTIL OK;
	NEXTLINE:=NEXTLINE+2;

	(*
        if (( prog = entrep ) and ( ACT = 6 ) and ( unit_name <> null )) then
	  begin

	    DIS (28-length(XENTLOWER),
		     NEXTLINE, Concat (XENTLOWER,' Unit Name: '));

	    REPEAT
	      ok_continue := false;
	      workstr := unit_name;

	      no_func_key;
	      REC (40, NEXTLINE, 15, workstr, 0,0,0,0,0,0);
	      IF ESCKEY THEN EXIT(REPORTRUN);

	      unit_name := scrint;

	      for x := 1 to length( unit_name ) do
		if unit_name[x] <> space1 then
		  ok_continue := true;

	    UNTIL ok_continue;

	    NEXTLINE := NEXTLINE + 2;

	    DIS (22-length (XENTLOWER),
		 NEXTLINE, Concat ('Number of ',XENTLOWER,' Units: '));
	    REPEAT
	      longstr ( no_units, workstr, 'L' );
	      slimright ( workstr );
	      slimleft ( workstr );

	      repeat
		no_func_key;
		REC (40, NEXTLINE, 12, workstr, 0,0,0,0,0,0);
		IF ESCKEY THEN
		  Begin
		    clearfrom ( 24 );
		    exit ( REPORTRUN );
		  End;
		workstr := scrint;
	      until isitlongno ( workstr, 'L', no_units );

	      if no_units = 0 then
		Begin
		  beepuser ( 1 );
		  clearfrom ( 24 );
		  dis ( 1, 24, 'NUMBER OF UNITS MUST BE NON-ZERO');
		End;

	    UNTIL no_units > 0;

	    clearfrom ( 24 );
	    single_ent := true;
	    NEXTLINE := NEXTLINE + 2;
	  end;
        *)

        (*
	IF (PROG=ENTREP) AND (ACT=1) THEN
	  BEGIN
	    DIS (5,NEXTLINE,'Show Monthly/Annual Budgets (Y/N): ');
	    askyes ( 40, nextline, showannual, 0 );
	    If esckey Then Exit ( reportrun );
	    INCWEEKLY :=FALSE;
	    NEXTLINE:=NEXTLINE+2;
	    IF (NOT SHOWANNUAL) AND (XNOMWEEK) THEN
	      BEGIN
		DIS (9,NEXTLINE,'Include Weekly Balances (Y/N): ');
		askyes ( 40, nextline, incweekly, 0 );
		If esckey then Exit ( reportrun );
		{
		REPEAT
		  no_func_key;
		  REC (40,NEXTLINE,1,'Y',0,0,0,0,0,0);
		  IF ESCKEY THEN EXIT(REPORTRUN);
		UNTIL SCRIN[1] IN ['Y','N','y','n'];
		INCWEEKLY:=(SCRIN[1] IN ['Y','y']);
		}
		NEXTLINE:=NEXTLINE+2;
		IF INCWEEKLY THEN
		  BEGIN
		    DIS (22,NEXTLINE,'From Week Number: ');
		    DIS (24,NEXTLINE+1,'To Week Number: ');
		    MINWEEK:=0;
		    MAXWEEK:=0;
		    REPEAT
		      REPEAT
			IF MINWEEK>0
			  THEN STR (MINWEEK,SCRIN)
			  ELSE SCRIN:='';
			REPEAT
			  no_func_key;
			  REC (40,NEXTLINE,2,SCRIN,0,0,0,0,0,0);
			  IF ESCKEY THEN EXIT(REPORTRUN);
			UNTIL NUMERIC (SCRINT);
			INTVAL (MINWEEK,SCRINT);
		      UNTIL MINWEEK IN [1..53];
		      REPEAT
			IF MAXWEEK>0
			  THEN STR (MAXWEEK,SCRIN)
			  ELSE SCRIN:='';
			REPEAT
			  no_func_key;
			  REC (40,NEXTLINE+1,2,SCRIN,0,0,0,0,0,0);
			  IF ESCKEY THEN EXIT(REPORTRUN);
			UNTIL NUMERIC (SCRINT);
			INTVAL (MAXWEEK,SCRINT);
		      UNTIL MAXWEEK IN [1..53];
		    UNTIL (MAXWEEK>=MINWEEK) AND (MAXWEEK-MINWEEK+1<=5);
		    NEXTLINE:=NEXTLINE+3;
		  END;
	      END;
	  END;
	*)

        (*
	If (( prog = entrep ) And ( act = 4 )) Then
	   Begin
	      If ( xfinmonth=xmonthno ) Then
		 scrin[1] := 'T'
	      Else
		 scrin[1] := 'P';
	      Dis ( 1, nextline, 'Period Summaries / Transactions (P/T):');
	      Repeat
		no_func_key;
		Rec ( 40, NEXTLINE, 1, scrin, 281, 0, 0, 0, 0, 0 );
		If esckey Then Exit ( REPORTRUN );
	      Until SCRIN[1] In ['P','T','p','t'];
	      use_tx := (SCRIN[1] IN ['T','t']);
	      NEXTLINE := NEXTLINE+2;
	   End;
        *)

	(*
        IF  (PROG=ENTREP) AND (ACT IN [5  ]) THEN MAXMONTH:=12;
	IF ((PROG=ENTREP) AND (ACT IN [3,4]))
	OR ((PROG=ENTREP) AND (ACT IN [1  ])) then
	  BEGIN
	    If NOT use_tx Then
	      Begin
		DIS (17,NEXTLINE,'Calendar Month Number: ');
		STR (XMONTHNO,SCRIN);
		month := xmonthno;
		askint ( 40, nextline, 2, 1, 12, month, 0 );
		If esckey Then Exit ( reportrun );
		MAXMONTH:=MONTH-XFINMONTH+1;
		IF MAXMONTH<1 THEN MAXMONTH:=MAXMONTH+12;
		NEXTLINE:=NEXTLINE+2;
	      End;
	  END;
        *)

      END;
    NOHEADING:=FALSE;
    PRINTSEL:='N';
    NUMBERONE:=TRUE;
    VERYFIRST:=TRUE;
    (*
    IF Device[1] = 'P' THEN
      BEGIN
	IF AUTORUN AND ((NOT AUTOFIRST) OR (AUTOPROG=22)) THEN
	ELSE
	  BEGIN
	    BoolAns := STARTPRINT ( 0 );
	    IF ESCKEY THEN EXIT(REPORTRUN);
	    ArrPos := 1;
	    If ( act = 121 ) And BalanceSheet Then ArrPos := 2;
	    IF Device[1]='P' THEN
	      FOR X := 1 TO 9 DO
		IF PLINEASCII[ArrPos][X]<>0 THEN
		  WRITE(PRINTFILE,CHR(PLINEASCII[ArrPos][X]));
	  END;
      END;
    *)
    TOTRECS:=0;
    DBTOT  :=0;
    CRTOT  :=0;
    PAGENO :=0;
    PDB	   :=0;
    PCR	   :=0;
    UDB	   :=0;
    UCR	   :=0;
    EDB	   :=0;
    ECR	   :=0;
    AMTTOT :=0;
    TAXDTOT:=0;

  END;						       { end REPORTRUN }

  Procedure REPHEADINGS;
  VAR
    Page,
    read_it,
    X,Y	    : INTEGER;
    WORKSTR : SHORTSTRING;
    ST	      : ShortString;

  BEGIN                                                { begin REPHEADING }
    WorkStr := '';
    If Device = 'P' Then
       Printer.Canvas.Font.Style := [fsBold];
    IF (PROG=SPECREP) AND (ACT=4) THEN EXIT;
    If ( Device[1] in ['C','F','P','S'] ) then
      Begin
        IF NOT VERYFIRST THEN
           If Device[1] = 'P' Then
              Printer.NewPage
	  Else
	     SKIPLINES(RFarmGate.PLINESPAGE[1]-LINECOUNT);
        LINECOUNT:=1;
	RepDash;
	VERYFIRST:=FALSE;
	PAGENO:=PAGENO+1;
	BLANKLINE;
	BUILDLINE(1,Cash1.XCOMPANY);
	IF Cash1.XCOMPANY<>NULL THEN BUILDLINE(0,'/');
	IF ACT IN [21,121,30,66,77,88,89] THEN
	  CASE ACT OF
	    121	  : BUILDLINE(0,'BALANCE SHEET');
	    21	  : BUILDLINE(0,'MANAGEMENT REPORTS-8');
	    30	  : BUILDLINE(0,'SPECIAL REPORT-30');
	    66	  : BUILDLINE(0,CONCAT(Cash2.XENTUPPER,'S-2'));
	    77	  : BUILDLINE(0,CONCAT(Cash2.XENTUPPER,'S-1'));
	    88	  : BUILDLINE(0,'NOMINAL CODES-8');
	    89	  : BUILDLINE(0,'NOMINAL CODES-9');
	  END
	ELSE
	  BEGIN
	    IF PROG=ENTREP  THEN BUILDLINE(0,CONCAT(Cash2.XENTUPPER,' REPORT-'));
	    IF PROG=SPECREP THEN BUILDLINE(0,'SPECIAL REPORT-');
	    If ( prog = specrep ) and ( act = 100 ) Then
	      STR(6,WORKSTR)
	    Else
	      STR(ACT,WORKSTR);
	    BUILDLINE(0,WORKSTR);
	  END;
	BUILDLINE(0,'	  ');
	BUILDLINE(0,HEADING);
	IF (PROG=SPECREP) AND (ACT In [6,100]) AND (REPTYPE='M') THEN
	  BEGIN
	    STR (MONTH,CURRSTR);
	    BUILDLINE(0,' - MONTH ');
	    BUILDLINE(0,CURRSTR);
	  END;
	If ( act = 121 ) And BalanceSheet Then
	    Begin
	       buildline ( 52, curr_time );
	       BUILDLINE ( 59, SPACE1);
//	       BUILDLINE ( 60, Cash1.XDATE);
	       BUILDLINE ( 60, REPXDATE);
	       BUILDLINE ( 70, 'PAGE ');
	    End
	Else
	    Begin
	       buildline ( RFarmGate.plinewidth[1]-30{28}, curr_time );
	       BUILDLINE(RFarmGate.PLINEWIDTH[1]-21,SPACE1);
//	       BUILDLINE(RFarmGate.PLINEWIDTH[1]-20,Cash1.XDATE);
	       BUILDLINE(RFarmGate.PLINEWIDTH[1]-20,REPXDATE);
               BUILDLINE(RFarmGate.PLINEWIDTH[1]-10,'PAGE ');
	    End;
	STR(PAGENO,WORKSTR);
	BUILDLINE(0,WORKSTR);
	OUTPUTLINE;
	BLANKLINE;
        If ( PROG = SPECREP ) And ( ACT In [8,11,12] ) Then
           Begin
              Page_Heading := Null;
              Str ( schrecf, WorkStr );
//tgm
              Page_heading:= '                                                       ';

              Page_heading:=Page_heading + 'Transaction ' + WorkStr + ' to ';
//              Page_heading := concat ( 'TRANSACTION ', WorkStr, ' TO ' );
              Str ( schrect, WorkStr );
              Page_heading:=Page_heading + WorkStr;

//              Page_heading := concat ( Page_Heading , WorkStr );
//              BuildLine ( Trunc (( RFarmGate.plinewidth[1] - length ( page_heading )) / 2 ),
//				Page_heading );
              Buildline (1,Page_Heading);
           End;
	OUTPUTLINE;
        BLANKLINE;

	BUILDLINE ( 1, SYSNAME );
        buildline ( RFarmGate.plinewidth[1]-length(verno), verno );

	{ 09/12/94 M.C.
	  if full nominal audut trail output the currrec nominals name }
	if (( prog = specrep ) and ( act = 7 )) then
	  Begin
	    page_heading := null;
	    read_it := currrec[NLFILE];
	    str ( currrec[NLFILE], page_heading );
	    page_heading := concat ( 'ACCOUNT ', page_heading );

	    if read_it > 0 then
	      Begin
		setdb ( NLFile );
		readrec ( NlFile, read_it );
		if errorno >  0 then DbErr;
		if recactive ( Nlfile ) then
		  Begin
		    getitem ( NLFile, 1 );
		    page_heading := concat ( page_heading, ' : ', currstr );

		    buildline ( trunc (( RFarmGate.plinewidth[1] - length ( page_heading )) / 2 ),
				page_heading );
		  End;
	      End;
	  End;

	{ 17/04/96 M.C.
	  if full nominal audut trail by group output the group name }
	If (( prog = specrep ) and ( act = 101 )) then
	  Begin
	    page_heading := null;
	    str ( curr_group, page_heading );
	    page_heading := concat ( 'GROUP ', page_heading );
	    If curr_group > 0 Then
	       ReadTables ( NlFile, curr_group, currstr )
	    Else
	       currstr := 'NO GROUP SPECIFIED';
	    page_heading := concat ( page_heading, ' : ', currstr );
	    buildline ( trunc (( RFarmGate.plinewidth[1] - length ( page_heading )) / 2 ),
			page_heading );
	  End;

	If (( act in [8,11, 12] ) and ( prog = specrep ) and
	   ( date1 <> null ) and ( date2 <> null ) and ( taxaudit )) then
	  buildline ( trunc ( ( RFarmGate.Plinewidth[1] - 27 ) div 2 ),
			concat ( 'PERIOD ',date1,' TO ',DATE2 ))
	Else
	  if ((( autoprog = 24 ) and ( prog = specrep ) and ( taxaudit ))
	      Or
	      (( prog = entrep ) and ( act = 6 )) and
	       ( date1 <> null ) and ( date2 <> null ))
	     then
	     buildline ( trunc ( ( RFarmGate.Plinewidth[1] - 27 ) div 2 ),
			  concat ('PERIOD ',date1,' TO ',date2 ))
	  Else
	    If (( prog = entrep ) And ( act = 6 ) And
		( period1 = 0 ) And ( period2 = 0 )) Then
		Begin
		  str ( Cash1.xfinyear, workstr );
		  buildline ( trunc (( RFarmGate.Plinewidth[1]-27) div 2),
			    concat ( 'PERIOD : YEAR ', workstr ));
		End;

	if (( prog = SPECREP ) And ( act in [ 1, 2 ] )) Then
	   buildline ( 45,'***** INDICATES MULTIPLE LINE TRANSACTIONS');

	if (( prog = SPECREP ) And ( act = 5 ) And ( report_sorted )) Then
	   Begin
	      workstr := '';
	      workstr := 'SORTED BY ';
	      If sort_fld = 2 Then
		 workstr := Concat ( workstr, 'DATE ')
	      Else
		 workstr := Concat ( workstr, 'STUB-NO ');
	      If sort_asc Then
		 workstr := Concat ( workstr, 'ASCENDING' )
	      Else
		 workstr := Concat ( workstr, 'DECENDING' );
	      buildline ((RFarmGate.plinewidth[1] div 2 )-(length(workstr) div 2 ), workstr );
	   End;

	If ( act = 121 ) And BalanceSheet Then
           BEGIN
                BUILDLINE(1,SYSNAME);
	        buildline ( 80-length ( verno ), verno );
           END
	Else
           BUILDLINE(1,SYSNAME);
	   buildline ( RFarmGate.plinewidth[1]-length ( verno ), verno );

	OUTPUTLINE;
	BLANKLINE;
      END;
    RepDash;
    BLANKLINE;
    IF NOHEADING THEN EXIT;
    IF PROG=SPECREP THEN
      CASE ACT OF
    //  30    : Buildline ( 1,'TRANS-NO  DATE	    AMOUNT       VAT/DISC  REF        DESCRIPTION   STUB-NO         TRANSACTION TYPE');                                        //Ch028
        30    : Buildline ( 1,' TX-NO  DATE	      AMOUNT       VAT/DISC  REF        DESCRIPTION   STUB-NO         TRANSACTION TYPE                        CUST/SUPP');       //Ch028
	66    : BUILDLINE (1,Cash2.XENTUPPER);
	77    : BEGIN
		  BUILDLINE ( 1, Cash2.XENTUPPER);
		  BUILDLINE (36,'INCOME-ACCOUNTS');
		  BUILDLINE (55,'EXPENDITURE-ACCOUNTS');
		  IF EXTRA THEN BUILDLINE (80,'EXPEND-COS-ACCOUNTS');
		END;
	3     : Begin
		  buildline (1,'RECORD        AMOUNT    DATE  DESCRIPTION ');
		  {
		  buildline (47,'CR-ACCOUNT  CR-NAME		DB-ACCOUNT  DB-NAME');
		  }
		  buildline (47,'DB-ACCOUNT  DB-NAME  CR-ACCOUNT  CR-NAME');
		End;
	{
	3     : BUILDLINE (1,'RECORD DB-ACCOUNT CR-ACCOUNT	AMOUNT	DATE	 DESCRIPTION');
	}
	(*
	11,12 : BEGIN
		  BUILDLINE ( 1,'RECORD	 TYPE[ORIG]  DATE      ACCOUNT	REFERENCE');
		  BUILDLINE (51,'ANALYSIS	AMOUNT		 VAT');
		  BUILDLINE (89,'VAT-CODE  DB-ACC  CR-ACC  DESCRIPTION');
		END;
	*)
	11,12 : begin
		  buildline ( 1,'RECORD	   DATE	      ACCOUNT');
		  buildline ( 51,'REFERENCE  AMOUNT    VAT');    
		  buildline ( 92,'VAT-CODE    DESCRIPTION');
		end;
	1,2   : BEGIN
		  BUILDLINE ( 1,'RECORD  DATE     REFERENCE');
		  BUILDLINE (33,'AMOUNT	   VAT/DISC');
		  if ACT = 1 then
                     BUILDLINE (55,'CUSTOMER')
		  else
                     BUILDLINE (55,'SUPPLIER');
		  BUILDLINE (77{79},'STUB-NO');
		  BUILDLINE (87{90}, 'ACCOUNT NAME');
                END;
	7,
	101   : BEGIN
		  buildline ( 1,'TRANS-NO STUB-NO      DEBIT    CREDIT');
		  buildline (44,'DATE   REF');
		  BUILDLINE (68,'DB--BALANCE--CR    QUANTITY');
		  {* New Code }
		  buildline ( 96, 'CUST/SUPP            DESCRIPTION');
		END;
	5     : Begin
		  BUILDLINE (1,'ACCOUNT-NUMBER   RECEIPT     PAYMENT');
		  buildline (53{52},' DATE    STATUS        TRANS-NO');
		  If txdetail Then
		     Begin
			buildline (90, 'CUSTOMER/SUPPLIER');
			buildline (113,'COMMENT/DESC.');
		     End;
		End;
	8     : BEGIN
		  IF (DATE1<>NULL) AND (DATE2<>NULL) THEN
		    BEGIN
		      BUILDLINE (20, CONCAT ( 'PERIOD ',DATE1,' TO ',DATE2 ));
		    END;
		  BUILDLINE (3,'TITLE');
		  BUILDLINE (65,'BOX');
		  BUILDLINE (74,'VALUE');
		END;
	6,21,
	121   : BEGIN
		  If act = 121 Then
		     Begin
			BUILDLINE (  1,'ACCOUNT NAME');
			str ( Cash1.xfinyear, workstr );
			BUILDLINE ( 52, workstr );
			str ( Cash1.xfinyear-1, workstr );
			BUILDLINE ( 72, workstr );
		     End
		  Else
		     Begin
			BUILDLINE (  1,'ACCOUNT NAME');
			IF ( EXTENDED ) or ( act = 21 ) THEN
			   BEGIN
                           // Trial Balance Header TGM 10/10/01
			      BUILDLINE ( 46,'DB---OPENING-BAL---CR');
			      CASE REPTYPE[1] OF
				 'M' : BUILDLINE ( 75,'DB--MONTH-MOVEMENT--CR');
				 'Y' : BUILDLINE ( 75,'DB--YEAR-MOVEMENT--CR');
			      END;
			      BUILDLINE (105,'DB---CLOSING-BAL---CR');
			   END
			ELSE
			   BUILDLINE (46,'DB---CURRENT-BAL---CR');
		     End;
		END;
	55    : BEGIN
		  BUILDLINE (  1,'RECORD TXTYPE NXTDB NXTCR NXTSP DATE');
		  BUILDLINE ( 42,'REF     ACC  DAC  CAC    AMOUNT');
		  BUILDLINE ( 77,'VAT VAT/DISC   NOM-AMT');
		  BUILDLINE (102, COPY(Cash2.XENTUPPER,1,3));
		  BUILDLINE (107,'NOM STUB-NO  ANL DESCRIPT ');
		END;
	88    : begin
		  BUILDLINE (1,'ACCOUNT-NUMBER NAME');
                  BuildLine(30,'GROUP');
		  buildline (55,'ACCOUNT-TYPE');
		end;
	89    : BUILDLINE (1,'REPORT-GROUP         NOMINAL-ACCOUNTS');
	 100  : BEGIN
		  BUILDLINE (  1,'GROUP   NAME');  // heading for trial balance by group
		  IF ( EXTENDED ) THEN
		    BEGIN
		      BUILDLINE ( 46,'DB---OPENING-BAL---CR');     // changed from 47 TGM AB 01/05/02
		      CASE REPTYPE[1] OF
			'M' : BUILDLINE ( 75,'DB--MONTH-MOVEMENT--CR');    // changed from 77 TGM AB 01/05/02
			'Y' : BUILDLINE ( 75,'DB--YEAR-MOVEMENT--CR');     // changed from 77 TGM AB 01/05/02
		      END;
		      BUILDLINE (105,'DB---CLOSING-BAL---CR');
		    END
		  ELSE
		    BUILDLINE (46,'DB---CURRENT-BAL---CR');        // changed from 47 TGM AB 01/05/02
		END;
      END;
    IF PROG=ENTREP THEN
      CASE ACT OF
	1,
	6   : BEGIN
		BUILDLINE ( 1, Cash2.XENTUPPER);
		if act = 6 then
	    //	  buildline ( 49, 'THIS-PRD') TGM AB
                  buildline ( 49, 'Total Cost')
		else
		  BUILDLINE (49,'THIS-YEAR   THIS-PERIOD');
		if act = 6 then				    (* change *)
		  (* on first pass thru heading ent. unit name is unknown *)
		  (* so get the name if unit_name is null *)
		  begin
		    if (( unit_name = null ) and ( NOT single_ent )
			and ( first_ent )) then
		      begin
			first_ent := false;
			setdb ( dbno );
			readrec (dbno, 1 );
			getitem ( dbno, 4 );
			{
			if errorno <> 0 then
			  currstr := null;
			}
			unit_name := currstr;
			slimright ( unit_name );
		      end;
		    SHOWANNUAL := false;      (* set these globals to false *)
		    INCWEEKLY  := false;
                    slimright ( unit_name );
	    // TGM AB	    buildline ( 61, concat ('  THIS-PRD/',unit_name ) );
                    buildline ( 61, concat ('  COST/',unit_name ) );
		    if showbreakdown then
		      Begin
			buildline ( 85, ' QUANTITY' );
	   // TGM AB		buildline ( 98, 'THIS-PRD/QUANTITY' );
                        buildline ( 98, 'COST/QUANTITY' );
		      End;

		  end;
		IF SHOWANNUAL THEN
		  BEGIN
		    BUILDLINE ( 77,'PD-BUDGET    PD-BUD-COMP');
		    BUILDLINE (105,'YR-BUDGET    YR-BUD-COMP');
		  END;
		IF INCWEEKLY THEN
		  FOR X:=MINWEEK TO MAXWEEK DO
		     BEGIN
		      STR (X,WORKSTR);
		      IF X<10 THEN WORKSTR:=CONCAT('0',WORKSTR);
		      BUILDLINE (81+((X-MINWEEK)*11),CONCAT('WEEK-',WORKSTR));
		    END;
	      END;
	2   : BEGIN
		BUILDLINE ( 1, Cash2.XENTUPPER);
		BUILDLINE (44,'THIS-YEAR-');
		STR (Cash1.XFINYEAR,ST);
		BUILDLINE (54,ST);
		STR (Cash1.XFINYEAR-1,ST);
		BUILDLINE (68,ST);
		STR (Cash1.XFINYEAR-2,ST);
		BUILDLINE (82,ST);
		STR (Cash1.XFINYEAR-3,ST);
		BUILDLINE (96,ST);
	      END;
	3   : BEGIN
		BUILDLINE (  1, Cash2.XENTUPPER);
		BUILDLINE ( 43,'THIS-PD-ACT');
		BUILDLINE ( 56,'THIS-PD-LST');
		BUILDLINE ( 69,'THIS-PD-BUD');
		BUILDLINE ( 85,'THIS-YTD');
		BUILDLINE ( 98,'LAST-YTD');
		BUILDLINE (109,'BUDGET-YTD');
		BUILDLINE (122,'ANNUAL-BUD');
	      END;
	4,5 : BEGIN
		BUILDLINE (  1, Cash2.XENTUPPER);
		BUILDLINE (127,'TOTAL');
		FOR X:=1 TO 12 DO
		  BEGIN
		    Y:=X+Cash1.XFINMONTH-1;
		    IF Y>12 THEN Y:=Y-12;
		    CASE Y OF
		      1 : BUILDLINE (38+(X*7),'JAN');
		      2 : BUILDLINE (38+(X*7),'FEB');
		      3 : BUILDLINE (38+(X*7),'MAR');
		      4 : BUILDLINE (38+(X*7),'APR');
		      5 : BUILDLINE (38+(X*7),'MAY');
		      6 : BUILDLINE (38+(X*7),'JUN');
		      7 : BUILDLINE (38+(X*7),'JUL');
		      8 : BUILDLINE (37+(X*7),'AUG');
		      9 : BUILDLINE (38+(X*7),'SEP');
		     10 : BUILDLINE (38+(X*7),'OCT');
		     11 : BUILDLINE (38+(X*7),'NOV');
		     12 : BUILDLINE (38+(X*7),'DEC');
		    END;
		  END;
	      END;
      END;
    OUTPUTLINE;
   (* if ( PROG=SPECREP ) And ( ACT = 30 ) then                                  // Ch028
       begin                                                                     // Ch028
          BlankLine;                                                             // Ch028
          Buildline ( 54,'CUSTOMER/SUPPLIER');     // TGM AB was 52              // Ch028
          OUTPUTLINE;                                                            // Ch028
       end;   *)                                                                 // Ch028

    RepDash;
    SKIPLINES(1);
    BLANKLINE;
    If Device = 'P' Then
       Printer.Canvas.Font.Style := []
  END;						    { end REPHEADING }

  PROCEDURE PRINTTOTS;
  VAR
    S1,S2     : ShortSTRING;
    X	      : INTEGER;
    ST	      : ShortSTRING;

    PROCEDURE PRINTBAL (TITLE: ShortString; TOTAL: LISTBAL);
    VAR
      COL : INTEGER;
      X,
      BAL : INTEGER;
    BEGIN					    { begin PRINTBAL }
      BLANKLINE;
      BUILDLINE (1,TITLE);
      COL:=33;
      If EXTENDED Then BAL:=1 Else BAL:=5;
      For X := BAL To 6 Do
	BEGIN
	  COL:=COL+12;
	  IF (X IN [3,5]) AND (EXTENDED) THEN COL:=COL+6;
          DoubleToStr ( Total[x], s1, '%10.2f', True, True, 10, False );
          {S1 := Format ( '%f', [Total[x]] );}
	  {LONGSTR (TOTAL[X],S1,'L');}
	  BUILDLINE (COL,S1);
	END;
      OUTPUTLINE;
    END;					    { end PRINTBAL }

    PROCEDURE SHOWBAL (COL: INTEGER; TITLE: ShortString; TOTAL: LISTBAL);
    VAR
      X,
      BAL : INTEGER;
    BEGIN					     { begin SHOWBAL }
      {
      DIS (1,COL,TITLE);
      }
      IF EXTENDED THEN BAL:=1 ELSE BAL:=5;
      FOR X:=BAL TO 6 DO
	BEGIN
          S1 := Format ('%f', [Total[x]] );
	  {LONGSTR (TOTAL[X],S1,'L');}
	  {DIS (((X-BAL+1)*12)-4,COL,S1);}
	END;
    END;					     { end SHOWBAL }

    PROCEDURE TAXRETURN;

      PROCEDURE TAXLINE (BOX: INTEGER; VALUE: Double{LONG}; TITLE: ShortString);
      VAR
	WORKSTR : ShortSTRING;
      BEGIN					      { begin TAXLINE }
	BLANKLINE;

	{ Changed position of title start point to col. 3 from (63 - len. title)
	BUILDLINE (63-LENGTH(TITLE),TITLE);
	}
	BUILDLINE ( 3, TITLE );
	STR (BOX,WORKSTR);
	BUILDLINE (66,WORKSTR);

	IF BOX = 5 THEN	     { Changed box for reclaim or paid from 7 to 5 }
	  IF VALUE < 0 THEN
	    BEGIN
	      VALUE := 0 - VALUE;
	      BUILDLINE (83,'(REPAYABLE)');
	    END
	  ELSE
	    BUILDLINE (83,'(PAYABLE)');
        DoubleToStr ( Value, WorkStr, '%f', True, True, 12, False );
	{LONGSTR (VALUE,WORKSTR,'L');}
	BUILDLINE (68,WORKSTR);
	OUTPUTLINE;
      END;					      { end TAXLINE }

    BEGIN					      { begin TAXRETURN }

      BLANKLINE;
      TAXLINE (1,TOTTAX[1],
	  CONCAT ( Cash1.XTAXCODE,' due in this period on sales and other outputs'));
      BLANKLINE;
      OUTPUTLINE;

      BUILDLINE ( 3,
	  CONCAT ( Cash1.XTAXCODE, ' due in this period on acquisitions from other ',
	  'EC Member' ));
      OUTPUTLINE;
      TAXLINE (2, EC_TOTTAX, 'States' );

      BLANKLINE;
      OUTPUTLINE;

      IF EC_TOTAMT[2] < 7500000 THEN	   {ensure the ec vat amount is zero}
	EC_TOTTAX := 0;

      TAXLINE (3,TOTTAX[1], CONCAT ('Total ',Cash1.XTAXCODE, ' due'));
      BLANKLINE;
      OUTPUTLINE;

      BUILDLINE (3, CONCAT
	 (Cash1.XTAXCODE,' reclaimed in this period on purchases and other inputs'));
      OUTPUTLINE;
      TAXLINE (4,TOTTAX[2],'( including acquisitions from the EC )');

      BLANKLINE;
      OUTPUTLINE;

      BUILDLINE ( 3, CONCAT
	      ('Net ',Cash1.XTAXCODE, ' to be paid to Customs or reclaimed by you'));
      OUTPUTLINE;
      TAXLINE (5,TOTTAX[1] - TOTTAX[2], '( difference between boxes 3 and 4 )');
      BLANKLINE;
      OUTPUTLINE;

      BUILDLINE ( 3,'Total value of Sales and all other outputs excluding any');
      OUTPUTLINE;
      TAXLINE (6, TOTAMT[1], CONCAT ( Cash1.XTAXCODE,' ( Plus BOX 8 below )' ));
      BLANKLINE;
      OUTPUTLINE;

      BUILDLINE
	    ( 3,'Total value of Purchases and all other inputs excluding any');
      OUTPUTLINE;
      TAXLINE (7, TOTAMT[2], CONCAT ( Cash1.XTAXCODE, ' ( Plus BOX 9 below )'));
      BLANKLINE;
      OUTPUTLINE;

      BUILDLINE
	    (3, 'Total value of all supplies of goods and related services' );
      OUTPUTLINE;
      TAXLINE
	(8, EC_TOTAMT[1],
	CONCAT( 'excluding any ', Cash1.XTAXCODE , ' , to other EC Member States'));
      BLANKLINE;
      OUTPUTLINE;

      BUILDLINE
	    (3,'Total value of all acquisitions of goods and related services' );
      OUTPUTLINE;
      TAXLINE
	(9, EC_TOTAMT[2],
	CONCAT( 'excluding any ', Cash1.XTAXCODE , ' , from other EC Member States'));
      BLANKLINE;
      OUTPUTLINE;
      
      BLANKLINE;

      OUTPUTLINE;
      OUTPUTLINE;
      (*
      while linecount < 66 do
	Begin
	  blankline;
	  outputline;
	End;
      *)

    END;						 { end TAXRETURN }

    PROCEDURE ASKAMT (COL,LINE: INTEGER; VAR BAL: LONG);
    VAR
      ST : ShortSTRING;
    BEGIN						 { begin ASKAMT }
      LONGSTR (BAL,ST,'L');
      SLIMLEFT (ST);
      IF BAL=0 THEN ST:=NULL;
      {
      HDIS (COL,LINE,'		  ');
      REPEAT
	no_func_key;
	REC (COL,LINE,12,ST,0,0,0,0,0,0);
	IF ESCKEY THEN EXIT (ASKAMT);
	ST:=SCRIN;
      UNTIL ISITLONG (ST,'L',CURRLONG) OR (SCRINT=NULL);
      IF SCRINT=NULL THEN CURRLONG:=0;
      BAL:=CURRLONG;
      LONGSTR (BAL,ST,'L');
      HDIS (COL,LINE,ST);
      }
    END;						  { end ASKAMT }

  BEGIN							  { begin PRINTTOTS }
    IF (DBNO=EntFile) OR ((PROG=SPECREP) AND (ACT IN [21,121,88,89])) THEN
      EXIT;
    IF (PROG=SPECREP) AND (ACT=8) THEN
      BEGIN
	TAXRETURN;
	EXIT;
      END;

    if (( Device[1] in ['C','F','P','S'] )
      AND NOT ( ACT IN [4 ] )) then

      BEGIN
	NOHEADING:=TRUE;
	IF (PROG=SPECREP) AND (ACT=6) THEN
	  BEGIN
	    IF LINECOUNT+30 > RFarmGate.PLINESPAGE[1]
	      THEN REPHEADINGS
	      ELSE SKIPLINES(RFarmGate.PLINESPAGE[1]-LINECOUNT-30);
	   END
	 ELSE
	   BEGIN
	    IF LINECOUNT+20 > RFarmGate.PLINESPAGE[1]
	      THEN REPHEADINGS
	      ELSE SKIPLINES(RFarmGate.PLINESPAGE[1]-LINECOUNT-20);
	   END;
	FOR X := 1 TO 2 DO
	  BEGIN
	    SENDLINE (NULL);
	    IF ESCKEY THEN EXIT;
	  END;
	IF ACT IN [3,1,2] THEN
	  BEGIN
	    SENDLINE ('TRANSACTION STATUS ... E=EDITED ... R=REVERSAL');
	    IF ESCKEY THEN EXIT;
	    SENDLINE (NULL);
	    IF ESCKEY THEN EXIT;
	    SENDLINE (NULL);
	    IF ESCKEY THEN EXIT;
	    {LINECOUNT:=LINECOUNT+3;}
	  END;
	SENDLINE ('TOTALS ... ');
	IF ESCKEY THEN EXIT;
	SENDLINE (NULL);
	IF ESCKEY THEN EXIT;
	IF PROG=SPECREP THEN
	  BEGIN

	    STR (TOTRECS,ST);
	    CASE ACT OF
	      6,
	      7,
	      5,
	      101	   : SENDLINE (CONCAT('NUMBER OF ACCOUNTS ... ',ST));
	      30,
	      3,1,2,55,11,12 : SENDLINE (CONCAT('NUMBER OF RECORDS .... ',ST));
	    END;
	    IF ESCKEY THEN EXIT;
	    IF ACT IN [1,2,11,12] THEN
	      BEGIN
		SENDLINE (NULL);
		IF ESCKEY THEN EXIT;
		{LONGSTR (AMTTOT,ST,'L');}
                DoubleToStr ( AmtTot, ST, '%10.2f', True, True, 12, False );
		SENDLINE (CONCAT('AMOUNT TOTAL ....... ',ST));
		IF ESCKEY THEN EXIT;
		{LONGSTR (TAXDTOT,ST,'L');}
                DoubleToStr ( TaxDTot, ST, '%10.2f', True, True, 12, False );
		SENDLINE (CONCAT('VAT/DISCOUNT ....... ',ST));
		IF ESCKEY THEN EXIT;
		{LONGSTR (AMTTOT+TAXDTOT,ST,'L');}
                DoubleToStr ( AmtTot+TaxDTot, ST, '%10.2f', True, True, 12, False );
                SENDLINE (CONCAT('GRAND TOTAL ........ ',ST));
		IF ESCKEY THEN EXIT;
		{LINECOUNT:=LINECOUNT+4;}
	      END;
	  END;
	SENDLINE (NULL);
	IF ESCKEY THEN EXIT;
	SENDLINE (NULL);
	IF ESCKEY THEN EXIT;
	{LINECOUNT:=LINECOUNT+7;}
	IF (PROG=SPECREP) AND (ACT IN [6,7,5,101]) THEN
	  BEGIN
	    LONGSTR(DBTOT,S1,'L');
	    LONGSTR(CRTOT,S2,'L');
{            DoubleToSTR(DBTOT,S1,'%f', true,true,12);
	    DoubleToSTR(CRTOT,S2,'%f', true,true,12);}

	    CASE ACT OF
	      5	  : PLINE:=CONCAT('RECEIPT TOTAL: ',S1,'    PAYMENT TOTAL: ',S2);
	      6,
	      7,
	      101 : begin
                         While Length(S1) < 12 do S1:=S1 + ' ';
                         PLINE:=CONCAT('Debit Total: ',S1,'   Credit Total: ',S2);
                    end;
	    END;
	    IF (DBTOT<>CRTOT) {AND (PRINTZERO)} AND
	       (SCHRECF=1) AND (SCHRECT=DB1.DBRECHIGH) THEN
		PLINE:=CONCAT(PLINE,'** Error in totals! **');
	    SENDLINE (PLINE);
	    IF ESCKEY THEN EXIT;
	    {LINECOUNT:=LINECOUNT+1;}
	  END;
	IF (PROG=SPECREP) AND (ACT=6) THEN
        // Trial Balance Footer - TGM 10/10/01
	  BEGIN
	    BLANKLINE;
	    OUTPUTLINE;
	    OUTPUTLINE;
	    IF EXTENDED THEN
	      BEGIN
		BUILDLINE ( 46,'DB---OPENING-BAL---CR');
		CASE REPTYPE[1] OF
		  'M' : BUILDLINE ( 75,'DB--MONTH-MOVEMENT--CR');
		  'Y' : BUILDLINE ( 75,'DB--YEAR-MOVEMENT--CR');
		END;
		BUILDLINE (105,'DB---CLOSING-BAL---CR');
	      END
	    ELSE
	      BUILDLINE ( 46,'DB---CURRENT-BAL---CR');
	    OUTPUTLINE;
	    BLANKLINE;
	    OUTPUTLINE;
	    PRINTBAL (CONCAT(Cash2.XENTUPPER,' INCOME'),	 BALTOT[1]);
	    PRINTBAL (CONCAT('NON-',Cash2.XENTUPPER,' INCOME'),BALTOT[2]);
	    PRINTBAL (CONCAT(Cash2.XENTUPPER,' EXPENESE'),	 BALTOT[3]);
	    PRINTBAL ('OVERHEADS',	      BALTOT[4]);
	    PRINTBAL ('CURRENT ASSETS',	      BALTOT[5]);
	    PRINTBAL ('FIXED ASSETS',	      BALTOT[6]);
	    PRINTBAL ('LIABILITIES',	      BALTOT[7]);
	    PRINTBAL ('BANK ACCOUNTS',	      BALTOT[8]);
	    PRINTBAL ('PRIVATE',	      BALTOT[9]);
	    PRINTBAL ('CONTROL ACCOUNTS',     BALTOT[10]);
	  END;
      END
    ELSE
      BEGIN
	IF (PROG=SPECREP) AND (ACT=4) THEN
	  BEGIN
	    {
            CLEARFROM (24);
	    DIS (1,24,'RECONCILE THIS BANK ACCOUNT (Y/N) ');
	    SCRIN:=BANKREC;
	    REPEAT
	      no_func_key;
	      REC (35,24,1,SCRIN,0,0,0,0,0,0);
	      IF ESCKEY THEN EXIT(PRINTTOTS);
	    UNTIL SCRIN[1] IN ['Y','N','y','n'];
	    BANKREC:=SCRIN;
	    IF BANKREC='n' THEN BANKREC:='N';
	    IF BANKREC='y' THEN BANKREC:='Y';
            }
	  END
	ELSE
	  BEGIN
	    {
            CLEARFROM(24);
	    DIS ( 1,24,'PRESS ENTER FOR TOTALS ');
	    no_func_key;
	    REC (25,24,0,NULL,0,0,0,0,0,0);
	    IF ESCKEY THEN EXIT(PRINTTOTS);
            }
	  END;
	{
        CLEARFROM (4);
	BETALINE;
	}
        {
        IF PROG=SPECREP THEN
	  BEGIN
	    CASE ACT OF
	      3,1,2,55,11,12 : BEGIN
				 DIS  ( 1,5,'NUMBER OF RECORDS .... ');
				 DISI (24,5,TOTRECS,1);
				 IF ACT IN [1,2,11,12] THEN
				   BEGIN
				     LONGSTR (AMTTOT,ST,'L');
				     DIS ( 1, 9,'AMOUNT TOTAL ....... ');
				     DIS (22, 9,ST);
				     LONGSTR (TAXDTOT,ST,'L');
				     DIS ( 1,11,'VAT/DISCOUNT ....... ');
				     DIS (22,11,ST);
				     LONGSTR (AMTTOT+TAXDTOT,ST,'L');
				     DIS ( 1,13,'GRAND TOTAL ........ ');
				     DIS (22,13,ST);
				   END;
			       END;
	      6,7,5	     : BEGIN
				 DIS  ( 1,5,'NUMBER OF ACCOUNTS ... ');
				 DISI (24,5,TOTRECS,1);
			       END;
	    END;
	  END;
	}

        {
        IF (ACT IN [6,7,4,5]) AND (PROG=SPECREP) THEN
	  BEGIN
	    NEXTLINE:=8;
	    LONGSTR(DBTOT,S1,'L');
	    LONGSTR(CRTOT,S2,'L');
	    CASE ACT OF
	      5	  : BEGIN
		      DIS (2,NEXTLINE,	CONCAT('RECEIPT TOTAL: ',S1));
		      DIS (2,NEXTLINE+1,CONCAT('PAYMENT TOTAL: ',S2));
		    END;
	      6,7 : BEGIN
		      DIS (2,NEXTLINE,	CONCAT(' DEBIT TOTAL: ',S1));
		      DIS (2,NEXTLINE+1,CONCAT('CREDIT TOTAL: ',S2));
		    END;
	    END;
	    SETDB(DBNO);
	    IF (DBTOT<>CRTOT) AND (NOT PRINTZERO) AND
	       (SCHRECF=1) AND (SCHRECT=DB1.DBRECHIGH) THEN
	      BEGIN
		DIS (40,NEXTLINE+1,'**** BALANCE ERROR ****');
		BEEPUSER(1);
	      END;
	  END;
	}
        IF (ACT=4) AND (PROG=SPECREP) THEN
	  BEGIN
	    {
            IF BANKREC='Y' THEN
	      BEGIN
		IF (DBTOT=0) AND (CRTOT>0) THEN DBTOT:=0-CRTOT;
		LONGSTR (DBTOT,ST,'L');
		DIS  (23, 6,'Computer Balance: ');
		HDIS (41, 6,ST);
		IF DBTOT<0 THEN DIS (55, 6,'(Overdrawn)');
		LONGSTR (UDB,ST,'L');
		DIS  (13, 8,'Total Unpresented Receipts: ');
		HDIS (41, 8,ST);
		LONGSTR (UCR,ST,'L');
		DIS  (13, 9,'Total Unpresented Payments: ');
		HDIS (41, 9,ST);
		DIS  (15,11,'Actual Statement Balance: ');
		STATBAL:=0;
		REPEAT
		  CLEARFROM (12);
		  BETALINE;
		  ASKAMT (41,11,STATBAL);
		  IF ESCKEY THEN EXIT (PRINTTOTS);
		  LONGSTR (DBTOT-UDB+UCR,ST,'L');
		  DIS  (11,12,'Calculated Statement Balance: ');
		  HDIS (41,12,ST);
		  LONGSTR (STATBAL-(DBTOT-UDB+UCR),ST,'L');
		  DIS  (19,14,'Reconciliation Error: ');
		  HDIS (41,14,ST);
		  IF STATBAL-(DBTOT-UDB+UCR)<>0
		    THEN IDIS (56,14,' ACCOUNT NOT RECONCILED ')
		    ELSE IDIS (56,14,' ACCOUNT RECONCILED ');
		UNTIL OKOK;
	      END;
            }
	    PDB	 :=0;
	    PCR	 :=0;
	    UDB	 :=0;
	    UCR	 :=0;
	    EDB	 :=0;
	    ECR	 :=0;
	    DBTOT:=0;
	    CRTOT:=0
	  END;

        IF (ACT=6) AND (PROG=SPECREP) THEN
	  BEGIN
	    SHOWBAL (12,CONCAT(COPY(Cash2.XENTUPPER,1,3),'-INC'),BALTOT[1]);
	    SHOWBAL (13,CONCAT('NON-',COPY(Cash2.XENTUPPER,1,3)),BALTOT[2]);
	    SHOWBAL (14,CONCAT(COPY(Cash2.XENTUPPER,1,3),'-EXP'),BALTOT[3]);
	    SHOWBAL (15,'O/HEAD' ,BALTOT[4]);
	    SHOWBAL (16,'C/ASSET',BALTOT[5]);
	    SHOWBAL (17,'F/ASSET',BALTOT[6]);
	    SHOWBAL (18,'LIAB',	  BALTOT[7]);
	    SHOWBAL (19,'BANK',	  BALTOT[8]);
	    SHOWBAL (20,'PRIVATE',BALTOT[9]);
	    SHOWBAL (21,'CONTROL',BALTOT[10]);
	  END;

        {LINECOUNT:=18;}
      END;
  END;							 { end PRINTTOTS }

  PROCEDURE PRINTALL;
  BEGIN							  { begin PRINTALL }
    AUTORUN:=TRUE;
    AUTOFIRST:=FALSE;
    (*
    FOR X:=1 TO 8 DO
      IF X IN [1,2,3,5,6,7,8] THEN
	IF (X=8) AND (XCOUNTRY=2) THEN
	  Begin
	    if pickopt[17] then
	      Begin
		{* set first and last transaction }
		setdb ( 2 );
		tx_start := 1;
		tx_end := db1.dbrechigh;
		ACT:=23;
	      End
	    else
	      act := 0;
	  End
	ELSE
	  BEGIN
	    ESCKEY:=FALSE;
	    ACT:=X;
	    CASE ACT OF
	      5,6,7   : DBNO:=1;
	      1,2,3,8 : DBNO:=2;
	    END;
	    SETDB (DBNO);

	    {* if Bank Audit Trail then Process all Transaction P, U, E }
	    which_stub := space1;
	    which_stub[1] := 'A';
	    {* if VAT report then run audit trail also }
	    if act = 8 then
	      Begin
		{taxaudit := space1;}
		taxaudit := true;
	      End;

	    REPSEG;

	    If ( ACT = 8 ) And ( TAXAUDIT ) And ( pickopt[17] ) Then
	      Begin
		{* set first and last transaction }
		setdb ( dbno );
		tx_start := 1;
		tx_end := db1.dbrechigh;

		CLEARFROM (24);

		SORT ( 2, 8, 10, 10, 999, 0, 0, TRUE, TRUE, TRUE, TRUE,
		       0, 0, false, false );

		CCLOSE ( 8, 'N' );
		CRESET ( 8, SORTID );

		IF ERRORNO > 0 THEN ABORT ( SEQERR );
		ACT := 11;
		REPSEG;

		ACT := 12;
		if not esckey then
		  REPSEG;

		CCLOSE (8,'P');
	      End;

	  END;
      *)
  END;
  							 { end PRINTALL }

  PROCEDURE ProcBalanceSheet;
  VAR
     no_partners : Integer;
     RECNO   : INTEGER;
     CATOT   : LISTBAL;
     FATOT   : LISTBAL;
     LITOT   : LISTBAL;
     WKTOT   : LISTBAL;
     OPTOT   : LISTBAL;
     SaveOp  : LISTBAL;
     SaveLd  : LISTBAL;
     TPTOT   : LISTBAL;
     X	     : INTEGER;
     WORKSTR : ShortSTRING;
 
     PROCEDURE ZEROTOTS;
     Var
        x : Integer;
     BEGIN						    { begin ZEROTOTS }
       FOR X:=1 TO 6 DO BALTOT[1][X]:=0;
     END;						    { end ZEROTOTS }

     PROCEDURE SAVETOTS;
     Var
        x : Integer;
     BEGIN						    { begin SAVETOTS }
       FOR X:=1 TO 6 DO WKTOT[X]:=BALTOT[1][X];
       ZEROTOTS;
     END;						    { end SAVETOTS }

     PROCEDURE RESTTOTS;
     Var
        x : Integer;
     BEGIN						    { begin RESTTOTS }
       FOR X:=1 TO 6 DO BALTOT[1][X]:=BALTOT[1][X]+WKTOT[X];
     END;							  { end RESTTOTS }

     PROCEDURE CALCTOTS (VAR VAL1: LONG; VAR VAL2: LONG);
     BEGIN						    { begin CALCTOTS }
       IF VAL1>VAL2 THEN
	 BEGIN
	   VAL1:=VAL1-VAL2;
	   VAL2:=0;
	 END
       ELSE
	 BEGIN
	   VAL2:=VAL2-VAL1;
	   VAL1:=0;
	 END;
     END;						     { end CALCTOTS }
 
     PROCEDURE SHOWTOTS ( TEXT: ShortString; FROMTOT: LISTBAL;
			  VAR TOTOT: LISTBAL; DASH: BOOLEAN);
     VAR
       COL : PACKED ARRAY [1..6] OF INTEGER;
       NegSign, x   : Integer;
     BEGIN						     { begin SHOWTOTS }
       COL[1]:=53;
       COL[2]:=72;
       COL[3]:=83;
       COL[4]:=95;
       COL[5]:=113;
       COL[6]:=125;
       FOR X:=1 TO 6 DO TOTOT[X]:=FROMTOT[X];
       IF DASH THEN
	 BEGIN
	   BLANKLINE;
	   OUTPUTLINE;
	   RepDash;
	 END;

       {
       CALCTOTS (TOTOT[1],TOTOT[2]);
       CALCTOTS (TOTOT[3],TOTOT[4]);
       CALCTOTS (TOTOT[5],TOTOT[6]);
       }
       totot[1] := totot[1] + totot[2];
       totot[5] := totot[5] + totot[6];

       BLANKLINE;
       BUILDLINE (1,TEXT);

       DoubleToStr ( Totot[1], WorkStr, '%f', True, True, 12, False );
       NegSign := Pos('-', WorkStr);
       If NegSign > 0 Then
          WorkStr[NegSign] := ' ';
       {
       LONGSTR (TOTOT[1],WORKSTR,'L');
       WORKSTR[12]:=SPACE1;
       }
       BUILDLINE (COL[2],'-');
       {
       BUILDLINE (COL[1],'-');
       If TOTOT[1]>0 Then
	  BUILDLINE (45,WORKSTR)
       Else
	  IF TOTOT[1]<0 THEN
	     BUILDLINE (44,Concat ('(',WORKSTR,')'));
       }
       If TOTOT[1]>0 Then
	  BUILDLINE (64,WORKSTR)      //65 AB 03/05/02 MOVED FIGURES ON BALANCE SHEET BY 1 TO LINE UP WITH THE TOTALS
       Else
	  IF TOTOT[1]<0 THEN
	     BUILDLINE (63,Concat ('(',WORKSTR,')'));         //66

       DoubleToStr ( Totot[5], WorkStr, '%f', True, True, 12, False );
       NegSign := Pos('-', WorkStr);
       If NegSign > 0 Then
          WorkStr[NegSign] := ' ';
       {
       LONGSTR (TOTOT[5],WORKSTR,'L');
       WORKSTR[12]:=SPACE1;
       }
       BUILDLINE (COL[1],'-');
       {
       BUILDLINE (COL[2],'-');
       If TOTOT[5]>0 Then
	  BUILDLINE (65,WORKSTR)
       Else
	  IF TOTOT[5]<0 THEN
	     BUILDLINE (64,Concat ('(',WORKSTR,')'));
       }
       If TOTOT[5]>0 Then
	  BUILDLINE (44,WORKSTR)         //45
       Else
	  IF TOTOT[5]<0 THEN
	     BUILDLINE (43,Concat ('(',WORKSTR,')'));    //44

       OUTPUTLINE;
       IF DASH THEN
	 BEGIN
	   RepDash;
	   BLANKLINE;
	   OUTPUTLINE;
	 END;
     END;						 { end SHOWOTOTS }

     PROCEDURE SHOWBALS (FROMREC,TOREC,TEST: INTEGER);
     VAR
       PRINT : BOOLEAN;
{-->>       LAST_TOTAL,}
       TOTAL : LONG;
     BEGIN						  { begin SHOWBALS }
       TOTAL:=0;
{-->>       LAST_TOTAL := 0;}
       RECNO:=FROMREC;
       REPEAT
	 READREC(DBNO,RECNO);
	 IF ERRORNO>0 THEN DbErr;
	 IF RECACTIVE(DBNO) THEN
	   BEGIN
	     OKTOPRINT:=TRUE;
	     PRINT    :=TRUE;
	     CASE TEST OF
	       1 : BEGIN
		     PRINT:=FALSE;
		     GETITEM(dbno,2);
		     IF CURRLONG<=0 THEN OKTOPRINT:=FALSE;
		   END;
	       3 : BEGIN
		     PRINT:=FALSE;
		     GETITEM(dbno,2);
		     IF CURRLONG>=0 THEN OKTOPRINT:=FALSE;
		   END;
	       2 : BEGIN
		     PRINT:=FALSE;
		     GETITEM(dbno,2);
		     IF CURRLONG <= 0 then
		       OKTOPRINT:=FALSE
		     ELSE
		       TOTAL := TOTAL + CURRLONG;
		     GETITEM(dbno,17);
		     IF CURRLONG > 0 then
{-->>		       LAST_TOTAL:=LAST_TOTAL+CURRLONG;}
		   END;
	       4 : BEGIN
		     PRINT:=FALSE;
		     GETITEM(dbno,2);
		     IF CURRLONG >= 0 then
		       OKTOPRINT:=FALSE
		     ELSE
		       TOTAL:=TOTAL+CURRLONG;
		     GETITEM(dbno,17);
		     IF CURRLONG < 0 then
{-->>		       LAST_TOTAL:=LAST_TOTAL+CURRLONG;}

		   END;
	       5 : PRINT:=FALSE;
	     END;
	     IF OKTOPRINT THEN PRINTOUT (PRINT);
	   END;
	 RECNO:=RECNO+1;
       UNTIL RECNO>TOREC;
       CASE TEST OF
	 1 : IF OKTOPRINT THEN SHOWTOTS (CONCAT(Cash1.XTAXCODE,' RECOVERABLE'),BALTOT[1],BALTOT[1],FALSE);
	 3 : IF OKTOPRINT THEN SHOWTOTS (CONCAT(Cash1.XTAXCODE,' PAYABLE'),	 BALTOT[1],BALTOT[1],FALSE);
	 2 : IF TOTAL> 0  THEN SHOWTOTS ('BALANCE AT BANK',BALTOT[1],BALTOT[1],FALSE);
	 4 : IF TOTAL< 0  THEN SHOWTOTS ('BANK OVERDRAFT', BALTOT[1], BALTOT[1],FALSE);
       END;
     END;						{ end SHOWBALS }

     PROCEDURE get_2_balances (FROMREC,TOREC,TEST: INTEGER);
     VAR
       count : Integer;
     BEGIN						  { begin SHOWBALS }
{-->>       count := 0;}

       For count := 1 To 2 Do
	 Begin
	   if count = 1 Then
	     recno := fromrec
	   Else
	     recno := torec;
	   READREC(DBNO,RECNO);
	   IF ERRORNO>0 THEN DbErr;
	   IF RECACTIVE(DBNO) THEN
	     BEGIN
	       OKTOPRINT:=TRUE;
	       PRINTOUT (false);
	     END;
	 End;
     END;						{ end get_2_balances }

     PROCEDURE SUBTITLE (TEXT: ShortString);
     BEGIN						{ begin SUBTITLE }
       BLANKLINE;
       BUILDLINE (1,TEXT);
       OUTPUTLINE;
       BLANKLINE;
       OUTPUTLINE;
     END;						 { end SUBTITLE }

   BEGIN						 { begin ProcBalanceSheet }
     SETDB(DBNO);

     SUBTITLE ('FIXED ASSETS');
     ZEROTOTS;
     SHOWBALS (Cash1.XNOMFAFROM,Cash1.XNOMFATO,0);
     SHOWTOTS ('TOTAL FIXED ASSETS',BALTOT[1],FATOT,TRUE);
     SUBTITLE ('CURRENT ASSETS');
     ZEROTOTS;
     SHOWBALS (Cash1.XNOMCAFROM,Cash1.XNOMCATO,0);
     BLANKLINE;
     OUTPUTLINE;
     SAVETOTS;
     SHOWBALS (Cash1.XNOMDEBTOR,Cash1.XNOMDEBTOR,5);
     SHOWTOTS ('DEBTORS',BALTOT[1],BALTOT[1],FALSE);
     RESTTOTS;
     SAVETOTS;
     SHOWBALS (Cash1.XNOMTAX,Cash1.XNOMTAX,1);
     RESTTOTS;
     SAVETOTS;
     SHOWBALS (Cash1.XBANKMIN,Cash1.XBANKMAX,2);
     RESTTOTS;
     SHOWTOTS ('TOTAL CURRENT ASSETS',BALTOT[1],CATOT,TRUE);
     SUBTITLE ('LESS LIABILITIES');
     ZEROTOTS;
     SHOWBALS (Cash1.XNOMLIFROM,Cash1.XNOMLITO,0);
     BLANKLINE;
     OUTPUTLINE;
     SAVETOTS;
     SHOWBALS (Cash1.XNOMCREDIT,Cash1.XNOMCREDIT,5);
     SHOWTOTS ('CREDITORS',BALTOT[1],BALTOT[1],FALSE);
     RESTTOTS;
     SAVETOTS;
     SHOWBALS (Cash1.XNOMTAX,Cash1.XNOMTAX,3);
     RESTTOTS;
     SAVETOTS;
     SHOWBALS (Cash1.XBANKMIN,Cash1.XBANKMAX,4);
     RESTTOTS;
     SHOWTOTS ('TOTAL LIABILITIES',BALTOT[1],LITOT,TRUE);
     ZEROTOTS;
     FOR X:=1 TO 6 DO BALTOT[1][X]:=CATOT[X]+LITOT[X];
     SHOWTOTS ('NET CURRENT ASSETS',BALTOT[1],BALTOT[1],FALSE);
     ZEROTOTS;

     FOR X:=1 TO 6 DO BALTOT[1][X]:=CATOT[X]+FATOT[X]+LITOT[X];
     SHOWTOTS ('TOTAL NET ASSETS',BALTOT[1],BALTOT[1],TRUE);

     blankline;
     outputline;
     blankline;
     buildline ( 1, 'REPRESENTED BY:');     //balance sheet problem??
     outputline;
     blankline;
     outputline;

     ZEROTOTS;
     For x := 1 To 6 Do
	Begin
	   SaveOp[x] := 0;
	   SaveLd[x] := 0;
	End;
     For no_partners := 1 To Cash11.xno_of_partners+1 Do
       Begin
	 get_2_balances (Cash1.XNOMPROFIT+no_partners-1,Cash1.XNOMOPEN+no_partners-1,5);
	 SHOWTOTS ('OPENING NET WORTH',BALTOT[1],OPTOT,FALSE);
	 For X := 1 To 6 Do
	    SaveOp[X] := SaveOp[X] + Optot[X];
	 ZEROTOTS;
       End;
     SHOWBALS (Cash1.XNOMINCFROM,Cash1.XNOMOHTO,5);
     SHOWTOTS ('TRADING PROFIT FOR YEAR',BALTOT[1],TPTOT,FALSE);
     BLANKLINE;
     OUTPUTLINE;
     For no_partners := 1 to Cash11.xno_of_partners+1 Do
       Begin
	 ZEROTOTS;
	 get_2_balances (Cash1.XNOMPRVINC+no_partners-1,Cash1.XNOMPRVEXP+no_partners-1,5);
	 SHOWTOTS ('LESS DRAWINGS',BALTOT[1],BALTOT[1],FALSE);
	 For X := 1 To 6 Do
	    SaveLd[X] := SaveLd[X] + BalTot[1][X];
       End;
     {
     FOR X:=1 TO 6 DO BALTOT[1][X]:=OPTOT[X]+TPTOT[X]+BALTOT[1][X];
     }
     FOR X:=1 TO 6 DO BALTOT[1][X]:=SaveOp[x]+TPTOT[x]+SaveLd[X];
     SHOWTOTS ('TOTAL NET WORTH',BALTOT[1],BALTOT[1],TRUE);
   END;						       { end ProcBalanceSheet }
  (*
  PROCEDURE ProcBalanceSheet;
  VAR
    no_partners : Integer;
    RECNO   : INTEGER;
    TOPREC  : STRING[4];
    CATOT   : LISTBAL;
    FATOT   : LISTBAL;
    LITOT   : LISTBAL;
    WKTOT   : LISTBAL;
    OPTOT   : LISTBAL;
    TPTOT   : LISTBAL;
    X	    : INTEGER;
    WORKSTR : STRING;

    PROCEDURE ZEROTOTS;
    Var
       X : Integer;
    BEGIN						   { begin ZEROTOTS }
      FOR X:=1 TO 6 DO BALTOT[1][X]:=0;
    END;						   { end ZEROTOTS }

    PROCEDURE SAVETOTS;
    Var
       X : Integer;
    BEGIN						   { begin SAVETOTS }
      FOR X:=1 TO 6 DO WKTOT[X]:=BALTOT[1][X];
      ZEROTOTS;
    END;						   { end SAVETOTS }

    PROCEDURE RESTTOTS;
    Var
       X : Integer;
    BEGIN						   { begin RESTTOTS }
      FOR X:=1 TO 6 DO BALTOT[1][X]:=BALTOT[1][X]+WKTOT[X];
    END;						   { end RESTTOTS }

    PROCEDURE CALCTOTS (VAR VAL1: LONG; VAR VAL2: LONG);
    BEGIN						   { begin CALCTOTS }
      IF VAL1>VAL2 THEN
	BEGIN
	  VAL1:=VAL1-VAL2;
	  VAL2:=0;
	END
      ELSE
	BEGIN
	  VAL2:=VAL2-VAL1;
	  VAL1:=0;
	END;
    END;						    { end CALCTOTS }

    PROCEDURE SHOWTOTS ( TEXT: STRING; FROMTOT: LISTBAL;
			 VAR TOTOT: LISTBAL; DASH: BOOLEAN);
    Var
       X   : Integer;
       COL : PACKED ARRAY [1..6] OF INTEGER;
    BEGIN						    { begin SHOWTOTS }
      COL[1]:=53;
      COL[2]:=72;
      COL[3]:=83;
      COL[4]:=95;
      COL[5]:=113;
      COL[6]:=125;
      FOR X:=1 TO 6 DO TOTOT[X]:=FROMTOT[X];
      IF DASH THEN
	BEGIN
	  BLANKLINE;
	  OUTPUTLINE;
	  RepDash;
	END;

      {
      CALCTOTS (TOTOT[1],TOTOT[2]);
      CALCTOTS (TOTOT[3],TOTOT[4]);
      CALCTOTS (TOTOT[5],TOTOT[6]);
      }
      totot[1] := totot[1] + totot[2];
      totot[5] := totot[5] + totot[6];

      BLANKLINE;
      BUILDLINE (1,TEXT);

      {LONGSTR (TOTOT[1],WORKSTR,'L');}
      DoubleToStr (TOTOT[1],WORKSTR,'%f', True, True, 12);
      WORKSTR[12]:=SPACE1;
      BUILDLINE (COL[1],'-');
      If TOTOT[1]>0 Then
	 BUILDLINE (45,WORKSTR)
      Else
	 IF TOTOT[1]<0 THEN
	    BUILDLINE (44,Concat ('(',WORKSTR,')'));

      {LONGSTR (TOTOT[5],WORKSTR,'L');}
      DoubleToStr (TOTOT[5],WORKSTR,'%f', True, True, 12);
      WORKSTR[12]:=SPACE1;
      BUILDLINE (COL[2],'-');
      If TOTOT[5]>0 Then
	 BUILDLINE (65,WORKSTR)
      Else
	 IF TOTOT[5]<0 THEN
	    BUILDLINE (64,Concat ('(',WORKSTR,')'));

      OUTPUTLINE;
      IF DASH THEN
	BEGIN
	  RepDash;
	  BLANKLINE;
	  OUTPUTLINE;
	END;
    END;						{ end SHOWOTOTS }

    PROCEDURE SHOWBALS (FROMREC,TOREC,TEST: INTEGER);
    VAR
      PRINT : BOOLEAN;
      LAST_TOTAL,
      TOTAL : LONG;
    BEGIN						 { begin SHOWBALS }
      TOTAL:=0;
      LAST_TOTAL := 0;
      RECNO:=FROMREC;
      REPEAT
	{
        IF (( Device[1] IN ['F','P','S'] ) and ( first_disp )) THEN
	  DISI (31,24,RECNO,4);
	}
        READREC(DBNO,RECNO);
	IF ERRORNO>0 THEN DbErr;
	IF RECACTIVE(DBNO) THEN
	  BEGIN
	    OKTOPRINT:=TRUE;
	    PRINT    :=TRUE;
	    CASE TEST OF
	      1 : BEGIN
		    PRINT:=FALSE;
		    GETITEM(1,2);
		    IF CURRLONG<=0 THEN OKTOPRINT:=FALSE;
		  END;
	      3 : BEGIN
		    PRINT:=FALSE;
		    GETITEM(1,2);
		    IF CURRLONG>=0 THEN OKTOPRINT:=FALSE;
		  END;
	      2 : BEGIN
		    PRINT:=FALSE;
		    GETITEM(1,2);
		    IF CURRLONG <= 0 then
		      OKTOPRINT:=FALSE
		    ELSE
		      TOTAL := TOTAL + CURRLONG;
		    GETITEM(1,17);
		    IF CURRLONG > 0 then
		      LAST_TOTAL:=LAST_TOTAL+CURRLONG;
		  END;
	      4 : BEGIN
		    PRINT:=FALSE;
		    GETITEM(1,2);
		    IF CURRLONG >= 0 then
		      OKTOPRINT:=FALSE
		    ELSE
		      TOTAL:=TOTAL+CURRLONG;
		    GETITEM(1,17);
		    IF CURRLONG < 0 then
		      LAST_TOTAL:=LAST_TOTAL+CURRLONG;

		  END;
	      5 : PRINT:=FALSE;
	    END;
	    IF OKTOPRINT THEN PRINTOUT (PRINT);
	    IF ESCKEY THEN EXIT;
	  END;
	RECNO:=RECNO+1;
      UNTIL RECNO>TOREC;
      CASE TEST OF
	1 : IF OKTOPRINT THEN SHOWTOTS (CONCAT(XTAXCODE,' RECOVERABLE'),BALTOT[1],BALTOT[1],FALSE);
	3 : IF OKTOPRINT THEN SHOWTOTS (CONCAT(XTAXCODE,' PAYABLE'),	BALTOT[1],BALTOT[1],FALSE);
	2 : IF TOTAL> 0	 THEN SHOWTOTS ('BALANCE AT BANK',BALTOT[1],BALTOT[1],FALSE);
	4 : IF TOTAL< 0	 THEN SHOWTOTS ('BANK OVERDRAFT', BALTOT[1], BALTOT[1],FALSE);
      END;
    END;					       { end SHOWBALS }

    PROCEDURE get_2_balances (FROMREC,TOREC,TEST: INTEGER);
    VAR
      count : Integer;
    BEGIN						 { begin SHOWBALS }
      count := 0;

      For count := 1 To 2 Do
	Begin
	  if count = 1 Then
	    recno := fromrec
	  Else
	    recno := torec;
	  {
          IF (( Device[1] IN ['F','P','S'] ) and ( first_disp )) THEN
	    DISI (31,24,RECNO,4);
	  }
          READREC(DBNO,RECNO);
	  IF ERRORNO>0 THEN DbErr;
	  IF RECACTIVE(DBNO) THEN
	    BEGIN
	      OKTOPRINT:=TRUE;
	      PRINTOUT (false);
	      IF ESCKEY THEN EXIT;
	    END;
	End;
    END;					       { end get_2_balances }

    PROCEDURE SUBTITLE (TEXT: STRING);
    BEGIN					       { begin SUBTITLE }
      BLANKLINE;
      BUILDLINE (1,TEXT);
      OUTPUTLINE;
      BLANKLINE;
      OUTPUTLINE;
    END;						{ end SUBTITLE }

  BEGIN							{ begin ProcBalanceSheet }
    SETDB(DBNO);
    {
    IF (( Device[1] IN ['F','P','S'] ) and ( first_disp )) THEN
      BEGIN
	CLEARFROM (24);
	STR (DB1.DBRECHIGH,TOPREC);
	DIS ( 1,24,'PROCESSING ACCOUNT NUMBER ...');
	DIS (36,24,CONCAT('(OF ',TOPREC,')'))
      END;
    }
    SUBTITLE ('FIXED ASSETS');
    ZEROTOTS;
    SHOWBALS (XNOMFAFROM,XNOMFATO,0);
    SHOWTOTS ('TOTAL FIXED ASSETS',BALTOT[1],FATOT,TRUE);
    SUBTITLE ('CURRENT ASSETS');
    ZEROTOTS;
    SHOWBALS (XNOMCAFROM,XNOMCATO,0);
    BLANKLINE;
    OUTPUTLINE;
    SAVETOTS;
    SHOWBALS (XNOMDEBTOR,XNOMDEBTOR,5);
    SHOWTOTS ('DEBTORS',BALTOT[1],BALTOT[1],FALSE);
    RESTTOTS;
    SAVETOTS;
    SHOWBALS (XNOMTAX,XNOMTAX,1);
    RESTTOTS;
    SAVETOTS;
    SHOWBALS (XBANKMIN,XBANKMAX,2);
    RESTTOTS;
    SHOWTOTS ('TOTAL CURRENT ASSETS',BALTOT[1],CATOT,TRUE);
    SUBTITLE ('LESS LIABILITIES');
    ZEROTOTS;
    SHOWBALS (XNOMLIFROM,XNOMLITO,0);
    BLANKLINE;
    OUTPUTLINE;
    SAVETOTS;
    SHOWBALS (XNOMCREDIT,XNOMCREDIT,5);
    SHOWTOTS ('CREDITORS',BALTOT[1],BALTOT[1],FALSE);
    RESTTOTS;
    SAVETOTS;
    SHOWBALS (XNOMTAX,XNOMTAX,3);
    RESTTOTS;
    SAVETOTS;
    SHOWBALS (XBANKMIN,XBANKMAX,4);
    RESTTOTS;
    SHOWTOTS ('TOTAL LIABILITIES',BALTOT[1],LITOT,TRUE);
    ZEROTOTS;
    FOR X:=1 TO 6 DO BALTOT[1][X]:=CATOT[X]+LITOT[X];
    SHOWTOTS ('NET CURRENT ASSETS',BALTOT[1],BALTOT[1],FALSE);
    ZEROTOTS;

    FOR X:=1 TO 6 DO BALTOT[1][X]:=CATOT[X]+FATOT[X]+LITOT[X];
    SHOWTOTS ('TOTAL NET ASSETS',BALTOT[1],BALTOT[1],TRUE);

    blankline;
    outputline;
    blankline;
    buildline ( 1, 'REPRESENTED BY:');
    outputline;
    blankline;
    outputline;

    ZEROTOTS;
    For no_partners := 1 To xno_of_partners+1 Do
      Begin
	get_2_balances (XNOMPROFIT+no_partners-1,XNOMOPEN+no_partners-1,5);
	SHOWTOTS ('OPENING NET WORTH',BALTOT[1],OPTOT,FALSE);
	ZEROTOTS;
      End;
    SHOWBALS (XNOMINCFROM,XNOMOHTO,5);
    SHOWTOTS ('TRADING PROFIT FOR YEAR',BALTOT[1],TPTOT,FALSE);
    BLANKLINE;
    OUTPUTLINE;
    For no_partners := 1 to xno_of_partners+1 Do
      Begin
	ZEROTOTS;
	get_2_balances (XNOMPRVINC+no_partners-1,XNOMPRVEXP+no_partners-1,5);
	SHOWTOTS ('LESS DRAWINGS',BALTOT[1],BALTOT[1],FALSE);
      End;
    FOR X:=1 TO 6 DO BALTOT[1][X]:=OPTOT[X]+TPTOT[X]+BALTOT[1][X];
    SHOWTOTS ('TOTAL NET WORTH',BALTOT[1],BALTOT[1],TRUE);
  END;							{ end ProcBalanceSheet }
  *)
end.

