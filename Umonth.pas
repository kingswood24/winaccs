unit Umonth;

interface
      
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, Gauges, ComCtrls;

type
  TMonthEndForm = class(TForm)
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    ThisMonthNo: TEdit;
    NextMonthNo: TEdit;
    CopyToBudgets: TCheckBox;
    StandardExitPanel: TPanel;
    Help: TBitBtn;
    ExitButton: TBitBtn;
    RunButton: TBitBtn;
    MonthBanksGrid: TStringGrid;
    KeepTransPanel: TPanel;
    RetainTxPanel: TPanel;
    RetainBanksCheck: TCheckBox;
    MonthBar: TGauge;
    MonthBarLabel: TLabel;
    MonthStatusBar: TStatusBar;
    CheckPrinted: TCheckBox;
    CheckBacked: TCheckBox;
    Month: TLabel;
    procedure ExitButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RunButtonClick(Sender: TObject);
    procedure RetainBanksCheckClick(Sender: TObject);
    procedure MonthBanksGridDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CheckBackedClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure NextMonthNoChange(Sender: TObject);
  private
    procedure CheckFlags ( Sender : TObject );
    { Private declarations }
  public
    { Public declarations }

  end;

var
  MonthEndForm: TMonthEndForm;
  MonthStr : ShortString;
  MonthNo : Integer;

implementation
Uses
    PYEnd,
    Uyearend,
    Clears,
    Calcs,
    UTIL,
    DBCore,
    types,
    MainUnit,
    Vars;


{$R *.DFM}

procedure MonthNames (Sender : TObject);
begin
     MonthStr := '';

     If monthno = 1 Then
        MonthStr := 'January'
     Else
         If monthno = 2 Then
            MonthStr := 'February'
     Else
         If monthno = 3 Then
            MonthStr := 'March'
     Else
         If monthno = 4 Then
            MonthStr := 'April'
     Else
         If monthno = 5 Then
            MonthStr := 'May'
     Else
         If monthno = 6 Then
            MonthStr := 'June'
     Else
         If monthno = 7 Then
            MonthStr := 'July'
     Else
         If monthno = 8 Then
            MonthStr := 'August'
     Else
         If monthno = 9 Then
            MonthStr := 'September'
     Else
         If monthno = 10 Then
            MonthStr := 'October'
     Else
         If monthno = 11 Then
            MonthStr := 'November'
     Else
         If monthno = 12 Then
            MonthStr := 'December'
     Else
         Begin
              If Sender is TEdit Then
                 Begin
                      (Sender as TEdit).Text := '';
                      (Sender as TEdit).SetFocus;
                 End;
         End;
end;

procedure TMonthEndForm.ExitButtonClick(Sender: TObject);
begin
     Close;
end;

Procedure FillGridBanks;
Var
   GridRow,
   RecCount : Integer;
Begin
   SetDb ( NlFile );
   GridRow := 2;
   For RecCount := Cash1.xBankMin To Cash1.xBankMax Do
      Begin
         ReadRec ( NlFile, RecCount );
         DbErr;
         If RecActive ( NlFile ) Then
            Begin
               MonthEndForm.MonthBanksGrid.Cells[0,GridRow] := IntToStr ( RecCount );
               GetItem ( NlFile, 1 );
               MonthEndForm.MonthBanksGrid.Cells[1,GridRow] := CurrStr;
               MonthEndForm.MonthBanksGrid.Cells[2,GridRow] := 'Yes';
               Inc ( GridRow );
            End;
      End;
   MonthEndForm.MonthBanksGrid.RowCount := GridRow;
End;

procedure TMonthEndForm.FormShow(Sender: TObject);
Var st, st2 : Shortstring;
begin
     st := Monthname [Cash1.xmonthno];
     st2 := Inttostr(cash1.xfinyear);
     caption := 'Year End';
     st := Monthname [Cash1.xmonthno];
     st2 := Inttostr(Cash1.xfinyear);
     MonthStatusBar.Panels.Items[0].Text := 'Financial Time ';
     MonthStatusBar.Panels.Items[1].Text := 'Current Month : ' + st;
     MonthStatusBar.Panels.Items[2].Text := 'Current Year : ' + st2;
     Month.Hide;
     ThisMonthNo.Text := IntToStr ( Cash1.xMonthNo );
     NextMonthNo.Text := '';
     MonthBar.Hide;
     MonthBarLabel.Caption := '';
     MonthBarLabel.Hide;

     If Cash1.xKeepTran Then
        Begin
           KeepTransPanel.Show;
           MonthBanksGrid.Hide;
           RetainTxPanel.Hide;
        End
     Else
        Begin
           KeepTransPanel.Hide;
           MonthBanksGrid.Hide;
           RetainTxPanel.Show;
        End;
     MonthEndForm.MonthBanksGrid.Cells[0,0] := 'Code';
     MonthEndForm.MonthBanksGrid.Cells[1,0] := 'Name';
     MonthEndForm.MonthBanksGrid.Cells[2,0] := 'Retain';
     MonthEndForm.MonthBanksGrid.Cells[2,1] := 'Unpresented';

     CopyToBudgets.Checked := Cash1.xCopyBal;
