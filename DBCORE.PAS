{

  File	    : U-DB:DBCORE.TEXT
  Unit	    : DB_CORE_ROUTINES
  Prefix    :
  Status    : Finished

  DATE'S
  Started   : 16-04-92
  Finished  : 16-04-92

  this unit contains the core routines of the database general

  05/12/17 [V4.2 R9.4] /MK Bug Fix - GETITEM - EntsFile - JobCardEnabled - Added try except here just in case field is null.
}

Unit DBCore;

{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface

Uses
  SysUtils,
  Dialogs,
  db,
  TYPES;

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

PROCEDURE SETDB	 (DB: INTEGER);
PROCEDURE SAVEDB (DB: INTEGER);
PROCEDURE READTABLES (DB,TABREC: INTEGER; VAR TABLEDESC: ShortSTRING);    //TGM AB Updated
PROCEDURE WRITETABLES (DB,TABREC: INTEGER; TABLEDESC: ShortSTRING);       //TGM AB Updated
PROCEDURE GETITEM (DB,ITEMNO: INTEGER);
PROCEDURE READREC (DB,RECNO: INTEGER);
PROCEDURE PUTITEM (DB,ITEMNO: INTEGER);
FUNCTION  RECACTIVE  (DB: INTEGER): BOOLEAN;
PROCEDURE CLOSEDB    (DB: INTEGER);
PROCEDURE BLANKREC   (DB: INTEGER; ADDDEL: CHAR);
PROCEDURE SETITEM;
Function PSysLongToDelphi ( ValArray : Array Of Char ) : LongInt;
Procedure DelphiLongToPSys ( LongNo : LongInt; Var ValArray : Array Of Char );
Function GetNextFreeAccount ( SearchDb : Integer; AccRange : TAccRange ) : Integer;
Function KStrToInt ( StrToChange : ShortString ) : Integer;
Procedure UpdateDataBaseDefaults;
Function PadString (TestStr : string; requiredlength : integer) : String;


{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation

Uses
  {FILEIO,
  DOS_ACCESS,
  SCREENOPS,
  DATASEGM,
  COMMANDIO,
  }
  UTIL,
  VARS,
  PARAMS,
  CLEARS,
  ABORTPrg,
  CALCS,
  FILED,
  ACCSDATA,
  langunit;


{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

Function PadString (TestStr : string; requiredlength : integer) : String;
begin
   result := '';
   while length(TestStr) < requiredlength do begin
         Teststr := ' ' + Teststr;
   end;
   result := TestStr;
end;

PROCEDURE SETDB;
VAR
  OK : BOOLEAN;
  ST : STRING{[1]};
BEGIN

  ERRORNO:=0;

//  If DB=CURRDB then Exit;

  IF NOT (DB IN [1..MaxDatabases]) THEN
    BEGIN
      ERRORNO:=11;
      EXIT;
    END;

  // TGM AB Code added to handle Paradox DB's
  case DB of
       NewTxfile : begin

                //   accsdatamodule.TransactionsDB.open;
                   db1.DBRECHIGH := accsdatamodule.TransactionsDB.RecordCount;
                   db1.dbrectot := db1.DBRECHIGH;
                   db1.dbrectot := db1.DBRECHIGH;

                   If DB=CURRDB then Exit;
                   CURRDB:=DB;

                   DB1.DBITEMS[1].DBINAME := 'TX-TYPE';      // These values correspond to original database
                   DB1.DBITEMS[1].DBITYPE[0] := 'N';      // and not to longer / extra fields in paradox db's
                   DB1.DBITEMS[1].DBISIZE := 4;
                   DB1.DBITEMS[2].DBINAME := 'DATE';
                   DB1.DBITEMS[2].DBITYPE[0] := 'D';
                   DB1.DBITEMS[2].DBISIZE := 8;
                   DB1.DBITEMS[3].DBINAME := 'ACCOUNT';
                   DB1.DBITEMS[3].DBITYPE[0] := 'N';
                   DB1.DBITEMS[3].DBISIZE := 4;
                   DB1.DBITEMS[4].DBINAME := 'REFERENCE';
                   DB1.DBITEMS[4].DBITYPE[0] := 'X';
                   DB1.DBITEMS[4].DBISIZE := 8;
                   DB1.DBITEMS[5].DBINAME := 'DESCRIPT';
                   DB1.DBITEMS[5].DBITYPE[0] := 'X';
                   DB1.DBITEMS[5].DBISIZE := 15;
                   DB1.DBITEMS[6].DBINAME := 'QUANTITY';
                   DB1.DBITEMS[6].DBITYPE[0] := 'L';
                   DB1.DBITEMS[6].DBISIZE := 14;
                   DB1.DBITEMS[7].DBINAME := 'PRODUCT';
                   DB1.DBITEMS[7].DBITYPE[0] := 'N';
                   DB1.DBITEMS[7].DBISIZE := 4;
                   DB1.DBITEMS[8].DBINAME := 'NOMINAL';
                   DB1.DBITEMS[8].DBITYPE[0] := 'N';
                   DB1.DBITEMS[8].DBISIZE := 4;
                   DB1.DBITEMS[9].DBINAME := 'AMOUNT';
                   DB1.DBITEMS[9].DBITYPE[0] := 'L';
                   DB1.DBITEMS[9].DBISIZE := 14;
                   DB1.DBITEMS[10].DBINAME := 'TAX-CODE';
                   DB1.DBITEMS[10].DBITYPE[0] := 'X';
                   DB1.DBITEMS[10].DBISIZE := 1;
                   DB1.DBITEMS[11].DBINAME := 'TAX/DISC';
                   DB1.DBITEMS[11].DBITYPE[0] := 'L';
                   DB1.DBITEMS[11].DBISIZE := 14;
                   DB1.DBITEMS[12].DBINAME := 'ANALYSIS';
                   DB1.DBITEMS[12].DBITYPE[0] := 'N';
                   DB1.DBITEMS[12].DBISIZE := 4;
                   DB1.DBITEMS[13].DBINAME := 'NEXT-DB';
                   DB1.DBITEMS[13].DBITYPE[0] := 'Y';
                   DB1.DBITEMS[13].DBISIZE := 5;
                   DB1.DBITEMS[14].DBINAME := 'NEXT-CR';
                   DB1.DBITEMS[14].DBITYPE[0] := 'Y';
                   DB1.DBITEMS[14].DBISIZE := 5;
                   DB1.DBITEMS[16].DBINAME := 'NEXT-S/P';
                   DB1.DBITEMS[16].DBITYPE[0] := 'Y';
                   DB1.DBITEMS[16].DBISIZE := 5;
                   DB1.DBITEMS[17].DBINAME := 'NOM-AMOUNT';
                   DB1.DBITEMS[17].DBITYPE[0] := 'L';
                   DB1.DBITEMS[17].DBISIZE := 14;
                   DB1.DBITEMS[18].DBINAME := 'DEBIT-AC';
                   DB1.DBITEMS[18].DBITYPE[0] := 'N';
                   DB1.DBITEMS[18].DBISIZE := 4;
                   DB1.DBITEMS[19].DBINAME := 'CREDIT-AC';
                   DB1.DBITEMS[19].DBITYPE[0] := 'N';
                   DB1.DBITEMS[19].DBISIZE := 4;
                   DB1.DBITEMS[23].DBINAME := 'ORIG-TYPE';
                   DB1.DBITEMS[23].DBITYPE[0] := 'N';
                   DB1.DBITEMS[23].DBISIZE := 4;
                   DB1.DBITEMS[24].DBINAME := 'ENTERPRISE';
                   DB1.DBITEMS[24].DBITYPE[0] := 'X';
                   DB1.DBITEMS[24].DBISIZE := 4;
                   DB1.DBITEMS[26].DBINAME := 'STUB-NO';
                   DB1.DBITEMS[26].DBITYPE[0] := 'Y';
                   DB1.DBITEMS[26].DBISIZE := 8;
                   DB1.DBITEMS[27].DBINAME := 'BANK-REC';
                   DB1.DBITEMS[27].DBITYPE[0] := 'X';
                   DB1.DBITEMS[27].DBISIZE := 1;
                   DB1.DBITEMS[28].DBINAME := 'EDIT-STAT';
                   DB1.DBITEMS[28].DBITYPE[0] := 'X';
                   DB1.DBITEMS[28].DBISIZE := 1;
                   DB1.DBITEMS[29].DBINAME := 'AMT-PAID';
                   DB1.DBITEMS[29].DBITYPE[0] := 'L';
                   DB1.DBITEMS[29].DBISIZE := 14;
                   DB1.DBITEMS[30].DBINAME := 'ALLOCATED';
                   DB1.DBITEMS[30].DBITYPE[0] := 'X';
                   DB1.DBITEMS[30].DBISIZE := 1;
                   DB1.DBITEMS[31].DBINAME := 'DUE-DATE';
                   DB1.DBITEMS[31].DBITYPE[0] := 'D';
                   DB1.DBITEMS[31].DBISIZE := 8;

                   end;
       EntFile : begin
             //      If DB=CURRDB then Exit;
                   CURRDB:=DB;
                //   accsdatamodule.EntsFileDB.open;
                   updatedatabasedefaults;
                   db1.DBRECHIGH := EntsUsed;
                   db1.dbrectot := 100;
                   //db1.dbrectot := EntsMax;
                   end;
       AnalFile : begin
                   db1.DBRECHIGH := accsdatamodule.AnalysisDB.RecordCount;
                   db1.dbrectot := db1.DBRECHIGH;
                   If DB=CURRDB then Exit;
                   CURRDB:=DB;
                   end;
       SLFile : begin
                //   if DB=CURRDB then exit;
                   CURRDB := DB;
                //   accsdatamodule.SLFileDB.open;
                   updatedatabasedefaults;
                   db1.DBRECHIGH := SLUsed;
                   db1.dbrectot := SLUsed + 1;
                   DB1.DBITEMS[1].DBINAME := 'NAME';      // These values correspond to original database
                   DB1.DBITEMS[1].DBITYPE[0] := 'X';      // and not to longer / extra fields in paradox db's
                   DB1.DBITEMS[1].DBISIZE := 30;
                   DB1.DBITEMS[2].DBINAME := 'ADDRESS1';
                   DB1.DBITEMS[2].DBITYPE[0] := 'X';
                   DB1.DBITEMS[2].DBISIZE := 30;
                   DB1.DBITEMS[3].DBINAME := 'ADDRESS2';
                   DB1.DBITEMS[3].DBITYPE[0] := 'X';
                   DB1.DBITEMS[3].DBISIZE := 25;
                   DB1.DBITEMS[4].DBINAME := 'ADDRESS3';
                   DB1.DBITEMS[4].DBITYPE[0] := 'X';
                   DB1.DBITEMS[4].DBISIZE := 25;
                   DB1.DBITEMS[5].DBINAME := 'ADDRESS4';
                   DB1.DBITEMS[5].DBITYPE[0] := 'X';
                   DB1.DBITEMS[5].DBISIZE := 25;
                   DB1.DBITEMS[6].DBINAME := 'BALANCE-BF';
                   DB1.DBITEMS[6].DBITYPE[0] := 'L';
                   DB1.DBITEMS[6].DBISIZE := 14;
                   DB1.DBITEMS[7].DBINAME := 'BALANCE';
                   DB1.DBITEMS[7].DBITYPE[0] := 'L';
                   DB1.DBITEMS[7].DBISIZE := 14;
                   DB1.DBITEMS[8].DBINAME := 'TURNOVER';
                   DB1.DBITEMS[8].DBITYPE[0] := 'L';
                   DB1.DBITEMS[8].DBISIZE := 14;
                   DB1.DBITEMS[9].DBINAME := 'AGE-CURR';
                   DB1.DBITEMS[9].DBITYPE[0] := 'L';
                   DB1.DBITEMS[9].DBISIZE := 14;
                   DB1.DBITEMS[10].DBINAME := 'AGE-1';
                   DB1.DBITEMS[10].DBITYPE[0] := 'L';
                   DB1.DBITEMS[10].DBISIZE := 14;
                   DB1.DBITEMS[11].DBINAME := 'AGE-2';
                   DB1.DBITEMS[11].DBITYPE[0] := 'L';
                   DB1.DBITEMS[11].DBISIZE := 14;
                   DB1.DBITEMS[12].DBINAME := 'AGE-3';
                   DB1.DBITEMS[12].DBITYPE[0] := 'L';
                   DB1.DBITEMS[12].DBISIZE := 14;
                   DB1.DBITEMS[13].DBINAME := 'NOT-ALLOC';
                   DB1.DBITEMS[13].DBITYPE[0] := 'L';
                   DB1.DBITEMS[13].DBISIZE := 14;
                   DB1.DBITEMS[14].DBINAME := 'FIRST-YEAR';
                   DB1.DBITEMS[14].DBITYPE[0] := 'Y';
                   DB1.DBITEMS[14].DBISIZE := 5;
                   DB1.DBITEMS[15].DBINAME := 'FIRST-TX';
                   DB1.DBITEMS[15].DBITYPE[0] := 'Y';
                   DB1.DBITEMS[15].DBISIZE := 5;
                   DB1.DBITEMS[16].DBINAME := 'LAST-TX';
                   DB1.DBITEMS[16].DBITYPE[0] := 'Y';
                   DB1.DBITEMS[16].DBISIZE := 5;
                   DB1.DBITEMS[17].DBINAME := 'BALANCE-ST';
                   DB1.DBITEMS[17].DBITYPE[0] := 'L';
                   DB1.DBITEMS[17].DBISIZE := 14;
                   DB1.DBITEMS[18].DBINAME := 'PAY-DATE';
                   DB1.DBITEMS[18].DBITYPE[0] := 'D';
                   DB1.DBITEMS[18].DBISIZE := 8;
                   DB1.DBITEMS[19].DBINAME := 'PHONE-NO1';
                   DB1.DBITEMS[19].DBITYPE[0] := 'X';
                   DB1.DBITEMS[19].DBISIZE := 20;
                   DB1.DBITEMS[20].DBINAME := 'PHONE-NO2';
                   DB1.DBITEMS[20].DBITYPE[0] := 'X';
                   DB1.DBITEMS[20].DBISIZE := 20;
                   DB1.DBITEMS[21].DBINAME := 'FAX-NO';
                   DB1.DBITEMS[21].DBITYPE[0] := 'X';
                   DB1.DBITEMS[21].DBISIZE := 20;
                   DB1.DBITEMS[22].DBINAME := 'AREA-CODE';
                   DB1.DBITEMS[22].DBITYPE[0] := 'N';
                   DB1.DBITEMS[22].DBISIZE := 4;
                   DB1.DBITEMS[23].DBINAME := 'POST-CODE';
                   DB1.DBITEMS[23].DBITYPE[0] := 'X';
                   DB1.DBITEMS[23].DBISIZE := 20;
                   DB1.DBITEMS[24].DBINAME := 'CUST-REF';
                   DB1.DBITEMS[24].DBITYPE[0] := 'X';
                   DB1.DBITEMS[24].DBISIZE := 20;
                   DB1.DBITEMS[25].DBINAME := 'CONTACT1';
                   DB1.DBITEMS[25].DBITYPE[0] := 'X';
                   DB1.DBITEMS[25].DBISIZE := 20;
                   DB1.DBITEMS[26].DBINAME := 'CONTACT2';
                   DB1.DBITEMS[26].DBITYPE[0] := 'X';
                   DB1.DBITEMS[26].DBISIZE := 20;
                   DB1.DBITEMS[27].DBINAME := 'VAT-NO';
                   DB1.DBITEMS[27].DBITYPE[0] := 'X';
                   DB1.DBITEMS[27].DBISIZE := 20;
                   DB1.DBITEMS[28].DBINAME := 'COMMENT1';
                   DB1.DBITEMS[28].DBITYPE[0] := 'X';
                   DB1.DBITEMS[28].DBISIZE := 25;
                   DB1.DBITEMS[29].DBINAME := 'COMMENT2';
                   DB1.DBITEMS[29].DBITYPE[0] := 'X';
                   DB1.DBITEMS[29].DBISIZE := 25;
                   DB1.DBITEMS[30].DBINAME := 'COMMENT3';
                   DB1.DBITEMS[30].DBITYPE[0] := 'X';
                   DB1.DBITEMS[30].DBISIZE := 25;
                   end;
       PLFile : begin
                //   if DB=CURRDB then exit;
                   CURRDB := DB;
                //   accsdatamodule.PLFileDB.open;
                   updatedatabasedefaults;
                   db1.DBRECHIGH := PLUsed;
                   db1.dbrectot := PLUsed + 1;
                   DB1.DBITEMS[1].DBINAME := 'NAME';      // These values correspond to original database
                   DB1.DBITEMS[1].DBITYPE[0] := 'X';      // and not to longer / extra fields in paradox db's
                   DB1.DBITEMS[1].DBISIZE := 30;
                   DB1.DBITEMS[2].DBINAME := 'ADDRESS1';
                   DB1.DBITEMS[2].DBITYPE[0] := 'X';
                   DB1.DBITEMS[2].DBISIZE := 30;
                   DB1.DBITEMS[3].DBINAME := 'ADDRESS2';
                   DB1.DBITEMS[3].DBITYPE[0] := 'X';
                   DB1.DBITEMS[3].DBISIZE := 25;
                   DB1.DBITEMS[4].DBINAME := 'ADDRESS3';
                   DB1.DBITEMS[4].DBITYPE[0] := 'X';
                   DB1.DBITEMS[4].DBISIZE := 25;
                   DB1.DBITEMS[5].DBINAME := 'ADDRESS4';
                   DB1.DBITEMS[5].DBITYPE[0] := 'X';
                   DB1.DBITEMS[5].DBISIZE := 25;
                   DB1.DBITEMS[6].DBINAME := 'BALANCE-BF';
                   DB1.DBITEMS[6].DBITYPE[0] := 'L';
                   DB1.DBITEMS[6].DBISIZE := 14;
                   DB1.DBITEMS[7].DBINAME := 'BALANCE';
                   DB1.DBITEMS[7].DBITYPE[0] := 'L';
                   DB1.DBITEMS[7].DBISIZE := 14;
                   DB1.DBITEMS[8].DBINAME := 'TURNOVER';
                   DB1.DBITEMS[8].DBITYPE[0] := 'L';
                   DB1.DBITEMS[8].DBISIZE := 14;
                   DB1.DBITEMS[9].DBINAME := 'AGE-CURR';
                   DB1.DBITEMS[9].DBITYPE[0] := 'L';
                   DB1.DBITEMS[9].DBISIZE := 14;
                   DB1.DBITEMS[10].DBINAME := 'AGE-1';
                   DB1.DBITEMS[10].DBITYPE[0] := 'L';
                   DB1.DBITEMS[10].DBISIZE := 14;
                   DB1.DBITEMS[11].DBINAME := 'AGE-2';
                   DB1.DBITEMS[11].DBITYPE[0] := 'L';
                   DB1.DBITEMS[11].DBISIZE := 14;
                   DB1.DBITEMS[12].DBINAME := 'AGE-3';
                   DB1.DBITEMS[12].DBITYPE[0] := 'L';
                   DB1.DBITEMS[12].DBISIZE := 14;
                   DB1.DBITEMS[13].DBINAME := 'NOT-ALLOC';
                   DB1.DBITEMS[13].DBITYPE[0] := 'L';
                   DB1.DBITEMS[13].DBISIZE := 14;
                   DB1.DBITEMS[14].DBINAME := 'FIRST-YEAR';
                   DB1.DBITEMS[14].DBITYPE[0] := 'Y';
                   DB1.DBITEMS[14].DBISIZE := 5;
                   DB1.DBITEMS[15].DBINAME := 'FIRST-TX';
                   DB1.DBITEMS[15].DBITYPE[0] := 'Y';
                   DB1.DBITEMS[15].DBISIZE := 5;
                   DB1.DBITEMS[16].DBINAME := 'LAST-TX';
                   DB1.DBITEMS[16].DBITYPE[0] := 'Y';
                   DB1.DBITEMS[16].DBISIZE := 5;
                   DB1.DBITEMS[17].DBINAME := 'BALANCE-ST';
                   DB1.DBITEMS[17].DBITYPE[0] := 'L';
                   DB1.DBITEMS[17].DBISIZE := 14;
                   DB1.DBITEMS[18].DBINAME := 'PAY-DATE';
                   DB1.DBITEMS[18].DBITYPE[0] := 'D';
                   DB1.DBITEMS[18].DBISIZE := 8;
                   DB1.DBITEMS[19].DBINAME := 'PHONE-NO1';
                   DB1.DBITEMS[19].DBITYPE[0] := 'X';
                   DB1.DBITEMS[19].DBISIZE := 20;
                   DB1.DBITEMS[20].DBINAME := 'PHONE-NO2';
                   DB1.DBITEMS[20].DBITYPE[0] := 'X';
                   DB1.DBITEMS[20].DBISIZE := 20;
                   DB1.DBITEMS[21].DBINAME := 'FAX-NO';
                   DB1.DBITEMS[21].DBITYPE[0] := 'X';
                   DB1.DBITEMS[21].DBISIZE := 20;
                   DB1.DBITEMS[22].DBINAME := 'AREA-CODE';
                   DB1.DBITEMS[22].DBITYPE[0] := 'N';
                   DB1.DBITEMS[22].DBISIZE := 4;
                   DB1.DBITEMS[23].DBINAME := 'POST-CODE';
                   DB1.DBITEMS[23].DBITYPE[0] := 'X';
                   DB1.DBITEMS[23].DBISIZE := 20;
                   DB1.DBITEMS[24].DBINAME := 'CUST-REF';
                   DB1.DBITEMS[24].DBITYPE[0] := 'X';
                   DB1.DBITEMS[24].DBISIZE := 20;
                   DB1.DBITEMS[25].DBINAME := 'CONTACT1';
                   DB1.DBITEMS[25].DBITYPE[0] := 'X';
                   DB1.DBITEMS[25].DBISIZE := 20;
                   DB1.DBITEMS[26].DBINAME := 'CONTACT2';
                   DB1.DBITEMS[26].DBITYPE[0] := 'X';
                   DB1.DBITEMS[26].DBISIZE := 20;
                   DB1.DBITEMS[27].DBINAME := 'VAT-NO';
                   DB1.DBITEMS[27].DBITYPE[0] := 'X';
                   DB1.DBITEMS[27].DBISIZE := 20;
                   DB1.DBITEMS[28].DBINAME := 'COMMENT1';
                   DB1.DBITEMS[28].DBITYPE[0] := 'X';
                   DB1.DBITEMS[28].DBISIZE := 25;
                   DB1.DBITEMS[29].DBINAME := 'COMMENT2';
                   DB1.DBITEMS[29].DBITYPE[0] := 'X';
                   DB1.DBITEMS[29].DBISIZE := 25;
                   DB1.DBITEMS[30].DBINAME := 'COMMENT3';
                   DB1.DBITEMS[30].DBITYPE[0] := 'X';
                   DB1.DBITEMS[30].DBISIZE := 25;
                   end;
       NLFile : begin
                   if DB=CURRDB then exit;
                   CURRDB := DB;
               //    accsdatamodule.NLFileDB.open;
               //    updatedatabasedefaults;
                   db1.DBRECHIGH := accsdatamodule.NLFileDB.RecordCount;
                   db1.dbrectot := accsdatamodule.NLFileDB.RecordCount;
                   end;
       LastNLFile : begin
                   if DB=CURRDB then exit;
                   CURRDB := DB;
                   try accsdatamodule.LastNLFileDB.open;
                   db1.DBRECHIGH := accsdatamodule.LastNLFileDB.RecordCount;
                   db1.dbrectot := accsdatamodule.LastNLFileDB.RecordCount;
                   except
                   end;
               //    db1.DBRECHIGH := accsdatamodule.LastNLFileDB.RecordCount;
               //    db1.dbrectot := accsdatamodule.LastNLFileDB.RecordCount;
                   end;
       TxfileYr1 : begin
                   If DB=CURRDB then Exit;
                   CURRDB:=DB;
                   try accsdatamodule.TransactionsYr1DB.open;
                   except
                   end;
                   db1.DBRECHIGH := accsdatamodule.TransactionsYr1DB.RecordCount;
                   db1.dbrectot := db1.DBRECHIGH;
                   end;
       TxfileYr2 : begin
                   If DB=CURRDB then Exit;
                   CURRDB:=DB;
                   try accsdatamodule.TransactionsYr2DB.open;
                   except
                   end;
                   db1.DBRECHIGH := accsdatamodule.TransactionsYr2DB.RecordCount;
                   db1.dbrectot := db1.DBRECHIGH;
                   end;
  else begin
       showmessage('Your Trying To Open An Old Database!');
       IF NOT DBOPEN[DB] THEN
          BEGIN
          ERRORNO:=1;
          EXIT;
       END;
       IF DB=CURRDB THEN EXIT;

       IF CURRDB IN [1..MaxDatabases] THEN
          SAVEDB (CURRDB);
          move (dbhold[db]^.header, DB1, sizeof(db1));
          move (dbhold[db]^.data_work, DATWORK^, sizeof(datwork^));
          ok := TRUE;

       IF NOT OK THEN
          BEGIN
          STR (DB,ST);
          AbortProgram (CONCAT(MEMERR,'dr',ST));
          END;
          CURRDB:=DB;
  end;
end; // case statement
END;

PROCEDURE SAVEDB;
VAR
  OK : BOOLEAN;
  ST : STRING{[1]};
BEGIN
  ERRORNO:=0;

  IF NOT (DB IN [1..MaxDatabases]) THEN
    BEGIN
      ERRORNO:=11;
      EXIT ;
  END;

  // TGM AB Code added to handle Paradox DB
  case DB of
          NewTxfile : begin
                      CURRDB:=DB;
                      try accsdatamodule.TransactionsDB.Post;
                         // accsdatamodule.TransactionsDB.close;
                          except
                          end;
                      end;

          Entfile : begin
                 CURRDB:=DB;
                 try accsdatamodule.EntsFileDB.Post;
                  //   accsdatamodule.EntsFileDB.close;
                     except
                     end;
                 end;

          SLfile : begin
                 CURRDB:=DB;
                 try accsdatamodule.SLFileDB.Post;
                  //   accsdatamodule.SLFileDB.close;
                     except
                     end;
                 end;

          PLfile : begin
                 CURRDB:=DB;
                 try accsdatamodule.PLFileDB.Post;
                  //   accsdatamodule.PLFileDB.close;
                     except
                     end;
                 end;
          NLfile : begin
                 CURRDB:=DB;
                 try accsdatamodule.NLFileDB.Post;
                   //  accsdatamodule.NLFileDB.close;
                     except
                     end;
                 end;

  else begin
      showmessage('You are Trying to Save an Old Database!');
      IF NOT DBOPEN[DB] THEN
         BEGIN
         ERRORNO:=1;
         EXIT;
      END;
      move (db1, dbhold[db]^.header, sizeof(db1));
      move (datwork^, dbhold[db]^.data_work, sizeof(datwork^));
      ok := TRUE;

      IF NOT OK THEN
         BEGIN
         STR (DB,ST);
         AbortProgram (CONCAT(MEMERR,'dw',ST));
      END;
  end;
  end; // case statement
END;

PROCEDURE READTABLES;
{VAR
  BLKNO	  : INTEGER;
  SUB	  : INTEGER;
  TABWORK : PACKED ARRAY[1..512] OF CHAR;  }
BEGIN
  Accsdatamodule.NLGroupsDB.open;
  try Accsdatamodule.NLGroupsDB.Locate('GroupNo',Tabrec,[]);
      Tabledesc := Accsdatamodule.NLGroupsDB['GroupDesc'];
  except Tabledesc := '';
  end;
  Accsdatamodule.NLGroupsDB.close;

END;

PROCEDURE WRITETABLES;
BEGIN
  Accsdatamodule.NLGroupsDB.open;
  try Accsdatamodule.NLGroupsDB.Locate('GroupNo',Tabrec,[]);
      Accsdatamodule.NLGroupsDB.edit;
      Accsdatamodule.NLGroupsDB['GroupDesc'] := Tabledesc;
      Accsdatamodule.NLGroupsDB['Active'] := True;
      Accsdatamodule.NLGroupsDB.post;
  except Tabledesc := '';
  end;
  Accsdatamodule.NLGroupsDB.close;
END;

PROCEDURE GETITEM;
VAR
  ST	: STRING132;
  DY	: INTEGER;
  MN	: INTEGER;
  YR	: INTEGER;
  X	: INTEGER;
  ITFST, J : INTEGER;
  temp_pos,
  pos_x    : Integer;
  tempstring : string;
  AYear, AMonth, ADay: Word;
  Value : Variant;

   PROCEDURE SETSTR;
   BEGIN
     CURRSTR:=CONCAT(SPACE30,SPACE30,SPACE4);
     MOVE (CURRDISP[1],CURRSTR[1],64);
     SLIMLEFT  (CURRSTR);
     SLIMRIGHT (CURRSTR);
   END;

BEGIN
  FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
  CURRSIZE:=0;
  CURRINT :=0;
  CURRLONG:=0;
  CURRSTR :=NULL;
  ERRORNO :=0;
  SETDB (DB);
  // Code for New Paradox Files
  case DB of
       NewTxFile : begin
                   DY:=0;
                   MN:=0;
                   YR:=0;
                   case itemno of
                        1: begin // TxType
                           currint := accsdatamodule.TransactionsDB['TxType'];
                           currsize := 4;
                           end;
                        2: begin //date (renamed Txdate in new table)
                           tempstring := copy(datetostr(accsdatamodule.TransactionsDB['TxDate']),1,2);
                           tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsDB['TxDate']),4,2);
                           if length(datetostr(accsdatamodule.TransactionsDB['TxDate'])) = 10 then tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsDB['TxDate']),9,2)
                                else tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsDB['TxDate']),7,2);
                           currint := kdatetoint(tempstring);
                           kdatetostr(currint, currstr);
                           for J:=1 to 8 do begin
                               currdisp[j] := currstr[j];
                           end;
                           currsize := 8;
                           end;
                        3: begin // Account
                           currint := accsdatamodule.TransactionsDB['Account'];
                           tempstring := vartostr(currint);
                           tempstring := padstring(tempstring,4);
                           for j:=1 to 4 do begin
                                 currdisp[j] := tempstring[j];
                              end;
                           currsize := 4;
                           end;
                        4: begin // Reference
                           currstr := varToStr(accsdatamodule.TransactionsDB['Reference']);
                           for j:=1 to 8 do currdisp[j] := ' ';
                           for j:=1 to length(currstr) do begin
                                 currdisp[j] := currstr[j];
                              end;
                           currsize := 8;  //8
                           end;
                        5: begin // Descript
                           currstr := vartostr(accsdatamodule.TransactionsDB['Descript']);
                           for j:=1 to 8 do currdisp[j] := ' ';
                           for j:=1 to length(currstr) do begin
                                 currdisp[j] := currstr[j];
                              end;
                           currsize := 30; //15
                           end;
                        6: begin // quantity
                           currlong := (accsdatamodule.TransactionsDB['Quantity'] * 100);
                           currsize := 14;
                           end;
                        7: begin // Product
                           currint := accsdatamodule.TransactionsDB['Product'];
                           currsize := 4;
                           end;
                        8: begin // Nominal
                           currint := accsdatamodule.TransactionsDB['Nominal'];
                           currsize := 4;
                           end;
                        9: begin
                           currlong := (accsdatamodule.TransactionsDB['Amount'] * 100);
                           currsize := 14;
                           end;
                        10: begin
                           currstr := vartostr(accsdatamodule.TransactionsDB['Taxcode']);
                           currsize := 1;
                           if currstr = '' then currstr := ' ';
                           currdisp[1] := currstr[1];
                           end;
                        11: begin
                           currlong := (accsdatamodule.TransactionsDB['TaxDisc'] * 100);
                           currsize := 14;
                           end;
                        12: begin
                           currint := accsdatamodule.TransactionsDB['Analysis'];
                           currsize := 4;
                           end;
                        13: begin
                           currint := accsdatamodule.TransactionsDB['NextDB'];
                           currsize := 5;
                           end;
                        14: begin
                           currint := accsdatamodule.TransactionsDB['NextCR'];
                           currsize := 5;
                           end;
                        16: begin
                           currint := accsdatamodule.TransactionsDB['NextSP'];
                           currsize := 5;
                           end;
                        17: begin
                           currlong := (accsdatamodule.TransactionsDB['NomAmount'] * 100);
                           currsize := 14;
                           end;
                        18: begin
                           currint := accsdatamodule.TransactionsDB['DebitAC'];
                           tempstring := vartostr(currint);
                           tempstring := padstring(tempstring,4);
                           for j:=1 to 4 do begin
                                 currdisp[j] := tempstring[j];
                              end;
                           currsize := 4;
                           end;
                        19: begin
                           currint := accsdatamodule.TransactionsDB['CreditAC'];
                           tempstring := vartostr(currint);
                           tempstring := padstring(tempstring,4);
                           for j:=1 to 4 do begin
                                 currdisp[j] := tempstring[j];
                              end;
                           currsize := 4;
                           end;
                        23: begin
                           currint := accsdatamodule.TransactionsDB['OrigType'];
                           currsize := 4;
                           end;
                        24: begin
                           currstr := vartostr(accsdatamodule.TransactionsDB['Enterprise']);
                           currsize := 4;
                           end;
                        26: begin
                           currstr := vartostr(accsdatamodule.TransactionsDB['StubNo']);
                           currsize := 8;
                           end;
                        27: begin
                           currstr := vartostr(accsdatamodule.TransactionsDB['BankRec']);
                           currsize := 1;
                           if currstr = '' then currstr := ' ';
                           currdisp[1] := currstr[1];
                           end;
                        28: begin
                           currstr := varToStr(accsdatamodule.TransactionsDB['EditStat']);
                           currsize := 1;
                           if currstr = '' then currstr := ' ';
                           currdisp[1] := currstr[1];
                           end;
                        29: begin
                           currlong := (accsdatamodule.TransactionsDB['AmtPaid'] * 100);
                           currsize := 14;
                           end;
                        30: begin
                           currstr := vartostr(accsdatamodule.TransactionsDB['Allocated']);
                           currsize := 1;
                           if currstr = '' then currstr := ' ';
                           currdisp[1] := currstr[1];
                           end;
                        31: begin
                              try
                              if accsdatamodule.TransactionsDB['DueDate'].asstring <> '' then begin
                              tempstring := copy(datetostr(accsdatamodule.TransactionsDB['DueDate']),1,2);
                              tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsDB['DueDate']),4,2);
                              if length(datetostr(accsdatamodule.TransactionsDB['DueDate'])) = 10 then tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsDB['DueDate']),9,2)
                                else tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsDB['DueDate']),7,2);
                              currint := kdatetoint(tempstring);
                              kdatetostr(currint, currstr);
                              for j:=1 to 8 do begin
                                 currdisp[j] := currstr[j];
                              end;
                              currsize := 8;
                              end;
                              except currsize := 8;
                              end;
                            end;
                        32: begin // quantity2                                                      // TGB AB 01/02/13
                              try currlong := (accsdatamodule.TransactionsDB['Quantity2'] * 100);   // TGB AB 01/02/13
                              except currlong := 0;                                                 // TGB AB 01/02/13
                              end;                                                                  // TGB AB 01/02/13
                              currsize := 14;                                                       // TGB AB 01/02/13
                            end;                                                                    // TGB AB 01/02/13
                        33: begin // quantity3                                                      // TGB AB 01/02/13
                              {try
                                 Value := accsdatamodule.TransactionsDB['Quantity3'];
                                 if not VarIsNull(Value) then
                                    begin
                                       currlong := (accsdatamodule.TransactionsDB['Quantity3'] * 100);   // TGB AB 01/02/13
                                    end
                                 else
                                    currlong := 0;
                              except
                                 on e : exception do
                                    begin
                                       currlong := 0;                                                 // TGB AB 01/02/13
                                       ShowMessage(E.Message);
                                    end;
                              end;  }                                                                // TGB AB 01/02/13
                              try currlong := (accsdatamodule.TransactionsDB['Quantity3'] * 100);   // TGB AB 01/02/13
                              except currlong := 0;                                                 // TGB AB 01/02/13
                              end;                                                                  // TGB AB 01/02/13
                              currsize := 14;                                                       // TGB AB 01/02/13
                            end;                                                                    // TGB AB 01/02/13
                            end;
                        Currrec[db] := Accsdatamodule.TransactionsDB.RecNo; // This holds the current recno for each DB
                                                                            // this is read by the reports and used as tx no!
                   end;

       EntFile : Begin
                   case itemno of
                        1: begin // Ent-Code
                           currstr := vartostr(accsdatamodule.EntsFileDB['EntCode']);
                           currsize := 4;
                           end;
                        2: begin // Ent-Name
                           currstr := vartostr(accsdatamodule.EntsFileDB['EntName']);
                           currsize := 20;
                           end;
                        3: begin // Unit-Div
                           currlong := 100*(accsdatamodule.EntsFileDB['UnitDiv']);
                           currstr := vartostr(accsdatamodule.EntsFileDB['UnitDiv']);
                           currsize := 14;
                           end;
                        4: begin // Unit-Text
                           currstr := vartostr(accsdatamodule.EntsFileDB['UnitText']);
                           currsize := 15;
                           end;
                        6: begin // Inc-From
                           currint := accsdatamodule.EntsFileDB['IncFrom'];
                           currsize := 4;
                           end;
                        7: begin // Inc-To
                           currint := accsdatamodule.EntsFileDB['IncTo'];
                           currsize := 4;
                           end;
                        8: begin // Exp-From
                           currint := accsdatamodule.EntsFileDB['ExpFrom'];
                           currsize := 4;
                           end;
                        9: begin // Exp-To
                           currint := accsdatamodule.EntsFileDB['ExpTo'];
                           currsize := 4;
                           end;
                        10: begin // Cos-From
                           currint := accsdatamodule.EntsFileDB['CosFrom'];
                           currsize := 4;
                           end;
                        11: begin // Cos-To
                           currint := accsdatamodule.EntsFileDB['CosTo'];
                           currsize := 4;
                           end;
                        12: begin // Quantity2 Name                                                // TGM AB 01/02/13
                           currstr := vartostr(accsdatamodule.EntsFileDB['Quantity2Name']);        // TGM AB 01/02/13
                           currsize := 30;                                                         // TGM AB 01/02/13
                           end;                                                                    // TGM AB 01/02/13
                        13: begin // Quantity3 Name                                                // TGM AB 01/02/13
                           currstr := vartostr(accsdatamodule.EntsFileDB['Quantity3Name']);        // TGM AB 01/02/13
                           currsize := 30;                                                         // TGM AB 01/02/13
                           end;                                                                    // TGM AB 01/02/13
                        //   05/12/17 [V4.2 R9.4] /MK Bug Fix - Added try except here just in case field is null. 
                        14: try // JobCardEnabled                                                  // TGM AB 01/02/13
                               currlong := accsdatamodule.EntsFileDB['JobCardEnabled'];            // TGM AB 01/02/13
                               currsize := 1;                                                      // TGM AB 01/02/13
                            except
                            end;                                                                    // TGM AB 01/02/13

                   end; // case
                    Currrec[db] := Accsdatamodule.EntsFileDB.RecNo;
                   end;
       SLFile : Begin
                   FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
                   CURRSIZE:=0;
                   CURRINT :=0;
                   CURRLONG:=0;
                   CURRSTR :=NULL;
                   case itemno of
                        1: begin // Name
                           currstr := vartostr(accsdatamodule.SLFileDB['Name']);
                           currsize := 30;
                           end;
                        2: begin // Address1
                           currstr := vartostr(accsdatamodule.SLFileDB['Address1']);
                           currsize := 30;
                           end;
                        3: begin // Address2
                           currstr := vartostr(accsdatamodule.SLFileDB['Address2']);
                           currsize := 30;
                           end;
                        4: begin // Address3
                           currstr := vartostr(accsdatamodule.SLFileDB['Address3']);
                           currsize := 30;
                           end;
                        5: begin // Address4
                           currstr := vartostr(accsdatamodule.SLFileDB['Address4']);
                           currsize := 30;
                           end;
                        6: begin // Balance-BF
                           currlong := 100*(accsdatamodule.SLFileDB['BalanceBF']);
                           currsize := 14;
                           end;
                        7: begin // Balance
                           currlong := 100*(accsdatamodule.SLFileDB['Balance']);
                           currsize := 14;
                           end;
                        8: begin // Turnover
                           currlong := 100*(accsdatamodule.SLFileDB['Turnover']);
                           currsize := 14;
                           end;
                        9: begin // Age-Curr
                           currlong := 100*(accsdatamodule.SLFileDB['AgeCurr']);
                           currsize := 14;
                           end;
                        10: begin // Age1
                           currlong := 100*(accsdatamodule.SLFileDB['Age1']);
                           currsize := 14;
                           end;
                        11: begin // Age2
                           currlong := 100*(accsdatamodule.SLFileDB['Age2']);
                           currsize := 14;
                           end;
                        12: begin // Age3
                           currlong := 100*(accsdatamodule.SLFileDB['Age3']);
                           currsize := 14;
                           end;
                        13: begin // Not-Alloc
                           currlong := 100*(accsdatamodule.SLFileDB['NotAlloc']);
                           currsize := 14;
                           end;
                        14: begin // First-Year
                           currint := accsdatamodule.SLFileDB['FirstYear'];
                           currsize := 7;
                           end;
                        15: begin // First-Tx
                           currint := accsdatamodule.SLFileDB['FirstTx'];
                           currsize := 7;
                           end;
                        16: begin // Last-Tx
                           currint := accsdatamodule.SLFileDB['LastTx'];
                           currsize := 7;
                           end;
                        17: begin // BalanceST
                           currlong := 100*(accsdatamodule.SLFileDB['BalanceST']);
                           currsize := 14;
                           end;
                        18: begin
                              try
                              if accsdatamodule.SLFileDB['PayDate'].asstring <> '' then begin
                              tempstring := copy(datetostr(accsdatamodule.SLFileDB['PayDate']),1,2);
                              tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.SLFileDB['PayDate']),4,2);
                              if length(datetostr(accsdatamodule.SLFileDB['PayDate'])) = 10 then tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.SLFileDB['PayDate']),9,2)
                                else tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.SLFileDB['PayDate']),7,2);
                              currint := kdatetoint(tempstring);
                              kdatetostr(currint, currstr);
                              for j:=1 to 8 do begin
                                 currdisp[j] := currstr[j];
                              end;
                              currsize := 8;
                              end;
                              except currsize := 8;
                              end;
                           end;
                        19: begin // Phone-No1
                           currstr := vartostr(accsdatamodule.SLFileDB['PhoneNo1']);
                           currsize := 30;
                           end;
                        20: begin // Phone-No2
                           currstr := vartostr(accsdatamodule.SLFileDB['PhoneNo2']);
                           currsize := 30;
                           end;
                        21: begin // Fax-No
                           currstr := vartostr(accsdatamodule.SLFileDB['FaxNo']);
                           currsize := 30;
                           end;
                        22: begin // Area-Code
                           currint := accsdatamodule.SLFileDB['AreaCode'];
                           currsize := 4;
                           end;
                        23: begin // Post-Code
                           currstr := vartostr(accsdatamodule.SLFileDB['Postcode']);
                           currsize := 20;
                           end;
                        24: begin // Cust-Ref
                           currstr := vartostr(accsdatamodule.SLFileDB['CustRef']);
                           currsize := 20;
                           end;
                        25: begin // Contact1
                           currstr := vartostr(accsdatamodule.SLFileDB['Contact1']);
                           currsize := 20;
                           end;
                        26: begin // Contact2
                           currstr := vartostr(accsdatamodule.SLFileDB['Contact2']);
                           currsize := 20;
                           end;
                        27: begin // VAT-No
                           currstr := vartostr(accsdatamodule.SLFileDB['VatNo']);
                           currsize := 20;
                           end;
                        28: begin // Comment1
                           currstr := vartostr(accsdatamodule.SLFileDB['Comment1']);
                           currsize := 25;
                           end;
                        29: begin // Comment2
                           currstr := vartostr(accsdatamodule.SLFileDB['Comment2']);
                           currsize := 25;
                           end;
                        30: begin // Comment3
                           currstr := vartostr(accsdatamodule.SLFileDB['Comment3']);
                           currsize := 25;
                           end;
                        31: begin // New Field Address 5
                           currstr := vartostr(accsdatamodule.SLFileDB['Address5']);
                           currsize := 30;
                           end;
                        32: begin // Email
                           currstr := vartostr(accsdatamodule.SLFileDB['Email']);
                           currsize := 50;
                           end;
                   end; // case

                   if currstr <> '' then begin
                        for j:=1 to length(currstr) do begin
                                 currdisp[j] := currstr[j];
                        end;
                   end
                   else FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
                   Currrec[db] := Accsdatamodule.SLFileDB.RecNo;
                end;
       PLFile : Begin
                   FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
                   CURRSIZE:=0;
                   CURRINT :=0;
                   CURRLONG:=0;
                   CURRSTR :=NULL;
                   case itemno of
                        1: begin // Name
                           currstr := vartostr(accsdatamodule.PLFileDB['Name']);
                           currsize := 30;
                           end;
                        2: begin // Address1
                           currstr := vartostr(accsdatamodule.PLFileDB['Address1']);
                           currsize := 30;
                           end;
                        3: begin // Address2
                           currstr := vartostr(accsdatamodule.PLFileDB['Address2']);
                           currsize := 30;
                           end;
                        4: begin // Address3
                           currstr := vartostr(accsdatamodule.PLFileDB['Address3']);
                           currsize := 30;
                           end;
                        5: begin // Address4
                           currstr := vartostr(accsdatamodule.PLFileDB['Address4']);
                           currsize := 30;
                           end;
                        6: begin // Balance-BF
                           currlong := 100*(accsdatamodule.PLFileDB['BalanceBF']);
                           currsize := 14;
                           end;
                        7: begin // Balance
                           currlong := 100*(accsdatamodule.PLFileDB['Balance']);
                           currsize := 14;
                           end;
                        8: begin // Turnover
                           currlong := 100*(accsdatamodule.PLFileDB['Turnover']);
                           currsize := 14;
                           end;
                        9: begin // Age-Curr
                           currlong := 100*(accsdatamodule.PLFileDB['AgeCurr']);
                           currsize := 14;
                           end;
                        10: begin // Age1
                           currlong := 100*(accsdatamodule.PLFileDB['Age1']);
                           currsize := 14;
                           end;
                        11: begin // Age2
                           currlong := 100*(accsdatamodule.PLFileDB['Age2']);
                           currsize := 14;
                           end;
                        12: begin // Age3
                           currlong := 100*(accsdatamodule.PLFileDB['Age3']);
                           currsize := 14;
                           end;
                        13: begin // Not-Alloc
                           currlong := 100*(accsdatamodule.PLFileDB['NotAlloc']);
                           currsize := 14;
                           end;
                        14: begin // First-Year
                           currint := accsdatamodule.PLFileDB['FirstYear'];
                           currsize := 7;
                           end;
                        15: begin // First-Tx
                           currint := accsdatamodule.PLFileDB['FirstTx'];
                           currsize := 7;
                           end;
                        16: begin // Last-Tx
                           currint := accsdatamodule.PLFileDB['LastTx'];
                           currsize := 7;
                           end;
                        17: begin // BalanceST
                           currlong := 100*(accsdatamodule.PLFileDB['BalanceST']);
                           currsize := 14;
                           end;
                        18: begin
                              try
                              if accsdatamodule.PLFileDB['PayDate'].asstring <> '' then begin
                              tempstring := copy(datetostr(accsdatamodule.PLFileDB['PayDate']),1,2);
                              tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.PLFileDB['PayDate']),4,2);
                              if length(datetostr(accsdatamodule.PLFileDB['PayDate'])) = 10 then tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.PLFileDB['PayDate']),9,2)
                                else tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.PLFileDB['PayDate']),7,2);
                              currint := kdatetoint(tempstring);
                              kdatetostr(currint, currstr);
                              for j:=1 to 8 do begin
                                 currdisp[j] := currstr[j];
                              end;
                              currsize := 8;
                              end;
                              except currsize := 8;
                              end;
                           end;
                        19: begin // Phone-No1
                           currstr := vartostr(accsdatamodule.PLFileDB['PhoneNo1']);
                           currsize := 30;
                           end;
                        20: begin // Phone-No2
                           currstr := vartostr(accsdatamodule.PLFileDB['PhoneNo2']);
                           currsize := 30;
                           end;
                        21: begin // Fax-No
                           currstr := vartostr(accsdatamodule.PLFileDB['FaxNo']);
                           currsize := 30;
                           end;
                        22: begin // Area-Code
                           currint := accsdatamodule.PLFileDB['AreaCode'];
                           currsize := 4;
                           end;
                        23: begin // Post-Code
                           currstr := vartostr(accsdatamodule.PLFileDB['Postcode']);
                           currsize := 20;
                           end;
                        24: begin // Cust-Ref
                           currstr := vartostr(accsdatamodule.PLFileDB['CustRef']);
                           currsize := 20;
                           end;
                        25: begin // Contact1
                           currstr := vartostr(accsdatamodule.PLFileDB['Contact1']);
                           currsize := 20;
                           end;
                        26: begin // Contact2
                           currstr := vartostr(accsdatamodule.PLFileDB['Contact2']);
                           currsize := 20;
                           end;
                        27: begin // VAT-No
                           currstr := vartostr(accsdatamodule.PLFileDB['VatNo']);
                           currsize := 20;
                           end;
                        28: begin // Comment1
                           currstr := vartostr(accsdatamodule.PLFileDB['Comment1']);
                           currsize := 25;
                           end;
                        29: begin // Comment2
                           currstr := vartostr(accsdatamodule.PLFileDB['Comment2']);
                           currsize := 25;
                           end;
                        30: begin // Comment3
                           currstr := vartostr(accsdatamodule.PLFileDB['Comment3']);
                           currsize := 25;
                           end;
                        31: begin // New Field Address 5
                           currstr := vartostr(accsdatamodule.PLFileDB['Address5']);
                           currsize := 30;
                           end;
                        32: begin // Email
                           currstr := vartostr(accsdatamodule.PLFileDB['Email']);
                           currsize := 50;
                           end;
                   end; // case
                   if currstr <> '' then begin
                        for j:=1 to length(currstr) do begin
                                 currdisp[j] := currstr[j];
                        end;
                   end
                   else FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
                   Currrec[db] := Accsdatamodule.PLFileDB.RecNo;
                   end;
       NLFile : Begin
                   FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
                   CURRSIZE:=0;
                   CURRINT :=0;
                   CURRLONG:=0;
                   CURRSTR :=NULL;
                   case itemno of
                        1: begin // Name
                           currstr := vartostr(accsdatamodule.NLFileDB['Name']);
                           currsize := 30;
                           end;
                        2: begin // Balance
                           currlong := 100*(accsdatamodule.NLFileDB['Balance']);
                           currsize := 14;
                           end;
                        3: begin // ST-Period
                           currlong := 100*(accsdatamodule.NLFileDB['STPeriod']);
                           currsize := 14;
                           end;
                        4: begin // ST-Year
                           currlong := 100*(accsdatamodule.NLFileDB['STYear']);
                           currsize := 14;
                           end;
                        5: begin // Rep-Group
                           currint := accsdatamodule.NLFileDB['RepGroup'];
                           currstr := vartostr(currint);   // TGM AB 29/09/17
                           currsize := 4;
                           end;
                        6: begin // ST-Week
                           currlong := 100*(accsdatamodule.NLFileDB['STWeek']);
                           currsize := 14;
                           end;
                        7: begin // Budg-Year
                           currlong := 100*(accsdatamodule.NLFileDB['BudgYear']);
                           currsize := 14;
                           end;
                        14: begin // First-Bank
                           currint := accsdatamodule.NLFileDB['FirstBank'];
                           currsize := 4;
                           end;
                        15: begin // First-Tx
                           currint := accsdatamodule.NLFileDB['FirstTx'];
                           currsize := 4;
                           end;
                        16: begin // Last-Tx
                           currint := accsdatamodule.NLFileDB['LastTx'];
                           currsize := 4;
                           end;
                        17: begin // Year-Tot-1
                           currlong := 100*(accsdatamodule.NLFileDB['YearTot1']);
                           currsize := 14;
                           end;
                        18: begin // Year-Tot-2
                           currlong := 100*(accsdatamodule.NLFileDB['YearTot2']);
                           currsize := 14;
                           end;
                        19: begin // Year-Tot-3
                           currlong := 100*(accsdatamodule.NLFileDB['YearTot3']);
                           currsize := 14;
                           end;
                        20: begin // Tax-Code
                           currstr := vartostr(accsdatamodule.NLFileDB['TaxCode']);
                           currsize := 1;
                           end;
                        21: begin // Rep-Flag
                           currstr := vartostr(accsdatamodule.NLFileDB['RepFlag']);
                           currsize := 1;
                           end;
                        22: begin // Balance-ST
                           currlong := 100*(accsdatamodule.NLFileDB['BalanceST']);
                           currsize := 14;
                           end;
                        24: begin // Enterprise
                           currstr := vartostr(accsdatamodule.NLFileDB['Enterprise']);
                           currsize := 4;
                           end;
                        33: begin // Bud-Per-01
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer01']);
                           currsize := 14;
                           end;
                        34: begin // Bud-Per-02
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer02']);
                           currsize := 14;
                           end;
                        35: begin // Bud-Per-03
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer03']);
                           currsize := 14;
                           end;
                        36: begin // Bud-Per-04
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer04']);
                           currsize := 14;
                           end;
                        37: begin // Bud-Per-05
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer05']);
                           currsize := 14;
                           end;
                        38: begin // Bud-Per-06
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer06']);
                           currsize := 14;
                           end;
                        39: begin // Bud-Per-07
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer07']);
                           currsize := 14;
                           end;
                        40: begin // Bud-Per-08
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer08']);
                           currsize := 14;
                           end;
                        41: begin // Bud-Per-09
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer09']);
                           currsize := 14;
                           end;
                        42: begin // Bud-Per-10
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer10']);
                           currsize := 14;
                           end;
                        43: begin // Bud-Per-11
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer11']);
                           currsize := 14;
                           end;
                        44: begin // Bud-Per-12
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer12']);
                           currsize := 14;
                           end;
                        45: begin // Bud-Per-13
                           currlong := 100*(accsdatamodule.NLFileDB['BudPer13']);
                           currsize := 14;
                           end;

                        49: begin // Act-Per-01
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer01']);
                           currsize := 14;
                           end;
                        50: begin // Act-Per-02
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer02']);
                           currsize := 14;
                           end;
                        51: begin // Act-Per-03
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer03']);
                           currsize := 14;
                           end;
                        52: begin // Act-Per-04
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer04']);
                           currsize := 14;
                           end;
                        53: begin // Act-Per-05
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer05']);
                           currsize := 14;
                           end;
                        54: begin // Act-Per-06
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer06']);
                           currsize := 14;
                           end;
                        55: begin // Act-Per-07
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer07']);
                           currsize := 14;
                           end;
                        56: begin // Act-Per-08
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer08']);
                           currsize := 14;
                           end;
                        57: begin // Act-Per-09
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer09']);
                           currsize := 14;
                           end;
                        58: begin // Act-Per-10
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer10']);
                           currsize := 14;
                           end;
                        59: begin // Act-Per-11
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer11']);
                           currsize := 14;
                           end;
                        60: begin // Act-Per-12
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer12']);
                           currsize := 14;
                           end;
                        61: begin // Act-Per-13
                           currlong := 100*(accsdatamodule.NLFileDB['ActPer13']);
                           currsize := 14;
                           end;

                        65: begin // Lst-Per-01
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer01']);
                           currsize := 14;
                           end;
                        66: begin // Lst-Per-02
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer02']);
                           currsize := 14;
                           end;
                        67: begin // Lst-Per-03
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer03']);
                           currsize := 14;
                           end;
                        68: begin // Lst-Per-04
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer04']);
                           currsize := 14;
                           end;
                        69: begin // Lst-Per-05
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer05']);
                           currsize := 14;
                           end;
                        70: begin // Lst-Per-06
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer06']);
                           currsize := 14;
                           end;
                        71: begin // Lst-Per-07
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer07']);
                           currsize := 14;
                           end;
                        72: begin // Lst-Per-08
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer08']);
                           currsize := 14;
                           end;
                        73: begin // Lst-Per-09
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer09']);
                           currsize := 14;
                           end;
                        74: begin // Lst-Per-10
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer10']);
                           currsize := 14;
                           end;
                        75: begin // Lst-Per-11
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer11']);
                           currsize := 14;
                           end;
                        76: begin // Lst-Per-12
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer12']);
                           currsize := 14;
                           end;
                        77: begin // Lst-Per-13
                           currlong := 100*(accsdatamodule.NLFileDB['LstPer13']);
                           currsize := 14;
                           end;
                        101: begin // DepRate
                           try currlong := 100*(accsdatamodule.NLFileDB['DepRate']);
                           except
                           end;
                           currsize := 14;
                           end;
                        102: begin // DepAmount
                           try currlong := 100*(accsdatamodule.NLFileDB['DepAmount']);
                           except
                           end;
                           currsize := 14;
                           end;
                        103: begin // NominalType
                           currstr := vartostr(accsdatamodule.NLFileDB['NominalType']);
                           currsize := 1;
                           end;
                        104: begin // Category
                           currstr := vartostr(accsdatamodule.NLFileDB['Category']);
                           currsize := 10;
                           end;


                   end; // case
                   if currstr <> '' then begin
                        for j:=1 to length(currstr) do begin
                                 currdisp[j] := currstr[j];
                        end;
                   end
                   else FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
                   Currrec[db] := Accsdatamodule.NLFileDB.RecNo;
                   end;
       LastNLFile : Begin
                   FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
                   CURRSIZE:=0;
                   CURRINT :=0;
                   CURRLONG:=0;
                   CURRSTR :=NULL;
                   case itemno of
                        1: begin // Name
                           currstr := vartostr(accsdatamodule.LastNLFileDB['Name']);
                           currsize := 30;
                           end;
                        2: begin // Balance
                           currlong := 100*(accsdatamodule.LastNLFileDB['Balance']);
                           currsize := 14;
                           end;
                        3: begin // ST-Period
                           currlong := 100*(accsdatamodule.LastNLFileDB['STPeriod']);
                           currsize := 14;
                           end;
                        4: begin // ST-Year
                           currlong := 100*(accsdatamodule.LastNLFileDB['STYear']);
                           currsize := 14;
                           end;
                        5: begin // Rep-Group
                           currint := accsdatamodule.LastNLFileDB['RepGroup'];
                           currstr := vartostr(currint);   // TGM AB 29/09/17
                           currsize := 4;
                           end;
                        6: begin // ST-Week
                           currlong := 100*(accsdatamodule.LastNLFileDB['STWeek']);
                           currsize := 14;
                           end;
                        7: begin // Budg-Year
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudgYear']);
                           currsize := 14;
                           end;
                        14: begin // First-Bank
                           currint := accsdatamodule.LastNLFileDB['FirstBank'];
                           currsize := 4;
                           end;
                        15: begin // First-Tx
                           currint := accsdatamodule.LastNLFileDB['FirstTx'];
                           currsize := 4;
                           end;
                        16: begin // Last-Tx
                           currint := accsdatamodule.LastNLFileDB['LastTx'];
                           currsize := 4;
                           end;
                        17: begin // Year-Tot-1
                           currlong := 100*(accsdatamodule.LastNLFileDB['YearTot1']);
                           currsize := 14;
                           end;
                        18: begin // Year-Tot-2
                           currlong := 100*(accsdatamodule.LastNLFileDB['YearTot2']);
                           currsize := 14;
                           end;
                        19: begin // Year-Tot-3
                           currlong := 100*(accsdatamodule.LastNLFileDB['YearTot3']);
                           currsize := 14;
                           end;
                        20: begin // Tax-Code
                           currstr := vartostr(accsdatamodule.LastNLFileDB['TaxCode']);
                           currsize := 1;
                           end;
                        21: begin // Rep-Flag
                           currstr := vartostr(accsdatamodule.LastNLFileDB['RepFlag']);
                           currsize := 1;
                           end;
                        22: begin // Balance-ST
                           currlong := 100*(accsdatamodule.LastNLFileDB['BalanceST']);
                           currsize := 14;
                           end;
                        24: begin // Enterprise
                           currstr := vartostr(accsdatamodule.LastNLFileDB['Enterprise']);
                           currsize := 4;
                           end;
                        33: begin // Bud-Per-01
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer01']);
                           currsize := 14;
                           end;
                        34: begin // Bud-Per-02
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer02']);
                           currsize := 14;
                           end;
                        35: begin // Bud-Per-03
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer03']);
                           currsize := 14;
                           end;
                        36: begin // Bud-Per-04
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer04']);
                           currsize := 14;
                           end;
                        37: begin // Bud-Per-05
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer05']);
                           currsize := 14;
                           end;
                        38: begin // Bud-Per-06
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer06']);
                           currsize := 14;
                           end;
                        39: begin // Bud-Per-07
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer07']);
                           currsize := 14;
                           end;
                        40: begin // Bud-Per-08
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer08']);
                           currsize := 14;
                           end;
                        41: begin // Bud-Per-09
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer09']);
                           currsize := 14;
                           end;
                        42: begin // Bud-Per-10
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer10']);
                           currsize := 14;
                           end;
                        43: begin // Bud-Per-11
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer11']);
                           currsize := 14;
                           end;
                        44: begin // Bud-Per-12
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer12']);
                           currsize := 14;
                           end;
                        45: begin // Bud-Per-13
                           currlong := 100*(accsdatamodule.LastNLFileDB['BudPer13']);
                           currsize := 14;
                           end;

                        49: begin // Act-Per-01
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer01']);
                           currsize := 14;
                           end;
                        50: begin // Act-Per-02
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer02']);
                           currsize := 14;
                           end;
                        51: begin // Act-Per-03
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer03']);
                           currsize := 14;
                           end;
                        52: begin // Act-Per-04
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer04']);
                           currsize := 14;
                           end;
                        53: begin // Act-Per-05
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer05']);
                           currsize := 14;
                           end;
                        54: begin // Act-Per-06
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer06']);
                           currsize := 14;
                           end;
                        55: begin // Act-Per-07
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer07']);
                           currsize := 14;
                           end;
                        56: begin // Act-Per-08
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer08']);
                           currsize := 14;
                           end;
                        57: begin // Act-Per-09
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer09']);
                           currsize := 14;
                           end;
                        58: begin // Act-Per-10
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer10']);
                           currsize := 14;
                           end;
                        59: begin // Act-Per-11
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer11']);
                           currsize := 14;
                           end;
                        60: begin // Act-Per-12
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer12']);
                           currsize := 14;
                           end;
                        61: begin // Act-Per-13
                           currlong := 100*(accsdatamodule.LastNLFileDB['ActPer13']);
                           currsize := 14;
                           end;

                        65: begin // Lst-Per-01
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer01']);
                           currsize := 14;
                           end;
                        66: begin // Lst-Per-02
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer02']);
                           currsize := 14;
                           end;
                        67: begin // Lst-Per-03
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer03']);
                           currsize := 14;
                           end;
                        68: begin // Lst-Per-04
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer04']);
                           currsize := 14;
                           end;
                        69: begin // Lst-Per-05
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer05']);
                           currsize := 14;
                           end;
                        70: begin // Lst-Per-06
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer06']);
                           currsize := 14;
                           end;
                        71: begin // Lst-Per-07
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer07']);
                           currsize := 14;
                           end;
                        72: begin // Lst-Per-08
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer08']);
                           currsize := 14;
                           end;
                        73: begin // Lst-Per-09
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer09']);
                           currsize := 14;
                           end;
                        74: begin // Lst-Per-10
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer10']);
                           currsize := 14;
                           end;
                        75: begin // Lst-Per-11
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer11']);
                           currsize := 14;
                           end;
                        76: begin // Lst-Per-12
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer12']);
                           currsize := 14;
                           end;
                        77: begin // Lst-Per-13
                           currlong := 100*(accsdatamodule.LastNLFileDB['LstPer13']);
                           currsize := 14;
                           end;
                        101: begin // DepRate
                           try currlong := 100*(accsdatamodule.LastNLFileDB['DepRate']);
                           except
                           end;
                           currsize := 14;
                           end;
                        102: begin // DepAmount
                           try currlong := 100*(accsdatamodule.LastNLFileDB['DepAmount']);
                           except
                           end;
                           currsize := 14;
                           end;
                        103: begin // NominalType
                           currstr := vartostr(accsdatamodule.LastNLFileDB['NominalType']);
                           currsize := 1;
                           end;
                        104: begin // Category
                           currstr := vartostr(accsdatamodule.LastNLFileDB['Category']);
                           currsize := 10;
                           end;


                   end; // case
                   if currstr <> '' then begin
                        for j:=1 to length(currstr) do begin
                                 currdisp[j] := currstr[j];
                        end;
                   end
                   else FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
                   Currrec[db] := Accsdatamodule.LastNLFileDB.RecNo;
                   end;
       TxFileYr1 : begin
                   DY:=0;
                   MN:=0;
                   YR:=0;
                   case itemno of
                        1: begin // TxType
                           currint := accsdatamodule.TransactionsYr1DB['TxType'];
                           currsize := 4;
                           end;
                        2: begin //date (renamed Txdate in new table)
                           tempstring := copy(datetostr(accsdatamodule.TransactionsYr1DB['TxDate']),1,2);
                           tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsYr1DB['TxDate']),4,2);
                           if length(datetostr(accsdatamodule.TransactionsYr1DB['TxDate'])) = 10 then tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsYr1DB['TxDate']),9,2)
                                else tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsYr1DB['TxDate']),7,2);
                           currint := kdatetoint(tempstring);
                           kdatetostr(currint, currstr);
                           for J:=1 to 8 do begin
                               currdisp[j] := currstr[j];
                           end;
                           currsize := 8;
                           end;
                        3: begin // Account
                           currint := accsdatamodule.TransactionsYr1DB['Account'];
                           tempstring := vartostr(currint);
                           tempstring := padstring(tempstring,4);
                           for j:=1 to 4 do begin
                                 currdisp[j] := tempstring[j];
                              end;
                           currsize := 4;
                           end;
                        4: begin // Reference
                           currstr := varToStr(accsdatamodule.TransactionsYr1DB['Reference']);
                           for j:=1 to 8 do currdisp[j] := ' ';
                           for j:=1 to length(currstr) do begin
                                 currdisp[j] := currstr[j];
                              end;
                           currsize := 8;  //8
                           end;
                        5: begin // Descript
                           currstr := vartostr(accsdatamodule.TransactionsYr1DB['Descript']);
                           for j:=1 to 8 do currdisp[j] := ' ';
                           for j:=1 to length(currstr) do begin
                                 currdisp[j] := currstr[j];
                              end;
                           currsize := 30; //15
                           end;
                        6: begin // quantity
                           currlong := (accsdatamodule.TransactionsYr1DB['Quantity'] * 100);
                           currsize := 14;
                           end;
                        7: begin // Product
                           currint := accsdatamodule.TransactionsYr1DB['Product'];
                           currsize := 4;
                           end;
                        8: begin // Nominal
                           currint := accsdatamodule.TransactionsYr1DB['Nominal'];
                           currsize := 4;
                           end;
                        9: begin
                           currlong := (accsdatamodule.TransactionsYr1DB['Amount'] * 100);
                           currsize := 14;
                           end;
                        10: begin
                           currstr := vartostr(accsdatamodule.TransactionsYr1DB['Taxcode']);
                           currsize := 1;
                           if currstr = '' then currstr := ' ';
                           currdisp[1] := currstr[1];
                           end;
                        11: begin
                           currlong := (accsdatamodule.TransactionsYr1DB['TaxDisc'] * 100);
                           currsize := 14;
                           end;
                        12: begin
                           currint := accsdatamodule.TransactionsYr1DB['Analysis'];
                           currsize := 4;
                           end;
                        13: begin
                           currint := accsdatamodule.TransactionsYr1DB['NextDB'];
                           currsize := 5;
                           end;
                        14: begin
                           currint := accsdatamodule.TransactionsYr1DB['NextCR'];
                           currsize := 5;
                           end;
                        16: begin
                           currint := accsdatamodule.TransactionsYr1DB['NextSP'];
                           currsize := 5;
                           end;
                        17: begin
                           currlong := (accsdatamodule.TransactionsYr1DB['NomAmount'] * 100);
                           currsize := 14;
                           end;
                        18: begin
                           currint := accsdatamodule.TransactionsYr1DB['DebitAC'];
                           tempstring := vartostr(currint);
                           tempstring := padstring(tempstring,4);
                           for j:=1 to 4 do begin
                                 currdisp[j] := tempstring[j];
                              end;
                           currsize := 4;
                           end;
                        19: begin
                           currint := accsdatamodule.TransactionsYr1DB['CreditAC'];
                           tempstring := vartostr(currint);
                           tempstring := padstring(tempstring,4);
                           for j:=1 to 4 do begin
                                 currdisp[j] := tempstring[j];
                              end;
                           currsize := 4;
                           end;
                        23: begin
                           currint := accsdatamodule.TransactionsYr1DB['OrigType'];
                           currsize := 4;
                           end;
                        24: begin
                           currstr := vartostr(accsdatamodule.TransactionsYr1DB['Enterprise']);
                           currsize := 4;
                           end;
                        26: begin
                           currstr := vartostr(accsdatamodule.TransactionsYr1DB['StubNo']);
                           currsize := 8;
                           end;
                        27: begin
                           currstr := vartostr(accsdatamodule.TransactionsYr1DB['BankRec']);
                           currsize := 1;
                           end;
                        28: begin
                           currstr := varToStr(accsdatamodule.TransactionsYr1DB['EditStat']);
                           currsize := 1;
                           end;
                        29: begin
                           currlong := (accsdatamodule.TransactionsYr1DB['AmtPaid'] * 100);
                           currsize := 14;
                           end;
                        30: begin
                           currstr := vartostr(accsdatamodule.TransactionsYr1DB['Allocated']);
                           currsize := 1;
                           end;
                        31: begin
                              try
                              if accsdatamodule.TransactionsYr1DB['DueDate'].asstring <> '' then begin
                              tempstring := copy(datetostr(accsdatamodule.TransactionsYr1DB['DueDate']),1,2);
                              tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsYr1DB['DueDate']),4,2);
                              if length(datetostr(accsdatamodule.TransactionsYr1DB['DueDate'])) = 10 then tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsYr1DB['DueDate']),9,2)
                                else tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsYr1DB['DueDate']),7,2);
                              currint := kdatetoint(tempstring);
                              kdatetostr(currint, currstr);
                              for j:=1 to 8 do begin
                                 currdisp[j] := currstr[j];
                              end;
                              currsize := 8;
                              end;
                              except currsize := 8;
                              end;
                            end;
                            end;
                        Currrec[db] := Accsdatamodule.TransactionsYr1DB.RecNo; // This holds the current recno for each DB
                                                                            // this is read by the reports and used as tx no!
                   end;
       AnalFile : begin
                        case itemno of
                        2: begin
                              try currstr := accsdatamodule.AnalysisDB['Description'];
                              except
                              end;
                           end;
                        end;
                  end;
       TxFileYr2 : begin
                   DY:=0;
                   MN:=0;
                   YR:=0;
                   case itemno of
                        1: begin // TxType
                           currint := accsdatamodule.TransactionsYr2DB['TxType'];
                           currsize := 4;
                           end;
                        2: begin //date (renamed Txdate in new table)
                           tempstring := copy(datetostr(accsdatamodule.TransactionsYr2DB['TxDate']),1,2);
                           tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsYr2DB['TxDate']),4,2);
                           if length(datetostr(accsdatamodule.TransactionsYr2DB['TxDate'])) = 10 then tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsYr2DB['TxDate']),9,2)
                                else tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsYr2DB['TxDate']),7,2);
                           currint := kdatetoint(tempstring);
                           kdatetostr(currint, currstr);
                           for J:=1 to 8 do begin
                               currdisp[j] := currstr[j];
                           end;
                           currsize := 8;
                           end;
                        3: begin // Account
                           currint := accsdatamodule.TransactionsYr2DB['Account'];
                           tempstring := vartostr(currint);
                           tempstring := padstring(tempstring,4);
                           for j:=1 to 4 do begin
                                 currdisp[j] := tempstring[j];
                              end;
                           currsize := 4;
                           end;
                        4: begin // Reference
                           currstr := varToStr(accsdatamodule.TransactionsYr2DB['Reference']);
                           for j:=1 to 8 do currdisp[j] := ' ';
                           for j:=1 to length(currstr) do begin
                                 currdisp[j] := currstr[j];
                              end;
                           currsize := 8;  //8
                           end;
                        5: begin // Descript
                           currstr := vartostr(accsdatamodule.TransactionsYr2DB['Descript']);
                           for j:=1 to 8 do currdisp[j] := ' ';
                           for j:=1 to length(currstr) do begin
                                 currdisp[j] := currstr[j];
                              end;
                           currsize := 30; //15
                           end;
                        6: begin // quantity
                           currlong := (accsdatamodule.TransactionsYr2DB['Quantity'] * 100);
                           currsize := 14;
                           end;
                        7: begin // Product
                           currint := accsdatamodule.TransactionsYr2DB['Product'];
                           currsize := 4;
                           end;
                        8: begin // Nominal
                           currint := accsdatamodule.TransactionsYr2DB['Nominal'];
                           currsize := 4;
                           end;
                        9: begin
                           currlong := (accsdatamodule.TransactionsYr2DB['Amount'] * 100);
                           currsize := 14;
                           end;
                        10: begin
                           currstr := vartostr(accsdatamodule.TransactionsYr2DB['Taxcode']);
                           currsize := 1;
                           if currstr = '' then currstr := ' ';
                           currdisp[1] := currstr[1];
                           end;
                        11: begin
                           currlong := (accsdatamodule.TransactionsYr2DB['TaxDisc'] * 100);
                           currsize := 14;
                           end;
                        12: begin
                           currint := accsdatamodule.TransactionsYr2DB['Analysis'];
                           currsize := 4;
                           end;
                        13: begin
                           currint := accsdatamodule.TransactionsYr2DB['NextDB'];
                           currsize := 5;
                           end;
                        14: begin
                           currint := accsdatamodule.TransactionsYr2DB['NextCR'];
                           currsize := 5;
                           end;
                        16: begin
                           currint := accsdatamodule.TransactionsYr2DB['NextSP'];
                           currsize := 5;
                           end;
                        17: begin
                           currlong := (accsdatamodule.TransactionsYr2DB['NomAmount'] * 100);
                           currsize := 14;
                           end;
                        18: begin
                           currint := accsdatamodule.TransactionsYr2DB['DebitAC'];
                           tempstring := vartostr(currint);
                           tempstring := padstring(tempstring,4);
                           for j:=1 to 4 do begin
                                 currdisp[j] := tempstring[j];
                              end;
                           currsize := 4;
                           end;
                        19: begin
                           currint := accsdatamodule.TransactionsYr2DB['CreditAC'];
                           tempstring := vartostr(currint);
                           tempstring := padstring(tempstring,4);
                           for j:=1 to 4 do begin
                                 currdisp[j] := tempstring[j];
                              end;
                           currsize := 4;
                           end;
                        23: begin
                           currint := accsdatamodule.TransactionsYr2DB['OrigType'];
                           currsize := 4;
                           end;
                        24: begin
                           currstr := vartostr(accsdatamodule.TransactionsYr2DB['Enterprise']);
                           currsize := 4;
                           end;
                        26: begin
                           currstr := vartostr(accsdatamodule.TransactionsYr2DB['StubNo']);
                           currsize := 8;
                           end;
                        27: begin
                           currstr := vartostr(accsdatamodule.TransactionsYr2DB['BankRec']);
                           currsize := 1;
                           end;
                        28: begin
                           currstr := varToStr(accsdatamodule.TransactionsYr2DB['EditStat']);
                           currsize := 1;
                           end;
                        29: begin
                           currlong := (accsdatamodule.TransactionsYr2DB['AmtPaid'] * 100);
                           currsize := 14;
                           end;
                        30: begin
                           currstr := vartostr(accsdatamodule.TransactionsYr2DB['Allocated']);
                           currsize := 1;
                           end;
                        31: begin
                              try
                              if accsdatamodule.TransactionsYr2DB['DueDate'].asstring <> '' then begin
                              tempstring := copy(datetostr(accsdatamodule.TransactionsYr2DB['DueDate']),1,2);
                              tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsYr2DB['DueDate']),4,2);
                              if length(datetostr(accsdatamodule.TransactionsYr2DB['DueDate'])) = 10 then tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsYr2DB['DueDate']),9,2)
                                else tempstring := tempstring + '/' + copy(datetostr(accsdatamodule.TransactionsYr2DB['DueDate']),7,2);
                              currint := kdatetoint(tempstring);
                              kdatetostr(currint, currstr);
                              for j:=1 to 8 do begin
                                 currdisp[j] := currstr[j];
                              end;
                              currsize := 8;
                              end;
                              except currsize := 8;
                              end;
                            end;
                            end;
                        Currrec[db] := Accsdatamodule.TransactionsYr2DB.RecNo; // This holds the current recno for each DB
                                                                            // this is read by the reports and used as tx no!
                   end;


  else begin
      IF ERRORNO>0 THEN EXIT;
      IF CURRREC[DB]<1 THEN
         BEGIN
         ERRORNO:=10;
         EXIT;
         END;
      DY:=0;
      MN:=0;
      YR:=0;
      IF NOT (ITEMNO IN [1..MAXITEMS])    THEN EXIT ;
      IF DB1.DBITEMS[ITEMNO].DBINAME=NULL THEN EXIT ;
      CURRSIZE:=DB1.DBITEMS[ITEMNO].DBISIZE;
      IF DB1.DBITEMS[ITEMNO].DBITYPE='F' THEN
         BEGIN
         EXIT ;
         END;
      ITFST:=DB1.DBITEMS[ITEMNO].DBIOFSET;
      CASE DB1.DBITEMS[ITEMNO].DBITYPE[0] OF
      'C','D','N','T' : MOVE (DATWORK^[CURROFST[DB]+ITFST],CURRINT,2);
      'K'		    : BEGIN
			MOVE (DATWORK^[CURROFST[DB]+ITFST],CURRKONG,6);
			CURRLONG:=CURRKONG;
		      END;
      'L','M'	    : Begin
                           x := 0;
                           {
                           While (( DATWORK^[CURROFST[DB]+ITFST+x] = chr (0) ) Or
                                  ( DATWORK^[CURROFST[DB]+ITFST+x] = chr (255) ) And
                                  (x <= 10)) Do
                              inc (x);
                           While (DATWORK^[CURROFST[DB]+ITFST+x] In [chr (0),chr(255)]) and (x <= 10) do
                              inc (x);
                           }
                           If ( DATWORK^[CURROFST[DB]+ITFST] ) = chr ( 255 ) Then
                              fillchar (temp_val[0], sizeof (temp_val), chr (255))
                           Else
                              fillchar (temp_val[0], sizeof (temp_val), chr (0));

                           pos_x := 9;
                           temp_pos := 0;
                           While pos_x >= x Do
                               Begin
                                   MOVE (DATWORK^[CURROFST[DB]+ITFST+pos_x-1],
                                         Temp_val[temp_pos], 2);
                                   dec ( pos_x, 2 );
                                   inc ( temp_pos, 2 );
                               End;
                           Move ( temp_val[0], CurrLong, sizeof(currlong) );
                      End;
      '?'		    : MOVE (DATWORK^[CURROFST[DB]+ITFST],CURRDISP[1],1);
      'X','Y'	    : MOVE (DATWORK^[CURROFST[DB]+ITFST],CURRDISP[1],
				DB1.DBITEMS[ITEMNO].DBISIZE);
      END;
      IF DB1.DBITEMS[ITEMNO].DBITYPE[0] IN ['C','N','T'] THEN
         BEGIN
           STR (CURRINT,ST);
         REPEAT
           IF LENGTH(ST)<4 THEN ST:=CONCAT(SPACE1,ST);
         UNTIL NOT (LENGTH(ST)<4);
         MOVE (ST[1],CURRDISP[1],LENGTH(ST));
      END
      ELSE
        IF DB1.DBITEMS[ITEMNO].DBITYPE[0] IN ['K','L','M'] THEN
        BEGIN
        LONGSTR (CURRLONG,ST,DB1.DBITEMS[ITEMNO].DBITYPE[0]);
	SLIMLEFT (ST);
	IF ST<>NULL THEN MOVE (ST[1],CURRDISP[1],LENGTH(ST));
      END
      ELSE
      IF (DB1.DBITEMS[ITEMNO].DBITYPE[0]='D') AND (CURRINT<>0) THEN
      DATEDISP (ITEMNO,DY,MN,YR);
      SETSTR;
      If ( db1.dbitems[itemno].dbitype[0]='Y' ) And
         ( db1.dbitems[itemno].dbisize = 5 ) Then
         IntVal ( CurrInt, CurrStr );
  end;
  end; // Case
