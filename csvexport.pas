unit csvexport;

(* Changes

    31/08/20 - AB - Transaction Listing Report Issues - Bug : Reference not always being shown (marked Ch028)
                                                        Improvement : customer wanted Cust / Supp shown on all ledger transactions - added cust / supp column (marked Ch028)

*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, accsdata, reportdefs, reports, nomrpt;

type
  TCSVExportForm = class(TForm)
    SaveDialog1: TSaveDialog;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RunExport;
    procedure ThisYearMonthlyReport(Filename : string);
    procedure FullNominalReport(Filename : string);
    procedure TransactionReport(Filename : string);
    procedure TrialBalanceReport(Filename : string);
    procedure CashBookIncomeExpenditureReport(Filename : string);
    procedure BankAuditTrailReport(Filename : string);
    Function RemoveCommas( inputstring: string): string;
    Function ZeroValues( inputstring: string): string;
  end;

var
  CSVExportForm: TCSVExportForm;
 // var ReportType : TReportType;

implementation

{$R *.DFM}

Function TCSVExportForm.RemoveCommas( inputstring: string): string;
var
        i : integer;
begin
     for i:= 1 to length(inputstring) do begin
         if inputstring[i] = ',' then inputstring[i] := ' ';
     end;
     result := inputstring;
end;

Function TCSVExportForm.ZeroValues( inputstring: string): string;

begin
         if inputstring = '' then inputstring := '0';
         if inputstring = '-' then inputstring := '0';
         result := inputstring;
end;


procedure TCSVExportForm.FullNominalReport(Filename : string);
var
        OutputFile : textfile;
        i : integer;
        teststring : string;
        tempstring : string;
        outputline : string;
        testint : integer;
begin
        Assignfile(OutputFile,Filename);
        Rewrite(OutputFile);
        WriteLn(OutputFile,',Trans-No,Stub-No,Debit,Credit,Date,Reference,Running Balance,Quantity,Cust/Supp,Description');
        reports.Report.Table.First;
        for i := 1 to reports.Report.Table.recordcount do begin
           teststring := vartostr(reports.Report.Table['F1']);
           trim(teststring);
           if teststring = '' then teststring := '  ';
           if Ord(teststring[1]) <> 151 then begin // 151 = '-' so skip dashed lines
                if nominalreportform.rgAccountGroup2.ItemIndex = 0 then begin  // By Account
                       teststring := vartostr(reports.Report.Table['F11']); // check if the line holds the account details
                       trim(teststring);
                       if lowercase(teststring) = 'account' then begin
                          outputline := '';
                          outputline := 'Account ' + vartostr(reports.Report.Table['F13']) + ' : ' + removecommas(vartostr(reports.Report.Table['F15']))+',,,,,,,,,';
                          WriteLn(OutputFile,OutputLine);
                       end;
                   end
                        else begin // By Group
                                   teststring := vartostr(reports.Report.Table['F12']);
                                   trim(teststring);
                                   if ((lowercase(teststring) <> 'ref') and (teststring <> '')) then begin
                                       teststring := removecommas(teststring);
                                       outputline := '';
                                       outputline := 'Group : ' + teststring + ',,,,,,,,,,';
                                       WriteLn(OutputFile,OutputLine);
                                   end;
                        end;
                teststring := vartostr(reports.Report.Table['F1']);
                trim(teststring);
                if lowercase(teststring) = 'current balance' then begin
                   outputline := '';
                   Outputline := 'Current Balance,,,' + zerovalues(vartostr(reports.Report.Table['F6'])) + ',' + zerovalues(vartostr(reports.Report.Table['F9'])) +',,,,,,';
                   WriteLn(OutputFile,OutputLine);
                end;
                if lowercase(teststring) = 'year opening' then begin
                   outputline := '';
                   Outputline := 'Year Opening,,,' + zerovalues(vartostr(reports.Report.Table['F6'])) + ',' + zerovalues(vartostr(reports.Report.Table['F9'])) +',,,,,,';
                   WriteLn(OutputFile,OutputLine);
                end;
                if lowercase(teststring) = 'year movement' then begin
                   outputline := '';
                   Outputline := 'Year Movement,,,' + zerovalues(vartostr(reports.Report.Table['F6'])) + ',' + zerovalues(vartostr(reports.Report.Table['F9'])) +',,,,,,';
                   WriteLn(OutputFile,OutputLine);
                end;
                if lowercase(teststring) = 'year budget' then begin
                   outputline := '';
                   Outputline := 'Year Budget,,,' + zerovalues(vartostr(reports.Report.Table['F6'])) + ',' + zerovalues(vartostr(reports.Report.Table['F9'])) +',,,,,,';
                   WriteLn(OutputFile,OutputLine);
                end;
                if lowercase(teststring) = 'last year movement' then begin
                   outputline := '';
                   Outputline := 'Last Year Movement,,,' + zerovalues(vartostr(reports.Report.Table['F6'])) + ',' + zerovalues(vartostr(reports.Report.Table['F9'])) +',,,,,,';
                   WriteLn(OutputFile,OutputLine);
                end;
                if lowercase(teststring) = 'period opening' then begin
                   outputline := '';
                   Outputline := 'Period Opening,,,' + zerovalues(vartostr(reports.Report.Table['F6'])) + ',' + zerovalues(vartostr(reports.Report.Table['F9'])) +',,,,,,';
                   WriteLn(OutputFile,OutputLine);
                end;
                if lowercase(teststring) = 'period movement' then begin
                   outputline := '';
                   Outputline := 'Period Movement,,,' + zerovalues(vartostr(reports.Report.Table['F6'])) + ',' + zerovalues(vartostr(reports.Report.Table['F9'])) +',,,,,,';
                   WriteLn(OutputFile,OutputLine);
                end;
                if lowercase(teststring) = 'year budget diff' then begin
                   outputline := '';
                   Outputline := 'Year Budget Diff,,,' + zerovalues(vartostr(reports.Report.Table['F6'])) + ',' + zerovalues(vartostr(reports.Report.Table['F9'])) +',,,,,,';
                   WriteLn(OutputFile,OutputLine);
                end;
                if nominalreportform.rgAccountGroup2.ItemIndex = 0 then teststring := vartostr(reports.Report.Table['F2'])
                        else begin
                                   teststring := vartostr(reports.Report.Table['F1']);
                                   try testint := strtoint(teststring);
                                   except teststring := '';
                                   end;
                             end;
                trim(teststring);
                if teststring <> '' then begin
                   outputline := '';
                   outputline := ',' + teststring + ',' + vartostr(reports.Report.Table['F3']) + ',' + zerovalues(vartostr(reports.Report.Table['F6'])) + ',' + zerovalues(vartostr(reports.Report.Table['F9'])) +',';
                   accsdatamodule.TransactionsDB.Locate('TxNo',strtoint(teststring),[]);
                   tempstring := datetostr(accsdatamodule.TransactionsDB['Txdate']);
                   outputline := outputline + tempstring + ',';
                   tempstring := vartostr(accsdatamodule.TransactionsDB['Reference']);
                   outputline := outputline + tempstring + ',';
                   tempstring := vartostr(reports.Report.Table['F18']);
                   outputline := outputline + tempstring+ ',';
                   tempstring := vartostr(reports.Report.Table['F20']);
                   outputline := outputline + tempstring+ ',';
                   tempstring := copy(removecommas(vartostr(reports.Report.Table['F21'])),0,21);
                   outputline := outputline + tempstring+ ',';
                   tempstring := removecommas(vartostr(accsdatamodule.TransactionsDB['Descript']));
                   outputline := outputline + tempstring;
                   WriteLn(OutputFile,OutputLine);
                end;
                teststring := vartostr(reports.Report.Table['F6']);
                trim(teststring);
                if teststring = '' then teststring := ' ';
            //    showmessage(vartostr(Ord(teststring[1])));
                if Ord(teststring[1]) = 45 then begin
                   reports.Report.Table.next; // totals on next line
                   outputline := '';
                   outputline := 'Totals,,,' + zerovalues(vartostr(reports.Report.Table['F6'])) + ',' + zerovalues(vartostr(reports.Report.Table['F9'])) + ',,,,' + zerovalues(vartostr(reports.Report.Table['F20']))+ ',,';
                   WriteLn(OutputFile,OutputLine);
                end;
           end;

        reports.Report.Table.next;
        end;
        closefile(OutputFile);

        Showmessage('Export Complete');          //Ch025 - removed CSV
end;

procedure TCSVExportForm.RunExport;
begin

   savedialog1.FileName := '';           //Ch025     

   if savedialog1.Execute then begin
        if reportdefs.ReportType = reportdefs.rpFullNominalAuditTrail then begin
           FullNominalReport(Savedialog1.FileName);
        end;
        if reportdefs.ReportType = reportdefs.rpTrialBalance then begin
           TrialBalanceReport(Savedialog1.FileName);
        end;
        if reportdefs.ReportType = reportdefs.rpCashBookIncomeExpenditure then begin
           CashBookIncomeExpenditureReport(Savedialog1.FileName);
        end;
        if reportdefs.ReportType = reportdefs.rpBankAuditTrail then begin
           BankAuditTrailReport(Savedialog1.FileName);
        end;
        if reportdefs.ReportType = reportdefs.rpTransactionReport then begin
           TransactionReport(Savedialog1.FileName);
        end;
        if reportdefs.ReportType = reportdefs.rpThisYearMonthly then begin
           ThisYearMonthlyReport(Savedialog1.FileName);
        end;
        if reportdefs.ReportType = reportdefs.rpLastYearMonthly then begin
           ThisYearMonthlyReport(Savedialog1.FileName);
        end;
   end
        else showmessage('Error Exporting Data');
end;

procedure TCSVExportForm.TrialBalanceReport(Filename : string);
var
        OutputFile : textfile;
        i : integer;
        teststring, teststring2 : string;
        tempstring : string;
        outputline : string;
begin
     if nominalreportform.extended.Checked = false then begin
        Assignfile(OutputFile,Filename);
        Rewrite(OutputFile);
        WriteLn(OutputFile,'Account,Name,Current Balance - Debit,Current Balance - Credit');
        reports.Report.Table.First;
        for i := 1 to reports.Report.Table.recordcount do begin
           teststring := vartostr(reports.Report.Table['F1']);
           trim(teststring);
           if teststring = '' then teststring := '  ';
           if Ord(teststring[1]) <> 151 then begin // 151 = '-' so skip dashed lines
                 teststring := vartostr(reports.Report.Table['F1']);
                 trim(teststring);
                 teststring2 := vartostr(reports.Report.Table['F2']);
                 trim(teststring2);
              if ((teststring <> 'Account Name') and (teststring2 <> '')) then begin
                 teststring := vartostr(reports.Report.Table['F2']); // check if the line holds the account number
                 trim(teststring);
                 outputline := '';
                 outputline := teststring + ',' + removecommas(vartostr(reports.Report.Table['F4']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'totals ...') then begin
                 outputline := ',Totals ...,,';
                 WriteLn(OutputFile,OutputLine);
              end;
              if pos('number of accounts', lowercase(teststring)) > 0 then begin
                 teststring := vartostr(reports.Report.Table['F1']);
                 trim(teststring);
                 WriteLn(OutputFile,',' + Teststring+',,');
              end;
              if pos('debit total', lowercase(teststring)) > 0 then begin
                 teststring := vartostr(reports.Report.Table['F1']);
                 trim(teststring);
                 outputline := ',,' + teststring;
                 teststring := vartostr(reports.Report.Table['F20']);
                 trim(teststring);
                 WriteLn(OutputFile,Outputline + ',' + Teststring);
              end;
              if (lowercase(teststring) = 'enterprise income') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'non-enterprise income') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'enterprise expenese') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'overheads') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'current assets') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'fixed assets') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'liabilities') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'bank accounts') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'private') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'control accounts') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 WriteLn(OutputFile,OutputLine);
              end;
           end;

        reports.Report.Table.next;
        end;
        closefile(OutputFile);
        Showmessage('Export Complete');                    //Ch025 - removed CSV
     end
      else begin
        Assignfile(OutputFile,Filename);
        Rewrite(OutputFile);
        if nominalreportform.showyearmonth.Checked = true then WriteLn(OutputFile,'Account,Name,Current Balance - Debit,Current Balance - Credit,Year Movement - Debit,Year Movement - Credit,Closing Balance - Debit,Closing Balance - Credit')
           else WriteLn(OutputFile,'Account,Name,Current Balance - Debit,Current Balance - Credit,Month Movement - Debit,Month Movement - Credit,Closing Balance - Debit,Closing Balance - Credit');
        reports.Report.Table.First;
        for i := 1 to reports.Report.Table.recordcount do begin
           teststring := vartostr(reports.Report.Table['F1']);
           trim(teststring);
           if teststring = '' then teststring := '  ';
           if Ord(teststring[1]) <> 151 then begin // 151 = '-' so skip dashed lines
                 teststring := vartostr(reports.Report.Table['F1']);
                 trim(teststring);
                 teststring2 := vartostr(reports.Report.Table['F2']);
                 trim(teststring2);
              if ((teststring <> 'Account Name') and (teststring2 <> '')) then begin
                 teststring := vartostr(reports.Report.Table['F2']); // check if the line holds the account number
                 trim(teststring);
                 outputline := '';
                 outputline := teststring + ',' + removecommas(vartostr(reports.Report.Table['F4']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F13']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F15']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F17']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F19']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'totals ...') then begin
                 outputline := ',Totals ...,,';
                 WriteLn(OutputFile,OutputLine);
              end;
              if pos('number of accounts', lowercase(teststring)) > 0 then begin
                 teststring := vartostr(reports.Report.Table['F1']);
                 trim(teststring);
                 WriteLn(OutputFile,',' + Teststring+',,');
              end;
              if pos('debit total', lowercase(teststring)) > 0 then begin
                 teststring := vartostr(reports.Report.Table['F1']);
                 trim(teststring);
                 outputline := ',,' + teststring;
                 teststring := vartostr(reports.Report.Table['F20']);
                 trim(teststring);
                 WriteLn(OutputFile,Outputline + ',' + Teststring);
              end;
              if (lowercase(teststring) = 'enterprise income') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F13']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F15']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F17']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F19']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'non-enterprise income') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F13']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F15']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F17']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F19']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'enterprise expenese') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F13']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F15']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F17']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F19']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'overheads') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F13']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F15']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F17']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F19']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'current assets') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F13']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F15']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F17']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F19']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'fixed assets') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F13']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F15']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F17']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F19']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'liabilities') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F13']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F15']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F17']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F19']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'bank accounts') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F13']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F15']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F17']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F19']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'private') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F13']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F15']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F17']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F19']));
                 WriteLn(OutputFile,OutputLine);
              end;
              if (lowercase(teststring) = 'control accounts') then begin
                 outputline := '';
                 outputline := ',' + teststring + '';
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F9']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F11']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F13']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F15']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F17']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F19']));
                 WriteLn(OutputFile,OutputLine);
              end;
           end;

        reports.Report.Table.next;
        end;
        closefile(OutputFile);
        Showmessage('Export Complete');       //Ch025 - removed CSV

     end;

