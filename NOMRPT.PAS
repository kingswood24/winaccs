unit Nomrpt;
{
Form to Run Reports Invoice, Payment & Credit Note Listing Reports
}
interface

{Changes

17/07/15 - updates to call the new combined invoive & payment VAT Report

21/07/17 - updates to Bank Audit Trial report defaults

Jan 18 - Updated for Bank Audit Trial carried forward transactions & added new Bank Transaction Listing report.

Jan 19 (Ch006) - Changes to enable transactions to be marked VAT Processed ahead of MTD

02/09/19 [V4.5 R0.3] /MK Change - Created public variable, MainGridVatSumChecked, that allows the defaulting of VatAuditChecked.Checked from outside forms.
                                - FormActivate - Check MainGridVatSumChecked to set VatAuditChecked.Checked.

01/11/19 - added in tickbox at bottom of VAT panel to include Exempt VAT Code in Audit Trials for Invoice VAT only (for Northern Ireland Users only) - marked Ch017

04/06/20 - added in new Acountant CSV export to some reports - all marked Ch025. ExportBtn Caption changes to 'CSV Export' for new exports and just 'Export' for older exports

}


uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, NewClass, ComCtrls, Mask, uvatreps,
 { LMDCustomComponent, LMDSysBase, LMDSysBaseComponent, LMDSysSystemInfo,   }
  RXCtrls, cxControls, cxContainer, cxEdit, cxCheckBox, Menus;

