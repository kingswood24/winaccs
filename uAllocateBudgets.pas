unit uAllocateBudgets;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  Tfallocatebudgets = class(TForm)
    AllocateBtn: TButton;
    CancelBtn: TButton;
    BudgetRG: TRadioGroup;
    procedure CancelBtnClick(Sender: TObject);
    procedure AllocateBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fallocatebudgets: Tfallocatebudgets;

implementation

uses uBudgets, AccsData;

{$R *.DFM}

procedure Tfallocatebudgets.CancelBtnClick(Sender: TObject);
begin
     showmessage('Year Total reverting to original value.' + #10#13 + #10#13 + 'Year Total will automatically be recalculated when the individual month values are changed.');
     self.close;
end;

procedure Tfallocatebudgets.AllocateBtnClick(Sender: TObject);
begin
     if budgetrg.ItemIndex = 0 then accsdatamodule.AllocateBudget
        else accsdatamodule.AllocateBudgetZeros;
     self.close;
end;

end.
