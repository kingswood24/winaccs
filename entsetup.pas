{
Use   : SetUp Enterprise Accounts Plus Income/Expenditure
}
unit UEntSetUp;

interface
Uses
    Types,
    SetUp;
      
Procedure FillEntGrid;
Procedure FillEntPanel ( RecToRead : Integer );
Procedure FillEntAccountPanel ( RecToRead : Integer );
Procedure SaveEnterpriseAccount;
Procedure NewEntNominalAccount;
Procedure DeleteEnterprise;
Procedure DeleteEntNominalAccount;
Function  GetAccountRanges : TAccRange;
Procedure CancelEntNominalAccount;
Procedure EnterpriseButtonNames;
Function DuplicatesFound ( TestStr : String; CurrRecNo : Integer ) : Boolean;
Procedure SaveEntNominalAccount;
Procedure NewEnterprise;
Procedure CancelNewEnterprise;
Function CheckAvailability ( NoRequested : Integer; AccountType : Char; Var StartRec : Integer ) : Boolean;

implementation
Uses
    Listing,
    Controls,
    Messages,
    Dialogs,
    SysUtils,
    Calcs,
    DBCore,
    DBGen,
    Clears,
    Util,
    Vars,
    AccsData,
    LangUnit;

  {* Check to see if a Report Group is in use }
Function GroupInUse ( Cdb, CGroup, rfrom, rto : Integer ) : Boolean;
Var
   Counter : Integer;
Begin
     GroupInUse := False;
     If (( CGroup >= rfrom ) And
	 ( CGroup <= rto )) Then
	Begin
	   For counter := rfrom To rto Do
	      Begin
		 Readrec ( Cdb, counter );
		 If recactive ( Cdb ) Then
		    Begin
		       getitem ( Cdb, 5 );
		       If ( currint = CGroup ) Then
			  Begin
			     GroupInUse := True;
			     Exit;
			  End;
		    End;
	      End;
	End
     Else
	If (( CGroup >= rfrom ) And
	    ( CGroup <= rto )) Then
	   Begin
	      For counter := rfrom To rto Do
		 Begin
		    Readrec ( Cdb, counter );
		    If recactive ( Cdb ) Then
		       Begin
			  getitem ( Cdb, 5 );
			  If ( currint = CGroup ) Then
			     Begin
				GroupInUse := True;
				Exit;
			     End;
		       End;
		 End;
	   End;
  End;

Procedure CheckAccType ( AccountToCheck : Integer; Var CLong : Long );
Begin
     If (( AccountToCheck >= Cash1.xnomliFrom ) And
         ( AccountToCheck <= Cash1.xnomliTo )) Or
        (( AccountToCheck >= Cash1.xbankmin ) And
         ( AccountToCheck <= Cash1.xbankmax )) Or
        (( AccountToCheck >= Cash1.xnomcredit ) And
         ( AccountToCheck <= Cash1.xnomcredit )) Or
        (( AccountToCheck >= Cash1.xnomprofit ) And
         ( AccountToCheck <= Cash1.xnomprofit+Cash11.xno_of_partners )) Then
         CLong := 0-CLong;
End;

Procedure FillEntNomGrids ( IncFrom, IncTo, ExpFrom, ExpTo : Integer );
Var
   Loops,
   ArrPos,
   RecCounter,
   RecFrom,
   RecTo    : Integer;
Begin
     SetDb ( NlFile );
     RecFrom := IncFrom;
     RecTo := IncTo;
     Loops := 1;
     ArrPos := 1;
     RecCounter := RecFrom;
     SetUpAccounts.EntIncomeGrid.Cells[0,arrpos] := '';
     SetUpAccounts.EntIncomeGrid.Cells[1,arrpos] := '';
     SetUpAccounts.EntIncomeGrid.Rowcount := 2;
     SetUpAccounts.EntExpendGrid.Cells[0,arrpos] := '';
     SetUpAccounts.EntExpendGrid.Cells[1,arrpos] := '';
     SetUpAccounts.EntExpendGrid.ColWidths[1] := 400;
     SetUpAccounts.EntIncomeGrid.ColWidths[1] := 400;
     SetUpAccounts.EntExpendGrid.Rowcount := 2;

     If ( RecFrom > 0 ) Then
        Repeat
           Repeat
                 ReadRec ( NlFile, RecCounter );
                 dberr;
                 If RecActive ( NlFile ) Then
                    Begin
                         Case Loops Of
                              1 : Begin
                                       SetUpAccounts.EntIncomeGrid.Cells[0,arrpos] := IntToStr ( RecCounter );
                                       GetItem ( NlFile, 1 );
                                       SetUpAccounts.EntIncomeGrid.Cells[1,arrpos] := CurrStr;
                                  End;
                              2 : Begin
                                       SetUpAccounts.EntExpendGrid.Cells[0,arrpos] := IntToStr ( RecCounter );
                                       GetItem ( NlFile, 1 );
                                       SetUpAccounts.EntExpendGrid.Cells[1,arrpos] := CurrStr;
                                  End;
                         End;
                         Inc ( ArrPos );
                    End;
                 Inc ( RecCounter );
           Until ( RecCounter > RecTo );
           Dec ( ArrPos );
           If ( Loops = 1 ) And ( ArrPos > 0 ) Then
              SetUpAccounts.EntIncomeGrid.RowCount := ArrPos+1
           Else If ( Loops = 1 ) And ( ArrPos <= 0 ) Then
              SetUpAccounts.EntIncomeGrid.RowCount := 2
           Else If ( Loops = 2 ) And ( ArrPos > 0 ) Then
                  SetUpAccounts.EntExpendGrid.RowCount := ArrPos+1
           Else If ( Loops = 2 ) And ( ArrPos <= 0 ) Then
                  SetUpAccounts.EntExpendGrid.RowCount := 2;

           Inc ( Loops );
           RecFrom := ExpFrom;
           RecTo := ExpTo;
           ArrPos := 1;
           If RecFrom = 0 Then Loops := 3;
           RecCounter := RecFrom;
        Until (Loops > 2 );
