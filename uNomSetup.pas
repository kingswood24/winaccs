{
Use   : SetUp Nominal Accounts
}
unit UNominalSetUp;

interface
Uses
    Types,
    SetUp;

Procedure FillNomGrid ( AccRange : TAccRange );
Procedure FillNomPanel ( RecToRead : Integer );
Procedure SaveNominal;
Procedure NewNominalAccount;
Procedure DeleteNominalAccount;
Function  GetAccountRanges : TAccRange;
Procedure CancelNominalAccount;
Procedure NominalButtonNames;

implementation
Uses
    StdCtrls,
    Controls,
    Messages,
    Dialogs,
    SysUtils,
    Calcs,
    DBCore,
    DBGen,
    Util,
    Vars,
    AccsData,
    LangUnit;

Var
   WasBalance : Long;



Procedure CheckAccType ( AccountToCheck : Integer; Var CLong : Long );
Begin

     If (( AccountToCheck >= Cash1.xnomliFrom ) And
         ( AccountToCheck <= Cash1.xnomliTo )) Or
     {
        (( AccountToCheck >= xbankmin ) And
         ( AccountToCheck <= xbankmax )) Or
     }
        (( AccountToCheck >= Cash1.xnomcredit ) And
         ( AccountToCheck <= Cash1.xnomcredit )) Or
        (( AccountToCheck >= Cash1.xnomprofit ) And
         ( AccountToCheck <= Cash1.xnomprofit+Cash11.xno_of_partners )) Then
         CLong := 0-CLong;
      
End;

{ Fill the screen Panel with data from the Current RecToRead }
Procedure FillNomPanel ( RecToRead : Integer );
Begin
     SetUpAccounts.RecNo := 0;
     SetDb ( SetUpAccounts.cDb );
     If ( RecToRead > 0 ) And ( RecToRead <= db1.dbrechigh ) Then
        Begin
             ReadRec ( SetUpAccounts.cDb, RecToRead );
             dberr;
             If Recactive ( SetUpAccounts.cDb ) Then
                Begin
                     SetUpAccounts.NomCode.Text := IntToStr ( RecToRead );
                     Getitem ( SetUpAccounts.cDb, 1 );
                     SetUpAccounts.NomName.Text := CurrStr;
                     If SetUpAccounts.ShowOpening.Checked Then
                        Getitem ( SetUpAccounts.cDb, 22 )
                     Else
                         GetItem ( SetUpAccounts.cDb, 2 );

                     CheckAccType ( RecToRead, CurrLong );
                     WasBalance := CurrLong;
                     LongStr ( CurrLong, CurrStr, 'L' );
                     SetUpAccounts.NomBalance.Text := CurrStr;
                     // Get the Current Records Product
                     try
                         AccsDataModule.NominalList.Locate('Account',RecToRead,[] );
                     except

                     end;

                     Getitem ( SetUpAccounts.cDb, 5 );
                     // No Group entered so default to the Record Number
                     if Currint = 0 then
                        CurrInt := RecToRead;

                     SetUpAccounts.NomRepGroup.Text := IntToStr ( Currint );
                     ReadTables ( SetUpAccounts.cDb, CurrInt, CurrStr );
                     SetUpAccounts.NomGroupDesc.Text := CurrStr;
                     Getitem ( SetUpAccounts.cDb, 20 );
                     SetUpAccounts.NomVatCode.Text := CurrStr;
                     SetUpAccounts.RecNo := RecToRead;
                     If ( SetUpAccounts.EntIncome.Checked ) Or
                        ( SetUpAccounts.EntExpenditure.Checked ) Then
                        Begin
                             GetStr ( SetUpAccounts.cDb, 24, 4, CurrStr );
                             SetUpAccounts.NomEntCode.Text := CurrStr;
                        End;
                End;
        End;
End;

Procedure ClearNomPanel;
Begin
    SetUpAccounts.NomCode.Clear;
    SetUpAccounts.NomName.Clear;
    SetUpAccounts.NomVATCode.Clear;
    SetUpAccounts.NomBalance.Text := '0';
    SetUpAccounts.NomRepGroup.Text := '0';
    SetUpAccounts.NomGroupDesc.Clear;
    SetUpAccounts.NomEntCode.Clear;
End;

{ Fill the NomGrid With the Current Nominal Ledger File }
Procedure FillNomGrid ( AccRange : TAccRange );
Var
   ArrPos,
   NomRec : Integer;
