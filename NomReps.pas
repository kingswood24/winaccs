Unit NomReps;
// tgm altered 16/10/01 tp check whether or not item is to included in VAT report by setting OKToPrint in line
// 1882 - I copied the code from lines 2043+ - I assume this is run first before line 1882 as the
// var testcode is initialised in lines 2043+
// lines 1833+ need altered if S ireland users to be allowed to include/exclude items from VAT return
// tgm added line 1895 to exclude VAT code 0 from S Ireland VAT return
InterFace
Uses
    types, db, dialogs;

Var
   From_Date,
   To_Date   : Integer;
  Period1,
  Period2    : Integer;
  Date1,
  Date2      : ShortString{[8]};
  PrintSel   : Char;
  TaxAudit   : Boolean;
  ans	     : char;
  page_heading : ShortString;  { hold the nominal acount name for the page heading }
  first_acc,	   { used in full nominal led trail to output account heading }
  EXTRA	     : BOOLEAN;
  SCHTXF     : INTEGER;
  SCHTXT     : INTEGER;
  BLKTOT     : LISTBAL;
  FROMDT     : INTEGER;
  TODT	     : INTEGER;
  MAXMONTH   : INTEGER;
  which_stub : ShortString{[1]};
  
  PRINTZERO,
  NOMYS,
  NOMYM,
  NOMPS,
  NOMPM,
  NOMLYM,
  NOMYB,
  NOMYBV,
  NEWPAGEACC,
  EXTENDED,
  STUBU,
  STUBP,
  STUBE,
  TXDETAIL   : Boolean;
  BANKREC    : ShortSTRING{[1]};
  REPTYPE    : ShortSTRING{[1]};
  TXDEBIT    : LONG;
  TXCREDIT   : LONG;
  STDEBIT    : LONG;
  STCREDIT   : LONG;
  STUBNO     : ShortSTRING{[8]};
  LASTSTUB   : ShortSTRING{[8]};
  LASTTXT    : INTEGER;
  THISDATE   : INTEGER;
  LASTDATE   : INTEGER;
  AUTORUN    : BOOLEAN;
  AUTOFIRST  : BOOLEAN;
  SCHENT     : ShortSTRING{[4]};
{  ACT	     : INTEGER;}
  DBTOT	     : LONG;
  CRTOT	     : LONG;
  HEADING    : ShortSTRING{[50]};
  TOTRECS    : INTEGER;
  OKTOPRINT  : BOOLEAN;
  NOHEADING  : BOOLEAN;
  VERYFIRST  : BOOLEAN;
  NUMBERONE  : BOOLEAN;
  PAGENO     : INTEGER;
  NEXTCOL    : INTEGER;
  COLHIGH    : INTEGER;
  PLINE	     : ShortSTRING{[255]};
  REPDATE    : ShortSTRING{[8]};
  DATETOT    : INTEGER;
  NEXTLINE   : INTEGER;
  DBNO	     : INTEGER;
  DATEFORMAT : ShortSTRING{[8]};
  showbreakdown,
  SHOWANNUAL : BOOLEAN;
  INCWEEKLY  : BOOLEAN;
  MINWEEK    : INTEGER;
  MAXWEEK    : INTEGER;
  BALTOT     : PACKED ARRAY [1..10] OF LISTBAL;
  TOTAMT     : PACKED ARRAY [1..2] OF Double{LONG};
  TOTTAX     : PACKED ARRAY [1..2] OF Double{LONG};

  EC_TOTAMT  : PACKED ARRAY [1..2] OF Double{LONG};	  { to cal. ec tax & amounts }
  EC_TOTTAX  : Double{LONG};
  no_units   : double {Long};
  cal_units  : double{long};
  unit_name  : ShortString{[15]};
  single_ent : boolean;
  VAT_PERIOD : integer;
  BANKNO     : INTEGER;
  BANKNAME   : ShortSTRING{[30]};
  BANKBAL    : ShortSTRING{[12]};
  PDB,PCR    : LONG;
  UDB,UCR    : LONG;
  EDB,ECR    : LONG;
  MONTH	     : INTEGER;
  AMTTOT     : LONG;
  TAXDTOT    : LONG;
  NEG	     : BOOLEAN;
  LASTCODE   : CHAR;
  SUBREC     : INTEGER;
  SUBAMT     : LONG;
  SUBTAX     : LONG;

  SCHSTUBF     : LONG;
  SCHSTUBT     : LONG;
  counter,
  last_counter : integer;
  nom_heading  : ShortString{[40]};
  first_ent    : boolean;
  curr_time    : ShortString;

  BalanceSheet,
  report_sorted,	      { set to true if report is sorted }
  sort_asc	 : boolean;   { set to true if report in ascending order }
  ArrPos,
  sort_fld,		      { which field to sort on }
  start_from,		      { first record to read from in transaction file }
  which_nominal	 : integer;   { which nominal code is to be sorted 0 for none }

  { The following are used for the list transaction report -
    Initialised in CATEXT:CBA.NSREPD.TEXT }
  tr_desc	: ShortString{[30]};	{ Used to distinguise Transactions }
  tr_listall,			{ set to 'Y' to list all }
  tr_cashinc,			{ set to 'Y' to list Cashbook or S.O. Income }
  tr_cashexp,			{ set to 'Y' to list Cashbook or S.O. Expend }
  tr_d_debits,			{ set to 'Y' to list Direct Debits/Journals }
  tr_cust,			{ set to 'Y' to list Customer Transactions }
  tr_supp	: Boolean;{string[1];}	  { set to 'Y' to list Supplier transactions }
  trial_by_group : ShortString{[1]};	{ set to 'Y' to Group Trial }
  curr_group	 : Integer;	{ Set in rep_nominal_by_group to allow group
				  Name in heading }
  comment_cust_supp,
  cust_supp	 : ShortString;{[30]}	{ Customer Supplier Name }
  BoolAns,
  new_rec,			{ True if using New Bank Rec. Routines }
  use_tx	 : Boolean;
  TempLong       : Long;
  TempStr        : ShortString;      { General purpose string for conversion }
  UsePreviousYear : Boolean;
  AnalysisCodeFrom,
  AnalysisCodeTo   : Integer;
  // GM meddled with 2 new vars below 18/02/03 to get nominal code unto transaction report
  //tr_debit, tr_credit : integer;
// next 2 vars added by tgm 16/10/01
    testcode	      : ShortString{[10]};
    vat_count	      : integer;
Procedure NomReports ( Option, DataBase : Integer );
{
Procedure PrintOut ( Print : Boolean );
}
{
Procedure Processsort;
Procedure ProcessBals;
Procedure ProcBalanceSheet;
Procedure ProcessTabs;
Procedure ProcessEnts;
Procedure Rep_Trial_By_Groups;
Procedure Rep_Nominal_By_Groups;
Procedure ProcessFile;
Procedure PrintOut ( Print : Boolean );
}

Implementation
Uses
    Sortit,
    SysUtils,
    UPrintOut,
    NsPrint,
    NsRep11,
    util,
    clears,
    DbCore,
    params,
    calcs,
    DBRPT,
    abortprg,
    filed,
    vars,
    NomRpt,
    EntReps,
    dbgen,
    Accsdata;

		   { main body at end of CBA.NSREPD.TEXT }
{
Modified : 13/06/95
Added New Report List Transactions, this report can be filtered by Cashbook
income, Cashbook expenditure, Direct Debits/Journals, Supplier or customer
Transactions.  The Globals PROG and ACT are set to SPECREP and 30.  Changes to
Repheadings, Processfile and Printout Procedures.
}
Procedure NomReports ( Option, DataBase : Integer );

{
PROCEDURE ERR; FORWARD;
PROCEDURE SKIPLINES(NOLINES: INTEGER); FORWARD;
PROCEDURE BUILDLINE(COL: INTEGER; STRVAL: STRING); FORWARD;
PROCEDURE OUTPUTLINE; FORWARD;
PROCEDURE SKIPSCREEN(LINES: INTEGER); FORWARD;
PROCEDURE BLANKLINE; FORWARD;
PROCEDURE DASHLINE; FORWARD;
}
PROCEDURE REPSEG; FORWARD;
{
Function CheckNextTx ( db, RecTx : Integer ) : Boolean; Forward;
Procedure Totalrecs; Forward;
}

{
			       Kingswood Accounts
			       ------------------

   File	    : CATEXT:CBA.NSREP3.TEXT
   Created  : 03/04/96
   Modified :

   This Segment contains the code to print the Trial Balance using group
   codes.  All Nominals in Group 0 are included in group 0 "No Group Specified"
}

