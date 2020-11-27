Unit UTIL;
{

  File	    : U-DB:DBUTIL.TEXT
  Unit	    : DB_UTIL
  Prefix    :
  Status    : Finished

  DATE'S
  Started   : 21-04-92
  Finished  : 19-jANUNARY-1994

  this unit contains some general routines that are used by the database
  program, these are to index files, read referances and so on
}




{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface

Uses
    DIALOGS,
    types,
    accsdata;



{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

PROCEDURE REWRITEREC   (DB,RECNO: INTEGER);
PROCEDURE ADDRECORD    (DB,RECNO: INTEGER; UPDATEPRIME: BOOLEAN);
PROCEDURE DELETERECORD (DB,RECNO: INTEGER; UPDATEPRIME: BOOLEAN);
PROCEDURE DBERR;
PROCEDURE OPENDB     (DB: INTEGER; PATHNAME: STRING; BUILDPRIMEINDEX: BOOLEAN);

{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation

Uses
  Forms,
  VARS,
  PARAMS,
  CALCS,
  FILED,
  DBCORE,
  DBGEN,
  CLEARS;

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}


PROCEDURE DBERR;
VAR
  ErrSt   : String;
  DB	 : INTEGER;
BEGIN
  IF NOT (ERRORNO IN [0,4]) THEN
    BEGIN
      DATAOPEN:=FALSE;
      If Errorno in [1..12, 99] then
	Case Errorno of
	  1 : ErrSt := 'DATABASE NOT OPENED';
	  2 : ErrSt := 'ERROR READING FROM DISK';
	  3 : ErrSt := 'ERROR WRITING TO DISK';
	  4 : ErrSt := 'INDEX KEY NOT FOUND';
	  5 : ErrSt := 'RECORD NUMBER NOT FOUND';
	  6 : ErrSt := 'NO SPARE RECORDS IN DATABASE';
	  7 : ErrSt := 'INDEX OVERFLOW AREA IS FULL';
	  8 : ErrSt := 'INCONSISTENT DATA....PLEASE AUDIT';
	  9 : ErrSt := 'DATABASE NAME INVALID ON "OPENDB"';
	 10 : ErrSt := 'GET OR PUT TRIED ON NULL RECORD';
	 11 : ErrSt := 'INVALID DATABASE NUMBER';
	 12 : ErrSt := 'NOT APPLICABLE TO THIS DATABASE';
	 99 : ErrSt := 'ERROR READING INDEX';
	end
      else
          Str ( errorno, ErrSt );

      MessageDlg( ErrSt, mtInformation,[mbOK], 0);
      Application.Terminate;

      {FOR DB:=1 TO Max_Dbs DO}
      FOR DB:=1 TO MaxDatabases DO
	CLOSEDB (DB);
      EXITDOS;
    END;
END;

PROCEDURE REWRITEREC;
VAR
  BLKNO	  : INTEGER;
  {
  INDOFST : INTEGER;
  INDSZ	  : INTEGER;
  WK	  : PACKED ARRAY [1..1024] OF CHAR;
  }
BEGIN
  if ((DB = NewTxFile) or (DB = NLFile) or (DB=EntFile) or (DB = SLFile) or (DB = PLFile)) then exit;
  ERRORNO:=0;
  SETDB (DB);
  IF ERRORNO>0 THEN EXIT;
  IF (RECNO<1) OR (RECNO>DB1.DBRECTOT) THEN
    BEGIN
      ERRORNO:=10;
      EXIT;
    END;
  BLKNO:=((RECNO-1) DIV DB1.DBRECBLK);
  MOVE (DATWORK^[1],CBLOCKS[1],1024);
  IF CWRITE (DB,2,(BLKNO*2)+DB1.DBDATAS)<2 THEN EXIT ;

  { AH ADD 12.3.96 }
  savedb (db);
END;

PROCEDURE ADDRECORD;
VAR

  {
  SETZERO : INTEGER;
  }
  BLKNO	  : INTEGER;
  {
  INDOFST : INTEGER;
  INDSZ	  : INTEGER;
  ST	  : STRING;
  THERECNO: INTEGER;
  X	  : INTEGER;
  }
  PROCEDURE AR1;
  BEGIN
    ERRORNO:=0;
    SETDB (DB);
    IF ERRORNO>0 THEN EXIT;
    IF (RECNO<1) OR (RECNO>DB1.DBRECTOT) THEN
      BEGIN
	ERRORNO:=10;
	EXIT;
      END;
  END;

  PROCEDURE AR2;
  BEGIN
    BLKNO:=((RECNO-1) DIV DB1.DBRECBLK);
    ERRORNO:=0;
    {
    DATWORK[DB][CURROFST[DB]+1]:='A';
    MOVELEFT (DATWORK[DB][1],CBLOCKS[1],1024);
    }
    DATWORK^[CURROFST[DB]+1]:='A';
    MOVE (DATWORK^[1],CBLOCKS[1],1024);
    IF CWRITE (DB,2,(BLKNO*2)+DB1.DBDATAS)<2 THEN EXIT;
  END;

BEGIN

  if ((db = Entfile) or (db = SLFile) or (db = PLFile) or (db = NLFile)) then begin


  end else begin
      AR1;
      AR2;

      IF RECNO>DB1.DBRECHIGH THEN
         BEGIN
         DB1.DBRECHIGH:=RECNO;
         MOVE (DB1.DBFILLS[1],CBLOCKS[1],512);
         IF CWRITE (DB,1,0)<1 THEN EXIT;
      END;
  end; //else
  { AH ADD 12.3.96 }
  savedb (db);
END;

PROCEDURE DELETERECORD;
VAR
  BLKNO	  : INTEGER;
BEGIN
  if DB = Entfile then begin
     with Accsdatamodule do begin
          EntsFileDB.edit;
          EntsFileDB['Active'] := False;
          EntsFileDB['Entcode'] := '';
          EntsFileDB['EntName'] := '';
          EntsFileDB['UnitDiv'] := 0;
          EntsFileDB['UnitText'] := '';
          EntsFileDB['IncFrom'] := 0;
          EntsFileDB['IncTo'] := 0;
          EntsFileDB['ExpFrom'] := 0;
          EntsFileDB['ExpTo'] := 0;
          EntsFileDB['CosFrom'] := 0;
          EntsFileDB['CosTo'] := 0;
          EntsFileDB.post;
     end
  end else
     if DB = SLfile then begin
     with Accsdatamodule do begin
          SLFileDB.edit;
          SLFileDB['BalanceBF'] := '0.00';
          SLFileDB['Balance'] := '0.00';
          SLFileDB['Turnover'] := '0.00';
          SLFileDB['AgeCurr'] := '0.00';
          SLFileDB['Age1'] := '0.00';
          SLFileDB['Age2'] := '0.00';
          SLFileDB['Age3'] := '0.00';
          SLFileDB['NotAlloc'] := '0.00';
          SLFileDB['FirstYear'] := '0';
          SLFileDB['FirstTx'] := '0';
          SLFileDB['LastTx'] := '0';
          SLFileDB['BalanceST'] := '0.00';
          SLFileDB['AreaCode'] := '0';
          SLFileDB['Active'] := False;
          SLFileDB.post;
     end
     end else
         if DB = PLfile then begin
         with Accsdatamodule do begin
          PLFileDB.edit;
          PLFileDB['BalanceBF'] := '0.00';
          PLFileDB['Balance'] := '0.00';
          PLFileDB['Turnover'] := '0.00';
          PLFileDB['AgeCurr'] := '0.00';
          PLFileDB['Age1'] := '0.00';
          PLFileDB['Age2'] := '0.00';
          PLFileDB['Age3'] := '0.00';
          PLFileDB['NotAlloc'] := '0.00';
          PLFileDB['FirstYear'] := '0';
          PLFileDB['FirstTx'] := '0';
          PLFileDB['LastTx'] := '0';
          PLFileDB['BalanceST'] := '0.00';
          PLFileDB['AreaCode'] := '0';
          PLFileDB['Active'] := False;
          PLFileDB.post;
     end
        end else
            if DB = NLfile then begin
            with Accsdatamodule do begin
            NLFileDB.edit;
            NLFileDB['Name'] := Null;
            NLFileDB['Balance'] := '0.00';
            NLFileDB['STPeriod'] := '0.00';
            NLFileDB['STYear'] := '0.00';
            NLFileDB['Repgroup'] := 0;
            NLFileDB['STWeek'] := '0.00';
            NLFileDB['BudgYear'] := '0.00';
            NLFileDB['FirstBank'] := 0;
            NLFileDB['FirstTx'] := 0;
            NLFileDB['LastTx'] := 0;
            NLFileDB['YearTot1'] := '0.00';
            NLFileDB['YearTot2'] := '0.00';
            NLFileDB['YearTot3'] := '0.00';
            NLFileDB['TaxCode'] := Null;
            NLFileDB['BalanceST'] := '0.00';
            NLFileDB['Enterprise'] := Null;
            NLFileDB['BudPer01'] := '0.00';
            NLFileDB['BudPer02'] := '0.00';
            NLFileDB['BudPer03'] := '0.00';
            NLFileDB['BudPer04'] := '0.00';
            NLFileDB['BudPer05'] := '0.00';
            NLFileDB['BudPer06'] := '0.00';
            NLFileDB['BudPer07'] := '0.00';
            NLFileDB['BudPer08'] := '0.00';
            NLFileDB['BudPer09'] := '0.00';
            NLFileDB['BudPer10'] := '0.00';
            NLFileDB['BudPer11'] := '0.00';
            NLFileDB['BudPer12'] := '0.00';
            NLFileDB['BudPer13'] := '0.00';
            NLFileDB['ActPer01'] := '0.00';
            NLFileDB['ActPer02'] := '0.00';
            NLFileDB['ActPer03'] := '0.00';
            NLFileDB['ActPer04'] := '0.00';
            NLFileDB['ActPer05'] := '0.00';
            NLFileDB['ActPer06'] := '0.00';
            NLFileDB['ActPer07'] := '0.00';
            NLFileDB['ActPer08'] := '0.00';
            NLFileDB['ActPer09'] := '0.00';
            NLFileDB['ActPer10'] := '0.00';
            NLFileDB['ActPer11'] := '0.00';
            NLFileDB['ActPer12'] := '0.00';
            NLFileDB['ActPer13'] := '0.00';
            NLFileDB['LstPer01'] := '0.00';
            NLFileDB['LstPer02'] := '0.00';
            NLFileDB['LstPer03'] := '0.00';
            NLFileDB['LstPer04'] := '0.00';
            NLFileDB['LstPer05'] := '0.00';
            NLFileDB['LstPer06'] := '0.00';
            NLFileDB['LstPer07'] := '0.00';
            NLFileDB['LstPer08'] := '0.00';
            NLFileDB['LstPer09'] := '0.00';
            NLFileDB['LstPer10'] := '0.00';
            NLFileDB['LstPer11'] := '0.00';
            NLFileDB['LstPer12'] := '0.00';
            NLFileDB['LstPer13'] := '0.00';
            NLFileDB['Active'] := False;
            NLFileDB['DepRate'] := '0.00';
            NLFileDB['DepAmount'] := '0.00';
            NLFileDB['NominalType'] := Null;
            NLFileDB.post;
     end
  end;
  savedb (db);
END;

PROCEDURE OPENDB;
VAR
  X  : INTEGER;

BEGIN
  if DB = NewTxfile then begin
        CURRDB:=DB;
        try accsdatamodule.TransactionsDB.open;
        except 
        end;
  end
        else if DB = LastTxFile then begin
                   CURRDB:=DB;
                   try accsdatamodule.TransactionsYr1DB.open;
                   except
                   end;

             end
                 else
                  if DB = LastNLfile then begin
                     CURRDB:=DB;
                     try accsdatamodule.LastNLFileDB.open;
                     except
                     end;
  end else begin
  ERRORNO:=0;
  SETDB (DB);
  IF ERRORNO=11 THEN EXIT;
  ERRORNO:=0;
  CURRDATBLK[DB]:=-10;
  CURRREC   [DB]:=-10;
  CCLOSE (DB,'N');
  DBOPEN[DB]:=FALSE;
  CRESET (DB,PATHNAME);
  IF ERRORNO>0 THEN EXIT ;
  IF CREAD (DB,1,0)<1 THEN EXIT;
  MOVE (CBLOCKS[1],DB1.DBFILLS[1],512);

  FILLCHAR (DB1.DBITEMS[1].DBIFILL[1],MAXITEMS*32,CHR(0));

  FOR X:=1 TO DB1.DBITEMBLKS DO
    IF CREAD (DB,1,X+1)<1
      THEN EXIT
      ELSE MOVE (CBLOCKS[1],DB1.DBITEMS[((X-1)*16)+1].DBIFILL[1],512);
  DBOPEN[DB]:=TRUE;
  CURRDB:=DB;
{  IF DB1.DBINDEX1>0 THEN
    IF BUILDPRIMEINDEX THEN BUILDINDEX (DB);
 }
  SAVEDB (DB);
  end;
END;

Begin
{-----------------------------	INITIALIZATION	------------------------------}


{-------------------------------  TERMINATION  -------------------------------}


End.