Begin
     SetUpAccounts.RecNo := 0;
     ArrPos := 1;
     SetUpAccounts.NomGrid.Cells[2,ArrPos] := '';
     SetUpAccounts.NomGrid.Cells[1,ArrPos] := '';
     SetUpAccounts.NomGrid.Cells[0,ArrPos] := '';
     NomRec := AccRange[1];
     SetDb ( SetUpAccounts.cDb );
     Repeat
           ReadRec ( SetUpAccounts.cDb, NomRec );
           dberr;
           If Recactive ( SetUpAccounts.cDb ) And ( NOT ExcludeNominal ( NomRec )) Then
              Begin
                   SetUpAccounts.NomGrid.Cells[0,ArrPos] := IntToStr ( NomRec );
                   GetItem ( SetUpAccounts.cDb, 1 );
                   SetUpAccounts.NomGrid.Cells[1,ArrPos] := CurrStr;
                   GetItem ( SetUpAccounts.cDb, 24 );
                   SetUpAccounts.NomGrid.Cells[2,ArrPos] := CurrStr;
                   Inc ( ArrPos );
              End;
           Inc ( NomRec );
     Until ( NomRec > AccRange[2] ) Or ( NomRec = 0 );
     {
     If ArrPos > 2 Then
        SetUpAccounts.NomGrid.RowCount := ArrPos
     Else
         SetUpAccounts.NomGrid.RowCount := ArrPos+1;
     }
     Dec ( ArrPos );
     If ArrPos > 0 Then
        SetUpAccounts.NomGrid.RowCount := ArrPos+1
     Else If ArrPos <= 0 Then
          SetUpAccounts.NomGrid.RowCount := 2;

     If Numeric ( SetUpAccounts.NomGrid.Cells[0, 1]) Then
        FillNomPanel ( StrToInt (SetUpAccounts.NomGrid.Cells[0, SetUpAccounts.NomGrid.Row]))
     Else
         ClearNomPanel;

     If SetUpAccounts.NomGrid.CanFocus Then
       SetUpAccounts.NomGrid.SetFocus;

End;

Procedure SaveNominal;
Var
   NewBalance : Long;
Begin
     If SetUpAccounts.RecNo > 0 Then
        Begin
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.NomName.Text, 1 );

             CurrInt := StrToInt ( SetUpAccounts.NomRepGroup.Text );
             PutItem ( SetUpAccounts.cDb, 5 );
             CurrInt := StrToInt ( SetUpAccounts.NomRepGroup.Text );
             PutItem ( SetUpAccounts.cDb, 5 );

             try
                if AccsDataModule.Products.FieldByName('ID').AsFloat > 0 then
                   begin
                      SetItem;
                      CurrLong := AccsDataModule.Products.FieldByName('ID').AsInteger;
                      PutItem (SetUpAccounts.cDb,6);
                   end;
             except
                ShowMessage('Cannot add Product to Nominal Account');
             end;

             CurrStr := SetUpAccounts.NomGroupDesc.Text;
             WriteTables ( SetUpAccounts.cDb, CurrInt, CurrStr );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.NomVatCode.Text, 20 );
             { Rewrite the record before adding inbalance }
             Rewriterec ( SetUpAccounts.cDb, SetUpAccounts.RecNo );
             dberr;

             StrLong ( SetUpAccounts.NomBalance.Text, CurrLong );
             CheckAccType ( SetUpAccounts.RecNo, CurrLong );
             If SetUpAccounts.ShowOpening.Checked Then
                PutItem ( SetUpAccounts.cDb, 22 )
             Else
                 PutItem ( SetUpAccounts.cDb, 2 );

             StrLong ( SetUpAccounts.NomBalance.Text, NewBalance );
             {CheckAccType ( SetUpAccounts.RecNo, NewBalance );}

             If ( WasBalance = NewBalance ) Then  { No Change in balance Save Info }
                Begin
                     Rewriterec ( SetUpAccounts.cDb, SetUpAccounts.RecNo );
                     dberr;
                End
             Else
                 Begin
                      CheckAccType ( SetUpAccounts.RecNo, NewBalance );
                      CheckAccType ( SetUpAccounts.RecNo, WasBalance );
                      SetUpAccounts.LogNom ( SetUpAccounts.cDb, SetUpAccounts.RecNo,
                             Cash1.XNomOpen, 0-WasBalance );
                      SetUpAccounts.LogNom ( SetUpAccounts.cDb, SetUpAccounts.RecNo,
                             Cash1.XNomOpen, NewBalance );
                 End;

             FillNomGrid ( GetAccountRanges );
        End;
End;

Procedure AddNewNominalAccount ( Accno : Integer );
Begin
     If AccNo > 0 Then
        Begin
             BlankRec ( SetUpAccounts.cDb, 'A' );
             AddRecord ( SetUpAccounts.cDb, AccNo, False );
             FillNomPanel ( AccNo );
             SetUpAccounts.NomName.SetFocus;
        End;
