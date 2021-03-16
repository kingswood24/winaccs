unit CredentialsStore;

interface
uses
   Classes, LoginCredentials;

type
   TCredentialsStoreType = ( cstMTD, cstBilling );
   TCredentialsStore = class
   public
    class function Save(ALoginCredentials: TLoginCredentials; const AStorePath: string; const ACredentialsStoreType : TCredentialsStoreType) : boolean;
    class function Load(const AStorePath: string; const ACredentialsStoreType : TCredentialsStoreType): TLoginCredentials;
    class function IsStoredFor(const AStorePath: string; const ACredentialsStoreType : TCredentialsStoreType): Boolean;
   end;

implementation
uses
   SysUtils, FileCtrl;

{ TCredentialsStore }

class function TCredentialsStore.IsStoredFor(
  const AStorePath: string; const ACredentialsStoreType : TCredentialsStoreType): Boolean;
var
   LoginCredentials: TLoginCredentials;
begin
   LoginCredentials := TCredentialsStore.Load(AStorePath,ACredentialsStoreType);
   Result := (LoginCredentials <> nil) and (LoginCredentials.IsFilled);
end;

class function TCredentialsStore.Load(
  const AStorePath: string;
  const ACredentialsStoreType : TCredentialsStoreType): TLoginCredentials;
var
   Params : TStringList;
   FileName: string;
begin
   Result := nil;
   if ( ACredentialsStoreType = cstMTD ) then
      FileName := IncludeTrailingBackslash(AStorePath) + 'mtd.cfg'
   else if ( ACredentialsStoreType = cstBilling ) then
      FileName := IncludeTrailingBackslash(AStorePath) + 'billing.cfg';
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

class function TCredentialsStore.Save(
  ALoginCredentials: TLoginCredentials; const AStorePath: string;
  const ACredentialsStoreType : TCredentialsStoreType): boolean;
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
         if ( ACredentialsStoreType = cstMTD ) then
            Params.SaveToFile(IncludeTrailingBackslash(AStorePath) + 'mtd.cfg')
         else if ( ACredentialsStoreType = cstBilling ) then
            Params.SaveToFile(IncludeTrailingBackslash(AStorePath) + 'billing.cfg');
         Result := True;
      except

      end;
   finally
      FreeAndNil(Params);
   end;
end;

end.
