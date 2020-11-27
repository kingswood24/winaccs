unit uAccountsHelp;

interface

uses
   SysUtils, HHPack, ShellAPI, Forms, igHHInt, Windows, Dialogs;

procedure ShowHTMLHelp (AHelpStr : String);

implementation
{ TAccountsHelp }

procedure ShowHTMLHelp(AHelpStr: String);
var
   HF : string;
   HelpSocket : TigAppHelpSocket;
begin
   HelpSocket := TigAppHelpSocket.Create(nil);
   with HelpSocket do
      try
         try
            SetCurrentDir(ExtractFilePath(ParamStr(0)));
            HF := ExtractFilePath(ParamStr(0))+'AccountsHelp.chm';
            if ( FileExists(HF) ) then
               begin
                  if (Application.HelpFile <> HF) then
                     begin
                        HelpSocket.CloseAll;
                        Application.HelpFile := HF;
                     end;
                  HelpSocket.HHPopupsSource := psHtmlHelpFile;
                  HelpSocket.HHPopupWindow.BackgroundColor := $FFFFFFFF;
                  
                  HelpSocket.HTMLHelpCommand(HH_DISPLAY_TOPIC,LongInt(PChar(AHelpStr)));
                  if ( HelpSocket.HHShowTopicByName(AHelpStr,False) = 0 ) then
                     ShellExecute(Application.Handle,'Open',PChar(HF),nil,nil,SW_SHOWMAXIMIZED);
               end;
         except
            MessageDlg('Error Executing Help Function. Contact Kingswood.',mtConfirmation,[mbOK],0);
         end;
      finally
         FreeAndNil(HelpSocket);
      end;
end;

end.
