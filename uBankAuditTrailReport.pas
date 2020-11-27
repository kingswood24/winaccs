{
   03/09/18 [V4.3 R1.2] /MK Incorporated Changes from Andrew (TGM) - BuildListingReport - Bug reported where if contra entry then report was looking
                                                                                          at supplier for Cash Income and customer for Cash Expenditure - Milo Murphy.
}

unit uBankAuditTrailReport;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls;

type
  TBankAuditTrialReport = class(TQuickRep)
    DetailBand1: TQRBand;
    PageFooterBand1: TQRBand;
    PageHeaderBand1: TQRBand;
    BottomLine: TQRShape;
    AccountsName: TQRLabel;
    TopLine1: TQRShape;
    Heading: TQRLabel;
    TopLine2: TQRShape;
    PageNumber: TQRSysData;
    KingswoodLbl: TQRLabel;
    dataset: TQRLabel;
    Range: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    ColumnHeaderBand1: TQRBand;
    QRShape1: TQRShape;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    CustSuppLabel: TQRLabel;
    CommentLabel: TQRLabel;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText13: TQRDBText;
    QRDBText14: TQRDBText;
    QRLabel7: TQRLabel;
    QRDBText15: TQRDBText;
    KingsAccFooter: TQRLabel;
    DateLabel: TQRLabel;
    procedure QRDBText5Print(sender: TObject; var Value: String);
    procedure QRDBText6Print(sender: TObject; var Value: String);
    procedure QRDBText12Print(sender: TObject; var Value: String);
    procedure QRDBText13Print(sender: TObject; var Value: String);
    procedure QRDBText15Print(sender: TObject; var Value: String);
  private

  public
    Procedure RunReport(PreviewReport : Boolean);        //Ch025
    Procedure GatherParams;
    Procedure BuildReport;
    Procedure RunListingReport;
    Procedure BuildListingReport;
  end;

type
   TBankArray = record
      BankAccNo : Integer;
      Report : Boolean;
   end;

var
  BankAuditTrialReport: TBankAuditTrialReport;
  ReportDate, DateFrom, DateTo : TDateTime;
  AccFrom, AccTo : Integer;
  StubType : char;   // P - Presented, U - Unpresented, A - All
  ShowStubDetails, NewPagePerAcc, PrintOnlyIfTransactions, DateRange, AccRange : Boolean;
  BankArray : array [1..100] of TBankArray;                        // TGM AB 02/12/16 was 20
  FirstTxYear : Integer;
  SortBy : char;    // T - TxNo, D - Date                         // TGM AB 02/12/16
  ShowCarriedDEtails : Boolean;  // TGM AB 13/11/17

implementation

{$R *.DFM}

uses
    vars, types, params, accsdata, nomrpt, dialogs, clears, fullaudit;

procedure TBankAuditTrialReport.RunReport(PreviewReport : Boolean);        //Ch025
Var
     RangeCaption : string;
begin
     GatherParams;

     KingswoodLbl.caption := 'Kingswood Accounts ' + VerNo;
     dataset.caption := RFarmGate.PLocation[2];
     DateLabel.caption := NominalReportForm.BankAuditDate.Text;

     RangeCaption := '';
     if AccRange then RangeCaption := RangeCaption + 'Bank Range : ' + IntToStr(AccFrom) + ' To ' + IntToStr(AccTo);
     if DateRange then begin
                If Length(RangeCaption) > 0 then RangeCaption := RangeCaption + ' & ';
                RangeCaption := RangeCaption + 'Date Range : ' + DateToStr(DateFrom) + ' To ' + DateToStr(DateTo);
        end;
      if StubType <> 'A' then begin
                If Length(RangeCaption) > 0 then RangeCaption := RangeCaption + ' : ';
                if StubType = 'P' then RangeCaption := RangeCaption + ' Presented Only';       // TGM AB 02/12/16
                if StubType = 'U' then RangeCaption := RangeCaption + ' Un-presented Only';    // TGM AB 02/12/16
        end;

     // TGM AB 02/12/16

     if SortBy = 'T' then RangeCaption := RangeCaption + ' Sorted by : Tx No'
        else RangeCaption := RangeCaption + ' Sorted by : Date';

     // end TGM AB 02/12/16

     Range.Caption := RangeCaption;
     Heading.Caption := 'Bank Audit Trial';    // TGM AB 19/01/18

     BuildReport;

     if PreviewReport then preview;       //Ch025


end;

procedure TBankAuditTrialReport.GatherParams;
var
    i, arraycount : integer;
begin
    // gather the parameters off the Report Input screen

    ReportDate := 0;
    DateFrom := 0;
    DateTo := 0;
    AccFrom := 0;
    AccTo := 0;
    StubType := 'A';
    ShowStubDetails := False;
    NewPagePerAcc := False;
    PrintOnlyIfTransactions := False;
    DateRange := False;
    AccRange := False;
    CustSuppLabel.Enabled := False;
    CommentLabel.Enabled := False;
    ShowCarriedDetails := False;        // TGM AB 13/11/17

    try ReportDate := strtodate(NominalReportForm.BankAuditDate.text);
    except
    end;
    try DateFrom := strtodate(NominalReportForm.DateFrom.text);
    except
    end;
    try DateTo := strtodate(NominalReportForm.DateTo.text);
    except
    end;
    try AccFrom := strtoint(NominalReportForm.BankAuditAccFrom.text);
    except
    end;
    try AccTo := strtoint(NominalReportForm.BankAuditAccTo.text);
    except
    end;
    StubType := NominalReportForm.WhichStub.text[1];
    ShowStubDetails := NominalReportForm.ShowStubDetails.checked;
    NewPagePerAcc := NominalReportForm.NewPageAcc.checked;
    PrintOnlyIfTransactions := NominalReportForm.PrintZero.checked;

    ShowCarriedDetails := NominalReportForm.PrintCarriedDetails.checked;        // TGM AB 13/11/17

    If ((DateFrom <> 0) and (DateTo <> 0)) then DateRange := True;
    If ((AccFrom <> 0) and (AccTo <> 0)) then AccRange := True;


    // TGM AB 02/12/16

    // Tx Sort

    if NominalReportForm.BATSortRG.ItemIndex = 0 then SortBy := 'T'
        else SortBy := 'D';

    // end TGM AB 02/12/16

    // set-up selected banks

    for i := 1 to 100 do begin              // TGM Ab 02/12/16  was 20
        BankArray[i].BankAccNo := 0;
        BankArray[i].Report := false;
    end;

    if AccRange then begin        // add only the bank accounts selected into the array
             ArrayCount := 1;
             for i:= AccFrom to AccTo do begin
                 BankArray[Arraycount].BankAccNo := i;
                 BankArray[Arraycount].Report := True;
                 inc(Arraycount);
             end;

    end
        else begin
             AccsDatamodule.NlaccsDB.open;
             ArrayCount := 1;
             for i:= Cash1.xBankMin to Cash1.xBankMax do begin     // run through all bank accounts and add in if they are active or not
                 BankArray[Arraycount].BankAccNo := i;
                 AccsDatamodule.NLFileDB.Locate('NLNo',i,[]);
                 if AccsDatamodule.NLFileDB['Active'] = True then BankArray[Arraycount].Report := True;
                 inc(Arraycount);
             end;
        end;

    if ShowStubDetails then begin
        CustSuppLabel.Enabled := True;
        CommentLabel.Enabled := True;
    end;

    FirstTxYear := AuditFiles.FirstTxThisYear;

end;

