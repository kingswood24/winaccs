{
  File	    : ABORT.PAS
  Unit	    : Abort
  Prefix    :
  Status    :
  Level	    :

  DATE'S
  Started   :
  Finished  :

  This unit contains the abort procedure. ABORT is used all over the program
  whether in database access routines.
}


Unit DB_Abort;

{-----------------------------------------------------------------------------}
{--------------------------------  INTERFACE  --------------------------------}
{-----------------------------------------------------------------------------}

Interface

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

Procedure AbortProgram (Smessage : string); Export;

{-----------------------------------------------------------------------------}
{-----------------------------	IMPLEMENTATION	------------------------------}
{-----------------------------------------------------------------------------}

Implementation

Uses
  forms,
  dialogs,
  types,
  filed,
  clears;

{-------------------------  PROCEDURES AND FUNCTIONS  ------------------------}

procedure AbortProgram;
var
  counter : Integer;
begin
  For counter := 1 To 10 Do
      cclose ( counter, 'N' );
  MessageDlg( 'Termination Message ' + Smessage, mtInformation,[mbOK], 0);
  Application.Terminate;
end;

Begin

{-----------------------------	INITIALIZATION	------------------------------}

{-------------------------------  TERMINATION  -------------------------------}

End.

