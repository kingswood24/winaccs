unit uPaymentVATReport;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls;

type
  TPaymentVATReport = class(TQuickRep)
    DetailBand1: TQRBand;
    PageFooterBand1: TQRBand;
    PageHeaderBand1: TQRBand;
    Range: TQRLabel;
    DataSet: TQRLabel;
    AccountsName: TQRLabel;
    TopLine1: TQRShape;
    Heading: TQRLabel;
    TopLine2: TQRShape;
    QRLabel11: TQRLabel;
    PageNumber: TQRSysData;
    KingswoodLbl: TQRLabel;
    BottomLine: TQRShape;
    DateLbl: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    SalesBefore: TQRLabel;
    SalesVAT: TQRLabel;
    SalesTotal: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel12: TQRLabel;
    PurchaseTotal: TQRLabel;
    PurchaseVAT: TQRLabel;
    PurchaseBefore: TQRLabel;
    KingsAccFooter: TQRLabel;
  private

  public

  end;

var
  PaymentVATReport: TPaymentVATReport;

implementation

{$R *.DFM}

end.
