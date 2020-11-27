unit uVATAuditTrailReport;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls, Types;

type
  TQuickRep1 = class(TQuickRep)
    TitleBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    TopLine1: TQRShape;
    TopLine2: TQRShape;
    Heading: TQRLabel;
    TimeLbl: TQRSysData;
    PageNumber: TQRSysData;
    BottomLine: TQRShape;
    PageFooterBand1: TQRBand;
    DataSet: TQRLabel;
    Range: TQRLabel;
    KingswoodLbl: TQRLabel;
    AccountsName: TQRLabel;
    KingsAccFooter: TQRLabel;
  private

  public
     Procedure ShowReport;
  end;

var
  QuickRep1: TQuickRep1;

implementation

{$R *.DFM}

Procedure TQuickRep1.ShowReport;
begin
          KingswoodLbl.caption := 'Kingswood Accounts ' + VerNo;
          QuickRep1.preview;
end;

end.
