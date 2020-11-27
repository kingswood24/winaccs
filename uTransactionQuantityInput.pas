unit uTransactionQuantityInput;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxControls, cxContainer, cxEdit, cxGroupBox, cxTextEdit, cxCurrencyEdit,
  StdCtrls, cxButtons, cxLabel, uQuantityInput;

type
  TfmTransactionQuantityInput = class(TForm)
    cxGroupBox1: TcxGroupBox;
    lQuantity2: TcxLabel;
    lQuantity3: TcxLabel;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    ceQuantity2: TcxCurrencyEdit;
    ceQuantity3: TcxCurrencyEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ceQuantity3PropertiesEditValueChanged(Sender: TObject);
    procedure ceQuantity2PropertiesEditValueChanged(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FQuantityInput : TQuantityInput;
    procedure SetupForm;
  public
    { Public declarations }
    class function Show(var AQuantityInput : TQuantityInput) : Boolean;
    class function ShowAt(var AQuantityInput : TQuantityInput;
        const X : Integer = -1; const Y : Integer = -1) : Boolean;
  end;

var
  fmTransactionQuantityInput: TfmTransactionQuantityInput;

implementation

{$R *.DFM}

{ TfmTransactionQuantityInput }

procedure TfmTransactionQuantityInput.SetupForm;
begin
   if (FQuantityInput.Quantity2Enabled) then
      begin
         lQuantity2.Caption := FQuantityInput.Heading2+': ';
         ceQuantity2.Value := FQuantityInput.Quantity2;
      end
   else
      begin
         lQuantity2.Hide;
         ceQuantity2.Hide;
      end;


   if (FQuantityInput.Quantity3Enabled) then
      begin
         lQuantity3.Caption := FQuantityInput.Heading3+': ';
         ceQuantity3.Value := FQuantityInput.Quantity3;
      end
   else
      begin
         lQuantity3.Hide;
         ceQuantity3.Hide;
      end;

   if ((not (FQuantityInput.Quantity2Enabled)) and (FQuantityInput.Quantity3Enabled)) then
      begin
         // move quantity 3 into quantity 2 position.
         lQuantity3.Top := lQuantity2.Top;
         ceQuantity3.Top := ceQuantity2.Top;
      end;
end;

class function TfmTransactionQuantityInput.Show(
  var AQuantityInput: TQuantityInput) : Boolean;
begin
   Result := ShowAt(AQuantityInput);
end;

class function TfmTransactionQuantityInput.ShowAt(var AQuantityInput : TQuantityInput;
   const X : Integer; const Y : Integer) : Boolean;
begin
   Result := False;
   if (AQuantityInput = nil) or
      (not(AQuantityInput.Quantity2Enabled) and
       not(AQuantityInput.Quantity3Enabled)) then Exit;
   
   with TfmTransactionQuantityInput.Create(nil) do
      try
         FQuantityInput := AQuantityInput;
         if (X > -1) and (Y > -1) then
            begin

               if (( Left + Width ) > Screen.Width) then
                  Left := Screen.Width - ( Width + 15 )
               else
                  Left := X;
               Top := Y;
            end
         else
            begin
               Position := poDesktopCenter;
            end;
         SetupForm;

         if (ShowModal = mrOK) then
            begin
               Result := True;
               AQuantityInput := FQuantityInput;
            end;
      finally
         FQuantityInput := nil;
         Free;
      end;
end;

procedure TfmTransactionQuantityInput.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   ceQuantity2.PostEditValue;
   ceQuantity3.PostEditValue;
end;

procedure TfmTransactionQuantityInput.ceQuantity3PropertiesEditValueChanged(
  Sender: TObject);
begin
   try
      FQuantityInput.Quantity3 := ceQuantity3.Value;
   except
      FQuantityInput.Quantity3 := 0;
   end;
end;

procedure TfmTransactionQuantityInput.ceQuantity2PropertiesEditValueChanged(
  Sender: TObject);
begin
   try
      FQuantityInput.Quantity2 := ceQuantity2.Value;
   except
      FQuantityInput.Quantity2 := 0;
   end;
end;

procedure TfmTransactionQuantityInput.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (Key = VK_ESCAPE) then
      Close;
end;

end.
