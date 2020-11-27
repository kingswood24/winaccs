{
 Used to Add/Amend/Delete Standing Orders, Enterprise Transfers and Journals.
 Up to 48 in Total can be added,
 Standing Orders are Identified by having a xType = 2 Or 3 depending on Income/Expenditure
 Inter Enterprise Transfers by having a xType = 4
 Journals will be xType = 1.

 30/08/19 [V4.5 R0.3] /MK Change - Changed layout of the screen so that it can be made larger to view more lines - TGM request.
                                 - Remove the Next button as its no longer required - TGM request.
                                 - Change colour of panels to standard blue colour on main grid - TGM request.
}

unit Jour;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, ExtCtrls, StdCtrls, Buttons, Mask, ComCtrls;

type
  TKSet = ( SOrders, EntTrans );
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
    VATCodeLabel: TLabel;
    AnalysisLabel: TLabel;
    BankNameLabel: TLabel;
    SOVATAmount: TEdit;
    VATamtLabel: TLabel;
    Label5: TLabel;
    SOVATCode: TMaskEdit;
    Quantity: TEdit;
    QtyLabel: TLabel;
    BankSearch: TSpeedButton;
    AnalysisBtn: TSpeedButton;
    IncExpBtn: TSpeedButton;
    VATBtn: TSpeedButton;
    NominalNameLabel: TLabel;
    ExpenditureLabel: TLabel;
    TxDate: TMaskEdit;
    DateSearch: TDateTimePicker;
    PromptLine: TStatusBar;
    pTop: TPanel;
    Panel1: TPanel;
    Exitbtn: TBitBtn;
    Save: TBitBtn;
    Delete: TBitBtn;
    Add: TBitBtn;
    Help: TBitBtn;
    Panel2: TPanel;
    SOTypeLabel: TLabel;
    WritePanel: TPanel;
    WriteTxButton: TBitBtn;
    procedure DispJournalsDblClick(Sender: TObject);
    procedure DispJournalsClick(Sender: TObject);
    procedure ExitbtnClick(Sender: TObject);
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
    procedure FormShow(Sender: TObject);
    procedure WriteTxButtonClick(Sender: TObject);
    procedure NextButtonClick(Sender: TObject);
    procedure SOIncExpClick(Sender: TObject);
    procedure QuantityExit(Sender: TObject);
    procedure SOAnalysisKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BankSearchClick(Sender: TObject);
    procedure IncExpBtnClick(Sender: TObject);
    procedure VATBtnClick(Sender: TObject);
    procedure AnalysisBtnClick(Sender: TObject);
    procedure SONameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure SOBankDblClick(Sender: TObject);
    procedure SOIncExpDblClick(Sender: TObject);
    procedure SOVATCodeDblClick(Sender: TObject);
    procedure DateSearchCloseUp(Sender: TObject);
    procedure DateSearchDropDown(Sender: TObject);
    procedure TxDateEnter(Sender: TObject);
    procedure TxDateExit(Sender: TObject);
    procedure SOAmountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SOVATAmountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure QuantityKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HelpClick(Sender: TObject);
    procedure SOBankEnter(Sender: TObject);
    procedure SOAnalysisExit(Sender: TObject);
    procedure SONameEnter(Sender: TObject);
    procedure SOReferenceEnter(Sender: TObject);
    procedure SOAmountEnter(Sender: TObject);
    procedure SODescriptionEnter(Sender: TObject);
    procedure QuantityEnter(Sender: TObject);
    procedure DispJournalsEnter(Sender: TObject);
    procedure SOAmountChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    
    AmtChanged,
    CodeChanged : Boolean;

    GridRowPos : Integer;
    Procedure ClearTopOfScreen;
    Procedure FillTopOfScreen;
    Procedure MoveTopInfoToGrid;
    Function MoveTxInfo : Boolean;
    Procedure LoadJournals;
    procedure SetNextRec;
    procedure GetNextRec;
    procedure CheckWriteOk;
  public
    { Public declarations }
    WhichType : TKSet;
  end;

var
  Journals: TJournals;

implementation
Uses
    JnlType,
    TxWrite,
    LangUnit,
    NewListing,
    Clears,
    DbGen,
    UTIL,
    DBCore,
    Calcs,
    vars,
    types,
    DefSecFl, uSetupAnalysis;

Var
   JnlInUse : Packed Array [1..48] Of Boolean;
//   AmountEXVat : ShortString;

{$R *.DFM}

Procedure TJournals.ClearTopOfScreen;
var
   i : Integer;
begin
    with SOrderPanel do
       for i := 0 to ControlCount-1 do
          begin
              if (Controls[i] is TEdit) then
                 (Controls[i] as TEdit).Clear;
              if (Controls[i] is TMaskEdit) then
                 (Controls[i] as TMaskEdit).Clear;
          end;
end;

Procedure TJournals.LoadJournals;
Var
   RowCounter,
   ACounter2,
   ACounter,
   Offset   : Integer;
   TempStr  : ShortString;
