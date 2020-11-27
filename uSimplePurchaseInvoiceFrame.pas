unit uSimplePurchaseInvoiceFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxClasses,
  cxControls, cxGridCustomView, cxGrid, StdCtrls, cxButtons, cxCustomData,
  cxGraphics, cxDataStorage, cxCalendar, cxButtonEdit, cxEdit, cxStyles,
  cxTextEdit, cxCurrencyEdit, uAccsMessages, uAccsTransaction,
  uSimpleInvoiceBaseFrame, SimpleAccsDataModule, cxContainer, ActnList,
  Menus, cxSpinEdit, cxLabel;

type
  TSimplePurchaseInvoiceFrame = class(TSimpleInvoiceBaseFrame)
    GridContainerPanel: TPanel;
    PurchaseInvoiceGrid: TcxGrid;
    PurchaseInvoiceGridTableView: TcxGridTableView;
    PurchaseInvoiceGridLevel: TcxGridLevel;
    HeaderPanel: TPanel;
    LeftPanel: TPanel;
    RightPanel: TPanel;
    InvoiceCountTextEdit: TcxTextEdit;
    MyTimer: TTimer;
    Label2: TLabel;
    CurrentInvoiceTotalAmountTextEdit: TcxTextEdit;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton4: TcxButton;
    cxButton5: TcxButton;
    FooterPanel: TPanel;
    PurchInvHeadBevel: TBevel;
    Bevel2: TBevel;
    Label1: TLabel;
    pPurchInvInfo: TPanel;
    imgPurchInvInfo: TImage;
    lPurchInvEntryInfo: TcxLabel;
    procedure MyTimerTimer(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure PurchaseInvoiceGridTableViewDataControllerAfterInsert(
      ADataController: TcxCustomDataController);
  private
    { Private declarations }
    procedure SupplierButtonEditClick(Sender: TObject; AButtonIndex: Integer);
    procedure FillSupplier(const ASupplierId: Integer;
       const ARaiseErrorOnNotFound: Boolean = False);
 protected
    FInvoiceClass : TPurchaseInvoice;
    procedure Loaded; override;
    procedure NominalSelector(); override;
    procedure InvokeLookupEditor(const AGridViewItemIndex: Integer);override;

    function ValidateInvoice(AInvoiceList :TList): Boolean;override;
    function CreateInvoice(AInvoiceList :TList) : Integer;override;
    function LoadInvoice(AInvoice: TInvoice): Boolean;override;
    procedure UpdateInvoice(AInvoice: TInvoice);override;
    function ValidateRow(ARecordIndex: Integer): TList;override;
    procedure NominalAccountButtonEditClick(Sender: TObject;
      AButtonIndex: Integer);override;

    procedure Summarize();override;

    procedure CreateGridCols();override;
    procedure TransGridTableViewFocusedItemChanged(
      Sender: TcxCustomGridTableView; APrevFocusedItem,
      AFocusedItem: TcxCustomGridTableItem);override;
    function CreateInvoiceInstance(const ARecordIndex: Integer):TInvoice;override;
    function GetNominalAccountHeading(): string;override;
    procedure KeySearchBusinessName(const ASearchText: string);override;
    procedure KeySearchNominalName(const ASearchText: string);override;
    procedure LoadDefaultNominalForBusiness(const ABusinessId: Integer);override;
  public
    { Public declarations }
    procedure FrameOnShow(Sender: TObject);override;
    procedure EditInvoice(AInvoice: TInvoice);override;
  end;

implementation
uses
   TYPES, DBGen, Clears, Calcs, DBCore, Vars, NewListing,
   uAccounts, AccsData, AccsUtils, uPreferences, uPreferenceConsts;

{$R *.DFM}

{ TSimplePurchaseInvoiceFrame }

procedure TSimplePurchaseInvoiceFrame.Loaded;
begin
  inherited;
  FTotalInvoices := 0;
  HeaderPanel.Caption := '';
  FGridDesigning := False;
  GridTableView := PurchaseInvoiceGridTableView;
  Initialize();
end;

procedure TSimplePurchaseInvoiceFrame.SupplierButtonEditClick(
  Sender: TObject; AButtonIndex: Integer);
begin
   CheckNumericColumns(PurchaseInvoiceGridTableView.DataController.FocusedRecordIndex);
   NewListBox.ListIt ( nil, Suppliers, 'S' );
   if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
      try
         FillSupplier(StrToInt(NewListBox.ListInfo.ReturnValue), True);
         PostMessage(Handle, WM_FOCUSNEXTITEM, tvBusinessNameIndex+1,0);
      except
         ErrorMessage('Unable to load Supplier details.');
      end;
end;

procedure TSimplePurchaseInvoiceFrame.NominalSelector();
begin
   NewListBox.ListIt ( nil, AllNoms, 'N', IntToStr(AccsDataModule.GetEnterpriseExpenseStart()) );
end;

procedure TSimplePurchaseInvoiceFrame.Summarize;
begin
  inherited;
  InvoiceCountTextEdit.Text := IntToStr(FInvoiceCount);
  CurrentInvoiceTotalAmountTextEdit.Text := FloatToStrF(FCurrentInvoiceTotalAmount,ffFixed, 9,2);
  //HeaderPanel.Caption := 'Grid Updated';
  MyTimer.Enabled := True;
end;

procedure TSimplePurchaseInvoiceFrame.MyTimerTimer(Sender: TObject);
begin
  inherited;
  MyTimer.Enabled := False;
  HeaderPanel.Caption := '';
end;

procedure TSimplePurchaseInvoiceFrame.cxButton2Click(Sender: TObject);
begin
   GridToFile(DataDir+'\purch_inv_data.txt');
end;

procedure TSimplePurchaseInvoiceFrame.cxButton3Click(Sender: TObject);
begin
   FileToGrid(DataDir+'\purch_inv_data.txt');
end;

function TSimplePurchaseInvoiceFrame.CreateInvoice(
  AInvoiceList: TList): Integer;
var
   i : Integer;
   Invoice : TInvoice;
begin
   Result := Inherited CreateInvoice(AInvoiceList);
   if (Result=-1) then Exit; // -1 Indicates problem with input data on grid

   SimpleAccsData.CreateInvoice(AInvoiceList);
   for i := 0 to AInvoiceList.Count-1 do
      begin
         Invoice := TInvoice(AInvoiceList[i]);
         if (Invoice.TransactionState = tsCreated) then
            begin
               Inc(Result);
               RemoveInvoiceFromGrid(Invoice.ClientId);
            end;
      end;
   PostMessage(MainScreenHandle, WM_LOADTRANSACTIONDATA, 0,0);
end;

function TSimplePurchaseInvoiceFrame.ValidateInvoice(AInvoiceList: TList): Boolean;
var
   PurchInvoice : TPurchaseInvoice;
   i : Integer;
begin
   Result := ( AInvoiceList.Count > 0 );
   if ( not(Result) ) then Exit;
   for i := 0 to AInvoiceList.Count-1 do
      begin
         PurchInvoice := TPurchaseInvoice(AInvoiceList[0]);
         Result := ( PurchInvoice.SupplierId > 0 );
         if ( not(Result) ) then Exit;
         Result := PurchInvoice.IsValid;
         if ( not(Result) ) then Exit;
         Result := Inherited ValidateInvoice(AInvoiceList);
         if not Result then Exit;
      end;
end;

function TSimplePurchaseInvoiceFrame.LoadInvoice(
  AInvoice: TInvoice): Boolean;
var
   i : Integer;
   NominalAccount: TNominalAccount;
begin
  if not(AInvoice is TPurchaseInvoice) then
     raise Exception.Create('Invoice type not as expected.');

   Result := inherited LoadInvoice(AInvoice);

   if (Result) then
      begin
         GridTableView.DataController.FocusedRecordIndex := 0; // change back to 0 index on grid to fill the other header values e.g supplier

         // Purchase specific information must be loaded to grid.
         FillSupplier((AInvoice as TPurchaseInvoice).SupplierId);
         for i := 0 to AInvoice.Lines.Count-1 do
            begin
               NominalAccount := AInvoice.Lines[i].Nominal;
               if (NominalAccount <> nil) then
                  begin
                     TransGridCell[tvNominalIdIndex] := NominalAccount.Id;
                     TransGridCell[tvNominalNameIndex] := NominalAccount.Name;
                  end;

               if (i<GridTableView.DataController.RecordCount-1) then
                  GridTableView.DataController.FocusedRecordIndex := i+1;
            end;
     end;
   Summarize();
   if FVATProcessed then
      MessageDlg('You cannot make changes to this Invoice. The VAT on this invoice has processed.',mtWarning,[mbOk],0);
end;

procedure TSimplePurchaseInvoiceFrame.UpdateInvoice(AInvoice: TInvoice);
var
   EditingInvoice : TPurchaseInvoice;
   Invoice : TPurchaseInvoice;
begin
   inherited UpdateInvoice(AInvoice);

   EditingInvoice := (FEditingInvoice as TPurchaseInvoice);
   Invoice := (AInvoice as TPurchaseInvoice);

   EditingInvoice.SupplierId := Invoice.SupplierId;
end;

procedure TSimplePurchaseInvoiceFrame.FrameOnShow(Sender: TObject);
begin
  inherited;
  FocusGridItemTimer.Enabled := True;
end;

function TSimplePurchaseInvoiceFrame.ValidateRow(
  ARecordIndex: Integer): TList;
var
   NominalAccount: TNominalAccount;
   TempName: string;
   TempId: Integer;
begin
   Result := Inherited ValidateRow(ARecordIndex);

   if IsRowEmpty(ARecordIndex) then Exit;

   if (GetRowType(ARecordIndex) = 'Header') then
      begin
         if VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex, tvBusinessNameIndex]) then
            Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Supplier Name" must be filled.',tvBusinessNameIndex)))
         else
            begin
               // Because the name can be typed by user the is no guarantee that the box contains a full and valid name
               // This code below ensures the name entered by user is an actual business account

               TempName := VarToStr(GridTableView.DataController.Values[ARecordIndex, tvBusinessNameIndex]);
               if not SLPLAccountExists(PLFile,TempName) then
                  Result.Add(Pointer(TSimpleInvoiceValidationError.create(Format('Supplier Name "%s" is not valid.',[TempName]), tvBusinessNameIndex)))
            end;

         if VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex, tvBusinessIdIndex]) then
            Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Supplier Name" must be filled.',tvBusinessNameIndex)))
         else
            begin
               TempId := GridTableView.DataController.Values[ARecordIndex, tvBusinessIdIndex];
               if GetSLPLAccountName(PLFile,TempId) = '' then
                  Result.Add(Pointer(TSimpleInvoiceValidationError.create(Format('"Supplier Name" is not valid.',[TempName]), tvBusinessNameIndex)))
            end;
      end;

   if VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex, tvNominalIdIndex]) or
      VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex, tvNominalNameIndex]) then
      Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Expense Account" must be filled.', tvNominalNameIndex)))
   else if not VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex, tvNominalNameIndex]) and
      not Preferences.ValueAsBoolean[cPref_AllowFreeTextForNominalDescriptionColumn] then
      begin
         // Because the name can be typed by user the is no guarantee that the box contains a full and valid name
         // This code below ensures the name entered by user is an actual nominal account
         TempName := VarToStr(GridTableView.DataController.Values[ARecordIndex, tvNominalNameIndex]);
         NominalAccount := AccsDataModule.Accounts.GetNominalAccount(TempName, ntExpense);
         if (NominalAccount=nil) then
            Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Expense Account" is not valid.', tvNominalNameIndex)))
      end
