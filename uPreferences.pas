unit uPreferences;

interface
uses
   Classes, Registry, Windows, SysUtils;

type
   TPreferences = class
   private
     FReg : TRegistry;
     function GetValueAsString(AName: string): string;
     procedure SetValueAsString(AName: string; const Value: string);
     function GetValueAsBoolean(AName: string): Boolean;
     function GetValueAsDateTime(AName: string): TDateTime;
     function GetValueAsInteger(AName: string): Integer;
     procedure SetValueAsBoolean(AName: string; const Value: Boolean);
     procedure SetValueAsDateTime(AName: string; const Value: TDateTime);
     procedure SetValueAsInteger(AName: string; const Value: Integer);
   public
     function PreferenceExists(AName : string) : Boolean;
     procedure Restore(AFileName : string);
     procedure Backup(AFileName : string);
     function GetValueAsBinary( AName : string; var Buffer; BufSize: Integer): Integer;
     procedure SetValueAsBinary( AName : string; var Buffer; BufSize: Integer);
     constructor Create(AStoreName : string);
     destructor Destroy; override;
     property ValueAsString[AName : string] : string read GetValueAsString write SetValueAsString;
     property ValueAsInteger[AName : string] : Integer read GetValueAsInteger write SetValueAsInteger;
     property ValueAsBoolean[AName : string] : Boolean read GetValueAsBoolean write SetValueAsBoolean;
     property ValueAsDateTime[AName : string] : TDateTime read GetValueAsDateTime write SetValueAsDateTime;
   end;

var
   Preferences : TPreferences;

const
   { Global Preference's Consts }
   cReg_ReadError = 'Failed to get %s Registry Data';

   cReg_DefaultPath = 'Software\Kingswood\Accounts\Preferences\';

implementation

{ TPreferences }

procedure TPreferences.Backup(AFileName: string);
begin

end;

constructor TPreferences.Create(AStoreName: string);
begin
   FReg := TRegistry.Create;
   FReg.RootKey := HKEY_LOCAL_MACHINE;
   FReg.LazyWrite := False;
   if not FReg.KeyExists(cReg_DefaultPath+AStoreName) then
      FReg.CreateKey(cReg_DefaultPath+AStoreName);
   FReg.OpenKey(cReg_DefaultPath+AStoreName, TRUE);
end;

destructor TPreferences.Destroy;
begin
   FReg.CloseKey;
   FreeAndNil(FReg);
   inherited;
end;

function TPreferences.PreferenceExists(AName: string): Boolean;
begin
   Result := FReg.ValueExists(AName);
end;

function TPreferences.GetValueAsBinary(AName: string; var Buffer;
  BufSize: Integer): Integer;
begin
   Result := FReg.ReadBinaryData(AName, Buffer, BufSize);
end;

function TPreferences.GetValueAsBoolean(AName: string): Boolean;
begin
   Result := False;
   if FReg.ValueExists(AName) then
      Result := FReg.ReadBool(AName);
end;

function TPreferences.GetValueAsDateTime(AName: string): TDateTime;
begin
   Result := 0;
   if FReg.ValueExists(AName) then
      Result := FReg.ReadDateTime(AName);
end;

function TPreferences.GetValueAsInteger(AName: string): Integer;
begin

   Result := 0;
   if (FReg = nil) then Exit;

   try
      if FReg.ValueExists(AName) then
         Result := FReg.ReadInteger(AName);
   except
      on e : exception do
         begin
            raise Exception.Create(e.Message);
         end;
   end;
end;

function TPreferences.GetValueAsString(AName : string): string;
begin
   Result := '';
   if FReg.ValueExists(AName) then
      Result := FReg.ReadString(AName);
end;

procedure TPreferences.Restore(AFileName: string);
begin

end;

procedure TPreferences.SetValueAsBinary(AName: string; var Buffer;
  BufSize: Integer);
begin
   FReg.WriteBinaryData(AName, Buffer, BufSize);
end;

procedure TPreferences.SetValueAsBoolean(AName: string;
  const Value: Boolean);
begin
   FReg.WriteBool(AName, Value);
end;

procedure TPreferences.SetValueAsDateTime(AName: string;
  const Value: TDateTime);
begin
   FReg.WriteDateTime(AName, Value);
end;

procedure TPreferences.SetValueAsInteger(AName: string;
  const Value: Integer);
begin
   FReg.WriteInteger(AName, Value);
end;

procedure TPreferences.SetValueAsString(AName: string;
  const Value: string);
begin
   FReg.WriteString(AName, Value);
end;

initialization
   Preferences := nil;

end.
