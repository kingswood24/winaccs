unit Kmessage;

interface
Uses
    WinTypes;

   Procedure ShellExecError ( HndID : THandle );

implementation
Uses
    Dialogs;

Procedure ShellExecError ( HndID : THandle );
Var
   ErrorStr : String;
begin
     { Must be in this range to generate error }
     If HndId < 31 Then
        If HndId In [0,2,3,5,6,8,10,11,12,13,14,15,16,19,20,21] Then
           Begin
                ErrorStr := 'Unknown Error';
                Case HndId Of
                     0 : ErrorStr := 'System out of Memory';
                     2 : ErrorStr := 'File Not Found';
                     3 : ErrorStr := 'Path Not Found';
                     5 : ErrorStr := 'Sharing Error';
                     6 : ErrorStr := 'Data Segment Error';
                     8 : ErrorStr := 'NOT enough memory';
                    10 : ErrorStr := 'Windows Version Error';
                    11 : ErrorStr := 'Executable file was Invalid';
                    12 : ErrorStr := 'Designed for a Different OS';
                    13 : ErrorStr := 'Wrong Version of DOS';
                    14 : ErrorStr := 'Executable UnKnown';
                    15 : ErrorStr := 'Cannot Load REAL MODE Application';
                    16 : ErrorStr := 'Cannot Load 2nd instance';
                    19 : ErrorStr := 'Compressed executables cannot be run';
                    20 : ErrorStr := 'DLL missing';
                    21 : ErrorStr := '32-bit extensions needed';
                end;
                MessageDlg ( ErrorStr, mtInformation, [mbOK], 0 );
           End;
end;

end.