End;

{ Fill the screen Panel with data from the Current RecToRead }
Procedure FillEntPanel ( RecToRead : Integer );
Var
   NomRecToRead,
   IncFrom,
   IncTo,
   ExpFrom,
   ExpTo    : Integer;
Begin
     SetDb ( SetUpAccounts.cDb );
     If ( RecToRead > 0 ) And ( RecToRead <= db1.dbrechigh ) Then
        Begin
             ReadRec ( SetUpAccounts.cDb, RecToRead );
             dberr;
             If Recactive ( SetUpAccounts.cDb ) Then
                Begin
                     GetItem ( SetUpAccounts.cDb, 1 );
                     SetUpAccounts.EntCode.Text := CurrStr;
                     SetUpAccounts.OrigEntCode := CurrStr;
                     Getitem ( SetUpAccounts.cDb, 2 );
                     PadRight ( CurrStr, 20 );
                     SetUpAccounts.EntName.Text := Copy ( CurrStr, 1, 17 );
                     SetUpAccounts.EntPercOverheads.Text := Copy ( CurrStr, 18, 3 );

                     GetItem ( SetUpAccounts.cDb, 3 );
                     LongStr ( CurrLong, CurrStr, 'L' );
                     SetUpAccounts.EntUnitDiv.Text := CurrStr;
                     Getitem ( SetUpAccounts.cDb, 4 );
                     SetUpAccounts.EntUnitName.Text := CurrStr;
                     GetInt ( SetUpAccounts.cDb, 6, IncFrom );
                     SetUpAccounts.EntIncomeFrom.Text := IntToStr ( IncFrom );
                     GetInt ( SetUpAccounts.cDb, 7, IncTo );
                     SetUpAccounts.EntIncomeTo.Text := IntToStr ( IncTo );
                     GetInt ( SetUpAccounts.cDb, 8, ExpFrom );
                     SetUpAccounts.EntExpendFrom.Text := IntToStr ( ExpFrom );
                     GetInt ( SetUpAccounts.cDb, 9, ExpTo );
                     SetUpAccounts.EntExpendTo.Text := IntToStr ( ExpTo );

                     SetUpAccounts.RecNo := RecToRead;
                     If IncFrom = 0 Then
                        SetUpAccounts.NoOfIncomeAccounts.Text := '0'
                     Else
                         SetUpAccounts.NoOfIncomeAccounts.Text := IntToStr ( IncTo-IncFrom+1 );
                     If ExpFrom = 0 Then
                        SetUpAccounts.NoOfExpendAccounts.Text := '0'
                     Else
                         SetUpAccounts.NoOfExpendAccounts.Text := IntToStr ( ExpTo-ExpFrom+1 );

                     FillEntNomGrids ( IncFrom, IncTo, ExpFrom, ExpTo );
                     If SetUpAccounts.EntIncomeRadio.Checked Then
                        Begin
                             NomRecToRead := 0;
                             If Numeric ( SetUpAccounts.EntIncomeGrid.Cells[0, SetUpAccounts.EntIncomeGrid.Row]) Then
                                NomRecToRead := StrToInt ( SetUpAccounts.EntIncomeGrid.Cells[0,
                                                           SetUpAccounts.EntIncomeGrid.Row]);
                             FillEntAccountPanel ( NomRecToRead );
                        End
                     Else If SetUpAccounts.EntExpendRadio.Checked Then
                        Begin
                             NomRecToRead := 0;
                             If Numeric ( SetUpAccounts.EntExpendGrid.Cells[0, SetUpAccounts.EntExpendGrid.Row]) Then
                                NomRecToRead := StrToInt ( SetUpAccounts.EntExpendGrid.Cells[0,
                                                           SetUpAccounts.EntExpendGrid.Row]);
                             FillEntAccountPanel ( NomRecToRead );
                        End
                End;
        End;
