unit JobCardReportSetup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, Mask, NewClass;

type
  TJobCardReportSetupForm = class(TKingForm)
    Panel1: TPanel;
    Run: TBitBtn;
    Exitbtn: TBitBtn;
    ReportTypeSelection: TRadioGroup;
    GroupBox1: TGroupBox;
    AccFromLabel: TLabel;
    Label5: TLabel;
    DateFrom: TMaskEdit;
    AccFrom: TEdit;
    CustAccounts: TSpeedButton;
    DateSearchFrom: TDateTimePicker;
    AccToLabel: TLabel;
    Label6: TLabel;
    DateTo: TMaskEdit;
    AccTo: TEdit;
    SpeedButton1: TSpeedButton;
    DateSearchTo: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    SortByGroup: TRadioGroup;
    procedure ExitbtnClick(Sender: TObject);
    procedure CustAccountsClick(Sender: TObject);
    procedure DateSearchFromCloseUp(Sender: TObject);
    procedure DateSearchToCloseUp(Sender: TObject);
    procedure ReportTypeSelectionClick(Sender: TObject);
    procedure AccFromExit(Sender: TObject);
    procedure AccFromDblClick(Sender: TObject);
    procedure AccFromKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AccToExit(Sender: TObject);
    procedure AccToDblClick(Sender: TObject);
    procedure AccToKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure RunClick(Sender: TObject);
    procedure ProcessRecords;
    procedure DateToExit(Sender: TObject);
    procedure DateFromExit(Sender: TObject);
  private
    { Private declarations }
    procedure FocusTheControl(AControl: TWinControl);
  public
    { Public declarations }
    procedure LoadForm(ReportType : Char);
    class function DumpReportData(const AReportType: Char = 'J') : Boolean;
  end;

var
  JobCardReportSetupForm: TJobCardReportSetupForm;
  ReportAmount, ReportVATAmount, ReportTotalAmount : real;

implementation

uses
   DBCore,
   Types,
   VARS,
   Clears,
   NewListing,
   Calcs,
   NewRepUnit,
   DBGen,
   JobCardReports,
   AccsData,
   Params;

{$R *.DFM}


procedure TJobCardReportSetupForm.LoadForm(ReportType : Char);
begin

     Case ReportType of

     'J' : begin
           JobCardReportSetupForm.Caption := 'Job Card Report';
           ReportTypeSelection.ItemIndex := 0;
           end;

     'P' : begin
           JobCardReportSetupForm.Caption := 'Proforma Report';
           ReportTypeSelection.ItemIndex := 1;
           end;

     'Q' : begin
           JobCardReportSetupForm.Caption := 'Quotation Report';
           ReportTypeSelection.ItemIndex := 2;
           end;

     end;

     // set-up customer boxes
     SetDb ( SLFile );
     AccFrom.Text := '1';
     AccTo.Text   := IntToStr ( db1.dbrechigh );

     DateSearchFrom.Date := StrToDate (Cash11.Default_Date);
     DateSearchTo.Date := StrToDate (Cash11.Default_Date);
     DateTo.Text := '  /  /  ';
     DateFrom.Text := '  /  /  ';

     
     Self.showmodal;

end;

procedure TJobCardReportSetupForm.ExitbtnClick(Sender: TObject);
begin
        self.Close;
end;

procedure TJobCardReportSetupForm.CustAccountsClick(Sender: TObject);
begin
        NewListBox.ListIt ( Sender, Customers, 'C' );
        If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then AccFrom.Text := NewListBox.ListInfo.ReturnValue;
        FocusTheControl(AccFrom);

end;

procedure TJobCardReportSetupForm.DateSearchFromCloseUp(Sender: TObject);
begin
           DateFrom.Text:= DateToStr(DateSearchFrom.Date);
           FocusTheControl(DateFrom);
end;

procedure TJobCardReportSetupForm.DateSearchToCloseUp(Sender: TObject);
begin
           DateTo.Text:= DateToStr(DateSearchTo.Date);
           FocusTheControl(DateTo);
end;



procedure TJobCardReportSetupForm.ReportTypeSelectionClick(
  Sender: TObject);
begin
     Case ReportTypeSelection.itemindex of

     0 : begin
           JobCardReportSetupForm.Caption := 'Job Card Report';
           end;

     1 : begin
           JobCardReportSetupForm.Caption := 'Proforma Report';
           end;

     2 : begin
           JobCardReportSetupForm.Caption := 'Quotation Report';
           end;

     end;
