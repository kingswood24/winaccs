unit Entreps;
{
Form to Run Reports Enterprise Cost per Unit
}             
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, NewClass, ComCtrls, Mask,
  Grids, QRExportHelper, uAccounts;
type TEnterpriseType = (ETDairy,ETUnknown);

type
  TEntCostPerUnit = class(TKingForm)
    CustSuppPanel: TPanel;
    ReportDate: TLabel;
    EntCodeLabel: TLabel;
    Panel1: TPanel;
    Help: TBitBtn;
    Run: TBitBtn;
    Exit: TBitBtn;
    EntCode: TEdit;
    EntCostingPanel: TPanel;
    IncludePerQtyBreakDown_: TCheckBox;
    DateFromLabel: TLabel;
    DateToLabel: TLabel;
    NoEntUnits: TEdit;
    EntCostThisPanel: TPanel;
    CalMonth: TEdit;
    ShowAnnual: TCheckBox;
    CalMonthLabel: TLabel;
    UseTx: TCheckBox;
    PrevDir1: TEdit;
    PrevDir2: TEdit;
    AnalysisFrom: TEdit;
    AnalysisTo: TEdit;
    AnalysisFromLabel: TLabel;
    AnalysisToLabel: TLabel;
    DateTo: TMaskEdit;
    DateSearchFrom: TDateTimePicker;
    DateSearchTo: TDateTimePicker;
    DateFrom: TMaskEdit;
    CustAccounts: TSpeedButton;
    AnalysisFromButton: TSpeedButton;
    AnalysisToButton: TSpeedButton;
    RepDate: TMaskEdit;
    RepSearch: TDateTimePicker;
    TotUnitLabel: TLabel;
    EntUnitName: TEdit;
    EntUnitNameLabel: TLabel;
    IncludeLastYear: TCheckBox;
    ThisYearPanel: TPanel;
    ThisYearRG: TRadioGroup;
    ExportBtn: TBitBtn;
    PencePerUnit: TCheckBox;
    PenceLbl: TLabel;
    AccGrid: TStringGrid;
    CostUnitRepOutputRG: TRadioGroup;
    ReportType: TRadioGroup;
    NewCostCB: TCheckBox;
    SetupBtn: TBitBtn;
    procedure RunClick(Sender: TObject);
    procedure EntCode1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ExitClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EntCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EntCodeExit(Sender: TObject);
    procedure CalMonthExit(Sender: TObject);
    procedure UseTxExit(Sender: TObject);
    procedure ShowAnnualExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure VReportsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AnalysisFromKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AnalysisFromExit(Sender: TObject);
    procedure AnalysisToExit(Sender: TObject);
    procedure AnalysisToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DateFromExit(Sender: TObject);
    procedure DateToExit(Sender: TObject);
    procedure DateSearchFromCloseUp(Sender: TObject);
    procedure DateSearchToCloseUp(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CustAccountsClick(Sender: TObject);
    procedure AnalysisFromButtonClick(Sender: TObject);
    procedure AnalysisToButtonClick(Sender: TObject);
    procedure RepDateExit(Sender: TObject);
    procedure RepSearchCloseUp(Sender: TObject);
    procedure IncludePerQtyBreakDown_Click(Sender: TObject);
    procedure AccGridDblClick(Sender: TObject);
    procedure NoEntUnitsExit(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure ThisYearByGroup;
    procedure ThisYearRGClick(Sender: TObject);
    procedure ExportBtnClick(Sender: TObject);
    procedure ReportTypeClick(Sender: TObject);
    procedure SetupBtnClick(Sender: TObject);
  private
    { Private declarations }
    function GetTotalUnits ( TestNomSt : ShortString ) : double;
    procedure CalcTotalNoUnits;
    procedure CheckForDates(Sender: TObject);
    procedure CheckAnalysis;
    procedure UpdateReportTable(InvertVariance : boolean; IncludeTotal : boolean);
    procedure SetDefaultUnitFromNominalAccount(const AAcountName : string);
    procedure SetDefaultUnitFromEnterpriseAccount(const AEnterpriseCode : string);
    function CountOfSelectedNominals : Integer;
    function SelectedNominal : string;
  public
    { Public declarations }
    TotalUnits            : Double;
    EntAnlFrom,
    EntAnlTo              : Integer;

    iAccFrom,
    iAccTo     : Integer;
    PRLIST     : PACKED ARRAY[1..9999] OF INTEGER;
    TOTLIST    : Integer;
    UseAnalysis,
    EntUsePreviousYear : Boolean;
    EnterpriseType : TEnterpriseType;
//    function GetTotalUnits ( TestNomSt : ShortString ) : double;   // TGM AB 18/10/13
    procedure CheckForEnterpriseQtyFields(EnterpriseCode : String);



  end;

var
  EntCostPerUnit: TEntCostPerUnit;
  Gridpos,
  GridCol,
  GridRow : Integer;
  Qty2Active, Qty3Active : Boolean;


implementation
Uses
    dbgen,
    DBCore,
    newlisting,
    clears,
    vars,
    types,
    Calcs,
    NewRepUnit,
    NomReps,
    NsRep11,
    NomRpt,
    UTIL,
    abortprg,
    Params,
    uEnterpriseAnalysisThisYearVsLast,
    ReportDefs, Dataexport,AccsData, ThisYearReport, CostPerUnit, UEnterpriseSetup;

    procedure FillGrid ( EnterpriseAccRange : TAccRange ); Forward;

{$R *.DFM}

Procedure FillGrid ( EnterpriseAccRange : TAccRange );
Var
   RecCount : Integer;
Begin
     SetDb(NlFile);
     GridRow := 1;
     For RecCount := EnterpriseAccRange[1] to EnterpriseAccRange[2] do
         Begin
              ReadRec ( NlFile, RecCount );
              DbErr;
              If RecActive ( NlFile ) Then
                 Begin
                    EntCostPerUnit.AccGrid.Cells[0,GridRow] := IntToStr ( RecCount );
                    GetItem ( NlFile, 1 );
                    EntCostPerUnit.AccGrid.Cells[1,GridRow] := CurrStr;
                    EntCostPerUnit.AccGrid.Cells[2,GridRow] := 'No';
                    Inc ( GridRow );
                 End;
         End;
     GridPos := GridRow;
     EntCostPerUnit.AccGrid.RowCount := GridRow
End;

procedure TEntCostPerUnit.RunClick(Sender: TObject);
Var
   NoDays,
   FinDateFrom,
   FinDateTo   : Integer;
   StrDays     : ShortString;
   Date1,
   Date2       : ShortString;
   OkToProceed : boolean;
   counter,
   TempInt : Integer;
   TempStr : ShortString;
begin
     // Set the Global Report Date
     REPXDATE := RepDate.Text;
     TempInt := 1;

     If (( Prog = EntRep ) AND ( Act = 6 )) Then      // Act = 6 = the enterprise cost per unit report
//     If EntReportForm.EntPerUnitRadio.Checked Then
        Begin

             if NewCostCB.checked then begin
                   if not bool (CostPerUnitReport) then Application.CreateForm(TCostPerUnitReport, CostPerUnitReport);
                   if EntCode.Text <> '' then CostPerUnitReport.RunReport
                     else showmessage('Please choose an Enterprise Code');
             end
                 else begin

                        SetDb ( EntFile );
                        GetFinDateRange ( FinDateFrom, FinDateTo );
                        KDateToStr ( TxDateFrom, Date1 );
                        KDateToStr ( TxDateTo, Date2 );
                        OkToProceed := True;

                        DATEDIFF (DATE1,DATE2, NoDays, StrDays );
                        If ( NoDays > 730 ) Then
                                OkToProceed := False;

                        If OkToProceed Then
                                NomReports ( 6, NewRepForm.DataBase )
                        Else
                                Begin
                                        CloseAll ( MaxDatabases );
                                        If NOT OpenAll Then
                                           AbortProgram ( 'Error Opening Databases - Contact Kingswood');
                                        MessageDlg('Date Range is Over 2 Years',mtInformation, [mbOk], 0);
                                End;

                end; // If NewCostCB
        End

     Else If (( Prog = EntRep ) AND ( Act = 1 )) Then //EntReportForm.EntCostThisYearRadio.Checked
          NomReports ( 1, NewRepForm.DataBase )

     Else If (( Prog = EntRep ) AND ( Act = 3 )) Then    //EntReportForm.EntThisYearVBudAndLastYearRadio.Checked
          begin
          if ThisYearRG.itemindex = 0 then NomReports ( 3, NewRepForm.DataBase )
             else ThisYearByGroup;
          end
     Else If (( Prog = EntRep ) AND ( Act = 4 )) Then//EntReportForm.ThisYearMonthlyRadio.Checked
          NomReports ( 4, NewRepForm.DataBase )

     Else If (( Prog = EntRep ) AND ( Act = 5 )) Then//EntReportForm.LastYearMonthlyRadio.Checked
          NomReports ( 5, NewRepForm.DataBase )

     Else If (( Prog = EntRep ) AND ( Act = 2 )) Then//EntReportForm.EntCostThisYearVLastRadio.Checked
          NomReports ( 2, NewRepForm.DataBase )
     Else If (( Prog = EntRep ) AND ( Act = 2000 )) Then
          EnterpriseAnalysisThisYearVsLast.RunReport;
end;

procedure TEntCostPerUnit.EntCode1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       Begin
          If (( Prog = EntRep ) AND ( Act = 6 )) Then
//          If EntReportForm.EntPerUnitRadio.Checked Then
             NewListBox.ListIt ( Sender, Enterprise, 'E' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
             EntCode.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TEntCostPerUnit.ExitClick(Sender: TObject);
begin
     Close;
end;

procedure TEntCostPerUnit.FormActivate(Sender: TObject);
var
   AYear, AMonth, ADay: Word;
begin


  //   Panel1.Width := 261;
  //   Self.Width := 478;    //450
     ExportBtn.Enabled := False;
     ExportBtn.visible := false;
     SetupBtn.Enabled := False;        // TGM AB 27/06/14
     SetupBtn.visible := false;        // TGM AB 27/06/14
     RepDate.SetFocus;
     NewRepform.Database := EntFile;
     caption := 'Enterprise Cost Per Unit';{ + ' - ' + st;}
  (*   If Device = 'P' Then
        PReports.Checked := True
     Else
         VReports.Checked := True; *)
 // TGM AB

     NomRpt.NominalReportForm.FullNominalPanel.Enabled := False;
     NomRpt.NominalReportForm.VATPanel.Enabled := False;

     NomRpt.NominalReportForm.CashBookListingPanel.Enabled := False;
     NomRpt.NominalReportForm.BalanceSheetPanel.Enabled := False;
     NomRpt.NominalReportForm.TransListingPanel.Enabled := False;
     NomRpt.NominalReportForm.BankAuditPanel.Enabled := False;
     NomRpt.NominalReportForm.TrialBalancePanel.Enabled := False;
     NomRpt.NominalReportForm.FullNominalPanel.Hide;
     NomRpt.NominalReportForm.CashBookListingPanel.Hide;
     NomRpt.NominalReportForm.BalanceSheetPanel.Hide;
     NomRpt.NominalReportForm.TransListingPanel.Hide;
     NomRpt.NominalReportForm.BankAuditPanel.Hide;
     NomRpt.NominalReportForm.TrialBalancePanel.Hide;
     NomRpt.NominalReportForm.VATPanel.Hide;

     // End TGM AB these lines as they disable all the nominal panels - need to be re-enalbed for other reports to work!
     // cannot be removed as this leads to an exception error when runnig a 'This Year Monthly' report.

     PrevDir1.Hide;
     PrevDir2.Hide;

     DateFrom.Text := '  /  /  ';
     DateTo.Text := '  /  /  ';
     EntCode.Text := '';
     IncludePerQtyBreakDown_.checked := False;

     Qty2Active := False;
     Qty3Active := False;

     // Analysis Codes
     AnalysisFromLabel.Visible := False;
     AnalysisFrom.Visible := False;
     AnalysisToLabel.Visible := False;
     AnalysisTo.Visible := False;
     AnalysisFromButton.Hide;
     AnalysisToButton.Hide;

     TotalUnits := 0;
     TxDateFrom := CdateFrom;
     TxDateTo   := Cdateto;
     EntAnlFrom := 0;
     EntAnlTo   := 9999;
     UseAnalysis := False;
     AnalysisFrom.Text := IntToStr ( EntAnlFrom );
     AnalysisTo.Text := IntToStr ( EntAnlTo );

     EntUsePreviousYear := False;

     RepDate.Text := Cash1.xDate;

     AccGrid.Hide;
     EntUnitName.Hide;
     NoEntUnits.Hide;
     PencePerUnit.hide;
//     PencePerUnit.Checked := true;          Removed check by default
     Pencelbl.hide;
     UseTx.Hide;
     EntUnitNameLabel.Hide;
     TotUnitLabel.Hide;
     Showannual.visible := true;


     ThisYearPanel.visible := False;
     CalMonthLabel.visible := True;
     CalMonth.visible := True;
     EntCode.visible := True;
     CustAccounts.visible := True;
     EntCodeLabel.visible := True;
     ThisYearRG.itemindex := 0;
     IncludeLastYear.visible := false;

     ShowAnnual.Show;
     If ( Act = 6 ) Then
//     If EntReportForm.EntPerUnitRadio.Checked Then
        Begin
             CheckForDates ( Sender );
             EntCostingPanel.Visible := True;
             EntCostThisPanel.Hide;
             EntCostPerUnit.Caption := 'Cost Per Unit Report';

             SetupBtn.Enabled := True;        // TGM AB 27/06/14
             SetupBtn.visible := True;        // TGM AB 27/06/14

             // TGM AB - look for D or DA enterprise code and default to it
                 if Accsdatamodule.EntsFileDB.Locate('EntCode','Da',[]) then begin
                     EntCode.Text := 'Da';
                     EntCodeExit(self);
                 end;
                 if Accsdatamodule.EntsFileDB.Locate('EntCode','DA',[]) then begin
                     EntCode.Text := 'DA';
                     EntCodeExit(self);
                 end;
                 if Accsdatamodule.EntsFileDB.Locate('EntCode','da',[]) then begin
                     EntCode.Text := 'da';
                     EntCodeExit(self);
                 end;
                 if Accsdatamodule.EntsFileDB.Locate('EntCode','D',[]) then begin
                     EntCode.Text := 'D';
                     EntCodeExit(self);
                 end;
                 if Accsdatamodule.EntsFileDB.Locate('EntCode','d',[]) then begin
                     EntCode.Text := 'd';
                     EntCodeExit(self);
                 end;
             // end

        End
     Else If (( Act = 2 ) OR ( Act = 5 ) or ( Act = 2000)) Then
//     Else If EntReportForm.EntCostThisYearVLAStRadio.Checked Or
//             EntReportForm.LastYearMonthlyRadio.Checked Then
        Begin
             EntCostingPanel.Hide;
             EntCostThisPanel.Hide;
             If ( Act = 2 ) Then
//             If EntReportForm.EntCostThisYearVLAStRadio.Checked Then
                 EntCostPerUnit.Caption := 'This Year Vs Previous Years'
             Else  if ( Act = 5 ) Then begin
                 EntCostPerUnit.Caption := 'Last Year Monthly';
                 Panel1.Width := 344;
                 ExportBtn.visible := True;
                 ExportBtn.Enabled := True;
             end
             Else If ( Act = 2000 ) Then begin
                 EntCostPerUnit.Caption := 'This Year Vs Last Year';
                 EntCostThisPanel.visible := true;
                 Showannual.Visible := false;
             end;
        End
     Else If ( Act = 3 ) Then
//     Else If EntReportForm.EntThisYearVBudAndLastYearRadio.Checked Then
         Begin
              EntCostingPanel.Hide;
              EntCostThisPanel.Visible := True;
              ShowAnnual.Hide;
              if Reportdefs.ReportType = rpThisMonthVsBudgetAndLastYear then EntCostPerUnit.Caption := 'This Month Vs Budget And Last Year'
                  else begin
                       ThisYearPanel.visible := True;
                       EntCostPerUnit.Caption := 'This Year Vs Budget And Last Year';
                       IncludeLastYear.visible := True;
                       end;
         End
     Else If ( Act = 1 ) Then
//     Else If EntReportForm.EntCostThisYearRadio.Checked Then
         Begin
              EntCostingPanel.Visible := False;
              EntCostThisPanel.Visible := True;
              EntCostPerUnit.Caption := 'Costing Report (This Year)';
         End
     Else If ( Act = 4 ) Then
//     Else If EntReportForm.ThisYearMonthlyRadio.Checked Then
         Begin
              EntCostingPanel.Hide;
              ShowAnnual.Hide;
              UseTx.Show;
              EntCostThisPanel.Show;
              EntCostPerUnit.Caption := 'This Year Monthly';
              Panel1.Width := 344;
              ExportBtn.visible := True;
              ExportBtn.Enabled := True;
         End;


     //CalMonth.Text := IntToStr ( Cash1.xMonthNo );

     // TGM AB filling default month into calander month box!
     DecodeDate(strtodate(Cash1.xDate), AYear, AMonth, ADay);
     Calmonth.text := Vartostr(AMonth);


     SetDb ( NewRepForm.DataBase );

     if (AccsDataModule.IsEnterpriseInUse(cDairyEnterpriseName)) then
      begin
         EntCode.Text := AccsDataModule.GetEnterpriseCodeByName(cDairyEnterpriseName);
         //SetDefaultUnitFromNominalAccount('MILK SALES');
         SetDefaultUnitFromEnterpriseAccount(EntCode.Text);
      end;
end;

function TEntCostPerUnit.GetTotalUnits ( TestNomSt : ShortString ) : double;
Var
   UnitName : ShortString;
   TestTots,
   SumUnits : Double;
   TestNom  : Integer;
begin
     ReSult := 0;
     SlimAll ( TestNomSt );
     If Numeric ( TestNomSt ) Then
        begin
           TestNom := StrToInt ( TestNomSt );
           If EntCostPerUnit.EntUsePreviousYear Then
              If Calc_qty ( False, TestNom, TxDateFrom, TxDateTo,
                      UnitName, SumUnits, TestTots, LastNlFile, LastTxFile,
                      EntAnlfrom, EntAnlTo ) Then
                 ReSult := SumUnits;
           If Calc_qty ( False, TestNom, TxDateFrom, TxDateTo,
                   UnitName, SumUnits, TestTots, NlFile, TxFile,
                   EntAnlfrom, EntAnlTo ) Then
              ReSult := ReSult + SumUnits;
        end;
end;

procedure TEntCostPerUnit.CalcTotalNoUnits;
Var
   x : Integer;
begin
     TotalUnits := 0;
     For x := 1 To AccGrid.RowCount-1 Do
         begin
              // If use i.e. Yes recalculate the No of Units
              If AccGrid.Cells[2,x] = 'Yes' Then
                 TotalUnits := TotalUnits + GetTotalUnits ( AccGrid.Cells[0,x] );
         end;
     // Display the No of Enterprise Units
     NoEntUnits.Text := Format ( '%f', [TotalUnits] );
end;

Procedure CheckDataForYear ( PassedDate, FromOrTo : Integer );
Var
   DataDir1,
   DataDir2,
   TempStr : ShortString;
   FinDateFrom,
   FinDateTo,
   TempMonth,
   TempInt : Integer;
   OkToProceed,
   FirstPrev : Boolean;
{-->>   SecondPrev : Boolean;}
Begin
     // Check if Date range is within this year if not
     // attempt to locate the Sub Dir containing this archived data
     // if this fails inform user that data for that year doesn't exist
     OkToProceed := True;
     FirstPrev   := False;
{-->>     SecondPrev  := False;}

     KDateToStr ( PassedDate, TempStr );
     SlimAll ( TempStr );
     // Only check if theres a valid date entered
     if Length ( TempStr ) > 0 then
        begin
           TempMonth := StrToInt ( Copy ( TempStr, 4, 2 ));
           TempInt := StrToInt ( Copy ( TempStr, 7, 2 ));

           if ( TempInt > 80 ) then
              TempInt := TempInt + 1900
           else
              TempInt := TempInt + 2000;

           if ( TempMonth < Cash1.xFinMonth ) then
              Dec ( TempInt, ((1+Cash1.xFinYear)-TempInt) );

           GetFinDateRange ( FinDateFrom, FinDateTo );

           Case FromOrTo Of
              1 : If PassedDate < FinDateFrom Then
                    { Not the current year get the year }
                    Begin
                      DataDir1 := Copy ( RFarmGate.pLocation[2],1,3) + IntToStr ( TempInt );
                      EntCostPerUnit.EntUsePreviousYear := True;
                      FirstPrev := True;
                    End;
              2 : If PassedDate < FinDateFrom Then
                   { Not the current year get the year }
                   Begin
                      DataDir2 := Copy ( RFarmGate.pLocation[2],1,3) + IntToStr ( TempInt );
                      EntCostPerUnit.EntUsePreviousYear := True;
{-->>                      SecondPrev := True;}
                   End;
           End;

           If FirstPrev Then
             Begin
               (*
               SaveDB ( EntFile );
               *)
        //       OpenDb ( LastTxFile, '\kingsacc\' + datadir1 + '\trans.fdb', True );
        //       If Errorno = 0 Then
        //         OpenDb ( LastNlFile, '\kingsacc\' + datadir1 + '\nlaccs.fdb', True )
        //       Else
        //         OkToProceed := False;


               Accsdatamodule.GatherPreviousYears;
               OkToProceed := false;
               if fileexists('C:\kingsacc\' + RFarmGate.pLocation[2] + '\NLFile-1.db') then OkToProceed := true;
               if fileexists('C:\kingsacc\' + RFarmGate.pLocation[2] + '\Year-1.db') then OkToProceed := true;
               If OkToProceed Then
                 Begin
                     EntCostPerUnit.PrevDir1.Text := datadir1;
                     EntCostPerUnit.PrevDir1.Show;
                 End
               Else
                 MessageDlg('No Data for the YEAR entered',mtInformation, [mbOk], 0);
             End;

           If NOT OkToProceed Then
              EntCostPerUnit.DateFrom.SetFocus
           Else
             If EntCostPerUnit.AccGrid.Visible Then
               // ReCalculate the total Units for the Enterprise
               EntcostPerUnit.CalcTotalNoUnits;
        end
     Else
         EntCostPerUnit.EntUsePreviousYear := False;

End;

procedure TEntCostPerUnit.EntCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Key = VK_F2 Then    { F2 Pressed }
       Begin
            NewListBox.ListIt ( Sender, Enterprise, 'E' );
            If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
               EntCode.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TEntCostPerUnit.EntCodeExit(Sender: TObject);
Var
   TempStr : ShortString;
   RecNo, i   : Integer;
   AccRange     : TAccRange;
begin
     TempStr := EntCode.Text;
     SlimAll ( TempStr );
     If Length ( TempStr ) > 0 Then
        Begin
             TotUnitLabel.Show;
             EntUnitName.Show;
             NoEntUnits.Show;
             If NOT CheckEnt ( EntCode.Text, RecNo ) Then
                EntCode.SetFocus
             Else
                 // If its a valid Enterprise Show get the name and no of units
                 // Show the Income Grid, filling it with the associated Income
                 // Accounts. Call Check Dates to show the Dates
                 begin
                    TotalUnits := 0;
                    NewListBox.ListInfo.Ent := EntCode.Text;
                    AccRange := NewListBox.SetRanges ( Sender, EntRange );
                    NoEntUnits.Text := GetAccountName ( EntFile, RecNo, 3 );
                    EntUnitName.Text := GetAccountName ( EntFile, RecNo, 4 );
                    EntUnitNameLabel.Show;
                    PencePerUnit.show;
                    Pencelbl.show;
                    If cash2.XCOUNTRY = 2 then Pencelbl.Caption := 'Show totals' + #10#13 + 'as cents' + #10#13 + 'per unit'
                       else Pencelbl.caption := 'Show totals' +  #10#13 +'as pence' + #10#13 + 'per unit';
                    TotUnitLabel.Show;
                    EntUnitName.Show;
                    AccGrid.Hide;
                    FillGrid ( AccRange );
                    // TGM AB

                    if ((ansilowercase(EntCode.Text) = 'd') or (ansilowercase(EntCode.Text) = 'da')) then EnterpriseType := ETDairy
                       else EnterpriseType := ETUnknown;



                    //TGM AB 21/02/14


                    if EnterpriseType = ETDairy then begin
                        TRadioButton(ReportType.Controls[2]).caption := 'Cost/Litre && Cost/Kgs Milk Solid';
                        TRadioButton(ReportType.Controls[2]).visible := true;
                        TRadioButton(ReportType.Controls[3]).visible := false;
                        ReportType.ItemIndex := 2;
                        ReportTypeClick(Sender);
                    end
                        else begin
                             CheckForEnterpriseQtyFields(ansilowercase(EntCode.Text));
                             if Qty2Active then begin
                                     TRadioButton(ReportType.Controls[2]).caption := 'Include Cost/Qty2 Column';
                                     TRadioButton(ReportType.Controls[2]).visible := true;
                             end else TRadioButton(ReportType.Controls[2]).visible := false;
                             if Qty3Active then begin
                                     TRadioButton(ReportType.Controls[3]).caption := 'Include Cost/Qty3 Column';
                                     TRadioButton(ReportType.Controls[3]).visible := true;
                             end else TRadioButton(ReportType.Controls[3]).visible := false;
                             ReportType.ItemIndex := 0;

                        end;

                 end;


                 
        End
     Else
         Begin
              AccGrid.hide;
              EntUnitNameLabel.Hide;
              TotUnitLabel.Hide;
              EntUnitName.Hide;
              NoEntUnits.Hide;
              PencePerUnit.hide;
              Pencelbl.hide;
              TxDateFrom := CDateFrom;
              TxDateTo := CDateTo;
         End;
    CheckForDates(Sender);



end;

procedure TEntCostPerUnit.CheckForDates(Sender: TObject);
Begin
     // Hide Dates if not using Quantity breakdown and No Enterprise has been selected
  //   If ( NOT IncludePerQtyBreakDown.Checked ) And (Length( EntCode.Text) = 0 ) Then
     If (Length( EntCode.Text) = 0 ) Then
        Begin
             EntUsePreviousYear := False;
             DateTo.Enabled := False;
             DateFrom.Enabled := False;
             DateSearchFrom.Enabled := False;
             DateSearchTo.Enabled := False;
             DateFromLabel.Enabled := False;
             DateToLabel.Enabled := False;
             DateTo.Hide;
             DateFrom.Hide;
             DateSearchFrom.Hide;
             DateSearchTo.Hide;
             DateFromLabel.Hide;
             DateToLabel.Hide;
        End
     Else
       // If the User has entered an Enterprise Show the Dates
       If (Length ( EntCode.Text ) > 0 ) Then
        Begin
             DateTo.Enabled := True;
             DateFrom.Enabled := True;
             DateSearchFrom.Enabled := True;
             DateSearchTo.Enabled := True;
             DateFromLabel.Enabled := True;
             DateToLabel.Enabled := True;
             DateTo.Show;
             DateFrom.Show;
             DateSearchFrom.Show;
             DateSearchTo.Show;
             DateFromLabel.Show;
             DateToLabel.Show;
        End;
     // Check to see if the Analysis Codes need to be shown
     CheckAnalysis;
End;

procedure TEntCostPerUnit.CheckAnalysis;
begin
   // Analysis Codes can be used only when a Date Range has been selected
   If ( TxDateFrom <> CDateFrom ) Or ( TxDateTo <> CDateTo ) Then
      begin
             AnalysisFromLabel.Visible := True;
             AnalysisFrom.Visible := True;
             AnalysisToLabel.Visible := True;
             AnalysisTo.Visible := True;
             AnalysisFromButton.Visible := True;
             AnalysisToButton.Visible := True;
             UseAnalysis := True;
      end
   Else
       Begin
          UseAnalysis := False;
          AnalysisFromLabel.Visible := False;
          AnalysisFrom.Visible := False;
          AnalysisToLabel.Visible := False;
          AnalysisFromButton.Visible := False;
          AnalysisToButton.Visible := False;
          AnalysisTo.Visible := false;
       End;
end;

procedure TEntCostPerUnit.CalMonthExit(Sender: TObject);
begin
     If NOT Numeric ( CalMonth.Text ) Then
        CalMonth.SetFocus
     Else
         If NOT ( StrToInt ( CalMonth.Text ) In [1..12] ) Then
            CalMonth.SetFocus;
end;

procedure TEntCostPerUnit.UseTxExit(Sender: TObject);
begin
     If UseTx.Checked Then
        CalMonth.Enabled := False
     Else
         CalMonth.Enabled := True;
end;

procedure TEntCostPerUnit.ShowAnnualExit(Sender: TObject);
begin
     If ShowAnnual.Checked Then
        CalMonth.Enabled := False
     Else
         CalMonth.Enabled := True;
end;

procedure TEntCostPerUnit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     DateFrom.Text := '  /  /  ';
     DateTO.Text := '  /  /  ';
     EntUnitName.Text := '';
     NoEntUnits.Text := '';
     CalMonth.Text := '12';
     CloseAll ( MaxDatabases );
     If NOT OpenAll Then
        AbortProgram ( 'Error Opening Databases - Contact Kingswood');
end;

procedure TEntCostPerUnit.VReportsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     KPrinterOrScreen ( Sender, Button, Shift, x, y );
end;

procedure TEntCostPerUnit.AnalysisFromKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  If Key = VK_F2 Then    { F2 Pressed }
       Begin
            NewListBox.ListIt ( Sender, Analysis, 'A' );
            If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
               AnalysisFrom.Text := NewListBox.ListInfo.ReturnValue;
       End;

end;

procedure TEntCostPerUnit.AnalysisFromExit(Sender: TObject);
Var
   TempStr : ShortString;
   RecNo   : Integer;
begin
     TempStr := AnalysisFrom.Text;
     SlimAll ( TempStr );
     If ( Length ( TempStr ) > 0 ) And Numeric ( TempStr ) Then
        begin
           EntAnlFrom := StrToInt ( TempStr );
           EntcostPerUnit.CalcTotalNoUnits;
        end
     Else
        AnalysisFrom.Setfocus;
end;

procedure TEntCostPerUnit.AnalysisToExit(Sender: TObject);
begin
     TempStr := Analysisto.Text;
     SlimAll ( TempStr );
     If ( Length ( TempStr ) > 0 ) And Numeric ( TempStr ) Then
        begin
           EntAnlTo := StrToInt ( TempStr );
           EntcostPerUnit.CalcTotalNoUnits;
        end
     Else
        AnalysisTo.Setfocus;
end;

procedure TEntCostPerUnit.AnalysisToKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_F2 Then    { F2 Pressed }
       Begin
            NewListBox.ListIt ( Sender, Analysis, 'A' );
            If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
               AnalysisTo.Text := NewListBox.ListInfo.ReturnValue;
       End;
end;

procedure TEntCostPerUnit.DateFromExit(Sender: TObject);
begin
     KDateFromExit ( Sender, Report );
     CheckAnalysis;
     If ( TxDateTo < TxDateFrom ) Then
        DateFrom.SetFocus
     Else
         CheckDataForYear ( TxDateFrom, 1 );
end;

procedure TEntCostPerUnit.DateToExit(Sender: TObject);
Var
   TempStr : String;
begin
    KDateToExit ( Sender, Report );
    CheckAnalysis;
    If ( TxDateTo < TxDateFrom ) Then
       DateFrom.SetFocus
    Else
        CheckDataForYear ( TxDateTo, 2 );
end;

procedure TEntCostPerUnit.DateSearchFromCloseUp(Sender: TObject);
begin
     DateFrom.Text:= DateToStr(DateSearchFrom.Date);
     DateFrom.SetFocus;
end;

procedure TEntCostPerUnit.DateSearchToCloseUp(Sender: TObject);
begin
     DateTo.Text:= DateToStr(DateSearchTo.Date);
     DateTo.SetFocus;
end;

procedure TEntCostPerUnit.FormShow(Sender: TObject);
begin
     RepSearch.Date := KStrToDate ( Cash11.Default_Date );
     DateSearchFrom.Date := KStrToDate (Cash11.Default_Date);
     DateSearchTo.Date := KStrToDate (Cash11.Default_Date);
     AccGrid.Cells[0,0] := 'Code';
     AccGrid.Cells[1,0] := 'Name';
     AccGrid.Cells[2,0] := 'Report ?';
end;

procedure TEntCostPerUnit.CustAccountsClick(Sender: TObject);
begin
      NewListBox.ListIt ( Sender, Enterprise, 'E' );
      If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
         begin
            EntCode.Text := NewListBox.ListInfo.ReturnValue;
            SetDefaultUnitFromEnterpriseAccount(EntCode.Text);
         end;

      EntCode.SetFocus;
end;

procedure TEntCostPerUnit.AnalysisFromButtonClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Analysis, 'A' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        AnalysisFrom.Text := NewListBox.ListInfo.ReturnValue;
     AnalysisFrom.SetFocus;
end;

procedure TEntCostPerUnit.AnalysisToButtonClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Analysis, 'A' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        AnalysisTo.Text := NewListBox.ListInfo.ReturnValue;
     AnalysisTo.SetFocus;
end;

procedure TEntCostPerUnit.RepDateExit(Sender: TObject);
begin
     KDateValid ( Sender );
end;

procedure TEntCostPerUnit.RepSearchCloseUp(Sender: TObject);
var
   AYear, AMonth, ADay: Word;
begin
     RepDate.Text:= DateToStr(RepSearch.Date);

     // TGM AB filling default month into calander month box!
     DecodeDate(RepSearch.Date, AYear, AMonth, ADay);
     Calmonth.text := Vartostr(AMonth);
     RepDate.SetFocus;
end;

procedure TEntCostPerUnit.IncludePerQtyBreakDown_Click(Sender: TObject);
begin
    CheckForDates ( Sender );
end;

procedure TEntCostPerUnit.AccGridDblClick(Sender: TObject);
Var
   TempStr  : ShortString;
   TestNom  : SmallInt;
   UnitName : ShortString;
   SumUnits,
   TestTots : Double;
begin
     If AccGrid.Cells[2,AccGrid.Row] = 'Yes' Then
        begin
           // Subtract the Total Qty for this Account from Total
           AccGrid.Cells[2,AccGrid.Row] := 'No';
           TotalUnits := TotalUnits - GetTotalUnits ( AccGrid.Cells[0,AccGrid.Row] );
           // Display the No of Enterprise Units
           NoEntUnits.Text := Format ( '%f', [TotalUnits] );
        end
     Else
        Begin
           // Add the Total Qty for this Account to Total
           AccGrid.Cells[2,AccGrid.Row] := 'Yes';
           TotalUnits := GetTotalUnits ( AccGrid.Cells[0,AccGrid.Row] ) + TotalUnits;
           // Display the No of Enterprise Units
           NoEntUnits.Text := Format ( '%f', [TotalUnits] );
        End;
   if (CountOfSelectedNominals() = 0) then
      SetDefaultUnitFromEnterpriseAccount(EntCode.Text)
   else if (CountOfSelectedNominals() = 1) then
      begin
         if (SelectedNominal = 'MILK SALES') then
            EntUnitName.Text := 'LITRES';
      end
   else
      begin
         // Multiple Noms selected, must remove the default unit name
         EntUnitName.Text := '';
      end;
end;

procedure TEntCostPerUnit.NoEntUnitsExit(Sender: TObject);
var
   TempStr  : ShortString;
begin
   TempStr := NoEntUnits.Text;
   SlimAll ( TempStr );
   If ChangeToLong ( TempStr ) Then
      NoEntUnits.Text := TempStr;
end;

procedure TEntCostPerUnit.HelpClick(Sender: TObject);
begin
     If (( Prog = EntRep ) AND ( Act = 1 )) Then
//     If EntReportForm.EntCostThisYearRadio.Checked Then
        //Application.HelpContext(154)
        AccsDataModule.HTMLHelp('costingReport.htm')

     Else If (( Prog = EntRep ) AND ( Act = 2 )) Then
//     Else If EntReportForm.EntCostThisYearVLastRadio.Checked Then
             //Application.HelpContext(155)
             AccsDataModule.HTMLHelp('thisYearVsPreviousYears.htm')

     Else If (( Prog = EntRep ) AND ( Act = 3 )) Then
//     Else If EntReportForm.EntThisYearVBudAndLastYearRadio.Checked Then
             //Application.HelpContext(156)
             AccsDataModule.HTMLHelp('thisYearVsPreviousYears.htm')

     Else If (( Prog = EntRep ) AND ( Act = 5 )) Then
//     Else If EntReportForm.LastYearMonthlyRadio.Checked Then
             //Application.HelpContext(157)
             AccsDataModule.HTMLHelp('lastYearMonthly.htm')

     Else If (( Prog = EntRep ) AND ( Act = 4 )) Then
//     Else If EntReportForm.ThisYearMonthlyRadio.Checked Then
             //Application.HelpContext(158)
             AccsDataModule.HTMLHelp('thisYearMonthlyReport.htm')

     Else If (( Prog = EntRep ) AND ( Act = 6 )) Then
//     Else If EntReportForm.EntPerUnitRadio.Checked Then
             //Application.HelpContext(159)
             AccsDataModule.HTMLHelp('costPerUnitReport.htm');
end;

procedure TEntCostPerUnit.FormDeactivate(Sender: TObject);
begin
     // TGM AB 12/06/02 - Direct opposite of the lines in form activate - to re-enable components of the nomnial
     // report form, as previously the forms all still remained disabled and you could not change any options when
     // trying to print a nominal report

     NomRpt.NominalReportForm.FullNominalPanel.Enabled := true;
     NomRpt.NominalReportForm.VATPanel.Enabled := true;
     NomRpt.NominalReportForm.CashBookListingPanel.Enabled := true;
     NomRpt.NominalReportForm.BalanceSheetPanel.Enabled := true;
     NomRpt.NominalReportForm.TransListingPanel.Enabled := true;
     NomRpt.NominalReportForm.BankAuditPanel.Enabled := true;
     NomRpt.NominalReportForm.TrialBalancePanel.Enabled := true;
     NomRpt.NominalReportForm.FullNominalPanel.show;
     NomRpt.NominalReportForm.CashBookListingPanel.show;
     NomRpt.NominalReportForm.BalanceSheetPanel.show;
     NomRpt.NominalReportForm.TransListingPanel.show;
     NomRpt.NominalReportForm.BankAuditPanel.show;
     NomRpt.NominalReportForm.TrialBalancePanel.show;
     NomRpt.NominalReportForm.VATPanel.show;


end;

procedure TEntCostPerUnit.ThisYearByGroup;
//   RepGroup, i  : Integer;
begin
     Dataexport.ProcessNLFile(self);
     Dataexport.ProcessGroups;

     AccsDataModule.ThisYearTempTableSQL.SQL.clear;
     AccsDataModule.ThisYearTempTableSQL.SQL.add('select repgroup, Max(GroupDesc) as GroupDesc, Sum(Balance) as Balance, Sum(BudgYear) as BudgYear, Sum(YearTot1) as YearTot1, Max(Enterprise) as Enterprise from nlaccs N');
     AccsDataModule.ThisYearTempTableSQL.SQL.add('join groups g on N.RepGroup = G.GroupNo');
//     if Entcode.text <> '' then begin
//        AccsDataModule.ThisYearTempTableSQL.SQL.add('where Enterprise = ''' + EntCode.text + '''');
//     end;
     AccsDataModule.ThisYearTempTableSQL.SQL.add('group by repgroup');
     AccsDatamodule.ThisYearTempTableSQL.open; //ExecSQL;
     AccsDatamodule.ThisYearTempTableSQL.Active := True;

     Try AccsDataModule.ThisYearTempTableDB.close;
     except
     end;
     AccsDataModule.ThisYearTempTableDB.EmptyTable;
     AccsDataModule.ThisYearTempTableDB.Open;

     AccsDataModule.ThisYearTempTableDB.append;
     AccsDatamodule.ThisYearTempTableDB['Comment'] := 'Income';
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableDB.append;
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableSQL.Filter := 'repgroup >= ' + vartostr(Cash1.xNomIncFrom) + ' and repgroup <= ' + vartostr(Cash1.xNomIncTo) + 'or repgroup >= ' + vartostr(Cash1.xNomNonFrom) + ' and repgroup <= ' + vartostr(Cash1.xNomNonTo);;
     AccsDataModule.ThisYearTempTableSQL.filtered := True;
     If AccsDataModule.ThisYearTempTableSQL.RecordCount > 0 then UpdateReportTable(false,true);

     AccsDataModule.ThisYearTempTableDB.append;
     AccsDatamodule.ThisYearTempTableDB['Comment'] := 'Expenditure';
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableDB.append;
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableSQL.Filter := 'repgroup >= ' + vartostr(Cash1.xNomExpFrom) + ' and repgroup <= ' + vartostr(Cash1.xNomExpTo);
     AccsDataModule.ThisYearTempTableSQL.filtered := True;
     If AccsDataModule.ThisYearTempTableSQL.RecordCount > 0 then UpdateReportTable(false,true);

     AccsDataModule.ThisYearTempTableDB.append;
     AccsDatamodule.ThisYearTempTableDB['Comment'] := 'Change In Overheads';
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableDB.append;
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableSQL.Filter := 'repgroup >= ' + vartostr(Cash1.xNomOhFrom) + ' and repgroup <= ' + vartostr(Cash1.xNomOhTo);
     AccsDataModule.ThisYearTempTableSQL.filtered := True;
     If AccsDataModule.ThisYearTempTableSQL.RecordCount > 0 then UpdateReportTable(false,true);

     AccsDataModule.ThisYearTempTableDB.append;
     AccsDatamodule.ThisYearTempTableDB['Comment'] := 'Change In Current Assets';
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableDB.append;
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableSQL.Filter := 'repgroup >= ' + vartostr(Cash1.xNomCaFrom) + ' and repgroup <= ' + vartostr(Cash1.xNomCaTo);
     AccsDataModule.ThisYearTempTableSQL.filtered := True;
     If AccsDataModule.ThisYearTempTableSQL.RecordCount > 0 then UpdateReportTable(false,true);

     AccsDataModule.ThisYearTempTableDB.append;
     AccsDatamodule.ThisYearTempTableDB['Comment'] := 'Change In Fixed Assets';
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableDB.append;
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableSQL.Filter := 'repgroup >= ' + vartostr(Cash1.xNomFaFrom) + ' and repgroup <= ' + vartostr(Cash1.xNomFaTo);
     AccsDataModule.ThisYearTempTableSQL.filtered := True;
     If AccsDataModule.ThisYearTempTableSQL.RecordCount > 0 then UpdateReportTable(false,true);

     AccsDataModule.ThisYearTempTableDB.append;
     AccsDatamodule.ThisYearTempTableDB['Comment'] := 'Change In Liabilities';
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableDB.append;
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableSQL.Filter := 'repgroup >= ' + vartostr(Cash1.xNomLiFrom) + ' and repgroup <= ' + vartostr(Cash1.xNomLiTo);
     AccsDataModule.ThisYearTempTableSQL.filtered := True;
     If AccsDataModule.ThisYearTempTableSQL.RecordCount > 0 then UpdateReportTable(false,true);

     AccsDataModule.ThisYearTempTableDB.append;
     AccsDatamodule.ThisYearTempTableDB['Comment'] := 'Change In Banks';
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableDB.append;
     AccsDataModule.ThisYearTempTableDB.post;
     AccsDataModule.ThisYearTempTableSQL.Filter := 'repgroup >= ' + vartostr(Cash1.xBankMin) + ' and repgroup <= ' + vartostr(Cash1.xBankMax);
     AccsDataModule.ThisYearTempTableSQL.filtered := True;
     If AccsDataModule.ThisYearTempTableSQL.RecordCount > 0 then UpdateReportTable(false,true);


     AccsDataModule.ThisYearTempTableSQL.Filter := 'repgroup >= ' + vartostr(Cash1.xNomPrvInc) + ' and repgroup <= ' + vartostr(cash1.xNomPrvInc + cash11.xno_of_partners);
     AccsDataModule.ThisYearTempTableSQL.filtered := True;
     If AccsDataModule.ThisYearTempTableSQL.RecordCount > 0 then UpdateReportTable(false,false);

     AccsDataModule.ThisYearTempTableSQL.Filter := 'repgroup >= ' + vartostr(Cash1.xNomPrvExp) + ' and repgroup <= ' + vartostr(cash1.xNomPrvExp + cash11.xno_of_partners);
     AccsDataModule.ThisYearTempTableSQL.filtered := True;
     If AccsDataModule.ThisYearTempTableSQL.RecordCount > 0 then UpdateReportTable(false,false);

     AccsDataModule.ThisYearTempTableSQL.Filter := 'repgroup = ' + vartostr(Cash1.xnomdebtor);
     AccsDataModule.ThisYearTempTableSQL.filtered := True;
     If AccsDataModule.ThisYearTempTableSQL.RecordCount > 0 then UpdateReportTable(false,false);

     AccsDataModule.ThisYearTempTableSQL.Filter := 'repgroup = ' + vartostr(Cash1.xnomcredit);
     AccsDataModule.ThisYearTempTableSQL.filtered := True;
     If AccsDataModule.ThisYearTempTableSQL.RecordCount > 0 then UpdateReportTable(false,false);

     AccsDataModule.ThisYearTempTableSQL.Filter := 'repgroup = ' + vartostr(Cash1.xnomtax);
     AccsDataModule.ThisYearTempTableSQL.filtered := True;
     If AccsDataModule.ThisYearTempTableSQL.RecordCount > 0 then UpdateReportTable(false,false);


     if not Bool(ThisYearReport.ThisYearReportForm) then Application.CreateForm(TThisYearReportForm, ThisYearReportForm);

     ThisYearReportForm.KingswoodLbl.caption:= 'Kingswood Accounts ' +  VerNo;
     ThisYearReportForm.DateLabel.caption := RepDate.text;
     ThisYearReportform.Preview;
     SaveAsPdf( ThisYearReportform, 'C:\Kingsacc\CostPerUnit.pdf' );

     AccsDataModule.ThisYearTempTableDB.close;
     AccsDatamodule.ThisYearTempTableSQL.Active := false;
end;

procedure TEntCostPerUnit.UpdateReportTable(InvertVariance : boolean; IncludeTotal :Boolean);
var
   i, Repgroup : integer;
   ThisYearTotal,BudgetTotal,LastYearTotal,BudgetVarTotal,LastYearVar : real;
begin

     ThisYearTotal := 0;
     BudgetTotal := 0;
     LastYearTotal := 0;
     BudgetVarTotal := 0;
     LastYearVar := 0;

     For i:=1 to AccsDataModule.ThisYearTempTableSQL.RecordCount do begin
         AccsDataModule.ThisYearTempTableDB.append;
         AccsDatamodule.ThisYearTempTableDB['RepGroup'] := AccsDataModule.ThisYearTempTableSQL['repgroup'];
         RepGroup := AccsDataModule.ThisYearTempTableSQL['repgroup'];
         AccsDatamodule.ThisYearTempTableDB['GroupName'] := AccsDataModule.ThisYearTempTableSQL['GroupDesc'];
         if ((RepGroup >=Cash1.xNomIncFrom) and (RepGroup <=Cash1.xNomIncTo)) or
            ((RepGroup >=Cash1.xNomNonFrom) and (RepGroup  <=Cash1.xNomNonTo)) then begin
              if AccsDataModule.ThisYearTempTableSQL['Balance'] <> 0 then AccsDatamodule.ThisYearTempTableDB['ThisYear'] := (AccsDataModule.ThisYearTempTableSQL['Balance'] * -1);
              if AccsDataModule.ThisYearTempTableSQL['BudgYear'] <> 0 then AccsDatamodule.ThisYearTempTableDB['Budget'] := (AccsDataModule.ThisYearTempTableSQL['BudgYear'] * -1);
              if AccsDataModule.ThisYearTempTableSQL['YearTot1'] <> 0 then AccsDatamodule.ThisYearTempTableDB['LastYear'] := (AccsDataModule.ThisYearTempTableSQL['YearTot1'] * -1);

              AccsDatamodule.ThisYearTempTableDB['BudgetVar'] := ((-1*AccsDatamodule.ThisYearTempTableSQL['Balance']) - (-1*AccsDatamodule.ThisYearTempTableSQL['BudgYear']));
              AccsDatamodule.ThisYearTempTableDB['LastYearVar'] := ((-1*AccsDatamodule.ThisYearTempTableSQL['Balance']) - (-1*AccsDatamodule.ThisYearTempTableSQL['YearTot1']));

              ThisYearTotal := ThisYearTotal + (-1*AccsDatamodule.ThisYearTempTableSQL['Balance']);
              BudgetTotal := BudgetTotal + (-1*AccsDatamodule.ThisYearTempTableSQL['BudgYear']);
              LastYearTotal := LastYearTotal + (-1*AccsDatamodule.ThisYearTempTableSQL['YearTot1']);
              BudgetVarTotal := BudgetVarTotal +  ((-1*AccsDatamodule.ThisYearTempTableSQL['Balance'])- (-1*AccsDatamodule.ThisYearTempTableSQL['BudgYear']));
              LastYearVar := LastYearVar + ((-1*AccsDatamodule.ThisYearTempTableSQL['Balance']) - (-1*AccsDatamodule.ThisYearTempTableSQL['YearTot1']));

              if invertvariance then begin
                  BudgetVarTotal := BudgetVarTotal + -1*((-1*AccsDatamodule.ThisYearTempTableSQL['Balance']) - (-1*AccsDatamodule.ThisYearTempTableSQL['BudgYear']));
                  LastYearVar := LastYearVar +  -1*((-1*AccsDatamodule.ThisYearTempTableSQL['Balance']) - (-1*AccsDatamodule.ThisYearTempTableSQL['YearTot1']));
              end;
         end
            else begin
                 if AccsDataModule.ThisYearTempTableSQL['Balance'] <> 0 then AccsDatamodule.ThisYearTempTableDB['ThisYear'] := (AccsDataModule.ThisYearTempTableSQL['Balance']);
                 if AccsDataModule.ThisYearTempTableSQL['BudgYear'] <> 0 then AccsDatamodule.ThisYearTempTableDB['Budget'] := (AccsDataModule.ThisYearTempTableSQL['BudgYear']);
                 if AccsDataModule.ThisYearTempTableSQL['YearTot1'] <> 0 then AccsDatamodule.ThisYearTempTableDB['LastYear'] := (AccsDataModule.ThisYearTempTableSQL['YearTot1']);

                 AccsDatamodule.ThisYearTempTableDB['BudgetVar'] := (AccsDatamodule.ThisYearTempTableSQL['Balance'] - AccsDatamodule.ThisYearTempTableSQL['BudgYear']);
                 AccsDatamodule.ThisYearTempTableDB['LastYearVar'] := (AccsDatamodule.ThisYearTempTableSQL['Balance'] - AccsDatamodule.ThisYearTempTableSQL['YearTot1']);

                 ThisYearTotal := ThisYearTotal + AccsDatamodule.ThisYearTempTableSQL['Balance'];
                 BudgetTotal := BudgetTotal + AccsDatamodule.ThisYearTempTableSQL['BudgYear'];
                 LastYearTotal := LastYearTotal + AccsDatamodule.ThisYearTempTableSQL['YearTot1'];
                 BudgetVarTotal := BudgetVarTotal +  (AccsDatamodule.ThisYearTempTableSQL['Balance'] - AccsDatamodule.ThisYearTempTableSQL['BudgYear']);
                 LastYearVar := LastYearVar + (AccsDatamodule.ThisYearTempTableSQL['Balance'] - AccsDatamodule.ThisYearTempTableSQL['YearTot1']);

                 if invertvariance then begin
                    BudgetVarTotal := BudgetVarTotal + -1*(AccsDatamodule.ThisYearTempTableSQL['Balance'] - AccsDatamodule.ThisYearTempTableSQL['BudgYear']);
                    LastYearVar := LastYearVar +  -1*(AccsDatamodule.ThisYearTempTableSQL['Balance'] - AccsDatamodule.ThisYearTempTableSQL['YearTot1']);
                 end;
            end;



         AccsDataModule.ThisYearTempTableDB.post;

         AccsDataModule.ThisYearTempTableSQL.Next;

     end;

     // Write results line
     AccsDataModule.ThisYearTempTableDB.append;
     AccsDataModule.ThisYearTempTableDB.post;

     if includetotal then begin
        AccsDataModule.ThisYearTempTableDB.append;
        AccsDatamodule.ThisYearTempTableDB['Comment'] := 'Total';
        if ThisYearTotal <> 0 then AccsDatamodule.ThisYearTempTableDB['ThisYear'] := ThisYearTotal;
        if BudgetTotal <> 0 then AccsDatamodule.ThisYearTempTableDB['Budget'] := BudgetTotal ;
        if LastYearTotal <>0 then AccsDatamodule.ThisYearTempTableDB['LastYear'] := LastYearTotal;
        if BudgetVarTotal <> 0 then AccsDatamodule.ThisYearTempTableDB['BudgetVar'] := BudgetVarTotal;
        if LastYearVar <> 0 then AccsDatamodule.ThisYearTempTableDB['LastYearVar'] := LastYearVar;
        AccsDataModule.ThisYearTempTableDB.post;
        AccsDataModule.ThisYearTempTableDB.append;
        AccsDataModule.ThisYearTempTableDB.post;
     end;


end;

procedure TEntCostPerUnit.ThisYearRGClick(Sender: TObject);
begin
     if ThisYearRG.itemindex = 0 then begin
                             CalMonthLabel.visible := True;
                             CalMonth.visible := True;
                             EntCode.visible := True;
                             CustAccounts.visible := True;
                             EntCodeLabel.visible := True;
                             IncludeLastYear.visible := True;
     end
        else begin
             CalMonthLabel.visible := False;
             CalMonth.visible := False;
             EntCode.visible := False;
             CustAccounts.visible := False;
             EntCodeLabel.visible := False;
             IncludeLastYear.visible := false;
        end;
end;

procedure TEntCostPerUnit.ExportBtnClick(Sender: TObject);
begin
        reportdefs.ExportToCSV := true;
        runclick(self);
end;

procedure TEntCostPerUnit.ReportTypeClick(Sender: TObject);
begin
      if EnterpriseType = ETDairy then begin
        if ReportType.ItemIndex = 2 then AccGrid.Show
           else AccGrid.hide;
      end else begin
               if ReportType.ItemIndex = 0 then AccGrid.hide
                  else AccGrid.show;
               end;
end;

{
procedure TEntCostPerUnit.Button1Click(Sender: TObject);
begin
    EnterpriseAnalysisThisYearVsLast.RunReport;
end;
}

procedure TEntCostPerUnit.SetDefaultUnitFromNominalAccount(
  const AAcountName: string);
Var
   TempStr  : ShortString;
   TestNom  : SmallInt;
   UnitName : ShortString;
   TestTots : Double;
   i : Integer;
begin
   for i := 0 to AccGrid.RowCount-1 do
      begin
         if (UPPERCASE(AccGrid.Cells[1,i]) = UPPERCASE(AAcountName)) then
            begin
               // Add the Total Qty for this Account to Total
               AccGrid.Cells[2,i] := 'Yes';
               TotalUnits := GetTotalUnits ( AccGrid.Cells[0,i] );
               // Display the No of Enterprise Units
               NoEntUnits.Text := Format ( '%f', [TotalUnits] );
               AccGrid.Row := i;
               Break;
            end;
      end;
end;

procedure TEntCostPerUnit.SetDefaultUnitFromEnterpriseAccount(
  const AEnterpriseCode: string);
var
   Enterprise : TEnterpriseAccount;
begin
   Enterprise := AccsDataModule.GetEnterpriseByCode(AEnterpriseCode);
   if (Enterprise = nil) then System.Exit;

   try
      NoEntUnits.Text := FloatToStr(Enterprise.DefaultUnitTotal);
      EntUnitName.Text := Enterprise.DefaultUnitDescription;
      NoEntUnitsExit(EntUnitName);

   finally
      FreeAndNil(Enterprise);
   end;
end;

function TEntCostPerUnit.CountOfSelectedNominals : Integer;
var
   i : Integer;
begin
   Result := 0;
   for i := 1 to AccGrid.RowCount-1 do
      begin
         if AccGrid.Cells[2,i] = 'Yes' then
            Inc(Result);
      end;
end;

function TEntCostPerUnit.SelectedNominal: string;
var
   i : Integer;
begin
   Result := '';
   if (CountOfSelectedNominals <> 1) then System.Exit;

   for i := 0 to AccGrid.RowCount-1 do
      begin
         if (AccGrid.Cells[2,i] = 'Yes') then
            begin
               Result := UPPERCASE(AccGrid.Cells[1,i]);
               Break;
            end;
      end;
end;

procedure TEntCostPerUnit.SetupBtnClick(Sender: TObject);
begin
        if not bool (EnterpriseSetup) then Application.CreateForm(TEnterpriseSetup, EnterpriseSetup);   // TGM AB 27/06/14
        EnterpriseSetup.ShowModal;             // TGM AB 27/06/14
end;


Procedure TEntCostPerUnit.CheckForEnterpriseQtyFields(EnterpriseCode : String);
begin

        Qty2Active := False;
        Qty3Active := False;

        Accsdatamodule.EntsFileDB.Locate('EntCode',EnterpriseCode,[]);

        if not varisnull(Accsdatamodule.EntsFileDB['Quantity2Name']) then begin
                Qty2Active := True;
        end;

        if not varisnull(Accsdatamodule.EntsFileDB['Quantity3Name']) then begin
                Qty3Active := True;
        end;

end;

end.



