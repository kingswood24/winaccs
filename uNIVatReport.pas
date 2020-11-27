unit uNIVatReport;

// Ch006 - Added comment fields for return confirmation

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls;

type
  TNIVatReport = class(TQuickRep)
    PageHeaderBand1: TQRBand;
    SummaryBand1: TQRBand;
    PageFooterBand1: TQRBand;
    AccountsName: TQRLabel;
    TopLine1: TQRShape;
    Heading: TQRLabel;
    BottomLine: TQRShape;
    QRLabel11: TQRLabel;
    TimeLbl: TQRSysData;
    PageNumber: TQRSysData;
    KingswoodLbl: TQRLabel;
    TopLine2: TQRShape;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRShape1: TQRShape;
    SalesVatCodes: TQRMemo;
    QRMemo1: TQRMemo;
    QRMemo2: TQRMemo;
    QRMemo3: TQRMemo;
    QRMemo4: TQRMemo;
    QRMemo5: TQRMemo;
    QRMemo6: TQRMemo;
    QRMemo7: TQRMemo;
    QRMemo8: TQRMemo;
    QRMemo9: TQRMemo;
    QRMemo10: TQRMemo;
    QRMemo11: TQRMemo;
    QRMemo12: TQRMemo;
    QRMemo13: TQRMemo;
    QRMemo14: TQRMemo;
    QRMemo15: TQRMemo;
    QRMemo16: TQRMemo;
    QRMemo17: TQRMemo;
    Box1: TQRLabel;
    Box2: TQRLabel;
    Box3: TQRLabel;
    Box4: TQRLabel;
    Box5: TQRLabel;
    Box6: TQRLabel;
    Box7: TQRLabel;
    Box8: TQRLabel;
    Box9: TQRLabel;
    Comment: TQRLabel;
    DataSet: TQRLabel;
    Range: TQRLabel;
    KingsAccFooter: TQRLabel;
    CommentLabel1: TQRLabel;
    CommentLabel2: TQRLabel;
  private


  public

  
  end;

var
  NIVatReport: TNIVatReport;

implementation

{$R *.DFM}

end.
