unit Vat;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, StdCtrls, Buttons, ExtCtrls, Mask;

type
  TFVat = class(TForm)
    VATGrid: TStringGrid;
    Panel1: TPanel;
    Exit: TBitBtn;
    Save: TBitBtn;
    VatDesc: TEdit;
    VatDescription: TLabel;
    Help: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure VATGridGetEditMask(Sender: TObject; ACol, ARow: Longint;
      var Value: OpenString);
    procedure VATGridSelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure VATGridSetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: String);
    procedure SaveClick(Sender: TObject);
    procedure VATGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HelpClick(Sender: TObject);
  private
    { Private declarations }
    function OKScan : Boolean;
    function DuplicatesFound : Boolean;
  public
    { Public declarations }
  end;

var
  FVat: TFVat;

implementation
Uses
    DefSecFl,
    Clears,
    DbGen,
    Types,
    LangUnit,
    vars,
    calcs;

Var
   LastCol,
   LastRow   : Integer;

{$R *.DFM}

procedure TFVat.FormActivate(Sender: TObject);
Var
   RowCount : Integer;
   VatRate  : Single;
   JOffset : Integer;
begin
     JnlRead ( 1, JOffset );
     LastCol := -1;
     LastRow := -1;

     { Set the Buttons }
     Exit.Caption := ReadLang ( 1, CurrLang );
     Save.Caption := ReadLang ( 26, CurrLang );
     { Set the Heading }
     if Cash2.XCOUNTRY = 1 then  // UK
        VatGrid.ColCount := 5
     else
        VatGrid.ColCount := 4;
     VatGrid.Cells[0, 0] := ReadLang ( 62, CurrLang );
     VatGrid.Cells[1, 0] := ReadLang ( 127, CurrLang );
     VatGrid.Cells[2, 0] := ReadLang ( 128, CurrLang );
     VatGrid.Cells[3, 0] := ReadLang ( 129, CurrLang );
     VatGrid.ColWidths[0] := 65;
     VatGrid.ColWidths[1] := 80;
     VatGrid.ColWidths[2] := 70;
     VatGrid.ColWidths[3] := 115;
     if Cash2.XCOUNTRY = 1 then  // UK
        begin
           VatGrid.Cells[4, 0] := 'Inc/Excl';
           VatGrid.ColWidths[4] := 80;
           fVat.Width := 430
        end
        else
            fVat.Width := 390;  // was 350

     VatDesc.Text := Cash1.xTaxCode;
     { Read the Vat Items into the Grid }
     For RowCount := 0 to 9 Do
         Begin
              VatGrid.Cells[0, RowCount+1] := Cash1.xTaxIds[RowCount];
              VatRate := Cash1.xTaxRates[RowCount]/100;
              VatGrid.Cells[1, RowCount+1] := Format ( '%f', [VatRate] );
              VatGrid.Cells[2, RowCount+1] := Cash2.xTaxTypes[RowCount];
              VatGrid.Cells[3, RowCount+1] := Cash11.Vat_Desc[RowCount];
//tgm              if Cash2.XCOUNTRY = 1 then // UK
                 VatGrid.Cells[4, RowCount+1] := Cash2.Vat_inc_exc[RowCount];
         End;
end;

procedure TFVat.ExitClick(Sender: TObject);
begin
     {If MessageDlg('Exit Without Saving', mtInformation,[mbOK], 0) = mrOK Then}
        Close;
end;

procedure TFVat.VATGridGetEditMask(Sender: TObject; ACol, ARow: Longint;
  var Value: OpenString);
begin
     Case ACol Of
          0 : Value := '!>A; ';
          {1 : Value := '!99.99;';}
          2 : Value := '!>A; ';
          4 : Value := '!>A; '; //tgm if Cash2.XCOUNTRY = 1 then Value := '!>A; ';
      End;
end;

Function TFVat.DuplicatesFound : Boolean;
Var
   i : Integer;
   KeepGoing   : Boolean;
   TestAgainst,
   ThingToTest : ShortString;
