{
   27/08/19 [V4.5 R0.3] /MK Bug Fix - Call ResetGridView at end of actCreateInvoiceExecute so that next invoice no is created after save - TGM reported.

   28/08/19 [V4.5 R0.3] /MK Additional Feature - actCreateInvoiceExecute - Check for duplicate Cust/Supplier+Date+Reference/InvoiceNo before saving and give Yes/No prompt - TGM request.
                            Change - ChangesPending - Was based on whether user had created an invoice by adding a full line instead of whether the user had entered something in a cell of the grid.

   30/08/19 [V4.5 R0.3] /MK Additional Feature - Added new column to grid for Line Description that is only available when the Allow Overwrite of Nominal Description preference is ticked - TGM request.
                            Change - Changed Comment column caption to Invoice Commment - TGM request.
                                   - Removed all code for the pop up of the Nominal Description Free Text - TGM request.

   20/09/19 [V4.5 R0.5] /MK Change - AcceptUserVatAmount - George (TGM) asked that we change this allowed amount from 0.01 to 0.025.
                            Bug Fix - Summarize - Using HeaderIndex instead of line index for tvVATAmtIndex Value.

   11/02/21 [V4.5 R5.0] /MK Bug Fix - FillNominalAccount - When editing an invoice the LineDesc and VatCode would always default to that of the nominal.
}

unit uSimpleInvoiceBaseFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView, cxClasses,
  cxControls, cxGridCustomView, cxGrid, StdCtrls, cxButtons, cxCustomData,
  cxGraphics, cxDataStorage, cxCalendar, cxButtonEdit, cxEdit, cxStyles,
  cxTextEdit, cxCurrencyEdit, uAccsMessages, uAccsTransaction, ActnList,
  cxHint, DateUtil, Menus, uPreferences, uPreferenceConsts;

type
  TVATAmount = Record
    VATAmount: Double;
    Amount: Double;
  end;

  TSimpleInvoiceEditMode = (emCreate, emEdit);
  
  TSimpleInvoiceValidationError = class
  private
    FIndex: Integer;
    FMessage: string;
  public
     constructor create(AMessage: string; AIndex: Integer);
     property Message: string read FMessage;
     property Index: Integer read FIndex;
  end;

  TSimpleInvoiceBaseFrame = class(TFrame)
    SimpleInvoiceActionList: TActionList;
    actCreateInvoice: TAction;
    actUpdateInvoice: TAction;
    FocusGridItemTimer: TTimer;
    actCancelInvoice: TAction;
    actDeleteInvoiceLine: TAction;
    PopupMenu: TPopupMenu;
    pmDeleteInvoiceLine: TMenuItem;
    actDeleteInvoice: TAction;
    pmDeleteInvoice: TMenuItem;
    procedure actCreateInvoiceExecute(Sender: TObject);
    procedure actUpdateInvoiceExecute(Sender: TObject);
    procedure FocusGridItemTimerTimer(Sender: TObject);
    procedure actCreateInvoiceUpdate(Sender: TObject);
    procedure actUpdateInvoiceUpdate(Sender: TObject);
    procedure actCancelInvoiceExecute(Sender: TObject);
    procedure actCancelInvoiceUpdate(Sender: TObject);
    procedure actDeleteInvoiceLineExecute(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure actDeleteInvoiceExecute(Sender: TObject);
  private
    { Private declarations }

    FHintStyleController: TcxHintStyleController;
    function GetTransGridCell(Index: Integer): Variant;
    procedure SetTransGridCell(Index: Integer; const Value: Variant);
    procedure DoFocusNextItem(var Message:TMessage); message WM_FOCUSNEXTITEM;
    procedure FocusItem(AIndex : Integer);
    function IsLastColumn(View : TcxGridTableView; Item : TcxCustomGridTableItem) : Boolean;
    procedure HideHint();
    procedure GridTableViewDataControllerBeforeInsert(
      ADataController: TcxCustomDataController);
    function GetEditMode: TSimpleInvoiceEditMode;
    function GetDataDir: string;
  protected
    FGridDesigning: Boolean;
    FInvoiceCount: Integer;
    FCurrentInvoiceTotalAmount: Double;
    FEditingInvoice: TInvoice;

    FTotalInvoices : Integer;
    FDefaultFocusedItemIndex : Integer;

    tvInvUUIDIndex,
    // Grid Column Layout
    tvTxNoIndex, tvInvDateIndex, tvEntIndex,
    // Nominal Cols
    tvNominalIdIndex, tvNominalNameIndex,
    // Enterprise Cols
    tvEnterpriseIdIndex, tvEnterpriseNameIndex,
    // Supplier Cols
    tvBusinessIdIndex, tvBusinessNameIndex,
    // Amount Cols
    tvQtyIndex, tvAmtIndex,

    tvVATAmtIndex, tvVATOrigAmtIndex, tvVATCodeIndex,

    // Misc Cols
    tvCommentIndex, tvRefIndex, tvLineDesc : Integer;

    GridTableView : TcxGridTableView;

    FVATProcessed: Boolean;

    FVATAmountGridColumn : TcxGridColumn; // Referecen to VATAmount column, ref required to enable/disable column events.
    FVATAmountCheckModified: Boolean;
    FNextTxNo : Integer;
    procedure TransGridTableViewOnChange(
      Sender: TObject);
    procedure VATCodeButtonEditClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure TransGridTableViewEditValueChanged(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
    procedure TransGridTableViewInvoiceDatePropertiesInitPopup(
      Sender: TObject);
    procedure GridTableViewDataControllerDataChanged(
      Sender: TObject);
    procedure TransGridTableViewFocusedItemChanged(
      Sender: TcxCustomGridTableView; APrevFocusedItem,
      AFocusedItem: TcxCustomGridTableItem);virtual;
    procedure TransGridTableViewInvoiceDateKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TransGridTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure TransGridTableViewEditing(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      var AAllow: Boolean);
    procedure TransactionGridDateOnCloseUp(Sender : TObject);
    procedure NominalAccountButtonEditClick(Sender: TObject;
      AButtonIndex: Integer);virtual;
    procedure GridTableViewEditChanged(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);virtual;
    procedure GridTableViewInitEdit(
      Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
      AEdit: TcxCustomEdit);

    procedure NominalSelector();virtual;
    procedure InvokeLookupEditor(const AGridViewItemIndex: Integer);virtual;
    procedure CheckVATForChanges();
    function CalcVATAmount(): TVATAmount;
    procedure CheckNumericColumns(const ARowIndex : Integer);

    function ValidateInvoice(AInvoiceList :TList): Boolean;virtual;
    // Returns number of invoices created
    function CreateInvoice(AInvoiceList :TList) : Integer;virtual;
    function LoadInvoice(AInvoice: TInvoice): Boolean;virtual;
    procedure UpdateInvoice(AInvoice: TInvoice);virtual;

    procedure RemoveInvoiceFromGrid(AClientId : string);overload;
    procedure RemoveInvoiceFromGrid(ARecordIndex : Integer);overload;

    function GridRowsToInvoices(): TList;virtual;
    function GetRowType(ARecordIndex : Integer): string;
    function GetNextVisibleGridItem(ACurrentItemIndex : Integer) : Integer;
    procedure Summarize();virtual;
    procedure CalcTxNos();
    function ValidateRow(ARecordIndex: Integer): TList;virtual;

    procedure ShowValidationError(AValidationError: TSimpleInvoiceValidationError);virtual;
    procedure FillNominalAccount(const ANominalId: Integer;
       const ARaiseErrorOnNotFound: Boolean = False);virtual;
    procedure FillVATCode(const AValue: Variant;
       const ARaiseErrorOnNotFound: Boolean = False);virtual;

    procedure InfoMessage(const AText: string);
    procedure ErrorMessage(const AText: string);
    procedure WarningMessage(const AText: string);
    function ConfirmMessage(const AText: string): Boolean;

    function GetSaveInvoiceCaption: string;
    procedure FocusInvalidItem(ACustomGridTableItem : TcxCustomGridTableItem; const AHintTitle, AHintText : string);
    procedure CreateGridCols();virtual;
    procedure SetupGrid();virtual;
    procedure ResetGridView();
    procedure FocusDefaultGridItem(const MoveToTopRow: Boolean = True);
    procedure EditValueOnChange(Sender: TObject);virtual;
    procedure EditDoubleClickHandler(Sender: TObject);virtual;
    procedure VATAmountOnEditValueChanged(Sender: TObject);virtual;
    function CreateInvoiceInstance(const ARecordIndex: Integer):TInvoice;virtual;
    function AcceptUserVATAmount(const ARecordIndex: Integer) : Boolean;

    procedure GridToFile(const AFileName: string = '');
    procedure FileToGrid(const AFileName: string);
    function GetNominalAccountHeading(): string;virtual;
    procedure KeySearchBusinessName(const ASearchText: string);virtual;
    procedure KeySearchNominalName(const ASearchText: string);virtual;
    procedure LoadDefaultNominalForBusiness(const ABusinessId: Integer);virtual;
    function IsRowEmpty(ARecordIndex: Integer): Boolean;

    property SaveInvoiceCaption: string read GetSaveInvoiceCaption;
    property DataDir: string read GetDataDir;

    property TransGridCell[Index : Integer] : Variant read GetTransGridCell write SetTransGridCell;
    property EditMode : TSimpleInvoiceEditMode read GetEditMode;
  public
    procedure DefaultHandler(var Message); override;
    procedure HandleKeyDownEvent(Sender: TObject;
     var Key: Word; Shift: TShiftState;
     var AHandled : Boolean);virtual;
    procedure HandleKeyUpEvent(Sender: TObject; var Key: Word;
     Shift: TShiftState);
    procedure FrameOnShow(Sender: TObject);virtual;
    procedure Initialize();virtual;
    function RowsValid(): Boolean;
    procedure EditInvoice(AInvoice: TInvoice);virtual;
    function ChangesPending : Boolean; virtual;
  end;

{$R *.DFM}

implementation
uses
   TYPES, DBGen, Clears, Calcs, DBCore, Vars,
   NewListing, uAccounts, AccsData, AccsUtils, SimpleAccsDataModule,
   KRoutines;

const
   cDefaultGridRowHeight = 26;
   cDefaultGridFooterHeight = 26;

   cUSER_VAT_AMOUNT_ERROR_CODE = 1001;

   cUSER_VAT_AMOUNT_ERROR_MESSAGE = 'Invalid VAT Amount entered.' + cCRLFx2 +'If you are correcting a rounding error please ensure the new '+cCRLF+'VAT Amount is within 0.1% of original VAT Amount.';

{ TSimpleInvoiceBaseFrame }

procedure TSimpleInvoiceBaseFrame.FocusItem(AIndex: Integer);
var
   NextItem : TcxCustomGridTableItem;
begin
   if (AIndex > GridTableView.ColumnCount-1) then Exit;

   if AIndex = -1 then
      GridTableView.Controller.FocusNextItem(GridTableView.Controller.FocusedItemIndex, True, True, True)
   else
      begin
         NextItem := GridTableView.FindItemByID(AIndex);
         if ((NextItem <> nil) and (NextItem.Visible)) then
            begin
               GridTableView.Controller.FocusedItem := GridTableView.FindItemByID(AIndex)
            end
         else
            GridTableView.Controller.FocusNextItem(GridTableView.Controller.FocusedItemIndex, True, True, True)
      end;

   if (GridTableView.Controller.FocusedItem <> nil) then
      GridTableView.Controller.EditingController.EditingItem := GridTableView.Controller.FocusedItem;
end;

procedure TSimpleInvoiceBaseFrame.NominalSelector();
begin
   // virtual
end;

function TSimpleInvoiceBaseFrame.GetTransGridCell(Index: Integer): Variant;
begin
   Result := varNull;
   if Index > -1 then
      Result := GridTableView.DataController.Values[GridTableView.DataController.FocusedRecordIndex, Index];
end;

procedure TSimpleInvoiceBaseFrame.SetTransGridCell(Index: Integer;
  const Value: Variant);
begin
   GridTableView.DataController
      .Values[GridTableView.DataController.FocusedRecordIndex, Index]
         := Value;
end;

procedure TSimpleInvoiceBaseFrame.TransGridTableViewEditValueChanged(
   Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  GridTableViewDataControllerDataChanged(Sender);
end;

procedure TSimpleInvoiceBaseFrame.VATCodeButtonEditClick(Sender: TObject;
  AButtonIndex: Integer);
begin
   InvokeLookupEditor(tvVATCodeIndex);
   PostMessage(Handle, WM_FOCUSNEXTITEM, GridTableView.Controller.FocusedItemIndex+1, 0);
end;

procedure TSimpleInvoiceBaseFrame.DoFocusNextItem(var Message: TMessage);
begin
   if Message.Msg = WM_FOCUSNEXTITEM then
      FocusItem(Message.WParam);
end;

procedure TSimpleInvoiceBaseFrame.TransGridTableViewInvoiceDatePropertiesInitPopup(
  Sender: TObject);
begin
   //
end;

procedure TSimpleInvoiceBaseFrame.CheckVATForChanges;
var
   Amounts : TVATAmount;
begin
   Amounts := CalcVATAmount();
   TransGridCell[tvAmtIndex] := Amounts.Amount;
   TransGridCell[tvVATAmtIndex] := Amounts.VATAmount;
   TransGridCell[tvVATOrigAmtIndex] := Amounts.VATAmount;

   Summarize();
end;

procedure TSimpleInvoiceBaseFrame.CheckNumericColumns(
  const ARowIndex: Integer);
var
   TempVar : Variant;
begin
   if GridTableView.DataController.FocusedRecordIndex <> ARowIndex then
      GridTableView.DataController.FocusedRecordIndex := ARowIndex;

   TempVar := TransGridCell[tvQtyIndex];
   if VarIsNullOrEmpty(TempVar) then
      TransGridCell[tvQtyIndex] := 0;

   TempVar := TransGridCell[tvAmtIndex];
   if VarIsNullOrEmpty(TempVar) then
      TransGridCell[tvAmtIndex] := 0;

   TempVar := TransGridCell[tvVATAmtIndex];
   if VarIsNullOrEmpty(TempVar) then
      begin
         TransGridCell[tvVATAmtIndex] := 0;
         TransGridCell[tvVATOrigAmtIndex] := 0;
      end;
end;

function TSimpleInvoiceBaseFrame.LoadInvoice(AInvoice: TInvoice): Boolean;
var
   i : Integer;
begin
   Result := False;
   if (AInvoice = nil) then Exit;

   GridTableView.DataController.RecordCount := AInvoice.Lines.Count;
   GridTableView.DataController.FocusedRecordIndex := 0;

   TransGridCell[tvInvDateIndex] := AInvoice.TransactionDate;
   TransGridCell[tvRefIndex] := AInvoice.Reference;
   TransGridCell[tvCommentIndex] := AInvoice.Comment;
   for i := 0 to AInvoice.Lines.Count-1 do
      begin
         TransGridCell[tvLineDesc] := AInvoice.Lines[i].NominalFreeTxt;
         TransGridCell[tvQtyIndex] := AInvoice.Lines[i].Quantity;
         TransGridCell[tvAmtIndex] := AInvoice.Lines[i].Amount;
         TransGridCell[tvVATCodeIndex] := AInvoice.Lines[i].VATCode;
         TransGridCell[tvVATAmtIndex] := AInvoice.Lines[i].VATAmount;
         if (i<GridTableView.DataController.RecordCount-1) then
            GridTableView.DataController.FocusedRecordIndex := i+1;
      end;
   Result := GridTableView.DataController.RecordCount>0;
end;

procedure TSimpleInvoiceBaseFrame.GridTableViewDataControllerDataChanged(
  Sender: TObject);
begin
   //
   Summarize();

end;

procedure TSimpleInvoiceBaseFrame.Summarize;
var
   i : Integer;
   RowType: string;
   CurrIndex : Integer;
   Value : Variant;
   HeaderIndex : Integer;

   function GetHeaderIndex : Integer;
   var
     j : Integer;
   begin
      Result := -1;
      // Move down until RowType <> 'Line'
      for j := CurrIndex-1 downto 0 do
         begin
            RowType := GetRowType(j);
            if (RowType = 'Header') then
               begin
                  Result := j;
                  Break;
               end;
         end;
   end;
begin
   FInvoiceCount := 0;
   FCurrentInvoiceTotalAmount := 0;
   if (GridTableView.DataController.RecordCount=0) then Exit;

   for i := 0 to GridTableView.DataController.RecordCount-1 do
      begin
         RowType := GetRowType(i);
         if (RowType = 'Header') then
            Inc(FInvoiceCount);
      end;

   CurrIndex := GridTableView.DataController.FocusedRecordIndex;

   RowType := GetRowType(CurrIndex);
   if (RowType = 'Header') then
      HeaderIndex := CurrIndex
   else
      HeaderIndex := GetHeaderIndex();
   if (HeaderIndex = -1) then Exit;

   Value := GridTableView.DataController.Values[HeaderIndex,tvAmtIndex];
   if not(VarIsNullOrEmpty(Value)) then
      FCurrentInvoiceTotalAmount := FCurrentInvoiceTotalAmount + Value;
   Value := GridTableView.DataController.Values[HeaderIndex,tvVATAmtIndex];
   if not(VarIsNullOrEmpty(Value)) then
      FCurrentInvoiceTotalAmount := FCurrentInvoiceTotalAmount + Value;

   Inc(HeaderIndex);
   // Move down until RowType <> 'Line'
   for i := HeaderIndex to GridTableView.DataController.RecordCount-1 do
      begin
         RowType := GetRowType(i);
         if (RowType <> 'Line') then Break;

         Value := GridTableView.DataController.Values[i,tvAmtIndex];
         if not(VarIsNullOrEmpty(Value)) then
            FCurrentInvoiceTotalAmount := FCurrentInvoiceTotalAmount + Value;

         //   20/09/19 [V4.5 R0.5] /MK Bug Fix - Using HeaderIndex instead of line index for tvVATAmtIndex Value.
         Value := GridTableView.DataController.Values[i,tvVATAmtIndex];
         if not(VarIsNullOrEmpty(Value)) then
            FCurrentInvoiceTotalAmount := FCurrentInvoiceTotalAmount + Value;
      end;
end;

function TSimpleInvoiceBaseFrame.GetRowType(ARecordIndex : Integer): string;
var
   IsFilled : Boolean;
begin
   Result := '';
   if (ARecordIndex > GridTableView.DataController.RecordCount-1) then Exit;

   // If any one of BusinessId, InvDate or Ref is filled its considered a Header Line
   IsFilled := not(VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvBusinessIdIndex])) or
               not(VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvInvDateIndex])) or
               not(VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvRefIndex])) or
               not(VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvCommentIndex]));

   if (IsFilled) then
      begin
         Result := 'Header';
         Exit;
      end;

   IsFilled := not(VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvQtyIndex])) or
               not(VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvNominalIdIndex])) or
               not(VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvAmtIndex])) or
               not(VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvVATAmtIndex]));

   if (IsFilled) then
      Result := 'Line';
