{ To get result mrYes use Controls Unit And Messages }

// 04/12/15 - Function CheckNomials updated to fix validation issues when doing 'To Sales' & 'To Purchases' Transactions

// 25/10/19 - Ch016 - Bug Fix when editing date on a Receipt / Payment the date on the discount line was not updated

unit TxWrite;

interface
Uses
    Types,FullAudit,Windows,Messages,uAccsMessages, kRoutines;

CONST
  keyf5	 = 'keyf5';
  MAXTX	 = 6;
  MAXNOM = 4;
  MAXACC = 50;
  MAXPAY = 100;

TYPE
  MEDST	 = STRING{[20]};

VAR
  WORKDATE    : STRING{[8]};
  DUEDATE     : INTEGER;
  ANYDUE      : BOOLEAN;
  HLP	      : INTEGER;
  AUTOACC     : INTEGER;
  AUTONUM     : INTEGER;
  AUTOTX      : INTEGER;
  NEXTTX      : INTEGER;
  ALLOCPAY    : BOOLEAN;
  FINISHED    : BOOLEAN;
  ENDCUST     : BOOLEAN;
{
  PAYACC      : PACKED ARRAY [1..MAXACC] OF INTEGER;
  PAYSTUB     : PACKED ARRAY [1..MAXACC] OF LONG;
  PAYOPEN     : PACKED ARRAY [1..MAXPAY] OF BOOLEAN;
  PAYCUST     : PACKED ARRAY [1..MAXPAY] OF INTEGER;
  PAYTX	      : PACKED ARRAY [1..MAXPAY] OF INTEGER;
  PAYAMT      : PACKED ARRAY [1..MAXPAY] OF LONG;
  PAYDISC     : PACKED ARRAY [1..MAXPAY] OF LONG;

  PAYINT      : INTEGER;
  PAYDATE     : STRING[8];
  PAYREF      : STRING[8];
  PAYCOMM     : PACKED ARRAY [1..MAXACC] OF STRING[15];
  PAYBANK     : INTEGER;
  PAYBAL      : LONG;
  PAYDU       : LONG;
}
  TXHOLD      : PACKED ARRAY [1..MAXTX]	 OF ^DW_TYPE;{[1..1024] OF CHAR}
  NOMHOLD     : PACKED ARRAY [1..MAXNOM] OF ^DW_TYPE;{[1..1024] OF CHAR}
  TXBLOCKS    : PACKED ARRAY [1..MAXTX]	 OF INTEGER;
  NOMBLOCKS   : PACKED ARRAY [1..MAXNOM] OF INTEGER;
  USERJNLS    : PACKED ARRAY [1..48] OF BOOLEAN;
  USEROPT     : INTEGER;
  LISTNO      : INTEGER;
  LISTSPARE   : INTEGER;
{  ENTLIST     : PACKED ARRAY [1..99] OF STRING[4];}
{  ENTNAME     : PACKED ARRAY [1..99] OF STRING[20];}
  ENTSUB      : INTEGER;
  NOMCHECKED  : BOOLEAN;
  ACTION      : CHAR;
  FIRSTTIME   : BOOLEAN;
  DATEFORMAT  : STRING80;
  MONTH	      : INTEGER;
  YEARNO      : INTEGER;
  VATSTR      : STRING{[1]};
  JOFFSET     : INTEGER;
  JAMEND      : BOOLEAN;

  // TGM AB these vars hold info from cashbookform grid prior to being written as transactions
  // 02/07/04 changed declaritions from PACKED ARRARY to ARRAY

  ZTXDATE     : ARRAY [1..2] OF INTEGER;
  ZDUESTR     : ARRAY [1..2] OF STRING[8];
  ZDUEINT     : ARRAY [1..2] OF INTEGER;
  ZALLOC      : ARRAY [1..2] OF CHAR;
  ZAMTPAID    : ARRAY [1..2] OF LONG;
  ZDISCOUNT   : ARRAY [1..2] OF LONG;
  ZTOTAMT     : ARRAY [1..2] OF LONG;
  ZTOTTAX     : ARRAY [1..2] OF LONG;
  ZBANK	      : ARRAY [1..2] OF INTEGER;
  ZBANK2      : ARRAY [1..2] OF INTEGER;
  ZSTUB	      : ARRAY [1..2] OF BIGLONG;
  ZBANKBAL    : ARRAY [1..2] OF STRING[12];
  ZBANKAMT    : ARRAY [1..2] OF LONG;
  ZACCOUNT    : ARRAY [1..2] OF INTEGER;
  ZACCBAL     : ARRAY [1..2] OF LONG;
  ZREF	      : ARRAY [1..2] OF STRING[8];
  ZCOMM	      : ARRAY [1..2] OF MEDST;
  ZJNLNO      : ARRAY [1..2] OF INTEGER;
  ZJNLNAME    : ARRAY [1..2] OF MEDST;
  ZUSE	      : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF BOOLEAN;
  ZENT	      : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF STRING[4];
  ZENTREC     : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF INTEGER;
  ZQTY	      : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF LONG;
  ZGEN	      : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF INTEGER;
  ZAMT	      : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF LONG;
  ZTAX	      : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF STRING [1];
  ZTAXAMT     : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF LONG;
  ZDESC	      : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF STRING[15];
  ZDB	      : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF INTEGER;
  ZCR	      : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF INTEGER;
  ZANALYSIS   : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF INTEGER;
  ZCUSTREC    : ARRAY [1..2] OF INTEGER;
  ZUSER1      : ARRAY [1..2] OF ARRAY [1..MaxGridLines]
				    OF ARRAY [1..MaxGridLines] OF STRING[15];
  ZUSER2      : ARRAY [1..2] OF ARRAY [1..MaxGridLines]
				    OF ARRAY [1..MaxGridLines] OF LONG;
  ZUSER3      : ARRAY [1..2] OF ARRAY [1..MaxGridLines]
				    OF ARRAY [1..MaxGridLines] OF INTEGER;
  ZQTY2	      : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF LONG;     // TGM AB 01/02/13
  ZQTY3	      : ARRAY [1..2] OF ARRAY [1..MaxGridLines] OF LONG;     // TGM AB 01/02/13

  // End TGM AB Variables

  STARTREC    : INTEGER;
  TRANSREC    : INTEGER;
  WAITSUB     : INTEGER;
  EDFROM      : INTEGER;
  EDTO	      : INTEGER;
  EDTYPE      : INTEGER;
  VIEW	      : BOOLEAN;
  {
  NOMNAME     : STRING[30];
  }
  SAMESTUB    : BOOLEAN;
  STUBTOT     : LONG;
  TXNO	      : INTEGER;

  F8_active,				{ used when calling F8 to calc amount }
  first_pass  : boolean;	 { used when printing cheque to align printer }
  i_hp_liabil : Integer;	       {* stores last used HP liablility code }
  Presented   : Boolean;
  GArrPos     : Integer;
  { Positon 1 holds the Debit Account Pos 2 Holds The Credit Account }
  NomArray    : Array [1..2] Of Array [1..2] Of Array [1..((MaxGridLines*2)+2)] Of Integer;  //TENFOUND 22 // TGM AB was Packed Arrays

  NOTIFY_TRANSACTION_WRITE_SUCCESS : Boolean = True;

  // New variable to disable calling of Transaction Grid loading
  PREVENT_TRANSACTIONGRID_LOADING_ON_TRANSACTION_WRITE : Boolean = False;


  Procedure WriteTransactions(ZTX,DBACC,OldAct: INTEGER;SOrder:Boolean);
  function  LoadTrans : Boolean;
  Procedure CheckEnd;
  Procedure ReSetPointers ( Sender : TObject );
  Function TestGridCell ( Cell : ShortString ) : Boolean;
  Procedure INITVALS;
  Function CheckNominals : integer;

{
  Procedure PutXXXX ( db, Itemno : Integer );
  Procedure WriteXXX;
  Procedure InList ( db, BlkNo : Integer );
  Procedure ReadXXX ( db, RecNo : Integer );
  Procedure ReWriteXXX ( db, RecNo : Integer );
  Procedure ADDXXXXXX ( db, RecNo : Integer );
}

Implementation
Uses
    DefSecFl,
    Controls,
    SysUtils,
    Audit,
    MainUnit,
    Dialogs,
    Clears,
    Filed,
    Calcs,
    Util,
    Vars,
    DbCore,
    DbGen,
    AccsData,
    langunit,
    dbtables,
    bde,
    uPreferences,
    uPreferenceConsts;

Var
    TXLINE,
    counter,
    NO_LINES,
    Sub,
    TxT,
    X,Y,
    LineX : Integer;

  Procedure PutXXXX ( db, Itemno : Integer ); Forward; //
  Procedure WriteXXX; Forward;
  Procedure InList ( db, BlkNo : Integer ); Forward;
  Procedure ReadXXX ( db, RecNo : Integer ); Forward; //
  Procedure ReWriteXXX ( db, RecNo : Integer ); Forward;
  Procedure ADDXXXXXX ( db, RecNo : Integer ); Forward;


function CopyRecordToEnd(Table:TTable):boolean;
  var
      buf:PChar;
  begin
    GetMem(buf,Table.RecordSize);
    try
       Table.GetCurrentRecord(buf);
       DBIAppendRecord(Table.Handle, Buf);
       Table.close;
       Table.open;
       Table.last;
       Table.edit;
    finally
       FreeMem(buf);
    end;
  end;



Procedure UpdateTempBanks;
Var
   DoNotContinue : Boolean;
//   BankR    : tBankRec;
//   BankFile : tBankFile;

   Procedure FindBank ( BankNo : Integer; Amt : Long; FirstSecond : Integer );
   Var
 //     BankFileRec : Integer;
      LastBalance : real;  // was long
      i : integer;
   Begin
     Accsdatamodule.BankTableDB.open;
     Accsdatamodule.BankTableDB.first;

     For i := 1 to Accsdatamodule.BankTableDB.recordcount do begin
         if Accsdatamodule.BankTableDB['BankCode'] = BankNo then begin

            LastBalance := (Accsdatamodule.BankTableDB['Balance']*100);
            If ( FirstSecond = 2 ) Then
                    LastBalance := LastBalance - Amt
            Else
                    LastBalance := LastBalance + Amt;

            Accsdatamodule.BankTableDB.edit;
            try Accsdatamodule.BankTableDB['Balance'] := LastBalance/100;
            except Accsdatamodule.BankTableDB['Balance'] := 0;
            end;
            Accsdatamodule.BankTableDB.post;

         end;
         Accsdatamodule.BankTableDB.next;
     end;
     (*
     BankFileRec := 0;
     FillChar ( BankR, SizeOf ( BankR ), chr(0));
     ReSet ( BankFile );
     Seek ( BankFile, BankFileRec );

     Repeat
        If NOT Eof ( BankFile ) Then
          Begin
            Read ( BankFile, BankR );

            If BankR.BankCode = BankNo Then
              Begin
                 LastBalance := PSysLongToDelphi ( BankR.Balance );
                 If ( FirstSecond = 2 ) Then
                    LastBalance := LastBalance - Amt
                 Else
                    LastBalance := LastBalance + Amt;

                 DelphiLongToPSys ( LastBalance, BankR.Balance );
                 Seek ( BankFile, BankFileRec );
                 Write ( BankFile, BankR );

              End
            Else
              Begin
                 Inc ( BankFileRec );
                 Seek ( BankFile, BankFileRec );
              End;
          End;
     Until ( Eof ( BankFile ) );
       *)
   End;

Begin
     DoNotContinue := False;


 //    Assign ( BankFile, Cash2.xdirectory + cBankFile );
 //    Try
 //       ReSet ( BankFile );
 //    ExCept
 //       DoNotContinue := True;
 //    End;

     If NOT DoNotContinue Then
        Begin
             If PROG In [CashInc, SalesTx] Then
                Begin
                   FindBank ( zbank[1], ztotamt[1]+ztottax[1], 1 );
                   FindBank ( zbank[2], 0-(ztotamt[2]+ztottax[2]), 2 );
                End
             Else
                If PROG In [CashExp, PurchTx] Then
                   Begin
                      FindBank ( zbank[1], ztotamt[1]+ztottax[1], 2 );
                      FindBank ( zbank[2], 0-(ztotamt[2]+ztottax[2]), 1 );
                   End;
        End;
End;

Procedure WriteTransactions(ZTX,DBACC,OldAct: INTEGER;SOrder:Boolean);

{ Different Transaction Types
  PROG              ACT
  SALESTX           1        = Sales Invoice
  SALESTX           2        = Cash Sale
  SALESTX           3        = Sales Receipt
  SALESTX           4        = Sales Credit Note

  PURCHTX           1        = Purchase Invoice
  PURCHTX           2        = Cash Purchase
  PURCHTX           3        = Purchase Payment
  PURCHTX           4        = Purchase Credit Note

  CASHINC                    = Cashbook Income
  CASHEXP                    = Cashbook Expenditure

  JOURNAL           1        = Direct Debits
  JOURNAL           2        = Direct Credits
  JOURNAL           3        = VAT Paid
  JOURNAL           4        = VAT Received
  JOURNAL           5        = Inter Bank Transfers
}

