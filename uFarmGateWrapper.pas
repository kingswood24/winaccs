unit uFarmGateWrapper;

interface
uses
   SysUtils;

type
   TFarmGateWrapper = class
   public
     procedure SetDefaultCompany(const ACompanyName : string);
   end;

function FarmGateWrapper : TFarmGateWrapper;

var
   _farmGateWrapper : TFarmGateWrapper;

implementation
uses
    PARAMS,DefSecFl;

function FarmGateWrapper : TFarmGateWrapper;
begin
   if (_farmGateWrapper = nil) then
      _farmGateWrapper := TFarmGateWrapper.Create;
   Result := _farmGateWrapper;
end;

{ TFarmGateWrapper }

procedure TFarmGateWrapper.SetDefaultCompany(const ACompanyName: string);
begin
   RFarmGate.plocation[2] := ACompanyName;
   SecWrite;
end;

initialization

finalization
  if (_farmGateWrapper <> nil) then
     FreeAndNil(_farmGateWrapper);

end.