end;

procedure TSimpleInvoiceBaseFrame.actCreateInvoiceExecute(Sender: TObject);
var
   Invoices : TList;
   InvoiceCount, CreatedCount: Integer;
   Invoice : TInvoice;
   i : Integer;
   sInvoiceCheckStr : string;
   saInvoiceCheck : array of string;
   sCustSuppID : string;
begin
   if (EditMode <> emCreate) then Exit;

   InvoiceCount := 0;
   CreatedCount := -1;// Important initial value indicates error status, will be changed if invoices are saved.

   if ( GridTableView.DataController.RecordCount > 1 ) then
      if IsRowEmpty(GridTableView.DataController.RecordCount-1) then
         GridTableView.DataController.DeleteRecord(GridTableView.DataController.RecordCount-1);

   if not RowsValid() then Exit;

   Invoices := GridRowsToInvoices();
   if ((Invoices = nil) or (Invoices.Count=0)) then
      begin
         WarningMessage('There are no invoices to save.');
         Exit;
      end;

   //   28/08/19 [V4.5 R0.3] /MK Additional Feature - Check for duplicate Cust/Supplier+Date+Reference/InvoiceNo before saving and give Yes/No prompt - TGM request.
   sInvoiceCheckStr := '';
   SetLength(saInvoiceCheck,0);
   for i := 0 to Invoices.Count-1 do
      begin
         Invoice := Invoices[i];
         if ( Invoice is TSaleInvoice ) then
            sCustSuppID := IntToStr((Invoice as TSaleInvoice).CustomerId)
         else
            sCustSuppID := IntToStr((Invoice as TPurchaseInvoice).SupplierId);

         if ( Length(Invoice.Reference) > 0 ) then
            begin
               sInvoiceCheckStr := sCustSuppID+FormatDateTime('ddMMyy',Invoice.TransactionDate)+Invoice.Reference;
               if ( Length(sInvoiceCheckStr) > 0 ) and ( Length(saInvoiceCheck) > 0 ) and ( InArray(sInvoiceCheckStr,saInvoiceCheck) ) then
                  if ( MessageDlg('Invoice header detail already exists. Continue?',mtConfirmation,[mbYes,mbNo],0) = mrNo ) then Exit;
               SetLength(saInvoiceCheck,Length(saInvoiceCheck)+1);
               saInvoiceCheck[Length(saInvoiceCheck)-1] := sInvoiceCheckStr;
            end;
      end;

   Screen.Cursor := crHourGlass;

   GridTableView.DataController.BeginFullUpdate;
   try
      InvoiceCount := Invoices.Count;
       // if not Invoice.IsValid then WARNING THE USER IN SOME UNOBSTRUSIVE WAY
      CreatedCount := CreateInvoice(Invoices);
   finally
      GridTableView.DataController.EndFullUpdate;
      FreeAndNil(Invoices);
      Screen.Cursor := crDefault;

      if (InvoiceCount = CreatedCount) then
         begin
            Initialize();
            MessageDlg(Format('%d invoice%s successfully saved.',
               [CreatedCount, IfThenElse(CreatedCount>1, 's','')]),mtInformation,[mbOK],0);
         end
      else if (CreatedCount>-1) then
         // IMPORTANT:
         // Do not call Initialize method if there are any invalid invoices remaining on grid.
         // The user must be given the opportunity to rectify invalid invoices
         MessageDlg(Format('%d of %d invoice%s saved. %d invoice%s could not saved - contact Kingswood.',
              [CreatedCount, InvoiceCount,
               IfThenElse(CreatedCount>1, 's',''),
               InvoiceCount - CreatedCount,
               IfThenElse((InvoiceCount - CreatedCount)>1, 's','')]), mtWarning,[mbOK],0);

         ResetGridView();
   end;
