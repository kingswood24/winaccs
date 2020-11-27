unit uBudgets;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uBaseForm, ActnList, dxBar, dxBarExtItems, cxControls, dxStatusBar,
  cxContainer, cxEdit, cxGroupBox, cxRadioGroup, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxGridBandedTableView, cxGridDBBandedTableView,
  db, dbTables, cxTextEdit, cxMaskEdit, cxDropDownEdit, ExtCtrls, cxLabel,
  Types, cxCheckComboBox, DateUtil, uReportBaseForm, QuickRpt, StdCtrls,
  cxButtons, uAccounts, cxCurrencyEdit, cxStyles, cxProgressBar, cxCheckBox,
  cxCustomData, cxExportGrid4Link, cxFilter, cxDBData, cxMemo, cxDBEdit,
  cxSplitter;

const
   WM_PROCESSGRIDKEYPRESS = WM_USER+1;

type
  TNominalActiveType = (atAllNominalRecords, atActiveNominalRecords, atInActiveNominalRecords);

  TComparisionView = (cvAll, cvLastYear, cvActual, cvNone );
  TYearType = (ytThisYear, ytLastYear);
  TfmBudgets = class(TBaseForm)
    blbReports: TdxBarLargeButton;
    actReport: TAction;
    bcciBudgetActions: TdxBarControlContainerItem;
    dsTempBudget: TDataSource;
    blbOptions: TdxBarLargeButton;
    pmOptions: TdxBarPopupMenu;
    dxBarButton1: TdxBarButton;
    actCopyLastYearFiguresToBudget: TAction;
    bcciReportActions: TdxBarControlContainerItem;
    actBudgetReport: TAction;
    pTransctionGridHeader: TPanel;
    cxLabel12: TcxLabel;
    DefaultStyleRepository: TcxStyleRepository;
    StyleReadOnly: TcxStyle;
    cxStyle1stQuarter: TcxStyle;
    cxStyle2ndQuarter: TcxStyle;
    cxStyle3rdQuarter: TcxStyle;
    cxStyle4thQuarter: TcxStyle;
    cxStyle1stQuarterHeader: TcxStyle;
    cxStyle2ndQuarterHeader: TcxStyle;
    cxStyle3rdQuarterHeader: TcxStyle;
    cxStyle4thQuarterHeader: TcxStyle;
    cxStyle1stQuarterMonthBand: TcxStyle;
    cxStyle2ndQuarterMonthBand: TcxStyle;
    cxStyle3rdQuarterMonthBand: TcxStyle;
    cxStyle4thQuarterMonthBand: TcxStyle;
    actZeroiseBudgetFigures: TAction;
    dxBarButton2: TdxBarButton;
    SaveDialog: TSaveDialog;
    dxBarLargeButton1: TdxBarLargeButton;
    cxStyleRepository1: TcxStyleRepository;
    cxStyle1: TcxStyle;
    BudgetGrid: TcxGrid;
    BudgetGridDBTableView: TcxGridDBTableView;
    BudgetGridDBTableViewNominalID: TcxGridDBColumn;
    BudgetGridDBTableViewNomName: TcxGridDBColumn;
    BudgetGridDBTableViewYearBudget: TcxGridDBColumn;
    BudgetGridDBTableViewJan: TcxGridDBColumn;
    BudgetGridDBTableViewActualJan: TcxGridDBColumn;
    BudgetGridDBTableViewLastYearJan: TcxGridDBColumn;
    BudgetGridDBTableViewFeb: TcxGridDBColumn;
    BudgetGridDBTableViewMar: TcxGridDBColumn;
    BudgetGridDBTableViewApr: TcxGridDBColumn;
    BudgetGridDBTableViewMay: TcxGridDBColumn;
    BudgetGridDBTableViewJun: TcxGridDBColumn;
    BudgetGridDBTableViewJul: TcxGridDBColumn;
    BudgetGridDBTableViewAug: TcxGridDBColumn;
    BudgetGridDBTableViewSep: TcxGridDBColumn;
    BudgetGridDBTableViewOct: TcxGridDBColumn;
    BudgetGridDBTableViewNov: TcxGridDBColumn;
    BudgetGridDBTableViewDec: TcxGridDBColumn;
    BudgetGridDBTableViewAlteredBudget: TcxGridDBColumn;
    BudgetGridDBTableViewCheckBudget: TcxGridDBColumn;
    BudgetGridDBBandedTableView: TcxGridDBBandedTableView;
    BudgetGridDBBandedTableViewNominalID: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewEnterpriseCode: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewNomName: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewYearBudget: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLYYearTotal: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewBudgetToDate: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualTotal: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewJanuary: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualJanuary: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLastYearJanuary: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewFebruary: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualFebruary: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLastYearFebruary: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewMarch: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualMarch: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLastYearMarch: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewApril: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualApril: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLastYearApril: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewMay: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualMay: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLastYearMay: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewJune: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualJune: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLastYearJune: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewJuly: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualJuly: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLastYearJuly: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewAugust: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualAugust: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLastYearAugust: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewSeptember: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualSeptember: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLastYearSeptember: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewOctober: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualOctober: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLastYearOctober: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewNovember: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualNovember: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLastYearNovember: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewDecember: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualDecember: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLastYearDecember: TcxGridDBBandedColumn;
    BudgetGridLevel: TcxGridLevel;
    pBudgetActions: TPanel;
    cmboMonthlyComparision: TcxComboBox;
    lbMonthlyComparision: TcxLabel;
    cmboAccountTypeFilter: TcxComboBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cmboBudgetPeriods: TcxCheckComboBox;
    cxLabel3: TcxLabel;
    pReportActions: TPanel;
    cxLabel4: TcxLabel;
    btnBudgetCashflowComparison: TcxButton;
    ProgressBar: TcxProgressBar;
    cbHideInactiveNominalAccounts: TcxCheckBox;
    pCostPerUnitControls: TPanel;
    cxLabel5: TcxLabel;
    cmboReportUnitSelection: TcxComboBox;
    lNoOfUnits: TcxLabel;
    ceNoOfUnitsLastYear: TcxCurrencyEdit;
    btnHideCostPerUnitControls: TcxButton;
    lUnitLastYear: TcxLabel;
    lUnitThisYear: TcxLabel;
    ceNoOfUnitsThisYear: TcxCurrencyEdit;
    BudgetGridDBBandedTableViewYearBudgetCPU: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewLYYearTotalCPU: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewBudgetToDateCPU: TcxGridDBBandedColumn;
    BudgetGridDBBandedTableViewActualTotalCPU: TcxGridDBBandedColumn;
    btnShowCostPerUnitControls: TcxButton;
    Splitter: TcxSplitter;
    pBudgetDiary: TPanel;
    cxGroupBox1: TcxGroupBox;
    DiaryNotes: TcxDBMemo;
    btnEdit: TcxButton;
    cxButton2: TcxButton;
    actEditComments: TAction;
    actSaveComments: TAction;
    lDiaryNotesLastUpdated: TcxLabel;
    cxButton3: TcxButton;
    actCancelComments: TAction;
    procedure actReportExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure rgBudgetTypePropertiesChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmboMonthlyComparisionPropertiesChange(Sender: TObject);
    procedure actCopyLastYearFiguresToBudgetExecute(Sender: TObject);
    procedure cmboFilterPropertiesChange(Sender: TObject);
    procedure chkcomboBudgetMonthsPropertiesClickCheck(Sender: TObject;
      ItemIndex: Integer; var AllowToggle: Boolean);
    procedure chkcomboBudgetMonthsPropertiesEditValueChanged(
      Sender: TObject);
    procedure actBudgetReportExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure blbOptionsClick(Sender: TObject);
    procedure cbHideInactiveNominalAccountsPropertiesChange(
      Sender: TObject);
    procedure actZeroiseBudgetFiguresExecute(Sender: TObject);
    procedure BudgetGridDBBandedTableViewTotalColumnSummaryGetText(
      Sender: TcxDataSummaryItem; const AValue: Variant;
      AIsFooter: Boolean; var AText: String);
    procedure BudgetGridDBBandedTableViewFocusedItemChanged(
      Sender: TcxCustomGridTableView; APrevFocusedItem,
      AFocusedItem: TcxCustomGridTableItem);
    procedure BudgetGridDBBandedTableViewEditKeyDown(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure BudgetGridDBBandedTableViewKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure BudgetGridDBBandedTableViewTcxGridDBDataControllerTcxDataSummaryFooterSummaryItems6GetText(
      Sender: TcxDataSummaryItem; const AValue: Variant;
      AIsFooter: Boolean; var AText: String);
    procedure BudgetGridDBBandedTableViewTcxGridDBDataControllerTcxDataSummaryFooterSummaryItems40GetText(
      Sender: TcxDataSummaryItem; const AValue: Variant;
      AIsFooter: Boolean; var AText: String);
    procedure actExportExecute(Sender: TObject);
    procedure BudgetGridDBBandedTableViewDataControllerSummaryFooterSummaryItemsSummary(
      ASender: TcxDataSummaryItems; Arguments: TcxSummaryEventArguments;
      var OutArguments: TcxSummaryEventOutArguments);
    procedure BudgetGridDBBandedTableViewDataControllerSummaryAfterSummary(
      ASender: TcxDataSummary);
    procedure BudgetGridDBBandedTableViewDataControllerFilterChanged(
      Sender: TObject);
    procedure BudgetGridDBBandedTableViewDataControllerFilterFormatFilterTextValue(
      Sender: TcxDBDataFilterCriteria; const AValue: Variant;
      var ADisplayValue: String);
    procedure btnHideCostPerUnitControlsClick(Sender: TObject);
    procedure BudgetGridDBBandedTableViewMouseWheel(Sender: TObject;
      Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
      var Handled: Boolean);
    procedure BudgetGridDBBandedTableViewEditing(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      var AAllow: Boolean);
    procedure ceNoOfUnitsLastYearExit(Sender: TObject);
    procedure BudgetGridDBBandedTableViewCalcColumnSummaryGetText(
      Sender: TcxDataSummaryItem; const AValue: Variant;
      AIsFooter: Boolean; var AText: String);
    procedure btnShowCostPerUnitControlsClick(Sender: TObject);
    procedure cmboReportUnitSelectionPropertiesChange(Sender: TObject);
    procedure actEditCommentsExecute(Sender: TObject);
    procedure actSaveCommentsExecute(Sender: TObject);
    procedure actCancelCommentsExecute(Sender: TObject);
  private
    { Private declarations }
    FTempTable : TTable;
    FTempQuery : TQuery;
    FWorkingQuarter : Integer;
    FStartItem : Integer;
    FFormShowing : Boolean;
    FEntFiltered : Boolean;
    FFilteredEntCode : string;
    FCurrentMonth : Word;
    FQueryExecCount : Integer;
    FUseCostPerUnit : Boolean;
    function GetSelectedAccountActivityType : TNominalActiveType;
    function GetSelectedAccountType : string;
    procedure FTempTableBeforePost(DataSet: TDataSet);
    procedure FTempTableAfterPost(DataSet: TDataSet);
    function CalcNominalBudgetToDate : Double;
    function GetMonthBand(AMonthIndex : Integer) : TcxGridBand;
    function GetQuarterBand(AQuarterIndex : Integer) : TcxGridBand;
    procedure SetupGridLayout;
    procedure SetupMonthFields(Sender: TObject);
    procedure LoadBudgetData();
    procedure LoadView(const AAccountType : string; const AActiveType : TNominalActiveType);
    procedure CompareAgainst(const AComparisionView : TComparisionView = cvLastYear);
    procedure ShowGridItems(const AVisible : Boolean; const ATagIndex : Integer);
    procedure ShowGridBand(const AQuarterIndex : Integer; const AVisible : Boolean);
    procedure UpdateNominalAccount;
    function CalcColumnTotal(AFieldName : string) : Double;
    procedure UpdateGridFooterSummary;
    procedure SetupSummaryItems;
    procedure AddSummaryItem(AFieldName : string; AItem : TObject;
      ASummaryKind : TcxSummaryKind; AFormat : string);
{         Format := ',0;-,0';
         Kind := skSum;
         ItemLink := BudgetGridDBBandedTableViewJanuary;
         TcxGridDBBandedColumn(DataField.Item).DataBinding.FieldName := 'JAN';  }

    procedure ProcessKeyPress(var Message:TMessage); message WM_PROCESSGRIDKEYPRESS;
    procedure FieldGetDisplayText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    function UsingCostPerUnit : Boolean;
    function CalcCostPerUnit(AValue, ANoOfUnits : Double) : Double;
    function GetYearFromFieldName(AFieldName : string) : TYearType;
    function IsCalcField(AFieldName : string) : Boolean;

    procedure OnFTempTableCalcFields(Sender: TDataset);

    procedure UpdateBudgetDiaryPanel();

  protected
    procedure SetupForm;override;
  public
    { Public declarations }
    class procedure ShowBudget;
  end;

var
  fmBudgets: TfmBudgets;
  budgetmontharray : array[1..12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May',
    'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

const
   cDefaultItemValueFormat = ',0;-,0';
   cCostPerUnitValueFormat = ',0.00;-,0.00';

implementation
uses
    Vars,
    NewRepUnit,
    CashFlow,
    AccsData,
    Reports,
    ReportDefs, uBudgetTypes, DbCore, Util, uBudgetReport, AccsUtils, cxUtils,
    uPreferences;



{$R *.DFM}

procedure TfmBudgets.actReportExecute(Sender: TObject);
begin
  inherited;
  {SetupReport(rpSetupBudget);
  if (rgBudgetType.ItemIndex=0) then
     Act := 21
  else
     Act := 22;

  PROG := AnnBud;
  NewRepForm.DataBase := NlFile;
  if Act = 21 then
     CashFlow.CashFlowReportsForm.Caption := 'This years Monthly Budget'
  else
     CashFlow.CashFlowReportsForm.Caption := 'Last years Monthly Balances';
  CashFlow.CashFlowReportsForm.Enabled := True;

  CashFlowReportsForm.ShowModal;}
end;

procedure TfmBudgets.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
{    try
       accsdatamodule.Budgets.edit;
       accsdatamodule.budgets.post;
    except;
    end;
}

   if ( FTempTable <> nil ) then
      begin
         // post any remaining updates, allow nominal account information to be updated in AfterPost event of FTempTable.
         if FTempTable.State in dsEditModes then
            FTempTable.Post;
      end;
end;

procedure TfmBudgets.SetupMonthFields(Sender: TObject);
var
   i,j: integer;
begin

    j:=3;
    for i:=cash1.xfinmonth to (cash1.xfinmonth + 11) do begin
        if i > 12 then begin
           BudgetGridDBTableView.Columns[j].DataBinding.fieldname := budgetmontharray[i - 12];
           BudgetGridDBTableView.columns[j].Caption := budgetmontharray[i - 12];
        end;
        if i <= 12 then begin
           BudgetGridDBTableView.columns[j].DataBinding.fieldname := budgetmontharray[i];
           BudgetGridDBTableView.columns[j].Caption := budgetmontharray[i];
        end;
        inc(j);
    end;

end;

procedure TfmBudgets.FormShow(Sender: TObject);
begin
  inherited;
   accsdatamodule.dontallocateacrossyear := false;
//   SetupMonthFields(nil);
//   Refresh;  // Draw the Form
   {if (rgBudgetType.ItemIndex=0) then
      AccsDataModule.GetBudgets(BudgetThisYear)
   else
      AccsDataModule.GetBudgets(LastYearActual);}
end;

class procedure TfmBudgets.ShowBudget;
begin
   with TfmBudgets.Create(nil) do
      try
         Screen.Cursor := crHourGlass;
         FQueryExecCount := 0;
         SetupForm;
         ShowModal;
      finally
         Free;
      end;
end;

procedure TfmBudgets.rgBudgetTypePropertiesChange(Sender: TObject);
begin
  inherited;
  {if (rgBudgetType.ItemIndex=0) then
     AccsDataModule.GetBudgets(BudgetThisYear)
  else if (rgBudgetType.ItemIndex=1) then
     AccsDataModule.GetBudgets(LastYearActual);}

  //AccsDataModule.GetBudgets(BudgetThisYear)
end;

procedure TfmBudgets.SetupForm;
var
   i : Integer;
   txDate : TDateTime;
   y, d : Word;
begin
   inherited;
   ProgressBar.Visible := False;
   blbReports.Visible := ivNever;
   FWorkingQuarter := -1;

   if (Preferences.PreferenceExists('BudgetUnitsLastYear')) then
       begin
          ceNoOfUnitsLastYear.Text := Preferences.ValueAsString['BudgetUnitsLastYear'];
          ceNoOfUnitsLastYear.PostEditValue;
       end
   else
      begin
         ceNoOfUnitsLastYear.Value := 0;
         ceNoOfUnitsLastYear.PostEditValue;
      end;
   if (Preferences.PreferenceExists('BudgetUnitsThisYear')) then
      begin
         ceNoOfUnitsThisYear.Text := Preferences.ValueAsString['BudgetUnitsThisYear'];
         ceNoOfUnitsThisYear.PostEditValue;
      end
   else
      begin
         ceNoOfUnitsThisYear.Value := 0;
         ceNoOfUnitsThisYear.PostEditValue;
      end;

//   AccsDataModule. EnterpriseAccounts.Load;

//   AccsDataModule.BudgetCalculator := TBudgetCalculator.Create(ExtractMonth(Date)); // calculates the nominal account actual figure for each month

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
         TableName := 'tmpBudget';
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

         with TFloatField.Create(Self) do
         begin
            FieldName := 'YearBudgetCPU'; // CPU = Cost Per Unit
            FieldKind := fkCalculated;
            Dataset := FTempTable;
         end;

         with TFloatField.Create(Self) do
         begin
            FieldName := 'BudgetToDateCPU'; // CPU = Cost Per Unit
            FieldKind := fkCalculated;
            Dataset := FTempTable;
         end;

         with TFloatField.Create(Self) do
         begin
            FieldName := 'ActualYearTotalCPU'; // CPU = Cost Per Unit
            FieldKind := fkCalculated;
            Dataset := FTempTable;
         end;

         with TFloatField.Create(Self) do
         begin
            FieldName := 'LYYearTotalCPU'; // CPU = Cost Per Unit
            FieldKind := fkCalculated;
            Dataset := FTempTable;
         end;

         FTempTable.OnCalcFields := OnFTempTableCalcFields;
         CreateTable;
         for i := 0 to FieldDefs.Count-1 do
            begin
               FTempTable.FieldDefs[i].CreateField(FTempTable);

               if (Fields[i].DataType = ftFloat) then
                  begin
                     if Fields[i].FieldKind <> fkCalculated then
                        begin
                           Fields[i].OnGetText := FieldGetDisplayText;
                        end;
                  end;
            end;
         Open;

      end;

   FTempQuery := TQuery.Create(nil);
   FTempQuery.DatabaseName := FTempTable.DatabaseName;

   //cmboMonthlyComparision.Style.StyleController := AccsDataModule.cxDefaultEditStyleController;

   SetupGridLayout;
   LoadBudgetData;

//   cmboMonthlyComparision.ItemIndex := 1; // CompareAgainst( cvActual )
   cmboMonthlyComparision.ItemIndex := 3; // CompareAgainst( cvNeither ) Instructed by Gerry to default to Neither. It was felt
   // by Gerry that for demo'ing purposes that no comparsion is required when entering the screen first. 14/12/2011 - SP

   //CompareAgainst( TComparisionView(cmboMonthlyComparision.ItemIndex) );
   //pBudgetDiary.Visible := False;
   Splitter.Control := pBudgetDiary;
   if not AccsDataModule.BudgetExt.Active then
      AccsDataModule.BudgetExt.Active := True;

   if not (AccsDataModule.BudgetExt.Locate('BudgetYear', Cash1.xfinyear,[])) then
      begin
         AccsDataModule.BudgetExt.Append;
         AccsDataModule.BudgetExt.FieldByName('BudgetYear').AsInteger := Cash1.xfinyear;
         AccsDataModule.BudgetExt.Post;
      end;
   Splitter.CloseSplitter;
   UpdateBudgetDiaryPanel();
end;

procedure TfmBudgets.LoadBudgetData;
var
   i : Integer;
   //EnterpriseAccount : TEnterpriseAccount;
   NominalAccount : TNominalAccount;
   BudgetRecord : TBudgetRecord;

begin
   if FTempTable = nil then Exit;

   FTempTable.Close;
   FTempTable.EmptyTable;
   FTempTable.Open;

   dsTempBudget.Dataset := FTempQuery;
   FTempTable.DisableControls;
   BudgetGridDBBandedTableView.DataController.BeginUpdate;
   try
      // Get This Years Budget Figures
      AccsDataModule.GetBudgets(BudgetThisYear);

{         for i := 0 to FTempTable.FieldDefs.Count-1 do
            begin
               if (FTempTable.Fields[i].DataType = ftFloat) then
                  begin
                     FTempTable.Fields[i].OnGetText := FieldGetDisplayText;
                  end;
            end;
}

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

                     FTempTable.FieldByName('BudgetToDate').AsFloat := CalcNominalBudgetToDate();


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
   finally
      //FTempTable.EnableControls;
      //FTempTable.Close;

      FTempTable.BeforePost := FTempTableBeforePost;
      FTempTable.AfterPost := FTempTableAfterPost;

      dsTempBudget.Dataset := FTempTable;
      FTempTable.EnableControls;
      LoadView(GetSelectedAccountType, GetSelectedAccountActivityType);
      BudgetGridDBBandedTableView.DataController.EndUpdate;

      for i := 0 to cmboBudgetPeriods.Properties.Items.Count-1 do
         cmboBudgetPeriods.States[i] := cbsChecked;
   end;
end;


procedure TfmBudgets.LoadView(const AAccountType : string;
  const AActiveType : TNominalActiveType);
begin
{
  TNominalActiveType = (atAllNominalRecords, atActiveNominalRecords, atInActiveNominalRecords);
  TNominalRecordType = (rtIncome, rtExpense, rtAll);
}

   with FTempTable do
      begin
         if (AActiveType = atActiveNominalRecords) then
            Filter := 'ActiveNominalRecord = True'
         else if (AActiveType = atInActiveNominalRecords) then
            Filter := 'ActiveNominalRecord = False'
         else
            Filter := '';

         if Filter <> '' then
            Filter := ' AND ';

         if ( AAccountType <> '' ) then
            Filter := Filter + 'NomType='''+AAccountType+'''';

         if ( Filter <> '' ) and ( cbHideInactiveNominalAccounts.Checked = True ) then
            Filter := Filter + ' AND ActiveNominalRecord=''True'''
         else if ( cbHideInactiveNominalAccounts.Checked = True ) then
            Filter := 'ActiveNominalRecord=''True''';

         Filtered := (Filter <> '');
      end;
end;

procedure TfmBudgets.FormActivate(Sender: TObject);
begin
  inherited;
  Screen.Cursor := crDefault;
  FFormShowing := True;

  UpdateGridFooterSummary();
  Update;
  OnActivate := nil;
end;

procedure TfmBudgets.FormDestroy(Sender: TObject);
begin
  inherited;
  FTempTable.Close;
  FTempTable.DeleteTable;
  FreeAndNil(FTempTable);
  FTempQuery.Close;
  FreeAndNil(FTempQuery);
  FreeAndNil(AccsDataModule.BudgetCalculator);
  if not AccsDataModule.BudgetExt.Active then
     AccsDataModule.BudgetExt.Active := False;
end;

procedure TfmBudgets.CompareAgainst(
  const AComparisionView: TComparisionView);
var
   i : Integer;
   Value  : Integer;
begin
   Screen.Cursor := crHourGlass;
   try
      if ( AComparisionView = cvNone ) then
         begin
            ShowGridItems(False, Ord(cvLastYear));
            ShowGridItems(False, Ord(cvActual));
         end
      else if ( AComparisionView = cvAll ) then
         begin
            ShowGridItems(True, Ord(cvLastYear));
            ShowGridItems(True, Ord(cvActual));
         end
      else if ( AComparisionView = cvLastYear ) then
         begin
            ShowGridItems(True, Ord(cvLastYear));
            ShowGridItems(False, Ord(cvActual));
         end
      else if ( AComparisionView = cvActual ) then
         begin
            ShowGridItems(True, Ord(cvActual));
            ShowGridItems(False, Ord(cvLastYear));
         end;

      { TComparisionView = (cvAll, cvLastYear, cvActual, cvNone) }
      if (AComparisionView = cvAll) then
         begin
            BudgetGridDBBandedTableViewBudgetToDate.Visible := True;
            BudgetGridDBBandedTableViewActualTotal.Visible := True;
            if FUseCostPerUnit then
               begin
                  BudgetGridDBBandedTableViewBudgetToDateCPU.Visible := cmboReportUnitSelection.ItemIndex = 0;
                  BudgetGridDBBandedTableViewActualTotalCPU.Visible := cmboReportUnitSelection.ItemIndex = 0;
               end;

            BudgetGridDBBandedTableViewYearBudget.Visible := True;
            BudgetGridDBBandedTableViewLYYearTotal.Visible := True;

            if FUseCostPerUnit then
               begin
                  BudgetGridDBBandedTableViewYearBudgetCPU.Visible := cmboReportUnitSelection.ItemIndex = 0;
                  BudgetGridDBBandedTableViewLYYearTotalCPU.Visible := cmboReportUnitSelection.ItemIndex = 0;
               end;
         end
      else if (AComparisionView = cvLastYear) then
         begin
            // Only show Year Budget and Last Year Total
            BudgetGridDBBandedTableViewYearBudget.Visible := True;
            BudgetGridDBBandedTableViewLYYearTotal.Visible := True;
            if FUseCostPerUnit then
               begin
                  BudgetGridDBBandedTableViewYearBudgetCPU.Visible := (cmboReportUnitSelection.ItemIndex = 0);
                  BudgetGridDBBandedTableViewLYYearTotalCPU.Visible := (cmboReportUnitSelection.ItemIndex = 0);
               end;

            BudgetGridDBBandedTableViewBudgetToDate.Visible := False;
            BudgetGridDBBandedTableViewActualTotal.Visible := False;
            BudgetGridDBBandedTableViewBudgetToDateCPU.Visible := False;
            BudgetGridDBBandedTableViewActualTotalCPU.Visible := False;
         end
      else if (AComparisionView = cvActual) then
         begin
            // Only show Budget to Date and Actual to Date.
            BudgetGridDBBandedTableViewBudgetToDate.Visible := True;
            BudgetGridDBBandedTableViewActualTotal.Visible := True;

            if FUseCostPerUnit then
               begin
                  BudgetGridDBBandedTableViewBudgetToDateCPU.Visible := (cmboReportUnitSelection.ItemIndex = 0);
                  BudgetGridDBBandedTableViewActualTotalCPU.Visible := (cmboReportUnitSelection.ItemIndex = 0);
               end;

            BudgetGridDBBandedTableViewYearBudget.Visible := False;
            BudgetGridDBBandedTableViewLYYearTotal.Visible := False;
            BudgetGridDBBandedTableViewYearBudgetCPU.Visible := False;
            BudgetGridDBBandedTableViewLYYearTotalCPU.Visible := False;
         end
      else
         begin
            // Only show Year Budget
            BudgetGridDBBandedTableViewBudgetToDate.Visible := False;
            BudgetGridDBBandedTableViewActualTotal.Visible := False;
            BudgetGridDBBandedTableViewBudgetToDateCPU.Visible := False;
            BudgetGridDBBandedTableViewActualTotalCPU.Visible := False;

            BudgetGridDBBandedTableViewYearBudget.Visible := True;
            BudgetGridDBBandedTableViewLYYearTotal.Visible := False;
            if FUseCostPerUnit then
               BudgetGridDBBandedTableViewYearBudgetCPU.Visible := cmboReportUnitSelection.ItemIndex = 0
            else
               BudgetGridDBBandedTableViewYearBudgetCPU.Visible := False;

            BudgetGridDBBandedTableViewLYYearTotalCPU.Visible := False;
         end;

      if not FUseCostPerUnit then
         begin
            BudgetGridDBBandedTableView.Bands[1].Visible := True;
            BudgetGridDBBandedTableView.Bands[2].Visible := False;
         end
      else
         begin
            BudgetGridDBBandedTableView.Bands[1].Visible := True;
            BudgetGridDBBandedTableView.Bands[2].Visible := cmboReportUnitSelection.ItemIndex = 0;
         end;

      BudgetGridDBBandedTableView.Bands[1].Caption := 'Yearly Totals (Euro/Pound)';
      BudgetGridDBBandedTableView.Bands[2].Caption := 'Yearly Cost Per Unit (Cent/Pence)';
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmBudgets.ShowGridItems(const AVisible : Boolean; const ATagIndex: Integer);
var
   i : Integer;
   Value  : Integer;
begin
   BudgetGridDBBandedTableView.Controller.BeginUpdate;
   try
      for i := 0 to BudgetGridDBBandedTableView.ColumnCount-1 do
         begin
            if BudgetGridDBBandedTableView.Columns[i].Tag = ATagIndex then
               BudgetGridDBBandedTableView.Columns[i].Visible := AVisible;
         end;

   finally
      BudgetGridDBBandedTableView.Controller.EndUpdate;
   end;
end;

procedure TfmBudgets.cmboMonthlyComparisionPropertiesChange(
  Sender: TObject);
begin
  inherited;
  { TComparisionView = (cvAll, cvLastYear, cvActual) }

  if ( cmboMonthlyComparision.ItemIndex = 0 ) then
     CompareAgainst( cvLastYear )
  else if ( cmboMonthlyComparision.ItemIndex = 1 ) then
     CompareAgainst( cvActual )
  else if ( cmboMonthlyComparision.ItemIndex = 2 ) then
     CompareAgainst( cvAll )
  else
     CompareAgainst( cvNone )
end;

procedure TfmBudgets.actCopyLastYearFiguresToBudgetExecute(
  Sender: TObject);
var
   TablePreFix : string;
begin
  inherited;
  //
  if Application.MessageBox('You are about to use last year''s figures as this year''s budget figures' + cCRLF +
                            'This will overwrite previous budget entries!' + cCRLFx2 +
                            'Are you sure you want to continue?', 'Confirm', MB_YESNO + MB_DEFBUTTON2 + MB_ICONWARNING) = IDNO then
      begin
         Exit;
      end;

   if FTempTable.State in dsEditModes then  FTempTable.Post;

   Enabled := False;
   FTempTable.DisableControls;
   try
      with TQuery.Create(nil) do
         try
            Screen.Cursor := crHourGlass;

            DatabaseName := AccsDataModule.AccsDataBase.AliasName;
            TablePreFix := FTempTable.TableName + '.';
            SQL.Clear;
            SQL.Add('UPDATE ' +FTempTable.TableName);
            SQL.Add(Format('SET %sJAN = %sLYJAN, ',[TablePreFix,TablePreFix]));
            SQL.Add(Format('%sFEB = %sLYFEB, ',[TablePreFix,TablePreFix]));
            SQL.Add(Format('%sMAR = %sLYMAR, ',[TablePreFix,TablePreFix]));
            SQL.Add(Format('%sAPR = %sLYAPR, ',[TablePreFix,TablePreFix]));
            SQL.Add(Format('%sMAY = %sLYMAY, ',[TablePreFix,TablePreFix]));
            SQL.Add(Format('%sJUN = %sLYJUN, ',[TablePreFix,TablePreFix]));
            SQL.Add(Format('%sJUL = %sLYJUL, ',[TablePreFix,TablePreFix]));
            SQL.Add(Format('%sAUG = %sLYAUG, ',[TablePreFix,TablePreFix]));
            SQL.Add(Format('%sSEP = %sLYSEP, ',[TablePreFix,TablePreFix]));
            SQL.Add(Format('%sOCT = %sLYOCT, ',[TablePreFix,TablePreFix]));
            SQL.Add(Format('%sNOV = %sLYNOV, ',[TablePreFix,TablePreFix]));
            SQL.Add(Format('%s"DEC" = %sLYDEC, ',[TablePreFix,TablePreFix]));
            SQL.Add(Format('%sYearBudget = %sLYYearTotal ',[TablePreFix,TablePreFix]));

            ExecSQL;

            ProgressBar.Properties.Min := 0;
            FTempTable.First;
            with FTempTable do
               begin
                  ProgressBar.Properties.Max := RecordCount;
                  ProgressBar.Visible := True;

                  Update;

                  // update nominal accounts with latest data.
                  while not eof do
                     begin
                        Application.ProcessMessages;
                        Edit;
                        Post; // after post will be called.
                        ProgressBar.Position := ProgressBar.Position +1;
                        Update;
                        Next;
                     end;
               end;
               MessageDlg('Update complete.', mtInformation, [mbOK], 0);
         finally
            Free;
            Screen.Cursor := crDefault;
         end;
   finally

      ProgressBar.Visible := False;
      ProgressBar.Position := 0;

      BudgetGridDBBandedTableView.DataController.Refresh;
      FTempTable.First;
      FTempTable.EnableControls;
      Enabled := True;
   end;
end;

procedure TfmBudgets.FTempTableAfterPost(DataSet: TDataSet);
var
  i : Integer;
begin
   Screen.Cursor := crHourGlass;
   try
       FStartItem := 33;
       UpdateNominalAccount(); // this will update this years budget figures
       FStartItem := 65;
       UpdateNominalAccount(); // this will update last years actual figures
       UpdateGridFooterSummary();
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmBudgets.cmboFilterPropertiesChange(Sender: TObject);
begin
  inherited;
  Screen.Cursor := crHourGlass;
  Update;
  try
     LoadView(GetSelectedAccountType, GetSelectedAccountActivityType);
  finally
     Screen.Cursor := crDefault;
  end;
end;

function TfmBudgets.GetSelectedAccountActivityType: TNominalActiveType;
begin
   {   TNominalActiveType = (atAllNominalRecords, atActiveNominalRecords, atInActiveNominalRecords) }
   Result := atAllNominalRecords; // to do: needs completing!
end;

function TfmBudgets.GetSelectedAccountType: string;
begin
  if ( cmboAccountTypeFilter.ItemIndex = 1 ) then
     Result := 'Income'
  else if ( cmboAccountTypeFilter.ItemIndex = 2 ) then
     Result := 'Expense'
  else
     Result := '';
end;

procedure TfmBudgets.chkcomboBudgetMonthsPropertiesClickCheck(
  Sender: TObject; ItemIndex: Integer; var AllowToggle: Boolean);
begin
  inherited;
  FWorkingQuarter := ItemIndex+1;
  cmboBudgetPeriods.PostEditValue;
end;

procedure TfmBudgets.ShowGridBand(const AQuarterIndex : Integer;
  const AVisible : Boolean);
var
   cxGridBand : TcxGridBand;
begin
   cxGridBand := GetQuarterBand(AQuarterIndex);
   if ( cxGridBand <> nil ) then
      cxGridBand.Visible := AVisible;
end;

procedure TfmBudgets.chkcomboBudgetMonthsPropertiesEditValueChanged(
  Sender: TObject);
begin
  inherited;
  if FWorkingQuarter > -1 then
     ShowGridBand(FWorkingQuarter, ( cmboBudgetPeriods.States[FWorkingQuarter-1] = cbsChecked ));
end;

procedure TfmBudgets.UpdateNominalAccount;
var
   ReverseSign : Boolean;
   NominalId : Integer;
begin
   NominalId := FTempTable.FieldByName('NominalID').AsInteger;
   if ( NominalId <= 0 ) then Exit;

    try
       SetDB(NlFile);
       READREC( NlFile, NominalId );
       dberr;

       if RECACTIVE(NlFile) then
          begin
             ReverseSign := AccsDataModule.CreditAccount(NominalId);
             SetItem;
             if FStartItem = 33 then
                begin
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('YearBudget').AsFloat, ReverseSign);
                   PutItem ( NlFile,7);
                   SetItem;

                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('JAN').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('FEB').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+1);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('MAR').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+2);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('APR').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+3);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('MAY').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+4);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('JUN').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+5);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('JUL').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+6);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('AUG').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+7);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('SEP').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+8);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('OCT').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+9);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('NOV').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+10);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('DEC').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+11);
                end
             else
                begin
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYYearTotal').AsFloat, ReverseSign);
                   PutItem ( NlFile,17);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYJAN').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYFEB').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+1);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYMAR').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+2);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYAPR').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+3);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYMAY').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+4);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYJUN').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+5);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYJUL').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+6);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYAUG').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+7);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYSEP').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+8);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYOCT').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+9);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYNOV').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+10);
                   SetItem;
                   CurrLong := AccsDataModule.SetDOSAmount(FTempTable.FieldByName('LYDEC').AsFloat, ReverseSign);
                   PutItem ( NlFile,FStartItem+11);
                end;
             ReWriteRec(NlFile, NominalId);
          end;
    except
        MessageDlg(Format('Cannot Update Budget for Nominal Account [%d]',[NominalId]),mtError,[mbOK],0);
    end;

