{
   04/03/11 - Fix For Tom O'Keeffe Bug On CostPerUnitReport
}

unit FullAudit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Gauges, ExtCtrls, Buttons, Mask, ComCtrls,vars,types,params,shellapi;

  procedure RunAuditFiles( FlNo : Integer; FromAcc, ToAcc, LowTx, LowDt : Integer; SetFirstTX:Boolean );
  
type
  TAuditFiles = class(TForm)
    pAuditFiles: TPanel;
    Panel1: TPanel;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    EarliestDateLabel: TLabel;
    Label11: TLabel;
    Label16: TLabel;
    ProgressBar: TGauge;
    ProgressLabel: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    PassMask: TEdit;
    SalesPanel: TPanel;
    Label7: TLabel;
    SalesFromButton: TSpeedButton;
    Label9: TLabel;
    SalesToButton: TSpeedButton;
    ResetSales: TCheckBox;
    SalesFrom: TEdit;
    SalesTo: TEdit;
    PurchasePanel: TPanel;
    Label5: TLabel;
    PurchaseFromButton: TSpeedButton;
    Label6: TLabel;
    PurchaseToButton: TSpeedButton;
    ResetPurchase: TCheckBox;
    PurchaseFrom: TEdit;
    PurchaseTo: TEdit;
    Panel5: TPanel;
    NomAccFromButton: TSpeedButton;
    NomAccToButton: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    ResetNominal: TCheckBox;
    NomAccFrom: TEdit;
    NomAccTo: TEdit;
    LowestTx: TMaskEdit;
    EarliestDate: TMaskEdit;
    EarliestDateButton: TDateTimePicker;
    ResetFirstGroup: TRadioGroup;
    Button1: TButton;
    cbshowtx1: TCheckBox;
    Button2: TButton;
    RecalcMonths: TButton;
    Panel3: TPanel;
    bExit: TBitBtn;
    ConfirmBtn: TBitBtn;
    BitBtn1: TBitBtn;
    RadioButton1: TRadioButton;
    Panel4: TPanel;
    salesbtn: TButton;
    nominalbtn: TButton;
    Purchasebtn: TButton;
    checkbtn: TButton;
    IncludeDetailedCB: TCheckBox;
    Panel2: TPanel;
    ProgressBar2: TGauge;
    progressLabel2: TLabel;
    procedure NomAccFromButtonClick(Sender: TObject);
    procedure NomAccToButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SalesToDblClick(Sender: TObject);
    procedure SalesFromDblClick(Sender: TObject);
    procedure PurchaseFromDblClick(Sender: TObject);
    procedure PurchaseToDblClick(Sender: TObject);
    procedure EarliestDateButtonCloseUp(Sender: TObject);
    procedure LowestTxChange(Sender: TObject);
    procedure EarliestDateExit(Sender: TObject);
    procedure ConfirmBtnClick(Sender: TObject);
    procedure bExitClick(Sender: TObject);
    procedure PassMaskKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ResetFirstGroupClick(Sender: TObject);
    procedure button1Click(Sender: TObject);
    procedure salesbtnClick(Sender: TObject);
    Function NLbalancesOK(Writereport,testingonly: boolean;TestValue:smallint):boolean;
    Function Error(Sender: TObject): boolean;
    procedure checkbtnClick(Sender: TObject);
    Function PurchaseLedgersOK(Writereport: boolean): boolean;
    Function SaleLedgersOK(Writereport: boolean): boolean;
    Function Missingaccounts(Writereport: boolean): boolean;
    Function BlankFields(Writereport : boolean): boolean;
    Function DeleteBlankRecords(Writereport : boolean): boolean;
    procedure PurchasebtnClick(Sender: TObject);
    procedure nominalbtnClick(Sender: TObject);
    Function Controlaccountsmatch (writereport: boolean): boolean;
    procedure BitBtn1Click(Sender: TObject);
    Function FirstTxThisYear: SmallInt;
    function testforfirsttx: smallint;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure RecalcMonthsClick(Sender: TObject);
    function MissingTxs(Writereport: boolean): boolean;                     // TGM AB 18/09/15
    function InvoiceTypeOK(InvoiceType, RecordNo : Integer): boolean;       // TGM AB 18/09/15
    function CashbookTypeOK(CashbookType, RecordNo : Integer): boolean;     // TGM AB 09/10/15
    function CreditNoteTypeOK(CreditNoteType, RecordNo : Integer): boolean; // TGM AB 16/10/15
    function PaymentTypeOK(PaymentType, RecordNo : Integer): boolean;       // TGM AB 13/10/15
    function OthersTypeOK(RecordNo : Integer): boolean;                     // TGM AB 15/01/16
    Function FirstTxLastYear: SmallInt;                                     // TGM AB 18/10/16

  private
    { Private declarations }
    FLogFilePath : string;
    FActivateCount,
    FPurchAccountFrom,
    FPurchAccountTo : Integer;
    function CheckAllParameters ( Var FromNom, ToNom,
                                      FromSales, ToSales,
                                      FromPurchase, ToPurchase,
                                      LowTx, LowDt : Integer ) : Boolean;
  public

    { Public declarations }
  end;

{var
  AuditFiles: TAuditFiles;
  logfile:textfile;}

type ArrayRec = record
                  balance:biglong;
                  firsttx:integer;
                  end;
type ledgerrec = record
                   amount:biglong;
                   invoice:boolean;
                  end;

type accountrec = record
                   inuse : boolean;
                  end;
type NomRec = record
                  balance_st:biglong;
                  st_year:biglong;
                  firsttx:integer;
                  end;

var
    AuditFiles: TAuditFiles;
    RECNO : INTEGER;
    TXT	  : INTEGER;
    DBAC  : INTEGER;
    CRAC  : INTEGER;
    ACCREC: INTEGER;
    OK	  : BOOLEAN;
    TempAmount,TempNomAmount:BigLong;
    filecount     : Integer;
    DataArray:array[1..9999] of ArrayRec;
    SLLedgerArray:array[1..9999] of LedgerRec;
    PLLedgerArray:array[1..9999] of LedgerRec;
    Accountarray:array[1..9999] of accountrec;
    nominalarray:array[1..999] of nomrec;
    TxType,db,cr,acc: integer;
    balance_st,nom_amount,first_tx, amount, tax: biglong;
    Logfile, testfile:textfile;
    sltotalbalance, pltotalbalance, pldiff, sldiff, OpeningNetWorthDiff: biglong;
    sltotalbalanceStartYear, pltotalbalanceStartYear, pldiffStartYear, sldiffStartYear : biglong;
    TrialBalanceDifference, StartYearTrialBalanceDifference : biglong;
    Opening_recno, credit_recno, debit_recno: integer;
    age_1, age_2, age_3, age_curr: biglong;
    tempstr: string;
    DataProblem:boolean;
    FirstTransactionOfYear : smallint; //TGM AB 09/01/15




implementation
Uses
    UTIL,
    DBCore,
    NewListing,
    Calcs,
    accsdata,
    Clears,
    DataExport,
    defsecfl,
    Mainunit,  // TGM AB 4/07/02 - for paradox table export test button
    CalculateMonths,
    uNotepad;


{$R *.DFM}

{
FlNo is the Database No i.e. Nlfile, PlFile, SlFile
FromAcc, ToAcc are the Account Ranges
LowTx is the Lowest transaction to include
LowDt is the Lowest Date to Include
}

// gm wrote function below to get the first tx this year by checking all nominals for the lowest value in item 15 (First-tx)
Function Tauditfiles.FirstTxThisYear: SmallInt;
var
i: integer;
firstyear : integer;
FirstNL, FirstSL, FirstPL : integer;
begin
     OnActivate(nil);
     OnShow(nil);
     firstyear := Accsdatamodule.TransactionsDB.RecordCount+1;  // was 32001
     if cbshowtx1.checked then firstyear := 1;

     FirstNL := 0;
     FirstSL := 0;
     FirstPL := 0;

     Accsdatamodule.FirstTxQuery.SQL.text := 'select firsttx from nlfile group by firsttx';
     Accsdatamodule.FirstTxQuery.open;//ExecSQL;
     Accsdatamodule.FirstTxQuery.active := true;
     FirstNL := Accsdatamodule.FirstTxQuery['FirstTx'];
     if FirstNL = 0 then begin
         try Accsdatamodule.FirstTxQuery.next;
             FirstNL := Accsdatamodule.FirstTxQuery['FirstTx'];
         except
         end;
     end;
     if ((FirstNL < firstyear) and (FirstNL <> 0)) then firstyear := FirstNL;
     Accsdatamodule.FirstTxQuery.active := false;

     Accsdatamodule.FirstTxQuery.SQL.text := 'select firsttx from slfile group by firsttx';
     Accsdatamodule.FirstTxQuery.open;//ExecSQL;
     Accsdatamodule.FirstTxQuery.active := true;
     try FirstSL := Accsdatamodule.FirstTxQuery['FirstTx'];
     except
     end; // TGM AB Cope with empty files
     if FirstSL = 0 then begin
         try Accsdatamodule.FirstTxQuery.next;
             FirstSL := Accsdatamodule.FirstTxQuery['FirstTx'];
         except
         end;
     end;
     if ((FirstSL < firstyear) and (FirstSL <> 0)) then firstyear := FirstSL;
     Accsdatamodule.FirstTxQuery.active := false;


     Accsdatamodule.FirstTxQuery.SQL.text := 'select firstyear from slfile group by firstyear';
     Accsdatamodule.FirstTxQuery.open;//ExecSQL;
     Accsdatamodule.FirstTxQuery.active := true;
     try FirstSL := Accsdatamodule.FirstTxQuery['FirstYear'];
     except
     end; // TGM AB Cope with empty files
     if FirstSL = 0 then begin
         try Accsdatamodule.FirstTxQuery.next;
             FirstSL := Accsdatamodule.FirstTxQuery['FirstYear'];
         except
         end;
     end;
     if ((FirstSL < firstyear) and (FirstSL <> 0)) then firstyear := FirstSL;
     Accsdatamodule.FirstTxQuery.active := false;



     Accsdatamodule.FirstTxQuery.SQL.text := 'select firsttx from plfile group by firsttx';
     Accsdatamodule.FirstTxQuery.open;//ExecSQL;
     Accsdatamodule.FirstTxQuery.active := true;
     try FirstPL := Accsdatamodule.FirstTxQuery['FirstTx'];                               // TGM AB 18/10/16
     except
     end; // TGM AB Cope with empty files
     if FirstPL = 0 then begin                                                            // TGM AB 18/10/16
         try Accsdatamodule.FirstTxQuery.next;
             FirstPL := Accsdatamodule.FirstTxQuery['FirstTx'];                           // TGM AB 18/10/16
         except
         end;
     end;
     if ((FirstPL < firstyear) and (FirstPL <> 0)) then firstyear := FirstPL;
     Accsdatamodule.FirstTxQuery.active := false;


     Accsdatamodule.FirstTxQuery.SQL.text := 'select firstyear from plfile group by firstyear';
     Accsdatamodule.FirstTxQuery.open;//ExecSQL;
     Accsdatamodule.FirstTxQuery.active := true;
     try FirstPL := Accsdatamodule.FirstTxQuery['FirstYear'];                               // TGM AB 18/10/16
     except
     end; // TGM AB Cope with empty files
     if FirstPL = 0 then begin                                                              // TGM AB 18/10/16
         try Accsdatamodule.FirstTxQuery.next;
             FirstPL := Accsdatamodule.FirstTxQuery['FirstYear'];                           // TGM AB 18/10/16
         except
         end;
     end;
     if ((FirstPL < firstyear) and (FirstPL <> 0)) then firstyear := FirstPL;
     Accsdatamodule.FirstTxQuery.active := false;

     // 04/03/11 - Fix For Tom O'Keeffe Bug On CostPerUnitReport
     result := firstyear;
     if result > 1 then begin
        SETDB (txfile);
        READREC(txfile,result-1);
        try Getitem(TxFile,1);
            if ((Currint = 1) or (Currint = 3) or (Currint = 5) or (Currint = 7) or (Currint = 11) or (Currint = 15)) then result := result - 1;
        except
        end;
     end;
     xFirstTx := result;
end;

function TAuditFiles.testforfirsttx: smallint;
var i:integer;
    startfound:boolean;
begin
       StartFound := false;

       FOR i:=1 TO 300 do
           if not StartFound then
           if nlbalancesOK(false,true,i) then begin
              showmessage(IntToStr(i));
              StartFound := true;
           end;
       if not startfound then showmessage('first tx not found in the first 300 transactions');
           {BEGIN
           READREC(SlFile,RECNO);
	   IF RECACTIVE(txfile) THEN BEGIN
               GetItem(SLFile,14);        //First-year
               if ((currint < firstyear) and (currint <> 0)) then firstyear := currint;
               GetItem(SLFile,15);        //First-year
               if ((currint < firstyear) and (currint <> 0)) then firstyear := currint;

           end;
       end;}

end;



Function TAuditfiles.NLbalancesOK(Writereport,TestingOnly: boolean;testvalue:SmallInt): boolean;
         // writereport used as flag to enabling / disabling writing
         // errors out to log file

         // Checks Both Trial Balance and balances of each nominal code

         // Reports any accounts that have no transactions but balance-st
         // does not equal St-year.
