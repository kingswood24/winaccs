unit MD5Convert;

interface
 uses
 MD5;

 function GenerateHash(AValue : string) : String;

implementation

function GenerateHash(AValue : string) : String;
begin
   Result := LowerStrMD5( AValue );
end;

end.
