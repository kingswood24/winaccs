unit uAccsSync;

interface
uses
  db, dbTables, MSXML2_TLB, ComObj, Windows, SysUtils, Dialogs,
  contnrs, classes, ShellApi;

const
  NominalSync  = 1;
  EntpriseSync = 2;
  CustomerSync = 3;
  ProductSync  = 4;
  AnalysisType = 5;

type
  TSyncOp = (soSyncDataIn, soSyncDataOut);
  TSyncDirection = (soSyncDataBothWays, soSyncDataToServerOnly);
  TSyncRecordType = (rtNominal,rtEntprise,rtCustomer,rtProduct,rtAnalysisType);

  TSyncParams = class
  private
    FResetSyncFlagsBeforeStart: Boolean;
    FDatabaseName: string;
    FOutputExtendedStatementData: Boolean;
    FOutputAgeOfDebtAnalysisData: Boolean;
    FAgeOfDebtAgedByMonth: Integer;
    FSyncType: TSyncOp;
    FIsValid: Boolean;
    FFileName: string;
    FOutputJobCardReport: Boolean;
    FOutputProformaReport: Boolean;
  public
    constructor create(AParams : TStrings);
    property SyncType : TSyncOp read FSyncType write FSyncType;
    property IsValid : Boolean read FIsValid write FIsValid;
    property ResetSyncFlagsBeforeStart : Boolean read FResetSyncFlagsBeforeStart;
    property DatabaseName : string read FDatabaseName;
    property OutputAgeOfDebtAnalysisData : Boolean read FOutputAgeOfDebtAnalysisData;
    property AgeOfDebtAgedByMonth : Integer read FAgeOfDebtAgedByMonth;
    property OutputExtendedStatementData : Boolean read FOutputExtendedStatementData;
    property OutputJobCardReport : Boolean read FOutputJobCardReport;
    property OutputProformaReport : Boolean read FOutputProformaReport;
    property FileName : string read FFileName write FFileName;
  end;

  TAccsSync = class
  private
     FDatabasePath : string;

     FSyncParams : TSyncParams;
     FAccsSync : TTable;

     FEntsFile : TQuery;

     FDocument : IXMLDOMDocument;
     FRootNode,
     FNode,
     FTopNode: IXMLDOMNode;
     FChildNode : IXMLDOMNode;

     FCompanyNode : IXMLDOMNode;
     FCompaniesNode : IXMLDOMNodeList;

     FQuery : TQuery;

     FSyncIds : TTable;

     // Guid storing unique reference to company on server.
     FCompanyId : string;
     FCanSync : Boolean;

     procedure Initialize(ASyncOp : TSyncOp);
     procedure FreeAndNilObjects;

     procedure CreateLogEntry(ALogEntry : String);
     procedure FlagAsSynchronized(AIds : array of Integer; ASyncType : TSyncRecordType);
  public
     constructor Create;
     destructor Destroy;override;
     class procedure CreateSyncData(ASyncParams : TSyncParams);
     class procedure ReadSyncData(ASyncParams :TSyncParams);
     class procedure MarkAsSynchronized(const ADatabasePath : string);
  end;

  procedure ResetSyncFlags(const ANotifySuccess : Boolean; const ADatabasePath : string);
  procedure Sync(AParams : TStrings);
  function IntArrayToSQLInString( const AValue : array of Integer ) : string;
  procedure InvokeFarmSyncProgram(AHandle : Hwnd; AParams : string);

const
   DefaultDirectory  = 'C:\Kingsacc';
   SyncTables : array [TSyncRecordType] of string = ('NLFile', 'EntsFile', 'SLFile', 'Products', 'Analysis');
   SyncTableKeys : array [TSyncRecordType] of string = ('NLNo', 'EntNo', 'SLNo', 'Id', 'Number');

var
   SESSION_PASSWORD_PROTECTED : Boolean = False;