Var
  CheckBank : Boolean;       { If editing & true read temp bankfile.dat and update bankinfo }
  TYPE9     : ARRAY[1..MaxGridLines] OF INTEGER; // TENFOUND was Packed Array
  DEBITACC  : INTEGER;
  CREDITACC : INTEGER;
  DBCRAMT   : LONG;
  ANALTOT   : INTEGER;
  WK	    : ARRAY[1..1024] OF CHAR; // was packed array
  PAYREC    : INTEGER;
  FIRSTREC  : INTEGER;
  PREVREC   : INTEGER;
  CTrans    : Integer;

    (* TGM AB - Deleted
    PROCEDURE PUTSTATUS;
    BEGIN					       { begin PUTSTATUS }

      {
      IF (EDIT) AND (ZTX=2) THEN
	BEGIN
	  SETITEM;
	  CURRDISP[1]:='R';
	  PutXXXX(2,28);
	END;
      }
    END;						{ end PUTSTATUS }
    *)

    PROCEDURE SETDBCR (NOMLOG: BOOLEAN; AMT: LONG; DB1,CR1,DB2,CR2: INTEGER);
    BEGIN						{ begin SETDBCR }
      CURRLONG:=AMT;
      IF CURRLONG<0 THEN CURRLONG:=0-CURRLONG;
      DBCRAMT:=CURRLONG;
      { Write the AMT into the Nom-Amt field if NOMLOG is true }
      IF NOMLOG THEN PutXXXX(TxFile,17);
      IF PROG IN [CASHINC,SALESTX] THEN
	BEGIN
	  IF AMT<0 THEN
	    BEGIN
	      DEBITACC :=CR1;
	      CREDITACC:=DB1;
	    END
	  ELSE
	    BEGIN
	      DEBITACC :=DB1;
              CREDITACC:=CR1;
	    END;
	END;
      IF PROG IN [CASHEXP,PURCHTX] THEN
	BEGIN
	  IF AMT<0 THEN
	    BEGIN
	      DEBITACC :=CR2;
	      CREDITACC:=DB2;
	    END
	  ELSE
	    BEGIN
	      DEBITACC :=DB2;
	      CREDITACC:=CR2;
	    END;
	END;
      IF NOMLOG THEN
	BEGIN
	  CURRINT:=DEBITACC;
	  PutXXXX(TxFile,18);
	  CURRINT:=CREDITACC;
	  PutXXXX(TxFile,19);
	END;
    END;						 { end SETDBCR }

    PROCEDURE SETNOM(AMT: LONG; DB1,CR1: INTEGER);
    BEGIN						 { begin SETNOM }
      CURRLONG:=AMT;
      IF CURRLONG<0 THEN CURRLONG:=0-CURRLONG;
      DBCRAMT:=CURRLONG;
      PutXXXX(TxFile,17);
      IF AMT<0 THEN
	BEGIN
	  DEBITACC:=CR1;
	  CREDITACC:=DB1;
	END
      ELSE
	BEGIN
	  DEBITACC:=DB1;
	  CREDITACC:=CR1;
	END;
      CURRINT:=DEBITACC;
      PutXXXX(TxFile,18);
      CURRINT:=CREDITACC;
      PutXXXX(TxFile,19);
      IF ((DEBITACC >=Cash1.XBANKMIN) AND (DEBITACC <=Cash1.XBANKMAX))
      OR ((CREDITACC>=Cash1.XBANKMIN) AND (CREDITACC<=Cash1.XBANKMAX)) THEN
	BEGIN
             SETITEM;
             If GEditing And Presented Then
                CURRDISP[1]:='P'
             Else
                 CURRDISP[1]:='U';
             PutXXXX (TxFile,27);
	END;
      IF (PROG=JOURNAL) AND (NOT (ACT IN [3,4,5])) THEN
	BEGIN
	  CURRLONG:=AMT;
	  IF CURRLONG<0 THEN CURRLONG:=0-CURRLONG;
	  DBCRAMT:=CURRLONG;
	  PutXXXX(TxFile,11);
	  SETITEM;
	  CURRDISP[1]:='*';
	  PutXXXX(TxFile,10);
	  { MC 04/12/95
	  IF DEBITACC=XNOMTAX THEN
	    BEGIN
	      CURRINT:=0;
	      PutXXXX (TxFile,1);
	      CURRINT:=8;
	      PutXXXX (TxFile,23);
	    END;
	  IF CREDITACC=XNOMTAX THEN
	    BEGIN
	      CURRINT:=0;
	      PutXXXX (TxFile,1);
	      CURRINT:=4;
	      PutXXXX (TxFile,23);
	    END;
	  }
	END;
    END;						 { end SETNOM }

    PROCEDURE LOGNOM (FULLUPDATE: BOOLEAN; TXREC: INTEGER);
    VAR
      OLDDB  : INTEGER;
      OLDCR  : INTEGER;
      PREVCR : INTEGER;
      PREVDB : INTEGER;
    BEGIN						  { begin LOGNOM }
      Inc ( GArrPos );
      NomArray[ztx,1,GArrPos-1] := DebitAcc;
      NomArray[ztx,2,GArrPos-1] := CreditAcc;

      FULLUPDATE:= TXREC>0;
      IF DBCRAMT=0 THEN EXIT;
      { Read the DEBITACC from the Nominal Ledger File }
      READXXX(NlFile,DEBITACC);
      IF ERRORNO>0 THEN dbERR;
      { Get the Last transaction }
      GETITEM(NlFile,16);
      PREVDB:=CURRINT;
      GETITEM(NlFile,2);
      CURRLONG:=CURRLONG+DBCRAMT;
      { Put the New Balance }
      PutXXXX(NlFile,2);
      IF FULLUPDATE THEN
         BEGIN
              GETITEM(NlFile,15);
              IF CURRINT=0 THEN
                 BEGIN
                      CURRINT:=TXREC;
                      PutXXXX(NlFile,15);
                 END;
              CURRINT:=TXREC;
              PutXXXX(NlFile,16);
         END;
      REWRITEXXX(NlFile,DEBITACC);
      IF ERRORNO > 0 THEN dbERR;
      { Read the CREDITACC from Nominal Ledger }
      READXXX(NlFile,CREDITACC);
      IF ERRORNO > 0 THEN dbERR;
      IF NOT RECACTIVE(NlFile) THEN dbERR;
      { Get the Last Transaction }
      GETITEM(NlFile,16);
      PREVCR:=CURRINT;
      GETITEM(NlFile,2);
      CURRLONG:=CURRLONG-DBCRAMT;
      { Update the Balance }
      PutXXXX(NlFile,2);
      IF FULLUPDATE THEN
         BEGIN
              GETITEM(NlFile,15);
              IF CURRINT=0 THEN
                 BEGIN
                      CURRINT:=TXREC;
                      PutXXXX(NlFile,15);
                 END;
              CURRINT:= TXREC;
              PutXXXX(NlFile,16);
         END;
      REWRITEXXX(NlFile,CREDITACC);
      IF ERRORNO>0 THEN dbERR;

      IF (PREVDB>0) AND FULLUPDATE THEN
         BEGIN
              READXXX(TxFile,PREVDB);
              IF ERRORNO > 0 THEN dbERR;
              GETITEM(TxFile,18);
              OLDDB:=CURRINT;
              GETITEM(TxFile,19);
              OLDCR:=CURRINT;
              CURRINT:=TXREC;
              IF OLDDB=DEBITACC THEN
                 PutXXXX(TxFile,13);
              IF OLDCR=DEBITACC THEN
                 PutXXXX(TxFile,14);
       //       REWRITEXXX(TxFile,PREVDB);
              IF ERRORNO>0 THEN dbERR;
         END;

      IF (PREVCR>0) AND FULLUPDATE THEN
         BEGIN
              READXXX(TxFile,PREVCR);
              IF ERRORNO>0 THEN dbERR;
              GETITEM(TxFile,18);
              OLDDB:=CURRINT;
              GETITEM(TxFile,19);
              OLDCR:=CURRINT;
              CURRINT:=TXREC;
              IF OLDDB=CREDITACC THEN
                 PutXXXX(TxFile,13);
              IF OLDCR=CREDITACC THEN
                 PutXXXX(TxFile,14);
              REWRITEXXX(TxFile,PREVCR);   // put back in
              IF ERRORNO > 0 THEN dbERR;
         END;
      IF TXREC<>0 THEN READXXX(TxFile,TXREC);
      IF ERRORNO>0 THEN dbERR;
    END;						{ end LOGNOM }

    PROCEDURE TESTTX (X: INTEGER);
    BEGIN						{ begin TESTTX }
      SETDB(TxFile);
      If NOT GEditing Then
         Begin
            IF DB1.DBRECHIGH+X > DB1.DBRECTOT THEN
               showmessage('Error - This code is still needed - Debug!');
	       BEGIN
	         MessageDlg('TRANSACTION FILE FULL - NO DETAILS UPDATED', mtInformation,[mbOK], 0);
	         IF ALLOCPAY THEN EXIT
                 ELSE EXIT;
               END;

            READXXX(TxFile,DB1.DBRECHIGH+1);
            IF ERRORNO>0 THEN dbERR;
            BLANKREC(TxFile,'A');
         End
      Else
          Begin
             ReadXXX(TxFile, CTrans);
             If ErrorNo > 0 Then DbErr;
          End;
    End;						 { end TESTTX }

    PROCEDURE US1;
    VAR
      X,Y: INTEGER;
    BEGIN						 { begin US1 }
      IF ((PROG IN [SALESTX,PURCHTX]) AND (ACT=4)) THEN
      (* REVERSE CREDIT NOTES TO NEGATIVE ON FILE *)
	BEGIN
	  ZTOTAMT[ZTX]:=0-ZTOTAMT[ZTX];
	  ZTOTTAX[ZTX]:=0-ZTOTTAX[ZTX];
	  FOR X:=1 TO MaxGridLines DO    // TENFOUND
	    IF ZUSE[ZTX][X] THEN
	      BEGIN
		ZAMT   [ZTX][X]:=0-ZAMT	  [ZTX][X];
		ZTAXAMT[ZTX][X]:=0-ZTAXAMT[ZTX][X];
	      END;
	END;
      FOR X:=1 TO MaxGridLines DO TYPE9[X]:=0;                          // TENFOUND
      IF (PROG IN [SALESTX,PURCHTX]) AND (ZCUSTREC[ZTX]=0) THEN EXIT;
      X:=2;
      ANALTOT:=1;
      FOR Y:=1 TO MaxGridLines DO
	IF ZUSE[ZTX][Y] THEN          // TENFOUND
	  BEGIN
	    X:=Y+1;
	    ANALTOT:=Y;
	  END;
      { Purchase Payment Or Sales Receipt }
      IF (PROG IN [SALESTX,PURCHTX]) AND (ACT=2) THEN
         X:=X+1; (* WRITE A PAYMENT TX AS WELL *)
      FOR Y:=1 TO ANALTOT DO IF ZTAXAMT[ZTX][Y]<>0 THEN X:=X+1;
    //  TESTTX(X); TGM AB Removed
    END;						 { end US1 }

    PROCEDURE UPDATESTART;
    VAR
      ST : STRING;
      i:integer;
    BEGIN						 { begin UPDATESTART }
      US1;
      if not GEditing then RewriteXXX(TxFile,Accsdatamodule.TransactionsDB.recordcount + 1) //TGM AB
         else RewriteXXX(TxFile,TxEditRec.TransF);
      CURRINT:=ZTXDATE[ZTX];
      PutXXXX(TxFile,2);
      SETITEM;
      IF ZREF[ZTX]<>NULL THEN
         Move(ZREF[ZTX][1],CURRDISP[1],LENGTH(ZREF[ZTX]));
      PutXXXX(TxFile,4);
      SETITEM;
      IF ZCOMM[ZTX]<>NULL THEN
         Move(ZCOMM[ZTX][1],CURRDISP[1],LENGTH(ZCOMM[ZTX]));
      PutXXXX(TxFile,5);
      SETITEM;
      CURRINT:=ZACCOUNT[ZTX];
      PutXXXX(TxFile,3);
      SETITEM;
      CASE PROG OF
           CASHINC : CURRINT:=11;
           CASHEXP : CURRINT:=15;
           SALESTX : CASE ACT OF
                          1,2 : CURRINT:=1;
                          3   : CURRINT:=2;
                          4   : CURRINT:=3;
                     END;
           PURCHTX : CASE ACT OF
                          1,2 : CURRINT:=5;
                          3   : CURRINT:=6;
                          4   : CURRINT:=7;
                     END;
      END;
      PutXXXX(TxFile,1);
      getitem(TxFile,1); //TGM AB
      PutXXXX(TxFile,23);

    //  PUTSTATUS; TGM AB Deleted
      CURRLONG:=ZTOTAMT[ZTX];
      PutXXXX(TxFile,9);
      IF  (PROG IN [CASHINC,CASHEXP])
      OR ((PROG IN [SALESTX,PURCHTX]) AND (ACT IN [1,2,4])) THEN
         BEGIN
              CURRLONG:=ZTOTTAX[ZTX];
              PutXXXX(TxFile,11);
