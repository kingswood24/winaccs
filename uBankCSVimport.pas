
unit uBankCSVimport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Mask, ToolEdit, RxLookup, Grids, DBGrids, DB,
  DBCtrls, RXDBCtrl, Menus, RXCtrls, uAccounts, Types;

const
   WM_PROCESSGRIDKEYPRESS = WM_USER+1;

type
  THackGrid = class(TDBGrid);
  TBankCSVImportForm = class(TForm)
    Panel1: TPanel;
    Exitbtn: TBitBtn;
    SaveBtn: TBitBtn;
    SetupBtn: TBitBtn;
    DropDownBox: TDBComboBox;
    Panel2: TPanel;
    Instructions: TLabel;
    TxGrid: TDBGrid;
    gbImportPanel: TGroupBox;
    SourceBankLabel: TLabel;
    BrowseLabel: TLabel;
    BankAccountLabel: TLabel;
    ListAccounts: TSpeedButton;
    BankNameLabel: TLabel;
    ImportFile: TFilenameEdit;
    ImportBtn: TBitBtn;
    InputFormatLookup: TRxDBLookupCombo;
    BankAccount: TEdit;
    procedure FormShow(Sender: TObject);
    procedure BankAccountDblClick(Sender: TObject);
    procedure BankAccountExit(Sender: TObject);
    procedure BankAccountKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListAccountsClick(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure ReadCSVSettings;
    Procedure WriteToTable(ItemCount : integer; Value : shortstring);
    procedure ExitbtnClick(Sender: TObject);
    procedure CheckTable;
    procedure SaveTransactions;
    procedure SaveBtnClick(Sender: TObject);
    Function RemoveNonNumeric(Value : shortstring): string;

    procedure SetupBtnClick(Sender: TObject);
    procedure LoadBankDefaults(BankAccount : integer);
    procedure SaveBankDefaults(BankAccount : integer);
    procedure ImportFileEnter(Sender: TObject);
    procedure ImportFileClick(Sender: TObject);
    procedure TxGridCellClick(Column: TColumn);
    procedure TxGridDblClick(Sender: TObject);
    procedure TxGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TxGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    Function GetCustSuppInfo(SalesPurchDB, RecID : Integer) : string;
    procedure FormCreate(Sender: TObject);
	procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TxGridColExit(Sender: TObject);
    procedure TxGridKeyPress(Sender: TObject; var Key: Char);
    procedure TxGridColEnter(Sender: TObject);
    procedure TxGridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FFileName : string;
    FBankAccount : TBankAccount;
    FAutoLoadTransFile : Boolean;
    FPrevColIndex : Integer;
    FColIndex : Integer;
    procedure SetupScreen();
    procedure ImportTransactions();
    function GetColumnIndexByFieldName(AFieldName : string) : Integer;
    procedure ProcessFocusedColumnChange(const AFocusedColumnIndex, APrevFocusedColumnIndex : Integer);
    function GetTransactionType() : TTransactionType;
    procedure ProcessKeyPress(var Message:TMessage); message WM_PROCESSGRIDKEYPRESS;
    function GetEditingText : string;
    procedure ProcessCustomerSupplierLookup(ALookupText : string);
//    procedure FieldOnChange(Sender : TField);
  public
    { Public declarations }
    class procedure RunImport(AFileName : string; ABankAccount : TBankAccount);
  end;

var
  BankCSVImportForm: TBankCSVImportForm;
  CSVFile      : TextFile;
  RecordString, ChequeIdentifier, LodgementIdentifier : String;
  DateCol, DetailCol, DebitCol, CreditCol, HeaderLines, FieldCount : integer;
  Delimiter : string;
  TableOK : boolean;
  Filein : TStringlist;
  slColumnCaptions: TStringList;
  SalesPurchDB : Integer;
  SingleAmountColumn : Boolean;

implementation

{$R *.DFM}

uses AccsData, Calcs, Vars, DBCore, DBGen, Clears, NewListing, TxWrite,
  uBankCSVConfig, Mainunit, uSetupAnalysis, Global, AccsUtils, Cashbook;

type TMyCustomGrid = class(TCustomGrid) end;

procedure TBankCSVImportForm.FormShow(Sender: TObject);
var

   Field : TField;
begin
   AccsDataModule.BankCSVDefaultsDB.open;

   AccsDataModule.BankCSVTempTableDB.close;
//        AccsDataModule.BankCSVTempTableDB.EmptyTable;
   if FileExists  (AccsDataModule.AccsDataBase.Directory + '\BankCSVTempTable.db')  then  DeleteFile  (AccsDataModule.AccsDataBase.Directory + '\BankCSVTempTable.db');

   AccsDataModule.CreateBankImportTempTable;

   AccsDataModule.BankCSVTempTableDB.open;

//   AccsDataModule.BankCSVTempTableDB.FieldByName('Analysis').OnChange := FieldOnChange;

   if FAutoLoadTransFile then
      begin
         BankAccount.Text := IntToStr(FBankAccount.Id);
         ImportFile.FileName := FFileName;
         InputFormatLookup.Value := IntToStr(FBankAccount.BankFileFormat);
      end
   else
      begin
         BankNameLabel.caption := '';
         ImportFile.ClearSelection;
         ImportFile.text := '<Select Location of Bank File>';
         InputFormatLookup.ResetField;
         BankCSVImportForm.Caption := 'Bank Statement Import';

         BankAccount.Text := IntToStr(Cash1.xLastBank);
      end;
   SetupScreen();
   BankAccountExit(self);
end;

procedure TBankCSVImportForm.BankAccountDblClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Banks, 'N' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        BankAccount.Text := NewListBox.ListInfo.ReturnValue;
end;

procedure TBankCSVImportForm.BankAccountExit(Sender: TObject);
Var
   TestStr  : ShortString;
   AccRange : TAccRange;

   Procedure GetBankInfo;
   Begin
        SetDb ( NlFile );
        ReadRec ( NlFile, StrToInt ( TestStr ));
        If RecActive ( NlFile ) Then
           Begin
              GetItem ( NlFile, 1 );
              BankNameLabel.Caption := CurrStr;

              // look up default bank file & location
              if not(FAutoLoadTransFile) then
                 LoadBankDefaults(StrToInt ( TestStr ));
           End;
   End;

begin
     InitRange ( AccRange );
     AccRange[1] := Cash1.xBankMin;
     AccRange[2] := Cash1.xBankMax;
     TestStr := BankAccount.Text;
     SlimAll ( TestStr );
     If ( NOT NewListBox.CheckNom ( BankAccount.Text,{ 0, 0, }AccRange )) or
        ( Length ( TestStr ) = 0 ) Then
        BankAccount.SetFocus
     Else
         GetBankInfo;

end;

procedure TBankCSVImportForm.BankAccountKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    If Key = VK_F2 Then
       Begin
         NewListBox.ListIt ( Sender, Banks, 'N' );
         If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
            BankAccount.Text := NewListBox.ListInfo.ReturnValue;
         Key := 0;
       End;
end;

procedure TBankCSVImportForm.ListAccountsClick(Sender: TObject);
begin
        NewListBox.ListIt ( Sender, Banks, 'N' );
        If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
              BankAccount.Text := NewListBox.ListInfo.ReturnValue;
        BankAccountExit ( Sender );
end;

procedure TBankCSVImportForm.ReadCSVSettings;
begin
        // Read default parameters

        DateCol := 0;
        DetailCol := 0;
        DebitCol := 0;
        CreditCol := 0;
        Delimiter := ',';
        ChequeIdentifier := '';
        LodgementIdentifier := '';
        HeaderLines := 0;
        FieldCount := 0;
        SingleAmountColumn := False;

        Accsdatamodule.BankCSVDefaultsDB.Locate('ID',InputFormatLookup.KeyValue,[]);

        DateCol     := Accsdatamodule.BankCSVDefaultsDB['DateFieldNo'];
        DetailCol   := Accsdatamodule.BankCSVDefaultsDB['DetailFieldNo'];
        DebitCol    := Accsdatamodule.BankCSVDefaultsDB['DebitFieldNo'];
        try CreditCol   := Accsdatamodule.BankCSVDefaultsDB['CreditFieldNo'];
        except CreditCol := 0;
        end;

        if CreditCol = 0 then SingleAmountColumn := True;

        HeaderLines := Accsdatamodule.BankCSVDefaultsDB['HeaderLines'];
        try FieldCount   := Accsdatamodule.BankCSVDefaultsDB['FieldCount'];     // function not enabled
        except FieldCount   := 25;    // used as count of data items in csv to be used to limit loop time
        end;

        if Accsdatamodule.BankCSVDefaultsDB['Delimiter'] <> '' then Delimiter := Accsdatamodule.BankCSVDefaultsDB['Delimiter'];
        if Accsdatamodule.BankCSVDefaultsDB['ChequeIdentifier'] <> '' then ChequeIdentifier := Accsdatamodule.BankCSVDefaultsDB['ChequeIdentifier'];
        if Accsdatamodule.BankCSVDefaultsDB['LodgementIdentifier'] <> '' then LodgementIdentifier := Accsdatamodule.BankCSVDefaultsDB['LodgementIdentifier'];
end;

procedure TBankCSVImportForm.ImportBtnClick(Sender: TObject);
begin
   ImportTransactions();
end;

procedure TBankCSVImportForm.WriteToTable(ItemCount : integer; Value : shortstring);
var
    TempStr : Shortstring;
    TempReal : Real;
    i : integer;

begin

        if ItemCount = DateCol then begin
           Slimall(Value);

           // Northern Bank as . in date not /
           for i:= 1 to length(Value) do begin
               if Value[i] = '.' then Value[i] := '/';
           end;

           AccsDataModule.BankCSVTempTableDB['TxDate'] := StrToDate(Value);
        end;
        if ItemCount = DetailCol then begin
           // Identify any Stub Number
           if pos(ChequeIdentifier,Value) > 0 then begin
              AccsDataModule.BankCSVTempTableDB['Details'] := ChequeIdentifier;
              TempStr := copy(Value,pos(ChequeIdentifier,Value)+length(ChequeIdentifier),length(Value));
              Slimall(TempStr);
              AccsDataModule.BankCSVTempTableDB['StubNumber'] := TempStr;
           end else
                    if pos(LodgementIdentifier,Value) > 0 then begin
                           AccsDataModule.BankCSVTempTableDB['Details'] := LodgementIdentifier;
                           TempStr := copy(Value,pos(LodgementIdentifier,Value)+length(LodgementIdentifier),length(Value));
                           Slimall(TempStr);
                           AccsDataModule.BankCSVTempTableDB['StubNumber'] := TempStr;
                    end else begin
                             Slimall(Value);
                             AccsDataModule.BankCSVTempTableDB['Details'] := Value;
                             end;
        end;
        if ItemCount = DebitCol then begin
           Value := RemoveNonNumeric(Value);

           if SingleAmountColumn then begin
              if length(Value) > 0 then begin
                 if Value[1] = '-' then begin
                       Value := copy(Value,2,length(Value)-1);
                       try TempReal := StrToFloat(Value);
                            AccsDataModule.BankCSVTempTableDB['Expenditure'] := TempReal;
                       except
                       end;

                    end else begin
                             if Value[1] = '+' then Value := copy(Value,2,length(Value)-1);
                             try TempReal := StrToFloat(Value);
                                 AccsDataModule.BankCSVTempTableDB['Income'] := TempReal;
                             except
                             end;
                    end;
              end;
           end else begin // SingleAmountColumn

                        try TempReal := StrToFloat(Value);
                            AccsDataModule.BankCSVTempTableDB['Expenditure'] := TempReal;
                        except
                        end;
           end;

        end;
        if ItemCount = CreditCol then begin
           Value := RemoveNonNumeric(Value);
           try TempReal := StrToFloat(Value);
               AccsDataModule.BankCSVTempTableDB['Income'] := TempReal;
           except
           end;
        end;
end;

procedure TBankCSVImportForm.ExitbtnClick(Sender: TObject);
begin
        AccsDataModule.BankCSVTempTableDB.close;
        AccsDataModule.BankCSVTempTableDB.EmptyTable;
        close;
end;

Procedure TBankCSVImportForm.CheckTable;
var
        i, RecNo : integer;
        TestString, DateString, ExpendString, IncomeString : shortstring;
        TestDate : TDateTime;
        TestInteger, ArrPos : Integer;
        TestReal : Real;
        NomCode, EntCode, VATCode, CustSupp, AnalysisString : Shortstring;
        AccRange : TAccRange;
        TypeString : string;

   AnalysisCode : TAnalysisCode;

begin
        TableOK := True;

        InitRange ( AccRange );
        AccRange[1] := 1;
        AccRange[2] := Cash1.xNomPrvExp+Cash11.xNo_Of_Partners;

        AccsDataModule.BankCSVTempTableDB.first;

        for i := 1 to AccsDataModule.BankCSVTempTableDB.recordcount do begin

          if AccsDataModule.BankCSVTempTableDB['Import'] = 'ü' then begin

            TestString := '';
            DateString := '';
            ExpendString := '';
            IncomeString := '';
            NomCode := '';
            EntCode := '';
            VATCode := '';
            CustSupp := '';
            AnalysisString := '';
            TypeString := '';

            DateString := AccsDatamodule.BankCSVTempTableDB.FieldByName('TxDate').AsString;
            try
                     TestDate := StrToDate(DateString);
            except
                     TableOK := False;
                     ShowMessage('"' + DateString + '" is not a valid Date');
                     exit;
            end;

            TestString := AccsDatamodule.BankCSVTempTableDB.FieldByName('StubNumber').AsString;
            if TestString <> '' then begin
                try
                     TestInteger := StrToInt(TestString);
                except
                     TableOK := False;
                     ShowMessage('"' + TestString + '" is not a valid Stub Number');
                     exit;
                end;
            end;

            TestString := AccsDatamodule.BankCSVTempTableDB.FieldByName('VATCode').AsString;
            if TestString <> '' then begin
                if not NewListBox.CheckVat ( TestString, ArrPos ) then begin
                       ShowMessage('"' + TestString + '" is not a valid VAT Code');
                       TableOK := False;
                end;
            end else begin
                      ShowMessage('VAT Code cannot be blank - Enter ''Z'' for zero VAT transactions');
                      TableOK := False;
                      exit;
                     end;

            ExpendString := AccsDatamodule.BankCSVTempTableDB.FieldByName('Expenditure').AsString;
            if ExpendString = '0' then ExpendString := '';
            if ExpendString = '0.00' then ExpendString := '';

            IncomeString := AccsDatamodule.BankCSVTempTableDB.FieldByName('Income').AsString; 
            if IncomeString = '0' then IncomeString := '';
            if IncomeString = '0.00' then IncomeString := '';

            if ((ExpendString <> '') and (IncomeString <> '')) then begin
                ShowMessage(DateString + ' - Cannot have both an Income && Expenditure value');
                TableOK := False;
                exit;
            end;

            if ((ExpendString = '') and (IncomeString = '')) then begin
                ShowMessage(DateString + ' - Both Income && Expenditure value cannot be zero');
                TableOK := False;
                exit;
            end;

            if ExpendString <> '' then begin
                try
                     TestReal := StrToFloat(ExpendString);
                except
                     TableOK := False;
                     ShowMessage('"' + ExpendString + '" is not a valid Expenditure value');
                     exit;
                end;
            end;

            if IncomeString <> '' then begin
                try
                     TestReal := StrToFloat(IncomeString);
                except
                     TableOK := False;
                     ShowMessage('"' + IncomeString + '" is not a valid Income value');
                     exit;
                end;
            end;

            NomCode := AccsDatamodule.BankCSVTempTableDB.FieldByName('NomCode').AsString; 
            slimall(NomCode);

            if NomCode = '' then begin
                                        ShowMessage(DateString + ' - Blank Nominal Code');
                                        TableOK := False;
                                        exit;
            end else begin
                        if not NewListBox.CheckNom ( NomCode, AccRange ) then begin
                             ShowMessage(NomCode + ' - Invalid Nominal Code');
                             TableOK := False;
                             exit;
                        end;
            end;

            EntCode := AccsDatamodule.BankCSVTempTableDB.FieldByName('Enterprise').AsString; 
            slimall(EntCode);

            if EntCode <> '' then begin

               If NOT CheckEnt ( EntCode, RecNo ) Then begin
                    ShowMessage(EntCode + ' - Invalid Enterprise Code');
                    TableOK := False;
                    exit;
               end;
            end;

            AnalysisString := AccsDatamodule.BankCSVTempTableDB.FieldByName('Analysis').AsString;
            if AnalysisString <> '' then begin
               try
                     TestInteger := StrToInt(AnalysisString);

                     AnalysisCode := AccsDatamodule.Accounts.AnalysisCodes.GetAnalysisCode(AnalysisString);
                     if (AnalysisCode = nil) then
                        begin
                           MessageDlg('The Analysis code you have entered does not exist.',mtError,[mbOK],0);
                           Exit;
                        end;

               except
                     TableOK := False;
                     exit;
               end;
            end;

            TypeString := AccsDatamodule.BankCSVTempTableDB.FieldByName('Type').AsString;
            if (TypeString <> 'Sale/Purch') and (TypeString <> 'Pay / Rec') and (TypeString <> 'S Order') and (TypeString <> 'DD / DC') and (TypeString  <> 'Cashbook') then begin
                TableOK := False;
                ShowMessage('"' + DateString + '" has an invalid Tx Type');
                exit;
            end;

            if (TypeString = 'Sale/Purch') or (TypeString = 'Pay / Rec') then begin
                  CustSupp := '';
                  CustSupp := AccsDatamodule.BankCSVTempTableDB.FieldByName('CustSupp').AsString;
                  if CustSupp = '' then begin
                     TableOK := False;
                     ShowMessage('"' + DateString + '" has an No Customer / Supplier');
                     exit;
                  end;
            end;

 (*
            CustSupp := AccsDatamodule.BankCSVTempTableDB.FieldByName('CustSupp').AsString;
               if CustSupp <> '' then begin

               end;
            end;
   *)


          end;  // if import = true

          AccsDataModule.BankCSVTempTableDB.next;

        end;  // if i :=.....

end;

Procedure TBankCSVImportForm.SaveTransactions;
var
        PCount : integer;
        i : integer;
        DateString, DescString, StubString, ExpendString, IncomeString, NomString, EntString, VATCode, VATString, CustSuppName, CustSupp, TempStr, TxType : shortstring;
        StubNo, AnalysisCode : integer;
        Expend, Income : real;
        NomCode, VATArrPos : integer;
        VATAmt, NomAmt : long;
        IsExclusive : boolean;

begin
   try
        For PCount := 1 To MaxTx Do
             New ( TxHold[PCount] );
        For PCount := 1 To MaxNom Do
             New ( NomHold[PCount] );
         { Initialise the Pointer Variable }
        For PCount := 1 To MaxTx Do
             FillChar ( TxHold[PCount]^, SizeOf(TxHold[PCount]^),chr(0));
        For PCount := 1 To MaxNom Do
             FillChar ( NomHold[PCount]^, SizeOf(NomHold[PCount]^),chr(0));

        AccsDataModule.BankCSVTempTableDB.first;


        for i := 1 to AccsDatamodule.BankCSVTempTableDB.recordcount do begin

        if AccsDataModule.BankCSVTempTableDB['Import'] = 'ü' then begin

        Initvals;

        DateString   := '';
        DescString   := '';
        StubString   := '';
        ExpendString := '';
        IncomeString := '';
        EntString    := '';
        NomString    := '';
        VATString    := '';
        CustSupp     := '';
        CustSuppName := '';
        TxType       := '';
        Expend       := 0;
        Income       := 0;
        VATAmt       := 0;
        NomAmt       := 0;
        AnalysisCode := 0;

        DateString := AccsDatamodule.BankCSVTempTableDB.FieldByName('TxDate').AsString;
        DescString := AccsDatamodule.BankCSVTempTableDB.FieldByName('Details').AsString;
        StubString := AccsDatamodule.BankCSVTempTableDB.FieldByName('StubNumber').AsString;

        EntString := AccsDatamodule.BankCSVTempTableDB.FieldByName('Enterprise').AsString;
        NomString := AccsDatamodule.BankCSVTempTableDB.FieldByName('NomCode').AsString;

        VATCode := AccsDatamodule.BankCSVTempTableDB.FieldByName('VATCode').AsString;

        CustSupp := AccsDatamodule.BankCSVTempTableDB.FieldByName('CustSupp').AsString;
        CustSuppName := AccsDatamodule.BankCSVTempTableDB.FieldByName('CustSuppName').AsString;

        TxType := AccsDatamodule.BankCSVTempTableDB.FieldByName('Type').AsString;

        try AnalysisCode := AccsDatamodule.BankCSVTempTableDB.FieldByName('Analysis').AsInteger;
        except AnalysisCode := 0;
        end;

        try Income := AccsDatamodule.BankCSVTempTableDB['Income'];
        except
        end;
        try Expend := AccsDatamodule.BankCSVTempTableDB['Expenditure'];
        except
        end;

        DoubletoStr((Expend*100), ExpendString , '%8.2f', True, True, 8, True);
        DoubletoStr((Income*100), IncomeString , '%8.2f', True, True, 8, True);
        Slimall(ExpendString);
        Slimall(IncomeString);

        slimall(VATCode);

        if VATCode <> 'Z' then begin
           if ( NewListBox.CheckVAT ( VATCode, VATArrPos )) then
               begin
                  if Income <> 0 then begin
                        StrLong(IncomeString,NomAmt);
                        NewListBox.CalcTax ( VATArrpos, TempStr, VatAmt, NomAmt, IsExclusive );
                        LongStr(VatAmt,VATString,'L');
                        Slimall(VATString);
                        StrLong(IncomeString,NomAmt);
                        NomAmt := NomAmt - VatAmt;
                        LongStr(NomAmt,IncomeString,'L');
                        Slimall(IncomeString);
                  end else begin
                                StrLong(ExpendString,NomAmt);
                                NewListBox.CalcTax ( VATArrpos, TempStr, VatAmt, NomAmt, IsExclusive );
                                LongStr(VatAmt,VATString,'L');
                                Slimall(VATString);
                                StrLong(ExpendString,NomAmt);
                                NomAmt := NomAmt - VatAmt;
                                LongStr(NomAmt,ExpendString,'L');
                                Slimall(ExpendString);
                           end;
               end;
        end;


        if ExpendString = '0' then ExpendString := '';
        if ExpendString = '0.00' then ExpendString := '';
        if IncomeString = '0' then IncomeString := '';
        if IncomeString = '0.00' then IncomeString := '';
        if VATString = '0' then VATString := '';
        if VATString = '0.00' then VATString := '';

        if TxType = 'Cashbook' then begin
             if ExpendString <> '' then prog := cashexp
                   else prog := cashinc;
             act := 0;
        end;

        if TxType = 'Sale/Purch' then begin
             if ExpendString <> '' then prog := PurchTx
                   else prog := SalesTx;
             act := 2;

        end;

        if TxType = 'Pay / Rec' then begin
             if ExpendString <> '' then prog := PurchTx
                   else prog := SalesTx;
             act := 3;

        end;

        if TxType = 'DD / DC' then begin
             if ExpendString <> '' then begin
                                        act := 1;
                                        ZRef[1] := 'DD';
                                   end
                   else begin
                           act := 2;
                           ZRef[1] := 'DC';
                   end;
             Prog := Journal;
        end;

        if TxType = 'S Order' then begin
             if ExpendString <> '' then prog := cashexp
                   else prog := cashinc;
             act := 1;
             ZRef[1] := 'S Order';
        end;

        if ((CustSupp <> '') and (CustSupp <> '0')) then begin
            slimall(CustSupp);
            ZAccount[1] := StrtoInt(CustSupp);
            ZComm[1] := CustSuppName;
        end;

        If ((Prog = PurchTx) or (Prog = SalesTX)) then ZCustRec[1] := ZAccount[1];

        ZBank[1] := StrToInt(BankAccount.text);
        Cash1.XLASTBANK := StrToInt(BankAccount.text);
        DateString := FormatDateTime('dd/mm/yy',StrToDateTime(DateString));
        ZTxDate[1] := KDateToInt(DateString);
        ZStub[1] := 0;
        if StubString <> '' then ZStub[1] := strtoint(StubString);
        zUse[1,1] := True;
        ZTax[1,1] := VATCode;  // was 'Z'
        if cash11.Xuse_enterprise = false then zEnt[1,1] := EntString;

        zGen[1,1] := strtoint(NomString);
        zDesc[1,1] := DescString;

    //    StrLong ( '1.00', ZQty[1,1] );

        zAnalysis[1,1] := AnalysisCode;

        CheckEnd;

        Case PROG Of
          CASHINC : Begin
                      SalesPurchDB := 0;
                      StrLong(IncomeString,ZAmt[1,1]);
                    End;
          CASHEXP : Begin
                      SalesPurchDB := 0;
                      StrLong(ExpendString,ZAmt[1,1]);
                    End;
          SALESTX : Begin
                      SalesPurchDB := SlFile;
                      StrLong(IncomeString,ZAmt[1,1]);
                      if act = 3 then begin      // Payment does not have a VAT element
                                            ZAmt[1,1] := ZAmt[1,1] + ZTAXAMT[1,1];
                                            ZTAXAMT[1,1] := 0;
                                       end;
                    End;
          PURCHTX : Begin
                      SalesPurchDB := PlFile;
                      StrLong(ExpendString,ZAmt[1,1]);
                      if act = 3 then begin      // Receipt does not have a VAT element
                                            ZAmt[1,1] := ZAmt[1,1] + ZTAXAMT[1,1];
                                            ZTAXAMT[1,1] := 0;
                                       end;
                    End;
          JOURNAL : Begin
                       if act = 1 then StrLong(ExpendString,ZAmt[1,1])
                          else StrLong(IncomeString,ZAmt[1,1]);
                       ZAmt[1,1] := ZAmt[1,1] + ZTAXAMT[1,1];
                       ZTAXAMT[1,1] := 0;

                    end;
        End;

        try  StrLong(VATString,ZTAXAMT[1,1]);
        except
        end;

        ZTOTAMT[1] := ZAmt[1,1];
        ZTOTTAX[1] := ZTAXAMT[1,1];


        WriteTransactions( 1, SalesPurchDB, 0, FALSE );

        end; // if import = true;

        AccsDataModule.BankCSVTempTableDB.next;

        end;  // if i :=.....
      if not IsDebugging then
         begin
            if FileExists(FFileName) then
               DeleteFile(FFileName); // delete file on successful import
         end;
   except
      on e : Exception do
         raise Exception.Create(e.Message);
   end;		

end;

procedure TBankCSVImportForm.SaveBtnClick(Sender: TObject);
begin
   CheckTable;
   if TableOK = True then begin
        SaveTransactions;
        SaveBankDefaults(StrToInt(BankAccount.text));
    //    ResetPointers(CashbookForm);
        FMainScreen.LoadTransactionGrid;
        showmessage('Transactions saved successfully');
        Formshow(self);
   end
        else begin
             AccsDataModule.BankCSVTempTableDB.first;
        end;
end;



procedure TBankCSVImportForm.SetupBtnClick(Sender: TObject);
begin
        if not bool(BankCSVConfigForm) then Application.CreateForm(TBankCSVConfigForm, BankCSVConfigForm);
        BankCSVConfigForm.show;
end;

procedure TBankCSVImportForm.LoadBankDefaults(BankAccount : integer);
begin
    AccsDataModule.BankImportDefaultsDB.open;
    try AccsDataModule.BankImportDefaultsDB.Locate('BankAccount',BankAccount,[]);
        if AccsDataModule.BankImportDefaultsDB['BankAccount'] = BankAccount then begin
                InputFormatLookup.value := AccsDataModule.BankImportDefaultsDB['DefaultBankFileID'];
                InputFormatLookup.Refresh;
                if length(AccsDataModule.BankImportDefaultsDB['DefaultPath']) > 0 then ImportFile.InitialDir := AccsDataModule.BankImportDefaultsDB['DefaultPath'];
                ImportFile.Update;

        end else begin
                 InputFormatLookup.ClearValue;
                 ImportFile.InitialDir := '';
            end;
    except  InputFormatLookup.ClearValue;
            ImportFile.InitialDir := '';

    end;
    AccsDataModule.BankImportDefaultsDB.close;
end;

procedure TBankCSVImportForm.SaveBankDefaults(BankAccount : integer);
begin
    AccsDataModule.BankImportDefaultsDB.open;
    try AccsDataModule.BankImportDefaultsDB.Locate('BankAccount',BankAccount,[]);
        if AccsDataModule.BankImportDefaultsDB['BankAccount'] = BankAccount then begin
               AccsDataModule.BankImportDefaultsDB.edit;
               AccsDataModule.BankImportDefaultsDB['DefaultBankFileID'] := InputFormatLookup.value;
               AccsDataModule.BankImportDefaultsDB['DefaultPath'] := ImportFile.InitialDir;
               AccsDataModule.BankImportDefaultsDB.post;

        end else begin
               AccsDataModule.BankImportDefaultsDB.append;
               AccsDataModule.BankImportDefaultsDB['BankAccount'] := BankAccount;
               AccsDataModule.BankImportDefaultsDB['DefaultBankFileID'] := InputFormatLookup.value;
               AccsDataModule.BankImportDefaultsDB['DefaultPath'] := ImportFile.InitialDir;
               AccsDataModule.BankImportDefaultsDB.post;
            end;
    except begin
               AccsDataModule.BankImportDefaultsDB.append;
               AccsDataModule.BankImportDefaultsDB['BankAccount'] := BankAccount;
               AccsDataModule.BankImportDefaultsDB['DefaultBankFileID'] := InputFormatLookup.value;
               AccsDataModule.BankImportDefaultsDB['DefaultPath'] := ImportFile.InitialDir;
               AccsDataModule.BankImportDefaultsDB.post;
           end;
    end;
    AccsDataModule.BankImportDefaultsDB.close;
end;

procedure TBankCSVImportForm.ImportFileEnter(Sender: TObject);
begin
        ImportFile.Text := '"' + ImportFile.InitialDir + '\"';
end;

procedure TBankCSVImportForm.ImportFileClick(Sender: TObject);
begin
        ImportFile.Text := '"' + ImportFile.InitialDir + '\"';
end;



procedure TBankCSVImportForm.TxGridCellClick(Column: TColumn);
begin


      if (Column.FieldName = 'Import') then begin
                Column.Grid.DataSource.DataSet.Edit;
                if AccsDataModule.BankCSVTempTableDB['Import'] = 'ü' then AccsDataModule.BankCSVTempTableDB['Import'] := ''
                   else AccsDataModule.BankCSVTempTableDB['Import'] := 'ü';
                Column.Grid.DataSource.DataSet.Post;
        end;

end;



procedure TBankCSVImportForm.TxGridDblClick(Sender: TObject);
begin
   NewListBox.ListInfo.Ent := '';
   if ((TxGrid.SelectedField.FieldName = 'Enterprise') and (cash11.Xuse_enterprise = false)) then
      begin   // Enterprise Column
          NewListBox.ListIt ( Sender, Enterprise, 'E' );

          if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
             begin
                AccsDatamodule.BankCSVTempTableDB.edit;
                AccsDatamodule.BankCSVTempTableDB['Enterprise'] := NewListBox.ListInfo.ReturnValue;
                AccsDatamodule.BankCSVTempTableDB.FieldByName('NomCode').AsString := '';
                AccsDatamodule.BankCSVTempTableDB.post;

//                TxGrid.SelectedField.FieldName := 'NomCode';
             end;

      end;

   if (TxGrid.SelectedField.FieldName = 'NomCode') then
      begin   // Nominal Code Column
         if AccsDatamodule.BankCSVTempTableDB.FieldByName('Expenditure').AsString <> '' then
            PROG := CASHEXP
         else
            PROG := CASHINC;

         if AccsDatamodule.BankCSVTempTableDB['Enterprise'] <> '' then
            NewListBox.ListInfo.Ent := AccsDatamodule.BankCSVTempTableDB.FieldByName('Enterprise').AsString;

         if Length ( NewListBox.ListInfo.Ent ) > 0 Then
            NewListBox.ListIt ( Sender, EntRange, 'N' )   { Nominal Ledger Accounts }
         else
            begin
               if Prog = CASHEXP then
                  NewListBox.ListIt ( Sender, OverheadsToLiab, 'N' )   // was overheads
               else if Prog = CASHINC then
                  NewListBox.ListIt ( Sender, NonEntToLiab, 'N' );
            end;

         if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
            begin
               AccsDatamodule.BankCSVTempTableDB.edit;
               AccsDatamodule.BankCSVTempTableDB['NomCode'] := NewListBox.ListInfo.ReturnValue;
               AccsDatamodule.BankCSVTempTableDB.post;
            end;
      end;

      if (TxGrid.SelectedField.FieldName = 'VATCode') then begin   // VAT Code Column

             NewListBox.ListIt ( Sender, Vat, 'W' );   { VAT Rates }
                          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
                             begin
                                 AccsDatamodule.BankCSVTempTableDB.edit;
                                 AccsDatamodule.BankCSVTempTableDB['VATCode'] := NewListBox.ListInfo.ReturnValue;
                                 AccsDatamodule.BankCSVTempTableDB.post;
                             end;
      end;
 (*
      if (TxGrid.SelectedField.FieldName = 'CustSupp') then
      begin   // Nominal Code Column
         if AccsDatamodule.BankCSVTempTableDB.FieldByName('Expenditure').AsString <> '' then
            PROG := CASHEXP
         else
            PROG := CASHINC;

         if Prog = CASHEXP then NewListBox.ListIt ( Sender, Suppliers, 'S' )
            else if Prog = CASHINC then NewListBox.ListIt ( Sender, Customers, 'C' );

         if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
            begin
               AccsDatamodule.BankCSVTempTableDB.edit;
               AccsDatamodule.BankCSVTempTableDB['CustSupp'] := NewListBox.ListInfo.ReturnValue;
               AccsDatamodule.BankCSVTempTableDB.post;
            end;

      end;
   *)

      if (TxGrid.SelectedField.FieldName = 'CustSuppName') then
      begin   // Nominal Code Column
         if AccsDatamodule.BankCSVTempTableDB.FieldByName('Expenditure').AsString <> '' then
            PROG := CASHEXP
         else
            PROG := CASHINC;


         if Prog = CASHEXP then NewListBox.ListIt ( Sender, Suppliers, 'S' )
            else if Prog = CASHINC then NewListBox.ListIt ( Sender, Customers, 'C' );

         if not IsNumeric(TxGrid.SelectedField.AsString) then
            NewListBox.InitialSearchFieldText := TxGrid.SelectedField.AsString;

         if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
            begin
               AccsDatamodule.BankCSVTempTableDB.edit;
               AccsDatamodule.BankCSVTempTableDB['CustSupp'] := NewListBox.ListInfo.ReturnValue;
               if Prog = CASHEXP then AccsDatamodule.BankCSVTempTableDB['CustSuppName'] := GetCustSuppInfo(PLFile,StrToInt(NewListBox.ListInfo.ReturnValue))
                  else if Prog = CASHINC then AccsDatamodule.BankCSVTempTableDB['CustSuppName'] := GetCustSuppInfo(SLFile,StrToInt(NewListBox.ListInfo.ReturnValue));
               AccsDatamodule.BankCSVTempTableDB.post;
            end
                else begin
                    AccsDatamodule.BankCSVTempTableDB.edit;
                    AccsDatamodule.BankCSVTempTableDB['CustSupp'] := 0;
                    AccsDatamodule.BankCSVTempTableDB['CustSuppName'] := '';
                    AccsDatamodule.BankCSVTempTableDB.post;
                end;
      end;

      if (TxGrid.SelectedField.FieldName = 'Import') then
      begin
                AccsDatamodule.BankCSVTempTableDB.edit;
                if AccsDataModule.BankCSVTempTableDB['Import'] = 'ü' then AccsDataModule.BankCSVTempTableDB['Import'] := ''
                   else AccsDataModule.BankCSVTempTableDB['Import'] := 'ü';
                AccsDatamodule.BankCSVTempTableDB.Post;
      end;

      if (TxGrid.SelectedField.FieldName = 'Analysis') then
      begin

                if not bool(SetupAnalysisForm) then Application.CreateForm(TSetupAnalysisForm, SetupAnalysisForm);
                SetupAnalysisForm.ShowWindow(1);
                if length(Setupanalysisform.selectedcode) > 0 then begin
                   AccsDatamodule.BankCSVTempTableDB.edit;
                   AccsDataModule.BankCSVTempTableDB['Analysis'] := Setupanalysisform.selectedcode;
                   AccsDatamodule.BankCSVTempTableDB.post;
                end;
      end;



end;

procedure TBankCSVImportForm.TxGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 TempStr : string;
begin

 if Key = VK_F2 then
      begin   { F2 Pressed }
              NewListBox.ListInfo.Ent := '';
   if ((TxGrid.SelectedField.FieldName = 'Enterprise') and (cash11.Xuse_enterprise = false)) then
      begin   // Enterprise Column
          NewListBox.ListIt ( Sender, Enterprise, 'E' );

          if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
             begin
                AccsDatamodule.BankCSVTempTableDB.edit;
                AccsDatamodule.BankCSVTempTableDB['Enterprise'] := NewListBox.ListInfo.ReturnValue;
                AccsDatamodule.BankCSVTempTableDB.FieldByName('NomCode').AsString := '';
                AccsDatamodule.BankCSVTempTableDB.post;

//                TxGrid.SelectedField.FieldName := 'NomCode';
             end;

      end;

   if (TxGrid.SelectedField.FieldName = 'NomCode') then
      begin   // Nominal Code Column
         if AccsDatamodule.BankCSVTempTableDB.FieldByName('Expenditure').AsString <> '' then
            PROG := CASHEXP
         else
            PROG := CASHINC;

         if AccsDatamodule.BankCSVTempTableDB['Enterprise'] <> '' then
            NewListBox.ListInfo.Ent := AccsDatamodule.BankCSVTempTableDB.FieldByName('Enterprise').AsString;

         if Length ( NewListBox.ListInfo.Ent ) > 0 Then
            NewListBox.ListIt ( Sender, EntRange, 'N' )   { Nominal Ledger Accounts }
         else
            begin
               if PROG = CASHEXP then
                  NewListBox.ListIt ( Sender, OverheadsToLiab, 'N' )   // was overheads
               else if PROG = CASHINC then
                  NewListBox.ListIt ( Sender, NonEntToLiab, 'N' );
            end;

         if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
            begin
               AccsDatamodule.BankCSVTempTableDB.edit;
               AccsDatamodule.BankCSVTempTableDB['NomCode'] := NewListBox.ListInfo.ReturnValue;
               AccsDatamodule.BankCSVTempTableDB.post;
            end;

      end;


      end;

      if (TxGrid.SelectedField.FieldName = 'VATCode') then begin   // VAT Code Column

             NewListBox.ListIt ( Sender, Vat, 'W' );   { VAT Rates }
                          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
                             begin
                                 AccsDatamodule.BankCSVTempTableDB.edit;
                                 AccsDatamodule.BankCSVTempTableDB['VATCode'] := NewListBox.ListInfo.ReturnValue;
                                 AccsDatamodule.BankCSVTempTableDB.post;
                             end;
      end;
      
      {if (TxGrid.SelectedField.FieldName = 'Analysis') then
      begin

                if not bool(SetupAnalysisForm) then Application.CreateForm(TSetupAnalysisForm, SetupAnalysisForm);
                SetupAnalysisForm.ShowWindow(1);
                if length(Setupanalysisform.selectedcode) > 0 then begin
                   AccsDatamodule.BankCSVTempTableDB.edit;
                   AccsDataModule.BankCSVTempTableDB['Analysis'] := Setupanalysisform.selectedcode;
                   AccsDatamodule.BankCSVTempTableDB.post;
                end;
      end;}

end;


Function TBankCSVImportForm.RemoveNonNumeric(Value : shortstring): string;
var
    i : integer;
    TempStr : shortstring;
begin
    while pos(',',Value) > 0 do begin

    if pos(',',Value) > 0 then begin
        TempStr := copy(Value,1,pos(',',Value)-1) + copy(Value,pos(',',Value)+1,length(Value));
        Value := TempStr;
    end;

    end;


    for i := 1 to length(Value) do begin
        if not (Value[i] in ['1','2','3','4','5','6','7','8','9','0','.','+','-']) then Value[i] := ' ';
    end;
    Slimall(Value);
    Result := Value;
end;




procedure TBankCSVImportForm.TxGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
        S1, S2: String;
        sCaption : String;
begin
        sCaption := slColumnCaptions[Column.Index];
        TMyCustomGrid(TxGrid).RowHeights[0] := 32;
        with TxGrid do begin

                Canvas.Brush.Style := bsClear;

                if Pos(';',sCaption) = 0 then begin
                        s1 := sCaption;
                        s2 := '';
                end
                   else begin
                          s1 := Copy(sCaption,1,Pos(';',sCaption)-1);
                          s2 := Copy(sCaption,Pos(';',sCaption)+1,Length(sCaption)-Length(s1));
                   end;

                TxGrid.Columns[Column.Index].Title.Caption := S1;
                Canvas.Font.Name := 'MS Sans Serif';
                //Canvas.TextOut(Rect.Left+2, 2, S1); Causes Flicker so use .caption line above
                Canvas.TextOut(Rect.Left+2, 16, S2);
        end;


         if (gdFocused in State) then
  begin
{    if (Column.Field.FieldName = 'Type') then
    with DropDownBox do
    begin
      Left := Rect.Left + TxGrid.Left + 2;
      Top := Rect.Top + TxGrid.Top + 2;
      Width := Rect.Right - Rect.Left;
      Width := Rect.Right - Rect.Left;
      Height := Rect.Bottom - Rect.Top;

      Visible := True;
    end;  }
  end
end;

Function TBankCSVImportForm.GetCustSuppInfo(SalesPurchDB, RecID : Integer) : string;
   Var
      TStr, TempStr : ShortString;
Begin
        SetDb ( SalesPurchDB );
        ReadRec ( SalesPurchDB, RecID );
        If RecActive ( SalesPurchDB ) Then
           Begin
              // Get the Name
              GetItem ( SalesPurchDB, 1 );
              Result := CurrStr;
        end;
End;

class procedure TBankCSVImportForm.RunImport(AFileName : string;
   ABankAccount : TBankAccount);
begin
   if (ABankAccount = nil) then
      raise Exception.Create('Invalid Bank argument passed.');

   if not (FileExists(AFileName)) then
      raise Exception.Create('Bank Transaction file does not exist.');

   with TBankCSVImportForm.Create(nil) do
      try
         FFileName := AFileName;
         FBankAccount := ABankAccount;
         FAutoLoadTransFile := True;
         ShowModal;
      finally
         Free;
      end;
end;

procedure TBankCSVImportForm.FormCreate(Sender: TObject);
var
   i: Integer;
   s: String;
begin
   slColumnCaptions := TStringList.Create;

   for i := 0 to TxGrid.Columns.Count-1 do begin
           s := TxGrid.Columns[i].Title.Caption;
           slColumnCaptions.Add(s);
           TxGrid.Columns[i].Title.caption := '';
   end;
   
   FFileName := '';


end;

procedure TBankCSVImportForm.SetupScreen();
begin
   BrowseLabel.Visible := not FAutoLoadTransFile;
   ImportFile.Visible := not FAutoLoadTransFile;
   ImportBtn.Visible := not FAutoLoadTransFile;
   SourceBankLabel.Visible := not FAutoLoadTransFile;
   InputFormatLookup.Visible := not FAutoLoadTransFile;

   Instructions.Visible := false;

   TxGrid.Columns[1].visible := false;    // type column - hidden for cashbook only customers

//      if cash11.xuse_inc_exp = true then begin
//          TxGrid.Columns[1].visible := true;
//      end;

   if (cash11.xuse_inc_exp = true) or ((cash11.xuse_inc_exp = false) and (cash1.xcashbook = false)) then begin
       TxGrid.Columns[1].visible := true;
       Instructions.Visible := true;
   end
   else
      begin
         height := height - 55;
      end;

   DropDownbox.Items.Clear;
   Instructions.Caption := '';
   DropDownbox.Items.Add('Sale/Purch');
   Instructions.Caption := 'Tx Types        Sale / Purch   - Cash Sale / Cash Purchase';
   DropDownbox.Items.Add('Pay / Rec');
   Instructions.Caption := Instructions.Caption + #10#13 + '                      Pay / Rec        - Payment / Receipt';
   DropDownbox.Items.Add('S Order');
   Instructions.Caption := Instructions.Caption + #10#13 + '                      S Order          - Standing Order';
   DropDownbox.Items.Add('DD / DC');
   Instructions.Caption := Instructions.Caption + #10#13 + '                      DD / DC          - Direct Debit / Direct Credit';

   if ((cash11.xuse_inc_exp = false) and (cash1.xcashbook = false)) then begin
       DropDownbox.Items.Add('Cashbook');
       Instructions.Caption := Instructions.Caption + #10#13 + '                      Cashbook       - Cashbook Income / Expenditure';
   end;
  TxGrid.Columns[1].PickList := DropDownbox.Items;
end;

procedure TBankCSVImportForm.ImportTransactions;
var
        Parameter : string;
        ParameterCount : integer;
        CSVLineCount : integer;
        i, line : integer;
begin

        ReadCSVSettings;

        CSVLineCount := 0;

        if ImportFile.FileName = '<Select Location of Bank File>' then begin
            showmessage('No Bank File selected - Please select a file to import');
            exit;
        end;



        if ((InputFormatLookup.DisplayValue = '') or (InputFormatLookup.DisplayValue = '<Select File Format>')) then begin
            showmessage('No Source Bank selected - Please select the appropriate Source Bank');
            exit;
        end;


        Filein := TStringlist.create;
        Filein.loadfromfile(ImportFile.FileName);

        AccsDataModule.BankCSVTempTableDB.close;
        AccsDataModule.BankCSVTempTableDB.emptytable;
        AccsDataModule.BankCSVTempTableDB.open;
        AccsDataModule.BankCSVTempTableDB.edit;

        for line := 0 to Filein.count-1 do
              begin
                 RecordString := FileIn.Strings[line];
                 CSVLineCount := CSVLineCount + 1;

                 if CSVLineCount > HeaderLines then begin

                        i := 1;

                        AccsDataModule.BankCSVTempTableDB.Append;
                        AccsDataModule.BankCSVTempTableDB['Import'] := 'ü';
                        AccsDataModule.BankCSVTempTableDB['Analysis'] := '0';

                        // need to parse the line into correct columns

                        while i < FieldCount do begin

                           if pos('"',RecordString) = 1 then begin

                                  RecordString := copy(RecordString,2,length(RecordString));

                                  if pos('"',RecordString) > 0 then begin

                                        parameter := copy(RecordString,1,pos('"',RecordString)-1);

                                        if parameter <> '' then WriteToTable(i,Parameter);

                                        if (pos('"',RecordString)+2 < length(RecordString)) then RecordString := copy(RecordString,pos('"',RecordString)+2,length(RecordString))
                                           else RecordString := '';

                                  end;

                                  i := i + 1; //next record
                                  
                           end
                               else begin

                                        if pos(Delimiter,RecordString) > 0 then begin

                                                parameter := copy(RecordString,1,pos(Delimiter,RecordString)-1);

                                                if parameter <> '' then WriteToTable(i,Parameter);

                                                RecordString := copy(RecordString,pos(Delimiter,RecordString)+1,length(RecordString));

                                        end;

                                        i := i + 1; //next record

                                        if ((pos(Delimiter,RecordString) = 0) and (length(RecordString) > 0)) then begin

                                                parameter := RecordString;

                                                if parameter <> '' then WriteToTable(i,Parameter);

                                                RecordString := '';

                                        end;
                               end;
                        end;
                 AccsDataModule.BankCSVTempTableDB['VATCode'] := 'Z';
                 if (cash11.xuse_inc_exp = true) or ((cash11.xuse_inc_exp = false) and (cash1.xcashbook = false)) then AccsDataModule.BankCSVTempTableDB['Type'] := ''
                     else AccsDataModule.BankCSVTempTableDB['Type'] := 'Cashbook';
                 AccsDataModule.BankCSVTempTableDB.post;
                 end;

              end;

        Filein.free;
end;

procedure TBankCSVImportForm.FormActivate(Sender: TObject);
begin
   OnActivate := nil;
   if FAutoLoadTransFile then
      ImportTransactions();
end;

procedure TBankCSVImportForm.TxGridColExit(Sender: TObject);
begin
{  if TxGrid.SelectedField.FieldName = 'Type' then
    DropdownBox.Visible := False }
end;

procedure TBankCSVImportForm.TxGridKeyPress(Sender: TObject;
  var Key: Char);
var
   TempStr : string;
   begin
 if (key = Chr(9)) then Exit;

  Key := System.UpCase(Key);

 { if (TxGrid.SelectedField.FieldName = 'Type') then
  begin
    DropdownBox.SetFocus;
    SendMessage(DropdownBox.Handle, WM_Char, word(Key), 0);
  end;  }
end;

procedure TBankCSVImportForm.FormDestroy(Sender: TObject);
begin
   slColumnCaptions.Free;
end;

procedure TBankCSVImportForm.TxGridColEnter(Sender: TObject);
begin
   if not (Sender is TDBGrid) then Exit;

   FPrevColIndex := FColIndex;
   FColIndex := (Sender as TDBGrid).SelectedIndex; // << Actual column index, which includes columns which are not visible.

   ProcessFocusedColumnChange(FColIndex, FPrevColIndex);
end;

procedure TBankCSVImportForm.ProcessFocusedColumnChange(
  const AFocusedColumnIndex, APrevFocusedColumnIndex: Integer);
var
   CustomerSupplierColumnIndex : Integer;
   CustomerSupplierValue : Integer;
   TempStr : string;
begin
   if not (AccsDataModule.BankCSVTempTable.State in dsEditModes) then
      AccsDataModule.BankCSVTempTable.Edit;

   CustomerSupplierColumnIndex := GetColumnIndexByFieldName('CustSuppName');
   if (APrevFocusedColumnIndex = CustomerSupplierColumnIndex) then
      begin
         // user has left the Customer/Supplier column.

         // Check if the customer/supplier code has been typed instead of the name.
         // If it has, attempt to lookup the name against the user typed code.
         // NOTE: The code must be numeric
         TempStr := Trim(AccsDataModule.BankCSVTempTableDB.FieldByName('CustSuppName').AsString);
         if IsNumeric(TempStr) then
            begin
               CustomerSupplierValue := StrToInt(TempStr);
               if (GetTransactionType = ttExpense) then
                  TempStr := GetAccountName(PLFile, CustomerSupplierValue, 1)
               else
                  TempStr := GetAccountName(SLFile, CustomerSupplierValue, 1);

               if ( Trim(TempStr) <> '' ) then
                  begin
                     AccsDataModule.BankCSVTempTableDB.FieldByName('CustSupp').AsInteger := CustomerSupplierValue;
                     AccsDataModule.BankCSVTempTableDB.FieldByName('CustSuppName').AsString := TempStr;
                  end
               else
                  begin
                     AccsDataModule.BankCSVTempTableDB.FieldByName('CustSupp').Clear;
                     AccsDataModule.BankCSVTempTableDB.FieldByName('CustSuppName').Clear;
                     if (GetTransactionType = ttExpense) then
                        TempStr := 'Supplier'
                     else
                        TempStr := 'Customer';
                     MessageDlg(Format(TempStr +' Account No: [%d] was not found.',[CustomerSupplierValue]),mtWarning,[mbOK],0);
                  end;
            end;
      end;
end;

function TBankCSVImportForm.GetColumnIndexByFieldName(
  AFieldName: string): Integer;
var
   i : Integer;
begin
   Result := -1;
   for i := 0 to TxGrid.Columns.Count-1 do
      begin
         if (UPPERCASE(TxGrid.Columns[i].Field.FieldName) = UPPERCASE(AFieldName)) then
            begin
               Result := TxGrid.Columns[i].Index;
               Break;
            end;
      end;
end;

function TBankCSVImportForm.GetTransactionType: TTransactionType;
begin
   Result := ttNone;
   if ( AccsDataModule.BankCSVTempTableDB.FieldByName('Income').AsFloat > 0 ) then
      Result := ttIncome
   else if ( AccsDataModule.BankCSVTempTableDB.FieldByName('Expenditure').AsFloat > 0 ) then
      Result := ttExpense;
end;

procedure TBankCSVImportForm.ProcessKeyPress(var Message: TMessage);
var
   TempStr : string;
begin
   if Message.Msg = WM_PROCESSGRIDKEYPRESS then
      begin
         TempStr := Trim(GetEditingText);
         if (TxGrid.SelectedField.FieldName = 'CustSuppName') then
            begin
               if not IsNumeric(TempStr) then
                  ProcessCustomerSupplierLookup(TempStr);
            end;
      end;
end;

function TBankCSVImportForm.GetEditingText: string;
begin
   Result := '';
   if (THackGrid(TxGrid).InplaceEditor = nil) then exit;

   Result := THackGrid(TxGrid).InplaceEditor.EditText;
   if (Length(Trim(Result)) <= 0) then
      Result := THackGrid(TxGrid).InplaceEditor.Text;
end;

procedure TBankCSVImportForm.TxGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   SendMessage(Handle, WM_PROCESSGRIDKEYPRESS, 0, 0);
end;

procedure TBankCSVImportForm.ProcessCustomerSupplierLookup(ALookupText : string);
begin
   if AccsDatamodule.BankCSVTempTableDB.FieldByName('Expenditure').AsString <> '' then
      PROG := CASHEXP
   else
      PROG := CASHINC;

         if not IsNumeric(TxGrid.SelectedField.AsString) then
            NewListBox.InitialSearchFieldText := ALookupText;

   if Prog = CASHEXP then NewListBox.ListIt ( nil, Suppliers, 'S' )
      else if Prog = CASHINC then NewListBox.ListIt ( nil, Customers, 'C' );

   if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then
      begin
         AccsDatamodule.BankCSVTempTableDB.edit;
         AccsDatamodule.BankCSVTempTableDB['CustSupp'] := NewListBox.ListInfo.ReturnValue;
         if Prog = CASHEXP then AccsDatamodule.BankCSVTempTableDB['CustSuppName'] := GetCustSuppInfo(PLFile,StrToInt(NewListBox.ListInfo.ReturnValue))
            else if Prog = CASHINC then AccsDatamodule.BankCSVTempTableDB['CustSuppName'] := GetCustSuppInfo(SLFile,StrToInt(NewListBox.ListInfo.ReturnValue));
         AccsDatamodule.BankCSVTempTableDB.post;
      end
          else begin
              AccsDatamodule.BankCSVTempTableDB.edit;
              AccsDatamodule.BankCSVTempTableDB['CustSupp'] := 0;
              AccsDatamodule.BankCSVTempTableDB['CustSuppName'] := '';
              AccsDatamodule.BankCSVTempTableDB.post;
          end;
end;
{
procedure TBankCSVImportForm.FieldOnChange(Sender: TField);
var
   AnalysisCode : TAnalysisCode;
begin
   if (UPPERCASE(Sender.FieldName) = 'ANALYSIS') then
      begin
         AnalysisCode := AccsDatamodule.Accounts.AnalysisCodes.GetAnalysisCode(Sender.AsString);
         if (AnalysisCode = nil) then
            begin
               MessageDlg('The Analysis code you have entered does not exist - resetting to default',mtError,[mbOK],0);
               AnalysisCode := AccsDatamodule.Accounts.AnalysisCodes.DefaultAnalysisCode;
               if (AnalysisCode <> nil) then
                  Sender.Value := AnalysisCode.Id;
               Abort;
            end;
      end;
end;
    }
end.
