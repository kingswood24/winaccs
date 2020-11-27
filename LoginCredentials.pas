unit LoginCredentials;

interface
uses
   SysUtils;

type
  TLoginCredentials = class
  private
    FUsername: string;
    FPassword: string;
    function getIsFilled: Boolean;
  public
    constructor create();overload;
    constructor create(AUsername: string; APassword: string);overload;
    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property IsFilled: Boolean read getIsFilled;
  end;

implementation

{ TLoginCredentials }

constructor TLoginCredentials.create;
begin

end;

constructor TLoginCredentials.create(AUsername, APassword: string);
begin
   FUsername := AUsername;
   FPassword := APassword;
end;

function TLoginCredentials.getIsFilled: Boolean;
begin
   Result := (Trim(FUsername) <> '') and (Trim(FPassword)<>'');
end;

end.
 