end;

procedure TfmBudgets.actBudgetReportExecute(Sender: TObject);
begin
  inherited;
  TfmBudgetReport.ShowBudgetReport(FCurrentMonth, FFilteredEntCode);
end;

procedure TfmBudgets.FormResize(Sender: TObject);
begin
  inherited;
  pBudgetActions.Width := ClientWidth;
  pReportActions.Width := ClientWidth;
  bcciBudgetActions.Control := pBudgetActions;
  bcciReportActions.Control := pReportActions;
end;

procedure TfmBudgets.FormCreate(Sender: TObject);
begin
  inherited;
  FEntFiltered := False;
  FFormShowing := False;
  StatusBar.Top := Top + ClientHeight -2;
  pCostPerUnitControls.Visible := False;
end;

procedure TfmBudgets.blbOptionsClick(Sender: TObject);
var
  pt : TPoint;
begin
  inherited;
  pt.x:=0;
  pt.y:= blbOptions.Height;
  pt := ClientToScreen(pt);
  pmOptions.Popup(pt.x, pt.y);
end;

procedure TfmBudgets.cbHideInactiveNominalAccountsPropertiesChange(
  Sender: TObject);
begin
  inherited;
  LoadView(GetSelectedAccountType, GetSelectedAccountActivityType);
end;

