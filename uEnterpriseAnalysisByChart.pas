{
 16/11/11 [V4.1 R0.8] / SP New - uEnterpriseAnalysisByChart - Aka "Farm Summary / Business Summary" depending on modules :@.

 19/01/12 [V4.1 R1.3] / SP - Ensure the pie chart year select combo is drawn over the pie area of the screen (right side)

 18/04/13 [V4.1 R4.7] /MK Bug Fix - UpperCase (FSeriesData[i].EnterpriseName) to match UpperCase(AEnterpriseName).
}

unit uEnterpriseAnalysisByChart;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uBaseForm, ActnList, dxBar,  Db, DBTables, dxBarExtItems, cxControls, dxStatusBar,
  cxSplitter, TeEngine, TeeTools, Series, TeeProcs, Chart, DBChart,
  cxLabel, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  ExtCtrls, uEnterpriseLineSeriesData, TeeAntiAlias, StdCtrls, cxButtons,
  uAccounts;

type
  TfmEnterpriseAnalysisByChart = class(TBaseForm)
    dxBarControlContainerItem: TdxBarControlContainerItem;
    pChartContainer: TPanel;
    Chart3Container: TPanel;
    DBChart3: TDBChart;
    GridBandTool8: TGridBandTool;
    GridBandTool9: TGridBandTool;
    Chart2Container: TPanel;
    DBChart2: TDBChart;
    GridBandTool5: TGridBandTool;
    GridBandTool6: TGridBandTool;
    Chart1Container: TPanel;
    DBChart1: TDBChart;
    GridBandTool1: TGridBandTool;
    GridBandTool3: TGridBandTool;
    PieChart1: TChart;
    MarginPieSeries1: TPieSeries;
    ChartTool1: TAntiAliasTool;
    PieChart2: TChart;
    MarginPieSeries2: TPieSeries;
    AntiAliasTool1: TAntiAliasTool;
    PieChart3: TChart;
    MarginPieSeries3: TPieSeries;
    AntiAliasTool2: TAntiAliasTool;
    DBChart5: TDBChart;
    GridBandTool7: TGridBandTool;
    DefaultEnterpriseSeries: TLineSeries;
    pEntFilter: TPanel;
    cmboEnterprise: TcxComboBox;
    cxLabel1: TcxLabel;
    pYearView: TPanel;
    cxLabel2: TcxLabel;
    cmboYearType: TcxComboBox;
    procedure FormCreate(Sender: TObject);
    procedure cmboEnterprisePropertiesEditValueChanged(Sender: TObject);
    procedure DBChart1GetAxisLabel(Sender: TChartAxis;
      Series: TChartSeries; ValueIndex: Integer; var LabelText: String);
    procedure cmboYearTypePropertiesEditValueChanged(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    function DefaultEnterpriseSeriesGetPointerStyle(Sender: TChartSeries;
      ValueIndex: Integer): TSeriesPointerStyle;
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FTempTable,
    FTempEntsTable : TTable;
    FTempQuery : TQuery;
    FCurrentMonth : Word;
    FSeriesData : array of TEnterpriseLineSeriesData;
    FMaxAllEntsDataValue : Double;
    FMinAllEntsDataValue : Double;

    // used to hold monthly margins figures for this year
    FThisYearAllEntMarginData : TSeriesData;
    // used to hold monthly margins figures for last year
    FLastYearAllEntMarginData : TSeriesData;

    // used to hold individual (1..12) monthly income figures for this year
    FThisYearAllEntIncData : TSeriesData;
    // used to hold individual (1..12) monthly expense figures for this year
    FThisYearAllEntExpData : TSeriesData;

    // used to hold individual (1..12) monthly income figures for last year
    FLastYearAllEntIncData : TSeriesData;
    // used to hold individual (1..12) monthly expense figures for last year
    FLastYearAllEntExpData : TSeriesData;

    nMonths : array[1..12] of string;

    procedure LoadChartData();
    procedure ProcessLinesSeries(AEntName : string);
    procedure ProcessPieChart;
    procedure ProcessChartData;
    function GetSeries(ASeriesName : string; AChart : TDBChart) : TChartSeries;
    function GetEntSeriesData(AEnterpriseName : string) : TEnterpriseLineSeriesData;
    procedure DrawCharts();
    procedure SetChartAxisMinMaxValues(AChart : TDBChart);
//    procedure SetChartAxisMinMaxValues(AChart : TDBChart;
//      ASeries : array of TLineSeries);
  protected
     procedure SetupForm;override;
     procedure CleanUp();override;
  public
    { Public declarations }
    class procedure ShowSummary();
  end;

var
  fmEnterpriseAnalysisByChart: TfmEnterpriseAnalysisByChart;

implementation
uses AccsData, uBudgetTypes, Types, VARS;

{$R *.DFM}

{ TfmEnterpriseAnalysisByChart }

procedure TfmEnterpriseAnalysisByChart.SetupForm;
var
   txDate : TDateTime;
   y, d : Word;
   i, Index : Integer;
begin
  inherited;

   FillChar(FThisYearAllEntMarginData, SizeOf(TSeriesData),0);
   FillChar(FLastYearAllEntMarginData, SizeOf(TSeriesData),0);

   txDate := AccsDataModule.MaxTransactionDate;
   if ( txDate > 0 ) then
      DecodeDate(txDate, y, FCurrentMonth, d )
   else
      FCurrentMonth := 1;

   AccsDataModule.BudgetCalculator := TBudgetCalculator.Create(FCurrentMonth); // calculates the nominal account actual figure for each month

   Index := 1;
   for i:=cash1.xfinmonth to 12 do
   begin
      nMonths[Index] := ShortMonths[i];
      Inc(Index);
   end;

   for i := 1 to cash1.xfinmonth-1 do begin
      nMonths[Index] := ShortMonths[i];
      Inc(Index);
   end;

   FTempTable := TTable.Create(nil);
   FTempTable.DatabaseName := AccsDataModule.AccsDataBase.DatabaseName;
   with FTempTable do
      begin
         FieldDefs.Clear;
         IndexDefs.Clear;
         TableName := 'tmpYearlyData';
         if Exists then
            DeleteTable;

         with FieldDefs do
            begin
               Add('NominalID',ftInteger,0,FALSE);
               Add('NomName',ftString,30,FALSE);
               Add('NomType',ftString,30,FALSE);
               Add('EnterpriseCode',ftString,10,FALSE);

               // Budgeted
               Add('YearBudget',ftFloat,0,FALSE);
               Add('BudgetToDate',ftFloat,0,FALSE);
               Add('Jan',ftFloat);
               Add('Feb',ftFloat);
               Add('Mar',ftFloat);
               Add('Apr',ftFloat);
               Add('May',ftFloat);
               Add('Jun',ftFloat);
               Add('Jul',ftFloat);
               Add('Aug',ftFloat);
               Add('Sep',ftFloat);
               Add('Oct',ftFloat);
               Add('Nov',ftFloat);
               Add('Dec',ftFloat);

               // Actual - This Year
               Add('ActualYearTotal',ftFloat);
               Add('ActualJan',ftFloat);
               Add('ActualFeb',ftFloat);
               Add('ActualMar',ftFloat);
               Add('ActualApr',ftFloat);
               Add('ActualMay',ftFloat);
               Add('ActualJun',ftFloat);
               Add('ActualJul',ftFloat);
               Add('ActualAug',ftFloat);
               Add('ActualSep',ftFloat);
               Add('ActualOct',ftFloat);
               Add('ActualNov',ftFloat);
               Add('ActualDec',ftFloat);

               // Last Year
               Add('LYYearTotal',ftFloat);
               Add('LYJan',ftFloat);
               Add('LYFeb',ftFloat);
               Add('LYMar',ftFloat);
               Add('LYApr',ftFloat);
               Add('LYMay',ftFloat);
               Add('LYJun',ftFloat);
               Add('LYJul',ftFloat);
               Add('LYAug',ftFloat);
               Add('LYSep',ftFloat);
               Add('LYOct',ftFloat);
               Add('LYNov',ftFloat);
               Add('LYDec',ftFloat);

               Add('ActiveNominalRecord',ftBoolean);

               Add('AlteredBudget',ftBoolean,0,FALSE);
            end;
         with IndexDefs do
            begin
              Clear;
              Add('pk_NominalId', 'NominalId', [ixPrimary, ixUnique]);
              Add('ix_NomType', 'NomType', [ixCaseInsensitive]);
            end;
         CreateTable;
         Open;
      end;

   FTempQuery := TQuery.Create(nil);
   FTempQuery.DatabaseName := FTempTable.DatabaseName;

   FTempEntsTable := TTable.Create(nil);
   with FTempEntsTable do
     begin
        DatabaseName := AccsDataModule.AccsDataBase.DatabaseName;
        TableName := 'tEntsTable';
        FieldDefs.Clear;
        IndexDefs.Clear;
        FieldDefs.Add('EntCode',ftString,4,FALSE);
        FieldDefs.Add('EntName',ftString,20,FALSE);
        FieldDefs.Add('EntColor',ftInteger,0,FALSE);
        CreateTable;
        Open;
     end;

   with FTempQuery do
      try
         DatabaseName := AccsDataModule.AccsDataBase.DatabaseName;
         SQL.Clear;
         SQL.Add('INSERT INTO '+FTempEntsTable.TableName+' (EntCode, EntName, EntColor) ');
         SQL.Add('SELECT E.EntCode, E.EntName, E.Color');
         SQL.Add('FROM '+ AccsDataModule.EntsFileDb.TableName+' E ');
         SQL.Add('WHERE E."Active" = True');
         ExecSQL;
      finally
         Free;
      end;

   with cmboEnterprise.Properties.Items do
      begin
         Clear;
         BeginUpdate;
         FTempEntsTable.Open;
         FTempEntsTable.First;
         Add('ALL ENTERPRISES');
         while not FTempEntsTable.EOF do
            begin
               FTempEntsTable.Edit;
               FTempEntsTable.FieldByName('EntName').AsString := Trim(Copy( FTempEntsTable.FieldByName('EntName').AsString,1,17 ) );
               FTempEntsTable.Post;
               Add( FTempEntsTable.FieldByName('EntName').AsString );
               FTempEntsTable.Next;
            end;
         EndUpdate;
      end;
   cmboEnterprise.ItemIndex := 0;

   with cmboYearType.Properties.Items do
      begin
         Clear;
         BeginUpdate;
         Add('This Year');
         Add('Last Year');
//         Add('This Year vs. Last Year');
         EndUpdate;
      end;
   cmboYearType.ItemIndex := 0;

   {
   with cmboHeadingType.Properties.Items do
      begin
         Clear;
         BeginUpdate;
         Add('Income');
         Add('Expenditure');
         EndUpdate;
      end;
   cmboHeadingType.ItemIndex := 0;
   }

   DBChart1.Title.Text.Clear;

   DBChart2.Legend.Assign(DBChart1.Legend);
   DBChart3.Legend.Assign(DBChart1.Legend);
   DBChart2.Title.Assign(DBChart1.Title);
   DBChart3.Title.Assign(DBChart1.Title);
   LoadChartData;
end;

procedure TfmEnterpriseAnalysisByChart.FormCreate(Sender: TObject);
begin
  inherited;
  SetupForm();
end;

procedure TfmEnterpriseAnalysisByChart.DrawCharts;
var
   newHeight : Integer;
   dxBar : TdxBar;
begin
   newHeight := Trunc(pChartContainer.Height / 3);
   Chart2Container.Height := newHeight;
   Chart3Container.Height := newHeight;
   PieChart1.Width := Trunc(Chart1Container.Width * 0.3);
   PieChart2.Width := PieChart1.Width;
   PieChart3.Width := PieChart1.Width;

   dxBarControlContainerItem.Control := pEntFilter;
   pEntFilter.Width := Width - 135;
   // Align the pViewPanel against the right of DBChart
   // so that the drop down list is over the pie chart
   // side of the screen. 
   pYearView.Left := (DBChart2.Left + DBChart2.Width) - 86;
   pEntFilter.Repaint;
   pYearView.Repaint;
   dxBarControlContainerItem.Control.Repaint;

   PieChart1.Show;
   PieChart2.Show;
   PieChart3.Show;
end;

function TfmEnterpriseAnalysisByChart.GetEntSeriesData(
  AEnterpriseName: string): TEnterpriseLineSeriesData;
var
 i : Integer;
begin
   Result := nil;
   for i := 0 to Length(FSeriesData)-1 do
      begin
         //   18/04/13 [V4.1 R4.7] /MK Bug Fix - UpperCase (FSeriesData[i].EnterpriseName) to match UpperCase(AEnterpriseName).
         if ( UpperCase(FSeriesData[i].EnterpriseName) = AEnterpriseName ) then
            begin
               Result := FSeriesData[i];
               Break;
            end;
      end;
end;

function TfmEnterpriseAnalysisByChart.GetSeries(
  ASeriesName: string; AChart : TDBChart): TChartSeries;
var
   i : Integer;
begin
   Result := nil;
   for i := 0 to AChart.SeriesList.Count-1 do
      begin
         if ( AChart.SeriesList[i].Name = ASeriesName) then
             begin
                Result := AChart.SeriesList[i];
                Break;
             end;
      end;
end;

procedure TfmEnterpriseAnalysisByChart.LoadChartData;
var
   NominalAccount : TNominalAccount;
   BudgetRecord : TBudgetRecord;
begin
   if FTempTable = nil then Exit;

   FTempTable.Close;
   FTempTable.EmptyTable;
   FTempTable.Open;

   FTempTable.DisableControls;
   try
      // Get This Years Budget Figures
      AccsDataModule.GetBudgets(BudgetThisYear);

      with AccsDataModule.Budgets do
         begin
            First;
            while not eof do
               begin
                  NominalAccount := AccsDataModule.Accounts.GetNominalAccount(FieldByName('NominalID').AsInteger);
                  if ( NominalAccount = nil ) then
                     begin
                        Next;
                        Continue;
                     end;

                  FTempTable.Append;
                  try
                     FTempTable.FieldByName('NominalID').AsInteger := FieldByName('NominalID').AsInteger;
                     FTempTable.FieldByName('NomName').AsString := FieldByName('NomName').AsString;
                     FTempTable.FieldByName('YearBudget').AsFloat := FieldByName('YearBudget').AsFloat;
                     try
                        FTempTable.FieldByName('EnterpriseCode').AsString := NominalAccount.EntCode;
                        if ( NominalAccount.AccountType in [natEntIncome, natNonEntIncome, natPrivateIncome ] ) then
                           FTempTable.FieldByName('NomType').AsString := 'Income'
                        else if ( NominalAccount.AccountType in [ natEntExpense, natOverhead, natPrivateExpense ] ) then
                           FTempTable.FieldByName('NomType').AsString := 'Expense'
                        else
                           FTempTable.FieldByName('NomType').AsString := 'Unknown';
                     except
                        on e : exception do
                           begin
                              ShowMessage(E.Message);
                           end;
                     end;

                     FTempTable.FieldByName('Jan').AsFloat := FieldByName('Jan').AsFloat;
                     FTempTable.FieldByName('Feb').AsFloat := FieldByName('Feb').AsFloat;
                     FTempTable.FieldByName('Mar').AsFloat := FieldByName('Mar').AsFloat;
                     FTempTable.FieldByName('Apr').AsFloat := FieldByName('Apr').AsFloat;
                     FTempTable.FieldByName('May').AsFloat := FieldByName('May').AsFloat;
                     FTempTable.FieldByName('Jun').AsFloat := FieldByName('Jun').AsFloat;
                     FTempTable.FieldByName('Jul').AsFloat := FieldByName('Jul').AsFloat;
                     FTempTable.FieldByName('Aug').AsFloat := FieldByName('Aug').AsFloat;
                     FTempTable.FieldByName('Sep').AsFloat := FieldByName('Sep').AsFloat;
                     FTempTable.FieldByName('Oct').AsFloat := FieldByName('Oct').AsFloat;
                     FTempTable.FieldByName('Nov').AsFloat := FieldByName('Nov').AsFloat;
                     FTempTable.FieldByName('Dec').AsFloat := FieldByName('Dec').AsFloat;

                     // Actual figures
                     BudgetRecord := AccsDataModule.BudgetCalculator.GetBudgetRecordByNominalId(FTempTable.FieldByName('NominalID').AsInteger);
                     if ( BudgetRecord <> nil ) then
                        begin
                           FTempTable.FieldByName('ActualJan').AsFloat := BudgetRecord.ActualData.JanTotal;
                           FTempTable.FieldByName('ActualFeb').AsFloat := BudgetRecord.ActualData.FebTotal;
                           FTempTable.FieldByName('ActualMar').AsFloat := BudgetRecord.ActualData.MarTotal;
                           FTempTable.FieldByName('ActualApr').AsFloat := BudgetRecord.ActualData.AprTotal;
                           FTempTable.FieldByName('ActualMay').AsFloat := BudgetRecord.ActualData.MayTotal;
                           FTempTable.FieldByName('ActualJun').AsFloat := BudgetRecord.ActualData.JunTotal;
                           FTempTable.FieldByName('ActualJul').AsFloat := BudgetRecord.ActualData.JulTotal;
                           FTempTable.FieldByName('ActualAug').AsFloat := BudgetRecord.ActualData.AugTotal;
                           FTempTable.FieldByName('ActualSep').AsFloat := BudgetRecord.ActualData.SepTotal;
                           FTempTable.FieldByName('ActualOct').AsFloat := BudgetRecord.ActualData.OctTotal;
                           FTempTable.FieldByName('ActualNov').AsFloat := BudgetRecord.ActualData.NovTotal;
                           FTempTable.FieldByName('ActualDec').AsFloat := BudgetRecord.ActualData.DecTotal;

                           FTempTable.FieldByName('ActualYearTotal').AsFloat := BudgetRecord.ActualData.YearTotal;
                        end;

                     FTempTable.Post;
                  except
                     FTempTable.Cancel;
                     Screen.Cursor := crDefault;
                     MessageDlg(Format('An error occurred while creating budget record "%s"', [FieldByName('NomName').AsString]),mtError,[mbOk],0);
                     Abort;
                  end;
                  Next;
               end;

            // Get Last Year's Actual Figures
            AccsDataModule.GetBudgets(LastYearActual);

            First;
            while not eof do
               begin

                  NominalAccount := AccsDataModule.Accounts.GetNominalAccount(FieldByName('NominalID').AsInteger);
                  if ( NominalAccount = nil ) then
                     begin
                        Next;
                        Continue;
                     end;

                  if FTempTable.Locate('NominalID', FieldByName('NominalID').AsInteger, []) then
                     FTempTable.Edit
                  else
                     begin
                        FTempTable.Append;
                        FTempTable.FieldByName('NominalID').AsInteger := FieldByName('NominalID').AsInteger;
                        FTempTable.FieldByName('NomName').AsString := FieldByName('NomName').AsString;

                        try
                           FTempTable.FieldByName('EnterpriseCode').AsString := NominalAccount.EntCode;
                           if ( NominalAccount.AccountType in [natEntIncome, natNonEntIncome, natPrivateIncome ] ) then
                              FTempTable.FieldByName('NomType').AsString := 'Income'
                           else if ( NominalAccount.AccountType in [ natEntExpense, natOverhead, natPrivateExpense ] ) then
                              FTempTable.FieldByName('NomType').AsString := 'Expense'
                           else
                              FTempTable.FieldByName('NomType').AsString := 'Unknown';
                        except
                           on e : exception do
                              begin
                                 ShowMessage(E.Message);
                              end;
                        end;
                     end;

                  try
                     FTempTable.FieldByName('LYYearTotal').AsFloat := FieldByName('YearBudget').AsFloat;
                     FTempTable.FieldByName('LYJan').AsFloat := FieldByName('Jan').AsFloat;
                     FTempTable.FieldByName('LYFeb').AsFloat := FieldByName('Feb').AsFloat;
                     FTempTable.FieldByName('LYMar').AsFloat := FieldByName('Mar').AsFloat;
                     FTempTable.FieldByName('LYApr').AsFloat := FieldByName('Apr').AsFloat;
                     FTempTable.FieldByName('LYMay').AsFloat := FieldByName('May').AsFloat;
                     FTempTable.FieldByName('LYJun').AsFloat := FieldByName('Jun').AsFloat;
                     FTempTable.FieldByName('LYJul').AsFloat := FieldByName('Jul').AsFloat;
                     FTempTable.FieldByName('LYAug').AsFloat := FieldByName('Aug').AsFloat;
                     FTempTable.FieldByName('LYSep').AsFloat := FieldByName('Sep').AsFloat;
                     FTempTable.FieldByName('LYOct').AsFloat := FieldByName('Oct').AsFloat;
                     FTempTable.FieldByName('LYNov').AsFloat := FieldByName('Nov').AsFloat;
                     FTempTable.FieldByName('LYDec').AsFloat := FieldByName('Dec').AsFloat;

                     FTempTable.FieldByName('ActiveNominalRecord').AsBoolean := not ((FTempTable.FieldByName('LYYearTotal').AsFloat=0 ) and
                                                                                     (FTempTable.FieldByName('YearBudget').AsFloat=0) and
                                                                                     (FTempTable.FieldByName('ActualYearTotal').AsFloat=0));

                     FTempTable.Post;
                  except
                     FTempTable.Cancel;
                     Screen.Cursor := crDefault;
                     MessageDlg(Format('An error occurred while creating budget record "%s"', [FieldByName('NomName').AsString]),mtError,[mbOk],0);
                     Abort;
                  end;
                  Next;
               end;
         end;

   ProcessChartData;

   finally

   end;
end;

procedure TfmEnterpriseAnalysisByChart.ProcessChartData;
var
   i, j : Integer;
   EntSeriesData : TEnterpriseLineSeriesData;
begin

   for i := 1 to cmboEnterprise.Properties.Items.Count-1 do
      begin
         EntSeriesData := TEnterpriseLineSeriesData.Create(cmboEnterprise.Properties.Items[i]);
         EntSeriesData.LoadData();
         SetLength(FSeriesData, Length(FSeriesData)+1);
         FSeriesData[Length(FSeriesData)-1] := EntSeriesData;
      end;

   FMaxAllEntsDataValue := 0;
   FMinAllEntsDataValue := 0;

   FillChar(FThisYearAllEntMarginData, SizeOf(TSeriesData),0);
   FillChar(FLastYearAllEntMarginData, SizeOf(TSeriesData),0);

   // used to hold ndividual (1..12) monthly income figures for this year
   FillChar(FThisYearAllEntIncData, SizeOf(TSeriesData),0);
   // used to hold ndividual (1..12) monthly expense figures for this year
   FillChar(FThisYearAllEntExpData, SizeOf(TSeriesData),0);

   // used to hold individual (1..12) monthly income figures for last year
   FillChar(FLastYearAllEntIncData, SizeOf(TSeriesData),0);
   // used to hold individual (1..12) monthly expense figures for last year
   FillChar(FLastYearAllEntExpData, SizeOf(TSeriesData),0);

   for i := 0 to Length(FSeriesData)-1 do
      begin
         for j := 1 to 12 do
            begin
                // store ent cumulative inc/exp for this year
                FThisYearAllEntIncData[j] := FThisYearAllEntIncData[j] + FSeriesData[i].ThisYearDataInc[j];
                FThisYearAllEntExpData[j] := FThisYearAllEntExpData[j] + FSeriesData[i].ThisYearDataExp[j];

                // store ent cumulative inc/exp for last year
                FLastYearAllEntIncData[j] := FLastYearAllEntIncData[j] + FSeriesData[i].LastYearDataInc[j];
                FLastYearAllEntExpData[j] := FLastYearAllEntExpData[j] + FSeriesData[i].LastYearDataExp[j];

                // store ent cumulative margin's
                FThisYearAllEntMarginData[j] := FThisYearAllEntMarginData[j] + FSeriesData[i].ThisYearMargin[j];
                FLastYearAllEntMarginData[j] := FLastYearAllEntMarginData[j] + FSeriesData[i].LastYearMargin[j];
            end;
      end;

   for i := 1 to 12 do
      begin
         if (FThisYearAllEntMarginData[i]>FMaxAllEntsDataValue) then
            begin
               FMaxAllEntsDataValue := FThisYearAllEntMarginData[i];
            end;
         if (FLastYearAllEntMarginData[i]>FMaxAllEntsDataValue) then
            begin
               FMaxAllEntsDataValue := FLastYearAllEntMarginData[i];
            end;

         if (FThisYearAllEntMarginData[i]<FMinAllEntsDataValue) then
            begin
               FMinAllEntsDataValue := FThisYearAllEntMarginData[i];
            end;
         if (FLastYearAllEntMarginData[i]<FMinAllEntsDataValue) then
            begin
               FMinAllEntsDataValue := FLastYearAllEntMarginData[i];
            end;
      end;
end;

procedure TfmEnterpriseAnalysisByChart.ProcessLinesSeries(
  AEntName: string);
var
   EntName : String;
   EntColor : TColor;
   i : Integer;
   ThisSeries : TLineSeries;
   tdouble : Double;
   EntSeriesData : TEnterpriseLineSeriesData;
begin

   if not FFormShowing then Exit;

   DBChart1.Legend.Items.Clear;

   DBChart1.Title.Caption := 'Enterprise Margin - This Year vs. Last Year';
   DBChart2.Title.Caption := 'Enterprise Income - This Year vs. Last Year';
   DBChart3.Title.Caption := 'Enterprise Expenditure - This Year vs. Last Year';

   for i := 0 to DBChart1.SeriesCount -1 do
       DBChart1.Series[i].Active := False;
   for i := 0 to DBChart2.SeriesCount -1 do
       DBChart2.Series[i].Active := False;
   for i := 0 to DBChart3.SeriesCount -1 do
       DBChart3.Series[i].Active := False;

   if (UPPERCASE(AEntName) = 'ALL ENTERPRISES') then
      begin
          ThisSeries := GetSeries('AllEntThisYearMargin',DBChart1) as TLineSeries;
          if ThisSeries = nil then
             begin
                // AllEntThisYearMargin Series
                ThisSeries := CloneChartSeries(DefaultEnterpriseSeries) as TLineSeries;
                ThisSeries.ParentChart := DBChart1;
                ThisSeries.SeriesColor := $0089CD23;
                ThisSeries.Title := 'This Year Enterprise Margin';
                ThisSeries.Name := 'AllEntThisYearMargin';
                ThisSeries.Active := False;
                (ThisSeries as TLineSeries).OnGetPointerStyle := DefaultEnterpriseSeriesGetPointerStyle;
             end;

          ThisSeries.Clear;
          ThisSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                ThisSeries.Add(FThisYearAllEntMarginData[i], IntToStr(i));
             end;
          ThisSeries.Active := True;

          ThisSeries := GetSeries('AllEntLastYearMargin',DBChart1) as TLineSeries;
          if ThisSeries = nil then
             begin
                // AllEntLastYearMargin Series
                ThisSeries := CloneChartSeries(DefaultEnterpriseSeries) as TLineSeries;
                ThisSeries.ParentChart := DBChart1;
                ThisSeries.SeriesColor := $005838F1;
                ThisSeries.Title := 'Last Year Enterprise Margin';
                ThisSeries.Name := 'AllEntLastYearMargin';
                ThisSeries.Active := False;
                (ThisSeries as TLineSeries).OnGetPointerStyle := DefaultEnterpriseSeriesGetPointerStyle;
             end;

          ThisSeries.Clear;
          ThisSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                ThisSeries.Add(FLastYearAllEntMarginData[i], IntToStr(i));
             end;
          ThisSeries.Active := True;

          { This Year vs. Last Year Income Series }

          ThisSeries := GetSeries('AllEntThisYearInc', DBChart2) as TLineSeries;
          if ThisSeries = nil then
             begin
                ThisSeries := CloneChartSeries(DefaultEnterpriseSeries) as TLineSeries;
                ThisSeries.ParentChart := DBChart2;
                ThisSeries.SeriesColor := $0089CD23;
                ThisSeries.Title := 'This Year Enterpise Income';
                ThisSeries.Name := 'AllEntThisYearInc';
                ThisSeries.Active := True;
                (ThisSeries as TLineSeries).OnGetPointerStyle := DefaultEnterpriseSeriesGetPointerStyle;
             end;

          ThisSeries.Clear;
          ThisSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                ThisSeries.Add(FThisYearAllEntIncData[i], IntToStr(i));
             end;
          ThisSeries.Active := True;

          ThisSeries := GetSeries('AllEntLastYearInc', DBChart2) as TLineSeries;
          if ThisSeries = nil then
             begin
                ThisSeries := CloneChartSeries(DefaultEnterpriseSeries) as TLineSeries;
                ThisSeries.ParentChart := DBChart2;
                ThisSeries.SeriesColor := $005838F1;
                ThisSeries.Title := 'Last Year Enterprise Income';
                ThisSeries.Name := 'AllEntLastYearInc';
                ThisSeries.Active := True;
                (ThisSeries as TLineSeries).OnGetPointerStyle := DefaultEnterpriseSeriesGetPointerStyle;
             end;

          ThisSeries.Clear;
          ThisSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                ThisSeries.Add(FLastYearAllEntIncData[i], IntToStr(i));
             end;
          ThisSeries.Active := True;

          { End - This Year vs. Last Year Income Series }

          { This Year vs. Last Year Expense Series }

          ThisSeries := GetSeries('AllEntThisYearExp', DBChart3) as TLineSeries;
          if ThisSeries = nil then
             begin
                ThisSeries := CloneChartSeries(DefaultEnterpriseSeries) as TLineSeries;
                ThisSeries.ParentChart := DBChart3;
                ThisSeries.SeriesColor := $0089CD23;
                ThisSeries.Title := 'This Year Enterprise Expenditure';
                ThisSeries.Name := 'AllEntThisYearExp';
                ThisSeries.Active := True;
                (ThisSeries as TLineSeries).OnGetPointerStyle := DefaultEnterpriseSeriesGetPointerStyle;
             end;

          ThisSeries.Clear;
          ThisSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                ThisSeries.Add(FThisYearAllEntExpData[i], IntToStr(i));
             end;
          ThisSeries.Active := True;

          ThisSeries := GetSeries('AllEntLastYearExp', DBChart3) as TLineSeries;
          if ThisSeries = nil then
             begin
                ThisSeries := CloneChartSeries(DefaultEnterpriseSeries) as TLineSeries;
                ThisSeries.ParentChart := DBChart3;
                ThisSeries.SeriesColor := $005838F1;
                ThisSeries.Title := 'Last Year Enterprise Expenditure';
                ThisSeries.Name := 'AllEntLastYearExp';
                ThisSeries.Active := True;
                (ThisSeries as TLineSeries).OnGetPointerStyle := DefaultEnterpriseSeriesGetPointerStyle;
             end;

          ThisSeries.Clear;
          ThisSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                ThisSeries.Add(FLastYearAllEntExpData[i], IntToStr(i));
             end;
         ThisSeries.Active := True;

          { End - This Year vs. Last Year Expense Series }
      end
   else
      begin
         EntSeriesData := GetEntSeriesData(AEntName);
         if ( EntSeriesData = nil ) then
             begin
                raise Exception.Create('There is no enterprise matching selected criteria.');
             end;

         ThisSeries := GetSeries('ThisYearMargin',DBChart1)as TLineSeries;
         if ThisSeries = nil then
            begin
               // ThisYearMargin Series
               ThisSeries := CloneChartSeries(DefaultEnterpriseSeries) as TLineSeries;
               ThisSeries.ParentChart := DBChart1;
               ThisSeries.SeriesColor := $0089CD23;
               ThisSeries.Title := 'This Year Enterprise Margin';
               ThisSeries.Name := 'ThisYearMargin';
               ThisSeries.Active := False;
                (ThisSeries as TLineSeries).OnGetPointerStyle := DefaultEnterpriseSeriesGetPointerStyle;
            end;

         ThisSeries.Clear;
         ThisSeries.RefreshSeries;
         for i := 1 to 12 do
            begin
               ThisSeries.Add(EntSeriesData.ThisYearMargin[i], IntToStr(i));
            end;
         ThisSeries.Active := True;

         ThisSeries := GetSeries('LastYearMargin',DBChart1)as TLineSeries;
         if ThisSeries = nil then
            begin
               // LastYearMargin Series
               ThisSeries := CloneChartSeries(DefaultEnterpriseSeries) as TLineSeries;
               ThisSeries.ParentChart := DBChart1;
               ThisSeries.SeriesColor := $005838F1;
               ThisSeries.Title := 'Last Year Enterprise Margin';
               ThisSeries.Name := 'LastYearMargin';
               ThisSeries.Active := False;
               (ThisSeries as TLineSeries).OnGetPointerStyle := DefaultEnterpriseSeriesGetPointerStyle;
            end;

         ThisSeries.Clear;
         ThisSeries.RefreshSeries;
         for i := 1 to 12 do
            begin
               ThisSeries.Add(EntSeriesData.LastYearMargin[i], IntToStr(i));
            end;
         ThisSeries.Active := True;

         ThisSeries := GetSeries('ThisYearInc',DBChart2) as TLineSeries;
         if ThisSeries = nil then
            begin
               // ThisYearInc Series
               ThisSeries := CloneChartSeries(DefaultEnterpriseSeries) as TLineSeries;
               ThisSeries.ParentChart := DBChart2;
               ThisSeries.SeriesColor := $0089CD23;
               ThisSeries.Title := 'This Year Enterprise Income';
               ThisSeries.Name := 'ThisYearInc';
               ThisSeries.Active := False;
                (ThisSeries as TLineSeries).OnGetPointerStyle := DefaultEnterpriseSeriesGetPointerStyle;
            end;

         ThisSeries.Clear;
         ThisSeries.RefreshSeries;
         for i := 1 to 12 do
            begin
               ThisSeries.Add(EntSeriesData.ThisYearDataInc[i], IntToStr(i));
            end;
         ThisSeries.Active := True;

         ThisSeries := GetSeries('LastYearInc',DBChart2) as TLineSeries;
         if ThisSeries = nil then
            begin
               // LastYearInc Series
               ThisSeries := CloneChartSeries(DefaultEnterpriseSeries) as TLineSeries;
               ThisSeries.ParentChart := DBChart2;
               ThisSeries.SeriesColor := $005838F1;
               ThisSeries.Title := 'Last Year Enterprise Income';
               ThisSeries.Name := 'LastYearInc';
               ThisSeries.Active := False;
                (ThisSeries as TLineSeries).OnGetPointerStyle := DefaultEnterpriseSeriesGetPointerStyle;
            end;

         ThisSeries.Clear;
         ThisSeries.RefreshSeries;

         for i := 1 to 12 do
            begin
               ThisSeries.Add(EntSeriesData.LastYearDataInc[i], IntToStr(i));
            end;
         ThisSeries.Active := True;

         // Expenditure

         ThisSeries := GetSeries('ThisYearExp',DBChart3)as TLineSeries;
         if ThisSeries = nil then
            begin
               // ThisYearExp Series
               ThisSeries := CloneChartSeries(DefaultEnterpriseSeries) as TLineSeries;
               ThisSeries.ParentChart := DBChart3;
               ThisSeries.SeriesColor := $0089CD23;
               ThisSeries.Title := 'This Year Enterprise Expenditure';
               ThisSeries.Name := 'ThisYearExp';
               ThisSeries.Active := False;
               (ThisSeries as TLineSeries).OnGetPointerStyle := DefaultEnterpriseSeriesGetPointerStyle;
            end;

         ThisSeries.Clear;
         ThisSeries.RefreshSeries;
         for i := 1 to 12 do
            begin
               ThisSeries.Add(EntSeriesData.ThisYearDataExp[i], IntToStr(i));
            end;
         ThisSeries.Active := True;

         ThisSeries := GetSeries('LastYearExp',DBChart3) as TLineSeries;
         if ThisSeries = nil then
            begin
               // LastYearExp Series
               ThisSeries := CloneChartSeries(DefaultEnterpriseSeries) as TLineSeries;
               ThisSeries.ParentChart := DBChart3;
               ThisSeries.SeriesColor := $005838F1;
               ThisSeries.Title := 'Last Year Enterprise Expenditure';
               ThisSeries.Name := 'LastYearExp';
               ThisSeries.Active := False;
                (ThisSeries as TLineSeries).OnGetPointerStyle := DefaultEnterpriseSeriesGetPointerStyle;
            end;

         ThisSeries.Clear;
         ThisSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                ThisSeries.Add(EntSeriesData.LastYearDataExp[i], IntToStr(i));
             end;
         ThisSeries.Active := True;

      end;
   SetChartAxisMinMaxValues(DBChart1);
   SetChartAxisMinMaxValues(DBChart2);
   SetChartAxisMinMaxValues(DBChart3);
end;

procedure TfmEnterpriseAnalysisByChart.cmboEnterprisePropertiesEditValueChanged(
  Sender: TObject);
var
   i : Integer;
begin
   DrawCharts;
   if not( VarIsNull(cmboEnterprise.ItemIndex) ) then
      ProcessLinesSeries(UPPERCASE(cmboEnterprise.Text));
end;

procedure TfmEnterpriseAnalysisByChart.DBChart1GetAxisLabel(
  Sender: TChartAxis; Series: TChartSeries; ValueIndex: Integer;
  var LabelText: String);
var
   MonthIndex : Integer;
begin
  inherited;
   if ((Sender = DBChart1.BottomAxis ) or
       (Sender = DBChart2.BottomAxis ) or
       (Sender = DBChart3.BottomAxis )) then
   try
      LabelText := nMonths[StrToInt(LabelText)];
   except
   end;
end;

procedure TfmEnterpriseAnalysisByChart.cmboYearTypePropertiesEditValueChanged(
  Sender: TObject);
begin
  inherited;
   if not( VarIsNull(cmboEnterprise.ItemIndex) ) then
      begin
         ProcessLinesSeries(UPPERCASE(cmboEnterprise.Text));
         ProcessPieChart();
      end;
end;

procedure TfmEnterpriseAnalysisByChart.CleanUp;
begin
  inherited;

  if (FTempTable <> nil) then
     begin
         FTempTable.Close;
         FTempTable.DeleteTable;
         FreeAndNil(FTempTable);
      end;

   if (FTempEntsTable <> nil) then
      begin
         FTempEntsTable.Close;
         FTempEntsTable.DeleteTable;
         FreeAndNil(FTempEntsTable);
      end;
end;

procedure TfmEnterpriseAnalysisByChart.FormResize(Sender: TObject);
begin
  inherited;
  DrawCharts();
end;

procedure TfmEnterpriseAnalysisByChart.FormActivate(Sender: TObject);
begin
  inherited;
   OnActivate := nil;

   DrawCharts();
   ProcessLinesSeries('ALL ENTERPRISES');
   ProcessPieChart();
   Screen.Cursor := crDefault;
end;

procedure TfmEnterpriseAnalysisByChart.ProcessPieChart();
var
   i, j : Integer;
   sYearText : string;
   Value : Double;
begin

   if (cmboYearType.ItemIndex = 0) then
      sYearText := 'This'
   else
      sYearText := 'Last';
            
   MarginPieSeries1.Clear;
   for i := 0 to Length(FSeriesData)-1 do
      begin
         if (cmboYearType.ItemIndex = 0) then
            begin
               Value := FSeriesData[i].ThisYearMargin[13];
               if Value < 0 then Value := 0;

               if FSeriesData[i].EnterpriseColour = clDefault then
                  begin
                     MarginPieSeries1.AddPie(Value, Copy(FSeriesData[i].EnterpriseName,1,5))
                  end
               else
                  MarginPieSeries1.AddPie(Value,
                                          Copy(FSeriesData[i].EnterpriseName,1,5),
                                          FSeriesData[i].EnterpriseColour);
            end
         else if (cmboYearType.ItemIndex = 1) then
            begin
               Value := FSeriesData[i].LastYearMargin[13];
               if Value < 0 then Value := 0;

               if FSeriesData[i].EnterpriseColour = clDefault then
                  MarginPieSeries1.AddPie(Value, Copy(FSeriesData[i].EnterpriseName,1,5))
               else
                  MarginPieSeries1.AddPie(Value,
                                          Copy(FSeriesData[i].EnterpriseName,1,5),
                                          FSeriesData[i].EnterpriseColour)
            end
      end;
   MarginPieSeries1.RefreshSeries;

   MarginPieSeries2.Clear;
   for i := 0 to Length(FSeriesData)-1 do
      begin
         if (cmboYearType.ItemIndex = 0) then
            begin
               Value := FSeriesData[i].ThisYearDataInc[13];
               if Value < 0 then Value := 0;

               if FSeriesData[i].EnterpriseColour = clDefault then
                  MarginPieSeries2.AddPie(Value, Copy(FSeriesData[i].EnterpriseName,1,5))
               else
                  MarginPieSeries2.AddPie(Value,
                                          Copy(FSeriesData[i].EnterpriseName,1,5),
                                          FSeriesData[i].EnterpriseColour);
            end
         else if (cmboYearType.ItemIndex = 1) then
            begin
               Value := FSeriesData[i].LastYearDataInc[13];
               if Value < 0 then Value := 0;

               if FSeriesData[i].EnterpriseColour = clDefault then
                  MarginPieSeries2.AddPie(Value, FSeriesData[i].EnterpriseName)
               else
                  MarginPieSeries2.AddPie(FSeriesData[i].LastYearDataInc[13],
                                          Copy(FSeriesData[i].EnterpriseName,1,5),
                                          FSeriesData[i].EnterpriseColour);
            end
      end;
   MarginPieSeries2.RefreshSeries;

   MarginPieSeries3.Clear;
   for i := 0 to Length(FSeriesData)-1 do
      begin
         if (cmboYearType.ItemIndex = 0) then
            begin
               Value := FSeriesData[i].ThisYearDataExp[13];
               if Value < 0 then Value := 0;

               if FSeriesData[i].EnterpriseColour = clDefault then
                  MarginPieSeries3.AddPie(Value, Copy(FSeriesData[i].EnterpriseName,1,5))
               else
                  MarginPieSeries3.AddPie(Value,
                                          Copy(FSeriesData[i].EnterpriseName,1,5),
                                          FSeriesData[i].EnterpriseColour)
            end
         else if (cmboYearType.ItemIndex = 1) then
            begin
               Value := FSeriesData[i].LastYearDataExp[13];
               if Value < 0 then Value := 0;

               if FSeriesData[i].EnterpriseColour = clDefault then
                  MarginPieSeries3.AddPie(Value, Copy(FSeriesData[i].EnterpriseName,1,5))
               else
                  MarginPieSeries3.AddPie(Value,
                                          Copy(FSeriesData[i].EnterpriseName,1,5),
                                          FSeriesData[i].EnterpriseColour)
            end;
      end;
   MarginPieSeries3.RefreshSeries;

   PieChart1.Title.Caption := Format('Showing %s Year Enterprise Margin',[sYearText]);
   PieChart2.Title.Caption := Format('Showing %s Year Enterprise Income',[sYearText]);
   PieChart3.Title.Caption := Format('Showing %s Year Enterprise Expenditure',[sYearText]);

   PieChart1.Visible := True;
   PieChart2.Visible := True;
   PieChart3.Visible := True;
end;

class procedure TfmEnterpriseAnalysisByChart.ShowSummary;
begin
   Screen.Cursor := crHourGlass;
   with TfmEnterpriseAnalysisByChart.Create(nil) do
      try
         ShowModal;
      finally
         Free;
      end;
end;

function TfmEnterpriseAnalysisByChart.DefaultEnterpriseSeriesGetPointerStyle(
  Sender: TChartSeries; ValueIndex: Integer): TSeriesPointerStyle;
var
  LastYValue,
  YValue : Double;
begin
  inherited;
  Result := psRectangle;
  if ValueIndex > 0 then
     begin
        LastYValue := Round(Sender.YValue[ ValueIndex-1 ]);
        YValue := Round(Sender.YValue[ ValueIndex ]);
        if LastYValue < YValue then
           Result := psTriangle
        else if LastYValue > YValue then
           Result := psDownTriangle;
     end;
end;

procedure TfmEnterpriseAnalysisByChart.SetChartAxisMinMaxValues(AChart : TDBChart);
var
   i, j : Integer;
   MinValue, MaxValue : Double;
begin
   MinValue := 0;
   MaxValue := 0;

   for i := 0 to AChart.SeriesList.Count-1 do
      begin
         if not AChart.SeriesList[i].Active then
            Continue;

         for j := 0 to 11 do
            begin
               if AChart.SeriesList[i].YValues[j] < MinValue then
                  MinValue := AChart.SeriesList[i].YValues[j];
               if AChart.SeriesList[i].YValues[j] > MaxValue then
                  MaxValue := AChart.SeriesList[i].YValues[j];
            end;
      end;
   AChart.LeftAxis.AutomaticMinimum := False;
   AChart.LeftAxis.AutomaticMaximum := False;
   AChart.LeftAxis.Minimum := MinValue * 1.7;
   if (MinValue < 0 ) and (MaxValue = 0) then
      MaxValue := MinValue * -1;

   AChart.LeftAxis.Maximum := MaxValue * 1.25;
end;

procedure TfmEnterpriseAnalysisByChart.FormDestroy(Sender: TObject);
var
 i : Integer;
begin
   Inherited;
   for i := 0 to Length(FSeriesData)-1 do
      begin
         FSeriesData[i].Free;
      end;
   DBChart1.FreeAllSeries(TLineSeries);
   DBChart2.FreeAllSeries(TLineSeries);
   DBChart3.FreeAllSeries(TLineSeries);
end;

end.
