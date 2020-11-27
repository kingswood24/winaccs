{
   24/02/17 [V4.2 R7.1] /MK Additional Feature - Add email statement button which saves statement for selected accounts only - GL request.
                                                 *NOTE* - Email of statements sets iAccType to 4. iAccType is also set by AccountsBox.ItemIndex.

   23/09/19 [V4.5 R0.6] /MK Bug Fix - FormActivate - Only show Extended Statement button if Prog is Statement.
}

unit Stat;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, NewClass, Mask, Grids,
  ComCtrls, RXSpin, cxButtons, QRExportHelper, uEmailTemplates, uEmailEntityInfo,
  cxControls, dxStatusBar, FileCtrl, AccsUtils;

type
  TStatementForm = class(TKingForm)
    StatementPanel: TPanel;
    ReportDate: TLabel;
    Panel1: TPanel;
    Help: TBitBtn;
    Run: TBitBtn;
    btnExit: TBitBtn;
    AccType: TEdit;
    LedgerCardsOnlyPanel: TPanel;
    IncBalance: TCheckBox;
    RecordCardsOnlyPanel: TPanel;
    InvoiceSubTotal: TCheckBox;
    NewPage: TCheckBox;
    PerUnit: TCheckBox;
    TotalSelected: TCheckBox;
    Panel2: TPanel;
    VReports: TRadioButton;
    PReports: TRadioButton;
    AccGrid: TStringGrid;
    RepDate: TMaskEdit;
    DateSearch: TDateTimePicker;
    AccountsBox: TRadioGroup;
    PrintBox: TRadioGroup;
    Panel3: TPanel;
    AccFromLabel: TLabel;
    AccFrom: TEdit;
    CustAccounts: TSpeedButton;
    Label5: TLabel;
    DateFrom: TMaskEdit;
    DateSearchFrom: TDateTimePicker;
    Label6: TLabel;
    DateTo: TMaskEdit;
    DateSearchTo: TDateTimePicker;
    SpeedButton1: TSpeedButton;
    AccTo: TEdit;
    AccToLabel: TLabel;
    PrintFrom: TRxSpinEdit;
    Label2: TLabel;
    DoubleSpace: TCheckBox;
    RecCardsOnly: TPanel;
    NomAccFrom: TEdit;
    NomAccFromButton: TSpeedButton;
    RangeFromButton: TSpeedButton;
    RangeFrom: TEdit;
    AnalFromLabel: TLabel;
    NomAccFromLabel: TLabel;
    NomAccToButton: TSpeedButton;
    NomAccTo: TEdit;
    NomAccToLabel: TLabel;
    AnalToLabel: TLabel;
    RangeTo: TEdit;
    RangeToButton: TSpeedButton;
    Searchlabel: TLabel;
    Searchfield: TEdit;
    Label3: TLabel;
    eAltName1: TEdit;
    eAltName2: TEdit;
    Label7: TLabel;
    ShowEuroTotals: TCheckBox;
    GreaterThanBalance: TEdit;
    PrePrintedStationary: TCheckBox;
    AgeByLabel: TLabel;
    AgeByCombo: TComboBox;
    AreaCodePanel: TPanel;
    AreaCodeTo: TMaskEdit;
    Label4: TLabel;
    AreaCodeFrom: TMaskEdit;
    Label1: TLabel;
    LastYearsPanel: TPanel;
    Label8: TLabel;
    IncludeLastYearsTx: TCheckBox;
    UseNew: TCheckBox;
    CBExtendedStatement: TCheckBox;
    GroupBox1: TGroupBox;
    GroupExtendedConditions: TRadioGroup;
    CBExtendedSubTotals: TCheckBox;
    CBExtendedShowPerUnit: TCheckBox;
    ExtAltName1: TEdit;
    Label9: TLabel;
    ExtAltName2: TEdit;
    Label10: TLabel;
    UseInvoiceDetailsCB: TCheckBox;
    bStatementSetup: TButton;
    btnEmailStatement: TcxButton;
    StatusBar: TdxStatusBar;
    ClearTimer: TTimer;
    procedure AccFromKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AccToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RunClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure NomAccFromKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NomAccToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AreaCodeFromExit(Sender: TObject);
    procedure AreaCodeToExit(Sender: TObject);
    procedure NomAccFromExit(Sender: TObject);
    procedure NomAccToExit(Sender: TObject);
    procedure RepDate1Exit(Sender: TObject);
    procedure VReportsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure AccFromExit(Sender: TObject);
    procedure AccGridDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DateToExit(Sender: TObject);
    procedure DateFromExit(Sender: TObject);
    procedure DateSearchFromCloseUp(Sender: TObject);
    procedure DateSearchToCloseUp(Sender: TObject);
    procedure RepDateExit(Sender: TObject);
    procedure AccToExit(Sender: TObject);
    procedure AccountsBoxClick(Sender: TObject);
    procedure InitOnRangeChange;
    procedure CustAccountsClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure NomAccFromButtonClick(Sender: TObject);
    procedure NomAccToButtonClick(Sender: TObject);
    procedure RangeFromExit(Sender: TObject);
    procedure RangeToExit(Sender: TObject);
    procedure PrintBoxClick(Sender: TObject);
    procedure InvoiceSubTotalClick(Sender: TObject);
    procedure RangeFromButtonClick(Sender: TObject);
    procedure RangeToButtonClick(Sender: TObject);
    procedure DateSearchCloseUp(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure SearchfieldKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SearchfieldChange(Sender: TObject);
    procedure SearchfieldEnter(Sender: TObject);
    procedure bStatementSetupClick(Sender: TObject);
    procedure AgeByComboChange(Sender: TObject);
    procedure LoadDefaults;
    procedure SaveDefaults;
    procedure CBExtendedStatementClick(Sender: TObject);
    procedure btnEmailStatementClick(Sender: TObject);
  private
    procedure ClearStatusPanel;
    procedure UpdateStatusPanel(const AText : string; const AColor : TColor = clWindowText);
    procedure CheckForSelectedAccounts(var ARunReport : Boolean);
    procedure SetAccountAndReportType;
    { Private declarations }
  public
    { Public declarations }
    iAccType,             // Which Accounts to process 1 = All 2 = Range 3 = Selected 4 = Email Range
    iPrintType,           // Printing Conditions
    SCHANALF,
    SCHANALT,
    AreaFrom,
    AreaTo,
    iAccFrom,
    iAccTo     : Integer;
    HeadingDate : ShortString;
    PRLIST     : PACKED ARRAY[1..9999] OF INTEGER;
    TOTLIST    : Integer;
  end;

var
  StatementForm: TStatementForm;
  Gridpos,
  GridCol,
  GridRow : Integer;

implementation
uses
    DefSecFl,
    UTIL,
    LangUnit,
    DBCore,
    Vars,
    Types,
    Clears,
    Calcs,
    StmRep,
    NewRepUnit,
    FullAudit,
    NewListing,
    uStatementSetup,
    params,
    CalculateMonths,
    RcsList, AccsData, uLedgerReport;

{$R *.DFM}

Procedure FillGrid(Searchstring : string);
Var
   RecCount : Integer;
   tempstr: string;
Begin
   If NewRepForm.CustRadio.Checked then
      Begin
      //     SetDb(SlFile);
           GridRow := 1;
      //     For RecCount := 1 to db1.DbRecHigh do
           accsdatamodule.SLFileDB.first;
           For RecCount := 1 to accsdatamodule.SLFileDB.RecordCount do
               Begin
                  if accsdatamodule.SLFileDB['Active'] = True then begin
                     try tempstr := accsdatamodule.SLFileDB['Name'];
                     except tempstr := '';
                     end;
                     if searchstring <> '' then begin
                        if (pos(ansilowercase(searchstring),ansilowercase(tempstr)) <> 0) then begin
                            StatementForm.AccGrid.Cells[0,GridRow] := IntToStr ( RecCount );
                            StatementForm.AccGrid.Cells[1,GridRow] := tempstr;
                            StatementForm.AccGrid.Cells[2,GridRow] := 'No';
                            Inc ( GridRow );
                        end;
                        if (pos(ansilowercase(searchstring),vartostr(reccount)) <> 0) then begin
                            StatementForm.AccGrid.Cells[0,GridRow] := IntToStr ( RecCount );
                            StatementForm.AccGrid.Cells[1,GridRow] := tempstr;
                            StatementForm.AccGrid.Cells[2,GridRow] := 'No';
                            Inc ( GridRow );
                        end;
                     end
                        else begin
                                StatementForm.AccGrid.Cells[0,GridRow] := IntToStr ( RecCount );
                                StatementForm.AccGrid.Cells[1,GridRow] := tempstr;
                                StatementForm.AccGrid.Cells[2,GridRow] := 'No';
                                Inc ( GridRow );
                        end;
                  end;
                  accsdatamodule.SLFileDB.next;
                  {  ReadRec ( SlFile, RecCount );
                    DbErr;
                    If RecActive ( SlFile ) Then
                       Begin
                            StatementForm.AccGrid.Cells[0,GridRow] := IntToStr ( RecCount );
                            GetItem ( SlFile, 1 );
                            StatementForm.AccGrid.Cells[1,GridRow] := CurrStr;
                            StatementForm.AccGrid.Cells[2,GridRow] := 'No';
                            Inc ( GridRow );
                       End;}

               End;
      End
   Else
      Begin
    //       SetDb(PlFile);
           GridRow := 1;
           accsdatamodule.PLFileDB.first;
           For RecCount := 1 to accsdatamodule.PLFileDB.RecordCount do
    //       For RecCount := 1 to db1.DbRecHigh Do
               Begin
                   if accsdatamodule.PLFileDB['Active'] = True then begin
                     try tempstr := accsdatamodule.PLFileDB['Name'];
                     except tempstr := '';
                     end;
                     if searchstring <> '' then begin
                        if (pos(ansilowercase(searchstring),ansilowercase(tempstr)) <> 0) then begin
                            StatementForm.AccGrid.Cells[0,GridRow] := IntToStr ( RecCount );
                            StatementForm.AccGrid.Cells[1,GridRow] := tempstr;
                            StatementForm.AccGrid.Cells[2,GridRow] := 'No';
                            Inc ( GridRow );
                        end;
                        if (pos(ansilowercase(searchstring),vartostr(reccount)) <> 0) then begin
                            StatementForm.AccGrid.Cells[0,GridRow] := IntToStr ( RecCount );
                            StatementForm.AccGrid.Cells[1,GridRow] := tempstr;
                            StatementForm.AccGrid.Cells[2,GridRow] := 'No';
                            Inc ( GridRow );
                        end;
                     end
                        else begin
                                StatementForm.AccGrid.Cells[0,GridRow] := IntToStr ( RecCount );
                                StatementForm.AccGrid.Cells[1,GridRow] := tempstr;
                                StatementForm.AccGrid.Cells[2,GridRow] := 'No';
                                Inc ( GridRow );
                        end;
                  end;
                  accsdatamodule.PLFileDB.next;
                    {ReadRec ( PlFile, RecCount );
                    DbErr;
                    If RecActive ( PlFile ) Then
                       Begin
                            StatementForm.AccGrid.Cells[0,GridRow] := IntToStr ( RecCount );
                            GetItem ( PlFile, 1 );
                            StatementForm.AccGrid.Cells[1,GridRow] := CurrStr;
                            StatementForm.AccGrid.Cells[2,GridRow] := 'No';
                            Inc ( GridRow );
                       End;  }
               End;
      End;
   GridPos := GridRow;
   StatementForm.AccGrid.RowCount := GridRow
End;

procedure TStatementForm.AccFromKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If NewRepForm.CustRadio.Checked then
        KOnKeyDown ( Sender, Key, Shift, Customers, 'C')
     Else If NewRepForm.SuppRadio.Checked then
        KOnKeyDown ( Sender, Key, Shift, Suppliers, 'S');

    If Key = VK_F1 Then
       If NewRepForm.CustRadio.Checked then
          Application.HelpContext(2)
       Else If NewRepForm.SuppRadio.Checked Then
          Application.HelpContext(3);
end;

procedure TStatementForm.AccToKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If NewRepForm.CustRadio.Checked then
        KOnKeyDown ( Sender, Key, Shift, Customers, 'C')
     Else If NewRepform.SuppRadio.Checked Then
        KOnKeyDown ( Sender, Key, Shift, Suppliers, 'S');
     Try
        iAccTo := StrToInt ( AccTo.Text );
     except
           iAccTo := 1;
     End;

     If Key = VK_F1 Then
        if NewRepForm.CustRadio.Checked then
           Application.HelpContext(2)
        else if NewRepForm.SuppRadio.Checked Then
           Application.HelpContext(3);
end;

procedure TStatementForm.RunClick(Sender: TObject);
Var
   x : Integer;
   RunReport : Boolean;
begin
   CalculateMonths.UpdateSLFigures(strtodate(Repdate.text), AgeByCombo.ItemIndex);
   CalculateMonths.UpdatePLFigures(strtodate(Repdate.text), AgeByCombo.ItemIndex);
   RunReport := True;
   REPXDATE := RepDate.Text;  // Set the Global Report Date
   HeadingDate := RepDate.Text;
   SLIMALL(HeadingDate);
   AreaFrom := 0;
   AreaTo := 9999;

   SaveDefaults;

   SetAccountAndReportType();
   CheckForSelectedAccounts(RunReport);

   If ( RunReport ) then
     begin
        // TGM AB 11/03/16 removed NewReport Option (UseNew.checked = true)
        if ( (Act = 10) or (Act = 9) ) then
           begin
              if ( prog in [CustLed,SuppLed] ) then
                 LedgerReport.RunLedgerReport;
              if ( prog in [CustSTM,SuppSTM] ) then
                 LedgerReport.RunStatementReport;
           end
        else
           begin
              if ( PROG in [CustLED,SuppLED,CustSTM,SuppSTM] ) then
                 begin
                    if NewRepForm.CustRadio.Checked then
                       FullAudit.RunAuditFiles(4,iAccFrom,iAccTo,1,1,false)
                    else
                       FullAudit.RunAuditFiles(5,iAccFrom,iAccTo,1,1,false);
                 end;

              if ( NewRepForm.CustRadio.Checked ) Then
                 begin
                    //CustSuppReportForm.StatementRadio.Checked
                    if ( Act = 9 ) then
                       PROG := CustSTM
                    //CustSuppReportForm.RecordRadio.Checked
                    else if ( Act = 11 ) Then
                       begin
                          PROG := CustREC;
                          // Set the Analysis Code ranges
                          if RangeFrom.Text <> '' then
                             SchAnalF := StrToInt ( RangeFrom.Text );
                          if RangeTo.Text <> '' then
                             SchAnalT := StrToInt ( RangeTo.Text );
                          if StrToInt(AreaCodeTo.text) > 0 then
                             begin
                                AreaFrom := StrToInt ( AreaCodeFrom.text );
                                AreaTo := StrToInt ( AreaCodeTo.text );
                             end;
                       end
                    // Ledgers
                    else if ( Act = 10 ) then
                       PROG := CustLED
                    // Invoice Summary
                    else if ( Act = 911 ) then
                       begin
                          SetDB (NLFile);                                                    // TGM AB 16/12/16
                          RunAuditFiles ( NlFile, 1, db1.DBRECHIGH, 1, 0, False );           // TGM AB 16/12/16
                          SetDB (PLFile);                                                    // TGM AB 16/12/16
                          RunAuditFiles ( PlFile, 1, db1.DBRECHIGH, 1, 0, False );           // TGM AB 16/12/16
                          SetDB (SLFile);                                                    // TGM AB 16/12/16
                          RunAuditFiles ( SlFile, 1, db1.DBRECHIGH, 1, 0, False );           // TGM AB 16/12/16
                          PROG := CUSTSUM;                                                   // TGM AB 16/12/16
                       end;

                    if ( Prog = CustSTM ) then
                       begin
                          if ( StrToInt(AreaCodeTo.text) > 0 ) then
                             begin
                                AreaFrom := StrToInt ( AreaCodeFrom.text );
                                AreaTo := StrToInt ( AreaCodeTo.text );
                             end;
                       end;
                    STM ( SLFile );
                 end
              else
                 begin
                    //CustSuppReportForm.StatementRadio.Checked
                    if ( Act = 9 ) Then
                       PROG := SuppSTM
                    //CustSuppReportForm.RecordRadio.Checked
                    else if ( Act = 11 ) Then
                       begin
                          PROG := SuppREC;
                          // Set the Analysis Code ranges
                          if RangeFrom.Text <> '' then
                             SchAnalF := StrToInt ( RangeFrom.Text );
                          if RangeTo.Text <> '' then
                             SchAnalT := StrToInt ( RangeTo.Text );
                       end
                    else if ( Act = 10 ) then // Ledgers
                       PROG := SuppLED
                    else if ( Act = 911 ) then
                       begin
                          SetDB (NLFile);                                                    // TGM AB 16/12/16
                          RunAuditFiles ( NlFile, 1, db1.DBRECHIGH, 1, 0, False );           // TGM AB 16/12/16
                          SetDB (PLFile);                                                    // TGM AB 16/12/16
                          RunAuditFiles ( PlFile, 1, db1.DBRECHIGH, 1, 0, False );           // TGM AB 16/12/16
                          SetDB (SLFile);                                                    // TGM AB 16/12/16
                          RunAuditFiles ( SlFile, 1, db1.DBRECHIGH, 1, 0, False );           // TGM AB 16/12/16
                          PROG := SUPPSUM;                                                   // TGM AB 16/12/16
                       end;
                    if ( Prog = SuppSTM ) then
                       begin
                          if StrToInt(AreaCodeTo.text) > 0 then
                             begin
                                AreaFrom := StrToInt ( AreaCodeFrom.text );
                                AreaTo := StrToInt ( AreaCodeTo.text );
                             end;
                       end;
                    STM ( PLFile );
                 end;
           end;
     end;
end;

procedure TStatementForm.FormActivate(Sender: TObject);
var
   x : Integer;
begin
   btnEmailStatement.Visible := ( act = 9 );
   btnEmailStatement.Enabled := AccsDataModule.MailboxExists;
   Panel2.Visible := not NewRepForm.NewReports.Checked;
   GreaterThanBalance.text:='0.00';
   if Device = 'P' then
      PReports.Checked := True
   else
      VReports.Checked := True;

   RepDate.Text := Cash1.xDate;

   AreaFrom   := 0;
   AreaTo     := 9999;

   Searchfield.Text := '';

   if NewRepForm.CustRadio.Checked then
      SetDb ( SLFILE )
   else
      SetDb ( PLFILE );

   iAccFrom  := 1;
   iAccTo    := db1.dbrechigh;
   AccFrom.Text := '1';
   AccTo.Text := IntToStr(iAccTo);
   TotList   := 0;
   // next bit added by GM 08/06/01 - this resets the pointers (but not first and last transactions
   // before running the ledger cards.  This fixes any ledgers which have lost items due to bug elsewhere
   // this is only a workarround arround the bug.  Haven't fixed the bug which loses the transactions from
   // the ledger card in the first place.
   // One definate bug - when you edit a cash  purchase, subsequent entries (invoices or payments)
   // are lost on the ledger card.  I haven't fixed the bug casuing this but resetting the pointers below
   // sorts the ledger cards out, so it's not obvious to the user that a problem ever occurred. GM
   if ( not(PROG in [CustLED,SuppLED,CustSTM,SuppSTM]) ) then
      begin
         if ( NewRepForm.CustRadio.Checked ) then
            FullAudit.RunAuditFiles(4,iAccFrom,iAccTo,1,1,False)
         else
            FullAudit.RunAuditFiles(5,iAccFrom,iAccTo,1,1,False);
      end;

   //   23/09/19 [V4.5 R0.6] /MK Bug Fix - Only show Extended Statement button if Prog is Statement. 
   CBExtendedStatement.Visible := ( PROG in [CustSTM,SuppSTM] );

   AccFrom.Hint := ReadLang ( 141, CurrLang );
   AccTo.Hint := AccFrom.Hint;
   NomAccFrom.Hint := AccFrom.Hint;
   NomAccTo.Hint := AccFrom.Hint;

   AccFromLabel.Caption := 'Select Account';
   AccGrid.Show;
   Fillgrid('');
   AccTo.Hide;
   AccToLabel.Hide;
   Acctype.Text := '3';

   AccTo.Hide;
   AccToLabel.Hide;
   LedgerCardsOnlyPanel.Hide;
   RecordCardsOnlyPanel.Hide;
   RecCardsOnly.Hide;
   LastYearsPanel.hide;

   stat.StatementForm.Width := 670; //TGM AB 11/03/16

   if Prog In [CUSTLED,SUPPLED] then
      LedgerCardsOnlyPanel.Show
   else
       if PROG In [CUSTREC,SUPPREC,CUSTSUM,SUPPSUM] then
          RecordCardsOnlyPanel.Show;
   if PROG In [CUSTSUM,SUPPSUM] then
      DoubleSpace.Show
   else
      DoubleSpace.Hide;

   if Prog In [CUSTLED,SUPPLED,CUSTSTM,SUPPSTM] then LastYearsPanel.Show;

   SetDb ( NlFile );
   schrecf := 1;
   schrect := db1.dbrechigh;
   // Set the range for Nominal Accounts
   NomAccFrom.Text := IntToStr ( schrecf );
   NomAccTo.Text := IntToStr ( schrect );
   AreaCodeFrom.Text := '0';
   AreaCodeTo.Text := '9999';

   // Read the Print From line from the Cashbook.def
   LoadDefaults;

   // Set the PrintBox Radio Group to
   with PrintBox Do
      begin
         TotalSelected.Show;
         Items.Clear;
         if PROG In [CUSTSUM,SUPPSUM] then
            begin
               Items.Add('Full VAT Details');
               Items.Add('No VAT');
               Items.Add('No VAT on Detail lines');
               Items.Add('Price ex. VAT only');
               ItemIndex := 0;
               TotalSelected.Hide;
               TotalSelected.Checked := False;
               RecCardsOnly.Hide;
               GreaterThanBalance.visible:=false;
            end
         else
            begin
               Items.Add('All');
               Items.Add('With Balances Greater Than');
               Items.Add('With Balances Or Transactions');
               ItemIndex := 2;
               GreaterThanBalance.visible:=false;
            end;
         if PROG In [CUSTREC,SUPPREC] then
            RecCardsOnly.Show;
      end;

   AccountsBoxClick ( Sender );

   CBExtendedStatementClick(self); // TGM AB 18/03/16

   UpdateStatusPanel('');
end;

procedure TStatementForm.NomAccFromKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     KOnKeyDown ( Sender, Key, Shift, AllNoms, 'N');
end;

procedure TStatementForm.NomAccToKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     KOnKeyDown ( Sender, Key, Shift, AllNoms, 'N');
end;

procedure TStatementForm.AreaCodeFromExit(Sender: TObject);
Var
   st : ShortString;
begin
     st := AreaCodeFrom.Text;
     SlimAll ( st );
     If Numeric ( st ) Then
        AreaFrom := StrToInt ( St )
     Else
         AreaCodeFrom.SetFocus;
end;

procedure TStatementForm.AreaCodeToExit(Sender: TObject);
Var
   st : ShortString;
begin
     st := AreaCodeTo.Text;
     SlimAll ( st );
     If Numeric ( st ) Then
        AreaTo := StrToInt ( St )
     Else
         AreaCodeTo.SetFocus;   
end;

procedure TStatementForm.NomAccFromExit(Sender: TObject);
Var
   st : ShortString;
begin
     st := NomAccFrom.Text;
     SlimAll ( st );
     If Numeric ( st ) Then
        schrecf := StrToInt ( St )
     Else
        NomAccFrom.SetFocus;
end;

procedure TStatementForm.NomAccToExit(Sender: TObject);
Var
   st : ShortString;
begin
     st := NomAccTo.Text;
     SlimAll ( st );
     If Numeric ( st ) Then
        schrect := StrToInt ( St )
     Else
        NomAccTo.SetFocus;
end;

procedure TStatementForm.RepDate1Exit(Sender: TObject);
begin
     KDateValid ( Sender );
end;

procedure TStatementForm.VReportsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     KPrinterOrScreen ( Sender, Button, Shift, x, y );
end;


procedure TStatementForm.InitOnRangeChange;
begin
     If NewRepForm.CustRadio.Checked then
        SetDb ( SLFILE )
     Else
        SetDb ( PLFILE );
     iAccFrom  := 1;
     iAccTo    := db1.dbrechigh;
     SchAnalf  := 0;
     SchAnalt  := 9999;
     TotalSelected.Checked := False;
     TotalSelected.Hide;
end;

procedure TStatementForm.FormShow(Sender: TObject);
Var
   x : Integer;
Begin
   //  UseNew.Visible := false;           //  TGM AB 11/03/16
     Self.Agebylabel.visible := false;
     Self.AgeByCombo.Visible := false;
     Self.AgeByCombo.ItemIndex := 0;
     CustSuppListing.AgeByCombo.ItemIndex := 0;
     if Cash11.xSaveAsEuro = true then ShowEuroTotals.Visible := false  // TGM AB 22/01/16
        else ShowEuroTotals.Visible := true;                            // TGM AB 22/01/16
     CBExtendedStatement.checked := False;   // TGM AB 04/03/16
     ShowEuroTotals.checked:=false;
     RepDate.SetFocus;
     AccountsBox.ItemIndex := 2;
     DateTo.Text := '  /  /  ';
     DateFrom.Text := '  /  /  ';
     DateSearch.Date := StrToDate (Cash11.Default_Date);
     DateSearchFrom.Date := StrToDate (Cash11.Default_Date);
     DateSearchTo.Date := StrToDate (Cash11.Default_Date);
     AccType.Text := '';
     AccGrid.Cells[0,0] := 'Code';
     AccGrid.Cells[1,0] := 'Name';
     AccGrid.Cells[2,0] := 'Report ?';
     // Call the Initialisation procedure
     InitOnRangeChange;
     If Device = 'P' Then
        PReports.Checked := True
     Else
         VReports.Checked := True;
     RepDate.Text := Cash1.xDate;
     TxDateFrom := CDateFrom; // -32000;
     TxDateTo   := CDateTo;   // 32000;
     AreaFrom   := 0;
     AreaTo     := 0;
     TotList   := 0;
     For x := 1 To 9999 Do
         PRLIST[x] := 0;
     AccFrom.Hint := ReadLang ( 141, CurrLang );
     AccTo.Hint := AccFrom.Hint;
     NomAccFrom.Hint := AccFrom.Hint;
     NomAccTo.Hint := AccFrom.Hint;
     LedgerCardsOnlyPanel.Hide;
     RecordCardsOnlyPanel.Hide;
     AreaCodePanel.hide;
     if PROG In [CUSTLED,SUPPLED] then
        Begin
           Caption := 'Ledger Cards';{ + ' - ' + st;}
           LedgerCardsOnlyPanel.Show;
     //      UseNew.Visible := true;          //  TGM AB 11/03/16
        End
     Else if PROG In [CUSTREC,SUPPREC] then
        Begin
           Caption := 'Record Cards';{ + ' - ' + st;}
           RecordCardsOnlyPanel.Show;
           AreaCodePanel.show;
        End
     Else if PROG In [CUSTSUM,SUPPSUM] then
        Begin
           Caption := 'Invoice Summary';{ + ' - ' + st;}
           RecordCardsOnlyPanel.Show;
           AreaCodePanel.show;
        End
     Else begin
        Caption := 'Statements';{ + ' - ' + st;}
        AreaCodePanel.show;
    //    UseNew.Visible := true;         //  TGM AB 11/03/16
        if NewRepForm.CustRadio.Checked then begin
           Self.Agebylabel.visible := true;
           Self.AgeByCombo.Visible := true;
        end;
     end;
     SetDb ( NlFile );
     schrecf := 1;
     schrect := db1.dbrechigh;
     AccountsBoxClick ( Sender );

end;

procedure TStatementForm.AccFromExit(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := AccFrom.Text;
     SlimAll(TempStr);
     If (AccType.Text = '2') And Not(TempStr = '') Then
        If Numeric (TempStr) Then
           iAccFrom := StrToInt ( TempStr )
        Else
           AccFrom.SetFocus;
end;

procedure TStatementForm.AccGridDblClick(Sender: TObject);
begin
     If AccGrid.Cells[2,AccGrid.Row] = 'Yes' Then
        AccGrid.Cells[2,AccGrid.Row] := 'No'
     Else
        AccGrid.Cells[2,AccGrid.Row] := 'Yes';
//     AccFrom.Text := AccGrid.Cells[0,AccGrid.Row];
end;

procedure TStatementForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
       Acctype.Text := '';
       NomAccFrom.Text := '';
       NomAccTo.Text := '';
       // Save the Line to Print From for Record Cards and Invoice Summary
       if ( PROG In [CUSTREC,SUPPREC,CUSTSUM,SUPPSUM] ) then
          begin
      //       Cash11.xPrintFrom := PrintFrom.AsInteger;
      //       DefWrite( 11 );
          SaveDefaults;
          end;
end;

procedure TStatementForm.DateToExit(Sender: TObject);
begin
     KDateToExit ( Sender, Report);
end;

procedure TStatementForm.DateFromExit(Sender: TObject);
begin
     KDateFromExit ( Sender, Report);
end;

procedure TStatementForm.DateSearchFromCloseUp(Sender: TObject);
begin
     DateFrom.Text:= DateToStr(DateSearchFrom.Date);
     DateFrom.SetFocus;
end;

procedure TStatementForm.DateSearchToCloseUp(Sender: TObject);
begin
     DateTo.Text:= DateToStr(DateSearchTo.Date);
     DateTo.SetFocus;
end;

procedure TStatementForm.RepDateExit(Sender: TObject);
begin
     KDateValid ( Sender );
end;

procedure TStatementForm.AccToExit(Sender: TObject);
begin
     If (AccType.Text = '2') And Not(AccTo.Text = '') Then
        If AccTo.Text <> '' Then
           iAccTo := StrToInt ( AccTo.Text );
end;

procedure TStatementForm.AccountsBoxClick(Sender: TObject);
begin
     InitOnRangeChange;
     If AccountsBox.ItemIndex = 1 Then
        Begin
            SearchLabel.Hide;
            SearchField.Hide;
            AccFrom.Text := '1';
            AccFrom.Enabled := True;
            AccFrom.Show;
            CustAccounts.Show;
            AccTo.Show;
            Speedbutton1.Show;
            AccFromLabel.Caption := 'Account From';
            AccFromLabel.Show;
            AccToLabel.Show;
            AccGrid.Hide;
            if AccFrom.Text <> '' then
               iAccFrom := StrToInt ( AccFrom.Text );
            if AccTo.Text <> '' then
               iAccTo := StrToInt ( AccTo.Text );
            Acctype.text := '2';
        End
     Else If AccountsBox.ItemIndex = 2 Then
        Begin
            SearchLabel.Show;
            SearchField.Show;
            AccGrid.Show;
            Fillgrid('');
            AccFrom.Hide;
            CustAccounts.Hide;
            AccFromLabel.Hide;
            AccTo.Hide;
            SpeedButton1.Hide;
            AccToLabel.Hide;
            if NOT ( PROG In [CUSTSUM,SUPPSUM] ) then
               TotalSelected.Show;
            Acctype.Text := '3';
        End
      Else
        Begin
            SearchLabel.Hide;
            SearchField.Hide;
            iAccFrom := 1;
            AccFrom.Text := '1';
            AccGrid.Hide;
            AccFrom.Hide;
            CustAccounts.Hide;
            SpeedButton1.Hide;
            AccTo.Hide;
            AccFromLabel.Hide;
            AccToLabel.Hide;
            Acctype.Text := '1';
        End;
end;

procedure TStatementForm.CustAccountsClick(Sender: TObject);
begin
     If NewRepForm.CustRadio.Checked Then
        NewListBox.ListIt ( Sender, Customers, 'C' )
     Else
        NewListBox.ListIt ( Sender, Suppliers, 'S' );

     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        AccFrom.Text := NewListBox.ListInfo.ReturnValue;
     AccFrom.SetFocus;
end;

procedure TStatementForm.SpeedButton1Click(Sender: TObject);
begin
     If NewRepForm.CustRadio.Checked Then
        NewListBox.ListIt ( Sender, Customers, 'C' )
     Else
        NewListBox.ListIt ( Sender, Suppliers, 'S' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        AccTo.Text := NewListBox.ListInfo.ReturnValue;
     AccTo.SetFocus;
end;

procedure TStatementForm.NomAccFromButtonClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, AllNoms, 'N' );   { Nominal Ledger Accounts }
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        NomAccFrom.Text := NewListBox.ListInfo.ReturnValue;
     NomAccFrom.SetFocus;
end;

procedure TStatementForm.NomAccToButtonClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, AllNoms, 'N' );   { Nominal Ledger Accounts }
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        NomAccTo.Text := NewListBox.ListInfo.ReturnValue;
     NomAccTo.SetFocus;
end;

procedure TStatementForm.RangeFromExit(Sender: TObject);
Var
   st : ShortString;
begin
     st := RangeFrom.Text;
     SlimAll ( st );
     If Numeric ( st ) Then
        SCHANALF := StrToInt ( St )
     Else
         RangeFrom.SetFocus;
end;

procedure TStatementForm.RangeToExit(Sender: TObject);
Var
   st : ShortString;
begin
     st := RangeTo.Text;
     SlimAll ( st );
     If Numeric ( st ) Then
        SCHANALT := StrToInt ( St )
     Else
         RangeTo.SetFocus;
end;

procedure TStatementForm.PrintBoxClick(Sender: TObject);
begin
     // Condition for printing Changes
           if ((PrintBox.ItemIndex =1) and not (PROG In [CUSTSUM,SUPPSUM])) then
              GreaterThanBalance.visible:=true
           else GreaterThanBalance.visible:=false;

end;

procedure TStatementForm.InvoiceSubTotalClick(Sender: TObject);
begin
     If InvoiceSubTotal.Checked Then
        begin
            RangeFrom.Hide;
            AnalFromLabel.Hide;
            RangeTo.Hide;
            AnalToLabel.Hide;
            RangeToButton.Hide;
            RangeFromButton.Hide;
            NomAccFrom.Hide;
            NomAccTo.Hide;
            NomAccFromLabel.Hide;
            NomAccToLabel.Hide;
            NomAccFromButton.Hide;
            NomAccToButton.Hide;
            // Reset the Accounts Ranges and the Analysis Ranges
            RangeFrom.Text := '0';
            RangeTo.Text := '9999';
            SetDb ( NlFile );
            NomAccFrom.Text := '1';
            NomAccTo.Text   := IntToStr ( db1.dbrechigh );
            schrecf := 1;
            schrect := db1.dbrechigh;
            SchAnalf := 0;
            SchAnalt := 9999;
        end
     Else
         begin
            RangeFrom.Show;
            AnalFromLabel.Show;
            RangeTo.Show;
            AnalToLabel.Show;
            RangeToButton.Show;
            RangeFromButton.Show;
            NomAccFrom.Show;
            NomAccTo.Show;
            NomAccFromLabel.Show;
            NomAccToLabel.Show;
            NomAccFromButton.Show;
            NomAccToButton.Show;
         end;
end;

procedure TStatementForm.RangeFromButtonClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Analysis, 'A' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        RangeFrom.Text := NewListBox.ListInfo.ReturnValue;
     RangeFrom.SetFocus;
end;

procedure TStatementForm.RangeToButtonClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Analysis, 'A' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        RangeTo.Text := NewListBox.ListInfo.ReturnValue;
     RangeTo.SetFocus;
end;

procedure TStatementForm.DateSearchCloseUp(Sender: TObject);
begin
     RepDate.Text:= DateToStr(DateSearch.Date);
     RepDate.SetFocus;
end;

procedure TStatementForm.HelpClick(Sender: TObject);
begin
     if PROG In [SUPPSTM,CUSTSTM] then
        //Application.HelpContext(151)
        AccsDataModule.HTMLHelp('statementsReport.htm')
     else if PROG In [SUPPLED,CUSTLED] then
        //Application.HelpContext(152)
        AccsDataModule.HTMLHelp('ledgerCards.htm')
     else if PROG In [CUSTREC,SUPPREC] then //Record Cards
        //Application.HelpContext(153)
        AccsDataModule.HTMLHelp('recordCardsReport.htm')
end;

procedure TStatementForm.SearchfieldKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If (Key = VK_UP) or (Key = VK_DOWN) or (Key = VK_PRIOR) or
        (Key = VK_NEXT) Then AccGrid.SetFocus;
end;

procedure ListSearch ( ItemFrom, ItemTo : Integer; var GridPos : Integer);{Search Function Using Case statement}
Var
   RecCounter : Integer;
   RecOk : Boolean;
   TotAmt : Long;
Begin
     RecOk := False;
     With NewListBox.ListInfo Do
          Begin
               RecCounter := ItemFrom;
               If ItemFrom > 0 Then
                  {For RecCounter := ItemFrom to ItemTo do}
                  While ( RecCounter <= ItemTo ) Do
                      Begin
                           Case ListType Of
                           'C',
                           'S': Begin
                                     ReadRec ( NewListBox.ListInfo.ActiveDb, RecCounter );
                                     dberr;
                                     RecOk := RecActive ( NewListBox.ListInfo.ActiveDb );
                                     if RecOk then
                                        getItem ( NewListBox.listInfo.ActiveDb, 1 );
                                End;
                           End;

                           If RecOk then
                              Begin
                                   If NewListBox.listOk ( StatementForm.SearchField.Text, CurrStr, RecCounter ) then
                                      Begin
                                           If ListType = 'E' Then
                                              Begin
                                                   GetItem ( ActiveDb, 1 );
                                                   StatementForm.AccGrid.Cells [0, GridPos] := CurrStr;
                                                   GetItem ( ActiveDb, 2 );
                                                   StatementForm.AccGrid.Cells [1, GridPos] := Copy ( CurrStr, 1, 16 );
                                              End
                                           Else
                                               If ( ListType = 'L' ) Then
                                                  Begin
                                                     GetItem ( TxFile, 2 );
                                                     StatementForm.AccGrid.Cells [0, GridPos] := CurrStr;
                                                     GetItem ( TxFile, 1 );
                                                     Case CurrInt Of
                                                          1,
                                                          5 : StatementForm.AccGrid.Cells [1, GridPos] := 'INV';
                                                          2,
                                                          6 : StatementForm.AccGrid.Cells [1, GridPos] := 'PAY';
                                                          3,
                                                          7 : StatementForm.AccGrid.Cells [1, GridPos] := 'CRN';
                                                     End;
                                                     GetItem ( TxFile, 9 );
                                                     TotAmt := CurrLong;
                                                     GetItem ( TxFile, 11 );
                                                     TotAmt := CurrLong + TotAmt;
                                                     LongStr ( TotAmt, CurrStr, 'L' );
                                                     StatementForm.AccGrid.Cells [2, GridPos] := CurrStr;
                                                  End
                                               Else
                                                  Begin
                                                     If ((RecCounter <= cash1.XNOMNONFROM) And (Ent <> '')) or
                                                        ((Reccounter < cash1.XNOMOHFROM) And ( Ent = '' )) Then
                                                         FirstEXP := GridPos;
                                                     {Else
                                                        FirstEXP := 0;}


//                                                     If (CashBookForm.PaymentReceipt.Checked) and Then
//                                                        FirstExp := 0;

                                                     StatementForm.AccGrid.Cells [0, GridPos] := IntTostr ( RecCounter );
                                                     StatementForm.AccGrid.Cells [1, GridPos] := CurrStr;
                                                  End;
                                           Inc ( GridPos );
                                      End;
                              End;
                           If ( ListType <> 'L' ) Then
                               Inc ( RecCounter );
                      End;
               StatementForm.AccGrid.RowCount := GridPos;

               If GridPos <= 1 Then
                  Begin
                       StatementForm.AccGrid.RowCount := 2;
                       StatementForm.AccGrid.Cells[0,1] := ' ';
                       StatementForm.AccGrid.Cells[1,1] := ' ';
                       StatementForm.AccGrid.Cells[2,1] := ' ';
                       If ListType = 'L' Then
                          StatementForm.AccGrid.Cells[2,1] := ' ';
                       StatementForm.AccGrid.FixedRows := 1;
                       StatementForm.AccGrid.Row := 1;
                  End;
          End;
End;

procedure TStatementForm.SearchfieldChange(Sender: TObject);
begin
     if Searchfield.Text = '' then
        FillGrid ('')
     else
        FillGrid(Searchfield.text);
    (*     begin
              GridPos := 1;
              With NewListBox.ListInfo Do
                   ListSearch ( AccRange[1], AccRange[2], GridPos );
         end;
    *)
end;

procedure TStatementForm.SearchfieldEnter(Sender: TObject);
begin
     if NewRepForm.CustRadio.Checked then
        begin
           NewListBox.ListInfo.ListType := 'C';
           NewListBox.ListInfo.ActiveDb := SLFILE;
        end
     else
        begin
           NewListBox.ListInfo.ListType := 'S';
           NewListBox.ListInfo.ActiveDb := PLFILE;
        end;
     NewListBox.ListInfo.CustOrSupp := 0;
     SetDb( NewListBox.ListInfo.ActiveDb );
     NewListBox.ListInfo.AccRange[1] := 1;
     NewListBox.ListInfo.AccRange[2] := Db1.DBRECHIGH;
end;

procedure TStatementForm.bStatementSetupClick(Sender: TObject);
begin
     if ( not(bool(FormStatementSetup)) ) then
        FormStatementSetup := TFormStatementSetup.Create(self);
     uStatementSetup.FormStatementSetup.ShowModal;
end;


procedure TStatementForm.AgeByComboChange(Sender: TObject);
begin
     CustSuppListing.AgeByCombo.ItemIndex := Self.AgeByCombo.ItemIndex;
end;

procedure TStatementForm.LoadDefaults;
begin
     try Accsdatamodule.AccsDefaults.Open;
     Accsdatamodule.AccsDefaults.first;
     Printfrom.AsInteger := Accsdatamodule.AccsDefaults['InvSum_NumberBlankLines'];
     if Accsdatamodule.AccsDefaults['InvSum_DoubleSpacing'] = true then DoubleSpace.Checked := true
        else DoubleSpace.Checked := false;
     if Accsdatamodule.AccsDefaults['InvSum_UsePrePrinted'] = true then PrePrintedStationary.checked := true
        else PrePrintedStationary.checked := false;
     except Printfrom.AsInteger := 20;
     end;
     Accsdatamodule.AccsDefaults.close;
end;

procedure TStatementForm.SaveDefaults;
begin
     try Accsdatamodule.AccsDefaults.Open;
     Accsdatamodule.AccsDefaults.first;
     Accsdatamodule.AccsDefaults.edit;
     Accsdatamodule.AccsDefaults['InvSum_NumberBlankLines'] := Printfrom.AsInteger;
     Accsdatamodule.AccsDefaults['InvSum_DoubleSpacing'] := DoubleSpace.Checked;
     Accsdatamodule.AccsDefaults['InvSum_UsePrePrinted'] := PrePrintedStationary.checked;
     Accsdatamodule.AccsDefaults.post;
     Accsdatamodule.AccsDefaults.close;
     except
     end;
end;



procedure TStatementForm.CBExtendedStatementClick(Sender: TObject);        // TGM AB 11/03/16
begin
        if CBExtendedStatement.Checked = true then begin
            stat.StatementForm.Width := 900;
        end
            else begin
                   stat.StatementForm.Width := 670;
                end;
end;

procedure TStatementForm.btnEmailStatementClick(Sender: TObject);
var
   i : Integer;
   bEmailStatement : Boolean;
   EntityInfo : TEntityInfo;
   ConfirmedEmailAddress,
   FileName,
   TempDir : String;
   Files : TStringList;
   EmailTemplate : TEmailTemplate;
   iaSelectedCustSupps : array of Integer;
begin
   SetLength(iaSelectedCustSupps,0);
   if ( AccountsBox.ItemIndex <> 2 ) then
      begin
         MessageDlg('Emailing of statements is currently available for selected accounts only.',mtWarning,[mbOK],0);
         Exit;
      end;

   CheckForSelectedAccounts(bEmailStatement);

   if ( not(bEmailStatement) ) then Exit;

   if ( Length(PrList) > 1 ) then
      for i := 1 to Length(PrList) do
         if ( PrList[i] <> 0 ) then
            begin
               SetLength(iaSelectedCustSupps,Length(iaSelectedCustSupps)+1);
               iaSelectedCustSupps[Length(iaSelectedCustSupps)-1] := PrList[i];
            end;

   SetAccountAndReportType();
   iAccType := 4;
   try
      EmailTemplate := TfmEmailTemplates.ShowTheForm(TSelecting);
      if ( EmailTemplate = nil ) then
         begin
            UpdateStatusPanel('Template not found. The email has not been sent.');
            Exit;
         end;

      if ( Length(iaSelectedCustSupps) > 0 ) then
         for i := 0 to Length(iaSelectedCustSupps)-1 do
            try
               Screen.Cursor := crHourGlass;
               if ( NewRepForm.CustRadio.Checked ) then
                  EntityInfo := EntityInfo.GetCustSuppInfo(SlFile,iaSelectedCustSupps[i])
               else if ( NewRepForm.SuppRadio.Checked ) then
                  EntityInfo := EntityInfo.GetCustSuppInfo(PLFile,iaSelectedCustSupps[i]);
               if (EntityInfo = nil) then
                  begin
                     MessageDlg('An error occurred while preparing email.',mtError,[mbOK],0);
                     Exit;
                  end;

               TempDir := IncludeTrailingBackslash(AccsDataModule.CurrentDatabasePath) + 'temp';
               if ( not(DirectoryExists(TempDir)) ) then
                  CreateDir(TempDir);

               btnEmailStatement.Enabled := False;
               ClearStatusPanel();
               LedgerReport.FEmailCustSupp := iaSelectedCustSupps[i];
               LedgerReport.BuildStatementReport;

               try
                  FileName := Format('%s%s_%s_%s.pdf',
                                     [IncludeTrailingBackSlash(TempDir),
                                     StripAllNomNumAlpha(EntityInfo.Name),
                                     FormatDateTime('dd-MM-yy',Date),
                                     IntToStr(iaSelectedCustSupps[i])]);

                  SaveAsPDF( LedgerReport, FileName );

                  if ( not(FileExists(FileName)) ) then
                     begin
                        MessageDlg('Unable to save Statement PDF File.',mtError,[mbOK],0);
                        Exit;
                     end;

                  UpdateStatusPanel('Sending email...');

                  Files := TStringList.Create();
                  Files.Add(FileName);

                  ConfirmedEmailAddress := EntityInfo.EmailAddress;
                  if ( InputQuery('Confirm '+EntityInfo.Name+' Email', 'Email Address', ConfirmedEmailAddress) ) then
                     if ( AccsDataModule.SendEMail(ConfirmedEmailAddress, EmailTemplate.Subject, EmailTemplate.Body, Files) > 0 ) then
                        UpdateStatusPanel('Email successfully sent.')
                     else
                        UpdateStatusPanel('Error sending email.',clRed)
               finally
                  DeleteFile(PChar(FileName));
                  FreeAndNil(Files);
               end;
            finally
               if ( EntityInfo <> nil ) then
                  FreeAndNil(EntityInfo);
               ClearTimer.Enabled := True;
               btnEmailStatement.Enabled := True;
               Screen.Cursor := crDefault;
            end;
   finally
      if ( EmailTemplate <> nil ) then
         FreeAndNil(EmailTemplate);
   end;
end;

procedure TStatementForm.CheckForSelectedAccounts(var ARunReport : Boolean);
var
   counter,
   TempInt : Integer;
   TempStr : ShortString;
begin
   TempInt := 0;
   Counter := 0;
   if ( AccountsBox.ItemIndex = 2 ) Then
      begin
         TempInt := 1;
         for Counter := 1 To AccGrid.Rowcount do
             begin
                if ( Accgrid.Cells[2,Counter] = 'Yes' ) Then
                   begin
                      TempStr := AccGrid.Cells[0,Counter];
                      SlimAll ( TempStr );
                      iAccFrom := StrToInt(TempStr);
                      PrList[TempInt] := iAccFrom;
                      Inc ( TempInt );
                   end;
             end;
         TotList := TempInt - 1;
         // No point in running report no accounts selected
         if ( TotList = 0 ) then
            begin
               MessageDlg('Please select some accounts to print.',mtInformation,[mbok],0);
               // Set focus to the Grid.
               AccGrid.SetFocus;
            end;
         ARunReport := TotList > 0;
      end;
end;

procedure TStatementForm.SetAccountAndReportType;
begin
   // If running the summary set the iPrintType to display all
   if ( PROG In [SUPPSUM,CUSTSUM] ) then
      iPrintType := 1
   else
      // Set the PrintType
      case PrintBox.ItemIndex of
        0 : iPrintType := 1;
        1 : iPrintType := 2;
        2 : iPrintType := 3;
      end;

   // Set the Account Type
   case AccountsBox.ItemIndex of
      0 : iAccType := 1;   // All
      1 : iAccType := 2;   // Range
      2 : iAccType := 3;   // Selected
   end;
end;

procedure TStatementForm.ClearStatusPanel;
begin
   StatusBar.Panels[0].Text := '';
   StatusBar.Panels[0].PanelStyle.Font.Color := clWindowText;
   Update;
   Application.ProcessMessages;
end;

procedure TStatementForm.UpdateStatusPanel(const AText: string; const AColor: TColor);
begin
   StatusBar.Panels[0].Text := AText;
   StatusBar.Panels[0].PanelStyle.Font.Color := AColor;
   Update;
   Application.ProcessMessages;
end;

end.