procedure TBankAuditTrialReport.BuildReport;
var
     i, BankNo, j, k : integer;
     ReportLineCount : Integer;
     TempStr : shortstring;
     AppendToPrevious : boolean;
     StubNumber, LastStubNumber : integer;
     GroupedTx : integer;
     NoTransactions : boolean;
     RunStatementBal, CarriedForwardTotal : real;
     CustSuppNo : integer;
     BankName : String;
     LastTxType : string[1];    // D - Debit  C - Credit
     DateFromString, DateToString : string;   // TGM AB 28/10/16
     OutsideDateRange : Boolean;   // TGM AB 13/11/17
     DateRunStatementBal : real;
     EstimatedLineEntered : Boolean;


begin
      // build table for report

     // check if temp table exists, if so delete before creating

     AccsDatamodule.BankAuditTrailDB.close;

     if ( FileExists(AccsDataModule.AccsDataBase.Directory + '\BankAuditTrailTempTable.db') ) then
        DeleteFile(AccsDataModule.AccsDataBase.Directory + '\BankAuditTrailTempTable.db');

     AccsDatamodule.CreateBankAuditTrialTempTable;

     AccsDatamodule.BankAuditTrailDB.Open;


     BankNo := 0;
     StubNumber := 0;
     LastStubNumber := 0;
     LastTxType := '';
     ReportLineCount := 0;             // line count per page = 52  ??  was 51
     GroupedTx := 0;
     RunStatementBal := 0;
     DateRunStatementBal := 0;      // TGM AB 18/12/17




     DateFromString := copy(datetostr(DateFrom),4,2) + '/' + copy(datetostr(DateFrom),1,2) + '/' + copy(datetostr(DateFrom),7,2);
     DateToString := copy(datetostr(DateTo),4,2) + '/' + copy(datetostr(DateTo),1,2) + '/' + copy(datetostr(DateTo),7,2);


     for i := 1 to 100 do begin               // Run through array and report on the selected Bank Accounts               // TGM AB 02/12/16 was 20
        if BankArray[i].Report = true then begin
           BankNo := BankArray[i].BankAccNo;

           NoTransactions := false;

           EstimatedLineEntered := false;

           // Test For Transactions

           if PrintOnlyIfTransactions then begin

                NoTransactions := True;

                AccsDatamodule.BankAuditTrailQuery.SQL.Clear;
                AccsDatamodule.BankAuditTrailQuery.sql.Add('Select * From Transactions where Nominal =' + vartostr(BankNo));
                AccsDatamodule.BankAuditTrailQuery.open;
                if AccsDatamodule.BankAuditTrailQuery.RecordCount > 0 then NoTransactions := false;
                AccsDatamodule.BankAuditTrailQuery.close;

                AccsDatamodule.BankAuditTrailQuery.SQL.Clear;
                AccsDatamodule.BankAuditTrailQuery.sql.Add('Select * From Transactions where DebitAC =' + vartostr(BankNo));
                AccsDatamodule.BankAuditTrailQuery.open;
                if AccsDatamodule.BankAuditTrailQuery.RecordCount > 0 then NoTransactions := false;
                AccsDatamodule.BankAuditTrailQuery.close;

                AccsDatamodule.BankAuditTrailQuery.SQL.Clear;
                AccsDatamodule.BankAuditTrailQuery.sql.Add('Select * From Transactions where CreditAC =' + vartostr(BankNo));
                AccsDatamodule.BankAuditTrailQuery.open;
                if AccsDatamodule.BankAuditTrailQuery.RecordCount > 0 then NoTransactions := false;
                AccsDatamodule.BankAuditTrailQuery.close;

           end;

     if not NoTransactions then begin      // don't continue with this bank account if No Transactions (only set if user ticks box (PrintOnlyIfTransactions variable))

           if ReportLineCount > 52 then ReportLineCount := ReportLineCount mod 52;

           if ReportLineCount > 46 then begin         // don't start if on last few lines of a page
               While ReportLineCount < 52 do begin
                   AccsDatamodule.BankAuditTrailDB.append;
                   AccsDatamodule.BankAuditTrailDB.post;
                   ReportLineCount := ReportLineCount + 1;
               end;
               ReportLineCount := 0;
           end;

           if ((NewPagePerAcc) and (ReportLineCount <> 0)) then begin      // ensures each account starts on new page (user selection)
               While ReportLineCount < 52 do begin        //44
                   AccsDatamodule.BankAuditTrailDB.append;
                   AccsDatamodule.BankAuditTrailDB.post;
                   ReportLineCount := ReportLineCount + 1;
               end;
               ReportLineCount := 0;
           end;

           if ReportLineCount <> 0 then begin
                AccsDatamodule.BankAuditTrailDB.append;
                AccsDatamodule.BankAuditTrailDB.post;
                AccsDatamodule.BankAuditTrailDB.append;
                AccsDatamodule.BankAuditTrailDB.post;
                ReportLineCount := ReportLineCount + 2;
           end;

           AccsDatamodule.BankAuditTrailDB.append;
           AccsDatamodule.NLFileDB.Locate('NLNo',BankNo,[]);
           BankName := '';
           BankName := vartostr(BankNo);
           BankName := BankName + ' - ';
           try BankName := BankName + AccsDatamodule.NLFileDB['Name'];
           except
           end;

           AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Bank Account :  ' + BankName; //vartostr(BankNo) + '  -  ' + AccsDatamodule.NLFileDB['Name'];
           AccsDatamodule.BankAuditTrailDB.post;
           ReportLineCount := ReportLineCount + 1;
           AccsDatamodule.BankAuditTrailDB.append;
           AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Opening Nominal Balance :   ';
           AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := strtofloat(vartostr(AccsDatamodule.NLFileDB['BalanceSt']));
           RunStatementBal := strtofloat(vartostr(AccsDatamodule.NLFileDB['BalanceSt']));
           AccsDatamodule.BankAuditTrailDB.post;
           ReportLineCount := ReportLineCount + 1;

           // TGM AB 06/11/17 - New section to list all carried forward transactions not yet presented

           try AccsDatamodule.BankAuditTrailQuery.close;
           except
           end;

           AccsDatamodule.BankAuditTrailQuery.sql.clear;

           AccsDatamodule.BankAuditTrailQuery.sql.Add('Select * From Transactions where ((debitac =' + vartostr(BankNo) + ') or (creditac =' + vartostr(BankNo) + ')) and TxNo < ' + vartostr(FirstTxYear));
           AccsDatamodule.BankAuditTrailQuery.open;
           AccsDatamodule.BankAuditTrailQuery.first;

           CarriedForwardTotal := 0;

           if AccsDatamodule.BankAuditTrailQuery.RecordCount > 0 then begin



               if ShowCarriedDetails then begin

                                AccsDatamodule.BankAuditTrailDB.append;
                                AccsDatamodule.BankAuditTrailDB.post;
                                ReportLineCount := ReportLineCount + 1;

                                AccsDatamodule.BankAuditTrailDB.edit;
                                AccsDatamodule.BankAuditTrailDB.append;
                                AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Carried forward transaction breakdown - ';
                                AccsDatamodule.BankAuditTrailDB.post;
                                ReportLineCount := ReportLineCount + 1;

                                AccsDatamodule.BankAuditTrailDB.append;
                                AccsDatamodule.BankAuditTrailDB.post;
                                ReportLineCount := ReportLineCount + 1;

               end;

               for K := 1 to AccsDatamodule.BankAuditTrailQuery.RecordCount do begin

                    AccsDatamodule.BankAuditTrailDB.append;
                    AccsDatamodule.BankAuditTrailDB['StubNumber'] := AccsDatamodule.BankAuditTrailQuery['StubNo'];
                    AccsDatamodule.BankAuditTrailDB['StubDate'] := AccsDatamodule.BankAuditTrailQuery['TxDate'];
                    AccsDatamodule.BankAuditTrailDB['TxNo'] := AccsDatamodule.BankAuditTrailQuery['TxNo'];

                    if AccsDatamodule.BankAuditTrailQuery['DebitAC'] = BankNo  then begin
                                                                                       AccsDatamodule.BankAuditTrailDB['Receipt'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];
                                                                                       CarriedForwardTotal := CarriedForwardTotal - AccsDatamodule.BankAuditTrailDB['Receipt'];
                                                                                       RunStatementBal := RunStatementBal - AccsDatamodule.BankAuditTrailDB['Receipt'];
                    end;
                    if AccsDatamodule.BankAuditTrailQuery['CreditAC'] = BankNo then begin
                                                                                       AccsDatamodule.BankAuditTrailDB['Payment'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];
                                                                                       CarriedForwardTotal := CarriedForwardTotal + AccsDatamodule.BankAuditTrailDB['Payment'];
                                                                                       RunStatementBal := RunStatementBal + AccsDatamodule.BankAuditTrailDB['Payment'];
                    end;

                    AccsDatamodule.BankAuditTrailDB['Status'] := 'Carried Forward';
              //      AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := RunStatementBal;
                    if not ShowCarriedDetails then AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] := true;
                    AccsDatamodule.BankAuditTrailDB.post;
                    if AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] <> true then ReportLineCount := ReportLineCount + 1;

                    AccsDatamodule.BankAuditTrailQuery.next;

               end;

               if ShowCarriedDetails then begin

                        AccsDatamodule.BankAuditTrailDB.append;
                        AccsDatamodule.BankAuditTrailDB.post;
                        ReportLineCount := ReportLineCount + 1;

               end;


               AccsDatamodule.BankAuditTrailDB.append;
               AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Opening Bank Statement Balance';
               AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := strtofloat(vartostr(AccsDatamodule.NLFileDB['BalanceSt'])) + CarriedForwardTotal;
               AccsDatamodule.BankAuditTrailDB.post;
               ReportLineCount := ReportLineCount + 1;


               AccsDatamodule.BankAuditTrailDB.append;
               AccsDatamodule.BankAuditTrailDB.post;
               ReportLineCount := ReportLineCount + 1;

           end      // if recordcount > 0
                else begin

                        AccsDatamodule.BankAuditTrailDB.append;
                        AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Opening Bank Statement Balance';
                        AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := strtofloat(vartostr(AccsDatamodule.NLFileDB['BalanceSt']));
                        AccsDatamodule.BankAuditTrailDB.post;
                        ReportLineCount := ReportLineCount + 1;

                        AccsDatamodule.BankAuditTrailDB.append;
                        AccsDatamodule.BankAuditTrailDB.post;
                        ReportLineCount := ReportLineCount + 1;


                end;

            AccsDatamodule.BankAuditTrailQuery.close;
            AccsDatamodule.BankAuditTrailQuery.sql.clear;

           // end of new section TGM AB 06/11/17




           if ((StubType = 'A') or (StubType = 'P')) then begin    // Find all Presented Transactions

                AccsDatamodule.BankAuditTrailQuery.SQL.Clear;
                AccsDatamodule.BankAuditTrailQuery.sql.Add('Select * From Transactions where ((debitac =' + vartostr(BankNo) + ') or (creditac =' + vartostr(BankNo) + ')) and BankRec = ''P''');

                if SortBy = 'D' then AccsDatamodule.BankAuditTrailQuery.sql.Add('Order By TxDate')
                        else  AccsDatamodule.BankAuditTrailQuery.sql.Add('Order By TxNo');


                AccsDatamodule.BankAuditTrailQuery.open;
                AccsDatamodule.BankAuditTrailQuery.first;

                AppendToPrevious := False;

                For j := 1 to AccsDatamodule.BankAuditTrailQuery.RecordCount do begin

                 if ((AccsDatamodule.BankAuditTrailQuery['NomAmount'] <> 0) and (AccsDatamodule.BankAuditTrailQuery['TxNo'] >= 0)) then begin

                    try StubNumber := strtoint(AccsDatamodule.BankAuditTrailQuery['StubNo']);
                    except StubNumber := 0;
                    end;

                    If StubNumber <> 0 then begin
                        If StubNumber = LastStubNumber then begin
                                                                  if (((LastTxType = 'D') and (AccsDatamodule.BankAuditTrailQuery['DebitAC'] = BankNo)) or ((LastTxType = 'C') and (AccsDatamodule.BankAuditTrailQuery['CreditAC'] = BankNo))) then begin
                                                                       AppendToPrevious := True;
                                                                       AccsDatamodule.BankAuditTrailDB.Locate('ID',GroupedTX,[]);
                                                                  end;
                           end
                               else AccsDatamodule.BankAuditTrailDB.Last;
                    end
                        else AppendToPrevious := false;

                    if AccsDatamodule.BankAuditTrailQuery['DebitAC'] = BankNo then LastTxType := 'D'
                        else LastTxType := 'C';
                    LastStubNumber := StubNumber;
                    CustSuppNo := 0;

                    if AppendToPrevious then AccsDatamodule.BankAuditTrailDB.edit
                        else AccsDatamodule.BankAuditTrailDB.append;


                    AccsDatamodule.BankAuditTrailDB['StubNumber'] := AccsDatamodule.BankAuditTrailQuery['StubNo'];
                    AccsDatamodule.BankAuditTrailDB['StubDate'] := AccsDatamodule.BankAuditTrailQuery['TxDate'];
                    if not AppendToPrevious then AccsDatamodule.BankAuditTrailDB['TxNo'] := AccsDatamodule.BankAuditTrailQuery['TxNo'];
                    if AccsDatamodule.BankAuditTrailQuery['DebitAC'] = BankNo then begin
                                                                                        if AppendToPrevious then AccsDatamodule.BankAuditTrailDB['Receipt'] := AccsDatamodule.BankAuditTrailDB['Receipt'] + AccsDatamodule.BankAuditTrailQuery['NomAmount']       // TGM AB 02/06/17
                                                                                            else AccsDatamodule.BankAuditTrailDB['Receipt'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];  // TGM AB 02/06/17
                                                                                        RunStatementBal := RunStatementBal + AccsDatamodule.BankAuditTrailQuery['NomAmount'];
                                                                                   end;
                    if AccsDatamodule.BankAuditTrailQuery['CreditAC'] = BankNo then begin
                                                                                        if AppendToPrevious then  AccsDatamodule.BankAuditTrailDB['Payment'] := AccsDatamodule.BankAuditTrailDB['Payment'] + AccsDatamodule.BankAuditTrailQuery['NomAmount']       // TGM AB 02/06/17
                                                                                            else AccsDatamodule.BankAuditTrailDB['Payment'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];     // TGM AB 02/06/17
                                                                                        RunStatementBal := RunStatementBal - AccsDatamodule.BankAuditTrailQuery['NomAmount'];
                                                                                   end;
                    AccsDatamodule.BankAuditTrailDB['Status'] := 'Presented';
                    if not DateRange then AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := RunStatementBal;

                    // Check if falls within date filter

                    OutsideDateRange := False;

                    if DateRange then begin
                        if ((AccsDatamodule.BankAuditTrailQuery['TxDate'] < DateFrom) or (AccsDatamodule.BankAuditTrailQuery['TxDate'] > DateTo)) then begin
                                AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] := True;
                                OutsideDateRange := True;
                        end;
                    end;

                    if AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] <> true then begin
                        DateRunStatementBal := RunStatementBal;
                    end;


                    if AppendToPrevious then begin
                                                   AccsDatamodule.BankAuditTrailDB['MultiTx'] := '+';
                                             end;

                    if not AppendToPrevious then begin
                        if ReportLineCount = 51 then ReportLineCount := 0        // 51 as inside the loop
                            else ReportLineCount := ReportLineCount + 1;
                    end;

                    if ((AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] = true) and (not AppendToPrevious)) then begin
                        if ReportLineCount = 0 then ReportLineCount := 51
                                else ReportLineCount := ReportLineCount - 1;
                    end;

                    AccsDatamodule.BankAuditTrailDB.post;
                    GroupedTx := AccsDatamodule.BankAuditTrailDB['ID'];

        {
                    if (not OutsideDateRange) then begin
                         if EstimatedLineEntered = false then begin
                                EstimatedLineEntered := true;
                                AccsDatamodule.BankAuditTrailDB.insert;
                                AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Estimated Period Opening Bank Statement Balance';
                                AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := RunStatementBal;
                                AccsDatamodule.BankAuditTrailDB.post;
                                AccsDatamodule.BankAuditTrailDB.next;
                                ReportLineCount := ReportLineCount + 1;
                                AccsDatamodule.BankAuditTrailDB.insert;
                                AccsDatamodule.BankAuditTrailDB.post;
                                ReportLineCount := ReportLineCount + 1;
                                AccsDatamodule.BankAuditTrailDB.last;
                         end;
                    end;
          }


                    if (ShowStubDetails and (not OutsideDateRange)) then begin
                        CustSuppNo := AccsDatamodule.BankAuditTrailQuery['Account'];
                        AccsDatamodule.BankAuditTrailDB.append;
                        AccsDatamodule.BankAuditTrailDB['MultiTxNo'] := AccsDatamodule.BankAuditTrailQuery['TxNo'];
                        AccsDatamodule.BankAuditTrailDB['LineDate'] := AccsDatamodule.BankAuditTrailQuery['TxDate'];
                        AccsDatamodule.BankAuditTrailDB['CommentDesc'] := AccsDatamodule.BankAuditTrailQuery['Descript'];

                        if AccsDatamodule.BankAuditTrailQuery['DebitAC'] = BankNo then begin
                                                                                        AccsDatamodule.BankAuditTrailDB['LineReceipt'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];           // TGM AB 02/06/17
                                                                                        if (AccsDatamodule.BankAuditTrailQuery['TxType'] = 2) then begin                                     // Ch007
                                                                                            AccsDatamodule.SLFileDB.locate('SLNo',AccsDatamodule.BankAuditTrailQuery['Account'],[]);         // Ch007
                                                                                            AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.SLFileDB['Name'];                  // Ch007
                                                                                        end else                                                                                             // Ch007
                                                                                        if (AccsDatamodule.BankAuditTrailQuery['TxType'] = 6) then begin                                     // Ch007
                                                                                            AccsDatamodule.PLFileDB.locate('PLNo',AccsDatamodule.BankAuditTrailQuery['Account'],[]);         // Ch007
                                                                                            AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.PLFileDB['Name'];                  // Ch007
                                                                                        end else begin
                                                                                               AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.BankAuditTrailQuery['Reference'];
                                                                                            end;
                                                                                   end;
                        if AccsDatamodule.BankAuditTrailQuery['CreditAC'] = BankNo then begin
                                                                                        AccsDatamodule.BankAuditTrailDB['LinePayment'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];          // TGM AB 02/06/17
                                                                                        if (AccsDatamodule.BankAuditTrailQuery['TxType'] = 2) then begin                                     // Ch007
                                                                                            AccsDatamodule.SLFileDB.locate('SLNo',AccsDatamodule.BankAuditTrailQuery['Account'],[]);         // Ch007
                                                                                            AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.SLFileDB['Name'];                  // Ch007
                                                                                        end else                                                                                             // Ch007
                                                                                        if (AccsDatamodule.BankAuditTrailQuery['TxType'] = 6) then begin                                     // Ch007
                                                                                            AccsDatamodule.PLFileDB.locate('PLNo',AccsDatamodule.BankAuditTrailQuery['Account'],[]);         // Ch007
                                                                                            AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.PLFileDB['Name'];                  // Ch007
                                                                                        end else begin
                                                                                               AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.BankAuditTrailQuery['Reference'];
                                                                                            end;
                                                                                   end;

                        AccsDatamodule.BankAuditTrailDB.post;
                        ReportLineCount := ReportLineCount + 1;
                    end;
                 end;

                    AccsDatamodule.BankAuditTrailQuery.next;
                    AppendToPrevious := False;



                end;

                AccsDatamodule.BankAuditTrailQuery.close;

                AccsDatamodule.BankAuditTrailDB.append;
                AccsDatamodule.BankAuditTrailDB.post;
                ReportLineCount := ReportLineCount + 1;

                AccsDatamodule.BankAuditTrailDB.append;

                if not DateRange then begin
                                AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := RunStatementBal;              
                                AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Bank Statement Balance';
                       end;
                AccsDatamodule.BankAuditTrailDB.post;
                ReportLineCount := ReportLineCount + 1;


           end;  // Presented

           LastStubNumber := 0; // clears the last held stubnumber

           if (StubType = 'A') then begin      // add spacing if both presented and unpresented as displayed

                   if ReportLineCount > 52 then ReportLineCount := ReportLineCount mod 52;
                   if ReportLineCount > 46 then begin
                      While ReportLineCount <> 52 do begin
                      AccsDatamodule.BankAuditTrailDB.append;
                      AccsDatamodule.BankAuditTrailDB.post;
                      ReportLineCount := ReportLineCount + 1;
                      end;
                      ReportLineCount := 0;
                   end
                       else begin
                                   AccsDatamodule.BankAuditTrailDB.append;
                                   AccsDatamodule.BankAuditTrailDB.post;
                                   ReportLineCount := ReportLineCount + 1;
                                   AccsDatamodule.BankAuditTrailDB.append;
                                   AccsDatamodule.BankAuditTrailDB.post;
                                   ReportLineCount := ReportLineCount + 1;
                            end;
           end;

           if ((StubType = 'A') or (StubType = 'U')) then begin

                AccsDatamodule.BankAuditTrailQuery.SQL.Clear;
                AccsDatamodule.BankAuditTrailQuery.sql.Add('Select * From Transactions where ((debitac =' + vartostr(BankNo) + ') or (creditac =' + vartostr(BankNo) + ')) and BankRec = ''U''');

                if SortBy = 'D' then AccsDatamodule.BankAuditTrailQuery.sql.Add('Order By TxDate')
                        else  AccsDatamodule.BankAuditTrailQuery.sql.Add('Order By TxNo');

                AccsDatamodule.BankAuditTrailQuery.open;
                AccsDatamodule.BankAuditTrailQuery.first;

                AppendToPrevious := False;

                For j := 1 to AccsDatamodule.BankAuditTrailQuery.RecordCount do begin

                  if ((AccsDatamodule.BankAuditTrailQuery['NomAmount'] <> 0) and (AccsDatamodule.BankAuditTrailQuery['TxNo'] >= {FirstTxYear}0)) then begin


                    try StubNumber := strtoint(AccsDatamodule.BankAuditTrailQuery['StubNo']);
                    except StubNumber := 0;
                    end;

                    If StubNumber <> 0 then begin
                        If StubNumber = LastStubNumber then begin
                                                                  if (((LastTxType = 'D') and (AccsDatamodule.BankAuditTrailQuery['DebitAC'] = BankNo)) or ((LastTxType = 'C') and (AccsDatamodule.BankAuditTrailQuery['CreditAC'] = BankNo))) then begin
                                                                       AppendToPrevious := True;
                                                                       AccsDatamodule.BankAuditTrailDB.Locate('ID',GroupedTX,[]);
                                                                  end;
                           end
                               else AccsDatamodule.BankAuditTrailDB.Last;
                    end
                        else AppendToPrevious := false;

                    if AccsDatamodule.BankAuditTrailQuery['DebitAC'] = BankNo then LastTxType := 'D'
                        else LastTxType := 'C';

                    LastStubNumber := StubNumber;
                    CustSuppNo := 0;

                    if AppendToPrevious then AccsDatamodule.BankAuditTrailDB.edit
                        else AccsDatamodule.BankAuditTrailDB.append;


                    AccsDatamodule.BankAuditTrailDB['StubNumber'] := AccsDatamodule.BankAuditTrailQuery['StubNo'];
                    AccsDatamodule.BankAuditTrailDB['StubDate'] := AccsDatamodule.BankAuditTrailQuery['TxDate'];
                    if not AppendToPrevious then AccsDatamodule.BankAuditTrailDB['TxNo'] := AccsDatamodule.BankAuditTrailQuery['TxNo'];
                    if AccsDatamodule.BankAuditTrailQuery['DebitAC'] = BankNo then begin
                                                                                        if AppendToPrevious then AccsDatamodule.BankAuditTrailDB['Receipt'] := AccsDatamodule.BankAuditTrailDB['Receipt'] + AccsDatamodule.BankAuditTrailQuery['NomAmount']  // TGM AB 02/06/17
                                                                                            else AccsDatamodule.BankAuditTrailDB['Receipt'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];    // TGM AB 02/06/17
                                                                                        RunStatementBal := RunStatementBal + AccsDatamodule.BankAuditTrailQuery['NomAmount'];
                                                                                   end;
                    if AccsDatamodule.BankAuditTrailQuery['CreditAC'] = BankNo then begin
                                                                                        if AppendToPrevious then  AccsDatamodule.BankAuditTrailDB['Payment'] := AccsDatamodule.BankAuditTrailDB['Payment'] + AccsDatamodule.BankAuditTrailQuery['NomAmount']   // TGM AB 02/06/17
                                                                                            else AccsDatamodule.BankAuditTrailDB['Payment'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];  // TGM AB 02/06/17
                                                                                        RunStatementBal := RunStatementBal - AccsDatamodule.BankAuditTrailQuery['NomAmount'];
                                                                                   end;
                    AccsDatamodule.BankAuditTrailDB['Status'] := 'Unpresented';
                    if ((not DateRange) and (not (StubType = 'U'))) then AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := RunStatementBal;      // balance for unpresented means nothing when date filtered

                    // Check if falls within date filter

                    OutsideDateRange := False;

                    if DateRange then begin
                        if ((AccsDatamodule.BankAuditTrailQuery['TxDate'] < DateFrom) or (AccsDatamodule.BankAuditTrailQuery['TxDate'] > DateTo)) then begin
                                AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] := True;
                                OutsideDateRange := True;
                        end;
                    end;
          {
                    if ((DateRange) and (AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] <> true)) then begin    // TGM AB 21/12/17
                          try      DateRunStatementBal := DateRunStatementBal - AccsDatamodule.BankAuditTrailDB['Payment'];
                          except
                          end;
                          try      DateRunStatementBal := DateRunStatementBal + AccsDatamodule.BankAuditTrailDB['Receipt'];
                          except
                          end;

                          AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := DateRunStatementBal;

                    end;
           }
                    if AppendToPrevious then begin
                                                   AccsDatamodule.BankAuditTrailDB['MultiTx'] := '+';
                                             end;

                    if not AppendToPrevious then begin
                        if ReportLineCount = 51 then ReportLineCount := 0        // 51 as inside the loop
                            else ReportLineCount := ReportLineCount + 1;
                    end;

                    if ((AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] = true) and (not AppendToPrevious)) then begin
                        if ReportLineCount = 0 then ReportLineCount := 51
                                else ReportLineCount := ReportLineCount - 1;
                    end;

                    AccsDatamodule.BankAuditTrailDB.post;
                    GroupedTx := AccsDatamodule.BankAuditTrailDB['ID'];

                    if (ShowStubDetails and (not OutsideDateRange)) then begin
                        CustSuppNo := AccsDatamodule.BankAuditTrailQuery['Account'];
                        AccsDatamodule.BankAuditTrailDB.append;
                        AccsDatamodule.BankAuditTrailDB['MultiTxNo'] := AccsDatamodule.BankAuditTrailQuery['TxNo'];
                        AccsDatamodule.BankAuditTrailDB['LineDate'] := AccsDatamodule.BankAuditTrailQuery['TxDate'];
                        AccsDatamodule.BankAuditTrailDB['CommentDesc'] := AccsDatamodule.BankAuditTrailQuery['Descript'];

                        if AccsDatamodule.BankAuditTrailQuery['DebitAC'] = BankNo then begin
                                                                                        AccsDatamodule.BankAuditTrailDB['LineReceipt'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];     // TGM AB 02/06/17
                                                                                        if (AccsDatamodule.BankAuditTrailQuery['TxType'] = 2) then begin                                       // Ch007
                                                                                            AccsDatamodule.SLFileDB.locate('SLNo',AccsDatamodule.BankAuditTrailQuery['Account'],[]);           // Ch007
                                                                                            AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.SLFileDB['Name'];                    // Ch007
                                                                                        end else                                                                                               // Ch007
                                                                                        if (AccsDatamodule.BankAuditTrailQuery['TxType'] = 6) then begin                                       // Ch007
                                                                                            AccsDatamodule.PLFileDB.locate('PLNo',AccsDatamodule.BankAuditTrailQuery['Account'],[]);           // Ch007
                                                                                            AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.PLFileDB['Name'];                    // Ch007
                                                                                        end else begin
                                                                                               AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.BankAuditTrailQuery['Reference'];
                                                                                            end;
                                                                                   end;
                        if AccsDatamodule.BankAuditTrailQuery['CreditAC'] = BankNo then begin
                                                                                        AccsDatamodule.BankAuditTrailDB['LinePayment'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];   // TGM AB 02/06/17
                                                                                        if (AccsDatamodule.BankAuditTrailQuery['TxType'] = 2) then begin                                     // Ch007
                                                                                            AccsDatamodule.SLFileDB.locate('SLNo',AccsDatamodule.BankAuditTrailQuery['Account'],[]);         // Ch007
                                                                                            AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.SLFileDB['Name'];                  // Ch007
                                                                                        end else                                                                                             // Ch007
                                                                                        if (AccsDatamodule.BankAuditTrailQuery['TxType'] = 6) then begin                                     // Ch007
                                                                                            AccsDatamodule.PLFileDB.locate('PLNo',AccsDatamodule.BankAuditTrailQuery['Account'],[]);         // Ch007
                                                                                            AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.PLFileDB['Name'];                  // Ch007
                                                                                        end else begin
                                                                                               AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.BankAuditTrailQuery['Reference'];
                                                                                            end;
                                                                                   end;

                        AccsDatamodule.BankAuditTrailDB.post;
                        ReportLineCount := ReportLineCount + 1;
                    end;
                 end;  // TGM AB 09/01/15

              //      end;
                    AccsDatamodule.BankAuditTrailQuery.next;
                    AppendToPrevious := False;



                end;



           end; // Unpresented

           AccsDatamodule.BankAuditTrailQuery.close;

           if ((not DateRange) and (StubType = 'A')) then begin

                        AccsDatamodule.BankAuditTrailDB.append;
                        AccsDatamodule.BankAuditTrailDB.post;
                        ReportLineCount := ReportLineCount + 1;

                        AccsDatamodule.BankAuditTrailDB.append;
                        AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Nominal Balance';
                        AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := RunStatementBal;
                        AccsDatamodule.BankAuditTrailDB.post;
                        ReportLineCount := ReportLineCount + 1;

           end;                                                    

        end; // If report = true

        AccsDatamodule.BankAuditTrailQuery.close;

     end; // NoTransactions

     end;

     // This query deletes the unwanted lines when filtering etc

     AccsDatamodule.BankAuditTrailQuery.sql.clear;
     AccsDatamodule.BankAuditTrailQuery.sql.Add('Delete from BankAuditTrailTempTable where ToBeDeleted = True');
     AccsDatamodule.BankAuditTrailQuery.ExecSQL;
     AccsDatamodule.BankAuditTrailQuery.close;


