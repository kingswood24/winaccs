unit uBankFileFormatSelector;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, cxButtons, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBLookupComboBox, cxTextEdit, cxLabel, cxControls,
  cxContainer, cxEdit, cxGroupBox;

type
  TfmBankFileFormatSelector = class(TForm)
    cxGroupBox1: TcxGroupBox;
    lBankName: TcxLabel;
    teBankName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cmboFileFormats: TcxLookupComboBox;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ShowSelector(const ABankName : string;
       const AExistingFormat : Integer = 0) : Integer;
  end;

var
  fmBankFileFormatSelector: TfmBankFileFormatSelector;

implementation

uses AccsData;

{$R *.DFM}

{ TfmBankFileFormatSelector }

class function TfmBankFileFormatSelector.ShowSelector(
  const ABankName: string; const AExistingFormat : Integer): Integer;
begin
   with TfmBankFileFormatSelector.Create(nil) do
      try
         AccsDataModule.BankCSVDefaults.DataSet.Active := True;
         teBankName.Text := ABankName;

         // If changing from one format to another
         if (AExistingFormat>0) then
            cmboFileFormats.EditValue := AExistingFormat;

         if (ShowModal = mrOK) then
            Result := cmboFileFormats.EditValue;
      finally
         AccsDataModule.BankCSVDefaults.DataSet.Active := False;
         Free;
      end;
end;

procedure TfmBankFileFormatSelector.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
   if (Modalresult = mrOK) then
      begin
         if VarIsNull(cmboFileFormats.EditValue) then
            begin

               Canclose := false;
            end;
      end;
end;

end.
