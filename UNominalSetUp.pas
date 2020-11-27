{
Use   : SetUp Nominal Accounts

   03/09/18 [V4.3 R1.2] /MK Incorporated Changes from Andrew (TGM) - DeleteNominalAccount - Don't allow delete of nominal if it was used in job card or proforma.
}
unit UNominalSetUp;

interface
Uses
    Types,
    SetUp,
    uFarmSyncSettings;

Procedure FillNomGrid ( AccRange : TAccRange );
Procedure FillNomPanel ( RecToRead : Integer );
Procedure SaveNominal;
Procedure NewNominalAccount;
Procedure DeleteNominalAccount;
Function  GetAccountRanges : TAccRange;
Procedure CancelNominalAccount;
Procedure NominalButtonNames;
Procedure TransferNominal(FromNL : integer);

Procedure CheckAccType ( AccountToCheck : Integer; Var CLong : Long );
Function CheckProformaTableForNominal(NLNo : integer) : Boolean;        // Ch005

implementation
Uses
    DBTables,            //Ch005
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
    db,
    LangUnit,
    NewListing;

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
      SetupAccounts.Deprec_edit.visible := false;
      SetupAccounts.Depreclabel.visible := false;
      SetupAccounts.Deprec_edit2.visible := false;
      SetupAccounts.Depreclabel2.visible := false;
      SetUpAccounts.TypeLabel.visible := false;
      SetUpAccounts.NominalTypeDropdown.visible := false;
     SetDb ( SetUpAccounts.cDb );
     If ( RecToRead > 0 ) And ( RecToRead <= db1.dbrechigh ) Then
        Begin
              If //(( RecToRead >= Cash1.xbankmax ) Or // TGM remmed this out 20/01/03 to allow controll a/c balances to be corrected.
                         (( RecToRead = Cash1.xnomsldisc ) Or
                         ( RecToRead = Cash1.xnompldisc ) Or
                         ( RecToRead = Cash1.xnomdeprec ))
              Then begin
                           SetUpAccounts.Savenom.enabled := false;
                           SetUpAccounts.Delaccount.enabled := false;
              end
                 else begin
                      SetUpAccounts.Savenom.enabled := true;
                      SetUpAccounts.Delaccount.enabled := ( not(TfmFarmSyncSettings.SyncConfigured(AccsDataModule.CurrentDatabase)) );
                 end;
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
                     if NOT Cash11.xBilling then // Donot show the products
                        try
                           // Cancel in case they change record but click on the grid without
                           // Saving
                           AccsDataModule.NominalList.Cancel;
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


                     if (((RecToRead >=Cash1.xNomCaFrom) and (RectoRead <=Cash1.xNomCaTo)) or
                        ((RecToRead >=Cash1.xNomFaFrom) and (RecToRead <=Cash1.xNomFaTo)) or
                        ((RecToRead >=Cash1.xNomIncFrom) and (RecToRead <=Cash1.xNomOhTo))) then begin

                                 SetupAccounts.Deprec_edit.visible := false;
                                 SetupAccounts.Depreclabel.visible := false;
                                 SetupAccounts.Deprec_edit2.visible := false;
                                 SetupAccounts.Depreclabel2.visible := false;
                                 SetUpAccounts.TypeLabel.visible := false;
                                 SetUpAccounts.NominalTypeDropdown.visible := false;

                                 if (((RecToRead >=Cash1.xNomCaFrom) and (RectoRead <=Cash1.xNomCaTo)) or
                                     ((RecToRead >=Cash1.xNomFaFrom) and (RecToRead <=Cash1.xNomFaTo))) then begin
                                         SetupAccounts.Deprec_edit.visible := true;
                                         SetupAccounts.Depreclabel.visible := true;
                                         SetupAccounts.Deprec_edit2.visible := true;
                                         SetupAccounts.Depreclabel2.visible := true;
                                         getitem(NLFile,101);
                                         DoubleToStr(currlong,currstr,'%10.2f',true,true,12,true);
                                         SetupAccounts.Deprec_edit.text := currstr;
                                         getitem(NLFile,102);
                                         DoubleToStr(currlong,currstr,'%10.2f',true,true,12,true);
                                         SetupAccounts.Deprec_edit2.text := currstr;
                                 end;
                                 if  ((RecToRead >=Cash1.xNomIncFrom) and (RecToRead <=Cash1.xNomOhTo) and (Accsdatamodule.linkedtoherd)) then begin
                                     SetUpAccounts.TypeLabel.visible := true;
                                     SetUpAccounts.NominalTypeDropdown.visible := true;
                                     Getitem(NLFile, 103);
                                     if currstr = 'L' then Setupaccounts.NominalTypeDropdown.ItemIndex := 1
                                        else if  currstr = 'P' then Setupaccounts.NominalTypeDropdown.ItemIndex := 2
                                             else if currstr = 'O' then Setupaccounts.NominalTypeDropdown.ItemIndex := 3
                                                  else if currstr = 'U' then Setupaccounts.NominalTypeDropdown.ItemIndex := 4
                                                  else Setupaccounts.NominalTypeDropdown.ItemIndex := 0;

                                 end;



                     end // if in ranges
                           else begin
                                SetupAccounts.Deprec_edit.visible := false;
                                SetupAccounts.Depreclabel.visible := false;
                                SetupAccounts.Deprec_edit2.visible := false;
                                SetupAccounts.Depreclabel2.visible := false;
                                SetUpAccounts.TypeLabel.visible := false;
                                SetUpAccounts.NominalTypeDropdown.visible := false;
                           end;
                End;  // end if recactive

             if SetUpAccounts.ControlAccounts.checked then begin
                   if ((RecToRead = cash1.XNOMDEBTOR) or (RecToRead = cash1.XNOMCREDIT)) then SetUpAccounts.NomBalance.enabled := false
                      else SetUpAccounts.NomBalance.enabled := true;
             end
        End; // end RecToRead
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

     SetupAccounts.Deprec_edit.visible := false;
     SetupAccounts.Depreclabel.visible := false;
     SetUpAccounts.TypeLabel.visible := false;
     SetUpAccounts.NominalTypeDropdown.visible := false;
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

             if NOT Cash11.xBilling then // Dont show the products
                try
                   if AccsDatamodule.NominalList.State in dsEditmodes then
                      AccsDataModule.NominalList.Post;
                 if SetupAccounts.cbProductsNoms.KeyValue > 0 then
                      begin
                         SetItem;
                         CurrLong := AccsDataModule.Products.FieldByName('ID').AsInteger;
                         PutItem (SetUpAccounts.cDb,6);
                      end else begin
                         SetItem;
                         CurrLong := 0;
                         PutItem (SetUpAccounts.cDb,6);
                      end;
                except
                   ShowMessage('Cannot add Product to Nominal Account');
                end;

             CurrInt := StrToInt ( SetUpAccounts.NomRepGroup.Text );
             CurrStr := SetUpAccounts.NomGroupDesc.Text;

             WriteTables ( SetUpAccounts.cDb, CurrInt, CurrStr );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.NomVatCode.Text, 20 );
             { Rewrite the record before adding inbalance }
             Rewriterec ( SetUpAccounts.cDb, SetUpAccounts.RecNo );
             dberr;

             StrLong ( SetUpAccounts.NomBalance.Text, CurrLong );
             CheckAccType ( SetUpAccounts.RecNo, CurrLong );
       {      If SetUpAccounts.ShowOpening.Checked Then
                PutItem ( SetUpAccounts.cDb, 22 )
             Else
                PutItem ( SetUpAccounts.cDb, 2 );
        }    // TGM AB removed this code to repair issues when setting up liability accounts
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
        End
     else
        begin
           SetDB(NlFile);
           SetUpAccounts.AddAmendDelete := '';
           SetUpAccounts.AddEntAccount.Enabled := False;
        end;
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
   ContainsArchiveData : Boolean;   // TGM AB 18/01/13
