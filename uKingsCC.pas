{
   16/04/19 [V4.4 R0.5] /MK Change - GetSysDir - George (TGM) asked that we check for the Wasys32.dll file in the Kingsacc folder for users
                                                 who have the Accounts on a high security system that doesn't allow access to the Windows directory.
}

unit uKingsCC;

interface

uses
  Forms, Registry, Windows, SysUtils, Classes, Dialogs, Controls,
  FileCtrl; //KRoutines;

type
  tCCRec = Packed Record
     c : array [0..2] of Char;
     d, s, e, u : DWORD;
  end;

  TBackupKCC = record
   a, b : Byte; s1 : DWORD; s2 : DWORD;
   CCRec : TCCRec;
  end;

  function UseKACC : Boolean;
  procedure AddRegistrationCode;
  procedure Readkcc(var ACCRec : tCCRec);
  procedure Writekcc(BKCC : TBackupKCC);
  function StrToDWord(s : String) : LongWord;
  procedure CheckKCC;
  procedure KCC(Reg : Boolean);
  function IntToBin(Value : Int64; NoBits : Word = 64) : String;
  function BinToInt(Value : String) : Int64;
  procedure UpdateExecs(LStr, AStr, BStr, CStr : String);
  function alrinst : Boolean;

var
  TokenSerialNo                  : Integer;
  StrPDLLPath                   : String;
  verd : Integer;


const
   sError = 'Error ';
   StrPDLL = 'wasys32.dll';
   StrKACC  = 'kacc.dll';

   DateBasedCCStart = '13/12/2005';

   ErrorInKCC = sError + '#0';
   InvalidFilePath = sError + '#1';
   FileAccessError = sError + '#2';
   SerialNoError = sError + '#3';
   VolNoError = sError + '#4';
   Auth1Error = sError + '#5';
   Auth2Error = sError + '#6';
   InvalidRegKey = sError + '#7';
   AlreadyInst = sError + '#8';
   HerdCountExceeded = sError + '#15';
   idArray : Array [0..9] of String = ('AFE', 'PKU', 'ZDL', 'FRB', 'WNT', 'XRT', 'GTI', 'MCB', 'ZRT', 'LLU');

implementation
uses
   uRegisterForm;

