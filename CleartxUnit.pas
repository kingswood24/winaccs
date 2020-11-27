unit CleartxUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TYPES, StdCtrls, Gauges, Buttons, ExtCtrls, ComCtrls, Mask;


type
  TCleartxForm = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Exit: TBitBtn;
    ProgressBar: TGauge;
    Label1: TLabel;
    PassMask: TEdit;
    ConfirmBtn: TBitBtn;
    ProgressLabel: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Image1: TImage;
    procedure FormActivate(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure ConfirmBtnClick(Sender: TObject);
    procedure PassMaskKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CleartxForm: TCleartxForm;

implementation
Uses
  MainUnit,
  UTIL,
  VARS,
  PARAMS,
  CLEARS,
  ABORTPrg,
  CALCS,
  DBCORE,
  DBGEN,
  DefSecFl,
  AccsData,
  FILED;

{$R *.DFM}

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}


PROCEDURE CLEARFILES;
VAR
  x,
  RECNO : INTEGER;
  FIELD : INTEGER;
  zero_cust_supp : ShortString;
  file_name : ShortString;

  PROCEDURE ERR;
  BEGIN
    FLUSH:=TRUE;
    messagedlg ('Error '+inttostr(errorno),mtinformation,[mbok],0);
    (*
    DOS_FLUSH;
    DISKERROR;
    EXIT(CLEARFILES);*)
  END;

  PROCEDURE ZEROFILE (FL: INTEGER);
  Var
    tx_start,
    tx_last  : Integer;
    RECNO : INTEGER;
    FIELD : INTEGER;

  BEGIN
    SETDB (FL);
    CleartxForm.ProgressBar.Show;
    CleartxForm.ProgressBar.Progress := 0;
    CleartxForm.ProgressBar.MinValue := 0;
    CleartxForm.ProgressBar.MaxValue := db1.dbrectot;
    CleartxForm.ProgressLabel.Caption := '';
    CleartxForm.ProgressLabel.ReFresh;