end;

procedure TMonthEndForm.RunButtonClick(Sender: TObject);
Var
   MonthInt : Integer;
   MonthString : ShortString;
   Proceed : boolean;
begin
     Proceed := True;
     If Not(CheckBacked.Checked) OR Not(CheckPrinted.Checked) or (NextMonthNo.Text = '') Then
        Begin
             MessageDlg('You Must Back-Up and Print Your Data To Proceed.',
             mtInformation, [mbOK], 0);
             ModalResult := mrNone;
             Proceed := False;
             CheckBacked.SetFocus;
        End;

     MonthInt := StrToInt(MonthEndForm.NextMonthNo.Text);
     MonthString := MonthEndForm.NextMonthNo.Text;
     SlimAll (MonthString);
     if Numeric (MonthString) Then
        Begin
             MonthInt := StrToInt(MonthString);
             If (Cash1.XMONTHNO = MonthInt) or Not(MonthInt in [1..12]) Then
                Begin
                     MessageDlg('New Period Number Must Be Different From Last Period Number',
                     mtInformation, [mbOK], 0);
                     Proceed := False;
                     MonthEndForm.NextMonthNo.SetFocus;
                End;
        End
     Else if (NextMonthNo.Text = '') or Not Numeric (MonthString) Then
        Begin
             MessageDlg('Please Enter A New Calender Period Number',
                     mtInformation, [mbOK], 0);
             Proceed := False;
             MonthEndForm.NextMonthNo.SetFocus;
        End;

     If (CheckBacked.Checked) And (CheckPrinted.Checked) And (Proceed = True) Then
        Begin
             MonthBar.Show;
             MonthBarLabel.Show;
             Help.Enabled := False;
             RunButton.Enabled := False;
             ExitButton.Enabled := False;
             PROG := EndMonth;
             EndPeriod;
             MonthBar.Hide;
             MonthBarLabel.Hide;
             Help.Enabled := True;
             RunButton.Enabled := True;
             ExitButton.Enabled := True;
             MessageDlg('Period End Complete', mtInformation, [mbOK], 0);
             FMainscreen.LoadTransactionGrid;
             Close;
        End;
end;

procedure TMonthEndForm.RetainBanksCheckClick(Sender: TObject);
begin
     If NOT RetainBanksCheck.Checked Then
        Begin
           FillGridBanks;
           MonthBanksGrid.Show;
        End
     Else
        MonthBanksGrid.Hide;
end;

procedure TMonthEndForm.MonthBanksGridDblClick(Sender: TObject);
begin
     If MonthBanksGrid.Cells[2,MonthBanksGrid.Row] = 'Yes' Then
        MonthBanksGrid.Cells[2,MonthBanksGrid.Row] := 'No'
     Else
         MonthBanksGrid.Cells[2,MonthBanksGrid.Row] := 'Yes';
end;

procedure TMonthEndForm.FormCreate(Sender: TObject);
Begin
     NextMonthNo.Text := '';
end;

procedure TMonthEndForm.FormActivate(Sender: TObject);
begin
     caption := 'Period End';{ + ' - ' + st;}
     CheckBacked.Checked := False;
     CheckPrinted.Checked := False;
     RunButton.Enabled := False;
     NextMonthNo.SetFocus;
end;

procedure TMonthEndForm.CheckFlags ( Sender : TObject );
begin
     RunButton.Enabled := (( CheckBacked.Checked ) And ( CheckPrinted.Checked ));

end;

procedure TMonthEndForm.CheckBackedClick(Sender: TObject);
begin
     CheckFlags ( Sender );
end;

procedure TMonthEndForm.HelpClick(Sender: TObject);
begin
     Application.HelpContext(209);
end;

procedure TMonthEndForm.NextMonthNoChange(Sender: TObject);
begin
     If Numeric (NextMonthNo.Text) Then
        Begin
             Monthno := StrToInt(NextmonthNo.Text);
             MonthNames(Sender);
             Month.Caption := MonthStr;
             Month.Show;
             Month.refresh;
        End;
end;

end.

