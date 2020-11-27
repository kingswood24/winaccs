{
   23/11/18 [V4.3 R2.9] /MK Change - Changed Bank Statement Import button from RXButtong to CXButton to allow for drop-down-menu button type.
                                   - Drop-down-menu allows Ledger users to specify the default location of bank link files for auto import.
}

unit Bankact;
{ PROG             ACT
  JOURNAL           1        = Direct Debits
  JOURNAL           2        = Direct Credits
  JOURNAL           5        = Inter Bank Transfers
}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, ComCtrls, Mask,
  FullAudit, RXCtrls, UBankSetup, cxButtons, Menus, uBankFileSelectorSettings;

type
  TBankActivities = class(TForm)
    Panel1: TPanel;
    OtherTxGrid: TStringGrid;
    Exitbtn: TBitBtn;
    Save: TBitBtn;
    BankTxGroup: TGroupBox;
    DDebitRadio: TRadioButton;
    DCreditRadio: TRadioButton;
    Label1: TLabel;
    Label2: TLabel;
    OtherAmount: TEdit;
    OtherDescription: TEdit;
    OtherPanel: TPanel;
    InterBankRadio: TRadioButton;
    StubNo: TEdit;
    Label4: TLabel;
    JournalRadio: TRadioButton;
    WhichOption: TGroupBox;
    BankTxRadio: TRadioButton;
    LoanTxRadio: TRadioButton;
    LoanTxGroup: TGroupBox;
    BankLoanRadio: TRadioButton;
    HirePRadio: TRadioButton;
    LeaseRadio: TRadioButton;
    RepayRadio: TRadioButton;
    InterestRadio: TRadioButton;
    OthersPanel: TPanel;
    BankNameLabel: TLabel;
    BankAccountLabel: TLabel;
    OtherAccountLabel: TLabel;
    OtherAccountNameLabel: TLabel;
    BankAccount: TEdit;
    OtherAccount: TEdit;
    DateLabel: TLabel;
    ReferenceLabel: TLabel;
    BankBalanceLabel: TLabel;
    Reference: TEdit;
    BankBalance: TEdit;
    HpSetupPanel: TPanel;
    SupplierNo: TEdit;
    Comment: TEdit;
    SupplierLabel: TLabel;
    CommentLabel: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    HpReference: TEdit;
    Account: TEdit;
    AccountLabel: TLabel;
    HpSetUpAmtPanel: TPanel;
    HpAmount: TEdit;
    HpDiscount: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    StandingOrderRadio: TRadioButton;
    ListAccounts: TSpeedButton;
    OtherF2: TSpeedButton;
    SupplierF2: TSpeedButton;
    BankRecRadio: TRadioButton;
    TxDate: TMaskEdit;
    DateSearch: TDateTimePicker;
    TxHPDate: TMaskEdit;
    SuppDateSearch: TDateTimePicker;
    SpeedButton1: TSpeedButton;
    Help: TBitBtn;
    PromptLine: TStatusBar;
    ImportPanel: TPanel;
    SetupBanksBtn: TRxSpeedButton;
    HPSetupLabel: TLabel;
    btnBankImport: TcxButton;
    pmBankFileOptions: TPopupMenu;
    mi: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure OtherTxGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure OtherTxGridGetEditMask(Sender: TObject; ACol, ARow: Longint;
      var Value: OpenString);
    procedure OtherTxGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BankAccountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OtherTxGridSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure OtherTxGridSetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: String);
    procedure SaveClick(Sender: TObject);
    procedure DDebitRadioClick(Sender: TObject);
    procedure DCreditRadioClick(Sender: TObject);
    procedure ExitbtnClick(Sender: TObject);
    procedure BankAccountExit(Sender: TObject);
    procedure OtherAccountExit(Sender: TObject);
    procedure OtherAccountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure InterBankRadioClick(Sender: TObject);
    procedure OtherAmountExit(Sender: TObject);
    procedure JournalRadioClick(Sender: TObject);
    procedure BankTxRadioClick(Sender: TObject);
    procedure BankLoanRadioClick(Sender: TObject);
    procedure LoanTxRadioClick(Sender: TObject);
    procedure HirePRadioClick(Sender: TObject);
    procedure LeaseRadioClick(Sender: TObject);
    procedure RepayRadioClick(Sender: TObject);
    procedure InterestRadioClick(Sender: TObject);
    procedure AccountExit(Sender: TObject);
    procedure AccountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SupplierNoExit(Sender: TObject);
    procedure SupplierNoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HpAmountExit(Sender: TObject);
    procedure HpDiscountExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StandingOrderRadioMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ListAccountsClick(Sender: TObject);
    procedure SupplierF2Click(Sender: TObject);
    procedure OtherF2Click(Sender: TObject);
    procedure OtherTxGridDblClick(Sender: TObject);
    procedure BankRecRadioMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TxDateEnter(Sender: TObject);
    procedure TxDateExit(Sender: TObject);
    procedure DateSearchCloseUp(Sender: TObject);
    procedure SuppDateSearchCloseUp(Sender: TObject);
    procedure DateSearchDropDown(Sender: TObject);
    procedure SuppDateSearchDropDown(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HpAmountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HpDiscountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BankBalanceKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure OtherAmountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HelpClick(Sender: TObject);
    procedure OtherTxGridClick(Sender: TObject);
    procedure OtherTxGridExit(Sender: TObject);
    procedure BankAccountEnter(Sender: TObject);
    procedure UnCheckAll(Sender: TObject);
    procedure SetupBanksBtnClick(Sender: TObject);
    procedure btnBankImportClick(Sender: TObject);
    procedure miClick(Sender: TObject);
  private
    { Private declarations }
    Procedure ReBuildScreen;
    { Setup the screen as radio buttons are checked and unchecked }
    Procedure SetUpScreen(Prog, Act : Integer; SpecialCase : Char );
  public
    { Public declarations }
    CellSize : Packed Array [0..2] Of Integer;
    SalesPurchDB,
    CurrTrans : Integer;
    JournalType : Boolean;
//    Procedure EuroCalcBank;
  end;

var
  BankActivities: TBankActivities;
  NegitiveValue : Boolean;
  LastCol,
  LastRow     : Integer;

implementation
Uses
    pickdate,
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
    DefSecFl,
    uBankCSVimport, uBankImport, AccsData;

Const
     BadBankFrom = 63;
     BadBankTo   = 64;
     OtherGridWidth = 324;

{$R *.DFM}

Procedure TBankActivities.ReBuildScreen;
Var
   TempStr   : ShortString;
   ItemCount,
   NoOfItems : Integer;
Begin
     { Hide all the Panels from user }
     WhichOption.Hide;
     BankTxGroup.Hide;
     JournalRadio.Checked := True;
     {
     BankAccount.Text := IntToStr ( zbank[1] );
     }
     KDateToStr ( zTxDate[1], TempStr  );
//     Date.Text := TempStr;
     TxDate.Text := TempStr;
     Reference.Text := zRef[1];
     {
     Comment.Text := zComm[1];
     Str ( zStub[1], Tempstr );
     PadZero ( TempStr, 8 );
     StubNo.Text := TempStr;
     }
     NoOfItems := 0;
     For ItemCount := 1 To 10 Do
         Begin
              If ( zDb[1,ItemCount] <> 0 ) And ( zCr[1,ItemCount] <> 0 ) Then
                 Begin
                      Inc ( NoOfItems );
                      OtherTxGrid.Cells[0,NoOfItems] := IntToStr ( zDb[1,ItemCount] );
                      OtherTxGrid.Cells[1,NoOfItems] := IntToStr ( zCr[1,ItemCount] );
                      LongStr ( zAmt[1,NoOfItems], TempStr, 'L' );
                      OtherTxGrid.Cells[2,NoOfItems] := TempStr;
                      OtherTxGrid.Cells[3,NoOfItems] := zdesc[1,ItemCount];
                 End;
         End;
     OtherTxGrid.RowCount := NoOfItems+1;
End;

Function MoveTxInfo ( Var Col, Row : LongInt ) : Boolean;
Var
   NomsDifferent,       // TRUE if Nominal Accounts for Journals are Different
   Nominal,
   SecondNominal,
   Amount,
   Dummy,
   CorrectEntry : Boolean;
   GridPosOk    : Packed Array [1..10] Of Boolean;
   LineOk,
   LastLine,
   LineCount : Integer;
   TestStr   : ShortString;
Begin

     If NOT GEditing Then
        InitVals;

     For LineCount := 1 To 10 Do
        GridPosOk[Linecount] := False;

{-->>     MoveTxInfo := True;}
     CorrectEntry := True;
     Col := 0;
     Row := 0;
     LastLine := -1;

     LineCount := 1;

     If NOT ( Act In [3,4,5] ) Then
        While ( LineCount <= 10 ) And ( CorrectEntry ) Do        
           Begin
              Nominal := True;
              Amount := True;
              SecondNominal := True;
              NomsDifferent := TRUE;

              If TestGridCell ( BankActivities.OtherTxGrid.Cells[0, LineCount] ) Then
                 Begin
                      { Only set if col hasn;t been Changed previously }
                      if Col = 0 Then
                         Begin
                              Col := 0;
                              Row := LineCount;
                         End;
                      Nominal := False;
                 End;
              If TestGridCell ( BankActivities.OtherTxGrid.Cells[1, LineCount] ) Then
                 Begin
                      { Only set if col hasn;t been Changed previously }
                      If Col = 0 Then
                         Begin
                              Col := 1;
                              Row := LineCount;
                         End;
                      if BankActivities.JournalRadio.Checked Or
                         BankActivities.LeaseRadio.Checked Or
                         BankActivities.InterestRadio.Checked Then
                         begin
                            SecondNominal := False;
                            NomsDifferent := FALSE;
                         end
                      else
                         begin
                            Amount := False;
                            SecondNominal := False;
                            NomsDifferent := FALSE;
                         end;
                 End
              else // Check the 2 Accounts are not the SAME
                 if ( BankActivities.JournalRadio.Checked ) And ( Col = 0 ) Then
                    if ( BankActivities.OtherTxGrid.Cells[0, LineCount] =
                         BankActivities.OtherTxGrid.Cells[1, LineCount] ) then
                       begin
                          Col := 0;
                          Row := LineCount;
                          NomsDifferent := FALSE;
                       end;

              If BankActivities.JournalRadio.Checked Or
                 BankActivities.LeaseRadio.Checked Or
                 BankActivities.InterestRadio.Checked Or
                 GEditing Then
                 If TestGridCell ( BankActivities.OtherTxGrid.Cells[2, LineCount] ) Then
                    Begin
                         { Only set if col hasn;t been Changed previously }
                         If Col = 0 Then
                            Begin
                                 Col := 2;
                                 Row := LineCount;
                            End;
                         Amount := False;
                    End;

              If ( LineCount > 1 ) And
                 ( NOT Nominal ) And ( NOT Amount ) And
                 ( NOT SecondNominal ) And
                 ( NOT NomsDifferent ) Then  { Line not in use }
                 Begin
                    If LastLine = -1 Then
                       LastLine := LineCount-1;
                    CorrectEntry := True;
                    GridPosOk[LineCount] := False;
                 End
              Else
                  Begin
                       CorrectEntry := ( Nominal ) And ( Amount ) And
                                       ( SecondNominal ) And ( NomsDifferent ) ;
                       GridPosOk[LineCount] := True;
                  End;

              Inc ( LineCount );
           End
     Else
         Begin
            If ( Prog <> PurchTx ) Then
              Case Act Of
                 5  : Begin { Inter Bank Transfers }
                           Try
                              zbank[1] := StrToInt ( BankActivities.BankAccount.Text );
                           Except
                              CorrectEntry := False;
                              Col := BadBankFrom;
                           End;
                           If CorrectEntry Then
                              Try
                                 zbank2[1] := StrToInt ( BankActivities.OtherAccount.Text );
                              Except
                                    CorrectEntry := False;
                                    Col := BadBankTo;
                              End;
                           If CorrectEntry Then
                              Begin
                                   CorrectEntry := ( zBank[1] <> zBank2[1] );
                                   If CorrectEntry Then
                                      Begin
                                           StrLong ( BankActivities.StubNo.Text, ZStub[1] );
                                           ZDesc[1,1] := BankActivities.OtherDescription.Text;
                                           StrLong ( BankActivities.OtherAmount.Text, ZAmt[1,1] );
                                           zUse[1,1] := True;
                                      End
                                   Else
                                       Col := 2; { Banks are the Same }
                              End;
                      End;
              End;
         End;

     If CorrectEntry Then     { Check Date }
        Begin
             If ( Prog = PurchTx ) And ( Act = 3 ) Then
                Begin
//                     TestStr := BankActivities.HpDate.Text;
                     TestStr := BankActivities.TxHpDate.Text;
                     SlimAll ( TestStr );
                     If Length ( TestStr ) > 0 Then
                        If NOT DateValid ( TestStr, TDateFormat ) Then
                           BankActivities.TxHpDate.SetFocus;
                End
             Else
                Begin
//                     TestStr := BankActivities.Date.Text;
                     TestStr := BankActivities.TxDate.Text;
                     SlimAll ( TestStr );
                     If Length ( TestStr ) > 0 Then
                        If NOT DateValid ( TestStr, TDateFormat ) Then
                           BankActivities.TxDate.SetFocus;
                End;
        End;

     If CorrectEntry Then
        Begin
             If ( Prog = PurchTx ) And ( Act = 3 ) Then
                Begin
                     zComm[1] := BankActivities.Comment.Text;
                     zRef[1] := BankActivities.HPReference.Text;
//                     zTxDate[1] := KDateToInt ( BankActivities.HPDate.Text );
                     zTxDate[1] := KDateToInt ( BankActivities.TxHPDate.Text );
                     zbank[1] := StrToInt ( BankActivities.Account.Text );
                     zAccount[1] := StrToInt ( BankActivities.SupplierNo.Text );
                     zCustRec[1] := zAccount[1];
                     StrLong ( BankActivities.HPDiscount.text, zDiscount[1] );
                     StrLong ( BankActivities.HpAmount.text, zAmt[1,1] );
                End
             Else
                Begin
                     zRef[1] := BankActivities.Reference.Text;
//                     zTxDate[1] := KDateToInt ( BankActivities.Date.Text );
                     zTxDate[1] := KDateToInt ( BankActivities.TxDate.Text );
                End;

             If PROG In [CASHINC,CASHEXP] Then
                Begin
                   TestStr := BankActivities.BankAccount.Text;
                   SlimAll ( TestStr );
                   ZAccount[1] := StrToInt ( TestStr );
                   ZBank[1] := ZAccount[1];
(*
                   If ACT = 3 Then { Receipt or PAyment }
                      Begin
                           StrLong ( OthForm.StubNo.text, zStub[1] );
                           StrLong ( OthForm.Discount.text, zDiscount[1] );
                           StrLong ( OthForm.AmtReceived.text, zAmt[1,1] );
                      End;
*)
                End;

             LineOK := 0;
             If NOT ( Act In [3,4,5] ) Then
                For LineCount := 1 To 10 Do
                  If GridPosOK[LineCount] Then
                    Begin
                      Inc ( LineOK );
                      zUse[1,LineOK] := True;
                      TestStr := BankActivities.OtherTxGrid.Cells[0, LineCount];
                      SlimAll ( TestStr );
                      If Act = 6 Then { Simple Journal }
                         Begin
                               TestStr := BankActivities.OtherTxGrid.Cells[0, LineCount];
                               SlimAll ( TestStr );
                               zdb[1,lineOK] := StrToInt ( TestStr );
                               TestStr := BankActivities.OtherTxGrid.Cells[1, LineCount];
                               SlimAll ( TestStr );
                               zcr[1,lineOK] := StrToInt ( TestStr );
                               ZDesc[1,LineOK] := BankActivities.OtherTxGrid.Cells[3, LineCount];

                               TestStr := BankActivities.OtherTxGrid.Cells[2, LineCount];
                               SlimAll ( TestStr );
                               Dummy := ChangeToLong ( TestStr );
                               StrLong ( TestStr, ZAmt[1,LineOK] );
                         End
                      Else
                          Begin
                               ZGen[1,LineOK] := StrToInt ( TestStr );
                               ZDesc[1,LineOK] := BankActivities.OtherTxGrid.Cells[2, LineCount];

                               TestStr := BankActivities.OtherTxGrid.Cells[1, LineCount];
                               SlimAll ( TestStr );
                               Dummy := ChangeToLong ( TestStr );
                               StrLong ( TestStr, ZAmt[1,LineOK] );
                          End;
                    End;
             { Direct Debit Or Credit }
             If ( Prog = Journal ) And ( Act In [1,2] ) Then
                Begin
                     TestStr := BankActivities.BankAccount.Text;
                     SlimAll ( TestStr );
                     Try
                        zbank[1] := StrToInt ( TestStr );
                     Except
                           CorrectEntry := False;
                           Col := BadBankFrom;
                     End;
                     {ZBank[1] := StrToInt ( TestStr );}
                End;
             CheckEnd;
        End;

     {Else}
     MoveTxInfo := CorrectEntry;
End;

Function SetRanges ( Range : TRange ) : TAccRange;
Begin
     SetRanges[1] := 0;
     SetRanges[2] := 0;
     SetRanges[3] := 0;
     SetRanges[4] := 0;
     SetRanges[5] := 0;
     SetRanges[6] := 0;
     If ( Range = AllNoms ) Then
        Begin
             SetRanges[1] := 1;
             SetRanges[2] := Cash1.xNomPrvExp+Cash11.xNo_Of_Partners;
        End
     Else If ( Range = Liab ) Then
        Begin
             SetRanges[1] := Cash1.xNomLiFrom;
             SetRanges[2] := Cash1.xNomLiTo;
        End
     Else If ( Range = Banks ) Then
        Begin
             SetRanges[1] := Cash1.xBankMin;
             SetRanges[2] := Cash1.xBankMax;
        End
     Else If ( Range = FAsset ) Then
        Begin
             SetRanges[1] := Cash1.xNomFaFrom;
             SetRanges[2] := Cash1.xNomFaTo;
        End
     Else If ( Range = CAsset ) Then
        Begin
             SetRanges[1] := Cash1.xNomCaFrom;
             SetRanges[2] := Cash1.xNomCaTo;
        End
     Else If ( Range = OverHeads ) Then
        Begin
             {
             SetRanges[1] := Cash1.xNomExpFrom;
             SetRanges[2] := Cash1.xNomExpTo;
             }
             SetRanges[1] := Cash1.xNomOhFrom;
             SetRanges[2] := Cash1.xNomOhTo;
        End
     Else If ( Range = OverHeadsWithExpense ) Then
        Begin
             SetRanges[1] := Cash1.xNomExpFrom;
             SetRanges[2] := Cash1.xNomExpTo;
             SetRanges[3] := Cash1.xNomOhFrom;
             SetRanges[4] := Cash1.xNomOhTo;
        End
     Else If ( Range = AllNomsPlusCapitalLessControl ) Then
        Begin
             SetDb ( NlFile );
             SetRanges[1] := 1;
             SetRanges[2] := cash1.XNOMDEBTOR-1;
             SetRanges[3] := cash1.XNOMCREDIT+1;
             SetRanges[4] := DB1.DBRECTOT;
             SetRanges[5] := 0;
             SetRanges[6] := 0;
        End;
End;

Procedure NegitiveFlag ( NomAccount : Integer; Col, Row : LongInt );
Var
   TestStr : ShortString;
   Neg : Boolean;
Begin
   Neg := False;
   IF (PROG IN [CASHINC,CASHEXP,SALESTX,PURCHTX]) AND
     (( NomAccount >= Cash1.XNOMPRVINC ) AND
      ( NomAccount <= Cash1.XNOMPRVEXP+Cash11.xno_of_partners )) THEN
      BEGIN
         CASE PROG OF
            CASHINC,SALESTX : NEG:=(( NomAccount >=Cash1.XNOMPRVEXP) And
			     ( NomAccount <=Cash1.xnomprvexp+Cash11.xno_of_partners ));
            CASHEXP,PURCHTX : NEG:=(( NomAccount >=Cash1.XNOMPRVINC) And
			     ( NomAccount <=Cash1.xnomprvinc+Cash11.xno_of_partners ));
         END;
      END
   ELSE
      NEG:= (( PROG IN [CASHINC,SALESTX] ) AND
            (( NomAccount < Cash1.XNOMINCFROM ) OR
             ( NomAccount > Cash1.XNOMNONTO )) AND
            (( NomAccount > Cash1.XNOMEXPFROM-1 ) AND
             ( NomAccount < Cash1.XNOMOHTO+1 )) ) OR

            (( PROG IN [CASHEXP,PURCHTX] ) AND
            (( NomAccount < Cash1.XNOMEXPFROM ) OR
             ( NomAccount > Cash1.XNOMOHTO )) AND
	    (( NomAccount > Cash1.XNOMINCFROM-1 ) AND
	     ( NomAccount < Cash1.XNOMNONTO+1 )));

   If NEG Then
      Begin
           TestStr := BankActivities.OTherTxGrid.Cells[1, Row];
           SlimAll ( TestStr );
           If ( Pos ( '-', TestStr ) = 0 ) Then
              BankActivities.OtherTxGrid.Cells[1, Row] := TestStr + '-';
      End;
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
{-->>     CheckNom := False;}
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
                          ( NomAccount <= AccRange[4] )) Or
                         (( NomAccount >= AccRange[5] ) And
                          ( NomAccount <= AccRange[6] ))); 

             If NominalOK Then
                NegitiveFlag ( NomAccount, Col, Row );
        End
     Else
         If Length ( NomCode ) = 0 Then
            NominalOK := True;
     CheckNom := NominalOK;
