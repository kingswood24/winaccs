unit AnalysisReports;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls;

type
  TAnalysisReport = class(TQuickRep)
    PageHeaderBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    PageFooterBand1: TQRBand;
    TopLine1: TQRShape;
    Heading: TQRLabel;
    TopLine2: TQRShape;
    TimeLbl: TQRSysData;
    PageNumber: TQRSysData;
    KingswoodLbl: TQRLabel;
    BottomLine: TQRShape;
    DetailBand1: TQRBand;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText9: TQRDBText;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRDBText3: TQRDBText;
    QRLabel6: TQRLabel;
    QRDBText5: TQRDBText;
    KingsAccFooter: TQRLabel;
  private

  public
  procedure PreviewReport;
  end;

var
  AnalysisReport: TAnalysisReport;

implementation

{$R *.DFM}

uses accsdata, Types;

procedure TAnalysisReport.PreviewReport;
begin
    with AnalysisReport do begin
         KingswoodLbl.caption := 'Kingswood Accounts ' + VerNo;
         preview;
    end;
end;

end.
