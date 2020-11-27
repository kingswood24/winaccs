unit uBudgetReport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uReportBaseForm, ActnList, dxBar, dxBarExtItems, cxControls, dxStatusBar,
  Db, DBTables, cxGroupBox, cxRadioGroup, cxContainer, cxEdit, QRCtrls,
  QuickRpt, ExtCtrls, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  Types, cxCheckBox;

type

  TfmBudgetReport = class(TfmReportBaseForm)
    QuickRep: TQuickRep;
    QRSubDetail1: TQRSubDetail;
    QRDBText1: TQRDBText;
    QRSubDetail2: TQRSubDetail;
    QRBand3: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel4: TQRLabel;
    qrlBudgetJanToMonthHeader: TQRLabel;
    qrlActualJanToMonthHeader: TQRLabel;
    QRBand4: TQRBand;
    GroupFooterBand1: TQRBand;
    GroupHeaderBand1: TQRBand;
    QRLabel7: TQRLabel;
    GroupHeaderBand2: TQRBand;
    QRLabel6: TQRLabel;
    GroupFooterBand2: TQRBand;
    cxGroupBox1: TcxGroupBox;
    rgReportType: TcxRadioGroup;
    QueryAccounts: TQuery;
    cmboMonths: TcxComboBox;
    lbStartMonth: TcxLabel;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    qrlIncomeTotalBudget: TQRLabel;
    qrlExpenseTotalBudget: TQRLabel;
    QRLabel8: TQRLabel;
    QRLabel9: TQRLabel;
    QRLabel10: TQRLabel;
    qrlNetTotalBudget: TQRLabel;
    QRDBText7: TQRDBText;
    QRLabel11: TQRLabel;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRSysData1: TQRSysData;
    QRDBText11: TQRDBText;
    QRLabel3: TQRLabel;
    QRLabel5: TQRLabel;
    QRDBText12: TQRDBText;
    qrlIncomeVariance: TQRLabel;
    qrlExpenseVariance: TQRLabel;
    qrlAccIncomeVariance: TQRLabel;
    qrlAccExpenseVariance: TQRLabel;
    QRShape1: TQRShape;
    qrlNetVariance: TQRLabel;
    KingsAccFooter: TQRLabel;
    cbHideInactiveNominalAccounts: TcxCheckBox;
    QRShape2: TQRShape;
    QRShape3: TQRShape;
    QRShape4: TQRShape;
    qrlBudgetIncomeMonthToEnd: TQRLabel;
    qrlActualIncomeTotalBudget: TQRLabel;
    qrlBudgetExpenseMonthToEnd: TQRLabel;
    qrlActualExpenseTotalBudget: TQRLabel;
    qrlNetTotalBudgetMonthToEnd: TQRLabel;
    qrlNetActualTotalBudget: TQRLabel;
    QRShape5: TQRShape;
    QRLabel12: TQRLabel;
    QRShape6: TQRShape;
    QRShape7: TQRShape;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    procedure QRSubDetail1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure QRSubDetail2BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure QuickRepBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure qrlIncomeTotalBudgetPrint(sender: TObject;
      var Value: String);
    procedure qrlBudgetIncomeMonthToEndPrint(sender: TObject; var Value: String);
    procedure qrlExpenseTotalBudgetPrint(sender: TObject;
      var Value: String);
    procedure qrlNetTotalBudgetPrint(sender: TObject;
      var Value: String);
    procedure qrlNetActualJanToMonthPrint(sender: TObject;
      var Value: String);
    procedure QRLabel3Print(sender: TObject; var Value: String);
    procedure QRLabel5Print(sender: TObject; var Value: String);
    procedure qrlIncomeVariancePrint(sender: TObject; var Value: String);
    procedure qrlExpenseVariancePrint(sender: TObject; var Value: String);
    procedure qrlAccIncomeVariancePrint(sender: TObject;
      var Value: String);
    procedure qrlAccExpenseVariancePrint(sender: TObject;
      var Value: String);
    procedure qrlNetVariancePrint(sender: TObject; var Value: String);
    procedure qrlBudgetExpenseMonthToEndPrint(sender: TObject;
      var Value: String);
    procedure qrlActualExpenseTotalBudgetPrint(sender: TObject;
      var Value: String);
    procedure qrlActualIncomeTotalBudgetPrint(sender: TObject;
      var Value: String);
    procedure qrlNetTotalBudgetMonthToEndPrint(sender: TObject;
      var Value: String);
    procedure qrlNetActualTotalBudgetPrint(sender: TObject;
      var Value: String);
  private
    { Private declarations }
     FIncomeTotalBudget : Double;
     FIncomeBudgetMonthToEnd : Double;
     FIncomeActualTotalBudget : Double;
     FExpenseTotalBudget : Double;
     FExpenseBudgetMonthToEnd : Double;
     FExpenseActualTotalBudget : Double;
     FFilteredEntAccounts : string;
     FStartMonth : Byte;
     function GetSelectedMonthsString : string;

     function GetTotalIncomeVariance : Double;
     function GetTotalExpenseVariance : Double;
     function GetNetTotalBudget : Double;
     function GetNetBudgetMonthToEnd : Double;
     function GetNetActualMonthToEnd : Double;
     function GetNetVariance : Double;

     function HideInactiveAccount : Boolean;
  protected
     procedure BuildReport;override;
     procedure SetupForm;override;
  public
    { Public declarations }
    class procedure ShowBudgetReport(AStartMonth : Byte; AFilteredEntAccounts : string);
  end;

