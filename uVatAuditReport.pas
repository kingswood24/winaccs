unit uVatAuditReport;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls, AccsData;

type
  TVatAuditReport = class(TQuickRep)
    PageHeaderBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    BottomLine: TQRShape;
    KingswoodLbl: TQRLabel;
    TimeLbl: TQRSysData;
    PageNumber: TQRSysData;
    Heading: TQRLabel;
    TopLine1: TQRShape;
    TopLine2: TQRShape;
    QRShape1: TQRShape;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel4: TQRLabel;
    Comment: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    PageFooterBand1: TQRBand;
    QRLabel8: TQRLabel;
    QRDBText1: TQRDBText;
    QRShape2: TQRShape;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    AccountsName: TQRLabel;
    QRLabel11: TQRLabel;
    Range: TQRLabel;
    DataSet: TQRLabel;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText13: TQRDBText;
    QRDBText14: TQRDBText;
    QRDBText15: TQRDBText;
    KingsAccFooter: TQRLabel;
  private

  public

  end;

var
  VatAuditReport: TVatAuditReport;

implementation

{$R *.DFM}

end.
