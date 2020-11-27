unit uReportBaseForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uBaseForm, ActnList, dxBar, dxBarExtItems, cxControls, dxStatusBar;

type
  TfmReportBaseForm = class(TBaseForm)
    procedure blbViewClick(Sender: TObject);
  private
    { Private declarations }
  protected
     procedure BuildReport;dynamic;
  public
    { Public declarations }
  end;

var
  fmReportBaseForm: TfmReportBaseForm;

implementation

{$R *.DFM}

{ TfmReportBaseForm }

procedure TfmReportBaseForm.BuildReport;
begin

end;

procedure TfmReportBaseForm.blbViewClick(Sender: TObject);
begin
  inherited;
  BuildReport;
end;

end.
