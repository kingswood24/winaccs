{
MIT License

Copyright (c) 2018 badunius

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

}
unit JSON;

interface

uses
  SysUtils, Classes;

type
  JSONDataType = (dtValue, dtObject, dtArray, dtUnset);
  JSONValueType = (vtText, vtNumber, vtBoolean, vtNull);

  JSONItem = class
  private
    // item name
    fKey: string;
    // item type (value/object/array)
    fType: JSONDataType;
    // if item type is value, additionaly specify value type (text/number/boolean)
    fValType: JSONValueType;
    // value (if item type is value)
    fValue: string;
    // child nodes (if item type is object/array)
    fChild: array of JSONItem;

    // getters
    function getItem(key: string): JSONItem;
    function getCode: string;
    function getKey(index: integer): string;
    function getElem(index: integer): JSONItem;
    function hasKey(key: string): boolean;

    // parse code
    procedure setCode(aCode: string);

    // utility
    procedure clear_child;

    // this metod do actual parsing, returns the rest (unparsed) of the code
    function internal_parse(aCode: string): string;overload;
    // those methods read values and return the rest of the code
    function readValue(aCode: string): string;
    function readObject(aCode: string): string;
    function readArray(aCode: string): string;
    function readNumber(aCode: string): string;
    function readBoolean(aCode: string): string;
    function readNull(aCode: string): string;

    function StrToFloatDef(const S: string;
             const Default: Extended): Extended;
    function TryStrToFloat(const S: string;
             out Value: Extended): Boolean;
  public
    // Item's name (key)
    property Name: string read fKey;
    // Returns child node by it's key
    property Item[key: string]: JSONItem read getItem; default;
    // Own code setter/getter (assign opne item's code to another to clone it)
    property Code: string read getCode write setCode;
    // Returns child node key by it's index
    property Key[index: integer]: string read getKey;
    // Returns child node by it's index (for arrays, but will also work for objects)
    property Value[index: integer]: JSONItem read getElem;
    // Returns if the node has some key (better than get value and check if it's equal to default)
    property Has[key: string]: boolean read hasKey;

    constructor Create;
    destructor Destroy; override;

    // Child nodes count
    function Count: integer;
    // Remove n-th node
    procedure Remove(n: integer);
    // Load/Save own code
    procedure LoadFromStream(AStream: TStringStream);

    procedure LoadFromFile(filename: string);
    procedure SaveToFile(filename: string);

    // terminal node's (leafs) methods
    //  setters
    procedure setInt(value: integer);
    procedure setNum(value: double);
    procedure setStr(value: string);
    procedure setBool(value: boolean);
    procedure setType(aType: JSONDataType);

    //   getters
    function getInt(default: integer = 0): integer;
    function getNum(default: double = 0): double;
    function getStr(default: string = ''): string;
    function getBool(default: boolean = false): boolean;
    function getType(default: JSONDataType = dtUnset): JSONDataType;
    function getJSON: string;

    // NULL-handling
    procedure setNull;
    function isNull: boolean;

    class function Parse(AValue: string) : JSONItem;overload;
    class function Parse(AStream: TStringStream) : JSONItem;overload;
  end;

implementation

