{

  File	    : U-DB:DBGEN.TEXT
  Unit	    : DB_GENERAL
  Prefix    :
  Status    : Finished

  DATE'S
  Started   : 16-04-92
  Modified  : 8-Feburary-1995

  This unit is the database general routines
}


Unit DBGen;

{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface

Uses
    TYPES, classes, Accsdata ;


{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

PROCEDURE DBAUDIT;
PROCEDURE OPENERR;
PROCEDURE OPENFILE (DB: INTEGER; FILENAME: STRING);
Function OpenAll : Boolean;
Procedure CloseAll(Range:Integer);
PROCEDURE GETSTR (DB,NUM,LEN: INTEGER; VAR STR: ShortSTRING );
PROCEDURE GETSML (DB,NUM,LEN: INTEGER; VAR STR: STRING132	 );
PROCEDURE GETINT (DB,NUM    : INTEGER; VAR INT: INTEGER	 );
PROCEDURE GETLNG (DB,NUM    : INTEGER; VAR LNG: LONG	 );
PROCEDURE GETSHT (DB,NUM    : INTEGER; VAR LNG: SHORTLONG);
PROCEDURE PUTSTR (DB: INTEGER; STR: ShortSTRING; NUM: INTEGER);
PROCEDURE PUTINT (DB: INTEGER;		INT,NUM: INTEGER);
PROCEDURE PUTLNG (DB: INTEGER; LNG: LONG;   NUM: INTEGER);
PROCEDURE DBFULL;
Function ExcludeNominal ( AccountNo : Integer; const AExcludePrivateIncExp : Boolean = True) : Boolean;
Function GetAccountName ( DataBase, RecNo, Item : Integer ) : String;
Function GetSLPLAccountName ( DataBase, RecNo : Integer ) : String;
Function SLPLAccountExists (const ADataBase : Integer; const AAccountName : string) : Boolean;
Function GetEntRanges ( EntCode : String ) : TAccRange;
Function CheckEnt ( EntCode : ShortString; Var RecNo : Integer ) : Boolean;
Function ChangeToLong ( Var StrLong : ShortString ) : Boolean;
Procedure InitRange ( Var AccRange : TAccRange );
Function CheckCustSupp ( Database : Integer; CustSuppCode : String ) : Boolean;
Function CheckEditStatus : Boolean;

//function GetBankBalance(const ABankName : string) : Double;
//procedure EnumBanks(AStrings : TStrings);

{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation

Uses
  {FILEIO,
  POPUP2,
  DOS_ACCESS,
  CALLDOS,
  SCREENOPS,
  DATASEGM,
  COMMANDIO,
  }
  Dialogs,
  VARS,
  PARAMS,
  CLEARS,
  ABORTPRG,
  CALCS,
  DefSecFl,
  UTIL,
  FILED,
  DBCORE,
  SysUtils;

{-------------------------	   VARIABLES	      ------------------------}
{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

PROCEDURE DBAUDIT;
BEGIN
  errorno := 8;		{ set error number }
  dberr;		{ check for error }
END;

PROCEDURE OPENERR;

BEGIN
  errorno := 14;
  dberr;
END;

PROCEDURE OPENFILE;
VAR
  PATHNAME : STRING;
BEGIN
  DATAOPEN:=TRUE;
  If Pos ( ':',Cash2.xdirectory ) = 0 Then
     PATHNAME := SubDir + Cash2.XDIRECTORY + FILENAME
  Else
      PathName := Cash2.xdirectory + filename;

  IF POS('.',PATHNAME)=0 THEN PATHNAME:=CONCAT(PATHNAME,'.',SUFFIX);
  REPEAT
    OPENDB (DB,PATHNAME,TRUE);
    IF ERRORNO > 0 THEN
      BEGIN
	DB1.DBNAME := FILENAME;
	OPENERR;
      END;
  UNTIL ERRORNO=0;
END;

Function OpenAll : Boolean;
Begin
     CloseAll ( MaxDatabases );
{-->>     OpenAll := False;}
  //   OpenFile ( EntFile, Cash2.xentfile );
  //   OpenFile ( TxFile, Cash2.xtransfile );
  //   OpenFile ( NlFile, Cash2.xnlaccfile );


     { Only Open if Ledger Version }

     {
     If NOT Cash1.XCashBook Then
        Begin
     }
     //       OpenFile ( SlFile, Cash2.xslaccfile );
     //       OpenFile ( PlFile, Cash2.xplaccfile );
     //   End;

  {   If Cash11.xAnl_File = '' Then
        Cash11.xAnl_File := 'anl_file';
     OpenFile ( AnalFile, Cash11.xAnl_File ); } // TGM AB Removed

     // TGM AB Open DB's
      Accsdatamodule.NLFileDB.open;

   //   If Not Cash1.XCashBook Then
   //     Begin
        Accsdatamodule.SLFileDB.open;
        Accsdatamodule.PLFileDB.open;
   //     end;

      Accsdatamodule.TransactionsDB.open;
      Accsdatamodule.EntsFileDB.open;
      Accsdatamodule.AnalysisDB.open;


     OpenAll := ( ErrorNo = 0 );
End;

Procedure CloseAll(Range:Integer);
Var
   x : Integer;
Begin
     { Close Selected files up to range }
     For x := 1 To Range Do
         CClose ( x, 'N' );
     Accsdatamodule.NLFileDB.close;
     Accsdatamodule.SLFileDB.close;
     Accsdatamodule.PLFileDB.close;
     Accsdatamodule.TransactionsDB.close;
     Accsdatamodule.EntsFileDB.close;
     Accsdatamodule.AnalysisDB.close;
End;

PROCEDURE GETSTR;
BEGIN
  ERRORNO:=0;
  IF DB<>CURRDB THEN SETDB (DB);
  DBERR;
  GETITEM (DB,NUM);
  DBERR;
  MOVE (CURRDISP[1],STR[1],LEN);
  if Slim_on_Left then	   { if globol variable is true then call slimleft }
    SLIMLEFT (STR);
  WHILE LENGTH(STR)<LEN DO STR:=CONCAT(STR,SPACE1);
END;

PROCEDURE GETSML;
VAR
  INT : INTEGER;
BEGIN
  ERRORNO:=0;
  IF DB<>CURRDB THEN SETDB (DB);
  DBERR;
  GETITEM (DB,NUM);
  DBERR;
  INT:=CURRINT;
  SMALLSTR (INT,STR);
END;

PROCEDURE GETINT;
BEGIN
  ERRORNO:=0;
  IF DB<>CURRDB THEN SETDB (DB);
  DBERR;
  GETITEM (DB,NUM);
  DBERR;
  INT:=CURRINT;
END;

PROCEDURE GETLNG;
BEGIN
  ERRORNO:=0;
  IF DB<>CURRDB THEN SETDB (DB);
  DBERR;
  GETITEM (DB,NUM);
  DBERR;
  LNG:=CURRLONG;
END;

PROCEDURE GETSHT;
BEGIN
  ERRORNO:=0;
  IF DB<>CURRDB THEN SETDB (DB);
  DBERR;
  GETITEM (DB,NUM);
  DBERR;
  LNG:=CURRLONG;
END;

PROCEDURE PUTSTR;
VAR
  WORKSTR : STRING;
BEGIN
  ERRORNO:=0;
  WORKSTR:=CONCAT (SPACE30,SPACE30,SPACE4);
  MOVE (WORKSTR[1],CURRDISP[1],MAXISIZE);
  IF LENGTH (STR) > 0 THEN
    MOVE (STR[1],CURRDISP[1],LENGTH(STR));
  // TG AB Fix probs with paradox which makes make currstr = currdisp
  currstr := '';
  IF DB <> CURRDB THEN
    SETDB (DB);
  PUTITEM (DB,NUM);
  DBERR;
END;

PROCEDURE PUTINT;
BEGIN
  ERRORNO:=0;
  CURRINT:=INT;
  IF DB<>CURRDB THEN SETDB (DB);
  PUTITEM (DB,NUM);
  DBERR;
END;

PROCEDURE PUTLNG;
BEGIN
  ERRORNO:=0;
  CURRLONG:=LNG;
  IF DB<>CURRDB THEN SETDB (DB);
  PUTITEM (DB,NUM);
  DBERR;
END;

PROCEDURE DBFULL;
BEGIN
  errorno := 6;
  dberr;
END;


Function ExcludeNominal ( AccountNo : Integer;
   const AExcludePrivateIncExp : Boolean) : Boolean;
Begin
  ExcludeNominal := False;

  if (AExcludePrivateIncExp ) then // 01/02/2011 SP - Private inc/exp accounts to be included in the budget - GL
     begin
        If ((( AccountNo > Cash1.xnomprvinc+Cash11.xno_of_partners ) And
             ( AccountNo < Cash1.xnomprvexp )) Or
            (( AccountNo > Cash1.xnomprvexp+Cash11.xno_of_partners ) And
             ( AccountNo < Cash1.xnomtax )) Or

            (( AccountNo > Cash1.xnomprofit+Cash11.xno_of_partners ) And
             ( AccountNo < Cash1.xnomopen )) Or
             ( AccountNo > Cash1.xnomopen+Cash11.xno_of_partners )) Then
          ExcludeNominal := True;
     end
  else
     begin
        if ((( AccountNo > Cash1.xnomprofit+Cash11.xno_of_partners ) And
             ( AccountNo < Cash1.xnomopen )) Or
             ( AccountNo > Cash1.xnomopen+Cash11.xno_of_partners )) Then
            ExcludeNominal := True;
     end;
End;

Function GetAccountName ( DataBase, RecNo, Item : Integer ) : String;
Begin
     GetAccountName := '';
 //    If (NOT Cash1.xCashBook) Or (Database = NLFILE) Or
 //       (NOT Cash11.Xuse_enterprise ) Then
 // TGM AB 24/07/02 changed these 2 lines to allow listing of customers in Cashbook with No Enterprise
       If ((NOT Cash1.xCashBook) Or (Database = NLFILE) Or (Database = SLFILE) Or (Database = PLFILE) Or
          (NOT Cash11.Xuse_enterprise )) Then
        Begin
                SetDb ( DataBase );
                If ( RecNo >= 1 ) And ( RecNo <= db1.dbrechigh ) Then
                    Begin
                    ReadRec ( DataBase, RecNo );
                    dberr;
                    GetItem ( DataBase, Item );
                    GetAccountName := CurrStr;
                    End;
        End;
 End;

Function GetSLPLAccountName ( DataBase, RecNo : Integer ) : String;
Begin
     result := '';

     if database = SLFile then begin
             if accsdatamodule.SLFileDB.locate('SLNo',RecNo,[]) then Result := vartostr(accsdatamodule.SLFileDB['Name']);
     end else
             begin
             if accsdatamodule.PLFileDB.locate('PLNo',RecNo,[]) then Result := vartostr(accsdatamodule.PLFileDB['Name']);
             end;

End;

function SLPLAccountExists(
   const ADataBase : Integer;
   const AAccountName : string) : Boolean;
begin
   Result := False;
   if Length(Trim(AAccountName)) = 0 then Exit;

   if ADataBase = SLFile then
      Result := accsdatamodule.SLFileDB.locate('Name',AAccountName,[])
   else
      Result := accsdatamodule.PLFileDB.locate('Name',AAccountName,[]);
end;

Function GetEntRanges ( EntCode : String ) : TAccRange;
Var
   RecNo,
   x        : Integer;
   AccRange : TAccRange;
Begin
     For x := 1 To MAXACCRANGE Do
         AccRange[x] := 0;

     If CheckEnt ( EntCode, RecNo ) Then
        Begin
             If ( RecNo > 0 ) Then
                Begin
                     SetDb ( EntFile );
                     ReadRec ( EntFile, RecNo );
                     dberr;
                     If RecActive ( EntFile ) Then
                        Begin
                             GetInt ( EntFile, 6, AccRange[1] );
                             GetInt ( EntFile, 7, AccRange[2] );
                             GetInt ( EntFile, 8, AccRange[3] );
                             GetInt ( EntFile, 9, AccRange[4] );
                        End;
                End;
        End;
     GetEntRanges := AccRange;
End;

Function CheckEnt ( EntCode : ShortString; Var RecNo : Integer ) : Boolean;
Var
   LastEnt,
   EntRecord : Integer;
Begin
     CheckEnt := False;
{-->>     EntRecord := 0;}
     EntRecord := 1;
     RecNo     := 0;
     SetDb ( EntFile );
     LastEnt := db1.dbrechigh;
     SlimAll ( EntCode );
     { Only Check if Ent Code Entered into Grid }
     If Length ( EntCode ) > 0 Then
        Begin
             While ( EntRecord <= LastEnt ) Do
                   Begin
                        ReadRec ( EntFile, EntRecord );
                        dberr;
                        If RecActive ( EntFile ) Then
                           Begin
                                Getitem ( EntFile, 1 );
                                If CurrStr = EntCode Then
                                   Begin
                                        CheckEnt := True;
                                        RecNo := EntRecord;
                                        EntRecord := LastEnt;
                                   End;
                           End;
                        Inc ( EntRecord );
                   End;
        End
     Else
         CheckEnt := True;
End;

Function ChangeToLong ( Var StrLong : ShortString ) : Boolean;
Var
   TempLong : Long;
Begin
     ChangeToLong := False;
     SlimAll ( StrLong );
     If Length ( StrLong ) > 0 Then
        Begin
             If IsItLong ( StrLong, 'L', TempLong ) Then
                Begin
                     LongStr ( TempLong, StrLong, 'L' );
                     ChangeToLong := True;
                End;
        End
     Else
         ChangeToLong := True;
End;

Procedure InitRange ( Var AccRange : TAccRange );
Var
   X : Integer;
Begin
     For X := 1 To MAXACCRANGE Do
         AccRange[X] := 0;
End;

Function CheckCustSupp ( Database : Integer; CustSuppCode : String ) : Boolean;
Var
   RecNo : Integer;
Begin
     CheckCustSupp := False;
     If Numeric ( CustSuppCode ) Then
        If Length ( CustSuppCode ) > 0 Then
           Begin
              RecNo := StrToInt ( CustSuppCode );
              SetDb ( Database );
              If ( RecNo > 0 ) And ( RecNo <= db1.dbrechigh ) Then
                 Begin
                   ReadRec ( Database, Recno );
                   dberr;
                   CheckCustSupp := ( RecActive ( Database ));
                 End;
           End;
End;

Function CheckEditStatus;
Var
  EDIT_STAT : STRING{[1]};

begin
  EDIT_STAT := SPACE1;
  GETITEM (Txfile, 28);
  EDIT_STAT[1] := CURRDISP[1];
  CheckEditStatus := NOT ( EDIT_STAT[1] IN ['E','R'] );
end;

{function GetBankBalance(const ABankName : string) : Double;
Var
   ArrPos,
   NomRec : Integer;
   AccountRanges  : TAccRange;
begin
   Result := 0;
   AccountRanges[1] := Cash1.xBankMin;
   AccountRanges[2] := Cash1.xBankMax;
   ArrPos := 1;
   NomRec := AccountRanges[1];
   SetDb ( NlFile );
   Repeat
         ReadRec ( NlFile, NomRec );
         dberr;
         If Recactive ( NlFile ) And ( NOT ExcludeNominal ( NomRec )) Then
            Begin
                 GetItem ( NlFile, 1 );
                 if CurrStr = ABankName then
                    begin
                       GetItem ( NlFile, 2 );
                       LongStr ( CurrLong, CurrStr, 'L' );

                       Result := StrToFloat(CurrStr);
                       Break;
                    end;
                 Inc ( ArrPos );
            End;
         Inc ( NomRec );
   until ( NomRec > AccountRanges[2] ) Or ( NomRec = 0 );
   Dec ( ArrPos );

begin

   Result := 0;

   with TQuery.Create(nil) do
      try
         DatabaseName := Sess

      finally
         Free;
      end;

end;
 }
 {
procedure EnumBanks(AStrings : TStrings);
Var
   ArrPos,
   NomRec : Integer;
   AccountRanges  : TAccRange;
begin
   AStrings.Clear;
   AccountRanges[1] := Cash1.xBankMin;
   AccountRanges[2] := Cash1.xBankMax;
   ArrPos := 1;
   NomRec := AccountRanges[1];
   SetDb ( NlFile );
   Repeat
         ReadRec ( NlFile, NomRec );
         dberr;
         If Recactive ( NlFile ) And ( NOT ExcludeNominal ( NomRec )) Then
            Begin
               GetItem ( NlFile, 1 );
               if AStrings.IndexOf(CurrStr) = -1 then
                  AStrings.AddObject(CurrStr, pointer(NomRec));
               Inc ( ArrPos );
            End;
         Inc ( NomRec );
   until ( NomRec > AccountRanges[2] ) Or ( NomRec = 0 );
   Dec ( ArrPos );
end;
  }

Begin
{-----------------------------	INITIALIZATION	------------------------------}


{-------------------------------  TERMINATION  -------------------------------}


End.