Begin

     For ACounter := 0 To DispJournals.RowCount Do
         For ACounter2 := 0 To DispJournals.ColCount-1 Do
             DispJournals.Cells[ACounter2, Acounter] := ' ';
     RowCounter := 0;
     DispJournals.RowCount := 0;
     DispJournals.RowCount := 1;
     For ACounter := 1 To 48 Do
         JnlInUse[ACounter] := False;

     // Added 09-03-1999 Disable the Delete and Save button to ensure there
     // are some Ent Trans or S Orders to save/delete
     FillTopOfScreen;
     Save.Enabled := FALSE;
     Delete.Enabled := FALSE;

     For ACounter := 0 To 47 Do
         Begin
              JnlRead ( ACounter+1, Offset );
              {
              messagedlg ( 'TYPE ' + inttostr ( Cash3.xJournal[offset].xtype),mtinformation,[mbok],0);
              }
              If Cash3.xJournal[OffSet].xType In [1..4] Then
                 JnlInUse[ACounter+1] := True;

              If ( OffSet >= 1 ) And ( OffSet <= 6 ) And
                 ( Cash3.xJournal[OffSet].xType In [2,3] ) And
                 ( WhichType = SOrders ) Then
                 Begin
                      DispJournals.Cells[1, RowCounter] := Cash3.xJournal[OffSet].xName;
                      DispJournals.Cells[2, RowCounter] := IntToStr ( Cash3.xJournal[OffSet].xDebit );
                      DispJournals.Cells[3, RowCounter] := IntToStr ( Cash3.xJournal[OffSet].xCredit );
                      LongStr ( Cash3.xJournal[Offset].xNewAmt, TempStr, 'L' );
                      DispJournals.Cells[4, RowCounter] := TempStr;
                      // Store the Original Amount
                      DispJournals.Cells[13, RowCounter] := TempStr;
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
                      If RowCounter = 0 Then
                         begin
                            FillTopOfScreen;
                            // Added 09-03-1999
                            Save.Enabled := TRUE;
                            Delete.Enabled := TRUE;
                         end;

                      Inc ( RowCounter );
                      If ( RowCounter > 1 ) Then
                         DispJournals.RowCount := DispJournals.RowCount + 1;
                 End
              Else
                  { Enterprise Transfers }
                  If (( OffSet >= 1 ) And ( OffSet <= 6 ) And
                      ( Cash3.xJournal[OffSet].xType = 4 ) And
                      ( WhichType = EntTrans )) Then
                    Begin
                      DispJournals.Cells[1, RowCounter] := Cash3.xJournal[OffSet].xName;
                      DispJournals.Cells[2, RowCounter] := IntToStr ( Cash3.xJournal[OffSet].xDebit );
                      DispJournals.Cells[3, RowCounter] := IntToStr ( Cash3.xJournal[OffSet].xCredit );
                      LongStr ( Cash3.xJournal[Offset].xNewAmt, TempStr, 'L' );
                      DispJournals.Cells[4, RowCounter] := TempStr;
                      // Store the Original Amount
                      DispJournals.Cells[13, RowCounter] := TempStr;
                      DispJournals.Cells[6, RowCounter] := Cash3.xJournal[OffSet].xDesc;
                      DispJournals.Cells[5, RowCounter] := Cash3.xJournal[OffSet].xRef;
                      LongStr ( Cash3.xJournal[Offset].xQty, TempStr, 'L' );
                      DispJournals.Cells[7, RowCounter] := TempStr;
                      {
                      DispJournals.Cells[8, RowCounter] := IntToStr ( Cash3.xJournal[OffSet].xAnal );
                      }
                      DispJournals.Cells[9, RowCounter] := 'Enterprise Transfer';
                      DispJournals.Cells[10, RowCounter] := IntToStr ( Cash3.xJournal[OffSet].xNo );
                      DispJournals.Cells[11, RowCounter] := Cash11.Default_Date;
                      DispJournals.Cells[12, RowCounter] := IntToStr ( Cash3.xJournal[OffSet].xType );
                      If RowCounter = 0 Then
                         begin
                            FillTopOfScreen;
                            // Added 09-03-1999
                            Save.Enabled := TRUE;
                            Delete.Enabled := TRUE;
                         end;

                      Inc ( RowCounter );
                      If ( RowCounter > 1 ) Then
                         DispJournals.RowCount := DispJournals.RowCount + 1;
                    end;
         End;
End;

Procedure TJournals.FillTopOfScreen;
Begin
  Try
     ClearTopOfScreen;
     If Numeric ( DispJournals.Cells[2, DispJournals.Row] ) And
        Numeric ( DispJournals.Cells[3, DispJournals.Row] ) Then
        {
        If ((( StrToInt ( DispJournals.Cells[2,DispJournals.Row] ) >= xBankMin ) And
             ( StrToInt ( DispJournals.Cells[2,DispJournals.Row] ) <= xBankMax )) Or
            (( StrToInt ( DispJournals.Cells[3,DispJournals.Row] ) >= xBankMin ) And
             ( StrToInt ( DispJournals.Cells[3,DispJournals.Row] ) <= xBankMax )) And
             ( WhichType = SOrders )) Or
           ((( StrToInt ( DispJournals.Cells[2,DispJournals.Row] ) >= xNomExpFrom ) And
             ( StrToInt ( DispJournals.Cells[2,DispJournals.Row] ) <= xNomExpTo )) Or
            (( StrToInt ( DispJournals.Cells[3,DispJournals.Row] ) >= xNomIncFrom ) And
             ( StrToInt ( DispJournals.Cells[3,DispJournals.Row] ) <= xNomIncTo )) And
             ( WhichType = EntTrans )) Then
        }
            Begin
                 SOName.Text := DispJournals.Cells[1,DispJournals.Row];
