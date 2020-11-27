unit uSuppDownload;

interface

uses
  Windows, Messages, SysUtils, Db, DBTables, StdCtrls, Buttons, Controls,
  Classes, ExtCtrls, Forms, Dialogs, Grids, DBGrids, DBCtrls, Adgrad, params, registry;

type
  TfSuppDownload = class(TForm)
    Panel2: TPanel;
    Label2: TLabel;
    ThisDate: TEdit;
    ImportTable: TTable;
    dsImportTable: TDataSource;
    dbgImport: TDBGrid;
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
    ImportTableNomName: TStringField;
    Label3: TLabel;
    eStatementFor: TEdit;
    VatCodes: TTable;
    dsVatCodes: TDataSource;
    cbSupplierLookup: TDBLookupComboBox;
    Label4: TLabel;
    GetImportFile: TOpenDialog;
    pSetDefault: TPanel;
    dbgSetDefault: TDBGrid;
    Label5: TLabel;
    qLocal: TQuery;
    bCloseChooseCoOp: TBitBtn;
    ImportTableTaxIDS: TStringField;
    ImportTableTaxRate: TIntegerField;
    ImportTableTaxAmount: TFloatField;
    ImportTableDocketNo: TStringField;
    Panel3: TPanel;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    bOptions: TBitBtn;
    bSave: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn3: TBitBtn;
    pWarning: TPanel;
    bCloseWarning: TBitBtn;
    lWarning: TLabel;
    Comment: TEdit;
    Label1: TLabel;
    cbSupplier: TEdit;
    lwhichCoOp: TLabel;
    pHelp: TPanel;
    Label8: TLabel;
    bCloseHelp: TBitBtn;
    ReferenceLabel: TLabel;
    Reference: TEdit;
    DateLabel: TLabel;
    TxDate: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    Label13: TLabel;
    AdrockGradientFill1: TAdrockGradientFill;
    Label9: TLabel;
    Label14: TLabel;
    TotalsPanel: TPanel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    TotalLessVAT: TEdit;
    TotalVAT: TEdit;
    TotalAmt: TEdit;
    VATRegisteredCB: TCheckBox;
    Label18: TLabel;
    procedure ExitButtonClick(Sender: TObject);
    procedure bRecordClick(Sender: TObject);
    procedure bSaveClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ImportTableNLAccValidate(Sender: TField);
    procedure bOptionsClick(Sender: TObject);
    procedure dbgSetDefaultDblClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure bCloseChooseCoOpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ImportTableAfterPost(DataSet: TDataSet);
    procedure ImportTableBeforeInsert(DataSet: TDataSet);
    procedure ImportTableInvDateValidate(Sender: TField);
    procedure cbSupplierLookupClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bCloseHelpClick(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure bCloseWarningClick(Sender: TObject);
    procedure VATRegisteredCBClick(Sender: TObject);
    procedure UpdateTableWithComments;  // TGM AB 05/02/16
  private
    { Private declarations }
    YearStart,
    YearEnd,
    ThisYear,
    ThisMonth   : Integer;
    SavedInfo,                  // TRUE if you saved 1 or more TX's
    ReadRecord,
    Headerfound : Boolean;
    MyFile      : TextFile;
    DiskLine    : String;
    Finished: Boolean; // set when eof(MyFile)
    NewDairygoldFormat : boolean; // saves not Dairygold Format
    procedure CreateDownLoadTable;
    procedure ReadFileFromDisk;
    function  IsNegOrPos(TestStr : ShortString) : String;
    function  MoveTxInfo : Boolean;
    procedure SETVALS;
    function  CheckImportTable : Boolean;
    procedure GetNextTx;
    function  FindVAT (ThisRate : Double ) : Boolean;
    procedure CheckImportDates;   // Check the Date month combo to warn user
    procedure CheckIfSaved;
  public
    { Public declarations }

  end;

procedure ShowTheForm;


implementation
uses Clears,
     TxWrite,
     Calcs,
     Vars,
     types,
     DBGen,
     AccsData, newListing, Vat, FullAudit, DBCore, Util, Cashbook;

const
   cUserInfo = 'Statement from ';

var
   fSuppDownload: TfSuppDownload;
   Helponly : boolean;
   OverWriteNominalDesc : Boolean;  // TGM AB 05/02/16
{$R *.DFM}

procedure ShowTheForm;
var
   PCount : Integer;
begin

   // TGM AB 05/02/16

   // This variable controls the overwriting of the nomnial description with the description within the Co-Op file

   OverWriteNominalDesc := true;

   // end 05/02/16

   try
      try
         if fSuppDownLoad = nil then
            Application.CreateForm(TfSuppDownLoad,fSuppDownLoad);


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

         try
            AccsDataModule.ImportDefaults.Open;
            // Try and Locate the Default
            if NOT AccsDataModule.ImportDefaults.Locate('UseAsDefault',TRUE,[]) then
               fSuppDownLoad.pSetDefault.Show
            else // Set the Caption to Show the Curent COOP in use
               begin
                  fSuppDownLoad.Caption := AccsDataModule.ImportDefaultsCoOpName.AsString + ' DownLoad';
                  fSuppDownLoad.lwhichCoOp.Caption := cUserInfo + AccsDataModule.ImportDefaultsCoOpName.AsString;
               end;
         except
            ShowMessage('Cannot open Defaults Table');
         end;

         with fSuppDownLoad do
            if ( AccsDataModule.NomMatch.Active ) and
               ( AccsDataModule.ImportDefaults.Active ) then
               begin
                  pSetDefault.Hide;
                  pWarning.Hide;
                  // Get the finalial year start and end
                  GetFinDateRange(YearStart,YearEnd);
                  SavedInfo := FALSE;
                  ShowModal;
               end;
      except
         ShowMessage('Cannot Create Form - Close and reBoot');
      end;
   finally
      for PCount := 1 to MaxTx do
         Dispose ( TxHold[PCount] );
      for PCount := 1 to MaxNom do
         Dispose ( NomHold[PCount] );
      try
         with fSuppDownLoad do
            CloseFile(MyFile);
      except

      end;
      AccsDataModule.NomMatch.Close;
      if AccsDataModule.PurchaseLedger.Locate('Account',AccsDataModule.ImportDefaults['DefaultAccount'],[]) then begin
         //fSuppDownload.cbSupplier.value:= IntToStr(AccsDataModule.PurchaseLedger['Account']);
         fSuppDownload.cbSupplierLookup.keyValue:=AccsDataModule.PurchaseLedger['Account'];//.Text:= AccsDataModule.PurchaseLedger['Name'];
      end;
      AccsDataModule.ImportDefaults.Close;
   end;
end;

procedure TfSuppDownload.CreateDownLoadTable;
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

procedure TfSuppDownload.ExitButtonClick(Sender: TObject);

begin
     pHelp.visible:=false;
     if ((GetImportFile.FileName <> '') and (not EOF(Myfile))) then begin
        if MessageDlg('You haven''t finished data import yet.  If you exit now, you wil have to skip past the transactions already entered if you choose to import the same file later.  Are you sure you wish to exit?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
        then begin
             Close;
             cbsupplier.text := '';
        end;
     end else begin
              close;
              cbsupplier.text := '';
         end;
end;

procedure TfSuppDownload.bRecordClick(Sender: TObject);
var FileOK,
    SetDefaultKeepGoing,
    KeepGoing            : Boolean;
begin
     CheckIfSaved;      // check if the Month Date Combo needs to be saved.
     bSave.enabled:=true;
     pWarning.Hide;
     pHelp.visible:=false;

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
     while KeepGoing Or SetDefaultKeepGoing do
        begin
           if GetImportFile.FileName = '' then
              GetImportFile.Execute;
           if GetImportFile.FileName = '' then
              KeepGoing := (MessageDLG('Do you want to locate the file',mtInformation,[mbYes,mbNo],0) = mrYes)
           else
              try
                 AssignFile(MyFile, GetImportFile.FileName );
                 ReSet(MyFile);
                 FileOK := TRUE;
                 KeepGoing := FALSE;
              except
                 ShowMessage('Cannot open external File');
              end;
           if NOT AccsDataModule.ImportDefaults.Locate('UseAsDefault',TRUE,[] ) then
              begin
                 pSetDefault.Show;
                 SetDefaultKeepGoing := NOT (AccsDataModule.ImportDefaults.Locate('UseAsDefault',TRUE,[] ));
                 FileOK := SetDefaultKeepGoing;
              end
           else
              SetDefaultKeepGoing := FALSE;
        end;

     if FileOK then
        GetNextTx;
end;

procedure TfSuppDownload.GetNextTx;
begin
    ReadFileFromDisk;
    Comment.text:='';
end;

function TfSuppDownload.CheckImportTable : Boolean;
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
       else if Length(cbSupplier.Text) = 0 then
          begin
             ShowMessage('You must choose a Supplier');
             RESULT := FALSE;
             cbSupplierLookup.DropDown;
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

procedure TfSuppDownload.bSaveClick(Sender: TObject);
var
   WasAct,
   WasProg : Integer;
   continue:boolean;
begin
    if cash1.xyearend = true then begin
        if messagedlg('You are making changes to an archive set of accounts, are you sure you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrno then exit;
    end;

     Continue:=false;
     if ((cash1.xcashbook) and (Length(cbSupplier.Text) = 0)) then begin
         Showmessage('No CoOp Selected - Please use Select CoOp to select the CoOp you are using');
         exit;
     end;
     If Comment.text = '' then
     if messagedlg ('Are you sure you want to leave the comment for this transaction blank?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes  then continue:=true;
    If Length(comment.text) > 0 then continue:=true;
    If Continue then begin

     pHelp.visible:=false;
     if CheckImportTable then
        begin
             accsDataModule.importdefaults.edit;
             accsDataModule.Importdefaults['DefaultAccount'] := accsDataModule.purchaseLedger['Account'];
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
           UpdateTableWithComments;  // TGM AB 05/02/16
           GetNextTx;   // Get the Next record
        end;
     end else comment.setfocus;
{     if finished then begin
        showmessage('File Import Completed');
        bSave.Enabled:=false;
     end;}
end;

procedure TfSuppDownload.ReadFileFromDisk;

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
              begin
                 ReadLn(MyFile,DiskLine);
                 TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsRecTypeStart.AsInteger, AccsDataModule.ImportDefaultsRecTypeLen.AsInteger);
                 If TempStr = HeaderStr then
                    begin
                       if pos('1]Dairygold         ',DiskLine) > 0 then NewDairyGoldFormat := True;  // Old File has 1]Dairygold Co-Operative

                       if AccsDataModule.ImportDefaults['HeaderDateFormat'] = 'YYYYMM' then
                          begin
                             TempStr := Copy(DiskLine,AccsDataModule.ImportDefaultsHeaderDateStart.AsInteger,6);
                             ThisMonth := StrToInt(Copy (TempStr,5,2));
                             ThisYear  := StrToInt(Copy (TempStr,1,4));
                             ThisDate.Text := Copy (TempStr,5,2) + '/';
                             ThisDate.Text := ThisDate.Text + Copy (TempStr,1,4);
                             TempStr := Copy(DiskLine,AccsDataModule.ImportDefaultsCustomerNameStart.asInteger,AccsDataModule.ImportDefaultsCustomerNameLen.asInteger);
                             eStatementFor.Text := TempStr;
                             Headerfound := TRUE;
                          end;

                       if AccsDataModule.ImportDefaults['HeaderDateFormat'] = 'MMYYYY' then
                          begin
                             TempStr := Copy(DiskLine,AccsDataModule.ImportDefaultsHeaderDateStart.asInteger,6);
                             ThisMonth := StrToInt(Copy (TempStr,1,2));
                             ThisYear  := StrToInt(Copy (TempStr,3,4));
                             ThisDate.Text := Copy (TempStr,1,2) + '/';
                             ThisDate.Text := ThisDate.Text + Copy (TempStr,3,4);
                             TempStr := Copy(DiskLine,AccsDataModule.ImportDefaultsCustomerNameStart.asInteger,AccsDataModule.ImportDefaultsCustomerNameLen.asInteger);
                             eStatementFor.Text := TempStr;
                             Headerfound := TRUE;
                          end;
                       if AccsDataModule.ImportDefaults['HeaderDateFormat'] = 'DDMMMYYYY' then
                          begin
                             TempStr := Copy(DiskLine,AccsDataModule.ImportDefaultsHeaderDateStart.asInteger,11);
                             DDMMMYYYYtoStr(TempStr);
                             ThisMonth := StrToInt(Copy (TempStr,4,2));
                             ThisYear  := StrToInt(Copy (TempStr,7,4));

                             ThisDate.Text := Copy (TempStr,4,2) + '/' + Copy (TempStr,7,4);
                             TempStr := Copy(DiskLine,AccsDataModule.ImportDefaultsCustomerNameStart.asInteger,AccsDataModule.ImportDefaultsCustomerNameLen.asInteger);
                             //TempStr := Copy(DiskLine,147,50);
                             eStatementFor.Text := TempStr;
                             Headerfound := TRUE;
                          end;

                       // test to See if the Year month Combo exists for this Import
                       CheckImportDates;
                    end;
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
                                ImportTable.FieldByName('InvDate').AsDateTime := StrToDateTime(DateStr);
                             except
                                ImportTable.FieldByName('InvDate').Clear;
                             end;
                             txDate.Text:=DateStr;
                             // Insert the Docket Number
                             ImportTableDocketNo.AsString := LastDocket;
                             Reference.Text:=LastDocket;

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
                                if ((Cash11.Xuse_vat) or (not VATRegisteredCb.checked)) then
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
                                            if accsDataModule.ImportDefaults['VATInclusive'] then begin
                                               AmountIncVAT := round(ImportTable['Amount']*100)/100;
                                               ImportTable['Amount'] := round((AmountIncVAT / (1+ VatCodes['TaxRate'] / 100)*100))/100;
                                               ImportTable['TaxAmount'] := AmountIncVAT - ImportTable['Amount'];
                                            end else
                                                ImportTable.FieldByName('TaxAmount').AsFloat := (ImportTable.FieldByName('Amount').Value / (1+ VatCodes.FieldByName('TaxRate').AsFloat)) / 100;
                                            TotalVATAmount := TotalVATAmount + ImportTable['TaxAmount'];
                                            TotalVat.text:=VarToStr(TotalVATAmount);

                                         end;
                                   end;
                             except
                                VATRateOK := FALSE;
                                NoErrors := FALSE;
                             end;
                             TotalLessVATAmount := TotalLessVATAmount + ImportTable['Amount'];
                             TotalLessVAT.Text := varToStr(TotalLessVATAmount);
                             TotalAmount:=TotalVATAmount + TotalLessVATAmount;
                             TotalAmt.text := varToStr(TotalAmount);
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
                                   ImportTable.FieldByName('NLacc').AsInteger := AccsDataModule.NomMatch.FieldByName('NlRecNo').AsInteger;

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
     ImportTable.Close;
     ImportTable.EmptyTable;
     ReportErrors;
     MessageDLG('Error(s) on Statement Disk',mtWarning,[mbOK],0);
  end; // of try
end;

procedure TFSuppDownLoad.CheckImportDates;
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

function TFSuppDownLoad.IsNegOrPos(TestStr : ShortString) : String;
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

procedure TfSuppDownload.FormActivate(Sender: TObject);
begin
     // Build Nominal Ledger Listing
     AccsDataModule.GetExpenseNominalLedgerAccs;
     AccsDataModule.GetPurchaseLedgerAccs;
     AccsDatamodule.PurchaseLedger.open;
     AccsDataModule.ImportDefaults.Open;
     If AccsDataModule.PurchaseLedger.locate('Account',accsDataModule.Importdefaults['DefaultAccount'],[]) then begin
        cbSupplier.text:=accsdatamodule.purchaseLedger['Name'];
     end;

     if cash1.xcashbook then begin
              cbsupplierlookup.Visible := false;
     end
        else begin
             cbsupplierlookup.Visible := true;
        end;

    // Create the Table for a Down Load.
    CreateDownLoadTable;
end;

procedure TfSuppDownload.ImportTableNLAccValidate(Sender: TField);
begin
    if NOT AccsDataModule.qNominalLedger.Locate('Account',(Sender as TField).AsInteger,[] ) then
       raise ErrorMsg.CreateFmt('Account must exist on Listing',[nil]);
end;

function TfSuppDownload.FindVAT (ThisRate : Double ) : Boolean;
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

Function TfSuppDownload.MoveTxInfo : Boolean;
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
                zAccount[1] := accsDataModule.PurchaseLedger['Account'];
                zCustRec[1] := accsDataModule.PurchaseLedger['Account'];
             end
                else begin
             zCustRec[1] := accsDataModule.PurchaseLedger['Account'];//Integer(cbSupplier.KeyValue);
             zAccount[1] := accsDataModule.PurchaseLedger['Account'];//Integer(cbSupplier.KeyValue);
             end;

             if length(Comment.text) >0 then zComm[1] := Comment.text;//Copy(Comment.text,1,SizeOf(zComm[1]));
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
                   if OverWriteNominalDesc then ZDesc[1,LineOK] := Copy(ImportTable.FieldByName('Description').AsString,1,SizeOf(zDesc[1,LineOK]))      // TGM AB 05/02/16
                        else begin                                                                                                                      // TGM AB 05/02/16
                             AccsDatamodule.NominalList.locate('Account',ImportTable.FieldByName('NLAcc').AsInteger,[]);                                // TGM AB 05/02/16
                             ZDesc[1,LineOK] := Copy(AccsDatamodule.NominalList.FieldByName('Name').AsString,1,SizeOf(zDesc[1,LineOK]))                 // TGM AB 05/02/16
                        end;                                                                                                                            // TGM AB 05/02/16

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

Procedure TfSuppDownload.SETVALS;
Begin						     { begin SETVALS }
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
End;						     { end SETVALS }

procedure TfSuppDownload.bOptionsClick(Sender: TObject);
begin
     if messagedlg('You should only skip past a transaction if it has already been entered, for example if you exited this import before finishing, you will have to skip past those transactions already entered.  Are you sure you wish to skip this transaction?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then

         GetNextTx;
end;

procedure TfSuppDownload.dbgSetDefaultDblClick(Sender: TObject);
begin
    try
       with qLocal do
          begin
             SQL.Clear;
             SQL.Add('UPDATE ' + AccsDataModule.ImportDefaults.TableName);
             SQL.Add('SET UseAsDefault = FALSE');
             ExecSQL;
             SQL.Clear;
             SQL.Add('UPDATE ' + AccsDataModule.ImportDefaults.TableName);
             SQL.Add('SET UseAsDefault = TRUE');
             SQL.Add('WHERE ID = ' + AccsDataModule.ImportDefaultsID.AsString);
             ExecSQL;
          end;
       dbgSetDefault.DataSource.DataSet.Refresh;
       Caption := AccsDataModule.ImportDefaultsCoOpName.AsString + ' DownLoad';
       lwhichCoOp.Caption := cUserInfo + AccsDataModule.ImportDefaultsCoOpName.AsString;
    except
        ShowMessage('Cannot Set Default');
    end;
     AccsDatamodule.PurchaseLedger.open;
     AccsDataModule.ImportDefaults.Open;
     If AccsDataModule.PurchaseLedger.locate('Account',accsDataModule.Importdefaults['DefaultAccount'],[]) then begin
        cbSupplier.text:=accsdatamodule.purchaseLedger['Name'];
     end else cbSupplier.text:='';

end;

procedure TfSuppDownload.BitBtn3Click(Sender: TObject);
begin
    pHelp.visible:=false;
    pSetDefault.Show;
end;

procedure TfSuppDownload.bCloseChooseCoOpClick(Sender: TObject);
var
      RecNo: Integer;
      Located : Boolean;
      NewRec : Integer;
      AccRange    : TAccRange;
      AccountNo : integer;
begin
     if cash1.xcashbook then begin
         AccountNo := 0;
         AccRange[1] := 1;
         AccRange[2] := -1;
         // sets account range to all

         Located := False;

         setdb(plfile);

         FOR RecNo:= 1 TO db1.DBRECTOT DO
             BEGIN
             READREC(plFile,RECNO);
	     IF RECACTIVE(plFile) then begin
               Getitem(plfile,1);
               if currstr = (AccsDataModule.ImportDefaultsCoOpName.AsString + ' Purchase A/C') then begin
                                                                                located := True;
                                                                                AccountNo := RecNo;
                                                                                end;
             end;
         end;

         if not located then begin
              NewRec := GetNextFreeAccount (plFile,AccRange);
              BlankRec (plFile, 'A' );
              AddRecord (plFile, NewRec, False );
              PutStr (plFile, (AccsDataModule.ImportDefaultsCoOpName.AsString + ' Purchase A/C'), 1 );
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
         cbsupplier.text := GetAccountName ( PlFile,AccountNo,1);
         cbsupplierlookup.visible := False;

     end;

     Comment.setfocus;
     pSetDefault.Hide;
end;

procedure TfSuppDownload.CheckIfSaved;
begin
     if SavedInfo then  // try and save the Year Month Combo into the ImportDates table
        try
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

procedure TfSuppDownload.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     CheckIfSaved;
end;

procedure TfSuppDownload.ImportTableAfterPost(DataSet: TDataSet);
begin
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

procedure TfSuppDownload.ImportTableBeforeInsert(DataSet: TDataSet);
begin
     if DataSet.RecordCount >= 10 then
        raise ErrorMsg.CreateFmt('Cannot have more than 10 Items',[nil]);
end;

procedure TfSuppDownload.ImportTableInvDateValidate(Sender: TField);
var
   TempStr : ShortString;
   TestDate : Integer;
begin
     try
        TempStr := (Sender as TField).AsString;
        TestDate := KDateToInt ( TempStr );
        if ( TestDate < YearStart ) or
           ( TestDate > YearEnd ) then
           pWarning.Show;
     except
         // Do Nothing.
     end;
end;

procedure TfSuppDownload.cbSupplierLookupClick(Sender: TObject);
begin
     cbSupplier.text:=cbSupplierLookup.text;
end;

procedure TfSuppDownload.FormShow(Sender: TObject);
var
   i : integer;
   registry : TRegistry;
begin
     registry:=Tregistry.Create;
     Registry.OpenKey('Software\Kingswood\Kingsacc\VATRegistered\'+RFarmGate.plocation[2]+'\', True);
     if Registry.ReadString('UpdatedOK') = 'True' then begin
        if Registry.ReadString('VATRegistered') = 'True' then VATRegisteredcb.checked := true
        else VATRegisteredcb.checked := false;
     end else begin
         if cash11.xuse_vat then Registry.WriteString('VATRegistered','False')
            else Registry.WriteString('VATRegistered','True');
         if cash11.xuse_vat then VATRegisteredcb.checked := false
            else VATRegisteredcb.checked := true;
         Registry.WriteString('UpdatedOK','True');
     end;
     registry.free;
     
     bSave.enabled:=true;
     AccsDataModule.ImportDates.open;
     If AccsDatamodule.ImportDates.recordcount=0 then begin
        pHelp.visible:=true;
     end;
end;

procedure TfSuppDownload.bCloseHelpClick(Sender: TObject);
begin
     pHelp.visible:=false;
     if helponly then helponly := False
        else pSetDefault.Show;
end;

procedure TfSuppDownload.BitBtn6Click(Sender: TObject);
begin
     Helponly := True;
     pHelp.visible:=true;
end;

procedure TfSuppDownload.bCloseWarningClick(Sender: TObject);
begin
     Comment.setfocus;
     pWarning.hide;
end;


procedure TfSuppDownload.VATRegisteredCBClick(Sender: TObject);
var
   registry : tregistry;
begin
     registry:= Tregistry.Create;
     Registry.OpenKey('Software\Kingswood\Kingsacc\VATRegistered\'+RFarmGate.plocation[2]+'\', True);
     if VATRegisteredcb.checked = true then Registry.WriteString('VATRegistered','True')
         else Registry.WriteString('VATRegistered','False');
     registry.free;

end;

procedure TfSuppDownload.UpdateTableWithComments;  // TGM AB 12/02/16
var
        i : integer;
        Tempstr : string;
begin

    // This procedure steps through the last saved import and updates the comment fields for each individual line & marks as co-op import transaction

    // The variable TxWrite.TxNo holds the Transaction Number of the last saved Tx

    Accsdatamodule.TransactionsDB.Locate('TxNo',TxWrite.TxNo,[]);
    Accsdatamodule.TransactionsDB.edit;
    Accsdatamodule.TransactionsDB['CoOpImport'] := True;
    try Accsdatamodule.TransactionsDB['CoOpComment'] := comment.text;
    except
    end;
    Accsdatamodule.TransactionsDB.post;

    ImportTable.first;

    for i:= 1 to (ImportTable.recordcount) do begin

        Tempstr := '';
        try Tempstr := ImportTable['Description'];
        except
        end;

        Accsdatamodule.TransactionsDB.next;
        Accsdatamodule.TransactionsDB.edit;
        Accsdatamodule.TransactionsDB['CoOpImport'] := True;
        Accsdatamodule.TransactionsDB['CoOpComment'] := TempStr;
        Accsdatamodule.TransactionsDB.post;

        Accsdatamodule.TransactionsDB.next;
        Accsdatamodule.TransactionsDB.edit;
        Accsdatamodule.TransactionsDB['CoOpImport'] := True;
        Accsdatamodule.TransactionsDB['CoOpComment'] := TempStr;
        Accsdatamodule.TransactionsDB.post;

        ImportTable.next;
    end;
end;

end.
