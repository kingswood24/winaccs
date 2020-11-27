{
   19/10/17 [V4.2 R8.8] /MK Incorporated Changes from Andrew (TGM) - Zeroise turnover figures for both cashbook and ledger systems.

   10/10/18 [V4.3 R1.7] /MK Change - CLEARTX - Removed CheckForNewFields from this procedure as there is no need for it as CreateTransactionTable already
                                               creates the transaction table required for CLEARTX. CheckForNewFields was used to add additional fields that
                                               were not included in CreateTransactionTable when all new fields in Transaction table should be added to
                                               the CreateTransactionTable procedure table first.
}

Unit PYEnd;

InterFace

  PROCEDURE EndPeriod;

Implementation
Uses
    SysUtils,
    Umonth,
    Uyearend,
    DefSecFl,
    Clears,
    Calcs,
    Filed,
    Util,
    Vars,
    Types,
    DbCore,
    AccsData,
    Dialogs,
    AbortPrg,
    chkcomp,
    WinTypes, WinProcs,
    filectrl;

procedure ClearProductTransactions;
begin
    with AccsDataModule do
       try
          ProdsTx.Close;
          ProdsTx.EmptyTable;
       except
          ShowMessage('Could not Remove Product Transactions - Contact Kingswood before continuing');
       end;
end;

PROCEDURE ENDPERIOD;
CONST
  PMAX = 2000;
  BMAX =  999;
  CMAX =  999;

Type
  TPLAST = PACKED ARRAY [1..PMAX] OF SmallInt;
  TPFIRST = PACKED ARRAY [1..PMAX] OF SmallInt;
  TZEROBANK = PACKED ARRAY [1..BMAX] OF BOOLEAN;
  TZEROCAP  = PACKED ARRAY [1..CMAX] OF BOOLEAN;
  TALLOCAP  = PACKED ARRAY [1..CMAX] OF SmallInt;

VAR
  auto_monthend : boolean;	   (* to carry out a monthend automatically *)
  FROMACC  : SmallInt;
  TOACC	   : SmallInt;
  PLAST	   : ^TPLAST; {PACKED ARRAY [1..PMAX] OF INTEGER;}
  PFIRST   : ^TPFIRST; {PACKED ARRAY [1..PMAX] OF INTEGER;}
  ZEROBANK : ^TZEROBANK; {PACKED ARRAY [1..BMAX] OF BOOLEAN;}
  ZEROCAP  : ^TZEROCAP; {PACKED ARRAY [1..CMAX] OF BOOLEAN;}
  ALLOCAP  : ^TALLOCAP; {PACKED ARRAY [1..CMAX] OF INTEGER;}
  ZEROT	   : BOOLEAN;
  REMOVETX : BOOLEAN;
  RESETNOM : BOOLEAN;
  RESETSAL : BOOLEAN;
  RESETPUR : BOOLEAN;
  COPYBALS : BOOLEAN;
  KEEPBANK : BOOLEAN;
  CLEARCAP : BOOLEAN;
  STUBNO   : ShortString;
  LASTSTUB : ShortString;
  TXTYPE   : SmallInt;
  ORTYPE   : SmallInt;
  LASTTYPE : SmallInt;
  STATUS   : ShortString;
  EDSTAT   : ShortString;
  ALLOC	   : ShortString;
  BANKNOM  : SmallInt;
  BANKNOM1 : SmallInt;
  BANKNOM2 : SmallInt;
  TXDATE   : SmallInt;
  LASTDATE : SmallInt;
  NEXTLINE : SmallInt;

  Procedure err; Forward;

  Procedure NewMemory;
  Begin
       New ( PLAST );
       FillChar ( PLast^, SizeOf(PLast^),chr(0));
       New ( PFIRST );
       FillChar ( PFirst^, SizeOf(PFirst^),chr(0));
       New ( ZEROBANK );
       FillChar ( ZeroBank^, SizeOf(ZeroBank^),chr(0));
       New ( ZEROCAP );
       FillChar ( ZeroCap^, SizeOf(ZeroCap^),chr(0));
       New ( ALLOCAP );
       FillChar ( AllOCap^, SizeOf(AllOCap^),chr(0));
  End;

  Procedure DisposeMemory;
  Begin
       Dispose ( PLAST );
       Dispose ( PFIRST );
       Dispose ( ZEROBANK );
       Dispose ( ZEROCAP );
       Dispose ( ALLOCAP );
  End;

  PROCEDURE ERR;
  BEGIN
    DisposeMemory;
    AbortProgram ( 'Aborting Error' );
  END;

  Procedure GridLoop;  // Grid Calaculation for Month end Screen
  Var
     GridCounter : Integer;
     BankString : ShortString;
     ArrPos : Integer;
     BankInt : Integer;
  Begin
       GridCounter := 2;
       while ( GridCounter <= MonthEndForm.MonthBanksGrid.RowCount ) do
          Begin
             if MonthEndForm.MonthBanksGrid.Cells[2,GridCounter] = 'No'  then
                if Numeric(MonthEndForm.MonthBanksGrid.Cells[0,GridCounter]) then
                   Begin
                        BankString := MonthEndForm.MonthBanksGrid.Cells[0, GridCounter];
                        SlimAll (BankString);
                        BankInt := StrToInt(BankString);
                        ArrPos := (BankInt - Cash1.XBankMin + 1);
                        Zerobank^[ArrPos] := True;
                   End;
             GridCounter := GridCounter + 1;
          End;
  End;

  Procedure YearLoop; // Grid Calculation for Year End Screen
  Var
     GridCounter : Integer;
     CapString : ShortString;
     ArrPos : Integer;
     CapInt : Integer;
  Begin
       GridCounter := 2;
       while ( GridCounter <= YearEndForm.YearEndGrid.RowCount ) do
          Begin
             if YearEndForm.YearEndGrid.Cells[2,GridCounter] = 'Yes'  then
                if Numeric(YearEndForm.YearEndGrid.Cells[0,GridCounter]) then
                   Begin
                        CapString := YearEndForm.YearEndGrid.Cells[0, GridCounter];
                        SlimAll (CapString);
                        CapInt := StrToInt(CapString);
                        ArrPos := (CapInt - Cash1.XNomcaFrom + 1);
                        ZeroCap^[ArrPos] := True;
                   End;
             GridCounter := GridCounter + 1;
          End;
  End;

  {* checks the new transaction file for analysis code then checks to see if
     are to be deleted }
  Procedure clearanl;
  type
    anl_rec = record
      anl_no  : integer;
      anl_del : boolean;
    end;

  Var
    last_anl,
    arr_pos,
    counter   : integer;
    del_anl   : array [1..cmax] of anl_rec;

    Procedure delete_anl ( del_to : integer );
    Var
       d_count : integer;

    Begin
      for d_count := 1 to del_to do
	Begin
	  setdb ( AnalFile );
	  if ( del_anl[d_count].anl_del ) then
	    Begin
	      readrec ( AnalFile, del_anl[d_count].anl_no );
	      if errorno > 0 then err;
	      blankrec ( AnalFile, 'D' );
	      deleterecord ( AnalFile, del_anl[d_count].anl_no, False );
	      if errorno > 0 then err;
	    End;
	End;
    End;

    Procedure read_del_anl ( l_anl : integer );
    Var
      tx_count,
      last_trans : integer;

      Procedure scan_anl ( a_code : integer );
      Var
	scan_it : integer;
      Begin
	for scan_it := 1 to l_anl do
	  Begin
	    if del_anl[scan_it].anl_no = a_code then
	      del_anl[scan_it].anl_del := false;
	  End;
      End;

    Begin
      setdb ( TxFile );
      last_trans := db1.dbrechigh;

      for tx_count := 1 to last_trans do
	Begin
	  readrec ( TxFile, tx_count );
	  if errorno > 0 then err;
	  if recactive ( TxFile ) then
	    Begin
	      getitem ( TxFile, 12 );
	      scan_anl ( currint );
	    End;
	End;
    End;

  Begin
    {
    clearfrom ( 24 );
    dis ( 1, 24, 'DELETING MARKED ANALYSIS CODE ' );
    }

    if AnalFile = 0 then
      exit;

    setdb ( AnalFile );
    last_anl := db1.dbrechigh;

    arr_pos := 1;
    for counter := 1 to last_anl do
      Begin
	readrec ( AnalFile, counter );
	if errorno > 0 then err;
	if recactive ( AnalFile ) then
	  Begin
	    getitem ( AnalFile, 6 );
	    if currdisp[1] = 'Y' then
	      Begin
		getitem ( AnalFile, 1 );
		del_anl[arr_pos].anl_no := currint;
		del_anl[arr_pos].anl_del := true;
		arr_pos := arr_pos + 1;
	      End;
	  End;
	    if ( counter = last_anl ) then
	      Begin
		read_del_anl ( arr_pos-1 );
		delete_anl ( arr_pos-1 );
	      End
	    else
	      if ( arr_pos = cmax ) then
		Begin
		  read_del_anl ( arr_pos-1 );
		  delete_anl ( arr_pos-1 );
		  arr_pos := 1;
		End;
	  {End;}
      End;

  End;

  PROCEDURE CLEARTX;
  VAR
    incrementor,
    BLKIN    : SmallInt;
    INSUB    : SmallInt;
    INREC    : SmallInt;
    BLKOUT   : SmallInt;
    OUTSUB   : SmallInt;
    OUTREC   : SmallInt;
    amount : long;
    {
    BLKIN    : INTEGER;
    INSUB    : INTEGER;
    INREC    : INTEGER;
    BLKOUT   : INTEGER;
    OUTSUB   : INTEGER;
    OUTREC   : INTEGER;
    }
    STILLREQ : BOOLEAN;