end;

procedure TSimplePurchaseInvoiceFrame.EditInvoice(AInvoice: TInvoice);
begin
  inherited;
  LoadInvoice(AInvoice);
end;

procedure TSimplePurchaseInvoiceFrame.FillSupplier(const ASupplierId: Integer;
  const ARaiseErrorOnNotFound: Boolean = False);
var
   SupplierName : string;
begin
   TransGridCell[tvBusinessIdIndex] := 0;
   TransGridCell[tvBusinessNameIndex] := Null;

   SupplierName := GetAccountName(PLFile, ASupplierId, 1);
   if (Length(Trim(SupplierName))>0) then
      begin
         TransGridCell[tvBusinessIdIndex] := ASupplierId;
         TransGridCell[tvBusinessNameIndex] := SupplierName;

         LoadDefaultNominalForBusiness(ASupplierId);
      end
   else
      begin
         FDefaultFocusedItemIndex := tvBusinessNameIndex;
         PostMessage(Handle, WM_FOCUS_DEFAULT_ITEM,0,0);

         if ARaiseErrorOnNotFound then
            ErrorMessage('Supplier not found.');
      end;
end;

procedure TSimplePurchaseInvoiceFrame.PurchaseInvoiceGridTableViewDataControllerAfterInsert(
  ADataController: TcxCustomDataController);