end;

function TSimpleInvoiceBaseFrame.GridRowsToInvoices(): TList;
var
   i : Integer;
   RowType: string;
   Value : Variant;

   Invoice : TInvoice;
   Nominal : TNominalAccount;
   Quantity : Double;
   Amount : Double;
   Stub: string;
   VATCode : string;
   VATAmount : Double;
   NominalFreeText : string;

   GridRowStateValid : Boolean;
begin
   Result := TList.Create();

   Invoice := nil;
   if (GridTableView.DataController.RecordCount = 0) then
      begin
         InfoMessage('No invoices to process.');
         Exit;
      end;

   GridRowStateValid := True;
   for i := 0 to GridTableView.DataController.RecordCount-1 do
   begin
     RowType := GetRowType(i);
     if (RowType = '') then
        begin
           GridRowStateValid := false;
           Break;
        end;
   end;

   // Delete all empty rows
   while ((RowType='Line') and (IsRowEmpty(GridTableView.DataController.RecordCount-1))) do
      begin
         GridTableView.DataController.DeleteRecord(GridTableView.DataController.RecordCount-1);
      end;

   if not(GridRowStateValid) then
      begin
         WarningMessage('Invoice input is incomplete.');
         Exit;
      end;

   for i := 0 to GridTableView.DataController.RecordCount-1 do
   begin
      Nominal := nil;
      Quantity := 0;
      Amount := 0;
      Stub := '';
      VATCode := '';
      VATAmount := 0;
      NominalFreeText := '';

      RowType := GetRowType(i);
      if (RowType = 'Header') then
         begin
            if (Invoice <> nil) then
               Result.Add(pointer(Invoice));

            Invoice := CreateInvoiceInstance(i);

            if (VarIsNullOrEmpty(GridTableView.DataController.Values[i,tvInvUUIDIndex])) then
               // Store the Unique Id of Invoice so that we can come back later and update the
               // grid accordingly
               GridTableView.DataController.Values[i, tvInvUUIDIndex] := Invoice.ClientId;

            Value := GridTableView.DataController.Values[i,tvInvDateIndex];
            if not(VarIsNullOrEmpty(Value)) then
               Invoice.TransactionDate := StrToDate(Value);

            Value := GridTableView.DataController.Values[i,tvRefIndex];
            if not(VarIsNullOrEmpty(Value)) then
               Invoice.Reference := Value;

            Value := GridTableView.DataController.Values[i,tvCommentIndex];
            if not(VarIsNullOrEmpty(Value)) then
               Invoice.Comment := Value;
         end;

      Value := GridTableView.DataController.Values[i,tvNominalIdIndex];
      if not(VarIsNullOrEmpty(Value)) then
         Nominal := AccsDataModule.Accounts.GetNominalAccount(Value);

      Value := GridTableView.DataController.Values[i,tvLineDesc];
      if not(VarIsNullOrEmpty(Value)) then
         NominalFreeText := Value;

      Value := GridTableView.DataController.Values[i,tvQtyIndex];
      if not(VarIsNullOrEmpty(Value)) then
         Quantity := Value;

      Value := GridTableView.DataController.Values[i,tvAmtIndex];
      if not(VarIsNullOrEmpty(Value)) then
         Amount := Value;

      Value := GridTableView.DataController.Values[i,tvVATCodeIndex];
      if not(VarIsNullOrEmpty(Value)) then
         begin
            VATCode := Value;

            Value := GridTableView.DataController.Values[i,tvVATAmtIndex];
            if not(VarIsNullOrEmpty(Value)) then
               VATAmount := Value;
         end;

      Invoice.AddLine(Nominal,Quantity,Amount,VATCode,VATAmount, NominalFreeText);
   end;

   // Add the last processed invoice to the list
   if (Invoice <> nil) then
      Result.Add(pointer(Invoice));
end;

function TSimpleInvoiceBaseFrame.CreateInvoice(
  AInvoiceList: TList): Integer;
begin
   Result := 0;

   if ((AInvoiceList=nil) or (AInvoiceList.Count=0)) then
      begin
         Result := -1;
         WarningMessage('There are no invoices to save.');
      end;

   if not ValidateInvoice(AInvoiceList) then
      begin
         Result := -1;
         ErrorMessage('The invoice data entered is invalid.');
      end;
end;

function TSimpleInvoiceBaseFrame.ValidateInvoice(AInvoiceList :TList): Boolean;
var
   i : Integer;
   Invoice : TInvoice;
begin
   Result := False;
   for i := 0 to AInvoiceList.Count-1 do
      begin
         Invoice := TInvoice(AInvoiceList[i]);
         if not(Invoice.IsValid()) then Exit;
      end;

   Result := True;
end;

procedure TSimpleInvoiceBaseFrame.actUpdateInvoiceExecute(Sender: TObject);
var
   Invoices : TList;
begin
   if (EditMode <> emEdit) then Exit;

   if FVATProcessed then
   begin
      WarningMessage('This Invoice cannot be changed. The VAT on this invoice has been processed.');
      SysUtils.Abort;
   end;

   Screen.Cursor := crHourGlass;

   if not RowsValid() then Exit;

   GridTableView.DataController.BeginFullUpdate;
   Invoices := GridRowsToInvoices();
   if ((Invoices = nil) or (Invoices.Count<>1)) then
      begin
         WarningMessage('Invoice state is not valid.');
         Exit;
      end;

   try
      UpdateInvoice(TInvoice(Invoices[0]));

      if FEditingInvoice.TransactionState = tsUnchanged then Exit;

      SimpleAccsData.UpdateInvoice(FEditingInvoice);
   finally
      GridTableView.DataController.EndFullUpdate;
      FreeAndNil(Invoices);
      Screen.Cursor := crDefault;
      Summarize();

      case FEditingInvoice.TransactionState of
          tsUnchanged:
          begin
             InfoMessage('No changes have been made to this invoice.');
          end;
          tsError:
          begin
             ErrorMessage('Error updating invoice - contact Kingswood.');
          end;
          tsUpdated:
          begin
            FEditingInvoice := nil;
            PostMessage(MainScreenHandle, WM_LOADTRANSACTIONDATA, 0,0);
            ResetGridView();
            InfoMessage('Invoice successfully updated.');
          end;
      end;
   end;
end;

procedure TSimpleInvoiceBaseFrame.UpdateInvoice(
  AInvoice: TInvoice);
var
   i : Integer;
begin
   if (FEditingInvoice = nil) then Exit;

   if (FEditingInvoice.Lines.Count <> AInvoice.Lines.Count) then
      raise Exception.Create('Invoice line count mismatch.');

   FEditingInvoice.TransactionDate := AInvoice.TransactionDate;
   FEditingInvoice.Reference := AInvoice.Reference;
   FEditingInvoice.StubNo := AInvoice.StubNo;
   FEditingInvoice.Comment := AInvoice.Comment;

   for i := 0 to FEditingInvoice.Lines.Count-1 do
      begin
         if (AInvoice.Lines[i].Nominal = nil) then
            raise Exception.Create('Nominal account must be specified prior to saving.');

         FEditingInvoice.UpdateLine(i,
            AInvoice.Lines[i].Nominal,
            AInvoice.Lines[i].Quantity,
            AInvoice.Lines[i].Amount,
            AInvoice.Lines[i].VATCode,
            AInvoice.Lines[i].VATAmount);
      end;
end;

procedure TSimpleInvoiceBaseFrame.RemoveInvoiceFromGrid(AClientId: string);
var
   i : Integer;
   RecordIndex : Integer;
   RowType : string;
begin
   GridTableView.DataController.BeginFullUpdate;
   try
      RecordIndex := -1;
      for i := 0 to GridTableView.DataController.RecordCount-1 do
         begin
            if (GridTableView.DataController.Values[i, tvInvUUIDIndex] = AClientId) then
               begin
                  RecordIndex := i;
                  Break;
               end;
         end;

      if (RecordIndex=-1) then Exit;

      GridTableView.DataController.DeleteRecord(RecordIndex);
      RowType := GetRowType(RecordIndex);

      // Move down and remove until RowType <> 'Line'
      while (RowType = 'Line') do
         begin
            GridTableView.DataController.DeleteRecord(RecordIndex);
            RowType := GetRowType(i);
         end;

   finally
      GridTableView.DataController.EndFullUpdate;
   end;
end;

function TSimpleInvoiceBaseFrame.GetNextVisibleGridItem(
  ACurrentItemIndex: Integer): Integer;
var
   i : Integer;
begin
   Result := -1;
   if (GridTableView=nil) or (GridTableView.DataController=nil) then Exit;

   for i := ACurrentItemIndex+1 to GridTableView.ColumnCount-1 do
      if (not GridTableView.Columns[i].Hidden) and (GridTableView.Columns[i].Visible) then
         begin
            Result := GridTableView.Columns[i].Index;
            Break;
         end;
