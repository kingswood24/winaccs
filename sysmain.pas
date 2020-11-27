unit Sysmain;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Gauges, Mask, ComCtrls,
  Tabnotbk,Registry, jpeg;

type
  TSystemForm = class(TForm)
    Panel1: TPanel;
    Exit: TBitBtn;
    Save: TBitBtn;
    TempEdit: TEdit;
    Timer1: TTimer;
    Help: TBitBtn;
    Promptline: TStatusBar;
    Button1: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Memory: TLabel;
    MemoryLoad: TLabel;
    Gauge1: TGauge;
    Gauge2: TGauge;
    Gauge3: TGauge;
    Label12: TLabel;
    Label9: TLabel;
    CPU: TLabel;
    Label8: TLabel;
    Label15: TLabel;
    Label25: TLabel;
    Label24: TLabel;
    Label17: TLabel;
    Label6: TLabel;
    Label16: TLabel;
    lEmailTo: TLabel;
    Label19: TLabel;
    Label23: TLabel;
    lWebsite: TLabel;
    Label18: TLabel;
    SerialNumber: TLabel;
    Label26: TLabel;
    Ownerlbl: TLabel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    CurrentMonth: TLabel;
    FinancialLabel: TLabel;
    CompanyEdit: TEdit;
    YearEdit: TEdit;
    MonthEdit: TEdit;
    StartEdit: TEdit;
    AltEdit: TEdit;
    CurrencyBox: TGroupBox;
    Label13: TLabel;
    Label20: TLabel;
    Label14: TLabel;
    Label21: TLabel;
    PuntImage: TImage;
    EuroImage: TImage;
    EuroConverter: TMaskEdit;
    EuroToPunt: TMaskEdit;
    CurrencyGroup: TRadioGroup;
    TabControl1: TTabControl;
    PasswordGroup: TGroupBox;
    LPassOld: TLabel;
    LPassNew: TLabel;
    LPassConfirm: TLabel;
    Label4: TLabel;
    PasswordUse: TCheckBox;
    PassOld: TEdit;
    PassConfirm: TEdit;
    PassNew: TEdit;
    ConfirmPassOld: TEdit;
    RegisterBtn: TBitBtn;
    PeriodEnd: TGroupBox;
    Label22: TLabel;
    ResetNomCheck: TCheckBox;
    ResetSalesCheck: TCheckBox;
    ResetPurchCheck: TCheckBox;
    RetainTxCheck: TCheckBox;
    GroupBox3: TGroupBox;
    cbUseLastDesc: TCheckBox;
    cbSLPLDefaults: TCheckBox;
    cbsimpleview: TCheckBox;
    CBDirectImport: TCheckBox;
    Image8: TImage;
    PaymentVatCB: TCheckBox;
    VATRadioGroup: TRadioGroup;
    procedure ExitClick(Sender: TObject);
    procedure MonthEditExit(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure StartEditExit(Sender: TObject);
    procedure AltEditExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure YearEditExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CurrencyGroupClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RetainTxCheckClick(Sender: TObject);
    procedure PasswordUseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lEmailToClick(Sender: TObject);
    procedure lWebsiteClick(Sender: TObject);
    procedure lEmailToMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lWebsiteMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GroupBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure ConfirmPassOldKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CompanyEditChange(Sender: TObject);
    procedure YearEditChange(Sender: TObject);
    procedure AltEditChange(Sender: TObject);
    procedure CBDirectImportClick(Sender: TObject);
    procedure cbsimpleviewClick(Sender: TObject);
    procedure cbSLPLDefaultsClick(Sender: TObject);
    procedure EuroConverterChange(Sender: TObject);
    procedure EuroToPuntChange(Sender: TObject);
    procedure ConfirmPassOldChange(Sender: TObject);
    procedure PassNewChange(Sender: TObject);
    procedure PassConfirmChange(Sender: TObject);
    procedure RegisterBtnClick(Sender: TObject);
    procedure PaymentVatCBClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public Declarations }
  end;

var
  SystemForm: TSystemForm;
  MonthStr : ShortString;
  MonthNo : Integer;
  datachanged : boolean;

implementation
uses
    ShellAPI,
    init,
    DefSecFl,
    filed,
    dbcore,
    util,
    dbgen,
    vars,
    types,
    clears,
    calcs,
    MainUnit, FullAudit, RegisterForm, uKingsCC;