End;


procedure TBankActivities.FormActivate(Sender: TObject);
Var
   NoPresented : Boolean;
   PCount : Integer;
Begin
     Caption := 'Bank Activities';{ + ' - ' + st;}
     BankActivities.DDebitRadio.Checked := True;
     SalesPurchDb := 0;
     CurrTrans    := 0;
     //FMainScreen.Hide;
     WhichOption.Show;

     {Mask.DefaultBlank := ' ';}
{     Mask.MaskNoSave := '0';    }
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
     BankActivities.Exitbtn.Caption := ReadLang ( 1, CurrLang );
     BankActivities.Save.Caption := ReadLang ( 26, CurrLang );
     BankActivities.BankAccount.Hint := ReadLang ( 140, CurrLang );
     BankActivities.OtherAccount.Hint := BankActivities.BankAccount.Hint;
     BankActivities.ListAccounts.Hint := ReadLang ( 141, CurrLang );

     // Cashbook CSV Import Button

  //   if (cash1.Xcashbook = true) then importpanel.Visible := true
  //      else importpanel.Visible := false;

     if Gediting then importpanel.Visible := false
        else importpanel.Visible := true;

     OtherTxGrid.RowCount := 11;
     OtherTxGrid.FixedRows := 1;

     With OtherTxGrid Do
         Begin
              Cells[0,0] := ReadLang ( 28, CurrLang ); { Ents }
              Cells[1,0] := ReadLang ( 31, CurrLang ); { Nom }
              Cells[2,0] := ReadLang ( 29, CurrLang ); { Description }
              CellSize[0] := 40;
              CellSize[1] := 70;
              CellSize[2] := 206;
              For PCount := 0 To 2 Do
                  ColWidths[PCount] := Cellsize[PCount];

         End;
     BankAccount.Text := IntToStr ( Cash1.xLastBank );
     TxDate.Text := Cash11.Default_Date;{xDate;}
     TxHpDate.Text := Cash11.Default_Date;{xDate}

     if TxEditRec.TransF > 0 then
        begin
           // Set Temp Bool to TRUE
           NoPresented := TRUE;
           // If the Button hasn't already been disabled - Load Transaction
           // TEST result for Presented cheques
           if Save.Enabled then
              begin
                 NoPresented := LoadTrans;  // Load the Info
                 Save.Enabled := NoPresented;
              end
           else
              LoadTrans;  // Load the Info
           ReBuildScreen;
           SetUpScreen (Prog, Act, ' ' );
           if NOT NoPresented then
                ShowMessage('This Transaction is Presented' + #13 +
                            'You have to UnPresent it before editing');
        end;

     if JournalType then begin
          JournalRadioClick(self);
          JournalType := False;
     end

