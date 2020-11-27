unit uChequeJournal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uBaseForm, dxBar, ActnList, dxBarExtItems, cxControls, dxStatusBar, Db,
  DBTables, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid;

type
  TfmChequeJournal = class(TBaseForm)
    beBankAccount: TdxBarEdit;
    actGenerateBankJournal: TAction;
    bbGenerateBankJournal: TdxBarButton;
    bbGenerateNonBankJournal: TdxBarButton;
    actGenerateNonBankJournal: TAction;
    bbSelectBankAccount: TdxBarButton;
    actSelectBankAccount: TAction;
    ChequeJournalGridDBTableView: TcxGridDBTableView;
    ChequeJournalGridLevel: TcxGridLevel;
    ChequeJournalGrid: TcxGrid;
    ChequeJournalDB: TTable;
    ChequeJournal: TDataSource;
    SaveDialog1: TSaveDialog;
    procedure FormDestroy(Sender: TObject);
    procedure actGenerateBankJournalExecute(Sender: TObject);
    procedure actGenerateNonBankJournalExecute(Sender: TObject);
    procedure actSelectBankAccountExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
  private
    { Private declarations }
    BankAccountNumber : integer;
    procedure GenerateBankJournal;
    procedure GenerateNonBankJournal;
    procedure GetTotals(Bank : Boolean);

  public
    { Public declarations }
    class procedure ShowChequeJournal;
  end;

var
  fmChequeJournal: TfmChequeJournal;

implementation

uses AccsData, dataexport, types, vars, NewListing, DBGen;

{$R *.DFM}

{ TfmChequeJournal }

class procedure TfmChequeJournal.ShowChequeJournal;
begin
   with TfmChequeJournal.Create(nil) do
      try
         ShowModal;
      finally
         Free;
      end;
end;

procedure TfmChequeJournal.FormDestroy(Sender: TObject);
begin
  inherited;
  Accsdatamodule.TransQuery.Active := false;

end;

procedure TfmChequeJournal.GenerateBankJournal;
var
   i : Integer;
   tempstring : string;
   TransType, fieldcode : string;
   tempreal : real;
   DebitAC, CreditAC : integer;
   ColumnNo : integer;
