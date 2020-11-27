unit uVatReport;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls;

type
  TVatReport = class(TQuickRep)
    PageHeaderBand1: TQRBand;
    BottomLine: TQRShape;
    PageNumber: TQRSysData;
    TimeLbl: TQRSysData;
    TopLine2: TQRShape;
    Heading: TQRLabel;
    TopLine1: TQRShape;
    PageFooterBand1: TQRBand;
    SummaryBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    SalesVatAmounts: TQRMemo;
    SalesNetAmounts: TQRMemo;
    SalesVatRates: TQRMemo;
    QRLabel6: TQRLabel;
    QRShape2: TQRShape;
    QRShape1: TQRShape;
    SalesVatCodes: TQRMemo;
    SalesTotalNet: TQRLabel;
    SalesTotalVat: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    PurchVatRates: TQRMemo;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    PurchNetAmounts: TQRMemo;
    PurchTotalNet: TQRLabel;
    QRLabel12: TQRLabel;
    PurchTotalVat: TQRLabel;
    PurchVatAmounts: TQRMemo;
    QRLabel14: TQRLabel;
    QRShape4: TQRShape;
    QRShape5: TQRShape;
    PurchVatCodes: TQRMemo;
    QRLabel11: TQRLabel;
    AccountsName: TQRLabel;
    DataSet: TQRLabel;
    Range: TQRLabel;
    KingswoodLbl: TQRLabel;
    QRLabel13: TQRLabel;
  private

  public

  end;

var
  VatReport: TVatReport;

implementation


{$R *.DFM}

end.