var
  fmBudgetReport: TfmBudgetReport;

implementation

uses AccsData, VARS;

{$R *.DFM}

{ TfmBudgetReport }

function TfmBudgetReport.GetSelectedMonthsString: string;
var
   i : Integer;
begin
   Result := '';
   for i := 0 to cmboMonths.ItemIndex do
      begin
         Result := Result + 'SUM(tmpBudget.'+Copy(cmboMonths.Properties.Items[i],1,3)+')';
         if ( i <> cmboMonths.ItemIndex ) then
            Result := Result + ' + ';
      end;
   Result := Result + ' as JanToMonth ';
end;

procedure TfmBudgetReport.SetupForm;
var
   m : Word;
begin
  inherited;
  QuickRep.Hide;
  QueryAccounts.DatabaseName := AccsDataModule.AccsDataBase.DatabaseName;

  with cmboMonths.Properties.Items do
     try
        BeginUpdate;

        for m := cash1.xfinmonth to (cash1.xfinmonth + 11) do
           begin
              if m > 12 then
                 Add(Months[m-12])
              else if m <= 12 then
                 Add(Months[m]);
           end;

        lbStartMonth.Caption := Format('From %s to',[Months[cash1.xfinmonth]]);
     finally
        if (FStartMonth in [1..12]) then
           cmboMonths.ItemIndex := cmboMonths.Properties.Items.IndexOf(Months[FStartMonth])
        else
           cmboMonths.ItemIndex := 0;
        EndUpdate;
     end;
end;

class procedure TfmBudgetReport.ShowBudgetReport(AStartMonth : Byte; AFilteredEntAccounts : string);
begin
  with TfmBudgetReport.Create(nil) do
      try
         FStartMonth := AStartMonth;
         FFilteredEntAccounts := AFilteredEntAccounts;
         SetupForm;
         ShowModal;
      finally
         Free;
      end;
end;

procedure TfmBudgetReport.QRSubDetail1BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  inherited;
  qrlAccIncomeVariance.Caption := '';
  PrintBand := UPPERCASE(QueryAccounts.FieldByName('NomType').AsString) = 'INCOME';


  if ( PrintBand ) then
     begin
        // Only print band when there is data to be shown.
        PrintBand := not HideInactiveAccount;
     end;

