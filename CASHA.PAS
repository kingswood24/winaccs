Unit CashA; {CashFlowReports}

InterFace

  {
  Listing of all Procedures and Functions contained in this program section.
  Pro. CASHFLOW.
  Pro. CREPORTRUN.
  Pro. CREPHEADINGS.
  Pro. CPRINTTOTS.
  Pro. TOTALRECS.
  Pro. ENDPRINT.
  Pro. ERR.
  Pro. BUILDLINE.
  Pro. OUTPUTLINE.
  Pro. SKIPSCREEN.
  Pro. BLANKSCREEN.
  Pro. PROCESSGROUPc.
  Pro. PROCESSOTHER.
  Pro. PRINTSUMM.
  Pro. KNOCKOFF.
  }
{**
   19-02-97 M.C.
   Added new ACT Code 24 to casha + cashb to allow a Profit & Loss Report be
   generated from the Report Groups.
}

Procedure RunCashFlow ( option, option1 : integer );

Implementation
Uses
    NewClass,
    SysUtils,
    CashFlow,    { Unit containing the Form for Cashflow Reports }
    TotalTx,
    DBRPT,
    abortprg,
    Calcs,
    Params,
    DBCore,
    Vars,
    Types,
    graphics,
    Printers;

Procedure RunCashFlow ( option, option1 : integer );
VAR
  CurrDbl      : Double;
  GROUPBUD     : ^YEARVAL;
  TOTENTINC    : ^YEARVAL;
  TOTENTEXP    : ^YEARVAL;
  TOTINCOME    : ^YEARVAL;
  TOTEXPEND    : ^YEARVAL;
  TOTOVERHD    : ^YEARVAL;
  GROSSPROFIT  : ^YEARVAL;
  NETPROFIT    : ^YEARVAL;

  TOTOTHER   : ^YEARVAL;
  TOTBANK    : ^YEARVAL;
  OPENBAL    : LONG;
  NETWORTH   : LONG;
  GROUPNO    : ^GROUPVAL;
  RECGROUP   : ^GROUPVAL;
  MAXGROUP   : PACKED ARRAY [1..4] OF INTEGER;
  ACT	     : INTEGER;
  OPT	     : INTEGER;
  HEADING    : STRING; 
  TOTRECS    : INTEGER;
  PAGENO     : INTEGER;
  NEXTCOL    : INTEGER;
  COLHIGH    : INTEGER;
  {PLINE	     : STRING[255];}
  DBNO	     : INTEGER;
  VERYFIRST  : BOOLEAN;
  NAME	     : PACKED ARRAY [1..12] OF STRING[3];
  MONTH	     : INTEGER;
  MAXMONTH   : INTEGER;
  PASS	     : INTEGER;
  ACTVAL     : PACKED ARRAY [1..3] OF ^YEARVAL;
  BUDVAL     : PACKED ARRAY [1..3] OF ^YEARVAL;
  NUMBERONE  : BOOLEAN;
  SHOWANNUAL : BOOLEAN;
  from_grp,		      (* limits the detail business report by group *)
  to_grp     : integer;	      (* as above *)
  curr_time  : string;
  NewPageAfterIncExp,
  print_nonincome,
  use_tx     : Boolean;
  page_width : Integer;