END;

PROCEDURE PUTITEM;
VAR
  ITFST : INTEGER;
  ST	: STRING132;
  pos_x,
  temp_pos     : Integer;
  tempstring : shortstring;
  i : integer;

BEGIN
  ERRORNO:=0;
  SETDB (DB);
    // Code for New Paradox Tx File
  case DB of
            NewTxFile : begin
                        accsdatamodule.TransactionsDB.edit;
                        case itemno of
                        1 : begin
                            Accsdatamodule.TransactionsDB.FieldValues['TxType'] := Currint;
                            end;
                        2 : begin
                            if currint <> 0 then begin
                            KDateToStr(Currint,Tempstring);
                            Accsdatamodule.TransactionsDB.FieldValues['TxDate'] := StrToDate(Tempstring);
                                end;
                            end;
                        3 : begin
                            Accsdatamodule.TransactionsDB.FieldValues['Account'] := Currint;
                            end;
                        4 : begin
                            currstr := '';
                            for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                            slimall(currstr);
                            Accsdatamodule.TransactionsDB.FieldValues['Reference'] := Currstr;
                            end;
                        5 : begin
                            currstr := '';
                            for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                            slimall(currstr);
                            Accsdatamodule.TransactionsDB.FieldValues['Descript'] := Currstr;
                            end;
                        6 : begin
                            if Currlong = 538976288 then Currlong := 0;
                               Accsdatamodule.TransactionsDB.FieldValues['Quantity'] := CurrLong/100;
                            end;
                        7 : begin
                            Accsdatamodule.TransactionsDB.FieldValues['Product'] := Currint;
                            end;
                        8 : begin
                            Accsdatamodule.TransactionsDB.FieldValues['Nominal'] := Currint;
                            end;
                        9 : begin
                            if Currlong = 538976288 then Currlong := 0;
                            Accsdatamodule.TransactionsDB.FieldValues['Amount'] := CurrLong/100;
                            end;
                        10 : begin
                           //if CurrStr = '8224' then CurrStr := '';
                           Accsdatamodule.TransactionsDB.FieldValues['TaxCode'] := currdisp[1]; //Currstr;
                           end;
                        11 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           Accsdatamodule.TransactionsDB.FieldValues['TaxDisc'] := CurrLong/100;
                           end;
                        12 : begin
                           Accsdatamodule.TransactionsDB.FieldValues['Analysis'] := Currint;
                           end;
                        13 : begin
                           Accsdatamodule.TransactionsDB.FieldValues['NextDB'] := Currint;
                           end;
                        14 : begin
                           Accsdatamodule.TransactionsDB.FieldValues['NextCR'] := Currint;
                           end;
                        16 : begin
                           Accsdatamodule.TransactionsDB.FieldValues['NextSP'] := Currint;
                           end;
                        17 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           Accsdatamodule.TransactionsDB.FieldValues['NomAmount'] := CurrLong/100;
                           end;
                        18 : begin
                           Accsdatamodule.TransactionsDB.FieldValues['DebitAC'] := Currint;
                           end;
                        19 : begin
                           Accsdatamodule.TransactionsDB.FieldValues['CreditAC'] := Currint;
                           end;
                        23 : begin
                           Accsdatamodule.TransactionsDB.FieldValues['OrigType'] := Currint;
                           end;
                        24 : begin
                           //if CurrStr = '8224' then CurrStr := '';
                           currstr := currdisp[1];
                           if currdisp[2] <> '' then currstr := currstr + currdisp[2];
                           if currdisp[3] <> '' then currstr := currstr + currdisp[3];
                           if currdisp[4] <> '' then currstr := currstr + currdisp[4];
                           Accsdatamodule.TransactionsDB.FieldValues['Enterprise'] := Currstr;
                           end;
                        26 : begin
                           currstr := '';
                           for i:=1 to 64 do begin
                               currstr := currstr + currdisp[i];
                           end;
                           slimall(currstr);
                           Accsdatamodule.TransactionsDB.FieldValues['StubNo'] := Currstr;
                           end;
                        27 : begin
                           //if CurrStr = '8224' then CurrStr := '';
                           Accsdatamodule.TransactionsDB.FieldValues['BankRec'] := Currdisp[1];
                           end;
                        28 : begin
                           //if CurrStr = '8224' then CurrStr := '';
                           Accsdatamodule.TransactionsDB.FieldValues['EditStat'] := Currdisp[1];
                           end;
                        29 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           Accsdatamodule.TransactionsDB.FieldValues['AmtPaid'] := CurrLong/100;
                           end;
                        30 : begin
                           //if CurrStr = '8224' then CurrStr := '';
                           Accsdatamodule.TransactionsDB.FieldValues['Allocated'] := Currdisp[1];
                           end;
                        31 : begin
                           if currint <> 0 then begin
                              KDateToStr(Currint,Tempstring);
                              Accsdatamodule.TransactionsDB.FieldValues['DateDue'] := StrToDate(Tempstring);
                              end;
                           end;
                        32 : begin                                                                           // TGB AB 01/02/13
                            if Currlong = 538976288 then Currlong := 0;                                      // TGB AB 01/02/13
                               Accsdatamodule.TransactionsDB.FieldValues['Quantity2'] := CurrLong/100;      // TGB AB 01/02/13
                            end;                                                                             // TGB AB 01/02/13
                        33 : begin                                                                           // TGB AB 01/02/13
                            if Currlong = 538976288 then Currlong := 0;                                      // TGB AB 01/02/13
                               Accsdatamodule.TransactionsDB.FieldValues['Quantity3'] := CurrLong/100;      // TGB AB 01/02/13
                            end;
                        100 : begin
                            Accsdatamodule.TransactionsDB.FieldValues['AmtPaid'] := CurrLong/100;
                            end;
                        101 : begin
                            Accsdatamodule.TransactionsDB.FieldValues['AllocatedVATAmount'] := CurrLong/100;
                            end;
                        end;
                        Accsdatamodule.transactionsdb.post;
                        end;

            EntFile : begin
                      Accsdatamodule.EntsFileDB.Edit;
                      case itemno of
                         1 : begin
                            for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                            slimall(currstr);
                            Accsdatamodule.EntsFileDB.FieldValues['EntCode'] := Currstr;
                            end;
                         2 : begin
                            for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                            slimall(currstr);
                            Accsdatamodule.EntsFileDB.FieldValues['EntName'] := Currstr;
                            end;
                         3 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           Accsdatamodule.EntsFileDB.FieldValues['UnitDiv'] := CurrLong/100;
                           end;
                         4 : begin
                            currstr := '';
                            for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                            slimall(currstr);
                            Accsdatamodule.EntsFileDB.FieldValues['UnitText'] := Currstr;
                            end;
                         6 : begin
                           Accsdatamodule.EntsFileDB.FieldValues['IncFrom'] := Currint;
                           end;
                         7 : begin
                           Accsdatamodule.EntsFileDB.FieldValues['IncTo'] := Currint;
                           end;
                         8 : begin
                           Accsdatamodule.EntsFileDB.FieldValues['ExpFrom'] := Currint;
                           end;
                         9 : begin
                           Accsdatamodule.EntsFileDB.FieldValues['ExpTo'] := Currint;
                           end;
                         10 : begin
                           Accsdatamodule.EntsFileDB.FieldValues['CosFrom'] := Currint;
                           end;
                         11 : begin
                           Accsdatamodule.EntsFileDB.FieldValues['CosTo'] := Currint;
                           end;
                         12 : begin                                                                  // TGM AB 01/02/13
                            currstr := '';                                                           // TGM AB 01/02/13
                            for i:=1 to 64 do begin                                                  // TGM AB 01/02/13
                                currstr := currstr + currdisp[i];                                    // TGM AB 01/02/13
                                end;                                                                 // TGM AB 01/02/13
                            slimall(currstr);                                                        // TGM AB 01/02/13
                            Accsdatamodule.EntsFileDB.FieldValues['Quantity2Name'] := Currstr;       // TGM AB 01/02/13
                            end;                                                                     // TGM AB 01/02/13
                         13 : begin                                                                  // TGM AB 01/02/13
                            currstr := '';                                                           // TGM AB 01/02/13
                            for i:=1 to 64 do begin                                                  // TGM AB 01/02/13
                                currstr := currstr + currdisp[i];                                    // TGM AB 01/02/13
                                end;                                                                 // TGM AB 01/02/13
                            slimall(currstr);                                                        // TGM AB 01/02/13
                            Accsdatamodule.EntsFileDB.FieldValues['Quantity3Name'] := Currstr;       // TGM AB 01/02/13
                            end;                                                                     // TGM AB 01/02/13

                      end;
                      Accsdatamodule.EntsFileDB.post;
                    end;
            SLFile : Begin
                     Accsdatamodule.SLFileDB.edit;
                     case itemno of
                        1: begin // Name
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['Name'] := currstr;
                           end;
                        2: begin // Address1
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['Address1'] := currstr;
                           end;
                        3: begin // Address2
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['Address2'] := currstr;
                           end;
                        4: begin // Address3
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['Address3'] := currstr;
                           end;
                        5: begin // Address4
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['Address4'] := currstr;
                           end;
                        6: begin // Balance-BF
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.SLFileDB['BalanceBF'] := Currlong/100;
                           end;
                        7: begin // Balance
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.SLFileDB['Balance'] := Currlong/100;
                           end;
                        8: begin // Turnover
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.SLFileDB['Turnover'] := Currlong/100;
                           end;
                        9: begin // Age-Curr
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.SLFileDB['AgeCurr'] := Currlong/100;
                           end;
                        10: begin // Age1
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.SLFileDB['Age1'] := Currlong/100;
                           end;
                        11: begin // Age2
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.SLFileDB['Age2'] := Currlong/100;
                           end;
                        12: begin // Age3
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.SLFileDB['Age3'] := Currlong/100;
                           end;
                        13: begin // Not-Alloc
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.SLFileDB['NotAlloc'] := Currlong/100;
                           end;
                        14: begin // First-Year
                           accsdatamodule.SLFileDB['FirstYear'] := currint;
                           end;
                        15: begin // First-Tx
                           accsdatamodule.SLFileDB['FirstTx'] := currint;
                           end;
                        16: begin // Last-Tx
                           accsdatamodule.SLFileDB['LastTx'] := currint;
                           end;
                        17: begin // BalanceST
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.SLFileDB['BalanceST'] := Currlong/100;
                           end;
                        18: begin
                              if currint <> 0 then begin
                                 KDateToStr(Currint,Tempstring);
                                 accsdatamodule.SLFileDB['PayDate'] := StrToDate(Tempstring);
                              end;
                           end;
                        19: begin // Phone-No1
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['PhoneNo1'] := currstr;
                           end;
                        20: begin // Phone-No2
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['PhoneNo2'] := currstr;
                           end;
                        21: begin // Fax-No
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['FaxNo'] := currstr;
                           end;
                        22: begin // Area-Code
                           accsdatamodule.SLFileDB['AreaCode'] := currint;
                           end;
                        23: begin // Post-Code
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['PostCode'] := currstr;
                           end;
                        24: begin // Cust-Ref
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['CustRef'] := currstr;
                           end;
                        25: begin // Contact1
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['Contact1'] := currstr;
                           end;
                        26: begin // Contact2
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['Contact2'] := currstr;
                           end;
                        27: begin // VAT-No
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['VATNo'] := currstr;
                           end;
                        28: begin // Comment1
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['Comment1'] := currstr;
                           end;
                        29: begin // Comment2
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['Comment2'] := currstr;
                           end;
                        30: begin // Comment3
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['Comment3'] := currstr;
                           end;
                        31: begin // New Field Address 5
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['Address5'] := currstr;
                           end;
                        32: begin // Email
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.SLFileDB['Email'] := currstr;
                           end;
                    end;
                   Accsdatamodule.SLFileDB.post;
                   FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
                   CURRSIZE:=0;
                   CURRINT :=0;
                   CURRLONG:=0;
                   CURRSTR :=NULL;
                   end; // case
       PLFile : Begin
                     Accsdatamodule.PLFileDB.edit;
                     case itemno of
                        1: begin // Name
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['Name'] := currstr;
                           end;
                        2: begin // Address1
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['Address1'] := currstr;
                           end;
                        3: begin // Address2
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['Address2'] := currstr;
                           end;
                        4: begin // Address3
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['Address3'] := currstr;
                           end;
                        5: begin // Address4
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['Address4'] := currstr;
                           end;
                        6: begin // Balance-BF
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.PLFileDB['BalanceBF'] := Currlong/100;
                           end;
                        7: begin // Balance
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.PLFileDB['Balance'] := Currlong/100;
                           end;
                        8: begin // Turnover
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.PLFileDB['Turnover'] := Currlong/100;
                           end;
                        9: begin // Age-Curr
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.PLFileDB['AgeCurr'] := Currlong/100;
                           end;
                        10: begin // Age1
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.PLFileDB['Age1'] := Currlong/100;
                           end;
                        11: begin // Age2
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.PLFileDB['Age2'] := Currlong/100;
                           end;
                        12: begin // Age3
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.PLFileDB['Age3'] := Currlong/100;
                           end;
                        13: begin // Not-Alloc
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.PLFileDB['NotAlloc'] := Currlong/100;
                           end;
                        14: begin // First-Year
                           accsdatamodule.PLFileDB['FirstYear'] := currint;
                           end;
                        15: begin // First-Tx
                           accsdatamodule.PLFileDB['FirstTx'] := currint;
                           end;
                        16: begin // Last-Tx
                           accsdatamodule.PLFileDB['LastTx'] := currint;
                           end;
                        17: begin // BalanceST
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.PLFileDB['BalanceST'] := Currlong/100;
                           end;
                        18: begin
                              if currint <> 0 then begin
                                 KDateToStr(Currint,Tempstring);
                                 accsdatamodule.PLFileDB['PayDate'] := StrToDate(Tempstring);
                              end;
                           end;
                        19: begin // Phone-No1
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['PhoneNo1'] := currstr;
                           end;
                        20: begin // Phone-No2
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['PhoneNo2'] := currstr;
                           end;
                        21: begin // Fax-No
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['FaxNo'] := currstr;
                           end;
                        22: begin // Area-Code
                           accsdatamodule.PLFileDB['AreaCode'] := currint;
                           end;
                        23: begin // Post-Code
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['PostCode'] := currstr;
                           end;
                        24: begin // Cust-Ref
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['CustRef'] := currstr;
                           end;
                        25: begin // Contact1
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['Contact1'] := currstr;
                           end;
                        26: begin // Contact2
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['Contact2'] := currstr;
                           end;
                        27: begin // VAT-No
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['VATNo'] := currstr;
                           end;
                        28: begin // Comment1
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['Comment1'] := currstr;
                           end;
                        29: begin // Comment2
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['Comment2'] := currstr;
                           end;
                        30: begin // Comment3
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['Comment3'] := currstr;
                           end;
                        31: begin // New Field Address 5
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['Address5'] := currstr;
                           end;
                        32: begin // Email
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.PLFileDB['Email'] := currstr;
                           end;
                   end;
                   Accsdatamodule.PLFileDB.post;
                   FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
                   CURRSIZE:=0;
                   CURRINT :=0;
                   CURRLONG:=0;
                   CURRSTR :=NULL;
                   end; // case
       NLFile : begin
                      Accsdatamodule.NLFileDB.Edit;
                      Currstr := '';
                      case itemno of
                         1 : begin
                            for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                            slimall(currstr);
                            Accsdatamodule.NLFileDB.FieldValues['Name'] := Currstr;
                            end;
                         2 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['Balance'] := Currlong/100;
                           end;
                         3 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['STPeriod'] := Currlong/100;
                           end;
                         4 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['STYear'] := Currlong/100;
                           end;
                         5 : begin
                           accsdatamodule.NLFileDB['RepGroup'] := currint;
                           end;
                         6 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['STWeek'] := Currlong/100;
                           end;
                         7 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudgYear'] := Currlong/100;
                           end;
                         14 : begin
                           accsdatamodule.NLFileDB['FirstBank'] := currint;
                           end;
                         15 : begin
                           accsdatamodule.NLFileDB['FirstTx'] := currint;
                           end;
                         16 : begin
                           accsdatamodule.NLFileDB['LastTx'] := currint;
                           end;
                         17 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['YearTot1'] := Currlong/100;
                           end;
                         18 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['YearTot2'] := Currlong/100;
                           end;
                         19 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['YearTot3'] := Currlong/100;
                           end;
                         20 : begin
                            for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                            slimall(currstr);
                            Accsdatamodule.NLFileDB.FieldValues['TaxCode'] := Currstr;
                            end;
                         21 : begin
                            for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                            slimall(currstr);
                            Accsdatamodule.NLFileDB.FieldValues['Repflag'] := Currstr;
                            end;
                         22 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BalanceST'] := Currlong/100;
                           end;
                         24 : begin
                            for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                            slimall(currstr);
                            Accsdatamodule.NLFileDB.FieldValues['Enterprise'] := Currstr;
                            end;
                         33 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer01'] := Currlong/100;
                           end;
                         34 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer02'] := Currlong/100;
                           end;
                         35 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer03'] := Currlong/100;
                           end;
                         36 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer04'] := Currlong/100;
                           end;
                         37 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer05'] := Currlong/100;
                           end;
                         38 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer06'] := Currlong/100;
                           end;
                         39 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer07'] := Currlong/100;
                           end;
                         40 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer08'] := Currlong/100;
                           end;
                         41 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer09'] := Currlong/100;
                           end;
                         42 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer10'] := Currlong/100;
                           end;
                         43 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer11'] := Currlong/100;
                           end;
                         44 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer12'] := Currlong/100;
                           end;
                         45 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['BudPer13'] := Currlong/100;
                           end;
                         49 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer01'] := Currlong/100;
                           end;
                         50 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer02'] := Currlong/100;
                           end;
                         51 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer03'] := Currlong/100;
                           end;
                         52 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer04'] := Currlong/100;
                           end;
                         53 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer05'] := Currlong/100;
                           end;
                         54 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer06'] := Currlong/100;
                           end;
                         55 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer07'] := Currlong/100;
                           end;
                         56 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer08'] := Currlong/100;
                           end;
                         57 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer09'] := Currlong/100;
                           end;
                         58 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer10'] := Currlong/100;
                           end;
                         59 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer11'] := Currlong/100;
                           end;
                         60 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer12'] := Currlong/100;
                           end;
                         61 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['ActPer13'] := Currlong/100;
                           end;
                         65 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer01'] := Currlong/100;
                           end;
                         66 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer02'] := Currlong/100;
                           end;
                         67 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer03'] := Currlong/100;
                           end;
                         68 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer04'] := Currlong/100;
                           end;
                         69 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer05'] := Currlong/100;
                           end;
                         70 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer06'] := Currlong/100;
                           end;
                         71 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer07'] := Currlong/100;
                           end;
                         72 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer08'] := Currlong/100;
                           end;
                         73 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer09'] := Currlong/100;
                           end;
                         74 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer10'] := Currlong/100;
                           end;
                         75 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer11'] := Currlong/100;
                           end;
                         76 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer12'] := Currlong/100;
                           end;
                         77 : begin
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['LstPer13'] := Currlong/100;
                           end;
                         101: begin // DepRate
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['DepRate'] := Currlong/100;
                           end;
                        102: begin // DepAmount
                           if Currlong = 538976288 then Currlong := 0;
                           accsdatamodule.NLFileDB['DepAmount'] := Currlong/100;
                           end;
                        103: begin // NominalType
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.NLFileDB['NominalType'] := currstr;
                           end;
                        104: begin // Category
                           for i:=1 to 64 do begin
                                currstr := currstr + currdisp[i];
                                end;
                           slimall(currstr);
                           accsdatamodule.NLFileDB['Category'] := currstr;
                           end;
                      end;
                      Accsdatamodule.NLFileDB.post;
                      FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
                      CURRSIZE:=0;
                      CURRINT :=0;
                      CURRLONG:=0;
                      CURRSTR :=NULL;
                   end
  else begin

  IF ERRORNO>0 THEN EXIT ;
  IF CURRREC[DB]<1 THEN
    BEGIN
      ERRORNO:=10;
      EXIT ;
    END;
  IF (ITEMNO<1) OR (ITEMNO>MAXITEMS) THEN
    BEGIN
      ERRORNO:=16;
      EXIT ;
    END;
  IF DB1.DBITEMS[ITEMNO].DBINAME=NULL THEN
    BEGIN
      ERRORNO:=16;
      EXIT ;
    END;
  ITFST:=DB1.DBITEMS[ITEMNO].DBIOFSET;

  CASE DB1.DBITEMS[ITEMNO].DBITYPE[0] OF
    'C'	    : MOVE (CURRINT,DATWORK^[CURROFST[DB]+ITFST],2);
    'D','E' : MOVE (CURRINT,DATWORK^[CURROFST[DB]+ITFST],2);
    'T'	    : MOVE (CURRINT,DATWORK^[CURROFST[DB]+ITFST],2);
    'N'	    : MOVE (CURRINT,DATWORK^[CURROFST[DB]+ITFST],2);
    'K'	    : BEGIN
		CURRKONG:=CURRLONG;
		MOVE (CURRKONG,DATWORK^[CURROFST[DB]+ITFST],6);
	      END;
    'L','M' : Begin
                   If ( currlong >= 0 ) Then
                      fillchar (temp_val[0], sizeof (temp_val), chr (0))
                   Else
                      fillchar (temp_val[0], sizeof (temp_val), chr (255));
                   MOVE (currlong,Temp_val[0],sizeof(currlong));
                   pos_x := 0;
                   temp_pos := 8;
                   While pos_x < 9 Do
                      Begin
                         MOVE (temp_Val[temp_pos],
                               DATWORK^[CURROFST[DB]+ITFST+pos_x], 2);
                         inc ( pos_x, 2 );
                         dec ( temp_pos, 2 );
                      End;
              End;
    '?'	    : MOVE (CURRDISP[1],DATWORK^[CURROFST[DB]+ITFST],1);
    'X'	    : MOVE (CURRDISP[1],DATWORK^[CURROFST[DB]+ITFST],
			DB1.DBITEMS[ITEMNO].DBISIZE);
    'Y'	    : BEGIN
                   IF DB1.DBITEMS[ITEMNO].DBISIZE=5 THEN
		      BEGIN
		           STR (CURRINT,ST);
		           WHILE LENGTH(ST)<5 DO ST:=CONCAT('0',ST);
                      END
                   ELSE
               	       Begin
                            ST:=CONCAT(SPACE30,SPACE30,SPACE4);
		            MOVE (CURRDISP[1],ST[1],DB1.DBITEMS[ITEMNO].DBISIZE);
		            SlimAll (ST);
		            REPEAT
		                  IF LENGTH(ST)<DB1.DBITEMS[ITEMNO].DBISIZE THEN
		                     ST:=CONCAT(ZERO,ST);
                            UNTIL NOT (LENGTH(ST)<DB1.DBITEMS[ITEMNO].DBISIZE);
                       End;
                   MOVE (ST[1],DATWORK^[CURROFST[DB]+ITFST],
				DB1.DBITEMS[ITEMNO].DBISIZE);
              END;
  END;
  End;
  End; //else
