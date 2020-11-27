unit uCustSuppListing;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls, dialogs;

type
  TCustSuppListingReport = class(TQuickRep)
    PageHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    PageFooterBand1: TQRBand;
    BottomLine: TQRShape;
    Dataset: TQRLabel;
    Company: TQRLabel;
    TopLine1: TQRShape;
    Heading: TQRLabel;
    PrintDateLbl: TQRLabel;
    TimeLbl: TQRSysData;
    PageNumber: TQRSysData;
    KingswoodLbl: TQRLabel;
    TopLine2: TQRShape;
    QRDBText8: TQRDBText;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText9: TQRDBText;
    ColumnHeaderBand1: TQRBand;
    AmountLabel: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRShape1: TQRShape;
    SummaryBand1: TQRBand;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    TotalNo: TQRLabel;
    KingsAccFooter: TQRLabel;
  private

  public
    Procedure RunReport(Database, AccFrom, AccTo, AreaFrom, AreaTo : Integer; SortField : String);
  end;

var
  CustSuppListingReport: TCustSuppListingReport;
  PageLineCount : integer;

implementation

uses AccsData, Vars, Types, Params, calcs;

{$R *.DFM}




procedure TCustSuppListingReport.RunReport(Database, AccFrom, AccTo, AreaFrom, AreaTo : Integer; SortField : String);
var
   i, recordcount : integer;

begin
     Accsdatamodule.CustSuppListingDB.close;
     AccsDataModule.CustSuppQuery.Close;


     if FileExists  (Accsdatamodule.AccsDataBase.Directory + 'CustSuppListingTable.DB' ) then begin
         try DeleteFile  (Accsdatamodule.AccsDataBase.Directory + 'CustSuppListingTable.DB' );
         except showmessage('Error Deleting Cust / Supp Listing Table!');
         end;
     end;

     try Accsdatamodule.CreateCustSuppListingTable;
     except showmessage('Error Creating Cust / Supp Listing Table!');
     end;

     Accsdatamodule.CustSuppListingDB.open;



     KingswoodLbl.caption := 'Kingswood Accounts ' + VerNo;
     Company.Caption := cash1.XCOMPANY;
     dataset.caption := RFarmGate.PLocation[2];
     PageLineCount := 0;
     RecordCount := 0;

     if cash11.Xuse_inc_exp then AmountLabel.caption := 'Balance BF'
         else AmountLabel.caption := 'Turnover';

     AccsDataModule.CustSuppQuery.Close;
     AccsDataModule.CustSuppQuery.sql.clear;

     Case Database of

     4 : begin
              Heading.Caption := 'Customer Account Listing';
              AccsDataModule.CustSuppQuery.sql.Add('Select * From SLFile');
              AccsDataModule.CustSuppQuery.sql.Add('where SLNo >= ' + vartostr(AccFrom) + ' and SLNo <=' + vartostr(AccTo) + ' and AreaCode >= ' + vartostr(AreaFrom) + ' and AreaCode <=' + vartostr(AreaTo));
     end;

     5 : begin
              Heading.Caption := 'Supplier Account Listing';
              AccsDataModule.CustSuppQuery.sql.Add('Select * From PLFile');
              AccsDataModule.CustSuppQuery.sql.Add('where PLNo >= ' + vartostr(AccFrom) + ' and PLNo <=' + vartostr(AccTo) + ' and AreaCode >= ' + vartostr(AreaFrom) + ' and AreaCode <=' + vartostr(AreaTo));
     end;

     end;


     if SortField = 'Name' then AccsDataModule.CustSuppQuery.sql.Add('Order By Name');
     if SortField = 'Account' then begin
              Case Database of
              4 : AccsDataModule.CustSuppQuery.sql.Add('Order By SLNo');
              5 : AccsDataModule.CustSuppQuery.sql.Add('Order By PLNo');
              end;
     end;

     AccsDataModule.CustSuppQuery.open;

     for i:=1 to AccsDataModule.CustSuppQuery.RecordCount do begin
              if AccsDataModule.CustSuppQuery['Active'] = true then begin
                 Inc(Recordcount);
                 AccsDataModule.CustSuppListingDB.Append;
                 if database = 4 then AccsDataModule.CustSuppListingDB['Code'] := AccsDataModule.CustSuppQuery['SLNo']
                    else AccsDataModule.CustSuppListingDB['Code'] := AccsDataModule.CustSuppQuery['PLNo'];
                 AccsDataModule.CustSuppListingDB['Name'] := AccsDataModule.CustSuppQuery['Name'];
                 AccsDataModule.CustSuppListingDB['Address1'] := AccsDataModule.CustSuppQuery['Address1'];
                 AccsDataModule.CustSuppListingDB['Address2'] := AccsDataModule.CustSuppQuery['Address2'];
                 AccsDataModule.CustSuppListingDB['Address3'] := AccsDataModule.CustSuppQuery['Address3'];
                 AccsDataModule.CustSuppListingDB['Address4'] := AccsDataModule.CustSuppQuery['Address4'];
                 AccsDataModule.CustSuppListingDB['Postcode'] := AccsDataModule.CustSuppQuery['Postcode'];
                 AccsDataModule.CustSuppListingDB['PhoneNo1'] := AccsDataModule.CustSuppQuery['PhoneNo1']; // TGM AB 16/11/12
                 AccsDataModule.CustSuppListingDB['PhoneNo2'] := AccsDataModule.CustSuppQuery['PhoneNo2']; // TGM AB 16/11/12
                 if cash11.Xuse_inc_exp then AccsDataModule.CustSuppListingDB['Amount1'] := AccsDataModule.CustSuppQuery['BalanceST']
                    else AccsDataModule.CustSuppListingDB['Amount1'] := AccsDataModule.CustSuppQuery['Turnover'];

              end;

              AccsDataModule.CustSuppQuery.next;
     end;


     TotalNo.Caption := vartostr(RecordCount);
     preview;

end;


end.
