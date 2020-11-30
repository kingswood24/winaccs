//   30/11/20 [V4.5 R4.6] /MK Change - Change char length of teNewCompanyName - TGM Request.

unit uRestoreToNewCompanyName;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxLabel, cxControls, cxContainer, cxEdit, cxTextEdit, ActnList, StdCtrls,
  cxButtons;

type
  TfmRestoreToNewCompanyName = class(TForm)
    teNewCompanyName: TcxTextEdit;
    lNewCompanyName: TcxLabel;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    FOldCompanyName,
    FNewCompanyName : String;
  public
    { Public declarations }
    class function NewCompanyName ( ACompanyName : String ) : String;
  end;

var
  fmRestoreToNewCompanyName: TfmRestoreToNewCompanyName;

implementation

{$R *.DFM}

{ TfmRestoreToNewCompanyName }

class function TfmRestoreToNewCompanyName.NewCompanyName(ACompanyName: String): String;
begin
   with TfmRestoreToNewCompanyName.Create(nil) do
      try
         FOldCompanyName := ACompanyName;
         teNewCompanyName.Text := FOldCompanyName;
         ShowModal;
         FNewCompanyName := teNewCompanyName.Text;
         if ( ModalResult = mrOK ) then
            Result := FNewCompanyName
         else
            Result := '';
      finally
         Free;
      end;
end;

procedure TfmRestoreToNewCompanyName.btnOKClick(Sender: TObject);
begin
   if ( Length(teNewCompanyName.Text) = 0 ) then
      begin
         MessageDlg('Please enter a new company name.',mtError,[mbOK],0);
         ModalResult := mrNone;
      end
   else
      ModalResult := mrOK;
end;

end.
