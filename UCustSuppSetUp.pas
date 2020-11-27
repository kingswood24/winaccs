{
   Use   : SetUp Nominal Accounts

   13/12/16 [V4.2 R4.6] /MK Additional Feature - DeleteCustSuppAccount - Add extra check for customers to see if there are job card records.
}

unit UCustSuppSetUp;

interface
uses
    Types, SetUp, accsdata, db, dbTables;
        
Procedure FillCustSuppGrid(searchtext:string);
Procedure FillCustSuppPanel ( RecToRead : Integer );
Procedure NewCustSuppAccount;
Procedure CancelCustSuppAccount;
Procedure DeleteCustSuppAccount;
Procedure SaveCustSuppAccount;
Procedure CustSuppButtonNames;

Var
   WasBalance : Long;
   NoActiveTransactions : Boolean;

implementation
Uses
    Controls,
    Messages,
    Dialogs,
    SysUtils,
    Calcs,
    DBCore,
    DBGen,
    Util,
    Vars,
    LangUnit;



{ Fill the screen Panel with data from the Current RecToRead }
Procedure FillCustSuppPanel ( RecToRead : Integer );
Begin
     SetDb ( SetUpAccounts.cDb );
     NoActiveTransactions := False;
     If ( RecToRead > 0 ) And ( RecToRead <= db1.dbrechigh ) Then
        Begin
             ReadRec ( SetUpAccounts.cDb, RecToRead );
             dberr;
             If Recactive ( SetUpAccounts.cDb ) Then
                Begin
                     SetUpAccounts.CustSuppNo.Text := IntToStr ( RecToRead );
                     GetItem ( SetUpAccounts.cDb, 1 );
                     SetUpAccounts.CustSuppName.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 2 );
                     SetUpAccounts.CustSuppAdd1.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 3 );
                     SetUpAccounts.CustSuppAdd2.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 4 );
                     SetUpAccounts.CustSuppAdd3.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 5 );
                     SetUpAccounts.CustSuppAdd4.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 22 );
                     SetUpAccounts.CustSuppAreaCode.Text := IntToStr ( CurrInt );
                     GetItem ( SetUpAccounts.cDb, 23 );
                     SetUpAccounts.CustSuppPostCode.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 21 );
                     SetUpAccounts.CustSuppFaxNo.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 27 );
                     SetUpAccounts.CustSuppVATNo.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 19 );
                     SetUpAccounts.CustSuppPhone1.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 20 );
                     SetUpAccounts.CustSuppPhone2.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 25 );
                     SetUpAccounts.CustSuppContact1.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 26);
                     SetUpAccounts.CustSuppContact2.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 24 );
                     SetUpAccounts.CustSuppRefCode.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 28 );
                     SetUpAccounts.CustSuppComment.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 32 );
                     SetUpAccounts.CustSuppEmailAddress.Text := CurrStr;

                     { Store original balance }
                     GetItem ( SetUpAccounts.cDb, 7 );
                     WasBalance := CurrLong;
                     LongStr ( CurrLong, CurrStr, 'L' );
                     SetUpAccounts.CustSuppOpenBalance.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 8 );
                     LongStr ( CurrLong, CurrStr, 'L' );
                     SetUpAccounts.CustSuppTurnOver.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 9 );
                     LongStr ( CurrLong, CurrStr, 'L' );
                     SetUpAccounts.CustSuppAgeCurr.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 10 );
                     LongStr ( CurrLong, CurrStr, 'L' );
                     SetUpAccounts.CustSuppAged1.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 11 );
                     LongStr ( CurrLong, CurrStr, 'L' );
                     SetUpAccounts.CustSuppAged2.Text := CurrStr;
                     GetItem ( SetUpAccounts.cDb, 12 );
                     LongStr ( CurrLong, CurrStr, 'L' );
                     SetUpAccounts.CustSuppAged3.Text := CurrStr;
                     SetUpAccounts.RecNo := RecToRead;

                     { Check for Active Transactions }
                     GetItem ( SetUpAccounts.cDb, 15 );
                     NoActiveTransactions := ( Currint = 0 );
                     If NoActiveTransactions Then
                        Begin
                             GetItem ( SetUpAccounts.cDb, 16 );
                             NoActiveTransactions := ( Currint = 0 );
                        End;
                     If NoActiveTransactions Then
                        Begin
                             SetUpAccounts.CustSuppTurnover.Enabled := false; // TGM AB
                             SetUpAccounts.CustSuppOpenBalance.Enabled := True;
                             SetUpAccounts.CustSuppAgeCurr.Enabled := True;
                             SetUpAccounts.CustSuppAged1.Enabled := True;
                             SetUpAccounts.CustSuppAged2.Enabled := True;
                             SetUpAccounts.CustSuppAged3.Enabled := True;
                        End
                     Else
                        Begin
                             SetUpAccounts.CustSuppTurnover.Enabled := False;
                             SetUpAccounts.CustSuppOpenBalance.Enabled := False;
                             SetUpAccounts.CustSuppAgeCurr.Enabled := False;
                             SetUpAccounts.CustSuppAged1.Enabled := False;
                             SetUpAccounts.CustSuppAged2.Enabled := False;
                             SetUpAccounts.CustSuppAged3.Enabled := False;
                        End;
                End;
        End;
