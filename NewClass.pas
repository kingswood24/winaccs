unit NewClass;

interface
Uses
    WinTypes, Classes,
    StdCtrls, NewListing,
    Controls,ExtCtrls,mask,
    types, Forms;

Type
    TWhereFrom = (Report, Input);
    TKingForm = class(TForm)
    Published
        Procedure KOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState;
                                       AccountType : TRange; ListType : Char);
        Procedure KDateFromExit(Sender:TObject; WhereFrom : TWhereFrom );
        Procedure KDateToExit(Sender:TObject; WhereFrom : TWhereFrom );
        Procedure KDateValid(Sender:TObject );
        Procedure KPrinterOrScreen(Sender: TObject;
                        Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Public
        TxDateFrom,
        TxDateTo   : Integer;
    End;

Var
   REPXDATE : ShortString;
            
Implementation
Uses
    Vars,
    Clears,
    Calcs,
    PrintSet;

Procedure TKingForm.KOnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState;
                                       AccountType : TRange; ListType : Char);
Var
   st : ShortString;
begin
   If Key = VK_F2 Then    { F2 Pressed }
       Begin
          NewListBox.ListIt ( Sender, AccountType, ListType );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
             Begin
                 St :=NewListBox.ListInfo.ReturnValue;
                 SlimAll ( St );
                 ( Sender as TEdit ).Text := St;
             End;
       End;
End;

Procedure TKingForm.KDateFromExit(Sender:TObject; WhereFrom : TWhereFrom );
Var
   Day,Month,Year : ShortString;
   BlankDate : Boolean;
begin
   TxDateFrom := CDateFrom;

   If (Sender is Tedit) Then
     Begin
     If Length ( ( Sender as TEdit ).Text ) <> 0  Then
        If NOT DateValid ( ( Sender as TEdit ).Text, TDateFormat ) Then
           ( Sender as TEdit ).SetFocus
        Else
            TxDateFrom := Trunc ( DayTot-32000 );
     End
   Else if (Sender is TMaskedit) Then
     Begin
        BlankDate := False;  // Assume Not a blank Date
        If WhereFrom = Report Then  // If its a report check for blanks
           Begin
              Day   := Copy ((Sender as TMaskEdit).Text,1,2 );
              SlimAll(Day);
              Month := Copy ((Sender as TMaskEdit).Text,4,2 );
              SlimAll(Month);
              Year  := Copy ((Sender as TMaskEdit).Text,7,2 );
              SlimAll(Year);
              // Set to true if all fields are Blank
              BlankDate := ((Length(Day)=0) And (Length(Month)=0) And (Length(Year)=0));
           End;
        If ( NOT BlankDate ) Then
           If Length (( Sender as TMaskEdit ).Text ) <> 0  Then
              If NOT DateValid ( ( Sender as TMaskEdit ).Text, TDateFormat ) Then
                 ( Sender as TMaskEdit ).SetFocus
              Else
                 TxDateFrom := Trunc ( DayTot-32000 );
     End;
end;

Procedure TKingForm.KDateToExit(Sender:TObject; WhereFrom : TWhereFrom);
Var
   Day,Month,Year : ShortString;
   BlankDate : Boolean;
begin
   TxDateTo := CDateTo;
   If (Sender is Tedit) Then
     Begin
     If Length ( ( Sender as TEdit ).Text ) <> 0  Then
        If NOT DateValid ( ( Sender as TEdit ).Text, TDateFormat ) Then
           ( Sender as TEdit ).SetFocus
        Else
            Begin
                 TxDateTo := Trunc ( DayTot-32000 );
                 If TxDateTo < TxDateFrom Then
                    ( Sender as TEdit ).SetFocus;
            End;
      End
   Else if (Sender is TMaskEdit) Then
     Begin
        BlankDate := False;  // Assume Not a blank Date
        If WhereFrom = Report Then  // If its a report check for blanks
           Begin
              Day   := Copy ((Sender as TMaskEdit).Text,1,2 );
              SlimAll(Day);
              Month := Copy ((Sender as TMaskEdit).Text,4,2 );
              SlimAll(Month);
              Year  := Copy ((Sender as TMaskEdit).Text,7,2 );
              SlimAll(Year);
              // Set to true if all fields are Blank
              BlankDate := ((Length(Day)=0) And (Length(Month)=0) And (Length(Year)=0));
           End;
        If ( NOT BlankDate ) Then
           If Length ( ( Sender as TMaskEdit ).Text ) <> 0  Then
              If NOT DateValid ( ( Sender as TMaskEdit ).Text, TDateFormat ) Then
                 ( Sender as TMaskEdit ).SetFocus
              Else
                 Begin
                    TxDateTo := Trunc ( DayTot-32000 );
                    If TxDateTo < TxDateFrom Then
                       ( Sender as TMaskEdit ).SetFocus;
                 End;
     End;
end;

Procedure TKingForm.KDateValid(Sender:TObject );
begin
   If (Sender is Tedit) Then
     Begin
     If Length ( (Sender as TEdit).Text ) <> 0  Then
        If NOT DateValid ( (Sender as TEdit).Text, TDateFormat ) Then
           (Sender as TEdit).SetFocus;
     End
   Else if (Sender is TMaskEdit) Then
     Begin
     If Length ( (Sender as TMaskEdit).Text ) <> 0  Then
        If NOT DateValid ( (Sender as TMaskEdit).Text, TDateFormat ) Then
           (Sender as TMaskEdit).SetFocus;
     End;
end;

procedure TKingForm.KPrinterOrScreen(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     { Check the name of the sender OBJECT and set the Global Device to P - Printer
       Or F - WordPad }
     If Button = mbLeft Then
        Begin
             (Sender as TRadioButton ).Checked := True;
             If ( Sender as TRadioButton ).Name = 'PReports' Then
                Device := 'P'
             Else
                 Device := 'F';
        End
     Else
         { Call the Printer Setup Form if Right Button Clicked }
         If Button = mbRight Then
            PrintForm.ShowModal;
end;

end.
