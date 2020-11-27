{
  File	    : U-DB:DBCHAIN.TEXT
  Unit	    : DB_CHAIN
  Prefix    :
  Status    : Finished    

  DATE'S
  Started   : 21-04-92
  Finished  : 21-04-92

  This unit contains the procedure chainprog & some other general procedures
  and functions
}

Unit DefSecFl;


{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface


Uses
  {ChkComp,}
  types;

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

PROCEDURE DEFOPEN  (COMPANY: STRING; ASKLOC: BOOLEAN);

PROCEDURE DEFREAD  (DEFBLOCK: INTEGER);
PROCEDURE DEFWRITE (DEFBLOCK: INTEGER);
PROCEDURE SECREAD;
PROCEDURE SECWRITE;
Procedure JnlRead ( Jnl : Integer; Var SUB : Integer );
Procedure JnlWrite ( Jnl : Integer );

{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation

Uses
  MainUnit,
  SysUtils,
  VARS,
  PARAMS,
  ABORTPRG,
  CALCS,
  FILED,
  CLEARS,
  Dialogs;
{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}


PROCEDURE DEFOPEN;
VAR
  ERR : INTEGER;
BEGIN
  REPEAT
    DEFID :=CASHBOOK;
    SORTID :=SORTWORK;
    MISCID :=MISCWORK;
    DEFID := SubDir + RFarmGate.PLOCATION[2] + '\' + DEFID;
    SORTID := SubDir + RFarmGate.PLOCATION[2] + '\' + SORTID;
    MISCID := SubDir + RFarmGate.PLOCATION[2] + '\' + MISCID;
    CCLOSE (CashFile, 'N');
    CRESET (CashFile, DEFID);
    ERR:=ERRORNO;

    IF (ERR>0) AND (ASKLOC) THEN
      BEGIN
	{
        CLEARSCREEN;
	DIS ( 1,24,'SPECIFY PATHNAME FOR LOCATION OF CASHBOOK DEFINITION: ');
        ChkComp.FCheckName.Show;
        REC (52,24,7,PLOCATION[4],0);
	IF ESCKEY THEN AbortProgram (DEFERR);
        }

        {
        ChkComp.FCheckName.Hide;
        ChkComp.FCheckName.ShowModal;
        If ChkComp.FCheckName.Visible Then
           ChkComp.FCheckName.CheckcompanyName.SetFocus;
        }
{        PLOCATION[2] := ChkComp.FCheckName.CheckCompanyName.Text;}
	SECWRITE;

      END;
  UNTIL (ERR=0) OR (NOT ASKLOC){ Or ( NOT ChkComp.FCheckName.Visible )};
End;

Procedure DEFREAD;
Begin
  If CREAD (CashFile,1,DEFBLOCK) < 1 Then
    AbortProgram (DEFERR)
  Else
    Case DEFBLOCK Of
      0 : MOVE (CBLOCKS[1],Cash1.DBLOCK0[1],512);
      1 : MOVE (CBLOCKS[1],Cash2.DBLOCK1[1],512);
{
      2 : MOVE (CBLOCKS[1],DBLOCK2[1],512);
      3 : MOVE (CBLOCKS[1],DBLOCK3[1],512);
      4 : MOVE (CBLOCKS[1],DBLOCK4[1],512);
      5 : MOVE (CBLOCKS[1],DBLOCK5[1],512);
      6 : MOVE (CBLOCKS[1],DBLOCK6[1],512);
      7 : MOVE (CBLOCKS[1],DBLOCK7[1],512);
      8 : MOVE (CBLOCKS[1],DBLOCK8[1],512);
}
      11 : MOVE (CBLOCKS[1],Cash11.DB_LOC_PROGS[1],512);
    End;
End;

PROCEDURE DEFWRITE;
BEGIN
  CASE DEFBLOCK OF
    0 : MOVE (Cash1.DBLOCK0[1],CBLOCKS[1],512);
    1 : MOVE (Cash2.DBLOCK1[1],CBLOCKS[1],512);
{
    2 : MOVE (DBLOCK2[1],CBLOCKS[1],512);
    3 : MOVE (DBLOCK3[1],CBLOCKS[1],512);
    4 : MOVE (DBLOCK4[1],CBLOCKS[1],512);
    5 : MOVE (DBLOCK5[1],CBLOCKS[1],512);
    6 : MOVE (DBLOCK6[1],CBLOCKS[1],512);
    7 : MOVE (DBLOCK7[1],CBLOCKS[1],512);
    8 : MOVE (DBLOCK8[1],CBLOCKS[1],512);
}
    11 : MOVE (Cash11.DB_LOC_PROGS[1],CBLOCKS[1],512);
  END;
  IF CWRITE (CashFile,1,DEFBLOCK)<1 THEN AbortProgram (DEFERR);
End;

Procedure SECREAD;
Begin
  IF CREAD (FarmFile,2,0)<2 Then
     AbortProgram (SECERR)
  Else
      MOVE (CBLOCKS[1],RFarmGate.PBLOCK0[1],1024);
End;

Procedure SECWRITE;
Begin
  MOVE (RFarmGate.PBLOCK0[1],CBLOCKS[1],1024);
  IF CWRITE (FarmFile,2,0) < 2 Then AbortProgram (SECERR);
End;

Procedure JnlRead ( Jnl : Integer; Var SUB : Integer );
Var
  POS_X,
  TEMP_POS,
  X,
  BLK : INTEGER;
Begin
  {
  REPEAT
    DEFCHECK;
  UNTIL NOT ESCKEY;
  }
  BLK:=(JNL+11) DIV 6;
  SUB:=(JNL+12)-(BLK*6);
  If CREAD (CashFile,1,BLK)<1 Then;
  Move (CBLOCKS[1],Cash3.DBLOCK2[1],512);

  x := 0;

  While (Cash3.XJOURNAL[sub].XAMOUNT[X] In [chr (0),chr(255)]) and (x < 7) do
        inc (x);
  inc (x);

  If ( Cash3.XJOURNAL[sub].XAMOUNT[1] ) = chr ( 255 ) Then
     fillchar (temp_val[0], sizeof (temp_val), chr (255))
  Else
      fillchar (temp_val[0], sizeof (temp_val), chr (0));

  pos_x := 7;
  temp_pos := 0;
  While pos_x >= x Do
        Begin
             MOVE (Cash3.XJOURNAL[sub].XAMOUNT[pos_x-1],
                  Temp_val[temp_pos], 2);
             dec ( pos_x, 2 );
             inc ( temp_pos, 2 );
        End;
//  Move ( temp_val[0], Cash3.xjournal[sub].XNewAmt, sizeof(Cash3.xjournal[sub].XNewAmt) );

  Move ( temp_val[0], Cash3.xjournal[sub].XAmount, sizeof(Cash3.xjournal[sub].XAmount) );

End;

Procedure JnlWrite ( Jnl : Integer );
Var
  POS_X,
  TEMP_POS,
  X,
  APos,
  BLK : INTEGER;
  ERR : INTEGER;
Begin
  BLK:=(JNL+11) DIV 6;
  APos:=(JNL+12)-(BLK*6);
  Repeat
    {
    Repeat
      DEFCHECK;
    Until NOT ESCKEY;
    }
    ERR:=0;

    If ( Cash3.xjournal[APos].xNewAmt >= 0 ) Then
       fillchar (temp_val[0], sizeof (temp_val), chr (0))
    Else
        fillchar (temp_val[0], sizeof (temp_val), chr (255));
    MOVE (Cash3.xJournal[APos].xNewAmt, Temp_val[0], sizeof(Cash3.xJournal[APos].xNewAmt));


    x := 7;
    While (Temp_val[x] In [chr (0),chr(255)]) and (x > 0) do
          dec (x);
    pos_x := 0;
    temp_pos := 6;
    While pos_x < 7 Do
          Begin
               MOVE (temp_Val[temp_pos],
                    Cash3.xJournal[APos].xAmount[pos_x], 2);
               inc ( pos_x, 2 );
               dec ( temp_pos, 2 );
          End;
    Move (Cash3.DBLOCK2[1],CBLOCKS[1],512);
    IF CWRITE (CashFile,1,BLK)<1 THEN ERR:=99;
    IF ERR=0 Then ERR:=ERRORNO;
    IF ERR>0 Then
      Begin
	{
	BEEPUSER (1);
	CLEARFROM (24);
	DIS ( 1,24,'*** ENSURE PROGRAM DISK IS UNPROTECTED & PRESS RETURN');
	REC (55,24,0,NULL,0);
	CLEARFROM (24);
	}
        MessageDlg('ENSURE PROGRAM DISK IS UNPROTECTED', mtInformation,[mbOk], 0);
	EXIT;
      End;
  Until ERR=0;
End;

Begin
{-----------------------------	INITIALIZATION	------------------------------}


{-------------------------------  TERMINATION  -------------------------------}


End.
