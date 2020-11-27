unit uReports;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxStyles, dxNavBarCollns, cxClasses, dxNavBarBase, ExtCtrls, dxNavBar,
  dxNavBarStyles, RXCtrls, Adgrad, ActnList, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxMaskEdit, cxSpinEdit, cxSpinButton, RxLookup,
  StdCtrls, dxBar, cxButtons, dxBarExtDBItems, dxBarExtItems, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, cxLabel, cxLookAndFeels,
  Menus, uReportMenu, cxCheckBox, dxNavBarOfficeViews, dxNavBarOffice11Views,
  dxNavBarViewsFact;

type

  TdxMyNavBarOffice11NavPaneViewInfo = class(TdxNavBarOffice11NavPaneViewInfo)
  public
    function GetSplitterHeight: Integer; override;
    function GetOverflowPanelHeight: Integer; override;
  end;

  TdxMyNavBarOffice11NavPanePainter = class(TdxNavBarOffice11NavPanePainter)
  protected
    function CreateViewInfo: TdxNavBarViewInfo; override;
  public
    procedure DrawOverflowPanel; override;
    procedure DrawSplitter; override;
  end;


  TfmReports = class(TForm)
   cxStyleRepository1: TcxStyleRepository;

    cxStyleHerdReports: TcxStyle;
    pNewReports: TPanel;
    ReportsActionList: TActionList;
    AdrockGradientFill1: TAdrockGradientFill;
    nbSimpleReports: TdxNavBar;
    nbgKeyReports: TdxNavBarGroup;
    HeaderStyle: TdxNavBarStyleItem;
    nbiItemStyle: TdxNavBarStyleItem;
    nbiItemStyleHotTracked: TdxNavBarStyleItem;
    nbiItemStylePressed: TdxNavBarStyleItem;
    nbInventoryReports: TdxNavBar;
    nbgInventoryReports: TdxNavBarGroup;
    nbiLivestockInventory: TdxNavBarItem;
    nbiREPSReport: TdxNavBarItem;
    nbiProfitMonitorSummary: TdxNavBarItem;
    nbiNutrientProduction: TdxNavBarItem;
    nbiHistoricalNutrientProduction: TdxNavBarItem;
    nbgInventoryReportsControl: TdxNavBarGroupControl;
    nbVeterinaryMisc: TdxNavBar;
    nbgVeterinaryMisc: TdxNavBarGroup;
    nbiSalesPlanner: TdxNavBarItem;
    nbiRestrictedAnimalsReport: TdxNavBarItem;
    nbiDiseaseTestStatus: TdxNavBarItem;
    nbgVeterinaryMiscControl: TdxNavBarGroupControl;
    nbiVeterinaryRegister: TdxNavBarItem;
    nbiVeterinaryDueToList: TdxNavBarItem;
    nbiMedicineStockReport: TdxNavBarItem;
    nbiSCCCurrentLactationAnalysis: TdxNavBarItem;
    nbiVeterinaryFeedPurchases: TdxNavBarItem;
    nbiVeterinaryRptGen: TdxNavBarItem;
    dxBarManager1: TdxBarManager;
    nbCattleMargins: TdxNavBar;
    nbgCattleMargins: TdxNavBarGroup;
    nbiCattleMargins: TdxNavBarItem;
    nbiWeighingsCatMarg: TdxNavBarItem;
    nbiLivestockValutation: TdxNavBarItem;
    nbgCattleMarginsControl: TdxNavBarGroupControl;
    nbiBeefPurchaseGrps: TdxNavBarItem;
    nbPedigreeReports: TdxNavBar;
    nbgPedigreeReports: TdxNavBarGroup;
    nbiIHFAHUKIRegistrations: TdxNavBarItem;
    nbiHerdBrochure: TdxNavBarItem;
    nbiSalesCatalogue: TdxNavBarItem;
    nbiPedigreeRptGen: TdxNavBarItem;
    nbgPedigreeReportsControl: TdxNavBarGroupControl;
    nbCowRecord: TdxNavBar;
    nbgCowRecording: TdxNavBarGroup;
    nbiBreedingChart: TdxNavBarItem;
    nbiBreedingDueTo: TdxNavBarItem;
    nbiActionWarnRem: TdxNavBarItem;
    nbiRecentActList: TdxNavBarItem;
    nbgCowRecordingControl: TdxNavBarGroupControl;
    nbiDairyHerdHealthCert: TdxNavBarItem;
    nbiWeighingsCowRec: TdxNavBarItem;
    nbiBullReport: TdxNavBarItem;
    nbiHerdRptGen: TdxNavBarItem;
    nbiCalfPerfGen: TdxNavBarItem;
    nbMilkAnalysis: TdxNavBar;
    nbgMilkAnalysis: TdxNavBarGroup;
    nbiBestCowInHerd: TdxNavBarItem;
    nbiMnthRcrdReview: TdxNavBarItem;
    nbiMnthSumAnalysis: TdxNavBarItem;
    nbiMilkProdGraphs: TdxNavBarItem;
    nbgMilkAnalysisControl: TdxNavBarGroupControl;
    nbiDairyBenchmarks: TdxNavBarItem;
    nbiMlkPerfGen: TdxNavBarItem;
    nbBreedFert: TdxNavBar;
    nbgBreedFertqBreedFert: TdxNavBarGroup;
    nbiBreedFertiBrowseSireRegister: TdxNavBarItem;
    nbiBreedFertiSireSelection: TdxNavBarItem;
    nbiBreedFertiMlkQuotaPlan: TdxNavBarItem;
    nbiBreedFertiHerdFertility: TdxNavBarItem;
    nbiBreedFertiIndvCowFert: TdxNavBarItem;
    nbiBreedFertiFertRepGenerator: TdxNavBarItem;
    nbgBreedFertqBreedFertControl: TdxNavBarGroupControl;
    pmBreedingDueTo: TdxBarPopupMenu;
    pmSalesPlanner: TdxBarPopupMenu;
    actClose: TAction;
    nbiFertilityTreatmentChart: TdxNavBarItem;
    pmHerdFertility: TdxBarPopupMenu;
    nbProfitMonitorRprts: TdxNavBar;
    nbgProfitMonitorReports: TdxNavBarGroup;
    nbiProfitMonitorRprts: TdxNavBarItem;
    dxNavBarStyleItem1: TdxNavBarStyleItem;
    dxNavBarStyleItem2: TdxNavBarStyleItem;
    dxNavBarStyleItem3: TdxNavBarStyleItem;
    dxNavBarStyleItem4: TdxNavBarStyleItem;
    nbgProfitMonitorReportsControl: TdxNavBarGroupControl;
    HeaderStyleDisabled: TdxNavBarStyleItem;
    ItemStyleDisabled: TdxNavBarStyleItem;
    blbClose: TdxBarLargeButton;
    nbgKeyReportsControl: TdxNavBarGroupControl;
    lbInfo: TLabel;
    actBudgets: TAction;
    actBusinessSummary: TAction;
    actCostPerUnit: TAction;
    cbDoNotShowAgain: TcxCheckBox;
    btnClose: TcxButton;
    actProfitLoss: TAction;
    actInterYearComparision: TAction;
    actTrialBalance: TAction;
    procedure FormCreate(Sender: TObject);
    procedure sbExitClick(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure pNewReportsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure nbSimpleReportsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure nbSimpleReportsMouseLeave(Sender: TObject);
    procedure nbSimpleReportsMouseEnter(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure actBudgetsExecute(Sender: TObject);
    procedure actBusinessSummaryExecute(Sender: TObject);
    procedure actCostPerUnitExecute(Sender: TObject);
    procedure actProfitLossExecute(Sender: TObject);
    procedure actInterYearComparisionExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actTrialBalanceExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    IsDairyEnterpriseInUse : Boolean;
    KeyReportsMenu : TReportMenu;
    LastReportMenu : TReportMenu;
    FNavBarPopupMenu : TdxBarPopupMenu;
    procedure SetupForm;
    procedure ReportsCheckMods;
    procedure ClearReportSelection;
    procedure ShowReportsPopupMenu;
  public
    { Public declarations }
    class procedure ShowReports();
  end;

var
  fmReports: TfmReports;

const dxMyNavBarOffice11NavigatorPaneView = 14;

implementation
uses
  dxNavBarConsts, uBudgets, Vars, Types,
  uEnterpriseAnalysisByChart, NewRepUnit, AccsData,
  uPreferences,uPreferenceConsts;

{$R *.DFM}

procedure TfmReports.FormCreate(Sender: TObject);
begin
   dxNavBarViewsFactory().RegisterView(dxMyNavBarOffice11NavigatorPaneView, 'kwOffice11NavigatorPaneView', TdxMyNavBarOffice11NavPanePainter);

   FNavBarPopupMenu := TdxBarPopupMenu.Create(nil);
   FNavBarPopupMenu.BackgroundBitmap := pmSalesPlanner.BackgroundBitmap;

   KeyReportsMenu := TReportMenu.Create(nil);
   KeyReportsMenu.NavBarPopupMenu := FNavBarPopupMenu;
   KeyReportsMenu.ActionList := ReportsActionList;
   KeyReportsMenu.NavBar := nbSimpleReports;

   SetupForm;

   // Simple Reports
   nbSimpleReports.View := dxMyNavBarOffice11NavigatorPaneView;
   KeyReportsMenu.ActionList := ReportsActionList;

   KeyReportsMenu.AddItem(actProfitLoss);
   KeyReportsMenu.AddItem(actInterYearComparision);
   KeyReportsMenu.AddItem(actCostPerUnit);
   KeyReportsMenu.AddItem(actBudgets);
   KeyReportsMenu.AddItem(actBusinessSummary);
   KeyReportsMenu.AddItem(actTrialBalance);
   KeyReportsMenu.Parent := nbgKeyReportsControl;
   KeyReportsMenu.DrawMenu;
end;

procedure TfmReports.sbExitClick(Sender: TObject);
begin
   Close;
end;

class procedure TfmReports.ShowReports();
begin
   with TfmReports.Create(nil) do
      try
         ShowModal;
      finally
         Free;
      end;
end;

procedure TfmReports.SetupForm;
begin
   IsDairyEnterpriseInUse := AccsDataModule.IsEnterpriseInUse(cDairyEnterpriseName);
   ReportsCheckMods;
end;

procedure TfmReports.actCloseExecute(Sender: TObject);
begin
   Close;
end;

procedure TfmReports.ReportsCheckMods;
begin
   actBusinessSummary.Caption := AccsDataModule.GetBusinessSummaryAlterName;
   actBudgets.Caption := AccsDataModule.GetBudgetAlternateName;
   actCostPerUnit.Caption := AccsDataModule.CostPerUnitReportAlternateName;
end;

procedure TfmReports.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
   Resize := false;
end;

procedure TfmReports.pNewReportsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
   ClearReportSelection;
end;

procedure TfmReports.nbSimpleReportsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
   ClearReportSelection;
end;

procedure TfmReports.ClearReportSelection;
begin
   KeyReportsMenu.UpdateMenuItems;
   if LastReportMenu <> nil then
      LastReportMenu.UpdateMenuItems;
end;

procedure TfmReports.nbSimpleReportsMouseLeave(Sender: TObject);
begin
   KeyReportsMenu.UpdateMenuItems;
   LastReportMenu := KeyReportsMenu;
end;

procedure TfmReports.nbSimpleReportsMouseEnter(Sender: TObject);
begin
   if LastReportMenu <> nil then
      LastReportMenu.UpdateMenuItems;
end;

procedure TfmReports.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   ClearReportSelection;
end;

procedure TfmReports.ShowReportsPopupMenu;
begin
   if FNavBarPopupMenu <> nil then
      FNavBarPopupMenu.ItemLinks.Clear;
end;

procedure TfmReports.actBudgetsExecute(Sender: TObject);
begin
   TfmBudgets.ShowBudget;
end;

procedure TfmReports.actBusinessSummaryExecute(Sender: TObject);
begin
   TfmEnterpriseAnalysisByChart.ShowSummary();
end;

procedure TfmReports.actCostPerUnitExecute(Sender: TObject);
begin
   if (NewRepForm <> nil) then
    begin
       Hide;
       NewRepForm.CostPerUnitBtnClick(NewRepForm.CostPerUnitBtn);
       Show;
    end;
end;

procedure TfmReports.actProfitLossExecute(Sender: TObject);
begin
   if (NewRepForm <> nil) then
    begin
       Hide;
       NewRepForm.ProfitAndLossBtnClick(NewRepForm.ProfitAndLossBtn);
       Show;
    end;
end;

procedure TfmReports.actInterYearComparisionExecute(Sender: TObject);
begin
   if (NewRepForm = nil) then Exit;

   if (IsDairyEnterpriseInUse) then
      begin
         NewRepForm.ThisYearVsPreviousYears1Click(NewRepForm.ThisYearVsPreviousYears1);
      end
   else
      begin
         NewRepForm.miEntSummaryThisYrVslast3YrClick(NewRepForm.miEntSummaryThisYrVslast3Yr);
      end;
end;

procedure TfmReports.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if (cbDoNotShowAgain.Checked) then
       begin
          Preferences.ValueAsBoolean[cPref_ShowKeyReportsMenu] := False;
       end;
end;

procedure TfmReports.actTrialBalanceExecute(Sender: TObject);
begin
   (Sender as TAction).Enabled := False;
   try
      if (NewRepForm <> nil) then
          NewRepForm.TrialBalBtnClick(NewRepForm.TrialBalBtn);
   finally
      (Sender as TAction).Enabled := True;
   end;
end;


{ TdxMyNavBarOffice11NavPaneViewInfo }

function TdxMyNavBarOffice11NavPaneViewInfo.GetOverflowPanelHeight: Integer;
begin
  Result := 0
end;

function TdxMyNavBarOffice11NavPaneViewInfo.GetSplitterHeight: Integer;
begin
  Result := 0;
end;

{ TdxMyNavBarOffice11NavPanePainter }

function TdxMyNavBarOffice11NavPanePainter.CreateViewInfo: TdxNavBarViewInfo;
begin
  Result := TdxMyNavBarOffice11NavPaneViewInfo.Create(self);
end;

procedure TdxMyNavBarOffice11NavPanePainter.DrawOverflowPanel;
begin

end;

procedure TdxMyNavBarOffice11NavPanePainter.DrawSplitter;
begin

end;

procedure TfmReports.FormDestroy(Sender: TObject);
begin
   dxNavBarViewsFactory.UnRegisterView(dxMyNavBarOffice11NavigatorPaneView);
end;

end.
