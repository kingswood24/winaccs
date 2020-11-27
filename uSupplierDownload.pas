{
   23/09/11 [V4.1 R0.3] /MK Additional Feature - On FormCreate Check If Cash.Vat Is Checked Then cbVatRegistered.Checked.

   07/11/11 [V4.1 R0.7] /MK Bug Fix - FormCreate - Building Of Nomlisting Table Should Be Done Before qNominalLedger.Active.

   07/08/12 [V4.1 R2.1] /MK Change - Load file from GetImportFile.Filename to StringList and then to TextFile.
                                   - Allows files that were downloaded incorrectly from website to be imported.

   24/11/14 [V4.1 R7.6] /MK Additional Feature - Added payment button that allows users to record payment
                                                 in this unit. Payment supplier is associated from the selected
                                                 supplier in cmboSupplier.

   02/03/16 [V4.1 R1.9] /MK Additional Feature - Incorporated Andrew's (TGM) changes to update new fields in transactions table.
                            Bug Fix - ReadFile - If wrong file i.e. file header contents does not match co-op selected then close MyFile and exit ReadFile procedure.

   21/12/17 [V4.3 R0.1] /MK Additional Feature - Improved grid to look like the bank link with wider columns and line/column height increased.
                                               - Removed the old NomName lookup type field and added a NomName data type field.
                                               - Improved search option for Nominal which shows the ListBox screen like the Bank Link screen.
                                               - Allow user to type into Nominal field and it will popup list box with first letter typed, again, like Bank Link - DOM requests.

   15/01/19 [V5.8 R4.1] /MK Bug Fix - actImportExecute - If MyFile is open then close it before assigning it again - Monika reported. 
}

unit uSupplierDownload;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uBaseForm, ActnList, dxBar, dxBarExtItems, cxControls, dxStatusBar,
  cxContainer, cxEdit, cxGroupBox, StdCtrls, cxLabel, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, cxCheckBox, cxCalendar, cxCurrencyEdit,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridLevel,
  cxClasses, cxGridCustomView, cxGrid, Db, DBTables, Registry, cxHint,
  RxLookup, uPreferences, uPreferenceConsts, KRoutines,
  cxEditRepositoryItems, cxButtonEdit, AccsUtils, Types, uAccounts,
  cxStyles, uAccsMessages;

const
   cUserInfo = 'Statement from ';
   WM_INVOKESEARCHITEM = WM_USER+2;