End;

{ Fill the CustSuppGrid With the Current Nominal Ledger File }
Procedure FillCustSuppGrid(searchtext:string);
Var
   LastCustSupp,
   ArrPos,
   CustSuppRec : Integer;
   tempstr : string;
   sstring : shortstring;
Begin
     ArrPos := 1;
     SetUpAccounts.CustSuppGrid.Cells[2,ArrPos] := '';
     SetUpAccounts.CustSuppGrid.Cells[1,ArrPos] := '';
     SetUpAccounts.CustSuppGrid.Cells[0,ArrPos] := '';
     CustSuppRec := 1;
     SetDb ( SetUpAccounts.cDb );
     LastCustSupp := db1.dbrechigh;

     if SetUpAccounts.cDb = PLFile then begin
     Repeat
           accsdatamodule.PLFileDB.locate('PLNo',CustSuppRec,[]);

           If accsdatamodule.PLFileDB['Active'] = true Then Begin
                   tempstr := vartostr(accsdatamodule.PLFileDB['Name']);
                   if ((setupAccounts.searchbox.text = '') or (pos(UpperCase(SetupAccounts.searchbox.text),UPPERCase(Tempstr)) > 0)) then begin
                        SetUpAccounts.CustSuppGrid.Cells[0,ArrPos] := IntToStr ( CustSuppRec );
                        SetUpAccounts.CustSuppGrid.Cells[1,ArrPos] := Tempstr;
                        // TGM AB 12/08/02 edited to show no balance in cashbook system
                        if not cash1.xcashbook then begin
                               // tempstr := vartostr(accsdatamodule.PLFileDB['Balance']);
                                DoubletoStr(accsdatamodule.PLFileDB['Balance'], sstring , '%8.2f', True, False, 10, True);
                                SetUpAccounts.CustSuppGrid.Cells[2,ArrPos] := sstring;
                        end;
                        // End TGM AB
                        Inc ( ArrPos );
                   end;
              End;
           Inc ( CustSuppRec );
     Until ( CustSuppRec > LastcustSupp  ) Or ( CustSuppRec = 0 );

     end
     else begin

     Repeat
           accsdatamodule.SLFileDB.locate('SLNo',CustSuppRec,[]);

           If accsdatamodule.SLFileDB['Active'] = true Then Begin
                   tempstr := vartostr(accsdatamodule.SLFileDB['Name']);
                   if ((setupAccounts.searchbox.text = '') or (pos(UpperCase(SetupAccounts.searchbox.text),UPPERCase(Tempstr)) > 0)) then begin
                        SetUpAccounts.CustSuppGrid.Cells[0,ArrPos] := IntToStr ( CustSuppRec );
                        SetUpAccounts.CustSuppGrid.Cells[1,ArrPos] := Tempstr;
                        // TGM AB 12/08/02 edited to show no balance in cashbook system
                        if not cash1.xcashbook then begin
                               // tempstr := vartostr(accsdatamodule.SLFileDB['Balance']);
                                DoubletoStr(accsdatamodule.SLFileDB['Balance'], sstring , '%8.2f', True, False, 10, True);
                                SetUpAccounts.CustSuppGrid.Cells[2,ArrPos] := sstring;
                        end;
                        // End TGM AB
                        Inc ( ArrPos );
                   end;
              End;
           Inc ( CustSuppRec );
     Until ( CustSuppRec > LastcustSupp  ) Or ( CustSuppRec = 0 );

     end; // else begin

     Dec ( ArrPos );
     If ArrPos > 0 Then
        SetUpAccounts.CustSuppGrid.RowCount := ArrPos+1
     Else If ArrPos <= 0 Then
          SetUpAccounts.CustSuppGrid.RowCount := 2;

     If Numeric ( SetUpAccounts.CustSuppGrid.Cells[0, 1]) Then
        FillCustSuppPanel ( StrToInt (SetUpAccounts.CustSuppGrid.Cells[0, SetUpAccounts.CustSuppGrid.Row]));

     //If SetUpAccounts.CustSuppGrid.CanFocus Then
     //   SetUpAccounts.CustSuppGrid.SetFocus;
