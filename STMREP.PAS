{* 06/07/95
   Procedure statments and processtxs changed to allow custstm, suppstm
   be date filtered

ACCTYPE :
        '1' = All Accounts
        '2' = Range Of Accounts
        '3' = Select Accounts
        29/09/98 M.C.
        Added New Report Customers/Suppliers Invoice Summary Report.
        PROG can be SUPPSUM or CUSTSUM
}
       
Unit STMREP;

InterFace

{ FileNo will be either the Sales or Purchase Ledger }
PROCEDURE STM ( FileNo : Integer );

Implementation

Uses
    sortit,
    dialogs,
    SysUtils,
    OPENFL,
    clears,
    DbCore,
    params,
    calcs,
    DBRPT,
    abortprg,
    filed,
    vars,
    types,
    Stat,
    Graphics,
    AccsData,
    NewRepUnit,
    util,
    Printers;

PROCEDURE STM ( FileNo : Integer );
CONST
  MAXLINES = 66;
  MAXCOLS  = 81;
  MAXINTS  = 200;
  MAXYES   = 99;
  MAXLIST  = 200;
  max_grp  = 100;
Type

    TSTBEGIN = PACKED ARRAY[1..2] OF CHAR;
    TSTLINES = PACKED ARRAY[1..MAXLINES] OF STRING[MAXCOLS];
    TSTINTS  = PACKED ARRAY[1..MAXINTS] OF SmallInt;

    TGrpAccs = packed array[1..max_grp] of record
        acc_no   : SmallInt;				    (* store account numbers *)
        acc_name : ShortString;			            (* store account name *)
        totamt,						    (* total - vat *)
        tottax,						    (* total Vat *)
        total,
        quantity : long;				    (* total + Vat *)
    End;
VAR
		(* grp_accs records to hold select accounts total, names etc *)
  grp_accs   : ^TGrpAccs;
  OkToPrint  : Boolean;
  CurrDbl    : Double;                       { General purpose Double }
//  period1,
//  period2,
  grp_read   : integer;			       (* counter for grp_accs array *)
  TotalGrp  : boolean;		  (* only used if ledger cards & select accs *)
  total_ex_vat,
  vat_total,
  grand_total,
  total_quan  : long;		  (* to hold the total+vat for all accounts *)
  last_page  : boolean;	     (* only used if ledger card & selected accounts *)

  STBEGIN    : ^TSTBEGIN;    {PACKED ARRAY[1..2] OF CHAR;}
  STLINES    : ^TSTLINES;    {PACKED ARRAY[1..MAXLINES] OF STRING[MAXCOLS];}
  STINTS     : ^TSTINTS;     {PACKED ARRAY[1..MAXINTS] OF INTEGER;}

  RUNBAL     : LONG;
  LISTSUB    : INTEGER;
  FROMACC    : SmallInt;
  TOACC	     : INTEGER;
  LISTRUN    : BOOLEAN;
  TXPOINTER  : SmallInt;
  TXSAVE     : SmallInt;
  TXNEXTSUB  : INTEGER;
  TXNEXTREM  : INTEGER;
  PRINTTYPE  : INTEGER;
  AGEDBALS   : PACKED ARRAY[1..4] OF LONG;
{  ACCTYPE    : CHAR;}
  CUSTACC    : INTEGER;
  CUSTNAME   : STRING{[30]};
  Add1,
  Add2,
  Add3,
  Add4       : String;
  ACCBALANCE : LONG;
  DATEFORMAT : STRING80;
  DATE1	     : STRING{[8]};
  DATE2	     : STRING{[8]};
  FROMDT     : INTEGER;
  TODT	     : INTEGER;
  PAGE	     : INTEGER;
  SHOWAMT    : BOOLEAN;
  BLANK	     : BOOLEAN;
{-->>  FIRST	     : BOOLEAN;}
  TOTQTY     : LONG;
  TOTAMT     : LONG;
  TOTTAX     : LONG;
//  SCHANALF   : INTEGER;
//  SCHANALT   : INTEGER;
  DESCFLD    : INTEGER;
  FIRSTTX    : INTEGER;
  ALLOC	     : BOOLEAN;
  BALBF	     : BOOLEAN;

  start_from	: integer;	   { transaction record to start reading from }
  sort_asc,				    { sort in ascending or descending }
  report_sorted : boolean;			   { true if you want to sort }
  sortfld,						{ which field to sort }
  sortpos,					 { position in sortwork array }
  sortblk  : integer;					 { current sort block }
  sortwork : packed array[1..512] of char;		    { store sort data }
  open_balance : Boolean;
  stopping_balance : Long;	{ stores the stopping balance for statements }
				{ if a date range has been specified }
  first_pass : Boolean;		{ indicates if the stopping balance has been }
				{ set for the particular cust/supp }
  blankit   : Boolean;
  inv_amt,
  inv_vat,
  inv_tot   : long;
  sub_total_inv,		{ true if subtotalling Invoices }
  exclude_first : Boolean;	{ true for 1st Invoice for every Cust/Supp }

  head_area     : Integer;

  AreaFrom,
  AreaTo	: Integer;

  ThrowPage,			     { used to stop page throw on record cards }
  page_break,
  sort_area	: Boolean;
  no_count	: Integer;	{ no of records read }
  ExitProcessTxs: Boolean;
  PrintFrom     : SmallInt;
  DoubleSpace   : Boolean;
  LineForTotals : Integer;      // Hold the Total Line for Invoice Summary
  GreaterThan :real;
  Code: integer;

  PROCEDURE STATEMENTS;	    FORWARD;
  PROCEDURE PRINTSTATEMENT; FORWARD;
  PROCEDURE PROCESSTXS;	    FORWARD;

  Procedure DisposeMemory;
  Begin
      Dispose ( Grp_Accs );
      Dispose ( STLINES );
      Dispose ( STBEGIN );
      Dispose ( STINTS );
  end;

  Procedure NewMemory;
  Begin
      Try
         New ( Grp_Accs );
         New ( STBEGIN );
         New ( STLINES );
         New ( STINTS );

         FillChar ( Grp_Accs^, SizeOf(Grp_Accs^),chr(0));
         FillChar ( STBEGIN^, SizeOf(STBEGIN^),chr(0));
         FillChar ( STLINES^, SizeOf(STLINES^),chr(0));
         FillChar ( STINTS^, SizeOf(STINTS^),chr(0));

      Except
         DisposeMemory;
      End;
  end;

  Procedure init_grp_array;   (* initalize the record to store Accounts data *)
  Var x : integer;
  Begin
    for x := 1 to max_grp do
      Begin
	grp_accs^[x].acc_no   := 0;
	grp_accs^[x].acc_name := '';
	grp_accs^[x].totamt   := 0;
	grp_accs^[x].tottax   := 0;
	grp_accs^[x].total    := 0;
	grp_accs^[x].quantity := 0;
      End;
  End;

  { this procedure sets the next record to read if you are sorting }
  Procedure next_sort_rec ( var update_read_no : SmallInt );
  Begin
    if sortpos + 2 > 513 then
      Begin
	sortblk := sortblk + 1;
	sortpos := 1;
	if cread ( SortFileNo, 1, sortblk ) < 1 then AbortProgram ( seqerr );
	Move ( cblocks[1], sortwork[1], 512 );
      End;
    move ( sortwork[sortpos], update_read_no, 2 );
    sortpos := sortpos + 2;
    if update_read_no > 30000 then update_read_no := 0;
  End;

  Procedure sort_file ( db : Integer; Var next_Read : SmallInt;
			sort_fld, start_from : Integer;
			sort_asc : Boolean );
     Begin
      	tx_start := fromacc;
	tx_end	 := toacc;
	SortFile ( db, SortFileNo, WorkFile, sort_fld, 999, 0, 0, sort_asc, TRUE, TRUE, TRUE,
				  start_from, 0, false, false );

	cclose ( SortFileNo, 'N' );
	creset ( SortFileNo, sortid );
	if errorno > 0 then AbortProgram ( seqerr );

	sortpos := 512;
	sortblk := -1;

	{ get the next record to read }
	next_sort_rec ( next_read );
     End;

  PROCEDURE ERR;
  BEGIN
    MessageDlg('Error Occured ' + IntToStr ( errorno), mtInformation,[mbOK], 0);
    {DISKERROR;}
    DisposeMemory;
    EXIT;
  END;

  PROCEDURE READSTM ( StateFileNo : Integer );
  VAR
    X : INTEGER;
  BEGIN
    STLINES^[1]:=CONCAT(SPACE40,SPACE40);
    FOR X:=2 TO 66 DO STLINES^[X]:=STLINES^[1];
    ERRORNO:=0;
    {
    IF CREAD(StateFileNo,3,0)<3 THEN EXIT;
    Move(CBLOCKS[1],STBEGIN^[1],SizeOf(STBEGIN^));
    Move(CBLOCKS[1,3],STLINES^[1,1],(1536-SizeOf(STBEGIN^)));

    IF CREAD(StateFileNo,3,3)<3 THEN EXIT;
    Move(CBLOCKS[1],STLINES^[19][58],1536);
    IF CREAD(StateFileNo,3,6)<3 THEN EXIT;
    Move(CBLOCKS[1],STLINES^[38][36],1536);

    IF CREAD(StateFileNo,3,9)<3 THEN EXIT;
    Move(CBLOCKS[1],STLINES^[57][14],805);

    Move(CBLOCKS[2,294],STINTS^[1],SizeOf(STINTS^));
    }

    For X:=1 to 200 do STINTS^[X] := 0;

    if StatefileNo = SLStatefile then begin
        STLINES^[1] := '           S A L E   S T A T E M E N T                                          ';
        STLINES^[2] := '                                                                               *';
        STLINES^[3] := '     ______________________________                                            *';
        STLINES^[4] := '     To:                                                                       *';
        STLINES^[5] := '                                                                               *';
        STLINES^[6] := '                                                                               *';
        STLINES^[7] := '                                             Statement Of Account              *';
        STLINES^[8] := '                                                                               *';
        STLINES^[9] := '     _______________________________                                           *';
        STLINES^[20]:= '================================================================================';
        STLINES^[21]:= 'Date     Type Ref        Description             Debit      Credit     Balance  ';
        STLINES^[22]:= '--------------------------------------------------------------------------------';
        STLINES^[48]:= '--------------------------------------------------------------------------------';
        STLINES^[49]:= '                                                                               *';
        STLINES^[50]:= ' Please return this      section with your payment                              ';
        STLINES^[51]:= '                                                                               *';
        STLINES^[52]:= '                                    Balance Outstanding:                        ';
        STLINES^[53]:= ' Current:                                                                       ';
        STLINES^[55]:= ' 30+ days:                                                                      ';
        STLINES^[57]:= ' 60+ days:                                                                      ';
        STLINES^[59]:= ' 90+ days:                                                                      ';
        STLINES^[61]:= '  Account No:            NAME:                                                  ';
        STLINES^[62]:= ' EOFILE                                                                         ';

        STINTS^[5] := 62;
        STINTS^[6] := 23;
        STINTS^[7] := 47;
        STINTS^[10] := 61;
        STINTS^[11] := 14;
        STINTS^[12] := 7;
        STINTS^[13] := 67;
        STINTS^[20] := 45;
        STINTS^[21] := 57;
        STINTS^[22] := 69;
        STINTS^[23] := 10;
        STINTS^[24] := 52;
        STINTS^[30] := 53;
        STINTS^[31] := 16;
        STINTS^[32] := 55;
        STINTS^[33] := 16;
        STINTS^[34] := 57;
        STINTS^[35] := 16;
        STINTS^[36] := 59;
        STINTS^[37] := 16;

        STINTS^[101] := 1;
        STINTS^[102] := 4;
        STINTS^[103] := 11;
        STINTS^[104] := 2;
        STINTS^[105] := 5;
        STINTS^[106] := 11;
        STINTS^[107] := 3;
        STINTS^[108] := 6;
        STINTS^[109] := 11;
        STINTS^[110] := 4;
        STINTS^[111] := 7;
        STINTS^[112] := 11;
        STINTS^[113] := 5;
        STINTS^[114] := 8;
        STINTS^[115] := 11;
        STINTS^[116] := 1;
        STINTS^[117] := 61;
        STINTS^[118] := 32;
        STINTS^[119] := 2;

        STINTS^[122] := 3;
        STINTS^[125] := 4;
        STINTS^[128] := 5;
        STINTS^[131] := 2;
        STINTS^[132] := 1;
        STINTS^[133] := 4;
        STINTS^[134] := 15;
        STINTS^[135] := 5;
        STINTS^[136] := 26;


    end;
    if StatefileNo = PLStatefile then begin
        STLINES^[1] := '           S A L E   S T A T E M E N T                                          ';
        STLINES^[2] := '                                                                               *';
        STLINES^[3] := '     ______________________________                                            *';
        STLINES^[4] := '     To:                                                                       *';
        STLINES^[5] := '                                                                               *';
        STLINES^[6] := '                                                                               *';
        STLINES^[7] := '                                             Statement Of Account              *';
        STLINES^[8] := '                                                                               *';
        STLINES^[9] := '     _______________________________                                           *';
        STLINES^[20]:= '================================================================================';
        STLINES^[21]:= 'Date     Type Ref        Description             Debit      Credit     Balance  ';
        STLINES^[22]:= '--------------------------------------------------------------------------------';
        STLINES^[48]:= '--------------------------------------------------------------------------------';
        STLINES^[49]:= '                                                                               *';
        STLINES^[50]:= ' Please return this      section with your payment                              ';
        STLINES^[51]:= '                                                                               *';
        STLINES^[52]:= '                                    Balance Outstanding:                        ';
        STLINES^[53]:= ' Current:                                                                       ';
        STLINES^[55]:= ' 30+ days:                                                                      ';
        STLINES^[57]:= ' 60+ days:                                                                      ';
        STLINES^[59]:= ' 90+ days:                                                                      ';
        STLINES^[61]:= '  Account No:            NAME:                                                  ';
        STLINES^[62]:= ' EOFILE                                                                         ';

        STINTS^[5] := 62;
        STINTS^[6] := 23;
        STINTS^[7] := 47;
        STINTS^[10] := 61;
        STINTS^[11] := 14;
        STINTS^[12] := 7;
        STINTS^[13] := 67;
        STINTS^[20] := 45;
        STINTS^[21] := 57;
        STINTS^[22] := 69;
        STINTS^[23] := 10;
        STINTS^[24] := 52;
        STINTS^[30] := 53;
        STINTS^[31] := 16;
        STINTS^[32] := 55;
        STINTS^[33] := 16;
        STINTS^[34] := 57;
        STINTS^[35] := 16;
        STINTS^[36] := 59;
        STINTS^[37] := 16;

        STINTS^[101] := 1;
        STINTS^[102] := 4;
        STINTS^[103] := 11;
        STINTS^[104] := 2;
        STINTS^[105] := 5;
        STINTS^[106] := 11;
        STINTS^[107] := 3;
        STINTS^[108] := 6;
        STINTS^[109] := 11;
        STINTS^[110] := 4;
        STINTS^[111] := 7;
        STINTS^[112] := 11;
        STINTS^[113] := 5;
        STINTS^[114] := 8;
        STINTS^[115] := 11;
        STINTS^[116] := 1;
        STINTS^[117] := 61;
        STINTS^[118] := 32;
        STINTS^[119] := 2;

        STINTS^[122] := 3;
        STINTS^[125] := 4;
        STINTS^[128] := 5;
        STINTS^[131] := 2;
        STINTS^[132] := 1;
        STINTS^[133] := 4;
        STINTS^[134] := 15;
        STINTS^[135] := 5;
        STINTS^[136] := 26;


    end;
  END;

  PROCEDURE READLED;
  VAR
    X  : INTEGER;
    ST : STRING;
  BEGIN
    For x := 1 to PrintFrom do
        StLines[x] := CONCAT(SPACE40,SPACE40);
    STLINES^[1+PrintFrom]:=CONCAT(SPACE40,SPACE40);
    FOR X:=2+PrintFrom TO 66 DO STLINES^[X]:=STLINES^[1];
    STLINES^[1+PrintFrom]:=CONCAT(DASH40,DASH40);
    STLINES^[5+PrintFrom]:=CONCAT(DASH40,DASH40);
    if PROG In [SUPPSUM,CUSTSUM] then
       STLINES^[8+PrintFrom]:=CONCAT(DASH40,DASH40) //this needs changed for invoice summary
    else
       STLINES^[7+PrintFrom]:=CONCAT(DASH40,DASH40);
    if NOT ( PROG In [SUPPSUM,CUSTSUM] ) then
       Move (Cash1.XCOMPANY[1],STLINES^[2+PrintFrom][1],LENGTH(Cash1.XCOMPANY));
    CASE PROG OF
      CUSTLED : ST:='CUSTOMER LEDGER CARD';
      SUPPLED : ST:='SUPPLIER LEDGER CARD';
      CUSTREC : ST:='CUSTOMER RECORD CARD';
      SUPPREC : ST:='SUPPLIER RECORD CARD';
      CUSTSUM : ST:='CUSTOMER INVOICE/SUMMARY';
      SUPPSUM : ST:='SUPPLIER INVOICE/SUMMARY';
    END;
    if ( PROG In [SUPPSUM,CUSTSUM] ) then
       Move (ST[1],STLINES^[2+PrintFrom][44],LENGTH(ST))
    else
       Move (ST[1],STLINES^[2+PrintFrom][36],LENGTH(ST));
    ST:=SYSNAME;
    Move (ST[1],STLINES^[4+PrintFrom][1],LENGTH(ST));
    if NOT ( PROG In [SUPPSUM,CUSTSUM] ) then
       begin
          ST:=VERNO;
          Move (ST[1],STLINES^[4+PrintFrom][65{67}],LENGTH(ST));
       end;
    CASE PROG OF
      CUSTLED,
      SUPPLED : BEGIN
                  ST:='DATE     TX-NO TYP REF      DESCRIPTION';
		  Move (ST[1],STLINES^[6][1],LENGTH(ST));
		  ST:='DEBIT      CREDIT     BALANCE';
		  Move (ST[1],STLINES^[6][49],LENGTH(ST));
		END;
      CUSTREC,
      SUPPREC : BEGIN
		  {
                  if showamt then
		    st := 'DATE     TX-NO DESC      NOM    '
		  else
		    ST := 'DATE     TX-NO DESCRIPTION   NOM';
		  Move (ST[1],STLINES^[6][1],LENGTH(ST));
                  }
		END;
    END;
  END;

  Procedure CheckHeading;
  Var
     St : ShortString;
  Begin
     if ( PROG In [CUSTREC,SUPPREC] ) Then
        Begin
           If ( ShowAmt ) And ( Sub_Total_Inv ) Then
               St := 'DATE     INV-REF   DESC           '
           Else If ( NOT ShowAmt ) And ( Sub_Total_Inv ) Then
               St := 'DATE     INV-REF    DESCRIPTION   '
           Else If ( ShowAmt ) And ( NOT Sub_Total_Inv ) Then
               St := 'DATE     TX-NO DESC       NOM     '
           Else If not last_page then begin
               St := 'DATE     TX-NO DESCRIPTION     NOM';
               MOVE (ST[1],STLINES[6+PrintFrom][ 1],LENGTH(ST));
           end;
        End;
     if ( PROG In [CUSTSUM,SUPPSUM] ) then
