unit uSimpleSaleInvoiceFrame;

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
  TSimpleSaleInvoiceFrame = class(TSimpleInvoiceBaseFrame)
    GridContainerPanel: TPanel;
    SalesInvoiceGrid: TcxGrid;
    SalesInvoiceGridTableView: TcxGridTableView;
    SalesInvoiceGridLevel: TcxGridLevel;
    LeftPanel: TPanel;
    RightPanel: TPanel;
    MyTimer: TTimer;
    HeaderPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    InvoiceCountTextEdit: TcxTextEdit;
    CurrentInvoiceTotalAmountTextEdit: TcxTextEdit;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    cxButton3: TcxButton;
    cxButton4: TcxButton;
    cxButton5: TcxButton;
    FooterPanel: TPanel;
    SaleInvHeadBevel: TBevel;
    Bevel2: TBevel;
    pSaleInvInfo: TPanel;
    imgSaleInvInfo: TImage;
    lSaleInvEntryInfo: TcxLabel;
    procedure MyTimerTimer(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure cxButton3Click(Sender: TObject);
    procedure SalesInvoiceGridTableViewDataControllerAfterInsert(
      ADataController: TcxCustomDataController);
  private
    { Private declarations }
    procedure CustomerButtonEditClick(Sender: TObject; AButtonIndex: Integer);
    procedure FillCustomer(const ACustomerId: Integer;
       const ARaiseErrorOnNotFound: Boolean = False);

  protected
    FGridDesigning : Boolean;
    FJustAdded : Boolean;
    procedure Loaded; override;
    procedure NominalSelector(); override;
    procedure InvokeLookupEditor(const AGridViewItemIndex: Integer);override;
    function ValidateInvoice(AInvoiceList :TList): Boolean;override;
    function CreateInvoice(AInvoiceList :TList) : Integer;override;
    function LoadInvoice(AInvoice: TInvoice): Boolean;override;
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

{ TSimpleSaleInvoiceFrame }

procedure TSimpleSaleInvoiceFrame.Loaded;
begin
  inherited;
  HeaderPanel.Caption := '';
  FGridDesigning := False;
  GridTableView := SalesInvoiceGridTableView;
  Initialize();
end;

procedure TSimpleSaleInvoiceFrame.CustomerButtonEditClick(
   Sender: TObject; AButtonIndex: Integer);
begin
   CheckNumericColumns(SalesInvoiceGridTableView.DataController.FocusedRecordIndex);
   NewListBox.ListIt ( nil, Customers, 'C' );
   if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
      try
         FillCustomer(StrToInt(NewListBox.ListInfo.ReturnValue), True);
         PostMessage(Handle, WM_FOCUSNEXTITEM, tvBusinessNameIndex+1,0);
      except
         ErrorMessage('Unable to load Customer details.');
      end;
end;

procedure TSimpleSaleInvoiceFrame.NominalSelector();
begin
   inherited;
   NewListBox.ListIt ( nil, AllNoms, 'N', IntToStr(AccsDataModule.GetEnterpriseIncomeStart()) );
end;

procedure TSimpleSaleInvoiceFrame.Summarize;
begin
  inherited;
  InvoiceCountTextEdit.Text := IntToStr(FInvoiceCount);
  CurrentInvoiceTotalAmountTextEdit.Text := FloatToStrF(FCurrentInvoiceTotalAmount,ffFixed, 9,2);
  //HeaderPanel.Caption := 'Grid Updated';
  MyTimer.Enabled := True;
end;

procedure TSimpleSaleInvoiceFrame.MyTimerTimer(Sender: TObject);
begin
  inherited;
  MyTimer.Enabled := False;
  HeaderPanel.Caption := '';
end;

procedure TSimpleSaleInvoiceFrame.cxButton2Click(Sender: TObject);
begin
   GridToFile(DataDir+'\sales_inv_data.txt');
end;

procedure TSimpleSaleInvoiceFrame.cxButton3Click(Sender: TObject);
begin
   FileToGrid(DataDir+'\sales_inv_data.txt');
end;

function TSimpleSaleInvoiceFrame.CreateInvoice(AInvoiceList: TList): Integer;
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

function TSimpleSaleInvoiceFrame.ValidateInvoice(AInvoiceList: TList): Boolean;
var
   SaleInvoice : TSaleInvoice;
   i : Integer;
begin
   Result := ( AInvoiceList.Count > 0 );
   if ( not(Result) ) then Exit;
   for i := 0 to AInvoiceList.Count-1 do
      begin
         SaleInvoice := TSaleInvoice(AInvoiceList[0]);
         Result := ( SaleInvoice.CustomerId > 0 );
         if ( not(Result) ) then Exit;
         Result := SaleInvoice.IsValid;
         if ( not(Result) ) then Exit;
         Result := Inherited ValidateInvoice(AInvoiceList);
         if not Result then Exit;
      end;
end;

function TSimpleSaleInvoiceFrame.LoadInvoice(
  AInvoice: TInvoice): Boolean;
var
   i : Integer;
   NominalAccount: TNominalAccount;
begin
  if not(AInvoice is TSaleInvoice) then
     raise Exception.Create('Invoice type not as expected.');

   Result := inherited LoadInvoice(AInvoice);

   if (Result) then
      begin
         GridTableView.DataController.FocusedRecordIndex := 0; // change back to 0 index on grid to fill the other header values e.g supplier

         // Sale specific information must be loaded to grid.
         FillCustomer((AInvoice as TSaleInvoice).CustomerId);
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

procedure TSimpleSaleInvoiceFrame.FrameOnShow(Sender: TObject);
begin
  inherited;
  FocusGridItemTimer.Enabled := True;
end;

function TSimpleSaleInvoiceFrame.ValidateRow(
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
            Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Customer Name" must be filled.',tvBusinessNameIndex)))
         else
            begin
               // Because the name can be typed by user the is no guarantee that the box contains a full and valid name
               // This code below ensures the name entered by user is an actual business account
               TempName := VarToStr(GridTableView.DataController.Values[ARecordIndex, tvBusinessNameIndex]);
               if not SLPLAccountExists(SLFile,TempName) then
                  Result.Add(Pointer(TSimpleInvoiceValidationError.create(Format('Customer Name "%s" is not valid.',[TempName]), tvBusinessNameIndex)))
            end;

         if VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex, tvBusinessIdIndex]) then
            Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Customer Name" must be filled.',tvBusinessNameIndex)))
         else
            begin
               TempId := GridTableView.DataController.Values[ARecordIndex, tvBusinessIdIndex];
               if GetSLPLAccountName(SLFile,TempId) = '' then
                  Result.Add(Pointer(TSimpleInvoiceValidationError.create(Format('"Customer Name" is not valid.',[TempName]), tvBusinessNameIndex)))
            end;
      end;

   if VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex, tvNominalIdIndex]) or
      VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex, tvNominalNameIndex]) then
      Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Income Account" must be filled.',tvNominalIdIndex)))
   else if not VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex, tvNominalNameIndex]) and
      not Preferences.ValueAsBoolean[cPref_AllowFreeTextForNominalDescriptionColumn] then
      // Because the name can be typed by user the is no guarantee that the box contains a full and valid name
      // This code below ensures the name entered by user is an actual nominal account
      begin
         TempName := VarToStr(GridTableView.DataController.Values[ARecordIndex, tvNominalNameIndex]);
         NominalAccount := AccsDataModule.Accounts.GetNominalAccount(TempName, ntIncome);
         if (NominalAccount=nil) then
            Result.Add(Pointer(TSimpleInvoiceValidationError.create(Format('Income Account "%s" is not valid.',
              [GridTableView.DataController.Values[ARecordIndex, tvNominalNameIndex]]),tvNominalNameIndex)))
      end;
