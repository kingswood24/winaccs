unit Jour;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, ExtCtrls, StdCtrls, Buttons, Mask;

type
  TJournals = class(TForm)
    DispJournals: TStringGrid;
    SOrderPanel: TPanel;
    SOName: TEdit;
    SOReference: TEdit;
    SOBank: TEdit;
    SOIncExp: TEdit;
    SOAmount: TEdit;
    SODescription: TEdit;
    SOAnalysis: TEdit;
    SONameLabel: TLabel;
    SORefLabel: TLabel;
    SODescLabel: TLabel;
    SOBankLabel: TLabel;
    SOIncExpLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Exit: TBitBtn;
    Save: TBitBtn;
    RunButton: TBitBtn;
    BankNameLabel: TLabel;
    NominalNameLabel: TLabel;
    Panel2: TPanel;
    SOTypeLabel: TLabel;
    SOVATAmount: TEdit;
    Label3: TLabel;
    SODate: TEdit;
    Label5: TLabel;
    SOVATCode: TMaskEdit;
    Delete: TBitBtn;
    Add: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure DispJournalsDblClick(Sender: TObject);
    procedure DispJournalsClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure RunButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure SOBankClick(Sender: TObject);
    procedure SOBankKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SOIncExpKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SOAmountExit(Sender: TObject);
    procedure SOVATCodeChange(Sender: TObject);
    procedure SOVATCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SOIncExpExit(Sender: TObject);
    procedure SOVATCodeExit(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure SODateExit(Sender: TObject);
  private
    { Private declarations }
    Procedure FillTopOfScreen ( Sender: TObject);
    Procedure MoveTopInfoToGrid;
    Function MoveTxInfo : Boolean;
    Procedure LoadJournals;
  public
    { Public declarations }
  end;

var
  Journals: TJournals;

implementation
Uses
    JnlType,
    TxRoutines,
    LangUnit,
    Listing,
    Clears,
    DBGen,
    UTIL,
    DBCore,
    Calcs,
    vars,
    types,
    DefSecFl;

Var
   JnlInUse : Packed Array [1..48] Of Boolean;

{$R *.DFM}

Procedure TJournals.LoadJournals;
Var
   RowCounter,
   ACounter2,
   ACounter,
   Offset   : Integer;
   TempStr  : ShortString;
Begin
     RowCounter := 0;
     DispJournals.RowCount := 0;
     DispJournals.RowCount := 1;
     For ACounter := 1 To 48 Do
         JnlInUse[ACounter] := False;
     For ACounter := 0 To DispJournals.RowCount Do
         For ACounter2 := 0 To 12 Do
             DispJournals.Cells[ACounter2, Acounter] := '';

     For ACounter := 0 To 47 Do
         Begin
              JnlRead ( ACounter+1, Offset );
              If ( OffSet >= 1 ) And ( OffSet <= 6 ) And
                 ( Cash3.xJournal[OffSet].xType In [2,3] ) Then
                 Begin
                      JnlInUse[ACounter+1] := True;
                      DispJournals.Cells[1, RowCounter] := Cash3.xJournal[OffSet].xName;
                      DispJournals.Cells[2, RowCounter] := IntToStr ( Cash3.xJournal[OffSet].xDebit );
                      DispJournals.Cells[3, RowCounter] := IntToStr ( Cash3.xJournal[OffSet].xCredit );
                      LongStr ( Cash3.xJournal[Offset].xNewAmt, TempStr, 'L' );
                      DispJournals.Cells[4, RowCounter] := TempStr;
                      DispJournals.Cells[5, RowCounter] := Cash3.xJournal[OffSet].xRef;
                      DispJournals.Cells[6, RowCounter] := Cash3.xJournal[OffSet].xDesc;
                      DispJournals.Cells[7, RowCounter] := Cash3.xJournal[OffSet].xTax;
                      DispJournals.Cells[8, RowCounter] := IntToStr ( Cash3.xJournal[OffSet].xAnal );

                      If ( Cash3.xJournal[OffSet].xDebit >= Cash1.xBankMin ) And
                         ( Cash3.xJournal[OffSet].xDebit <= Cash1.xBankMax ) Then
                         DispJournals.Cells[9, RowCounter] := 'Income'
                      Else
                          DispJournals.Cells[9, RowCounter] := 'Expenditure';
                      DispJournals.Cells[10, RowCounter] := IntToStr ( Cash3.xJournal[OffSet].xNo );
                      DispJournals.Cells[11, RowCounter] := Cash11.Default_Date;{xDate}
                      DispJournals.Cells[12, RowCounter] := IntToStr ( Cash3.xJournal[OffSet].XType );

                      Inc ( RowCounter );
                      If ( RowCounter > 1 ) Then
                         DispJournals.RowCount := DispJournals.RowCount + 1;
                 End
              Else
                  If ( OffSet >= 1 ) And ( OffSet <= 6 ) And
                     ( Cash3.xJournal[OffSet].xType = 1 ) Then
                     JnlInUse[Acounter+1] := True;
         End;
End;

procedure TJournals.FormActivate(Sender: TObject);
begin
     { xType Of 2 = PROG of CASHINC }
     { xType Of 3 = PROG of CASHEXP }
     Exit.Caption := ReadLang ( 1, CurrLang );

     PROG := JOURNAL;
     ACT  := 10;
     LoadJournals;

end;

Procedure TJournals.FillTopOfScreen ( Sender : TObject );
Begin
  try
     If Numeric ( DispJournals.Cells[2, DispJournals.Row] ) And
        Numeric ( DispJournals.Cells[3, DispJournals.Row] ) Then
        If (( StrToInt ( DispJournals.Cells[2,DispJournals.Row] ) >= Cash1.xBankMin ) And
            ( StrToInt ( DispJournals.Cells[2,DispJournals.Row] ) <= Cash1.xBankMax )) Or
           (( StrToInt ( DispJournals.Cells[3,DispJournals.Row] ) >= Cash1.xBankMin ) And
            ( StrToInt ( DispJournals.Cells[3,DispJournals.Row] ) <= Cash1.xBankMax )) Then
            Begin
                 SOName.Text := DispJournals.Cells[1,DispJournals.Row];
                 SODate.Text := DispJournals.Cells[11,DispJournals.Row];

                 If ( StrToInt ( DispJournals.Cells[2,DispJournals.Row] ) >= Cash1.xBankMin ) And
                    ( StrToInt ( DispJournals.Cells[2,DispJournals.Row] ) <= Cash1.xBankMax ) Then
                    Begin
                         SOBank.Text   := DispJournals.Cells[2,DispJournals.Row];
                         SOIncExp.Text := DispJournals.Cells[3,DispJournals.Row];
                    End
                 Else
                     Begin
                          SOIncExp.Text := DispJournals.Cells[2,DispJournals.Row];
                          SOBank.Text   := DispJournals.Cells[3,DispJournals.Row];
                     End;
                 SOAmount.Text     := DispJournals.Cells[4,DispJournals.Row];
                 SOReference.Text  := DispJournals.Cells[5,DispJournals.Row];
                 SODescription.Text:= DispJournals.Cells[6,DispJournals.Row];
                 SOVATCode.Text      := DispJournals.Cells[7,DispJournals.Row];
                 SOAnalysis.Text   := DispJournals.Cells[8,DispJournals.Row];
                 If StrToInt ( DispJournals.Cells[12,DispJournals.Row] ) = 2 Then
                    SOTypeLabel.Caption := 'Standing Order Income'
                 Else
                     SOTypeLabel.Caption := 'Standing Order Expenditure';
                 Journals.Caption := SOTypeLabel.Caption;
                 SOVATCodeChange(Sender);
            End;
  except
        MessageDlg('Missing Information choose ADD or Select a line', mtInformation,[mbOK], 0);
  End;
End;

procedure TJournals.DispJournalsClick(Sender: TObject);
begin
    Journals.FillTopOfScreen ( Sender );
end;

procedure TJournals.DispJournalsDblClick(Sender: TObject);
Var
   ChangedStatus : Boolean;
   ACounter      : Integer;
begin
     If DispJournals.Cells[DispJournals.Col,DispJournals.Row] = 'X' Then
        DispJournals.Cells[DispJournals.Col,DispJournals.Row] := ' '
     Else
         DispJournals.Cells[DispJournals.Col,DispJournals.Row] := 'X';
     { Check to see if the Run Button should be activated }
     Try
        ChangedStatus := False;
        For ACounter := 0 To DispJournals.RowCount Do
            If Numeric ( DispJournals.Cells[2, ACounter] ) And
               Numeric ( DispJournals.Cells[3, ACounter] ) Then
               If   ( DispJournals.Cells[0, ACounter] = 'X' ) And
                  ((( StrToInt ( DispJournals.Cells[2, ACounter] ) >= Cash1.xBankMin ) And
                    ( StrToInt ( DispJournals.Cells[2, ACounter] ) <= Cash1.xBankMax )) Or
                   (( StrToInt ( DispJournals.Cells[3, ACounter] ) >= Cash1.xBankMin ) And
                    ( StrToInt ( DispJournals.Cells[3, ACounter] ) <= Cash1.xBankMax ))) Then
                    ChangedStatus := True;
        RunButton.Enabled := ChangedStatus;
     ExCept
        RunButton.Enabled := ChangedStatus;
     End;
end;

procedure TJournals.ExitClick(Sender: TObject);
begin
     Close;
end;

Function TJournals.MoveTxInfo : Boolean;
Var
   TestStr : ShortString;
Begin
     MoveTxInfo := False;

     zUse[1,1] := True;

     zRef[1] := SOReference.Text;
     ZDesc[1,1] := SODescription.Text;

     TestStr := SOBank.Text;
     SlimAll ( TestStr );
     {
     ZAccount[1] := StrToInt ( TestStr );
     }
     ZBank[1] := StrToInt ( TestStr );

     zTxDate[1] := KDateToInt ( SODate.Text );

     TestStr := SOIncExp.Text;
     SlimAll ( TestStr );
     ZGen[1,1] := StrToInt ( TestStr );
     StrLong ( SOAmount.Text, ZAmt[1,1] );
     ZTax[1,1] := SOVATCode.Text;
     StrLong ( SOVATAmount.Text, ZTaxAmt[1,1] );
     CheckEnd;

     MoveTxInfo := True;
End;

procedure TJournals.RunButtonClick(Sender: TObject);
Var
   ACounter : Integer;
begin
     { Write Transactions For All Marked Records }
     For ACounter := 0 To DispJournals.RowCount Do
         Try
            InitVals;
            If Numeric ( DispJournals.Cells[2, ACounter] ) And
               Numeric ( DispJournals.Cells[3, ACounter] ) Then
               If   ( DispJournals.Cells[0, ACounter] = 'X' ) And
                  ((( StrToInt ( DispJournals.Cells[2, ACounter] ) >= Cash1.xBankMin ) And
                    ( StrToInt ( DispJournals.Cells[2, ACounter] ) <= Cash1.xBankMax )) Or
                   (( StrToInt ( DispJournals.Cells[3, ACounter] ) >= Cash1.xBankMin ) And
                    ( StrToInt ( DispJournals.Cells[3, ACounter] ) <= Cash1.xBankMax ))) Then
                    Begin
                      { Set the row }
                      DispJournals.Row := ACounter;
                      { Paint the top of the Screen with ROW Info. }
                      Journals.FillTopOfScreen ( Sender );
                      If MessageDlg('OK to Write Transaction', mtConfirmation,[mbYes,mbNo], 0) = mrYes Then
                         Begin
                              If StrToInt ( DispJournals.Cells[12, ACounter] ) = 2 Then
                                 PROG := CASHINC
                              Else
                                  PROG := CASHEXP;
                              ACT := 1;
                              If MoveTxInfo Then
                                 WriteTransactions(1,NLFile);
                              DispJournals.Cells[0, ACounter] := ' ';
                         End;
                    End;
         ExCept
               { Invalid details so no record written }
         End;
     RunButton.Enabled := False;
end;

procedure TJournals.FormCreate(Sender: TObject);
begin
     RunButton.Enabled := False;
end;

Procedure TJournals.MoveTopInfoToGrid{(Sender : TObject )};
Begin
     DispJournals.Cells[1,DispJournals.Row] := SOName.Text;
     If StrToInt ( DispJournals.Cells[12,DispJournals.Row] ) = 2 Then
        Begin
             DispJournals.Cells[2,DispJournals.Row] := SOBank.Text;
             DispJournals.Cells[3,DispJournals.Row] := SOIncExp.Text;
        End
     Else
        Begin
             DispJournals.Cells[2,DispJournals.Row] := SOIncExp.Text;
             DispJournals.Cells[3,DispJournals.Row] := SOBank.Text;
        End;
     DispJournals.Cells[4,DispJournals.Row] := SOAmount.Text;
     DispJournals.Cells[5,DispJournals.Row] := SOReference.Text;
     DispJournals.Cells[6,DispJournals.Row] := SODescription.Text;
     DispJournals.Cells[7,DispJournals.Row] := SOVATCode.Text;
     DispJournals.Cells[8,DispJournals.Row] := SOAnalysis.Text;
     DispJournals.Cells[11,DispJournals.Row]:= SODate.Text;
End;


procedure TJournals.SaveClick(Sender: TObject);
Var
   TempStr       : String;
   TempOffSet,
   RewriteOffSet : Integer;
begin

     { Save the Current Journal back to CashBook.DEF }
     ReWriteOffSet := StrToInt ( DispJournals.Cells[10,DispJournals.Row] );
     { ReRead the current Journal }
     JnlRead ( ReWriteOffSet, TempOffSet );

     If TempOffSet In [1..6] Then
        Begin
             MoveTopInfoToGrid {( Sender )};
             With Cash3.xJournal[TempOffSet] Do
                  Begin
                       xName   := DispJournals.Cells[1, DispJournals.Row];
                       xNo     := ReWriteOffSet;
                       xDebit  := StrToInt ( DispJournals.Cells[2, DispJournals.Row] );
                       xCredit := StrToInt ( DispJournals.Cells[3, DispJournals.Row] );
                       TempStr := DispJournals.Cells[4, DispJournals.Row];
                       StrLong ( TempStr, xNewAmt );
                       xRef    := DispJournals.Cells[5, DispJournals.Row];
                       xDesc   := DispJournals.Cells[6, DispJournals.Row];
                       xTax    := DispJournals.Cells[7, DispJournals.Row];
                       If Numeric ( DispJournals.Cells[8, DispJournals.Row] ) Then
                          xAnal   := StrToInt ( DispJournals.Cells[8, DispJournals.Row] )
                       Else
                           xAnal := 0;
                       xType   := StrToInt ( DispJournals.Cells[12, DispJournals.Row] );
                  End;
             JnlWrite ( ReWriteOffSet );
        End;
end;

procedure TJournals.SOBankClick(Sender: TObject);
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
           End;
   End;

begin
     InitRange ( AccRange );
     AccRange[1] := Cash1.xBankMin;
     AccRange[2] := Cash1.xBankMax;
     TestStr := SOBank.Text;
     SlimAll ( TestStr );
     If ( NOT ListBox.CheckNom ( SOBank.Text, AccRange )) Or
        ( Length ( TestStr ) = 0 ) Then
        SOBank.SetFocus
     Else
         GetBankInfo;
end;

procedure TJournals.SOBankKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
         ListBox.ListIt ( Sender, Banks{'B'}, 'N' );
         If Length ( ListBox.ListInfo.ReturnValue ) > 0 Then
            SOBank.Text := ListBox.ListInfo.ReturnValue;
       End;
end;

procedure TJournals.SOIncExpKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
         ListBox.ListIt ( Sender, AllNomsXBank{'X'}, 'N' );
         If Length ( ListBox.ListInfo.ReturnValue ) > 0 Then
            SOIncExp.Text := ListBox.ListInfo.ReturnValue;
       End;
end;

procedure TJournals.SOAmountExit(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := SOAmount.Text;
     SlimAll ( TempStr );
     If Length ( TempStr ) > 0 Then
        If NOT ChangeToLong ( TempStr ) Then
           SOAmount.SetFocus
        Else
            SOAmount.Text := TempStr;
end;

procedure TJournals.SOVATCodeChange(Sender: TObject);
Var
   VATArrPos : Integer;
   VAtAmt,
   NomAmt    : Long;
   TempLong,
   TempStr   : ShortString;
begin
     TempStr := SOVATCode.Text;
     If NOT ListBox.CheckVAT ( TempStr, VATArrPos ) Then
        SOVATCode.SetFocus
     Else
         Begin
              TempLong := SOAmount.Text;
              SlimAll ( TempLong );
              StrLong ( TempLong, NomAmt );
              TempLong := SOVATAmount.Text;
              SlimAll ( TempLong );
              StrLong ( TempLong, VatAmt );
              ListBox.CalcTax ( VATArrpos, TempStr, VatAmt, NomAmt );
              LongStr ( VatAmt, TempLong, 'L' );
              {
              If ( VatAmt <> 0 ) Then
              }
              SOVATAmount.Text := TempLong;
              LongStr ( NomAmt, TempLong, 'L' );
              If ( NomAmt <> 0 ) Then
                 SOAmount.Text := TempLong;
         End;
end;

procedure TJournals.SOVATCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Key = VK_F2 Then
        Begin
             ListBox.ListIt ( Sender, Vat, 'V' );
             If Length ( ListBox.ListInfo.ReturnValue ) > 0 Then
                SOVATCode.Text := ListBox.ListInfo.ReturnValue;
        End;
end;

procedure TJournals.SOIncExpExit(Sender: TObject);
Var
   Selected   : Boolean;
   NomAccount : Integer;
begin
     Selected := False;
     NomAccount := 0;
     If Numeric ( SOIncExp.Text ) Then
        NomAccount := StrToInt ( SOIncExp.Text );

     If (( NomAccount >= Cash1.XNOMPRVINC ) AND
         ( NomAccount <= Cash1.XNOMPRVINC+Cash11.xno_of_partners )) Or
        (( NomAccount >= Cash1.xNomIncFrom ) And
         ( NomAccount <= Cash1.xNomNonto ))                  Or
        (( NomAccount >= Cash1.xNomCaFrom ) And
         ( NomAccount <= Cash1.xNomCaTo ))                   Then
         { Standing Order Income }
         Begin
              DispJournals.Cells[12,DispJournals.Row] := '2';
              Selected := True;
              SOTypeLabel.Caption := 'Standing Order Income';
         End
     Else
         If (( NomAccount >= Cash1.xNomExpFrom ) And ( NomAccount <= Cash1.xNomOhTo )) Or
            (( NomAccount >= Cash1.xNomPrvExp ) And ( NomAccount <= Cash1.xNomPrvExp+Cash11.xNo_Of_Partners )) Or
            (( NomAccount >= Cash1.xNomLiFrom ) And ( NomAccount <= Cash1.xNomLiTo )) Then
               { Standing Order Income }
               Begin
                    DispJournals.Cells[12,DispJournals.Row] := '3';
                    SOTypeLabel.Caption := 'Standing Order Expenditure';
                    Selected := True;
               End;
     If NOT Selected Then
        SOIncExp.SetFocus;
     Caption := SoTypeLabel.Caption;
end;

procedure TJournals.SOVATCodeExit(Sender: TObject);
begin
    SOVATCodeChange(Sender);
end;

procedure TJournals.DeleteClick(Sender: TObject);
Var
   TempOffSet,
   ReWriteOffSet : Integer;
begin
     { Delete the Current Journal From CashBook.DEF }
     ReWriteOffSet := StrToInt ( DispJournals.Cells[10,DispJournals.Row] );
     { ReRead the current Journal }
     JnlRead ( ReWriteOffSet, TempOffSet );

     If TempOffSet In [1..6] Then
        Begin
             FillChar ( Cash3.xJournal[TempOffSet], SizeOf ( Cash3.xJournal[TempOffSet] ), Chr(0));
             JnlWrite ( ReWriteOffSet );
        End;
     { ReRead The Journals into the Grid }
     LoadJournals;
end;

procedure TJournals.AddClick(Sender: TObject);
Var
   FreeAccount,
   ACounter : Integer;
begin
     { Find Next Free Journal }
     ACounter := 1;
     FreeAccount := 0;

     JnlType.FJnlType.ShowModal;

     If FJnlType.JnlType In [2..3] Then
        Repeat
           If ( NOT JnlInUse[ACounter] ) Then
              FreeAccount := ACounter;
           Inc ( ACounter );
        Until ( ACounter > 48 ) Or ( FreeAccount In[1..48] );
     If FreeAccount In [1..48] Then
        Begin
             DispJournals.RowCount := DispJournals.RowCount + 1;
             {
             TempStr := DispJournals.Cells[10,DispJournals.RowCount-1];
             SlimAll ( TempStr );
             If Numeric ( TempStr ) Then
                DispJournals.RowCount := DispJournals.RowCount + 1;
             }
             DispJournals.Row := DispJournals.RowCount-1;
             DispJournals.Cells[10, DispJournals.Row] := IntToStr ( FreeAccount );
             DispJournals.Cells[11, DispJournals.Row] := Cash11.Default_Date;{xDate}
             DispJournals.Cells[12, DispJournals.Row] := IntToStr(FJnlType.JnlType);
             SODate.Text := Cash11.Default_Date;{xDate}
             SOBank.Text := IntToStr ( Cash1.xLastBank );
             SOName.SetFocus;
        End
     Else
        MessageDlg('No Free Accounts', mtInformation,[mbOK], 0);
end;

procedure TJournals.SODateExit(Sender: TObject);
Var
   TestDate : ShortString;
   DateBefore : Boolean;
begin
     TestDate := SODate.Text;
     If NOT DateValid ( SODate.Text, TDateFormat ) Then
        SODate.SetFocus
     Else If NOT CheckDateRange ( TestDate, True, DateBefore ) Then
          Begin
               SODate.Text := TestDate;
               SODate.SetFocus;
          End;
end;

end.