begin
     If SetUpAccounts.RecNo > 0 Then
        Begin
             SetDb ( SetUpAccounts.cDb );
             ReadRec ( SetUpAccounts.cDb, SetUpAccounts.RecNo );
             dberr;
             ContainsArchiveData := False;   // TGM AB 18/01/13
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

             //   03/09/18 [V4.3 R1.2] /MK Incorporated Changes from Andrew (TGM) - DeleteNominalAccount - Don't allow delete of nominal if it was used in job card or proforma.
             If OkToDelete Then begin                                                                           // Ch005
                        if CheckProformaTableForNominal(SetUpAccounts.RecNo) = true then OkToDelete := False;   // Ch005
             end;                                                                                               // Ch005
             

             If OkToDelete then begin
                GetItem ( SetUpAccounts.cdb, 7 );           // BudgYear
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 17 );          // YearTot1
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 18 );          // YearTot2
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 19 );          // YearTot3
                if currlong <> 0 then ContainsArchiveData := true;

                GetItem ( SetUpAccounts.cdb, 33 );          // BudPer01
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 34 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 35 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 36 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 37 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 38 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 39 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 40 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 41 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 42 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 43 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 44 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 45 );          // BudPer13
                if currlong <> 0 then ContainsArchiveData := true;

                GetItem ( SetUpAccounts.cdb, 65 );          // LstPer01
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 66 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 67 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 68 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 69 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 70 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 71 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 72 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 73 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 74 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 75 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 76 );
                if currlong <> 0 then ContainsArchiveData := true;
                GetItem ( SetUpAccounts.cdb, 77 );          // LstPer13
                if currlong <> 0 then ContainsArchiveData := true;

             end;

             If (OkToDelete and (ContainsArchiveData = false)) Then
                Begin
                     If MessageDlg('Delete Account ' +
                        SetUpAccounts.NomGrid.Cells[0,SetUpAccounts.NomGrid.Row] + ' ' +
                        SetUpAccounts.NomGrid.Cells[1,SetUpAccounts.NomGrid.Row],
                        mtInformation, [mbYes, mbNo], 0) = mrYes  Then
                          Begin
                               DeleteRecord ( SetUpAccounts.cDb, SetUpAccounts.Recno, False );
                               FillNomGrid ( GetAccountRanges ); { refresh the nominal Grid }
                          End;
                End
             Else if (OkToDelete and (ContainsArchiveData = True)) Then        // TGM AB 18/01/13
                 begin
                     If MessageDlg('Account ' +
                        SetUpAccounts.NomGrid.Cells[0,SetUpAccounts.NomGrid.Row] + ' ' +
                        SetUpAccounts.NomGrid.Cells[1,SetUpAccounts.NomGrid.Row] + ' - Contains no current year data but has previous year figues, do you wish to transfer these to another nominal code before deleting?',
                        mtInformation, [mbYes, mbNo], 0) = mrYes  Then
                          Begin
                              TransferNominal( strtoint(SetUpAccounts.NomGrid.Cells[0,SetUpAccounts.NomGrid.Row]));
                          End
                              else begin
                                         If MessageDlg('Are you sure you wish to delete this Nominal Code along with the previous year data?',
                                            mtInformation, [mbYes, mbNo], 0) = mrYes then begin
                                                                                                DeleteRecord ( SetUpAccounts.cDb, SetUpAccounts.Recno, False );
                                                                                                FillNomGrid ( GetAccountRanges ); { refresh the nominal Grid }
                                            end;
                              end;
                 end else
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