begin
  inherited;
  PostMessage(Handle, WM_FOCUSNEXTITEM, tvCommentIndex+1,0);
end;

procedure TSimplePurchaseInvoiceFrame.CreateGridCols;
begin
   // Create Purchase specific columns
   with GridTableView.CreateColumn do
      begin
         Caption := 'TX No.';
         Name := 'TransNo';
         DataBinding.ValueTypeClass := TcxStringValueType;
         PropertiesClass := TcxSpinEditProperties;
         Visible := True;
         Options.Editing := False;
         with TcxSpinEditProperties(Properties) do
            begin
               ImmediatePost := True;
               Alignment.Horz := taRightJustify;
               Alignment.Vert := taVCenter;
               Styles.Content := SimpleAccsData.cxGridStyleRow;
               ReadOnly := True;
            end;
         HeaderAlignmentHorz := taCenter;
         HeaderAlignmentVert := vaCenter;
         Width := 75;
         tvTxNoIndex := Index;
      end;

   with GridTableView.CreateColumn do
      begin
         Caption := 'Supplier Name';
         DataBinding.ValueTypeClass := TcxStringValueType;
         HeaderAlignmentHorz := taCenter;
         HeaderAlignmentVert := vaCenter;
         Width := 160;
         tvBusinessNameIndex := Index;
         PropertiesClass := TcxButtonEditProperties;
         Visible := True;
         with TcxButtonEditProperties(Properties) do
            begin

               Alignment.Vert := taVCenter;
               OnButtonClick := SupplierButtonEditClick;
               OnEditValueChanged := EditValueOnChange;
               OnChange := TransGridTableViewOnChange;
               ImmediateUpdateText := True;
               ImmediatePost := True;
               CharCase := ecUpperCase;
               Buttons[0].Kind := bkGlyph;
               AccsDataModule.ImageList16x16.GetBitmap(1, Buttons[0].Glyph);
               Styles.Content := SimpleAccsData.cxGridStyleRow;
            end;
         FDefaultFocusedItemIndex := tvBusinessNameIndex;
      end;

    with GridTableView.CreateColumn do
       begin
          DataBinding.ValueTypeClass := TcxIntegerValueType;
          tvBusinessIdIndex := Index;
          Visible := False;
          Hidden := True;
       end;

   // Create Common cols
  inherited;