end;

procedure TBankActivities.FormDeactivate(Sender: TObject);
Var
   PCount : Integer;
begin
   if not JournalType then begin

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
 //    FMainScreen.Visible := True;

   end;
end;

procedure TBankActivities.OtherTxGridDrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
Var
   AccRange : TAccRange;

begin
     If ( NOT GEditIng ) And ( Row > 0 ) Then
        Begin
             Case Col Of
               0 : Begin
                     { Set the range for F2 to Liabilities if using Loans }
                     if ( LoanTxRadio.Checked ) and (( BankLoanRadio.Checked ) Or ( RePayRadio.Checked )) Then
                        AccRange := SetRanges ( Liab )
                     else if ( LoanTxRadio.Checked ) and ( LeaseRadio.Checked ) then
                        AccRange := SetRanges ( FAsset )
                     else if ( LoanTxRadio.Checked ) And ( InterestRadio.Checked ) then
                        AccRange := SetRanges ( OverHeadsWithExpense )
                     else if JournalRadio.Checked then
                        AccRange := SetRanges ( AllNomsPlusCapitalLessControl )
                     else
                        AccRange := SetRanges ( AllNoms );

                     If NOT CheckNom ( OtherTxGrid.Cells[Col,Row], Col, Row, AccRange ) or (CheckNomEqualsZero(OtherTxGrid.Cells[Col,Row])) Then  //TGM AB 24/04/15
                        Begin
                           OtherTxGrid.Col := Col;
                           OtherTxGrid.Row := Row;
                        End;
                     // check the enter Account and the Bank Account are NOT the SAME
                     if ( ACT In [1,2] ) And ( PROG = 15 ) And
                        ( Length ( OtherTxGrid.Cells[Col,Row] ) > 0 ) And
                        ( Length ( BankAccount.Text ) > 0 ) then
                        if ( OtherTxGrid.Cells[Col,Row] = BankAccount.Text ) then
                           begin
                              MessageDLG('Bank and Nom. Account cannot be the same',mtWarning,[mbOK],0);
                              OtherTxGrid.Col := Col;
                              OtherTxGrid.Row := Row;
                           end;
                   end;
               1 : if JournalRadio.Checked Or
                      LeaseRadio.Checked Or
                      InterestRadio.Checked Or
                      GEditing then
                      begin
                           if ( BankTxRadio.Checked ) And ( NOT JournalRadio.Checked ) then
                              AccRange := SetRanges ( AllNoms )
                           else if ( BankTxRadio.Checked ) And ( JournalRadio.Checked ) then
                              AccRange := SetRanges ( AllNomsPlusCapitalLessControl )
                           else
                              AccRange := SetRanges ( Liab );
                           {
                           if LeaseRadio.Checked = True then
                              AccRange := SetRanges ( Liab )
                           else if JournalRadio.Checked then
                              AccRange := SetRanges ( AllNomsPlusCapital )
                           else
                              AccRange := SetRanges ( AllNoms );
                           }
                           if NOT CheckNom ( OtherTxGrid.Cells[Col,Row], Col, Row, AccRange ) or (CheckNomEqualsZero(OtherTxGrid.Cells[Col,Row])) Then  //TGM AB 24/04/15
                              Begin
                                   OtherTxGrid.Col := Col;
                                   OtherTxGrid.Row := Row;
                              End;
                      end;
             End;
        End;