// tgm next 4 lines altered to correct standing order not saving description bug
// the bit below saves the desc as the supplier/customer.  tgm added the (act <> 0) bit
// Nov 28th to prevent progran from saving the supplier as the nominal desription when entering
// cashbook exp.  however act = 1 for standing orders and saving the descriptoin in the supplier
// field puts description unto front grid                           
              If ((PROG IN [CASHINC,CASHEXP]) and (act <> 0) and (ZRef[1] <> 'DD / SO') and (ZRef[1] <> 'DC / SO')) then                           // Ch024 was - If (PROG IN [CASHINC,CASHEXP]) and (act <> 0)
              If Zdesc[1,1][1]<>'' then begin
                 for i:= 1 to 15 do if Zdesc[1,1][i]<>'' then Currdisp[i]:=Zdesc[1,1][i];
	         PutXXXX(TxFile,5);
              end;
   
         END;
      IF ((PROG IN [SALESTX,PURCHTX]) AND (ACT=3)) THEN
         BEGIN
              CURRLONG:=ZDISCOUNT[ZTX];
              PutXXXX(TxFile,11);
         END;
      SETITEM;
      CURRDISP[1]:=SPACE1;
      PutXXXX(TxFile,10);
      IF  (PROG IN [CASHINC,CASHEXP])
      OR ((PROG IN [SALESTX,PURCHTX]) AND (ACT IN [2,3])) THEN
         BEGIN
              SETITEM;
              STR (ZSTUB[ZTX],ST);
              WHILE LENGTH(ST)<8 DO
                 ST:=CONCAT('0',ST);
              Move (ST[1],CURRDISP[1],LENGTH(ST));
              PutXXXX (TxFile,26);
              SETITEM;
              If GEditing And Presented Then
                 CURRDISP[1]:='P'
              Else
                  CURRDISP[1]:='U';
              PutXXXX (TxFile,27);
         END;
      SETITEM;
      CURRDISP[1]:=ZALLOC[ZTX];
      PutXXXX(TxFile,30);
      CURRLONG:=ZAMTPAID[ZTX];
      PutXXXX(TxFile,29);
      IF Cash2.XINVALLOC THEN
         BEGIN
              IF (PROG IN [SALESTX,PURCHTX]) AND (ACT=1) THEN
                 BEGIN
                      CURRINT:=ZDUEINT[ZTX];
                      PutXXXX(TxFile,31);
                      IF ZTOTAMT[ZTX]+ZTOTTAX[ZTX]=0 THEN
                         BEGIN
                              CURRDISP[1]:='Y';
                              PutXXXX(TxFile,30);
                         END;
                 END;
              IF (PROG IN [SALESTX,PURCHTX]) AND (ACT=2) THEN
                 BEGIN
                      SETITEM;
                      CURRDISP[1]:='Y';
                      PutXXXX(TxFile,30);
                      CURRLONG:=ZTOTAMT[ZTX]+ZTOTTAX[ZTX];
                      PutXXXX(TxFile,29);
                 END;
         END;
    END;						 { end UPDATESTART }

    PROCEDURE UPCUST;
    VAR
      ADDAGED	: BOOLEAN;
      SUBAGED	: BOOLEAN;
      DEDUCTAMT : LONG;
      X		: INTEGER;
      DB        : INTEGER;
    BEGIN						  { begin UPCUST }
      If Prog in [CASHINC,CASHEXP] then begin     // TGMAB to update turnover figures for cashbook systems
         if ((ZAccount[ZTX] <> 0) and (Act = 0)) then begin
             if Prog = cashinc then DB := SLFile
                else DB := PLFile;
             READREC(DB,ZAccount[ZTX]);
             GETITEM(DB,8);
             CURRLONG:=CURRLONG + ZTOTAMT[ZTX];
             PutXXXX(DB,8);
             REWRITEREC(DB,ZAccount[ZTX]);
         end; // ZAccount <> 0
      end else
     begin
      READREC(DBACC,ZCUSTREC[ZTX]);
      GETITEM(DBACC,16);
      SETDB(TxFile);
      IF (CURRINT>0) AND (CURRINT<DB1.DBRECHIGH) And ( NOT GEditing ) THEN
         BEGIN
              PREVREC:=CURRINT;
              READXXX(TxFile,PREVREC);
              dbERR;
              SETITEM;
              CURRINT:=FIRSTREC;
              PutXXXX(TxFile,16);
              REWRITEXXX(TxFile,PREVREC);
              dbERR;
         END;
      GETITEM(DBACC,15);
      IF ( CURRINT=0 ) And ( NOT GEditing ) THEN
         BEGIN
              SETITEM;
              CURRINT:=FIRSTREC;
              PutXXXX(DBACC,15);
         END;
      SETITEM;
      CURRINT:=FIRSTREC;
      IF ACT=2 THEN CURRINT:=PAYREC;
      PutXXXX(DBACC,16);
      IF ACT IN [1,2,4] THEN
         BEGIN
              IF ACT IN [1,4] THEN
                 BEGIN
                      GETITEM(DBACC,7);
                      CURRLONG:=CURRLONG + ZTOTAMT[ZTX] + ZTOTTAX[ZTX];
                      PutXXXX(DBACC,7);
                 END;
              GETITEM(DBACC,8);
              CURRLONG:=CURRLONG + ZTOTAMT[ZTX];
              PutXXXX(DBACC,8);
         END;
      IF ACT=3 THEN
         BEGIN
              GETITEM(DBACC,7);
              CURRLONG:=CURRLONG - ZAMT[ZTX][1] - ZDISCOUNT[ZTX];
              PutXXXX(DBACC,7);
         END;
      ADDAGED:=FALSE;
      SUBAGED:=(ACT=3) AND (ZAMT[ZTX][1]+ZDISCOUNT[ZTX]>0);
      IF NOT SUBAGED THEN ADDAGED:=TRUE;
      IF ADDAGED THEN
         BEGIN
              GETITEM(DBACC,9);
              CASE ACT OF
                   1,4 : CURRLONG:= CURRLONG + ZTOTAMT[ZTX] + ZTOTTAX[ZTX];
	           3   : CURRLONG:= CURRLONG - ZAMT[ZTX][1] - ZDISCOUNT[ZTX];
              END;
              PutXXXX(DBACC,9);
         END;
      IF SUBAGED THEN
         BEGIN
              DEDUCTAMT:= ZAMT[ZTX][1] + ZDISCOUNT[ZTX];
              FOR X:=4 DOWNTO 1 DO
                  BEGIN
                       IF DEDUCTAMT>0 THEN
                          BEGIN
                               GETITEM(DBACC,8+X);
                               IF (CURRLONG>0) OR (X=1) THEN
                                  BEGIN
                                       IF (CURRLONG>DEDUCTAMT) OR (X=1) THEN
                                          BEGIN
                                               CURRLONG:=CURRLONG-DEDUCTAMT;
                                               DEDUCTAMT:=0;
                                               PutXXXX(DBACC,8+X);
                                          END
                                       ELSE
                                           BEGIN
                                                DEDUCTAMT:=DEDUCTAMT-CURRLONG;
                                                CURRLONG:=0;
                                                PutXXXX(DBACC,8+X);
                                           END;
                                  END;
                          END;
                  END;
         END;
      REWRITEREC(DBACC,ZCUSTREC[ZTX]);
      IF ERRORNO>0 THEN dbERR;
     end // not CashInc / CashExp
    END;						 { end UPCUST }

    PROCEDURE UPLD;
    BEGIN						 { begin UPLD }
      SETDB(TxFile);
      UPDATESTART;
      IF ((PROG IN [SALESTX,PURCHTX]) AND (ACT=3)) THEN
	BEGIN
	  SETITEM;
	  CURRINT:=ZBANK[1];
	  PutXXXX(TxFile,8);
	END;
    END;						  { end UPLD }

    PROCEDURE WRITEPAYMENT;
    var i,j:integer;
        ST : string;
    BEGIN						  { begin WRITEPAYMENT}
      IF  (PROG IN [CASHINC,CASHEXP])
      OR ((PROG IN [SALESTX,PURCHTX]) AND (ACT=2)) THEN
	BEGIN
          if PROG IN [SALESTX,PURCHTX] then begin
            // Accsdatamodule.TransactionsDB.Append;
            IF not GEditing then copyrecordtoend(Accsdatamodule.TransactionsDB);
          end;
          if ((PROG IN [CASHINC,CASHEXP]) and (Act = 1)) then begin      // TGM AB standing order
          //  IF not GEditing then copyrecordtoend(Accsdatamodule.TransactionsDB);
          end;
	  SETDB(TxFile);
	  Move(DATWORK^[CURROFST[TxFile]+1],WK[1],DB1.DBRECSZ);
          If GEditing Then
             Begin
                  Inc ( CTrans );
	          READXXX(TxFile,CTrans);
             End
          Else
	      READXXX(TxFile,(DB1.DBRECHIGH));  // tgm ab removed +1
	  IF ERRORNO > 0 THEN dbERR;
	  Move(WK[1],DATWORK^[CURROFST[TxFile]+1],DB1.DBRECSZ);
	  SETDBCR (TRUE,ZTOTAMT[ZTX]+ZTOTTAX[ZTX],
			ZBANK[ZTX],Cash1.XNOMDEBTOR,Cash1.XNOMCREDIT,ZBANK[ZTX]);
	  SETITEM;
	  CASE PROG OF
	    CASHINC : CURRINT:=12;
	    CASHEXP : CURRINT:=16;
	    SALESTX : CURRINT:=2;
	    PURCHTX : CURRINT:=6;
	  END;
	  PutXXXX(TxFile,1);
	 // PUTSTATUS; TGM AB Deleted

          SETITEM;
          CURRINT:=ZTXDATE[ZTX];
          PutXXXX(TxFile,2);

          SETITEM;                    // TGM AB 09/11/12
          CURRINT:=ZACCOUNT[ZTX];
          PutXXXX(TxFile,3);


	  CURRINT:=0;
	  PutXXXX(TxFile,16);
	  SETITEM;
	  IF ZCOMM[ZTX]<>NULL THEN
	    Move(ZCOMM[ZTX][1],CURRDISP[1],LENGTH(ZCOMM[ZTX]));
	  PutXXXX(TxFile,5);
// tgm next 3 lines altered to correct standing order not saving description bug
// included act <> 0 to prevent decription reverting to nominal desription for cashbook
// inc / exp
              If ((PROG IN [CASHINC,CASHEXP]) and (act <> 0) and (ZRef[1] <> 'DD / SO') and (ZRef[1] <> 'DC / SO')) then                         // Ch024 was - If (PROG IN [CASHINC,CASHEXP]) and (act <> 0) then
              If Zdesc[1,1][1]<>'' then begin