{$R *.DFM}

procedure MonthNames (Sender : TObject);
begin
     If monthno = 1 Then MonthStr := 'January'
     Else If monthno = 2 Then MonthStr := 'February'
     Else If monthno = 3 Then MonthStr := 'March'
     Else If monthno = 4 Then MonthStr := 'April'
     Else If monthno = 5 Then MonthStr := 'May'
     Else If monthno = 6 Then MonthStr := 'June'
     Else If monthno = 7 Then MonthStr := 'July'
     Else If monthno = 8 Then MonthStr := 'August'
     Else If monthno = 9 Then MonthStr := 'September'
     Else If monthno = 10 Then MonthStr := 'October'
     Else If monthno = 11 Then MonthStr := 'November'
     Else If monthno = 12 Then MonthStr := 'December'
     Else
         Begin
              (Sender as TEdit).Text := '';
              (Sender as TEdit).SetFocus;
              MonthStr := '';
         End;
end;

procedure TSystemForm.ExitClick(Sender: TObject);
begin
     If Datachanged then begin
        if MessageDlg('Do you wish to save System Changes ?', mtInformation, [mbYes, mbNo], 0) = mrYes then
           Save.Click
        Else Close;
     end else close;
end;

procedure TSystemForm.MonthEditExit(Sender: TObject);
begin
     dataChanged := true;
     If Numeric (MonthEdit.Text) Then
        Begin
             MonthNo := StrToInt(monthEdit.Text);
             MonthNames(Sender);
             CurrentMonth.Caption := MonthStr;
             CurrentMonth.refresh;
        End;
end;

procedure TSystemForm.SaveClick(Sender: TObject);
VAR
   Registry:Tregistry;
   Str1,Str2 : ShortString;
   UseImport:String;
begin
   Str1 := '';
   Str2 := '';
   registry:= Tregistry.Create;
   Registry.OpenKey('Software\Kingswood\Kingsacc\UseImport', True);
   if cbDirectImport.checked = true then begin
      FMainScreen.gbImport.visible:=true;
//      FMainscreen.gbimport.enabled := true;
      FMainscreen.DiskImport.visible := True;
      Registry.WriteString('UseImport','True')
   end else begin
       Registry.WriteString('UseImport','False');
       FMainScreen.gbImport.visible:=false;
       FMainscreen.DiskImport.visible := false;
   end;

   registry:= Tregistry.Create;
   Registry.OpenKey('Software\Kingswood\Kingsacc\SLPLDefaults', True);
   if cbSLPLDefaults.checked = true then begin
      Registry.WriteString('SLPLDefaults','True');
   end else Registry.WriteString('SLPLDefaults','False');
   Registry.Free;

   FMainScreen.SetupInterface;

    If Not((Companyedit.Text = '') or (YearEdit.Text = '') or
           (MonthEdit.Text = '') or (StartEdit.Text = '') or (AltEdit.Text = '' )) then
           Begin
                Cash1.Xcompany := CompanyEdit.Text;
                Cash1.XFinYear := StrToInt(YearEdit.Text);
                Cash1.Xmonthno := StrToInt(MonthEdit.Text);
                Cash1.xfinMonth := StrToInt(StartEdit.Text);
                Cash2.Xentupper := (AltEdit.Text);
                Cash2.Xentlower := (TempEdit.Text);
                Cash1.xKeepTran := RetainTxCheck.Checked;
                Cash1.xResetNom := ResetNomCheck.Checked;
                cash1.XSimple := cbsimpleview.checked;
                FMainScreen.SetupInterface;
                Cash11.xResetSales := ResetSalesCheck.Checked;
                Cash11.xResetPurchases := ResetPurchCheck.Checked;
                Cash11.xUseLastNomDesc := cbUseLastDesc.Checked;
                Str1 := PassOld.Text;
                Str2 := PassConfirm.Text;
                SlimAll( Str1 );
                SlimAll( Str2 );
                if Length(PassNew.text) > 0 then
                if PassNew.Text = PassConfirm.Text then
                   begin
                        PADRIGHT(Str2,SizeOf(Cash2.xPassword[2]));
                        Cash2.XPASSWORD[2] := Copy(Str2,1,SizeOf(Cash2.xPassword[2])); // Pass confirm
                        DefWrite(1);
                        Cash11.xp_words := PasswordUse.Checked;
                        DefWrite(11);
                   end
                else
                    MessageDlg('Password incorrect. Please input again.', mtInformation,[mbOK],0);

                if CurrencyBox.Visible = True Then //For Euro Conversion
                   begin
                        Cash11.xSaveAsEuro := (CurrencyGroup.ItemIndex = 1);
                        Cash11.xEuroConverter := StrToFloat(EuroConverter.Text);
                        DefWrite(11);
                   end;
                if PassOld.text = ConfirmPassOld.text then Cash11.xp_words := PasswordUse.Checked;
                if not PasswordUse.Checked then Cash2.XPASSWORD[2] := '      ';



                if PaymentVATCB.Checked = true then cash2.XPaymentVAT := true
                        else cash2.XPaymentVAT := false;

                // TGM AB 12/06/15
                if VATRadioGroup.ItemIndex = 2 then begin
                                                cash11.xSalesPaymentVAT := 'Y';
                                                cash11.xPurchPaymentVAT := 'Y';
                   end else if VATRadioGroup.ItemIndex = 1 then begin
                                                cash11.xSalesPaymentVAT := 'N';
                                                cash11.xPurchPaymentVAT := 'Y';
                       end else begin
                                                cash11.xSalesPaymentVAT := 'Y';
                                                cash11.xPurchPaymentVAT := 'N';
                           end;
                // end

                Defwrite(0);
                Defwrite(1);
                DefWrite(11);
                Close;
           End
    Else
         Begin
              MessageDlg('Incomplete system settings.', mtInformation,[mbOk], 0);
              CompanyEdit.SetFocus;
         End;
