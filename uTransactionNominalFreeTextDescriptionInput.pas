unit uTransactionNominalFreeTextDescriptionInput;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxTextEdit, StdCtrls, cxButtons, cxLabel, cxControls, cxContainer,
  cxEdit, cxGroupBox;

type
  TfmTransactionNominalFreeTextDescriptionInput = class(TForm)
    cxGroupBox1: TcxGroupBox;
    lQuantity2: TcxLabel;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    teDescription: TcxTextEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    class function GetText(const ANominalDescription : string) : string;
    class function GetTextAt(const ANominalDescription : string;
        const X : Integer = -1; const Y : Integer = -1) : string;
  end;

var
  fmTransactionNominalFreeTextDescriptionInput: TfmTransactionNominalFreeTextDescriptionInput;

implementation

{$R *.DFM}

{ TfmTransactionNominalFreeTextDescriptionInput }

class function TfmTransactionNominalFreeTextDescriptionInput.GetTextAt(
  const ANominalDescription: string; const X, Y: Integer): string;
begin
   Result := ANominalDescription;
   with TfmTransactionNominalFreeTextDescriptionInput.Create(nil) do
      try
         if (X > -1) and (Y > -1) then
            begin
               if (( Left + Width ) > Screen.Width) then
                  Left := Screen.Width - ( Width + 15 )
               else
                  Left := X;
               Top := Y;
            end
         else
            Position := poDesktopCenter;

         teDescription.Text := ANominalDescription;
         if (ShowModal = mrOK) then
            begin
               teDescription.PostEditValue;
               if (teDescription.Text <> '') then
                  Result := teDescription.Text
            end;
      finally
         Free;
      end;
end;

procedure TfmTransactionNominalFreeTextDescriptionInput.FormKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (Key = VK_ESCAPE) then
      Close;
end;


class function TfmTransactionNominalFreeTextDescriptionInput.GetText(
  const ANominalDescription: string): string;
begin
   Result := GetTextAt(ANominalDescription);
end;

end.