END;

FUNCTION RECACTIVE;
BEGIN
  RECACTIVE:=FALSE;
  ERRORNO:=0;
  SETDB (DB);
  IF ERRORNO>0 THEN EXIT ;
  case DB of

          NewTxFile, TxFileYr1, TxFileYr2, AnalFile : Recactive := true;

          EntFile : if accsdatamodule.EntsFileDB['Active'] = true then recactive := true;

          SLFile : if accsdatamodule.SLFileDB['Active'] = true then recactive := true;

          PLFile : if accsdatamodule.PLFileDB['Active'] = true then recactive := true;

          NLFile : if accsdatamodule.NLFileDB['Active'] = true then recactive := true;

          LastNLFile : if accsdatamodule.LastNLFileDB['Active'] = true then recactive := true;
  end;

END;

PROCEDURE READREC;
VAR
  BLKNO : INTEGER;
  SUB	: INTEGER;
BEGIN
  currrec[DB] := RecNo;
  ERRORNO:=0;
  case db of
            NewTxFile : begin
                        try accsdatamodule.TransactionsDB.locate('TxNo',RecNo,[]);
                            CURRREC [DB]:=RECNO;
                        except showmessage('Cannot find Transaction File Record No. ' + vartostr(recno));
                        end;
                        end;
            AnalFile : begin
                        try accsdatamodule.AnalysisDB.locate('Number',RecNo,[]);
                        except showmessage('Cannot find Analysis File Record No. ' + vartostr(recno));
                        end;
                        end;
            TxFileYr1 : begin
                        try accsdatamodule.TransactionsYr1DB.locate('TxNo',RecNo,[]);
                        except showmessage('Cannot find Transaction Yr 1 File Record No. ' + vartostr(recno));
                        end;
                        end;
            TxFileYr2 : begin
                        try accsdatamodule.TransactionsYr2DB.locate('TxNo',RecNo,[]);
                        except showmessage('Cannot find Transaction Yr 2 File Record No. ' + vartostr(recno));
                        end;
                        end;
            NLFile : begin
                        try accsdatamodule.NLFileDB.locate('NLNo',RecNo,[]);
                        except showmessage('Cannot find Nominal File Record No. ' + vartostr(recno));
                        end;
                        end;
            LastNLFile : begin
                        try accsdatamodule.LastNLFileDB.locate('NLNo',RecNo,[]);
                        except showmessage('Cannot find Last Nominal File Record No. ' + vartostr(recno));
                        end;
                        end;
            EntFile : begin
                        if RecNo = (db1.dbrechigh + 1) then begin
                            Accsdatamodule.EntsFileDB.append;
                            Accsdatamodule.EntsFileDB.post;
                        end;
                        try accsdatamodule.EntsFileDB.locate('EntNo',RecNo,[]);
                        except showmessage('Cannot find Enterprise File Record No. ' + vartostr(recno));
                        end;
                        end;
            SLFile : begin
                        if RecNo = (db1.dbrechigh + 1) then begin
                            Accsdatamodule.SLFileDB.append;
                            Accsdatamodule.SLFileDB.post;
                        end;
                        try accsdatamodule.SLFileDB.locate('SLNo',RecNo,[]);
                        except showmessage('Cannot find SLFile Record No. ' + vartostr(recno));
                        end;
                        end;
            PLFile : begin
                        if RecNo = (db1.dbrechigh + 1) then begin
                            Accsdatamodule.PLFileDB.append;
                            Accsdatamodule.PLFileDB.post;
                        end;
                        try accsdatamodule.PLFileDB.locate('PLNo',RecNo,[]);
                        except showmessage('Cannot find PLFile Record No. ' + vartostr(recno));
                        end;
                        end;
  else begin
  ERRORNO:=0;
  SETDB (DB);
  IF ERRORNO>0 THEN EXIT ;
  CURRREC [DB]:=0;
  CURROFST[DB]:=0;
  IF (RECNO<1) OR (RECNO>DB1.DBRECTOT) THEN
    BEGIN
      ERRORNO:=5;
      EXIT ;
    END;
  BLKNO:=((RECNO-1) DIV DB1.DBRECBLK);
  SUB:=RECNO-(DB1.DBRECBLK*BLKNO);
  IF BLKNO<>CURRDATBLK[DB] THEN
    BEGIN
      IF CREAD (DB,2,(BLKNO*2)+DB1.DBDATAS)<2
	THEN EXIT
	ELSE MOVE(CBLOCKS,DATWORK^[1],1024);
      CURRDATBLK[DB]:=BLKNO;
    END;
  CURRREC [DB]:=RECNO;
  CURROFST[DB]:=((SUB-1)*DB1.DBRECSZ);
  end;
  end; // case
