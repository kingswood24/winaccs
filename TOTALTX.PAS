{ This Unit total the transaction for a given nominal into month columns }

Unit TotalTx;

InterFace
Uses
    Types;

Procedure total_tx_for_nom ( nom_db, curr_nom, month : Integer;
				     income_Acc : Boolean;
				     Var result : listcols );
     
Implementation
Uses
  Forms,
  VARS,
  PARAMS,
  CALCS,
  FILED,
  DBCORE,
  DBGEN,
  CLEARS,
  SysUtils,
  DefSecFl,
  Util,
  AbortPrg;

Procedure total_tx_for_nom ( nom_db, curr_nom, month : Integer;
				     income_Acc : Boolean;
				     Var result : listcols );
Var
  x,
  last_tx,
  yr,
  mn,
  dy,
  tx_rec,
  tx_from,
  tx_to	   : Integer;
{-->>  total_for : biglong;}
  debit_it  : boolean;


  Procedure err;
  Begin
     AbortProgram ( 'Error in Totaling Transactions' );
  End;

Begin


  For x := 1 To 13 Do
    result[x] := 0;

{-->>  total_for := 0;}
{-->>  tx_from := 0;}
{-->>  tx_to	  := 0;}
  setdb ( nom_db );
  readrec ( nom_db, curr_nom );
  If errorno > 0 Then err;
  If recactive ( nom_db ) Then
    Begin
      getitem ( nom_db, 15 );
      tx_from := currint;
      getitem ( nom_db, 16 );
      tx_to := currint;
      setdb ( TxFile );
      tx_rec := tx_from;
      last_tx := tx_Rec;

      If tx_from > 0 Then
	 Repeat
	    readrec ( TxFile, tx_rec );
	    If errorno > 0 Then err;
	    If recactive ( TxFile ) Then
	       Begin

		 getitem ( TxFile, 18 );
		 debit_it := false;
		 If currint = curr_nom Then
		    Begin
		      Getitem ( TxFile, 13 );
		      debit_it := true;
		    End
		 Else
		    Getitem ( TxFile, 14 );
		 tx_rec := currint;		    { set next record }
		 getitem ( TxFile, 2 );
		 datedisp ( 2, yr, mn, dy );
		 If ( CheckEditStatus ) And ( mn In [1..12] ) Then
		    Begin
		       getitem ( TxFile, 1 );
		       {
		       If currint = 9 Then
			  Begin
		       }
			     getitem ( TxFile, 17 );
			     If income_acc Then
				currlong := 0-currlong;
			     If debit_it Then
				result[mn] := result[mn] + currlong
			     Else
				result[mn] := result[mn] - currlong;
		       {
			  End;
		       }
		    End;
	       End;
            If ( tx_rec <= Last_Tx ) Then       { problem with pointer }
               tx_rec := 0;
            Last_Tx := Tx_rec;
	 Until ( tx_rec = 0 ) Or ( tx_rec > tx_to );
    End;

End;


Begin


End.