//                 SODate.Text := DispJournals.Cells[11,DispJournals.Row];
                 TxDate.Text :=  cash1.xdate; // TGM AB was DispJournals.Cells[11,DispJournals.Row];

                 AmtChanged := FALSE;
                 CodeChanged := FALSE;

                 If ( WhichType = SOrders ) Then
                    Begin
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
                    End
                 Else
                    Begin
                       SOBank.Text   := DispJournals.Cells[2,DispJournals.Row];
                       SOIncExp.Text := DispJournals.Cells[3,DispJournals.Row];
                    End;

                 // Restore from 13 the Original Amount NO VAT calc done on this
                 SOAmount.Text     := DispJournals.Cells[13,DispJournals.Row];
                 SOReference.Text  := DispJournals.Cells[5,DispJournals.Row];
                 SODescription.Text:= DispJournals.Cells[6,DispJournals.Row];
                 If WhichType = SOrders Then
                    Begin
                       SOVATCode.Text      := DispJournals.Cells[7,DispJournals.Row];
//                       if ( AmtChanged ) or ( CodeChanged ) or ( VATAmtChanged ) then
//                          SOVATCodeChange ( Self );
                    End
                 Else
                    Quantity.Text      := DispJournals.Cells[7,DispJournals.Row];
                 SOAnalysis.Text   := DispJournals.Cells[8,DispJournals.Row];
                 If StrToInt ( DispJournals.Cells[12,DispJournals.Row] ) = 2 Then
                    SOTypeLabel.Caption := 'S.Order Income'
                 Else If StrToInt ( DispJournals.Cells[12,DispJournals.Row] ) = 3 Then
                    SOTypeLabel.Caption := 'S.Order Expenditure'
                 Else If StrToInt ( DispJournals.Cells[12,DispJournals.Row] ) = 4 Then
                    SOTypeLabel.Caption := 'Enterprise Transfer';
                 Journals.Caption := SOTypeLabel.Caption;
            End;
  except
        MessageDlg('Missing Information choose ADD or Select a line', mtInformation,[mbOK], 0);
  End;
End;

procedure TJournals.DispJournalsClick(Sender: TObject);
begin
    FillTopOfScreen;
    GridRowPos := DispJournals.Row;
end;

procedure TJournals.CheckWriteOk;
Var
   ChangedStatus : Boolean;
   ACounter      : Integer;
begin
     { Check to see if the Run Button should be activated }
     Try
        ChangedStatus := False;
        For ACounter := 0 To DispJournals.RowCount Do
            If Numeric ( DispJournals.Cells[2, ACounter] ) And
               Numeric ( DispJournals.Cells[3, ACounter] ) Then
               If ( DispJournals.Cells[0, ACounter] = 'X' ) Then
                  ChangedStatus := True;
        WritePanel.Enabled := ChangedStatus;
        WriteTxButton.Enabled := ChangedStatus;
     ExCept
        WritePanel.Enabled := False;
        WriteTxButton.Enabled := False;
     End;
end;

procedure TJournals.DispJournalsDblClick(Sender: TObject);
begin
     If DispJournals.Cells[0,DispJournals.Row] = 'X' Then
        DispJournals.Cells[0,DispJournals.Row] := ' '
     Else
         DispJournals.Cells[0,DispJournals.Row] := 'X';
     CheckWriteOK;
end;

procedure TJournals.ExitbtnClick(Sender: TObject);
begin
     Close;
end;

Function TJournals.MoveTxInfo : Boolean;
Var
   TestStr : ShortString;
//   i:integer;
Begin
     MoveTxInfo := False;

     zUse[1,1] := True;

     zRef[1] := SOReference.Text;
     ZDesc[1,1] := SODescription.Text;

     TestStr := SOBank.Text;
     SlimAll ( TestStr );

     If WhichType = EntTrans Then
        zDb[1,1] := StrToInt ( TestStr )
     Else
         zBank[1] := StrToInt ( TestStr );

//     zTxDate[1] := KDateToInt ( SODate.Text );
     zTxDate[1] := KDateToInt ( TxDate.Text );

     Zstub[1] := 00000000;

     TestStr := SOIncExp.Text;
     SlimAll ( TestStr );
     If WhichType = EntTrans Then
        zCr[1,1] := StrToInt ( TestStr )
     Else
         zGen[1,1] := StrToInt ( TestStr );
     StrLong ( SOAmount.Text, ZAmt[1,1] );
     If WhichType = EntTrans Then
        StrLong ( Quantity.Text, zQty[1,1] );

     // TGM AB 23/11/12 Fix bug allowing program to save blank VAT code
     if ((SOVATCode.Text = ' ') or (SOVATCode.Text = ' ')) then ZTax[1,1] := 'Z'
        else ZTax[1,1] := SOVATCode.Text;


// next line added by TGM 15/10/01 to correct bug where standing orders not saving description
//     for i:= 1 to 15 do
     ZDesc[1,1] := '               ';
     ZDesc[1,1] := SODescription.text;

     // TGM AB 23/11/12 Fix bug where analysis code isn't being saved

     TestStr := SOAnalysis.Text;
     SlimAll ( TestStr );
     try zAnalysis[1,1] := strtoint(TestStr);
     except zAnalysis[1,1] := 0;
     end;


     StrLong ( SOVATAmount.Text, ZTaxAmt[1,1] );
     CheckEnd;

     MoveTxInfo := True;