end;

procedure TSimplePurchaseInvoiceFrame.NominalAccountButtonEditClick(
  Sender: TObject; AButtonIndex: Integer);
var
   Point : TPoint;
begin
   if (Sender is TcxTextEdit) then
      (Sender as TcxTextEdit).PostEditValue;

   Point.x := -1;
   Point.y := -1;
   try
      Point := PurchaseInvoiceGrid.ClientToScreen(PurchaseInvoiceGridTableView.Controller.FocusedItem.FocusedCellViewInfo.EditBounds.TopLeft);
   except
   end;

   NominalSelector();

   if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
      begin
         TransGridCell[tvNominalIdIndex] := NewListBox.ListInfo.ReturnValue; // Nom Acc Id.
         TransGridCell[tvNominalNameIndex] := GetAccountName ( NewListBox.ListInfo.ActiveDb, StrToInt ( NewListBox.ListInfo.ReturnValue ), 1 );
         TransGridCell[tvLineDesc] := TransGridCell[tvNominalNameIndex];
         TransGridCell[tvVATCodeIndex] := GetAccountName ( NewListBox.ListInfo.ActiveDb, StrToInt ( NewListBox.ListInfo.ReturnValue ),20);
         CheckVATForChanges();
         CheckNumericColumns(PurchaseInvoiceGridTableView.DataController.FocusedRecordIndex);

      end;

   if not VarIsNull(TransGridCell[tvNominalNameIndex]) then
      begin
         PostMessage(Handle, WM_FOCUSNEXTITEM, -1, 0);
      end;