//                 for i:= 1 to 15 do Currdisp[i]:=' ';
                 for i:= 1 to 15 do if Zdesc[1,1][i]<>'' then Currdisp[i]:=Zdesc[1,1][i];
	         PutXXXX(TxFile,5);
              end;
    	  CURRINT:=ZBANK[ZTX];
	  PutXXXX(TxFile,8);
	  CURRLONG:=ZTOTAMT[ZTX]+ZTOTTAX[ZTX];
	  PutXXXX(TxFile,9);
	  CURRLONG:=0;
	  PutXXXX(TxFile,11);
	  SETITEM;
	  CURRDISP[1]:=SPACE1;
	  PutXXXX(TxFile,10);

          IF (PROG IN [CASHINC,CASHEXP]) then begin
             SETITEM;
             CURRLONG:=ZTOTAMT[ZTX]+ZTOTTAX[ZTX];
             PutXXXX(TxFile,100);
             SETITEM;
             CURRLONG:=ZTOTTAX[ZTX];
             PutXXXX(TxFile,101);
          end;



          // TGM AB - update Stub No when editing
          STR (ZSTUB[ZTX],ST);
	  WHILE LENGTH(ST)<8 DO ST:=CONCAT('0',ST);
	  Move (ST[1],CURRDISP[1],LENGTH(ST));
	  PutXXXX (TxFile,26);


	  {
          DISI (60,24,DB1.DBRECHIGH+1,5);
	  DIS  (66,24,'(ANALYSIS REC)');
	  }
          If GEditing Then
             Begin
                  PAYREC:=CTrans;
                  ReWriteXXX(TxFile,CTrans);
             End
	  Else
             Begin
                  PAYREC:=DB1.DBRECHIGH;   // tgm ab removed +1
                  ADDXXXXXX(TxFile,DB1.DBRECHIGH);  //tgm ab removed + 1
             End;

	  If ERRORNO > 0 THEN dbERR;
          If GEditing Then
	     LOGNOM(TRUE,0)
	  Else
              LOGNOM(TRUE,DB1.DBRECHIGH);
	END;
      // Test for Discount Line when editing
      // If ZDISCOUNT[ZTX]<>0 THEN
      // Accsdatamodule.TransactionsDB.Post;


 (*     If  ( ZDISCOUNT[ZTX]<>0 ) Or
         (
           (( PROG In [SalesTx, PurchTx] ) And ( Act = 3 ) And ( gEditing )) And
           (
             ((ZTX=1) And ( ZDISCOUNT[1] = 0 ) And ( ZDISCOUNT[2]<>0 ) ) Or
             ((ZTX=1) And ( ZTOTAMT[1] = 0 ) And ( ZTOTAMT[2] <> 0 )
                      And ( TxEditRec.NoRecs = 2 )) Or
             ((ZTX=1) And ( ZTOTAMT[1] <> 0 ) And ( ZTOTAMT[2] = 0 )
                      And ( TxEditRec.NoRecs = 2 ))
           )
         ) THEN *)

        If ((PROG In [SalesTx, PurchTx]) And ( Act = 3 )) then

       	BEGIN

          if (GEditing and (TxEditRec.TransF = TxEditRec.TransT)) then exit;  // TGM AB 16/11/12

          if not GEditing then copyrecordtoend(Accsdatamodule.TransactionsDB)
             else READXXX(TxFile,CTrans+1);
             // TGM AB added GEditing and readxxx to fix editing discounts bug
	  SETDBCR (TRUE,ZDISCOUNT[ZTX],
		   Cash1.XNOMSLDISC,Cash1.XNOMDEBTOR,Cash1.XNOMCREDIT,Cash1.XNOMPLDISC);
	  SETDB(TxFile);
     //	  Move(DATWORK^[CURROFST[TxFile]+1],WK[1],DB1.DBRECSZ);


          If GEditing Then
             Begin
                  Inc ( CTrans );
	          READXXX(TxFile,CTrans);
                  ReadRec ( TxFile, CTrans-1);       // TGM AB Updating figures when editing
                  getitem(Txfile,9);
                  ReadRec ( TxFile, CTrans);
                  putitem(Txfile,9);
                  ReadRec ( TxFile, CTrans-1);
                  getitem(Txfile,11);
                  ReadRec ( TxFile, CTrans);
                  putitem(Txfile,11);

                  // Ch016 - start
                  ReadRec ( TxFile, CTrans-1);
                  getitem(Txfile,2);
                  ReadRec ( TxFile, CTrans);
                  putitem(Txfile,2);
                  // Ch016 - end

              End
          Else
	        READXXX(TxFile,DB1.DBRECHIGH);       // tgm ab +1?
            //  begin
           //   Accsdatamodule.TransactionsDB.post;
           //   Accsdatamodule.TransactionsDB.edit;
           //   copyrecordtoend(Accsdatamodule.TransactionsDB);
           //   ACCSDATAMODULE.TransactionsDB.Prior;
           //   GetItem (TxFile,8);
           //   PutItem (TxFile,18); // TGM AB}
           //   Accsdatamodule.TransactionsDB.next;
           //   end;

	  IF ERRORNO > 0 THEN dbERR;
    //	  Move(WK[1],DATWORK^[CURROFST[TxFile]+1],DB1.DBRECSZ);
	  SETITEM;
	  CURRINT:=9;
	  PutXXXX(TxFile,1);
	//  PUTSTATUS; TGM AB Deleted
	  {
          DISI (60,24,DB1.DBRECHIGH+1,5);
	  DIS  (66,24,'(ANALYSIS REC)');
	  }
          If GEditing Then
             ReWriteXXX(TxFile,CTrans)
          Else
               ADDXXXXXX(TxFile,DB1.DBRECHIGH);
	  IF ERRORNO > 0 THEN dbERR;
	  If GEditing Then
             LOGNOM(TRUE,0)
          Else
             LOGNOM(TRUE,DB1.DBRECHIGH);
	END;
      IF ((PROG IN [SALESTX,PURCHTX]) AND (ACT=2)) THEN
	BEGIN
	  READXXX(TxFile,FIRSTREC);
	  IF ERRORNO > 0 THEN dbERR;
	  CURRINT:=PAYREC;
	  PutXXXX(TxFile,16);
	  REWRITEXXX(TxFile,FIRSTREC);
	  IF ERRORNO > 0 THEN dbERR;
	END;
    END;						{ end WRITEPAYMENT }

    PROCEDURE WRITE9AMT;
    VAR
      Y, A, I : INTEGER;
      ST : String;
    BEGIN						{ begin WRITE9AMT }
      // TGM AB 15/07/04 Removed memory move operations
      SETDB(TxFile);
      // Move(DATWORK^[CURROFST[TxFile]+1],WK[1],DB1.DBRECSZ);
      If GEditing Then
         READXXX(TxFile,CTrans)
      Else
         READXXX(TxFile,DB1.DBRECHIGH+1);

      try
          if not AccsDataModule.ProdsTxTemp.Active then
             AccsDataModule.ProdsTxTemp.Active := True; //

          if AccsDataModule.ProdsTxTemp.Locate('LineNo',LineX,[] ) then
             begin
                AccsDataModule.ProdsTxTemp.Edit;
                if GEditing then
                   AccsDataModule.ProdsTxTemp.FieldByName('TxNo').AsInteger := CTrans
                else
                   AccsDataModule.ProdsTxTemp.FieldByName('TxNo').AsInteger := DB1.DBRECHIGH+1;
                AccsDataModule.ProdsTxTemp.Post;
             end;
      except
         on e : exception do
            showmessage(e.message);
      end;

      IF ERRORNO>0 THEN dbERR;
      // Move(WK[1],DATWORK^[CURROFST[Txfile]+1],DB1.DBRECSZ);
      IF Cash2.XINVALLOC THEN
         IF (PROG IN [SALESTX,PURCHTX]) AND (ACT IN [1,2]) THEN
            BEGIN
               SETITEM;
               PutXXXX(TxFile,31);
               PutXXXX(TxFile,30);
               PutXXXX(TxFile,29);
            END;

      SETITEM;
      CURRINT:=9;
      PutXXXX(TxFile,1);
    // TGM AB Deleted  PUTSTATUS;
      CURRINT:=0;
      PutXXXX(TxFile,16);
      SETITEM;
      IF ZDESC[ZTX][LineX]<>NULL THEN
    	      Move(ZDESC[ZTX][LineX][1],CURRDISP[1],length(ZDESC[ZTX][LineX]));
      //for i:= 1 to  length(ZDESC[ZTX][LineX][1] do CurrStr := CurrStr + CurrDisp
    //  Currstr := ZDESC[ZTX][LineX][1];
      PutXXXX(TxFile,5);
      SETITEM;
      CURRINT:=ZANALYSIS[ZTX][LineX];
      PutXXXX(TxFile,12);
      CURRINT:=ZGEN[ZTX][LineX];
      PutXXXX(TxFile,8);
      CURRLONG:=ZQTY[ZTX][LineX];
      PutXXXX(TxFile,6);
      CURRLONG:=ZQTY2[ZTX][LineX];    // TGM AB 01/02/13
      PutXXXX(TxFile,32);             // TGM AB 01/02/13
      CURRLONG:=ZQTY3[ZTX][LineX];    // TGM AB 01/02/13
      PutXXXX(TxFile,33);             // TGM AB 01/02/13
      CURRLONG:=ZAMT[ZTX][LineX];
      PutXXXX(TxFile,9);

      SETITEM;
      CURRDISP[1]:=ZTAX[ZTX][LineX][1];
      PutXXXX(TxFile,10);
      SETITEM;
      CURRLONG:=ZTAXAMT[ZTX][LineX];
      PutXXXX(TxFile,11);
      SETITEM;

      // TGM AB

      CURRINT:=ZTXDATE[ZTX];
      PutXXXX(TxFile,2);
      SETITEM;
      CURRINT:=ZACCOUNT[ZTX];
      PutXXXX(TxFile,3);
      SETITEM;
      STR (ZSTUB[ZTX],ST);
      WHILE LENGTH(ST)<8 DO ST:=CONCAT('0',ST);
      Move (ST[1],CURRDISP[1],LENGTH(ST));
      PutXXXX (TxFile,26);
      SETITEM;

      IF ZREF[ZTX]<>NULL THEN Move(ZREF[ZTX][1],CURRDISP[1],LENGTH(ZREF[ZTX]));
      PutXXXX(TxFile,4);
      SETITEM;
      CASE PROG OF
                CASHINC : CURRINT:=11;
                CASHEXP : CURRINT:=15;
                SALESTX : CASE ACT OF
                          1,2 : CURRINT:=1;
                          3   : CURRINT:=2;
                          4   : CURRINT:=3;
                END;
                PURCHTX : CASE ACT OF
                          1,2 : CURRINT:=5;
                          3   : CURRINT:=6;
                          4   : CURRINT:=7;
                END;
      END;
      PutXXXX(TxFile,23);

      IF ZENT[ZTX][LineX]<>NULL THEN
	      Move (ZENT[ZTX][LineX][1],CURRDISP[1],LENGTH(ZENT[ZTX][LineX]));
      PutXXXX(TxFile,24);
      SETDBCR (TRUE,ZAMT[ZTX][LineX],
   	       Cash1.XNOMDEBTOR,ZGEN[ZTX][LineX],ZGEN[ZTX][LineX],Cash1.XNOMCREDIT);
      SETDB(TxFile);
      { // TGM AB Removed this section as i can't see its needed with paradox table
      IF (PROG IN [SALESTX,PURCHTX]) AND (ACT IN [1,4]) THEN
         FOR Y:=1 TO MaxGridLines DO  // TENFOUND
             IF DB1.DBITEMS[32+Y].DBINAME<>NULL THEN
                BEGIN
                     SETITEM;
                     CASE DB1.DBITEMS[32+Y].DBITYPE[0] OF
                          'X','Y','?' : IF LENGTH(ZUSER1[ZTX][LineX][Y])>0 THEN
				                       Move (ZUSER1[ZTX][LineX][Y][1],CURRDISP[1],LENGTH(ZUSER1[ZTX][LineX][Y]));
                          'K','L','M' : CURRLONG:=ZUSER2[ZTX][LineX][Y];
                          'N','D','E' : CURRINT :=ZUSER3[ZTX][LineX][Y];
                     END;
                     IF (DB1.DBITEMS[32+Y].DBITYPE='Y') AND
                        (DB1.DBITEMS[32+Y].DBISIZE= 5 ) THEN
                        BEGIN
                             STRLONG (ZUSER1[ZTX][LineX][Y],CURRLONG);
                             IF (CURRLONG>=-9999) AND
                                (CURRLONG<=+9999) THEN CURRINT:=TRUNC(CURRLONG);
                        END;
                     PutXXXX (TxFile,32+Y);
                END;
       }
      {
      DISI (60,24,DB1.DBRECHIGH+1,5);
      DIS  (66,24,'(ANALYSIS REC)');
      }
      TYPE9[LineX]:=DB1.DBRECHIGH;    // tgm ab removed + 1
      If GEditing Then ReWriteXXX ( TxFile, CTrans );

      IF ERRORNO>0 THEN dbERR;
      If GEditing Then
         LOGNOM(TRUE,0)
      Else
          LOGNOM(TRUE,DB1.DBRECHIGH);

      If Not GEditing Then ADDXXXXXX(TxFile,DB1.DBRECHIGH+1);

    END;						 { end WRITE9AMT }

    PROCEDURE SLPLDETAIL;
    var
    tempstring : shortstring;

      PROCEDURE SP1;
      BEGIN						 { begin SP1 }
         UPLD;

         SETDB(TxFile);
         db1.DBRECHIGH := accsdatamodule.TransactionsDB.RecordCount;

         If GEditing Then
            Begin
                 FIRSTREC :=CTrans;
                 TXNO	  :=CTrans;
            End
         Else
             Begin
                     FIRSTREC:=DB1.DBRECHIGH;
                     TXNO:=DB1.DBRECHIGH;

             End;
        {
         STR  ( DB1.DBRECTOT,TOPREC);
        DIS  ( 1,24,'WRITING TRANSACTION ... ');
	DISI (25,24,DB1.DBRECHIGH+1,5);
	DIS  (31,24,CONCAT('(OF ',TOPREC,')'));
	}
         IF ((PROG IN [SALESTX,PURCHTX]) AND (ACT=3)) THEN
            SETDBCR (TRUE,ZTOTAMT[ZTX],ZBANK[ZTX],Cash1.XNOMDEBTOR,Cash1.XNOMCREDIT,ZBANK[ZTX]);
        If GEditing Then
            ReWriteXXX ( TxFile, CTrans )
         Else
             if not ((Prog in [SALESTX,PURCHTX]) AND (ACT=3)) then ADDXXXXXX(TxFile,DB1.DBRECHIGH); // tgm ab was +1

         IF ERRORNO>0 THEN dbERR;
         IF ((PROG IN [SALESTX,PURCHTX]) AND (ACT=3)) THEN
            Begin
               If GEditing Then
                  LOGNOM( TRUE, 0 )
               Else
                   LOGNOM( TRUE, DB1.DBRECHIGH );
            End;
      END;						 { end SP1 }

      Procedure WriteTax;

          Function NOTVatLine ( Var TestTrans : Integer ) : Boolean;
          Var
             TempBool : Boolean;
             Counter : Integer;
          Begin
              TempBool := TRUE;
              Counter := 1;
              while Counter <= ((MaxGridLines*2)+2) Do  //TENFOUND 22
                 begin
                    if ( TxEditRec.TxNo[Counter] = TestTrans ) Then
                       begin
                          if ( TxEditRec.TxType[Counter] = 0 ) Then
                             TempBool := FALSE;
                          {
                          if ( TxEditRec.TxType[Counter] > 0 ) Then
                             begin
                                Dec ( TestTrans );
                                TempBool := True;
                             end;
                          }
                          Counter := ((MaxGridLines*2)+3); //23
                       end;
                    Inc ( Counter );
                 end;
              if TempBool then
                 Dec ( TestTrans );
              Result := TempBool;
          end;
      Var
         ST, tempstr : String;
         A : Integer;
      Begin
           // TGM AB 15/07/04 Removed memory operations
           SETDB(TxFile);
           // Move(DATWORK^[CURROFST[TxFile]+1],WK[1],DB1.DBRECSZ);
           If GEditing Then
              Begin
                   Inc ( CTrans );
                   If NOTVatLine ( CTrans ) Then Exit;
                   READXXX(TxFile,CTrans);
              End
           Else
               READXXX(TxFile,DB1.DBRECHIGH);     // ?? +1 TGM AB
           dbERR;
           // Move(WK[1],DATWORK^[CURROFST[TxFile]+1],DB1.DBRECSZ);
           //SETITEM;

           // TGM AB
           SETITEM;
           IF ZDESC[ZTX][LineX]<>NULL THEN
    	      Move(ZDESC[ZTX][LineX][1],CURRDISP[1],length(ZDESC[ZTX][LineX]));
           PutXXXX(TxFile,5);
           SETITEM;
           CURRINT:=ZTXDATE[ZTX];
           PutXXXX(TxFile,2);
           CURRINT:=ZACCOUNT[ZTX];
           PutXXXX(TxFile,3);
           CURRINT:=ZGEN[ZTX][LineX];
           PutXXXX(TxFile,8);
           CURRLONG:=ZQTY[ZTX][LineX];
           PutXXXX(TxFile,6);
           CURRLONG:=ZQTY2[ZTX][LineX];    // TGM AB 01/02/13
           PutXXXX(TxFile,32);             // TGM AB 01/02/13
           CURRLONG:=ZQTY3[ZTX][LineX];    // TGM AB 01/02/13
           PutXXXX(TxFile,33);             // TGM AB 01/02/13
           IF ZENT[ZTX][LineX]<>NULL THEN
	      Move (ZENT[ZTX][LineX][1],CURRDISP[1],LENGTH(ZENT[ZTX][LineX]));
           PutXXXX(TxFile,24);
           SETITEM;
           IF ZREF[ZTX]<>NULL THEN begin
                                        FILLCHAR (CURRDISP[1],MAXISIZE,SPACE1);
                                        Move(ZREF[ZTX][1],CURRDISP[1],LENGTH(ZREF[ZTX]));
                                        {tempstr := ZREF[ZTX][1];
                                        for A := 1 to 64 do begin
                                           currdisp[A] := ' ';
                                        end;
                                        for A := 1 to length(tempstr) do begin
                                           currdisp[A] := tempstr[A];
                                        end; }
                                   end;
           PutXXXX(TxFile,4);
          { SETITEM;
           CURRDISP[1]:=ZTAX[ZTX][LineX][1];
           PutXXXX(TxFile,10);  }
           SETITEM;
           CASE PROG OF
                CASHINC : CURRINT:=11;
                CASHEXP : CURRINT:=15;
                SALESTX : CASE ACT OF
                          1,2 : CURRINT:=1;
                          3   : CURRINT:=2;
                          4   : CURRINT:=3;
                END;
                PURCHTX : CASE ACT OF
                          1,2 : CURRINT:=5;
                          3   : CURRINT:=6;
                          4   : CURRINT:=7;
                END;
           END;
           PutXXXX(TxFile,23);


           CURRINT:=0;
           PutXXXX(TxFile,1);
           // TGM AB Deleted PUTSTATUS;
           SETITEM;
           PutXXXX(TxFile,16);
           SETITEM;
           STR (ZSTUB[ZTX],ST);
           WHILE LENGTH(ST)<8 DO ST:=CONCAT('0',ST);
           Move (ST[1],CURRDISP[1],LENGTH(ST));
           PutXXXX (TxFile,26);

           SETITEM;
           Currint := ZANALYSIS[ZTX][LineX];
           PutXXXX(TxFile,12);
           SETITEM;
           CURRLONG:=ZAMT[ZTX][LineX];
           PutXXXX(TxFile,9);
           SETITEM;
           CURRDISP[1]:=ZTAX[ZTX][LineX][1];
           PutXXXX(TxFile,10);
           SETITEM;
           CURRLONG:=ZTAXAMT[ZTX][LineX];
           PutXXXX(TxFile,11);
           SETDBCR (TRUE,ZTAXAMT[ZTX][LineX],Cash1.XNOMDEBTOR,
                    Cash1.XNOMTAX,Cash1.XNOMTAX,Cash1.XNOMCREDIT);
           IF GEditing Then
              ReWriteXXX(TxFile,CTrans)
           Else
               ADDXXXXXX(TxFile,DB1.DBRECHIGH);   // TGB AB was +1
           dbERR;
           CURRDISP[1]:=SPACE1;
           //PutXXXX(TxFile,10); TGM AB removed blanks out vat code in paradox
           If GEditing Then
              LOGNOM(TRUE,0)
           Else
               LOGNOM(TRUE,DB1.DBRECHIGH);
      End;

    BEGIN						 { begin SLPLDETAIL }
      SP1;
      IF  (PROG IN [CASHINC,CASHEXP])
      OR ((PROG IN [SALESTX,PURCHTX]) AND (ACT IN [1,2,4])) THEN
         BEGIN
              For LineX := 1 To ANALTOT Do
                  Begin
                       If GEditing Then Inc ( CTrans );
                  {     if not GEditing then begin
                          Accsdatamodule.TransactionsDB.append;
                          AccsDatamodule.TransactionsDB.post;
                       end;
                   }    WRITE9AMT;
                        if PROG in [CASHINC,CASHEXP] then AccsDatamodule.TransactionsDB.post;
{ 1993 }
                       { xCountry  1 = UK 2 = IRL }
                       {
                       if (( ZTAXAMT[ZTX][LineX] <> 0 ) or
                           ( ZTAX[ZTX][LineX] = Cash1.XTAXIDS[0] )) or
                          (( Cash2.XCOUNTRY = 1 ) and
                           ( ZTAX[ZTX][LineX] = Cash1.XTAXIDS[1] )) or
                          (( ZTaxAmt[2,Linex] <> 0 ) and ( GEditing )) Then
                          begin
                       }
                       // Always write a Tax Line
                   {    if not GEditing then begin
                          Accsdatamodule.TransactionsDB.append;
                          AccsDatamodule.TransactionsDB.post;
                       end;
                    }   WriteTax;
                        if PROG in [CASHINC,CASHEXP] then AccsDatamodule.TransactionsDB.post;
                       //   end;
                  end;
         end;
      If  (PROG IN [CASHINC,CASHEXP])
      OR ((PROG IN [SALESTX,PURCHTX]) AND (ACT IN [2,3])) THEN  begin // Act 3 - Purchase Payment

         if ((PROG IN [CASHINC,CASHEXP]) and (not GEditing)) then copyrecordtoend(Accsdatamodule.TransactionsDB);
       //  if not ((PROG IN [SALESTX,PURCHTX]) AND (ACT =3)) then copyrecordtoend(Accsdatamodule.TransactionsDB);

         WRITEPAYMENT;	(* MUST BE BEFORE UPCUST    *)
			(* MUST BE LAST TRANS WRITE *)
         end;
      IF PROG IN [SALESTX,PURCHTX,CASHINC,CASHEXP] THEN UPCUST;   // was [SALESTX,PURCHTX] TGM AB
   //   IF ((cash1.Xcashbook = true) and (Cash11.xuse_inc_exp = false) and (PROG IN [CASHINC,CASHEXP])) THEN UPCUST;
      If ( ZTX = 1 ) And ( NOT gEditing ) Then
         Begin

            if (NOTIFY_TRANSACTION_WRITE_SUCCESS) then
                MessageDlg('Transaction No ' + IntToStr ( FirstRec ) + ' Saved', mtInformation,[mbOK], 0);

     //       Currrec[TxFile] := FirstRec;   // Paradox sets current database record number

            // TGM AB 07/07/05 - fixes bug with default date not always being set to the last saved transaction date

            try  KDateToStr ( zTxDate[1], TempString );
                 cash1.XDATE := TempString;
                 defwrite (0);
                 
            except
            end;