end;

procedure TSimpleInvoiceBaseFrame.HandleKeyDownEvent(Sender: TObject;
  var Key: Word; Shift: TShiftState; var AHandled : Boolean);
begin
   if (GridTableView.Controller.FocusedItem = nil) then Exit;

   if (Key = VK_F2) or (Key = VK_RETURN) then
      begin
         Key := 0;
         AHandled := True;
         if (GridTableView.Controller.FocusedItem.Index = tvInvDateIndex) then
            GridTableView.Controller.EditingController.ShowEdit(GridTableView.Controller.FocusedItem)
         else
            InvokeLookupEditor(GridTableView.Controller.FocusedItem.Index);
      end
   else if (Key = VK_TAB) then
      begin
         if (SHIFT = [ssShift]) then
            begin
               if ( GridTableView.Controller.FocusedColumnIndex > 0 ) then
                  begin
                     GridTableView.Controller.FocusedColumnIndex := GridTableView.Controller.FocusedColumnIndex-1;
                     GridTableView.Controller.EditingItem := GridTableView.Controller.FocusedItem;
                     AHandled := True;
                  end;
            end
         else
            begin
               AHandled := True;

               if ( IsLastColumn(GridTableView, GridTableView.Controller.FocusedItem) ) then
                  begin
                     FDefaultFocusedItemIndex := tvBusinessNameIndex;
                     if ( GridTableView.Controller.FocusedRowIndex < GridTableView.DataController.RowCount ) and
                        ( GridTableView.DataController.RecordCount = GridTableView.DataController.RowCount ) then
                        begin
                           if not IsRowEmpty(GridTableView.DataController.RecordCount-1) and RowsValid() then // don't add multiple empty lines
                              GridTableView.DataController.InsertRecord(GridTableView.DataController.RecordCount);
                           GridTableView.Controller.FocusedRowIndex := GridTableView.DataController.RecordCount - 1;
                           PostMessage(Handle, WM_FOCUS_DEFAULT_ITEM,0,0);
                        end;
                  end
               else
                  begin
                     PostMessage(Handle, WM_FOCUSNEXTITEM, -1,0);
                  end;
            end;
         Key := 0;
      end
   else if ( Key = VK_ESCAPE ) then
      begin
         GridTableView.Controller.EditingItem := GridTableView.Controller.FocusedItem;
         if ( GridTableView.Controller.FocusedItem.Index = tvInvDateIndex ) then
             TransGridCell[tvInvDateIndex] := Date()
         else if ( GridTableView.Controller.FocusedItem.Index in [tvQtyIndex, tvAmtIndex] ) then
            GridTableView.Controller.EditingItem.EditValue := 0
         else
            GridTableView.Controller.EditingItem.EditValue := Null;
      end
   else if (Key = VK_LEFT) then
      begin
         if (GridTableView.Controller.FocusedItem.Index = tvNominalNameIndex) and
            (VarIsNullOrEmpty(TransGridCell[tvNominalNameIndex])) then
            begin
               PostMessage(Handle, WM_FOCUS_DEFAULT_ITEM,0,0);
            end;
      end
   else if (Key = VK_DOWN) then
      begin
         FDefaultFocusedItemIndex := tvNominalNameIndex;
         PostMessage(Handle, WM_FOCUS_DEFAULT_ITEM,0,0);
      end;
end;

procedure TSimpleInvoiceBaseFrame.FrameOnShow(Sender: TObject);
begin
   GridTableView.DataController.OnBeforeInsert := GridTableViewDataControllerBeforeInsert;
   ResetGridView();
end;

procedure TSimpleInvoiceBaseFrame.FocusGridItemTimerTimer(Sender: TObject);
begin
   FocusGridItemTimer.Enabled := False;
   FocusDefaultGridItem();
end;

function TSimpleInvoiceBaseFrame.ValidateRow(ARecordIndex: Integer): TList;
var
   DateStr : ShortString;
   IsBefore: Boolean;
   TempVar: Variant;
begin
   Result := TList.Create;

   {if IsRowEmpty(ARecordIndex) then
      begin
         Result.Add(Pointer(TSimpleInvoiceValidationError.create('Invoice row cannot be empty.', tvBusinessIdIndex)));
         Exit;
      end;}

   if (GetRowType(ARecordIndex) = 'Header') then
      begin
         if (VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex, tvInvDateIndex])) then
            Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Invoice Date" must be filled.', tvInvDateIndex)))
         else
            begin
               DateStr := ShortString(DateToStr(GridTableView.DataController.Values[ARecordIndex, tvInvDateIndex]));

               if not CheckDateRange(DateStr, False, IsBefore, False ) Then
                  Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Invoice Date" is not in the current financial year.', tvInvDateIndex)))
               else
                  begin
                     try
                        if (StrToDate(DateStr)>Date) then
                           Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Invoice Date" cannot be a future date.', tvInvDateIndex)))
                     except
                        Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Invoice Date" must be filled.', tvInvDateIndex)))
                     end;
                  end;
            end;
         {
         if (VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex, tvRefIndex])) then
            Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Invoice Number / Reference" must be filled.', tvRefIndex)));
         }
      end;
      
   { Pointed out by George (TGM)that Quantity can be left empty, so don't validate

   TempVar := GridTableView.DataController.Values[ARecordIndex, tvQtyIndex];
   if VarIsNullOrEmpty(TempVar) or (TempVar <= 0) then
      Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Quantity" must be filled.', tvQtyIndex)));
   }

   // Pointed out by George (TGM) that amount can be a negative, relax the validation

   TempVar := GridTableView.DataController.Values[ARecordIndex, tvAmtIndex];
   //if VarIsNullOrEmpty(TempVar) or (TempVar <= 0) then
   if VarIsNullOrEmpty(TempVar) then
      Result.Add(Pointer(TSimpleInvoiceValidationError.create('"Amount" must be filled.',tvAmtIndex)));

   TempVar := GridTableView.DataController.Values[ARecordIndex, tvVATCodeIndex];
   if VarIsNullOrEmpty(TempVar) then
      Result.Add(Pointer(TSimpleInvoiceValidationError.create('"VAT Code" must be filled.',tvVATCodeIndex)))
   else
      begin
         // Check code is valid
         if not NewListBox.CheckVATCode(TempVar) then
            Result.Add(Pointer(TSimpleInvoiceValidationError.create(Format('VAT Code "%s" was not found.',[TempVar]),tvVATCodeIndex)))
      end;

   {TempVar := GridTableView.DataController.Values[ARecordIndex, tvVATAmtIndex];
   if VarIsNullOrEmpty(TempVar) then
      Result.Add(Pointer(TSimpleInvoiceValidationError.create('"VAT Amount" must be filled.',tvVATAmtIndex)));}
end;

procedure TSimpleInvoiceBaseFrame.ShowValidationError(
  AValidationError: TSimpleInvoiceValidationError);
begin
   if (AValidationError = nil) then Exit;

   FDefaultFocusedItemIndex := AValidationError.Index;
   PostMessage(Handle, WM_FOCUS_DEFAULT_ITEM,0,0);

   MessageDlg(AValidationError.Message,mtError,[mbOK],0);
end;

function TSimpleInvoiceBaseFrame.RowsValid: Boolean;
var
   i, j : Integer;
   ValidationErrors : TList;
begin
  inherited;
  Result := True;
  GridTableView.DataController.PostEditingData();
  
  if (GridTableView.DataController.RecordCount=0) then
     begin
        Result := False;
        Exit;
     end;

  // This is only an example of what to do!
  for i := 0 to GridTableView.DataController.RecordCount-1 do
     begin
        ValidationErrors := ValidateRow(i);
        try
           if (ValidationErrors.Count>0) then
              begin
                 Result := False;
                 ShowValidationError(ValidationErrors[0]);
                 GridTableView.DataController.FocusedRecordIndex := i;
                 Break;
              end;
        finally
           for j := 0 to ValidationErrors.Count-1 do
              TSimpleInvoiceValidationError(ValidationErrors[j]).Free;
           FreeAndNil(ValidationErrors);
        end;
     end;
end;

function TSimpleInvoiceBaseFrame.IsLastColumn(View: TcxGridTableView; Item: TcxCustomGridTableItem): Boolean;
begin
   Result := (Item.Index = tvVATCodeIndex);
end;

procedure TSimpleInvoiceBaseFrame.EditInvoice(AInvoice: TInvoice);
begin
   FEditingInvoice := AInvoice;
   FVATProcessed := AccsDataModule.IsVATProcessed(TxEditRec);
   GridTableView.Columns[0].Hidden := True;
   GridTableView.Columns[0].Visible := False;
   with GridTableView do
      begin
         OptionsData.Inserting := False;
         OptionsData.Appending := False;
         OptionsData.Editing := not FVATProcessed;
      end;
end;

procedure TSimpleInvoiceBaseFrame.FillNominalAccount(
  const ANominalId: Integer; const ARaiseErrorOnNotFound: Boolean);
var
   NominalName : string;
begin
   TransGridCell[tvNominalIdIndex] := 0;
   TransGridCell[tvNominalNameIndex] := Null;

   NominalName := GetAccountName(NLFile, ANominalId, 1);
   if (Length(Trim(NominalName))>0) then
      begin
         TransGridCell[tvNominalIdIndex] := ANominalId;
         TransGridCell[tvNominalNameIndex] := NominalName;
         //   11/02/21 [V4.5 R5.0] /MK Bug Fix - When editing an invoice the LineDesc and VatCode would always default to that of the nominal.
         if ( TransGridCell[tvLineDesc] = '' ) then
            TransGridCell[tvLineDesc] := NominalName;
         if ( TransGridCell[tvVATCodeIndex] = '' ) then
            TransGridCell[tvVATCodeIndex] := GetAccountName ( NLFile, ANominalId ,20);
         CheckVATForChanges();
      end
   else
      begin
         FDefaultFocusedItemIndex := tvNominalNameIndex;
         PostMessage(Handle, WM_FOCUS_DEFAULT_ITEM,0,0);
         if ARaiseErrorOnNotFound then
            ErrorMessage(Format('Nominal Account[%d] not found.',[ANominalId]));
      end;
end;

procedure TSimpleInvoiceBaseFrame.InfoMessage(const AText: string);
begin
   MessageDlg(AText,mtInformation,[mbOK],0);
end;

procedure TSimpleInvoiceBaseFrame.ErrorMessage(const AText: string);
begin
   MessageDlg(AText,mtError,[mbOK],0);
end;

procedure TSimpleInvoiceBaseFrame.WarningMessage(const AText: string);
begin
   MessageDlg(AText,mtWarning,[mbOK],0);