End;

Function CheckAgedBalance : Boolean;
Var
   AccountBalance,
   TotalAged : Long;
Begin
     CheckAgedBalance := True;
     StrLong ( SetUpAccounts.CustSuppOpenBalance.Text, AccountBalance );
     StrLong ( SetUpAccounts.CustSuppAgeCurr.Text, TotalAged );
     StrLong ( SetUpAccounts.CustSuppAged1.Text, CurrLong );
     TotalAged := TotalAged + CurrLong;
     StrLong ( SetUpAccounts.CustSuppAged2.Text, CurrLong );
     TotalAged := TotalAged + CurrLong;
     StrLong ( SetUpAccounts.CustSuppAged3.Text, CurrLong );
     TotalAged := TotalAged + CurrLong;
     If TotalAged <> AccountBalance Then
        Begin
             CheckAgedBalance := False;
             MessageDlg('Balance/Aged Analysis do not Agree', mtInformation, [mbOk], 0);
             SetUpAccounts.CustSuppOpenBalance.SetFocus;
        End;
End;

Procedure SaveCustSuppAccount;
Var
   NewBalance : Long;
Begin
     If ( SetUpAccounts.RecNo > 0 ) And CheckAgedBalance Then
        Begin
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppName.Text, 1 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppAdd1.Text, 2 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppAdd2.Text, 3 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppAdd3.Text, 4 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppAdd4.Text, 5 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppPostCode.Text, 23 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppFaxNo.Text, 21 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppVATNo.Text, 27 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppPhone1.Text, 19 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppPhone2.Text, 20 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppContact1.Text, 25 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppContact2.Text, 26 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppRefCode.Text, 24 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppComment.Text, 28 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.CustSuppEmailAddress.Text, 32 );

             CurrInt := StrToInt ( SetUpAccounts.CustSuppAreaCode.Text );
             PutItem ( SetUpAccounts.cDb, 22 );

             { Only save financial info if allowed to enter it }
             If NoActiveTransactions Then
                Begin
                     StrLong ( SetUpAccounts.CustSuppOpenBalance.Text, CurrLong );
                     NewBalance := CurrLong;
                     PutItem ( SetUpAccounts.cDb, 6 );
                     Currlong := NewBalance;
                     PutItem ( SetUpAccounts.cDb, 7 );
                     Currlong := NewBalance;
                     PutItem ( SetUpAccounts.cDb, 17 );

                     StrLong ( SetUpAccounts.CustSuppTurnover.Text, CurrLong );
                     PutItem ( SetUpAccounts.cDb, 8 );
                     StrLong ( SetUpAccounts.CustSuppAgeCurr.Text, CurrLong );
                     PutItem ( SetUpAccounts.cDb, 9 );
                     StrLong ( SetUpAccounts.CustSuppAged1.Text, CurrLong );
                     PutItem ( SetUpAccounts.cDb, 10 );
                     StrLong ( SetUpAccounts.CustSuppAged2.Text, CurrLong );
                     PutItem ( SetUpAccounts.cDb, 11 );
                     StrLong ( SetUpAccounts.CustSuppAged3.Text, CurrLong );
                     PutItem ( SetUpAccounts.cDb, 12 );

                     WasBalance := 0-WasBalance;
                     If SetUpAccounts.Customers.Checked Then
                        Begin
                             SetUpAccounts.LogNom ( NlFile, Cash1.xNomDebtor, Cash1.xNomOpen, WasBalance );
                             SetUpAccounts.LogNom ( NlFile, Cash1.xNomDebtor, Cash1.xNomOpen, NewBalance );
                        End
                     Else
                        Begin
                             SetUpAccounts.LogNom ( NlFile, Cash1.xNomOpen, Cash1.xNomCredit, WasBalance );
                             SetUpAccounts.LogNom ( NlFile, Cash1.xNomOpen, Cash1.xNomCredit, NewBalance );
                        End;
                End;
             Rewriterec ( SetUpAccounts.cDb, SetUpAccounts.RecNo );
             dberr;

             FillCustSuppGrid('');
        End;