//            If ( Prog In [CASHINC,CASHEXP] ) And ( NOT GEditing ) Then

            If ((PROG IN [SALESTX,PURCHTX]) AND (ACT IN [2,3]) And ( NOT (OldAct In [61,62])) OR
                (Prog IN [CASHINC,CASHEXP])) AND (NOT GEditing) AND (NOT SOrder)  Then
         //     If MessageDlg('Stub ' + IntToStr (zStub[1] ) + ' Details Completed',           TGM AB 19/10/12 - Gerry requested this prompt be removed aqs no longer that relevant to users
         //                     mtInformation,[mbYes,mbNo],0) = mrYes Then
         //         Begin

                      zStub[1] := zStub[1]+1;
                      Case Prog Of
                           CASHINC,
                           SALESTX : DelphiLongToPSys ( zStub[1], Cash1.xRecStub );
                           CASHEXP,
                           PURCHTX : DelphiLongToPSys ( zStub[1], Cash1.xPayStub );
                      End;
                      if PROG in [CASHINC,CASHEXP] then
                         begin
                            Cash1.xDefBank := ZBANK[1];
                            Cash1.xLastBank := ZBANK[1];
                         end;
          //        End
         End;
    END;						 { end SLPLDETAIL }

    PROCEDURE NOMDETAIL;
    VAR
      X,TOT   : INTEGER;
      ANALTOT : INTEGER;
      ST      : STRING;
    BEGIN						  { begin NOMDETAIL }
      AnalTot := 0;
      FOR X:=1 TO MaxGridLines DO IF ZUSE[ZTX][X] THEN ANALTOT:=X; // TENFOUND
      TOT:=ANALTOT;
      FOR X:=1 TO MaxGridLines DO // TENFOUND
	IF ZUSE[ZTX][X] THEN
	  IF (ACT=10) AND (ZTAXAMT[ZTX][X]<>0) THEN TOT:=TOT+1;
     // TESTTX(TOT); Removed TGM AB
      {
      STR (DB1.DBRECTOT,TOPREC);
      DIS ( 1,24,'WRITING TRANSACTION ... ');
      DIS (31,24,CONCAT('(OF ',TOPREC,')'));
      }
      SetDB(Txfile);
      If GEditing Then
         TxNo := TxEditRec.TransF
      Else
          TXNO:=DB1.DBRECHIGH;  // was DBRECHIGH+1
      FOR X:=1 TO ANALTOT DO
	BEGIN
          Inc(TxNo);
	  SETDB(TxFile);
          If GEditing Then
	     READXXX(TxFile,CTrans)
	  Else
             READXXX(TxFile,TXNO);   // was DBRECHIGH+1
	  IF ERRORNO>0 THEN dbERR;
      //	  If NOT GEditing Then BLANKREC(TxFile,'A');   // TGM replaced with following lines
          if NOT GEditing then begin
             if prog = journal then begin
             Accsdatamodule.TransactionsDB.last;
             Accsdatamodule.TransactionsDB.edit;
             end
                else BLANKREC(TxFile,'A');
      // TGM AB
          end;
	  CURRINT:=9;
	  PutXXXX(TxFile,1);
	  // TGM AB Deleted PUTSTATUS;
	  CURRINT:=ZTXDATE[ZTX];
	  PutXXXX(TxFile,2);
	  SETITEM;
	  IF ZREF[ZTX]<>NULL THEN
	    Move(ZREF[ZTX][1],CURRDISP[1],LENGTH(ZREF[ZTX]));
	  PutXXXX(TxFile,4);

	  {
          if ( screen_type = reg_trans ) then
	    Begin
	       setitem;
	       currlong := zqty[ztx][x];
	       PutXXXX ( 2, 6 );
	    End;
          }
          // If there is a Qty in the zQty array then add it to the record
          if ( zQty[ztx,1] <> 0 ) then
             begin
                SetItem;
                CurrLong := zQty[ztx,1];
                PutXXXX ( TxFile, 6 );
             end;
          if ( zQty2[ztx,1] <> 0 ) then        // TGM AB 01/02/13
             begin                             // TGM AB 01/02/13
                SetItem;                       // TGM AB 01/02/13
                CurrLong := zQty2[ztx,1];      // TGM AB 01/02/13
                PutXXXX ( TxFile, 32 );        // TGM AB 01/02/13
             end;                              // TGM AB 01/02/13
          if ( zQty3[ztx,1] <> 0 ) then        // TGM AB 01/02/13
             begin                             // TGM AB 01/02/13
                SetItem;                       // TGM AB 01/02/13
                CurrLong := zQty3[ztx,1];      // TGM AB 01/02/13
                PutXXXX ( TxFile, 33 );        // TGM AB 01/02/13
             end;                              // TGM AB 01/02/13

	  SETITEM;
	  CURRINT:=ZANALYSIS[ZTX][X];
	  PutXXXX(TxFile,12);
	  SETITEM;
	  IF ZDESC[ZTX][X]<>NULL THEN
	    Move(ZDESC[ZTX][X][1],CURRDISP[1],LENGTH(ZDESC[ZTX][X]));
	  PutXXXX(TxFile,5);
	  CURRLONG:=ZAMT[ZTX][X];
	  PutXXXX(TxFile,9);
	  CASE ACT OF
	    1 : SETNOM(ZAMT[ZTX][X],ZGEN[ZTX][X],ZBANK[ZTX]);
	    2 : SETNOM(ZAMT[ZTX][X],ZBANK[ZTX],	 ZGEN[ZTX][X]);
	    3 : SETNOM(ZAMT[ZTX][X],Cash1.XNOMTAX,	 ZBANK[ZTX]);
	    4 : SETNOM(ZAMT[ZTX][X],ZBANK[ZTX],	 Cash1.XNOMTAX);
	    5 : SETNOM(ZAMT[ZTX][X],ZBANK2[ZTX], ZBANK[ZTX]);
	    6 : SETNOM(ZAMT[ZTX][X],ZDB[ZTX][X], ZCR[ZTX][X]);
	   10 : SETNOM(ZAMT[ZTX][X],ZDB[ZTX][X], ZCR[ZTX][X]);
	  END;
	  IF ACT=10 THEN
	    BEGIN
	      SETITEM;
	      CURRDISP[1]:=ZTAX[ZTX][X][1];
	      PutXXXX(TxFile,10);
	      SETITEM;
	      CURRLONG:=ZTAXAMT[ZTX][X];
	      PutXXXX(TxFile,11);
	    END;
	  IF ACT=5 THEN
	    BEGIN
	      SETITEM;
	      STR (ZSTUB[ZTX],ST);
	      WHILE LENGTH(ST)<8 DO ST:=CONCAT('0',ST);
	      Move (ST[1],CURRDISP[1],LENGTH(ST));
	      PutXXXX (TxFile,26);
              SETITEM;
              If GEditing And Presented Then
                 CURRDISP[1]:='P'
              Else
                  CURRDISP[1]:='U';
              PutXXXX (TxFile,27);
	    END;
	  {
          DISI (25,24,DB1.DBRECHIGH+1,5);
	  }
          If GEditing Then
             ReWriteXXX(TxFile,CTrans);
       //   Else
       //       ADDXXXXXX(TxFile,DB1.DBRECHIGH+1);
	  IF ERRORNO>0 THEN dbERR;
          SetDB(TxFile);
          If GEditing Then
             LogNom ( True, 0 )
          Else
	      LOGNOM(TRUE,DB1.DBRECHIGH);
	  {
	  IF ZTAXAMT[ZTX][X]<>0 THEN
	    BEGIN
	      SETDB (2);
	      Move(DATWORK[CURROFST[TxFile]+1],WK[1],DB1.DBRECSZ);
	      READXXX(2,DB1.DBRECHIGH+1);
	      IF ERRORNO>0 THEN ERR;
	      Move(WK[1],DATWORK[CURROFST[TxFile]+1],DB1.DBRECSZ);
	      SETITEM;
	      CURRINT:=0;
	      PutXXXX(2,1);
	      PUTSTATUS;
	      SETITEM;
	      CURRLONG:=ZAMT[ZTX][X];
	      PutXXXX(2,9);
	      SETITEM;
	      CURRDISP[1]:=ZTAX[ZTX][X][1];
	      PutXXXX(2,10);
	      SETITEM;
	      CURRLONG:=ZTAXAMT[ZTX][X];
	      PutXXXX(2,11);
	      SETNOM (ZTAXAMT[ZTX][X],ZDB[ZTX][X],XNOMTAX);
	      DISI (60,24,DB1.DBRECHIGH+1,5);
	      DIS  (66,24,'(ANALYSIS REC)');
	      ADDXXXXXX(2,DB1.DBRECHIGH+1);
	      IF ERRORNO>0 THEN ERR;
	      CURRDISP[1]:=SPACE1;
	      PutXXXX(2,10);
	      LOGNOM(TRUE,DB1.DBRECHIGH);
	    END;
	  }
	END;
      If ( ztx = 1 ) Then
         MessageDlg('Transaction No ' + IntToStr ( TxNo ) + ' Saved', mtInformation,[mbOK], 0);
    END;						 { end NOMDETAIL }

BEGIN							 { begin WRITETRANSACTIONS }

  CTrans  := 0;
  GArrPos := 1;
  CheckBank := False;
  If GEditing Then
     Begin
        CTrans := TxEditRec.TransF;
        CheckBank := Presented And (( zBank[1] <> zBank[2] ) Or
                                    ( zTotAmt[1]+zTotTax[1] <> 0-(zTotAmt[2]+zTotTax[2]) ));
     End;
  CASE PROG OF
    CASHINC,CASHEXP,SALESTX,PURCHTX : SLPLDETAIL;

    JOURNAL			    : NOMDETAIL;
  END;
  WRITEXXX;
  // SP - 30/07/2015 - Prevent the main grid reloading after each transaction write (during bank import)
  If ( NOT GEditing ) and (not PREVENT_TRANSACTIONGRID_LOADING_ON_TRANSACTION_WRITE) Then
     begin
        PostMessage(MainScreenHandle, WM_LOADTRANSACTIONDATA, 0,0);
     end;

  { Reset the bank balances if editing }
  If GEditing And CheckBank And ( ztx = 1 ) Then
     UpdateTempBanks;

  {CashBook.CashBookForm.Refresh;}
  {
  check_analysis;
  }

  // Update the Products Trans Table
  try
     with AccsDataModule do
        begin
           ProdsTxTemp.Open;
           if not ProdsTx.Active then ProdsTx.Open;;
           ProdsTxTemp.First;
           while NOT ProdsTxTemp.EOF do
              begin
                 if ProdsTx.Locate('TxNo',ProdsTxTemp.FieldByName('TxNo').AsInteger,[] ) then
                    begin
                       ProdsTx.Edit;
                       ProdsTx['LineRef'] := ProdsTxTemp['LineRef'];
                       ProdsTx['LineDate'] := ProdsTxTemp['Linedate'];
                       ProdsTx.FieldByName('LineNo').AsInteger := ProdsTxTemp.FieldByName('LineNo').AsInteger;
                       ProdsTx.FieldByName('Desc1').AsString := ProdsTxTemp.FieldByName('Desc1').AsString;
                       ProdsTx.FieldByName('Desc2').AsString := ProdsTxTemp.FieldByName('Desc2').AsString;
                       ProdsTx.FieldByName('Desc3').AsString := ProdsTxTemp.FieldByName('Desc3').AsString;
                       ProdsTx.FieldByName('ProductID').AsString := ProdsTxTemp.FieldByName('ProductID').AsString;
                       ProdsTx.Post;
                    end
                 else
                    begin
                       ProdsTx.Append;
                       ProdsTx.FieldByName('TxNo').AsInteger := ProdsTxTemp.FieldByName('TxNo').AsInteger;
                       ProdsTx['LineRef'] := ProdsTxTemp['LineRef'];
                       ProdsTx['LineDate'] := ProdsTxTemp['Linedate'];
                       ProdsTx.FieldByName('LineNo').AsInteger := ProdsTxTemp.FieldByName('LineNo').AsInteger;
                       ProdsTx.FieldByName('Desc1').AsString := ProdsTxTemp.FieldByName('Desc1').AsString;
                       ProdsTx.FieldByName('Desc2').AsString := ProdsTxTemp.FieldByName('Desc2').AsString;
                       ProdsTx.FieldByName('Desc3').AsString := ProdsTxTemp.FieldByName('Desc3').AsString;
                       ProdsTx.FieldByName('ProductID').AsString := ProdsTxTemp.FieldByName('ProductID').AsString;
                       ProdsTx.Post;
                    end;
                 ProdsTxTemp.Next;
              end;
           ProdsTxTemp.Close;
           ProdsTxTemp.EmptyTable;
           ProdsTxTemp.Open;
        end;
  except
      ShowMessage('Could not update the Extra Details');
  end;

END;							  { end UPDATELEDGER }

function LoadTrans : Boolean;
Var
   PrevType9    : Boolean;
   EditRecCount : Integer;
   St           : String;

