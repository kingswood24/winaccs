unit uSuppDownload;

interface

uses
  Windows, Messages, SysUtils, Db, DBTables, StdCtrls, Buttons, Controls,
  Classes, ExtCtrls, Forms, Dialogs, Grids, DBGrids, DBCtrls;

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
    cbSupplier: TDBLookupComboBox;
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
    lwhichCoOp: TLabel;
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
     AccsData;

const
   cUserInfo = 'Statement from ';

var
   fSuppDownload: TfSuppDownload;

{$R *.DFM}

procedure ShowTheForm;
var
   PCount : Integer;
begin
   try
      try
         if fSuppDownLoad = nil then
            Application.CreateForm(TfSuppDownLoad,fSuppDownLoad);


         for PCount := 1 To MaxTx Do
            New ( TxHold[PCount] );
         for PCount := 1 To MaxNom Do
            New ( NomHold[PCount] );
         { Initialise the Pointer Variable }
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
     Close;
end;

procedure TfSuppDownload.bRecordClick(Sender: TObject);
var FileOK,
    SetDefaultKeepGoing,
    KeepGoing            : Boolean;
begin
     CheckIfSaved;      // check if the Month Date Combo needs to be saved.
     pWarning.Hide;

     KeepGoing := TRUE;
     Headerfound := FALSE;
     ReadRecord  := TRUE;
     ThisYear    := 0;
     ThisMonth   := 0;

     SetDefaultKeepGoing := TRUE;
     FileOk    := FALSE;
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
end;

