unit Monthend;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Grids;

type
  TMonthEndForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    CompanyEdit: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    Edit3: TEdit;
    Edit1: TEdit;
    CheckBox5: TCheckBox;
    StandardExitPanel: TPanel;
    Help: TBitBtn;
    SetUpExit: TBitBtn;
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    MonthEndGrid: TStringGrid;
    Button1: TButton;
    procedure SetUpExitClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MonthEndGridDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MonthEndForm: TMonthEndForm;

implementation
uses
    YearEnd;

{$R *.DFM}

procedure TMonthEndForm.SetUpExitClick(Sender: TObject);
begin
     Close;
end;

procedure TMonthEndForm.Button1Click(Sender: TObject);
begin
     YearEndForm.ShowModal;
end;

procedure TMonthEndForm.FormCreate(Sender: TObject);
begin
     MonthEndForm.MonthEndGrid.Cells[0,0] := 'Code';
     MonthEndForm.MonthEndGrid.Cells[1,0] := 'Name';
     MonthEndForm.MonthEndGrid.Cells[2,0] := 'Retain';
     MonthEndForm.MonthEndGrid.Cells[2,1] := 'Unpresented';
end;

procedure TMonthEndForm.MonthEndGridDblClick(Sender: TObject);
begin

     If  MonthEndForm.MonthEndGrid.Cells[2,MonthEndGrid.Row] = 'SELECTED' then
         MonthEndForm.MonthEndGrid.Cells[2,MonthEndGrid.Row] := ''
     else
         MonthEndForm.MonthEndGrid.Cells[2,MonthEndGrid.Row] := 'SELECTED';

end;

end.

