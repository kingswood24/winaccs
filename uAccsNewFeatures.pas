{
   19/11/18 [V4.3 R2.8] /MK Bug Fix - Defaults for left and right button were off - should be left is defaulted off and right is on. 
}

unit uAccsNewFeatures;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxPC, cxControls, StdCtrls, cxButtons, ExtCtrls, cxContainer, cxEdit,
  cxCheckBox, cxLabel, cxImage, KRoutines, GenTypesConst, uPreferences,
  uPreferenceConsts;

type
  TFeatureType = (ftAll, ftBankLink, ftCoOpLink, ftAccountantLink);
  TfmAccsNewFeatures = class(TForm)
    pcNewFeatures: TcxPageControl;
    tsBankLink: TcxTabSheet;
    tsCoOpLink: TcxTabSheet;
    pBankLinkHead: TPanel;
    pCoOpLinkHead: TPanel;
    pBottomBar: TPanel;
    cbHideScreen: TcxCheckBox;
    lShowAppInformation: TcxLabel;
    btnLeft: TcxButton;
    btnRight: TcxButton;
    lBankLinkInfo: TcxLabel;
    lCoOpLinkInfo: TcxLabel;
    imgCoOpLink: TcxImage;
    pBankLinkImg: TPanel;
    imgBankLink: TcxImage;
    tsAccountantLink: TcxTabSheet;
    pAccountantLink: TPanel;
    imgAccountantLink: TcxImage;
    lAccountLinkInfo: TcxLabel;
    procedure btnLeftClick(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure cbHideScreenPropertiesChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure pcNewFeaturesPageChanging(Sender: TObject;
      NewPage: TcxTabSheet; var AllowChange: Boolean);
  private
    FFromStartup : Boolean;
    FCountry : TCountry;
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowTheForm (const AFromStartup : Boolean = True);
  end;

var
  fmAccsNewFeatures: TfmAccsNewFeatures;

implementation

{$R *.DFM}

{ TfmAccsNewFeatures }

class procedure TfmAccsNewFeatures.ShowTheForm (const AFromStartup : Boolean = True);
begin
   with TfmAccsNewFeatures.Create(nil) do
      try
         FFromStartup := AFromStartup;
         ShowModal;
      finally
         Free;
      end;
end;

procedure TfmAccsNewFeatures.btnLeftClick(Sender: TObject);
begin
   pcNewFeatures.ActivePageIndex := pcNewFeatures.ActivePageIndex - 1;
end;

procedure TfmAccsNewFeatures.btnRightClick(Sender: TObject);
begin
   pcNewFeatures.ActivePageIndex := pcNewFeatures.ActivePageIndex + 1;
end;

procedure TfmAccsNewFeatures.cbHideScreenPropertiesChange(Sender: TObject);
begin
   if Preferences <> nil then
      try
         if ( pcNewFeatures.ActivePageIndex = tsBankLink.PageIndex ) then
            Preferences.ValueAsBoolean[cPref_ShowBankLinkFeatures] := False
         else if ( pcNewFeatures.ActivePageIndex = tsCoOpLink.PageIndex ) then
            Preferences.ValueAsBoolean[cPref_ShowCoOpLinkFeatures] := False
         else if ( pcNewFeatures.ActivePageIndex = tsAccountantLink.PageIndex ) then
            Preferences.ValueAsBoolean[cPref_ShowAccountantLinkFeatures] := False;
      finally
      end;
   if ( cbHideScreen.Checked ) then Close;
end;

procedure TfmAccsNewFeatures.FormActivate(Sender: TObject);
var
   i : Integer;
begin
   if Preferences <> nil then
      try
         cbHideScreen.Visible := FFromStartup;
         try
            try
               tsBankLink.TabVisible := Preferences.ValueAsBoolean[cPref_ShowBankLinkFeatures];
               tsCoOpLink.TabVisible := Preferences.ValueAsBoolean[cPref_ShowCoOpLinkFeatures];
               tsAccountantLink.TabVisible := Preferences.ValueAsBoolean[cPref_ShowAccountantLinkFeatures];
               if ( not(tsBankLink.TabVisible) ) and ( tsCoOpLink.TabVisible ) and ( tsAccountantLink.TabVisible ) then
                  begin
                     tsCoOpLink.PageIndex := 0;
                     tsAccountantLink.PageIndex := 1;
                     tsBankLink.PageIndex := 2;
                  end
               else if ( tsBankLink.TabVisible ) and ( not(tsCoOpLink.TabVisible) ) and ( tsAccountantLink.TabVisible ) then
                  begin
                     tsBankLink.PageIndex := 0;
                     tsAccountantLink.PageIndex := 1;
                     tsCoOpLink.PageIndex := 2;
                  end;

               for i := 0 to pcNewFeatures.PageCount do
                  if ( pcNewFeatures.Pages[i].TabVisible ) then
                     begin
                        pcNewFeatures.ActivePageIndex := i;
                        Break;
                     end;

               btnLeft.Visible := ( pcNewFeatures.TabCount > 1 ) and ( pcNewFeatures.ActivePageIndex > 0 ) ;
               btnRight.Visible := ( pcNewFeatures.TabCount > 1 );

               OnActivate := nil;
            except
               on e : Exception do
                  ShowMessage(e.Message);
            end;
         finally
         end;
      finally
      end;
end;

procedure TfmAccsNewFeatures.pcNewFeaturesPageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
   if ( NewPage = nil ) then Exit;
   btnLeft.Visible := ( pcNewFeatures.TabCount > 1 ) and ( NewPage.PageIndex > 0 ) and ( pcNewFeatures.Pages[NewPage.PageIndex-1].TabVisible );
   btnRight.Visible := ( pcNewFeatures.TabCount > 1 ) and ( NewPage.PageIndex >= 0 ) and ( NewPage.PageIndex < pcNewFeatures.TabCount-1 ) and ( pcNewFeatures.Pages[NewPage.PageIndex+1].TabVisible );
end;

end.