procedure TfmBudgets.FTempTableBeforePost(DataSet: TDataSet);
begin

   FTempTable.FieldByName('YearBudget').AsFloat :=
      FTempTable.FieldByName('JAN').AsFloat +
      FTempTable.FieldByName('FEB').AsFloat +
      FTempTable.FieldByName('MAR').AsFloat +
      FTempTable.FieldByName('APR').AsFloat +
      FTempTable.FieldByName('MAY').AsFloat +
      FTempTable.FieldByName('JUN').AsFloat +
      FTempTable.FieldByName('JUL').AsFloat +
      FTempTable.FieldByName('AUG').AsFloat +
      FTempTable.FieldByName('SEP').AsFloat +
      FTempTable.FieldByName('OCT').AsFloat +
      FTempTable.FieldByName('NOV').AsFloat +
      FTempTable.FieldByName('DEC').AsFloat ;

   FTempTable.FieldByName('BudgetToDate').AsFloat := CalcNominalBudgetToDate();

   FTempTable.FieldByName('LYYearTotal').AsFloat :=
      FTempTable.FieldByName('LYJAN').AsFloat +
      FTempTable.FieldByName('LYFEB').AsFloat +
      FTempTable.FieldByName('LYMAR').AsFloat +
      FTempTable.FieldByName('LYAPR').AsFloat +
      FTempTable.FieldByName('LYMAY').AsFloat +
      FTempTable.FieldByName('LYJUN').AsFloat +
      FTempTable.FieldByName('LYJUL').AsFloat +
      FTempTable.FieldByName('LYAUG').AsFloat +
      FTempTable.FieldByName('LYSEP').AsFloat +
      FTempTable.FieldByName('LYOCT').AsFloat +
      FTempTable.FieldByName('LYNOV').AsFloat +
      FTempTable.FieldByName('LYDEC').AsFloat ;


