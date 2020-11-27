unit uEnterpriseAnalysisByChart1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, TeeTools, Db, DBTables, TeeURL, TeeSeriesTextEd, Series,
  ExtCtrls, TeeProcs, Chart, DBChart, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxControls, cxContainer, cxEdit, cxGroupBox,
  cxColorComboBox, cxDBColorComboBox, StdCtrls, cxButtons, dxBar,
  dxBarExtItems, uEnterpriseLineSeriesData, cxSplitter;

type

  TfmEnterpriseAnalysisByChart1 = class(TForm)
    dxBarManager: TdxBarManager;
    blbExit: TdxBarLargeButton;
    bsFiller: TdxBarStatic;
    bbHelp: TdxBarButton;
    bbSearchTransaction: TdxBarButton;
    bbClearSearch: TdxBarButton;
    bsiFile: TdxBarSubItem;
    bbPrintPreview: TdxBarButton;
    BarStatic1: TdxBarStatic;
    BarControlProgressBar: TdxBarControlContainerItem;
    dxBarControlContainerItemSearchPanel: TdxBarControlContainerItem;
    blbHelp: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    dxBarLargeButton5: TdxBarLargeButton;
    dxBarContainerItem1: TdxBarContainerItem;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    pChartContainer: TPanel;
    YearComparisonChart: TDBChart;
    GridBandTool1: TGridBandTool;
    GridBandTool3: TGridBandTool;
    DBChart2: TDBChart;
    DBChart3: TDBChart;
    FastLineSeries1: TFastLineSeries;
    GridBandTool4: TGridBandTool;
    GridBandTool5: TGridBandTool;
    GridBandTool6: TGridBandTool;
    DBChart4: TDBChart;
    DBChart5: TDBChart;
    FastLineSeries2: TFastLineSeries;
    GridBandTool7: TGridBandTool;
    GridBandTool8: TGridBandTool;
    GridBandTool9: TGridBandTool;
    pEntFilter: TPanel;
    cmboYearType: TcxComboBox;
    cmboEnterprise: TcxComboBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    Panel1: TPanel;
    cxSplitter1: TcxSplitter;
    procedure FormCreate(Sender: TObject);
    procedure cmboEnterprisePropertiesCloseUp(Sender: TObject);
    procedure YearComparisonChartGetAxisLabel(Sender: TChartAxis;
      Series: TChartSeries; ValueIndex: Integer; var LabelText: String);
    procedure cmboYearTypePropertiesCloseUp(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure blbExitClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
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

    procedure LoadChartData();
    procedure ProcessLinesSeries(AEntName : string);
    procedure ProcessChartData;
    function GetSeries(ASeriesName : string) : TChartSeries;
    function GetEntSeriesData(AEnterpriseName : string) : TEnterpriseLineSeriesData;
    procedure DrawChartsRegions();
  protected
    procedure SetupForm();
  public
    { Public declarations }
  end;

var
  fmEnterpriseAnalysisByChart1: TfmEnterpriseAnalysisByChart1;

implementation

uses AccsData, uAccounts, uBudgetTypes, Types;

{$R *.DFM}

{ TfmYearlyComparisonCharts }

procedure TfmEnterpriseAnalysisByChart1.LoadChartData;
var
   NominalAccount : TNominalAccount;
   BudgetRecord : TBudgetRecord;
begin
   if FTempTable = nil then Exit;

   if ( AccsDataModule.Accounts = nil ) then Exit;

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
                  NominalAccount := AccsDataModule.Accounts.GetNominalAccountById(FieldByName('NominalID').AsInteger);
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

                  NominalAccount := AccsDataModule.Accounts.GetNominalAccountById(FieldByName('NominalID').AsInteger);
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

procedure TfmEnterpriseAnalysisByChart1.SetupForm;
var
   txDate : TDateTime;
   y, d : Word;
begin

   FillChar(FThisYearAllEntMarginData, SizeOf(TSeriesData),0);
   FillChar(FLastYearAllEntMarginData, SizeOf(TSeriesData),0);

   txDate := AccsDataModule.MaxTransactionDate;
   if ( txDate > 0 ) then
      DecodeDate(txDate, y, FCurrentMonth, d )
   else
      FCurrentMonth := 1;

   AccsDataModule.BudgetCalculator := TBudgetCalculator.Create(FCurrentMonth); // calculates the nominal account actual figure for each month

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
         Add('This Year Vs. Last Year');
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

   YearComparisonChart.Title.Text.Clear;

   LoadChartData;

end;

//
// Create the Line Series for enterprise.
//
procedure TfmEnterpriseAnalysisByChart1.ProcessLinesSeries(AEntName : string);
var
   EntName : String;
   EntColor : TColor;
   i : Integer;
   NewSeries : TFastLineSeries;
   tdouble : Double;
   EntSeriesData : TEnterpriseLineSeriesData;
begin
   YearComparisonChart.Legend.Items.Clear;

   if (UPPERCASE(AEntName) = 'ALL ENTERPRISES') then
      begin
          NewSeries := GetSeries('AllEntThisYearMargin') as TFastLineSeries;
          if NewSeries = nil then
             begin
                // AllEntThisYearMargin Series
                NewSeries := CloneChartSeries(DefaultEnterpriseSeries) as TFastLineSeries;
                NewSeries.ParentChart := YearComparisonChart;
                NewSeries.SeriesColor := $0089CD23;
                NewSeries.Title := 'This Year Income';
                NewSeries.Name := 'AllEntThisYearMargin';
                NewSeries.Active := False;
             end;

          NewSeries.Clear;
          NewSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                NewSeries.Add(FThisYearAllEntMarginData[i], IntToStr(i));
             end;

          NewSeries := GetSeries('AllEntLastYearMargin')as TFastLineSeries;
          if NewSeries = nil then
             begin
                // AllEntLastYearMargin Series
                NewSeries := CloneChartSeries(DefaultEnterpriseSeries) as TFastLineSeries;
                NewSeries.ParentChart := YearComparisonChart;
                NewSeries.SeriesColor := $005838F1;
                NewSeries.Title := 'This Year Expenditure';
                NewSeries.Name := 'AllEntLastYearMargin';
                NewSeries.Active := False;
             end;

          NewSeries.Clear;
          NewSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                NewSeries.Add(FLastYearAllEntMarginData[i], IntToStr(i));
             end;

         YearComparisonChart.LeftAxis.AutomaticMinimum := False;
         YearComparisonChart.LeftAxis.Minimum := FMinAllEntsDataValue * 1.25;

         YearComparisonChart.LeftAxis.AutomaticMaximum := False;
         YearComparisonChart.LeftAxis.Maximum := FMaxAllEntsDataValue * 1.25;

         for i := 0 to YearComparisonChart.SeriesCount -1 do
            begin
               if YearComparisonChart.Series[i].Name = 'AllEntThisYearMargin' then
                  YearComparisonChart.Series[i].Active := True
               else if YearComparisonChart.Series[i].Name = 'AllEntLastYearMargin' then
                  YearComparisonChart.Series[i].Active := True
               else
                  YearComparisonChart.Series[i].Active := False;
            end;

          { This Year vs. Last Year Income Series }

          NewSeries := GetSeries('AllEntThisYearInc') as TFastLineSeries;
          if NewSeries = nil then
             begin
                NewSeries := CloneChartSeries(DefaultEnterpriseSeries) as TFastLineSeries;
                NewSeries.ParentChart := DBChart2;
                NewSeries.SeriesColor := $0089CD23;
                NewSeries.Title := 'This Year Income';
                NewSeries.Name := 'AllEntThisYearInc';
                NewSeries.Active := False;
             end;

          NewSeries.Clear;
          NewSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                NewSeries.Add(FThisYearAllEntIncData[i], IntToStr(i));
             end;

          NewSeries := GetSeries('AllEntLastYearInc') as TFastLineSeries;
          if NewSeries = nil then
             begin
                NewSeries := CloneChartSeries(DefaultEnterpriseSeries) as TFastLineSeries;
                NewSeries.ParentChart := DBChart2;
                NewSeries.SeriesColor := $005838F1;
                NewSeries.Title := 'Last Year Income';
                NewSeries.Name := 'AllEntLastYearInc';
                NewSeries.Active := False;
             end;

          NewSeries.Clear;
          NewSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                NewSeries.Add(FLastYearAllEntIncData[i], IntToStr(i));
             end;

          { End - This Year vs. Last Year Income Series }


          { This Year vs. Last Year Expense Series }

          NewSeries := GetSeries('AllEntThisYearExp') as TFastLineSeries;
          if NewSeries = nil then
             begin
                NewSeries := CloneChartSeries(DefaultEnterpriseSeries) as TFastLineSeries;
                NewSeries.ParentChart := DBChart4;
                NewSeries.SeriesColor := $0089CD23;
                NewSeries.Title := 'This Year Expense';
                NewSeries.Name := 'AllEntThisYearExp';
                NewSeries.Active := False;
             end;

          NewSeries.Clear;
          NewSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                NewSeries.Add(FThisYearAllEntExpData[i], IntToStr(i));
             end;

          NewSeries := GetSeries('AllEntLastYearExp') as TFastLineSeries;
          if NewSeries = nil then
             begin
                NewSeries := CloneChartSeries(DefaultEnterpriseSeries) as TFastLineSeries;
                NewSeries.ParentChart := DBChart4;
                NewSeries.SeriesColor := $005838F1;
                NewSeries.Title := 'Last Year Expense';
                NewSeries.Name := 'AllEntLastYearExp';
                NewSeries.Active := False;
             end;

          NewSeries.Clear;
          NewSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                NewSeries.Add(FLastYearAllEntExpData[i], IntToStr(i));
             end;

          { End - This Year vs. Last Year Expense Series }
      end
   else
      begin
         EntSeriesData := GetEntSeriesData(AEntName);
         if ( EntSeriesData = nil ) then
             begin
                raise Exception.Create('There is no enterprise matching selected criteria.');
             end;

         NewSeries := GetSeries('ThisYearInc') as TFastLineSeries;
         if NewSeries = nil then
            begin
               // ThisYearInc Series
               NewSeries := CloneChartSeries(DefaultEnterpriseSeries) as TFastLineSeries;
               NewSeries.ParentChart := YearComparisonChart;
               NewSeries.SeriesColor := $0089CD23;
               NewSeries.Title := 'This Year Income';
               NewSeries.Name := 'ThisYearInc';
               NewSeries.Active := False;
            end;

         NewSeries.Clear;
         NewSeries.RefreshSeries;
         for i := 1 to 12 do
            begin
               NewSeries.Add(EntSeriesData.ThisYearDataInc[i], IntToStr(i));
            end;

         NewSeries := GetSeries('ThisYearExp')as TFastLineSeries;
         if NewSeries = nil then
            begin
               // ThisYearExp Series
               NewSeries := CloneChartSeries(DefaultEnterpriseSeries) as TFastLineSeries;
               NewSeries.ParentChart := YearComparisonChart;
               NewSeries.SeriesColor := $005838F1;
               NewSeries.Title := 'This Year Expenditure';
               NewSeries.Name := 'ThisYearExp';
               NewSeries.Active := False;
            end;

         NewSeries.Clear;
         NewSeries.RefreshSeries;
         for i := 1 to 12 do
            begin
               NewSeries.Add(EntSeriesData.ThisYearDataExp[i], IntToStr(i));
            end;

         NewSeries := GetSeries('LastYearInc')as TFastLineSeries;
         if NewSeries = nil then
            begin
               // LastYearInc Series
               NewSeries := CloneChartSeries(DefaultEnterpriseSeries) as TFastLineSeries;
               NewSeries.ParentChart := YearComparisonChart;
               NewSeries.SeriesColor := $00D573B3;
               NewSeries.Title := 'Last Year Income';
               NewSeries.Name := 'LastYearInc';
               NewSeries.Active := False;
            end;

         NewSeries.Clear;
         NewSeries.RefreshSeries;

         for i := 1 to 12 do
            begin
               NewSeries.Add(EntSeriesData.LastYearDataInc[i], IntToStr(i));
            end;

         NewSeries := GetSeries('LastYearExp')as TFastLineSeries;
         if NewSeries = nil then
            begin
               // LastYearExp Series
               NewSeries := CloneChartSeries(DefaultEnterpriseSeries) as TFastLineSeries;
               NewSeries.ParentChart := YearComparisonChart;
               NewSeries.SeriesColor := $002367F5;
               NewSeries.Title := 'Last Year Expenditure';
               NewSeries.Name := 'LastYearExp';
               NewSeries.Active := False;
            end;

         NewSeries.Clear;
         NewSeries.RefreshSeries;
          for i := 1 to 12 do
             begin
                NewSeries.Add(EntSeriesData.LastYearDataExp[i], IntToStr(i));
             end;

         NewSeries := GetSeries('ThisYearMargin')as TFastLineSeries;
         if NewSeries = nil then
            begin
               // ThisYearMargin Series
               NewSeries := CloneChartSeries(DefaultEnterpriseSeries) as TFastLineSeries;
               NewSeries.ParentChart := YearComparisonChart;
               NewSeries.SeriesColor := $004B8CBC;
               NewSeries.Title := 'This Year Gross Margin';
               NewSeries.Name := 'ThisYearMargin';
               NewSeries.Active := False;
            end;

         NewSeries.Clear;
         NewSeries.RefreshSeries;
         for i := 1 to 12 do
            begin
               NewSeries.Add(EntSeriesData.ThisYearMargin[i], IntToStr(i));
            end;

         NewSeries := GetSeries('LastYearMargin')as TFastLineSeries;
         if NewSeries = nil then
            begin
               // LastYearMargin Series
               NewSeries := CloneChartSeries(DefaultEnterpriseSeries) as TFastLineSeries;
               NewSeries.ParentChart := YearComparisonChart;
               NewSeries.SeriesColor := $00D8D070;
               NewSeries.Title := 'Last Year Gross Margin';
               NewSeries.Name := 'LastYearMargin';
               NewSeries.Active := False;
            end;

         NewSeries.Clear;
         NewSeries.RefreshSeries;
         for i := 1 to 12 do
            begin
               NewSeries.Add(EntSeriesData.LastYearMargin[i], IntToStr(i));
            end;

         if cmboYearType.ItemIndex = 0 then
            begin
               YearComparisonChart.LeftAxis.AutomaticMinimum := False;
               if EntSeriesData.MinThisYearDataValue > 0 then
                  YearComparisonChart.LeftAxis.Minimum := EntSeriesData.MinThisYearDataValue * 1.25
               else
                  YearComparisonChart.LeftAxis.Minimum := EntSeriesData.MinThisYearDataValue;

               YearComparisonChart.LeftAxis.AutomaticMaximum := False;
               YearComparisonChart.LeftAxis.Maximum := EntSeriesData.MaxThisYearDataValue * 1.25;

               for i := 0 to YearComparisonChart.SeriesCount -1 do
                  begin
                     if YearComparisonChart.Series[i].Name = 'ThisYearInc' then
                        YearComparisonChart.Series[i].Active := True
                     else if YearComparisonChart.Series[i].Name = 'ThisYearExp' then
                        YearComparisonChart.Series[i].Active := True
                     else
                        YearComparisonChart.Series[i].Active := False;
                  end;
            end
         else if cmboYearType.ItemIndex = 1 then
            begin
               YearComparisonChart.LeftAxis.AutomaticMinimum := False;
               if EntSeriesData.MinLastYearDataValue > 0 then
                  YearComparisonChart.LeftAxis.Minimum := EntSeriesData.MinLastYearDataValue * 1.25
               else
                  YearComparisonChart.LeftAxis.Minimum := EntSeriesData.MinThisYearDataValue;

               YearComparisonChart.LeftAxis.AutomaticMaximum := False;
               YearComparisonChart.LeftAxis.Maximum := EntSeriesData.MaxLastYearDataValue * 1.25;

               for i := 0 to YearComparisonChart.SeriesCount -1 do
                  begin
                     if YearComparisonChart.Series[i].Name = 'LastYearInc' then
                        YearComparisonChart.Series[i].Active := True
                     else if YearComparisonChart.Series[i].Name = 'LastYearExp' then
                        YearComparisonChart.Series[i].Active := True
                     else
                        YearComparisonChart.Series[i].Active := False;

                  end;
            end
         else if cmboYearType.ItemIndex = 2 then
            begin
               YearComparisonChart.LeftAxis.AutomaticMinimum := False;
               YearComparisonChart.LeftAxis.Minimum := EntSeriesData.MinMarginValue * 1.25;
               YearComparisonChart.LeftAxis.AutomaticMaximum := False;
               YearComparisonChart.LeftAxis.Maximum := EntSeriesData.MaxMarginValue * 1.25;

               for i := 0 to YearComparisonChart.SeriesCount -1 do
                  begin
                     if YearComparisonChart.Series[i].Name = 'ThisYearMargin' then
                        YearComparisonChart.Series[i].Active := True
                     else if YearComparisonChart.Series[i].Name = 'LastYearMargin' then
                        YearComparisonChart.Series[i].Active := True
                     else
                        YearComparisonChart.Series[i].Active := False;

                  end;
            end;
      end;
end;

procedure TfmEnterpriseAnalysisByChart1.ProcessChartData;
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

procedure TfmEnterpriseAnalysisByChart1.FormCreate(Sender: TObject);
begin
   SetupForm;
end;

function TfmEnterpriseAnalysisByChart1.GetSeries(
  ASeriesName: string): TChartSeries;
var
   i : Integer;
begin
   Result := nil;
   for i := 0 to YearComparisonChart.SeriesList.Count-1 do
      begin
         if ( YearComparisonChart.SeriesList[i].Name = ASeriesName) then
             begin
                Result := YearComparisonChart.SeriesList[i];
                Break;
             end;
      end;
end;

procedure TfmEnterpriseAnalysisByChart1.cmboEnterprisePropertiesCloseUp(
  Sender: TObject);
var
   i : Integer;
begin
   DrawChartsRegions;
   if not( VarIsNull(cmboEnterprise.ItemIndex) ) then
      ProcessLinesSeries(UPPERCASE(cmboEnterprise.Text));
end;

procedure TfmEnterpriseAnalysisByChart1.YearComparisonChartGetAxisLabel(
  Sender: TChartAxis; Series: TChartSeries; ValueIndex: Integer;
  var LabelText: String);
begin
   if Sender = YearComparisonChart.BottomAxis then
   try
      LabelText := ShortMonths[ StrToInt(LabelText)];
   except
   end;
end;

procedure TfmEnterpriseAnalysisByChart1.cmboYearTypePropertiesCloseUp(
  Sender: TObject);
begin
   if not( VarIsNull(cmboEnterprise.ItemIndex) ) then
      ProcessLinesSeries(UPPERCASE(cmboEnterprise.Text));
end;

procedure TfmEnterpriseAnalysisByChart1.FormDestroy(Sender: TObject);
begin
   if FTempTable.Exists then
      begin
         FTempTable.Close;
         FTempTable.DeleteTable;
         FreeAndNil(FTempTable);
      end;

   if FTempEntsTable.Exists then
      begin
         FTempEntsTable.Close;
         FTempEntsTable.DeleteTable;
         FreeAndNil(FTempEntsTable);
      end;

end;

procedure TfmEnterpriseAnalysisByChart1.btnExitClick(Sender: TObject);
begin
   Close;
end;

function TfmEnterpriseAnalysisByChart1.GetEntSeriesData(
  AEnterpriseName: string): TEnterpriseLineSeriesData;
var
 i : Integer;
begin
   Result := nil;
   for i := 0 to Length(FSeriesData)-1 do
      begin
         if (  FSeriesData[i].EnterpriseName = AEnterpriseName) then
            begin
               Result := FSeriesData[i];
               Break;
            end;
      end;
end;

procedure TfmEnterpriseAnalysisByChart1.FormShow(Sender: TObject);
begin
   //
   ProcessLinesSeries('ALL ENTERPRISES');
end;

procedure TfmEnterpriseAnalysisByChart1.blbExitClick(Sender: TObject);
begin
   Close;
end;

procedure TfmEnterpriseAnalysisByChart1.FormResize(Sender: TObject);
begin
   DrawChartsRegions();
end;

procedure TfmEnterpriseAnalysisByChart1.DrawChartsRegions;
var
   newChartHeight : Integer;
begin
   if (cmboEnterprise.Text = 'ALL ENTERPRISES') then
      begin
         newChartHeight := Trunc(pChartContainer.Height / 3);

         YearComparisonChart.Height := newChartHeight;
         DBChart2.Height := newChartHeight;
      end
   else
      begin
         DBChart2.Hide;
         DBChart4.Hide;
      end;
end;

procedure TfmEnterpriseAnalysisByChart1.FormActivate(Sender: TObject);
begin
   DrawChartsRegions();
   OnActivate := nil;
end;

end.
