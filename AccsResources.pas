unit AccsResources;

interface
uses
  Classes, SysUtils, AccsUtils, Windows, Types;

  procedure ExtractResourceFiles;

resourcestring
   Msg_00001 = 'Please complete editing of the current transaction before moving to another transaction.';
   cKInstallerProgram = 'KInstaller.exe';
   cKInstallerUpdate = 'KInstaller.zip';

   LIBEAY32 = 'libeay32';
   SSLEAY32 = 'ssleay32';
   LIBEAY32_DLL = 'libeay32.dll';
   SSLEAY32_DLL = 'ssleay32.dll';

implementation


procedure ExtractResourceFiles;
var
  ResourceStream : TResourceStream;
  FileStream: TFileStream;
  Filename: string;

begin
   Filename := ApplicationPath + 'DataConvert.exe';
   if not FileExists(Filename) then
      begin
         ResourceStream := TResourceStream.Create(hInstance, 'dataconvert', RT_RCDATA) ;
         try
            FileStream := TFileStream.Create(Filename, fmCreate) ;
            try
               FileStream.CopyFrom(ResourceStream, 0) ;
            finally
               FileStream.Free;
            end;
        finally
           ResourceStream.Free;
        end;
     end;

   Filename := cQRPDFLibLocation;
   if not FileExists(Filename) then
      begin
         ResourceStream := TResourceStream.Create(hInstance, 'qrpdflib', RT_RCDATA) ;
         try
            FileStream := TFileStream.Create(Filename, fmCreate) ;
            try
               FileStream.CopyFrom(ResourceStream, 0) ;
            finally
               FileStream.Free;
            end;
        finally
           ResourceStream.Free;
        end;
     end;


   Filename := ApplicationPath+LIBEAY32_DLL;
   if not FileExists(Filename) then
      begin
         ResourceStream := TResourceStream.Create(hInstance, LIBEAY32, RT_RCDATA) ;
         try
            FileStream := TFileStream.Create(Filename, fmCreate) ;
            try
               FileStream.CopyFrom(ResourceStream, 0) ;
            finally
               FileStream.Free;
            end;
        finally
           ResourceStream.Free;
        end;
     end;

   Filename := ApplicationPath+SSLEAY32_DLL;
   if not FileExists(Filename) then
      begin
         ResourceStream := TResourceStream.Create(hInstance, SSLEAY32, RT_RCDATA) ;
         try
            FileStream := TFileStream.Create(Filename, fmCreate) ;
            try
               FileStream.CopyFrom(ResourceStream, 0) ;
            finally
               FileStream.Free;
            end;
        finally
           ResourceStream.Free;
        end;
     end;
end;

end.
