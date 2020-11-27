unit Addrec;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TAddRecForm = class(TForm)
    NewCode: TEdit;
    CodeName: TEdit;
    Panel1: TPanel;
    AddButton: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    CancelButton: TBitBtn;
    NomPanel: TPanel;
    NonEntRadio: TRadioButton;
    OverHeadRadio: TRadioButton;
    LiabRadio: TRadioButton;
    BankRadio: TRadioButton;
    CAssetsRadio: TRadioButton;
    FAssetsRadio: TRadioButton;
    EntPanel: TPanel;
    EntIncome: TRadioButton;
    EntExpenditure: TRadioButton;
    BlankPanel: TPanel;
    SaveButton: TBitBtn;
    AddressPanel: TPanel;
    Address1: TEdit;
    Addresslbl1: TLabel;
    Addresslbl2: TLabel;
    Address2: TEdit;
    Address3: TEdit;
    Addresslbl3: TLabel;
    Addresslbl4: TLabel;
    Address4: TEdit;
    Extraspanel: TPanel;
    depreclabel2: TLabel;
    Depreclabel: TLabel;
    Deprec_edit: TEdit;
    Deprec_edit2: TEdit;
    NominalTypeDropdown: TComboBox;
    TypeLabel: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure CAssetsRadioMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure SetupExtras;
    procedure Deprec_editChange(Sender: TObject);
    procedure Deprec_edit2Change(Sender: TObject);
    procedure Deprec_editExit(Sender: TObject);
    procedure Deprec_edit2Exit(Sender: TObject);
  private
    { Private declarations }
    NewRec : Integer;
  public
    { Public declarations }
    MadeNewRec : Boolean;
  end;

var
  AddRecForm: TAddRecForm;

implementation
Uses
    dbcore,
    clears,
    types,
    vars,
    dbgen,
    util,
    NewListing, AccsData;

Var
   NewRecAdded,
   RangeSelected : Boolean;
   LocalRange : TAccRange;

{$R *.DFM}

procedure TAddRecForm.FormActivate(Sender: TObject);
begin
     Caption := 'Add Records';{+ ' - ' + st;}
     MadeNewRec := False;
     RangeSelected := False;
     addresspanel.hide;
     { Decide which Panel to display }
     If ( NewListBox.ListInfo.ActiveDb = NlFile ) And ( Length (NewListBox.ListInfo.Ent) = 0 ) Then
        Begin
             NomPanel.Show;
             MessageDlg('Select Account Type', mtConfirmation, [mbOk], 0);
        End
     Else If ( NewListBox.ListInfo.ActiveDb = NlFile ) Then
        Begin
             EntPanel.Show;
             MessageDlg('Select Account Type', mtConfirmation, [mbOk], 0);
        End
     Else begin
          BlankPanel.Show;
          addresspanel.show;
          end;
end;

procedure TAddRecForm.AddButtonClick(Sender: TObject);
var
   range : integer;
begin
     Savebutton.enabled := true;
     Addbutton.Enabled := false;
     If ( NOT NewRecAdded ) Then
        Begin
             // TGM AB - sets up extra fields panel
             SetupExtras;

             If ( NomPanel.Visible = True ) And NOT ( RangeSelected ) Then
                Begin
                     MessageDlg('Select Account Type', mtConfirmation, [mbOk], 0);
                     NomPanel.SetFocus;
                End;

             If ( NomPanel.Visible = True ) Or ( EntPanel.Visible = True ) Then
                Begin
                     If RangeSelected Then
                        NewRec := GetNextFreeAccount ( NewListBox.ListInfo.ActiveDb, LocalRange )
                     Else
                         MessageDlg('Select Account Type', mtConfirmation, [mbOk], 0);
                End
             Else
                 begin
                 if NewListBox.ListInfo.ActiveDb = slFile then begin
                    range := NewListBox.ListInfo.AccRange[2];
                    UpdateDataBaseDefaults;
                    if SLMax = 0 then NewListBox.ListInfo.AccRange[2] := 9999
                       else NewListBox.ListInfo.AccRange[2] := SLMax;
                    NewRec := GetNextFreeAccount ( NewListBox.ListInfo.ActiveDb, NewListBox.ListInfo.AccRange );
                    NewListBox.ListInfo.AccRange[2] := range+1;
                 end else
                         if NewListBox.ListInfo.ActiveDb = plFile then begin
                            range := NewListBox.ListInfo.AccRange[2];
                            UpdateDataBaseDefaults;
                            if PLMax = 0 then NewListBox.ListInfo.AccRange[2] := 9999
                               else NewListBox.ListInfo.AccRange[2] := PLMax;
                            NewRec := GetNextFreeAccount ( NewListBox.ListInfo.ActiveDb, NewListBox.ListInfo.AccRange );
                            NewListBox.ListInfo.AccRange[2] := range+1;
                         end else NewRec := GetNextFreeAccount ( NewListBox.ListInfo.ActiveDb, NewListBox.ListInfo.AccRange );
                 end;

             NewCode.Text := IntToStr ( NewRec );
             { If new record allowed then Blank it and add it }
             If ( NewRec > 0 ) Then
                Begin
                     NewRecAdded := True;
                     BlankRec ( NewListBox.ListInfo.ActiveDb, 'A' );
                     AddRecord ( NewListBox.ListInfo.ActiveDb, NewRec, False );
                     dberr;
                End
             Else
                 CodeName.SetFocus;
        End
     Else
         Begin
              MessageDlg('Account Already Added', mtConfirmation, [mbOk], 0);
              CodeName.SetFocus;
         End;
