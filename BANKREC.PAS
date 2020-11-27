unit Bankrec;

interface                     

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, Types, ComCtrls, Mask, NewClass;

type
  TBankRecForm = class(TKingForm)
    Panel1: TPanel;
    Exit: TBitBtn;
    Panel2: TPanel;
    BankCode: TEdit;
    Label1: TLabel;
    ListAccounts: TSpeedButton;
    BankRecGrid: TStringGrid;
    StartBankRec: TBitBtn;
    BankBalance: TEdit;
    TotalUnReceipts: TEdit;
    TotalUnPayments: TEdit;
    CurrentBalance: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    UserStatementBalance: TEdit;
    Label13: TLabel;
    SaveChequeStatus: TBitBtn;
    Help: TBitBtn;
    StatusBar1: TStatusBar;
    pBalances: TPanel;
    RunningBalance: TEdit;
    Label11: TLabel;
    RecError: TEdit;
    Label12: TLabel;
    Label6: TLabel;
    pFilters: TPanel;
    Label2: TLabel;
    TxDateFrom: TMaskEdit;
    DateSearchFrom: TDateTimePicker;
    DateSearchTo: TDateTimePicker;
    TxDateTo: TMaskEdit;
    Label3: TLabel;
    IncludeP: TCheckBox;
    IncludeU: TCheckBox;
    IncludeE: TCheckBox;
    Label4: TLabel;
    StubFrom: TEdit;
    StubTo: TEdit;
    Label5: TLabel;
    BitBtn1: TBitBtn;
    ColRecError: TEdit;
    Continue: TBitBtn;
    Label14: TLabel;
    SearchBox: TEdit;
    procedure ExitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BankCodeDblClick(Sender: TObject);
    procedure BankCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StartBankRecClick(Sender: TObject);
    procedure BankRecGridDblClick(Sender: TObject);
    procedure RecErrorChange(Sender: TObject);
    procedure UserStatementBalanceExit(Sender: TObject);
    procedure BankCodeExit(Sender: TObject);