type
  TRptType = (NomsOrGroups,ManBalSheet,VatReport,FullNomAudit,TrialBalance,BankAudit, // FullAudit Changed to FullNomAudit TGM AB 27/02/02
              CashIncExp,TxList,EntStructure,BankTransListing);    // TGM AB 19/01/18
  TNominalReportForm = class(TKingForm)
    BalanceSheetPanel: TPanel;
    ReportDate: TLabel;
    Panel1: TPanel;
    Help: TBitBtn;
    Run: TBitBtn;
    Exitbtn: TBitBtn;
    BalanceSheet: TCheckBox;
    TrialBalancePanel: TPanel;
    lDate: TLabel;
    AccFromLabel: TLabel;
    AccFrom: TEdit;
    AccTo: TEdit;
    AccToLabel: TLabel;
    Extended: TCheckBox;
    ShowYearMonth: TCheckBox;
    TrialByAccount: TCheckBox;
    BankAuditPanel: TPanel;
    Label2: TLabel;
    ShowStubDetails: TCheckBox;
    BankAuditAccFrom: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    BankAuditAccTo: TEdit;
    NewPageAcc: TCheckBox;
    PrintZero: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    WhichStub: TEdit;
    Label7: TLabel;
    CashbookListingPanel: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    TxFrom: TEdit;
    TxTo: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    IncomeListing: TRadioButton;
    ExpendListing: TRadioButton;
    TransListingPanel: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    ListingTxfrom: TEdit;
    ListingTxTo: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    ListAllCheck: TCheckBox;
    ListCashIncCheck: TCheckBox;
    ListCashExpCheck: TCheckBox;
    ListDDJCheck: TCheckBox;
    ListCustCheck: TCheckBox;
    ListSuppCheck: TCheckBox;
    FullNominalPanel: TPanel;
    Label18: TLabel;
    AuditByAcc: TCheckBox;
    Label19: TLabel;
    NomAccFrom: TEdit;
    NomAccTo: TEdit;
    Label20: TLabel;
    UseTransCheck: TCheckBox;
    UseTransPanel: TPanel;
    Label21: TLabel;
    NomTxFrom: TEdit;
    NomTxTo: TEdit;
    Label22: TLabel;
    UseDatePanel: TPanel;
    Label23: TLabel;
    Label24: TLabel;
    IncStartYearBal: TCheckBox;
    IncMoveYear: TCheckBox;
    IncStartMthBal: TCheckBox;
    IncMoveLastYear: TCheckBox;
    IncMoveMth: TCheckBox;
    IncBudget: TCheckBox;
    IncBudgetDiff: TCheckBox;
    FullNomNewPageAcc: TCheckBox;
    PrintOnlyTx: TCheckBox;
    Panel2: TPanel;
    VReports: TRadioButton;
    PReports: TRadioButton;
    VatPanel: TPanel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    VatTxFrom: TEdit;
    VatTxTo: TEdit;
    VatAuditChecked: TCheckBox;
    NomAccountsTo: TSpeedButton;
    nomAccountsFrom: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    RepDate: TMaskEdit;
    RepSearch: TDateTimePicker;
    NomRepSearch: TDateTimePicker;
    NomRepDate: TMaskEdit;
    DateFrom: TMaskEdit;
    DateTo: TMaskEdit;
    BankAuditDate: TMaskEdit;
    DateToSearch: TDateTimePicker;
    DateFromSearch: TDateTimePicker;
    BankAuditDateSearch: TDateTimePicker;
    VatRepDateSearch: TDateTimePicker;
    VatRepDate: TMaskEdit;
    VatDateFrom: TMaskEdit;
    VATDateTo: TMaskEdit;
    VatDateToExitSearch: TDateTimePicker;
    VatDateFromExitSearch: TDateTimePicker;
    TrialBalanceDateSearch: TDateTimePicker;
    CashBookDate: TMaskEdit;
    ListingDateTo: TMaskEdit;
    ListingDateFrom: TMaskEdit;
    ListingDateFromSearch: TDateTimePicker;
    ListingDateToSearch: TDateTimePicker;
    TransListingDate: TMaskEdit;
    TransListingDateFrom: TMaskEdit;
    TransListingDateTo: TMaskEdit;
    TransListingDateFromSearch: TDateTimePicker;
    TransListingDateToSearch: TDateTimePicker;
    TransListingDateSearch: TDateTimePicker;
    NomDateFrom: TMaskEdit;
    NomDateTo: TMaskEdit;
    NomDateFromSearch: TDateTimePicker;
    NomDateToSearch: TDateTimePicker;
    TrialBalanceDate: TMaskEdit;
    sbAccFrom: TSpeedButton;
    sbAccTo: TSpeedButton;
    CashBookDateSearch: TDateTimePicker;
    pPrintNomsOrGroups: TPanel;
    pEntStructure: TPanel;
    EntCodeLabel: TLabel;
    EntCode: TEdit;
    EntAccounts: TSpeedButton;
    rgAccountGroup: TRadioGroup;
    rgAccountGroup2: TRadioGroup;
    rgbytrans: TRadioGroup;
    translabel: TLabel;
    ExportBtn: TRxSpeedButton;
    UseNewVATReportCB: TCheckBox;
    PaymentCb: TCheckBox;
    monthpanel: TPanel;
    CalMonthLabel: TLabel;
    CalMonth: TEdit;
    MonthTo: TEdit;
    ToLbl: TLabel;
    MonthCB: TCheckBox;
    LastYrLbl: TLabel;
    ThisYrLbl: TLabel;
    MonthTypeSelectRG: TRxCheckListBox;
    MonthFrom: TEdit;
    UseNewAuditReportCB: TCheckBox;
    BATSortRG: TRadioGroup;
    Label1: TLabel;
    PrintCarriedDetails: TCheckBox;
    ReportDateCoverPanel: TPanel;
    MTDPanel: TPanel;
    MTDLabel: TLabel;
    MarkTxVATCB: TCheckBox;
    IncludeExemptCB: TcxCheckBox;
    SaveCSVExportDialog: TSaveDialog;
    procedure RunClick(Sender: TObject);
    procedure ExitbtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CalMonthExit(Sender: TObject);
    procedure AccFromKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AccToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ShowYearMonthExit(Sender: TObject);
    procedure ExtendedEnter(Sender: TObject);
    procedure WhichStubChange(Sender: TObject);
    procedure TxToEnter(Sender: TObject);
    procedure TxFromEnter(Sender: TObject);
    procedure ListingTxfromEnter(Sender: TObject);
    procedure ListingTxToEnter(Sender: TObject);
    procedure ListAllCheckEnter(Sender: TObject);
    procedure NomTxFromEnter(Sender: TObject);
    procedure NomTxToEnter(Sender: TObject);
    procedure NomAccFromEnter(Sender: TObject);
    procedure NomAccToEnter(Sender: TObject);
    procedure NomAccFromKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NomAccToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UseTransCheckEnter(Sender: TObject);
    procedure BankAuditAccFromKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BankAuditAccToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure VReportsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure nomAccountsFromClick(Sender: TObject);
    procedure NomAccountsToClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure TransListingDateFromSearchCloseUp(Sender: TObject);
    procedure TransListingDateToSearchCloseUp(Sender: TObject);
    procedure TransListingDateSearchCloseUp(Sender: TObject);
    procedure MaskEdit1Enter(Sender: TObject);
    procedure RepDateExit(Sender: TObject);
    procedure RepSearchCloseUp(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure NomRepSearchCloseUp(Sender: TObject);
    procedure NomDateFromSearchCloseUp(Sender: TObject);
    procedure NomDateToSearchCloseUp(Sender: TObject);
    procedure BankAuditDateSearchCloseUp(Sender: TObject);
    procedure DateToExit(Sender: TObject);
    procedure DateFromExit(Sender: TObject);
    procedure VatRepDateSearchCloseUp(Sender: TObject);
    procedure VatDateFromExitSearchCloseUp(Sender: TObject);
    procedure VatDateToExitSearchCloseUp(Sender: TObject);
    procedure TrialBalanceDateSearchCloseUp(Sender: TObject);
    procedure sbAccFromClick(Sender: TObject);
    procedure sbAccToClick(Sender: TObject);
    procedure CashBookDateSearchCloseUp(Sender: TObject);
    procedure ListingDateFromSearchCloseUp(Sender: TObject);
    procedure ListingDateToSearchCloseUp(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DateFromSearchCloseUp(Sender: TObject);
    procedure DateToSearchCloseUp(Sender: TObject);
    procedure VatTxFromExit(Sender: TObject);
    procedure VatTxToExit(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure BankAuditAccFromExit(Sender: TObject);
    procedure BankAuditAccToExit(Sender: TObject);
    procedure AccFromExit(Sender: TObject);
    procedure AccToExit(Sender: TObject);
    procedure EntAccountsClick(Sender: TObject);
    procedure EntCodeExit(Sender: TObject);
    procedure rgAccountGroupClick(Sender: TObject);
    procedure rgAccountGroup2Click(Sender: TObject);
    procedure rgbytransClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExportBtnClick(Sender: TObject);
    procedure MonthFromExit(Sender: TObject);
    procedure MonthToExit(Sender: TObject);
    procedure MonthTypeSelectRGClick(Sender: TObject);
    procedure BATSortRGClick(Sender: TObject);
    procedure MarkVATAsProcessed;                      // Ch006
    procedure FullReportExportBtnClick(Sender: TObject);                         // Ch025
    procedure TrialBalanceReportExport(Filename : string);                // Ch025
    procedure BankAuditReportExport(Filename : string);                   // Ch025
    procedure FullNominalReportExport(Filename : string);                 // Ch025
  private
    { Private declarations }
  public
    { Public declarations }
    NomFrom,                             { Nominal Ledger Acccount From }
    NomTo,                               { Nominal Ledger Acccount To }
    TransFrom,                           { Transactions Record From }
    TransTo                  : Integer;  { Transactions Record To }

    MainGridVatSumChecked : Boolean;

    procedure SetNominalReportForm(RptType   : TRptType);
   end;

var
  NominalReportForm: TNominalReportForm;

implementation
Uses
    Mainrpts,
    pickdate,
    DBCore,
    newlisting,
    vars,
    types,
    clears,
    Calcs,
    SpRepa,
    DBGEN,
    NomReps,
    ReportDefs, NewRepUnit, fullaudit, chkcomp, accsdata, uTrialBalanceReport,
    uBankAuditTrailReport, DBTables, Registry, KRoutines;       // Ch006  // Ch017   // Ch025

{$R *.DFM}

// Start Ch025

Function RemoveCommas( inputstring: string): string;
var
        i : integer;
begin
     for i:= 1 to length(inputstring) do begin
         if inputstring[i] = ',' then inputstring[i] := ' ';
     end;
     result := inputstring;
end;

// End Ch025

procedure TNominalReportForm.RunClick(Sender: TObject);
var
          trialbalanceOK : boolean;   // TGM AB 27/02/02
          MarkVAT : boolean; // Ch006 22/03/19
          Registry : TRegistry;  // Ch017

begin

     TrialbalanceOK := true;     // TGM AB 27/02/02

     If BalanceSheetPanel.Visible Then
        Begin
              REPXDATE := RepDate.Text;
             PRog := SpecRep;
             If BalanceSheet.Checked Then Begin    // tgm fixed this 12/03/02 by removing a NOT - was the wrong way round
                SetupReport(rpManagementBalance1);
                NomReports ( 21, 0 )
             end Else begin
                 SetupReport(rpManagementBalance2);
                 NomReports ( 121, 0 );
             End;
        End
     Else If TrialBalancePanel.Visible Then
            Begin
                 // TGM AB Trial Balance Run
                 if chkcomp.FCheckName.TrialbalanceOK = false then TrialbalanceOK := false;
              //   if Fullaudit.AuditFiles.NLbalancesOK(false) = false then TrialbalanceOK := false;
              //   if fullaudit.AuditFiles.Missingaccounts(false) = true then TrialbalanceOK :=false;
                 {if not cash1.xcashbook then begin
                                           //  if Fullaudit.AuditFiles.Controlaccountsmatch(false) = false then TrialbalanceOK := false;
                                             if Fullaudit.auditfiles.SaleLedgersOK(false) = false then TrialbalanceOK := false;
                                             if Fullaudit.auditfiles.PurchaseLedgersOK(false) = false then TrialbalanceOK := false;
                                             if Fullaudit.auditfiles.Controlaccountsmatch(false) = false then TrialbalanceOK := false;
                                             end;
                 }

                 if not TrialBalanceOK then Begin
                                            Showmessage('Data Integrity Check Indicates A Problem With The Trial Balance' + #10#13 + 'Please Contact Kingswood Before Completing A Year End' +#10#13 +  'And Before Presenting The Trial Balance To Your Accountant');
                                            end;
                 // end

                (* REPXDATE := TrialBalanceDate.Text;
                 PROG := SPECREP;
                 If TrialByAccount.Checked Then
                 ACT := 6
                 Else
                 ACT := 100;
                 NomReports ( ACT, NlFile );   *) // TGM AB 18/01/13 Old Report

                 if not bool (TrialBalanceReport) then Application.CreateForm(TTrialBalanceReport, TrialBalanceReport);
                 TrialBalanceReport.RunReport(True);         // Ch025 added (true) to preview report

            End
         Else If BankAuditPanel.Visible Then
            Begin                                                           // TGM AB 02/08/13
                 if UseNewAuditReportCB.checked then begin
                               if not bool (BankAuditTrialReport) then Application.CreateForm(TBankAuditTrialReport, BankAuditTrialReport);
                               if WhichStub.visible then BankAuditTrialReport.RunReport(True)                       //   Ch025
                                else  BankAuditTrialReport.RunListingReport;                                  //   TGM AB 19/01/18
                 end else begin
                            REPXDATE := BankAuditDate.Text;
                            DateTo.SetFocus;
                            DateFrom.SetFocus;
                            PROG := SPECREP;
                            ACT := 5;
                            NomReports ( ACT, NlFile );
                     end;                                                   // TGM AB 02/08/13 end
            End
         Else If CashBookListingPanel.Visible Then
            Begin
                 DateFromExit(ListingDateFrom);
                 DateToExit(ListingDateTo);
                 REPXDATE := CashBookDate.Text;
                 PROG := SPECREP;
                 If IncomeListing.Checked Then
                    ACT := 1
                 Else
                     ACT := 2;
                 NomReports ( ACT, NlFile );
            End
         Else If TransListingPanel.Visible Then
            Begin
                 REPXDATE := TranslistingDate.Text;
                 TranslistingDateFrom.SetFocus;
                 TranslistingDateTo.SetFocus;
                 PROG := SPECREP;
                 ACT := 30;
                 NomReports ( ACT, NlFile );
            End
         Else If FullNominalPanel.Visible Then
            Begin
                 UseTransCheckEnter(self);
                 // TGM AB Full Nominal pre checks
                 Fullaudit.RunAuditFiles(3,NomFrom,NomTo,1,1,false);
                 auditfiles.OnActivate(self);
                 auditfiles.OnShow(self);
                 if fullaudit.AuditFiles.NLbalancesOK(false,false,1) = false then
                    showmessage('Data Integrity Check indicates there may be a problem with your data. ' +#10#13
                     +'This is probably due to the unreconciled cheques carried forward from last year being included in the nominal audit trail' +#10#13
                     +'Please contact Kingswood before printing off your nominal audit trail report for your accountant.');
         {        if fullaudit.AuditFiles.Missingaccounts(false) = true then TrialbalanceOK :=false;     }
                 // end
                 REPXDATE := NomRepDate.Text;

                 PROG := SPECREP;
                 If AuditByAcc.Checked Then
                    ACT := 7
                 Else
                     ACT := 101;
                 NomReports ( ACT, NlFile );
            End
         Else If VatPanel.Visible Then
            Begin

                 if ((MTDPanel.visible) and (MarkTxVATCB.checked)) then MarkVAT := true             // Ch006    22/03/19
                        else MarkVAT := False;                                                      // Ch006    22/03/19

                 // Start Ch017

                 Registry:=Tregistry.Create;
                 Registry.OpenKey('Software\Kingswood\Kingsacc\VATAuditDefaults', True);
                 if IncludeExemptCB.checked = true then Registry.WriteString('NIStandardIncExempt','True')
                        else Registry.WriteString('NIStandardIncExempt','False');
                 Registry.Free;

                 // End Ch017

                 if cash2.XAllocation and cash2.XPaymentVAT then begin
                       act := 11;
                       uvatreps.PrintVatReport;
                 end
                    else begin
                             if not UseNewVatReportCB.checked then begin

                                     VATDateFrom.SetFocus;
                                     DateFromExit(VATDateFrom);
                                     VATDateTo.SetFocus;
                                     DateToExit(VATDateTo);
                                     VatTxFromExit(VATTxFrom);
                                     VatTxToExit(VATTxTo);
                                     //VATRepDate.SetFocus;
                                     REPXDATE := VATRepDate.Text;
                                     If ( Cash2.xCountry = 2 ) Then
                                        Begin
                                              PROG := CUSTREP;
                                              Rep ( 11, 0 );
                                              If VatAuditChecked.Checked Then
                                                  Begin
                                                        PROG := SPECREP;
                                                        NomReports ( 24, 0 );   { 91 indicates the IRL Audit Trail }
                                              End
                                     End
                                         Else
                                              Begin
                                                    PROG := SPECREP;
                                                    NomReports ( 8, 0 );
                                              End;

                             end
                                 else begin
                                           act := 11;
                                           uvatreps.PrintVatReport;
                                      end;

                             if MarkVAT then MarkVATAsProcessed;      // Ch006     22/03/19

                    end;
            End // VATPanel
         Else If pPrintNomsOrGroups.Visible Then
            Begin
                 REPXDATE := TrialBalanceDate.Text;
                 PROG := SPECREP;
                 if TrialByAccount.Checked then
                    ACT := 88   // List Groups
                 else
                    ACT := 89;  // List Nominals
                 NomReports ( ACT, NlFile );
            End
         Else If pEntStructure.Visible Then
            Begin
                 REPXDATE := TrialBalanceDate.Text;
                 PROG := SPECREP;
                 ACT := 66;   // List Enterprise Structure
                 NomReports ( ACT, NlFile );
            End;

end;

procedure TNominalReportForm.ExitbtnClick(Sender: TObject);
begin
     Close;
end;

procedure TNominalReportForm.FormActivate(Sender: TObject);
Var i : Integer;
Begin
     Panel2.Visible := not NewRepForm.NewReports.Checked;
//     NominalReportForm.SetFocus;
     If Device = 'P' Then
        PReports.Checked := True
     Else
         VReports.Checked := True;

     For i := 0 To ComponentCount-1 Do
         Begin
              If ( NominalReportForm.Components[i] is TEdit ) Then
                 TEdit(Components[i]).Clear;
              If ( NominalReportForm.Components[i] is TCheckBox ) Then
                 TCheckBox(Components[i]).Checked := False;
         End;

     // TGM AB 21/07/17  - updated defaults for Bank Audit Trial
     PrintZero.checked := true;
     // BATSortRG.itemindex := 1;     // TGM AB 19/01/18
     // end TGM AB 21/07/17

     If rgbytrans.itemindex = 0 then UseTransCheck.checked := true
        else UseTransCheck.Checked := false;
     TxDateFrom := CDateFrom;
     TxDateTo   := CDateTo;
     RepDate.Text := Cash1.xDate;
     TrialBalanceDate.Text := Cash1.xDate;
     VatRepDate.Text := Cash1.xDate;
     ShowYearMonth.Enabled := False;
  //   CalMonth.Enabled := False;
  //   CalMonthLabel.Enabled := False;
     CalMonth.Text := IntToStr(Cash1.xMonthNo);
     MonthPanel.visible := false;
     TrialBalanceDate.Text := Cash1.xDate;
     BankAuditDate.Text := Cash1.xDate;
     CashBookDate.Text := Cash1.xDate;
     TransListingDate.Text := Cash1.xDate;
     Setdb ( TxFile );
     TxFrom.Text := IntToStr(xFirstTx);//'1'; gm changed 11/05/02
     ListingTxFrom.Text := IntToStr(xFirstTx);//'1';
     Transfrom := xFirstTx;//1;
      TransTo   := db1.dbrechigh;
     VatTxFrom.Text := IntToStr(xFirstTx);//'1';
     VatTxTo.Text := IntToStr ( TransTo );
     TxTo.Text := IntToStr ( db1.dbrechigh );
     NomTxFrom.Text := IntToStr(xFirstTx);//'1';
     NomTxTo.Text := IntToStr ( db1.dbrechigh );
     ListingTxTo.Text := IntToStr ( db1.dbrechigh );
     IncomeListing.Checked := True;
     ExpendListing.Checked := False;
     WhichStub.Text := 'A';
     ListAllCheck.Checked := True;
     ListCashIncCheck.Enabled := False;
     ListCashExpCheck.Enabled := False;
     ListDDJCheck.Enabled := False;
     ListCustCheck.Enabled := False;
     ListSuppCheck.Enabled := False;
     SetDb ( NlFile );
     NomFrom := 1;
     NomTo   := db1.dbrechigh;
     NomAccFrom.Text := '1';
     NomAccTo.Text   := IntToStr ( db1.dbrechigh );
     {if UseTransCheck.Checked then begin
        UseTransPanel.Show;
        UseDatePanel.Hide
     end else begin
        UseTransPanel.Hide;
        UseDatePanel.Show;
     end;}
     { Move the Date Panel over the transaction panel }
     UseDatePanel.Left := UseTransPanel.Left;
     UseDatePanel.Top := UseTransPanel.Top;
     NomRepDate.Text := Cash1.xDate;

    AuditByAcc.Checked      := True;
     TrialByAccount.Checked  := True;
     IncStartYearBal.Checked := True;
     IncMoveYear.Checked     := True;
     IncStartMthBal.Checked  := False;
     IncMoveMth.Checked      := False;
     UseNewAuditReportCB.Checked := True; // TGM AB 02/08/13
     UseNewVATReportCB.checked := true; // TGM AB 17/07/15

 {*//  TGM AB 17/07/15
     if cash2.XAllocation and cash2.XPaymentVAT then begin         //TGM AB New Payment based report option
              PaymentCb.Visible := true;
              PaymentCb.checked := true;
              UseNewVATReportCB.Visible := false;
     end
          else begin
               PaymentCb.Visible := false;
               UseNewVATReportCB.Visible := true;
               UseNewVATReportCB.checked := true; // TGM AB Use new VAT Report option

          end;

     // PaymentCb - hidden on form as no longer used
     // UseNewVATReportCB - hidden on form as no longer option to use old report
     // End TGM AB 17/07/15
  *}

{     If CashFlowMainForm.ManageMentBalanceSheetRadio.Checked Then
        Caption := CashFlowMainForm.ManageMentBalanceSheetRadio.Caption + ' - ' + st;}


   VatAuditChecked.Checked := MainGridVatSumChecked
end;

procedure TNominalReportForm.CalMonthExit(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := CalMonth.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        Begin
            If NOT ( StrToInt ( TempStr ) In [1..12]) Then
               CalMonth.SetFocus;
        End
     Else
         CalMonth.SetFocus;
end;

procedure TNominalReportForm.AccFromKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
          if TrialByAccount.Checked then
             NewListBox.ListIt ( Sender, AllNoms, 'N' )
          else
             NewListBox.ListIt ( Sender, AllNoms, 'G' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
             AccFrom.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TNominalReportForm.AccToKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
          if TrialByAccount.Checked then
             NewListBox.ListIt ( Sender, AllNoms, 'N' )
          else
             NewListBox.ListIt ( Sender, AllNoms, 'G' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
             AccTo.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TNominalReportForm.ShowYearMonthExit(Sender: TObject);
begin
     If NOT ShowYearMonth.Checked Then
         Begin
           //   CalMonthLabel.Enabled := True;
           //   CalMonth.Enabled := True;
              MonthPanel.visible := true;
              MonthTypeSelectRGClick(self);
         End
     Else
         Begin
          //    CalMonthLabel.Enabled := False;
          //    CalMonth.Enabled := False;
              MonthPanel.visible := false;
         End;
end;

procedure TNominalReportForm.ExtendedEnter(Sender: TObject);
begin
     If Extended.Checked Then
        begin
           ShowYearMonth.Enabled := True;
           ShowYearMonth.Checked := True;
        end
     Else
         Begin
             ShowYearMonth.Checked := FALSE;
             ShowYearMonth.Enabled := False;
       //      CalMonthLabel.Enabled := False;
       //      CalMonth.enabled := False;
             MonthPanel.visible := false;
         End;
end;

procedure TNominalReportForm.WhichStubChange(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := WhichStub.Text;
     SlimAll ( TempStr );
     If WhichStub.CanFocus Then
        If NOT ( TempStr[1] In ['A','P','U'] ) Then
           WhichStub.SetFocus;
end;

procedure TNominalReportForm.TxToEnter(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := (Sender as tEdit).Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        TransTo := StrToInt ( TempStr );
     If ( TransFrom > TransTo ) Then
        (Sender as tEdit).SetFocus;
end;

procedure TNominalReportForm.TxFromEnter(Sender: TObject);
Var
   TempStr : ShortString;  // TGM AB 26/02/02
begin
     TempStr := (Sender as tEdit).Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        TransFrom := StrToInt ( TempStr );
     If ( TransFrom > TransTo ) Then
        (Sender as tEdit).SetFocus;
end;

procedure TNominalReportForm.ListingTxfromEnter(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := ListingTxFrom.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        TransFrom := StrToInt ( TempStr )
     Else
        ListingTxFrom.SetFocus;
     If ( TransFrom > TransTo ) Then
        ListingTxFrom.SetFocus;
end;

procedure TNominalReportForm.ListingTxToEnter(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := ListingTxTo.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        TransTo := StrToInt ( TempStr )
     Else
        ListingTxTo.SetFocus;
     If ( TransFrom > TransTo ) Then
        ListingTxFrom.SetFocus;
end;

procedure TNominalReportForm.ListAllCheckEnter(Sender: TObject);
begin
     If ListAllCheck.Checked Then
       Begin
         ListCashIncCheck.Enabled := False;
         ListCashExpCheck.Enabled := False;
         ListDDJCheck.Enabled := False;
         ListCustCheck.Enabled := False;
         ListSuppCheck.Enabled := False;
         ListCashIncCheck.Checked := False;
         ListCashExpCheck.Checked := False;
         ListDDJCheck.Checked := False;
         ListCustCheck.Checked := False;
         ListSuppCheck.Checked := False;
       End
     Else
       Begin
         ListCashIncCheck.Enabled := True;
         ListCashExpCheck.Enabled := True;
         ListDDJCheck.Enabled := True;
         ListCustCheck.Enabled := True;
         ListSuppCheck.Enabled := True;
       End;
end;

procedure TNominalReportForm.NomTxFromEnter(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := NomTxFrom.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        TransFrom := StrToInt ( TempStr )
     Else
        NomTxFrom.SetFocus;
     If ( TransFrom > TransTo ) Then
        NomTxFrom.SetFocus;
end;

procedure TNominalReportForm.NomTxToEnter(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := NomTxTo.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        TransTo := StrToInt ( TempStr )
     Else
        NomTxTo.SetFocus;        
     If ( TransFrom > TransTo ) Then
        NomTxTo.SetFocus;
end;

procedure TNominalReportForm.NomAccFromEnter(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := NomAccFrom.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        NomFrom := StrToInt ( TempStr );
     If ( NomFrom = 0 ) Then
        NomAccFrom.SetFocus;
end;

procedure TNominalReportForm.NomAccToEnter(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := NomAccTo.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        NomTo := StrToInt ( TempStr );
     If ( NomFrom > NomTo ) or ( NomTo = 0 ) Then
        NomAccTo.SetFocus;
end;

procedure TNominalReportForm.NomAccFromKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    {NKeyDown ( Sender, Key, Shift );}
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
          if AuditByAcc.Checked then
             NewListBox.ListIt ( Sender, AllNoms, 'N' )
          else
             NewListBox.ListIt ( Sender, AllNoms, 'G' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
             NomAccFrom.Text := NewListBox.ListInfo.ReturnValue;
          NomAccFrom.SetFocus;
       End;
end;

procedure TNominalReportForm.NomAccToKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
          if AuditByAcc.Checked then
             NewListBox.ListIt ( Sender, AllNoms, 'N' )
          else
             NewListBox.ListIt ( Sender, AllNoms, 'G' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
             NomAccTo.Text := NewListBox.ListInfo.ReturnValue;
          NomAccTo.SetFocus;
       End;
end;

procedure TNominalReportForm.UseTransCheckEnter(Sender: TObject);
begin
     If UseTransCheck.Checked Then
        Begin
             UseTransPanel.Show;
             UseDatePanel.Hide;
             NominalReportForm.DateFromExit(sender);
             NominalReportForm.DateToExit(sender);
             TxDateFrom := CDateFrom;
             TxDateto   := CDateTo;
        End
     Else
         Begin
             UseTransPanel.Hide;
             UseDatePanel.Show;
             SetDb ( Txfile );
             TransFrom := 1;
             TransTo   := db1.dbrechigh;
             datefromExit(NomDateFrom);
             DateToExit(NomDateTo);
         End;

end;

procedure TNominalReportForm.BankAuditAccFromKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
          NewListBox.ListIt ( Sender, Banks, 'N' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            BankAuditAccFrom.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TNominalReportForm.BankAuditAccToKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
          NewListBox.ListIt ( Sender, Banks, 'N' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
             BankAuditAccTo.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TNominalReportForm.VReportsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     KPrinterOrScreen ( Sender, Button, Shift, x, y );
end;

procedure TNominalReportForm.nomAccountsFromClick(Sender: TObject);
begin
     if AuditByAcc.Checked then
        NewListBox.ListIt ( Sender, AllNoms, 'N' )
     else
        NewListBox.ListIt ( Sender, AllNoms, 'G' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        NomAccFrom.Text := NewListBox.ListInfo.ReturnValue;
     NomAccFrom.SetFocus;
end;

procedure TNominalReportForm.NomAccountsToClick(Sender: TObject);
begin
     if AuditByAcc.Checked then
        NewListBox.ListIt ( Sender, AllNoms, 'N' )
     else
        NewListBox.ListIt ( Sender, AllNoms, 'G' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        NomAccTo.Text := NewListBox.ListInfo.ReturnValue;
     NomAccTo.SetFocus;
end;

procedure TNominalReportForm.SpeedButton3Click(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Banks, 'N' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        BankAuditAccTo.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TNominalReportForm.SpeedButton2Click(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Banks, 'N' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        BankAuditAccFrom.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TNominalReportForm.TransListingDateFromSearchCloseUp(Sender: TObject);
begin
     TransListingDateFrom.Text:= DateToStr(TransListingDateFromSearch.Date);
     TransListingDateFrom.SetFocus;
end;

procedure TNominalReportForm.TransListingDateToSearchCloseUp(Sender: TObject);
begin
     TransListingDateTo.Text:= DateToStr(TransListingDateToSearch.Date);
     TransListingDateTo.SetFocus;
end;

procedure TNominalReportForm.TransListingDateSearchCloseUp(Sender: TObject);
begin
     TransListingDate.Text:= DateToStr(TransListingDateSearch.Date);
     TransListingDate.SetFocus;
end;

procedure TNominalReportForm.MaskEdit1Enter(Sender: TObject);
begin
     (Sender as TEdit).Text := Cash1.xDate;
end;

procedure TNominalReportForm.RepDateExit(Sender: TObject);
begin
     KDateValid ( Sender );
end;

procedure TNominalReportForm.RepSearchCloseUp(Sender: TObject);
begin
     RepDate.Text:= DateToStr(RepSearch.Date);
     RepDate.SetFocus;
end;

procedure TNominalReportForm.FormShow(Sender: TObject);
begin

     TransLabel.Caption := 'The first transaction of the current year is transaction ' + IntToStr(xFirstTx);
     RepSearch.Date := KStrToDate (Cash11.Default_Date);
     NomRepSearch.Date := KStrToDate (Cash11.Default_Date);
     BankAuditDateSearch.Date := KStrToDate (Cash11.Default_Date);
     VATRepDateSearch.Date := KStrToDate (Cash11.Default_Date);
     TrialBalanceDateSearch.Date := KStrToDate (Cash11.Default_Date);
     TranslistingDateSearch.Date := KStrToDate (Cash11.Default_Date);
     CashbookDateSearch.Date := KStrToDate (Cash11.Default_Date);

     //NomDateFromSearch.Date := KStrToDate (Cash11.Default_Date);
     //NomDateToSearch.Date := KStrToDate (Cash11.Default_Date);

     DateFromSearch.Date := KStrToDate (Cash11.Default_Date);
     DateToSearch.Date := KStrToDate (Cash11.Default_Date);

     VATDateFromExitSearch.Date := KStrToDate (Cash11.Default_Date);
     VATDateToExitSearch.Date := KStrToDate (Cash11.Default_Date);

     ListingDateFromSearch.Date := KStrToDate (Cash11.Default_Date);
     ListingDateToSearch.Date := KStrToDate (Cash11.Default_Date);

     TransListingDateFromSearch.Date := KStrToDate (Cash11.Default_Date);
     TransListingDateToSearch.Date := KStrToDate (Cash11.Default_Date);

     RepDate.Text := Cash1.xDate;
     NomRepDate.Text := Cash1.xDate;
     BankAuditDate.Text := Cash1.xDate;
     VATRepDate.Text := Cash1.xDate;
     TrialBalanceDate.Text := Cash1.xDate;
     TranslistingDate.Text := Cash1.xDate;
     CashbookDate.Text := Cash1.xDate;

     Label19.caption := 'Account From';
     Label20.caption := 'Account To';       // TGM AB 08/05/02 Sets up group / account labels for full nominal audit form
     rgaccountgroup.itemindex := 0;
     rgaccountgroup2.itemindex := 0;  // TGM AB 03/09/04 was 0
     rgbytrans.itemindex :=0;
     //UseTransCheck.Checked:=true;
     accfromlabel.caption := 'Account From';
     acctolabel.caption := 'Account To';



     if UseTransCheck.Checked then begin
        rgbytrans.itemindex := 0;
        UseTransPanel.Show;
        UseDatePanel.Hide
     end else begin
        UseTransPanel.Hide;
        UseDatePanel.Show;
        rgbytrans.itemindex := 1;
     end;

end;

procedure TNominalReportForm.NomRepSearchCloseUp(Sender: TObject);
begin
     NomRepDate.Text:= DateToStr(NomRepSearch.Date);
     NomRepDate.SetFocus;
end;

procedure TNominalReportForm.NomDateFromSearchCloseUp(Sender: TObject);
begin
     NomDateFrom.Text:= DateToStr(NomDateFromSearch.Date);
     NomDateFrom.SetFocus;
end;

procedure TNominalReportForm.NomDateToSearchCloseUp(Sender: TObject);
begin
     NomDateTo.Text:= DateToStr(NomDateToSearch.Date);
     NomDateTo.SetFocus;
end;

procedure TNominalReportForm.BankAuditDateSearchCloseUp(Sender: TObject);
begin
     BankAuditDate.Text := DateToStr(BankAuditDateSearch.Date);
     BankAuditDate.SetFocus;
end;

procedure TNominalReportForm.DateToExit(Sender: TObject);
begin
     KDateToExit ( Sender, Report );
     if DateTo.text <> '  /  /  ' then BATSortRG.itemindex := 1;    // TGM AB 13/11/17

end;

procedure TNominalReportForm.DateFromExit(Sender: TObject);
begin
     KDateFromExit ( Sender, Report );
     if DateFrom.text <> '  /  /  ' then BATSortRG.itemindex := 1  // TGM AB 13/11/17
end;

procedure TNominalReportForm.VatRepDateSearchCloseUp(Sender: TObject);
begin
     VatRepDate.Text:= DateToStr(VatRepDateSearch.Date);
     VatRepDate.SetFocus;
end;

procedure TNominalReportForm.VatDateFromExitSearchCloseUp(Sender: TObject);
begin
     VatDateFrom.Text:= DateToStr(VatDateFromExitSearch.Date);
     VatDateFrom.SetFocus;
end;

procedure TNominalReportForm.VatDateToExitSearchCloseUp(Sender: TObject);
begin
     VatDateTo.Text:= DateToStr(VatDateToExitSearch.Date);
     VatDateTo.SetFocus;
end;

procedure TNominalReportForm.TrialBalanceDateSearchCloseUp(
  Sender: TObject);
begin
     TrialBalanceDate.Text:= DateToStr(TrialBalanceDateSearch.Date);
     TrialBalanceDate.SetFocus;
end;

procedure TNominalReportForm.sbAccFromClick(Sender: TObject);
begin
     if TrialByAccount.Checked then
        NewListBox.ListIt ( Sender, AllNoms, 'N' )
     else
        NewListBox.ListIt ( Sender, AllNoms, 'G' );
     if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
        AccFrom.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TNominalReportForm.sbAccToClick(Sender: TObject);
begin
     if TrialByAccount.Checked then
        NewListBox.ListIt ( Sender, AllNoms, 'N' )
     else
        NewListBox.ListIt ( Sender, AllNoms, 'G' );
     // NewListBox.ListIt ( Sender, AllNoms, 'N' );
     if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
        AccTo.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TNominalReportForm.CashBookDateSearchCloseUp(Sender: TObject);
begin
     CashBookDate.Text:= DateToStr(CashBookDateSearch.Date);
     CashBookDate.SetFocus;
end;

procedure TNominalReportForm.ListingDateFromSearchCloseUp(Sender: TObject);
begin
     ListingDateFrom.Text:= DateToStr(ListingDateFromSearch.Date);
     ListingDateFrom.SetFocus;
end;

procedure TNominalReportForm.ListingDateToSearchCloseUp(Sender: TObject);
begin
     ListingDateTo.Text:= DateToStr(ListingDateToSearch.Date);
     ListingDateTo.SetFocus;
end;

procedure TNominalReportForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     NomDateFrom.Text          := '  /  /  ';
     NomDateTo.Text            := '  /  /  ';
     DateFrom.Text             := '  /  /  ';
     DateTo.Text               := '  /  /  ';
     VATDateFrom.Text          := '  /  /  ';
     VATDateTo.Text            := '  /  /  ';
     ListingDateFrom.Text      := '  /  /  ';
     ListingDateTo.Text        := '  /  /  ';
     TransListingDateFrom.Text := '  /  /  ';
     TransListingDateTo.Text   := '  /  /  ';
end;

procedure TNominalReportForm.DateFromSearchCloseUp(Sender: TObject);
begin
     DateFrom.Text:= DateToStr(DateFromSearch.Date);
     DateFrom.SetFocus;
end;

procedure TNominalReportForm.DateToSearchCloseUp(Sender: TObject);
begin
     DateTo.Text:= DateToStr(DateToSearch.Date);
     DateTo.SetFocus;
end;

procedure TNominalReportForm.VatTxFromExit(Sender: TObject);
Var TempStr : Shortstring;
begin
     TempStr := (Sender as tEdit).Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        TransFrom := StrToInt ( TempStr )
     Else
        VATTxFrom.SetFocus;
     If ( TransFrom > TransTo ) Then
        (Sender as tEdit).SetFocus;
end;

procedure TNominalReportForm.VatTxToExit(Sender: TObject);
Var TempStr : Shortstring;
begin
     TempStr := (Sender as tEdit).Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        TransTo := StrToInt ( TempStr )
     Else
        VATTxTo.SetFocus;
end;

procedure TNominalReportForm.HelpClick(Sender: TObject);
begin
     If TransListingPanel.Visible Then         //transaction listong
        Application.HelpContext(160)
     Else If CashbookListingPanel.Visible Then // CashB Income/exp listing
        Application.HelpContext(161)
     Else If BankAuditPanel.Visible Then       // bank audit trail
        Application.HelpContext(162)
     Else If TrialBalancePanel.Visible then    // trial balance
        Application.HelpContext(163)
     Else If FullNominalPanel.Visible Then     // Full nom ledger
        Application.HelpContext(164)
     Else If BalanceSheetPanel.Visible Then    // Management report
        Application.HelpContext(170)
     Else If VatPanel.Visible then             // VAT Rep
        Application.HelpContext(165);
end;

procedure TNominalReportForm.BankAuditAccFromExit(Sender: TObject);
begin
     If BankAuditAccFrom.Text = '0' Then
        BankAuditAccFrom.SetFocus;
end;

procedure TNominalReportForm.BankAuditAccToExit(Sender: TObject);
begin
     If BankAuditAccTo.Text = '0' Then
        BankAuditAccTo.SetFocus;
end;

procedure TNominalReportForm.AccFromExit(Sender: TObject);
Var AccFromNo : Integer;
begin
   try
     AccFromNo := StrToInt(AccFrom.Text);
     if (AccFromNo = 0) Then
        AccFrom.SetFocus;
   except
     // Do nothing
   end;
end;

procedure TNominalReportForm.AccToExit(Sender: TObject);
Var AccToNo,
    AccFromNo : Integer;
begin
   try
     AccFromNo := StrToInt(AccFrom.Text);
     AccToNo := StrToInt(AccTo.Text);
     If ((AccToNo = 0) or (AccFromNo > AccToNo)) Then
        AccTo.SetFocus;
   except
     // Do nothing
   end;
end;

procedure TNominalReportForm.SetNominalReportForm(RptType : TRptType);
var                                 // Ch017
        Registry : tregistry;       // Ch017
begin
    VatPanel.Hide;
    FullNominalPanel.Hide;
    CashBookListingPanel.Hide;
    BalanceSheetPanel.Hide;
    TransListingPanel.Hide;
    BankAuditPanel.Hide;
    TrialBalancePanel.Hide;
    pPrintNomsOrGroups.Hide;
    pEntStructure.Hide;
    ExportBtn.hide;
    Panel1.width := 258;
    ExportBtn.Caption := ' Export ';

    case RptType of
       NomsOrGroups : begin
                        lDate.Parent := pPrintNomsOrGroups;
                        TrialBalanceDate.Parent := pPrintNomsOrGroups;
                        TrialBalanceDateSearch.Parent := pPrintNomsOrGroups;
                        TrialByAccount.Parent := pPrintNomsOrGroups;
                        AccFromLabel.Parent   := pPrintNomsOrGroups;
                        AccToLabel.Parent     := pPrintNomsOrGroups;
                        AccFrom.Parent        := pPrintNomsOrGroups;
                        sbAccFrom.Parent      := pPrintNomsOrGroups;
                        AccTo.Parent          := pPrintNomsOrGroups;
                        sbAccTo.Parent        := pPrintNomsOrGroups;
                        pPrintNomsOrGroups.Show;
                        Caption := 'Nominal Accounts/Groups Listing';
                      end;
       ManBalSheet  : begin
                        BalanceSheetPanel.Show;
                        Caption := 'Management Balance Sheet';
                      end;
       TxList       : begin
                        TransListingPanel.Show;
                        Caption := 'Transaction Listing';
                        ExportBtn.show;
                        Panel1.width := 372;            // Ch025 // was 345
                        ExportBtn.Caption := 'CSV Export';  // Ch028
                      end;
       CashIncExp   : begin
                        CashBookListingPanel.Show;
                        Caption := 'Cashbook Income/Expenditure Listing';
                        ExportBtn.show;
                        Panel1.width := 372;            // Ch025 // was 345
                      end;
       BankAudit    : begin
                        BankAuditPanel.Show;
                        Caption := 'Bank Audit Trail';
                        ExportBtn.show;
                        Panel1.width := 372;            // Ch025 // was 345
                        Label7.Visible := true;      // TGM AB 19/01/18
                        WhichStub.visible := true;   // TGM AB 19/01/18
                        PrintCarriedDetails.Visible := True;   // TGM AB 19/01/18
                        PrintCarriedDetails.checked := True;   // TGM AB 19/01/18
                        ReportDateCoverPanel.hide;    // TGM AB 19/01/18
                        ExportBtn.Caption := 'CSV Export';  // Ch025
                      end;
       TrialBalance : begin
                        lDate.Parent          := TrialBalancePanel;
                        TrialBalanceDate.Parent := TrialBalancePanel;
                        TrialBalanceDateSearch.Parent := TrialBalancePanel;
                        TrialByAccount.Parent := TrialBalancePanel;
                        AccFromLabel.Parent   := TrialBalancePanel;
                        AccToLabel.Parent     := TrialBalancePanel;
                        AccFrom.Parent        := TrialBalancePanel;
                        sbAccFrom.Parent      := TrialBalancePanel;
                        AccTo.Parent          := TrialBalancePanel;
                        sbAccTo.Parent        := TrialBalancePanel;
                        TrialBalancePanel.Show;
                        Caption := 'Trial Balance';
                        ExportBtn.show;           // Re-activated Ch025
                        Panel1.width := 372;      // Re-activated Ch025  // was 345
                        ExportBtn.Caption := 'CSV Export';  // Ch025
                      end;
       FullNomAudit    : begin     // changed form FullAudit to FullNomAudit 27/02/02 TGM AB
                        FullNominalPanel.Show;
                        Caption := 'Full Nominal Ledger Audit Trail';
                        ExportBtn.show;
                        Panel1.width := 372;       // Ch025 // was 345
                        ExportBtn.Caption := 'CSV Export';  // Ch025
                      end;
       VatReport    : begin
                        VatPanel.Show;
                        Caption := 'VAT Report';

                        // Ch006
                        if cash2.xcountry = 1 then
                           MTDPanel.visible := not AccsDataModule.DigitalVATReturnCompleted()        // Northern Ireland
                        else
                           MTDPanel.visible := False;

                        MarkTxVATCB.checked := False;
                        // end CH006





                        // Ch017

                        if ((cash2.xcountry = 1) and (cash2.XPaymentVAT = false)) then IncludeExemptCB.Visible := True
                                else IncludeExemptCB.Visible := false;

                        Registry:=Tregistry.Create;
                        Registry.OpenKey('Software\Kingswood\Kingsacc\VATAuditDefaults', True);
                        if Registry.ReadString('NIStandardIncExempt') = 'True' then IncludeExemptCB.checked := true
                        else IncludeExemptCB.checked := false;
                        Registry.Free;

                        // end Ch017

                      end;
       EntStructure : begin
                        lDate.Parent            := pEntStructure;
                        TrialBalanceDate.Parent := pEntStructure;
                        TrialBalanceDateSearch.Parent := pEntStructure;
                        pEntStructure.Show;
                        Caption := 'Enterprise Structure Report';
                      end;
       BankTransListing    : begin                     // start TGM AB 19/01/18
                        BankAuditPanel.Show;
                        Caption := 'Bank Transaction Listing';
                        Panel1.width := 258;          // Ch025 // was 345 no export
                        Label7.Visible := False;
                        WhichStub.visible := False;
                        PrintCarriedDetails.Visible := True;         // here
                        PrintCarriedDetails.checked := false;
                        ReportDateCoverPanel.show;
                        BATSortRG.itemindex := 1;
                      end;                            // end TGM AB 19/01/18
    end;
end;

procedure TNominalReportForm.EntAccountsClick(Sender: TObject);
begin
      NewListBox.ListIt ( Sender, Enterprise, 'E' );
      If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
         EntCode.Text := NewListBox.ListInfo.ReturnValue;
      EntCode.SetFocus;
end;

procedure TNominalReportForm.EntCodeExit(Sender: TObject);
Var
   TempStr : ShortString;
   RecNo   : Integer;
begin
     TempStr := EntCode.Text;
     SlimAll ( TempStr );
     if Length ( TempStr ) > 0 then
        if NOT CheckEnt ( EntCode.Text, RecNo ) then
           EntCode.SetFocus;
end;


    // TGM AB 08/05/02 - Next 3 procedures were introduced to enable the radio check gropus to replace the single tick box for
    // By Account / group - trial balance
    // By Account / group - full nominal audit trail
    // By transaction / date range - full nominal audit trail
    // they simply check / unchecl the original ticvk boxes to avoid the need to change large numbers of references within the code

procedure TNominalReportForm.rgAccountGroupClick(Sender: TObject);
begin
     if rgaccountgroup.ItemIndex = 0 then begin
                                          trialbyaccount.checked := true;
                                          accfromlabel.caption := 'Account From';
                                          acctolabel.caption := 'Account To';
                                          end
        else begin
             trialbyaccount.checked := false;
             accfromlabel.caption := 'Group From';
             acctolabel.caption := 'Group To';
        end;
end;

procedure TNominalReportForm.rgAccountGroup2Click(Sender: TObject);
var
    flag : boolean;
begin
     if rgaccountgroup2.ItemIndex = 0 then begin
                                           auditbyacc.checked := true;
                                           label19.caption := 'Account From';
                                           label20.caption := 'Account To';
                                           SetDB (NLFile);
                                           NomAccFrom.text := '1';
                                           NomAccTo.text   := vartostr(db1.dbrechigh);
     end
        else begin
                  auditbyacc.checked := false;
                  label19.caption := 'Group From';
                  label20.caption := 'Group To';

                  flag := false;

                  Accsdatamodule.NLGroupsDB.open;
                  Accsdatamodule.NLGroupsDB.first;

                  while flag = false do
                  begin
                     if Accsdatamodule.NLGroupsDB['Active'] = true then flag := true;
                        Accsdatamodule.NLGroupsDB.next;
                  end;

                  NomAccFrom.text := (Accsdatamodule.NLGroupsDB['GroupNo']-1);

                  flag := false;

                  Accsdatamodule.NLGroupsDB.open;
                  Accsdatamodule.NLGroupsDB.last;

                  while flag = false do
                  begin
                     if Accsdatamodule.NLGroupsDB['Active'] = true then flag := true;
                     Accsdatamodule.NLGroupsDB.prior;
                  end;

                  NomAccTo.text := (Accsdatamodule.NLGroupsDB['GroupNo']+1);

        end;

end;

procedure TNominalReportForm.rgbytransClick(Sender: TObject);
begin
     if rgbytrans.ItemIndex = 0 then usetranscheck.checked := true
        else usetranscheck.checked := false;
     UseTransCheckEnter(self);
end;

    // End TGM AB

procedure TNominalReportForm.FormCreate(Sender: TObject);
begin
//     NomDateFromSearch.Date := KStrToDate (Cash11.Default_Date);
//     NomDateToSearch.Date := KStrToDate (Cash11.Default_Date);
   MainGridVatSumChecked := False;

end;

procedure TNominalReportForm.ExportBtnClick(Sender: TObject);
begin
//Start Ch025

        SaveCSVExportdialog.FileName := '';

        if TrialBalancePanel.Visible then begin
                if SaveCSVExportdialog.Execute then TrialBalanceReportExport(SaveCSVExportdialog.FileName);
        end else
                if BankAuditPanel.Visible then begin
                           if SaveCSVExportdialog.Execute then BankAuditReportExport(SaveCSVExportdialog.FileName);
                end else
                        if FullNominalPanel.Visible then begin
                                 if SaveCSVExportdialog.Execute then FullNominalReportExport(SaveCSVExportdialog.FileName);
                        end else begin
                                     reportdefs.ExportToCSV := true;
                                      runclick(self);
                        end;


//End Ch025

       // reportdefs.ExportToCSV := true;      //Ch025
       // runclick(self);                      //Ch025
end;

procedure TNominalReportForm.MonthFromExit(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := MonthFrom.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        Begin
            If NOT ( StrToInt ( TempStr ) In [1..12]) Then
               MonthFrom.SetFocus;
        End
     Else
         MonthFrom.SetFocus;
end;

procedure TNominalReportForm.MonthToExit(Sender: TObject);
Var
   TempStr : ShortString;
begin
     TempStr := MonthTo.Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        Begin
            If NOT ( StrToInt ( TempStr ) In [1..12]) Then
               MonthTo.SetFocus;
        End
     Else
         MonthTo.SetFocus;
end;

procedure TNominalReportForm.MonthTypeSelectRGClick(Sender: TObject);
begin
        if MonthTypeSelectRG.CheckedIndex = 0 then begin
             Calmonth.visible := True;
             MonthFrom.Visible := false;
             Tolbl.Visible := false;
             MonthTo.Visible := false;
             LastYrLbl.visible := false;
             ThisYrLbl.visible := false;
        end;
        if MonthTypeSelectRG.CheckedIndex = 1 then begin
             Calmonth.visible := False;
             MonthFrom.Visible := True;
             Tolbl.Visible := True;
             MonthTo.Visible := True;
             LastYrLbl.visible := false;
             ThisYrLbl.visible := false;
        end;
        if MonthTypeSelectRG.CheckedIndex = 2 then begin
             Calmonth.visible := False;
             MonthFrom.Visible := True;
             Tolbl.Visible := True;
             MonthTo.Visible := True;
             LastYrLbl.visible := True;
             ThisYrLbl.visible := True;
        end;
end;

procedure TNominalReportForm.BATSortRGClick(Sender: TObject);
begin
        if ((DateFrom.text <> '  /  /  ') or (DateTo.text <> '  /  /  ')) then BATSortRG.itemindex := 1 
end;


procedure TNominalReportForm.MarkVATAsProcessed;
var
        MyQuery : TQuery;
        FormattedDate : String;
        i, RecNo : integer;
begin
    // Ch006 - new Procedure

    // Mark all transactions before starting Tx Numbers & dates

    if VatTxFrom.Text <> '' then begin

        // check value is numeric & not 1
        If ((Numeric(VatTxFrom.Text)) and (StrToInt(VatTxFrom.Text) > 1)) Then begin

               MyQuery := TQuery.create(self);
               Myquery.DatabaseName := accsdatamodule.AccsDataBase.databasename;
               MyQuery.SQL.clear;
               MyQuery.SQL.add ('Update Transactions set VATProcessed = ''True'' Where TxNo < ' + VatTxFrom.Text);
               MyQuery.ExecSQL;

               MyQuery.close;
               MyQuery.free;
        end;
    end;

    if VatDateFrom.Text <> '  /  /  ' then begin

               FormattedDate := FormatDateTime('mm/dd/yy', strtodate(VatDateFrom.Text));

               MyQuery := TQuery.create(self);
               Myquery.DatabaseName := accsdatamodule.AccsDataBase.databasename;
               MyQuery.SQL.clear;
               MyQuery.SQL.add ('Update Transactions set VATProcessed = ''True'' Where TxDate < "' + FormattedDate + '"');
               MyQuery.ExecSQL;

               MyQuery.close;
               MyQuery.free;

    end;


    // Process records in the return

    RecNo := 0;

    Accsdatamodule.TempVATDB.First;

    for i:= 1 to Accsdatamodule.TempVATDB.RecordCount do begin

        if length(Accsdatamodule.TempVATDB.FieldByName('Record').AsString) > 0 then begin

             try RecNo := StrToInt(Accsdatamodule.TempVATDB['Record']);
             except RecNo := 0;
             end;

             if Accsdatamodule.TransactionsDB.locate('TxNo',RecNo,[]) then begin
                  Accsdatamodule.TransactionsDB.edit;
                  Accsdatamodule.TransactionsDB['VATPRocessed'] := True;
                  Accsdatamodule.TransactionsDB.Post;
             end;

        end;

        Accsdatamodule.TempVATDB.next;

    end;

    // Mark Transactions in the Year-1 File as processed so they won't appear on the report

    MyQuery := TQuery.create(self);
    Myquery.DatabaseName := accsdatamodule.AccsDataBase.databasename;
    MyQuery.SQL.clear;
    MyQuery.SQL.add ('Update "Year-1" set VATProcessed = ''True''');
    MyQuery.ExecSQL;

    MyQuery.close;
    MyQuery.free;

end;

// Ch025 start

procedure TNominalReportForm.FullReportExportBtnClick(Sender: TObject);
begin
        reportdefs.ExportToCSV := true;
        runclick(self);
end;



procedure TNominalReportForm.TrialBalanceReportExport(Filename : string);
var
        OutputFile : textfile;
        i : integer;
        outputline : string;
        ColumnCount : Integer;

begin

        // Run report but don't preview

        if not bool (TrialBalanceReport) then Application.CreateForm(TTrialBalanceReport, TrialBalanceReport);
        TrialBalanceReport.RunReport(False);

        // Build CSV File

        Assignfile(OutputFile,Filename);
        Rewrite(OutputFile);

        Accsdatamodule.TrialBalanceReportDB.open;
        Accsdatamodule.TrialBalanceReportDB.First;

        Outputline := '';

        // Header

        if rgAccountGroup.itemindex = 0 then Outputline :=  'Account,Name'
                        else Outputline :=  'Report Group,Name';

        if nominalreportform.extended.Checked = false then begin    // standard 2 Columns only

            Outputline := Outputline + ',Current Balance - Debit,Current Balance - Credit';
            ColumnCount := 2;

        end
            else begin

                  ColumnCount := 6;

                  if ShowYearMonth.checked then Outputline := Outputline + ',Opening Balance - Debit,Opening Balance - Credit,Year Movement - Debit,Year Movement - Credit,Closing Balance - Debit,Closing Balance - Credit'
                        else begin
                                    if MonthTypeSelectRG.CheckedIndex = 0 then Outputline := Outputline + ',Opening Balance - Debit,Opening Balance - Credit,Month Movement - Debit,Month Movement - Credit,Closing Balance - Debit,Closing Balance - Credit'
                                       else if MonthTypeSelectRG.CheckedIndex = 1 then Outputline := Outputline + ',Opening Balance - Debit,Opening Balance - Credit,Period Movement - Debit,Period Movement - Credit,Closing Balance - Debit,Closing Balance - Credit'
                                             else begin
                                                        Outputline := Outputline + ',Total Movement - Debit,Total Movement - Credit';
                                                        ColumnCount := 2;
                                             end
                             end;

                 end;

        WriteLn(OutputFile,OutputLine); //writeheader

        for i := 1 to Accsdatamodule.TrialBalanceReportDB.recordcount do begin

                Outputline := '';

                if ColumnCount = 2 then begin

                   if Accsdatamodule.TrialBalanceReportDB.fieldbyname('RecNo').AsString <> '' then begin

                        Outputline := Accsdatamodule.TrialBalanceReportDB.fieldbyname('RecNo').AsString;
                        Outputline := Outputline + ',' + trim(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Name').AsString);
                   end
                        else begin
                             //   if ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'totals' then outputline := ',,,';

                                if ((ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'enterprise income') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'non-enterprise income') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'enterprise expense') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'overheads') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'current assets') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'fixed assets') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'liabilities') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'bank accounts') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'private') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'control accounts')) then begin

                                                Outputline := 'Totals,' + trim(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString);
                                end;

                         end;

                         if outputline <> '' then begin

                                if Accsdatamodule.TrialBalanceReportDB.fieldbyname('Curr_db').AsString <> '-' then Outputline := Outputline + ',' + trim(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Curr_db').AsString)
                                        else Outputline := Outputline + ',';

                                if Accsdatamodule.TrialBalanceReportDB.fieldbyname('Curr_cr').AsString <> '-' then Outputline := Outputline + ',' + trim(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Curr_cr').AsString)
                                        else Outputline := Outputline + ',';

                        end;

                end;   //Columncount = 2

                if ColumnCount = 6 then begin

                   if Accsdatamodule.TrialBalanceReportDB.fieldbyname('RecNo').AsString <> '' then begin

                        Outputline := Accsdatamodule.TrialBalanceReportDB.fieldbyname('RecNo').AsString;
                        Outputline := Outputline + ',' + trim(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Name').AsString);
                   end
                        else begin
                             //   if ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'totals' then outputline := ',,,';

                                if ((ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'enterprise income') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'non-enterprise income') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'enterprise expense') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'overheads') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'current assets') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'fixed assets') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'liabilities') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'bank accounts') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'private') or
                                        (ansilowercase(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString) = 'control accounts')) then begin

                                                Outputline := 'Totals,' + trim(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Labels').AsString);
                                end;

                         end;

                         if outputline <> '' then begin

                                if Accsdatamodule.TrialBalanceReportDB.fieldbyname('Open_db').AsString <> '-' then Outputline := Outputline + ',' + trim(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Open_db').AsString)
                                        else Outputline := Outputline + ',';

                                if Accsdatamodule.TrialBalanceReportDB.fieldbyname('Open_cr').AsString <> '-' then Outputline := Outputline + ',' + trim(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Open_cr').AsString)
                                        else Outputline := Outputline + ',';

                                if Accsdatamodule.TrialBalanceReportDB.fieldbyname('Mov_db').AsString <> '-' then Outputline := Outputline + ',' + trim(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Mov_db').AsString)
                                        else Outputline := Outputline + ',';

                                if Accsdatamodule.TrialBalanceReportDB.fieldbyname('Mov_cr').AsString <> '-' then Outputline := Outputline + ',' + trim(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Mov_cr').AsString)
                                        else Outputline := Outputline + ',';

                                if Accsdatamodule.TrialBalanceReportDB.fieldbyname('Close_db').AsString <> '-' then Outputline := Outputline + ',' + trim(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Close_db').AsString)
                                        else Outputline := Outputline + ',';

                                if Accsdatamodule.TrialBalanceReportDB.fieldbyname('Close_cr').AsString <> '-' then Outputline := Outputline + ',' + trim(Accsdatamodule.TrialBalanceReportDB.fieldbyname('Close_cr').AsString)
                                        else Outputline := Outputline + ',';

                        end;

                end;   //Columncount = 6


                if outputline <> '' then WriteLn(OutputFile,OutputLine);

                Accsdatamodule.TrialBalanceReportDB.next;

        end;               // for i :=

        closefile(OutputFile);
        Showmessage('Trial Balance CSV Export Complete');


end;

procedure TNominalReportForm.BankAuditReportExport(Filename : string);
var
        OutputFile : textfile;
        i : integer;
        outputline : string;
        BankAccount,stubno : string;
        IncStubDetails : Boolean;

begin

        // Run report but don't preview

        if not bool (BankAuditTrialReport) then Application.CreateForm(TBankAuditTrialReport, BankAuditTrialReport);

        BankAuditTrialReport.RunReport(false);

        // Build CSV File

        Assignfile(OutputFile,Filename);
        Rewrite(OutputFile);

        AccsDatamodule.BankAuditTrailDB.Open;
        AccsDatamodule.BankAuditTrailDB.First;

        Outputline := '';

        if ShowStubDetails.checked then IncStubDetails := True
                else IncStubDetails := False;

        // Header

        if IncStubDetails then Outputline := 'Bank Account,Stub Number,Stub Date,TxNo,Receipt,Payment,Balance,Status,Cust/Supp,Comment/Desc,Stub Breakdown'
                else  Outputline := 'Bank Account,Stub Number,Stub Date,TxNo,Receipt,Payment,Balance,Status';

        WriteLn(OutputFile,OutputLine); //writeheader



        for i := 1 to AccsDatamodule.BankAuditTrailDB.recordcount do begin

                Outputline := '';

                if AccsDatamodule.BankAuditTrailDB.fieldbyname('LabelText').asstring <> null then begin

                    if pos('Bank Account : ',AccsDatamodule.BankAuditTrailDB['LabelText']) > 0 then begin

                        BankAccount := copy(AccsDatamodule.BankAuditTrailDB['LabelText'],15,(pos('-',AccsDatamodule.BankAuditTrailDB['LabelText'])-15));
                        Trim(BankAccount);

                    end;

                end;

                if AccsDatamodule.BankAuditTrailDB.fieldbyname('StubNumber').asstring <> null then begin

                        Outputline := BankAccount;
                        StubNo :=  AccsDatamodule.BankAuditTrailDB.fieldbyname('StubNumber').asstring;
                        Outputline := Outputline + ',' + StubNo;
                        Outputline := Outputline + ',' + AccsDatamodule.BankAuditTrailDB.fieldbyname('StubDate').asstring;
                        Outputline := Outputline + ',' + AccsDatamodule.BankAuditTrailDB.fieldbyname('TxNo').asstring;
                        if AccsDatamodule.BankAuditTrailDB.fieldbyname('MultiTx').asstring <> null then Outputline := Outputline + AccsDatamodule.BankAuditTrailDB.fieldbyname('MultiTx').asstring;           // add plus onto end of txno
                        if AccsDatamodule.BankAuditTrailDB.fieldbyname('Receipt').asstring <> null then Outputline := Outputline + ',' + AccsDatamodule.BankAuditTrailDB.fieldbyname('Receipt').asstring
                                else Outputline := Outputline + ',';
                        if AccsDatamodule.BankAuditTrailDB.fieldbyname('Payment').asstring <> null then Outputline := Outputline + ',' + AccsDatamodule.BankAuditTrailDB.fieldbyname('Payment').asstring
                                else Outputline := Outputline + ',';
                        if AccsDatamodule.BankAuditTrailDB.fieldbyname('RunStatementBal').asstring <> null then Outputline := Outputline + ',' + vartostr(round(AccsDatamodule.BankAuditTrailDB['RunStatementBal']*100)/100)
                                else Outputline := Outputline + ',';
                        Outputline := Outputline + ',' + AccsDatamodule.BankAuditTrailDB.fieldbyname('Status').asstring;

                end;


                if AccsDatamodule.BankAuditTrailDB.fieldbyname('CustSupp').asstring <> null then begin

                        Outputline := BankAccount;
                        Outputline := Outputline + ',' + StubNo;
                        Outputline := Outputline + ',' + AccsDatamodule.BankAuditTrailDB.fieldbyname('LineDate').asstring;
                        Outputline := Outputline + ',' + AccsDatamodule.BankAuditTrailDB.fieldbyname('MultiTxNo').asstring;
                        if AccsDatamodule.BankAuditTrailDB.fieldbyname('LineReceipt').asstring <> null then Outputline := Outputline + ',' + AccsDatamodule.BankAuditTrailDB.fieldbyname('LineReceipt').asstring
                                else Outputline := Outputline + ',';
                        if AccsDatamodule.BankAuditTrailDB.fieldbyname('LinePayment').asstring <> null then Outputline := Outputline + ',' + AccsDatamodule.BankAuditTrailDB.fieldbyname('LinePayment').asstring
                                else Outputline := Outputline + ',';
                        if AccsDatamodule.BankAuditTrailDB.fieldbyname('RunStatementBal').asstring <> null then Outputline := Outputline + ',' + vartostr(round(AccsDatamodule.BankAuditTrailDB['RunStatementBal']*100)/100)
                                else Outputline := Outputline + ',';
                        Outputline := Outputline + ',' + AccsDatamodule.BankAuditTrailDB.fieldbyname('Status').asstring;
                        Outputline := Outputline + ',' + RemoveCommas(AccsDatamodule.BankAuditTrailDB.fieldbyname('CustSupp').asstring);
                        if AccsDatamodule.BankAuditTrailDB.fieldbyname('CommentDesc').asstring <> null then Outputline := Outputline + ',' + RemoveCommas(AccsDatamodule.BankAuditTrailDB.fieldbyname('CommentDesc').asstring)
                                else Outputline := Outputline + ',';
                        Outputline := Outputline + ',Stub Breakdown';

                end;


                if outputline <> '' then WriteLn(OutputFile,OutputLine);

                AccsDatamodule.BankAuditTrailDB.next;

        end;               // for i :=



        closefile(OutputFile);
        Showmessage('Bank Audit Trail CSV Export Complete');


end;


procedure TNominalReportForm.FullNominalReportExport(Filename : string);
var
        OutputFile : textfile;
        i,j : integer;
        outputline : string;
        MyQuery : TQuery;
        Account : String;
        CarryOverText : String;
        TempStr : ShortString;

begin

        // Run report but don't preview

        reportdefs.NoPreview := True;
        runclick(self);
        reportdefs.NoPreview := false;

        // Build CSV File

        Assignfile(OutputFile,Filename);
        Rewrite(OutputFile);

        MyQuery := TQuery.create(self);
        Myquery.DatabaseName := accsdatamodule.AccsDataBase.databasename;
        MyQuery.SQL.clear;
        MyQuery.SQL.add ('Select * From "c:\kingsacc\report.db"');
        MyQuery.open;
        MyQuery.First;

        Outputline := '';


        // Header

        if rgAccountGroup2.ItemIndex = 0 then Outputline := 'Account,TxNo,Stub Number,Debit,Credit,Date,Ref,Balance-Debit,Balance-Credit,Quantity,Cust/Supp,Description'
                else Outputline := 'Group,TxNo,Stub Number,Debit,Credit,Date,Ref,Balance-Debit,Balance-Credit,Quantity,Cust/Supp,Description';

        WriteLn(OutputFile,OutputLine); //write header

        if rgAccountGroup2.ItemIndex = 0 then begin     // Account Report

            for i := 1 to MyQuery.recordcount do begin

                Outputline := '';
                CarryOverText := '';

                if MyQuery.fieldbyname('F13').asstring <> null then begin

                        Account := MyQuery.fieldbyname('F13').asstring;
                        Trim(Account);

                end;

                if MyQuery.fieldbyname('F2').asstring <> null then begin        //TxNo - check for valid detail line

                    if IsNumeric(MyQuery.fieldbyname('F2').asstring) then begin

                                Outputline := Account + ',' + MyQuery.fieldbyname('F2').asstring;

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F3').asstring <> null then Outputline := Outputline + MyQuery.fieldbyname('F3').asstring;            // stub

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F6').asstring <> null then Outputline := Outputline + MyQuery.fieldbyname('F6').asstring;            // debit

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F9').asstring <> null then Outputline := Outputline + MyQuery.fieldbyname('F9').asstring;            // credit

                                if MyQuery.fieldbyname('F10').asstring <> null then begin                 // date & ref

                                    Outputline := Outputline + ',' + copy(MyQuery.fieldbyname('F10').asstring,0,8);
                                    Outputline := Outputline + ',';

                                    if length(MyQuery.fieldbyname('F10').asstring) > 8 then begin
                                        TempStr  := copy(MyQuery.fieldbyname('F10').asstring,9,length(MyQuery.fieldbyname('F10').asstring));
                                        Trim (TempStr);
                                        Outputline := Outputline + TempStr;
                                    end

                                end
                                        else Outputline := Outputline + ',,.';

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F17').asstring <> null then Outputline := Outputline + MyQuery.fieldbyname('F17').asstring;           // Bal debit

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F18').asstring <> null then Outputline := Outputline + MyQuery.fieldbyname('F18').asstring;           // Bal Credit

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F20').asstring <> null then Outputline := Outputline + MyQuery.fieldbyname('F20').asstring;           // Qty

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F21').asstring <> null then begin

                                if length(MyQuery.fieldbyname('F21').asstring) <21 then Outputline := Outputline + RemoveCommas(MyQuery.fieldbyname('F21').asstring)        // Cust/Supp
                                        else begin
                                             Outputline := Outputline + RemoveCommas(copy(MyQuery.fieldbyname('F21').asstring,0,21));
                                             CarryOverText := RemoveCommas(copy(MyQuery.fieldbyname('F21').asstring,22,length(MyQuery.fieldbyname('F21').asstring)));

                                        end;
                                end;

                                Outputline := Outputline + ',';
                                if CarryOverTExt <> '' then Outputline := Outputline + CarryOverText
                                        else if MyQuery.fieldbyname('F22').asstring <> null then Outputline := Outputline + RemoveCommas(MyQuery.fieldbyname('F22').asstring);     // Desc




                    end;   // isnumeric
                end;       // F2




                if Outputline <> '' then WriteLn(OutputFile,OutputLine);

                MyQuery.next;


            end;           // for i :=
        end;               // Account


        if rgAccountGroup2.ItemIndex = 1 then begin     // Group Report

            for i := 1 to MyQuery.recordcount do begin

                Outputline := '';
                CarryOverText := '';

                if ((MyQuery.fieldbyname('F12').asstring <> null) and (MyQuery.fieldbyname('F12').asstring <> 'Ref')) then begin


                        Account := copy(MyQuery.fieldbyname('F12').asstring,0,(pos(':',MyQuery.fieldbyname('F12').asstring)-1));
                        Trim(Account);

                end;

                if MyQuery.fieldbyname('F1').asstring <> null then begin        //TxNo - check for valid detail line

                    if IsNumeric(MyQuery.fieldbyname('F1').asstring) then begin

                                Outputline := Account + ',' + MyQuery.fieldbyname('F1').asstring;

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F3').asstring <> null then Outputline := Outputline + MyQuery.fieldbyname('F3').asstring;            // stub

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F6').asstring <> null then Outputline := Outputline + MyQuery.fieldbyname('F6').asstring;            // debit

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F9').asstring <> null then Outputline := Outputline + MyQuery.fieldbyname('F9').asstring;            // credit

                                if MyQuery.fieldbyname('F10').asstring <> null then begin                 // date & ref

                                    Outputline := Outputline + ',' + copy(MyQuery.fieldbyname('F10').asstring,0,8);
                                    Outputline := Outputline + ',';

                                    if length(MyQuery.fieldbyname('F10').asstring) > 8 then begin
                                        TempStr  := copy(MyQuery.fieldbyname('F10').asstring,9,length(MyQuery.fieldbyname('F10').asstring));
                                        SlimAll(TempStr);
                                        Outputline := Outputline + TempStr;
                                    end

                                end
                                        else Outputline := Outputline + ',,.';

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F17').asstring <> null then Outputline := Outputline + MyQuery.fieldbyname('F17').asstring;           // Bal debit

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F18').asstring <> null then Outputline := Outputline + MyQuery.fieldbyname('F18').asstring;           // Bal Credit

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F20').asstring <> null then Outputline := Outputline + MyQuery.fieldbyname('F20').asstring;           // Qty

                                Outputline := Outputline + ',';
                                if MyQuery.fieldbyname('F21').asstring <> null then begin

                                if length(MyQuery.fieldbyname('F21').asstring) <21 then Outputline := Outputline + RemoveCommas(MyQuery.fieldbyname('F21').asstring)        // Cust/Supp
                                        else begin
                                             Outputline := Outputline + RemoveCommas(copy(MyQuery.fieldbyname('F21').asstring,0,21));
                                             CarryOverText := RemoveCommas(copy(MyQuery.fieldbyname('F21').asstring,22,length(MyQuery.fieldbyname('F21').asstring)));

                                        end;
                                end;

                                Outputline := Outputline + ',';
                                if CarryOverTExt <> '' then Outputline := Outputline + CarryOverText
                                        else if MyQuery.fieldbyname('F22').asstring <> null then Outputline := Outputline + RemoveCommas(MyQuery.fieldbyname('F22').asstring);     // Desc




                    end;   // isnumeric
                end;       // F2




                if Outputline <> '' then WriteLn(OutputFile,OutputLine);

                MyQuery.next;


            end;           // for i :=
        end;               // Group





        MyQuery.close;
        MyQuery.free;

        closefile(OutputFile);
        Showmessage('Full Nominal Audit Trail CSV Export Complete');


end;

// End Ch025


end.
