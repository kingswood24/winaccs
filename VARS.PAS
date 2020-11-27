{
  File	    : U-DB:VARS.TEXT
  Unit	    : DB_VARS
  Prefix    :
  Status    : Finished
  Level	    : 2

  DATE'S
  Started   : 15-04-92
  Modified  : 22-September-1994

  This Unit contains Variables vital to the running of the programs.  This unit
  is on access level 2 which means that it only depends on the unit TYPES.
      
  02/08/95 MC. Added 5 new globals all prefixed g_ ( integers ).

    15/02/02 TGM AB Added global param_start (boolean) & param_type (string)
  (S - Sales, P - Purchase, M - mainscreen, R  - reports) when running the program with startup parameters
  Also firstrun - used as flag to trigger trial balance check first time main screen is viewed
}


Unit VARS;
{$O-}
{$A-}
{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface

Uses
  printers,
  TYPES;

type
    TCash1 = record
      DBLOCK0	: PACKED ARRAY [1..2] OF CHAR;
      XCOMPANY	: STRING[41];
      XDATE	        : STRING[9];
      XMONTHNO	: SmallInt;
      XTAXRATES	: PACKED ARRAY [0..9] OF SmallInt;
      XDEFBANK	: SmallInt;       //default bank account
      XTAXCODE	: STRING[9];
      XGROSSSL	: WORDBOOL;
      XCALCSTAX	: WORDBOOL;
      XSHOWTOTS	: WORDBOOL;
      XNOMTAX	: SmallInt;
      XNOMDEBTOR	: SmallInt; 
      XNOMCREDIT	: SmallInt;
      XNOMSLDISC	: SmallInt;
      XNOMPLDISC	: SmallInt;
      XNOMPROFIT	: SmallInt;
      XNOMINCFROM   : SmallInt;
      XNOMINCTO	: SmallInt;
      XNOMEXPFROM   : SmallInt;
      XNOMEXPTO	: SmallInt;
      XBANKMIN	: SmallInt;
      XBANKMAX	: SmallInt;
      XORDTXFILE	: STRING[23];
      XVACCFILE	: STRING[23];
      XVSTKFILE	: STRING[23];
      XAUTOLIST	: WORDBOOL;
      XNOMWEEK	: WORDBOOL;
      XWEEKNO	: SmallInt;
      XMAXVANS	: SmallInt;
      XMONTXFILE	: STRING[23];
      XSTUBCOM	: PACKED ARRAY [1..2] OF BOOLEAN;
      XSETGROUP	: WORDBOOL;
      XRAWFILE	: STRING[23];
      XMIXFILE	: STRING[23];
      XUSEFILE	: STRING[23];
      XGROSSPL	: WORDBOOL;
      XCALCPTAX	: WORDBOOL;
      XORDWEEKS	: SmallInt;
      XORDITEMS	: SmallInt;
      XORDCYCLE	: SmallInt;
      XYEAREND	: WORDBOOL; // was XSELFBILL used as flag for completed year end
      XSUPWEEKS	: SmallInt;
      XNOMNONFROM   : SmallInt;
      XNOMNONTO	: SmallInt;
      XNOMOPEN	: SmallInt;
      XSALSTATE	: STRING[23];
      XPENNIES	: WORDBOOL;
      XLASTTX	: SmallInt;
      XMENULOAD	: STRING[23];
      XDATEBEEP : WORDBOOL;  (* // TGM AB was XDATEBEEP now XNOMEDIT - true to enable editing & false to disable editing ??  *)
      XCOPYBAL	: WORDBOOL;
      XDEFCOMM	: WORDBOOL;
      XINTERJNL	: PACKED ARRAY [1..2] OF BOOLEAN;
      XCASHBOOK	: WORDBOOL;
      XINVCOST	: WORDBOOL;
      XINVSPTX	: PACKED ARRAY [1..2] OF BOOLEAN;
      XCRNALLOC	: WORDBOOL;
      XREMASCII	: PACKED ARRAY [1..4] OF 0..255;
      XSIMPLE	: WORDBOOL;  // was xvanrec  TGM AB - Variable to hold simple interface flag for cashbook
      XANOTHER	: WORDBOOL;
      XMULTPAY	: WORDBOOL;
      XFRANCHISE	: WORDBOOL;
      XCUSTDISC	: WORDBOOL;
      XUNITDISC	: WORDBOOL;
      XTAXIDS	: PACKED ARRAY [0..9] OF STRING[1];
      XNOMOHFROM	: SmallInt;
      XNOMOHTO	: SmallInt;
      XNOMCAFROM	: SmallInt;
      XNOMCATO	: SmallInt;
      XNOMFAFROM	: SmallInt;
      XNOMFATO	: SmallInt;
      XNOMLIFROM	: SmallInt;
      XNOMLITO	: SmallInt;
      XNOMPRVINC	: SmallInt;
      XNOMPRVEXP	: SmallInt;
      XPAYSTUB	    : Packed array [1..8] Of Char; { LONG; }
      XRECSTUB	    : Packed array [1..8] Of Char; { LONG; }
      XKEEPTRAN	: WORDBOOL;
      XRESETNOM	: WORDBOOL;
      XNOMDEPREC	: SmallInt;
      XUSERTX	: Packed array [1..6] Of Char; { PACKED ARRAY [1..48] OF BOOLEAN; }
      XGROSSJL	: WORDBOOL;
      XCALCJTAX	: WORDBOOL;
      XSHOWBANK	: WORDBOOL;
      XFINYEAR	: SmallInt;
      XFINMONTH	: SmallInt;
      XNOMTHIS	: WORDBOOL;
      XPURSTATE	: STRING[23];
      XNOMLAST	: WORDBOOL;
      XLASTBANK	: SmallInt;
      XPRDSYS	: WORDBOOL;
    end;


    TCash2 = Record
    { Second Definition block from CASHBOOK.DEF }
      DBLOCK1	: PACKED ARRAY [1..2] OF CHAR;
      XORDERFILE	: STRING[23];
      XDELIVFILE	: STRING[23];
      XISSTITLE	: STRING[19];
      XRECTITLE	: STRING[19];
      XENTUPPER	: STRING[15];
      XENTLOWER	: STRING[15];
      XACCSYS	: WORDBOOL;
      XINVSYS	: WORDBOOL;
      XORDSYS	: WORDBOOL;
      XBUDSYS	: WORDBOOL;
      XFWDFILE	: STRING[23];
      XMONTHLY	: WORDBOOL;
      XAllocation: WORDBOOL;   // TGM AB was XQUICKLY
      XCRALLOK	: WORDBOOL;
      XINVALLOC	: WORDBOOL;
      XTXANAL	: WORDBOOL;
      XBLANK	: WORDBOOL;
      XTAXTYPES	: PACKED ARRAY [0..9]  OF CHAR;
      XDIARY	: WORDBOOL;
      XOTHER	: WORDBOOL;
      XENTEXTRA	: WORDBOOL;
      DSPARE3	: PACKED ARRAY [0..1] OF CHAR;
      vat_inc_exc   : packed array [0..9] of char;
      DSPARE4	: PACKED ARRAY [1..14] OF CHAR;
      XTXDETAIL	: WORDBOOL;
      XENTFILE	: STRING[23];
      XSLACCFILE	: STRING[23];
      XPLACCFILE	: STRING[23];
      XNLACCFILE	: STRING[23];
      XTRANSFILE	: STRING[23];
      XDIARYFILE	: STRING[23];
      XDIRECTORY	: STRING[15];
      XHELPDIR	: STRING[15];
      XPASSWORD	: PACKED ARRAY [1..5] OF STRING[7];
      XPASSNO	: Packed Array [1..8] Of Char; { PACKED ARRAY [1..20] OF 0..5; }
      XREMLINES	: SmallInt;
      XLASTDUE	: STRING[9];
      XPRODSUBS	: WORDBOOL;
      XMIDWEEK	: WORDBOOL;
      XCONMENU	: ddouble;
      XACCMENU	: ddouble;
      XINVMENU	: ddouble;
      XORDMENU	: ddouble;
      XBUDMENU	: ddouble;
      XMASTPASS	: STRING[7];
      XSALESINFO	: WORDBOOL;
      XPURCHINFO	: WORDBOOL;
      XWININV	: WORDBOOL;       // Formally XHELLO
      XSTOCKFILE	: STRING[23];
      XINVTYPE	: STRING[1];
      XORDSUMM	: WORDBOOL;
      XINVLINES	: SmallInt;
      XINVCHARS	: SmallInt;
      XPaymentVAT	: WORDBOOL;   // Formally XCOMBINE
      XCOUNTRY	: SmallInt;    // 2 = S Ireland
      XPRDMENU	: ddouble;
    End;

    TCash3 = Record
    { Cashbook.def Third Journal Block 2+ }
      DBLOCK2	    : PACKED ARRAY [1..2] OF CHAR;           { SizeOF  2 }
      XJOURNAL    : PACKED ARRAY [1..6] OF RECORD
         XNO	   : SmallInt;                               { SizeOf  2 }
         XNAME     : STRING[21];                             { SizeOf 22 }
         XREF      : STRING[9];                              { SizeOf 10 }
         XDEBIT    : SmallInt;                               { SizeOf  2 }
         XCREDIT   : SmallInt;                               { SizeOf  2 }
         XDESC     : STRING[15];                             { SizeOf 16 }
         XAMOUNT   : Packed Array [0..7] Of Char;            { SizeOf  8 }
         XTAX      : STRING[1];                              { SizeOf  2 }
         XANAL     : SmallInt;                               { SizeOf  2 }
         XTYPE     : SmallInt;                               { SizeOf  2 }
         XAMEND    : WORDBOOL;                               { SizeOf  2 }
         xNewAmt   : LongInt;                                { SizeOf  2 }
         xQty      : LongInt;                                { SizeOf  2 }
         {x         : SmallInt;}                               { SizeOf  2 }
         XSPARE    : PACKED ARRAY [1..6] OF CHAR;           { SizeOf 6 }
      END;
      DFILLER2    : PACKED ARRAY [1..6] OF CHAR;             { SizeOf 6 }
    End;


    TCash11 = Record
    { 11th Definition block from CASHBOOK.DEF }
      DB_LOC_PROGS    : packed array [1..2] of char;
      XCON_LOCAT,						  (* program locations *)
      XACC_LOCAT,
      XINV_LOCAT,
      XBUD_LOCAT,
      XRND_LOCAT,
      XPRD_LOCAT      : string[25];
      LIVE_LNK	      : string[23];
      LIVE_SDB	      : string[23];
      NOT_USED	      : string[23];
      XCONFIG_OK,					      (* configurator access *)
      XSTOP_OTHERS    : WORDBOOL;		     (* stop access to other systems *)
      SYS_EXPIRES,				    (* store the expiry date *)
      DEFAULT_DATE    : STRING[9];			       (* store default date *)
      TRANS_AMEND     : WORDBOOL;	      (* set if full trans editing on or off *)
      CHK_WRITING     : WORDBOOL;	     (* allows the option of printing cheque *)
      Xuse_enterprise : WORDBOOL;		   (* true for excluding Enterprises *)
      Xuse_vat	      : WORDBOOL;			     (* true for exclude VAT *)
      Xuse_inc_exp    : WORDBOOL;	     (* use the Income & Expenditure Options *)
      xgroupfile      : string[23];			 (* group file name location *)
      xanl_file	      : string[23];
      xp_words	      : WORDBOOL;			  (* exclude use of password *)
      first_password  : WORDBOOL;(* set when analysis file is created KA2.0 R1.3 *)
      first_prot      : WORDBOOL;
      serial_no	      : Packed array [1..8] OF Char; {long;}
      xuse_livestock  : WORDBOOL;
      vat_desc	      : array [0..9] of string[7];
      year_period_rep : packed array [1..4] Of Char; {[1..17] Of Boolean; }
      xno_of_partners : SmallInt;	      {* No. Of Partners in Companies max. 10 }
      first_option    : SmallInt;
      xUpdateNo       : SmallInt;
      xDefaultBankRec : String[1];
      xSaveAsEuro     : Boolean;  { True if base currency is Pounds }
      xEuroConverter  : Double; // 1/1/1999 fixed IRL rate is 0.787564
      xUnUsed         : Double;
      xResetSales     : Boolean;  // Monthend - reset sales.
      xResetPurchases : Boolean;  // Monthend - reset purch.
      xPrintFrom      : SmallInt; // Used to control the start line for the Record card report - TGM AB No longer used
      xUseLastNomDesc : Boolean;
      xBilling        : Boolean;  // New Module for Contractors
//      FILL_UP	      : packed array [1..68] of char;      (* fill rest of block *)                                     // TGM AB 12/06/15
      xSalesPaymentVAT   : char;                           (* Y / N for using payment based VAT for sales *)            // TGM AB 12/06/15
      xPurchPaymentVAT   : char;                           (* Y / N for using payment based VAT for Purchases *)        // TGM AB 12/06/15
      XSimpleVAT         : WORDBOOL;
      FILL_UP	      : packed array [1..64] of char;      (* fill rest of block *)                                     // TGM AB 12/06/15
    end;


procedure Initialize_TxEditRec;


{--------------------------------  CONSTANTS  --------------------------------}

{--------------------------------  VARIABLES  --------------------------------}
VAR
  Enter_Pass : boolean;
  Ext_Line,			 { extended 132 char report }
  Slim_on_Left : boolean;     { when getting info from data base if
				slim_on_left is true the slimleft }
  Txt_File     : String{[8]};	 { Out file Name }
  Terminate    : Boolean;	 { Terminate report }
  Pageno    : Integer;		 { page number counter }
  Option    : Integer;		 { menu choice option }
  Search_Fld: Integer;		 { field number used when search procedure is used }
  dbase_num : integer;		 { dbase number used for list codes }
  Func_Disp : Boolean;		 { display function key help line or not }
  Ped_Search: Boolean;		 { pedigree search }
  Ped_Type  : Integer;		 { pedigree search type }
  Ped_C_Num : String{[6]};	 { pedigree cow number }
  HELPNAME  : STRING{[9]};	 { help file name }
  PROGNAME  : STRING{[19]};	 { current program name }
  Main_Exit : boolean;		 { allow F10 at main menu to exit program }
  F10_Exiting : boolean;	 { set to true when user chooses to exit }
  Save_All : boolean;		 { allow F10 durning set cow screen }
  F10_Saving : boolean;		 { true if F10 hit durning set cow scren }
  List_Parlour : boolean;	 { do a parlour system type list }
  F9_Selected : boolean;	 { true if F9 was selected }
  F9_Allowed : integer;		 { set depending on what F9 is doing }
  F8_Selected : boolean;	 { true if F8 was selected }
  F7_Selected : boolean;	 { true if F7 was selected }
  F7_Allowed : integer;		 { set depending on what F7 is doing }

  g_recno,
  g_type_list,
  g_read_db,
  g_item    : integer;    {* Used to control F2 Listing of old code Listit }
  SubDir   : String;

   // TGM AB 15/02/02
  param_start : boolean;
  param_type : string;
  firstrun : boolean;

  // TGM AB 04/10/04 - Added For Paradox Tables
  EntsMax : integer;
  EntsUsed : integer;
  SLMax : integer;
  SLUsed : integer;
  PLMax : integer;
  PLUsed : integer;

  // TGM AB 01/12/06
  ParamSecurityByPass : boolean;

  UNDLINE   : STRING;{[80]}
  BOXLINE   : STRING;{[77]}
  NEWPAGE   : BOOLEAN;
  ALLOWUP   : BOOLEAN;
  ALLOWDOWN : BOOLEAN;
  UPKEY	    : BOOLEAN;
  DOWNKEY   : BOOLEAN;
  OFFSET    : INTEGER;
  LINE	    : INTEGER;
  LINECOUNT : INTEGER;
  TIDYINDEX : BOOLEAN;
  AUTOINDEX : BOOLEAN;
  HERDID    : STRING{[1]};
  DEVICE    : STRING{[1]};
  WDRIVE    : STRING{[4]};
  PRINTLINE : STRING{[132]};
  MAXBULLS  : INTEGER;
  MAXFEED   : INTEGER;
  MAXLINES  : INTEGER;
  TABNUM    : INTEGER;
  TABSTR    : STRING{[32]};
  DATAOK    : BOOLEAN;
  NUMDAYS   : INTEGER;
  STRDAYS   : STRING{[4]};
  SYSDATE   : INTEGER;
  STRDATE   : STRING{[8]};
  LASTNMR   : STRING{[8]};
  LASTINT   : STRING{[8]};
  DAYS	    : PACKED ARRAY [1..12] OF INTEGER;
  MONTHNAME : PACKED ARRAY [1..12] OF STRING[3];
  MONTHNO   : INTEGER;
  ABSMONTH  : INTEGER;
  NEXTREC   : INTEGER;
  dbScc	    : Integer;	      { database number of somatic cell count db }
  dbGrp	    : integer;	      { database number if group names db }
  DBCLF	    : INTEGER;
  DBPLF	    : INTEGER;
  DBFEEDF   : INTEGER;
  DBMPF	    : INTEGER;
  DBBULLF   : INTEGER;
  DBINTF    : INTEGER;
  DBHRF	    : INTEGER;
  DBNMRF    : INTEGER;
  DBHPF	    : INTEGER;
  DBEDF	    : INTEGER;
  DBCUMF    : INTEGER;
  DBMQF	    : INTEGER;
  DBLCF	    : INTEGER;
  DBFCF	    : INTEGER;
  DBGFF	    : INTEGER;
  DBGRF	    : INTEGER;
  ESCKEY    : BOOLEAN;
  SCRIN	    : STRING;
  SCRINT    : STRING;
  DAYTOT    : LONG;
  DATAOPEN  : BOOLEAN;
  FLUSH	    : BOOLEAN;
  OPENYEAR  : String{[2]};

  FLOPEN    : PACKED ARRAY [1..MaxFiles] OF BOOLEAN;

  SECID,
  DEFID,
  SORTID,
  MISCID,
  PRNT	    : STRING{[40]};
  Dos_Txt_File : TextFile;
  PRINTFILE : TextFile;
//  SEQREC    : PACKED ARRAY[1..256] OF INTEGER;
//  SEQBLK    : INTEGER;
//  SEQMAX    : INTEGER;
  AUTOPROG,
  ACT,
  PROG      : Integer;    {* Sets path through code in conjunction with ACT }
  tx_start,
  tx_end    : Integer;    {* globals to use for sorting reports ist & Last TX }
  schrecf,
  schrect   : Integer;

  CHARINS,CHARDEL,CHAREOL,CHARALL: INTEGER;

  ERRORNO: INTEGER;

  (*** 0  - OK					   ***)
  (*** 1  - DATA BASE NOT OPENED		   ***)
  (*** 2  - ERROR READING FROM DISK		   ***)
  (*** 3  - ERROR WRITING TO DISK		   ***)
  (*** 4  - INDEX KEY (PRIME/SECONDARY) NOT FOUND  ***)
  (*** 5  - RECORD NUMBER NOT FOUND		   ***)
  (*** 6  - NO SPARE RECORDS IN THE DATA BASE	   ***)
  (*** 7  - INDEX OVERFLOW AREA IS FULL - INDEX	   ***)
  (*** 8  - INCONSISTANT DATA - PLEASE AUDIT	   ***)
  (*** 9  - PATHNAME NAME INVALID ON OPENDB	   ***)
  (*** 10 - NO DETAILS CURRENT (SHOULD HAVE BEEN)  ***)
  (*** 11 - INVALID DATA BASE NUMBER		   ***)
  (*** 12 - NOT APPLICABLE TO THIS DATA BASE	   ***)

  CURRDB: INTEGER;

  DBBASE : Packed Array [1..MaxFiles] Of FILE;

  DATWORK     : ^DW_TYPE;
  DBHOLD      : Packed Array [1..MaxDatabases] Of ^DB_HOLD_TYPE;
  DBOPEN      : PACKED ARRAY [1..MaxDatabases] OF BOOLEAN;

  CBLOCKS: PACKED ARRAY[1..DOS_BLK_MAX] OF DOS_BLK;

  (*** CURRENT RECORD / BLOCK DETAILS ***)
  CURRREC:    ARRAY[1..MaxDatabases] OF INTEGER;	(** CURRENT RECORD NUMBERS **)
  CURRDATBLK: ARRAY[1..MaxDatabases] OF INTEGER;	(** CURRENT DATA BLOCK NOS **)
  CURROFST:   ARRAY[1..MaxDatabases] OF INTEGER;	(** CURRENT RECORD OFFSETS **)

  (*** CURRENT ITEM POST "GETITEM" - PRE "PUTITEM" VARIABLES ***)

  CURRDISP:   PACKED ARRAY[1..MAXISIZE] OF CHAR; (*** DISPLAY FORMAT **)

  CURRSTR:    STRING132;	  (** DISPLAY FORMAT AS A STRING   **)
			  (** NO LEADING / TRAILING SPACES **)
  CURRSIZE:   SmallInt;	  (** DISPLAY SIZE OF LAST GETITEM **)
  CURRINT:    SmallInt;	  (** INTEGER VALUE OF LAST  "	   **)
  CURRLONG:   BIGLONG;	  (** LONG VALUE OF LAST     "	   **)
  CURRKONG:   SHORTLONG;
  TxEditRec   : TxEditType;
  GEditing    : Boolean;   { True if editing transactions }


  DB1: PACKED RECORD
    DBFILLS:	  PACKED ARRAY[1..2] OF CHAR;
    DBVERSION:	  SmallInt;
    DBVERSION1:  SmallInt;
    DBVERSION2:  SmallInt;
    DBNAME:	  STRING[31];
    DBLOCKING:	  STRING[9];  (*** 'Y' OF LOCKING APPLICABLE ***)
    DBDATEUPD:	  STRING[9];
    DBLOCKID:	  STRING[9];  (*** UNIQUE ID FOR DB LOCKS ***)
    DBRECSZ:	  SmallInt;
    DBINDEX1:	  SmallInt;
    DBRECNO:	  CHAR2;
    DBINDEX2:	  SmallInt;
    DBINDSTAT:	  CHAR2;
    DBRECTOT:	  SmallInt;
    DBTABTOT:	  SmallInt;
    DBIND1S:	  SmallInt;
    DBIND1T:	  SmallInt;
    DBIND2S:	  SmallInt;
    DBIND2T:	  SmallInt;
    DBTABS:	  SmallInt;
    DBTABT:	  SmallInt;
    DBDATAS:	  SmallInt;
    DBDATAT:	  SmallInt;
    DBRECHIGH:	  Integer;     // TGM AB
    DBRECBLK:	  SmallInt;
    DBIND1BLK:	  SmallInt;
    DBIND2BLK:	  SmallInt;
    DBSORTWORK:  STRING[19];
  //  DBSPARE:	  SmallInt;    // TGM AB
    DBPAGETHROW: CHAR2;
    DBPASS:	  STRING[11];
    DBIND3S:	  SmallInt;
    DBIND3T:	  SmallInt;
    DBINDEX3:	  SmallInt;
    DBIND3BLK:	  SmallInt;
    DBUPDPASS:	  PACKED ARRAY[1..3] OF STRING[11];
    DBMASTPASS:  STRING[11];
    DBWAIT:	  SmallInt;
    DBITEMTOT:	  SmallInt;
    DBITEMBLKS:  SmallInt;
    DBMUSTART:	  SmallInt;
    DBMUBLKS:	  SmallInt;
    DBSPSTART:	  SmallInt;
    DBSPBLKS:	  SmallInt;
    DBSCRSTART:  SmallInt;
    DBSCRBLKS:	  SmallInt;
    DBBITSTART:  SmallInt;
    DBBITBLKS:	  SmallInt;

    DBUSER:	  PACKED ARRAY[1..20] OF SmallInt;
    DBFILLEND:	  PACKED ARRAY[1..FILLSPARE] OF CHAR;
    DBCFILL:	  PACKED ARRAY[1..88] OF CHAR;

    DBITEMS:	  PACKED ARRAY[1..MAXITEMS] OF RECORD
      DBIFILL:	  PACKED ARRAY[1..2] OF CHAR;
      DBINAME:	  STRING[11];
      DBITYPE:	  CHAR2;
      DBIOFSET:  SmallInt;
      DBIRECSZ:  SmallInt;
      DBISIZE:	  SmallInt;
      DBICALC:	  PACKED ARRAY[1..10] OF CHAR;
    END;

  END;
  Temp_Val : Packed array [0..9] Of Char;

  { Cashbook.DEF First Block }
  Cash1 : TCash1;

  { Second Definition block from CASHBOOK.DEF }
  Cash2 : TCash2;

  { Cashbook.def Third Journal Block 2+ }
  Cash3 : TCash3;

  { 11th Definition block from CASHBOOK.DEF }
  Cash11 : TCash11;

  xFirstTx : smallint; // this var set in full audit 'fistTxThisYear' function
                       // which is run every time fill grid is called.
                       // GM created it 11/05/02 to store the first tx of the current year, used for
                       // starting the grid at the right place + restting pointers properly during editing
                       // LOWtx in unit audit is set to this var so reset restting pointers doesn't mess up
                       // nominal audit trail.

{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation

procedure Initialize_TxEditRec;
var
  Counter : Integer;
begin
     with TxEditRec Do
         Begin
              TransF := 0;
              TransT := 0;
              TransType := '  ';
              TxRow     := -1;  { Store the Row Number for redisplaying }
              For counter := 1 To ((maxgridlines *2) + 2) Do //TENFOUND WAS 22
                  Begin
                       TxType[counter] := -1;
                       TxNo[counter] := 0;
                  End;
         End;
end;

Begin
{-----------------------------	INITIALIZATION	------------------------------}
  Txt_File := 'ACCOUNTS';	      { set default text file name }
  Func_Disp := True;	      { set default function key help line = TRUE }
  Main_Exit := false;	      { set default F10 to exit = false }
  save_all := false;	      { set default save all screen = false }
  Ext_line := true;
  Slim_on_Left := true;		 { set default }
  List_Parlour := false;      { parlour list is off }
  F9_Selected := false;	      { true if F9 was selected }
  F9_Allowed := 0;	      { set depending on what F9 is doing }
  F8_Selected := false;	      { true if F8 was selected }
  F7_Selected := false;
  F7_Allowed := 0;
  Enter_Pass := false;

  g_recno      := 0;	      { Initialise globals for F2 listing u-db:Listit }
  g_type_list  := 0;
  g_read_db    := 0;
  g_item       := 0;
  fillchar ( Temp_Val, sizeof(Temp_val), chr(0));
  GEditing     := False;

   // TGM AB  15/02/02
  param_start := false;
  param_type := '';
  firstrun := true;
  ParamSecurityByPass := false;

{-------------------------------  TERMINATION  -------------------------------}

End.