end;

procedure TfmBudgets.actZeroiseBudgetFiguresExecute(Sender: TObject);
var
   TablePreFix : string;
begin
  inherited;
  //
  if Application.MessageBox('You are about to ZEROISE the budget figures.' + cCRLFx2 +
                            'Are you sure you want to continue?', 'Confirm', MB_YESNO + MB_DEFBUTTON2 + MB_ICONWARNING) = IDNO then
      begin
         Exit;
      end;

   if FTempTable.State in dsEditModes then  FTempTable.Post;

   Enabled := False;
   FTempTable.DisableControls;
   try
      with TQuery.Create(nil) do
         try
            Screen.Cursor := crHourGlass;

            DatabaseName := AccsDataModule.AccsDataBase.AliasName;
            TablePreFix := FTempTable.TableName + '.';
            SQL.Clear;
            SQL.Add('UPDATE ' +FTempTable.TableName);
            SQL.Add(Format('SET %sJAN = 0, ',[TablePreFix]));
            SQL.Add(Format('%sFEB = NULL, ',[TablePreFix]));
            SQL.Add(Format('%sMAR = NULL, ',[TablePreFix]));
            SQL.Add(Format('%sAPR = NULL, ',[TablePreFix]));
            SQL.Add(Format('%sMAY = NULL, ',[TablePreFix]));
            SQL.Add(Format('%sJUN = NULL, ',[TablePreFix]));
            SQL.Add(Format('%sJUL = NULL, ',[TablePreFix]));
            SQL.Add(Format('%sAUG = NULL, ',[TablePreFix]));
            SQL.Add(Format('%sSEP = NULL, ',[TablePreFix]));
            SQL.Add(Format('%sOCT = NULL, ',[TablePreFix]));
            SQL.Add(Format('%sNOV = NULL, ',[TablePreFix]));
            SQL.Add(Format('%s"DEC" = NULL, ',[TablePreFix]));
            SQL.Add(Format('%sYearBudget = NULL ',[TablePreFix]));

            ExecSQL;

            ProgressBar.Properties.Min := 0;
            FTempTable.First;
            with FTempTable do
               begin
                  ProgressBar.Properties.Max := RecordCount;
                  ProgressBar.Visible := True;

                  Update;

                  // update nominal accounts with latest data.
                  while not eof do
                     begin
                        Application.ProcessMessages;
                        Edit;
                        Post; // after post will be called.
                        ProgressBar.Position := ProgressBar.Position +1;
                        Update;
                        Next;
                     end;
               end;
               MessageDlg('Update complete.', mtInformation, [mbOK], 0);
         finally
            Free;
            Screen.Cursor := crDefault;
         end;
   finally

      ProgressBar.Visible := False;
      ProgressBar.Position := 0;

      BudgetGridDBBandedTableView.DataController.Refresh;
      FTempTable.First;
      FTempTable.EnableControls;
      Enabled := True;
   end;