end;

procedure TCSVExportForm.CashBookIncomeExpenditureReport(Filename : string);
var
        OutputFile : textfile;
        i : integer;
        teststring, teststring2 : string;
        tempstring : string;
        outputline : string;
begin
        Assignfile(OutputFile,Filename);
        Rewrite(OutputFile);
        WriteLn(OutputFile,'Record,Date,Reference,Amount,VAT/Disc,Supplier,Stub-No,Account Name');
        reports.Report.Table.First;
        for i := 1 to reports.Report.Table.recordcount do begin
           teststring := vartostr(reports.Report.Table['F1']);
           trim(teststring);
           if teststring = '' then teststring := '  ';
           if Ord(teststring[1]) <> 151 then begin // 151 = '-' so skip dashed lines
                 if (lowercase(teststring) = 'totals ...') then begin
                     outputline := 'Totals ...,,,,,,,';
                     WriteLn(OutputFile,OutputLine);
                 end;
                 if pos('number of records', lowercase(teststring)) > 0 then begin
                     teststring := vartostr(reports.Report.Table['F1']);
                     trim(teststring);
                     WriteLn(OutputFile,Teststring+',,,,,,,');
                 end;
                 if pos('amount total', lowercase(teststring)) > 0 then begin
                     teststring := vartostr(reports.Report.Table['F1']);
                     trim(teststring);
                     WriteLn(OutputFile,Teststring+',,,,,,,');
                 end;
                 if pos('vat/discount', lowercase(teststring)) > 0 then begin
                     teststring := vartostr(reports.Report.Table['F1']);
                     trim(teststring);
                     WriteLn(OutputFile,Teststring+',,,,,,,');
                 end;
                 if pos('grand total', lowercase(teststring)) > 0 then begin
                     teststring := vartostr(reports.Report.Table['F1']);
                     trim(teststring);
                     WriteLn(OutputFile,Teststring+',,,,,,,');
                 end;
                 teststring := vartostr(reports.Report.Table['F2']);
                 trim(teststring);
                 if (teststring <> '') then begin
                 outputline := '';
                 outputline := teststring + ',' + copy(removecommas(vartostr(reports.Report.Table['F3'])),1,8);
                 outputline := outputline + ',' + copy(removecommas(vartostr(reports.Report.Table['F3'])),10,length(removecommas(vartostr(reports.Report.Table['F3']))));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F6']));
                 outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F8']));
                 outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F10']));
                 outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F12']));
                 outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F14']));
                 WriteLn(OutputFile,OutputLine);
              end;

          end; // if ord
        reports.Report.Table.next;
        end;
        closefile(OutputFile);
        Showmessage('Export Complete');                //Ch025 - removed CSV
     end;