begin

    actExport.Enabled := True;

    if not (bankaccountnumber > 0) then begin
        showmessage('Please Select A Bank Account');
        exit;
    end;

    ChequeJournalGrid.Visible := False;

    Dataexport.ProcessTransFile(self);

    // Transquery with Journals

    // SELECT * from trans where account = '0' and txtype = '9' or bankrec is not null and txtype <> '0'
    // order by ID

    // Account 0, txtype 9 is a journal

    try Accsdatamodule.TransQuery.close;
    except
    end;
    Accsdatamodule.TransQuery.ExecSQL;
    Accsdatamodule.TransQuery.active := true;

    Accsdatamodule.GetAllNominalLedgerAccs;
    AccsDataModule.NominalList.filter := 'Account <= ' + vartostr(Cash1.XNOMPRVEXP + cash11.xno_of_partners) + ' or Account = ' + vartostr(cash1.xnomtax);
    AccsDatamodule.NominalList.filtered := true;
    AccsDataModule.NominalList.First;

    with ChequeJournalDB do
           begin
           Close;
           FieldDefs.Clear;
           IndexDefs.Clear;
           TableName := 'ChequeJournalTable';
           with FieldDefs do
              begin
               //  Add('ID',ftAutoInc,0,FALSE);
                 Add('StubNumber',ftString,8,FALSE);
                 Add('Amount',ftFloat,0,FALSE);
                 Add('TransType',ftstring,8,FALSE);

                 for i:= 1 to AccsDataModule.NominalList.RecordCount do begin
                     if AccsDataModule.NominalList['Account'] <> bankaccountnumber then begin
                        tempstring := vartostr(AccsDataModule.NominalList['Account']);
                        Add(tempstring,ftFloat,0,FALSE);
                     end;
                     AccsDataModule.NominalList.Next;
                 end;
              end;
           CreateTable;
           open;
       end;

    ChequeJournalGridDBTableView.DataController.CreateAllItems; 
    ChequeJournalGridDBTableView.Columns[2].Caption := 'Type';
    ColumnNo := 3;
    AccsDataModule.NominalList.first;
    for i:= 1 to AccsDataModule.NominalList.RecordCount do begin
                     if AccsDataModule.NominalList['Account'] <> bankaccountnumber then begin
                        tempstring := vartostr(AccsDataModule.NominalList['Account']) + ' - ' + vartostr(AccsDataModule.NominalList['Name']);
                        ChequeJournalGridDBTableView.Columns[ColumnNo].Caption := tempstring;
                        Inc(ColumnNo);
                     end;
                     AccsDataModule.NominalList.Next;
                 end;

    AccsDatamodule.NominalList.filtered := false;
    AccsDatamodule.NominalList.filter := '';

    AccsDatamodule.TransQuery.First;
    while not AccsDatamodule.TransQuery.Eof do begin
        if AccsDatamodule.TransQuery['TxType'] = 11 then begin
           ChequeJournalDB.Append;
           ChequeJournalDB['StubNumber'] := AccsDatamodule.TransQuery['StubNo'];
           AccsDatamodule.TransQuery.Next;
           While AccsDatamodule.TransQuery['TxType'] = 9 do begin
                 Fieldcode := vartostr(AccsDatamodule.TransQuery['Nominal']);
                 try tempreal := ChequeJournalDB[fieldcode];
                 except tempreal := 0;
                 end;
                 ChequeJournalDB[fieldcode] := tempreal + AccsDatamodule.TransQuery['Amount'] + AccsDatamodule.TransQuery['TaxDisc'];
                 AccsDatamodule.Transquery.Next;
           end;
           if AccsDatamodule.TransQuery['TxType'] = 12 then begin
                 if AccsDatamodule.TransQuery['Nominal'] = Bankaccountnumber then begin
                    ChequeJournalDB['Amount'] := AccsDatamodule.TransQuery['Amount'];
                    ChequeJournalDB['Transtype'] := 'Income';
                    ChequeJournalDB.post;
                 end
                     else ChequeJournalDB.cancel;
           end;
        end;     // end type 11

        if AccsDatamodule.TransQuery['TxType'] = 15 then begin
           ChequeJournalDB.Append;
           ChequeJournalDB['StubNumber'] := AccsDatamodule.TransQuery['StubNo'];
           AccsDatamodule.TransQuery.Next;
           While AccsDatamodule.TransQuery['TxType'] = 9 do begin
                 Fieldcode := vartostr(AccsDatamodule.TransQuery['Nominal']);
                 try tempreal := ChequeJournalDB[fieldcode];
                 except tempreal := 0;
                 end;
                 ChequeJournalDB[fieldcode] := tempreal - AccsDatamodule.TransQuery['Amount'] - AccsDatamodule.TransQuery['TaxDisc'];
                 AccsDatamodule.Transquery.Next;
           end;
           if AccsDatamodule.TransQuery['TxType'] = 16 then begin
                 if AccsDatamodule.TransQuery['Nominal'] = Bankaccountnumber then begin
                    ChequeJournalDB['Amount'] := -1 * AccsDatamodule.TransQuery['Amount'];
                    ChequeJournalDB['Transtype'] := 'Expend';
                    ChequeJournalDB.post;
                 end
                     else ChequeJournalDB.cancel;
           end;
        end;          // end type 15

        if AccsDatamodule.TransQuery['OrigType'] = 0 then begin
                DebitAc := AccsDatamodule.TransQuery['DebitAc'];
                CreditAc := AccsDatamodule.TransQuery['CreditAc'];
                //if ((DebitAc <> bankaccountnumber) and (CreditAc <> bankaccountnumber)) then begin

                if (((DebitAc < Cash1.xBankMin) or (DebitAc > Cash1.xBankMax)) and ((CreditAc < Cash1.xBankMin) or (CreditAc > Cash1.xBankMax))) then begin
                    // Non Bank Journal - not used here - transfered into non bank journal section
                    ChequeJournalDB.Append;
                    ChequeJournalDB['Amount'] := 0;
                    ChequeJournalDB[vartostr(DebitAc)] := AccsDatamodule.TransQuery['Amount'];
                    ChequeJournalDB[vartostr(CreditAc)] := -1 * AccsDatamodule.TransQuery['Amount'];
                    ChequeJournalDB['Transtype'] := 'Journal';
                    ChequeJournalDB.post;
                end;
                if (((DebitAc = BankAccountNumber) or (CreditAc = BankAccountNumber)) and (CreditAc >=Cash1.xBankMin) and (CreditAc <=Cash1.xBankMax) and (DebitAc >=Cash1.xBankMin) and (DebitAc <=Cash1.xBankMax)) then begin
                    // Interbank
                    ChequeJournalDB.Append;
                    ChequeJournalDB['StubNumber'] := AccsDatamodule.TransQuery['StubNo'];
                    if DebitAc = Bankaccountnumber then begin
                       ChequeJournalDB['Amount'] := AccsDatamodule.TransQuery['Amount'];
                       ChequeJournalDB[vartostr(CreditAc)] := -1 * AccsDatamodule.TransQuery['Amount'];
                       ChequeJournalDB['Transtype'] := 'Income';
                    end else begin
                        ChequeJournalDB[vartostr(DebitAc)] := AccsDatamodule.TransQuery['Amount'];
                        ChequeJournalDB['Amount'] := -1 * AccsDatamodule.TransQuery['Amount'];
                        ChequeJournalDB['Transtype'] := 'Expend';
                        end;
                       ChequeJournalDB.post;
                end else
                    if ((CreditAc = BankAccountNumber) and (CreditAc >=Cash1.xBankMin) and (CreditAc <=Cash1.xBankMax)) then begin
                       // Direct Debit & bank journals
                       ChequeJournalDB.Append;
                       ChequeJournalDB['StubNumber'] := AccsDatamodule.TransQuery['StubNo'];
                       ChequeJournalDB[vartostr(DebitAc)] := -1 * AccsDatamodule.TransQuery['Amount'];
                       ChequeJournalDB['Amount'] := -1 * AccsDatamodule.TransQuery['Amount'];
                       ChequeJournalDB['Transtype'] := 'Expend';
                       ChequeJournalDB.post;
                    end else
                        if ((DebitAc = BankAccountNumber) and (DebitAc >=Cash1.xBankMin) and (DebitAc <=Cash1.xBankMax)) then begin
                        // Direct Credit & bank journals
                        ChequeJournalDB.Append;
                        ChequeJournalDB['StubNumber'] := AccsDatamodule.TransQuery['StubNo'];
                        ChequeJournalDB[vartostr(CreditAc)] := AccsDatamodule.TransQuery['Amount'];
                        ChequeJournalDB['Amount'] := AccsDatamodule.TransQuery['Amount'];
                        ChequeJournalDB['Transtype'] := 'Income';
                        ChequeJournalDB.post;
                    end;
        end; // End Type 0

        AccsDatamodule.TransQuery.next;
    end;
    Gettotals(True);  // calculate totals
    ChequeJournalGrid.visible := true;;
