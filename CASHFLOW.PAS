unit Cashflow;
{
Form to Run Reports Invoice, Payment & Credit Note Listing Reports
}
interface                          

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, Mask, NewClass, ComCtrls;

type
  TCashFlowReportsForm = class(TKingForm)
    CustSuppPanel: TPanel;
    GroupFrom: TEdit;
    GroupTo: TEdit;
    ReportDate: TLabel;
    GroupFromLabel: TLabel;
    GroupToLabel: TLabel;
    Panel1: TPanel;
    Help: TBitBtn;
    Run: TBitBtn;
    Exit: TBitBtn;
    UseTx: TCheckBox;
    CalMonth: TEdit;
    CalMonthLabel: TLabel;
    Panel2: TPanel;
    VReports: TRadioButton;
    PReports: TRadioButton;
    RepDate: TMaskEdit;
    RepSearch: TDateTimePicker;
    cbNewPage: TCheckBox;
    cbPrintNonIncome: TCheckBox;
    procedure RunClick(Sender: TObject);
    procedure GroupFromKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GroupToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ExitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure GroupFromExit(Sender: TObject);
    procedure GroupToExit(Sender: TObject);
    procedure PReportsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VReportsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RepSearchCloseUp(Sender: TObject);
    procedure RepDateExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UseTxClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure FixMissingNominalGroups;
  private
    { Private declarations }
  public
    { Public declarations }
    SecondOption : Integer;
    TxDateFrom,
    TxDateTo                : Integer;
  end;

var
  CashFlowReportsForm: TCashFlowReportsForm;

implementation
Uses
    pickdate,
    DBCore,
    newlisting,
    vars,
    types,
    Calcs,
    Casha,
    NewRepUnit,
    Printers,
    Accsdata,
    FullAudit;

{$R *.DFM}

procedure TCashFlowReportsForm.RunClick(Sender: TObject);
begin
     REPXDATE := RepDate.Text;

     If (Act = 24) then FixMissingNominalGroups;

     If ( Act = 1) Then//CashFlowMainForm.ActualCashFlowToDateRadio.Checked
        RunCashFlow ( 1, 0 )
     Else If ( Act = 2 ) Then//CashFlowMainForm.CashFlowVBudgetMonthRadio.Checked
        RunCashFlow ( 2, 0 )
     Else If ( Act = 3 ) Then//CashFlowMainForm.CashFlowVBudgetYearRadio.Checked
        RunCashFlow ( 3, 0 )
     Else If ( Act = 4 ) Then // enterprise summary report
        RunCashFlow ( 4, NewRepUnit.EnterpriseSummaryOption)   //  TGM AB Removed
     Else If ( Act = 5 ) Then//Overheads
        RunCashFlow ( 5, SecondOption )
     Else If ( Act = 24 ) Then begin //CashFlowMainForm.ProfitAndLossRadio.Checked
        // TGM AB 16/08/13 Added Data Integrity Check Below

        SetDb ( NlFile );
   //     NomFrom := 1;
   //     NomTo   := db1.dbrechigh;

        Fullaudit.RunAuditFiles(3,1,db1.dbrechigh,1,1,false);
        auditfiles.OnActivate(self);
        auditfiles.OnShow(self);
        if fullaudit.AuditFiles.NLbalancesOK(false,false,1) = false then
            showmessage('Data Integrity Check indicates there may be a problem with your data. ' +#10#13
            +'Please contact Kingswood before printing off this report for your accountant.');

        RunCashFlow ( 24, 0 )

        end
     Else If ( Act = 21 ) Then//Budget this Year Monthly
        RunCashFlow ( Act, 0 )
     Else If ( Act = 22 ) Then//Last Years Actual Monthly Balances
        RunCashFlow ( Act, 0 );
end;

procedure TCashFlowReportsForm.GroupFromKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    KOnKeyDown ( Sender, Key, Shift, AllNoms, 'G');
end;