End;

Function GetAccountRanges  : TAccRange;
Begin
     GetAccountRanges[1] := 0;
     GetAccountRanges[2] := 0;
     GetAccountRanges[3] := 0;
     GetAccountRanges[4] := 0;
     GetAccountRanges[5] := 0;
     GetAccountRanges[6] := 0;
     { Focus is on the Nominal Accounts SetUp Screen }
     If SetUpAccounts.NominalAccounts.CanFocus Then
        Begin
             If SetUpAccounts.EntIncome.Checked Then
                Begin
                     GetAccountRanges[1] := Cash1.xNomIncFrom;
                     GetAccountRanges[2] := Cash1.xNomIncTo;
                End
             Else If SetUpAccounts.EntExpenditure.Checked Then
                Begin
                     GetAccountRanges[1] := Cash1.xNomExpFrom;
                     GetAccountRanges[2] := Cash1.xNomExpTo;
                End
             Else If SetUpAccounts.NomEntIncome.Checked Then
                Begin
                     GetAccountRanges[1] := Cash1.xNomNonFrom;
                     GetAccountRanges[2] := Cash1.xNomNonTo;
                End
             Else If SetUpAccounts.OverHeads.Checked Then
                Begin
                     GetAccountRanges[1] := Cash1.xNomOhFrom;
                     GetAccountRanges[2] := Cash1.xNomOhTo;
                End
             Else If SetUpAccounts.CurrentAssets.Checked Then
                Begin
                     GetAccountRanges[1] := Cash1.xNomCaFrom;
                     GetAccountRanges[2] := Cash1.xNomCaTo;
                End
             Else If SetUpAccounts.FixedAssets.Checked Then
                Begin
                     GetAccountRanges[1] := Cash1.xNomFaFrom;
                     GetAccountRanges[2] := Cash1.xNomFaTo;
                End
             Else If SetUpAccounts.Liabilities.Checked Then
                Begin
                     GetAccountRanges[1] := Cash1.xNomLiFrom;
                     GetAccountRanges[2] := Cash1.xNomLiTo;
                End
             Else If SetUpAccounts.Banks.Checked Then
                Begin
                     GetAccountRanges[1] := Cash1.xBankMin;
                     GetAccountRanges[2] := Cash1.xBankMax;
                End
             Else If SetUpAccounts.ControlAccounts.Checked Then
                Begin
                     GetAccountRanges[1] := Cash1.xNomTax;
                     GetAccountRanges[2] := Cash1.xNomProfit+Cash11.xno_of_partners;
                End
             Else If SetUpAccounts.AllAccounts.Checked Then
                Begin
                     SetDb ( SetUpAccounts.cDb );
                     GetAccountRanges[1] := 1;
                     GetAccountRanges[2] := db1.dbrechigh;
                End;
        End
     { Focus is on the Enterprise SetUp Screen }
     Else If SetUpAccounts.Enterprises.CanFocus Then
             Begin
                  If SetUpAccounts.EntIncomeRadio.Checked Then
                     Begin
                          GetAccountRanges[1] := Cash1.xNomIncFrom;
                          GetAccountRanges[2] := Cash1.xNomIncTo;
                     End
                  Else If SetUpAccounts.EntExpendRadio.Checked Then
                     Begin
                          GetAccountRanges[1] := Cash1.xNomExpFrom;
                          GetAccountRanges[2] := Cash1.xNomExpTo;
                     End;
             End;
End;

Procedure NewNominalAccount;
Begin
     If SetUpAccounts.NomEntIncome.Checked Then
        AddNewNominalAccount ( GetNextFreeAccount ( NlFile, GetAccountRanges ))
     Else If SetUpAccounts.OverHeads.Checked Then
        AddNewNominalAccount ( GetNextFreeAccount ( NlFile, GetAccountRanges ))
     Else If SetUpAccounts.CurrentAssets.Checked Then
        AddNewNominalAccount ( GetNextFreeAccount ( NlFile, GetAccountRanges ))
     Else If SetUpAccounts.FixedAssets.Checked Then
        AddNewNominalAccount ( GetNextFreeAccount ( NlFile, GetAccountRanges ))
     Else If SetUpAccounts.Liabilities.Checked Then
        AddNewNominalAccount ( GetNextFreeAccount ( NlFile, GetAccountRanges ))
     Else If SetUpAccounts.Banks.Checked Then
        AddNewNominalAccount ( GetNextFreeAccount ( NlFile, GetAccountRanges ))
     Else
        begin
           MessageDlg('Select Account Type', mtInformation, [mbOk], 0);
           SetUp.SetUpAccounts.AddAmendDelete := '';
        end;
End;

