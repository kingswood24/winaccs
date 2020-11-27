unit UBankSetup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Grids, Types;

type
  TBankSetup = class(TForm)
    ButtonPanel: TPanel;
    ExitBtn: TBitBtn;
    AddBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ChangeBtn: TBitBtn;
    SaveBtn: TBitBtn;
    DetailGrid: TStringGrid;
    Panel1: TPanel;
    Label1: TLabel;
    NominalCode: TEdit;
    Name: TEdit;
    Opening: TEdit;
    Current: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure ExitBtnClick(Sender: TObject);
    procedure Launchform(Parameter : Char);
    procedure FillBankTable;
    procedure DetailGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure AddBtnClick(Sender: TObject);
    procedure DetailGridClick(Sender: TObject);
    procedure ChangeBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure OpeningExit(Sender: TObject);
    procedure CurrentExit(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BankSetup : TBankSetup;
  SetupBank : Boolean;
  SetupVAT  : Boolean;
  Ranges : TAccRange;
  WasOpening : real;
  WasBalance : real;
  BalanceDifference : real;
  NewRecord : Boolean;

implementation

{$R *.DFM}

uses
 vars,
 AccsData,
 Calcs,
 DBCore,
 clears,
 UTIL;

procedure TBankSetup.Launchform(Parameter : Char);
begin
    // B - Bank Setup
    // V - VAT Control Acoount Setup

        SetupBank := False;
        SetupVAT := False;

        ChangeBtn.Enabled := False;
        AddBtn.Enabled := False;
        SaveBtn.Enabled := False;
        CancelBtn.Enabled := False;

        if uppercase(Parameter) = 'B' then SetupBank := True;
        if uppercase(Parameter) = 'V' then SetupVAT := True;

        if SetupBank then begin
           BankSetup.Caption := 'Setup Bank Accounts';
           ChangeBtn.Enabled := True;
           AddBtn.Enabled := True;
           FillBankTable;
        end;

        If SetupVAT then begin
           BankSetup.Caption := 'Setup VAT Control Account';
           ChangeBtn.enabled := True;

        end;

        Self.Show;
end;

procedure TBankSetup.FillBankTable;
var
     CodeCount : Integer;
     i : integer;
     TableRow : integer;
     TempStr : ShortString;
begin
  //      CodeCount := Cash1.xBankMax - Cash1.xBankMin + 1;
  //      Detailgrid.RowCount := CodeCount + 1; // extra for header line
        Detailgrid.RowCount := 2;
        Detailgrid.cells[0,0] := 'Code';
        Detailgrid.cells[1,0] := 'Name';
        Detailgrid.cells[2,0] := 'Balance';
        Detailgrid.cells[3,0] := 'Opening';
        TableRow := 0;

        for i:=Cash1.xBankMin to Cash1.xBankMax do begin
             AccsDataModule.NLFileDB.Locate('NLNo',I,[]);
             if AccsDataModule.NLFileDB['Active'] = true then begin
                  TableRow := TableRow + 1;
                  if TableRow <> 1 then Detailgrid.RowCount := Detailgrid.RowCount + 1;
                  Detailgrid.cells[0,TableRow] := vartostr(I);
                  Detailgrid.cells[1,TableRow] := AccsDataModule.NLFileDB.FieldByName('Name').AsString;
             //     Detailgrid.cells[2,TableRow] := AccsDataModule.NLFileDB.FieldByName('Balance').AsString;
                  DoubleToStr((AccsDataModule.NLFileDB['Balance']*100),TempStr,'%8.2f', True, True, 8, True);
                  Detailgrid.cells[2,TableRow] := TempStr;
                  DoubleToStr((AccsDataModule.NLFileDB['BalanceST']*100),TempStr,'%8.2f', True, True, 8, True);
                  Detailgrid.cells[3,TableRow] := TempStr;
             //     Detailgrid.cells[3,TableRow] := AccsDataModule.NLFileDB.FieldByName('BalanceST').AsString;      //StYear
             end;


        end;

        DetailGridClick(self);

end;

procedure TBankSetup.ExitBtnClick(Sender: TObject);
begin
        Self.close;
end;

procedure TBankSetup.DetailGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
        s : string;
        LDelta : integer;
begin
        if ((ACol=2) or (ACol=3)) and (ARow <> 0) then
        begin
               s     := DetailGrid.Cells[ACol, ARow];
               LDelta := DetailGrid.ColWidths[ACol] - DetailGrid.Canvas.TextWidth(s);
               DetailGrid.Canvas.TextRect(Rect, Rect.Left+LDelta, Rect.Top+2, s);
        end
           else
                DetailGrid.Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2, DetailGrid.Cells[ACol, ARow]);