end;

procedure TfmChequeJournal.GenerateNonBankJournal;
var
   i : Integer;
   tempstring : string;
   TransType, fieldcode : string;
   tempreal : real;
   DebitAC, CreditAC : integer;
   ColumnNo : integer;

begin
    actExport.Enabled := True;

    ChequeJournalGrid.visible := False;

    Dataexport.ProcessTransFile(self);

    BankAccountNumber := -1;

    beBankAccount.Text := '';

    try Accsdatamodule.JournalQuery.close;
    except
    end;
    Accsdatamodule.JournalQuery.ExecSQL;
    Accsdatamodule.JournalQuery.active := true;

    Accsdatamodule.GetAllNominalLedgerAccs;
    AccsDataModule.NominalList.filter := 'Account <= ' + vartostr(Cash1.XNOMPRVEXP + cash11.xno_of_partners); //Cash1.xBankMax);
    AccsDatamodule.NominalList.filtered := true;
    AccsDataModule.NominalList.First;

    with ChequeJournalDB do
           begin
           Close;
           FieldDefs.Clear;
           IndexDefs.Clear;
           TableName := 'ChequeJournalTable';
           with FieldDefs do
              begin
                 Add('StubNumber',ftString,8,FALSE);
                 Add('Amount',ftFloat,0,FALSE);
                 Add('TransType',ftstring,8,FALSE);

                 for i:= 1 to AccsDataModule.NominalList.RecordCount do begin
                        tempstring := vartostr(AccsDataModule.NominalList['Account']);
                        Add(tempstring,ftFloat,0,FALSE);
                        AccsDataModule.NominalList.Next;
                 end;
              end;
           CreateTable;
           open;
       end;

    ChequeJournalGridDBTableView.DataController.CreateAllItems; 
    ChequeJournalGridDBTableView.Columns[2].Caption := 'Type';
    ColumnNo := 3;
    AccsDataModule.NominalList.first;
    for i:= 1 to AccsDataModule.NominalList.RecordCount do begin
                        tempstring := vartostr(AccsDataModule.NominalList['Account']) + ' - ' + vartostr(AccsDataModule.NominalList['Name']);
                        ChequeJournalGridDBTableView.Columns[ColumnNo].Caption := tempstring;
                        Inc(ColumnNo);
                        AccsDataModule.NominalList.Next;
                 end;

    AccsDatamodule.NominalList.filtered := false;
    AccsDatamodule.NominalList.filter := '';

    AccsDatamodule.JournalQuery.First;
    while not AccsDatamodule.JournalQuery.Eof do begin
                DebitAc := AccsDatamodule.JournalQuery['DebitAc'];
                CreditAc := AccsDatamodule.JournalQuery['CreditAc'];
                if (((DebitAc < Cash1.xBankMin) or (DebitAc > Cash1.xBankMax)) and ((CreditAc < Cash1.xBankMin) or (CreditAc > Cash1.xBankMax))) then begin
                    ChequeJournalDB.Append;
                    ChequeJournalDB['Amount'] := 0;
                    ChequeJournalDB[vartostr(DebitAc)] := -1 * AccsDatamodule.JournalQuery['Amount'];
                    ChequeJournalDB[vartostr(CreditAc)] := AccsDatamodule.JournalQuery['Amount'];
                    ChequeJournalDB['Transtype'] := 'Journal';
                    ChequeJournalDB.post;
                end;


        AccsDatamodule.JournalQuery.next;
    end;
    Gettotals(False);  // calculate totals
    ChequeJournalGrid.visible := true;;
