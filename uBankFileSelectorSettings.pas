unit uBankFileSelectorSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxShellComboBox, StdCtrls, cxButtons, cxGroupBox;

type
  TfmBankFileSelectorSettings = class(TForm)
    cxGroupBox1: TcxGroupBox;
    Label2: TLabel;
    shlcbDefaultDirectory: TcxShellComboBox;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
     FDefaultPath : string;
  public
    { Public declarations }
    class procedure ShowSettings;
  end;

var
  fmBankFileSelectorSettings: TfmBankFileSelectorSettings;

implementation

uses FileCtrl, AccsData;

{$R *.DFM}

procedure TfmBankFileSelectorSettings.FormCreate(Sender: TObject);
begin
   FDefaultPath := AccsDataModule.DefaultStatementDirectory;
   shlcbDefaultDirectory.Path := FDefaultPath;
end;

procedure TfmBankFileSelectorSettings.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
   if (ModalResult = mrOK) then
      begin
         if not DirectoryExists(shlcbDefaultDirectory.Path) then
            begin
               MessageDlg('Please select a valid directory',mtwarning,[mbOK],0);
               shlcbDefaultDirectory.DoEditing;
               CanClose := False;
            end
         else if (shlcbDefaultDirectory.Path <> FDefaultPath) then
            AccsDataModule.DefaultStatementDirectory := shlcbDefaultDirectory.Path;
      end;
end;

class procedure TfmBankFileSelectorSettings.ShowSettings;
begin
   with TfmBankFileSelectorSettings.Create(nil) do
      try
         ShowModal;
      finally
         Free;
      end;
end;

end.
