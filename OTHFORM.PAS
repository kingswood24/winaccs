
// Ch018 - Modified OthForm to disable the year end check box & stop users being able to do a year end within archive data

unit Othform;
{ PROG             ACT
  JOURNAL           3        = VAT Paid
  JOURNAL           4        = VAT Received
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, ComCtrls, Mask;

type
  TOthersForm = class(TForm)
    Panel1: TPanel;
    Exitbtn: TBitBtn;
    Save: TBitBtn;
    VatPaidRadio: TRadioButton;
    VatReceivedRadio: TRadioButton;
    VatPanel: TPanel;
    AmountLabel: TLabel;
    VatDescription: TEdit;
    DescriptionLabel: TLabel;
    VatAmount: TEdit;
    VatTxGroup: TGroupBox;
    WhichOption: TGroupBox;
    VatTxRadio: TRadioButton;
    VatCodesRadio: TRadioButton;
    BankAccountLabel: TLabel;
    VatMainPanel: TPanel;
    Label1: TLabel;
    BankAccount: TEdit;
    DateLabel: TLabel;
    ReferenceLabel: TLabel;
    Reference: TEdit;
    BankBalance: TEdit;
    BankBalanceLabel: TLabel;
    ListAccounts: TSpeedButton;
    BankNameLabel: TLabel;
    PeriodEndRadio: TRadioButton;
    YearEndRadio: TRadioButton;
    EntTransButton: TRadioButton;
    TxDate: TMaskEdit;
    DateSearch: TDateTimePicker;
    Help: TBitBtn;
    PromptLine: TStatusBar;
    JournalRadioButton: TRadioButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure BankAccountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SaveClick(Sender: TObject);
    procedure ExitbtnClick(Sender: TObject);
    procedure BankAccountExit(Sender: TObject);
    procedure VatAmountExit(Sender: TObject);
    procedure VatPaidRadioClick(Sender: TObject);
    procedure VatTxRadioClick(Sender: TObject);
    procedure ListAccountsClick(Sender: TObject);
    procedure VatCodesRadioMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure YearEndRadioMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PeriodEndRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EntTransButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BankAccountEnter(Sender: TObject);
    procedure VatPaidRadioMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure VatReceivedRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure VatTxRadioMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TxDateExit(Sender: TObject);
    procedure DateSearchCloseUp(Sender: TObject);
    procedure DateSearchDropDown(Sender: TObject);
    procedure VatAmountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BankBalanceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HelpClick(Sender: TObject);
    procedure TxDateEnter(Sender: TObject);
    procedure JournalRadioButtonMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure RadioButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RadioButton2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    { Setup the screen as radio buttons are checked and unchecked }
    Procedure SetUpScreen(Prog, Act : Integer; SpecialCase : Char );
    procedure HideVAT;
    procedure ShowVAT;
  public
    { Public declarations }
    CellSize : Packed Array [0..2] Of Integer;
    SalesPurchDB,
    CurrTrans : Integer;
  end;

var
  OthersForm: TOthersForm;
  NegitiveValue : Boolean;
  LastCol,
  LastRow     : Integer;

implementation
Uses
    UMonth,
    UYearEnd,
    PYEnd,
    LangUnit,
    DbGen,
    Filed,
    Calcs,
    Util,
    Vars,
    types,
    Clears,
    DbCore,
    MainUnit,
    TxWrite,
    NewListing,
    Jour,
    BankRec,
    Vat,
    DefSecFl,
    BankAct, uDataBackup, AccsData, uKingswoodAccountantController;

Const
     BadDate     = 61;
     BadBankCode = 62;

Function CheckNom ( NomCode : ShortString; Col, Row : LongInt;
                    AccRange : TAccRange ) : Boolean; Forward;

{$R *.DFM}

Function MoveTxInfo ( Var Col, Row : LongInt ) : Boolean;
Var
   CorrectEntry : Boolean;
   TestStr   : ShortString;
   AccRange  : TAccRange;
Begin

     InitVals;

     MoveTxInfo := True;
     CorrectEntry := False;

     Case Act Of
          3,
          4  : Begin
                    InitRange ( AccRange );
                    AccRange[1] := Cash1.xBankMin;
                    AccRange[2] := Cash1.xBankMax;

                    If CheckNom ( OthersForm.BankAccount.Text, 0, 0, AccRange ) Then
                       CorrectEntry := True
                    Else
                       Col := BadBankCode;
                    If CorrectEntry Then
                       Begin
                          TestStr := OthersForm.BankAccount.Text;
                          SlimAll ( TestStr );
                          zbank[1] := StrToInt ( TestStr );
                          zUse[1,1] := True;
                          ZDesc[1,1] := OthersForm.VatDescription.Text;
                          StrLong ( OthersForm.VatAmount.Text, ZAmt[1,1] );
                       End;
               End;
     End;

     If CorrectEntry Then     { Check Date }
        Begin
             CorrectEntry := False;
             TestStr := OthersForm.TxDate.Text;
             SlimAll ( TestStr );
             If Length ( TestStr ) > 0 Then
                Begin
                   If NOT DateValid ( TestStr, TDateFormat ) Then
                      Col := BadDate  {OthersForm.Date.SetFocus}
                   Else
                       CorrectEntry := True;
                End
             Else
                 Col := BadDate;
        End;

     If CorrectEntry Then
        Begin
             zRef[1] := OthersForm.Reference.Text;
             zTxDate[1] := KDateToInt ( Othersform.TxDate.Text );
             CheckEnd;
        End;
     {
     Else
     }
     MoveTxInfo := CorrectEntry;

End;


Function CheckNom ( NomCode : ShortString; Col, Row : LongInt;
                    AccRange : TAccRange ) : Boolean;
Var
   NomAccount,
   LastNom   : Integer;
   NominalOK,
   ActiveRecord,
   UseRanges : Boolean;

Begin
     CheckNom := False;
     NominalOK := False;
     SlimAll ( NomCode );
     If Numeric ( NomCode ) Then
        Begin
             UseRanges := False;
             NomAccount := StrToInt ( NomCode );
             SetDb ( NlFile );
             LastNom := db1.dbrechigh;
             If AccRange[2] > 0 Then
                Begin
                     LastNom := AccRange[2];
                     UseRanges := True;
                End;
             If AccRange[4] > 0 Then
                Begin
                     LastNom := AccRange[4];
                     UseRanges := True;
                End;
             If ( NomAccount <= LastNom ) Then
                Begin
                     ReadRec ( NlFile, NomAccount );
                     dberr;
                     ActiveRecord := RecActive ( NlFile );
                End;

             NominalOK := (( ActiveRecord ) And ( NOT UseRanges )) Or
                         (( ActiveRecord ) And ( UseRanges ) And
                         (( NomAccount >= AccRange[1] ) And
                          ( NomAccount <= AccRange[2] )) Or
                         (( NomAccount >= AccRange[3] ) And
                          ( NomAccount <= AccRange[4] )));

        End;
     {
     Else
         If Length ( NomCode ) = 0 Then
            NominalOK := True;
     }
     CheckNom := NominalOK;
End;

procedure TOthersForm.FormActivate(Sender: TObject);
Var
   PCount : Integer;
begin
     PromptLine.Panels.Items[0].Text := 'Press F1 For Help';
     Caption := 'Year End/VAT';{ + ' - ' + st;}
     SalesPurchDb := 0;
     CurrTrans    := 0;
 //    FMainScreen.Hide;
     BankAccount.Text := IntToStr ( Cash1.xLastBank );
//     if ((not cash11.Xuse_vat) or (not cash1.Xcashbook)) then PeriodEndRadio.Visible := true
//        else PeriodEndRadio.Visible := false;

{     Mask.DefaultBlank := ' ';
     Mask.MaskNoSave := '0';   }
     LastCol := -1;
     LastRow := -1;

     For PCount := 1 To MaxTx Do
         New ( TxHold[PCount] );
     For PCount := 1 To MaxNom Do
         New ( NomHold[PCount] );
     { Initialise the Pointer Variable }
     For PCount := 1 To MaxTx Do
         FillChar ( TxHold[PCount]^, SizeOf(TxHold[PCount]^),chr(0));
     For PCount := 1 To MaxNom Do
         FillChar ( NomHold[PCount]^, SizeOf(NomHold[PCount]^),chr(0));

     OpenLang;
     OthersForm.Exitbtn.Caption := ReadLang ( 1, CurrLang );
     OthersForm.Save.Caption := ReadLang ( 26, CurrLang );
     OthersForm.BankAccount.Hint := ReadLang ( 140, CurrLang );
     OthersForm.ListAccounts.Hint := ReadLang ( 141, CurrLang );

     {
     BankAccount.Text := IntToStr ( xLastBank );
     Date.Text := Default_Date;
     VatTxRadio.Checked := True;
     }
end;

procedure TOthersForm.FormDeactivate(Sender: TObject);
Var
   PCount : Integer;
begin
     With TxEditRec Do
        Begin
             TransF := 0;
             TransT := 0;
             TransType := '  ';
             NoRecs    := 0;
        End;
     GEditing := False;
     For PCount := 1 To MaxTx Do
         Dispose ( TxHold[PCount] );
     For PCount := 1 To MaxNom Do
         Dispose ( NomHold[PCount] );
  //   FMainScreen.Visible := True;
end;

procedure TOthersForm.BankAccountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
         NewListBox.ListIt ( Sender, Banks, 'N' );
         If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            BankAccount.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

Procedure TOthersForm.SaveClick(Sender: TObject);
Var
   BadCol,
   BadRow : LongInt;
   ErrText : ShortString;
begin
   if cash1.xyearend = true then begin
        if messagedlg('You are making changes to an archive set of accounts, are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrno then exit;
     end;

   try if StrToInt(BankAccount.text) > 0 then begin
       zbank[1] := StrToInt(BankAccount.text);
       Cash1.XLASTBANK := StrToInt(BankAccount.text);
       end;
   except
   end;

   BadCol := -1;
   BadRow := -1;
   If MoveTxInfo ( BadCol, BadRow  ) Then
      Begin
         If MessageDlg(ReadLang ( 142, CurrLang ),mtInformation, [mbYes, mbNo], 0) = mrYes then
            Begin
              WriteTransactions ( 1, PLFile,0, FALSE );
              Cash11.Default_Date := TxDate.Text;
              DefWrite ( 11 );
              VATAmount.Text := '';
              VATDescription.Text := '';
              Reference.Text := '';
            End;
      End
   Else
       Begin
            Case BadCol Of
                 BadDate     : ErrText := 'Date';
                 BadBankCode : ErrText := 'Bank Account';
                 Else
                     ErrText := 'UnKnown Field';
            End;
            MessageDlg('Missing ' + ErrText, mtInformation,[mbOK], 0);
            Case BadCol Of
//                 BadDate     : Date.SetFocus;
                 BadDate     : TxDate.SetFocus;
                 BadBankCode : BankAccount.SetFocus;
            End;
       End;
End;

procedure TOthersForm.ExitbtnClick(Sender: TObject);
begin
{     If MessageDlg('Exit Without Saving', mtInformation,[mbOK], 0) = mrOK Then}
     Close;
end;

procedure TOthersForm.BankAccountExit(Sender: TObject);
Var
   TestStr  : ShortString;
   AccRange : TAccRange;

   Procedure GetBankInfo;
   Begin
        SetDb ( NlFile );
        ReadRec ( NlFile, StrToInt ( TestStr ));
        dberr;
        If RecActive ( NlFile ) Then
           Begin
              GetItem ( NlFile, 1 );
              BankNameLabel.Caption := CurrStr;
              If Cash1.xShowBank Then
                 Begin
                    GetItem ( NlFile, 2 );
                    LongStr ( CurrLong, CurrStr, 'L' );
                    BankBalance.Text := CurrStr;
                 End;
           End;
   End;

begin
     InitRange ( AccRange );
     AccRange[1] := Cash1.xBankMin;
     AccRange[2] := Cash1.xBankMax;
     TestStr := BankAccount.Text;
     SlimAll ( TestStr );
     If ( NOT CheckNom ( BankAccount.Text, 0, 0, AccRange )) Or
        ( Length ( TestStr ) = 0 ) or (CheckNomEqualsZero(TestStr))  Then                     // TGM AB 24/04/15
        BankAccount.SetFocus      // TGM AB 20/03/15
     Else
         GetBankInfo;
     PromptLine.Panels.Items[1].Text := '';         
end;

procedure TOthersForm.VatAmountExit(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := VatAmount.Text;
     SlimAll ( TempStr );
     If Length ( TempStr ) > 0 Then
        If NOT ChangeToLong ( TempStr ) Then
           VatAmount.SetFocus
        Else
            VatAmount.Text := TempStr;
end;

procedure TOthersForm.VatPaidRadioClick(Sender: TObject);
begin
     Prog := Journal;
     Act  := 3;
     SetUpScreen ( Prog, Act, ' ' );
     Save.enabled := True;
     BankAccount.SetFocus;
end;

procedure TOthersForm.VatTxRadioClick(Sender: TObject);
begin
     {
     If ( NOT VatReceivedRadio.Checked ) And ( NOT VatPaidRadio.Checked ) Then
        VatPaidRadio.Checked := True
     Else
         If VatReceivedRadio.Checked Then
            VatReceivedRadioClick ( Sender )
         Else
            VatPaidRadioClick ( Sender );
     }
end;

Procedure TOthersForm.SetUpScreen(Prog, Act : Integer; SpecialCase : Char );
begin
    { SpecialCase Options

     }
     { Initialise all relevant variables }
     VatAmount.Text := '';
     VatDescription.Text := '';
     Reference.Text := '';
     {BankAccount.Text := '';}

     If ( Act In [3,4] ) And ( PROG = Journal ) Then
        Case ACT Of
          3,
          4 : Begin
                   VatTxGroup.Show;
                   If PROG = Journal Then
                     Begin
                          VatTxGroup.Visible := True;
                          If Act = 3 Then
                             Caption := ReadLang ( 123, CurrLang ){+ ' - ' + st}
                          Else
                              Caption := ReadLang ( 124, CurrLang );{+ ' - ' + st;}

                          BankBalance.Visible := True;
                          BankBalanceLabel.Visible := True;
                          BankAccount.Visible := True;
                          BankAccountLabel.Visible := True;
                          BankNameLabel.Visible := True;
                          ListAccounts.Show;

                          Height := VatPanel.Top + VatPanel.Height + 75;   // was 50
                     End;
              End;
        End     { EndCase }
     Else
         Begin
              MessageDlg('Invalid Option Selection - Contact Kingswood' , mtInformation,[mbOK], 0);
              Close;
         End;

End;

procedure TOthersForm.ListAccountsClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Banks, 'N' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        BankAccount.Text := NewListBox.ListInfo.ReturnValue;
     BankAccountExit ( Sender );
end;

procedure TOthersForm.VatCodesRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     Save.enabled := False;
     FVat.ShowModal;
end;

procedure TOthersForm.HideVAT;
begin
     If Cash11.xUse_Vat Then
        VatTxRadio.Hide;
     VatTxGroup.Hide;
     VatPanel.Hide;
     VatMainPanel.Hide;
end;

procedure TOthersForm.ShowVAT;
begin
     If Cash11.xUse_Vat Then
        VatTxRadio.Show;
     VatTxGroup.Show;
     VatPanel.Show;
     VatMainPanel.Show;
     VatTxRadio.SetFocus;
end;

procedure TOthersForm.FormShow(Sender: TObject);
begin
     DateSearch.Date := KStrToDate (Cash11.Default_Date);
     TxDate.Text := Cash11.Default_Date;{XDate;}     
     Act := 0;
     Prog := 0;
     Save.enabled := False;
     if Cash11.xUse_Vat then   { No Vat Options }
        HideVat
     else
        ShowVat;
     if Cash11.xuse_enterprise then   { No Enterprise in use }
        EntTransButton.Hide
     else
        EntTransButton.Show;

     // Ch018 start

     if cash1.xyearend = true then YearEndRadio.Enabled := false
        else  YearEndRadio.Enabled := True;

     // Ch018 end
end;

procedure TOthersForm.YearEndRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     HideVAT;
     Save.enabled := False;
     YearEndForm.ShowModal;
end;

procedure TOthersForm.PeriodEndRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     HideVAT;
     Save.enabled := False;
     MonthEndForm.ShowModal;
end;

procedure TOthersForm.EntTransButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     If Button = mbLeft Then
        Begin
           Save.enabled := False;
           HideVAT;
           Jour.Journals.WhichType := EntTrans;
           Jour.Journals.Caption := 'Enterprise Transfers';{+ ' - ' + st;}
           Jour.Journals.ShowModal;
        End;
end;

procedure TOthersForm.BankAccountEnter(Sender: TObject);
begin
     If BankAccount.Text = '' Then
        BankAccount.Text := IntToStr ( Cash1.xLastBank );
     PromptLine.Panels.Items[1].Text := 'Press F2 or Double Click to List Accounts';
end;

procedure TOthersForm.VatPaidRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     if Button = mbLeft Then
        begin
           VatPaidRadio.checked := True;
           Save.Enabled := True;
           Prog := Journal;
           Act  := 3;
           SetUpScreen ( Prog, Act, ' ' );
           BankAccount.SetFocus;
        end;
end;

procedure TOthersForm.VatReceivedRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     If Button = mbLeft Then
        Begin
           VatReceivedRadio.checked := True;
           Save.Enabled := True;
           Prog := Journal;
           Act  := 4;
           SetUpScreen ( Prog, Act, ' ' );
           BankAccount.SetFocus;
        End;
end;

procedure TOthersForm.VatTxRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     If button = mbLeft Then
        ShowVat;
end;

procedure TOthersForm.TxDateExit(Sender: TObject);
VAR TestDate : ShortString;
    DateBefore : Boolean;
begin
     If VATMainPanel.Visible Then
        Begin
             TestDate := TxDate.Text;
             If NOT DateValid ( TxDate.Text, TDateFormat ) Then
                TxDate.SetFocus
             Else If NOT CheckDateRange ( TestDate, True, DateBefore, true ) Then
                  Begin
                       TxDate.Text := TestDate;
                       TxDate.SetFocus;
                  End;
        End;
     PromptLine.Panels.Items[1].Text := '';                  
end;

procedure TOthersForm.DateSearchCloseUp(Sender: TObject);
begin
     TxDate.Text:= DateToStr(DateSearch.Date);
     TxDate.SetFocus;     
end;

procedure TOthersForm.DateSearchDropDown(Sender: TObject);
begin
    DateSearch.Date := KStrToDate (TxDate.Text );
end;

procedure TOthersForm.VatAmountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Cash2.XCOUNTRY = 2 Then
        If Key = VK_F5 then
           (Sender as TEdit).Text := EuroConvert( (Sender as TEdit).Text);
end;

procedure TOthersForm.BankBalanceKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Cash2.XCOUNTRY = 2 Then
        If Key = VK_F5 then
           (Sender as TEdit).Text := EuroConvert( (Sender as TEdit).Text);
end;

procedure TOthersForm.HelpClick(Sender: TObject);
begin
     //Application.HelpContext(69);
     AccsDataModule.HTMLHelp('otherActivities.htm');
end;

procedure TOthersForm.TxDateEnter(Sender: TObject);
begin
     PromptLine.Panels.Items[1].Text := 'Press The Down Arrow To Use The Calendar';
end;

procedure TOthersForm.JournalRadioButtonMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     If Button = mbLeft Then
        Begin
        HideVAT;
        Save.enabled := False;
        Application.CreateForm(TBankActivities, BankActivities );
        BankActivities.JournalType := True;
        BankAct.BankActivities.showmodal;
        OthersForm.FormActivate(self);
 //       VatTxRadio.checked := True;
        end;
end;

procedure TOthersForm.RadioButton1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if not (KAC.Active) then
      TfmDataBackup.Execute(daSendToAccountant)
   else
      MessageDlg('This feature is unavailable.',mtWarning,[mbOK],0);
end;

procedure TOthersForm.RadioButton2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   if not (KAC.Active) then
      TfmDataBackup.Execute(daReceiveFromAccountant)
   else
      MessageDlg('This feature is unavailable.',mtWarning,[mbOK],0);
end;

end.
