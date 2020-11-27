Unit ResetPointers;

InterFace

   Procedure AUDITFILES ( option : integer; RunAuto : Char );

Implementation
Uses
    UTIL,
    Vars,
    TYPES,
    DBCore;

{
   Listing of Procedures and Functions contained in this program section
   Seg. AUDITFILES.
   Pro. INIT.
   Pro. ERR.
   Pro. PHASE1.
   Pro. PHASE2.
 }
PROCEDURE AUDITFILES ( option : integer; RunAuto : Char );
CONST
  AUDITMAX = 999;
VAR
  Runs,			{ Store runs completed }
  OldProg : Integer;	{ Store orig prog if RunAuto = 'A' }
  FLNO	  : INTEGER;
  FROMACC : INTEGER;
  TOACC	  : INTEGER;
  LOWTX	  : INTEGER;
  LOWDT	  : INTEGER;
  PFIRST  : PACKED ARRAY[1..AUDITMAX] OF INTEGER;
  PLAST	  : PACKED ARRAY[1..AUDITMAX] OF INTEGER;
  NEXTTX  : PACKED ARRAY[1..AUDITMAX] OF INTEGER;
  ST	  : STRING;

  PROCEDURE INIT;
  VAR
    X : INTEGER;
  BEGIN
    FOR X:=1 TO AUDITMAX DO
      BEGIN
	PFIRST[X]:=0;
	PLAST[X]:=0;
	NEXTTX[X]:=0;
      END;
  END;

  PROCEDURE ERR;
  BEGIN
    EXIT;
  END;

  PROCEDURE PHASE1;
  VAR
    RECNO : INTEGER;
    TXT	  : INTEGER;
    DBAC  : INTEGER;
    CRAC  : INTEGER;
    ACCREC: INTEGER;
    OK	  : BOOLEAN;
  BEGIN
    SETDB (TxFile);
    {
    CLEARFROM (24);
    DIS (1,24,'READING TRANSACTION FILE BACKWARDS ... ');
    }
    FOR RECNO:=DB1.DBRECHIGH DOWNTO 1 DO
      BEGIN
	{
        DIS  (40,24,'	  ');
	DISI (40,24,RECNO,1);
	}
        READREC(TxFile,RECNO);
	IF ERRORNO>0 THEN ERR;
	IF RECACTIVE(TxFile) THEN
	  BEGIN
	    GETITEM(TxFile,1);
	    TXT:=CURRINT;
	    CASE FLNO OF
	      SlFile:  BEGIN
		    OK:= TXT IN [1..4];
		    GETITEM(TxFile,3);
		    ACCREC:=CURRINT;
		    IF OK THEN OK:= (ACCREC>FROMACC-1) AND (ACCREC<TOACC+1);
		    IF OK THEN
		      BEGIN
			CURRINT:=0;
			PUTITEM(TxFile,16);
			IF NEXTTX[ACCREC-FROMACC+1]>0 THEN
			  BEGIN
			    CURRINT:=NEXTTX[ACCREC-FROMACC+1];
			    PUTITEM(TxFile,16);
			  END;
			NEXTTX[ACCREC-FROMACC+1]:=RECNO;
			IF PLAST [ACCREC-FROMACC+1]=0 THEN
			   PLAST [ACCREC-FROMACC+1]:=RECNO;
			GETITEM (TxFile,2);
			IF ((LOWTX>0) AND (RECNO  >=LOWTX))
			OR ((LOWDT>0) AND (CURRINT>=LOWDT)) THEN
			  PFIRST[ACCREC-FROMACC+1]:=RECNO;
		      END;
		  END;
	      PlFile:  BEGIN
		    OK:= TXT IN [5..8];
		    GETITEM(TxFile,3);
		    ACCREC:=CURRINT;
		    IF OK THEN OK:= (ACCREC>FROMACC-1) AND (ACCREC<TOACC+1);
		    IF OK THEN
		      BEGIN
			CURRINT:=0;
			PUTITEM(TxFile,16);
			IF NEXTTX[ACCREC-FROMACC+1]>0 THEN
			  BEGIN
			    CURRINT:=NEXTTX[ACCREC-FROMACC+1];
			    PUTITEM(TxFile,16);
			  END;
			NEXTTX[ACCREC-FROMACC+1]:=RECNO;
			IF PLAST [ACCREC-FROMACC+1]=0 THEN
			   PLAST [ACCREC-FROMACC+1]:=RECNO;
			GETITEM (TxFile,2);
			IF ((LOWTX>0) AND (RECNO  >=LOWTX))
			OR ((LOWDT>0) AND (CURRINT>=LOWDT)) THEN
			  PFIRST[ACCREC-FROMACC+1]:=RECNO;
		      END;
		  END;
	      NlFile:  BEGIN
		    GETITEM(TxFile,18);
		    DBAC:=CURRINT;
		    GETITEM(TxFile,19);
		    CRAC:=CURRINT;
		    GETITEM(TxFile,17);
		    OK:= ( (DBAC>0) OR (CRAC>0) ) AND (CURRLONG<>0);
		    IF OK THEN
		      OK:= ( (DBAC>FROMACC-1) AND (DBAC<TOACC+1) )
			OR ( (CRAC>FROMACC-1) AND (CRAC<TOACC+1) );
		    IF OK THEN
		      BEGIN
			IF (DBAC>FROMACC-1) AND (DBAC<TOACC+1) THEN
			  BEGIN
			    CURRINT:=0;
			    PUTITEM(TxFile,13);
			    IF NEXTTX[DBAC-FROMACC+1]>0 THEN
			      BEGIN
				CURRINT:=NEXTTX[DBAC-FROMACC+1];
				PUTITEM(TxFile,13);
			      END;
			    NEXTTX[DBAC-FROMACC+1]:=RECNO;
			    IF PLAST [DBAC-FROMACC+1]=0 THEN
			       PLAST [DBAC-FROMACC+1]:=RECNO;
			    GETITEM (TxFile,2);
			    IF ((LOWTX>0) AND (RECNO  >=LOWTX))
			    OR ((LOWDT>0) AND (CURRINT>=LOWDT)) THEN
			      PFIRST[DBAC-FROMACC+1]:=RECNO;
			  END;
			IF (CRAC>FROMACC-1) AND (CRAC<TOACC+1) THEN
			  BEGIN
			    CURRINT:=0;
			    PUTITEM(TxFile,14);
			    IF NEXTTX[CRAC-FROMACC+1]>0 THEN
			      BEGIN
				CURRINT:=NEXTTX[CRAC-FROMACC+1];
				PUTITEM(TxFile,14);
			      END;
			    NEXTTX[CRAC-FROMACC+1]:=RECNO;
			    IF PLAST [CRAC-FROMACC+1]=0 THEN
			       PLAST [CRAC-FROMACC+1]:=RECNO;
			    GETITEM (TxFile,2);
			    IF ((LOWTX>0) AND (RECNO  >=LOWTX))
			    OR ((LOWDT>0) AND (CURRINT>=LOWDT)) THEN
			      PFIRST[CRAC-FROMACC+1]:=RECNO;
			  END;
		      END;
		  END;
	    END;
	  END;
	REWRITEREC(TxFile,RECNO);
	IF ERRORNO>0 THEN ERR;
      END;
  END;

  PROCEDURE PHASE2;
  VAR
    RECNO : INTEGER;
  BEGIN
    {
    CLEARFROM (24);
    DIS (1,24,'UPDATING ACCOUNT FILE POINTERS ... ');
    }
    FOR RECNO:=FROMACC TO TOACC DO
      BEGIN
	{
        DIS  (36,24,'	  ');
	DISI (36,24,RECNO,1);
	}
        READREC(FLNO,RECNO);
	IF ERRORNO > 0 THEN ERR;
	IF RECACTIVE(FLNO) THEN
	  BEGIN
	    CASE FLNO OF
	      SlFile,
              PlFile : BEGIN
		      CURRINT:=NEXTTX[RECNO-FROMACC+1];
		      PUTITEM(FLNO,14);
		    END;
              NlFile : IF (RECNO>=Cash1.XBANKMIN) AND (RECNO<=Cash1.XBANKMAX) THEN
		      BEGIN
			CURRINT:=NEXTTX[RECNO-FROMACC+1];
			PUTITEM(FLNO,14);
		      END;
	    END;
	    CURRINT:=PFIRST[RECNO-FROMACC+1];
	    PUTITEM(FLNO,15);
	    CURRINT:=PLAST[RECNO-FROMACC+1];
	    PUTITEM(FLNO,16);
	    REWRITEREC(FLNO,RECNO);
	    IF ERRORNO > 0 THEN ERR;
	  END;
      END;
  END;