end;

procedure TBankActivities.OtherTxGridGetEditMask(Sender: TObject; ACol,
  ARow: Longint; var Value: OpenString);
begin
     Case ACol Of
          0 : Value := '!9999; ';
          1 : If JournalRadio.Checked Or LeaseRadio.Checked Or GEditing Then
                 Value := '!9999; ';
     End;
end;

procedure TBankActivities.OtherTxGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
            Case OtherTxGrid.Col Of
                 0 : Begin   { Nominal Ledger Column }
                        if ( LoanTxRadio.Checked ) And (( BankLoanRadio.Checked ) Or
                           ( RepayRadio.Checked )) Then
                           NewListBox.ListIt ( Sender, Liab, 'N' )         { List Liabilites }
                        else If ( LoanTxRadio.Checked ) And ( LeaseRadio.Checked ) Then
                           NewListBox.ListIt ( Sender, FAsset, 'N' )        { List Fixed Assets }
                        else If ( LoanTxRadio.Checked ) And ( InterestRadio.Checked ) Then
                           NewListBox.ListIt ( Sender, OverHeadsWithExpense, 'N' )        { List Overheads }
                        else if JournalRadio.Checked then
                           NewListBox.ListIt ( Sender, AllNomsPlusCapital, 'N' )      { Nominal Ledger Accounts }
                        else
                           NewListBox.ListIt ( Sender, AllNoms, 'N' );      { Nominal Ledger Accounts }
                        (*
                        if BankLoanRadio.Checked Or RepayRadio.Checked Then
                           NewListBox.ListIt ( Sender, Liab, 'N' )         { List Liabilites }
                        else If LeaseRadio.Checked Then
                           NewListBox.ListIt ( Sender, FAsset, 'N' )        { List Fixed Assets }
                        else If InterestRadio.Checked Then
                           NewListBox.ListIt ( Sender, OverHeadsWithExpense, 'N' )        { List Overheads }
                        else
                           NewListBox.ListIt ( Sender, AllNoms, 'N' );      { Nominal Ledger Accounts }
                        *)
                        If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
                           OtherTxGrid.Cells[0,OtherTxGrid.Row] := NewListBox.ListInfo.ReturnValue;
                     End;
                 1 : If JournalRadio.Checked Or LeaseRadio.Checked Or
                        InterestRadio.Checked Or GEditing Then
                        begin   { Nominal Ledger Column }
                           if ( BankTxRadio.Checked ) And ( NOT JournalRadio.Checked ) then
                              NewListBox.ListIt ( Sender, AllNoms, 'N' )   { Nominal Ledger Accounts }
                           else if ( BankTxRadio.Checked ) And ( JournalRadio.Checked ) Then
                              NewListBox.ListIt ( Sender, AllNomsPlusCapital, 'N' )   { Nominal Ledger Accounts }
                           else
                              NewListBox.ListIt ( Sender, Liab, 'N' );  { Liablilties }
                           (*
                           if JournalRadio.Checked then
                              NewListBox.ListIt ( Sender, AllNoms, 'N' )   { Nominal Ledger Accounts }
                           else
                              NewListBox.ListIt ( Sender, Liab, 'N' );  { Liablilties }
                           *)
                           if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
                              OtherTxGrid.Cells[1,OtherTxGrid.Row] := NewListBox.ListInfo.ReturnValue;
                        end;
            End;
       end;
    If Key = VK_F1 then
       Begin
            if BankTXRadio.Checked and JournalRadio.Checked or
               LoanTXRadio.Checked and InterestRadio.checked or
               LoanTXRadio.Checked and LeaseRadio.Checked then
               begin
                    Case OtherTXGrid.Col Of
                    0 : begin
                             Application.HelpContext(45{19} );       {Debit}
                        end;
                    1 : begin
                             Application.HelpContext(46{20} );      {Credit}
                        end;
                    2 : begin
                             Application.HelpContext(11);           {Amount}
                        end;
                    3 : begin
                             Application.HelpContext(9);         {Description}
                        end;
                    end;
               end;
            if BankTXRadio.Checked and DDebitRadio.Checked or
               BankTXRadio.Checked and DCreditRadio.Checked or
               LoanTXRadio.Checked and BankLoanRadio.Checked or
               LoanTXRadio.Checked and RepayRadio.Checked then
               Begin
                    Case OtherTXGrid.Col Of
                    0 : begin
                             Application.HelpContext(8);           {Nominal}
                        end;
                    1 : begin
                             Application.HelpContext(11);          {Amount}
                        end;
                    2 : begin
                             Application.HelpContext(9);           {Description}
                        end;
                    End;
               End;
       end;

    If Key = VK_F5 Then
       Begin
           If (Prog = Journal) AND (Act = 6) Then
              Case OtherTxGrid.Col Of
                 2 : Begin      { Amount Column }
                          If Cash2.XCOUNTRY = 2 Then
                             OtherTxGrid.Cells[OtherTxGrid.Col, OtherTxGrid.Row] := EuroConvert ( OtherTxGrid.Cells[OtherTxGrid.Col, OtherTxGrid.Row] );
                             //EuroCalcBank;
                     End;
              End
           Else
              Case OtherTxGrid.Col Of
                 1 : Begin      { Amount Column }
                          If Cash2.XCOUNTRY = 2 Then
                             OtherTxGrid.Cells[OtherTxGrid.Col, OtherTxGrid.Row] := EuroConvert ( OtherTxGrid.Cells[OtherTxGrid.Col, OtherTxGrid.Row] );
//                             EuroCalcBank;
                     End;
              End;
       End;
    {   Key := 0;}
end;

procedure TBankActivities.BankAccountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
         NewListBox.ListIt ( Sender, Banks, 'N' );
         If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            BankAccount.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TBankActivities.OtherTxGridSelectCell(Sender: TObject; Col,
  Row: Longint; var CanSelect: Boolean);
Var
   TempStr : ShortString;
begin
     Case LastCol Of
          1 : If ( NOT JournalRadio.Checked ) And
                 ( NOT LeaseRadio.Checked ) And
                 ( NOT InterestRadio.Checked ) And
                 ( NOT GEditing ) Then
                 Begin
                   TempStr := OtherTxGrid.Cells[LastCol, LastRow];
                   SlimAll ( TempStr );
                   If Length ( TempStr ) > 0 Then
                      If NOT ChangeToLong ( TempStr ) Then
                         CanSelect := False
                      Else
                          OtherTxGrid.Cells[LastCol, LastRow] := TempStr;
                 End;
          2 : If JournalRadio.Checked Or LeaseRadio.Checked Or InterestRadio.Checked Or
                 GEditing Then
                 Begin
                   TempStr := OtherTxGrid.Cells[LastCol, LastRow];
                   SlimAll ( TempStr );
                   If Length ( TempStr ) > 0 Then
                      If NOT ChangeToLong ( TempStr ) Then
                         CanSelect := False
                      Else
                          OtherTxGrid.Cells[LastCol, LastRow] := TempStr;
                 End;
     End;
end;

procedure TBankActivities.OtherTxGridSetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: String);
begin
     // TGM MESSING ARROUND 15/12/01