//    procedure SaveClick(Sender: TObject);
    procedure SaveChequeStatusClick(Sender: TObject);
    procedure RunningBalanceExit(Sender: TObject);
    procedure StubFromExit(Sender: TObject);
    procedure StubToExit(Sender: TObject);
    procedure BankCodeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TxDateFromExit(Sender: TObject);
    procedure DateSearchFromCloseUp(Sender: TObject);
    procedure DateSearchFromDropDown(Sender: TObject);
    procedure TxDateToExit(Sender: TObject);
    procedure DateSearchToCloseUp(Sender: TObject);
    procedure DateSearchToDropDown(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure ContinueClick(Sender: TObject);
    procedure UpdateGridTxNos;   // TGM AB 21/12/12 Procedure to run through table and update Tx Numbers to the First Tx in the transaction not the Payment Line
    function FindFirstTxNumber(TxNo : Integer) : integer; // TGM AB 04/01/13 finds First Tx in the transaction not the Payment Line (if applicable)
  private
    { Private declarations }
//    Procedure OpenBank;
    Function RecordOK ( Var CurrStat : ShortString ): Boolean;
    Procedure CalcError;
    Procedure DispOutput ( TxRec, LocalLine, CurrAcc : Integer );
    Procedure FillGrid ( FTx, LTx, BankNo : Integer );
    Function ShowInfo ( Bank : String ) : Boolean;
    Procedure GetBankInfo ( BankNo : Integer );
    Procedure CalcRecError ( Row : Integer; AddIt : Boolean );
  public
    { Public declarations }
  end;

var
  BankRecForm: TBankRecForm;
  FirstTxYear : integer;

implementation
Uses
    pickdate,
    DBGen,
    Clears,
    DBCore,
    Util,
    Calcs,
    NewListing,
    Vars,
    LangUnit,
    Chkcomp, AccsData, FullAudit;

Var
 //  BankR    : tBankRec;
 //  BankFile : tBankFile;
   LRunningBalance,
   ClosingBalance,
   vTotalUnReceipts,
   vTotalUnPayments,
   LastBalance,
   LBankBalance : Long;  
   LStubFrom,
   LStubTo       : LongInt;
   DateFrom,
   DateTo,
   LastBank      : integer;
 //  BankFileRec : Integer;
   BankAccount : integer; // TGM AB new variable to hold Bank Account number when using new paradox bank table
   InfoSaved   : Boolean;

{$R *.DFM}

//Procedure TBankRecForm.OpenBank;
//Begin
 (*    AssignFile ( BankFile, Cash2.xdirectory + cBankFile );
     Try
        ReSet ( BankFile );
     ExCept
           ReWrite ( BankFile );
     End; *)
//End;

Function TBankRecForm.RecordOK ( Var CurrStat : ShortString ): Boolean;
Var
   RecOk : Boolean;
Begin
     { Test Trans Type against user inputted items }
     GetItem ( TxFile, 27 );
     CurrStat := Currstr;
     SlimAll ( CurrStat );
     RecOk := (( IncludeP.Checked ) And ( CurrStr = 'P' )) Or
              (( IncludeU.Checked ) And ( CurrStr = 'U' )) Or
              (( IncludeE.Checked ) And ( CurrStr = 'E' ));
     If RecOk Then
        RecOk := CheckEditStatus;
     RecordOk := RecOk;
End;

Procedure TBankRecForm.CalcError;
Var TempSt : ShortString;
Begin
     LongStr (LRunningBalance-(LBankBalance+vTotalUnPayments-vTotalUnReceipts), TempSt, 'L' );
     RecError.Text := TempSt;
End;

Procedure TBankRecForm.DispOutput ( TxRec, LocalLine, CurrAcc : Integer );
Var
   TempSt         : ShortString;
   Amount         : Long;
   Debit          : Boolean;
Begin
{-->>     Amount := 0;}
     If LocalLine > 1 Then
        BankRecGrid.RowCount:= BankRecGrid.RowCount + 1;

           {** Display Record }
     Str ( TxRec, TempSt );
     padright ( TempSt, 5 );
  //   BankRecGrid.Cells[0,LocalLine] := TempSt;   TGM AB 04/01/13
     BankRecGrid.Cells[10,LocalLine] := TempSt; // TGM AB 14/12/12

     GetItem ( TxFile, 17 );
     Amount := Currlong;
     LongStr ( Amount, TempSt, 'L' );
     Getitem ( TxFile, 18 );
     If ( Currint = CurrAcc ) Then
        Begin
             BankRecGrid.Cells[1,LocalLine] := TempSt;
             BankRecGrid.Cells[2,LocalLine] := '';
             Debit := True;
        End
     Else
         Begin
              BankRecGrid.Cells[1,LocalLine] := '';
              BankRecGrid.Cells[2,LocalLine] := TempSt;
              Debit := False;
         End;

     GetItem ( TxFile, 26 );
     BankRecGrid.Cells[3,LocalLine] := CurrStr;

     BankRecGrid.Cells[6,LocalLine] := '';
     BankRecGrid.Cells[7,LocalLine] := '';
     BankRecGrid.Cells[8,LocalLine] := '';
     GetItem ( TxFile, 27 );
     If CurrStr = 'P' Then
        BankRecGrid.Cells[6,LocalLine] := CurrStr
     Else If CurrStr = 'U' Then
        Begin
           BankRecGrid.Cells[7,LocalLine] := CurrStr;
           If Debit Then
              vTotalUnReceipts := vTotalUnReceipts + Amount
           Else
              vTotalUnPayments := vTotalUnPayments + Amount;
        End
     Else If CurrStr = 'E' Then
        BankRecGrid.Cells[8,LocalLine] := CurrStr;

     { Store the original status }
     BankRecGrid.Cells[9,LocalLine] := CurrStr; 
     GetItem ( TxFile, 2 );
     BankRecGrid.Cells[4,LocalLine] := CurrStr;

     GetItem ( TxFile, 5 );
     BankRecGrid.Cells[5,LocalLine] := CurrStr;
End;

Procedure TBankRecForm.FillGrid ( FTx, LTx, BankNo : Integer );
Var
   GridPos,
   TxNo : Integer;
   IncludeRec : Boolean;
   ThisStat,
   TempSt : ShortString;
Begin
     DateFrom := -32765;
     DateTo   := 32765;
     If DateValid ( TxDateFrom.Text, TDateFormat ) Then
        DateFrom := Trunc ( Daytot-32000 );
     If DateValid ( TxDateTo.Text, TDateFormat ) Then
        DateTo := Trunc ( Daytot-32000 );

     vTotalUnReceipts := 0;
     vTotalUnPayments := 0;
     SetDb ( TxFile );
     TxNo := FTx;
     GridPos := 1;

     If FTx > 0 Then
        Begin
             TxNo := FTx;
             While ( TxNo <= LTx ) And ( TxNo <> 0 ) Do
                   Begin
                        ReadRec ( TxFile, TxNo );
                        If errorno > 0 Then DbErr;

                        If RecActive ( TxFile ) Then
                          Begin
                            ThisStat := '';
                            If RecordOK ( ThisStat ) Then
                               Begin
                                  GetItem ( TxFile, 2 );
                                  IncludeRec := (( CurrInt <= DateTo ) and ( DateFrom <= CurrInt )) Or    // TGM AB 19/02/16 was ( CurrInt <= DateTo )
                                                ( CurrInt < DateFrom ) And ( ThisStat = 'P' );
                                  If IncludeRec Then
                                     Begin
                                        DispOutput ( TxNo, GridPos, BankNo );
                                        Inc ( GridPos );
                                     End;
                               End;

                            GetItem ( TxFile, 18 );
                            If CurrInt = BankNo Then
                               GetInt ( TxFile, 13, TxNo )
                            Else
                                Begin
                                     GetItem ( TxFile, 19 );
                                     If CurrInt = BankNo Then
                                        GetInt ( TxFile, 14, TxNo )
                                     Else
                                         Inc ( TxNo );
                                End;
                          End
                        Else
                            Inc ( TxNo );
                   End;
             LongStr ( vTotalUnReceipts, TempSt, 'L' );
             TotalUnReceipts.Text := TempSt;
             LongStr ( vTotalUnPayments, TempSt, 'L' );
             TotalUnPayments.Text := TempSt;
             LongStr ( ClosingBalance, TempSt, 'L' );
             LongStr ( LBankBalance+vTotalUnPayments-vTotalUnReceipts, TempSt, 'L' );
             BankBalance.Text := TempSt;

             {
             LongStr ( BankBalance-(ClosingBalance-TotalUnPayments+TotalUnReceipts), TempSt, 'L' );
             }
             CalcError;
             {LongStr ( LBankBalance-(LRunningBalance-TotalUnPayments+TotalUnReceipts), TempSt, 'L' );
             BankRecForm.RecError.Text := TempSt;}
        End;

     UpdateGridTxNos; // TGM AB 04/01/13

End;

Procedure TBankRecForm.GetBankInfo ( BankNo : Integer );
Var
   FoundBank   : Boolean;
   TempSt      : ShortString;
   I : integer;
Begin
     Accsdatamodule.BankTableDB.open;
     BankAccount := BankNo;   // Sets global varible which holds bank account
     FoundBank := False;

     Accsdatamodule.BankTableDB.first;

     For i := 1 to Accsdatamodule.BankTableDB.recordcount do begin
         if Accsdatamodule.BankTableDB['BankCode'] = BankAccount then begin
            FoundBank := True;

            LastBalance := Accsdatamodule.BankTableDB['Balance'] * 100;
            LongStr ( LastBalance, TempSt,'L' );
            {BankRecForm.BankBalance.Text := TempSt;}
            TempSt := UserStatementBalance.Text;
            SlimAll ( TempSt );
            if ( Length (TempSt) = 0 ) Or ( LastBank <> BankNo ) Then
                    begin
                         LongStr ( LastBalance, TempSt,'L' );
                         UserStatementBalance.Text := TempSt;
                         StrLong ( TempSt, ClosingBalance );
                         LastBank := BankNo;
                    end;
         end;
         Accsdatamodule.BankTableDB.next;
     end;

     If not FoundBank Then { Add a new record }
        Begin
              Accsdatamodule.BankTableDB.append;
              Accsdatamodule.BankTableDB['BankCode'] := BankAccount;
              Accsdatamodule.BankTableDB['Balance'] := 0;
              Accsdatamodule.BankTableDB.post;
              {BankRecForm.BankBalance.Text := '0';}
              UserStatementBalance.Text := '0';
        End;


(*     LastBalance := 0;
     FoundBank := False;
     BankFileRec := 0;
     FillChar ( BankR, SizeOf ( BankR ), chr(0));
     ReSet ( BankFile );
     Seek ( BankFile, BankFileRec );
     {
     If NOT Eof ( BankFile ) Then
        Read ( BankFile, BankR );
     }
     Repeat
     {While NOT eof ( BankFile ) Do}
        if ( NOT Eof ( BankFile )) And ( NOT FoundBank ) then
          begin
            Read ( BankFile, BankR );

            if BankR.BankCode = BankNo Then
              begin
                 LastBalance := PSysLongToDelphi ( BankR.Balance );
                 LongStr ( LastBalance, TempSt,'L' );
                 {BankRecForm.BankBalance.Text := TempSt;}
                 TempSt := UserStatementBalance.Text;
                 SlimAll ( TempSt );
                 if ( Length (TempSt) = 0 ) Or ( LastBank <> BankNo ) Then
                    begin
                         LongStr ( LastBalance, TempSt,'L' );
                         UserStatementBalance.Text := TempSt;
                         StrLong ( TempSt, ClosingBalance );
                         LastBank := BankNo;
                    end;
                 Seek ( BankFile, FileSize(BankFile) );
                 FoundBank := True;
              end
            else
              begin
                 Inc ( BankFileRec );
                 Seek ( BankFile, BankFileRec );
                 {Read ( BankFile, BankR );}
              end;
          end;
     Until ( Eof ( BankFile )) Or ( FoundBank );
     //Until ( Eof ( BankFile ) );

     If NOT FoundBank Then { Add a new record }
        Begin
           BankFileRec := FileSize ( BankFile );
           Seek ( BankFile, BankFileRec );
           BankR.BankCode := BankNo;
           FillChar ( BankR.Balance, SizeOf ( BankR.Balance ), chr(0));
           Write ( BankFile, BankR );
           {BankRecForm.BankBalance.Text := '0';}
           UserStatementBalance.Text := '0';
        End;
  *)
End;

Function TBankRecForm.ShowInfo ( Bank : String ) : Boolean;
Var
   FirstTx,
   LastTx,
   BankNo   : Integer;
   TempSt   : ShortString;

Begin
     BankNo := StrToInt ( Bank );
     GetBankInfo ( BankNo );

     SetDb ( NlFile );
     ReadRec ( NlFile, BankNo );
     If errorno > 0 Then dbErr;
     If RecActive ( NlFile ) Then
        Begin
             GetInt ( NlFile, 14, FirstTx );
             If ( FirstTx = 0 ) Then
                GetInt ( NlFile, 15, FirstTx );
             GetInt ( NlFile, 16, LastTx );
      (*       if LastTX > 0 then begin   // TGM AB - fixes prob with FirstTx not always being set by new year end routine.
                 if FirstTx = 0 then FirstTx := 1;
             end;    *)
             GetItem ( NlFile, 2 );             { Bank Balance }
             LBankBalance := CurrLong;
             LongStr ( LBankBalance, TempSt, 'L' );
             CurrentBalance.Text := TempSt;
             FillGrid ( FirstTx, LastTx, BankNo );
             ShowInfo := True;
        End
     Else
         ShowInfo := False;
End;

procedure TBankRecForm.ExitClick(Sender: TObject);
begin
     StartBankRec.Enabled:= true;     
     Close;
end;

procedure TBankRecForm.FormActivate(Sender: TObject);
begin
     pFilters.Hide;
     Caption := 'Bank Reconciliation';
     Exit.Caption := ReadLang ( 1, CurrLang );
     BankRecGrid.Hide;
     SaveChequeStatus.Hide;
     StartBankRec.enabled := true;
     Continue.Hide;
     pBalances.Hide;
     LastBank := 0;
//     OpenBank;
     InfoSaved := False;
     BankRecGrid.Cells[0,0] := 'Trans';
     BankRecGrid.Cells[1,0] := 'Receipt';
     BankRecGrid.Cells[2,0] := 'Payment';
     BankRecGrid.Cells[3,0] := 'Stub No';
     BankRecGrid.Cells[4,0] := 'Date';
     BankRecGrid.Cells[5,0] := 'Comment';
     BankRecGrid.Cells[6,0] := 'P';
     BankRecGrid.Cells[7,0] := 'U';
     BankRecGrid.Cells[8,0] := 'E';
     BankRecGrid.ColWidths[8] := 0;  // TGM AB 15/08/02 - Removing E Column
     BankRecGrid.ColWidths[9] := 0;  // TGM AB 16/12/12 - Hide the 'Current Status' column
     BankRecGrid.Cells[10,0] := 'Bank TX'; // TGM AB 14/12/12 adding extra column which will keep actual Tx Number 'Trans' will now list the effective Transaction first Tx number
     BankRecGrid.ColWidths[10] := 0;  // hide bank tx column
     BankRecGrid.FixedColor := clWhite;
     BankCode.Text := IntToStr ( Cash1.xLastBank );
     UserStatementBalance.Text := '';
end;

procedure TBankRecForm.BankCodeDblClick(Sender: TObject);
begin

     NewListBox.ListIt ( Sender, Banks, 'N' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        BankCode.Text := NewListBox.ListInfo.ReturnValue;
     BankCode.SetFocus;
end;

procedure TBankRecForm.BankCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Key = VK_F2 Then
        Begin
             NewListBox.ListIt ( Sender, Banks, 'N' );
             If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
                BankCode.Text := NewListBox.ListInfo.ReturnValue;
        End;
end;

procedure TBankRecForm.StartBankRecClick(Sender: TObject);
Var
   TempSt : ShortString;
begin
     If Numeric ( BankCode.Text ) Then
        If ( StrToInt ( BankCode.Text ) >= Cash1.xBankMin ) And
           ( StrToInt ( BankCode.Text ) <= Cash1.xBankMax ) Then
           Begin
                Chkcomp.AutomatedBackup;
                TempSt := UserStatementBalance.Text;
                If ChangeToLong ( TempSt ) Then
                   Begin
                        StrLong ( TempSt, LRunningBalance );
                        UserStatementBalance.Text := TempSt;
                        RunningBalance.Text := TempSt;
                   End
                Else
                    UserStatementBalance.SetFocus;

                BankRecGrid.Rowcount := 2;
                BankRecGrid.Cells[0,1] := '';
                BankRecGrid.Cells[1,1] := '';
                BankRecGrid.Cells[2,1] := '';
                BankRecGrid.Cells[3,1] := '';
                BankRecGrid.Cells[4,1] := '';
                BankRecGrid.Cells[5,1] := '';
                BankRecGrid.Cells[6,1] := '';
                BankRecGrid.Cells[7,1] := '';
                BankRecGrid.Cells[8,1] := '';
                BankRecGrid.Cells[9,1] := '';
                BankRecGrid.Cells[10,1] := '';  // TGM AB 14/12/12
                BankRecGrid.FixedRows := 1;
                If ShowInfo ( BankCode.Text ) Then
                   Begin
                        BankRecGrid.Show;
                        SaveChequeStatus.Show;
                        Continue.show;
                        pBalances.Show;
                   End;
           End;
           StartBankRec.Enabled:= false;
end;

Procedure TBankRecForm.CalcRecError ( Row : Integer; AddIt : Boolean );
Var
   TempLong : Long;
   TempSt   : ShortString;
   Receipt  : Boolean;
Begin
     Receipt := True;
     TempSt := BankRecGrid.Cells[1,Row];
     SlimAll ( TempSt );
     If Length ( TempSt ) = 0 Then
        Begin
             TempSt := BankRecGrid.Cells[2,Row];
             SlimAll ( TempSt );
             Receipt := False;
        End;
     StrLong ( TempSt, TempLong );
     If AddIt Then
        Begin
           If Receipt Then
              Begin
                 vTotalUnReceipts := vTotalUnReceipts + TempLong;
                 LRunningBalance := LRunningBalance - TempLong;
              End
           Else
              Begin
                 vTotalUnPayments := vTotalUnPayments + TempLong;
                 LRunningBalance := LRunningBalance + TempLong;
              End;
        End
     Else
        Begin
           If Receipt Then
              Begin
                 vTotalUnReceipts := vTotalUnReceipts - TempLong;
                 LRunningBalance := LRunningBalance + TempLong;
              End
           Else
              Begin
                 vTotalUnPayments := vTotalUnPayments - TempLong;
                 LRunningBalance := LRunningBalance - TempLong;
              End;
        End;

     {
     LongStr ( BankBalance-(ClosingBalance-TotalUnPayments+TotalUnReceipts), TempSt, 'L' );
     }
     LongStr ( vTotalUnPayments, TempSt, 'L' );
     TotalUnPayments.Text := TempSt;
     LongStr ( vTotalUnreceipts, TempSt, 'L' );
     TotalUnReceipts.Text := TempSt;

     LongStr ( LBankBalance+vTotalUnPayments-vTotalUnReceipts, TempSt, 'L' );
     BankBalance.Text := TempSt;

     CalcError;
     LongStr ( LRunningBalance, TempSt, 'L' );
     RunningBalance.Text := TempSt;
End;

Procedure TBankRecForm.BankRecGridDblClick(Sender: TObject);
begin
     case BankRecGrid.Col of
          6 : Begin
                   BankrecGrid.Cells[BankrecGrid.Col,BankrecGrid.Row] := 'P';
                   If BankRecGrid.Cells[9,BankRecGrid.Row] = 'U' Then
                      CalcRecError ( BankRecGrid.Row, False );
                   BankrecGrid.Cells[7,BankrecGrid.Row] := ' ';
                   BankrecGrid.Cells[8,BankrecGrid.Row] := ' ';
                   BankrecGrid.Cells[9,BankrecGrid.Row] := 'P';
              End;
          7 : Begin
                   BankrecGrid.Cells[BankrecGrid.Col,BankrecGrid.Row] := 'U';
                   If BankRecGrid.Cells[9,BankRecGrid.Row] = 'P' Then
                      CalcRecError ( BankRecGrid.Row, True );
                   BankrecGrid.Cells[6,BankrecGrid.Row] := ' ';
                   BankrecGrid.Cells[8,BankrecGrid.Row] := ' ';
                   BankrecGrid.Cells[9,BankrecGrid.Row] := 'U';
              End;
          8 : Begin
                   BankrecGrid.Cells[BankrecGrid.Col,BankrecGrid.Row] := 'E';
                   BankrecGrid.Cells[6,BankrecGrid.Row] := ' ';
                   BankrecGrid.Cells[7,BankrecGrid.Row] := ' ';
              end;
     end;
end;

procedure TBankRecForm.RecErrorChange(Sender: TObject);
Var
   TempLong : Long;
   TempSt   : ShortString;
begin
     TempSt := RecError.Text;
     SlimAll ( TempSt );
     StrLong ( TempSt, TempLong );
     If ( TempLong <> 0 ) Then
        ColRecError.Color := clRed
     Else
        ColRecError.Color := clGreen;
end;

procedure TBankRecForm.UserStatementBalanceExit(Sender: TObject);
Var
   TempSt : ShortString;
begin
     ClosingBalance := 0;
     TempSt := UserStatementBalance.Text;
     If ChangeToLong ( TempSt ) Then
        Begin
             StrLong ( TempSt, LRunningBalance );
             UserStatementBalance.Text := TempSt;
             RunningBalance.Text := TempSt;
        End
     Else
        UserStatementBalance.SetFocus;
end;

procedure TBankRecForm.BankCodeExit(Sender: TObject);
begin
     if Numeric ( BankCode.Text ) Then
        if ( StrToInt ( BankCode.Text ) >= Cash1.xBankMin ) And
           ( StrToInt ( BankCode.Text ) <= Cash1.xBankMax ) Then
           GetBankInfo ( StrToInt ( BankCode.Text ) );
end;


//procedure TBankRecForm.SaveClick(Sender: TObject);
//begin
  (*
    { Save bank info back to temp file }
    Seek ( BankFile, BankFileRec );
    Read ( BankFile, BankR );
    {TempSt := RunningBalance.Text;}
    {StrLong ( TempSt, TempLong );}
    DelphiLongToPSys ( LRunningBalance, BankR.Balance );

    Seek ( BankFile, BankFileRec );
    Write ( BankFile, BankR );
    CloseFile ( BankFile );
    *)
// end;


procedure TBankRecForm.SaveChequeStatusClick(Sender: TObject);
Var
   RecToRead,
   LoopCount,
   LastGrid  : Integer;
   ReWriteOk : Boolean;
   TestGrid  : ShortString;
   i : integer;
begin
  (*
     StartBankRec.Enabled:= true;
     InFoSaved := True;
     Seek ( BankFile, BankFileRec );
     Read ( BankFile, BankR );
     LRunningBalance := ((LRunningBalance+100)-100);
     DelphiLongToPSys ( LRunningBalance, BankR.Balance );

     Seek ( BankFile, BankFileRec );
     Write ( BankFile, BankR );
    *)

     Accsdatamodule.BankTableDB.first;

     For i := 1 to Accsdatamodule.BankTableDB.recordcount do begin
         if Accsdatamodule.BankTableDB['BankCode'] = BankAccount then begin
            Accsdatamodule.BankTableDB.edit;
            LRunningBalance := ((LRunningBalance+100)-100);
            try Accsdatamodule.BankTableDB['Balance'] := (LRunningBalance/100);
            except Accsdatamodule.BankTableDB['Balance'] := 0;
            end;
            Accsdatamodule.BankTableDB.post;
            InFoSaved := True;
         end;
         Accsdatamodule.BankTableDB.next;
     end;

     { Scan the Grid and set the Status Flag to whichever is checked }
     SetDb ( TxFile );
     LastGrid := BankRecGrid.RowCount-1;
     For LoopCount := 1 To LastGrid Do
       Begin
         TestGrid := BankRecGrid.Cells[10,LoopCount];       // Was column 0 TGM AB 23/08/13
         SlimAll ( TestGrid );
         If Numeric ( TestGrid ) Then
            Begin
                RecToRead := StrToInt ( TestGrid );
                If ( RecToRead > 0 ) Then
                   Begin
                       ReadRec ( TxFile, RecToRead );
                       If errorno > 0 Then DbErr;
                       If RecActive ( TxFile ) Then
                          Begin
                              SetItem;
                              ReWriteOk := False;
                              If BankRecGrid.Cells[6,LoopCount] = 'P' Then
                                 Begin
                                    CurrStr := 'P';
                                    ReWriteOK := True;
                                 End
                              Else If BankRecGrid.Cells[7,LoopCount] = 'U' Then
                                 Begin
                                    CurrStr := 'U';
                                    ReWriteOK := True;
                                 End
                              Else If BankRecGrid.Cells[8,LoopCount] = 'E' Then
                                 Begin
                                    CurrStr := 'E';
                                    ReWriteOK := True;
                                 End;
                              If ReWriteOK Then
                                 Begin
                                    PutStr ( TxFile, CurrStr, 27 );
                                    ReWriteRec ( TxFile, RecToRead );
                                    If ErrorNo > 0 Then DbErr;
                                 End;
                          End;
                   End;
            End;
       End;
     ExitClick(Sender);

end;

procedure TBankRecForm.RunningBalanceExit(Sender: TObject);
Var
   TempSt : ShortString;
begin
     TempSt := RunningBalance.Text;
     If ChangeToLong ( TempSt ) Then
        Begin
             StrLong ( TempSt, LRunningBalance );
             RunningBalance.Text := TempSt;
             CalcError;
        End
     Else
        RunningBalance.SetFocus;
end;

procedure TBankRecForm.StubFromExit(Sender: TObject);
Var
   TempSt : ShortString;
begin
     TempSt := StubFrom.Text;
     SlimAll ( TempSt );
     If Numeric ( TempSt ) Then
        LStubFrom := StrToInt ( TempSt );
end;

procedure TBankRecForm.StubToExit(Sender: TObject);
Var
   TempSt : ShortString;
begin
     TempSt := StubTo.Text;
     SlimAll ( TempSt );
     If Numeric ( TempSt ) Then
        LStubTo := StrToInt ( TempSt );
end;

procedure TBankRecForm.BankCodeChange(Sender: TObject);
begin
     InfoSaved := False;
     BankRecGrid.Hide;
     SaveChequeStatus.Hide;
     Continue.hide;
     StartBankRec.Enabled := true;
end;

procedure TBankRecForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    if NOT InfoSaved then
       if MessageDlg('Save Bank Reconciliation changes', mtInformation,[mbYes,mbNo], 0) = mrYes Then
          SaveChequeStatusClick(Sender);

    // Make sure the BankFile.DAT is closed
   // CloseFile ( BankFile );
end;

procedure TBankRecForm.TxDateFromExit(Sender: TObject);
begin
     KDateFromExit ( Sender, Report );
end;

procedure TBankRecForm.DateSearchFromCloseUp(Sender: TObject);
begin
     TxDateFrom.Text:= DateToStr(DateSearchFrom.Date);
     TxDateFrom.SetFocus;
end;

procedure TBankRecForm.DateSearchFromDropDown(Sender: TObject);
begin
   DateSearchFrom.Date := KStrToDate (Cash11.Default_Date);
end;

procedure TBankRecForm.TxDateToExit(Sender: TObject);
begin
    KDateToExit ( Sender, Report );
end;

procedure TBankRecForm.DateSearchToCloseUp(Sender: TObject);
begin
     TxDateTo.Text:= DateToStr(DateSearchTo.Date);
     TxDateTo.SetFocus;
end;

procedure TBankRecForm.DateSearchToDropDown(Sender: TObject);
begin
    DateSearchTo.Date := KStrToDate (Cash11.Default_Date);
end;

procedure TBankRecForm.FormShow(Sender: TObject);
begin
     DateSearchTo.Date := KStrToDate (Cash11.Default_Date);
     DateSearchFrom.Date := KStrToDate (Cash11.Default_Date);
     BankCode.Text := '';
end;

procedure TBankRecForm.HelpClick(Sender: TObject);
begin
     //Application.HelpContext(87);
     AccsDataModule.HTMLHelp('yourFirstBankReconciliation.htm');
end;

procedure TBankRecForm.BitBtn1Click(Sender: TObject);
begin
    if pFilters.Showing then
       pFilters.Hide
    else
       begin
          pFilters.Show;
          ShowMessage('Care must be taken when using filters' + #13#13 +
                      'Unpresented Cheques may be excluded by' + #13 +
                      '1. the Date range chosen' + #13 +
                      '2. the Stub No chosen' + #13 +
                      '3. the Unpresented check box being ticked');
       startbankRec.Enabled := true;
       end;

end;

procedure TBankRecForm.SearchBoxChange(Sender: TObject);
var i : integer;
    found : boolean;
begin
     found := false;
     if length(searchbox.text) > 0 then begin
         for i := 1 to BankRecGrid.Rowcount do begin
             if not found then begin
                if (BankRecGrid.Cells[1,i] = SearchBox.text + ' ') then begin
                   found := true;
                   BankRecGrid.Col := 6;
                   BankRecGrid.Row := i;
                end;
                if (BankRecGrid.Cells[2,i] = SearchBox.text + ' ') then begin
                   found := true;
                   BankRecGrid.Col := 6;
                   BankRecGrid.Row := i;
                end;
                if (BankRecGrid.Cells[3,i] = SearchBox.text) then begin
                   found := true;
                   BankRecGrid.Col := 6;
                   BankRecGrid.Row := i;
                end;
             end;
         end;
     end;
end;

procedure TBankRecForm.ContinueClick(Sender: TObject);
Var
   RecToRead,
   LoopCount,
   LastGrid  : Integer;
   ReWriteOk : Boolean;
   TestGrid  : ShortString;
   i : integer;
begin

    Accsdatamodule.BankTableDB.first;

     For i := 1 to Accsdatamodule.BankTableDB.recordcount do begin
         if Accsdatamodule.BankTableDB['BankCode'] = BankAccount then begin
            Accsdatamodule.BankTableDB.edit;
            LRunningBalance := ((LRunningBalance+100)-100);
            try Accsdatamodule.BankTableDB['Balance'] := (LRunningBalance/100);
            except Accsdatamodule.BankTableDB['Balance'] := 0;
            end;
            Accsdatamodule.BankTableDB.post;
            InFoSaved := True;
         end;
         Accsdatamodule.BankTableDB.next;
     end;

 (*    InFoSaved := True;
     Seek ( BankFile, BankFileRec );
     Read ( BankFile, BankR );
     DelphiLongToPSys ( LRunningBalance, BankR.Balance );

     Seek ( BankFile, BankFileRec );
     Write ( BankFile, BankR );
  *)
     { Scan the Grid and set the Status Flag to whichever is checked }
     SetDb ( TxFile );
     LastGrid := BankRecGrid.RowCount-1;
     For LoopCount := 1 To LastGrid Do
       Begin
         TestGrid := BankRecGrid.Cells[10,LoopCount];  // Was column 0 TGM AB 04/01/13
         SlimAll ( TestGrid );
         If Numeric ( TestGrid ) Then
            Begin
                RecToRead := StrToInt ( TestGrid );
                If ( RecToRead > 0 ) Then
                   Begin
                       ReadRec ( TxFile, RecToRead );
                       If errorno > 0 Then DbErr;
                       If RecActive ( TxFile ) Then
                          Begin
                              SetItem;
                              ReWriteOk := False;
                              If BankRecGrid.Cells[6,LoopCount] = 'P' Then
                                 Begin
                                    CurrStr := 'P';
                                    ReWriteOK := True;
                                 End
                              Else If BankRecGrid.Cells[7,LoopCount] = 'U' Then
                                 Begin
                                    CurrStr := 'U';
                                    ReWriteOK := True;
                                 End
                              Else If BankRecGrid.Cells[8,LoopCount] = 'E' Then
                                 Begin
                                    CurrStr := 'E';
                                    ReWriteOK := True;
                                 End;
                              If ReWriteOK Then
                                 Begin
                                    PutStr ( TxFile, CurrStr, 27 );
                                    ReWriteRec ( TxFile, RecToRead );
                                    If ErrorNo > 0 Then DbErr;
                                 End;
                          End;
                   End;
            End;
       End;
       UserStatementBalance.Text := RunningBalance.text;
       StartBankRecClick(sender);

end;


procedure TBankRecForm.UpdateGridTxNos;
var
    i : integer;
    tempstring : shortstring;
begin
    // TGM AB 21/12/12

    FirstTxYear := FullAudit.AuditFiles.FirstTxThisYear;

    for i := 1 to BankRecGrid.Rowcount-1 do begin // 1st line is the header
        tempstring := BankRecGrid.Cells[10,i]; //:= BankRecGrid.Cells[10,i] + 'A';
        slimall(tempstring);
        if tempstring <> '' then
           try
              BankRecGrid.Cells[0,i] := inttostr(FindFirstTxNumber(strtoint(tempstring)));
           except
              on e : Exception do
                 ShowMessage(e.Message);
           end;
    end;
end;

function TBankRecForm.FindFirstTxNumber(TxNo : Integer) : Integer;
var
    TxType, OrigType, RecNo : Integer;
    FirstFound : Boolean;
    NewOrigType, NewTxType : Integer;
begin
    // TGM AB 04/01/13

    TxType := -1;
    OrigType := -1;
    AccsDatamodule.TransactionsDB.Locate('TxNo',TxNo,[]);
    TxType := AccsDatamodule.TransactionsDB['TxType'];
    OrigType := AccsDatamodule.TransactionsDB['OrigType'];

    if ( TxNo < FirstTxYear ) then
       Result := TxNo
    else if ( TxType = Origtype ) then
       Result := TxNo
    else if OrigType = 0 then
       Result := TxNo
    else
       begin
          FirstFound := False;
          while ( not(FirstFound) ) do
             begin
                AccsDatamodule.TransactionsDB.prior;
                if ( AccsDatamodule.TransactionsDB['TxType'] = OrigType ) then
                   begin
                      FirstFound := True;
                      Result := AccsDatamodule.TransactionsDB['TxNo'];
                   end;
             end;
       end;
end;

end.
