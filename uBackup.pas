unit uBackup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uBaseForm, ActnList, dxBar, dxBarExtItems, cxControls, dxStatusBar,
  Grids, ExtCtrls, StdCtrls, ComCtrls, DynaLibU, DynaZip, DynaLibZ,
  cxProgressBar;

type
  TBackupForm = class(TBaseForm)
    blbBackup: TdxBarLargeButton;
    blbRestore: TdxBarLargeButton;
    blbUndo: TdxBarLargeButton;
    BarPopupMenu: TdxBarPopupMenu;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    actBackupToCD: TAction;
    actBackupToExternal: TAction;
    ZipFile1: TZipFile;
    UnzipFile1: TUnzipFile;
    RemoveablePanel: TPanel;
    PanelLabel: TLabel;
    DriveStringGrid: TStringGrid;
    UndoPanel: TPanel;
    label1: TLabel;
    FileListGrid: TStringGrid;
    RestorePanel: TPanel;
    Label2: TLabel;
    RestoreFilesGrid: TStringGrid;
    actUndo: TAction;
    actRestore: TAction;
    StatusBarContainer: TdxStatusBarContainerControl;
    procedure blbBackupClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actBackupToExternalExecute(Sender: TObject);
    procedure ZipFile1MinorCallback(szItem: PChar; Percent: Integer;
      var DoCancel: Boolean);
    procedure actUndoExecute(Sender: TObject);
    procedure RestoreFilesGridDblClick(Sender: TObject);
    procedure FileListGridDblClick(Sender: TObject);
    procedure DriveStringGridDblClick(Sender: TObject);
    procedure actRestoreExecute(Sender: TObject);
    procedure actBackupToCDExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FProgressBar : TcxProgressBar;
    FFormOriginalHeight, FFormOriginalWidth : Integer;
    procedure Backup(Letter : char);
    procedure BackupToCD;
    procedure Restore(Filename : string);
    procedure BuildRestoreList(Letter : string);
    procedure RestoreFormToOriginalSize;
    procedure ResizeForm(AHeight, AWidth : Integer);

    function GetBackupFileName(const AOriginalFileName : string) : string;
  public
    { Public declarations }
  end;

var
  BackupForm: TBackupForm;
  BackingUp, Restoring : boolean;

implementation
uses
   AccsData, Mainunit, Params, DbGen, Types, Filed, Init,
   AbortPrg;

{$R *.DFM}

procedure TBackupForm.blbBackupClick(Sender: TObject);
var
   pt : TPoint;
begin
  inherited;
  GetCursorPos(pt);
  BarPopupMenu.Popup(pt.x, pt.y);
end;

procedure TBackupForm.BackupToCD;
var
      XPBurnDllPath : PChar;
      RunCmd, cCDBackupExeName, ZipFilePath : string;

      Filename,mbMessage:string;
      mbResult:integer;
      DirString : string;
      progpath : string;
      filecount : integer;
      SearchRec: TSearchRec;
      backupfail : boolean;


