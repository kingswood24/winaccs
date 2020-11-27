unit Nlreps;

interface         

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TEntReportForm = class(TForm)
    Help: TBitBtn;
    Exit: TBitBtn;
    GroupBox1: TGroupBox;
    panel1: TPanel;
    EntPerUnitRadio: TRadioButton;
    EntCostThisYearRadio: TRadioButton;
    EntCostThisYearVLastRadio: TRadioButton;
    EntThisYearVBudAndLastYearRadio: TRadioButton;
    LastYearMonthlyRadio: TRadioButton;
    ThisYearMonthlyRadio: TRadioButton;
    procedure FormActivate(Sender: TObject);
    procedure EntCostThisYearRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EntCostThisYearVLastRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EntThisYearVBudAndLastYearRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LastYearMonthlyRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ThisYearMonthlyRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EntPerUnitRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    DataBase : Integer;
  end;

var
  EntReportForm: TEntReportForm;

implementation
Uses
  pickdate,
  newlisting,
  calcs,
  vars,
  types,
  DBRPT,
  EntReps;
{  NominalReports;}

{$R *.DFM}

procedure TEntReportForm.FormActivate(Sender: TObject);
Begin
     EntCostThisYearRadio.SetFocus;
     caption := 'Enterprise Reports';{ + ' - ' + st;}
end;

procedure TEntReportForm.EntCostThisYearRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     EntReportForm.Database := EntFile;
     EntCostThisYearRadio.Checked := True;
     EntReps.EntCostPerUnit.ShowModal;
end;

procedure TEntReportForm.EntCostThisYearVLastRadioMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    EntReportForm.Database := EntFile;
    EntCostThisYearVLAstRadio.Checked := True;
    EntReps.EntCostPerUnit.ShowModal;
end;

procedure TEntReportForm.EntThisYearVBudAndLastYearRadioMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
     EntReportForm.Database := EntFile;
     EntThisYearVBudAndLastYearRadio.Checked := True;
     EntReps.EntCostPerUnit.ShowModal;
end;

procedure TEntReportForm.LastYearMonthlyRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     EntReportForm.Database := EntFile;
     LastYearMonthlyRadio.Checked := True;
     EntReps.EntCostPerUnit.ShowModal;
end;

procedure TEntReportForm.ThisYearMonthlyRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     EntReportForm.Database := EntFile;
     ThisYearMonthlyRadio.Checked := True;
     EntReps.EntCostPerUnit.ShowModal;
end;

procedure TEntReportForm.EntPerUnitRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     EntReportForm.Database := EntFile;
     EntPerUnitRadio.Checked := True;
     EntReps.EntCostPerUnit.ShowModal;
end;

procedure TEntReportForm.HelpClick(Sender: TObject);
begin
     Application.HelpContext(110);
end;

procedure TEntReportForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If KEY = VK_F1 then
        Application.HelpContext(110);     
end;

end.