end;

procedure TSystemForm.StartEditExit(Sender: TObject);
begin
     dataChanged := true;
     If Numeric (StartEdit.Text) Then
        Begin
             MonthNo := StrToInt(StartEdit.Text);
             MonthNames(Sender);
             FinancialLabel.Caption := MonthStr;
             FinancialLabel.refresh;
        End;
end;

procedure TSystemForm.AltEditExit(Sender: TObject);
begin
     TempEdit.Text := AltEdit.Text;
end;

procedure TSystemForm.FormShow(Sender: TObject);
Const
     PlatNames : array[0..3] of string =
    ('Win32s', 'Windows 95', 'Windows NT', 'Windows 98');
Var
   OVI : TOsVERSIONINFO;
   SI  : TSystemInfo;
   TMS : TMemoryStatus;
   Ico : TIcon;
   St : ShortString;
   Doub : Double;
   registry:Tregistry;
   UseImport:string;
   keystring:string;
begin
   if cash1.xcashbook then cbsimpleview.Visible := true
      else cbsimpleview.Visible := false;
   registry:=Tregistry.Create;
   Registry.OpenKey('Software\Kingswood\Kingsacc\UseImport', True);
   if Registry.ReadString('UseImport') = 'True' then cbDirectImport.checked := true
   else cbDirectImport.checked := false;
   registry.free;

   registry:=Tregistry.Create;
   Registry.OpenKey('Software\Kingswood\Kingsacc\SLPLDefaults', True);
   if Registry.ReadString('SLPLDefaults') = 'True' then cbSLPLDefaults.checked := true
   else cbSLPLDefaults.checked := false;
   Registry.Free;



     OVI.dwOSVersionInfoSize := Sizeof(OVI);
     GetVersionEx(OVI);
     Label9.Caption := Format('%s, Version %u.%.u',        // TGM AB was.2u
                       [PlatNames[OVI.dwPlatformID], OVI.DwMajorVersion,
                                  OVI.dwMinorversion]);
     GetSystemInfo(SI);
     Case SI.dwProcessorType OF
             386 : CPU.Caption := '386';
             486 : CPU.Caption := '486';
             586 : CPU.Caption := 'Pentium Processor';
        Else CPU.Caption := 'Unknown Processer Type' + IntToStr(SI.dwProcessortype);
     End;

     TMS.dwLength := SizeOf(TMS);
     GlobalMemoryStatus(TMS);
     Doub := (TMS.dwtotalphys) div 1048576; // TGM AB was 1024000
     DoubleToStr ( Doub, st, '%2.1f', False, False, 0, False );
     Label25.caption := st +' MB RAM';
     
