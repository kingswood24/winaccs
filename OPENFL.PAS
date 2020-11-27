{
  File	    : OPENFL.PAS
  Unit	    : OPENFL
  Prefix    :
  Status    :
                
  DATE'S
  Started   :
  Finished  :

}

Unit OPENFL;

{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

Procedure openfiles;

{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation
Uses
    Dialogs,
    VARS,
    types,
    util,
    PARAMS,
    CALCS,
    FILED,
    DBCORE,
    DBGEN,
    CLEARS;

Procedure openfiles;
VAR
  FLNAME    : STRING;
  X	    : INTEGER;
{-->>  FIRSTTIME : BOOLEAN;}
  POSYEAR   : INTEGER;

  Procedure open_analysis ( dbno : integer );
  Begin
    {
    if NOT xtxanal then
      Begin
	flname := null;
	anl_db := dbno;
	flname := xanl_file;
	if flname <> null then
	  OpenFile ( anl_db, flname );
      End;
    }
  End;

BEGIN

  (*
  anl_db := 0;					     { set the db number to 0 }
  *)
  FOR X:=1 TO 6 DO CCLOSE(X,'N');

{-->>  FIRSTTIME:=TRUE;}
  ESCKEY   :=FALSE;
  REPEAT
    ERRORNO:=0;
 {
    If ( PROG = TxFillGrid ) Then
       Begin
            flname := xentfile;
            OpenFile ( 1, flname );
            If errorno = 0 Then
               Begin
                    flname := xtransfile;
                    OpenFile ( 2, flname );
               End;
            If errorno = 0 Then
               Begin
                    flname := xnlaccfile;
                    OpenFile ( 3, flname );
               End;
            If errorno = 0 Then
               Begin
                    flname := xslaccfile;
                    OpenFile ( 4, flname );
               End;
            If errorno = 0 Then
               Begin
                    flname := xplaccfile;
                    OpenFile ( 5, flname );
               End;
            Exit;
       End;
}
    IF NOT (PROG IN [EVDIARY]) THEN
      BEGIN
	FLNAME :=  Cash2.XENTFILE;
	OpenFile(6,FLNAME);
      END;

    { open livestock files and enterprise, nominal files }
    if (( prog = live_links ) and ( errorno = 0 )) then
      Begin
	flname :=  Cash11.live_lnk;
       	OpenFile ( 4, flname );
	if errorno = 0 then
	  Begin
	    flname :=  Cash11.live_sdb;
	    OpenFile ( 5, flname );
	  End;
	if errorno = 0 then
	  Begin
	    flname :=  Cash2.xnlaccfile;
	    OpenFile ( 3, flname );
	  End;
	if errorno = 0 then
	  Begin
	    flname :=  Cash2.xtransfile;
	    OpenFile ( 2, flname );
	  End;

	{ if there are no errors then exit this procedure }
	if errorno = 0 then exit;
      End;

    IF ERRORNO = 0 THEN
      BEGIN
	FLNAME := NULL;
	CASE PROG OF
	  ENDMONTH,
	  ENDYEAR, SECRET,  CANCEL   : IF NOT Cash1.XCASHBOOK THEN FLNAME:= Cash2.XSLACCFILE;
	  UPDCUST, SALESTX, CUSTREP,
	  CUSTSTM, CUSTLED, CUSTREC  : FLNAME:= Cash2.XSLACCFILE;
	  UPDSUPP, PURCHTX, SUPPREP,
	  SUPPSTM, SUPPLED, SUPPREC  : FLNAME:= Cash2.XPLACCFILE;
	  CASHREP, UPDNOM,  ANNBUD,
	  ENTREP,  SPECREP	     : FLNAME:= Cash2.XNLACCFILE;
	END;
	IF FLNAME<>NULL THEN OpenFile ( 1, FLNAME );

	if errorno = 0 then
	  Begin
	    flname := null;
	    if prog in [custrep, supprep] then
	      Begin
		flname :=  Cash2.xnlaccfile;
     //		if flname <> null then OpenFile ( 4, flname );
	      End;
	  End;
      END;

    IF (PROG IN [SALESTX,PURCHTX]) AND (ERRORNO=0) THEN
      BEGIN
	FLNAME := NULL;
	CASE PROG OF
	  SALESTX : FLNAME :=  Cash2.XPLACCFILE;
	  PURCHTX : FLNAME :=  Cash2.XSLACCFILE;
	END;
     //	OpenFile(4,FLNAME );
      END;

    IF (PROG IN [ENDMONTH,ENDYEAR,SECRET,CANCEL]) AND (ERRORNO=0) THEN
      BEGIN
	IF NOT Cash1.XCASHBOOK THEN
	  BEGIN
	    FLNAME:= Cash2.XPLACCFILE;
	    OpenFile(2,FLNAME );
	  END;
	FLNAME:= Cash2.XNLACCFILE;
	IF ERRORNO=0 THEN OpenFile(3,FLNAME );
	FLNAME:= Cash2.XTRANSFILE;
	IF ERRORNO=0 THEN OpenFile(5,FLNAME );

	{ if clearing transactions open stock file if invoicer and using stock }
	If (( prog = cancel ) And ( Cash2.xinvsys ) And ( Cash2.xinvtype[1] = 'S' ) And
	    ( errorno = 0 )) Then
	  Begin
	    flname :=  Cash2.xstockfile;
	    OpenFile ( 4, flname );
	    If errorno = 0 Then Exit;
	  End;

	if errorno = 0 then
	  Begin
	    flname := null;
	    flname :=  Cash11.xanl_file;
	    if flname <> null then open_analysis ( 4 );
	  End;
	IF ERRORNO=0 THEN EXIT;
      END;

    IF (PROG IN [UPDENT, UPDCUST,UPDSUPP,ENDWEEK,CUSTREC,SUPPREC,
		 CASHINC,CASHEXP,SALESTX,PURCHTX,JOURNAL]) AND (ERRORNO=0) THEN
      BEGIN
	FLNAME:= Cash2.XNLACCFILE;
	OpenFile(3,FLNAME );
      END;

    IF ERRORNO=0 THEN
      BEGIN
	IF PROG IN [UPDENT,UPDCUST,UPDSUPP,
		    UPDNOM,{ANNBUD,} CASHREP,ENDWEEK] THEN EXIT;
	IF PROG=EVDIARY THEN
	  BEGIN
	    FLNAME:= Cash2.XDIARYFILE;
	    POSYEAR:=POS('*',FLNAME);
	    IF POSYEAR>0 THEN
	      IF LENGTH(OPENYEAR)=2 THEN
		BEGIN
		  INSERT ('*',FLNAME,POSYEAR);
		  MOVE (OPENYEAR[1],FLNAME[POSYEAR],2);
		END;
	    OpenFile(1,FLNAME );
	  END
	ELSE
	  BEGIN
	    FLNAME :=  Cash2.XTRANSFILE;
	    OpenFile ( 2, FLNAME );
	  END;

	if errorno = 0 then open_analysis ( 5 );

	IF ERRORNO=0 THEN EXIT;
      END;

    MessageDlg('ENSURE THAT DATA DISK IS LOADED', mtInformation,[mbOK], 0);
{-->>    FIRSTTIME:=FALSE;}
    IF ESCKEY THEN EXIT;
  UNTIL FALSE;
END;

Begin

End.