//     If OtherTxGrid.col = 0 then showmessage('test');
     If LastCol <> Acol Then
        LastCol := ACol;
     If LastRow <> ARow Then
        LastRow := ARow;
end;

procedure TBankActivities.SaveClick(Sender: TObject);
Var
   BadCol,
   BadRow   : LongInt;
   ErrText  : String;
   counter,
   counter2 : Integer;
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
   If MoveTxInfo ( BadCol, BadRow  ) Then
      Begin
        If MessageDlg(ReadLang ( 142, CurrLang ),mtInformation, [mbYes, mbNo], 0) = mrYes then
          Begin
            If GEditing Then
              Begin
                WriteTransactions ( 2, PlFile,0, FALSE );
                WriteTransactions ( 1, PlFile,0, FALSE );
                ResetPointers( BankActivities );
                { Exit the Form }
                BankActivities.ExitbtnClick(Sender);
              End
            Else
               WriteTransactions ( 1, PLFile,0, FALSE );

            { Initialise the Grid }
            For Counter := 1 To 11 Do
               For Counter2 := 0 To 3 Do      // TGM AB changed from 2 to 3
                   OtherTxGrid.Cells[Counter2,Counter] := '';
            OtherTxGrid.Row := 1;
            OtherTxGrid.Col := 0;
            If HpSetUpPanel.Visible Then
//              Cash11.Default_Date := HPDate.Text
              Cash11.Default_Date := TxHPDate.Text
            Else
//               Cash11.Default_Date := Date.Text;
               Cash11.Default_Date := TxDate.Text;
            DefWrite ( 11 );
          End;
        End
      Else
         If Act = 5 Then  { InterBank Transfers }
             Begin
                Case BadCol Of
                   BadBankFrom : ErrText := 'Missing Bank Account From';
                   BadBankTo   : ErrText := 'Missing Bank Account To';
                   2 : ErrText := 'Bank''s are the Same';
                   Else
                       ErrText := 'UnKnown Field';
                End;
	        MessageDlg( ErrText, mtInformation,[mbOK], 0);
                If BadCol = BadBankFrom Then
                   BankAccount.SetFocus
                Else
                    If BadCol In [BadBankTo,2] Then
                       OtherAccount.SetFocus;
             End
         Else
             Begin
                Case BadCol Of
                   BadBankFrom : ErrText := 'Bank Account';
                   0           : if BankActivities.JournalRadio.Checked Or
                                    BankActivities.LeaseRadio.Checked Or
                                    BankActivities.InterestRadio.Checked Then
                                    ErrText := ' or Duplicate Nominal Code'
                                 else
                                    ErrText := 'Nominal Code';
                   1           : if BankActivities.JournalRadio.Checked Or
                                    BankActivities.LeaseRadio.Checked Or
                                    BankActivities.InterestRadio.Checked Then
                                    ErrText := ' or Duplicate Nominal Code'
                                 else
                                    ErrText := 'Amount';
                   2           : if BankActivities.JournalRadio.Checked Or
                                    BankActivities.LeaseRadio.Checked Or
                                    BankActivities.InterestRadio.Checked Then
                                    ErrText := 'Amount';
                   else
                       ErrText := 'UnKnown Field';
                End;
	        MessageDlg('Missing ' + ErrText, mtInformation,[mbOK], 0);
                Case BadCol Of
                   BadBankFrom : BankAccount.SetFocus;
                   Else          Begin
                                      OtherTxGrid.Col := BadCol;
                                      OtherTxGrid.Row := BadRow;
                                      OtherTxGrid.SetFocus;
                                 End;
                End;

             End;
end;

procedure TBankActivities.ExitbtnClick(Sender: TObject);
begin
{     If MessageDlg('Exit Without Saving', mtInformation,[mbOK], 0) = mrOK Then}
     Close;
end;

procedure TBankActivities.BankAccountExit(Sender: TObject);
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
                    if ( CurrLong < 0 ) then
                       BankBalance.Font.Color := clRed
                    else
                       BankBalance.Font.Color := clBlack;
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
        ( Length ( TestStr ) = 0 ) or (CheckNomEqualsZero(TestStr)) Then    // TGM AB 24/04/15
        BankAccount.SetFocus        //TGM AB 20/03/15
     Else
         GetBankInfo;
     PromptLine.Panels.Items[1].Text := '';         
end;

procedure TBankActivities.OtherAccountExit(Sender: TObject);
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
              OtherAccountNameLabel.Caption := CurrStr;
              {
              If xShowBank Then
                 Begin
                    GetItem ( NlFile, 2 );
                    LongStr ( CurrLong, CurrStr, 'L' );
                    BankBalance.Text := CurrStr;
                 End;
              }
           End;
   End;

