unit uAccountantLink;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, cxControls, cxContainer, cxEdit, cxLabel, uAccountantDownloadHelper,
  MSXML2_TLB, ComObj, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit,
  cxDBLookupEdit, cxDBExtLookupComboBox, StdCtrls, cxButtons,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, Db,
  cxGridLevel, cxClasses, cxGridCustomView, cxGrid, dxmdaset;

type
  TfmAccountantLink = class(TForm)
    lStatus: TcxLabel;
    DownloadTimer: TTimer;
    AccountantListingData: TdxMemData;
    AccountantListingDataName: TStringField;
    AccountantListingDataAddress1: TStringField;
    AccountantListingDataAddress2: TStringField;
    AccountantListingDataAddress3: TStringField;
    AccountantListingDataAddress4: TStringField;
    AccountantListingDataTelNo: TStringField;
    AccountantListingDataAccountantAccessKey: TStringField;
    AccountantListingTableView: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    dsAccountantListingData: TDataSource;
    AccountantListingTableViewRecId: TcxGridDBColumn;
    AccountantListingTableViewName: TcxGridDBColumn;
    AccountantListingTableViewAddress1: TcxGridDBColumn;
    AccountantListingTableViewAddress2: TcxGridDBColumn;
    AccountantListingTableViewAddress3: TcxGridDBColumn;
    AccountantListingTableViewAddress4: TcxGridDBColumn;
    AccountantListingTableViewTelNo: TcxGridDBColumn;
    AccountantListingTableViewAccountantId: TcxGridDBColumn;
    pAccountantListing: TPanel;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    cmboAccountant: TcxExtLookupComboBox;
    lHeader: TcxLabel;
    btnRemoveAccountantLink: TcxButton;
    btnClose: TcxButton;
    procedure FormActivate(Sender: TObject);
    procedure DownloadTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnRemoveAccountantLinkClick(Sender: TObject);
    procedure cmboAccountantPropertiesEditValueChanged(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FAccountNode : IXMLDOMNode;
    FAccountantNodeList : IXMLDOMNodeList;
    FChildNode : IXMLDOMNode;
    FDocument : IXMLDOMDocument;
    GetAvailableAccountants : TGetAvailableAccountants;
    SetAccountant : TSetAccountant;
    procedure DownloadAccountantListing();
    procedure LoadListingToScreen(AListingData : string);
    procedure SetStoredAccountantAccessKey(const Value: string);
    class function CurrentDatabase : string;
    procedure UpdateAccountantLink(AAccessKey : string);
    procedure CheckAccountantIsSelected();
  public
    { Public declarations }
    class function GetStoredAccountantAccessKey: string;
    class procedure Show();
    property StoredAccountantAccessKey : string read GetStoredAccountantAccessKey write SetStoredAccountantAccessKey;
  end;

var
  fmAccountantLink: TfmAccountantLink;

implementation
uses
   VARS, DBCore, AccsUtils, DCPCryptManagement, AccsData, Def, Types;

{$R *.DFM}

procedure TfmAccountantLink.FormActivate(Sender: TObject);
begin
   OnActivate := nil;
   DownloadTimer.Enabled := True;
end;

procedure TfmAccountantLink.DownloadTimerTimer(Sender: TObject);
begin
   DownloadTimer.Enabled := False;
   DownloadAccountantListing();
end;

procedure TfmAccountantLink.DownloadAccountantListing;
const
   ErrorInDownload = 'Error downloading accountant listing.';
var
   UserName : string;
   PResult : PChar;
   AccountantListingXML : string;
   DLLHandle : THandle;
   s : string;
   accesskey : string ;
begin
   DLLHandle := LoadLibrary(pchar(ApplicationPath + cDLLName));
   if ( DLLHandle = 0 ) then
      begin
         MessageDlg(cDLLUnableToLoad,mtError,[mbOk],0);
         Exit;
      end;
   Screen.Cursor := crHourGlass;
   try
     try
        UserName := vartostr(PSysLongToDelphi(Cash11.serial_no));
        @GetAvailableAccountants := GetProcAddress(DLLHandle, cFuncName_GetAccountants);
        if (@GetAvailableAccountants = nil) then
           begin
              MessageDlg(cDLLCallToFunctionFailed,mtError,[mbOk],0);
              Exit;
           end;

        Update;
        Application.ProcessMessages;
        PResult := GetAvailableAccountants(PChar(UserName));
        if (PResult = nil) then
           begin
              MessageDlg(ErrorInDownload,mtError,[mbOk],0);
              Exit;
           end;

        AccountantListingXML := StrPas(PResult);
        if Length(AccountantListingXML) > 0 then
           begin
              LoadListingToScreen(AccountantListingXML);
              if (AccountantListingData.RecordCount = 0 ) then
                  begin
                     MessageDlg('There are no Accountants available for selection',mtInformation,[mbOK],0);
                     Close;
                  end;
           end
        else
           MessageDlg(ErrorInDownload,mtError,[mbOk],0);

     except
        on e : Exception do
           raise Exception.Create(E.Message);
     end;
   finally
      FreeLibrary(DLLHandle);
      Screen.Cursor := crDefault;
   end;
end;

procedure TfmAccountantLink.FormCreate(Sender: TObject);
begin
   AccountantListingData.Active := True;
   GetAvailableAccountants := nil;
   SetAccountant := nil;
   FDocument := nil;
   FAccountNode := nil;
   FAccountantNodeList := nil;
   FChildNode := nil;
   pAccountantListing.Visible := False;
   lStatus.Visible := True;
   btnRemoveAccountantLink.Visible := False;
   btnClose.Visible := False; // becomes visible after update
end;

procedure TfmAccountantLink.LoadListingToScreen(AListingData: string);
var
   i : Integer;
   StoredAccountantAccessKey : string;
begin
   Application.ProcessMessages;

   FDocument := CreateOleObject('MSXML2.DOMDocument') as IXMLDOMDocument;
   FDocument.loadXML(AListingData);

   FAccountantNodeList := FDocument.getElementsByTagName('accountant');
   for i := 0 to FAccountantNodeList.length-1 do
      begin
         FAccountNode  := FAccountantNodeList[i];
         if (FAccountNode = nil) then continue;

         AccountantListingData.Append;
         try
            FChildNode := FAccountNode.selectSingleNode('accountantId');
            if (FChildNode <> nil) then
               AccountantListingDataAccountantAccessKey.AsString := FChildNode.text;

            FChildNode := FAccountNode.selectSingleNode('name');
            if (FChildNode <> nil) then
               AccountantListingDataName.AsString := FChildNode.text;

            FChildNode := FAccountNode.selectSingleNode('address1');
            if (FChildNode <> nil) then
               AccountantListingDataAddress1.AsString := FChildNode.text;

            FChildNode := FAccountNode.selectSingleNode('address2');
            if (FChildNode <> nil) then
               AccountantListingDataAddress2.AsString := FChildNode.text;

            FChildNode := FAccountNode.selectSingleNode('address3');
            if (FChildNode <> nil) then
               AccountantListingDataAddress3.AsString := FChildNode.text;

            FChildNode := FAccountNode.selectSingleNode('address4');
            if (FChildNode <> nil) then
               AccountantListingDataAddress4.AsString := FChildNode.text;

            FChildNode := FAccountNode.selectSingleNode('telNo');
            if (FChildNode <> nil) then
               AccountantListingDataTelNo.AsString := FChildNode.text;
            AccountantListingData.Post;

         except
            AccountantListingData.Cancel;
         end;
      end;

   StoredAccountantAccessKey := GetStoredAccountantAccessKey;
   if (StoredAccountantAccessKey<>'') then
      begin
         if AccountantListingData.Locate('AccountantAccessKey', StoredAccountantAccessKey,[]) then
            begin
               cmboAccountant.EditValue := StoredAccountantAccessKey;
               btnRemoveAccountantLink.Visible := True;
            end;
      end;

   AccountantListingTableView.DataController.FocusedRowIndex := 0;
   pAccountantListing.Visible := True;
   lStatus.Visible := False;
   cmboAccountant.SetFocus;
end;

class procedure TfmAccountantLink.Show;
begin
   with TfmAccountantLink.Create(nil) do
      try
         CLientWidth := 526;
         ClientHeight := 188;
         ShowModal;
      finally
         Free;
      end;
end;

procedure TfmAccountantLink.FormDestroy(Sender: TObject);
begin
   SetAccountant := nil;
   FDocument := nil;
   FAccountNode := nil;
   FAccountantNodeList := nil;
   FChildNode := nil;
   AccountantListingData.Active := False;
end;

class function TfmAccountantLink.GetStoredAccountantAccessKey: string;
var
   LinkFile : TStringList;
   AccountantId : string;
   FileName : string;
begin
   LinkFile := TStringList.Create;
   try
      FileName := ApplicationPath + 'accslink.config';
      if not FileExists(FileName) then Exit;
      LinkFile.LoadFromFile(FileName);
      LinkFile.Text := decryptString('kingsw'+ vartostr(PSysLongToDelphi(Cash11.serial_no)), LinkFile.Text);
      Result := LinkFile.Values[CurrentDatabase];
   finally
      FreeAndNil(LinkFile);
   end;
end;

procedure TfmAccountantLink.SetStoredAccountantAccessKey(const Value: string);
var
   LinkFile : TStringList;
   AccountantId : string;
   FileName : string;
   IsBeingRemoved : Boolean;
begin
   FileName := ApplicationPath + 'accslink.config';

   IsBeingRemoved := (Copy(Value,1,6) = 'REMOVE');
   if IsBeingRemoved then
      begin
         DeleteFile(FileName);
         Exit;
      end;

   LinkFile := TStringList.Create;
   try
      if FileExists(FileName) then
         begin
            LinkFile.LoadFromFile(FileName);
            LinkFile.Text := decryptString('kingsw'+ vartostr(PSysLongToDelphi(Cash11.serial_no)), LinkFile.Text);
         end;
      LinkFile.Values[CurrentDatabase] := Value;
      LinkFile.Text := encryptString('kingsw'+ vartostr(PSysLongToDelphi(Cash11.serial_no)), LinkFile.Text);
      LinkFile.SaveToFile(FileName);
   finally
      FreeAndNil(LinkFile);
   end;
end;

class function TfmAccountantLink.CurrentDatabase: string;
begin
   Result := ExtractDirFromPath(ExcludeTrailingBackslash(AccsDataModule.AccsDataBase.Directory));
end;

procedure TfmAccountantLink.btnOKClick(Sender: TObject);
var
   DLLHandle : THandle;
   AccessKey : string;
   UserName : string;
   MessageText: string;
begin
   CheckAccountantIsSelected();

   if not AccountantListingData.Locate('AccountantAccessKey', cmboAccountant.EditValue,[]) then
      begin
         MessageDlg('Record not found.',mtError,[mbOK],0);
         Exit;
      end;

   MessageText := 'Please confirm that this is your current accountant. '+cCRLFx2+
                  'Check the name, address and phone number '+
                  'of the account below to ensure that we are sending your'+cCRLF+
                  'accounts data to the correct location. Kingswood Computing can'+cCRLF+
                  'take no responsibility for sending your data incorrectly, if you get this wrong.'+cCRLFx2+
                  'Name:  ' +  AccountantListingDataName.AsString + cCRLF +
                  'Address:  '+ AccountantListingDataAddress1.AsString + ', '+ AccountantListingDataAddress2.AsString + cCRLF +
                  'Tel. No:  '+ AccountantListingDataTelNo.AsString+cCRLFx2+
                  'Is this your current accountant?';

   if (MessageDlg(MessageText, mtWarning, [mbYes,mbNo],0 ) = mrNo) then Exit;

   UpdateAccountantLink(cmboAccountant.EditValue);
end;

procedure TfmAccountantLink.btnRemoveAccountantLinkClick(Sender: TObject);
begin
   CheckAccountantIsSelected();
   if (MessageDlg('Are you sure you want to STOP this Accountant from accessing your data?',
        mtConfirmation,[mbYes,mbNo],0) = idYes) then
      begin
         Update;
         UpdateAccountantLink('REMOVE'+cmboAccountant.EditValue);
      end;
end;

procedure TfmAccountantLink.UpdateAccountantLink(AAccessKey: string);
var
   DLLHandle : THandle;
   UserName : string;
begin
   DLLHandle := LoadLibrary(pchar(ApplicationPath + cDLLName));
   if ( DLLHandle = 0 ) then
      begin
         MessageDlg(cDLLUnableToLoad,mtError,[mbOk],0);
         Exit;
      end;

   lStatus.Caption := 'Updating records, please wait...'+cCRLFx3;
   pAccountantListing.Visible := False;
   lStatus.Visible := True;
   Update;

   Screen.Cursor := crHourGlass;

   try
     try
        UserName := vartostr(PSysLongToDelphi(Cash11.serial_no));
        @SetAccountant := GetProcAddress(DLLHandle, cFuncName_SetAccountant);
        if (@SetAccountant = nil) then
           begin
              MessageDlg(cDLLCallToFunctionFailed,mtError,[mbOk],0);
              Exit;
           end;

        Update;
        Application.ProcessMessages;
        if SetAccountant(PChar(UserName), PChar(AAccessKey)) then
           begin
              lStatus.Caption := 'Update Successful.'+cCRLFx3;
              SetStoredAccountantAccessKey(AAccessKey);
           end
        else
           begin
              lStatus.Caption := 'Update Failed!'+cCRLFx3;;
              lStatus.Style.TextColor := clRed;
              Update;
           end;
        btnClose.Visible := True;
     except
        on e : Exception do
           raise Exception.Create(E.Message);
     end;
   finally
      FreeLibrary(DLLHandle);
      Screen.Cursor := crDefault;
   end;
end;


procedure TfmAccountantLink.CheckAccountantIsSelected;
begin
   if (cmboAccountant.EditValue = Null) then
      begin
         MessageDlg('Could not set the Accountant Link value',mtError,[mbOK],0);
         Abort;
      end;
end;

procedure TfmAccountantLink.cmboAccountantPropertiesEditValueChanged(
  Sender: TObject);
begin
   btnRemoveAccountantLink.Visible := False;
end;

procedure TfmAccountantLink.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (key = vk_Escape) then
      Close;
end;

end.