//    WORKIN   : PACKED ARRAY [1..1024] OF CHAR;
//    WORKOUT  : PACKED ARRAY [1..1024] OF CHAR;
//    OFFSET   : SmallInt;

    FUNCTION BANKREQ: BOOLEAN;
    BEGIN
      BANKREQ:=TRUE;
      BankReq := True;
      IF NOT KEEPBANK THEN
	IF (TXTYPE=9) AND (ORTYPE=0) AND (BANKNOM=0) THEN
	  BEGIN
	    BANKREQ:=FALSE;
	    IF ( BANKNOM1-Cash1.XBANKMIN+1  >= 1 ) And
               ( BANKNOM1-Cash1.XBANKMIN+1  < BMAX ) Then
	      IF NOT ZEROBANK^[BANKNOM1-Cash1.XBANKMIN+1] THEN BANKREQ:=TRUE;
	    IF ( BANKNOM2-Cash1.XBANKMIN+1  >= 1 ) And
               ( BANKNOM2-Cash1.XBANKMIN+1  < BMAX ) Then
	      IF NOT ZEROBANK^[BANKNOM2-Cash1.XBANKMIN+1] THEN BANKREQ:=TRUE;
	  END
	ELSE
	  IF ( BANKNOM-Cash1.XBANKMIN+1 >= 1 ) And
             ( BANKNOM-Cash1.XBANKMIN+1 <=BMAX ) Then
	    BANKREQ:=NOT ZEROBANK^[BANKNOM-Cash1.XBANKMIN+1];
    END;

    PROCEDURE CHECKOK;
    BEGIN

      STILLREQ:=True;
      Amount := 0;
      IF STILLREQ THEN
	BEGIN
	  EDSTAT:='X';
	  Getitem(TxFile,28);
          EDSTAT[1] := Currstr[1];
	  Getitem(TxFile,1);
          TXTYPE := currint;
          Getitem(TxFile,23);
          ORTYPE := currint;
	  Getitem(TxFile,2);
          TXDATE := currint;
	  { 16/01/98 - Changed to allow '0' to '9' be entered Direct editing }
	  If ((EDSTAT=SPACE1) OR (EDSTAT='I') Or
	      (EDSTAT[1] In ['1'..'9','0'])) AND
	     ((TXTYPE IN [2,6,12,16]) OR ((TXTYPE=9) AND (ORTYPE=0))) THEN
	    Begin
              STILLREQ:=FALSE;
	      STUBNO:='XXXXXXXX';
	      Getitem(TxFile,26);
              STUBNO := currstr;
              Getitem(TxFile,17);
              Amount := currlong;
	      IF (((STUBNO <> 'XXXXXXXX') //LASTSTUB)
	      //OR (STUBNO='00000000')
	      //OR
              or (ORTYPE<>LASTTYPE)
	      OR (TXDATE<>LASTDATE)) AND (AMOUNT > 0)) THEN
		BEGIN
		  LASTSTUB:=STUBNO;
		  LASTTYPE:=ORTYPE;
		  LASTDATE:=TXDATE;
		  STATUS  :=SPACE1;
		  BANKNOM :=0;
		  BANKNOM1:=0;
		  BANKNOM2:=0;
		  Getitem(TxFile,27);
                  STATUS[1] := Currstr[1];
		  Getitem(TxFile,8);
                  Banknom := Currint;
		  IF (TXTYPE=9) AND (ORTYPE=0) AND (BANKNOM=0) THEN
		    BEGIN
                      keepbank := false;
		      Getitem(TxFile,18);
                      Banknom1 := Currint;
		      Getitem(TxFile,19);
                      Banknom2 := Currint;
		    END;
                  STILLREQ:=(STATUS='U') AND (BANKREQ);
                  Keepbank := true;
		END;
	    END
	  ELSE
	    IF EDSTAT='P' THEN
	      STILLREQ:=FALSE
	    ELSE
	      IF ((Cash2.XINVALLOC) OR (Cash1.XCRNALLOC)) AND (TXTYPE IN [1,5]) THEN
              		BEGIN
		  ALLOC:='X';
		  STILLREQ:=(ALLOC<>'Y');
		END
	      ELSE
		STILLREQ:=FALSE;
	END;
    END; // CheckOK

  BEGIN
    SETDB ( TxFile );

    IF REMOVETX THEN
      BEGIN
	INREC	:=0;
        OUTREC	:=0;
      	OUTSUB	:=0;
	BLKIN	:=0;
	BLKOUT	:=0;
	LASTSTUB:='XXXXXXXX';
	LASTTYPE:=99;
	LASTDATE:=99;

        If YearEndForm.Visible Then
           Begin
              YearEndForm.ProgressBar.Progress := 0;
              YearEndForm.ProgressBar.MaxValue := db1.DBRECHIGH;
              YearEndForm.ProgressLabel.Caption := 'Processing Old Transactions ...';
              YearEndForm.ProgressLabel.ReFresh;
           End
        Else
           Begin
              MonthEndForm.MonthBar.Progress := 0;
              MonthEndForm.MonthBar.MaxValue := db1.DBRECHIGH;
              MonthEndForm.MonthBarLabel.Caption := '';
              MonthEndForm.MonthBarLabel.Caption := 'Processing Old Transactions ...         ';
              MonthEndForm.MonthBarLabel.ReFresh;
           End;

        incrementor := 1;

        // TGM AB
        CloseDB(TxFile);
        if fileexists(pchar(Accsdatamodule.AccsDataBase.Directory + '_Transactions.db')) then deletefile(pchar(Accsdatamodule.AccsDataBase.Directory + '_Transactions.db'));
        if fileexists(pchar(Accsdatamodule.AccsDataBase.Directory + '_Transactions.px')) then deletefile(pchar(Accsdatamodule.AccsDataBase.Directory + '_Transactions.px'));
        if fileexists(pchar(Accsdatamodule.AccsDataBase.Directory + 'NewTransactions.db')) then deletefile(pchar(Accsdatamodule.AccsDataBase.Directory + 'NewTransactions.db'));
        if fileexists(pchar(Accsdatamodule.AccsDataBase.Directory + 'NewTransactions.px')) then deletefile(pchar(Accsdatamodule.AccsDataBase.Directory + 'NewTransactions.px'));

        RenameFile(Accsdatamodule.AccsDataBase.Directory + 'Transactions.db',Accsdatamodule.AccsDataBase.Directory + '_Transactions.db');
        RenameFile(Accsdatamodule.AccsDataBase.Directory + 'Transactions.px',Accsdatamodule.AccsDataBase.Directory + '_Transactions.px');
        Accsdatamodule.CreateTransactionTable;
        //ChkComp.FCheckName.CheckForNewFields;
        RenameFile(Accsdatamodule.AccsDataBase.Directory + 'Transactions.db',Accsdatamodule.AccsDataBase.Directory + 'NewTransactions.db');
        RenameFile(Accsdatamodule.AccsDataBase.Directory + 'Transactions.px',Accsdatamodule.AccsDataBase.Directory + 'NewTransactions.px');

        RenameFile(Accsdatamodule.AccsDataBase.Directory + '_Transactions.db',Accsdatamodule.AccsDataBase.Directory + 'Transactions.db');
        RenameFile(Accsdatamodule.AccsDataBase.Directory + '_Transactions.px',Accsdatamodule.AccsDataBase.Directory + 'Transactions.px');

        try accsdatamodule.TransactionsDB.open;
        except
        end;

        SetDB(TxFile);

	  FOR INREC:=1 TO DB1.DBRECHIGH DO
	    BEGIN
            If YearEndForm.Visible Then
                   YearEndForm.ProgressBar.Progress := YearEndForm.ProgressBar.Progress + incrementor
               Else
                   MonthEndForm.MonthBar.Progress := MonthEndForm.MonthBar.Progress + incrementor;

            accsdatamodule.TransactionsDB.Locate('TxNo',INREC,[]);
            CHECKOK;  // this checks the transaction to see if needs to be carried forward to next year
	    IF STILLREQ  THEN
		    BEGIN // copy record into new table
		      OUTREC:=OUTREC+1;
                      AccsDataModule.TransMoveQuery.Close;
                      AccsDataModule.TransMoveQuery.sql.Clear;
                      AccsDataModule.TransMoveQuery.sql.add('Insert Into NewTransactions');
                      AccsDataModule.TransMoveQuery.sql.add('Select * From Transactions A where TxNo = ' + vartostr(Inrec)); //needs to be 'Transactions A' to work
                      AccsDataModule.TransMoveQuery.ExecSQL;

            end;
          END;

    DB1.DBUSER[1]:=DB1.DBRECHIGH;

    // TGM AB Tidy Up files

    CloseDB(TxFile);
    try accsdatamodule.TransactionsDB.close;
    except
    end;


    if fileexists(Accsdatamodule.AccsDataBase.Directory + 'year-2.db') then DeleteFile(pchar(Accsdatamodule.AccsDataBase.Directory + 'year-2.db'));
    if fileexists(Accsdatamodule.AccsDataBase.Directory + 'year-2.px') then DeleteFile(pchar(Accsdatamodule.AccsDataBase.Directory + 'year-2.px'));

    if fileexists(Accsdatamodule.AccsDataBase.Directory + 'year-1.db') then RenameFile(Accsdatamodule.AccsDataBase.Directory + 'year-1.db',Accsdatamodule.AccsDataBase.Directory + 'year-2.db');
    if fileexists(Accsdatamodule.AccsDataBase.Directory + 'year-1.px') then RenameFile(Accsdatamodule.AccsDataBase.Directory + 'year-1.px',Accsdatamodule.AccsDataBase.Directory + 'year-2.px');

    RenameFile(Accsdatamodule.AccsDataBase.Directory + 'Transactions.db',Accsdatamodule.AccsDataBase.Directory + 'year-1.db');
    RenameFile(Accsdatamodule.AccsDataBase.Directory + 'Transactions.px',Accsdatamodule.AccsDataBase.Directory + 'year-1.px');

    RenameFile(Accsdatamodule.AccsDataBase.Directory + 'NewTransactions.db',Accsdatamodule.AccsDataBase.Directory + 'Transactions.db');
    RenameFile(Accsdatamodule.AccsDataBase.Directory + 'NewTransactions.px',Accsdatamodule.AccsDataBase.Directory + 'Transactions.px');

    try accsdatamodule.TransactionsDB.open;
    except
    end;

    try accsdatamodule.AllocatedVATDB.close;
    except
    end;

    accsdatamodule.AllocatedVATDB.emptytable;

    try accsdatamodule.AllocatedVATDB.open;
    except
    end;

    SetDB(TxFile);
    Cash1.XLASTTX:=DB1.DBRECHIGH;
    defwrite(0);

    END;
  END;

  PROCEDURE CARRYFORWARD (FL: SmallInt; called_from_year_end : Boolean );
  VAR
    RECNO : SmallInt;

    PROCEDURE P2CHECK;
    VAR
      RECNO    : SmallInt;
      TT       : SmallInt;
      WK       : LONG;
      TXACC    : SmallInt;
      DBACC    : SmallInt;
      CRACC    : SmallInt;
      OK       : BOOLEAN;
    BEGIN
      IF ((FL=SLFile) AND (NOT RESETSAL))
      OR ((FL=PlFile) AND (NOT RESETPUR))
      OR ((FL=NlFile) AND (NOT RESETNOM)) THEN EXIT;
      SETDB ( TxFile );
      IF DB1.DBRECHIGH=0 THEN EXIT;
      {
      CLEARFROM (24);
      CASE FL OF
	1 : DIS (1,24,'CHECKING ACTIVE CUSTOMER TRANSACTIONS ... ');
	2 : DIS (1,24,'CHECKING ACTIVE SUPPLIER TRANSACTIONS ... ');
	3 : DIS (1,24,'CHECKING ACTIVE NOMINAL TRANSACTIONS .... ');
      END;
      }
      MonthEndForm.MonthBar.Progress := 0;
      MonthEndForm.MonthBar.MaxValue := db1.dbrechigh div 10;
      MonthEndForm.MonthBarLabel.Caption := '';
      CASE FL OF
	SLFile : MonthEndForm.MonthBarLabel.Caption :='Checking Active Customer Transactions ';
	PlFile : MonthEndForm.MonthBarLabel.Caption :='Checking Active Supplier Transactions ';
	NlFile : MonthEndForm.MonthBarLabel.Caption :='Checking Active Nominal Transactions  ';
      END;
      MonthEndForm.MonthBarLabel.Refresh;

      FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO
	BEGIN
          MonthEndForm.MonthBar.Progress := MonthEndForm.MonthBar.Progress + 10;
	  {
          DIS  (43,24,'	    ');
	  DISI (43,24,RECNO,1);
	  }
          READREC (TxFile,RECNO);
	  IF ERRORNO>0 THEN ERR;
	  IF RECACTIVE(TxFile) THEN
	    BEGIN
	      CASE FL OF
		PlFile,
                SlFile
                    : BEGIN
			GETITEM(TxFile,3);
			TXACC:=CURRINT;
			GETITEM(TxFile,1);
			TT:=CURRINT;
			IF (TXACC>=FROMACC) AND (TXACC<=TOACC) AND
			  (((FL=SlFile) AND (TT IN [1..4]))
			OR ((FL=PlFile) AND (TT IN [5..8]))) THEN
			  BEGIN
			    CURRINT:=0;
			    PUTITEM(TxFile,16);
			    IF PFIRST^[TXACC-FROMACC+1]>0 THEN
			      BEGIN
				CURRINT:=PFIRST^[TXACC-FROMACC+1];
				PUTITEM(TxFile,16);
			      END;
			    IF PLAST^[TXACC-FROMACC+1]=0 THEN
			       PLAST^[TXACC-FROMACC+1]:=RECNO;
			    PFIRST^[TXACC-FROMACC+1]:=RECNO;
			    REWRITEREC(TxFile,RECNO);
			    IF ERRORNO>0 THEN ERR;
			  END;
		      END;
		NlFile
                    : BEGIN
			GETITEM(TxFile,18);
			DBACC:=CURRINT;
			GETITEM(TxFile,19);
			CRACC:=CURRINT;
			OK:= ((DBACC>0) OR (CRACC>0));
			IF OK THEN
			  OK:=((DBACC>=FROMACC) AND (DBACC<=TOACC))
			  OR  ((CRACC>=FROMACC) AND (CRACC<=TOACC));
			IF OK THEN
			  BEGIN
			    IF (DBACC>=FROMACC) AND (DBACC<=TOACC) THEN
			      BEGIN
				CURRINT:=0;
				PUTITEM(TxFile,13);
				IF PFIRST^[DBACC-FROMACC+1]>0 THEN
				  BEGIN
				    CURRINT:=PFIRST^[DBACC-FROMACC+1];
				    PUTITEM(TxFile,13);
				  END;
				IF PLAST^[DBACC-FROMACC+1]=0 THEN
				   PLAST^[DBACC-FROMACC+1]:=RECNO;
				PFIRST^[DBACC-FROMACC+1]:=RECNO;
			      END;
			    IF (CRACC>=FROMACC) AND (CRACC<=TOACC) THEN
			      BEGIN
				CURRINT:=0;
				PUTITEM(TxFile,14);
				IF PFIRST^[CRACC-FROMACC+1]>0 THEN
				  BEGIN
				    CURRINT:=PFIRST^[CRACC-FROMACC+1];
				    PUTITEM(TxFile,14);
				  END;
				IF PLAST^[CRACC-FROMACC+1]=0 THEN
				   PLAST^[CRACC-FROMACC+1]:=RECNO;
				PFIRST^[CRACC-FROMACC+1]:=RECNO;
			      END;
			    REWRITEREC(TxFile,RECNO);
			    IF ERRORNO>0 THEN ERR;
			  END;
		      END;
	      END;
	    END;
	END;
      {
      CLEARFROM(24);
      }
    END;

    PROCEDURE P3CHECK;
    VAR
      RECNO   : SmallInt;
      AGEBAL  : LONG;
      OPENBAL : LONG;
      MOVEBAL : LONG;
      MOVEBUD : LONG;
    BEGIN
      SETDB(FL);
      {
      CLEARFROM (24);
      CASE FL OF
	1 : DIS (1,24,'RE-SETTING CUSTOMER ACCOUNT BALANCES ... ');
	2 : DIS (1,24,'RE-SETTING SUPPLIER ACCOUNT BALANCES ... ');
	3 : DIS (1,24,'RE-SETTING NOMINAL ACCOUNT BALANCES .... ');
      END;
      }
      MonthEndForm.MonthBar.Progress := 0;
      MonthEndForm.MonthBar.MaxValue := ToAcc-FromAcc+1;
      MonthEndForm.MonthBarLabel.Caption := '';
      CASE FL OF
	SLFile : MonthEndForm.MonthBarLabel.Caption :='Re-Setting Customer Account Balances  ';
	PlFile : MonthEndForm.MonthBarLabel.Caption :='Re-Setting Supplier Account Balances  ';
	NlFile : MonthEndForm.MonthBarLabel.Caption :='Re-Setting Nominal Account Balances   ';
      END;
      MonthEndForm.MonthBarLabel.Refresh;

      FOR RECNO:=FROMACC TO TOACC DO
	BEGIN
          MonthEndForm.MonthBar.Progress := MonthEndForm.MonthBar.Progress + 1;
	  {
          DISI (42,24,RECNO,1);
	  }
          READREC (FL,RECNO);
	  IF ERRORNO>0 THEN ERR;
	  IF RECACTIVE(FL) THEN
	    BEGIN
	      CASE FL OF
		SlFile,
                PlFile
                    : BEGIN
			IF REMOVETX THEN
			  BEGIN
			    IF (Cash2.XINVALLOC)
			    OR (Cash1.XCRNALLOC) OR ((Cash2.XINVSYS) AND (Cash1.XINVCOST)) THEN
			      BEGIN
				CURRINT:=PFIRST^[RECNO-FROMACC+1];
				PUTITEM(FL,14);
			      END
			    ELSE
			      BEGIN
				CURRINT:=0;
				PUTITEM(FL,14);
			      END;
			  END
			ELSE
			  BEGIN
			    GETITEM(FL,14);
			    IF CURRINT=0 THEN
			      BEGIN
				GETITEM(FL,15);
				PUTITEM(FL,14);
			      END;
			  END;
			{
			CURRINT:=PLAST[RECNO-FROMACC+1];
			PUTITEM(FL,16);
			SETITEM;
			PUTITEM(FL,15);
			GETITEM(FL,7);
			PUTITEM(FL,6);
			IF REMOVETX THEN PUTITEM(FL,17);
			}
			IF ((FL=SlFile) AND (RESETSAL))
			OR ((FL=PlFile) AND (RESETPUR)) THEN
			  BEGIN
			    CURRINT:=0;
			    PUTITEM(FL,15);
			    CURRINT:=PLAST^[RECNO-FROMACC+1];
			    PUTITEM(FL,16);
			    GETITEM(FL,7);
			    PUTITEM(FL,6);
                            GETITEM(FL,7); // TGM AB avoids memory getting reset;
			    IF REMOVETX THEN PUTITEM(FL,17);
			  END;
			{ stops resetting age back another month }
			If NOT called_from_year_end Then
			   Begin
			      GETITEM(FL,12);
			      AGEBAL:=CURRLONG;
			      GETITEM(FL,11);
			      CURRLONG:=CURRLONG+AGEBAL;
			      PUTITEM(FL,12);
			      GETITEM(FL,10);
			      PUTITEM(FL,11);
			      GETITEM(FL,9);
			      IF CURRLONG>0 THEN
				BEGIN
				  PUTITEM(FL,10);
				  CURRLONG:=0;
				  PUTITEM(FL,9);
				END
			      ELSE
				BEGIN
				  CURRLONG:=0;
				  PUTITEM(FL,10);
				END;
			   End;
		      END;
		NlFile
                    : BEGIN
			{
			IF (RECNO>=XBANKMIN) AND (RECNO<=XBANKMAX)
			  THEN CURRINT:=PFIRST[RECNO-FROMACC+1]
			  ELSE CURRINT:=0;
			}
			IF (RECNO>=Cash1.XBANKMIN) AND (RECNO<=Cash1.XBANKMAX) THEN
			  IF RESETNOM THEN
			    BEGIN
			      CURRINT:=PFIRST^[RECNO-FROMACC+1];
			      PUTITEM (FL,14);
			    END
			  ELSE
			    BEGIN
			      GETITEM (FL,14);
			      IF CURRINT=0 THEN
				BEGIN
				  GETITEM (FL,15);
				  PUTITEM (FL,14);
				END;
			    END;
			IF RESETNOM THEN
			  BEGIN
			    CURRINT:=0;
			    PUTITEM(FL,15);
			  END;
			IF RESETNOM THEN
			  BEGIN
			    CURRINT:=PLAST^[RECNO-FROMACC+1];
			    PUTITEM(FL,16);
			  END;
			GETITEM(NlFile,3);
			OPENBAL:=CURRLONG;
			GETITEM(NlFile,2);
			MOVEBAL:=CURRLONG-OPENBAL;
			PUTITEM(NlFile,3);
                        GETITEM(NlFile,2);        // TGM AB
			MOVEBAL:=CURRLONG-OPENBAL; // TGM AB to avoid memory getting emptied
			IF RESETNOM THEN PUTITEM(NlFile,22);
			IF Cash1.XNOMTHIS THEN
			  BEGIN
			    CURRLONG:=MOVEBAL;
			    PUTITEM(NlFile,48+Cash1.XMONTHNO);
			  END;
			IF COPYBALS THEN
			  BEGIN
			    GETITEM(NlFile,32+Cash1.XMONTHNO);
			    MOVEBUD:=CURRLONG;
			    CURRLONG:=MOVEBAL;
			    PUTITEM(NlFile,32+Cash1.XMONTHNO);
			    GETITEM(NlFile,7);
			    CURRLONG:=CURRLONG-MOVEBUD+MOVEBAL;
			    PUTITEM(NlFile,7);
			  END;
		      END;
	      END;
	      REWRITEREC(FL,RECNO);
	      IF ERRORNO>0 THEN ERR;
	    END;
	END;
      {
      CLEARFROM (24);
      }
    END;

  BEGIN
    SETDB(FL);
    FROMACC:=1;
    REPEAT
      SETDB(FL);
      TOACC:=FROMACC+PMAX-1;
      IF TOACC>DB1.DBRECTOT THEN TOACC:=DB1.DBRECTOT;
      FILLCHAR(PFIRST^,PMAX*2,CHR(0));
      FILLCHAR(PLAST^, PMAX*2,CHR(0));
      P2CHECK;
      P3CHECK;
      FROMACC:=TOACC+1;
      SETDB(FL);
    UNTIL NOT(FROMACC<DB1.DBRECTOT);
  END;

  PROCEDURE BANKRESET;
  VAR
    RECNO : SmallInt;
    TXREC : SmallInt;
    DBAC  : SmallInt;
    CRAC  : SmallInt;
  BEGIN
    IF NOT RESETNOM THEN EXIT;
    SETDB(NlFile);
    {
    CLEARFROM (24);
    DIS (1,24,'RE-SETTING BANK AUDIT TRAIL ... ');
    }
    MonthEndForm.MonthBar.Progress := 0;
    MonthEndForm.MonthBar.MaxValue := (Cash1.xBankMax-Cash1.xBankMin+1);
    MonthEndForm.MonthBarLabel.Caption := '';
    MonthEndForm.MonthBarLabel.Caption :='Re-Setting Bank Audit Trail                        ';
    MonthEndForm.MonthBarLabel.Refresh;

    FOR RECNO:=Cash1.XBANKMIN TO Cash1.XBANKMAX DO
      BEGIN
        MonthEndForm.MonthBar.Progress := MonthEndForm.MonthBar.Progress + 1;

        READREC (NlFile,RECNO);
	IF ERRORNO>0 THEN ERR;
	IF RECACTIVE(NlFile) THEN
	  BEGIN
	    GETITEM(NlFile,14);
	    TXREC:=CURRINT;
	    SETDB(NlFile);
	    STATUS  :='X';
	    LASTSTUB:='XXXXXXXX';
	    LASTTYPE:=99;
	    LASTDATE:=99;
	    {
            DIS (39,24,'CHECKING BANK TRANSACTIONS ...	    ');
	    }
            WHILE (TXREC>0) AND (STATUS<>'U') DO
	      BEGIN
		{
                DISI (70,24,TXREC,1);
		}
                READREC(TxFile,TXREC);
		IF ERRORNO>0 THEN ERR;
		IF RECACTIVE(TxFile) THEN
		  BEGIN
		    GETITEM(TxFile,1);
		    TXTYPE:=CURRINT;
		    GETITEM(TxFile,23);
		    ORTYPE:=CURRINT;
		    GETITEM(TxFile,2);
		    TXDATE:=CURRINT;
		    GETITEM(TxFile,28);
		    EDSTAT   :=SPACE1;
		    EDSTAT[1]:=CURRDISP[1];
		    IF ((EDSTAT=SPACE1) OR (EDSTAT='I')) AND
		       ((TXTYPE IN [2,6,12,16]) OR ((TXTYPE=9) AND (ORTYPE=0))) THEN
		      BEGIN
			GETITEM(TxFile,26);
			STUBNO:=CURRSTR;
			IF (STUBNO<>LASTSTUB)
			OR (STUBNO='00000000')
			OR (ORTYPE<>LASTTYPE)
			OR (TXDATE<>LASTDATE) THEN
			  BEGIN
			    LASTSTUB:=STUBNO;
			    LASTTYPE:=ORTYPE;
			    LASTDATE:=TXDATE;
			    GETITEM(TxFile,27);
			    STATUS   :=SPACE1;
			    STATUS[1]:=CURRDISP[1];
			  END;
		      END;
		    IF STATUS<>'U' THEN
		      BEGIN
			GETITEM(TxFile,18);
			DBAC:=CURRINT;
			GETITEM(TxFile,19);
			CRAC:=CURRINT;
			TXREC:=0;
			IF CURRREC[NlFile]=DBAC THEN
			  BEGIN
			    GETITEM(TxFile,13);
			    TXREC:=CURRINT;
			  END;
			IF CURRREC[NlFile]=CRAC THEN
			  BEGIN
			    GETITEM(TxFile,14);
			    TXREC:=CURRINT;
			  END;
		      END;
		  END
		ELSE
		  TXREC:=0;
	      END;
	    SETDB(NlFile);
	    CURRINT:=TXREC;
	    PUTITEM(NlFile,14);
	    REWRITEREC(NlFile,RECNO);
	    IF ERRORNO>0 THEN ERR;
	  END;
      END;
    {
    CLEARFROM (24);
    }
  END;

  PROCEDURE ZEROTURN (FL: SmallInt);
  VAR
    RECNO : SmallInt;
  BEGIN
    {
    CLEARFROM (24);
    CASE FL OF
      1 : DIS (1,24,'RE-SETTING CUSTOMER ACCOUNT TURNOVER ... ');
      2 : DIS (1,24,'RE-SETTING SUPPLIER ACCOUNT TURNOVER ... ');
    END;
    }
    SETDB(FL);
    YearEndForm.ProgressBar.Progress := 0;
    YearEndForm.ProgressBar.MaxValue := db1.dbrechigh div 10;

    CASE FL OF
      SlFile : YearEndForm.ProgressLabel.Caption := 'Re-Setting Customer Account Turnover ...';
      PlFile : YearEndForm.ProgressLabel.Caption := 'Re-Setting Supplier Account Turnover ...';
    END;
    YearEndForm.ProgressLabel.ReFresh;

    FOR RECNO:=1 TO DB1.DBRECHIGH DO
      BEGIN
        YearEndForm.ProgressBar.Progress := YearEndForm.ProgressBar.Progress + 10;

        READREC(FL,RECNO);
	IF ERRORNO>0 THEN ERR;
	IF RECACTIVE(FL) THEN
	  BEGIN
	    SETITEM;
	    PUTITEM(FL,8);
	    IF (FL=SlFile) AND (Cash1.XCUSTDISC) THEN PUTITEM(FL,18);
	    REWRITEREC(FL,RECNO);
	    IF ERRORNO>0 THEN ERR;
	  END;
      END;
    {
    CLEARFROM (24);
    }
  END;

  PROCEDURE CARRYNOMINAL;
  VAR
    ACCUMBAL : LONG;
    ST	     : ShortString;
    X	     : SmallInt;
    CURRBAL  : LONG;
    OPENBAL  : LONG;
    MOVEBAL  : LONG;
    RECNO    : SmallInt;
    ACC	     : SmallInt;
    BAL	     : LONG;

  BEGIN
    ACCUMBAL:=0;
    {
    CLEARFROM (24);
    DIS (1,24,'RE-SETTING NOMINAL ACCOUNT BALANCES ... ');
    }

    SETDB(NlFile);
    YearEndForm.ProgressBar.Progress := 0;
    YearEndForm.ProgressBar.MaxValue := db1.dbrectot div 10;
    YearEndForm.ProgressLabel.Caption := 'Re-Setting Nominal Account Balances.';
    YearEndForm.ProgressLabel.ReFresh;

    FOR RECNO:=1 TO DB1.DBRECTOT DO
      BEGIN
        YearEndForm.ProgressBar.Progress := YearEndForm.ProgressBar.Progress + 10;

        READREC (NlFile,RECNO);
	IF ERRORNO>0 THEN ERR;
	IF RECACTIVE(NlFile) THEN
	  BEGIN
	    IF COPYBALS THEN
	      BEGIN
		GETITEM(NlFile,2);
		CURRBAL:=CURRLONG;
		GETITEM(NlFile,4);
		CURRLONG:=CURRBAL-CURRLONG;
		PUTITEM(NlFile,7);
		FOR X:=1 TO 12 DO
		  BEGIN
		    GETITEM(NlFile,48+X);
		    PUTITEM(NlFile,32+X);
		  END;
	      END;

	    { ** 20-04-94 This Field is set to zero so as not to throw out
		 the Full Nominal Ledger Audit Trail after a year end has been
		 completed }
	    {
	    setitem;
	    putitem ( NlFile, 22 );
	    }
	    GETITEM(NlFile,18);
	    PUTITEM(NlFile,19);
	    GETITEM(NlFile,17);
	    PUTITEM(NlFile,18);
	    GETITEM(NlFile,4);
	    OPENBAL:=CURRLONG;
	    GETITEM(NlFile,2);
	    MOVEBAL:=CURRLONG-OPENBAL;
	    PUTITEM(NlFile,4);
	    CURRLONG:=MOVEBAL;
	    PUTITEM(NlFile,17);
	    FOR X:=1 TO 12 DO
	      BEGIN
		IF Cash1.XNOMLAST THEN
		  BEGIN
		    GETITEM(NlFile,48+X);
		    PUTITEM(NlFile,64+X);
		  END;
		IF Cash1.XNOMTHIS THEN
		  BEGIN
		    CURRLONG:=0;
		    PUTITEM(NlFile,48+X);
		  END;
	      END;
	    IF Cash1.XNOMWEEK THEN
	      FOR X:=1 TO 53 DO
		BEGIN
		  CURRLONG:=0;
		  PUTITEM (NlFile,80+X);
		END;
	    IF ((RECNO>Cash1.XNOMINCFROM-1) AND (RECNO<Cash1.XNOMNONTO+1))
	    OR ((RECNO>Cash1.XNOMEXPFROM-1) AND (RECNO<Cash1.XNOMOHTO+1)) THEN
	      BEGIN
		GETITEM(NlFile,2);
		ACCUMBAL:=ACCUMBAL+CURRLONG;
		CURRLONG:=0;
		PUTITEM(NlFile,2);
                getitem(nlfile,2); // TGM AB
		PUTITEM(NlFile,3);
                getitem(nlfile,2); // TGM AB
		PUTITEM(NlFile,4);
                getitem(nlfile,2); // TGM AB
		putitem ( NlFile, 22 );
                getitem(nlfile,2); // TGM AB
		IF Cash1.XNOMWEEK THEN PUTITEM(NlFile,6);
	      END;
	    {IF (RECNO=XNOMPRVINC) OR (RECNO=XNOMPRVEXP) THEN}
	    {* include all income Or expenditure accounts }
	    IF (( RECNO >= Cash1.XNOMPRVINC ) And
		( recno <= Cash1.xnomprvinc+Cash11.xno_of_partners )) Or
	       (( RECNO >= Cash1.XNOMPRVEXP ) And
		( recno <= Cash1.xnomprvexp+Cash11.xno_of_partners )) THEN
	      BEGIN
		GETITEM(NlFile,2);
		ACCUMBAL:=ACCUMBAL+CURRLONG;
		CURRLONG:=0;
		PUTITEM(NlFile,2);
                getitem(nlfile,2); // TGM AB
		PUTITEM(NlFile,3);
                getitem(nlfile,2); // TGM AB
		PUTITEM(NlFile,4);
                getitem(nlfile,2); // TGM AB
		putitem ( NlFile, 22 );
                getitem(nlfile,2); // TGM AB
		IF Cash1.XNOMWEEK THEN PUTITEM(NlFile,6);
	      END;
	    ACC:=0;
	    IF CLEARCAP THEN
	      IF  (RECNO>Cash1.XNOMCAFROM-1) AND (RECNO<Cash1.XNOMLITO+1) THEN
		IF ( RECNO-Cash1.XNOMCAFROM+1 >= 1 ) And
                   ( RecNo-Cash1.xNomCAFrom+1 <= CMAX ) Then
		  IF ZEROCAP^[RECNO-Cash1.XNOMCAFROM+1] THEN
		    BEGIN
		      GETITEM(NlFile,2);
		      { IF ALLOCAP[RECNO-XNOMCAFROM+1]=XNOMPROFIT THEN	}
		      {* allow for multi partners }
		      IF (( ALLOCAP^[RECNO-Cash1.XNOMCAFROM+1] >= Cash1.XNOMPROFIT ) And
			  ( allocap^[recno-Cash1.xnomcafrom+1] <=
			    Cash1.xnomprofit+Cash11.xno_of_partners ))  Then
			ACCUMBAL:=ACCUMBAL+CURRLONG
		      ELSE
			BEGIN
			  ACC:=ALLOCAP^[RECNO-Cash1.XNOMCAFROM+1];
			  BAL:=CURRLONG;
			END;
		      CURRLONG:=0;
		      PUTITEM(NlFile,2);
                      getitem(nlfile,2); // TGM AB
		      PUTITEM(NlFile,3);
                      getitem(nlfile,2); // TGM AB
		      PUTITEM(NlFile,4);
                      getitem(nlfile,2); // TGM AB
		      putitem ( NlFile, 22 );
                      getitem(nlfile,2); // TGM AB
		      IF Cash1.XNOMWEEK THEN PUTITEM(NlFile,6);
		    END;
	    REWRITEREC (NlFile,RECNO);
	    IF ERRORNO>0 THEN ERR;
	    IF ACC>0 THEN
	      BEGIN
		READREC (NlFile,ACC);
		IF ERRORNO>0 THEN ERR;
		GETITEM(NlFile,2);
		CURRLONG:=CURRLONG+BAL;
		PUTITEM(NlFile,2);
                getitem(nlfile,2); // TGM AB
		PUTITEM(NlFile,3);
                getitem(nlfile,2); // TGM AB
		PUTITEM(NlFile,4);
                getitem(nlfile,2); // TGM AB
		putitem ( NlFile, 22 );
                getitem(nlfile,2); // TGM AB
		IF Cash1.XNOMWEEK THEN PUTITEM(NlFile,6);
		REWRITEREC (NlFile,ACC);
		IF ERRORNO>0 THEN ERR;
	      END;
	  END;
      END;
    LONGSTR (ACCUMBAL,ST,'L');
    SLIMLEFT (ST);
    NEXTLINE:=NEXTLINE+2;
    READREC (NlFile,Cash1.XNOMPROFIT);
    IF ERRORNO>0 THEN ERR;
    GETITEM(NlFile,2);
    CURRLONG:=CURRLONG+ACCUMBAL;
    PUTITEM(NlFile,2);
    getitem(nlfile,2); // TGM AB
    PUTITEM(NlFile,3);
    getitem(nlfile,2); // TGM AB
    PUTITEM(NlFile,4);
    getitem(nlfile,2); // TGM AB
    PUTITEM(NlFile,22);  // TGM AB
    getitem(nlfile,2); // TGM AB
    IF Cash1.XNOMWEEK THEN PUTITEM(NlFile,6);
    REWRITEREC (NlFile,Cash1.XNOMPROFIT);
    IF ERRORNO>0 THEN ERR;

    LongStr(ACCUMBAL, st, 'L');
    YearEndForm.ProfitLossEdit.Text := st;
  END;

  PROCEDURE SETWEEKLY;
  VAR
    RECNO   : SmallInt;
    OPENBAL : LONG;
    MOVEBAL : LONG;
  BEGIN
    SETDB(NlFile);
    FOR RECNO:=1 TO DB1.DBRECTOT DO
      BEGIN
        READREC (NlFile,RECNO);
	IF ERRORNO>0 THEN ERR;
	IF RECACTIVE(NlFile) THEN
	  BEGIN
	    GETITEM(NlFile,6);
	    OPENBAL:=CURRLONG;
	    GETITEM(NlFile,2);
	    MOVEBAL:=CURRLONG-OPENBAL;
	    PUTITEM(NlFile,6);
	    GETITEM(NlFile,80+Cash1.XWEEKNO);
	    CURRLONG:=CURRLONG+MOVEBAL;
	    PUTITEM(NlFile,80+Cash1.XWEEKNO);
	    REWRITEREC(NlFile,RECNO);
	    IF ERRORNO>0 THEN ERR;
	  END;
      END;
  END;

  PROCEDURE WEEKEND;
  VAR
    ST : STRING80;
    WK : SmallInt;


  BEGIN
    ZEROT   :=FALSE;
    REMOVETX:=FALSE;
    RESETNOM:=FALSE;
    RESETSAL:=FALSE;
    RESETPUR:=FALSE;
    COPYBALS:=FALSE;
    //WE1;
    FLUSH:=FALSE;
    SETWEEKLY;
    FLUSH:=TRUE;
    WK:=Cash1.XWEEKNO+1;
    IF WK>53 THEN WK:=1;
    STR(WK,ST);
    Cash1.XWEEKNO:=WK;
    DEFWRITE(0);
  END;

  PROCEDURE MONTHEND;
  VAR
    ST : STRING80;
    MN : SmallInt;
    OK : BOOLEAN;
    MonthString : ShortString;
    MonthInt : SmallInt;


  BEGIN							   (* begin monthend *)
    ZEROT   :=FALSE;
    // next bit is used to determine if month end removes transactions
{    REMOVETX:=TRUE;
    RESETNOM:=TRUE;
    RESETSAL:=TRUE;
    RESETPUR:=TRUE;}
    if auto_monthend then		  (* carries out monthend at yearend *)
      Begin
	resetnom := true;
	resetsal := true;
	resetpur := true;
	removetx := true;
	keepbank := true;
	copybals := false;
      end;
    FLUSH:=FALSE;
    CLEARTX;
    IF NOT Cash1.XCASHBOOK THEN CARRYFORWARD(SlFile, false);
    IF NOT Cash1.XCASHBOOK THEN CARRYFORWARD(PlFile,false);
    CARRYFORWARD(NlFile, false);
    BANKRESET;
    FLUSH:=TRUE;
    SETDB (NlFile);
    MN:=Cash1.XMONTHNO+1;
    IF MN>12 THEN MN:=1;

    if auto_monthend then
       begin
            Cash1.XMONTHNO := Cash1.XMONTHNO+1;
            Cash1.XMONTHNO:=MonthInt;
            DEFWRITE(0);
       end
    else
       Begin
            MonthString := MonthEndForm.NextMonthNo.Text;
            SlimAll (MonthString);
            MonthInt := StrToInt(MonthString);
            Cash1.XMONTHNO:=MonthInt;
            DEFWRITE(0);
       end;
  END;							     (* end monthend *)

  PROCEDURE YEAREND;
  VAR
    ST	: STRING80;
    YR	: SmallInt;
    OK	: BOOLEAN;
    ACC : SmallInt;


    PROCEDURE YE1;
    BEGIN

      NEXTLINE:= 15 {7};

      //IF CLEARCAP THEN YELIST;
    END;


  BEGIN
    prog := endyear;

    ZEROT:=TRUE;
    YE1;

  {  IF NOT Cash1.XCASHBOOK THEN} ZEROTURN(SLFile);               // TGM AB 13/10/17 - removed limitation to zero turnover on ledger systems only
  {  IF NOT Cash1.XCASHBOOK THEN} ZEROTURN(PlFile);               // TGM AB 13/10/17 - removed limitation to zero turnover on ledger systems only
    
    CARRYNOMINAL;
    FLUSH:=TRUE;

    DEFREAD(0);

    YR:=Cash1.XFINYEAR+1;
    STR(YR,ST);

    { Store New Year and Set Current Month to financial year start month no }
    Cash1.XFINYEAR := YR;
    Cash1.XMONTHNO := Cash1.XFINMONTH;

    DEFWRITE(0);

    {* read & clear the analysis file }
    (*
    if xtxanal then
      Begin
	openfiles;
	clearanl;
      End;
    *)

    { Clear the invoices sub dir. }
    {
    ClearInvoice;
    }

  END;