end;

procedure TSimpleSaleInvoiceFrame.EditInvoice(AInvoice: TInvoice);
begin
  inherited;
  LoadInvoice(AInvoice);
end;

procedure TSimpleSaleInvoiceFrame.FillCustomer(const ACustomerId: Integer;
  const ARaiseErrorOnNotFound: Boolean);
var
   CustomerName : string;
begin
   TransGridCell[tvBusinessIdIndex] := 0;
   TransGridCell[tvBusinessNameIndex] := Null;

   CustomerName := GetAccountName(SLFile, ACustomerId, 1);
   if (Length(Trim(CustomerName))>0) then
      begin
         TransGridCell[tvBusinessIdIndex] := ACustomerId;
         TransGridCell[tvBusinessNameIndex] := CustomerName;

         LoadDefaultNominalForBusiness(ACustomerId);
      end
   else
      begin
         FDefaultFocusedItemIndex := tvBusinessNameIndex;
         PostMessage(Handle, WM_FOCUS_DEFAULT_ITEM,0,0);

         if ARaiseErrorOnNotFound then
            ErrorMessage('Customer not found.');
      end;
end;

procedure TSimpleSaleInvoiceFrame.SalesInvoiceGridTableViewDataControllerAfterInsert(
  ADataController: TcxCustomDataController);
begin
  inherited;
  PostMessage(Handle, WM_FOCUSNEXTITEM, tvCommentIndex+1,0);
end;