function GetSysDir : string;
{get window's system directory} 
var 
   PathLen, BuffLen : integer;
begin
   //   16/04/19 [V4.4 R0.5] /MK Change - George (TGM) asked that we check for the Wasys32.dll file in the Kingsacc folder for
   //                                     users who have the Accounts on a high security system that doesn't allow access to the Windows directory.
   if ( FileExists('C:\Kingsacc\'+StrPDLL) ) then
      begin
         Result := 'C:\Kingsacc';
         Exit;
      end;

   PathLen := MAX_PATH + 1;
   SetLength(Result, PathLen);
   repeat
    BuffLen := PathLen;
     PathLen := GetSystemDirectory(PChar(Result), BuffLen);
     if PathLen > 0 then
       SetLength(Result, PathLen)
     else
       raise EWin32Error.Create('Cannot get Windows System directory');
   until PathLen <= BuffLen; 
end;

procedure AddRegistrationCode;
Var
    Registry : TRegistry;
    MaximumComponentLength        : DWORD;
    FileSystemFlags               : DWORD;
    VolSerNo                      : DWORD;
    Serial1, Serial2              : DWORD;
    Serial                        : String;
    pWinDir                       : pChar;
    WinDir                        : String;
    BackupSerial                  : TBackupKCC;
    FileStream                    : TFileStream;
    CCRec                         : tCCRec;
    SerialNumber                  : Integer;
    NoExecs                       : Integer;
    StartDate                     : TDateTime;
    Buffer                        : TCCRec;
    Str : String;
    Ranseed : DWORD;

begin
   {$I-}

   StrPDLLPath := GetSysDir; // need to generate StrPDLL FileName ...

   if StrPDLLPath = '' then
      begin
         MessageDlg('Copy Protection '+InvalidFilePath+#13#10+#13#10+
                    'There has been in error in the program registration.'+#13#10+
                    'Please contact Kingswood for help.',mtError,[mbOk],0);
         Halt(1); { Cannot access the system path. This Dir is used to store the CC DLL File }
      end
   else
      StrPDLLPath := StrPDLLPath +'\'+ StrPDLL;

   if not FileExists(StrPDLLPath) then
      begin
         FileStream := TFileStream.Create(StrPDLLPath, fmCreate);
         FileStream.Free;
      end;

   if not FileExists(StrPDLLPath) then
      begin
         MessageDlg('Copy Protection '+FileAccessError+#13#10+#13#10+
                    'There has been in error in the program registration.'+#13#10+
                    'Please contact Kingswood for help.',mtError,[mbOk],0);
         Halt(1); { DLL file was was not created in system path }
      end;

 //  FillChar(BackupSerial, SizeOf(TBackupKCC), #0);

   FileStream := TFileStream.Create(StrPDLLPath, fmOpenReadWrite);
   FileStream.Seek(-Sizeof(BackupSerial), soFromEnd);
   FileStream.Read(BackupSerial, sizeof(BackupSerial));
   FileStream.Free;

   {$I+}
   with BackupSerial do
      if (BackupSerial.A = 87) and (BackupSerial.B = 29) then
         begin
            Registry := TRegistry.Create;
            Registry.OpenKey('Software\Kingswood\kacc', True);
            Registry.WriteString('Serial Number', IntToStr(s1) + 'x' + IntToStr(S2) );
            Registry.Free;
            Exit;
         end;

   GetVolumeInformation ('C:\', nil, 0, @VolSerNo, MaximumComponentLength, FileSystemFlags, nil, 0);

   Registry := TRegistry.Create;
   Registry.OpenKey('Software\Kingswood\kacc', True);
   Serial := Registry.ReadString('Serial Number');

   if Serial = '' then
      begin

         { We need to access the kacc file, this file contains the encrypted Serial + NoExes }
         ReadKCC(BackupSerial.CCRec);

         { Create First Serial Number }
         Serial1 := (VolSerNo and $FFFF0000);
         Serial1 := ((BackupSerial.CCRec.s + $31057810)  xor Serial1 );

         { Create Second Serial Number }
         Serial2 := (VolSerNo and $FFFF);
         Serial2 := ((BackupSerial.CCRec.s + $93546150) xor Serial2 );

         { Write concacted serial number (Serial1 + "x" +Serial2) to the registry  }
         Registry.WriteString('Serial Number', IntToStr(Serial1) + 'x' + IntToStr(Serial2));

         { Again ensure DLL Path is not empty }
         if StrPDLLPath = '' then
            begin
               MessageDlg('Copy Protection '+InvalidFilePath+#13#10+#13#10+
                          'There has been in error in the program registration.'+#13#10+
                          'Please contact Kingswood for help.',mtError,[mbOk],0);
               Registry.Free;
               Halt(1);
            end;

         { Now create the file offset }
         FileStream := TFileStream.Create(StrPDLLPath, fmCreate);
         FileStream.Free;

         { Now create stream again }
         FileStream := TFileStream.Create(StrPDLLPath, fmOpenReadWrite);
         FileStream.Seek(0, soFromEnd);
         with BackupSerial do
            begin
               a := 87;
               b := 29;
               s1 := Serial1;
               s2 := Serial2;
            end;

         { Write the record to the Stream }
         FileStream.Write(BackupSerial, sizeof(BackupSerial));
         FileStream.Free;
      end;
   Registry.Free;
end;

function StrToDWord(s : String) : DWORD;
var i, r, m : DWORD;
begin
   r := 0; m := 1;
   for i := Length(s) downto 1 do begin
       r := r + (m*DWORD(StrToInt(s[i])));
       m := m * 10;
   end;
   StrToDWord := r;
end;

procedure KCC(Reg : Boolean);
var
    Registry : TRegistry;
    MaximumComponentLength        : DWORD;
    FileSystemFlags               : DWORD;
    Serial1, Serial2              : DWORD;
    Auth1, Auth2                  : DWORD;
    FirstDateRun                  : DWORD;
    Serial                        : String;
    AuthKey                       : String;
    daysleftstr                   : string;
    StrPDLLPath                   : String;
    TempStr                       : String;
    VolSerNo                      : DWORD;
    StoredVolLabel                : DWORD;
    FileStream                    : TFileStream;
    BackupSerial                  : TBackupKCC;
    daysleft                      : Integer;
    enddate                       : Tdate;
    SerialNumber                  : Integer;
    NoExecs                       : Integer;
    StartDate                     : TDateTime;
    Buffer                        : TCCRec;
    TempE                         : DWORD;
    DateOnFile : TDateTime;
    HerdCount : Integer;
begin

   GetVolumeInformation(nil, nil, 0, @VolSerNo, MaximumComponentLength, FileSystemFlags, nil, 0);

   Registry := TRegistry.Create;
   Registry.OpenKey('Software\Kingswood\kacc', True);
   Serial := Registry.ReadString('Serial Number');
   Registry.Free;
   if Serial <> '' then
      begin
         try
            Serial1 := StrToDWord(Copy(Serial, 1, Pos('x', Serial)-1));
            Serial2 := StrToDWord(Copy(Serial, Pos('x', Serial) + 1, Length(Serial) - Pos(Serial, '.') + 1));
         except
            MessageDlg('Program has not been properly installed - no windows registry key found!', mtError, [mbOK], 0);
            Application.Terminate;
         end;

         {$I-}
         StrPDLLPath := GetSysDir; // need to generate StrPDLL FileName ...
         if StrPDLLPath = '' then
            begin
               MessageDlg('Copy Protection '+InvalidFilePath+#13#10+#13#10+
                          'There has been in error in the program registration.'+#13#10+
                          'Please contact Kingswood for help.',mtError,[mbOk],0);
               Application.Terminate; { Cannot access the system path. This Dir is used to store the CC DLL File }
            end
         else
            StrPDLLPath := StrPDLLPath +'\'+ StrPDLL;

         FileStream := TFileStream.Create(StrPDLLPath, fmOpenReadWrite);
         FileStream.Seek(-Sizeof(BackupSerial), soFromEnd);
         FileStream.Read(BackupSerial, Sizeof(BackupSerial));
         FileStream.Free;

         TokenSerialNo := ( BackupSerial.CCRec.s xor $4859 );

         {$I+}
         with BackupSerial do
            if (s1 <> Serial1) or (s2 <> Serial2) then
               begin
                  MessageDlg('Copy Protection '+SerialNoError, mtError, [mbOK], 0);
                  if not Bool(RegistrationForm) then
                     Application.CreateForm(TRegistrationForm, RegistrationForm);
                  RegistrationForm.Label4.Caption := IntToStr(BackupSerial.CCRec.s xor $4859);
                  RegistrationForm.ShowModal;
                  if RegistrationForm.AccRun then
                     RegistrationForm.Free
                  else
                     begin
                        RegistrationForm.Free;
                        Halt(1);
                     end;
               end;

//         FirstDateRun   := (Serial1 and $FFFF);
         Serial1 := (( BackupSerial.CCRec.s + $31057810) xor Serial1 );
         Serial2 := (( BackupSerial.CCRec.s + $93546150) xor Serial2 );

         StoredVolLabel := ( Serial1 and $FFFF0000 ) + ( Serial2 and $FFFF );
         if ( StoredVolLabel <> VolSerNo ) then
            begin
               MessageDlg('Copy Protection '+VolNoError, mtError, [mbOK], 0);
               Application.Terminate;
               if not Bool(RegistrationForm) then
                  Application.CreateForm(TRegistrationForm, RegistrationForm);
               RegistrationForm.Label4.Caption := IntToStr(BackupSerial.CCRec.s xor $4859);
               RegistrationForm.ShowModal;
               if RegistrationForm.AccRun then
                  RegistrationForm.Free
               else
                  begin
                     RegistrationForm.Free;
                     Halt(1);
                  end;
             end;

         Registry := TRegistry.Create;
         Registry.OpenKey('Software\Kingswood\kacc', True);
         AuthKey  := Registry.ReadString('Authorisation Key');
         Registry.Free;

         DateOnFile := (BackupSerial.CCRec.d xor (( BackupSerial.CCRec.s xor $4859 ) * 100));

         if AuthKey <> '' then
            begin
               try
                  Auth1 := StrToDWord(Copy(AuthKey, 1, Pos('x', AuthKey)-1));
                  Auth2 := StrToDWord(Copy(AuthKey, Pos('x', AuthKey)+1, Length(AuthKey) - Pos(AuthKey, '.')+1));
                  Auth1 := Auth1 and $FFFFFFFF;
               except
                   MessageDlg('Copy Protection '+ Auth1Error, mtError, [mbOK], 0);
                   MessageDlg('Invalid Registration Key - Check that you have typed all the digits correctly and seperated them with one x', mtError, [mbOK], 0);
                   Registry := TRegistry.Create;
                   Registry.OpenKey('Software\Kingswood\kacc', True);
                   Registry.WriteString('Authorisation Key', '');
                   Registry.Free;
                   Halt(1);
               end;

               if (Auth1 <> ((VolSerNo xor $FFFFFFFF) AND $FFFFFFFE)) then
                  begin
                     MessageDlg('Copy Protection '+ Auth1Error, mtError, [mbOK], 0);
                     MessageDlg('Invalid Registration Key - Check that you have typed all the digits correctly and seperated them with one x', mtError, [mbOK], 0);
                     Registry := TRegistry.Create;
                     Registry.OpenKey('Software\Kingswood\kacc', True);
                     Registry.WriteString('Authorisation Key', '');
                     Registry.Free;
                     Halt(1);
                  end;

               Auth2 := (Auth2 and $FFFF0000);

               if Auth2 = $92650000 then
                  begin
                     if Reg then
                        MessageDlg('Program verification accepted',mtInformation,[mbOk],0)
                     else
                        begin
                           if ( DateOnFile > StrToDate(DateBasedCCStart) ) then
                              begin
                                 if ( DateOnFile > Date ) then//
                                    begin
                                       ShowMessage('Program licence has expired. Please contact Kingswood to renew program licence');
                                       Halt(1);
                                    end
                                 else
                                    // To be done: store the last date used. further check to ensure date integrity
                              end
                           else
                              begin
                                 // allow
                              end;
                        end;
                  end
               else
                  begin
                     MessageDlg('Copy Protection '+Auth2Error, mtError, [mbOK], 0);
                     if Reg then
                        begin
                           Registry := TRegistry.Create;
                           //Registry.OpenKey('Software\Kingswood\Herd', True);
                           Registry.DeleteKey('Software\Kingswood\kacc\Authorisation Key');
                           Registry.Free;
                           MessageDlg('Invalid Registration Key - Check that you have typed all the digits correctly and seperated them with one x', mtError, [mbOK], 0);
                        end;
                     Halt(1);
                  end;
            end
         else
            begin
               verd := 96536;
               { We need to access the kcc file, this file contains StartDate + Serial + NoExes }
               //StartDate := ( Buffer.d xor $EEEEEEEE ); reserved for future use.
               SerialNumber := ( BackupSerial.CCRec.s xor $4859 );
               // Maybe check with def file here. This is how we'll determine if file was contents where changed.
               {if ( BackupSerial.CCRec.e xor $FFFF) < SerialNumber then
                  begin
                     MessageDlg('Copy Protection '+SerialNoError, mtError, [mbOK], 0);
                     Halt(1);
                  end;}

               TokenSerialNo := SerialNumber;

               NoExecs := ( BackupSerial.CCRec.e xor ( SerialNumber * 100 )) div SerialNumber;
               // implementation of date based cc on/after 07/12/2005

               if ( NoExecs > -1 ) then
                  Dec(NoExecs);

               if (( NoExecs > -1 ) and ( NoExecs <= 10 )) then
                  begin
                     Application.MessageBox(PChar(Format('There are %d executions left.    ', [NoExecs])),'Kingswood Herd', MB_OK + MB_ICONWARNING );
                     Application.ProcessMessages;
                  end
               else if NoExecs <= 0 then
                  begin
                     ShowMessage('All Executions have been used. Trial period is now over.');
                //     Application.Terminate;
                     NoExecs := 0;
                     BackupSerial.CCRec.e := ( (( NoExecs * SerialNumber )) xor (SerialNumber * 100) );
                     WriteKCC(BackupSerial);
                     if not Bool(RegistrationForm) then
                        Application.CreateForm(TRegistrationForm, RegistrationForm);
                     RegistrationForm.Label4.Caption := IntToStr(BackupSerial.CCRec.s xor $4859);
                     RegistrationForm.ShowModal;
                     if RegistrationForm.AccRun then
                        RegistrationForm.Free
                     else
                        begin
                           RegistrationForm.Free;
                           Halt(1);
                        end;
                  end;
               BackupSerial.CCRec.e := ( (( NoExecs * SerialNumber )) xor (SerialNumber * 100) );
               WriteKCC(BackupSerial);
            end;
      end
   else
      begin
         MessageDlg('Copy Protection '+InvalidRegKey, mtError, [mbOK], 0);
         Halt(1);
      end;
end;

procedure CheckKCC;
begin
   application.processmessages;
   Kcc(False);
end;

procedure Readkcc(var ACCRec : tCCRec);
var
   FileStream : TFileStream;
begin
  {$I-}
   if alrinst then
      begin
         MessageDlg('Copy Protection '+AlreadyInst+#13#10+#13#10+
                    'There has been in error in the program registration.'+#13#10+
                    'Please contact Kingswood for help.',mtError,[mbOk],0);
         Halt(1);
      end;
   if not(FileExists(ExtractFilePath(ParamStr(0))+ '\' + StrKACC)) then
      begin
         MessageDlg('Copy Protection '+ErrorInKCC+#13#10+#13#10+
                    'There has been in error in the program registration.'+#13#10+
                    'Please contact Kingswood for help.',mtError,[mbOk],0);
         Halt(1);
      end;

   FileStream := TFileStream.Create(ExtractFilePath(ParamStr(0)) +'\'+StrKACC, fmOpenReadWrite);
   FileStream.Seek(-Sizeof(TCCRec), soFromEnd);
   FileStream.ReadBuffer(ACCRec, Sizeof(TCCRec));

   try
     StrToInt(ACCRec.c[0]);
   except
     ACCRec.c[0] := #0; // No valid number of herds found. set array to null. do not do herdcount check if array is null.
     ACCRec.c[1] := #0;
     ACCRec.c[2] := #0;
   end;
   FileStream.Free;
   DeleteFile(ExtractFilePath(ParamStr(0)) +'\'+StrKACC);
   {$I+}
end;

procedure Writekcc(BKCC : TBackupKCC);
var
   FileStream : TFileStream;
begin
   { Now create stream again }
   StrPDLLPath := GetSysDir; // need to generate StrPDLL FileName ...
         if StrPDLLPath = '' then
            begin
               MessageDlg('Copy Protection '+InvalidFilePath+#13#10+#13#10+
                          'There has been in error in the program registration.'+#13#10+
                          'Please contact Kingswood for help.',mtError,[mbOk],0);
               Application.Terminate; { Cannot access the system path. This Dir is used to store the CC DLL File }
            end
         else
            StrPDLLPath := StrPDLLPath +'\'+ StrPDLL;
   {$I-}
   FileStream := TFileStream.Create(StrPDLLPath, fmOpenReadWrite);
   FileStream.Seek(0, soFromEnd);
   FileStream.WriteBuffer(BKCC, sizeof(BKCC));
   FileStream.Free;
   {$I+}
end;

function UseKACC : Boolean;
begin
   SetCurrentDir(ExtractFilePath(ParamStr(0)));
   Result := not(FileExists(ExtractFilePath(ParamStr(0))+'\WACCSCC.DLL'));
end;

function IntToBin(Value : Int64; NoBits : Word = 64) : String;
var
  rVar : Variant;
  i, iLen : Byte;
begin
   RVar := '';

   Case NoBits of
      32 : Value := dWord(Value);
      16 : Value := word(Value);
      8 : Value := Byte(Value);
   end;

   while Value <> 0 do
      begin
         rVar := Char(48 + (Value and 1)) + rVar;
         Value := Value shr 1;
      end;

   if rVar = '' then
      rVar := '0';

   while Length(rVar) < NoBits do
      rVar := '0' + rVar;

   Result := rVar;
end;

function BinToInt(Value : String) : Int64;
var
  rVar : Int64;
  i, iLen : Byte;
begin
   Value := UPPERCASE(Value);
   if Value[Length(Value)] = 'B' then
      Delete(Value, Length(Value), 1);

   rVar := 0;
   for i := 1 to Length(Value) do
      begin
         if not (Value[i] in ['0', '1']) then
            begin
               rVar := 0;
               Break;
            end;
         rVar := (rVar shl 1) + (Byte(Value[i]) and 1);
      end;
   Result := rVar;
end;

procedure UpdateExecs(LStr, AStr, BStr, CStr : String);
var
   BackupKCC : TBackupKCC;
   FileStream : TFileStream;
   SerialNo : Integer;
   NoExecs : INteger;
   tDate : DWORD;
   tExecs : DWORD;
   tSerialNo : DWORD;
   UpdSerialNo : Integer;
   UpdDate : TDateTime;
   i,
   UpdExecs : Integer;
   UpdNo : Integer;
   f : LongInt;
   TokenFound : Boolean;
begin
// AB   StrPDLLPath := GetSysDir;
   if StrPDLLPath = '' then
      begin
         MessageDlg('Copy Protection '+InvalidFilePath+#13#10+#13#10+
                    'There has been in error in the program registration.'+#13#10+
                    'Please contact Kingswood for help.',mtError,[mbOk],0);
         Halt(1);
         { Cannot access the system path. This Dir is used to store the CC DLL File }
      end
   else
      StrPDLLPath := StrPDLLPath +'\'+ StrPDLL;

   if not FileExists(StrPDLLPath) then
      begin
         MessageDlg('Copy Protection '+FileAccessError+#13#10+#13#10+
                    'There has been in error in the program registration.'+#13#10+
                    'Please contact Kingswood for help.',mtError,[mbOk],0);
         Halt(1);
      end;

   {$I-}
   FileStream := TFileStream.Create(StrPDLLPath, fmOpenReadWrite);
   FileStream.Seek(-Sizeof(TBackupKCC), soFromEnd);
   FileStream.Read(BackupKCC, Sizeof(TBackupKCC));

   TokenFound := False;
   for i := Low(idarray) to High(idArray) do
       if idArray[i] = LStr then
          begin
             TokenFound := True;
             UpdNo := i+1;
          end;

   if not (TokenFound) then
      begin
         MessageDlg('Copy Protection Error #9'+#13#10+#13#10+
                    'There has been in error in the program registration.'+#13#10+
                    'Please contact Kingswood for help.',mtError,[mbOk],0);
         Halt(1);
      end;

   SerialNo := ( BackupKCC.CCRec.s xor $4859);

   f := UpdNo * SerialNo * 100;

   try
      tDate := StrToInt(AStr);
   except
      MessageDlg('Copy Protection Error #12'+#13#10+#13#10+
                 'There has been in error in the program registration.'+#13#10+
                 'Please contact Kingswood for help.',mtError,[mbOk],0);
      Halt(1);
   end;

   UpdDate := ( tDate xor f );
   if UpdDate <> Round(Date) then
      begin
         FileStream.Free;
         MessageDlg('Copy Protection Error #10 ',mtError,[mbOK],0);
         Exit;
      end;

   try
      tSerialNo := StrToInt(BStr);
   except
      MessageDlg('Copy Protection Error #13'+#13#10+#13#10+
                 'There has been in error in the program registration.'+#13#10+
                 'Please contact Kingswood for help.',mtError,[mbOk],0);
      Halt(1);
   end;

   UpdSerialNo := ( tSerialNo xor f );
   if UpdSerialNo <> SerialNo then
      begin
         FileStream.Free;
         MessageDlg('Copy Protection Error #11. Error in registration code. Please check code and re-enter',mtError,[mbOK],0);
         Exit;
      end;

   try
     tExecs := StrToInt(CStr);
   except
      MessageDlg('Copy Protection Error #14'+#13#10+#13#10+
                 'There has been in error in the program registration.'+#13#10+
                 'Please contact Kingswood for help.',mtError,[mbOk],0);
      Halt(1);
   end;

   UpdExecs := (( tExecs xor f ) div SerialNo);
   if (UpdExecs > 0 ) and ( UpdExecs <= 99 ) then
       begin
          MessageDlg(Format('You have topped up your executions by %d', [UpdExecs]),mtInformation,[mbOk],0);
          BackupKCC.CCRec.u := tDate;
          BackupKCC.CCRec.e := ((( UpdExecs * SerialNo )) xor (SerialNo * 100) );
          FileStream.Write(BackupKCC, sizeof(BackupKCC));
      end
   else
      begin
         MessageDlg('An unexpected error occurred, please try again.',mtError,[mbOK],0);
         FileStream.Free;
         Halt(1);
      end;
   FileStream.Free;
   {$I+}
end;

function alrinst : Boolean;
var
   FileStream : TFileStream;
   BackupSerial : TBackupKCC;
begin
   Result := True;
   {$I-}
   FileStream := TFileStream.Create(StrPDLLPath, fmOpenReadWrite);
   FileStream.Seek(-Sizeof(BackupSerial), soFromEnd);
   FileStream.Read(BackupSerial, sizeof(BackupSerial));
   FileStream.Free;
   {$I+}
   Result := (BackupSerial.a = 87) and (BackupSerial.b = 29);
end;



end.

