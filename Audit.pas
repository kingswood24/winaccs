{
   Listing of Procedures and Functions contained in this program section
   Seg. AUDITFILES.
   Pro. INIT.
   Pro. PHASE1.                
   Pro. PHASE2.
 }
Unit Audit;

InterFace

PROCEDURE AUDITFILES ( UpdateFile : Integer; AccountToUpdate : Integer; Sender : TObject  );

Implementation
Uses
    SysUtils,
    Dialogs,
    Forms,
    {Waiting,}
    UTIL,
    Vars,
    TYPES,
    DBCore,
    FullAudit;

PROCEDURE AUDITFILES ( UpdateFile : Integer; AccountToUpdate : Integer; Sender : TObject  );
CONST
  AUDITMAX = 999;
VAR
  FLNO	  : INTEGER;
  FROMACC : INTEGER;
  TOACC	  : INTEGER;
  LOWTX	  : INTEGER;
  LOWDT	  : INTEGER;
  PFIRST,
  PLAST,
  NEXTTX  : Integer;
{
  PFIRST  : PACKED ARRAY[1..AUDITMAX] OF INTEGER;
  PLAST	  : PACKED ARRAY[1..AUDITMAX] OF INTEGER;
  NEXTTX  : PACKED ARRAY[1..AUDITMAX] OF INTEGER;
}


  PROCEDURE INIT;
  BEGIN
    {
    FOR X:=1 TO AUDITMAX DO
      BEGIN
	PFIRST[X]:=0;
	PLAST[X]:=0;
	NEXTTX[X]:=0;
      END;
    }
    PFIRST :=0;
    PLAST  :=0;
    NEXTTX :=0;
  END;

  PROCEDURE PHASE1;
  VAR
    RECNO : INTEGER;
    TXT	  : INTEGER;
    DBAC  : INTEGER;
    CRAC  : INTEGER;
    ReadNo,
    NoToRead,
    ACCREC: INTEGER;
    ExitRoutine,
    OK	  : BOOLEAN;
  BEGIN
    SETDB (TxFile);

    {FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO}
    RecNo := db1.dbrechigh;
{-->>    NoToRead := Trunc( RecNo Div 500 ); }    { 500 being the width of WaitingForm }
{-->>    If NoToRead = 0 Then NoToRead := 1;}


    (Sender as TForm).Caption := 'Please Wait ';

    NoToRead := Trunc( RecNo Div 500 );     { 500 being the width of WaitingForm }
    If NoToRead = 0 Then NoToRead := 1;

{    WaitingForm.ProgressGauge.Progress := 0;}


    ReadNo   := 0;
    ExitRoutine := False;

    While ( RecNo >= 1 ) And ( NOT ExitRoutine ) Do
      BEGIN

        Inc ( Readno );

        If ( ReadNo mod 200 = 0 ) Then
           (Sender as TForm).Caption := (Sender as TForm).Caption + '*';

