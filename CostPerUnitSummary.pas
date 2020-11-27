unit CostPerUnitSummary;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls;

type
  TCostPerUnitSummaryReport = class(TQuickRep)
    PageHeaderBand1: TQRBand;
    PageFooterBand1: TQRBand;
    BottomLine: TQRShape;
    KingswoodLbl: TQRLabel;
    ReportDatelabel: TQRLabel;
    QRLabel1: TQRLabel;
    dataset: TQRLabel;
    AccountsName: TQRLabel;
    TimeLbl: TQRSysData;
    PageNumber: TQRSysData;
    Heading: TQRLabel;
    TopLine2: TQRShape;
    QRShape1: TQRShape;
    TitleBand1: TQRBand;
    Header: TQRLabel;
    EnterpriseLabel: TQRLabel;
    QRLabel2: TQRLabel;
    UnitNameLabel: TQRLabel;
    NoUnitsLabel: TQRLabel;
    QRLabel3: TQRLabel;
    QRShape2: TQRShape;
    QRLabel5: TQRLabel;
    PerUnitLbl: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    IncTotalLbl: TQRLabel;
    IncUnitLbl: TQRLabel;
    ExpTotalLbl: TQRLabel;
    ExpUnitLbl: TQRLabel;
    GrossUnitLbl: TQRLabel;
    GrossTotalLbl: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    OverheadsLbl: TQRLabel;
    OverTotalLbl: TQRLabel;
    ProdTotalLbl: TQRLabel;
    NetTotalLbl: TQRLabel;
    OverUnitLbl: TQRLabel;
    NetUnitLbl: TQRLabel;
    ProdUnitLbl: TQRLabel;
    GrossMarginPercentLbl: TQRLabel;
    NetMarginPercentLbl: TQRLabel;
    DairyLbl1: TQRLabel;
    DairyLbl2: TQRLabel;
    LitresMilkUnit: TQRLabel;
    kgMilkUnit: TQRLabel;
    TotalLitres: TQRLabel;
    TotalSolids: TQRLabel;
    PerLitreLabel: TQRLabel;
    PerKgLabel: TQRLabel;
    ExpPerLitre: TQRLabel;
    IncPerLitre: TQRLabel;
    GrossPerLitre: TQRLabel;
    OverPerLitre: TQRLabel;
    ProdPerLitre: TQRLabel;
    MarginPerLitre: TQRLabel;
    IncPerKg: TQRLabel;
    ExpPerKg: TQRLabel;
    GrossPerKg: TQRLabel;
    OverPerKg: TQRLabel;
    ProdPerKg: TQRLabel;
    MarginPerKg: TQRLabel;
    FilterLabel: TQRLabel;
    KingsAccFooter: TQRLabel;
  private

  public
      Procedure RunReport;
  end;

var
  CostPerUnitSummaryReport: TCostPerUnitSummaryReport;

implementation

{$R *.DFM}

procedure TCostPerUnitSummaryReport.RunReport;
begin
    preview;
end;

end.