procedure TCSVExportForm.BankAuditTrailReport(Filename : string);
var
        OutputFile : textfile;
        i : integer;
        teststring, teststring2 : string;
        tempstring : string;
        outputline : string;
begin
     if nominalreportform.showstubdetails.Checked = false then begin
        Assignfile(OutputFile,Filename);
        Rewrite(OutputFile);
        WriteLn(OutputFile,'Account Number,Receipt,Payment,Date,Status,Trans No');
        reports.Report.Table.First;
        for i := 1 to reports.Report.Table.recordcount do begin
           teststring := vartostr(reports.Report.Table['F1']);
           trim(teststring);
           if teststring = '' then teststring := '  ';
           if Ord(teststring[1]) <> 151 then begin // 151 = '-' so skip dashed lines
                  teststring := vartostr(reports.Report.Table['F18']);
                  trim(teststring);
                  if (teststring <> '') then begin
                      outputline := '';
                      outputline := vartostr(reports.Report.Table['F18']) + ' : ' + removecommas(vartostr(reports.Report.Table['F8'])) + ',' + zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7'])) +',,,';
                      WriteLn(OutputFile,OutputLine);
                  end;
                  teststring := vartostr(reports.Report.Table['F1']);
                  trim(teststring);
                  if lowercase(teststring) = 'year opening' then begin
                   outputline := '';
                   Outputline := 'Year Opening,' + zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7'])) +',,,,';
                   WriteLn(OutputFile,OutputLine);
                  end;
                  if lowercase(teststring) = 'year movement' then begin
                   outputline := '';
                   Outputline := 'Year Movement,' + zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7'])) +',,,,';
                   WriteLn(OutputFile,OutputLine);
                  end;
                  if lowercase(teststring) = 'period opening' then begin
                   outputline := '';
                   Outputline := 'Period Opening,' + zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7'])) +',,,,';
                   WriteLn(OutputFile,OutputLine);
                end;
                if lowercase(teststring) = 'period movement' then begin
                   outputline := '';
                   Outputline := 'Period Movement,' + zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7'])) +',,,,';
                   WriteLn(OutputFile,OutputLine);
                end;

                teststring := vartostr(reports.Report.Table['F2']);
                trim(teststring);
                if teststring = '' then teststring := '  ';
                if (teststring[1] = '-') then begin
                  { reports.Report.Table.next;
                   outputline := '';
                   outputline := 'Totals';
                   outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7'])) + ',,,';
                   WriteLn(OutputFile,OutputLine);  }
                   // not included as totals are not filled in
                end;

                teststring := vartostr(reports.Report.Table['F1']);
                trim(teststring);
                if pos('stub-no',lowercase(teststring)) > 0 then begin
                   outputline := '';
                   outputline := removecommas(vartostr(reports.Report.Table['F1']));
                   outputline := outputline + ',' +  zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7']));
                   outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F9']));
                   outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F11']));
                   outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F13']));
                   WriteLn(OutputFile,OutputLine);
                end;

          end; // if ord
        reports.Report.Table.next;
        end;
        closefile(OutputFile);
        Showmessage('Export Complete');        //Ch025 - removed CSV
     end // showstubdetails
        else begin
                Assignfile(OutputFile,Filename);
                Rewrite(OutputFile);
                WriteLn(OutputFile,'Account Number,Receipt,Payment,Date,Status,Trans No,Customer/Supplier,Comment/Desc');
                reports.Report.Table.First;
                for i := 1 to reports.Report.Table.recordcount do begin
                        teststring := vartostr(reports.Report.Table['F1']);
                        trim(teststring);
                        if teststring = '' then teststring := '  ';
                        if Ord(teststring[1]) <> 151 then begin // 151 = '-' so skip dashed lines
                                teststring := vartostr(reports.Report.Table['F18']);
                                trim(teststring);
                                if (teststring <> '') then begin
                                outputline := '';
                                outputline := vartostr(reports.Report.Table['F18']) + ' : ' + removecommas(vartostr(reports.Report.Table['F8'])) + ',' + zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7'])) +',,,,,';
                                WriteLn(OutputFile,OutputLine);
                        end;
                        teststring := vartostr(reports.Report.Table['F1']);
                        trim(teststring);
                        if lowercase(teststring) = 'year opening' then begin
                                outputline := '';
                                Outputline := 'Year Opening,' + zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7'])) +',,,,,,';
                                WriteLn(OutputFile,OutputLine);
                        end;
                        if lowercase(teststring) = 'year movement' then begin
                                outputline := '';
                                Outputline := 'Year Movement,' + zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7'])) +',,,,,,';
                                WriteLn(OutputFile,OutputLine);
                        end;
                        if lowercase(teststring) = 'period opening' then begin
                                outputline := '';
                                Outputline := 'Period Opening,' + zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7'])) +',,,,,,';
                                WriteLn(OutputFile,OutputLine);
                        end;
                        if lowercase(teststring) = 'period movement' then begin
                                outputline := '';
                                Outputline := 'Period Movement,' + zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7'])) +',,,,,,';
                                WriteLn(OutputFile,OutputLine);
                        end;

                        teststring := vartostr(reports.Report.Table['F2']);
                        trim(teststring);
                        if teststring = '' then teststring := '  ';
                        if (teststring[1] = '-') then begin
                                reports.Report.Table.next;
                                outputline := '';
                                outputline := 'Totals';
                                outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7'])) + ',,,,,';
                                WriteLn(OutputFile,OutputLine);
                        end;

                        teststring := vartostr(reports.Report.Table['F9']);
                        trim(teststring);
                        if teststring <> '' then begin
                                outputline := '';
                                outputline := ',' +  zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7']));
                                outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F9']));
                                outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F11']));
                                outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F13']));
                                outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F14']));
                                outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F16']));
                                WriteLn(OutputFile,OutputLine);
                        end;

                        teststring := vartostr(reports.Report.Table['F1']);
                        trim(teststring);
                        if pos('stub-no',lowercase(teststring)) > 0 then begin
                                outputline := '';
                                outputline := removecommas(vartostr(reports.Report.Table['F1']));
                                outputline := outputline + ',' +  zerovalues(vartostr(reports.Report.Table['F4'])) + ',' + zerovalues(vartostr(reports.Report.Table['F7']));
                                outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F9']));
                                outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F11']));
                                outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F13']));
                                WriteLn(OutputFile,OutputLine);
                        end;

                end; // if ord
                reports.Report.Table.next;
           end;
        closefile(OutputFile);
        Showmessage('Export Complete');            //Ch025 - removed CSV
        END;
