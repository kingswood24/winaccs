unit uMailboxHelper;

interface
uses
   Windows;
type
  TSendMail2           = function(const AToAddress,
                                        ASubject,
                                        ABody,
                                        AAttachments,
                                        AConfigDirectory : PAnsiChar) : Integer; stdcall;

  TEMailLoginSetting   = procedure(const AConfigDirectory : PAnsiChar); stdcall;

function RegisterChilKat : Boolean;

const
   KingswoodMailBoxDLL = 'kingswoodmailbox.dll';

   cGmailProvider = 'gmail.com';
   cHotmailProvider = 'hotmail.com';
   cLiveCOMProvider = 'live.com';
   cLiveIEProvider = 'live.ie';

   cLivePOPAddress = 'pop3.live.com';
   cLivePOPPort = 995;
   cLiveSMTPAddress = 'smtp.live.com';
   cLiveSMTPPort = 25;

   cGmailPOPAddress =  'pop.gmail.com';
   cGmailPOPPort = 995;
   cGmailSMTPAddress =  'smtp.gmail.com';
   cGmailSMTPPort = 587;
   cGmailSMTPSSLPort = 465;

   cEmailWithAttachment = 2;

   cEmailClient_MS = 'MS Email Client';
   cEmailClient_GMail = 'GMail Email Client';

   cEMailSendError_0 = 'Error sending email.';
   cEMailSendError_1 = cEMailSendError_0+#13#10+#13#10+'An unknown exception has occurred - contact Kingswood';
   cEMailSendError_2 = cEMailSendError_0+#13#10+#13#10+'Error reading file list - contact Kingswood';
   cEMailSendError_3 = cEMailSendError_0+#13#10+#13#10+'An unexpected exception has occurred - contact Kingswood';
   cEMailSendError_4 = cEMailSendError_0+#13#10+#13#10+'Failed to connect to mail server - contact Kingswood';

   cKingswoodMailBoxDLLNotFound = KingswoodMailBoxDLL+' not found - try downloading a new version to install the required files.';
   cKingswoodMailBoxDLLUnableToLoad = 'Unable to load DLL '+KingswoodMailBoxDLL;
   cKingswoodMailBoxDLLCallToFunctionFailed = 'Call to function "'+KingswoodMailBoxDLL+'.%s" failed!';

   cFuncName_SendMail2 = 'SendMail2';

   cActiveXNotRegistered = 'Internal mailBox error - contact Kingswood';

   cChilKatUnlockCode = 'KINGSWMAILQ_Sw8SKMq06J4Z';

   cChilKatFile_ChilkatMail_v7_9DLL = 'ChilkatMail_v7_9.dll';
   cChilKatFile_ChilkatCertDLL = 'ChilkatCert.dll';
   cChilKatFile_ChilkatUtilDLL = 'ChilkatUtil.dll';
var
   SendMail2 :TSendMail2;
   EMailLoginSetting :TEMailLoginSetting;

implementation
uses
   Forms, SysUtils, CHILKATMAILLib2_TLB, Dialogs,
   ShellAPI{, Dialogs}{,Messages};

function RegisterChilKat : Boolean;
var
   MailBox : TChilkatMailMan2;
begin

{
Unlock Code(s)
KINGSWMAILQ_Sw8SKMq06J4Z

Sold To
Gerry Lynskey (info@kingswood.ie)

Support Contact
Name: Matt Fausey
Email: support@chilkatsoft.com
Phone: 630-784-9670
Hours: 9am - 5pm CST, Monday-Friday

Australia: +61 (2) 8006 2660
United Kingdom: +44 (0) 20 8144 6010
Brazil: +55 (11) 3717 5022
}
   Result := False;
   try
      MailBox := TChilkatMailMan2.Create(nil);
      FreeAndNil(MailBox);
      Result := True;
   except
      on e : exception do
         begin
            if (lowercase(E.Message) = 'class not registered') then
               begin
                   WinExec('regsvr32 "C:\Kingsacc\ChilkatMail_v7_9.dll" /s', SW_Hide);
                   Result := True;
               end
         end;
   end;
end;


end.