Begin
{-->>        DuplicatesFound := False;}
   i := 1;
   KeepGoing := False;
   ThingToTest := VatGrid.Cells[0, LastRow];
   SlimAll(ThingToTest);
   ThingToTest := UPPERCASE(ThingToTest);

   if Length(ThingToTest) > 0 then
      repeat
         { only check if youre not on the current line }
         if ( i <> LastRow ) and ( NOT KeepGoing ) then
            begin
               TestAgainst := VATGrid.Cells[0,i];
               SlimAll(TestAgainst);
               TestAgainst := UPPERCASE(TestAgainst);
               if Length(TestAgainst) > 0 then
                  if TestAgainst[1] = ThingToTest[1] then
                     KeepGoing := True;
            end;
         Inc ( i );
      until ( i > 10 ) Or KeepGoing
   else
      KeepGoing := FALSE;
   DuplicatesFound := KeepGoing;
end;

procedure TFVat.VATGridSelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
Var
   TempStr : ShortString;
   TempLong : BigLong;

begin
     case LastCol of
          0 : if ( LastCol = 0 ) And ( LastRow = 1 ) Then
                 CanSelect := ( VatGrid.Cells[LastCol, LastRow][1] = 'Z' )
              else
                  if NOT ( VatGrid.Cells[LastCol, LastRow] = '' ) Then
                     begin
                        TempStr := VatGrid.Cells[LastCol, LastRow];
                        SlimAll ( TempStr);
                        TempStr := UPPERCASE(TempStr);

                        if NOT ( TempStr[1] In ['A'..'Z','0'..'9',' '] ) then
                           begin
                              CanSelect := False;
                              MessageDLG('Invalid entry - A to Z and 0 to 9 only',mtInformation,[mbOK],0);
                           end
                        else
                           begin
                              CanSelect := ( NOT DuplicatesFound );
                              if NOT CanSelect then
                                 MessageDLG('Duplicate entry',mtInformation,[mbOK],0);
                           end;
                        {
                        if NOT ( VatGrid.Cells[LastCol, LastRow][1] In ['A'..'Z','0'..'9',' '] ) Then
                           begin
                              CanSelect := False;
                              MessageDLG('Invalid entry - A to Z and 0 to 9 only',mtInformation,[mbOK],0);
                           end
                        else
                           begin
                              CanSelect := ( NOT DuplicatesFound );
                              if NOT CanSelect then
                                 MessageDLG('Duplicate entry',mtInformation,[mbOK],0);
                           end;
                        }
                        VatGrid.Cells[LastCol, LastRow] := TempStr;
                     end
                  else VatGrid.Cells[LastCol, LastRow] := ' ';
          1 : Begin
                   { Save contents of VAT Rate }
                   TempStr := VatGrid.Cells[LastCol, LastRow];
                   If ChangeToLong ( TempStr ) Then
                      Begin
                           StrLong ( TempStr, TempLong );
                           if ( TempLong > 0 ) Then
                              CanSelect := ( VatGrid.Cells[LastCol+1, LastRow][1] In ['I','E','X']);
                           SlimAll ( TempStr );
                           VatGrid.Cells[LastCol, LastRow] := TempStr;
                           If ( Length ( TempStr ) > 5 ) Then
                              CanSelect := False;
                      End
                   Else
                       CanSelect := False;
              End;
          2 : Begin
                   { Save contents of VAT Inclusive, Exclusive or Default }
                   TempStr := VatGrid.Cells[LastCol, LastRow];
                   SlimAll ( TempStr );
                   TempStr := UPPERCASE(TempStr);
                   CanSelect := ( TempStr[1] In ['X','E','I'] );
                   if ( Length ( TempStr ) > 1 ) Or ( NOT ( TempStr[1] In ['X','E','I'] )) then
                      begin
                         MessageDLG('Invalid entry - I = Inclusive, E = Exclusive, X = Default',mtInformation,[mbOK],0);
                         CanSelect := False;
                      end
                   else
                      VatGrid.Cells[LastCol, LastRow] := TempStr;
              End;
          4 : begin
                   if Cash2.XCOUNTRY = 1 then // UK
                      begin
                         { Save contents of VAT Include or Exclude from VAT return }
                         TempStr := VatGrid.Cells[LastCol, LastRow];
                         SlimAll ( TempStr );
                         TempStr := UPPERCASE(TempStr);
                         CanSelect := ( TempStr[1] In ['E','I'] );
                         if ( Length ( TempStr ) > 1 ) Or ( NOT ( TempStr[1] In ['E','I'] )) then
                            begin
                               MessageDLG('Invalid entry - I = Include, E = Exclude on VAT return',mtInformation,[mbOK],0);
                               CanSelect := False;
                            end
                         else
                            VatGrid.Cells[LastCol, LastRow] := TempStr;
                      end;
              end;
     end;

     case Col Of
          2 : If ( VatGrid.Cells[Col, Row][1] = 'X' ) And ( Row = 1 ) Then
                 Begin
                      CanSelect := False;
                      If LastCol = 3 Then
                          VatGrid.Col := Col-1
                      Else
                          VatGrid.Col := Col+1;
                 End;
     end;
