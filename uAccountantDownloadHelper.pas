unit uAccountantDownloadHelper;


interface

type
  TDownloadAccountantClientFile = function(AAccountantId, AAccessKey : PChar) : PChar;stdcall;
  TUploadAccountantClientFile = function(AAccountantId, AAccessKey, AClientId, AInFile : PChar) : Boolean;stdcall;
  TGetAvailableAccountants = function(AUserName : PChar) : PChar;stdcall;
  TSetAccountant = function(AUserName, AAccountantId : PChar) : Boolean;stdcall;

const
   cDLLName = 'obclient.dll';

   cFuncName_DownloadAccountantClientFile = 'DownloadAccountantClientFile';
   cFuncName_UploadAccountantClientFile = 'UploadAccountantClientFile';
   cFuncName_GetAccountants = 'GetAccountants';
   cFuncName_SetAccountant = 'SetAccountant';

   cDLLUnableToLoad = 'Unable to load DLL '+cDLLName;
   cDLLCallToFunctionFailed = 'Call to function in '+cDLLName+' failed!';

implementation

end.