implementation
uses
   FileCtrl, uApplicationLog, Types, AccsUtils, XMLExport, uPreferences, uPreferenceConsts,KRoutines,
   SystemDefinition;

   procedure Sync(AParams : TStrings);
   var
      SyncParams : TSyncParams;
  begin
      SyncParams := TSyncParams.Create(AParams);
      if not (SyncParams.IsValid) then
      begin
         //KRoutines.CreateLogEntry('Sync Params Invalid','C:\Kingsacc\Services\log.txt');
         Exit;
      end;

      if (SyncParams.SyncType = soSyncDataOut) then
         TAccsSync.CreateSyncData(SyncParams)
      else
         TAccsSync.ReadSyncData(SyncParams);
   end;

  procedure ResetSyncFlags(const ANotifySuccess : Boolean; const ADatabasePath : string);
     procedure ResetSyncStatus(AATableName : string);
     begin
        with TQuery.Create(nil) do
           try
              DatabaseName := ADataBasePath;
              SQL.Clear;
              SQL.Add('UPDATE '+ AATableName +' SET IsSynchronized = False');
              ExecSQL;
           finally
              Free;
           end;
     end;
  var
     SyncRecordType : TSyncRecordType;
  begin
     try
        for SyncRecordType := Low(SyncTables) to High(SyncTables) do
           ResetSyncStatus(SyncTables[SyncRecordType]);

        if (ANotifySuccess) then
           MessageDlg('Data sync flags have been successfully reset.',mtInformation,[mbOK],0);
     except
        if (ANotifySuccess) then
           MessageDlg('An error occurred while resetting the data sync flags.',mtError,[mbOK],0);
     end;
  end;

function IntArrayToSQLInString( const AValue : array of Integer ) : string;
var
   I : Integer;
begin
   Result := '';
   if Length( AValue ) = 1 then
      begin
         Result := '(' + IntToStr( AValue[ 0 ] ) +')';
      end
   else
      begin
         for I := 0 to Length( AValue ) - 1 do      // Iterate
            begin
               if ( AValue[ I ] >= 0) then  // << ensure only numbers greater than 0 are output to result
                  begin
                     if Length( Result ) = 0 then
                        Result := '(' + IntToStr( AValue[ I ] )
                     else
                        Result := Result +', '+  IntToStr( AValue[ I ] );
                  end;
            end;  // for
         if Result <> '' then
            Result := Result + ')'
         else
            Result := Result + '()'
       end;
end;

procedure InvokeFarmSyncProgram(AHandle : Hwnd; AParams : string);
var
   ProgramToStart : string;
begin
  ProgramToStart := 'C:\Kingsacc\Services\FarmSync.exe';
   try
      if FileExists(ProgramToStart) then
         ShellExecute(AHandle, 'open', pChar(ProgramToStart),
            PChar(AParams) , nil, SW_SHOWNORMAL)
      else
         messagedlg('The Kingswood FarmSync program is not installed,'+#13+
                    'or cannot be found.',mtError,[mbOK],0);
   except
      MessageDlg('Error Opening Kingswood FarmSync program.',mtError,[mbOK],0);
   end;

end;

{ TAccsSync }

constructor TAccsSync.Create;
begin
   ForceDirectories(DefaultDirectory +'\Services');
end;

procedure TAccsSync.CreateLogEntry(ALogEntry: String);
begin
   ALogEntry := Format('[START: %s]',[FormatDateTime('dd/MM/yyyy hh:nn:ss',Now)]) + #13#10 + #13#10 +
                       ALogEntry + #13#10 + #13#10 +
                       '[END]' + #13#10 + #13#10;
   InsertAllText(ALogEntry, DefaultDirectory +'\Services\log.txt');
end;

class procedure TAccsSync.CreateSyncData(
  ASyncParams: TSyncParams);
var
   Filename : string;
   AccsSync : TAccsSync;

   MyArray : array of Integer;
   ArrayIndex : Integer;
   initialtime, elapsedtime: DWord;
   NomProdRelationship : string;