//tgm
//        Cash2.xCountry:= 2;

        begin
          ST := 'DATE     DESCRIPTION             ';
          Move (ST[1],STLINES^[7+PrintFrom][1],LENGTH(ST));

          if StatementForm.PerUnit.Checked then
             begin
                if Length(StatementForm.eAltName1.Text) > 0 then
                   ST := StatementForm.eAltName1.Text
                else
                   ST := 'HRS';
             end
          else if Length(StatementForm.eAltName1.Text) > 0 then
             ST := StatementForm.eAltName1.Text
          else
             ST:='HRS';
          PADRIGHT(ST,8);
          Move (ST[1],STLINES^[6+PrintFrom][30],LENGTH(ST));       // TGM AB CHanged from 35

          if StatementForm.PerUnit.Checked then
             begin
                ST := 'UNIT';
                Move (ST[1],STLINES^[6+PrintFrom][42],LENGTH(ST));
             end;

          if StatementForm.PrintBox.ItemIndex In [0,2,3] then
             begin
                ST:='PRICE';
                Move (ST[1],STLINES^[6+PrintFrom][52],LENGTH(ST));
             end;

          if StatementForm.PrintBox.ItemIndex In [0,1] then
             begin
                ST:='TOTAL';
                Move (ST[1],STLINES^[6+PrintFrom][72],LENGTH(ST));
             end;

          if StatementForm.PerUnit.Checked then
             begin
                if Length(StatementForm.eAltName2.Text) > 0 then
                   ST := StatementForm.eAltName2.Text
                else
                   ST := 'ACRES';
             end
          else
             begin
                if Length(StatementForm.eAltName2.Text) > 0 then
                   ST := StatementForm.eAltName2.Text
                else
                   ST := 'ACRES';
             end;
          PADRIGHT(ST,8);
          If ((Stat.StatementForm.ShowEuroTotals.checked = true) and (NewRepUnit.NewRepForm.newreports.checked = true)) then begin//( Cash2.xCountry = 2 ) then
             if StatementForm.PerUnit.Checked then
             begin
                if Length(StatementForm.eAltName1.Text) > 0 then
                   ST := StatementForm.eAltName1.Text + '-' + ST
                else
                   ST := 'HRS-' + ST;
             end
          else if Length(StatementForm.eAltName1.Text) > 0 then
             ST := StatementForm.eAltName1.Text +'-' + ST
          else
             ST:='HRS-' + ST;

             Move (ST[1],STLINES^[7+PrintFrom][30],LENGTH(ST))
             end // was 35
             else Move (ST[1],STLINES^[7+PrintFrom][30],LENGTH(ST));     // TGB AB Changed from 35

          if StatementForm.PerUnit.Checked then
             begin
                ST := 'PRICE';
                If ((Stat.StatementForm.ShowEuroTotals.checked = true) and (NewRepUnit.NewRepForm.newreports.checked = true)) then //( Cash2.xCountry = 2 ) then
                   Move (ST[1],STLINES^[7+PrintFrom][36],LENGTH(ST)) // was 42
                   else Move (ST[1],STLINES^[7+PrintFrom][42],LENGTH(ST));
             end;

          if StatementForm.PrintBox.ItemIndex In [0,2,3] then
             begin
                If ((Stat.StatementForm.ShowEuroTotals.checked = true) and (NewRepUnit.NewRepForm.newreports.checked = true)) then begin//( Cash2.xCountry = 2 ) then begin
                   ST:=' EX VAT     VAT    PRICE  Euro Value';
                   Move (ST[1],STLINES^[7+PrintFrom][42],LENGTH(ST)); // was 52
                end else begin
                   ST:='EX VAT      VAT    PRICE';
                   Move (ST[1],STLINES^[7+PrintFrom][52],LENGTH(ST)); // was 52
                end;
             end
          else if StatementForm.PrintBox.ItemIndex = 1 then
             begin
                ST:='PRICE';
                Move (ST[1],STLINES^[7+PrintFrom][72],LENGTH(ST));
             end;
        end;
  End;

  PROCEDURE PRINTOUT (LINE: INTEGER);
  VAR
    ST	  : ShortSTRING;
  BEGIN
    if  ( Device = 'P' ) and (( Line <= PrintFrom+8 ) and ( PROG In [CUSTSUM,SUPPSUM] )) Or
       (( Line <= PrintFrom+7 ) and ( PROG In [CUSTLED,SUPPLED,CUSTREC,SUPPREC] )) then
       Printer.Canvas.Font.Style := [fsBold];
    if ( Device = 'P' ) And ( Line = LineForTotals ) and ( PROG In [CUSTSUM,SUPPSUM] ) then
       Printer.Canvas.Font.Style := [fsBold];
    if ( Device = 'P' ) And (( Line <= STINTS^[6] ) or ( Line >= STINTS^[7] )) and ( PROG In [CUSTSTM,SUPPSTM] ) then
       Printer.Canvas.Font.Style := [fsBold];

    if STINTS^[191]>0 THEN
      if LINE>STINTS^[191] THEN
	if (LINE<STINTS^[191]+STINTS^[196]+1) THEN EXIT;
    if LINE>MAXLINES THEN
      BEGIN
	SENDLINE (NULL);
	EXIT;
      END;
    ST:=STLINES^[LINE];
    SLIMRIGHT(ST);
    if (( LINE=STINTS^[191] ) And ( Device = 'P' )) THEN
      BEGIN
	{
        IF STINTS^[192]<>0 THEN WRITE(PRINTFILE,CHR(STINTS^[192]));
	IF STINTS^[193]<>0 THEN WRITE(PRINTFILE,CHR(STINTS^[193]));
	}
        SENDLINE (ST);
	{
        IF STINTS^[194]<>0 THEN WRITE(PRINTFILE,CHR(STINTS^[194]));
	IF STINTS^[195]<>0 THEN WRITE(PRINTFILE,CHR(STINTS^[195]));
        }
      END
    ELSE
      SENDLINE (ST);
    if Device = 'P' then
       Printer.Canvas.Font.Style := [];
    IF ESCKEY THEN EXIT;
    {LINECOUNT:=LINECOUNT+1;}

  END;

  PROCEDURE FILL (LINE,COL,SIZ: INTEGER; CH: CHAR);
  BEGIN
    IF (LINE>0) AND (LINE<MAXLINES+1) THEN
      IF (COL>0) AND NOT(COL+SIZ-1>MAXCOLS) THEN
	FILLCHAR(STLINES^[LINE][COL],SIZ,CH);
  END;

  PROCEDURE BUILDITEM (LINE,COL: INTEGER);
{-->>  VAR
    Y : INTEGER;}
  BEGIN
    IF CURRSIZE<1 THEN EXIT;
{-->>    Y:=CURRSIZE;}
    IF (COL+CURRSIZE-1>MAXCOLS) OR (COL<1) THEN EXIT;
    IF (LINE<1) OR (LINE>MAXLINES) THEN EXIT;
    Move(CURRDISP[1],STLINES^[LINE][COL],CURRSIZE);
  END;

  PROCEDURE BUILDSTR (LINE,COL,MINSZ: INTEGER; ST: STRING);
  VAR
    SZ : INTEGER;
    WD : PACKED ARRAY[1..80] OF CHAR;
  BEGIN
    SZ:=LENGTH(ST);
    IF (SZ<1) OR (SZ>80) THEN EXIT;
    FILLCHAR(WD[1],80,SPACE1);
    Move(ST[1],WD[1],LENGTH(ST));
    IF (LINE<1) OR (LINE>MAXLINES) THEN EXIT;
    IF (COL<1) OR (MINSZ=0) OR (COL+MINSZ-1>MAXCOLS) THEN EXIT;
    Move(WD[1],STLINES^[LINE][COL],MINSZ);
  END;


  PROCEDURE CUSTITEMS;
  VAR
    SUB : INTEGER;
  BEGIN
    SETDB(FileNo);
    CASE PROG OF
      CUSTSTM,SUPPSTM : FOR SUB:=1 TO 10 DO // possible TENFOUND
			  BEGIN
			    GETITEM(FileNo,STINTS^[98+(SUB*3)]);
			    BUILDITEM(STINTS^[99+(SUB*3)],STINTS^[100+(SUB*3)]);
			  END;
      CUSTLED,SUPPLED,
      CUSTREC,SUPPREC : BEGIN
			  CUSTNAME := COPY ( SPACE40, 1, 30 );
			  GETITEM(FileNo,1);
			  CUSTNAME:=CURRSTR;
			  While length ( custname ) < 30 do
			    custname := concat ( custname, ' ' );
			END;
      CUSTSUM,SUPPSUM : BEGIN
			  CUSTNAME := COPY ( SPACE40, 1, 30 );
			  SETITEM;
                          GETITEM(FileNo,1);
			  CUSTNAME:=CURRSTR;
			  While length ( custname ) < 25 do
			    custname := concat ( custname, ' ' );
                          if Length(CustName) > 25 then
                             Delete(CustName,26,Length(CustName)-25);
                          // Add1
			  Add1 := COPY ( SPACE40, 1, 30 );
			  SETITEM;
			  GETITEM(FileNo,2);
			  Add1:=CURRSTR;
			  While length ( Add1 ) < 25 do
			    Add1 := concat ( Add1, ' ' );
                          if Length(Add1) > 25 then
                             Delete(Add1,26,Length(Add1)-25);
                          // Add2
			  Add2 := COPY ( SPACE40, 1, 30 );
			  SETITEM;
			  GETITEM(FileNo,3);
			  Add2:=CURRSTR;
			  While length ( Add2 ) < 25 do
			    Add2 := concat ( Add2, ' ' );
                          if Length(Add2) > 25 then
                             Delete(Add2,26,Length(Add2)-25);
			  Add3 := COPY ( SPACE40, 1, 30 );
			  SETITEM;
			  GETITEM(FileNo,4);
			  Add3:=CURRSTR;
			  While length ( Add3 ) < 25 do
			    Add3 := concat ( Add3, ' ' );
                          if Length(Add3) > 25 then
                             Delete(Add3,26,Length(Add3)-25);
			  Add4 := COPY ( SPACE40, 1, 30 );
			  SETITEM;
			  GETITEM(FileNo,5);
			  Add4:=CURRSTR;
			  While length ( Add4 ) < 25 do
			    Add4 := concat ( Add4, ' ' );
                          if Length(Add4) > 25 then
                             Delete(Add4,26,Length(Add4)-25);

			END;
    END;
  END;

  PROCEDURE BLANKSTATEMENT;
  VAR
    X  : INTEGER;
    ST : STRING;
  BEGIN
    CASE PROG OF
      CUSTLED,SUPPLED,
      CUSTREC,SUPPREC : Begin
			  STLINES^[4+PrintFrom]:=CONCAT(SPACE40,SPACE40);
			  ST:=SYSNAME;
			  Move (ST[1],STLINES^[4+PrintFrom][1],LENGTH(ST));
			  ST:=VERNO;
			  Move (ST[1],STLINES^[4+PrintFrom][65{67}],LENGTH(ST));
			  PAGE:=PAGE+1;
			  STR (PAGE,ST);
			  ST:=CONCAT('PAGE ',ST);
			  Move (ST[1],STLINES^[2+PrintFrom][72],LENGTH(ST));
			  FOR X:=9+PrintFrom TO 66 DO STLINES^[X]:=CONCAT(SPACE40,SPACE40);
			  If ( Prog In [custrec, supprec,SUPPSUM,CUSTSUM] ) and sort_area Then
			    Begin
			      buildstr ( 3+PrintFrom,30{34}, 6, 'AREA CODE: ');
			      str ( head_area, st );
			      buildstr ( 3+PrintFrom,39{45}, 4, st );
			    End;
			  (*
			  This section of code outputs the customer name &
			  number on ledger cards which are longer than 1 page
			  *)
			  If (( NOT last_page ) and ( page > 1 )) then
			    Begin
			      buildstr (3+PrintFrom,30{36}, 9, 'ACCOUNT: ');
			      str ( custacc, st );
			      buildstr (3+PrintFrom,39{45}, 4, st );
			      buildstr (3+PrintFrom,44{50}, length (custname), custname);
			    End;
                          If ( Device = 'P' ) And ( Page > 1 ) Then
                             Begin
                                  Printer.NewPage;
                                  Linecount := 0;
                             End;
			END;
      CUSTSUM,SUPPSUM : Begin
			  STLINES^[4+PrintFrom]:=CONCAT(SPACE40,SPACE40);
			  PAGE:=PAGE+1;
			  STR (PAGE,ST);
			  ST:=CONCAT('PAGE ',ST);
			  Move (ST[1],STLINES^[2+PrintFrom][70],LENGTH(ST));
			  FOR X:=9+PrintFrom TO 66 DO STLINES^[X]:=CONCAT(SPACE40,SPACE40);
			  (*
			  This section of code outputs the customer name &
			  number on ledger cards which are loner than 1 page
			  *)
			  If (( NOT last_page ) and ( page > 1 )) then
			    Begin
			      buildstr (2+PrintFrom,1, 9, 'ACCOUNT: ');
			      str ( custacc, st );
			      buildstr (2+PrintFrom,9, 4, st );
			      buildstr (2+PrintFrom,14, length (custname), custname);
			      buildstr (3+PrintFrom,14, length (Add1), Add1);
			      buildstr (4+PrintFrom,14, length (Add2), Add2);
			      //buildstr (5+PrintFrom,14, length (Add3), Add3);
			      //buildstr (6+PrintFrom,14, length (Add4), Add4);
			    End;
			  (*
                          STLINES^[4+PrintFrom]:=CONCAT(SPACE40,SPACE40);
			  PAGE:=PAGE+1;
			  STR (PAGE,ST);
			  ST:=CONCAT('PAGE ',ST);
			  Move (ST[1],STLINES^[2+PrintFrom][30],LENGTH(ST));
			  FOR X:=9+PrintFrom TO 66 DO STLINES^[X]:=CONCAT(SPACE40,SPACE40);
			  If ( Prog In [custrec, supprec,SUPPSUM,CUSTSUM] ) and sort_area Then
			    Begin
			      buildstr ( 3+PrintFrom,30, 6, 'AREA CODE: ');
			      str ( head_area, st );
			      buildstr ( 3+PrintFrom,39, 4, st );
			    End;
			  {
			  This section of code outputs the customer name &
			  number on ledger cards which are loner than 1 page
			  }
			  If (( NOT last_page ) and ( page > 1 )) then
			    Begin
			      buildstr (2+PrintFrom,40, 9, 'ACCOUNT: ');
			      str ( custacc, st );
			      buildstr (2+PrintFrom,49, 4, st );
			      buildstr (2+PrintFrom,54, length (custname), custname);
			      buildstr (3+PrintFrom,54, length (Add1), Add1);
			      buildstr (4+PrintFrom,54, length (Add2), Add2);
			    End;
                          *)
                          if ( Device = 'P' ) And ( Page > 1 ) Then
                             Begin
                                  Printer.NewPage;
                                  Linecount := 0;
                             End;
			END;
      CUSTSTM,SUPPSTM : BEGIN
                          Page := Page +1;
			  IF NOT(STINTS^[6]>STINTS^[7]) THEN
			    FOR X:=STINTS^[6] TO STINTS^[7] DO
			      FILL(X,1,MAXCOLS,' ');
			  BUILDSTR(STINTS^[24],STINTS^[22],12,'		 ');
			  FOR X:=1 TO 4 DO BUILDSTR(STINTS^[28+(X*2)],
			    STINTS^[29+(X*2)],12,'	     ');
			  IF NOT(STINTS^[46]>STINTS^[47]) THEN
			    FOR X:=STINTS^[46] TO STINTS^[47] DO
			      FILL(X,1,MAXCOLS,' ');
			  BUILDSTR(STINTS^[64],STINTS^[62],12,'		 ');
			  FOR X:=1 TO 4 DO BUILDSTR(STINTS^[68+(X*2)],
			    STINTS^[69+(X*2)],12,'	     ');
                          If ( Device = 'P' ) And ( Page > 1 ) Then
                             Begin
                                  Printer.NewPage;
                                  Linecount := 0;
                             End;
			END;
    END;
  END;

  PROCEDURE PRINTAGED;
  VAR
    X	   : INTEGER;
    ST	   : ShortSTRING;
    ANYNEG : BOOLEAN;
  BEGIN
    { if using date range then don't print out aged balance }
    {
    If (( period1 <> 0 ) And ( period2 <> 0 )) Then
       exit ( printaged );
    }
(*    if (( FROMDT <> CDateFrom ) and ( TODT <> CDateTo )) then
       Exit;
  *)
    ANYNEG:=FALSE;

    if ( accbalance < 0 ) then
      anyneg := true;

    { MC 08/03/95 Taken out, now test accbalance and setting anyneg
      from this
    FOR X:=1 TO 4 DO
      BEGIN
	GETITEM(1,8+X);
	IF CURRLONG<0 THEN ANYNEG:=TRUE;
      END;
    }
    FOR X:=1 TO 4 DO
      BEGIN
	GETITEM(FileNo,8+X);
	{LONGSTR(CURRLONG,ST,'L');}
        DoubleToStr ( CurrLong, St, '%10.2f', True, True, 10, False );
	IF ANYNEG THEN ST:='		';
	BUILDSTR(STINTS^[28+(X*2)],STINTS^[29+(X*2)],LENGTH(ST),ST);
	BUILDSTR(STINTS^[68+(X*2)],STINTS^[69+(X*2)],LENGTH(ST),ST);
      END;
  END;

  PROCEDURE STSTART;
  VAR
    ST : ShortSTRING;
    X  : INTEGER;
  BEGIN
    CUSTITEMS;
    open_balance := false;
    STR(CUSTACC,ST);
    CASE PROG OF
      CUSTSTM,SUPPSTM : BEGIN
			  BUILDSTR(STINTS^[10],STINTS^[11],4,ST);
			  BUILDSTR(STINTS^[50],STINTS^[51],4,ST);
			  TXNEXTSUB:=STINTS^[ 6];
			  {doing this to stp discounts coming out on line 1 of }
			  {the statements }
			  If stints^[46] = 0 Then
			     TXNEXTREM:=-1
			  Else
			     TXNEXTREM:=STINTS^[46];
			  GETITEM(FileNo,6);
			END;
      CUSTLED,SUPPLED : Begin
			  BUILDSTR(3,30{36},9,'ACCOUNT: ');
			  BUILDSTR(3,39{45},4,ST);
			  BUILDSTR(3,44{50},LENGTH(CUSTNAME),CUSTNAME);

			  If ( prog In [custled,suppled] ) And ( Device = 'S' ) Then
			    Begin
			      ST:='DEBIT    CREDIT   BALANCE EUR';
			      Move (ST[1],STLINES^[6][49],LENGTH(ST));
			    End;

			  { Initialise The Sub Total Vars }
			  inv_amt := 0;
			  inv_vat := 0;
			  inv_tot := 0;
			  exclude_first := true;

			  TXNEXTSUB:=9;
			  GETITEM(FileNo,17);

			End;
      CUSTREC,SUPPREC : BEGIN  // TGM AB - customer / supplier record card
			  If (( txnextsub < RFarmGate.plinespage[1]-5 ) And
			      ( NOT ThrowPage ) And ( No_count > 1 )) Then
			    Begin
			      txnextsub := txnextsub + 1;
			      st := concat ( dash40, dash40 );
			      buildstr ( txnextsub, 1, 80, st );
			      txnextsub := txnextsub + 1;
			      st := '';
			      STR(CUSTACC,ST);
			      BUILDSTR(txnextsub,30{36},9,'ACCOUNT: ');
			      BUILDSTR(txnextsub,39{45},4,ST);
			      BUILDSTR(txnextsub,44{50},LENGTH(CUSTNAME),CUSTNAME);
			      txnextsub := txnextsub + 1;
			      st := concat ( dash40, dash40 );
			      buildstr ( txnextsub, 1, 80, st );
			    End
			  Else
			    Begin
			      BUILDSTR(3+PrintFrom,30{36},9,'ACCOUNT: ');
			      BUILDSTR(3+PrintFrom,39{45},4,ST);
			      BUILDSTR(3+PrintFrom,44{50},LENGTH(CUSTNAME),CUSTNAME);

			      if showamt then
				//st := 'DATE     TX-NO DESC       NOM    QUAN    AMOUNT   AMT/UNIT      VAT     TOTAL'
				st := 'DATE     TX-NO DESC       NOM    QUAN    AMT/UNIT   AMOUNT      VAT     TOTAL'
			      else
				st := 'DATE     TX-NO DESCRIPTION     NOM  QUANTITY     AMOUNT        VAT      TOTAL';
			      Move ( st[1], STLINES^[6+PrintFrom][1], length ( st ));
			      TXNEXTSUB:=7+PrintFrom;
			    End;
			  { Initialise The Sub Total Vars }
			  inv_amt := 0;
			  inv_vat := 0;
			  inv_tot := 0;
			  exclude_first := true;
			  GETITEM(FileNo,17);
			END;
      CUSTSUM,SUPPSUM : BEGIN
			  if (( txnextsub < RFarmGate.plinespage[1]-5 ) And
			      ( NOT ThrowPage ) And ( No_count > 1 )) Then
			    begin
			      txnextsub := txnextsub + 1;
			      st := concat ( dash40, dash40 );
			      buildstr ( txnextsub, 1, 80, st );
			      txnextsub := txnextsub + 1;
			      st := '';
			      str ( custacc, st );
			      buildstr (2+PrintFrom,9, 4, st );
			      buildstr (2+PrintFrom,14, length (custname), custname);
			      buildstr (3+PrintFrom,14, length (Add1), Add1);
			      buildstr (4+PrintFrom,14, length (Add2), Add2);
			      //buildstr (5+PrintFrom,14, length (Add3), Add3);
			      //buildstr (6+PrintFrom,14, length (Add4), Add4);

			      txnextsub := txnextsub + 1;
			      st := concat ( dash40, dash40 );
			      buildstr ( txnextsub, 1, 80, st );
			    end
			  else
			    begin
			      buildstr (2+PrintFrom,1, 9, 'ACCOUNT: ');
			      str ( custacc, st );
			      buildstr (2+PrintFrom,9, 4, st );
			      buildstr (2+PrintFrom,14, length (custname), custname);
			      buildstr (3+PrintFrom,14, length (Add1), Add1);
			      buildstr (4+PrintFrom,14, length (Add2), Add2);
			      //buildstr (5+PrintFrom,14, length (Add3), Add3);
			      //buildstr (6+PrintFrom,14, length (Add4), Add4);
                              CheckHeading;
                              (*
                              if showamt then
				//st := 'DATE     TX-NO DESC       NOM    QUAN    AMOUNT   AMT/UNIT      VAT     TOTAL'
				st := 'DATE     TX-NO DESC       NOM    QUAN    AMT/UNIT   AMOUNT      VAT     TOTAL'
			      else
				st := 'DATE     TX-NO DESCRIPTION     NOM  QUANTITY     AMOUNT        VAT      TOTAL';
			      Move ( st[1], STLINES^[6+PrintFrom][1], length ( st ));
			      *)
                              TXNEXTSUB:=7+PrintFrom;
			    End;
			  { Initialise The Sub Total Vars }
			  inv_amt := 0;
			  inv_vat := 0;
			  inv_tot := 0;
			  exclude_first := true;
			  GETITEM(FileNo,17);
			END;
    END;
    // line below sets the account starting balance for ledgers and statements
    // if a date range is selected, the string written out in BUILDSTR will be overwritten down arrouns line 1321
    RUNBAL:=CURRLONG;
    {LONGSTR(CURRLONG,ST,'L');}
    DoubleToStr ( CurrLong, St, '%10.2f', True, True, 10, True ); // tgm changed false to true to show negative
    CASE PROG OF
      CUSTSTM,SUPPSTM : IF NOT Cash2.XINVALLOC THEN
			  BEGIN
                            if ( FROMDT = CDateFrom ) then
			    // If ( period1 = 0 ) Then
			       Begin
				 open_balance := true;
				 BUILDSTR(TXNEXTSUB,STINTS^[22],12,ST);
				 BUILDSTR(TXNEXTREM,STINTS^[62],12,ST);
			       End
			     Else
				Begin
                          //	  sortfld := 2;
                          //        report_sorted := true;              TGM AB removed this sort to fix statement report sorting problems in paradox data
			  //  sort_asc := true;
				End;
			  END;
      CUSTLED,SUPPLED : IF BALBF THEN
			  Begin
			    If Device = 'S' Then
			      BUILDSTR(TXNEXTSUB,65,12,ST)
			    Else
			      BUILDSTR(TXNEXTSUB,68,12,ST);
			  End;
    END;
    (*	 taken out to clear up user comfusion about the Balance Brought forward
	 and Balance-st starting balance
    ST:='BALANCE BROUGHT FORWARD';
*)
    CASE PROG OF
      CUSTSTM,SUPPSTM : IF NOT Cash2.XINVALLOC THEN
			  BEGIN
			    ST := 'BALANCE BROUGHT FORWARD';
                            // STINTS^[ 9] is the variable storing the statement parameters for this data item
			    BUILDSTR(TXNEXTSUB,STINTS^[ 9],LENGTH(ST),ST);
			    BUILDSTR(TXNEXTREM,STINTS^[49],LENGTH(ST),ST);
			  END;
      CUSTLED,SUPPLED : IF BALBF THEN
			  Begin
			    st := 'ACCOUNT STARTING BALANCE';
			    BUILDSTR(TXNEXTSUB,1,LENGTH(ST),ST);
			  End;
    END;
    TXNEXTSUB:=TXNEXTSUB+1;
    IF TXNEXTREM>0 THEN TXNEXTREM:=TXNEXTREM+1;
    GETITEM(FileNo,7);
    ACCBALANCE:=CURRLONG;
    FOR X:=1 TO 4 DO AGEDBALS[X]:=0;
    TOTQTY:=0;
    TOTTAX:=0;
    TOTAMT:=0;
  END;

  { Procedure to print individual invoice totals }
  Procedure print_inv_totals;
  Var
    st : ShortString;
  Begin
     if PROG In [SUPPREC,CUSTREC] then
        begin
           St := '---------';
           If showamt Then
	      Begin
	         buildstr ( txnextsub, 51, 9, st );
	         buildstr ( txnextsub, 62, 9, st );
	         buildstr ( txnextsub, 71, 9, st );
              End
           Else
	      Begin
	         buildstr ( txnextsub, 48, 9, st );
	         buildstr ( txnextsub, 59, 9, st );
	         buildstr ( txnextsub, 70, 9, st );
              End;
           txnextsub := txnextsub + 1;

           DoubleToStr ( inv_amt, St, '%10.2f', True, True, 10, False );
           if showamt Then
	      buildstr ( txnextsub, 51, 10, Copy ( st, 3, 10 ))
           else
	      buildstr ( txnextsub, 48, 10, Copy ( st, 3, 10 ));
           DoubleToStr ( inv_vat, St, '%10.2f', True, True, 10, False );
           if showamt Then
	      buildstr ( txnextsub, 62, 9, Copy ( st, 4, 9 ))
           else
	      buildstr ( txnextsub, 59, 10, Copy ( st, 3,10 ));
           DoubleToStr ( inv_tot, St, '%10.2f', True, True, 10, False );
           if showamt Then
	      buildstr ( txnextsub, 70, 10, Copy ( st, 3, 10 ))
           else
	      buildstr ( txnextsub, 70, 10, Copy ( st, 3,10 ));
           TXNEXTSUB:=TXNEXTSUB+1;
        end
     else
        begin
           St := '---------';
           if StatementForm.PrintBox.ItemIndex In [0,3] then
              buildstr ( txnextsub, 49, 9, st );
           if StatementForm.PrintBox.ItemIndex = 0 then
              buildstr ( txnextsub, 59, 9, st );
           if StatementForm.PrintBox.ItemIndex In [0..2] then
              buildstr ( txnextsub, 69, 9, st );
           txnextsub := txnextsub + 1;

           // Total EX VAT
           if StatementForm.PrintBox.ItemIndex In [0,3] then
              begin
                 DoubleToStr ( inv_amt, St, '%10.2f', True, True, 10, False );
                 buildstr ( txnextsub, 48, 10, st );
              end;

           // Total VAT
           if StatementForm.PrintBox.ItemIndex = 0 then
              begin
                 DoubleToStr ( inv_vat, St, '%10.2f', True, True, 10, False );
                 buildstr ( txnextsub, 58, 10, st );
              end;

           // Total for Invoice
           if StatementForm.PrintBox.ItemIndex In [0..2] then
              begin
                 DoubleToStr ( inv_tot, St, '%10.2f', True, True, 10, False );
                 buildstr ( txnextsub, 68, 10, st );
              end;

           TXNEXTSUB:=TXNEXTSUB+1;
        end;

     st := concat ( dash40, dash40 );
     buildstr ( txnextsub, 1, 80, st );
     txnextsub := txnextsub + 1;

     { Initialise The Sub Total Vars }
     blankit := false;
     inv_amt := 0;
     inv_vat := 0;
     inv_tot := 0;
  End;

  PROCEDURE STEND;
  VAR
    ST	 : ShortSTRING;
    CALC : Double;{INTEGER[36];}
  BEGIN
    IF PROG IN [CUSTSTM,SUPPSTM] THEN PRINTAGED;

    (*
    If (( prog In [custstm, suppstm] ) And
	( period1 <> 0 ) And
	( period2 <> 0 )) Then
    *)
    if (( prog In [custstm, suppstm,custled,suppled] ) And //tgm added custled
	( FROMDT <> CDateFrom ) And
	( TODT <> CDateTo )) Then
       Begin
	 If first_pass Then
	    Begin
	       first_pass := false;
	       stopping_balance := runbal;
	    End;
	 accbalance := stopping_balance;
       End;

    {LONGSTR(ACCBALANCE,ST,'L');}
    DoubleToStr ( AccBalance, St, '%10.2f', True, True, 10, TRUE );
    CASE PROG OF
      CUSTSTM,SUPPSTM : BEGIN
			  BUILDSTR(STINTS^[24],STINTS^[22],12,ST);
			  BUILDSTR(STINTS^[64],STINTS^[62],12,ST);
			END;
      CUSTLED,SUPPLED : BEGIN
			  If Device = 'S' Then
			    BUILDSTR(TXNEXTSUB+2,65,12,ST)
			  Else
			    BUILDSTR(TXNEXTSUB+2,68,12,ST);
			  ST:='CURRENT BALANCE';
			  BUILDSTR(TXNEXTSUB+2,1,LENGTH(ST),ST);
			END;
      CUSTREC,SUPPREC : BEGIN
			  if TotalGrp then		(* accumulate totals *)
			     Begin
			       grp_accs^[grp_read].tottax := tottax;
			       grp_accs^[grp_read].totamt := totamt;
			       grp_accs^[grp_read].total  := tottax + totamt;
			       grp_accs^[grp_read].quantity := totqty;
			     End;
			  If ( prog In [custrec,supprec] ) And
			     ( sub_total_inv ) Then
			     Begin
				txnextsub := txnextsub + 1;
				print_inv_totals;
			     End;

			  {LONGSTR (TOTQTY,ST,'L');}
                          DoubleToStr ( TotQty, St, '%10.2f', True, True, 10, True );
			  IF SHOWAMT THEN
                            BUILDSTR(TXNEXTSUB+2,29, 10,COPY(ST,2,10 ))
                          ELSE
                            BUILDSTR(TXNEXTSUB+2,36,11,COPY(ST,2,10));      // TGM AB was BUILDSTR(TXNEXTSUB+2,37,10,COPY(ST,3,10));
                          DoubleToStr ( TotAmt, St, '%10.2f', True, True, 10, True );
			  IF SHOWAMT
			    THEN BUILDSTR(TXNEXTSUB+2,51, 10,COPY(ST,3,10{9}))
			    ELSE BUILDSTR(TXNEXTSUB+2,47,11,COPY(ST,2,10));    // TGM AB was BUILDSTR(TXNEXTSUB+2,48,10,COPY(ST,3,10));
			  (*IF SHOWAMT
			    THEN BUILDSTR(TXNEXTSUB+2,40{45}, 10{9},COPY(ST,3,10{9}))
			    ELSE BUILDSTR(TXNEXTSUB+2,48,10,COPY(ST,3,10));*)
			  IF SHOWAMT THEN
			    BEGIN
			      CALC:=TOTAMT;
			      IF TOTQTY=0 THEN
                                 CALC:=0
                              ELSE
                                  CALC:=( CALC / TOTQTY );
                              CurrDbl := Calc;
                              DoubleToStr(CurrDbl, ST, '%f', True, False, 11, False );
                              {LONGSTR(CURRLONG,ST,'L');}
			      if showamt then
				//buildstr ( txnextsub+2, 51, 9, copy ( st, 4, 9 ))
				buildstr ( txnextsub+2, 40, 9, copy ( st, 4, 9 ))
			      else
				BUILDSTR(TXNEXTSUB+2,54, 9,COPY(ST,4, 9));
			    END;
                          DoubleToStr(TotTax, ST, '%f', True, True, 11, True );
			  {LONGSTR (TOTTAX,ST,'L');}
			  IF SHOWAMT
			    THEN BUILDSTR(TXNEXTSUB+2,61, 9,COPY(ST,4, 9))
			    ELSE BUILDSTR(TXNEXTSUB+2,58{59},10,COPY(ST,3,10));
                          DoubleToStr(TotAmt+TotTax, ST, '%f', True, True, 11, True );
			  {LONGSTR (TOTAMT+TOTTAX,ST,'L');}
			  IF SHOWAMT
			    THEN BUILDSTR(TXNEXTSUB+2,69, 10,COPY(ST,3, 10))
			    ELSE BUILDSTR(TXNEXTSUB+2,69{70},10,COPY(ST,3,10));

			  {* if not page feeding then add to txnetsub }
			  If ( NOT ThrowPage ) Then
			     txnextsub := txnextsub + 4;
			END;
      CUSTSUM,SUPPSUM : BEGIN
			  if TotalGrp then		(* accumulate totals *)
			     Begin
			       grp_accs^[grp_read].tottax := tottax;
			       grp_accs^[grp_read].totamt := totamt;
			       grp_accs^[grp_read].total  := tottax + totamt;
			       grp_accs^[grp_read].quantity := totqty;
			     End;
			  if ( sub_total_inv ) Then
			     Begin
				txnextsub := txnextsub + 1;
				print_inv_totals;
			     End;

                          LineForTotals := TxNextSub+2;
                          BUILDSTR(TXNEXTSUB+2,41,6,'TOTALS');
                          //BUILDSTR(TXNEXTSUB+2,40,6,'TOTALS');    // TGM AB
                          // Total EX Vat
                          if StatementForm.PrintBox.ItemIndex In [0,2,3] then
                             begin
                                DoubleToStr(TotAmt, ST, '%10.2f', True, True, 10, True );
                                BUILDSTR(TXNEXTSUB+2,48,10,ST);
                             end;
                          // Total Tax
                          if StatementForm.PrintBox.ItemIndex In [0,2,3] then
                             begin
                                DoubleToStr(TotTax, ST, '%10.2f', True, True, 10, True );
                                BUILDSTR(TXNEXTSUB+2,58,10,ST);
                             end;
                          // Total Amount
                          if StatementForm.PrintBox.ItemIndex In [0..3] then
                             begin
                                DoubleToStr ( TotAmt+TotTax, St, '%10.2f', True, True, 10, True );
                                BUILDSTR(TXNEXTSUB+2,68,10,ST);
                             end;

			  {* if not page feeding then add to txnetsub }
			  If ( NOT ThrowPage ) Then
			     txnextsub := txnextsub + 4;
			END;
    END;
  END;


  PROCEDURE TXSTART (VAR TXT: INTEGER);    // TGM AB  - this looks at the TxFile as determined earlier
  VAR
    local_amt : long;
    curr_date,
    ORIG : INTEGER;
    st	 : ShortString;
  BEGIN
    txt := 0;
    Curr_date := 0;
    SETDB(TxFile);
    IF (TXPOINTER<1) OR (TXPOINTER>DB1.DBRECTOT) THEN
       Begin
           ExitProcessTxs := True;
           EXIT;
       End;

    READREC(TxFile,TXPOINTER);
    GETITEM(TxFile,1);
    TXT:=CURRINT;
    GETITEM(TxFile,23);
    ORIG:=CURRINT;
    IF PROG IN [CUSTSTM,CUSTLED,SUPPSTM,SUPPLED] THEN
      BEGIN
	if report_sorted then
	  next_sort_rec ( txpointer )
	else
	  Begin
	    GETITEM(TxFile,16);
	    TXPOINTER:=CURRINT;
	  End;
      END
    ELSE
      BEGIN
	IF (TXT=ORIG)
	OR ((PROG In [CUSTREC,CUSTSUM]) AND (ORIG<>1))
	OR ((PROG In [SUPPREC,SUPPSUM]) AND (ORIG<>5)) THEN
	  BEGIN
	    TXPOINTER:=TXSAVE;
	    IF (TXPOINTER<1) OR (TXPOINTER>DB1.DBRECTOT) THEN
               Begin
                    ExitProcessTxs := True;
                    EXIT;
               End;
	    READREC(TxFile,TXPOINTER);
	    GETITEM(TxFile,1);
	    TXT:=CURRINT;
	    GETITEM(TxFile,23);
	    ORIG:=CURRINT;

	    { if sorting then read the next record from the sort file }
	    if report_sorted then
	      next_sort_rec ( txsave )
	    else
	      { else use the record pointer }
	      Begin
		GETITEM(TxFile,16);
		TXSAVE:=CURRINT;
	      End;
	  END;
	TXPOINTER:=TXPOINTER+1;
      END;

    { If its not the first pass check if you need to output next line as sub }
    If NOT exclude_first Then
      If NOT blankit Then
	blankit := (( prog In [custrec,CUSTSUM] ) And ( txt = 1 )) Or
		   (( prog In [supprec,SUPPSUM] ) And ( txt = 5 ));

    GETITEM(TxFile,28);
    IF CURRDISP[1] IN ['E','R'] THEN
       Begin
           ExitProcessTxs := True;
           EXIT;
       End;
    IF PROG IN [CUSTSTM,CUSTLED] THEN
      IF NOT(TXT IN [1..4]) THEN
         Begin
              ExitProcessTxs := True;
              EXIT;
         End;

    IF PROG IN [SUPPSTM,SUPPLED] THEN
      IF NOT(TXT IN [5..8]) THEN
         Begin
           ExitProcessTxs := True;
           EXIT;
         End;

    {* allow statements filtered by date }
    IF PROG IN [CUSTLED,SUPPLED,CUSTREC,SUPPREC,CUSTSUM,SUPPSUM, suppstm, custstm ] THEN
      BEGIN
	GETITEM(TxFile,2);
	curr_date := currint;
	If prog In [custrec, supprec,SUPPSUM,CUSTSUM] Then // custled, suppled, removed by tgm
	  If (CURRINT<FROMDT) OR (CURRINT>TODT) THEN
             Begin
                  ExitProcessTxs := True;
                  EXIT;
             End;
      END;
    IF PROG IN [CUSTREC,SUPPREC,SUPPSUM,CUSTSUM] THEN
      BEGIN
	GETITEM(TxFile,12);
	IF (CURRINT<StatementForm.SCHANALF) OR (CURRINT>StatementForm.SCHANALT) THEN
           Begin
                ExitProcessTxs := True;
                EXIT;
           End;
      END;
    IF PROG In [CUSTREC,CUSTSUM] THEN
      IF (ORIG<>1) OR (TXT<>9) THEN
         Begin
              ExitProcessTxs:=True; { processtxs }
              Exit;
         End;
    IF PROG In [SUPPREC,SUPPSUM] THEN
      IF (ORIG<>5) OR (TXT<>9) THEN
         Begin
              ExitProcessTxs:=True; { processtxs }
              Exit;
         End;
    IF PROG IN [CUSTREC,SUPPREC,SUPPSUM,CUSTSUM] THEN
      BEGIN
     	GETITEM (TxFile,8);
	IF (CURRINT<SCHRECF) OR (CURRINT>SCHRECT) THEN
           Begin
                ExitProcessTxs := True;
                EXIT;
           End;
     END;
    ALLOC:=FALSE;
    IF Cash2.XINVALLOC THEN
      IF PROG IN [CUSTSTM,SUPPSTM,custled,suppled] THEN // custled added by tgm
	IF (CURRREC[TxFile]<FIRSTTX) OR (FIRSTTX=0) THEN
	  BEGIN
	    IF NOT (TXT IN [1,5]) THEN
               Begin
                    ExitProcessTxs := True;
                    EXIT;
               End;
	    GETITEM (TxFile,30);
	    IF CURRDISP[1]='Y' THEN
               Begin
                    ExitProcessTxs := True;
                    EXIT;
               End;
	    ALLOC:=TRUE;
	  END;

    If (( Prog In [custstm, suppstm,custled,suppled] ) And
	( curr_date < fromdt ) Or ( curr_date > todt )) Then
      Begin
	if (( curr_date > todt ) and ( first_pass )) then
	   begin
	     first_pass := false;
	     stopping_balance := runbal;
	   end;
	{ Accumulate the opening balance for this account }
	GETITEM(TxFile,9);
	local_amt:=CURRLONG;
	GETITEM(TxFile,11);
	local_amt:=local_amt+CURRLONG;
	IF Cash2.XINVALLOC THEN
	  IF PROG IN [CUSTSTM,SUPPSTM,custled,suppled] THEN // custled added by tgm
	    IF ALLOC THEN
	      BEGIN
		GETITEM (TxFile,29);
		local_amt:=local_amt-CURRLONG;
	      END;
	CASE TXT OF
	  1,3,4,5,7,8 : RUNBAL:=RUNBAL+local_amt;
	  2,6	      : RUNBAL:=RUNBAL-local_amt;
	END;
        ExitProcessTxs := True;
        EXIT;
      End
    Else
      Begin  // the section below adjust the opening balance for both ledgers and statements if a date rangee
             // has been specified. GM added the custled and suppled bits 01/05/02
             // Open_Balance is a flag to indicate that the opening balance figure has been altered.
             // I'm not quite sure why open_balance is set to true - it must be set to false again elswhere
             // if the trans date of the next tx is less than the starting date
	If (( Prog In [custstm, suppstm,custled,suppled] ) And ( NOT open_balance )) Then // custled,suppled added by tgm
	  Begin
	    Open_Balance := true;
	    {LONGSTR( runbal, ST, 'L');}
            DoubleToStr ( RunBal, St, '%10.2f', True, True, 10, True ); //False );
            // tgm added the custled bit below
            if (prog in [custled,suppled]) then begin
               BUILDSTR(TXNEXTSUB-1,68,12,ST);
            end else begin
	       BUILDSTR(TXNEXTSUB-1,STINTS^[22],12,ST);
	       BUILDSTR(TXNEXTREM-1,STINTS^[62],12,ST);
            end;
	  End;
	TXNEXTSUB:=TXNEXTSUB+1;
	IF TXNEXTREM>0 THEN TXNEXTREM:=TXNEXTREM+1;
      End;
  END;

  PROCEDURE PROCESSTXS;
  VAR
    ST	  : ShortSTRING;
    AMT	  : LONG;
    PAMT  : LONG;
    LinesAdded,
    TXT	  : INTEGER;
    discounted,
    DBCOL : BOOLEAN;
    SUB	  : INTEGER;
    disp_disc_amt,
    disc_amt,
    VatAmt,
    QUAN  : LONG;
    CALC  : Double;

  BEGIN
    discounted := false;
    SETDB(TxFile);
    IF (TXPOINTER<1) OR (TXPOINTER>DB1.DBRECTOT) THEN EXIT;
    TXSTART(TXT);
    If ExitProcessTxs Then Exit;

    { if its record cards and the user wants sub-totals, print sub }
    If ( prog In [custrec,supprec,SUPPSUM,CUSTSUM] ) And ( sub_total_inv ) Then
      If blankit And ( NOT exclude_first ) Then
	 print_inv_totals;
    IF PROG IN [CUSTSTM,SUPPSTM] THEN
      IF ((TXNEXTSUB>STINTS^[ 7]-1) AND (STINTS^[ 7]>0))
      OR ((TXNEXTREM>STINTS^[47]-1) AND (STINTS^[47]>0)) THEN
	BEGIN
	  ST:='CONTINUED OVER ...';
	  BUILDSTR(STINTS^[ 7],STINTS^[ 9],LENGTH(ST),ST);
	  BUILDSTR(STINTS^[47],STINTS^[49],LENGTH(ST),ST);
	  PRINTSTATEMENT;
	  BLANKSTATEMENT;
	  ST:='CONTINUED ...';
	  BUILDSTR(STINTS^[ 6],STINTS^[ 9],LENGTH(ST),ST);
	  BUILDSTR(STINTS^[46],STINTS^[49],LENGTH(ST),ST);
	  TXNEXTSUB:=STINTS^[6]+1;
	  IF STINTS^[46]=0
	    THEN TXNEXTREM:=0
	    ELSE TXNEXTREM:=STINTS^[46]+1;
	END;
    If PROG In [CUSTLED,SUPPLED,CUSTREC,SUPPREC,SUPPSUM,CUSTSUM] Then
      Begin
        // Double space the lines
        if ( PROG In [CUSTSUM,SUPPSUM] ) And ( DoubleSpace ) then
           TXNEXTSUB:=TXNEXTSUB+1;

	if TXNEXTSUB>RFarmGate.PLINESPAGE[1]- 7 then  // TGM CHANGED 5 TO 7
	  begin
	    {ST:='CONTINUED OVER ...';
	    If Device = 'S' Then
	       BUILDSTR (65,1,LENGTH(ST),ST)
	    Else
	       BUILDSTR (txnextsub+2,1,LENGTH(ST),ST);}
	    PRINTSTATEMENT;
	    BLANKSTATEMENT;
	    //ST:='CONTINUED ...';
	    TXNEXTSUB:=9+PrintFrom;
	    //BUILDSTR (TXNEXTSUB,1,LENGTH(ST),ST);
	    TXNEXTSUB:=TXNEXTSUB+1;

	  END;
      End;
    SETDB(TxFile);
    { Check if discount line }
    If ( Prog In [custstm, suppstm, custled, suppled] ) And ( txt In [2,6] ) Then
	Begin
	   getitem ( TxFile, 11 );  { get discount amt }
	   discounted := (currlong <> 0);
	  End;
    CASE PROG OF
      CUSTSTM,
      SUPPSTM : BEGIN
		  FOR SUB:=1 TO 10 DO
		    IF STINTS^[(SUB*2)+129] IN [1..32] THEN
		      IF DB1.DBITEMS[STINTS^[(SUB*2)+129]].DBINAME<>'' THEN
			BEGIN
			  IF (STINTS^[(SUB*2)+129]=5) AND (TXT IN [2,6]) THEN
			    BEGIN
			      SETITEM;
			      CASE TXT OF
				2 : CURRSTR:='RECEIPT';
				6 : CURRSTR:='PAYMENT';
			      END;
			      CURRSIZE:=LENGTH(CURRSTR);
			      Move (CURRSTR[1],CURRDISP[1],CURRSIZE);
			    END
			  ELSE
			    GETITEM(TxFile,STINTS^[(SUB*2)+129]);
			  BUILDITEM(TXNEXTSUB,STINTS^[130+(SUB*2)]);
			  BUILDITEM(TXNEXTREM,STINTS^[130+(SUB*2)]);
			  If ( txt In [2,6] ) And discounted Then
			     Begin
				IF (STINTS^[(SUB*2)+129]=5) AND (TXT IN [2,6]) THEN
				  BEGIN
				    SETITEM;
				    CURRSTR:='DISCOUNT';
				    CURRSIZE:=LENGTH(CURRSTR);
				    Move (CURRSTR[1],CURRDISP[1],CURRSIZE);
				  END;
				BUILDITEM(TXNEXTSUB+1,STINTS^[130+(SUB*2)]);
				If ( TXNEXTREM <> 0 ) Then
				   BUILDITEM(TXNEXTREM+1,STINTS^[130+(SUB*2)]);
			     End;
			END;
		  CASE TXT OF
		    1,5 : BUILDSTR(TXNEXTSUB,STINTS^[23],3,'INV');
		    2,6 : Begin
			     BUILDSTR(TXNEXTSUB,STINTS^[23],3,'PAY');
			     If discounted Then
				BUILDSTR(TXNEXTSUB+1,STINTS^[23],3,'DIS');
			  End;
		    3,7 : BUILDSTR(TXNEXTSUB,STINTS^[23],3,'CRN');
		  END;
		  CASE TXT OF
		    1,5 : BUILDSTR(TXNEXTREM,STINTS^[63],3,'INV');
		    2,6 : Begin
			     BUILDSTR(TXNEXTREM,STINTS^[63],3,'PAY');
			     If discounted And ( TXNEXTREM <>0 ) Then
				{BUILDSTR(TXNEXTSUB+1,STINTS[23],3,'DIS');}
				BUILDSTR(TXNEXTREM+1,STINTS^[23],3,'DIS');
			  End;
		    3,7 : BUILDSTR(TXNEXTREM,STINTS^[63],3,'CRN');
		  END;
		END;
      CUSTLED,
      SUPPLED : BEGIN
		  GETITEM(TxFile,2);
		  BUILDITEM(TXNEXTSUB,1);
		  If ( txt In [2,6] ) And discounted Then
		     BUILDITEM(TXNEXTSUB+1,1);
		  GETITEM(TxFile,4);
		  BUILDITEM(TXNEXTSUB,20);
		  If ( txt In [2,6] ) And discounted Then
		     BUILDITEM(TXNEXTSUB+1,20);
		  IF TXT IN [2,6] THEN
		    BEGIN
		      SETITEM;
		      CASE TXT OF
			2 : CURRSTR:='RECEIPT';
			6 : CURRSTR:='PAYMENT';
		      END;
		      CURRSIZE:=LENGTH(CURRSTR);
		      Move (CURRSTR[1],CURRDISP[1],CURRSIZE);
		    END
		  ELSE
//tgm
		    GETITEM(TxFile,5);
		  BUILDITEM(TXNEXTSUB,30);
		  If ( txt In [2,6] ) And discounted Then
		     Begin
			SETITEM;
			CURRSTR:='DISCOUNT';
			CURRSIZE:=LENGTH(CURRSTR);
			Move (CURRSTR[1],CURRDISP[1],CURRSIZE);
//tgm line below was 29
			BUILDITEM(TXNEXTSUB+1, 30 );
		     End;
		  CASE TXT OF
		    1,5 : BUILDSTR(TXNEXTSUB,16,3,'INV');
		    2,6 : Begin
			     BUILDSTR(TXNEXTSUB,16,3,'PAY');
			     If discounted Then
				BUILDSTR(TXNEXTSUB+1, 16, 3,'DIS');
			  End;
		    3,7 : BUILDSTR(TXNEXTSUB,16,3,'CRN');
		  END;
		  STR (CURRREC[TxFile],ST);
		  WHILE LENGTH(ST)<5 DO ST:=CONCAT(SPACE1,ST);
		  BUILDSTR(TXNEXTSUB,10,5,ST);
		  If ( txt In [2,6] ) And discounted Then
		     BUILDSTR(TXNEXTSUB+1,10,5,ST);
		END;
      CUSTREC,
      SUPPREC : BEGIN
		  { ** 15-04-94 changed the layout of the line to expand the
		       no of digits displayed for the Amounts }
		  { 22/04/96 store sub-totals }
		  GETITEM(TxFile,2);
		  BUILDITEM(TXNEXTSUB,1);
		  GETITEM(TxFile,DESCFLD);
		  If showamt Then
		    Begin
		      IF CURRSIZE>10 THEN CURRSIZE:=10;
		    End
		  Else
		    If currsize > 15 Then currsize := 15;

		  BUILDITEM(TXNEXTSUB, 16 );
		  GETITEM(TxFile,8);
		  STR (CURRINT,ST);
		  WHILE LENGTH(ST)<3{4} DO ST:=CONCAT(SPACE1,ST);
		  If showamt then
		    BUILDSTR ( TXNEXTSUB, 27, 3, ST )
		  Else
		    buildstr ( txnextsub, 32, 3, st );
		  GETITEM(TxFile,6);
		  QUAN:=CURRLONG;

		  {LONGSTR(CURRLONG,ST,'L');}
                  DoubleToStr ( CurrLong, St, '%10.2f', True, True, 10, True );
		  IF SHOWAMT THEN
		     BUILDSTR(TXNEXTSUB,31, 8,COPY(ST,4, 8))
		  ELSE
		     BUILDSTR(TXNEXTSUB,36,11,COPY(ST,2,10));       // TGM AB  was BUILDSTR(TXNEXTSUB,37,10,COPY(ST,3,10));
		  TOTQTY:=TOTQTY+CURRLONG;
		  GETITEM(TxFile,9);
		  {LONGSTR(CURRLONG,ST,'L');}
                  DoubleToStr ( CurrLong, St, '%10.2f', True, True, 10, true );
		  inv_amt := inv_amt + currlong;

		  {
                  IF SHOWAMT THEN
                     BUILDSTR(TXNEXTSUB,40, 10,COPY(ST,3, 10))
                  ELSE
                     BUILDSTR(TXNEXTSUB,48,10,COPY(ST,3,10));
		  }
                  IF SHOWAMT THEN
                     BUILDSTR(TXNEXTSUB,51, 10,COPY(ST,3, 10))
                  ELSE
                     BUILDSTR(TXNEXTSUB,47,11,COPY(ST,2,10));  // TGM AB was BUILDSTR(TXNEXTSUB,48,10,COPY(ST,3,10));
		  AMT	:=CURRLONG;
		  TOTAMT:=TOTAMT+AMT;
		  IF SHOWAMT THEN
		    BEGIN
		      CALC:=AMT;
		      IF QUAN=0 Then
                         CALC:=0
                      Else
                          CALC:=( CALC / QUAN );
                      DoubleToStr ( Calc, St, '%f', true, False, 11, True );
		      BUILDSTR(TXNEXTSUB, 40, 9,COPY(ST,4, 9));
		      //BUILDSTR(TXNEXTSUB, 51, 9,COPY(ST,4, 9));
		    END;
		  GETITEM(TxFile,11);
		  {LONGSTR(CURRLONG,ST,'L');}
                  DoubleToStr ( CurrLong, St, '%10.2f', True, True, 10, true );

		  IF SHOWAMT
		    THEN BUILDSTR(TXNEXTSUB,62{63}, 9,COPY(ST,4, 9))
		    ELSE BUILDSTR(TXNEXTSUB,58,11,COPY(ST,2,10));       // TGM AB was BUILDSTR(TXNEXTSUB,59,10,COPY(ST,3,10));
		  AMT	:=AMT	+CURRLONG;
		  inv_vat := inv_vat + currlong;
		  inv_tot := inv_tot + amt;

		  TOTTAX:=TOTTAX+CURRLONG;
		  {LONGSTR(AMT,ST,'L');}
                  DoubleToStr ( Amt, St, '%10.2f', True, True, 10, True );
		  IF SHOWAMT
		    THEN BUILDSTR(TXNEXTSUB,70{71}, 10,COPY(ST,3, 10))
		    ELSE BUILDSTR(TXNEXTSUB,69,11,COPY(ST,2,10));  // TGM AB was BUILDSTR(TXNEXTSUB,70,10,COPY(ST,3,10));
		  STR (CURRREC[TxFile],ST);
		  WHILE LENGTH(ST)<5 DO ST:=CONCAT(SPACE1,ST);
		  BUILDSTR(TXNEXTSUB,10,5,ST);
		  exclude_first := false;	{ reset exclude first }
		END;
      CUSTSUM,
      SUPPSUM : BEGIN
		  GETITEM(TxFile,2);
		  BUILDITEM(TXNEXTSUB,1);
		  GETITEM(TxFile,DESCFLD);
                  If CURRSIZE > 22 Then CURRSIZE := 22;
		  BUILDITEM(TXNEXTSUB, 10 );

                  // try and get the extra details for this TX
                  try
                      LinesAdded := 0;
                      if AccsDataModule.ProdsTx.Locate('TxNo',TxPointer-1,[] ) then
                         begin
                            // If there is a product associated print this instead of the
                            // Nominal description
                            if NOT AccsDataModule.ProdsTx.FieldByName('Desc1').IsNull then
		               begin
                                  St := AccsDataModule.ProdsTx.FieldByName('Desc1').AsString;
                                  BUILDSTR(TXNEXTSUB,10,22,ST);
                                  // Inc(LinesAdded);
                               end;
                            if NOT AccsDataModule.ProdsTx.FieldByName('Desc2').IsNull then
		               begin
                                  St := AccsDataModule.ProdsTx.FieldByName('Desc2').AsString;
                                  BUILDSTR(TXNEXTSUB+1,10,22,ST);
                                  Inc(LinesAdded);
                               end;
                            if NOT AccsDataModule.ProdsTx.FieldByName('Desc3').IsNull then
		               begin
                                  St := AccsDataModule.ProdsTx.FieldByName('Desc3').AsString;
                                  BUILDSTR(TXNEXTSUB+2,10,22,ST);
                                  Inc(LinesAdded);
                               end;
                         end;
                  except

                  end;

		  // Quantity
                  GETITEM(TxFile,6);
		  QUAN:=CURRLONG;
                  DoubleToStr ( CurrLong, St, '%8.2f', True, True, 8, True );
                  BUILDSTR(TXNEXTSUB,33,8,ST);
		  TOTQTY:=TOTQTY+CURRLONG;

                  // Amount EX VAT
		  GETITEM(TxFile,9);
                  DoubleToStr ( CurrLong, St, '%10.2f', True, True, 10, true );
		  inv_amt := inv_amt + currlong;
                  // if PRINTTYPE <> 2 then
                  if StatementForm.PrintBox.ItemIndex In [0,3] then
                     BUILDSTR(TXNEXTSUB,48,10,ST);
		  AMT	:=CURRLONG;
		  TOTAMT:=TOTAMT+AMT;

		  IF SHOWAMT THEN
		    BEGIN
		      CALC:=AMT;
		      IF QUAN=0 Then
                         CALC:=0
                      Else
                          CALC:=( CALC / QUAN );
                      DoubleToStr ( Calc, St, '%7.2f', true, False, 7, True );
		      BUILDSTR(TXNEXTSUB, 40, 7, ST );
		    END;

                  // Vat Amount
		  GETITEM(TxFile,11);
                  DoubleToStr ( CurrLong, St, '%10.2f', True, True, 10, true );
                  if StatementForm.PrintBox.ItemIndex = 0 then
                  // if PRINTTYPE = 1 then
                     BUILDSTR(TXNEXTSUB,58,10,ST);
                  VatAmt := CurrLong;

                  // Price EX VAT
                  DoubleToStr ( AMT+VatAmt, St, '%10.2f', True, True, 10, true );
                  if StatementForm.PrintBox.ItemIndex In [0,1,2] then
                  // if PRINTTYPE <> 3 then
                     BUILDSTR(TXNEXTSUB,68,10,ST);

		  // Accumulate the Totals
                  AMT:=AMT+VatAmt;

		  inv_vat := inv_vat + VatAmt;
		  inv_tot := inv_tot + amt;

		  TOTTAX:=TOTTAX+VatAmt;
		  exclude_first := false;	{ reset exclude first }
                  // ??
                  TxNextSub := TxNextSub+LinesAdded;
		END;
    END;
    IF NOT (PROG IN [CUSTREC,SUPPREC,SUPPSUM,CUSTSUM]) THEN
      BEGIN
	GETITEM(TxFile,9);
	AMT:=CURRLONG;
	GETITEM(TxFile,11);
	If ( txt In [2,6] ) And discounted Then	 { Store the Discount Amount }
	   Begin
	      disc_amt := currlong;
	      disp_disc_amt := disc_amt;
	      If disp_disc_amt < 0 Then disp_disc_amt := 0-disp_disc_amt;
	   End
	Else
	   Begin
	      disp_disc_amt := 0;
	      disc_amt := 0;
	      AMT := AMT+CURRLONG;
	   End;

	IF Cash2.XINVALLOC THEN
	  IF PROG IN [CUSTSTM,SUPPSTM] THEN
	    IF ALLOC THEN
	      BEGIN
		GETITEM (TxFile,29);
		AMT:=AMT-CURRLONG;
	      END;
	CASE TXT OF
	  1,3,4,5,7,8 : RUNBAL:=RUNBAL+AMT;
	  2,
	  6	      : RUNBAL:=RUNBAL-AMT;
	END;
	DBCOL:=FALSE;
	IF PROG IN [CUSTSTM,CUSTLED] THEN
	  IF ((TXT IN [1,3,4]) AND NOT(AMT<0)) OR ((TXT=2) AND (AMT<0)) THEN
	    DBCOL:=TRUE;
	IF PROG IN [SUPPSTM,SUPPLED] THEN
	  IF ((TXT IN [5,7,8]) AND NOT(AMT<0)) OR ((TXT=6) AND (AMT<0)) THEN
	    DBCOL:=TRUE;
	PAMT:=AMT;
	IF PAMT<0 THEN PAMT:=0-PAMT;
	{LONGSTR(PAMT,ST,'L');}
        DoubleToStr ( PAmt, St, '%10.2f', True, True, 10, TRUE );
	IF PROG IN [CUSTLED,SUPPLED] THEN ST:=COPY(ST,2,11);
	CASE PROG OF
	  CUSTSTM : BEGIN
		      IF DBCOL THEN
			 Begin
			    BUILDSTR(TXNEXTSUB,STINTS^[20],12,ST);
			    If ( txt In [2,6] ) And discounted Then
			       Begin
				  {LONGSTR(disp_disc_amt,ST,'L');}
                                  DoubleToStr ( Disp_Disc_amt, St, '%10.2f', True, True, 10, False );
				  BUILDSTR(TXNEXTSUB+1,STINTS^[20],12,ST);
			       End;
			 End
		      ELSE
			 Begin
			    BUILDSTR(TXNEXTSUB,STINTS^[21],12,ST);
			    If ( txt In [2,6] ) And discounted Then
			       Begin
				  {LONGSTR(disp_disc_amt,ST,'L');}
                                  DoubleToStr ( Disp_Disc_amt, St, '%10.2f', True, True, 10, False );
				  BUILDSTR(TXNEXTSUB+1,STINTS^[21],12,ST);
			       End;
			 End;
		      IF DBCOL THEN
			 Begin
			    BUILDSTR(TXNEXTREM,STINTS^[60],12,ST);
			    If ( txt In [2,6] ) and discounted Then
			       Begin
				  {LONGSTR(disp_disc_amt,ST,'L');}
                                  DoubleToStr ( Disp_Disc_amt, St, '%10.2f', True, True, 10, False );
				  If TXNEXTREM <> 0 Then
				     BUILDSTR(TXNEXTREM+1,STINTS^[60],12,ST);
			       End;
			 End
		      ELSE
			 Begin
			    BUILDSTR(TXNEXTREM+1,STINTS^[61],12,ST);
			    If ( txt In [2,6] ) And discounted Then
			       Begin
				  {LONGSTR(disp_disc_amt,ST,'L');}
                                  DoubleToStr ( Disp_Disc_amt, St, '%10.2f', True, True, 10, False );
				  If TXNEXTREM <> 0 Then
				     BUILDSTR(TXNEXTREM+1,STINTS^[61],12,ST);
			       End;
			 End;
		    END;
	  CUSTLED : BEGIN
		      IF DBCOL THEN
			 If Device = 'S' Then
			    Begin
			       BUILDSTR(TXNEXTSUB,44,11,ST);
			       If ( txt In [2,6] ) And discounted Then
				  Begin
				     {LONGSTR(disp_disc_amt,ST,'L');}
                                     DoubleToStr ( Disp_Disc_Amt, St, '%10.2f', True, True, 10, False );
				     ST:=COPY(ST,2,11);
				     BUILDSTR(TXNEXTSUB+1,44,11,ST);
				  End;
			    End
			 Else
			    Begin
			       BUILDSTR(TXNEXTSUB,45,11,ST);
			       If ( txt In [2,6] ) And discounted Then
				  Begin
				     {LONGSTR(disp_disc_amt,ST,'L');}
                                     DoubleToStr ( Disp_Disc_Amt, St, '%10.2f', True, True, 10, False );
				     ST:=COPY(ST,2,11);
				     BUILDSTR(TXNEXTSUB+1,45,11,ST);
				  End;
			    End
		      ELSE
			 If Device = 'S' Then
			    Begin
			       BUILDSTR(TXNEXTSUB,54{7},11,ST);
			       If ( txt In [2,6] ) And discounted Then
				  Begin
                                     DoubleToStr ( Disp_Disc_amt, St, '%10.2f', True, True, 10, False );
				     {LONGSTR(disp_disc_amt,ST,'L');}
				     ST:=COPY(ST,2,11);
				     BUILDSTR(TXNEXTSUB+1,54,11,ST);
				  End;
			    End
			 Else
			    Begin
			       BUILDSTR(TXNEXTSUB,57,11,ST);
			       If ( txt In [2,6] ) And discounted Then
				  Begin
                                     DoubleToStr ( Disp_Disc_Amt, St, '%10.2f', True, True, 10, False );
				     {LONGSTR(disp_disc_amt,ST,'L');}
				     ST:=COPY(ST,2,11);
				     BUILDSTR(TXNEXTSUB+1,57,11,ST);
				  End;
			    End;
		    END;
	  SUPPSTM : BEGIN
		      IF DBCOL THEN
			 Begin
			    BUILDSTR(TXNEXTSUB,STINTS^[21],12,ST);
			    If ( txt In [2,6] ) And discounted Then
			       Begin
                                  DoubleToStr ( Disp_Disc_Amt, St, '%10.2f', True, True, 10, False );
				  {LONGSTR(disp_disc_amt,ST,'L');}
				  BUILDSTR(TXNEXTSUB+1,STINTS^[21],12,ST);
			       End;
			 End
		      ELSE
			 Begin
			    BUILDSTR(TXNEXTSUB,STINTS^[20],12,ST);
			    If ( txt In [2,6] ) And discounted Then
			       Begin
                                  DoubleToStr ( Disp_Disc_Amt, St, '%10.2f', True, True, 10, False );
				  {LONGSTR(disp_disc_amt,ST,'L');}
				  BUILDSTR(TXNEXTSUB+1,STINTS^[20],12,ST);
			       End;
			 End;
		      IF DBCOL THEN
			 Begin
			    BUILDSTR(TXNEXTREM,STINTS^[61],12,ST);
			    If ( txt In [2,6] ) And discounted Then
			       Begin
                                  DoubleToStr ( Disp_Disc_amt, St, '%10.2f', True, True, 10, False );
				  {LONGSTR(disp_disc_amt,ST,'L');}
				  If TXNEXTREM <> 0 Then
				     BUILDSTR(TXNEXTREM+1,STINTS^[61],12,ST);
			       End;
			 End
		      ELSE
			 Begin
			    BUILDSTR(TXNEXTREM,STINTS^[60],12,ST);
			    If ( txt In [2,6] ) And discounted Then
			       Begin
                                  DoubleToStr ( Disp_Disc_Amt, St, '%10.2f', True, True, 10, False );
				  {LONGSTR(disp_disc_amt,ST,'L');}
				  If TXNEXTREM <> 0 Then
				     BUILDSTR(TXNEXTREM+1,STINTS^[60],12,ST);
			       End;
			 End;
		    END;
	  SUPPLED : BEGIN
		      IF DBCOL THEN
			Begin
			  If Device = 'S' Then
			    Begin
			       BUILDSTR(TXNEXTSUB,54{7},11,ST);
			       If ( txt In [2,6] ) And discounted Then
				  Begin
                                     DoubleToStr ( Disp_Disc_Amt, St, '%10.2f', True, True, 10, False );
				     {LONGSTR(disp_disc_amt,ST,'L');}
				     ST:=COPY(ST,2,11);
				     BUILDSTR(TXNEXTSUB+1,54,11,ST);
				  End;
			    End
			  Else
			    Begin
			       BUILDSTR(TXNEXTSUB,57,11,ST);
			       If ( txt In [2,6] ) And discounted Then
				  Begin
                                     DoubleToStr ( Disp_Disc_Amt, St, '%10.2f', True, True, 10, False );
				     {LONGSTR(disp_disc_amt,ST,'L');}
				     ST:=COPY(ST,2,11);
				     BUILDSTR(TXNEXTSUB+1,57,11,ST);
				  End;
			    End;
			End
		      ELSE
			If Device = 'S' Then
			  Begin
			     BUILDSTR(TXNEXTSUB,44,11,ST);
			     If ( txt In [2,6] ) And discounted Then
				Begin
                                   DoubleToStr ( Disp_Disc_Amt, St, '%10.2f', True, True, 10, False );
				   {LONGSTR(disp_disc_amt,ST,'L');}
				   ST:=COPY(ST,2,11);
				   BUILDSTR(TXNEXTSUB+1,44,11,ST);
				End;
			  End
			Else
			  Begin
			     BUILDSTR(TXNEXTSUB,45,11,ST);
			     If ( txt In [2,6] ) And discounted Then
				Begin
                                   DoubleToStr ( Disp_Disc_Amt, St, '%10.2f', True, True, 10, False );
				   {LONGSTR(disp_disc_amt,ST,'L');}
				   ST:=COPY(ST,2,11);
				   BUILDSTR(TXNEXTSUB+1,45,11,ST);
				End;
			  End;
		    END;
	END;
        DoubleToStr ( RunBal, St, '%10.2f', True, True, 10, TRUE );
	{LONGSTR(RUNBAL,ST,'L');}
	IF PROG IN [CUSTLED,SUPPLED] THEN ST:=COPY(ST,2,11);
	CASE PROG OF
	  CUSTSTM,SUPPSTM : IF NOT Cash2.XINVALLOC THEN
			      BEGIN
				BUILDSTR(TXNEXTSUB,STINTS^[22],12,ST);
				BUILDSTR(TXNEXTREM,STINTS^[62],12,ST);
				If ( txt In [2,6] ) And discounted Then
				   Begin
				      RUNBAL := ( RUNBAL-disc_amt );
                                      DoubleToStr ( RunBal, St, '%10.2f', True, True, 10, True );
				      {LONGSTR(RUNBAL,ST,'L');}
				      BUILDSTR(TXNEXTSUB+1,STINTS^[22],12,ST);
				      BUILDSTR(TXNEXTREM+1,STINTS^[62],12,ST);
				      txnextsub := txnextsub+1;
				      If txnextrem > 0 Then
					 txnextrem := txnextrem+1;
				   End;
			      END;
	  CUSTLED,SUPPLED : IF BALBF THEN
			      IF (DATE1=NULL) AND (DATE2=NULL) THEN
				Begin
				   If Device = 'S' Then
				      Begin
					 BUILDSTR(TXNEXTSUB,66,11,ST);
					 If ( txt In [2,6] ) And discounted Then
					    Begin
					       RUNBAL := ( RUNBAL-disc_amt );
                                               DoubleToStr ( RunBal, St, '%10.2f', True, True, 10, True );
                                               // DoubleToStr ( RunBal, St, '%10.2f', True, True, 10, False );
					       {LONGSTR(RUNBAL,ST,'L');}
					       ST:=COPY(ST,2,11);
					       BUILDSTR(TXNEXTSUB+1,66,11,ST);
					       txnextsub := txnextsub+1;
					    End;
				      End
				   Else
				      Begin
					 BUILDSTR(TXNEXTSUB,69,11,ST);
					 If ( txt In [2,6] ) And discounted Then
					    Begin
					       RUNBAL := ( RUNBAL-disc_amt );
                                               DoubleToStr ( RunBal, St, '%10.2f', True, True, 10, True );
                                               // DoubleToStr ( RunBal, St, '%10.2f', True, True, 10, False );
					       {LONGSTR(RUNBAL,ST,'L');}
					       ST:=COPY(ST,2,11);
					       BUILDSTR(TXNEXTSUB+1,69,11,ST);
					       txnextsub := txnextsub+1;
					    End;
				      End;
				End;
	END;
      END;
  END;

  PROCEDURE PRINTSTATEMENT;
  VAR
    X	  : INTEGER;
    LINES : INTEGER;
  BEGIN

    LINES:=MAXLINES;
    IF PROG IN [CUSTSTM,SUPPSTM] THEN
      Begin
	IF STINTS^[5]<>0 THEN LINES:=STINTS^[5];
      End
    Else
      Lines := RFarmGate.plinespage[1];
    BLANK:=FALSE;

    LINECOUNT:=1;
    CheckHeading;
    FOR X := 1 TO LINES DO PRINTOUT(X);
  END;

     (*
     to print the final page of totals for selected accounts
     This is chosen if the user selects Ledger cards from the Customer or
     Supplier Menu. The option selected accounts must also be chosen for this
     process to be carried out
     *)
  Procedure print_grp;
  var
    x : Integer;
    st		: Shortstring;		(* gen string for building statement *)
    sales_purch : string[8];			     (* stores heading title *)
  Begin
    last_page := true;
    if prog = custrec then
      sales_purch := 'CUSTOMER'
    else
      sales_purch := 'SUPPLIER';

    st := concat (space40, space40 );
    Move ( st[1], STLINES^[6+PrintFrom][1], length ( st ));

                                      		  (* build the main heading for report *)
    // next line puts the heading ACC-NO and CUSTOMER or SUPPLIER on the top of the last page if total accounts has
    // been ticked.
    st := concat ( 'ACC-NO ',sales_purch,'	      ' ); // see line 338 - GM fixed 338 07/05/02- it was missing if not last_page
    Move ( st[1], STLINES^[6+PrintFrom][1], length(st));
    st := '    QTY    AMOUNT       AMT/QTY       VAT      TOTAL';
    Move (ST[1], STLINES^[6+PrintFrom][26], length ( st ));
    blankstatement;			     (* initialise a blank statement *)

    x := 1;
    for x := 1 to grp_read do	 (* build list upto no. of account processed *)
      Begin
	st := concat ( space40, space40 );
	str ( grp_accs^[x].acc_no, st );
	buildstr ( 9+x, 1, 4, st );
	buildstr ( 9+x, 7, 18, grp_accs^[x].acc_name );

	st := concat ( space40, space40 );
        DoubleToStr ( Grp_Accs^[x].Quantity, St, '%10.2f', True, True, 10, False );
	{longstr ( grp_accs^[x].quantity, st, 'L' );}
	buildstr ( 9+x, 25, 10, copy (st, 3, 10));

	st := concat (space40, space40 );
	{longstr ( grp_accs^[x].totamt, st, 'L' );}
        DoubleToStr ( Grp_Accs^[x].TotAmt, St, '%10.2f', True, True, 10, False );
	buildstr ( 9+x, 35, 12, copy(st,1,12));

	st := concat (space40, space40 );
	if ( grp_accs^[x].quantity > 0 ) then
          DoubleToStr (((Grp_Accs^[x].TotAmt*100) div grp_accs^[x].Quantity), St, '%10.2f', True, True, 10, False )
	  {longstr ((( grp_accs^[x].totamt*100) div grp_accs^[x].quantity), st, 'L' )}
	Else
          DoubleToStr ( 0, St, '%10.2f', True, True, 10, False );
	  {longstr ( 0, st, 'L' );}
	buildstr ( 9+x, 47, 10, copy(st,3,10));

	st := concat (space40, space40 );
        DoubleToStr (Grp_Accs^[x].TotTax, St, '%10.2f', True, True, 10, False );
        {longstr ( grp_accs^[x].tottax, st, 'L' );}
	buildstr ( 9+x, 57, 12, copy (st,1, 12));
	st := concat ( space40, space40 );
        DoubleToStr (Grp_Accs^[x].Total, St, '%10.2f', True, True, 10, False );
        {longstr ( grp_accs^[x].total, st, 'L' );}
	buildstr ( 9+x, 69, 12, copy(st,1,12));

			    (* store running totals *)
	total_ex_vat := total_ex_vat + grp_accs^[x].totamt;
	vat_total    := vat_total + grp_accs^[x].tottax;
	grand_total := grand_total + grp_accs^[x].total;
	total_quan := total_quan + grp_accs^[x].quantity;

      End;

	     (* build strings to display/print the totals & sub totals *)
      st := concat ( space40, space40 );
      buildstr ( 9+x+2, 4, 15, '   GRAND TOTALS');
      st := concat ( space40, space40 );
      DoubleToStr (Total_Quan, St, '%10.2f', True, True, 10, False );
      {longstr ( total_quan, st, 'L' );}
      buildstr ( 9+x+2, 25, 10,copy(st,3,10));
      st := concat ( space40, space40 );
      DoubleToStr (Total_Ex_Vat, St, '%10.2f', True, True, 10, False );
      {longstr ( total_ex_vat, st, 'L' );}
      buildstr ( 9+x+2, 35, 12, copy(st,1,12));

      st := concat ( space40, space40 );
      if total_quan > 0 then
        DoubleToStr ((( total_ex_vat*100)div total_quan), St, '%10.2f', True, True, 10, False )
	{longstr ((( total_ex_vat*100)div total_quan), st, 'L' )}
      else
        DoubleToStr ( 0, St, '%10.2f', True, True, 10, False );
	{longstr ( 0, st,'L');}
      buildstr ( 9+x+2, 47, 10, copy(st,3,10));

      st := concat ( space40, space40 );
      DoubleToStr ( Vat_Total, St, '%10.2f', True, True, 10, False );
      {longstr ( vat_total, st, 'L' );}
      buildstr ( 9+x+2, 57, 12, copy(st,1,12));
      st := concat ( space40, space40 );
      DoubleToStr ( Grand_Total, St, '%10.2f', True, True, 10, False );
      {longstr ( grand_total, st, 'L' );}
      buildstr ( 9+x+2, 69, 12, copy(st,1,12));
      PRINTSTATEMENT;				    (* print the ledger card *)

  End;

  PROCEDURE LISTACCOUNTS;
  BEGIN
    LISTRUN:=TRUE;
    {DIS (15,NEXTLINE,'Total Accounts Selected: ');}
    {
    REPEAT
      DIS (24,NEXTLINE+1,'Account Number: ');
      DIS ( 1,24,'ENTER ACCOUNTS REQUIRED & PRESS ENTER WHEN ALL ENTERED');
      SETDB(NlFile);
      REPEAT
	RECNO:=0;
	ALLOWQUEST:=TRUE;
	window_position := 'L';
	disp_options := true;
	allow_exit := false;
	F2_F3_active := true;
	case PROG of
	  CUSTSTM, CUSTLED, CUSTREC : search_action := 2;
	  SUPPSTM, SUPPLED, SUPPREC : search_action := 3;
	end;
	search_db := 1;

	ENTERACC(40,NEXTLINE-1,RECNO,FALSE,0,40,40,1,-1,all_supp_cust);
	ALLOWQUEST:=FALSE;
	IF ESCKEY THEN EXIT(LISTACCOUNTS);
	IF (SCRINT=NULL) AND (TOTLIST>0) THEN
	  BEGIN
	    DIS (24,NEXTLINE-1,SPACE40);
	    NEXTLINE:=NEXTLINE+2;
	    EXIT(LISTACCOUNTS);
	  END;
	VALID:=(RECNO>0) AND (RECNO<DB1.DBRECTOT+1);
      UNTIL VALID;

      PRLIST[TOTLIST+1]:=RECNO;
      TOTLIST:=TOTLIST+1;
      HDISI (40,NEXTLINE,TOTLIST,1);
    UNTIL TOTLIST=MAXLIST;

    DIS (24,NEXTLINE-1,SPACE40);

    NEXTLINE:=NEXTLINE+2;
    }
  END;

  PROCEDURE PROCESSDB;
  VAR
    last_area :integer;
    I : integer;
{-->>    store_area,}
{-->>    TOTS : INTEGER;}
  BEGIN

    page_break := false;
    last_area  := -1;
    head_area  := 0;
{-->>    store_area := 0;}

    If ( sort_area ) And ( prog In [custrec, supprec] ) Then
      Begin
	 sort_file ( FileNo, fromacc, 22, 1, true );
	 If ( fromacc > 0 ) Then
	    Begin
	       Repeat
		  readrec ( FileNo,fromacc );
		  If errorno > 0 Then err;
		  If recactive ( FileNo ) Then
		     Begin
			getitem ( FileNo, 22 );
			head_area := currint;
			oktoprint := ( head_area >= StatementForm.AreaFrom ) And
				     ( head_area <= StatementForm.AreaTo );
		     End;
		  { only read next if the record just read isn't valid }
		  If NOT oktoprint Then
		     next_sort_rec ( fromacc );
	       Until oktoprint Or ( fromacc = 0 );
	       If fromacc <> 0 Then
		  {ststart}
	       Else
		  exit;
	    End;
      End
    Else
      FROMACC := FROMACC - 1;

{-->>    TOTS:=0;}
    no_count := 0;
    REPEAT
      If ( sort_area ) And ( prog In [custrec, supprec] ) Then
      Else
	 FROMACC := FROMACC + 1;

      IF ( FROMACC > TOACC ) Or
	 ( Fromacc = 0 ) THEN EXIT;

      READREC(FileNo,FROMACC);
      IF NOT(ERRORNO IN [0,5]) THEN ERR;
      IF RECACTIVE(FileNo) THEN
	BEGIN
	  CUSTACC:=FROMACC;
          If StatementForm.AreaTo > 0 then begin
             GETITEM (FileNo,22);
             last_area := currint;
	     oktoprint := ( last_area >= StatementForm.AreaFrom ) And
			     ( last_area <= StatementForm.AreaTo );
          end else
	  OKTOPRINT:=TRUE;
	  IF (PROG IN [CUSTSTM,SUPPSTM]) THEN
	    BEGIN
	      GETITEM (FileNo,15);
	      FIRSTTX:=CURRINT;
	    END;
	  if (PROG IN [CUSTLED,SUPPLED,CUSTREC,SUPPREC,SUPPSUM,CUSTSUM]) OR (Cash2.XINVALLOC) THEN
	    begin
	      GETITEM(FileNo,14);
	      IF CURRINT=0 THEN GETITEM(FileNo,15);
	    end;
	  TXPOINTER:=CURRINT;
	  TXSAVE   :=CURRINT;
	  IF PRINTTYPE <> 1 THEN
	    BEGIN
	      GETITEM(FileNo,7);
              // tgm print change
              val(stat.StatementForm.GreaterThanBalance.text,GreaterThan,Code);
	      IF (PRINTTYPE=2) AND (CURRLONG <= GreaterThan*100) THEN OKTOPRINT:=FALSE;
	      IF (PRINTTYPE=3) AND (CURRLONG=0) AND (TXPOINTER=0) THEN
		OKTOPRINT:=FALSE;
	    END;

	  If (( sort_area ) And ( oktoprint ) And
	      ( Prog In [custrec, supprec] )) Then
	      Begin
		getitem ( FileNo, 22 );
		page_break := (( currint <> last_area ) And ( last_area <> -1 ));
		If currint <> last_area Then
{-->>		  store_area := last_area;}
		last_area := currint;
		head_area := last_area;
		oktoprint := ( last_area >= StatementForm.AreaFrom ) And
			     ( last_area <= StatementForm.AreaTo );
	      End;

	  IF OKTOPRINT THEN
	    BEGIN
	      no_count := no_count + 1;

	      if ( NOT ( PROG In [custrec, supprec,SUPPSUM,CUSTSUM] )) Or ( ThrowPage ) Then
		 BLANKSTATEMENT;

	      IF ESCKEY THEN EXIT;
	      STSTART;

	      IF NOT ESCKEY THEN
		Begin
		  { if the report is to be sorted then call the sort routine }
		  if ( report_sorted ) then
		    Begin

	              start_from := txpointer;
	       	 //     SortFile ( TxFile, SortFileNo, WorkFile, sortfld, 999, 0, 0, sort_asc, TRUE, TRUE, TRUE,
	       	 //	     start_from, 0, false, true );

                      Accsdatamodule.TransactionsDB.close;
                      Accsdatamodule.TransactionsDB.IndexDefs.Add('ByDate', 'TxDate',[] );
                      Accsdatamodule.TransactionsDB.IndexDefs.Update;
                      for I := 0 to Accsdatamodule.TransactionsDB.IndexDefs.Count - 1 do
                          if Accsdatamodule.TransactionsDB.IndexDefs.Items[I].Fields = 'ByDate' then
                             begin
                             Accsdatamodule.TransactionsDB.IndexName := Accsdatamodule.TransactionsDB.IndexDefs.Items[I].Name;
                          end;
                      Accsdatamodule.TransactionsDB.open;


		//      cclose ( SortFileNo, 'N' );
		//      creset ( SortFileNo, sortid );
		//      if errorno > 0 then AbortProgram ( seqerr );

		      sortpos := 512;
		      sortblk := -1;

		      { get the next record to read }
		      { if sorting than set txsave to first }
		      { record on sorted file }
		      next_sort_rec ( txpointer );
		      txsave := txpointer;
		    End;
		  { process tx file as normal }
		  first_pass := true;
		  exclude_first := true;
		  REPEAT
                    ExitProcessTxs := False;
		    PROCESSTXS;
		  UNTIL ESCKEY OR (TXPOINTER=0) OR (TXPOINTER > DB1.DBRECHIGH);
		End;
	      If NOT ESCKEY THEN STEND;
	      If ( NOT ( PROG In [custrec, supprec,SUPPSUM,CUSTSUM] )) Or
		  ( ThrowPage ) Then
		 Begin
		    IF NOT ESCKEY THEN PRINTSTATEMENT;
		 End
	      Else
		 If (( PROG In [custrec, supprec,SUPPSUM,CUSTSUM] ) And
		     ( txnextsub >= RFarmGate.plinespage[1]-5 ) And
		     ( NOT ThrowPage )) Then
		    If NOT esckey Then
		       Begin
			 printstatement;
			 blankstatement;
		       End;
	    END;
	END;

      If ( sort_area ) And ( prog In [custrec, supprec,SUPPSUM,CUSTSUM] ) Then
	 next_sort_rec ( fromacc );

      {* If you are not throwing pages then print the last statement }
      If (( NOT sort_area ) And ( fromacc >= toacc ) And
	  ( PROG In [custrec, supprec,SUPPSUM,CUSTSUM] ) And ( NOT ThrowPage )) Then
	printstatement;

    UNTIL ESCKEY;

    if report_sorted Or (( prog In [custrec, supprec,SUPPSUM,CUSTSUM] ) And ( sort_area )) then
      cclose ( SortFileNo, 'P' );

  END;

  PROCEDURE ACCOUNTRANGE;
  BEGIN
    SETDB(FileNo);
    FROMACC:=1;
    TOACC  :=DB1.DBRECHIGH;
{
    REPEAT

      DIS   (20,NEXTLINE,'Account Range From: ');
      DIS   (56,NEXTLINE,'To: ');
      HDISI (40,NEXTLINE,FROMACC,1);
      HDISI (60,NEXTLINE,TOACC,1);
      REPEAT
	REPEAT
	  ALLOWQUEST:=TRUE;
	  window_position := 'L';
	  disp_options := true;
	  allow_exit := false;
	  F2_F3_active := true;
	  case PROG of
	    CUSTSTM,CUSTLED,CUSTREC : search_action := 2;
	    SUPPSTM,SUPPLED,SUPPREC : search_action := 3;
	  end;
	  search_db := 1;

	  ENTERACC(40,NEXTLINE,FROMACC,FALSE,0,40,40,1,-1,all_supp_cust);
	  ALLOWQUEST:=FALSE;
	  IF ESCKEY THEN EXIT(ACCOUNTRANGE);
	UNTIL SCRINT<>QUERY;
	REPEAT
	  ALLOWQUEST:=TRUE;
	  window_position := 'L';
	  disp_options := true;
	  allow_exit := false;
	  F2_F3_active := true;
	  search_db := 1;

	  case PROG of
	    CUSTSTM,CUSTLED,CUSTREC : search_action := 2;
	    SUPPSTM,SUPPLED,SUPPREC : search_action := 3;
	  end;

	  ENTERACC(60,NEXTLINE,TOACC,FALSE,0,40,40,1,-1, all_supp_cust);
	  ALLOWQUEST:=FALSE;
	UNTIL SCRINT<>QUERY;
      UNTIL NOT ESCKEY;
    UNTIL (FROMACC>0) AND NOT(FROMACC>TOACC) AND (TOACC<DB1.DBRECTOT+1);
    NEXTLINE:=NEXTLINE+2;
}
  END;

  PROCEDURE PROCESSLIST;
  VAR
    FINISHED : BOOLEAN;
  BEGIN
    LISTSUB:=1;
    no_count := 0;
    IF StatementForm.TOTLIST = 0 THEN EXIT;
    CUSTACC := StatementForm.PRLIST[1];
    REPEAT
      READREC(FileNo,CUSTACC);
      IF NOT(ERRORNO IN [0,5]) THEN ERR;
      IF RECACTIVE(FileNo) THEN
	BEGIN
	  OKTOPRINT:=TRUE;
	  IF (PROG IN [CUSTSTM,SUPPSTM]) THEN
	    BEGIN
	      GETITEM (FileNo,15);
	      FIRSTTX:=CURRINT;
	    END;
	  IF (PROG IN [CUSTLED,SUPPLED,CUSTREC,SUPPREC,SUPPSUM,CUSTSUM]) OR (Cash2.XINVALLOC) THEN
	    BEGIN
	      GETITEM(FileNo,14);
	      IF CURRINT=0 THEN GETITEM(FileNo,15);
	    END;
	  TXPOINTER:=CURRINT;
	  TXSAVE   :=CURRINT;
	  IF PRINTTYPE <> 1 THEN
	    BEGIN
	      GETITEM(FileNo,7);
              // tgm print change
              val(stat.StatementForm.GreaterThanBalance.text,GreaterThan,Code);
	      IF (PRINTTYPE=2) AND (CURRLONG <= GreaterThan*100) THEN OKTOPRINT:=FALSE;
	      IF (PRINTTYPE=3) AND (CURRLONG=0) AND (TXPOINTER=0) THEN
		OKTOPRINT:=FALSE;
	    END;
	  IF OKTOPRINT THEN
	    BEGIN
	      no_count := no_count + 1;
	      If ( NOT ( PROG In [custrec, supprec,SUPPSUM,CUSTSUM] )) Or ( ThrowPage ) Then
		 BLANKSTATEMENT;

	      IF ESCKEY THEN EXIT;
	      STSTART;

	      if TotalGrp then
		Begin
		  grp_read := grp_read + 1;		  (* advance counter *)
		  grp_accs^[grp_read].acc_no   := custacc;
		  grp_accs^[grp_read].acc_name := custname;
		End;

	      IF NOT ESCKEY THEN
		Begin
		  { if the report is to be sorted then call the sort routine }
		  if ( report_sorted ) then
		    Begin
		      start_from := txpointer;
		      SortFile ( TxFile, SortFileNo, WorkFile, sortfld, 999, 0, 0, sort_asc, TRUE, TRUE, TRUE,
			     start_from, 0, false, true );

		      cclose ( SortFileNo, 'N' );
		      creset ( SortFileNo, sortid );

		      if errorno > 0 then AbortProgram ( seqerr );

		      sortpos := 512;
		      sortblk := -1;

		      { get the next record to read }
		      { if sorting then set txsave equal to first }
		      { record on the sorted transaction file }
		      next_sort_rec ( txpointer );
		      txsave := txpointer;
		    End;
		  { process file as normal }
		  first_pass := true;
		  exclude_first := true;
		  REPEAT
                    ExitProcessTxs := False;
		    PROCESSTXS;
                    // Line below added by TGM AB - not sure whats causing the problem but the next
                    // line stops statement reports going into a infinite loop
                    if TXPointer > Accsdatamodule.TransactionsDB.recordcount then Txpointer := 0;
		  UNTIL ESCKEY OR (TXPOINTER=0);
		End;
	      IF NOT ESCKEY THEN STEND;
	      If ( NOT ( PROG In [custrec, supprec,SUPPSUM,CUSTSUM] )) Or
		  ( ThrowPage ) Then
		 Begin
		    IF NOT ESCKEY THEN PRINTSTATEMENT;
		 End
	      Else
		 If (( PROG In [custrec, supprec,SUPPSUM,CUSTSUM] ) And
		     ( txnextsub >= RFarmGate.plinespage[1]-5 ) And
		     ( NOT ThrowPage )) Then
		    If NOT esckey Then
		       Begin
			  printstatement;
			  blankstatement;
		       End;
	    END;
	END;
      ESCKEY:=FALSE;
      LISTSUB:=LISTSUB+1;
      FINISHED:= (LISTSUB>StatementForm.TOTLIST);
	(*
	if the processing is finished and the flag TotalGrp is true then the
	report totalling the group is processed to show totals & sub-totals
	*)
      if (( finished ) and ( TotalGrp )) then
	Begin
	  {* ensure the last page is printed before the group totals }
	  If ( PROG In [custrec, supprec] ) And ( NOT ThrowPage ) Then
	     printstatement;
	  print_GRP;
	End;

      IF NOT FINISHED THEN CUSTACC:=StatementForm.PRLIST[LISTSUB];
    UNTIL FINISHED;

    {* If you are not throwing pages then print the last statement }
    If ( PROG In [custrec, supprec,SUPPSUM,CUSTSUM] ) And ( NOT ThrowPage ) And
       ( NOT TotalGrp ) Then
      printstatement;

    if report_sorted then
      cclose ( SortFileNo, 'P' );

  END;

  PROCEDURE STATEMENTS;
  BEGIN
    {
    NEXTLINE:=6;
    CASE PROG OF
      CUSTSTM,SUPPSTM : DIS (21,NEXTLINE,'Date on Statement: ');
      CUSTLED,SUPPLED : DIS (19,NEXTLINE,'Date on Ledger Card: ');
      CUSTREC,SUPPREC : DIS (19,NEXTLINE,'Date on Record Card: ');
    END;
(* change *)
    SCRIN := XDATE;
    repeat
      recdat ( 40, nextline, scrin, temp_date, 0, 0, 0, 0, 0 ,0 );
      if esckey then exit ( statements );
      error_date ( report, go_on );
    until NOT CHECK_DATE ( SCRIN, DEFAULT_DATE );

    XDATE:=SCRIN;
    CLEARFROM ( 24 );

    NEXTLINE:=NEXTLINE+2;
    WRITEDEF:=TRUE;
    }
    case PROG of
      CUSTSTM,SUPPSTM : begin
			  BUILDSTR(STINTS[12],STINTS[13],LENGTH(StatementForm.HeadingDate),StatementForm.HeadingDate);
			  BUILDSTR(STINTS[52],STINTS[53],LENGTH(StatementForm.HeadingDate),StatementForm.HeadingDate);
			end;
      CUSTLED,SUPPLED,
      CUSTREC,SUPPREC : BUILDSTR(2+PrintFrom,62,LENGTH(StatementForm.HeadingDate),StatementForm.HeadingDate);
    end;
    {
    DATA_DEST ( NEXTLINE, WORKSTR );

    IF ESCKEY THEN
       EXIT ( STATEMENTS );

    NEXTLINE:=NEXTLINE+2;
    WHERETO :=WORKSTR[1];
    CLEARFROM (24);
    DIS (7,NEXTLINE,'Which Accounts to Print (1/2/3): ');
    DIS (1,24,'ENTER ... 1 ALL ... 2 RANGE OF ACCOUNTS ... 3 SELECTED ACCOUNTS');
    REPEAT
      no_func_key;
      REC (40,NEXTLINE,1,'3',0,0,0,0,0,0);
      IF ESCKEY THEN EXIT(STATEMENTS);
    UNTIL SCRIN[1] IN ['1'..'3'];
    CLEARFROM (24);
    ACCTYPE :=SCRIN[1];
    CASE ACCTYPE OF
      '1' : HDIS (45,NEXTLINE,'All Accounts');
      '2' : HDIS (45,NEXTLINE,'Range of Accounts');
      '3' : HDIS (45,NEXTLINE,'Selected Accounts');
    END;

    NEXTLINE:=NEXTLINE+1;
    DIS (7,NEXTLINE,'Conditions for Printing (1/2/3): ');
    DIS (1,24,'ENTER ... 1 ALL ... 2 WITH BALANCES ... 3 WITH BALANCES OR TRANSACTIONS');
    REPEAT
      no_func_key;
      REC (40,NEXTLINE,1,'3',0,0,0,0,0,0);
      IF ESCKEY THEN EXIT(STATEMENTS);
    UNTIL SCRIN[1] IN ['1'..'3'];
    CLEARFROM (24);
    INTVAL(PRINTTYPE,SCRINT);
    CASE PRINTTYPE OF
      1 : HDIS (45,NEXTLINE,'All Accounts');
      2 : HDIS (45,NEXTLINE,'With Balances');
      3 : HDIS (45,NEXTLINE,'With Balances or Transactions');
    END;
    NEXTLINE:=NEXTLINE+2;
    SETDB(1);
    FROMACC:=1;
    TOACC  :=DB1.DBRECHIGH;
    IF ACCTYPE='2' THEN ACCOUNTRANGE;
    IF ACCTYPE='3' THEN LISTACCOUNTS;
    IF ESCKEY THEN EXIT (STATEMENTS);

    If (( prog In [custrec, supprec] ) And ( acctype <> '3' )) Then
       Begin
	  area_from := 0;
	  area_to   := 0;

	  Dis ( 18, nextline-1, 'Print Area Code From: ' );
	  Dis ( 56, nextline-1, 'To: ' );

	  Repeat
	     str ( area_from, st );
	     recint ( 40, nextline-1, st, area_from, 0, 0, 0, 0, 0, 0 );
	     If esckey Then exit ( statements );
	     str ( area_to, st );
	     recint ( 60, nextline-1, st, area_To, 0, 0, 0, 0, 0, 0 );
	  Until ( area_to >= area_from ) And ( NOT esckey );

	  sort_area := ( area_to > 0 );

       End;

    IF PROG IN [CUSTLED,SUPPLED,CUSTREC,SUPPREC, custstm, suppstm ] THEN
      BEGIN
	date1 := null;
	date2 := null;
	get_period ( period1, period2, date1, date2,
		     99, nextline, fromdt, todt );
	if ESCKEY then EXIT ( STM );
	nextline := nextline + 3;
      END;

    BALBF:=TRUE;
    IF PROG IN [CUSTLED,SUPPLED] THEN
      IF (DATE1=NULL) AND (DATE2=NULL) THEN
	BEGIN
	  NEXTLINE:=NEXTLINE+1;
	  dis ( 11, nextline, 'Include Balance B/F ? (Y/N): ');
	  SCRIN:='Y';
	  REPEAT
	    no_func_key;
	    REC (40,NEXTLINE,1,SCRIN,0,0,0,0,0,0);
	    IF ESCKEY THEN EXIT(STATEMENTS);
	  UNTIL SCRIN[1] IN ['Y','N','y','n'];
	  BALBF:=(SCRIN[1] IN ['Y','y']);
	  NEXTLINE:=NEXTLINE+2;
	END
      else
	BALBF := false;

    IF PROG IN [CUSTREC,SUPPREC] THEN
      BEGIN
	scrin[1] := 'N';
	Dis ( 12, nextline,'Invoice Sub-totals ? (Y/N): ');
	repeat
	  rec ( 40, nextline, 1, scrin, 0, 0, 0, 0, 0, 0 );
	  if esckey then exit ( statements );
	until scrin[1] in ['Y','n','N','y'];
	If scrin[1] in ['Y','y'] Then
	   sub_total_inv := true
	Else
	   Begin
	     scrin[1] := 'Y';
	     Dis ( 44, nextline, 'New Page for Each Account (Y/N):');
	     Askyes ( 77, nextline, ThrowPage, 0 );
	     If esckey Then Exit ( statements );
	     nextline := nextline + 1;
	     sub_total_inv := false;
	   End;

	SETDB (3);
	SCHRECF:=1;
	SCHRECT:=DB1.DBRECHIGH;
	If NOT sub_total_inv Then
	  Begin
	    REPEAT
	      DIS ( 7,NEXTLINE,'Transaction Analysis Range From: ');
	      DIS (56,NEXTLINE,'To: ');
	      STR(SCHANALF,ST);
	      REPEAT
		no_func_key;
		REC(40,NEXTLINE,4,ST,0, 40, 40, anl_db, -1, all_anl );
		IF ESCKEY THEN EXIT(STATEMENTS);
		ST:=SCRIN;
	      UNTIL NUMERIC (SCRINT);
	      INTVAL(SCHANALF,SCRINT);
	      STR(SCHANALT,ST);
	      REPEAT
		no_func_key;
		REC( 60, NEXTLINE, 4, ST, 0, 40, 40, anl_db, -1, all_anl );
		ST:=SCRIN;
	      UNTIL ESCKEY OR NUMERIC(SCRINT);
	      IF NOT ESCKEY THEN INTVAL(SCHANALT,SCRINT);
	    UNTIL NOT ESCKEY AND (SCHANALF>=0) AND NOT(SCHANALT<SCHANALF);
	    NEXTLINE:=NEXTLINE+1;
	    SETDB (3);
	    SCHRECF:=1;
	    SCHRECT:=DB1.DBRECHIGH;
	    REPEAT
	      DIS (12,NEXTLINE,'Nominal Account Range From: ');
	      DIS (56,NEXTLINE,'To: ');
	      STR(SCHRECF,ST);
	      REPEAT
		window_position := 'L';
		disp_options := true;
		allow_exit := false;
		F2_F3_active := true;
		search_action := 4;
		search_db := 3;
    
		REC(40,NEXTLINE,4,ST,0,40,40,3,-1,all_nom);
		IF ESCKEY THEN EXIT(STATEMENTS);
		ST:=SCRIN;
	      UNTIL NUMERIC (SCRINT);
	      INTVAL(SCHRECF,SCRINT);
	      STR(SCHRECT,ST);
	      REPEAT
		window_position := 'L';
		disp_options := true;
		allow_exit := false;
		F2_F3_active := true;
		search_action := 4;
		search_db := 3;

		REC(60,NEXTLINE,4,ST,0,40,40,3,-1,all_nom);
		ST:=SCRIN;
	      UNTIL ESCKEY OR NUMERIC(SCRINT);
	      IF NOT ESCKEY THEN INTVAL(SCHRECT,SCRINT);
	    UNTIL NOT ESCKEY AND (SCHRECF>0) AND NOT(SCHRECT<SCHRECF);
	  End
	Else
	  Begin
	     nextline := nextline + 1;
	     scrin[1] := 'N';
	     Dis ( 7, nextline, 'New Page for Each Account (Y/N):');
	     Askyes ( 40, nextline, ThrowPage, 0 );
	     If esckey Then Exit ( statements );
	  End;
	
	NEXTLINE:=NEXTLINE+1;
	scrin[1] := 'N';
	DIS (10,NEXTLINE,'Show Amount per Unit ? (Y/N): ');
	REPEAT
	  no_func_key;
	  REC ( 40, NEXTLINE, 1, scrin, 0, 0, 0, 0, 0, 0 );
	  IF ESCKEY THEN EXIT (STATEMENTS);
	UNTIL SCRIN[1] IN ['Y','N','y','n'];
	SHOWAMT:=(SCRIN[1] IN ['Y','y']);
	NEXTLINE:=NEXTLINE+1;
	SETDB (1);
	IF SHOWAMT
	  THEN ST:='QUAN     AMOUNT  AMT/UNIT	     VAT    TOTAL'
	  ELSE ST:='QUANTITY	 AMOUNT	       VAT	TOTAL';
	if showamt then
	  Move ( st[1], STLINES^[6][34], length ( st ))
	else
	  Move (ST[1],STLINES^[6][38],LENGTH(ST));
      END;
    DESCFLD:=5;
    IF ((PROG=CUSTREC) AND (XSALESINFO))
    OR ((PROG=SUPPREC) AND (XPURCHINFO)) THEN
      BEGIN
	SETDB (2);
	DIS (14,NEXTLINE,'Description Field Number: ');
	SCRIN:='5';
	REPEAT
	  REPEAT
	    no_func_key;
	    REC (40,NEXTLINE,2,SCRIN,0,0,0,0,0,0);
	    IF ESCKEY THEN EXIT (STATEMENTS);
	  UNTIL	 NUMERIC (SCRINT);
	  INTVAL (DESCFLD,SCRINT);
	UNTIL DB1.DBITEMS[DESCFLD].DBINAME<>NULL;
	NEXTLINE:=NEXTLINE+2;
      END;

    if (( prog in [custrec,supprec] ) and ( acctype = '3' )) then
      Begin
	dis ( 42, nextline-1, 'Total Selected Accounts ? (Y/N): ');
	scrin[1] := 'N';
	repeat
	  no_func_key;
	  rec ( 75, nextline-1, 1, scrin, 0,0, 0,0,0,0);
	  if esckey then exit ( statements );
	until scrin[1] in ['Y','y','n','N'];
	if scrin[1] in ['y','Y'] then
	  TotalGrp := true
	else
	  TotalGrp := false;
      End;
    
    If ( NOT sort_area ) Then
      if ( prog in [custrec, supprec, custled, suppled] ) then
	Begin
	  if acctype = '1' then
	    nextline := nextline + 1;

	  dis ( 20, nextline, 'Sort by Date (Y/N): ');
	  scrin[1] := 'N';
	  repeat
	    rec ( 40, nextline, 1, scrin, 0, 0, 0, 0, 0, 0 );
	    if esckey then exit ( statements );
	  until scrin[1] in ['Y','y','N','n'];
	  if scrin[1] in ['y','Y'] then
	    Begin
	      sortfld := 2;
	      report_sorted := true;
	    End
	  else
	    report_sorted := false;
	  
	  if report_sorted then
	    Begin
	      scrin[1] := 'A';
	      dis ( 44, nextline,'Ascending or Descending (A/D): ');
	      repeat
		rec ( 75, nextline, 1, scrin, 0, 0, 0, 0, 0, 0 );
		if esckey then exit ( statements );
	      until scrin[1] in ['A','a','D','d'];
	      if scrin[1] in ['A','a'] then
		sort_asc := true
	      else
		sort_asc := false;
	    End;
	End;
    
    IF WHERETO = 'P' THEN
      BEGIN
	IF SENDCONSOLE THEN WHERETO := 'C';
	IF WHERETO = 'P' THEN
	  CASE PROG OF
	    CUSTSTM,SUPPSTM : FOR X:=1 TO 4 DO IF STINTS[X]<>0 THEN
				WRITE(PRINTFILE,CHR(STINTS[X]));
	    CUSTLED,SUPPLED,
	    CUSTREC,SUPPREC : FOR X:=1 TO 9 DO IF PLINEASCII[2][X]<>0 THEN
				WRITE(PRINTFILE,CHR(PLINEASCII[2][X]));
	  END;
      END;
    }
    //Case StatementForm.iAccType.Text[1] Of
    Case StatementForm.iAccType Of
      1 : PROCESSDB;
      2 : PROCESSDB;
      3 : PROCESSLIST;
    End;
    {
    If Device = 'P' THEN
      CLOSE(PRINTFILE)
    Else
      if Device = 'F' then
	Close ( DISK_FILE)
      else
	if whereto = 'S' then
	  begin
	    if (( line_no > 0 ) and ( line_no <= 66 )) then
	      begin
		FP_init_remainder;
		SCR_disp_page;
		if terminate then
		  EXIT ( STM );
	      end;
	  end;

    if Device <> 'S' then
      begin
	CLEARFROM (24);
	CASE PROG OF
	  CUSTSTM,SUPPSTM : DIS (1,24,'STATEMENTS COMPLETED - PRESS ENTER ');
	  CUSTLED,SUPPLED : DIS (1,24,'LEDGER CARDS COMPLETED - PRESS ENTER ');
	  CUSTREC,SUPPREC : DIS (1,24,'RECORD CARDS COMPLETED - PRESS ENTER ');
	END;
	no_func_key;
	REC (39,24,0,NULL,0,0,0,0,0,0);
	CLEARFROM (24);
      end;
    }
  END;

  PROCEDURE STMSTART;
  VAR
    OPENOK : BOOLEAN;
    FLNAME : STRING;
  BEGIN
     OpenOk := False;
    {
    CASE PROG OF
      CUSTSTM : BETATITLE ('CUSTOMER STATEMENT');
      SUPPSTM : BETATITLE ('SUPPLIER STATEMENT');
      CUSTLED : BETATITLE ('CUSTOMER LEDGER CARD');
      SUPPLED : BETATITLE ('SUPPLIER LEDGER CARD');
      CUSTREC : BETATITLE ('CUSTOMER RECORD CARD');
      SUPPREC : BETATITLE ('SUPPLIER RECORD CARD');
    END;
    }
    IF PROG IN [CUSTSTM,SUPPSTM] THEN
      BEGIN
       { CASE PROG OF
             CUSTSTM : FLNAME:=Cash1.XSALSTATE;
             SUPPSTM : FLNAME:=Cash1.XPURSTATE;
        END;

        Case Prog Of
             CustStm : Begin
                            CCLOSE(SlStateFile,'N');
	                    CRESET(SlStateFile,CONCAT(Cash2.XDIRECTORY,FLNAME));
	                    OPENOK:= (ERRORNO=0);
                       End;
             SuppStm : Begin
                            CCLOSE(PlStateFile,'N');
	                    CRESET(PlStateFile,CONCAT(Cash2.XDIRECTORY,FLNAME));
	                    OPENOK:= (ERRORNO=0);
                       End;
        End;   }
        OPENOK := True;
	IF OPENOK THEN
          Case PROG Of
               CUSTSTM : READSTM ( SlStateFile );
               SUPPSTM : READSTM ( PlStateFile );
          End;
	{  END;}
	IF NOT OPENOK THEN
	  BEGIN
               MessageDlg('STATEMENT DEFINITION NOT FOUND', mtInformation,[mbOK], 0);
	       EXIT;
	  END;
      END
    ELSE
      READLED;

    StartPrint ( True );

    {
    OPENFILES;
    IF ESCKEY THEN EXIT(STM);
    }
    STATEMENTS;

    EndPrint;

  END;

BEGIN
  NewMemory;

  // try and Open the Products File
  try
      if NOT AccsDataModule.ProdsTx.Active then
         AccsDataModule.ProdsTx.Open;
  except
      ShowMessage('Cannot open Extra Details table');
  end;

  (* first_disp - for user info line to be displayed once when whereto = 'S' *)
  blankit := false;
  sort_area  := False;
  report_sorted := false;
  DATEFORMAT := 'DD/MM/YY';
{-->>  FIRST := TRUE;}
  PAGE	:= 0;
		   (* initialise variables used in ledger cards *)
  grp_read     := 0;
  grand_total  := 0;
  total_quan   := 0;
  total_ex_vat := 0;
  vat_total    := 0;
  LineForTotals := 0;

  last_page    := false;

  date1 := null;
  date2 := null;

  ThrowPage   := StatementForm.NewPage.Checked;
  ShowAmt     := StatementForm.PerUnit.Checked;
  TotalGrp    := StatementForm.TotalSelected.Checked;
  BalBf       := StatementForm.IncBalance.Checked;

//  period1	:= 0;	{* initialise the period numbers }
//  period2	:= 0;
  PrintFrom     := 0;
  DoubleSpace   := False;
  if ( PROG In [CUSTREC,SUPPREC,CUSTSUM,SUPPSUM] ) then
     begin
        PrintFrom := StatementForm.PrintFrom.AsInteger;
        if PROG In [CUSTSUM,SUPPSUM] then
           DoubleSpace := StatementForm.DoubleSpace.Checked;
     end;
  stopping_balance := 0;
  first_pass	:= true;
  if PROG In [CUSTREC,SUPPREC,SUPPSUM,CUSTSUM] then
     sub_total_inv := StatementForm.InvoiceSubTotal.Checked
  else
     sub_total_inv := False;

  if prog in [custled, suppled] then
    init_grp_array;		      (* initialize for accounts selected *)

  SetDb ( FileNo );

  FROMACC := StatementForm.iAccFrom;
  TOACC   := StatementForm.iAccTo;

  PRINTTYPE := StatementForm.iPrintType;
  FROMDT := StatementForm.TxDateFrom;
  TODT := StatementForm.TxDateTo;
  AreaFrom := StatementForm.AreaFrom;
  AreaTo := StatementForm.AreaTo;

  DESCFLD:=5;

  STMSTART;

  DisposeMemory;

END;

End.