procedure TCashFlowReportsForm.GroupToKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    KOnKeyDown ( Sender, Key, Shift, AllNoms, 'G');
end;

procedure TCashFlowReportsForm.ExitClick(Sender: TObject);
begin
     Close;
end;

procedure TCashFlowReportsForm.FormActivate(Sender: TObject);
Var i : Integer;
begin
     Panel2.Visible := not NewRepForm.NewReports.Checked;
     if Cash11.Xuse_enterprise then
        cbPrintNonIncome.Caption := 'Include Income'
     else
        cbPrintNonIncome.Caption := 'Include Non-' + Cash2.XENTLOWER + ' Income';

     if Device = 'P' then
        PReports.Checked := True
     else
        VReports.Checked := True;

     for i := 0 to ComponentCount-1 do
        if Components[i] is TEdit then
           TEdit(Components[i]).Text := '';

     TxDateFrom := CDateFrom;
     TxDateTo   := CDateTo;
     RepDate.Text := Cash1.xDate;
     Calmonth.Text := IntToStr(Cash1.xmonthno);

     if ( Act in [21,22,24] ) then //CashFlowMainForm.ProfitAndLossRadio.Checked
        begin
             cbNewPage.Hide;
             cbPrintNonIncome.Hide;
             UseTx.Hide;
             GroupFromLabel.Hide;
             GroupToLabel.Hide;
             GroupFrom.Hide;
             GroupTo.Hide;
             CalMonth.Hide;
             CalMonthLabel.Hide;
        end
     else if ( ACT = 5 ) then // Overhead Reports
        begin
             cbPrintNonIncome.Show;
             cbNewPage.Hide;
             GroupFromLabel.Hide;
             GroupToLabel.Hide;
             GroupFrom.Hide;
             GroupTo.Hide;
             if SecondOption in [1,2] then
                begin
                   CalMonth.Show;
                   CalMonthLabel.Show;
                end
             else
                begin
                   CalMonth.Hide;
                   CalMonthLabel.Hide;
                end;
             if SecondOption = 4 then
                UseTx.Show
             else
                UseTx.Hide;
        end
     else if ( ACT = 4 ) then // Enterprise Summary
        begin
             self.caption := 'Enterprise Summary Reports';
             cbPrintNonIncome.hide;
             cbNewPage.Hide;
             GroupFromLabel.Hide;
             GroupToLabel.Hide;
             GroupFrom.Hide;
             GroupTo.Hide;
             CalMonth.Show;
             CalMonth.Text := vartostr(Cash1.Xmonthno);
             CalMonthLabel.Show;
             UseTx.Hide;
        end
     else
        begin
             cbPrintNonIncome.Hide;
             cbNewPage.Show;
             UseTx.Show;
             GroupFromLabel.Show;
             GroupToLabel.Show;
             GroupFrom.Show;
             GroupTo.Show;
             CalMonth.Show;
             CalMonthLabel.Show;
             // Cashflow V. budget this Year
             if ( Act = 3 ) then
                begin
                   CalMonth.Hide;
                   CalMonthLabel.Hide;
                end
             // Cashflow V. Budget this Month
             else if ( Act = 2 ) then
                begin
                   GroupFromLabel.Hide;
                   GroupToLabel.Hide;
                   GroupFrom.Hide;
                   GroupTo.Hide;
                end;
             UseTxClick(Sender);        // Check the Status of Use Tx
        end;

     GroupFrom.Text := '1';
     GroupTo.Text   := '999';
     RepDate.SetFocus;
end;

procedure TCashFlowReportsForm.GroupFromExit(Sender: TObject);
begin
     If NOT Numeric ( GroupFrom.Text ) Then
        GroupFrom.SetFocus;
end;

