unit password;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, cxButtons;

type
  TPasswordForm = class(TForm)
    PasswordEdit: TEdit;
    Label1: TLabel;
    OKBtn: TcxButton;
    CancelBtn: TcxButton;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Password : string;
  end;

var
  PasswordForm: TPasswordForm;

implementation

{$R *.DFM}


procedure TPasswordForm.OKBtnClick(Sender: TObject);
begin
     Password := passwordedit.text;
     close;
end;

procedure TPasswordForm.CancelBtnClick(Sender: TObject);
begin
     Password := '';
     close;
end;

procedure TPasswordForm.FormShow(Sender: TObject);
begin
     Password := '';
     PasswordEdit.text := '';
     PasswordEdit.SetFocus;
end;

end.
