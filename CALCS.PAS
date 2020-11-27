{

  File	    : CALCS.TEXT
  Unit	    : CALCS
  Prefix    :
  Status    :
  Level	    :

  DATE'S
  Started   :
  Modified  :

  This unit does the calculations on string and numbers.
}

Unit Calcs;

{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface

Uses
    TYPES, StdCtrls, DbTables, AccsData;

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

procedure CheckDataBaseFields(tablename:TTable;STableName,Fieldname,FieldType:string;DefaultValue : string);
procedure KDateToStr{date_2_str} (date : integer; var st : ShortString);
procedure DDMMMYYYYtostr(var St : ShortString);
function  KStrToDate(St : ShortString) : TDateTime;
function is_digit (c : char) : boolean;
function digit_value (digit:char) : integer;
procedure del_non_chars (var st : string);
procedure ins_dec (place : integer; var str : string132);
PROCEDURE INTVAL (VAR NEWINT: SmallInt; FROMSTR: STRING132);
Procedure Intval2 (var newint : integer2; fromstr : string132);
FUNCTION  NUMERIC (TESTSTR: STRING): BOOLEAN;
FUNCTION  LEAPYEAR (YR: INTEGER): BOOLEAN;
FUNCTION  DATEVALID (DATETEST: ShortString; Template: ShortString): BOOLEAN;
PROCEDURE LONGSTR (LONGNO: BIGLONG; VAR ST: ShortSTRING; DT: CHAR);
PROCEDURE STRLONG (ST: ShortSTRING; VAR LONGNO: BIGLONG);
FUNCTION  ISITTABLE (XX: STRING80; CURRITEM : Integer; VAR INTN: SmallInt): BOOLEAN;
FUNCTION  ISITINT (ST: STRING132; VAR INT: SmallInt): BOOLEAN;
FUNCTION  ISITLONG (ST: STRING132; DATATYPE : Char; VAR LONGNO : LONG): BOOLEAN;
FUNCTION  CHECKNUM (LEN,DEC: INTEGER; VAR STR: ShortSTRING): BOOLEAN;
PROCEDURE DATEDIFF (DATE1,DATE2: ShortSTRING; VAR XDAYS: INTEGER; VAR WDAYS: ShortSTRING);
PROCEDURE DATEINC (DATE1: STRING132; INC: INTEGER; VAR NUM: INTEGER; VAR DATE2: STRING);
PROCEDURE DATEDEC (DATE1: STRING132; DEC: INTEGER; VAR NUM: INTEGER; VAR DATE2: STRING);
FUNCTION  CHKLNG (NUM,LO,HI: LONG   ): BOOLEAN;
FUNCTION  CHKINT (NUM,LO,HI: INTEGER): BOOLEAN;
PROCEDURE SMALLSTR (INT: INTEGER; VAR REALSTR: STRING132);
PROCEDURE TINYSTR  (INT: INTEGER; VAR REALSTR: STRING132);
PROCEDURE DIVLNG (TOP: BIGLONG; BOTTOM: LONG;	 VAR ANSWER: LONG);
PROCEDURE DIVINT (TOP: BIGLONG; BOTTOM: INTEGER; VAR ANSWER: LONG);
PROCEDURE SHORTSTR (LNG: LONG; VAR STR: STRING);
PROCEDURE DATEDISP (ITEMSUB: INTEGER; VAR DY,MN,YR: INTEGER);
Function  KDateToInt ( DateText : ShortString ) : Integer;
Procedure DoubleToStr ( DNum : Double; Var RetStr : ShortString; FormatStr : ShortString;
                        PadToLeft, DivBy100 : Boolean; PaddTo : Integer; ShowNeg : Boolean );
{ Gets the start and end date of financial year as integer }
Procedure GetFinDateRange ( Var FinDateFrom, FinDateTo : Integer );
{ OkBefore allows a date earlier than financial year start to go through }
Function CheckDateRange ( Var DateToCheck : ShortString; OkBefore : Boolean; Var IsBefore : Boolean; Showwarning : boolean ) : Boolean;
FUNCTION NumericWithMinus(TestStr:ShortString):Boolean;
function EuroConvert ( StrToChange : ShortString ) : String;        { Euro conversion Procedure}
function CheckNomEqualsZero (CodeToCheck : string) : Boolean;     // TGM AB 24/04/15

{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation

Uses
  dialogs,
  SysUtils,
  VARS,
  PARAMS,
  CLEARS,
  DbGen,
  Othform,
  UYearend,
  UYearEndTransWarning;

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

procedure CheckDataBaseFields(tablename:TTable;STableName,Fieldname,FieldType:string;DefaultValue : string);
begin
   TableName.Open;
   try
      try
         // Field Exists.
         Tablename.fieldbyname(Fieldname);
      except
         // Field Doesn't Exist.
         Tablename.Close;
         AccsDataModule.AddFieldsQuery.SQL.Clear;
         AccsDataModule.AddFieldsQuery.SQL.text:='ALTER TABLE ' + STablename + ' ADD ' + Fieldname + ' ' + FieldType;
         AccsDataModule.AddFieldsQuery.ExecSQL;
         AccsDataModule.AddFieldsQuery.SQL.Clear;
         if Length(DefaultValue) > 0 then
            begin
               AccsDataModule.AddFieldsQuery.SQL.Text:='UPDATE ' + STablename + ' SET ' + Fieldname + ' = ' + DefaultValue;
               AccsDataModule.AddFieldsQuery.ExecSQL;
               AccsDataModule.AddFieldsQuery.SQL.Clear;
            end;

         //   22/02/17 [V4.2 R6.4] /MK Change - Default UseLineReference to whatever UseLineDatet is set to.
         if ( (UpperCase(tablename.TableName) = 'INVOICELAYOUT.DB') and (UpperCase(FieldName) = 'USELINEREFERENCE') ) then
            begin
               if ( AccsDataModule.AddFieldsQuery.Active ) then
                  AccsDataModule.AddFieldsQuery.Close;
               AccsDataModule.AddFieldsQuery.SQL.Clear;
               AccsDataModule.AddFieldsQuery.SQL.Add('UPDATE '+STableName+'');
               AccsDataModule.AddFieldsQuery.SQL.Add('SET UseLineReference = False');
               AccsDataModule.AddFieldsQuery.ExecSQL;
               AccsDataModule.AddFieldsQuery.SQL.Clear;

               AccsDataModule.AddFieldsQuery.SQL.Add('UPDATE '+STableName+'');
               AccsDataModule.AddFieldsQuery.SQL.Add('SET UseLineReference = True');
               AccsDataModule.AddFieldsQuery.SQL.Add('WHERE UseLineDate = True');
               AccsDataModule.AddFieldsQuery.ExecSQL;
               AccsDataModule.AddFieldsQuery.SQL.Clear;
            end;

         AccsDataModule.AddFieldsQuery.Close;
      end;
   finally
      TableName.close;
   end;
end;

procedure KDateToStr{date_2_str}; { (date : integer; var st : string) }
{ convert date to string }
var
  day, month, year : integer;
  d, m, y : string;

  procedure break_num (var num, d, m, y : integer);
  { break date into year, month & day }
  var
    work, work2 : Double;{long;}
    begin
      work := num;
      work := work + 32000;
      work2 := work / 500;
      y := trunc (work2);
      work := trunc(work) - (trunc(work2) * 500);
      work2 := trunc(work) / 35;
      m := trunc (work2);
      work := work - (trunc(work2) * 35);
      d := trunc (work);
    end;

  procedure convert (n : integer; var st : string);
  { convert integer to 2 digit string }
  begin
    st := '00';
    st[2] := chr(ord('0') + n mod 10);
    st[1] := chr(ord('0') + (n div 10) mod 10);
  end;

begin
  if (date <= 0) then
    st := space8
  else
    begin
      break_num (date, day, month, year);
      convert (day, d);
      convert (month, m);
      convert (year, y);
      st := concat (d,'/',m,'/',y);
    end;
end;

procedure DDMMMYYYYtostr(var St : ShortString); // converts 01-JAN-2001 to 01/01/2001
var TempStr:string;
begin
     TempStr:=copy(St,4,3);
     if UpperCase(TempStr) = 'JAN' then TempStr :='01';
     if UpperCase(TempStr) = 'FEB' then TempStr :='02';
     if UpperCase(TempStr) = 'MAR' then TempStr :='03';
     if UpperCase(TempStr) = 'APR' then TempStr :='04';
     if UpperCase(TempStr) = 'MAY' then TempStr :='05';
     if UpperCase(TempStr) = 'JUN' then TempStr :='06';
     if UpperCase(TempStr) = 'JUL' then TempStr :='07';
     if UpperCase(TempStr) = 'AUG' then TempStr :='08';
     if UpperCase(TempStr) = 'SEP' then TempStr :='09';
     if UpperCase(TempStr) = 'OCT' then TempStr :='10';
     if UpperCase(TempStr) = 'NOV' then TempStr :='11';
     if UpperCase(TempStr) = 'DEC' then TempStr :='12';
     St:=copy(St,1,2) + '/' + TempStr + '/' + copy(St,8,4);

end;

function KStrToDate (St : ShortString) : TDateTime;
{ convert String to TDateTime }
var sDate, dStr, mStr, yStr : ShortString;
    yInt : Integer;
begin
    if DateValid (St,TDATEFORMAT) then
       begin
           dStr := Copy(St,1,2);
           SLIMALL(dStr);
           mStr := Copy(St,4,2);
           SLIMALL(mStr);
           yStr := Copy(St,7,2);
           SLIMALL(yStr);
           yInt := StrToInt(yStr);
           if yInt >= 64 then  // 1900 to 2000 date
              yStr := '19' + yStr
           else
              yStr := '20' + yStr;
           sDate := dStr + '/' + mStr + '/' + yStr;
           RESULT := StrToDate(sDate);
       end
    else
       RESULT := StrToDate(St);
end;

function is_digit;	{ (c : char) : boolean; }
{ true if c is a digit }
  begin
    is_digit := (c in ['0'..'9']);
  end;

function digit_value; { (digit:char) : integer }
{ Return integer value of digit character, '0'..'9' }
begin
  digit_value := ord(digit)-ord('0');
end;

procedure del_non_chars;    { (var st : string); }
{ This procedure will delete all characters that are not 0..9 and A..Z }
var
  i : integer;

  begin
    i := 1;
    if length (st) > 0 then
      while i <= length (st) do
	begin
	  if not (st[i] in ['0'..'9', 'A'..'Z']) then
	    delete (st, i, 1);
	  i := i + 1;
	end;
  end;

procedure ins_dec; { (place : integer; var str : string;) }
{ This procedure will delete the old decimal and insert a new one
  in place you want, if place = 2 then the string will look like so "SDFFF.SD" }
  begin
    if pos ('.',str) > 0 then
      delete (str,pos('.',str),1);		{ delete old decimal point }
    slimright (str);				{ cut off all trailing spaces }
    if place > 0 then
      insert ('.',str,length(str)-place+1);	 { insert new decimal point }
  end;

PROCEDURE INTVAL;
VAR
  Neg_Value : boolean;
  SUB	: INTEGER;
  DIGIT : longint;{INTEGER[5];}
  POWER : longint;{INTEGER[5];}
  WK	: longint;{INTEGER[5];}
BEGIN
  Neg_Value := false;
  SLIMLEFT  (FROMSTR);
  SLIMRIGHT (FROMSTR);
  POWER :=1;
  NEWINT:=0;
  WK	:=0;
  if length (fromstr) > 0 then	    { check for minus value }
    begin
      if fromstr[1] = '-' then
	begin
	  delete (fromstr, 1, 1);
	  Neg_Value := true;
	end
      else if fromstr[length(fromstr)] = '-' then
	begin
	  delete (fromstr, length (fromstr), 1);
	  Neg_Value := true;
	end;
    end;
  FOR SUB:=LENGTH(FROMSTR) DOWNTO 1 DO
    BEGIN
      DIGIT:=ORD(FROMSTR[SUB])-48;
      WK:=WK+(DIGIT*POWER);
      POWER:=POWER*10;
    END;
  IF WK>32000 THEN WK:=32000;
  NEWINT:=TRUNC (WK);
  if Neg_Value then
    NEWINT := -NEWINT;
END;

procedure intval2;
{ Convert string to integer2 - returns 0 if not valid }
var
  num : integer2;
  i : integer;
begin
  if not (numeric (fromstr) and (length (fromstr) <= 6)) then
      newint := 0
  else
    begin
      num := 0;
      for i := 1 to length (fromstr) do
	  num := num * 10 + digit_value (fromstr[i]);
      newint := num;
    end;
end;

FUNCTION NUMERIC;
VAR
  C	   : CHAR;
  SUB	   : INTEGER;
  FINISHED : BOOLEAN;
  OKSOFAR  : BOOLEAN;
BEGIN
  SUB:=0;
  IF TESTSTR=NULL THEN TESTSTR:=SPACE1;

  FINISHED:=FALSE;

  REPEAT
    SUB:=SUB+1;
    C:=TESTSTR[SUB];
    OKSOFAR:=(C IN ['0'..'9']);
    IF (NOT OKSOFAR) OR (SUB=LENGTH(TESTSTR)) THEN FINISHED:=TRUE;
  UNTIL FINISHED;
  NUMERIC:=OKSOFAR;
END;

FUNCTION LEAPYEAR;
BEGIN
  IF YR=0 THEN
    BEGIN
      LEAPYEAR:=TRUE;
      EXIT;
    END;
  IF ODD(YR) THEN
    BEGIN
      LEAPYEAR:=FALSE;
      EXIT;
    END;
  YR:=YR DIV 2;
  LEAPYEAR:=NOT(ODD(YR));
END;

FUNCTION  DATEVALID (DATETEST: ShortString; Template: ShortString): BOOLEAN;
VAR
  DAYSTR : STRING{[2]};
  MONSTR : STRING{[2]};
  YRSTR	 : STRING{[2]};
  DAY	 : SmallInt;
  MONTH	 : SmallInt;
  YEAR	 : SmallInt;
  W	 : LONG;
  DELSOK : BOOLEAN;
  X	 : SmallInt;
  C	 : CHAR;
  D	 : CHAR;
BEGIN
  DateValid := False;
  IF LENGTH(DATETEST) <> LENGTH( Template ) THEN
    DATETEST := Template ;
  DELSOK:=TRUE;
  DAYSTR:='01';
  MONSTR:='01';
  if length(template) = 10 then YRSTR :='0000' else YRSTR := '00';
  X:=0;
  DAYTOT:=0;
  REPEAT
    X:=X+1;
    C:=Template [X];
    D:=DATETEST[X];
    IF C='D' THEN
      BEGIN
	        DAYSTR:=COPY(DATETEST,X,2);
	        X:=X+1;
      END
    ELSE
      IF C='M' THEN
	      BEGIN
	           MONSTR:=COPY(DATETEST,X,2);
	           X:=X+1;
         END
      ELSE
          IF C='Y' THEN
	          BEGIN
                       if length(TemPlate) = 10 then YRSTR := copy(DateTest,X,4)
	               else YRSTR:=COPY(DATETEST,X,2);
	               X:=X+1;
             END
          ELSE
              IF C<>D THEN DELSOK:=FALSE;
  UNTIL X>LENGTH(Template)-2;
  IF NUMERIC(DAYSTR) THEN INTVAL(DAY,DAYSTR) ELSE DAY:=-1;
  IF DAY>0 THEN DAYTOT:=DAY;
  IF NUMERIC(MONSTR) THEN INTVAL(MONTH,MONSTR) ELSE MONTH:=-1;
  IF MONTH>0 THEN
    BEGIN
      W:=MONTH;
      DAYTOT:=DAYTOT+(W*35);
    END;
  IF NUMERIC(YRSTR) THEN INTVAL(YEAR,YRSTR) ELSE YEAR:=-1;
  If Year >= 0 Then { >= Allows Year 2000 '00' }
     Begin
          { Year 2000 Problem }
          If Year >= 64 Then
             W := Year { Old Code }
          Else
              W := Year + 100;
          DAYTOT:=DAYTOT+(W*500);
     End;
  {
  IF YEAR>0 THEN
    BEGIN
      W:=YEAR;
      DAYTOT:=DAYTOT+(W*500);
    END;
  }
  { Caused a range error if invalid date }
  If (( Month > 0 ) And ( Day > 0 )) Then
     IF (MONTH IN [4,6,9,11]) AND (DAY>30) THEN DAY:=33;
  IF MONTH=2 THEN
    BEGIN
      IF LEAPYEAR(YEAR) THEN
	      BEGIN
	           IF DAY>29 THEN DAY:=33;
         END
      ELSE
	       BEGIN
	            IF DAY>28 THEN DAY:=33;
          END;
    END;
  { Caused error if any were less than 0 }
  If (( Day > 0 ) And ( Month > 0 ) And ( Year >= 0 )) Then
     DATEVALID:=(DAY   IN [1..31]) AND
	       (MONTH IN [1..12]) AND
	       (YEAR  IN [0..200]) AND DELSOK;  { Used to be 99 }
END;

PROCEDURE LONGSTR;
VAR
  MIN : INTEGER;
BEGIN
  IF DT='M' THEN MIN:=5 ELSE MIN:=3;
  STR(LONGNO,ST);
  IF ST[1]	   ='-' THEN ST:=COPY(ST,2,LENGTH(ST)-1);
  IF ST[LENGTH(ST)]='-' THEN ST:=COPY(ST,1,LENGTH(ST)-1);
  WHILE LENGTH(ST)<MIN DO ST:=CONCAT(ZERO,ST);
  ST:=CONCAT (COPY(ST,1,LENGTH(ST)-(MIN-1)),'.',
	      COPY(ST,LENGTH(ST)-MIN+2,MIN-1),SPACE1);
  IF LONGNO<0 THEN ST[LENGTH(ST)]:='-';
  IF LENGTH(ST)>12 THEN ST:='************';
  {
  WHILE LENGTH(ST)<12 DO ST:=CONCAT(ST,SPACE1);
  }
END;

PROCEDURE STRLONG;
VAR
  SVAL	: LONG;
  POWER : LONG;
  SUB	: INTEGER;
BEGIN
  LONGNO:=0;
  POWER :=1;
  SlimAll ( st );
  IF LENGTH (ST) > 0 THEN
    BEGIN
      FOR SUB:=LENGTH(ST) DOWNTO 1 DO
      IF ST[SUB] IN ['0'..'9'] THEN
	BEGIN
	  SVAL:=ORD(ST[SUB])-48;
	  SVAL:=SVAL*POWER;
	  LONGNO:=LONGNO+SVAL;
	  POWER:=POWER*10;
	END;
      IF ST[LENGTH(ST)]='-' THEN
	LONGNO:= -LONGNO;
    END;
END;

FUNCTION ISITTABLE;
VAR
  TF : INTEGER;
  TT : INTEGER;
BEGIN
  IF NOT ISITINT(XX,INTN) THEN
    BEGIN
      ISITTABLE:=FALSE;
      EXIT ;
    END;
  IF INTN=0 THEN
    BEGIN
      ISITTABLE:=FALSE;
      EXIT ;
    END;
  MOVE{LEFT} (DB1.DBITEMS[CURRITEM].DBICALC[1],TF,2);
  MOVE{LEFT} (DB1.DBITEMS[CURRITEM].DBICALC[3],TT,2);
  IF (INTN>DB1.DBTABTOT) OR (INTN<TF) OR (INTN>TT) THEN
    BEGIN
      ISITTABLE:=FALSE;
      EXIT;
    END;
  ISITTABLE:=TRUE;
END;

FUNCTION ISITINT;

BEGIN
  SLIMLEFT  (ST);
  SLIMRIGHT (ST);
  IF (ST=NULL) OR NOT(NUMERIC(ST)) THEN
    BEGIN
      ISITINT:=FALSE;
      EXIT;
    END;
  INTVAL (INT,ST);
  ISITINT:=TRUE;
END;

FUNCTION  ISITLONG;
VAR
  PT	: INTEGER;
  X	: INTEGER;
  VALST : STRING;
BEGIN
  LONGNO:=0;
  VALST:='00000000.0000+';
  SLIMLEFT(ST); SLIMRIGHT(ST);
  IF (ST='') OR NOT(DATATYPE IN ['K','L','M','k','l','m'])  THEN
    BEGIN
      ISITLONG:=FALSE;
      EXIT;
    END;
  IF (ST[1]='-') AND (LENGTH(ST)>1) THEN
    BEGIN
      VALST[14]:='-';
      ST:=COPY(ST,2,LENGTH(ST)-1);
    END;
  IF (ST[LENGTH(ST)]='-') AND (LENGTH(ST)>1) THEN
    BEGIN
      VALST[14]:='-';
      ST:=COPY(ST,1,LENGTH(ST)-1);
    END;
  PT:=POS('.',ST);
  IF (PT>9)
  OR ( (PT>0) AND (LENGTH(ST)-PT>5) )
  OR ( (PT=0) AND (LENGTH(ST)>8) ) THEN
    BEGIN
      ISITLONG:=FALSE;
      EXIT;
    END;
  IF PT=0 THEN
    MOVE(ST[1],VALST[9-LENGTH(ST)],LENGTH(ST));
  IF PT>1 THEN
    MOVE(ST[1],VALST[9-PT+1],PT-1);
  IF (PT>0) AND (PT<LENGTH(ST)) THEN
    MOVE(ST[PT+1],VALST[10],LENGTH(ST)-PT);
  IF DATATYPE IN ['K','L','k','l'] THEN
    BEGIN
      IF (VALST[12]<>'0') OR (VALST[13]<>'0') THEN
	BEGIN
	  ISITLONG:=FALSE;
	  EXIT;
	END;
      ST:=CONCAT(COPY(VALST,1,11),COPY(VALST,14,1));
      FOR X:=1 TO 8 DO
	IF NOT(ST[X] IN ['0'..'9']) THEN
	  BEGIN
	    ISITLONG:=FALSE;
	    EXIT;
	  END;
      IF (ST[9]<>'.') OR NOT(ST[10] IN ['0'..'9'])
	OR NOT(ST[11] IN ['0'..'9']) OR NOT(ST[12] IN ['+','-']) THEN
	  BEGIN
	    ISITLONG:=FALSE;
	    EXIT;
	  END;
    END;
  IF (DATATYPE='M') OR (DATATYPE='m') THEN
    BEGIN
      IF (VALST[1]<>'0') OR (VALST[2]<>'0') THEN
	BEGIN
	  ISITLONG:=FALSE;
	  EXIT;
	END;
      ST:=COPY(VALST,3,12);
      FOR X:=1 TO 11 DO
	IF X<>7 THEN
	  IF NOT(ST[X] IN ['0'..'9']) THEN
	    BEGIN
	      ISITLONG:=FALSE;
	      EXIT;
	    END;
      IF (ST[7]<>'.') OR NOT(ST[12] IN ['+','-']) THEN
	BEGIN
	  ISITLONG:=FALSE;
	  EXIT;
	END;
    END;
  X:=0;
  REPEAT
    X:=X+1;
    IF ST[X]='0' THEN ST[X]:=' ';
  UNTIL (ST[X]<>' ')
    OR ((X=7) AND (DATATYPE IN ['K','L']))
    OR ((X=5) AND (DATATYPE IN ['M'    ]));
  ISITLONG:=TRUE;
  STRLONG(ST,LONGNO);
END;

PROCEDURE DATEDISP;
VAR
  X    : INTEGER;
  Y    : INTEGER;
  XVAL : LONG;
  YVAL : LONG;
  ST   : STRING{[2]};
BEGIN
  XVAL:=CURRINT;
  XVAL:=XVAL+32000;
  YVAL:=XVAL DIV 500;
  YR  :=TRUNC(YVAL);
  XVAL:=XVAL-(YVAL*500);
  YVAL:=XVAL DIV 35;
  MN  :=TRUNC(YVAL);
  XVAL:=XVAL-(YVAL*35);
  DY  :=TRUNC(XVAL);
  FILLCHAR (CURRDISP[1],8,ZERO);
  CURRDISP[3]:='/';
  CURRDISP[6]:='/';

  { Year 2000 compliant }
  If ( YR >= 100 ) Then
     Str ( YR - 100, ST )
  Else
      Str (YR,ST);
  IF LENGTH(ST)=1 THEN ST:=CONCAT(ZERO,ST);
  FOR X:=1 TO LENGTH(ST) DO CURRDISP[6+X]:=ST[X];
  STR (MN,ST);
  IF LENGTH(ST)=1 THEN ST:=CONCAT(ZERO,ST);
  IF (ITEMSUB=0)
    THEN Y:=3
    ELSE
  IF DB1.DBITEMS[ITEMSUB].DBITYPE[0]='D'
    THEN Y:=3
    ELSE Y:=0;
  FOR X:=1 TO LENGTH(ST) DO CURRDISP[Y+X]:=ST[X];
  STR (DY,ST);
  IF LENGTH(ST)=1 THEN ST:=CONCAT(ZERO,ST);
  IF Y=3
    THEN Y:=0
    ELSE Y:=3;
  FOR X:=1 TO LENGTH(ST) DO CURRDISP[Y+X]:=ST[X];
END;


FUNCTION CHECKNUM;
VAR
  SUFFIX : STRING{[6]};
BEGIN
  CHECKNUM:=FALSE;
  CASE DEC OF
    1 : SUFFIX:='.0+';
    2 : SUFFIX:='.00+';
    4 : SUFFIX:='.0000+';
  END;
  IF NUMERIC(STR) AND (LENGTH(STR)<LEN-DEC-1) THEN 
    STR:=CONCAT (STR,SUFFIX);
  IF NOT (STR [LENGTH(STR)] IN ['+','-']) AND (LENGTH(STR)<LEN) THEN
    STR:=CONCAT (STR,'+');
  WHILE (POS('.',STR)+DEC+1 > POS('+',STR)+POS('-',STR)) 
    AND (LENGTH(STR)<LEN) DO
    STR:=CONCAT (COPY(STR,1,LENGTH(STR)-1),ZERO,COPY(STR,LENGTH(STR),1));
  PADZERO (STR,LEN);
  IF (STR[LEN-DEC-1]='.') THEN
    IF (STR[LEN] IN ['+','-']) THEN
      IF (NUMERIC (COPY(STR,1,LEN-DEC-2))) THEN
	IF (NUMERIC (COPY(STR,LEN-DEC,DEC))) THEN CHECKNUM:=TRUE;
END;

PROCEDURE DATEDIFF;
VAR
  DD1,MM1,YY1 : SmallInt;
  DD2,MM2,YY2 : SmallInt;
  THISMONTH   : SmallInt;
  MONTHNO     : SmallInt;
BEGIN
  SLIMLEFT (DATE1);
  SLIMLEFT (DATE2);
  IF (DATE1=NULL) OR (DATE2=NULL) THEN
    BEGIN
      XDAYS:=0;
      WDAYS:=SPACE4;
    END
  ELSE
    BEGIN
      INTVAL (DD1, COPY(DATE1,1,2));
      INTVAL (DD2, COPY(DATE2,1,2));
      INTVAL (MM1, COPY(DATE1,4,2));
      INTVAL (MM2, COPY(DATE2,4,2));
      INTVAL (YY1, COPY(DATE1,7,2));
      INTVAL (YY2, COPY(DATE2,7,2));
      IF  (YY1>YY2)
      OR ((YY1=YY2) AND (MM1>MM2)) 
      OR ((YY1=YY2) AND (MM1=MM2) AND (DD1>DD2)) THEN
	BEGIN
	  XDAYS:=0;
	  WDAYS:=SPACE4;
	END
      ELSE
	BEGIN
	  IF YY2>YY1 THEN MM2:=MM2+((YY2-YY1)*12);
	  IF (MM1=MM2) THEN 
	    XDAYS:=DD2-DD1
	  ELSE
	    BEGIN
	      XDAYS:=DAYS[MM1]-DD1+DD2;
	      IF MM2>MM1+1 THEN
		FOR THISMONTH:=MM1+1 TO MM2-1 DO
		  BEGIN
		    MONTHNO:=THISMONTH;
		    WHILE MONTHNO>12 DO MONTHNO:=MONTHNO-12;
		    IF XDAYS<=9999-DAYS[MONTHNO] THEN
		      XDAYS:=XDAYS+DAYS[MONTHNO];
		  END;
	    END;
	END;
      IF XDAYS<=9999 THEN STR (XDAYS,WDAYS);
      PADRIGHT (WDAYS,4);
    END;
END;

PROCEDURE DATEINC;
VAR
  DD1,MM1,YY1 : SmallInt;
  DD2,MM2,YY2 : SmallInt;
  WD2,WM2,WY2 : STRING132;
BEGIN
  SLIMLEFT (DATE1);
  IF (DATE1=NULL) OR (INC=0) THEN
    DATE2:=SPACE8
  ELSE
    BEGIN
      INTVAL (DD1, COPY(DATE1,1,2));
      INTVAL (MM1, COPY(DATE1,4,2));
      INTVAL (YY1, COPY(DATE1,7,2));
      DD2:=DD1+INC;
      MM2:=MM1;
      YY2:=YY1;
      WHILE DD2>DAYS[MM2] DO
	BEGIN
	  DD2:=DD2-DAYS[MM2];
	  MM2:=MM2+1;
	  IF MM2>12 THEN
	    BEGIN
	      MM2:=MM2-12;
	      YY2:=YY2+1;
	    END;
	END;
      STR (DD2,WD2); PADZERO (WD2,2);
      STR (MM2,WM2); PADZERO (WM2,2);
      STR (YY2,WY2); PADZERO (WY2,2);
      DATE2:=CONCAT(WD2,COPY(TDATEFORMAT,3,1),WM2,COPY(TDATEFORMAT,6,1),WY2);
      IF DATEVALID (DATE2,TDATEFORMAT) THEN
	BEGIN
	  DAYTOT:=DAYTOT-32000;
	  NUM:=TRUNC(DAYTOT);
	END;
    END;
END;

PROCEDURE DATEDEC;
VAR
  DD1,MM1,YY1 : SmallInt;
  DD2,MM2,YY2 : SmallInt;
  WD2,WM2,WY2 : STRING132;
BEGIN
  SLIMLEFT (DATE1);
  IF (DATE1=NULL) OR (DEC=0) THEN
    DATE2:=SPACE8
  ELSE
    BEGIN
      INTVAL (DD1, COPY(DATE1,1,2));
      INTVAL (MM1, COPY(DATE1,4,2));
      INTVAL (YY1, COPY(DATE1,7,2));
      DD2:=DD1-DEC;
      MM2:=MM1;
      YY2:=YY1;
      WHILE DD2<1 DO
	BEGIN
	  MM2:=MM2-1;
	  IF MM2<1 THEN
	    BEGIN
	      MM2:=MM2+12;
	      YY2:=YY2-1;
	    END;
	  DD2:=DD2+DAYS[MM2];
	END;
      STR (DD2,WD2); PADZERO (WD2,2);
      STR (MM2,WM2); PADZERO (WM2,2);
      STR (YY2,WY2); PADZERO (WY2,2);
      DATE2:=CONCAT(WD2,COPY(TDATEFORMAT,3,1),WM2,COPY(TDATEFORMAT,6,1),WY2);
      IF DATEVALID (DATE2,TDATEFORMAT) THEN
	BEGIN
	  DAYTOT:=DAYTOT-32000;
	  NUM:=TRUNC(DAYTOT);
	END;
    END;
END;

FUNCTION CHKLNG;
BEGIN
  IF (NUM<LO) OR (NUM>HI) THEN
    CHKLNG:=FALSE
  ELSE
    CHKLNG:=TRUE;
END;

FUNCTION CHKINT;
BEGIN
  IF (NUM<LO) OR (NUM>HI) THEN
     CHKINT:=FALSE
  ELSE
    CHKINT:=TRUE;
END;

PROCEDURE DIVLNG;

BEGIN
  ANSWER:=0;
  IF (TOP<>0) AND (BOTTOM<>0) THEN
    BEGIN
{      IF TOP*BOTTOM>0 THEN FACTOR:=50 ELSE FACTOR:=-50;
      ANSWER:=((((TOP * 10000) DIV BOTTOM) + FACTOR) DIV 100);
      }
    END;
END;

PROCEDURE DIVINT;

BEGIN
  ANSWER:=0;
  IF (TOP<>0) AND (BOTTOM<>0) THEN
    BEGIN
{      IF TOP*BOTTOM>0 THEN FACTOR:=50 ELSE FACTOR:=-50;
      ANSWER:=((((TOP * 100) DIV BOTTOM) + FACTOR) DIV 100);
      }
    END;
END;

PROCEDURE SMALLSTR;
VAR
  NEGATIVE : BOOLEAN;
BEGIN
  NEGATIVE:=FALSE;
  STR (INT,REALSTR);
  IF REALSTR[1]='-' THEN
    BEGIN
      NEGATIVE:=TRUE;
      DELETE (REALSTR,1,1);
    END;
  PADZERO (REALSTR,3);
  INSERT ('.',REALSTR,LENGTH(REALSTR)-1);
  IF NEGATIVE THEN 
    IF LENGTH(REALSTR)<6 THEN 
      REALSTR:=CONCAT (REALSTR,'-')
    ELSE
      REALSTR:='******';
  PADRIGHT (REALSTR,6);
END;

PROCEDURE TINYSTR;
BEGIN
  STR (INT,REALSTR);
  PADZERO (REALSTR,2);
  INSERT ('.',REALSTR,LENGTH(REALSTR));
  PADRIGHT (REALSTR,5);
END;

PROCEDURE SHORTSTR;
VAR
  WORK : ShortSTRING;
BEGIN
    WORK:=SPACE12;
    LONGSTR (LNG,WORK,'L');
    STR:=COPY (WORK,1,8);
END;

function KDateToInt ( DateText : ShortString ) : Integer;
begin
    DateValid ( DateText, TDateFormat );
    DayTot := DayTot-32000;
    RESULT := Trunc ( DayTot );
end;

Procedure DoubleToStr ( DNum : Double; Var RetStr : ShortString; FormatStr : ShortString;
                        PadToLeft, DivBy100 : Boolean; PaddTo : Integer; ShowNeg : Boolean );
Begin
     { Take away negitive sign }
     If ( DNum < 0 ) and not ShowNeg Then
        DNum := 0-DNum;
     If DivBy100 Then
        RetStr := Format ( FormatStr, [dNum/100] )
     Else
          RetStr := Format ( FormatStr, [dNum] );

     If PadToLeft Then
          PadLeft ( RetStr, PaddTo );
End;

Procedure GetFinDateRange ( Var FinDateFrom, FinDateTo : Integer );
Var
   FinancialStart,
   FinancialEnd,
   Day,
   MonthStart,
   MonthEnd,
   YearEnd,
   YearStart    : ShortString;
Begin
     FinDateFrom    := 0;
     FinDateTo      := 0;
     FinancialStart := '';
     FinancialEnd   := '';
     MonthStart     := '';
     MonthEnd       := '';
     YearStart      := '';
     YearEnd        := '';
     Day            := '';

     Str ( 31, Day );
     Str ( Cash1.xFinMonth, MonthStart );
     If Length ( MonthStart ) < 2 then
       Insert ( '0', MonthStart, 1 );
     Str ( Cash1.xFinYear, YearStart );
     { remove 19 from the financial year }
     Delete ( YearStart, 1, 2 );

     If ( Cash1.xfinmonth > 1 ) Then
       Begin
         Str ( Cash1.xfinmonth-1, MonthEnd );
         { Set to Last day of Month }
         Str ( Cash1.xfinyear+1, YearEnd );
         Case Cash1.xfinmonth-1 Of
           3,
           5,
           7,
           8,
           10,
           12 : str ( 31, day );
           4,
           6,
           9,
           11 : str ( 30, day );
           2  : Begin
                    If ( (Cash1.xfinyear+1) mod 4 = 0 ) Then
                       str ( 29, day )
                    Else
                       str ( 28, day );
                      End;
         End;
       End
     Else
       { January year start }
       Begin
         Str ( 31, Day );
         MonthEnd := '12';
         { current financial year }
         Str ( Cash1.xfinyear, YearEnd );
       End;

     If Length ( MonthEnd ) < 2 then
       Insert ( '0', MonthEnd, 1 );
     { remove 19 from the financial year }
     Delete ( YearEnd, 1, 2 );

     { build the date of financial year end }
     FinancialEnd := '';
     FinancialStart := '';
     //FillChar ( FinancialEnd[1], 8, ' ' );
     //FillChar ( FinancialStart[1], 8, ' ' );

     Insert ( concat ( day, '/' ), FinancialEnd, 1 );
     Insert ( concat ( MonthEnd,'/' ), FinancialEnd, 4 );
     Insert ( YearEnd, FinancialEnd, 7 );

     Insert ( '01/', FinancialStart, 1 );
     Insert ( Concat ( MonthStart,'/' ), FinancialStart, 4 );
     Insert ( YearStart, FinancialStart, 7 );

     { Convert Dates to Integer }
     FinDateFrom := KDateToInt ( FinancialStart );
     FinDateTo   := KDateToInt ( FinancialEnd );

End;

Function CheckDateRange ( Var DateToCheck : ShortString; OkBefore : Boolean; Var IsBefore : Boolean; Showwarning : boolean ) : Boolean;
Var
   FinancialStart,
   FinancialEnd   : ShortString;
   FinStart,
   FinEnd,
   DateCheck    : Integer;
Begin
     IsBefore       := False;
     FinancialStart := '';
     FinancialEnd   := '';

     DateCheck := KDateToInt ( DateToCheck );

     GetFinDateRange ( FinStart, FinEnd );

     { build the date of financial year end }
     FinancialEnd := '';
     FinancialStart := '';

     KDateToStr ( FinStart, FinancialStart );
     KDateToStr ( FinEnd,   FinancialEnd );

     if ( (DateCheck >= FinStart) and (DateCheck <= FinEnd) ) or
        ( (OkBefore) and (DateCheck <= FinEnd) ) then
         begin
              CheckDateRange := True;
              IsBefore := ( DateCheck < FinStart );
         end
     else
        begin
           if ( showwarning ) then
              begin
                 if ( TFYearEndTransWarning.ShowTheForm(FinancialStart, FinancialEnd) ) then
                   begin
                      GEditing := False;
                      YearEndForm :=  TYearEndForm.Create(nil);
                      try
                         YearEndForm.ShowModal;
                      finally
                        FreeAndNil(YearEndForm);
                      end;
                   end;
               end;
           DateToCheck := Cash1.xDate;
           CheckDateRange := False;
           IsBefore := True;
        end;
End;

FUNCTION NumericWithMinus(TestStr:ShortString):Boolean;
VAR
C	   : CHAR;
SUB	   : INTEGER;
FINISHED : BOOLEAN;
OKSOFAR  : BOOLEAN;
BEGIN
     SUB:=0;
     IF TESTSTR=NULL THEN TESTSTR:=SPACE1;

     FINISHED:=FALSE;
     If (TestStr = '-') Or (Teststr = '.') Then
        Begin
             MessageDlg('Invalid Data Entry.', mtInformation,
                    [mbOk], 0);
             Exit;
        End;

     REPEAT
     SUB:=SUB+1;
     C:=TESTSTR[SUB];
     OKSOFAR:=((C IN ['0'..'9']) or (C IN ['-']) or (C IN ['.']));
     IF (NOT OKSOFAR) OR (SUB=LENGTH(TESTSTR)) THEN FINISHED:=TRUE;
     UNTIL FINISHED;
     NumericWithMinus:=OKSOFAR;
END;

function EuroConvert ( StrToChange : ShortString ) : String;        { Euro conversion Procedure}
var EuroValue,
    Teststr   : Shortstring;
    EuroFloat : Double;
    EuroTotal : Double;
    TempLong  : Longint;
Begin
     TestStr := '';
     EuroValue := '';
     EuroFloat := 0;
     EuroTotal := 0;
     TempLong := 0;

     TestStr := StrToChange;
     SlimAll ( TestStr );
     // Check its a valid number if not then DO NOTHING
     If ChangeToLong ( TestStr ) Then
        begin
           StrLong ( TestStr, TempLong );

           If NOT Cash11.xSaveAsEuro Then   // To Euro Currency
             Begin
                Try
                   If ( Cash11.xEuroConverter > 0 ) Then
                      begin
                         EuroFloat := TempLong / 100;
                         EuroTotal := (EuroFloat*Cash11.xEuroConverter);
                         DoubleToStr ( EuroTotal, EuroValue, '%1.2f', False, False, 0, True );
                         Result := EuroValue;
                      end
                   else
                      begin
                         MessageDlg('No Conversion Factor Set - Go to System on Main Form', mtInformation,[mbOk], 0);
                         Result := StrToChange;
                      end;
                Except
                   MessageDlg('Could not Calculate.', mtInformation,[mbOk], 0);
                End;
             End
           Else                                 //To Punt Currency
             Begin
                Try
                   If ( Cash11.xEuroConverter > 0 ) Then
                      begin
                         EuroFloat := TempLong / 100;
                         EuroTotal := (EuroFloat/Cash11.xEuroConverter);
                         DoubleToStr ( EuroTotal, EuroValue, '%1.2f', False, False, 0, True );
                         Result := EuroValue;
                      end
                   else
                      begin
                         MessageDlg('No Conversion Factor Set - Go to System on Main Form', mtInformation,[mbOk], 0);
                         Result := StrToChange;
                      end;
                Except
                   MessageDlg('Could not Calculate.', mtInformation,[mbOk], 0);
                End;
             End;
        end;
End;                                                 // End of Euro Calc

function CheckNomEqualsZero (CodeToCheck : string) : Boolean;   // TGM AB 24/04/15 start
var
        TestInt : integer;
begin
    Result := false;
    TestInt := -1;
    if length(CodeToCheck) > 0 then begin
        Try TestInt := strtoint(CodeToCheck);
            if TestInt = 0 then result := true;
        except result := true;
        end;
    end;

end;   
Begin
{-----------------------------	INITIALIZATION	------------------------------}


{-------------------------------  TERMINATION  -------------------------------}

End.