end;

procedure TCSVExportForm.TransactionReport(Filename : string);
var
        OutputFile : textfile;
        i : integer;
        teststring : string;
        tempstring : string;
        outputline : string;
        testint : integer;
begin
        Assignfile(OutputFile,Filename);
        Rewrite(OutputFile);
      //  WriteLn(OutputFile,'Trans-No,Date,Amount,Vat/Disc,Ref,Description or Customer/Suppier, Stub-No, Transaction Type');           //Ch028
        WriteLn(OutputFile,'Trans-No,Date,Amount,Vat/Disc,Ref,Description,Stub-No,Transaction Type,Customer/Suppier');           //Ch028
        reports.Report.Table.First;
        reports.Report.Table.next;
        reports.Report.Table.next;
        reports.Report.Table.next;
        reports.Report.Table.next; //move to record 5
        for i := 1 to reports.Report.Table.recordcount do begin
           teststring := vartostr(reports.Report.Table['F3']);
           if ((teststring <> '') and (teststring <> 'Date')) then begin                                                                             // Ch028 skip header lines
                   outputline := '';
                   outputline := vartostr(reports.Report.Table['F2']);
                   outputline := outputline + ',' + vartostr(reports.Report.Table['F3']);
                   outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F6']));
                   outputline := outputline + ',' + zerovalues(vartostr(reports.Report.Table['F8']));
                   outputline := outputline + ',' + vartostr(reports.Report.Table['F9']);
                   outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F10']));
                   outputline := outputline + ',' + vartostr(reports.Report.Table['F12']);
                   outputline := outputline + ',' + vartostr(reports.Report.Table['F13']);
                   outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F14']));                       //Ch028
                   WriteLn(OutputFile,OutputLine);
                end;
        (*                                                                                                           //Ch028 removed this section to take toals lines off export
           teststring := vartostr(reports.Report.Table['F1']);
           if (lowercase(teststring) = 'totals ...') then begin
                     outputline := 'Totals ...,,,,,,';
                     WriteLn(OutputFile,OutputLine);
                     reports.Report.Table.next;
                     reports.Report.Table.next;
                     Outputline := vartostr(reports.Report.Table['F1']) + ',,,,,,';
                     WriteLn(OutputFile,OutputLine);
           end;
        *)
           reports.Report.Table.next;
        end;
        closefile(OutputFile);
        Showmessage('Transaction Report CSV Export Complete');       //Ch025 added Transaction Report