Procedure TransferNominal(FromNL : integer);
Var
    ToNL, i : integer;
    RecordValue : Array [1..30] of Long;
Begin
   // TGM AB Procedure transfers previous year data into another nominal code and deletes old code

   ToNL := 0;

   for i:= 1 to 30 do begin
       RecordValue[i] := 0;
   end;

   ReadRec ( SetUpAccounts.cDb, FromNL );

   GetItem ( SetUpAccounts.cdb, 7 );           // BudgYear
   RecordValue[1] := currlong;
   GetItem ( SetUpAccounts.cdb, 17 );          // YearTot1
   RecordValue[2] := currlong;
   GetItem ( SetUpAccounts.cdb, 18 );          // YearTot2
   RecordValue[3] := currlong;
   GetItem ( SetUpAccounts.cdb, 19 );          // YearTot3
   RecordValue[4] := currlong;

   GetItem ( SetUpAccounts.cdb, 33 );          // BudPer01
   RecordValue[5] := currlong;
   GetItem ( SetUpAccounts.cdb, 34 );
   RecordValue[6] := currlong;
   GetItem ( SetUpAccounts.cdb, 35 );
   RecordValue[7] := currlong;
   GetItem ( SetUpAccounts.cdb, 36 );
   RecordValue[8] := currlong;
   GetItem ( SetUpAccounts.cdb, 37 );
   RecordValue[9] := currlong;
   GetItem ( SetUpAccounts.cdb, 38 );
   RecordValue[10] := currlong;
   GetItem ( SetUpAccounts.cdb, 39 );
   RecordValue[11] := currlong;
   GetItem ( SetUpAccounts.cdb, 40 );
   RecordValue[12] := currlong;
   GetItem ( SetUpAccounts.cdb, 41 );
   RecordValue[13] := currlong;
   GetItem ( SetUpAccounts.cdb, 42 );
   RecordValue[14] := currlong;
   GetItem ( SetUpAccounts.cdb, 43 );
   RecordValue[15] := currlong;
   GetItem ( SetUpAccounts.cdb, 44 );
   RecordValue[16] := currlong;
   GetItem ( SetUpAccounts.cdb, 45 );          // BudPer13
   RecordValue[17] := currlong;

   GetItem ( SetUpAccounts.cdb, 65 );          // LstPer01
   RecordValue[18] := currlong;
   GetItem ( SetUpAccounts.cdb, 66 );
   RecordValue[19] := currlong;
   GetItem ( SetUpAccounts.cdb, 67 );
   RecordValue[20] := currlong;
   GetItem ( SetUpAccounts.cdb, 68 );
   RecordValue[21] := currlong;
   GetItem ( SetUpAccounts.cdb, 69 );
   RecordValue[22] := currlong;
   GetItem ( SetUpAccounts.cdb, 70 );
   RecordValue[23] := currlong;
   GetItem ( SetUpAccounts.cdb, 71 );
   RecordValue[24] := currlong;
   GetItem ( SetUpAccounts.cdb, 72 );
   RecordValue[25] := currlong;
   GetItem ( SetUpAccounts.cdb, 73 );
   RecordValue[26] := currlong;
   GetItem ( SetUpAccounts.cdb, 74 );
   RecordValue[27] := currlong;
   GetItem ( SetUpAccounts.cdb, 75 );
   RecordValue[28] := currlong;
   GetItem ( SetUpAccounts.cdb, 76 );
   RecordValue[29] := currlong;
   GetItem ( SetUpAccounts.cdb, 77 );          // LstPer13
   RecordValue[30] := currlong;

   Showmessage('Please Select the nominal code you wish to transfer the archive data to');

   NewListBox.ListIt (SetUpAccounts.DelAccount, AllNoms, 'N' );
   if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then begin

               ToNL := strtoint(NewListBox.ListInfo.ReturnValue);


                ReadRec ( SetUpAccounts.cDb, ToNL );

                GetItem ( SetUpAccounts.cdb, 7 );           // BudgYear
                currlong := currlong + RecordValue[1];
                PutItem ( SetUpAccounts.cdb, 7 );
                GetItem ( SetUpAccounts.cdb, 17 );          // YearTot1
                currlong := currlong + RecordValue[2];
                PutItem ( SetUpAccounts.cdb, 17 );
                GetItem ( SetUpAccounts.cdb, 18 );          // YearTot2
                Currlong := currlong + RecordValue[3];
                PutItem ( SetUpAccounts.cdb, 18 );
                GetItem ( SetUpAccounts.cdb, 19 );          // YearTot3
                currlong := currlong + RecordValue[4];
                PutItem ( SetUpAccounts.cdb, 19 );

                GetItem ( SetUpAccounts.cdb, 33 );          // BudPer01
                currlong := currlong + RecordValue[5];
                PutItem ( SetUpAccounts.cdb, 33 );
                GetItem ( SetUpAccounts.cdb, 34 );
                currlong := currlong + RecordValue[6];
                PutItem ( SetUpAccounts.cdb, 34 );
                GetItem ( SetUpAccounts.cdb, 35 );
                currlong := currlong + RecordValue[7];
                PutItem ( SetUpAccounts.cdb, 35 );
                GetItem ( SetUpAccounts.cdb, 36 );
                currlong := currlong + RecordValue[8];
                PutItem ( SetUpAccounts.cdb, 36 );
                GetItem ( SetUpAccounts.cdb, 37 );
                currlong := currlong + RecordValue[9];
                PutItem ( SetUpAccounts.cdb, 37 );
                GetItem ( SetUpAccounts.cdb, 38 );
                currlong := currlong + RecordValue[10];
                PutItem ( SetUpAccounts.cdb, 38 );
                GetItem ( SetUpAccounts.cdb, 39 );
                currlong := currlong + RecordValue[11];
                PutItem ( SetUpAccounts.cdb, 39 );
                GetItem ( SetUpAccounts.cdb, 40 );
                currlong := currlong + RecordValue[12];
                PutItem ( SetUpAccounts.cdb, 40 );
                GetItem ( SetUpAccounts.cdb, 41 );
                currlong := currlong + RecordValue[13];
                PutItem ( SetUpAccounts.cdb, 41 );
                GetItem ( SetUpAccounts.cdb, 42 );
                currlong := currlong + RecordValue[14];
                PutItem ( SetUpAccounts.cdb, 42 );
                GetItem ( SetUpAccounts.cdb, 43 );
                currlong := currlong + RecordValue[15];
                PutItem ( SetUpAccounts.cdb, 43 );
                GetItem ( SetUpAccounts.cdb, 44 );
                currlong := currlong + RecordValue[16];
                PutItem ( SetUpAccounts.cdb, 44 );
                GetItem ( SetUpAccounts.cdb, 45 );          // BudPer13
                currlong := currlong + RecordValue[17];
                PutItem ( SetUpAccounts.cdb, 45 );

                GetItem ( SetUpAccounts.cdb, 65 );          // LstPer01
                currlong := currlong + RecordValue[18];
                PutItem ( SetUpAccounts.cdb, 65 );
                GetItem ( SetUpAccounts.cdb, 66 );
                currlong := currlong + RecordValue[19];
                PutItem ( SetUpAccounts.cdb, 66 );
                GetItem ( SetUpAccounts.cdb, 67 );
                currlong := currlong + RecordValue[20];
                PutItem ( SetUpAccounts.cdb, 67 );
                GetItem ( SetUpAccounts.cdb, 68 );
                currlong := currlong + RecordValue[21];
                PutItem ( SetUpAccounts.cdb, 68 );
                GetItem ( SetUpAccounts.cdb, 69 );
                currlong := currlong + RecordValue[22];
                PutItem ( SetUpAccounts.cdb, 69 );
                GetItem ( SetUpAccounts.cdb, 70 );
                currlong := currlong + RecordValue[23];
                PutItem ( SetUpAccounts.cdb, 70 );
                GetItem ( SetUpAccounts.cdb, 71 );
                currlong := currlong + RecordValue[24];
                PutItem ( SetUpAccounts.cdb, 71 );
                GetItem ( SetUpAccounts.cdb, 72 );
                currlong := currlong + RecordValue[25];
                PutItem ( SetUpAccounts.cdb, 72 );
                GetItem ( SetUpAccounts.cdb, 73 );
                currlong := currlong + RecordValue[26];
                PutItem ( SetUpAccounts.cdb, 73 );
                GetItem ( SetUpAccounts.cdb, 74 );
                currlong := currlong + RecordValue[27];
                PutItem ( SetUpAccounts.cdb, 74 );
                GetItem ( SetUpAccounts.cdb, 75 );
                currlong := currlong + RecordValue[28];
                PutItem ( SetUpAccounts.cdb, 75 );
                GetItem ( SetUpAccounts.cdb, 76 );
                currlong := currlong + RecordValue[29];
                PutItem ( SetUpAccounts.cdb, 76 );
                GetItem ( SetUpAccounts.cdb, 77 );          // LstPer13
                currlong := currlong + RecordValue[30];
                PutItem ( SetUpAccounts.cdb, 77 );

                Rewriterec( SetUpAccounts.cDb, ToNL );

                ReadRec ( SetUpAccounts.cDb, FromNL );
                DeleteRecord ( SetUpAccounts.cDb, FromNL, False );
                FillNomGrid ( GetAccountRanges );
           end
               else showmessage('No valid Transfer Account Selected');

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