End;

Procedure AddNewCustSuppAccount ( Accno : Integer );
Begin
     If AccNo > 0 Then
        Begin
             BlankRec ( SetUpAccounts.cDb, 'A' );
             AddRecord ( SetUpAccounts.cDb, AccNo, False );
             FillCustSuppPanel ( AccNo );
             SetUpAccounts.CustSuppName.SetFocus;
        End;
End;

Procedure NewCustSuppAccount;
Var
   AccRange    : TAccRange;
Begin
     AccRange[1] := 1;
     AccRange[2] := -1;    { Set to this to indicate use full range of records }

     If SetUpAccounts.Customers.Checked Then
        AddNewCustSuppAccount ( GetNextFreeAccount ( SetUpAccounts.cDb, AccRange ))
     Else If SetUpAccounts.Suppliers.Checked Then
        AddNewCustSuppAccount ( GetNextFreeAccount ( SetUpAccounts.cDb, AccRange ))
     Else MessageDlg('Select Account Type', mtInformation, [mbOk], 0);
End;

procedure DeleteCustSuppAccount;
var
   OkToDelete : Boolean;
   CurrentBalance : Long;

   function HasActiveProformaTrans ( ACustSuppID : Integer ) : Boolean;
   begin
      Result := False;
      if ( ACustSuppID = 0 ) then Exit;
      with TQuery.Create(nil) do
         try
            DatabaseName := AccsDataModule.CurrentDatabase;
            SQL.Clear;
            SQL.Add('SELECT *');
            SQL.Add('FROM Proforma');
            SQL.Add('WHERE CustID = '+IntToStr(ACustSuppID)+'');
            try
               Open;
               Result := ( RecordCount > 0 );
            except
               on e : Exception do
                  ShowMessage(e.Message);
            end;
         finally
            Free;
         end;
   end;

