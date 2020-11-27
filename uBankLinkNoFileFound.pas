{
   29/09/20 [V4.5 R3.9] /MK Change - Give the user the ability to jump to either Desktop or Downloads.
                                   - Changed the Cancel button to Exit - GL request.

   26/11/20 [V4.5 R4.6] /MK Change - Added a "Don't show this again" option - Milo Murphy/Kieran Ryan.
}

unit uBankLinkNoFileFound;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, cxButtons, ExtCtrls, cxControls, cxContainer, cxEdit, cxLabel,
  AccsData, uBankFileSelectorSettings, AccsUtils, cxCheckBox, uPreferences,
  uPreferenceConsts;

type
  TfmBankLinkNoFileFound = class(TForm)
    pBankLinkInfo: TPanel;
    btnExit: TcxButton;
    lBankLinkInfo: TcxLabel;
    lBankLinkDefaultDirectory: TcxLabel;
    lDesktopDirLink: TcxLabel;
    lDownloadsDirLink: TcxLabel;
    cbHideScreen: TcxCheckBox;
    procedure lDesktopDirLinkClick(Sender: TObject);
    procedure lDownloadsDirLinkClick(Sender: TObject);
    procedure cbHideScreenClick(Sender: TObject);
  private
    { Private declarations }
    FShowBankFileSelectorSettings : Boolean;
  public
    { Public declarations }
    class procedure ShowTheForm (var AShowBankFileSelectorSettings : Boolean); 
  end;

var
  fmBankLinkNoFileFound: TfmBankLinkNoFileFound;

implementation

{$R *.DFM}

{ TfmBankLinkNoFileFound }

class procedure TfmBankLinkNoFileFound.ShowTheForm(var AShowBankFileSelectorSettings : Boolean);
begin
   with TfmBankLinkNoFileFound.Create(nil) do
      try
         lBankLinkDefaultDirectory.Caption := '"'+AccsDataModule.DefaultStatementDirectory+'"';
         FShowBankFileSelectorSettings := False;
         ShowModal;
         AShowBankFileSelectorSettings := FShowBankFileSelectorSettings;
      finally
         Free;
      end;
end;

procedure TfmBankLinkNoFileFound.lDesktopDirLinkClick(Sender: TObject);
begin
   AccsDataModule.DefaultStatementDirectory := GetSpecialFolder(CSIDL_DESKTOP);
   FShowBankFileSelectorSettings := True;
   Close;
end;

procedure TfmBankLinkNoFileFound.lDownloadsDirLinkClick(Sender: TObject);
begin
   AccsDataModule.DefaultStatementDirectory := GetUserDownloadsDir;
   FShowBankFileSelectorSettings := True;
   Close;
end;

procedure TfmBankLinkNoFileFound.cbHideScreenClick(Sender: TObject);
begin
   if ( Preferences <> nil ) then
      try
         Preferences.ValueAsBoolean[cPref_ShowBankLinkFileNotFound] := False;
      finally
      end;
   if ( cbHideScreen.Checked ) then Close;
end;

end.
