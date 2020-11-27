unit uAccsSettings;

interface
uses
   MSXML2_TLB, ComObj;

type
   TAccsSettings = class(TObject)
   private
     FDocument : IXMLDOMDocument;
     FRootNode : IXMLDOMNode;
     FDatabaseNode : IXMLDOMNode;
     FTempNode : IXMLDOMNode;
     FDatabaseName: string;
     procedure CheckDatabaseName;
     procedure Initialize;
     function GetLastBackUpDate: TDateTime;
     function GetLastRestoreDate: TDateTime;
     procedure SetLastBackUpDate(const Value: TDateTime);
     procedure SetLastRestoreDate(const Value: TDateTime);
     function GetFileName: string;
     procedure SetDatabaseName(const Value: string);
     procedure CreateDatabaseNode;
     procedure Commit;
     procedure SimpleWrite(ANodeName, ANodeValue : string);
     function SimpleRead(ANodeName: string) : string;
     function GetDateTime(ANodeName : string) : TDateTime;
   public
     property DatabaseName : string read FDatabaseName write SetDatabaseName;
     constructor Create(const ADatabaseName : string);
     destructor destroy;override;

     property LastBackUpDate : TDateTime Read GetLastBackUpDate write SetLastBackUpDate;
     property LastRestoreDate : TDateTime read GetLastRestoreDate write SetLastRestoreDate;
     property FileName : string read GetFileName;
   end;

var
   AccsSettings : TAccsSettings;

{function AccsSettings : TAccsSettings;
begin
   if (_AccsSettings = nil) then
      _AccsSettings := TAccsSettings.Create;
   Result := _AccsSettings;
end;}

const
   cLastRestoreDate = 'lastRestoreDate';
   cLastBackupDate = 'lastBackupDate';

implementation

{ TAccsSettings }

uses
   SysUtils, AccsUtils;

procedure TAccsSettings.CheckDatabaseName;
begin
   if (FDatabaseName = '') then
      raise Exception.Create('DatabaseName cannot be empty');

end;

constructor TAccsSettings.Create(const ADatabaseName : string);
begin
   Initialize();
   DatabaseName := ADatabaseName;
end;

destructor TAccsSettings.destroy;
begin
  inherited;
  FDocument := nil;
end;

procedure TAccsSettings.Initialize;
begin
   FDocument := CreateOleObject('MSXML2.DOMDocument') as IXMLDOMDocument;
   if not FileExists(FileName) then
      begin
         FDocument.appendChild(FDocument.createProcessingInstruction('xml', 'version="1.0" encoding="UTF-8"'));
         FRootNode := FDocument.createElement('settings');
         FDocument.appendChild(FRootNode);
         Commit;
      end
   else
      begin
         FDocument.load(FileName);
         FRootNode := FDocument.selectSingleNode('settings');
      end;
end;

function TAccsSettings.GetLastBackUpDate: TDateTime;
begin
   Result := GetDateTime( cLastBackupDate );
end;

function TAccsSettings.GetLastRestoreDate: TDateTime;
begin
   Result := GetDateTime( cLastRestoreDate );
end;

procedure TAccsSettings.SetLastBackUpDate(const Value: TDateTime);
begin
   SimpleWrite(cLastBackupDate, DateToStr(Value));
end;

procedure TAccsSettings.SetLastRestoreDate(const Value: TDateTime);
begin
   SimpleWrite(cLastRestoreDate, DateToStr(Value));
end;

function TAccsSettings.GetFileName: string;
begin
   Result := ApplicationPath + 'settings.xml';
end;

procedure TAccsSettings.CreateDatabaseNode;
begin
   FDatabaseNode := FDocument.createElement('database');
   FTempNode := FDocument.createElement('databaseName');
   FTempNode.text := FDatabaseName;
   FDatabaseNode.appendChild(FTempNode);
   FRootNode.appendChild(FDatabaseNode);
   FDocument.save(FileName);
end;

procedure TAccsSettings.SetDatabaseName(const Value: string);
var
   i, j : Integer;
   DatabaseNodeList : IXMLDOMNodeList;
begin
   FDatabaseNode := nil;
   FDatabaseName := UPPERCASE(Value);
   CheckDatabaseName();

   FTempNode := FDocument.selectSingleNode('//settings/database');
   if (FTempNode = nil) then
      begin
         CreateDatabaseNode;
         Exit;
      end;

   for i := 0 to FTempNode.childNodes.length-1 do
      begin
         if (FTempNode.childNodes[i].nodeName = 'databaseName') and
            (FTempNode.childNodes[i].text = FDatabaseName) then
            begin
               FDatabaseNode := FTempNode.childNodes[i];
               Break;
            end;
      end;
end;

procedure TAccsSettings.Commit;
begin
   FDocument.save(FileName);
end;

procedure TAccsSettings.SimpleWrite(ANodeName, ANodeValue: string);
begin
   if (FDatabaseNode = nil) then Exit;

   FTempNode := FDatabaseNode.selectSingleNode(ANodeName);
   if (FTempNode=nil) then
      begin
         FTempNode := FDocument.createElement(ANodeName);
         FDatabaseNode.appendChild(FTempNode);
      end;
   FTempNode.text := ANodeValue;
   Commit();
end;

function TAccsSettings.SimpleRead(ANodeName: string): string;
begin
   if (FDatabaseNode = nil) then Exit;

   Result := '';
   try
      FTempNode := FDatabaseNode.selectSingleNode(ANodeName);
      if (FTempNode=nil) then Exit;
      Result := FTempNode.text;
   except
   end;
end;

function TAccsSettings.GetDateTime(ANodeName: string): TDateTime;
var
   tResult : string;
begin
   Result := 0;
   try
      tResult := SimpleRead(ANodeName);
      if (tResult = '') then Exit;
      Result := StrToDate(tResult);
   except
   end;
end;

end.