(*    CLEARFROM (24);*)
    CASE FL OF
      SLFile,
      PLFile : BEGIN
	     (* CASE FL OF
		1 : DIS (1,24,'ZEROISING CUSTOMER ACCOUNT ... ');
		2 : DIS (1,24,'ZEROISING SUPPLIER ACCOUNT ... ');
	      END;*)
              If fl = SlFile Then
                 Begin
                      CleartxForm.ProgressLabel.Caption := 'Zeroising Customer Accounts...     ';
                      CleartxForm.ProgressLabel.ReFresh;
                 End
              Else
                  Begin
                      CleartxForm.ProgressLabel.Caption := 'Zeroising Supplier Accounts...     ';
                      CleartxForm.ProgressLabel.ReFresh;
                  end;

	      FOR RECNO:=1 TO DB1.DBRECTOT DO
		BEGIN
		  READREC (FL,RECNO);
		  IF ERRORNO>0 THEN ERR;
		  IF RECACTIVE (FL) THEN
		    BEGIN
		      (*DISI (32,24,RECNO,1);*)

                      CleartxForm.ProgressBar.Progress := CleartxForm.ProgressBar.Progress + 1;
		      If ( zero_cust_supp[1] In ['N','n'] ) Then
			Begin
			  getint ( fl, 15, tx_start );
			  getint ( fl, 16, tx_last );
			  If ( tx_start <> 0 ) Or ( tx_last <> 0 ) Then
			    Begin
			      SETITEM;
			      FOR FIELD:=6 TO 18 DO PUTITEM (FL,FIELD);
			      REWRITEREC (FL,RECNO);
			      IF ERRORNO>0 THEN ERR;
			    End;
			End
		      Else
			Begin
			  SETITEM;
			  FOR FIELD:=6 TO 18 DO PUTITEM (FL,FIELD);
 			  REWRITEREC (FL,RECNO);
			  IF ERRORNO>0 THEN ERR;
			End;
		    END;
		END;
	    END;
      NLFile : BEGIN
	       (*DIS (1,24,'ZEROISING NOMINAL ACCOUNT ... ');*)
               CleartxForm.ProgressLabel.Caption := 'Zeroising Nominal Accounts...     ';
               CleartxForm.ProgressLabel.ReFresh;
	       FOR RECNO:=1 TO DB1.DBRECTOT DO
	        BEGIN
                  CleartxForm.ProgressBar.Progress := 0;
                  CleartxForm.ProgressBar.Progress := CleartxForm.ProgressBar.Progress + 1;
		  READREC (FL,RECNO);
		  IF ERRORNO>0 THEN ERR;
		  IF RECACTIVE (FL) THEN
		    BEGIN
		      (*DISI (31,24,RECNO,1);*)
		      SETITEM;
		      FOR FIELD:= 2 TO	4 DO PUTITEM (FL,FIELD);
		      FOR FIELD:= 6 TO	7 DO PUTITEM (FL,FIELD);
		      FOR FIELD:=14 TO 19 DO PUTITEM (FL,FIELD);
		      FOR FIELD:=22 TO 22 DO PUTITEM (FL,FIELD);
		      FOR FIELD:=33 TO 45 DO PUTITEM (FL,FIELD);
		      IF Cash1.XNOMTHIS THEN
			FOR FIELD:=49 TO  61 DO PUTITEM (FL,FIELD);
		      IF Cash1.XNOMLAST THEN
			FOR FIELD:=65 TO  77 DO PUTITEM (FL,FIELD);
		      IF Cash1.XNOMWEEK THEN
			FOR FIELD:=81 TO 133 DO PUTITEM (FL,FIELD);
		      REWRITEREC (FL,RECNO);
		      IF ERRORNO>0 THEN ERR;
		    END;
		END;
	    (*  CLEARFROM (24);*)
	    END;
      99  : BEGIN
	     (* DIS (1,24,'ZEROISING STOCK ITEMS DATA ... ');*)
              CleartxForm.ProgressLabel.Caption := 'Zeroising Stock Items Data...     ';
              CleartxForm.ProgressLabel.ReFresh;
	      FOR RECNO:=1 TO DB1.DBRECTOT DO
		BEGIN
                  CleartxForm.ProgressBar.Progress := 0;
                  CleartxForm.ProgressBar.Progress := CleartxForm.ProgressBar.Progress + 1;
		  READREC (FL,RECNO);
		  IF ERRORNO>0 THEN ERR;
		  IF RECACTIVE (FL) THEN
		    BEGIN
		      (*DISI (32,24,RECNO,1);*)
		      SETITEM;
		      FOR FIELD := 33 TO 39 DO PUTITEM (FL,FIELD);
		      FOR FIELD := 47 TO 48 DO PUTITEM (FL,FIELD);
		      REWRITEREC (FL,RECNO);
		      IF ERRORNO>0 THEN ERR;
		    END;
		END;
	    (*  CLEARFROM (24);*)
	    END;
      TXFile : BEGIN
	    (*  DIS (1,24,'REMOVING ACCOUNTS TRANSACTION ... ');*)
              CleartxForm.ProgressLabel.Caption := 'Removing Account Transactions...      ';
              CleartxForm.ProgressLabel.ReFresh;
              SetDB(TxFile);
              CloseDB(TxFile);
              DeleteFile(Accsdatamodule.AccsDataBase.Directory + 'Transactions.db');
              DeleteFile(Accsdatamodule.AccsDataBase.Directory + 'Transactions.px');
              Accsdatamodule.CreateTransactionTable;
              try accsdatamodule.TransactionsDB.open;
              except
              end;
              SetDB(TxFile);
              DeleteFile(Accsdatamodule.AccsDataBase.Directory + 'AllocatedVAT.px');
              Accsdatamodule.CreateAllocatedVATTable;
              try accsdatamodule.AllocatedVATDB.open;
              except
              end;
  {	      FOR RECNO:=1 TO DB1.DBRECTOT DO
		BEGIN
                  CleartxForm.ProgressBar.Progress := CleartxForm.ProgressBar.Progress + 1;
		  READREC (FL,RECNO);
		  IF ERRORNO>0 THEN ERR;
		  IF RECACTIVE (FL) THEN
		    BEGIN
		      (*DISI (35,24,RECNO,1);*)
		      BLANKREC	(Fl,'D');
		      DELETERECORD (Fl,RecNo,False);
		      IF ERRORNO>0 THEN ERR;
		    END;
		END;
	      (*CLEARFROM (24);*)
	      DB1.DBRECHIGH:=0;
	      MOVE (DB1.DBFILLS[1],CBLOCKS[1],512);
//	      IF CWRITE (5,1,0)<1 THEN ERR;
	      IF CWRITE (TXFile,1,0)<1 THEN ERR;  }
	      END;
    END;
  END;

  Procedure zero_livestock ( fl : integer );
  Var RecNo : Integer;
      Field : Integer;
  Begin
  (*  clearfrom (24);*)
    setdb ( fl );

    Case fl of
	1  : Begin
	     (* DIS ( 1, 24, 'INITIALISING ANALYSIS CODES ... ' );*)
              CleartxForm.ProgressLabel.Caption := 'Initialising Analysis Codes...     ';
              CleartxForm.ProgressLabel.ReFresh;

	      FOR RECNO := 1 TO DB1.DBRECTOT DO
		BEGIN
                  CleartxForm.ProgressBar.Progress := CleartxForm.ProgressBar.Progress + 1;
		  READREC ( FL, RECNO );
		  IF ERRORNO > 0 THEN ERR;
		  IF RECACTIVE ( FL ) THEN
		    BEGIN
		      (*DISI ( 31, 24, RECNO, 1 );*)
		      SETITEM;
		      currdisp[1] := 'N';
		      putitem ( fl, 5 );
		      REWRITEREC ( FL, RECNO );
		      IF ERRORNO > 0 THEN ERR;
		    END;
		END;
	    (*  CLEARFROM (24);*)
	    END;
      5	 : Begin
	    (*  DIS ( 1, 24, 'ZEROISING LIVESTOCK DEATHS BIRTHS ... ' );*)
              CleartxForm.ProgressLabel.Caption := 'Zeroising Livestock Deaths/Births...     ';
              CleartxForm.ProgressLabel.ReFresh;
	      FOR RECNO := 1 TO DB1.DBRECTOT DO
		BEGIN
                  CleartxForm.ProgressBar.Progress := CleartxForm.ProgressBar.Progress + 1;
		  READREC ( FL, RECNO );
		  IF ERRORNO > 0 THEN ERR;
		  IF RECACTIVE ( FL ) THEN
		    BEGIN
		      (*DISI ( 39, 24, RECNO, 1 );*)

		      BLANKREC	( FL, 'D' );
		      (*DELETEREC ( FL, RECNO );*)
		      IF ERRORNO > 0 THEN ERR;

		      DB1.DBRECHIGH := 0;
		      (*MOVELEFT ( DB1.DBFILLS[1], CBLOCKS[1], 512 );*)
		      IF CWRITE ( fl, 1, 0 ) < 1 THEN ERR;
		      {
		      SETITEM;
		      FOR FIELD := 1 TO 16 DO PUTITEM ( FL, FIELD );
		      REWRITEREC ( FL, RECNO );
		      IF ERRORNO > 0 THEN ERR;
		      }
		    END;
		END;
	    (*  CLEARFROM (24);*)
	    END;
       4  : Begin
       	    (*  DIS ( 1, 24, 'ZEROISING LIVESTOCK LINKS ... ' );*)
              CleartxForm.ProgressLabel.Caption := 'Zeroising Livestock Links...     ';
              CleartxForm.ProgressLabel.ReFresh;
	      FOR RECNO := 1 TO DB1.DBRECTOT DO
		BEGIN
                  CleartxForm.ProgressBar.Progress := CleartxForm.ProgressBar.Progress + 1;
		  READREC ( FL, RECNO );
		  IF ERRORNO > 0 THEN ERR;
		  IF RECACTIVE ( FL ) THEN
		    BEGIN
		      (*DISI ( 31, 24, RECNO, 1 );*)
		      SETITEM;
		      FOR FIELD := 3 TO 5 DO PUTITEM ( FL, FIELD );
		      REWRITEREC ( FL, RECNO );
		      IF ERRORNO > 0 THEN ERR;
		    END;
		END;
	    (*  CLEARFROM (24);*)
	    END;
    End;
  End;

  Procedure Calc_net_worth (FL : INTEGER);
  Var

    debtor_total,
    creditor_total,
    net_worth		: long;
    x,
    last_rec		: Integer;
    negitive_worth	: boolean;

    Procedure calc_amt ( db : Integer );
    Var x : integer;
    Begin
       For x := 1 to last_rec Do
	  Begin
