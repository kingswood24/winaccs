unit uQuantityInput;

interface
uses
   SysUtils;

type
  TQuantityInput = class
  private
    FHeading2: string;
    FHeading3: string;
    FQuantity2: Double;
    FQuantity3: Double;
    function GetQuantity2Enabled: Boolean;
    function GetQuantity3Enabled: Boolean;
  public
    property Heading2 : string read FHeading2 write FHeading2;
    property Heading3 : string read FHeading3 write FHeading3;
    property Quantity2 : Double read FQuantity2 write FQuantity2;
    property Quantity3 : Double read FQuantity3 write FQuantity3;
    property Quantity2Enabled : Boolean read GetQuantity2Enabled;
    property Quantity3Enabled : Boolean read GetQuantity3Enabled;
  end;


implementation

{ TQuantityInput }

function TQuantityInput.GetQuantity2Enabled: Boolean;
begin
   Result := (Length(Trim(Heading2)) > 0);
end;

function TQuantityInput.GetQuantity3Enabled: Boolean;
begin
   Result := (Length(Trim(Heading3)) > 0);
end;

end.
 