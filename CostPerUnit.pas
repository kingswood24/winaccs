unit CostPerUnit;

{changes

12/06/15 - bug fix where unpresented transactions carried forward from last year where being shown on the report

}

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls, dialogs;

type
  TCostPerUnitReport = class(TQuickRep)
    PageHeaderBand1: TQRBand;
    PageFooterBand1: TQRBand;
    BottomLine: TQRShape;
    TopLine2: TQRShape;
    Heading: TQRLabel;
    TimeLbl: TQRSysData;
    PageNumber: TQRSysData;
    KingswoodLbl: TQRLabel;
    dataset: TQRLabel;
    AccountsName: TQRLabel;
    QRShape1: TQRShape;
    ReportDatelabel: TQRLabel;
    DetailBand1: TQRBand;
    QRDBText1: TQRDBText;
    TitleBand1: TQRBand;
    Header: TQRLabel;
    QRShape2: TQRShape;
    EnterpriseLabel: TQRLabel;
    QRLabel1: TQRLabel;
    ColumnHeaderBand1: TQRBand;
    QRShape3: TQRShape;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    UnitNameLabel: TQRLabel;
    NoUnitsLabel: TQRLabel;
    QRLabel4: TQRLabel;
    UnitValueLabel: TQRLabel;
    QRDBText2: TQRDBText;
    QRLabel5: TQRLabel;
    QRDBText3: TQRDBText;
    PerUnitLbl: TQRLabel;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QtyLabel: TQRLabel;
    QRDBQty: TQRDBText;
    QRDBQtyBold: TQRDBText;
    QtyLabel2: TQRLabel;
    QRDBPerQty: TQRDBText;
    QRDBPerQtyBold: TQRDBText;
    EntCaption1: TQRLabel;
    EntCaption2: TQRLabel;
    EntField6: TQRDBText;
    EntField5: TQRDBText;
    EntField5Bold: TQRDBText;
    EntField6Bold: TQRDBText;
    EntTotalsLabel: TQRLabel;
    FilterLabel: TQRLabel;
    KingsAccFooter: TQRLabel;
    procedure QRDBText2Print(sender: TObject; var Value: String);
    procedure QRDBText4Print(sender: TObject; var Value: String);
    procedure QRDBText7Print(sender: TObject; var Value: String);
    procedure QRDBText8Print(sender: TObject; var Value: String);
    procedure QRDBQtyPrint(sender: TObject; var Value: String);
    procedure QRDBQtyBoldPrint(sender: TObject; var Value: String);
    procedure QRDBPerQtyPrint(sender: TObject; var Value: String);
    procedure QRDBPerQtyBoldPrint(sender: TObject; var Value: String);
    procedure EntField5Print(sender: TObject; var Value: String);
    procedure EntField6Print(sender: TObject; var Value: String);
    procedure EntField5BoldPrint(sender: TObject; var Value: String);
    procedure EntField6BoldPrint(sender: TObject; var Value: String);
  private

  public
    Procedure RunReport;
    Procedure GatherParams;
    Procedure ProcessRecords;
    procedure GatherTransactions(NomAccount : Integer);
  end;

var
  CostPerUnitReport: TCostPerUnitReport;
  // Parameters off the Report Input screen
  ReportDate : string;
  EnterpriseCode, EnterpriseName : String;
  IncludePerQtyBreakdown : boolean;
  EnterpriseBreakdown : boolean;
  DateFrom : String;
  DateTo : String;
  AnalysisFrom, AnalysisTo : Integer;
  PencePerUnitBreakdown : boolean;
  NoEntUnits : Real;
  ReportUnitName : String;
  TotalEntIncome, TotalEntExp, GrossMargin, GrossMarginPercent, TotalOverheadExp, TotalProductionCosts, NetMargin, NetMarginPercent: Real;
  EntOverheadPercent : real;
  DairyEnterprise : Boolean;
  SpanYears : Boolean;
  TotalAmount, TotalQty, TotalQty2, TotalQty3 : Real; // Returned Values from Transaction file look up
  TotalLitres, TotalMilkSolids : Real; // Returned Values from Transaction file look up
  SummaryReportOnly : Boolean;
  EnterpriseBreakdown2 : boolean;
  QTY2Name, QTY3Name : string;


implementation

{$R *.DFM}

uses
     Types, params, EntReps, AccsData, vars, Calcs, CostPerUnitSummary, FullAudit;      // TGM AB 12/06/15

procedure TCostPerUnitReport.RunReport;
var
   tempstr : shortstring;
   tempreal : real;
   i : integer;
