{
    
  File	    : U-DB:PARAMS.TEXT
  Unit	    : DB_PARAMS
  Prefix    : DB
  Status    : Finished
  Level	    : 2

  DATE'S
  Started   : 15-04-92
  Modified  : 30-March-1994

  This unit will hold all the vars that the program uses from the dairy
  defination file.  This unit is also on a level 2 which like the unit VARS it
  only uses unit TYPES.

  FAMILY 30.3.95: changes made to implement the use of the cow family file.
}


Unit PARAMS;
{$O-}

{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface

type
  THoldRec = Record
  PBLOCK0     : PACKED ARRAY [1..2] OF CHAR;
  PDEFVOL     : STRING[7];
  PCONFIRM    : WORDBOOL;
  PSPARE      : PACKED ARRAY [1..8] OF CHAR;
  PSECURITY   : SmallInt;
  PSERIAL     : Packed array [1..8] Of Char;

  PCONTROL    : Packed Array [1..24] Of Char; {PACKED ARRAY [1..3] OF LONG;}
  PUSER	   : STRING[31];
  PLOCFILES   : STRING[27];
  PSUFFIX     : PACKED ARRAY [1..9] OF STRING[5];
  PTERMINIT   : PACKED ARRAY [1..9] OF SmallInt;
  PTERMEND    : PACKED ARRAY [1..9] OF SmallInt;
  PINVON      : PACKED ARRAY [1..3] OF SmallInt;
  PINVOFF     : PACKED ARRAY [1..3] OF SmallInt;
  PCURON      : PACKED ARRAY [1..3] OF SmallInt;
  PCUROFF     : PACKED ARRAY [1..3] OF SmallInt;
  PLOWINT     : PACKED ARRAY [1..3] OF SmallInt;
  PHIGHINT    : PACKED ARRAY [1..3] OF SmallInt;
  PUNDON      : PACKED ARRAY [1..3] OF SmallInt;
  PUNDOFF     : PACKED ARRAY [1..3] OF SmallInt;
  PBOXES      : PACKED ARRAY [1..20] OF SmallInt;
  PSOLIDLINE  : SmallInt;
  PINSERT     : SmallInt;
  PDELETE     : SmallInt;
  PERASEEND   : SmallInt;
  PERASEALL   : SmallInt;
  PINSLINE    : SmallInt;
  PDELLINE    : SmallInt;
  PSPECIAL    : SmallInt;
  PPRINTSCR   : SmallInt;
  PPREFIX     : SmallInt;
  PASCIIFROM  : PACKED ARRAY [1..20] OF SmallInt;
  PASCIITO    : PACKED ARRAY [1..20] OF SmallInt;
  PASCIIRET   : Packed array [1..4] Of Char; {PACKED ARRAY [1..20] OF BOOLEAN;}
  PNOTAHEAD   : WORDBOOL;
  PSINGLERET  : WORDBOOL;
  PMENSINGRET : WORDBOOL;
  PLINESPAGE  : PACKED ARRAY [1..3] OF SmallInt;
  PLINEWIDTH  : PACKED ARRAY [1..3] OF SmallInt;
  PLINEASCII  : PACKED ARRAY [1..3,1..9] OF SmallInt;
  PLINESTART  : PACKED ARRAY [1..3] OF SmallInt;
  PLINEEND    : PACKED ARRAY [1..3] OF SmallInt;
  PCOMPANY    : STRING[1];
  PCLEAREND   : SmallInt;
  PCLEARALL   : SmallInt;
  PQUIT	      : SmallInt;
  PHELPKEY    : SmallInt;
  PBOLDON     : PACKED ARRAY [1..4] OF SmallInt;
  PBOLDOFF    : PACKED ARRAY [1..4] OF SmallInt;
  PFILLER0    : PACKED ARRAY [1..6] OF CHAR;

  (*** FARMGATE SECURITY FILE BLOCK 1 ***)

  PBLOCK1     : PACKED ARRAY [1..2] OF CHAR;
  PLOCATION   : PACKED ARRAY [1..20] OF STRING[7];
  PSKIP_CHECK : WORDBOOL;

  xUsePrinter     : Boolean;
  xFontName       : String[12];
  xPointSize      : SmallInt;
  xPointSizeCompressed   : SmallInt;
  xPointSizeUnCompressed : SmallInt;
  xLineSpacing           : SmallInt;

  PFILLER1    : PACKED ARRAY [1..326] OF CHAR;
  End;

{--------------------------------  VARIABLES  --------------------------------}
Var
  (*** FARMGATE SECURITY FILE BLOCK 0 ***)
  RFarmGate : THoldRec;

{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation


Begin
{-----------------------------	INITIALIZATION	------------------------------}

{-------------------------------  TERMINATION  -------------------------------}

End.