//             CleartxForm.ProgressBar.Progress := 0;
             CleartxForm.ProgressBar.Progress := CleartxForm.ProgressBar.Progress + 1;
	     readrec ( db, x );
	     If errorno > 0 then err;
	     If recactive ( db ) Then
		Begin
		   getitem ( db, 7 );
		   If db = 1 Then	   { Customer }
		      debtor_total := debtor_total + currlong
		   Else			   { Supplier }
		      creditor_total := creditor_total + currlong;
		End;
	  End;
    End;

  Begin
    debtor_total	:= 0;
    creditor_total	:= 0;
    net_worth		:= 0;
//    setdb ( 1 );       { Customer ( 1 ) }
    setdb ( SLFile );       { Customer ( 1 ) }
    last_Rec := db1.dbrechigh;
    calc_amt ( slfile );

    (*clearfrom ( 24 );
    dis ( 1, 24, 'RECALCULATING OPENING NET WORTH ... ' );*)
    CleartxForm.ProgressLabel.Caption := 'Recalculating Open Net Worth...     ';
    CleartxForm.ProgressLabel.ReFresh;

//    setdb ( 2 );	{ Supplier ( 2 ) }
    setdb ( PLFile );	{ Supplier ( 2 ) }
    last_Rec := db1.dbrechigh;