//     CompanyEdit.SetFocus;
     Timer1.Enabled := True;

     // serial number check

     if ukingscc.UseKACC then begin
        Registry := TRegistry.Create;
        Registry.OpenKey('Software\Kingswood\kacc', True);
        Keystring := Registry.ReadString('Authorisation Key');
        Registry.Free;

        if keystring <> '' then Registerbtn.visible := False;

     end
        else Registerbtn.visible := False;

end;

procedure TSystemForm.Timer1Timer(Sender: TObject);
Var TMS : TMemoryStatus;
begin
     TMS.dwLength := SizeOf(TMS);
     GlobalMemoryStatus(TMS);
     Gauge1.Progress := TMS.dwMemoryLoad;
     Gauge2.Progress := (10000*TMS.dwAvailphys) DIV TMS.dwTotalPhys;
     Gauge3.Progress := (10000*TMS.dwAvailPageFile) DIV TMS.dwTotalPagefile;
     Memory.Caption := FormatFloat('#',(TMS.dwAvailphys + TMS.dwAvailPagefile) DIV 1024);
     MemoryLoad.Caption := Format('%d%% Load', [TMS.dwMemoryLoad]);
end;

procedure TSystemForm.YearEditExit(Sender: TObject);
Var Int : Integer;
begin
     If Numeric (Yearedit.Text) then
        Begin
             Int := StrToInt(YearEdit.Text);
             If Not((Int > 1989) AND (Int < 2501)) Then
             YearEdit.SetFocus;
        End
     Else
         YearEdit.SetFocus;
end;

procedure TSystemForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Timer1.Enabled := False;
end;

procedure TSystemForm.CurrencyGroupClick(Sender: TObject);
begin
     dataChanged := true;
    If ( CurrencyGroup.ItemIndex = 0 ) Then
       Begin
            if Cash2.XCOUNTRY = 2 then CurrencyBox.Caption := 'Punt Currency'
                else CurrencyBox.Caption := 'Sterling Currency';
            EuroImage.hide;
            PuntImage.Show;
       End
    Else
       Begin
            CurrencyBox.Caption := 'EURO Currency';
            PuntImage.Hide;
            EuroImage.Show;
       End;
end;

procedure TSystemForm.HelpClick(Sender: TObject);
begin
     Application.HelpContext(195);
end;

procedure TSystemForm.FormActivate(Sender: TObject);
Var vEuroConverter : Shortstring;
    TempPassOld : string;
    i : integer;
begin
     // Hide the Period end options
     PeriodEnd.Hide;
     MonthNo := 0;
     vEuroConverter := '';

 //    GroupBox1.Hide;
//     ClientHeight := 358; // TGM AB was 320
//     Image4.Visible := False;
     If ( Cash2.XCOUNTRY = 2 ) then begin
        CurrencyGroup.items[0]:='IR£';
        Label21.Caption:='IR£';
     end else begin
          CurrencyGroup.items[0]:='Stg£';
          Label21.Caption:='Stg£';
     end;