Begin
    RESULT := TRUE;
    ACT := 0;
    EditRecCount := 1;
    InitVals;
    SetDb ( TxFile );

    ReadRec ( TxFile, TxEditRec.TransF );
    dberr;
    EDFROM := TxEditRec.TransF; {CashBookForm.CurrTrans;}

    Getitem ( TxFile, 1 );
    EdType := Currint;
    Getitem ( TxFile, 23 );
    txt := Currint;

    {
    TxEditRec.TxType[EditRecCount] := EdType;
    TxEditRec.TxNo[EditRecCount] := TxEditRec.TransF;
    }
    GETITEM (TxFile,3);
    ZCUSTREC[1]:=CURRINT;
    ZACCOUNT[1]:=CURRINT;
    GETITEM (TxFile,31);
    ZDUESTR[1]:=CURRSTR;
    ZDUEINT[1]:=CURRINT;
    GETITEM (TxFile,30);
    ZALLOC[1]:=CURRDISP[1];
    GETITEM (TxFile,29);
    ZAMTPAID[1]:=CURRLONG;
    GETITEM ( TxFile, 2);
    ZTXDATE[1]:=CURRINT;
    WORKDATE:=COPY(CURRSTR,1,8);
    GETITEM ( TxFile, 4);
    ZREF[1]:=CURRSTR;
    GETITEM ( TxFile, 5);
    ZCOMM[1]:=CURRSTR;
    GETITEM ( TxFile, 9);
    IF EDTYPE IN [3,7] THEN CURRLONG:=0-CURRLONG;
    ZTOTAMT[1]:=CURRLONG;
    IF EDTYPE IN [2,6,9,0] THEN
      BEGIN
	ZAMT[1][1]:=CURRLONG;
	ZAMT[2][1]:=0-CURRLONG;
	ZUSE[1][1]:=TRUE;
	ZUSE[2][1]:=TRUE;
      END;
    GETITEM ( TxFile, 11);
    IF EDTYPE IN [3,7] THEN CURRLONG:=0-CURRLONG;
    IF EDTYPE IN [2,6]
      THEN ZDISCOUNT[1]:=CURRLONG
      ELSE ZTOTTAX  [1]:=CURRLONG;
    ZSTUB[1]:=0;
    IF EDTYPE IN [1,2,3,5,6,7,11,15] THEN
      BEGIN
	GETITEM ( TxFile, 26);
	STRLONG (CURRSTR,ZSTUB[1]);
      END;
    IF EDTYPE IN [2,6] THEN
      BEGIN
	CASE EDTYPE OF
	  2 : IF ZTOTAMT[1]<0 THEN GETITEM ( TxFile, 19) ELSE GETITEM ( TxFile, 18);
	  6 : IF ZTOTAMT[1]<0 THEN GETITEM ( TxFile, 18) ELSE GETITEM ( TxFile, 19);
	END;
	ZBANK[1]:=CURRINT;
        Getitem ( TxFile,  27 );
	Presented := ( currdisp[1] = 'P' );
      END;
    IF EDTYPE IN [9,0] THEN
      BEGIN
	IF ZTOTAMT[1]<0 THEN GETITEM ( TxFile, 19) ELSE GETITEM ( TxFile, 18);
	ZDB[1][1]:=CURRINT;
	ZDB[2][1]:=CURRINT;
	IF ZTOTAMT[1]<0 THEN GETITEM ( TxFile, 18) ELSE GETITEM ( TxFile, 19);
	ZCR[1][1]:=CURRINT;
	ZCR[2][1]:=CURRINT;
	GETITEM ( TxFile, 12);
	ZANALYSIS[1][1]:=CURRINT;
	ZANALYSIS[2][1]:=CURRINT;
	GETITEM ( TxFile, 5);
	ZDESC[1][1]:=CURRSTR;
	ZDESC[2][1]:=CURRSTR;
	Getitem ( TxFile,  27 );
	Presented := ( currdisp[1] = 'P' );
      END;
    NEXTTX:=EDFROM;

    If (( edtype = 9 ) And
	( txt = 0 ) And
	( zcr[1,1] >= Cash1.xnomincfrom ) And
	( zcr[1,1] <= Cash1.xnomincto ) And
	( zdb[1,1] >= Cash1.xnomexpfrom ) And
	( zdb[1,1] <= Cash1.xnomexpto )) Then
       Begin
	{ get the quantity for ent transfers }
	getitem ( TxFile,  6 );
	zqty[1,1] := currlong;
        getitem ( TxFile,  32 );     // TGM AB 01/02/13
	zqty2[1,1] := currlong;      // TGM AB 01/02/13
        getitem ( TxFile,  33 );     // TGM AB 01/02/13
	zqty3[1,1] := currlong;      // TGM AB 01/02/13
      End;

    TXLINE:=0;
    counter := 1;
    NO_LINES := 0;

    {PrevType9 := False;}

    try
       with AccsDataModule do
          begin
             // Clear the Temp
             ProdsTxTemp.Close;
             ProdsTxTemp.EmptyTable;
             ProdsTxTemp.Open;
          end;
    except

    end;

    REPEAT
      NEXTTX:=NEXTTX+1;
      counter := counter + 1;
      IF NEXTTX<=DB1.DBRECHIGH THEN
	BEGIN
	  READREC ( TxFile, NEXTTX);
	  dberr;
	  TXT:=99;
	  SUB:=99;

	  IF RECACTIVE ( TxFile ) THEN
	    BEGIN
	      GETITEM ( TxFile, 23);
	      TXT:=CURRINT;
	      GETITEM ( TxFile, 1);
	      SUB:=CURRINT;

	      IF (TXT=EDTYPE) AND (SUB=9) THEN
		BEGIN
		  TXLINE:=TXLINE+1;
		  NO_LINES := NO_LINES + 1;
                  {
                  PrevType9 := True;


                  Inc ( EditRecCount );
                  TxEditRec.TxType[EditRecCount] := Sub;
                  TxEditRec.TxNo[EditRecCount] := NextTx;
                  }
		  ZUSE[1][TXLINE]:=TRUE;
		  IF EDTYPE IN [1,3,5,7,11,15] THEN
		    BEGIN
		      GETITEM ( TxFile, 24);
		      ZENT[1][TXLINE]:=CURRSTR;
		      GETITEM ( TxFile, 6);
		      ZQTY[1][TXLINE]:=CURRLONG;
              GETITEM ( TxFile, 32);           // TGM AB 01/02/13
		      ZQTY2[1][TXLINE]:=CURRLONG;      // TGM AB 01/02/13
              GETITEM ( TxFile, 33);           // TGM AB 01/02/13
		      ZQTY3[1][TXLINE]:=CURRLONG;      // TGM AB 01/02/13
		      GETITEM ( TxFile, 8);
		      ZGEN[1][TXLINE]:=CURRINT;
		      GETITEM ( TxFile, 10);
		      ZTAX[1][TXLINE]:=CURRSTR;
		      GETITEM ( TxFile, 11);
		      IF EDTYPE IN [3,7] THEN CURRLONG:=0-CURRLONG;
		      ZTAXAMT[1][TXLINE]:=CURRLONG;
		      GETITEM ( TxFile, 5);
		      ZDESC[1][TXLINE]:=CURRSTR;
		      GETITEM ( TxFile, 12);
		      ZANALYSIS[1][TXLINE]:=CURRINT;
		    End;
		  GETITEM ( TxFile, 9);
		  IF EDTYPE IN [3,7] THEN CURRLONG:=0-CURRLONG;
		  ZAMT[1][TXLINE]:=CURRLONG;
		  IF EDTYPE IN [1,3,5,7] THEN
		    FOR X:=1 TO MaxGridLines DO  // TENFOUND
		      IF DB1.DBITEMS[32+X].DBINAME<>NULL THEN
			BEGIN
			  GETITEM ( TxFile, 32+X);
			  CASE DB1.DBITEMS[32+X].DBITYPE[0] Of
			    'X','Y','?' : ZUSER1[1][TXLINE][X]:=CURRSTR;
			    'K','L','M' : ZUSER2[1][TXLINE][X]:=CURRLONG;
			    'N'		: ZUSER3[1][TXLINE][X]:=CURRINT;
			    'D','E'	: BEGIN
					    ZUSER1[1][TXLINE][X]:=CURRSTR;
					    ZUSER3[1][TXLINE][X]:=CURRINT;
					  END;
			  END;
			END;
		End
              Else
                  If ( Sub = 0 ) {And PrevType9}Then { VAT LINE }
                     Begin
                          TxEditRec.TxType[TxLine] := Sub;
                          TxEditRec.TxNo[TxLine] := NextTx;
                          {Inc ( EditRecCount );}
                          {PrevType9 := False;}
                     End;
	    END;
	END;
      // Read the ProdsTx to try and locate a matching TxNo
   //   If invoicer then
       try
         with AccsDataModule do
            begin
               if ProdsTx.Locate('TxNo',NextTx,[] ) then
                  begin
                     ProdsTxTemp.Append;
                     ProdsTxTemp.FieldByName('TxNo').AsInteger := ProdsTx.FieldByName('TxNo').AsInteger;
                     ProdsTxTemp['LineDate'] := ProdsTx['LineDate'];
                     ProdsTxTemp['LineRef'] := ProdsTx['LineRef'];
                     ProdsTxTemp.FieldByName('LineNo').AsInteger := ProdsTx.FieldByName('LineNo').AsInteger;
                     ProdsTxTemp.FieldByName('Desc1').AsString := ProdsTx.FieldByName('Desc1').AsString;
                     ProdsTxTemp.FieldByName('Desc2').AsString := ProdsTx.FieldByName('Desc2').AsString;
                     ProdsTxTemp.FieldByName('Desc3').AsString := ProdsTx.FieldByName('Desc3').AsString;
                     ProdsTxTemp.FieldByName('ProductID').AsString := ProdsTx.FieldByName('ProductID').AsString;
                     ProdsTxTemp.Post;
                  end;
            end;
      except

      end;
      
    UNTIL (NEXTTX>DB1.DBRECHIGH)
       OR (TXLINE=MaxGridLines + 2) OR (TXT<>EDTYPE) OR (NOT (SUB IN [0,9,10])); // TENFOUND  TXLINE WAS 12
    EDTO:=NEXTTX-1;

    IF TXLINE=MaxGridLines + 2 THEN EDTO:=NEXTTX; // TENFOUND TXLINE WAS 12
    IF (NEXTTX<=DB1.DBRECHIGH) THEN
      IF ((TXT=1) AND (SUB=2))
      OR ((TXT=5) AND (SUB=6)) THEN
	BEGIN
	  EDTO:=NEXTTX;
	  CASE SUB OF
	    2 : IF ZTOTAMT[1]<0 THEN GETITEM ( TxFile, 19) ELSE GETITEM ( TxFile, 18);
	    6 : IF ZTOTAMT[1]<0 THEN GETITEM ( TxFile, 18) ELSE GETITEM ( TxFile, 19);
	  END;
	  ZBANK[1]:=CURRINT;
	  Getitem ( TxFile,  27 );
	  Presented := ( currdisp[1] = 'P' );
	END;
    IF (NEXTTX<=DB1.DBRECHIGH) THEN
      IF ((TXT=11) AND (SUB=12))
      OR ((TXT=15) AND (SUB=16)) THEN
	BEGIN
	  EDTO:=NEXTTX;
	  CASE SUB OF
	    12 : IF ZTOTAMT[1]<0 THEN GETITEM ( TxFile, 19) ELSE GETITEM ( TxFile, 18);
	    16 : IF ZTOTAMT[1]<0 THEN GETITEM ( TxFile, 18) ELSE GETITEM ( TxFile, 19);
	  END;
	  ZBANK[1]:=CURRINT;
	  Getitem ( TxFile,  27 );
	  Presented := ( currdisp[1] = 'P' );
	END;

    {* Check for Enterprise Transfer }
    If ( edfrom = edto ) Then	{* Only 1 Transaction }
	Begin
	   { If debit & credit in enterprise range than assume ent trans }
	   If (( zcr[1,1] >= Cash1.xnomincfrom ) And
	       ( zcr[1,1] <= Cash1.xnomincto ) And
	       ( zdb[1,1] >= Cash1.xnomexpfrom ) And
	       ( zdb[1,1] <= Cash1.xnomexpto )) Then
	       {creen_type := reg_trans;}
	End;

    ZAMTPAID [2]:=0-ZAMTPAID [1];
    ZDISCOUNT[2]:=0-ZDISCOUNT[1];
    ZTOTAMT  [2]:=0-ZTOTAMT  [1];
    ZTOTTAX  [2]:=0-ZTOTTAX  [1];
    ZALLOC   [2]:=ZALLOC  [1];
    ZBANK    [2]:=ZBANK	  [1];
    ZSTUB    [2]:=ZSTUB	  [1];
    ZACCOUNT [2]:=ZACCOUNT[1];
    ZCUSTREC [2]:=ZCUSTREC[1];
    ZTXDATE  [2]:=ZTXDATE [1];
    ZDUESTR  [2]:=ZDUESTR [1];
    ZDUEINT  [2]:=ZDUEINT [1];
    ZREF     [2]:=ZREF	  [1];
    ZCOMM    [2]:=ZCOMM	  [1];
    FOR X:=1 TO TXLINE DO
      BEGIN
	ZAMT	 [2][X]:=0-ZAMT	  [1][X];
	ZTAXAMT	 [2][X]:=0-ZTAXAMT[1][X];
	ZUSE	 [2][X]:=ZUSE	  [1][X];
	ZENT	 [2][X]:=ZENT	  [1][X];
	ZQTY	 [2][X]:=0-ZQTY	  [1][X];
    ZQTY2	 [2][X]:=0-ZQTY2  [1][X];    // TGB AB 01/02/13
    ZQTY3	 [2][X]:=0-ZQTY3  [1][X];    // TGB AB 01/02/13
	ZGEN	 [2][X]:=ZGEN	  [1][X];
	ZTAX	 [2][X]:=ZTAX	  [1][X];
	ZDESC	 [2][X]:=ZDESC	  [1][X];
	ZANALYSIS[2][X]:=ZANALYSIS[1][X];
	FOR Y:=1 TO MaxGridLines DO  // TENFOUND
	  BEGIN
	    ZUSER1[2][X][Y]:=  ZUSER1[1][X][Y];
	    ZUSER2[2][X][Y]:=0-ZUSER2[1][X][Y];
	    ZUSER3[2][X][Y]:=  ZUSER3[1][X][Y];
	  END;
      END;

    IF (NEXTTX<=DB1.DBRECHIGH) THEN
      BEGIN
	IF (TXT=1) AND (SUB=2) THEN
	  BEGIN
	    PROG:=SALESTX;
	    ACT :=2;
	  END;
	IF (TXT=5) AND (SUB=6) THEN
	  BEGIN
	    PROG:=PURCHTX;
	    ACT :=2;
	  END;
      END;
    IF ACT<>2 THEN
      BEGIN
	CASE EDTYPE OF
	  1,5,11,15 : ACT:=1;
	  2,6	    : ACT:=3;
	  3,7	    : ACT:=4;
	  9,0	    : ACT:=6;
	END;
	CASE EDTYPE OF
	  1,2,3 : PROG:=SALESTX;
	  5,6,7 : PROG:=PURCHTX;
	  9,0	: PROG:=JOURNAL;
	  11	: PROG:=CASHINC;
	  15	: PROG:=CASHEXP;
	END;
      END;
    TxEditRec.TransT := EdTo;
    TxEditRec.NoRecs := ( TxEditRec.TransT-TxEditRec.TransF ) + 1;

    RESULT := (NOT Presented);  // if presented you cannot edit
End;

Procedure CheckEnd;
VAR
   X	  : INTEGER;
   CHKAMT : LONG;
   CHKTAX : LONG;
BEGIN						      { begin CHECKEND }
    ZTOTAMT[1]:=0;
    ZTOTTAX[1]:=0;
    IF ((PROG IN [SALESTX,PURCHTX]) AND (ACT IN [3,61,62])) THEN
      BEGIN
	ZTOTAMT[1]:=ZAMT[1][1];
	EXIT;
      END;
    IF (PROG=JOURNAL) AND (ACT IN [3..5]) THEN EXIT;
    CHKAMT:=0;
    CHKTAX:=0;
    FOR X:=1 TO MaxGridLines DO  // TENFOUND
      IF ZUSE[1][X] THEN
	BEGIN
	  IF PROG IN [CASHINC,CASHEXP,SALESTX,PURCHTX,JOURNAL] THEN
	    CHKAMT:=CHKAMT+ZAMT[1][X];
	  IF (PROG IN [CASHINC,CASHEXP,SALESTX,PURCHTX])
	  OR ((PROG=JOURNAL) AND (ACT=10)) THEN
	    CHKTAX:=CHKTAX+ZTAXAMT[1][X];
	END;
    ZTOTAMT[1]:=CHKAMT;
    ZTOTTAX[1]:=CHKTAX;
End;

