{
   11/12/18 [V4.3 R3.0] /MK Change - Created Global class procedure that allows that allows the invoicer module to be switched on outside of this unit.
}

unit SystemDefinition;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TSystemDefinitionForm = class(TForm)
    Panel3: TPanel;
    Exitbtn: TBitBtn;
    SaveBtn: TBitBtn;
    PageControl1: TPageControl;
    General: TTabSheet;
    NominalAccounts: TTabSheet;
    Label58: TLabel;
    gbControlAccounts: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    OpeningNetWroth: TLabel;
    Label31: TLabel;
    VATControl: TEdit;
    DebtorsControl: TEdit;
    CreditorsControl: TEdit;
    PLBroughtForward: TEdit;
    PrivateIncome: TEdit;
    PrivateExpenditure: TEdit;
    OpeningNetWorth: TEdit;
    gbBanks: TGroupBox;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    BankMin: TEdit;
    BankMax: TEdit;
    gbEntIncome: TGroupBox;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    NomIncFrom: TEdit;
    NomIncTo: TEdit;
    gbEntExpense: TGroupBox;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    NomExpFrom: TEdit;
    NomExpTo: TEdit;
    gbNoneEntIcome: TGroupBox;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    NonEntIncFrom: TEdit;
    NonEntIncTo: TEdit;
    PurchaseDiscounts: TEdit;
    gbOverheads: TGroupBox;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    OverheadsFrom: TEdit;
    OverheadsTo: TEdit;
    SalesDiscounts: TEdit;
    Depreciation: TEdit;
    gbCurrentAssets: TGroupBox;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    CAFrom: TEdit;
    CATo: TEdit;
    gbFixedAssets: TGroupBox;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    FAFrom: TEdit;
    FATo: TEdit;
    gbLiabilities: TGroupBox;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    LiFrom: TEdit;
    LiTo: TEdit;
    RebuildDataBtn: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    CompanyName: TLabel;
    Label4: TLabel;
    Path: TLabel;
    ChangeDataPath: TButton;
    SystemType: TRadioGroup;
    VATGroup: TRadioGroup;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    NoPartners: TEdit;
    SerialPanel: TGroupBox;
    Label1: TLabel;
    DefSerialNo: TLabel;
    Label2: TLabel;
    CashSerialNo: TLabel;
    Label5: TLabel;
    TokenSerialNo: TLabel;
    ChangeSerial: TButton;
    GroupBox1: TGroupBox;
    Use_Enterprise: TCheckBox;
    Use_Vat: TCheckBox;
    Use_billing: TCheckBox;
    Invoicer: TCheckBox;
    InvoiceAllocCB: TCheckBox;
    GroupBox4: TGroupBox;
    ArchiveCB: TCheckBox;
    gbCashbookLastTx: TGroupBox;
    eCashBookLastTx: TEdit;
    gbNomProdRelationship: TGroupBox;
    Label7: TLabel;
    rgNomProdRelationship: TRadioGroup;
    cbPaymentBasedVat: TCheckBox;
    SimpleVATCheckbox: TCheckBox;
    procedure SaveBtnClick(Sender: TObject);
    procedure ReadDefs;
    function SaveDefs:boolean;
    procedure ExitbtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Use_VatClick(Sender: TObject);
    procedure ChangeSerialClick(Sender: TObject);
    procedure ChangeDataPathClick(Sender: TObject);
    procedure eCashBookLastTxKeyPress(Sender: TObject; var Key: Char);
    procedure ChangeCompanyNameClick(Sender: TObject);
    procedure PrivateIncomeChange(Sender: TObject);
    procedure NonEntIncToExit(Sender: TObject);
    procedure OverheadsFromExit(Sender: TObject);
    procedure OverheadsToExit(Sender: TObject);
    procedure RebuildDataBtnClick(Sender: TObject);
  private
    procedure SetNomProdRelationship(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    class procedure SaveInvoicerModule ( ASerialNo : Integer; const AHasInvoicer : Boolean = False );
  end;

var
  SystemDefinitionForm: TSystemDefinitionForm;

  function GetNomProdRelationship(ADatabasePath : string) : string;

implementation

{$R *.DFM}

uses
   vars, types, Defsecfl, mainunit, DBCore, params, chkcomp, db, dbtables, AccsData;

procedure TSystemDefinitionForm.ReadDefs;
var
   DefSerial , CashSerial : longint;
   NomProdRelationShip : string;
begin
   TokenSerialNo.Caption := vartostr(Chkcomp.FCheckName.tokenserialnumber);
   DefSerial  := PSysLongToDelphi ( RFarmGate.PSerial );
   DefSerialNo.Caption := vartostr(DefSerial);
   CashSerial := PSysLongToDelphi ( Cash11.serial_no );
   CashSerialNo.caption := vartostr(CashSerial);
   CompanyName.caption := cash1.XCOMPANY;
   Path.Caption := Cash2.XDIRECTORY;

   if ( not(cash11.XUse_Vat) ) then
      begin
         Use_vat.checked := True;
         VATGroup.Visible := true;
         if cash2.xcountry = 2 then VATGroup.ItemIndex := 0;
         if cash2.xcountry = 1 then VATGroup.ItemIndex := 1;
      end
    else
      begin
         Use_vat.checked := false;
         VATGroup.Visible := false;
      end;

    Use_enterprise.checked := ( not(cash11.Xuse_enterprise) );

    use_billing.checked := ( not(cash11.xbilling) );

    Invoicer.Checked := cash2.XWININV;

    ArchiveCB.checked := cash1.XYearEND;

    InvoiceAllocCB.checked := cash2.XAllocation;

    cbPaymentBasedVat.checked := cash2.XPaymentVAT;       //     TGM AB 09/03/18  - Payment VAT Report

    if ( (cash1.Xcashbook ) and (not(Cash11.xuse_inc_exp)) ) then
       Systemtype.itemindex := 0;
    if ( (not(cash1.Xcashbook)) and (Cash11.xuse_inc_exp) ) then
       Systemtype.itemindex := 1;
    if ( (not(cash1.Xcashbook)) and (not(Cash11.xuse_inc_exp)) ) then
       Systemtype.itemindex := 2;
    if ( (cash1.Xcashbook) and (Cash11.xuse_inc_exp) ) then
       begin
          Systemtype.itemindex := -1;
          ShowMessage('Invalid System Type');
       end;

    nopartners.Text := vartostr(Cash11.xno_of_partners);

    eCashBookLastTx.Text := IntToStr(Cash1.xLastTx);

    rgNomProdRelationship.Items.Clear;
    rgNomProdRelationship.Items.Add(cNomProdRelationship_OnetoOne);
    rgNomProdRelationship.Items.Add(cNomProdRelationship_OnetoMany);
    rgNomProdRelationship.Items.Add(cNomProdRelationship_ManytoMany);

    NomProdRelationShip := GetNomProdRelationship('C:\Kingsacc\'+Cash2.XDIRECTORY);
    if ( NomProdRelationShip = cNomProdRelationship_OnetoOne ) then
       rgNomProdRelationship.ItemIndex := 0
    else if ( NomProdRelationShip = cNomProdRelationship_OnetoMany ) then
       rgNomProdRelationship.ItemIndex := 1
    else if ( NomProdRelationShip = cNomProdRelationship_ManytoMany ) then
       rgNomProdRelationship.ItemIndex := 2
    else
       gbNomProdRelationship.Enabled := False; // do not permit any changes if the relationship is unknown.

    VATControl.text := vartostr(Cash1.XNOMTAX);                 // VAT Control
    DebtorsControl.text := vartostr(Cash1.XNOMDEBTOR);          // Debtors
    CreditorsControl.text := vartostr(Cash1.XNOMCREDIT);        // Creditors
    PLBRoughtForward.text := vartostr(Cash1.XNOMPROFIT);        // P/L Brought Forward
    PrivateIncome.text := vartostr(cash1.XNOMPRVINC);           // Private Income
    PrivateExpenditure.text := vartostr(cash1.XNOMPRVEXP);      // Private Expenditure
    OpeningNetWorth.text := vartostr(cash1.XNOMOPEN);           // Opening Net Worth

    BankMin.text := vartostr(Cash1.XBANKMIN);                   // Bank Min
    BankMax.text := vartostr(Cash1.XBANKMAX);                   // Bank Max
    NomIncFrom.text := vartostr(Cash1.XNOMINCFROM);             // Enterprise Income start
    NomIncTo.text := vartostr(Cash1.XNOMINCTO);                 // Enterprise Income end
    NomExpFrom.text := vartostr(Cash1.XNOMEXPFROM);             // Enterprise Expend start
    NomExpTo.text := vartostr(Cash1.XNOMEXPTO);                 // Enterprise Expend end
    NonEntIncFrom.text := vartostr(Cash1.XNOMNONFROM);          // Non Enterprise Income start
    NonEntIncTo.text := vartostr(Cash1.XNOMNONTO);              // Non Enterprise Income end
    SalesDiscounts.text := vartostr(Cash1.XNOMSLDISC);          // Sales Discounts
    PurchaseDiscounts.text := vartostr(Cash1.XNOMPLDISC);       // Purchase Discounts
    OverheadsFrom.text := vartostr(Cash1.XNOMOHFROM);           // Overheads start
    OverheadsTo.text := vartostr(Cash1.XNOMOHTO);               // Overheads end
    CAFrom.text := vartostr(Cash1.XNOMCAFROM);                  // Current Assets start
    CATo.text := vartostr(Cash1.XNOMCATO);                      // Current Assets end
    FAFrom.text := vartostr(Cash1.XNOMFAFROM);                  // Fixed Assets start
    FATo.text := vartostr(Cash1.XNOMFATO);                      // Fixed Assets end
    LiFrom.text := vartostr(Cash1.XNOMLIFROM);                  // Liabilities start
    LiTo.text := vartostr(Cash1.XNOMLITO);                      // Liabilities end
    Depreciation.text := vartostr(Cash1.XNOMDEPREC);            // Depreciation

    SimpleVATCheckbox.Checked := ( Cash11.XSimpleVAT ) and ( not(cash1.Xcashbook) ); 
end;

function TSystemDefinitionForm.SaveDefs : Boolean;
var
   testint : integer;
begin
   Result := true;

   try
      testint := strtoint(nopartners.text)
   except
   end;

   if ( (testint < 9) and (testint > -1) ) then
      Cash11.xno_of_partners := testint
   else
      begin
         ShowMessage('Number of Extra Partners must be between 0 and 9');
         Result := false;
      end;

   cash11.XUse_Vat := ( not(Use_vat.checked) );
   if ( Use_vat.checked ) then
      begin
         if ( VATGroup.ItemIndex = 1 ) then
            cash2.xcountry := 1;
         if ( VATGroup.ItemIndex = 0 ) then
            cash2.xcountry := 2;
      end;

   cash11.Xuse_enterprise := ( not(Use_enterprise.checked) );

   cash11.xbilling := ( not(Use_billing.checked) );

   cash2.XWININV := invoicer.Checked;

   cash1.XYEAREND := ArchiveCB.Checked;

   if ( Systemtype.ItemIndex = 0 ) then
      begin
         cash1.Xcashbook := true;
         Cash11.xuse_inc_exp := false;
      end;

   if ( Systemtype.ItemIndex = 1 ) then
      begin
         cash1.Xcashbook := false;
         Cash11.xuse_inc_exp := true;
      end;

   if ( Systemtype.ItemIndex = 2 ) then
      begin
         cash1.Xcashbook := false;
         Cash11.xuse_inc_exp := false;
      end;

   cash2.xAllocation := InvoiceAllocCB.Checked;

   cash2.XPaymentVAT := cbPaymentBasedVat.checked;
   if ( cbPaymentBasedVat.Checked ) then
      cash11.xSalesPaymentVAT := 'Y'
   else
      cash11.xSalesPaymentVAT := 'N';

   Cash1.XNOMTAX := strtoint(VATControl.text);                 // VAT Control
   Cash1.XNOMDEBTOR := strtoint(DebtorsControl.text);          // Debtors
   Cash1.XNOMCREDIT := strtoint(CreditorsControl.text);        // Creditors
   Cash1.XNOMPROFIT := strtoint(PLBRoughtForward.text);        // P/L Brought Forward
   cash1.XNOMPRVINC := strtoint(PrivateIncome.text);           // Private Income
   cash1.XNOMPRVEXP := strtoint(PrivateExpenditure.text);      // Private Expenditure
   cash1.XNOMOPEN   := strtoint(OpeningNetWorth.text);         // Opening Net Worth
   cash1.XBANKMIN   := strtoint(BankMin.text);                 // BankMin
   cash1.XBANKMAX   := strtoint(BankMax.text);                 // BankMax
   Cash1.XNOMINCFROM := strtoint(NomIncFrom.text);             // Enterprise Income start
   Cash1.XNOMINCTO   := strtoint(NomIncTo.text);               // Enterprise Income end
   Cash1.XNOMEXPFROM := strtoint(NomExpFrom.text);             // Enterprise Expend start
   Cash1.XNOMEXPTO   := strtoint(NomExpTo.text);               // Enterprise Expend end

   Cash1.XNOMNONFROM := strtoint(NonEntIncFrom.text);          // Non Enterprise Income start
   Cash1.XNOMNONTO := strtoint(NonEntIncTo.text);              // Non Enterprise Income end
   Cash1.XNOMSLDISC := strtoint(SalesDiscounts.text);          // Sales Discounts
   Cash1.XNOMPLDISC := strtoint(PurchaseDiscounts.text);       // Purchase Discounts
   Cash1.XNOMOHFROM := strtoint(OverheadsFrom.text);           // Overheads start
   Cash1.XNOMOHTo := strtoint(OverheadsTo.text);               // Overheads end
   Cash1.XNOMCAFROM := strtoint(CAFrom.text);                  // Current Assets start
   Cash1.XNOMCATO := strtoint(CATo.text);                      // Current Assets end
   Cash1.XNOMFAFROM := strtoint(FAFrom.text);                  // Fixed Assets start
   Cash1.XNOMFATO := strtoint(FATo.text);                      // Fixed Assets end
   Cash1.XNOMLIFROM := strtoint(LiFrom.text);                  // Liabilities start
   Cash1.XNOMLITO := strtoint(LiTo.text);                      // Liabilities end
   Cash1.XNOMDEPREC := strtoint(Depreciation.text);            // Depreciation

   Cash1.xLastTx := strtoint(eCashBookLastTx.Text);

   Cash11.XSimpleVAT := ( SimpleVATCheckbox.Checked ) and ( not(cash1.Xcashbook) );

   if ( result ) then
      begin
         DEFWRITE(11);
         DEFWRITE(1);
         DEFWRITE(0);
      end;

   SetNomProdRelationship( rgNomProdRelationship.Items[rgNomProdRelationship.ItemIndex]);
end;

procedure TSystemDefinitionForm.SaveBtnClick(Sender: TObject);
begin
   if ( PageControl1.ActivePageIndex = NominalAccounts.PageIndex ) then
      RebuildDataBtnClick(Sender)
   else
      begin
         if ( SaveDefs ) then
            begin
               ShowMessage('Kingswood Accounts will now shutdown this set of accounts to apply changes');
               Close;
           end;
      end;
end;

procedure TSystemDefinitionForm.ExitbtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSystemDefinitionForm.FormShow(Sender: TObject);
begin
   Pagecontrol1.ActivePageIndex := 0;
   ReadDefs;
end;

procedure TSystemDefinitionForm.Use_VatClick(Sender: TObject);
begin
   if ( Use_vat.checked ) then
      begin
         VATGroup.Visible := true;
         if ( cash2.xcountry = 2 ) then
            VATGroup.ItemIndex := 0;
         if ( cash2.xcountry = 1 ) then
            VATGroup.ItemIndex := 1;
      end
   else
      VATGroup.visible := false;
end;

procedure TSystemDefinitionForm.ChangeSerialClick(Sender: TObject);
var
   CashSerial : longint;
   SerialNo : string;
begin
   CashSerial := PSysLongToDelphi ( Cash11.serial_no );
   SerialNo:= InputBox('Enter New Data Serial Number', 'Serial No', varToStr(CashSerial));
   CashSerial := StrToInt(SerialNo);
   DelphiLongToPSys(CashSerial,Cash11.serial_no);
   DefWrite ( 11 );
   ReadDefs;
end;

procedure TSystemDefinitionForm.ChangeDataPathClick(Sender: TObject);
var
   path, newpath : string;
begin
   path := Cash2.XDirectory;
   newpath:= InputBox('Enter New Data Path', 'Data Path (Max 7 characters followed by \)', path);
   cash2.xdirectory := newpath;
   DefWrite ( 2 );
   ReadDefs;
end;

procedure TSystemDefinitionForm.eCashBookLastTxKeyPress(Sender: TObject;
  var Key: Char);
begin
   if ( not(Key in [#8, '0'..'9']) ) then Exit;
end;

function GetNomProdRelationship(ADatabasePath : string) : string;
begin
   with TQuery.Create(nil) do
      try
         try
            DatabaseName := ADatabasePath;
            SQL.Add('SELECT NomProdRelationship FROM AccsDefaults ');
            Open;
            First;
            Result := Fields[0].AsString;
         except
            Result := 'Unknown';
         end;
      finally
         Free;
      end;
end;

procedure TSystemDefinitionForm.SetNomProdRelationship(
  const Value: string);
begin
   with TQuery.Create(nil) do
      try
         DatabaseName := 'C:\Kingsacc\'+ cash2.XDIRECTORY;
         SQL.Add(Format('UPDATE AccsDefaults SET NomProdRelationship = ''%s''',[Value]));
         ExecSQL;
      finally
         Free;
      end;
end;

procedure TSystemDefinitionForm.ChangeCompanyNameClick(Sender: TObject);
var
   name, newname : string;
begin
   name := cash1.XCOMPANY;
   newname:= InputBox('Enter New Company Name', 'Company Name', name);
   cash1.XCOMPANY := newname;
   DefWrite ( 1 );
   ReadDefs;
end;

procedure TSystemDefinitionForm.PrivateIncomeChange(Sender: TObject);
var
   ID : Integer;
begin
   try
      ID := strtoint(PrivateIncome.text);
      PrivateExpenditure.text := vartostr(ID + 10);
      VATControl.text := vartostr(ID + 20);
      DebtorsControl.text := vartostr(ID + 21);
      CreditorsControl.text := vartostr(ID + 22);
      PLBRoughtForward.text := vartostr(ID + 23);
      OpeningNetWorth.text := vartostr(ID + 33);
   except

   end;
end;

procedure TSystemDefinitionForm.NonEntIncToExit(Sender: TObject);
begin
   PurchaseDiscounts.Text := NonEntIncTo.text;
end;

procedure TSystemDefinitionForm.OverheadsFromExit(Sender: TObject);
begin
   SalesDiscounts.Text := OverheadsFrom.text;
end;

procedure TSystemDefinitionForm.OverheadsToExit(Sender: TObject);
begin
   Depreciation.Text := OverheadsTo.text;
end;

procedure TSystemDefinitionForm.RebuildDataBtnClick(Sender: TObject);
var
   FileName : pchar;
   progpath : string;
   RecNo : integer;
begin
   if ( MessageDlg('You are sure you wish to delete nominal codes losing all data and rebuild?',
                   mtConfirmation, [mbYes, mbNo], 0) = MrYes ) then
      begin
         if ( SaveDefs ) then
            begin
               // close the current NLFile

               AccsDataModule.NLFileDB.Close;
               AccsDataModule.NLGroupsDB.Close;

               // delete current file & index

               progpath := extractfilepath(paramStr(0));
               FileName := pchar(progpath + Cash2.XDIRECTORY + 'NLFile.db');
               DeleteFile(FileName);
               FileName := pchar(progpath + Cash2.XDIRECTORY + 'NLFile.px');
               DeleteFile(FileName);
               FileName := pchar(progpath + Cash2.XDIRECTORY + 'NLGroups.db');
               DeleteFile(FileName);
               FileName := pchar(progpath + Cash2.XDIRECTORY + 'NLGroups.px');
               DeleteFile(FileName);

               AccsDataModule.CreateNLFileTable;
               AccsDataModule.CreateNLGroupsTable;

               AccsDataModule.AddNLGroups;
               AccsDataModule.AddNLCodes;

               AccsDataModule.NLFileDB.Open;
               AccsDataModule.NLGroupsDB.Open;

               AccsDataModule.NLFileDB.first;

               // add category info

               for RecNo:= 1 to AccsDataModule.NLFileDB.RecordCount do
                  begin
                     Accsdatamodule.NLFileDB.edit;
                     if ( (RECNO >= Cash1.xNomIncFrom) and (RecNo <= Cash1.xNomIncTo) ) then
                        AccsDataModule.NLFileDB.FieldValues['Category'] := 'EI';
                     if ( (RECNO >= Cash1.xNomNonFrom) and (RecNo <= Cash1.xNomNonTo) ) then
                        AccsDataModule.NLFileDB.FieldValues['Category'] := 'NEI';
                     if ( (RECNO >= Cash1.xNomExpFrom) and (RecNo <= Cash1.xNomExpTo) ) then
                        AccsDataModule.NLFileDB.FieldValues['Category'] := 'EE';
                     if ( (RECNO >= Cash1.xNomOhFrom) and (RecNo <= Cash1.xNomOhTo) ) then
                        AccsDataModule.NLFileDB.FieldValues['Category'] := 'OH';
                     if ( (RECNO >= Cash1.xNomCaFrom) and (RecNo <= Cash1.xNomCaTo) ) then
                        AccsDataModule.NLFileDB.FieldValues['Category'] := 'CA';
                     if ( (RECNO >= Cash1.xNomFaFrom) and (RecNo <= Cash1.xNomFaTo) ) then
                        AccsDataModule.NLFileDB.FieldValues['Category'] := 'FA';
                     if ( (RECNO >= Cash1.xNomLiFrom) and (RecNo <= Cash1.xNomLiTo) ) then
                        AccsDataModule.NLFileDB.FieldValues['Category'] := 'LI';
                     if ( (RECNO >= Cash1.xBankMin) and (RecNo <= Cash1.xBankMax) ) then
                        AccsDataModule.NLFileDB.FieldValues['Category'] := 'BA';
                     if ( (RECNO >= Cash1.xBankMax+1) and (RecNo <= Cash1.xnomopen + cash11.xno_of_partners) ) then
                        AccsDataModule.NLFileDB.FieldValues['Category'] := 'CTRL';

                     if ( RECNO = Cash1.xBankMin ) then
                        begin       // programme won't open a few forms without an active bank account
                           Accsdatamodule.NLFileDB.FieldValues['Active'] := True;
                           Accsdatamodule.NLFileDB.FieldValues['Name'] := 'Default Bank';
                        end;

                     AccsDataModule.NLFileDB.post;
                     AccsDataModule.NLFileDB.next;
                  end;

            end  // savedefs
         else
            ShowMessage('Error Saving Definition File');
      end;   // messagedlg

   ShowMessage('Complete - Kingswood Accounts must now shutdown this set of accounts to apply changes');
   Close;
end;

class procedure TSystemDefinitionForm.SaveInvoicerModule(ASerialNo: Integer; const AHasInvoicer: Boolean);
begin
   if ( ASerialNo <> PSysLongToDelphi(Cash11.serial_no) ) then Exit;
   cash2.XWININV := AHasInvoicer;
   DEFWRITE(11);
   DEFWRITE(1);
   DEFWRITE(0);
end;

end.