END;


PROCEDURE CLOSEDB;
BEGIN
  // TGM AB Code added to handle Paradox DB
  case db of
          NewTxfile : begin
                      CURRDB:=0;
                      try accsdatamodule.TransactionsDB.close;
                      except AbortProgram ('Error Closing Transactions File');
                      end;
                     end;
          Entfile : begin
                      CURRDB:=0;
                      try accsdatamodule.EntsFileDB.close;
                      except AbortProgram ('Error Closing Enterprise File');
                      end;
                    end;
          SLfile : begin
                      CURRDB:=0;
                      try accsdatamodule.SLFileDB.close;
                      except AbortProgram ('Error Closing SLFile');
                      end;
                    end;
          PLfile : begin
                      CURRDB:=0;
                      try accsdatamodule.PLFileDB.close;
                      except AbortProgram ('Error Closing PLFile');
                      end;
                    end;
          NLfile : begin
                      CURRDB:=0;
                      try accsdatamodule.NLFileDB.close;
                      except AbortProgram ('Error Closing NLFile');
                      end;
                    end;
          LastNLfile : begin
                      CURRDB:=0;
                      try accsdatamodule.LastNLFileDB.close;
                      except AbortProgram ('Error Closing Last NLFile');
                      end;
                    end;
  else begin
      ERRORNO:=0;
      SETDB (DB);
      IF ERRORNO>0 THEN EXIT ;
      CCLOSE (DB,'N');
      {DOS_FLUSH;}
      CURRDATBLK[DB]:=-10;
      DBOPEN    [DB]:=FALSE;
      CURRDB:=0;
  end;
  end; //case