Procedure ReSetPointers;
Var
   TxType : Integer;
   NomsUpdated : Packed Array [1..2,1..2,1..((MaxGridLines*2)+2)] Of Integer;
   c1,
   c2,
   c3 : Integer;

   Function RanAlready ( AccToCheck : Integer ) : Boolean;
   Var
      Counter1,
      Counter2,
      Counter : Integer;
   Begin
        RanAlready := False;
        Counter1   := 1;
{-->>        Counter2   := 1;}
{-->>        Counter    := 1;}

        While Counter1 <= 2 Do
           Begin
              Counter2 := 1;
              While Counter2 <= 2 Do
                 Begin
                    Counter := 1;
                    While Counter <= ((MaxGridLines*2)+2)  Do     // TENFOUND 22
                       Begin
                          If NomsUpdated[counter1,counter2,Counter] <> 0 Then
                             If ( NomsUpdated[counter1,counter2,Counter] = AccToCheck ) Then
                                Begin
                                   RanAlready := True;
                                   Counter1 := 2;
                                   Counter2 := 2;
                                   Counter  := ((MaxGridLines*2)+2); // TENFOUND 22
                                End;
                          Inc ( Counter );
                       End;
                    Inc ( Counter2 );
                 End;
              Inc ( Counter1 );
           End;
   End;

Begin
     For c1 := 1 To 2 Do
         For c2 := 1 To 2 Do
             For C3 := 1 To ((MaxGridLines*2)+2) Do // TENFOUND 22
                 NomsUpdated[c1,c2,c3] :=  0;


     { Show the progress Form
     WaitingForm.Caption := 'ReSetting Indexes';
     WaitingForm.WindowState := wsNormal;
     WaitingForm.BringToFront;
     WaitingForm.Show;
     }

     c1 := 1;
     c2 := 1;
     for c1 := 1 to 2 do
       for c2 := 1 to ((MaxGridLines*2)+2) do  // TENFOUND 22
         begin
            if ( NomArray[1,c1,c2] <> 0 ) then
               if ( NOT RanAlready ( NomArray[1,c1,c2] )) then
                  begin
                     AuditFiles ( NlFile, NomArray[1,c1,c2], Sender );
                     NomsUpdated[1,c1,c2] := NomArray[1,c1,c2];
                  end;

            if ( NomArray[2,c1,c2] <> 0 ) then
               if ( NOT RanAlready ( NomArray[2,c1,c2] )) then
                  begin
                     AuditFiles ( NlFile, NomArray[2,c1,c2], Sender  );
                     NomsUpdated[2,c1,c2] := NomArray[2,c1,c2];
                  end;
         end;

     // If ( PROG In [SalesTx, PurchTx] ) And ( zCustRec[1] <> zCustRec[2] ) Then
     // if its a Sales/Purch TX and the Customer/Supplier has Changed
     // OR the Amount was previously 0 bit now has a value you must reset pointers
     // for this Customer/Supplier

     If  ( PROG In [SalesTx, PurchTx] ) And
       ( ( zCustRec[1] <> zCustRec[2] ) Or (( ZTOTAMT[2] = 0 ) And ( ZTOTAMT[1] <> 0 )) ) Then
        Begin
             If PROG = SALESTX Then
                Begin
                     AuditFiles ( SlFile, zAccount[1], Sender  );
                     AuditFiles ( SlFile, zAccount[2], Sender  );
                End
             Else
                Begin
                     AuditFiles ( PlFile, zAccount[1], Sender  );
                     AuditFiles ( PlFile, zAccount[2], Sender  );
                End;
        End;
        // next bit added by GM 08/06/01 to force a complete reset pointers on completion of an edit
        // the 'false' parameter prevents the runauditfiles proc from altering first and last tx
        // field values
     If  ( PROG In [SalesTx, PurchTx] ) then
     If PROG = SALESTX Then begin
        FullAudit.RunAuditFiles(4,zAccount[1],zAccount[1],1,1,false);
        FullAudit.RunAuditFiles(4,zAccount[2],zAccount[2],1,1,false);
     end else begin
        FullAudit.RunAuditFiles(5,zAccount[1],zAccount[1],1,1,false);
        FullAudit.RunAuditFiles(5,zAccount[2],zAccount[2],1,1,false);
     end;
     // end of GMs bit 08/06/01
     { Before Initialising set the Update the Grid with new record Info }
     SetDb ( TxFile );
     ReadRec ( TxFile, TxEditRec.TransF );
     Dberr;
     If RecActive ( TxFile ) Then
        Begin
             GetItem ( TxFile, 2 );
             //FMainScreen.TxGrid.Cells[1,TxEditRec.TxRow] := Currstr;
             FMainScreen.TransactionGridTableView.DataController.Values[TxEditRec.TxRow, FMainScreen.tvDateIndex] := Currstr;

             GetItem ( TxFile, 4 );
//             FMainScreen.TxGrid.Cells[2,TxEditRec.TxRow] := CurrStr;
             FMainScreen.TransactionGridTableView.DataController.Values[TxEditRec.TxRow, FMainScreen.tvRefIndex] := Currstr;

             GetItem ( TxFile, 5 );
//             FMainScreen.TxGrid.Cells[3,TxEditRec.TxRow] := CurrStr;
             FMainScreen.TransactionGridTableView.DataController.Values[TxEditRec.TxRow, FMainScreen.tvCommentStubNoIndex] := Currstr;

             GetItem ( TxFile, 11 );
             LongStr ( CurrLong, CurrStr, 'L' );
             Slimright ( CurrStr );
//             FMainScreen.TxGrid.Cells[4,TxEditRec.TxRow] := CurrStr;
             FMainScreen.TransactionGridTableView.DataController.Values[TxEditRec.TxRow, FMainScreen.tvVATorDiscountIndex] := Currstr;

             GetItem ( TxFile, 1 );
             TxType := CurrInt;
             GetItem ( TxFile, 9 );
             If TxType In [3,7] Then CurrLong := 0-CurrLong;
             LongStr ( CurrLong, CurrStr, 'L' );
             Slimright ( CurrStr );
//             FMainScreen.TxGrid.Cells[5,TxEditRec.TxRow] := CurrStr;
             FMainScreen.TransactionGridTableView.DataController.Values[TxEditRec.TxRow, FMainScreen.tvAmountIndex] := Currstr;

             If ( TxType = 11 ) Or ( TxType = 15 ) Then
                GetItem ( TxFile, 5 )
             Else
                 Begin
                      GetItem ( TxFile, 3 );
                      If TxType In [1..3] Then
                         CurrStr := GetAccountName ( SlFile, CurrInt, 1 )
                      Else If TxType In [5..7] Then
                           CurrStr := GetAccountName ( PlFile, CurrInt, 1 )
                      Else
                          GetItem ( TxFile, 5 );
                 End;
//             FMainScreen.TxGrid.Cells[6,TxEditRec.TxRow] := CurrStr;
             FMainScreen.TransactionGridTableView.DataController.Values[TxEditRec.TxRow, FMainScreen.tvCustomerSupplierIndex] := Currstr;
        End;

     { Initialise the TxEditRec }
     GEditing         := False;
     TxEditRec.TransF := 0;
     TxEditRec.TransT := 0;
     TxEditRec.TransType := '  ';
     TxEditRec.NoRecs := 0;
     For c1 := 1 To ((MaxGridLines*2)+2) Do //TENFOUND 22
         Begin
              TxEditRec.TxType[c1] := -1;
              TxEditRec.TxNo[c1] := 0;
         End;

     { Hide the progress Form
     WaitingForm.SendToBack;
     }


End;

Function TestGridCell ( Cell : ShortString ) : Boolean;
Begin
     SlimAll ( Cell );
     TestGridCell := ( Length ( Cell ) = 0 );
End;

PROCEDURE INITVALS;
Var
    X	: INTEGER;
    Y	: INTEGER;
    ZTX : INTEGER;