begin
   if ( SetUpAccounts.RecNo > 0 ) then
      begin
         SetDb ( SetUpAccounts.cDb );
         ReadRec ( SetUpAccounts.cDb, SetUpAccounts.RecNo );
         dberr;
         GetItem ( SetUpAccounts.cdb, 7 );
         CurrentBalance := CurrLong;
         GetItem ( SetUpAccounts.cDb, 8 );
         OkToDelete := ( CurrLong = 0 );

         //   13/12/16 [V4.2 R4.6] /MK Additional Feature - Add extra check for customers to see if there are job card records.
         if ( OkToDelete ) then
            if  ( SetUpAccounts.cDb = SLFile ) then
               OkToDelete := ( not(HasActiveProformaTrans(SetUpAccounts.RecNo)) );

         if ( OkToDelete ) then
            begin
               GetItem ( SetUpAccounts.cdb, 15 );
               OkToDelete := ( Currint = 0 );
               if OkToDelete Then
                  begin
                       GetItem ( SetUpAccounts.cdb, 16 );
                       OkToDelete := ( Currint = 0 );
                  end;
            end;

         if ( OkToDelete ) then
            begin
               if ( MessageDlg('Delete Account ' +
                               SetUpAccounts.CustSuppGrid.Cells[0,SetUpAccounts.CustSuppGrid.Row] + ' ' +
                               SetUpAccounts.CustSuppGrid.Cells[1,SetUpAccounts.CustSuppGrid.Row],
                               mtInformation, [mbYes, mbNo], 0) = mrYes ) Then
                  begin
                     DeleteRecord ( SetUpAccounts.cDb, SetUpAccounts.Recno, False );
                     FillCustSuppGrid(''); { Refresh the CsutSupp Grid }
                     if ( CurrentBalance <> 0 ) then
                        begin
                           CurrentBalance := 0-CurrentBalance;
                           if SetUpAccounts.Customers.Checked Then
                              SetUpAccounts.LogNom ( NlFile, Cash1.xNomDebtor, Cash1.xNomOpen, CurrentBalance )
                           else
                               If SetUpAccounts.Suppliers.Checked Then
                                  SetUpAccounts.LogNom ( NlFile, Cash1.xNomOpen, Cash1.xNomCredit, CurrentBalance );
                        end;
                  end;
            end
         else
             MessageDlg('This Account has Active Details - Delete Rejected',
                              mtInformation, [mbOk], 0);
      end;
end;

Procedure CancelCustSuppAccount;
Begin
     If SetUpAccounts.AddAmendDelete = 'ADD' Then
        DeleteRecord ( SetUpAccounts.cDb, SetUpAccounts.RecNo, False );
     SetUpAccounts.AddAmendDelete := '';
     FillCustSuppGrid('');
End;


Procedure CustSuppButtonNames;
Begin
    With SetUpAccounts Do
         Begin
              Customers.Caption := ReadLang ( 74, CurrLang );
              Suppliers.Caption := ReadLang ( 75, CurrLang );

              LabelCustSuppNo.Caption := ReadLang ( 76, CurrLang );
              LabelCustSuppName.Caption := ReadLang ( 61, CurrLang );
              LabelCustSuppAddress.Caption := ReadLang ( 77, CurrLang );
              LabelCustSuppRefCode.Caption := ReadLang ( 78, CurrLang );
              LabelCustSuppComment.Caption := ReadLang ( 79, CurrLang );
              LabelCustSuppAreaCode.Caption := ReadLang ( 80, CurrLang );
              LabelCustSuppPostCode.Caption := ReadLang ( 81, CurrLang );
              LabelCustSuppFax.Caption := ReadLang ( 82, CurrLang );
              LabelCustSuppContact1.Caption := ReadLang ( 83, CurrLang );
              LabelCustSuppContact2.Caption := ReadLang ( 84, CurrLang );
              LabelCustSuppPhone1.Caption := ReadLang ( 85, CurrLang );
              LabelCustSuppPhone2.Caption := ReadLang ( 86, CurrLang );
              LabelCustSuppVatNo.Caption := ReadLang ( 87, CurrLang );
              LabelCustSuppAgeCurr.Caption := ReadLang ( 88, CurrLang );
              LabelCustSuppAged1.Caption := ReadLang ( 89, CurrLang );
              LabelCustSuppAged2.Caption := ReadLang ( 90, CurrLang );
              LabelCustSuppAged3.Caption := ReadLang ( 91, CurrLang );
              LabelCustSuppTurnOver.Caption := ReadLang ( 92, CurrLang );
              LabelCustSuppBalance.Caption := ReadLang ( 93, CurrLang );

              SaveNom.Caption := ReadLang ( 26, CurrLang );
              CancelNominalChanges.Caption := ReadLang ( 70, CurrLang );
              AddAccount.Caption := ReadLang ( 69, CurrLang );
              DelAccount.Caption := ReadLang ( 68, CurrLang );
              NomHelp.Caption := ReadLang ( 48, CurrLang );
         End;
End;

end.