begin
   initialtime := Windows.GetTickCount;
   SetLength(MyArray, 0);

   AccsSync := TAccsSync.Create;
   //KRoutines.CreateLogEntry('AccsSync created','C:\Kingsacc\Services\log.txt');
   with AccsSync do
      try
         FSyncParams := ASyncParams;

         try
            FDatabasePath := IncludeTrailingBackSlash(DefaultDirectory) + FSyncParams.DatabaseName;
            if not DirectoryExists(FDatabasePath) then
               begin
                  CreateLogEntry(Format('Database path not found %s',[FDatabasePath]));
                  Exit;
               end;

            if (FSyncParams.ResetSyncFlagsBeforeStart) then
               ResetSyncFlags(false,FDatabasePath);

            if (FSyncParams.FOutputAgeOfDebtAnalysisData) then
               begin
                  OutputCustomerAgeOfDebtAsXML(FSyncParams.DatabaseName, // Accounts company name eg ACCS - not case sensitive
                                               FDatabasePath + '\ageOfDebt.xml', // Filename for export file e.g. 'c:\test.xml'
                                               Date(), // Start date for the report (should by default be the current date)
                                               FSyncParams.AgeOfDebtAgedByMonth, // The number of months included in each field - choices are 1,2,3,6,9 or 12 as per Accounts report
                                               False); // True / False to include zero transactions, including zero balance transactions will give a history breakdown
                                                       // & turnover figure even though there is no current balance
                  if (FileExists(FDatabasePath + '\ageOfDebt.xml')) then
                     CreateLogEntry('Age of Debt output created.')
                  else
                     CreateLogEntry('Age of Debt output failed.');
               end
            else
               CreateLogEntry('Age of Debt not selected for output.');

            if (FSyncParams.FOutputExtendedStatementData) then
               begin
                  OutputCustomerExtendedStatementAsXML(FSyncParams.DatabaseName, // Accounts company name eg ACCS - not case sensitive
                                               FDatabasePath + '\extendedstatement.xml'); // Filename for export file e.g. 'c:\test.xml'
                  if (FileExists(FDatabasePath + '\extendedstatement.xml')) then
                     CreateLogEntry('Extended statement output created.')
                  else
                     CreateLogEntry('Extended statement output failed.');
               end
            else
               CreateLogEntry('Extended statement not selected for output.');

            if (FSyncParams.OutputJobCardReport) then
               begin
                  OutputProformaAsXML('J',
                                      FSyncParams.DatabaseName, // Accounts company name eg ACCS - not case sensitive
                                      FDatabasePath + '\jobcardreport.xml'); // Filename for export file e.g. 'c:\test.xml'
                  if (FileExists(FDatabasePath + '\jobcardreport.xml')) then
                     CreateLogEntry('Job Card report output created.')
                  else
                     CreateLogEntry('Job Card report output failed.');
               end
            else
               CreateLogEntry('Job Card report not selected for output.');

            if (FSyncParams.OutputProformaReport) then
               begin
                  OutputProformaAsXML('P',
                                      FSyncParams.DatabaseName, // Accounts company name eg ACCS - not case sensitive
                                      FDatabasePath + '\proformareport.xml'); // Filename for export file e.g. 'c:\test.xml'
                  if (FileExists(FDatabasePath + '\proformareport.xml')) then
                     CreateLogEntry('Proforma report output created.')
                  else
                     CreateLogEntry('Proforma report output failed.');
               end
            else
               CreateLogEntry('Proforma report not selected for output.');

            Initialize(soSyncDataOut);
            //CreateLogEntry('Sync successfully initialised.');

            if not FCanSync then
               begin
                  CreateLogEntry(Format('The sync operation was aborted.' + cCRLF +
                                        'The sync information for company "%s" is missing.',[FDatabasePath]));
                  Exit;
               end;

            FDocument := CreateOleObject('MSXML2.DOMDocument') as IXMLDOMDocument;

            FileName := FDatabasePath + '\accsData_input.xml';
            if FileExists(FileName) then
               DeleteFile(FileName);
            FDocument.appendChild(FDocument.createProcessingInstruction('xml', 'version="1.0" encoding="UTF-8"'));

            FRootNode := FDocument.createElement('accsData');
            FDocument.appendChild(FRootNode);

            FCompanyNode := FDocument.createElement('company'); // Create Root Node
            FNode := FDocument.createAttribute('name');
            FNode.Set_text(FSyncParams.DatabaseName);
            FCompanyNode.attributes.setNamedItem(FNode);

            FNode := FDocument.createAttribute('id');
            FNode.Set_text(FCompanyId);
            FCompanyNode.attributes.setNamedItem(FNode);

            FChildNode := FDocument.createElement('productRelationship');
            NomProdRelationship := GetNomProdRelationship(FDatabasePath);
            FChildNode.text := NomProdRelationship;
            FCompanyNode.appendChild(FChildNode);

            FRootNode.appendChild(FCompanyNode);

            ArrayIndex := 0;
            SetLength(MyArray, 0);

            FQuery.SQL.Clear;
            FQuery.SQL.Add('SELECT * From EntsFile E WHERE E."Active"=True');
            FQuery.Active := True;
            try
               // Add Node For Enterprises
               if FQuery.RecordCount > 0 then
                  begin
                     FTopNode := FDocument.createElement('enterprises');
                     FCompanyNode.appendChild(FTopNode);

                     FQuery.First;
                     while not FQuery.Eof do
                        begin
                           FNode := FDocument.createElement('enterprise');

                           FChildNode := FDocument.createElement('enterpriseId');
                           FChildNode.Set_text(FQuery.FieldByName('EntNo').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('code');
                           FChildNode.Set_text(FQuery.FieldByName('EntCode').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('name');
                           FChildNode.Set_text(FQuery.FieldByName('EntName').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('jobCardEnabled');
                           FChildNode.Set_text(FQuery.FieldByName('JobCardEnabled').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('isSynchronized');
                           FChildNode.Set_text(FQuery.FieldByName('IsSynchronized').AsString);
                           FNode.appendChild(FChildNode);

                           FTopNode.appendChild(FNode);

                           if (not FQuery.FieldByName('IsSynchronized').AsBoolean) then
                              begin
                                 SetLength(myArray, ArrayIndex+1);
                                 myArray[ArrayIndex] := FQuery.FieldByName('EntNo').AsInteger;;
                                 Inc(ArrayIndex);
                              end;

                           FQuery.Next;
                        end;
                  end;
               FlagAsSynchronized(MyArray, rtEntprise);
            finally
               FQuery.Active := False;
            end;

            ArrayIndex := 0;
            SetLength(MyArray, 0);

            FQuery.SQL.Clear;
            FQuery.SQL.Add('SELECT NLNo, Name, Enterprise, IsSynchronized, P.Id DefaultProduct');
            FQuery.SQL.Add('FROM NLFile N');
            FQuery.SQL.Add('LEFT JOIN NomListing L ON (N.NLNo=L.Account)');
            FQuery.SQL.Add('LEFT JOIN Products P ON (L.Product=P.Id)');
            FQuery.SQL.Add('WHERE N."Active"=True');

            // Only take nominals that have an associated product.
            if ( NomProdRelationship = cNomProdRelationship_OnetoOne) then
               begin
                  FQuery.SQL.Add('AND (P.Id>0)');
               end;

            FQuery.Active := True;
            try
               // Add Node For Nominals
               if FQuery.RecordCount > 0 then
                  begin
                     FTopNode := FDocument.createElement('nominals');
                     FCompanyNode.appendChild(FTopNode);

                     FQuery.First;
                     while not FQuery.Eof do
                        begin
                           FNode := FDocument.createElement('nominal');

                           FChildNode := FDocument.createElement('nominalId');
                           FChildNode.Set_text(FQuery.FieldByName('NLNo').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('code');
                           FChildNode.Set_text(FQuery.FieldByName('NLNo').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('name');
                           FChildNode.Set_text(FQuery.FieldByName('Name').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('enterpriseCode');
                           FChildNode.Set_text(FQuery.FieldByName('Enterprise').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('incomeOrExpense');
                           if (FQuery.FieldByName('NLNo').AsInteger >= 1) and
                              (FQuery.FieldByName('NLNo').AsInteger <= 200) then
                              FChildNode.Set_text('Income')
                           else if (FQuery.FieldByName('NLNo').AsInteger >= 201) and
                              (FQuery.FieldByName('NLNo').AsInteger <= 400) then
                              FChildNode.Set_text('Expense');
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('defaultProduct');
                           FChildNode.Set_text(FQuery.FieldByName('DefaultProduct').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('isSynchronized');
                           FChildNode.Set_text(FQuery.FieldByName('IsSynchronized').AsString);
                           FNode.appendChild(FChildNode);

                           FTopNode.appendChild(FNode);

                           if (not FQuery.FieldByName('IsSynchronized').AsBoolean) then
                              begin
                                 SetLength(myArray, ArrayIndex+1);
                                 myArray[ArrayIndex] := FQuery.FieldByName('NLNo').AsInteger;;
                                 Inc(ArrayIndex);
                              end;

                           FQuery.Next;
                        end;
                  end;

               FlagAsSynchronized(MyArray, rtNominal);
            finally
               FQuery.Active := False;
            end;

            ArrayIndex := 0;
            SetLength(MyArray, 0);

            FQuery.SQL.Clear;
            FQuery.SQL.Add('SELECT * From Products');
            FQuery.Active := True;
            try
               // Add Node For Nominals
               if FQuery.RecordCount > 0 then
                  begin
                     FTopNode := FDocument.createElement('products');
                     FCompanyNode.appendChild(FTopNode);

                     FQuery.First;
                     while not FQuery.Eof do
                        begin
                           FNode := FDocument.createElement('product');

                           FChildNode := FDocument.createElement('productId');
                           FChildNode.Set_text(FQuery.FieldByName('Id').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('name');
                           FChildNode.Set_text(FQuery.FieldByName('Desc1').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('defaultPrice');
                           FChildNode.Set_text(FQuery.FieldByName('DefaultPrice').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('unit');
                           FChildNode.Set_text(FQuery.FieldByName('Unit').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('isSynchronized');
                           FChildNode.Set_text(FQuery.FieldByName('IsSynchronized').AsString);
                           FNode.appendChild(FChildNode);

                           FTopNode.appendChild(FNode);

                           if (not FQuery.FieldByName('IsSynchronized').AsBoolean) then
                              begin
                                 SetLength(myArray, ArrayIndex+1);
                                 myArray[ArrayIndex] := FQuery.FieldByName('Id').AsInteger;;
                                 Inc(ArrayIndex);
                              end;

                           FQuery.Next;
                        end;
                  end;

               FlagAsSynchronized(MyArray, rtProduct);
            finally
               FQuery.Active := False;
            end;

            ArrayIndex := 0;
            SetLength(MyArray, 0);

            FQuery.Active := False;
            FQuery.SQL.Clear;
            FQuery.SQL.Add('SELECT * From SLFile S WHERE S."Active"=True');
            FQuery.Active := True;
            try
               // Add Node For Customers
               if FQuery.RecordCount > 0 then
                  begin
                     FTopNode := FDocument.createElement('customers');
                     FCompanyNode.appendChild(FTopNode);

                     FQuery.First;
                     while not FQuery.Eof do
                        begin
                           FNode := FDocument.createElement('customer');

                           FChildNode := FDocument.createElement('customerId');
                           FChildNode.Set_text(FQuery.FieldByName('SLNo').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('code');
                           FChildNode.Set_text(FQuery.FieldByName('SLNo').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('name');
                           FChildNode.Set_text(FQuery.FieldByName('Name').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('address1');
                           FChildNode.Set_text(FQuery.FieldByName('Address1').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('address2');
                           FChildNode.Set_text(FQuery.FieldByName('Address2').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('address3');
                           FChildNode.Set_text(FQuery.FieldByName('Address3').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('address4');
                           FChildNode.Set_text(FQuery.FieldByName('Address4').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('phoneNo');
                           FChildNode.Set_text(FQuery.FieldByName('PhoneNo1').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('faxNo');
                           FChildNode.Set_text(FQuery.FieldByName('FaxNo').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('isSynchronized');
                           FChildNode.Set_text(FQuery.FieldByName('IsSynchronized').AsString);
                           FNode.appendChild(FChildNode);

                           FTopNode.appendChild(FNode);

                           if (not FQuery.FieldByName('IsSynchronized').AsBoolean) then
                              begin
                                 SetLength(myArray, ArrayIndex+1);
                                 myArray[ArrayIndex] := FQuery.FieldByName('SLNo').AsInteger;;
                                 Inc(ArrayIndex);
                              end;

                           FQuery.Next;
                        end;
                  end;

                  FlagAsSynchronized(MyArray, rtCustomer);
               finally
                  FQuery.Active := False;
               end;

            ArrayIndex := 0;
            SetLength(MyArray, 0);

            FQuery.SQL.Clear;
            FQuery.SQL.Add('SELECT * From Analysis');
            FQuery.Active := True;
            try
               // Add Node For Enterprises
               if FQuery.RecordCount > 0 then
                  begin
                     FTopNode := FDocument.createElement('analysisTypes');
                     FCompanyNode.appendChild(FTopNode);

                     FQuery.First;
                     while not FQuery.Eof do
                        begin
                           FNode := FDocument.createElement('analysisType');

                           FChildNode := FDocument.createElement('analysisTypeId');
                           FChildNode.Set_text(IntToStr(FQuery.RecNo));
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('code');
                           FChildNode.Set_text(FQuery.FieldByName('Number').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('name');
                           FChildNode.Set_text(FQuery.FieldByName('Description').AsString);
                           FNode.appendChild(FChildNode);

                           FChildNode := FDocument.createElement('isSynchronized');
                           FChildNode.Set_text(FQuery.FieldByName('IsSynchronized').AsString);
                           FNode.appendChild(FChildNode);

                           FTopNode.appendChild(FNode);

                           if (not FQuery.FieldByName('IsSynchronized').AsBoolean) then
                              begin
                                 SetLength(myArray, ArrayIndex+1);
                                 myArray[ArrayIndex] := FQuery.FieldByName('Number').AsInteger;;
                                 Inc(ArrayIndex);
                              end;

                           FQuery.Next;
                        end;
                  end;
               FlagAsSynchronized(MyArray, rtAnalysisType);
            finally
               FQuery.Active := False;
            end;


               FDocument.Save(Filename);
         except
            on e : Exception do
               begin
                  CreateLogEntry('CreateSyncData() : '+e.Message);
               end;
         end;

         //TAccsSync.MarkAsSynchronized(FDatabasePath);

      finally
         FreeAndNil(AccsSync);
         elapsedtime := Windows.GetTickCount - initialtime;
         if (FileExists(Filename)) then
             CreateLogEntry('Sync output file successfully created.' + cCRLFx2 +'Time elapsed: ' + FloatToStr(elapsedtime / 1000) + ' seconds');
      end;
end;

destructor TAccsSync.Destroy;
begin
  FreeAndNilObjects();
  inherited;

end;

procedure TAccsSync.FlagAsSynchronized(AIds: array of Integer;
  ASyncType: TSyncRecordType);
var
   Index, ArrayLen : Integer;
begin
   if (@AIds = nil) or ((Length(AIds)=0) or (FSyncIds = nil) or (not FSyncIds.Active)) then Exit;
   ArrayLen := Length(AIds);
   for Index := 0 to ArrayLen-1 do
      begin
         FSyncIds.Append;
         FSyncIds.Fields[0].AsInteger := AIds[Index];
         FSyncIds.Fields[1].AsInteger := integer(ASyncType);
         FSyncIds.Post;
      end;
end;

procedure TAccsSync.FreeAndNilObjects;
begin
   if (FQuery <> nil) then
      FreeAndNil(FQuery);
end;

procedure TAccsSync.Initialize(ASyncOp: TSyncOp);
begin
   FQuery := TQuery.Create(nil);
   FQuery.DatabaseName := FDatabasePath;

   FAccsSync := TTable.Create(nil);
   with FAccsSync do
   try
      DatabaseName := FDatabasePath;
      TableName := 'AccsSync';
      Open;
      try
         First;

         FCompanyId := Trim(FieldByName('CompanyId').AsString);

         FCanSync := ((Uppercase(FieldByName('CompanyName').AsString)
                             = Uppercase(FSyncParams.DatabaseName)) and
                      (FCompanyId <> ''));
         finally
            Close;
         end;
   finally
      Free;
   end;

   FEntsFile := TQuery.Create(nil);
   FEntsFile.DatabaseName := FDatabasePath;
   FEntsFile.SQL.Text := 'Select * from EntsFile';

   if (ASyncOp = soSyncDataOut) then
      begin

         FSyncIds := TTable.Create(nil);
         FSyncIds.DatabaseName := FDatabasePath;
         FSyncIds.TableName := 'SyncIds';
         with FSyncIds.FieldDefs do
            begin
               Clear;
               Add('KeyValue', ftInteger);
               Add('SyncType', ftInteger);
            end;
         if (FSyncIds.Exists) then
            FSyncIds.DeleteTable;

         FSyncIds.CreateTable;
         FSyncIds.Active := True;

      end;
end;

class procedure TAccsSync.MarkAsSynchronized(const ADatabasePath: string);
var
   SyncType : Integer;
   KeyField, TableName : string;
begin
   with TQuery.Create(nil) do
      try
         DatabaseName := ADatabasePath;

         for SyncType := Integer(Low(SyncTables)) to Integer(High(SyncTables)) do
            begin
               TableName := SyncTables[TSyncRecordType(SyncType)];
               KeyField := SyncTableKeys[TSyncRecordType(SyncType)];
               SQL.Clear;
               SQL.Add('UPDATE ' + TableName + ' SET IsSynchronized = True');
               SQL.Add('WHERE '+KeyField+' IN');
               SQL.Add('       (SELECT KeyValue');
               SQL.Add('        FROM SyncIds   ');
               SQL.Add('        WHERE (SyncType = '+IntToStr(SyncType)+'))');
               try
                  ExecSQL;
               except
               end;
            end;
      finally
         Free;
      end;
end;


class procedure TAccsSync.ReadSyncData(ASyncParams : TSyncParams);
var
   AccsSync : TAccsSync;
   h : Integer;
   FileName : string;
   SyncDataStore : string;
begin

   AccsSync := TAccsSync.Create;
   with AccsSync do
      try
      try
         FDocument := CreateOleObject('MSXML2.DOMDocument') as IXMLDOMDocument;
         FDocument.load(ASyncParams.FileName);

         FRootNode := FDocument.documentElement;
         if (FRootNode = nil) then Exit;

         if FRootNode.attributes.length = 1 then
            try
               FDatabasePath := IncludeTrailingBackSlash(DefaultDirectory) + FRootNode.attributes.item[0].text;
               if ( not(DirectoryExists(FDatabasePath)) ) then
                  begin
                     CreateLogEntry('Path "'+FDatabasePath+'" does not exist.');
                     Exit;
                  end;
               Initialize(soSyncDataIn);
            except
              on e:Exception do
                 CreateLogEntry(e.Message);
            end
         else
            begin
               CreateLogEntry('Xml document does not contain the expected format.');
               Exit;
            end;

         SyncDataStore := FDatabasePath + '\sync';
         if not(DirectoryExists(SyncDataStore)) then
            begin
               if not CreateDir(SyncDataStore) then
                  CreateLogEntry('Failed to create dir '+SyncDataStore);
            end;

         FCompaniesNode := FDocument.getElementsByTagName('company');

         try
            // iterate through companies Node
            for h := 0 to FCompaniesNode.Get_length-1 do
               begin
                  FCompanyNode := FCompaniesNode.item[h];
                  if ( FCompanyNode = nil ) then continue;

                  FChildNode := FCompanyNode.selectSingleNode('name');
                  if FChildNode = nil then continue;

                  //CreateJobCards(FCompanyNode.selectNodes('jobCard'));
               end;
         finally
            if FileExists(ASyncParams.FileName) then
               begin
                  FileName := SyncDataStore + '\syncdata ' + FormatDateTime('yymmdd hhnnss',now) + '.xml';
                  if CopyFile(pChar(ASyncParams.FileName), Pchar(FileName), false) then
                     DeleteFile(ASyncParams.FileName)
                  else
                     CreateLogEntry('Could not create data sync file.');
               end
         end;

      except
         on e : Exception do
            CreateLogEntry('ReadSyncData() : '+e.Message);
      end;

      finally
         if (AccsSync <> nil) then
            FreeAndNil(AccsSync);
      end;
end;

{ TSyncOutputParams }

constructor TSyncParams.create(AParams: TStrings);
   function IsParam(value : string) : Boolean;
   begin
      Result := (AParams.IndexOf(value)>-1) or
                (AParams.IndexOfName(value)>-1);
   end;

   function GetParamValue(value : string) : Variant;
   begin
      if (IsParam(value)) then
      Result := AParams.Values[Value];
   end;

var
   Pref : TPreferences;
begin
   FIsValid := False;

   if (AParams[1] = '-o') then
      begin
         FSyncType := soSyncDataOut;
         FDatabaseName := AParams[2];
      end
   else if (AParams[1] = '-i') then
      begin
         FSyncType := soSyncDataOut;
         FFileName := AParams[2];
      end
   else
      Exit;

   if (Trim(AParams[2]) = '') then Exit;



   FIsValid := True;

   FResetSyncFlagsBeforeStart := IsParam('-resetflags');
   FOutputAgeOfDebtAnalysisData := IsParam('-aod');
   FOutputExtendedStatementData := IsParam('-es');
   FOutputJobCardReport := IsParam('-jcrpt');
   FOutputProformaReport := IsParam('-prorpt');
   if (FOutputAgeOfDebtAnalysisData) then
      begin
         Pref := TPreferences.Create(FDatabaseName);
         try
            FAgeOfDebtAgedByMonth := Pref.ValueAsInteger[cPref_AgeOfDebt_AgedBy_Month];
            if (FAgeOfDebtAgedByMonth <= 0) or (FAgeOfDebtAgedByMonth > 12) then
               FAgeOfDebtAgedByMonth := 12;
         finally
            Pref.Free;
         end;
      end;
end;

end.