BEGIN							{ begin INITVALS }
   FIRSTTIME:=TRUE;
   Presented := FALSE;
   {
   NOMNAME  :=NULL;
   }
   WORKDATE :=NULL;
   For x := 1 To 6 Do CurrDatBlk[X] := -10;
   For x := 1 To MaxTx Do TxBlocks[X] := 9999;
   For x := 1 To MaxNom Do NomBlocks[X] := 9999;
   GArrPos := 1;

   For Ztx := 1 To 2 Do
       For X := 1 To 2 Do
           For Y := 1 To ((MaxGridLines*2)+2) Do // TENFOUND 22
               NomArray[ZTX,X,Y] := 0;

   FOR ZTX:=1 TO 2 DO
      BEGIN
	IF (PROG=JOURNAL) AND (ACT=5) THEN
	  ZBANK[ZTX]:=0
	ELSE
	  IF (( Cash1.XLASTBANK >= Cash1.XBANKMIN ) and ( Cash1.xlastbank <= Cash1.XBANKMAX )) THEN
	    ZBANK[ZTX]:=Cash1.XLASTBANK
	  ELSE
	    ZBANK[ZTX]:=Cash1.XDEFBANK;

        CASE PROG OF
	  CASHINC,SALESTX : ZSTUB[ZTX] := PSysLongToDelphi ( Cash1.XRECSTUB );
	  CASHEXP,PURCHTX : ZSTUB[ZTX] := PSysLongToDelphi ( Cash1.XPAYSTUB );
	  JOURNAL	  : ZSTUB[ZTX] :=0;
	END;

        ZREF	 [ZTX]:=NULL;
	ZCOMM	 [ZTX]:=NULL;
	ZDUESTR	 [ZTX]:=NULL;
	ZDUEINT	 [ZTX]:=0;
	ZBANKBAL [ZTX]:=NULL;
	ZBANKAMT [ZTX]:=0;
	ZALLOC	 [ZTX]:=SPACE1;
	ZAMTPAID [ZTX]:=0;
	ZDISCOUNT[ZTX]:=0;
	ZTOTAMT	 [ZTX]:=0;
	ZTOTTAX	 [ZTX]:=0;
	ZACCOUNT [ZTX]:=0;
	ZACCBAL	 [ZTX]:=0;
	ZCUSTREC [ZTX]:=0;
	ZBANK2	 [ZTX]:=0;
	ZJNLNO	 [ZTX]:=0;
	ZJNLNAME [ZTX]:=NULL;

	FOR X:=1 TO MaxGridLines DO  // TENFOUND
          BEGIN
	    IF (ACT=3) AND (PROG IN [SALESTX,PURCHTX]) THEN
               ZGEN[ZTX][X]:=Cash1.XDEFBANK
            ELSE
               ZGEN[ZTX][X]:=0;
	    ZUSE     [ZTX][X]:=FALSE;
	    ZENT     [ZTX][X]:=NULL;
	    ZDESC    [ZTX][X]:=NULL;
	    ZENTREC  [ZTX][X]:=0;
	    ZQTY     [ZTX][X]:=0;
       ZQTY2    [ZTX][X]:=0;   // TGM AB 01/02/13
       ZQTY3    [ZTX][X]:=0;   // TGM AB 01/02/13
	    ZAMT     [ZTX][X]:=0;
	    ZTAX     [ZTX][X]:=SPACE1;
	    ZTAXAMT  [ZTX][X]:=0;
	    ZDB	     [ZTX][X]:=0;
	    ZCR	     [ZTX][X]:=0;
	    ZANALYSIS[ZTX][X]:=0;
	    FOR Y:=1 TO MaxGridLines DO // TENFOUND
	      BEGIN
		ZUSER1[ZTX][X][Y]:=COPY(SPACE40,1,15);
		ZUSER2[ZTX][X][Y]:=0;
		ZUSER3[ZTX][X][Y]:=0;
	      END;
	  END;
	IF (PROG=JOURNAL) AND (ACT=8) THEN ZDB[ZTX][1]:=ZBANK[ZTX];
	IF (PROG=JOURNAL) AND (ACT=9) THEN ZCR[ZTX][1]:=ZBANK[ZTX];
      END;
  END;							{ end INITVALS }

  PROCEDURE PUTXXXX;
  VAR
    Pos_X,
    X,
    Temp_pos,
    ITFST : INTEGER;
    ST	  : STRING{[5]};
  BEGIN						       { begin PUTXXXX }
    SETDB(DB);
    if ((DB = NewTxFile) or (DB = NLFile) or (DB = SLFile) or (DB = PLFile)) then begin
            putitem(DB,Itemno);
    end else begin
    IF	   DB1.DBITEMS[ITEMNO].DBINAME=NULL THEN EXIT;
    ITFST:=DB1.DBITEMS[ITEMNO].DBIOFSET;
    CASE DB1.DBITEMS[ITEMNO].DBITYPE[0] OF
      'N' : Move(CURRINT,DATWORK^[CURROFST[DB]+ITFST],2);
      'K' : BEGIN
	      CURRKONG:=CURRLONG;
	      Move(CURRKONG,DATWORK^[CURROFST[DB]+ITFST],6);
	    END;
      'L',
      'M' : Begin
                   If ( currlong >= 0 ) Then
                      fillchar (temp_val[0], sizeof (temp_val), chr (0))
                   Else
                      fillchar (temp_val[0], sizeof (temp_val), chr (255));
                   MOVE (currlong,Temp_val[0],sizeof(currlong));
                   x := 9;
                   While (Temp_val[x] In [chr (0),chr(255)]) and (x > 0) do
                         dec (x);
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
      {
      'L',
      'M' : Move(CURRLONG,DATWORK^[CURROFST[DB]+ITFST],10);
      }
      'X' : Move(CURRDISP[1],DATWORK^[CURROFST[DB]+ITFST],
		     DB1.DBITEMS[ITEMNO].DBISIZE);
      'Y' : IF DB1.DBITEMS[ITEMNO].DBISIZE=5 THEN
	      BEGIN
		STR (CURRINT,ST);
		WHILE LENGTH(ST)<5 DO ST:=CONCAT('0',ST);
		Move(ST[1],DATWORK^[CURROFST[DB]+ITFST],5);
	      END
	    ELSE
	      Move(CURRDISP[1],DATWORK^[CURROFST[DB]+ITFST],
		       DB1.DBITEMS[ITEMNO].DBISIZE);
      'D',
      'E' : Move(CURRINT,DATWORK^[CURROFST[DB]+ITFST],2);
      '?' : Move(CURRDISP[1],DATWORK^[CURROFST[DB]+ITFST],1);
      end;
    end;  // else
  END;						       { end PUTXXXX }

  PROCEDURE WRITEXXX;
  VAR
    X : INTEGER;
  BEGIN						       { begin WRITEXXX }
    SETDB(TxFile);
   (* FOR X:=1 TO MAXTX DO   // GM
      IF TXBLOCKS[X]<>9999 THEN
	BEGIN
	  Move(TXHOLD[X]^[1],CBLOCKS[1],1024);
	  IF CWRITE(TxFile,2,(TXBLOCKS[X]*2)+DB1.DBDATAS)<2 THEN dbERR;
	END;
    Move(DB1.DBFILLS[1],CBLOCKS[1],512);
    IF CWRITE(TxFile,1,0)<1 THEN dbERR;
    *)
    SETDB(NlFile);
   { FOR X:=1 TO MAXNOM DO
      IF NOMBLOCKS[X]<>9999 THEN
	BEGIN
	  Move(NOMHOLD[X]^[1],CBLOCKS[1],1024);
 	  IF CWRITE(NlFile,2,(NOMBLOCKS[X]*2)+DB1.DBDATAS)<2 THEN dbERR;
	END;
    CURRDATBLK[TxFile]:=-10;
    CURRDATBLK[NlFile]:=-10;
    }
    For x := 1 To 6 Do CurrDatBlk[X] := -10;
    For x := 1 To MaxTx Do TxBlocks[X] := 9999;
    For x := 1 To MaxNom Do NomBlocks[X] := 9999;

 //    If not editing record write new Stub to Cashbook Def
    If NOT gEditing Then
       DefWrite( 0 );

  END;						       { end WRITEXXX }

  Procedure InList ( db, BlkNo : Integer );
  VAR
    X : INTEGER;
  BEGIN						       { begin INLIST }
    LISTNO:=0;
    IF DB=TxFile THEN
     { FOR X:=1 TO MAXTX DO
	IF TXBLOCKS[X]=BLKNO THEN
	  BEGIN
	    LISTNO:=X;
	    EXIT;
     	  END;        TGM AB }
    IF DB=NlFile THEN
      FOR X:=1 TO MAXNOM DO
	IF NOMBLOCKS[X]=BLKNO THEN
	  BEGIN
	    LISTNO:=X;
	    EXIT;
	  END;
    LISTSPARE:=0;
    IF DB=TxFile THEN
      FOR X:=MAXTX DOWNTO 1 DO
	IF TXBLOCKS[X]=9999 THEN LISTSPARE:=X;
    IF DB=NlFile THEN
      FOR X:=MAXNOM DOWNTO 1 DO
	IF NOMBLOCKS[X]=9999 THEN LISTSPARE:=X;
  END;						      { end INLIST }

  PROCEDURE READXXX;
  VAR
    BLKNO : INTEGER;
    SUB	  : INTEGER;
  BEGIN						       { begin READXXX }
    ERRORNO:=0;
    SETDB(DB);
    case db of
    NewTxFile : begin
            if RecNo > accsdatamodule.TransactionsDB.RecordCount then begin
               while RecNo > accsdatamodule.TransactionsDB.RecordCount do begin
                     accsdatamodule.TransactionsDB.append;
                     accsdatamodule.TransactionsDB.post;
               end;
            end;
            accsdatamodule.TransactionsDB.Locate('TxNo',Recno,[]);
            accsdatamodule.TransactionsDB.edit;
            end;
    NLFile : begin
            accsdatamodule.NLFileDB.Locate('NLNo',Recno,[]);
            accsdatamodule.NLFileDB.edit;
            end;
    SLFile : begin
            accsdatamodule.SLFileDB.Locate('SLNo',Recno,[]);
            accsdatamodule.SLFileDB.edit;
            end;
    PLFile : begin
            accsdatamodule.PLFileDB.Locate('PLNo',Recno,[]);
            accsdatamodule.PLFileDB.edit;
            end;
    end;
            {else begin
    IF (RECNO<1) OR (RECNO>DB1.DBRECTOT) THEN
      BEGIN
	ERRORNO:=5;
	EXIT;
      END;
    BLKNO:=((RECNO-1) DIV DB1.DBRECBLK);
    SUB:=RECNO-(DB1.DBRECBLK*BLKNO);
    INLIST(DB,BLKNO);
    IF LISTNO>0 THEN
      BEGIN
	CASE DB OF
	  TxFile : Move(TXHOLD[LISTNO]^[1],DATWORK^[1],1024);
	  NlFile : Move(NOMHOLD[LISTNO]^[1],DATWORK^[1],1024);
	END;
      END;
    IF LISTNO=0 THEN
      BEGIN
	IF CREAD(DB,2,(BLKNO*2)+DB1.DBDATAS) < 2 THEN EXIT;
	Move(CBLOCKS[1],DATWORK^[1],1024);
	CURRDATBLK[DB]:=BLKNO;
	IF LISTSPARE>0 THEN
	  BEGIN
	    CASE DB OF
	      TxFile : BEGIN
		            Move(DATWORK^[1],TXHOLD[LISTSPARE]^[1],1024);
                            TXBLOCKS[LISTSPARE]:=BLKNO;
                       END;
	      NlFile : BEGIN
		            Move(DATWORK^[1],NOMHOLD[LISTSPARE]^[1],1024);
		            NOMBLOCKS[LISTSPARE]:=BLKNO;
                       END;
	    END;
	  END;
      END;
    CURRREC[DB]:=RECNO;
    CURROFST[DB]:=((SUB-1)*DB1.DBRECSZ);
   end; //else  }
  END;							{ end READXXX }

  Procedure ReWriteXXX ( db, RecNo : Integer );
  VAR
    BLKNO : INTEGER;
  BEGIN							 { begin REWRITEXXX }

 //   if db = newtxfile then exit
 //   else begin    // GM put in next bit and trans do get added to transactions file
 //     if db = newtxfile then begin
 //        accsdatamodule.TransactionsDB.open;
 //        accsdatamodule.TransactionsDB.append;  // GM
 //     end;
    if db = NewTxFile then begin
            if (RecNo > accsdatamodule.TransactionsDB.RecordCount) then begin
                while (RecNo > accsdatamodule.TransactionsDB.RecordCount) do begin
                accsdatamodule.TransactionsDB.append;
                accsdatamodule.TransactionsDB.post;
                end;
            end;
            accsdatamodule.TransactionsDB.Locate('TxNo',Recno,[]);
            accsdatamodule.TransactionsDB.edit;
    end {else begin
    ERRORNO:=0;
    SETDB(DB);
    IF (RECNO<1) OR (RECNO>DB1.DBRECTOT) THEN
      BEGIN
	ERRORNO:=10;
	EXIT;
      END;
    BLKNO:=((RECNO-1) DIV DB1.DBRECBLK);
    INLIST(DB,BLKNO);
    IF LISTNO>0 THEN
      BEGIN
	CASE DB OF
	  TxFile : if db <> newtxfile then Move(DATWORK^[1],TXHOLD[LISTNO]^[1],1024)
                 else begin
                     accsdatamodule.TransactionsDB['Reference'] := ZRef[1];
                     accsdatamodule.TransactionsDB.post;
                 end;

	  NlFile : Move(DATWORK^[1],NOMHOLD[LISTNO]^[1],1024);
	END;
      END;
    IF LISTNO=0 THEN
      BEGIN
	if db <> newtxfile then begin
           Move(DATWORK^[1],CBLOCKS[1],1024);
	   IF CWRITE(DB,2,(BLKNO*2)+DB1.DBDATAS) < 2 THEN EXIT;
           end;
      END;
    end; }
  END;						    { end REWRITEXXX }

  PROCEDURE ADDXXXXXX;
  BEGIN						    { begin ADDXXXXXX }
   { if db = newtxfile then begin
          //accsdatamodule.TransactionsDB.open;
          accsdatamodule.TransactionsDB.append;  // GM
          accsdatamodule.TransactionsDB.post;
        end
    else} begin   
    REWRITEXXX(DB,RECNO);
    IF ERRORNO>0 THEN EXIT;
    IF RECNO>DB1.DBRECHIGH THEN
      BEGIN
	DB1.DBRECHIGH:=RECNO;
	{
	CASE DB OF
	  1 : Move(DB1.DBFILLS[1],DB1HOLD[1],512);
	  2 : Move(DB1.DBFILLS[1],DB2HOLD[1],512);
	  3 : Move(DB1.DBFILLS[1],DB3HOLD[1],512);
	  4 : Move(DB1.DBFILLS[1],DB4HOLD[1],512);
	  5 : Move(DB1.DBFILLS[1],DB5HOLD[1],512);
	  6 : Move(DB1.DBFILLS[1],DB6HOLD[1],512);
	END;
	}
	IF ERRORNO>0 THEN EXIT;
      END;
    end;
  END;						    { end ADDXXXXXX }

Function CheckNominals : integer;
var i : integer;
begin
    Result  := 0;
    for i:= 1 to maxgridlines do begin

        if Zdb[1,i] = cash1.xnomdebtor then result := Zdb[1,i];
        if Zcr[1,i] = cash1.xnomdebtor then result := Zcr[1,i];
        if Zgen[1,i] = cash1.xnomdebtor then result := Zgen[1,i];
        if Zdb[1,i] = cash1.xnomcredit then result := Zdb[1,i];
        if Zcr[1,i] = cash1.xnomcredit then result := Zcr[1,i];
        if Zgen[1,i] = cash1.xnomcredit then result := Zgen[1,i];
        if Zdb[2,i] = cash1.xnomdebtor then result := Zdb[2,i];
        if Zcr[2,i] = cash1.xnomdebtor then result := Zcr[2,i];
        if Zgen[2,i] = cash1.xnomdebtor then result := Zgen[2,i];
        if Zdb[2,i] = cash1.xnomcredit then result := Zdb[2,i];
        if Zcr[2,i] = cash1.xnomcredit then result := Zcr[2,i];
        if Zgen[2,i] = cash1.xnomcredit then result := Zgen[2,i];
        setdb(NLFile);
        if Zdb[1,i] > db1.DBRECHIGH then result := Zdb[1,i];
        if Zcr[1,i] > db1.DBRECHIGH then result := Zcr[1,i];
        if Zgen[1,i] > db1.DBRECHIGH then result := Zgen[1,i];
        if Zdb[2,i] > db1.DBRECHIGH then result := Zdb[2,i];
        if Zcr[2,i] > db1.DBRECHIGH then result := Zcr[2,i];
        if Zgen[2,i] > db1.DBRECHIGH then result := Zgen[2,i];

        if (Cash1.xNomPrvExp = Cash1.xNomPrvInc + 10) then begin

                if ((Zdb[1,i] > Cash1.xNomPrvInc + Cash11.xNo_Of_Partners) and (Zdb[1,i] < Cash1.xNomPrvInc + 10)) then result := Zdb[1,i];
                if ((Zdb[1,i] > Cash1.xNomPrvExp + Cash11.xNo_Of_Partners) and (Zdb[1,i] < Cash1.xNomPrvExp + 10)) then result := Zdb[1,i];
                if ((Zcr[1,i] > Cash1.xNomPrvInc + Cash11.xNo_Of_Partners) and (Zcr[1,i] < Cash1.xNomPrvInc + 10)) then result := Zcr[1,i];
                if ((Zcr[1,i] > Cash1.xNomPrvExp + Cash11.xNo_Of_Partners) and (Zcr[1,i] < Cash1.xNomPrvExp + 10)) then result := Zcr[1,i];
                if ((Zgen[1,i] > Cash1.xNomPrvInc + Cash11.xNo_Of_Partners) and (Zgen[1,i] < Cash1.xNomPrvInc + 10)) then result := Zgen[1,i];
                if ((Zgen[1,i] > Cash1.xNomPrvExp + Cash11.xNo_Of_Partners) and (Zgen[1,i] < Cash1.xNomPrvExp + 10)) then result := Zgen[1,i];

                if ((Zdb[2,i] > Cash1.xNomPrvInc + Cash11.xNo_Of_Partners) and (Zdb[2,i] < Cash1.xNomPrvInc + 10)) then result := Zdb[2,i];
                if ((Zdb[2,i] > Cash1.xNomPrvExp + Cash11.xNo_Of_Partners) and (Zdb[2,i] < Cash1.xNomPrvExp + 10)) then result := Zdb[2,i];
                if ((Zcr[2,i] > Cash1.xNomPrvInc + Cash11.xNo_Of_Partners) and (Zcr[2,i] < Cash1.xNomPrvInc + 10)) then result := Zcr[2,i];
                if ((Zcr[2,i] > Cash1.xNomPrvExp + Cash11.xNo_Of_Partners) and (Zcr[2,i] < Cash1.xNomPrvExp + 10)) then result := Zcr[2,i];
                if ((Zgen[2,i] > Cash1.xNomPrvInc + Cash11.xNo_Of_Partners) and (Zgen[2,i] < Cash1.xNomPrvInc + 10)) then result := Zgen[2,i];
                if ((Zgen[2,i] > Cash1.xNomPrvExp + Cash11.xNo_Of_Partners) and (Zgen[2,i] < Cash1.xNomPrvExp + 10)) then result := Zgen[2,i];



           (*     if Act in [61,63] then begin

                        if ZAccount[1] = cash1.xnomdebtor then result := ZAccount[1];
                        if ZAccount[1] = cash1.xnomdebtor then result := ZAccount[1];
                        if ZAccount[2] = cash1.xnomcredit then result := ZAccount[2];
                        if ZAccount[2] = cash1.xnomcredit then result := ZAccount[2];                                                   =

                        setdb(NLFile);
                        if ZAccount[1] > db1.DBRECHIGH then result := ZAccount[1];
                        if ZAccount[2] > db1.DBRECHIGH then result := ZAccount[2];
                        if ((ZAccount[1] > Cash1.xNomPrvInc + Cash11.xNo_Of_Partners) and (ZAccount[1] < Cash1.xNomPrvInc + 10)) then result := ZAccount[1];
                        if ((ZAccount[2] > Cash1.xNomPrvInc + Cash11.xNo_Of_Partners) and (ZAccount[2] < Cash1.xNomPrvInc + 10)) then result := ZAccount[2];
                        if ((ZAccount[1] > Cash1.xNomPrvExp + Cash11.xNo_Of_Partners) and (ZAccount[1] < Cash1.xNomPrvExp + 10)) then result := ZAccount[1];
                        if ((ZAccount[2] > Cash1.xNomPrvExp + Cash11.xNo_Of_Partners) and (ZAccount[2] < Cash1.xNomPrvExp + 10)) then result := ZAccount[2];

                end;    *)      // TGM AB 04/12/15
        end
            else begin

                       (* if Act in [61,63] then begin

                                if ZAccount[1] = cash1.xnomdebtor then result := ZAccount[1];
                                if ZAccount[1] = cash1.xnomdebtor then result := ZAccount[1];
                                if ZAccount[2] = cash1.xnomcredit then result := ZAccount[2];
                                if ZAccount[2] = cash1.xnomcredit then result := ZAccount[2];

                                setdb(NLFile);
                                if ZAccount[1] > db1.DBRECHIGH then result := ZAccount[1];
                                if ZAccount[2] > db1.DBRECHIGH then result := ZAccount[2];


                        end;
                        *)  // TGM AB 04/12/15

            end;

    end;

    //SetRanges[3] := Cash1.xNomPrvInc;
    //SetRanges[4] := Cash1.xNomPrvExp+Cash11.xNo_Of_Partners;

    // TGM AB 04/12/15     Start

    if Act = 61 then begin
                    if Prog = 13 then begin
                        if CheckCustSupp ( SLFile, vartostr(ZAccount[1]) ) =  false then result := ZAccount[1];
                        if CheckCustSupp ( SLFile, vartostr(ZAccount[2]) ) =  false then result := ZAccount[2];
                    end;
                    if Prog = 14 then begin
                        if CheckCustSupp ( PLFile, vartostr(ZAccount[1]) ) =  false then result := ZAccount[1];
                        if CheckCustSupp ( PLFile, vartostr(ZAccount[2]) ) =  false then result := ZAccount[2];
                    end;
    end;

    if Act = 62 then begin
                    if Prog = 13 then begin
                        if CheckCustSupp ( SLFile, vartostr(ZAccount[1]) ) =  false then result := ZAccount[1];
                        if CheckCustSupp ( PLFile, vartostr(ZAccount[2]) ) =  false then result := ZAccount[2];
                    end;
                    if Prog = 14 then begin
                        if CheckCustSupp ( PLFile, vartostr(ZAccount[1]) ) =  false then result := ZAccount[1];
                        if CheckCustSupp ( SLFile, vartostr(ZAccount[2]) ) =  false then result := ZAccount[2];
                    end;
    end;

    // TGM AB 04/12/15     End

end;


end.