begin
     GatherParams;
     Accsdatamodule.CostPerUnitReportTableDB.open;
     ProcessRecords;

     // Fill in labels etc

     KingswoodLbl.caption := 'Kingswood Accounts ' + VerNo;
     ReportDateLabel.Caption := ReportDate;
     dataset.caption := RFarmGate.PLocation[2];
     Enterpriselabel.caption := EnterpriseCode + ' - ' + EnterpriseName;
     UnitNamelabel.caption := ReportUnitName;
     PerUnitlbl.caption := 'Per ' + ReportUnitName;
     NoUnitsLabel.caption := vartostr(NoEntUnits);
     AccountsName.caption := Cash1.xcompany;
     EntTotalsLabel.Enabled := false;

     // TGM AB 16/01/15
     FilterLabel.caption := '';
     if ((DateFrom <> '  /  /  ') and (DateTo <> '  /  /  ')) then begin
         FilterLabel.Caption := 'Date Range: ' + DateFrom + ' - ' + DateTo;
     end;
     // TGM AB 16/01/15 end

     if Cash2.XCOUNTRY = 1 then begin
              if PencePerUnitBreakdown then UnitValueLabel.caption := 'pence'
                 else UnitValueLabel.caption := 'Pounds';
     end  else begin
                    if PencePerUnitBreakdown then UnitValueLabel.caption := 'cents'
                       else UnitValueLabel.caption := 'Euros';
               end;
     if IncludePerQtyBreakdown then begin
                QtyLabel.enabled := true;
                QtyLabel2.enabled := true;
                QRDBQty.enabled := true;
                QRDBPerQty.enabled := true;
                QRDBQtyBold.enabled := true;
                QRDBPerQtyBold.enabled := true;
     end else begin
                QtyLabel.enabled := false;
                QtyLabel2.enabled := false;
                QRDBQty.enabled := false;
                QRDBPerQty.enabled := false;
                QRDBQtyBold.enabled := false;
                QRDBPerQtyBold.enabled := false;
          end;

     // fill out enterprise specific fields


     if EnterpriseBreakdown then begin
                EntCaption1.Enabled := True;
                EntCaption2.Enabled := True;
                EntField5.Enabled := True;
                EntField6.Enabled := True;
                EntField5Bold.Enabled := True;
                EntField6Bold.Enabled := True;

                EntCaption1.Caption := QTY2Name;
                EntCaption2.Caption := 'Per ' + QTY2Name;

                if DairyEnterprise then begin     // calculate per litre & per kg solid figures

                    EntCaption1.Caption := 'Per Litre';
                    EntCaption2.Caption := 'Per kg Solid';   // TGM AB 25/07/14 was kg Milk

                    AccsDataModule.CostPerUnitReportTableDB.First;
                    for i := 1 to AccsDataModule.CostPerUnitReportTableDB.recordcount do begin
                        if (AccsDataModule.CostPerUnitReportTableDB.FieldByName('numberfield1').asstring <> '') then begin
                           AccsDataModule.CostPerUnitReportTableDB.edit;
                           if TotalLitres <> 0 then begin
                                try AccsDataModule.CostPerUnitReportTableDB['numberfield5'] := AccsDataModule.CostPerUnitReportTableDB['numberfield1']/TotalLitres
                                except AccsDataModule.CostPerUnitReportTableDB['numberfield5'] := 0;
                                end;
                           end;
                           if TotalMilkSolids <> 0 then begin
                                try AccsDataModule.CostPerUnitReportTableDB['numberfield6'] := AccsDataModule.CostPerUnitReportTableDB['numberfield1']/TotalMilkSolids
                                except AccsDataModule.CostPerUnitReportTableDB['numberfield6'] := 0;
                                end;
                           end;
                           AccsDataModule.CostPerUnitReportTableDB.post;
                        end;

                        if ((AccsDataModule.CostPerUnitReportTableDB.FieldByName('numberfield1bold').asstring <> '') and (pos('%',AccsDataModule.CostPerUnitReportTableDB.FieldByName('label').asstring) = 0)) then begin
                           AccsDataModule.CostPerUnitReportTableDB.edit;
                           if TotalLitres <> 0 then begin
                                try AccsDataModule.CostPerUnitReportTableDB['numberfield5bold'] := AccsDataModule.CostPerUnitReportTableDB['numberfield1bold']/TotalLitres
                                except AccsDataModule.CostPerUnitReportTableDB['numberfield5bold'] := 0;
                                end;
                           end;
                           if TotalMilkSolids <> 0 then begin
                                try AccsDataModule.CostPerUnitReportTableDB['numberfield6bold'] := AccsDataModule.CostPerUnitReportTableDB['numberfield1bold']/TotalMilkSolids
                                except AccsDataModule.CostPerUnitReportTableDB['numberfield6bold'] := 0;
                                end;
                           end;
                           AccsDataModule.CostPerUnitReportTableDB.post;
                        end;

                        AccsDataModule.CostPerUnitReportTableDB.next;
                    end;

                    EntTotalsLabel.Enabled := true;

                    EntTotalsLabel.caption := FloatToStrF(TotalLitres, ffNumber , 8, 2) + ' litres / ' + FloatToStrF(TotalMilkSolids, ffNumber , 8, 2) + ' kg Solids'

                end;

     end else if EnterpriseBreakdown2 then begin
                         EntCaption1.Enabled := True;
                         EntCaption2.Enabled := True;
                         EntField5.Enabled := True;
                         EntField6.Enabled := True;
                         EntField5Bold.Enabled := True;
                         EntField6Bold.Enabled := True;

                         EntCaption1.Caption := QTY3Name;
                         EntCaption2.Caption := 'Per ' + QTY3Name;

                    end else begin
                              EntCaption1.Enabled := False;
                              EntCaption2.Enabled := False;
                              EntField5.Enabled := False;
                              EntField6.Enabled := False;
                              EntField5Bold.Enabled := False;
                              EntField6Bold.Enabled := False;
         end;


         
     if not SummaryReportOnly then preview;

     // build summary report

     if not bool (CostPerUnitSummaryReport) then Application.CreateForm(TCostPerUnitSummaryReport, CostPerUnitSummaryReport);

     // Fill out all the captions

     CostPerUnitSummaryReport.KingswoodLbl.caption := 'Kingswood Accounts ' + VerNo;
     CostPerUnitSummaryReport.ReportDateLabel.Caption := ReportDate;
     CostPerUnitSummaryReport.dataset.caption := RFarmGate.PLocation[2];
     CostPerUnitSummaryReport.Enterpriselabel.caption := EnterpriseCode + ' - ' + EnterpriseName;
     CostPerUnitSummaryReport.UnitNamelabel.caption := ReportUnitName;
     CostPerUnitSummaryReport.PerUnitLbl.caption := 'Per ' + ReportUnitName;
     CostPerUnitSummaryReport.NoUnitsLabel.caption := vartostr(NoEntUnits);

     // TGM AB 16/01/15
     CostPerUnitSummaryReport.FilterLabel.caption := '';
     if ((DateFrom <> '  /  /  ') and (DateTo <> '  /  /  ')) then begin
         CostPerUnitSummaryReport.FilterLabel.Caption := 'Date Range: ' + DateFrom + ' - ' + DateTo;
     end;
     // TGM AB 16/01/15 end


     CostPerUnitSummaryReport.DairyLbl1.enabled := false;
     CostPerUnitSummaryReport.DairyLbl2.enabled := false;
     CostPerUnitSummaryReport.TotalLitres.enabled := false;
     CostPerUnitSummaryReport.TotalSolids.enabled := false;
     CostPerUnitSummaryReport.LitresMilkUnit.enabled := false;
     CostPerUnitSummaryReport.kgMilkUnit.enabled := false;
     CostPerUnitSummaryReport.PerLitreLabel.enabled := false;
     CostPerUnitSummaryReport.PerKgLabel.enabled := false;
     CostPerUnitSummaryReport.IncPerLitre.enabled := false;
     CostPerUnitSummaryReport.ExpPerLitre.enabled := false;
     CostPerUnitSummaryReport.GrossPerLitre.enabled := false;
     CostPerUnitSummaryReport.OverPerLitre.enabled := false;
     CostPerUnitSummaryReport.ProdPerLitre.enabled := false;
     CostPerUnitSummaryReport.MarginPerLitre.enabled := false;
     CostPerUnitSummaryReport.IncPerKg.enabled := false;
     CostPerUnitSummaryReport.ExpPerKg.enabled := false;
     CostPerUnitSummaryReport.GrossPerKg.enabled := false;
     CostPerUnitSummaryReport.OverPerKg.enabled := false;
     CostPerUnitSummaryReport.ProdPerKg.enabled := false;
     CostPerUnitSummaryReport.MarginPerKg.enabled := false;
     // Income Summary

     Tempstr := '';
     DoubleToStr(TotalEntIncome*100,TempStr,'%8.2n', True, True, 8, True);
     CostPerUnitSummaryReport.IncTotalLbl.caption := TempStr;
     Tempstr := '';
     DoubleToStr((TotalEntIncome*100)/NoEntUnits,TempStr,'%8.2n', True, True, 8, True);
     CostPerUnitSummaryReport.IncUnitLbl.caption := TempStr;

     // Expenditure Summary

     Tempstr := '';
     DoubleToStr(TotalEntExp*100,TempStr,'%8.2n', True, True, 8, True);
     CostPerUnitSummaryReport.ExpTotalLbl.caption := TempStr;
     Tempstr := '';
     DoubleToStr((TotalEntExp*100)/NoEntUnits,TempStr,'%8.2n', True, True, 8, True);
     CostPerUnitSummaryReport.ExpUnitLbl.caption := TempStr;

     // Gross Margin

     Tempstr := '';
     DoubleToStr(GrossMargin*100,TempStr,'%8.2n', True, True, 8, True);
     CostPerUnitSummaryReport.GrossTotalLbl.caption := TempStr;
     Tempstr := '';
     DoubleToStr(((GrossMargin)*100/NoEntUnits),TempStr,'%8.2n', True, True, 8, True);
     CostPerUnitSummaryReport.GrossUnitLbl.caption := TempStr;

     Tempstr := '';
     DoubleToStr(GrossMarginPercent*100,TempStr,'%8.2f', True, True, 8, True);
     CostPerUnitSummaryReport.GrossMarginPercentLbl.caption := TempStr + '%';

     // Total Overheads

     Tempstr := '';
     DoubleToStr(TotalOverheadExp*100,TempStr,'%8.2n', True, True, 8, True);
     CostPerUnitSummaryReport.OverTotalLbl.caption := TempStr;
     Tempstr := '';
     DoubleToStr(((TotalOverheadExp)*100)/NoEntUnits,TempStr,'%8.2n', True, True, 8, True);
     CostPerUnitSummaryReport.OverUnitLbl.caption := TempStr;

     CostPerUnitSummaryReport.OverheadsLbl.caption := 'Overheads ( ' + vartostr(EntOverheadPercent * 100) + '%)';

     // Production Costs

     Tempstr := '';
     DoubleToStr((TotalProductionCosts)*100,TempStr,'%8.2n', True, True, 8, True);
     CostPerUnitSummaryReport.ProdTotalLbl.caption := TempStr;
     Tempstr := '';
     DoubleToStr((TotalProductionCosts)*100/NoEntUnits,TempStr,'%8.2n', True, True, 8, True);
     CostPerUnitSummaryReport.ProdUnitLbl.caption := TempStr;

     // Net Margin

     Tempstr := '';
     DoubleToStr((NetMargin)*100,TempStr,'%8.2n', True, True, 8, True);
     CostPerUnitSummaryReport.NetTotalLbl.caption := TempStr;
     Tempstr := '';
     DoubleToStr(((NetMargin)*100)/NoEntUnits,TempStr,'%8.2n', True, True, 8, True);
     CostPerUnitSummaryReport.NetUnitLbl.caption := TempStr;

     Tempstr := '';
     DoubleToStr(NetMarginPercent*100,TempStr,'%8.2f', True, True, 8, True);
     CostPerUnitSummaryReport.NetMarginPercentLbl.caption := TempStr + '%';

     if (DairyEnterprise and EnterpriseBreakdown) then begin

                Tempstr := '';
                DoubleToStr((TotalLitres)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.TotalLitres.caption := TempStr;
                Tempstr := '';
                DoubleToStr((TotalLitres/NoEntUnits)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.LitresMilkUnit.caption := TempStr;
                Tempstr := '';
                DoubleToStr((TotalMilkSolids)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.TotalSolids.caption := TempStr;
                Tempstr := '';
                DoubleToStr((TotalMilkSolids/NoEntUnits)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.kgMilkUnit.caption := TempStr;

                CostPerUnitSummaryReport.IncPerKg.caption := '';
                CostPerUnitSummaryReport.ExpPerKg.caption := '';
                CostPerUnitSummaryReport.GrossPerKg.caption := '';
                CostPerUnitSummaryReport.OverPerKg.caption := '';
                CostPerUnitSummaryReport.ProdPerKg.caption := '';
                CostPerUnitSummaryReport.MarginPerKg.caption := '';

                CostPerUnitSummaryReport.IncPerLitre.caption := '';
                CostPerUnitSummaryReport.ExpPerLitre.caption := '';
                CostPerUnitSummaryReport.GrossPerLitre.caption := '';
                CostPerUnitSummaryReport.OverPerLitre.caption := '';
                CostPerUnitSummaryReport.ProdPerLitre.caption := '';
                CostPerUnitSummaryReport.MarginPerLitre.caption := '';

                if TotalLitres <> 0 then begin

                //Income
                Tempstr := '';
                DoubleToStr((TotalEntIncome/TotalLitres)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.IncPerLitre.caption := TempStr;

                //Expend
                Tempstr := '';
                DoubleToStr((TotalEntExp/TotalLitres)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.ExpPerLitre.caption := TempStr;

                //Gross Margin
                Tempstr := '';
                DoubleToStr((GrossMargin/TotalLitres)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.GrossPerLitre.caption := TempStr;

                //Overheads
                Tempstr := '';
                DoubleToStr((TotalOverheadExp/TotalLitres)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.OverPerLitre.caption := TempStr;

                //ProductionCosts
                Tempstr := '';
                DoubleToStr((TotalProductionCosts/TotalLitres)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.ProdPerLitre.caption := TempStr;

                //Net Margin
                Tempstr := '';
                DoubleToStr((NetMargin/TotalLitres)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.MarginPerLitre.caption := TempStr;

                end;

                if TotalMilkSolids <> 0 then begin

                //Income
                Tempstr := '';
                DoubleToStr((TotalEntIncome/TotalMilkSolids)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.IncPerKg.caption := TempStr;

                //Expend
                Tempstr := '';
                DoubleToStr((TotalEntExp/TotalMilkSolids)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.ExpPerKg.caption := TempStr;

                //Gross Margin
                Tempstr := '';
                DoubleToStr((GrossMargin/TotalMilkSolids)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.GrossPerKg.caption := TempStr;

                //Overheads
                Tempstr := '';
                DoubleToStr((TotalOverheadExp/TotalMilkSolids)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.OverPerKg.caption := TempStr;

                //ProductionCosts
                Tempstr := '';
                DoubleToStr((TotalProductionCosts/TotalMilkSolids)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.ProdPerKg.caption := TempStr;

                //Net Margin
                Tempstr := '';
                DoubleToStr((NetMargin/TotalMilkSolids)*100,TempStr,'%8.2n', True, True, 8, True);
                CostPerUnitSummaryReport.MarginPerKg.caption := TempStr;


                end;


                CostPerUnitSummaryReport.DairyLbl1.enabled := true;
                CostPerUnitSummaryReport.DairyLbl2.enabled := true;
                CostPerUnitSummaryReport.TotalLitres.enabled := true;
                CostPerUnitSummaryReport.TotalSolids.enabled := true;
                CostPerUnitSummaryReport.LitresMilkUnit.enabled := true;
                CostPerUnitSummaryReport.kgMilkUnit.enabled := true;
                CostPerUnitSummaryReport.PerLitreLabel.enabled := true;
                CostPerUnitSummaryReport.PerKgLabel.enabled := true;
                CostPerUnitSummaryReport.IncPerLitre.enabled := true;
                CostPerUnitSummaryReport.ExpPerLitre.enabled := true;
                CostPerUnitSummaryReport.GrossPerLitre.enabled := true;
                CostPerUnitSummaryReport.OverPerLitre.enabled := true;
                CostPerUnitSummaryReport.ProdPerLitre.enabled := true;
                CostPerUnitSummaryReport.MarginPerLitre.enabled := true;
                CostPerUnitSummaryReport.IncPerKg.enabled := true;
                CostPerUnitSummaryReport.ExpPerKg.enabled := true;
                CostPerUnitSummaryReport.GrossPerKg.enabled := true;
                CostPerUnitSummaryReport.OverPerKg.enabled := true;
                CostPerUnitSummaryReport.ProdPerKg.enabled := true;
                CostPerUnitSummaryReport.MarginPerKg.enabled := true;

     end;

     CostPerUnitSummaryReport.RunReport;


end;

procedure TCostPerUnitReport.GatherParams;
var
    tempstr : string;
begin
    // gather the parameters off the Report Input screen

      ReportDate := '';
      EnterpriseCode := '';
      IncludePerQtyBreakdown := false;
      EnterpriseBreakdown := False;
      DateFrom := '';
      DateTo := '';
      AnalysisFrom := 0;
      AnalysisTo := 9999;
      PencePerUnitBreakdown := false;
      NoEntUnits := 1.00;
      ReportUnitName := '';
      EnterpriseName := '';
      EntOverheadPercent := 100;
      DairyEnterprise := False;
      SpanYears := False;
      SummaryReportOnly := False;
      EnterpriseBreakdown2 := False;
      Qty2Name := '';
      Qty3Name := '';


      ReportDate := EntCostPerUnit.RepDate.Text;
      EnterpriseCode := EntCostPerUnit.EntCode.Text;
 //     IncludePerQtyBreakdown := EntCostPerUnit.IncludePerQtyBreakDown.Checked;
      if EntCostPerUnit.ReportType.ItemIndex = 1 then IncludePerQtyBreakdown := True;
      if EntCostPerUnit.ReportType.ItemIndex = 2 then EnterpriseBreakdown := True;
      if EntCostPerUnit.ReportType.ItemIndex = 3 then EnterpriseBreakdown2 := True;

      if EntCostPerUnit.CostUnitRepOutputRG.ItemIndex = 1 then SummaryReportOnly := True;

      If EntCostPerUnit.EntUsePreviousYear Then SpanYears := True;

      if EnterpriseCode <> '' then begin
                PencePerUnitBreakdown := EntCostPerUnit.PencePerUnit.checked;
                DateFrom := EntCostPerUnit.DateFrom.Text;
                DateTo := EntCostPerUnit.DateTo.Text;
                AnalysisFrom := strtoint(EntCostPerUnit.AnalysisFrom.Text);
                AnalysisTo := strtoint(EntCostPerUnit.AnalysisTo.Text);
                ReportUnitName := EntCostPerUnit.EntUnitName.text;
                try NoEntUnits := strtofloat(EntCostPerUnit.NoEntUnits.text)
                except
                end;
                if NoEntUnits = 0 then NoEntUnits := 1;

                Accsdatamodule.EntsFileDB.open;
                Accsdatamodule.EntsFileDB.Locate('EntCode',EnterpriseCode,[]);
                EnterpriseName := trim(Copy (Accsdatamodule.EntsFileDB['EntName'], 1, 16 ));
                TempStr := trim(Copy (Accsdatamodule.EntsFileDB['EntName'], 18, 3 ));
                Qty2Name := Accsdatamodule.EntsFileDB.FieldByName('Quantity2Name').AsString;
                if Qty2Name = '' then Qty2Name := 'Qty2';
                Qty3Name := Accsdatamodule.EntsFileDB.FieldByName('Quantity3Name').AsString;
                if Qty3Name = '' then Qty3Name := 'Qty2';
                if length(tempstr) > 0 then begin
                         EntOverheadPercent := (strtofloat(tempstr)/100);
                end
                    else EntOverheadPercent := 0;

                if EntCostPerUnit.EnterpriseType = ETDairy then DairyEnterprise := True;
      end;

end;

procedure TCostPerUnitReport.ProcessRecords;
var
   RangeFrom, RangeTo, I : Integer;
   tempreal, Qty, Qty2, Qty3, IncomePerQty, ExpensePerQty : real;
   RunningQty, RunningExtraQty, RunningExtraQtyPer : real;  // TGM AB 23/01/15
begin
    // Process all the nominal codes within the enterprise

    TotalEntIncome := 0.00;
    TotalEntExp := 0.00;
    GrossMargin := 0.00;
    GrossMarginPercent := 0.00;
    TotalOverheadExp := 0.00;
    TotalProductionCosts := 0.00;
    NetMargin := 0.00;
    NetMarginPercent := 0.00;
    QTY := 0.00;
    QTY2 := 0.00;
    QTY3 := 0.00;
    IncomePerQty := 0.00;
    ExpensePerQty := 0.00;

    TotalLitres := 0;
    TotalMilkSolids := 0;

    AccsDatamodule.CostPerUnitReportTableDB.close;
    AccsDatamodule.CostPerUnitReportTableDB.EmptyTable;
    AccsDatamodule.CostPerUnitReportTableDB.Open;

    Accsdatamodule.EntsFileDB.open;
    Accsdatamodule.EntsFileDB.Locate('EntCode',EnterpriseCode,[]);

    // Process income ranges

    IncomePerQty := 0.00;
    RangeFrom := Accsdatamodule.EntsFileDB['IncFrom'];
    RangeTo := Accsdatamodule.EntsFileDB['IncTo'];

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB['HighLightLabel'] := 'Enterprise Income';
    AccsDataModule.CostPerUnitReportTableDB.post;

    Accsdatamodule.NLFileDB.open;

    RunningQty := 0.00;    // TGM AB 23/01/15
    RunningExtraQty := 0.00;    // TGM AB 23/01/15
    RunningExtraQtyPer := 0.00;    // TGM AB 23/01/15

    For I := RangeFrom to RangeTo do begin

        Accsdatamodule.NLFileDB.Locate('NLNo',I,[]);
        if Accsdatamodule.NLFileDB['Active'] = True then begin
           AccsDataModule.CostPerUnitReportTableDB.append;
           AccsDataModule.CostPerUnitReportTableDB['NomCode'] := I;
           AccsDataModule.CostPerUnitReportTableDB['NomName'] := Accsdatamodule.NLFileDB['Name'];

           GatherTransactions(I);

         //  AccsDatamodule.CostPerUnitReportTableDB['NumberField1'] := Accsdatamodule.NLFileDB['Balance'] * -1;
         //  TotalEntIncome := TotalEntIncome + (Accsdatamodule.NLFileDB['Balance'] * -1);
           AccsDatamodule.CostPerUnitReportTableDB['NumberField1'] := (TotalAmount * -1);
           TotalEntIncome := TotalEntIncome + (TotalAmount * -1);
         //  try Tempreal := (Accsdatamodule.NLFileDB['Balance'] * -1) / NoEntUnits;
           try Tempreal := (TotalAmount * -1) / NoEntUnits;
           except tempreal := 0;
           end;
           AccsDatamodule.CostPerUnitReportTableDB['NumberField2'] := tempreal;
           if PencePerUnitBreakdown then AccsDatamodule.CostPerUnitReportTableDB['NumberField2'] := AccsDatamodule.CostPerUnitReportTableDB['NumberField2'] * 100;

  //         try Qty := EntCostPerUnit.GetTotalUnits(vartostr(I));
  //         except Qty := 0;
  //         end;
           Qty := TotalQty;
           Qty2 := TotalQty2;
           Qty3 := TotalQty3;

           AccsDatamodule.CostPerUnitReportTableDB['NumberField3'] := Qty;
           if Qty <> 0 then begin
               try Tempreal := (TotalAmount * -1) / Qty;
               except tempreal := 0;
               end;
               AccsDatamodule.CostPerUnitReportTableDB['NumberField4'] := tempreal;
               IncomePerQty := IncomePerQty  + tempreal;
               RunningQty := RunningQty + Qty; // TGM AB 23/01/15
           end
               else AccsDatamodule.CostPerUnitReportTableDB['NumberField4'] := 0;

           if EnterpriseBreakdown and not DairyEnterprise then begin

               AccsDatamodule.CostPerUnitReportTableDB['NumberField5'] := Qty2;
               if Qty2 <> 0 then begin
                    try Tempreal := (TotalAmount * -1) / Qty2;
                    except tempreal := 0;
                    end;
                    AccsDatamodule.CostPerUnitReportTableDB['NumberField6'] := tempreal;
                    RunningExtraQtyPer := RunningExtraQtyPer  + tempreal; // TGM AB 23/01/15
                    RunningExtraQty := RunningExtraQty + Qty2; //TGM AB 23/01/15
               end
                   else AccsDatamodule.CostPerUnitReportTableDB['NumberField6'] := 0;

           end;

           if EnterpriseBreakdown2 then begin

               AccsDatamodule.CostPerUnitReportTableDB['NumberField5'] := Qty3;
               if Qty3 <> 0 then begin
                    try Tempreal := (TotalAmount * -1) / Qty3;
                    except tempreal := 0;
                    end;
                    AccsDatamodule.CostPerUnitReportTableDB['NumberField6'] := tempreal;
                    RunningExtraQtyPer := RunningExtraQtyPer  + tempreal; // TGM AB 23/01/15
                    RunningExtraQty := RunningExtraQty + Qty3; //TGM AB 23/01/15
               end
                   else AccsDatamodule.CostPerUnitReportTableDB['NumberField6'] := 0;


           end;

               AccsDataModule.CostPerUnitReportTableDB.post;

        end;

    end;

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB.post;

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB['Label'] := 'Total Enterprise Income';
    AccsDatamodule.CostPerUnitReportTableDB['NumberField1Bold'] := TotalEntIncome;

    try Tempreal := TotalEntIncome / NoEntUnits;
    except tempreal := 0;
    end;

    AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] := tempreal;
    if PencePerUnitBreakdown then AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] := AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] * 100;

    // TGM AB 23/01/15

    AccsDatamodule.CostPerUnitReportTableDB['NumberField3Bold'] := RunningQty;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField4Bold'] := IncomePerQty;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField5Bold'] := RunningExtraQty;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField6Bold'] := RunningExtraQtyPer;

    // end TGM AB 23/01/15

    AccsDataModule.CostPerUnitReportTableDB.post;

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB.post;

    // Process Expenditure ranges

    ExpensePerQty := 0.00;
    RangeFrom := Accsdatamodule.EntsFileDB['ExpFrom'];
    RangeTo := Accsdatamodule.EntsFileDB['ExpTo'];

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB['HighLightLabel'] := 'Enterprise Expenditure';
    AccsDataModule.CostPerUnitReportTableDB.post;

    RunningQty := 0.00;    // TGM AB 23/01/15
    RunningExtraQty := 0.00;    // TGM AB 23/01/15
    RunningExtraQtyPer := 0.00;    // TGM AB 23/01/15

    For I := RangeFrom to RangeTo do begin

        Accsdatamodule.NLFileDB.Locate('NLNo',I,[]);
        if Accsdatamodule.NLFileDB['Active'] = True then begin
           AccsDataModule.CostPerUnitReportTableDB.append;
           AccsDataModule.CostPerUnitReportTableDB['NomCode'] := I;
           AccsDataModule.CostPerUnitReportTableDB['NomName'] := Accsdatamodule.NLFileDB['Name'];

           GatherTransactions(I);

      //     AccsDatamodule.CostPerUnitReportTableDB['NumberField1'] := Accsdatamodule.NLFileDB['Balance'];
      //     TotalEntExp := TotalEntExp + (Accsdatamodule.NLFileDB['Balance']);
           AccsDatamodule.CostPerUnitReportTableDB['NumberField1'] := TotalAmount;
           TotalEntExp := TotalEntExp + TotalAmount;
      //     try Tempreal := (Accsdatamodule.NLFileDB['Balance']) / NoEntUnits;
           try Tempreal := TotalAmount / NoEntUnits;
           except tempreal := 0;
           end;
           AccsDatamodule.CostPerUnitReportTableDB['NumberField2'] := tempreal;
           if PencePerUnitBreakdown then AccsDatamodule.CostPerUnitReportTableDB['NumberField2'] := AccsDatamodule.CostPerUnitReportTableDB['NumberField2'] * 100;

           Qty := TotalQty;
           Qty2 := TotalQty2;     // TGM AB 23/01/15
           Qty3 := TotalQty3;     // TGM AB 23/01/15

           AccsDatamodule.CostPerUnitReportTableDB['NumberField3'] := Qty;

           if Qty <> 0 then begin
                try Tempreal := TotalAmount / Qty;
                except tempreal := 0;
                end;
                AccsDatamodule.CostPerUnitReportTableDB['NumberField4'] := tempreal;
                ExpensePerQty := ExpensePerQty + tempreal;
                RunningQty := RunningQty + Qty; // TGM AB 23/01/15
           end
                else AccsDatamodule.CostPerUnitReportTableDB['NumberField4'] := 0;

           if EnterpriseBreakdown and not DairyEnterprise then begin

               AccsDatamodule.CostPerUnitReportTableDB['NumberField5'] := Qty2;
               if Qty2 <> 0 then begin
                    try Tempreal := (TotalAmount) / Qty2;               // TGM AB 23/01/15 was  * -1
                    except tempreal := 0;
                    end;
                    AccsDatamodule.CostPerUnitReportTableDB['NumberField6'] := tempreal;
                    RunningExtraQtyPer := RunningExtraQtyPer  + tempreal; // TGM AB 23/01/15
                    RunningExtraQty := RunningExtraQty + Qty2; //TGM AB 23/01/15
               end
                   else AccsDatamodule.CostPerUnitReportTableDB['NumberField6'] := 0;

           end;

           if EnterpriseBreakdown2 then begin

               AccsDatamodule.CostPerUnitReportTableDB['NumberField5'] := Qty3;
               if Qty3 <> 0 then begin
                    try Tempreal := (TotalAmount) / Qty3;              // TGM AB 23/01/15 was  * -1
                    except tempreal := 0;
                    end;
                    AccsDatamodule.CostPerUnitReportTableDB['NumberField6'] := tempreal;
                    RunningExtraQtyPer := RunningExtraQtyPer  + tempreal; // TGM AB 23/01/15
                    RunningExtraQty := RunningExtraQty + Qty3; //TGM AB 23/01/15
               end
                   else AccsDatamodule.CostPerUnitReportTableDB['NumberField6'] := 0;


           end;


           AccsDataModule.CostPerUnitReportTableDB.post;

        end;

    end;

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB.post;

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB['Label'] := 'Total Enterprise Expenses';
    AccsDatamodule.CostPerUnitReportTableDB['NumberField1Bold'] := TotalEntExp;
    try Tempreal := TotalEntExp / NoEntUnits;
    except tempreal := 0;
    end;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] := tempreal;
    if PencePerUnitBreakdown then AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] := AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] * 100;

    // TGM AB 23/01/15

    AccsDatamodule.CostPerUnitReportTableDB['NumberField3Bold'] := RunningQty;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField4Bold'] := ExpensePerQty;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField5Bold'] := RunningExtraQty;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField6Bold'] := RunningExtraQtyPer;

    // end TGM AB 23/01/15


    AccsDataModule.CostPerUnitReportTableDB.post;

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB.post;

    // Calculate Gross Margin

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB['Label'] := 'Enterprise Gross Margin';
    GrossMargin := TotalEntIncome - TotalEntExp;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField1Bold'] := GrossMargin;
    try TempReal := (TotalEntIncome - TotalEntExp) / NoEntUnits;
    except TempReal := 0;
    end;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] := TempReal;
    if PencePerUnitBreakdown then AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] := AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] * 100;

    // TGM AB 16/05/14    tempreal := IncomePerQty - ExpensePerQty;
    // TGM AB 16/05/14    AccsDatamodule.CostPerUnitReportTableDB['NumberField4Bold'] := TempReal;

    AccsDataModule.CostPerUnitReportTableDB.post;

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB['Label'] := 'Enterprise Gross Margin %';

    if TotalEntIncome < TotalEntExp then begin
                 try GrossMarginPercent := ((TotalEntExp - TotalEntIncome) / TotalEntIncome) *100;
                     GrossMarginPercent := tempreal * -1;
                 except GrossMarginPercent := 0;
                 end;
             end;
    if TotalEntIncome > TotalEntExp then begin
                 try GrossMarginPercent := ((TotalEntIncome - TotalEntExp) / TotalEntIncome) *100;
                 except GrossMarginPercent := 0;
                 end;
             end;
    if TotalEntIncome = TotalEntExp then GrossMarginPercent := 0;

    AccsDatamodule.CostPerUnitReportTableDB['NumberField1Bold'] := GrossMarginPercent;
    AccsDataModule.CostPerUnitReportTableDB.post;

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB.post;

    // Process Overhead Range

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB['HighLightLabel'] := 'Overhead Expenses at ' + vartostr(EntOverheadPercent * 100) + '%';
    AccsDataModule.CostPerUnitReportTableDB.post;

    RangeFrom := Cash1.xNomOhFrom;
    RangeTo := Cash1.xNomOhTo;

        For I := RangeFrom to RangeTo do begin

        Accsdatamodule.NLFileDB.Locate('NLNo',I,[]);
        if Accsdatamodule.NLFileDB['Active'] = True then begin
           AccsDataModule.CostPerUnitReportTableDB.append;
           AccsDataModule.CostPerUnitReportTableDB['NomCode'] := I;
           AccsDataModule.CostPerUnitReportTableDB['NomName'] := Accsdatamodule.NLFileDB['Name'];

           GatherTransactions(I);

           AccsDatamodule.CostPerUnitReportTableDB['NumberField1'] := (TotalAmount * EntOverheadPercent);
           TotalOverheadExp := TotalOverheadExp + (TotalAmount  * EntOverheadPercent);
       //    AccsDatamodule.CostPerUnitReportTableDB['NumberField1'] := (Accsdatamodule.NLFileDB['Balance'] * EntOverheadPercent);
       //    TotalOverheadExp := TotalOverheadExp + (Accsdatamodule.NLFileDB['Balance'] * EntOverheadPercent);

       //    try Tempreal := (Accsdatamodule.NLFileDB['Balance'] * EntOverheadPercent) / NoEntUnits;
           try Tempreal := (TotalAmount * EntOverheadPercent) / NoEntUnits;
           except tempreal := 0;
           end;

           AccsDatamodule.CostPerUnitReportTableDB['NumberField2'] := tempreal; //(Accsdatamodule.NLFileDB['Balance'] * EntOverheadPercent) / NoEntUnits;
           if PencePerUnitBreakdown then AccsDatamodule.CostPerUnitReportTableDB['NumberField2'] := AccsDatamodule.CostPerUnitReportTableDB['NumberField2'] * 100;

           AccsDataModule.CostPerUnitReportTableDB.post;

        end;

    end;



    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB.post;

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB['Label'] := 'Total Overhead Expenses';
    AccsDatamodule.CostPerUnitReportTableDB['NumberField1Bold'] := TotalOverheadExp;
    try Tempreal := TotalOverheadExp / NoEntUnits;
    except tempreal := 0;
    end;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] := tempreal;
    if PencePerUnitBreakdown then AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] := AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] * 100;

    AccsDataModule.CostPerUnitReportTableDB.post;

    // Total Production Costs

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB.post;

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB['Label'] := 'Total Production Costs';
    TotalProductionCosts := TotalEntExp + TotalOverheadExp;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField1Bold'] := TotalProductionCosts;

    try Tempreal := TotalProductionCosts / NoEntUnits;
    except tempreal := 0;
    end;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] := tempreal;
    if PencePerUnitBreakdown then AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] := AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] * 100;
    AccsDataModule.CostPerUnitReportTableDB.post;

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB.post;

    // Calculate Net Margin

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB['Label'] := 'Enterprise Net Margin';
    NetMargin :=  TotalEntIncome - TotalEntExp - TotalOverheadExp;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField1Bold'] := NetMargin;
    try Tempreal := NetMargin / NoEntUnits;
    except tempreal := 0;
    end;
    AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] := tempreal;
    if PencePerUnitBreakdown then AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] := AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'] * 100;
    AccsDataModule.CostPerUnitReportTableDB.post;

    AccsDataModule.CostPerUnitReportTableDB.append;
    AccsDataModule.CostPerUnitReportTableDB['Label'] := 'Enterprise Net Margin %';

    try NetMarginPercent := (NetMargin / TotalEntIncome) *100;
    except NetMarginPercent := 0;
    end;

    if NetMargin = TotalEntIncome then NetMarginPercent := 0;

    AccsDatamodule.CostPerUnitReportTableDB['NumberField1Bold'] := NetMarginPercent;
    AccsDataModule.CostPerUnitReportTableDB.post;
       
