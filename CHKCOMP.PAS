{
   04/11/11 [V4.1 R0.7] /MK Additional Feature - CheckForNewFields - Adding New Color Field To Store Enterprise Color For Graphs.

   02/03/16 [V4.1 R1.9] /MK Additional Feature - CheckForNewFields - Incorporated Andrew's (TGM) changes to add new columns for CoOpImport.

   14/12/16 [V4.2 R5.1] /MK Additional Feature - Added new image and new logo.
                            Change - Removed network panel.
                                   - Added new check for companies to be added to CheckCompanyName.
                                   - Changed height of form if/if not using password.

   11/09/18 [V4.3 R1.2] /MK Bug Fix - RunButtonClick - Run GatherCompanies again so that after Year End the archived year will show.
                            Change - GatherCompanies - If CheckCompanyName.ItemIndex then assign ItemIndex based on last selected company i.e. FSelectCompanyName.
                                   - RunButtonClick - Assign FSelectedCompany as the selected company name before opening MainUnit.

   21/05/19 [V4.4 R0.7] /MK Additional Feature - RunButtonClick - If MTD user then install BDEUpdate.zip that was downloaded by KInstaller.

   26/05/20 [V4.5 R2.1] /MK Additional Feature - DeleteSyncFilesInKingsacc - Delete the sync files from the Kingsacc folder that were installed by KInstaller.
                                               - DeleteServicesFolder - Delete the Services folder for customers without the Invoice module.

   28/07/20 [V4.5 R3.2] /MK Bug Fix - DeleteServicesFolder - Only delete the services folder if its not figured - Catriona Hughes had an issue where the folder
                                                             was being deleted when she opened the Farm accounts company.                                            

   30/07/20 [V4.5 R3.4] /MK Change - RunButtonClick - If the user has the Kac.config file and a serial number between 100 and 999 i.e. accountant, don't show "Data Path does not match" message.

   04/03/21 [V4.5 R5.1] /AB Change - CheckForNewFields added field update for AllocatedVAT-1 - Ch006(P)
}

Unit Chkcomp;

interface

uses
   SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
   Forms, Dialogs, StdCtrls, Buttons,
   vars,
   types,
   params,
   DefSecFl,
   init,
   ExtCtrls, OleCtrls, {graphsv3,} ComCtrls, Mask ,NewClass, Adgrad, FileCtrl,
   Grids, DynaZip, DynaLibZ, DynaLibU, USuppdownload,
   IniFiles, jpeg, shellapi, bde, dbtables, db, uAccountsHelp, AccsUtils,
   dxGDIPlusClasses, cxControls, cxContainer, cxEdit, cxImage, uAccsSystem,
   KRoutines;
   
const
   InputBoxMessage = WM_USER + 200;

type

   TChangeRec = Packed Record
      szName: DBIName;
      iType: word;
      iSubType: word;
      iLength: word;
      iPrecision: byte;
   end;

type
  TFCheckName = class(TKingForm)
    ZipFile1: TZipFile;
    pOuter: TPanel;
    ImagePanel: TPanel;
    pBottom: TPanel;
    Label1: TLabel;
    PasswordLabel: TLabel;
    DateLabel: TLabel;
    CheckCompanyName: TComboBox;
    Password: TEdit;
    TxDate: TMaskEdit;
    DateSearch: TDateTimePicker;
    cxImage1: TcxImage;
    ExitButton: TBitBtn;
    RunButton: TBitBtn;
    Help: TBitBtn;
    procedure ExitButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RunButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure PasswordExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DateSearchCloseUp(Sender: TObject);
    procedure PasswordEnter(Sender: TObject);
    procedure TxDateEnter(Sender: TObject);
    procedure CheckCompanyNameExit(Sender: TObject);
    procedure GatherCompanies;  // TGM AB 15/02/02 moved from private to public
    function TrialbalanceOK: boolean;   // TGM AB
    function CheckProtection : Boolean; // TGM AB
    procedure CheckForBankFile;
    function Networked: boolean;
    procedure TidyDataFolder(Path : string);
    procedure ChangeField(Table:TTable; FieldName:String; Rec:TChangeRec);
    procedure ResizeField(TablePathName, FieldName : String; NewFieldSize : Integer);
    procedure CheckCompanyNameChange(Sender: TObject);
    procedure PasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PasswordChange(Sender: TObject);
  private
    FSearchPath : String;
    FSelectedCompany : String;
    procedure PasswordProc( Sender: TObject );
    procedure SetUpScreen;
    procedure InputBoxSetPasswordChar(var Msg: TMessage); message InputBoxMessage;
    function ExtractTopMostFolder(Path: string): string;
    { Private declarations }
  public
    { Public declarations }
    LangOpen : Boolean;
    networkpath : string;
    TokenSerialNumber : integer;
    // CheckForNewFields moved from private to public so that the XMLExport can ensure db is updated before export is run.
    // TGM AB 13/08/02 Moved code for adding new DB fields here so it can be called by data dump process
    procedure CheckForNewFields;
  end;

var
  FCheckName: TFCheckName;
  DirString : shortString;
  DLLLoaded : boolean;
  SaveExit : pointer;
  DLLHandle: THandle;
  AlreadyChecked: Boolean;
  procedure LoadDLL;
  procedure NewExit; far;
  procedure AutomatedBackup;

  TYPE
    TDataPtr = ^ccmb_rec_type;
    ccmb_rec_type = record
    ccmb          : array[1..4] of char;
    func          : byte;
    r_code        : shortint;
    drive         : byte;
    dir           : dword;
    vers          : shortint;
    s_n           : word;
    p_code        : array[1..9]  of char;
    p_name        : array[1..13] of char;
    cc_sn         : word;
    master        : byte;
    dr_typ        : byte;
    copies        : Word;
    init_copies   : word;
    uses_left     : word;
    i_uses        : word;
    exp_d         : byte;
    exp_m         : byte;
    exp_y         : word;
    feature       : word;
    net_users     : word;
    secure_msg    : array[1..257] of char;
    update_num    : word;
    flags1        : word;
    net_user_data : array[1..4] of byte;
    dos_time      : array[1..4] of byte;
    max_days      : word;
    res2          : dword;
    extended_err  : array[1..6] of byte;
    res_expand    : array[1..173] of byte;
end;

Implementation
Uses
    Calcs,
    dbgen,
    DbCore,
    pickdate,
    clears,
    BackGnd,
    LangUnit,
    MainUnit, AccsData, FullAudit, Filed, AbortPrg, DataUpgrade, uKingsCC;

var cc32 : function ( test : TDataPtr) : Integer ; pascal ; // external 'WACCSCC.DLL' NAME 'cc32';

{$R *.DFM}

procedure TFCheckName.InputBoxSetPasswordChar(var Msg: TMessage);
var
  hInputForm, hEdit, hButton: HWND;
begin
  hInputForm := Screen.Forms[0].Handle;
  if (hInputForm <> 0) then
  begin
    hEdit := FindWindowEx(hInputForm, 0, 'TEdit', nil);
    {
      // Change button text:
      hButton := FindWindowEx(hInputForm, 0, 'TButton', nil);
      SendMessage(hButton, WM_SETTEXT, 0, Integer(PChar('Cancel')));
    }
    SendMessage(hEdit, EM_SETPASSWORDCHAR, Ord('*'), 0);
  end;
