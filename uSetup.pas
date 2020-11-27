unit uSetup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uBaseForm, ActnList, dxBar, dxBarExtItems, cxControls, dxStatusBar,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLabel, cxContainer, cxEdit,
  cxGroupBox, cxGridCustomTableView, cxGridTableView, cxGridCustomView,
  cxClasses, cxGridLevel, cxGrid, cxPC, cxButtons, StdCtrls, RxLookup,
  Buttons, ExtCtrls, cxButtonEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, Types, cxRadioGroup, Menus, cxFilter,db,
  dbTables, cxSplitter;

type
  TAccountType = (accNominal, accEnterprise, accCustomerSupplier, accNone);
  TfmAccountSetup = class(TBaseForm)
    blbBudgets: TdxBarLargeButton;
    blbReports: TdxBarLargeButton;
    actBudgets: TAction;
    actReports: TAction;
    PageControl: TcxPageControl;
    tsNominalAccounts: TcxTabSheet;
    tsEnterprises: TcxTabSheet;
    tsCustomerSupplier: TcxTabSheet;
    gbNominalAccounts: TcxGroupBox;
    cxLabel1: TcxLabel;
    cmboNominalAccountTypes: TcxComboBox;
    Bevel1: TBevel;
    cxLabel2: TcxLabel;
    Bevel2: TBevel;
    LabelNomCode: TLabel;
    LabelNomName: TLabel;
    LabelNomBalance: TLabel;
    LabelNomReportGroup: TLabel;
    LabelNomVatCode: TLabel;
    LabelNomGroupDesc: TLabel;
    lProductsNoms: TLabel;
    Depreclabel: TLabel;
    TypeLabel: TLabel;
    depreclabel2: TLabel;
    NomRepGroup: TcxButtonEdit;
    NomVatCode: TcxButtonEdit;
    NomBalance: TcxTextEdit;
    NomName: TcxTextEdit;
    NomCode: TcxTextEdit;
    NomGroupDesc: TcxTextEdit;
    ShowOpening: TRadioButton;
    ShowCurrent: TRadioButton;
    NomEntCode: TcxTextEdit;
    Deprec_edit: TcxTextEdit;
    Deprec_edit2: TcxTextEdit;
    btnNomAccHelp: TcxButton;
    btnNomAccSave: TcxButton;
    btnNomAccDelete: TcxButton;
    btnNomAccAdd: TcxButton;
    btnNomAccCancel: TcxButton;
    actVATCodeSelect: TAction;
    actReportGroupSelect: TAction;
    cbProductsNoms: TcxDBLookupComboBox;
    btnClearProduct: TcxButton;
    actClearProduct: TAction;
    NominalTypeDropdown: TcxComboBox;
    actNomAccHelp: TAction;
    actNomAccSave: TAction;
    actNomAccAdd: TAction;
    actNomAccDelete: TAction;
    actNomAccCancel: TAction;
    NomAccsGrid: TcxGrid;
    NomAccsGridTableView: TcxGridTableView;
    NomAccsGridTableViewNo: TcxGridColumn;
    NomAccsGridTableViewName: TcxGridColumn;
    NomAccsGridTableViewEnt: TcxGridColumn;
    NomAccsGridLevel: TcxGridLevel;
    gbCustomersSuppliers: TcxGroupBox;
    Bevel3: TBevel;
    cxLabel3: TcxLabel;
    btnCustSuppHelp: TcxButton;
    btnCustSuppSave: TcxButton;
    btnCustSuppDelete: TcxButton;
    btnCustSuppAdd: TcxButton;
    btnCustSuppCancel: TcxButton;
    CustomerSupplierGrid: TcxGrid;
    CustomerSupplierGridTableView: TcxGridTableView;
    CustomerSupplierGridLevel: TcxGridLevel;
    actCustSuppHelp: TAction;
    actCustSuppSave: TAction;
    actCustSuppDelete: TAction;
    actCustSuppAdd: TAction;
    actCustSuppCancel: TAction;
    rgCustomerSupplier: TcxRadioGroup;
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
    LabelCustSuppAreaCode: TLabel;
    CustSuppNo: TcxTextEdit;
    CustSuppName: TcxTextEdit;
    CustSuppAdd2: TcxTextEdit;
    CustSuppAdd3: TcxTextEdit;
    CustSuppPostCode: TcxTextEdit;
    CustSuppFaxNo: TcxTextEdit;
    CustSuppAdd1: TcxTextEdit;
    CustSuppAdd4: TcxTextEdit;
    CustSuppVATNo: TcxTextEdit;
    CustSuppPhone2: TcxTextEdit;
    CustSuppPhone1: TcxTextEdit;
    CustSuppContact1: TcxTextEdit;
    CustSuppContact2: TcxTextEdit;
    CustSuppRefCode: TcxTextEdit;
    CustSuppComment: TcxTextEdit;
    CustSuppAreaCode: TcxTextEdit;
    pCustSuppCashbook: TPanel;
    LabelcustSuppTurnover: TLabel;
    LabelCustSuppBalance: TLabel;
    LabelCustSuppAgeCurr: TLabel;
    LabelCustSuppAged1: TLabel;
    LabelCustSuppAged2: TLabel;
    LabelCustSuppAged3: TLabel;
    CustSuppTurnover: TcxTextEdit;
    CustSuppOpenBalance: TcxTextEdit;
    CustSuppAged1: TcxTextEdit;
    CustSuppAged2: TcxTextEdit;
    CustSuppAged3: TcxTextEdit;
    CustSuppAgeCurr: TcxTextEdit;
    bpmReports: TdxBarPopupMenu;
    actRptNominalAccounts: TAction;
    actRptEnterprises: TAction;
    actRptCustomerListing: TAction;
    actRptSupplierListing: TAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    CustomerSupplierGridTableViewNo: TcxGridColumn;
    CustomerSupplierGridTableViewName: TcxGridColumn;
    CustomerSupplierGridTableViewBalance: TcxGridColumn;
    SearchBox: TcxTextEdit;
    cxLabel4: TcxLabel;
    cxGroupBox1: TcxGroupBox;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton4: TcxButton;
    btnEntAccountCancel: TcxButton;
    Panel1: TPanel;
    EntGrid: TcxGrid;
    EntGridTableView: TcxGridTableView;
    EntGridTableViewNo: TcxGridColumn;
    EntGridTableViewEnt: TcxGridColumn;
    EntGridTableViewName: TcxGridColumn;
    EntGridLevel: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    Panel2: TPanel;
    EntIncomeGrid: TcxGrid;
    EntIncomeGridTableView: TcxGridTableView;
    EntIncomeGridTableViewNo: TcxGridColumn;
    EntIncomeGridTableViewName: TcxGridColumn;
    EntIncomeGridLevel: TcxGridLevel;
    cxSplitter2: TcxSplitter;
    Bevel4: TBevel;
    cxLabel7: TcxLabel;
    LabelEntCode: TLabel;
    LabelEntUnitdiv: TLabel;
    LabelEntName: TLabel;
    LabelEntUnitName: TLabel;
    LabelEntIncomeRange: TLabel;
    LabelEntExpendRange1: TLabel;
    LabelEntPercOverheads: TLabel;
    EntCode: TcxTextEdit;
    EntName: TcxTextEdit;
    EntUnitDiv: TcxTextEdit;
    EntUnitName: TcxTextEdit;
    EntIncomeFrom: TcxTextEdit;
    EntIncomeTo: TcxTextEdit;
    EntExpendFrom: TcxTextEdit;
    EntExpendTo: TcxTextEdit;
    EntPercOverheads: TcxTextEdit;
    NoOfIncomeAccounts: TcxTextEdit;
    NoOfExpendAccounts: TcxTextEdit;
    cxLabel8: TcxLabel;
    Bevel5: TBevel;
    rgEnterpriseType: TcxRadioGroup;
    LabelEntAccount: TLabel;
    LabelEntAccountName: TLabel;
    LabelEntAccountVatNo: TLabel;
    LabelEntAccountRepGroup: TLabel;
    LabelEntAccountGroupDesc: TLabel;
    lProductsEnts: TLabel;
    EntTypeLabel: TLabel;
    EntAccountGroupNo: TcxButtonEdit;
    EntAccountName: TcxTextEdit;
    EntAccountVatNo: TcxButtonEdit;
    EntAccount: TcxTextEdit;
    EntAccountGroupDesc: TcxTextEdit;
    EntNominalTypeDropdown: TcxComboBox;
    cbProductsEnts: TcxDBLookupComboBox;
    btnEntHelp: TcxButton;
    btnEntSave: TcxButton;
    btnEntDelete: TcxButton;
    btnEntAdd: TcxButton;
    btnEntCancel: TcxButton;
    actEntAdd: TAction;
    actEntHelp: TAction;
    actEntDelete: TAction;
    actEntSave: TAction;
    actEntCancel: TAction;
    EntExpendGrid: TcxGrid;
    EntExpendGridTableView: TcxGridTableView;
    EntExpendGridTableViewNo: TcxGridColumn;
    EntExpendGridTableViewName: TcxGridColumn;
    EntExpendGridLevel: TcxGridLevel;
    Panel3: TPanel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    actEntAccountHelp: TAction;
    actEntAccountSave: TAction;
    actEntAccountDelete: TAction;
    actEntAccountAdd: TAction;
    actEntAccountCancel: TAction;
    actCurrentOpeningBalance: TAction;
    procedure Deprec_editExit(Sender: TObject);
    procedure Deprec_edit2Exit(Sender: TObject);
    procedure NomNameExit(Sender: TObject);
    procedure NomVatCodeDblClick(Sender: TObject);
    procedure NomVatCodeExit(Sender: TObject);
    procedure NomVatCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Deprec_editPropertiesChange(Sender: TObject);
    procedure NomVatCodePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure actVATCodeSelectExecute(Sender: TObject);
    procedure NomBalancePropertiesChange(Sender: TObject);
    procedure NomRepGroupPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure NomRepGroupPropertiesChange(Sender: TObject);
    procedure actReportGroupSelectExecute(Sender: TObject);
    procedure NomRepGroupExit(Sender: TObject);
    procedure NomRepGroupKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actClearProductExecute(Sender: TObject);
    procedure actNomAccHelpExecute(Sender: TObject);
    procedure actNomAccSaveExecute(Sender: TObject);
    procedure actNomAccDeleteExecute(Sender: TObject);
    procedure actNomAccAddExecute(Sender: TObject);
    procedure actNomAccCancelExecute(Sender: TObject);
    procedure cmboNominalAccountTypesPropertiesChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actRptNominalAccountsExecute(Sender: TObject);
    procedure actRptCustomerListingExecute(Sender: TObject);
    procedure actRptSupplierListingExecute(Sender: TObject);
    procedure actRptEnterprisesExecute(Sender: TObject);
    procedure gbCustomersSuppliersEnter(Sender: TObject);
    procedure CustSuppAreaCodeExit(Sender: TObject);
    procedure CustSuppTurnoverExit(Sender: TObject);
    procedure CustSuppOpenBalanceExit(Sender: TObject);
    procedure CustSuppAgeCurrExit(Sender: TObject);
    procedure CustSuppAged1Exit(Sender: TObject);
    procedure CustSuppAged2Exit(Sender: TObject);
    procedure CustSuppAged3Exit(Sender: TObject);
    procedure NomBalanceExit(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure SearchBoxPropertiesChange(Sender: TObject);
    procedure rgCustomerSupplierPropertiesChange(Sender: TObject);
    procedure CustomerSupplierGridTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure actHelpExecute(Sender: TObject);
    procedure NomAccsGridTableViewNoGetDisplayText(
      Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
      var AText: String);
    procedure NomAccsGridTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure actCustSuppHelpExecute(Sender: TObject);
    procedure actCustSuppSaveExecute(Sender: TObject);
    procedure actCustSuppDeleteExecute(Sender: TObject);
    procedure actCustSuppAddExecute(Sender: TObject);
    procedure actCustSuppCancelExecute(Sender: TObject);
    procedure actBudgetsExecute(Sender: TObject);
    procedure blbReportsClick(Sender: TObject);
    procedure PageControlPageChanging(Sender: TObject;
      NewPage: TcxTabSheet; var AllowChange: Boolean);
    procedure EntIncomeGridTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure EntExpendGridTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure EntGridTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure actEntHelpExecute(Sender: TObject);
    procedure actEntSaveExecute(Sender: TObject);
    procedure actEntDeleteExecute(Sender: TObject);
    procedure actEntAddExecute(Sender: TObject);
    procedure actEntCancelExecute(Sender: TObject);
    procedure actEntAccountHelpExecute(Sender: TObject);
    procedure actEntAccountSaveExecute(Sender: TObject);
    procedure actEntAccountDeleteExecute(Sender: TObject);
    procedure EntCodeEnter(Sender: TObject);
    procedure EntCodeExit(Sender: TObject);
    procedure EntUnitDivExit(Sender: TObject);
    procedure NoOfIncomeAccountsDblClick(Sender: TObject);
    procedure NoOfIncomeAccountsExit(Sender: TObject);
    procedure EntIncomeFromDblClick(Sender: TObject);
    procedure EntIncomeToDblClick(Sender: TObject);
    procedure NoOfExpendAccountsDblClick(Sender: TObject);
    procedure NoOfExpendAccountsExit(Sender: TObject);
    procedure EntExpendFromDblClick(Sender: TObject);
    procedure EntExpendToDblClick(Sender: TObject);
    procedure EntAccountGroupNoPropertiesChange(Sender: TObject);
    procedure EntAccountGroupNoDblClick(Sender: TObject);
    procedure EntAccountVatNoDblClick(Sender: TObject);
    procedure EntAccountGroupNoPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EntAccountVatNoPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EntAccountNameExit(Sender: TObject);
    procedure actEntAccountAddExecute(Sender: TObject);
    procedure actEntAccountCancelExecute(Sender: TObject);
    procedure EntAccountVatNoExit(Sender: TObject);
    procedure ShowCurrentClick(Sender: TObject);
    procedure ShowOpeningClick(Sender: TObject);
    procedure actCurrentOpeningBalanceExecute(Sender: TObject);
    procedure EntIncomeGridEnter(Sender: TObject);
    procedure EntExpendGridEnter(Sender: TObject);
  private
    function GetNominalAccountNo: Integer;
    function GetCustomerSupplierNo: Integer;
    function GetCustomerSupplierName: string;
    function GetEnterpriseAccountNo: Integer;
    function GetEnterpriseAccountName: string;
    function GetEnterpriseAccountCode: string;
  private
    { Private declarations }
    teststr : string;
    tempfloat : real;

    FAccountType : TAccountType;
    FFormShowing : Boolean;

    NominalWasBalance : Long;
    CustomerSupplierWasBalance : Long;
    procedure SetToLong ( var StrToChange : TcxTextEdit );
    procedure SetupDBControls;
    function PasswordPrompt: boolean;

    { Nominal Proc's }
    procedure LoadNominalAccount(const AAcountDescription : string);
    procedure ChangeNominalAccountType(const AAcountDescription : string);
    procedure CheckNominalAccountType(AccountToCheck : Integer; var CLong : Long );
    procedure FillNominalGrid ( AccRange : TAccRange );
    procedure ClearNominalPanel;
    procedure FillNominalPanel( RecToRead : Integer );
    procedure AddNominalAccount;
    procedure SaveNominalAccount;
    procedure CancelNominalAccount;
    procedure DeleteNominalAccount;
    function NominalAccountRanges : TAccRange;

    { Customer/Supplier Proc's}
    procedure FillCustomerSupplierGrid(const ASearchText : string='');
    procedure FillCustomerSupplierPanel( RecToRead : Integer );
    procedure SearchCustomerSupplier(const ASearchText : string='');
    procedure AddCustomerSupplierAccount;
    procedure SaveCustomerSupplierAccount;
    procedure CancelCustomerSupplierAccount;
    procedure DeleteCustomerSupplierAccount;

    { Enterprise Proc's}
    procedure FillEnterpriseGrid;
    procedure FillEnterprisePanel(RecToRead : Integer);
    procedure FillEnterpriseAccountPanel(RecToRead : Integer );
    procedure ClearEnterpriseAccountPanel;
    procedure FillEnterpriseNomGrids(IncFrom, IncTo, ExpFrom, ExpTo : Integer);
    function EntCheckBeforeSave(Sender: TObject) : Boolean;
    procedure SaveEnterpriseAccount;
    procedure DeleteEnterprise;
    procedure AddEnterpriseAccount;
    procedure CancelEnterprise;
    procedure CancelNewEnterpriseAccount;
    function  GetEnterpriseAccountRanges : TAccRange;


    procedure SaveEnterpriseNominalAccount;
    procedure DeleteEnterpriseNominalAccount;
    procedure CancelEnterpriseNominalAccount;
    procedure AddEnterpriseNominalAccount;

    function CheckForDelete(AccFrom, AccTo : Integer; var DelFlag : Boolean) : Boolean;
    procedure DeleteNomRecords ( AccFrom, AccTo : Integer; IncOrExp : Char );
    function DuplicatesFound ( TestStr : String; CurrRecNo : Integer ) : Boolean;
    function GroupInUse ( Cdb, CGroup, rfrom, rto : Integer ) : Boolean;
    function CheckAvailability( NoRequested : Integer; AccountType : Char;
        var StartRec : Integer ) : Boolean;


    procedure LoadScreenData;
    procedure MyFocusControl(Control: TWinControl);

    procedure LogNom (DBNUM,DBAC,CRAC: INTEGER; BAL: LONG);

    function CheckAgedBalance : Boolean;

    property NominalAccountNo : Integer read GetNominalAccountNo;
    property CustomerSupplierNo : Integer read GetCustomerSupplierNo;
    property CustomerSupplierName : string read GetCustomerSupplierName;
    property EnterpriseAccountNo : Integer read GetEnterpriseAccountNo;
    property EnterpriseAccountName : string read GetEnterpriseAccountName;
    property EnterpriseAccountCode : string read GetEnterpriseAccountCode;
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
    cDb : Integer;
    OrigEntCode : ShortString{[4]};
    class procedure SetupAccounts(const AAccountType : TAccountType = accNone);
  end;

var
  fmAccountSetup: TfmAccountSetup;
  LastCust,
  LastSupp,
  LastNom,
  LastEnt  : Integer;
  ValidPassword : Boolean;  // TGM AB remembers if a valid setup password has been entered
  NoActiveTransactions : Boolean;

implementation

uses
    AccsData,
    LangUnit,
    Calcs,
    DBCore,
    DBGen,
    Util,
    Vars,
    Clears,
    MainUnit,
    NewListing,
    NomRpt,
    NewRepUnit,
    RcsList,
    uBudgets,
    uSetUpProducts,
    ReportDefs,
    AccsUtils;

{$R *.DFM}

procedure TfmAccountSetup.Deprec_editExit(Sender: TObject);
begin
  inherited;
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

procedure TfmAccountSetup.Deprec_edit2Exit(Sender: TObject);
begin
  inherited;
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

procedure TfmAccountSetup.NomNameExit(Sender: TObject);
Var
   GroupStr,
   TestStr : ShortString;
begin
  inherited;
  TestStr := NomName.Text;
  SlimAll ( TestStr );
  If ( Length ( TestStr ) = 0 ) And
     ( NOT btnNomAccCancel.Focused ) Then
     Begin
          MessageDlg('Accounts has no Name', mtInformation, [mbOk], 0);
          MyFocusControl(NomName);
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

procedure TfmAccountSetup.NomVatCodeDblClick(Sender: TObject);
begin
  inherited;
  actVATCodeSelect.Execute;
end;

procedure TfmAccountSetup.NomVatCodeExit(Sender: TObject);
var
   ArrPos : Integer;
begin
   inherited;

   if ( Sender is TcxButtonEdit ) then
   If NOT NewListBox.CheckVat ( ( Sender as TcxButtonEdit).Text, ArrPos ) Then
      MyFocusControl( Sender as TWinControl );

end;

procedure TfmAccountSetup.NomVatCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  If Key = VK_F2 Then    { F2 Pressed }
     actVATCodeSelect.Execute;

end;

procedure TfmAccountSetup.Deprec_editPropertiesChange(Sender: TObject);
begin
  inherited;
  try if strtofloat(deprec_edit.Text) > 100.00 then begin
                            showmessage('Depreciation rate cannot exceed 100%');
                            deprec_edit.text := '100.00';
                            end;
  except
  end;

end;

procedure TfmAccountSetup.NomVatCodePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  inherited;
  if AButtonIndex = 0 then
     actVATCodeSelect.Execute;
end;

procedure TfmAccountSetup.actVATCodeSelectExecute(Sender: TObject);
begin
  inherited;
     NewListBox.ListInfo.ActiveDb := 0;
     NewListBox.ListInfo.ListType := 'V';
     NewListBox.ListInfo.AccRange[1] := 0;
     NewListBox.ListInfo.AccRange[2] := 0;
     NewListBox.ShowModal;
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        Begin
             Case PageControl.ActivePageIndex Of
                  0 : Begin
                         MyFocusControl(NomVATCode);
                         NomVATCode.Text := NewListBox.ListInfo.ReturnValue;
                      End;
                  1 : Begin
                         MyFocusControl(EntAccountVatNo);
                         EntAccountVATNo.Text := NewListBox.ListInfo.ReturnValue;
                      End;
             End;
        End;
end;

procedure TfmAccountSetup.NomBalancePropertiesChange(Sender: TObject);
var
   TestLong : Long;
begin
  inherited;
  If IsItLong ( NomBalance.Text, 'L', TestLong ) Then
     Begin
          If ( TestLong < 0 ) Then
             NomBalance.Style.Font.Color := clRed
          Else
             NomBalance.Style.Font.Color := clBlack;
     End
  Else
     Begin
          NomBalance.Text := '';
          MyFocusControl(NomBalance);
     End;
end;

procedure TfmAccountSetup.NomRepGroupPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  inherited;
  if AButtonIndex = 0 then
     actReportGroupSelect.Execute;
end;

procedure TfmAccountSetup.NomRepGroupPropertiesChange(Sender: TObject);
begin
  inherited;
  ReadTables ( NlFile, StrToInt ( NomRepGroup.Text ), CurrStr );
  NomGroupDesc.Text := CurrStr;

end;

procedure TfmAccountSetup.actReportGroupSelectExecute(Sender: TObject);
begin
  inherited;
  NewListBox.ListInfo.ActiveDb := NlFile;
  NewListBox.ListInfo.ListType := 'G';
  if PageControl.ActivePage = tsNominalAccounts then
     NewListBox.ListInfo.AccRange := NominalAccountRanges
  else if PageControl.ActivePage = tsEnterprises then
     NewListBox.ListInfo.AccRange := GetEnterpriseAccountRanges;

  NewListBox.ShowModal;
  If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
     If ( PageControl.ActivePage = tsNominalAccounts ) Then { Nominal Accounts Group Set-Up }
        NomRepGroup.Text := NewListBox.ListInfo.ReturnValue
     else if PageControl.ActivePage = tsEnterprises then{ Enterprise set-up }
        EntAccountGroupNo.Text := NewListBox.ListInfo.ReturnValue;

end;

procedure TfmAccountSetup.NomRepGroupExit(Sender: TObject);
Var
   AccRange : TAccRange;
   TempStr : ShortString;
begin
   inherited;

   if (Sender is TcxButtonEdit) then
      begin
         TempStr := (Sender as TcxButtonEdit).Text;
         SlimAll ( TempStr );
         If Numeric ( TempStr ) Then
            Begin
                AccRange := NominalAccountRanges;
                TempStr := (Sender as TcxButtonEdit).Text;
                SlimAll ( TempStr );
                If Numeric ( TempStr ) Then
                   If ( StrToInt ( TempStr ) < AccRange[1] ) Or
                      ( StrToInt ( TempStr ) > AccRange[2] ) Then
                      MyFocusControl(Sender as TWinControl);
            End
         Else
            MyFocusControl(Sender as TWinControl);
     end;
end;

procedure TfmAccountSetup.NomRepGroupKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  If Key = VK_F2 Then
     actReportGroupSelect.Execute;

end;

procedure TfmAccountSetup.actClearProductExecute(Sender: TObject);
begin
  inherited;
  cbProductsNoms.EditValue := Null;
end;

procedure TfmAccountSetup.actNomAccHelpExecute(Sender: TObject);
begin
  inherited;
  Application.HelpContext(118);

end;

procedure TfmAccountSetup.actNomAccSaveExecute(Sender: TObject);
var
  RecToRead : Integer;
  NomTypeStr : char;
begin
  inherited;
  if cash1.xyearend = true then begin
     if messagedlg('You are making changes to an archive set of accounts.'+ #13#10 +
                   'Are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrno then exit;
  end;

  AddAmendDelete := '';
  actNomAccAdd.Enabled := True;

  RecToRead := StrToInt(NomCode.Text);

   if  ((RecToRead >=Cash1.xNomIncFrom) and (RecToRead <=Cash1.xNomOhTo)) then
      begin
         if NominalTypeDropdown.ItemIndex = 1 then
            NomTypeStr := 'L'
         else if NominalTypeDropdown.ItemIndex = 2 then
            NomTypeStr := 'P'
         else if NominalTypeDropdown.ItemIndex = 3 then
            NomTypeStr := 'O'
         else if NominalTypeDropdown.ItemIndex = 4 then
            NomTypeStr := 'U';

         if NomTypeStr <> '' then
            begin
               currdisp[1] := NomTypeStr;
               putitem(NLFile,103);
            end;
      end;

   if (((RecToRead >=Cash1.xNomCaFrom) and (RectoRead <=Cash1.xNomCaTo)) or
       ((RecToRead >=Cash1.xNomFaFrom) and (RecToRead <=Cash1.xNomFaTo))) then
      begin
         currlong := strtoint(floattostr(100 * strtofloat(Deprec_edit.text)));
         putitem(NLFile,101);
         currlong := strtoint(floattostr(100 * strtofloat(Deprec_edit2.text)));
         putitem(NLFile,102);
      end;

   SaveNominalAccount;
   actNomAccCancel.Enabled := False; // TGM AB 4/06/02
end;

procedure TfmAccountSetup.actNomAccDeleteExecute(Sender: TObject);
begin
  inherited;
  AddAmendDelete := 'DEL';
  actNomAccAdd.Enabled := True;
  DeleteNominalAccount;
end;

procedure TfmAccountSetup.actNomAccAddExecute(Sender: TObject);
begin
  inherited;
  if ( cmboNominalAccountTypes.Text = cNomAcc_EnterpriseIncome ) Or ( cmboNominalAccountTypes.Text = cNomAcc_EnterpriseExpenditure ) then
     MessageDLG('Cannot Add Enterprise Income/Expenditure Accounts here - Select Enterprises.',mtInformation,[mbOK],0)
  else if ( cmboNominalAccountTypes.Text = 'Control Accounts' ) then
     MessageDLG('Cannot Add Control Accounts.',mtInformation,[mbOK],0)
  else
     begin
        AddAmendDelete := 'ADD';
        actNomAccAdd.Enabled := False;
        AddNominalAccount;
        AccsDataModule.NomListOk := FALSE;
        if AddAmendDelete = 'ADD' then
           actNomAccCancel.Enabled := true; // TGM AB 4/06/02
     end;
end;

procedure TfmAccountSetup.actNomAccCancelExecute(Sender: TObject);
begin
  inherited;
  actNomAccAdd.Enabled := True;
  CancelNominalAccount;
  AccsDataModule.NomListOk := TRUE;
  actNomAccCancel.Enabled := False; // TGM AB 4/06/02
end;

procedure TfmAccountSetup.LoadNominalAccount(const AAcountDescription: string);
begin
   actNomAccCancel.Execute;
   if (AAcountDescription = cNomAcc_EnterpriseIncome) then
      begin
         //NomGrid.Rowcount := 3;
         NomEntCode.Visible := True;
         gbNominalAccounts.Caption := 'Enterprise Income Accounts (Range '
                                      + IntToStr ( Cash1.xNomincFrom ) + ' To ' + IntToStr ( Cash1.xNomIncTo ) + ')';
         NomBalance.Enabled := False;
      end
   else if (AAcountDescription = cNomAcc_NonEnterpriseIncome) then
      begin
         NomEntCode.Visible := False;
         gbNominalAccounts.Caption := 'Non-Enterprise Income Accounts  (Range '
                                      + IntToStr ( Cash1.xNomNonFrom ) + ' To ' + IntToStr ( Cash1.xNomNonTo ) + ')';
         NomBalance.Enabled := False;
      end
   else if (AAcountDescription = cNomAcc_EnterpriseExpenditure) then
      begin
         NomEntCode.Visible := True;
         gbNominalAccounts.Caption := 'Enterprise Expenditure Accounts (Range '
                                      + IntToStr ( Cash1.xNomExpFrom ) + ' To ' + IntToStr ( Cash1.xNomExpTo ) + ')';
         NomBalance.Enabled := False;
      end
   else if (AAcountDescription = cNomAcc_Overheads) then
      begin
        NomEntCode.Visible := False;
        gbNominalAccounts.Caption := 'Overhead Accounts (Range '
                                      + IntToStr ( Cash1.xNomOhFrom ) + ' To ' + IntToStr ( Cash1.xNomOhTo ) + ')';
        NomBalance.Enabled := False;
      end
   else if (AAcountDescription = cNomAcc_CurrentAssets) then
      begin
        NomEntCode.Visible := False;
        gbNominalAccounts.Caption := 'Current Asset Accounts (Range '
                                      + IntToStr ( Cash1.xNomCaFrom ) + ' To ' + IntToStr ( Cash1.xNomCaTo ) + ')';
        NomBalance.Enabled := True;
      end
   else if (AAcountDescription = cNomAcc_FixedAssets) then
      begin
         NomEntCode.Visible := False;
         gbNominalAccounts.Caption := 'Fixed Asset Accounts (Range '
                                      + IntToStr ( Cash1.xNomFaFrom ) + ' To ' + IntToStr ( Cash1.xNomFaTo ) + ')';
         NomBalance.Enabled := True;
      end
   else if (AAcountDescription = cNomAcc_Liabilities) then
      begin
         NomEntCode.Visible := False;
         gbNominalAccounts.Caption := 'Liability Accounts (Range '
                                      + IntToStr ( Cash1.xNomLiFrom ) + ' To ' + IntToStr ( Cash1.xNomLiTo ) + ')';
         NomBalance.Enabled := True;
      end
   else if (AAcountDescription = cNomAcc_Banks) then
      begin
         NomEntCode.Visible := False;
         gbNominalAccounts.Caption := 'Bank Accounts (Range '
                                               + IntToStr ( Cash1.xBankMin ) + ' To ' + IntToStr ( Cash1.xBankMax ) + ')';
         NomBalance.Enabled := True;
      end
   else if (AAcountDescription = cNomAcc_AllAccounts) then
      begin
        NomEntCode.Visible := False;
        SetDb ( cDb );
        gbNominalAccounts.Caption := 'All Ledger Accounts';
        NomBalance.Enabled := False;
      end
   else if (AAcountDescription = cNomAcc_ControlAccounts) then
      begin
         NomEntCode.Visible := False;
         gbNominalAccounts.Caption := 'Control Accounts (Range '
                                               + IntToStr ( Cash1.xBankMax+1 ) + ' To ' + IntToStr ( Cash1.xNomOpen+Cash11.xno_of_partners ) + ')';
         NomBalance.Enabled := True;
         MessageDlg('Warning - changing the balances of creditors and debtors control accounts can result in the balances not matching the age of debt summaries. Please take care.',mtWarning,[mbOK],0);
      end;
   FillNominalGrid ( NominalAccountRanges );
   ChangeNominalAccountType(AAcountDescription);


end;

procedure TfmAccountSetup.ChangeNominalAccountType(const AAcountDescription : string);
begin
   If AAcountDescription = cNomAcc_ControlAccounts Then
      begin
         NomVATCode.Enabled := False;
         NomVatCode.Visible := False;
         LabelNomVATCode.Visible := False;
      end
   else
      Begin
         NomVATCode.Enabled := True;
         NomVatCode.Visible := True;
         LabelNomVATCode.Visible := True;
      end;
end;

procedure TfmAccountSetup.FillNominalGrid(AccRange: TAccRange);
Var
   ArrPos,
   NomRec : Integer;
Begin
   Screen.Cursor := crHourGlass;
   Deprec_edit.visible := false;
   Depreclabel.visible := false;
   TypeLabel.visible := false;
   NominalTypeDropdown.visible := false;
   RecNo := 0;
   ArrPos := 0;
   NomRec := AccRange[1];
   SetDb ( cDb );

   NomAccsGridTableView.DataController.RecordCount := 0;
   with NomAccsGridTableView.DataController do
      begin
         BeginUpdate;
         try
            Repeat
               ReadRec ( cDb, NomRec );
               dberr;
               If Recactive ( cDb ) And ( NOT ExcludeNominal ( NomRec )) Then
                  Begin
                     NomAccsGridTableView.DataController.RecordCount := NomAccsGridTableView.DataController.RecordCount+1;
                     Values[ArrPos, NomAccsGridTableViewNo.Index] := PadString(IntToStr ( NomRec ),'0',20);
                     dbCore.GetItem ( cDb, 1 );
                     Values[ArrPos, NomAccsGridTableViewName.Index] := CurrStr;
                     dbCore.GetItem ( cDb, 24 );
                     Values[ArrPos, NomAccsGridTableViewEnt.Index] := CurrStr;
                     Inc ( ArrPos );
                  End;
               Inc ( NomRec );
            Until ( NomRec > AccRange[2] ) Or ( NomRec = 0 );
         finally
            MyFocusControl(NomAccsGrid);
            EndUpdate;
            if (RecordCount>0) then
               begin
                  FocusedRecordIndex := 0;
                  if Numeric ( Values[0, NomAccsGridTableViewNo.Index]) Then
                     FillNominalPanel( StrToInt (Values[0, NomAccsGridTableViewNo.Index]))
                  else
                     ClearNominalPanel;
               end;
            Screen.Cursor := crDefault;
         end;
      end;
end;

procedure TfmAccountSetup.ClearNominalPanel;
begin
    NomCode.Clear;
    NomName.Clear;
    NomVATCode.Clear;
    NomBalance.Text := '0';
    NomRepGroup.Text := '0';
    NomGroupDesc.Clear;
    NomEntCode.Clear;
end;

procedure TfmAccountSetup.FillNominalPanel(RecToRead: Integer);
begin
   RecNo := 0;
   Deprec_edit.visible := false;
   Depreclabel.visible := false;
   Deprec_edit2.visible := false;
   Depreclabel2.visible := false;
   TypeLabel.visible := false;
   NominalTypeDropdown.visible := false;
   SetDb ( cDb );

   If ( RecToRead > 0 ) And ( RecToRead <= db1.dbrechigh ) Then
      begin
         if //(( RecToRead >= Cash1.xbankmax ) Or // TGM remmed this out 20/01/03 to allow controll a/c balances to be corrected.
            (( RecToRead = Cash1.xnomsldisc ) or ( RecToRead = Cash1.xnompldisc ) Or ( RecToRead = Cash1.xnomdeprec )) then
            begin
               actNomAccSave.Enabled := false;
               actNomAccDelete.Enabled := false;
            end
         else
            begin
               actNomAccSave.Enabled := true;
               actNomAccDelete.Enabled := true;
            end;
         ReadRec ( cDb, RecToRead );
         dberr;
         if Recactive ( cDb ) then
            begin
               NomCode.Text := IntToStr ( RecToRead );
               Getitem ( cDb, 1 );
               NomName.Text := CurrStr;
               if ShowOpening.Checked Then
                  Getitem ( cDb, 22 )
               else
                  GetItem ( cDb, 2 );

               CheckNominalAccountType ( RecToRead, CurrLong );
               NominalWasBalance := CurrLong;
               LongStr ( CurrLong, CurrStr, 'L' );
               NomBalance.Text := CurrStr;

               // Get the Current Records Product
               if NOT Cash11.xBilling then // Donot show the products
                  try
                     // Cancel in case they change record but click on the grid without
                     // Saving
                     AccsDataModule.NominalList.Cancel;
                     AccsDataModule.NominalList.Locate('Account',RecToRead,[] );
                  except

                  end;

               Getitem ( cDb, 5 );
               // No Group entered so default to the Record Number
               if Currint = 0 then
                  CurrInt := RecToRead;

               NomRepGroup.Text := IntToStr ( Currint );
               ReadTables ( cDb, CurrInt, CurrStr );
               NomGroupDesc.Text := CurrStr;
               Getitem ( cDb, 20 );
               NomVatCode.Text := CurrStr;
               RecNo := RecToRead;
               if ( cmboNominalAccountTypes.Text = cNomAcc_EnterpriseIncome ) or ( cmboNominalAccountTypes.Text = cNomAcc_EnterpriseExpenditure ) then
                  begin
                     GetStr ( cDb, 24, 4, CurrStr );
                     NomEntCode.Text := CurrStr;
                  end;


               if (((RecToRead >=Cash1.xNomCaFrom) and (RectoRead <=Cash1.xNomCaTo)) or
                  ((RecToRead >=Cash1.xNomFaFrom) and (RecToRead <=Cash1.xNomFaTo)) or
                  ((RecToRead >=Cash1.xNomIncFrom) and (RecToRead <=Cash1.xNomOhTo))) then
                  begin
                     Deprec_edit.visible := false;
                     Depreclabel.visible := false;
                     Deprec_edit2.visible := false;
                     Depreclabel2.visible := false;
                     TypeLabel.visible := false;
                     NominalTypeDropdown.visible := false;

                     if (((RecToRead >=Cash1.xNomCaFrom) and (RectoRead <=Cash1.xNomCaTo)) or
                         ((RecToRead >=Cash1.xNomFaFrom) and (RecToRead <=Cash1.xNomFaTo))) then
                        begin
                             Deprec_edit.visible := true;
                             Depreclabel.visible := true;
                             Deprec_edit2.visible := true;
                             Depreclabel2.visible := true;
                             getitem(NLFile,101);
                             DoubleToStr(currlong,currstr,'%10.2f',true,true,12,true);
                             Deprec_edit.text := currstr;
                             getitem(NLFile,102);
                             DoubleToStr(currlong,currstr,'%10.2f',true,true,12,true);
                             Deprec_edit2.text := currstr;
                        end;

                     if ((RecToRead >=Cash1.xNomIncFrom) and (RecToRead <=Cash1.xNomOhTo) and (Accsdatamodule.linkedtoherd)) then
                        begin
                           TypeLabel.visible := true;
                           NominalTypeDropdown.visible := true;
                           Getitem(NLFile, 103);
                           if currstr = 'L' then
                              NominalTypeDropdown.ItemIndex := 1
                           else if currstr = 'P' then
                              NominalTypeDropdown.ItemIndex := 2
                           else if currstr = 'O' then
                              NominalTypeDropdown.ItemIndex := 3
                           else if currstr = 'U' then
                              NominalTypeDropdown.ItemIndex := 4
                           else
                              NominalTypeDropdown.ItemIndex := 0;

                        end;

                     end // if in ranges
                  else
                     begin
                        Deprec_edit.visible := false;
                        Depreclabel.visible := false;
                        Deprec_edit2.visible := false;
                        Depreclabel2.visible := false;
                        TypeLabel.visible := false;
                        NominalTypeDropdown.visible := false;
                     end;
            end;  // end if recactive
      end; // end RecToRead

end;

class procedure TfmAccountSetup.SetupAccounts(
  const AAccountType: TAccountType);
begin
   with TfmAccountSetup.Create(nil) do
      try
         FAccountType := AAccountType;
         LoadScreenData;
         ShowModal;
      finally
         Free;
      end;
end;

procedure TfmAccountSetup.cmboNominalAccountTypesPropertiesChange(
  Sender: TObject);
begin
  inherited;
  LoadNominalAccount( cmboNominalAccountTypes.Text );
end;

procedure TfmAccountSetup.FormActivate(Sender: TObject);
begin
  inherited;
  if NOT Cash11.xBilling then // Donot show the products
     try
        AccsDataModule.GetAllNominalLedgerAccs;
        AccsDataModule.NominalList.Open;
        AccsDataModule.Products.Open;
     except
        ShowMessage('Cannot open Products File');
     end;

  NomBalance.Enabled := False;



  pCustSuppCashbook.visible := not cash1.xcashbook;


  PageControl.ActivePageIndex := 2;

  Validpassword := false;

  actRptEnterprises.Visible := not Cash11.xUse_Enterprise;
  FFormShowing := True;
end;

procedure TfmAccountSetup.SetupDBControls;
begin
  { Nominal Account Types }

  with AccsDataModule.erNominalAccountTypes.Properties.Items do
     begin
        Clear;
        BeginUpdate;
        try
           If not Cash11.xUse_Enterprise Then
              Add(cNomAcc_EnterpriseIncome);
           Add(cNomAcc_NonEnterpriseIncome);
           If not Cash11.xUse_Enterprise Then
              Add(cNomAcc_EnterpriseExpenditure);
           Add(cNomAcc_Overheads);
           Add(cNomAcc_CurrentAssets);
           Add(cNomAcc_FixedAssets);
           Add(cNomAcc_Liabilities);
           Add(cNomAcc_Banks);
           Add(cNomAcc_AllAccounts);
           Add(cNomAcc_ControlAccounts);
        finally
           EndUpdate;
        end;
       //cmboNominalAccountTypes.RepositoryItem := AccsDataModule.erNominalAccountTypes

       cmboNominalAccountTypes.Properties.Assign(AccsDataModule.erNominalAccountTypes.Properties);
       cmboNominalAccountTypes.Properties.OnChange := cmboNominalAccountTypesPropertiesChange;
       cmboNominalAccountTypes.Properties.DropDownRows := cmboNominalAccountTypes.Properties.Items.Count;

       EntNominalTypeDropdown.Properties.Assign(AccsDataModule.erNominalAccountTypes.Properties);

       if NomRepGroup.Properties.Buttons[0] <> nil then
          AccsDataModule.ImageList16x16.GetBitmap(1, NomRepGroup.Properties.Buttons[0].Glyph);
       if NomVatCode.Properties.Buttons[0] <> nil then
          AccsDataModule.ImageList16x16.GetBitmap(1, NomVatCode.Properties.Buttons[0].Glyph);
       if EntAccountGroupNo.Properties.Buttons[0] <> nil then
          AccsDataModule.ImageList16x16.GetBitmap(1, EntAccountGroupNo.Properties.Buttons[0].Glyph);
       if EntAccountVatNo.Properties.Buttons[0] <> nil then
          AccsDataModule.ImageList16x16.GetBitmap(1, EntAccountVatNo.Properties.Buttons[0].Glyph);
     end;
end;

procedure TfmAccountSetup.FormCreate(Sender: TObject);
begin
  inherited;
  SetupDBControls;

  FFormShowing := False;
  LastCust := 0;
  LastSupp := 0;
  LastNom := 0;
  LastEnt := 0;
  AddAmendDelete := '';
  AddAmendDeleteEnt := '';
  Caption := 'Nominal Accounts';
end;

procedure TfmAccountSetup.actRptNominalAccountsExecute(Sender: TObject);
begin
  inherited;
  SetupReport(rpSetupNominal);
  PROG := SpecRep;
  NewRepForm.DataBase := NlFile;
  NominalReportForm.SetNominalReportForm(NomsOrGroups);
  NominalReportForm.ShowModal;

end;

procedure TfmAccountSetup.actRptCustomerListingExecute(Sender: TObject);
begin
  inherited;
  SetupReport(rpSetupCustomer);
  PROG := CustRep;
  NewRepForm.DataBase := SLFile;
  CustSuppListing.RepType := Customer;
  Act := 1;
  CustSuppListing.Caption := 'Account Listing';
  CustSuppListing.ShowModal;

end;

procedure TfmAccountSetup.actRptSupplierListingExecute(Sender: TObject);
begin
  inherited;
  SetupReport(rpSetupCustomer);
  PROG := SUPPrep;
  NewRepForm.DataBase := PLFile;
  CustSuppListing.RepType := Supplier;
  Act := 1;
  CustSuppListing.Caption := 'Account Listing';
  CustSuppListing.ShowModal;
end;

procedure TfmAccountSetup.actRptEnterprisesExecute(Sender: TObject);
begin
  inherited;
  SetupReport(rpSetupEnterprise);
  PROG := SpecRep;
  NewRepForm.DataBase := NlFile;
  NominalReportForm.SetNominalReportForm(EntStructure);
  NominalReportForm.ShowModal;

end;

procedure TfmAccountSetup.gbCustomersSuppliersEnter(Sender: TObject);
begin
  inherited;
  If (rgCustomerSupplier.ItemIndex=0) Then
     cDb := SLFile
  else if (rgCustomerSupplier.ItemIndex=1) Then
     cDb := PLFile
  else
     begin
        rgCustomerSupplier.ItemIndex :=0;
        MyFocusControl(CustomerSupplierGrid);
        cDb := SLFile;
     end;
end;

procedure TfmAccountSetup.CustSuppAreaCodeExit(Sender: TObject);
begin
  inherited;
  If NOT Numeric ( CustSuppAreaCode.Text ) Then
     MyFocusControl(CustSuppAreaCode);

end;

procedure TfmAccountSetup.SetToLong(var StrToChange: TcxTextEdit);
begin
    If IsItLong ( StrToChange.Text, 'L', CurrLong ) Then
       Begin
            LongStr ( CurrLong, CurrStr, 'L' );
            StrToChange.Text := CurrStr;
       End
    Else
       MyFocusControl(StrToChange);
end;

procedure TfmAccountSetup.CustSuppTurnoverExit(Sender: TObject);
begin
  inherited;
  SetToLong ( CustSuppTurnover );
end;

procedure TfmAccountSetup.CustSuppOpenBalanceExit(Sender: TObject);
begin
  inherited;
  SetToLong ( CustSuppOpenBalance );
end;

procedure TfmAccountSetup.CustSuppAgeCurrExit(Sender: TObject);
begin
  inherited;
  SetToLong ( CustSuppAgeCurr );
end;

procedure TfmAccountSetup.CustSuppAged1Exit(Sender: TObject);
begin
  inherited;
  SetToLong ( CustSuppAged1 );
end;

procedure TfmAccountSetup.CustSuppAged2Exit(Sender: TObject);
begin
  inherited;
  SetToLong ( CustSuppAged2 );

end;

procedure TfmAccountSetup.CustSuppAged3Exit(Sender: TObject);
begin
  inherited;
  SetToLong ( CustSuppAged3 );
end;

procedure TfmAccountSetup.NomBalanceExit(Sender: TObject);
begin
  inherited;
  SetToLong ( NomBalance );
end;

procedure TfmAccountSetup.PageControlChange(Sender: TObject);
begin
  inherited;
  case PageControl.ActivePageIndex Of
     0 : FAccountType := accNominal;
     1 : FAccountType := accEnterprise;
     2 : FAccountType := accCustomerSupplier;
  end;
  LoadScreenData;
end;

procedure TfmAccountSetup.FillCustomerSupplierGrid(
  const ASearchText: string);
Var
   LastCustSupp,
   ArrPos,
   CustSuppRec : Integer;
   tempstr : string;
   sstring : shortstring;
begin
   Screen.Cursor := crHourGlass;
   ArrPos := 0;
   CustSuppRec := 1;
   SetDb ( cDb );
   LastCustSupp := db1.dbrechigh;

   CustomerSupplierGridTableView.DataController.BeginFullUpdate;

   try
      CustomerSupplierGridTableView.DataController.RecordCount := 0;

      if ( cDb = PLFile ) then
         begin
            Repeat
               accsdatamodule.PLFileDB.locate('PLNo',CustSuppRec,[]);
               If AccsDataModule.PLFileDB['Active'] = true then
                  begin
                     tempstr := vartostr(accsdatamodule.PLFileDB['Name']);
                     if ((searchbox.text = '') or (pos(UpperCase(searchbox.text),UPPERCase(Tempstr)) > 0)) then
                        begin
                           CustomerSupplierGridTableView.DataController.RecordCount := CustomerSupplierGridTableView.DataController.RecordCount+1;
                           CustomerSupplierGridTableView.DataController.Values[ArrPos, CustomerSupplierGridTableViewNo.Index] := IntToStr ( CustSuppRec );
                           CustomerSupplierGridTableView.DataController.Values[ArrPos,CustomerSupplierGridTableViewName.Index] := Tempstr;
                           // TGM AB 12/08/02 edited to show no balance in cashbook system
                           if not cash1.xcashbook then
                              begin
                                 // tempstr := vartostr(accsdatamodule.PLFileDB['Balance']);
                                 DoubletoStr(accsdatamodule.PLFileDB['Balance'], sstring , '%8.2f', True, False, 10, True);
                                 CustomerSupplierGridTableView.DataController.Values[ArrPos,CustomerSupplierGridTableViewBalance.Index] := sstring;
                              end;
                           // End TGM AB
                           Inc ( ArrPos );
                        end;
                  end;
               Inc ( CustSuppRec );
            until ( CustSuppRec > LastcustSupp  ) Or ( CustSuppRec = 0 );

         end
      else
         begin
            Repeat
               accsdatamodule.SLFileDB.locate('SLNo',CustSuppRec,[]);
               If accsdatamodule.SLFileDB['Active'] = true Then
                  begin
                     tempstr := vartostr(accsdatamodule.SLFileDB['Name']);
                     if ((SearchBox.text = '') or (pos(UpperCase(SearchBox.text),UPPERCase(Tempstr)) > 0)) then
                        begin
                           CustomerSupplierGridTableView.DataController.RecordCount := CustomerSupplierGridTableView.DataController.RecordCount+1;
                           CustomerSupplierGridTableView.DataController.Values[ArrPos, CustomerSupplierGridTableViewNo.Index] := IntToStr ( CustSuppRec );
                           CustomerSupplierGridTableView.DataController.Values[ArrPos,CustomerSupplierGridTableViewName.Index] := Tempstr;
                           // TGM AB 12/08/02 edited to show no balance in cashbook system
                           if not cash1.xcashbook then
                              begin
                                 // tempstr := vartostr(accsdatamodule.SLFileDB['Balance']);
                                 DoubletoStr(accsdatamodule.SLFileDB['Balance'], sstring , '%8.2f', True, False, 10, True);
                                 CustomerSupplierGridTableView.DataController.Values[ArrPos,CustomerSupplierGridTableViewBalance.Index] := sstring;
                              end;
                           // End TGM AB
                           Inc ( ArrPos );
                        end;
                  end;
               Inc ( CustSuppRec );
            Until ( CustSuppRec > LastcustSupp  ) Or ( CustSuppRec = 0 );
        end; // else begin

   finally
      CustomerSupplierGridTableView.DataController.EndFullUpdate;
      if (CustomerSupplierGridTableView.DataController.RecordCount>0) then
         begin
            CustomerSupplierGridTableView.Controller.FocusedRecordIndex := 0;
            if Numeric ( CustomerSupplierGridTableView.DataController.Values[0, 0]) Then
               FillCustomerSupplierPanel( StrToInt (CustomerSupplierGridTableView.DataController.Values[0, 0]));
         end;
      Screen.Cursor := crDefault;
      MyFocusControl(CustomerSupplierGrid);
   end;
end;

procedure TfmAccountSetup.SearchBoxPropertiesChange(Sender: TObject);
begin
  inherited;
  SearchCustomerSupplier( Searchbox.Text );
  MyFocusControl(SearchBox);
end;

procedure TfmAccountSetup.rgCustomerSupplierPropertiesChange(
  Sender: TObject);
begin
   inherited;
   RecNo := 0;
   ClearEnterpriseAccountPanel;
   if (rgEnterpriseType.ItemIndex=0) then
      begin
         with EntIncomeGridTableView.DataController do
            begin
               if (RecordCount>0) then
                  begin
                     if FocusedRecordIndex < 0 then
                        FocusedRecordIndex := 0;
                     if Numeric ( Values[FocusedRecordIndex, EntIncomeGridTableViewNo.Index]) Then
                        RecNo := StrToInt ( Values[FocusedRecordIndex, EntIncomeGridTableViewNo.Index]);
                     FillEnterpriseAccountPanel ( RecNo );
                    // MyFocusControl(EntGrid);
                  end;
            end;
      end
   else if (rgEnterpriseType.ItemIndex=1) Then
       begin
         with EntExpendGridTableView.DataController do
            begin
               if (RecordCount>0) then
                  begin
                     if FocusedRecordIndex < 0 then
                        FocusedRecordIndex := 0;
                     if Numeric ( Values[FocusedRecordIndex, EntExpendGridTableViewNo.Index]) Then
                        RecNo := StrToInt ( Values[FocusedRecordIndex, EntExpendGridTableViewNo.Index]);
                     FillEnterpriseAccountPanel ( RecNo );
                   //  MyFocusControl(EntGrid);
                  end;
            end;
       end;
end;

procedure TfmAccountSetup.FillCustomerSupplierPanel(RecToRead: Integer);
begin
   SetDb ( cDb );
   NoActiveTransactions := False;
   If ( RecToRead > 0 ) And ( RecToRead <= db1.dbrechigh ) Then
      Begin
         ReadRec ( cDb, RecToRead );
         dberr;
         If Recactive ( cDb ) Then
            begin
               CustSuppNo.Text := IntToStr ( RecToRead );
               GetItem ( cDb, 1 );
               CustSuppName.Text := CurrStr;
               GetItem ( cDb, 2 );
               CustSuppAdd1.Text := CurrStr;
               GetItem ( cDb, 3 );
               CustSuppAdd2.Text := CurrStr;
               GetItem ( cDb, 4 );
               CustSuppAdd3.Text := CurrStr;
               GetItem ( cDb, 5 );
               CustSuppAdd4.Text := CurrStr;
               GetItem ( cDb, 22 );
               CustSuppAreaCode.Text := IntToStr ( CurrInt );
               GetItem ( cDb, 23 );
               CustSuppPostCode.Text := CurrStr;
               GetItem ( cDb, 21 );
               CustSuppFaxNo.Text := CurrStr;
               GetItem ( cDb, 27 );
               CustSuppVATNo.Text := CurrStr;
               GetItem ( cDb, 19 );
               CustSuppPhone1.Text := CurrStr;
               GetItem ( cDb, 20 );
               CustSuppPhone2.Text := CurrStr;
               GetItem ( cDb, 25 );
               CustSuppContact1.Text := CurrStr;
               GetItem ( cDb, 26);
               CustSuppContact2.Text := CurrStr;
               GetItem ( cDb, 24 );
               CustSuppRefCode.Text := CurrStr;
               GetItem ( cDb, 28 );
               CustSuppComment.Text := CurrStr;
               { Store original balance }
               GetItem ( cDb, 7 );
               CustomerSupplierWasBalance := CurrLong;
               LongStr ( CurrLong, CurrStr, 'L' );
               CustSuppOpenBalance.Text := CurrStr;
               GetItem ( cDb, 8 );
               LongStr ( CurrLong, CurrStr, 'L' );
               CustSuppTurnOver.Text := CurrStr;
               GetItem ( cDb, 9 );
               LongStr ( CurrLong, CurrStr, 'L' );
               CustSuppAgeCurr.Text := CurrStr;
               GetItem ( cDb, 10 );
               LongStr ( CurrLong, CurrStr, 'L' );
               CustSuppAged1.Text := CurrStr;
               GetItem ( cDb, 11 );
               LongStr ( CurrLong, CurrStr, 'L' );
               CustSuppAged2.Text := CurrStr;
               GetItem ( cDb, 12 );
               LongStr ( CurrLong, CurrStr, 'L' );
               CustSuppAged3.Text := CurrStr;
               RecNo := RecToRead;

               { Check for Active Transactions }
               GetItem ( cDb, 15 );
               NoActiveTransactions := ( Currint = 0 );
               If NoActiveTransactions Then
                  Begin
                       GetItem ( cDb, 16 );
                       NoActiveTransactions := ( Currint = 0 );
                  End;
               If NoActiveTransactions Then
                  begin
                     CustSuppTurnover.Enabled := false; // TGM AB
                     CustSuppOpenBalance.Enabled := True;
                     CustSuppAgeCurr.Enabled := True;
                     CustSuppAged1.Enabled := True;
                     CustSuppAged2.Enabled := True;
                     CustSuppAged3.Enabled := True;
                  end
               else
                  begin
                     CustSuppTurnover.Enabled := False;
                     CustSuppOpenBalance.Enabled := False;
                     CustSuppAgeCurr.Enabled := False;
                     CustSuppAged1.Enabled := False;
                     CustSuppAged2.Enabled := False;
                     CustSuppAged3.Enabled := False;
                  end;
            end;
      end;
end;

procedure TfmAccountSetup.LoadScreenData;
begin
   if (FAccountType = accNominal) then
      begin
         if cmboNominalAccountTypes.ItemIndex < 0 then
            cmboNominalAccountTypes.ItemIndex := cmboNominalAccountTypes.Properties.Items.IndexOf(cNomAcc_AllAccounts);

         Caption := 'Nominal Accounts';
         cDb := NlFile;
         SetDb ( cDb );
         FillNominalGrid ( NominalAccountRanges );
      end
   else if (FAccountType = accEnterprise) then
      begin
         Caption := 'Enterprise Accounts';{+ ' - ' + st;}
         cDb := EntFile;
         SetDb ( cDb );
         RecNo := LastEnt;
         FillEnterpriseGrid;
         MyFocusControl(EntGrid);
      end
   else { accCustomerSupplier, accNone }
      begin
         Caption := 'Customer/Supplier Accounts';
         CustomerSupplierGridTableViewBalance.Visible := not cash1.xcashbook;

         if (rgCustomerSupplier.ItemIndex=0) Then
            begin
               cDb := SlFile;
               RecNo := LastCust;
            end
         else
             begin
                cDb := PlFile;
                RecNo := LastSupp;
             end;
         SetDb ( cDb );
         FillCustomerSupplierGrid;
         // TGM AB 12/08/02 - panel covering balances in a cashbook system
         pCustSuppCashbook.visible := not cash1.xcashbook;
         MyFocusControl(SearchBox);
     end
end;

procedure TfmAccountSetup.MyFocusControl(Control: TWinControl);
begin
  inherited;
  if FFormShowing then
     begin
     //   ShowMessage(Control.Name);
        if Control.CanFocus then
           FocusControl(Control);
     end;
end;

procedure TfmAccountSetup.CustomerSupplierGridTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
var
   RecToRead : Integer;
begin
  inherited;

  if ( AFocusedRecord <> nil ) then
     begin
        AddAmendDelete := '';
        RecToRead := 0;
        with CustomerSupplierGridTableView.DataController do
           begin
              if (RecordCount>0) then
                 begin
                    if FocusedRecordIndex < 0 then
                       FocusedRecordIndex := 0;

                    if Numeric (  Values[FocusedRecordIndex, CustomerSupplierGridTableViewNo.Index]) Then
                       RecToRead := StrToInt (Values[FocusedRecordIndex, CustomerSupplierGridTableViewNo.Index]);
                    If RecToRead <> 0 Then
                       FillCustomerSupplierPanel( RecToRead );
                 end;
           end;
     end;
end;

procedure TfmAccountSetup.SearchCustomerSupplier(
  const ASearchText: string);
begin
   with CustomerSupplierGridTableView.DataController do
      begin
         BeginUpdate;
         Filter.BeginUpdate;
         try
            Filter.Active := False;
            Filter.Root.Clear;
            if (Trim(ASearchText)<>'') then
               begin
                  Filter.Root.AddItem(CustomerSupplierGridTableViewName, foLike, '%'+ASearchText+'%', ASearchText);
                  Filter.Active := True;
               end;
         finally
            Filter.EndUpdate;
            EndUpdate;
         end;
      end;
end;

procedure TfmAccountSetup.actHelpExecute(Sender: TObject);
begin
  inherited;
  Application.HelpContext(118);
end;

function TfmAccountSetup.NominalAccountRanges: TAccRange;
begin
   FillChar(Result, SizeOf(TAccRange), 0);
   if ( PageControl.ActivePage = tsNominalAccounts ) then
      begin
         if (cmboNominalAccountTypes.Text = cNomAcc_EnterpriseIncome) then
            begin
               Result[1] := Cash1.xNomIncFrom;
               Result[2] := Cash1.xNomIncTo;
            end
         else if (cmboNominalAccountTypes.Text = cNomAcc_NonEnterpriseIncome) then
            begin
               Result[1] := Cash1.xNomNonFrom;
               Result[2] := Cash1.xNomNonTo;
            end
         else if (cmboNominalAccountTypes.Text = cNomAcc_EnterpriseExpenditure) then
            begin
               Result[1] := Cash1.xNomExpFrom;
               Result[2] := Cash1.xNomExpTo;
            end
         else if (cmboNominalAccountTypes.Text = cNomAcc_Overheads) then
            begin
               Result[1] := Cash1.xNomOhFrom;
               Result[2] := Cash1.xNomOhTo;
            end
         else if (cmboNominalAccountTypes.Text = cNomAcc_CurrentAssets) then
            begin
               Result[1] := Cash1.xNomCaFrom;
               Result[2] := Cash1.xNomCaTo;
            end
         else if (cmboNominalAccountTypes.Text = cNomAcc_FixedAssets) then
            begin
               Result[1] := Cash1.xNomFaFrom;
               Result[2] := Cash1.xNomFaTo;
            end
         else if (cmboNominalAccountTypes.Text = cNomAcc_Liabilities) then
            begin
               Result[1] := Cash1.xNomLiFrom;
               Result[2] := Cash1.xNomLiTo;
            end
         else if (cmboNominalAccountTypes.Text = cNomAcc_Banks) then
            begin
               Result[1] := Cash1.xBankMin;
               Result[2] := Cash1.xBankMax;
            end
         else if (cmboNominalAccountTypes.Text = cNomAcc_AllAccounts) then
            begin
               SetDb ( cDb );
               Result[1] := 1;
               Result[2] := db1.dbrechigh;
            end
         else if (cmboNominalAccountTypes.Text = cNomAcc_ControlAccounts) then
            begin
               Result[1] := Cash1.xNomTax;
               Result[2] := Cash1.xNomProfit+Cash11.xno_of_partners;
            end;
      end
   else if ( PageControl.ActivePage = tsEnterprises ) then
      begin
         if (rgEnterpriseType.ItemIndex=0) then
            Begin
                 Result[1] := Cash1.xNomIncFrom;
                 Result[2] := Cash1.xNomIncTo;
            End
         else if (rgEnterpriseType.ItemIndex=1) then
            begin
               Result[1] := Cash1.xNomExpFrom;
               Result[2] := Cash1.xNomExpTo;
            end;
      end;
end;

procedure TfmAccountSetup.NomAccsGridTableViewNoGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord;
  var AText: String);
begin
  inherited;
  AText := StripLeadingZero(AText);
end;

procedure TfmAccountSetup.NomAccsGridTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  inherited;
  if ( AFocusedRecord <> nil ) then
     begin
        RecNo := 0;
        with NomAccsGridTableView.DataController do
           begin
              if (RecordCount>0) then
                 begin
                    if FocusedRecordIndex < 0 then
                       FocusedRecordIndex := 0;

                    if Numeric (  Values[FocusedRecordIndex, NomAccsGridTableViewNo.Index]) Then
                       RecNo := StrToInt (Values[FocusedRecordIndex, NomAccsGridTableViewNo.Index]);
                    If RecNo <> 0 Then
                       FillNominalPanel( RecNo );
                 end;
           end;
     end;
end;

procedure TfmAccountSetup.actCustSuppHelpExecute(Sender: TObject);
begin
  inherited;
  Application.HelpContext(227);
end;

procedure TfmAccountSetup.actCustSuppSaveExecute(Sender: TObject);
begin
  inherited;
  if cash1.xyearend = true then begin
        if messagedlg('You are making changes to an archive set of accounts, are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrno then exit;
     end;
  actCustSuppAdd.Enabled := True;
  SaveCustomerSupplierAccount;
  actCustSuppCancel.Enabled := False; // TGM AB 4/06/02

end;

procedure TfmAccountSetup.actCustSuppDeleteExecute(Sender: TObject);
begin
  inherited;
  actCustSuppAdd.Enabled := True;
  DeleteCustomerSupplierAccount;

end;

procedure TfmAccountSetup.actCustSuppAddExecute(Sender: TObject);
begin
  inherited;
  AddAmendDelete := 'ADD';
  actCustSuppAdd.Enabled := False;
  AddCustomerSupplierAccount;
  actCustSuppCancel.enabled := true; // TGM AB 4/06/02
end;

procedure TfmAccountSetup.actCustSuppCancelExecute(Sender: TObject);
begin
  inherited;
  actCustSuppAdd.Enabled := True;
  CancelCustomerSupplierAccount;
  actCustSuppCancel.enabled := false; // TGM AB 4/06/02
end;

procedure TfmAccountSetup.AddCustomerSupplierAccount;
Var
   AccRange    : TAccRange;
   AccNo : Integer;
Begin
     AccRange[1] := 1;
     AccRange[2] := -1;    { Set to this to indicate use full range of records }

     if (rgCustomerSupplier.ItemIndex=0) or (rgCustomerSupplier.ItemIndex=0) then
        begin
           AccNo := GetNextFreeAccount ( cDb, AccRange );
           if ( AccNo > 0 ) then
              begin
                 BlankRec ( cDb, 'A' );
                 AddRecord ( cDb, AccNo, False );
                 FillCustomerSupplierPanel ( AccNo );
                 MyFocusControl(CustSuppName);
              end
           else
              MessageDlg('Internal Error: 1000',mtError, [mbOk], 0);
        end
     else
        MessageDlg('Select Account Type', mtInformation, [mbOk], 0);
end;

procedure TfmAccountSetup.AddNominalAccount;
var
   AccNo : Integer;
begin
   if (cmboNominalAccountTypes.Text = cNomAcc_NonEnterpriseIncome) or
      (cmboNominalAccountTypes.Text = cNomAcc_Overheads) or
      (cmboNominalAccountTypes.Text = cNomAcc_CurrentAssets) or
      (cmboNominalAccountTypes.Text = cNomAcc_FixedAssets) or
      (cmboNominalAccountTypes.Text = cNomAcc_Liabilities) or
      (cmboNominalAccountTypes.Text = cNomAcc_Banks) then
      begin
         AccNo := GetNextFreeAccount ( NlFile, NominalAccountRanges );
         If AccNo > 0 Then
            begin
               BlankRec ( cDb, 'A' );
               AddRecord ( cDb, AccNo, False );
               FillNominalPanel ( AccNo );
               MyFocusControl(NomName);
            end
         else
            begin
               SetDB(NlFile);
               AddAmendDelete := '';
               actEntAccountAdd.Enabled := False;
            end;
      end
   else
      begin
         MessageDlg('Select Account Type', mtInformation, [mbOk], 0);
         AddAmendDelete := '';
      end;

end;

procedure TfmAccountSetup.DeleteNominalAccount;
Var
   OkToDelete : Boolean;
   AccName : Variant;
begin
   RecNo := GetNominalAccountNo;
   if (RecNo>0) then
      begin
         AccName := VarToStr(NomAccsGridTableView.DataController.Values[0, NomAccsGridTableViewName.Index]);
         SetDb ( cDb );
         ReadRec ( cDb, RecNo );
         dberr;
         { Cannot delete control Accounts }
         OkToDelete := (( RecNo <= Cash1.xbankmax ) and
                        ( RecNo <> Cash1.xnomsldisc ) and
                        ( RecNo <> Cash1.xnompldisc ) and
                        ( RecNo <> Cash1.xnomdeprec ));
         if OkToDelete then
            begin
               GetItem ( cDb, 2 );
               OkToDelete := ( currlong = 0 );
            end
         else if OkToDelete then
            begin
               GetItem ( cdb, 14 );
               OkToDelete := ( Currint = 0 );
               if OkToDelete then
                  begin
                     GetItem ( cdb, 15 );
                     OkToDelete := ( Currint = 0 );
                  end;
            end;

         If OkToDelete then
            begin
               if MessageDlg('Delete Account ' + IntToStr(RecNo) + ' ' + AccName,  mtInformation, [mbYes, mbNo], 0) = mrYes  then
                  begin
                     DeleteRecord ( cDb, Recno, False );
                     FillNominalGrid ( NominalAccountRanges ); { refresh the nominal Grid }
                  end;
            end
         else
            begin
               if ( RecNo >= Cash1.xbankmax ) or
                  ( RecNo = Cash1.xnomsldisc ) or
                  ( RecNo = Cash1.xnompldisc ) or
                  ( RecNo = Cash1.xnomdeprec ) then
                  MessageDlg('This Account cannot be Deleted', mtInformation, [mbOk], 0)
               else
                   MessageDlg('This Account has Active Details - Delete Rejected', mtInformation, [mbOk], 0);
            end;
      end
   else
      MessageDlg('No Account has been selected.', mtInformation, [mbOk], 0);

end;

procedure TfmAccountSetup.SaveNominalAccount;
var
   NewBalance : Long;
begin
   RecNo := GetNominalAccountNo;
   if ( RecNo > 0 ) then
      begin
         PutStr ( cDb, NomName.Text, 1 );

         CurrInt := StrToInt ( NomRepGroup.Text );
         PutItem ( cDb, 5 );

         if NOT Cash11.xBilling then // Dont show the products
            try
               if AccsDatamodule.NominalList.State in dsEditmodes then
                  AccsDataModule.NominalList.Post;
               if cbProductsNoms.EditValue > 0 then
                  begin
                     SetItem;
                     CurrLong := AccsDataModule.Products.FieldByName('ID').AsInteger;
                     PutItem (cDb,6);
                  end
               else
                  begin
                     SetItem;
                     CurrLong := 0;
                     PutItem (cDb,6);
                  end;
            except
               ShowMessage('Cannot add Product to Nominal Account');
            end;

         CurrInt := StrToInt ( NomRepGroup.Text );
         CurrStr := NomGroupDesc.Text;

         WriteTables ( cDb, CurrInt, CurrStr );
         PutStr ( cDb, NomVatCode.Text, 20 );
         { Rewrite the record before adding inbalance }
         Rewriterec ( cDb, RecNo );
         dberr;

         StrLong ( NomBalance.Text, CurrLong );
         CheckNominalAccountType ( RecNo, CurrLong );
   {      If SetUpAccounts.ShowOpening.Checked Then
            PutItem ( SetUpAccounts.cDb, 22 )
         Else
            PutItem ( SetUpAccounts.cDb, 2 );
    }    // TGM AB removed this code to repair issues when setting up liability accounts
         StrLong ( NomBalance.Text, NewBalance );
         {CheckAccType ( SetUpAccounts.RecNo, NewBalance );}

         if ( NominalWasBalance = NewBalance ) Then  { No Change in balance Save Info }
            begin
               Rewriterec ( cDb, RecNo );
               dberr;
            end
         else
            begin
               CheckNominalAccountType( RecNo, NewBalance );
               CheckNominalAccountType( RecNo, NominalWasBalance );
               LogNom ( cDb, RecNo, Cash1.XNomOpen, 0-NominalWasBalance );
               LogNom ( cDb, RecNo, Cash1.XNomOpen, NewBalance );
            end;
         FillNominalGrid ( NominalAccountRanges );
      end;
end;

function TfmAccountSetup.GetNominalAccountNo: Integer;
var
   tResult : Variant;
begin
   Result := 0;

   with NomAccsGridTableView.DataController do
      begin
         if FocusedRecordIndex < 0 then
            FocusedRecordIndex := 0;

         tResult := Values[FocusedRecordIndex, NomAccsGridTableViewNo.Index];
         if not VarIsNull(tResult) then
            Result := tResult;
      end;

end;

procedure TfmAccountSetup.CancelNominalAccount;
begin
   if AddAmendDelete = 'ADD' then
      begin
         RecNo := NominalAccountNo;
         if (RecNo>0) then
            DeleteRecord ( cDb, RecNo, False );
      end;
   AddAmendDelete := '';
   FillNominalGrid ( NominalAccountRanges );
end;

procedure TfmAccountSetup.LogNom(DBNUM, DBAC, CRAC: INTEGER; BAL: LONG);

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

procedure TfmAccountSetup.CheckNominalAccountType(AccountToCheck: Integer;
  var CLong: Long);
begin
   If (( AccountToCheck >= Cash1.xnomliFrom ) And
       ( AccountToCheck <= Cash1.xnomliTo )) Or
   {
      (( AccountToCheck >= xbankmin ) And
       ( AccountToCheck <= xbankmax )) Or
   }
      (( AccountToCheck >= Cash1.xnomcredit ) And
       ( AccountToCheck <= Cash1.xnomcredit )) Or
      (( AccountToCheck >= Cash1.xnomprofit ) And
       ( AccountToCheck <= Cash1.xnomprofit+Cash11.xno_of_partners )) Then
       CLong := 0-CLong;
end;

procedure TfmAccountSetup.SaveCustomerSupplierAccount;
var
   NewBalance : Long;
begin
   RecNo := GetCustomerSupplierNo;
   if ( RecNo > 0 ) and CheckAgedBalance then
      begin
         PutStr ( cDb, CustSuppName.Text, 1 );
         PutStr ( cDb, CustSuppAdd1.Text, 2 );
         PutStr ( cDb, CustSuppAdd2.Text, 3 );
         PutStr ( cDb, CustSuppAdd3.Text, 4 );
         PutStr ( cDb, CustSuppAdd4.Text, 5 );
         PutStr ( cDb, CustSuppPostCode.Text, 23 );
         PutStr ( cDb, CustSuppFaxNo.Text, 21 );
         PutStr ( cDb, CustSuppVATNo.Text, 27 );
         PutStr ( cDb, CustSuppPhone1.Text, 19 );
         PutStr ( cDb, CustSuppPhone2.Text, 20 );
         PutStr ( cDb, CustSuppContact1.Text, 25 );
         PutStr ( cDb, CustSuppContact2.Text, 26 );
         PutStr ( cDb, CustSuppRefCode.Text, 24 );
         PutStr ( cDb, CustSuppComment.Text, 28 );
         CurrInt := StrToInt ( CustSuppAreaCode.Text );
         PutItem ( cDb, 22 );

         { Only save financial info if allowed to enter it }
         if NoActiveTransactions then
            begin
               StrLong ( CustSuppOpenBalance.Text, CurrLong );
               NewBalance := CurrLong;
               PutItem ( cDb, 6 );
               Currlong := NewBalance;
               PutItem ( cDb, 7 );
               Currlong := NewBalance;
               PutItem ( cDb, 17 );

               StrLong ( CustSuppTurnover.Text, CurrLong );
               PutItem ( cDb, 8 );
               StrLong ( CustSuppAgeCurr.Text, CurrLong );
               PutItem ( cDb, 9 );
               StrLong ( CustSuppAged1.Text, CurrLong );
               PutItem ( cDb, 10 );
               StrLong ( CustSuppAged2.Text, CurrLong );
               PutItem ( cDb, 11 );
               StrLong ( CustSuppAged3.Text, CurrLong );
               PutItem ( cDb, 12 );

               CustomerSupplierWasBalance := 0-CustomerSupplierWasBalance;
               if (rgCustomerSupplier.ItemIndex=0) then
                  begin
                     LogNom ( NlFile, Cash1.xNomDebtor, Cash1.xNomOpen, CustomerSupplierWasBalance );
                     LogNom ( NlFile, Cash1.xNomDebtor, Cash1.xNomOpen, NewBalance );
                  end
               else
                  begin
                     LogNom ( NlFile, Cash1.xNomOpen, Cash1.xNomCredit, CustomerSupplierWasBalance );
                     LogNom ( NlFile, Cash1.xNomOpen, Cash1.xNomCredit, NewBalance );
                  end;
            end;
         Rewriterec ( cDb, RecNo );
         dberr;
         FillCustomerSupplierGrid;
      end;
end;

function TfmAccountSetup.GetCustomerSupplierNo: Integer;
var
   tResult : Variant;
begin
   Result := 0;

   with CustomerSupplierGridTableView.DataController do
      begin
         if FocusedRecordIndex < 0 then
            FocusedRecordIndex := 0;

         tResult := Values[FocusedRecordIndex, CustomerSupplierGridTableViewNo.Index];
         if not VarIsNull(tResult) then
            Result := tResult;
      end;
end;

function TfmAccountSetup.CheckAgedBalance: Boolean;
var
   AccountBalance,
   TotalAged : Long;
begin
   Result := True;
   StrLong ( CustSuppOpenBalance.Text, AccountBalance );
   StrLong ( CustSuppAgeCurr.Text, TotalAged );
   StrLong ( CustSuppAged1.Text, CurrLong );
   TotalAged := TotalAged + CurrLong;
   StrLong ( CustSuppAged2.Text, CurrLong );
   TotalAged := TotalAged + CurrLong;
   StrLong ( CustSuppAged3.Text, CurrLong );
   TotalAged := TotalAged + CurrLong;
   if TotalAged <> AccountBalance Then
      begin
         Result := False;
         MessageDlg('Balance/Aged Analysis do not Agree', mtInformation, [mbOk], 0);
         MyFocusControl(CustSuppOpenBalance);
      end;
end;

procedure TfmAccountSetup.CancelCustomerSupplierAccount;
begin
   if AddAmendDelete = 'ADD' Then
      begin
         RecNo := CustomerSupplierNo;
         if (RecNo>0) then
            DeleteRecord ( cDb, RecNo, False );
      end;
   AddAmendDelete := '';
   FillCustomerSupplierGrid;
end;

procedure TfmAccountSetup.DeleteCustomerSupplierAccount;
Var
   OkToDelete : Boolean;
   CurrentBalance : Long;
   CSName : string;
begin

   RecNo := CustomerSupplierNo;

   If ( RecNo > 0) then
      Begin
         CSName := GetCustomerSupplierName;

         SetDb ( cDb );
         ReadRec ( cDb, RecNo );
         dberr;
         GetItem ( cdb, 7 );
         CurrentBalance := CurrLong;
         GetItem ( cDb, 8 );
         OkToDelete := ( CurrLong = 0 );
         if OkToDelete then
            begin
               GetItem ( cdb, 15 );
               OkToDelete := ( Currint = 0 );
               if OkToDelete then
                  begin
                     GetItem ( cdb, 16 );
                     OkToDelete := ( Currint = 0 );
                  end;
            end;
         if OkToDelete then
            begin
               If MessageDlg('Delete Account ' + IntToStr(RecNo) + ' ' + CSName, mtInformation, [mbYes, mbNo], 0) = mrYes  Then
                  Begin
                     DeleteRecord ( cDb, RecNo, False );
                     FillCustomerSupplierGrid; { Refresh the CsutSupp Grid }
                     If CurrentBalance <> 0 Then
                        begin
                           CurrentBalance := 0-CurrentBalance;
                           if (rgCustomerSupplier.ItemIndex=0) then
                              LogNom ( NlFile, Cash1.xNomDebtor, Cash1.xNomOpen, CurrentBalance )
                           else if (rgCustomerSupplier.ItemIndex=1) then
                              LogNom ( NlFile, Cash1.xNomOpen, Cash1.xNomCredit, CurrentBalance );
                        end;
                  End;
            End
         Else
             MessageDlg('This Account has Active Details - Delete Rejected', mtInformation,[mbOk], 0);
      end;
end;

function TfmAccountSetup.GetCustomerSupplierName: string;
begin
   with CustomerSupplierGridTableView.DataController do
   Result := VarToStr(Values[FocusedRecordIndex, CustomerSupplierGridTableViewName.Index]);
end;

procedure TfmAccountSetup.actBudgetsExecute(Sender: TObject);
begin
  inherited;
  TfmBudgets.ShowBudget;
end;

procedure TfmAccountSetup.blbReportsClick(Sender: TObject);
var
   pt : TPoint;
begin
   inherited;
   GetCursorPos(pt);
   bpmReports.Popup(pt.x, pt.y);
end;

procedure TfmAccountSetup.FillEnterpriseGrid;
var
   LastEnterprise,
   ArrPos,
   EntRec : Integer;
begin
   ArrPos := 0;
   EntRec := 1;
   SetDb ( cDb );
   LastEnterprise := db1.dbrechigh;

   with EntGridTableView.DataController do
      begin
         RecordCount := 0;
         BeginUpdate;
         try
            repeat
               ReadRec ( cDb, EntRec );
               dberr;
               if Recactive ( cDb ) then
                  begin
                     RecordCount := RecordCount+1;
                     Values[ArrPos,EntGridTableViewNo.Index] := IntToStr ( EntRec );
                     dbCore.GetItem ( cDb, 1 );
                     Values[ArrPos,EntGridTableViewEnt.Index] := CurrStr;
                     dbCore.GetItem ( cDb, 2 );
                     PadRight ( CurrStr, 20 );
                     Values[ArrPos,EntGridTableViewName.Index] := Copy ( CurrStr, 1, 17 );
                     Inc ( ArrPos );
                  end;
               Inc ( EntRec );
            until ( EntRec > LastEnterprise  ) Or ( EntRec = 0 );

            MyFocusControl(EntGrid);
         finally
            EndUpdate;
            if (RecordCount>0) then
               begin
                  EntGridTableView.Controller.FocusedRecordIndex := 0;
                  if Numeric ( Values[0, EntGridTableViewNo.Index]) then
                     FillEnterprisePanel ( StrToInt (Values[0, EntGridTableViewNo.Index]));
               end;
         end;
      end;
end;

procedure TfmAccountSetup.FillEnterprisePanel(RecToRead: Integer);
var
   NomRecToRead,
   IncFrom,
   IncTo,
   ExpFrom,
   ExpTo    : Integer;
begin
   SetDb ( cDb );
   if ( RecToRead > 0 ) And ( RecToRead <= db1.dbrechigh ) then
      begin
         ReadRec ( cDb, RecToRead );
         dberr;
         if Recactive ( cDb ) then
            begin
               GetItem ( cDb, 1 );
               EntCode.Text := CurrStr;
               OrigEntCode := CurrStr;
               Getitem ( cDb, 2 );
               PadRight ( CurrStr, 20 );
               EntName.Text := Copy ( CurrStr, 1, 17 );
               EntPercOverheads.Text := Copy ( CurrStr, 18, 3 );

               GetItem ( cDb, 3 );
               LongStr ( CurrLong, CurrStr, 'L' );
               EntUnitDiv.Text := CurrStr;
               Getitem ( cDb, 4 );
               EntUnitName.Text := CurrStr;
               GetInt ( cDb, 6, IncFrom );
               EntIncomeFrom.Text := IntToStr ( IncFrom );
               GetInt ( cDb, 7, IncTo );
               EntIncomeTo.Text := IntToStr ( IncTo );
               GetInt ( cDb, 8, ExpFrom );
               EntExpendFrom.Text := IntToStr ( ExpFrom );
               GetInt ( cDb, 9, ExpTo );
               EntExpendTo.Text := IntToStr ( ExpTo );

               RecNo := RecToRead;
               if IncFrom = 0 then
                  NoOfIncomeAccounts.Text := '0'
               else
                  NoOfIncomeAccounts.Text := IntToStr ( IncTo-IncFrom+1 );
               if ExpFrom = 0 then
                  NoOfExpendAccounts.Text := '0'
               else
                  NoOfExpendAccounts.Text := IntToStr ( ExpTo-ExpFrom+1 );

               FillEnterpriseNomGrids ( IncFrom, IncTo, ExpFrom, ExpTo );
               ClearEnterpriseAccountPanel;
               if ( rgEnterpriseType.ItemIndex=0) Then
                  begin
                     NomRecToRead := 0;
                     with EntIncomeGridTableView.DataController do
                        begin
                           FocusedRecordIndex := 0;
                           if (RecordCount>0) then
                              begin
                                 if Numeric ( Values[0,EntIncomeGridTableViewNo.Index ]) then
                                    NomRecToRead := StrToInt ( Values[0,EntIncomeGridTableViewNo.Index ] );
                                 FillEnterpriseAccountPanel ( NomRecToRead );
                              end;
                        end;
                  end
               else if ( rgEnterpriseType.ItemIndex=1) Then
                  begin
                     NomRecToRead := 0;
                     with EntExpendGridTableView.DataController do
                        begin
                           FocusedRecordIndex := 0;
                           if (RecordCount>0) then
                              begin
                                 if Numeric ( Values[0,EntExpendGridTableViewNo.Index ]) then
                                    NomRecToRead := StrToInt ( Values[0,EntExpendGridTableViewNo.Index ] );
                                 FillEnterpriseAccountPanel( NomRecToRead );
                              end;
                        end;
                  end;
            end;
      end;
end;

procedure TfmAccountSetup.FillEnterpriseAccountPanel ( RecToRead : Integer );
begin
   ClearEnterpriseAccountPanel;
   SetDb ( NlFile );
   If ( RecToRead > 0 ) And ( RecToRead <= db1.dbrechigh ) Then
      begin
         ReadRec ( NlFile, RecToRead );
         dberr;
         If Recactive ( NlFile ) Then
            begin
               EntAccount.Text := IntToStr ( RecToRead );
               GetItem ( NlFile, 1 );
               EntAccountName.Text := CurrStr;
               GetItem ( NlFile, 20 );
               EntAccountVATNo.Text := CurrStr;
               // Get the Current Records Product
               if NOT Cash11.xBilling then // Donot show the products
                  try
                      // Cancel in case they change record but click on the grid without
                      // Saving
                      AccsDataModule.NominalList.Cancel;
                      AccsDataModule.NominalList.Locate('Account',RecToRead,[] );
                  except

                  end;
               GetItem ( NlFile, 5 );
               EntAccountGroupNo.Text := IntToStr ( CurrInt );
               ReadTables ( NlFile, CurrInt, CurrStr );
               SlimAll ( CurrStr );
               EntAccountGroupDesc.Text := CurrStr;
//               EntNomRecNo := RecToRead;

                 // TGM AB 14/08/02 - Nominal type setup
               if accsdatamodule.LinkedToHerd then
                  begin
                     EntNominalTypeDropdown.visible := true;
                     EntTypeLabel.visible := true;
                     Getitem (Nlfile, 103);
                     if currstr = 'L' then
                        EntNominalTypeDropdown.ItemIndex := 1
                     else if currstr = 'P' then
                        EntNominalTypeDropdown.ItemIndex := 2
                     else if currstr = 'O' then
                        EntNominalTypeDropdown.ItemIndex := 3
                     else if currstr = 'U' then
                        EntNominalTypeDropdown.ItemIndex := 4
                     else
                        EntNominalTypeDropdown.ItemIndex := 0;
                   end  // if linked
               else
                   begin
                      EntNominalTypeDropdown.Visible := false;
                      EntTypeLabel.Visible := false;
                   end;   // end TGM AB
            end;
      end;
end;

procedure TfmAccountSetup.FillEnterpriseNomGrids(IncFrom, IncTo, ExpFrom,
  ExpTo: Integer);
var
   Loops,
   ArrPos,
   RecCounter,
   RecFrom,
   RecTo    : Integer;
begin
   SetDb ( NlFile );
   RecFrom := IncFrom;
   RecTo := IncTo;
   Loops := 1;
   ArrPos := 0;
   RecCounter := RecFrom;
   EntIncomeGridTableView.DataController.BeginUpdate;
   EntExpendGridTableView.DataController.BeginUpdate;
   try
      EntIncomeGridTableView.DataController.RecordCount := 0;
      EntExpendGridTableView.DataController.RecordCount := 0;

      If ( RecFrom > 0 ) Then
         repeat
            repeat
               ReadRec ( NlFile, RecCounter );
               dberr;
               if RecActive ( NlFile ) Then
                  begin
                     case Loops Of
                        1 : begin
                               EntIncomeGridTableView.DataController.RecordCount := EntIncomeGridTableView.DataController.RecordCount+1;
                               EntIncomeGridTableView.DataController.Values[arrpos, EntIncomeGridTableViewNo.Index] := PadString(IntToStr ( RecCounter ),'0',10);
                               GetItem ( NlFile, 1 );
                               EntIncomeGridTableView.DataController.Values[arrpos, EntIncomeGridTableViewName.Index] := CurrStr;
                            end;
                        2 : begin
                               EntExpendGridTableView.DataController.RecordCount := EntExpendGridTableView.DataController.RecordCount+1;
                               EntExpendGridTableView.DataController.Values[arrpos, EntExpendGridTableViewNo.Index] := PadString(IntToStr ( RecCounter ),'0',10);
                               GetItem ( NlFile, 1 );
                               EntExpendGridTableView.DataController.Values[arrpos, EntExpendGridTableViewName.Index] := CurrStr;
                            end;
                     end;
                     Inc ( ArrPos );
                  end;
               Inc ( RecCounter );
            until ( RecCounter > RecTo );
            Dec ( ArrPos );

            Inc ( Loops );
            RecFrom := ExpFrom;
            RecTo := ExpTo;
            ArrPos := 0;
            if RecFrom = 0 then Loops := 3;
            RecCounter := RecFrom;
         until (Loops > 2 );

   finally
      EntIncomeGridTableView.DataController.EndUpdate;
      EntExpendGridTableView.DataController.EndUpdate;

      if EntIncomeGridTableView.DataController.RecordCount > 0 then
         EntIncomeGridTableView.DataController.FocusedRecordIndex := 0;

      if EntExpendGridTableView.DataController.RecordCount > 0 then
         EntExpendGridTableView.DataController.FocusedRecordIndex := 0;
   end;
end;

procedure TfmAccountSetup.PageControlPageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  inherited;
  if (NewPage<>nil) and (NewPage.PageIndex in [tsNominalAccounts.PageIndex,tsEnterprises.PageIndex]) then
     begin
        if not validpassword then
           AllowChange := PasswordPrompt;
     end;
end;

function TfmAccountSetup.PasswordPrompt: boolean;
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
    MessageDlg('Do not modify Nominal Ledger Codes '+#13#10+
               'before getting advice from your Accountant or Kingswood Personnel',mtWarning,[mbOK],0);
end;

procedure TfmAccountSetup.EntIncomeGridTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  inherited;
  // Cancel any unsaved changes
  // CancelEntAccountClick(Sender);
  if AFocusedRecord <> nil then
     begin
        AddAmendDeleteEnt := '';
        AddAmendDelete := '';
        if rgEnterpriseType.ItemIndex <> 0 then
           rgEnterpriseType.ItemIndex := 0
        else
           rgCustomerSupplierPropertiesChange(rgEnterpriseType);
     end;
end;

procedure TfmAccountSetup.EntExpendGridTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  inherited;
  // Cancel any unsaved changes
  // CancelEntAccountClick(Sender);
  if AFocusedRecord <> nil then
     begin
        AddAmendDeleteEnt := '';
        AddAmendDelete := '';
        if rgEnterpriseType.ItemIndex <> 1 then
           rgEnterpriseType.ItemIndex := 1
        else
           rgCustomerSupplierPropertiesChange(rgEnterpriseType);
     end;
end;

procedure TfmAccountSetup.EntGridTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
var
   RecToRead : Integer;
begin
  inherited;
  if AFocusedRecord <> nil then
     begin
        AddAmendDeleteEnt := '';
        AddAmendDelete := '';
        RecToRead := 0;
        with EntGridTableView.DataController do
           begin
              if Numeric ( Values[FocusedRecordIndex, EntGridTableViewNo.Index]) Then
                 RecToRead := StrToInt ( Values[FocusedRecordIndex, EntGridTableViewNo.Index]);
              If RecToRead <> 0 Then
                 FillEnterprisePanel ( RecToRead );
           end;
     end;
end;

procedure TfmAccountSetup.actEntHelpExecute(Sender: TObject);
begin
  inherited;
  Application.HelpContext(226);
end;

procedure TfmAccountSetup.actEntSaveExecute(Sender: TObject);
begin
  inherited;
  if cash1.xyearend = true then begin
     if messagedlg('You are making changes to an archive set of accounts, are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrno then exit;
  end;
  EntIncomeFrom.enabled:=false;
  EntIncomeTo.enabled:=false;
  EntExpendFrom.enabled:=false;
  EntExpendTo.enabled:=false;
  if EntCheckBeforeSave ( Sender ) Then
     Begin
         SaveEnterpriseAccount;
         AddAmendDeleteEnt    := '';
         actEntAdd.Enabled := True;
     End;
  actEntCancel.Enabled := false; // TGM AB 4/06/02

end;

function TfmAccountSetup.EntCheckBeforeSave(Sender: TObject): Boolean;
var
   TestNum : LongInt;
   TestStr : ShortString;
begin
   Result := False;
   TestNum := 0;
   { Test all vital fields before Saving }
   if ( not btnEntCancel.Focused ) Then
      begin
         TestStr := EntCode.Text;
         SlimAll ( TestStr );
         If ( Length ( TestStr ) = 0 ) Then
            begin
               MessageDlg('Enterprise has no Name', mtInformation, [mbOk], 0);
               MyFocusControl(EntName);
            end
         else
            begin
               TestStr := NoOfIncomeAccounts.Text;
               SlimAll ( TestStr );
               if Numeric ( TestStr ) Then
                  TestNum := StrToInt ( TestStr );
               if ( TestNum = 0 ) Then
                  begin
                     MessageDlg('No Of Income Accounts cannot be 0', mtInformation, [mbOk], 0);
                     MyFocusControl(NoOfIncomeAccounts);
                  end
               else
                  begin
                     TestStr := NoOfExpendAccounts.Text;
                     SlimAll ( TestStr );
                     if Numeric ( TestStr ) then
                        TestNum := StrToInt ( TestStr );
                     if ( TestNum = 0 ) Then
                        begin
                             MessageDlg('No Of Expenditure Accounts cannot be 0', mtInformation, [mbOk], 0);
                             MyFocusControl(NoOfExpendAccounts);
                        end
                     else
                        Result := True;
                  end;
            end;
      end;
end;

procedure TfmAccountSetup.SaveEnterpriseAccount;
Var
    TestCode : ShortString;

    Procedure RefreshNominalAccounts;
    Var
       ValueOfPos,
       Loops,
       RecCounter,
       ArrFrom,
       ArrTo,
       IncFrom,
       IncTo,
       ExpFrom,
       ExpTo    : Integer;
    Begin
         IncFrom := StrToInt ( EntIncomeFrom.Text );
         IncTo   := StrToInt ( EntIncomeTo.Text );
         ArrFrom := IncFrom;
         ArrTo   := IncTo;
         ExpFrom := StrToInt ( EntExpendFrom.Text );
         ExpTo   := StrToInt ( EntExpendTo.Text );
         SetDb ( NlFile );
         Loops := 1;
         Repeat
            If ( ArrFrom > 0 ) Then
               For RecCounter := ArrFrom To ArrTo Do
                   Begin
                        ReadRec ( NlFile, RecCounter );
                        dberr;
                        If RecActive ( NlFile ) Then
                           Begin
                                PutStr ( NlFile, TestCode, 24 );
                                ReWriteRec ( NlFile, RecCounter );
                                dberr;
                           End;
                   End;

               Inc ( Loops );
               ArrFrom := ExpFrom;
               ArrTo   := ExpTo;
         Until ( Loops > 2 );

{-->>         ArrFrom := 1;}
         ArrTo := NomAccsGridTableView.DataController.RecordCount;
         RecCounter := 0;
         If AddAmendDeleteEnt <> 'ADD' Then
            While RecCounter <= ArrTo-1 Do
               Begin
                    ValueOfPos := StrToInt (  NomAccsGridTableView.DataController.Values[RecCounter, NomAccsGridTableViewNo.Index] );
                    If (( ValueOfPos >= IncFrom ) And
                        ( ValueOfPos <= IncTo )) Or
                       (( ValueOfPos >= ExpFrom ) And
                        ( ValueOfPos <= ExpTo )) Then
                        NomAccsGridTableView.DataController.Values[RecCounter, NomAccsGridTableViewEnt.Index] := TestCode;
                    Inc ( RecCounter );
                    If ValueOfPos >= ExpTo Then
                       RecCounter := ArrTo+1;
               End;
    End;

begin
   RecNo := EnterpriseAccountNo;
   if ( RecNo > 0 ) then
      Begin
         ReadRec ( cDb, RecNo );
         dberr;

         PutStr ( cDb, EntCode.Text, 1 );
         CurrStr := EntName.Text;
         PadRight ( CurrStr, 17 );
         EntName.Text := CurrStr;
         CurrStr := EntPercOverheads.Text;
         PadRight ( CurrStr, 3 );
         EntName.Text := EntName.Text + CurrStr;

         PutStr ( cDb, EntName.Text, 2 );
         StrLong ( EntUnitDiv.Text, CurrLong );
         PutItem ( cDb, 3 );
         PutStr ( cDb, EntUnitName.Text, 4 );
         PutInt ( cDb, StrToInt ( EntIncomeFrom.Text ), 6 );
         PutInt ( cDb, StrToInt ( EntIncomeTo.Text ), 7 );
         PutInt ( cDb, StrToInt ( EntExpendFrom.Text ), 8 );
         PutInt ( cDb, StrToInt ( EntExpendTo.Text ), 9 );

         ReWriteRec ( cDb, RecNo );
         dberr;

         TestCode := EntCode.Text;
         SlimAll ( TestCode );
         SlimAll ( OrigEntCode );
         If TestCode <> OrigEntCode Then
            RefreshNominalAccounts;

         FillEnterpriseGrid;
         {
         Set the focus to the new record
         SetUpAccounts.EntGrid.TopRow := SetUpAccounts.EntGrid.RowCount-1;
         }
      end;
end;

procedure TfmAccountSetup.actEntDeleteExecute(Sender: TObject);
begin
  inherited;
  DeleteEnterprise;
  actEntAdd.Enabled := True;

end;

procedure TfmAccountSetup.DeleteEnterprise;
Var
   OkToDelete : Boolean;
   IncFrom,
   IncTo,
   ExpFrom,
   ExpTo      : Integer;

begin
   OkToDelete := True;
   RecNo := EnterpriseAccountNo;
   if ( RecNo > 0 ) then
      Begin
           SetDb ( cDb );
           ReadRec ( cDb, RecNo );
           dberr;

           GetInt ( cDb, 6, IncFrom );
           GetInt ( cDb, 7, IncTo );
           GetInt ( cDb, 8, ExpFrom );
           GetInt ( cDb, 9, ExpTo );

           OkToDelete := CheckForDelete ( IncFrom, IncTo, OkToDelete );
           OkToDelete := CheckForDelete ( ExpFrom, ExpTo, OkToDelete );

           if OkToDelete then
              begin
                 if MessageDlg('Delete Account ' + EnterpriseAccountCode + ' ' + CustomerSupplierName, mtInformation, [mbYes, mbNo], 0) = mrYes then
                      begin
                         DeleteRecord ( cDb, Recno, False );
                         DeleteNomRecords ( IncFrom, IncTo, 'I' );
                         DeleteNomRecords ( ExpFrom, ExpTo, 'E' );
                         FillEnterpriseGrid; { Refresh the Nominal Grid }
                     end;
              end
           else
               MessageDlg('This Account has Active Details - Delete Rejected',
                                mtInformation, [mbOk], 0);
      end;
end;

function TfmAccountSetup.GetEnterpriseAccountNo: Integer;
var
   tResult : Variant;
begin
   Result := 0;
   with EntGridTableView.DataController do
      begin
         tResult :=  Values[FocusedRecordIndex,EntGridTableViewNo.Index];
         if not VarIsNull(tResult) then
            Result := tResult;
      end;
end;

function TfmAccountSetup.GetEnterpriseAccountName: string;
var
   tResult : Variant;
begin
   Result := '';
   with EntGridTableView.DataController do
      begin
         tResult :=  Values[FocusedRecordIndex,EntGridTableViewName.Index];
         if not VarIsNull(tResult) then
            Result := tResult;
      end;
end;

function TfmAccountSetup.GetEnterpriseAccountCode: string;
var
   tResult : Variant;
begin
   Result := '';
   with EntGridTableView.DataController do
      begin
         tResult :=  Values[FocusedRecordIndex,EntGridTableViewEnt.Index];
         if not VarIsNull(tResult) then
            Result := tResult;
      end;
end;

function TfmAccountSetup.CheckForDelete(AccFrom, AccTo: Integer;
  var DelFlag: Boolean): Boolean;
var
   RecCounter : Integer;
begin
{-->>     CheckForDelete := DelFlag;}
   RecCounter := AccFrom;
   If DelFlag And ( RecCounter > 0 ) Then
      While RecCounter <=AccTo Do
          Begin
               ReadRec ( NlFile, RecCounter );
               dberr;
               If RecActive ( NlFile ) Then
                  Begin
                       GetItem ( NlFile, 2 );

                       DelFlag := ( CurrLong = 0 );
                       If DelFlag Then
                          Begin
                               GetItem ( NlFile, 14 );
                               DelFlag := ( Currint = 0 );
                               If DelFlag Then
                                  Begin
                                       GetItem ( NlFile, 15 );
                                       DelFlag := ( Currint = 0 );
                                  End;
                          End;
                       If NOT DelFlag Then { Record cannot be deleted }
                          RecCounter := AccTo;
                  End;
               Inc ( RecCounter );
          End;
   Result := DelFlag;
end;

procedure TfmAccountSetup.DeleteNomRecords(AccFrom, AccTo: Integer;
  IncOrExp: Char);
var
   CurrGroup,
   RecCounter : Integer;

   Procedure DeleteTable ( Cdb, CGroup : Integer );
   Var
      TabDesc : ShortString;
   Begin
        FillChar ( TabDesc[1], 32, ' ' );
        WriteTables ( cDb, CGroup, TabDesc );
   End;

begin
   SetDb ( NlFile );
   if ( AccFrom > 0 ) then
      for RecCounter := AccFrom to AccTo do
          begin
            ReadRec ( NlFile, RecCounter );
            dberr;
            if RecActive ( NlFile ) then
               begin
                    GetInt ( NlFile, 5, CurrGroup );
                    DeleteRecord ( NlFile, RecCounter, False );
                    case IncOrExp of
                         'I' : if ( not GroupInUse ( NlFile, CurrGroup, Cash1.xNomIncFrom, Cash1.xNomIncTo )) then
                                     DeleteTable ( NlFile, CurrGroup );
                         'E' : if ( not GroupInUse ( NlFile, CurrGroup, Cash1.xNomExpFrom, Cash1.XNomExpTo )) then
                                     DeleteTable ( NlFile, CurrGroup );
                    end;
               end;
          end;
end;

function TfmAccountSetup.DuplicatesFound(TestStr: String;
  CurrRecNo: Integer): Boolean;
var
   RecCounter,
   LastEnt : Integer;
   FoundDup : Boolean;
begin
   SetDb ( cDb );
   LastEnt := db1.dbrechigh;
{-->>     DuplicatesFound := False;}
   FoundDup := False;
   RecCounter := 1;

   while RecCounter <= LastEnt Do
      begin
         if ( RecCounter <> CurrRecNo ) then
            begin
               ReadRec ( cDb, RecCounter );
               dberr;
               if RecActive ( cDb ) then
                  begin
                     GetItem ( cDb, 1 );
                     SlimAll ( CurrStr );
                     FoundDup := ( CurrStr = TestStr );
                     if FoundDup then
                        RecCounter := LastEnt;
                  end;
            end;
         Inc ( RecCounter );
       end;
   DuplicatesFound := FoundDup;
end;

function TfmAccountSetup.GroupInUse(Cdb, CGroup, rfrom,
  rto: Integer): Boolean;
Var
   Counter : Integer;
Begin
     Result := False;
     If (( CGroup >= rfrom ) And
	 ( CGroup <= rto )) Then
	Begin
	   For counter := rfrom To rto Do
	      Begin
		 Readrec ( Cdb, counter );
		 If recactive ( Cdb ) Then
		    Begin
		       getitem ( Cdb, 5 );
		       If ( currint = CGroup ) Then
			  Begin
			     Result := True;
			     Exit;
			  End;
		    End;
	      End;
	End
     Else
	If (( CGroup >= rfrom ) And
	    ( CGroup <= rto )) Then
	   Begin
	      For counter := rfrom To rto Do
		 Begin
		    Readrec ( Cdb, counter );
		    If recactive ( Cdb ) Then
		       Begin
			  getitem ( Cdb, 5 );
			  If ( currint = CGroup ) Then
			     Begin
				Result := True;
				Exit;
			     End;
		       End;
		 End;
	   End;
end;

procedure TfmAccountSetup.actEntAddExecute(Sender: TObject);
begin
  inherited;
  If ( AddAmendDeleteEnt <> 'ADD' ) Then
     Begin
         actEntAdd.Enabled := False;
         AddAmendDelete := '';
         AddAmendDeleteEnt := 'ADD';
         AddEnterpriseAccount;
     End;
  actEntCancel.Enabled := true; // TGM AB 4/06/02
end;

procedure TfmAccountSetup.AddEnterpriseAccount;
Var
   AccNo : Integer;
   RecCount,
   LastEnt     : Integer;
   NewRecFound : Boolean;
Begin
   SetDb ( cDb );
   LastEnt := db1.dbrectot;
   AccNo := 0;
   RecCount := 1;
   NewRecFound := False;
   repeat
      If ( RecCount > 0 ) Then
         Begin
              ReadRec ( cDb, RecCount );
              dberr;
              NewRecFound := ( NOT RecActive ( cDb ));
         End;
      Inc ( RecCount );
   until ( RecCount <= 0 ) Or ( RecCount > LastEnt ) Or NewRecFound;
   Dec ( RecCount );
   if NewRecFound then
      begin
         AccNo := RecCount;
         If ( AccNo > 0 ) Then
            begin
  //             AccNo := db1.dbrechigh+1;
               BlankRec ( cDb, 'A' );
               AddRecord ( cDb, AccNo, False );
  //             Readrec(SetUpAccounts.cDb, AccNo);
               FillEnterprisePanel(AccNo);
               MyFocusControl(EntCode);
            end;
      end
   else
       MessageDlg('No Free Records Available', mtInformation, [mbOk], 0)
end;

procedure TfmAccountSetup.actEntCancelExecute(Sender: TObject);
begin
  inherited;
  EntIncomeFrom.enabled:=false;
  EntIncomeTo.enabled:=false;
  EntExpendFrom.enabled:=false;
  EntExpendTo.enabled:=false;
  CancelNewEnterpriseAccount;
  actEntAdd.Enabled := True;
  actEntCancel.Enabled := false; // TGM AB 4/06/02

end;

procedure TfmAccountSetup.CancelEnterprise;
var
   TempStr : ShortString;
begin
   If AddAmendDeleteEnt = 'ADD' Then
      begin
         RecNo := EnterpriseAccountNo;
         if (RecNo>0) then
            DeleteRecord ( cDb, RecNo, False );
      end;
   AddAmendDeleteEnt := '';
   AddAmendDelete := '';
   EntGridTableView.DataController.FocusedRecordIndex := 0;
   TempStr := IntToStr(EnterpriseAccountNo);
   SlimAll ( TempStr );
   If Numeric ( TempStr ) Then
      FillEnterprisePanel ( StrToInt ( TempStr ));
end;

procedure TfmAccountSetup.actEntAccountHelpExecute(Sender: TObject);
begin
  inherited;
  Application.HelpContext(8);
end;

procedure TfmAccountSetup.actEntAccountSaveExecute(Sender: TObject);
var TestStr : Shortstring;
    GroupStr : Shortstring;
    NomTypeStr : char;
begin
   inherited;
   if cash1.xyearend = true then begin
      if messagedlg('You are making changes to an archive set of accounts, are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrno then exit;
   end;AddAmendDelete := '';
   AddAmendDeleteEnt := '';
   if (EntNominalTypeDropdown.ItemIndex <> 0) then begin
        if EntNominalTypeDropdown.ItemIndex = 1 then NomTypeStr := 'L';
        if EntNominalTypeDropdown.ItemIndex = 2 then NomTypeStr := 'P';
        if EntNominalTypeDropdown.ItemIndex = 3 then NomTypeStr := 'O';
        if EntNominalTypeDropdown.ItemIndex = 4 then NomTypeStr := 'U';
        if NomTypeStr <> '' then begin
                                 currdisp[1] := NomTypeStr;
                                 putitem(NLFile,103);
                                 end;
   end;
   TestStr := EntAccountName.Text;
   Slimall(TestStr);
   begin
        GroupStr := EntAccountGroupDesc.Text;
        SlimAll(GroupStr);
        if Length(GroupStr) = 0 then
        EntAccountGroupDesc.Text:= TestStr;
   end;
   SaveEnterpriseNominalAccount;
   actEntAccountAdd.Enabled := True;
   actEntAccountCancel.Enabled := False;             // TGM AB 31/5/02
end;

procedure TfmAccountSetup.SaveEnterpriseNominalAccount;
begin
   RecNo := EnterpriseAccountNo;
   if ( RecNo > 0 ) then
      begin
         ReadRec ( NlFile, RecNo );
         dberr;

         PutStr ( NlFile, EntAccountName.Text, 1 );
         CurrInt := StrToInt ( EntAccountGroupNo.Text );
         PutItem ( NlFile, 5 );

         if NOT Cash11.xBilling then // Donot show the products
            try
               if AccsDatamodule.NominalList.State in dsEditmodes then
                  AccsDataModule.NominalList.Post;
               if AccsDataModule.Products.FieldByName('ID').AsFloat > 0 then
                  begin
                     SetItem;
                     CurrLong := AccsDataModule.Products.FieldByName('ID').AsInteger;
                     PutItem (NLFile,6);
                  end;
            except
               ShowMessage('Cannot add Product to Nominal Account');
            end;

         CurrInt := StrToInt ( EntAccountGroupNo.Text );
         CurrStr := EntAccountGroupDesc.Text;
         WriteTables ( NlFile, CurrInt, CurrStr );
         PutStr ( NlFile, EntAccountVatNo.Text, 20 );
         PutStr ( NlFile, EntCode.Text, 24 );

         Rewriterec ( NlFile, RecNo );
         dberr;

         with EntGridTableView.DataController do
            begin
               if RecordCount>0 then
                  begin
                     If Numeric ( Values[FocusedRecordIndex, EntGridTableViewNo.Index]) Then
                        FillEnterprisePanel ( StrToint(Values[FocusedRecordIndex, EntGridTableViewNo.Index]));
                  end;
            end;
      end;

end;

procedure TfmAccountSetup.actEntAccountDeleteExecute(Sender: TObject);
begin
  inherited;
  DeleteEnterpriseNominalAccount;
  if (rgEnterpriseType.ItemIndex=0) Then
     EntIncomeGridTableView.Controller.FocusedRecordIndex := 0
  Else if (rgEnterpriseType.ItemIndex=1) Then
     EntExpendGridTableView.Controller.FocusedRecordIndex := 0;
  actEntAccountAdd.Enabled := True;
end;

procedure TfmAccountSetup.DeleteEnterpriseNominalAccount;
var
   OkToDelete  : Boolean;
   AccToDelete : Integer;
begin
   OktoDelete := True;
   AccToDelete := StrToInt ( EntAccount.Text );

   if CheckForDelete ( AccToDelete, AccToDelete, OkToDelete ) then
      begin
         if (rgEnterpriseType.ItemIndex=0) then
            begin
                 If MessageDlg('Delete Account ' +
                    EntAccount.Text + ' ' +
                    EntAccountName.Text,
                    mtInformation, [mbYes, mbNo], 0) = mrYes  then
                    DeleteNomRecords ( AccToDelete, AccToDelete, 'I' );
            end
         else if (rgEnterpriseType.ItemIndex=1) then
            begin
                 if MessageDlg('Delete Account ' +
                    EntAccount.Text + ' ' +
                    EntAccountName.Text,
                    mtInformation, [mbYes, mbNo], 0) = mrYes  Then
                    DeleteNomRecords ( AccToDelete, AccToDelete, 'E' );
            end;
         FillEnterpriseNomGrids ( StrToInt ( EntIncomeFrom.Text ),
                                  StrToInt ( EntIncomeTo.Text ),
                                  StrToInt ( EntExpendFrom.Text ),
                                  StrToInt ( EntExpendTo.Text ))

      end
   else
       MessageDlg('This Account has Active Details - Delete Rejected', mtInformation, [mbOk], 0);
end;

procedure TfmAccountSetup.EntCodeEnter(Sender: TObject);
begin
  inherited;
  If ( Length ( EntCode.Text ) = 0 ) Then
     actEntAdd.Execute;

end;

procedure TfmAccountSetup.EntCodeExit(Sender: TObject);
var
   TStr,
   TestStr : ShortString;
begin
  inherited;
  TestStr := EntCode.Text;
  SlimAll ( TestStr );
  If ( not btnEntCancel.Focused ) then
     begin
        if ( Length ( TestStr ) = 0 ) then
           begin
              MessageDlg('Enterprise has no Code', mtInformation, [mbOk], 0);
              MyFocusControl(EntCode);
           end
        else
           If AddAmendDeleteEnt = 'ADD' Then
              Begin
                 If DuplicatesFound ( TestStr, 0 ) Then
                    Begin
                       MessageDlg('Enterprise Code ' + TestStr + ' already Exists', mtInformation, [mbOk], 0);
                       EntCode.Text := OrigEntCode;
                       MyFocusControl(EntCode);
                    End
                 Else
                    begin
                       with EntGridTableView.DataController do
                          begin
                             TStr := Values[FocusedRecordIndex,EntGridTableViewNo.Index];
                             SlimAll ( TStr );
                             if Numeric ( TStr ) Then
                                if DuplicatesFound ( TestStr, StrToInt ( TStr )) Then
                                   begin
                                      MessageDlg('Enterprise Code ' + TestStr + ' already Exists', mtInformation, [mbOk], 0);
                                      EntCode.Text := OrigEntCode;
                                      MyFocusControl(EntCode);
                                   end;
                          end;
                    end;
              end;
     end;
end;

procedure TfmAccountSetup.EntUnitDivExit(Sender: TObject);
begin
  inherited;
  SetToLong ( EntUnitDiv );

end;

procedure TfmAccountSetup.NoOfIncomeAccountsDblClick(Sender: TObject);
begin
  inherited;
     EntIncomeFrom.enabled:=true;
     EntIncomeTo.enabled:=true;

end;

procedure TfmAccountSetup.NoOfIncomeAccountsExit(Sender: TObject);
var
   StartRec : Integer;
begin
  inherited;
  If NoOfIncomeAccounts.ModifiedAfterEnter Then
     Begin
        If Numeric ( NoOfIncomeAccounts.Text ) Then
           Begin
                If Not CheckAvailability ( StrToInt ( NoOfIncomeAccounts.Text ), 'I', StartRec ) Then
                   MyFocusControl(NoOfIncomeAccounts)
                Else
                   Begin
                        EntIncomeFrom.Text := IntToStr ( StartRec );
                        EntIncomeTo.Text := IntToStr (( StartRec )+ StrToInt ( NoOfIncomeAccounts.Text )-1);
                   End;
           End
        Else
            MyFocusControl(NoOfIncomeAccounts);
     End;

end;

procedure TfmAccountSetup.EntIncomeFromDblClick(Sender: TObject);
begin
  inherited;
     EntIncomeFrom.enabled:=true;

end;

procedure TfmAccountSetup.EntIncomeToDblClick(Sender: TObject);
begin
  inherited;
     EntIncomeTo.enabled:=true;

end;

procedure TfmAccountSetup.NoOfExpendAccountsDblClick(Sender: TObject);
begin
  inherited;
     EntExpendFrom.enabled:=true;
     EntExpendTo.enabled:=true;

end;

procedure TfmAccountSetup.NoOfExpendAccountsExit(Sender: TObject);
Var
   StartRec : Integer;
begin
  inherited;
  if NoOfIncomeAccounts.ModifiedAfterEnter then
     begin
        If Numeric ( NoOfExpendAccounts.Text ) Then
           Begin
                if not CheckAvailability ( StrToInt ( NoOfExpendAccounts.Text ), 'E', StartRec ) then
                   MyFocusControl(NoOfExpendAccounts)
                else
                   begin
                        EntExpendFrom.Text := IntToStr ( StartRec );
                        EntExpendTo.Text := IntToStr (( StartRec )+StrToInt ( NoOfExpendAccounts.Text )-1);
                   end;
           end
        else
            MyFocusControl(NoOfExpendAccounts);
     end;
end;

procedure TfmAccountSetup.EntExpendFromDblClick(Sender: TObject);
begin
  inherited;
  EntExpendFrom.enabled:=true;
end;

procedure TfmAccountSetup.EntExpendToDblClick(Sender: TObject);
begin
  inherited;
  EntExpendTo.enabled:=true;
end;

procedure TfmAccountSetup.EntAccountGroupNoPropertiesChange(
  Sender: TObject);
begin
  inherited;
  ReadTables ( NlFile, KStrToInt ( EntAccountGroupNo.Text ), CurrStr );
  EntAccountGroupDesc.Text := CurrStr;
end;

procedure TfmAccountSetup.EntAccountGroupNoDblClick(Sender: TObject);
begin
  inherited;
  actReportGroupSelect.Execute;
end;

procedure TfmAccountSetup.EntAccountVatNoDblClick(Sender: TObject);
begin
  inherited;
  actVATCodeSelect.Execute;

end;

procedure TfmAccountSetup.EntAccountGroupNoPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if (AButtonIndex=0) then
     actReportGroupSelect.Execute;
end;

procedure TfmAccountSetup.EntAccountVatNoPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  inherited;
  if (AButtonIndex=0) then
     actVATCodeSelect.Execute;
end;

procedure TfmAccountSetup.EntAccountNameExit(Sender: TObject);
var
   TestStr : ShortString;
begin
   inherited;
   TestStr := EntAccountName.Text;
   SlimAll ( TestStr );
   If ( Length ( TestStr ) = 0 ) And
      ( NOT btnEntAccountCancel.Focused ) Then
      Begin
           MessageDlg('Accounts has no Name', mtInformation, [mbOk], 0);
           EntAccountName.SetFocus;
      End;

end;

procedure TfmAccountSetup.CancelEnterpriseNominalAccount;
begin
   if AddAmendDelete = 'ADD' then
      begin
         RecNo := EnterpriseAccountNo;
         if (RecNo>0) then
            DeleteRecord ( NLFile, RecNo, False );
      end;
   AddAmendDelete := '';
   AddAmendDeleteEnt := '';

   ClearEnterpriseAccountPanel;
   if (rgEnterpriseType.ItemIndex =0) then
      begin
         with EntIncomeGridTableView.DataController do
            begin
               FocusedRecordIndex := 0;
               if Numeric(Values[FocusedRecordIndex, EntIncomeGridTableViewNo.index]) then
                  FillEnterpriseAccountPanel(Values[FocusedRecordIndex, EntIncomeGridTableViewNo.index]);

            end;
      end
   else if (rgEnterpriseType.ItemIndex =1) then
      begin
         with EntExpendGridTableView.DataController do
            begin
               FocusedRecordIndex := 0;

               if Numeric(Values[FocusedRecordIndex, EntExpendGridTableViewNo.index]) then
                  FillEnterpriseAccountPanel(Values[FocusedRecordIndex, EntExpendGridTableViewNo.index]);
            end;
      end;
end;

procedure TfmAccountSetup.AddEnterpriseNominalAccount;
var
   AccNo : Integer;
begin
   AccNo := 0;
   if (rgEnterpriseType.ItemIndex=0) then
      AccNo := GetNextFreeAccount ( NlFile, GetEnterpriseAccountRanges )
   else if (rgEnterpriseType.ItemIndex=1) then
      AccNo := GetNextFreeAccount ( NlFile, GetEnterpriseAccountRanges )
   else
      MessageDlg('Select Account Type', mtInformation, [mbOk], 0);

   ClearEnterpriseAccountPanel;
   if (AccNo > 0) then
      begin
         BlankRec ( NlFile, 'A' );
         AddRecord ( NlFile, AccNo, False );
         FillEnterpriseAccountPanel( AccNo );
         MyFocusControl(EntAccountName);
      end
   else
      begin
         SetDB(NlFile);
         AddAmendDelete := '';
         actEntAccountAdd.Enabled := False;
      end;
end;

function TfmAccountSetup.GetEnterpriseAccountRanges: TAccRange;
begin
   Result[1] := 0;
   Result[2] := 0;
   Result[3] := 0;
   Result[4] := 0;
   Result[5] := 0;
   Result[6] := 0;

   if (rgEnterpriseType.ItemIndex=0) then
      begin
         if NewListBox.ListInfo.ListType = 'G' then
            begin
               Result[1] := Cash1.XnomIncFrom;
               Result[2] := Cash1.XnomIncTo;
            end
         else
             begin
                Result[1] := StrToInt ( EntIncomeFrom.Text );
                Result[2] := StrToInt ( EntIncomeTo.Text );
             end
      End
   else if (rgEnterpriseType.ItemIndex=1) then
      begin
         if NewListBox.ListInfo.ListType = 'G' then
            begin
               Result[1] := Cash1.XnomExpFrom;
               Result[2] := Cash1.XnomExpTo;
            end
         else
             begin
                Result[1] := StrToInt ( EntExpendFrom.Text );
                Result[2] := StrToInt ( EntExpendTo.Text );
             end;
      End;

end;

procedure TfmAccountSetup.actEntAccountAddExecute(Sender: TObject);
begin
  inherited;
  actEntAccountAdd.Enabled := False;
  AddAmendDelete    := 'ADD';
  AddAmendDeleteEnt := '';
  AddEnterpriseNominalAccount;
  EntAccountGroupNo.text := EntAccount.text;
  AccsDataModule.NomListOk := FALSE;
  if (AddAmendDelete = 'ADD') then actEntAccountAdd.Enabled := true;             // TGM AB 31/5/02
end;

procedure TfmAccountSetup.CancelNewEnterpriseAccount;
begin
   CancelEnterprise;
end;

function TfmAccountSetup.CheckAvailability(NoRequested: Integer;
  AccountType: Char; var StartRec: Integer): Boolean;
var
   RequestOK,
   RecInUse : Boolean;
   CheckFrom,
   CheckTo,
   OriginalDiff,
   RecCounter,
   EndRec,
   Highest : Integer;
   TempStr : ShortString;
begin
   CheckAvailability := False;
   Highest := 0;
   StartRec := 0;
   RecInUse := False;
   CheckFrom := 0;
   OriginalDiff := 0;

   if ( AddAmendDeleteEnt = 'ADD' ) and ( NoRequested > 0 ) then
       begin
          SetDb ( cDb );
          if ( AccountType = 'I' ) then
             Highest := 0
          else
             Highest := Cash1.xNomExpFrom-1;

          for RecCounter := 1 to db1.dbrechigh do
             begin
                ReadRec ( cDb, RecCounter );
                dberr;
                if RecActive ( cDb ) then
                   begin
                      if ( AccountType = 'I' ) then
                         GetItem ( cDb, 7 )
                      else if ( AccountType = 'E' ) then
                         GetItem ( cDb, 9 );

                      if ( CurrInt > Highest ) then
                         Highest := Currint;
                   end;
             end;
          Inc ( Highest );
       end
       { Amending Old Enterprise Record Need to Check Ranges }
   else if ( NoRequested > 0 ) then
      begin
         if AccountType = 'I' then
            begin
               TempStr := EntIncomeTo.Text;
               SlimAll ( TempStr );
               CheckFrom := StrToInt ( TempStr )+1;
               OriginalDiff := ( StrToInt ( EntIncomeTo.Text ) -
                                 StrToInt ( EntIncomeFrom.Text ))+1;
               Highest := StrToInt ( EntIncomeFrom.Text );
            end
         else if AccountType = 'E' then
            begin
               TempStr := EntExpendTo.Text;
               SlimAll ( TempStr );
               CheckFrom := StrToInt ( TempStr )+1;
               OriginalDiff := ( StrToInt ( EntExpendTo.Text ) -
                                 StrToInt ( EntExpendFrom.Text ))+1;
               Highest := StrToInt ( EntExpendFrom.Text );
            end;
         CheckTo := CheckFrom + ( NoRequested - OriginalDiff )-1;
         SetDb ( NlFile );
         for RecCounter := CheckFrom to CheckTo do
            if ( not RecInUse ) then
               begin
                  ReadRec ( NlFile, RecCounter );
                  dberr;
                  if RecActive ( NlFile ) then
                     RecInUse := True;
               end;
      end;

    EndRec := (Highest-1) + NoRequested;
    RequestOk := (( AccountType = 'I' ) and
                  ( Highest <= Cash1.xNomIncTo ) and
                  ( EndRec <= Cash1.xNomIncTo )) or
                 (( AccountType = 'E' ) and
                  ( Highest >= Cash1.xNomExpFrom ) and
                  ( Highest <= Cash1.xNomExpTo ) and
                  ( EndRec <= Cash1.xNomExpTo ));

    if RequestOk then
       if (( NoRequested <= Highest ) and ( NoRequested > 0 )) or
          (( NoRequested > 0 ) and ( not RecInUse )) then
          begin
             StartRec := Highest;
             CheckAvailability := ( not RecInUse );
          end;
end;

procedure TfmAccountSetup.actEntAccountCancelExecute(Sender: TObject);
begin
  inherited;
  CancelEnterpriseNominalAccount;
  actEntAccountAdd.Enabled := True;
  AccsDataModule.NomListOk := TRUE;
  actEntAccountCancel.Enabled := false;             // TGM AB 31/5/02
end;

procedure TfmAccountSetup.EntAccountVatNoExit(Sender: TObject);
Var
   ArrPos : Integer;
begin
  inherited;
  if not NewListBox.CheckVat ( ( Sender As TcxTextEdit).Text, ArrPos ) then
     MyFocusControl(Sender as TcxTextEdit);

end;

procedure TfmAccountSetup.ShowCurrentClick(Sender: TObject);
begin
  inherited;
  {RecNo := NominalAccountNo;
  if (RecNo>0) then
      FillNominalPanel(RecNo);}
end;

procedure TfmAccountSetup.ShowOpeningClick(Sender: TObject);
begin
  inherited;
  {RecNo := NominalAccountNo;
  if (RecNo>0) then
      FillNominalPanel(RecNo);}
end;

procedure TfmAccountSetup.actCurrentOpeningBalanceExecute(Sender: TObject);
begin
  inherited;
  RecNo := NominalAccountNo;
  if (RecNo>0) then
      FillNominalPanel(RecNo);
end;

procedure TfmAccountSetup.EntIncomeGridEnter(Sender: TObject);
begin
  inherited;
  rgEnterpriseType.ItemIndex := 0;
end;

procedure TfmAccountSetup.EntExpendGridEnter(Sender: TObject);
begin
  inherited;
  rgEnterpriseType.ItemIndex := 1;
end;

procedure TfmAccountSetup.ClearEnterpriseAccountPanel;
begin
   EntAccount.Text := '';
   EntAccountName.Text := '';
   EntAccountVATNo.Text := '';
   EntAccountGroupNo.Text := '';
   EntAccountGroupDesc.Text := '';
   EntNominalTypeDropdown.ItemIndex := -1;
   cbProductsEnts.EditValue := Null;
end;

end.