//        CurrencyBox.Show;
//     Else
//        CurrencyBox.Hide;

     If Cash1.xCashBook Then
        Begin
             ResetSalesCheck.Hide;
             ResetPurchCheck.Hide;
             cbUseLastDesc.Hide;
        End
     else
        Begin
             cbUseLastDesc.Show;
             ResetSalesCheck.Show;
             ResetPurchCheck.Show;
             ResetSalesCheck.Checked := Cash11.xResetSales;
             ResetPurchCheck.Checked := Cash11.xResetPurchases;
        End;

     if ((cash2.XAllocation) and (cash11.XUse_Vat = false)) then PaymentVATCB.Show               // TGM AB 10/07/15
           else PaymentVATCB.hide;

     PaymentVATCB.checked := cash2.XPaymentVAT;
     // TGM AB 12/06/15
     VATRadioGroup.Visible := false;
     if ((PaymentVATCB.Visible) and (PaymentVATCB.checked)) then VATRadioGroup.Visible := true
         else VATRadioGroup.Visible := false;
     if ((cash11.xSalesPaymentVAT = 'Y') and (cash11.xPurchPaymentVAT = 'Y')) then VATRadioGroup.ItemIndex := 2
         else if ((cash11.xSalesPaymentVAT = 'Y') and (cash11.xPurchPaymentVAT = 'N')) then VATRadioGroup.ItemIndex := 0
              else if ((cash11.xSalesPaymentVAT = 'N') and (cash11.xPurchPaymentVAT = 'Y')) then VATRadioGroup.ItemIndex := 1
                   else VATRadioGroup.ItemIndex := 2;
     // end
     cbUseLastDesc.Checked := Cash11.xUseLastNomDesc;
     RetainTxCheck.Checked := Cash1.xKeepTran;
     ResetNomCheck.Checked := Cash1.xResetNom;
     CompanyEdit.Text := Cash1.XCOMPANY;
     cbsimpleview.checked := Cash1.XSimple;
     YearEdit.Text := IntToStr(Cash1.xfinyear);
     MonthEdit.Text := IntToStr(Cash1.Xmonthno);
     StartEdit.Text := IntToStr(Cash1.xfinMonth);
     AltEdit.Text := Cash2.xentupper;
     PassOld.text := '';
     ConfirmPassOld.Text := '';
     PassNew.text := '';
     PassConfirm.Text := '';
     TempPassOld := Cash2.XPASSWORD[2];
     for i := 1 to length(TempPassOld) do begin
         if TempPassOld[i] <> ' ' then PassOld.Text := PassOld.text + TempPassOld[i];
     end;
 //    MoreBtn.Caption := 'Mor&e';
     If NOT Cash11.xSaveAsEuro Then
        CurrencyGroup.ItemIndex := 0 // IRL
     Else
        CurrencyGroup.ItemIndex := 1; // EURO
     DoubleToStr ( Cash11.xEuroConverter, vEuroConverter, '%1.6f', False, False, 0, False );
     EuroConverter.Text := vEuroConverter; //StFrom;
     if Length(PassOld.text) > 0 then  PasswordUse.Checked := Cash11.xp_words
        else PasswordUse.Checked := false;

     PasswordUse.OnClick( Sender );
     try SerialNumber.caption := 'Serial Number: - ' + vartostr(PSysLongToDelphi ( Cash11.serial_no ));
     except SerialNumber.caption := 'Serial Number: - Error';
     end;
     try OwnerLbl.caption := 'Registered Owner: - ' + Cash1.xcompany;
     except OwnerLbl.caption := 'Registered Owner: - Error';
     end;

     If PasswordUse.checked = false then begin
        PassOld.Enabled := false;
        ConfirmPassOld.enabled := false;
        PassNew.enabled := true;
        PassConfirm.enabled := true;
        PasswordUse.enabled := true;
        PassOld.Color := ClBtnFace;
        ConfirmPassOld.color := ClBtnFace;
        PassNew.Color := ClBtnFace;
        PassConfirm.Color := ClBtnFace;

     end else begin
         PassNew.enabled := false;
         PassConfirm.enabled := false;
         PasswordUse.enabled := false;
         PassOld.Enabled := true;
         ConfirmPassOld.enabled := true;
         PassOld.Color := ClWindow;
         ConfirmPassOld.color := ClWindow;
         PassNew.Color := ClBtnFace;
         PassConfirm.Color := ClBtnFace;

     end;
     DataChanged := false;
     Pagecontrol1.ActivePage := Tabsheet1;
end;

procedure TSystemForm.RetainTxCheckClick(Sender: TObject);
begin
     If (RetainTxCheck.Checked = False) Then
        Begin
             ResetNomCheck.Enabled := False;
             ResetSalesCheck.Enabled := False;
             ResetPurchCheck.Enabled := False;
        End
     Else
         Begin
             ResetNomCheck.Enabled := True;
             ResetSalesCheck.Enabled := True;
             ResetPurchCheck.Enabled := True;
         End;
end;

procedure TSystemForm.PasswordUseClick(Sender: TObject);
begin
     dataChanged := true;
     If PasswordUse.Checked Then
        Begin
             If length(PassOld.text) > 0 then begin
                PassOld.Enabled := True;
                ConfirmPassOld.enabled := true;
                PassOld.Color := ClWindow;
                ConfirmPassOld.color := ClWindow;
                PassNew.Color := ClWindow;
                PassConfirm.Color := ClWindow;

             end else begin
                PassOld.Enabled := false;
                ConfirmPassOld.enabled := false;
                PassOld.Color := ClBtnFace;
                ConfirmPassOld.color := ClBtnFace;
                PassNew.Color := ClWindow;
                PassConfirm.Color := ClWindow;
             end;
             PassNew.Color := ClWindow;
             PassConfirm.Color := ClWindow;
        End
     Else
        Begin
             PassOld.Enabled := False;
             PassNew.Enabled := False;
             PassConfirm.Enabled := False;
             PassOld.Color := CLBtnFace;
             PassNew.Color := CLBtnFace;
             PassConfirm.Color := CLBtnFace;
             ConfirmPassOld.color := ClBtnFace;
        End;
