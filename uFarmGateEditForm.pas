unit uFarmGateEditForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfmFarmGateEditForm = class(TForm)
    NameEdit: TEdit;
    Button1: TButton;
    Button2: TButton;
    SerialNoEdit: TEdit;
    Name: TLabel;
    SerialNo: TLabel;
    DefaultCompanyNameEdit: TEdit;
    Label1: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure DefaultCompanyNameEditExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmFarmGateEditForm: TfmFarmGateEditForm;

implementation

uses DbCore, Params, DefSecFl;

{$R *.DFM}

procedure TfmFarmGateEditForm.Button2Click(Sender: TObject);
var
   SerialNoArray : packed array [1..8] Of Char;
begin

   try
      StrToInt(SerialNoEdit.Text);
   except
      MessageDlg('Invalid serial number entered',mtError,[mbOK],0);
      Exit;
   end;

   if (StrToInt(SerialNoEdit.Text) <= 0) then
      begin
         MessageDlg('Serial number must be greater than 0.',mtError,[mbOK],0);
         Exit;
      end;

   if Length(Trim(NameEdit.Text)) = 0 then
      begin
         MessageDlg('Name must be entered',mtError,[mbOK],0);
         Exit;
      end;


   if Length(Trim(DefaultCompanyNameEdit.Text)) = 0 then
      DefaultCompanyNameEdit.Text := 'ACCS';

   DelphiLongToPSys(StrToInt(SerialNoEdit.Text), RFarmGate.PSerial);

   RFarmGate.PUSER := NameEdit.Text;

   RFarmGate.plocation[2] := DefaultCompanyNameEdit.Text;
   SecWrite;

   MessageDlg('File saved. Exit program and restart',mtInformation,[mbOK],0);

end;

procedure TfmFarmGateEditForm.DefaultCompanyNameEditExit(Sender: TObject);
begin
   if Length(Trim(DefaultCompanyNameEdit.Text)) = 0 then
      DefaultCompanyNameEdit.Text := 'ACCS';
end;

procedure TfmFarmGateEditForm.FormCreate(Sender: TObject);
begin
   SerialNoEdit.Text := IntToStr(PSysLongToDelphi ( RFarmGate.PSerial ));

   NameEdit.Text := RFarmGate.PUSER;

   DefaultCompanyNameEdit.Text := RFarmGate.plocation[2];
end;

end.