Procedure DeleteNominalAccount;
Var
   OkToDelete : Boolean;
begin
     If SetUpAccounts.RecNo > 0 Then
        Begin
             SetDb ( SetUpAccounts.cDb );
             ReadRec ( SetUpAccounts.cDb, SetUpAccounts.RecNo );
             dberr;
             { Cannot delete control Accounts }
             OkToDelete := (( SetUpAccounts.RecNo <= Cash1.xbankmax ) And
                            ( SetUpAccounts.RecNo <> Cash1.xnomsldisc ) And
                            ( SetUpAccounts.RecNo <> Cash1.xnompldisc ) And
                            ( SetUpAccounts.RecNo <> Cash1.xnomdeprec ));
             If OkToDelete Then
                Begin
                     GetItem ( SetUpAccounts.cdb, 2 );
                     OkToDelete := ( currlong = 0 );
                End
             Else If OkToDelete Then
                Begin
                     GetItem ( SetUpAccounts.cdb, 14 );
                     OkToDelete := ( Currint = 0 );
                     If OkToDelete Then
                        Begin
                             GetItem ( SetUpAccounts.cdb, 15 );
                             OkToDelete := ( Currint = 0 );
                        End;
                End;
             If OkToDelete Then
                Begin
                     If MessageDlg('Delete Account ' +
                        SetUpAccounts.NomGrid.Cells[0,SetUpAccounts.NomGrid.Row] + ' ' +
                        SetUpAccounts.NomGrid.Cells[1,SetUpAccounts.NomGrid.Row],
                        mtInformation, [mbYes, mbNo], 0) = mrYes  Then
                          Begin
                               DeleteRecord ( SetUpAccounts.cDb, SetUpAccounts.Recno, False );
                               FillNomGrid ( GetAccountRanges ); { refresh the nomnal Grid }
                          End;
                End
             Else
                 Begin
                      If ( SetUpAccounts.RecNo >= Cash1.xbankmax ) Or
                         ( SetUpAccounts.RecNo = Cash1.xnomsldisc ) Or
                         ( SetUpAccounts.RecNo = Cash1.xnompldisc ) Or
                         ( SetUpAccounts.RecNo = Cash1.xnomdeprec ) Then
                         MessageDlg('This Account cannot be Deleted',
                                  mtInformation, [mbOk], 0)
                      Else
                          MessageDlg('This Account has Active Details - Delete Rejected',
                                  mtInformation, [mbOk], 0);
                 End;
        End;
End;

Procedure CancelNominalAccount;
Begin
     If SetUpAccounts.AddAmendDelete = 'ADD' Then
        DeleteRecord ( SetUpAccounts.cDb, SetUpAccounts.RecNo, False );
     SetUpAccounts.AddAmendDelete := '';
     FillNomGrid ( GetAccountRanges );
End;

Procedure NominalButtonNames;
Begin
    With SetUpAccounts Do
         Begin
              NominalAccounts.Caption := ReadLang ( 49, CurrLang );
              EntIncome.Caption := ReadLang ( 50, CurrLang );
              NomEntIncome.Caption := ReadLang ( 51, CurrLang );
              EntExpenditure.Caption := ReadLang ( 52, CurrLang );
              Overheads.Caption := ReadLang ( 53, CurrLang );
              CurrentAssets.Caption := ReadLang ( 54, CurrLang );
              FixedAssets.Caption := ReadLang ( 55, CurrLang );
              Liabilities.Caption := ReadLang ( 56, CurrLang );
              Banks.Caption := ReadLang ( 57, CurrLang );
              AllAccounts.Caption := ReadLang ( 58, CurrLang );
              ControlAccounts.Caption := ReadLang ( 59, CurrLang );
              ShowOpening.Caption := ReadLang ( 67, CurrLang );
              ShowCurrent.Caption := ReadLang ( 66, CurrLang );
              LabelNomCode.Caption := ReadLang ( 60, CurrLang );
              LabelNomName.Caption := ReadLang ( 61, CurrLang );
              LabelNomVatCode.Caption := ReadLang ( 62, CurrLang );
              LabelNomBalance.Caption := ReadLang ( 63, CurrLang );
              LabelNomReportGroup.Caption := ReadLang ( 64, CurrLang );
              LabelNomGroupDesc.Caption := ReadLang ( 65, CurrLang );
              SaveNom.Caption := ReadLang ( 26, CurrLang );
              CancelNominalChanges.Caption := ReadLang ( 70, CurrLang );
              AddAccount.Caption := ReadLang ( 69, CurrLang );
              DelAccount.Caption := ReadLang ( 68, CurrLang );
              NomHelp.Caption := ReadLang ( 48, CurrLang );
         End;
End;

end.
