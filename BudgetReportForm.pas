unit BudgetReportForm;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls;

type
  TBudgetReport = class(TQuickRep)
    PageHeaderBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    TopLine1: TQRShape;
    Heading: TQRLabel;
    TopLine2: TQRShape;
    BottomLine: TQRShape;
    TimeLbl: TQRSysData;
    PageNumber: TQRSysData;
    KingswoodLbl: TQRLabel;
    NominalLabel: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRShape1: TQRShape;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    PageFooterBand1: TQRBand;
    QRDBText12: TQRDBText;
    QRDBText13: TQRDBText;
    QRDBText14: TQRDBText;
    QRDBText15: TQRDBText;
    QRLabel14: TQRLabel;
    QRLabel15: TQRLabel;
    Actuallbl1: TQRDBText;
    actuallbl2: TQRDBText;
    actuallbl3: TQRDBText;
    actuallbl4: TQRDBText;
    actuallbl5: TQRDBText;
    actuallbl6: TQRDBText;
    actuallbl7: TQRDBText;
    actuallbl8: TQRDBText;
    actuallbl9: TQRDBText;
    actuallbl10: TQRDBText;
    actuallbl11: TQRDBText;
    actuallbl12: TQRDBText;
    ActualYear: TQRDBText;
    LastYearLabel: TQRLabel;
    QRDBText29: TQRDBText;
    QRDBText30: TQRDBText;
    QRDBText31: TQRDBText;
    QRDBText32: TQRDBText;
    QRDBText33: TQRDBText;
    QRDBText34: TQRDBText;
    QRDBText35: TQRDBText;
    QRDBText36: TQRDBText;
    QRDBText37: TQRDBText;
    QRDBText38: TQRDBText;
    QRDBText39: TQRDBText;
    QRDBText40: TQRDBText;
    QRDBText41: TQRDBText;
    SummaryBand1: TQRBand;
    QRLabel16: TQRLabel;
    KingsAccFooter: TQRLabel;
  private

  public

  end;

var
  BudgetReport: TBudgetReport;

implementation

uses accsdata;
{$R *.DFM}

end.
