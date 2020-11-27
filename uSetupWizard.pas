unit uSetupWizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxSpinEdit, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxContainer,
  cxEdit, cxGroupBox, StdCtrls, cxButtons, cxPC, cxControls, DateUtil, db,
  dbtables;

type
  TfmSetupWizard = class(TForm)
    pcSetupWizard: TcxPageControl;
    tsGettingStarted: TcxTabSheet;
    btnClose: TcxButton;
    btnUpdate: TcxButton;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cmboFinancialYears: TcxComboBox;
    cmboFinancialMonth: TcxComboBox;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    seCurrentBalance: TcxSpinEdit;
    lbInfo: TcxLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure seCurrentBalancePropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FFinancialYear,
    FFinancialMonth : Integer;
    class function IsRequired : Boolean;
    procedure SetupForm;
    procedure UpdateDB;
    function IsValid : Boolean;
  public
    { Public declarations }
    class procedure ShowIfRequired();
  end;

var
  fmSetupWizard: TfmSetupWizard;

implementation
uses
   Types, AccsData, Vars, DefSecFl;

{$R *.DFM}

procedure TfmSetupWizard.FormCreate(Sender: TObject);
begin
   SetupForm;
end;

class function TfmSetupWizard.IsRequired: Boolean;
var
   Balance, STPeriod, STYear, BalanceST : Double;
   TransactionCount : Integer;
   NLQuery : TQuery;
begin

   if cash1.Xcashbook = false then Exit;

   NLQuery := AccsDataModule.GetNominalRecord(cControlAccNo);


   if ( NLQuery = nil ) then Exit;
   try

      NLQuery.Active := True;

      if ( NLQuery.RecordCount <> 1) then Exit;

      Balance := 0;
      STPeriod := 0;
      STYear := 0;
      BalanceST := 0;

      if NLQuery.FindField('Balance') <> nil then
         Balance := NLQuery.FieldByName('Balance').AsFloat;

      if NLQuery.FindField('STPeriod') <> nil then
         STPeriod := NLQuery.FieldByName('STPeriod').AsFloat;

      if NLQuery.FindField('STYear') <> nil then
         STYear := NLQuery.FieldByName('STYear').AsFloat;

      if NLQuery.FindField('BalanceST') <> nil then
         BalanceST := NLQuery.FieldByName('BalanceST').AsFloat;

      TransactionCount := AccsDataModule.GetTransactionCount;

      Result := ((Balance = 0) and (STPeriod = 0) and (STYear = 0) and (BalanceST = 0) and (TransactionCount = 0));

   finally
      if NLQuery.Active then
         NLQuery.Active := False;
   end;
end;

procedure TfmSetupWizard.UpdateDB;
var
   Balance : Double;
   FinancialYear, FinancialMonth : Integer;
   pt : Tpoint;
begin

   pt.x := 0;
   pt.y := btnUpdate.height;

   pt := btnUpdate.ClientToScreen(pt);
   if not IsValid() then
      begin
         MessageDlg('Unable to update, please check Financial Year/Month are selected.',mtError,[mbOK],0);
         Exit;
      end;

   if MessageDlgPos('Are you sure these settings are correct?',mtConfirmation,[mbYes,mbNo],0, pt.x, pt.y) = idYes then
      begin
         try
            FFinancialYear := StrToInt(cmboFinancialYears.Text);
            FFinancialMonth := StrToInt(cmboFinancialMonth.Text);


            Cash1.XFinYear := FFinancialYear;
            Cash1.Xmonthno := FFinancialMonth;
            Defwrite(0);
            Balance := seCurrentBalance.Value;

            AccsDataModule.UpdateNominalRecord(cCurrentBankAccNo, Balance, Balance, Balance, Balance);
            AccsDataModule.UpdateNominalRecord(cControlAccNo, -Balance, -Balance, -Balance, -Balance);

            lbInfo.Visible := True;
            MessageDlg('Update successfully completed.',mtInformation,[mbOk],0);
            //Close;
            btnClose.SetFocus;
         except
            on e : Exception do
               begin
                  raise Exception.Create(E.Message);
               end;
         end;
      end;
end;

procedure TfmSetupWizard.SetupForm;
var
   i : Integer;
   nValue : Word;
   y, m, d : Word;
begin
   DecodeDate(Date, y, m, d);
   lbInfo.Visible := False;

   nValue := y;
   with cmboFinancialYears do
      try
         Properties.Items.BeginUpdate;
         for i := nValue downto ( nValue - 10) do
            cmboFinancialYears.Properties.Items.Add( IntToStr( i ));
      finally
         Properties.Items.EndUpdate;
      end;

   nValue := m;
   with cmboFinancialMonth do
      try
         Properties.Items.BeginUpdate;
         for i := 1 to 12 do
            cmboFinancialMonth.Properties.Items.Add( IntToStr( i ));
      finally
         cmboFinancialMonth.ItemIndex := cmboFinancialMonth.Properties.Items.IndexOf(IntToStr(nValue));
         Properties.Items.EndUpdate;
      end;

   FFinancialYear := Cash1.XFinYear;
   FFinancialMonth := Cash1.Xmonthno;

   cmboFinancialYears.ItemIndex := cmboFinancialYears.Properties.Items.IndexOf(IntToStr(FFinancialYear));
   cmboFinancialMonth.ItemIndex := cmboFinancialMonth.Properties.Items.IndexOf(IntToStr(FFinancialMonth));

   btnUpdate.Enabled := False;

   seCurrentBalance.Properties.Buttons[0].Visible := false;
   seCurrentBalance.Properties.Buttons[1].Visible := false;
end;

class procedure TfmSetupWizard.ShowIfRequired;
var
   ShowSetupWizard : Boolean;
begin
   ShowSetupWizard := IsRequired;
   if not ShowSetupWizard then
      Exit;
      
   with TfmSetupWizard.Create(nil) do
      try
         ShowModal;
      finally
         Free;
      end;
end;

function TfmSetupWizard.IsValid: Boolean;
begin
   Result := (cmboFinancialYears.ItemIndex > -1 ) and (cmboFinancialMonth.ItemIndex > -1 ) and ( not VarIsNull(seCurrentBalance.Value));
end;

procedure TfmSetupWizard.btnUpdateClick(Sender: TObject);
begin
   UpdateDB;
end;

procedure TfmSetupWizard.seCurrentBalancePropertiesChange(Sender: TObject);
begin
   if not btnUpdate.Enabled then
      btnUpdate.Enabled := True;

   lbInfo.Visible := False;
end;

end.