end;

procedure TSimplePurchaseInvoiceFrame.InvokeLookupEditor(const AGridViewItemIndex: Integer);
begin
   inherited InvokeLookupEditor(AGridViewItemIndex);

   if (AGridViewItemIndex = tvBusinessNameIndex) then
      begin
         NewListBox.ListIt(nil, Suppliers, 'S' );
         if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
            try
               FillSupplier(StrToInt(NewListBox.ListInfo.ReturnValue), True);
               PostMessage(Handle, WM_FOCUSNEXTITEM, tvBusinessNameIndex+1,0);
            except
               ErrorMessage('Unable to load Supplier details.');
            end;
      end;
end;

procedure TSimplePurchaseInvoiceFrame.TransGridTableViewFocusedItemChanged(
  Sender: TcxCustomGridTableView; APrevFocusedItem,
  AFocusedItem: TcxCustomGridTableItem);
begin
  inherited;
  if ((APrevFocusedItem <> nil) and (APrevFocusedItem.Index = tvBusinessNameIndex)) then
      begin
         if (not(VarIsNullOrEmpty(APrevFocusedItem.EditValue)) and
            (IsNumeric(APrevFocusedItem.EditValue))) then
            begin
               FillSupplier(APrevFocusedItem.EditValue, True);
            end;
      end;
end;

function TSimplePurchaseInvoiceFrame.CreateInvoiceInstance(const ARecordIndex: Integer): TInvoice;
var
   Value: Variant;
   Invoice: TPurchaseInvoice;
begin
   Invoice := TPurchaseInvoice.create();
   if (ARecordIndex>=0) then
      begin
         Value := GridTableView.DataController.Values[ARecordIndex,tvBusinessIdIndex];
         if not VarIsNullOrEmpty(Value) then
            Invoice.SupplierId := Value;
      end;

   Result := Invoice;
end;

function TSimplePurchaseInvoiceFrame.GetNominalAccountHeading: string;
begin
   Result := 'Expense Account';
end;

procedure TSimplePurchaseInvoiceFrame.KeySearchBusinessName(
  const ASearchText: string);
begin
   NewListBox.InitialSearchFieldText := ASearchText;
   SupplierButtonEditClick(nil,0);
end;

procedure TSimplePurchaseInvoiceFrame.KeySearchNominalName(
  const ASearchText: string);
begin
   inherited;
end;

procedure TSimplePurchaseInvoiceFrame.LoadDefaultNominalForBusiness(const ABusinessId: Integer);
var
   DefaultNominalId : Integer;
begin
   if not VarIsNull(TransGridCell[tvNominalIdIndex]) then Exit;

   if ( Preferences.ValueAsBoolean[cPref_EnableSLPLDefaults] ) then
      begin
         AccsDataModule.SLPLDefaults.Open;
         if ( AccsDataModule.SLPLDefaults.Locate('SLPLCode;SLPLType',VarArrayOf([ABusinessId,'P']),[]) ) then
            begin
               if ( accsdatamodule.SLPLDefaults['Comment'] <> null) then
                  TransGridCell[tvCommentIndex] := VarToStr(AccsDataModule.SLPLDefaults.FieldByName('Comment').AsString);
               try
                  DefaultNominalId := AccsDataModule.SLPLDefaults.FieldByName('Nominal').AsInteger;
               except
               end;
            end;
         AccsDataModule.SLPLDefaults.Close;
      end;

   if ( DefaultNominalId <= 0 ) then
      DefaultNominalId := AccsDataModule.GetNominalForSupplierCustomer(ABusinessId,ttExpense);

   if ( DefaultNominalId <= 0 ) then Exit;
   
   FillNominalAccount(DefaultNominalId);
end;

end.