BEGIN
  Flno := option;

  SETDB (FLNO);
  FROMACC:=1;
  TOACC	 :=DB1.DBRECHIGH;

  {
  CASE FLNO OF
     SlFile : BETATITLE ('SALES ACCOUNT POINTERS');
     PlFile : BETATITLE ('PURCHASE ACCOUNT POINTERS');
     NlFile : BETATITLE ('NOMINAL ACCOUNT POINTERS');
  END;
  }
      (*
      DIS   (29, 7,'From Account: ');
      DIS   (31, 8,'To Account: ');
      DIS   (32,10,'Max Range: ');
      HDISI (43,10,AUDITMAX,1);
      STR(FROMACC,ST);
      REPEAT
	window_position := 'L';
	disp_options := true;
	allow_exit := false;
	F2_F3_active := true;
	search_action := FLNO + 1;
	search_db := FLNO;

	REC (43,7,4,ST,0, 0, 0, 0, 0, 0 );
	ST:=SCRIN;
      UNTIL ESCKEY OR NUMERIC (SCRINT);
      IF NOT ESCKEY THEN INTVAL (FROMACC,SCRINT);
      IF NOT ESCKEY THEN
	BEGIN
	  TOACC:=FROMACC+998;
	  IF TOACC>DB1.DBRECHIGH THEN TOACC:=DB1.DBRECHIGH;
	  STR (TOACC,ST);
	  REPEAT
	    search_action := FLNO + 1;
	    window_position := 'L';
	    disp_options := true;
	    allow_exit := false;
	    F2_F3_active := true;
	    search_db := FLNO;

	    REC (43,8,4,ST,0, 0, 0, 0,0, 0 );
	    ST:=SCRIN;
	  UNTIL ESCKEY OR NUMERIC (SCRINT);
	  IF NOT ESCKEY THEN INTVAL (TOACC,SCRINT);
	END;
      IF NOT ESCKEY THEN
	BEGIN
	  IF TOACC	       <FROMACC THEN ESCKEY:=TRUE;
	  IF FROMACC+AUDITMAX-1<TOACC	THEN ESCKEY:=TRUE;
	END;
      IF NOT ESCKEY THEN
	BEGIN
	  LOWTX:=1;
	  LOWDT:=0;
	  DIS (5,13,'Lowest Transaction Record to Include: ');
	  DIS (2,14,'OR Lowest Transaction Date	  to Include: ');
	  SETDB(5);
	  REPEAT
	    no_func_key;
	    REC (43,13,5,'1    ',0, 0, 0, 0, 0 ,0);
	  UNTIL	 ESCKEY OR NUMERIC(SCRINT) OR (SCRINT=NULL);
	  IF NOT ESCKEY THEN IF SCRINT<>NULL THEN INTVAL (LOWTX,SCRINT);
	  IF (LOWTX<0) OR (LOWTX>DB1.DBRECHIGH) THEN ESCKEY:=TRUE;
	  IF NOT ESCKEY THEN
	    IF LOWTX=0 THEN
	      BEGIN
		SCRIN:=NULL;
		REPEAT
		  no_func_key;
		  REC (43,14,8,SCRIN,0, 0, 0, 0, 0 ,0);
		UNTIL (SCRINT=NULL) OR (DATEVALID (SCRIN,'DD/MM/YY'));
		IF SCRINT=NULL
		  THEN LOWDT:=0
		  ELSE LOWDT:=TRUNC(DAYTOT-32000);
		IF LOWDT=0 THEN ESCKEY:=TRUE;
	      END;
	END;
    End;
*)

    INIT;
    PHASE1;
    PHASE2;
    FLUSH:=TRUE;

END;

End.