End;

{ Fill the screen Panel with data from the Current RecToRead }
Procedure FillEntAccountPanel ( RecToRead : Integer );
Begin

     SetDb ( NlFile );
     If ( RecToRead > 0 ) And ( RecToRead <= db1.dbrechigh ) Then
        Begin
             ReadRec ( NlFile, RecToRead );
             dberr;
             If Recactive ( NlFile ) Then
                Begin
                     SetUpAccounts.EntAccount.Text := IntToStr ( RecToRead );
                     GetItem ( NlFile, 1 );
                     SetUpAccounts.EntAccountName.Text := CurrStr;
                     GetItem ( NlFile, 20 );
                     SetUpAccounts.EntAccountVATNo.Text := CurrStr;
                     // Get the Current Records Product
                     try
                         if AccsDataModule.NominalList.Locate('Account',RecToRead,[] ) then
                            AccsDataModule.Products.Locate('ID',AccsDataModule.NominalList.FieldByName('Product').AsInteger,[] );
                     except

                     end;

                     GetItem ( NlFile, 5 );
                     SetUpAccounts.EntAccountGroupNo.Text := IntToStr ( CurrInt );
                     ReadTables ( NlFile, CurrInt, CurrStr );
                     SlimAll ( CurrStr );
                     SetUpAccounts.EntAccountGroupDesc.Text := CurrStr;
                     SetUpAccounts.EntNomRecNo := RecToRead;
                End;
        End
     Else
         Begin
              SetUpAccounts.EntAccount.Text := '';
              SetUpAccounts.EntAccountName.Text := '';
              SetUpAccounts.EntAccountVATNo.Text := '';
              SetUpAccounts.EntAccountGroupNo.Text := '';
              SetUpAccounts.EntAccountGroupDesc.Text := '';
              SetUpAccounts.EntNomRecNo := RecToRead;
         End;
End;

{ Fill the EntGrid With the Current Enterprise File }
Procedure FillEntGrid;
Var
   LastEnterprise,
   ArrPos,
   EntRec : Integer;
Begin
     ArrPos := 1;
     {
     SetUpAccounts.CustSuppGrid.Cells[2,ArrPos] := '';
     SetUpAccounts.CustSuppGrid.Cells[1,ArrPos] := '';
     SetUpAccounts.CustSuppGrid.Cells[0,ArrPos] := '';
     }
     SetUpAccounts.EntGrid.Cells[2,ArrPos] := '';
     SetUpAccounts.EntGrid.Cells[1,ArrPos] := '';
     SetUpAccounts.EntGrid.Cells[0,ArrPos] := '';
     EntRec := 1;
     SetDb ( SetUpAccounts.cDb );
     LastEnterprise := db1.dbrechigh;

     Repeat
           ReadRec ( SetUpAccounts.cDb, EntRec );
           dberr;
           If Recactive ( SetUpAccounts.cDb ) Then
              Begin
                   SetUpAccounts.EntGrid.Cells[0,ArrPos] := IntToStr ( EntRec );
                   GetItem ( SetUpAccounts.cDb, 1 );
                   SetUpAccounts.EntGrid.Cells[1,ArrPos] := CurrStr;
                   GetItem ( SetUpAccounts.cDb, 2 );
                   PadRight ( CurrStr, 20 );
                   SetUpAccounts.EntGrid.Cells[2,ArrPos] := Copy ( CurrStr, 1, 17 );
                   Inc ( ArrPos );
              End;
           Inc ( EntRec );
     Until ( EntRec > LastEnterprise  ) Or ( EntRec = 0 );
     Dec ( ArrPos );
     If ArrPos > 0 Then
        SetUpAccounts.EntGrid.RowCount := ArrPos+1
     Else If ArrPos <= 0 Then
          SetUpAccounts.EntGrid.RowCount := 2;

     If Numeric ( SetUpAccounts.EntGrid.Cells[0, SetUpAccounts.EntGrid.Row]) Then
        FillEntPanel ( StrToInt (SetUpAccounts.EntGrid.Cells[0, SetUpAccounts.EntGrid.Row]));
     If SetUpAccounts.EntGrid.CanFocus Then
        SetUpAccounts.EntGrid.SetFocus;
End;

