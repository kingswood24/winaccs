unit Rcslist;
{
Form to Run Customer/Supplier Listing, Age Of Debt Reports

Ch001 - Form changes
        CustSuppPanel changes - all boxes moved down & ReportDate label, RepDate Text Box & DateSearch enabled / made visable and moved to top of list.

Ch025 - Added new CSV Export Function for Age of Debt Reports


}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, Mask, NewClass, ComCtrls,
  RxLookup;

type
  TRepType = (Customer, Supplier);
  TCustSuppListing = class(TKingForm)
    CustSuppPanel: TPanel;
    RepDate1: TEdit;
    AccFrom: TEdit;
    AccTo: TEdit;
    ReportDate: TLabel;
    lAccFrom: TLabel;
    lAccTo: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Help: TBitBtn;
    Run: TBitBtn;
    AreaFrom: TEdit;
    AreaTo: TEdit;
    Exit: TBitBtn;
    Panel2: TPanel;
    VReports: TRadioButton;
    PReports: TRadioButton;
    sbAccFrom: TSpeedButton;
    sbAccTo: TSpeedButton;
    RepDate: TMaskEdit;
    DateSearch: TDateTimePicker;
    CustSuppAnal: TPanel;
    Label1: TLabel;
    eTxFrom: TEdit;
    eTxTo: TEdit;
    Label2: TLabel;
    Label5: TLabel;
    eAnalFrom: TEdit;
    eAnalTo: TEdit;
    Label6: TLabel;
    AccFromLabel: TLabel;
    AccToLabel: TLabel;
    eNomFrom: TEdit;
    eNomTo: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    AnalysisBreakdownPanel: TPanel;
    Label7: TLabel;
    AnalysisCodeSelect: TRxDBLookupCombo;
    rbsales: TRadioButton;
    rbPurchase: TRadioButton;
    AgeByLabel: TLabel;
    AgeByCombo: TComboBox;
    MinBalance: TCheckBox;
    GreaterThanBalance: TEdit;
    ProductSummaryPanel: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    eProductTxFrom: TEdit;
    eProductTxTo: TEdit;
    eproductFrom: TEdit;
    eProductTo: TEdit;
    EProductNomFrom: TEdit;
    EProductNomTo: TEdit;
    rbProductSales: TRadioButton;
    rbProductPurchases: TRadioButton;
    Label14: TLabel;
    NomDateFrom: TMaskEdit;
    Label15: TLabel;
    MaskEdit1: TMaskEdit;
    Label16: TLabel;
    RgSortBy: TRadioGroup;
    BalancesRG: TRadioGroup;
    ExportBtn: TBitBtn;
    SaveCSVExportdialog: TSaveDialog;
    procedure RunClick(Sender: TObject);
    procedure RepDate1Exit(Sender: TObject);
    procedure RepDate1Enter(Sender: TObject);
    procedure AccFromKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AccToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AreaFromExit(Sender: TObject);
    procedure AreaToExit(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure VReportsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbAccFromClick(Sender: TObject);
    procedure sbAccToClick(Sender: TObject);
    procedure RepDateExit(Sender: TObject);
    procedure DateSearchCloseUp(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure eTxFromExit(Sender: TObject);
    procedure eNomToDblClick(Sender: TObject);
    procedure eNomFromDblClick(Sender: TObject);
    procedure eNomToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eNomFromKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BuildAnalysisReports(Sender: TObject);
    procedure NomDateFromExit(Sender: TObject);
    procedure MaskEdit1Exit(Sender: TObject);
    procedure rbProductPurchasesClick(Sender: TObject);
    procedure rbProductSalesClick(Sender: TObject);
    procedure rbsalesClick(Sender: TObject);
    procedure rbPurchaseClick(Sender: TObject);
    procedure ExportBtnClick(Sender: TObject);
    procedure AgeOfDebtExport(Filename : string);             //Ch025
  private

    { Private declarations }
  public
    { Public declarations }
    RepType : TRepType;
  end;

var
  CustSuppListing: TCustSuppListing;
  Breakdownreport : boolean;
  ProductReport : Boolean;
  CSVExport : Boolean;

implementation
Uses
    DBCore,
    newlisting,
    vars,
    types,
    Calcs,
    NewRepUnit,
    SPREPA,
    DataExport,
    AnalysisReports, AccsData,CalculateMonths, UAgeOfDebtReport, UCustSuppListing;

{$R *.DFM}

// Start Ch025

Function RemoveCommas( inputstring: string): string;
var
        i : integer;
begin
     for i:= 1 to length(inputstring) do begin
         if inputstring[i] = ',' then inputstring[i] := ' ';
     end;
     result := inputstring;
end;

// End Ch025

procedure TCustSuppListing.RunClick(Sender: TObject);
Var IntFrom : Integer;
    IntTo : Integer;
    Database, ListingDB : integer;
begin

     if RepType = Customer then ListingDB := 4
           else ListingDB := 5;

     if rbSales.Checked or rbProductSales.checked then
        begin
           PROG := CustRep;
           DataBase := SLFile;
           CustSuppListing.RepType := Customer;
        end
     else
        begin
           PROG := SUPPrep;
           DataBase := PLFile;
           CustSuppListing.RepType := Supplier;
        end;


     REPXDATE := RepDate.Text;
     IntFrom := StrToInt(AccFrom.Text);
     IntTo := StrToInt(AccTo.Text);

     If ( IntTo < IntFrom ) OR ( IntTo = 0 ) OR ( IntFrom = 0 ) Then
        AccTo.SetFocus
     Else                   
     If ( Act = 1 ) Then begin// CustSuppReportForm.AccountListingRadio.Checked
      //  Rep ( 1, NewRepForm.DataBase )


        if not bool(CustSuppListingReport) then Application.CreateForm(TCustSuppListingReport, CustSuppListingReport);

        if RGSortby.ItemIndex = 0 then CustSuppListingReport.RunReport(ListingDB,strtoint(AccFrom.text),strtoint(AccTo.text),strtoint(AreaFrom.text),strtoint(AreaTo.text),'Account')
           else CustSuppListingReport.RunReport(ListingDB,strtoint(AccFrom.text),strtoint(AccTo.text),strtoint(AreaFrom.text),strtoint(AreaTo.text),'Name');


        end
     Else If ( Act = 2 ) Then begin//CustSuppReportForm.AgeOfDebtRadio.Checked
          CalculateMonths.UpdateSLFiguresAofDReport(strtodate(Repdate.text), AgeByCombo.ItemIndex);   // TGM AB Ch001 - was CalculateMonths.UpdateSLFigures(strtodate(Repdate.text));
          CalculateMonths.UpdatePLFiguresAofDReport(strtodate(Repdate.text), AgeByCombo.ItemIndex);   // TGM AB Ch001 - was CalculateMonths.UpdatePLFigures(strtodate(Repdate.text));
//          Rep ( 2, NewRepForm.DataBase );

       // TGM AB New Report Entered Here
          AccsDataModule.AgeOfDebtQuery.SQL.clear;

  { // TGM AB Ch001
          if MinBalance.Checked then begin
                if NewRepForm.CustRadio.checked then AccsDataModule.AgeOfDebtQuery.SQL.add('Select * from SLFile where (Rep_Balance > ' + GreaterThanBalance.text + ' or Rep_Balance < -' + GreaterThanBalance.text + ')')           // TGM AB Ch001 Rep_Balance was balance
                        else AccsDataModule.AgeOfDebtQuery.SQL.add('Select * from PLFile where (Rep_Balance > ' + GreaterThanBalance.text + ' or Rep_Balance < -' + GreaterThanBalance.text + ')');                                  // TGM AB Ch001 Rep_Balance was balance
                AccsDataModule.AgeOfDebtQuery.SQL.add(' and ');
                end
                        else begin
                             if NewRepForm.CustRadio.checked then AccsDataModule.AgeOfDebtQuery.SQL.add('Select * from SLFile')
                                     else AccsDataModule.AgeOfDebtQuery.SQL.add('Select * from PLFile');
                             AccsDataModule.AgeOfDebtQuery.SQL.add('where ');
                        end;
          end;
   }
   // TGM AB Ch001 start

         Case BalancesRG.itemindex of

         0 : begin
                if NewRepForm.CustRadio.checked then AccsDataModule.AgeOfDebtQuery.SQL.add('Select * from SLFile where (Rep_Balance > ' + GreaterThanBalance.text + ' or Rep_Balance < -' + GreaterThanBalance.text + ')')           // TGM AB Ch001 Rep_Balance was balance
                        else AccsDataModule.AgeOfDebtQuery.SQL.add('Select * from PLFile where (Rep_Balance > ' + GreaterThanBalance.text + ' or Rep_Balance < -' + GreaterThanBalance.text + ')');                                  // TGM AB Ch001 Rep_Balance was balance

                AccsDataModule.AgeOfDebtQuery.SQL.add(' and ');

         end;

         1 : begin
                if NewRepForm.CustRadio.checked then AccsDataModule.AgeOfDebtQuery.SQL.add('Select * from SLFile where (Rep_Balance > ' + GreaterThanBalance.text +')')
                        else AccsDataModule.AgeOfDebtQuery.SQL.add('Select * from PLFile where (Rep_Balance > ' + GreaterThanBalance.text + ')');

                AccsDataModule.AgeOfDebtQuery.SQL.add(' and ');

         end;

         2 : begin
                if NewRepForm.CustRadio.checked then AccsDataModule.AgeOfDebtQuery.SQL.add('Select * from SLFile where (Rep_Balance < ' + GreaterThanBalance.text + ')')
                        else AccsDataModule.AgeOfDebtQuery.SQL.add('Select * from PLFile where (Rep_Balance < ' + GreaterThanBalance.text + ')');

                AccsDataModule.AgeOfDebtQuery.SQL.add(' and ');

         end;

         3 : begin
                if NewRepForm.CustRadio.checked then AccsDataModule.AgeOfDebtQuery.SQL.add('Select * from SLFile')
                    else AccsDataModule.AgeOfDebtQuery.SQL.add('Select * from PLFile');

                AccsDataModule.AgeOfDebtQuery.SQL.add('where ');

         end;

         end;

   // TGM AB Ch001 end

         if NewRepForm.CustRadio.checked then AccsDataModule.AgeOfDebtQuery.SQL.add('(SLNo between ' + AccFrom.text + ' and ' + AccTo.text + ')')
                else AccsDataModule.AgeOfDebtQuery.SQL.add('(PLNo between ' + AccFrom.text + ' and ' + AccTo.text + ')');

         AccsDataModule.AgeOfDebtQuery.SQL.add(' and (AreaCode between ' + AreaFrom.text + ' and ' + AreaTo.text + ')');

         if Rgsortby.ItemIndex = 0 then begin
                    if NewRepForm.CustRadio.checked then AccsDataModule.AgeOfDebtQuery.SQL.add('Order by SLNo')
                       else AccsDataModule.AgeOfDebtQuery.SQL.add('Order by PLNo');
                end;
         if Rgsortby.Itemindex = 1 then begin
                    AccsDataModule.AgeOfDebtQuery.SQL.add('Order by Name');
                end;
         if Rgsortby.Itemindex = 2 then begin
                    AccsDataModule.AgeOfDebtQuery.SQL.add('Order by Rep_Balance asc');        // TGM AB Ch001
                end;
         if Rgsortby.Itemindex = 3 then begin
                    AccsDataModule.AgeOfDebtQuery.SQL.add('Order by Rep_Balance desc');       // TGM AB Ch001
                end;

         AccsDataModule.AgeOfDebtQuery.filter := 'Active = ''True''';
         AccsDataModule.AgeOfDebtQuery.Open;
         AccsDataModule.AgeOfDebtQuery.filtered := true;

         if not bool(AgeOfDebtReport) then Application.CreateForm(TAgeOfDebtReport, AgeOfDebtReport);

         AgeOfDebtReport.showreport(not CSVExport);           // Ch025 added condition
       //



     end
     Else If ( Act = 10 ) Then begin  //CustSuppReportForm. Analysis Report
         if AnalysisBreakdownPanel.Visible then buildanalysisreports(self)
             else Rep ( 10, NewRepForm.DataBase );
          end;
end;

procedure TCustSuppListing.RepDate1Exit(Sender: TObject);
begin
     If NOT DateValid ( RepDate.Text, TDateFormat ) Then
        RepDate.SetFocus;
end;

procedure TCustSuppListing.RepDate1Enter(Sender: TObject);
begin
     RepDate.Text := Cash1.xDate;
end;

procedure TCustSuppListing.AccFromKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F1 Then
       If NewRepForm.CustRadio.Checked Then
          Application.HelpContext(2)
       Else If NewRepForm.SuppRadio.Checked Then
          Application.HelpContext(3);

    If Key = VK_F2 Then    { F2 Pressed }
       Begin
          If NewRepForm.CustRadio.Checked Then
             NewListBox.ListIt ( Sender, Customers, 'C' )
          Else
             NewListBox.ListIt ( Sender, Suppliers, 'S' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            AccFrom.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TCustSuppListing.AccToKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F1 Then
       If NewRepForm.CustRadio.Checked Then
          Application.HelpContext(2)
       Else If NewRepForm.SuppRadio.Checked Then
          Application.HelpContext(3);

    If Key = VK_F2 Then    { F2 Pressed }
       Begin
          If NewRepForm.CustRadio.Checked Then
             NewListBox.ListIt ( Sender, Customers, 'C' )
          Else
             NewListBox.ListIt ( Sender, Suppliers, 'S' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            AccFrom.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TCustSuppListing.AreaFromExit(Sender: TObject);
begin
     If NOT Numeric ( AreaFrom.Text ) Then
        AreaFrom.SetFocus;
end;

procedure TCustSuppListing.AreaToExit(Sender: TObject);
begin
     If NOT Numeric ( AreaTo.Text ) Then
        AreaTo.SetFocus;
end;

procedure TCustSuppListing.ExitClick(Sender: TObject);
begin
     // TGM AB
     try AccsDataModule.AnalysisQuery.close;
     except
     end;
     Breakdownreport := false;
     Close;
end;

procedure TCustSuppListing.FormActivate(Sender: TObject);
Var i : Integer;
begin
     //TxDateFrom := CDateFrom;
     //TxDateTo   := CDateTo;

     CSVExport := False;            //Ch025

     AnalysisBreakdownpanel.Visible := false;
     ProductSummaryPanel.Visible := false;

     Panel2.Visible := not NewRepForm.NewReports.Checked;
     If Device = 'P' Then
        PReports.Checked := True
     Else
         VReports.Checked := True;

     For i := 0 To ComponentCount-1 Do
         If Components[i] is TEdit Then
            TEdit(Components[i]).Text := '';

     SetDb ( NewRepForm.DataBase );
     AccFrom.Text := '1';
     AccTo.Text   := IntToStr ( db1.dbrechigh );
     AreaFrom.Text := '0';
     AreaTo.Text := '9999';
  //   RepDate.Text := Cash1.xDate;            // TGM AB Ch011
     GreaterthanBalance.text := '0.00';
     RGSortby.Items.Clear;
     RGSortBy.Items.add('Account Number');
     RGSortBy.Items.add('Name');
     RGSortBy.ItemIndex := 0;
     Repdate.visible := False;      // TGM AB Ch001
     Reportdate.visible := False;   // TGM AB Ch001
     DateSearch.visible := False;   // TGM AB Ch001
     BalancesRG.visible := False;   // TGM AB Ch001

     Panel1.width := 261;           // TGM AB Ch025
     ExportBtn.visible := False;    // TGM AB Ch025

     If ( Act = 2 )  Then begin //CustSuppReportForm.AgeOfDebtRadio.Checked
        MinBalance.Visible := True;
        Greaterthanbalance.visible := true;
        Label16.visible := true;
        custsupplisting.AgeByCombo.Visible := true;
        AgeBylabel.Visible := true;
        RGSortBy.Items.add('Balance Ascending');
        RGSortBy.Items.add('Balance Descending');
        Repdate.visible := True;      // TGM AB Ch001
        Reportdate.visible := True;   // TGM AB Ch001
        DateSearch.visible := True;   // TGM AB Ch001
        BalancesRG.visible := True;   // TGM AB Ch001
        Panel1.width := 366;          // TGM AB Ch025
        ExportBtn.visible := True;    // TGM AB Ch025
        end
     Else begin
         MinBalance.Hide;
         Greaterthanbalance.hide;
         Label16.hide;
         custsupplisting.AgeByCombo.Visible := false;
         AgeBylabel.Visible := false;
         end;

     if Act = 10 then // Analysis Report
        begin
            // TGM AB

            if Breakdownreport then begin
               CustSuppAnal.hide;
               CustSuppPanel.Hide;
               AnalysisBreakdownpanel.Visible := true;
               try AccsDataModule.AnalysisQuery.close;
               except
               end;
               AccsDataModule.AnalysisQuery.open; //ExecSQL;
               AccsDataModule.AnalysisQuery.Active := True;
               try AccsDataModule.ProductsQuery.close;
               except
               end;
               AccsDataModule.ProductsQuery.open; //ExecSQL;
               AccsDataModule.ProductsQuery.Active := True;

            end
               else begin
                    ReportDate.Parent := CustSuppAnal;
                    RepDate.Parent := CustSuppAnal;
                    DateSearch.Parent := CustSuppAnal;

                    SetDB(TxFile);
                    if ProductReport then begin
                       eProductTxFrom.Text := '1';
                       eProductTxTo.Text := IntToStr ( db1.dbrechigh );
                    end else begin
                        eTxFrom.Text := '1';
                        eTxTo.Text := IntToStr ( db1.dbrechigh );
                    end;
                    SetDB(NlFile);
                    If ProductReport then begin
                        eProductNomFrom.Text := '1';
                        eProductNomTo.Text := IntToStr ( db1.dbrechigh );
                    end else begin
                        eNomFrom.Text := '1';
                        eNomTo.Text := IntToStr ( db1.dbrechigh );
                    end;
                    If ProductReport then begin
                        eProductFrom.Text := '1';
                        eProductTo.Text := '9999';
                        ProductSummaryPanel.Show;
                        CustSuppPanel.Hide;
                    end else begin

                        SetDB(AnalFile);
                        eAnalFrom.Text := '1';
                        eAnalTo.Text := '9999';

                        CustSuppAnal.Show;
                        CustSuppPanel.Hide;
                    end;
                end;
        end
     else
        begin
            ReportDate.Parent := CustSuppPanel;
            RepDate.Parent := CustSuppPanel;
            DateSearch.Parent := CustSuppPanel;
            CustSuppAnal.Hide;
            CustSuppPanel.Show;
        end;

end;

procedure TCustSuppListing.VReportsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     KPrinterOrScreen ( Sender, Button, Shift, x, y );
end;

procedure TCustSuppListing.sbAccFromClick(Sender: TObject);
begin
     If RepType = Customer Then
        NewListBox.ListIt ( Sender, Customers, 'C' )
     Else
        NewListBox.ListIt ( Sender, Suppliers, 'S' );

     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        AccFrom.Text := NewListBox.ListInfo.ReturnValue;
 end;

procedure TCustSuppListing.sbAccToClick(Sender: TObject);
begin
     If RepType = Customer Then
        NewListBox.ListIt ( Sender, Customers, 'C' )
     Else
        NewListBox.ListIt ( Sender, Suppliers, 'S' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        AccTo.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TCustSuppListing.RepDateExit(Sender: TObject);
var
        TestDate : Shortstring;   // TGM AB Ch001
        DateBefore : Boolean;     // TGM AB Ch001
begin
 //    KDateValid ( Sender );           TGM AB Ch001
       TestDate := RepDate.Text;              // TGM AB Ch001
       If NOT CheckDateRange ( TestDate, False, DateBefore, False ) Then begin                // TGM AB Ch001a
            if Not DateBefore then RepDate.setfocus;                                          // TGM AB Ch001a
       end;                                                                                   // TGM AB Ch001a
end;

procedure TCustSuppListing.DateSearchCloseUp(Sender: TObject);
begin
     RepDate.Text:= DateToStr(DateSearch.Date);
     RepDate.SetFocus;
end;

procedure TCustSuppListing.FormShow(Sender: TObject);
begin
     If NewRepForm.CustRadio.checked then begin
            custsupplisting.AgeByCombo.Visible := true;
            AgeBylabel.Visible := true;
        end else begin
            custsupplisting.AgeByCombo.Visible := false;
            AgeBylabel.Visible := false;
        end;

     ageByCombo.ItemIndex := 0;
     DateSearch.Date := KStrToDate (DateToStr(date));           // TGM AB Ch011           was Cash11.Default_Date
     RepDate.Text := DateToStr(date);                           // TGM AB Ch011           was Cash1.xDate;
end;

procedure TCustSuppListing.HelpClick(Sender: TObject);
begin
     If ( Act = 1 ) Then
        Application.HelpContext(145)
     Else
        Application.HelpContext(146)
end;

procedure TCustSuppListing.eTxFromExit(Sender: TObject);
begin
     if ( Sender is TEdit ) then
        if NOT Numeric (( Sender as TEdit ).Text) Then
           (Sender as TEdit).SetFocus;
end;

procedure TCustSuppListing.eNomToDblClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, AllNoms, 'N' );
     if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
        eNomTo.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TCustSuppListing.eNomFromDblClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, AllNoms, 'N' );
     if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
        eNomFrom.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TCustSuppListing.eNomToKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_F2 then    { F2 Pressed }
       begin
          NewListBox.ListIt ( Sender, AllNoms, 'N' );
          if Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
             eNomTo.Text := NewListBox.ListInfo.ReturnValue;
       end;
end;

procedure TCustSuppListing.eNomFromKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_F2 then    { F2 Pressed }
       begin
          NewListBox.ListIt ( Sender, AllNoms, 'N' );
          if Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
             eNomFrom.Text := NewListBox.ListInfo.ReturnValue;
       end;
end;

procedure TCustSuppListing.BuildAnalysisReports(Sender: TObject);
var
    I, keyvalue : integer;
    CustSupp : string;
    SalesTotal,PurchasesTotal,SalesQtyTotal, PurchQtyTotal : real;

begin
          try keyvalue := analysiscodeselect.KeyValue;
          except showmessage('Invalid Code - reverting to the Default Code');
                 keyvalue := 0;
          end;

          Dataexport.ProcessTransFile(self);
          AccsDataModule.GetPurchaseLedgerAccs;
          AccsDataModule.GetSalesLedgerAccs;
          AccsDataModule.AnalysisDB.open;
          //AccsDataModule.Products.open;


          salestotal := 0;
          purchasestotal := 0;
          SalesQtyTotal := 0;
          PurchQtyTotal := 0;
          With AccsDataModule Do Begin
               TransDB.open;
               //ProductsTxQuery.open;
               Purchaseledger.open;
               Salesledger.open;
               AnalysisReportTableDB.EmptyTable;
               AnalysisReportTableDB.open;
               AnalysisReportTableDB.append;
               AnalysisReportTableDB['Comment'] := 'Income';
               AnalysisReportTableDB.post;
               //ProductsTxQuery.Filter := 'TxType = ''9'' and OrigType = ''1'' and ProductID = ''' + vartostr(keyvalue) + '''';
               //ProductsTxQuery.Filtered := true;
               //ProductsTxQuery.First;
               Transdb.filter := '(TxType = ''9'' and OrigType = ''1'' and Analysis = ''' + vartostr(keyvalue) + ''') or (TxType = ''9'' and OrigType = ''3'' and Analysis = ''' + vartostr(keyvalue) + ''') or (TxType = ''9'' and OrigType = ''11'' and Analysis = ''' + vartostr(keyvalue) + ''')';  // TGM AB 20/11/12
            //   Transdb.filter := 'TxType = ''9'' and OrigType = ''1'' and Analysis = ''' + vartostr(keyvalue) + '''';
               TransDB.filtered := True;
               TransDB.First;
               {For i:= 1 to ProductsTxQuery.recordcount do begin
                   AnalysisReportTableDB.Append;
                   try SalesLedger.Locate('Account',ProductsTxQuery['Account'],[]);
                       AnalysisReportTableDB['CustSupp'] := SalesLedger['Name'];
                   except
                   end;
                   SalesTotal := SalesTotal + ProductsTxQuery['Amount'];
                   SalesQtyTotal := SalesQtyTotal + ProductsTxQuery['Quantity'];

                   AnalysisReportTableDB['Amount'] := ProductsTxQuery['Amount'];
                   AnalysisReportTableDB['TaxDisc'] := ProductsTxQuery['TaxDisc'];
                   AnalysisReportTableDB['Nominal'] := ProductsTxQuery['Nominal'];
                   AnalysisReportTableDB['TxDate'] := ProductsTxQuery['TxDate'];
                   AnalysisReportTableDB['Account'] := ProductsTxQuery['Account'];
                   AnalysisReportTableDB['Reference'] := ProductsTxQuery['Reference'];
                   AnalysisReportTableDB['Descript'] := ProductsTxQuery['Descript'];
                   AnalysisReportTableDB['Analysis'] := ProductsTxQuery['ProductID'];
                   AnalysisReportTableDB.post;
                   ProductsTxQuery.next;
               end;}

               For i:= 1 to TransDB.recordcount do begin
                   AnalysisReportTableDB.Append;
                   try SalesLedger.Locate('Account',TransDB['Account'],[]);
                       AnalysisReportTableDB['CustSupp'] := SalesLedger['Name'];
                   except
                   end;
                   SalesTotal := SalesTotal + TransDB['Amount'];
                   if TransDB['OrigType'] = 3 then begin
                       if TransDB['Quantity'] >0 then SalesQtyTotal := SalesQtyTotal - TransDB['Quantity']
                           else SalesQtyTotal := SalesQtyTotal + TransDB['Quantity'];
                   end else SalesQtyTotal := SalesQtyTotal + TransDB['Quantity'];
                   AnalysisReportTableDB['Amount'] := TransDB['Amount'];
                   AnalysisReportTableDB['TaxDisc'] := TransDB['TaxDisc'];
                   AnalysisReportTableDB['Nominal'] := TransDB['Nominal'];
                   AnalysisReportTableDB['TxDate'] := TransDB['TxDate'];
                   AnalysisReportTableDB['Account'] := TransDB['Account'];
                   AnalysisReportTableDB['Reference'] := TransDB['Reference'];
                   AnalysisReportTableDB['Descript'] := TransDB['Descript'];
                   //AnalysisReportTableDB['Analysis'] := TransDB['Product'];
                   AnalysisReportTableDB['Analysis'] := TransDB['Analysis'];
                   AnalysisReportTableDB.post;
                   TransDB.next;
               end;

               AnalysisReportTableDB.append;
               AnalysisReportTableDB['Comment'] := 'Total Income';
               AnalysisReportTableDB['Amount'] := SalesTotal;
               AnalysisReportTableDB.post;

               AnalysisReportTableDB.append;
               AnalysisReportTableDB['Comment'] := 'Expenditure';
               AnalysisReportTableDB.post;

               ProductsTxQuery.Filtered := false;
               Transdb.filtered := false;
               //ProductsTxQuery.filter := 'TxType = ''9'' and OrigType = ''5'' and ProductID = ''' + vartostr(keyvalue) + '''';
               //ProductsTxQuery.filtered := true;
               //ProductsTxQuery.first;
               //Transdb.filter := 'TxType = ''9'' and OrigType = ''5'' and Analysis = ''' + vartostr(keyvalue) + '''';
               Transdb.filter := '(TxType = ''9'' and OrigType = ''5'' and Analysis = ''' + vartostr(keyvalue) + ''') or (TxType = ''9'' and OrigType = ''7'' and Analysis = ''' + vartostr(keyvalue) + ''') or (TxType = ''9'' and OrigType = ''15'' and Analysis = ''' + vartostr(keyvalue) + ''')';  // TGM AB 20/11/12
               TransDB.filtered := True;
               TransDB.First;

               {For i:= 1 to ProductsTxQuery.recordcount do begin
                   AnalysisReportTableDB.Append;
                   try PurchaseLedger.Locate('Account',ProductsTxQuery['Account'],[]);
                       AnalysisReportTableDB['CustSupp'] := PurchaseLedger['Name'];
                   except
                   end;
                   PurchasesTotal := PurchasesTotal + ProductsTxQuery['Amount'];
                   PurchQtyTotal := PurchQtyTotal + ProductsTxQuery['Quantity'];
                   AnalysisReportTableDB['Amount'] := ProductsTxQuery['Amount'];
                   AnalysisReportTableDB['TaxDisc'] := ProductsTxQuery['TaxDisc'];
                   AnalysisReportTableDB['Nominal'] := ProductsTxQuery['Nominal'];
                   AnalysisReportTableDB['TxDate'] := ProductsTxQuery['TxDate'];
                   AnalysisReportTableDB['Account'] := ProductsTxQuery['Account'];
                   AnalysisReportTableDB['Reference'] := ProductsTxQuery['Reference'];
                   AnalysisReportTableDB['Descript'] := ProductsTxQuery['Descript'];
                   AnalysisReportTableDB['Analysis'] := ProductsTxQuery['ProductID'];
                   //AnalysisReportTableDB['Analysis'] := TransDB['Analysis'];
                   AnalysisReportTableDB.post;
                   ProductsTxQuery.next;
               end;}



               For i:= 1 to TransDB.recordcount do begin
                   AnalysisReportTableDB.Append;
                   try PurchaseLedger.Locate('Account',TransDB['Account'],[]);
                       AnalysisReportTableDB['CustSupp'] := PurchaseLedger['Name'];
                   except
                   end;
                   PurchasesTotal := PurchasesTotal + TransDB['Amount'];

                   if TransDB['OrigType'] = 7 then begin
                      if TransDB['Quantity'] >0 then PurchQtyTotal := PurchQtyTotal - TransDB['Quantity']
                          else PurchQtyTotal := PurchQtyTotal + TransDB['Quantity'];
                   end else PurchQtyTotal := PurchQtyTotal + TransDB['Quantity'];

                   AnalysisReportTableDB['Amount'] := TransDB['Amount'];
                   AnalysisReportTableDB['TaxDisc'] := TransDB['TaxDisc'];
                   AnalysisReportTableDB['Nominal'] := TransDB['Nominal'];
                   AnalysisReportTableDB['TxDate'] := TransDB['TxDate'];
                   AnalysisReportTableDB['Account'] := TransDB['Account'];
                   AnalysisReportTableDB['Reference'] := TransDB['Reference'];
                   AnalysisReportTableDB['Descript'] := TransDB['Descript'];
                   AnalysisReportTableDB['Analysis'] := TransDB['Product'];
                   //AnalysisReportTableDB['Analysis'] := TransDB['Analysis'];
                   AnalysisReportTableDB.post;
                   TransDB.next;
               end;

               AnalysisReportTableDB.append;
               AnalysisReportTableDB['Comment'] := 'Total Expenditure';
               AnalysisReportTableDB['Amount'] := PurchasesTotal;
               AnalysisReportTableDB.post;
               AnalysisReportTableDB.append;
               AnalysisReportTableDB.post;
               AnalysisReportTableDB.append;
               AnalysisReportTableDB.post;

               AnalysisReportTableDB.append;
               AnalysisReportTableDB['Comment'] := 'Margin';
               AnalysisReportTableDB['Amount'] := SalesTotal - PurchasesTotal;
               AnalysisReportTableDB.post;

               AnalysisReportTableDB.append;
               AnalysisReportTableDB['Comment'] := 'Sales Qty';
               AnalysisReportTableDB['Amount'] := SalesQtyTotal;
               AnalysisReportTableDB.post;

               AnalysisReportTableDB.append;
               AnalysisReportTableDB['Comment'] := 'Purchase Qty';
               AnalysisReportTableDB['Amount'] := PurchQtyTotal;
               AnalysisReportTableDB.post;

               //ProductsTxQuery.filtered := false;
               //ProductsTxQuery.filter := '';
               //ProductsTxQuery.close;

               Transdb.filtered := false;
               Transdb.filter := '';
               TransDB.close;
               Purchaseledger.close;
               Salesledger.close;
          end;


          if not bool(AnalysisReport) then Application.CreateForm(TAnalysisReport, AnalysisReport);
          //accsdatamodule.Products.Locate('ID',keyvalue,[]);
          accsdatamodule.analysisDB.Locate('Number',keyvalue,[]);
          //AnalysisReports.AnalysisReport.Heading.caption := 'Product Report For ' + vartostr(accsdatamodule.ProductQuery['Desc1']);
          AnalysisReports.AnalysisReport.Heading.caption := 'Analysis Report For ' + vartostr(accsdatamodule.analysisDB['Description']);
          AnalysisReports.AnalysisReport.PreviewReport;
          Accsdatamodule.AnalysisReportTableDB.close;

end;

procedure TCustSuppListing.NomDateFromExit(Sender: TObject);
begin
     KDateFromExit ( Sender, Report );
end;

procedure TCustSuppListing.MaskEdit1Exit(Sender: TObject);
begin
     KDateToExit ( Sender, Report );
end;

procedure TCustSuppListing.rbProductPurchasesClick(Sender: TObject);
begin
     rbPurchase.checked := true;
end;

procedure TCustSuppListing.rbProductSalesClick(Sender: TObject);
begin
     rbSales.checked := true;
end;

procedure TCustSuppListing.rbsalesClick(Sender: TObject);
begin
     rbProductSales.checked := true;
end;

procedure TCustSuppListing.rbPurchaseClick(Sender: TObject);
begin
     rbProductPurchases.checked := True;
end;

// Ch025 starts here

procedure TCustSuppListing.ExportBtnClick(Sender: TObject);
begin
        CSVExport := True;   // set report to export
        Runclick(self);
        if SaveCSVExportdialog.Execute then AgeOfDebtExport(SaveCSVExportdialog.FileName);
        CSVExport := False   // clear export flag

end;

procedure TCustSuppListing.AgeOfDebtExport(Filename : string);
var
        OutputFile : textfile;
        i : integer;
        outputline : string;

begin

        // Build CSV File

        Assignfile(OutputFile,Filename);
        Rewrite(OutputFile);

        // Header

        Outputline := '';

        Outputline := 'Code,Name,Balance';
        OutputLine := Outputline + ',' + AgeOfDebtReport.Current.Caption;
        OutputLine := Outputline + ',' + AgeOfDebtReport.Age1.Caption;
        OutputLine := Outputline + ',' + AgeOfDebtReport.Age2.Caption;
        OutputLine := Outputline + ',' + AgeOfDebtReport.Age3.Caption;
        OutputLine := Outputline + ',' + 'Turnover';

        WriteLn(OutputFile,OutputLine);

        Accsdatamodule.AgeOfDebtQuery.First;

        for i:= 1 to Accsdatamodule.AgeOfDebtQuery.RecordCount do begin

            Outputline := '';

            if NewRepForm.CustRadio.checked then Outputline := Accsdatamodule.AgeOfDebtQuery.fieldbyname('SLNo').AsString
                else Outputline := Accsdatamodule.AgeOfDebtQuery.fieldbyname('PLNo').AsString;

            Outputline := Outputline + ',' + trim(RemoveCommas(Accsdatamodule.AgeOfDebtQuery.fieldbyname('Name').AsString));
            Outputline := Outputline + ',' + Accsdatamodule.AgeOfDebtQuery.fieldbyname('Rep_Balance').AsString;
            Outputline := Outputline + ',' + Accsdatamodule.AgeOfDebtQuery.fieldbyname('Rep_AgeCurr').AsString;
            Outputline := Outputline + ',' + Accsdatamodule.AgeOfDebtQuery.fieldbyname('Rep_Age1').AsString;
            Outputline := Outputline + ',' + Accsdatamodule.AgeOfDebtQuery.fieldbyname('Rep_Age2').AsString;
            Outputline := Outputline + ',' + Accsdatamodule.AgeOfDebtQuery.fieldbyname('Rep_Age3').AsString;
            Outputline := Outputline + ',' + Accsdatamodule.AgeOfDebtQuery.fieldbyname('Rep_Turnover').AsString;


            WriteLn(OutputFile,OutputLine);

            Accsdatamodule.AgeOfDebtQuery.next;

        end;   // for i



        closefile(OutputFile);
        Showmessage('Age of Debt CSV Export Complete');

end;

// Ch025 ends here

end.



