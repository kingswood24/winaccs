unit CalculateMonths;

{  File	    : CalculateMonths.PAS   TGM AB 28/02/03
  Unit	    :  CalculateMonths

  This unit contains the procedures for reading the complete transaction file and
  saved the value for the transaction against the correct nominal code in the correct
  month, ignoring any period ends completed.

  The results are stored in a 999 record Array called MonthlyArray

  18/12/15 [V4.2 R1.5] /MK Change - UpdateSLFigures, UpdatePLFigures - Passing in Integer Value instead of using RcsList.CustSuppListing.AgeByCombo.ItemIndex.

  21/09/18 [V4.3 R1.5] /MK Incorporated Changes from Andrew (TGM) - Bug Report with Aging on statements - reported by Harvey Allen.
}

interface

uses
    Types, DBCore, SysUtils, Vars, Calcs, Dialogs, Util, params, fullaudit, Accsdata;

type ArrayRec = record
                  firsttx:integer;
                  Month1:biglong;
                  Month2:biglong;
                  Month3:biglong;
                  Month4:biglong;
                  Month5:biglong;
                  Month6:biglong;
                  Month7:biglong;
                  Month8:biglong;
                  Month9:biglong;
                  Month10:biglong;
                  Month11:biglong;
                  Month12:biglong;
                  YearTotal:biglong;
                  end;

type LedgerRec = record
                  CurrMonthInvoices:biglong;
                  CurrMonthPayments:biglong;
                  Month1Invoices,Month1Payments:biglong;
                  Month2Invoices,Month2Payments:biglong;
                  BalanceAdjustment,TurnoverAdjustment:biglong; // TGM AB Ch001
                  end;

var

   MonthlyArray:array[1..999] of ArrayRec;
   LedgerArray:array[1..9999] of LedgerRec;             // TGM AB Ch001 - was 5000

   Procedure CalculateMonthlyValues;
   Procedure UpdateNLMonthlyFigures;
   Procedure UpdateNLMonthlyLastYearFigures;
   Procedure UpdateBudgetFigures;
   Procedure UpdateSLFigures(RepDate: TDateTime; AAgedItem : Integer);
   Procedure UpdatePLFigures(RepDate: TDateTime; AAgedItem : Integer);
   procedure UpdateSLFiguresAofDReport(ReportDate: TDateTime; AAgedItem : Integer);        // TGM AB Ch001 - New Procedure
   procedure UpdatePLFiguresAofDReport(ReportDate: TDateTime; AAgedItem : Integer);        // TGM AB Ch001 - New Procedure

implementation

uses RcsList;

Procedure CalculateMonthlyValues;
var
   i,Recno : integer;
   db,cr: integer;
   nom_amount,first_tx: biglong;
   VarDate : TDateTime;
   TempDate : shortstring;
   AYear, AMonth, ADay: Word;


begin

   for i:=1 to 999 do begin
       Monthlyarray[i].firsttx:=0;
       Monthlyarray[i].month1:=0;
       Monthlyarray[i].month2:=0;
       Monthlyarray[i].month3:=0;
       Monthlyarray[i].month4:=0;
       Monthlyarray[i].month5:=0;
       Monthlyarray[i].month6:=0;
       Monthlyarray[i].month7:=0;
       Monthlyarray[i].month8:=0;
       Monthlyarray[i].month9:=0;
       Monthlyarray[i].month10:=0;
       Monthlyarray[i].month11:=0;
       Monthlyarray[i].month12:=0;
       Monthlyarray[i].YearTotal:=0;
   end;

   AYear := 0;
   AMonth := 0;
   ADay := 0;

   SETDB (NlFile);
   FOR RecNo:=1 TO db1.dbrectot DO
   BEGIN
        READREC(NlFile,RECNO);
	IF RECACTIVE(NlFile) THEN BEGIN
           GetItem(NLFile,15);        // First-Tx - first transaction in current year
           MonthlyArray[RecNo].firsttx:=currint;
           GetItem(NLFile,22);        //balance-st  starting balance
           MonthlyArray[RecNo].YearTotal:=Currlong;
        end;
   end;

   // Getting Values From Tx File

   SETDB (TxFile);

   FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO
   BEGIN
   READREC(TxFile,RECNO);
   getitem(Txfile,28);

      IF ((RECACTIVE(TxFile)) and not (currstr[1] in ['E','R'])) THEN BEGIN  // TGM AB 6/6/02
        getitem(Txfile,18);        // Debit-Ac
        db:=currint;
        getitem(Txfile,19);        // Credit-Ac
        cr:=currint;
        getitem(TxFile,17);        // nom-amount
        nom_amount:=currlong;

        getitem(TxFile,2);
        KDateToStr(Currint,TempDate);
        VarDate := StrtoDate(TempDate);
        DecodeDate(VarDate, AYear, AMonth, ADay);

        first_tx:=MonthlyArray[db].firsttx;

        if ((first_tx > 0) and  (RecNo>=first_tx)) then
              begin
                   MonthlyArray[db].YearTotal:=MonthlyArray[db].YearTotal + nom_amount;

                   case AMonth of
                        1 : MonthlyArray[db].Month1:=MonthlyArray[db].Month1 + nom_amount;
                        2 : MonthlyArray[db].Month2:=MonthlyArray[db].Month2 + nom_amount;
                        3 : MonthlyArray[db].Month3:=MonthlyArray[db].Month3 + nom_amount;
                        4 : MonthlyArray[db].Month4:=MonthlyArray[db].Month4 + nom_amount;
                        5 : MonthlyArray[db].Month5:=MonthlyArray[db].Month5 + nom_amount;
                        6 : MonthlyArray[db].Month6:=MonthlyArray[db].Month6 + nom_amount;
                        7 : MonthlyArray[db].Month7:=MonthlyArray[db].Month7 + nom_amount;
                        8 : MonthlyArray[db].Month8:=MonthlyArray[db].Month8 + nom_amount;
                        9 : MonthlyArray[db].Month9:=MonthlyArray[db].Month9 + nom_amount;
                        10 : MonthlyArray[db].Month10:=MonthlyArray[db].Month10 + nom_amount;
                        11 : MonthlyArray[db].Month11:=MonthlyArray[db].Month11 + nom_amount;
                        12 : MonthlyArray[db].Month12:=MonthlyArray[db].Month12 + nom_amount;
                   end;

              end;

        first_tx:=MonthlyArray[cr].firsttx;

        if ((first_tx > 0) and  (RecNo>=first_tx)) then
              begin
                   MonthlyArray[cr].YearTotal:=MonthlyArray[cr].YearTotal - nom_amount;

                   case AMonth of
                        1 : MonthlyArray[cr].Month1:=MonthlyArray[cr].Month1 - nom_amount;
                        2 : MonthlyArray[cr].Month2:=MonthlyArray[cr].Month2 - nom_amount;
                        3 : MonthlyArray[cr].Month3:=MonthlyArray[cr].Month3 - nom_amount;
                        4 : MonthlyArray[cr].Month4:=MonthlyArray[cr].Month4 - nom_amount;
                        5 : MonthlyArray[cr].Month5:=MonthlyArray[cr].Month5 - nom_amount;
                        6 : MonthlyArray[cr].Month6:=MonthlyArray[cr].Month6 - nom_amount;
                        7 : MonthlyArray[cr].Month7:=MonthlyArray[cr].Month7- nom_amount;
                        8 : MonthlyArray[cr].Month8:=MonthlyArray[cr].Month8 - nom_amount;
                        9 : MonthlyArray[cr].Month9:=MonthlyArray[cr].Month9 - nom_amount;
                        10 : MonthlyArray[cr].Month10:=MonthlyArray[cr].Month10 - nom_amount;
                        11 : MonthlyArray[cr].Month11:=MonthlyArray[cr].Month11 - nom_amount;
                        12 : MonthlyArray[cr].Month12:=MonthlyArray[cr].Month12 - nom_amount;
                   end;

              end;
     end;
   end;

end;

procedure UpdateNLMonthlyFigures;
var
   RecNo : Integer;
begin
     SETDB (NlFile);
     FOR RecNo:=1 TO db1.dbrechigh DO
     BEGIN
        READREC(NlFile,RECNO);
        IF RECACTIVE(NlFile) THEN BEGIN
           Currlong := MonthlyArray[RecNo].Month1;
           PutItem(NLFile,49);
           Currlong := MonthlyArray[RecNo].Month2;
           PutItem(NLFile,50);
           Currlong := MonthlyArray[RecNo].Month3;
           PutItem(NLFile,51);
           Currlong := MonthlyArray[RecNo].Month4;
           PutItem(NLFile,52);
           Currlong := MonthlyArray[RecNo].Month5;
           PutItem(NLFile,53);
           Currlong := MonthlyArray[RecNo].Month6;
           PutItem(NLFile,54);
           Currlong := MonthlyArray[RecNo].Month7;
           PutItem(NLFile,55);
           Currlong := MonthlyArray[RecNo].Month8;
           PutItem(NLFile,56);
           Currlong := MonthlyArray[RecNo].Month9;
           PutItem(NLFile,57);
           Currlong := MonthlyArray[RecNo].Month10;
           PutItem(NLFile,58);
           Currlong := MonthlyArray[RecNo].Month11;
           PutItem(NLFile,59);
           Currlong := MonthlyArray[RecNo].Month12;
           PutItem(NLFile,60);
           REWRITEREC(NlFile,RECNO);
        end;
    end;