end;

procedure TBankSetup.AddBtnClick(Sender: TObject);
var
        NewAccNo : Integer;
        i : integer;
begin
        Ranges[1] := Cash1.XBANKMIN;
        Ranges[2] := Cash1.XBANKMAX;
        Ranges[3] := 0;
        Ranges[4] := 0;
        Ranges[5] := 0;
        Ranges[6] := 0;


        NewAccNo := GetNextFreeAccount ( NLFile, Ranges );

        if NewAccNo <> 0 then begin
                BlankRec ( NLFile, 'A' );
                AddRecord ( NLFile, NewAccNo, False );
                FillBankTable; // refresh the table

                for i:=1 to detailgrid.rowcount-1 do begin
                    if strtoint(DetailGrid.Cells[0,i]) = NewAccNo then DetailGrid.Row := i;

                AddBtn.enabled := False;
                SaveBtn.enabled := True;
                CancelBtn.enabled := True;
                ChangeBtn.enabled := False;

                Name.enabled := True;
                Opening.enabled := True;
                Current.enabled := True;

                NewRecord := True;

                end;

        end;
end;

procedure TBankSetup.DetailGridClick(Sender: TObject);
var
    NomCode : Integer;
    TempStr : ShortString;
begin
       If Numeric ( DetailGrid.Cells[0, DetailGrid.Row]) then begin
          NominalCode.text := vartostr(DetailGrid.Cells[0, DetailGrid.Row]);
          NomCode := StrToInt(DetailGrid.Cells[0, DetailGrid.Row]);

          WasOpening := 0;
          WasBalance := 0;
          BalanceDifference := 0;

          AccsDataModule.NLFileDB.Locate('NLNo',NomCode,[]);
          Name.text := AccsDataModule.NLFileDB.FieldByName('Name').AsString;
          DoubleToStr((AccsDataModule.NLFileDB['Balance']*100),TempStr,'%8.2f', True, True, 8, True);
          Slimall(TempStr);
          Current.text := TempStr;
          DoubleToStr((AccsDataModule.NLFileDB['BalanceST']*100),TempStr,'%8.2f', True, True, 8, True);
          Slimall(TempStr);
          Opening.text := TempStr;

          WasOpening := AccsDataModule.NLFileDB['BalanceST'];
          WasBalance := AccsDataModule.NLFileDB['Balance'];
          BalanceDifference := WasOpening - WasBalance;
   (*
          AddBtn.enabled := False;
          SaveBtn.enabled := True;
          CancelBtn.enabled := True;
          ChangeBtn.enabled := False;

          Name.enabled := True;
          Opening.enabled := True;
          Current.enabled := True;
     *)

       end
           else showmessage('Please select a Bank Account');

end;

procedure TBankSetup.ChangeBtnClick(Sender: TObject);
begin
        AddBtn.enabled := False;
        SaveBtn.enabled := True;
        CancelBtn.enabled := True;
        ChangeBtn.enabled := False;

        Name.enabled := True;
        Opening.enabled := True;
        Current.enabled := True;
end;

procedure TBankSetup.CancelBtnClick(Sender: TObject);
begin

        AddBtn.enabled := True;
        SaveBtn.enabled := False;
        CancelBtn.enabled := False;
        ChangeBtn.enabled := True;

        Name.enabled := False;
        Opening.enabled := False;
        Current.enabled := False;

        if NewRecord then begin
           //remove the new record
           AccsDataModule.NLFileDB.Locate('NLNo',StrToInt(NominalCode.text),[]);
           AccsDataModule.NLFileDB.edit;
           AccsDataModule.NLFileDB['Name'] := '';
           AccsDataModule.NLFileDB['Active'] := False;
           AccsDataModule.NLFileDB.post;
        end;

        NewRecord := False;
        
        FillBankTable;
        DetailGridClick(self); // clear any changes
end;

procedure TBankSetup.SaveBtnClick(Sender: TObject);
Var
   NomCode : Integer;
   NewBalance : Long;
   OpeningDifference : Real;