var
I: integer;
Tempstr : string;
begin

       Result := true;
       TrialBalanceDifference:=0;
       StartYearTrialBalanceDifference:=0;

  for i:=1 to 999 do begin
       nominalarray[i].balance_st:=0;
       nominalarray[i].st_year:=0;
       nominalarray[i].firsttx:=0;
  end;
       SETDB (NlFile);
       ProgressLabel2.Caption := 'Checking Data - NL Phase (Getting Starting Balances)';
       ProgressLabel2.ReFresh;

       FOR RecNo:=StrToInt(NomAccFrom.text) TO StrToInt(NomAccTo.text) DO
           BEGIN

           AccsDataModule.NLFileDB.Locate('NLNo',RecNo,[]);
	   IF AccsDataModule.NLFileDB['Active'] = True THEN BEGIN
     //          GetItem(NLFile,22);        //Balance St
               nominalarray[RecNo].balance_st:= (AccsDataModule.NLFileDB['BalanceST']* 100);      //Currlong;
     //          GetItem(NLFile,4);        //St year
               nominalarray[RecNo].st_year:= (AccsDataModule.NLFileDB['STYear']* 100);   //Currlong;
               if testingOnly then nominalarray[RecNo].firsttx:=testvalue
               else begin
     //          GetItem(NLFile,15);        // First-Tx - first transaction in current year
                  nominalarray[RecNo].firsttx:= AccsDataModule.NLFileDB['FirstTX'] //currint;
               end;
     //          Getitem(NlFile,16); // Last Tx
               if AccsDataModule.NLFileDB['LastTX'] = 0 then begin // currint;
                  if nominalarray[RecNo].balance_st <> nominalarray[RecNo].st_year then begin
                     //if  MessageDlg('Nominal Account ' + vartostr(recno) + ' has no transactions, but balance-st <> St-Year.  Automatically fix this now?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
                       //  Getitem(NlFile,4);  // ST Year
                       //  Putitem(NLFile,22); // BalanceST
                       //  REWRITEREC(NLFile,RecNo);
                        AccsDataModule.NLFileDB.edit;
                        AccsDataModule.NLFileDB['STYear'] := AccsDataModule.NLFileDB['BalanceST'];
                        AccsDataModule.NLFileDB.Post;
                        if writereport then writeln(logfile, 'Nominal Account ' + vartostr(recno) + ' had no transactions, but balance-st <> St-Year, This was automatically fixed by setting Balance-St equal to St-Year.');
                  end;
               end;
           end; // if active
       end; // begin

     // Getting Values From Tx File
       SETDB (TxFile);
       ProgressLabel2.Caption := 'Checking Data - NL Phase (Calculating Balances)';
       ProgressLabel2.ReFresh;

       AccsDataModule.TransactionsDB.last;

       FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO
           BEGIN
       //    READREC(TxFile,RECNO);
       //    getitem(Txfile,28);
       //	   IF (RECACTIVE(TxFile) and not (currstr[1] in ['E','R'])) THEN     // TGM AB 6/6/02
           IF ((AccsDataModule.TransactionsDB['EditStat'] <> 'E') and (AccsDataModule.TransactionsDB['EditStat'] <> 'R')) THEN
              BEGIN
              // getitem(TxFile,1);
              TxType:= AccsDataModule.TransactionsDB['TxType'];  //currint;

              // getitem(Txfile,18);        // Debit-Ac
              db:= AccsDataModule.TransactionsDB['DebitAC']; //currint;

              // getitem(Txfile,19);        // Credit-Ac
              cr:=AccsDataModule.TransactionsDB['CreditAC']; //currint;

              // getitem(TxFile,17);        // nom-amount
              nom_amount:=(AccsDataModule.TransactionsDB['NomAmount']*100); //currlong;

              // transaction number is same as the RecNo
              // updating account balance in array by transaction amount
              first_tx:=nominalarray[db].firsttx;      // reads in first transaction for the current year for debit account
              if ((first_tx > 0) and  (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
              begin
                   nominalarray[db].balance_st:=nominalarray[db].balance_st + nom_amount;
                   nominalarray[db].st_year:=nominalarray[db].st_year + nom_amount; // updating (adding) account balance with non amount
              end;
              first_tx:=nominalarray[cr].firsttx;      // same for credit account
              if ((first_tx > 0) and  (RecNo>=first_tx)) then
              begin
                   nominalarray[cr].balance_st:=nominalarray[cr].balance_st - nom_amount;
                   nominalarray[cr].st_year:=nominalarray[cr].st_year - nom_amount;// subtracting from credit account balance
              end;
           end; // active
           AccsDataModule.TransactionsDB.prior;
       end; // for



   // Comparing Balances
       SETDB (NlFile);
       ProgressLabel2.Caption := 'Checking Data - NL Phase (Comparing Balances)';
       ProgressLabel2.ReFresh;
       AccsDataModule.NLFileDB.First;


       FOR RecNo:=StrToInt(NomAccFrom.text) TO StrToInt(NomAccTo.text) DO
           BEGIN
           ProgressBar2.Progress := ProgressBar2.Progress + 1;
          // READREC(NlFile,RECNO);
          Accsdatamodule.NLFileDB.locate('NLNo',RecNo,[]);
	   IF RECACTIVE(NlFile) THEN BEGIN
          //     Getitem(NlFile,4);    // ST-YEAR
               if cash11.xno_of_partners > 0 then
               if ((recno > (cash1.xNomPrvinc + cash11.xno_of_partners+1 )) and (recno < (cash1.xNomPrvInc + 10)) and (accsdatamodule.NLFileDB['STYear'] <> 0)) then begin //currlong
                  writeln(Logfile,'Nominal Account ' + VarToStr(RecNo) + ' has a balance in the ST-YEAR field in NLACCS.  This code is outside the allowable range and should not have ever been used');
                  writeLn(LogFile, 'This problem occurs one of the extra limited company private income codes has accidentally been used when it shouldn''t have been.');
               end;
               if cash11.xno_of_partners > 0 then
               if ((recno > (cash1.xNomPrvExp + cash11.xno_of_partners+1 )) and (recno < (cash1.xNomPrvExp + 10)) and (accsdatamodule.NLFileDB['STYear'] <> 0)) then begin
                  writeln(Logfile,'Nominal Account ' + VarToStr(RecNo) + ' has a balance in the ST-YEAR field in NLACCS.  This code is outside the allowable range and should not have ever been used');
                  writeLn(LogFile, 'This problem occurs one of the extra limited company private expenditure codes has accidentally been used when it shouldn''t have been.');
               end;

               StartYearTrialBalanceDifference:=StartYearTrialBalanceDifference + (100*accsdatamodule.NLFileDB['STYear']); //currlong;
              // Getitem(NlFile,2);    // Balance of account - Array Has Calculated Balance
               if cash11.xno_of_partners > 0 then
               if ((recno > (cash1.xNomPrvinc + cash11.xno_of_partners+1 )) and (recno < (cash1.xNomPrvInc + 10)) and (accsdatamodule.NLFileDB['Balance'] <> 0)) then begin
                  writeln(Logfile,'Nominal Account ' + VarToStr(RecNo) + ' has a balance in the BALANCE field in NLACCS.  This code is outside the allowable range and should not have ever been used');
                  writeLn(LogFile, 'This problem occurs one of the extra limited company private income codes has accidentally been used when it shouldn''t have been.');
               end;
               if cash11.xno_of_partners > 0 then
               if ((recno > (cash1.xNomPrvExp + cash11.xno_of_partners+1 )) and (recno < (cash1.xNomPrvExp + 10)) and (accsdatamodule.NLFileDB['Balance'] <> 0)) then begin
                  writeln(Logfile,'Nominal Account ' + VarToStr(RecNo) + ' has a balance in the BALANCE field in NLACCS.  This code is outside the allowable range and should not have ever been used');
                  writeLn(LogFile, 'This problem occurs one of the extra limited company private expenditure codes has accidentally been used when it shouldn''t have been.');
               end;

               TrialBalanceDifference:=TrialBalanceDifference + (100*accsdatamodule.NLFileDB['Balance']); //currlong;

               // above line is adding up the sum of all nominal balances (if =0 then trial balance balances)
               if ((strtoint(vartostr((100*accsdatamodule.NLFileDB['Balance']))) - nominalarray[RecNo].balance_st <> 0)) then begin
                  //Result:=false;
                  //if writereport then writeln(Logfile,'Error - Nominal Account ' + VarToStr(RecNo) + ' Has Balance Difference of ' + VarToStr((currlong - nominalarray[RecNo].balance_st)/100) + ' Using Balance-st');
                  if (((100*accsdatamodule.NLFileDB['Balance']) - nominalarray[RecNo].st_year = 0) and (not testingOnly )) then begin
                     //if  MessageDlg('Using Balance-st, Nominal Account ' + VarToStr(RecNo) + ' has the wrong total.  This can be fixed by setting BALANCE-ST to the same as ST-YEAR.  Do you want to fix this account now? ',mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
                     //begin
                       //  Getitem(NlFile,4);
                       //  Putitem(NLFile,22);
                         accsdatamodule.NLFileDB.edit;
                         accsdatamodule.NLFileDB['BalanceST'] := accsdatamodule.NLFileDB['STYear'];
                       //  REWRITEREC(NLFile,RecNo);
                         if writereport then begin
                                         writeln(Logfile,'Using St-Year, Nominal Account ' + VarToStr(RecNo) + ' is OK, so Balance_st has been set to be the same as St-Year');
                                         //writeLn(LogFile, 'Please run Data Integrity Check again to check that the problem has been fixed.');
                                         end;
                     //end;

                  end else begin
                      Result:=false;
                      Accsdatamodule.NLFileDB.locate('NLNo',RecNo,[]);
                      if writereport then writeln(Logfile,'Error - Nominal Account ' + VarToStr(RecNo) + ' Has Balance Difference between the nominal audit trail running balance and the trial balance total (BALANCE field in NLACCS) ' + VarToStr(((100*accsdatamodule.NLFileDB['Balance']) - nominalarray[RecNo].balance_st)/100) + ' Using Balance-st');
                      if writereport then writeln(Logfile,'Error - Nominal Account ' + VarToStr(RecNo) + ' Has Balance Difference between the nominal audit trail running balance and the trial balance total (BALANCE field in NLACCS) ' + VarToStr(((100*accsdatamodule.NLFileDB['Balance']) - nominalarray[RecNo].st_year)/100) + ' Using St-Year');
                      if writereport then writeln(Logfile,'This error is normally due to pointers being set incorrectly.  You must determine the first transaction of the current year and then reset pointers for nominals, entering this transaction number as the first transaction');
                      if writereport then writeln(Logfile,'Run the Data Integrity Check again, after resetting pointers');
                      if writereport then writeln(Logfile);
               end;

           end;
       end;
   end;

       If TrialBalanceDifference <> 0 then begin           // <> 0 then trial balance does not balance
                                      Result:=false;
                                      if writereport then begin
                                                          WriteLn(logfile,'');
                                                          WriteLn(Logfile,'Trial Balance Difference is ' + VarToStr((TrialBalanceDifference)/100));
                                                          WriteLn(LogFile,'Trial Balance Difference carried forward from last year is ' + VarToStr((StartYearTrialBalanceDifference)/100));
                                                          if TrialBalanceDifference = StartYearTrialBalanceDifference then begin
                                                             writeln(Logfile,'The current trial balance difference is the same as that at the end of last year.');
                                                             writeLn(Logfile, 'The error now shown may be the result of:');
                                                             writeLn(Logfile, ' 1. a carry over from last year, in which case adjusting the P/L brought forward will resolve the problem.');
                                                             writeLn(LogFile, ' 2. an active nominal code has somehow been deleted.  You need to manually check that all the codes used last year are still in use this year');
                                                             writeLn(LogFile, ' 3. A Code such as one of the extra private income/expenditure codes used for Limited Companies has been used for a transaction.');
                                                             writeln(LogFile);
                                                          end else begin
                                                             writeln(LogFile,'The current trial balance difference is not the same as that brought forward from last year');
                                                             writeln(LogFile,'The first thing to look for is missing nominals - if some transactions have a missing nominal report,');
                                                             writeln(LogFile,'fix these transactions and then run the data integrity check again');
                                                             writeln(LogFile, 'If there are no missing nominal problems, the repair nominal balances button will set the trial balance');
                                                             writeln(LogFile,'Nominal totals to match the running balance in the nominal audit trail.  It is essential before using the ');
                                                             writeln(LogFile,'Repair Nominals button that you''re sure that no missing nominals are reported and that the trial balance error is ');
                                                             writeln(LogFile,'not a carry forward problem from last year');
                                                             writeln(LogFile);
                                                          end;

                                                          end;
                                      end;

end;

Function TAuditfiles.PurchaseLedgersOK(Writereport: boolean): boolean;

         // uses Writereport as flag to enable / disable the writing to the logfile

         // checks the running balance of each Pl account

         // builds an array of calculated blances and compares against the stored values

var
   i: integer;
begin
     result := true;

   for i:=1 to 9999 do begin
       dataarray[i].balance:=0;
       dataarray[i].firsttx:=0;
   end;

       SETDB (PlFile);
       ProgressLabel2.Caption := 'Checking Data - PL Phase (Getting Starting Balances)';
       ProgressLabel2.ReFresh;

       FOR RecNo:= FPurchAccountFrom TO FPurchAccountTo DO
           BEGIN
           READREC(PlFile,RECNO);
	   IF RECACTIVE(PlFile) THEN BEGIN
               GetItem(PLFile,17);        //Balance-St - balance Start
               DataArray[RecNo].balance:=Currlong;
               GetItem(PLFile,14);        // First-year - first transaction in current year
               if currint = 0 then Getitem(PlFile,15); //if first-year = 0 then use first-tx instead
               DataArray[RecNo].firsttx:=currint;
           end;
       end;


       // Getting Values From Tx File

       SETDB (TxFile);
       ProgressLabel2.Caption := 'Checking Data - PL Phase (Calculating Balances)';
       ProgressLabel2.ReFresh;

       FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO
           BEGIN
           READREC(TxFile,RECNO);
           getitem(Txfile,28);
	   IF ((RECACTIVE(TxFile)) and not (currstr[1] in ['E','R'])) THEN BEGIN  // TGM AB 6/6/02
	 //  IF RECACTIVE(TxFile) THEN BEGIN
              getitem(TxFile,1);
              TxType:=currint;

              if (TxType = 5) then
                 begin
                 getitem(Txfile,3);        // account
                 acc:=currint;
                 getitem(TxFile,9);        // amount
                 amount:=currlong;
                 getitem(Txfile,11);       //Tax/Disc
                 tax:=currlong;
                 // transaction number is same as the RecNo
                 // updating account balance by transaction amount
                 first_tx:=DataArray[acc].firsttx;      // reads in first transaction for the current year
                 if ((first_tx > 0) and (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
                    begin
                    DataArray[acc].balance:=DataArray[acc].balance + amount + tax; // adding amount to account balance
                    end;

                 end;



              if (TxType = 6) then
                 begin
                 getitem(Txfile,3);        // account
                 acc:=currint;
                 getitem(TxFile,9);        // amount
                 amount:=currlong;
                 getitem(Txfile,11);       //Tax/Disc
                 tax:=currlong;
                 // transaction number is same as the RecNo
                 // updating account balance by transaction amount
                 first_tx:=DataArray[acc].firsttx;      // reads in first transaction for the current year for debit account
                 if ((first_tx > 0) and (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
                    begin
                    DataArray[acc].balance:=DataArray[acc].balance - amount - tax; // subtracting amount to account balance
                    end;

                 end;



              if (TxType = 7) then
                 begin
                 getitem(Txfile,3);        // account
                 acc:=currint;
                 getitem(TxFile,9);        // amount
                 amount:=currlong;
                 getitem(Txfile,11);       //Tax/Disc
                 tax:=currlong;
                 // transaction number is same as the RecNo
                 // updating account balance by transaction amount
                 first_tx:=DataArray[acc].firsttx;      // reads in first transaction for the current year for debit account
                 if ((first_tx > 0) and (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
                    begin
                    DataArray[acc].balance:=DataArray[acc].balance + amount + tax; // adding amount to account balance
                    end;

                 end;

              end;
           end;


               // comparing the array to Pl file values
       SETDB (PlFile);
       ProgressLabel2.Caption := 'Checking Data - PL Phase (Comparing Balances)';

       FOR RecNo:= FPurchAccountFrom TO FPurchAccountTo DO
           BEGIN
           ProgressBar2.Progress := ProgressBar2.Progress + 1;
           READREC(PlFile,RECNO);
	   IF RECACTIVE(PlFile) THEN BEGIN
               Getitem(PlFile,7);    // Balance of account - Array Has Calculated Balance
               if ((currlong - DataArray[RecNo].balance <> 0)) then begin
                  if writereport then writeln(Logfile,'Error - Purchase Account ' + VarToStr(RecNo) + ' Has Balance Difference of ' + VarToStr((currlong - DataArray[RecNo].balance)/100));
                  Result:=False;
                  end;
           end;
       end;

end;


Function TAuditfiles.SaleLedgersOK(Writereport: boolean): boolean;

         // uses Writereport as flag to enable / disable the writing to the logfile

         // checks the running balance of each Pl account

         // builds an array of calculated blances and compares against the stored values
var
   i : integer;
begin
       Result := true;
       for i:=1 to 9999 do begin
       dataarray[i].balance:=0;
       dataarray[i].firsttx:=0;
       end;


       SETDB (SlFile);
       ProgressLabel2.Caption := 'Checking Data - SL Phase (Getting Balances)';
       ProgressLabel2.ReFresh;


       FOR RecNo:=StrToInt(SalesFrom.text) TO StrToInt(SalesTo.text) DO
           BEGIN
           READREC(SlFile,RECNO);
	   IF RECACTIVE(SlFile) THEN BEGIN
               GetItem(SLFile,17);        //Balance-St - balance start
               DataArray[RecNo].balance:=Currlong;
               GetItem(SLFile,14);        // First-year - first transaction in current year
               if currint = 0 then Getitem(SlFile,15); //if first-year = 0 then use first-tx instead
               DataArray[RecNo].firsttx:=currint;
           end;

       end;

       // Getting Values From Tx File
       SETDB (TxFile);
       ProgressLabel2.Caption := 'Checking Data - SL Phase (Calculating Balances)';
       ProgressLabel2.ReFresh;

       FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO
          try
             ProgressBar2.Progress := ProgressBar2.Progress + 1;
             READREC(TxFile,RECNO);
             getitem(Txfile,28);
             IF ((RECACTIVE(TxFile)) and not (currstr[1] in ['E','R'])) THEN BEGIN  // TGM AB 6/6/02
           //  IF RECACTIVE(TxFile) THEN BEGIN
                getitem(TxFile,1);
                TxType:=currint;
                if (TxType = 1) then
                   begin
                   getitem(Txfile,3);        // account
                   acc:=currint;
                   getitem(TxFile,9);        // amount
                   amount:=currlong;
                   getitem(Txfile,11);       //Tax/Disc
                   tax:=currlong;
                   // transaction number is same as the RecNo
                   // updating account balance by transaction amount
                   first_tx:=DataArray[acc].firsttx;      // reads in first transaction for the current year for debit account
                   // tgm 28/02/02
                   if ((first_tx >0) and (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
                      begin
                      DataArray[acc].balance:=DataArray[acc].balance + amount + tax; // adding amount to account balance
                      end;

                   end;


                if (TxType = 2) then
                   begin
                   getitem(Txfile,3);        // account
                   acc:=currint;
                   getitem(TxFile,9);        // amount
                   amount:=currlong;
                   getitem(Txfile,11);       //Tax/Disc
                   tax:=currlong;
                   // transaction number is same as the RecNo
                   // updating account balance by transaction amount
                   first_tx:=DataArray[acc].firsttx;      // reads in first transaction for the current year for debit account
                   if ((first_tx > 0) and (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
                      begin
                      DataArray[acc].balance:=DataArray[acc].balance - amount - tax; // subtraction amount from account balance
                      end;

                   end;


                if (TxType = 3) then
                   begin
                   getitem(Txfile,3);        // account
                   acc:=currint;
                   getitem(TxFile,9);        // amount
                   amount:=currlong;
                   getitem(Txfile,11);       //Tax/Disc
                   tax:=currlong;
                   // transaction number is same as the RecNo
                   // updating account balance by transaction amount
                   first_tx:=DataArray[acc].firsttx;      // reads in first transaction for the current year for debit account
                   if ((first_tx > 0) and (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
                      begin
                      DataArray[acc].balance:=DataArray[acc].balance + amount + tax; // adding amount to account balance
                      end;

                   end;

                end;
          except
          end;

       // checking the array with Sl values
       SETDB (SlFile);
       ProgressLabel2.Caption := 'Checking Data - SL Phase (Comparing Balances)';
       ProgressLabel2.ReFresh;


       FOR RecNo:=StrToInt(SalesFrom.text) TO StrToInt(SalesTo.text) DO
           BEGIN
           READREC(SlFile,RECNO);
	   IF RECACTIVE(SlFile) THEN BEGIN
               currlong:=DataArray[RecNo].balance;
               sltotalbalance:=sltotalbalance + currlong;
               GetItem(SlFile,7);
               if ((currlong - DataArray[RecNo].balance <> 0)) then begin
                  if writereport then writeln(Logfile,'Error - Sale Account ' + VarToStr(RecNo) + ' Has Balance Difference of ' + VarToStr((currlong - DataArray[RecNo].balance)/100));
                  Result:=false;
                  end;

           end;
       end;

end;



Function TAuditfiles.Error(Sender: TObject): Boolean;
         // Error function (implemented by original code - only used to avoid large scale changing of original code))
Begin
     showmessage('Error - Please Contact Kingswood');
end;

Procedure RunAuditFiles ( FlNo : Integer; FromAcc, ToAcc, LowTx, LowDt : Integer; SetFirstTX:Boolean );
CONST
  AUDITMAX = 9999;
VAR
  PFIRST  : PACKED ARRAY[1..AUDITMAX] OF SmallInt;
  PLAST	  : PACKED ARRAY[1..AUDITMAX] OF SmallInt;
  NEXTTX  : PACKED ARRAY[1..AUDITMAX] OF SmallInt;

  PROCEDURE INIT;
  VAR
    X : INTEGER;
  BEGIN
    // Initialise the Arrays
    FOR X:=1 TO AUDITMAX DO
      BEGIN
	PFIRST[X]:=0;
	PLAST[X]:=0;
	NEXTTX[X]:=0;
      END;
  END;

  PROCEDURE ERR;
  BEGIN
    MessageDlg ('An Error Occured during ReSetting - Contact Kingswood Computing',mtinformation,[mbOK],0);
    EXIT;
  END;


  // Processes Transaction file and record the first and last transaction for each Account
  // First Stored in PFIRST array
  // Last Stored in PLAST array
  PROCEDURE PHASE1;
  VAR
    RECNO : INTEGER;
    TXT	  : INTEGER;
    DBAC  : INTEGER;
    CRAC  : INTEGER;
    ACCREC: INTEGER;
    OK	  : BOOLEAN;
    TempAmount,TempNomAmount:BigLong;
  BEGIN
    SETDB (TxFile);
    AuditFiles.ProgressBar.Show;
    AuditFiles.ProgressBar.Progress := 0;
    AuditFiles.ProgressBar.MinValue := 0;
    AuditFiles.ProgressBar.MaxValue := db1.dbrecHigh;
    AuditFiles.ProgressLabel.Caption := '';
    AuditFiles.ProgressLabel.ReFresh;
    AuditFiles.ProgressLabel.ReFresh;
    AuditFiles.ProgressLabel.Caption := 'Reading Transaction File ...     ';
    AuditFiles.ProgressLabel.ReFresh;

    FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO
      BEGIN
        AuditFiles.ProgressBar.Progress := AuditFiles.ProgressBar.Progress + 1;
        READREC(TxFile,RECNO);
	IF ERRORNO>0 THEN ERR;
	IF RECACTIVE(TxFile) THEN
	  BEGIN
	    GETITEM(TxFile,1);
	    TXT:=CURRINT;

	    CASE FLNO OF
	      SlFile:  BEGIN
		    OK:= TXT IN [1..4];
		    GETITEM(TxFile,3);
		    ACCREC:=CURRINT;
		    IF OK THEN OK:= (ACCREC>FROMACC-1) AND (ACCREC<TOACC+1);
		    IF OK THEN
		      BEGIN
			CURRINT:=0;
			PUTITEM(TxFile,16);
			IF NEXTTX[ACCREC-FROMACC+1]>0 THEN
			  BEGIN
			    CURRINT:=NEXTTX[ACCREC-FROMACC+1];
			    PUTITEM(TxFile,16);
			  END;
			NEXTTX[ACCREC-FROMACC+1]:=RECNO;
			IF PLAST [ACCREC-FROMACC+1]=0 THEN
			   PLAST [ACCREC-FROMACC+1]:=RECNO;
			GETITEM (TxFile,2);
			IF ((LOWTX>0) AND (RECNO  >=LOWTX))
			OR ((LOWDT>0) AND (CURRINT>=LOWDT)) THEN
			  PFIRST[ACCREC-FROMACC+1]:=RECNO;
		      END;
		  END;
	      PlFile:  BEGIN
		    OK:= TXT IN [5..8];
		    GETITEM(TxFile,3);
		    ACCREC:=CURRINT;
		    IF OK THEN OK:= (ACCREC>FROMACC-1) AND (ACCREC<TOACC+1);
		    IF OK THEN
		      BEGIN
			CURRINT:=0;
			PUTITEM(TxFile,16);
			IF NEXTTX[ACCREC-FROMACC+1]>0 THEN
			  BEGIN
			    CURRINT:=NEXTTX[ACCREC-FROMACC+1];
			    PUTITEM(TxFile,16);
			  END;
			NEXTTX[ACCREC-FROMACC+1]:=RECNO;
			IF PLAST [ACCREC-FROMACC+1]=0 THEN
			   PLAST [ACCREC-FROMACC+1]:=RECNO;
			GETITEM (TxFile,2);
			IF ((LOWTX>0) AND (RECNO  >=LOWTX))
			OR ((LOWDT>0) AND (CURRINT>=LOWDT)) THEN
			  PFIRST[ACCREC-FROMACC+1]:=RECNO;
		      END;
		  END;
	      NlFile:  BEGIN
		    GETITEM(TxFile,18);
		    DBAC:=CURRINT;
		    GETITEM(TxFile,19);
		    CRAC:=CURRINT;
		    GETITEM(TxFile,17);
		    OK:= ( (DBAC>0) OR (CRAC>0) ) AND (CURRLONG<>0);
		    IF OK THEN
		      OK:= ( (DBAC>FROMACC-1) AND (DBAC<TOACC+1) )
			OR ( (CRAC>FROMACC-1) AND (CRAC<TOACC+1) );
		    IF OK THEN
		      BEGIN
			IF (DBAC>FROMACC-1) AND (DBAC<TOACC+1) THEN
			  BEGIN
			    CURRINT:=0;
			    PUTITEM(TxFile,13);
			    IF NEXTTX[DBAC-FROMACC+1]>0 THEN
			      BEGIN
				CURRINT:=NEXTTX[DBAC-FROMACC+1];
				PUTITEM(TxFile,13);
			      END;
			    NEXTTX[DBAC-FROMACC+1]:=RECNO;
			    IF PLAST [DBAC-FROMACC+1]=0 THEN
			       PLAST [DBAC-FROMACC+1]:=RECNO;
			    GETITEM (TxFile,2);
			    IF ((LOWTX>0) AND (RECNO  >=LOWTX))
			    OR ((LOWDT>0) AND (CURRINT>=LOWDT)) THEN
			      PFIRST[DBAC-FROMACC+1]:=RECNO;
			  END;
			IF (CRAC>FROMACC-1) AND (CRAC<TOACC+1) THEN
			  BEGIN
			    CURRINT:=0;
			    PUTITEM(TxFile,14);
			    IF NEXTTX[CRAC-FROMACC+1]>0 THEN
			      BEGIN
				CURRINT:=NEXTTX[CRAC-FROMACC+1];
				PUTITEM(TxFile,14);
			      END;
			    NEXTTX[CRAC-FROMACC+1]:=RECNO;
			    IF PLAST [CRAC-FROMACC+1]=0 THEN
			       PLAST [CRAC-FROMACC+1]:=RECNO;
			    GETITEM (TxFile,2);
			    IF ((LOWTX>0) AND (RECNO  >=LOWTX))
			    OR ((LOWDT>0) AND (CURRINT>=LOWDT)) THEN
			      PFIRST[CRAC-FROMACC+1]:=RECNO;
			  END;
		      END;
		  END;
	    END;
	  END;
	REWRITEREC(TxFile,RECNO);
	IF ERRORNO>0 THEN ERR;
      END;
  END;

  // Sets the First and Last transaction for an Account
  PROCEDURE PHASE2;
  VAR
    RECNO : INTEGER;
  BEGIN
    AuditFiles.ProgressBar.Show;
    AuditFiles.ProgressBar.Progress := 0;
    AuditFiles.ProgressBar.MinValue := 0;
    AuditFiles.ProgressBar.MaxValue := ToAcc;
    AuditFiles.ProgressLabel.Caption := '';
    AuditFiles.ProgressLabel.ReFresh;
    AuditFiles.ProgressLabel.Caption := 'Updating Account File Pointers...';
    AuditFiles.ProgressLabel.ReFresh;

    SetDb ( FlNo );
    // Check for Account to begin to big
    If db1.dbrectot < ToAcc Then
       ToAcc := db1.dbrectot;

    FOR RECNO:=FROMACC TO TOACC DO
      BEGIN
        AuditFiles.ProgressBar.Progress := AuditFiles.ProgressBar.Progress + 1;
        READREC(FLNO,RECNO);
	IF ERRORNO > 0 THEN ERR;
	IF RECACTIVE(FLNO) THEN
	  BEGIN
	    CASE FLNO OF
	      SlFile,
              PlFile :  if SetFirstTX then BEGIN // SetFirstTX added by GM 08/06/01
                          // added by M.C. on 15/09/1999 marked with //#
                          GetItem(FLNO,14);     // #
                          if CurrInt <> 0 then  // # indicates months have been carried out > 0
		             begin              // #
//tgm removed 06/06/01                                CURRINT:=NEXTTX[RECNO-FROMACC+1];
//tgm removed 06/06/01		                PUTITEM(FLNO,14);
                                    CURRINT:=PFIRST[RECNO-FROMACC+1];
	                            PUTITEM(FLNO,14);

                             end;               // 15/09/1999 #
		       END;
              NlFile : IF (RECNO>=Cash1.XBANKMIN) AND (RECNO<=Cash1.XBANKMAX) THEN
		      BEGIN
			CURRINT:=NEXTTX[RECNO-FROMACC+1];
			PUTITEM(FLNO,14);
		      END;
	    END;

            IF SetFirstTX then begin // SetFirstTX test added by GM 08/06/01
	       CURRINT:=PFIRST[RECNO-FROMACC+1];
	       PUTITEM(FLNO,15);
               //PutItem(FlNo,14);
               //tgm 06/06/01  - check out the line below for resetting pointer problem.
	       CURRINT:=PLAST[RECNO-FROMACC+1];
	       PUTITEM(FLNO,16);
	       REWRITEREC(FLNO,RECNO);
	       IF ERRORNO > 0 THEN ERR;
            end;
	  END;
      END;
  END;

BEGIN         // RunAuditFiles Begin
    INIT;
    PHASE1;
    PHASE2;
END;          // RunAuditFiles End

procedure TAuditFiles.NomAccFromButtonClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, AllNoms, 'N' );   { Nominal Ledger Accounts }
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        NomAccFrom.Text := NewListBox.ListInfo.ReturnValue;
     NomAccFrom.SetFocus;
end;

procedure TAuditFiles.NomAccToButtonClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, AllNoms, 'N' );   { Nominal Ledger Accounts }
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        NomAccTo.Text := NewListBox.ListInfo.ReturnValue;
     NomAccTo.SetFocus;
end;

procedure TAuditFiles.FormActivate(Sender: TObject);
begin
     // Set the Checkbox to unchecked
     if FActivateCount = 0 then
        begin
           FActivateCount := 1;
           Exit;
        end;

     ReSetNominal.Checked := False;
     ReSetSales.Checked := False;
     ReSetPurchase.Checked := False;

     PassMask.Text := '';
     ConfirmBtn.Enabled := True;
     bExit.Enabled := True;
     PassMask.Enabled := True;
     ProgressLabel.Hide;
     ProgressBar.Hide;
     // TGM AB 19/02/02 next line
 //    PassMask.SetFocus;
     SetDb ( NlFile );
     NomAccFrom.Text := '1';
     NomAccTo.Text   := IntToStr ( db1.dbrectot );
     LowestTx.Text := '1';

     EarliestDate.Text:= Cash11.DEFAULT_DATE;
     EarliestDateButton.Date := KStrToDate ( Cash11.DEFAULT_DATE );

     // Cashbook only system so hide the Sales & Purchase Items.
     If Cash1.XCASHBOOK Then
        begin
           ReSetSales.Checked := False;
           ReSetPurchase.Checked := False;
           SalesPanel.Hide;
           PurchasePanel.Hide;
        end
     Else
         begin
             SetDb ( SlFile );
             SalesFrom.Text := '1';
             SalesTo.Text := IntToStr ( db1.dbrechigh );
             SetDb ( PlFile );
             PurchaseFrom.Text := '1';
             FPurchAccountFrom := 1;
             PurchaseTo.Text := IntToStr ( db1.dbrechigh );
             FPurchAccountTo := StrToInt(PurchaseTo.Text);
         end;
end;

procedure TAuditFiles.SalesToDblClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Suppliers, 'S' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        SalesTo.Text := NewListBox.ListInfo.ReturnValue;
     SalesTo.SetFocus;
end;

procedure TAuditFiles.SalesFromDblClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Customers, 'C' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        SalesFrom.Text := NewListBox.ListInfo.ReturnValue;
     SalesFrom.SetFocus;
end;

procedure TAuditFiles.PurchaseFromDblClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Suppliers, 'S' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        begin
           PurchaseFrom.Text := NewListBox.ListInfo.ReturnValue;
           FPurchAccountFrom := StrToInt(PurchaseFrom.Text);
        end;
     PurchaseFrom.SetFocus;
end;

procedure TAuditFiles.PurchaseToDblClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Suppliers, 'S' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        begin
           PurchaseTo.Text := NewListBox.ListInfo.ReturnValue;
           FPurchAccountTo := StrToInt(PurchaseTo.Text);
        end;
     PurchaseTo.SetFocus;
end;

procedure TAuditFiles.EarliestDateButtonCloseUp(Sender: TObject);
begin
     EarliestDate.Text:= DateToStr(EarliestDateButton.Date);
     EarliestDate.SetFocus;
end;

procedure TAuditFiles.LowestTxChange(Sender: TObject);
Var
   TempStr : ShortString;
   TestTx  : Integer;
begin
    TempStr := LowestTx.Text;
    SlimAll ( TempStr );
    If Numeric ( TempStr ) Then
       begin
          TestTx := StrToInt ( TempStr );
          If ( TestTx > 0 ) Then
             begin
                EarliestDate.Hide;
                EarliestDateLabel.Hide;
                EarliestDateButton.Hide;
             end
          Else
             // Zero Tx means use the Date
             begin
                EarliestDate.Show;
                EarliestDateLabel.Show;
                EarliestDateButton.Show;
             end;
       end
    Else
        LowestTx.SetFocus;
end;

procedure TAuditFiles.EarliestDateExit(Sender: TObject);
begin
     If NOT DateValid ( EarliestDate.Text, TDateFormat ) Then
        EarliestDate.SetFocus
     else
        EarliestDateButton.Date := KStrToDate ( EarliestDate.Text );
{
     Else
         LowDt := Trunc ( DayTot-32000 );
}
end;

function TAuditFiles.CheckAllParameters ( Var FromNom, ToNom,
                                              FromSales, ToSales,
                                              FromPurchase, ToPurchase,
                                              LowTx, LowDt : Integer ) : Boolean;
Var
   TempStr    : ShortString;
   SalesOK,
   PurchaseOK,
   AllOK,
   NomsOK     : Boolean;

begin
     LowTx        := 1;
     LowDt        := 0;
     FromNom      := 0;
     ToNom        := 0;
     FromSales    := 0;
     ToSales      := 0;
     FromPurchase := 0;
     ToPurchase   := 0;
     LowTx        := 1;
     LowDt        := 0;
     SalesOK      := False;
     PurchaseOK   := False;
     NomsOK       := False;

     // Nominal Range
     TempStr := NomAccFrom.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        FromNom := StrToInt ( TempStr );
     TempStr := NomAccTo.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        ToNom := StrToInt ( TempStr );
     // Sales Range
     TempStr := SalesFrom.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        FromSales := StrToInt ( TempStr );
     TempStr := SalesTo.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        ToSales := StrToInt ( TempStr );
     // Purchase Range
     TempStr := PurchaseFrom.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        FromPurchase := StrToInt ( TempStr );
     TempStr := PurchaseTo.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        ToPurchase := StrToInt ( TempStr );

     If ResetNominal.Checked Then
        NomsOK := (( FromNom > 0 ) And ( ToNom > 0 ) And
                   ( FromNom <= ToNom ));
     If ResetSales.Checked Then
        SalesOK := (( FromSales > 0 ) And ( ToSales > 0 ) And
                    ( FromSales <= ToSales ));
     If ResetPurchase.Checked Then
        PurchaseOK := (( FromPurchase > 0 ) And ( ToPurchase > 0 ) And
                       ( FromPurchase <= ToPurchase ));

     // Set Focus to inaccurate information
     AllOK := ( ReSetNominal.Checked ) Or ( ReSetSales.Checked ) Or ( ReSetPurchase.Checked );
     If ResetNominal.Checked And ( NOT NomsOK ) then
        begin
            MessageDlg ( 'Nominal Settings Incorrect',mtinformation,[mbOK],0);
            ReSetNominal.SetFocus;
            AllOK := False;
        end
     else If ResetSales.Checked And ( NOT SalesOK ) then
        begin
           MessageDlg ( 'Sales Settings Incorrect',mtinformation,[mbOK],0);
           ReSetSales.SetFocus;
           AllOK := False;
        end
     else If ResetPurchase.Checked And ( NOT PurchaseOK ) then
        begin
           MessageDlg ( 'Purchase Settings Incorrect',mtinformation,[mbOK],0);
           ReSetPurchase.SetFocus;
           AllOK := False;
        end;

     TempStr := LowestTx.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        LowTx := StrToInt ( TempStr )
     Else
         begin
            AllOk := False;
            MessageDlg ( 'Transaction Number Incorrect',mtinformation,[mbOK],0);
         end;

     If EarliestDate.Visible Then
        begin
           If DateValid ( EarliestDate.Text, TDateFormat ) Then
              LowDt := Trunc ( DayTot-32000 )
           Else
              begin
                 AllOk := False;
                 MessageDlg ( 'Date entered Incorrect',mtinformation,[mbOK],0);
              end;
        end;

     ReSult := AllOk;
end;

procedure TAuditFiles.ConfirmBtnClick(Sender: TObject);
Var
   FromNom,
   ToNom,
   FromSales,
   ToSales,
   FromPurchase,
   ToPurchase,
   LowTx,
   LowDt      : Integer;
   ResetLowest:Boolean; // this var added by GM 08/06/01 used to determine whether or not to reset lowest and highest transactions.

begin
     If (((PassMask.Text = 'CONFIG') Or (PassMask.Text = 'config')) And
          (PassMask.Text <> '' )) Then
            Begin
               If CheckAllParameters ( FromNom, ToNom, FromSales, ToSales, FromPurchase,
                                       ToPurchase, LowTx, LowDt ) Then
                 begin
                    If Messagedlg('You are about to Reset Pointer.', mtInformation,[mbYes,mbNo,mbCancel],0) = mrYes then
                       begin
                          ProgressLabel.Show;
                          bExit.Enabled := False;
                          Confirmbtn.Enabled := False;
                          PassMask.Enabled := False;
                          // ResetLowest added by GM 08/06/01.  If false, procedure reset the chain of pointers, but leave first year , first-TX and last year alone
                          if ResetFirstGroup.Itemindex = 0 then ResetLowest:=false else ResetLowest:=true;
                          // Reset Nominal Accounts Pointer
                          If ResetNominal.Checked Then
                             RunAuditFiles ( NlFile, FromNom, ToNom, LowTx, LowDt,ResetLowest );
                          // Reset Purchase Accounts Pointer
                          If ResetPurchase.Checked Then
                             RunAuditFiles ( PlFile, FromPurchase, ToPurchase, LowTx, LowDt,ResetLowest );
                          // Reset Sales Accounts Pointer
                          If ResetSales.Checked Then
                             RunAuditFiles ( SlFile, FromSales, ToSales, LowTx, LowDt,ResetLowest );
                          ProgressLabel.Hide;
                          ProgressBar.Hide;
                          PassMask.Text := '';
                          Messagedlg('Resetting Process Completed.', mtInformation,[mbOK],0);
                          Close;
                          // TGM AB fixes problem with check box not being reset to 'Don't Reset .....'
                          Resetfirstgroup.ItemIndex:=0;
                       end;
                 end
               Else
                 Messagedlg('Incorrect Information Entered - Contact Kingswood Compting Ltd.', mtInformation,[mbOK],0);
            End
     Else
            Begin
                 Messagedlg('Incorrect Password - Contact Kingswood Compting Ltd.', mtInformation,[mbOK],0);
                 PassMask.Text := '';
                 PassMask.SetFocus;
            End
end;

procedure TAuditFiles.bExitClick(Sender: TObject);
begin
     if cbshowtx1.checked then Fmainscreen.LoadTransactionGrid;
     self.Close;
end;

procedure TAuditFiles.PassMaskKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If (Key = VK_Return) Then
        Confirmbtn.Click;
end;

procedure TAuditFiles.FormShow(Sender: TObject);
begin
//     Panel2.visible:= true;
     Label10.visible:=false;
     LowestTx.Visible:=false;
     EarliestDateLabel.visible:=false;
     EarliestDate.visible:=false;
     EarliestDateButton.visible:=false;

end;

procedure TAuditFiles.ResetFirstGroupClick(Sender: TObject);
begin
     if ResetFirstGroup.Itemindex = 1 then begin
        Label10.visible:=true;
        LowestTx.Visible:=true;
     end else begin
          Label10.visible:=false;
          LowestTx.Visible:=false;
          EarliestDateLabel.visible:=false;
          EarliestDate.visible:=false;
          EarliestDateButton.visible:=false;
     end;
end;

procedure TAuditFiles.button1Click(Sender: TObject);
begin
     // testforfirsttx checks from trans 1 to 100 if nominal audit trail running balance matches
     // trial balance.  This is normally the first tx of the current year.
     // have left button not visible yet 11/05/02 as not fully tested GM

     TestForFirstTx;
     //ConfirmBtn.enabled:=true;
//     Panel2.Visible:=false;
end;

procedure TAuditFiles.salesbtnClick(Sender: TObject);

          // repair of sales balances

          // builds an array of calculated balances using starting values and
          // replaces the stored balance values with the new figures

var
   i: integer;
   InputString: string;
//   ans: integer;

begin
    If (((PassMask.Text = 'CONFIG') Or (PassMask.Text = 'config')) And
          (PassMask.Text <> '' )) Then begin

    // FIXING OF SLFILE BALANCES

(*   InputString:= InputBox('Select maximum amount for fixing ledgers', '(£/€) - must be a whole number!', '');
   try ans := strtoint(InputString);
       ans := ans *100;
   except showmessage('Error in Threshold value');
          exit;

   end;
*)
//    ans := 100000;

// building array of SL start values
   for i:=1 to 9999 do begin
       dataarray[i].balance:=0;
       dataarray[i].firsttx:=0;
   end;

       SETDB (SlFile);
       ProgressLabel2.Caption := 'Building SL Array';
       ProgressLabel2.ReFresh;


       FOR RecNo:=StrToInt(SalesFrom.text) TO StrToInt(SalesTo.text) DO
           BEGIN
           READREC(SlFile,RECNO);
	   IF ERRORNO>0 THEN Error(self);
	   IF RECACTIVE(SlFile) THEN BEGIN
               GetItem(SLFile,17);        //Balance-St - balance brought forward
               DataArray[RecNo].balance:=Currlong;
               GetItem(SLFile,14);        // First-year - first transaction in current year
               if currint = 0 then Getitem(SlFile,15);
               DataArray[RecNo].firsttx:=currint;
           end;

       end;

       // Getting Values From Tx File
       SETDB (TxFile);
       ProgressLabel2.Caption := 'Updating Sl Array With Balances';
       ProgressLabel2.ReFresh;

       FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO
           BEGIN
           READREC(TxFile,RECNO);
	   IF ERRORNO>0 THEN Error(self);
           getitem(Txfile,28);
	   IF ((RECACTIVE(TxFile)) and not (currstr[1] in ['E','R'])) THEN BEGIN  // TGM AB 6/6/02
           //  IF RECACTIVE(TxFile) THEN BEGIN
              getitem(TxFile,1);
              TxType:=currint;

              if (TxType = 1) then
                 begin
                 getitem(Txfile,3);        // account
                 acc:=currint;
                 getitem(TxFile,9);        // amount
                 amount:=currlong;
                 getitem(Txfile,11);       //Tax/Disc
                 tax:=currlong;
                 // transaction number is same as the RecNo
                 // updating account balance by transaction amount
                 first_tx:=DataArray[acc].firsttx;      // reads in first transaction for the current year for debit account
                 if ((first_tx > 0) and (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
                    begin
                    DataArray[acc].balance:=DataArray[acc].balance + amount + tax; // adding amount to account balance
                    end;

                 end;


              if (TxType = 2) then
                 begin
                 getitem(Txfile,3);        // account
                 acc:=currint;
                 getitem(TxFile,9);        // amount
                 amount:=currlong;
                 getitem(Txfile,11);       //Tax/Disc
                 tax:=currlong;
                 // transaction number is same as the RecNo
                 // updating account balance by transaction amount
                 first_tx:=DataArray[acc].firsttx;      // reads in first transaction for the current year for debit account
                 if ((first_tx > 0) and (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
                    begin
                    DataArray[acc].balance:=DataArray[acc].balance - amount - tax; // subtraction amount from account balance
                    end;

                 end;


              if (TxType = 3) then
                 begin
                 getitem(Txfile,3);        // account
                 acc:=currint;
                 getitem(TxFile,9);        // amount
                 amount:=currlong;
                 getitem(Txfile,11);       //Tax/Disc
                 tax:=currlong;
                 // transaction number is same as the RecNo
                 // updating account balance by transaction amount
                 first_tx:=DataArray[acc].firsttx;      // reads in first transaction for the current year for debit account
                 if ((first_tx > 0) and (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
                    begin
                    DataArray[acc].balance:=DataArray[acc].balance + amount + tax; // adding amount to account balance
                    end;

                 end;

              end;
           end;

       // writing back the array into Sl
       SETDB (SlFile);
       ProgressLabel2.Caption := 'Writing back the Sl Array';
       ProgressLabel2.ReFresh;

       age_1:=0;
       age_2:=0;
       age_3:=0;
       age_curr:=0;


       FOR RecNo:=StrToInt(SalesFrom.text) TO StrToInt(SalesTo.text) DO
           BEGIN
           READREC(SlFile,RECNO);
	   IF ERRORNO>0 THEN Error(self);
	   IF RECACTIVE(SlFile) THEN BEGIN
               getitem(Slfile,7);
               if (currlong <> DataArray[RecNo].balance) then begin
                  currlong:=DataArray[RecNo].balance;
                  PutItem(SlFile,7);        //Balance - writing current balance into Sl file
                  getitem(Slfile,10);
                  age_1:=currlong;
                  getitem(Slfile,11);
                  age_2:=currlong;
                  getitem(Slfile,12);
                  age_3:=currlong;
                  age_curr:=DataArray[RecNo].balance - age_1 - age_2 - age_3;
                  currlong:=age_curr;
                  PutItem(Slfile,9);
                  REWRITEREC(SlFile,RecNo);
               end;
           end;
       end;
       showmessage('Sales Ledgers Corrected - Please Rerun Data Integrity Check');

     End Else
            Begin
                 Messagedlg('Incorrect Password - Contact Kingswood Compting Ltd.', mtInformation,[mbOK],0);
                 PassMask.Text := '';
                 PassMask.SetFocus;
            End;


end;

procedure TAuditFiles.checkbtnClick(Sender: TObject);
          // full data integrity check
var dirstring,progpath : string;

begin
       Dataproblem := false;      // indicates a integrity check fail

       FLogFilePath := Accsdata.AccsDataModule.AccsDataBase.Directory + 'DataLog.Txt';
       Assignfile(Logfile, FLogFilePath);
       Rewrite(Logfile);
       WriteLn(Logfile,'Kingswood Data Log File');
       WriteLn(Logfile,'===================');
       Writeln(Logfile,'');
       Writeln(Logfile,'Log File For Set of Accounts - ' + Accsdata.AccsDataModule.AccsDataBase.AliasName);
       Writeln(Logfile,'');

       // tests
       if NLbalancesOK(true,false,1) = false then dataproblem := true;
       writeln(logfile,'');
       //if DeleteBlankRecords(true) then dataproblem := true; this function needs to be finished.
       if Missingaccounts(true) = true then dataproblem := true;
       writeln(logfile,'');
       if BlankFields(true) = true then dataproblem := true;
       writeln(logfile,'');

       if IncludeDetailedCB.checked then begin                               // TGM AB 18/09/15
                if MissingTxs(true) = true then dataproblem := true;         // TGM AB 18/09/15
                writeln(logfile,'');                                         // TGM AB 18/09/15
       end;                                                                  // TGM AB 18/09/15

       if not cash1.xcashbook then begin
                                   if SaleLedgersOK(true) = false then dataproblem := true;        // SalesledgersOK(Writereport)
                                   writeln(logfile,'');
                                   if PurchaseLedgersOK(true) = false then dataproblem := true;    // PurchaseledgersOK(Writereport)
                                   writeln(logfile,'');
                                   if Controlaccountsmatch(true) = false then dataproblem := true;  // Controlaccountsmatch(Writereport)
                                   end;

         If DataProblem = true then begin
           Showmessage('Data Integrity Test indicates a problem with your data. A detail log of problems and fixes done will now be displayed. Please Contact Kingswood For Help');
           WriteLn(Logfile,' ');
           WriteLn(Logfile,'Data Integrity Test Indicates a problem with your data.');
           WriteLn(Logfile,'');
           WriteLn(LogFile,'Please Contact Kingswood for Help');
           closefile(logfile);
            dirstring := RFarmGate.PLocation[2];
            progpath := ExtractFilePath( ParamStr(0));
            try //winexec(PChar(progpath + 'wordpad.exe ' + progpath +  dirstring +'\datalog.txt'),sw_show);
                // SP 12/01/11 - Load log file from log file path.
                TNotepadForm.LoadFile(FLogFilePath);
            except
               on E : Exception do
                  begin
                     MessageDlg(E.Message,mtError,[mbOK],0);
                  end;
            end;
           end
       Else begin
            Showmessage('Data Integrity Test Has Found No Errors With Your Data');
            WriteLn(Logfile,' ');
            WriteLn(Logfile,'Data Integrity Test Indicates No Problems With Your Data.');
            WriteLn(Logfile,'');
            closefile(logfile);
       //     dirstring := RFarmGate.PLocation[2];
       //     progpath := ExtractFilePath( ParamStr(0));
       //     try //winexec(PChar(progpath +'wordpad.exe ' + progpath + dirstring +'\datalog.txt'),sw_show);
       //         unotepad.NotepadForm.LoadFile(progpath +  dirstring +'\datalog.txt');
       //         except
       //     end;
            end;
end;

procedure TAuditFiles.PurchasebtnClick(Sender: TObject);

           // repair of purchase balances

          // builds an array of calculated balances using starting values and
          // replaces the stored balance values with the new figures

var
   i : integer;
 //  ans : integer;
   Inputstring : string;
begin

    If (((PassMask.Text = 'CONFIG') Or (PassMask.Text = 'config')) And
          (PassMask.Text <> '' )) Then begin

(*   InputString:= InputBox('Select maximum amount for fixing ledgers', '(£/€) - must be a whole number!', '');
   try ans := strtoint(InputString);
       ans := ans *100;
   except showmessage('Error in Threshold value');
          exit;

   end;
*)
 //   ans := 100000000;

   for i:=1 to 9999 do begin
       dataarray[i].balance:=0;
       dataarray[i].firsttx:=0;
   end;

       SETDB (PlFile);
       ProgressLabel.Caption := 'Building PL Array';
       ProgressLabel.ReFresh;

       FOR RecNo:= FPurchAccountFrom TO FPurchAccountTo DO
           try
              READREC(PlFile,RECNO);
              IF ERRORNO>0 THEN ERROR(self);
              IF RECACTIVE(PlFile) THEN BEGIN
                  GetItem(PLFile,17);        //Balance-St - balance brought forward
                  DataArray[RecNo].balance:=Currlong;
                  GetItem(PLFile,14);        // First-year - first transaction in current year
                  if currint = 0 then Getitem(PlFile,15);
                     DataArray[RecNo].firsttx:=currint;
                 end;
          except
             on e : Exception do
                ShowMessage(e.Message);
          end;


       // Getting Values From Tx File

       SETDB (TxFile);
       ProgressLabel.Caption := 'Updating Pl Array With Balances';
       ProgressLabel.ReFresh;

       FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO
           try
              READREC(TxFile,RECNO);
              IF ERRORNO>0 THEN ERROR(self);
              getitem(Txfile,28);
              IF ((RECACTIVE(TxFile)) and not (currstr[1] in ['E','R'])) THEN BEGIN  // TGM AB 6/6/02
                  // IF RECACTIVE(TxFile) THEN BEGIN
                 getitem(TxFile,1);
                 TxType:=currint;
                 if (TxType = 5) then
                    begin
                    getitem(Txfile,3);        // account
                    acc:=currint;
                    getitem(TxFile,9);        // amount
                    amount:=currlong;
                    getitem(Txfile,11);       //Tax/Disc
                    tax:=currlong;
                    // transaction number is same as the RecNo
                    // updating account balance by transaction amount
                    first_tx:=DataArray[acc].firsttx;      // reads in first transaction for the current year
                    if ((first_tx > 0) and (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
                       begin
                       DataArray[acc].balance:=DataArray[acc].balance + amount + tax; // adding amount to account balance
                       end;

                    end;



                 if (TxType = 6) then
                    begin
                    getitem(Txfile,3);        // account
                    acc:=currint;
                    getitem(TxFile,9);        // amount
                    amount:=currlong;
                    getitem(Txfile,11);       //Tax/Disc
                    tax:=currlong;
                    // transaction number is same as the RecNo
                    // updating account balance by transaction amount
                    first_tx:=DataArray[acc].firsttx;      // reads in first transaction for the current year for debit account
                    if ((first_tx > 0) and (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
                       begin
                       DataArray[acc].balance:=DataArray[acc].balance - amount - tax; // subtracting amount to account balance
                       end;

                    end;



                 if (TxType = 7) then
                    begin
                    getitem(Txfile,3);        // account
                    acc:=currint;
                    getitem(TxFile,9);        // amount
                    amount:=currlong;
                    getitem(Txfile,11);       //Tax/Disc
                    tax:=currlong;
                    // transaction number is same as the RecNo
                    // updating account balance by transaction amount
                    first_tx:=DataArray[acc].firsttx;      // reads in first transaction for the current year for debit account
                    if ((first_tx > 0) and (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
                       begin
                       DataArray[acc].balance:=DataArray[acc].balance + amount + tax; // adding amount to account balance
                       end;

                    end;

                 end;
           except
              on e : Exception do
                 ShowMessage(e.Message);
           end;

        age_1:=0;
        age_2:=0;
        age_3:=0;
        age_curr:=0;

               // writing back the array into Pl
       SETDB (PlFile);
       ProgressLabel.Caption := 'Writing back the Pl Array';
       ProgressLabel.ReFresh;

       FOR RecNo:= FPurchAccountFrom TO FPurchAccountTo DO
           try
              READREC(PlFile,RECNO);
              IF ERRORNO>0 THEN ERROR(self);
              IF RECACTIVE(PlFile) THEN BEGIN
                  getitem(Plfile,7);
                  if (currlong <> DataArray[RecNo].balance) then begin
                     currlong:=DataArray[RecNo].balance;
                     PutItem(PlFile,7);        //Balance - writing current balance into Pl file
                     getitem(Plfile,10);
                     age_1:=currlong;
                     getitem(Plfile,11);
                     age_2:=currlong;
                     getitem(Plfile,12);
                     age_3:=currlong;
                     age_curr:=DataArray[RecNo].balance - age_1 - age_2 - age_3;
                     currlong:=age_curr;
                     PutItem(Plfile,9);
                     REWRITEREC(PlFile,RecNo);
                     end;
                 end;
           except
              on e : Exception do
                 ShowMessage(e.Message);
           end;

       showmessage('Purchase Ledgers Corrected - Please Rerun Data Integrity Check');

     End Else
            Begin
                 Messagedlg('Incorrect Password - Contact Kingswood Compting Ltd.', mtInformation,[mbOK],0);
                 PassMask.Text := '';
                 PassMask.SetFocus;
            End


end;

procedure TAuditFiles.nominalbtnClick(Sender: TObject);

      //    Function to repair nominal balances
      //    Be careful when using as it is diificult to chose which starting value to repair with
      //    balance-st of st-year.

var
   i: integer;
   InputString: string;
 //  ans: integer;

begin
    If (((PassMask.Text = 'CONFIG') Or (PassMask.Text = 'config')) And
          (PassMask.Text <> '' )) Then begin

     messagedlg('This auto fix is using Balance-ST as it''s start value.' +#10#13 +  'If no month end reset pointer operations done, Balance-St should be the same as St-Year.' +#10#13 +  'If they''re not the same, they must be manually fixed, otherwise this auto fix will make things worse. ' + #10#13 + #10#13 +  'Note, month end pointer reset is not an option in Winaccs, only DOS accs, so Balance-ST and St-Year should be the same in all winaccs systems and in DOS systems where end month ''reset nominal pointers'' was not run.',mtConfirmation,[mbOk],0);
   if messageDlg('Use this option with EXTREME CAUTION.  Make sure you have backed up the accounts data before proceeding.  Manually check trial balance totals against Nominal audit running balances after running.  Are you sure you wish to continue?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin


(*   InputString:= InputBox('Select maximum amount for fixing nominals', '(£/€) - must be a whole number!', '');
   try ans := strtoint(InputString);
       ans := ans *100;
   except showmessage('Error in Threshold value');
          exit;

   end;
*)
//    ans := 100000;

// UPDATE NL FILES TO CORRECT NOMINAL

   for i:=1 to 9999 do begin
       dataarray[i].balance:=0;
       dataarray[i].firsttx:=0;
   end;

// building array of NL start values
       SETDB (NlFile);
       ProgressLabel.Caption := 'Building NL Array';
       ProgressLabel.ReFresh;

       FOR RecNo:=StrToInt(NomAccFrom.text) TO StrToInt(NomAccTo.text) DO
           BEGIN
           READREC(NlFile,RECNO);
	   IF ERRORNO>0 THEN ERROR(self);
	   IF RECACTIVE(NlFile) THEN BEGIN
               GetItem(NLFile,22);        //balance-st  starting balance
               DataArray[RecNo].balance:=Currlong;
               GetItem(NLFile,15);        // First-Tx - first transaction in current year
               DataArray[RecNo].firsttx:=currint;
           end;
       end;


     // Getting Values From Tx File
       SETDB (TxFile);
       ProgressLabel.Caption := 'Updating NL Array With Balances';
       ProgressLabel.ReFresh;

       FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO
           BEGIN
           READREC(TxFile,RECNO);
	   IF ERRORNO>0 THEN ERROR(self);
           getitem(Txfile,28);
	   IF ((RECACTIVE(TxFile)) and not (currstr[1] in ['E','R'])) THEN BEGIN  // TGM AB 6/6/02
              getitem(TxFile,1);
              TxType:=currint;
              getitem(Txfile,18);        // Debit-Ac
              db:=currint;
              getitem(Txfile,19);        // Credit-Ac
              cr:=currint;
              getitem(TxFile,17);        // nom-amount
              nom_amount:=currlong;
              // transaction number is same as the RecNo
              // updating account balance by transaction amount
              first_tx:=DataArray[db].firsttx;      // reads in first transaction for the current year for debit account
              if ((first_tx > 0) and  (RecNo>=first_tx)) then             // checks the currrent transaction is equal to or greater than the first transaction number
              begin
                   DataArray[db].balance:=DataArray[db].balance + nom_amount; // updating (adding) account balance with non amount
              end;
              first_tx:=DataArray[cr].firsttx;      // same for credit account
              if ((first_tx > 0) and  (RecNo>=first_tx)) then
              begin
                   DataArray[cr].balance:=DataArray[cr].balance - nom_amount; // subtracting from credit account balance
              end;
           end;
       end;


   // writing back the array into Nl
       SETDB (NlFile);
       ProgressLabel.Caption := 'Writing back the NL Array';
       ProgressLabel.ReFresh;

       FOR RecNo:=StrToInt(NomAccFrom.text) TO StrToInt(NomAccTo.text) DO
           BEGIN
           READREC(NlFile,RECNO);
	   IF ERRORNO>0 THEN ERROR(Self);
	   IF RECACTIVE(NlFile) THEN BEGIN
               currlong:=DataArray[RecNo].balance;
               PutItem(NlFile,2);        //Balance - writing current balance into Nl file
               REWRITEREC(NlFile,RECNO);
           end;
       end;
       showmessage('Nominal Accounts Corrected - Please Rerun Data Integrity Check');
       end // end of messagedlg 'are you sure you wish to continue

       else showmessage('Fix Nominals cancelled');

     End Else
            Begin
                 Messagedlg('Incorrect Password - Contact Kingswood Compting Ltd.', mtInformation,[mbOK],0);
                 PassMask.Text := '';
                 PassMask.SetFocus;
            End

end;

Function TAuditFiles.Missingaccounts(Writereport : boolean): boolean;

         // uses Writereport as a flag to enable / disble writing to the log file

         // runs through all currently active nominal accounts and marks them as inuse (true)
         // in an array.

         // runs through all transactions and checks Debit / Credit accounts against the array
         // and reports any transactions that are using accounts that have be deleted
var
   i : integer;

begin
       result := false;
       for i:=1 to 9999 do begin
       accountarray[i].inuse:=false;
       end;
  //     Showmessage(varToStr(cash11.xno_of_partners));
      SETDB (Nlfile);

      FOR RecNo:=StrToInt(NomAccFrom.text) TO StrToInt(NomAccTo.text) DO
           BEGIN
           READREC(NlFile,RECNO);
	   IF RECACTIVE(NlFile) THEN BEGIN
                accountarray[RECNO].inuse := true;
                if (cash1.XNOMPRVEXP <> cash1.xNOMPRVINC +1) then begin
                   if ((RECNO > Cash1.XNOMPRVINC + cash11.xno_of_partners) and (RecNo <= cash1.XNOMPRVINC + 9)) then accountarray[RECNO].inuse := false;
                   if ((RECNO > Cash1.xNOMPRVEXP + cash11.xno_of_partners) and (RecNo <=Cash1.XNOMPRVEXP + 9)) then accountarray[RECNO].inuse := false;
                end;
           end;
      end;

      SETDB (TxFile);
      FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO
           BEGIN
           READREC(TxFile,RECNO);
	   IF RECACTIVE(TxFile) THEN BEGIN
              getitem(TxFile,1);
              TxType:=currint;
              if not ((txtype = 15) or (txtype = 11) or (txtype = 1) or (txtype = 5) or (txtype = 7) or (txtype = 3)) then begin
                 getitem(Txfile,18);        // Debit-Ac
                 db:=currint;
                 if accountarray[db].inuse <> true then begin
                                                        result := true;
                                                        if writereport then begin
                                                           writeln(logfile,'Transaction ' + vartostr(RECNO) + ' Has account ' + vartostr(db) + ' missing');
                                                           writeln(logfile,'Either edit the transaction and select a nominal code which does exist, or else setup a new nominal code with the number ' + varToStr(db));
                                                           writeln(LogFile,'After fixing, run Data Integrity Check again.');
                                                           writeln(LogFile,'It is highly likely that this is causing the trial balance not to balance.  Fix this and all other transactions which have the same');
                                                           writeln(LogFile,'fault. then run the data integrity check again to see if there is still a trial balance problem.');
                                                           writeln(logFile);
                                                           end;
                                                        end;
                 getitem(Txfile,19);        // Credit-Ac
                 cr:=currint;
                 if accountarray[cr].inuse <> true then begin
                                                        result := true;
                                                        if writereport then begin
                                                           writeln(logfile,'Transaction ' + vartostr(RECNO) + ' Has account ' + vartostr(cr) + ' missing');
                                                           writeln(logfile,'Either edit the transaction and select a nominal code which does exist, or else setup a new nominal code with the number ' + varToStr(cr));
                                                           writeln(LogFile,'After fixing, run Data Integrity Check again.');
                                                           writeln(LogFile,'It is highly likely that this is causing the trial balance not to balance.  Fix this and all other transactions which have the same');
                                                           writeln(LogFile,'fault. then run the data integrity check again to see if there is still a trial balance problem.');
                                                           writeln(LogFile);
                                                           end;
                                                        end;
                 if cr = db then begin
                                 result := true;
                                 if writereport then begin
                                 writeln(logfile,'Transaction ' + vartostr(RECNO) + ' Has account the smae Debit & Credit Account');
                                 writeln(logfile,'Debit Account - ' + vartostr(db));
                                 writeln(logfile,'Credit Account - ' + vartostr(cr));
                                 writeln(LogFile);
                                 end;
                              end;


              end;
           end;
      end;

end;

Function TAuditFiles.BlankFields(Writereport : boolean): boolean;

         // uses Writereport as a flag to enable / disble writing to the log file

         // runs through all currently active nominal accounts and marks them as inuse (true)
         // in an array.

         // runs through all transactions and checks Debit / Credit accounts against the array
         // and reports any transactions that are using accounts that have be deleted
var
   i : integer;
   FirstTx : integer;

begin
       result := false;
      FirstTx := FirstTxThisYear;
      SETDB (TxFile);
      FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO BEGIN
           READREC(TxFile,RECNO);
	   IF RECACTIVE(TxFile) THEN BEGIN
              getitem(Txfile,2);        // Date
              if currint < 1 then begin
                 result := true;
                 if recno < firstTx then begin
                    currint := KDateToInt('01/01/90');
                    Putitem(TxFile,2);
                    ReWriterec(TxFile,recno);
                    if writereport then begin
                       writeln(logfile,'Transaction ' + vartostr(RECNO) + ' Had bad date. Date has been set to 01/01//90');
                       writeln(logFile);
                    end;
                 end else
                    if writereport then begin
                       writeln(logfile,'Transaction ' + vartostr(RECNO) + ' Has bad date. ');
                       writeln(logFile);
                    end;

              end;

              getitem(Txfile,18);        // Debit
              if currint < 1 then begin
                 getitem(Txfile,1);
                 if currint = 9 then begin
                    result := true;
                    if writereport then begin
                       writeln(logfile,'Transaction ' + vartostr(RECNO) + ' Has blank Debit a/c. ');
                       writeln(logFile);
                    end;
                 end;
              end;
              getitem(Txfile,19);        // Credit
              if currint < 1 then begin
                 getitem(Txfile,1);
                 if currint = 9 then begin
                    result := true;
                    if writereport then begin
                       writeln(logfile,'Transaction ' + vartostr(RECNO) + ' Has blank Credit a/c. ');
                       writeln(logFile);
                    end;
                 end;
              end;



           end;
      end;

end;

Function TAuditFiles.DeleteBlankRecords(Writereport : boolean): boolean;

         // uses Writereport as a flag to enable / disble writing to the log file
         // checks all transaction for dates < 1, with debit or credit nominal < 1 of tx type 9
         // this function is not finished.  It doesn't actually delete the record.
var
   i : integer;

begin
     result := false;

     SETDB (TxFile);
      FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO BEGIN
           READREC(TxFile,RECNO);
	   IF RECACTIVE(TxFile) THEN BEGIN
              getitem(Txfile,2);        // Date
              if currint < 1 then begin
                 getitem(Txfile,9);        // Date
                 if currlong < 1 then begin
                    getitem(Txfile,17);        // Date
                    if currint < 1 then begin
                       result := true;
                       if writereport then begin
                          writeln(logfile,'Transaction ' + vartostr(RECNO) + ' is blank record. ');
                          writeln(logFile);
                       end;
                    end;
                 end;
              end;
           end;
      end;

end;

function Tauditfiles.Controlaccountsmatch (writereport: boolean): boolean;
   // uses writereport as the flag to enable / disable writing to the log file

   // runs through the Purchases and calculates the combined age of debt and check against
   // creditors control

   // runs through the Sales and calculates the combined age of debt and check against
   // debtors control
begin
       Pltotalbalance := 0;
       sltotalbalance := 0;
       sldiff := 0;
       pldiff := 0;
       PltotalbalanceStartYear := 0;
       sltotalbalanceStartYear := 0;
       sldiffStartYear := 0;
       pldiffStartYear := 0;

       result := true;
       SETDB (PlFile);

       FOR RecNo:= FPurchAccountFrom TO FPurchAccountTo DO
           BEGIN
           READREC(PlFile,RECNO);
	   IF RECACTIVE(PlFile) THEN BEGIN
              GetItem(PLFile,7);        //Balance
              pltotalbalance:=pltotalbalance + currlong;
              GetItem(PLFile,17);        //Balance
              pltotalbalanceStartYear:=pltotalbalanceStartYear + currlong;
              end;
           end;

       SETDB (SlFile);

       FOR RecNo:=StrToInt(SalesFrom.text) TO StrToInt(SalesTo.text) DO
           begin
              READREC(SlFile,RECNO);
              if RECACTIVE(SlFile) then
                 begin
                    GetItem(SLFile,7);        //Balance
                    sltotalbalance:=sltotalbalance + currlong;
                    GetItem(SLFile,17);        //Balance
                    sltotalbalanceStartYear:=sltotalbalanceStartYear + currlong;
                 end;
           end;

       SETDB (NlFile);

       for RecNo:=StrToInt(NomAccFrom.text) to StrToInt(NomAccTo.text) do
          begin
             READREC(NlFile,RECNO);
             if RECACTIVE(NlFile) then
                begin
                   Getitem(Nlfile,1);
                   if currstr = 'Creditors Control' then
                      begin
                         getitem(NlFile,2);
                         if pltotalbalance <> - currlong then
                            begin
                               result:= false;
                               pldiff := pltotalbalance + currlong;
                               if writereport then
                                  writeln(logfile, 'Error Purchase Age of Debt does not equal Creditors Control - Difference = ' + vartostr(pldiff/100));
                            end;
                         getitem(NlFile,4);
                         if pltotalbalanceStartYear <> - currlong then
                            begin
                               result:= false;
                               pldiffStartYear := pltotalbalanceStartYear + currlong;
                               if writereport then
                                  writeln(logfile, 'Error Purchase Age of Debt at StartYear does not equal Creditors Control at StartYear - Difference = ' + vartostr(pldiffStartYear/100));
                            end;
                      end;
                   if currstr = 'Debtors Control' then
                      begin
                         getitem(NlFile,2);
                         if sltotalbalance <> currlong then
                            begin
                               result:= false;
                               sldiff:=sltotalbalance - currlong;
                               if writereport then
                                  writeln(logfile, 'Error Sales Age of Debt does not equal Debtors Control - Difference = ' + vartostr(sldiff/100));
                            end;
                         getitem(NlFile,4);
                         if sltotalbalanceStartYear <> currlong then
                            begin
                               result:= false;
                               sldiffStartYear:=sltotalbalanceStartYear - currlong;
                               if writereport then
                                  writeln(logfile, 'Error Sales Age of Debt at StartYear does not equal Debtors Control at StartYear - Difference = ' + vartostr(sldiffStartYear/100));
                            end;
                      end;
                end;
          end;
end;

procedure TAuditFiles.BitBtn1Click(Sender: TObject);
var progpath:string;
begin
            progpath := ExtractFilePath( ParamStr(0));
            try shellexecute(handle,'open',PChar(progpath +'dataloghelp.txt'),null,null,sw_shownormal);
                except
            end;

end;

procedure TAuditFiles.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Key = VK_F10 Then Button1.visible := true;
end;

procedure TAuditFiles.Button2Click(Sender: TObject);
var comment : shortstring;
    fixed : boolean;
    i : integer;
begin
    If (((PassMask.Text = 'CONFIG') Or (PassMask.Text = 'config')) And
          (PassMask.Text <> '' )) Then begin

      SETDB (TxFile);
      fixed := true;
      comment := '';
      FOR RECNO:=1 to DB1.DBRECHIGH do begin

           READREC(TxFile,RECNO);
           getitem(TxFile,1);
           TxType:=currint;
           if (txtype = 15) then begin
              comment := '';
              getitem(Txfile,5);
              for i := 1 to length(currdisp) do
              comment:=comment + currdisp[i];
              fixed := false;
           end;
           if ((txtype = 16) and (not fixed)) then begin
              for i := 1 to length(comment) do
                  currdisp[i] := comment[i];
              putitem(Txfile,5);
              fixed := true;
              ReWriteRec(TxFile,Recno);
           end;
           if (txtype = 11) then begin
              comment := '';
              getitem(Txfile,5);
              for i := 1 to length(currdisp) do
              comment:=comment + currdisp[i];
              fixed := false;
           end;
           if ((txtype = 12) and (not fixed)) then begin
              for i := 1 to length(comment) do
                  currdisp[i] := comment[i];
              putitem(Txfile,5);
              fixed := true;
              ReWriteRec(TxFile,Recno);
           end;
           if (txtype = 5) then begin
              comment := '';
              getitem(Txfile,5);
              for i := 1 to length(currdisp) do
              comment:=comment + currdisp[i];
              fixed := false;
           end;
           if ((txtype = 6) and (not fixed)) then begin
              getitem(TxFile,23);
              if currint = 5 then begin
                 for i := 1 to length(comment) do
                     currdisp[i] := comment[i];
                 putitem(Txfile,5);
                 ReWriteRec(TxFile,Recno);
              end;
           end;
           if (txtype = 6) then fixed := true;
           if (txtype = 1) then begin
              comment := '';
              getitem(Txfile,5);
              for i := 1 to length(currdisp) do
              comment:=comment + currdisp[i];
              fixed := false;
           end;
           if ((txtype = 2) and (not fixed)) then begin
              getitem(TxFile,23);
              if currint = 1 then begin
                 for i := 1 to length(comment) do
                     currdisp[i] := comment[i];
                 putitem(Txfile,5);
                 ReWriteRec(TxFile,Recno);
              end;
           end;
           if (txtype = 2) then fixed := true;
      end;
      showmessage('Bank Rec Problem Fix Complete');
    end else
     showmessage('Incorrect Password');

end;

procedure TAuditFiles.RecalcMonthsClick(Sender: TObject);
begin
         CalculateMonths.CalculateMonthlyValues;
         Calculatemonths.UpdateNLMonthlyFigures;
         Showmessage('Balance Recalculation Complete');
end;



// TGM AB 18/09/15 from here onward



function Tauditfiles.MissingTxs(Writereport: boolean): boolean;

         // uses Writereport as a flag to enable / disable writing to the log file

         // runs through the transaction file looking for missing transaction lines

var
        RecNo : integer;
        TransType, OrigType : integer;
        Error : boolean;
        LastTxNo : integer;


begin
    //

        FirstTransactionOfYear := FirstTxThisYear;
        result := false;
        Error := False;

    // do basic check if table recordcount = max txno field - if not then missing record(s)

        AccsData.AccsDataModule.TransactionsDB.last;
        LastTxNo := AccsData.AccsDataModule.TransactionsDB['TxNo'];
        if LastTxNo <> AccsData.AccsDataModule.TransactionsDB.recordcount then begin

                writeln(logfile,'Transaction database record count does not match program transaction count');
                result := true;
        end;

    // function to look for missing transactions


        AccsData.AccsDataModule.TransactionsDB.First;


        while not AccsData.AccsDataModule.TransactionsDB.eof do
           Begin

           Transtype := AccsData.AccsDataModule.TransactionsDB['TxType'];
           Origtype := AccsData.AccsDataModule.TransactionsDB['OrigType'];


           case Transtype of

               1 : begin
                    Error := not InvoiceTypeOK(1,AccsData.AccsDataModule.TransactionsDB['TxNo']);
               end;

               2 : begin
                    Error := not PaymentTypeOK(2,AccsData.AccsDataModule.TransactionsDB['TxNo']);
               end;

               3 : begin
                    Error := not CreditNoteTypeOK(3,AccsData.AccsDataModule.TransactionsDB['TxNo']);
               end;

               5 : begin
                    Error := not InvoiceTypeOK(5,AccsData.AccsDataModule.TransactionsDB['TxNo']);
               end;

               6 : begin
                    Error := not PaymentTypeOK(6,AccsData.AccsDataModule.TransactionsDB['TxNo']);
               end;

               7 : begin
                    Error := not CreditNoteTypeOK(7,AccsData.AccsDataModule.TransactionsDB['TxNo']);
               end;

               9 : begin
                    Error := not OthersTypeOK(AccsData.AccsDataModule.TransactionsDB['TxNo']);
               end;

               11 : begin
                    Error := not CashbookTypeOK(11,AccsData.AccsDataModule.TransactionsDB['TxNo']);
               end;

               15 : begin
                    Error := not CashbookTypeOK(15,AccsData.AccsDataModule.TransactionsDB['TxNo']);
               end;


           end;

                 AccsData.AccsDataModule.TransactionsDB.next;
                 if error then result := True;
           end;  // while .....




end;

function Tauditfiles.InvoiceTypeOK(InvoiceType, RecordNo : Integer): boolean;
var
     FooterType: integer;
     stop : boolean;
     jumptorecord, TxType, PreviousRecType : integer;
begin
    // Check Sales (1) / Purchase Invoice Types (5)
    // Result = True for OK transaction

    if InvoiceType = 1 then FooterType := 2;
    if InvoiceType = 5 then FooterType := 6;

    result := true;
    stop := false;
    jumptorecord := 0;
    PreviousRecType := InvoiceType;  // set to the type of the header line

    while not (stop or AccsData.AccsDataModule.TransactionsDB.eof) do begin
         if AccsData.AccsDataModule.TransactionsDB.RecNo = AccsData.AccsDataModule.TransactionsDB.RecordCount then exit;
         AccsData.AccsDataModule.TransactionsDB.next;

         TxType := AccsData.AccsDataModule.TransactionsDB['TxType'];

         case txtype of

                0 : Begin
                         if (AccsData.AccsDataModule.TransactionsDB['OrigType'] = InvoiceType) then begin
                                 stop := false;
                                 if PreviousRecType <> 9 then begin

                                        // invoice must have at least 1 type 9 before the type 0 line in invoice so first record after header is missing

                                        writeln(logfile,'Transaction ' + vartostr(RecordNo) + ' has missing type 9 line');
                                        result := false;
                                 end;
                            end
                                else begin

                                     // isn't a valid type 0 record - jump out to next line and return to the main loop

                                     writeln(logfile,'Transaction Line  ' + vartostr(AccsData.AccsDataModule.TransactionsDB['TxNo']) + ' appears invalid');
                                     result := false;
                                     jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'] + 1;
                                     stop := true;
                               end;

                         PreviousRecType := 0;
                end;

                1,3, 5 ,7 : Begin
                                // start of new transaction record
                                if PreviousRecType <> 0 then begin
                                    // last line of invoice is not 0 therefore a line is incorrect / missing
                                    writeln(logfile,'Transaction ' + vartostr(RecordNo) + ' has invalid / missing last line');
                                    result := false;
                                end;

                                jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                                stop := true;
                end;

                2,6 : Begin
                                // could be footer line or start of seperate payment transaction
                                if (AccsData.AccsDataModule.TransactionsDB['OrigType'] = InvoiceType) then begin
                                        if PreviousRecType <> 0 then begin
                                            // last line of invoice is not 0 therefore a line is incorrect / missing
                                            writeln(logfile,'Transaction ' + vartostr(RecordNo) + ' has invalid / missing last line');
                                            result := false;
                                        end
                                            else begin
                                             // move onto next transaction
                                             jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'] + 1;
                                             stop := true;
                                             result := true;
                                            end
                                end
                                    else begin
                                        // New Transaction
                                        if PreviousRecType <> 0 then begin
                                            // last line of invoice is not 0 therefore a line is incorrect / missing
                                            writeln(logfile,'Transaction ' + vartostr(RecordNo) + ' has invalid / missing last line');
                                            result := false;
                                        end;
                                        jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                                        stop := true;
                                    end;
                end;


                9 : Begin
                         if (AccsData.AccsDataModule.TransactionsDB['OrigType'] = InvoiceType) then begin
                                stop := false;
                             if ((PreviousRecType <> InvoiceType) and (PreviousRecType <> 0)) then begin

                                     writeln(logfile,'Transaction Line  ' + vartostr(AccsData.AccsDataModule.TransactionsDB['TxNo']) + ' appears invalid');
                                     result := false;
                                     jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                                     stop := true;

                             end;
                         end
                             else begin

                                     if (PreviousRecType <> InvoiceType) then begin
                                     // could be a valid type 9 record - jump out and let main loop run type 9 check on this record

                                     jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                                     stop := true;
                                     end
                                         else begin

                                                // could be a valid type 9 record - jump out and let main loop run type 9 check on this record
                                                writeln(logfile,'Transaction Line  ' + vartostr(AccsData.AccsDataModule.TransactionsDB['TxNo']) + ' appears invalid');
                                                result := false;


                                         end;
                                  end;

                         PreviousRecType := 9;
                end;

                11,12,15,16 : Begin
                        // these are not part of a invoice trnasaction so jump out and return to main loop
                        jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                        stop := true;
                end;


         end;
    end; // while

    if jumptorecord <> 0 then begin
           AccsData.AccsDataModule.TransactionsDB.Locate('TxNo',(jumptorecord-1),[]);  // Add - 1 as loop automatically steps forward level above this
    end;


end;



function Tauditfiles.CashbookTypeOK(CashbookType, RecordNo : Integer): boolean;
var
     FooterType: integer;
     stop, validfooter : boolean;
     jumptorecord, TxType, PreviousRecType : integer;

begin
     // Cashbook Type Transactions


     // Check Sales (11) / Purchase (15)
    // Result = True for OK transaction

    if CashbookType = 11 then FooterType := 12;
    if CashbookType = 15 then FooterType := 16;

    result := true;
    stop := false;
    jumptorecord := 0;
    validfooter := false;
    PreviousRecType := CashbookType;  // set to the type of the header line

    while not (stop or AccsData.AccsDataModule.TransactionsDB.eof) do begin
         if AccsData.AccsDataModule.TransactionsDB.RecNo = AccsData.AccsDataModule.TransactionsDB.RecordCount then exit;

         AccsData.AccsDataModule.TransactionsDB.next;


         TxType := AccsData.AccsDataModule.TransactionsDB['TxType'];

         case txtype of

                0 : Begin
                         if (AccsData.AccsDataModule.TransactionsDB['OrigType'] = CashbookType) then begin
                                 stop := false;
                                 if PreviousRecType <> 9 then begin

                                        // transaction must have at least 1 type 9 before the type 0 line so first record after header is missing
                                        writeln(logfile,'Transaction ' + vartostr(RecordNo) + ' has missing type 9 line');
                                        result := false;

                                 end;
                            end
                                else begin

                                     // isn't a valid type 0 record - jump out to next line and return to the main loop

                                     writeln(logfile,'Transaction Line  ' + vartostr(AccsData.AccsDataModule.TransactionsDB['TxNo']) + ' appears invalid');
                                     result := false;
                                     jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'] + 1;
                                     stop := true;
                               end;

                         PreviousRecType := 0;
                end;

                9 : Begin
                         if (AccsData.AccsDataModule.TransactionsDB['OrigType'] = CashbookType) then begin
                                stop := false;
                             if ((PreviousRecType <> CashbookType) and (PreviousRecType <> 0)) then begin

                                     writeln(logfile,'Transaction Line  ' + vartostr(AccsData.AccsDataModule.TransactionsDB['TxNo']) + ' appears invalid');
                                     result := false;
                                     jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                                     stop := true;

                             end;
                         end
                             else begin

                                     if (PreviousRecType <> CashbookType) then begin
                                     // could be a valid type 9 record - jump out and let main loop run type 9 check on this record

                                     jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                                     stop := true;
                                     end
                                         else begin

                                                // could be a valid type 9 record - jump out and let main loop run type 9 check on this record
                                                writeln(logfile,'Transaction Line  ' + vartostr(AccsData.AccsDataModule.TransactionsDB['TxNo']) + ' appears invalid');
                                                result := false;


                                         end;
                                  end;

                         PreviousRecType := 9;
                end;


                12,16 : Begin
                                // footer line
                                if (AccsData.AccsDataModule.TransactionsDB['OrigType'] = CashbookType) then begin
                                        ValidFooter := True;
                                        if PreviousRecType <> 0 then begin
                                            // last line of invoice is not 0 therefore a line is incorrect / missing
                                            writeln(logfile,'Transaction ' + vartostr(RecordNo) + ' has invalid / missing last line');
                                            result := false;

                                        end
                                            else begin
                                             // move onto next transaction
                                             jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'] + 1;
                                             stop := true;
                                             result := true;
                                            end
                                end
                                    else begin
                                        // error this isn't a valid footer

                                        writeln(logfile,'Transaction ' + vartostr(RecordNo) + ' has invalid footer - TxNo ' + vartostr(AccsData.AccsDataModule.TransactionsDB['TxNo']));
                                        result := false;
                                        validfooter := false;
                                        jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'] + 1;
                                        stop := true;
                                    end;
                end;




                1,2,3,5,6,7,11,15 : Begin
                        // these are not part of a invoice trnasaction so jump out and return to main loop
                        jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                        stop := true;
                end;


         end;
    end; // while

    if validfooter = false then begin
        result := false;
        writeln(logfile,'Transaction ' + vartostr(RecordNo) + ' has no valid payment line');
    end;

    if jumptorecord <> 0 then begin
           AccsData.AccsDataModule.TransactionsDB.Locate('TxNo',(jumptorecord-1),[]);  // Add - 1 as loop automatically steps forward level above this
    end;


end;



function Tauditfiles.CreditNoteTypeOK(CreditNoteType, RecordNo : Integer): boolean;
var
     stop : boolean;
     jumptorecord, TxType, PreviousRecType : integer;
begin
    // Check Sales (3) credit notes / Purchase (7)
    // Result = True for OK transaction

    result := true;
    stop := false;
    jumptorecord := 0;
    PreviousRecType := CreditNoteType;  // set to the type of the header line

    while not (stop or AccsData.AccsDataModule.TransactionsDB.eof) do begin
         if AccsData.AccsDataModule.TransactionsDB.RecNo = AccsData.AccsDataModule.TransactionsDB.RecordCount then exit;
         AccsData.AccsDataModule.TransactionsDB.next;

         TxType := AccsData.AccsDataModule.TransactionsDB['TxType'];

         case txtype of

                0 : Begin
                         if (AccsData.AccsDataModule.TransactionsDB['OrigType'] = CreditNoteType) then begin
                                 stop := false;
                                 if PreviousRecType <> 9 then begin

                                        // invoice must have at least 1 type 9 before the type 0 line in invoice so first record after header is missing

                                        writeln(logfile,'Transaction ' + vartostr(RecordNo) + ' has missing type 9 line');
                                        result := false;
                                 end;
                            end
                                else begin

                                     // isn't a valid type 0 record - jump out to next line and return to the main loop

                                     writeln(logfile,'Transaction Line  ' + vartostr(AccsData.AccsDataModule.TransactionsDB['TxNo']) + ' appears invalid');
                                     result := false;
                                     jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'] + 1;
                                     stop := true;
                               end;

                         PreviousRecType := 0;
                end;

                1, 2, 3, 5, 6, 7 : Begin
                                // start of new transaction record
                                if PreviousRecType <> 0 then begin
                                    // last line of invoice is not 0 therefore a line is incorrect / missing
                                    writeln(logfile,'Transaction ' + vartostr(RecordNo) + ' has invalid / missing last line');
                                    result := false;
                                end;

                                jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                                stop := true;
                end;




                9 : Begin
                         if (AccsData.AccsDataModule.TransactionsDB['OrigType'] = CreditNoteType) then begin
                                stop := false;
                             if ((PreviousRecType <> CreditNoteType) and (PreviousRecType <> 0)) then begin

                                     writeln(logfile,'Transaction Line  ' + vartostr(AccsData.AccsDataModule.TransactionsDB['TxNo']) + ' appears invalid');
                                     result := false;
                                     jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                                     stop := true;

                             end;
                         end
                             else begin

                                     if (PreviousRecType <> CreditNoteType) then begin
                                     // could be a valid type 9 record - jump out and let main loop run type 9 check on this record

                                     jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                                     stop := true;
                                     end
                                         else begin

                                                // could be a valid type 9 record - jump out and let main loop run type 9 check on this record
                                                writeln(logfile,'Transaction Line  ' + vartostr(AccsData.AccsDataModule.TransactionsDB['TxNo']) + ' appears invalid');
                                                result := false;


                                         end;
                                  end;

                         PreviousRecType := 9;
                end;

                11,12,15,16 : Begin
                        // these are not part of a invoice trnasaction so jump out and return to main loop
                        jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                        stop := true;
                end;


         end;
    end; // while

    if jumptorecord <> 0 then begin
           AccsData.AccsDataModule.TransactionsDB.Locate('TxNo',(jumptorecord-1),[]);  // Add - 1 as loop automatically steps forward level above this
    end;


end;

function TAuditfiles.PaymentTypeOK(PaymentType, RecordNo : Integer): boolean;
var
     stop : boolean;
     jumptorecord, TxType : integer;
begin
    // Check Sales Receipt (2) / Purchase Payment (6)
    // Result = True for OK transaction

    result := true;
    stop := false;
    jumptorecord := 0;

    while not (stop or AccsData.AccsDataModule.TransactionsDB.eof) do begin
         if AccsData.AccsDataModule.TransactionsDB.RecNo = AccsData.AccsDataModule.TransactionsDB.RecordCount then exit;
         AccsData.AccsDataModule.TransactionsDB.next;

         TxType := AccsData.AccsDataModule.TransactionsDB['TxType'];

         case txtype of

                9 : Begin
                         if (AccsData.AccsDataModule.TransactionsDB['OrigType'] = PaymentType) then begin
                                stop := false;
                                // looks like a valid transaction
                         end
                             else begin    // must be another transaction
                                       jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                                       stop := true;
                                  end;

                end;

                0,1,2,3,5,6,7,11,12,15,16 : Begin
                        // these are not part of current payment transaction so jump out and return to main loop
                        jumptorecord := AccsData.AccsDataModule.TransactionsDB['TxNo'];
                        stop := true;
                end;

         end;
    end; // while

    if jumptorecord <> 0 then begin
           AccsData.AccsDataModule.TransactionsDB.Locate('TxNo',(jumptorecord-1),[]);  // Add - 1 as loop automatically steps forward level above this
    end;

end;

function TAuditfiles.OthersTypeOK(RecordNo : Integer): boolean;
begin

    // Result = True for OK transaction
 
    result := true;

    if (AccsData.AccsDataModule.TransactionsDB['OrigType'] = '0') then begin // looks like a valid transaction
                                result := true;

    end
        else begin // looks like an invalid transaction
                  result := false;
                  writeln(logfile,'Transaction Line ' + vartostr(AccsData.AccsDataModule.TransactionsDB['TxNo']) + ' appears invalid');
        end;


end;



// 18/10/16 TGM AB - rewritten version of the FirstTXThisYear function to calculate firsttx of last year.

Function Tauditfiles.FirstTxLastYear: SmallInt;
var
i: integer;
firstyear : integer;
FirstNL, FirstSL, FirstPL : integer;
begin
     OnActivate(nil);
     OnShow(nil);
     firstyear := 10000000;   // TGM AB 21/10/16
     if cbshowtx1.checked then firstyear := 1;

     FirstNL := 0;
     FirstSL := 0;
     FirstPL := 0;


     // if fileexists('c:\kingsacc\' + RFarmGate.pLocation[2] + '\year-1.db') then firstyear := Accsdatamodule.TransactionsYr1DB.RecordCount+1;   // TGM AB 21/10/16

     if fileexists('c:\kingsacc\' + RFarmGate.pLocation[2] + '\nlfile-1.db') then begin

        Accsdatamodule.FirstTxQuery.SQL.text := 'select firsttx from ''nlfile-1'' group by firsttx';
        Accsdatamodule.FirstTxQuery.open;
        Accsdatamodule.FirstTxQuery.active := true;
        FirstNL := Accsdatamodule.FirstTxQuery['FirstTx'];
        if FirstNL = 0 then begin
                try Accsdatamodule.FirstTxQuery.next;
                    FirstNL := Accsdatamodule.FirstTxQuery['FirstTx'];
                except
                end;
        end;
        if ((FirstNL < firstyear) and (FirstNL <> 0)) then firstyear := FirstNL;
        Accsdatamodule.FirstTxQuery.active := false;

     end;

     if fileexists('c:\kingsacc\' + RFarmGate.pLocation[2] + '\slfile-1.db') then begin

        Accsdatamodule.FirstTxQuery.SQL.text := 'select firsttx from ''slfile-1'' group by firsttx';

        Accsdatamodule.FirstTxQuery.open;
        Accsdatamodule.FirstTxQuery.active := true;
        try FirstSL := Accsdatamodule.FirstTxQuery['FirstTx'];
        except
        end;
        if FirstSL = 0 then begin
                try Accsdatamodule.FirstTxQuery.next;
                    FirstSL := Accsdatamodule.FirstTxQuery['FirstTx'];
                except
                end;
        end;
        if ((FirstSL < firstyear) and (FirstSL <> 0)) then firstyear := FirstSL;
        Accsdatamodule.FirstTxQuery.active := false;


        Accsdatamodule.FirstTxQuery.SQL.text := 'select firstyear from ''slfile-1'' group by firstyear';
        Accsdatamodule.FirstTxQuery.open;
        Accsdatamodule.FirstTxQuery.active := true;
        try FirstSL := Accsdatamodule.FirstTxQuery['FirstYear'];
        except
        end;
        if FirstSL = 0 then begin
                try Accsdatamodule.FirstTxQuery.next;
                    FirstSL := Accsdatamodule.FirstTxQuery['FirstYear'];
                except
                end;
        end;
        if ((FirstSL < firstyear) and (FirstSL <> 0)) then firstyear := FirstSL;
        Accsdatamodule.FirstTxQuery.active := false;

     end;

     if fileexists('c:\kingsacc\' + RFarmGate.pLocation[2] + '\plfile-1.db') then begin

        Accsdatamodule.FirstTxQuery.SQL.text := 'select firsttx from ''plfile-1'' group by firsttx';
        Accsdatamodule.FirstTxQuery.open;
        Accsdatamodule.FirstTxQuery.active := true;
        try FirstPL := Accsdatamodule.FirstTxQuery['FirstTx'];
        except
        end;
        if FirstPL = 0 then begin
                try Accsdatamodule.FirstTxQuery.next;
                    FirstPL := Accsdatamodule.FirstTxQuery['FirstTx'];
                except
                end;
        end;
        if ((FirstPL < firstyear) and (FirstPL <> 0)) then firstyear := FirstPL;
        Accsdatamodule.FirstTxQuery.active := false;


        Accsdatamodule.FirstTxQuery.SQL.text := 'select firstyear from ''plfile-1'' group by firstyear';
        Accsdatamodule.FirstTxQuery.open;
        Accsdatamodule.FirstTxQuery.active := true;
        try FirstPL := Accsdatamodule.FirstTxQuery['FirstYear'];
        except
        end;
        if FirstPL = 0 then begin
                try Accsdatamodule.FirstTxQuery.next;
                    FirstPL := Accsdatamodule.FirstTxQuery['FirstYear'];
                except
                end;
        end;
        if ((FirstPL < firstyear) and (FirstPL <> 0)) then firstyear := FirstPL;
        Accsdatamodule.FirstTxQuery.active := false;

     end;

     if firstyear = 10000000 then result := 1   // default to 1 if no detailed last year data available          // TGM AB 21/10/16
        else result := firstyear;                                                                                // TGM AB 21/10/16

     if fileexists('c:\kingsacc\' + RFarmGate.pLocation[2] + '\year-1.db') then begin

        if result > 1 then begin
          SETDB (lasttxfile);
          READREC(lasttxfile,result-1);
          try Getitem(lastTxFile,1);
              if ((Currint = 1) or (Currint = 3) or (Currint = 5) or (Currint = 7) or (Currint = 11) or (Currint = 15)) then result := result - 1;
          except
          end;
        end;
     end;

end;



end.