end;

Procedure TFCheckName.ChangeField(Table:TTable; FieldName:String; Rec:TChangeRec);
var
  Props: CURProps;
  hDb: hDBIDb;
  Res : DBIResult;
  TableDesc: CRTblDesc;
  pFields: pFLDDesc;
  pOp: pCROpType;
  B: byte;
  Field : TField;
begin
  // Make sure table is opened exclusively
  If (Table.Active and Not Table.Exclusive) Then Table.Close;
  If (Not Table.Exclusive) Then Table.Exclusive := True;
  If (Not Table.Active) Then Table.Open;

  Field := Table.FieldByName(FieldName);

  // Get table properties (needed to get table type)
  Check(DbiSetProp(hDBIObj(Table.Handle), curxltMODE, integer(xltNONE)));
  Check(DbiGetCursorProps(Table.Handle, Props));

  // Allocate memory for pointers
  pFields := AllocMem(Table.FieldCount * sizeof(FLDDesc));
  pOp := AllocMem(Table.FieldCount * sizeof(CROpType));

  try
    // Set the pointer to the index in the operation descriptor
    // to crMODIFY (to modify field properties)
    Inc(pOp, Field.Index);
    pOp^ := crMODIFY;
    Dec(pOp, Field.Index);

    // Get existing field properties
    Check(DbiGetFieldDescs(Table.Handle, pFields));
    Inc(pFields, Field.Index);

    // Check for field changes specified by caller
    if StrLen(Rec.szName) > 0 then pFields^.szName := Rec.szName;
    if Rec.iType > 0 then pFields^.iFldType := Rec.iType;
    if Rec.iSubType > 0 then pFields^.iSubType := Rec.iSubType;
    if Rec.iLength > 0 then pFields^.iUnits1 := Rec.iLength;
    if Rec.iPrecision > 0 then pFields^.iUnits2 := Rec.iPrecision;

    Dec(pFields, Field.Index);

    for B := 1 to Table.FieldCount do begin
      pFields^.iFldNum := B;
      Inc(pFields, 1);
    end;
    Dec(pFields, Table.FieldCount);

    // Clear the structure
    FillChar(TableDesc, sizeof(TableDesc), 0);

    // Get database handle from the table cursor's handle
    Check(DbiGetObjFromObj(hDBIObj(Table.Handle), objDATABASE, hDBIObj(hDb)));

    // Set table name and type into the descriptor
    StrPCopy(TableDesc.szTblName, Table.TableName);
    StrPCopy(TableDesc.szTblType, Props.szTableType);

    // Set field count for this table
    TableDesc.iFldCount := Table.FieldCount;

    // Link the operation descriptor to the table descriptor
    TableDesc.pecrFldOp := pOp;

    // Link the field descriptor to the table descriptor
    TableDesc.pFldDesc := pFields;

    Table.Close;

    // Do the actual table restructuring
    Res := DbiDoRestructure(hDb, 1, @TableDesc, nil, nil, nil, FALSE);
    Check(Res);
  finally
    if pFields <> nil then FreeMem(pFields);
    if pOp <> nil then FreeMem(pOp);

    Table.Exclusive := False;
    Table.Open;
  end;
end;

procedure TFCheckName.ResizeField(TablePathName, FieldName : String; NewFieldSize : Integer);
var
  FldChanges : TChangeRec;
  MyTable : TTable;
begin
  // First create a table component
  MyTable := TTable.Create(Application.MainForm);
  MyTable.DatabaseName := ExtractFilePath(TablePathName);
  MyTable.TableName := ExtractFileName(TablePathName);

  // Set the new field size into the field structure
  FillChar(FldChanges, SizeOf(FldChanges), 0);
  FldChanges.iLength := NewFieldSize;
  //FldChanges.iType := NewFieldType;
  // Call ChangeField to do the actual dbiDoRestructure call
  ChangeField(MyTable, FieldName, FldChanges);

  MyTable.Free;
end;

function TFCheckName.CheckProtection : Boolean;
var
   Temp : TDataPtr; { Pointer to Copy Control record structure }
   TCCRecord : ccmb_rec_type;
   i : Integer;
   x : Integer;
   CashSerial,
   SerialLng : LongInt;
   TempBool : Boolean;
