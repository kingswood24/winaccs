unit JobCardReports;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, QuickRpt, ExtCtrls;

type
  TJobCardReportForm = class(TForm)
    QuickRep1: TQuickRep;
    PageHeaderBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    PageFooterBand1: TQRBand;
    Heading: TQRLabel;
    TopLine2: TQRShape;
    TopLine1: TQRShape;
    BottomLine: TQRShape;
    KingswoodLbl: TQRLabel;
    TimeLbl: TQRSysData;
    PageNumber: TQRSysData;
    QRDBText1: TQRDBText;
    QRLabel1: TQRLabel;
    QRDBText2: TQRDBText;
    QRLabel2: TQRLabel;
    QRDBText3: TQRDBText;
    QRLabel3: TQRLabel;
    QRShape1: TQRShape;
    QRDBText4: TQRDBText;
    QRShape2: TQRShape;
    Comment: TQRLabel;
    QRDBText5: TQRDBText;
    ref: TQRDBText;
    QRLabel4: TQRLabel;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRBand1: TQRBand;
    SummaryTotalAmount: TQRLabel;
    SummaryAmount: TQRLabel;
    QRLabel7: TQRLabel;
    SummaryTAXAmount: TQRLabel;
    RangeLabel: TQRLabel;
    SubHeading: TQRLabel;
    QRLabel8: TQRLabel;
    KingsAccFooter: TQRLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure BuildReport(ReportType : Char);
  end;

var
  JobCardReportForm: TJobCardReportForm;

implementation

Uses
    CashBook, Types, AccsData;

{$R *.DFM}

Procedure TJobCardReportForm.BuildReport(ReportType : Char);
// report type P - proforma
//             J - Job cards
//             Q - Quotes

begin

          If ReportType = 'Q' then Heading.caption := 'Quotations Outstanding'
             else If ReportType = 'P' then Heading.caption := 'Incomplete Proforma Invoices'
                  else Heading.caption := 'Incomplete Job Cards';
          KingswoodLbl.caption := 'Kingswood Accounts ' + VerNo;
          QuickRep1.preview;



end;

end.