END;

PROCEDURE BLANKREC;
VAR
  X : INTEGER;
BEGIN
  Case DB Of
          NewTxFile : accsdatamodule.transactionsdb.append;
          EntFile : begin
                    //accsdatamodule.EntsFileDB.locate('EntNo',RecNo,[]);
                    accsdatamodule.EntsFiledb.edit;
                    accsdatamodule.EntsFiledb['Active'] := True;
                    accsdatamodule.EntsFileDB.post;
                    end;
          SLFile : begin
                    accsdatamodule.SLFileDB.edit;
                    accsdatamodule.SLFileDB['Active'] := True;
                    accsdatamodule.SLFileDB['Name'] := '';
                    accsdatamodule.SLFileDB['Address1'] := '';
                    accsdatamodule.SLFileDB['Address2'] := '';
                    accsdatamodule.SLFileDB['Address3'] := '';
                    accsdatamodule.SLFileDB['Address4'] := '';
                    accsdatamodule.SLFileDB['BalanceBF'] := 0;
                    accsdatamodule.SLFileDB['Balance'] := 0;
                    accsdatamodule.SLFileDB['Turnover'] := 0;
                    accsdatamodule.SLFileDB['AgeCurr'] := 0;
                    accsdatamodule.SLFileDB['Age1'] := 0;
                    accsdatamodule.SLFileDB['Age2'] := 0;
                    accsdatamodule.SLFileDB['Age3'] := 0;
                    accsdatamodule.SLFileDB['NotAlloc'] := 0;
                    accsdatamodule.SLFileDB['FirstYear'] := 0;
                    accsdatamodule.SLFileDB['FirstTx'] := 0;
                    accsdatamodule.SLFileDB['LastTx'] := 0;
                    accsdatamodule.SLFileDB['BalanceST'] := 0;
                    accsdatamodule.SLFileDB['PhoneNo1'] := '';
                    accsdatamodule.SLFileDB['PhoneNo2'] := '';
                    accsdatamodule.SLFileDB['FaxNo'] := '';
                    accsdatamodule.SLFileDB['AreaCode'] := 0;
                    accsdatamodule.SLFileDB['PostCode'] := '';
                    accsdatamodule.SLFileDB['CustRef'] := '';
                    accsdatamodule.SLFileDB['Contact1'] := '';
                    accsdatamodule.SLFileDB['Contact2'] := '';
                    accsdatamodule.SLFileDB['VATNo'] := '';
                    accsdatamodule.SLFileDB['Comment1'] := '';
                    accsdatamodule.SLFileDB['Comment2'] := '';
                    accsdatamodule.SLFileDB['Comment3'] := '';
                    accsdatamodule.SLFileDB['Address5'] := '';
                    accsdatamodule.SLFileDB['Email'] := '';
                    accsdatamodule.SLFileDB.post;
                    end;
          PLFile : begin
                    accsdatamodule.PLFileDB.edit;
                    accsdatamodule.PLFileDB['Active'] := True;
                    accsdatamodule.PLFileDB['Name'] := '';
                    accsdatamodule.PLFileDB['Address1'] := '';
                    accsdatamodule.PLFileDB['Address2'] := '';
                    accsdatamodule.PLFileDB['Address3'] := '';
                    accsdatamodule.PLFileDB['Address4'] := '';
                    accsdatamodule.PLFileDB['BalanceBF'] := 0;
                    accsdatamodule.PLFileDB['Balance'] := 0;
                    accsdatamodule.PLFileDB['Turnover'] := 0;
                    accsdatamodule.PLFileDB['AgeCurr'] := 0;
                    accsdatamodule.PLFileDB['Age1'] := 0;
                    accsdatamodule.PLFileDB['Age2'] := 0;
                    accsdatamodule.PLFileDB['Age3'] := 0;
                    accsdatamodule.PLFileDB['NotAlloc'] := 0;
                    accsdatamodule.PLFileDB['FirstYear'] := 0;
                    accsdatamodule.PLFileDB['FirstTx'] := 0;
                    accsdatamodule.PLFileDB['LastTx'] := 0;
                    accsdatamodule.PLFileDB['BalanceST'] := 0;
                    accsdatamodule.PLFileDB['PhoneNo1'] := '';
                    accsdatamodule.PLFileDB['PhoneNo2'] := '';
                    accsdatamodule.PLFileDB['FaxNo'] := '';
                    accsdatamodule.PLFileDB['AreaCode'] := 0;
                    accsdatamodule.PLFileDB['PostCode'] := '';
                    accsdatamodule.PLFileDB['CustRef'] := '';
                    accsdatamodule.PLFileDB['Contact1'] := '';
                    accsdatamodule.PLFileDB['Contact2'] := '';
                    accsdatamodule.PLFileDB['VATNo'] := '';
                    accsdatamodule.PLFileDB['Comment1'] := '';
                    accsdatamodule.PLFileDB['Comment2'] := '';
                    accsdatamodule.PLFileDB['Comment3'] := '';
                    accsdatamodule.PLFileDB['Address5'] := '';
                    accsdatamodule.PLFileDB['Email'] := '';
                    accsdatamodule.PLFileDB.post;
                    end;
          NLFile : begin
                    accsdatamodule.NLFileDB.edit;
                    accsdatamodule.NLFileDB['Active'] := True;
                    accsdatamodule.NLFileDB.post;
                    end;
  else begin
  ERRORNO:=0;
  SETDB (DB);
  IF ERRORNO>0	   THEN EXIT ;
  IF CURRREC[DB]<1 THEN EXIT ;
  CURRINT :=0;
  FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
  CURRLONG:=0;
  CURRSTR :=NULL;
  FILLCHAR (DATWORK^[CURROFST[DB]+1],DB1.DBRECSZ,SPACE1);
  FOR X:=1 TO MAXITEMS DO
    IF (DB1.DBITEMS[X].DBINAME<>NULL) AND (DB1.DBITEMS[X].DBIRECSZ>0) THEN
      PUTITEM (DB,X);
  IF ADDDEL='A' THEN DATWORK^[CURROFST[DB]+1]:='A';
  end;
  end;
