unit PrintPreviewForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges, StdCtrls;

type
  TPrinterDefs = class(TForm)
    Label1: TLabel;
    PrinterCombo: TComboBox;
    NewPrinter: TButton;
    Preview: TButton;
    Gauge: TGauge;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrinterDefs: TPrinterDefs;

implementation

{$R *.DFM}

end.
