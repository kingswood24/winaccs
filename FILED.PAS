{
	      ษอออออออออออออออออออออออออออออออออออออออออออออออออป
	      บ Kingswood Computing Ltd. - Unit DB_File		บ
	      ศอออออออออออออออออออออออออออออออออออออออออออออออออผ
                   
  File	    : U-DB:FILED.TEXT
  Unit	    : DB_FILE
  Prefix    :
  Status    : Finished

  DATE'S
  Started   : 16-04-92
  Finished  : 16-04-92

  This unit is for exiting from the P-System and Exiting to DOS
}

{$I-}
Unit Filed;


{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

PROCEDURE EXITDOS;
PROCEDURE EXITPROG (PASS: BOOLEAN);
PROCEDURE CRESET   (FL: INTEGER; PATH: STRING);
PROCEDURE CREWIND  (FL: INTEGER);
PROCEDURE CREWRITE (FL: INTEGER; PATH: STRING);
FUNCTION  CREAD	   (FL,BLKTOT,STARTBLK: INTEGER): INTEGER;
FUNCTION  CWRITE   (FL,BLKTOT,STARTBLK: INTEGER): INTEGER;
PROCEDURE CCLOSE   (FL: INTEGER; COPTION: CHAR);

{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation

Uses
  TYPES,
  VARS,
  CLEARS,
  AbortPrg;


{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

PROCEDURE EXITPROG;
VAR
  X : INTEGER;
BEGIN
  For X:=1 To MaxFiles Do CCLOSE(X,'N');
  IF NOT PASS THEN
      EXIT;
END;

PROCEDURE EXITDOS;
BEGIN
  EXITPROG  (TRUE);
  EXIT;
END;

PROCEDURE CRESET;
BEGIN
  ERRORNO:=0;
  AssignFile ( DBBASE[FL], PATH );
  ReSet ( DBBASE[FL], 512 );
  ErrorNo := IoResult;

  If errorno > 0 Then
    case errorno of
      128, 132 : errorno := 13;
      10, 130, 131 : errorno := 14;
      133, 134 : errorno := 15;
      else errorno := 999;
    end;
  IF ERRORNO = 0 THEN
    FLOPEN[FL]:=TRUE;
END;

PROCEDURE CREWIND;
BEGIN
  ERRORNO:=0;
  ReSet ( DBBASE[FL], 512 );
  errorno := ioresult;
  if errorno > 0 then
    case errorno of
      128, 132 : errorno := 13;
      10, 130, 131 : errorno := 14;
      133, 134 : errorno := 15;
      else errorno := 999;
    end;
  IF ERRORNO = 0 THEN
    FLOPEN[FL]:=TRUE;
END;

PROCEDURE CREWRITE;
BEGIN
     ERRORNO:=0;
     AssignFile ( DBBASE[FL], PATH);
     Rewrite ( DBBASE[FL], 512 );
     ERRORNO:= IORESULT;
     IF ERRORNO = 0 THEN FLOPEN[FL]:=TRUE;
END;

PROCEDURE CCLOSE;
VAR
  OPT : STRING;
BEGIN
  ERRORNO:=0;
  OPT:='';
  IF NOT FLOPEN[FL] THEN EXIT;
  CLOSEFILE(DBBASE[FL]);
  ERRORNO:=IORESULT;
  FLOPEN[FL]:=FALSE;
END;

FUNCTION  CREAD;
VAR
  BLK : INTEGER;
  SEEK_POINT : LONGINT;
BEGIN
  ERRORNO:=0;
  IF BLKTOT>DOS_BLK_MAX THEN AbortProgram('INTERNAL PROGRAM ERROR br');
  SEEK_POINT := STARTBLK;
  Seek (DBBASE[FL], SEEK_POINT);
  Blockread ( DBBASE[FL], CbLocks[1], blktot, BLK );
  IF BLK < BLKTOT THEN ERRORNO:= 99;
  ReSult := BLK;
END;

FUNCTION CWRITE;
VAR
  BLK : INTEGER;
  SEEK_POINT : Integer;
BEGIN
  ERRORNO:=0;
  IF BLKTOT>DOS_BLK_MAX THEN AbortProgram('INTERNAL PROGRAM ERROR bw');
  SEEK_POINT := STARTBLK;
  Seek (DBBASE[FL], SEEK_POINT);
  BlockWrite(DBBASE[FL], CbLocks[1], Blktot, BLK );
  IF BLK < BLKTOT THEN ERRORNO:= 99;
  ReSult:= BLK;
END;

Begin
{-----------------------------	INITIALIZATION	------------------------------}


{-------------------------------  TERMINATION  -------------------------------}


End.