Procedure SaveEnterpriseAccount;
Var
    TestCode : ShortString;

    Procedure RefreshNominalAccounts;
    Var
       ValueOfPos,
       Loops,
       RecCounter,
       ArrFrom,
       ArrTo,
       IncFrom,
       IncTo,
       ExpFrom,
       ExpTo    : Integer;
    Begin
         IncFrom := StrToInt ( SetUpAccounts.EntIncomeFrom.Text );
         IncTo   := StrToInt ( SetUpAccounts.EntIncomeTo.Text );
         ArrFrom := IncFrom;
         ArrTo   := IncTo;
         ExpFrom := StrToInt ( SetUpAccounts.EntExpendFrom.Text );
         ExpTo   := StrToInt ( SetUpAccounts.EntExpendTo.Text );
         SetDb ( NlFile );
         Loops := 1;
         Repeat
            If ( ArrFrom > 0 ) Then
               For RecCounter := ArrFrom To ArrTo Do
                   Begin
                        ReadRec ( NlFile, RecCounter );
                        dberr;
                        If RecActive ( NlFile ) Then
                           Begin
                                PutStr ( NlFile, TestCode, 24 );
                                ReWriteRec ( NlFile, RecCounter );
                                dberr;
                           End;
                   End;

               Inc ( Loops );
               ArrFrom := ExpFrom;
               ArrTo   := ExpTo;
         Until ( Loops > 2 );

{-->>         ArrFrom := 1;}
         ArrTo := SetUpAccounts.NomGrid.RowCount;
         RecCounter := 1;
         If SetUpAccounts.AddAmendDeleteEnt <> 'ADD' Then
            While RecCounter <= ArrTo Do
               Begin
                    ValueOfPos := StrToInt ( SetUpAccounts.NomGrid.Cells[0,RecCounter] );
                    If (( ValueOfPos >= IncFrom ) And
                        ( ValueOfPos <= IncTo )) Or
                       (( ValueOfPos >= ExpFrom ) And
                        ( ValueOfPos <= ExpTo )) Then
                        SetUpAccounts.NomGrid.Cells[2,RecCounter] := TestCode;
                    Inc ( RecCounter );
                    If ValueOfPos >= ExpTo Then
                       RecCounter := ArrTo+1;
               End;
    End;

Begin
     If SetUpAccounts.RecNo > 0 Then
        Begin
             ReadRec ( SetUpAccounts.cDb, SetUpAccounts.RecNo );
             dberr;

             PutStr ( SetUpAccounts.cDb, SetUpAccounts.EntCode.Text, 1 );
             CurrStr := SetUpAccounts.EntName.Text;
             PadRight ( CurrStr, 17 );
             SetUpAccounts.EntName.Text := CurrStr;
             CurrStr := SetUpAccounts.EntPercOverheads.Text;
             PadRight ( CurrStr, 3 );
             SetUpAccounts.EntName.Text := SetUpAccounts.EntName.Text + CurrStr;

             PutStr ( SetUpAccounts.cDb, SetUpAccounts.EntName.Text, 2 );
             StrLong ( SetUpAccounts.EntUnitDiv.Text, CurrLong );
             PutItem ( SetUpAccounts.cDb, 3 );
             PutStr ( SetUpAccounts.cDb, SetUpAccounts.EntUnitName.Text, 4 );
             PutInt ( SetUpAccounts.cDb, StrToInt ( SetUpAccounts.EntIncomeFrom.Text ), 6 );
             PutInt ( SetUpAccounts.cDb, StrToInt ( SetUpAccounts.EntIncomeTo.Text ), 7 );
             PutInt ( SetUpAccounts.cDb, StrToInt ( SetUpAccounts.EntExpendFrom.Text ), 8 );
             PutInt ( SetUpAccounts.cDb, StrToInt ( SetUpAccounts.EntExpendTo.Text ), 9 );

             ReWriteRec ( SetUpAccounts.cDb, SetUpAccounts.RecNo );
             dberr;

             TestCode := SetUpAccounts.EntCode.Text;
             SlimAll ( TestCode );
             SlimAll ( SetUpAccounts.OrigEntCode );
             If TestCode <> SetUpAccounts.OrigEntCode Then
                RefreshNominalAccounts;

             FillEntGrid;
             {
             Set the focus to the new record
             SetUpAccounts.EntGrid.TopRow := SetUpAccounts.EntGrid.RowCount-1;
             }
        End;
End;

Procedure AddNewNominalAccount ( Accno : Integer );
Begin
     If AccNo > 0 Then
        Begin
             BlankRec ( NlFile, 'A' );
             AddRecord ( NlFile, AccNo, False );
             FillEntAccountPanel ( AccNo );
             SetUpAccounts.EntAccountName.SetFocus;
        End;
End;