PROCEDURE ERR; FORWARD;
PROCEDURE BUILDLINE(COL: INTEGER; STRVAL: STRING); FORWARD;
PROCEDURE OUTPUTLINE; FORWARD;
PROCEDURE SKIPSCREEN(LINES: INTEGER); FORWARD;
PROCEDURE BLANKLINE; FORWARD;
PROCEDURE REPSEG; FORWARD;


  Procedure NewMemory;
  Var
     x : Integer;
  Begin

    New ( GROUPBUD );
    New ( TOTENTINC );
    New ( TOTENTEXP );
    New ( TOTINCOME );
    New ( TOTEXPEND );
    New ( TOTOVERHD );
    New ( GROSSPROFIT );
    New ( NETPROFIT );

    New ( TOTOTHER );
    New ( TOTBANK );
    New ( GROUPNO );
    New ( RECGROUP );
    For x := 1 To 3 Do
        Begin
             New ( ACTVAL[x] );
             New ( BUDVAL[x] );
        End;

  End;

  Procedure DisposeMemory;
  Var
     x : Integer;
  Begin

    Dispose ( GROUPBUD );
    Dispose ( TOTENTINC );
    Dispose ( TOTENTEXP );
    Dispose ( TOTINCOME );
    Dispose ( TOTEXPEND );
    Dispose ( TOTOVERHD );
    Dispose ( GROSSPROFIT );
    Dispose ( NETPROFIT );

    Dispose ( TOTOTHER );
    Dispose ( TOTBANK );
    Dispose ( GROUPNO );
    Dispose ( RECGROUP );
    For x := 1 To 3 Do
        Begin
             Dispose ( ACTVAL[x] );
             Dispose ( BUDVAL[x] );
        End;
  End;


  PROCEDURE CREPORTRUN;
  VAR

    ACC	    : INTEGER;
    CAT	    : INTEGER;
    GRP	    : INTEGER;
   { WORKSTR : STRING;}
    MIN	    : INTEGER;
    MAX	    : INTEGER;
    FOUND   : BOOLEAN;
  BEGIN

     Min := 0;
     Max := 0;

    {
    IF ACT IN [4,5,6]
      THEN BETASCREEN (SUBSYS)
      ELSE BETACLEAR;
    }
    HEADING:=NULL;
    CASE ACT OF
      1	 : HEADING:='ACTUAL CASHFLOW TO DATE';
      2	 : HEADING:='ACTUAL CASHFLOW COMPARED WITH BUDGET (THIS MONTH ' + MonthName[Month] + ')';
      3	 : HEADING:='ACTUAL CASHFLOW COMPARED WITH BUDGET (THIS YEAR)';
      4	 : HEADING:= CONCAT(Cash2.XENTUPPER,' GROSS MARGIN SUMMARY');
      5	 : If Cash11.xuse_enterprise Then
	      HEADING := 'EXPENDITURE REPORT ' + UPPERCASE(CashFlowReportsForm.Caption)
	   Else
	      HEADING := UPPERCASE(CashFlowReportsForm.Caption);
      6	 : HEADING:='SUMMARISED BUSINESS TRADING REPORT';
      {
      7	 : HEADING:='DETAILED BUSINESS TRADING REPORT';
      }
      7	 : HEADING:='ACTUAL CASHFLOW TO DATE';
     21	 : HEADING:='PRINT THIS YEARS MONTHLY BUDGET';
     22	 : HEADING:='PRINT LAST YEARS MONTHLY BALANCES';
     24	 : HEADING:='PROFIT & LOSS ACCOUNT';
    END;
    {
    BETATITLE (HEADING);
    NEXTLINE:=6;
    DIS (27,NEXTLINE,'Report Date: ');
    SCRIN := XDATE;

    REPEAT
      recdat ( 40, nextline, scrin, temp_date, 0,0,0,0,0,0 );
      if esckey then exit ( creportrun );
      error_date ( report, go_on );
    until NOT CHECK_DATE ( SCRIN, DEFAULT_DATE );
    XDATE := SCRIN;

    CLEARFROM ( 24 );

    NEXTLINE := NEXTLINE+2;
    DAYTOT:=DAYTOT-32000;

    DATA_DEST ( NEXTLINE, WORKSTR );

    IF ESCKEY THEN
       EXIT(CREPORTRUN);

    NEXTLINE := NEXTLINE + 2;
    WHERETO := WORKSTR[1];

    IF (ACT IN [4,5,6]) AND (OPT=1) THEN
      BEGIN
	DIS (5,NEXTLINE,'Show Monthly/Annual Budgets (Y/N): ');
	askyes ( 40, nextline, showannual, 0 );
	NEXTLINE:=NEXTLINE+2;
      END;
    }

    {* detailed business report limited by report group *}
    (*
    If ( opt = 4 ) Or ( act = 1 ) {In [1,4,5,6]} then
      Begin
	If ( xfinmonth=xmonthno ) Then
	   scrin[1] := 'T'
	Else
	   scrin[1] := 'P';
	Dis ( 1, nextline, 'Period Summaries / Transactions (P/T):');
	Repeat
	  no_func_key;
	  Rec ( 40, NEXTLINE, 1, scrin, 281, 0, 0, 0, 0, 0 );
	  If esckey Then Exit ( CREPORTRUN );
	Until SCRIN[1] In ['P','T','p','t'];
	use_tx := (SCRIN[1] IN ['T','t']);
	NEXTLINE := NEXTLINE+2;
      End;
    *)
    (*
    MAXMONTH:=12;
    If NOT use_tx Then
      Begin
	IF  (ACT IN [4,5,6]) AND (OPT IN [5  ])	 THEN MAXMONTH:=12;
	IF  (ACT IN [1,2,3,7]) OR ((ACT IN [4,5,6]) AND (OPT IN [3,4])) OR
	    ((ACT IN [4,5,6]) AND (OPT IN [1  ]) {AND (SHOWANNUAL)} ) Then
	  BEGIN
	    month := xmonthno;
	    DIS (17,NEXTLINE,'Calendar Month Number: ');
	    STR (XMONTHNO,WORKSTR);
	    askint ( 40, nextline, 2, 1, 12, month, 0 );
	    If esckey Then Exit ( creportrun );
	    {
	    XMONTHNO:=MONTH;
	    DEFWRITE (FALSE);
	    MAXMONTH:=XMONTHNO-XFINMONTH+1;
	    }
	    MAXMONTH:=MONTH-XFINMONTH+1;
	    IF MAXMONTH<1 THEN MAXMONTH:=MAXMONTH+12;
	    NEXTLINE:=NEXTLINE+2;
	  END;
      End;
    *)
    (*
    if act = 1{7} then	 detailed business report limited by report group
      Begin
	Repeat
	  dis (21 ,nextline,'From Report Group: ');
	  dis (23 ,nextline+1,'To Report Group: ');
	  str ( from_grp, workstr );

	  Repeat
	    rec ( 40, nextline, 3, workstr, 0, 40, 40, 1, -1, all_rep_grp );
	    If esckey Then exit ( creportrun );
	    If numeric ( scrint ) Then
	      intval ( from_grp, scrint );
	  Until ( from_grp in [0..999] );
	  str ( to_grp, workstr );
	  Repeat
	    rec ( 40, nextline+1, 3, workstr, 0, 40, 40, 1, -1, all_rep_grp );
	    If esckey Then exit ( creportrun );
	    If numeric ( scrint ) Then
	      intval ( to_grp, scrint );
	  Until ( to_grp in [from_grp..999] );

	  {
	  askint (40, NEXTLINE, 3, 1, 999, from_grp, 0);
	  IF ESCKEY THEN EXIT(CREPORTRUN);
	  askint (40, NEXTLINE+1, 3, 1, 999, to_grp, 0);
	  IF ESCKEY THEN EXIT(CREPORTRUN);
	  }
	  nextline := nextline + 2;
	Until from_grp <= to_grp;
      End;
    *)

    IF ACT IN [1,2,3,21,22,23,24,7] THEN
      BEGIN
	FOR CAT:=1 TO 4 DO
	  BEGIN
	    MAXGROUP[CAT]:=0;
	    FOR ACC:=1 TO 999 DO
	      BEGIN
		GROUPNO ^[CAT][ACC]:=-1;
		RECGROUP^[CAT][ACC]:=-1;
	      END;
	  END;
	{
        CLEARFROM (24);
	DIS (1,24,'READING REPORT GROUPS ...');
	}
        FOR CAT:=1 TO 4 DO
	  BEGIN
	    CASE CAT OF
	      1 : BEGIN
		    MIN:=Cash1.XNOMINCFROM;
		    MAX:=Cash1.XNOMINCTO;
		  END;
	      2 : BEGIN
		    MIN:=Cash1.XNOMNONFROM;
		    MAX:=Cash1.XNOMNONTO;
		  END;
	      3 : BEGIN
		    MIN:=Cash1.XNOMEXPFROM;
		    MAX:=Cash1.XNOMEXPTO;
		  END;
	      4 : BEGIN
		    MIN:=Cash1.XNOMOHFROM;
		    MAX:=Cash1.XNOMOHTO;
		  END;
	    END;

	    FOR ACC:=MIN TO MAX DO
	      BEGIN
		READREC (NlFile,ACC);
		IF ERRORNO>0 THEN ERR;
		IF RECACTIVE (NlFile) THEN
		  BEGIN
		    GETITEM (NlFile,5);

			(* tests REP-GROUP is within the specified range *)
		    If ( Currint >= from_grp ) And
                       ( Currint <= to_grp ) then
		      Begin
			RECGROUP^[CAT][ACC-MIN+1]:=CURRINT;
			FOUND:=FALSE;
			FOR GRP:=1 TO MAXGROUP[CAT] DO
			  IF GROUPNO^[CAT][GRP]=CURRINT THEN FOUND:=TRUE;
			IF NOT FOUND THEN
			  BEGIN
			    MAXGROUP[CAT]:=MAXGROUP[CAT]+1;
			    GROUPNO^[CAT][MAXGROUP[CAT]]:=CURRINT;
			  END;
		      End;
		  END;
	      END;
	  END;
      END;

    If act = 5 Then
       Begin
	  {
          If xuse_enterprise Then
	     Begin
		scrin[1] := 'Y';
		Dis ( 11, nextline, 'Include Income Report (Y/N):');
	     End
	  Else
	     Begin
		scrin[1] := 'N';
		Dis ( 40-(27+length(xentlower)), nextline, Concat('Include Non-',xentlower,' Income (Y/N):'));
	     End;
	  Repeat
	     no_func_key;
	     Rec ( 40, NEXTLINE, 1, scrin, 0, 0, 0, 0, 0, 0 );
	     If esckey Then Exit ( CREPORTRUN );
	  Until SCRIN[1] In ['Y','N','y','n'];
	  print_nonincome := (SCRIN[1] IN ['Y','y']);
          }
       End;

    VERYFIRST := TRUE;
    NUMBERONE := TRUE;
    If Device[1] = 'F' Then
      Begin
	{
        If STARTPRINT (0) Then;
        }
	{
        If ( WHERETO = 'P' ) And ( ACT <> 24 ) Then
	  Begin
	    For X := 1 TO 9 Do
	       If PLINEASCII[1][X]<>0 Then
		  WRITE(PRINTFILE,CHR(PLINEASCII[1][X]));
	  End
	Else
	  Begin
	    If WHERETO = 'P' Then
	       For X := 1 TO 9 Do
		  If PLINEASCII[2][X]<>0 Then
		     WRITE(PRINTFILE,CHR(PLINEASCII[2][X]));
	  End;
        }
      End;
    TOTRECS:=0;
    PAGENO :=0;
    NAME[ 1]:='JAN';
    NAME[ 2]:='FEB';
    NAME[ 3]:='MAR';
    NAME[ 4]:='APR';
    NAME[ 5]:='MAY';
    NAME[ 6]:='JUN';
    NAME[ 7]:='JUL';
    NAME[ 8]:='AUG';
    NAME[ 9]:='SEP';
    NAME[10]:='OCT';
    NAME[11]:='NOV';
    NAME[12]:='DEC';

  END;

  PROCEDURE CREPHEADINGS;
  VAR
    X,Y	    : INTEGER;
    MONTH   : INTEGER;
    WORKSTR : STRING;
    ST	    : STRING;

  BEGIN
      If Device = 'P' Then
         Printer.Canvas.Font.Style := [fsBold];
      If NOT VeryFirst Then
         If ( Device[1] = 'P' ) Then
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
      IF ACT IN [21,22,23,24] THEN
         BEGIN
              workstr := '';
	      If ( act = 24 ) Then
	         BUILDLINE ( 0, 'PROFIT & LOSS ACCOUNT' )
              Else
	          Begin
		       BUILDLINE(0,'BUDGET & BALANCE REPORT-');
		       STR(ACT-16,WORKSTR);
                  End;
         END
      ELSE
          BEGIN
               BUILDLINE(0,'MANAGEMENT REPORTS-');
	       if act = 7 then
	          str ( 1, workstr )
               else
	           STR ( ACT, WORKSTR );
	  END;
      BUILDLINE(0,WORKSTR);
      BUILDLINE(0,'	  ');
      If ( act <> 24 ) Then
         BUILDLINE(0,HEADING);
      IF ACT IN [4,5,6] THEN
         BEGIN
              STR(OPT,WORKSTR);
	      BUILDLINE(0,CONCAT(' (',WORKSTR,')'));
         END;
      buildline ( page_width-30{28}, curr_time );

      BUILDLINE(page_width-21,SPACE1);
      BUILDLINE(page_width-20,Cash1.XDATE);
      BUILDLINE(page_width-20,REPXDATE);
      BUILDLINE(page_width-10,'PAGE ');
      STR(PAGENO,WORKSTR);
      BUILDLINE(0,WORKSTR);
      OUTPUTLINE;
      BLANKLINE;
      OUTPUTLINE;
      BUILDLINE(1,SYSNAME);
      buildline ( page_width-length(verno), verno );

      OUTPUTLINE;
      BLANKLINE;

    RepDash;
    BLANKLINE;
    CASE ACT OF
      1,3,21,22,23,7 : BEGIN
			 BUILDLINE (1,'MONTH');
			 FOR X:=1 TO 12 DO
			   BEGIN
			     MONTH:=Cash1.XFINMONTH+X-1;
			     IF MONTH>12 THEN MONTH:=MONTH-12;
			     BUILDLINE (23+(X*8),NAME[MONTH]);
			   END;
			 BUILDLINE (127,'TOTAL');
		       END;
      2		     : BEGIN
			 BUILDLINE ( 50,'BUDGET');
			 BUILDLINE ( 74,'ACTUAL');
			 BUILDLINE ( 96,'VARIANCE');
		       END;
      4,5,6	     : BEGIN
			 CASE ACT OF
			   4 : BUILDLINE ( 1, Cash2.XENTUPPER);
			   5 : BUILDLINE ( 1,'NOMINAL');
			   6 : BUILDLINE ( 1,'CATEGORY');
			 END;
			 CASE OPT OF
			   1   : BEGIN
				   BUILDLINE (49,'THIS-YEAR   THIS-PERIOD');
				   IF SHOWANNUAL THEN
				     BEGIN
				       BUILDLINE ( 77,'Period:  Budget  Variance');
				       BUILDLINE (105,'Year:  Budget   Variance');
				     END;
				 END;
			   2   : BEGIN
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
				   BUILDLINE ( 43,'This Period:Actual'); 
				   //BUILDLINE ( 43,'THIS-PD-ACT');
				   BUILDLINE ( 63,'Last');
				   BUILDLINE ( 69,'Budget');
				   BUILDLINE ( 82,'YearToDate:This Year');
				   BUILDLINE ( 104,'Last Year');
				   BUILDLINE (115,'Budget');
				   BUILDLINE (123,'ANNUAL-BUD');
				 END;
			   4,5 : BEGIN
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
					 8 : BUILDLINE (38+(X*7),'AUG');
					 9 : BUILDLINE (38+(X*7),'SEP');
					10 : BUILDLINE (38+(X*7),'OCT');
					11 : BUILDLINE (38+(X*7),'NOV');
					12 : BUILDLINE (38+(X*7),'DEC');
				       END;
				     END;
				 END;
			 END;
		       END;
      24	     : BEGIN
			 str ( Cash1.xfinyear, st );
			 BUILDLINE ( 54{55}, st );
			 str ( Cash1.xfinyear-1, st );
			 BUILDLINE ( 70{72}, st );
		       END;

    END;
    OUTPUTLINE;
    RepDash;
    SKIPLINES(1);
    If Device = 'P' Then
       Printer.Canvas.Font.Style := [];

  END;

  PROCEDURE CPRINTTOTS (TITLE: STRING; TOTAL: YEARVAL; DASH: BOOLEAN);
  VAR
    X  : INTEGER;
    ST : ShortSTRING;
    origLinesPerPage : Integer;
  BEGIN
       origLinesPerPage := RFarmGate.PlinesPage[1];
       RFarmGate.PlinesPage[1] := 70;  // TGM AB Changed from 95
       if act = 24 then RFarmGate.PlinesPage[1] := 105; // tgm 06/06/02 - this sets page length to 95 for profit/loss
    If ( act = 24 ) And ( LINECOUNT+5 > RFarmGate.PLINESPAGE[1] ) THEN
      CREPHEADINGS
    Else
      IF LINECOUNT+8>RFarmGate.PLINESPAGE[1] THEN
         CREPHEADINGS;
     RFarmGate.PlinesPage[1] := origLinesPerPage;

    IF DASH THEN
      BEGIN
	BLANKLINE;
	OUTPUTLINE;
	RepDash;
      END;
    BLANKLINE;
    If ( act = 24 ) Then
      BUILDLINE ( 4, TITLE )
    Else
      BUILDLINE ( 1, TITLE );

    IF ACT=2 THEN
      BEGIN
	FOR X:=1 TO 3 DO
	  IF (TOTAL[X]<>0) OR (NOT Cash2.XBLANK) THEN
	    BEGIN
	      DoubleToStr ( Total[x], St, '%8.0f', True, True, 8, True );
	      BUILDLINE (25+(X*24),COPY(ST,2,8));
	    END;
      END
    ELSE
      If act = 24 Then
	 Begin
	    DoubleToStr ( Total[1], st, '%10.0f', True, True, 10, True );
            buildline ( 48, st );
	    DoubleToStr ( Total[2], st, '%10.0f', True, True, 10, True );
            buildline ( 64, st );
	 End
      Else
	 BEGIN
	   FOR X:=1 TO 12 DO
	     IF (TOTAL[X]<>0) OR (NOT Cash2.XBLANK) THEN
	       BEGIN
                 DoubleToStr ( Total[x], st, '%8.0f', True, True, 8, True );
                 BUILDLINE (19+(X*8),COPY(ST,2,8));
	       END;
	   IF (TOTAL[13]<>0) OR (NOT Cash2.XBLANK) THEN
	     BEGIN
               DoubleToStr ( Total[13], st, '%8.0f', True, True, 8, True );
               BUILDLINE (124,ST);
	     END;
	 END;
    OUTPUTLINE;
    IF DASH THEN
      BEGIN
	RepDash;
	BLANKLINE;
	OUTPUTLINE;
      END;
  END;

  PROCEDURE TOTALRECS (GROUP: YEARVAL; VAR TOTAL: YEARVAL; ADD: BOOLEAN);
  VAR
    X  : INTEGER;

  BEGIN
    FOR X:=1 TO 13 DO
      BEGIN

	{
        IF GROUP[X]<0 THEN HALF:=-50 ELSE HALF:=50;
	GROUP[X]:=((GROUP[X]+HALF) DIV 100) * 100;
        }

	IF ADD THEN
	  TOTAL[X]:=TOTAL[X]+GROUP[X]
	ELSE
	  TOTAL[X]:=TOTAL[X]-GROUP[X];

      END;
  END;

  PROCEDURE ERR;
  BEGIN
    DisposeMemory;
    AbortProgram ('Error in CashFlow Reports');
  END;

  PROCEDURE BUILDLINE;
  BEGIN
    IF COL=0 THEN COL:=NEXTCOL;
    IF STRVAL='' THEN EXIT;
    IF COL+LENGTH(STRVAL)-1 IN [1..132] { 255 } THEN
      MOVE(STRVAL[1],PrintLine[COL],LENGTH(STRVAL));
    NEXTCOL:=COL+LENGTH(STRVAL);
    IF NEXTCOL>COLHIGH THEN COLHIGH:=NEXTCOL;
  END;

  PROCEDURE OUTPUTLINE;
  VAR
    X : INTEGER;
  BEGIN
    (*
    IF WHERETO = 'S' THEN
      BEGIN
	IF LINECOUNT>20 THEN
	  BEGIN
	    DIS ( 1,24,'PRESS ENTER FOR MORE DETAILS');
	    no_func_key;
	    REC (31,24,0,NULL,0,0,0,0,0,0);
	    IF ESCKEY THEN EXIT(CASHFLOW);
	    CLEARFROM (6);
	    BETALINE;
	    IF ACT IN [5,6]
	      THEN LINECOUNT:=7
	      ELSE LINECOUNT:=6;
	  END;
	DIS (1,LINECOUNT,COPY(PrintLine,1,80));
	LINECOUNT:=LINECOUNT+1;
	EXIT(OUTPUTLINE);
      END;
    *)

    X := COLHIGH;
    IF X > page_width THEN
      X := page_width;
    IF X < 1 THEN
      X := 1;

    SENDLINE (COPY(PrintLine,1,X));
    IF ESCKEY THEN EXIT;
    LINECOUNT := LINECOUNT + 1;
    COLHIGH := 1;
    NEXTCOL := 1;
  END;

  PROCEDURE SKIPSCREEN;
  BEGIN
    LINECOUNT:=LINECOUNT+LINES;
  END;

  PROCEDURE BLANKLINE;
  VAR
    X : INTEGER;
  BEGIN
     PrintLine:=NULL;
     FOR X:=1 TO 3 DO PrintLine:=CONCAT(PrintLine,SPACE40);
     PrintLine:=CONCAT(PrintLine,COPY(SPACE40,1,12));
     COLHIGH:=1;
  END;

  PROCEDURE PROCESSGROUP;
  VAR
    tx_totals : listcols;
    ST	    : STRING;
    X,
    CAT	    : INTEGER;
    GRP	    : INTEGER;
    ACC	    : INTEGER;
    MTH	    : INTEGER;
    ABSMTH  : INTEGER;
    OFFSET  : INTEGER;
    TABSTR  : ShortSTRING;
    CURRBAL : LONG;
  BEGIN
    OffSet := 0;

    SETDB(DBNO);
    For MTH := 1 To 13 Do
      Begin
	 TOTINCOME^[MTH]	   := 0;
	 TOTEXPEND^[MTH]	   := 0;
	 TOTOVERHD^[MTH]	   := 0;
	 GROSSPROFIT^[MTH]  := 0;
	 NETPROFIT^[MTH]	   := 0;
      End;

    FOR CAT:=1 TO  4 DO
      BEGIN
	IF ( act <> 24 ) And (ACT<>2) AND (CAT IN [1,3]) THEN
	  BEGIN
	    (*
	    IF (WHERETO = 'S') AND (CAT=3) THEN LINECOUNT:=99;
	    *)
	    BLANKLINE;
	    IF (ACT=21) OR ((ACT IN [3,23]) AND (PASS=2))
	      THEN ST:='BUDGETED'
	      ELSE ST:='ACTUAL';
	    CASE CAT OF
	       1 : BUILDLINE (1,CONCAT('TOTAL ',ST,' MONTHLY INCOME'));
	       3 : BUILDLINE (1,CONCAT('TOTAL ',ST,' MONTHLY EXPENDITURE'));
	    END;
	    IF (ACT=21) OR ((ACT IN [3,23]) AND (PASS=2)) THEN
	      IF (CAT=1) AND (Cash1.XCOPYBAL) THEN
		BUILDLINE (55,'Budgeted Values set to Actual Values at Period End');
	    OUTPUTLINE;
	    BLANKLINE;
	    OUTPUTLINE;
	  END
	Else
	  If ( act = 24 ) And ( cat In [1,3,4] ) Then
	    Begin
	      BLANKLINE;
	      Case cat Of
		  1 : buildline ( 1, 'SALES' );
		  3 : buildline ( 1, 'COST OF SALES' );
		  4 : buildline ( 1, 'GENERAL EXPENSES' );
	      End;
	      OUTPUTLINE;
	      BLANKLINE;
	      OUTPUTLINE;
	    End;

	FOR GRP := 1 TO MAXGROUP[CAT] DO
	  BEGIN
	    FOR MTH := 1 TO 13	DO
	       GROUPBUD^[MTH]:=0;
	    FOR ACC:=1 TO 999 DO
	      IF RECGROUP^[CAT][ACC] = GROUPNO^[CAT][GRP] THEN
		BEGIN
		  CASE CAT OF
		    1 : OFFSET:=Cash1.XNOMINCFROM;
		    2 : OFFSET:=Cash1.XNOMNONFROM;
		    3 : OFFSET:=Cash1.XNOMEXPFROM;
		    4 : OFFSET:=Cash1.XNOMOHFROM;
		  END;
		  READREC (NlFile,OFFSET+ACC-1);
		  if ERRORNO>0 then ERR;
		  if ACT=2 then
		    begin
                      GETITEM (NlFile,32+MONTH);
                      IF CAT IN [1,2] THEN CURRLONG:=0-CURRLONG;
                         GROUPBUD^[1]:=GROUPBUD^[1]+CURRLONG;
		      if NOT ( Use_Tx ) then
                         begin
                            GETITEM (NlFile,2);
                            CURRBAL:=CURRLONG;
                            if (MONTH=Cash1.XMONTHNO) OR (NOT Cash1.XNOMTHIS) THEN
                               begin
                                 GETITEM (NlFile,3);
			         CURRLONG:=CURRBAL-CURRLONG;
                               end
                            else
                               GETITEM (NlFile,48+MONTH);
                            if CAT in [1,2] then CURRLONG:=0-CURRLONG;
                            GROUPBUD^[2]:=GROUPBUD^[2]+CURRLONG;
                         end
                      else  // Added by MC 22/02/2000
                         begin
                            total_tx_for_nom ( Nlfile, offset+acc-1, 0,
                                             ( offset < Cash1.xnomexpfrom ), tx_totals );
                            CURRLONG := Round(tx_totals[Month]);
                            // if CAT in [1,2] then CURRLONG:=0-CURRLONG;
                            GROUPBUD^[2]:=GROUPBUD^[2]+CURRLONG;
		         end;
		    end
		  else
                    // changed 22/02/2000 MC
		    // If use_tx And ( Act = 1 ) Then
		    if use_tx And (( Act = 1 ) or (( Act = 3 ) And (Pass = 1 ))) Then
		       begin
			  total_tx_for_nom ( Nlfile, offset+acc-1, 0,
				       ( offset < Cash1.xnomexpfrom ), tx_totals );
			  for mth := 1 to 12 do
			     begin
				ABSMTH := Cash1.XFINMONTH+MTH-1;
				If ABSMTH > 12 Then ABSMTH := ABSMTH-12;
				GROUPBUD^[MTH]:=GROUPBUD^[MTH]+tx_totals[absmth];
				GROUPBUD^[13] :=GROUPBUD^[13] +tx_totals[absmth];
			     end;
		       end
		    else
		       If act = 24 Then
			  Begin
			     {* get the account balance so far }
			     getitem ( NlFile, 2 );	{ get the account balance }
			     If CAT In [1,2] Then CURRLONG := 0-CURRLONG;
			     groupbud^[1] := groupbud^[1] + currlong;

			     {* get the account balance last year }
			     getitem ( NlFile, 17 );
			     If CAT In [1,2] Then CURRLONG := 0-CURRLONG;
			     groupbud^[2] := groupbud^[2] + currlong;
			  End
		       Else
			  Begin
			     FOR MTH:=1 TO 12 DO
			       BEGIN
				 ABSMTH:=Cash1.XFINMONTH+MTH-1;
				 IF ABSMTH>12 THEN ABSMTH:=ABSMTH-12;

				 IF  ( MTH < MAXMONTH ) OR
				    (( ACT = 3 ) AND ( PASS = 2 )) OR
				     ( ACT IN [21,22,23] ) THEN
				   BEGIN
				     IF	 (ACT= 1)
				     OR	 (ACT= 7)
				     OR ((ACT= 3) AND (PASS=1)) THEN GETITEM(NlFile,48+ABSMTH);
				     IF	 (ACT=21)
				     OR ((ACT=23) AND (PASS=2))
				     OR ((ACT= 3) AND (PASS=2)) THEN GETITEM(NlFile,32+ABSMTH);
				     IF	 (ACT=22)
				     OR ((ACT=23) AND (PASS=1)) THEN GETITEM(NlFile,64+ABSMTH);
				     IF CAT IN [1,2] THEN CURRLONG:=0-CURRLONG;
				     GROUPBUD^[MTH]:=GROUPBUD^[MTH]+CURRLONG;
				     GROUPBUD^[13] :=GROUPBUD^[13] +CURRLONG;
				   END
				 ELSE
				   IF MTH=MAXMONTH THEN
				     BEGIN
				       GETITEM (Nlfile,2);
				       CURRBAL:=CURRLONG;
				       IF (MONTH=Cash1.XMONTHNO) OR (NOT Cash1.XNOMTHIS) THEN
					 BEGIN
					   GETITEM (NlFile,3);
					   CURRLONG:=CURRBAL-CURRLONG;
					 END
				       ELSE
					 GETITEM (NlFile,48+MONTH);
				       IF CAT IN [1,2] THEN CURRLONG:=0-CURRLONG;
				       GROUPBUD^[MTH]:=GROUPBUD^[MTH]+CURRLONG;
				       GROUPBUD^[13] :=GROUPBUD^[13] +CURRLONG;
				     END;
			       END;
			  End;
		END;

	    FOR MTH:=1 TO 13 DO
	      BEGIN
		{IF GROUPBUD[MTH]<0 THEN HALF:=-50 ELSE HALF:=50;
		GROUPBUD[MTH]:=((GROUPBUD[MTH]+HALF) DIV 100)*100;}
	      END;
	    IF ACT=2 THEN
	      GROUPBUD^[3]:=GROUPBUD^[1]-GROUPBUD^[2];
	    IF GROUPNO^[CAT][GRP] > 0 THEN
	      READTABLES (NlFile,GROUPNO^[CAT][GRP],TABSTR)
	    ELSE
	      TABSTR:='GROUP UNDEFINED';
	    CPRINTTOTS (TABSTR,GROUPBUD^,FALSE);
	    CASE CAT OF
	      1,2 : TOTALRECS (GROUPBUD^,TOTINCOME^,TRUE);
	      3,4 : Begin
		      If ( act = 24 ) And ( cat = 4 ) Then
			TOTALRECS (GROUPBUD^,TOTOVERHD^,TRUE)
		      Else
			TOTALRECS (GROUPBUD^,TOTEXPEND^,TRUE);
		    End;
	    END;
	  END;

	If ( act = 24 ) Then
	  CASE CAT OF
	    2 : CPRINTTOTS ('TOTAL INCOME',	TOTINCOME^,TRUE);
	    3 : Begin
		  CPRINTTOTS ('TOTAL EXPENDITURE',TOTEXPEND^,TRUE);
		  For X := 1 to 2 Do
		     GROSSPROFIT^[x] := ( totincome^[x]-totexpend^[x] );
		  CPRINTTOTS ('GROSS PROFIT',GROSSPROFIT^,TRUE);
		End;
	    4 : Begin
		  CPRINTTOTS ('TOTAL OVERHEADS',TOTOVERHD^,TRUE);
		  For x := 1 To 2 Do
		     NETPROFIT^[x] := ( GROSSPROFIT^[x]-TOTOVERHD^[x] );
		  CPRINTTOTS ('NET PROFIT',NETPROFIT^,TRUE);
		End;
	  END
	Else
	  CASE CAT OF
	    2 : begin
                   CPRINTTOTS ('TOTAL INCOME',	TOTINCOME^,TRUE);
                   if NewPageAfterIncExp then
                      CREPHEADINGS;
                end;
	    4 : begin
                   CPRINTTOTS ('TOTAL EXPENDITURE',TOTEXPEND^,TRUE);
                   if NewPageAfterIncExp then
                      CREPHEADINGS;
                end;
	  END;

	IF ACT IN [3,23] THEN
	  CASE PASS OF
	    1 : CASE CAT OF
		  2 : FOR MTH:=1 TO 13 DO ACTVAL[1]^[MTH]:=TOTINCOME^[MTH];
		  4 : FOR MTH:=1 TO 13 DO ACTVAL[2]^[MTH]:=TOTEXPEND^[MTH];
		END;
	    2 : CASE CAT OF
		  2 : FOR MTH:=1 TO 13 DO BUDVAL[1]^[MTH]:=TOTINCOME^[MTH];
		  4 : FOR MTH:=1 TO 13 DO BUDVAL[2]^[MTH]:=TOTEXPEND^[MTH];
		END;
	  END;
      END;
  END;

  PROCEDURE PROCESSOTHER;
  VAR
    StoreIncPrv,
    StoreExpPrv : YEARVAL;
    StorePL	: YEARVAL;
    CAT	    : INTEGER;
    GRP	    : INTEGER;
    ACC	    : INTEGER;
    MTH	    : INTEGER;
    ABSMTH  : INTEGER;
    MIN	    : INTEGER;
    MAX	    : INTEGER;
    OFFSET  : INTEGER;
    WORKSTR : ShortSTRING;
    CURRBAL : LONG;
    partner : packed array [1..10] of YEARVAL{packed array [1..13] of Double}{long};
    counter,
    no_partner : integer;
    tx_totals : listcols;
    truth_flag : Boolean;

  BEGIN
    Min := 0;
    Max := 0;

    truth_flag := true;
    For MTH := 1 To 13 Do
      Begin
	 TOTOTHER^[MTH]:=TOTINCOME^[MTH]-TOTEXPEND^[MTH];
	 StoreIncPrv[mth] := 0;
	 StoreExpPrv[mth] := 0;
      End;

    CPRINTTOTS ('PROFIT (-LOSS)',TOTOTHER^,TRUE);
    StorePL := TotOther^;

    IF ACT=7 THEN EXIT;
    SETDB(DBNO);
    OPENBAL  :=0;
    NETWORTH :=0;
    IF ACT<>2 THEN
      BEGIN
	BLANKLINE;
	IF (ACT=21) OR ((ACT IN [3,23]) AND (PASS=2))
	  THEN BUILDLINE (1,'TOTAL BUDGETED MONTHLY MOVEMENTS')
	  ELSE BUILDLINE (1,'TOTAL ACTUAL MONTHLY MOVEMENTS');
	OUTPUTLINE;
	BLANKLINE;
	OUTPUTLINE;
      END;
    FOR MTH:=1 TO 13 DO TOTOTHER^[MTH]:=0;
    FOR CAT:=1 TO 10 DO
      BEGIN
	IF CAT<>10 THEN FOR MTH:=1 TO 13 DO GROUPBUD^[MTH]:=0;
	If cat In [1,2] Then
	  For no_partner := 1 to 10 Do
	    For mth := 1 To 13 Do
	      partner[no_partner,mth] := 0;

	CASE CAT OF
	  1 : BEGIN
		MIN:=Cash1.XNOMPRVINC;
		MAX:=Cash1.XNOMPRVINC+Cash11.xno_of_partners;
		truth_flag := false;
	      END;
	  2 : BEGIN
		MIN:=Cash1.XNOMPRVEXP;
		MAX:=Cash1.XNOMPRVEXP+Cash11.xno_of_partners;
		truth_flag := true;
	      END;
	  3 : BEGIN
		MIN:=Cash1.XNOMCAFROM;
		MAX:=Cash1.XNOMCATO;
		truth_flag := false;
	      END;
	  4 : BEGIN
		MIN:=Cash1.XNOMFAFROM;
		MAX:=Cash1.XNOMFATO;
		truth_flag := false;
	      END;
	  5 : BEGIN
		MIN:=Cash1.XNOMLIFROM;
		MAX:=Cash1.XNOMLITO;
		truth_flag := true;
	      END;
	  6 : BEGIN
		MIN:=Cash1.XNOMDEBTOR;
		MAX:=Cash1.XNOMDEBTOR;
		truth_flag := false;
	      END;
	  7 : BEGIN
		MIN:=Cash1.XNOMCREDIT;
		MAX:=Cash1.XNOMCREDIT;
		truth_flag := true;
	      END;
	  8 : BEGIN
		MIN:=Cash1.XNOMTAX;
		MAX:=Cash1.XNOMTAX;
		truth_flag := true;
	      END;
	  9 : BEGIN
		MIN:=Cash1.XBANKMIN;
		MAX:=Cash1.XBANKMAX;
		truth_flag := false;
	      END;
	 10 : BEGIN
		MIN:=Cash1.XNOMOPEN;
		MAX:=Cash1.XNOMOPEN+Cash11.xno_of_partners;
		truth_flag := false;
	      END;
	END;
	FOR ACC:=MIN TO MAX DO
	  BEGIN
	    READREC (NlFile,ACC);
	    IF ERRORNO>0 THEN ERR;
	    IF RECACTIVE (NlFile) THEN
	      BEGIN
		IF CAT<>10 THEN
		  BEGIN
		    IF ACT=2 THEN
		      BEGIN
                        // Get the Budget figures
			GETITEM (NlFile,32+MONTH);
			IF CAT IN [2,5,7,8] THEN CURRLONG:=0-CURRLONG;
			GROUPBUD^[1]:=GROUPBUD^[1]+CURRLONG;
			case cat of
			  1 : partner[acc-Cash1.xnomprvinc+1,1] :=
				    partner[acc-Cash1.xnomprvinc+1,1]+currlong;
			  2 : partner[acc-Cash1.xnomprvexp+1,1] :=
				    partner[acc-Cash1.xnomprvexp+1,1]+currlong;
			end;

                        if NOT ( Use_Tx ) then
                           begin
                              // Get the Current Balance
                              GETITEM (NlFile,2);
                              CURRBAL:=CURRLONG;
                              IF (MONTH=Cash1.XMONTHNO) OR (NOT Cash1.XNOMTHIS) THEN
                                 BEGIN
                                    GETITEM (NlFile,3);
                                    CURRLONG:=CURRBAL-CURRLONG;
                                 END
                              ELSE
			         GETITEM (NlFile,48+MONTH);
                              IF CAT IN [2,5,7,8] THEN CURRLONG:=0-CURRLONG;
                                 GROUPBUD^[2]:=GROUPBUD^[2]+CURRLONG;
                           end
                        else  // Added by MC 22/02/2000
                           begin
                              total_tx_for_nom ( Nlfile, acc, 0,
                                               truth_flag, tx_totals );
                              CURRLONG := Round(tx_totals[Month]);
                              // IF CAT IN [2,5,7,8] THEN CURRLONG:=0-CURRLONG;
                                 GROUPBUD^[2]:=GROUPBUD^[2]+CURRLONG;
                           end;

			case cat of
			  1 : partner[acc-Cash1.xnomprvinc+1,2] :=
				    partner[acc-Cash1.xnomprvinc+1,2]+currlong;
			  2 : partner[acc-Cash1.xnomprvexp+1,2] :=
				    partner[acc-Cash1.xnomprvexp+1,2]+currlong;
			end;
		      end
		    else
		      If use_tx Then
			Begin
			  total_tx_for_nom ( NlFile, acc, 0, truth_flag, tx_totals );

			  For mth := 1 To 12 Do
			    Begin
			      ABSMTH:=Cash1.XFINMONTH+MTH-1;
			      IF ABSMTH>12 THEN ABSMTH:=ABSMTH-12;
			      GROUPBUD^[MTH]:=GROUPBUD^[MTH]+tx_totals[absmth];
			      GROUPBUD^[13] :=GROUPBUD^[13] +tx_totals[absmth];
			      Case cat Of
				  1 : Begin
					partner[acc-Cash1.xnomprvinc+1,mth] :=
					 partner[acc-Cash1.xnomprvinc+1,mth]+
					     tx_totals[absmth];
					partner[acc-Cash1.xnomprvinc+1,13] :=
					 partner[acc-Cash1.xnomprvinc+1,13]+
					     tx_totals[absmth];
				      End;
				  2 : Begin
					partner[acc-Cash1.xnomprvexp+1,mth] :=
					 partner[acc-Cash1.xnomprvexp+1,mth]+
					     tx_totals[absmth];
					partner[acc-Cash1.xnomprvexp+1,13] :=
					 partner[acc-Cash1.xnomprvexp+1,13]+
					     tx_totals[absmth];
				      End;
			      End;
			    End;
			End
		      Else
			FOR MTH:=1 TO 12 DO
			  BEGIN
			    ABSMTH:=Cash1.XFINMONTH+MTH-1;
			    IF ABSMTH>12 THEN ABSMTH:=ABSMTH-12;
			    IF	(MTH<MAXMONTH) Or
				((ACT=3) AND (PASS=2))
			    OR	(ACT IN [21,22,23]) THEN
			      BEGIN
				IF  (ACT= 1)
				OR ((ACT= 3) AND (PASS=1)) THEN GETITEM(NlFile,48+ABSMTH);
				IF  (ACT=21)
				OR ((ACT=23) AND (PASS=2))
				OR ((ACT= 3) AND (PASS=2)) THEN GETITEM(NlFile,32+ABSMTH);
				IF  (ACT=22)
				OR ((ACT=23) AND (PASS=1)) THEN GETITEM(NlFile,64+ABSMTH);
				IF CAT IN [2,5,7,8] THEN CURRLONG:=0-CURRLONG;
				GROUPBUD^[MTH]:=GROUPBUD^[MTH]+CURRLONG;
				GROUPBUD^[13] :=GROUPBUD^[13] +CURRLONG;

				Case cat Of
				  1 : Begin
					partner[acc-Cash1.xnomprvinc+1,mth] :=
					 partner[acc-Cash1.xnomprvinc+1,mth]+currlong;
					partner[acc-Cash1.xnomprvinc+1,13] :=
					 partner[acc-Cash1.xnomprvinc+1,13]+currlong;
				      End;
				  2 : Begin
					partner[acc-Cash1.xnomprvexp+1,mth] :=
					 partner[acc-Cash1.xnomprvexp+1,mth]+currlong;
					partner[acc-Cash1.xnomprvexp+1,13] :=
					 partner[acc-Cash1.xnomprvexp+1,13]+currlong;
				      End;
				End;
			      END
			    ELSE
			      IF MTH=MAXMONTH THEN
				BEGIN
				  GETITEM (NlFile,2);
				  CURRBAL:=CURRLONG;
				  IF (MONTH=Cash1.XMONTHNO) OR (NOT Cash1.XNOMTHIS) THEN
				    BEGIN
				      GETITEM (NlFile,3);
				      CURRLONG:=CURRBAL-CURRLONG;
				    END
				  ELSE
				    GETITEM (NlFile,48+MONTH);
				  IF CAT IN [2,5,7,8] THEN CURRLONG:=0-CURRLONG;
				  GROUPBUD^[MTH]:=GROUPBUD^[MTH]+CURRLONG;
				  GROUPBUD^[13] :=GROUPBUD^[13] +CURRLONG;
				  Case cat Of
				    1 : Begin
					  partner[acc-Cash1.xnomprvinc+1,mth] :=
					   partner[acc-Cash1.xnomprvinc+1,mth]+currlong;
					  partner[acc-Cash1.xnomprvinc+1,13] :=
					   partner[acc-Cash1.xnomprvinc+1,13]+currlong;
					End;
				    2 : Begin
					  partner[acc-Cash1.xnomprvexp+1,mth] :=
					   partner[acc-Cash1.xnomprvexp+1,mth]+currlong;
					  partner[acc-Cash1.xnomprvexp+1,13] :=
					   partner[acc-Cash1.xnomprvexp+1,13]+currlong;
					End;
				  End;
				END;
			  END;
		  END;
		IF CAT=9 THEN
		  BEGIN
		    GETITEM (NlFile,4);
		    OPENBAL:=OPENBAL+CURRLONG;
		  END;
		IF CAT=10 THEN
		  BEGIN
		    GETITEM (NlFile,4);
		    NETWORTH:=NETWORTH+CURRLONG;
		  END;
	      END;
	  END;
	IF CAT<>10 THEN
	  BEGIN
	    {
            FOR MTH:=1 TO 13 DO
	      BEGIN

                IF GROUPBUD[MTH]<0 THEN HALF:=-50 ELSE HALF:=50;
		GROUPBUD[MTH]:=((GROUPBUD[MTH]+HALF) DIV 100)*100;
                If cat In [1,2] Then
		  For no_partner := 1 to xno_of_partners+1 Do
		    Begin
		      if partner[no_partner, mth] < 0 Then
			half := -50
		      Else
			half := 50;
		      partner[no_partner, mth] :=
			(( partner[no_partner,mth]+half) div 100)*100;
		    End;
	      END;
	    }
            IF ACT=2 THEN
	      Begin
		GROUPBUD^[3]:=GROUPBUD^[1]-GROUPBUD^[2];
		If cat In [1,2] Then
		  for no_partner := 1 To Cash11.xno_of_partners+1 Do
		    partner[no_partner, 3] :=
		       partner[no_partner,1]-partner[no_partner,2];
	      End;
	  END;
	{
	IF CAT=9 THEN
	  IF ((ACT IN [3,23]) AND (PASS=2)) OR (ACT=21) THEN
	    FOR MTH:=1 TO 13 DO
	      GROUPBUD[MTH]:=TOTINCOME[MTH]-TOTEXPEND[MTH];
	}
	CASE CAT OF
	  1,3,4,6,9 : TOTALRECS (GROUPBUD^,TOTOTHER^,TRUE);
	  2,5,7,8   : TOTALRECS (GROUPBUD^,TOTOTHER^,FALSE);
	END;

	{
	IF CAT IN [1,3,4,6] THEN
	  FOR MTH:=1 TO 13 DO
	    GROUPBUD[MTH]:=0-GROUPBUD[MTH];
	}
	IF CAT IN [1,3,4,6] THEN
	  FOR MTH := 1 TO 13 DO
	    Begin
	      GROUPBUD^[MTH]:=0-GROUPBUD^[MTH];
	      If cat = 1 Then
		For no_partner := 1 To Cash11.xno_of_partners+1 Do
		  partner[no_partner, mth] := 0-partner[no_partner, mth];
	    End;

	CASE CAT OF
	  1 : Begin
		{CPRINTTOTS ('CHANGE IN PRIVATE INCOME !',   GROUPBUD,FALSE);}
		for no_partner := 1 to Cash11.xno_of_partners+1 Do
		  Begin
		     CPRINTTOTS ('CHANGE IN PRIVATE INCOME', partner[no_partner],FALSE);
		     For counter := 1 To 13 Do
			StoreIncPrv[counter] := partner[no_partner,counter]+
						StoreIncPrv[counter];
		  End;
	      End;
	  2 : Begin
		{CPRINTTOTS ('CHANGE IN PRIVATE EXPEND',   GROUPBUD,FALSE);}
		For no_partner := 1 To Cash11.xno_of_partners+1 Do
		  Begin
		    CPRINTTOTS ('CHANGE IN PRIVATE EXPEND', partner[no_partner],FALSE);
		    For counter := 1 To 13 Do
			StoreExpPrv[counter] := partner[no_partner,counter]+
						StoreExpPrv[counter];
		  End;
	      End;
	  3 : CPRINTTOTS ('CHANGE IN CURRENT ASSETS',	GROUPBUD^,FALSE);
	  4 : CPRINTTOTS ('CHANGE IN FIXED ASSETS',	GROUPBUD^,FALSE);
	  5 : CPRINTTOTS ('CHANGE IN LIABILITIES',	GROUPBUD^,FALSE);
	  6 : CPRINTTOTS ('CHANGE IN DEBTORS',		GROUPBUD^,FALSE);
	  7 : CPRINTTOTS ('CHANGE IN CREDITORS',	GROUPBUD^,FALSE);
	  8 : CPRINTTOTS (CONCAT('CHANGE IN ',Cash1.XTAXCODE),GROUPBUD^,FALSE);

	  {
	  9 : CPRINTTOTS ('NET MONTHLY CASHFLOW',	GROUPBUD,TRUE);
	  }
	  9 : Begin
		If ((ACT In [3,23]) And (PASS=2)) Or (ACT=21) Then
		  Begin
		     For counter := 1 To 13 Do
			GroupBud^[counter] := ( StorePL[counter] - TOTOTHER^[counter] +
					      GROUPBUD^[counter]);
		  End;
		CPRINTTOTS ('NET MONTHLY CASHFLOW', GROUPBUD^, TRUE);
	      End;
	END;
      END;
    (*
    IF WHERETO = 'S' THEN LINECOUNT:=99;
    *)
    BLANKLINE;
    IF ACT<>2 THEN
      BEGIN
	BUILDLINE (1,'YEAR OPENING BANK BALANCE');
	{
        IF OPENBAL<0 THEN HALF:=-50 ELSE HALF:=50;
	OPENBAL:=((OPENBAL+HALF) DIV 100)*100;
        }
        CurrDbl := OpenBal;
	IF (CurrDbl<>0) OR (NOT Cash2.XBLANK) THEN
	  BEGIN
            DoubleToStr ( CurrDbl, WorkStr, ('%8.0f'), True, True, 8, True );
	    {
            LONGSTR (OPENBAL,WORKSTR,'L');
	    DELETE (WORKSTR,9,3);
            BUILDLINE (27,COPY(WORKSTR,2,8));
            }
            BUILDLINE (26,WORKSTR);
	  END;
	OUTPUTLINE;
	FOR MTH:=1 TO 13 DO TOTBANK^[MTH]:=0;
	TOTBANK^[1]:=OPENBAL+GROUPBUD^[1];
	FOR MTH:=2 TO 12 DO
          // Changed 22/02/2000 MC
	  // Add Line "or (( act = 3 ) And ( use_tx ) And ( Pass = 1 ))"
	  IF  (MTH<=MAXMONTH) Or (( act = 1 ) And ( use_tx ))
          or (( act = 3 ) And ( use_tx ) And ( Pass = 1 ))
	  OR ((ACT=3) AND (PASS=2))
	  OR  (ACT IN [21,22,23]) THEN
	    TOTBANK^[MTH]:=TOTBANK^[MTH-1]+GROUPBUD^[MTH];
	CPRINTTOTS ('CUMULATIVE BANK BALANCE',TOTBANK^,FALSE);
	IF ACT IN [3,23] THEN
	  CASE PASS OF
	    1 : FOR MTH:=1 TO 13 DO ACTVAL[3]^[MTH]:=TotBank^[MTH];
	    2 : FOR MTH:=1 TO 13 DO BUDVAL[3]^[MTH]:=TotBank^[MTH];
	  END;

	If ((ACT In [3,23]) And (PASS=2)) Or (ACT=21) Then
	    For counter := 1 To 13 Do
	       TotOther^[counter] :=  StorePL[counter] +
				     StoreIncPrv[counter] +
				     StoreExpPrv[counter];

	CPRINTTOTS ('CHANGE IN NET WORTH',TOTOTHER^,TRUE);

	BLANKLINE;
	BUILDLINE (1,'YEAR OPENING NET WORTH');
	NETWORTH:=0-NETWORTH;
	{
        IF NETWORTH<0 THEN HALF:=-50 ELSE HALF:=50;
	NETWORTH:=((NETWORTH+HALF) DIV 100)*100;
	}
        CurrDbl := NetWorth;
        IF (CurrDbl<>0) OR (NOT Cash2.XBLANK) THEN
	  BEGIN
            DoubleToStr ( CurrDbl, WorkStr, '%8.0f', True, True, 8, False );
	    {
            LONGSTR (NETWORTH,WORKSTR,'L');
	    DELETE (WORKSTR,9,3);
	    BUILDLINE (27,COPY(WORKSTR,2,8));
	    }
            BUILDLINE (26,WORKSTR);
	  END;
	OUTPUTLINE;
	TOTOTHER^[1]:=NETWORTH+TOTOTHER^[1];
	FOR MTH:=2 TO 12 DO
          // 22/02/2000 MC
          // Add Line "or (( act = 3 ) And ( use_tx ) And ( Pass = 1 ))"
	  if  (MTH<=MAXMONTH) Or (( act = 1 ) And ( use_tx ))
          or (( act = 3 ) And ( use_tx ) And ( Pass = 1 ))
	  OR ((ACT=3) AND (PASS=2))
	  OR  (ACT IN [21,22,23]) THEN
	    TOTOTHER^[MTH]:=TOTOTHER^[MTH-1]+TOTOTHER^[MTH];
	TOTOTHER^[13]:=0;
	CPRINTTOTS ('CUMULATIVE NET WORTH',TOTOTHER^,FALSE);
	BLANKLINE;
	OUTPUTLINE;
	RepDash;
      END;
  END;

  PROCEDURE PRINTSUMM;
  VAR
    MTH : INTEGER;

    PROCEDURE KNOCKOFF (VAR VAL: YEARVAL; SUM: BOOLEAN);
    VAR
      TOT : Double{LONG};
      MTH : Integer;
    BEGIN
      IF MAXMONTH<12 THEN
	BEGIN
	  IF SUM THEN
	    BEGIN
	      TOT:=0;
	      FOR MTH:=1 TO MAXMONTH DO
		TOT:=TOT+VAL[MTH];
	      VAL[13]:=TOT;
	    END
	  ELSE
	    VAL[13]:=0;
	  FOR MTH:=MAXMONTH+1 TO 12 DO
	    VAL[MTH]:=0;
	END;
    END;

  BEGIN
    CREPHEADINGS;
    KNOCKOFF (BUDVAL[1]^,TRUE);
    CPRINTTOTS ('TOTAL INCOME (BUDGET) ',BUDVAL[1]^,FALSE);               // TGM AB 03/05/02 Removed all dots to fix problem with new report layout
    CPRINTTOTS ('TOTAL INCOME (ACTUAL) ',ACTVAL[1]^,FALSE);               // TGM AB chnaged from TOTAL INCOME    BUDGET
    FOR MTH:=1 TO 13 DO BUDVAL[1]^[MTH]:=BUDVAL[1]^[MTH]-ACTVAL[1]^[MTH];
    CPRINTTOTS ('VARIANCE',BUDVAL[1]^,TRUE);
    KNOCKOFF (BUDVAL[2]^,TRUE);
    CPRINTTOTS ('TOTAL EXPEND (BUDGET) ',BUDVAL[2]^,FALSE);
    CPRINTTOTS ('TOTAL EXPEND (ACTUAL) ',ACTVAL[2]^,FALSE);
    FOR MTH:=1 TO 13 DO BUDVAL[2]^[MTH]:=BUDVAL[2]^[MTH]-ACTVAL[2]^[MTH];
    CPRINTTOTS ('VARIANCE',BUDVAL[2]^,TRUE);
    KNOCKOFF (BUDVAL[3]^,FALSE);
    CPRINTTOTS ('CUM BANK BAL (BUDGET) ',BUDVAL[3]^,FALSE);
    CPRINTTOTS ('CUM BANK BAL (ACTUAL) ',ACTVAL[3]^,FALSE);
    FOR MTH:=1 TO 13 DO BUDVAL[3]^[MTH]:=BUDVAL[3]^[MTH]-ACTVAL[3]^[MTH];    // TGM AB End
    CPRINTTOTS ('VARIANCE',BUDVAL[3]^,TRUE);
  END;

  {
  Listing of all Procedures and Functions contained in this program section.
  Pro. BLANKNEXT.
  Pro. SHOWTOTAL.
  Pro. PRINTOUT.
  Pro. MINSIZE.
  Pro. ENTDETAIL.
  Pro. ENTNOMINAL.
  Pro. ENTITEM.
  Pro. ENTVALUE.
  Pro. LISTOHEADS.
  Pro. PROCESSENTS.
  Pro. PROCESSNOM.
  Pro. REPSEG.
  Pro. MAINFLOW.
  Pro. SHOWNEXT.
  Pro. SHOWOPTS.
  Pro. SHOWMENU.
  }

  PROCEDURE BLANKNEXT;
  VAR
    X : INTEGER;
  BEGIN
    IF LINECOUNT + 4 > RFarmGate.PLINESPAGE[1] THEN
       CREPHEADINGS;
    PrintLine:=NULL;
    FOR X:=1 TO 6 DO PrintLine:=CONCAT(PrintLine,SPACE40);
    PrintLine:=CONCAT(PrintLine,COPY(SPACE40,1,15));
    COLHIGH:=1;
  END;

  PROCEDURE SHOWTOTAL (TITLE: STRING; VAR TOTAL: YEARVAL; SUM,INT: BOOLEAN);
  VAR
    X	    : INTEGER;
    WORKSTR : ShortSTRING;
  BEGIN
    IF TITLE<>NULL THEN
      BEGIN
	BLANKNEXT;
	BUILDLINE (1,TITLE);
      END;
    CASE OPT OF
      4,5 : BEGIN
	      IF SUM THEN TOTAL[13]:=0;
	      FOR X:=1 TO 12 DO
		BEGIN
		  IF SUM THEN TOTAL[13]:=TOTAL[13]+TOTAL[X];
                  {LONGSTR (TOTAL[X],WORKSTR,'L');}
		  IF INT THEN
		    BEGIN
		      DoubleToStr ( Total[X], WorkStr, '%7.0f', True, True, 7, False );
		      {
                      DELETE (WORKSTR,9,3);
		      BUILDLINE (34+(X*7),COPY(WORKSTR,3,7));
		      }
                      BUILDLINE (34+(X*7),WORKSTR);
		    END
		  ELSE
		    BEGIN
                      DoubleToStr ( Total[X], WorkStr, '%7.0f', True, True, 7, False );
		      {
                      DELETE (WORKSTR,11,1);
		      BUILDLINE (34+(X*7),COPY(WORKSTR,5,7));
		      }
                      BUILDLINE (34+(X*7),WORKSTR);
		    END;
		END;
	      {LONGSTR (TOTAL[13],WORKSTR,'L');}
	      IF INT THEN
		BEGIN
                  DoubleToStr ( Total[13], WorkStr, '%7.0f', True, True, 7, False );
		  {
                  DELETE (WORKSTR,9,3);
		  BUILDLINE (125,COPY(WORKSTR,2,8));
		  }
                  BUILDLINE (125,WORKSTR);
		END
	      ELSE
		BEGIN
                  DoubleToStr ( Total[13], WorkStr, '%7.0f', True, True, 7, False );
		  {
                  DELETE (WORKSTR,11,1);
		  BUILDLINE (125,COPY(WORKSTR,4,8));
		  }
                  BUILDLINE (125,WORKSTR);
		END;
	    END;
      3	  : FOR X:=1 TO 7 DO
	      BEGIN
                DoubleToStr ( Total[x], WorkStr, '%10.2f', True, True, 12, False );
                {LONGSTR (TOTAL[X],WORKSTR,'L');}
		BUILDLINE (30+(X*13),WORKSTR);
	      END;
      1,2 : BEGIN
              DoubleToStr ( Total[1], WorkStr, '%10.2f', True, True, 12, False );
	      {LONGSTR (TOTAL[1],WORKSTR,'L');}
	      BUILDLINE (47,WORKSTR);
              DoubleToStr ( Total[2], WorkStr, '%10.2f', True, True, 12, False );
	      {LONGSTR (TOTAL[2],WORKSTR,'L');}
	      BUILDLINE (61,WORKSTR);
	      IF (OPT=2) OR ((OPT=1) AND (SHOWANNUAL)) THEN
		CASE OPT OF
		  1 : BEGIN
                        DoubleToStr ( Total[3], WorkStr, '%10.2f', True, True, 12, False );
			{LONGSTR (TOTAL[3],WORKSTR,'L');}
			BUILDLINE (103,WORKSTR);
                        DoubleToStr ( Total[4], WorkStr, '%10.2f', True, True, 12, False );
			{LONGSTR (TOTAL[4],WORKSTR,'L');}
			BUILDLINE (75,WORKSTR);
                        DoubleToStr ( Total[5], WorkStr, '%10.2f', True, True, 12, False );
			{LONGSTR (TOTAL[5],WORKSTR,'L');}
			BUILDLINE (117,WORKSTR);
                        DoubleToStr ( Total[6], WorkStr, '%10.2f', True, True, 12, False );
			{LONGSTR (TOTAL[6],WORKSTR,'L');}
			BUILDLINE (89,WORKSTR);
		      END;
		  2 : BEGIN
                        DoubleToStr ( Total[3], WorkStr, '%10.2f', True, True, 12, False );
			{LONGSTR (TOTAL[3],WORKSTR,'L');}
			BUILDLINE (75,WORKSTR);
                        DoubleToStr ( Total[4], WorkStr, '%10.2f', True, True, 12, False );
			{LONGSTR (TOTAL[4],WORKSTR,'L');}
			BUILDLINE (89,WORKSTR);
		      END;
		END;
	    END;
    END;
    OUTPUTLINE;
  END;

  PROCEDURE PRINTOUT;
  VAR
    WORKSTR    : ShortSTRING;


    PROCEDURE MINSIZE(VAR ST: ShortSTRING; SZ: INTEGER);
    BEGIN
      REPEAT
	IF LENGTH(ST)<SZ THEN ST:=CONCAT(SPACE1,ST);
      UNTIL NOT(LENGTH(ST)<SZ);
    END;

    PROCEDURE ENTDETAIL;
    VAR
      INCF,INCT : INTEGER;
      EXPF,EXPT : INTEGER;
      SUB	: INTEGER;
      INCTOT	: YEARVAL;
      EXPTOT	: YEARVAL;
      NETTOT	: YEARVAL;
      PROFIT	: YEARVAL;
      RECTOT	: INTEGER;

      PROCEDURE ENTNOMINAL (LINK1,LINK2: INTEGER;
			    VAR SUBTOT,BIGTOT: YEARVAL; INC: BOOLEAN);
      VAR
	Sub,
        DBNUM	: INTEGER;
	PER	: INTEGER;
	YEARACT : Double{BIGLONG};
        YEARLST : Double{BIGLONG};
	YEARBUD : Double{BIGLONG};
	NOMBAL	: Double{BIGLONG};
	NOMPD	: Double{BIGLONG};
	NOMYR	: Double{BIGLONG};
	NOMDIFF : Double{BIGLONG};
	TOTVAL	: Double{BIGLONG};
	ABSMTH	: INTEGER;
	tx_totals : listcols;

	PROCEDURE ENTITEM (SLOT,COL: INTEGER; VAR VAL: Double{BIGLONG});
	BEGIN
	  BIGTOT[SLOT]:=BIGTOT[SLOT]-VAL;
	  IF INC THEN VAL:=0-VAL;
	  SUBTOT[SLOT]:=SUBTOT[SLOT]+VAL;
	  IF ACT=5 THEN
	    BEGIN
	      DoubleToStr ( 0-Val, WorkStr, '%f', True, True, 12, False );
              {LONGSTR (0-VAL,WORKSTR,'L');}
	      BUILDLINE (COL,WORKSTR);
	    END;
	END;

	PROCEDURE ENTVALUE (VAR VALUE: Double{BIGLONG}; ITEM: INTEGER);
	BEGIN
	  {
          IF VALUE>=0 THEN HALF:=50 ELSE HALF:=-50;
	  VALUE:=((VALUE+HALF) DIV 100)*100;
	  }
          IF ACT=5 THEN
	    BEGIN
              DoubleToStr ( 0-Value, WorkStr, ('%7.0f'), True, True, 7, False );
	      {
              LONGSTR (0-VALUE,WORKSTR,'L');
	      DELETE (WORKSTR,9,3);
              IF ITEM=13
		THEN BUILDLINE (125,	    COPY(WORKSTR,2,8))
		ELSE BUILDLINE (34+(ITEM*7),COPY(WORKSTR,3,7));
	      }
              IF ITEM=13
		THEN BUILDLINE (125,WORKSTR)
		ELSE BUILDLINE (34+(ITEM*7),WORKSTR);
	    END;
	END;

      BEGIN
	DBNUM:=NLFile;
	SETDB (DBNUM);
	RECTOT:=DB1.DBRECTOT;
	FOR SUB:=LINK1 TO LINK2 DO
	  IF (SUB>0) AND (SUB<RECTOT) THEN
	    BEGIN
	      READREC(DBNUM,SUB);
	      IF ERRORNO>0 THEN ERR;
	      IF RECACTIVE(DBNUM) THEN
		BEGIN
		  IF ACT=5 THEN
		    BEGIN
		      BLANKNEXT;
		      STR (SUB,CURRSTR);
		      MINSIZE (CURRSTR,4);
		      BUILDLINE (3,CURRSTR);
		      GETITEM (DBNUM,1);
		      BUILDLINE (10,CURRSTR);
		    END;
		  GETITEM (DBNUM,2);
		  NOMBAL:=CURRLONG;
		  GETITEM (DBNUM,4);
		  NOMYR:=NOMBAL-CURRLONG;

		  CASE OPT OF
		    1 : BEGIN
			  ENTITEM (1,47,NOMYR);
			  IF (MONTH=Cash1.XMONTHNO) OR (NOT Cash1.XNOMTHIS) THEN
			    BEGIN
			      //  GETITEM (DBNUM,3);
			      //  NOMPD:=NOMBAL-CURRLONG;
                              GETITEM (DBNUM,48+MONTH);
			      NOMPD:=CURRLONG;
			    END
			  ELSE
			    BEGIN
			      GETITEM (DBNUM,48+MONTH);
			      NOMPD:=CURRLONG;
			    END;
			  ENTITEM (2,61,NOMPD);
			  IF SHOWANNUAL THEN
			    BEGIN
			      GETITEM (DBNUM,7);
                              CurrDbl := CurrLong;
			      ENTITEM (3,103,CURRDbl);
			      NOMDIFF:=CURRDbl-NOMYR;
			      IF ACT=5 THEN
				BEGIN
                                  DoubleToStr ( 0-NomDiff, WorkStr, ('%f'), True, True, 12, False );
				  {LONGSTR (0-NOMDIFF,WORKSTR,'L');}
				  BUILDLINE (117,WORKSTR);
				END;
			      SUBTOT[5]:=SUBTOT[5]+NOMDIFF;
			      IF INC THEN NOMDIFF:=0-NOMDIFF;
			      BIGTOT[5]:=BIGTOT[5]-NOMDIFF;
			      GETITEM (DBNUM,32+MAXMONTH);
                              CurrDbl := currLong;
			      ENTITEM (4,75,CURRDbl);
			      NOMDIFF:=CurrDbl-NOMPD;
			      IF ACT=5 THEN
				BEGIN
                                  DoubleToStr ( 0-NomDiff, WorkStr, ('%f'), True, True, 12, False );
				  {LONGSTR (0-NOMDIFF,WORKSTR,'L');}
				  BUILDLINE (89,WORKSTR);
				END;
			      SUBTOT[6]:=SUBTOT[6]+NOMDIFF;
			      IF INC THEN NOMDIFF:=0-NOMDIFF;
			      BIGTOT[6]:=BIGTOT[6]-NOMDIFF;
			    END;
			END;
		    2 : BEGIN
			  ENTITEM (1,47,NOMYR);
			  GETITEM (DBNUM,17);
                          CurrDbl := CurrLong;
			  ENTITEM (2,61,CURRDbl);
			  GETITEM (DBNUM,18);
                          currDbl := CurrLong;
			  ENTITEM (3,75,CURRDbl);
			  GETITEM (DBNUM,19);
                          CurrDbl := CurrLong;
			  ENTITEM (4,89,CurrDbl);
			END;
		    3 : BEGIN
			  if not ((option = 4) and (option1 = 3)) then ENTITEM (4,82,NOMYR);
			  IF (MONTH=Cash1.XMONTHNO) OR (NOT Cash1.XNOMTHIS) THEN
			    BEGIN
			      //      GETITEM (DBNUM,3);       TGM AB Removed - fixed bug where report no sohwing correct month values
                        //      currDbl := CurrLong;
			//      NOMPD:=NOMBAL-CURRDbl;
                              GETITEM (DBNUM,48+MONTH);
			      NOMPD:=CURRLONG;
			    END
			  ELSE
			    BEGIN
			      GETITEM (DBNUM,48+MONTH);
			      NOMPD:=CURRLONG;
			    END;
			  ENTITEM (1,43,NOMPD);
			  {
			  GETITEM (DBNUM,64+XMONTHNO);
			  }
			  GETITEM (DBNUM,64+MONTH);
                          CurrDbl := CurrLong;
			  ENTITEM (2,56,CurrDbl);
			  {
			  GETITEM (DBNUM,32+XMONTHNO);
			  }
			  GETITEM (DBNUM,32+MONTH);
                          CurrDbl := CurrLong;
			  ENTITEM (3,69,CurrDbl);
			  YEARACT:=0;
			  YEARBUD:=0;
                          YEARLST:=0;
			  FOR PER:=1 TO MAXMONTH DO
			    BEGIN
			      ABSMTH:=Cash1.XFINMONTH+PER-1;
			      IF ABSMTH>12 THEN ABSMTH:=ABSMTH-12;
			      GETITEM (DBNUM,64+ABSMTH);
                              CurrDbl := CurrLong;
			      YEARLST:=YEARLST+CURRDbl;   // was YEARACT
			      GETITEM (DBNUM,32+ABSMTH);
                              CurrDbl := CurrLong;
			      YEARBUD:=YEARBUD+CurrDbl;
                              GETITEM (DBNUM,48+ABSMTH); //TGM AB
                              CurrDbl := CurrLong;       //TGM AB
			      YEARACT:=YEARACT+CurrDbl;  //TGM AB
			    END;
			  if ((option = 4) and (option1 = 3)) then begin // enterprise summary This Year Vs Last
                              ENTITEM (4,82,YEARACT); //TGM AB
                          end;
			  ENTITEM (5, 95,YEARLST);  // was YEARACT
			  ENTITEM (6,108,YEARBUD);
			  GETITEM (DBNUM,7);
                          CurrDbl := CurrLong;
			  ENTITEM (7,121,CurrDbl );
			END;
		    4 : BEGIN
			  If use_tx And ( Act In [4,5,6] ) Then
			     Begin
			       totval := 0;
			       total_tx_for_nom ( NlFile, sub, 0, false, tx_totals );
			       For per := 1 To 12 Do
				  Begin
				     ABSMTH := Cash1.XFINMONTH+per-1;
				     If ABSMTH > 12 Then ABSMTH := ABSMTH-12;
				     BIGTOT[PER]:=BIGTOT[PER]-tx_totals[absmth];
				     IF INC THEN tx_totals[absmth] :=
						    0-tx_totals[absmth];
				     SUBTOT[PER]:=SUBTOT[PER]+tx_totals[absmth];
                                     CurrDbl := tx_totals[absmth];
				     {currlong := tx_totals[absmth];}
				     ENTVALUE (CurrDbl,PER);
				     TOTVAL:=TOTVAL+tx_totals[absmth];
				  End;
				entvalue(totval, 13);
			     End
			  Else
			     Begin
			       IF (MONTH=Cash1.XMONTHNO) OR (NOT Cash1.XNOMTHIS) THEN
				 BEGIN
				   //  GETITEM (DBNUM,3);
				 //  NOMPD:=NOMBAL-CURRLONG;
                                   GETITEM (DBNUM,48+MONTH);
				   NOMPD:=CURRLONG;
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
				   ENTVALUE (CURRDbl,PER);
				   TOTVAL:=TOTVAL+CURRDbl;
				 END;
			       CURRLONG:=0;
                               CurrDbl := CurrLong;
			       FOR PER:=MAXMONTH+1 TO 12 DO ENTVALUE (CURRDbl,PER);
			       ENTVALUE (TOTVAL,13);
			     End;
			END;
		    5 : BEGIN
			   TOTVAL:=0;
			   FOR PER:=1 TO 12 DO    //TGM AB changed from MaxMonth
			     BEGIN
			       ABSMTH:=Cash1.XFINMONTH+PER-1;
			       IF ABSMTH>12 THEN ABSMTH:=ABSMTH-12;
			       GETITEM (DBNUM,64+ABSMTH);
                               CurrDbl := CurrLong;
			       BIGTOT[PER]:=BIGTOT[PER]-CurrDbl;
			       IF INC THEN CurrDbl:=0-CURRDbl;
			       SUBTOT[PER]:=SUBTOT[PER]+CurrDbl;
			       ENTVALUE (CurrDbl,PER);
			       TOTVAL:=TOTVAL+CURRDbl;
			     END;
			   CURRLONG:=0;
                           CurrDbl := CurrLong;
			   FOR PER:=MAXMONTH+1 TO 12 DO ENTVALUE (CurrDbl,PER);
			   ENTVALUE (TOTVAL,13);
			END;
		    END;
		  IF ACT=5 THEN OUTPUTLINE;
		END;
	    END;
      END;

    BEGIN
      FOR SUB:=1 TO 13 DO
	BEGIN
	  INCTOT[SUB]:=0;
	  EXPTOT[SUB]:=0;
	  NETTOT[SUB]:=0;
	  PROFIT[SUB]:=0;
	END;
      CASE ACT OF
	4 : BEGIN
	      CASE PASS OF
		1 : BEGIN
		      GETITEM(EntFile,6);
		      INCF:=CURRINT;
		      GETITEM(EntFile,7);
		      INCT:=CURRINT;
		      IF INCF>0 THEN ENTNOMINAL (INCF,INCT,INCTOT,NETTOT,TRUE);
		      SHOWTOTAL (NULL,INCTOT,TRUE,TRUE);
		    END;
		2 : BEGIN
		      GETITEM(EntFile,8);
		      EXPF:=CURRINT;
		      GETITEM(EntFile,9);
		      EXPT:=CURRINT;
		      IF EXPF>0 THEN ENTNOMINAL (EXPF,EXPT,EXPTOT,NETTOT,FALSE);
		      SHOWTOTAL (NULL,EXPTOT,TRUE,TRUE);
		    END;
		3 : Begin
		      GETITEM(EntFile,6);
		      INCF:=CURRINT;
		      GETITEM(EntFile,7);
		      INCT:=CURRINT;
		      IF INCF>0 THEN ENTNOMINAL (INCF,INCT,INCTOT,NETTOT,TRUE);
		      GETITEM(EntFile,8);
		      EXPF:=CURRINT;
		      GETITEM(EntFile,9);
		      EXPT:=CURRINT;
		      IF EXPF>0 THEN ENTNOMINAL (EXPF,EXPT,EXPTOT,NETTOT,FALSE);

		      for sub := 1 to 13 do
			inctot[sub] := inctot[sub] - exptot[sub];
		      showtotal ( null, inctot, true, true );
		    End;
	      END;

	      if pass <> 3 then
		FOR SUB:=1 TO 13 DO
		  BEGIN
		    TOTINCOME^[SUB]:=TOTINCOME^[SUB]+INCTOT[SUB];
		    TOTEXPEND^[SUB]:=TOTEXPEND^[SUB]+EXPTOT[SUB];
		  END;
	    END;
	5 : BEGIN
	      Case pass Of
		1 : Begin
		       ENTNOMINAL (Cash1.XNOMOHFROM,Cash1.XNOMOHTO,EXPTOT,NETTOT,TRUE);
		       BLANKLINE;
		       OUTPUTLINE;
		       RepDash;
		       FOR SUB:=1 TO 13 DO EXPTOT[SUB]:=0-EXPTOT[SUB];
		       If Cash11.xuse_enterprise Then
			 SHOWTOTAL ('TOTAL EXPENDITURE',EXPTOT,TRUE,TRUE)
		       Else
			 SHOWTOTAL ('TOTAL OVERHEADS',EXPTOT,TRUE,TRUE);
		       RepDash;
		    End;
		2 : Begin
		       FOR SUB:=1 TO 13 DO
			 BEGIN
			   INCTOT[SUB]:=0;
			   EXPTOT[SUB]:=0;
			   NETTOT[SUB]:=0;
			   PROFIT[SUB]:=0;
			 END;
		       ENTNOMINAL (Cash1.XNOMNONFROM,Cash1.XNOMNONTO,INCTOT,NETTOT,False);
		       BLANKLINE;
		       OUTPUTLINE;
		       RepDash;
		       FOR SUB:=1 TO 13 DO INCTOT[SUB]:=0-INCTOT[SUB];
		       If Cash11.xuse_enterprise Then
			  SHOWTOTAL ('TOTAL INCOME',INCTOT,TRUE,TRUE)
		       Else
			  SHOWTOTAL (Concat ('TOTAL NON-',Cash2.XENTUPPER,' INCOME'),INCTOT,TRUE,TRUE);
		       RepDash;
		    End;
	      End;
	    END;
	6 : BEGIN
	      CASE PASS OF
		1 : ENTNOMINAL (Cash1.XNOMINCFROM,Cash1.XNOMINCTO,INCTOT,NETTOT,TRUE);
		2 : ENTNOMINAL (Cash1.XNOMNONFROM,Cash1.XNOMNONTO,INCTOT,NETTOT,TRUE);
		3 : ENTNOMINAL (Cash1.XNOMEXPFROM,Cash1.XNOMEXPTO,EXPTOT,NETTOT,FALSE);
		4 : ENTNOMINAL (Cash1.XNOMOHFROM, Cash1.XNOMOHTO, EXPTOT,NETTOT,FALSE);
	      END;
	      CASE PASS OF
		1 : SHOWTOTAL (CONCAT('TOTAL ',Cash2.XENTUPPER,' INCOME'),	 INCTOT,TRUE,TRUE);
		2 : SHOWTOTAL (CONCAT('TOTAL NON-',Cash2.XENTUPPER,' INCOME'),INCTOT,TRUE,TRUE);
		3 : SHOWTOTAL (CONCAT('TOTAL ',Cash2.XENTUPPER,' EXPENDITURE'),EXPTOT,TRUE,TRUE);
		4 : If Cash11.xuse_enterprise Then
		       SHOWTOTAL ('TOTAL EXPENDITURE',			      EXPTOT,TRUE,TRUE)
		    Else
		       SHOWTOTAL ('TOTAL OVERHEADS',			    EXPTOT,TRUE,TRUE);
	      END;
	      FOR SUB:=1 TO 13 DO
		BEGIN
		  IF PASS=1 THEN TOTENTINC^[SUB]:=INCTOT[SUB];
		  IF PASS=3 THEN TOTENTEXP^[SUB]:=EXPTOT[SUB];
		  TOTINCOME^[SUB]:=TOTINCOME^[SUB]+INCTOT[SUB];
		  TOTEXPEND^[SUB]:=TOTEXPEND^[SUB]+EXPTOT[SUB];
		END;
	    END;
      END;
    END;

  BEGIN
    BLANKLINE;
    IF ACT=4 THEN
      BEGIN
	GETITEM(EntFile,1);
	BUILDLINE(5,CURRSTR);
	GETITEM(EntFile,2);
	BUILDLINE(9,' - ');
	if length ( currstr ) > 17 then
	  delete ( currstr, 18, ( length ( currstr )-17 ));
	BUILDLINE(12,CURRSTR);
	NUMBERONE:=FALSE;
      END;
    ENTDETAIL;
  END;

  PROCEDURE LISTOHEADS;
  BEGIN
    SETDB(DBNO);
    PRINTOUT;
    IF ESCKEY THEN EXIT;
  END;

  PROCEDURE PROCESSENTS;
  VAR
    RECNO : INTEGER;
    SUB	  : INTEGER;

  BEGIN
    SETDB(DBNO);

    BLANKLINE;
    CASE PASS OF
      1 : BUILDLINE (1,CONCAT(Cash2.XENTUPPER,' INCOME'));
      2 : BUILDLINE (1,CONCAT(Cash2.XENTUPPER,' EXPENDITURE'));
      3 : buildline (1, concat ( Cash2.xentupper, ' GROSS MARGIN'));
    END;
    OUTPUTLINE;
    BLANKLINE;
    OUTPUTLINE;
    RECNO:=1;
    REPEAT
      READREC(DBNO,RECNO);
      IF ERRORNO>0 THEN ERR;
      IF RECACTIVE(DBNO) THEN
	BEGIN
	  GETITEM(EntFile,1);
	  PRINTOUT;
	  IF ESCKEY THEN EXIT;
	END;
      RECNO:=RECNO+1;
      SETDB(DBNO);
    UNTIL RECNO>DB1.DBRECHIGH;
    BLANKLINE;
    OUTPUTLINE;
    RepDash;
    CASE PASS OF
      1 : SHOWTOTAL (CONCAT('TOTAL ',Cash2.XENTUPPER,' INCOME'),     TOTINCOME^,TRUE,TRUE);
      2 : SHOWTOTAL (CONCAT('TOTAL ',Cash2.XENTUPPER,' EXPENDITURE'),TOTEXPEND^,TRUE,TRUE);
    END;

    if pass <> 3 then
      RepDash;

    BLANKLINE;
    OUTPUTLINE;

    IF PASS=3{2} THEN
      BEGIN
	FOR SUB:=1 TO 13 DO
	  TOTOTHER^[SUB]:=TOTINCOME^[SUB]-TOTEXPEND^[SUB];
	SHOWTOTAL ('TOTAL GROSS MARGIN',TOTOTHER^,FALSE,TRUE);
	BLANKLINE;
	OUTPUTLINE;
	FOR SUB:=1 TO 13 DO
	  IF (TOTOTHER^[SUB]<>0) AND (TOTINCOME^[SUB]<>0) THEN
	    TOTOTHER^[SUB]:=(TOTOTHER^[SUB] / TOTINCOME^[SUB]);
	    {TOTOTHER[SUB]:=((TOTOTHER[SUB]*10000) DIV TOTINCOME[SUB]);}
	SHOWTOTAL ('TOTAL GROSS PROFIT %',TOTOTHER^,FALSE,FALSE);
	BLANKLINE;
	OUTPUTLINE;
	RepDash;
      END;
  END;

  PROCEDURE PROCESSNOM;
  VAR
    SUB	  : INTEGER;
  BEGIN
    SETDB(DBNO);

    PRINTOUT;
    IF ESCKEY THEN EXIT;
    IF PASS IN [2,4] THEN
      BEGIN
	BLANKLINE;
	OUTPUTLINE;
	RepDash;
	CASE PASS OF
	  2 : SHOWTOTAL ('TOTAL BUSINESS INCOME',     TOTINCOME^,TRUE,TRUE);
	  4 : SHOWTOTAL ('TOTAL BUSINESS EXPENDITURE',TOTEXPEND^,TRUE,TRUE);
	END;
	RepDash;
	BLANKLINE;
	OUTPUTLINE;
      END;
    IF PASS=4 THEN
      BEGIN	  
	FOR SUB:=1 TO 13 DO
	  TOTOTHER^[SUB]:=TOTENTINC^[SUB]-TOTENTEXP^[SUB];
	SHOWTOTAL ('TOTAL BUSINESS GROSS MARGIN',TOTOTHER^,FALSE,TRUE);
	BLANKLINE;
	OUTPUTLINE;
	FOR SUB:=1 TO 13 DO
	  TOTOTHER^[SUB]:=TOTINCOME^[SUB]-TOTEXPEND^[SUB];
	SHOWTOTAL ('TOTAL BUSINESS TRADING PROFIT',TOTOTHER^,FALSE,TRUE);
	BLANKLINE;
	OUTPUTLINE;
	RepDash;
	BLANKLINE;
	OUTPUTLINE;
	FOR SUB:=1 TO 13 DO
	  IF (TOTENTINC^[SUB]-TOTENTEXP^[SUB]<>0) AND (TOTENTINC^[SUB]<>0) THEN
             TOTOTHER^[SUB]:=
	      ((TOTENTINC^[SUB]-TOTENTEXP^[SUB]) / TOTENTINC^[SUB])
             {TOTOTHER[SUB]:=
	      (((TOTENTINC[SUB]-TOTENTEXP[SUB])*10000) DIV TOTENTINC[SUB])}
	    ELSE TOTOTHER^[SUB]:=0;
	SHOWTOTAL ('TOTAL BUSINESS GROSS PROFIT %',TOTOTHER^,FALSE,FALSE);
	BLANKLINE;
	OUTPUTLINE;
	FOR SUB:=1 TO 13 DO
	  IF (TOTINCOME^[SUB]-TOTEXPEND^[SUB]<>0) AND (TOTINCOME^[SUB]<>0) THEN
             TOTOTHER^[SUB]:=
	      ((TOTINCOME^[SUB]-TOTEXPEND^[SUB]) / TOTINCOME^[SUB])
             {TOTOTHER[SUB]:=
	      (((TOTINCOME[SUB]-TOTEXPEND[SUB])*10000) DIV TOTINCOME[SUB])}
	    ELSE TOTOTHER^[SUB]:=0;
	SHOWTOTAL ('TOTAL BUSINESS TRADING PROFIT %',TOTOTHER^,FALSE,FALSE);
	BLANKLINE;
	OUTPUTLINE;
	FOR SUB:=1 TO 13 DO
	  IF (TOTEXPEND^[SUB]-TOTENTEXP^[SUB]<>0) AND (TOTENTINC^[SUB]<>0) THEN
             TOTOTHER^[SUB]:=
	      ((TOTEXPEND^[SUB]-TOTENTEXP^[SUB]) / TOTENTINC^[SUB])
             {TOTOTHER[SUB]:=
	      (((TOTEXPEND[SUB]-TOTENTEXP[SUB])*10000) DIV TOTENTINC[SUB])}
	    ELSE TOTOTHER^[SUB]:=0;
	If Cash11.xuse_enterprise Then
	   SHOWTOTAL ('TOTAL EXPENDITURE AS % OF INCOME',TOTOTHER^,FALSE,FALSE)
	Else
	   SHOWTOTAL ('TOTAL OVERHEADS AS % OF INCOME',TOTOTHER^,FALSE,FALSE);
	BLANKLINE;
	OUTPUTLINE;
	RepDash;
      END;
  END;

  PROCEDURE REPSEG;
  VAR
    SUB : INTEGER;
  BEGIN
    CREPORTRUN;
    IF ESCKEY THEN EXIT;
    CREPHEADINGS;
    CASE ACT OF
      1,2,3,7,
      21,121,
      22,23   : BEGIN
		  PASS:=0;
		  REPEAT
		    PASS:=PASS+1;
		    PROCESSGROUP;
		    PROCESSOTHER;
		    IF (ACT IN [3,23]) AND (PASS=1) THEN CREPHEADINGS;
		    (*
		    IF WHERETO = 'S' THEN LINECOUNT:=99;
		    *)
		  UNTIL	 (ACT IN [1,2,21,22,7])
		     OR ((ACT IN [3,23]) AND (PASS=2));
		  IF ACT IN [3,23] THEN PRINTSUMM;
		END;
      24      : BEGIN
		  PASS:=0;
		  {
		  REPEAT
		  }
		    PASS:=PASS+1;
		    PROCESSGROUP;
		    {
		    PROCESSOTHER;
		    }
		    { IF (ACT IN [3,23]) AND (PASS=1) THEN CREPHEADINGS; }
		  (*
		  UNTIL	 {(ACT IN [1,2,21,22,7])
		     OR ((ACT IN [3,23,24]) AND} ( PASS = 2 );
		  *)
		  { IF ACT IN [3,23,24] THEN PRINTSUMM; }
		END;
      4	      : BEGIN
		  FOR SUB:=1 TO 13 DO
		    BEGIN
		      TOTINCOME^[SUB] := 0;
		      TOTEXPEND^[SUB] := 0;
		      totentinc^[sub] := 0;
		      totentexp^[sub] := 0;
		    END;
		  PASS:=0;
		  REPEAT
		    PASS:=PASS+1;
		    PROCESSENTS;
		  UNTIL PASS=3{2};
		END;
      5	      : Begin
		   pass := 0;
		   Repeat
		      pass := pass + 1;
		      If ( pass = 2 ) Then
			 Begin
			    heading := null;
			    If Cash11.xuse_enterprise Then
			       heading := 'INCOME REPORT'
			    Else
			       heading := Concat ('NON-',Cash2.xentupper,' INCOME REPORT');
			    crepheadings;
			 End;
		      LISTOHEADS;
		   Until ( pass = 2 ) Or ( NOT ( print_nonincome ));
		End;
      6	      : BEGIN
		  FOR SUB:=1 TO 13 DO
		    BEGIN
		      TOTINCOME^[SUB]:=0;
		      TOTEXPEND^[SUB]:=0;
		      TOTENTINC^[SUB]:=0;
		      TOTENTEXP^[SUB]:=0;
		    END;
		  PASS:=0;
		  REPEAT
		    PASS:=PASS+1;
		    PROCESSNOM;
		  UNTIL PASS=4;
		END;
    END;
    IF NOT ESCKEY THEN ENDPRINT;

    {
    if WHERETO = 'P' then
      CLOSE(PRINTFILE,LOCK)
    else
      if WHERETO = 'F' then
	begin
	  close ( DISK_FILE, LOCK );
	  dos_off;
	end
      else
	if whereto = 'S' then
	  begin
	    if (( line_no > 0 ) and ( line_no < 66 )) then
	      begin
		FP_init_remainder;
		SCR_disp_page;
		if ESCKEY then
		  EXIT ( REPSEG );
	      end;
	  end;
    }
  END;

  PROCEDURE MAINFLOW;
  VAR
    NEXTOPT : INTEGER;
    NEXTROW : INTEGER;

    PROCEDURE SHOWNEXT (TEXT: STRING);
    BEGIN
      NEXTOPT:=NEXTOPT+1;
      NEXTROW:=NEXTROW+1;
    END;


  BEGIN
    ACT:=0;
    if autoprog = 0 then
      Begin
      //	showmenu;
	act := option;
      End
    else
      act := autoprog;
{
    REPEAT
      IF AUTOPROG=0 THEN
	REPEAT
	  SHOWMENU;
}
{
	  REPEAT
	    no_func_key;
	    REC(30,24,1,SPACE1,0,0,0,0,0,0);
	    IF ESCKEY OR (SCRINT='M') OR (SCRINT='m') THEN SCRINT:='9';
	    WORKSTR:=SCRIN;
	    ACT:=0;
	    IF NUMERIC ( SCRINT ) THEN INTVAL ( ACT, SCRINT );
	    IF ( NOT XNOMTHIS ) AND ( ACT <> 9 ) THEN
	      IF ACT IN [1..5] THEN
		BEGIN
		  ACT := ACT + 1;
		  IF ACT > 2 THEN ACT := ACT + 1;
		  IF ACT > 6 THEN ACT := ACT + 1;
		END
	      ELSE
		ACT:=0;
	    if ( ACT = 4 ) and ( Xuse_enterprise ) then ACT := 0;
	  UNTIL ACT IN [1..8,9];
	  IF ACT = 9 THEN EXIT ( CASHFLOW );
}

	  IF ACT IN [4,5,6] THEN
	    BEGIN
	      {
	      SHOWOPTS;
	      REPEAT
		no_func_key;
		REC(30,24,1,SPACE1,0,0,0,0,0,0);
		IF ESCKEY OR (SCRINT='M') OR (SCRINT='m') THEN SCRINT:='9';
		WORKSTR:=SCRIN;
		OPT:=0;
		IF NUMERIC(SCRINT) THEN INTVAL(OPT,SCRINT);
		IF (NOT XNOMLAST) AND (OPT=5) THEN OPT:=0;
		IF (NOT XNOMLAST) AND (OPT=4) THEN OPT:=0;
		IF (NOT XNOMTHIS) AND (OPT=3) THEN OPT:=0;
		IF (NOT XNOMLAST) AND (OPT=3) THEN OPT:=4;
	      UNTIL OPT IN [1..5,9];
	      IF OPT=9 THEN ACT:=0;
	      }
	      opt := option1;
	    END;
{
	UNTIL ACT>0
      ELSE
	ACT:=AUTOPROG;
}
      IF ACT IN [1,2,3,5,6,7,21,121,22,23,24] THEN
	BEGIN
	  If ( act = 24 ) Then
	    page_width := 79;	 { 80 character Reports }
	  DBNO:=NlFile;
	  SETDB (DBNO);
	  REPSEG;
	END;
      IF ACT=4 THEN
	BEGIN
	  DBNO:=EntFile;
	  SETDB (DBNO);
	  REPSEG;
	END;
      If ACT = 8 Then
	 AUTOPROG := 21;
{
    UNTIL AUTOPROG<>0;
}
  END;

BEGIN
  {time_of_day ( curr_time );}
  opt := option1;
  showannual := true;
  Curr_Time := TimeToStr ( Time );
  NewPageAfterIncExp := ( CashFlowReportsForm.cbNewPage.Checked );
  use_tx := ( CashFlowReportsForm.UseTx.Checked );

  if Option = 5 then
     print_nonincome := ( CashFlowReportsForm.cbPrintNonIncome.Checked )
  else
     print_nonincome := FALSE;

  page_width := RFarmGate.plinewidth[1];

  If Numeric ( CashFlowReportsForm.GroupFrom.Text ) Then
     from_grp := StrToInt ( CashFlowReportsForm.GroupFrom.Text )
  Else
      From_Grp := 1;
  If Numeric ( CashFlowReportsForm.GroupTo.Text ) Then
     To_grp := StrToInt ( CashFlowReportsForm.GroupTo.Text )
  Else
     To_grp   := 999;

  If Numeric ( CashFlowReportsForm.CalMonth.Text ) Then
     Month := StrToInt ( CashFlowReportsForm.CalMonth.Text )
  Else
      Month := Cash1.xMonthNo;
  MAXMONTH:=MONTH-Cash1.XFINMONTH+1;
  If MAXMONTH<1 Then MAXMONTH:=MAXMONTH+12;

  StartPrint (( Option = 24 ));

  COLHIGH:=1;
  NEXTCOL:=1;
  BLANKLINE;

  NewMemory;

  MAINFLOW;

  DisposeMemory;

END;

{Begin}

End.