end;



procedure TBankAuditTrialReport.QRDBText5Print(sender: TObject;
  var Value: String);
begin
 if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.BankAuditTrailDB['Receipt'], ffNumber , 8, 2);
end;

procedure TBankAuditTrialReport.QRDBText6Print(sender: TObject;
  var Value: String);
begin
 if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.BankAuditTrailDB['Payment'], ffNumber , 8, 2);
end;

procedure TBankAuditTrialReport.QRDBText12Print(sender: TObject;
  var Value: String);
begin
 if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.BankAuditTrailDB['LineReceipt'], ffNumber , 8, 2);
end;

procedure TBankAuditTrialReport.QRDBText13Print(sender: TObject;
  var Value: String);
begin
 if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.BankAuditTrailDB['LinePayment'], ffNumber , 8, 2);
end;

procedure TBankAuditTrialReport.QRDBText15Print(sender: TObject;
  var Value: String);
begin
 if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.BankAuditTrailDB['RunStatementBal'], ffNumber , 8, 2);
end;



procedure TBankAuditTrialReport.RunListingReport;        // TGM AB 19/01/18
Var
     RangeCaption : string;
begin
     GatherParams;

     KingswoodLbl.caption := 'Kingswood Accounts ' + VerNo;
     dataset.caption := RFarmGate.PLocation[2];
     DateLabel.caption := '';

     RangeCaption := '';
     if AccRange then RangeCaption := RangeCaption + 'Bank Range : ' + IntToStr(AccFrom) + ' To ' + IntToStr(AccTo);
     if DateRange then begin
                If Length(RangeCaption) > 0 then RangeCaption := RangeCaption + ' & ';
                RangeCaption := RangeCaption + 'Date Range : ' + DateToStr(DateFrom) + ' To ' + DateToStr(DateTo);
        end;

     if SortBy = 'T' then RangeCaption := RangeCaption + ' Sorted by : Tx No'
        else RangeCaption := RangeCaption + ' Sorted by : Date';

     Range.Caption := RangeCaption;
     Heading.Caption := 'Bank Transaction Listing';

     BuildListingReport;

     preview;