end;

function TSimpleInvoiceBaseFrame.GetSaveInvoiceCaption: string;
begin
  if (FInvoiceCount>1) then
     Result := Format('Save Invoices (%d)',[FInvoiceCount])
  else
     Result := 'Save Invoice';
end;

procedure TSimpleInvoiceBaseFrame.actCreateInvoiceUpdate(Sender: TObject);
begin
  actCreateInvoice.Caption := GetSaveInvoiceCaption();
  actCreateInvoice.Visible := EditMode = emCreate;
  actCreateInvoice.Enabled := FInvoiceCount>0;
  if (not actCreateInvoice.Visible) and (not actUpdateInvoice.Visible) then
     actUpdateInvoice.Visible := True;
end;

procedure TSimpleInvoiceBaseFrame.actUpdateInvoiceUpdate(Sender: TObject);
begin
   actUpdateInvoice.Visible := EditMode = emEdit;
   if (actUpdateInvoice.Visible) then
      actUpdateInvoice.Enabled := FInvoiceCount=1
   else if not actCreateInvoice.Visible then
      actCreateInvoice.Visible := True;
end;

procedure TSimpleInvoiceBaseFrame.actCancelInvoiceUpdate(Sender: TObject);
begin
   if ( EditMode = emEdit) then
      actUpdateInvoice.Enabled := FInvoiceCount=1
   else
      actUpdateInvoice.Enabled := True;
end;

procedure TSimpleInvoiceBaseFrame.GridTableViewDataControllerBeforeInsert(
  ADataController: TcxCustomDataController);
begin
  if (not AcceptUserVATAmount(GridTableView.DataController.FocusedRecordIndex)) or
     (not RowsValid()) or
     (IsRowEmpty(GridTableView.DataController.FocusedRecordIndex)) then SysUtils.Abort;
end;

procedure TSimpleInvoiceBaseFrame.FocusInvalidItem(
  ACustomGridTableItem: TcxCustomGridTableItem; const AHintTitle,
  AHintText: string);
var
   Point : TPoint;
begin
   Windows.Beep(1000,150);

   if not GridTableView.Site.Focused then
      GridTableView.Site.SetFocus;

   GridTableView.Controller.EditingController.ShowEdit(ACustomGridTableItem);
   if (GridTableView.Controller.EditingController.Edit = nil) then Exit;

   Point := GridTableView.Controller.EditingItem.FocusedCellViewInfo.EditBounds.BottomRight;
   Point.x := Point.x-8; // allow for any edit button
   Point := GridTableView.Site.ClientToScreen(Point);

   HideHint();
   FHintStyleController := TcxHintStyleController.Create(nil);
   FHintStyleController.HintStyle.Standard := False;
   FHintStyleController.HintStyle.Color := clRed;
   FHintStyleController.HintStyle.Animate :=cxhaSlideDownward;
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
   FHintStyleController.ShowHint(Point.x, Point.y, AHintTitle, AHintText);
end;

procedure TSimpleInvoiceBaseFrame.HideHint;
begin
  if (FHintStyleController <> nil) then
  begin
     FHintStyleController.HideHint;
     FreeAndNil(FHintStyleController);
  end;
end;

procedure TSimpleInvoiceBaseFrame.actCancelInvoiceExecute(Sender: TObject);
var
   ConfirmText: string;
begin
   ConfirmText := IfThenElse(FInvoiceCount>1, 'Cancel changes to all invoices?', 'Cancel changes to invoice?');
   if ConfirmMessage(ConfirmText) then
      begin
         ResetGridView();
         FocusDefaultGridItem();
      end;
end;

function TSimpleInvoiceBaseFrame.ConfirmMessage(
  const AText: string): Boolean;
begin
   Result := MessageDlg(AText, mtConfirmation, [mbYes,mbNo],0) = mrYes;
end;

procedure TSimpleInvoiceBaseFrame.ResetGridView();
begin
   FEditingInvoice := nil;
   with GridTableView do
   begin
      OptionsData.Inserting := True;
      OptionsData.Appending := True;
   end;
   GridTableView.Columns[0].Hidden := False;
   GridTableView.Columns[0].Visible := True;

   GridTableView.Columns[tvLineDesc].Hidden := ( not(Preferences.ValueAsBoolean[cPref_AllowFreeTextForNominalDescriptionColumn]) );
   GridTableView.Columns[tvLineDesc].Visible := ( not(GridTableView.Columns[tvLineDesc].Hidden) );

   GridTableView.DataController.RecordCount := 0;
   GridTableView.DataController.RecordCount := 1;

   FNextTxNo := AccsDataModule.GetNextTxNo();

   TransGridCell[tvTxNoIndex] := FNextTxNo;
end;

procedure TSimpleInvoiceBaseFrame.SetupGrid;
begin
   FGridDesigning := True;
   GridTableView.BeginUpdate;

   tvInvUUIDIndex := -1;
   tvInvDateIndex := -1;
   tvEntIndex := -1;
   tvNominalIdIndex := -1;
   tvNominalNameIndex := -1;
   tvCommentIndex := -1;
   tvBusinessIdIndex := -1;
   tvBusinessNameIndex := -1;
   tvQtyIndex := -1;
   tvAmtIndex := -1;
   tvVATAmtIndex := -1;
   tvVATCodeIndex := -1;
   tvRefIndex := -1;

   with GridTableView do
      begin
         GridTableView.PopupMenu := PopupMenu;

         DataController.Options := [dcoAnsiSort,
                                    dcoCaseInsensitive,
                                    dcoAssignGroupingValues,
                                    dcoAssignMasterDetailKeys,
                                    dcoSaveExpanding,
                                    dcoFocusTopRowAfterSorting,
                                    dcoImmediatePost];

         OptionsCustomize.ColumnHiding := False;
         OptionsCustomize.ColumnsQuickCustomization := False;
         OptionsCustomize.ColumnFiltering := False;
         OptionsCustomize.ColumnSorting := False;

         OptionsData.CancelOnExit := False;
         OptionsData.Deleting := False;
         OptionsData.DeletingConfirmation := False;
         OptionsData.Editing := True;
         OptionsData.Inserting := True;
         OptionsData.Appending := True;

         OptionsSelection.CellSelect := True;

         OptionsView.DataRowHeight := cDefaultGridRowHeight;
         OptionsView.Footer := True;
         OptionsView.GridLines := glBoth;
         OptionsView.HeaderHeight := 40;       
         OptionsView.Indicator := True;
         OptionsView.GroupByBox := False;
         OptionsView.ShowEditButtons := gsebNever;

         OnEditValueChanged := TransGridTableViewEditValueChanged;
         OnFocusedItemChanged := TransGridTableViewFocusedItemChanged;
         OnEditChanged := GridTableViewEditChanged;
         OnFocusedRecordChanged := TransGridTableViewFocusedRecordChanged;
         OnEditing := TransGridTableViewEditing;
         OnInitEdit := GridTableViewInitEdit;

         Styles.GroupByBox := nil;

         ClearItems;
      end;
   CreateGridCols();
   GridTableView.DataController.RecordCount := 1;
   GridTableView.Site.Align := alClient;
   GridTableView.EndUpdate;

   FGridDesigning := False;
end;

