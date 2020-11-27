{
   06/03/19 [V4.3 R4.4] /SP Bug Fix - New way to clear off files from FBankFiles that have been deleted by the user.
                                      This would have caused an index error message.

   29/09/20 [V4.5 R3.9] /MK Change - Added icons to the form for Settings, Ignore File, Import and Cancel - GL request.
                                   - Added text to the top information area about Ignore File - GL request.
                                   - Changed colour of top information area to clInfobk and the font colour to clNavy - GL request.
                                   - Order the grid by Created Date - GL request.
                                   - After changing the Grid Sort to Created Date in descending order I had to order the FBankFiles and FIgnoreList by name
                                     using a MemData recordset so that when reading in the IgnoredFiles file the files won't appear again because of the
                                     use of indexes of item in both the FBankFiles and FIgnoreList.
                                   - If the user ignores all files then close the form and pop up uBankLinkNoFileFound.
}

unit uBankFileSelector;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxContainer, cxEdit, cxLabel, cxGridCustomTableView, cxGridTableView,
  cxControls, cxGridCustomView, StdCtrls, cxButtons, cxClasses,
  cxGridLevel, cxGrid, ActnList, uAccounts, ExtCtrls, uAccsSystem,
  dxmdaset, cxUtils, db, cxCustomData;