end;

procedure TJobCardReportSetupForm.AccFromExit(Sender: TObject);
Var
   TempStr : ShortString;
   AccNo : integer;
begin
     TempStr := AccFrom.Text;
     SlimAll(TempStr);
     SetDB(SLFile);   //TGM AB 05/06/15
     try AccNo := StrToInt(Tempstr);
         if AccNo > db1.dbrechigh then
            FocusTheControl(AccFrom);
     except
     FocusTheControl(AccFrom);
     end;


end;

procedure TJobCardReportSetupForm.AccFromDblClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Customers, 'C' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then AccFrom.Text := NewListBox.ListInfo.ReturnValue;
     FocusTheControl(AccFrom);
end;

procedure TJobCardReportSetupForm.AccFromKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
     ST : ShortString;
begin

       If Key = VK_F2 Then    { F2 Pressed }
       Begin
          NewListBox.ListIt ( Sender, Customers, 'C' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
             Begin
                 ST :=NewListBox.ListInfo.ReturnValue;
                 SlimAll ( ST );
                 AccFrom.Text := ST;
             End;
       End;

end;

procedure TJobCardReportSetupForm.AccToExit(Sender: TObject);
Var
   TempStr : ShortString;
   AccNo : Integer;
begin
     TempStr := AccTo.Text;
     SlimAll(TempStr);
     SetDB(SLFile);   //TGM AB 05/06/15
     try AccNo := StrToInt(Tempstr);
         if AccNo > db1.dbrechigh then
         FocusTheControl(AccTo);
     except
     FocusTheControl(AccTo);
     end;


end;

procedure TJobCardReportSetupForm.AccToDblClick(Sender: TObject);
begin
     NewListBox.ListIt ( Sender, Customers, 'C' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then AccTo.Text := NewListBox.ListInfo.ReturnValue;
     FocusTheControl(AccTo);
end;

procedure TJobCardReportSetupForm.AccToKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
     ST : ShortString;
begin

       If Key = VK_F2 Then    { F2 Pressed }
       Begin
          NewListBox.ListIt ( Sender, Customers, 'C' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
             Begin
                 ST :=NewListBox.ListInfo.ReturnValue;
                 SlimAll ( ST );
                 AccTo.Text := ST;
             End;
       End;
end;

procedure TJobCardReportSetupForm.SpeedButton1Click(Sender: TObject);
begin
        NewListBox.ListIt ( Sender, Customers, 'C' );
        If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then AccTo.Text := NewListBox.ListInfo.ReturnValue;
        FocusTheControl(AccTo);
end;

procedure TJobCardReportSetupForm.RunClick(Sender: TObject);
var
        TempStr : shortstring;
begin
        ProcessRecords;   // build report table

        AccsDataModule.JobCardReportDB.Open;  // display the report

        if not bool (JobCardReportForm) then Application.CreateForm(TJobCardReportForm, JobCardReportForm);

        DoubleToStr(ReportAmount*100,TempStr,'%8.2f', True, True, 8, True);
        JobCardReportForm.SummaryAmount.caption := Tempstr;
        DoubleToStr(ReportVATAmount*100,TempStr,'%8.2f', True, True, 8, True);
        JobCardReportForm.SummaryTAXAmount.caption := Tempstr;
        DoubleToStr(ReportTotalAmount*100,TempStr,'%8.2f', True, True, 8, True);
        JobCardReportForm.SummaryTotalAmount.caption := Tempstr;

        JobCardReportForm.SubHeading.Caption := RFarmGate.PLocation[2];
        JobCardReportForm.RangeLabel.caption := 'Account Range : ' + AccFrom.text + ' to ' + AccTo.text;
        if DateFrom.text <> '  /  /  ' then JobCardReportForm.RangeLabel.caption := JobCardReportForm.RangeLabel.caption + ' & Date Range : ' + DateFrom.Text + ' to ' + DateTo.Text;

        Case ReportTypeSelection.itemindex of
            0 : begin
                JobCardReportForm.BuildReport('J');
                end;

            1 : begin
                JobCardReportForm.BuildReport('P');
                end;

            2 : begin
                JobCardReportForm.BuildReport('Q');
                end;
        end;

        AccsDataModule.JobCardReportDB.Close;
end;

procedure TJobCardReportSetupForm.ProcessRecords;
var
        FirstAcc, LastAcc : Integer;
        Date_From, Date_To, Acc_From, Acc_To : String;
        Amount, VATAmount, TotalAmount : real;
        i, PreviousBatchID, Customer : integer;
        JobDate, TempDate : TDateTime;
        Ref, Descript : String;
        SQLDate_From, SQLDate_To : string;
        TempAmount, TempVATAmount : real;    // TGM AB 05/06/15

begin
         // Empty Table to remove any previous data

         AccsDataModule.JobCardReportDB.Close;
         AccsDataModule.JobCardReportDB.EmptyTable;
         Accsdatamodule.JobCardReportDB.IndexName := '';
         AccsDataModule.JobCardReportDB.open;

         // Gather Params

         FirstAcc := StrToInt(AccFrom.text);
         LastAcc := StrToInt(AccTo.text);
         Acc_From := AccFrom.text;
         Acc_To := AccTo.text;
         Date_From := DateFrom.text;
         Date_To := DateTo.text;

         if Date_From <> '  /  /  ' then begin
             try
                  TempDate := StrToDateTime(Date_From);
                  SQLDate_From := FormatDateTime('mm/dd/yyyy', TempDate); //copy(Date_From,4,2) + '/' + copy(Date_From,1,2) + '/'
                  TempDate := StrToDateTime(Date_To);
                  SQLDate_To := FormatDateTime('mm/dd/yyyy', TempDate); //copy(Date_From,4,2) + '/' + copy(Date_From,1,2) + '/'
             except
                  showmessage('Invalid or blank date entered!');
                  exit;
             end;
         end;

         // Apply SQL to table to get results

         Accsdatamodule.JobCardReportQuery.Sql.Clear;

         Case ReportTypeSelection.itemindex of
            0 : begin                                   // J
                   Accsdatamodule.JobCardReportQuery.Sql.add('Select * from Proforma');
                   Accsdatamodule.JobCardReportQuery.Sql.add('where (CustID >=' + Acc_From + ' and CustID <= ' + Acc_To + ')');
                   if Date_From <> '  /  /  ' then begin
                       Accsdatamodule.JobCardReportQuery.Sql.add('and (JobDate >="' + SQLDate_From + '" and JobDate <= "' + SQLDate_To + '")');
                   end;
                   Accsdatamodule.JobCardReportQuery.Sql.add('and batchID > 0');
                   Accsdatamodule.JobCardReportQuery.Sql.add('and complete = False');
                   Accsdatamodule.JobCardReportQuery.Sql.add('and Proforma = False');
                   Accsdatamodule.JobCardReportQuery.Sql.add('and Quote = False');
                   Accsdatamodule.JobCardReportQuery.open;
                end;

            1 : begin                                   // P
                   Accsdatamodule.JobCardReportQuery.Sql.add('Select * from Proforma');
                   Accsdatamodule.JobCardReportQuery.Sql.add('where (CustID >=' + Acc_From + ' and CustID <= ' + Acc_To + ')');
                   if Date_From <> '  /  /  ' then begin
                       Accsdatamodule.JobCardReportQuery.Sql.add('and (JobDate >="' + SQLDate_From + '" and JobDate <= "' + SQLDate_To + '")');
                   end;
                   Accsdatamodule.JobCardReportQuery.Sql.add('and batchID > 0');
                   Accsdatamodule.JobCardReportQuery.Sql.add('and complete = False');
                   Accsdatamodule.JobCardReportQuery.Sql.add('and Proforma = True');
                   Accsdatamodule.JobCardReportQuery.Sql.add('and Quote = False');
                   Accsdatamodule.JobCardReportQuery.open;
                end;

            2 : begin                                   // Q
                   Accsdatamodule.JobCardReportQuery.Sql.add('Select * from Proforma');
                   Accsdatamodule.JobCardReportQuery.Sql.add('where (CustID >=' + Acc_From + ' and CustID <= ' + Acc_To + ')');
                   if Date_From <> '  /  /  ' then begin
                       Accsdatamodule.JobCardReportQuery.Sql.add('and (JobDate >="' + SQLDate_From + '" and JobDate <= "' + SQLDate_To + '")');
                   end;
                   Accsdatamodule.JobCardReportQuery.Sql.add('and batchID > 0');
                   Accsdatamodule.JobCardReportQuery.Sql.add('and complete = False');
                   Accsdatamodule.JobCardReportQuery.Sql.add('and Proforma = False');
                   Accsdatamodule.JobCardReportQuery.Sql.add('and Quote = True');
                   Accsdatamodule.JobCardReportQuery.open;
                end;
         end;

         // Gather together transaction details and copy into report table

         Accsdatamodule.JobCardReportQuery.First;
         PreviousBatchID := 0;
         Amount := 0;
         VATAmount := 0;
         TotalAmount := 0;
         ReportAmount := 0;
         ReportVATAmount := 0;
         ReportTotalAmount := 0;

         for i := 1 to Accsdatamodule.JobCardReportQuery.RecordCount do
         try

            if Accsdatamodule.JobCardReportQuery['BatchID'] <> PreviousBatchID then begin
                 if PreviousBatchID <> 0 then begin
                     // write out previous transaction into report table
                     AccsDataModule.JobCardReportDB.append;
                     AccsDataModule.JobCardReportDB['Customer'] := Customer;

                     // Locate and enter customer name
                     AccsDataModule.SLFileDB.locate('SLNO', Customer,[]);
                     AccsDataModule.JobCardReportDB['CName'] := AccsDataModule.SLFileDB['Name'];

                     AccsDataModule.JobCardReportDB['JDate'] := JobDate;
                     AccsDataModule.JobCardReportDB['Reference'] := Ref;
                     AccsDataModule.JobCardReportDB['Comment'] := Descript;
                     AccsDataModule.JobCardReportDB['Amount'] := Amount;
                     AccsDataModule.JobCardReportDB['VATAmount'] := VATAmount;
                     TotalAmount := Amount + VATAmount;                               // TGM AB 05/06/15
                     AccsDataModule.JobCardReportDB['TotalAmount'] := TotalAmount;
                     AccsDataModule.JobCardReportDB.post;
                     ReportAmount := ReportAmount + Amount ;
                     ReportVATAmount := ReportVATAmount + VATAmount;
                     ReportTotalAmount := ReportTotalAmount + TotalAmount;
                     VATAmount := 0;                                            // TGM AB 05/06/15
                     Amount := 0;                                               // TGM AB 05/06/15
                     TotalAmount := 0;                                          // TGM AB 05/06/15

                 end;

                 PreviousBatchID := Accsdatamodule.JobCardReportQuery['BatchID'];
                 Customer :=  Accsdatamodule.JobCardReportQuery['CustID'];
                 JobDate := Accsdatamodule.JobCardReportQuery['JobDate'];
                 Ref := Accsdatamodule.JobCardReportQuery['Reference'];
                 Descript := Accsdatamodule.JobCardReportQuery['Descript'];
                 try Amount := Accsdatamodule.JobCardReportQuery['Amount'];         // TGM AB 05/06/15
                 except Amount := 0;                                                // TGM AB 05/06/15
                 end;                                                               // TGM AB 05/06/15
                 try VATAmount := Accsdatamodule.JobCardReportQuery['TaxAmount'];   // TGM AB 05/06/15
                 except VATAmount := 0;                                             // TGM AB 05/06/15
                 end;                                                               // TGM AB 05/06/15
            //     TotalAmount := Amount + VATAmount;                               // TGM AB 05/06/15      moved to writing out totals to table

            end else
                  begin

                       try Amount := Amount + Accsdatamodule.JobCardReportQuery['Amount'];             // TGM AB 05/06/15
                       except                                                                          // TGM AB 05/06/15
                       end;                                                                            // TGM AB 05/06/15
                       try VATAmount := VATAmount + Accsdatamodule.JobCardReportQuery['TaxAmount'];    // TGM AB 05/06/15
                       except                                                                          // TGM AB 05/06/15
                       end;                                                                            // TGM AB 05/06/15
                 //      TotalAmount := TotalAmount + Amount + VATAmount;                              // TGM AB 05/06/15       moved to writing out totals to table

                  end;

            if ((i = Accsdatamodule.JobCardReportQuery.recordcount) and (Accsdatamodule.JobCardReportQuery.recordcount <> 0)) then begin
                     // write out last record
                     AccsDataModule.JobCardReportDB.append;
                     AccsDataModule.JobCardReportDB['Customer'] := Customer;

                     // Locate and enter customer name
                     AccsDataModule.SLFileDB.locate('SLNO', Customer,[]);
                     AccsDataModule.JobCardReportDB['CName'] := AccsDataModule.SLFileDB['Name'];

                     AccsDataModule.JobCardReportDB['JDate'] := JobDate;
                     AccsDataModule.JobCardReportDB['Reference'] := Ref;
                     AccsDataModule.JobCardReportDB['Comment'] := Descript;
                     AccsDataModule.JobCardReportDB['Amount'] := Amount;
                     AccsDataModule.JobCardReportDB['VATAmount'] := VATAmount;
                     TotalAmount := Amount + VATAmount;                               // TGM AB 05/06/15
                     AccsDataModule.JobCardReportDB['TotalAmount'] := TotalAmount;
                     AccsDataModule.JobCardReportDB.post;
                     ReportAmount := ReportAmount + Amount ;
                     ReportVATAmount := ReportVATAmount + VATAmount;
                     ReportTotalAmount := ReportTotalAmount + TotalAmount;
                     VATAmount := 0;                                            // TGM AB 05/06/15
                     Amount := 0;                                               // TGM AB 05/06/15
                     TotalAmount := 0;                                          // TGM AB 05/06/15
            end;

            Accsdatamodule.JobCardReportQuery.next;

         except
            on e : Exception do
               ShowMessage(e.Message);
         end; // for i :=


         AccsDataModule.JobCardReportDB.Close;


         if SortByGroup.ItemIndex > 0 then begin

            if SortByGroup.ItemIndex = 1 then begin
                Accsdatamodule.JobCardReportQuery.sql.clear;
                Accsdatamodule.JobCardReportQuery.sql.Add('CREATE INDEX ByCustomer ON JobCardReportTable (Customer)');
                Accsdatamodule.JobCardReportQuery.ExecSQL;
                Accsdatamodule.JobCardReportDB.IndexName := 'ByCustomer';
            end;

            if SortByGroup.ItemIndex = 2 then begin
                Accsdatamodule.JobCardReportQuery.sql.clear;
                Accsdatamodule.JobCardReportQuery.sql.Add('CREATE INDEX ByDate ON JobCardReportTable (JDate)');
                Accsdatamodule.JobCardReportQuery.ExecSQL;
                Accsdatamodule.JobCardReportDB.IndexName := 'ByDate';
            end;

         end;


         Accsdatamodule.JobCardReportQuery.close;
         Accsdatamodule.JobCardReportDB.open;

end;

procedure TJobCardReportSetupForm.DateToExit(Sender: TObject);
begin
         if DateTo.text <> '  /  /  ' then KDateValid ( Sender );
end;

procedure TJobCardReportSetupForm.DateFromExit(Sender: TObject);
begin
         if DateFrom.text <> '  /  /  ' then KDateValid ( Sender );
end;

class function TJobCardReportSetupForm.DumpReportData(const AReportType: Char = 'J') : Boolean;
var
   TempStr: shortstring;
begin
   Result := False;

   Application.CreateForm(TJobCardReportSetupForm, JobCardReportSetupForm);
   with JobCardReportSetupForm do
   try
     try
     case AReportType of
     'J' : ReportTypeSelection.ItemIndex := 0;
     'P' : ReportTypeSelection.ItemIndex := 1;
     'Q' : ReportTypeSelection.ItemIndex := 2
     else
        Exit;
     end;

     // set-up customer boxes
     SetDb ( SLFile );
     AccFrom.Text := '1';
     AccTo.Text   := '99999'; //IntToStr ( db1.dbrechigh );

     DateSearchFrom.Date := StrToDate (Cash11.Default_Date);
     DateSearchTo.Date := StrToDate (Cash11.Default_Date);
     DateTo.Text := '  /  /  ';
     DateFrom.Text := '  /  /  ';

     AccsDataModule.SLFileDB.Open;

     ProcessRecords;   // build report table

     AccsDataModule.JobCardReportDB.Open;  // display the report
     Result := True;

     except
        on e: exception do
           begin
             // Log the error
             TempStr := e.Message;

           end;
     end;
   finally
      AccsDataModule.JobCardReportDB.Close;
      AccsDataModule.SLFileDB.Close;
      FreeAndNil(JobCardReportSetupForm);
   end;
end;

procedure TJobCardReportSetupForm.FocusTheControl(AControl: TWinControl);
begin
   try
      AControl.SetFocus();
   except
   end;
end;

end.