procedure TSimpleInvoiceBaseFrame.CreateGridCols;
begin
   with GridTableView.CreateColumn do
      begin
         Caption := 'Invoice Date';
         Name := 'InvDate';
         DataBinding.ValueTypeClass := TcxDateTimeValueType;
         HeaderAlignmentHorz := taCenter;
         HeaderAlignmentVert := vaCenter;
         Width := 85;
         PropertiesClass := TcxDateEditProperties;
         Visible := True;
         with TcxDateEditProperties(Properties) do
            begin
               Alignment.Vert := taVCenter;
               ImmediatePost := True;
               SaveTime := False;
               ShowTime := False;
               DisplayFormat := 'dd/MM/yyyy';
               EditFormat := 'dd/MM/yyyy';
               PostPopupValueOnTab := True;
               UseDisplayFormatWhenEditing := True;
               PostPopupValueOnTab := True;
               AccsDataModule.ImageList16x16.GetBitmap(11, Buttons[0].Glyph);
               OnCloseUp := TransactionGridDateOnCloseUp;
               OnEditValueChanged := EditValueOnChange;
               OnInitPopup := TransGridTableViewInvoiceDatePropertiesInitPopup;
               OnKeyDown := TransGridTableViewInvoiceDateKeyDown;
               Styles.Content := SimpleAccsData.cxGridStyleRow;
               Name := 'InvDateEdit';
            end;
         tvInvDateIndex := Index;
      end;

   with GridTableView.CreateColumn do
      begin
         Caption := 'Invoice Number / Reference';
         Name := 'InvReference';
         DataBinding.ValueTypeClass := TcxStringValueType;
         HeaderAlignmentHorz := taCenter;
         HeaderAlignmentVert := vaCenter;
         Visible := True;
         Width := 130;
         tvRefIndex := Index;
         Styles.Content := SimpleAccsData.cxGridStyleRow;
         PropertiesClass := TcxTextEditProperties;
         with TcxTextEditProperties(Properties) do
            begin
               ImmediatePost := True;
               Alignment.Vert := taVCenter;
               OnEditValueChanged := EditValueOnChange;
               OnChange := TransGridTableViewOnChange;
               //CharCase := ecUpperCase;
               ImmediateUpdateText := True;
               ImmediatePost := True;
               MaxLength := 15; // this is a database constraint!
            end;
      end;

   with GridTableView.CreateColumn do
      begin
         Caption := 'Invoice Comment';
         Name := 'InvComment';
         DataBinding.ValueTypeClass := TcxStringValueType;
         HeaderAlignmentHorz := taCenter;
         HeaderAlignmentVert := vaCenter;
         Visible := True;
         Width := 150;
         PropertiesClass := TcxTextEditProperties;
         with TcxTextEditProperties(Properties) do
            begin
               ImmediatePost := True;
               OnEditValueChanged := EditValueOnChange;
               OnChange := TransGridTableViewOnChange;
               ImmediateUpdateText := True;
               ImmediatePost := True;
               //CharCase := ecUpperCase;
               Styles.Content := SimpleAccsData.cxGridStyleRow;
               Alignment.Vert := taVCenter;
               MaxLength := 30;
            end;
         tvCommentIndex := Index;
      end;

   with GridTableView.CreateColumn do
      begin
         Caption := GetNominalAccountHeading();
         Name := 'InvNominalAccount';
         DataBinding.ValueTypeClass := TcxStringValueType;
         HeaderAlignmentHorz := taCenter;
         HeaderAlignmentVert := vaCenter;
         Visible := True;
         Width := 210;
         PropertiesClass := TcxButtonEditProperties;
         with TcxButtonEditProperties(Properties) do
            begin
               ImmediatePost := True;
               OnButtonClick := NominalAccountButtonEditClick;
               OnEditValueChanged := EditValueOnChange;
               OnChange := TransGridTableViewOnChange;
               ImmediateUpdateText := True;
               ImmediatePost := True;
               //CharCase := ecUpperCase;
               Buttons[0].Kind := bkGlyph;
               AccsDataModule.ImageList16x16.GetBitmap(1, Buttons[0].Glyph);
               Styles.Content := SimpleAccsData.cxGridStyleRow;
               Alignment.Vert := taVCenter;
            end;
         tvNominalNameIndex := Index;
      end;

   with GridTableView.CreateColumn do
      begin
         Caption := 'Line Description';
         Name := 'LineDescription';
         DataBinding.ValueTypeClass := TcxStringValueType;
         HeaderAlignmentHorz := taCenter;
         HeaderAlignmentVert := vaCenter;
         Visible := True;
         Width := 150;
         PropertiesClass := TcxTextEditProperties;
         with TcxTextEditProperties(Properties) do
            begin
               ImmediatePost := True;
               OnEditValueChanged := EditValueOnChange;
               OnChange := TransGridTableViewOnChange;
               ImmediateUpdateText := True;
               ImmediatePost := True;
               //CharCase := ecUpperCase;
               Styles.Content := SimpleAccsData.cxGridStyleRow;
               Alignment.Vert := taVCenter;
               MaxLength := 30;
            end;
         tvLineDesc := Index;
      end;

   with GridTableView.CreateColumn do
      begin
         Caption := 'Quantity';
         Name := 'InvQty';
         DataBinding.ValueTypeClass := TcxFloatValueType;
         PropertiesClass := TcxCurrencyEditProperties;
         Visible := True;
         with TcxCurrencyEditProperties(Properties) do
            begin
               ImmediatePost := True;
               Alignment.Horz := taRightJustify;
               Alignment.Vert := taVCenter;
               DisplayFormat := cDefaultCurrencyFormat;
               Styles.Content := SimpleAccsData.cxGridStyleRow;
               //EditButton := Buttons.Add;
               //EditButton.Kind := bkEllipsis;
               //OnButtonClick := QuantityButtonEditClick;
            end;
         HeaderAlignmentHorz := taCenter;
         HeaderAlignmentVert := vaCenter;
         Width := 75;
         tvQtyIndex := Index;
      end;

   with GridTableView.CreateColumn do
      begin
         Caption := 'Amount';
         Name := 'InvUnitCost';
         DataBinding.ValueTypeClass := TcxFloatValueType;
         PropertiesClass := TcxCurrencyEditProperties;
         Visible := True;
         with TcxCurrencyEditProperties(Properties) do
            begin
               ImmediatePost := True;
               Alignment.Horz := taRightJustify;
               Alignment.Vert := taVCenter;
               DisplayFormat := cDefaultCurrencyFormat;
               Styles.Content := SimpleAccsData.cxGridStyleRow;
               OnEditValueChanged := EditValueOnChange;
            end;
         HeaderAlignmentHorz := taCenter;
         HeaderAlignmentVert := vaCenter;
         Width := 75;
         tvAmtIndex := Index;
      end;

   with GridTableView.CreateColumn do
      begin
         Caption := 'VAT Code';
         Name := 'InvVATCode';
         DataBinding.ValueTypeClass := TcxStringValueType;
         HeaderAlignmentHorz := taCenter;
         HeaderAlignmentVert := vaCenter;
         Width := 75;
         Visible := True;
         PropertiesClass := TcxButtonEditProperties;

         with TcxButtonEditProperties(Properties) do
            begin
               ImmediatePost := True;
               Alignment.Vert := taVCenter;
               Alignment.Horz := taCenter;
               CharCase := ecUpperCase;
               OnButtonClick := VATCodeButtonEditClick;
               //OnEditValueChanged := EditValueOnChange;
               OnChange:= EditValueOnChange;
               Buttons[0].Kind := bkGlyph;
               AccsDataModule.ImageList16x16.GetBitmap(1, Buttons[0].Glyph);
               Styles.Content := SimpleAccsData.cxGridStyleRow;
            end;

         tvVATCodeIndex := Index;
      end;

   FVATAmountGridColumn := GridTableView.CreateColumn;
   with FVATAmountGridColumn do
      begin
         Caption := 'VAT Amount';
         Name := 'InvVATAmount';
         DataBinding.ValueTypeClass := TcxFloatValueType;
         PropertiesClass := TcxCurrencyEditProperties;
         // Options.Editing := False; 16/07/19 TGM Has recommended we allow users to enter VAT Amount to correct any rounding issues
         Visible := True;
         with TcxCurrencyEditProperties(Properties) do
            begin
               //ImmediatePost := True; Dont post immediately, wait until user exists the column, at that point validate the VAT Amount against original 
               Alignment.Vert := taVCenter;
               Alignment.Horz := taRightJustify;
               DisplayFormat := cDefaultCurrencyFormat;
               Styles.Content := SimpleAccsData.cxGridStyleRow;
               //ReadOnly := True;
               OnEditValueChanged := VATAmountOnEditValueChanged;
            end;
         HeaderAlignmentHorz := taCenter;
         HeaderAlignmentVert := vaCenter;

         //Options.Focusing := False;

         Width := 75;
         tvVATAmtIndex := Index;
      end;

   with GridTableView.CreateColumn do
      begin
         Name := 'InvNominalAccountId';
         DataBinding.ValueTypeClass := TcxIntegerValueType;
         tvNominalIdIndex := Index;
         Visible := False;
         Hidden := True;
      end;

    with GridTableView.CreateColumn do
       begin
          Name := 'InvUUID';
          DataBinding.ValueTypeClass := TcxStringValueType;
          tvInvUUIDIndex := Index;
          Visible := False;
          Hidden := True;
       end;

    with GridTableView.CreateColumn do
       begin
          Name := 'InvVATOrigAmt';
          DataBinding.ValueTypeClass := TcxFloatValueType;
          tvVATOrigAmtIndex := Index;
          Visible := False;
          Hidden := True;
       end;
end;

procedure TSimpleInvoiceBaseFrame.TransGridTableViewFocusedItemChanged(
  Sender: TcxCustomGridTableView; APrevFocusedItem,
  AFocusedItem: TcxCustomGridTableItem);
begin
   if ( FGridDesigning ) or (AFocusedItem = nil) then Exit;

   GridTableViewDataControllerDataChanged(Sender);
   CheckNumericColumns(GridTableView.Controller.FocusedRecordIndex);
   if (( APrevFocusedItem <> nil ) and ( APrevFocusedItem.Index = tvNominalNameIndex )) then
      begin
         if (not(VarIsNullOrEmpty(APrevFocusedItem.EditValue)) and
            (IsNumeric( APrevFocusedItem.EditValue))) then
            begin
               FillNominalAccount(APrevFocusedItem.EditValue, True);
            end;
      end;

   {if ( and (AFocusedItem.Index <> tvInvDateIndex)) then
      begin
         TempVar := TransGridCell[tvInvDateIndex];
         if not VarIsNull(TempVar) then
            begin
               TestDate := FormatDateTime(ShortDateFormat, TempVar);

               if not( DateValid(TestDate, TDateFormat )) then
                  begin
                     MessageDlg('You must enter a valid Invoice Date.',mtWarning,[mbOK],0);
                     Exit;
                  end;
            end;
      end;}

   //PostMessage(Handle, WM_FOCUSNEXTITEM, GetNextVisibleGridItem(AFocusedItem.Index),0);

   if ( EditMode <> emEdit ) then
      if ( AFocusedItem.Index in [tvInvDateIndex, tvBusinessIdIndex] ) or
         ( APrevFocusedItem.Index in [tvInvDateIndex, tvBusinessIdIndex] ) then
         CalcTxNos;
end;

procedure TSimpleInvoiceBaseFrame.TransGridTableViewInvoiceDateKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if ( Key = VK_RETURN ) then
      begin
         if (Sender is TcxDateEdit) then
            (Sender as TcxDateEdit).PopupWindow.Popup( GridTableView.Site );
      end;
end;

procedure TSimpleInvoiceBaseFrame.TransactionGridDateOnCloseUp(
  Sender: TObject);
begin
   if (Sender is TcxDateEdit) then
      begin
         (Sender as TcxDateEdit).PostEditValue;
         if VarIsNullOrEmpty((Sender as TcxDateEdit).EditValue) then
            (Sender as TcxDateEdit).EditValue := Date;
         PostMessage(Handle, WM_FOCUSNEXTITEM, -1, 0);
      end;
end;

procedure TSimpleInvoiceBaseFrame.NominalAccountButtonEditClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  //
end;

procedure TSimpleInvoiceBaseFrame.InvokeLookupEditor(const AGridViewItemIndex: Integer);
var
   TempStr : ShortString;
   TempVar : Variant;
   NominalDesc : String;
   FreeTxt : String;
   Point : TPoint;
begin
   if ( AGridViewItemIndex = tvInvDateIndex ) then
      begin

      end
   else if ( AGridViewItemIndex = tvNominalNameIndex ) then
      begin
         NominalSelector();

         if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
            begin
               Point := GridTableView.Controller.EditingItem.FocusedCellViewInfo.EditBounds.TopLeft;
               Point.y := Point.y + GridTableView.OptionsView.DataRowHeight;
               Point := GridTableView.Site.ClientToScreen(Point);
               NominalDesc := GetAccountName(NewListBox.ListInfo.ActiveDb,StrToInt( NewListBox.ListInfo.ReturnValue ), 1 );
               TransGridCell[tvNominalNameIndex] := NominalDesc;

               TransGridCell[tvNominalIdIndex] := NewListBox.ListInfo.ReturnValue; // Nom Acc Id.
               TransGridCell[tvNominalNameIndex] := GetAccountName ( NewListBox.ListInfo.ActiveDb, StrToInt ( NewListBox.ListInfo.ReturnValue ), 1 );
               TransGridCell[tvLineDesc] := TransGridCell[tvNominalNameIndex];

               TransGridCell[tvVATCodeIndex] := GetAccountName ( NewListBox.ListInfo.ActiveDb, StrToInt ( NewListBox.ListInfo.ReturnValue ),20);
               CheckVATForChanges();
               CheckNumericColumns(GridTableView.DataController.FocusedRecordIndex);
            end;

         if not VarIsNullOrEmpty(TransGridCell[tvNominalNameIndex]) then
            begin
               PostMessage(Handle, WM_FOCUSNEXTITEM, -1, 0);
            end;
      end
   else if (AGridViewItemIndex = tvVATCodeIndex) then
      begin
         CheckNumericColumns(GridTableView.DataController.FocusedRecordIndex);

         TempVar := TransGridCell[tvVATCodeIndex];
         if not VarIsNull(TempVar) then
            begin
               TempStr := TempVar;
               SlimAll ( TempStr );
               NewListBox.InitialSearchFieldText := TempStr;
            end;

         NewListBox.ListIt ( nil, Vat, 'V' );   { VAT Rates }
         If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            begin
               TransGridCell[tvVATCodeIndex] := NewListBox.ListInfo.ReturnValue;
               CheckVATForChanges();
            end;
      end;