type
  TfmSupplierDownload = class(TBaseForm)
    blbSkipTransaction: TdxBarLargeButton;
    actSkipTransaction: TAction;
    blbSelectCoOp: TdxBarLargeButton;
    actSelectCoOp: TAction;
    gbCoOp: TcxGroupBox;
    cmboSupplier: TcxLookupComboBox;
    cxLabel1: TcxLabel;
    gbTotals: TcxGroupBox;
    ceTotalVAT: TcxCurrencyEdit;
    ceTotalLessVAT: TcxCurrencyEdit;
    ceTotalAmt: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    teStatementFor: TcxTextEdit;
    cxLabel6: TcxLabel;
    cxLabel7: TcxLabel;
    cbVATRegistered: TcxCheckBox;
    cxLabel8: TcxLabel;
    teReference: TcxTextEdit;
    cxLabel9: TcxLabel;
    teComment: TcxTextEdit;
    dsImportTable: TDataSource;
    ImportTable: TTable;
    ImportTableID: TAutoIncField;
    ImportTableNLAcc: TIntegerField;
    ImportTableRecIdent: TStringField;
    ImportTableAccType: TStringField;
    ImportTableInvDate: TDateTimeField;
    ImportTableCompanyCode: TStringField;
    ImportTableDescription: TStringField;
    ImportTableQuantity: TFloatField;
    ImportTableUnits: TStringField;
    ImportTableAmount: TFloatField;
    ImportTableVATRate: TFloatField;
    ImportTableExpCode: TStringField;
    ImportTableTransRef: TStringField;
    ImportTableTaxIDS: TStringField;
    ImportTableTaxRate: TIntegerField;
    ImportTableTaxAmount: TFloatField;
    ImportTableDocketNo: TStringField;
    ImportGridDBTableView: TcxGridDBTableView;
    ImportGridLevel: TcxGridLevel;
    ImportGrid: TcxGrid;
    ImportGridDBTableViewID: TcxGridDBColumn;
    ImportGridDBTableViewNlAcc: TcxGridDBColumn;
    ImportGridDBTableViewRecIdent: TcxGridDBColumn;
    ImportGridDBTableViewAccType: TcxGridDBColumn;
    ImportGridDBTableViewInvDate: TcxGridDBColumn;
    ImportGridDBTableViewCompanyCode: TcxGridDBColumn;
    ImportGridDBTableViewDescription: TcxGridDBColumn;
    ImportGridDBTableViewQuantity: TcxGridDBColumn;
    ImportGridDBTableViewUnits: TcxGridDBColumn;
    ImportGridDBTableViewAmount: TcxGridDBColumn;
    ImportGridDBTableViewVATRate: TcxGridDBColumn;
    ImportGridDBTableViewExpCode: TcxGridDBColumn;
    ImportGridDBTableViewTransRef: TcxGridDBColumn;
    ImportGridDBTableViewNomName: TcxGridDBColumn;
    ImportGridDBTableViewTaxIDS: TcxGridDBColumn;
    ImportGridDBTableViewTaxRate: TcxGridDBColumn;
    ImportGridDBTableViewTaxAmount: TcxGridDBColumn;
    ImportGridDBTableViewDocketNo: TcxGridDBColumn;
    VatCodes: TTable;
    dsVatCodes: TDataSource;
    teThisDate: TcxTextEdit;
    teTxDate: TcxTextEdit;
    GetImportFile: TOpenDialog;
    HintStyleController: TcxHintStyleController;
    dxblbEnterPayment: TdxBarLargeButton;
    actEnterPayment: TAction;
    ImportGridDBTableViewEnterprise: TcxGridDBColumn;
    cxEditRepository1: TcxEditRepository;
    erCurrency: TcxEditRepositoryCurrencyItem;
    erButtonEdit: TcxEditRepositoryButtonItem;
    cxStyleRepository1: TcxStyleRepository;
    TransGridNormalStyle: TcxStyle;
    EmphasizedHeaderStyle: TcxStyle;
    ImportTableNomName: TStringField;
    procedure actSelectCoOpExecute(Sender: TObject);
    procedure cbVATRegisteredPropertiesChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actSave2Execute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImportTableAfterPost(DataSet: TDataSet);
    procedure ImportTableBeforeInsert(DataSet: TDataSet);
    procedure ImportTableInvDateValidate(Sender: TField);
    procedure FormShow(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
    procedure actSkipTransactionExecute(Sender: TObject);
    procedure actImportExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormClick(Sender: TObject);
    procedure ImportGridDBTableViewCellClick(
      Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);
    procedure gbCoOpEnter(Sender: TObject);
    procedure ImportGridDBTableViewMouseEnter(Sender: TObject);
    procedure gbCoOpClick(Sender: TObject);
    procedure gbTotalsClick(Sender: TObject);
    procedure cmboSupplierEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actEnterPaymentExecute(Sender: TObject);
  private
    function GetSelectedSupplier: Integer;
    procedure ButtonEditClick(Sender: TObject; AButtonIndex: Integer);
    procedure ButtonEditOnChange(Sender: TObject);
    function FocusedColumnString: string;
    procedure FindAndPostNominal(const ASearchTextValue : string = '');
    function IsIncomeOrExpense: TTransactionType;
  private
    { Private declarations }
    CoOpName : string;
    YearStart,
    YearEnd,
    ThisYear,
    ThisMonth   : Integer;
    SavedInfo,                  // TRUE if you saved 1 or more TX's
    ReadRecord,
    Headerfound : Boolean;
    MyFile : TextFile;
    DiskLine : String;
    Finished: Boolean; // set when eof(MyFile)
    NewDairygoldFormat : boolean; // saves not Dairygold Format
    FFileList : TStringList;
    FRefreshTransGrid: Boolean;
    procedure CreateDownLoadTable;
    procedure ReadFile;
    procedure CheckImportDates;   // Check the Date month combo to warn user
    function  IsNegOrPos(TestStr : ShortString) : String;
    function  FindVAT (ThisRate : Double ) : Boolean;
    procedure CheckIfSaved;
    function  CheckImportTable : Boolean;
    procedure GetNextTx;
    procedure SETVALS;
    function  MoveTxInfo : Boolean;
    procedure UpdateTableWithComments;  // TGM AB 05/02/16
    procedure StoreNominalSelection(const ANomCode : Integer);
    procedure InvokeQuantityScreen;
    procedure EditCBEQuantities(APoint : TPoint);
    procedure InvokeSearchItem(var Message:TMessage); message WM_INVOKESEARCHITEM;
    property SelectedSupplier : Integer read GetSelectedSupplier;
  public
    { Public declarations }
    class procedure ShowSupplierDownload;
  end;

var
  fmSupplierDownload: TfmSupplierDownload;

implementation

uses uCoOpSelect, AccsData, Clears,
     TxWrite,
     Calcs,
     Vars,
     DBGen,
     newListing,
     Vat,
     FullAudit,
     DBCore,
     Util,
     Cashbook,
     Params,
     uSupplierDownloadDateWarning;

{$R *.DFM}

procedure TfmSupplierDownload.actSelectCoOpExecute(Sender: TObject);
var
   RecNo: Integer;
   Located : Boolean;
   NewRec : Integer;
   AccRange    : TAccRange;
   AccountNo : integer;
begin
   inherited;
   HintStyleController.HideHint;
   CoOpName := TfmCoOpSelect.GetCoOpName;

   Screen.Cursor := crHourGlass;
   try
      Caption := CoOpName + ' Download';

      if ( AccsDataModule.PurchaseLedger.locate('Account',accsDataModule.Importdefaults['DefaultAccount'],[]) ) then
         cmboSupplier.EditValue := accsdatamodule.PurchaseLedger['Account']
      else
         cmboSupplier.EditValue := Null;

      gbCoOp.Caption := cUserInfo + CoOpName;

      //if ( cash1.xcashbook ) then
         //begin
            AccountNo := 0;
            AccRange[1] := 1;
            AccRange[2] := -1;
            // sets account range to all

            Located := False;
            SETDB(plFile);

            for RecNo:= 1 to db1.DBRECTOT do
                begin
                   READREC(plFile,RECNO);
                   if ( RECACTIVE(plFile) ) then
                      begin
                         Getitem(plfile,1);
                         if ( UpperCase(currstr) = (UpperCase(CoOpName) + ' PURCHASE A/C') ) then
                            begin
                               located := True;
                               AccountNo := RecNo;
                            end;
                      end;
                end;

            if ( not(located) ) then
               begin
                  NewRec := GetNextFreeAccount (plFile,AccRange);
                  BlankRec (plFile, 'A' );
                  AddRecord (plFile, NewRec, False );
                  PutStr (plFile, (CoOpName + ' Purchase A/C'), 1 );
                  RewriteRec (plfile, NewRec );
                  AccountNo := NewRec;
                  AccsDatamodule.PurchaseLedger.close;
                  AccsDataModule.GetPurchaseLedgerAccs;
                  AccsDatamodule.PurchaseLedger.open;
               end;

            accsDataModule.importdefaults.edit;
            accsDataModule.Importdefaults['DefaultAccount'] := AccountNo;
            accsDataModule.ImportDefaults.post;
            AccsDataModule.PurchaseLedger.locate('Account',AccountNo,[]);
            cmboSupplier.EditValue := AccountNo; 
         //end;

      teComment.SetFocus;
   finally
      Screen.Cursor := crDefault;
   end;

   Update;
end;

procedure TfmSupplierDownload.CheckImportDates;
begin
   try
      AccsDataModule.ImportDates.Open;
      if AccsDataModule.ImportDates.Locate('ImportYear;ImportMonth;Importfrom',
            VarArrayOf([ThisYear, ThisMonth, AccsDataModule.ImportDefaultsCoOpName.AsVariant]), []) then
         ShowMessage('Some of this Data may already have been inported.  If so, you will have to click on ''Skip Past This Transaction'' until you''re past the item already entered previously');
   finally
      AccsDataModule.ImportDates.Close;
   end;
end;

procedure TfmSupplierDownload.CreateDownLoadTable;
var
   i : Integer;
begin
    with ImportTable do
       begin
           Close;
           FieldDefs.Clear;
           IndexDefs.Clear;
           TableName := 'Import';
           with FieldDefs do
              begin
                 Add('ID',ftAutoInc,0,FALSE);
                 Add('NLAcc',ftInteger,0,FALSE);
                 Add('NomName',ftString,30,FALSE);
                 Add('RecIdent',ftString,5,FALSE);
                 Add('AccType',ftString,1,FALSE);
                 Add('InvDate',ftDateTime,0,FALSE);
                 Add('CompanyCode',ftString,10,FALSE);
                 Add('Description',ftString,30,FALSE);
                 Add('Quantity',ftFloat,0,FALSE);
                 Add('Units',ftString,10,FALSE);
                 Add('Amount',ftFloat,0,FALSE);
                 Add('VATRate',ftFloat,0,FALSE);
                 Add('ExpCode',ftString,20,FALSE);
                 Add('TransRef',ftString,8,FALSE);
                 Add('DocketNo',ftString,15,FALSE);
                 Add('TaxIDS',ftString,1,FALSE);          // Kingswood VAT Code
                 Add('TaxRate',ftInteger,0,FALSE);        // Kingswood VAT Code
                 Add('TaxAmount',ftFloat,0,FALSE);
              end;
           CreateTable;
           Open;
       end;
    with VatCodes do
       begin
           Close;
           FieldDefs.Clear;
           IndexDefs.Clear;
           TableName := 'VatCodes';
           with FieldDefs do
              begin
                 Add('ID',ftAutoInc,0,FALSE);
                 Add('TaxIds',ftString,1,FALSE);
                 Add('TaxRate',ftFloat,0,FALSE);
                 Add('IncExc',ftString,1,FALSE);
                 Add('Description',ftString,7,FALSE);
              end;
           CreateTable;
           Open;
           // Insert the VAT codes from Cash1 and Cash11
           for i := 0 to 9 do
              if ( Cash1.xtaxids[i] <> ' ' ) then
                 begin
                    Append;
                    FieldByName('TaxIDs').AsString := Cash1.xtaxids[i];
                    FieldByName('TaxRate').AsFloat := (Cash1.xtaxRates[i]/100);
                    FieldByName('IncExc').AsString := Cash2.xtaxTypes[i];
                    FieldByName('Description').AsString := Cash11.Vat_desc[i];
                    Post;
                 end;
       end;
end;

function TfmSupplierDownload.FindVAT(ThisRate: Double): Boolean;
var VATInclusive:char;
begin
     VatCodes.First;
    RESULT := FALSE;
    If AccsDataModule.ImportDefaults['VATInclusive'] then VATInclusive := 'I' else VATInclusive:= 'E';
    if ((ThisRate > 0) and (Vatcodes.locate('TaxRate;IncExc',varArrayOf([ThisRate,VATInclusive]),[]))) then result:=true
     else if thisrate > 0 then showmessage('There is no matching VAT rate for ' + varToStr(ThisRate) + '%, VAT Type ' + VATInclusive +'.  Please setup or amend an existing VAT Rate code now');
    if ((ThisRate = 0) and (Vatcodes.locate('TaxRate',ThisRate,[]))) then
       if VatCodes['TaxIDs'] = '0' then showmessage('The only VAT code setup in Kingswood with a 0% VAT Rate is the VAT Exempt code.  Please set up another zero rated code')
       else result := true;
end;

function TfmSupplierDownload.IsNegOrPos(TestStr: ShortString): String;
var
   NegNum : Boolean;
begin
    NegNum := FALSE;

    SlimAll(TestStr);
    NegNum := FALSE;
    if POS('+',TestStr) > 0 then
       Delete(TestStr,POS('+',TestStr),1)
    else if POS('-',TestStr) > 0 then
       begin
          Delete(TestStr,POS('-',TestStr),1);
          NegNum := TRUE;
       end;
    if NegNum then
       RESULT := '-' + TestStr
    else
       RESULT := TestStr;
end;

procedure TfmSupplierDownload.ReadFile;
var
   EndOfTx,
   NegNum  : Boolean;
   i : Integer;
   LastDocket,
   DateStr : String;
   TempStr : ShortString;
   sDay,
   sMonth,
   sYear,
   NewDate : String;
   DateSet,
   CompanyCodeOk,
   DescriptionOK,
   QuantityOK,
   AmountOK,
   VATRateOK,
   TransRefOK,
   NoErrors     : Boolean;
   ItemsRead    : Integer;      // Allow Maxof Ten Items per invoice
   AmountIncVAT : Real;
   HeaderStr,DetailTypeStr    : string;
   SkipStr1,SkipStr2,SkipStr3 : string;
   TotalLessVATAmount, TotalVATAmount, TotalAmount : real;
   NominalAccount : TNominalAccount;

   function CheckDates : Boolean;
   var
      DateOK : Boolean;
   begin
        RESULT := TRUE;
   end;

   procedure ReportErrors;
   begin
     if NOT DateSet then
        MessageDLG('Error - No Valid Date found',mtInformation,[mbOK],0);
     if NOT CompanyCodeOK then
        MessageDLG('Cannot find Company Code',mtInformation,[mbOK],0);
     if NOT DescriptionOK then
        MessageDLG('Cannot find Description',mtInformation,[mbOK],0);
     if NOT QuantityOK then
        MessageDLG('Cannot find/convert Quantity',mtInformation,[mbOK],0);
     if NOT AmountOK then
        MessageDLG('Cannot find/convert Amount',mtInformation,[mbOK],0);
     if NOT VATRateOK then
        MessageDLG('Cannot find/Convert VAT Rate',mtInformation,[mbOK],0);
     if NOT TransRefOK then
        MessageDLG('Cannot find Transaction reference',mtInformation,[mbOK],0);
   end;

begin  // ReadFileFromDisk
  DateSet       := TRUE;
  CompanyCodeOk := TRUE;
  DescriptionOK := TRUE;
  QuantityOK    := TRUE;
  AmountOK      := TRUE;
  VATRateOK     := TRUE;
  TransRefOK    := TRUE;
  NoErrors      := TRUE;
  TotalLessVATAmount := 0;
  TotalVATAmount := 0;
  TotalAmount := 0;

  try
     if CheckDates then
        begin
           DateSet := TRUE;

           // Empty the Table
           ImportTable.Close;
           ImportTable.EmptyTable;
           ImportTable.Open;

           EndOfTx := FALSE;
           LastDocket := '-1';
           ItemsRead := 0;
           HeaderStr := AccsDataModule.ImportDefaults['HeaderString'];
           SkipStr1 := varToStr(AccsDataModule.ImportDefaults['SkipString1']);
           SkipStr2 := varToStr(AccsDataModule.ImportDefaults['SkipString2']);
           SkipStr3 := varToStr(AccsDataModule.ImportDefaults['SkipString3']);

           while NOT EOF(MyFile) and ( NOT HeaderFound ) do
              try
                 ReadLn(MyFile,DiskLine);
                 TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsRecTypeStart.AsInteger, AccsDataModule.ImportDefaultsRecTypeLen.AsInteger);
                 If TempStr = HeaderStr then
                    begin
                       if ( pos('1]Dairygold         ',DiskLine) > 0 ) then
                          NewDairyGoldFormat := True;  // Old File has 1]Dairygold Co-Operative

                       if AccsDataModule.ImportDefaults['HeaderDateFormat'] = 'YYYYMM' then
                          begin
                             TempStr := Copy(DiskLine,AccsDataModule.ImportDefaultsHeaderDateStart.AsInteger,6);
                             ThisMonth := StrToInt(Copy (TempStr,5,2));
                             ThisYear  := StrToInt(Copy (TempStr,1,4));
                             teThisDate.Text := Copy (TempStr,5,2) + '/';
                             teThisDate.Text := teThisDate.Text + Copy (TempStr,1,4);
                             TempStr := Copy(DiskLine,AccsDataModule.ImportDefaultsCustomerNameStart.asInteger,AccsDataModule.ImportDefaultsCustomerNameLen.asInteger);
                             teStatementFor.Text := TempStr;
                             Headerfound := TRUE;
                          end;

                       if AccsDataModule.ImportDefaults['HeaderDateFormat'] = 'MMYYYY' then
                          begin
                             TempStr := Copy(DiskLine,AccsDataModule.ImportDefaultsHeaderDateStart.asInteger,6);
                             ThisMonth := StrToInt(Copy (TempStr,1,2));
                             ThisYear  := StrToInt(Copy (TempStr,3,4));
                             teThisDate.Text := Copy (TempStr,1,2) + '/';
                             teThisDate.Text := teThisDate.Text + Copy (TempStr,3,4);
                             TempStr := Copy(DiskLine,AccsDataModule.ImportDefaultsCustomerNameStart.asInteger,AccsDataModule.ImportDefaultsCustomerNameLen.asInteger);
                             teStatementFor.Text := TempStr;
                             Headerfound := TRUE;
                          end;

                       if AccsDataModule.ImportDefaults['HeaderDateFormat'] = 'DDMMMYYYY' then
                          begin
                             TempStr := Copy(DiskLine,AccsDataModule.ImportDefaultsHeaderDateStart.asInteger,11);
                             DDMMMYYYYtoStr(TempStr);
                             ThisMonth := StrToInt(Copy (TempStr,4,2));
                             ThisYear  := StrToInt(Copy (TempStr,7,4));

                             teThisDate.Text := Copy (TempStr,4,2) + '/' + Copy (TempStr,7,4);
                             TempStr := Copy(DiskLine,AccsDataModule.ImportDefaultsCustomerNameStart.asInteger,AccsDataModule.ImportDefaultsCustomerNameLen.asInteger);
                             //TempStr := Copy(DiskLine,147,50);
                             teStatementFor.Text := TempStr;
                             Headerfound := TRUE;
                          end;

                       // test to See if the Year month Combo exists for this Import
                       CheckImportDates;
                    end;
              except
                 //   02/03/16 [V4.2 R1.9] /MK Bug Fix - If wrong file i.e. file header contents does not match co-op selected then close MyFile and exit ReadFile procedure. 
                 CloseFile(MyFile);
                 Exit; 
              end;

           // Process the Statement Disk
           if HeaderFound then
           //while NOT EOF(MyFile) and ( NOT EndOfTx ) and ( ItemsRead < 10 ) do
           // TGM 22/02/02 had to use finished rather than eof, as the last transaction was not
           // being processed if it was a single transaction
           while (NOT Finished) and ( NOT EndOfTx ) and ( ItemsRead < 10 ) do
              begin
                 if eof(MyFile) then finished:=true else // tgm real problems with this but this now works
                 if ReadRecord then
                    ReadLn(MyFile,DiskLine);
                 ReadRecord := TRUE;
                 // skip past the opening balance and closing balance lines if glanbia
                 //if not ((AccsDataModule.importdefaults['CoOpName'] = 'Glanbia') and ((copy(DiskLine,99,15) = 'OPENING BALANCE') or (copy(DiskLine,99,15) = 'CLOSING BALANCE'))) then begin
                 TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsDescriptionStart.AsInteger, AccsDataModule.ImportDefaultsDescriptionLen.AsInteger);
                 SlimRight(TempStr);
                 if not ((SkipStr1 = TempStr) or (SkipStr2 = TempStr) or (SkipStr3 = TempStr)) then begin

                  TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsDocketNoStart.AsInteger, AccsDataModule.ImportDefaultsDocketNoLen.AsInteger);
                  if  {( TempStr = 'TLR2' ) or}
                    (( TempStr <> LastDocket ) And ( LastDocket <> '-1' )) then
                    begin
                       EndOfTx := TRUE;   // Break from Loop
                       ReadRecord := FALSE;
                    end;

                  //if AccsDataModule.ImportDefaultsCoOpName.AsString = cDairygold then
                    LastDocket := TempStr;

                  if ReadRecord then
                    begin
                       DetailTypeStr := VarToStr(AccsDataModule.importDefaults['DetailString']);
                       TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsRecTypeStart.AsInteger, AccsDataModule.ImportDefaultsRecTypeLen.AsInteger);
                       {if ( TempStr = 'SALES' ) Or
                          ( TempStr = '2' ) or (TempStr = 'CREDIT SALE  ') or (TempStr = 'GENERAL DEBIT') then}
                       if TempStr = DetailTypeStr then
                          begin
                             ImportTable.Insert;
                             try
                                TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsDateStart.AsInteger, AccsDataModule.ImportDefaultsDateLen.AsInteger);
                                // ReFormat it to dd/mm/yyyy
                                DateStr := '';
                                if (AccsDataModule.ImportDefaults['HeaderDateFormat'] = 'DDMMMYYYY') then begin
                                   DDMMMYYYYtoStr(TempStr);
                                   DateStr:=TempStr;
                                end else
                                if NewDairyGoldFormat then begin
                                   DateStr := Copy (TempStr,1,2) + '/';
                                   DateStr := DateStr + Copy (TempStr,3,2) + '/';
                                   DateStr := DateStr + Copy (TempStr,5,4);
                                end else begin
                                   DateStr := Copy (TempStr,7,2) + '/';
                                   DateStr := DateStr + Copy (TempStr,5,2) + '/';
                                   DateStr := DateStr + Copy (TempStr,1,4);
                                end;
                                if ( Length(DateStr) > 0 ) then
                                   ImportTable['InvDate'] := StrToDateTime(DateStr);
                             except
                                ImportTable.FieldByName('InvDate').Clear;
                             end;
                             tetxDate.Text:=DateStr;
                             // Insert the Docket Number
                             ImportTableDocketNo.AsString := LastDocket;
                             teReference.Text:=LastDocket;

                             // Get the Kerry Product Code
                             TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsAccountStart.AsInteger, AccsDataModule.ImportDefaultsAccountLen.AsInteger);
                             SlimAll(TempStr);
                             try
                                ImportTable.FieldByName('CompanyCode').Value := TempStr;
                             except
                                CompanyCodeOK := FALSE;
                                NoErrors := FALSE;
                             end;

                             // Get the Description
                             TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsDescriptionStart.AsInteger, AccsDataModule.ImportDefaultsDescriptionLen.AsInteger);
                             try
                                ImportTable.FieldByName('Description').Value := TempStr;
                             except
                                DescriptionOK := FALSE;
                                NoErrors := FALSE;
                             end;

                             // Get the Quantity
                             //if ((AccsDataModule.importdefaults['CoOpName'] = cGlanbia) and (length(DiskLine) < AccsDataModule.ImportDefaults['QuantityStart'])) then
                             if (length(DiskLine) < AccsDataModule.ImportDefaults['QuantityStart']) then
                                TempStr := '0000'
                             else TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsQuantityStart.AsInteger, AccsDataModule.ImportDefaultsQuantityLen.AsInteger);
                             SlimAll(TempStr);
                             try
                                if AccsDataModule.ImportDefaultsQuantityDec.AsInteger = 2 then
                                   ImportTable.FieldByName('Quantity').Value := StrToFloat(IsNegOrPos(TempStr))/100
                                else if AccsDataModule.ImportDefaultsQuantityDec.AsInteger = 3 then
                                   ImportTable.FieldByName('Quantity').Value := StrToFloat(IsNegOrPos(TempStr))/1000
                                else
                                   ImportTable.FieldByName('Quantity').Value := StrToFloat(IsNegOrPos(TempStr));
                             except
                                QuantityOK := FALSE;
                                NoErrors := FALSE;
                             end;

                             // Get the Amount
                             TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsAmountStart.AsInteger, AccsDataModule.ImportDefaultsAmountLen.AsInteger);
                             SlimAll(TempStr);
                             try
                                if TempStr = '+' then   // No amount entered
                                   ImportTable.FieldByName('Amount').Value := 0
                                else if AccsDataModule.ImportDefaultsAmountDec.AsInteger = 2 then
                                   ImportTable.FieldByName('Amount').Value := StrToFloat(IsNegOrPos(TempStr))/100
                                else
                                   ImportTable.FieldByName('Amount').Value := StrToFloat(IsNegOrPos(TempStr))/1000;
                             except
                                AmountOK := FALSE;
                                NoErrors := FALSE;
                             end;
                             // next bit allows for the Glanbia credit charge lines, as they're shorter and have no VAT rate or quantity
                             if (length(DiskLine) < AccsDataModule.ImportDefaults['QuantityStart']) then
                             TempStr := '0000'
                             // Get the VAT Rate
                             else TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsVATRateStart.AsInteger, AccsDataModule.ImportDefaultsVATRateLen.AsInteger);
                             try
                                if AccsDataModule.ImportDefaultsVATRateDec.AsInteger = 2 then
                                   ImportTable.FieldByName('VATRate').Value := StrToFloat(IsNegOrPos(TempStr))/100
                                else
                                   ImportTable.FieldByName('VATRate').Value := StrToFloat(IsNegOrPos(TempStr))/1000;
                                if ((Cash11.Xuse_vat) or (not cbVATRegistered.checked)) then
                                   begin
                                      ImportTable.FieldByName('TaxIDS').AsString := Cash1.xTaxIDs[0];
                                      ImportTable.FieldByName('TaxRate').AsFloat := 0;
                                   end
                                else
                                   begin
                                      while not FindVAT (ImportTable.FieldByName('VATRate').AsFloat) do begin
                                            FVat.showmodal;
                                            with VatCodes do begin
                                                 TableName := 'VatCodes';
                                                 close;
                                                 emptytable;
                                                 open;
                                                 // Insert the VAT codes from Cash1 and Cash11
                                                 for i := 0 to 9 do
                                                 if ( Cash1.xtaxids[i] <> ' ' ) then begin
                                                    Append;
                                                    FieldByName('TaxIDs').AsString := Cash1.xtaxids[i];
                                                    FieldByName('TaxRate').AsFloat := (Cash1.xtaxRates[i]/100);
                                                    FieldByName('IncExc').AsString := Cash2.xtaxTypes[i];
                                                    FieldByName('Description').AsString := Cash11.Vat_desc[i];
                                                    Post;
                                                 end;
                                            end;


                                         end;// else
                                         begin
                                            ImportTable.FieldByName('TaxIDS').AsString := VatCodes.FieldByName('TaxIDS').AsString;
                                            ImportTable.FieldByName('TaxRate').AsFloat := VatCodes.FieldByName('TaxRate').AsFloat;

                                            if accsDataModule.ImportDefaults['VATInclusive'] then
                                               begin
                                                  AmountIncVAT := round(ImportTable['Amount']*100)/100;
                                                  ImportTable['Amount'] := round((AmountIncVAT / (1+ VatCodes['TaxRate'] / 100)*100))/100;
                                                  ImportTable['TaxAmount'] := AmountIncVAT - ImportTable['Amount'];
                                               end
                                            else
                                                ImportTable.FieldByName('TaxAmount').AsFloat := (ImportTable.FieldByName('Amount').Value / (1+ VatCodes.FieldByName('TaxRate').AsFloat)) / 100;

                                            TotalVATAmount := TotalVATAmount + ImportTable['TaxAmount'];
                                            ceTotalVat.text:=VarToStr(TotalVATAmount);

                                         end;
                                   end;
                             except
                                VATRateOK := FALSE;
                                NoErrors := FALSE;
                             end;
                             TotalLessVATAmount := TotalLessVATAmount + ImportTable['Amount'];
                             ceTotalLessVAT.Text := varToStr(TotalLessVATAmount);
                             TotalAmount:=TotalVATAmount + TotalLessVATAmount;
                             ceTotalAmt.text := varToStr(TotalAmount);
                             // Get the Reference
                             TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsReferenceStart.AsInteger, AccsDataModule.ImportDefaultsReferenceLen.AsInteger);
                             try
                                ImportTable.FieldByName('TransRef').Value := TempStr;
                             except
                                TransRefOK := FALSE;
                                NoErrors := FALSE;
                             end;

                             // Try to find a match
                             if AccsDataModule.NomMatch.Locate('ExtFileCode',ImportTable.FieldByName('CompanyCode').AsString,[loCaseInsensitive]) then
                                if AccsDataModule.qNominalLedger.Locate('Account',AccsDataModule.NomMatch.FieldByName('NlRecNo').AsInteger,[] ) then
                                   begin
                                      NominalAccount := AccsDatamodule.Accounts.GetNominalAccount(AccsDataModule.NomMatch.FieldByName('NlRecNo').AsInteger);
                                      if ( NominalAccount <> nil ) then
                                         begin
                                            ImportTable.FieldByName('NomName').AsString := NominalAccount.Name;
                                            ImportTable.FieldByName('NLacc').AsInteger := AccsDataModule.NomMatch.FieldByName('NlRecNo').AsInteger;
                                         end;
                                   end;

                             ImportTable.Post;
                             Inc(ItemsRead);
                          end;
                    end;
                  end;
                  if ((not EndOfTx) and EOF(MyFile)) then finished:=true;
              end; // of while not finished


           if ( NOT NoErrors ) then
              begin
                 ImportTable.Close;
                 ImportTable.EmptyTable;
                 ImportTable.Open;
                 ReportErrors;
                 MessageDLG('Error on Statement Disk',mtWarning,[mbOK],0);
              end;
        end // of if checkdates
     else
        MessageDLG('Cannot continue without a valid Date',mtWarning,[mbOK],0);
  except

     on e : exception do
        begin
           ImportTable.Close;
           ImportTable.EmptyTable;
           ReportErrors;
           MessageDLG(E.Message + ' - Error(s) loading Statement Disk',mtWarning,[mbOK],0);
        end;
  end; // of try