Function GetAccountRanges : TAccRange;
Begin
     GetAccountRanges[1] := 0;
     GetAccountRanges[2] := 0;
     GetAccountRanges[3] := 0;
     GetAccountRanges[4] := 0;
     GetAccountRanges[5] := 0;
     GetAccountRanges[6] := 0;

     If SetUpAccounts.EntIncomeRadio.Checked Then
        Begin
             If ListBox.ListInfo.ListType = 'G'Then
                Begin
                     GetAccountRanges[1] := Cash1.XnomIncFrom;
                     GetAccountRanges[2] := Cash1.XnomIncTo;
                End
             Else
                 Begin
                      GetAccountRanges[1] := StrToInt ( SetUpAccounts.EntIncomeFrom.Text );
                      GetAccountRanges[2] := StrToInt ( SetUpAccounts.EntIncomeTo.Text );
                 End
        End
     Else If SetUpAccounts.EntExpendRadio.Checked Then
        Begin
             If ListBox.ListInfo.ListType = 'G'Then
                Begin
                     GetAccountRanges[1] := Cash1.XnomExpFrom;
                     GetAccountRanges[2] := Cash1.XnomExpTo;
                End
             Else
                 Begin
                      GetAccountRanges[1] := StrToInt ( SetUpAccounts.EntExpendFrom.Text );
                      GetAccountRanges[2] := StrToInt ( SetUpAccounts.EntExpendTo.Text );
                 End;
        End;
End;

Procedure NewEntNominalAccount;
Begin
     If SetUpAccounts.EntIncomeRadio.Checked Then
        AddNewNominalAccount ( GetNextFreeAccount ( NlFile, GetAccountRanges ))
     Else If SetUpAccounts.EntExpendRadio.Checked Then
        AddNewNominalAccount ( GetNextFreeAccount ( NlFile, GetAccountRanges ))
     Else MessageDlg('Select Account Type', mtInformation, [mbOk], 0);
End;

Function DuplicatesFound ( TestStr : String; CurrRecNo : Integer ) : Boolean;
Var
   RecCounter,
   LastEnt : Integer;
   FoundDup : Boolean;
Begin
     SetDb ( SetUpAccounts.cDb );
     LastEnt := db1.dbrechigh;
{-->>     DuplicatesFound := False;}
     FoundDup := False;
     RecCounter := 1;

     While RecCounter <= LastEnt Do
         Begin
              If ( RecCounter <> CurrRecNo ) Then
                 Begin
                      ReadRec ( SetUpAccounts.cDb, RecCounter );
                      dberr;
                      If RecActive ( SetUpAccounts.cDb ) Then
                         Begin
                              GetItem ( SetUpAccounts.cDb, 1 );
                              SlimAll ( CurrStr );
                              FoundDup := ( CurrStr = TestStr );
                              If FoundDup Then
                                 Reccounter := LastEnt;
                         End;
                 End;
              Inc ( RecCounter );
         End;
     DuplicatesFound := FoundDup;
End;

Function CheckForDelete ( AccFrom, AccTo : Integer; Var DelFlag : Boolean ) : Boolean;
Var
   RecCounter : Integer;
Begin
{-->>     CheckForDelete := DelFlag;}
     RecCounter := AccFrom;
     If DelFlag And ( RecCounter > 0 ) Then
        While RecCounter <=AccTo Do
            Begin
                 ReadRec ( NlFile, RecCounter );
                 dberr;
                 If RecActive ( NlFile ) Then
                    Begin
                         GetItem ( NlFile, 2 );

                         DelFlag := ( CurrLong = 0 );
                         If DelFlag Then
                            Begin
                                 GetItem ( NlFile, 14 );
                                 DelFlag := ( Currint = 0 );
                                 If DelFlag Then
                                    Begin
                                         GetItem ( NlFile, 15 );
                                         DelFlag := ( Currint = 0 );
                                    End;
                            End;
                         If NOT DelFlag Then { Record cannot be deleted }
                            RecCounter := AccTo;
                    End;
                 Inc ( RecCounter );
            End;
     CheckForDelete := DelFlag;
End;

Procedure DeleteNomRecords ( AccFrom, AccTo : Integer; IncOrExp : Char );
Var
   CurrGroup,
   RecCounter : Integer;

   Procedure DeleteTable ( Cdb, CGroup : Integer );
   Var
      TabDesc : ShortString;
   Begin
        FillChar ( TabDesc[1], 32, ' ' );
        WriteTables ( cDb, CGroup, TabDesc );
   End;

Begin
     SetDb ( NlFile );
     If ( AccFrom > 0 ) Then
        For RecCounter := AccFrom To AccTo Do
            Begin
              ReadRec ( NlFile, RecCounter );
              dberr;
              If RecActive ( NlFile ) Then
                 Begin
                      GetInt ( NlFile, 5, CurrGroup );
                      DeleteRecord ( NlFile, RecCounter, False );
                      Case IncOrExp Of
                           'I' : If ( Not GroupInUse ( NlFile, CurrGroup, Cash1.xNomIncFrom, Cash1.xNomIncTo )) Then
                                       DeleteTable ( NlFile, CurrGroup );
                           'E' : If ( Not GroupInUse ( NlFile, CurrGroup, Cash1.xNomExpFrom, Cash1.XNomExpTo )) Then
                                       DeleteTable ( NlFile, CurrGroup );
                      End;
                 End;
            End;
