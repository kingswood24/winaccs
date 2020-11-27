unit ProductListing;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls;

type
  TProductListingReport = class(TQuickRep)
    PageHeaderBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    PageFooterBand1: TQRBand;
    DataSet: TQRLabel;
    AccountsName: TQRLabel;
    TopLine1: TQRShape;
    Heading: TQRLabel;
    TopLine2: TQRShape;
    PageNumber: TQRSysData;
    KingswoodLbl: TQRLabel;
    BottomLine: TQRShape;
    QRDBText1: TQRDBText;
    QRShape3: TQRShape;
    QRLabel1: TQRLabel;
    QRShape4: TQRShape;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRDBText5: TQRDBText;
    KingsAccFooter: TQRLabel;
  private

  public
    Procedure RunReport;

  end;

var
  ProductListingReport: TProductListingReport;

implementation

{$R *.DFM}

uses
    AccsData, vars, Types;

Procedure TProductListingReport.RunReport;
begin

     Accsdatamodule.Products.open;    // TGM AB 08/09/17
     ProductListingReport.AccountsName.Caption := Cash1.XCOMPANY;
     ProductListingReport.KingswoodLbl.caption :=  'Kingswood Accounts ' + Verno;
     ProductListingReport.DataSet.Caption :=  Accsdata.AccsDataModule.AccsDataBase.AliasName;



     self.preview;
end;

end.
