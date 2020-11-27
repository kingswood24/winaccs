unit uReviewFarmFinances;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, cxControls, cxContainer, cxEdit, cxLabel, StdCtrls, cxButtons,
  reportdefs, Entreps, Types, Vars, uBudgets;

type
  TfmReviewFarmFinances = class(TForm)
    pTopPanel: TPanel;
    btnClose: TcxButton;
    pMain: TPanel;
    lDairyEnterpriseHeader: TcxLabel;
    lCostPerUnitText: TcxLabel;
    btnCostPerUnit: TcxButton;
    Bevel7: TBevel;
    lFarmBudgets: TcxLabel;
    lFarmBudgetText: TcxLabel;
    btnSetupBudgets: TcxButton;
    procedure btnCostPerUnitClick(Sender: TObject);
    procedure btnSetupBudgetsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowTheForm;
  end;

var
  fmReviewFarmFinances: TfmReviewFarmFinances;

implementation

{$R *.DFM}

{ TfmBankLinkSummary }

class procedure TfmReviewFarmFinances.ShowTheForm;
begin
   with TfmReviewFarmFinances.Create(nil) do
      try
         ShowModal;
      finally
         Free;
      end;
end;

procedure TfmReviewFarmFinances.btnCostPerUnitClick(Sender: TObject);
var
   Database : Integer;
begin
   SetupReport(rpCostPerUnit);
   Database := EntFile;
   Prog := EntRep;
   Act := 6;
   EntCostPerUnit.ShowModal;
end;

procedure TfmReviewFarmFinances.btnSetupBudgetsClick(Sender: TObject);
begin
   TfmBudgets.ShowBudget;
end;

end.