END;

Procedure SETITEM;
Begin
  CurrInt  := 0;
  CurrLong := 0;
  FillChar ( CurrDisp[1], 64, ' ' );
  CurrStr  := '';
End;

Function PSysLongToDelphi ( ValArray : Array Of Char ) : LongInt;
Var
   pos_x,
   temp_pos,
   x : Integer;
   TempLong : LongInt;
Begin
{-->>     PSysLongToDelphi := 0;}
     x := 0;

     While (ValArray[x] In [chr (0),chr(255)]) and (x < (SizeOf(ValArray)-1)) do
        inc (x);

     If ( ValArray[0] ) = chr ( 255 ) Then
        fillchar (temp_val[0], sizeof (temp_val), chr (255))
     Else
        fillchar (temp_val[0], sizeof (temp_val), chr (0));

     pos_x := SizeOf(ValArray)-1;
     temp_pos := 0;
     While pos_x >= x Do
           Begin
                Move ( ValArray[pos_x-1],
                       Temp_val[temp_pos], 2);
                Dec ( pos_x, 2 );
                Inc ( temp_pos, 2 );
           End;

{-->>     temp_pos := 0;}

     Move ( temp_val[0], TempLong, Sizeof(TempLong) );
     PSysLongToDelphi := TempLong;

End;