end;

class procedure TfmSupplierDownload.ShowSupplierDownload;
var
   PCount : Integer;
begin
   with TfmSupplierDownload.Create(nil) do
      try
         PREVENT_TRANSACTIONGRID_LOADING_ON_TRANSACTION_WRITE := True;

         for PCount := 1 To MaxTx Do
            New ( TxHold[PCount] );
         for PCount := 1 To MaxNom Do
            New ( NomHold[PCount] );

         { Initialise the Pointer Variable }
         // not at all sure what's being done below TGM 18/02/02  MC wrote the code
         for PCount := 1 To MaxTx Do
            FillChar ( TxHold[PCount]^, SizeOf(TxHold[PCount]^),chr(0));
         for PCount := 1 To MaxNom Do
            FillChar ( NomHold[PCount]^, SizeOf(NomHold[PCount]^),chr(0));

         try
            AccsDataModule.NomMatch.Open;
         except
            ShowMessage('Cannot open match Table');
         end;

         if ( AccsDataModule.NomMatch.Active ) and ( AccsDataModule.ImportDefaults.Active ) then
            begin
               //pSetDefault.Hide;
               //pWarning.Hide;
               // Get the finalial year start and end
               GetFinDateRange(YearStart,YearEnd);
               SavedInfo := FALSE;
            end;

         ShowModal;
      finally

         PREVENT_TRANSACTIONGRID_LOADING_ON_TRANSACTION_WRITE := False;
         for PCount := 1 to MaxTx do
            Dispose ( TxHold[PCount] );
         for PCount := 1 to MaxNom do
            Dispose ( NomHold[PCount] );
         try
            CloseFile(MyFile);
         except

         end;
         AccsDataModule.NomMatch.Close;
         if AccsDataModule.PurchaseLedger.Locate('Account',AccsDataModule.ImportDefaults['DefaultAccount'],[]) then begin
            cmboSupplier.EditValue := AccsDataModule.PurchaseLedger['Account'];//.Text:= AccsDataModule.PurchaseLedger['Name'];
         end;
         AccsDataModule.ImportDefaults.Close;

         if FRefreshTransGrid then
            PostMessage(MainScreenHandle, WM_LOADTRANSACTIONDATA, 0,0);

         Free;
      end;
