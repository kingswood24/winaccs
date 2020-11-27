unit ProformaQuote;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TProformaQuoteForm = class(TForm)
    RadioGroup1: TRadioGroup;
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProformaQuoteForm: TProformaQuoteForm;

implementation

{$R *.DFM}

procedure TProformaQuoteForm.RadioGroup1Click(Sender: TObject);
begin
     Close;
end;

end.
