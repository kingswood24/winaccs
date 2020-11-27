{

               Kingswood Computing Ltd. - DB_REPORTING
              

  File      : DBRPT.TEXT
  Unit      : DB_REPORTING
  Prefix    :
  Status    :

  DATE'S
  Started   :
  Modified  :

  This unit contains the routines for printing to the printer, screen and
  for printing to an ASCII text file.
}

Unit DBRPT;

{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface

Uses
  TYPES,
  VARS, Reports;

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

function Prt_on_line : boolean;
(*WINDOWS
procedure chk_dir_exists
           (dir_name : string; auto_create : boolean; var dir_exists : boolean);
*)
Procedure StartPrint ( NarrowPrint : Boolean );
PROCEDURE BUILDSTR (COL: INTEGER; STR: STRING132);
PROCEDURE BUILDLNG (COL: INTEGER; LNG: LONG; LEN: INTEGER);
PROCEDURE BUILDMTP (COL: INTEGER; LNG: LONG; LEN: INTEGER);
PROCEDURE BUILDINT (COL: INTEGER; LNG: LONG; LEN: INTEGER);
PROCEDURE BUILDTAB (DB,NUM,COL : Integer;LEN: SmallInt; STR: ShortString);
PROCEDURE BUILDNEW;
PROCEDURE ENDPRINT;
PROCEDURE REPMESS;
PROCEDURE REPHEAD (HEAD1,HEAD2,HEAD3: ShortString; PAGE: INTEGER);
PROCEDURE REPLINE;
PROCEDURE REPDASH;
PROCEDURE FILLPAGE;
PROCEDURE SENDLINE (LINE: STRING132);
PROCEDURE SKIPLINES(NOLINES: INTEGER);
PROCEDURE EXPANDON;
PROCEDURE EXPANDOFF;

{-----------------------------------------------------------------------------}
{-----------------------------  IMPLEMENTATION  ------------------------------}
{-----------------------------------------------------------------------------}

Implementation

Uses
  Dialogs,
  SHELLAPI,
  WinTypes,
  MainUnit,
  UTIL,
  PARAMS,
  ABORTPRG,
  DBCORE,
  DBGEN,
  CLEARS,
  Printers,
  CALCS,
  SysUtils,
  Graphics,
  PrintSet,
  ReportDefs, NewRepUnit;

var
  Report_Terminated : boolean;
  LineHeight,
  PageW,
  PageH : Integer;

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

Procedure StartPrint ( NarrowPrint : Boolean );
Begin
     If Device = 'P' Then
        Begin
             If NOT RFarmGate.xUsePrinter Then
                PrintForm.ShowModal;

             Printer.BeginDoc;
             Printer.Canvas.Font.Name := RFarmGate.xFontName;
             If NarrowPrint Then
                Begin
                     Printer.Canvas.Font.Size := RFarmGate.xPointSizeUnCompressed;
                     LineHeight := Printer.Canvas.TextHeight('S')-RFarmGate.xLineSpacing;//-30;
                End
             Else
                 Begin
                      Printer.Canvas.Font.Size := RFarmGate.xPointSizeCompressed;
                      LineHeight := Printer.Canvas.TextHeight('S')+RFarmGate.xLineSpacing;
                 End;
             PageH := Printer.PageHeight;
             PageW := Printer.PageWidth;
             RFarmGate.PlinesPage[1] := Trunc ( PageH div LineHeight )-1;
        End
     Else
        Begin
             Device := 'F';
             AssignFile ( Printfile, 'c:\kingsacc\reports\noname.rpt');
             rewrite ( printfile );
        End;

End;


function Prt_on_line;   { : boolean; }
{ ckecks that the printer is on-line.  if the printer does not respond, the
  user is asked to check the printer. if the user hit escape the function will
  return false.  if the printer is on-line the function returns true.
}
const
  PRN_DEV = 6;
  PRN_CONTROL = 16385;
var
{-->>  key_press : char;}
  PRN_Stat : packed record
    time_out : boolean;
    unused : 0..3;
    io_error : boolean;
    selected : boolean;
    out_of_paper : boolean;
    acknowledge : boolean;
    not_busy : boolean;
  end;

  begin
    Prt_on_line := false;       { assum not on-line }
{-->>    key_press := chr (0);}
    
    { check the device for error's }
    fillchar (PRN_Stat, sizeof(PRN_Stat), 0);
    {
    unitstatus (PRN_DEV, PRN_Stat, PRN_CONTROL);
    }
    if ((PRN_Stat.io_error) or (not PRN_Stat.selected) or
                                            (not PRN_Stat.not_busy)) then
      begin
        {
        read (keyboard, key_press);
        }
      end;
    fillchar (PRN_Stat, sizeof(PRN_Stat), 0);
    {
    unitstatus (PRN_DEV, PRN_Stat, PRN_CONTROL);
    }
    if ((not PRN_Stat.io_error) and (PRN_Stat.selected) and (PRN_Stat.not_busy)) then
      Prt_on_line := true;
  end;

(*WINDOWS
procedure chk_dir_exists;
   { (dir_name : string; auto_create : boolean; var dir_exists : boolean); }
var
 POP_Ans : boolean;
 Sa,
 Aa : packed array [0..400] of char;
 i : integer;
 ch : char;
 Q_Ans : string[1];
 Prefix : string;
 fl : os_file;

  begin
    { get current directory prefix }
    upcase (dir_name);
    slimleft (dir_name);
    slimright (dir_name);
    if length (dir_name) > 0 then
      begin
        os_get_prefix (Prefix);
        Prefix := concat (Prefix, '\', dir_name);
        slimright (Prefix);
        slimleft (Prefix);

        { check to see if the directory exists.
          if the directory does NOT exist the error code 10 will be returned.
        }
        os_reset (fl, Prefix);
        dir_exists := not (os_io_result = 10);
        os_close (fl);

        { if the directory does NOT exist }
        if not dir_exists then
          begin
            { if automatically create directory = true.
              attempt to create the directory.
              return boolean to dir_exists. }
            if auto_create then
              dir_exists := OS_MkDir (Prefix)

            { if automatically create directory = false.
              ask the user if they wish to create it.
              return boolean to dir_exists. }
            else if not auto_create then
              begin
                POP_Ans := PU_Pop_Screen (10, 10, 70, 14, PU_Green, PU_White,
                           Sa, Aa, PU_Btype_2, true, false, true, PU_Popup);
                POP_Ans := PU_Write (27, 11, PU_Red, PU_White,
                                       'DIRECTORY DOES NOT EXIST');
                hdis (40 - (length (Prefix) div 2), 13, Prefix);
                dis (19, 14, 'DO YOU WISH TO CREATE THIS DIRECTORY NOW (Y/N)');
                Q_Ans := 'Y';
                recstr (66, 14, 1, Q_Ans, 0);
                if not ESCKEY then
                  begin
                    upcase (Q_Ans);
                    slimright (Q_Ans);
                    slimleft (Q_Ans);
                    if Q_Ans = 'Y' then
                      begin
                        if OS_MkDir (Prefix) then
                          dir_exists := true
                        else
                          begin
                            dis (18, 14, 'ERROR CREATING SPECIFIED DIRECTORY - PRESS ANY KEY');
                            read (keyboard, ch);
                          end;
                      end
                    else
                      dir_exists := false;
                  end;
                POP_Ans := PU_Pop_Screen (10, 10, 70, 14, PU_Green, PU_White,
                           Sa, Aa, PU_Btype_2, true, false, true, PU_Popdown);
                ESCKEY := false;
              end;
          end;
      end;
  end;
{--------------------}
*)

PROCEDURE BUILDSTR;
VAR
  MAXCOL : INTEGER;
BEGIN
  IF DEVICE='S' THEN MAXCOL:=79 ELSE MAXCOL:=132;
  IF COL>MAXCOL THEN EXIT;
  IF LENGTH(STR)<1 THEN EXIT;
  IF COL+LENGTH(STR)>MAXCOL+1 THEN STR:=COPY(STR,1,MAXCOL+1-COL);
  MOVE (STR[1],PRINTLINE[COL],LENGTH(STR));
END;

PROCEDURE BUILDNEW;
BEGIN
  PRINTLINE:=CONCAT(SPACE30,SPACE30,SPACE30,SPACE30,SPACE12);
  IF DEVICE='S' THEN PRINTLINE:=COPY(PRINTLINE,1,79);
END;

PROCEDURE BUILDLNG;
VAR
  STR : ShortSTRING;{[12]}
BEGIN
  IF LNG<0 THEN LEN:=LEN+1;
  LONGSTR (LNG,STR,'L');
  SLIMRIGHT (STR);
  PADLEFT (STR,LEN);
  BUILDSTR (COL,STR);
END;

PROCEDURE BUILDMTP;
VAR
  STR : ShortSTRING; {[12];  }
BEGIN
  LONGSTR (LNG,STR,'M');
  SLIMRIGHT (STR);
  PADLEFT (STR,LEN);
  BUILDSTR (COL,STR);
END;

PROCEDURE BUILDINT;
VAR
  VAL : ShortSTRING;{[12];}
  NEG : BOOLEAN;
BEGIN
  NEG:=FALSE;
  IF LNG<0 THEN
    BEGIN
      NEG:=TRUE;
      LNG:=0-LNG;
      LEN:=LEN+1;
    END;
  STR (LNG,VAL);
  SLIMRIGHT (VAL);
  IF NEG THEN VAL:=CONCAT (VAL,'-');
  PADLEFT (VAL,LEN);
  BUILDSTR (COL,VAL);
END;

PROCEDURE BUILDTAB;

VAR
   LocalStr : ShortString;
   TempNum  : SmallInt;

BEGIN

  SETDB (DB);
  DBERR;
  TempNum := TabNum;
  IF ISITTABLE (STR,NUM,TempNum) THEN
    BEGIN
      READTABLES (DB,TABNUM,LocalStr);
      DBERR;
      BUILDSTR (COL,COPY(LocalStr,1,LEN));
    END;
END;

PROCEDURE ENDPRINT;
var
  Ret_Value : THandle;

BEGIN

  If device = 'F' then
    Begin
//      writeln ( PRINTFILE );
//      writeln ( PRINTFILE );
//      writeln ( PRINTFILE , 'Kingswood Computing Ltd.');
//      Linecount := Linecount + 3;

      CloseFile (PRINTFILE);
      (* call Report viewing program *)
      If NOT Report_Terminated Then Begin
         if NewRepForm.NewReports.Checked then begin
            RunReport;
         end else begin
                       Ret_Value := ShellExecute ( FMainScreen.Handle, 'open',
                                'c:\kingsacc\wordpad.exe',
                                'c:\KingsAcc\REPORTS\NONAME.RPT',
                                'c:\Kingsacc\REPORTS\',SW_SHOWMAXIMIZED);
                       If ( Ret_Value = 2 ) Or ( Ret_Value = 3 ) Then
                          MessageDlg('Configuration Error', mtInformation,[mbOK], 0);
         end;
      End;
    End
  Else
      Printer.EndDoc;

  LINECOUNT:=0;
END;

PROCEDURE REPMESS;
VAR
  d_File : ShortString;

BEGIN

  (*WINDOWS
  CLEARFROM (24);
  { set mouse click area active }
  km_range (43, 24, 43, 24);
  km_range (45, 24, 45, 24);
  km_range (47, 24, 47, 24);
  DIS (1,24,'SEND OUTPUT TO SCREEN OR PRINTER OR FILE (S/P/F)');
  IF DEVICE='C' THEN DEVICE:='P';
  REPEAT
    RECSTR (50, 24, 1, DEVICE, 0);
    upcase (DEVICE);
    { check for mouse click on active area }
    if ((mouse_info.left_but = down) and (km_in_range (43, 24, 43, 24))) then
      DEVICE := 'S'
    else if ((mouse_info.left_but = down) and (km_in_range (45, 24, 45, 24))) then
      DEVICE := 'P'
    else if ((mouse_info.left_but = down) and (km_in_range (47, 24, 47, 24))) then
      DEVICE := 'F';
    IF ESCKEY THEN
      begin
        exit (REPMESS);
        { set mouse click area active }
        km_kill_range (43, 24, 43, 24);
        km_kill_range (45, 24, 45, 24);
        km_kill_range (47, 24, 47, 24);
      end;
  UNTIL DEVICE[1] IN ['S','P','F'];
  { set mouse click area active }
  km_kill_range (43, 24, 43, 24);
  km_kill_range (45, 24, 45, 24);
  km_kill_range (47, 24, 47, 24);
  CLEARFROM (24);
  *)

  Report_Terminated := false;
  MessageDlg('Company does not exist', mtInformation,[mbOK], 0);

  {
  if MessageBox ( mainhwnd, 'Kingswood DAIRY', 'Generate Report', MB_YESNO) = IDNO then
    begin
      if MessageBox (mainhwnd, 'Terminate Report', 'Stop Printing', MB_OK) = IDOK then;
    end
  else
  }
    device := 'F';

(*
  IF DEVICE='P' THEN
    BEGIN
      PRNT:='PRINTER:';
      IF PRNT <> NULL THEN
        REWRITE (PRINTFILE,PRNT);
      for ascii := 1 to 2 do
       write (printfile, chr (PRN_Init[ascii]));
      for ascii := 1 to 5 do
       write (printfile, chr (PRN_Emul[ascii]));
      for ascii := 1 to 5 do
       write (printfile, chr (PRN_Char[ascii]));
      for ascii := 1 to 10 do
       write (printfile, chr (PRN_Font[ascii]));
      if Ext_Line then
        begin
          if (PRN_Pitch[1] = 1) and (PRN_Pitch[2] = 2) and (PRN_Pitch[3] = 3) and
             (PRN_Pitch[4] = 4) and (PRN_Pitch[5] = 5) and (PRN_Pitch[6] = 6) and
             (PRN_Pitch[7] = 7) and (PRN_Pitch[8] = 8) and (PRN_Pitch[9] = 9) and
             (PRN_Pitch[10] = 10) then
             begin
               write (printfile, chr(27), chr(40), chr(49), chr(68), chr(27),
                                 chr(40), chr(115), chr(48), chr(112), chr(49),
                                 chr(56), chr(104), chr(48), chr(115), chr(51),
                                 chr(98), chr(52), chr(49), chr(48), chr(50),
                                 chr(84));
             end
          else
            for ascii := 1 to 10 do
              write(printfile, chr(PRN_Pitch[ascii])); { set CPI }
        end;
      for ascii := 1 to 10 do
       write (printfile, chr (PRN_Point[ascii]));
      for ascii := 1 to 5 do
       write (printfile, chr (PRN_Left_Margin[ascii]));
      for ascii := 1 to 5 do
       write (printfile, chr (PRN_Right_Margin[ascii]));
      CLOSE   (PRINTFILE, LOCK);
      REWRITE (PRINTFILE, PRNT);
    END
  ELSE
    *)
    if device = 'F' then
      begin
        (*WINDOWS
        { check dir exists }
        chk_dir_exists ('REPORTS', false, dir_ok);
        if not dir_ok then
          begin
            terminate := true;
            exit (repmess);
          end;
        Clearfrom (24);
        repeat
          dis (1, 24, 'ENTER NAME OF DISK FILE (Up to 8 Characters):');
          Recstr (47, 24, 8, Txt_File, 0);
          if Esckey then
            Exit (Repmess);
        until (Txt_File <> space8);
        dis (47, 24, d_File);
        *)

        d_file := 'REPORTS\NONAME.RPT';
        upcase (d_File);
        {$i-}
        AssignFile ( Dos_Txt_File, d_file );
        rewrite (Dos_Txt_File);
        {$i+}
        {
        if ioresult <> 0 then
          if MessageBox (mainhwnd, 'Kingswood DAIRY', 'ERROR OPENING TEXT FILE', MB_OK) = IDOK then;
        }
        (*
        abort ('ERROR OPENING ASCII TEXT FILE');
        CLEARFROM (24);
        *)
      end;
  LINECOUNT:=0;
END;

PROCEDURE REPHEAD;
BEGIN
      REPDASH;
      If Device = 'P' Then
         Printer.Canvas.Font.Style := [fsBold];
      BUILDNEW;
      BUILDSTR (  1,'KINGSWOOD WINDOWS ACCOUNTS');
      BUILDSTR (112,STRDATE);
      BUILDSTR (122,'PAGE');
      BUILDINT (127, PAGE,1);
      SENDLINE (PRINTLINE);
      SENDLINE (NULL);
      BUILDNEW;
      BUILDSTR (  1,CONCAT(Cash1.XCOMPANY,'/',HEAD1,'     ',HEAD2,'     ',HEAD3));
      SENDLINE (PRINTLINE);
      REPDASH;
      If Device = 'P' Then
         Printer.Canvas.Font.Style := [];
END;

PROCEDURE REPDASH;
CONST
  DASH66='------------------------------------------------------------------';
BEGIN

  BUILDNEW;
  IF DEVICE='S' THEN
    BUILDSTR ( 1,UNDLINE)
  ELSE
    BEGIN
      BUILDSTR ( 1,DASH66);
      BUILDSTR (67,DASH66);
    END;
  SENDLINE (PRINTLINE);
  IF ESCKEY THEN EXIT;

END;

PROCEDURE REPLINE;
BEGIN
  SENDLINE (PRINTLINE);
  IF ESCKEY THEN EXIT;
  REPDASH;
  IF ESCKEY THEN EXIT;
  SENDLINE (NULL);
  IF ESCKEY THEN EXIT;
END;

PROCEDURE FILLPAGE;
VAR
   LINE : integer;
BEGIN
  if Device <> 'F' then
    begin
      IF LINECOUNT>0 THEN
        IF DEVICE='S' THEN
          WRITELN (PRINTFILE)
        ELSE
          FOR LINE := LINECOUNT + 1 TO MAXLINES DO
            WRITELN (PRINTFILE);
    end;
  LINECOUNT:=0;
END;

PROCEDURE SENDLINE;
BEGIN
  ESCKEY:=FALSE;
  If Device = 'P' Then
      Begin
          SLIMRIGHT(LINE);
          Printer.Canvas.TextOut(0,(LineHeight*(LineCount-1)),Line);
          LINECOUNT:=LINECOUNT+1;
      End
  Else
     Begin
          Device := 'F';
          WRITELN (PrintFile,LINE);
          LINECOUNT:=LINECOUNT+1;
          IF ((DEVICE = 'S') AND (LINECOUNT >= 17)) OR
             ((DEVICE <> 'S') AND (LINECOUNT >= MAXLINES-2)) THEN
             NEWPAGE := TRUE
          ELSE
             NEWPAGE := FALSE;
     End;
END;

PROCEDURE SKIPLINES(NOLINES: INTEGER);
VAR
   X : INTEGER;
BEGIN
   If NOLINES > 0 Then
     Begin
        FOR X := 1 TO NOLINES DO
            BEGIN
	      SENDLINE (NULL);
	      IF ESCKEY THEN
	         EXIT;
            END;
        LINECOUNT:=LINECOUNT+NOLINES;
     End;
END;

PROCEDURE EXPANDON;
BEGIN
  {
  IF DEVICE='P' THEN
    FOR ASCII:=1 TO 4 DO WRITE (PRINTFILE,CHR(PLINEASCII[2][ASCII]));
  }
END;

PROCEDURE EXPANDOFF;
BEGIN
  {
  IF DEVICE='P' THEN
    FOR ASCII:=5 TO 8 DO WRITE (PRINTFILE,CHR(PLINEASCII[2][ASCII]));
  }
END;


Begin
{-----------------------------  INITIALIZATION  ------------------------------}


{-------------------------------  TERMINATION  -------------------------------}

End.

