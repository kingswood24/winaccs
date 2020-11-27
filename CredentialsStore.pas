unit CredentialsStore;

interface
uses
   Classes, LoginCredentials;

type
   TCredentialsStore = class
   public
    class function Save(ALoginCredentials: TLoginCredentials; const AStorePath: string) : boolean;
    class function Load(const AStorePath: string): TLoginCredentials;
    class function IsStoredFor(const AStorePath: string): Boolean;
   end;

implementation
uses
   SysUtils, FileCtrl;

{ TCredentialsStore }

class function TCredentialsStore.IsStoredFor(const AStorePath: string): Boolean;
var
   LoginCredentials: TLoginCredentials;
begin
   LoginCredentials := TCredentialsStore.Load(AStorePath);
   Result := (LoginCredentials <> nil) and (LoginCredentials.IsFilled);
end;

class function TCredentialsStore.Load(const AStorePath: string): TLoginCredentials;
var
   Params : TStringList;
   FileName: string;
begin
   Result := nil;
   FileName := IncludeTrailingBackslash(AStorePath) + 'mtd.cfg';
   Params := TStringList.create();
   try
      if not FileExists(FileName) then Exit;
      try
         Params.LoadFromFile(FileName);
         Result := TLoginCredentials.create();
         Result.Username := Params.Values['username'];
         Result.Password := Params.Values['password'];
      except
         raise Exception.Create('An error occurred while retrieving information.');
      end;
   finally
      FreeAndNil(Params);
   end;
end;

class function TCredentialsStore.Save(ALoginCredentials: TLoginCredentials; const AStorePath: string): boolean;
var
   Params : TStringList;
begin
   Result := False;

   if (ALoginCredentials = nil) then Exit;

   Params := TStringList.create();
   try
      try
         Params.Values['username'] := ALoginCredentials.Username;
         Params.Values['password'] := ALoginCredentials.Password;

         ForceDirectories(AStorePath);
         Params.SaveToFile(IncludeTrailingBackslash(AStorePath) + 'mtd.cfg');
         Result := True;
      except

      end;
   finally
      FreeAndNil(Params);
   end;
end;

end.
