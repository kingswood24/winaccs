{
   22/02/17 [V4.2 R6.4] /MK Change - Layout of report changed to allow for new layout changes - GL request.

   02/11/18 [V4.3 R2.6] /MK Additional Feature - Added the Kingswood Accounts (C) Kingswood Computing footer to bottom of the invoice as is on all report - GL request.
}

unit InvoiceReport;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
     StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls, Db, DBTables, jpeg,
     QRExport, Dialogs;

type
  TInvoiceReportForm = class(TQuickRep)
    PageHeader: TQRBand;
    QRLabel1: TQRLabel;
    QRShape3: TQRShape;
    QRSysData1: TQRSysData;
    QRLabel2: TQRLabel;
    QRShape4: TQRShape;
    QRBand: TQRBand;
    DescriptionDBText: TQRDBText;
    EachDBText: TQRDBText;
    QtyDBText: TQRDBText;
    TotalDBText: TQRDBText;
    FromName: TQRLabel;
    Address1: TQRLabel;
    Address2: TQRLabel;
    Address3: TQRLabel;
    Address4: TQRLabel;
    Address5: TQRLabel;
    TelLabel: TQRLabel;
    Tel1: TQRLabel;
    Tel2: TQRLabel;
    FaxLabel: TQRLabel;
    Fax: TQRLabel;
    MobileLabel: TQRLabel;
    Mobile: TQRLabel;
    EMailLabel: TQRLabel;
    Email: TQRLabel;
    WebLabel: TQRLabel;
    Web: TQRLabel;
    QRLabel13: TQRLabel;
    Date: TQRLabel;
    InvoiceNumber: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel14: TQRLabel;
    QRShape1: TQRShape;
    ToName: TQRLabel;
    ToAddress1: TQRLabel;
    ToAddress2: TQRLabel;
    ToAddress3: TQRLabel;
    ToAddress4: TQRLabel;
    VATDBText: TQRDBText;
    TotalIncVATDBText: TQRDBText;
    QRShape2: TQRShape;
    VATNumberLabel: TQRLabel;
    VATNumber: TQRLabel;
    Line1DBText: TQRDBText;
    Line2DBText: TQRDBText;
    Line3DBText: TQRDBText;
    LineDateDBText: TQRDBText;
    LineRefDBText: TQRDBText;
    EachIncVATDBtext: TQRDBText;
    HeaderImage: TQRImage;
    QRShape5: TQRShape;
    CompanyRegLabel: TQRLabel;
    CompanyReg: TQRLabel;
    DescriptionLabel: TQRLabel;
    LinedateLabel: TQRLabel;
    LineRefLabel: TQRLabel;
    DetailsLabel: TQRLabel;
    QtyLabel: TQRLabel;
    EachLabel: TQRLabel;
    TotalLabel: TQRLabel;
    VATRateLabel: TQRLabel;
    VATLabel: TQRLabel;
    TotalIncVATLabel: TQRLabel;
    QRShape6: TQRShape;
    QRShape8: TQRShape;
    Summary: TQRBand;
    RTotIncVat: TQRLabel;
    RTotVAT: TQRLabel;
    RTotExcVAT: TQRLabel;
    QRLabel18: TQRLabel;
    QRLabel19: TQRLabel;
    QRLabel20: TQRLabel;
    RemittanceBox1: TQRShape;
    RAccountNumber: TQRLabel;
    RName: TQRLabel;
    RAddress1: TQRLabel;
    RAddress2: TQRLabel;
    RAddress3: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel8: TQRLabel;
    RemittanceComment: TQRLabel;
    PageFooter: TQRBand;
    QRShape9: TQRShape;
    ToAddress5: TQRLabel;
    ChildBand1: TQRChildBand;
    VatAnalysisLabel: TQRLabel;
    FooterLine1: TQRShape;
    EuroLabel: TQRLabel;
    TotalQuantLabel: TQRLabel;
    SumQuantity: TQRLabel;
    TotalIncVATLabel1: TQRLabel;
    TotalVATLabel1: TQRLabel;
    TotExcVATLabel1: TQRLabel;
    QRShape7: TQRShape;
    TotExcVAT: TQRLabel;
    TotVAT: TQRLabel;
    TotIncVAT: TQRLabel;
    RemittanceLine1: TQRShape;
    VATRateDBText: TQRDBText;
    CommentLabel: TQRLabel;
    VatCodeRateLabel: TQRLabel;
    AmountTableLabel: TQRLabel;
    VatTableLabel: TQRLabel;
    EuroAmountTableLabel: TQRLabel;
    EuroVatTableLabel: TQRLabel;
    KingsAccFooter: TQRLabel;
    procedure ChildBand1BeforePrint(Sender: TQRCustomBand; var PrintBand: Boolean);
  private

  public

  end;

var
  InvoiceReportForm: TInvoiceReportForm;

implementation
uses AccsData;

{$R *.DFM}

procedure TInvoiceReportForm.ChildBand1BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
   try
      PrintBand := ( (TQuickRep(Sender.Parent).RecordNumber) = Accsdatamodule.InvoiceReportTable.RecordCount );
   finally

   end;
end;

end.