end;

procedure UpdateNLMonthlyLastYearFigures;
var
   RecNo : Integer;
begin
     SETDB (NlFile);
     FOR RecNo:=1 TO db1.dbrechigh DO
     BEGIN
        READREC(NlFile,RECNO);
        IF RECACTIVE(NlFile) THEN BEGIN
           Currlong := MonthlyArray[RecNo].Month1;
           PutItem(NLFile,65);
           Currlong := MonthlyArray[RecNo].Month2;
           PutItem(NLFile,66);
           Currlong := MonthlyArray[RecNo].Month3;
           PutItem(NLFile,67);
           Currlong := MonthlyArray[RecNo].Month4;
           PutItem(NLFile,68);
           Currlong := MonthlyArray[RecNo].Month5;
           PutItem(NLFile,69);
           Currlong := MonthlyArray[RecNo].Month6;
           PutItem(NLFile,70);
           Currlong := MonthlyArray[RecNo].Month7;
           PutItem(NLFile,71);
           Currlong := MonthlyArray[RecNo].Month8;
           PutItem(NLFile,72);
           Currlong := MonthlyArray[RecNo].Month9;
           PutItem(NLFile,73);
           Currlong := MonthlyArray[RecNo].Month10;
           PutItem(NLFile,74);
           Currlong := MonthlyArray[RecNo].Month11;
           PutItem(NLFile,75);
           Currlong := MonthlyArray[RecNo].Month12;
           PutItem(NLFile,76);
           REWRITEREC(NlFile,RECNO);
        end;
    end;

end;


procedure UpdateBudgetFigures;
var
   RecNo : Integer;
begin
     SETDB (NlFile);
     FOR RecNo:=1 TO db1.dbrechigh DO
     BEGIN
        READREC(NlFile,RECNO);
        IF RECACTIVE(NlFile) THEN BEGIN
           Currlong := MonthlyArray[RecNo].Month1;
           PutItem(NLFile,33);
           Currlong := MonthlyArray[RecNo].Month2;
           PutItem(NLFile,34);
           Currlong := MonthlyArray[RecNo].Month3;
           PutItem(NLFile,35);
           Currlong := MonthlyArray[RecNo].Month4;
           PutItem(NLFile,36);
           Currlong := MonthlyArray[RecNo].Month5;
           PutItem(NLFile,37);
           Currlong := MonthlyArray[RecNo].Month6;
           PutItem(NLFile,38);
           Currlong := MonthlyArray[RecNo].Month7;
           PutItem(NLFile,39);
           Currlong := MonthlyArray[RecNo].Month8;
           PutItem(NLFile,40);
           Currlong := MonthlyArray[RecNo].Month9;
           PutItem(NLFile,41);
           Currlong := MonthlyArray[RecNo].Month10;
           PutItem(NLFile,42);
           Currlong := MonthlyArray[RecNo].Month11;
           PutItem(NLFile,43);
           Currlong := MonthlyArray[RecNo].Month12;
           PutItem(NLFile,44);
           Currlong := MonthlyArray[RecNo].YearTotal;
           PutItem(NLFile,7);
           REWRITEREC(NlFile,RECNO);
        end;
    end;

end;

procedure UpdatePLFigures(RepDate: TDateTime; AAgedItem : Integer);
var
   i : integer;
   AYear, AMonth, ADay: Word;
   CurrentYear, CurrentMonth, account : integer;

   month_1, month_2 : integer;
   nom_amount, templong : biglong;
   RecNo, Tempint : integer;
   VarDate : TDateTime;
   TempDate : shortstring;
   datadir : string;
   balance, month1total, month2total, month3total, currenttotal : biglong;
   IntAYear : integer;
   Teststring : string;
