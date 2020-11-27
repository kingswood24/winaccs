{
   Use   : SetUp all Accounts ( Enterprises, Nominals, Customers/Suppliers
   File Used : Enterprise ( EntFile )
               Nominal ( NlFile )
               Sales Ledger ( SlFile )
               Purchase Ledger ( Plfile )

   13/12/16 [V4.2 R5.1] /MK Change - Only allow delete of Nominals, Enterprises, Customers and Suppliers if not using App.

   18/04/17 [V4.2 R7.3] /AB Bug Fix - Incorporated change from Andrew for bug reported to him by Monika on 23/02/17.

   19/10/18 [V4.3 R2.5] /MK Additional Feature - SaveEntAccountClick - If adding an income nominal to an enterprise and one-to-one association is enabled
                                                                       then create a product of the same name as the nominal and link the two together.
                            Change - Grey out access to product drop-down in Enterprise and Nominal Setup screen if Job Card App user and One-To-One association.
                                   - Nominal Accounts - moved Product under Nominal Type drop-down as it is in the Enterprise page.

   25/10/18 [V4.3 R2.5] /MK Additional Feature - If One-To-One association then, after user saves a new enterprise income, pop up uEditAssocItem screen
                                                 that allows the user to add a price and unit for newly created product.
}

unit Setup;

interface

uses
   WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls, Tabs,
   Buttons, Grids, Types, Mask, ExtCtrls, DBCtrls, RXLookup, Menus,
   RXCtrls, DBGrids, cxControls, cxContainer, cxEdit, cxTextEdit,
   cxMaskEdit, cxDropDownEdit, cxColorComboBox, cxDBColorComboBox,
   cxLabel, uFarmSyncSettings, DB, SystemDefinition, uEditAssocItem;

type
  TSetUpAccounts = class(TForm)
    Notebook: TNotebook;
    Enterprises: TGroupBox;
    NominalAccounts: TGroupBox;
    CustomersSuppliers: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    EntGrid: TStringGrid;
    NomGrid: TStringGrid;
    NomPanel: TPanel;
    LabelNomCode: TLabel;
    LabelNomName: TLabel;
    LabelNomBalance: TLabel;
    NomRepGroup: TEdit;
    NomVatCode: TEdit;
    LabelNomReportGroup: TLabel;
    LabelNomVatCode: TLabel;
    NomBalance: TEdit;
    NomName: TEdit;
    NomCode: TEdit;
    Panel1: TPanel;
    AccountPanel: TPanel;
    EntIncome: TRadioButton;
    NomEntIncome: TRadioButton;
    EntExpenditure: TRadioButton;
    Overheads: TRadioButton;
    CurrentAssets: TRadioButton;
    FixedAssets: TRadioButton;
    Liabilities: TRadioButton;
    Banks: TRadioButton;
    AllAccounts: TRadioButton;
    NomGroupDesc: TEdit;
    LabelNomGroupDesc: TLabel;
    ControlAccounts: TRadioButton;
    ShowOpening: TRadioButton;
    ShowCurrent: TRadioButton;
    AddAccount: TBitBtn;
    DelAccount: TBitBtn;
    ListGroups: TSpeedButton;
    ListVATCodes: TSpeedButton;
    NomEntCode: TEdit;
    NomHelp: TBitBtn;
    CustSuppEntryPanel: TPanel;
    CustSuppRadioPanel: TPanel;
    CustSuppGrid: TStringGrid;
    Customers: TRadioButton;
    Suppliers: TRadioButton;
    CustSuppEntryButtonPanel: TPanel;
    BitBtn4: TBitBtn;
    CustSuppSave: TBitBtn;
    CustSuppDelete: TBitBtn;
    CustSuppAdd: TBitBtn;
    CustSuppCancel: TBitBtn;
    CustSuppNo: TEdit;
    CustSuppName: TEdit;
    CustSuppAdd2: TEdit;
    CustSuppAdd3: TEdit;
    CustSuppPostCode: TEdit;
    CustSuppFaxNo: TEdit;
    CustSuppAdd1: TEdit;
    CustSuppAdd4: TEdit;
    CustSuppVATNo: TEdit;
    CustSuppPhone2: TEdit;
    CustSuppPhone1: TEdit;
    CustSuppContact1: TEdit;
    CustSuppContact2: TEdit;
    CustSuppRefCode: TEdit;
    CustSuppComment: TEdit;
    CustSuppTurnover: TEdit;
    CustSuppOpenBalance: TEdit;
    CustSuppAged1: TEdit;
    CustSuppAged2: TEdit;
    CustSuppAged3: TEdit;
    CustSuppAgeCurr: TEdit;
    LabelCustSuppNo: TLabel;
    LabelCustSuppName: TLabel;
    LabelCustSuppAddress: TLabel;
    LabelCustSuppPostCode: TLabel;
    LabelCustSuppComment: TLabel;
    LabelCustSuppRefCode: TLabel;
    LabelcustSuppFax: TLabel;
    LabelCustSuppContact1: TLabel;
    LabelcustSuppContact2: TLabel;
    LabelCustSuppPhone1: TLabel;
    LabelCustSuppPhone2: TLabel;
    LabelCustSuppVATNo: TLabel;
    LabelcustSuppTurnover: TLabel;
    LabelCustSuppBalance: TLabel;
    LabelCustSuppAgeCurr: TLabel;
    LabelCustSuppAged1: TLabel;
    LabelCustSuppAged2: TLabel;
    LabelCustSuppAged3: TLabel;
    LabelCustSuppAreaCode: TLabel;
    CustSuppAreaCode: TEdit;
    Panel3: TPanel;
    EntIncomeGrid: TStringGrid;
    EntExpendGrid: TStringGrid;
    LabelIncomeHeading: TLabel;
    LabelExpendHeading: TLabel;
    CancelNominalChanges: TBitBtn;
    SaveNom: TBitBtn;
    StandardExitPanel: TPanel;
    Help: TBitBtn;
    SetUpExit: TBitBtn;
    Panel4: TPanel;
    NomRadioButton: TRadioButton;
    EntRadioButton: TRadioButton;
    CustSuppRadioButton: TRadioButton;
    GroupBox1: TGroupBox;
    LabelEntAccount: TLabel;
    LabelEntAccountName: TLabel;
    LabelEntAccountVatNo: TLabel;
    EntVatCodeButton: TSpeedButton;
    EntReportGroupButton: TSpeedButton;
    LabelEntAccountRepGroup: TLabel;
    LabelEntAccountGroupDesc: TLabel;
    EntAccountGroupNo: TEdit;
    EntAccountName: TEdit;
    EntAccountVatNo: TEdit;
    EntAccount: TEdit;
    EntAccountGroupDesc: TEdit;
    Panel6: TPanel;
    HelpEntAccount: TBitBtn;
    SaveEntAccount: TBitBtn;
    DeleteEntAccount: TBitBtn;
    AddEntAccount: TBitBtn;
    CancelEntAccount: TBitBtn;
    Panel5: TPanel;
    LabelEntCode: TLabel;
    LabelEntUnitdiv: TLabel;
    LabelEntName: TLabel;
    LabelEntUnitName: TLabel;
    LabelEntIncomeRange: TLabel;
    LabelEntExpendRange1: TLabel;
    LabelEntPercOverheads: TLabel;
    EntCode: TEdit;
    EntName: TEdit;
    EntUnitDiv: TEdit;
    EntUnitName: TEdit;
    EntIncomeFrom: TEdit;
    EntIncomeTo: TEdit;
    EntExpendFrom: TEdit;
    EntExpendTo: TEdit;
    Panel7: TPanel;
    HelpEnterprise: TBitBtn;
    SaveEnterprise: TBitBtn;
    DelEnterprise: TBitBtn;
    AddEnterprise: TBitBtn;
    CancelEnterprise: TBitBtn;
    EntPercOverheads: TEdit;
    NoOfIncomeAccounts: TEdit;
    NoOfExpendAccounts: TEdit;
    Label1: TLabel;
    bBudgets: TBitBtn;
    bReport: TBitBtn;
    cbProductsEnts: TRxDBLookupCombo;
    Panel2: TPanel;
    EntIncomeRadio: TRadioButton;
    EntExpendRadio: TRadioButton;
    lProductsEnts: TLabel;
    lProductsNoms: TLabel;
    cbProductsNoms: TRxDBLookupCombo;
    CashbookCoverPanel: TPanel;
    Depreclabel: TLabel;
    TypeLabel: TLabel;
    NominalTypeDropdown: TComboBox;
    depreclabel2: TLabel;
    EntNominalTypeDropdown: TComboBox;
    EntTypeLabel: TLabel;
    RxSpeedButton1: TRxSpeedButton;
    ReportPopup: TPopupMenu;
    NominalAccounts1: TMenuItem;
    EnterpriseReport: TMenuItem;
    Customers1: TMenuItem;
    Suppliers1: TMenuItem;
    SearchBox: TEdit;
    ClearBtn: TButton;
    Deprec_edit: TEdit;
    Deprec_edit2: TEdit;
    ProductsRadioButton: TRadioButton;
    Products: TGroupBox;
    Panel8: TPanel;
    Label2: TLabel;
    Panel9: TPanel;
    AddProduct: TBitBtn;
    DeleteProduct: TBitBtn;
    EditProduct: TBitBtn;
    CancelProduct: TBitBtn;
    SaveProduct: TBitBtn;
    ProductsGrid: TDBGrid;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Desc1: TDBEdit;
    Desc2: TDBEdit;
    Desc3: TDBEdit;
    DefaultPrice: TDBEdit;
    DefaultCheckBox: TDBCheckBox;
    ProductSearch: TEdit;
    ProductListing1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Label11: TLabel;
    cmboColor: TcxDBColorComboBox;
    lColor: TcxLabel;
    sbBankFileFormat: TSpeedButton;
    Qty2Name: TEdit;
    Label12: TLabel;
    Qty3Name: TEdit;
    Label13: TLabel;
    ProductUnitComboBox: TDBComboBox;
    Label14: TLabel;
    Label15: TLabel;
    CustSuppEmailAddress: TEdit;
    ClearBtn2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CustomersSuppliersEnter(Sender: TObject);
    procedure CustomersClick(Sender: TObject);
    procedure SuppliersClick(Sender: TObject);
    procedure EnterprisesEnter(Sender: TObject);
    procedure NomGridClick(Sender: TObject);
    procedure EntIncomeClick(Sender: TObject);
    procedure NomEntIncomeClick(Sender: TObject);
    procedure EntExpenditureClick(Sender: TObject);
    procedure OverheadsClick(Sender: TObject);
    procedure CurrentAssetsClick(Sender: TObject);
    procedure FixedAssetsClick(Sender: TObject);
    procedure LiabilitiesClick(Sender: TObject);
    procedure BanksClick(Sender: TObject);
    procedure AllAccountsClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure ControlAccountsClick(Sender: TObject);
    procedure SaveNomClick(Sender: TObject);
    procedure ShowOpeningClick(Sender: TObject);
    procedure ShowCurrentClick(Sender: TObject);
    procedure NomBalanceChange(Sender: TObject);
    procedure AddAccountClick(Sender: TObject);
    procedure DelAccountClick(Sender: TObject);
    procedure CancelNominalChangesClick(Sender: TObject);
    procedure NomRepGroupChange(Sender: TObject);
    procedure NomNameExit(Sender: TObject);
    procedure CancelNominalChangesExit(Sender: TObject);
    procedure ListGroupsClick(Sender: TObject);
    procedure ListVATCodesClick(Sender: TObject);
    procedure NomVatCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure NomRepGroupKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure CustSuppGridClick(Sender: TObject);
    procedure CustSuppHelpClick(Sender: TObject);
    procedure CustSuppAddClick(Sender: TObject);
    procedure CustSuppCancelClick(Sender: TObject);
    Procedure LogNom (DBNUM,DBAC,CRAC: INTEGER; BAL: LONG);
    procedure CustSuppDeleteClick(Sender: TObject);
    procedure CustSuppSaveClick(Sender: TObject);
    procedure CustSuppAreaCodeExit(Sender: TObject);
    procedure EntGridClick(Sender: TObject);
    procedure EntIncomeGridClick(Sender: TObject);
    procedure EntExpendGridClick(Sender: TObject);
    procedure EntIncomeRadioClick(Sender: TObject);
    procedure EntExpendRadioClick(Sender: TObject);
    procedure DelEnterpriseClick(Sender: TObject);
    procedure SaveEnterpriseClick(Sender: TObject);
    procedure AddEntAccountClick(Sender: TObject);
    procedure CancelEntAccountClick(Sender: TObject);
    procedure EntCodeExit(Sender: TObject);
    procedure EntAccountNameExit(Sender: TObject);
    procedure DeleteEntAccountClick(Sender: TObject);
    procedure NomRadioButtonClick(Sender: TObject);
    procedure EntRadioButtonClick(Sender: TObject);
    procedure CustSuppRadioButtonClick(Sender: TObject);
    procedure NotebookPageChanged(Sender: TObject);
    procedure SetToLong ( Var StrToChange : TEdit );
    procedure CustSuppTurnoverExit(Sender: TObject);
    procedure CustSuppOpenBalanceExit(Sender: TObject);
    procedure CustSuppAgeCurrExit(Sender: TObject);
    procedure CustSuppAged1Exit(Sender: TObject);
    procedure CustSuppAged2Exit(Sender: TObject);
    procedure CustSuppAged3Exit(Sender: TObject);
    procedure NomBalanceExit(Sender: TObject);
    procedure SaveEntAccountClick(Sender: TObject);
    procedure AddEnterpriseClick(Sender: TObject);
    procedure CancelEnterpriseClick(Sender: TObject);
    procedure NoOfIncomeAccountsExit(Sender: TObject);
    procedure NoOfExpendAccountsExit(Sender: TObject);
    Function EntCheckBeforeSave(Sender: TObject) : Boolean;
    procedure EntUnitDivExit(Sender: TObject);
    procedure EntAccountGroupNoChange(Sender: TObject);
    procedure EntCodeEnter(Sender: TObject);
    procedure NomRepGroupExit(Sender: TObject);
    procedure EntAccountVatNoExit(Sender: TObject);
    procedure Radiocheck(Sender : TObject);
    procedure SetUpExitClick(Sender: TObject);
    procedure EntAccountGroupNoDblClick(Sender: TObject);
    procedure EntAccountVatNoDblClick(Sender: TObject);
    procedure HelpEnterpriseClick(Sender: TObject);
    procedure HelpEntAccountClick(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure bBudgetsClick(Sender: TObject);
    procedure bReportClick(Sender: TObject);
    procedure cbProductsEntsCloseUp(Sender: TObject);
    procedure EntIncomeFromDblClick(Sender: TObject);
    procedure EntIncomeToDblClick(Sender: TObject);
    procedure EntExpendFromDblClick(Sender: TObject);
    procedure EntExpendToDblClick(Sender: TObject);
    procedure NoOfIncomeAccountsDblClick(Sender: TObject);
    procedure NoOfExpendAccountsDblClick(Sender: TObject);
    procedure EntAccountChange(Sender: TObject);
    Function PasswordPrompt: boolean;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Deprec_editChange(Sender: TObject);
    procedure EnterpriseReportClick(Sender: TObject);
    procedure NominalAccounts1Click(Sender: TObject);
    procedure Customers1Click(Sender: TObject);
    procedure Suppliers1Click(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure Deprec_editExit(Sender: TObject);
    procedure Deprec_edit2Exit(Sender: TObject);
    procedure ProductsRadioButtonClick(Sender: TObject);
    procedure EditProductClick(Sender: TObject);
    procedure CancelProductClick(Sender: TObject);
    procedure AddProductClick(Sender: TObject);
    procedure DeleteProductClick(Sender: TObject);
    procedure SaveProductClick(Sender: TObject);
    procedure ProductListing1Click(Sender: TObject);
    procedure ProductSearchChange(Sender: TObject);
    procedure sbBankFileFormatClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ClearBtn2Click(Sender: TObject);
    procedure ProductsGridEnter(Sender: TObject);
    procedure NominalAccountsEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AddAmendDeleteEnt,
    AddAmendDelete : ShortString{[3]};
    { RecNo is the Current Active Record in the Main Panel of any setup }
    { Screen ie Cust/Supp Supplier or Customer No }
    {           Nominal - Nominal Account Number }
    {           Enterprise - Enterprise Record Number Not the Code }
    RecNo,
    {           Enterprise - Enterprise Nominal Account in the Panel }
    EntNomRecNo,
    cDb : Integer;
    OrigEntCode : ShortString{[4]};
  end;

var
  SetUpAccounts: TSetUpAccounts;

implementation
Uses
    LangUnit,
    Dialogs,
    SysUtils,
    Calcs,
    DBCore,
    DBGen,
    Util,
    Vars,
    Clears,
    MainUnit,
    NewListing,
    UEntSetUp,
    UCustSuppSetUp,
    UNominalSetUp,
    NomRpt,
    NewRepUnit,
    RcsList,
    uBudgets,
    uSetUpProducts,
    AccsData,
    ReportDefs,
    ProductListing,
    uAccounts, uBankFileFormatSelector, uPreferenceConsts, uPreferences;

Var
   LastCust,
   LastSupp,
   LastNom,
   LastEnt  : Integer;
   ValidPassword : Boolean;  // TGM AB remembers if a valid setup password has been entered

{$R *.DFM}

procedure TSetUpAccounts.FormCreate(Sender: TObject);
begin
   LastCust := 0;
   LastSupp := 0;
   LastNom := 0;
   LastEnt := 0;
   SetUpAccounts.AddAmendDelete := '';
   SetUpAccounts.AddAmendDeleteEnt := '';
   SetUpAccounts.Caption := 'Nominal Accounts';
   NominalButtonNames;
   CustSuppButtonNames;
   AccsDataModule.GetProductUnits(ProductUnitComboBox.Items);
end;

procedure TSetUpAccounts.CustomersSuppliersEnter(Sender: TObject);
begin
     If SetUpAccounts.Customers.Checked Then
        SetUpAccounts.cDb := SLFile
     Else
        If SetUpAccounts.Suppliers.Checked Then
           SetUpAccounts.cDb := PLFile
        Else
            Begin
                 SetUpAccounts.Customers.Checked := True;
                 SetUpAccounts.CustSuppGrid.SetFocus;
                 SetUpAccounts.cDb := SLFile;
            End;
end;

procedure TSetUpAccounts.CustomersClick(Sender: TObject);
begin
     AddAmendDelete := '';
     CustomersSuppliers.Caption := 'Customers';
     SetUpAccounts.cDb := SlFile;
     SetDB ( SetUpAccounts.cDb );
     FillCustSuppGrid('');
end;

procedure TSetUpAccounts.SuppliersClick(Sender: TObject);
begin
     AddAmendDelete := '';
     CustomersSuppliers.Caption := 'Suppliers';
     SetUpAccounts.cDb := PLFile;
     SetDB ( SetUpAccounts.cDb );
     FillCustSuppGrid('');
end;

procedure TSetUpAccounts.EnterprisesEnter(Sender: TObject);
begin
   SetUpAccounts.cDb := EntFile;
   SetDb ( SetUpAccounts.cDb );
   with cmboColor.DataBinding do
      begin
         DataSource := AccsDataModule.Ents;
         DataField := 'Color';
      end;

   AccsDataModule.Products.Close;
   AccsDataModule.Products.Open;

   lProductsEnts.Enabled := ( not(AccsDataModule.NomProdRelationship = cNomProdRelationship_OnetoOne) );
   cbProductsEnts.Enabled := lProductsEnts.Enabled;
   ClearBtn2.Enabled := lProductsEnts.Enabled;
end;

procedure TSetUpAccounts.NomGridClick(Sender: TObject);
Var
   RecToRead : Integer;
begin
     RecToRead := 0;
     If Numeric ( NomGrid.Cells[0, NomGrid.Row]) Then
        RecToRead := StrToInt (NomGrid.Cells[0, NomGrid.Row]);
     If RecToRead <> 0 Then
        FillNomPanel ( RecToRead );
end;

procedure TSetUpAccounts.EntIncomeClick(Sender: TObject);
begin
     SetUpAccounts.NomGrid.Rowcount := 3;
     SetUpAccounts.NomEntCode.Visible := True;
     SetUpAccounts.NominalAccounts.Caption := 'Enterprise Income Accounts (Range '
                                           + IntToStr ( Cash1.xNomincFrom ) + ' To ' + IntToStr ( Cash1.xNomIncTo ) + ')';
     SetUpAccounts.NomBalance.Enabled := False;
     // Call cancel Button Code
     CancelNominalChangesClick(Sender);
     FillNomGrid ( GetAccountRanges );
     RadioCheck(Sender);
end;

procedure TSetUpAccounts.NomEntIncomeClick(Sender: TObject);
begin
     SetUpAccounts.NomGrid.Rowcount := 3;
     SetUpAccounts.NomEntCode.Visible := False;
     SetUpAccounts.NominalAccounts.Caption := 'Non-Enterprise Income Accounts  (Range '
                                           + IntToStr ( Cash1.xNomNonFrom ) + ' To ' + IntToStr ( Cash1.xNomNonTo ) + ')';
     SetUpAccounts.NomBalance.Enabled := False;
     // Call cancel Button Code
     CancelNominalChangesClick(Sender);
     FillNomGrid ( GetAccountRanges );
     RadioCheck(Sender);
end;

procedure TSetUpAccounts.EntExpenditureClick(Sender: TObject);
begin
     SetUpAccounts.NomGrid.Rowcount := 3;
     SetUpAccounts.NomEntCode.Visible := True;
     SetUpAccounts.NominalAccounts.Caption := 'Enterprise Expenditure Accounts (Range '
                                           + IntToStr ( Cash1.xNomExpFrom ) + ' To ' + IntToStr ( Cash1.xNomExpTo ) + ')';
     SetUpAccounts.NomBalance.Enabled := False;
     // Call cancel Button Code
     CancelNominalChangesClick(Sender);
     FillNomGrid ( GetAccountRanges );
     RadioCheck(Sender);
end;

procedure TSetUpAccounts.OverheadsClick(Sender: TObject);
begin
     SetUpAccounts.NomGrid.Rowcount := 3;
     SetUpAccounts.NomEntCode.Visible := False;
     SetUpAccounts.NominalAccounts.Caption := 'Overhead Accounts (Range '
                                           + IntToStr ( Cash1.xNomOhFrom ) + ' To ' + IntToStr ( Cash1.xNomOhTo ) + ')';
     SetUpAccounts.NomBalance.Enabled := False;
     // Call cancel Button Code
     CancelNominalChangesClick(Sender);
     FillNomGrid ( GetAccountRanges );
     RadioCheck(Sender);
end;

procedure TSetUpAccounts.CurrentAssetsClick(Sender: TObject);
begin
     SetUpAccounts.NomGrid.Rowcount := 3;
     SetUpAccounts.NomEntCode.Visible := False;
     SetUpAccounts.NominalAccounts.Caption := 'Current Asset Accounts (Range '
                                           + IntToStr ( Cash1.xNomCaFrom ) + ' To ' + IntToStr ( Cash1.xNomCaTo ) + ')';
     SetUpAccounts.NomBalance.Enabled := True;
     // Call cancel Button Code
     CancelNominalChangesClick(Sender);
     FillNomGrid ( GetAccountRanges );
     RadioCheck(Sender);
end;

procedure TSetUpAccounts.FixedAssetsClick(Sender: TObject);
begin
     SetUpAccounts.NomGrid.Rowcount := 3;
     SetUpAccounts.NomEntCode.Visible := False;
     SetUpAccounts.NominalAccounts.Caption := 'Fixed Asset Accounts (Range '
                                           + IntToStr ( Cash1.xNomFaFrom ) + ' To ' + IntToStr ( Cash1.xNomFaTo ) + ')';
     SetUpAccounts.NomBalance.Enabled := True;
     // Call cancel Button Code
     CancelNominalChangesClick(Sender);
     FillNomGrid ( GetAccountRanges );
     RadioCheck(Sender);
end;

procedure TSetUpAccounts.LiabilitiesClick(Sender: TObject);
begin
     SetUpAccounts.NomGrid.Rowcount := 3;
     SetUpAccounts.NomEntCode.Visible := False;
     SetUpAccounts.NominalAccounts.Caption := 'Liability Accounts (Range '
                                           + IntToStr ( Cash1.xNomLiFrom ) + ' To ' + IntToStr ( Cash1.xNomLiTo ) + ')';
     SetUpAccounts.NomBalance.Enabled := True;
     // Call cancel Button Code
     CancelNominalChangesClick(Sender);
     FillNomGrid ( GetAccountRanges );
     RadioCheck(Sender);
end;

procedure TSetUpAccounts.BanksClick(Sender: TObject);
begin
     SetUpAccounts.NomGrid.Rowcount := 3;
     SetUpAccounts.NomEntCode.Visible := False;
     SetUpAccounts.NominalAccounts.Caption := 'Bank Accounts (Range '
                                           + IntToStr ( Cash1.xBankMin ) + ' To ' + IntToStr ( Cash1.xBankMax ) + ')';
     SetUpAccounts.NomBalance.Enabled := True;
     // Call cancel Button Code
     CancelNominalChangesClick(Sender);
     FillNomGrid ( GetAccountRanges );
     RadioCheck(Sender);
end;

procedure TSetUpAccounts.AllAccountsClick(Sender: TObject);
begin
     SetUpAccounts.NomGrid.Rowcount := 3;
     SetUpAccounts.NomEntCode.Visible := False;
     SetDb ( SetUpAccounts.cDb );
     SetUpAccounts.NominalAccounts.Caption := 'All Ledger Accounts';
     SetUpAccounts.NomBalance.Enabled := False;
     // Call cancel Button Code
     CancelNominalChangesClick(Sender);
     FillNomGrid ( GetAccountRanges );
     RadioCheck(Sender);
end;

procedure TSetUpAccounts.ControlAccountsClick(Sender: TObject);
begin
     SetUpAccounts.NomGrid.Rowcount := 3;
     SetUpAccounts.NomEntCode.Visible := False;
     SetUpAccounts.NominalAccounts.Caption := 'Control Accounts (Range '
                                           + IntToStr ( Cash1.xBankMax+1 ) + ' To ' + IntToStr ( Cash1.xNomOpen+Cash11.xno_of_partners ) + ')';
     SetUpAccounts.NomBalance.Enabled := True;
     Showmessage('Warning - changing the balances of creditors and debtors control accounts can result in the balances not matching the age of debt summaries. Please take care.');
     // Call cancel Button Code
     CancelNominalChangesClick(Sender);
     FillNomGrid ( GetAccountRanges );
     RadioCheck(Sender);
end;

procedure TSetUpAccounts.HelpBtnClick(Sender: TObject);
begin
     Application.HelpContext(118);
end;

procedure TSetUpAccounts.SaveNomClick(Sender: TObject);
var
   RecToRead : Integer;
   NomTypeStr : char;
begin
   if ( cash1.xyearend ) then
      if ( MessageDlg('You are making changes to an archive set of accounts, are you sure you want to continue?',
                      mtConfirmation,[mbYes,mbNo],0) = mrNo ) then Exit;

   AddAmendDelete := '';
   AddAccount.Enabled := True;

   RecToRead := StrToInt(NomCode.Text);

   if ( (RecToRead >=Cash1.xNomIncFrom) and (RecToRead <=Cash1.xNomOhTo) ) then
      begin
         case Setupaccounts.NominalTypeDropdown.ItemIndex of
            1 : NomTypeStr := 'L';
            2 : NomTypeStr := 'P';
            3 : NomTypeStr := 'O';
            4 : NomTypeStr := 'U';
         end;
         if ( Length(NomTypeStr) > 0 ) then
            begin
               currdisp[1] := NomTypeStr;
               putitem(NLFile,103);
            end;
      end;

   if ( ((RecToRead >= Cash1.xNomCaFrom) and (RectoRead <=Cash1.xNomCaTo)) or
        ((RecToRead >= Cash1.xNomFaFrom) and (RecToRead <=Cash1.xNomFaTo)) ) then
      begin
         currlong := strtoint(floattostr(100 * strtofloat(Deprec_edit.text)));
         putitem(NLFile,101);
         currlong := strtoint(floattostr(100 * strtofloat(Deprec_edit2.text)));
         putitem(NLFile,102);
      end;

   SaveNominal;

   {
   //   25/10/18 - The below code will change the name of the associated product to the nominal name - GL asked that this be removed
   if ( UpperCase(AddAmendDelete) = '' ) then
      if ( not(Cash1.XCASHBOOK) ) and ( not(cash11.xbilling) ) and ( EntIncomeRadio.Checked ) then
         if ( AccsDataModule.NomProdRelationship = cNomProdRelationship_OnetoOne ) then
            if ( (cbProductsNoms.Value <> '') and (cbProductsNoms.Value <> '0') ) then
               if ( AccsDataModule.Products.Locate('ID',cbProductsEnts.Value,[loCaseInsensitive]) ) then
                  if ( AccsDataModule.Products.FieldByName('Desc1').AsString <> NomName.Text ) then
                     try
                        try
                           AccsDataModule.Products.Edit;
                           AccsDataModule.Products.FieldByName('Desc1').AsString := NomName.Text;
                           AccsDataModule.Products.Post;
                        except
                           on e : Exception do
                              begin
                                 ShowMessage(e.Message);
                                 if ( AccsDataModule.Products.State in dsEditModes ) then
                                    AccsDataModule.Products.Cancel;
                              end;
                        end;
                     finally
                        AccsDataModule.Products.Close;
                        AccsDataModule.Products.Open;
                     end;
   }

   cancelnominalchanges.enabled := false; // TGM AB 4/06/02

   sbBankFileFormat.Enabled := True;
end;

procedure TSetUpAccounts.ShowOpeningClick(Sender: TObject);
begin
     FillNomPanel ( SetUpAccounts.RecNo );
end;

procedure TSetUpAccounts.ShowCurrentClick(Sender: TObject);
begin
     FillNomPanel ( SetUpAccounts.RecNo );
end;

procedure TSetUpAccounts.NomBalanceChange(Sender: TObject);
Var
   TestLong : Long;
begin
     If IsItLong ( SetUpAccounts.NomBalance.Text, 'L', TestLong ) Then
        Begin
             If ( TestLong < 0 ) Then
                SetUpAccounts.NomBalance.Font.Color := clRed
             Else
                 SetUpAccounts.NomBalance.Font.Color := clBlack;
        End
     Else
        Begin
             SetUpAccounts.NomBalance.Text := '';
             SetUpAccounts.NomBalance.SetFocus;
        End;
end;

procedure TSetUpAccounts.AddAccountClick(Sender: TObject);
begin
     if ( EntIncome.Checked ) Or ( EntExpenditure.Checked ) then
        MessageDLG('Cannot Add Enterprise Income/Expenditure Accounts here - Select Enterprises',mtInformation,[mbOK],0)
     else if ( ControlAccounts.Checked ) then
        MessageDLG('Cannot Add Control Accounts',mtInformation,[mbOK],0)
     else
        begin
           AddAmendDelete := 'ADD';
           AddAccount.Enabled := False;
           NewNominalAccount;
           AccsDataModule.NomListOk := FALSE;
           if AddAmendDelete = 'ADD' then cancelnominalchanges.enabled := true; // TGM AB 4/06/02

           sbBankFileFormat.Enabled := False;
        end;
end;

procedure TSetUpAccounts.DelAccountClick(Sender: TObject);
begin
     AddAmendDelete := 'DEL';
     AddAccount.Enabled := True;
     DeleteNominalAccount;
end;

procedure TSetUpAccounts.CancelNominalChangesClick(Sender: TObject);
begin
     AddAccount.Enabled := True;
     CancelNominalAccount;
     AccsDataModule.NomListOk := TRUE;
     cancelnominalchanges.enabled := false; // TGM AB 4/06/02
end;

procedure TSetUpAccounts.NomRepGroupChange(Sender: TObject);
begin
     ReadTables ( NlFile, StrToInt ( SetUpAccounts.NomRepGroup.Text ), CurrStr );
     SetUpAccounts.NomGroupDesc.Text := CurrStr;
end;

procedure TSetUpAccounts.NomNameExit(Sender: TObject);
Var
   GroupStr,
   TestStr : ShortString;
begin
     TestStr := SetUpAccounts.NomName.Text;
     SlimAll ( TestStr );
     If ( Length ( TestStr ) = 0 ) And
        ( NOT SetUpAccounts.CancelNominalChanges.Focused ) Then
        Begin
             MessageDlg('Accounts has no Name', mtInformation, [mbOk], 0);
             SetUpAccounts.NomName.SetFocus;
        End
     else
        // Default Group to Account Name
        if Cash1.XSETGROUP then
           begin
              GroupStr := NomGroupDesc.Text;
              SlimAll(GroupStr);
              if Length(GroupStr) = 0 then
                 NomGroupDesc.Text := TestStr;
           end;
end;

procedure TSetUpAccounts.CancelNominalChangesExit(Sender: TObject);
begin
     AddAmendDelete := '';
end;

procedure TSetUpAccounts.ListGroupsClick(Sender: TObject);
begin

     Case NoteBook.PageIndex Of
          0 : NewListBox.ListGroups ( Sender, GetAccountRanges);
          1 : NewListBox.ListGroups ( Sender, UEntsetUp.GetAccountRanges);
     End;
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        If NomRadioButton.Checked Then { Nominal Accounts Group Set-Up }
           SetUpAccounts.NomRepGroup.Text := NewListBox.ListInfo.ReturnValue
        Else { Enterprise set-up }
           SetUpAccounts.EntAccountGroupNo.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TSetUpAccounts.ListVATCodesClick(Sender: TObject);
begin
     {NewListBox.ListInfo.ActiveDb := 0;
     NewListBox.ListInfo.ListType := 'V';
     NewListBox.ListInfo.AccRange[1] := 0;
     NewListBox.ListInfo.AccRange[2] := 0;
     NewListBox.ShowModal;}

     NewListBox.ListIt ( Sender, Vat, 'V');   { VAT Rates }
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        Begin
             Case SetUpAccounts.NoteBook.PageIndex Of
                  0 : Begin
                           SetUpAccounts.NomVATCode.SetFocus;
                           SetUpAccounts.NomVATCode.Text := NewListBox.ListInfo.ReturnValue;
                      End;
                  1 : Begin
                           SetUpAccounts.EntAccountVatNo.SetFocus;
                           SetUpAccounts.EntAccountVATNo.Text := NewListBox.ListInfo.ReturnValue;
                      End;
             End;
        End;
End;

procedure TSetUpAccounts.NomVatCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then    { F2 Pressed }
       SetUpAccounts.ListVATCodesClick(Sender);
end;

procedure TSetUpAccounts.NomRepGroupKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F2 Then   { F2 Pressed }
       SetUpAccounts.ListGroupsClick(Sender);
end;

procedure TSetUpAccounts.FormActivate(Sender: TObject);
begin
   with SetUpAccounts Do
        begin
             ProductListing1.Visible := false;    // Do not show the products
             ProductsRadioButton.visible := false;

             if NOT Cash11.xBilling then // Do show the products
                try
                   AccsDataModule.GetAllNominalLedgerAccs;
                   AccsDataModule.NominalList.Open;
                   AccsDataModule.Products.Open;
                   ProductListing1.Visible := true;
                   ProductsRadioButton.visible := true;
                except
                   ShowMessage('Cannot open Products File');
                end;

             CustSuppRadioButton.Caption := ReadLang ( 71, CurrLang );
             NomRadioButton.Caption := ReadLang ( 72, CurrLang );
             EntRadioButton.Caption := ReadLang ( 73, CurrLang );
             SetUpAccounts.NomBalance.Enabled := False;
             CustSuppRadioButton.Show;

             If NOT Cash11.xUse_Enterprise Then
                Begin
                   EntIncome.Show;
                   EntExpenditure.Show;
                   EntRadioButton.Show;
                End
             Else
                Begin
                   EntRadioButton.Hide;
                   EntIncome.Hide;
                   EntExpenditure.Hide;
                End;

             CashbookCoverPanel.visible := cash1.xcashbook;

             NoteBook.ActivePage := Notebook.Pages[2]; // TGM AB 12/08/02 Default Page Customer / supplier
             CustSuppRadioButton.checked := true;
             EntRadioButton.Checked := false;
             NomRadioButton.Checked := false;
             Validpassword := false;
        End;

    EnterpriseReport.visible := ( not(Cash11.xUse_Enterprise) );
end;

procedure TSetUpAccounts.CustSuppGridClick(Sender: TObject);
Var
   RecToRead : Integer;
begin
     AddAmendDelete := '';
     RecToRead := 0;
     If Numeric ( CustSuppGrid.Cells[0, CustSuppGrid.Row]) Then
        RecToRead := StrToInt (CustSuppGrid.Cells[0, CustSuppGrid.Row]);
     If RecToRead <> 0 Then
        FillCustSuppPanel ( RecToRead );
end;

procedure TSetUpAccounts.CustSuppHelpClick(Sender: TObject);
begin
    HelpBtnClick(Sender);
end;

procedure TSetUpAccounts.CustSuppAddClick(Sender: TObject);
begin
     AddAmendDelete := 'ADD';
     CustSuppAdd.Enabled := False;
     NewCustSuppAccount;
     custsuppcancel.enabled := true; // TGM AB 4/06/02
end;

procedure TSetUpAccounts.CustSuppCancelClick(Sender: TObject);
begin
    CustSuppAdd.Enabled := True;
    CancelCustSuppAccount;
    custsuppcancel.enabled := false; // TGM AB 4/06/02
end;

PROCEDURE TSetUpAccounts.LOGNOM (DBNUM,DBAC,CRAC: INTEGER; BAL: LONG);

  PROCEDURE LOGOFF;
  BEGIN				  { begin logoff }
    MessageDlg('MISSING NOMINAL ACCOUNT', mtInformation,[mbOK], 0);
    EXIT;
  END;				   { end logoff }

BEGIN					   { begin lognom }
  SETDB (DBNUM);
  IF (DBAC<1) OR (DBAC>DB1.DBRECTOT) OR (CRAC<1) OR (CRAC>DB1.DBRECTOT) THEN
    LOGOFF;
  READREC(DBNUM,CRAC);
  dberr;
  IF NOT RECACTIVE(DBNUM) THEN LOGOFF;
  READREC(DBNUM,DBAC);
  dberr;
  IF NOT RECACTIVE(DBNUM) THEN LOGOFF;
  GETITEM(DBNUM,2);
  CURRLONG:=CURRLONG+BAL;
  PUTITEM(DBNUM,2);
  IF DBNUM=NlFile THEN
    BEGIN
      GETITEM(DBNUM,22);
      CURRLONG:=CURRLONG+BAL;
      PUTITEM(DBNUM,22);
    END;
  GETITEM(DBNUM,3);
  CURRLONG:=CURRLONG+BAL;
  PUTITEM(DBNUM,3);
  GETITEM(DBNUM,4);
  CURRLONG:=CURRLONG+BAL;
  PUTITEM(DBNUM,4);
  IF Cash1.XNOMWEEK THEN
     BEGIN
       GETITEM(DBNUM,6);
       CURRLONG:=CURRLONG+BAL;
       PUTITEM(DBNUM,6);
     END;
  REWRITEREC(DBNUM,DBAC);
  dberr;
  READREC(DBNUM,CRAC);
  dberr;
  IF NOT RECACTIVE(DBNUM) THEN LOGOFF;
  GETITEM(DBNUM,2);
  CURRLONG:=CURRLONG-BAL;
  PUTITEM(DBNUM,2);
  IF DBNUM=NlFile THEN
     BEGIN
       GETITEM(DBNUM,22);
       CURRLONG:=CURRLONG-BAL;
       PUTITEM(DBNUM,22);
     END;
  GETITEM(DBNUM,3);
  CURRLONG:=CURRLONG-BAL;
  PUTITEM(DBNUM,3);
  GETITEM(DBNUM,4);
  CURRLONG:=CURRLONG-BAL;
  PUTITEM(DBNUM,4);
  IF Cash1.XNOMWEEK THEN
    BEGIN
      GETITEM(DBNUM,6);
      CURRLONG:=CURRLONG-BAL;
      PUTITEM(DBNUM,6);
    END;
  REWRITEREC(DBNUM,CRAC);
  dberr;
END;					       { end lognom }

procedure TSetUpAccounts.CustSuppDeleteClick(Sender: TObject);
begin
     CustSuppAdd.Enabled := True;
     DeleteCustSuppAccount;
end;

procedure TSetUpAccounts.CustSuppSaveClick(Sender: TObject);
begin
     if cash1.xyearend = true then begin
        if messagedlg('You are making changes to an archive set of accounts, are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrno then exit;
     end;
     CustSuppAdd.Enabled := True;
     SaveCustSuppAccount;
     custsuppcancel.enabled := false; // TGM AB 4/06/02
end;

procedure TSetUpAccounts.CustSuppAreaCodeExit(Sender: TObject);
begin
     If NOT Numeric ( SetUpAccounts.CustSuppAreaCode.Text ) Then
        SetUpAccounts.CustSuppAreaCode.SetFocus;
end;

procedure TSetUpAccounts.EntGridClick(Sender: TObject);
Var
   RecToRead : Integer;
begin
     SetUpAccounts.AddAmendDeleteEnt := '';
     SetUpAccounts.AddAmendDelete := '';
     RecToRead := 0;
     If Numeric ( EntGrid.Cells[0, EntGrid.Row]) Then
        RecToRead := StrToInt ( EntGrid.Cells[0, EntGrid.Row]);
     If RecToRead <> 0 Then
        FillEntPanel ( RecToRead );
end;

procedure TSetUpAccounts.EntIncomeGridClick(Sender: TObject);
begin
     // Cancel any unsaved changes
     // CancelEntAccountClick(Sender);
     SetUpAccounts.AddAmendDeleteEnt := '';
     SetUpAccounts.AddAmendDelete := '';
     SetUpAccounts.EntIncomeRadio.Checked := True;
     SetUpAccounts.EntIncomeRadioClick ( Sender );
end;

procedure TSetUpAccounts.EntExpendGridClick(Sender: TObject);
begin
     // Cancel any unsaved changes
     // CancelEntAccountClick(Sender);
     SetUpAccounts.AddAmendDeleteEnt := '';
     SetUpAccounts.AddAmendDelete := '';
     SetUpAccounts.EntExpendRadio.Checked := True;
     SetUpAccounts.EntExpendRadioClick ( Sender );
end;

procedure TSetUpAccounts.EntIncomeRadioClick(Sender: TObject);
Var
   RecToRead : Integer;
begin
     RecToRead := 0;
     If Numeric ( EntIncomeGrid.Cells[0, EntIncomeGrid.Row]) Then
        RecToRead := StrToInt ( EntIncomeGrid.Cells[0, EntIncomeGrid.Row]);
     FillEntAccountPanel ( RecToRead );
     If SetUpAccounts.EntGrid.CanFocus Then
        SetUpAccounts.EntGrid.SetFocus;
end;

procedure TSetUpAccounts.EntExpendRadioClick(Sender: TObject);
Var
   RecToRead : Integer;
begin
     RecToRead := 0;
     If Numeric ( EntExpendGrid.Cells[0, EntExpendGrid.Row]) Then
        RecToRead := StrToInt ( EntExpendGrid.Cells[0, EntExpendGrid.Row]);
     FillEntAccountPanel ( RecToRead );
     If SetUpAccounts.EntGrid.CanFocus Then
        SetUpAccounts.EntGrid.SetFocus;
End;

procedure TSetUpAccounts.DelEnterpriseClick(Sender: TObject);
begin
     DeleteEnterprise;
     AddEnterprise.Enabled := True;     
end;

procedure TSetUpAccounts.SaveEnterpriseClick(Sender: TObject);
begin
     if cash1.xyearend = true then begin
        if messagedlg('You are making changes to an archive set of accounts, are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrno then exit;
     end;
     EntIncomeFrom.enabled:=false;
     EntIncomeTo.enabled:=false;
     EntExpendFrom.enabled:=false;
     EntExpendTo.enabled:=false;
     If EntCheckBeforeSave ( Sender ) Then
        Begin
            SaveEnterpriseAccount;
            AddAmendDeleteEnt    := '';
            AddEnterprise.Enabled := True;
        End;
     cancelenterprise.enabled := false; // TGM AB 4/06/02
end;

procedure TSetUpAccounts.AddEntAccountClick(Sender: TObject);
begin
     AddEntAccount.Enabled := False;
     AddAmendDelete    := 'ADD';
     AddAmendDeleteEnt := '';
     NewEntNominalAccount;
     EntAccountGroupNo.text := EntAccount.text;
     AccsDataModule.NomListOk := FALSE;
     if (AddAmendDelete = 'ADD') then cancelentaccount.Enabled := true;             // TGM AB 31/5/02
     cbProductsEnts.KeyValue := 0;                                                  // TGM AB 06/01/17
end;

procedure TSetUpAccounts.CancelEntAccountClick(Sender: TObject);
begin
     CancelEntNominalAccount;
     AddEntAccount.Enabled := True;
     AccsDataModule.NomListOk := TRUE;
     cancelentaccount.Enabled := false;             // TGM AB 31/5/02
end;

procedure TSetUpAccounts.EntCodeExit(Sender: TObject);
Var
   TStr,
   TestStr : ShortString;
begin
     TestStr := SetUpAccounts.EntCode.Text;
     SlimAll ( TestStr );
     If ( NOT SetUpAccounts.CancelEnterprise.Focused ) Then
        Begin
           If ( Length ( TestStr ) = 0 ) Then
              Begin
                   MessageDlg('Enterprise has no Code', mtInformation, [mbOk], 0);
                   SetUpAccounts.EntCode.SetFocus;
              End
           Else
              If SetUpAccounts.AddAmendDeleteEnt = 'ADD' Then
                 Begin
                      If DuplicatesFound ( TestStr, 0 ) Then
                         Begin
                              MessageDlg('Enterprise Code ' + TestStr + ' already Exists', mtInformation, [mbOk], 0);
                              SetUpAccounts.EntCode.Text := OrigEntCode;
                              SetUpAccounts.EntCode.SetFocus;
                         End
                      Else
                          Begin
                             TStr := EntGrid.Cells[0,EntGrid.Row];
                             SlimAll ( TStr );
                             If Numeric ( TStr ) Then
                                If DuplicatesFound ( TestStr, StrToInt ( TStr )) Then
                                   Begin
                                      MessageDlg('Enterprise Code ' + TestStr + ' already Exists', mtInformation, [mbOk], 0);
                                      SetUpAccounts.EntCode.Text := OrigEntCode;
                                      SetUpAccounts.EntCode.SetFocus;
                                   End;
                          End;
                 End;
        End;
end;

procedure TSetUpAccounts.EntAccountNameExit(Sender: TObject);
Var
   TestStr : ShortString;
begin
     TestStr := SetUpAccounts.EntAccountName.Text;
     SlimAll ( TestStr );
     If ( Length ( TestStr ) = 0 ) And
        ( NOT SetUpAccounts.CancelEntAccount.Focused ) Then
        Begin
             MessageDlg('Accounts has no Name', mtInformation, [mbOk], 0);
             SetUpAccounts.EntAccountName.SetFocus;
        End;
end;

procedure TSetUpAccounts.DeleteEntAccountClick(Sender: TObject);
begin
     DeleteEntNominalAccount;
     If SetUpAccounts.EntIncomeRadio.Checked Then
        SetUpAccounts.EntIncomeGridClick(Sender)
     Else If SetUpAccounts.EntExpendRadio.Checked Then
         SetUpAccounts.EntExpendGridClick(Sender);

     AddEntAccount.Enabled := True;
end;

procedure TSetUpAccounts.NomRadioButtonClick(Sender: TObject);
begin
     if validpassword then Notebook.PageIndex := 0
        else if PasswordPrompt then Notebook.PageIndex := 0;
       {      else begin
                  NomRadiobutton.checked := false;
                  CustSuppRadioButton.checked := true;
                  end;
                  }
end;

procedure TSetUpAccounts.EntRadioButtonClick(Sender: TObject);
begin
     if validpassword then Notebook.PageIndex := 1
        else if PasswordPrompt then Notebook.PageIndex := 1;
           {  else begin
                  EntRadiobutton.checked := false;
                  CustSuppRadioButton.checked := true;
                  end;
                  }
end;

procedure TSetUpAccounts.CustSuppRadioButtonClick(Sender: TObject);
begin
     Notebook.PageIndex := 2;
end;

procedure TSetUpAccounts.NotebookPageChanged(Sender: TObject);
var
   bFarmSyncConfigured : Boolean;
begin
   bFarmSyncConfigured := False;
   case NoteBook.PageIndex Of
      { Nominal Accounts SetUp }
      0 : begin
             SetUpAccounts.Caption := 'Nominal Accounts';{+ ' - ' + st;}
             SetUpAccounts.NomGrid.Cells[0,0] := 'No';
             SetUpAccounts.NomGrid.Cells[1,0] := 'Name';
             SetUpAccounts.NomGrid.Cells[2,0] := 'Ent';
             SetUpAccounts.cDb := NlFile;
             SetDb ( SetUpAccounts.cDb );
             FillNomGrid ( GetAccountRanges );
             lProductsNoms.Enabled := ( not(AccsDataModule.NomProdRelationship = cNomProdRelationship_OnetoOne) );
             cbProductsNoms.Enabled := lProductsNoms.Enabled;
             ClearBtn.Enabled := lProductsNoms.Enabled;
          end;
      { Enterprise SetUp }
      1 : begin
             SetUpAccounts.Caption := 'Enterprise Accounts';{+ ' - ' + st;}
             SetUpAccounts.EntGrid.Cells[0,0] := 'No';
             SetUpAccounts.EntGrid.Cells[1,0] := 'Ent';
             SetUpAccounts.EntGrid.Cells[2,0] := 'Name';
             SetUpAccounts.cDb := EntFile;
             SetDb ( SetUpAccounts.cDb );
             SetUpAccounts.RecNo := LastEnt;
             FillEntGrid;
             SetUpAccounts.EntGrid.SetFocus;
          end;
      { Customers/Suppliers SetUp }
      2 : begin
             SetUpAccounts.Caption := 'Customer/Supplier Accounts';{ + ' - ' + st;}
             SetUpAccounts.CustSuppGrid.Cells[0,0] := 'No';
             SetUpAccounts.CustSuppGrid.Cells[1,0] := 'Name';
             if ( not(cash1.xcashbook) ) then
                SetUpAccounts.CustSuppGrid.Cells[2,0] := 'Balance'
             else
                SetUpAccounts.CustSuppGrid.Cells[2,0] := '';
             if ( SetUpAccounts.Customers.Checked ) Then
                begin
                   SetUpAccounts.cDb := SlFile;
                   SetUpAccounts.RecNo := LastCust;
                end
             else
                 begin
                    SetUpAccounts.cDb := PlFile;
                    SetUpAccounts.RecNo := LastSupp;
                 end;
             SetDb ( SetUpAccounts.cDb );
             FillCustsuppGrid('');
             // TGM AB 12/08/02 - panel covering balances in a cashbook system
             CashbookCoverPanel.visible := cash1.xcashbook;
             SetUpAccounts.CustSuppGrid.SetFocus;
          end;
      { Products SetUp }
      3 : begin
             SetUpAccounts.Caption := 'Products';{ + ' - ' + st;}
             Desc1.Enabled := False;
             Desc2.Enabled := False;
             Desc3.Enabled := False;
             DefaultPrice.Enabled := False;
             DefaultCheckBox.Enabled := False;
             ProductUnitComboBox.Enabled := False;
             SaveProduct.Enabled := False;
             DeleteProduct.Enabled := False;
             CancelProduct.Enabled := False;
             EditProduct.Enabled := True;
             AddProduct.Enabled := ( not(AccsDataModule.NomProdRelationship = cNomProdRelationship_OnetoOne) );
          end;
   end;

   bFarmSyncConfigured := TfmFarmSyncSettings.SyncConfigured(AccsDataModule.CurrentDatabase);
   SetUpAccounts.DelEnterprise.Enabled := ( not(bFarmSyncConfigured) );
   SetUpAccounts.DeleteEntAccount.Enabled := ( not(bFarmSyncConfigured) );
   SetUpAccounts.DelAccount.Enabled := ( not(bFarmSyncConfigured) );
   SetUpAccounts.CustSuppDelete.Enabled := ( not(bFarmSyncConfigured) );
end;

Procedure TSetUpAccounts.SetToLong ( Var StrToChange : TEdit );
Begin
    If IsItLong ( StrToChange.Text, 'L', CurrLong ) Then
       Begin
            LongStr ( CurrLong, CurrStr, 'L' );
            StrToChange.Text := CurrStr;
       End
    Else
        StrToChange.SetFocus;
End;

procedure TSetUpAccounts.CustSuppTurnoverExit(Sender: TObject);
begin
     SetUpAccounts.SetToLong ( SetUpAccounts.CustSuppTurnover );
end;

procedure TSetUpAccounts.CustSuppOpenBalanceExit(Sender: TObject);
begin
     SetUpAccounts.SetToLong ( SetUpAccounts.CustSuppOpenBalance );
end;

procedure TSetUpAccounts.CustSuppAgeCurrExit(Sender: TObject);
begin
     SetUpAccounts.SetToLong ( SetUpAccounts.CustSuppAgeCurr );
end;

procedure TSetUpAccounts.CustSuppAged1Exit(Sender: TObject);
begin
     SetUpAccounts.SetToLong ( SetUpAccounts.CustSuppAged1 );
end;

procedure TSetUpAccounts.CustSuppAged2Exit(Sender: TObject);
begin
     SetUpAccounts.SetToLong ( SetUpAccounts.CustSuppAged2 );
end;

procedure TSetUpAccounts.CustSuppAged3Exit(Sender: TObject);
begin
     SetUpAccounts.SetToLong ( SetUpAccounts.CustSuppAged3 );
end;

procedure TSetUpAccounts.NomBalanceExit(Sender: TObject);
begin
     SetUpAccounts.SetToLong ( SetUpAccounts.NomBalance );
end;

procedure TSetUpAccounts.SaveEntAccountClick(Sender: TObject);
var
   TestStr : Shortstring;
   GroupStr : Shortstring;
   NomTypeStr : char;
   iProductId : Integer;
   dNLProdId : Double;
   iNomID : Integer;
begin
   if ( cash1.xyearend ) then
      if ( MessageDlg('You are making changes to an archive set of accounts, are you sure you want to continue?',
                      mtConfirmation,[mbYes,mbNo],0) = mrNo ) then Exit;

   if ( Setupaccounts.EntNominalTypeDropdown.ItemIndex <> 0 ) then
      begin
         case Setupaccounts.EntNominalTypeDropdown.ItemIndex of
            1 : NomTypeStr := 'L';
            2 : NomTypeStr := 'P';
            3 : NomTypeStr := 'O';
            4 : NomTypeStr := 'U';
         end;
         if ( Length(NomTypeStr) > 0 ) then
            begin
               currdisp[1] := NomTypeStr;
               putitem(NLFile,103);
            end;
      end;

   TestStr := SetUpAccounts.EntAccountName.Text;
   Slimall(TestStr);

   GroupStr := EntAccountGroupDesc.Text;
   SlimAll(GroupStr);
   if ( Length(GroupStr) = 0 ) then
      EntAccountGroupDesc.Text := TestStr;

   iNomID := StrToInt(EntAccount.Text);

   SaveEntNominalAccount;

   //   19/10/18 [V4.3 R2.5] /MK Additional Feature - If adding an income nominal to an enterprise and one-to-one association is enabled
   //                                                 then create a product of the same name as the nominal and link the two together.
   if ( UpperCase(AddAmendDelete) = 'ADD' ) then
      begin
         // Weird reverse logic for Cash11.xBilling - not(Cash11.xBilling) means billing is on - MK.
         if ( not(Cash1.XCASHBOOK) ) and ( not(cash11.xbilling) ) and ( EntIncomeRadio.Checked ) then
            if ( AccsDataModule.NomProdRelationship = cNomProdRelationship_OnetoOne ) then
               try
                  if ( not(AccsDataModule.Products.Active) ) then
                     AccsDataModule.Products.Open;
                  AccsDataModule.Products.Append;
                  AccsDataModule.Products.FieldByName('Desc1').AsString := TestStr;
                  AccsDataModule.Products.FieldByName('UseDefaultPrice').AsBoolean := True;
                  AccsDataModule.Products.Post;

                  iProductId := AccsDataModule.Products.FieldByName('ID').AsInteger;
                  dNLProdId := ( iProductId / 100 );

                  if ( AccsDataModule.NLFileDB.Locate('NLNo',iNomID,[]) ) then
                     begin
                        AccsDataModule.NLFileDB.Edit;
                        AccsDataModule.NLFileDB.FieldByName('STWeek').AsFloat := dNLProdId;
                        AccsDataModule.NLFileDB.Post;
                     end;

                  TfmEditAssocItem.ShowTheForm(iProductId, itProducts);
               except
                  on e : Exception do
                     begin
                        ShowMessage(e.Message);
                        if ( AccsDataModule.Products.State in dsEditModes ) then
                           AccsDataModule.Products.Cancel;
                        if ( AccsDataModule.NLFileDB.State in dsEditModes ) then
                           AccsDataModule.NLFileDB.Cancel;
                     end;
               end;
      end;
   {
   //   25/10/18 - The below code will change the name of the associated product to the nominal name - GL asked that this be removed
   else
      begin
         if ( not(Cash1.XCASHBOOK) ) and ( not(cash11.xbilling) ) and ( EntIncomeRadio.Checked ) then
            if ( AccsDataModule.NomProdRelationship = cNomProdRelationship_OnetoOne ) then
               if ( AccsDataModule.NominalList.Locate('Account',iNomID,[]) ) then
                  begin
                     iProductId := AccsDataModule.NominalList.FieldByName('Product').AsInteger;
                     if ( iProductId > 0 ) then
                        if ( AccsDataModule.Products.Locate('ID',cbProductsEnts.Value,[loCaseInsensitive]) ) then
                           if ( AccsDataModule.Products.FieldByName('Desc1').AsString <> TestStr ) then
                              try
                                 AccsDataModule.Products.Edit;
                                 AccsDataModule.Products.FieldByName('Desc1').AsString := TestStr;
                                 AccsDataModule.Products.Post;
                              except
                                 on e : Exception do
                                    begin
                                       ShowMessage(e.Message);
                                       if ( AccsDataModule.Products.State in dsEditModes ) then
                                          AccsDataModule.Products.Cancel;
                                    end;
                              end;
                  end;
      end;
   }

   AddAmendDelete := '';
   AddAmendDeleteEnt := '';

   AddEntAccount.Enabled := True;
   cancelentaccount.Enabled := false;             // TGM AB 31/5/02
   AccsDataModule.GetAllNominalLedgerAccs;        // TGM AB 06/01/17     re-build the temp lookup listing
   AccsDataModule.NominalList.Close;
   AccsDataModule.NominalList.Open;
   FillEntGrid;                                   // TGM AB 06/01/17     refill the grid
end;

procedure TSetUpAccounts.AddEnterpriseClick(Sender: TObject);
begin
     If ( AddAmendDeleteEnt <> 'ADD' ) Then
        Begin
            AddEnterprise.Enabled := False;
            AddAmendDelete := '';
            AddAmendDeleteEnt := 'ADD';
            NewEnterprise;
        End;
     cancelenterprise.enabled := true; // TGM AB 4/06/02
end;

procedure TSetUpAccounts.CancelEnterpriseClick(Sender: TObject);
begin
     EntIncomeFrom.enabled:=false;
     EntIncomeTo.enabled:=false;
     EntExpendFrom.enabled:=false;
     EntExpendTo.enabled:=false;
     CancelNewEnterprise;
     AddEnterprise.Enabled := True;
     cancelenterprise.enabled := false; // TGM AB 4/06/02  
end;

procedure TSetUpAccounts.NoOfIncomeAccountsExit(Sender: TObject);
Var
   StartRec : Integer;
begin

     If SetUpAccounts.NoOfIncomeAccounts.Modified Then
        Begin
             If Numeric ( SetUpAccounts.NoOfIncomeAccounts.Text ) Then
                Begin
                     If Not CheckAvailability ( StrToInt ( SetUpAccounts.NoOfIncomeAccounts.Text ), 'I', StartRec ) Then
                        SetUpAccounts.NoOfIncomeAccounts.SetFocus
                     Else
                        Begin
                             SetUpAccounts.EntIncomeFrom.Text := IntToStr ( StartRec );
                             SetUpAccounts.EntIncomeTo.Text := IntToStr (( StartRec )+
                                                         StrToInt ( SetUpAccounts.NoOfIncomeAccounts.Text )-1);
                        End;
                End
             Else
                 SetUpAccounts.NoOfIncomeAccounts.SetFocus;
        End;
end;

procedure TSetUpAccounts.NoOfExpendAccountsExit(Sender: TObject);
Var
   StartRec : Integer;
begin
     If SetUpAccounts.NoOfIncomeAccounts.Modified Then
        Begin
             If Numeric ( SetUpAccounts.NoOfExpendAccounts.Text ) Then
                Begin
                     If Not CheckAvailability ( StrToInt ( SetUpAccounts.NoOfExpendAccounts.Text ), 'E', StartRec ) Then
                        SetUpAccounts.NoOfExpendAccounts.SetFocus
                     Else
                        Begin
                             SetUpAccounts.EntExpendFrom.Text := IntToStr ( StartRec );
                             SetUpAccounts.EntExpendTo.Text := IntToStr (( StartRec )+
                                                         StrToInt ( SetUpAccounts.NoOfExpendAccounts.Text )-1);
                        End;
                End
             Else
                 SetUpAccounts.NoOfExpendAccounts.SetFocus;
        End;
end;

Function TSetUpAccounts.EntCheckBeforeSave(Sender: TObject) : Boolean;
Var
   TestNum : LongInt;
   TestStr : ShortString;
Begin
     EntCheckBeforeSave := False;
     TestNum := 0;
     { Test all vital fields before Saving }
     If ( NOT SetUpAccounts.CancelEnterprise.Focused ) Then
        Begin
             TestStr := SetUpAccounts.EntCode.Text;
             SlimAll ( TestStr );
             If ( Length ( TestStr ) = 0 ) Then
                Begin
                     MessageDlg('Enterprise has no Name', mtInformation, [mbOk], 0);
                     SetUpAccounts.EntName.SetFocus;
                End
             Else
                Begin
                     TestStr := SetUpAccounts.NoOfIncomeAccounts.Text;
                     SlimAll ( TestStr );
                     If Numeric ( TestStr ) Then
                        TestNum := StrToInt ( TestStr );
                     If ( TestNum = 0 ) Then
                        Begin
                             MessageDlg('No Of Income Accounts cannot be 0', mtInformation, [mbOk], 0);
                             SetUpAccounts.NoOfIncomeAccounts.SetFocus;
                        End
                     Else
                        Begin
                             TestStr := SetUpAccounts.NoOfExpendAccounts.Text;
                             SlimAll ( TestStr );
                             If Numeric ( TestStr ) Then
                                TestNum := StrToInt ( TestStr );
                             If ( TestNum = 0 ) Then
                                Begin
                                     MessageDlg('No Of Expenditure Accounts cannot be 0', mtInformation, [mbOk], 0);
                                     SetUpAccounts.NoOfExpendAccounts.SetFocus;
                                End
                             Else
                                 EntCheckBeforeSave := True;
                        End;
                End;
        End;
End;

procedure TSetUpAccounts.EntUnitDivExit(Sender: TObject);
begin
     SetUpAccounts.SetToLong ( SetUpAccounts.EntUnitDiv );
end;

procedure TSetUpAccounts.EntAccountGroupNoChange(Sender: TObject);
begin
     ReadTables ( NlFile, KStrToInt ( SetUpAccounts.EntAccountGroupNo.Text ), CurrStr );
     SetUpAccounts.EntAccountGroupDesc.Text := CurrStr;
end;

procedure TSetUpAccounts.EntCodeEnter(Sender: TObject);
begin
     If ( Length ( EntCode.Text ) = 0 ) Then
        AddEnterpriseClick ( Sender );
end;

procedure TSetUpAccounts.NomRepGroupExit(Sender: TObject);
Var
   AccRange : TAccRange;
   TempStr : ShortString;
begin
     TempStr := (Sender as TEdit).Text;
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        Begin
            AccRange := GetAccountRanges;
            TempStr := (Sender as TEdit).Text;
            SlimAll ( TempStr );
            If Numeric ( TempStr ) Then
               If ( StrToInt ( TempStr ) < AccRange[1] ) Or
                  ( StrToInt ( TempStr ) > AccRange[2] ) Then
                  (Sender as TEdit).SetFocus;
        End
     Else
         (Sender as TEdit).SetFocus;
end;

procedure TSetUpAccounts.EntAccountVatNoExit(Sender: TObject);
Var
   ArrPos : Integer;
begin
     If NOT NewListBox.CheckVat ( ( Sender As TEdit).Text, ArrPos ) Then
        ( Sender As TEdit).SetFocus;
end;

procedure TSetUpAccounts.RadioCheck(Sender: TObject);
begin
     If (Sender AS TRadiobutton).Name = 'ControlAccounts' Then
         begin
              NomVATCode.Enabled := False;
              ListVATCodes.Enabled := False;
              ListVATCodes.visible := False;
              NomVATCode.visible := False;
              LabelNomVATCode.visible := False;
         end
     Else
         Begin
              NomVATCode.Enabled := True;
              ListVATCodes.Enabled := True;
              ListVATCodes.visible := True;
              NomVATCode.visible := True;
              LabelNomVATCode.visible := True;
         end;

   sbBankFileFormat.Visible := (Sender AS TRadiobutton).Name = 'Banks';
end;
procedure TSetUpAccounts.SetUpExitClick(Sender: TObject);
begin
     AddEnterprise.Enabled := True; //Enterprise
     AddEntAccount.Enabled := True; //Enterprise
     AddAccount.Enabled := True;    //Nominal
     CustSuppAdd.Enabled := True;   //Customers / Suppliers

end;

procedure TSetUpAccounts.EntAccountGroupNoDblClick(Sender: TObject);
begin
     SetUpAccounts.ListGroupsClick(Sender);
end;

procedure TSetUpAccounts.EntAccountVatNoDblClick(Sender: TObject);
begin
     SetUpAccounts.ListVATCodesClick(Sender);
end;

procedure TSetUpAccounts.HelpEnterpriseClick(Sender: TObject);
begin
     Application.HelpContext(226);
end;

procedure TSetUpAccounts.HelpEntAccountClick(Sender: TObject);
begin
     Application.HelpContext(8);
end;

procedure TSetUpAccounts.BitBtn4Click(Sender: TObject);
begin
     Application.HelpContext(227);
end;

procedure TSetUpAccounts.bBudgetsClick(Sender: TObject);
begin
    TfmBudgets.ShowBudget;
end;

procedure TSetUpAccounts.bReportClick(Sender: TObject);
begin
     // Set the Nominal Report Form
     if EntRadioButton.Checked then
        begin
           SetupReport(rpSetupEnterprise);
           PROG := SpecRep;
           NewRepForm.DataBase := NlFile;
           NominalReportForm.SetNominalReportForm(EntStructure);
           NominalReportForm.ShowModal;
        end
     else if NomRadioButton.Checked then
        begin
           SetupReport(rpSetupNominal);
           PROG := SpecRep;
           NewRepForm.DataBase := NlFile;
           NominalReportForm.SetNominalReportForm(NomsOrGroups);
           NominalReportForm.ShowModal;
        end
     else if CustSuppRadioButton.Checked then
        begin
           SetupReport(rpSetupCustomer);
           if Customers.Checked then
              begin
                PROG := CustRep;
                NewRepForm.DataBase := SLFile;
                CustSuppListing.RepType := Customer;
              end
           else
              begin
                 PROG := SUPPrep;
                 NewRepForm.DataBase := PLFile;
                 CustSuppListing.RepType := Supplier;
              end;
           Act := 1;
           CustSuppListing.Caption := 'Account Listing';
           CustSuppListing.ShowModal;
        end;
end;

procedure TSetUpAccounts.cbProductsEntsCloseUp(Sender: TObject);
begin
    if (Sender is TRXDBLookUpCombo) then
       if (Sender as TRXDBLookUpCombo).Value = '0' then
          fSetUpProducts.ShowModal;
end;

procedure TSetUpAccounts.EntIncomeFromDblClick(Sender: TObject);
begin
     EntIncomeFrom.enabled:=true;
end;

procedure TSetUpAccounts.EntIncomeToDblClick(Sender: TObject);
begin
     EntIncomeTo.enabled:=true;
end;

procedure TSetUpAccounts.EntExpendFromDblClick(Sender: TObject);
begin
     EntExpendFrom.enabled:=true;
end;

procedure TSetUpAccounts.EntExpendToDblClick(Sender: TObject);
begin
       EntExpendTo.enabled:=true;
end;

procedure TSetUpAccounts.NoOfIncomeAccountsDblClick(Sender: TObject);
begin
     EntIncomeFrom.enabled:=true;
     EntIncomeTo.enabled:=true;

end;

procedure TSetUpAccounts.NoOfExpendAccountsDblClick(Sender: TObject);
begin
     EntExpendFrom.enabled:=true;
     EntExpendTo.enabled:=true;

end;

procedure TSetUpAccounts.EntAccountChange(Sender: TObject);
begin
     // tgm 26/02/02 - attempted by making this box enabled, to allow user to manually set code number
     // need to follow back through code howver and change a number of other variables.  gave up
//     EntAccount.Enabled:=true;
//     EntAccount.ReadOnly:=false;
end;

Function TSetUpAccounts.PasswordPrompt: boolean;
var
  InputString: string;
begin
  {  result := false;
    InputString:= InputBox('Please Enter The Password', 'Please Enter The Password', '');
    if lowercase(Inputstring) = 'config' then begin
       result := true;
       validpassword := true;
    end
       else Showmessage('Invalid Password!');
    }
    // TGM AB Password routine removed to be only a warning left routine if ever needed in future
    validpassword := true;
    result := true;
    showmessage('Do not modify Nominal Ledger Codes without getting advice from your Accountant or Kingswood Personnel');

end;

procedure TSetUpAccounts.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   ValidPassword := False;
   Accsdatamodule.Products.Filtered := False;
   Accsdatamodule.Products.Filter := '';
   if ( UpperCase(AddAmendDeleteEnt) = 'ADD' ) then // TGM AB 14/04/17
      CancelEnterpriseClick(self);
end;

procedure TSetUpAccounts.Deprec_editChange(Sender: TObject);
begin
     try if strtofloat(deprec_edit.Text) > 100.00 then begin
                               showmessage('Depreciation rate cannot exceed 100%');
                               deprec_edit.text := '100.00';
                               end;
     except
     end;
end;

procedure TSetUpAccounts.EnterpriseReportClick(Sender: TObject);
begin
           SetupReport(rpSetupEnterprise);
           PROG := SpecRep;
           NewRepForm.DataBase := NlFile;
           NominalReportForm.SetNominalReportForm(EntStructure);
           NominalReportForm.ShowModal;
end;

procedure TSetUpAccounts.NominalAccounts1Click(Sender: TObject);
begin
           SetupReport(rpSetupNominal);
           PROG := SpecRep;
           NewRepForm.DataBase := NlFile;
           NominalReportForm.SetNominalReportForm(NomsOrGroups);
           NominalReportForm.ShowModal;
end;

procedure TSetUpAccounts.Customers1Click(Sender: TObject);
begin
           SetupReport(rpSetupCustomer);
           PROG := CustRep;
           NewRepForm.DataBase := SLFile;
           CustSuppListing.RepType := Customer;
           Act := 1;
           CustSuppListing.Caption := 'Customer Account Listing';
           CustSuppListing.ShowModal;
end;

procedure TSetUpAccounts.Suppliers1Click(Sender: TObject);
begin
           SetupReport(rpSetupCustomer);
           PROG := SUPPrep;
           NewRepForm.DataBase := PLFile;
           CustSuppListing.RepType := Supplier;
           Act := 1;
           CustSuppListing.Caption := 'Supplier Account Listing';
           CustSuppListing.ShowModal;
end;

procedure TSetUpAccounts.SearchBoxChange(Sender: TObject);
begin
 Case NoteBook.PageIndex Of
          2 : Begin { Customers/Suppliers SetUp }
                   If SetUpAccounts.Customers.Checked Then
                      Begin
                           SetUpAccounts.cDb := SlFile;
                           SetUpAccounts.RecNo := LastCust;
                      End
                   Else
                       Begin
                            SetUpAccounts.cDb := PlFile;
                            SetUpAccounts.RecNo := LastSupp;
                       End;
                   SetDb ( SetUpAccounts.cDb );
                   FillCustsuppGrid(Searchbox.text);
                   // TGM AB 12/08/02 - panel covering balances in a cashbook system
                   if cash1.xcashbook then CashbookCoverPanel.visible := true
                      else CashbookCoverPanel.visible := false;
                   SearchBox.setfocus;



          end;
 end;

end;

procedure TSetUpAccounts.ClearBtnClick(Sender: TObject);
begin
     cbProductsNoms.KeyValue := 0;
end;

procedure TSetUpAccounts.Deprec_editExit(Sender: TObject);
var
   teststr : string;
   tempfloat : real;
begin

     try if strtofloat(deprec_edit.text) <> 0.00 then begin
        teststr := deprec_edit2.text;
        tempfloat := 0.00;
        try tempfloat := strtofloat (teststr);
        except
        end;
        if tempfloat <> 0.00 then begin
                               showmessage('You can set either the percentage rate or a fixed rate depreciation but not both.' + #10#13 + 'If you want to set a rate, then change the fixed amount to 0.00');
                               deprec_edit.text := '0.00';
                               end;
        end;
     except showmessage('Depreciation Rate must be a percentage value');
            Deprec_edit.text := '0.00';
     end;
end;

procedure TSetUpAccounts.Deprec_edit2Exit(Sender: TObject);
var
   teststr : string;
   tempfloat : real;
begin
     try if strtofloat(deprec_edit2.text) <> 0.00 then begin
        teststr := deprec_edit.text;
        tempfloat := 0.00;
        try tempfloat := strtofloat (teststr);
        except
        end;
        if tempfloat <> 0.00 then begin
                               showmessage('You can set either the percentage rate or a fixed rate depreciation but not both.' + #10#13 + 'If you want to set a fixed amount, then change the rate to 0.00');
                               deprec_edit2.text := '0.00';
                               end;
        end;
     except showmessage('Depreciation Amount must be a numeric value');
            Deprec_edit2.text := '0.00';
     end;
end;

procedure TSetUpAccounts.ProductsRadioButtonClick(Sender: TObject);
begin
        Notebook.PageIndex := 3;
end;

procedure TSetUpAccounts.EditProductClick(Sender: TObject);
begin
   AccsDataModule.Products.Edit;
   Desc1.Enabled := True;
   Desc2.Enabled := True;
   Desc3.Enabled := True;
   DefaultPrice.Enabled := True;
   DefaultCheckBox.Enabled := True;
   ProductUnitComboBox.Enabled := True;
   SaveProduct.Enabled := True;
   DeleteProduct.Enabled := ( not(AccsDataModule.NomProdRelationship = cNomProdRelationship_OnetoOne) );
   CancelProduct.Enabled := True;
   EditProduct.Enabled := False;
   AddProduct.Enabled := False;
end;

procedure TSetUpAccounts.CancelProductClick(Sender: TObject);
begin
   AccsDataModule.Products.cancel;
   Desc1.Enabled := False;
   Desc2.Enabled := False;
   Desc3.Enabled := False;
   DefaultPrice.Enabled := False;
   DefaultCheckBox.Enabled := False;
   ProductUnitComboBox.Enabled := False;
   SaveProduct.Enabled := False;
   DeleteProduct.Enabled := ( not(AccsDataModule.NomProdRelationship = cNomProdRelationship_OnetoOne) );
   CancelProduct.Enabled := False;
   EditProduct.Enabled := True;
   AddProduct.Enabled := ( not(AccsDataModule.NomProdRelationship = cNomProdRelationship_OnetoOne) );
end;

procedure TSetUpAccounts.AddProductClick(Sender: TObject);
begin
   AccsDataModule.Products.append;
   AccsDataModule.Products['UseDefaultPrice'] := True;
   Desc1.Enabled := True;
   Desc2.Enabled := True;
   Desc3.Enabled := True;
   DefaultPrice.Enabled := True;
   DefaultCheckBox.Enabled := True;
   ProductUnitComboBox.Enabled := True;
   SaveProduct.Enabled := True;
   DeleteProduct.Enabled := false;
   CancelProduct.Enabled := True;
   EditProduct.Enabled := False;
   AddProduct.Enabled := False;
end;

procedure TSetUpAccounts.DeleteProductClick(Sender: TObject);
begin
   AccsDataModule.Products.delete;
   Desc1.Enabled := False;
   Desc2.Enabled := False;
   Desc3.Enabled := False;
   DefaultPrice.Enabled := False;
   DefaultCheckBox.Enabled := False;
   ProductUnitComboBox.Enabled := False;
   SaveProduct.Enabled := False;
   DeleteProduct.Enabled := False;
   CancelProduct.Enabled := False;
   EditProduct.Enabled := True;
   AddProduct.Enabled := ( not(AccsDataModule.NomProdRelationship = cNomProdRelationship_OnetoOne) );
end;

procedure TSetUpAccounts.SaveProductClick(Sender: TObject);
begin
   AccsDataModule.Products.post;
   Desc1.Enabled := False;
   Desc2.Enabled := False;
   Desc3.Enabled := False;
   DefaultPrice.Enabled := False;
   DefaultCheckBox.Enabled := False;
   ProductUnitComboBox.Enabled := False;
   SaveProduct.Enabled := False;
   DeleteProduct.Enabled := False;
   CancelProduct.Enabled := False;
   EditProduct.Enabled := True;
   AddProduct.Enabled := ( not(AccsDataModule.NomProdRelationship = cNomProdRelationship_OnetoOne) );
end;

procedure TSetUpAccounts.ProductListing1Click(Sender: TObject);
begin
    // TGM AB Product Listing Report

    Accsdatamodule.Products.Filtered := false;
    Accsdatamodule.Products.Filter := '';

    if not bool(ProductListingReport) then Application.CreateForm(TProductListingReport, ProductListingReport);
    ProductListingReport.RunReport;

end;

procedure TSetUpAccounts.ProductSearchChange(Sender: TObject);
begin
         Accsdatamodule.Products.Filtered := false;
         Accsdatamodule.Products.Filter := '';
         if ProductSearch.text <> '' then begin
            //    Accsdatamodule.Products.Filter := 'Desc1 LIKE ' + QuotedStr('%' + ProductSearch.text + '%');
                // 'Title LIKE '+ QuotedStr('%' + EditSearch.Text + '%');
                Accsdatamodule.Products.Filter := 'Desc1 = ''' + ProductSearch.text + '*''';
                Accsdatamodule.Products.Filtered := true;
         end;
end;

procedure TSetUpAccounts.sbBankFileFormatClick(Sender: TObject);
var
   BankAccount : TBankAccount;
   SelectedFormat : Integer;
begin
   BankAccount := AccsDataModule.Accounts.BankAccounts.GetBankAccount(NomName.Text);
   if (BankAccount = nil) then
      begin
         BankAccount := TBankAccount.Create;
         BankAccount.Id := StrToInt(NomCode.Text);
         BankAccount.Name := NomName.Text;
      end;

   SelectedFormat := TfmBankFileFormatSelector.ShowSelector(BankAccount.Name, BankAccount.BankFileFormat);
   if (SelectedFormat <= 0) then
      begin
         Exit;
      end;
   BankAccount.BankFileFormat := SelectedFormat;
   AccsDataModule.UpdateBankDetails(BankAccount);
end;

procedure TSetUpAccounts.FormShow(Sender: TObject);
begin
   if Preferences.ValueAsBoolean[cPref_AllowNominalLedgerAccess] then
      begin
         NomRadioButton.Enabled := True;
         EntRadioButton.Enabled := True;
      end
   else
      begin
         NomRadioButton.Enabled := False;
         EntRadioButton.Enabled := False;
      end;
end;

procedure TSetUpAccounts.ClearBtn2Click(Sender: TObject);
begin
  cbProductsEnts.KeyValue := 0;
end;

procedure TSetUpAccounts.ProductsGridEnter(Sender: TObject);
begin
   DeleteProduct.Enabled := ( not(AccsDataModule.NomProdRelationship = cNomProdRelationship_OnetoOne) );
end;

procedure TSetUpAccounts.NominalAccountsEnter(Sender: TObject);
begin
   AccsDataModule.Products.Close;
   AccsDataModule.Products.Open;
end;

end.