procedure TCashFlowReportsForm.GroupToExit(Sender: TObject);
begin
     If NOT Numeric ( GroupTo.Text ) Then
        GroupTo.SetFocus
     Else
         If ( StrToInt ( GroupTo.Text ) < StrToInt ( GroupFrom.Text )) Then
            GroupTo.SetFocus;
end;

procedure TCashFlowReportsForm.PReportsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     KPrinterOrScreen ( Sender, Button, Shift, x, y );
end;

procedure TCashFlowReportsForm.VReportsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     KPrinterOrScreen ( Sender, Button, Shift, x, y );
end;

procedure TCashFlowReportsForm.RepSearchCloseUp(Sender: TObject);
begin
     RepDate.Text:= DateToStr(RepSearch.Date);
     RepDate.SetFocus;
end;

procedure TCashFlowReportsForm.RepDateExit(Sender: TObject);
begin
     KDateValid ( Sender );
end;

procedure TCashFlowReportsForm.FormShow(Sender: TObject);
begin
     RepSearch.Date := KStrToDate (Cash11.Default_Date);
     RepDate.Text := Cash1.xDate;
end;

procedure TCashFlowReportsForm.UseTxClick(Sender: TObject);
begin
     if UseTx.Checked and ( Act in [1,3,5] ) then
        begin
           CalMonth.Enabled := False;
           CalMonth.Hide;
           CalMonthLabel.Hide;
        end
     else
        begin
           CalMonth.Enabled := True;
           CalMonth.Show;
           CalMonthLabel.Show;
        end;
end;

procedure TCashFlowReportsForm.HelpClick(Sender: TObject);
begin
     if ( Act = 1) then//CashFlowMainForm.ActualCashFlowToDateRadio.Checked
        //Application.HelpContext(166)
        AccsDataModule.HTMLHelp('actualCashflowToDate.htm')
     else if ( Act = 2 ) then//CashFlowMainForm.CashFlowVBudgetMonthRadio.Checked
        //Application.HelpContext(167)
        AccsDataModule.HTMLHelp('cashflowVersusBudgetThisMonth.htm')
     else if ( Act = 3 ) then//CashFlowMainForm.CashFlowVBudgetYearRadio.Checked
        //Application.HelpContext(168)
        AccsDataModule.HTMLHelp('cashflowVersusBudget.htm')
     else if ( Act = 24 ) then//CashFlowMainForm.ProfitAndLossRadio.Checked
        //Application.HelpContext(169);
        AccsDataModule.HTMLHelp('profitAndLossAccount.htm');
end;


procedure TCashFlowReportsForm.FixMissingNominalGroups;
var
   I : integer;
begin
    // Fixes Nominal Codes where the report group is 0 to be the same as the nomial code
    // and then updates the NLGroups table to reflect the group is active and give it the same
    // name as that of the nominal code

    Accsdatamodule.NLFileDB.open;
    Accsdatamodule.NLFileDB.First;

    For i:=1 to Accsdatamodule.NLFileDB.recordcount do begin
        if Accsdatamodule.NLFileDB['Active'] = true then begin
             if Accsdatamodule.NLFileDB['RepGroup'] = 0 then begin
                 Accsdatamodule.NLFileDB.edit;
                 Accsdatamodule.NLFileDB['RepGroup'] := i;
                 Accsdatamodule.NLFileDB.post;

                 Accsdatamodule.NLGroupsDB.open;
                 Accsdatamodule.NLGroupsDB.Locate('GroupNo',I,[]);
                 Accsdatamodule.NLGroupsDB.Edit;
                 Accsdatamodule.NLGroupsDB['Active'] := true;
                 if Accsdatamodule.NLGroupsDB['GroupDesc'] = '' then Accsdatamodule.NLGroupsDB['GroupDesc'] := Accsdatamodule.NLFileDB['Name'];
                 Accsdatamodule.NLGroupsDB.Post;

             end;

        end;
    Accsdatamodule.NLFileDB.next;    
    end;

end;

end.