End;

Procedure DeleteEnterprise;
Var
   OkToDelete : Boolean;
   IncFrom,
   IncTo,
   ExpFrom,
   ExpTo      : Integer;

begin
     OkToDelete := True;
     If SetUpAccounts.RecNo > 0 Then
        Begin
             SetDb ( SetUpAccounts.cDb );
             ReadRec ( SetUpAccounts.cDb, SetUpAccounts.RecNo );
             dberr;

             GetInt ( SetUpAccounts.cDb, 6, IncFrom );
             GetInt ( SetUpAccounts.cDb, 7, IncTo );
             GetInt ( SetUpAccounts.cDb, 8, ExpFrom );
             GetInt ( SetUpAccounts.cDb, 9, ExpTo );

             OkToDelete := CheckForDelete ( IncFrom, IncTo, OkToDelete );
             OkToDelete := CheckForDelete ( ExpFrom, ExpTo, OkToDelete );

             If OkToDelete Then
                Begin
                     If MessageDlg('Delete Account ' +
                        SetUpAccounts.EntGrid.Cells[1,SetUpAccounts.EntGrid.Row] + ' ' +
                        SetUpAccounts.EntGrid.Cells[2,SetUpAccounts.EntGrid.Row],
                        mtInformation, [mbYes, mbNo], 0) = mrYes  Then
                          Begin
                               DeleteRecord ( SetUpAccounts.cDb, SetUpAccounts.Recno, False );
                               DeleteNomRecords ( IncFrom, IncTo, 'I' );
                               DeleteNomRecords ( ExpFrom, ExpTo, 'E' );
                               FillEntGrid; { Refresh the Nominal Grid }
                          End;
                End
             Else
                 MessageDlg('This Account has Active Details - Delete Rejected',
                                  mtInformation, [mbOk], 0);
        End;
End;

Procedure DeleteEntNominalAccount;
Var
   OkToDelete  : Boolean;
   AccToDelete : Integer;
Begin
     OktoDelete := True;
     AccToDelete := StrToInt ( SetUpAccounts.EntAccount.Text );

     If CheckForDelete ( AccToDelete, AccToDelete, OkToDelete ) Then
        Begin
             If SetUpAccounts.EntIncomeRadio.Checked Then
                Begin
                     If MessageDlg('Delete Account ' +
                        SetUpAccounts.EntAccount.Text + ' ' +
                        SetUpAccounts.EntAccountName.Text,
                        mtInformation, [mbYes, mbNo], 0) = mrYes  Then
                        DeleteNomRecords ( AccToDelete, AccToDelete, 'I' );
                End
             Else If SetUpAccounts.EntExpendRadio.Checked Then
                Begin
                     If MessageDlg('Delete Account ' +
                        SetUpAccounts.EntAccount.Text + ' ' +
                        SetUpAccounts.EntAccountName.Text,
                        mtInformation, [mbYes, mbNo], 0) = mrYes  Then
                        DeleteNomRecords ( AccToDelete, AccToDelete, 'E' );
                End;
             FillEntNomGrids ( StrToInt ( SetUpAccounts.EntIncomeFrom.Text ),
                               StrToInt ( SetUpAccounts.EntIncomeTo.Text ),
                               StrToInt ( SetUpAccounts.EntExpendFrom.Text ),
                               StrToInt ( SetUpAccounts.EntExpendTo.Text ))

        End
     Else
         MessageDlg('This Account has Active Details - Delete Rejected',
                                  mtInformation, [mbOk], 0);
End;

Procedure CancelEntNominalAccount;
Begin
     If SetUpAccounts.AddAmendDelete = 'ADD' Then
        DeleteRecord ( NLFile, SetUpAccounts.EntNomRecNo, False );
     SetUpAccounts.AddAmendDelete := '';
     SetUpAccounts.AddAmendDeleteEnt := '';

     If Numeric ( SetUpAccounts.EntIncomeGrid.Cells[0, SetUpAccounts.EntIncomeGrid.Row]) And
          SetUpAccounts.EntIncomeRadio.Checked Then
        FillEntAccountPanel ( StrToInt (SetUpAccounts.EntIncomeGrid.Cells[0, SetUpAccounts.EntIncomeGrid.Row]))
     Else If Numeric ( SetUpAccounts.EntExpendGrid.Cells[0, SetUpAccounts.EntExpendGrid.Row]) And
          SetUpAccounts.EntExpendRadio.Checked Then
        FillEntAccountPanel ( StrToInt (SetUpAccounts.EntExpendGrid.Cells[0, SetUpAccounts.EntExpendGrid.Row]));