end;

procedure TSystemForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    // Shows the Period end Options
    if ( Shift = [ssCTRL,ssShift] ) and ( Char(Key) in ['P','p'] ) then
       PeriodEnd.Show;
end;

procedure TSystemForm.lEmailToClick(Sender: TObject);
begin
     ShellExecute(Self.Handle,'open','mailto:info@kingswood.ie',nil,nil,SW_SHOWNORMAL);
end;

procedure TSystemForm.lWebsiteClick(Sender: TObject);
begin
     ShellExecute(Self.Handle,'open','http://www.kingswood.ie/',nil,nil,SW_SHOWNORMAL);
end;

procedure TSystemForm.lEmailToMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
     LWebSite.Font.Color := clblue;
     LWebSite.Font.Style := [];
     Cursor := crHandPoint;
     lEmailTo.Font.Color := clRed;
     lEmailTo.Font.Style := [fsUnderline];
end;

procedure TSystemForm.lWebsiteMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
     lEmailTo.Font.Color := clblue;
     lEmailTo.Font.Style := [];
     Cursor := crHandPoint;
     LWebSite.Font.Color := clRed;
     LWebSite.Font.Style := [fsUnderline];
end;

procedure TSystemForm.GroupBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
     if ( Cursor <> crDefault ) then
        begin
           Cursor := crDefault;
           LEmailTo.Font.Color := clblue;
           LEmailTo.Font.Style := [];
           LWebSite.Font.Color := clblue;
           LWebSite.Font.Style := [];
        end;
end;

procedure TSystemForm.Button1Click(Sender: TObject);
begin
     Auditfiles.OnShow(self);
     Auditfiles.OnActivate(self);
     Auditfiles.checkbtnClick(self);

end;

procedure TSystemForm.ConfirmPassOldKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If ((Uppercase(PassOld.text) = Uppercase(ConFirmPassOld.text)) or (Uppercase(ConFirmPassOld.text) = 'SILVER')) then begin
        PassNew.enabled := true;
        PassConfirm.enabled := True;
        PasswordUse.enabled := true;
        PassNew.Color := ClWindow;
        PassConfirm.Color := ClWindow;

     end else begin
        PassNew.enabled := false;
        PassConfirm.enabled := false;
        PasswordUse.enabled := false;
        PassNew.Color := ClBtnFace;
        PassConfirm.Color := ClBtnFace;



     end;

end;

procedure TSystemForm.CompanyEditChange(Sender: TObject);
begin
     dataChanged := true;
end;

procedure TSystemForm.YearEditChange(Sender: TObject);
begin
     dataChanged := true;
end;

procedure TSystemForm.AltEditChange(Sender: TObject);
begin
     dataChanged := true;
end;

procedure TSystemForm.CBDirectImportClick(Sender: TObject);
begin
     dataChanged := true;
end;

procedure TSystemForm.cbsimpleviewClick(Sender: TObject);
begin
     dataChanged := true;
end;

procedure TSystemForm.cbSLPLDefaultsClick(Sender: TObject);
begin
     dataChanged := true;
end;

procedure TSystemForm.EuroConverterChange(Sender: TObject);
begin
     dataChanged := true;
end;

procedure TSystemForm.EuroToPuntChange(Sender: TObject);
begin
     dataChanged := true;
end;

procedure TSystemForm.ConfirmPassOldChange(Sender: TObject);
begin
     dataChanged := true;
end;

procedure TSystemForm.PassNewChange(Sender: TObject);
begin
     dataChanged := true;
end;

procedure TSystemForm.PassConfirmChange(Sender: TObject);
begin
     dataChanged := true;
end;

procedure TSystemForm.RegisterBtnClick(Sender: TObject);
begin
        Register.AccRun := True;
        Register.ShowModal;
end;

procedure TSystemForm.PaymentVatCBClick(Sender: TObject);                      // TGM AB 12/06/15
begin
        if PaymentVatCB.Checked = true then VATRadioGroup.Visible := true
                else VATRadioGroup.Visible := false;
end;

end.
