unit Cashrpts;
                                
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Mask, ExtCtrls{, Mask, Mask, VBXCtrl, Switch};

type
  TCashFlowMainForm = class(TForm)
    Panel1: TPanel;
    Help: TBitBtn;
    CustSuppGroupBox: TGroupBox;
    ActualCashFlowToDateRadio: TRadioButton;
    CashFlowVBudgetMonthRadio: TRadioButton;
    CashFlowVBudgetYearRadio: TRadioButton;
    ProfitAndLossRadio: TRadioButton;
    ManagementBalanceSheetRadio: TRadioButton;
    Exit: TBitBtn;
    procedure CancelButtonClick(Sender: TObject);
    procedure SuppReportsRadioClick(Sender: TObject);
    procedure CustReportsRadioClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure ActualCashFlowToDateRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CashFlowVBudgetMonthRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CashFlowVBudgetYearRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ProfitAndLossRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ManagementBalanceSheetRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    DataBase : Integer;
  end;

var
  CashFlowMainForm: TCashFlowMainForm;

implementation
Uses
  NomRpt,
  CashFlow,
  pickdate,
  newlisting,
  calcs,
  vars,
  types,
  DBRPT;

{$R *.DFM}

procedure TCashFlowMainForm.CancelButtonClick(Sender: TObject);
begin
     ModalResult := mrCancel;
end;

procedure TCashFlowMainForm.SuppReportsRadioClick(Sender: TObject);
begin
{     CustSuppGroupBox.Caption := 'Supplier';
     CustSuppReportForm.Caption := 'Supplier Reports';
     PaymentReceiptListingRadio.Caption := 'Receipt Listing';
     PROG := SuppRep;
     DataBase := PlFile;
}
end;

procedure TCashFlowMainForm.CustReportsRadioClick(Sender: TObject);
begin
{     CustSuppGroupBox.Caption := 'Customer';
     CustSuppReportForm.Caption := 'Customer Reports';
     PaymentReceiptListingRadio.Caption := 'Payment Listing';
     PROG := CustRep;
     DataBase := SlFile;
}end;

procedure TCashFlowMainForm.FormActivate(Sender: TObject);
begin
     ActualCashFlowToDateRadio.SetFocus;
     caption := 'Cashflow Reports';{ + ' - ' + st;}
     Device[1] := 'F';
     PROG := AnnBud;
     DataBase := NlFile;
end;

procedure TCashFlowMainForm.ExitClick(Sender: TObject);
begin
     Close;
end;

procedure TCashFlowMainForm.ActualCashFlowToDateRadioMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    ActualCashFlowToDateRadio.Checked := True;
    CashFlow.CashFlowReportsForm.Caption := 'Actual Cash Flow To Date';{ + ' - ' + st;}
    CashFlow.CashFlowReportsForm.Enabled := True;
    CashFlow.CashFlowReportsForm.ShowModal;
end;

procedure TCashFlowMainForm.CashFlowVBudgetMonthRadioMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
     CashFlowVBudgetMonthRadio.Checked := True;
     CashFlow.CashFlowReportsForm.Caption := 'Cash Versus Budget - This Month';{ + ' - ' + st;}
     CashFlow.CashFlowReportsForm.Enabled := True;
     CashFlow.CashFlowReportsForm.CalMonthLabel.Show;
     CashFlow.CashFlowReportsForm.CalMonth.Show;
     CashFlow.CashFlowReportsForm.ShowModal;
end;

procedure TCashFlowMainForm.CashFlowVBudgetYearRadioMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
     CashFlowVBudgetYearRadio.Checked := True;
     CashFlow.CashFlowReportsForm.Caption := 'Cash Versus Budget - This Year';{ + ' - ' + st;}
     CashFlow.CashFlowReportsForm.Enabled := True;
     CashFlow.CashFlowReportsForm.CalMonthLabel.Show;
     CashFlow.CashFlowReportsForm.CalMonth.Show;
     CashFlow.CashFlowReportsForm.ShowModal;
end;

procedure TCashFlowMainForm.ProfitAndLossRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    ProfitAndLossRadio.Checked := True;
    CashFlow.CashFlowReportsForm.Caption := 'Profit And Loss Account';{ + ' - ' + st;}
    CashFlow.CashFlowReportsForm.ShowModal;
end;

procedure TCashFlowMainForm.ManagementBalanceSheetRadioMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    ManagementBalanceSheetRadio.Checked := True;
    NomRpt.NominalReportForm.TrialBalancePanel.Enabled := False;
    NomRpt.NominalReportForm.BankAuditPanel.Enabled := False;
    NomRpt.NominalReportForm.FullNominalPanel.Enabled := False;
    NomRpt.NominalReportForm.CashBookListingPanel.Enabled := False;
    NomRpt.NominalReportForm.TransListingPanel.Enabled := True;
    NomRpt.NominalReportForm.VatPanel.Enabled := False;
    NomRpt.NominalReportForm.TrialBalancePanel.Hide;
    NomRpt.NominalReportForm.BankAuditPanel.Hide;
    NomRpt.NominalReportForm.FullNominalPanel.Hide;
    NomRpt.NominalReportForm.CashbookListingPanel.Hide;
    NomRpt.NominalReportForm.TransListingPanel.Hide;
    NomRpt.NominalReportForm.VATPanel.Hide;
    NomRpt.NominalReportForm.UseDatePanel.Hide;
    NomRpt.NominalReportForm.UseTransPanel.Hide;
    NomRpt.NominalReportForm.Caption := 'Management Balance Sheet';
    NomRpt.NominalReportForm.BalanceSheetPanel.Enabled := True;
    NomRpt.NominalReportForm.BalanceSheetPanel.Show;
    NomRpt.NominalReportForm.ShowModal;
//    NomRpt.NominalReportForm.RepDate.SetFocus;
end;

procedure TCashFlowMainForm.HelpClick(Sender: TObject);
begin
     Application.HelpContext(112);
end;

procedure TCashFlowMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Key = VK_F1 Then
        Application.HelpContext(112);
end;

End.