End;

Procedure SaveEntNominalAccount;
Begin
     If SetUpAccounts.EntNomRecNo > 0 Then
        Begin
             ReadRec ( NlFile, SetUpAccounts.EntNomRecNo );
             dberr;

             PutStr ( NlFile, SetUpAccounts.EntAccountName.Text, 1 );
             CurrInt := StrToInt ( SetUpAccounts.EntAccountGroupNo.Text );
             PutItem ( NlFile, 5 );

             try
                if AccsDataModule.Products.FieldByName('ID').AsFloat > 0 then
                   begin
                      SetItem;
                      CurrLong := AccsDataModule.Products.FieldByName('ID').AsInteger;
                      PutItem (NLFile,6);
                   end;
             except
                ShowMessage('Cannot add Product to Nominal Account');
             end;

             CurrStr := SetUpAccounts.EntAccountGroupDesc.Text;
             WriteTables ( NlFile, CurrInt, CurrStr );
             PutStr ( NlFile, SetUpAccounts.EntAccountVatNo.Text, 20 );
             PutStr ( NlFile, SetUpAccounts.EntCode.Text, 24 );

             Rewriterec ( NlFile, SetUpAccounts.EntNomRecNo );
             dberr;
             If Numeric ( SetUpAccounts.EntGrid.Cells[0, SetUpAccounts.EntGrid.Row]) Then
                FillEntPanel ( StrToInt (SetUpAccounts.EntGrid.Cells[0, SetUpAccounts.EntGrid.Row]));
        End;
End;

Procedure EnterpriseButtonNames;
Begin
    With SetUpAccounts Do
         Begin
              EntIncomeRadio.Caption := ReadLang ( 94, CurrLang );
              EntExpendRadio.Caption := ReadLang ( 95, CurrLang );

              LabelEntCode.Name := ReadLang ( 96, CurrLang );
              LabelEntUnitDiv.Name := ReadLang ( 97, CurrLang );
              LabelEntName.Name := ReadLang ( 61, CurrLang );
              LabelEntUnitName.Name := ReadLang ( 98, CurrLang );
              LabelEntPercOverheads.Name := ReadLang ( 99, CurrLang );
              LabelEntAccountName.Name := ReadLang ( 61, CurrLang );
              LabelEntAccount.Name := ReadLang ( 60, CurrLang );
              LabelEntAccountVatNo.Name := ReadLang ( 62, CurrLang );
              LabelEntAccountRepGroup.Name := ReadLang ( 64, CurrLang );
              LabelEntAccountGroupDesc.Name := ReadLang ( 65, CurrLang );
              LabelIncomeHeading.Name := ReadLang ( 102, CurrLang );
              LabelExpendHeading.Name := ReadLang ( 103, CurrLang );

              HelpEntAccount.Caption := ReadLang ( 48, CurrLang );
              SaveEntAccount.Caption := ReadLang ( 26, CurrLang );
              DeleteEntAccount.Caption := ReadLang ( 68, CurrLang );
              AddEntAccount.Caption := ReadLang ( 69, CurrLang );
              CancelEntAccount.Caption := ReadLang ( 70, CurrLang );

              HelpEnterprise.Caption := ReadLang ( 48, CurrLang );
              SaveEnterprise.Caption := ReadLang ( 26, CurrLang );
              DelEnterprise.Caption := ReadLang ( 68, CurrLang );
              AddEnterprise.Caption := ReadLang ( 69, CurrLang );
              CancelEnterprise.Caption := ReadLang ( 70, CurrLang );

         End;
End;

Procedure AddNewEnterprise ( Var AccNo : Integer );
Var
   RecCount,
   LastEnt     : Integer;
   NewRecFound : Boolean;
Begin
     SetDb ( SetUpAccounts.cDb );
     LastEnt := db1.dbrectot;
     AccNo := 0;
     RecCount := 1;
     NewRecFound := False;
     Repeat
           If ( RecCount > 0 ) Then
              Begin
                   ReadRec ( SetUpAccounts.cDb, RecCount );
                   dberr;
                   NewRecFound := ( NOT RecActive ( SetUpAccounts.cDb ));
              End;
           Inc ( RecCount );
     Until ( RecCount <= 0 ) Or ( RecCount > LastEnt ) Or NewRecFound;
     Dec ( RecCount );
     If NewRecFound Then
        AccNo := RecCount
     Else
         MessageDlg('No Free Records Available', mtInformation, [mbOk], 0)
End;

Procedure NewEnterprise;
Var
   AccNo : Integer;