{   Variance comparing year budget vs actual to date. Removed by request of Gerry Lynskey.
    Variance will now be calculated based on budget to date vs actual to date.

    if PrintBand then
     begin
        FIncomeTotalBudget := FIncomeTotalBudget + QueryAccounts.FieldByName('YearBudget').AsFloat;
        FIncomeBudgetMonthToEnd := FIncomeBudgetMonthToEnd + QueryAccounts.FieldByName('BudgetMonthToEnd').AsFloat;
        FIncomeActualMonthToEnd := FIncomeActualMonthToEnd + QueryAccounts.FieldByName('ActualMonthToEnd').AsFloat;
        qrlAccIncomeVariance.Caption := FormatFloat(',0;-,0', ( ( QueryAccounts.FieldByName('YearBudget').AsFloat - QueryAccounts.FieldByName('ActualMonthToEnd').AsFloat) * -1) );
     end;
}

    if PrintBand then
     begin
        FIncomeTotalBudget := FIncomeTotalBudget + QueryAccounts.FieldByName('YearBudget').AsFloat;
        FIncomeBudgetMonthToEnd := FIncomeBudgetMonthToEnd + QueryAccounts.FieldByName('BudgetMonthToEnd').AsFloat;
        FIncomeActualTotalBudget := FIncomeActualTotalBudget + QueryAccounts.FieldByName('ActualMonthToEnd').AsFloat;
        qrlAccIncomeVariance.Caption :=
                  FormatFloat(',0;-,0', ( ( QueryAccounts.FieldByName('BudgetMonthToEnd').AsFloat -
                                            QueryAccounts.FieldByName('ActualMonthToEnd').AsFloat ) * -1) );
     end;

end;

procedure TfmBudgetReport.QRSubDetail2BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
  inherited;
  qrlAccExpenseVariance.Caption := '';
  PrintBand := UPPERCASE(QueryAccounts.FieldByName('NomType').AsString) = 'EXPENSE';

  if ( PrintBand ) then
     begin
        // Only print band when there is data to be shown.
        PrintBand := not HideInactiveAccount;
     end;

{   Variance comparing year budget vs actual to date. Removed by request of Gerry Lynskey.
    Variance will now be calculated based on budget to date vs actual to date.

  if PrintBand then
     begin
        FExpenseTotalBudget := FExpenseTotalBudget + QueryAccounts.FieldByName('YearBudget').AsFloat;
        FExpenseBudgetMonthToEnd := FExpenseBudgetMonthToEnd + QueryAccounts.FieldByName('BudgetMonthToEnd').AsFloat;
        FExpenseActualMonthToEnd := FExpenseActualMonthToEnd + QueryAccounts.FieldByName('ActualMonthToEnd').AsFloat;
        qrlAccExpenseVariance.Caption := FormatFloat(',0;-,0', ( ( QueryAccounts.FieldByName('YearBudget').AsFloat - QueryAccounts.FieldByName('ActualMonthToEnd').AsFloat) * -1) );
     end;
}
  if PrintBand then
     begin
        FExpenseTotalBudget := FExpenseTotalBudget + QueryAccounts.FieldByName('YearBudget').AsFloat;
        FExpenseBudgetMonthToEnd := FExpenseBudgetMonthToEnd + QueryAccounts.FieldByName('BudgetMonthToEnd').AsFloat;
        FExpenseActualTotalBudget := FExpenseActualTotalBudget + QueryAccounts.FieldByName('ActualMonthToEnd').AsFloat;
        qrlAccExpenseVariance.Caption :=
                FormatFloat(',0;-,0', ( ( QueryAccounts.FieldByName('BudgetMonthToEnd').AsFloat -
                                          QueryAccounts.FieldByName('ActualMonthToEnd').AsFloat ) * -1) );
     end;
end;

procedure TfmBudgetReport.FormDestroy(Sender: TObject);
begin
  inherited;
  if QueryAccounts.Active then
     QueryAccounts.Close;
end;

procedure TfmBudgetReport.QuickRepBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
  inherited;
  FIncomeTotalBudget := 0;
  FIncomeBudgetMonthToEnd := 0;
  FIncomeActualTotalBudget := 0;

  FExpenseTotalBudget := 0;
  FExpenseBudgetMonthToEnd := 0;
  FExpenseActualTotalBudget := 0;

