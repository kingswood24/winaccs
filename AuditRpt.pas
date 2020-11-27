unit Auditrpt;

interface                  

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TAuditReportsForm = class(TForm)
    Panel1: TPanel;
    Help: TBitBtn;
    AuditReportsPanel: TGroupBox;
    TrialBalanceRadio: TRadioButton;
    BankAuditRadio: TRadioButton;
    Exit: TBitBtn;
    IncExpListButton: TRadioButton;
    TransListingRadio: TRadioButton;
    FullNominalLedgerRadio: TRadioButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TransListingRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure IncExpListButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BankAuditRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TrialBalanceRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FullNominalLedgerRadioMouseDown(Sender: TObject;
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
  AuditReportsForm: TAuditReportsForm;

implementation
Uses
  NomRpt,
  CashFlow,
  pickdate,
  newlisting,
  calcs,
  vars,
  types,
  NomReps,
  DBRPT;

{$R *.DFM}

procedure TAuditReportsForm.CancelButtonClick(Sender: TObject);
begin
     ModalResult := mrCancel;
end;

procedure TAuditReportsForm.FormActivate(Sender: TObject);
begin
     Caption := 'Audit Reports';{ + ' - ' + st;}
     Device[1] := 'F';
     PROG := AnnBud;
     DataBase := NlFile;
end;

procedure TAuditReportsForm.ExitClick(Sender: TObject);
begin
     Close;
end;

procedure TAuditReportsForm.FormShow(Sender: TObject);
begin
     TransListingRadio.SetFocus;
end;

procedure TAuditReportsForm.TransListingRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     TransListingRadio.Checked := True;
     NomRpt.NominalReportForm.VatPanel.Enabled := False;
     NomRpt.NominalReportForm.VatPanel.Hide;
     NomRpt.NominalReportForm.FullNominalPanel.Enabled := False;
     NomRpt.NominalReportForm.CashBookListingPanel.Enabled := False;
     NomRpt.NominalReportForm.BalanceSheetPanel.Enabled := False;
     NomRpt.NominalReportForm.TransListingPanel.Enabled := True;
     NomRpt.NominalReportForm.TrialBalancePanel.Enabled := False;
     NomRpt.NominalReportForm.BankAuditPanel.Enabled := False;
     NomRpt.NominalReportForm.TrialBalancePanel.Hide;
     NomRpt.NominalReportForm.BalanceSheetPanel.Hide;
     NomRpt.NominalReportForm.FullNominalPanel.Hide;
     NomRpt.NominalReportForm.BankAuditPanel.Hide;
     NomRpt.NominalReportForm.CashBookListingPanel.Hide;
     NomRpt.NominalReportForm.TransListingPanel.Show;
     NomRpt.NominalReportForm.Caption := 'Transaction Listing';{+ ' - ' + st;}
     NomRpt.NominalReportForm.ShowModal;
end;

procedure TAuditReportsForm.IncExpListButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    IncExpListButton.Checked := True;
    NomRpt.NominalReportForm.VatPanel.Enabled := False;
    NomRpt.NominalReportForm.VatPanel.Hide;
    NomRpt.NominalReportForm.FullNominalPanel.Enabled := False;
    NomRpt.NominalReportForm.CashBookListingPanel.Enabled := True;
    NomRpt.NominalReportForm.BalanceSheetPanel.Enabled := False;
    NomRpt.NominalReportForm.TransListingPanel.Enabled := False;
    NomRpt.NominalReportForm.TrialBalancePanel.Enabled := False;
    NomRpt.NominalReportForm.BankAuditPanel.Enabled := False;
    NomRpt.NominalReportForm.TrialBalancePanel.Hide;
    NomRpt.NominalReportForm.BalanceSheetPanel.Hide;
    NomRpt.NominalReportForm.BankAuditPanel.Hide;
    NomRpt.NominalReportForm.TransListingPanel.Hide;
    NomRpt.NominalReportForm.CashBookListingPanel.Show;
    NomRpt.NominalReportForm.Caption := 'Cashbook Income/Expenditure Listing';{+ ' - ' + st;}
    NomRpt.NominalReportForm.ShowModal;
end;

procedure TAuditReportsForm.BankAuditRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    BankAuditRadio.Checked := True;
    NomRpt.NominalReportForm.VatPanel.Enabled := False;
    NomRpt.NominalReportForm.VatPanel.Hide;
    NomRpt.NominalReportForm.FullNominalPanel.Enabled := False;
    NomRpt.NominalReportForm.CashBookListingPanel.Enabled := False;
    NomRpt.NominalReportForm.BalanceSheetPanel.Enabled := False;
    NomRpt.NominalReportForm.TransListingPanel.Enabled := False;
    NomRpt.NominalReportForm.TrialBalancePanel.Enabled := False;
    NomRpt.NominalReportForm.BankAuditPanel.Enabled := True;
    NomRpt.NominalReportForm.TrialBalancePanel.Hide;
    NomRpt.NominalReportForm.BalanceSheetPanel.Hide;
    NomRpt.NominalReportForm.FullNominalPanel.Hide;
    NomRpt.NominalReportForm.TransListingPanel.Hide;
    NomRpt.NominalReportForm.CashBookListingPanel.Hide;
    NomRpt.NominalReportForm.BankAuditPanel.Show;
    NomRpt.NominalReportForm.Caption := 'Bank Audit Trail';{+ ' - ' + st;}
    NomRpt.NominalReportForm.ShowModal;
end;

procedure TAuditReportsForm.TrialBalanceRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    TrialBalanceRadio.Checked := True;
    NomRpt.NominalReportForm.VatPanel.Enabled := False;
    NomRpt.NominalReportForm.VatPanel.Hide;
    NomRpt.NominalReportForm.TrialBalancePanel.Show;
    NomRpt.NominalReportForm.FullNominalPanel.Hide;
    NomRpt.NominalReportForm.CashBookListingPanel.Hide;
    NomRpt.NominalReportForm.BalanceSheetPanel.Hide;
    NomRpt.NominalReportForm.TransListingPanel.Hide;
    NomRpt.NominalReportForm.BankAuditPanel.Hide;
    NomRpt.NominalReportForm.FullNominalPanel.Enabled := False;
    NomRpt.NominalReportForm.CashBookListingPanel.Enabled := False;
    NomRpt.NominalReportForm.BalanceSheetPanel.Enabled := False;
    NomRpt.NominalReportForm.TransListingPanel.Enabled := False;
    NomRpt.NominalReportForm.BankAuditPanel.Enabled := False;
    NomRpt.NominalReportForm.TrialBalancePanel.Enabled := True;
    NomRpt.NominalReportForm.Caption := 'Trial Balance';{+ ' - ' + st;}
    NomRpt.NominalReportForm.ShowModal;
end;

procedure TAuditReportsForm.FullNominalLedgerRadioMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
     FullNominalLedgerRadio.Checked := True;
     NomRpt.NominalReportForm.FullNominalPanel.Enabled := True;
     NomRpt.NominalReportForm.CashBookListingPanel.Enabled := False;
     NomRpt.NominalReportForm.VatPanel.Enabled := False;
     NomRpt.NominalReportForm.VatPanel.Hide;
     NomRpt.NominalReportForm.BalanceSheetPanel.Enabled := False;
     NomRpt.NominalReportForm.TransListingPanel.Enabled := False;
     NomRpt.NominalReportForm.TrialBalancePanel.Enabled := False;
     NomRpt.NominalReportForm.BankAuditPanel.Enabled := False;
     NomRpt.NominalReportForm.TrialBalancePanel.Hide;
     NomRpt.NominalReportForm.BalanceSheetPanel.Hide;
     NomRpt.NominalReportForm.BankAuditPanel.Hide;
     NomRpt.NominalReportForm.CashBookListingPanel.Hide;
     NomRpt.NominalReportForm.TransListingPanel.Hide;
     NomRpt.NominalReportForm.FullNominalPanel.Show;
     NomRpt.NominalReportForm.Caption := 'Full Nominal Ledger Audit Trail';{+ ' - ' + st;}
     NomRpt.NominalReportForm.ShowModal;
end;

procedure TAuditReportsForm.HelpClick(Sender: TObject);
begin
     Application.HelpContext(111);
end;

procedure TAuditReportsForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If KEY = VK_F1 Then
        Application.HelpContext(111);
end;

End.