end;

procedure TCostPerUnitReport.GatherTransactions(NomAccount : Integer);
var
    i : integer;
    FirstTx, FirstTxThisYear : Integer;         // TGM AB 12/06/15
    SQLDateFrom, SQLDateTo : string;
    NominalName : string;
    QTY, QTY2, QTY3, TempReal : real;


begin
    // Gather together all transactions for selected nominal code

    (* Filter Inputs
        1. FirstTx of the year
        2. Date Range
        3. AnalysisCode Range
     *)
    TotalAmount := 0;
    TotalQty := 0;
    TotalQty2 := 0;
    TotalQty3 := 0;




    if SpanYears then begin           // If need to include transactions from last year

            Accsdatamodule.LastNLFileDB.open;
            Accsdatamodule.LastNLFileDB.Locate('NLNo',NomAccount,[]);
            FirstTx := Accsdatamodule.LastNLFileDB['FirstTx'];
            try NominalName := Accsdatamodule.LastNLFileDB['Name']
            except NominalName := '';
            end;

            AccsDatamodule.CostPerUnitReportQuery.Close;
            AccsDatamodule.CostPerUnitReportQuery.SQL.clear;
            AccsDatamodule.CostPerUnitReportQuery.SQL.Add('Select * from ''year-1'' where ((Nominal = ' + vartostr(NomAccount) + ') or (DebitAC = ' + vartostr(NomAccount) + ') or (CreditAC = ' + vartostr(NomAccount) + ')) and TxNo >= ' + inttostr(FirstTx));        // TGM AB 12/12/14
     //       AccsDatamodule.CostPerUnitReportQuery.SQL.Add('Select * from ''year-1'' where TxNo >= ' + inttostr(FirstTx) + ' and Nominal = ' + vartostr(NomAccount));
            if ((DateFrom <> '  /  /  ') and (DateTo <> '  /  /  ')) then begin
                 SQLDateFrom := copy(DateFrom,4,2) + '/' + copy(DateFrom,1,2) + '/' + copy(DateFrom,7,2);
                 SQLDateTo := copy(DateTo,4,2) + '/' + copy(DateTo,1,2) + '/' + copy(DateTo,7,2);
                 AccsDatamodule.CostPerUnitReportQuery.SQL.Add(' and (TxDate >= ''' + SQLDateFrom + ''' and TxDate <= ''' + SQLDateTo + ''')');
                 AccsDatamodule.CostPerUnitReportQuery.SQL.Add(' and ( Analysis >= ' + vartostr(AnalysisFrom) + ' and Analysis <= ' + vartostr(AnalysisTo) + ' )');
            end;
            AccsDatamodule.CostPerUnitReportQuery.Open;
            AccsDatamodule.CostPerUnitReportQuery.first;

            For i:= 1 to AccsDatamodule.CostPerUnitReportQuery.RecordCount do begin

               if AccsDatamodule.CostPerUnitReportQuery['TxType'] = 9 then begin    // include only type 9 transactions
                  if AccsDatamodule.CostPerUnitReportQuery['DebitAC'] = NomAccount then begin
                       TotalAmount := TotalAmount + AccsDatamodule.CostPerUnitReportQuery['NomAmount'];
                       TotalQty := TotalQty + AccsDatamodule.CostPerUnitReportQuery['Quantity'];
                       QTY := AccsDatamodule.CostPerUnitReportQuery['Quantity'];
                       try QTY2 := AccsDatamodule.CostPerUnitReportQuery['Quantity2']    // In Percent
                       except QTY2 := 0
                       end;
                       try QTY3 := AccsDatamodule.CostPerUnitReportQuery['Quantity3']    // In Percent
                       except QTY3 := 0
                       end;
                       TotalQty2 := TotalQty2 + QTY2;
                       TotalQty3 := TotalQty3 + QTY3;
                  end;
                  if AccsDatamodule.CostPerUnitReportQuery['CreditAC'] = NomAccount then begin
                       TotalAmount := TotalAmount - AccsDatamodule.CostPerUnitReportQuery['NomAmount'];
                       TotalQty := TotalQty + AccsDatamodule.CostPerUnitReportQuery['Quantity'];
                       QTY := AccsDatamodule.CostPerUnitReportQuery['Quantity'];
                       try QTY2 := AccsDatamodule.CostPerUnitReportQuery['Quantity2']    // In Percent
                       except QTY2 := 0
                       end;
                       try QTY3 := AccsDatamodule.CostPerUnitReportQuery['Quantity3']    // In Percent
                       except QTY3 := 0
                       end;
                       TotalQty2 := TotalQty2 + QTY2;
                       TotalQty3 := TotalQty3 + QTY3;
                  end;

                  If DairyEnterprise then begin
                     if pos('milk sales',ansilowercase(nominalname)) > 0 then begin

                          TotalLitres := TotalLitres + QTY;
                          try TempReal := 1.03*((QTY * (QTY2/100)) + (QTY * (QTY3/100)))
                          except TempReal := 0;
                          end;
                          TotalMilkSolids := TotalMilkSolids + TempReal;

                     end;


                  end;

               end;

               AccsDatamodule.CostPerUnitReportQuery.next;

            end;

            Accsdatamodule.LastNLFileDB.close;
    end;



    // Transactions This Year

    FirstTxThisYear := 0;                                    // TGM AB 12/06/15
    FirstTxThisYear := FullAudit.AuditFiles.FirstTxThisYear; // TGM AB 12/06/15

    Accsdatamodule.NLFileDB.Locate('NLNo',NomAccount,[]);
    FirstTx := Accsdatamodule.NLFileDB['FirstTx'];
    if FirstTx < FirstTxThisYear then FirstTx := FirstTxThisYear; // TGM AB 12/06/15
    try NominalName := Accsdatamodule.NLFileDB['Name']
    except NominalName := '';
    end;

    AccsDatamodule.CostPerUnitReportQuery.Close;
    AccsDatamodule.CostPerUnitReportQuery.SQL.clear;
    AccsDatamodule.CostPerUnitReportQuery.SQL.Add('Select * from Transactions where ((Nominal = ' + vartostr(NomAccount) + ') or (DebitAC = ' + vartostr(NomAccount) + ') or (CreditAC = ' + vartostr(NomAccount) + ')) and TxNo >= ' + inttostr(FirstTx));        // TGM AB 12/12/14
 //   AccsDatamodule.CostPerUnitReportQuery.SQL.Add('Select * from Transactions where TxNo >= ' + inttostr(FirstTx) + ' and Nominal = ' + vartostr(NomAccount));
    if ((DateFrom <> '  /  /  ') and (DateTo <> '  /  /  ')) then begin
        SQLDateFrom := copy(DateFrom,4,2) + '/' + copy(DateFrom,1,2) + '/' + copy(DateFrom,7,2);
        SQLDateTo := copy(DateTo,4,2) + '/' + copy(DateTo,1,2) + '/' + copy(DateTo,7,2);
        AccsDatamodule.CostPerUnitReportQuery.SQL.Add(' and (TxDate >= ''' + SQLDateFrom + ''' and TxDate <= ''' + SQLDateTo + ''')');
        AccsDatamodule.CostPerUnitReportQuery.SQL.Add(' and ( Analysis >= ' + vartostr(AnalysisFrom) + ' and Analysis <= ' + vartostr(AnalysisTo) + ' )');
    end;
    AccsDatamodule.CostPerUnitReportQuery.Open;
    AccsDatamodule.CostPerUnitReportQuery.first;

    For i:= 1 to AccsDatamodule.CostPerUnitReportQuery.RecordCount do begin

       if AccsDatamodule.CostPerUnitReportQuery['TxType'] = 9 then begin    // include only type 9 transactions
           if AccsDatamodule.CostPerUnitReportQuery['DebitAC'] = NomAccount then begin
               TotalAmount := TotalAmount + AccsDatamodule.CostPerUnitReportQuery['NomAmount'];
               TotalQty := TotalQty + AccsDatamodule.CostPerUnitReportQuery['Quantity'];
               QTY := AccsDatamodule.CostPerUnitReportQuery['Quantity'];
               try QTY2 := AccsDatamodule.CostPerUnitReportQuery['Quantity2']    // In Percent
               except QTY2 := 0
               end;
               try QTY3 := AccsDatamodule.CostPerUnitReportQuery['Quantity3']    // In Percent
               except QTY3 := 0
               end;
               TotalQty2 := TotalQty2 + QTY2;
               TotalQty3 := TotalQty3 + QTY3;
           end;
           if AccsDatamodule.CostPerUnitReportQuery['CreditAC'] = NomAccount then begin
               TotalAmount := TotalAmount - AccsDatamodule.CostPerUnitReportQuery['NomAmount'];
               TotalQty := TotalQty + AccsDatamodule.CostPerUnitReportQuery['Quantity'];
               QTY := AccsDatamodule.CostPerUnitReportQuery['Quantity'];
               try QTY2 := AccsDatamodule.CostPerUnitReportQuery['Quantity2']    // In Percent
               except QTY2 := 0
               end;
               try QTY3 := AccsDatamodule.CostPerUnitReportQuery['Quantity3']    // In Percent
               except QTY3 := 0
               end;
               TotalQty2 := TotalQty2 + QTY2;
               TotalQty3 := TotalQty3 + QTY3;
           end;

           If DairyEnterprise then begin
                     if pos('milk sales',ansilowercase(nominalname)) > 0 then begin

                          TotalLitres := TotalLitres + QTY;
                          try TempReal := 1.03*((QTY * (QTY2/100)) + (QTY * (QTY3/100)))
                          except TempReal := 0;
                          end;
                          TotalMilkSolids := TotalMilkSolids + TempReal;

                     end;
           end;
       end;

       AccsDatamodule.CostPerUnitReportQuery.next;

    end;


end;




procedure TCostPerUnitReport.QRDBText2Print(sender: TObject;
  var Value: String);
begin
 if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.CostPerUnitReportTableDB['NumberField1'], ffNumber , 8, 2);
end;

procedure TCostPerUnitReport.QRDBText4Print(sender: TObject;
  var Value: String);
begin
 if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.CostPerUnitReportTableDB['NumberField2'], ffNumber , 8, 2);
end;

procedure TCostPerUnitReport.QRDBText7Print(sender: TObject;
  var Value: String);
begin
 if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.CostPerUnitReportTableDB['NumberField1Bold'], ffNumber , 8, 2);
end;

procedure TCostPerUnitReport.QRDBText8Print(sender: TObject;
  var Value: String);
begin
  if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.CostPerUnitReportTableDB['NumberField2Bold'], ffNumber , 8, 2);
end;

procedure TCostPerUnitReport.QRDBQtyPrint(sender: TObject;
  var Value: String);
begin
  if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.CostPerUnitReportTableDB['NumberField3'], ffNumber , 8, 2);
end;

procedure TCostPerUnitReport.QRDBQtyBoldPrint(sender: TObject;
  var Value: String);
begin
  if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.CostPerUnitReportTableDB['NumberField3Bold'], ffNumber , 8, 2);
end;

procedure TCostPerUnitReport.QRDBPerQtyPrint(sender: TObject;
  var Value: String);
begin
  if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.CostPerUnitReportTableDB['NumberField4'], ffNumber , 8, 2);
end;

procedure TCostPerUnitReport.QRDBPerQtyBoldPrint(sender: TObject;
  var Value: String);
begin
  if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.CostPerUnitReportTableDB['NumberField4Bold'], ffNumber , 8, 2);
end;

procedure TCostPerUnitReport.EntField5Print(sender: TObject;
  var Value: String);
begin
  if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.CostPerUnitReportTableDB['NumberField5'], ffNumber , 8, 2);
end;

procedure TCostPerUnitReport.EntField6Print(sender: TObject;
  var Value: String);
begin
  if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.CostPerUnitReportTableDB['NumberField6'], ffNumber , 8, 2);
end;

procedure TCostPerUnitReport.EntField5BoldPrint(sender: TObject;
  var Value: String);
begin
  if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.CostPerUnitReportTableDB['NumberField5Bold'], ffNumber , 8, 2);
end;

procedure TCostPerUnitReport.EntField6BoldPrint(sender: TObject;
  var Value: String);
begin
  if value = null then value := ' '
    else value := FloatToStrF(AccsDatamodule.CostPerUnitReportTableDB['NumberField6Bold'], ffNumber , 8, 2);
end;

end.