end;

procedure TFVat.VATGridSetEditText(Sender: TObject; ACol, ARow: Longint;
  const Value: String);
begin
     If LastCol <> Acol Then
        LastCol := ACol;
     If LastRow <> ARow Then
        LastRow := ARow;
end;

function TFVat.OKScan : Boolean;
var
   DupFound,
   ColOneValid,
   ColTwoValid,
   ColFourValid : Boolean;
   RowCount     : Integer;
   TempStr      : ShortString;
begin
   // Check the contents of the grid are valid to save
   Result := FALSE;
   ColOneValid   := TRUE;
   ColTwoValid   := TRUE;
   ColFourValid  := TRUE;
   for RowCount  := 1 to 10 do
      begin
          // Check the VAT Code Col
          TempStr := VATGrid.Cells[0,RowCount];
          SlimALL(TempStr);
          if ColOneValid then
             ColOneValid := ( Length(TempStr) = 1 ) Or ( Length(TempStr) = 0 );

          TempStr := VATGrid.Cells[2,RowCount];
          SlimALL(TempStr);
          if ColTwoValid then
             ColTwoValid := ( Length(TempStr) = 1 ) Or ( Length(TempStr) = 0 );

          TempStr := VATGrid.Cells[4,RowCount];
          SlimALL(TempStr);
          if Cash2.XCOUNTRY = 1 then // UK
             if ColFourValid then
                ColFourValid := ( Length(TempStr) = 1 ) Or ( Length(TempStr) = 0 );

      end;

   DupFound := DuplicatesFound;

   if ( ColOneValid ) And ( ColTwoValid ) And ( ColFourValid ) And ( NOT DupFound ) then
      Result := TRUE
   else
      begin
         if NOT ColOneValid then // VAT Code is invalid
            MessageDLG('VAT Code - Invalid',mtinformation,[mbOk],0);
         if NOT ColTwoValid then // VAT Exclusive/Inclusive is invalid
            MessageDLG('Inclusive/Exclusive VAT - Invalid',mtinformation,[mbOk],0);
         if Cash2.XCOUNTRY = 1 then // UK
            if NOT ColFourValid then
               MessageDLG('Include/Exclude in VAT Return - Invalid',mtinformation,[mbOk],0);
         if Dupfound then
            MessageDLG('Duplicate VAT Code',mtinformation,[mbOk],0);
         VATGrid.SetFocus;
      end;
end;

procedure TFVat.SaveClick(Sender: TObject);
Var
   VatRate  : Integer;
   TempStr  : ShortString;
   RowCount : Integer;
   Templong : long;
   VatRateTemp  : Single;
