unit Rcsinv;
{
Form to Run Reports Invoice, Payment & Credit Note Listing Reports
}
interface
        
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, Mask, NewClass, ComCtrls;

type
  TCustSuppInvListing = class(TKingForm)
    CustSuppPanel: TPanel;
    RepDate1: TEdit;
    AccFrom: TEdit;
    AccTo: TEdit;
    ReportDate: TLabel;
    AccFromLabel: TLabel;
    AccToLabel: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Help: TBitBtn;
    Run: TBitBtn;
    TxFrom: TEdit;
    Exit: TBitBtn;
    IncludeBreakDown: TCheckBox;
    Label4: TLabel;
    TxTo: TEdit;
    DateTo1: TEdit;
    DateFrom1: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Panel2: TPanel;
    VReports: TRadioButton;
    PReports: TRadioButton;
    CustAccounts: TSpeedButton;
    SpeedButton1: TSpeedButton;
    DateFrom: TMaskEdit;
    DateTo: TMaskEdit;
    DateSearchFrom: TDateTimePicker;
    DateSearchTo: TDateTimePicker;
    RepDate: TMaskEdit;
    RepDateSearch: TDateTimePicker;
    procedure RunClick(Sender: TObject);
    procedure RepDate1Enter(Sender: TObject);
    procedure AccFromKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AccToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TxFromExit(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TxToExit(Sender: TObject);
    procedure AccFromExit(Sender: TObject);
    procedure AccToExit(Sender: TObject);
    procedure DateFrom1Exit(Sender: TObject);
    procedure DateTo1Exit(Sender: TObject);
    procedure VReportsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CustAccountsClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure DateFromExit(Sender: TObject);
    procedure DateFromEnter(Sender: TObject);
    procedure DateSearchFromCloseUp(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DateToEnter(Sender: TObject);
    procedure DateToExit(Sender: TObject);
    procedure DateSearchToCloseUp(Sender: TObject);
    procedure RepDateSearchCloseUp(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CustSuppInvListing: TCustSuppInvListing;

implementation
Uses
    pickdate,
    DBCore,
    newlisting,
    vars,
    types,
    Calcs,
    SPREPA,
    NewRepUnit, AccsData;

{$R *.DFM}

procedure TCustSuppInvListing.RunClick(Sender: TObject);
Var IntFrom : Integer;
    IntTo : Integer;
begin
     REPXDATE := RepDate.Text;
     IntFrom := StrToInt(AccFrom.Text);
     IntTo := StrToInt(AccTo.Text);

     If ((DateFrom.Text) <> '  /  /  ' )and((DateTo.Text) <> '  /  /  ' ) Then
        Begin
             DateFrom.SetFocus;
             DateTo.SetFocus;
             DateFrom.SetFocus;
        End;

     If ( IntTo < IntFrom ) OR ( IntTo = 0 ) OR ( IntFrom = 0 ) Then
        AccTo.SetFocus
     Else
     If ( Act = 5 ) Then// CustSuppReportForm.InvoiceListingRadio.Checked
        Rep ( 5, NewRepForm.DataBase )
     Else If ( Act = 6 ) Then// CustSuppReportForm.PaymentReceiptListingRadio.Checked
        Rep ( 6, NewRepForm.DataBase )
     Else If ( Act = 7 ) Then// CustSuppReportForm.CreditNoteListingRadio.Checked
        Rep ( 7, NewRepForm.DataBase )
     Else If ( Act = 8 ) Then// CustSuppReportForm.TxControlSummaryRadio.Checked
        Rep ( 8, NewRepForm.DataBase );
end;

procedure TCustSuppInvListing.RepDate1Enter(Sender: TObject);
begin
     RepDate.Text := Cash1.xDate;
end;

procedure TCustSuppInvListing.AccFromKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
          If NewRepForm.CustRadio.Checked Then
             NewListBox.ListIt ( Sender, Customers, 'C' )
          Else
             NewListBox.ListIt ( Sender, Suppliers, 'S' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            AccFrom.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TCustSuppInvListing.AccToKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
          If NewRepForm.CustRadio.Checked Then
             NewListBox.ListIt ( Sender, Customers, 'C' )
          Else
             NewListBox.ListIt ( Sender, Suppliers, 'S' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            AccTo.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TCustSuppInvListing.TxFromExit(Sender: TObject);
begin
     If NOT Numeric ( TxFrom.Text ) Then
        TxFrom.SetFocus;
end;

procedure TCustSuppInvListing.ExitClick(Sender: TObject);
begin
     Close;
end;

procedure TCustSuppInvListing.FormActivate(Sender: TObject);
Begin
     Panel2.Visible := not NewRepForm.NewReports.Checked;
     If Device = 'P' Then
        PReports.Checked := True
     Else
         VReports.Checked := True;

     RepDate.Text := Cash1.xDate;
     TxDateFrom := CDateFrom;
     TxDateTo   := CDateTo;
     AccFromLabel.Visible := True;
     AccToLabel.Visible := True;
     AccFrom.Visible := True;
     AccTo.Visible := True;
     CustAccounts.Visible := True;
     SpeedButton1.Visible := True;

     SetDb ( TxFile );
     TxFrom.Text := '1';
     TxTo.Text   := IntToStr ( db1.dbrechigh );
     SetDb ( NewRepForm.DataBase );
     AccFrom.Text := '1';
     AccTo.Text   := IntToStr ( db1.dbrechigh );

     If ( Act = 5 ) Or //( CustSuppReportForm.InvoiceListingRadio.Checked )
        ( Act = 7 ) Then//( CustSuppReportForm.CreditNoteListingRadio.Checked )
        IncludeBreakDown.Visible := True
     Else
         IncludeBreakDown.Hide;
     If ( ACt = 8 ) Then// ( CustSuppReportForm.TxControlSummaryRadio.Checked )
        Begin
             AccFrom.Hide;
             AccTo.Hide;
             AccFromLabel.Hide;
             AccToLabel.Hide;
             CustAccounts.Hide;
             SpeedButton1.Hide;
        End;
end;

procedure TCustSuppInvListing.TxToExit(Sender: TObject);
begin
     If NOT Numeric ( TxTo.Text ) Then
        TxTo.SetFocus
     Else
         If ( StrToInt ( TxTo.Text ) < StrToInt ( TxFrom.Text )) Then
            TxTo.SetFocus;
end;

procedure TCustSuppInvListing.AccFromExit(Sender: TObject);
begin
     If NOT Numeric ( AccFrom.Text ) Then
        AccFrom.SetFocus;
end;

procedure TCustSuppInvListing.AccToExit(Sender: TObject);
begin
     If NOT Numeric ( AccTo.Text ) Then
        AccTo.SetFocus
     Else
         If ( StrToInt ( AccTo.Text ) < StrToInt ( AccFrom.Text )) Then
            AccTo.SetFocus;
end;

procedure TCustSuppInvListing.DateFrom1Exit(Sender: TObject);
begin
     KDateFromExit ( Sender, Report );
end;

procedure TCustSuppInvListing.DateTo1Exit(Sender: TObject);
begin
     KDateToExit ( Sender, Report );
{     If Length ( DateTo.Text ) <> 0  Then
        If NOT DateValid ( DateTo.Text, TDateFormat ) Then
           DateTo.SetFocus
        Else
            Begin
                 TxDateTo := Trunc ( DayTot-32000 );
                 If TxDateTo < TxDateFrom Then
                    DateFrom.SetFocus;
            End;}
end;

procedure TCustSuppInvListing.VReportsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     KPrinterOrScreen(Sender, Button, Shift, x, y );
end;

procedure TCustSuppInvListing.CustAccountsClick(Sender: TObject);
begin
          If NewRepForm.CustRadio.Checked Then
             NewListBox.ListIt ( Sender, Customers, 'C' )
          Else
             NewListBox.ListIt ( Sender, Suppliers, 'S' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            AccFrom.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TCustSuppInvListing.SpeedButton1Click(Sender: TObject);
begin
          If NewRepForm.CustRadio.Checked Then
             NewListBox.ListIt ( Sender, Customers, 'C' )
          Else
             NewListBox.ListIt ( Sender, Suppliers, 'S' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            AccTo.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TCustSuppInvListing.DateFromExit(Sender: TObject);
begin
     KDateFromExit ( Sender, Report );
end;

procedure TCustSuppInvListing.DateFromEnter(Sender: TObject);
begin
(*     If NOT DateValid ( MaskDateFrom.Text, TDateFormat ) Then
        Begin
             MaskDateFrom.Text := Cash11.Default_Date;{XDate;}
        End;
*)
end;

procedure TCustSuppInvListing.DateSearchFromCloseUp(Sender: TObject);
Var St : Shortstring;
begin
     DateFrom.Text:= DateToStr(DateSearchFrom.Date);
     DateFrom.SetFocus;
end;

procedure TCustSuppInvListing.FormShow(Sender: TObject);
begin
     RepDateSearch.Date := KStrToDate (Cash11.Default_Date);
     DateSearchFrom.Date := KStrToDate (Cash11.Default_Date);
     DateSearchTo.Date := KStrToDate (Cash11.Default_Date);
end;

procedure TCustSuppInvListing.DateToEnter(Sender: TObject);
begin
(*     If NOT DateValid ( MaskDateTo.Text, TDateFormat ) Then
        Begin
             MaskDateTo.Text := Cash11.Default_Date;{XDate;}
        End;*)
end;

procedure TCustSuppInvListing.DateToExit(Sender: TObject);
begin
     KDateToExit ( Sender, Report );
{     DateTo.Text := MaskDateTo.Text;}
end;

procedure TCustSuppInvListing.DateSearchToCloseUp(Sender: TObject);
begin
     DateTo.Text:= DateToStr(DateSearchTo.Date);
     DateTo.SetFocus;
end;

procedure TCustSuppInvListing.RepDateSearchCloseUp(Sender: TObject);
begin
     RepDate.Text:= DateToStr(RepDateSearch.Date);
     RepDate.SetFocus;
end;

procedure TCustSuppInvListing.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     DateFrom.Text := '  /  /  ';
     DateTO.Text := '  /  /  ';
end;

procedure TCustSuppInvListing.HelpClick(Sender: TObject);
begin
     If ( Act = 5 ) Then //CustSuppReportForm.InvoiceListingRadio.Checked
        //Application.HelpContext(147)
          AccsDataModule.HTMLHelp('invoiceListing.htm')
     Else If ( Act = 6 ) Then//CustSuppReportForm.PaymentReceiptListingRadio.Checked
          //Application.HelpContext(148)
            AccsDataModule.HTMLHelp('payment.htm')
     Else If ( Act = 7 ) Then//CustSuppReportForm.CreditNoteListingRadio.Checked
          //Application.HelpContext(149)
             AccsDataModule.HTMLHelp('creditNoteListings.htm')
     Else If ( Act = 7 ) Then//CustSuppReportForm.TxControlSummaryRadio.Checked
          //Application.HelpContext(150)
           AccsDataModule.HTMLHelp('transactionSummary.htm')
          ;
end;

end.