procedure TSimpleSaleInvoiceFrame.CreateGridCols;
begin
   // Create Sale specific columns
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
         Caption := 'Customer Name';
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
               OnButtonClick := CustomerButtonEditClick;
               OnEditValueChanged := EditValueOnChange;
               OnChange := TransGridTableViewOnChange;
               ImmediateUpdateText := True;
               ImmediatePost := True;
               CharCase := ecUpperCase;
               Buttons[0].Kind := bkGlyph;
               AccsDataModule.ImageList16x16.GetBitmap(1, Buttons[0].Glyph);
               Styles.Content := SimpleAccsData.cxGridStyleRow
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

procedure TSimpleSaleInvoiceFrame.NominalAccountButtonEditClick(
  Sender: TObject; AButtonIndex: Integer);
var
   Point : TPoint;
begin
   if (Sender is TcxTextEdit) then
      (Sender as TcxTextEdit).PostEditValue;

   Point.x := -1;
   Point.y := -1;
   try
      Point := SalesInvoiceGrid.ClientToScreen(SalesInvoiceGridTableView.Controller.FocusedItem.FocusedCellViewInfo.EditBounds.TopLeft);
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
         CheckNumericColumns(SalesInvoiceGridTableView.DataController.FocusedRecordIndex);
      end;

   if not VarIsNull(TransGridCell[tvNominalNameIndex]) then
      begin
         PostMessage(Handle, WM_FOCUSNEXTITEM, -1, 0);
      end;
end;

procedure TSimpleSaleInvoiceFrame.InvokeLookupEditor(const AGridViewItemIndex: Integer);
begin
   inherited InvokeLookupEditor(AGridViewItemIndex);

   if (AGridViewItemIndex = tvBusinessNameIndex) then
      begin
         NewListBox.ListIt ( GridTableView.Controller.FocusedItem, Customers, 'C' );
         if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
            try
               FillCustomer(StrToInt(NewListBox.ListInfo.ReturnValue), True);
               PostMessage(Handle, WM_FOCUSNEXTITEM, tvBusinessNameIndex+1,0);
            except
               ErrorMessage('Unable to load Customer details.');
            end;
      end;
end;

procedure TSimpleSaleInvoiceFrame.TransGridTableViewFocusedItemChanged(
  Sender: TcxCustomGridTableView; APrevFocusedItem,
  AFocusedItem: TcxCustomGridTableItem);
begin
  inherited;
  if ((APrevFocusedItem <> nil) and (APrevFocusedItem.Index = tvBusinessNameIndex)) then
      begin
         if (not(VarIsNullOrEmpty(APrevFocusedItem.EditValue)) and
            (IsNumeric( APrevFocusedItem.EditValue))) then
            begin
               FillCustomer(APrevFocusedItem.EditValue, True);
            end;
      end;
end;

function TSimpleSaleInvoiceFrame.CreateInvoiceInstance(const ARecordIndex: Integer): TInvoice;
var
   Value: Variant;
   Invoice: TSaleInvoice;
begin
   Invoice := TSaleInvoice.create();
   if (ARecordIndex>=0) then
      begin
         Value := GridTableView.DataController.Values[ARecordIndex,tvBusinessIdIndex];
         if not VarIsNullOrEmpty(Value) then
            Invoice.CustomerId := Value;
      end;

   Result := Invoice;
end;

function TSimpleSaleInvoiceFrame.GetNominalAccountHeading: string;
begin
   Result := 'Income Account';
end;

procedure TSimpleSaleInvoiceFrame.KeySearchBusinessName(
  const ASearchText: string);
begin
   NewListBox.InitialSearchFieldText := ASearchText;
   CustomerButtonEditClick(nil,0);
end;

procedure TSimpleSaleInvoiceFrame.LoadDefaultNominalForBusiness(const ABusinessId: Integer);
var
   DefaultNominalId : Integer;
begin
   if not VarIsNull(TransGridCell[tvNominalIdIndex]) then Exit;

   if ( Preferences.ValueAsBoolean[cPref_EnableSLPLDefaults] ) then
      begin
         AccsDataModule.SLPLDefaults.Open;
         if ( AccsDataModule.SLPLDefaults.Locate('SLPLCode;SLPLType',VarArrayOf([ABusinessId,'S']),[]) ) then
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
      DefaultNominalId := AccsDataModule.GetNominalForSupplierCustomer(ABusinessId,ttIncome);

   if ( DefaultNominalId <= 0 ) then Exit;

   FillNominalAccount(DefaultNominalId);
end;

procedure TSimpleSaleInvoiceFrame.KeySearchNominalName(const ASearchText: string);
begin
  inherited;
end;

end.