End;

Procedure TJournals.MoveTopInfoToGrid{(Sender : TObject )};
Begin
     DispJournals.Cells[1,DispJournals.Row] := SOName.Text;
     If StrToInt ( DispJournals.Cells[12,DispJournals.Row] ) = 2 Then
        Begin
             DispJournals.Cells[2,DispJournals.Row] := SOBank.Text;
             DispJournals.Cells[3,DispJournals.Row] := SOIncExp.Text;
        End
     Else If StrToInt ( DispJournals.Cells[12,DispJournals.Row] ) = 3 Then
        Begin
             DispJournals.Cells[2,DispJournals.Row] := SOIncExp.Text;
             DispJournals.Cells[3,DispJournals.Row] := SOBank.Text;
        End
     Else If StrToInt ( DispJournals.Cells[12,DispJournals.Row] ) = 4 Then
        Begin
             DispJournals.Cells[2,DispJournals.Row] := SOBank.Text;
             DispJournals.Cells[3,DispJournals.Row] := SOIncExp.Text;
        End;

//     DispJournals.Cells[4,DispJournals.Row] := SOAmount.Text;
     DispJournals.Cells[4,DispJournals.Row] := DispJournals.Cells[13,DispJournals.Row] ;
     DispJournals.Cells[5,DispJournals.Row] := SOReference.Text;
     DispJournals.Cells[6,DispJournals.Row] := SODescription.Text;
     If WhichType = EntTrans Then
         DispJournals.Cells[7,DispJournals.Row] := Quantity.Text
     Else
         begin
         if ((SOVATCode.Text = '') or (SOVATCode.Text = ' ')) then SOVATCode.Text := 'Z';   // TGM AB 23/11/12
         DispJournals.Cells[7,DispJournals.Row] := SOVATCode.Text;
         end;
     DispJournals.Cells[8,DispJournals.Row] := SOAnalysis.Text;
//     DispJournals.Cells[11,DispJournals.Row]:= SODate.Text;
     DispJournals.Cells[11,DispJournals.Row]:= TxDate.Text;
End;

procedure TJournals.SaveClick(Sender: TObject);
Var
   TempStr       : ShortString;
   TempOffSet,
   RewriteOffSet : Integer;
begin

     { Save the Current Journal back to CashBook.DEF }
     ReWriteOffSet := StrToInt ( DispJournals.Cells[10,DispJournals.Row] );
     { ReRead the current Journal }
     JnlRead ( ReWriteOffSet, TempOffSet );

     If TempOffSet In [1..6] Then
        Begin
             MoveTopInfoToGrid;
             With Cash3.xJournal[TempOffSet] Do
                  Begin
                       xName   := DispJournals.Cells[1, DispJournals.Row];
                       xNo     := ReWriteOffSet;
                       If WhichType = SOrders Then
                          Begin
                            xDebit  := StrToInt ( DispJournals.Cells[2, DispJournals.Row] );
                            xCredit := StrToInt ( DispJournals.Cells[3, DispJournals.Row] );
                          End
                       Else
                          Begin
                            xDebit  := StrToInt ( DispJournals.Cells[2, DispJournals.Row] );
                            xCredit := StrToInt ( DispJournals.Cells[3, DispJournals.Row] );
                          End;

                       // Store Column 13 Original Amount
                       TempStr := DispJournals.Cells[13, DispJournals.Row];
                       StrLong ( TempStr, xNewAmt );
                       xDesc   := DispJournals.Cells[6, DispJournals.Row];
                       xRef    := DispJournals.Cells[5, DispJournals.Row];
                       If WhichType = SOrders Then begin
                          xTax    := DispJournals.Cells[7, DispJournals.Row];
                          end
                       Else
                          Begin
                             FillChar ( xTax, SizeOf(xTax), ' ' );
                             TempStr := DispJournals.Cells[7, DispJournals.Row];
                             StrLong ( TempStr, xQty );
                          End;

                       if Numeric ( DispJournals.Cells[8, DispJournals.Row] ) then
                          xAnal   := StrToInt ( DispJournals.Cells[8, DispJournals.Row] )
                       else
                           xAnal := 0;
                       xType   := StrToInt ( DispJournals.Cells[12, DispJournals.Row] );
                  End;
             JnlWrite ( ReWriteOffSet );
             JnlInUse[ReWriteOffSet] := True;
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
     If WhichType = SOrders Then
        Begin
           AccRange[1] := Cash1.xBankMin;
           AccRange[2] := Cash1.xBankMax;
        End
     Else
        Begin
           AccRange[1] := Cash1.xNomExpFrom;
           AccRange[2] := Cash1.xNomExpTo;
        End;

     TestStr := SOBank.Text;
     SlimAll ( TestStr );
     If ( NOT NewListBox.CheckNom ( SOBank.Text, AccRange )) Or
        ( Length ( TestStr ) = 0 ) or (CheckNomEqualsZero(TestStr)) Then      // TGM AB 24/04/15
        SOBank.SetFocus
     Else
         If WhichType = SOrders Then
            GetBankInfo;
end;

