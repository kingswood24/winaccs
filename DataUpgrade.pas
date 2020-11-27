unit DataUpgrade;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  jpeg, ExtCtrls, StdCtrls, Buttons, DynaLibU, DynaZip, DynaLibZ, ComCtrls;

type
  TDataUpgradeForm = class(TForm)
    Image2: TImage;
    Panel1: TPanel;
    ExitButton: TBitBtn;
    RunButton: TBitBtn;
    Label1: TLabel;
    ZipFile1: TZipFile;
    UnzipFile1: TUnzipFile;
    Bevel1: TBevel;
    ProgressLabel: TLabel;
    ProgressBar1: TProgressBar;
    procedure ExitButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function Backupdata: boolean;
    procedure RunButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataUpgradeForm: TDataUpgradeForm;

implementation

uses
  MainUnit, Accsdata, vars,types,params,dbgen,filed,init,abortprg,Dataconvert;

{$R *.DFM}

procedure TDataUpgradeForm.ExitButtonClick(Sender: TObject);
begin
     if (MessageDlg('Are you sure you wish to cancel as this data cannot be accessed until it has been converted?',mtInformation, [mbYes, mbNo], 0) = mrYes) then self.Close;
end;

procedure TDataUpgradeForm.FormShow(Sender: TObject);
begin
      Runbutton.SetFocus;
end;

function TDataUpgradeForm.Backupdata : boolean;
var Filename :string;
    DirString : string;
    progpath : string;

begin
     result := true;
     ProgressBar1.position := 10;
     ProgressLabel.Caption := 'Stage 1 - Backing up files, please wait..';
     Application.ProcessMessages;
     DirString := RFarmGate.PLocation[2];
     progpath := ExtractFilePath( ParamStr(0));

     accsdatamodule.closeallfiles;
     { Close all DATABASE files }
     CloseAll(MaxDatabases);
     { Close Cashbook.def file }
     cClose (CashFile, 'N');
     { Close Farmgate.def file }
     cClose ( FarmFile, 'N');

     // create archived backup
     ProgressBar1.position := 20;
     filename := progpath + 'import\' + DirString +'.zip';
     ZipFile1.lpszZipFile.SetText(PChar(Filename));
     ZipFile1.lpszItemList.SetText(PChar(ProgPath + DirString + '\*.*'));
     ZipFile1.Execute(ZIP_ADD);
     ProgressBar1.position := 40;
     ProgressLabel.Caption := 'Stage 1 - Copying to floppy disk';
     Application.ProcessMessages;


     filename := 'a:\' + DirString;
     if fileexists(filename +'.zip') then deletefile (filename +'.zip');
     ZipFile1.lpszZipFile.SetText(PChar(Filename));
     ZipFile1.lpszItemList.SetText(PChar(ProgPath + DirString + '\*.*'));
     if not ZipFile1.Execute(ZIP_ADD) then begin
        messageDlg('Your Backup Failed.  Please try again with a new floppy disk!', mtInformation, [mbOK],0);
        result := false;
        exit;
     end;
     ProgressBar1.position := 60;
     UnZipFile1.lpszZipFile.SetText(PChar('a:\'+ DirString +'.zip'));
     UnZipFile1.lpszFileSpec.SetText('*.*');
     UnZipFile1.Options:=[TestFlag];
     ProgressLabel.Caption := 'Stage 1 - Testing Integrity of backup on Floppy Disk';
     Application.ProcessMessages;
     ProgressBar1.position := 80;
     if not UnZipFile1.Execute(UNZIP_EXTRACT) then begin
          showmessage('Warning, Backup failed integrity test! Please backup again with a new disk');
          result := false;
          exit;
     end;
     ProgressBar1.position := 100;

     Screen.Cursor := crDefault;

     { reopen the FARMGATE.DEF and CASHBOOK.DEF }
     Initialise;
     { ReOpen all other Files }
     If Not OpenAll Then begin
          AbortProgram ('Error Opening Database Files - Contact Kingswood');
          result := false;
          exit;
     end;

end;

procedure TDataUpgradeForm.RunButtonClick(Sender: TObject);
begin
     progresslabel.visible := true;
     progressbar1.visible := true;
     if backupdata then begin
        CloseAll ( MaxDatabases );
        AccsDataModule.NLFileDB.close;
        OpenFile ( ImportFile, Cash2.xnlaccfile );
        Dataconvert.ProcessNLFile(self);

  //   OpenFile ( EntFile, Cash2.xentfile );
  //   OpenFile ( TxFile, Cash2.xtransfile );
     //       OpenFile ( SlFile, Cash2.xslaccfile );
     //       OpenFile ( PlFile, Cash2.xplaccfile );
  {   If Cash11.xAnl_File = '' Then
        Cash11.xAnl_File := 'anl_file';
     OpenFile ( AnalFile, Cash11.xAnl_File ); }

     end;
     showmessage('Data Conversion Completed Successfully.');
     progresslabel.visible := false;
     progressbar1.visible := false;
     self.close;
end;

end.
