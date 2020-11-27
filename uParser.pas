unit uParser;

interface
uses
  Classes;

type
   TParser = class
   private
    FLine : String;
    FFieldSep : String;
    FNumFields: Byte;
    Index,
    CT: array[0..255] of integer;
    function Getstr(n: byte): string;
    function GetFieldSep: String;
    procedure SetFieldSep(const Value: String);
   public
     procedure Parse(Line : String);
     constructor Create;
     destructor Destroy;override;
      property FieldSep  : String read GetFieldSep write SetFieldSep;
      property Parsecount: Byte read FNumFields;
      property Parsefields[n: byte]: string read Getstr;
   end;


implementation

{ TParser }

constructor TParser.Create;
begin
   FieldSep := '';
end;

destructor TParser.Destroy;
begin
  inherited;

end;

function TParser.GetFieldSep: String;
begin
   Result := FFieldSep;
end;

procedure TParser.SetFieldSep(const Value: String);
begin
   FFieldSep := Value;
end;

function TParser.Getstr(n: byte): string;
begin
  result := '';
  if n > FNumFields then
    exit;
  if n = 0 then
    result := FLine
  else if n > 0 then
   begin
    dec(n); {0 - based arrays!}
    if Index[n] > 0 then
      result := copy(FLine, index[n], ct[n]);
   end;
end;

procedure TParser.Parse(Line: String);
var
   i, p : byte;
   s,
   s2 : string;
begin
   Fline     := Line + FFieldSep;
   S         := Fline;
   FNumFields := 0;

   i := Pos(FFieldSep, S);

   while i > 0 do
      begin
         S2 := copy (s,1,i -1);

         if FNumFields = 0 then
            index[FNumFields] := 1
         else
            index[FNumFields] := pos(s2,fline);

         ct[FNumFields] := length(s2);

        delete(s,1,i);
        i := pos(FFieldSep, s);
        inc(FNumFields);

      end;
end;


end.