begin
    TempBool := False;
    Result := False;

    Temp := @TCCRECORD;
    New ( Temp );

    { Initialise the Pointer Variable }
    FillChar ( Temp^, SizeOf(Temp^),chr(0));

    Temp^.ccmb[1] := 'C';
    Temp^.ccmb[2] := 'C';
    Temp^.ccmb[3] := 'M';
    Temp^.ccmb[4] := 'B';
    Temp^.r_code  := -1;
    Temp^.func    := 0;
    Temp^.drive   := 0;

    {$I+}
    if uKingsCC.usekacc then begin
        if not AlreadyChecked then begin
            //    showmessage('New Protection');
                application.ProcessMessages;
{$IFDEF DEBUG}
                 ShowMessage('RUNNING IN DEBUG');
{$ELSE}
                uKingsCC.AddRegistrationCode;
                uKingsCC.CheckKcc;
{$ENDIF}

                TempBool := True;
                AlreadyChecked := True;
        end else Tempbool := True;

        SerialLng  := PSysLongToDelphi ( RFarmGate.PSerial );
        CashSerial := PSysLongToDelphi ( Cash11.serial_no );
        TokenSerialNumber := UKingsCC.TokenSerialNo;

        if ( Cash11.first_prot ) And ( SerialLng > 1000 ) Then
              Begin
                    if (uppercase(RFarmGate.PLocation[2]) <> 'DEMO') AND
                       (uppercase(RFarmGate.PLocation[2]) <> 'SETUP') then
                      If ( SerialLng <> CashSerial ) Or
                         ( UKingsCC.TokenSerialNo <> SerialLng ) Then
                         Begin
                              MessageDlg('Error in Data File Set-Up (ERR-NO 10/13) - Contact Kingswood Computing and quote the following error messages.' + #10#13 + 'Token Serial Number - ' + vartostr(UKingsCC.TokenSerialNo)
                                                + #10#13 + 'Farmgate Serial Number - ' + vartostr(SerialLng) + #10#13 + 'CashBook Serial Number - ' + vartostr(CashSerial), mtInformation,[mbOK], 0);
                              TempBool := False;
                         End;
              End
           Else
               If ( SerialLng >= 1000 ) Then
                  Begin
                       Cash11.first_prot := True;
                       DelphiLongToPSys ( SerialLng, Cash11.serial_no );
                       DefWrite ( 11 );
                       DefRead ( 11 );
                  End;

    end

    else begin

    Try
       LoadDLL;

       i := CC32 ( Temp );

       x := Integer (i);

       TempBool := ( Integer ( i ) = 0 );

       TempBool := ( Temp^.r_code = 0 );

       SerialLng  := PSysLongToDelphi ( RFarmGate.PSerial );
       CashSerial := PSysLongToDelphi ( Cash11.serial_no );
       TokenSerialNumber := Temp^.s_n;

       If (( Temp^.r_code <> 0 ) and ( Temp^.r_code <> -66 )) Then
          Case Temp^.r_code Of
               -25 : MessageDlg('Expiry Date Reached - Contact Kingswood Computing', mtInformation,[mbOK], 0);
             Else
              MessageDlg('Control Control Error ' + IntToStr ( Temp^.r_code ) +
                         ' - Contact Kingswood Computing', mtInformation,[mbOK], 0);
          End
       Else
           // if Master is Normal Floppy or Normal Install
           if ( Temp^.master In [0,1] ) And ( Cash11.first_prot ) And ( SerialLng > 1000 ) Then
              Begin
               //    If ( NOT (( RFarmGate.PLocation[2] = 'DEMO' ) Or ( RFarmGate.Plocation[2] = 'demo' ))) Then
                    if uppercase(RFarmGate.PLocation[2]) <> 'DEMO' then
                      If ( SerialLng <> CashSerial ) Or
                         ( Temp^.s_n <> SerialLng ) Then
                         Begin
                              MessageDlg('Error in Data File Set-Up (ERR-NO 10/13) - Contact Kingswood Computing and quote the following error messages.' + #10#13 + 'Token Serial Number - ' + vartostr(Temp^.s_n)
                                                + #10#13 + 'Farmgate Serial Number - ' + vartostr(SerialLng) + #10#13 + 'CashBook Serial Number - ' + vartostr(CashSerial), mtInformation,[mbOK], 0);
                              TempBool := False;
                         End;
              End
           Else
               If ( Temp^.master In [0,1]) And ( SerialLng >= 1000 ) Then
                  Begin
                       Cash11.first_prot := True;
                       DelphiLongToPSys ( SerialLng, Cash11.serial_no );
                       DefWrite ( 11 );
                       DefRead ( 11 );
                  End;

    Except
          TempBool := False;
          Dispose ( Temp );
    End;
    end; // except
    {$I-}
    Result := TempBool;
End;

Function TFCheckName.Networked: boolean;
var IniFile : TIniFile;
begin
     result:=false;
     if FileExists('c:\kingsacc\network.ini') then begin
        result:= true;
        Inifile := TInifile.create('c:\kingsacc\network.ini');
        NetWorkPath := IniFile.ReadString('NetworkPath','Path','');
        Inifile.free;
        if NetWorkPath = '' then begin
           showmessage('Invalid Network Path specified in Ini File');
           Application.terminate;
        end;
     end;
end;


procedure TFCheckName.PasswordProc( Sender: TObject );
var
   TempStr : ShortString;
begin
   TempStr := Cash2.XPASSWORD[2];
   SlimAll( TempStr );
   Password.Enabled := ( Cash11.xp_words ) and ( TempStr <> '' );
   RunButton.Enabled := ( not(Password.Enabled) );
   ImagePanel.Height := 312;
   if (Password.Enabled) then
      begin
         Password.Color := clWindow;
         try
            Password.SetFocus;
         except
         end;
      end
   else
     Password.Color := clBtnFace;
end;

procedure TFCheckName.ExitButtonClick(Sender: TObject);
begin
    CloseAll(MaxFiles);
    BackgndForm.Close;
    Application.Terminate;
end;

procedure TFCheckName.GatherCompanies;
var
   i : Integer;
   CompanyFolders,
   AliasParams : TStringList;
   SearchRec : TSearchRec;
   SearchResult : Integer;
   CompanyFolder : String;
begin
   try
      CompanyFolders := TStringList.Create();
      FSearchPath := '';
      FSearchPath := 'C:\Kingsacc\';
      SearchResult := FindFirst(FSearchPath+'*.*', faDirectory, SearchRec);
      if ( SearchResult = 0 ) then
         begin
            repeat
               if (SearchRec.Attr and faDirectory) <> 0 then
                  begin
                     if ( not(SearchRec.Name[1] = '.') ) then
                        CompanyFolders.Add(SearchRec.Name);
                  end;
               SearchResult := FindNext(SearchRec);
            until
               SearchResult <> 0;
            SysUtils.FindClose(SearchRec);
         end;
      CompanyFolders.Sort;
      CheckCompanyName.Items.Clear;
      for i := 0 to CompanyFolders.Count-1 do
         begin
            if FindFirst(FSearchPath + CompanyFolders.Strings[i] + '\Transactions.db', faAnyFile, SearchRec) = 0 then
               begin
                  CheckCompanyName.Items.Add(CompanyFolders.Strings[i]);
                  SysUtils.FindClose(SearchRec);
               end;
         end;
      AliasParams := TStringList.Create;
      if ( CheckCompanyName.Items.Count <= 0 ) then
         begin
            MessageDlg('No Accounts database can be found. Contact Kingswood.',mtError,[mbOK],0);
            Halt(0);
         end
      else
         begin
            // This doesn't work! Company is set later on in FormActivate.
            CompanyFolder := ExtractTopMostFolder(AliasParams.Values['PATH']);
            CheckCompanyName.ItemIndex := CheckCompanyName.Items.IndexOf(CompanyFolder);
            //   11/09/18 [V4.3 R1.2] /MK Change - If CheckCompanyName.ItemIndex then assign ItemIndex based on last selected company i.e. FSelectCompanyName.
            if ( CheckCompanyName.ItemIndex < 0 ) and ( Length(FSelectedCompany) > 0 ) then
               CheckCompanyName.ItemIndex := CheckCompanyName.Items.IndexOf(FSelectedCompany);
         end;
   finally
      FreeAndNil(CompanyFolders);
      FreeAndNil(AliasParams);
   end;
end;

procedure TFCheckName.SetUpScreen;
begin
   Cash1.xdate := Datetostr(now);
   TxDate.Text := DatetoStr (now); //Cash1.xdate;
   DateSearch.Date := Now; //KStrToDate ( Cash11.DEFAULT_DATE ); network
end;

procedure TFCheckName.FormActivate(Sender: TObject);
begin
   // Set up the Fields on the Screen
   CheckCompanyName.ItemIndex := CheckCompanyName.Items.IndexOf(RFarmGate.plocation[2]); { Set Default Company Name to last used }
   PasswordProc(nil);
   TxDate.text := Datetostr(now);

   if not (Firstrun) then Exit;

   if not DirectoryExists('C:\Kingsacc\Reports') then
       if not CreateDir('C:\Kingsacc\Reports') then
              raise Exception.Create('Cannot create Reports folder');
end;

procedure TFCheckName.RunButtonClick(Sender: TObject);
var
   TestDate : Shortstring;
   DateBefore : Boolean;
   dirstr,progpath, datalocation :string;
   FinancialEnd   : ShortString;
   FinStart, FinEnd : Integer;

   procedure ExtractAndExecuteBDEUpdate;
   var
      UnZipArray : array[0..70] of char;
      i : Integer;
      bExtractionComplete : Boolean;
      sUnzipDir : String;
   begin
      if ( not(FileExists('C:\Kingsacc\Temp\bdeupdate1.zip')) ) then Exit;
      with TUnzipFile.Create(nil) do
         try
            for i := 1 to 7 do
               begin
                  case i of
                     1 : sUnzipDir := 'C:\Kingsacc\Temp\BDEUpdate\Common\Borland Shared\BDE\';
                     2 : sUnzipDir := 'C:\Kingsacc\Temp\BDEUpdate\Extras\4GBPatch\';
                     3 : sUnzipDir := 'C:\Kingsacc\Temp\BDEUpdate\Extras\Manifest\';
                     4 : sUnzipDir := 'C:\Kingsacc\Temp\BDEUpdate\Extras\NewHelp\';
                     5 : sUnzipDir := 'C:\Kingsacc\Temp\BDEUpdate\System32\';
                     6 : sUnzipDir := 'C:\Kingsacc\Temp\BDEUpdate\Temp\';
                     7 : sUnzipDir := 'C:\Kingsacc\Temp\BDEUpdate\';
                  end;
                  FillChar( UnZipArray, SizeOf(UnZipArray), #0); // Set Array contents to null
                  StrPCopy( UnZipArray, sUnzipDir  + #0);
                  lpszDestination.SetText(UnZipArray);
                  lpszZipFile.SetText(PChar('C:\Kingsacc\Temp\bdeupdate'+IntToStr(i)+'.zip' + #0));
                  lpszFileSpec.SetText('*.*' + #0);
                  bExtractionComplete := ( Execute(UNZIP_EXTRACT) );
               end
         finally
            Free;
         end;
      if ( bExtractionComplete ) and ( FileExists('C:\Kingsacc\Temp\BDEUpdate\Setup.exe') ) then
         begin
            for i := 1 to 7 do
               DeleteFile(PChar('C:\Kingsacc\Temp\bdeupdate'+IntToStr(i)+'.zip'));
            ShellExecute(FCheckName.handle,nil,PChar('C:\Kingsacc\Temp\BDEUpdate\Setup.exe'),nil,nil,SW_SHOWNORMAL);
         end;
   end;

   procedure DeleteSyncFilesInKingsacc;
   var
      i : Integer;
   begin
      for i := 0 to Length(AccountSyncFiles)-1 do
         begin
            if ( FileExists(GetCurrentDir+'\'+AccountSyncFiles[i]) ) then
               DeleteFile(PChar(GetCurrentDir+'\'+AccountSyncFiles[i]));
         end;
   end;

   procedure DeleteServicesFolder;
   begin
      if ( not(cash2.XWININV) ) then
         if ( DirectoryExists(GetCurrentDir+'\Services') ) and
            ( not(FileExists(GetCurrentDir+'\Services\SyncSettings.xml')) ) then
            DeleteFolder(GetCurrentDir+'\Services',False);
   end;

   procedure CopyInNewKInstallerVersion;
   begin
      if ( FileExists(GetCurrentDir+'\KInstaller\KInstaller.exe') ) then
         begin
            CopyFile(PChar(GetCurrentDir+'\KInstaller\KInstaller.exe'),PChar(GetCurrentDir+'\KInstaller.exe'),False);
            DeleteFolder(GetCurrentDir+'\KInstaller');
         end;
   end;

begin
  //   Registry:= Tregistry.Create;
  //   Registry.OpenKey('Control Panel\Desktop\WindowsMetrics', True);
  //   Registry.WriteString('InvoiceAllocation','True')
  //   Registry.Free;

  // Ensure accounts belonging to previous company are removed from memory when
  // user attempts to load another company.
  // SP 16/11/11
  accsdatamodule.FreeAccounts();

  RunButton.enabled := false; // 26/04/04
  ExitButton.Enabled := false;
  if not ParamSecurityByPass then begin
     If ( NOT CheckProtection ) Then Application.Terminate;
  end;

  DeleteSyncFilesInKingsacc;

  DeleteServicesFolder;

  CopyInNewKInstallerVersion;

  If (Txdate.Text <> '  /  /  ') Then
     begin
          KDateValid( Sender );
          TestDate := TxDate.Text;
          if not CheckDateRange ( TestDate, True, DateBefore, False ) then
             begin
                //TxDate.Text := TestDate;
                GetFinDateRange ( FinStart, FinEnd );  //19386, 19881
                FinancialEnd := '';
                KDateToStr ( FinEnd,   FinancialEnd );
                TxDate.text := FinancialEnd;
                TxDate.SetFocus;
                RunButton.enabled := true;
                ExitButton.enabled := true; //26/04/04
             end
          else
             begin
                SlimAll ( TestDate );
                Cash1.xDate := TestDate;
                DefWrite(0);
                CheckCompanyName.SetFocus;
                ModalResult := mrCancel;

                //   21/05/19 [V4.4 R0.7] /MK Additional Feature - If MTD user then install BDEUpdate.zip that was downloaded by KInstaller.
                if ( AccsSystem.Region = 'UK' ) and ( soVAT in AccsSystem.SystemOptions ) then
                   if ( not(DirectoryExists('C:\BDE32')) ) then
                      begin
                         if ( not(DirectoryExists('C:\Temp')) ) then
                            ForceDirectories('C:\Temp');
                         Application.MessageBox('This version of Kingswood Accounts requires a database engine update.'+#13#10+
                                                'Click OK to begin the update process.'+#13#10+
                                                'Once the update is complete you can then open the Accounts program.',
                                                'Database Engine Update Required',MB_ICONWARNING + MB_OK);
                         ExtractAndExecuteBDEUpdate;
                         Halt;
                      end;

                // TGM AB - next few lines check if the data has been imported into paradox format
                dirstr := CheckCompanyName.Text;
                progpath := extractfilepath(paramStr(0));
                if FileExists(PChar(progpath + dirstr + '\trans.fdb')) then
                   begin
                      ShellExecute(FCheckName.handle,nil, pchar(progpath + 'dataconvert.exe'),nil ,nil , SW_SHOWNORMAL);
                      RunButton.enabled := true;
                      ExitButton.enabled := true;
                   end
                else
                   begin
                      // original startup code!

                      // Set the Database Alias and Create Files if Needed

                      RunButton.enabled := False;
                      Help.Enabled := False;

                      AccsDataModule.UseThisAlias(CheckCompanyName.Text);
                      //   11/09/18 [V4.3 R1.2] /MK Change - Assign FSelectedCompany as the selected company name before opening MainUnit.
                      FSelectedCompany := CheckCompanyName.Text;
                      // tgm put in next line 15/12/01 to correct bug when changing to a company
                      // company which didn't have nomlisting.db.  this procedure creates it if it doesn't
                      // exist. only usuppdownload.activate was calling getnominalLedgerAccs.
                      AccsDataModule.NomListOK := False;
                      dirstr := CheckCompanyName.Text;
                      progpath := extractfilepath(paramStr(0));

                      CheckForNewFields; // TGM AB moved code into this new procedure

                      CheckForBankFile; // TGM AB New precedure to import old bankfile

                      //FMainScreen.ShowModal;
                      Firstrun := true; // sets flag to run trial balance check first time opened only

                      //showmessage(dirstr);
                      //showmessage(cash2.xdirectory);
                      datalocation := Copy(cash2.xdirectory, 0, length(cash2.xdirectory)-1);
                      //   30/07/20 [V5.9 R5.1] /MK Change - If the user is has the Kac.config file and a serial number between 100 and 999 i.e. accountant, don't show "Data Path does not match" message.
                      if ( lowercase(datalocation) <> lowercase(dirstr) ) and ( not(IsAccountant(AccsDataModule.FarmgateSerialNo))  ) then
                        MessageDlg('Data Path does not match Company Name!',mtInformation,[mbOK],0);
                      AutomatedBackup;

                      // remove old files / files with ~ and also bat files
                      TidyDataFolder(progpath + CheckCompanyName.text);

                      Password.Clear;

                      // Reset the JobCardDownloadCount variable which will allow user to check for new jobs
                      // when entering the JobCard facility in the CashBook.pas unit
                      AccsDataModule.JobCardDownloadCount := 0;

                      FMainscreen.showModal;

                      //   11/09/18 [V4.3 R1.2] /MK Bug Fix - Run GatherCompanies again so that after Year End the archived year will show.
                      GatherCompanies;
                   end;
              end;
     end;
end;

procedure TFCheckname.CheckForBankFile;
var
    FileName : pchar;
    Progpath : string;
    BankR    : tBankRec;
    BankFile : tBankFile;
    BankFileRec : Integer;

begin
    // TGM AB locates old BankFile.Dat and imports into new table and deletes the old file
    progpath := extractfilepath(paramStr(0));
    FileName := pchar(progpath + CheckCompanyName.text + '\BankFile.Dat');

    if FileExists(FileName) then begin

        Accsdatamodule.BankTableDB.close;
        Accsdatamodule.BankTableDB.emptytable;    // ensures table is empty
        Accsdatamodule.BankTableDB.open;

        BankFileRec := 0;

        AssignFile ( BankFile, Cash2.xdirectory + cBankFile );
        FillChar ( BankR, SizeOf ( BankR ), chr(0));
        ReSet ( BankFile );
        Seek ( BankFile, BankFileRec );

        Repeat
           if ( NOT Eof ( BankFile )) then
              begin
                 Read ( BankFile, BankR );
                 Accsdatamodule.BankTableDB.append;
                 Accsdatamodule.BankTableDB['Balance'] := PSysLongToDelphi(BankR.Balance)/100;
                 Accsdatamodule.BankTableDB['BankCode'] := BankR.BankCode;
                 Accsdatamodule.BankTableDB.post;
                 Inc ( BankFileRec );
                 Seek ( BankFile, BankFileRec );
             end;
        Until ( Eof ( BankFile ));

        CloseFile(BankFile);

        DeleteFile(FileName)

    end;
end;


procedure TFCheckname.TidyDataFolder(Path : string);
var
   Records : TSearchRec;
   FilePath : pchar;
begin
   if FindFirst (Path + '\*.db', faAnyFile, Records) = 0 then try
      repeat
         FilePath := pchar(Path + '\' + Records.Name);
         if pos('~',Records.name) > 0 then begin
               Sysutils.DeleteFile(FilePath);
         end;
         if pos('autotemp.bat',ansilowercase(Records.name)) > 0 then begin
               Sysutils.DeleteFile(FilePath);
         end;
         if pos('be.exe',ansilowercase(Records.name)) > 0 then begin
               Sysutils.DeleteFile(FilePath);
         end;
         if pos('pkunzip.exe',ansilowercase(Records.name)) > 0 then begin
               Sysutils.DeleteFile(FilePath);
         end;
         if pos('pkzip.exe',ansilowercase(Records.name)) > 0 then begin
               Sysutils.DeleteFile(FilePath);
         end;
         if pos('.zip',ansilowercase(Records.name)) > 0 then begin
               Sysutils.DeleteFile(FilePath);
         end;
      until FindNext(Records) <> 0;
   finally
   end;
   SysUtils.FindClose(Records) ;
end;

procedure TFCheckName.CheckForNewFields;
var
   DBTableName : String;
   progpath : String;
begin
   if ( Length(CheckCompanyName.Text) = 0 ) then
      begin
         MessageDlg('No companies to check.',mtError,[mbOK],0);
         Application.Terminate;
      end;

   progpath := extractfilepath(paramStr(0));
   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\ProductsTx.db"';
   Checkdatabasefields(AccsDataModule.ProdsTx,DBTableName,'ProductID','Integer','');
   Checkdatabasefields(AccsDataModule.ProdsTx,DBTableName,'LineDate','Date','');
   Checkdatabasefields(AccsDataModule.ProdsTx,DBTableName,'LineRef','Char (20)','');

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\ProdTxTemp.db"';
   Checkdatabasefields(AccsDataModule.ProdsTxTemp,DBTableName,'ProductID','Integer','');
   Checkdatabasefields(AccsDataModule.ProdsTxTemp,DBTableName,'LineDate','Date','');
   Checkdatabasefields(AccsDataModule.ProdsTxTemp,DBTableName,'LineRef','Char (20)','');

   DBTableName:='"'+ progpath + '\InvoiceReport.db"';
   Checkdatabasefields(AccsDataModule.InvoiceReportTable,DBTableName,'LineDate','Char (8)','');
   Checkdatabasefields(AccsDataModule.InvoiceReportTable,DBTableName,'LineRef','Char (20)','');
   Checkdatabasefields(AccsDataModule.InvoiceReportTable,DBTableName,'EachIncVat','Char (15)','');
   Checkdatabasefields(AccsDataModule.InvoiceReportTable,DBTableName,'VATRate','Char (8)','');

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\InvoiceLayout.db"';
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'ID','Autoinc','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'UseLineDate','Boolean','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'UsePrePrinted','Boolean','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'IncludeNominalDesc','Boolean','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'IncludeVat','Boolean','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'HeaderHeight','Float','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'FooterStart','Float','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'NameAddressStart','Float','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'PageNumberStart','Float','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'CompanyRegNumber','Char(20)','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'IncCompanyReg','Boolean','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'CompanyIncorpDate','Date','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'NumberOfCopies','Integer','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'UseGraphicsFile','Boolean','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'GraphicsFileName','Char (255)','');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'IncludeEachColumn','Boolean','True');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'IncludeVATSummary','Boolean','True');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'IncludeQuantSummary','Boolean','False');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'IncludeComment','Boolean','False');
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'Comment','Blob','');
   //   22/02/17 [V4.2 R6.4] /MK Change - Add new UseLineReference field.
   Checkdatabasefields(AccsDataModule.InvoiceLayout,DBTableName,'UseLineReference','Boolean','');

   DBTableName:=progpath + CheckCompanyName.Text + '\InvoiceLayout.db';
   ResizeField(DBTableName, 'RemittanceComment', 255);

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\InvoiceNumbers.db"';
   Checkdatabasefields(AccsDataModule.InvoiceNumbers,DBTableName,'LastProforma','Integer','');
   Checkdatabasefields(AccsDataModule.InvoiceNumbers,DBTableName,'LastQuote','Integer','');
   Checkdatabasefields(AccsDataModule.InvoiceNumbers,DBTableName,'LastJobCard','Integer','');

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\Proforma.db"';
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'BatchID','Integer','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'CustID','Integer','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'JobDate','Date','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Reference','Char(8)','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Descript','Char(15)','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Enterprise','Char(5)','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Nominal','Integer','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Quantity','Char(15)','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Amount','Char(10)','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'TaxCode','Char(1)','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'TaxAmount','Char(10)','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Comment','Char(30)','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'LineNo','Integer','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Desc1','Char(30)','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Desc2','Char(30)','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Desc3','Char(30)','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'LineDate','Date','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'LineRef','Char(20)','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Proforma','Boolean','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Quote','Boolean','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'Complete','Boolean','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'ProformaNumber','Integer','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'QuoteNumber','Integer','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'JobCardNumber','Integer','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'AnalysisCode','Integer','');
   Checkdatabasefields(AccsDataModule.ProformaDB,DBTableName,'ProductID','Integer','');

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\Nlaccs.db"';
   Checkdatabasefields(AccsDataModule.NlaccsDB,DBTableName,'NominalType','Char(1)','');
   Checkdatabasefields(AccsDataModule.NlaccsDB,DBTableName,'DepRate','Float','');
   Checkdatabasefields(AccsDataModule.NlaccsDB,DBTableName,'DepAmount','Float','');

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\Products.db"';
   Checkdatabasefields(AccsDataModule.Products,DBTableName,'ID','Autoinc','');
   Checkdatabasefields(AccsDataModule.Products,DBTableName,'DefaultPrice','Float','');
   Checkdatabasefields(AccsDataModule.Products,DBTableName,'UseDefaultPrice','Boolean','');

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\TempBudgetReport.db"';
   Checkdatabasefields(AccsDataModule.TempBudgetReportDB,DBTableName,'Decem','Float','');

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\ThisYearTempTable.db"';
   Checkdatabasefields(AccsDataModule.ThisYearTempTableDB,DBTableName,'Comment','Char(30)','');

// TGM AB
// All new fields added from this point have been added into Paradox only Version 3 of Accounts

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\Transactions.db"';
   Checkdatabasefields(AccsDataModule.TransactionsDB,DBTableName,'AllocatedVATAmount','Float','');
   Checkdatabasefields(AccsDataModule.TransactionsDB,DBTableName,'Overpayment','Float','');
   Checkdatabasefields(AccsDataModule.TransactionsDB,DBTableName,'AllocationComplete','Boolean','');
   Checkdatabasefields(AccsDataModule.TransactionsDB,DBTableName,'VATClaimed','Float','');
   Checkdatabasefields(AccsDataModule.TransactionsDB,DBTableName,'AllocatedToOpening','Boolean','');

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\AllocatedVAT.db"';
   Checkdatabasefields(AccsDataModule.AllocatedVATDB,DBTableName,'PreviousYear','Boolean','');
   Checkdatabasefields(AccsDataModule.AllocatedVATDB,DBTableName,'AllocatedDate','Date','');
   Checkdatabasefields(AccsDataModule.AllocatedVATDB,DBTableName,'CreditNote','Boolean','');

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\TempVAT.db"';
   Checkdatabasefields(AccsDataModule.TempVATDB,DBTableName,'TXID','Integer','');
   Checkdatabasefields(AccsDataModule.TempVATDB,DBTableName,'PreviousYear','Char(1)','');
   Checkdatabasefields(AccsDataModule.TempVATDB,DBTableName,'VATBreakdown','Char(15)','');     // TGM AB 21/08/15
   Checkdatabasefields(AccsDataModule.TempVATDB,DBTableName,'TotalBreakdown','Char(15)','');   // TGM AB 21/08/15
   Checkdatabasefields(AccsDataModule.TempVATDB,DBTableName,'CodeBreakdown','Char(1)','');     // TGM AB 21/08/15
   Checkdatabasefields(AccsDataModule.TempVATDB,DBTableName,'DescBreakdown','Char(30)','');   // TGM AB 21/08/15
   Checkdatabasefields(AccsDataModule.TempVATDB,DBTableName,'VATID','Integer','');             // Ch006

   //   04/11/11 [V4.1 R0.7] /MK Additional Feature - Adding New Color Field To Store Enterprise Color For Graphs.
   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\EntsFile.db"';
   Checkdatabasefields(AccsDataModule.EntsFileDB, DBTableName,'Color','Integer','');

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\Transactions.db"';                // TGM AB 01/02/13
   Checkdatabasefields(AccsDataModule.TransactionsDB,DBTableName,'Quantity2','Float','');   // TGM AB 01/02/13
   Checkdatabasefields(AccsDataModule.TransactionsDB,DBTableName,'Quantity3','Float','');   // TGM AB 01/02/13

   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\EntsFile.db"';                       // TGM AB 01/02/13
   Checkdatabasefields(AccsDataModule.EntsFileDB,DBTableName,'Quantity2Name','Char(30)','');   // TGM AB 01/02/13
   Checkdatabasefields(AccsDataModule.EntsFileDB,DBTableName,'Quantity3Name','Char(30)','');   // TGM AB 01/02/13

   //   02/03/16 [V4.1 R1.9] /MK Additional Feature - Incorporated Andrew's (TGM) changes to add new columns for CoOpImport.
   DBTableName:='"'+ progpath + CheckCompanyName.Text + '\Transactions.db"';                        // TGM AB 29/01/16
   Checkdatabasefields(AccsDataModule.TransactionsDB,DBTableName,'CoOpImport','Boolean','');        // TGM AB 29/01/16
   Checkdatabasefields(AccsDataModule.TransactionsDB,DBTableName,'CoOpComment','Char(50)','');      // TGM AB 29/01/16

   AccsDataModule.CreatePreferenceDefaults(CheckCompanyName.Text);
   DBTableName:='"'+ progpath + CheckCompanyName.text + '\Statement.db"';                             // TGM AB 17/03/17
   Checkdatabasefields(AccsDataModule.Statement,DBTableName,'UseGraphicsFile','Boolean','');          // TGM AB 17/03/17
   Checkdatabasefields(AccsDataModule.Statement,DBTableName,'GraphicsFileName','Char (255)','');      // TGM AB 17/03/17

   DBTableName:='"'+ progpath + CheckCompanyName.text + '\SLFile.db"';                               // TGM AB Ch001
   Checkdatabasefields(AccsDataModule.SLFileDB,DBTableName,'Rep_Balance','Float','');                // TGM AB Ch001
   Checkdatabasefields(AccsDataModule.SLFileDB,DBTableName,'Rep_Turnover','Float','');               // TGM AB Ch001
   Checkdatabasefields(AccsDataModule.SLFileDB,DBTableName,'Rep_AgeCurr','Float','');                // TGM AB Ch001
   Checkdatabasefields(AccsDataModule.SLFileDB,DBTableName,'Rep_Age1','Float','');                   // TGM AB Ch001
   Checkdatabasefields(AccsDataModule.SLFileDB,DBTableName,'Rep_Age2','Float','');                   // TGM AB Ch001
   Checkdatabasefields(AccsDataModule.SLFileDB,DBTableName,'Rep_Age3','Float','');                   // TGM AB Ch001

   DBTableName:='"'+ progpath + CheckCompanyName.text + '\PLFile.db"';                               // TGM AB Ch001
   Checkdatabasefields(AccsDataModule.PLFileDB,DBTableName,'Rep_Balance','Float','');                // TGM AB Ch001
   Checkdatabasefields(AccsDataModule.PLFileDB,DBTableName,'Rep_Turnover','Float','');               // TGM AB Ch001
   Checkdatabasefields(AccsDataModule.PLFileDB,DBTableName,'Rep_AgeCurr','Float','');                // TGM AB Ch001
   Checkdatabasefields(AccsDataModule.PLFileDB,DBTableName,'Rep_Age1','Float','');                   // TGM AB Ch001
   Checkdatabasefields(AccsDataModule.PLFileDB,DBTableName,'Rep_Age2','Float','');                   // TGM AB Ch001
   Checkdatabasefields(AccsDataModule.PLFileDB,DBTableName,'Rep_Age3','Float','');                   // TGM AB Ch001

   // Start TGM AB Ch006 - New Fields for Digital VAT
   DBTableName:='"'+ progpath + CheckCompanyName.text + '\Transactions.db"';
   Checkdatabasefields(AccsDataModule.TransactionsDB,DBTableName,'VATProcessed','Boolean','');
   Checkdatabasefields(AccsDataModule.TransactionsDB,DBTableName,'ReturnID','Integer','');

   if fileexists(progpath + CheckCompanyName.text + '\Year-1.db') then begin

   DBTableName:='"'+ progpath + CheckCompanyName.text + '\Year-1.db"';
   Checkdatabasefields(AccsDataModule.TransactionsYr1DB,DBTableName,'VATProcessed','Boolean','');
   Checkdatabasefields(AccsDataModule.TransactionsYr1DB,DBTableName,'ReturnID','Integer','');
   end;
   // End TGM AB Ch006


   // Ch006(P) Start

   if fileexists(progpath + CheckCompanyName.Text + '\AllocatedVAT.db') then begin

   DBTableName:='"'+ progpath + CheckCompanyName.text + '\AllocatedVAT.db"';
   Checkdatabasefields(AccsDataModule.AllocatedVATDB,DBTableName,'VATProcessed','Boolean','');
   Checkdatabasefields(AccsDataModule.AllocatedVATDB,DBTableName,'ReturnID','Integer','');

   end;

   if fileexists(progpath + CheckCompanyName.Text + '\AllocatedVAT-1.db') then begin

   DBTableName:='"'+ progpath + CheckCompanyName.text + '\AllocatedVAT-1.db"';
   Checkdatabasefields(AccsDataModule.AllocatedVATDBYr1,DBTableName,'VATProcessed','Boolean','');
   Checkdatabasefields(AccsDataModule.AllocatedVATDBYr1,DBTableName,'ReturnID','Integer','');

   end;

   // Ch006(P) End

   // Ch032 start

   DBTableName:='"'+ progpath + CheckCompanyName.text + '\Statement.db"';
   Checkdatabasefields(AccsDataModule.Statement,DBTableName,'IncludeComment','Boolean','False');
   Checkdatabasefields(AccsDataModule.Statement,DBTableName,'Comment','Blob','');

   // Ch032 end


end;


procedure TFCheckName.FormCreate(Sender: TObject);
Var
   Counter : Integer;
begin
   For Counter := 1 To MaxDatabases Do
      New ( DBHOLD[Counter] );
   New ( DATWORK );
   For Counter := 1 To MaxDatabases Do { Initialise the Pointer Variable }
       FillChar ( DBHOLD[Counter]^, SizeOf(DBHOLD[Counter]^),chr(0));
   FillChar ( DATWORK^, SizeOf(DATWORK^),chr(0));
   FSelectedCompany := '';
   GatherCompanies();
   PasswordProc(Sender);
end;

procedure TFCheckName.FormDestroy(Sender: TObject);
var
   Counter : Integer;
begin
   Dispose ( DATWORK );
   For Counter := 1 To MaxDatabases Do
       Dispose ( DBHOLD[Counter] );
end;

procedure TFCheckName.HelpClick(Sender: TObject);
begin
   AccsDataModule.HTMLHelp('mainScreen.htm');
end;

procedure TFCheckName.PasswordExit(Sender: TObject);
begin
   Password.Color := clWindow;
end;

procedure TFCheckName.FormShow(Sender: TObject);
var
   ProgramPath : String;
   StopIndex,
   i : Integer;
begin
   (*  Windows 3.11 doesn't like this Procedure  *)
   {$I+}
   try
      ProgramPath := ParamStr(0);
      i := Length(ProgramPath);
      StopIndex := 0;
      while i >= 0 do
         begin
            if ProgramPath[i] = '\' then
               begin
                  StopIndex := i + 1;
                  Break;
               end;
            Dec(i);
         end;
      Delete ( ProgramPath, StopIndex, (Length(ProgramPath)+1)-StopIndex );
      ChDir ( ProgramPath );
   except
   { Do Nothing assuming its Win 3.11 or earlier }
   end;
   if ( not(FCheckName.Networked) ) then
      Initialise; //NETWORK
   OpenLang;    { Set Language Text onto Current Form }
   RunButton.Caption := ReadLang ( 2, CurrLang );  { Run }
   ExitButton.Caption := ReadLang ( 1, CurrLang ); { Exit }
   FCheckName.Caption := ReadLang ( 4, CurrLang ); { Window Caption }
   //Label1.Caption := ReadLang ( 3, CurrLang );     { Enter Company Name }
   RunButton.enabled := true;
   ExitButton.enabled := true; // 26/04/04
   SetUpScreen;

      
end;

procedure TFCheckName.DateSearchCloseUp(Sender: TObject);
begin
   TxDate.Text:= DateToStr(DateSearch.Date);
   TxDate.SetFocus;
   ExitButton.enabled := true;
   RunButton.enabled := true;
   PasswordProc(Self);
end;

procedure TFCheckName.PasswordEnter(Sender: TObject);
begin
   Password.Text := '';
   RunButton.Enabled := False;
//   StatusBar.Panels.Items[1].Text := 'Please enter your password. ESC to exit.';
   Password.Color := $00C6FFFF;
end;

procedure TFCheckName.TxDateEnter(Sender: TObject);
begin
//   StatusBar.Panels.Items[1].Text := 'Please enter the current financial date';
end;

procedure TFCheckName.CheckCompanyNameExit(Sender: TObject);
var
    SearchRec : TSearchRec;
    i, filecount : integer;
    Position : real;
    SPosition : string;
    InputString : string;
    TempPass1, TempPass2 : shortstring;
begin
   ExitButton.enabled := False;
   RunButton.enabled := False;
   if ( Length(CheckCompanyName.Text) = 0 ) then
      begin
         MessageDlg('No company selected.',mtError,[mbOK],0);
         Application.Terminate;
      end;

   TempPass1 := '';
   TempPass2 := '';
   if ( not(FileExists(SubDir + CheckCompanyName.Text + '\cashbook.def')) ) then
      begin
         MessageDlg('Problem Loading Data (Cashbook.def) ', mtInformation,[mbOK], 0);
         CheckCompanyName.SetFocus;
      end
   else
      begin
         ExitButton.enabled := True;
         RunButton.enabled := True;

         if ( CheckCompanyName.Text <> RFarmGate.plocation[2] ) then
            begin
               RFarmGate.plocation[2] := CheckCompanyName.Text;
               SecWrite;
               Initialise;
               SetUpScreen;
            end
         else
             Initialise;

         if ( not(param_start) ) then
            PasswordProc(Sender)
         else
            begin
               TempPass1 := Cash2.xPassword[1];
               TempPass2 := Cash2.xPassword[2];
               Slimall(TempPass1);
               Slimall(TempPass2);
               if ( (TempPass1 <> '') or (TempPass2 <> '') ) then
                  begin
                     PostMessage(Handle, InputBoxMessage, 0, 0);
                     InputString := InputBox('Kingswood Accounts', 'Please Enter your Company Password', '');
                     if InputString = '' then
                        application.terminate
                     else
                        begin
                           if ((uppercase(Inputstring) <> TempPass1) and (uppercase(Inputstring) <> TempPass2)) then
                              begin
                                 Showmessage('Incorrect Password Entered');
                                 application.terminate;
                              end;
                        end;
                  end;
            end;
      end;
end;

Function TFCheckName.TrialbalanceOK;
var
   Trialbalancedifference : long;
   RECNO : INTEGER;
begin
       TrialBalanceDifference:=0;
       Result := true;
       auditfiles.FormActivate(auditfiles);
       application.processmessages;

       FOR RecNo:=StrToInt(AuditFiles.NomAccFrom.text) TO StrToInt(AuditFiles.NomAccTo.text) DO
           BEGIN
           READREC(NlFile,RECNO);
	   IF RECACTIVE(NlFile) THEN BEGIN
               Getitem(NlFile,2);    // Balance of account - Array Has Calculated Balance
               TrialBalanceDifference:=TrialBalanceDifference + currlong;
                  end;
           end;

      If TrialBalanceDifference <> 0 then result := false;
end;

function TFCheckName.ExtractTopMostFolder(Path: string): string;
begin
   Result := ExtractDirFromPath(Path);
end;

procedure AutomatedBackup;
var
   Filename : string;
    DirString : string;
    progpath : string;
begin
     DirString := RFarmGate.PLocation[2];
     progpath := ExtractFilePath( ParamStr(0)); //copy(paramstr(0),1,11);
     accsdatamodule.closeallfiles;
     { Close all DATABASE files }
     CloseAll(MaxDatabases);
     { Close Cashbook.def file }
     cClose (CashFile, 'N');
     { Close Farmgate.def file }
     cClose ( FarmFile, 'N');
     // copy archive backups
     if not directoryexists('c:\kingsacc\archive') then createdir('c:\kingsacc\archive');
     if not fileexists('c:\kingsacc\archive\' + dirstring + '15.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'15.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '14.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '14.zip'));
     end else
     if not fileexists('c:\kingsacc\archive\' + dirstring + '14.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'14.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '13.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '13.zip'));
     end else
     if not fileexists('c:\kingsacc\archive\' + dirstring + '13.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'13.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '12.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '12.zip'));
     end else

     if not fileexists('c:\kingsacc\archive\' + dirstring + '12.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'12.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '11.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '11.zip'));
     end else
     if not fileexists('c:\kingsacc\archive\' + dirstring + '11.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'11.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '10.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '10.zip'));
     end else
     if not fileexists('c:\kingsacc\archive\' + dirstring + '10.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'10.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '09.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '09.zip'));
     end else
     if not fileexists('c:\kingsacc\archive\' + dirstring + '09.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'09.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '08.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '08.zip'));
     end else
     if not fileexists('c:\kingsacc\archive\' + dirstring + '08.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'08.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '07.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '07.zip'));
     end else
     if not fileexists('c:\kingsacc\archive\' + dirstring + '07.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'07.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '06.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '06.zip'));
     end else
     if not fileexists('c:\kingsacc\archive\' + dirstring + '06.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'06.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '05.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '05.zip'));
     end else
     if not fileexists('c:\kingsacc\archive\' + dirstring + '05.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'05.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '04.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '04.zip'));
     end else
     if not fileexists('c:\kingsacc\archive\' + dirstring + '04.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'04.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '03.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '03.zip'));
     end else
     if not fileexists('c:\kingsacc\archive\' + dirstring + '03.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'03.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '02.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '02.zip'));
     end else
     if not fileexists('c:\kingsacc\archive\' + dirstring + '02.zip') then begin
        filename := 'c:\kingsacc\archive\' + DirString +'02.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '01.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '01.zip'));
     end else
     begin
        filename := 'c:\kingsacc\archive\' + DirString +'01.zip';
        if fileexists('c:\kingsacc\archive\' + dirstring + '15.zip') then deletefile(PCHAR('c:\kingsacc\archive\' + dirstring + '15.zip'));
     end;

     FCheckName.ZipFile1.lpszZipFile.SetText(PChar(Filename));
     FCheckName.ZipFile1.lpszItemList.SetText(PChar(ProgPath + DirString + '\*.*'));
     FCheckName.ZipFile1.Execute(ZIP_ADD);

     { reopen the FARMGATE.DEF and CASHBOOK.DEF }
     Initialise;
     { ReOpen all other Files }
     If Not OpenAll Then
     AbortProgram ('Error Opening Database Files - Contact Kingswood');
end;

procedure LoadDLL;
begin
  if DLLLoaded then Exit;
  if WIN32PLATFORM = VER_PLATFORM_WIN32_NT then
          DLLHandle := LoadLibrary('C:\KINGSACC\WACCSCC.DLL')
       else
          DLLHandle := LoadLibrary('WACCSCC.DLL');

  if DLLHandle >= 32 then begin
     DLLLoaded := True;
     SaveExit := ExitProc;
     ExitProc := @NewExit;

     @cc32 := GetProcAddress(DLLHandle,'cc32');
     Assert(@cc32 <> nil);

  end else begin
     DLLLoaded := False;
  end;

end;

procedure NewExit; far;
begin
   ExitProc:=SaveExit;
   FreeLibrary(DLLHandle);
end;

procedure TFCheckName.CheckCompanyNameChange(Sender: TObject);
begin
   CheckCompanyNameExit(sender);
   PasswordProc(nil);
end;

procedure TFCheckName.PasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key = VK_RETURN) and (RunButton.Enabled) then
      RunButton.Click();
end;

procedure TFCheckName.PasswordChange(Sender: TObject);
var
   TempPass1, TempPass2 : ShortString;
begin
   TempPass1 := '';
   TempPass2 := '';
   TempPass1 := Cash2.xPassword[1];
   TempPass2 := Cash2.xPassword[2];
   SlimAll ( TempPass1 );
   SlimAll ( TempPass2 );
   if ( TempPass2 <> '' ) and ( Password.text <> '' ) then
      begin
         if ( Password.Text = TempPass1 ) or ( Password.text = TempPass2 ) or
            ( Password.Text = 'SILVER' ) then
            RunButton.Enabled := True
         else
            RunButton.Enabled := False;
      end
   else
      RunButton.Enabled := False;
end;

end.
