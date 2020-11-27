unit RegisterForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFormType = (ftUnlock, ftAddExecs);
  TRegister = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    SerialNumber: TEdit;
    AuthorisationKey: TEdit;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label8: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label9: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label10: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure AuthorisationKeyChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    AccRun : Boolean;
  end;

var
  Register: TRegister;

implementation
uses
   Registry, uKingsCC;

{$R *.DFM}

procedure TRegister.FormActivate(Sender: TObject);
var
   Registry : TRegistry;
begin
   Registry := TRegistry.Create;
   Registry.OpenKey('Software\Kingswood\kacc', True);
   SerialNumber.Text := Registry.ReadString('Serial Number');
   Registry.Free;
//   UKingscc.ReadKCC(UKingsCC.BackupSerial.CCRec);
   UKingsCC.alrinst;
   Label4.caption := vartostr(UKingsCC.TokenSerialNo);

end;

procedure TRegister.Button1Click(Sender: TObject);
var
    Registry                      : TRegistry;
begin
   Registry := TRegistry.Create;
   Registry.OpenKey('Software\Kingswood\kacc', True);
   Registry.WriteString('Authorisation Key', AuthorisationKey.Text);
   Registry.Free;

   if (( Trim(AuthorisationKey.Text) = '')  and ((Trim(Edit1.Text) <> '' ) and (Trim(Edit2.Text) <> '' ) and (Trim(Edit4.Text) <> '' ) and (Trim(Edit3.Text) <> '' ) ))  then
      uKingsCC.UpdateExecs(Trim(Edit4.Text), Trim(Edit1.Text), Trim(Edit2.Text), Trim(Edit3.Text))
   else if (( AuthorisationKey.Text <> '' ) and ( (Trim(Edit1.Text) = '' ) and  (Trim(Edit2.Text) = '' ) and (Trim(Edit4.Text) = '' ) and (Trim(Edit3.Text) = '' ) ) )  then
      uKingsCC.KCC(True)
   else
      ShowMessage('Unable to complete upatdate!');
   Close;
end;

procedure TRegister.Edit1Change(Sender: TObject);
begin
   if Length(Trim(TEdit(Sender).Text)) > 0 then
      AuthorisationKey.Text := '';
end;

procedure TRegister.AuthorisationKeyChange(Sender: TObject);
begin
   if Length(Trim(TEdit(Sender).Text)) > 0 then
      begin
         Edit1.Text := '';
         Edit2.Text := '';
         Edit3.Text := '';
         Edit4.Text := '';
      end;
end;

procedure TRegister.Button2Click(Sender: TObject);
begin
   Close;
   if not AccRun then
      Halt;
end;

procedure TRegister.FormCreate(Sender: TObject);
begin
   AccRun := False;
end;

end.