BEGIN
  auto_monthend := false;
  {
  OPENFILES;
  }
  NewMemory;
  CASE PROG OF
    ENDWEEK  : WEEKEND;
    ENDMONTH :
        begin
             RemoveTx := not(Cash1.xKeepTran);
             ResetNom := Cash1.xResetNom;
             ResetSal := Cash11.xResetSales;
             ResetPur := Cash11.xResetPurchases;

             CopyBals := MonthendForm.CopyToBudgets.Checked;
             KeepBank := MonthendForm.RetainBanksCheck.Checked;
             GridLoop;
             MONTHEND;
        end;
    ENDYEAR :
        Begin
              CopyBals := YearEndForm.CopyBalanceCheck.Checked;
              ClearCap := YearEndForm.ClearCapitolCheck.Checked;
              If YearEndForm.FinalEndCheck.Checked Then
                 Begin
                      removetx := true;
                      resetnom := true;	  { reset pointer nominal }
                      resetsal := true;	  { reset sales ledger pointer }
	              resetpur := true;	  { reset purchase ledger pointer }
	              keepbank := true;
	              cleartx;
      	              if NOT Cash1.xcashbook then carryforward ( SlFile, true );
	              if NOT Cash1.xcashbook then carryforward ( PlFile, true );
	              carryforward ( NlFile, true );
	              bankreset;
                  End
              Else
                  Begin
                      auto_monthend := true;
                      monthend;
                  End;
              YearLoop;
              YEAREND;
              // Clear out the ProdTx.db file
              if NOT Cash11.xBilling then
                 ClearProductTransactions;

        End;
  END;
  DisposeMemory;
END;

End.