{function GetBankBalance(const ABankName : string) : Double;
Var
   ArrPos,
   NomRec : Integer;
   AccountRanges  : TAccRange;
begin
   Result := 0;
   AccountRanges[1] := Cash1.xBankMin;
   AccountRanges[2] := Cash1.xBankMax;
   ArrPos := 1;
   NomRec := AccountRanges[1];
   SetDb ( NlFile );
   Repeat
         ReadRec ( NlFile, NomRec );
         dberr;
         If Recactive ( NlFile ) And ( NOT ExcludeNominal ( NomRec )) Then
            Begin
                 GetItem ( NlFile, 1 );
                 if CurrStr = ABankName then
                    begin
                       GetItem ( NlFile, 2 );
                       LongStr ( CurrLong, CurrStr, 'L' );

                       Result := StrToFloat(CurrStr);
                       Break;
                    end;
                 Inc ( ArrPos );
            End;
         Inc ( NomRec );
   until ( NomRec > AccountRanges[2] ) Or ( NomRec = 0 );
   Dec ( ArrPos );
end;}

// Ch005 Start


Function CheckProformaTableForNominal(NLNo : integer) : Boolean;        // Ch005
var
        ProformaQuery : TQuery;
begin

    // This procedure checks if a Nominal Code is saved within any Jobcards, Quotes or Proformas in the Proforma Table.
    // If BatchID = -1 this jobcard/quote/proforma has been transfered over and no longer active

    Result := False;

    if NLNo > 0 then begin
        ProformaQuery := TQuery.Create(nil);
        ProformaQuery.DatabaseName := AccsDataModule.AccsDataBase.DatabaseName;
        ProformaQuery.SQL.Add('Select * From Proforma');
        ProformaQuery.SQL.Add('Where Nominal = ' + vartostr(NLNo) + ' and BatchID <> -1');
        ProformaQuery.open;
        if ProformaQuery.recordcount <> 0 then Result := True;
        ProformaQuery.free;
    end;

end;

// Ch005 end
end.