end;

function TSimpleInvoiceBaseFrame.GetEditMode: TSimpleInvoiceEditMode;
begin
   Result := IfThenElse(FEditingInvoice=nil, emCreate, emEdit);
end;

procedure TSimpleInvoiceBaseFrame.Initialize;
begin
   FVATAmountCheckModified := True;
   FEditingInvoice := nil;
   GEditing := False;
   SetupGrid();
   Summarize();
   Update;
end;

procedure TSimpleInvoiceBaseFrame.FocusDefaultGridItem(const MoveToTopRow: Boolean);
var
   Item: TcxCustomGridTableItem;
begin
   if not GridTableView.Site.CanFocusEx then Exit;

   GridTableView.Site.SetFocus();
   GridTableView.Focused := True;

   Item := GridTableView.FindItemByID(FDefaultFocusedItemIndex);
   if (Item=nil) then Exit;

   if (MoveToTopRow) then
      GridTableView.Controller.FocusedRecordIndex := 0;
   GridTableView.Controller.EditingController.EditingItem := Item;
   FDefaultFocusedItemIndex := 0; // reset
end;

procedure TSimpleInvoiceBaseFrame.DefaultHandler(var Message);
begin
   with TMessage(Message) do
    begin
      if (Msg = WM_FOCUS_DEFAULT_ITEM) then
         begin
            FocusDefaultGridItem(False);
         end
      else if (Msg = WM_SHOW_MESSAGE_DIALOGUE) then
         begin
            if (LParam = cUSER_VAT_AMOUNT_ERROR_CODE) then
               begin
                  FVATAmountCheckModified := True;
                  TcxCurrencyEditProperties(FVATAmountGridColumn.Properties).OnEditValueChanged := VATAmountOnEditValueChanged; // restore the event
                  WarningMessage(cUSER_VAT_AMOUNT_ERROR_MESSAGE);

                  SysUtils.Abort;
               end;
         end
      else
         inherited DefaultHandler(Message);
    end;
end;

procedure TSimpleInvoiceBaseFrame.EditValueOnChange(Sender: TObject);
var
   NewValue: Variant;
   Edit : TcxCustomEdit;
begin
   if (Sender = nil) then Exit;

   if (GridTableView.Controller.EditingItem = nil) or
      (GridTableView.Controller.FocusedItem = nil) then Exit;

   Edit := GridTableView.Controller.EditingController.Edit as TcxCustomEdit;
   if (Edit = nil) then Exit;

   Edit.PostEditValue;
   NewValue := Edit.EditingValue;
   if (VarIsNullOrEmpty(NewValue) or (Length(Trim(NewValue))<=0)) then Exit;

   if ( not IsNumeric(NewValue)) then
      begin
         if ( GridTableView.Controller.FocusedItem.Index = tvBusinessNameIndex ) then
            KeySearchBusinessName(NewValue)
         else if ( GridTableView.Controller.FocusedItem.Index = tvNominalNameIndex ) then
            KeySearchNominalName(NewValue);
      end;

   CheckVATForChanges();
end;

procedure TSimpleInvoiceBaseFrame.EditDoubleClickHandler(Sender: TObject);
begin
   InvokeLookupEditor(GridTableView.Controller.FocusedItem.Index)
end;

function TSimpleInvoiceBaseFrame.CreateInvoiceInstance(const ARecordIndex: Integer): TInvoice;
begin
   Result := TInvoice.create();
end;

function TSimpleInvoiceBaseFrame.ChangesPending: Boolean;
var
   i, j : Integer;
begin
   //   28/08/19 [V5.9 R0.1] /MK Change - Was based on whether user had created an invoice by adding a full line instead of whether the user had entered something in a cell of the grid. 
   Result := ( FInvoiceCount > 0 ) and ( GridTableView.ViewData.RowCount > 0 );
   if ( Result ) then
      for i := 0 to GridTableView.ViewData.RowCount-1 do
         for j := 0 to GridTableView.ViewData.Rows[i].ValueCount-1 do
            begin
               Result := ( not(VarIsNull(GridTableView.ViewData.Rows[i].Values[j])) );
               if Result then Break;
            end;
end;

procedure TSimpleInvoiceBaseFrame.GridTableViewEditChanged(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem);
begin
  GridTableViewDataControllerDataChanged(Sender);
end;

procedure TSimpleInvoiceBaseFrame.FileToGrid(const AFileName: string);
var
   i : Integer;
   DataFile : TStringList;
   FileName : string;
   Values : TStringArray;
begin
   SetLength(Values,0);
   GridTableView.DataController.RecordCount := 1; // default to 1 record just in case there is no file to load from.

   if not FileExists(FileName) then Exit;

   DataFile := TStringList.Create;
   DataFile.LoadFromFile(FileName);

   GridTableView.DataController.RecordCount := DataFile.Count;
   try
      for i := 0 to DataFile.Count-1 do
         begin
            Values := SplitString(DataFile[i], '|', True);

            try
               if (Values[0]<>'') then
                   GridTableView.DataController.Values[i,tvBusinessIdIndex] := StrToInt(Values[0]);
            except
            end;
            try
               if (Values[1]<>'') then
                 GridTableView.DataController.Values[i,tvBusinessNameIndex] := Values[1];
            except
            end;
            try
               if (Values[2]<>'') then
                  GridTableView.DataController.Values[i,tvInvDateIndex] := Values[2];
            except
            end;
            try
               if (Values[3]<>'') then
                  GridTableView.DataController.Values[i,tvNominalIdIndex] := StrToInt(Values[3]);
            except
            end;
            try
               if (Values[4]<>'') then
                  GridTableView.DataController.Values[i,tvNominalNameIndex] := Values[4];
            except
            end;
            try
               if (Values[7]<>'') then
                  GridTableView.DataController.Values[i,tvQtyIndex] := StrToFloat(Values[5]);
            except
            end;
            try
               if (Values[8]<>'') then
                  GridTableView.DataController.Values[i,tvAmtIndex] := StrToFloat(Values[6]);
            except
            end;
            try
               if (Values[9]<>'') then
                  GridTableView.DataController.Values[i,tvVATCodeIndex] := Values[7];
            except
            end;
            try
               if (Values[10]<>'') then
                  GridTableView.DataController.Values[i,tvVATAmtIndex] := StrToFloat(Values[8]);
            except
            end;
            try
               if (Values[11]<>'') then
                  GridTableView.DataController.Values[i,tvRefIndex] := Values[9];
            except
            end;
            try
               if (Values[12]<>'') then
                  GridTableView.DataController.Values[i,tvCommentIndex] := Values[10];
            except
            end;
         end;
      Summarize();
   finally
      FreeAndNil(DataFile);
   end;
end;

procedure TSimpleInvoiceBaseFrame.GridToFile(const AFileName: string);
var
   i : Integer;
   Line : string;
   DataFile : TStringList;
   FileName: string;
begin
   if (Length(Trim(AFileName))>0) then
      FileName := AFileName
   else
      FileName := DataDir+'\purch_inv_data_'+ FormatDateTime('dd_MM_yyyy_hh_nn',Now)+'.txt';

   DataFile := TStringList.Create;
   try
      for i := 0 to GridTableView.DataController.RecordCount-1 do
         begin
            Line := '';
            Line := Line + VarToStr(GridTableView.DataController.Values[i,tvBusinessIdIndex]) + '|';
            Line := Line + VarToStr(GridTableView.DataController.Values[i,tvBusinessNameIndex]) + '|';
            Line := Line + VarToStr(GridTableView.DataController.Values[i,tvInvDateIndex]) + '|';
            Line := Line + VarToStr(GridTableView.DataController.Values[i,tvNominalIdIndex])+ '|';
            Line := Line + VarToStr(GridTableView.DataController.Values[i,tvNominalNameIndex])+ '|';
            Line := Line + VarToStr(GridTableView.DataController.Values[i,tvQtyIndex])+ '|';
            Line := Line + VarToStr(GridTableView.DataController.Values[i,tvAmtIndex])+ '|';
            Line := Line + VarToStr(GridTableView.DataController.Values[i,tvVATCodeIndex])+ '|';
            Line := Line + VarToStr(GridTableView.DataController.Values[i,tvVATAmtIndex])+ '|';
            Line := Line + VarToStr(GridTableView.DataController.Values[i,tvRefIndex]) + '|';
            Line := Line + VarToStr(GridTableView.DataController.Values[i,tvCommentIndex]);
            DataFile.Add(Line);
         end;
      DataFile.SaveToFile(FileName);
   finally
      FreeAndNil(DataFile);
   end;
end;

procedure TSimpleInvoiceBaseFrame.TransGridTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  GridTableViewDataControllerDataChanged(Sender);
  //CalcTxNos();
end;

function TSimpleInvoiceBaseFrame.GetDataDir: string;
begin
   Result := AccsDataModule.AccsDataBase.Directory;
end;

function TSimpleInvoiceBaseFrame.IsRowEmpty(
  ARecordIndex: Integer): Boolean;
var
   RowType: string;
begin
   Result := False;
   if (ARecordIndex > GridTableView.DataController.RecordCount-1) then Exit;

   Result := (VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvNominalIdIndex]) or
                 (GridTableView.DataController.Values[ARecordIndex,tvNominalIdIndex]<=0)) and
             (VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvVATCodeIndex]));

   if not Result then Exit;

   RowType := GetRowType(ARecordIndex);
   if (RowType='Header') then
      begin
         Result := (VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvBusinessIdIndex]) or
                       (GridTableView.DataController.Values[ARecordIndex,tvBusinessIdIndex]<=0)) and
                   (VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvInvDateIndex]) and
                       (GridTableView.DataController.Values[ARecordIndex,tvInvDateIndex]<=0)) or
                    VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvRefIndex]);
      end;
