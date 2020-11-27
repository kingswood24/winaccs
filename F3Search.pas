unit F3Search;
               
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons, ExtCtrls, checklst, Mask;

type
  TF3SearchForm = class(TForm)
    Panel3: TPanel;
    Exit: TBitBtn;
    Help: TBitBtn;
    DateLabel: TLabel;
    ReferenceLabel: TLabel;
    LComment: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    RefSearch: TEdit;
    CommentSearch: TEdit;
    VATSearch: TEdit;
    AmountSearch: TEdit;
    DescSearch: TEdit;
    DateSearch: TMaskEdit;
    CalenderSearch: TDateTimePicker;
    Label9: TLabel;
    ToDateSearch: TMaskEdit;
    ToCalenderSearch: TDateTimePicker;
    ChooseTypes: TCheckListBox;
    Label2: TLabel;
    SearchBtn: TBitBtn;
    LStub: TLabel;
    pCustSupp: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    SuppAccounts: TSpeedButton;
    CustAccounts: TSpeedButton;
    CustSearch: TEdit;
    SuppSearch: TEdit;
    Label1: TLabel;
    TxNo: TMaskEdit;
    procedure FormActivate(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure CommentSearchExit(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure CustAccountsClick(Sender: TObject);
    procedure SuppAccountsClick(Sender: TObject);
    procedure RefSearchExit(Sender: TObject);
    procedure CustSearchEnter(Sender: TObject);
    procedure SuppSearchEnter(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure VATSearchExit(Sender: TObject);
    procedure CustSearchExit(Sender: TObject);
    procedure DescSearchExit(Sender: TObject);
    procedure DescSearchEnter(Sender: TObject);
    procedure CheckForOther(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure DateSearchExit(Sender: TObject);
    procedure CalenderSearchDropDown(Sender: TObject);
    procedure CalenderSearchCloseUp(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure ToDateSearchExit(Sender: TObject);
    procedure ToCalenderSearchCloseUp(Sender: TObject);
    procedure ToCalenderSearchDropDown(Sender: TObject);
    procedure TxNoExit(Sender: TObject);
  private
    { Private declarations }
    procedure CheckForChanges(Sender: TObject);
    procedure CheckArray;
  public
    { Public declarations }
    FormActive       : Boolean;
    MaxTypesSelected : Integer;
    Amount,
    VATAmount    : LongInt;
    TxToSearchFor,
    TxDateSearch : Integer;
    ToTxDateSearch : Integer;
    StubInt : LongInt;
    CommentStr : String;
    substr,
    Bigstr : string;
    TempStr2 : ShortString;
    CompArray : Array [0..15] Of String;
  end;

var
  F3SearchForm: TF3SearchForm;

implementation
uses
    LangUnit,
    DBGen,
    Util,
    Vars,
    Mainunit,
    pickdate,
    DBCore,
    Newlisting,
    types,
    Clears,
    Calcs;


{$R *.DFM}

procedure TF3SearchForm.FormActivate(Sender: TObject);
Begin
    FormActive := True;
    Caption := 'F3 Transaction Listing';{ + ' - ' + st;}

    If NOT Cash1.XCASHBOOK Then
       Begin
            F3SearchForm.ChooseTypes.Items.Clear; //Clears List Check Box
            ChooseTypes.Items.Add(ReadLang(15, CurrLang)); //Sales Invoice
            ChooseTypes.Items.Add(ReadLang(17, CurrLang)); //Sales Cash Sale
            ChooseTypes.Items.Add(ReadLang(16, CurrLang)); //Sales Reciept
            ChooseTypes.Items.Add(ReadLang(46, CurrLang)); //Sales Credit Note
            ChooseTypes.Items.Add(ReadLang(18, CurrLang)); //Purchase Invoice
            ChooseTypes.Items.Add(ReadLang(115,CurrLang)); //Purchase Cash Purchase
            ChooseTypes.Items.Add(ReadLang(19, CurrLang)); //Purchase Payment
            ChooseTypes.Items.Add(ReadLang(47 ,CurrLang)); //Purchase Credit Note
            ChooseTypes.Items.Add(ReadLang(152, CurrLang));//Others
            ChooseTypes.Items.Add(ReadLang(21, CurrLang)); //Cashbook Income
            ChooseTypes.Items.Add(ReadLang(22, CurrLang)); //Cashbook Expenditure
            LComment.Caption := 'Comment /';
            LStub.Caption := 'Stub Number';
            pCustSupp.Show;
        End
    Else
        Begin
            F3SearchForm.ChooseTypes.Items.Clear; //Clears List Check Box
            ChooseTypes.Items.Add(ReadLang(152, CurrLang)); //Others
            ChooseTypes.Items.Add(ReadLang(21, CurrLang)); //Cashbook Income
            ChooseTypes.Items.Add(ReadLang(22, CurrLang)); //Cashbook Expenditure
            LComment.Caption := 'Customer /';
            LStub.Caption := 'Supplier / Stub';
            pCustSupp.Hide;            
        end;
end;

procedure TF3SearchForm.ExitClick(Sender: TObject);
begin
     Close;
end;

procedure TF3SearchForm.CommentSearchExit(Sender: TObject);
begin
     TempStr2 := CommentSearch.Text;
     CheckForChanges ( Sender );
end;

procedure TF3SearchForm.CheckArray;
Var Counter : Integer;
begin
     For Counter := 0 To 15 Do
        CompArray[Counter] := '';

     MaxTypesSelected := 0;

     if ( ChooseTypes.Items.Count > 0 ) then
       For Counter := 0 To ( ChooseTypes.Items.Count - 1 ) Do
         If ChooseTypes.Checked[Counter] Then
            Begin
               CompArray[MaxTypesSelected] := ChooseTypes.Items.Strings[Counter];
               Inc ( MaxTypesSelected );
            End;
     Dec ( MaxTypesSelected );
End;

procedure TF3SearchForm.SearchBtnClick(Sender: TObject);
begin
     CheckArray;
     FMainscreen.FillGrid;
     Close;
End;

procedure TF3SearchForm.CustAccountsClick(Sender: TObject);
Var RecNo : Integer;
begin
     SuppSearch.Color := clbtnface;
     SuppSearch.Enabled := False;
     SuppAccounts.Enabled := False;
     CustSearch.text := '';
     DescSearch.text := '';
     DescSearch.Color := clbtnface;
     NewListBox.ListIt ( Sender, Customers, 'C' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        Begin
             RecNo := StrToInt(NewListBox.ListInfo.ReturnValue);
             GetAccountName ( NewListBox.ListInfo.ActiveDb, RecNo, 1);
             CustSearch.Text := Currstr;
        End;
     CheckForChanges ( Sender );
end;

procedure TF3SearchForm.SuppAccountsClick(Sender: TObject);
Var RecNo : Integer;
begin
     CustSearch.Color := clbtnface;
     CustSearch.Enabled := False;
     CustAccounts.Enabled := False;
     CustSearch.Text := '';
     DescSearch.text := '';
     DescSearch.Color := clbtnface;
     NewListBox.ListIt ( Sender, Suppliers, 'S' );
     If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
        Begin
             RecNo := StrToInt(NewListBox.ListInfo.ReturnValue);
             GetAccountName ( NewListBox.ListInfo.ActiveDb, RecNo, 1);
             SuppSearch.Text := Currstr;
        End;
     CheckForChanges ( Sender );
end;

procedure TF3SearchForm.RefSearchExit(Sender: TObject);
begin
     CheckForChanges ( Sender );
end;

procedure TF3SearchForm.CustSearchEnter(Sender: TObject);
begin
     SuppSearch.Color := clbtnface;
     SuppSearch.Enabled := False;
     SuppAccounts.Enabled := False;
     SuppSearch.text := '';
     DescSearch.text := '';
     DescSearch.Color := clbtnface;
     DescSearch.Enabled := False;
end;

procedure TF3SearchForm.SuppSearchEnter(Sender: TObject);
begin
     CustSearch.Color := clbtnface;
     CustSearch.Enabled := False;
     CustAccounts.Enabled := False;
     CustSearch.text := '';
     DescSearch.text := '';
     DescSearch.Color := clbtnface;
     DescSearch.Enabled := False;
end;

procedure TF3SearchForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//     F3SearchForm.ChooseTypes.Items.Clear; //Clears List Check Box
//     FmainScreen.F3SearchBtn.Show;
     FmainScreen.actSearchTransactions.Enabled := True;
//     FmainScreen.BClearSearch.Show;
     FmainScreen.actClearSearch.Enabled := True;
end;

procedure TF3SearchForm.FormShow(Sender: TObject);
begin
     Top := fMainScreen.Top;
     Left := fMainScreen.Left;
     Width := fMainScreen.Width;
     DescSearch.Color := clWindow;
     DescSearch.Enabled := True;
     CustSearch.Color := clWindow;
     CustSearch.Enabled := True;
     CustAccounts.Enabled := True;
     SuppSearch.Color := clWindow;
     SuppSearch.Enabled := True;
     SuppAccounts.Enabled := True;
     CalenderSearch.Date := KStrToDate ( Cash11.Default_Date );
     ToCalenderSearch.Date := KStrToDate ( Cash11.Default_Date );
     // Set Focus to the Transaction Number
     TxNo.SetFocus;
end;

procedure TF3SearchForm.VATSearchExit(Sender: TObject);
Var TempStr : ShortString;
    CallFillGrid : Boolean;
begin
     CallFillGrid := (Sender as TEdit).Modified;

     TempStr := (Sender as TEdit).Text;
     If ChangeToLong ( TempStr ) Then
        begin
           If (Sender as TEdit).Name = 'VATSearch' Then
              StrLong ( TempStr, VATAmount )
           Else
               StrLong ( TempStr, Amount );

           (Sender as TEdit).Text := TempStr;
        end
     Else
        (Sender as TEdit).SetFocus;

     If CallFillGrid Then
        Begin
           CheckArray;
           FMainscreen.FillGrid;
           (Sender as TEdit).Modified := False;
        End;
end;

procedure TF3SearchForm.CheckForChanges(Sender: TObject);
begin
     if (Sender is TEdit) Then
        begin
           if (Sender as TEdit).Modified Then
              Begin
                 CheckArray;
                 FMainscreen.FillGrid;
              End;
           (Sender as TEdit).Modified := False;
        end
     Else
          if (Sender is TMaskEdit) then
             Begin
                If (Sender as TMaskEdit).Text <> '  /  /  ' then
                   Begin
                        (Sender as TMaskEdit).Modified := True;
                        CheckArray;
                        FMainscreen.FillGrid;
                   End
                Else
                   (Sender as TMaskEdit).Modified := False;
             End;
end;

procedure TF3SearchForm.CustSearchExit(Sender: TObject);
begin
     CheckForChanges ( Sender );
     CheckForOther ( Sender );
end;

procedure TF3SearchForm.DescSearchExit(Sender: TObject);
begin
     CheckForChanges ( Sender );
     CheckForOther ( Sender );
end;

procedure TF3SearchForm.DescSearchEnter(Sender: TObject);
begin
     SuppSearch.Color := clbtnface;
     SuppSearch.Enabled := False;
     SuppAccounts.Enabled := False;
     SuppSearch.text := '';
     CustSearch.text := '';
     CustSearch.Color := clbtnface;
     CustSearch.Enabled := False;
     CustAccounts.Enabled := False;
end;

procedure TF3SearchForm.CheckForOther(Sender: TObject);
begin
     If (Sender as TEdit).Text = '' Then
        Begin
           DescSearch.Enabled := True;
           CustSearch.Enabled := True;
           SuppSearch.Enabled := True;
           SuppAccounts.Enabled := False;
           CustAccounts.Enabled := False;
           CustSearch.Color := clWindow;
           SuppSearch.Color := clWindow;
           DescSearch.Color := clWindow;
           SuppAccounts.Enabled := True;
           CustAccounts.Enabled := True;
        End;
end;

procedure TF3SearchForm.FormDeactivate(Sender: TObject);
begin
     FormActive := False;
end;

procedure TF3SearchForm.DateSearchExit(Sender: TObject);
begin
     TxDateSearch := 0;
     TxDateSearch := KDateToInt ( DateSearch.Text );
//     CheckForChanges ( Sender );
end;

procedure TF3SearchForm.CalenderSearchDropDown(Sender: TObject);
begin
     If DateSearch.Text = '  /  /  ' Then
        CalenderSearch.Date := KStrToDate ( Cash11.Default_Date )
     Else
        CalenderSearch.Date := KStrToDate (DateSearch.Text);
end;

procedure TF3SearchForm.CalenderSearchCloseUp(Sender: TObject);
begin
     DateSearch.Text := DateToStr(CalenderSearch.Date);
     DateSearch.SetFocus;     
end;

procedure TF3SearchForm.HelpClick(Sender: TObject);
begin
     Application.HelpContext(194);
end;

procedure TF3SearchForm.ToDateSearchExit(Sender: TObject);
begin
     ToTxDateSearch := 0;
     ToTxDateSearch := KDateToInt ( ToDateSearch.Text );
//     CheckForChanges ( Sender );
end;

procedure TF3SearchForm.ToCalenderSearchCloseUp(Sender: TObject);
begin
     ToDateSearch.Text := DateToStr(ToCalenderSearch.Date);
     ToDateSearch.SetFocus;
end;

procedure TF3SearchForm.ToCalenderSearchDropDown(Sender: TObject);
begin
     If ToDateSearch.Text = '  /  /  ' Then
        ToCalenderSearch.Date := KStrToDate ( Cash11.Default_Date )
     Else
        ToCalenderSearch.Date := KStrToDate ( ToDateSearch.Text );
end;

procedure TF3SearchForm.TxNoExit(Sender: TObject);
var
   TxNoStr : ShortString;
begin
    TxNoStr := TxNo.Text;
    SLIMALL(TxNoStr);
    if Numeric(TxNoStr) then
       begin
          TxToSearchFor := StrToInt(TxNoStr);
          CheckForChanges(Sender);
       end
    else
       begin
          TxToSearchFor := 0;
          TxNo.Text := '';
       end;
end;

end.