end;

procedure TfmSupplierDownload.cbVATRegisteredPropertiesChange(
  Sender: TObject);
var
   registry : tregistry;
begin
   inherited;
   registry := Tregistry.Create;
   Registry.OpenKey('Software\Kingswood\Kingsacc\VATRegistered\'+RFarmGate.plocation[2]+'\', True);
   if cbVATRegistered.Checked then
      Registry.WriteString('VATRegistered','True')
   else
      Registry.WriteString('VATRegistered','False');
   registry.free;
end;

procedure TfmSupplierDownload.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
   if ( (Length(GetImportFile.FileName) > 0) and ((TTextRec(MyFile).Mode = fmClosed) or (not(EOF(MyFile)))) ) then
      CanClose := ( MessageDlg('You haven''t finished data import yet.'+#13#10+
                               'If you exit now and choose the same file later you will have to skip past the transactions already entered.'+#13#10+
                               'Are you sure you wish to exit?', mtConfirmation, [mbYes, mbNo], 0) = mrYes );
end;

procedure TfmSupplierDownload.actSave2Execute(Sender: TObject);
var
   WasAct,
   WasProg : Integer;
   continue:boolean;
begin
  inherited;


  HintStyleController.HideHint;
  if (ImportGridDBTableView.Controller.EditingController.Edit <> nil) then

     ImportGridDBTableView.Controller.EditingController.Edit.PostEditValue;


     if cash1.xyearend = true then begin
        if messagedlg('You are making changes to an archive set of accounts, are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrno then exit;
    end;

     Continue:=false;
     if ((cash1.xcashbook) and (Length(cmboSupplier.Text) = 0)) then begin
         Showmessage('No CoOp Selected - Please use Select CoOp to select the CoOp you are using');
         exit;
     end;
     If teComment.text = '' then
     if messagedlg ('Are you sure you want to leave the comment for this transaction blank?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes  then continue:=true;
    If Length(tecomment.text) > 0 then continue:=true;
    If Continue then begin

     // pHelp.visible:=false;

     if CheckImportTable then
        begin
             accsDataModule.importdefaults.edit;
             accsDataModule.Importdefaults['DefaultAccount'] := SelectedSupplier;//accsDataModule.purchaseLedger['Account'];
             accsDataModule.ImportDefaults.post;
           ACT := 1;
           PROG := PURCHTX;
           ImportTable.First;
           while NOT ImportTable.EOF do
              begin
                 MoveTxInfo;
                 SetVals;
                 WasAct := ACT;
                 WasProg := PROG;
                 ZStub[1] := 0;
                 ZStub[2] := 0;
                 WriteTransactions( 1, PlFile,WasAct, FALSE );
                 ImportTable.Next;
              end;
           SavedInfo := TRUE;   // To allow save of Month year combo when exiting
           UpdateTableWithComments; // TGM AB 05/02/16
           GetNextTx;   // Get the Next record
        end;
     end else tecomment.setfocus;
{     if finished then begin
        showmessage('File Import Completed');
        bSave.Enabled:=false;
     end;}
end;

procedure TfmSupplierDownload.CheckIfSaved;
begin
     if SavedInfo then  // try and save the Year Month Combo into the ImportDates table
        try
            FRefreshTransGrid := True;

            AccsDataModule.ImportDates.Open;
            AccsDataModule.ImportDates.Append;
            AccsDataModule.ImportDates.FieldByName('ImportFrom').AsString := AccsDataModule.ImportDefaultsCoOpName.AsString;
            AccsDataModule.ImportDates.FieldByName('ImportYear').AsInteger := ThisYear;
            AccsDataModule.ImportDates.FieldByName('ImportMonth').AsInteger := ThisMonth;
            AccsDataModule.ImportDates.Post;
        finally
            AccsDataModule.ImportDates.Close;
            SavedInfo := FALSE;
        end;
end;

procedure TfmSupplierDownload.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  CheckIfSaved;
end;

procedure TfmSupplierDownload.ImportTableAfterPost(DataSet: TDataSet);
begin
  inherited;
    try
       if ( NOT ImportTable.FieldByName('CompanyCode').IsNull ) then
          begin// Try to find a match
             if AccsDataModule.NomMatch.Locate('ExtFileCode',ImportTable.FieldByName('CompanyCode').AsString,[loCaseinsensitive]) then
                begin
                   AccsDataModule.NomMatch.Edit;
                   AccsDataModule.NomMatch.FieldByName('NlRecNo').AsInteger := ImportTable.FieldByName('NLacc').AsInteger;
                   AccsDataModule.NomMatch.Post;
                end
             else
                begin
                   AccsDataModule.NomMatch.Append;
                   AccsDataModule.NomMatch.FieldByName('NlRecNo').AsInteger := ImportTable.FieldByName('NLacc').AsInteger;
                   AccsDataModule.NomMatch.FieldByName('ExtFileCode').AsString := ImportTable.FieldByName('CompanyCode').AsString;
                   AccsDataModule.NomMatch.Post;
                end;
          end;
    except
        ShowMessage('Cannot set Default Nominal Account');
    end;
end;

procedure TfmSupplierDownload.ImportTableBeforeInsert(DataSet: TDataSet);
begin
  inherited;
     if DataSet.RecordCount >= 10 then
        raise ErrorMsg.CreateFmt('Cannot have more than 10 Items',[nil]);

end;

procedure TfmSupplierDownload.ImportTableInvDateValidate(Sender: TField);
var
   TempStr : ShortString;
   TestDate : Integer;
begin
   inherited;
     try
        TempStr := (Sender as TField).AsString;
        TestDate := KDateToInt ( TempStr );
        if ( TestDate < YearStart ) or
           ( TestDate > YearEnd ) then
           TfmSupplierDownloadDateWarning.ShowDateWarning;
     except
         // Do Nothing.
     end;
end;

procedure TfmSupplierDownload.FormShow(Sender: TObject);
var
   i : integer;
   registry : TRegistry;
begin
  inherited;
     registry:=Tregistry.Create;
     Registry.OpenKey('Software\Kingswood\Kingsacc\VATRegistered\'+RFarmGate.plocation[2]+'\', True);
     if Registry.ReadString('UpdatedOK') = 'True' then begin
        if Registry.ReadString('VATRegistered') = 'True' then cbVATRegistered.checked := true
        else cbVATRegistered.checked := false;
     end else begin
         if cash11.xuse_vat then Registry.WriteString('VATRegistered','False')
            else Registry.WriteString('VATRegistered','True');
         if cash11.xuse_vat then cbVATRegistered.checked := false
            else cbVATRegistered.checked := true;
         Registry.WriteString('UpdatedOK','True');
     end;
     registry.free;

     actSave.enabled:=true;
     AccsDataModule.ImportDates.open;
     If AccsDatamodule.ImportDates.recordcount=0 then begin
        actHelp.visible:=true;
     end;

end;

procedure TfmSupplierDownload.actHelpExecute(Sender: TObject);
var
   Hint : string;
begin
  inherited;
   AccsDataModule.HTMLHelp('coOpImport.htm');
  {
  HintStyleController.HideHint;
  Hint := 'Before you run the import the first time, you must click ''Select CoOp'''+#13#10+
          'and choose the correct CoOp from the list.  Please contact Kingswood if'+#13#10+
          'your CoOp supplier is not listed.'+#13#10+#13#10+
          'Click ''Read Import File'' to import the supplier statement.'+#13#10+
          'Normally the file will be on floppy disk, so the program initially'+#13#10+
          'searchs the floppy (a:). If the file has been emailed or is in some'+#13#10+
          'other location, when the program doesn''t find it on the floppy drive,'+#13#10+
          'you will be able to choose the file location.'+#13#10+#13#10+
          'Enter a comment if you wish a comment to appear on the'+#13#10+
          'supplier ledger card and then click ''Save'' to save the transaction.'+#13#10+
          'The next transaction will automatically be shown.'+#13#10+
          'Enter a comment for it and click ''Save'' to save the transaction.'+#13#10+
          'The supplier of the import file must already be in the program supplier list.'+#13#10+#13#10+
          'First time you import, you will have to choose the correct supplier from the'+#13#10+
          'drop down list of suppliers.  Subsequent imports will bring up the correct supplier'+#13#10+
          'For every VAT rate used by this supplier, there must be a matching VAT rate in the program'+#13#10+
          'VAT rate list.  If no match is found, the ''Set up Vat Rates'' window will be displayed'+#13#10+#13#10+
          'Program will automatically save the link between the Supplier item code and the program Nominal Code -'+#13#10+
          'The first time you import, you will have to choose the nominal code for each line.'+#13#10+
          'Subsequent imports will bring up the nominal last used for that supplier item code.'+#13#10+#13#10+
          'If you enter a batch of transactions from an import file and then exit without completing,'+#13#10+
          'you will have to use the ''Skip Past This Transaction'' button when you go to finish the'+#13#10+
          'import at a later stage. Otherwise the import will re enter the first batch of transactions'+#13#10+
          'a second time.';
   HintStyleController.ShowHint(40, 40, Caption + ' Help', Hint);
  }
end;

function TfmSupplierDownload.CheckImportTable: Boolean;
var
   TmpMark : TBookMark;
   i:integer;
begin
    try
       TmpMark := ImportTable.GetBookMark;
       ImportTable.DisableControls;
       RESULT := TRUE;
       ImportTable.First;
       if ImportTable.IsEmpty then
          begin
             ShowMessage('No Data to process');
             RESULT := FALSE;
          end
       else if Length(cmboSupplier.Text) = 0 then
          begin
             ShowMessage('You must choose a Supplier');
             RESULT := FALSE;
             cmboSupplier.DroppedDown := True;
          end
       else if ThisYear = 0 then
          begin
             ShowMessage('Year is NOT valid');
             RESULT := FALSE;
          end
       else if ThisMonth = 0 then
          begin
             ShowMessage('Month is NOT valid');
             RESULT := FALSE;
          end
       else
          with ImportTable do
             while NOT EOF do
                begin
                   if FieldByName('NLAcc').IsNull then
                      begin
                         ShowMessage('All Nominal Accounts must be filled');
                         Last;  // Kick it out
                         RESULT := FALSE;
                      end;
                   if FieldByName('InvDate').IsNull then
                      begin
                         ShowMessage('All Items need a Date');
                         Last;  // Kick it out
                         RESULT := FALSE;
                      end;
                   if FieldByName('Amount').IsNull then
                      begin
                         ShowMessage('All Items need an Amount');
                         Last;  // Kick it out
                         RESULT := FALSE;
                      end;
                   if FieldByName('Description').IsNull then
                      begin
                         ShowMessage('All Items need a Description');
                         Last;  // Kick it out
                         RESULT := FALSE;
                      end;
                   if FieldByName('TaxIDs').IsNull then
                      begin
                         ShowMessage('All Items need a VAT Rate');
                         Last;  // Kick it out
                         RESULT := FALSE;
                      end;
                   Next;
                end;
    finally
       ImportTable.GotoBookmark(TmpMark);
       ImportTable.FreeBookmark(TmpMark);
       ImportTable.EnableControls;
    end;
end;

procedure TfmSupplierDownload.GetNextTx;
begin
    ReadFile;
    teComment.text:='';
end;

procedure TfmSupplierDownload.SETVALS;
begin						     { begin SETVALS }
    If ( ACT=62 ) THEN
       ZTOTAMT[2]:=ZTOTAMT[1]
    Else
       ZTOTAMT[2]:=0-ZTOTAMT[1];
    If ( ACT=62 ) Then
       ZAMT[2][1]:=ZAMT[1][1]
    Else
        ZAMT[2][1]:=0-ZAMT[1][1];
    ZBANK  [2]:=ZBANK  [1];
    ZTXDATE[2]:=ZTXDATE[1];
    ZDUESTR[2]:=ZDUESTR[1];
    ZDUEINT[2]:=ZDUEINT[1];
    ZREF   [2]:=ZREF   [1];
    ZCOMM  [2]:=ZCOMM  [1];
    ZUSE[2][1]:=ZUSE[1][1];
end;						     { end SETVALS }

procedure TfmSupplierDownload.actSkipTransactionExecute(Sender: TObject);
begin
   inherited;
   HintStyleController.HideHint;
   if messagedlg('You should only skip past a transaction if it has already been entered.'+#13#10+#13#10+
                 'For example, if you exited this import before finishing, you will have to skip past those transactions already entered.'+#13#10+#13#10+
                 'Are you sure you wish to skip this transaction?',mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      GetNextTx;
end;

function TfmSupplierDownload.MoveTxInfo: Boolean;
Var
   TempInt    : Integer;
   Nominal,
   Amount,
   VAT,
   VATCode,
   Dummy,
   CorrectEntry : Boolean;
   GridPosOk    : Packed Array [1..10] Of Boolean;
   LineOK,
   LastLine,
   LineCount : Integer;
   TestStr   : ShortString;
   EntCode : string;
begin
     InitVals;

     MoveTxInfo := True;
     CorrectEntry := True;
     LastLine := -1;

     LineCount := 1;

     TestStr := ImportTable.FieldByName('InvDate').AsString;
     SlimAll ( TestStr );
     if Length ( TestStr ) > 0 then // next line added by TGM - shortens yyyy year to yy
        if length(TestStr) = 10 then TestStr := copy(TestStr,1,6) + copy(TestStr,9,2);
        if NOT DateValid ( TestStr, TDateFormat ) then
           CorrectEntry := FALSE;

     if CorrectEntry then
        begin
             // TGM AB cashbook stuff here!
             if cash1.xcashbook then begin
                zAccount[1] := SelectedSupplier;// accsDataModule.PurchaseLedger['Account'];
                zCustRec[1] := SelectedSupplier;//accsDataModule.PurchaseLedger['Account'];
             end
                else begin
             zCustRec[1] := SelectedSupplier; //accsDataModule.PurchaseLedger['Account'];//Integer(cbSupplier.KeyValue);
             zAccount[1] := SelectedSupplier; //accsDataModule.PurchaseLedger['Account'];//Integer(cbSupplier.KeyValue);
             end;

             if length(teComment.text) >0 then zComm[1] := teComment.text;//Copy(Comment.text,1,SizeOf(zComm[1]));
             if AccsDataModule.ImportDefaultsCoOpName.AsString = cDairygold then
                if ( NOT ImportTable.FieldByName('TransRef').IsNull ) then
                             zComm[1] := VarToStr(ImportTable['TransRef']);//Copy(ImportTable.FieldByName('TransRef').AsString,1,SizeOf(zComm[1]));
             zRef[1] := ImportTable['DocketNo'];Copy(ImportTable.FieldByName('DocketNo').AsString,1,SizeOf(zRef[1])); // remmed by TGM SizeOf(zComm[1]));

             //zComm[1] := Copy(ImportTable.FieldByName('TransRef').AsString,1,SizeOf(zComm[1])); // remmed by TGM SizeOf(zRef[1]));

             TestStr := ImportTable.FieldByName('InvDate').AsString;
             if length(TestStr) = 10 then TestStr := copy(TestStr,1,6) + copy(TestStr,9,2); // TGM AB Fix 4 digit year problem
             zTxDate[1] := KDateToInt ( TestStr );
             LineOk := 1;

             while ( NOT ImportTable.EOF ) And ( LineOK <= 10 ) do
                begin
                   zUse[1,LineOK] := True;
                   ZGen[1,LineOK] := ImportTable.FieldByName('NLAcc').AsInteger;

                   // TGM AB 05/02/16 BEGIN
                   //ZDesc[1,LineOK] := Copy(ImportTable.FieldByName('Description').AsString,1,SizeOf(zDesc[1,LineOK]));
                   if ( Preferences.ValueAsBoolean[cPref_AllowFreeTextForNominalDescriptionColumn] ) then
                      ZDesc[1,LineOK] := Copy(ImportTable.FieldByName('Description').AsString,1,SizeOf(zDesc[1,LineOK]))
                   else
                      begin
                         AccsDatamodule.NominalList.locate('Account',ImportTable.FieldByName('NLAcc').AsInteger,[]);
                         ZDesc[1,LineOK] := Copy(AccsDatamodule.NominalList.FieldByName('Name').AsString,1,SizeOf(zDesc[1,LineOK]));
                      end;
                   // TGM AB 05/02/16 END

                   // SP 29/07/2015
                   // For backwards compatibility we need to store the EntCode as
                   // part of the transaction so that the cashbook screen - EntCode column
                   // can be populated prior to editing.
                   EntCode := AccsDataModule.GetEnterpriseCodeByNominalCode(ImportTable.FieldByName('NLAcc').AsString);
                   if (EntCode <> '') then
                       zEnt[1,LineOK] := EntCode;

                   TestStr := FloatToStr(ImportTable.FieldByName('Quantity').AsFloat);
                   SlimAll ( TestStr );
                   Dummy := ChangeToLong ( TestStr );
                   StrLong ( TestStr, ZQty[1,LineOK] );

                   // Amount
                   TestStr := FloatToStr(ImportTable.FieldByName('Amount').AsFloat);
                   SlimAll ( TestStr );
                   Dummy := ChangeToLong ( TestStr );
                   StrLong ( TestStr, ZAmt[1,LineOK] );

                   // VAT Code
                   zTax[1,LineOK] := ImportTable.FieldByName('TaxIDS').AsString;

                   // VAT Amount
                   TestStr := FloatToStrF(ImportTable.FieldByName('TaxAmount').AsFloat,ffFixed,8,2);
                   SlimAll(TestStr);
                   Dummy := ChangeToLong ( TestStr );
                   StrLong(TestStr,zTaxAmt[1,LineOK]);

                   ImportTable.Next;
                   Inc ( LineOK );
                End;
             CheckEnd;
        End;
     MoveTxInfo := CorrectEntry;
end;

procedure TfmSupplierDownload.actImportExecute(Sender: TObject);
var
   FileOK,
   SetDefaultKeepGoing,
   KeepGoing : Boolean;
begin
   inherited;
   HintStyleController.HideHint;
   CheckIfSaved;      // check if the Month Date Combo needs to be saved.
   actSave.enabled:=true;

   KeepGoing := TRUE;
   Headerfound := FALSE;
   ReadRecord  := TRUE;
   ThisYear    := 0;
   ThisMonth   := 0;

   NewDairygoldFormat := false;

   SetDefaultKeepGoing := TRUE;
   FileOk    := FALSE;
   Finished:=false;
   // Clear the File Name
   GetImportFile.FileName := '';
   GetImportFile.InitialDir := GetSpecialFolder(CSIDL_DESKTOP);

   //   15/01/19 [V5.8 R4.1] /MK Bug Fix - If MyFile is open then close it before assigning it again - Monika reported. 
   if ( TextFileIsOpen(MyFile) ) then
      CloseFile(MyFile);

   if ( FileExists('C:\Kingsacc\TempCoOpFile.txt') ) then
      DeleteFile('C:\Kingsacc\TempCoOpFile.txt');

   while KeepGoing Or SetDefaultKeepGoing do
      begin
         if ( Length(GetImportFile.FileName) = 0 )  then
            GetImportFile.Execute;
         if ( Length(GetImportFile.FileName) = 0 )  then
            KeepGoing := (MessageDLG('Do you want to locate the file',mtInformation,[mbYes,mbNo],0) = mrYes)
         else
            try
               if ( Length(GetImportFile.FileName) = 0 ) then Exit;

               if FFileList <> nil then
                  begin
                     FreeAndNil(FFileList);
                     FFileList := TStringList.Create();
                  end;
               FFileList.LoadFromFile(GetImportFile.FileName);
               FFileList.SaveToFile('C:\Kingsacc\TempCoOpFile.txt');
               AssignFile(MyFile, 'C:\Kingsacc\TempCoOpFile.txt' );
               ReSet(MyFile);
               FileOK := TRUE;
               KeepGoing := FALSE;
            except
               KeepGoing := False;
               ShowMessage('Cannot open external File');
            end;
         if NOT AccsDataModule.ImportDefaults.Locate('UseAsDefault',TRUE,[] ) then
            begin
               //pSetDefault.Show;
               SetDefaultKeepGoing := NOT (AccsDataModule.ImportDefaults.Locate('UseAsDefault',TRUE,[] ));
               FileOK := SetDefaultKeepGoing;
            end
         else
            SetDefaultKeepGoing := FALSE;
      end;
   if ( FileOK ) then
      GetNextTx;
end;

procedure TfmSupplierDownload.actExitExecute(Sender: TObject);
begin
  inherited;
  HintStyleController.HideHint;
  Close;
end;

procedure TfmSupplierDownload.FormCreate(Sender: TObject);
begin
   inherited;
   FRefreshTransGrid := False;
   PREVENT_TRANSACTIONGRID_LOADING_ON_TRANSACTION_WRITE := True;

   cmboSupplier.RepositoryItem := AccsDataModule.erSuppliersLookup;

   //   07/11/11 [V4.1 R0.7] /MK Bug Fix - Building Of Nomlisting Table Should Be Done Before qNominalLedger.Active.
   AccsDataModule.GetExpenseNominalLedgerAccs;
   AccsDataModule.GetPurchaseLedgerAccs;

   if not AccsDatamodule.PurchaseLedger.Active then
      AccsDatamodule.PurchaseLedger.Active := True;
   if not AccsDataModule.ImportDefaults.Active then
      AccsDataModule.ImportDefaults.Active := True;
   if not AccsDataModule.qNominalLedger.Active then
      AccsDataModule.qNominalLedger.Active := True;

   // Build Nominal Ledger Listing
   try
      AccsDataModule.ImportDefaults.Open;
      // Try and Locate the Default
      if NOT AccsDataModule.ImportDefaults.Locate('UseAsDefault',TRUE,[]) then
         begin
            actSelectCoOp.Execute;
         end
      else // Set the Caption to Show the Curent COOP in use
         begin
            Caption := AccsDataModule.ImportDefaultsCoOpName.AsString + ' DownLoad';
            gbCoOp.Caption := cUserInfo + AccsDataModule.ImportDefaultsCoOpName.AsString;
         end;
   except
      ShowMessage('Cannot open Defaults Table');
   end;

   If AccsDataModule.PurchaseLedger.locate('Account',accsDataModule.Importdefaults['DefaultAccount'],[]) then begin
      cmboSupplier.EditValue := accsdatamodule.PurchaseLedger['Account']
   end;

   if cash1.xcashbook then
     cmboSupplier.Style.ButtonTransparency :=  ebtHideInactive
   else
     cmboSupplier.Style.ButtonTransparency :=  ebtNone;

   //   23/09/11 [V4.1 R0.3] /MK Additional Feature - Check If Cash.Vat Is Checked Then cbVatRegistered.Checked.
   if cash11.XUse_Vat = false then
      cbVATRegistered.Checked := True
   else
      cbVATRegistered.Checked := False;

   // Create the Table for a Down Load.
   CreateDownLoadTable;

   FFileList := TStringList.Create;

   AccsDataModule.ImageList16x16.GetBitmap(1, erButtonEdit.Properties.Buttons[0].Glyph);
   erButtonEdit.Properties.OnButtonClick := ButtonEditClick;
   erButtonEdit.Properties.OnChange := ButtonEditOnChange;
end;

procedure TfmSupplierDownload.FormMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;

   HintStyleController.HideHint;

end;

procedure TfmSupplierDownload.FormClick(Sender: TObject);
begin
  inherited;

  HintStyleController.HideHint;
end;

procedure TfmSupplierDownload.ImportGridDBTableViewCellClick(
  Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
  AShift: TShiftState; var AHandled: Boolean);
begin
  inherited;
 // HintStyleController.HideHint;
end;

procedure TfmSupplierDownload.gbCoOpEnter(Sender: TObject);
begin
  inherited;
HintStyleController.HideHint;
end;

procedure TfmSupplierDownload.ImportGridDBTableViewMouseEnter(
  Sender: TObject);
begin
  inherited;
//  HintStyleController.HideHint;
end;

procedure TfmSupplierDownload.gbCoOpClick(Sender: TObject);
begin
  inherited;
HintStyleController.HideHint;
end;

procedure TfmSupplierDownload.gbTotalsClick(Sender: TObject);
begin
  inherited;
  HintStyleController.HideHint;
end;

procedure TfmSupplierDownload.cmboSupplierEnter(Sender: TObject);
begin
  inherited;
  AccsDataModule.erSuppliersLookup.Properties.Grid.DataController.RefreshExternalData;
end;

function TfmSupplierDownload.GetSelectedSupplier: Integer;
begin
   Result := 0;
   if VarIsNull(cmboSupplier.EditValue) then
      begin
         MessageDlg('You must specify a supplier.',mtInformation,[mbOK],0);
         cmboSupplier.DroppedDown := True;
         Abort;
      end
   else
      Result := cmboSupplier.EditValue;
end;

procedure TfmSupplierDownload.FormDestroy(Sender: TObject);
begin
   inherited;
   if FFileList.Text <> '' then
      begin
         if ( FileExists('C:\Kingsacc\TempCoOpFile.txt') ) then
            DeleteFile('C:\Kingsacc\TempCoOpFile.txt');
         FreeAndNil(FFileList)
      end;
end;

procedure TfmSupplierDownload.actEnterPaymentExecute(Sender: TObject);
var
   SupplierID : Integer;
begin
   // cashbook payment routine
   SupplierID := 0;
   if ( not(AccsDataModule.ImportDefaults).Active ) then
      AccsDataModule.ImportDefaults.Active := True;
   if ( not(AccsDataModule.ImportDefaults.Locate('UseAsDefault',TRUE,[])) ) then
      MessageDlg('No CoOp Selected. Please Use Select CoOp under Read Disk to select your CoOp',mtError,[mbOK],0)
   else
      begin
         if ( not(VarIsNull(cmboSupplier.EditValue)) ) then
            SupplierID := cmboSupplier.EditValue;

         try
            Application.CreateForm(TCashBookForm, CashBookForm );
         except
         end;

         CashBookForm.SalesPurchDB := PLFile;
         CashBookForm.Save.Enabled := True;
         CashbookForm.CashbookImportPayment := True;
         GEditing := False;
         PROG := PURCHTX;
         ACT := 3;

         CashbookForm.CustSuppCode.text := vartostr(SupplierID);
         CashbookForm.CustSuppCode.enabled := False;
         CashbookForm.Listaccounts.visible := False;
         CashbookForm.SalesPurchaseGroup.visible := False;
         Cashbookform.caption := 'Entering CoOp Payments';
         CashBookForm.Showmodal;
         CashbookForm.CashbookImportPayment := False;
      end;
end;

procedure TfmSupplierDownload.UpdateTableWithComments; // TGM AB 12/02/16
var
   i : integer;
   Tempstr : string;
begin
   // This procedure steps through the last saved import and updates the comment fields for each individual line & marks as co-op import transaction
   // The variable TxWrite.TxNo holds the Transaction Number of the last saved Tx
   if ( Accsdatamodule.TransactionsDB.Locate('TxNo',TxWrite.TxNo,[]) ) then
      try
         Accsdatamodule.TransactionsDB.Edit;
         Accsdatamodule.TransactionsDB.FieldByName('CoOpImport').AsBoolean := True;
         try
            Accsdatamodule.TransactionsDB.FieldByName('CoOpComment').AsString := teComment.text;
         except

         end;
         Accsdatamodule.TransactionsDB.Post;

         ImportTable.First;

         for i:= 1 to ImportTable.RecordCount do
            begin
               Tempstr := '';
               try
                  Tempstr := ImportTable['Description'];
               except

               end;

               Accsdatamodule.TransactionsDB.Next;

               Accsdatamodule.TransactionsDB.Edit;
               Accsdatamodule.TransactionsDB.FieldByName('CoOpImport').AsBoolean := True;
               Accsdatamodule.TransactionsDB.FieldByName('CoOpComment').AsString := TempStr;
               Accsdatamodule.TransactionsDB.Post;

               Accsdatamodule.TransactionsDB.Next;

               Accsdatamodule.TransactionsDB.Edit;
               Accsdatamodule.TransactionsDB.FieldByName('CoOpImport').AsBoolean := True;
               Accsdatamodule.TransactionsDB.FieldByName('CoOpComment').AsString := TempStr;
               Accsdatamodule.TransactionsDB.Post;

               ImportTable.Next;
            end;
      except
         on e : Exception do
            ShowMessage(e.Message);
      end;
end;

procedure TfmSupplierDownload.ButtonEditClick(Sender: TObject; AButtonIndex: Integer);
begin
   if ( FocusedColumnString = ImportGridDBTableViewNomName.DataBinding.FieldName ) then
      PostMessage(Handle, WM_INVOKESEARCHITEM, 1, 0)
   else if ( FocusedColumnString = ImportGridDBTableViewQuantity.DataBinding.FieldName ) then
      PostMessage(Handle, WM_INVOKESEARCHITEM, 2, 0);
end;

procedure TfmSupplierDownload.ButtonEditOnChange(Sender: TObject);
var
   EditingText : string;
begin
   if ( FocusedColumnString = ImportGridDBTableViewNomName.DataBinding.FieldName ) then
      begin
         EditingText := (Sender as TcxButtonEdit).Text;
         if (not(IsEmpty(EditingText)) and (not Numeric(EditingText))) then
            begin
               FindAndPostNominal(EditingText);
               (Sender as TcxButtonEdit).Text := '';
            end;
      end
end;

function TfmSupplierDownload.FocusedColumnString: string;
begin
   try
      Result := TcxGridDBColumn(ImportGridDBTableView.Controller.FocusedColumn).DataBinding.FieldName;
   except
      Result := '';
   end;
end;

procedure TfmSupplierDownload.FindAndPostNominal(const ASearchTextValue: string);
var
   IncomeStart : Integer;
begin
   NewListBox.InitialSearchFieldText := ASearchTextValue;
   NewListBox.ListInfo.Ent := '';
   if (Preferences.ValueAsBoolean[cPref_AutoEntSelect]) then
      IncomeStart := AccsDataModule.GetEnterpriseIncomeStart()
   else
      IncomeStart := cNon_Enterprise_Income_Start;

   NewListBox.ListIt ( nil, AllNoms, 'N', IntToStr(IncomeStart) );

   if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
      StoreNominalSelection(StrToInt(NewListBox.ListInfo.ReturnValue))
end;

function TfmSupplierDownload.IsIncomeOrExpense : TTransactionType;
begin
   if ( AccsDatamodule.BankCSVTempTableDB.FieldByName('IncomeOrExpense').AsString = cExpense ) then
      Result := ttExpense
   else
      Result := ttIncome;
end;

procedure TfmSupplierDownload.StoreNominalSelection(const ANomCode: Integer);
var
   NominalAccount : TNominalAccount;
begin
   with ImportTable do
      try
         Edit;
         try
            FieldByName('NomName').Clear;
            FieldByName('NlAcc').Clear;
            if ( ANomCode > 0 ) then
               begin
                  NominalAccount := AccsDatamodule.Accounts.GetNominalAccount(ANomCode);
                  if ( NominalAccount <> nil ) then
                     begin
                        FieldByName('NomName').AsString := NominalAccount.Name;
                        FieldByName('NlAcc').AsInteger := ANomCode;
                     end;
               end;
            Post;
         except
            Cancel;
         end;
      finally
      end;
end;

procedure TfmSupplierDownload.InvokeSearchItem(var Message: TMessage);
begin
   if Message.Msg = WM_INVOKESEARCHITEM then
      begin
         if (Message.WParam = 1) then
            FindAndPostNominal('')
         else  if (Message.WParam = 6) then
            InvokeQuantityScreen();
      end;
end;

procedure TfmSupplierDownload.InvokeQuantityScreen;
var
   Point : TPoint;
begin
   GetCursorPos(Point);
   Point := ScreenToClient(ClientToScreen(Point));
   // try to align to left,bottom of cell
   Point.x := Point.x - 65;
   Point.y := Point.y + ImportGridDBTableView.OptionsView.DataRowHeight;
   EditCBEQuantities(Point);
end;

procedure TfmSupplierDownload.EditCBEQuantities(APoint: TPoint);
var
   Qty2, Qty3 : Variant;
begin
   // Post any edits to the quantity before opening the multiple quantity window
   {
   ImportGridDBTableView.DataController.PostEditingData;

   if AccsDatamodule.MultipleQuantityHandler(AccsDatamodule.BankCSVTempTableDB.FieldByName('Enterprise').AsString,
                                             AccsDatamodule.BankCSVTempTableDB.FieldByName('Quantity2').AsFloat,
                                             AccsDatamodule.BankCSVTempTableDB.FieldByName('Quantity3').AsFloat,
                                             Qty2, Qty3, APoint) then
      begin
         AccsDatamodule.BankCSVTempTableDB.Edit;
         if not VarIsNullOrEmpty(Qty2) then
            AccsDatamodule.BankCSVTempTableDB.FieldByName('Quantity2').Value := Qty2;

         if not VarIsNullOrEmpty(Qty3) then
            AccsDatamodule.BankCSVTempTableDB.FieldByName('Quantity3').Value := Qty3;
         AccsDatamodule.BankCSVTempTableDB.Post;
      end;
   }
end;

end.