const
  WHITESPACE: set of char =  [#9, #10, #13, #32];
  DIGITS: set of char =  ['0'..'9'];
  SIGNS: set of char = ['+', '-'];

class function JSONItem.Parse(AValue: string): JSONItem;
begin
   Result := JSONItem.Create;
   Result.Code := AValue;
end;

class function JSONItem.Parse(AStream: TStringStream): JSONItem;
begin
   Result := JSONItem.Create;
   Result.LoadFromStream(AStream);
end;

// removes all the whitespaces from the begining of the line
function wsTrim(src: string): string;
var
  n, l: integer;
begin
  n := 1;
  l := Length(src);

  while (src[n] in WHITESPACE) do begin
    n := n + 1;
    if n >= l
      then Break;
  end;

  result := Copy(src, n, l - n + 1);
end;

{ myJSONItem }

procedure JSONItem.clear_child;
var
  i: integer;
begin
  // recursively removes all childs
  for i := 0 to high(fChild) do
    fChild[i].Free;
  SetLength(fChild, 0);
end;

function JSONItem.Count: integer;
begin
  result := Length(fChild);
end;

constructor JSONItem.Create;
begin
  // Should've set initial values
  // But root node don't need them and child node will get them on parsing/from setter
  // or when they are called for the first time
end;

destructor JSONItem.Destroy;
begin
  // mem leaks prevention
  clear_child;

  inherited;
end;

function JSONItem.getBool(default: boolean): boolean;
var
  f: double;
begin
  // defaulting
  result := default;

  if self = nil
    then Exit;

  // type checking
  if fType <> dtValue
    then Exit;

  // checking alphabetic values
  if fValue = ''
    then Exit; // unset - defaulting

  if LowerCase(fValue) = 'true' then begin
    result := true;
    Exit;
  end;

  if LowerCase(fValue) = 'false' then begin
    result := false;
    Exit;
  end;

  // checking numeral values
  if default
    then f := 1
    else f := 0;
  f := StrToFloatDef(fValue, f);

  if f > 0
    then result := true
    else result := false;
end;

function JSONItem.getCode: string;
var
  i: integer;
begin
  result := '""';
  if self = nil
    then Exit;
  case self.fType of
    dtObject: begin
      result := '{';
      // adding childrens code
      for i := 0 to high(fChild) do begin
        result := result + fChild[i].Code;
        if i < high(fChild)
          then result := result + ',';
      end;
      result := result + '}';
    end;  
    dtArray: begin
      result := '[';
      // children's code
      for i := 0 to high(fChild) do begin
        result := result + fChild[i].Code;
        if i < high(fChild)
          then result := result + ',';
      end;
      result := result + ']';
    end;
    dtValue: begin
      // only text values should be enquoted
      if fValType <> vtText
        then result := fValue
        else result := '"' + fValue + '"';
    end;
  end;

  // if we have a key - add it before our value
  if fKey <> ''
    then result := '"' + fKey + '":' + result;
end;

function JSONItem.getElem(index: integer): JSONItem;
var
  i: integer;
begin
  // Item type is not changed, unlike getItem
  result := nil;
  if (fType <> dtObject) and (fType <> dtArray)
    then Exit;
  // range check
  if index < 0
    then Exit;

  if fType = dtObject then begin    if index <= high(fChild)
      then result := fChild[index];
    Exit;
  end;

  if fType = dtArray then begin
    if high(fChild) < index
      then SetLength(fChild, index + 1);
    for i := high(fChild) downto 0 do
      if fChild[i] = nil
        then fChild[i] := JSONItem.Create
        else Break;
    result := fChild[index];
  end;
end;

function JSONItem.getInt(default: integer): integer;
var
  f: double;
begin
  result := default;

  if self = nil
    then Exit;

  if fType <> dtValue
    then Exit;

  if fValue = 'true' then begin
    result := 1;
    Exit;
  end;
  if fValue = 'false' then begin
    result := 0;
    Exit;
  end;

  f := StrToFloatDef(fValue, default);

  result := Trunc(f);
end;

function JSONItem.getItem(key: string): JSONItem;
var
  i, n: integer;
begin
  result := nil;
  if self = nil
    then Exit;

  if fType <> dtObject
    then setType(dtObject);

  key := LowerCase(key);
  n := -1;
  for i := 0 to high(fChild) do
    if LowerCase(fChild[i].fKey) = key then begin
      n := i;
      Break;
    end;

  if n < 0 then begin
    SetLength(fChild, Length(fChild) + 1);
    n := high(fChild);
    fChild[n] := JSONItem.Create;
    fChild[n].fKey := key;
  end;

  result := fChild[n];
end;

function JSONItem.getJSON: string;
var
  i: integer;
begin
  // FIXME: this is the same code as in getCode (except we don't add "key":), gotta do something about this
  result := '""';
  if self = nil
    then Exit;

  case self.fType of
    dtObject: begin
      result := '{';
      // adding childrens code
      for i := 0 to high(fChild) do begin
        result := result + fChild[i].Code;
        if i < high(fChild)
          then result := result + ',';
      end;
      result := result + '}';
    end;  
    dtArray: begin
      result := '[';
      // children's code
      for i := 0 to high(fChild) do begin
        result := result + fChild[i].Code;
        if i < high(fChild)
          then result := result + ',';
      end;
      result := result + ']';
    end;
    dtValue: begin
      // only text values should be enquoted
      if fValType <> vtText
        then result := fValue
        else result := '"' + fValue + '"';
    end;
  end;
end;

function JSONItem.getKey(index: integer): string;
var
  n: JSONItem;
begin
  result := '';
  n := getElem(index);
  if n <> nil
    then result := n.fKey;
end;

function JSONItem.getNum(default: double): double;
begin
  result := default;

  if self = nil
    then Exit;

  if fType <> dtValue
    then Exit;

  if fValue = 'true' then begin
    result := 1;
    Exit;
  end;
  if fValue = 'false' then begin
    result := 0;
    Exit;
  end;

  result := StrToFloatDef(fValue, default);
end;

function JSONItem.getStr(default: string): string;
begin
  result := default;

  if self = nil
    then Exit;

  if fType <> dtValue
    then Exit;
  result := fValue;
end;

function JSONItem.getType(default: JSONDataType): JSONDataType;
begin
  result := default;

  if self = nil
    then Exit;
    
  result := fType;
end;

function JSONItem.hasKey(key: string): boolean;
var
  i: integer;
begin
  key := LowerCase(key);
  result := true;
  for i := 0 to high(fChild) do
    if fChild[i].fKey = key
      then Exit;
  result := false;
end;

function JSONItem.isNull: boolean;
begin
  // or should it be true?
  result := false;

  if Self = nil
    then Exit;

  result := fValType = vtNull;
end;

procedure JSONItem.LoadFromFile(filename: string);
var
  f: Text;
  s, b: string;
begin
  clear_child;
  AssignFile(f, filename);
  Reset(f);
  while not EOF(f) do begin
    Readln(f, b);
    b := Trim(b);
    s := s + b;
  end;
  Code := s;
  CloseFile(f);
end;

procedure JSONItem.LoadFromStream(AStream: TStringStream);
var
  Size: Integer;
  S: string;
begin
   if (AStream = nil) then
      raise Exception.Create('Stream');

  clear_child;
  try
    AStream.Position := 0;
    Size := AStream.Size - AStream.Position;
    SetString(S, nil, Size);
    AStream.Read(Pointer(S)^, Size);
    Code := S;
  except
  raise Exception.Create('Stream read error.');
  end;
end;


function JSONItem.internal_parse(aCode: string): string;
var
  trail: char;
begin
  aCode := wsTrim(aCode);
  case aCode[1] of
    // generic value (text)
    '"': result := readValue(aCode);
    // number
    '0'..'9', '+', '-': result := readNumber(aCode);
    // boolean
    't', 'T', 'f', 'F': result := readBoolean(aCode);
    // null
    'n', 'N': result := readNull(aCode);
    // Object
    '{': result := readObject(aCode);
    // Array
    '[': result := readArray(aCode);
    // Shit =/
    else begin
      // Shouldda raise an exception here
      result := aCode;
    end;
  end;
end;

function JSONItem.readArray(aCode: string): string;
var
  n, idx: integer;
  val: JSONItem;
begin
  // we get here because first symbol was '['
  Delete(aCode, 1, 1);
  aCode := wsTrim(aCode);
  idx := 0;

  Self.setType(dtArray);
  // reading values until we reach a ']'
  while aCode[1] <> ']' do begin
    // Creating a new value
    val := Self.Value[idx];
    aCode := val.internal_parse(aCode); // "foo"\n,  ,  "bar"] -> \n,  ,  "bar"]
    aCode := wsTrim(aCode); // \n,  ,  "bar'] -> ,  ,  "bar"]
    while aCode[1] = ',' do begin
      aCode := wsTrim(
        Copy(
          aCode,
          2,
          Length(aCode)
        )
      ); // ,  ,  "bar"] -> ,  "bar"] -> "bar"]
      idx := idx + 1;
    end;
  end;

  result := Copy(aCode, 2, Length(aCode)); // ]... -> ...
end;

function JSONItem.readBoolean(aCode: string): string;
var
  sample: string;
begin
  sample := Copy(aCode, 1, 4);
  if LowerCase(sample) = 'true' then begin
    Self.setType(dtValue);
    Self.fValue := 'true';
    Self.fValType := vtBoolean;
    result := copy(aCode, 5, Length(aCode));
    exit;
  end;


  sample := Copy(aCode, 1, 5);
  if LowerCase(sample) = 'false' then begin
    Self.setType(dtValue);
    Self.fValue := 'false';
    Self.fValType := vtBoolean;
    result := copy(aCode, 6, Length(aCode));
    exit;
  end;
end;

function JSONItem.readNull(aCode: string): string;
var
  sample: string;
begin
  sample := Copy(aCode, 1, 4);
  if LowerCase(sample) = 'null' then begin
    Self.setType(dtValue);
    Self.fValue := 'null';
    Self.fValType := vtNull;
    result := copy(aCode, 5, Length(aCode));
    exit;
  end;
end;

function JSONItem.readNumber(aCode: string): string;
var
  n, l: integer;
begin
  l := Length(aCode);
  n := 1;
  // 1. sign (optional)
  if aCode[n] in SIGNS
    then n := n + 1;

  // 2. some digits
  while (aCode[n] in DIGITS) do
    n := n + 1;

  // 3. decimal dot (optional)
  if aCode[n] = '.'
    then n := n + 1;

  // 4. fractional digits (optional)
  while (aCode[n] in DIGITS) do
    n := n + 1;

  // TODO: Add E+/-1.23 part

  // result
  Self.setType(dtValue);
  Self.fValType := vtNumber;
  Self.fValue := Copy(aCode, 1, n - 1);

  result := Copy(aCode, n, l);
end;

function JSONItem.readObject(aCode: string): string;
var
  n: integer;
  val: JSONItem;
begin
  // just like an array, but we read pairs of key:value instead
  Delete(aCode, 1, 1);
  aCode := wsTrim(aCode);

  Self.setType(dtObject);

  // reading values until we reach a '}'
  while aCode[1] <> '}' do begin
    // Reading a key
    n := 1;
    while aCode[n] <> ':' do
      n := n + 1;

    // Creating a new value
    // keys are supposted to be quoted
    val := Self[Copy(aCode, 2, n - 3)]; // -quote -quote -colon
    aCode := Copy(aCode, n + 1, Length(aCode));

    // parsing value
    aCode := val.internal_parse(aCode);
    // trimming leftovers
    aCode := wsTrim(aCode);

    // skipping to the next pair
    while aCode[1] = ',' do begin
      aCode := wsTrim(
        Copy(
          aCode,
          2,
          Length(aCode)
        )
      ); // ,  ,  "bar"] -> ,  "bar"] -> "bar"]
    end;
  end;

  result := Copy(aCode, 2, Length(aCode)); // ]... -> ...
end;

function JSONItem.readValue(aCode: string): string;
var
  n: integer;
begin
  // we get here because our first symbol is '"'
  n := 2;

  while aCode[n] <> '"' do begin
    case aCode[n] of
      '\': begin
        // TODO: escapes and stuff
        n := n + 2;
      end;

      else
        n := n + 1;
    end;
  end;

  Self.setType(dtValue);
  Self.fValType := vtText;
  Self.fValue := Copy(aCode, 2, n - 2);

  result := Copy(aCode, n + 1, Length(aCode));
end;

procedure JSONItem.Remove(n: integer);
var
  i: integer;
begin
  if (n < 0) or (n > high(fChild)) or (length(fChild) < 1)
    then Exit;

  fChild[n].Free;
  for i := n to high(fChild) - 1 do
    fChild[i] := fChild[i + 1];

  setLength(fChild, high(fChild));
end;

procedure JSONItem.SaveToFile(filename: string);
var
  f: Text;
begin
  AssignFile(f, filename);
  Rewrite(f);
  Write(f, Code);
  CloseFile(f);
end;

procedure JSONItem.setBool(value: boolean);
begin
  if self = nil
    then Exit;

  setType(dtValue);
  Self.fValType := vtBoolean;
  //fValType := vtBoolean;
  if value
    then fValue := 'true'
    else fValue := 'false';
end;

procedure JSONItem.setCode(aCode: string);
begin
  Self.internal_parse(aCode); // =/
end;

procedure JSONItem.setInt(value: integer);
begin
  if self = nil
    then Exit;

  setType(dtValue);
  fValType := vtNumber;
  fValue := IntToStr(value);
end;

procedure JSONItem.setNull;
begin
  if self = nil
    then Exit;

  setType(dtValue);
  fValType := vtNull;
  fValue := 'null';
end;

procedure JSONItem.setNum(value: double);
begin             
  if self = nil
    then Exit;

  setType(dtValue);
  fValType := vtNumber;
  fValue := FloatToStr(value);
end;

procedure JSONItem.setStr(value: string);
begin      
  if self = nil
    then Exit;

  setType(dtValue);
  fValType := vtText;
  fValue := value;
end;

procedure JSONItem.setType(aType: JSONDataType);
var
  i: integer;
begin    
  if self = nil
    then Exit;
    
  if (aType = dtValue) and (fType <> dtValue) then begin
    clear_child;
    fValType := vtText;
  end;

  if (aType <> dtValue) and (fType = dtValue) then begin
    fValue := '';
  end;

  if (aType = dtObject) and (fType = dtArray) then begin
    for i := 0 to high(fChild) do
      fChild[i].fKey := IntToStr(i);
  end;

  if (aType = dtArray) and (fType = dtObject) then begin
    for i := 0 to high(fChild) do
      fChild[i].fKey := '';
  end;

  fType := aType;
end;

function JSONItem.StrToFloatDef(const S: string;
  const Default: Extended): Extended;
var
   bResult: Boolean;
begin
  bResult := TryStrToFloat(PChar(S), Result);
  if not bResult then
    Result := Default;
end;

function JSONItem.TryStrToFloat(const S: string;
  out Value: Extended): Boolean;
var
  LValue: Extended;
begin
  Result := TextToFloat(PChar(S), LValue, fvExtended);
  if Result then
    Value := LValue;
end;

end.