function TfSuppDownload.CheckImportTable : Boolean;
var
   TmpMark : TBookMark;
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
             cbSupplier.DropDown;
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
begin
     if CheckImportTable then
        begin
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
                 WriteTransactions( 1, PlFile, WasAct, FALSE );
                 ImportTable.Next;
              end;
           SavedInfo := TRUE;   // To allow save of Month year combo when exiting
           GetNextTx;   // Get the Next record
        end;
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

   function CheckDates : Boolean;
   var
      DateOK : Boolean;
   begin
        RESULT := TRUE;
        (*
        ReSet(MyFile);
        DateOK := FALSE;
        MilkIDSet := FALSE;
        while NOT EOF(MyFile) do
           begin
              ReadLn(MyFile,DiskLine);
              if ( CountryCode = 'N' ) then
                 begin
                    MilkIDSet := TRUE;
                    CurrentID := '';
                 end
              else
                 // Only check if Ireland
                 begin
                    if ( NOT MilkIDSet ) then
                       begin
                          CurrentID := Copy(DiskLine,1,7);
                          CurrentID := WinData.StripAllSpaces(CurrentID);
                          if Length(CurrentID) > 0 then
                             MilkIDSet := TRUE;
                       end;
                 end;

              // Get the Test Date
              TempStr := Copy (DiskLine, TestDatePos, TestDateLen );
              if CountryCode = 'N' then
                 begin // Northern Ireland
                    sDay := Copy(TempStr,1,2);
                    sMonth := Copy(TempStr,3,2);
                    sYear := Copy(TempStr,5,2);
                    if ( sYear >= '00' ) And ( sYear <= '80' ) then sYear := '20' + sYear;
                 end
              else  // Use ROI
                 if TestDateLen = 6 then
                    begin
                       sYear := Copy(TempStr,1,2);
                       sMonth := Copy(TempStr,3,2);
                       sDay := Copy(TempStr,5,2);
                       if ( sYear >= '00' ) And ( sYear <= '80' ) then sYear := '20' + sYear;
                    end
                 else if TestDateLen = 8 then
                    begin
                       // New 4 Digit Year
                       sYear := Copy(TempStr,1,4);
                       sMonth := Copy(TempStr,5,2);
                       sDay := Copy(TempStr,7,2);
                    end;
              NewDate := sDay + '/' + sMonth + '/' + sYear;
              try
                 if NOT DateOK then
                    RecordingDate := StrToDate(NewDate);
                 DateOK := TRUE;
              except
                 // Not a valid Date
              end;
           end;

        CloseFile(MyFile);

        Result := TRUE;
        if NOT DateOK then
           if ( NOT uMilkRecDate.ShowDate ( RecordingDate, LastRecordingDate )) then
              begin
                 RecordingDate := 0;
                 Result := FALSE;
              end
           else
              begin
                 // As the date came from the user only update cumulatives
                 TidyUpDisk := TRUE;
                 Result := TRUE;
              end;

        if Result then
           if ( HerdNum.Visible ) And ( CountryCode <> 'N' ) then
              if MilkIDSet then
                 begin
                    if Length(CurrentID) > 0 then
                       if WinData.qHerdDefaults.FieldByName('MilkRecordingID').AsString <> CurrentID then
                          begin
                             MilkIDSet := FALSE;
                             Result := FALSE;
                          end;
                 end;
        *)
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

  // GetLastRecording;
  try
     // Using the TempCow file Strip all zeros and spaces fro the AnimalNo
     if CheckDates then
        begin
           // ThisDate.Text := FormatDateTime('dd/mm/yyyy',RecordingDate);  // Set the display date
           DateSet := TRUE;

           // Empty the Table
           ImportTable.Close;
           ImportTable.EmptyTable;
           ImportTable.Open;

           EndOfTx := FALSE;
           LastDocket := '-1';
           ItemsRead := 0;

           while NOT EOF(MyFile) and ( NOT HeaderFound ) do
              begin
                 ReadLn(MyFile,DiskLine);

                 TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsRecTypeStart.AsInteger, AccsDataModule.ImportDefaultsRecTypeLen.AsInteger);
                 if ( TempStr = 'HDER2' ) Or
                    ( TempStr = '1' ) then
                    // Copy the Farmers name to display on screen
                    begin
                       if TempStr = '1' then  // Header record for Dairy Gold.
                          begin
                             TempStr := Copy(DiskLine,75,6);
                             ThisMonth := StrToInt(Copy (TempStr,5,2));
                             ThisYear  := StrToInt(Copy (TempStr,1,4));

                             ThisDate.Text := Copy (TempStr,5,2) + '/';
                             ThisDate.Text := ThisDate.Text + Copy (TempStr,1,4);
                             eStatementFor.Text := '';
                             Headerfound := TRUE;
                          end
                       else
                          begin
                             TempStr := Copy(DiskLine,64,6);  // Kerry
                             // ReFormat it to mm/yyyy
                             ThisMonth := StrToInt(Copy (TempStr,5,2));
                             ThisYear  := StrToInt(Copy (TempStr,1,4));
                             ThisDate.Text := Copy (TempStr,1,2) + '/';
                             ThisDate.Text := ThisDate.Text + Copy (TempStr,3,4);
                             TempStr := Copy(DiskLine,26,30);
                             eStatementFor.Text := TempStr;
                             Headerfound := TRUE;
                          end;
                       // test to See if the Year month Combo exists for this Import
                       CheckImportDates;
                    end;
              end;


           // Process the Statement Disk
           if HeaderFound then
           while NOT EOF(MyFile) and ( NOT EndOfTx ) and ( ItemsRead < 10 ) do
              begin
                 if ReadRecord then
                    ReadLn(MyFile,DiskLine);
                 ReadRecord := TRUE;
                 (*
                 TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsRecTypeStart.AsInteger, AccsDataModule.ImportDefaultsRecTypeLen.AsInteger);
                 if ( TempStr = 'HDER2' ) Or
                    ( TempStr = '1' ) then
                    // Copy the Farmers name to display on screen
                    begin
                       if TempStr = '1' then  // Header record for Dairy Gold.
                          begin
                             TempStr := Copy(DiskLine,75,6);
                             ThisDate.Text := ThisDate.Text + Copy (TempStr,5,2) + '/';
                             ThisDate.Text := ThisDate.Text + Copy (TempStr,1,4);
                             eStatementFor.Text := '';
                          end
                       else
                          begin
                             TempStr := Copy(DiskLine,64,6);  // Kerry
                             // ReFormat it to mm/yyyy
                             ThisDate.Text := Copy (TempStr,1,2) + '/';
                             ThisDate.Text := ThisDate.Text + Copy (TempStr,3,4);
                             TempStr := Copy(DiskLine,26,30);
                             eStatementFor.Text := TempStr;
                          end;
                       LastDocket := '-1';
                    end;
                 *)

                 TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsDocketNoStart.AsInteger, AccsDataModule.ImportDefaultsDocketNoLen.AsInteger);
                 if  ( TempStr = 'TLR2' ) or
                    (( TempStr <> LastDocket ) And ( LastDocket <> '-1' )) then
                    begin
                       EndOfTx := TRUE;   // Break from Loop
                       ReadRecord := FALSE;
                    end;

                 if AccsDataModule.ImportDefaultsCoOpName.AsString = cDairygold then
                    LastDocket := TempStr;

                 if ReadRecord then
                    begin
                       TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsRecTypeStart.AsInteger, AccsDataModule.ImportDefaultsRecTypeLen.AsInteger);
                       if ( TempStr = 'SALES' ) Or
                          ( TempStr = '2' ) then
                          begin
                             ImportTable.Insert;
                             try
                                TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsDateStart.AsInteger, AccsDataModule.ImportDefaultsDateLen.AsInteger);
                                // ReFormat it to dd/mm/yyyy
                                DateStr := Copy (TempStr,7,2) + '/';
                                DateStr := DateStr + Copy (TempStr,5,2) + '/';
                                DateStr := DateStr + Copy (TempStr,1,4);
                                ImportTable.FieldByName('InvDate').AsDateTime := StrToDateTime(DateStr);
                             except
                                ImportTable.FieldByName('InvDate').Clear;
                             end;

                             // Insert the Docket Number
                             ImportTableDocketNo.AsString := LastDocket;

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
                             TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsQuantityStart.AsInteger, AccsDataModule.ImportDefaultsQuantityLen.AsInteger);
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

                             // Get the VAT Rate
                             TempStr := Copy(DiskLine, AccsDataModule.ImportDefaultsVATRateStart.AsInteger, AccsDataModule.ImportDefaultsVATRateLen.AsInteger);
                             try
                                if AccsDataModule.ImportDefaultsVATRateDec.AsInteger = 2 then
                                   ImportTable.FieldByName('VATRate').Value := StrToFloat(IsNegOrPos(TempStr))/100
                                else
                                   ImportTable.FieldByName('VATRate').Value := StrToFloat(IsNegOrPos(TempStr))/1000;
                                if Cash11.Xuse_vat then
                                   begin
                                      ImportTable.FieldByName('TaxIDS').AsString := Cash1.xTaxIDs[0];
                                      ImportTable.FieldByName('TaxRate').AsFloat := 0;
                                   end
                                else
                                   begin
                                      if FindVAT (ImportTable.FieldByName('VATRate').AsFloat) then
                                         begin
                                            ImportTable.FieldByName('TaxIDS').AsString := VatCodes.FieldByName('TaxIDS').AsString;
                                            ImportTable.FieldByName('TaxRate').AsFloat := VatCodes.FieldByName('TaxRate').AsFloat;
                                            ImportTable.FieldByName('TaxAmount').AsFloat := (ImportTable.FieldByName('Amount').Value * VatCodes.FieldByName('TaxRate').AsFloat) / 100;
                                         end;
                                   end;
                             except
                                VATRateOK := FALSE;
                                NoErrors := FALSE;
                             end;

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

           (*
           if (( FirstRecording ) Or ( RecordingDate > LastRecordingDate )) And
               ( NoErrors ) then
              begin
                 // Insert a new Recording Record
                 with WinData.MainMilkTrans do
                    begin
                       Open;
                       Insert;
                       FieldByName('RecordingDate').AsDateTime := RecordingDate;
                       if TidyUpDisk then
                          begin
                             FieldByName('Description').Value := 'Cumulative Update ' + FormatDateTime('dd/mm/yyyy',RecordingDate);
                             FieldByName('NMRRecording').Value := FALSE;
                          end
                       else
                          begin
                             FieldByName('Description').Value := 'Milk Recording on ' + FormatDateTime('dd/mm/yyyy',RecordingDate);
                             FieldByName('NMRRecording').Value := TRUE;
                          end;
                       Post;
                       Last;

                       MilkID := FieldByName('ID').Value;

                       MyQuery.SQL.Clear;
                       MyQuery.SQL.Add('UPDATE TempMilk SET MDTID=' + IntToStr(MilkId));
                       MyQuery.Prepare;
                       MyQuery.ExecSQL;
                       Close;
                    end;

                 //if ( iNoNotFound = 0 ) then
                 sbExecRecord.Enabled := True;
              end
           else if ( RecordingDate = LastRecordingDate ) and ( NoErrors ) then
              MessageDLG('Recording Date''s are the same',mtInformation,[mbOK],0)
           else if NoErrors then
              MessageDLG('Last Recording Date is after this Recording Date',mtInformation,[mbOK],0)
           else
           *)
           if ( NOT NoErrors ) then
              begin
                 ImportTable.Close;
                 ImportTable.EmptyTable;
                 ImportTable.Open;
                 ReportErrors;
                 MessageDLG('Error on Statement Disk',mtWarning,[mbOK],0);
              end;
        end
     else
        MessageDLG('Cannot continue without a valid Date',mtWarning,[mbOK],0);
  except
     ImportTable.Close;
     ImportTable.EmptyTable;
     ReportErrors;
     MessageDLG('Error(s) on Statement Disk',mtWarning,[mbOK],0);
  end;