end;

procedure TAddRecForm.CancelButtonClick(Sender: TObject);
begin
     { Delete the record you added before closing as it hasn't been saved by the user }
     If NewRecAdded Then
        DeleteRecord ( NewListBox.ListInfo.ActiveDb, NewRec, False );
        Close;
end;

procedure TAddRecForm.CAssetsRadioMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     RangeSelected := False;
     FillChar ( LocalRange, SizeOf(LocalRange), 0 );

     If Button = mbLeft Then
        Begin
             If (Sender as TRadioButton).Name = 'NonEntRadio' Then
                Begin
                     LocalRange := NewListBox.SetRanges ( Sender, NonEnt );
                     RangeSelected := True;
                End
             Else If (Sender as TRadioButton).Name = 'LiabRadio' Then
                Begin
                     LocalRange := NewListBox.SetRanges ( Sender, Liab );
                     RangeSelected := True;
                End
             Else If (Sender as TRadioButton).Name = 'CAssetsRadio' Then
                   Begin
                        LocalRange := NewListBox.SetRanges ( Sender, CAsset );
                        RangeSelected := True;
                   End
             Else If (Sender as TRadioButton).Name = 'FAssetsRadio' Then
                   Begin
                        LocalRange := NewListBox.SetRanges ( Sender, FAsset );
                        RangeSelected := True;
                   End
             Else If (Sender as TRadioButton).Name = 'BankRadio' Then
                   Begin
                        LocalRange := NewListBox.SetRanges ( Sender, Banks );
                        RangeSelected := True;
                   End
             Else If (Sender as TRadioButton).Name = 'OverHeadRadio' Then
                   Begin
                        LocalRange := NewListBox.SetRanges ( Sender, Overheads );
                        RangeSelected := True;
                   End
             Else If (Sender as TRadioButton).Name = 'EntIncome' Then
                   Begin
                        LocalRange[1] := NewListBox.ListInfo.AccRange[1];
                        LocalRange[2] := NewListBox.ListInfo.AccRange[2];
                        RangeSelected := True;
                   End
             Else If (Sender as TRadioButton).Name = 'EntExpenditure' Then
                   Begin
                        LocalRange[1] := NewListBox.ListInfo.AccRange[3];
                        LocalRange[2] := NewListBox.ListInfo.AccRange[4];
                        RangeSelected := True;
                   End;
        End;

end;

procedure TAddRecForm.FormShow(Sender: TObject);
begin
     EntPanel.Left := NomPanel.Left;
     EntPanel.Top := NomPanel.Top;
     BlankPanel.Left := NomPanel.Left;
     BlankPanel.Top := NomPanel.Top;
     NomPanel.Hide;
     EntPanel.Hide;
     BlankPanel.Hide;
     addresspanel.hide;
     NewRecAdded := False;
     Savebutton.enabled := false;
     addbutton.enabled := true;
     NewCode.Text := '';
     CodeName.Text := '';
     Address1.text := '';
     Address2.text := '';
     Address3.text := '';
     Address4.text := '';

     // TGM AB unchekcing all the boxes

     NonEntRadio.checked := false;
     OverheadRadio.checked := false;
     CAssetsRadio.checked := false;
     FAssetsRadio.checked := false;
     LiabRadio.checked := false;
     BankRadio.checked := false;
     EntIncome.checked := false;
     Entexpenditure.checked := false;
end;

procedure TAddRecForm.SaveButtonClick(Sender: TObject);
begin
     { If Rec added an Name has something in it }
     If ( NewRecAdded ) And ( Length ( CodeName.Text ) > 0 ) Then
        Begin
            Case NewListBox.ListInfo.ActiveDb Of
                 AnalFile : Begin
                                 PutInt ( NewListBox.ListInfo.ActiveDb, NewRec, 1 );
                                 PutStr ( NewListBox.ListInfo.ActiveDb, CodeName.Text, 2 );
                            End;
                 PlFile,
                 SlFile : begin
                          PutStr ( NewListBox.ListInfo.ActiveDb, CodeName.Text, 1 );
                          PutStr ( NewListBox.ListInfo.ActiveDb, Address1.text, 2 );
                          PutStr ( NewListBox.ListInfo.ActiveDb, Address2.text, 3 );
                          PutStr ( NewListBox.ListInfo.ActiveDb, Address3.text, 4 );
                          PutStr ( NewListBox.ListInfo.ActiveDb, Address4.text, 5 );
                          end;

                 NlFile : begin
                          PutStr ( NewListBox.ListInfo.ActiveDb, CodeName.Text, 1 );
                          PutStr ( NewListBox.ListInfo.ActiveDb, NewListBox.ListInfo.Ent, 24 );
                          WriteTables (NewListBox.ListInfo.ActiveDB,StrtoInt(NewCode.text),CodeName.text );

                          // TGM AB line above creats a nominal group with same code & name as nominal account

                          // TGM AB - 20/08/02 Added the next lines to allow saving of depreciation & nominal type

                          if deprec_edit.visible then begin
                              if Deprec_edit.text <> '' then begin
                                                             currlong := StrToInt(FloatToStr(100 * StrToFloat(Deprec_edit.text)));
                                                             putitem(NLFile,101);
                                                             end;
                              if Deprec_edit2.text <> '' then begin
                                                              currlong := StrToInt(FloatToStr(100 * StrToFloat(Deprec_edit2.text)));
                                                              putitem(NLFile,102);
                                                              end;
                          end;

                          if nominaltypedropdown.visible then begin
                              if NominalTypeDropdown.ItemIndex = 1 then currdisp[1] := 'L';
                              if NominalTypeDropdown.ItemIndex = 2 then currdisp[1] := 'P';
                              if NominalTypeDropdown.ItemIndex = 3 then currdisp[1] := 'O';
                              if NominalTypeDropdown.ItemIndex = 4 then currdisp[1] := 'U';
                              putitem(nlfile,103);
                          end;


                          end; // case

            End;
            RewriteRec ( NewListBox.ListInfo.ActiveDb, NewRec );
            dberr;
            MadeNewRec := True;
            Close;
        End
     Else
         If ( Length ( CodeName.Text ) = 0 ) Then
             Begin
                  MessageDlg('You Need to Enter a Name', mtConfirmation, [mbOk], 0);
                  CodeName.SetFocus;
             End
         Else
             MessageDlg('You Need to Add an Account Before you can save it', mtConfirmation, [mbOk], 0);
end;

procedure TAddRecForm.FormDeactivate(Sender: TObject);
begin
     addresspanel.hide;
     Extraspanel.hide;
end;

procedure TAddRecForm.SetupExtras;
begin
          Deprec_edit.text := '';
          Deprec_edit2.text := '';
          Deprec_edit.visible := false;
          Deprec_edit2.visible := false;
          Depreclabel.visible := false;
          Depreclabel2.visible := false;
          Typelabel.visible := false;
          NominalTypeDropDown.visible := false;
          Nominaltypedropdown.Itemindex := 0;

          if (CAssetsRadio.Checked or FAssetsRadio.checked) then begin
             Deprec_edit.visible := true;
             Deprec_edit2.visible := true;
             Depreclabel.visible := true;
             Depreclabel2.visible := true;
             Extraspanel.show;
          end
             else if ((NonEntRadio.Checked or OverheadRadio.checked or EntIncome.checked or EntExpenditure.checked) and (Accsdatamodule.linkedtoherd)) then begin
                     Typelabel.visible := true;
                     NominalTypeDropDown.visible := true;
                     Extraspanel.show;
             end
                else extraspanel.hide;
end;

procedure TAddRecForm.Deprec_editChange(Sender: TObject);
begin

        if ((deprec_edit2.text <> '') and (deprec_edit.Text <> '')) then begin
           Showmessage('You can set either the percentage rate or a fixed rate depreciation but not both.' + #10#13 + 'If you want to set a rate, then remove the fixed amount depreciation');
           deprec_edit.Clear;
        end;
        if (deprec_edit.text <> '') then begin
            try if strtofloat(deprec_edit.text) > 100.00 then begin
                               showmessage('Depreciation rate cannot exceed 100%');
                               deprec_edit.text := '100.00';
                               end;
            except
            end;
        end;
end;

procedure TAddRecForm.Deprec_edit2Change(Sender: TObject);
begin
        if ((deprec_edit.text <> '') and (deprec_edit2.text <> '')) then begin
           Showmessage('You can set either the percentage rate or a fixed rate depreciation but not both.' + #10#13 + 'If you want to set a fixed amount, then remove the depreciation rate');
           deprec_edit2.Clear;
        end;
end;

procedure TAddRecForm.Deprec_editExit(Sender: TObject);
begin
     if Deprec_edit.text <> '' then begin
        try strtofloat(Deprec_edit.text);
        except showmessage('Depreciation Rate must be a percentage value');
            Deprec_edit.clear;
        end;
     end;
end;

procedure TAddRecForm.Deprec_edit2Exit(Sender: TObject);
begin
     if Deprec_edit2.text <> '' then begin
        try strtofloat(Deprec_edit2.text);
        except showmessage('Depreciation Amount must be a numeric value');
            Deprec_edit2.clear;
        end;
     end;
end;

end.