end;

function TfmBudgets.CalcColumnTotal(AFieldName: string): Double;
var
   IncomeAmount, ExpenseAmount : Double;
begin
   Result := 0;
   if ( FTempTable = nil ) or ( not FFormShowing ) then Exit;

   Update;

   Inc(FQueryExecCount);
   with TQuery.Create(nil) do
      try
         DatabaseName := FTempTable.DatabaseName;
         SQL.Clear;
         SQL.Add(Format('SELECT SUM(%s."%s") Total',[FTempTable.TableName, AFieldName]));
         SQL.Add('FROM '+FTempTable.TableName);
         SQL.Add('WHERE NomType=:NomType');
         if (FFilteredEntCode <> '') then
            SQL.Add('AND (EnterpriseCode="'+FFilteredEntCode+'")');

         Params[0].AsString := 'Income';
         if (FEntFiltered) then
            begin

            end;

         Open;
         try
            First;
            IncomeAmount := Fields[0].AsFloat;
            if (UsingCostPerUnit) then
               begin
                  if GetYearFromFieldName(AFieldName) = ytLastYear then
                     IncomeAmount := CalcCostPerUnit(IncomeAmount, ceNoOfUnitsLastYear.Value)
                  else
                     IncomeAmount := CalcCostPerUnit(IncomeAmount, ceNoOfUnitsThisYear.Value);
               end;
         finally
            Close;
         end;

         Params[0].AsString := 'Expense';
         Open;
         try
            First;
            ExpenseAmount := Fields[0].AsFloat;
            if (UsingCostPerUnit) then
               begin
                  if GetYearFromFieldName(AFieldName) = ytLastYear then
                     ExpenseAmount := CalcCostPerUnit(ExpenseAmount, ceNoOfUnitsLastYear.Value)
                  else
                     ExpenseAmount := CalcCostPerUnit(ExpenseAmount, ceNoOfUnitsThisYear.Value);
               end;
         finally
            Close;
         end;

        if ( cmboAccountTypeFilter.ItemIndex = 1 ) then
           Result := IncomeAmount
        else if ( cmboAccountTypeFilter.ItemIndex = 2 ) then
           Result := ExpenseAmount
        else
           Result := (IncomeAmount - ExpenseAmount);
      finally
         Free;
      end;
end;

procedure TfmBudgets.BudgetGridDBBandedTableViewTotalColumnSummaryGetText(
  Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
  var AText: String);
var
   FieldName : string;
   TotalAmount : Double;
begin
  inherited;

  if Sender = nil then Exit;

  if (Sender as TcxDataSummaryItem).DataField = nil then Exit;

  if (Sender as TcxDataSummaryItem).DataField.Item = nil then Exit;

  if TcxGridDBBandedColumn((Sender as TcxDataSummaryItem).DataField.Item).Visible then
     begin
        FieldName := TcxGridDBBandedColumn((Sender as TcxDataSummaryItem).DataField.Item).DataBinding.FieldName;

        TotalAmount := CalcColumnTotal(FieldName);
        if IsCalcField(FieldName) then
           begin
              if (GetYearFromFieldName(FieldName) = ytLastYear) then
                 AText := FormatFloat(cDefaultItemValueFormat, CalcCostPerUnit(TotalAmount, ceNoOfUnitsLastYear.Value))
              else
                 AText := FormatFloat(cDefaultItemValueFormat, CalcCostPerUnit(TotalAmount, ceNoOfUnitsThisYear.Value))
           end
        else
           AText := FormatFloat(cDefaultItemValueFormat, TotalAmount);
     end;
end;

procedure TfmBudgets.BudgetGridDBBandedTableViewCalcColumnSummaryGetText(
  Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
  var AText: String);
var
   FieldName : string;
   TotalAmount : Double;
begin
  inherited;

  if Sender = nil then Exit;

  if (Sender as TcxDataSummaryItem).DataField = nil then Exit;

  if (Sender as TcxDataSummaryItem).DataField.Item = nil then Exit;

  if TcxGridDBBandedColumn((Sender as TcxDataSummaryItem).DataField.Item).Visible then
     begin
        FieldName := TcxGridDBBandedColumn((Sender as TcxDataSummaryItem).DataField.Item).DataBinding.FieldName;

        TotalAmount := CalcColumnTotal(FieldName);
        //if IsCalcField(FieldName) then
          // begin
              if (GetYearFromFieldName(FieldName) = ytLastYear) then
                 AText := FormatFloat(cDefaultItemValueFormat, CalcCostPerUnit(TotalAmount, ceNoOfUnitsLastYear.Value))
              else
                 AText := FormatFloat(cDefaultItemValueFormat, CalcCostPerUnit(TotalAmount,ceNoOfUnitsThisYear.Value))
           //end
     end;
end;

procedure TfmBudgets.BudgetGridDBBandedTableViewFocusedItemChanged(
  Sender: TcxCustomGridTableView; APrevFocusedItem,
  AFocusedItem: TcxCustomGridTableItem);
begin
  inherited;

  if FTempTable = nil then Exit;

  if FTempTable.State in dsEditModes then
     FTempTable.Post;
end;