end;

procedure TfmChequeJournal.actGenerateBankJournalExecute(Sender: TObject);
begin
  inherited;
  GenerateBankJournal;
end;

procedure TfmChequeJournal.actGenerateNonBankJournalExecute(
  Sender: TObject);
begin
  inherited;
  GenerateNonBankJournal;
end;

procedure TfmChequeJournal.actSelectBankAccountExecute(Sender: TObject);
begin
  inherited;
  NewListBox.ListIt ( Sender, Banks, 'N' );
  If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then begin
     BankAccountnumber := strtoint(NewListBox.ListInfo.ReturnValue);
     beBankAccount.Text := GetAccountName ( NewListBox.ListInfo.ActiveDb, StrToInt ( NewListBox.ListInfo.ReturnValue ),1);
  end;
end;

procedure TfmChequeJournal.FormShow(Sender: TObject);
begin
  inherited;
  beBankAccount.Text := '';
  Bankaccountnumber := 0;
  actExport.Enabled := false;
  ChequeJournalGrid.visible := False;
end;

procedure TfmChequeJournal.actExportExecute(Sender: TObject);
var
   ExportFile : TextFile;
   line, tempstring : string;
   i,j : integer;

begin
        // bankaccountnumber of -1 is for non-bank journals

        if bankaccountnumber < 0 then savedialog1.FileName := lowercase(Copy(cash2.xdirectory, 0, length(cash2.xdirectory)-1)+ ' - NonBank Journals.csv')
           else savedialog1.FileName := lowercase(Copy(cash2.xdirectory, 0, length(cash2.xdirectory)-1)+ ' - Bank Acc No ' + vartostr(BankAccountNumber) + '.csv');
        if savedialog1.Execute then begin
        AssignFile(ExportFile, SaveDialog1.FileName);
        Rewrite(ExportFile);
        line := '';

        if bankaccountnumber = -1 then line := 'Non Bank Journals'
        else line := 'Cheque Journal For Bank Account - ' + beBankAccount.Text;

        Writeln(ExportFile,line);
        Line := '';
        Writeln(ExportFile,line);
        line := 'Data Exported From ' + sysname + ' ' + verno;
        Writeln(ExportFile,line);
        Line := '';
        Writeln(ExportFile,line);
        Line := '';
        Writeln(ExportFile,line);

        line := line + 'Stub Number';
        line := line + ',';
        line := line + 'Amount';
        line := line + ',';
        line := line + 'Transaction Type';
       // line := line + ',';
        Accsdatamodule.GetAllNominalLedgerAccs;
        if bankaccountnumber = -1 then AccsDataModule.NominalList.filter := 'Account <= ' + vartostr(Cash1.XNOMPRVEXP + cash11.xno_of_partners)
           else AccsDataModule.NominalList.filter := 'Account <= ' + vartostr(Cash1.XNOMPRVEXP + cash11.xno_of_partners)+ ' or Account = ' + vartostr(cash1.xnomtax);
        AccsDatamodule.NominalList.filtered := true;
        AccsDataModule.NominalList.First;

        AccsDataModule.NominalList.first;
        for i:= 1 to AccsDataModule.NominalList.RecordCount do begin
                     if AccsDataModule.NominalList['Account'] <> bankaccountnumber then begin
                        line := line + ',';
                        line := line + vartostr(AccsDataModule.NominalList['Account']) + ' - ' + vartostr(AccsDataModule.NominalList['Name']);
                     end;
                     AccsDataModule.NominalList.Next;
        end;  // for i:=

        Writeln(ExportFile,line);

        line := '';

        ChequeJournalDB.first;
        for i:= 0 to ChequeJournalDB.RecordCount -1 do begin
                line := '';
                Line := vartostr(ChequeJournalDB['Stubnumber']) + ',' + vartostr(ChequeJournalDB['Amount']) + ',' + vartostr(ChequeJournalDB['Transtype']);

                AccsDataModule.NominalList.first;
                for j:= 1 to AccsDataModule.NominalList.RecordCount do begin
                     if AccsDataModule.NominalList['Account'] <> bankaccountnumber then begin
                        tempstring := vartostr(AccsDataModule.NominalList['Account']);
                        Line := Line + ',' + vartostr(ChequeJournalDB[tempstring]);
                     end;
                     AccsDataModule.NominalList.Next;
                end;
                Writeln(ExportFile,line);
                chequeJournalDB.next;
        end; // for i:=


        Closefile(ExportFile);
        Showmessage('Cheque Journal Export Complete');
        end;
