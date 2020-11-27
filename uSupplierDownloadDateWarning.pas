unit uSupplierDownloadDateWarning;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, cxButtons;

type
  TfmSupplierDownloadDateWarning = class(TForm)
    Bevel1: TBevel; 
    lWarning: TLabel;
    btnOK: TcxButton;
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowDateWarning;
  end;

var
  fmSupplierDownloadDateWarning: TfmSupplierDownloadDateWarning;

implementation

{$R *.DFM}

{ TfmSupplierDownloadDateWarning }

class procedure TfmSupplierDownloadDateWarning.ShowDateWarning;
begin
   with TfmSupplierDownloadDateWarning.Create(nil) do
      try
         ShowModal;
      finally
         Free;
      end;
end;

end.
