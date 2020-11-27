{
  File	    : U-DB:INIT.TEXT
  Unit	    : DB_INIT
  Prefix    :
  Status    : Finished       

  DATE'S
  Started   : 22-04-92
  Finished  : 22-04-92

  Unit DB_Init contains the routines for the start-up of the program

  10/01/19 [V4.3 R4.1] /MK Change - INITIALISE - If the database form Farmgate doesn't exist then look through other databases in the Kingsacc folder
                                                 then default the Farmdate database to the first database found i.e subforder containing Cashbook.def.
}

Unit Init;

{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface


{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

PROCEDURE INITIALISE;

{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation

Uses
  {,
  DiaLogs,}
  Classes,
  ChkComp,
  TYPES,
  VARS,
  PARAMS,
  ABORTPRG,
  FILED,
  DefSecFl,
  CLEARS,
  SYSUTILS,
  KROUTINES;

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

PROCEDURE INITIALISE;
VAR
   SCOMPS : TSTRINGS;

   PROCEDURE SETMONTHS;
   BEGIN
     MONTHNAME [ 1]:='JAN';
     MONTHNAME [ 2]:='FEB';
     MONTHNAME [ 3]:='MAR';
     MONTHNAME [ 4]:='APR';
     MONTHNAME [ 5]:='MAY';
     MONTHNAME [ 6]:='JUN';
     MONTHNAME [ 7]:='JUL';
     MONTHNAME [ 8]:='AUG';
     MONTHNAME [ 9]:='SEP';
     MONTHNAME [10]:='OCT';
     MONTHNAME [11]:='NOV';
     MONTHNAME [12]:='DEC';
   END;

   PROCEDURE MONTHDAYS;
   BEGIN
     DAYS [ 1]:=31;
     DAYS [ 2]:=28;
     DAYS [ 3]:=31;
     DAYS [ 4]:=30;
     DAYS [ 5]:=31;
     DAYS [ 6]:=30;
     DAYS [ 7]:=31;
     DAYS [ 8]:=31;
     DAYS [ 9]:=30;
     DAYS [10]:=31;
     DAYS [11]:=30;
     DAYS [12]:=31;
   END;

   PROCEDURE SECOPEN;
   BEGIN
     CCLOSE (FarmFile, 'N');
     CRESET (FarmFile, SECID);
     IF ERRORNO>0 THEN AbortProgram (SECERR);
   END;

BEGIN
   CURRDB   := 0;
   CHARINS  := 9;
   CHARDEL  := 4;
   CHAREOL  :=15;
   CHARALL  :=16;
   SYSDATE  := 0;
   ESCKEY   :=FALSE;
   DATAOPEN :=FALSE;
   ALLOWUP  :=FALSE;
   ALLOWDOWN:=FALSE;
   FLUSH	   :=TRUE;
   STRDATE  :=NULL;
   DEVICE   :='S';
   PRNT	   :='PRINTER:';

   RFarmGate.PLOCATION[2] := '';

  // GetDir ( 0, SubDir );                   // TGM AB 19/12/14
  //  SubDir := SubDir + '\';                // TGM AB 19/12/14
   Subdir := extractfilepath(paramStr(0));   // TGM AB 19/12/14

   SECID	   := SubDir + FARMGATE;
   SECOPEN;
   SECREAD;

   //   10/01/19 [V4.3 R4.1] /MK Change - If the database form Farmgate doesn't exist then look through other databases in the Kingsacc folder
   //                                     then default the Farmdate database to the first database found i.e subforder containing Cashbook.def.
   if ( not(DirExists(Subdir + RFarmGate.PLOCATION[2])) ) then
      begin
         SCOMPS := GETACCSDATABASES;
         IF ( SCOMPS.Count > 0 ) THEN
            RFarmGate.PLOCATION[2] := SCOMPS[0]
         ELSE
            EXIT;
      end;

   DEFOPEN ('0',TRUE);

   DEFREAD (0);
   DEFREAD (1);
   DEFREAD (11);

   { Store the User Entered System Date for use in data entry & Reports }
   Cash11.Default_Date := Cash1.xDate;
   { Check the last bank is in the Bank Ranges }
   If ( Cash1.xLastBank < Cash1.xBankMin ) Or ( Cash1.xLastBank > Cash1.xBankMax ) Then
      Cash1.xLastBank := Cash1.xBankMin;
   SETMONTHS;
   MONTHDAYS;
   (*
   BOXLINE:=CONCAT(SPACE30,SPACE30,SPACE15,SPACE2);
   UNDLINE:=CONCAT(SPACE30,SPACE30,SPACE12,SPACE8);
   FILLCHAR (BOXLINE[1],77,CHR(PBOXES[1]));
   FILLCHAR (UNDLINE[1],80,CHR(PBOXES[1]));
   *)
   MAXLINES:=RFarmGate.PLINESPAGE[1];
END;


Begin
{-----------------------------	INITIALIZATION	------------------------------}


{-------------------------------  TERMINATION  -------------------------------}


End.