{        If ( ReadNo mod 200 = 0 ) Then
           (Sender as TForm).trxstatusbar.simpletext := (Sender as TForm).Caption + '*';}

        {
        If WaitingForm.MoveIt.Left > ( WaitingForm.Width - 5 ) Then
           WaitingForm.MoveIt.Left := 4;

        If ( ReadNo >= NoToRead ) Then
           Begin
              WaitingForm.MoveIt.Left := ( WaitingForm.MoveIt.Left + 1 );
              WaitIngForm.ReFresh;
              ReadNo := 0;
           End;
        }

        READREC(TxFile,RECNO);
	IF ERRORNO>0 THEN DbERR;
	IF RECACTIVE(TxFile) THEN
	  BEGIN
	    GETITEM(TxFile,1);
	    TXT:=CURRINT;
	    CASE FLNO OF
              SlFile:  BEGIN
		    OK:= TXT IN [1..4];
		    GETITEM(TxFile,3);
		    ACCREC:=CURRINT;
		    IF OK THEN OK:= (ACCREC=AccountToUpdate);
		    {IF OK THEN OK:= (ACCREC>FROMACC-1) AND (ACCREC<TOACC+1);}
		    IF OK THEN
		      BEGIN
			CURRINT:=0;
			PUTITEM(TxFile,16);
			{IF NEXTTX[ACCREC-AccountToUpdate+1]>0 THEN}
			IF NEXTTX>0 THEN
			  BEGIN
			    {CURRINT:=NEXTTX[ACCREC-AccountToUpdate+1];}
			    CURRINT:=NEXTTX;
			    PUTITEM(TxFile,16);
			  END;
			{NEXTTX[ACCREC-AccountToUpdate+1]:=RECNO;}
			NEXTTX:=RECNO;
			{
                        IF PLAST [ACCREC-AccountToUpdate+1]=0 THEN
			   PLAST [ACCREC-AccountToUpdate+1]:=RECNO;
			}
                        IF PLAST=0 THEN
			   PLAST :=RECNO;
			{
                        GETITEM (TxFile,2);
			IF ((LOWTX>0) AND (RECNO  >=LOWTX))
			OR ((LOWDT>0) AND (CURRINT>=LOWDT)) THEN}
                        IF ((LOWTX>0) AND (RECNO  >=LOWTX)) Then
			  {PFIRST[ACCREC-AccountToUpdate+1]:=RECNO;}
			  PFIRST := RECNO;
                        //ExitRoutine := ( RecNo < TxEditRec.TransF );
		      END;
		  END;
	      PlFile:  BEGIN
		    OK:= TXT IN [5..8];
		    GETITEM(TxFile,3);
		    ACCREC:=CURRINT;
		    IF OK THEN OK:= (ACCREC=AccountToUpdate);
		    {IF OK THEN OK:= (ACCREC>FROMACC-1) AND (ACCREC<TOACC+1);}
		    IF OK THEN
		      BEGIN
			CURRINT:=0;
			PUTITEM(TxFile,16);
			{IF NEXTTX[ACCREC-AccountToUpdate+1]>0 THEN}
			IF NEXTTX>0 THEN
			  BEGIN
			    {CURRINT:=NEXTTX[ACCREC-AccountToUpdate+1];}
			    CURRINT:=NEXTTX;
			    PUTITEM(TxFile,16);
			  END;
			{
                        NEXTTX[ACCREC-AccountToUpdate+1]:=RECNO;
			IF PLAST [ACCREC-AccountToUpdate+1]=0 THEN
			   PLAST [ACCREC-AccountToUpdate+1]:=RECNO;
			}
                        NEXTTX:=RECNO;
			IF PLAST=0 THEN
			   PLAST:=RECNO;
			{
                        GETITEM (TxFile,2);
			IF ((LOWTX>0) AND (RECNO  >=LOWTX))
			OR ((LOWDT>0) AND (CURRINT>=LOWDT)) THEN}
                        IF ((LOWTX>0) AND (RECNO  >=LOWTX)) Then
			  {PFIRST[ACCREC-AccountToUpdate+1]:=RECNO;}
			  PFIRST := RECNO;
                        //ExitRoutine := ( RecNo < TxEditRec.TransF );
		      END;
		  END;
        NlFile :  BEGIN
		    GETITEM(TxFile,18);
		    DBAC:=CURRINT;
		    GETITEM(TxFile,19);
		    CRAC:=CURRINT;
		    GETITEM(TxFile,17);
		    OK:= ( (DBAC>0) OR (CRAC>0) ) AND (CURRLONG<>0);
		    IF OK THEN
		      OK:= (DBAC=AccountToUpdate) Or (CRAC=AccountToUpdate);
		      {
                      OK:= ( (DBAC>FROMACC-1) AND (DBAC<TOACC+1) )
			OR ( (CRAC>FROMACC-1) AND (CRAC<TOACC+1) );
                      }
		    IF OK THEN
		      BEGIN
			IF (DBAC=AccountToUpdate) THEN
			  BEGIN
			    CURRINT:=0;
			    PUTITEM(TxFile,13);
			    {IF NEXTTX[DBAC-AccountToUpdate+1]>0 THEN}
			    IF NEXTTX>0 THEN
			      BEGIN
				{CURRINT:=NEXTTX[DBAC-AccountToUpdate+1];}
				CURRINT:=NEXTTX;
				PUTITEM(TxFile,13);
			      END;
			    {
                            NEXTTX[DBAC-AccountToUpdate+1]:=RECNO;
			    IF PLAST [DBAC-AccountToUpdate+1]=0 THEN
			       PLAST [DBAC-AccountToUpdate+1]:=RECNO;
			    }
                            NEXTTX:=RECNO;
			    IF PLAST=0 THEN
			       PLAST:=RECNO;
			    {
                            GETITEM (TxFile,2);
			    IF ((LOWTX>0) AND (RECNO  >=LOWTX))
			    OR ((LOWDT>0) AND (CURRINT>=LOWDT)) THEN}
			    IF ((LOWTX>0) AND (RECNO  >=LOWTX)) Then
			      {PFIRST[DBAC-AccountToUpdate+1]:=RECNO;}
			      PFIRST:=RECNO;
                            //ExitRoutine := ( RecNo < TxEditRec.TransF );
			  END;
			IF (CRAC=AccountToUpdate) THEN
			  BEGIN
			    CURRINT:=0;
			    PUTITEM(TxFile,14);
			    {IF NEXTTX[CRAC-AccountToUpdate+1]>0 THEN}
			    IF NEXTTX>0 THEN
			      BEGIN
				{CURRINT:=NEXTTX[CRAC-AccountToUpdate+1];}
				CURRINT:=NEXTTX;
				PUTITEM(TxFile,14);
			      END;
			    {
                            NEXTTX[CRAC-AccountToUpdate+1]:=RECNO;
			    IF PLAST [CRAC-AccountToUpdate+1]=0 THEN
			       PLAST [CRAC-AccountToUpdate+1]:=RECNO;
			    }
                            NEXTTX:=RECNO;
			    IF PLAST=0 THEN
			       PLAST:=RECNO;
			    {
                            GETITEM (TxFile,2);
			    IF ((LOWTX>0) AND (RECNO  >=LOWTX))
			    Or ((LOWDT>0) AND (CURRINT>=LOWDT)) THEN}
			    IF ((LOWTX>0) AND (RECNO  >=LOWTX)) Then
			      {PFIRST[CRAC-AccountToUpdate+1]:=RECNO;}
			      PFIRST:=RECNO;
                            //ExitRoutine := ( RecNo < TxEditRec.TransF );
			  END;
		      END;
		  END;
	    END;
	  END;
	REWRITEREC(TxFile,RECNO);
	IF ERRORNO>0 THEN DbERR;
        Dec ( RecNo );
      END;
      {
      MessageDlg('Last  ' + IntToStr ( plast ), mtInformation,[mbOK], 0);
      MessageDlg('First ' + IntToStr ( pfirst ), mtInformation,[mbOK], 0);
      MessageDlg('Next  ' + IntToStr ( NextTx ), mtInformation,[mbOK], 0);
      }
  END;

  PROCEDURE PHASE2;
  VAR
    FirstYear,
    RECNO : INTEGER;
  BEGIN
    FOR RECNO:=FROMACC TO TOACC DO
      BEGIN
	READREC(FLNO,RECNO);
	IF ERRORNO > 0 THEN DbERR;
	IF RECACTIVE(FLNO) THEN
	  BEGIN
            GetItem ( FlNo, 14 );    // TGM AB 04/03/11
            FirstYear := CurrInt;
	    CASE FLNO OF
	      SlFile,
              PlFile : BEGIN
		         {CURRINT:=NEXTTX[RECNO-FROMACC+1];}
                         If ( FirstYear > NEXTTX ) Then
		            Begin
                               SetItem;
                               CURRINT:=NEXTTX;
                               PUTITEM(FLNO,14);
                            End;
		       END;
              NlFile : IF (RECNO>=Cash1.XBANKMIN) AND (RECNO<=Cash1.XBANKMAX) THEN
		          BEGIN
			     {CURRINT:=NEXTTX[RECNO-FROMACC+1];}
                             If ( FirstYear > NEXTTX ) Then
		                Begin
                                   SetItem;
                                   CURRINT:=NEXTTX;
			           PUTITEM(FLNO,14);
                                End;
                          END;
            END;
            { New }
	    CURRINT:=PFIRST;
            PutItem ( FlNo, 15 );
            {
            GetItem ( FlNo, 15 );
            If ( CurrInt < PFirst ) Then
               Begin
                  SetItem;
	          CURRINT:=PFIRST;
	          PUTITEM(FLNO,15);
               End;
            If ( CurrInt > PLast ) Then
               Begin
                  SetItem;
	          PUTITEM(FLNO,15);
               End;
	    }
            {CURRINT:=PLAST[RECNO-FROMACC+1];}
	    CURRINT:=PLAST;
	    PUTITEM(FLNO,16);
	    REWRITEREC(FLNO,RECNO);
	    IF ERRORNO > 0 THEN DbERR;
	  END;
      END;
  END;

BEGIN
  {
  Application.CreateForm(TWaitingForm, WaitingForm);
  WaitingForm.Show;
  }

  FlNo := UpDateFile;

  SETDB (FLNO);

  FROMACC:= AccountToUpdate;
  TOACC	 := AccountToUpdate;

  LowDt := 0;
  // GM CHANGED NEXT LINE 11/05/02 this solved pointer rest problems when
  //   editing
//  If ( NOT Cash1.xresetnom ) And ( flno = NlFile ) Then
  if flno = NlFile then
     LOWTX := xFirstTx
  Else
    { Auto run so only go to last active tx for year }
    LOWTX := Cash1.XLASTTX+1;

  INIT;
  PHASE1;
  PHASE2;
  {
  WaitingForm.free;
  }
END;

Begin

End.