Procedure DelphiLongToPSys ( LongNo : LongInt; Var ValArray : Array Of Char );
Var
   pos_x,
   temp_pos :integer;

Begin
     If ( LongNo >= 0 ) Then
        Begin
             fillchar (temp_val[0], sizeof (temp_val), chr (0));
             fillchar (ValArray[0], SizeOf (ValArray), chr (0));
        End
     Else
        Begin
             fillchar (temp_val[0], sizeof (temp_val), chr (255));
             fillchar (ValArray[0], SizeOf (ValArray), chr (255));
        End;

     Move ( LongNo, Temp_val[0], SizeOf(LongNo));
     {
     x := SizeOf(Temp_Val)-1;
     While (Temp_val[x] In [chr (0),chr(255)]) and (x >= 0) do
        dec (x);
     If Odd(X) Then Inc(x);
     }
     pos_x := 0;
     temp_pos := SizeOf(ValArray)-2{8};
     While pos_x < SizeOf(ValArray) Do
           Begin
                MOVE (temp_Val[temp_pos],
                      ValArray[pos_x], 2);
                inc ( pos_x, 2 );
                dec ( temp_pos, 2 );
           End;
End;

{
 SearchDb = Database to search for new record
 AccRange = array 1 to 6 of integer contains start and end of search range
 SpecialCase of AccRange[2] = -1 or 0 this indicates a full database search
 ie - Not a range of Accounts but from record 1 to the Last Record.
}
Function GetNextFreeAccount ( SearchDb : Integer; AccRange : TAccRange ) : Integer;
Var
   RecCount : Integer;
   NewRecFound : Boolean;