procedure TfmBudgets.BudgetGridDBBandedTableViewEditKeyDown(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
  inherited;
  PostMessage(Handle, WM_PROCESSGRIDKEYPRESS, Key, 0);
  if (Key in [ VK_TAB, VK_DOWN,VK_UP ,VK_LEFT,VK_RIGHT]) then
     Key := 0;
end;

procedure TfmBudgets.ProcessKeyPress(var Message: TMessage);
var
   Key : Integer;
   EditingItem: TcxGridDBBandedColumn;
begin
   inherited;
   Key := Message.WParam;

   if Message.Msg = WM_PROCESSGRIDKEYPRESS then
      begin
         if Key = VK_TAB then
            begin
               with BudgetGridDBBandedTableView.Controller do
                  begin
                    FocusNextItem(FocusedItemIndex, True, True, True);
                    Key := 0;
                  end;
            end
         else if Key = VK_DOWN then
            begin
               BudgetGridDBBandedTableView.DataController.DataSet.Next;
               Key := 0;
            end
         else if Key = VK_UP then
            begin
               BudgetGridDBBandedTableView.DataController.DataSet.Prior;
               Key := 0;
            end
         else if Key = VK_LEFT then
            begin
               BudgetGridDBBandedTableView.Controller.FocusNextItem(BudgetGridDBBandedTableView.Controller.FocusedItemIndex, False, True, True);
               Key := 0;
            end
         else if Key = VK_RIGHT then
            begin
               BudgetGridDBBandedTableView.Controller.FocusNextItem(BudgetGridDBBandedTableView.Controller.FocusedItemIndex, True, True, True);
               Key := 0;
            end;
      end;
end;

procedure TfmBudgets.BudgetGridDBBandedTableViewKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  PostMessage(Handle, WM_PROCESSGRIDKEYPRESS, Key, 0);
  if (Key in [ VK_TAB, VK_DOWN,VK_UP ,VK_LEFT,VK_RIGHT]) then
     Key := 0;
end;

procedure TfmBudgets.SetupGridLayout;
var
   BandColIndex,
   ColsInQuarter,
   QuarterIndex, i, j : Integer;
   cxGridBand : TcxGridBand;

   QuarterBandStyle : TcxStyle;
   MonthBandStyle : TcxStyle;
   ColumnStyle : TcxStyle;
begin
   BandColIndex := 1;
   ColsInQuarter := 0;
   QuarterIndex := 1; // First Quarter Band Index.

   QuarterBandStyle := nil;
   MonthBandStyle := nil;
   ColumnStyle := nil;

   for i := 1 to 12 do
      begin
         cxGridBand := GetMonthBand(i);
         if (cxGridBand <> nil) then
            begin
               cxGridBand.Position.BandIndex := -1;
               cxGridBand.Position.ColIndex := -1;
            end;
      end;

   //cxGridBand := GetMonthBand(i);
   for i := Cash1.xfinMonth to 12 do
      begin
         for j := 2 to BudgetGridDBBandedTableView.Bands.Count-1 do
            begin
               cxGridBand := GetMonthBand(i);
               if (cxGridBand <> nil) then
                  begin
                     cxGridBand.Position.ColIndex := 2 {Nom Info & Total Yearly Figures } + BandColIndex;
                     Inc(BandColIndex);
                  end;
            end;
      end;

   for i := 1 to Cash1.xfinMonth-1 do
      begin
         for j := 2 to BudgetGridDBBandedTableView.Bands.Count-1 do
            begin
               cxGridBand := GetMonthBand(i);
               if (cxGridBand <> nil) then
                  begin
                     cxGridBand.Position.ColIndex := 2 {Nom Info & Total Yearly Figures } + BandColIndex;
                     Inc(BandColIndex);
                  end;
            end;
      end;

  for i := 0 to BudgetGridDBBandedTableView.Bands.Count-1 do
     begin
        if ( BudgetGridDBBandedTableView.Bands[i].Tag = 1 ) then // if tag = 1 the band is a Month Band
           begin
              if ColsInQuarter = 3 then
                 begin
                    ColsInQuarter := 0;
                    Inc(QuarterIndex);
                 end;

              cxGridBand := GetQuarterBand(QuarterIndex);
              if ( cxGridBand <> nil ) then
                 BudgetGridDBBandedTableView.Bands[i].Position.BandIndex := cxGridBand.Index;

              QuarterBandStyle := cxStyle1stQuarterHeader;
              MonthBandStyle := cxStyle1stQuarterMonthBand;
              ColumnStyle := cxStyle1stQuarter;

              if ( QuarterIndex = 1 ) then
                 begin
                    QuarterBandStyle := cxStyle1stQuarterHeader;
                    MonthBandStyle := cxStyle1stQuarterMonthBand;
                    ColumnStyle := cxStyle1stQuarter;
                 end
              else if ( QuarterIndex = 2 ) then
                 begin
                    QuarterBandStyle := cxStyle2ndQuarterHeader;
                    MonthBandStyle := cxStyle2ndQuarterMonthBand;
                    ColumnStyle := cxStyle2ndQuarter;
                 end
              else if ( QuarterIndex = 3 ) then
                 begin
                    QuarterBandStyle := cxStyle3rdQuarterHeader;
                    MonthBandStyle := cxStyle3rdQuarterMonthBand;
                    ColumnStyle := cxStyle3rdQuarter;
                 end
              else if ( QuarterIndex = 4 ) then
                 begin
                    QuarterBandStyle := cxStyle4thQuarterHeader;
                    MonthBandStyle := cxStyle4thQuarterMonthBand;
                    ColumnStyle := cxStyle4thQuarter;
                 end;

               cxGridBand.Styles.Header := QuarterBandStyle;
               BudgetGridDBBandedTableView.Bands[i].Styles.Header := MonthBandStyle;
               for j := 0 to BudgetGridDBBandedTableView.Bands[i].ColumnCount-1 do
                   BudgetGridDBBandedTableView.Bands[i].Columns[j].Styles.Header := ColumnStyle;

              Inc(ColsInQuarter);
           end;
     end;
   SetupSummaryItems();
end;

function TfmBudgets.GetMonthBand(AMonthIndex: Integer): TcxGridBand;
var
   i : Integer;
begin
   Result := nil;
   for i := 0 to BudgetGridDBBandedTableView.Bands.Count-1 do
      begin
         if UPPERCASE(BudgetGridDBBandedTableView.Bands[i].Caption) = UPPERCASE(Months[AMonthIndex]) then
            begin
               Result := BudgetGridDBBandedTableView.Bands[i];
               Break;
            end;
      end;
end;

procedure TfmBudgets.BudgetGridDBBandedTableViewTcxGridDBDataControllerTcxDataSummaryFooterSummaryItems6GetText(
  Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
  var AText: String);
var
   RecordCount : Integer;
begin
  inherited;

  if not FFormShowing then
     begin
        AText := '';
        Exit;
     end;

  if (  FFilteredEntCode <> '' ) then
     RecordCount := BudgetGridDBBandedTableView.DataController.FilteredRecordCount
  else
     RecordCount := BudgetGridDBBandedTableView.DataController.RecordCount;

  if cmboAccountTypeFilter.ItemIndex = 1 then
     AText := Format('Income Headings: %d', [RecordCount])
  else if cmboAccountTypeFilter.ItemIndex = 2 then
     AText := Format('Expense Headings: %d', [RecordCount])
  else
     AText := Format('All Headings: %d', [RecordCount])
end;

function TfmBudgets.GetQuarterBand(AQuarterIndex: Integer): TcxGridBand;
var
   i : Integer;
   QuarterHeaderText : string;
begin

   Result := nil;

   if ( AQuarterIndex = 1 ) then
      QuarterHeaderText := '1st Quarter'
   else if ( AQuarterIndex = 2 ) then
      QuarterHeaderText := '2nd Quarter'
   else if ( AQuarterIndex = 3 ) then
      QuarterHeaderText := '3rd Quarter'
   else if ( AQuarterIndex = 4 ) then
      QuarterHeaderText := '4th Quarter';

   for i := 0 to BudgetGridDBBandedTableView.Bands.Count-1 do
      begin
         if UPPERCASE(BudgetGridDBBandedTableView.Bands[i].Caption) = UPPERCASE(QuarterHeaderText) then
            begin
               Result := BudgetGridDBBandedTableView.Bands[i];
               Break;
            end;
      end;

end;

procedure TfmBudgets.UpdateGridFooterSummary;
begin
   Screen.Cursor := crHourGlass;
   BudgetGridDBBandedTableView.DataController.Summary.BeginUpdate;
   try
      BudgetGridDBBandedTableView.DataController.Summary.Calculate;
   finally
      BudgetGridDBBandedTableView.DataController.Summary.EndUpdate;
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmBudgets.BudgetGridDBBandedTableViewTcxGridDBDataControllerTcxDataSummaryFooterSummaryItems40GetText(
  Sender: TcxDataSummaryItem; const AValue: Variant; AIsFooter: Boolean;
  var AText: String);
begin
  inherited;
//  if (cmboAccountTypeFilter.ItemIndex = 0) and (not FEntFiltered) then
  if cmboAccountTypeFilter.ItemIndex = 0 then
     AText := 'Margin:'
  else
     AText := 'Total:'

end;

procedure TfmBudgets.actExportExecute(Sender: TObject);
begin
   SaveDialog.InitialDir := ApplicationPath;
   SaveDialog.Filter := 'HTML File|*.html;*.htm';
   SaveDialog.DefaultExt := '*.html';

   if SaveDialog.Execute then
      begin
         if FileExists(SaveDialog.FileName) then
            if MessageDlg(cFileOverwrite,mtWarning,[mbYes,mbNo],0) = idNo then
               exit;

         ExportGrid4ToHTML(SaveDialog.FileName,BudgetGrid);
         if FileExists(SaveDialog.FileName) then
            MessageDlg(Format(cFileCreated,[SaveDialog.FileName]),mtInformation,[mbOK],0)
         else
            MessageDlg(cFileCreateError,mtError,[mbOK],0);
      end;

end;

procedure TfmBudgets.BudgetGridDBBandedTableViewDataControllerSummaryFooterSummaryItemsSummary(
  ASender: TcxDataSummaryItems; Arguments: TcxSummaryEventArguments;
  var OutArguments: TcxSummaryEventOutArguments);
begin
  inherited;
  Screen.Cursor := crHourGlass;
end;

procedure TfmBudgets.BudgetGridDBBandedTableViewDataControllerSummaryAfterSummary(
  ASender: TcxDataSummary);
begin
  inherited;
  Screen.Cursor := crDefault;
end;


procedure TfmBudgets.BudgetGridDBBandedTableViewDataControllerFilterChanged(
  Sender: TObject);
var
  cxFilterCriteriaItem : TcxFilterCriteriaItem;
begin
  inherited;
  FEntFiltered := ((Pos(UPPERCASE(BudgetGridDBBandedTableViewEnterpriseCode.DataBinding.FieldName), UPPERCASE(BudgetGridDBBandedTableView.DataController.Filter.FilterText))>0) and
                   (BudgetGridDBBandedTableView.DataController.Filter.Active ));
  if not FEntFiltered then
     FFilteredEntCode := '';
  UpdateGridFooterSummary();
end;

procedure TfmBudgets.BudgetGridDBBandedTableViewDataControllerFilterFormatFilterTextValue(
  Sender: TcxDBDataFilterCriteria; const AValue: Variant;
  var ADisplayValue: String);
begin
  inherited;
  FFilteredEntCode := '';
  if not VarIsNull(AValue) then
     FFilteredEntCode := AValue;
end;

function TfmBudgets.CalcNominalBudgetToDate : Double;
begin
   Result := 0;
   if AccsDataModule.BudgetCalculator = nil then Exit;

   // Budget Figures to Date
   with AccsDataModule.BudgetCalculator do
      begin
         if ValidationArray[1] = True then
            Result := Result + FTempTable.FieldByName('Jan').AsFloat;
         if ValidationArray[2] = True then
            Result := Result + FTempTable.FieldByName('Feb').AsFloat;
         if ValidationArray[3] = True then
            Result := Result + FTempTable.FieldByName('Mar').AsFloat;
         if ValidationArray[4] = True then
            Result := Result + FTempTable.FieldByName('Apr').AsFloat;
         if ValidationArray[5] = True then
            Result := Result + FTempTable.FieldByName('May').AsFloat;
         if ValidationArray[6] = True then
            Result := Result + FTempTable.FieldByName('Jun').AsFloat;
         if ValidationArray[7] = True then
            Result := Result + FTempTable.FieldByName('Jul').AsFloat;
         if ValidationArray[8] = True then
            Result := Result + FTempTable.FieldByName('Aug').AsFloat;
         if ValidationArray[9] = True then
            Result := Result + FTempTable.FieldByName('Sep').AsFloat;
         if ValidationArray[10] = True then
            Result := Result + FTempTable.FieldByName('Oct').AsFloat;
         if ValidationArray[11] = True then
            Result := Result + FTempTable.FieldByName('Nov').AsFloat;
         if ValidationArray[12] = True then
            Result := Result + FTempTable.FieldByName('Dec').AsFloat;
      end;
end;

procedure TfmBudgets.SetupSummaryItems;
begin
   AddSummaryItem('JAN',BudgetGridDBBandedTableViewJanuary,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ACTUALJAN',BudgetGridDBBandedTableViewActualJanuary,skSum,cDefaultItemValueFormat);
   AddSummaryItem('LYJAN',BudgetGridDBBandedTableViewLastYearJanuary,skSum,cDefaultItemValueFormat);

   AddSummaryItem('FEB',BudgetGridDBBandedTableViewFebruary,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ACTUALFEB',BudgetGridDBBandedTableViewActualFebruary,skSum,cDefaultItemValueFormat);
   AddSummaryItem('LYFEB',BudgetGridDBBandedTableViewLastYearFebruary,skSum,cDefaultItemValueFormat);

   AddSummaryItem('MAR',BudgetGridDBBandedTableViewMarch,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ACTUALMAR',BudgetGridDBBandedTableViewActualMarch,skSum,cDefaultItemValueFormat);
   AddSummaryItem('LYMAR',BudgetGridDBBandedTableViewLastYearMarch,skSum,cDefaultItemValueFormat);

   AddSummaryItem('APR',BudgetGridDBBandedTableViewApril,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ACTUALAPR',BudgetGridDBBandedTableViewActualApril,skSum,cDefaultItemValueFormat);
   AddSummaryItem('LYAPR',BudgetGridDBBandedTableViewLastYearApril,skSum,cDefaultItemValueFormat);

   AddSummaryItem('MAY',BudgetGridDBBandedTableViewMay,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ACTUALMAY',BudgetGridDBBandedTableViewActualMay,skSum,cDefaultItemValueFormat);
   AddSummaryItem('LYMAY',BudgetGridDBBandedTableViewLastYearMay,skSum,cDefaultItemValueFormat);

   AddSummaryItem('JUN',BudgetGridDBBandedTableViewJune,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ACTUALJUN',BudgetGridDBBandedTableViewActualJune,skSum,cDefaultItemValueFormat);
   AddSummaryItem('LYJUN',BudgetGridDBBandedTableViewLastYearJune,skSum,cDefaultItemValueFormat);

   AddSummaryItem('JUL',BudgetGridDBBandedTableViewJuly,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ACTUALJUL',BudgetGridDBBandedTableViewActualJuly,skSum,cDefaultItemValueFormat);
   AddSummaryItem('LYJUL',BudgetGridDBBandedTableViewLastYearJuly,skSum,cDefaultItemValueFormat);

   AddSummaryItem('AUG',BudgetGridDBBandedTableViewAugust,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ACTUALAUG',BudgetGridDBBandedTableViewActualAugust,skSum,cDefaultItemValueFormat);
   AddSummaryItem('LYAUG',BudgetGridDBBandedTableViewLastYearAugust,skSum,cDefaultItemValueFormat);

   AddSummaryItem('SEP',BudgetGridDBBandedTableViewSeptember,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ACTUALSEP',BudgetGridDBBandedTableViewActualSeptember,skSum,cDefaultItemValueFormat);
   AddSummaryItem('LYSEP',BudgetGridDBBandedTableViewLastYearSeptember,skSum,cDefaultItemValueFormat);

   AddSummaryItem('OCT',BudgetGridDBBandedTableViewOctober,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ACTUALOCT',BudgetGridDBBandedTableViewActualOctober,skSum,cDefaultItemValueFormat);
   AddSummaryItem('LYOCT',BudgetGridDBBandedTableViewLastYearOctober,skSum,cDefaultItemValueFormat);

   AddSummaryItem('NOV',BudgetGridDBBandedTableViewNovember,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ACTUALNOV',BudgetGridDBBandedTableViewActualNovember,skSum,cDefaultItemValueFormat);
   AddSummaryItem('LYNOV',BudgetGridDBBandedTableViewLastYearNovember,skSum,cDefaultItemValueFormat);

   AddSummaryItem('DEC',BudgetGridDBBandedTableViewDecember,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ACTUALDEC',BudgetGridDBBandedTableViewActualDecember,skSum,cDefaultItemValueFormat);
   AddSummaryItem('LYDEC',BudgetGridDBBandedTableViewLastYearDecember,skSum,cDefaultItemValueFormat);

   AddSummaryItem('NOMNAME',BudgetGridDBBandedTableViewNomName,skNone,'Total: #');

   AddSummaryItem('YEARBUDGET',BudgetGridDBBandedTableViewYearBudget,skSum,cDefaultItemValueFormat);

   AddSummaryItem('LYYearTotal',BudgetGridDBBandedTableViewLYYearTotal,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ActualYearTotal',BudgetGridDBBandedTableViewActualTotal,skSum,cDefaultItemValueFormat);
   AddSummaryItem('ENTERPRISECODE',BudgetGridDBBandedTableViewEnterpriseCode,skNone,'Margin:');
   AddSummaryItem('BudgetToDate',BudgetGridDBBandedTableViewBudgetToDate,skSum,cDefaultItemValueFormat);

   //AddSummaryItem('YEARBUDGET',BudgetGridDBBandedTableViewYearBudgetCPU,skSum,cCostPerUnitValueFormat);
   //AddSummaryItem('BudgetToDate',BudgetGridDBBandedTableViewBudgetToDateCPU,skSum,cCostPerUnitValueFormat);
   //AddSummaryItem('LYYearTotal',BudgetGridDBBandedTableViewLYYearTotalCPU,skSum,cCostPerUnitValueFormat);
   //AddSummaryItem('ActualYearTotal',BudgetGridDBBandedTableViewActualTotalCPU,skSum,cCostPerUnitValueFormat);
end;

procedure TfmBudgets.AddSummaryItem(AFieldName: string; AItem: TObject;
  ASummaryKind: TcxSummaryKind; AFormat: string);
begin
   with BudgetGridDBBandedTableView.DataController.Summary.FooterSummaryItems.Add do
      begin
         Format := AFormat;
         Kind := ASummaryKind;
         ItemLink := AItem;
         if (UPPERCASE(AFieldName) = 'NOMNAME') then
            OnGetText := BudgetGridDBBandedTableViewTcxGridDBDataControllerTcxDataSummaryFooterSummaryItems6GetText
         else if (UPPERCASE(AFieldName) = 'ENTERPRISECODE') then
            OnGetText := BudgetGridDBBandedTableViewTcxGridDBDataControllerTcxDataSummaryFooterSummaryItems40GetText
         else if (IsCalcField( TcxGridDBBandedColumn(DataField.Item).DataBinding.FieldName)) then
            OnGetText := BudgetGridDBBandedTableViewCalcColumnSummaryGetText
         else
            begin
               TcxGridDBBandedColumn(DataField.Item).DataBinding.FieldName := AFieldName;
               OnGetText := BudgetGridDBBandedTableViewTotalColumnSummaryGetText;
            end;

      end;
end;

procedure TfmBudgets.FieldGetDisplayText(Sender: TField; var Text: string;
  DisplayText: Boolean);
var
   Value : Double;
   NoOfUnits : Double;
begin
   if (Sender.FieldName = 'YearBudgetCPU' ) or
      (Sender.FieldName = 'BudgetToDateCPU' ) or
      (Sender.FieldName = 'LYYearTotalCPU' ) or
      (Sender.FieldName = 'ActualYearTotalCPU' ) then
      begin
         Exit;  // do not update calc fields
      end;

  if (UsingCostPerUnit) then
     begin
        if (GetYearFromFieldName(Sender.FieldName) = ytlastYear) then
           Text := FormatFloat(cCostPerUnitValueFormat, CalcCostPerUnit(Sender.AsFloat, ceNoOfUnitsLastYear.Value))
        else
           Text := FormatFloat(cCostPerUnitValueFormat, CalcCostPerUnit(Sender.AsFloat, ceNoOfUnitsThisYear.Value));
     end
  else
     begin
        Text := FormatFloat(cDefaultItemValueFormat, Sender.AsFloat);
     end;
end;

procedure TfmBudgets.btnHideCostPerUnitControlsClick(Sender: TObject);
begin
  inherited;
  FUseCostPerUnit := False;

  if (FTempTable <> nil) then
     begin
        FTempTable.DisableControls;
        FTempTable.EnableControls;
     end;
  UpdateGridFooterSummary();

  pCostPerUnitControls.Visible := False;
  pCostPerUnitControls.SendToBack;

  cmboReportUnitSelection.ItemIndex := -1;

  BudgetGridDBBandedTableView.Bands[1].Visible := True;
  BudgetGridDBBandedTableView.Bands[2].Visible := False;

  cmboMonthlyComparision.ItemIndex := 3; // reset to default view.

end;

function TfmBudgets.UsingCostPerUnit: Boolean;
begin
  Result := ((FUseCostPerUnit) and (cmboReportUnitSelection.ItemIndex = 1));
end;

function TfmBudgets.CalcCostPerUnit(AValue,
  ANoOfUnits: Double): Double;
begin
   if (ANoOfUnits<>0) then
      Result := ( AValue * 100 ) / ANoOfUnits // cent conversion
   else
      Result := AValue;
end;

procedure TfmBudgets.BudgetGridDBBandedTableViewMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  inherited;
  if UsingCostPerUnit then
     begin
        Handled := true;
     end;
end;

procedure TfmBudgets.BudgetGridDBBandedTableViewEditing(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  var AAllow: Boolean);
var
   OldValue, NewValue : string;
   FieldName : string;
   YearType : TYearType;

begin
  inherited;
  if (AItem = nil) then
     Exit;

  if UsingCostPerUnit then
     begin
        OldValue := '';
        NewValue := '';
        FieldName := TcxGridDBBandedColumn(AItem).DataBinding.FieldName;
        YearType := GetYearFromFieldName(FieldName);
        if (YearType = ytLastYear) then
           NewValue := FormatFloat(cCostPerUnitValueFormat, CalcCostPerUnit(AItem.EditValue * 100, ceNoOfUnitsLastYear.Value))
        else
           NewValue := FormatFloat(cCostPerUnitValueFormat, CalcCostPerUnit(AItem.EditValue * 100, ceNoOfUnitsThisYear.Value));
        OldValue := NewValue;
        InputQuery('Enter the Cost Per Unit Value', 'New Cost Per Unit:', NewValue);

        if (NewValue <> OldValue) then
           begin
              if (IsNumeric(NewValue,true)) then
                 begin
                    if (YearType = ytLastYear) then
                       try
                          FTempTable.Edit;
                          FTempTable.FieldByName(FieldName).AsFloat := (StrToFloat(NewValue) / 100) * ceNoOfUnitsLastYear.Value;
                          FTempTable.Post;
                       except
                       end
                    else
                       try
                          FTempTable.Edit;
                          FTempTable.FieldByName(FieldName).AsFloat := (StrToFloat(NewValue) /100) * ceNoOfUnitsThisYear.Value;
                          FTempTable.Post;
                       except
                       end
                 end
              else if (Trim(NewValue) <> '') then
                 MessageDlg('Value must be a number',mtError,[mbOK],0);
           end;
        AAllow := False;
     end;
end;

function TfmBudgets.GetYearFromFieldName(AFieldName: string): TYearType;
begin
   AFieldName := UpperCase(AFieldName);
   if (AFieldName = 'LYYEARTOTAL') or
      (AFieldName = 'LYYEARTOTALCPU') or
      (AFieldName = 'LYJAN') or
      (AFieldName = 'LYFEB') or
      (AFieldName = 'LYMAR') or
      (AFieldName = 'LYAPR') or
      (AFieldName = 'LYMAY') or
      (AFieldName = 'LYJUN') or
      (AFieldName = 'LYJUL') or
      (AFieldName = 'LYAUG') or
      (AFieldName = 'LYSEP') or
      (AFieldName = 'LYOCT') or
      (AFieldName = 'LYNOV') or
      (AFieldName = 'LYDEC') then
      Result := ytLastYear
   else
      Result := ytThisYear;

end;

procedure TfmBudgets.ceNoOfUnitsLastYearExit(Sender: TObject);
begin
   inherited;

   ceNoOfUnitsLastYear.PostEditValue;
   ceNoOfUnitsThisYear.PostEditValue;

   if (FTempTable <> nil) then
      begin
         FTempTable.DisableControls;
         FTempTable.EnableControls;
      end;

   Preferences.ValueAsString['BudgetUnitsLastYear'] := ceNoOfUnitsLastYear.Text;
   Preferences.ValueAsString['BudgetUnitsThisYear'] := ceNoOfUnitsThisYear.Text;

   UpdateGridFooterSummary();
end;

procedure TfmBudgets.OnFTempTableCalcFields(Sender: TDataset);
begin
   FTempTable.FieldByName('YearBudgetCPU').AsFloat :=
      CalcCostPerUnit(FTempTable.FieldByName('YearBudget').AsFloat, ceNoOfUnitsThisYear.Value);
   FTempTable.FieldByName('BudgetToDateCPU').AsFloat :=
      CalcCostPerUnit(FTempTable.FieldByName('BudgetToDate').AsFloat, ceNoOfUnitsThisYear.Value);
   FTempTable.FieldByName('LYYearTotalCPU').AsFloat :=
      CalcCostPerUnit(FTempTable.FieldByName('LYYearTotal').AsFloat, ceNoOfUnitsLastYear.Value);
   FTempTable.FieldByName('ActualYearTotalCPU').AsFloat :=
      CalcCostPerUnit(FTempTable.FieldByName('ActualYearTotal').AsFloat, ceNoOfUnitsThisYear.Value);
end;

function TfmBudgets.IsCalcField(AFieldName: string): Boolean;
var
   Field : TField;
begin
   Result := True;

   if (FTempTable = nil) then Exit;

   Field := FTempTable.FindField(AFieldName);
   if (Field <> nil) then
      Result := Field.FieldKind = fkCalculated;
end;

procedure TfmBudgets.btnShowCostPerUnitControlsClick(Sender: TObject);
begin
  inherited;
  FUseCostPerUnit := True;
  pCostPerUnitControls.Visible := True;
  pCostPerUnitControls.BringToFront;
  if (ceNoOfUnitsLastYear.Value <= 0) then
     ceNoOfUnitsLastYear.Value := 1;
  if (ceNoOfUnitsThisYear.Value <= 0) then
     ceNoOfUnitsThisYear.Value := 1;
  try
     ceNoOfUnitsThisYear.SetFocus;
  except
  end;

  cmboReportUnitSelection.ItemIndex := 0;
  cmboMonthlyComparision.ItemIndex := 2;
end;

procedure TfmBudgets.cmboReportUnitSelectionPropertiesChange(
  Sender: TObject);
begin
  inherited;
  if (FTempTable <> nil) then
     begin
        FTempTable.DisableControls;
        FTempTable.EnableControls;
     end;
  cmboMonthlyComparisionPropertiesChange(nil);
  UpdateGridFooterSummary();

end;

procedure TfmBudgets.actEditCommentsExecute(Sender: TObject);
begin
  inherited;
  if not (AccsDataModule.BudgetExt.State in dsEditModes) then
     AccsDataModule.BudgetExt.Edit;

  UpdateBudgetDiaryPanel();

  DiaryNotes.SetFocus;
  DiaryNotes.SelStart := Length(DiaryNotes.Text);
end;

procedure TfmBudgets.actSaveCommentsExecute(Sender: TObject);
begin
  inherited;
  if (AccsDataModule.BudgetExt.State in dsEditModes) then
     AccsDataModule.BudgetExt.Post;

  UpdateBudgetDiaryPanel();
end;

procedure TfmBudgets.actCancelCommentsExecute(Sender: TObject);
begin
  inherited;
  if (AccsDataModule.BudgetExt.State in dsEditModes) then
     AccsDataModule.BudgetExt.Cancel;

  UpdateBudgetDiaryPanel();
end;

procedure TfmBudgets.UpdateBudgetDiaryPanel;
begin
   lDiaryNotesLastUpdated.Caption := '';
   if not(AccsDataModule.BudgetExt.Exists) then Exit;

   if (DiaryNotes.DataBinding.DataSource = nil) then
       begin
          DiaryNotes.DataBinding.DataSource := AccsDataModule.dsBudgetExt;
          DiaryNotes.DataBinding.DataField := 'DiaryNotes';
       end;

   if not (AccsDataModule.BudgetExt.State in dsEditModes) then
      begin
         DiaryNotes.Properties.ReadOnly := True;
         actEditComments.Enabled := True;
         actSaveComments.Enabled := False;
         actCancelComments.Enabled := False;
      end
   else
      begin
         DiaryNotes.Properties.ReadOnly := False;
         actEditComments.Enabled := False;
         actSaveComments.Enabled := True;
         actCancelComments.Enabled := True;
      end;

   if (AccsDataModule.BudgetExt.FieldByName('DiaryNotesLastUpdated').AsDateTime>0) then
      begin
         lDiaryNotesLastUpdated.Caption :=
                Format('Last updated on: %s',[FormatDateTime('dd/MM/yyyy hh:nn', AccsDataModule.BudgetExt.FieldByName('DiaryNotesLastUpdated').AsDateTime)]);
      end;
   pBudgetDiary.Visible := True;
end;

end.