begin
     // updates PL age of debt
     for i:= 1 to 9999 do begin                                // TGM AB Ch001 - was 5000
         LedgerArray[i].CurrMonthInvoices := 0;
         LedgerArray[i].CurrMonthPayments := 0;
         LedgerArray[i].Month1Invoices := 0;
         LedgerArray[i].Month1Payments := 0;
         LedgerArray[i].Month2Invoices := 0;
         LedgerArray[i].Month2Payments := 0;

     end;

     //TGM AB Gather Archive Files
     Accsdatamodule.GatherPreviousYears;

     AYear := 0;
     AMonth := 0;
     ADay := 0;
     currentmonth :=0;
     Currentyear := 0;
     month_1 := 0;
     month_2 := 0;

     DecodeDate(RepDate, AYear, AMonth, ADay);

     CurrentYear := AYear;
     CurrentYear := Currentyear*100;

     case AAgedItem of
     0: begin
        currentmonth := CurrentYear + AMonth;
        If AMonth > 1 then month_1 := CurrentYear + Amonth-1
           else month_1 := (CurrentYear -100) + (AMonth + 11);
        If AMonth >= 3 then month_2 := CurrentYear + Amonth-2     // was >
           else month_2 := (CurrentYear - 100) + (Amonth + 10);
        end;
     1: begin
        If Amonth > 1 then currentmonth := CurrentYear + AMonth-1
           else CurrentMonth := (CurrentYear - 100) +(Amonth + 11);
        If AMonth > 3 then month_1 := CurrentYear + AMonth - 3
           else month_1 := (CurrentYear - 100) +(Amonth + 9);
        If AMonth > 5 then month_2 := CurrentYear + AMonth- 5
           else month_2 := (CurrentYear - 100) + (AMonth + 7);
        end;
     2: begin
        If AMonth > 2 then currentmonth := Currentyear + AMonth-2
           else CurrentMonth :=  (CurrentYear - 100) + (Amonth + 10);
        if AMonth > 5 then month_1 := CurrentYear + AMonth - 5
           else month_1 := (CurrentYear - 100) +(Amonth + 7);
        if AMonth > 8 then month_2 := CurrentYear + AMonth- 8
           else month_2 := (CurrentYear - 100) +(Amonth + 4);
        end;
     3: begin
        if AMonth > 5 then currentmonth := CurrentYear + AMonth-5
           else CurrentMonth :=  (CurrentYear - 100) + (Amonth + 7);
        if AMonth > 11 then month_1 := Currentyear + AMonth - 11
           else month_1 := (CurrentYear - 100) + (Amonth +1);
        if AMonth > 5 then Month_2:= (CurrentYear-100) + AMonth -5
        else month_2 := (CurrentYear - 200) + (Amonth + 7);
        end;
     4: begin
        if AMonth > 8 then currentmonth := CurrentYear + AMonth-8
           else CurrentMonth :=  (CurrentYear - 100) + (Amonth + 4);
        if AMonth > 5 then month_1 := Currentyear - 100 + AMonth - 5
           else month_1 := (CurrentYear - 200) + (Amonth + 7);
        if AMonth > 2 then Month_2:= CurrentYear - 200 + AMonth- 2
        else month_2 := (CurrentYear - 300) + (Amonth + 10);
        end;
     5: begin
             CurrentMonth := CurrentYear - 100+ Amonth;
             month_1 := CurrentYear - 200 + Amonth;
             month_2 := CurrentYear - 300 + AMonth;
        end;

     end;

     // Getting Values From Tx File

     Accsdatamodule.TransactionsDB.Last;

     FOR i:=(Accsdatamodule.TransactionsDB.recordcount) DOWNTO 1 DO
     BEGIN

     Teststring := '';
     Teststring := vartostr(accsdatamodule.transactionsDB['EditStat']);

        IF ((Teststring <> 'E') and (Teststring <> 'R')) THEN BEGIN
           if accsdatamodule.transactionsDB['TxType'] = 9 then begin
              if ((accsdatamodule.transactionsDB['OrigType'] = 5) or (accsdatamodule.transactionsDB['OrigType'] = 7)) then begin
                 account := accsdatamodule.transactionsDB['Account'];       // Account
                 nom_amount:=(accsdatamodule.transactionsDB['Amount'] * 100);     // amount
                 nom_amount:=nom_amount + (accsdatamodule.transactionsDB['TaxDisc'] * 100); // vat
                 VarDate := accsdatamodule.transactionsDB['TxDate'];
                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthInvoices := LedgerArray[Account].CurrMonthInvoices + nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Invoices := LedgerArray[Account].Month1Invoices + nom_amount
                            else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Invoices := LedgerArray[Account].Month2Invoices + nom_amount;
            //           end;
              end; // [5]
           end; // [9]
           if accsdatamodule.transactionsDB['TxType'] = 6 then begin
                 if ((accsdatamodule.transactionsDB['OrigType'] = 5) or (accsdatamodule.transactionsDB['OrigType'] = 6)) then begin     // TGM AB Ch001
                    account := accsdatamodule.transactionsDB['Account'];       // Account
                    nom_amount:=(accsdatamodule.transactionsDB['Amount'] * 100);     // amount
                    nom_amount:=nom_amount + (accsdatamodule.transactionsDB['TaxDisc'] * 100); // vat
                    VarDate := accsdatamodule.transactionsDB['TxDate'];
                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthPayments := LedgerArray[Account].CurrMonthPayments - nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Payments := LedgerArray[Account].Month1Payments - nom_amount
                             else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Payments := LedgerArray[Account].Month2Payments - nom_amount;
                 end; //[6]
           end; // [6]
        end;
     Accsdatamodule.TransactionsDB.Prior;
     end;

     DataDir := RFarmGate.pLocation[2];
     if FileExists('c:\kingsacc\' + datadir + '\year-1.db') then begin
     Accsdatamodule.TransactionsYr1DB.Open;
     Accsdatamodule.TransactionsYr1DB.last;

     FOR i:=(Accsdatamodule.TransactionsYr1DB.recordcount) DOWNTO 1 DO
     BEGIN

     Teststring := '';
     Teststring := vartostr(accsdatamodule.transactionsYr1DB['EditStat']);

        IF ((Teststring <> 'E') and (Teststring <> 'R')) THEN BEGIN
           if accsdatamodule.transactionsYr1DB['TxType'] = 9 then begin
              if ((accsdatamodule.transactionsYr1DB['OrigType'] = 5) or (accsdatamodule.transactionsYr1DB['OrigType'] = 7)) then begin
                 account := accsdatamodule.transactionsYr1DB['Account'];       // Account
                 nom_amount:=(accsdatamodule.transactionsYr1DB['Amount'] * 100);     // amount
                 nom_amount:=nom_amount + (accsdatamodule.transactionsYr1DB['TaxDisc'] * 100); // vat
                 VarDate := accsdatamodule.transactionsYr1DB['TxDate'];
                 DecodeDate(VarDate, AYear, AMonth, ADay);
                 IntAYear := AYear *100;
                 if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthInvoices := LedgerArray[Account].CurrMonthInvoices + nom_amount
                    else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Invoices := LedgerArray[Account].Month1Invoices + nom_amount
                         else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Invoices := LedgerArray[Account].Month2Invoices + nom_amount;
              end; // [5]
           end; // [9]
           if accsdatamodule.transactionsYr1DB['TxType'] = 6 then begin
                 if ((accsdatamodule.transactionsDB['OrigType'] = 5) or (accsdatamodule.transactionsDB['OrigType'] = 6)) then begin     // TGM AB Ch001
                    account := accsdatamodule.transactionsYr1DB['Account'];       // Account
                    nom_amount:=(accsdatamodule.transactionsYr1DB['Amount'] * 100);     // amount
                    nom_amount:=nom_amount + (accsdatamodule.transactionsYr1DB['TaxDisc'] * 100); // vat
                    VarDate := accsdatamodule.transactionsYr1DB['TxDate'];
                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthPayments := LedgerArray[Account].CurrMonthPayments - nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Payments := LedgerArray[Account].Month1Payments - nom_amount
                             else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Payments := LedgerArray[Account].Month2Payments - nom_amount;
                 end; //[6]
           end; // [6]
        end;
     Accsdatamodule.TransactionsYr1DB.Prior;
     end;
     end;

     DataDir := RFarmGate.pLocation[2];
     if FileExists('c:\kingsacc\' + datadir + '\year-2.db') then begin
     Accsdatamodule.TransactionsYr2DB.Open;
     Accsdatamodule.TransactionsYr2DB.last;

     FOR i:=(Accsdatamodule.TransactionsYr2DB.recordcount) DOWNTO 1 DO
     BEGIN

     Teststring := '';
     Teststring := vartostr(accsdatamodule.transactionsYr2DB['EditStat']);

        IF ((Teststring <> 'E') and (Teststring <> 'R')) THEN BEGIN
           if accsdatamodule.transactionsYr2DB['TxType'] = 9 then begin
              if ((accsdatamodule.transactionsYr2DB['OrigType'] = 5) or (accsdatamodule.transactionsYr2DB['OrigType'] = 7)) then begin
                 account := accsdatamodule.transactionsYr2DB['Account'];       // Account
                 nom_amount:=(accsdatamodule.transactionsYr2DB['Amount'] * 100);     // amount
                 nom_amount:=nom_amount + (accsdatamodule.transactionsYr2DB['TaxDisc'] * 100); // vat
                 VarDate := accsdatamodule.transactionsYr2DB['TxDate'];
                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthInvoices := LedgerArray[Account].CurrMonthInvoices + nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Invoices := LedgerArray[Account].Month1Invoices + nom_amount
                            else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Invoices := LedgerArray[Account].Month2Invoices + nom_amount;
              end; // [5]
           end; // [9]
           if accsdatamodule.transactionsYr2DB['TxType'] = 6 then begin
                 if ((accsdatamodule.transactionsDB['OrigType'] = 5) or (accsdatamodule.transactionsDB['OrigType'] = 6)) then begin     // TGM AB Ch001
                    account := accsdatamodule.transactionsYr2DB['Account'];       // Account
                    nom_amount:=(accsdatamodule.transactionsYr2DB['Amount'] * 100);     // amount
                    nom_amount:=nom_amount + (accsdatamodule.transactionsYr2DB['TaxDisc'] * 100); // vat
                    VarDate := accsdatamodule.transactionsYr2DB['TxDate'];
                        DecodeDate(VarDate, AYear, AMonth, ADay);
                        IntAYear := AYear *100;
                        if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthPayments := LedgerArray[Account].CurrMonthPayments - nom_amount
                           else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Payments := LedgerArray[Account].Month1Payments - nom_amount
                                 else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Payments := LedgerArray[Account].Month2Payments - nom_amount;
                 end; //[6]
           end; // [6]
        end;
     Accsdatamodule.TransactionsYr2DB.Prior;
     end;
     end;

     SETDB (PLFile);
     accsdatamodule.PLFileDB.first;
        FOR i:=1 TO accsdatamodule.PLFileDB.RecordCount do
        BEGIN
             accsdatamodule.PLFileDB.Edit;
             IF accsdatamodule.PLFileDB['Active'] = true THEN BEGIN
                Balance := (accsdatamodule.PLFileDB['Balance'] * 100); // balance
                if balance < 0 then begin
                   currlong := ledgerarray[i].currmonthPayments;
                   if currlong <= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.PLFileDB.Edit;
                   accsdatamodule.PLFileDB['AgeCurr'] := currlong /100;
                   accsdatamodule.PLFileDB.post;
                   currlong := ledgerarray[i].month1Payments;
                   if currlong <= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.PLFileDB.Edit;
                   accsdatamodule.PLFileDB['Age1'] := currlong /100;
                   accsdatamodule.PLFileDB.post;
                   currlong := ledgerarray[i].month2Payments;
                   if currlong <= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.PLFileDB.Edit;
                   accsdatamodule.PLFileDB['Age2'] := currlong /100;
                   accsdatamodule.PLFileDB.post;
                   Templong := Balance;
                   currlong := templong;
                   accsdatamodule.PLFileDB.Edit;
                   accsdatamodule.PLFileDB['Age3'] := currlong /100;
                   accsdatamodule.PLFileDB.post;
                end else                                                        // TGM AB Ch001
                if balance > 0 then begin
                   currlong := ledgerarray[i].currmonthInvoices;
                   if currlong >= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.PLFileDB.Edit;
                   accsdatamodule.PLFileDB['AgeCurr'] := currlong /100;
                   accsdatamodule.PLFileDB.post;
                   currlong := ledgerarray[i].month1Invoices;
                   if currlong >= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.PLFileDB.Edit;
                   accsdatamodule.PLFileDB['Age1'] := currlong /100;
                   accsdatamodule.PLFileDB.post;
                   currlong := ledgerarray[i].month2Invoices;
                   if currlong >= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.PLFileDB.Edit;
                   accsdatamodule.PLFileDB['Age2'] := currlong /100;
                   accsdatamodule.PLFileDB.post;
                   Templong := Balance;
                   currlong := templong;
                   accsdatamodule.PLFileDB.Edit;
                   accsdatamodule.PLFileDB['Age3'] := currlong /100;
                   accsdatamodule.PLFileDB.post;
                end else                                                             // TGM AB Ch001
                if balance = 0 then begin                                            // TGM AB Ch001
                   accsdatamodule.PLFileDB.Edit;                                     // TGM AB Ch001
                   accsdatamodule.PLFileDB['AgeCurr'] := 0;                          // TGM AB Ch001      // TGM AB Ch008
                   accsdatamodule.PLFileDB['Age1'] := 0;                             // TGM AB Ch001      // TGM AB Ch008
                   accsdatamodule.PLFileDB['Age2'] := 0;                             // TGM AB Ch001      // TGM AB Ch008
                   accsdatamodule.PLFileDB['Age3'] := 0;                             // TGM AB Ch001      // TGM AB Ch008
                   accsdatamodule.PLFileDB.post;                                     // TGM AB Ch001
                end;                                                                 // TGM AB Ch001
             end;
             accsdatamodule.PLFileDB.next;
        end;
end;


procedure UpdateSLFigures(RepDate: TDateTime; AAgedItem : Integer);
var
   i : integer;
   AYear, AMonth, ADay: Word;
   CurrentYear, CurrentMonth, account : integer;

   month_1, month_2 : integer;
   nom_amount, templong : biglong;
   RecNo, Tempint : integer;
   VarDate : TDateTime;
   TempDate : shortstring;
   datadir : string;
   balance, month1total, month2total, month3total, currenttotal : biglong;
   IntAYear : integer;
   Teststring : string;
begin
     // updates SL age of debt
     for i:= 1 to 9999 do begin                             // TGM AB Ch001 - was 5000
         LedgerArray[i].CurrMonthInvoices := 0;
         LedgerArray[i].CurrMonthPayments := 0;
         LedgerArray[i].Month1Invoices := 0;
         LedgerArray[i].Month1Payments := 0;
         LedgerArray[i].Month2Invoices := 0;
         LedgerArray[i].Month2Payments := 0;

     end;

     //TGM AB Gather Archive Files
     Accsdatamodule.GatherPreviousYears;

 //    Issues with >= and month number!!!!!!!!!!!!

     AYear := 0;
     AMonth := 0;
     ADay := 0;
     currentmonth :=0;
     Currentyear := 0;
     month_1 := 0;
     month_2 := 0;

     DecodeDate(RepDate, AYear, AMonth, ADay);

     CurrentYear := AYear;
     CurrentYear := Currentyear*100;

     case AAgedItem of
     0: begin
        currentmonth := CurrentYear + AMonth;
        If AMonth > 1 then month_1 := CurrentYear + Amonth-1
           else month_1 := (CurrentYear -100) + (AMonth + 11);
        If AMonth >= 3 then month_2 := CurrentYear + Amonth-2       // was >
           else month_2 := (CurrentYear - 100) + (Amonth + 10);
        end;
     1: begin
        If Amonth > 1 then currentmonth := CurrentYear + AMonth-1
           else CurrentMonth := (CurrentYear - 100) +(Amonth + 11);
        If AMonth > 3 then month_1 := CurrentYear + AMonth - 3
           else month_1 := (CurrentYear - 100) +(Amonth + 9);
        If AMonth > 5 then month_2 := CurrentYear + AMonth- 5
           else month_2 := (CurrentYear - 100) + (AMonth + 7);
        end;
     2: begin
        If AMonth > 2 then currentmonth := Currentyear + AMonth-2
           else CurrentMonth :=  (CurrentYear - 100) + (Amonth + 10);
        if AMonth > 5 then month_1 := CurrentYear + AMonth - 5
           else month_1 := (CurrentYear - 100) +(Amonth + 7);
        if AMonth > 8 then month_2 := CurrentYear + AMonth- 8
           else month_2 := (CurrentYear - 100) +(Amonth + 4);
        end;
     3: begin
        if AMonth > 5 then currentmonth := CurrentYear + AMonth-5
           else CurrentMonth :=  (CurrentYear - 100) + (Amonth + 7);
        if AMonth > 11 then month_1 := Currentyear + AMonth - 11
           else month_1 := (CurrentYear - 100) + (Amonth +1);
        if AMonth > 5 then Month_2:= (CurrentYear-100) + AMonth -5
        else month_2 := (CurrentYear - 200) + (Amonth + 7);
        end;
     4: begin
        if AMonth > 8 then currentmonth := CurrentYear + AMonth-8
           else CurrentMonth :=  (CurrentYear - 100) + (Amonth + 4);
        if AMonth > 5 then month_1 := Currentyear - 100 + AMonth - 5
           else month_1 := (CurrentYear - 200) + (Amonth + 7);
        if AMonth > 2 then Month_2:= CurrentYear - 200 + AMonth- 2
        else month_2 := (CurrentYear - 300) + (Amonth + 10);
        end;
     5: begin
             CurrentMonth := CurrentYear - 100+ Amonth;
             month_1 := CurrentYear - 200 + Amonth;
             month_2 := CurrentYear - 300 + AMonth;
        end;

     end;

     // Getting Values From Tx File

     Accsdatamodule.TransactionsDB.Last;

     FOR i:=(Accsdatamodule.TransactionsDB.recordcount) DOWNTO 1 DO
     BEGIN

     Teststring := '';
     Teststring := vartostr(accsdatamodule.transactionsDB['EditStat']);
        IF ((Teststring <> 'E') and (Teststring <> 'R')) THEN BEGIN
           if accsdatamodule.transactionsDB['TxType'] = 9 then begin
              if ((accsdatamodule.transactionsDB['OrigType'] = 1) or (accsdatamodule.transactionsDB['OrigType'] = 3)) then begin  // TGM AB 06/02/15 Removed 'or (accsdatamodule.transactionsDB['OrigType'] = 7)'
                 account := accsdatamodule.transactionsDB['Account'];       // Account
                 nom_amount:=(accsdatamodule.transactionsDB['Amount'] * 100);     // amount
                 nom_amount:=nom_amount + (accsdatamodule.transactionsDB['TaxDisc'] * 100); // vat
                 VarDate := accsdatamodule.transactionsDB['TxDate'];
                 DecodeDate(VarDate, AYear, AMonth, ADay);
                 IntAYear := AYear *100;
                 if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthInvoices := LedgerArray[Account].CurrMonthInvoices + nom_amount
                    else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Invoices := LedgerArray[Account].Month1Invoices + nom_amount
                         else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Invoices := LedgerArray[Account].Month2Invoices + nom_amount;
              end; // [1]
           end; // [9]
           if accsdatamodule.transactionsDB['TxType'] = 2 then begin
                 if ((accsdatamodule.transactionsDB['OrigType'] = 1) or (accsdatamodule.transactionsDB['OrigType'] = 2)) then begin     // TGM AB Ch001
                    account := accsdatamodule.transactionsDB['Account'];       // Account
                    nom_amount:=(accsdatamodule.transactionsDB['Amount'] * 100);     // amount
                    nom_amount:=nom_amount + (accsdatamodule.transactionsDB['TaxDisc'] * 100); // vat
                    VarDate := accsdatamodule.transactionsDB['TxDate'];
                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthPayments := LedgerArray[Account].CurrMonthPayments - nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Payments := LedgerArray[Account].Month1Payments - nom_amount
                             else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Payments := LedgerArray[Account].Month2Payments - nom_amount;
                 end; //[2]
           end; // [2]
        end;
     Accsdatamodule.TransactionsDB.Prior;
     end;

     DataDir := RFarmGate.pLocation[2];
     if FileExists('c:\kingsacc\' + datadir + '\year-1.db') then begin
     Accsdatamodule.TransactionsYr1DB.Open;
     Accsdatamodule.TransactionsYr1DB.last;

     FOR i:=(Accsdatamodule.TransactionsYr1DB.recordcount) DOWNTO 1 DO
     BEGIN

     Teststring := '';
     Teststring := vartostr(accsdatamodule.transactionsYr1DB['EditStat']);

        IF ((Teststring <> 'E') and (Teststring <> 'R')) THEN BEGIN
           if accsdatamodule.transactionsYr1DB['TxType'] = 9 then begin
              if ((accsdatamodule.transactionsYr1DB['OrigType'] = 1) or (accsdatamodule.transactionsYr1DB['OrigType'] = 3)) then begin
                 account := accsdatamodule.transactionsYr1DB['Account'];       // Account
                 nom_amount:=(accsdatamodule.transactionsYr1DB['Amount'] * 100);     // amount
                 nom_amount:=nom_amount + (accsdatamodule.transactionsYr1DB['TaxDisc'] * 100); // vat
                 VarDate := accsdatamodule.transactionsYr1DB['TxDate'];
                 DecodeDate(VarDate, AYear, AMonth, ADay);
                 IntAYear := AYear *100;
                 if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthInvoices := LedgerArray[Account].CurrMonthInvoices + nom_amount
                    else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Invoices := LedgerArray[Account].Month1Invoices + nom_amount
                         else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Invoices := LedgerArray[Account].Month2Invoices + nom_amount;
              end; // [1]
           end; // [9]
           if accsdatamodule.transactionsYr1DB['TxType'] = 2 then begin
                 if ((accsdatamodule.transactionsDB['OrigType'] = 1) or (accsdatamodule.transactionsDB['OrigType'] = 2)) then begin     // TGM AB Ch001
                    account := accsdatamodule.transactionsYr1DB['Account'];       // Account
                    nom_amount:=(accsdatamodule.transactionsYr1DB['Amount'] * 100);     // amount
                    nom_amount:=nom_amount + (accsdatamodule.transactionsYr1DB['TaxDisc'] * 100); // vat
                    VarDate := accsdatamodule.transactionsYr1DB['TxDate'];
                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthPayments := LedgerArray[Account].CurrMonthPayments - nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Payments := LedgerArray[Account].Month1Payments - nom_amount
                             else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Payments := LedgerArray[Account].Month2Payments - nom_amount;
                 end; //[2]
           end; // [2]
        end; // if editstat
     Accsdatamodule.TransactionsYr1DB.Prior;
     end;
     end;

     DecodeDate(RepDate, AYear, AMonth, ADay);
     DataDir := RFarmGate.pLocation[2];
     if FileExists('c:\kingsacc\' + datadir + '\year-2.db') then begin
        Accsdatamodule.TransactionsYr2DB.Open;
        Accsdatamodule.TransactionsYr2DB.last;

     FOR i:=(Accsdatamodule.TransactionsYr2DB.recordcount) DOWNTO 1 DO
     BEGIN

     Teststring := '';
     Teststring := vartostr(accsdatamodule.transactionsYr2DB['EditStat']);

            IF ((Teststring <> 'E') and (Teststring <> 'R')) THEN BEGIN
           if accsdatamodule.transactionsYr2DB['TxType'] = 9 then begin
              if ((accsdatamodule.transactionsYr2DB['OrigType'] = 1) or (accsdatamodule.transactionsYr2DB['OrigType'] = 3)) then begin
                 account := accsdatamodule.transactionsYr2DB['Account'];       // Account
                 nom_amount:=(accsdatamodule.transactionsYr2DB['Amount'] * 100);     // amount
                 nom_amount:=nom_amount + (accsdatamodule.transactionsYr2DB['TaxDisc'] * 100); // vat
                 VarDate := accsdatamodule.transactionsYr2DB['TxDate']; 
                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthInvoices := LedgerArray[Account].CurrMonthInvoices + nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Invoices := LedgerArray[Account].Month1Invoices + nom_amount
                            else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Invoices := LedgerArray[Account].Month2Invoices + nom_amount;
              end; // [1]
           end; // [9]
           if accsdatamodule.transactionsYr2DB['TxType'] = 2 then begin
                 if ((accsdatamodule.transactionsDB['OrigType'] = 1) or (accsdatamodule.transactionsDB['OrigType'] = 2)) then begin     // TGM AB Ch001
                    account := accsdatamodule.transactionsYr2DB['Account'];       // Account
                    nom_amount:=(accsdatamodule.transactionsYr2DB['Amount'] * 100);     // amount
                    nom_amount:=nom_amount + (accsdatamodule.transactionsYr2DB['TaxDisc'] * 100); // vat
                    VarDate := accsdatamodule.transactionsYr2DB['TxDate'];
                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthPayments := LedgerArray[Account].CurrMonthPayments - nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Payments := LedgerArray[Account].Month1Payments - nom_amount
                             else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Payments := LedgerArray[Account].Month2Payments - nom_amount;
                 end; //[2]
           end; // [2]
        end; // if editstat
     Accsdatamodule.TransactionsYr2DB.Prior;
     end;
     end;

        accsdatamodule.SLFileDB.first;
        FOR i:=1 TO accsdatamodule.SLFileDB.RecordCount do
        BEGIN
             IF accsdatamodule.SLFileDB['Active'] = true THEN BEGIN
                Balance := (accsdatamodule.SLFileDB['Balance'] * 100); // balance
                if balance < 0 then begin
                   currlong := ledgerarray[i].currmonthPayments;
                   if currlong <= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['AgeCurr'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                   currlong := ledgerarray[i].month1Payments;
                   if currlong <= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Age1'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                   currlong := ledgerarray[i].month2Payments;
                   if currlong <= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Age2'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                   Templong := Balance;
                   currlong := templong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Age3'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                end else                                       // TGM AB Ch001
                if balance > 0 then begin
                   currlong := ledgerarray[i].currmonthInvoices;
                   if currlong >= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['AgeCurr'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                   currlong := ledgerarray[i].month1Invoices;
                   if currlong >= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Age1'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                   currlong := ledgerarray[i].month2Invoices;
                   if currlong >= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Age2'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                   Templong := Balance;
                   currlong := templong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Age3'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                end else                                                             // TGM AB Ch001
                if balance = 0 then begin                                            // TGM AB Ch001
                   accsdatamodule.SLFileDB.Edit;                                     // TGM AB Ch001
                   accsdatamodule.SLFileDB['AgeCurr'] := 0;                          // TGM AB Ch001     // TGM AB Ch008
                   accsdatamodule.SLFileDB['Age1'] := 0;                             // TGM AB Ch001     // TGM AB Ch008
                   accsdatamodule.SLFileDB['Age2'] := 0;                             // TGM AB Ch001     // TGM AB Ch008
                   accsdatamodule.SLFileDB['Age3'] := 0;                             // TGM AB Ch001     // TGM AB Ch008
                   accsdatamodule.SLFileDB.post;                                     // TGM AB Ch001
                end;                                                                 // TGM AB Ch001
             end;
             accsdatamodule.SLFileDB.next;
        end;
end;

procedure UpdateSLFiguresAofDReport(ReportDate: TDateTime; AAgedItem : Integer);        // TGM AB Ch001 - New Procedure
var
   i : integer;
   AYear, AMonth, ADay: Word;
   CurrentYear, CurrentMonth, account : integer;

   month_1, month_2 : integer;
   nom_amount, templong : biglong;
   RecNo, Tempint : integer;
   VarDate : TDateTime;
   TempDate : shortstring;
   datadir : string;
   balance, month1total, month2total, month3total, currenttotal : biglong;
   IntAYear : integer;
   Teststring : string;
begin

     // updates SL age of debt
     for i:= 1 to 9999 do begin
         LedgerArray[i].CurrMonthInvoices := 0;
         LedgerArray[i].CurrMonthPayments := 0;
         LedgerArray[i].Month1Invoices := 0;
         LedgerArray[i].Month1Payments := 0;
         LedgerArray[i].Month2Invoices := 0;
         LedgerArray[i].Month2Payments := 0;
         LedgerArray[i].BalanceAdjustment := 0;
         LedgerArray[i].TurnoverAdjustment := 0;

     end;

     // Gather Archive Year Files
     Accsdatamodule.GatherPreviousYears;

     AYear := 0;
     AMonth := 0;
     ADay := 0;
     currentmonth :=0;
     Currentyear := 0;
     month_1 := 0;
     month_2 := 0;


     DecodeDate(ReportDate, AYear, AMonth, ADay);

     CurrentYear := AYear*100;

     case AAgedItem of
     0: begin
        currentmonth := CurrentYear + AMonth;
        If AMonth > 1 then month_1 := CurrentYear + Amonth-1
           else month_1 := (CurrentYear -100) + (AMonth + 11);
        If AMonth >= 3 then month_2 := CurrentYear + Amonth-2       // was >
           else month_2 := (CurrentYear - 100) + (Amonth + 10);
        end;
     1: begin
        If Amonth > 1 then currentmonth := CurrentYear + AMonth-1
           else CurrentMonth := (CurrentYear - 100) +(Amonth + 11);
        If AMonth > 3 then month_1 := CurrentYear + AMonth - 3
           else month_1 := (CurrentYear - 100) +(Amonth + 9);
        If AMonth > 5 then month_2 := CurrentYear + AMonth- 5
           else month_2 := (CurrentYear - 100) + (AMonth + 7);
        end;
     2: begin
        If AMonth > 2 then currentmonth := Currentyear + AMonth-2
           else CurrentMonth :=  (CurrentYear - 100) + (Amonth + 10);
        if AMonth > 5 then month_1 := CurrentYear + AMonth - 5
           else month_1 := (CurrentYear - 100) +(Amonth + 7);
        if AMonth > 8 then month_2 := CurrentYear + AMonth- 8
           else month_2 := (CurrentYear - 100) +(Amonth + 4);
        end;
     3: begin
        if AMonth > 5 then currentmonth := CurrentYear + AMonth-5
           else CurrentMonth :=  (CurrentYear - 100) + (Amonth + 7);
        if AMonth > 11 then month_1 := Currentyear + AMonth - 11
           else month_1 := (CurrentYear - 100) + (Amonth +1);
        if AMonth > 5 then Month_2:= (CurrentYear-100) + AMonth -5
        else month_2 := (CurrentYear - 200) + (Amonth + 7);
        end;
     4: begin
        if AMonth > 8 then currentmonth := CurrentYear + AMonth-8
           else CurrentMonth :=  (CurrentYear - 100) + (Amonth + 4);
        if AMonth > 5 then month_1 := Currentyear - 100 + AMonth - 5
           else month_1 := (CurrentYear - 200) + (Amonth + 7);
        if AMonth > 2 then Month_2:= CurrentYear - 200 + AMonth- 2
        else month_2 := (CurrentYear - 300) + (Amonth + 10);
        end;
     5: begin
             CurrentMonth := CurrentYear - 100+ Amonth;
             month_1 := CurrentYear - 200 + Amonth;
             month_2 := CurrentYear - 300 + AMonth;
        end;

     end;

     // Getting Values From Tx File

     Accsdatamodule.TransactionsDB.Last;

     FOR i:=(Accsdatamodule.TransactionsDB.recordcount) DOWNTO 1 DO
     BEGIN

        Teststring := '';
        Teststring := vartostr(accsdatamodule.transactionsDB['EditStat']);
        IF ((Teststring <> 'E') and (Teststring <> 'R')) THEN BEGIN

           VarDate := accsdatamodule.transactionsDB['TxDate'];

           if VarDate <= ReportDate then begin

           if accsdatamodule.transactionsDB['TxType'] = 9 then begin
              if ((accsdatamodule.transactionsDB['OrigType'] = 1) or (accsdatamodule.transactionsDB['OrigType'] = 3)) then begin
                 account := accsdatamodule.transactionsDB['Account'];       // Account
                 nom_amount:=(accsdatamodule.transactionsDB['Amount'] * 100);     // amount
                 nom_amount:=nom_amount + (accsdatamodule.transactionsDB['TaxDisc'] * 100); // vat

                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthInvoices := LedgerArray[Account].CurrMonthInvoices + nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Invoices := LedgerArray[Account].Month1Invoices + nom_amount
                            else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Invoices := LedgerArray[Account].Month2Invoices + nom_amount;

              end; // [1]
           end; // [9]

           if accsdatamodule.transactionsDB['TxType'] = 2 then begin
                 if ((accsdatamodule.transactionsDB['OrigType'] = 1) or (accsdatamodule.transactionsDB['OrigType'] = 2)) then begin
                    account := accsdatamodule.transactionsDB['Account'];       // Account
                    nom_amount:=(accsdatamodule.transactionsDB['Amount'] * 100);     // amount
                    nom_amount:=nom_amount + (accsdatamodule.transactionsDB['TaxDisc'] * 100); // vat

                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthPayments := LedgerArray[Account].CurrMonthPayments - nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Payments := LedgerArray[Account].Month1Payments - nom_amount
                             else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Payments := LedgerArray[Account].Month2Payments - nom_amount;

                 end; //[ 1 or 2]
           end; // [2]


           end  //  VarDate <= ReportDate
                else begin
                    // get transaction value to remove from balace & turnover

                     if accsdatamodule.transactionsDB['TxType'] = 9 then begin
                       if ((accsdatamodule.transactionsDB['OrigType'] = 1) or (accsdatamodule.transactionsDB['OrigType'] = 3)) then begin

                         account := accsdatamodule.transactionsDB['Account'];       // Account
                         nom_amount:=(accsdatamodule.transactionsDB['Amount'] * 100);     // amount
                         LedgerArray[Account].TurnoverAdjustment := LedgerArray[Account].TurnoverAdjustment + nom_amount;      // Turnover adjustment excludes VAT
                         nom_amount:=nom_amount + (accsdatamodule.transactionsDB['TaxDisc'] * 100); // vat
                         LedgerArray[Account].BalanceAdjustment := LedgerArray[Account].BalanceAdjustment + nom_amount;        // Balance adjustment

                       end; //  1 or 3
                     end; // 9

                     if accsdatamodule.transactionsDB['TxType'] = 2 then begin
                       if ((accsdatamodule.transactionsDB['OrigType'] = 1) or (accsdatamodule.transactionsDB['OrigType'] = 2)) then begin

                         account := accsdatamodule.transactionsDB['Account'];       // Account
                         nom_amount:=(accsdatamodule.transactionsDB['Amount'] * 100);     // amount
                         LedgerArray[Account].TurnoverAdjustment := LedgerArray[Account].TurnoverAdjustment - nom_amount;      // Turnover adjustment excludes VAT
                         nom_amount:=nom_amount + (accsdatamodule.transactionsDB['TaxDisc'] * 100); // vat
                         LedgerArray[Account].BalanceAdjustment := LedgerArray[Account].BalanceAdjustment - nom_amount;        // Balance adjustment

                       end;  // 1 or 2
                     end;  // 2

                end;

        end;  // TestString

     Accsdatamodule.TransactionsDB.Prior;

     end;    // If I:= ....

     DataDir := RFarmGate.pLocation[2];
     if FileExists('c:\kingsacc\' + datadir + '\year-1.db') then begin
     Accsdatamodule.TransactionsYr1DB.Open;
     Accsdatamodule.TransactionsYr1DB.last;

     FOR i:=(Accsdatamodule.TransactionsYr1DB.recordcount) DOWNTO 1 DO
     BEGIN

     Teststring := '';
     Teststring := vartostr(accsdatamodule.transactionsYr1DB['EditStat']);

        IF ((Teststring <> 'E') and (Teststring <> 'R')) THEN BEGIN
           if accsdatamodule.transactionsYr1DB['TxType'] = 9 then begin
              if ((accsdatamodule.transactionsYr1DB['OrigType'] = 1) or (accsdatamodule.transactionsYr1DB['OrigType'] = 3)) then begin
                 account := accsdatamodule.transactionsYr1DB['Account'];       // Account
                 nom_amount:=(accsdatamodule.transactionsYr1DB['Amount'] * 100);     // amount
                 nom_amount:=nom_amount + (accsdatamodule.transactionsYr1DB['TaxDisc'] * 100); // vat
                 VarDate := accsdatamodule.transactionsYr1DB['TxDate'];
                 DecodeDate(VarDate, AYear, AMonth, ADay);
                 IntAYear := AYear *100;
                 if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthInvoices := LedgerArray[Account].CurrMonthInvoices + nom_amount
                    else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Invoices := LedgerArray[Account].Month1Invoices + nom_amount
                         else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Invoices := LedgerArray[Account].Month2Invoices + nom_amount;
              end; // [1]
           end; // [9]
           if accsdatamodule.transactionsYr1DB['TxType'] = 2 then begin
                 if ((accsdatamodule.transactionsDB['OrigType'] = 1) or (accsdatamodule.transactionsDB['OrigType'] = 2)) then begin
                    account := accsdatamodule.transactionsYr1DB['Account'];       // Account
                    nom_amount:=(accsdatamodule.transactionsYr1DB['Amount'] * 100);     // amount
                    nom_amount:=nom_amount + (accsdatamodule.transactionsYr1DB['TaxDisc'] * 100); // vat
                    VarDate := accsdatamodule.transactionsYr1DB['TxDate'];
                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthPayments := LedgerArray[Account].CurrMonthPayments - nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Payments := LedgerArray[Account].Month1Payments - nom_amount
                             else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Payments := LedgerArray[Account].Month2Payments - nom_amount;
                 end; //[1 or 2]
           end; // [2]
        end; // if editstat
     Accsdatamodule.TransactionsYr1DB.Prior;
     end;
     end;

     DecodeDate(ReportDate, AYear, AMonth, ADay);
     DataDir := RFarmGate.pLocation[2];
     if FileExists('c:\kingsacc\' + datadir + '\year-2.db') then begin
        Accsdatamodule.TransactionsYr2DB.Open;
        Accsdatamodule.TransactionsYr2DB.last;


     FOR i:=(Accsdatamodule.TransactionsYr2DB.recordcount) DOWNTO 1 DO
     BEGIN

     Teststring := '';
     Teststring := vartostr(accsdatamodule.transactionsYr2DB['EditStat']);

        IF ((Teststring <> 'E') and (Teststring <> 'R')) THEN BEGIN
           if accsdatamodule.transactionsYr2DB['TxType'] = 9 then begin
              if ((accsdatamodule.transactionsYr2DB['OrigType'] = 1) or (accsdatamodule.transactionsYr2DB['OrigType'] = 3)) then begin
                 account := accsdatamodule.transactionsYr2DB['Account'];       // Account
                 nom_amount:=(accsdatamodule.transactionsYr2DB['Amount'] * 100);     // amount
                 nom_amount:=nom_amount + (accsdatamodule.transactionsYr2DB['TaxDisc'] * 100); // vat
                 VarDate := accsdatamodule.transactionsYr2DB['TxDate'];
                 DecodeDate(VarDate, AYear, AMonth, ADay);
                 IntAYear := AYear *100;
                 if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthInvoices := LedgerArray[Account].CurrMonthInvoices + nom_amount
                    else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Invoices := LedgerArray[Account].Month1Invoices + nom_amount
                         else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Invoices := LedgerArray[Account].Month2Invoices + nom_amount;
              end; // [1]
           end; // [9]
           if accsdatamodule.transactionsYr2DB['TxType'] = 2 then begin
                 if ((accsdatamodule.transactionsDB['OrigType'] = 1) or (accsdatamodule.transactionsDB['OrigType'] = 2)) then begin
                    account := accsdatamodule.transactionsYr2DB['Account'];       // Account
                    nom_amount:=(accsdatamodule.transactionsYr2DB['Amount'] * 100);     // amount
                    nom_amount:=nom_amount + (accsdatamodule.transactionsYr2DB['TaxDisc'] * 100); // vat
                    VarDate := accsdatamodule.transactionsYr2DB['TxDate'];
                        DecodeDate(VarDate, AYear, AMonth, ADay);
                        IntAYear := AYear *100;
                        if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthPayments := LedgerArray[Account].CurrMonthPayments - nom_amount
                           else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Payments := LedgerArray[Account].Month1Payments - nom_amount
                                 else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Payments := LedgerArray[Account].Month2Payments - nom_amount;
                 end; //[ 1 or 2]
           end; // [2]
        end; // if editstat
     Accsdatamodule.TransactionsYr2DB.Prior;
     end;
     end;

        accsdatamodule.SLFileDB.first;
        FOR i:=1 TO accsdatamodule.SLFileDB.RecordCount do
        BEGIN
             IF accsdatamodule.SLFileDB['Active'] = true THEN BEGIN
                Balance := (accsdatamodule.SLFileDB['Balance'] * 100); // balance

                Balance := Balance - LedgerArray[i].BalanceAdjustment;

                accsdatamodule.SLFileDB.Edit;
                accsdatamodule.SLFileDB['Rep_Balance'] := Balance /100;
                accsdatamodule.SLFileDB.post;

                accsdatamodule.SLFileDB.Edit;
                accsdatamodule.SLFileDB['Rep_Turnover'] := accsdatamodule.SLFileDB['Turnover'] - LedgerArray[i].TurnoverAdjustment /100;
                accsdatamodule.SLFileDB.post;

                if balance < 0 then begin
                   currlong := ledgerarray[i].currmonthPayments;
                   if currlong <= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Rep_AgeCurr'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                   currlong := ledgerarray[i].month1Payments;
                   if currlong <= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Rep_Age1'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                   currlong := ledgerarray[i].month2Payments;
                   if currlong <= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Rep_Age2'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                   Templong := Balance;
                   currlong := templong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Rep_Age3'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                end else
                if balance > 0 then begin
                   currlong := ledgerarray[i].currmonthInvoices;
                   if currlong >= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Rep_AgeCurr'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                   currlong := ledgerarray[i].month1Invoices;
                   if currlong >= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Rep_Age1'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                   currlong := ledgerarray[i].month2Invoices;
                   if currlong >= balance then currlong := balance;
                   balance := balance - currlong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Rep_Age2'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                   Templong := Balance;
                   currlong := templong;
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Rep_Age3'] := currlong /100;
                   accsdatamodule.SLFileDB.post;
                end else
                if balance = 0 then begin
                   accsdatamodule.SLFileDB.Edit;
                   accsdatamodule.SLFileDB['Rep_AgeCurr'] := 0;
                   accsdatamodule.SLFileDB['Rep_Age1'] := 0;
                   accsdatamodule.SLFileDB['Rep_Age2'] := 0;
                   accsdatamodule.SLFileDB['Rep_Age3'] := 0;
                   accsdatamodule.SLFileDB.post;
                end;
             end;
             accsdatamodule.SLFileDB.next;
        end;
end;

procedure UpdatePLFiguresAofDReport(ReportDate: TDateTime; AAgedItem : Integer);        // TGM AB Ch001 - New Procedure
var
   i : integer;
   AYear, AMonth, ADay: Word;
   CurrentYear, CurrentMonth, account : integer;

   month_1, month_2 : integer;
   nom_amount, templong : biglong;
   RecNo, Tempint : integer;
   VarDate : TDateTime;
   TempDate : shortstring;
   datadir : string;
   balance, month1total, month2total, month3total, currenttotal : biglong;
   IntAYear : integer;
   Teststring : string;
begin

     // updates PL age of debt
     for i:= 1 to 9999 do begin
         LedgerArray[i].CurrMonthInvoices := 0;
         LedgerArray[i].CurrMonthPayments := 0;
         LedgerArray[i].Month1Invoices := 0;
         LedgerArray[i].Month1Payments := 0;
         LedgerArray[i].Month2Invoices := 0;
         LedgerArray[i].Month2Payments := 0;
         LedgerArray[i].BalanceAdjustment := 0;
         LedgerArray[i].TurnoverAdjustment := 0;

     end;

     // Gather Archive Year Files
     Accsdatamodule.GatherPreviousYears;

     AYear := 0;
     AMonth := 0;
     ADay := 0;
     currentmonth :=0;
     Currentyear := 0;
     month_1 := 0;
     month_2 := 0;


     DecodeDate(ReportDate, AYear, AMonth, ADay);

     CurrentYear := AYear*100;

     case AAgedItem of
     0: begin
        currentmonth := CurrentYear + AMonth;
        If AMonth > 1 then month_1 := CurrentYear + Amonth-1
           else month_1 := (CurrentYear -100) + (AMonth + 11);
        If AMonth >= 3 then month_2 := CurrentYear + Amonth-2       // was >
           else month_2 := (CurrentYear - 100) + (Amonth + 10);
        end;
     1: begin
        If Amonth > 1 then currentmonth := CurrentYear + AMonth-1
           else CurrentMonth := (CurrentYear - 100) +(Amonth + 11);
        If AMonth > 3 then month_1 := CurrentYear + AMonth - 3
           else month_1 := (CurrentYear - 100) +(Amonth + 9);
        If AMonth > 5 then month_2 := CurrentYear + AMonth- 5
           else month_2 := (CurrentYear - 100) + (AMonth + 7);
        end;
     2: begin
        If AMonth > 2 then currentmonth := Currentyear + AMonth-2
           else CurrentMonth :=  (CurrentYear - 100) + (Amonth + 10);
        if AMonth > 5 then month_1 := CurrentYear + AMonth - 5
           else month_1 := (CurrentYear - 100) +(Amonth + 7);
        if AMonth > 8 then month_2 := CurrentYear + AMonth- 8
           else month_2 := (CurrentYear - 100) +(Amonth + 4);
        end;
     3: begin
        if AMonth > 5 then currentmonth := CurrentYear + AMonth-5
           else CurrentMonth :=  (CurrentYear - 100) + (Amonth + 7);
        if AMonth > 11 then month_1 := Currentyear + AMonth - 11
           else month_1 := (CurrentYear - 100) + (Amonth +1);
        if AMonth > 5 then Month_2:= (CurrentYear-100) + AMonth -5
        else month_2 := (CurrentYear - 200) + (Amonth + 7);
        end;
     4: begin
        if AMonth > 8 then currentmonth := CurrentYear + AMonth-8
           else CurrentMonth :=  (CurrentYear - 100) + (Amonth + 4);
        if AMonth > 5 then month_1 := Currentyear - 100 + AMonth - 5
           else month_1 := (CurrentYear - 200) + (Amonth + 7);
        if AMonth > 2 then Month_2:= CurrentYear - 200 + AMonth- 2
        else month_2 := (CurrentYear - 300) + (Amonth + 10);
        end;
     5: begin
             CurrentMonth := CurrentYear - 100+ Amonth;
             month_1 := CurrentYear - 200 + Amonth;
             month_2 := CurrentYear - 300 + AMonth;
        end;

     end;

     // Getting Values From Tx File

     Accsdatamodule.TransactionsDB.Last;

     FOR i:=(Accsdatamodule.TransactionsDB.recordcount) DOWNTO 1 DO
     BEGIN

        Teststring := '';
        Teststring := vartostr(accsdatamodule.transactionsDB['EditStat']);
        IF ((Teststring <> 'E') and (Teststring <> 'R')) THEN BEGIN

           VarDate := accsdatamodule.transactionsDB['TxDate'];

           if VarDate <= ReportDate then begin

           if accsdatamodule.transactionsDB['TxType'] = 9 then begin
              if ((accsdatamodule.transactionsDB['OrigType'] = 5) or (accsdatamodule.transactionsDB['OrigType'] = 7)) then begin
                 account := accsdatamodule.transactionsDB['Account'];       // Account
                 nom_amount:=(accsdatamodule.transactionsDB['Amount'] * 100);     // amount
                 nom_amount:=nom_amount + (accsdatamodule.transactionsDB['TaxDisc'] * 100); // vat

                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthInvoices := LedgerArray[Account].CurrMonthInvoices + nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Invoices := LedgerArray[Account].Month1Invoices + nom_amount
                            else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Invoices := LedgerArray[Account].Month2Invoices + nom_amount;

              end; // [5]
           end; // [9]

           if accsdatamodule.transactionsDB['TxType'] = 6 then begin
                 if ((accsdatamodule.transactionsDB['OrigType'] = 5) or (accsdatamodule.transactionsDB['OrigType'] = 6)) then begin
                    account := accsdatamodule.transactionsDB['Account'];       // Account
                    nom_amount:=(accsdatamodule.transactionsDB['Amount'] * 100);     // amount
                    nom_amount:=nom_amount + (accsdatamodule.transactionsDB['TaxDisc'] * 100); // vat

                        DecodeDate(VarDate, AYear, AMonth, ADay);
                        IntAYear := AYear *100;
                        if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthPayments := LedgerArray[Account].CurrMonthPayments - nom_amount
                           else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Payments := LedgerArray[Account].Month1Payments - nom_amount
                                 else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Payments := LedgerArray[Account].Month2Payments - nom_amount;

                 end; //[ 5 or 6]
           end; // [6]


           end  //  VarDate <= ReportDate
                else begin
                    // get transaction value to remove from balace & turnover

                     if accsdatamodule.transactionsDB['TxType'] = 9 then begin
                       if ((accsdatamodule.transactionsDB['OrigType'] = 5) or (accsdatamodule.transactionsDB['OrigType'] = 7)) then begin

                         account := accsdatamodule.transactionsDB['Account'];       // Account
                         nom_amount:=(accsdatamodule.transactionsDB['Amount'] * 100);     // amount
                         LedgerArray[Account].TurnoverAdjustment := LedgerArray[Account].TurnoverAdjustment + nom_amount;      // Turnover adjustment excludes VAT
                         nom_amount:=nom_amount + (accsdatamodule.transactionsDB['TaxDisc'] * 100); // vat
                         LedgerArray[Account].BalanceAdjustment := LedgerArray[Account].BalanceAdjustment + nom_amount;        // Balance adjustment

                       end; //  5 or 7
                     end; // 9

                     if accsdatamodule.transactionsDB['TxType'] = 6 then begin
                         if ((accsdatamodule.transactionsDB['OrigType'] = 5) or (accsdatamodule.transactionsDB['OrigType'] = 6)) then begin
                         account := accsdatamodule.transactionsDB['Account'];       // Account
                         nom_amount:=(accsdatamodule.transactionsDB['Amount'] * 100);     // amount
                         LedgerArray[Account].TurnoverAdjustment := LedgerArray[Account].TurnoverAdjustment - nom_amount;      // Turnover adjustment excludes VAT
                         nom_amount:=nom_amount + (accsdatamodule.transactionsDB['TaxDisc'] * 100); // vat
                         LedgerArray[Account].BalanceAdjustment := LedgerArray[Account].BalanceAdjustment - nom_amount;        // Balance adjustment

                       end;  // 5 or 6
                     end;  // 6

                end;

        end;  // TestString

     Accsdatamodule.TransactionsDB.Prior;

     end;    // If I:= ....



     DataDir := RFarmGate.pLocation[2];
     if FileExists('c:\kingsacc\' + datadir + '\year-1.db') then begin
     Accsdatamodule.TransactionsYr1DB.Open;
     Accsdatamodule.TransactionsYr1DB.last;


     FOR i:=(Accsdatamodule.TransactionsYr1DB.recordcount) DOWNTO 1 DO
     BEGIN

     Teststring := '';
     Teststring := vartostr(accsdatamodule.transactionsYr1DB['EditStat']);

        IF ((Teststring <> 'E') and (Teststring <> 'R')) THEN BEGIN
           if accsdatamodule.transactionsYr1DB['TxType'] = 9 then begin
              if ((accsdatamodule.transactionsYr1DB['OrigType'] = 5) or (accsdatamodule.transactionsYr1DB['OrigType'] = 7)) then begin
                 account := accsdatamodule.transactionsYr1DB['Account'];       // Account
                 nom_amount:=(accsdatamodule.transactionsYr1DB['Amount'] * 100);     // amount
                 nom_amount:=nom_amount + (accsdatamodule.transactionsYr1DB['TaxDisc'] * 100); // vat
                 VarDate := accsdatamodule.transactionsYr1DB['TxDate'];
                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthInvoices := LedgerArray[Account].CurrMonthInvoices + nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Invoices := LedgerArray[Account].Month1Invoices + nom_amount
                            else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Invoices := LedgerArray[Account].Month2Invoices + nom_amount;
              end; // [5]
           end; // [9]
           if accsdatamodule.transactionsYr1DB['TxType'] = 6 then begin
                 if ((accsdatamodule.transactionsDB['OrigType'] = 5) or (accsdatamodule.transactionsDB['OrigType'] = 6)) then begin
                    account := accsdatamodule.transactionsYr1DB['Account'];       // Account
                    nom_amount:=(accsdatamodule.transactionsYr1DB['Amount'] * 100);     // amount
                    nom_amount:=nom_amount + (accsdatamodule.transactionsYr1DB['TaxDisc'] * 100); // vat
                    VarDate := accsdatamodule.transactionsYr1DB['TxDate'];
                        DecodeDate(VarDate, AYear, AMonth, ADay);
                        IntAYear := AYear *100;
                        if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthPayments := LedgerArray[Account].CurrMonthPayments - nom_amount
                           else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Payments := LedgerArray[Account].Month1Payments - nom_amount
                                 else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Payments := LedgerArray[Account].Month2Payments - nom_amount;
                 end; //[ 5 or 6]
           end; // [6]
        end;
     Accsdatamodule.TransactionsYr1DB.Prior;
     end;
     end;

     DecodeDate(ReportDate, AYear, AMonth, ADay);
     DataDir := RFarmGate.pLocation[2];
     if FileExists('c:\kingsacc\' + datadir + '\year-2.db') then begin
        Accsdatamodule.TransactionsYr2DB.Open;
        Accsdatamodule.TransactionsYr2DB.last;

          FOR i:=(Accsdatamodule.TransactionsYr2DB.recordcount) DOWNTO 1 DO
     BEGIN

     Teststring := '';
     Teststring := vartostr(accsdatamodule.transactionsYr2DB['EditStat']);

        IF ((Teststring <> 'E') and (Teststring <> 'R')) THEN BEGIN
           if accsdatamodule.transactionsYr2DB['TxType'] = 9 then begin
              if ((accsdatamodule.transactionsYr2DB['OrigType'] = 5) or (accsdatamodule.transactionsYr2DB['OrigType'] = 7)) then begin
                 account := accsdatamodule.transactionsYr2DB['Account'];       // Account
                 nom_amount:=(accsdatamodule.transactionsYr2DB['Amount'] * 100);     // amount
                 nom_amount:=nom_amount + (accsdatamodule.transactionsYr2DB['TaxDisc'] * 100); // vat
                 VarDate := accsdatamodule.transactionsYr2DB['TxDate'];
                 DecodeDate(VarDate, AYear, AMonth, ADay);
                 IntAYear := AYear *100;
                 if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthInvoices := LedgerArray[Account].CurrMonthInvoices + nom_amount
                    else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Invoices := LedgerArray[Account].Month1Invoices + nom_amount
                         else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Invoices := LedgerArray[Account].Month2Invoices + nom_amount;
              end; // [5 or 7]
           end; // [9]
           if accsdatamodule.transactionsYr2DB['TxType'] = 6 then begin
                 if ((accsdatamodule.transactionsDB['OrigType'] = 5) or (accsdatamodule.transactionsDB['OrigType'] = 6)) then begin
                    account := accsdatamodule.transactionsYr2DB['Account'];       // Account
                    nom_amount:=(accsdatamodule.transactionsYr2DB['Amount'] * 100);     // amount
                    nom_amount:=nom_amount + (accsdatamodule.transactionsYr2DB['TaxDisc'] * 100); // vat
                    VarDate := accsdatamodule.transactionsYr2DB['TxDate'];
                    DecodeDate(VarDate, AYear, AMonth, ADay);
                    IntAYear := AYear *100;
                    if IntAYear + AMonth >= currentmonth then LedgerArray[Account].CurrMonthPayments := LedgerArray[Account].CurrMonthPayments - nom_amount
                       else if IntAYear + AMonth >= month_1 then LedgerArray[Account].Month1Payments := LedgerArray[Account].Month1Payments - nom_amount
                             else if IntAYear + AMonth >= month_2 then LedgerArray[Account].Month2Payments := LedgerArray[Account].Month2Payments - nom_amount;
                 end; //[ 5 or 6]
           end; // [6]
        end; // if editstat
     Accsdatamodule.TransactionsYr2DB.Prior;
     end;
     end;

     accsdatamodule.PLFileDB.first;
     FOR i:=1 TO accsdatamodule.PLFileDB.RecordCount do
     BEGIN
          IF accsdatamodule.PLFileDB['Active'] = true THEN BEGIN
             Balance := (accsdatamodule.PLFileDB['Balance'] * 100); // balance

             Balance := Balance - LedgerArray[i].BalanceAdjustment;

             accsdatamodule.PLFileDB.Edit;
             accsdatamodule.PLFileDB['Rep_Balance'] := Balance /100;
             accsdatamodule.PLFileDB.post;

             accsdatamodule.PLFileDB.Edit;
             accsdatamodule.PLFileDB['Rep_Turnover'] := accsdatamodule.PLFileDB['Turnover'] - LedgerArray[i].TurnoverAdjustment /100;
             accsdatamodule.PLFileDB.post;

             if balance < 0 then begin
                currlong := ledgerarray[i].currmonthPayments;
                if currlong <= balance then currlong := balance;
                balance := balance - currlong;
                accsdatamodule.PLFileDB.Edit;
                accsdatamodule.PLFileDB['Rep_AgeCurr'] := currlong /100;
                accsdatamodule.PLFileDB.post;
                currlong := ledgerarray[i].month1Payments;
                if currlong <= balance then currlong := balance;
                balance := balance - currlong;
                accsdatamodule.PLFileDB.Edit;
                accsdatamodule.PLFileDB['Rep_Age1'] := currlong /100;
                accsdatamodule.PLFileDB.post;
                currlong := ledgerarray[i].month2Payments;
                if currlong <= balance then currlong := balance;
                balance := balance - currlong;
                accsdatamodule.PLFileDB.Edit;
                accsdatamodule.PLFileDB['Rep_Age2'] := currlong /100;
                accsdatamodule.PLFileDB.post;
                Templong := Balance;
                currlong := templong;
                accsdatamodule.PLFileDB.Edit;
                accsdatamodule.PLFileDB['Rep_Age3'] := currlong /100;
                accsdatamodule.PLFileDB.post;
             end else
             if balance > 0 then begin
                currlong := ledgerarray[i].currmonthInvoices;
                if currlong >= balance then currlong := balance;
                balance := balance - currlong;
                accsdatamodule.PLFileDB.Edit;
                accsdatamodule.PLFileDB['Rep_AgeCurr'] := currlong /100;
                accsdatamodule.PLFileDB.post;
                currlong := ledgerarray[i].month1Invoices;
                if currlong >= balance then currlong := balance;
                balance := balance - currlong;
                accsdatamodule.PLFileDB.Edit;
                accsdatamodule.PLFileDB['Rep_Age1'] := currlong /100;
                accsdatamodule.PLFileDB.post;
                currlong := ledgerarray[i].month2Invoices;
                if currlong >= balance then currlong := balance;
                balance := balance - currlong;
                accsdatamodule.PLFileDB.Edit;
                accsdatamodule.PLFileDB['Rep_Age2'] := currlong /100;
                accsdatamodule.PLFileDB.post;
                Templong := Balance;
                currlong := templong;
                accsdatamodule.PLFileDB.Edit;
                accsdatamodule.PLFileDB['Rep_Age3'] := currlong /100;
                accsdatamodule.PLFileDB.post;
             end else
             if balance = 0 then begin
                accsdatamodule.PLFileDB.Edit;
                accsdatamodule.PLFileDB['Rep_AgeCurr'] := 0;
                accsdatamodule.PLFileDB['Rep_Age1'] := 0;
                accsdatamodule.PLFileDB['Rep_Age2'] := 0;
                accsdatamodule.PLFileDB['Rep_Age3'] := 0;
                accsdatamodule.PLFileDB.post;
             end;
          end;
          accsdatamodule.PLFileDB.next;
     end;
end;

end.