Begin
     GetNextFreeAccount := 0;
     SetDb ( SearchDb );
     RecCount := AccRange[1];
     If ( AccRange[2] = -1 ) Or ( AccRange[2] = 0 ) Then
        AccRange[2] := db1.dbrectot;

     NewRecFound := False;
     Repeat
           If ( RecCount > 0 ) Then
              Begin
                   ReadRec ( SearchDb, RecCount );
                   dberr;
                   NewRecFound := ( NOT RecActive ( SearchDb ));
              End;
           Inc ( RecCount );
     Until ( RecCount <= 0 ) Or ( RecCount > AccRange[2] ) Or NewRecFound;
     Dec ( RecCount );
     If NewRecFound Then
        GetNextFreeAccount := RecCount
     Else
        MessageDlg('No Free Accounts Available', mtInformation, [mbOk], 0)
End;

{
 Takes a string strips all spaces, then test if Numeric, then converts it to int/longint
 else it passes back 0
}
Function KStrToInt ( StrToChange : ShortString ) : Integer;
Begin
     KStrToInt := 0;
     SlimAll ( StrToChange );
     If Numeric ( StrToChange ) Then
        KStrToInt := StrToInt ( StrToChange );
End;

Procedure UpdateDataBaseDefaults;
begin
     Accsdatamodule.DefaultsDB.open;
     Accsdatamodule.DefaultsDB.edit;
 {    try EntsMax := Accsdatamodule.DefaultsDB['EntsMax'];
     except EntsMax := 0;
     end;
     try EntsUsed := Accsdatamodule.DefaultsDB['EntsUsed'];
     except EntsUsed := 0;
     end;

     try SLMax := Accsdatamodule.DefaultsDB['SLMax'];
     except SLMax := 0;
     end;
     try SLUsed := Accsdatamodule.DefaultsDB['SLUsed'];
     except SLUsed := 0;
     end;

     try PLMax := Accsdatamodule.DefaultsDB['PLMax'];
     except PLMax := 0;
     end;
     }
     try PLUsed := Accsdatamodule.DefaultsDB['PLUsed'];
     except PLUsed := 0;
     end;

     try EntsUsed := Accsdatamodule.EntsFileDB.recordcount;
     except
     end;
     try SLUsed := Accsdatamodule.SLFileDB.recordcount;
     except
     end;
     try PLUsed := Accsdatamodule.PLFileDB.recordcount;
     except
     end;
  //   PLUsed := Accsdatamodule.PLFileDB.recordcount;
     Accsdatamodule.DefaultsDB['EntsUsed'] := EntsUsed;
     Accsdatamodule.DefaultsDB['SLUsed'] := SLUsed;
     Accsdatamodule.DefaultsDB['PLUsed'] := PLUsed;
     Accsdatamodule.DefaultsDB.post;
     Accsdatamodule.DefaultsDB.close;

end;



Begin
{-----------------------------	INITIALIZATION	------------------------------}


{-------------------------------  TERMINATION  -------------------------------}


End.


