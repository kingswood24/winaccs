unit UAgeOfDebtReport;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls, Types, AccsData, vars;

type
  TAgeOfDebtReport = class(TQuickRep)
    PageHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    SummaryBand1: TQRBand;
    TopLine1: TQRShape;
    AccsName: TQRLabel;
    Heading: TQRLabel;
    QRLabel11: TQRLabel;
    PageNumber: TQRSysData;
    KingswoodLbl: TQRLabel;
    BottomLine: TQRShape;
    TopLine2: TQRShape;
    ColumnHeaderBand1: TQRBand;
    PageFooterBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRDBText1: TQRDBText;
    QRLabel2: TQRLabel;
    QRDBText2: TQRDBText;
    QRLabel3: TQRLabel;
    QRDBText3: TQRDBText;
    QRLabel4: TQRLabel;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRLabel5: TQRLabel;
    Age3: TQRLabel;
    Age1: TQRLabel;
    Current: TQRLabel;
    Age2: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    CurrentTotal: TQRLabel;
    Age1Total: TQRLabel;
    Age2Total: TQRLabel;
    Age3Total: TQRLabel;
    QRLabel8: TQRLabel;
    QRExpr1: TQRExpr;
    QRExpr2: TQRExpr;
    QRExpr3: TQRExpr;
    QRExpr4: TQRExpr;
    QRExpr5: TQRExpr;
    QRExpr6: TQRExpr;
    NumRecords: TQRLabel;
    KingsAccFooter: TQRLabel;
    DateLbl: TQRLabel;
  private

  public
     Procedure ShowReport(Preview : Boolean);         // Ch025 added condition
  end;

var
  AgeOfDebtReport: TAgeOfDebtReport;

implementation

uses Rcslist, NewRepUnit;

{$R *.DFM}

Procedure TAgeOfDebtReport.ShowReport(Preview : Boolean);       // Ch025 added condition
begin
          case CustSuppListing.AgeByCombo.ItemIndex of
               0: begin
                  Current.Caption := 'Current';
                  Age1.Caption := '1Mth';
                  Age2.Caption := '2Mth';
                  Age3.Caption := '3+Mths';
                  CurrentTotal.Caption := 'Current';
                  Age1Total.Caption := '1Mth';
                  Age2Total.Caption := '2Mth';
                  Age3Total.Caption := '3+Mths';
                  end;
               1: begin
                  Current.Caption := '0-1Mth';
                  Age1.Caption := '2-3Mths';
                  Age2.Caption := '4-5Mths';
                  Age3.Caption := '6+Mths';
                  CurrentTotal.Caption := '0-1Mth';
                  Age1Total.Caption := '2-3Mths';
                  Age2Total.Caption := '4-5Mths';
                  Age3Total.Caption := '6+Mths';
                  end;
               2: begin
                  Current.Caption := '0-2Mths';
                  Age1.Caption := '3-5Mths';
                  Age2.Caption := '6-8Mths';
                  Age3.Caption := '9+Mths';
                  CurrentTotal.Caption := '0-2Mths';
                  Age1Total.Caption := '3-5Mths';
                  Age2Total.Caption := '6-8Mths';
                  Age3Total.Caption := '9+Mths';
                  end;
               3: begin
                  Current.Caption := '0-5Mths';
                  Age1.Caption := '6-11Mths';
                  Age2.Caption := '12-17Mths';
                  Age3.Caption := '18+Mths';
                  CurrentTotal.Caption := '0-5Mths';
                  Age1Total.Caption := '6-11Mths';
                  Age2Total.Caption := '12-17Mths';
                  Age3Total.Caption := '18+Mths';
                  end;
               4: begin
                  Current.Caption := '0-8Mths';
                  Age1.Caption := '9-17Mths';
                  Age2.Caption := '18-27Mths';
                  Age3.Caption := '28+Mths';
                  CurrentTotal.Caption := '0-8Mths';
                  Age1Total.Caption := '9-17Mths';
                  Age2Total.Caption := '18-27Mths';
                  Age3Total.Caption := '28+Mths';
                  end;
               5: begin
                  Current.Caption := '0-11Mths';
                  Age1.Caption := '12-23Mths';
                  Age2.Caption := '24-35Mths';
                  Age3.Caption := '36+Mths';
                  CurrentTotal.Caption := '0-11Mths';
                  Age1Total.Caption := '12-23Mths';
                  Age2Total.Caption := '24-35Mths';
                  Age3Total.Caption := '36+Mths';
                  end;
          end;

          if NewRepForm.CustRadio.checked then QRDBText1.datafield := 'SLNo'
                else QRDBText1.datafield := 'PLNo';
          Numrecords.Caption := vartostr(Accsdatamodule.AgeOfDebtQuery.recordcount);
          AccsName.Caption := Cash1.XCOMPANY;

          DateLbl.caption :=  CustSuppListing.RepDate.text;      // TGM AB Ch001

          // TGM AB 23/01/15
          if NewRepForm.CustRadio.checked then Heading.caption := ' Customer'
                else Heading.caption := ' Supplier';
          Heading.caption := Heading.caption + ' Age Of Debt - Aged By ' + CustSuppListing.AgeByCombo.Text + ' '; // spaces before and after to give title spacing on report
          // end TGM AB 23/01/15

          // Heading.caption := ' Age Of Debt - Aged By ' + CustSuppListing.AgeByCombo.Text + ' '; // spaces before and after to give title spacing on report
          KingswoodLbl.caption := 'Kingswood Accounts ' + VerNo;
          if Preview then AgeOfDebtReport.preview;            //Ch025 added if Preview
end;

end.