begin
     if OKScan then
        begin
           { Save Info back to Cashbook.def }
           TempStr := VatDesc.Text;
           SlimAll ( TempStr );
           Cash1.xTaxCode := TempStr;
           For RowCount := 0 to 9 Do
              Begin
                 if Length(VatGrid.Cells[0, RowCount+1]) > 0 then
                    Cash1.xTaxIds[RowCount] := VatGrid.Cells[0, RowCount+1][1]
                 else
                    Cash1.xTaxIds[RowCount] := ' ';

                 TempStr := VatGrid.Cells[1,rowCount+1];

                 If IsItLong ( TempStr, 'L', TempLong ) Then
                    Begin
                     LongStr ( TempLong, TempStr, 'L' );
                    End;

                 if Pos ( '.', TempStr ) > 0 then
                    Delete ( TempStr, Pos ( '.',TempStr ),1 );

                 VatRate := 0;
                 SlimAll ( TempStr );
                 if Length ( TempStr) > 0 then
                    VatRate := StrToInt ( TempStr );
                 { Multiply the VatRate if User hasn't enter 99.99 }
                 If Length ( TempStr ) = 1 Then
                    VatRate := VatRate * 100
                 Else If Length ( TempStr ) = 2 Then
                    VatRate := VatRate * 10
                 Else If Length ( TempStr ) = 3 Then
                    VatRate := VatRate * 1;
                 Cash1.xTaxRates[RowCount] := VatRate;
                 if Length(VatGrid.Cells[2, RowCount+1]) > 0 then
                    Cash2.xTaxTypes[RowCount] := VatGrid.Cells[2, RowCount+1][1]
                 else
                    Cash2.xTaxTypes[RowCount] := ' ';

                 if Cash2.XCOUNTRY = 1 then // UK
                    begin
                       if Length(VatGrid.Cells[4, RowCount+1]) > 0 then
                          Cash2.vat_inc_exc[RowCount] := VatGrid.Cells[4, RowCount+1][1]
                       else
                          Cash2.vat_inc_exc[RowCount] := ' ';
                    end;

                 TempStr := VatGrid.Cells[3, RowCount+1 ];
                 SlimAll ( TempStr );
                 If Length ( TempStr ) > ( SizeOf ( Cash11.Vat_Desc[1] )-1 ) Then
                    Delete ( TempStr,SizeOf(Cash11.Vat_Desc[1]), Length(TempStr)-(SizeOf(Cash11.Vat_Desc[1])-1))
                 Else
                    PadRight ( TempStr, SizeOf ( Cash11.Vat_Desc[RowCount] )-1 );
                 Cash11.Vat_Desc[RowCount] := '        ';
                 Move ( TempStr[1],Cash11.Vat_Desc[RowCount][1], SizeOf ( Cash11.Vat_Desc[RowCount] )-1 );
              End;
           { Save the Info in Cashbook.Def File }
           DefWrite ( 0 );
           DefWrite ( 1 );
           DefWrite ( 11 );

                { Read the Vat Items into the Grid }
           For RowCount := 0 to 9 Do
           Begin
              VatGrid.Cells[0, RowCount+1] := Cash1.xTaxIds[RowCount];
              VatRateTemp := Cash1.xTaxRates[RowCount]/100;
              VatGrid.Cells[1, RowCount+1] := Format ( '%f', [VatRateTemp] );
              VatGrid.Cells[2, RowCount+1] := Cash2.xTaxTypes[RowCount];
              VatGrid.Cells[3, RowCount+1] := Cash11.Vat_Desc[RowCount];
              VatGrid.Cells[4, RowCount+1] := Cash2.Vat_inc_exc[RowCount];
            End;

        end;
end;

procedure TFVat.VATGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Key = VK_F1 then
       Begin
            Case VATGrid.Col Of
                 0 : begin
                          Application.HelpContext(12);           {VAT Code}
                     end;
                 1 : begin
                          Application.HelpContext(138);          {VAT Rate}
                     end;
                 2 : begin
                          Application.HelpContext(139);           {VAT Description}
                     end;
                 3 : begin
                          Application.HelpContext(139);           {VAT Description}
                     end;
            End;

       End;
       //Key := 0;
end;

procedure TFVat.HelpClick(Sender: TObject);
begin
     Application.HelpContext(199);
end;

end.
