unit UYearEndTransWarning;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFYearEndTransWarning = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    Image2: TImage;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure Setcaption(ACaption:String);
    class Function ShowTheForm (AFinancialStart, AFinancialEnd : String) : boolean;


  end;

var
  FYearEndTransWarning: TFYearEndTransWarning;

implementation

uses
 Uyearend;

{$R *.DFM}

{ TFYearEndTransWarning }



{ TFYearEndTransWarning }

procedure TFYearEndTransWarning.Setcaption(ACaption: String);
begin
   Label2.caption:=ACaption;
end;

procedure TFYearEndTransWarning.Button2Click(Sender: TObject);
begin
close;
end;

class Function TFYearEndTransWarning.ShowTheForm(AFinancialStart, AFinancialEnd: String): boolean;
begin
   Result := false;
   with TFYearEndTransWarning.Create(nil) do
      try
         if ( Length(AFinancialStart) = 0 ) and ( Length(AFinancialEnd) = 0 ) then
            Exit
         else
            begin
               Label2.Caption := 'Date entered not in Current Year - ' + AFinancialStart + ' To ' + AFinancialEnd + '.'+#13#10+
                                 'The system will revert to last valid date entered.';
               result := ShowModal = mrOK;
            end;
      finally
         Free;
      end;
end;

end.
