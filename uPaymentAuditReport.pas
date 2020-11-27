unit uPaymentAuditReport;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls, AccsData;

type
  TPaymentAuditReport = class(TQuickRep)
    PageFooterBand1: TQRBand;
    KingsAccFooter: TQRLabel;
    ColumnHeaderBand1: TQRBand;
    QRLabel2: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel4: TQRLabel;
    Comment: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel8: TQRLabel;
    QRShape1: TQRShape;
    QRShape3: TQRShape;
    QRBand1: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    PageHeaderBand1: TQRBand;
    BottomLine: TQRShape;
    DataSet: TQRLabel;
    Range: TQRLabel;
    AccountsName: TQRLabel;
    Heading: TQRLabel;
    TopLine1: TQRShape;
    TopLine2: TQRShape;
    QRLabel11: TQRLabel;
    PageNumber: TQRSysData;
    DateLbl: TQRLabel;
    KingswoodLbl: TQRLabel;
    QRDBText7: TQRDBText;
    QRDBText10: TQRDBText;
  private

  public

  end;

var
  PaymentAuditReport: TPaymentAuditReport;

implementation

{$R *.DFM}

end.