begin
     XPBurnDllPath := PChar('C:\Kingsacc\XPBurnObj.dll');
     cCDBackupExeName := 'C:\Kingsacc\CDBackup.exe';
  //   ZipFilePath := 'C:\Kingsacc\NCont.zip';

     actExit.enabled := false;
     Screen.Cursor := crHourGlass;
     MbMessage:='About to backup accounts files. OK to Continue?';
     mbresult := Application.Messagebox(PChar(MbMessage), 'Confirm', MB_YESNO + MB_ICONQUESTION);
     if mbresult = 7 then begin
        Screen.Cursor := crDefault;
        actExit.enabled := true;
        Showmessage('Backup not complete!');
        close;
        exit;
     end;

 //    showmessage('Please insert a floppy disk and click OK when ready.');
     Application.ProcessMessages;
     FProgressBar.Visible := True;
     FProgressBar.Position := 10;

     Statusbar.Panels[0].Text := 'Backing up files, please wait..';
     Application.ProcessMessages;
     DirString := RFarmGate.PLocation[2];
     progpath := ExtractFilePath( ParamStr(0)); //copy(paramstr(0),1,11);

     //SlimAll ( DirString );
     accsdatamodule.closeallfiles;
     { Close all DATABASE files }
     CloseAll(MaxDatabases);
     { Close Cashbook.def file }
     cClose (CashFile, 'N');
     { Close Farmgate.def file }
     cClose ( FarmFile, 'N');
     // copy archive backups
     if fileexists('c:\' + dirstring + '.003') then copyfile(PCHAR('c:\' + dirstring + '.003'),PCHAR('c:\' + dirstring + '.004'),false);
     if fileexists('c:\' + dirstring + '.002') then copyfile(PCHAR('c:\' + dirstring + '.002'),PCHAR('c:\' + dirstring + '.003'),false);
     if fileexists('c:\' + dirstring + '.001') then copyfile(PCHAR('c:\' + dirstring + '.001'),PCHAR('c:\' + dirstring + '.002'),false);
     // create new archive backup
     if fileexists('c:\' + dirstring + '.001') then deletefile('c:\' + dirstring + '.001');
     FProgressBar.position := 20;
     filename := 'c:\' + DirString +'.001';
     ZipFile1.lpszZipFile.SetText(PChar(Filename));
     ZipFile1.lpszItemList.SetText(PChar(ProgPath + DirString + '\*.*'));
     ZipFile1.Execute(ZIP_ADD);
     FProgressBar.position := 40;
     Statusbar.Panels[0].Text := '';
     Application.ProcessMessages;


     filename := 'c:\' + DirString;
     if fileexists(filename +'.zip') then deletefile (filename +'.zip');
     ZipFile1.lpszZipFile.SetText(PChar(Filename));
     ZipFile1.lpszItemList.SetText(PChar(ProgPath + DirString + '\*.*'));
     if not ZipFile1.Execute(ZIP_ADD) then messageDlg('Your Accounts Backup File Cannot Be Created!', mtInformation, [mbOK],0);
     FProgressBar.position := 60;
     UnZipFile1.lpszZipFile.SetText(PChar('c:\'+ DirString +'.zip'));
     UnZipFile1.lpszFileSpec.SetText('*.*');
     UnZipFile1.Options:=[TestFlag];
     Statusbar.Panels[0].Text := 'Testing Integrity of backup file';
     Application.ProcessMessages;
     FProgressBar.position := 80;
     if not UnZipFile1.Execute(UNZIP_EXTRACT) then showmessage('Warning, Backup File failed integrity test!');
     FProgressBar.position := 100;

     Screen.Cursor := crDefault;

     Statusbar.Panels[0].Text := 'Preparing to Copy File To CD';
     Application.ProcessMessages;
     FProgressBar.position := 0;


     ZipFilePath := 'c:\'+ DirString +'.zip';

     if FileExists( XPBurnDllPath ) then WinExec(PChar('regsvr32 "'+  XPBurnDllPath+'" /s'), SW_HIDE);

     RunCmd := cCDBackupExeName + ' ' + '"' + ZipFilePath + '"';
     WinExec(PChar(RunCmd), SW_SHOWNORMAL);

     Statusbar.Panels[0].Text := 'Preparing to Copy File To CD';

     { reopen the FARMGATE.DEF and CASHBOOK.DEF }
     Initialise;
     { ReOpen all other Files }
     If Not OpenAll Then AbortProgram ('Error Opening Database Files - Contact Kingswood');

     FProgressBar.Visible := False;
     actExit.enabled := true;
end;

procedure TBackupForm.Backup(Letter: char);
var Filename,mbMessage:string;
    mbResult:integer;
    dbname:string[40];
    i:integer;
    DirString : string;
    progpath : string;
    filecount : integer;
    SearchRec: TSearchRec;
    backupfail : boolean;
    TempStr : string;


begin
     backupfail := false;
     actExit.enabled := false;
     Screen.Cursor := crHourGlass;
     MbMessage:='About to backup accounts files. OK to Continue?';
     mbresult := Application.Messagebox(PChar(MbMessage), 'Confirm', MB_YESNO + MB_ICONQUESTION);
     if mbresult = 7 then begin
        Screen.Cursor := crDefault;
        actExit.enabled := true;
        Showmessage('Backup not complete!');
        close;
        exit;
     end;

     if letter = 'A' then showmessage('Please insert a floppy disk and click OK when ready.');
     Application.ProcessMessages;
     FProgressBar.Visible := True;

     FProgressBar.position := 10;
     Statusbar.Panels[0].Text := 'Backing up files, please wait..';

     Application.ProcessMessages;
     DirString := RFarmGate.PLocation[2];
     progpath := ExtractFilePath( ParamStr(0)); //copy(paramstr(0),1,11);

     //SlimAll ( DirString );
     accsdatamodule.closeallfiles;
     { Close all DATABASE files }
     CloseAll(MaxDatabases);
     { Close Cashbook.def file }
     cClose (CashFile, 'N');
     { Close Farmgate.def file }
     cClose ( FarmFile, 'N');
     // copy archive backups
     if fileexists('c:\' + dirstring + '.003') then copyfile(PCHAR('c:\' + dirstring + '.003'),PCHAR('c:\' + dirstring + '.004'),false);
     if fileexists('c:\' + dirstring + '.002') then copyfile(PCHAR('c:\' + dirstring + '.002'),PCHAR('c:\' + dirstring + '.003'),false);
     if fileexists('c:\' + dirstring + '.001') then copyfile(PCHAR('c:\' + dirstring + '.001'),PCHAR('c:\' + dirstring + '.002'),false);
     // create new archive backup
     if fileexists('c:\' + dirstring + '.001') then deletefile('c:\' + dirstring + '.001');
     FProgressBar.position := 20;
     filename := 'c:\' + DirString +'.001';
     ZipFile1.lpszZipFile.SetText(PChar(Filename));
     ZipFile1.lpszItemList.SetText(PChar(ProgPath + DirString + '\*.*'));
     ZipFile1.Execute(ZIP_ADD);
     FProgressBar.position := 40;
     Statusbar.Panels[0].Text := 'Copying files to backup device';

     Application.ProcessMessages;

     if letter = 'A' then begin
         filename := ansilowercase(Letter) + ':\' + DirString + '.zip';
         if fileexists(filename) then deletefile (filename);
     end
         else begin
{                    Filename := ansilowercase(Letter) + ':\' + DirString;
                    Tempstr := Datetostr(Date);
                    Filename := Filename + '_' + Tempstr[1] + Tempstr[2] + '_' + Tempstr[4] + Tempstr[5] + '_' +Tempstr[7] + Tempstr[8];
                    Tempstr := TimeToStr(Now);
                    Filename := Filename + '_' + Tempstr[1] + Tempstr[2] + '.' + Tempstr[4] + Tempstr[5] + '.zip';

}
                    FileName := GetBackupFileName(AnsiLowerCase(Letter) + ':\' + DirString);

                    if fileexists(filename) then deletefile (filename);
         end;

     ZipFile1.lpszZipFile.SetText(PChar(Filename));
     ZipFile1.lpszItemList.SetText(PChar(ProgPath + DirString + '\*.*'));
     if ZipFile1.Execute(ZIP_ADD) then
        messageDlg('Backup Complete', mtInformation, [mbOK],0)
     else begin
          Backupfail := true;
          if letter = 'A' then messageDlg('Your Accounts Backup Failed.  Please try again with a new floppy disk!', mtInformation, [mbOK],0)
                else messageDlg('Your Accounts Backup Failed.  Please try again', mtInformation, [mbOK],0);
          end;
     FProgressBar.position := 60;
 //      UnZipFile1.lpszZipFile.SetText(PChar(ansilowercase(Letter) + ':\'+ DirString +'.zip'));
     if not backupfail then begin
       UnZipFile1.lpszZipFile.SetText(PChar(Filename));
       UnZipFile1.lpszFileSpec.SetText('*.*');
       UnZipFile1.Options:=[TestFlag];

       Statusbar.Panels[0].Text := 'Testing Integrity of backup';

       Application.ProcessMessages;
       FProgressBar.position := 80;
       if UnZipFile1.Execute(UNZIP_EXTRACT) then
          showmessage('Backup Test OK!')
       else begin
            if letter = 'A' then showmessage('Warning, Backup failed integrity test! Please backup again with a new disk')
                else showmessage('Warning, Backup failed integrity test! Please backup again');
       end;

     end;

       FProgressBar.position := 100;

     Screen.Cursor := crDefault;
     Statusbar.Panels[0].Text := '';

       { reopen the FARMGATE.DEF and CASHBOOK.DEF }
       Initialise;
       { ReOpen all other Files }
       If Not OpenAll Then
       AbortProgram ('Error Opening Database Files - Contact Kingswood');


       //              TTable(Components[i]).Active := False
       actExit.enabled := true;
       FProgressBar.Visible := False;
       self.close;
end;

procedure TBackupForm.Restore(Filename: string);
var
   BakFileName,mbMessage,result: String;
   i,fc:integer;
    mbResult:integer;
    s:string;
    DirString,ProgPath : string;
begin
     DirString := RFarmGate.PLocation[2];
     progpath := ExtractFilePath( ParamStr(0)); //copy(paramstr(0),1,11);

     result := InputBox('WARNING, This will overwrite current data.', 'Type the word RESTORE if you wish to continue', '');
     If UpperCase(result) = 'RESTORE' then
     begin
     Screen.Cursor := crHourGlass;
  //   filename:=inputbox('Restore Files', 'Restore Files From: ', 'a:\' + dirstring + '.zip');
     MbMessage:='Restore ' + dirstring + ' Files from ' + filename + '?';
     mbresult := Application.Messagebox(PChar(MbMessage), 'Confirm', MB_YESNO + MB_ICONQUESTION);
     if mbresult = 7 then exit;
     Statusbar.Panels[0].Text := 'Closing Accounts Datafiles.';
     Application.processMessages;
     accsdatamodule.closeallfiles;
     { Close all DATABASE files }
     CloseAll(MaxDatabases);
     { Close Cashbook.def file }
     cClose (CashFile, 'N');
     { Close Farmgate.def file }
     cClose ( FarmFile, 'N');

     //       ProgressForm.Show;
 //    showmessage('Please insert the backup floppy from which you wish to restore your backup now, and click OK');
     Screen.Cursor := crHourGlass;
     FProgressBar.Visible := True;

     Application.processmessages;
     Statusbar.Panels[0].Text := 'Creating Hard Disk Backup of existing files';
     Application.processmessages;
     if fileexists('c:\' + dirstring + '02.BAK') then copyfile(PCHAR('c:\' + dirstring + '02.BAK'),PCHAR('c:\' + dirstring + '03.BAK'),false);
     if fileexists('c:\' + dirstring + '01.BAK') then copyfile(PCHAR('c:\' + dirstring + '01.BAK'),PCHAR('c:\' + dirstring + '02.BAK'),false);
     if fileexists('c:\' + dirstring + '01.BAK') then deletefile('c:\' + dirstring + '01.BAK');
     // create new archive backup
     Bakfilename := 'c:\' + DirString +'01.BAK';
     ZipFile1.lpszZipFile.SetText(PChar(BakFileName));
     ZipFile1.lpszItemList.SetText(pchar(progpath + dirstring + '\*.*'));
     ZipFile1.Execute(ZIP_ADD);

     Statusbar.Panels[0].Text := 'Restoring files ...';

     Application.processmessages;
       UnZipFile1.lpszZipFile.SetText(PChar(FileName));
       if UnzipFile1.Execute(UNZIP_COUNTALLZIPMEMBERS)then
          fc := UnzipFile1.ReturnCount
       else
          fc := 0;
       UnZipFile1.Options:=[OverWriteFlag];
       UnZipFile1.lpszDestination.SetText(pchar(progpath + dirstring));
       UnZipFile1.lpszDecryptCode.settext(pchar('copper'));
       application.processmessages;
       for i:= 1 to fc do begin
       if UnzipFile1.Execute(UNZIP_GETNEXTZIPINFO)then
          begin
               s := StrPas(UnzipFile1.zInfo^.szFileName);
               UnzipFile1.lpszFileSpec.SetText(PChar(s));
               UnZipFile1.Execute(UNZIP_EXTRACT);
               FProgressBar.Position:=round((i/fc)*100);
               FProgressBar.Refresh;
          end;
       end;
       Screen.Cursor := crDefault;
       FProgressBar.Visible := False;
       messagedlg('Restore Completed OK', mtInformation,[mbOK],0);
       Initialise;
       AccsDataModule.OpenAllFiles;
       { ReOpen all other Files }
       If Not OpenAll Then
       AbortProgram ('Error Opening Database Files - Contact Kingswood');

       FMainscreen.LoadTransactionGrid;
       //FCheckName.RunButtonClick(self);
       self.close;
     end;
end;

procedure TBackupForm.FormShow(Sender: TObject);
begin
  inherited;
     Backingup := False;
     Restoring := False;
     Statusbar.Panels[0].Text := '';
     FProgressBar.position := 0;
     actRestore.Visible := True;
     blbBackup.Visible := ivAlways;
     Restorepanel.visible := False;
     Undopanel.visible := False;
     actUndo.Visible := True;
//     ResizeForm(180, 420);

//     Backupform.Position := Mainunit.FMainScreen.Position;
 //    if RemovableDriveCount > 0 then RemoveablesBtn.visible := true
 //       else  RemoveablesBtn.visible := false;
     Removeablepanel.Visible := false;
end;

procedure TBackupForm.actBackupToExternalExecute(Sender: TObject);
var
  Drive, Backuplocation: Char;
  DriveLetter: String;
  Rowcount, i : integer;

  VolumeName: array[0..30] of Char;
  dummy: Cardinal;

begin
     Backingup := True;
     Restoring := False;
     PanelLabel.caption := 'Select Drive to store data backup';
     blbBackup.Visible := ivNever;
     actRestore.Visible := False;
     actUndo.Visible := False;
     Restorepanel.visible := False;
     Undopanel.visible := False;
     Removeablepanel.Visible := true;
     RestoreFormToOriginalSize;
     Rowcount := 0;
     DriveStringGrid.Cells[0,Rowcount] := 'Drive';
     DriveStringGrid.Cells[1,Rowcount] := 'Description';
     DriveStringGrid.Cells[2,Rowcount] := 'Drive Name';
     Rowcount := 1;
     for Drive := 'A' to 'Z' do begin
                DriveLetter := Drive + ':\';

                case GetDriveType(PChar(DriveLetter)) of

                DRIVE_REMOVABLE: begin
                if ((Drive <> 'A') and (Drive <> 'B')) then begin
                                        DriveStringGrid.Cells[0,Rowcount] :=  DriveLetter;
                                        DriveStringGrid.Cells[1,Rowcount] := 'Removeable Drive';
                                        GetVolumeInformation( pchar(DriveLetter), volumename, sizeof(volumename), nil, dummy, dummy, nil, 0 );
                                           try DriveStringGrid.Cells[2,Rowcount] := strpas(volumename);
                                           except;
                                           end;
                                        Inc(Rowcount);
                                        DriveStringGrid.RowCount := DriveStringGrid.RowCount + 1;
                                     end
                        else begin
                                DriveStringGrid.Cells[0,Rowcount] :=  DriveLetter;
                                DriveStringGrid.Cells[1,Rowcount] := 'Floppy Drive';
                                GetVolumeInformation( pchar(DriveLetter), volumename, sizeof(volumename), nil, dummy, dummy, nil, 0 );
                                   try DriveStringGrid.Cells[2,Rowcount] := strpas(volumename);
                                   except;
                                   end;
                                DriveStringGrid.RowCount := DriveStringGrid.RowCount + 1;
                                Inc(Rowcount);
                        end;
                end;
                DRIVE_FIXED: begin
                DriveStringGrid.Cells[0,Rowcount] :=  DriveLetter;
                DriveStringGrid.Cells[1,Rowcount] := 'Hard Drive (Not Recommended)';
                GetVolumeInformation( pchar(DriveLetter), volumename, sizeof(volumename), nil, dummy, dummy, nil, 0 );
                     try DriveStringGrid.Cells[2,Rowcount] := strpas(volumename);
                     except;
                     end;
                     DriveStringGrid.RowCount := DriveStringGrid.RowCount + 1;
                     Inc(Rowcount);
                end;
                DRIVE_REMOTE: begin
                DriveStringGrid.Cells[0,Rowcount] :=  DriveLetter;
                DriveStringGrid.Cells[1,Rowcount] := 'Network Drive';
                GetVolumeInformation( pchar(DriveLetter), volumename, sizeof(volumename), nil, dummy, dummy, nil, 0 );
                     try DriveStringGrid.Cells[2,Rowcount] := strpas(volumename);
                     except;
                     end;
                     DriveStringGrid.RowCount := DriveStringGrid.RowCount + 1;
                     Inc(Rowcount);
                end;
                DRIVE_CDROM: begin
                end;
                DRIVE_RAMDISK: begin
                end;
                DRIVE_NO_ROOT_DIR: begin
                end;
                DRIVE_UNKNOWN: begin
                DriveStringGrid.Cells[0,Rowcount] :=  DriveLetter;
                DriveStringGrid.Cells[1,Rowcount] := 'Unknown Drive - No Recommended';
                DriveStringGrid.RowCount := DriveStringGrid.RowCount + 1;
                Inc(Rowcount);
                end;
                end;  // case
     end;

end;

procedure TBackupForm.ZipFile1MinorCallback(szItem: PChar;
  Percent: Integer; var DoCancel: Boolean);
begin
  inherited;
   FProgressBar.Position := Percent;
//   ProgressBar1.Text := StrPas(szItem);
   Application.ProcessMessages;
//   DoCancel := CancelStatus;
end;

procedure TBackupForm.actUndoExecute(Sender: TObject);
var
   searchrec : Sysutils.TSearchRec;
   Stringlist : TStringlist;
   i : integer;
   position : integer;
begin
     blbBackup.Visible := ivNever;
     actRestore.Visible := False;
//     ResizeForm(180, 420);
     Undopanel.visible := True;
     Restorepanel.visible := False;
     Removeablepanel.Visible := false;

     Stringlist := TStringlist.Create;
     for i:= 0 to 16 do begin
         Filelistgrid.cells[0,i] := '';
         Filelistgrid.cells[1,i] := '';
     end;
     if FindFirst('c:\kingsacc\archive\' + RFarmGate.PLocation[2] + '*.zip', faAnyFile, SearchRec) = 0 then repeat
     Stringlist.Add(FormatDateTime(cddmmyyyyhhnn,FileDateToDateTime(SearchRec.time)) + ',' + SearchRec.name);
     until FindNext(searchRec) <> 0;
     Stringlist.Sort;
     For i:=(Stringlist.Count-1) downto 0 do begin
         position := pos(',',Stringlist.strings[i]);
         Filelistgrid.cells[0,i] := '  ' + copy(Stringlist.strings[i],0,position-1);
         Filelistgrid.cells[1,i] := 'c:\kingsacc\archive\' + copy(Stringlist.strings[i],position+1,length(Stringlist.strings[i])-position);
     end;
     Sysutils.FindClose(searchRec);
     Stringlist.Destroy;

     FilelistGrid.ColWidths[1] := 0;

     RestoreFormToOriginalSize;
     application.processmessages;
     Undopanel.visible := True;
end;

procedure TBackupForm.RestoreFilesGridDblClick(Sender: TObject);
begin
  inherited;
        try Restore(RestoreFilesGrid.Cells[1,RestoreFilesGrid.Row]);
        except showmessage('Restore Error - Please Try Again');
        end;
end;

procedure TBackupForm.FileListGridDblClick(Sender: TObject);
var
    BakFileName,Filename, result : String;
    i,fc:integer;
    s:string;
    DirString,ProgPath : string;
begin
     DirString := RFarmGate.PLocation[2];
     progpath := ExtractFilePath( ParamStr(0)); //copy(paramstr(0),1,11);
     filename:= FileListGrid.Cells[1,FileListGrid.Row];

     result := InputBox('WARNING, This will overwrite current data.', 'Type the word RESTORE if you wish to continue', '');
     If UpperCase(result) = 'RESTORE' then
     begin
     Statusbar.Panels[0].Text := 'Closing Accounts Datafiles.';

     Application.processMessages;
     accsdatamodule.closeallfiles;
     { Close all DATABASE files }
     CloseAll(MaxDatabases);
     { Close Cashbook.def file }
     cClose (CashFile, 'N');
     { Close Farmgate.def file }
     cClose ( FarmFile, 'N');

     Restorepanel.visible := False;
//     ResizeForm(180, 420);
     Undopanel.visible := False;

     Screen.Cursor := crHourGlass;
     FProgressBar.Visible := True;
     Application.processmessages;
     Statusbar.Panels[0].Text := 'Creating Hard Disk Backup of existing files';
     Application.processmessages;
     if fileexists('c:\' + dirstring + '02.BAK') then copyfile(PCHAR('c:\' + dirstring + '02.BAK'),PCHAR('c:\' + dirstring + '03.BAK'),false);
     if fileexists('c:\' + dirstring + '01.BAK') then copyfile(PCHAR('c:\' + dirstring + '01.BAK'),PCHAR('c:\' + dirstring + '02.BAK'),false);
     if fileexists('c:\' + dirstring + '01.BAK') then deletefile('c:\' + dirstring + '01.BAK');
     // create new archive backup
     Bakfilename := 'c:\' + DirString +'01.BAK';
     ZipFile1.lpszZipFile.SetText(PChar(BakFileName));
     ZipFile1.lpszItemList.SetText(pchar(progpath + dirstring + '\*.*'));
     ZipFile1.Execute(ZIP_ADD);
     Statusbar.Panels[0].Text := 'Restoring Undo Point, please wait..';
     Application.processmessages;
       UnZipFile1.lpszZipFile.SetText(PChar(FileName));
       if UnzipFile1.Execute(UNZIP_COUNTALLZIPMEMBERS)then
          fc := UnzipFile1.ReturnCount
       else
          fc := 0;
       UnZipFile1.Options:=[OverWriteFlag];
       UnZipFile1.lpszDestination.SetText(pchar(progpath + dirstring));
       application.processmessages;
       for i:= 1 to fc do begin
       if UnzipFile1.Execute(UNZIP_GETNEXTZIPINFO)then
          begin
               s := StrPas(UnzipFile1.zInfo^.szFileName);
               UnzipFile1.lpszFileSpec.SetText(PChar(s));
               UnZipFile1.Execute(UNZIP_EXTRACT);
               FProgressBar.Position:=round((i/fc)*100);
               FProgressBar.Refresh;
          end;
       end;
       Screen.Cursor := crDefault;
       FProgressBar.Visible := False;

       messagedlg('Undo Completed OK', mtInformation,[mbOK],0);
       Initialise;
       AccsDataModule.OpenAllFiles;
       { ReOpen all other Files }
       If Not OpenAll Then
       AbortProgram ('Error Opening Database Files - Contact Kingswood');

       FMainscreen.LoadTransactionGrid;
       //FCheckName.RunButtonClick(self);
       self.close;
     end;


end;

procedure TBackupForm.DriveStringGridDblClick(Sender: TObject);
var
        DriveLetter : string;
begin
        if Restoring then begin
                     try DriveLetter := DriveStringGrid.Cells[0,DriveStringGrid.Row];
                         BuildRestoreList(DriveLetter[1]);
                     except showmessage('Restore Error - Please Try Again');
                     end;
        end;
        if Backingup then begin
                     try DriveLetter := DriveStringGrid.Cells[0,DriveStringGrid.Row];
                     Backup(DriveLetter[1]);
                     except showmessage('Backup Error - Please Try Again');
                     end;
        end;

end;

procedure TBackupForm.BuildRestoreList(Letter: string);
var
   searchrec : Sysutils.TSearchRec;
   Stringlist : TStringlist;
   i : integer;
   position : integer;
begin
     for i:= 0 to 50 do begin
         Filelistgrid.cells[0,i] := '';
         Filelistgrid.cells[1,i] := '';
     end;

     Stringlist := TStringlist.Create;

     if FindFirst( Letter + ':\' + RFarmGate.PLocation[2] + '*.zip', faAnyFile, SearchRec) = 0 then repeat
     Stringlist.Add(FormatDateTime(cddmmyyyyhhnn,FileDateToDateTime(SearchRec.time)) + ',' + SearchRec.name);
     until FindNext(searchRec) <> 0;

     Stringlist.Sort;
     For i:=(Stringlist.Count-1) downto 0 do begin
         position := pos(',',Stringlist.strings[i]);
         RestoreFilesgrid.cells[0,i] := copy(Stringlist.strings[i],0,position-1);
         RestoreFilesgrid.cells[1,i] := Letter + ':\' + copy(Stringlist.strings[i],position+1,length(Stringlist.strings[i])-position);
     end;
     Sysutils.FindClose(searchRec);
     Stringlist.Destroy;

 //    FilelistGrid.ColWidths[1] := 0;

     RestoreFormToOriginalSize;
     application.processmessages;
     RemoveablePanel.Visible := False;
     RestorePanel.Visible := True;
end;

procedure TBackupForm.actRestoreExecute(Sender: TObject);
var
  Drive, Backuplocation: Char;
  DriveLetter: String;
  Rowcount, i : integer;

  VolumeName: array[0..30] of Char;
  dummy: Cardinal;
begin
     Backingup := False;
     Restoring := True;
     PanelLabel.caption := 'Select Drive containing data to be restored';
     blbBackup.Visible := ivNever;
     actRestore.Visible := False;
     actUndo.Visible := False;
     Restorepanel.visible := False;
     Removeablepanel.Visible := true;
     RestoreFormToOriginalSize;
     Backupform.show;
     Rowcount := 0;
     DriveStringGrid.Cells[0,Rowcount] := 'Drive';
     DriveStringGrid.Cells[1,Rowcount] := 'Description';
     DriveStringGrid.Cells[2,Rowcount] := 'Drive Name';
     Rowcount := 1;
     for Drive := 'A' to 'Z' do begin
                DriveLetter := Drive + ':\';

                case GetDriveType(PChar(DriveLetter)) of

                DRIVE_REMOVABLE: begin
                if ((Drive <> 'A') and (Drive <> 'B')) then begin
                                        DriveStringGrid.Cells[0,Rowcount] :=  DriveLetter;
                                        DriveStringGrid.Cells[1,Rowcount] := 'Removeable Drive';
                                        GetVolumeInformation( pchar(DriveLetter), volumename, sizeof(volumename), nil, dummy, dummy, nil, 0 );
                                           try DriveStringGrid.Cells[2,Rowcount] := strpas(volumename);
                                           except;
                                           end;
                                        Inc(Rowcount);
                                        DriveStringGrid.RowCount := DriveStringGrid.RowCount + 1;
                                     end
                        else begin
                                DriveStringGrid.Cells[0,Rowcount] :=  DriveLetter;
                                DriveStringGrid.Cells[1,Rowcount] := 'Floppy Drive';
                                GetVolumeInformation( pchar(DriveLetter), volumename, sizeof(volumename), nil, dummy, dummy, nil, 0 );
                                   try DriveStringGrid.Cells[2,Rowcount] := strpas(volumename);
                                   except;
                                   end;
                                DriveStringGrid.RowCount := DriveStringGrid.RowCount + 1;
                                Inc(Rowcount);
                        end;
                end;
                DRIVE_FIXED: begin
                DriveStringGrid.Cells[0,Rowcount] :=  DriveLetter;
                DriveStringGrid.Cells[1,Rowcount] := 'Hard Drive (Not Recommended)';
                GetVolumeInformation( pchar(DriveLetter), volumename, sizeof(volumename), nil, dummy, dummy, nil, 0 );
                     try DriveStringGrid.Cells[2,Rowcount] := strpas(volumename);
                     except;
                     end;
                     DriveStringGrid.RowCount := DriveStringGrid.RowCount + 1;
                     Inc(Rowcount);
                end;
                DRIVE_REMOTE: begin
                DriveStringGrid.Cells[0,Rowcount] :=  DriveLetter;
                DriveStringGrid.Cells[1,Rowcount] := 'Network Drive';
                GetVolumeInformation( pchar(DriveLetter), volumename, sizeof(volumename), nil, dummy, dummy, nil, 0 );
                     try DriveStringGrid.Cells[2,Rowcount] := strpas(volumename);
                     except;
                     end;
                     DriveStringGrid.RowCount := DriveStringGrid.RowCount + 1;
                     Inc(Rowcount);
                end;
                DRIVE_CDROM: begin
                end;
                DRIVE_RAMDISK: begin
                end;
                DRIVE_NO_ROOT_DIR: begin
                end;
                DRIVE_UNKNOWN: begin
                DriveStringGrid.Cells[0,Rowcount] :=  DriveLetter;
                DriveStringGrid.Cells[1,Rowcount] := 'Unknown Drive - No Recommended';
                DriveStringGrid.RowCount := DriveStringGrid.RowCount + 1;
                Inc(Rowcount);
                end;
                end;  // case
     end;
end;

procedure TBackupForm.actBackupToCDExecute(Sender: TObject);
begin
  inherited;
  BackupToCD;
end;

procedure TBackupForm.FormCreate(Sender: TObject);
var
   APanel: TdxStatusBarPanel;
   APanelStyle: TdxStatusBarContainerPanelStyle;
begin
   inherited;
   APanel := StatusBar.Panels[1];
   APanel.PanelStyleClass := TdxStatusBarContainerPanelStyle;
   APanelStyle := TdxStatusBarContainerPanelStyle(APanel.PanelStyle);
   APanelStyle.AlignControl := True;

   FProgressBar := TcxProgressBar.Create(nil);
   FProgressBar.Properties.Max := 100;
   FProgressBar.Parent := APanelStyle.Container;
   FProgressBar.Style.LookAndFeel.NativeStyle := True;
   FProgressBar.Visible := False;

   FFormOriginalHeight := Height;
   FFormOriginalWidth  := Width;
end;

procedure TBackupForm.RestoreFormToOriginalSize;
begin
   ResizeForm(FFormOriginalHeight, FFormOriginalWidth);
end;

procedure TBackupForm.ResizeForm(AHeight, AWidth: Integer);
begin
   Height := AHeight;
   Width  := AWidth;
end;

function TBackupForm.GetBackupFileName(const AOriginalFileName : string) : string;
begin
   Result := Format('%s%s%s',[ AOriginalFileName, FormatDateTime('_dd_mm_yy_hh.nn', Now()),'.zip']);
end;

end.