type
  TBankFileType = (bfNone,
                   bfBOI, // Bank of Ireland
                   bfACC, //
                   bfUB, // Ulster Bank
                   bfAIB); // Allied Irish Bank

  TfmBankFileSelector = class(TForm)
    BankFileGridLevel: TcxGridLevel;
    BankFileGrid: TcxGrid;
    btnClose: TcxButton;
    cxButton1: TcxButton;
    BankFileGridTableView: TcxGridTableView;
    BankFileGridTableViewFileName: TcxGridColumn;
    BankFileGridTableViewFileDateTime: TcxGridColumn;
    cxLabel1: TcxLabel;
    BankFileGridTableViewFileFormat: TcxGridColumn;
    btnImport: TcxButton;
    ActionList1: TActionList;
    actImport: TAction;
    actSettings: TAction;
    actCancel: TAction;
    FileDirectoryLabel: TcxLabel;
    cxButton2: TcxButton;
    actIgnore: TAction;
    EnableImportTimer: TTimer;
    procedure FormDestroy(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actImportExecute(Sender: TObject);
    procedure actIgnoreExecute(Sender: TObject);
    procedure actIgnoreUpdate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EnableImportTimerTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function GetAnyBankFiles: Boolean;
    procedure LoadIgnoredFile;
  private
    { Private declarations }
    FBankFiles : TStringList;
    FIgnoreListFileName : string;
    FIgnoreList : TStringList;
    FRunInSilentMode : Boolean;
    FSilentModeSettingsClickResult : Boolean;
    procedure UpdateScreenControls();
    procedure ScanBankFiles;
    procedure LoadBankFilesToGrid();
    procedure DoImport();
    procedure AddToIgnoreList(AFileName : string);
    function IsInIgnoreList(AFileName : string) : Boolean;
    property AnyBankFiles : Boolean read GetAnyBankFiles;
    procedure RemoveIgnoredFiles();
  public
    { Public declarations }
    class function ShowBankFileSelector(const ARunInSilentMode : Boolean = True) : Boolean;
  end;

var
  fmBankFileSelector: TfmBankFileSelector;

implementation

uses
   AccsUtils, AccsData, uBankFileSelectorSettings, Types,
   uBankFileFormatSelector, Global, uBankCSVimport, uBankImport;

{$R *.DFM}

{ TfmBankFileSelector }

class function TfmBankFileSelector.ShowBankFileSelector(const ARunInSilentMode : Boolean = True) : Boolean;
begin
   Result := True;
   with TfmBankFileSelector.Create(nil) do
      try
         FRunInSilentMode := ARunInSilentMode;
         if ( FRunInSilentMode ) then
            FSilentModeSettingsClickResult := False;
         LoadBankFilesToGrid();

         if not (AnyBankFiles) then
            begin
               Result := False;
               if ( not(ARunInSilentMode) ) then
                  MessageDlg('No transaction files have been found in '+
                      AccsDataModule.DefaultStatementDirectory,mtInformation,[mbOK],0);
               Exit;
            end;
         ShowModal;
         if ( ARunInSilentMode ) then
            Result := FSilentModeSettingsClickResult;

      finally
         Free;
      end;
end;

procedure TfmBankFileSelector.ScanBankFiles;
begin
   //
end;

procedure TfmBankFileSelector.FormDestroy(Sender: TObject);
var
   MemData : TdxMemData;
   i : Integer;
begin
   if (FBankFiles <> nil) then
      FreeAndNil(FBankFiles);

   if (FIgnoreList <> nil) then
      begin
         if ( FIgnoreList.Count > 0 ) then
            begin
               BankFileGridTableViewFileDateTime.SortOrder := soNone;
               BankFileGridTableViewFileDateTime.SortIndex := -1;

               MemData := TdxMemData.Create(nil);
               with MemData do
                  try
                     ClearMemDataFieldDefs(MemData);

                     CreateMemDataFieldDef(MemData,'FileName',ftString,200);
                     CreateMemDataFieldDef(MemData,'CreationDate',ftDateTime);

                     MemData.SortedField := 'FileName';
                     MemData.SortOptions := [soCaseInsensitive];

                     MemData.Open;
                     MemData.First;
                     for i := 0 to FIgnoreList.Count-1 do
                        try
                           MemData.Append;
                           MemData.FieldByName('FileName').AsString := ExtractFileName(FIgnoreList[i]);
                           MemData.FieldByName('CreationDate').AsDateTime := GetFileCreationDate(FIgnoreList[i]);
                           MemData.Post;
                        except
                           on e : Exception do
                              ShowDebugMessage(e.Message);
                        end;
                     MemData.Active := True;

                     FIgnoreList.Clear;
                     MemData.First;
                     while ( not(MemData.Eof) ) do
                        begin
                           FIgnoreList.Add(IncludeTrailingBackslash(AccsDataModule.DefaultStatementDirectory)+MemData.FieldByName('FileName').AsString);
                           MemData.Next;
                        end;
                  finally
                     MemData.Active := False;
                     FreeAndNil(MemData)
                  end;

               FIgnoreList.SaveToFile(FIgnoreListFileName);
            end;
         FreeAndNil(FIgnoreList);
      end;
end;

procedure TfmBankFileSelector.LoadBankFilesToGrid;
var
   i : Integer;
   BankFileType : TBankFileType;
   FileName : string;
   FBankOutFiles : TStringList;
   MemData : TdxMemData;
begin
   if (FBankFiles = nil) then
      FBankFiles := TStringList.Create;
   FBankFiles.Clear;
   BankFileGridTableView.DataController.RecordCount := 0; // reset to 0 to remove all previous files

   GetDirectoryFiles(AccsDataModule.DefaultStatementDirectory, FBankFiles, '*.csv');

   // 08/2017 AIB have started to defualt the ext to .out so we must search dir
   // and join both FBankFiles & FBankOutFiles together
   FBankOutFiles := TStringList.Create;
   try
      GetDirectoryFiles(AccsDataModule.DefaultStatementDirectory, FBankOutFiles, '*.out');
      for i := 0 to FBankOutFiles.Count-1 do
         FBankFiles.Add(FBankOutFiles[i]);
   finally
      FreeAndNil(FBankOutFiles);
   end;

   MemData := TdxMemData.Create(nil);
   with MemData do
      try
         ClearMemDataFieldDefs(MemData);

         CreateMemDataFieldDef(MemData,'FileName',ftString,200);
         CreateMemDataFieldDef(MemData,'BankName',ftString,200);
         CreateMemDataFieldDef(MemData,'CreationDate',ftDateTime);

         MemData.SortedField := 'FileName';
         MemData.SortOptions := [soCaseInsensitive];

         MemData.Open;
         MemData.First;
         for i := 0 to FBankFiles.Count-1 do
            try
               MemData.Append;
               MemData.FieldByName('FileName').AsString := ExtractFileName(FBankFiles[i]);
               MemData.FieldByName('BankName').AsString := AccsDataModule.LastImportBank;
               MemData.FieldByName('CreationDate').AsDateTime := GetFileCreationDate(FBankFiles[i]);
               MemData.Post;
            except
               on e : Exception do
                  ShowDebugMessage(e.Message);
            end;
         MemData.Active := True;

         FBankFiles.Clear;
         MemData.First;
         while ( not(MemData.Eof) ) do
            begin
               FBankFiles.Add(IncludeTrailingBackslash(AccsDataModule.DefaultStatementDirectory)+MemData.FieldByName('FileName').AsString);
               MemData.Next;
            end;
      finally
         MemData.Active := False;
         FreeAndNil(MemData)
      end;

   RemoveIgnoredFiles();

   if ( not(AnyBankFiles) ) then Exit;

   if ( FRunInSilentMode ) then
      FSilentModeSettingsClickResult := True;

   BankFileGridTableView.DataController.RecordCount := 0; // reset to 0 to remove all previous files
   BankFileGridTableView.DataController.RecordCount := FBankFiles.Count;
   for i := 0 to FBankFiles.Count-1 do
      begin
         // Filename
         BankFileGridTableView.DataController.Values[i, 0] := ExtractFileName(FBankFiles[i]);
         BankFileGridTableView.DataController.Values[i, 1] := AccsDataModule.LastImportBank;
         BankFileGridTableView.DataController.Values[i, 2] := GetFileCreationDate(FBankFiles[i]);
      end;

   BankFileGridTableViewFileDateTime.SortOrder := soDescending;
   BankFileGridTableViewFileDateTime.SortIndex := 0;

   BankFileGridTableView.DataController.FocusedRowIndex := 0;
   BankFileGridTableView.Controller.FocusedColumnIndex := 1;

   UpdateScreenControls();
end;

procedure TfmBankFileSelector.actCancelExecute(Sender: TObject);
begin
   Close;
end;

procedure TfmBankFileSelector.actSettingsExecute(Sender: TObject);
begin
   TfmBankFileSelectorSettings.ShowSettings;
   UpdateScreenControls;
   if ( FRunInSilentMode ) then
      FSilentModeSettingsClickResult := False;
   LoadBankFilesToGrid();
   if ( BankFileGridTableView.DataController.RecordCount = 0 ) then
      Close;
end;

procedure TfmBankFileSelector.FormCreate(Sender: TObject);
begin
   actImport.Enabled := False;
   FileDirectoryLabel.Caption := '';
   BankFileGridTableViewFileFormat.RepositoryItem := AccsDataModule.erBankLookup;
   LoadIgnoredFile;
end;

procedure TfmBankFileSelector.LoadIgnoredFile;
begin
   FIgnoreList := TStringList.Create;
   FIgnoreListFileName := IncludeTrailingBackSlash(ApplicationPath) + '\bankimportignore.txt';
   if ( FileExists(FIgnoreListFileName) ) then
      FIgnoreList.LoadFromFile(FIgnoreListFileName);
end;

procedure TfmBankFileSelector.actImportExecute(Sender: TObject);
begin
   DoImport;
end;

procedure TfmBankFileSelector.DoImport;
var
   BankAccount : TBankAccount;
   SelectedBankName : Variant;
   SelectedFormat : Integer;
   SelectedIndex : Integer;
   SelectedFileName : string;
begin
   if (BankFileGridTableView.DataController.FocusedRowIndex < 0) then
      begin
         MessageDlg('No file has been selected to import.',mtError,[mbOK],0);
         Exit;
      end;

   SelectedBankName := BankFileGridTableView.DataController.Values[BankFileGridTableView.DataController.FocusedRowIndex, 1];
   if VarIsNull(SelectedBankName) then
      begin
         MessageDlg('You must select a Bank before beginning import.',mtError,[mbOK],0);
         Exit;
      end;

   SelectedFileName := IncludeTrailingBackslash(AccsDataModule.DefaultStatementDirectory) +
                              BankFileGridTableView.DataController.Values[BankFileGridTableView.DataController.FocusedRowIndex, 0];

   BankAccount := AccsDataModule.Accounts.BankAccounts.GetBankAccount(VarToStr(SelectedBankName));
   if (BankAccount = nil) then
      raise Exception.CreateFmt(cBankNameNotOnFile,[BankAccount.Name]);

   if (BankAccount.BankFileFormat <= 0) then
      begin
         MessageDlg(Format('This is the first time a file for Bank Account (%s) is being imported.' + cCRLFx2 +
                           'You must select the correct Source Bank to use for this Bank Account.', [BankAccount.Name]),
                           mtInformation, [mbOK], 0);

         SelectedFormat := TfmBankFileFormatSelector.ShowSelector(BankAccount.Name);
         if (SelectedFormat <= 0) then
            begin
               MessageDlg('Cannot continue with import until a valid Source Bank has been selected.',mtError,[mbOK],0);
               Exit;
            end;
         BankAccount.BankFileFormat := SelectedFormat;

         AccsDataModule.UpdateBankDetails(BankAccount);
      end;

   BankFileGridTableView.DataController.DeleteRecord(BankFileGridTableView.DataController.FocusedRecordIndex);
   //TBankCSVImportForm.RunImport(SelectedFileName, BankAccount);
   Application.ProcessMessages;
   
   TfmBankImport.RunImport(SelectedFileName, BankAccount);
   if (BankFileGridTableView.DataController.RecordCount > 0) then
      begin
         BankFileGridTableView.DataController.FocusedRowIndex := 0;
         UpdateScreenControls();
         BankFileGrid.SetFocus;
      end
   else
      Close;
end;

procedure TfmBankFileSelector.UpdateScreenControls;
begin
   FileDirectoryLabel.Caption := Format('%d file(s) contained in '''+ AccsDataModule.DefaultStatementDirectory + '''',[BankFileGridTableView.DataController.RecordCount]);
end;

function TfmBankFileSelector.GetAnyBankFiles: Boolean;
begin
   Result := ((FBankFiles <> nil) and (FBankFiles.Count > 0));
end;

procedure TfmBankFileSelector.AddToIgnoreList(AFileName: string);
begin
   if (FIgnoreList = nil) or (IsInIgnoreList(AFileName)) then Exit;

   FIgnoreList.Add(Lowercase(AFileName));
end;

function TfmBankFileSelector.IsInIgnoreList(AFileName: string): Boolean;
begin
   if (FIgnoreList = nil) then Exit;

   Result := FIgnoreList.IndexOf(Lowercase(AFileName))>-1;
end;

procedure TfmBankFileSelector.actIgnoreExecute(Sender: TObject);
var
   SelectedFileName : string;
begin
   if (BankFileGridTableView.DataController.FocusedRowIndex < 0) then
      Exit;

   BankFileGridTableViewFileDateTime.SortOrder := soNone;
   BankFileGridTableViewFileDateTime.SortIndex := -1;

   SelectedFileName := BankFileGridTableView.DataController.Values[BankFileGridTableView.DataController.FocusedRowIndex, 0];

   AddToIgnoreList(IncludeTrailingBackslash(AccsDataModule.DefaultStatementDirectory)+SelectedFileName);

   BankFileGridTableView.DataController.DeleteRecord(BankFileGridTableView.DataController.FocusedRecordIndex);
   if (BankFileGridTableView.DataController.RecordCount > 0) then
      begin
         UpdateScreenControls();
         BankFileGrid.SetFocus;
         BankFileGridTableViewFileDateTime.SortOrder := soDescending;
         BankFileGridTableViewFileDateTime.SortIndex := 0;
         BankFileGridTableView.DataController.FocusedRowIndex := 0;
         BankFileGridTableView.Controller.FocusedColumnIndex := 1;
      end
   else
      begin
         if ( FRunInSilentMode ) then
            FSilentModeSettingsClickResult := False;
         Close;
      end;
end;

procedure TfmBankFileSelector.actIgnoreUpdate(Sender: TObject);
begin
   actIgnore.Enabled := (BankFileGridTableView.DataController.RecordCount>0) and
                        (BankFileGridTableView.DataController.FocusedRowIndex > -1);
end;

procedure TfmBankFileSelector.RemoveIgnoredFiles;
var
   i : Integer;
   IgnoredFileName : string;
   Index : Integer;
   BankFiles : TStringList;
   FileName : string;
begin
   BankFiles := TStringList.Create;
   BankFiles.Assign(FBankFiles);
   try
      for i := 0 to BankFiles.Count-1 do
        BankFiles[i] := Lowercase(BankFiles[i]);

      for i := FIgnoreList.Count-1 downto 0 do
         begin
            IgnoredFileName := Lowercase(FIgnoreList[i]);
            if (Trim(IgnoredFileName) = '') then Continue;

            Index := BankFiles.IndexOf(IgnoredFileName);
            if (Index>-1) and (Index < FBankFiles.Count) then
               FBankFiles.Delete(Index);
         end;
   finally
      FreeAndNil(BankFiles);
   end;
end;

procedure TfmBankFileSelector.FormActivate(Sender: TObject);
begin
   OnActivate := nil;

   // *** The problem:
   //
   // The import button is accidentally clicked by user when entering
   // the program.

   // *** Why is that happening.
   //
   // Its happening because the TFCheckName.RunButton is positioned exactly where
   // the fmBankFileSelector.btnImport button is positioned.
   // Because of the button positioning, when user double/triple clicks on
   // TFCheckName.RunButton the second or third click can get processed by this form.

   // *** The Solution:
   //
   // The actImport action should be disabled until form activation is invoked.
   // When FormActivation is invoked, start timer (500 milliseconds) and enable the
   // btnImport action when the timer fires.

   EnableImportTimer.Enabled := True;
end;

procedure TfmBankFileSelector.EnableImportTimerTimer(Sender: TObject);
begin
   EnableImportTimer.Enabled := False;
   actImport.Enabled := True;
end;

procedure TfmBankFileSelector.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = VK_ESCAPE) then
     Close;
end;


end.
