unit Jnltype;

interface

uses              
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TFJnlType = class(TForm)
    IncomeCheck: TCheckBox;
    ExpendCheck: TCheckBox;
    Bevel1: TBevel;
    procedure IncomeCheckClick(Sender: TObject);
    procedure ExpendCheckClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    JnlType : Integer;
  end;

var
  FJnlType: TFJnlType;

implementation

{$R *.DFM}

procedure TFJnlType.IncomeCheckClick(Sender: TObject);
begin
     JnlType := 2;
     ExpendCheck.Checked := False;
     Close;
end;

procedure TFJnlType.ExpendCheckClick(Sender: TObject);
begin
     JnlType := 3;
     IncomeCheck.Checked := False;
     Close;
end;

procedure TFJnlType.FormActivate(Sender: TObject);
begin
     JnlType := 0;
     InComeCheck.Checked := False;
     ExpendCheck.checked := False;
end;

end.