end;

procedure TfmBudgetReport.qrlIncomeTotalBudgetPrint(sender: TObject;
  var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0',FIncomeTotalBudget);
end;

procedure TfmBudgetReport.qrlBudgetIncomeMonthToEndPrint(sender: TObject;
  var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0',FIncomeBudgetMonthToEnd);
end;

procedure TfmBudgetReport.qrlExpenseTotalBudgetPrint(sender: TObject;
  var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0',FExpenseTotalBudget);
end;

procedure TfmBudgetReport.BuildReport;
var
   TempStr : string;
   i : Integer;
begin
   QueryAccounts.Close;
   try
      QueryAccounts.SQL.Clear;
      QueryAccounts.SQL.Add('SELECT NominalId, NomName, EnterpriseCode, YearBudget, NomType, ');

      TempStr := '';
      for i := 0 to cmboMonths.ItemIndex do
         begin
            TempStr := TempStr + 'SUM(tmpBudget."'+Copy(cmboMonths.Properties.Items[i],1,3)+'")';
            if ( i <> cmboMonths.ItemIndex ) then
               TempStr := TempStr + ' + ';
         end;
      TempStr := TempStr + ' as BudgetMonthToEnd, ';
      // add
      QueryAccounts.SQL.Add(TempStr);

      TempStr := '';
      for i := 0 to cmboMonths.ItemIndex do
         begin
            TempStr := TempStr + 'SUM(tmpBudget.Actual'+Copy(cmboMonths.Properties.Items[i],1,3)+')';
            if ( i <> cmboMonths.ItemIndex ) then
               TempStr := TempStr + ' + ';
         end;
      // add
      TempStr := TempStr + ' as ActualMonthToEnd';

      QueryAccounts.SQL.Add(TempStr);

      QueryAccounts.SQL.Add('FROM tmpBudget');

      if ( cbHideInactiveNominalAccounts.Checked ) then
         QueryAccounts.SQL.Add('WHERE (ActiveNominalRecord=True)');

      if (FFilteredEntAccounts <> '') then
        QueryAccounts.SQL.Add('AND (EnterpriseCode="'+FFilteredEntAccounts+'")');
      QueryAccounts.SQL.Add('GROUP BY NominalId, NomName, EnterpriseCode, YearBudget, NomType');
      QueryAccounts.SQL.Add('ORDER BY NominalId');
      QueryAccounts.Open;

      //qrlBudgetJanToMonthHeader.Caption := UPPERCASE(Copy(Months[cash1.xfinmonth], 1, 3));

      // Changed by SP 26/11/2012 from 'JAN - '+ UPPERCASE(Copy(cmboMonths.Text, 1, 3)); to Start Financial Month to end Month
      // qrlBudgetJanToMonthHeader.Caption := 'JAN - '+ UPPERCASE(Copy(cmboMonths.Text, 1, 3));
      // qrlActualJanToMonthHeader.Caption := 'JAN - '+ UPPERCASE(Copy(cmboMonths.Text, 1, 3));

      qrlBudgetJanToMonthHeader.Caption := ShortMonths[cash1.xfinmonth] + ' - ' + UPPERCASE(Copy(cmboMonths.Text, 1, 3));
      qrlActualJanToMonthHeader.Caption := qrlBudgetJanToMonthHeader.Caption;

      QuickRep.Preview;
   finally
      QueryAccounts.Close;
   end;
end;

procedure TfmBudgetReport.QRLabel3Print(sender: TObject;
  var Value: String);
begin
  inherited;
//
end;

procedure TfmBudgetReport.QRLabel5Print(sender: TObject;
  var Value: String);
begin
  inherited;
//
end;

procedure TfmBudgetReport.qrlIncomeVariancePrint(sender: TObject;
  var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0', GetTotalIncomeVariance);
end;

procedure TfmBudgetReport.qrlExpenseVariancePrint(sender: TObject;
  var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0', GetTotalExpenseVariance);

end;

procedure TfmBudgetReport.qrlAccIncomeVariancePrint(sender: TObject;
  var Value: String);
begin
  inherited;
//
end;

procedure TfmBudgetReport.qrlAccExpenseVariancePrint(sender: TObject;
  var Value: String);
begin
  inherited;
//
end;

function TfmBudgetReport.GetTotalIncomeVariance: Double;
begin
//   Result := ((FIncomeTotalBudget - FIncomeActualMonthToEnd) *-1);
   Result := ((FIncomeBudgetMonthToEnd - FIncomeActualTotalBudget) *-1);
end;

function TfmBudgetReport.GetTotalExpenseVariance: Double;
begin
//   Result := ((FExpenseTotalBudget - FExpenseActualMonthToEnd) *-1);
   Result := ((FExpenseBudgetMonthToEnd - FExpenseActualTotalBudget) *-1);
end;

{ NetTotalBudget }

function TfmBudgetReport.GetNetTotalBudget: Double;
begin
   Result := ((FIncomeTotalBudget - FExpenseTotalBudget));
end;

procedure TfmBudgetReport.qrlNetTotalBudgetPrint(sender: TObject;
  var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0', GetNetTotalBudget);
end;

{ End NetTotalBudget }

{ NetBudgetJanToMonth }

function TfmBudgetReport.GetNetBudgetMonthToEnd: Double;
begin
   Result := ((FIncomeBudgetMonthToEnd - FExpenseBudgetMonthToEnd));

   //Result := ((GetTotalIncomeVariance - GetTotalExpenseVariance));

end;


{ End NetBudgetJanToMonth }

{ NetActualJanToMonth }

function TfmBudgetReport.GetNetActualMonthToEnd: Double;
begin
   Result := ((FIncomeActualTotalBudget - FExpenseActualTotalBudget));
end;

procedure TfmBudgetReport.qrlNetActualJanToMonthPrint(
  sender: TObject; var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0', GetNetActualMonthToEnd);
end;

{ End NetActualJanToMonth }

{ NetVariance }

function TfmBudgetReport.GetNetVariance: Double;
begin
//   Result := ( ( GetNetTotalBudget -  GetNetActualJanToMonth ) * -1);

   Result := ( ( GetNetBudgetMonthToEnd -  GetNetActualMonthToEnd ) * -1);

end;

procedure TfmBudgetReport.qrlNetVariancePrint(sender: TObject;
  var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0', GetNetVariance);
end;

{ End NetVariance }


function TfmBudgetReport.HideInactiveAccount: Boolean;
begin
   // Only print band when there is data to be shown.
   Result := ((cbHideInactiveNominalAccounts.Checked) and
              (QueryAccounts.FieldByName('YearBudget').AsFloat <= 0) and
              (QueryAccounts.FieldByName('BudgetMonthToEnd').AsFloat <= 0) and
              (QueryAccounts.FieldByName('ActualMonthToEnd').AsFloat <= 0));
end;

procedure TfmBudgetReport.qrlBudgetExpenseMonthToEndPrint(sender: TObject;
  var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0', FExpenseBudgetMonthToEnd);
end;

procedure TfmBudgetReport.qrlActualExpenseTotalBudgetPrint(sender: TObject;
  var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0', FExpenseActualTotalBudget);
//
end;

procedure TfmBudgetReport.qrlActualIncomeTotalBudgetPrint(sender: TObject;
  var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0', FIncomeActualTotalBudget);
end;

procedure TfmBudgetReport.qrlNetTotalBudgetMonthToEndPrint(sender: TObject;
  var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0', GetNetBudgetMonthToEnd);
end;

procedure TfmBudgetReport.qrlNetActualTotalBudgetPrint(sender: TObject;
  var Value: String);
begin
  inherited;
  Value := FormatFloat(',0;-,0', GetNetActualMonthToEnd);
end;

end.