end;

procedure TBankAuditTrialReport.BuildListingReport;         // TGM AB 19/01/18
var
     i, BankNo, j, k : integer;
     ReportLineCount : Integer;
     TempStr : shortstring;
     AppendToPrevious : boolean;
     StubNumber, LastStubNumber : integer;
     GroupedTx : integer;
     NoTransactions : boolean;
     RunStatementBal, CarriedForwardTotal : real;
     CustSuppNo : integer;
     BankName : String;
     LastTxType : string[1];    // D - Debit  C - Credit
     DateFromString, DateToString : string;
     OutsideDateRange : Boolean;
     DateRunStatementBal, DateOpeningStatementBal : real;
     OpeningLineEntered : Boolean;
     PreviousRunStatementBal : Real;


begin

      // build table for report

     // check if temp table exists, if so delete before creating

     AccsDatamodule.BankAuditTrailDB.close;

     if ( FileExists(AccsDataModule.AccsDataBase.Directory + '\BankAuditTrailTempTable.db') ) then
        DeleteFile(AccsDataModule.AccsDataBase.Directory + '\BankAuditTrailTempTable.db');

     AccsDatamodule.CreateBankAuditTrialTempTable;

     AccsDatamodule.BankAuditTrailDB.Open;


     BankNo := 0;
     StubNumber := 0;
     LastStubNumber := 0;
     LastTxType := '';
     ReportLineCount := 0;             // line count per page = 52  ??  was 51
     GroupedTx := 0;
     RunStatementBal := 0;
     DateRunStatementBal := 0;
     PreviousRunStatementBal := 0;
     DateOpeningStatementBal := 0;




     DateFromString := copy(datetostr(DateFrom),4,2) + '/' + copy(datetostr(DateFrom),1,2) + '/' + copy(datetostr(DateFrom),7,2);
     DateToString := copy(datetostr(DateTo),4,2) + '/' + copy(datetostr(DateTo),1,2) + '/' + copy(datetostr(DateTo),7,2);


     for i := 1 to 100 do begin               // Run through array and report on the selected Bank Accounts
        if BankArray[i].Report = true then begin
           BankNo := BankArray[i].BankAccNo;

           NoTransactions := false;
           OpeningLineEntered := False;

           // Test For Transactions

           if PrintOnlyIfTransactions then begin

                NoTransactions := True;

                AccsDatamodule.BankAuditTrailQuery.SQL.Clear;
                AccsDatamodule.BankAuditTrailQuery.sql.Add('Select * From Transactions where Nominal =' + vartostr(BankNo));
                AccsDatamodule.BankAuditTrailQuery.open;
                if AccsDatamodule.BankAuditTrailQuery.RecordCount > 0 then NoTransactions := false;
                AccsDatamodule.BankAuditTrailQuery.close;

                AccsDatamodule.BankAuditTrailQuery.SQL.Clear;
                AccsDatamodule.BankAuditTrailQuery.sql.Add('Select * From Transactions where DebitAC =' + vartostr(BankNo));
                AccsDatamodule.BankAuditTrailQuery.open;
                if AccsDatamodule.BankAuditTrailQuery.RecordCount > 0 then NoTransactions := false;
                AccsDatamodule.BankAuditTrailQuery.close;

                AccsDatamodule.BankAuditTrailQuery.SQL.Clear;
                AccsDatamodule.BankAuditTrailQuery.sql.Add('Select * From Transactions where CreditAC =' + vartostr(BankNo));
                AccsDatamodule.BankAuditTrailQuery.open;
                if AccsDatamodule.BankAuditTrailQuery.RecordCount > 0 then NoTransactions := false;
                AccsDatamodule.BankAuditTrailQuery.close;

           end;

     if not NoTransactions then begin      // don't continue with this bank account if No Transactions (only set if user ticks box (PrintOnlyIfTransactions variable))

           if ReportLineCount > 52 then ReportLineCount := ReportLineCount mod 52;

           if ReportLineCount > 46 then begin         // don't start if on last few lines of a page
               While ReportLineCount < 52 do begin
                   AccsDatamodule.BankAuditTrailDB.append;
                   AccsDatamodule.BankAuditTrailDB.post;
                   ReportLineCount := ReportLineCount + 1;
               end;
               ReportLineCount := 0;
           end;

           if ((NewPagePerAcc) and (ReportLineCount <> 0)) then begin      // ensures each account starts on new page (user selection)
               While ReportLineCount < 52 do begin        //44
                   AccsDatamodule.BankAuditTrailDB.append;
                   AccsDatamodule.BankAuditTrailDB.post;
                   ReportLineCount := ReportLineCount + 1;
               end;
               ReportLineCount := 0;
           end;

           if ReportLineCount <> 0 then begin
                AccsDatamodule.BankAuditTrailDB.append;
                AccsDatamodule.BankAuditTrailDB.post;
                AccsDatamodule.BankAuditTrailDB.append;
                AccsDatamodule.BankAuditTrailDB.post;
                ReportLineCount := ReportLineCount + 2;
           end;

           AccsDatamodule.BankAuditTrailDB.append;
           AccsDatamodule.NLFileDB.Locate('NLNo',BankNo,[]);
           BankName := '';
           BankName := vartostr(BankNo);
           BankName := BankName + ' - ';
           try BankName := BankName + AccsDatamodule.NLFileDB['Name'];
           except
           end;

           AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Bank Account :  ' + BankName;
           AccsDatamodule.BankAuditTrailDB.post;
           ReportLineCount := ReportLineCount + 1;

           if not daterange then begin

           AccsDatamodule.BankAuditTrailDB.append;
           AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Opening Nominal Balance :   ';
           AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := strtofloat(vartostr(AccsDatamodule.NLFileDB['BalanceSt']));

           if not ShowCarriedDetails then AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] := True;
           AccsDatamodule.BankAuditTrailDB.post;
           if ShowCarriedDetails then ReportLineCount := ReportLineCount + 1;

           end;

           RunStatementBal := strtofloat(vartostr(AccsDatamodule.NLFileDB['BalanceSt']));

           // list all carried forward transactions

           try AccsDatamodule.BankAuditTrailQuery.close;
           except
           end;

           AccsDatamodule.BankAuditTrailQuery.sql.clear;

           AccsDatamodule.BankAuditTrailQuery.sql.Add('Select * From Transactions where ((debitac =' + vartostr(BankNo) + ') or (creditac =' + vartostr(BankNo) + ')) and TxNo < ' + vartostr(FirstTxYear));

           if SortBy = 'D' then AccsDatamodule.BankAuditTrailQuery.sql.Add('Order By TxDate')
                        else  AccsDatamodule.BankAuditTrailQuery.sql.Add('Order By TxNo');

           AccsDatamodule.BankAuditTrailQuery.open;
           AccsDatamodule.BankAuditTrailQuery.first;

           CarriedForwardTotal := 0;

           if AccsDatamodule.BankAuditTrailQuery.RecordCount > 0 then begin



                        if not DateRange then begin

                            if ShowCarriedDetails then begin

                                AccsDatamodule.BankAuditTrailDB.append;
                                AccsDatamodule.BankAuditTrailDB.post;
                                ReportLineCount := ReportLineCount + 1;

                                AccsDatamodule.BankAuditTrailDB.edit;
                                AccsDatamodule.BankAuditTrailDB.append;
                                AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Carried forward transaction breakdown - ';
                                AccsDatamodule.BankAuditTrailDB.post;
                                ReportLineCount := ReportLineCount + 1;

                                AccsDatamodule.BankAuditTrailDB.append;
                                AccsDatamodule.BankAuditTrailDB.post;
                                ReportLineCount := ReportLineCount + 1;
                                
                            end;

                        end;

           end;

           for K := 1 to AccsDatamodule.BankAuditTrailQuery.RecordCount do begin



                    AccsDatamodule.BankAuditTrailDB.append;
                    AccsDatamodule.BankAuditTrailDB['StubNumber'] := AccsDatamodule.BankAuditTrailQuery['StubNo'];
                    AccsDatamodule.BankAuditTrailDB['StubDate'] := AccsDatamodule.BankAuditTrailQuery['TxDate'];
                    AccsDatamodule.BankAuditTrailDB['TxNo'] := AccsDatamodule.BankAuditTrailQuery['TxNo'];

                    if AccsDatamodule.BankAuditTrailQuery['DebitAC'] = BankNo  then begin
                                                                                       AccsDatamodule.BankAuditTrailDB['Receipt'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];
                                                                                       CarriedForwardTotal := CarriedForwardTotal - AccsDatamodule.BankAuditTrailDB['Receipt'];
                                                                                       RunStatementBal := RunStatementBal - AccsDatamodule.BankAuditTrailDB['Receipt'];
                    end;
                    if AccsDatamodule.BankAuditTrailQuery['CreditAC'] = BankNo then begin
                                                                                       AccsDatamodule.BankAuditTrailDB['Payment'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];
                                                                                       CarriedForwardTotal := CarriedForwardTotal + AccsDatamodule.BankAuditTrailDB['Payment'];
                                                                                       RunStatementBal := RunStatementBal + AccsDatamodule.BankAuditTrailDB['Payment'];
                    end;


                    AccsDatamodule.BankAuditTrailDB['Status'] := 'Carried Forward';

            //        AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := RunStatementBal;
                    if DateRange then AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] := True;

                    if not ShowCarriedDetails then AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] := True;

                    AccsDatamodule.BankAuditTrailDB.post;
                    if AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] <> True then ReportLineCount := ReportLineCount + 1;


                    AccsDatamodule.BankAuditTrailQuery.next;

            end;    // for K := 1


               if not DateRange then begin
                        AccsDatamodule.BankAuditTrailDB.append;
                        AccsDatamodule.BankAuditTrailDB.post;
                        ReportLineCount := ReportLineCount + 1;
               end;


               if not DateRange then begin

                        AccsDatamodule.BankAuditTrailDB.append;
                        AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Opening Bank Statement Balance';
                        AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := strtofloat(vartostr(AccsDatamodule.NLFileDB['BalanceSt'])) + CarriedForwardTotal;
                        AccsDatamodule.BankAuditTrailDB.post;
                        ReportLineCount := ReportLineCount + 1;

               end;


               AccsDatamodule.BankAuditTrailDB.append;
               AccsDatamodule.BankAuditTrailDB.post;
               ReportLineCount := ReportLineCount + 1;


            AccsDatamodule.BankAuditTrailQuery.close;



            // Gather transactions

            AccsDatamodule.BankAuditTrailQuery.SQL.Clear;
            AccsDatamodule.BankAuditTrailQuery.sql.Add('Select * From Transactions where ((debitac =' + vartostr(BankNo) + ') or (creditac =' + vartostr(BankNo) + '))');

            if SortBy = 'D' then AccsDatamodule.BankAuditTrailQuery.sql.Add('Order By TxDate')
                        else  AccsDatamodule.BankAuditTrailQuery.sql.Add('Order By TxNo');


            AccsDatamodule.BankAuditTrailQuery.open;
            AccsDatamodule.BankAuditTrailQuery.first;

            AppendToPrevious := False;


            For j := 1 to AccsDatamodule.BankAuditTrailQuery.RecordCount do begin

                 if ((AccsDatamodule.BankAuditTrailQuery['NomAmount'] <> 0) and (AccsDatamodule.BankAuditTrailQuery['TxNo'] >= 0)) then begin

                    try PreviousRunStatementBal := AccsDatamodule.BankAuditTrailDB['RunStatementBal'];
                    except
                    end;

                    if OpeningLineEntered = false then DateOpeningStatementBal := RunStatementBal;

                    AccsDatamodule.BankAuditTrailDB.append;
                    AccsDatamodule.BankAuditTrailDB['StubNumber'] := AccsDatamodule.BankAuditTrailQuery['StubNo'];
                    AccsDatamodule.BankAuditTrailDB['StubDate'] := AccsDatamodule.BankAuditTrailQuery['TxDate'];
                    if not AppendToPrevious then AccsDatamodule.BankAuditTrailDB['TxNo'] := AccsDatamodule.BankAuditTrailQuery['TxNo'];
                    if AccsDatamodule.BankAuditTrailQuery['DebitAC'] = BankNo then begin
                                                                                        if AppendToPrevious then AccsDatamodule.BankAuditTrailDB['Receipt'] := AccsDatamodule.BankAuditTrailDB['Receipt'] + AccsDatamodule.BankAuditTrailQuery['NomAmount']       // TGM AB 02/06/17
                                                                                            else AccsDatamodule.BankAuditTrailDB['Receipt'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];  // TGM AB 02/06/17
                                                                                        RunStatementBal := RunStatementBal + AccsDatamodule.BankAuditTrailQuery['NomAmount'];
                                                                                   end;
                    if AccsDatamodule.BankAuditTrailQuery['CreditAC'] = BankNo then begin
                                                                                        if AppendToPrevious then  AccsDatamodule.BankAuditTrailDB['Payment'] := AccsDatamodule.BankAuditTrailDB['Payment'] + AccsDatamodule.BankAuditTrailQuery['NomAmount']       // TGM AB 02/06/17
                                                                                            else AccsDatamodule.BankAuditTrailDB['Payment'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];     // TGM AB 02/06/17
                                                                                        RunStatementBal := RunStatementBal - AccsDatamodule.BankAuditTrailQuery['NomAmount'];
                                                                                   end;

                    if AccsDatamodule.BankAuditTrailQuery['BankRec'] = 'P' then AccsDatamodule.BankAuditTrailDB['Status'] := 'Presented'
                           else AccsDatamodule.BankAuditTrailDB['Status'] := 'Un-Presented';

                    AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := RunStatementBal;

                    // Check if falls within date filter

                    OutsideDateRange := False;

                    if DateRange then begin
                        if ((AccsDatamodule.BankAuditTrailQuery['TxDate'] < DateFrom) or (AccsDatamodule.BankAuditTrailQuery['TxDate'] > DateTo)) then begin
                                AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] := True;
                                OutsideDateRange := True;
                        end;
                    end;

                    if AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] <> true then begin
                        DateRunStatementBal := RunStatementBal;

                    end;

                    AccsDatamodule.BankAuditTrailDB.post;

                    if AccsDatamodule.BankAuditTrailDB['ToBeDeleted'] <> true then ReportLineCount := ReportLineCount + 1;


                    if ((not OutsideDateRange) and (DateRange))then begin
                         if OpeningLineEntered = false then begin
                                OpeningLineEntered := true;
                                AccsDatamodule.BankAuditTrailDB.insert;
                                AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Opening Balance on - ' + datetostr(DateFrom);
                                AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := DateOpeningStatementBal; //PreviousRunStatementBal;
                                AccsDatamodule.BankAuditTrailDB.post;
                                AccsDatamodule.BankAuditTrailDB.next;
                                ReportLineCount := ReportLineCount + 1;
                                AccsDatamodule.BankAuditTrailDB.insert;
                                AccsDatamodule.BankAuditTrailDB.post;
                                ReportLineCount := ReportLineCount + 1;
                                AccsDatamodule.BankAuditTrailDB.last;
                         end;
                    end;



                    if (ShowStubDetails and (not OutsideDateRange)) then begin
                        CustSuppNo := AccsDatamodule.BankAuditTrailQuery['Account'];
                        AccsDatamodule.BankAuditTrailDB.append;
                        AccsDatamodule.BankAuditTrailDB['MultiTxNo'] := AccsDatamodule.BankAuditTrailQuery['TxNo'];
                        AccsDatamodule.BankAuditTrailDB['LineDate'] := AccsDatamodule.BankAuditTrailQuery['TxDate'];
                        AccsDatamodule.BankAuditTrailDB['CommentDesc'] := AccsDatamodule.BankAuditTrailQuery['Descript'];

                        if AccsDatamodule.BankAuditTrailQuery['DebitAC'] = BankNo then begin
                                                                                        AccsDatamodule.BankAuditTrailDB['LineReceipt'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];           // TGM AB 02/06/17
                                                                                        if (AccsDatamodule.BankAuditTrailQuery['TxType'] = 2) then begin                                     // Ch007
                                                                                            AccsDatamodule.SLFileDB.locate('SLNo',AccsDatamodule.BankAuditTrailQuery['Account'],[]);         // Ch007
                                                                                            AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.SLFileDB['Name'];                  // Ch007
                                                                                        end else                                                                                             // Ch007
                                                                                        if (AccsDatamodule.BankAuditTrailQuery['TxType'] = 6) then begin                                     // Ch007
                                                                                            AccsDatamodule.PLFileDB.locate('PLNo',AccsDatamodule.BankAuditTrailQuery['Account'],[]);         // Ch007
                                                                                            AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.PLFileDB['Name'];                  // Ch007
                                                                                        end else begin
                                                                                               AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.BankAuditTrailQuery['Reference'];
                                                                                            end;
                                                                                   end;
                        if AccsDatamodule.BankAuditTrailQuery['CreditAC'] = BankNo then begin
                                                                                        AccsDatamodule.BankAuditTrailDB['LinePayment'] := AccsDatamodule.BankAuditTrailQuery['NomAmount'];          // TGM AB 02/06/17
                                                                                        if (AccsDatamodule.BankAuditTrailQuery['TxType'] = 2) then begin                                     // Ch007
                                                                                            AccsDatamodule.SLFileDB.locate('SLNo',AccsDatamodule.BankAuditTrailQuery['Account'],[]);         // Ch007
                                                                                            AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.SLFileDB['Name'];                  // Ch007
                                                                                        end else                                                                                             // Ch007
                                                                                        if (AccsDatamodule.BankAuditTrailQuery['TxType'] = 6) then begin                                     // Ch007
                                                                                            AccsDatamodule.PLFileDB.locate('PLNo',AccsDatamodule.BankAuditTrailQuery['Account'],[]);         // Ch007
                                                                                            AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.PLFileDB['Name'];                  // Ch007
                                                                                        end else begin
                                                                                               AccsDatamodule.BankAuditTrailDB['CustSupp'] := AccsDatamodule.BankAuditTrailQuery['Reference'];
                                                                                            end;
                                                                                   end;

                        AccsDatamodule.BankAuditTrailDB.post;
                        ReportLineCount := ReportLineCount + 1;
                    end;
                 end;

                    AccsDatamodule.BankAuditTrailQuery.next;
                    AppendToPrevious := False;


         end; // For J := 1







                       if ((OpeningLineEntered = false) and (DateRange)) then begin
                                OpeningLineEntered := true;
                                AccsDatamodule.BankAuditTrailDB.append;
                                AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Opening Balance on - ' + datetostr(DateFrom);
                                AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := DateOpeningStatementBal; //RunStatementBal;
                                AccsDatamodule.BankAuditTrailDB.post;
                                ReportLineCount := ReportLineCount + 1;
                                AccsDatamodule.BankAuditTrailDB.append;
                                AccsDatamodule.BankAuditTrailDB.post;
                                ReportLineCount := ReportLineCount + 1;

                         end;                                                                                                              

                        AccsDatamodule.BankAuditTrailDB.append;
                        AccsDatamodule.BankAuditTrailDB.post;
                        ReportLineCount := ReportLineCount + 1;

                        AccsDatamodule.BankAuditTrailDB.append;
                        if DateRange then begin
                               AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Closing Balance on - ' + datetostr(DateTo);
                            end else begin
                                        AccsDatamodule.BankAuditTrailDB['LabelText'] := 'Nominal Balance';
                                        end;
                        AccsDatamodule.BankAuditTrailDB['RunStatementBal'] := DateRunStatementBal;
                        AccsDatamodule.BankAuditTrailDB.post;
                        ReportLineCount := ReportLineCount + 1;

         end; // NoTransactions

     end; // if BankArray[i].Report = true 

   end; // for i := 1 to 100 do begin




     // This query deletes the unwanted lines when filtering etc

     AccsDatamodule.BankAuditTrailQuery.sql.clear;
     AccsDatamodule.BankAuditTrailQuery.sql.Add('Delete from BankAuditTrailTempTable where ToBeDeleted = True');
     AccsDatamodule.BankAuditTrailQuery.ExecSQL;
     AccsDatamodule.BankAuditTrailQuery.close;




end;


end.