end;

procedure TCSVExportForm.ThisYearMonthlyReport(Filename : string);
var
        OutputFile : textfile;
        i : integer;
        teststring, outputline : string;
        blankfollowingline : boolean;
begin
        blankfollowingline := false;
        Assignfile(OutputFile,Filename);
        Rewrite(OutputFile);
        WriteLn(OutputFile,'Enterprise,Account,Name,Jan,Feb,Mar,Apr,May,June,Jul,Aug,Sept,Oct,Nov,Dec,Total');
      //  WriteLn(OutputFile,',,,,,,,,,,,,,,,');
        reports.Report.Table.First;

        for i := 1 to reports.Report.Table.recordcount do begin
           outputline := '';

           if blankfollowingline then begin
                WriteLn(OutputFile,',,,,,,,,,,,,,,,');
                blankfollowingline := false;
           end;

           teststring := vartostr(reports.Report.Table['F1']);

           if teststring <> '' then begin
              if uppercase(teststring) = 'ENTERPRISE' then begin
                        WriteLn(OutputFile,',,,,,,,,,,,,,,,');
                        WriteLn(OutputFile,'Enterprise,,,,,,,,,,,,,,,');
              end
                  else if pos('———',teststring) = 0 then begin
                            outputline := vartostr(reports.Report.Table['F1']);
                            outputline := outputline + ',,,' + vartostr(reports.Report.Table['F5']);
                            outputline := outputline + ',' + vartostr(reports.Report.Table['F7']);
                            outputline := outputline + ',' + vartostr(reports.Report.Table['F9']);
                            outputline := outputline + ',' + vartostr(reports.Report.Table['F11']);
                            outputline := outputline + ',' + vartostr(reports.Report.Table['F13']);
                            outputline := outputline + ',' + vartostr(reports.Report.Table['F15']);
                            outputline := outputline + ',' + vartostr(reports.Report.Table['F17']);
                            outputline := outputline + ',' + vartostr(reports.Report.Table['F19']);
                            outputline := outputline + ',' + vartostr(reports.Report.Table['F21']);
                            outputline := outputline + ',' + vartostr(reports.Report.Table['F23']);
                            outputline := outputline + ',' + vartostr(reports.Report.Table['F25']);
                            outputline := outputline + ',' + vartostr(reports.Report.Table['F27']);
                            outputline := outputline + ',' + vartostr(reports.Report.Table['F29']);
                            WriteLn(OutputFile,OutputLine);
                  end



           end else begin

                    teststring := vartostr(reports.Report.Table['F2']);
                    if teststring <> '' then begin
                                             teststring := vartostr(reports.Report.Table['F3']);
                                             if teststring[1] = '-' then begin
                                                 WriteLn(OutputFile,vartostr(reports.Report.Table['F2']) + vartostr(reports.Report.Table['F3']) + ',,,,,,,,,,,,,,,');
                                             end else begin

                                                 outputline := ',' + vartostr(reports.Report.Table['F2']);
                                                 outputline := outputline + ',' + removecommas(vartostr(reports.Report.Table['F3']));
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F5']);
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F7']);
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F9']);
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F11']);
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F13']);
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F15']);
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F17']);
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F19']);
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F21']);
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F23']);
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F25']);
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F27']);
                                                 outputline := outputline + ',' + vartostr(reports.Report.Table['F29']);
                                                 WriteLn(OutputFile,OutputLine);
                                             end;


                    end;
           end;

           reports.Report.Table.next;
        end;
        closefile(OutputFile);
        Showmessage('Export Complete');      //Ch025 - removed CSV


end;

end.
