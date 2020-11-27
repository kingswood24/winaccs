unit Mainrpts;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Comctrls;

type
  TReports = class(TForm)
    Panel1: TPanel;
    Exit: TBitBtn;
    Help: TBitBtn;
    BitBtn1: TBitBtn;
    CustSuppReportsRadio: TRadioButton;
    EntReportRadio: TRadioButton;
    AuditReportRadio: TRadioButton;
    VatRadio: TRadioButton;
    CashFlowMainRadio: TRadioButton;
    Bevel1: TBevel;
    procedure VatRadioClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CustSuppReportsRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EntReportRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AuditReportRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure VatRadioMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CashFlowMainRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Reports: TReports;

implementation
Uses
    NomRpt,
    Vars,
    Types,
    CashRpts,
    SpRepA,
    NlReps,
    NomReps,
    AuditRpt,
    PrintSet,
    RptForm;

{$R *.DFM}

Procedure NotImplementedYet;
Begin
     MessageDlg('NOT Available', mtInformation,[mbOK], 0)
End;

procedure TReports.VatRadioClick(Sender: TObject);
begin
     (*
     PROG := CUSTREP;
     Rep ( 11, 0 );
     }
     PROG := SPECREP;
     NomReports ( 8, 0 );
     {
     PROG := SUPPREP;
     Rep ( 11, 0 );
     }
     *)

end;

procedure TReports.FormActivate(Sender: TObject);
Begin
     caption := 'Reports';{ + ' - ' + st;}
     Device := 'F';
end;

procedure TReports.BitBtn1Click(Sender: TObject);
begin
     PrintForm.ShowModal;
end;

procedure TReports.FormShow(Sender: TObject);
begin
     If Cash1.xCashbook Then
        CustSuppReportsRadio.Hide
     Else
        CustSuppReportsRadio.Show;
     If Cash11.xUse_Enterprise Then
        EntReportRadio.Hide
     Else
         EntReportRadio.Show;
     // Check which button can be focused on
     If CustSuppReportsRadio.CanFocus Then
        CustSuppReportsRadio.SetFocus
     else If EntReportRadio.CanFocus Then
        EntReportRadio.SetFocus
     else AuditReportRadio.SetFocus;

     if Cash11.Xuse_vat then
        VATRadio.hide
     else
        VATRadio.Show;
end;

procedure TReports.CustSuppReportsRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     CustSuppReportForm.ShowModal;
end;

procedure TReports.EntReportRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     EntReportForm.ShowModal;
end;

procedure TReports.AuditReportRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     AuditReportsForm.ShowModal;
end;

procedure TReports.VatRadioMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     VatRadio.Checked := True;
     NomRpt.NominalReportForm.FullNominalPanel.Enabled := False;
     NomRpt.NominalReportForm.CashBookListingPanel.Enabled := False;
     NomRpt.NominalReportForm.VatPanel.Enabled := True;
     NomRpt.NominalReportForm.BalanceSheetPanel.Enabled := False;
     NomRpt.NominalReportForm.TransListingPanel.Enabled := False;
     NomRpt.NominalReportForm.TrialBalancePanel.Enabled := False;
     NomRpt.NominalReportForm.BankAuditPanel.Enabled := False;
     NomRpt.NominalReportForm.TrialBalancePanel.Hide;
     NomRpt.NominalReportForm.BalanceSheetPanel.Hide;
     NomRpt.NominalReportForm.BankAuditPanel.Hide;
     NomRpt.NominalReportForm.CashBookListingPanel.Hide;
     NomRpt.NominalReportForm.TransListingPanel.Hide;
     NomRpt.NominalReportForm.FullNominalPanel.Hide;
     NomRpt.NominalReportForm.VatPanel.Show;
     NomRpt.NominalReportForm.Caption := 'VAT Report';{ + ' - ' + st;}
     NomRpt.NominalReportForm.ShowModal;
end;

procedure TReports.CashFlowMainRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     CashFlowMainForm.ShowModal;
end;

procedure TReports.HelpClick(Sender: TObject);
begin
     Application.HelpContext(180);
end;

procedure TReports.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Key = VK_F1 then
        Application.HelpContext(180);        
end;

end.