begin
        OpeningDifference := 0;

        NomCode := StrToInt(NominalCode.text);

        AccsDataModule.NLFileDB.Locate('NLNo',NomCode,[]);

        AccsDataModule.NLFileDB.edit;
        AccsDataModule.NLFileDB['Name'] := Name.text;

        StrLong (Current.Text,NewBalance);

        if pos('-',Current.Text) = 1 then NewBalance := NewBalance * -1;     // TGM AB 25/08/17

        AccsDataModule.NLFileDB['Balance'] := NewBalance/100;

        StrLong (Opening.Text,NewBalance);

        if pos('-',Opening.Text) = 1 then NewBalance := NewBalance * -1;     // TGM AB 25/08/17

        AccsDataModule.NLFileDB['STPeriod'] := NewBalance/100;
        AccsDataModule.NLFileDB['STYear'] := NewBalance/100;
        AccsDataModule.NLFileDB['BalanceST'] := NewBalance/100;

        AccsDataModule.NLFileDB.post;

        OpeningDifference := WasOpening - (NewBalance/100);

        NomCode := Cash1.XNomOpen;
        AccsDataModule.NLFileDB.Locate('NLNo',NomCode,[]);
        AccsDataModule.NLFileDB.edit;
        AccsDataModule.NLFileDB['STPeriod'] := AccsDataModule.NLFileDB['STPeriod'] + OpeningDifference;
        AccsDataModule.NLFileDB['STYear'] := AccsDataModule.NLFileDB['STYear'] + OpeningDifference;
        AccsDataModule.NLFileDB['BalanceST'] := AccsDataModule.NLFileDB['BalanceST'] + OpeningDifference;
        AccsDataModule.NLFileDB['Balance'] := AccsDataModule.NLFileDB['Balance'] + OpeningDifference;
        AccsDataModule.NLFileDB.post;

        (*
    //                          CheckAccType ( SetUpAccounts.RecNo, NewBalance );
    //                  CheckAccType ( SetUpAccounts.RecNo, WasBalance );
                      SetUpAccounts.LogNom ( SetUpAccounts.cDb, SetUpAccounts.RecNo,
                             Cash1.XNomOpen, 0-WasBalance );
                      SetUpAccounts.LogNom ( SetUpAccounts.cDb, SetUpAccounts.RecNo,
                             Cash1.XNomOpen, NewBalance );
        *)

        FillBankTable; // refresh the table

        AddBtn.enabled := True;
        SaveBtn.enabled := False;
        CancelBtn.enabled := False;
        ChangeBtn.enabled := True;

        Name.enabled := False;
        Opening.enabled := False;
        Current.enabled := False;
end;

procedure TBankSetup.OpeningExit(Sender: TObject);
var
        NewValue : Real;
        NewCurrent : real;
        TempStr : ShortString;
begin

        if pos('-',Opening.text) = length(Opening.text) then Opening.text := '-' + copy(Opening.text,0,length(Opening.text)-1);   // TGM AB 25/08/17

        Try NewValue := StrToFloat(Opening.text);
            NewCurrent := NewValue - BalanceDifference;
            DoubleToStr((NewCurrent*100),TempStr,'%8.2f', True, True, 8, True);
            Slimall(TempStr);
            Current.text := TempStr;
            DoubleToStr((NewValue*100),TempStr,'%8.2f', True, True, 8, True);
            Slimall(TempStr);
            Opening.text := TempStr;

        except Opening.SetFocus;
        end;
end;

procedure TBankSetup.CurrentExit(Sender: TObject);
var
        NewValue : Real;
        NewOpening : real;
        TempStr : ShortString;
begin
        if pos('-',Current.text) = length(Current.text) then Current.text := '-' + copy(Current.text,0,length(Current.text)-1);   // TGM AB 25/08/17

        Try NewValue := StrToFloat(Current.text);
            NewOpening := NewValue + BalanceDifference;
            DoubleToStr((NewValue*100),TempStr,'%8.2f', True, True, 8, True);
            Slimall(TempStr);
            Current.text := TempStr;
            DoubleToStr((NewOpening*100),TempStr,'%8.2f', True, True, 8, True);
            Slimall(TempStr);
            Opening.text := TempStr;

        except Current.SetFocus;
        end;
end;

end.