//    calc_amt ( 2 );
    calc_amt ( PLFILE );
    {
    negitive_worth := ( debtor_total > creditor_total );
    }
    net_worth := ( debtor_total-creditor_total );

    {
    If negitive_worth Then
    }
       net_worth := ( 0-net_worth );

    { make creditor total negitive }
    creditor_total := 0-creditor_total;

//    setdb ( 3 );		{ nominal Ledger }
{    setdb ( NLFile );
    readrec ( FL, Cash1.xnomdebtor );
    If errorno > 0 Then err;
    If recactive ( FL ) Then
       Begin
	  setitem;
	  currlong := debtor_total;
	  putitem ( FL, FIELD );
	  putitem ( FL, FIELD );
	  putitem ( FL, FIELD );
	  rewriterec ( FL, Cash1.xnomdebtor );
       End;


(*    readrec ( 3, Cash1.xnomdebtor );
    If errorno > 0 Then err;
    If recactive ( 3 ) Then
       Begin
	  setitem;
	  currlong := debtor_total;
	  putitem ( 3, 2 );
	  putitem ( 3, 3 );
	  putitem ( 3, 4 );
	  rewriterec ( 3, Cash1.xnomdebtor );
       End;
*)
(*    readrec ( 3, xnomcreditor );*)
    If errorno > 0 Then err;
    If recactive ( 3 ) Then
       Begin
	  setitem;
	  currlong := creditor_total;
	  putitem ( 3, 2 );
	  putitem ( 3, 3 );
	  putitem ( 3, 4 );
(*	  rewriterec ( 3, xnomcreditor );*)
       End;

(*    readrec ( 3, xnomopen );*)
    If errorno > 0 Then err;
    If recactive ( 3 ) Then
       Begin
	  setitem;
	  currlong := net_worth;
	  putitem ( 3, 2 );
	  putitem ( 3, 3 );
	  putitem ( 3, 4 );
(*	  rewriterec ( 3, xnomopen );*)
       End;
}
  End;

(*****************************************************************************)
(*                                                                           *)
(* THE ABOVE SECTION MUST BE WRITTEN USING 'FL' OR INTEGER VARIABLES RATHER  *)
(* THAN  NUMERICAL VALUES                                                    *)
(*                                                                           *)
(*****************************************************************************)

BEGIN

  zero_cust_supp := 'Y';

  IF NOT Cash1.XCASHBOOK THEN ZEROFILE(SLFile);
  IF NOT Cash1.XCASHBOOK THEN ZEROFILE(PLFile);
  ZEROFILE (NLFile);
  ZEROFILE (TXFile);

  Cash1.XLASTTX:=0;
  DEFWRITE(0);

  FMainscreen.LoadTransactionGrid;

  // Empty the ProductTx table
  try
     AccsDataModule.ProdsTx.Close;
     AccsDataModule.ProdsTx.EmptyTable;
  except
     ShowMessage('Clear Down Process failed' + #13#13 +
                 'Could not clear the Product Transaction' + #13 +
                 'Contact Kingswood Computing');
  end;
end;

procedure TCleartxForm.FormActivate(Sender: TObject);
begin
  PassMask.Text := '';
  ConfirmBtn.Enabled := True;
  Exit.Enabled := True;
  PassMask.Enabled := True;
  ProgressLabel.Hide;
  ProgressBar.Hide;
  PassMask.SetFocus;
end;

procedure TCleartxForm.ExitClick(Sender: TObject);
begin
     Close;
end;

procedure TCleartxForm.ConfirmBtnClick(Sender: TObject);
begin
     If (PassMask.Text = 'config') OR
        (PassMask.Text = 'CONFIG') And
        Not(PassMask.Text = '' ) then
            Begin
                 ProgressLabel.Show;
                 Exit.Enabled := False;
                 Confirmbtn.Enabled := False;
                 PassMask.Enabled := False;
                 Clearfiles;
                 ProgressLabel.Hide;
                 ProgressBar.Hide;
                 PassMask.Text := '';
                 Messagedlg('Clear Down Process Completed.', mtInformation,[mbOK],0);
                 Close;
            End
     Else
            Begin
                 Messagedlg('Incorrect Password - Contact Kingswood Compting Ltd.', mtInformation,[mbOK],0);
                 PassMask.Text := '';
                 PassMask.SetFocus;
            End
end;

procedure TCleartxForm.PassMaskKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If (Key = VK_Return) Then
        Confirmbtn.Click;
end;

procedure TCleartxForm.FormShow(Sender: TObject);
Var Ico : TIcon;
begin
    Ico := Ticon.Create;
    Ico.Handle := LoadIcon(0,IDI_EXCLAMATION);
    With Image1.Picture Do
         Begin
              Ico.Height;
              Ico.Width;
              Image1.Picture.Graphic := Ico;
         End;
      Ico.Free;        
end;

end.


