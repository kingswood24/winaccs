unit Rptform;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Mask, ExtCtrls{, Mask, Mask, VBXCtrl, Switch};

type
  TCustSuppReportForm = class(TForm)
    GroupBox1: TGroupBox;
    CustReportsRadio: TRadioButton;
    SuppReportsRadio: TRadioButton;
    Panel1: TPanel;
    Help: TBitBtn;
    CustSuppGroupBox: TGroupBox;
    AccountListingRadio: TRadioButton;
    AgeOfDebtRadio: TRadioButton;
    InvoiceListingRadio: TRadioButton;
    PaymentReceiptListingRadio: TRadioButton;
    CreditNoteListingRadio: TRadioButton;
    Exit: TBitBtn;
    TxControlSummaryRadio: TRadioButton;
    GroupBox2: TGroupBox;
    StatementRadio: TRadioButton;
    RecordRadio: TRadioButton;
    LedgerRadio: TRadioButton;
    Bevel2: TBevel;
    Bevel1: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    procedure CancelButtonClick(Sender: TObject);
    procedure SuppReportsRadioClick(Sender: TObject);
    procedure CustReportsRadioClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AccountListingRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AgeOfDebtRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure InvoiceListingRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaymentReceiptListingRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CreditNoteListingRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TxControlSummaryRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure StatementRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LedgerRadioMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RecordRadioMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
  CustSuppReportForm: TCustSuppReportForm;

implementation
Uses
  StmRep,
  RcsInv,
  RcsList,
  pickdate,
  newlisting,
  calcs,
  vars,
  types,
  DBRPT,
  Stat;

{$R *.DFM}

procedure TCustSuppReportForm.CancelButtonClick(Sender: TObject);
begin
     ModalResult := mrCancel;
end;

procedure TCustSuppReportForm.SuppReportsRadioClick(Sender: TObject);
Begin
     CustSuppGroupBox.Caption := 'Supplier';
     CustSuppReportForm.Caption := 'Supplier Reports';{ + ' - ' + st;}
     PROG := SuppRep;
     DataBase := PlFile;
end;

procedure TCustSuppReportForm.CustReportsRadioClick(Sender: TObject);
Begin
     CustSuppGroupBox.Caption := 'Customer';
     CustSuppReportForm.Caption := 'Customer Reports';{ + ' - ' + st;}
     PROG := CustRep;
     DataBase := SlFile;
end;

procedure TCustSuppReportForm.FormActivate(Sender: TObject);
Begin
     caption := 'Customer Reports';{ + ' - ' + st;}
     Device[1] := 'F';
     PROG := CustRep;
     DataBase := SlFile;
end;

procedure TCustSuppReportForm.FormShow(Sender: TObject);
begin
     CustReportsRadio.SetFocus;
end;

procedure TCustSuppReportForm.AccountListingRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    AccountListingRadio.Checked := True;
    RcsList.CustSuppListing.Caption := 'Account Listing';{ + ' - ' + st;}
    RcsList.CustSuppListing.ShowModal;
end;

procedure TCustSuppReportForm.AgeOfDebtRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     AgeOfDebtRadio.Checked := True;
     RcsList.CustSuppListing.Caption := 'Age Of Debt';{ + ' - ' + st;}
     RcsList.CustSuppListing.ShowModal;
end;

procedure TCustSuppReportForm.InvoiceListingRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    InvoiceListingRadio.Checked := True;
    RcsInv.CustSuppInvListing.Caption := 'Invoice Listing';{ + ' - ' + st;}
    RcsInv.CustSuppInvListing.ShowModal;
end;

procedure TCustSuppReportForm.PaymentReceiptListingRadioMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
     PaymentReceiptListingRadio.Checked := True;
     if CustReportsRadio.Checked then
        RcsInv.CustSuppInvListing.Caption := 'Payment Listing'{ + ' - ' + st}
     else
        RcsInv.CustSuppInvListing.Caption := 'Payment Listing';{ + ' - ' + st;}
        RcsInv.CustSuppInvListing.ShowModal;
end;

procedure TCustSuppReportForm.CreditNoteListingRadioMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
     CreditNoteListingRadio.Checked := True;
     RcsInv.CustSuppInvListing.Caption := 'Credit Note Listing';{ + ' - ' + st;}
     RcsInv.CustSuppInvListing.ShowModal;
end;

procedure TCustSuppReportForm.TxControlSummaryRadioMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
     TxControlSummaryRadio.Checked := True;
     RcsInv.CustSuppInvListing.Caption := 'Transaction Summary';{ + ' - ' + st;}
     RcsInv.CustSuppInvListing.ShowModal;
end;

procedure TCustSuppReportForm.StatementRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     StatementRadio.Checked := True;
     Stat.StatementForm.Caption := 'Statements';{ + ' - ' + st;}
     Stat.StatementForm.ShowModal;
end;

procedure TCustSuppReportForm.LedgerRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     LedgerRadio.Checked := True;
     Stat.StatementForm.Caption := 'Ledger Cards';{ + ' - ' + st;}
     Stat.StatementForm.ShowModal;
end;

procedure TCustSuppReportForm.RecordRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     RecordRadio.Checked := True;
     Stat.StatementForm.Caption := 'Record Cards';{ + ' - ' + st;}
     Stat.StatementForm.ShowModal;
end;

procedure TCustSuppReportForm.HelpClick(Sender: TObject);
begin
     Application.HelpContext(109);
end;

procedure TCustSuppReportForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Key = VK_F1 Then
        Application.HelpContext(109);
end;

End.
