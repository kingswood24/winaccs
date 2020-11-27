unit Yearend;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TYearEndForm = class(TForm)
    GroupBox1: TGroupBox;
    ArchiveCheck: TCheckBox;
    ClearCapitolCheck: TCheckBox;
    StandardExitPanel: TPanel;
    Help: TBitBtn;
    SetUpExit: TBitBtn;
    CompanyEdit: TEdit;
    ArchiveEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    ProfitLossEdit: TEdit;
    FinancialEdit: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    CheckBox5: TCheckBox;
    CheckDone: TCheckBox;
    CheckBacked: TCheckBox;
    CheckPrinted: TCheckBox;
    PrintBitBtn: TBitBtn;
    BackupBitbtn: TBitBtn;
    procedure SetUpExitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  YearEndForm: TYearEndForm;

implementation

{$R *.DFM}

procedure TYearEndForm.SetUpExitClick(Sender: TObject);
begin
     Close;
end;

end.