begin
     InitRange ( AccRange );
     AccRange[1] := Cash1.xBankMin;
     AccRange[2] := Cash1.xBankMax;
     TestStr := OtherAccount.Text;
     SlimAll ( TestStr );
     If ( NOT CheckNom ( OtherAccount.Text, 0, 0, AccRange )) Or
        ( Length ( TestStr ) = 0 ) or (CheckNomEqualsZero(TestStr)) Then    //TGM AB 24/04/15
        If OtherAccount.CanFocus Then
           OtherAccount.SetFocus       // TGM AB was removed
     Else
         { Don't all journal to the same Bank }
         If Numeric ( OtherAccount.Text ) Then
            If StrToInt ( OtherAccount.Text ) <> StrToInt ( BankAccount.Text ) Then
               GetBankInfo
            Else
                OtherAccount.SetFocus;
     PromptLine.Panels.Items[1].Text := '';                
end;

procedure TBankActivities.OtherAccountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
         NewListBox.ListIt ( Sender, Banks, 'N' );
         If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            OtherAccount.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TBankActivities.OtherAmountExit(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := OtherAmount.Text;
     SlimAll ( TempStr );
     If Length ( TempStr ) > 0 Then
        If NOT ChangeToLong ( TempStr ) Then
           OtherAmount.SetFocus
        Else
            OtherAmount.Text := TempStr;
end;

procedure TBankActivities.DDebitRadioClick(Sender: TObject);
begin
     Prog := Journal;
     Act  := 1;
     SetUpScreen ( Prog, Act, ' ' );
     Caption := 'Direct Debit';{ + ' - ' + st;}
     BankAccountLabel.Caption := 'Bank Account';
     BankAccount.SetFocus;
end;

procedure TBankActivities.DCreditRadioClick(Sender: TObject);
begin
     Prog := Journal;
     Act  := 2;
     SetUpScreen ( Prog, Act, ' ' );
     Caption := 'Direct Crebit';{ + ' - ' + st;}
     BankAccountLabel.Caption := 'Bank Account';     
     BankAccount.SetFocus;
end;

procedure TBankActivities.InterBankRadioClick(Sender: TObject);
begin
     Prog := Journal;
     Act  := 5;
     SetUpScreen ( Prog, Act, ' ' );
     Caption := 'Inter Bank';{ + ' - ' + st;}
     BankAccount.SetFocus;
end;

procedure TBankActivities.JournalRadioClick(Sender: TObject);
begin
     Prog := Journal;
     Act  := 6;
     SetUpScreen ( Prog, Act, ' ' );
     Caption := 'Journal';{ + ' - ' + st;}

     BankTxRadio.Enabled := False;
     LoanTxRadio.Enabled := False;
     BankRecRadio.Enabled := False;
     btnBankImport.enabled := False;

     DDebitRadio.Enabled := False;
     DCreditRadio.Enabled := False;
     InterbankRadio.Enabled := False;
     StandingOrderRadio.Enabled := False;
     JournalRadio.Enabled := True;
     JournalRadio.visible := True;
     JournalRadio.Checked := True;

{     Date.SetFocus;     }
end;

procedure TBankActivities.BankTxRadioClick(Sender: TObject);
begin
     LoanTxGroup.Hide;
     UnCheckAll(LoanTxGroup);
     Caption := 'Bank Activities';{ + ' - ' + st;}
     BankTxGroup.Visible := True;
     If ( NOT DDebitRadio.Checked ) And ( NOT DCreditRadio.Checked ) And
        ( NOT InterBankRadio.Checked ) And ( NOT JournalRadio.Checked ) Then
        DDebitRadio.Checked := True
     Else If DDebitRadio.Checked Then
          DDebitRadioClick ( Sender )
     Else If DCreditRadio.Checked Then
          DCreditRadioClick ( Sender )
     Else If InterBankRadio.Checked Then
          InterBankRadioClick ( Sender )
     Else JournalRadioClick ( Sender );
end;

Procedure TBankActivities.SetUpScreen(Prog, Act : Integer; SpecialCase : Char );
Var
   Counter1,
   Counter : Integer;
Begin
     { SpecialCase Options
       B = Bank Loans
       H = Hire Purchase Initial Payment
       L = Lease Set-Up
       I = Interest Adjustment
       P = Repayment of Loan Or H.Purchase
     }

     BankTxRadio.Enabled := True;
     LoanTxRadio.Enabled := True;
     BankRecRadio.Enabled := True;
     btnBankImport.enabled := True;

     DDebitRadio.Enabled := True;
     DCreditRadio.Enabled := True;
     InterbankRadio.Enabled := True;
     StandingOrderRadio.Enabled := True;
     JournalRadio.Enabled := False;
     JournalRadio.visible := False;

     If NOT GEditing Then
        Begin
             { Initialise all relevant variables }
             HpAmount.Text := '';
             HpDiscount.Text := '';
             OtherAmount.Text := '';
             OtherDescription.Text := '';
             StubNo.Text := '';
             HpReference.Text := '';
             Comment.Text := '';
             Reference.Text := '';
             Account.Text := '';
             {BankAccount.Text := '';}
             OtherAccount.Text := '';

             For Counter := 1 To 10 Do
                 For Counter1 := 0 To 2 Do
                     OtherTxGrid.Cells[Counter1, Counter] := '';
        End;

     BankTxGroup.Hide;
     LoanTxGroup.Hide;
     HpSetUpAmtPanel.Hide;
     HpSetUpPanel.Hide;
     OtherPanel.Hide;
     OtherTxGrid.Width := OtherGridWidth;
     HPSetupLabel.Visible := False;

     If Act In [1..6] Then
        Case ACT Of
          1,
          2 : Begin
                   If SpecialCase In ['B','P'] Then       { Bank Loan or Repayment }
                      LoanTxGroup.Visible := True
                   Else
                       BankTxGroup.Visible := True;
                   If ( SpecialCase = 'B' ) Then
                      Caption := ReadLang ( 131, CurrLang ){+ ' - ' + st}
                   Else If ( SpecialCase = 'P' ) Then
                      Caption := ReadLang ( 132, CurrLang ){+ ' - ' + st}
                   Else If Act = 1 Then
                      Caption := ReadLang ( 121, CurrLang ){+ ' - ' + st}
                   Else
                      Caption := ReadLang ( 122, CurrLang );{+ ' - ' + st;}

                   BankBalance.Visible := True;
                   BankBalanceLabel.Visible := True;
                   BankAccount.Visible := True;
                   ListAccounts.Show;
                   BankAccountLabel.Visible := True;
                   BankNameLabel.Visible := True;

                   OtherAccount.Hide;
                   OtherAccountLabel.Hide;
                   OtherF2.Hide;
                   OthersPanel.Visible := True;
                   For Counter := 0 To 2 Do
                       OtherTxGrid.ColWidths[Counter] := Cellsize[Counter];
                   OtherTxGrid.Cells[0,0] := ReadLang ( 28, CurrLang ); { Ents }
                   OtherTxGrid.Cells[1,0] := ReadLang ( 31, CurrLang ); { Nom }
                   OtherTxGrid.Cells[2,0] := ReadLang ( 29, CurrLang ); { Description }

                   OtherTxGrid.ColCount := 3;
                   OtherTxGrid.Visible := True;
                   Height := OtherTxGrid.Top + OtherTxGrid.Height + 75;   //was 50
              End;
          3,
          4 : Begin
                   LoanTxGroup.Visible := True;
                  // Caption := ReadLang ( 134, CurrLang );{+ ' - ' + st;}
                   Caption := 'Set-Up Hire Purchase';
                   OthersPanel.Hide;
                   HpSetUpPanel.Top := OthersPanel.Top;
                   HpSetUpPanel.Left := OthersPanel.Left;
                   HpSetUpPanel.Width := OthersPanel.Width;
                   HpSetUpPanel.Visible := True;

                   HpSetUpAmtPanel.Top := HpSetUpPanel.Top + HpSetUpPanel.Height + 10;
                   HpSetUpAmtPanel.Left := OtherPanel.Left;
                   HpSetUpAmtPanel.Width := OtherPanel.Width;
                   HpSetUpAmtPanel.Height := OtherPanel.Height;
                   HpSetUpAmtPanel.Visible := True;

                   OtherTxGrid.Hide;
//                   Height := OtherPanel.Top + OtherPanel.Height + 70;
                   Height := OtherPanel.Top + OtherPanel.Height + 150;  // was 100
                   if Act = 3 then begin                                                               // TGM AB 24/10/14
                       HPSetupLabel.visible := true;                                                   // TGM AB 24/10/14
                       HPSetupLabel.top := HpSetUpAmtPanel.Top + HpSetUpAmtPanel.Height + 10;          // TGM AB 24/10/14
                       HPSetupLabel.left := HpSetUpAmtPanel.left - 50;                                 // TGM AB 24/10/14
                   end;                                                                                // TGM AB 24/10/14
              End;
          5 : Begin
                   BankTxGroup.Visible := True;
                   Caption := ReadLang ( 125, CurrLang );{+ ' - ' + st;}

                   OtherAccountLabel.Caption := 'To Bank Account';
                   BankAccountLabel.Caption := 'From Bank Account';

                   BankAccount.Visible := True;
                   BankAccountLabel.Visible := True;
                   ListAccounts.Show;

                   BankBalance.Visible := True;
                   BankBalanceLabel.Visible := True;
                   OtherAccount.Visible := True;
                   OtherAccountLabel.Visible := True;
                   OtherF2.Show;

                   OtherTxGrid.Hide;
                   OtherPanel.Visible := True;
                   Height := OtherPanel.Top + OtherPanel.Height + 75;    // was 50
              End;
          6 : Begin
                   OtherTxGrid.ColCount := 4;
                   OtherTxGrid.ColWidths[0] := 40;
                   OtherTxGrid.ColWidths[1] := 40;
                   OtherTxGrid.ColWidths[2] := 70;
                   OtherTxGrid.ColWidths[3] := 165;
                   OtherTxGrid.Cells[0,0] := ReadLang ( 119, CurrLang );
                   OtherTxGrid.Cells[1,0] := ReadLang ( 120, CurrLang );
                   If SpecialCase = 'L' Then  { Lease }
                      Begin
                           LoanTxGroup.Visible := True;
                           Caption := ReadLang ( 130, CurrLang );{+ ' - ' + st;}
                           OtherTxGrid.Cells[0,0] := 'F. Asset A/C';
                           OtherTxGrid.Cells[1,0] := 'Liability A/C';
                           OtherTxGrid.ColWidths[0] := 90;
                           OtherTxGrid.ColWidths[1] := 90;
                           OtherTxGrid.Width := ( OtherTxGrid.ColWidths[0] +
                                                  OtherTxGrid.ColWidths[1] +
                                                  OtherTxGrid.ColWidths[2] +
                                                  OtherTxGrid.ColWidths[3] + 15);       // TGM AB 20/03/15 was +5
                      End
                   Else If SpecialCase = 'I' Then  { Interest Adjustment }
                      Begin
                           LoanTxGroup.Visible := True;
                           Caption := ReadLang ( 133, CurrLang );{+ ' - ' + st;}
                           OtherTxGrid.Cells[0,0] := 'Interest A/C';
                           OtherTxGrid.Cells[1,0] := 'Loan A/C';
                           OtherTxGrid.ColWidths[0] := 90;
                           OtherTxGrid.ColWidths[1] := 70;
                           OtherTxGrid.Width := ( OtherTxGrid.ColWidths[0] +
                                                  OtherTxGrid.ColWidths[1] +
                                                  OtherTxGrid.ColWidths[2] +
                                                  OtherTxGrid.ColWidths[3] + 5);
                      End
                   Else
                       If ( NOT GEditing ) Then
                          Begin
                            BankTxGroup.Visible := True;
                            Caption := ReadLang ( 126, CurrLang );{+ ' - ' + st;}
                          End
                       Else
                            Caption := 'Editing Transaction';{+ ' - ' + st;}

                   BankBalance.Hide;
                   BankBalanceLabel.Hide;
                   BankAccount.Hide;
                   BankAccountLabel.Hide;
                   ListAccounts.Hide;
                   BankNameLabel.Hide;
                   OtherAccount.Hide;
                   OtherAccountLabel.Hide;
                   OtherAccountNameLabel.Hide;
                   OtherF2.Hide;

                   {OthersPanel.Visible := True;}
                   OtherTxGrid.Hide;
                   OthersPanel.Visible := True;
                   OtherTxGrid.Cells[2,0] := ReadLang ( 31, CurrLang );
                   OtherTxGrid.Cells[3,0] := ReadLang ( 29, CurrLang );

                   OtherTxGrid.Visible := True;
                   Height := OtherTxGrid.Top + OtherTxGrid.Height + 75;   // was 50
              End;
        End     { EndCase }
     Else
         Begin
              MessageDlg('Invalid Option Selection - Contact Kingswood' , mtInformation,[mbOK], 0);
              Close;
         End;
End;

procedure TBankActivities.LoanTxRadioClick(Sender: TObject);
begin
     Caption := 'Loans';{ + ' - ' + st;}
     LoanTxGroup.Top    := BankTxGroup.Top;
     LoanTxGroup.Left   := BankTxGroup.Left;
     LoanTxGroup.Height := BankTxGroup.Height;
     {LoanTxGroup.Width  := BankTxGroup.Width;}

     If NOT Cash1.XCASHBOOK Then
        HirePRadio.Show
     Else
        HirePRadio.Hide;

     LoanTxGroup.Visible := True;
     If ( NOT BankLoanRadio.Checked ) And ( NOT HirePRadio.Checked ) And
        ( NOT LeaseRadio.Checked ) And ( NOT RepayRadio.Checked ) And
        ( NOT InterestRadio.Checked ) Then
        BankLoanRadio.Checked := True
     Else
         If BankLoanRadio.Checked Then
            BankLoanradioClick ( Sender )
         Else If HirePRadio.Checked Then
            HirePRadioClick ( Sender )
         Else If LeaseRadio.Checked Then
            LeaseRadioClick ( Sender )
         Else If RepayRadio.Checked Then
            RepayRadioClick ( Sender )
         Else
            InterestRadioClick ( Sender );
     BankTxGroup.Hide;
     UnCheckAll(BankTxGroup);
end;

procedure TBankActivities.BankLoanRadioClick(Sender: TObject);
begin
     Prog := Journal;
     Act  := 2;      { Set to Direct credit }
     SetUpScreen ( Prog, Act, 'B' );
     BankAccountLabel.Caption := 'Bank Account';     
     BankAccount.SetFocus;
end;

procedure TBankActivities.HirePRadioClick(Sender: TObject);
begin
     Prog := PURCHTX;
     Act  := 3;      { Set to Purchase Ledger Payment using Liability Account }
     SetUpScreen ( Prog, Act, 'H' );
     SupplierNo.Text := '1';
     SupplierNo.SetFocus;
end;

procedure TBankActivities.LeaseRadioClick(Sender: TObject);
begin
     Prog := Journal;
     Act  := 6;      { Set Lease }
     SetUpScreen ( Prog, Act, 'L' );
     TxDate.SetFocus;
end;

procedure TBankActivities.RepayRadioClick(Sender: TObject);
begin
     Prog := Journal;
     Act  := 1;      { Set to Repay Loans }
     SetUpScreen ( Prog, Act, 'P' );
     BankAccountLabel.Caption := 'Bank Account';
     BankAccount.SetFocus;
end;

procedure TBankActivities.InterestRadioClick(Sender: TObject);
begin
     Prog := Journal;
     Act  := 6;      { Set to Interest Adjustments }
     SetUpScreen ( Prog, Act, 'I' );
     TxDate.SetFocus;
end;

procedure TBankActivities.AccountExit(Sender: TObject);
Var
   TestStr  : ShortString;
   AccRange : TAccRange;

   {
   Procedure GetBankInfo;
   Begin
        SetDb ( NlFile );
        ReadRec ( NlFile, StrToInt ( TestStr ));
        dberr;
        If RecActive ( NlFile ) Then
           Begin
              GetItem ( NlFile, 1 );
              BankNameLabel.Caption := CurrStr;
              If xShowBank Then
                 Begin
                    GetItem ( NlFile, 2 );
                    LongStr ( CurrLong, CurrStr, 'L' );
                    BankBalance.Text := CurrStr;
                 End;
           End;
   End;
   }

begin
     InitRange ( AccRange );
     AccRange := SetRanges ( Liab );
     TestStr := Account.Text;
     SlimAll ( TestStr );
     If ( NOT CheckNom ( Account.Text, 0, 0, AccRange )) Or
        ( Length ( TestStr ) = 0 ) or (CheckNomEqualsZero(TestStr)) Then                             // TGM AB 24/04/15
        Account.SetFocus;

     {
     Else
         GetBankInfo;
     }
end;

procedure TBankActivities.AccountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Key = VK_F2 Then    { F2 Pressed }
       Begin
         NewListBox.ListIt ( Sender, Liab, 'N' );
         If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            Account.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TBankActivities.SupplierNoExit(Sender: TObject);
Var
   TestStr : ShortString;

   Procedure GetCustSuppInfo;
   Begin
        {SetDb ( SalesPurchDB );
        ReadRec ( SalesPurchDB, StrToInt ( TestStr ));
        dberr;
        If RecActive ( SalesPurchDB ) Then
           Begin
              GetItem ( SalesPurchDB, 1 );
              CustSuppNameLabel.Caption := CurrStr;
              GetItem ( SalesPurchDB, 2 );
              CustSuppAdd1Label.Caption := CurrStr;
              GetItem ( SalesPurchDB, 3 );
              CustSuppAdd2Label.Caption := CurrStr;
              GetItem ( SalesPurchDB, 4 );
              CustSuppAdd3Label.Caption := CurrStr;
              GetItem ( SalesPurchDB, 7 );
              LongStr ( CurrLong, CurrStr, 'L' );
              CurrentBal.Text := CurrStr;
              GetItem ( SalesPurchDB, 9 );
              LongStr ( CurrLong, CurrStr, 'L' );
              AgedCurr.Text := CurrStr;
              GetItem ( SalesPurchDB, 10 );
              LongStr ( CurrLong, CurrStr, 'L' );
              Aged1.Text := CurrStr;
              GetItem ( SalesPurchDB, 11 );
              LongStr ( CurrLong, CurrStr, 'L' );
              Aged2.Text := CurrStr;
              GetItem ( SalesPurchDB, 12 );
              LongStr ( CurrLong, CurrStr, 'L' );
              Aged3.Text := CurrStr;
           End;
        }
   End;

begin
     If SupplierNo.Visible Then
        Begin
             SetDb ( PLFile );
             TestStr := SupplierNo.Text;
             SlimAll ( TestStr );

             If ( NOT CheckCustSupp ( PlFile, SupplierNo.Text )) Then
                SupplierNo.SetFocus
             Else
                 GetCustSuppInfo;
        End;
end;

procedure TBankActivities.SupplierNoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
          NewListBox.ListIt ( Sender, Suppliers, 'S' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            SupplierNo.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TBankActivities.HpAmountExit(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := HpAmount.Text;
     SlimAll ( TempStr );
     If Length ( TempStr ) > 0 Then
        If NOT ChangeToLong ( TempStr ) Then
           HpAmount.SetFocus
        Else
            HpAmount.Text := TempStr;
end;

procedure TBankActivities.HpDiscountExit(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := HpDiscount.Text;
     SlimAll ( TempStr );
     If Length ( TempStr ) > 0 Then
        If NOT ChangeToLong ( TempStr ) Then
           HpDiscount.SetFocus
        Else
            HpDiscount.Text := TempStr;
end;

procedure TBankActivities.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Release;
end;

procedure TBankActivities.StandingOrderRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     If Button = mbLeft Then
        Jour.Journals.WhichType := SOrders;
        Jour.Journals.Caption := 'Standing Orders';{ + ' - ' + st;}
        Jour.Journals.ShowModal;
end;

procedure TBankActivities.ListAccountsClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Banks, 'N' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        BankAccount.Text := NewListBox.ListInfo.ReturnValue;
     BankAccountExit ( Sender );
end;

procedure TBankActivities.SupplierF2Click(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Suppliers, 'S' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        SupplierNo.Text := NewListBox.ListInfo.ReturnValue;
     SupplierNoExit ( Sender );
end;

procedure TBankActivities.OtherF2Click(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Banks, 'N' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        OtherAccount.Text := NewListBox.ListInfo.ReturnValue;
     OtherAccountExit ( Sender );
end;

procedure TBankActivities.OtherTxGridDblClick(Sender: TObject);
begin
     Case OtherTxGrid.Col Of
          0 : Begin   { Nominal Ledger Column }
                  if ( LoanTxRadio.Checked ) And (( BankLoanRadio.Checked ) Or
                     ( RepayRadio.Checked )) Then
                     NewListBox.ListIt ( Sender, Liab, 'N' )         { List Liabilites }
                  else If ( LoanTxRadio.Checked ) And ( LeaseRadio.Checked ) Then
                       NewListBox.ListIt ( Sender, FAsset, 'N' )        { List Fixed Assets }
                  else If ( LoanTxRadio.Checked ) And ( InterestRadio.Checked ) Then
                       NewListBox.ListIt ( Sender, OverHeadsWithExpense, 'N' )        { List Overheads }
                  else if JournalRadio.Checked then
                      NewListBox.ListIt ( Sender, AllNomsPlusCapitalLessControl, 'N' )      { Nominal Ledger Accounts }
                  else
                      NewListBox.ListIt ( Sender, AllNoms, 'N' );      { Nominal Ledger Accounts }
                  If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
                     OtherTxGrid.Cells[0,OtherTxGrid.Row] := NewListBox.ListInfo.ReturnValue;
              End;
          1 : If JournalRadio.Checked Or LeaseRadio.Checked Or
                 InterestRadio.Checked Or GEditing Then
                 Begin   { Nominal Ledger Column }
                      if ( BankTxRadio.Checked ) And ( NOT JournalRadio.Checked ) then
                         NewListBox.ListIt ( Sender, AllNoms, 'N' )   { Nominal Ledger Accounts }
                      else if ( BankTxRadio.Checked ) And ( JournalRadio.Checked ) Then
                         NewListBox.ListIt ( Sender, AllNomsPlusCapitalLessControl, 'N' )   { Nominal Ledger Accounts }
                      else
                          NewListBox.ListIt ( Sender, Liab, 'N' );  { Liablilties }
                      if Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
                         OtherTxGrid.Cells[1,OtherTxGrid.Row] := NewListBox.ListInfo.ReturnValue;
                 End;
     End;
end;

procedure TBankActivities.BankRecRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     If Button = mbLeft Then
        //showmessage('If you have not done a backup before choosing bank reconciliation, please exit and do a backup now.');
        begin
            //   26/11/13 [V4.1 R5.7] /MK Bug Fix - Need to call OnActivate and OnShow before Data Integrity Runs.
            auditfiles.OnActivate(self);
            auditfiles.OnShow(self);
            //   11/11/13 [V4.1 R5.6] /MK Additional Feature - Add Data Integrity Check before Bank Rec opens.
            if fullaudit.AuditFiles.NLbalancesOK(false,false,1) = false then
               MessageDlg('Data Integrity Check indicates there may be a problem with your data.'+#10#13+
                          'Please contact Kingswood.',mtError,[mbOK],0);
            BankTxGroup.Hide;
            LoanTxGroup.Hide;
            OtherTxGrid.Hide;
            OthersPanel.Hide;
            HPSetupPanel.Hide;
            HPSetupAmtPanel.Hide;
            Caption := 'Bank Reconciliation';{ + ' - ' + st;}
            CreateAndShowForm(TBankRecForm);
        end;
end;

procedure TBankActivities.TxDateEnter(Sender: TObject);
begin
     If NOT DateValid ( TxDate.Text, TDateFormat ) Then
        Begin
             TxDate.Text := Cash11.Default_Date;{XDate;}
             TxHPDate.Text := Cash11.Default_Date;{XDate;}
        End;
     PromptLine.Panels.Items[1].Text := 'Click The Down Arrow Button To Use The Calendar';        
end;

procedure TBankActivities.TxDateExit(Sender: TObject);
Var
   TestDate : ShortString;
   DateBefore : Boolean;
begin
     If OthersPanel.Visible Then
        Begin
             TestDate := TxDate.Text;
             If NOT DateValid ( TxDate.Text, TDateFormat ) Then
                TxDate.SetFocus
             Else If NOT CheckDateRange ( TestDate, True, DateBefore, True ) Then
                  Begin
                       TxDate.Text := TestDate;
                       TxDate.SetFocus;
                  End;
        End
     Else
         If HPSetUpPanel.Visible Then
            Begin
                 TestDate := TxHPDate.Text;
                 If NOT DateValid ( TxHPDate.Text, TDateFormat ) Then
                    TxHPDate.SetFocus
                 Else If NOT CheckDateRange ( TestDate, True, DateBefore, True ) Then
                      Begin
                           TxHPDate.Text := TestDate;
                           TxHPDate.SetFocus;
                      End;
            End;
     PromptLine.Panels.Items[1].Text := '';
end;

procedure TBankActivities.DateSearchCloseUp(Sender: TObject);
begin
     TxDate.Text:= DateToStr(DateSearch.Date);
     TxDate.SetFocus;     
end;

procedure TBankActivities.SuppDateSearchCloseUp(Sender: TObject);
begin
     TxHPDate.Text := DateToStr(SuppDateSearch.Date);
     TxHPDate.SetFocus;     
end;

procedure TBankActivities.DateSearchDropDown(Sender: TObject);
begin
    DateSearch.Date := StrToDate (TxDate.Text );
end;

procedure TBankActivities.SuppDateSearchDropDown(Sender: TObject);
begin
    SuppDateSearch.Date := StrToDate (TxHPDate.Text );
end;

procedure TBankActivities.FormShow(Sender: TObject);
begin
     DateSearch.Date := StrToDate (Cash11.Default_Date);
     SuppDateSearch.Date := StrToDate (Cash11.Default_Date);
end;

procedure TBankActivities.HpAmountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Cash2.XCOUNTRY = 2 Then
        If Key = VK_F5 then
           (Sender as TEdit).Text := EuroConvert( (Sender as TEdit).Text);
end;

procedure TBankActivities.HpDiscountKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Cash2.XCOUNTRY = 2 Then
        If Key = VK_F5 then
           (Sender as TEdit).Text := EuroConvert( (Sender as TEdit).Text);
end;

procedure TBankActivities.BankBalanceKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
     If Cash2.XCOUNTRY = 2 Then
        If Key = VK_F5 then
           (Sender as TEdit).Text := EuroConvert( (Sender as TEdit).Text);
end;

procedure TBankActivities.SpeedButton1Click(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Liab, 'N' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        Account.Text := NewListBox.ListInfo.ReturnValue;
     Account.SetFocus;
end;

procedure TBankActivities.OtherAmountKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
     If Cash2.XCOUNTRY = 2 Then
        If Key = VK_F5 then
           (Sender as TEdit).Text := EuroConvert( (Sender as TEdit).Text);
end;

procedure TBankActivities.HelpClick(Sender: TObject);
begin
   //Application.HelpContext(68);
   if BankTxRadio.Checked then
      AccsDataModule.HTMLHelp('bank.htm')
   else if LoanTxRadio.Checked then
      AccsDataModule.HTMLHelp('loans.htm')
   else if BankRecRadio.Checked then
      AccsDataModule.HTMLHelp('yourFirstBankReconciliation.htm')
   else
      AccsDataModule.HTMLHelp('bankTransations.htm')
end;

procedure TBankActivities.OtherTxGridClick(Sender: TObject);
begin
     if BankTXRadio.Checked and JournalRadio.Checked or
        LoanTXRadio.Checked and InterestRadio.checked or
        LoanTXRadio.Checked and LeaseRadio.Checked then
        begin
             Case OtherTxGrid.Col of
                  0,
                  1 : PromptLine.Panels.Items[1].Text := 'Press F2 or Double Click to List Accounts';
                  2 : PromptLine.Panels.Items[1].Text := 'Please Enter The Amount';
                  3 : PromptLine.Panels.Items[1].Text := 'Please Enter a Description';
             Else
                 PromptLine.Panels.Items[1].Text := '';
             End;
        End
     Else if BankTXRadio.Checked and DDebitRadio.Checked or
             BankTXRadio.Checked and DCreditRadio.Checked or
             LoanTXRadio.Checked and BankLoanRadio.Checked or
             LoanTXRadio.Checked and RepayRadio.Checked then
             begin
                  Case OtherTxGrid.Col of
                       0 : PromptLine.Panels.Items[1].Text := 'Press F2 or Double Click to List Accounts';
                       1 : PromptLine.Panels.Items[1].Text := 'Please Enter The Amount';
                       2 : PromptLine.Panels.Items[1].Text := 'Please Enter a Description';
                  Else
                      PromptLine.Panels.Items[1].Text := '';
                  End;
             End
end;

procedure TBankActivities.OtherTxGridExit(Sender: TObject);
begin
     PromptLine.Panels.Items[1].Text := '';
end;

procedure TBankActivities.BankAccountEnter(Sender: TObject);
begin
     PromptLine.Panels.Items[1].Text := 'Press F2 or Double Click to List Accounts';
end;

procedure TBankActivities.UnCheckAll(Sender: TObject);
var
   i : Integer;
begin
   if (Sender is TGroupBox) then
       for i := 0 to (Sender as TGroupBox).ControlCount-1 do
          if ((Sender as TGroupBox).Controls[i] is TRadioButton) then
             ((Sender as TGroupBox).Controls[i] as TRadioButton).Checked := FALSE;
end;

procedure TBankActivities.SetupBanksBtnClick(Sender: TObject);
begin
      if not bool(BankSetup) then Application.CreateForm(TBankSetup, BankSetup);
      BankSetup.Launchform('B');
end;

procedure TBankActivities.btnBankImportClick(Sender: TObject);
begin
   TfmBankImport.RunImport;
end;

procedure TBankActivities.miClick(Sender: TObject);
begin
   TfmBankFileSelectorSettings.ShowSettings;
end;

end.
