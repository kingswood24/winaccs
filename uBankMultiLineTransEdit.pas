{
   23/11/18 [V4.3 R2.9] /MK Additional Feature - Allow "Overwrite of Nominal Description" prompt to appear after selecting nominal and preference is on - Scott Mernagh.
}

unit uBankMultiLineTransEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxControls, cxContainer, cxEdit, cxGroupBox, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxCurrencyEdit, StdCtrls, cxButtons,
  cxTextEdit, cxLabel, AccsData, cxMaskEdit, cxButtonEdit, cxDBEdit,
  Types, ActnList, db, cxCustomData, cxHint, cxDropDownEdit, ExtCtrls,
  Calcs, uTransactionNominalFreeTextDescriptionInput;

const
   WM_INVOKESEARCHITEM = WM_USER+1;
   WM_BEGINEDITING = WM_USER+2;
   WM_CHECK_GRID_AMOUNTS = WM_USER+3;
type
  TBankMultiLineTransEditForm = class(TForm)
    gbTransactionOptions: TcxGroupBox;
    cxGroupBox1: TcxGroupBox;
    DeleteLineButton: TcxButton;
    CloseButton: TcxButton;
    BankImportGrid: TcxGrid;
    BankImportGridTableView: TcxGridDBTableView;
    BankImportGridTableViewImport: TcxGridDBColumn;
    BankImportGridTableViewTransactionType: TcxGridDBColumn;
    BankImportGridTableViewTxDate: TcxGridDBColumn;
    BankImportGridTableViewDetails: TcxGridDBColumn;
    BankImportGridTableViewStubNumber: TcxGridDBColumn;
    BankImportGridTableViewIncomeOrExpense: TcxGridDBColumn;
    BankImportGridTableViewAmount: TcxGridDBColumn;
    BankImportGridTableViewVATCode: TcxGridDBColumn;
    BankImportGridTableViewNominalName: TcxGridDBColumn;
    BankImportGridTableViewEnterprise: TcxGridDBColumn;
    BankImportGridTableViewCustSuppName: TcxGridDBColumn;
    BankImportGridTableViewAnalysis: TcxGridDBColumn;
    BankImportGridLevel: TcxGridLevel;
    AddLineButton: TcxButton;
    ActionList1: TActionList;
    actAddLine: TAction;
    actDeleteLine: TAction;
    actClose: TAction;
    cxLabel1: TcxLabel;
    HelpLabel: TcxLabel;
    DescriptionLabel: TcxLabel;
    Label22: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    DateLabel: TcxLabel;
    AmountLabel: TcxLabel;
    RemainingBalanceLabel: TcxLabel;
    BankImportGridTableViewQuantity: TcxGridDBColumn;
    HideHintTimer: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actAddLineExecute(Sender: TObject);
    procedure actAddLineUpdate(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TransactionAmountCurrencyEditExit(Sender: TObject);
    procedure NominalAccountButtonEditExit(Sender: TObject);
    procedure actDeleteLineUpdate(Sender: TObject);
    procedure actDeleteLineExecute(Sender: TObject);
    procedure BankImportGridTableViewDataControllerSummaryAfterSummary(
      ASender: TcxDataSummary);
    procedure FormCreate(Sender: TObject);
    procedure BankImportGridTableViewKeyPress(Sender: TObject;
      var Key: Char);
    procedure BankImportGridTableViewEditValueChanged(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
    procedure BankImportGridTableViewCellDblClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure BankImportGridTableViewInitEdit(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit);
    procedure BankImportGridTableViewEditKeyDown(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
    procedure HideHintTimerTimer(Sender: TObject);
    procedure BankImportGridTableViewFocusedItemChanged(
      Sender: TcxCustomGridTableView; APrevFocusedItem,
      AFocusedItem: TcxCustomGridTableItem);
  private
    function GetBankImportGridCell(Index: Integer): Variant;
    procedure SetBankImportGridCell(Index: Integer; const Value: Variant);
  private
    { Private declarations }
    FTransactionType : TTransactionType;
    FBookmark : TBookmark;
    FHintStyleController: TcxHintStyleController;
    FUsingVAT : Boolean;

    function GetCanAddLine: boolean;

    procedure FindAndPostNominal(const ASearchTextValue : string = '');
    procedure FindAndPostVATCode();
    procedure FindAndPostAnalysisCode();
    procedure StoreNominalSelection(const ANomCode : Integer);

    function ValidateTransactions() : Boolean;
    function FocusedColumnIndex : Integer;
    function FocusedColumnString : string;
    procedure RemoveErroneousTransactions();
    procedure Post();
    procedure Bookmark();
    procedure GoToBookmark();
    procedure AddLine();
    procedure DeleteLine();
    procedure InvokeQuantityScreen();
    procedure EditCBEQuantities(APoint : TPoint);
    procedure MyCellDoubleClick(Sender : TObject);
    procedure InvokeSearchItem(var Message:TMessage); message WM_INVOKESEARCHITEM;
    procedure BeginEditing(var Message:TMessage); message WM_BEGINEDITING;
    procedure RecalclateGridAmounts(var Message:TMessage); message WM_CHECK_GRID_AMOUNTS;

    procedure ButtonEditClick(Sender: TObject; AButtonIndex: Integer);
    procedure FocusItem(ACustomGridTableItem : TcxCustomGridTableItem; const AHintTitle, AHintText : string);
    procedure FocusControl(AControl : TControl; const AHintTitle, AHintText : string);
    procedure ShowHint(APoint : TPoint; const AHintTitle, AHintText : string);
    procedure RaiseValidationError(AErrorMessage: string; const AAbort: Boolean);
    procedure HideHint();
    procedure InvokeGridCellSearch;
    procedure NomNameChange(Sender : TField);
    procedure ButtonEditOnChange(sender : TObject);
    procedure CheckAmount();
    procedure EditNominalFreeTextDescription();overload;
    procedure EditNominalFreeTextDescription(APoint : TPoint);overload;

    property CanAddLine : Boolean read GetCanAddLine;
    property BankImportGridCell[Index : Integer] : Variant read GetBankImportGridCell write SetBankImportGridCell;

  public
    { Public declarations }
    procedure EditTransaction(ATransactionType : TTransactionType);
  end;

var
  BankMultiLineTransEditForm: TBankMultiLineTransEditForm;

implementation

uses NewListing, VARS, uAccounts, uSetupAnalysis, uQuantityInput,
     uTransactionQuantityInput, Clears, DBGen, AccsUtils, uAccsSystem,
     uPreferences, uPreferenceConsts;

{$R *.DFM}

{ TBankMultiLineTransEditForm }

procedure TBankMultiLineTransEditForm.EditTransaction(ATransactionType : TTransactionType);
begin
   FTransactionType := ATransactionType;
   ShowModal;
end;

procedure TBankMultiLineTransEditForm.FormShow(Sender: TObject);
begin
   BankImportGridTableViewVATCode.Visible := FUsingVAT;
   if (AccsSystem.SystemType = stCashbook) then
       begin
          BankImportGridTableViewAnalysis.Visible := Preferences.ValueAsBoolean[cPref_ShowAnalysisCodeColumn];
          BankImportGridTableViewQuantity.Visible := Preferences.ValueAsBoolean[cPref_ShowQuantityColumn];
          BankImportGridTableViewStubNumber.Visible := Preferences.ValueAsBoolean[cPref_ShowStubNoColumn];
       end;

   BankImportGridTableView.DataController.DataSource := AccsDataModule.dsBankCSVDetailTempTableDB;
   if (AccsDataModule.BankCSVDetailTempTableDB.RecordCount = 0) then
      begin
         AddLine();
      end;

   Caption := Trim(AccsDataModule.BankCSVTempTableDB.FieldByName('Details').AsString);
   DescriptionLabel.Caption := Caption;
   try
       DateLabel.Caption := FormatDateTime('dd/mm/yyyy',
       AccsDataModule.BankCSVTempTableDB.FieldByName('TxDate').AsDateTime);
   except
   end;

   AmountLabel.Caption := Format('%.2f',[
     AccsDataModule.BankCSVTempTableDB.FieldByName('OriginalAmount').AsFloat
   ]);

   if (FTransactionType = ttExpense) then
      BankImportGridTableViewNominalName.Caption := 'Expense Account'
   else
      BankImportGridTableViewNominalName.Caption := 'Income Account';

   HelpLabel.Caption := Format('Select an %s from the grid below and enter the transaction amount.' + cCRLF +
                               'Please note: The total of all transactions below must equal the amount stated on the' + cCRLF +
                               'original bank transaction.',[BankImportGridTableViewNominalName.Caption]);
                               //; + cCRLF +
                               //'Use the information below to guide you through the transaction entry process.',[BankImportGridTableViewNominalName.Caption]);

   AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('NomName').OnChange := NomNameChange;
end;

procedure TBankMultiLineTransEditForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   AccsDatamodule.BankCSVTempTableDB.Edit;
   AccsDatamodule.BankCSVTempTableDB.FieldByName('IsMultiLineTransaction').AsBoolean :=
      AccsDatamodule.BankCSVDetailTempTableDB.RecordCount>0;

   HideHint();
   BankImportGridTableView.DataController.DataSource := nil;
   AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('NomName').OnChange := nil;
end;

procedure TBankMultiLineTransEditForm.FindAndPostNominal(const ASearchTextValue : string);
var
   IncomeStart, ExpenseStart : Integer;
   Point : TPoint;
begin
   Point.x := -1;
   Point.y := -1;
   try
      Point := BankImportGrid.ClientToScreen(BankImportGridTableView.Controller.FocusedItem.FocusedCellViewInfo.EditBounds.BottomRight);
   except
   end;

   if FTransactionType = ttExpense then
      PROG := CASHEXP
   else
      PROG := CASHINC;

   NewListBox.InitialSearchFieldText := ASearchTextValue;
   if not IsEmpty(AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('Enterprise').AsString) then
      begin
         NewListBox.ListInfo.Ent := AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('Enterprise').AsString;
         NewListBox.ListIt ( nil, EntRange, 'N' )   { Nominal Ledger Accounts }
      end
   else
      begin
         NewListBox.ListInfo.Ent := '';
         if (Preferences.ValueAsBoolean[cPref_AutoEntSelect]) then
            begin
               IncomeStart := AccsDataModule.GetEnterpriseIncomeStart();
               ExpenseStart := AccsDataModule.GetEnterpriseExpenseStart();
            end
         else
            begin
               IncomeStart := cNon_Enterprise_Income_Start;
               ExpenseStart := cNon_Enterprise_Expense_Start;
            end;

         if FTransactionType = ttExpense then
            NewListBox.ListIt ( nil, AllNoms, 'N', IntToStr(ExpenseStart)) // << default to Non Enterprise Expense range start
         else
            NewListBox.ListIt ( nil, AllNoms, 'N', IntToStr(IncomeStart)); // << default to Non Enterprise Income range start
      end;

   if ( Length(NewListBox.ListInfo.ReturnValue) > 0 ) then
      begin
         StoreNominalSelection(StrToInt(NewListBox.ListInfo.ReturnValue));
         EditNominalFreeTextDescription(Point);
      end;
end;

procedure TBankMultiLineTransEditForm.StoreNominalSelection(const ANomCode: Integer);
var
   NominalAccount : TNominalAccount;
begin
   with AccsDatamodule.BankCSVDetailTempTableDB do
      try
         Edit;
         try
            FieldByName('NomCode').Clear;
            FieldByName('NomName').Clear;
            FieldByName('Enterprise').Clear;
            if (ANomCode>0) then
               begin
                  NominalAccount := AccsDatamodule.Accounts.GetNominalAccount(ANomCode);
                  if (NominalAccount <> nil) then
                     begin
                        FieldByName('NomCode').AsInteger := ANomCode;
                        FieldByName('NomName').AsString := NominalAccount.Name;
                        FieldByName('Enterprise').AsString := NominalAccount.EntCode;
                     end;
               end;
            Post;
         except
            Cancel;
         end;

      finally
         //BankImportGridTableView.ApplyBestFit( BankImportGridTableViewNominalName );
      end;
end;

procedure TBankMultiLineTransEditForm.ButtonEditClick(Sender: TObject;
  AButtonIndex: Integer);
begin
   if (FocusedColumnString = BankImportGridTableViewNominalName.DataBinding.FieldName) then
      PostMessage(Handle, WM_INVOKESEARCHITEM, 1, 0)
   else if (FocusedColumnString = BankImportGridTableViewAnalysis.DataBinding.FieldName) then
      PostMessage(Handle, WM_INVOKESEARCHITEM, 4, 0)
   else if (FocusedColumnString = BankImportGridTableViewVATCode.DataBinding.FieldName) then
      PostMessage(Handle, WM_INVOKESEARCHITEM, 5, 0)
   else if (FocusedColumnString = BankImportGridTableViewQuantity.DataBinding.FieldName) then
      PostMessage(Handle, WM_INVOKESEARCHITEM, 6, 0)
end;

procedure TBankMultiLineTransEditForm.InvokeSearchItem(
  var Message: TMessage);
begin
   if Message.Msg = WM_INVOKESEARCHITEM then
      begin
         if (Message.WParam = 1) then
            FindAndPostNominal()
         else if (Message.WParam = 4) then
            FindAndPostAnalysisCode()
         else if (Message.WParam = 5) then
            FindAndPostVATCode()
         else  if (Message.WParam = 6) then
            InvokeQuantityScreen();
      end;
end;

procedure TBankMultiLineTransEditForm.actAddLineExecute(Sender: TObject);
begin
   HideHint();
   AddLine();
   PostMessage(Handle, WM_BEGINEDITING, 0, 0);
end;

procedure TBankMultiLineTransEditForm.actAddLineUpdate(Sender: TObject);
begin
   actAddLine.Enabled := CanAddLine;
end;

procedure TBankMultiLineTransEditForm.actCloseExecute(Sender: TObject);
begin
   Close;
end;

procedure TBankMultiLineTransEditForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
   CanClose := ValidateTransactions();
end;

function TBankMultiLineTransEditForm.ValidateTransactions: Boolean;
var
   TotalAmount : Currency;
   RecNo, ArrPos : Integer;
   OriginalAmount : Currency;
   AccRange : TAccRange;
   NomCode, EntCode : ShortString;
   AnalysisString, CustSupplierString : string;
   AnalysisCode : TAnalysisCode;
   WarningText : string;
begin
   Result := False;

   Post();

   // Remove any erroneous transactions
   RemoveErroneousTransactions();

   // Allow user to exit screen if there are no transaction lines to validate.
   if (AccsDatamodule.BankCSVDetailTempTableDB.RecordCount=0) then
      begin
         Result := True;
         Exit;
      end;

   AccsDatamodule.BankCSVDetailTempTableDB.DisableControls;
   Bookmark();
   try
      TotalAmount := 0;

      AccsDatamodule.BankCSVDetailTempTableDB.First;
      while not AccsDatamodule.BankCSVDetailTempTableDB.Eof do
         begin
            if (Length(Trim(AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('VATCode').AsString)) > 0) then
               begin
                  if not NewListBox.CheckVat(AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('VATCode').AsString, ArrPos ) then
                     begin
                        FocusItem( BankImportGridTableViewVATCode, 'VAT Code', Format('%s is not a valid VAT Code.',
                           [AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('VATCode').AsString]));
                        Exit;
                     end;
               end
            else
               begin
                  FocusItem( BankImportGridTableViewVATCode,
                     'VAT Code', 'VAT Code cannot be blank - Enter ''Z'' for zero VAT transactions.');
                  Exit;
               end;

            NomCode := AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('NomCode').AsString;
            slimall(NomCode);

            if (AccsDatamodule.BankCSVTempTableDB.FieldByName('TransactionType').AsString <> 'Pay / Rec') then
               begin
                  if (NomCode = '') then
                     begin
                        FocusItem( BankImportGridTableViewNominalName ,
                            'Inc./Exp. Account', 'You must specify an Inc./Exp. Account.');
                        Exit;
                     end
                  else if not NewListBox.CheckNom ( NomCode, AccRange ) then
                     begin
                        FocusItem( BankImportGridTableViewNominalName ,
                            'Inc./Exp. Account', 'You must specify a valid Inc./Exp. Account.');
                        Exit;
                     end;
               end;

            EntCode := AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('Enterprise').AsString;
            slimall(EntCode);

            if ((EntCode <> '') and not CheckEnt ( EntCode, RecNo )) then
               begin
                  FocusItem( BankImportGridTableViewEnterprise, 'Enterprise Code', EntCode + ' - Invalid Enterprise Code');
                  Exit;
               end;

            AnalysisString := Trim(AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('Analysis').AsString);
            if ((AnalysisString <> '') and (IsNumeric(AnalysisString))) then
               begin
                  AnalysisCode := AccsDatamodule.Accounts.AnalysisCodes.GetAnalysisCode(AnalysisString);
                  if (AnalysisCode = nil) then
                     begin
                        FocusItem( BankImportGridTableViewAnalysis, 'Analysis Code', 'The Analysis Code you have entered does not exist.' );
                        Exit;
                     end;
               end;

            TotalAmount :=
                 TotalAmount + AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('Amount').AsFloat;

            AccsDatamodule.BankCSVDetailTempTableDB.Next;
         end;


      OriginalAmount :=
         AccsDatamodule.BankCSVTempTableDB.FieldByName('OriginalAmount').AsFloat;

      if (TotalAmount <> OriginalAmount) then
         begin
            WarningText := 'Please ensure the total '+ cCRLF +
                      'of all transactions equals'+ cCRLF +
                      'the amount on the bank file.';
            FocusControl(RemainingBalanceLabel, 'Remaining', WarningText);
            Exit;
         end;

       Result := True;
   finally
      AccsDatamodule.BankCSVDetailTempTableDB.EnableControls;
      GoToBookmark();
   end;
end;

procedure TBankMultiLineTransEditForm.TransactionAmountCurrencyEditExit(
  Sender: TObject);
begin
   Post();
end;

procedure TBankMultiLineTransEditForm.NominalAccountButtonEditExit(
  Sender: TObject);
begin
   Post();
end;

procedure TBankMultiLineTransEditForm.Post;
begin
   if (AccsDatamodule.BankCSVDetailTempTableDB.State in dsEditModes) then
       AccsDatamodule.BankCSVDetailTempTableDB.Post;
end;

procedure TBankMultiLineTransEditForm.RemoveErroneousTransactions;
begin
   Bookmark();
   AccsDatamodule.BankCSVDetailTempTableDB.DisableControls;
   try
      AccsDatamodule.BankCSVDetailTempTableDB.First;
      while not AccsDatamodule.BankCSVDetailTempTableDB.Eof do
         begin
            if (AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('Amount').IsNull) then
               AccsDatamodule.BankCSVDetailTempTableDB.Delete
            else
               AccsDatamodule.BankCSVDetailTempTableDB.Next;
         end;

      GoToBookmark();

   finally
      AccsDatamodule.BankCSVDetailTempTableDB.EnableControls;
   end;
end;

procedure TBankMultiLineTransEditForm.Bookmark;
begin
   FBookmark := AccsDatamodule.BankCSVDetailTempTableDB.GetBookmark;
end;

procedure TBankMultiLineTransEditForm.GoToBookmark;
begin
   if (FBookmark<>nil) and
      (AccsDatamodule.BankCSVDetailTempTableDB.BookmarkValid(FBookmark)) then
      begin
         AccsDatamodule.BankCSVDetailTempTableDB.GotoBookmark(FBookmark);
         AccsDatamodule.BankCSVDetailTempTableDB.FreeBookmark(FBookmark);
      end;
end;

procedure TBankMultiLineTransEditForm.actDeleteLineUpdate(Sender: TObject);
begin
   actDeleteLine.Enabled := (AccsDatamodule.BankCSVDetailTempTableDB.RecordCount>0);
end;

procedure TBankMultiLineTransEditForm.actDeleteLineExecute(
  Sender: TObject);
begin
   HideHint();
   if (MessageDlg('Remove transaction line, are you sure?',mtConfirmation,[mbYes,mbNo],0) = mrNo) then
      Exit;
   DeleteLine();
end;

procedure TBankMultiLineTransEditForm.AddLine;
begin
   AccsDatamodule.BankCSVDetailTempTableDB.Append;
   AccsDatamodule.BankCSVDetailTempTableDB.Post;
end;

procedure TBankMultiLineTransEditForm.DeleteLine;
begin
   AccsDatamodule.BankCSVDetailTempTableDB.Delete;
end;

procedure TBankMultiLineTransEditForm.BankImportGridTableViewDataControllerSummaryAfterSummary(
  ASender: TcxDataSummary);
var
   Allocated : Currency;
   Remaining : Currency;
begin
   try
      Allocated := StrToFloat(VarToStr(ASender.FooterSummaryValues[0]));

      Remaining := AccsDatamodule.BankCSVTempTableDB.FieldByName('OriginalAmount').AsFloat -
          Allocated;

      if (Remaining=0) then
         RemainingBalanceLabel.Style.Font.Color := clGreen
      else
         RemainingBalanceLabel.Style.Font.Color := clRed;
      RemainingBalanceLabel.Caption := Format('%.2f',[Remaining]);

   except
      RemainingBalanceLabel.Caption := AmountLabel.Caption;
   end;
end;

procedure TBankMultiLineTransEditForm.FormCreate(Sender: TObject);
begin
   FUsingVAT := (soVAT in AccsSystem.SystemOptions);
   with TcxButtonEditProperties(BankImportGridTableViewNominalName.Properties) do
      begin
         OnButtonClick := ButtonEditClick;
         OnChange := ButtonEditOnChange;
      end;
   with TcxButtonEditProperties(BankImportGridTableViewVATCode.Properties) do
      OnButtonClick := ButtonEditClick;
   with TcxButtonEditProperties(BankImportGridTableViewQuantity.Properties) do
      OnButtonClick := ButtonEditClick;
   with TcxButtonEditProperties(BankImportGridTableViewAnalysis.Properties) do
      OnButtonClick := ButtonEditClick;
end;

procedure TBankMultiLineTransEditForm.InvokeQuantityScreen;
var
   Point : TPoint;
begin
   GetCursorPos(Point);
   Point := ScreenToClient(ClientToScreen(Point));
   // try to align to left,bottom of cell
   Point.x := Point.x - 65;
   Point.y := Point.y + BankImportGridTableView.OptionsView.DataRowHeight;
   EditCBEQuantities(Point);
end;

procedure TBankMultiLineTransEditForm.EditCBEQuantities(APoint: TPoint);
var
   Qty2, Qty3 : Variant;
begin
   // Post any edits to the quantity before opening the multiple quantity window
   BankImportGridTableView.DataController.PostEditingData;

   if AccsDatamodule.MultipleQuantityHandler(AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('Enterprise').AsString,
              AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('Quantity2').AsFloat,
              AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('Quantity3').AsFloat,
              Qty2, Qty3,APoint) then
      begin
         AccsDatamodule.BankCSVDetailTempTableDB.Edit;
         if not VarIsNullOrEmpty(Qty2) then
            AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('Quantity2').Value := Qty2;

         if not VarIsNullOrEmpty(Qty3) then
            AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('Quantity3').Value := Qty3;
         AccsDatamodule.BankCSVDetailTempTableDB.Post;
      end;
end;

function TBankMultiLineTransEditForm.FocusedColumnIndex: Integer;
begin
   Result := BankImportGridTableView.Controller.FocusedColumnIndex;
end;

function TBankMultiLineTransEditForm.FocusedColumnString: string;
begin
   try
      Result := TcxGridDBColumn(BankImportGridTableView.Controller.FocusedColumn).DataBinding.FieldName;
   except
      Result := '';
   end;
end;

procedure TBankMultiLineTransEditForm.FindAndPostAnalysisCode;
var
   Code : Integer;
begin
   if not bool(SetupAnalysisForm) then
      Application.CreateForm(TSetupAnalysisForm, SetupAnalysisForm);

   SetupAnalysisForm.ShowWindow(1);
   if length(Setupanalysisform.selectedcode) > 0 then
      begin
         try
            Code := StrToInt(Setupanalysisform.selectedcode);
            AccsDatamodule.BankCSVDetailTempTableDB.Edit;
            AccsDataModule.BankCSVDetailTempTableDB.FieldByName('Analysis').AsInteger := Code;
            AccsDatamodule.BankCSVDetailTempTableDB.Post;
         except

         end;
      end;
end;

procedure TBankMultiLineTransEditForm.FindAndPostVATCode;
begin
   NewListBox.ListIt ( nil, Vat, 'W' );   { VAT Rates }
   If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
      begin
          AccsDatamodule.BankCSVDetailTempTableDB.Edit;
          AccsDatamodule.BankCSVDetailTempTableDB.FieldByName('VATCode').AsString := NewListBox.ListInfo.ReturnValue;
          AccsDatamodule.BankCSVDetailTempTableDB.Post;
      end;
end;

procedure TBankMultiLineTransEditForm.FocusItem(
  ACustomGridTableItem: TcxCustomGridTableItem; const AHintTitle,
  AHintText: string);
var
   Point : TPoint;
begin
   Windows.Beep(1000,150);

   if not BankImportGrid.Focused then
      BankImportGrid.SetFocus;
   BankImportGridTableView.DataController.LocateByKey(AccsDataModule.BankCSVDetailTempTableDB.FieldByName('LineId').Value);

   BankImportGridTableView.Controller.EditingController.ShowEdit(ACustomGridTableItem);
   if (BankImportGridTableView.Controller.EditingController.Edit = nil) then Exit;

   if ( ACustomGridTableItem = BankImportGridTableViewTransactionType) then
      TcxCustomComboBox(BankImportGridTableView.Controller.EditingController.Edit).DroppedDown := true
   else
      BankImportGridTableView.Controller.EditingController.Edit.DoEditing;

   Point := BankImportGrid.ClientToScreen(
              BankImportGridTableView.Controller.EditingItem.FocusedCellViewInfo.EditBounds.BottomRight);

   ShowHint(Point, AHintTitle, AHintText);
end;

procedure TBankMultiLineTransEditForm.FocusControl(AControl: TControl;
  const AHintTitle, AHintText: string);
var
   Point : TPoint;
begin
   Windows.Beep(1000,150);

   Point := BankMultiLineTransEditForm.ClientToScreen(AControl.BoundsRect.BottomRight);
   ShowHint(Point, AHintTitle, AHintText);
end;

procedure TBankMultiLineTransEditForm.HideHint;
begin
   if (FHintStyleController <> nil) then
      begin
         FHintStyleController.HideHint;
         FreeAndNil(FHintStyleController);
      end;
end;

procedure TBankMultiLineTransEditForm.RaiseValidationError(
  AErrorMessage: string; const AAbort: Boolean);
begin

end;

procedure TBankMultiLineTransEditForm.BankImportGridTableViewKeyPress(
  Sender: TObject; var Key: Char);
begin
   Key := System.UpCase(Key);
   HideHint();
end;

procedure TBankMultiLineTransEditForm.BankImportGridTableViewEditValueChanged(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
   HideHint();

   if (AItem <> nil) and (AItem.VisibleIndex = BankImportGridTableViewAmount.VisibleIndex) then
      begin
         PostMessage(Handle, WM_CHECK_GRID_AMOUNTS, 0, 0);
      end;
end;

procedure TBankMultiLineTransEditForm.BankImportGridTableViewCellDblClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
   HideHint();
end;

procedure TBankMultiLineTransEditForm.BankImportGridTableViewInitEdit(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit);
begin
   HideHint();
   if (AEdit = nil) then Exit;

   if not Assigned(AEdit.OnDblClick) then
      AEdit.OnDblClick := MyCellDoubleClick;

   if (FocusedColumnIndex = BankImportGridTableViewQuantity.VisibleIndex) then
      begin
         (AEdit as TcxButtonEdit).Properties.Buttons[0].Visible := AccsDataModule.GetAdvancedQuantityInput(
         AccsDataModule.BankCSVDetailTempTableDB.FieldByName('Enterprise').AsString) <> nil;
      end;
end;

procedure TBankMultiLineTransEditForm.MyCellDoubleClick(Sender: TObject);
begin
   InvokeGridCellSearch();
end;

procedure TBankMultiLineTransEditForm.InvokeGridCellSearch;
begin
   NewListBox.ListInfo.Ent := '';

   if (FocusedColumnIndex = BankImportGridTableViewNominalName.VisibleIndex) then
      FindAndPostNominal()
   else if (FocusedColumnIndex = BankImportGridTableViewVATCode.VisibleIndex) then
      FindAndPostVATCode()
   else if (FocusedColumnIndex = BankImportGridTableViewAnalysis.VisibleIndex) then
      FindAndPostAnalysisCode();
   HideHint();
end;

procedure TBankMultiLineTransEditForm.BankImportGridTableViewEditKeyDown(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_F2 then
      InvokeGridCellSearch();
end;

procedure TBankMultiLineTransEditForm.NomNameChange(Sender: TField);
begin
   if IsEmpty(AccsDataModule.BankCSVDetailTempTableDB.FieldByName('NomName').AsString) then
      AccsDataModule.BankCSVDetailTempTableDB.FieldByName('NomCode').Clear;
end;

procedure TBankMultiLineTransEditForm.ShowHint(APoint: TPoint;
  const AHintTitle, AHintText: string);
begin
   HideHint();
   FHintStyleController := TcxHintStyleController.Create(nil);
   FHintStyleController.HintStyle.Standard := False;
   FHintStyleController.HintStyle.Color := clRed;
   FHintStyleController.HintStyle.Animate := cxhaSlideDownward;
   FHintStyleController.HintStyle.AnimationDelay := 50;
   FHintStyleController.HintStyle.CallOutPosition := cxbpLeftTop;
   FHintStyleController.HintStyle.CaptionFont.Name := 'Segoe UI';
   FHintStyleController.HintStyle.CaptionFont.Size := 12;
   FHintStyleController.HintStyle.CaptionFont.Style := [fsBold];
   FHintStyleController.HintStyle.CaptionFont.Color := clWhite;
   FHintStyleController.HintStyle.Font := FHintStyleController.HintStyle.CaptionFont;
   FHintStyleController.HintStyle.Font.Size := 10;
   FHintStyleController.HintStyle.Rounded := True;
   FHintStyleController.HintStyle.RoundRadius := 26;
   FHintStyleController.ShowHint(APoint.x, APoint.y, AHintTitle, AHintText);
   HideHintTimer.Enabled := True;
end;

procedure TBankMultiLineTransEditForm.HideHintTimerTimer(Sender: TObject);
begin
   HideHintTimer.Enabled := False;
   HideHint();
end;

procedure TBankMultiLineTransEditForm.BeginEditing(var Message: TMessage);
begin
   if Message.Msg = WM_BEGINEDITING then
      begin
        BankImportGrid.SetFocus;
        BankImportGridTableView.Controller.FocusedItem := BankImportGridTableViewAmount;
        BankImportGridTableView.Controller.FocusedItem.Focused := True;
      end;
end;

function TBankMultiLineTransEditForm.GetCanAddLine: boolean;
begin
   Result := True;
end;

procedure TBankMultiLineTransEditForm.ButtonEditOnChange(sender: TObject);
var
   EditingText : string;
begin
   if (FocusedColumnString = BankImportGridTableViewNominalName.DataBinding.FieldName) then
      begin
         EditingText := (Sender as TcxButtonEdit).Text;
         if not(IsEmpty(EditingText)) then
            begin
               if (not Numeric(EditingText)) then
                  begin
                     FindAndPostNominal(EditingText);
                     (Sender as TcxButtonEdit).Text := '';
                  end;
            end;
      end;
end;

procedure TBankMultiLineTransEditForm.BankImportGridTableViewFocusedItemChanged(
  Sender: TcxCustomGridTableView; APrevFocusedItem,
  AFocusedItem: TcxCustomGridTableItem);
begin
   if (APrevFocusedItem = nil) then Exit;

   if (APrevFocusedItem.VisibleIndex = BankImportGridTableViewNominalName.VisibleIndex) then
      begin
         if IsNumeric(AccsDataModule.BankCSVDetailTempTableDB.FieldByName('NomName').AsString) then
            try
               StoreNominalSelection(StrToInt(AccsDataModule.BankCSVDetailTempTableDB.FieldByName('NomName').AsString));
            except
            end;
      end
   // SP - 22/06/2015 - Handle contra transactions where appropriate
   else if (APrevFocusedItem.VisibleIndex = BankImportGridTableViewAmount.VisibleIndex) then
      begin
         CheckAmount();
         // Post any edits to the quantity before opening the multiple quantity window
      end;
end;

procedure TBankMultiLineTransEditForm.CheckAmount;
var
   TempStr : ShortString;
   TempAmount : Variant;
   NominalCode : string;
begin
   NominalCode := AccsDataModule.BankCSVDetailTempTableDB.FieldByName('NomCode').AsString;
   if Length(Trim(NominalCode)) <= 0 then Exit;

   TempAmount := AccsDataModule.BankCSVDetailTempTableDB.FieldByName('Amount').AsString;
   if Length(Trim(TempAmount)) <= 0 then Exit;

   TempStr := TempAmount;
   SlimAll ( TempStr );

   if (Length ( TempStr ) > 0 ) and
      { Check for minus sign and no numbers begin entered }
      NOT (( Length ( TempStr ) = 1 ) And ( TempStr = '-' )) and
      (ChangeToLong ( TempStr )) then
      begin
         TempStr := NewListBox.NegitiveFlag ( NominalCode, TempStr );
         AccsDataModule.BankCSVDetailTempTableDB.Edit;
         AccsDataModule.BankCSVDetailTempTableDB.FieldByName('Amount').Value := TempStr;
         AccsDataModule.BankCSVDetailTempTableDB.Post;
      end;
end;

procedure TBankMultiLineTransEditForm.RecalclateGridAmounts(
  var Message: TMessage);
begin
    CheckAmount();
end;

function TBankMultiLineTransEditForm.GetBankImportGridCell(Index: Integer): Variant;
begin
   Result := varNull;
   if Index > -1 then
      Result := BankImportGridTableView.DataController.Values[BankImportGridTableView.DataController.FocusedRecordIndex, Index];
end;

procedure TBankMultiLineTransEditForm.SetBankImportGridCell(Index: Integer; const Value: Variant);
begin
   BankImportGridTableView.DataController
      .Values[BankImportGridTableView.DataController.FocusedRecordIndex, Index]
         := Value;
end;

procedure TBankMultiLineTransEditForm.EditNominalFreeTextDescription;
begin
   EditNominalFreeTextDescription(Point(-1,-1));
end;

procedure TBankMultiLineTransEditForm.EditNominalFreeTextDescription(APoint: TPoint);
var
   NominalCode : string;
   NominalDescription : string;
begin
   if not Preferences.ValueAsBoolean[cPref_AllowFreeTextForNominalDescriptionColumn] then Exit;

   NominalCode := AccsDataModule.BankCSVDetailTempTableDB.FieldByName('NomCode').AsString;
   if Length(Trim(NominalCode)) <= 0 then Exit;

   NominalDescription := AccsDataModule.BankCSVDetailTempTableDB.FieldByName('NomName').AsString;

   if ( not(AccsDataModule.BankCSVDetailTempTableDB.State in dsEditModes) ) then
      AccsDataModule.BankCSVDetailTempTableDB.Edit;

   AccsDataModule.BankCSVDetailTempTableDB.FieldByName('NomName').AsString :=
      TfmTransactionNominalFreeTextDescriptionInput.GetText(NominalDescription);
end;

end.