procedure TJournals.SOBankKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
{  If Key = VK_F1 then
       Begin
            If Whichtype = SOrders Then
               Application.HelpContext(15)
            Else
               Application.HelpContext(46);
       end;}

    If Key = VK_F2 Then    { F2 Pressed }
       Begin
         If WhichType = SOrders Then
            NewListBox.ListIt ( Sender, Banks, 'N' )
         Else
            NewListBox.ListIt ( Sender, EntAllExpend, 'I' );
         If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            SOBank.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TJournals.SOIncExpKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
         If WhichType = SOrders Then
            NewListBox.ListIt ( Sender, AllNomsXBank, 'N' )
         Else
            NewListBox.ListIt ( Sender, EntAllIncome, 'I' );
         If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            SOIncExp.Text := NewListBox.ListInfo.ReturnValue;
       End;

    If Key = VK_F1 then
       Begin
            If Whichtype = SOrders Then
               Application.HelpContext(107)
            Else
               Application.HelpContext(45);
            Key := 0;
       end;

end;

procedure TJournals.SOAmountExit(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := SOAmount.Text;
     SlimAll ( TempStr );
     if Length ( TempStr ) > 0 then
        if NOT ChangeToLong ( TempStr ) then
           SOAmount.SetFocus
        else
           if AmtChanged then
              begin
                 SOAmount.Text := TempStr;
                 // Store the Amount before the VAT Calculation
                 DispJournals.Cells[13,DispJournals.Row] := SOAmount.Text;
                 DispJournals.Cells[4,DispJournals.Row] := SOAmount.Text;
                 if ( WhichType = SOrders ) then
                    SOVATCodeChange ( Sender );
              end;
end;

procedure TJournals.SOVATCodeChange(Sender: TObject);
Var
   VATArrPos : Integer;
   VAtAmt,
   NomAmt    : Long;
   TempLong,
   TempStr   : ShortString;
   IsExclusive : Boolean;
begin
     CodeChanged := TRUE;
     TempStr := SOVATCode.Text;
     If NOT NewListBox.CheckVAT ( TempStr, VATArrPos ) Then
        SOVATCode.SetFocus
     Else
         Begin
              TempLong := SOAmount.Text;
              SlimAll ( TempLong );
              StrLong ( TempLong, NomAmt );

              TempLong := SOVATAmount.Text;
              SlimAll ( TempLong );
              StrLong ( TempLong, VatAmt );
              NewListBox.CalcTax ( VATArrpos, TempStr, VatAmt, NomAmt, IsExclusive );
              LongStr ( VatAmt, TempLong, 'L' );
              {
              If ( VatAmt <> 0 ) Then
              }
              SOVATAmount.Text := TempLong;
              LongStr ( NomAmt, TempLong, 'L' );
              if ( NomAmt <> 0 ) then
                 SOAmount.Text := TempLong;
         End;

     AmtChanged := FALSE;
     CodeChanged := FALSE;
end;

procedure TJournals.SOVATCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Key = VK_F2 Then
        Begin
             NewListBox.ListIt ( Sender, Vat, 'V' );
             If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
                SOVATCode.Text := NewListBox.ListInfo.ReturnValue;
        End;
end;

procedure TJournals.SOIncExpExit(Sender: TObject);
Var
   Selected   : Boolean;
   NomAccount : Integer;
   AccRange : TAccRange;

begin
     InitRange ( AccRange ); // TGM AB 13/03/15
     Selected := False;
     NomAccount := 0;
     If Numeric ( SOIncExp.Text ) Then
        NomAccount := StrToInt ( SOIncExp.Text );

     If WhichType = SOrders Then
       Begin
         If (( NomAccount >= Cash1.XNOMPRVINC ) AND
             ( NomAccount <= Cash1.XNOMPRVINC+Cash11.xno_of_partners )) Or
            (( NomAccount >= Cash1.xNomIncFrom ) And
             ( NomAccount <= Cash1.xNomNonto ))                  Or
            (( NomAccount >= Cash1.xNomCaFrom ) And
             ( NomAccount <= Cash1.xNomCaTo ))                   Then
            { Standing Order Income }
            Begin
              DispJournals.Cells[12,DispJournals.Row] := '2';
              If ( NOT NewListBox.CheckNom ( SOIncExp.Text, AccRange )) Or              // TGM AB 13/03/15  - blank AccRange forces recactive check
                  ( NomAccount = 0 ) Then Selected := false                             // TGM AB 13/03/15
                  else Selected := True;                                                // TGM AB 13/03/15
              SOTypeLabel.Caption := 'S.Order Income';
            End
         Else
            If (( NomAccount >= Cash1.xNomExpFrom ) And ( NomAccount <= Cash1.xNomOhTo )) Or
               (( NomAccount >= Cash1.xNomPrvExp ) And ( NomAccount <= Cash1.xNomPrvExp+Cash11.xNo_Of_Partners )) Or
               (( NomAccount >= Cash1.xNomLiFrom ) And ( NomAccount <= Cash1.xNomLiTo )) Then
               { Standing Order Income }
               Begin
                    DispJournals.Cells[12,DispJournals.Row] := '3';
                    If ( NOT NewListBox.CheckNom ( SOIncExp.Text, AccRange )) Or         // TGM AB 13/03/15 - blank AccRange forces recactive check
                       ( NomAccount = 0 ) Then Selected := false                         // TGM AB 13/03/15
                       else Selected := True;                                            // TGM AB 13/03/15
                    SOTypeLabel.Caption := 'S.Order Expenditure';                    
               End;
       End
     Else
         Begin
            // start TGM AB 13/03/15
            SOTypeLabel.Caption := 'Enterprise Transfer';
            AccRange[1] := Cash1.xNomIncFrom;
            AccRange[2] := Cash1.xNomIncTo;

            If ( NOT NewListBox.CheckNom ( SOIncExp.Text, AccRange )) Or
              ( NomAccount = 0 ) Then Selected := false
                  else Selected := True;
                  
            // end TGM AB 13/03/15
         End;

     If NOT Selected Then
        SOIncExp.SetFocus;
     Caption := SoTypeLabel.Caption;
end;

procedure TJournals.SOVATCodeExit(Sender: TObject);
begin
    if ( CodeChanged ) then
       SOVATCodeChange(Sender);
    PromptLine.Panels.Items[2].Text := '';    
end;

procedure TJournals.DeleteClick(Sender: TObject);
Var
   TempOffSet,
   ReWriteOffSet : Integer;
   MsgStr,
   TempStr : ShortString;
begin
     If WhichType = SOrders Then
        MsgStr := 'Standing Order'
     Else
        MsgStr := 'Enterprise Transfer';
     { Delete the Current Journal From CashBook.DEF }
     TempStr := DispJournals.Cells[10,DispJournals.Row];
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        If MessageDlg ( 'Delete this ' + MsgStr,mtinformation,[mbYes,mbNo],0) = mrYes Then
           Begin{ ReRead the current Journal }
              ReWriteOffSet := StrToInt ( TempStr );
              JnlRead ( ReWriteOffSet, TempOffSet );

              If TempOffSet In [1..6] Then
                Begin
                  FillChar ( Cash3.xJournal[TempOffSet], SizeOf ( Cash3.xJournal[TempOffSet] ), Chr(0));
                  JnlWrite ( ReWriteOffSet );
                End;
              { ReRead The Journals into the Grid }
              LoadJournals;
           End;
end;

procedure TJournals.AddClick(Sender: TObject);
Var
   FreeAccount,
   ACounter : Integer;
   TempStr  : ShortString;

   Function AnyInUse : Boolean;
   Var
      x        : Integer;
      FoundOne : Boolean;
   Begin
       AnyInUse := False;
       x := 1;
       Repeat
          FoundOne := ( JnlInUse[x] );
          Inc ( x );
       Until  ( x > 48 ) Or ( FoundOne );
       AnyInUse := FoundOne;
   End;

begin
     { Find Next Free Journal }
     ACounter := 1;
     FreeAccount := 0;

     If WhichType = SOrders Then
        JnlType.FJnlType.ShowModal
     Else
         { Set the Type to 4 for Enterprise Transfers }
         JnlType.FJnlType.JnlType := 4;

     If FJnlType.JnlType In [1..4] Then
        Repeat
           If ( NOT JnlInUse[ACounter] ) Then
              FreeAccount := ACounter;
           Inc ( ACounter );
        Until ( ACounter > 48 ) Or ( FreeAccount In[1..48] );

     If FreeAccount In [1..48] Then
        Begin
             {If AnyInUse Then}
             TempStr := DispJournals.Cells[2,DispJournals.RowCount-1];
             SlimAll ( TempStr );
             If Numeric ( TempStr ) Then
                DispJournals.RowCount := DispJournals.RowCount + 1;
             {
             TempStr := DispJournals.Cells[10,DispJournals.RowCount-1];
             SlimAll ( TempStr );
             If Numeric ( TempStr ) Then
                DispJournals.RowCount := DispJournals.RowCount + 1;
             }
             DispJournals.Row := DispJournals.RowCount-1;
             DispJournals.Cells[10, DispJournals.Row] := IntToStr ( FreeAccount );
             DispJournals.Cells[11, DispJournals.Row] := Cash11.Default_Date;
             DispJournals.Cells[12, DispJournals.Row] := IntToStr(FJnlType.JnlType);
//             SODate.Text := Cash11.Default_Date;
             TxDate.Text := Cash11.Default_Date;
             If WhichType = SOrders Then
                SOBank.Text := IntToStr ( Cash1.xLastBank );
             SOName.SetFocus;
             Delete.Enabled := True;
             Save.Enabled := True;
        End
     Else
        MessageDlg('No Free Accounts', mtInformation,[mbOK], 0);
end;

procedure TJournals.FormShow(Sender: TObject);
Var
   i : Integer;
begin
     Delete.Enabled := False;
     Save.Enabled := False;

     DateSearch.Date := KStrToDate (Cash11.Default_Date);
     { xType Of 2 = PROG of CASHINC }
     { xType Of 3 = PROG of CASHEXP }
     { xType Of 4 = PROG of JOURNAL }
     Exitbtn.Caption := ReadLang ( 1, CurrLang );
     GridRowPos := -1;
     WritePanel.Enabled := False;
     WriteTxButton.Enabled := False;
     If WhichType = EntTrans Then
        Begin
             SONameLabel.Caption := 'Transfer Name';
             SOBankLabel.Caption := 'Account To';
             SOIncExpLabel.Caption := 'Account From';
             Quantity.Show;
             QtyLabel.Show;
             SOVatAmount.Hide;
             VATCodeLabel.Hide;
             AnalysisLabel.Hide;
             VATAmtLabel.Hide;
             SOVATCode.Hide;
             SOAnalysis.Hide;
             VatBtn.Hide;
             AnalysisBtn.Hide;
             ExpenditureLabel.Hide;
        End
     Else
        Begin
             SONameLabel.Caption := 'Standing Order Name';
             SOBankLabel.Caption := 'Bank';
             SOIncExpLabel.Caption := 'Income/';
             ExpenditureLabel.Show;
             ExpenditureLabel.Caption := 'Expenditure';
             VATCodeLabel.Show;
             SOVatAmount.Show;
             AnalysisLabel.Show;
             VATAmtLabel.Show;
             SOVATCode.Show;
             SOAnalysis.Show;
             Quantity.Hide;
             QtyLabel.Hide;
             VatBtn.Show;
             AnalysisBtn.Show;
        End;

     For i := 0 To ComponentCount-1 Do
         If Components[i] is TEdit Then
            TEdit(Components[i]).Text := '';

     PROG := 0{JOURNAL};
     ACT  := 0{10};
     LoadJournals;
end;

procedure TJournals.WriteTxButtonClick(Sender: TObject);
begin
     if cash1.xyearend = true then begin
        if messagedlg('You are making changes to an archive set of accounts, are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrno then exit;
     end;

     If GridRowPos = -1 Then
        SetNextRec;

     If DispJournals.Cells[0,GridRowPos] = 'X' Then
       If MessageDlg('OK to Write Transaction', mtConfirmation,[mbYes,mbNo], 0) = mrYes Then
         Begin
           InitVals;
           PROG := 0;
           ACT := 1;
           If StrToInt ( DispJournals.Cells[12, GridRowPos] ) = 2 Then
              PROG := CASHINC
           Else
               If StrToInt ( DispJournals.Cells[12, GridRowPos] ) = 3 Then
                  PROG := CASHEXP
               Else
                   If StrToInt ( DispJournals.Cells[12, GridRowPos] ) = 4 Then
                      Begin
                         PROG := JOURNAL;
                         Act := 6;
                      End;
           If MoveTxInfo And ( Prog <> 0 ) Then
              WriteTransactions(1,NLFile,0,TRUE);
           DispJournals.Cells[0, GridRowPos] := ' ';
           SetNextRec;

	   // TGM AB 07/07/05 - fixes bug with default date not always being set to the last saved transaction date

           try  cash1.XDATE := TxDate.Text;
                defwrite (0);
           except
           end;

         End;
end;

procedure TJournals.GetNextRec;
Var
   FoundRec : Boolean;
begin
     FoundRec := False;
     Repeat
        Inc ( GridRowPos );
        If Numeric ( DispJournals.Cells[2, GridRowPos] ) And
           Numeric ( DispJournals.Cells[3, GridRowPos] ) Then
           If ( DispJournals.Cells[0, GridRowPos] = 'X' ) Then
             Begin
               { Set the row }
               DispJournals.Row := GridRowPos;
               { Paint the top of the Screen with ROW Info. }
               FillTopOfScreen;
               FoundRec := True;
             End;
     Until ( GridRowPos >= DispJournals.RowCount ) Or FoundRec;
     CheckWriteOk;
end;

procedure TJournals.SetNextRec;
begin
     GetNextRec;
     If ( GridRowPos >= DispJournals.RowCount ) Then
        Begin
             DispJournals.Row := 0;
             GridRowPos := -1;
             GetNextRec;
        End;
end;

procedure TJournals.NextButtonClick(Sender: TObject);
begin
     SetNextRec;
end;

procedure TJournals.SOIncExpClick(Sender: TObject);
Var
   AccRange : TAccRange;
   TestStr  : ShortString;
begin
     If WhichType = EntTrans Then
        Begin
           InitRange ( AccRange );                 // TGM AB 13/03/15
           AccRange[1] := Cash1.xNomIncFrom;       // TGM AB 13/03/15
           AccRange[2] := Cash1.xNomIncTo;         // TGM AB 13/03/15

           TestStr := SOIncExp.Text;
           SlimAll ( TestStr );
           If ( NOT NewListBox.CheckNom ( SOIncExp.Text, AccRange )) Or
              ( Length ( TestStr ) = 0 ) or (CheckNomEqualsZero(TestStr)) Then        // TGM AB 24/04/15
              SOIncExp.SetFocus;
        End;
end;

procedure TJournals.QuantityExit(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := Quantity.Text;
     SlimAll ( TempStr );
     If Length ( TempStr ) > 0 Then
        If NOT ChangeToLong ( TempStr ) Then
           Quantity.SetFocus
        Else
           Quantity.Text := TempStr;
end;

procedure TJournals.SOAnalysisKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_F2 Then    { F2 Pressed }
       Begin
            NewListBox.ListIt ( Sender, Analysis, 'A' );
            If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
               SOAnalysis.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TJournals.BankSearchClick(Sender: TObject);
begin
     BankNameLabel.Caption := '';
     if WhichType = SOrders Then
        NewListBox.ListIt ( Sender, Banks, 'N' )
     Else
        NewListBox.ListIt ( Sender, EntAllExpend, 'I' );
        If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
           SOBank.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TJournals.IncExpBtnClick(Sender: TObject);
begin
         If WhichType = SOrders Then
            NewListBox.ListIt ( Sender, AllNomsXBank, 'N' )
         Else
            NewListBox.ListIt ( Sender, EntAllIncome, 'I' );
         If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            SOIncExp.Text := NewListBox.ListInfo.ReturnValue;
         SOIncExp.SetFocus;
end;

procedure TJournals.VATBtnClick(Sender: TObject);
begin
             NewListBox.ListIt ( Sender, Vat, 'V' );
             If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
                SOVATCode.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TJournals.AnalysisBtnClick(Sender: TObject);
begin
   { NewListBox.ListIt ( Sender, Analysis, 'A' );
    If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
       SOAnalysis.Text := NewListBox.ListInfo.ReturnValue;}
    if not bool(SetupAnalysisForm) then Application.CreateForm(TSetupAnalysisForm, SetupAnalysisForm);
    SetupAnalysisForm.ShowWindow(1);
    SOAnalysis.Text := Setupanalysisform.selectedcode;
end;

procedure TJournals.SONameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
{  If Key = VK_F1 then
       Begin
            If Whichtype = SOrders Then
               Application.HelpContext(146)
            Else
               Application.HelpContext(1);
       end;}
end;

procedure TJournals.FormActivate(Sender: TObject);
begin
     BankNameLabel.Caption := '';
     SOTypeLabel.Caption := '';
     If ( WhichType = SOrders ) Then
        SOBank.Text := IntToStr ( Cash1.xLastBank );
     {
     Else
         SOBank.Text := '';
     }
end;

procedure TJournals.SOBankDblClick(Sender: TObject);
begin
     If WhichType = SOrders Then
        NewListBox.ListIt ( Sender, Banks, 'N' )
     Else
        NewListBox.ListIt ( Sender, EntAllExpend, 'I' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        SOBank.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TJournals.SOIncExpDblClick(Sender: TObject);
begin
     If WhichType = SOrders Then
        NewListBox.ListIt ( Sender, AllNomsXBank, 'N' )
     Else
        NewListBox.ListIt ( Sender, EntAllIncome, 'I' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        SOIncExp.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TJournals.SOVATCodeDblClick(Sender: TObject);
begin
             NewListBox.ListIt ( Sender, Vat, 'V' );
             If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
                SOVATCode.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TJournals.DateSearchCloseUp(Sender: TObject);
begin
     TxDate.Text:= DateToStr(DateSearch.Date);
     TxDate.SetFocus;
end;

procedure TJournals.DateSearchDropDown(Sender: TObject);
begin
{        DateSearch.Date := StrToDate (TxDate.Text );}
end;

procedure TJournals.TxDateEnter(Sender: TObject);
begin
     PromptLine.Panels.Items[1].Text := 'Click The Down Arrow Button To Use The Calendar';
end;

procedure TJournals.TxDateExit(Sender: TObject);
Var
   TestDate : ShortString;
   DateBefore : Boolean;
begin
     TestDate := TxDate.Text;
     If NOT DateValid ( TxDate.Text, TDateFormat ) Then
        TxDate.SetFocus
     Else If NOT CheckDateRange ( TestDate, True, DateBefore, True ) Then
          Begin
               TxDate.Text := TestDate;
               TxDate.SetFocus;
          End;
     PromptLine.Panels.Items[1].Text := '';          
end;

procedure TJournals.SOAmountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Cash2.XCOUNTRY = 2 Then
        If Key = VK_F5 then
           ( Sender as TEdit).Text := EuroConvert( (Sender as TEdit).Text );
end;

procedure TJournals.SOVATAmountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Cash2.XCOUNTRY = 2 Then
        If Key = VK_F5 then
           ( Sender as TEdit).Text := EuroConvert( (Sender as TEdit).Text );
end;

procedure TJournals.QuantityKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Cash2.XCOUNTRY = 2 Then
        If Key = VK_F5 then
           ( Sender as TEdit).Text := EuroConvert( (Sender as TEdit).Text );
end;

procedure TJournals.HelpClick(Sender: TObject);
begin
     If ( WhichType = SOrders ) Then
        Application.HelpContext(92)            //Standing orders
     Else
          Application.HelpContext(201);        //enterprise transfers
end;

procedure TJournals.SOBankEnter(Sender: TObject);
begin
     PromptLine.Panels.Items[1].Text := 'Press F2 or Double Click to List Accounts';
end;

procedure TJournals.SOAnalysisExit(Sender: TObject);
begin
     PromptLine.Panels.Items[1].Text := '';
end;

procedure TJournals.SONameEnter(Sender: TObject);
begin
     PromptLine.Panels.Items[1].Text := '';
end;

procedure TJournals.SOReferenceEnter(Sender: TObject);
begin
     PromptLine.Panels.Items[1].Text := '';
end;

procedure TJournals.SOAmountEnter(Sender: TObject);
begin
     PromptLine.Panels.Items[1].Text := '';
end;

procedure TJournals.SODescriptionEnter(Sender: TObject);
begin
     PromptLine.Panels.Items[1].Text := '';
end;

procedure TJournals.QuantityEnter(Sender: TObject);
begin
     PromptLine.Panels.Items[1].Text := '';
end;

procedure TJournals.DispJournalsEnter(Sender: TObject);
begin
     PromptLine.Panels.Items[1].Text := '';
end;

procedure TJournals.SOAmountChange(Sender: TObject);
begin
    AmtChanged := TRUE;
end;

procedure TJournals.FormCreate(Sender: TObject);
begin
    DispJournals.ColWidths[DispJournals.ColCount-1] := 0;
    DispJournals.ColWidths[DispJournals.ColCount-2] := 0;
    DispJournals.ColWidths[DispJournals.ColCount-3] := 0;
    DispJournals.ColWidths[DispJournals.ColCount-4] := 0;
end;

end.