end;

procedure TfmChequeJournal.GetTotals(Bank: Boolean);
var
   TotalArray : Array [1..1000] of real;
   i,j : integer;
   NomAcc : integer;
begin
    // TGM AB
    For i:=1 to 1000 do begin
        Totalarray[i] := 0.00;
    end;

    Accsdatamodule.GetAllNominalLedgerAccs;
    if bank then AccsDataModule.NominalList.filter := 'Account <= ' + vartostr(Cash1.XNOMPRVEXP + cash11.xno_of_partners) + ' or Account = ' + vartostr(cash1.xnomtax)
       else AccsDataModule.NominalList.filter := 'Account <= ' + vartostr(Cash1.XNOMPRVEXP + cash11.xno_of_partners);
    AccsDatamodule.NominalList.filtered := true;
    AccsDataModule.NominalList.First;

    AccsDataModule.NominalList.first;
    for i:= 1 to AccsDataModule.NominalList.RecordCount do begin
         if AccsDataModule.NominalList['Account'] <> bankaccountnumber then begin
            NomAcc := AccsDataModule.NominalList['Account'];
            ChequeJournalDB.first;
            for j := 1 to ChequeJournalDB.RecordCount do begin
                if length(varToStr(ChequeJournalDB[vartostr(NomAcc)])) > 0 then Totalarray[NomAcc] := Totalarray[NomAcc] + ChequeJournalDB[VarToStr(NomAcc)];
                ChequeJournalDB.Next;
            end;
         end;
         AccsDataModule.NominalList.Next;
    end;
    ChequeJournalDB.first;
    for j := 1 to ChequeJournalDB.RecordCount do begin
                Totalarray[1000] := Totalarray[1000] + ChequeJournalDB['Amount'];
                // Bank Amount held in array 1000
                ChequeJournalDB.Next;
    end;


    ChequeJournalDB.last;
    ChequeJournalDB.append;
    ChequeJournalDB.post;
    ChequeJournalDB.append;
    ChequeJournalDB['Amount'] := TotalArray[1000];
    ChequeJournalDB['Stubnumber'] := 'Totals';

    AccsDataModule.NominalList.first;
    for i:= 1 to AccsDataModule.NominalList.RecordCount do begin
         if AccsDataModule.NominalList['Account'] <> bankaccountnumber then begin
            ChequeJournalDB[vartostr(AccsDataModule.NominalList['Account'])] := TotalArray[strtoint(vartostr(AccsDataModule.NominalList['Account']))];
         end;
         AccsDataModule.NominalList.Next;
    end;

    ChequeJournalDB.post;

    AccsDatamodule.NominalList.filtered := false;
    AccsDataModule.NominalList.filter := '';
end;

end.
