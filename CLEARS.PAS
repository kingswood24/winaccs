{
	      ษอออออออออออออออออออออออออออออออออออออออออออออออออป
	      บ Kingswood Computing Ltd. - Unit DB_CLEARS	บ
	      ศอออออออออออออออออออออออออออออออออออออออออออออออออผ
                                 
  File	    : U-DB:CLEARS.TEXT
  Unit	    : DB_CLEARS
  Prefix    :
  Status    : Finished
  Level	    : 3

  DATE'S
  Started   : 16-04-92
  Finished  : 16-04-92

  This unit contains the basic clear screen routines, string operations and
  some other general routines for setting the screen colours.  This unit is at
  access level 3 which means it depends on the units TYPES, VARS & DAIRY PARAMS
}

Unit Clears;


{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface

Uses
  TYPES;

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

PROCEDURE SLIMLEFT  (VAR STRVAL: ShortString);
PROCEDURE SLIMRIGHT (VAR STRVAL: ShortString);
PROCEDURE SLIMALL (VAR STRVAL: ShortString);
PROCEDURE UpCase (VAR ST : ShortString);
procedure strip_zero (var st : ShortString);	   { strip leading zeros }
PROCEDURE PADRIGHT (VAR STR: ShortString; LEN: INTEGER);
PROCEDURE PADLEFT  (VAR STR: ShortString; LEN: INTEGER);
PROCEDURE PADZERO  (VAR STR: ShortString; LEN: INTEGER);
Function UpCaseStr (ST : ShortString) : ShortString;




{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

procedure strip_zero;
{ this procedure is passed a string and its purpose is to remove all leading
  zeros from the string.
}
  begin
    slimright (st);
    slimleft (st);
    if	length (st) > 0 then
      while st[1] = '0' do
	begin
	  delete (st, 1, 1);
	  st := concat (st, ' ');
	end;
  end;

PROCEDURE SLIMLEFT;
VAR
  X : INTEGER;
BEGIN
  IF LENGTH(STRVAL)>0 THEN
    BEGIN
      X:=0;
      REPEAT
	X:=X+1;
      UNTIL (X=LENGTH(STRVAL)) OR (STRVAL[X]<>' ');
      STRVAL:=COPY (STRVAL,X,LENGTH(STRVAL)-X+1);
      IF STRVAL=' ' THEN STRVAL:='';
    END;
END;

PROCEDURE SLIMRIGHT;
VAR
  X : INTEGER;
BEGIN
  IF LENGTH(STRVAL)>0 THEN
    BEGIN
      X:=LENGTH(STRVAL)+1;
      REPEAT
	X:=X-1;
      UNTIL (X=1) OR (STRVAL[X]<>' ');
      STRVAL:=COPY (STRVAL,1,X);
      IF STRVAL=' ' THEN STRVAL:='';
    END;
END;

Procedure SlimAll;
Begin
     SlimLeft ( StrVal );
     SlimRight ( StrVal );
End;

procedure UpCase;
{ RC: convert string to upper case }
var
  i : integer;
begin
  SlimAll ( St );
  if st<>'' then
    for i := 1 to length(st) do
      if st[i] in ['a'..'z'] then
	      st[i] := chr(ord(st[i])-32);
end;

PROCEDURE PADRIGHT;
BEGIN
  WHILE LENGTH(STR)<LEN DO STR:=CONCAT (STR,' ');
END;

PROCEDURE PADLEFT;
BEGIN
  WHILE LENGTH(STR)<LEN DO STR:=CONCAT (' ',STR);
END;

PROCEDURE PADZERO;
BEGIN
  WHILE LENGTH(STR)<LEN DO STR:=CONCAT ('0',STR);
END;

Function UpCaseStr ( St : ShortString ) : ShortString;
{ convert string to upper case }
var
  i : integer;
begin
  UpCaseStr := '';
  if st<>'' then
    for i := 1 to length(st) do
      if st[i] in ['a'..'z'] then
	  st[i] := chr(ord(st[i])-32);
  UpCaseStr := St;
end;


Begin
{-----------------------------	INITIALIZATION	------------------------------}

{-------------------------------  TERMINATION  -------------------------------}

End.