end;

function TSimpleInvoiceBaseFrame.GetNominalAccountHeading: string;
begin
//
end;

procedure TSimpleInvoiceBaseFrame.HandleKeyUpEvent(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   //
end;

procedure TSimpleInvoiceBaseFrame.KeySearchBusinessName(
  const ASearchText: string);
begin

end;

procedure TSimpleInvoiceBaseFrame.KeySearchNominalName(
  const ASearchText: string);
begin
   NewListBox.InitialSearchFieldText := ASearchText;
   InvokeLookupEditor(tvNominalNameIndex);
end;

procedure TSimpleInvoiceBaseFrame.LoadDefaultNominalForBusiness(
  const ABusinessId: Integer);
begin
end;

procedure TSimpleInvoiceBaseFrame.GridTableViewInitEdit(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  AEdit: TcxCustomEdit);
begin
   if not Assigned(AEdit.OnDblClick) then
      AEdit.OnDblClick := EditDoubleClickHandler;
end;

procedure TSimpleInvoiceBaseFrame.TransGridTableViewOnChange(
  Sender: TObject);
begin
   if (Sender is TcxButtonEdit) then
      (Sender as TcxButtonEdit).PostEditValue;

  GridTableViewDataControllerDataChanged(Sender);
end;

procedure TSimpleInvoiceBaseFrame.TransGridTableViewEditing(
  Sender: TcxCustomGridTableView; AItem: TcxCustomGridTableItem;
  var AAllow: Boolean);
var
   RowType: string;
begin
   // Prevent editing of tvBusinessNameIndex, tvInvDateIndex, tvRefIndex
   if (AItem.Index in ([tvBusinessNameIndex, tvInvDateIndex, tvRefIndex, tvCommentIndex])) then
      begin
         RowType := GetRowType(GridTableView.DataController.FocusedRecordIndex);
         AAllow := (FEditingInvoice = nil) or ((FEditingInvoice <> nil) and (RowType='Header'));
      end;
end;

procedure TSimpleInvoiceBaseFrame.FillVATCode(const AValue: Variant;
  const ARaiseErrorOnNotFound: Boolean);
begin
   TransGridCell[tvVATCodeIndex] := Null;

   if NewListBox.CheckVATCode(AValue) then
      TransGridCell[tvVATCodeIndex] := AValue
   else
      begin
         FDefaultFocusedItemIndex := tvVATCodeIndex;
         PostMessage(Handle, WM_FOCUS_DEFAULT_ITEM,0,0);
         if ARaiseErrorOnNotFound then
            ErrorMessage(Format('VAT Code "%s" was not found.',[AValue]));
      end;
end;

function TSimpleInvoiceBaseFrame.AcceptUserVATAmount(const ARecordIndex: Integer) : Boolean;
var
   OriginalVATAmount : Double;
   NewVATAmount : Double;
   Difference: Double;
   MarginAllowed : Double;

   Edit : TcxCustomEdit;
   Amounts: TVATAmount;
begin
   Result := True;

   if (VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvVATAmtIndex])) then Exit;
   NewVATAmount := GridTableView.DataController.Values[ARecordIndex,tvVATAmtIndex];

   if (VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex,tvVATOrigAmtIndex])) then Exit;

   OriginalVATAmount := GridTableView.DataController.Values[ARecordIndex,tvVATOrigAmtIndex];

   Difference := (OriginalVATAmount - NewVATAmount);
   if ( Difference = 0 ) then Exit;

   //   20/09/19 [V4.5 R0.5] /MK Change - George (TGM) asked that we change this allowed amount from 0.01 to 0.025.
   MarginAllowed := (OriginalVATAmount * 0.025);

   if (MarginAllowed < 0) then
      MarginAllowed := MarginAllowed * -1;

   if (Difference < 0) then
      Difference := Difference * -1;

   Result := (Difference <= MarginAllowed);
end;


procedure TSimpleInvoiceBaseFrame.VATAmountOnEditValueChanged(Sender: TObject);
var
   Edit : TcxCustomEdit;
begin
   if (not FVATAmountCheckModified) or (Sender = nil) then Exit;

   if (GridTableView.Controller.EditingItem = nil) or
      (GridTableView.Controller.FocusedItem = nil) then Exit;
   Edit := GridTableView.Controller.EditingController.Edit as TcxCustomEdit;
   if (Edit = nil) then Exit;

   Edit.PostEditValue;

   if (not AcceptUserVATAmount(GridTableView.DataController.FocusedRecordIndex)) then
      begin
         FVATAmountCheckModified := False;
         TcxCurrencyEditProperties(FVATAmountGridColumn.Properties).OnEditValueChanged := nil;

         Edit.EditValue := GridTableView.DataController.Values[GridTableView.DataController.FocusedRecordIndex,tvVATOrigAmtIndex];
         Edit.PostEditValue;

         PostMessage(Handle, WM_SHOW_MESSAGE_DIALOGUE, 0, cUSER_VAT_AMOUNT_ERROR_CODE);
      end;
end;

function TSimpleInvoiceBaseFrame.CalcVATAmount(): TVATAmount;
var
   TempVATCode,
   TempVAT,
   TempStr,
   TempLong,
   TempAmt    : ShortString;
   NomAmt,
   VatAmt     : Long;
   VatArrPos  : Integer;
   IsExclusive : Boolean;
   TempVar: Variant;
begin
   Result.Amount := 0;
   Result.VATAmount := 0;

   TempVATCode := '';
   NomAmt := 0;
   VATAmt := 0;

   with GridTableView.DataController do
      begin
         PostEditingData();

         TempVar := TransGridCell[tvVATCodeIndex];
         if not VarIsNull(TempVar) then
            begin
               TempVATCode := TempVar;
               SlimAll ( TempVATCode );
            end;

         if ((TempVATCode = '') or ( TempVATCode = 'Z' )) then
            begin
               if not VarIsNullOrEmpty(TransGridCell[tvAmtIndex]) then
                  Result.Amount := TransGridCell[tvAmtIndex];
               Exit;
            end;

         TempVar := TransGridCell[tvAmtIndex];
         if not VarIsNullOrEmpty(TempVar) then
            begin
               TempAMT := VarToStr(TempVar);
               ChangeToLong ( TempAMT );
               SlimAll ( TempAMT );
               StrLong ( TempAMT, NomAmt );
            end;

         TempVar := TransGridCell[tvVATAmtIndex];
         if not VarIsNull(TempVar) then
            begin
               TempVAT := TempVar;
               SlimAll ( TempVAT );
               StrLong ( TempVAT, VATAmt );
            end;

         if ( NewListBox.CheckVAT ( TempVATCode, VATArrPos )) then
            begin
               NewListBox.CalcTax ( VATArrpos, TempStr, VatAmt, NomAmt, IsExclusive );
               LongStr ( VatAmt, TempLong, 'L' );
               //Result.VATAmount := StrToFloat(TempLong);
               Result.VATAmount := StrToFloat(FlipNegative(TempLong));
               LongStr ( NomAmt, TempLong, 'L' );
               //Result.Amount := StrToFloat(TempLong);
               Result.Amount := StrToFloat(FlipNegative(TempLong));
            end;
      end;
end;

procedure TSimpleInvoiceBaseFrame.RemoveInvoiceFromGrid(
  ARecordIndex: Integer);
var
   RowType : string;
   UId: string;
begin
   RowType := GetRowType(ARecordIndex);
   if (RowType<>'Header') then Exit;

   if ( not VarIsNullOrEmpty(GridTableView.DataController.Values[ARecordIndex, tvInvUUIDIndex])) then Exit;

   UId := GUID();
   GridTableView.DataController.Values[ARecordIndex, tvInvUUIDIndex] := UId;
   RemoveInvoiceFromGrid(UId);
end;

procedure TSimpleInvoiceBaseFrame.CalcTxNos;
var
   i : Integer;
   FTempNextTxNo: Integer;
   RowType : string;
begin
   if ( GridTableView.DataController.RecordCount = 0 ) then Exit;
   FTempNextTxNo := FNextTxNo;
   GridTableView.DataController.Values[0,tvTxNoIndex] := FTempNextTxNo;
   //Inc(FTempNextTxNo, 2);
   for i := 1 to GridTableView.DataController.RecordCount-1 do
      begin
         RowType := GetRowType(i);
         if (RowType = 'Header') then
            begin
               Inc(FTempNextTxNo,3);
               GridTableView.DataController.Values[i,tvTxNoIndex] := FTempNextTxNo;
            end
         else if (RowType = 'Line') then
            Inc(FTempNextTxNo,2);
      end;
end;

{ TSimpleInvoiceValidationError }

constructor TSimpleInvoiceValidationError.create(AMessage: string;
  AIndex: Integer);
begin
   FMessage := AMessage;
   FIndex := AIndex;
end;

procedure TSimpleInvoiceBaseFrame.actDeleteInvoiceLineExecute(
  Sender: TObject);
var
   RowType: string;
begin
   if FEditingInvoice <> nil then Exit;

   RowType := GetRowType(GridTableView.DataController.FocusedRecordIndex);
   if (RowType <> 'Line') then Exit;

   GridTableView.DataController.BeginFullUpdate;
   try
      GridTableView.DataController.DeleteRecord(GridTableView.DataController.FocusedRecordIndex);
   finally
      GridTableView.DataController.EndFullUpdate;
   end;
end;

procedure TSimpleInvoiceBaseFrame.PopupMenuPopup(Sender: TObject);
var
   RowType: string;
begin
   if FEditingInvoice = nil then Exit;

   RowType := GetRowType(GridTableView.DataController.FocusedRecordIndex);
   pmDeleteInvoiceLine.Visible := (RowType = 'Line');
   pmDeleteInvoiceLine.Enabled := pmDeleteInvoiceLine.Visible;
   pmDeleteInvoice.Visible := (RowType = 'Header');
   pmDeleteInvoice.Enabled := pmDeleteInvoice.Visible;
end;

procedure TSimpleInvoiceBaseFrame.actDeleteInvoiceExecute(Sender: TObject);
var
   RowType: string;
begin
   if FEditingInvoice <> nil then Exit;

   RowType := GetRowType(GridTableView.DataController.FocusedRecordIndex);
   if (RowType <> 'Header') then Exit;

   GridTableView.DataController.BeginFullUpdate;
   try
      RemoveInvoiceFromGrid(GridTableView.DataController.FocusedRecordIndex);
   finally
      GridTableView.DataController.EndFullUpdate;
   end;
end;

end.