Procedure Rep_Trial_by_Groups;
  Var
    okprintit,			 { Set to true if nominals exist for Group }
    f_pass     : Boolean;	 { Set true on initial run to gather 0 Group }
    last_nom,			 { Last nominal included }
    table,			 { Table Group counter }
    recno,			 { Record Number }
    minacc,			 { Store first nominal in range }
				 { e.g. enterprise income accounts }
    maxacc    : Integer;	 { Store last nominal in range }
    tabdesc   : ShortString{[32]};	 { Store group table description }
    st	      : ShortString;		 { General use String }
    tot	      : Integer;	 { Array position within baltot array }
    total_opening,			 { Total opening balance for Group }
    total_year_mth,		 { Total year/month movement for group }
    total_closing : long;	 { Total closing for group }

    Procedure setrange;
    Begin					     { begin SETRANGE }
      IF (TABLE>=Cash1.XNOMINCFROM) AND (TABLE<=Cash1.XNOMINCTO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMINCFROM;
	  MAXACC:=Cash1.XNOMINCTO;
	END;
      IF (TABLE>=Cash1.XNOMNONFROM) AND (TABLE<=Cash1.XNOMNONTO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMNONFROM;
	  MAXACC:=Cash1.XNOMNONTO;
	END;
      IF (TABLE>=Cash1.XNOMEXPFROM) AND (TABLE<=Cash1.XNOMEXPTO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMEXPFROM;
	  MAXACC:=Cash1.XNOMEXPTO;
	END;
      IF (TABLE>=Cash1.XNOMOHFROM) AND (TABLE<=Cash1.XNOMOHTO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMOHFROM;
	  MAXACC:=Cash1.XNOMOHTO;
	END;
      IF (TABLE>=Cash1.XNOMCAFROM) AND (TABLE<=Cash1.XNOMCATO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMCAFROM;
	  MAXACC:=Cash1.XNOMCATO;
	END;
      IF (TABLE>=Cash1.XNOMFAFROM) AND (TABLE<=Cash1.XNOMFATO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMFAFROM;
	  MAXACC:=Cash1.XNOMFATO;
	END;
      IF (TABLE>=Cash1.XNOMLIFROM) AND (TABLE<=Cash1.XNOMLITO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMLIFROM;
	  MAXACC:=Cash1.XNOMLITO;
	END;
      IF (TABLE>=Cash1.XBANKMIN) AND (TABLE<=Cash1.XBANKMAX) THEN
	BEGIN
	  MINACC:=Cash1.XBANKMIN;
	  MAXACC:=Cash1.XBANKMAX;
	END;
      {
      IF (TABLE>=XNOMPRVINC) AND (TABLE<=XNOMPRVEXP+xno_of_partners) THEN
	BEGIN
	  MINACC:=XNOMPRVINC;
	  MAXACC:=XNOMPRVEXP+xno_of_partners;
	END;
      IF (TABLE>=XNOMTAX) AND (TABLE<=XNOMOPEN+xno_of_partners) THEN
	BEGIN
	  MINACC:=XNOMTAX;
	  MAXACC:=XNOMOPEN+xno_of_partners;
	END;
      }
      IF (TABLE>=Cash1.XNOMPRVINC) AND (TABLE<=Cash1.XNOMPRVinc+Cash11.xno_of_partners) THEN
	BEGIN
	  MINACC:=Cash1.XNOMPRVINC;
	  MAXACC:=Cash1.XNOMPRVinc+Cash11.xno_of_partners;
	END;
      IF (TABLE>=Cash1.xnomprvexp) AND (TABLE<=Cash1.xnomprvexp+Cash11.xno_of_partners) THEN
	BEGIN
	  MINACC:=Cash1.xnomprvexp;
	  MAXACC:=Cash1.xnomprvexp+Cash11.xno_of_partners;
	END;
      IF (TABLE>=Cash1.XNOMTAX) AND (TABLE<=Cash1.XNOMCREDIT) THEN
	BEGIN
	  MINACC:=Cash1.XNOMTAX;
	  MAXACC:=Cash1.XNOMCREDIT;
	END;
      IF (TABLE>=Cash1.xnomprofit) AND (TABLE<=Cash1.xnomprofit+Cash11.xno_of_partners) Then
	BEGIN
	  MINACC:=Cash1.xnomprofit;
	  MAXACC:=Cash1.xnomprofit+Cash11.xno_of_partners;
	END;
      IF (TABLE>=Cash1.xnomopen) AND (TABLE<=Cash1.xnomopen+Cash11.xno_of_partners) Then
	BEGIN
	  MINACC:=Cash1.xnomopen;
	  MAXACC:=Cash1.xnomopen+Cash11.xno_of_partners;
	END;
    End;					       { end SETRANGE }

  Procedure Accum_balance;
  Var
     X : Integer;
  Begin

    IF (( recno >= Cash1.XNOMINCFROM ) And
	( recno <= Cash1.XNOMINCTO )) THEN TOT:=1;
    IF (( recno >= Cash1.XNOMNONFROM ) And
	( recno <= Cash1.XNOMNONTO )) THEN TOT:=2;
    IF (( recno >= Cash1.XNOMEXPFROM ) And
	( recno <= Cash1.XNOMEXPTO )) THEN TOT:=3;
    IF (( recno >= Cash1.XNOMOHFROM ) And
	( recno <= Cash1.XNOMOHTO ))	 THEN TOT:=4;
    IF (( recno >= Cash1.XNOMCAFROM ) And
	( recno <= Cash1.XNOMCATO ))	 THEN TOT:=5;
    IF (( recno >= Cash1.XNOMFAFROM ) And
	( recno <= Cash1.XNOMFATO ))	 THEN TOT:=6;
    IF (( recno >= Cash1.XNOMLIFROM ) And
	( recno <= Cash1.XNOMLITO ))	 THEN TOT:=7;
    IF (( recno >= Cash1.XBANKMIN ) And
	( recno <= Cash1.XBANKMAX ))	   THEN TOT:=8;
    IF (( recno >= Cash1.XNOMPRVINC ) And
	( recno <= Cash1.XNOMPRVEXP+Cash11.xno_of_partners )) THEN TOT:=9;
    IF (( recno >= Cash1.XNOMTAX ) And
	( recno <= Cash1.XNOMOPEN+Cash11.xno_of_partners ))	 THEN TOT:=10;

    If (REPTYPE='M') Then
      If MONTH=Cash1.XMONTHNO Then
	BEGIN
	  GETITEM (NlFile,3);
	  total_opening := total_opening + CURRLONG;
	END
      ELSE
	BEGIN
	  X := Cash1.XFINMONTH;
	  WHILE X <> MONTH DO
	    BEGIN
	      GETITEM (NlFile,48+X);
	      total_closing := total_closing + CURRLONG;
	      X := X + 1;
	      IF X > 12 THEN X := X - 12;
	      If x = month Then
		 total_opening := total_opening + currlong;
	    END;
	END
    ELSE
      BEGIN
	GETITEM ( NlFile, 4 );
	total_opening := total_opening + CURRLONG;
      END;

    IF (REPTYPE='M') AND (MONTH<>Cash1.XMONTHNO) THEN
      BEGIN
	GETITEM (NlFile,48+MONTH);
	Total_closing := Total_closing + CURRLONG;
	Total_year_mth := Total_year_mth + currlong;
      END
    ELSE
      BEGIN
	GETITEM (NlFile,2);
	total_closing := Total_closing + currlong;
	Total_year_mth := Total_closing - Total_opening;
      END;
  End;

  Procedure Store_bal;
  Begin	  
    IF (( last_nom >= Cash1.XNOMINCFROM ) And
	( last_nom <= Cash1.XNOMINCTO )) THEN TOT:=1;
    IF (( last_nom >= Cash1.XNOMNONFROM ) And
	( last_nom <= Cash1.XNOMNONTO )) THEN TOT:=2;
    IF (( last_nom >= Cash1.XNOMEXPFROM ) And
	( last_nom <= Cash1.XNOMEXPTO )) THEN TOT:=3;
    IF (( last_nom >= Cash1.XNOMOHFROM ) And
	( last_nom <= Cash1.XNOMOHTO ))   THEN TOT:=4;
    IF (( last_nom >= Cash1.XNOMCAFROM ) And
	( last_nom <= Cash1.XNOMCATO ))   THEN TOT:=5;
    IF (( last_nom >= Cash1.XNOMFAFROM ) And
	( last_nom <= Cash1.XNOMFATO ))   THEN TOT:=6;
    IF (( last_nom >= Cash1.XNOMLIFROM ) And
	( last_nom <= Cash1.XNOMLITO ))   THEN TOT:=7;
    IF (( last_nom >= Cash1.XBANKMIN ) And
	( last_nom <= Cash1.XBANKMAX ))     THEN TOT:=8;
    IF (( last_nom >= Cash1.XNOMPRVINC ) And
	( last_nom <= Cash1.XNOMPRVEXP+Cash11.xno_of_partners )) THEN TOT:=9;
    IF (( last_nom >= Cash1.XNOMTAX ) And
	( last_nom <= Cash1.XNOMOPEN+Cash11.xno_of_partners ))   THEN TOT:=10;

    IF total_opening > 0 THEN BALTOT[TOT][1]:=BALTOT[TOT][1]+total_opening;
    IF total_opening < 0 THEN BALTOT[TOT][2]:=BALTOT[TOT][2]-total_opening;

    If Total_year_mth > 0 THEN BALTOT[TOT][3]:=BALTOT[TOT][3]+Total_year_mth;
    If Total_year_mth < 0 THEN BALTOT[TOT][4]:=BALTOT[TOT][4]-Total_year_mth;

    If Total_closing > 0 THEN BALTOT[TOT][5]:=BALTOT[TOT][5]+Total_closing;
    If Total_closing < 0 THEN BALTOT[TOT][6]:=BALTOT[TOT][6]-Total_closing;

  End;

  Procedure Print_line;
  Var
     ST : ShortString;
  Begin

    IF ( EXTENDED ) THEN
      BEGIN
        DoubleToStr (Total_Opening,ST,'%f', True, True, 12, False);
	     {LONGSTR (total_opening,ST,'L');
	     ST[12]:=SPACE1;}
	     BUILDLINE (53,'-');
	     BUILDLINE (65,'-');
	     IF total_opening > 0 THEN BUILDLINE (44,ST);     // ab changed from 45 to get rpt to line up properly
	     IF total_opening < 0 THEN BUILDLINE (56,ST);     // ab changed from 57 to get rpt to line up properly
      END;

    IF ( EXTENDED ) THEN
      BEGIN
        DoubleToStr (Total_Year_Mth,ST,'%f', True, True, 12, False);
	{
        LONGSTR (Total_year_mth,ST,'L');
	     ST[12]:=SPACE1;}
	     BUILDLINE (83,'-');
	     BUILDLINE (95,'-');
	     IF Total_year_mth > 0 THEN BUILDLINE (74,ST);     // ab changed from 75 to get rpt to line up properly
	     IF Total_year_mth < 0 THEN BUILDLINE (86,ST);     // ab changed from 87 to get rpt to line up properly
      END;

    DoubleToStr (Total_Closing,ST,'%f', True, True, 12, False);
    {
    LONGSTR (Total_closing,ST,'L');
    ST[12]:=SPACE1;}
    IF ( EXTENDED ) THEN
      BEGIN
	        BUILDLINE (113,'-');
	        BUILDLINE (125,'-');
	        IF Total_closing > 0 THEN BUILDLINE (104,ST);     // ab changed from 105 to get rpt to line up properly
	        IF Total_closing < 0 THEN BUILDLINE (116,ST);     // ab changed from 117 to get rpt to line up properly
      END
    ELSE
      BEGIN
	        BUILDLINE (53,'-');
	        BUILDLINE (65,'-');
	        IF Total_closing > 0 THEN BUILDLINE (44,ST);  // ab changed from 45 to get rpt to line up properly
	        IF Total_closing < 0 THEN BUILDLINE (56,ST);   // ab changed from 57 to get rpt to line up
      END;
  End;

  Begin						       { begin PROCESSTABS }

    SETDB (NlFile);
    {
    IF (( Device[1] IN ['F','P','S'] ) and ( first_disp )) THEN
      BEGIN
	CLEARFROM(24);
	DIS (1,24,'PROCESSING REPORT GROUP ... ')
      END;
    }
    IF SCHRECT>DB1.DBRECHIGH THEN SCHRECT:=DB1.DBRECHIGH;
    last_nom := 0;
    TABLE := SCHRECF;

    f_pass := true;

    Repeat
      okprintit	     := false;
      total_opening  := 0;
      total_year_mth := 0;
      total_closing  := 0;

      { Test the Full nominal ledger for 0 in group field and total into
	Group 0 }
      If f_pass Then
	 Begin

	    For recno := schrecf To schrect Do
	      Begin
		If NOT ExcludeNominal ( recno ) Then
		  Begin
		     readrec (NlFile,RECNO);
		     If errorno > 0 THEN DbErr;

		     If recactive ( NlFile ) Then
			Begin
			   OKTOPRINT:=TRUE;

			   { * if excluding enterprises do not print if enterprise field
			      has a code in it }
			   getitem ( NlFile, 24 );
			   if (( Cash11.xuse_enterprise ) and ( currstr <> null )) then
			      oktoprint := false;

			   If oktoprint then
			      Begin
				 getitem ( NlFile, 5 );
				 If currint = 0 Then
				    Begin
				       okprintit := true;
				       accum_balance;
				       last_nom := recno;
				       Totalrecs;
				    End;
			      End;
			End;
		  End;
	      End;
	    If okprintit then
	       Begin
		  BLANKLINE;
		  STR ( 0, ST );
		  WHILE LENGTH(ST)<4 DO ST:=CONCAT(SPACE1,ST);
		  BUILDLINE (1,ST);
		  BUILDLINE (7,'NO GROUP SPECIFIED' );
		  store_bal;
		  print_line;
		  OUTPUTLINE;
	       End;
	    f_pass := false;
	    okprintit	   := false;
	    total_opening := 0;
	    total_year_mth := 0;
	    total_closing  := 0;
	 End;

      If NOT ExcludeNominal ( table ) Then
	Begin
	  readtables ( NlFile, table, tabdesc );
	  If TABDESC<>COPY(SPACE40,1,32) Then
	    BEGIN
	      SETRANGE;
	      BLANKLINE;
	      STR (TABLE,ST);
	      WHILE LENGTH(ST)<4 DO ST:=CONCAT(SPACE1,ST);
	      BUILDLINE (1,ST);
	      BUILDLINE (7,TABDESC);
	      RECNO :=MINACC;

	      Repeat

		{
                If (( Device[1] IN ['F','P','S'] ) and ( first_disp )) Then
		  DISI (29,24,TABLE,1);
		}
                If NOT ExcludeNominal ( recno ) Then
		  Begin
		    READREC (NlFile,RECNO);
		    IF ERRORNO>0 THEN DbErr;
		    IF RECACTIVE(NlFile) THEN
		      BEGIN
			OKTOPRINT:=TRUE;

			{ * if excluding enterprises do not print if enterprise field
			    has a code in it }
			getitem ( NlFile, 24 );
			if (( Cash11.xuse_enterprise ) and ( currstr <> null )) then
			  oktoprint := false;

			If oktoprint then
			  Begin
			    GETITEM(NlFile,5);
			    IF CURRINT=TABLE THEN
			      BEGIN
				okprintit := true;
				accum_balance;
				last_nom := recno;
				Totalrecs;
			    END;
			  End;
		      END;
		  End;
		RECNO:=RECNO+1;
	      UNTIL RECNO>MAXACC;

	      If okprintit then
		Begin
		  store_bal;
		  print_line;
		  OUTPUTLINE;
		End;

	      IF ESCKEY THEN EXIT;
	    END;
      End;

      IF LINECOUNT+4>RFarmGate.PLINESPAGE[1] THEN REPHEADINGS;
      BLANKLINE;

      TABLE:=TABLE+1;
    UNTIL TABLE>SCHRECT;

    { Change act to 6 to print out the summary }
    act := 6;

  END;						       { end PROCESSTABS }


  {
			       Kingswood Accounts
			       ------------------

   File	    : CATEXT:CBA.NSREP4.TEXT
   Created  : 11/04/96
   Modified :

   This Segment contains the code to print the Nominal Ledger Audit Trail
   by Group codes.  All Nominals in Group 0 are included in group
   0 "No Group Specified"
}

  Procedure Rep_Nominal_by_Groups;
  Var
    okprintit,			 { Set to true if nominals exist for Group }
    f_pass     : Boolean;	 { Set true on initial run to gather 0 Group }
    table,			 { Table Group counter }
    recno,			 { Record Number }
    minacc,			 { Store first nominal in range }
				 { e.g. enterprise income accounts }
    maxacc    : Integer;	 { Store last nominal in range }
    tabdesc   : ShortString{[32]};	 { Store group table description }
    st	      : ShortString;		 { General use String }
    nom_array  : packed array [1..999] Of Integer;
    CURRBAL    : LONG;
    STYEAR     : LONG;
    STPERIOD   : LONG;
    MOVEYEAR   : LONG;
    MOVEPERIOD : LONG;
    BUDYEAR    : LONG;
    BUDYVAR    : LONG;
    MOVELAST   : LONG;
    txquan     : long;
    first_group : Boolean;
    no_of_prints : Integer;	 { safeguard against okprintit }

    Procedure exit_rep;
    Begin
       {
       For X := 1 To 6 Do
	 cclose ( x, 'N' );
       }
       exit;
    End;

    Procedure setrange;
    Begin					     { begin SETRANGE }
      IF (TABLE>=Cash1.XNOMINCFROM) AND (TABLE<=Cash1.XNOMINCTO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMINCFROM;
	  MAXACC:=Cash1.XNOMINCTO;
	END;
      IF (TABLE>=Cash1.XNOMNONFROM) AND (TABLE<=Cash1.XNOMNONTO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMNONFROM;
	  MAXACC:=Cash1.XNOMNONTO;
	END;
      IF (TABLE>=Cash1.XNOMEXPFROM) AND (TABLE<=Cash1.XNOMEXPTO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMEXPFROM;
	  MAXACC:=Cash1.XNOMEXPTO;
	END;
      IF (TABLE>=Cash1.XNOMOHFROM) AND (TABLE<=Cash1.XNOMOHTO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMOHFROM;
	  MAXACC:=Cash1.XNOMOHTO;
	END;
      IF (TABLE>=Cash1.XNOMCAFROM) AND (TABLE<=Cash1.XNOMCATO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMCAFROM;
	  MAXACC:=Cash1.XNOMCATO;
	END;
      IF (TABLE>=Cash1.XNOMFAFROM) AND (TABLE<=Cash1.XNOMFATO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMFAFROM;
	  MAXACC:=Cash1.XNOMFATO;
	END;
      IF (TABLE>=Cash1.XNOMLIFROM) AND (TABLE<=Cash1.XNOMLITO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMLIFROM;
	  MAXACC:=Cash1.XNOMLITO;
	END;
      IF (TABLE>=Cash1.XBANKMIN) AND (TABLE<=Cash1.XBANKMAX) THEN
	BEGIN
	  MINACC:=Cash1.XBANKMIN;
	  MAXACC:=Cash1.XBANKMAX;
	END;
      IF (TABLE>=Cash1.XNOMPRVINC) AND (TABLE<=Cash1.XNOMPRVinc+Cash11.xno_of_partners) THEN
	BEGIN
	  MINACC:=Cash1.XNOMPRVINC;
	  MAXACC:=Cash1.XNOMPRVinc+Cash11.xno_of_partners;
	END;
      IF (TABLE>=Cash1.xnomprvexp) AND (TABLE<=Cash1.xnomprvexp+Cash11.xno_of_partners) THEN
	BEGIN
	  MINACC:=Cash1.xnomprvexp;
	  MAXACC:=Cash1.xnomprvexp+Cash11.xno_of_partners;
	END;
      IF (TABLE>=Cash1.XNOMTAX) AND (TABLE<=Cash1.XNOMCREDIT) THEN
	BEGIN
	  MINACC:=Cash1.XNOMTAX;
	  MAXACC:=Cash1.XNOMCREDIT;
	END;
      IF (TABLE>=Cash1.xnomprofit) AND (TABLE<=Cash1.xnomprofit+Cash11.xno_of_partners) Then
	BEGIN
	  MINACC:=Cash1.xnomprofit;
	  MAXACC:=Cash1.xnomprofit+Cash11.xno_of_partners;
	END;
      IF (TABLE>=Cash1.xnomopen) AND (TABLE<=Cash1.xnomopen+Cash11.xno_of_partners) Then
	BEGIN
	  MINACC:=Cash1.xnomopen;
	  MAXACC:=Cash1.xnomopen+Cash11.xno_of_partners;
	END;
    End;					       { end SETRANGE }

  Procedure init_array;
  Var
     X : Integer;
  Begin
    { Initialise nominal pointer array }
    For X := 1 To 999 Do
      nom_array[x] := 0;
    CURRBAL    := 0;
    STYEAR     := 0;
    STPERIOD   := 0;
    MOVEYEAR   := 0;
    MOVEPERIOD := 0;
    BUDYEAR    := 0;
    BUDYVAR    := 0;
    MOVELAST   := 0;
    no_of_prints := 0;
  End;

  Procedure Print_bal;
  Begin				    {** Begin print_bal }
    curr_group := table;		 { set global to allow heading build }
    if curr_group = 0 then
       tabdesc := 'NO GROUP SPECIFIED';
    if linecount+8 > RFarmGate.plinespage[1] then repheadings;
    blankline;
    buildline ( 45, 'GROUP ' );
    str ( table, st );
    buildline ( 51, Concat ( st, ' : ' ));
    buildline ( 56, tabdesc );
    outputline;
    blankline;
    buildline ( 1, 'CURRENT BALANCE' );
    DoubleToStr (CURRBAL,st,'%f', True, True, 11, False);
//    longstr ( currbal, st, 'L' );
    st[12] := space1;
    buildline ( 25, '-' );
    buildline ( 38, '-' );
    If currbal > 0 Then buildline ( 17, st );
    If currbal < 0 Then buildline ( 30, st );
    outputline;

    If nomys Then
      Begin
	 blankline;
	 buildline ( 1, 'YEAR OPENING' );
         DoubleToStr (STYEAR,st,'%f', True, True, 11, False);
//	 longstr ( styear, st, 'L' );
	 st[12] := space1;
	 buildline ( 25, '-' );
	 buildline ( 38, '-' );
	 If styear > 0 Then buildline ( 17, st );
	 If styear < 0 Then buildline ( 30, st );
	 outputline;
      End;

    If nomym Then
      Begin
	 blankline;
	 buildline ( 1, 'YEAR MOVEMENT' );
         DoubleToStr (MOVEYEAR,st,'%f', True, True, 11, False);
//	 longstr ( moveyear, st, 'L' );
	 st[12] := space1;
	 buildline ( 25, '-' );
	 buildline ( 38, '-' );
	 If moveyear > 0 Then buildline ( 17, st );
	 If moveyear < 0 Then buildline ( 30, st );
	 outputline;
      End;

    If nomps Then
      Begin
	 blankline;
	 buildline ( 1, 'PERIOD OPENING' );
         DoubleToStr (STPERIOD,st,'%f', True, True, 11, False);
//	 longstr ( stperiod, st, 'L' );
	 st[12] := space1;
	 buildline ( 25, '-' );
	 buildline ( 38, '-' );
	 If stperiod > 0 Then buildline ( 17, st );
	 If stperiod < 0 Then buildline ( 30, st );
	 outputline;
      End;

    If nompm Then
      Begin
	 blankline;
	 buildline ( 1, 'PERIOD MOVEMENT' );
         DoubleToStr (MOVEPERIOD,st,'%f', True, True, 11, False);
//	 longstr ( moveperiod, st, 'L' );
	 st[12] := space1;
	 buildline ( 25, '-' );
	 buildline ( 38, '-' );
	 If moveperiod > 0 Then buildline ( 17, st );
	 If moveperiod < 0 Then buildline ( 30, st );
	 outputline;
      End;

    If nomyb Then
      Begin
	 blankline;
	 buildline ( 1, 'YEAR BUDGET' );
         DoubleToStr (BUDYEAR,st,'%f', True, True, 11, False);
//	 longstr ( budyear, st, 'L' );
	 st[12] := space1;
	 buildline ( 25, '-' );
	 buildline ( 38, '-' );
	 If budyear > 0 Then buildline ( 17, st );
	 If budyear < 0 Then buildline ( 30, st );
	 outputline;
      End;

    If nomlym Then
      Begin
	 blankline;
	 buildline ( 1, 'LAST YEAR MOVEMENT' );
         DoubleToStr (MOVELAST,st,'%f', True, True, 11, False);
//	 longstr ( movelast, st, 'L' );
	 st[12] := space1;
	 buildline ( 25, '-' );
	 buildline ( 38, '-' );
	 If movelast > 0 Then buildline ( 17, st );
	 If movelast < 0 Then buildline ( 30, st );
	 outputline;
      End;

    If nomybv Then
      Begin
	 blankline;
	 buildline ( 1, 'YEAR BUDGET DIFF' );
         DoubleToStr (BUDYVAR,st,'%f', True, True, 11, False);
//	 longstr ( budyvar, st, 'L' );
	 st[12] := space1;
	 buildline ( 25, '-' );
	 buildline ( 38, '-' );
	 If budyvar > 0 Then buildline ( 17, st );
	 If budyvar < 0 Then buildline ( 30, st );
	 outputline;
      End;
    blankline;
    outputline;
  End;				    {** End print_bal }

  Procedure printtot;
  Begin
     If linecount + 3 > RFarmGate.plinespage[1] Then
	repheadings;

     BLANKLINE;
     BUILDLINE(17,'------------------------');
     BUILDLINE(84,'------------');
     OUTPUTLINE;
     BLANKLINE;
     BUILDLINE(25,'-');
     BUILDLINE(38,'-');
     IF TXDEBIT<>0 THEN
       BEGIN
         DoubleToStr (TXDEBIT,st,'%f', True, True, 11, False);
//	 LONGSTR(TXDEBIT,ST,'L');
	 BUILDLINE(17,ST);
       END;
     IF TXCREDIT<>0 THEN
       BEGIN
         DoubleToStr (TXCREDIT,st,'%f', True, True, 11, False);
//	 LONGSTR(TXCREDIT,ST,'L');
	 BUILDLINE(30,ST);
       END;
     DBTOT:=DBTOT+TXDEBIT;
     CRTOT:=CRTOT+TXCREDIT;
     IF ( TXQUAN <> 0 ) THEN
       BEGIN
         DoubleToStr (TXQUAN,st,'%f', True, True, 11, False);
//	 LONGSTR(TXQUAN,ST,'L');
	 BUILDLINE(84,ST);
       END;
     OUTPUTLINE;
  End;

  Function scan_array ( next_tx : SmallInt; var nomacc : SmallInt ) : SmallInt;
  Var
    last_tx,
    local_nom,
{-->>    s_a,}
    arr_loop : Integer;

  Begin
{-->>    scan_array := next_tx;}
{-->>    s_a := next_tx;}
    local_nom := nomacc;
    last_tx := next_tx;

    For arr_loop := Minacc To Maxacc Do
      Begin
	If (( nom_array[arr_loop] > 0 ) And ( arr_loop <> local_nom )) Then
	   If next_tx > nom_array[arr_loop] Then
	      Begin
		 next_tx := nom_array[arr_loop];
		 nomacc := arr_loop;
		 If last_tx > nom_array[arr_loop] Then
		    Begin
		       last_tx := nom_array[arr_loop];
		       nomacc := arr_loop;
		     End;
	      End
	   Else
	      If next_tx = 0 then
		 Begin
		    last_tx := nom_array[arr_loop];
		    nomacc  := arr_loop;
		 End;
      End;
    scan_array := last_tx;
  End;

  Procedure get_first ( var Nominal, first_tx : SmallInt );
  Var
    last_tx,
    arr_loop : Integer;
  Begin
    last_tx  := -1;
    first_tx := 0;
    nominal  := 0;

    For arr_loop := Minacc To Maxacc Do
      Begin
	If nom_array[arr_loop] > 0 Then
	   If last_tx = -1 Then
	      Begin
		 first_tx := nom_array[arr_loop];
		 last_tx  := first_tx;
		 nominal := arr_loop;
	      End
	   Else
	      If first_tx > nom_array[arr_loop] Then
		 Begin
		    first_tx := nom_array[arr_loop];
		    nominal := arr_loop;
		 End;
      End;
  End;

  Procedure process_nom;
  Var
      stub1,
      stub2,
      txt,
      thisdate,
      dbac,
      crac,
      tx,
      nom : SmallInt;
      t_date : ShortString{[8]};
      runbal : long;
      editst : ShortString{[1]};

      Procedure Process_tx ( var nominal : SmallInt );
      Var
	 ok : Boolean;

	 Procedure print_trans;
	 Begin						 { begin PRINTTRAN }
	    blankline;
	    {* get transaction number ready to print }
	    STR(CURRREC[2],ST);
	    buildline ( 1, st );

	    {* insert dashes for amount }
	    BUILDLINE(25,'-');
	    BUILDLINE(38,'-');

	    {* get nominal amount from transaction }
	    GETITEM(TxFile,17);
            DoubleToStr (CURRLONG,st,'%f', True, True, 11, False);
 {	    LONGSTR(CURRLONG,ST,'L');}
	    {* if current nominal account = nominal debit account on transaction }
	    IF DBAC=nominal {CURRREC[1]} THEN
	      BEGIN
		TXDEBIT:=TXDEBIT+CURRLONG;
		RUNBAL :=RUNBAL +CURRLONG;
		BUILDLINE(18,COPY(ST,2,11));
	      END;

	    {* if current nominal account = nominal credit account on transaction }
	    IF CRAC=nominal{CURRREC[1]} THEN
	      BEGIN
		TXCREDIT:=TXCREDIT+CURRLONG;
		RUNBAL	:=RUNBAL  -CURRLONG;
		BUILDLINE(31,COPY(ST,2,11));
	      END;

	    {* get the transacion date }
	    GETITEM(TxFile,2);
	    buildline ( 42, currstr );

	    {* if running Full Nominal Audit Trail ( act - 7 )}
	    buildline ( 9, stubno );
	    getitem ( TxFile, 4 );
	    buildline ( 51, CURRSTR );

	    BUILDLINE(68,'-');
	    BUILDLINE(81,'-');
            DoubleToStr (RUNBAL,st,'%f', True, True, 11, False);
//	    LONGSTR(RUNBAL,ST,'L');
	    ST[12]:=SPACE1;
	    IF RUNBAL>0 THEN BUILDLINE(60,ST);
	    IF RUNBAL<0 THEN BUILDLINE(73,ST);
	    GETITEM(TxFile,6);
	    TXQUAN:=TXQUAN+CURRLONG;
            DoubleToStr (CURRLONG,currstr,'%f', True, True, 11, false);
//	    LONGSTR(CURRLONG,CURRSTR,'L');
	    BUILDLINE(84,CURRSTR);

	    get_cust_supp;
	    {* remove characters over 20 as not enough room on report }
	    if length ( cust_supp ) > 20 Then
	      delete ( cust_supp, 20, length ( cust_supp )-19);
	    buildline ( 96, cust_supp );

	    getitem ( TxFile, 5 );
	    buildline ( 117, currstr );
	    OUTPUTLINE;
	  END;						  { end PRINTTRAN }

      Begin { Process_tx }
	 setdb ( TxFile );

	 While tx > 0 DO
	    Begin
	       readrec ( TxFile, tx );
	       if errorno > 0 then DbErr;
	       OK := RECACTIVE(TxFile);

	       IF OK THEN
		  BEGIN
		  GETITEM (TxFile,18);
		  DBAC	  :=CURRINT;
		  GETITEM (TxFile,19);
		  CRAC	  :=CURRINT;
		  GETITEM (TxFile,23);
		  TXT	  :=CURRINT;
		  GETITEM (TxFile,2);
		  THISDATE:=CURRINT;
		  t_date := currstr;

		  GETITEM (TxFile,2);
		  If CURRINT > TODT THEN OK:=FALSE;
		    If CURRINT < FROMDT THEN
		       OK:=FALSE;

		  IF (CURRREC[TxFile]<SCHTXF) OR (CURRREC[Txfile]>SCHTXT) THEN OK:=FALSE;
		  GETITEM (TxFile,28);
		  EDITST   :=SPACE1;
		  EDITST[1]:=CURRDISP[1];
		  IF ( EDITST[1] IN ['R','E'] ) THEN OK:=FALSE;

		  getitem ( TxFile, 26 );
		  stubno := currstr;
		  IF NUMERIC(CURRSTR) THEN
		    BEGIN
		      WHILE LENGTH(CURRSTR)<8 DO CURRSTR:=CONCAT('0',CURRSTR);
		      INTVAL (STUB1,COPY(CURRSTR,1,4));
		      INTVAL (STUB2,COPY(CURRSTR,5,4));
		    END;
		END;

	      IF  ( OK ) Then
		BEGIN
		  If linecount + 8 > RFarmGate.plinespage[1] Then
		     repheadings;
		  print_trans;
		End;

	      If recactive ( TxFile ) Then
		BEGIN
		  IF nominal = DBAC THEN GETITEM(TxFile,13);
		  IF nominal = CRAC THEN GETITEM(TxFile,14);
		  tx := currint;
		END;

	      { set nominal array tx position to last tx read }
	      nom_array[nominal] := tx;
	      tx := scan_array ( tx, nominal );
	    End;
      End;  { Process_tx }

  Begin	    { Process_nom }
     txdebit := 0;
     txcredit := 0;
     txquan := 0;
     runbal := 0;
     editst := space1;
     tx	    := 0;

     get_first ( nom, tx );

     While nom <> 0 Do { := minacc To Maxacc Do }
	Begin
	   setdb ( NlFile );
	   If nom > 0 Then
	       Begin
		  readrec ( Nlfile, nom );
		  If recactive ( NlFile ) Then
		     Begin
			process_tx ( nom );
			nom := 0;
		     End;
	       End;
	End;
     printtot;
     RepDash;

  End;	    { Process_nom }

  Procedure set_balances;

    Begin						{ Begin set_balances }
      GETITEM(NlFile,2);
      CURRBAL:=CURRLONG+currbal;
      GETITEM(NlFile,3);
      STPERIOD:=CURRLONG+stperiod;
      GETITEM(NlFile,4);
      STYEAR:=CURRLONG+styear;

      MOVEYEAR	:=CURRBAL-STYEAR;
      MOVEPERIOD:=CURRBAL-STPERIOD;
      GETITEM(NlFile,7);
      BUDYEAR:=CURRLONG+budyear;
      BUDYVAR:=BUDYEAR - (CURRBAL-STYEAR);
      GETITEM (NlFile,17);
      MOVELAST:=CURRLONG+movelast;
      IF NOMYS THEN
	BEGIN
	  CURRLONG:=STYEAR;
	  { BUILDLINE(1,'YEAR OPENING'); }
	END;
    End;					    { end setbalances }

  Begin						       { begin PROCESSTABS }
    first_group := true;
    init_array;

    {
    opendb ( 4, xslaccfile );
    opendb ( 5, xplaccfile );
    }

    SETDB (NlFile);
    {
    IF (( Device[1] IN ['F','P','S'] ) and ( first_disp )) THEN
      BEGIN
	CLEARFROM(24);
	DIS (1,24,'PROCESSING REPORT GROUP ... ')
      END;
    }
    IF SCHRECT>DB1.DBRECHIGH THEN SCHRECT:=DB1.DBRECHIGH;
    TABLE := SCHRECF;

    f_pass := true;

    Repeat
      okprintit	     := false;

      { Test the Full nominal ledger for 0 in group field and total into
	Group 0 }
      If f_pass Then
	 Begin
	    { set min & max to accounts entered by user }
	    minacc := schrecf;
	    maxacc := schrect;
	    table  := 0;
	    For recno := schrecf To schrect Do
	      Begin
		If NOT ExcludeNominal ( recno ) Then
		  Begin
		     readrec ( NlFile, recno );
		     If errorno > 0 THEN DbErr;

		     If recactive ( NlFile ) Then
			Begin
			   OKTOPRINT:=TRUE;

			   { * if excluding enterprises do not print if enterprise field
			      has a code in it }
			   getitem ( NlFile, 24 );
			   if (( Cash11.xuse_enterprise ) and ( currstr <> null )) then
			      oktoprint := false;

			   If oktoprint then
			      Begin
				 getitem ( NlFile, 5 );
				 If currint = 0 Then
				    Begin
				       { set first trans record for nominal }
				       getitem ( NlFile, 15 );
				       If (( printzero ) And ( currint = 0 )) then
				       Else
					  Begin
					     totalrecs;
					     nom_array[recno] := currint;
					     okprintit := true;
					     set_balances;
					     no_of_prints := no_of_prints + 1;
					  End;
				    End;
			      End;
			End;
		  End;
	      End;

	    If okprintit Or ( no_of_prints > 0 ) then
		Begin
		  curr_group := 0;
		  repheadings;
		  first_group := false;
		  print_bal;
		  process_nom;
		End;

	    f_pass := false;
	    okprintit := false;
	    table := SCHRECF;
	 End;

      init_array;

      If NOT ExcludeNominal ( table ) Then
	Begin
	  readtables ( NlFile, table, tabdesc );
	  If TABDESC<>COPY(SPACE40,1,32) Then
	    BEGIN
	      SETRANGE;
	      BLANKLINE;
	      STR (TABLE,ST);
	      WHILE LENGTH(ST)<4 DO ST:=CONCAT(SPACE1,ST);
	      BUILDLINE (1,ST);
	      BUILDLINE (7,TABDESC);
	      RECNO :=MINACC;

	      Repeat

		{
                If (( Device[1] IN ['F','P','S'] ) and ( first_disp )) Then
		  DISI (29,24,TABLE,1);
		}
                If NOT ExcludeNominal ( recno ) Then
		  Begin
		    READREC (NlFile,RECNO);
		    IF ERRORNO>0 THEN DbErr;
		    IF RECACTIVE(NlFile) THEN
		      BEGIN
			OKTOPRINT:=TRUE;

			{ * if excluding enterprises do not print if enterprise field
			    has a code in it }
			getitem ( NlFile, 24 );
			if (( Cash11.xuse_enterprise ) and ( currstr <> null )) then
			  oktoprint := false;

			If oktoprint then
			  Begin
			    GETITEM(NlFile,5);
			    If CURRINT=TABLE Then
			      Begin
				{ set first trans record for nominal }
				getitem ( NlFile, 15 );
				If (( printzero ) And ( currint = 0 )) then
				   { okprintit := false }
				Else
				   Begin
				      totalrecs;
				      nom_array[recno] := currint;
				      okprintit := true;
				      set_balances;
				      no_of_prints := no_of_prints + 1;
				   End;
			    End;
			  End;
		      END;
		  End;
		RECNO:=RECNO+1;
	      UNTIL RECNO > MAXACC;

	      If okprintit Or ( no_of_prints > 0 ) then
		Begin
		  If first_group Then
		     Begin
			curr_group := table;
			first_group := false;
			repheadings;
		     End;
		  print_bal;
		  process_nom;
		End;

	      IF ESCKEY THEN exit_rep;
	    END;
      End;

      IF LINECOUNT+4>RFarmGate.PLINESPAGE[1] THEN REPHEADINGS;
      BLANKLINE;

      TABLE:=TABLE+1;
    UNTIL TABLE>SCHRECT;

    {
    For X := 1 To 6 Do
      cclose ( x, 'N' );
    }

  END;						       { end PROCESSTABS }

PROCEDURE bank_balances;
  VAR
    st	 : Shortstring;
    accno : integer;

{-->>    LINE : INTEGER;}
  BEGIN
    SETDB(NlFile);
    {
    BETACLEAR;
    BETATITLE ( 'DISPLAY BANK BALANCES' );
    DIS (  1, 6, 'Nom	Account-Name' );
    DIS ( 44, 6, 'Rep-Grp');
    DIS ( 58, 6, 'Overdrawn    In-Credit');
    DIS ( 1,7,UNDLINE);
    }
{-->>    LINE:=7;}
    ACCNO:=Cash1.xbankmin;
    REPEAT
      READREC (NlFile,ACCNO);
      dberr;
      IF RECACTIVE(NlFile) THEN
	BEGIN
{-->>	  LINE:=LINE+1;}
	  {
          IF LINE>=22 THEN
	    BEGIN
              DIS ( 1,24,CONCAT('PRESS ENTER FOR MORE ',XENTUPPER,'S'));
              disp_options := true;
	      allow_exit := false;
	      F2_F3_active := false;
	      search_action := 0;

	      REC (35,24,0,NULL,0,0,0,0,0,0);
	      IF ESCKEY THEN EXIT ( bank_balances );
	      LINE:=8;
	      CLEARFROM (8);
	    END;
          }
	  str ( accno, st );
	  {
          dis ( 1, line, st );
	  }
          GETITEM (NlFile,1);
	  {
          DIS ( 6, LINE, CURRSTR );
	  }
          getitem ( NlFile, 5 );
	  str ( currint, st );
	  {
          dis ( 46, line, st );
	  }
          GETITEM ( NlFile, 2 );
          DoubleToStr (CURRLONG,st,'%f', True, True, 11, False);
//	  longstr ( currlong, st, 'L' );
	  {
          If currlong < 0 Then
	    dis ( 56, LINE, copy ( st, 1, 11 ))
	  Else
	    dis ( 69, line, st );
          }
	END;
      ACCNO:=ACCNO+1;
    UNTIL ACCNO > Cash1.xbankmax;
    {
    CONTINUE;
    }
  END;

  (*
  PROCEDURE ENDPRINT;
  CONST
    ENDREP = 'Kingswood Computing Ltd.';
  BEGIN							{ begin ENDPRINT }

    IF NOT ((PROG=SPECREP) AND (ACT=4)) THEN PRINTTOTS;
    SKIPLINES(2);

    IF ( Device[1] in ['C','F','P','S'] ) THEN
      BEGIN
	SENDLINE (ENDREP);
	IF ESCKEY THEN EXIT;
      END;

    LINECOUNT := LINECOUNT + 1;
    If Device[1] = 'P' Then
	{Page ( printfile )}
    Else
	SKIPLINES( PLINESPAGE[1] - LINECOUNT );

  END;							{ end ENDPRINT }
  *)

  (*
  PROCEDURE DbErr;
  BEGIN							{ begin DbErr }
    DISKERROR;
    EXIT(REPSEG);
  END;							{ end DbErr }
  *)


  PROCEDURE PROCESSENTS;
  VAR
    RECNO : INTEGER;
  BEGIN							{ begin PROCESSENTS }
    SETDB(DBNO);

    IF ( Device[1] IN ['F','P','S'] ) THEN
      BEGIN
	{
        CLEARFROM(24);
	}
        SETDB(DBNO);
	{
        DIS (1,24,CONCAT('PROCESSING ',XENTUPPER,' ... '));
        }
      END;
    RECNO:=1;
    REPEAT
      READREC(DBNO,RECNO);

      IF ERRORNO > 0 THEN DbErr;
      IF RECACTIVE(DBNO) THEN
	BEGIN
	  OKTOPRINT:=TRUE;
	  GETITEM(dbno,1);

	  IF SCHENT<>NULL THEN
	    IF CURRSTR<>SCHENT THEN OKTOPRINT:=FALSE;

	  {
          IF (( Device[1] IN ['F','P','S'] ) and ( first_disp )) THEN
	    DIS (27,24,CONCAT(CURRSTR,'	  '));
	  }
          IF OKTOPRINT THEN
	    BEGIN
(* change *)
	      If not SINGLE_ENT then
		begin
		  getitem ( dbno, 3 );
		  if currlong <> 0 then
		    Begin
                         no_units := currlong;
                         {No_Units := No_Units / 100;}
                    End
		  else
		    no_units := 100;
		  getitem ( dbno, 4 );
		  unit_name := currstr;
		end;

	      PRINTOUT (TRUE);
	      IF SCHENT<>NULL THEN EXIT;

              //If ((Act = 6) And ( PROG = EntRep ) And ( PageNo <> 1 )) Then
              //   REPHEADINGS;

	    END;
	  IF ESCKEY THEN EXIT;
	END;
      RECNO:=RECNO+1;
      SETDB(DBNO);
    UNTIL RECNO>DB1.DBRECHIGH;
  END;						   { end PROCESSENTS }

  PROCEDURE PROCESSTABS;
  VAR
    TABLE   : INTEGER;
    RECNO   : INTEGER;
    TOTREC  : INTEGER;
    MINACC  : INTEGER;
    MAXACC  : INTEGER;
    TABBLK  : INTEGER;
    TABSUB  : INTEGER;
    TABDESC : ShortSTRING{[32]};
    TABWORK : PACKED ARRAY [1..512] OF CHAR;
    ST	    : ShortSTRING;

    PROCEDURE TABREAD (DB,TABREC: INTEGER);
    VAR
      LSTBLK : INTEGER;
    BEGIN					    { begin TABREAD }
      LSTBLK:=TABBLK;
      TABDESC:=COPY(SPACE40,1,32);
      IF TABREC>0 THEN
	BEGIN
	  TABBLK:=((TABREC-1) DIV 16);
	  TABSUB:=TABREC-(TABBLK*16);
	  IF TABBLK<>LSTBLK THEN
	    BEGIN
	      IF CREAD (DB,1,DB1.DBTABS+TABBLK)<1 THEN;
	      MOVE (CBLOCKS[1],TABWORK[1],512);
	    END;
	  MOVE (TABWORK[1+((TABSUB-1)*32)],TABDESC[1],32);
	END;
    END;					     { end TABREAD }

    PROCEDURE SETRANGE;
    BEGIN					     { begin SETRANGE }
      IF (TABLE>=Cash1.XNOMINCFROM) AND (TABLE<=Cash1.XNOMINCTO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMINCFROM;
	  MAXACC:=Cash1.XNOMINCTO;
	END;
      IF (TABLE>=Cash1.XNOMNONFROM) AND (TABLE<=Cash1.XNOMNONTO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMNONFROM;
	  MAXACC:=Cash1.XNOMNONTO;
	END;
      IF (TABLE>=Cash1.XNOMEXPFROM) AND (TABLE<=Cash1.XNOMEXPTO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMEXPFROM;
	  MAXACC:=Cash1.XNOMEXPTO;
	END;
      IF (TABLE>=Cash1.XNOMOHFROM) AND (TABLE<=Cash1.XNOMOHTO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMOHFROM;
	  MAXACC:=Cash1.XNOMOHTO;
	END;
      IF (TABLE>=Cash1.XNOMCAFROM) AND (TABLE<=Cash1.XNOMCATO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMCAFROM;
	  MAXACC:=Cash1.XNOMCATO;
	END;
      IF (TABLE>=Cash1.XNOMFAFROM) AND (TABLE<=Cash1.XNOMFATO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMFAFROM;
	  MAXACC:=Cash1.XNOMFATO;
	END;
      IF (TABLE>=Cash1.XNOMLIFROM) AND (TABLE<=Cash1.XNOMLITO) THEN
	BEGIN
	  MINACC:=Cash1.XNOMLIFROM;
	  MAXACC:=Cash1.XNOMLITO;
	END;
      IF (TABLE>=Cash1.XBANKMIN) AND (TABLE<=Cash1.XBANKMAX) THEN
	BEGIN
	  MINACC:=Cash1.XBANKMIN;
	  MAXACC:=Cash1.XBANKMAX;
	END;
      {
      IF (TABLE>=XNOMPRVINC) AND (TABLE<=XNOMPRVEXP+xno_of_partners) THEN
	BEGIN
	  MINACC:=XNOMPRVINC;
	  MAXACC:=XNOMPRVEXP+xno_of_partners;
	END;
      IF (TABLE>=XNOMTAX) AND (TABLE<=XNOMOPEN+xno_of_partners) THEN
	BEGIN
	  MINACC:=XNOMTAX;
	  MAXACC:=XNOMOPEN+xno_of_partners;
	END;
      }
      IF (TABLE>=Cash1.XNOMPRVINC) AND (TABLE<=Cash1.XNOMPRVinc+Cash11.xno_of_partners) THEN
	BEGIN
	  MINACC:=Cash1.XNOMPRVINC;
	  MAXACC:=Cash1.XNOMPRVinc+Cash11.xno_of_partners;
	END;
      IF (TABLE>=Cash1.xnomprvexp) AND (TABLE<=Cash1.xnomprvexp+Cash11.xno_of_partners) THEN
	BEGIN
	  MINACC:=Cash1.xnomprvexp;
	  MAXACC:=Cash1.xnomprvexp+Cash11.xno_of_partners;
	END;
      IF (TABLE>=Cash1.XNOMTAX) AND (TABLE<=Cash1.XNOMCREDIT) THEN
	BEGIN
	  MINACC:=Cash1.XNOMTAX;
	  MAXACC:=Cash1.XNOMCREDIT;
	END;
      IF (TABLE>=Cash1.xnomprofit) AND (TABLE<=Cash1.xnomprofit+Cash11.xno_of_partners) Then
	BEGIN
	  MINACC:=Cash1.xnomprofit;
	  MAXACC:=Cash1.xnomprofit+Cash11.xno_of_partners;
	END;
      IF (TABLE>=Cash1.xnomopen) AND (TABLE<=Cash1.xnomopen+Cash11.xno_of_partners) Then
	BEGIN
	  MINACC:=Cash1.xnomopen;
	  MAXACC:=Cash1.xnomopen+Cash11.xno_of_partners;
	END;
    END;					       { end SETRANGE }

  BEGIN						       { begin PROCESSTABS }
//    SETDB (1);
    SETDB (NLFile);
    {
    IF (( Device[1] IN ['F','P','S'] ) and ( first_disp )) THEN
      BEGIN
	CLEARFROM(24);
	DIS (1,24,'PROCESSING REPORT GROUP ... ')
      END;
    }
    IF SCHRECT>DB1.DBRECHIGH THEN SCHRECT:=DB1.DBRECHIGH;
    TABLE := SCHRECF;
    TABBLK:=-1;
    REPEAT
      If NOT ExcludeNominal ( table ) Then
	Begin
	  TABREAD (NlFile,TABLE);
	  IF TABDESC<>COPY(SPACE40,1,32) THEN
	    BEGIN
	      SETRANGE;
	      BLANKLINE;
	      STR (TABLE,ST);
	      WHILE LENGTH(ST)<4 DO ST:=CONCAT(SPACE1,ST);
	      BUILDLINE (1,ST);
	      BUILDLINE (7,TABDESC);
	      RECNO :=MINACC;
	      TOTREC:=0;
	      REPEAT
		{
                IF (( Device[1] IN ['F','P','S'] ) and ( first_disp )) THEN
		  DISI (29,24,TABLE,1);
		}
                If NOT ExcludeNominal ( recno ) Then
		  Begin
		    READREC (NlFile,RECNO);
		    IF ERRORNO>0 THEN DbErr;
		    IF RECACTIVE(NlFile) THEN
		      BEGIN
			OKTOPRINT:=TRUE;

			{ * if excluding enterprises do not print if enterprise field
			    has a code in it }
			getitem ( NlFile, 24 );
			if (( Cash11.xuse_enterprise ) and ( currstr <> null )) then
			  oktoprint := false;

			if oktoprint then
			  Begin
			    GETITEM(Nlfile,5);
			    IF CURRINT=TABLE THEN
			      BEGIN
				STR (RECNO,ST);
				WHILE LENGTH(ST)<4 DO ST:=CONCAT(SPACE1,ST);
				GETITEM (NlFile,1);
				BUILDLINE (41,ST);
				BUILDLINE (47,CURRSTR);
				OUTPUTLINE;
				IF ESCKEY THEN EXIT;
				IF LINECOUNT+4>RFarmGate.PLINESPAGE[1] THEN REPHEADINGS;
				BLANKLINE;
				TOTREC:=TOTREC+1;
			      END;
			  End;
		      END;
		  End;
		RECNO:=RECNO+1;
	      UNTIL RECNO>MAXACC;

	      if oktoprint then
		OUTPUTLINE;
	      IF ESCKEY THEN EXIT;

	      IF (( TOTREC=0 ) and ( oktoprint )) THEN
		BEGIN
		  BLANKLINE;
		  OUTPUTLINE;
		  IF ESCKEY THEN EXIT;
		END;
	    END;
      End;
      TABLE:=TABLE+1;
    UNTIL TABLE>SCHRECT;
  END;						       { end PROCESSTABS }

  PROCEDURE PROCESSSORT;
  VAR
    RECNO, lastrec, currec    : Integer;
    SORTPOS  : INTEGER;
    SORTBLK  : INTEGER;
    SORTWORK : PACKED ARRAY[1..512] OF CHAR;
    TXT	     : INTEGER;
    SUB	     : INTEGER;
    AMT	     : LONG;
    check_9_types : Boolean;


    PROCEDURE NEXTCUST;
    BEGIN						{ begin NEXTCUST }
      IF SORTPOS + 2 > 513 THEN
	BEGIN
	  SORTBLK := SORTBLK + 1;
	  SORTPOS := 1;
	  IF CREAD (SortFileNo,1,SORTBLK)<1 THEN AbortProgram (SEQERR);
	  MOVE(CBLOCKS[1],SORTWORK[1],512);
	END;
      MOVE (SORTWORK[SORTPOS],RECNO,2);
      SORTPOS:=SORTPOS+2;
      IF RECNO > 30000 THEN RECNO := 0;
    END;						 { end NEXTCUST }

    PROCEDURE SUBTOTAL;
    VAR
      get_code : ShortString{[10]};
      counter  : integer;
      v_desc,
      ST : ShortString;

    BEGIN						 { begin SUBTOTAL }
      get_code := null;
      v_desc   := null;
      for counter := 0 to 9 do
	get_code := concat ( get_code, Cash1.xtaxids[counter] );

      BLANKLINE;
      OUTPUTLINE;
      STR (SUBREC,CURRSTR);
      ST   :=SPACE1;
      ST[1]:=LASTCODE;

      counter := pos ( st, get_code );
      if counter > 0 then
	v_desc := Cash11.vat_Desc[counter-1];

      ST   :=CONCAT('TOTAL FOR ',Cash1.XTAXCODE,' CODE ',ST,
		     ' (',CURRSTR,' RECORDS) ..... ', v_desc );
      BUILDLINE ( 1,ST);
      DoubleToStr (SubAmt,CurrStr,'%f', True, True, 12, False);
      {LONGSTR (SUBAMT,CURRSTR,'L');}
      buildline ( 60, CURRSTR );
      {LONGSTR (SUBTAX,CURRSTR,'L');}
      DoubleToStr (SubTax,CurrStr,'%f', True, True, 12, False);
      buildline ( 74, CURRSTR );
      OUTPUTLINE;
      RepDash;
      BLANKLINE;
      OUTPUTLINE;
    END;						{ end SUBTOTAL }

    Function check_0_codes ( test_this : ShortString ) : Boolean;
    Var
      counter   : Integer;
      test_code : ShortString{[1]};
      EditStat	: ShortString{[1]};
    Begin						{ begin check_0_codes }
      slimleft ( test_this );
      slimright ( test_this );

      check_0_codes := false;
      test_code := space1;
      If length ( test_this ) > 0 Then
	test_code[1] := test_this[1]
      Else
	test_code[1] := lastcode;

      { Don't check pos 0 as its going to be 0 rated }
      If Cash2.xcountry = 2 Then
	Begin
	  GetItem ( TxFile, 11 );
	  For counter := 1 To 9 Do
	     Begin
		If ( test_code = Cash1.xtaxids[counter] ) And ( CurrLong = 0 ) Then
		   check_0_codes := ( Cash1.xtaxrates[counter] = 0 );
	     End;
	End
      Else
	Begin
	   EditStat := SPACE1;
	   Getitem ( TxFile, 28 );
	   EditStat[1] := CurrDisp[1];
	   Getitem ( TxFile, 11 );
	   Check_0_Codes := ( test_code[1] = 'E' ) And ( CurrLong = 0 ) And
			    ( EditStat[1] In ['I','P'] );
	End;
    End;						  { end check_0_codes }

    (*
    Function CheckNextTx ( db, RecTx : Integer ) : Boolean;
    Var
      ThisType : Integer;

    Begin
      CheckNextTx := False;
      GetItem ( 2, 1 );
      ThisType := Currint;
      If ( ThisType = 9 ) Then
	 Begin
	    SetDb ( db );
	    If RecTx+1 <= db1.dbrechigh Then
	       Begin
		  ReadRec ( db, RecTx+1 );
		  If Errorno > 0 Then DbErr;
		  If Recactive ( db ) Then
		     Begin
			GetItem ( 2, 1 );
			CheckNextTx := ( Currint <> 0 );
		     End;
	       End;
	    { ReRead the Current Record }
	    ReadRec ( db, RecTx );
	    If ErrorNo > 0 Then DbErr;
	 End;
    End;
    *)

  Begin						   { begin PROCESSSORT }
// tgm added this to see if it sorts out S Ireland VAT 'Include in TAX Return'
// the 3 lines below do sort out the 'include in TAX return' problem, but only for the audit trail
// the summary is built in SPREPA lines 1190+, so would need to fix them also
// testcode is a string holding the 10 entries for 'include in tax return' for each of the 10 VAT codes
// VAT setup screen in S Ireland setting doesn't have columns for include/exclude from VAT return so it's
// not much use checking for these values.  Need to alter VAT setup screen if it's required to allow
// S Ireland users to choose to include/exclude from VAT return

{    testcode := null;
    for vat_count := 0 to 9 do
      testcode := concat ( testcode, Cash1.xtaxids[vat_count] );}


    SETDB(DBNO);
    {
    fromdt := from_date;
    todt   := to_date;
    }
{-->>    check_9_types := False;}

    (* open the purchase & sales file *)
    {
    opendb ( 5, XPLACCFILE );
    opendb ( 4, XSLACCFILE );
    IF (( Device[1] IN ['F','P','S'] ) and ( first_disp )) THEN
      BEGIN
	CLEARFROM (24);
	STR (DB1.DBRECHIGH,TOPREC);
	DIS (1,24,'PROCESSING TRANSACTION RECORD ...');
      END;
    }
    SORTPOS:=512;
    SORTBLK:= -1;
 //   NextCust;
    RecNo := DB1.DBRECHIGH;
    Inc(RECNO);
 {   REPEAT
      NEXTCUST; }// TGM AB
    Accsdatamodule.TransactionsDB.first;
    lastrec := Accsdatamodule.TransactionsDB['TxNo'];
    Accsdatamodule.TransactionsDB.last;
    Repeat
      //Dec(RECNO);
      Getitem(TxFile,1);
      Recno := Accsdatamodule.TransactionsDB['TxNo'];
      currec := recno;
      IF (RECNO>=SCHRECF) AND (RECNO<=SCHRECT) THEN
	BEGIN
	  {
          IF ( Device[1] IN ['F','P','S'] ) THEN
	    if first_disp then
	      BEGIN
		DIS  (35,24,'	  ');
		DISI (35,24,RECNO,1);
	      END;
	  }
	  SETDB	  (DBNO);
	  READREC (DBNO,RECNO);
	  IF ERRORNO>0 THEN DbErr;

	  IF RECACTIVE(DBNO) THEN
	    BEGIN
	      OKTOPRINT:=TRUE;

	      { Check the next record to see if its a VAT Record }
	      Check_9_Types := CheckNextTx ( DbNo, RecNo );

	      { Moved from below }
	      GETITEM(TxFile,10);
	      IF CURRSTR=SPACE1 THEN OKTOPRINT:=FALSE;
//tgm added to sort out S I VAT problem
              If CurrStr = '0' then OKTOPRINT:=False;
		If oktoprint Then
		  Begin
		    vat_count := pos ( currstr, testcode );
		    If vat_count > 0 Then
		      oktoprint := ( Cash2.vat_inc_exc[vat_count-1] = 'I' );
		  End;



	      {
	      check_9_types := false;
	      If ( Xcountry In [1,2] ) Then
		check_9_types := check_0_codes ( CURRSTR );
	      }

	      GETITEM(TxFile,1);
	      IF NOT (CURRINT IN [0,10]) THEN
		 OKTOPRINT:=FALSE;
	      {
	      If (( xcountry In [1,2] ) And
		  ( check_9_types ) And
		  ( currint = 9 )) Then
		 oktoprint := true;
	      }
// tgm reMmed out next bit 16/10/01
{	      If (( Cash2.xcountry In [1,2] ) And
		  ( check_9_types )) Then
		 oktoprint := true;}

	      GETITEM(TxFile,2);
	      IF (CURRINT<FROMDT) OR (CURRINT>TODT) THEN OKTOPRINT:=FALSE;
	      IF OKTOPRINT AND (ACT IN [11,12]) THEN
		BEGIN
		  GETITEM (TxFile,8);
		  {
		  IF CURRINT IN [XNOMPRVINC,XNOMPRVEXP+xno_of_partners] THEN OKTOPRINT:=FALSE;
		  }
		  If (( currint >= Cash1.xnomprvinc ) And
		      ( currint <= Cash1.xnomprvexp+Cash11.xno_of_partners )) Then
		     oktoprint := False;
		  GETITEM (TxFile,28);
		  IF CURRDISP[1] IN ['E','R'] THEN OKTOPRINT:=FALSE;
		  IF OKTOPRINT THEN
		    BEGIN
		      SUB:=0;
		      NEG:=FALSE;
		      GETITEM (TxFile,1);
		      {
		      If ( CURRINT=0 ) Or (( xcountry In [1,2] ) And
			 ( check_9_types ) And ( currint = 9 )) THEN
		      }
		      If ( CURRINT=0 ) Or (( Cash2.xcountry In [1,2] ) And
			 ( check_9_types )) THEN
			BEGIN
			  GETITEM (TxFile,23);
			  TXT:=CURRINT;
			  IF TXT IN [1,2,3,4,11,12] THEN SUB:=1;
			  IF TXT IN [5,6,7,8,15,16] THEN SUB:=2;
			END;
		      IF CURRINT=10 THEN SUB:=1;
		      IF SUB>0 THEN
			BEGIN
			  GETITEM (TxFile,9);
			  AMT:=CURRLONG;
			  GETITEM (TxFile,1);
			  {
			  IF ( CURRINT=0 )  Or (( xcountry In [1,2] ) And
			     ( check_9_types ) And ( currint = 9 )) THEN
			  }
			  IF ( CURRINT=0 )  Or (( Cash2.xcountry In [1,2] ) And
			     ( check_9_types )) THEN
			    IF ((NOT (TXT IN [3,7])) AND (AMT<0))
			    OR ((     TXT IN [3,7] ) AND (AMT>0)) THEN
			      BEGIN
				IF SUB=1 THEN SUB:=2 ELSE SUB:=1;
				NEG:=TRUE;
			      END;
			  IF CURRINT=10 THEN NEG:=TRUE;
			END;
		      IF ((ACT=11) AND (SUB<>1))
		      OR ((ACT=12) AND (SUB<>2)) THEN OKTOPRINT:=FALSE;
		      IF OKTOPRINT THEN
			BEGIN
			  GETITEM (TxFile,10);
			  IF CURRDISP[1]<>LASTCODE THEN
			    BEGIN
			      IF LASTCODE<>CHR(0) THEN SUBTOTAL;
			      LASTCODE:=CURRDISP[1];

			      {
			      check_9_types := false;
			      If ( Xcountry In [1,2] ) Then
				check_9_types := check_0_codes ( ' ' );
			      }
			      SUBTAX  :=0;
			      SUBAMT  :=0;
			      SUBREC  :=0;
			    END;
			END;
		    END;
		END;
	      IF OKTOPRINT THEN begin
                                CURRREC [TxFile]:=RECNO;   // added to fix problems with recno getting changed
                                PRINTOUT (TRUE);
                                end;
	      IF ESCKEY THEN EXIT;
	    END;
	END;
        Accsdatamodule.TransactionsDB.Locate('TxNo',currec,[]);
        Accsdatamodule.TransactionsDB.prior;
    UNTIL RECNO = Lastrec; // = 0;

    IF (PROG=SPECREP) AND (ACT IN [11,12]) AND (LASTCODE<>CHR(0)) THEN SUBTOTAL;
    {
    cclose ( 4, 'N' );
    cclose ( 5, 'N' );
    }
  END;							{ end PROCESSSORT }

  { 09/12/94 . MC. Changed the heading routine for specrep act 7
    ( full nom audit ) its called before a valid record has been read from the
    transaction file then the flag first_acc is set to false and the report
    carried out as normal. This was done to accomodate the displaying of the
    nominal name in the heading.
  }
  PROCEDURE PROCESSFILE;
  VAR
    skip_rec	      : Boolean;
    RECNO	      : INTEGER;
    BALANCE	      : LONG;
    TOPREC	      : ShortString{[5]};
    break_loop	      : boolean;
    hold_break_pt     : packed array [1..9] of integer;
//    testcode	      : ShortString{[10]};
//    vat_count	      : integer;

    tr_account,
    tr_orig,
    tr_type	      : integer;

    TransType	      : Integer;
{-->>    VatAmt	      : Long;}
    VatCode	      : ShortString{[1]};
    EditStat	      : ShortString{[1]};

  BEGIN							{ begin PROCESSFILE }
    skip_rec := false;
    (*
    if (( prog = specrep ) and ( act in [5,7] )) then
      Begin
	{ open sales & purchase ledgers }
	opendb ( 4, xslaccfile );
	opendb ( 5, xplaccfile );
      End;
    *)
    fillchar ( nom_heading, 40, ' ');
    last_counter      := 0;
    counter	      := 1;
    hold_break_pt[1]   := Cash1.XNOMINCTO;
    hold_break_pt[2]   := Cash1.XNOMNONTO;
    hold_break_pt[3]   := Cash1.XNOMEXPTO;
    hold_break_pt[4]   := Cash1.XNOMOHTO;
    hold_break_pt[5]   := Cash1.XNOMCATO;
    hold_break_pt[6]   := Cash1.XNOMFATO;
    hold_break_pt[7]   := Cash1.XNOMLITO;
    hold_break_pt[8]   := Cash1.XBANKMAX;
    hold_break_pt[9]   := DB1.DBRECHIGH;

    testcode := null;
    for vat_count := 0 to 9 do
      testcode := concat ( testcode, Cash1.xtaxids[vat_count] );

    SETDB(DBNO);

    IF ( Device[1] in ['F','P','S'] ) THEN
      BEGIN
	SETDB(DBNO);

	STR (DB1.DBRECHIGH,TOPREC);
	{
        IF PROG = SPECREP THEN
	  BEGIN
	    if first_disp then
	      begin
		IF ACT IN [88,6,7,5] THEN
		  DIS (1,24,'PROCESSING ACCOUNT NUMBER ...')
		ELSE
		  DIS (1,24,'PROCESSING TRANSACTION RECORD ...');
		IF ACT IN [88,6,7,5] THEN
		  DIS (36,24,CONCAT('(OF ',TOPREC,')'))
		ELSE
		  DIS (41,24,CONCAT('(OF ',TOPREC,')'));
	      end;
          END;
        }
      END;

    RECNO:=SCHRECF;

    REPEAT
      {
      IF (( Device[1] in ['F','P','S'] ) and ( first_disp )) THEN
	BEGIN
	  if report_sort then
	    Begin
	      clearfrom ( 24 );
	      dis ( 1, 24, 'PROCESSING ACCOUNT NUMBER ...' );
	    End;
	  IF ACT IN [88,6,7,5] THEN
	    DISI (31,24,RECNO,1)
	  ELSE
	    DISI (35,24,RECNO,1);
	END;
      }
      READREC(DBNO,RECNO);
      IF ERRORNO > 0 THEN DbErr;

      {* if running full nominal ledger audit trail }
      If (( prog = specrep ) And ( act = 7 )) Then
	skip_rec := ExcludeNominal ( recno );

      If NOT skip_rec Then
	IF RECACTIVE(DBNO) THEN
	  BEGIN

	    OKTOPRINT:=TRUE;

	    if (( Cash11.TRANS_AMEND ) and ( NOT ( ACT in [88,6,7,5] ))) then
	      OKTOPRINT := CheckEditStatus;

  (* change *)
	    if ACT = 88 then
	      begin
		{ * if exclude enterprises then do not print if the enterprise
		    field has a code in it }
		getitem ( dbno, 24 );
		if (( Cash11.xuse_enterprise ) and ( currstr <> null )) then
		  oktoprint := false;

		repeat
		  if RECNO <= hold_break_pt[counter] then
		    break_loop := true
		  else
		    begin
		      counter	 := counter + 1;
		      break_loop := false;
		    end;
		until break_loop;

		case counter of
		  1 : nom_heading := concat (Cash2.XENTUPPER,' INCOME');
		  2 : if NOT Cash11.Xuse_enterprise then
			nom_heading := concat ('NON ',Cash2.XENTUPPER,' INCOME')
		      else
			nom_heading := 'INCOME';
		  3 : nom_heading := concat (Cash2.XENTUPPER,' EXPENDITURE');
		  4 : if NOT Cash11.Xuse_enterprise then
			nom_heading := 'OVERHEADS'
		      else
			nom_heading := 'EXPENSE';
		  5 : nom_heading := 'CURRENT ASSETS';
		  6 : nom_heading := 'FIXED ASSETS';
		  7 : nom_heading := 'LIABILITY ACCOUNTS';
		  8 : nom_heading := 'BANKS';
		  9 : nom_heading := 'OTHER NOMINAL CODES';
		end;
		{
		if ((( recno > xnomprvinc+xno_of_partners ) And
		     ( recno < xnomprvexp )) Or
		    (( recno > xnomprvexp+xno_of_partners ) And
		     ( recno < xnomtax )) Or
		    (( recno > xnomprofit+xno_of_partners ) And
		     ( recno < xnomopen )) Or
		     ( recno > xnomopen+xno_of_partners )) Then
		  oktoprint := false;
		}
		oktoprint := ( NOT ExcludeNominal ( recno ));

	      end;
	    IF (ACT IN [3,1,2]) AND (PROG=SPECREP) THEN   // cashbook listing report
	      BEGIN
		GETITEM(TxFile,3);
       //		IF CURRINT<>0 THEN OKTOPRINT:=FALSE;     TGM AB - allows cashbook trans with accounts to be shown
		CASE ACT OF
		  1,2 : BEGIN
			  GETITEM(TxFile,1);
			  IF ((ACT IN [1]) AND (CURRINT IN [11]))
			  OR ((ACT IN [2]) AND (CURRINT IN [15]))
			    THEN
			    ELSE OKTOPRINT:=FALSE;
			END;
		  3   : BEGIN
			  GETITEM(TXFile,23);
			  IF CURRINT<>0 THEN OKTOPRINT:=FALSE;
			END;
		END;
	      END;
	    IF OKTOPRINT AND (ACT=8) AND (PROG=SPECREP) THEN  // vat report
	      BEGIN
		GETITEM(TxFile,1);
		TransType := Currint;
		IF NOT (CURRINT IN [0,10]) THEN OKTOPRINT:=FALSE;

		If ( TransType = 9 ) Then
		   OkToPrint := CheckNextTx ( 2, RecNo );

		GetItem ( TxFile, 11 );
{-->>		VatAmt := CurrLong;}
		EditStat := SPACE1;
		Getitem ( TxFile, 28 );
		EditStat[1] := CurrDisp[1];

		VatCode := SPACE1;
		GETITEM(TxFile,10);
		VatCode[1] := currdisp[1];
		IF CURRSTR=SPACE1 THEN OKTOPRINT:=FALSE;

		{ 14/12/94
		  if okto print then check if its to be included }
		If oktoprint Then
		  Begin
		    vat_count := pos ( currstr, testcode );
		    If vat_count > 0 Then
		      oktoprint := ( Cash2.vat_inc_exc[vat_count-1] = 'I' );
		  End;

		(*
		If (( TransType = 9 ) And
		    ( VatAmt = 0 ) And
		    ( VatCode[1] = 'E' ) And
		    ( EditStat[1] In ['I','P'] )) Then { Details Line }
		  oktoprint := True;
		*)
	      END;

	    If OKTOPRINT AND (ACT IN [7,5]) AND (PROG=SPECREP) AND (PRINTZERO) THEN
	      BEGIN
		(*
		GETITEM(1,2);
		BALANCE:=CURRLONG;
		*)
		BALANCE:=0;
		CASE ACT OF
		  7  : GETITEM(NlFile,15);
		  5  : BEGIN
			 GETITEM(Nlfile,14);
			 IF CURRINT=0 THEN GETITEM(NlFile,15);
		       END;
		END;
		OKTOPRINT:= (BALANCE<>0) OR (CURRINT<>0);
	      END;

	    If OKTOPRINT AND (DBNO=TxFile) Then
	      Begin
		GETITEM(TxFile,2);
		If (CURRINT<FROMDT) Or (CURRINT>TODT) Then OKTOPRINT:=FALSE;
	      End;

	    {* list transactions report }
	    If (( oktoprint ) and ( act = 30 ) and ( prog = specrep )) then  // Transaction Report             //Ch028
	      Begin
		If CheckEditStatus then		  { test for edited or reversed }
		  Begin
		    tr_desc := '';
                    //tr_debit := 0;
                    //tr_credit := 0;
		    getitem ( TxFile, 3 );
		    tr_account := currint;
		    getitem ( TxFile, 1 );
		    tr_type := currint;
		    getitem ( TxFile, 23 );
		    tr_orig := currint;

		    { test the transaction type }
		    case tr_type of
		      1,
		      2,
		      3	 : Begin
			     oktoprint := (( tr_cust ) and ( tr_orig = tr_type ));
			     tr_desc := 'Customer';
			     If tr_type = 1 Then
				tr_desc := Concat ( tr_desc, ' Invoice' )
			     Else
				If tr_type = 2 Then
				   tr_desc := Concat ( tr_desc, ' Receipt' )
				Else
				   tr_desc := Concat ( tr_desc, ' Credit Note' )
			   End;
		      5,
		      6,
		      7	 : Begin
			     oktoprint := (( tr_supp ) and ( tr_orig = tr_type ));
			     tr_desc := 'Supplier';
			     If tr_type = 5 Then
				tr_desc := Concat ( tr_desc, ' Invoice' )
			     Else
				If tr_type = 6 Then
				   tr_desc := Concat ( tr_desc, ' Payment' )
				Else
				   tr_desc := Concat ( tr_desc, ' Credit Note' );

                             //GM meddled with this 18/02/03 to get nominal account unto transaction report
                             //getitem ( TxFile, 8 );
                             //tr_debit := currint;

			   End;
		      9	 : Begin
			     oktoprint := (( tr_d_debits ) and ( tr_orig = 0 ));
			     tr_desc := 'Direct Debits/Journals';
			   End;
		      11 : Begin
			     oktoprint := (( tr_cashinc ));// and ( tr_account = 0 ));
			     if Cash11.xuse_inc_exp then
			       tr_desc := 'Standing Order Income'
			     else
			       tr_desc := 'Cashbook Income';
			   End;
		      15 : Begin
			     oktoprint := (( tr_cashexp ));// and ( tr_account = 0 ));
			     if Cash11.xuse_inc_exp then
			       tr_desc := 'Standing Order Expenditure'
			     else
			       tr_desc := 'Cashbook Expenditure';
			   End;
		      else oktoprint := false;
		    End;
		  End
		else
		  oktoprint := false;
	      End;

	    If OKTOPRINT Then
	      Begin
		 if (( prog = specrep ) and ( act = 7 )) then
		    Begin
		       if first_acc then
			  repheadings;
		       first_acc := false;
		    End;
		 PRINTOUT (TRUE);
	      End;

	    IF ESCKEY THEN
	      Begin
		if (( act in [5,7] ) and ( prog = specrep )) then
		   Begin
		     cclose ( 4, 'N' );
		     cclose ( 5, 'N' );
		   End;
		EXIT;
	      End;
	  END;
      RECNO := RECNO + 1;
      SETDB ( DBNO );
    UNTIL RECNO > SCHRECT;

    {
    if (( prog = specrep ) and ( act in [5,7] )) then
      Begin
	cclose ( 4, 'N' );
	cclose ( 5, 'N' );
      End;
    }
  END;							 { end PROCESSFILE }

  PROCEDURE PROCESSBALS;
  VAR
    no_partners : Integer;
    RECNO   : INTEGER;
    CATOT   : LISTBAL;
    FATOT   : LISTBAL;
    LITOT   : LISTBAL;
    WKTOT   : LISTBAL;
    OPTOT   : LISTBAL;
    TPTOT   : LISTBAL;
    X	    : INTEGER;
    WORKSTR : ShortSTRING{[80]};

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

    PROCEDURE CALCTOTS (VAR VAL1: Double{LONG}; VAR VAL2: Double{LONG});
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

    PROCEDURE SHOWTOTS ( TEXT: ShortSTRING; FROMTOT: LISTBAL;
			 VAR TOTOT: LISTBAL; DASH: BOOLEAN);
    VAR
      X : Integer;
      COL : PACKED ARRAY [1..6] OF INTEGER;
    BEGIN						    { begin SHOWTOTS }
      COL[1]:=53;
      COL[2]:=65;
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

      CALCTOTS (TOTOT[1],TOTOT[2]);
      CALCTOTS (TOTOT[3],TOTOT[4]);
      CALCTOTS (TOTOT[5],TOTOT[6]);

      BLANKLINE;
      BUILDLINE (1,TEXT);
      FOR X:=1 TO 6 DO
	 BEGIN
	    DoubleToStr (TOTOT[X],WORKSTR,'%f', True, True, 11, False);
	    WORKSTR[12]:=SPACE1;
	    BUILDLINE (COL[X],'-');
	    IF TOTOT[X]<>0 THEN BUILDLINE (COL[X]-8,WORKSTR);
	 END;
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
      TOTAL : LONG;
    BEGIN						 { begin SHOWBALS }
      TOTAL:=0;
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
		    GETITEM (dbno,2);
		    IF CURRLONG <= 0 then
		      OKTOPRINT:=FALSE
		    ELSE
		      TOTAL := TOTAL + CURRLONG;
		  END;
	      4 : BEGIN
		    PRINT:=FALSE;
		    GETITEM(dbno,2);
		    IF CURRLONG >= 0 then
		      OKTOPRINT:=FALSE
		    ELSE
		      TOTAL:=TOTAL+CURRLONG;
		  END;
	      5 : PRINT:=FALSE;
	    END;
	    IF OKTOPRINT THEN PRINTOUT (PRINT);
	    IF ESCKEY THEN EXIT;
	  END;
	RECNO:=RECNO+1;
      UNTIL RECNO>TOREC;
      CASE TEST OF
	1 : IF OKTOPRINT THEN SHOWTOTS (CONCAT(Cash1.XTAXCODE,' RECOVERABLE'),BALTOT[1],BALTOT[1],FALSE);
	3 : IF OKTOPRINT THEN SHOWTOTS (CONCAT(Cash1.XTAXCODE,' PAYABLE'),	BALTOT[1],BALTOT[1],FALSE);
	2 : IF TOTAL> 0	 THEN SHOWTOTS ('BALANCE AT BANK',BALTOT[1],BALTOT[1],FALSE);
	4 : IF TOTAL< 0	 THEN SHOWTOTS ('BANK OVERDRAFT', BALTOT[1], BALTOT[1],FALSE);
      END;
    END;					       { end SHOWBALS }

    PROCEDURE get_2_balances (FROMREC,TOREC,TEST: INTEGER);
    VAR
      count : Integer;
    BEGIN						 { begin SHOWBALS }
{-->>      count := 0;}

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

    PROCEDURE SUBTITLE (TEXT: ShortSTRING);
    BEGIN					       { begin SUBTITLE }
      BLANKLINE;
      BUILDLINE (1,TEXT);
      OUTPUTLINE;
      BLANKLINE;
      OUTPUTLINE;
    END;						{ end SUBTITLE }

  BEGIN							{ begin PROCESSBALS }
    SETDB(DBNO);

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
    SUBTITLE ('FIXED ASSETS');
    ZEROTOTS;
    SHOWBALS (Cash1.XNOMFAFROM,Cash1.XNOMFATO,0);
    SHOWTOTS ('TOTAL FIXED ASSETS',BALTOT[1],FATOT,TRUE);
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
    SHOWTOTS ('TOTAL NET ASSETS',BALTOT[1],BALTOT[1],FALSE);
    ZEROTOTS;
    {
    SHOWBALS (XNOMPROFIT,XNOMOPEN,5);
    SHOWTOTS ('OPENING NET WORTH',BALTOT[1],OPTOT,FALSE);
    ZEROTOTS;
    }
    For no_partners := 1 To Cash11.xno_of_partners+1 Do
      Begin
	get_2_balances (Cash1.XNOMPROFIT+no_partners-1,Cash1.XNOMOPEN+no_partners-1,5);
	SHOWTOTS ('OPENING NET WORTH',BALTOT[1],OPTOT,FALSE);
	ZEROTOTS;
      End;
    SHOWBALS (Cash1.XNOMINCFROM,Cash1.XNOMOHTO,5);
    SHOWTOTS ('TRADING PROFIT FOR YEAR',BALTOT[1],TPTOT,FALSE);
    BLANKLINE;
    OUTPUTLINE;
    {
    ZEROTOTS;
    SHOWBALS (XNOMPRVINC,XNOMPRVEXP+xno_of_partners,5);
    SHOWTOTS ('LESS DRAWINGS',BALTOT[1],BALTOT[1],FALSE);
    }
    For no_partners := 1 to Cash11.xno_of_partners+1 Do
      Begin
	ZEROTOTS;
	get_2_balances (Cash1.XNOMPRVINC+no_partners-1,Cash1.XNOMPRVEXP+no_partners-1,5);
	SHOWTOTS ('LESS DRAWINGS',BALTOT[1],BALTOT[1],FALSE);
      End;
    FOR X:=1 TO 6 DO BALTOT[1][X]:=OPTOT[X]+TPTOT[X]+BALTOT[1][X];
    SHOWTOTS ('TOTAL NET WORTH',BALTOT[1],BALTOT[1],TRUE);
  END;							{ end PROCESSBALS }

  PROCEDURE REPSEG;					{ begin REPSEG }
  BEGIN

    IF ACT IN [11,12] THEN
      BEGIN
	{
        IF (( ACT = 11 ) AND ( Device[1] IN ['P','F'] ) and
	    ( NOT pickopt[17] )) THEN
	  BEGIN
	    CLEARFROM ( 5 );
	    DATA_DEST ( 8, WORKSTR );		   (* get report destination *)

	    IF ESCKEY THEN
	      EXIT ( REPSEG );

	    Device[1] := WORKSTR[1];
	  END;
        }
	HEADING:=CONCAT(Cash1.XTAXCODE,' AUDIT TRAIL ');
	CASE ACT OF
	  11 : HEADING:=CONCAT(HEADING,'- INCOME');
	  12 : HEADING:=CONCAT(HEADING,'- EXPENDITURE');
	END;
	PAGENO	 :=0;
	TOTRECS	 :=0;
	AMTTOT	 :=0;
	TAXDTOT	 :=0;
	LASTCODE :=CHR(0);
	NOHEADING:=FALSE;
      END
    ELSE
      BEGIN
	REPORTRUN;
	IF ESCKEY THEN EXIT;
	If (( Prog = specrep ) And ( Act = 4 ) And ( new_rec )) Then
	   Begin
	      {
	      gotoxy(0,0);
	      writeln ('Bank From ',schrecf );
	      writeln ('Bank To	  ',schrect );
	      writeln ('From Date ',fromdt  );
	      writeln ('To Date	  ',todt );
	      writeln ('Stub From ',schstubf);
	      writeln ('Stub To	  ',schstubt);
	      halt;
	      }
	      {
              bank_reconciliation ( schrecf, schrect, fromdt, todt,
				    stubp, stubu, stube,
				    schstubf, schstubt );
              exit ( nomreports );
              }
	   End;
      END;

    if (( prog = specrep ) and ( act In [7,101] )) then
      { do nothing }
    else
      REPHEADINGS;

    IF ACT IN [11,12] THEN
      PROCESSSORT
    ELSE
      IF ACT = 21 THEN
	PROCESSBALS
      ELSE
        If ( act = 121 ) And BalanceSheet Then
	  ProcBalanceSheet
	Else
          IF ACT=89 THEN
	    PROCESSTABS
	  ELSE
	    IF DBNO = EntFile THEN
	      PROCESSENTS
	    ELSE
	      If act = 100 Then
		Rep_Trial_by_Groups
	      Else
		If act = 101 Then
		  Rep_Nominal_by_Groups
		Else
		  PROCESSFILE;         // vat report is included in this

    If (( ACT = 8 ) AND ( TAXAUDIT ) and ( Device[1] = 'F' ) and
       ( NOT ESCKEY )) THEN
      Begin
	{ENDPRINT;}
	PRINTTOTS;
      End
    Else
      If (ACT IN [8,11]) AND (TAXAUDIT) THEN
	PRINTTOTS
      ELSE
	BEGIN
	  if (( ACT in [4, 5] ) and ( PROG = SPECREP )) then
	    Begin
	      if ACT = 5 then endprint;
	    End
	  else
            If ( Act = 6 ) And ( PROG = SPECREP ) Then  { Trial Balance }
               Begin
                  PrintTots;
                  EndPrint;
               End
            Else
                If ((PROG=SPECREP) AND (ACT=8)) THEN
                   Begin
                        PRINTTOTS;
                        If NOT TaxAudit Then EndPrint;
                   End
                Else
                    Begin
                       IF NOT ((PROG=SPECREP) AND (ACT=4)) THEN
                          PRINTTOTS;
                       Endprint;
                    End;
	END;
  END;							 { end REPSEG }

  PROCEDURE MAINFLOW;
  var
  i, v : integer;

    PROCEDURE SHOWMENU;
    VAR
      temp_line : integer;

      Function line_no : integer;
	Begin
	  temp_line := temp_line + 1;
	  line_no := temp_line;
	End;

    BEGIN						  { begin SHOWMENU }
      {
      first_disp := true;
      BETASCREEN(SUBSYS);
      BETAUSER;
      }
      {
      temp_line := 5;

      if NOT Xuse_inc_exp then
	Begin
	  DIS ( 9, line_no,'1 ... Cashbook Income Listing');
	  DIS ( 9, line_no,'2 ... Cashbook Expenditure Listing');
	End;
      DIS ( 9, line_no,'3 ... Nominal Ledger Journal Listing');

      temp_line := temp_line + 1;
      DIS ( 9,line_no,'4 ... Bank Reconciliation');
      DIS ( 9,line_no,'5 ... Bank Audit Trail');

      temp_line := temp_line + 1;
      DIS ( 9,line_no,'6 ... Trial Balance');
      DIS ( 9,line_no,'7 ... Full Nominal Ledger Audit Trail');

      if NOT Xuse_vat then
	Begin
	  temp_line := temp_line + 1;
	  DIS ( 9,line_no,CONCAT('8 ... ',XTAXCODE,' Report'));
	End;

      temp_line := temp_line + 1;
      IF (XCASHBOOK) AND (NOT XTXANAL) THEN
	DIS ( 9,line_no,'9 ... Return to Main Menu')
      ELSE
	BEGIN
	  DIS ( 8,line_no,' 9 ... Sales Analysis Report');
	  DIS ( 8,line_no,'10 ... Purchase Analysis Report');
	  temp_line := temp_line + 1;
	  DIS ( 8,line_no,'99 ... Return to Main Menu');
	END;
      BETAMENU;
      }
      AUTOFIRST:=FALSE;
      AUTORUN  :=FALSE;
    END;						 { end SHOWMENU }

    PROCEDURE REPAUDIT;
    BEGIN						 { begin REPAUDIT }
      HEADING:=CONCAT(Cash1.XTAXCODE,' AUDIT TRAIL');
      {
      BETASCREEN (SUBSYS);
      BETATITLE	 (HEADING);
      IF Device[1] = 'C' THEN Device[1] := 'P';
      }
    END;						 { end REPAUDIT }

  BEGIN							 { begin MAINFLOW }
    ACT:=option{0};
{
    REPEAT
}
    {
    if autoprog = 0 then
      Begin
	showmenu;
	act := option;
      End
    else
      act := autoprog;
      }
{
      IF AUTOPROG=0 THEN
	BEGIN
	  SHOWMENU;
	  REPEAT
	    no_func_key;
	    REC(30,24,2,'  ',0,0,0,0,0,0);
	    IF ESCKEY OR (SCRINT='M') OR (SCRINT='m') THEN
	      IF (XCASHBOOK) AND (NOT XTXANAL)
		THEN SCRINT:='9'
		ELSE SCRINT:='99';
	    WORKSTR:=SCRIN;
	    ACT:=0;
	    IF NUMERIC ( SCRINT ) THEN INTVAL ( ACT, SCRINT );

	    if (( Xuse_vat ) and ( ACT = 8 )) then ACT := 0;
	    if (( Xuse_inc_exp ) and ( act in [1, 2] )) then act := 0;

	  UNTIL ((NOT XCASHBOOK)		   AND (ACT IN [1..10,55,99]))
	     OR ((    XCASHBOOK) AND (	  XTXANAL) AND (ACT IN [1..10,55,99]))
	     OR ((    XCASHBOOK) AND (NOT XTXANAL) AND (ACT IN [1..8, 55, 9]));
	  IF	((NOT XCASHBOOK)		   AND (ACT=99))
	  OR	((    XCASHBOOK) AND (	  XTXANAL) AND (ACT=99))
	  OR	((    XCASHBOOK) AND (NOT XTXANAL) AND (ACT= 9)) THEN
	    EXIT(NOMREPORTS);
}
	  IF (ACT= 8) AND (Cash2.XCOUNTRY=2) THEN ACT:=23;
	  IF (ACT= 9) THEN ACT:=33;
	  IF (ACT=10) THEN ACT:=44;
{
	END
      ELSE
	ACT:=AUTOPROG;
}

      IF ACT IN [1..8,21,121,24,30,55,66,77,88,89,100,101] THEN
	BEGIN

	  ESCKEY:=FALSE;
	  CASE ACT OF
	    4,5,6,7,21,121,88,89,100,101 : DBNO:=NlFile{1};
	    1,2,3,8,24,30,55	         : DBNO:=TxFile{2};
	    66,77		         : DBNO:=EntFile{6};
	  END;
	  SETDB (DBNO);
	  IF ACT = 24 THEN
	    REPAUDIT
	  ELSE
	    REPSEG;
	  IF (ACT=4) AND (NOT ESCKEY) THEN
	    BEGIN
	      ACT:=5;
	      REPSEG;
	    END;

	  IF (ACT IN [8,24]) AND (NOT ESCKEY) AND (TAXAUDIT) THEN
	    BEGIN

              {
              IF ( ACT = 8 ) AND ( NOT ( Device[1] IN ['F','P','S'] )) THEN
		BEGIN
                  if Device[1] <> 'S' then
		    CONTINUE;
		  BETASCREEN (SUBSYS);
		  BETATITLE  (HEADING);
		END;
	      }

           //   SortFile ( TxFile, SortFileNo, WorkFile, 10, 999, 0, 0, TRUE, TRUE, TRUE, TRUE,
	   //	     0, 0, false, false );
           // TGM AB Removed Sortfile above

           Accsdatamodule.TransactionsDB.close;

           Accsdatamodule.SQLUpdate.sql.clear;
           Accsdatamodule.SQLUpdate.sql.Add('CREATE INDEX ByTaxCode ON Transactions (TaxCode)');
           Accsdatamodule.SQLUpdate.ExecSQL;

           Accsdatamodule.TransactionsDB.IndexName := 'ByTaxCode';

           Accsdatamodule.TransactionsDB.open;

           for I := 0 to Accsdatamodule.TransactionsDB.IndexFieldCount - 1 do
               if Accsdatamodule.TransactionsDB.IndexFields[I].Name = 'ByTaxCode' then
                  begin
                        Accsdatamodule.TransactionsDB.IndexName := Accsdatamodule.TransactionsDB.IndexDefs.Items[I].Name;
                  end;

           Accsdatamodule.TransactionsDB.last;


	 //     CCLOSE ( SortFileNo, 'N' );
	 //     CRESET ( SortFileNo, SORTID );

	      {IF ERRORNO > 0 THEN AbortProgram;}

	      ACT := 11;

	      If (( Device[1] = 'S' ) and ( Cash2.XCOUNTRY = 2 )) Then
		veryfirst := true;

	      REPSEG;

	      ACT := 12;

	      If not esckey then
		REPSEG;

	      {
              if (( Device[1] = 'F' ) and ( act = 12 )) then
		endprint;
              }

         //     CCLOSE (SortFileNo,'P');

	    END;
	END;
      IF ACT IN [22	 ] THEN PRINTALL;
      IF ACT IN [23,33,44] THEN AUTOPROG:=ACT;

      Accsdatamodule.TransactionsDB.IndexName := '';

{
    UNTIL AUTOPROG<>0;
}
  END;							 { end MAINFLOW }

  PROCEDURE ENTFLOW;
    PROCEDURE SHOWMEN1;
    BEGIN						  { begin SHOWMEN1 }
      {
      first_disp := true;
      BETASCREEN(SUBSYS);
      BETAUSER;
      DIS (9, 7,'1 ... This Year Only');
      DIS (9, 9,'2 ... This Year Compared with Last Year Totals');
      NEXTOPT:='3';
      NEXTROW:=11;
      IF XNOMLAST THEN
	BEGIN
	  DIS (9,NEXTROW,CONCAT(NEXTOPT,' ... This Year Compared with Budget & Last Year Periods'));
	  NEXTOPT:='4';
	  NEXTROW:=NEXTROW+2;
	END;
      IF XNOMTHIS THEN
	BEGIN
	  DIS (9,NEXTROW,CONCAT(NEXTOPT,' ... This Year Monthly'));
	  NEXTOPT:='5';
	  NEXTROW:=NEXTROW+2;
	END;
      IF XNOMLAST THEN
	BEGIN
	  DIS (9,NEXTROW,CONCAT(NEXTOPT,' ... Last Year Monthly'));
	  NEXTROW:=NEXTROW+2;
	END;

      IF XNOMLAST THEN
	BEGIN
	  NEXTOPT := '6';
	  DIS (9,NEXTROW,
	      CONCAT(NEXTOPT,' ... This Year ( ',XENTLOWER,' Unit Costings )'));
	  NEXTROW:=NEXTROW+2;
	END;

      NEXTROW:=NEXTROW+1;
      DIS (9,NEXTROW,'9 ... Return to Main Menu');
      BETAMENU;
}
    END;						{ end SHOWMEN1 }

  BEGIN							{ begin ENTFLOW }
    ACT:=0;
    {
    REPEAT
    }
      first_ent := true;
      {
      SHOWMEN1;
      REPEAT
	no_func_key;
	REC(30,24,1,SPACE1,0,0,0,0,0,0);
	IF ESCKEY OR (SCRINT='M') OR (SCRINT='m') THEN SCRINT:='9';
	WORKSTR:=SCRIN;
	ACT:=0;
	IF NUMERIC(SCRINT) THEN INTVAL(ACT,SCRINT);

(* change *)
	IF (NOT XNOMLAST) AND (ACT=6) THEN ACT:=0;
	IF (NOT XNOMLAST) AND (ACT=5) THEN ACT:=0;
	IF (NOT XNOMLAST) AND (ACT=4) THEN ACT:=0;
	IF (NOT XNOMTHIS) AND (ACT=3) THEN ACT:=0;
	IF (NOT XNOMLAST) AND (ACT=3) THEN ACT:=4;
      UNTIL ACT IN [1,2,3,4,5,6,9];
      IF ACT=9 THEN EXIT(NOMREPORTS);
      }
      act := option;
      SETDB ( EntFile );
      DBNO := EntFile{6};
      REPSEG;
    {
    UNTIL ACT<>ACT;
    }
  END;							{ end ENTFLOW }

BEGIN							{ begin NOMOREPORTS }
  Curr_Time := TimeToStr ( Time );
  { initialise the sort variables }
  report_sorted := false;
  sort_asc	:= false;
  sort_fld	:= 0;
  start_from	:= 0;
  which_nominal := 0;
  comment_cust_supp := '';

  period1	:= 0;
  period2	:= 0;

  AnalysisCodeFrom := 0;
  AnalysisCodeTo   := 9999;

  FROMDT    := EntCostPerUnit.TxDateFrom;{-32765;}
  TODT	    := EntCostPerUnit.TxDateTo;{+32765;}
  UsePreviousYear := False;

  // Enterprise Unit Costing Report
  If ( PROG = ENTREP ) And ( Option = 6 ) Then
     begin
        UsePreviousYear := EntCostPerUnit.EntUsePreviousYear;
        AnalysisCodeFrom := EntCostPerUnit.EntAnlFrom;
        AnalysisCodeTo   := EntCostPerUnit.EntAnlTo;
     end;

  SCHENT := EntCostPerUnit.EntCode.Text;
  SlimAll ( SchEnt );
  If Length ( SchEnt ) > 0 Then
     Begin
          Single_Ent := True;
          StrLong ( EntCostPerUnit.NoEntUnits.Text, TempLong );
          try No_Units   := TempLong * 100;                                                 //Ch030 - report code is expecting a database value (i.e x100 to remove decimals - table value doesn't provide that)
          except                                                                            //Ch030
          end;                                                                              //Ch030
          if EntCostPerUnit.PencePerUnit.checked then No_Units := No_Units/100;
          Unit_Name := EntCostPerUnit.EntUnitName.Text;
     End
  Else
      begin
         Single_Ent := False;
         Unit_Name := '';
      end;
      
  If No_Units = 0 Then
     No_Units := 100;

  BalanceSheet := ( not NominalReportForm.BalanceSheet.Checked );   // tgm fixed this 12/03/02 by adding a NOT - was the wrong way round

  ShowBreakDown := ( EntCostPerUnit.IncludePerQtyBreakDown_.Checked );
  If Numeric ( EntCostPerUnit.CalMonth.Text ) Then
     Month := StrToInt ( EntCostPerUnit.CalMonth.Text )
  Else
      Month := 0;
  MAXMONTH:=MONTH-Cash1.XFINMONTH+1;
  If MAXMONTH<1 Then MAXMONTH:=MAXMONTH+12;
  If ( PROG = ENTREP ) And ( OPTION = 5 ) Then MaxMonth := 12;

  ShowAnnual := ( EntCostPerUnit.ShowAnnual.Checked );
  Use_Tx     := ( EntCostPerUnit.UseTx.Checked );

  SETDB (EntFile);
  EXTRA	    :=(DB1.DBITEMS[10].DBINAME<>NULL) AND (Cash2.XENTEXTRA);
  AUTORUN   :=FALSE;
  AUTOFIRST :=FALSE;

  NOMYS	    :=true;{'Y';}
  NOMYM	    :=true;{'Y';}
  NOMPS	    :=true;{'Y';}
  NOMPM	    :=true;{'Y';}
  NOMYB	    :=false;{'N';}
  NOMYBV    :=false;{'N';}
  NOMLYM    :=false;{'N';}
  NEWPAGEACC:=false;{'N';}
  PRINTZERO :=false;{'N';}
  EXTENDED   :=False;{'N';}  { ** was default to 'Y' changed to 'N' 18-04-94 }
  RepType := 'Y';
  Trial_By_Group := 'A';
  If NominalReportForm.TrialBalancePanel.Visible Then
     Begin
        Setdb ( NlFile );
        SchRecf := 1;
        SchRect := db1.dbrechigh;
        Extended := ( NominalReportForm.Extended.Checked );
        ShowAnnual := ( NominalReportForm.ShowYearMonth.Checked );
        If ( NOT NominalReportForm.TrialByAccount.Checked ) Then
           Trial_By_Group := 'G';

        If Extended And ( NOT ShowAnnual ) Then
           Begin
                RepType := 'M';
                If Numeric ( NominalReportForm.CalMonth.Text ) Then
                   Month := StrToInt ( NominalReportForm.CalMonth.Text )
                Else
                    Month := 0;
                MAXMONTH:=MONTH-Cash1.XFINMONTH+1;
                If MAXMONTH<1 Then MAXMONTH:=MAXMONTH+12;
           End;
        TempStr := ( NominalReportForm.AccFrom.Text );
        SlimAll ( TempStr );
        If Numeric ( TempStr ) Then
           SchRecF := StrToInt ( TempStr );
        TempStr := ( NominalReportForm.AccTo.Text );
        SlimAll ( TempStr );
        If Numeric ( TempStr ) Then
           SchRecT := StrToInt ( TempStr );
     End;

  STUBU	    :=true;{'Y';}
  STUBE	    :=true;{'Y';}
  STUBP	    :=false;{'N';}
  TXDETAIL  :=true;{'Y';}
  BANKREC   :='Y';

  If NominalReportForm.BankAuditPanel.Visible Then
     Begin
          TxDetail := ( NominalReportForm.ShowStubDetails.Checked );
          Which_Stub := NominalReportForm.WhichStub.Text[1];
          PrintZero  := ( NominalReportForm.PrintZero.Checked );
          NewPageAcc := ( NominalReportForm.NewPageAcc.Checked );
          FROMDT    := NominalReportForm.TxDateFrom;
          TODT	    := NominalReportForm.TxDateTo;
          SetDb ( TxFile );
          schtxf    := 1;
          schtxt    := db1.dbrechigh;
          schrecf := Cash1.xBankMin;
          schrect := Cash1.xBankMax;
          If Numeric ( NominalReportForm.BankAuditAccFrom.Text ) Then
             schrecf := StrToInt ( NominalReportForm.BankAuditAccFrom.Text );
          If Numeric ( NominalReportForm.BankAuditAccTo.Text ) Then
             schrect := StrToInt ( NominalReportForm.BankAuditAccTo.Text );
     End;

  If NominalReportForm.CashBookListingPanel.Visible Then
     Begin
          FROMDT    := NominalReportForm.TxDateFrom;
          TODT	    := NominalReportForm.TxDateTo;
          TempStr := NominalReportForm.TxFrom.Text;
          SetDB ( TxFile );
          If Numeric ( TempStr ) Then
             schrecf   := StrToInt ( TempStr )
          Else
              schrecf := 1;
          TempStr := NominalReportForm.TxTo.Text;
          If Numeric ( TempStr ) Then
             schrect   := StrToInt ( NominalReportForm.TxTo.Text )
          Else
             schrect := db1.dbrechigh;
     End;
  tr_listall  := true;
  tr_cashinc  := true;
  tr_cashexp  := true;
  tr_d_debits := true;
  tr_cust     := true;
  tr_supp     := true;
  If NominalReportForm.TransListingPanel.Visible Then
     Begin
          FROMDT      := NominalReportForm.TxDateFrom;
          TODT	      := NominalReportForm.TxDateTo;
          schtxf      := NominalReportForm.TransFrom;
          schtxt      := NominalReportForm.TransTo;
          schrecf     := schtxf;
          schrect     := schtxt;
          tr_listall  := NominalReportForm.ListAllCheck.Checked;
          If NOT tr_listall Then
             Begin
                 tr_cashinc  := NominalReportForm.ListCashIncCheck.Checked;
                 tr_cashexp  := NominalReportForm.ListCashExpCheck.Checked;
                 tr_d_debits := NominalReportForm.ListDDJCheck.Checked;
                 tr_cust     := NominalReportForm.ListCustCheck.Checked;
                 tr_supp     := NominalReportForm.ListSuppCheck.Checked;
             End;
     End;

  If NominalReportForm.FullNominalPanel.Visible Then
     Begin
          FROMDT      := NominalReportForm.TxDateFrom;
          TODT	      := NominalReportForm.TxDateTo;
          schtxf      := NominalReportForm.TransFrom;
          schtxt      := NominalReportForm.TransTo;
          schrecf     := NominalReportForm.NomFrom;
          schrect     := NominalReportForm.NomTo;

          NOMYS	    := NominalReportForm.IncStartYearBal.Checked;
          NOMYM	    := NominalReportForm.IncMoveYear.Checked;
          NOMPS	    := NominalReportForm.IncStartMthBal.Checked;
          NOMPM	    := NominalReportForm.IncMoveMth.Checked;
          NOMYB	    := NominalReportForm.IncBudget.Checked;
          NOMYBV    := NominalReportForm.IncBudgetDiff.Checked;
          NOMLYM    := NominalReportForm.IncMoveLastYear.Checked;

          PrintZero  :=  NominalReportForm.PrintOnlyTx.Checked;
          NewPageAcc  := NominalReportForm.FullNomNewPAgeAcc.Checked;
     End;

  If NominalReportForm.VatPanel.Visible Then
     Begin
          SchRecf  := NominalReportForm.TransFrom;
          SchRect  := NominalReportForm.TransTo;
          FROMDT   := NominalReportForm.TxDateFrom;
          TODT	   := NominalReportForm.TxDateTo;
          TaxAudit := NominalReportForm.VatAuditChecked.Checked;
          Tx_Start := Schrecf;
          Tx_End   := Schrect;
     End;

  if NominalReportForm.pPrintNomsOrGroups.Visible Then
     begin
        Setdb ( NlFile );
        SchRecf := 1;
        SchRect := db1.dbrechigh;
        TempStr := ( NominalReportForm.AccFrom.Text );
        SlimAll ( TempStr );
        If Numeric ( TempStr ) Then
           SchRecF := StrToInt ( TempStr );
        TempStr := ( NominalReportForm.AccTo.Text );
        SlimAll ( TempStr );
        If Numeric ( TempStr ) Then
           SchRecT := StrToInt ( TempStr );
        if SchRecF > db1.dbrechigh then
           SchRecF := db1.dbrechigh;
        if SchRecT > db1.dbrechigh then
           SchRect := db1.dbrechigh;
     end;


  if NominalReportForm.Visible Then
     begin
        if NominalReportForm.pEntStructure.Visible Then
        begin
           if NominalReportForm.EntCode.Text <> '' then
              SchEnt := NominalReportForm.EntCode.Text
           else
              SchEnt := '';
        end;
     end;

  From_Date := FromDt;
  To_Date   := ToDt;

  If ( FromDt <> CDateFrom ) And ( ToDt <> CDateTo ) Then
     Begin
          KDateToStr ( From_Date, Date1 );
          KDateToStr ( To_Date, Date2 );
     End
  Else
      Begin
           Date1 := Null;
           Date2 := Null;
      End;

  COLHIGH   :=1;
  NEXTCOL   :=1;
  AUTOFIRST :=FALSE;
  AUTORUN   :=FALSE;

  first_ent := true;
  first_acc := true;

  new_rec      := False;

  BLANKLINE;

  CASE PROG OF
    ENTREP  : ENTFLOW;
    SPECREP : Begin
		If ( option = 90 ) Then
		  bank_balances
		Else
		  MAINFLOW;
	      End;
  END;

END;							 { end NOMREPORTS }


End.