Begin
     AddNewEnterprise ( AccNo );
     If ( AccNo > 0 ) Then
        Begin
             BlankRec ( SetUpAccounts.cDb, 'A' );
             AddRecord ( SetUpAccounts.cDb, AccNo, False );
             FillEntPanel ( AccNo );
             SetUpAccounts.EntCode.SetFocus;
        End;
End;

Procedure CancelNewEnterprise;
Var
   TempStr : ShortString;
Begin
     If SetUpAccounts.AddAmendDeleteEnt = 'ADD' Then
        DeleteRecord ( SetUpAccounts.cDb, SetUpAccounts.RecNo, False );
     SetUpAccounts.AddAmendDeleteEnt := '';
     SetUpAccounts.AddAmendDelete := '';
     TempStr := SetUpAccounts.EntGrid.Cells[0,SetUpAccounts.EntGrid.Row ];
     SlimAll ( TempStr );
     If Numeric ( TempStr ) Then
        FillEntPanel ( StrToInt ( TempStr ));
End;

Function CheckAvailability ( NoRequested : Integer; AccountType : Char; Var StartRec : Integer ) : Boolean;
Var
   RequestOK,
   RecInUse : Boolean;
   CheckFrom,
   CheckTo,
   OriginalDiff,
   RecCounter,
   EndRec,
   Highest : Integer;
   TempStr : ShortString;
Begin
    CheckAvailability := False;
    Highest := 0;
    StartRec := 0;
    RecInUse := False;
    CheckFrom := 0;
    OriginalDiff := 0;

    If ( SetUpAccounts.AddAmendDeleteEnt = 'ADD' ) And ( NoRequested > 0 ) Then
        Begin
             SetDb ( SetUpAccounts.cDb );
             If ( AccountType = 'I' ) Then
                Highest := 0
             Else
                 Highest := Cash1.xNomExpFrom-1;
             For RecCounter := 1 To db1.dbrechigh Do
                 Begin
                      ReadRec ( SetUpAccounts.cDb, RecCounter );
                      dberr;
                      If RecActive ( SetUpAccounts.cDb ) Then
                         Begin
                              If ( AccountType = 'I' ) Then
                                 GetItem ( SetUpAccounts.cDb, 7 )
                              Else If ( AccountType = 'E' ) Then
                                  GetItem ( SetUpAccounts.cDb, 9 );

                              If ( CurrInt > Highest ) Then
                                 Highest := Currint;
                         End;
                 End;
             Inc ( Highest );
        End
        { Amending Old Enterprise Record Need to Check Ranges }
    Else If ( NoRequested > 0 ) Then
        Begin
             If AccountType = 'I' Then
                Begin
                     TempStr := SetUpAccounts.EntIncomeTo.Text;
                     SlimAll ( TempStr );
                     CheckFrom := StrToInt ( TempStr )+1;
                     OriginalDiff := ( StrToInt ( SetUpAccounts.EntIncomeTo.Text ) -
                                       StrToInt ( SetUpAccounts.EntIncomeFrom.Text ))+1;
                     Highest := StrToInt ( SetUpAccounts.EntIncomeFrom.Text );
                End
             Else If AccountType = 'E' Then
                Begin
                     TempStr := SetUpAccounts.EntExpendTo.Text;
                     SlimAll ( TempStr );
                     CheckFrom := StrToInt ( TempStr )+1;
                     OriginalDiff := ( StrToInt ( SetUpAccounts.EntExpendTo.Text ) -
                                       StrToInt ( SetUpAccounts.EntExpendFrom.Text ))+1;
                     Highest := StrToInt ( SetUpAccounts.EntExpendFrom.Text );
                End;
             CheckTo := CheckFrom + ( NoRequested - OriginalDiff )-1;
             SetDb ( NlFile );
             For RecCounter := CheckFrom To CheckTo Do
                 If ( NOT RecInUse ) Then
                    Begin
                       ReadRec ( NlFile, RecCounter );
                       dberr;
                       If RecActive ( NlFile ) Then
                          RecInUse := True;
                    End;
        End;

    EndRec := (Highest-1) + NoRequested;
    RequestOk := (( AccountType = 'I' ) And
                  ( Highest <= Cash1.xNomIncTo ) And
                  ( EndRec <= Cash1.xNomIncTo )) Or
                 (( AccountType = 'E' ) And
                  ( Highest >= Cash1.xNomExpFrom ) And
                  ( Highest <= Cash1.xNomExpTo ) And
                  ( EndRec <= Cash1.xNomExpTo ));

    If RequestOk Then
       If (( NoRequested <= Highest ) And ( NoRequested > 0 )) Or
          (( NoRequested > 0 ) And ( NOT RecInUse )) Then
          Begin
               StartRec := Highest;
               CheckAvailability := ( NOT RecInUse );
          End;
End;

End.
