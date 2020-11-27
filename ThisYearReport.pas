unit ThisYearReport;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls,AccsData;

type
  TThisYearReportForm = class(TQuickRep)
    PageHeaderBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    PageFooterBand1: TQRBand;
    Heading: TQRLabel;
    TopLine1: TQRShape;
    TopLine2: TQRShape;
    BottomLine: TQRShape;
    KingswoodLbl: TQRLabel;
    PageNumber: TQRSysData;
    QRLabel1: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRShape1: TQRShape;
    DateLabel: TQRLabel;
    KingsAccFooter: TQRLabel;
  private

  public

  end;

var
  ThisYearReportForm: TThisYearReportForm;

implementation

{$R *.DFM}

end.
