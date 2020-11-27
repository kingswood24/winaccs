unit Global;

interface
uses
   Windows;

const
   cBankNameNotOnFile = 'Bank "%s" was not found on file.';

   { CD Backup Program }
   cCDBackupExeName = 'CDBackup.exe';

   cINTERNET_CONNECTION_NOT_ESTABLISHED = 'An internet connection could not be established.';   
var
   AliasName : string = '';
   DLLHandle : THandle;

implementation

end.