end;

procedure TFSuppDownLoad.CheckImportDates;
begin
   try
      AccsDataModule.ImportDates.Open;
      if AccsDataModule.ImportDates.Locate('ImportYear;ImportMonth;Importfrom',
            VarArrayOf([ThisYear, ThisMonth, AccsDataModule.ImportDefaultsCoOpName.AsVariant]), []) then
         ShowMessage('This Data may already have been inputted');
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
    AccsDataModule.GetNominalLedgerAccs;
    AccsDataModule.GetPurchaseLedgerAccs;
    // Create the Table for a Down Load.
    CreateDownLoadTable;
end;

procedure TfSuppDownload.ImportTableNLAccValidate(Sender: TField);
begin
    if NOT AccsDataModule.qNominalLedger.Locate('Account',(Sender as TField).AsInteger,[] ) then
       raise ErrorMsg.CreateFmt('Account must exist on Listing',[nil]);
end;

function TfSuppDownload.FindVAT (ThisRate : Double ) : Boolean;
begin
    RESULT := FALSE;
    with VatCodes do
       begin
           First;
           while NOT EOF do
              begin
                 if FieldByName('TaxRate').AsFloat = ThisRate then
                    begin
                       RESULT := TRUE;
                       Break;
                    end;
                 Next;
              end;
       end;
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
     if Length ( TestStr ) > 0 then
        if NOT DateValid ( TestStr, TDateFormat ) then
           CorrectEntry := FALSE;

     if CorrectEntry then
        begin
             zCustRec[1] := Integer(cbSupplier.KeyValue);
             zAccount[1] := Integer(cbSupplier.KeyValue);

             if AccsDataModule.ImportDefaultsCoOpName.AsString = cDairygold then
                if ( NOT ImportTable.FieldByName('DocketNo').IsNull ) then
                   zComm[1] := Copy(ImportTable.FieldByName('DocketNo').AsString,1,SizeOf(zComm[1]));

             zRef[1] := Copy(ImportTable.FieldByName('TransRef').AsString,1,SizeOf(zRef[1]));

             TestStr := ImportTable.FieldByName('InvDate').AsString;
             zTxDate[1] := KDateToInt ( TestStr );
             LineOk := 1;

             while ( NOT ImportTable.EOF ) And ( LineOK <= 10 ) do
                begin
                   zUse[1,LineOK] := True;
                   ZGen[1,LineOK] := ImportTable.FieldByName('NLAcc').AsInteger;
                   ZDesc[1,LineOK] := Copy(ImportTable.FieldByName('Description').AsString,1,SizeOf(zDesc[1,LineOK]));

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
       pSetDefault.Hide;
       Caption := AccsDataModule.ImportDefaultsCoOpName.AsString + ' DownLoad';
       lwhichCoOp.Caption := cUserInfo + AccsDataModule.ImportDefaultsCoOpName.AsString;
    except
        ShowMessage('Cannot Set Default');
    end;
end;

procedure TfSuppDownload.BitBtn3Click(Sender: TObject);
begin
    pSetDefault.Show;
end;

procedure TfSuppDownload.bCloseChooseCoOpClick(Sender: TObject);
begin
    pWarning.Hide;
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

proce
