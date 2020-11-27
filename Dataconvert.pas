unit Dataconvert;

{ TGM AB - 20/08/04
 This unit contains the procedures that transfer the data from the old
 Binary Files into new Paradox Files
}

interface                   

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, UTIL, Vars, TYPES, DBCore, AccsData, ChkComp, calcs;

  procedure ProcessNLFile(Sender: TObject);
  procedure ProcessSLFile(Sender: TObject);
  procedure ProcessPLFile(Sender: TObject);
  Procedure ProcessTransactionFile(Sender : TObject);
  procedure ProcessNLGroups;
  procedure ProcessEntsFile;

implementation

procedure ProcessNLFile(Sender: TObject);
var
   RECNO : Integer;
   OldNLFile : Integer;
begin
       OldNLFile := ImportFile;
       // process & export the Nlfile info
       Accsdatamodule.NlFileDB.EmptyTable;
       Accsdatamodule.NlFileDB.Open;
       try AccsDataModule.NlaccsExtDB.Open;
       except
       end;
       SetDB(NLFile);
       SETDB (OldNlFile);
       For RECNO:= 1 TO DB1.DBRECHIGH DO
           BEGIN
           Accsdatamodule.nlfileDB.Append;
           READREC(OldNLFile,RECNO);
        //   CURRREC [OldNlFile]:=RecNo;
           if RecActive(OldNLFile) then Accsdatamodule.NlfileDB.FieldValues['Active'] := True
              else Accsdatamodule.NlfileDB.FieldValues['Active'] := false;
        //    Accsdatamodule.nlfileDB.FieldValues['NLNo'] := RecNo;
            Getitem(OldNlFile,1);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.nlfileDB.FieldValues['Name'] := Currstr;
            Getitem(OldNlFile,2);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['Balance'] := CurrLong/100;
            Getitem(OldNlFile,3);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['StPeriod'] := CurrLong/100;
            Getitem(OldNlFile,4);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['StYear'] := CurrLong/100;
            Getitem(OldNlFile,5);
            if CurrStr = '8224' then CurrStr := '0';
            Accsdatamodule.nlfileDB.FieldValues['RepGroup'] := Currstr;
            Getitem(OldNlFile,6);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['StWeek'] := CurrLong/100;
            Getitem(OldNlFile,7);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudgYear'] := CurrLong/100;
            Getitem(OldNlFile,14);
            Accsdatamodule.nlfileDB.FieldValues['FirstBank'] := Currint;
            Getitem(OldNlFile,15);
            Accsdatamodule.nlfileDB.FieldValues['FirstTx'] := Currint;
            Getitem(OldNlFile,16);
            Accsdatamodule.nlfileDB.FieldValues['LastTx'] := Currint;
            Getitem(OldNlFile,17);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['YearTot1'] := CurrLong/100;
            Getitem(OldNlFile,18);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['YearTot2'] := CurrLong/100;
            Getitem(OldNlFile,19);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['YearTot3'] := CurrLong/100;
            Getitem(OldNlFile,20);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.nlfileDB.FieldValues['TaxCode'] := Currstr;
            Getitem(OldNlFile,21);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.nlfileDB.FieldValues['RepFlag'] := Currstr;
            Getitem(OldNlFile,22);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BalanceSt'] := CurrLong/100;
            Getitem(OldNlFile,24);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.nlfileDB.FieldValues['Enterprise'] := Currstr;

            if ((RECNO >=Cash1.xNomIncFrom) and (RecNo <=Cash1.xNomIncTo)) then Accsdatamodule.nlfileDB.FieldValues['Category'] := 'EI';
            if ((RECNO >=Cash1.xNomNonFrom) and (RecNo <=Cash1.xNomNonTo)) then Accsdatamodule.nlfileDB.FieldValues['Category'] := 'NEI';
            if ((RECNO >=Cash1.xNomExpFrom) and (RecNo <=Cash1.xNomExpTo)) then Accsdatamodule.nlfileDB.FieldValues['Category'] := 'EE';
            if ((RECNO >=Cash1.xNomOhFrom) and (RecNo <=Cash1.xNomOhTo)) then Accsdatamodule.nlfileDB.FieldValues['Category'] := 'OH';
            if ((RECNO >=Cash1.xNomCaFrom) and (RecNo <=Cash1.xNomCaTo)) then Accsdatamodule.nlfileDB.FieldValues['Category'] := 'CA';
            if ((RECNO >=Cash1.xNomFaFrom) and (RecNo <=Cash1.xNomFaTo)) then Accsdatamodule.nlfileDB.FieldValues['Category'] := 'FA';
            if ((RECNO >=Cash1.xNomLiFrom) and (RecNo <=Cash1.xNomLiTo)) then Accsdatamodule.nlfileDB.FieldValues['Category'] := 'LI';
            if ((RECNO >=Cash1.xBankMin) and (RecNo <=Cash1.xBankMax)) then Accsdatamodule.nlfileDB.FieldValues['Category'] := 'BA';
            if ((RECNO >=Cash1.xBankMax+1) and (RecNo <=Cash1.xnomopen + cash11.xno_of_partners)) then Accsdatamodule.nlfileDB.FieldValues['Category'] := 'CTRL';

            if (AccsDataModule.NlaccsExtDB.Locate('NominalID',Recno,[] )) then begin
               Accsdatamodule.nlfileDB.FieldValues['DepRate'] := AccsDataModule.NlaccsExtDB.FieldValues['DepRate'];
               Accsdatamodule.nlfileDB.FieldValues['DepAmount'] := AccsDataModule.NlaccsExtDB.FieldValues['DepAmount'];
               Accsdatamodule.nlfileDB.FieldValues['NominalType'] := AccsDataModule.NlaccsExtDB.FieldValues['NominalType'];
               //    Accsdatamodule.nlfileDB.FieldValues['Category'] := AccsDataModule.NlaccsExtDB.FieldValues['Category'];  - Category Recalculated above
            end;

            Getitem(OldNlFile,33);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer01'] := CurrLong/100;
            Getitem(OldNlFile,34);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer02'] := CurrLong/100;
            Getitem(OldNlFile,35);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer03'] := CurrLong/100;
            Getitem(OldNlFile,36);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer04'] := CurrLong/100;
            Getitem(OldNlFile,37);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer05'] := CurrLong/100;
            Getitem(OldNlFile,38);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer06'] := CurrLong/100;
            Getitem(OldNlFile,39);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer07'] := CurrLong/100;
            Getitem(OldNlFile,40);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer08'] := CurrLong/100;
            Getitem(OldNlFile,41);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer09'] := CurrLong/100;
            Getitem(OldNlFile,42);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer10'] := CurrLong/100;
            Getitem(OldNlFile,43);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer11'] := CurrLong/100;
            Getitem(OldNlFile,44);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer12'] := CurrLong/100;
            Getitem(OldNlFile,45);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['BudPer13'] := CurrLong/100;


            Getitem(OldNlFile,49);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer01'] := CurrLong/100;
            Getitem(OldNlFile,50);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer02'] := CurrLong/100;
            Getitem(OldNlFile,51);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer03'] := CurrLong/100;
            Getitem(OldNlFile,52);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer04'] := CurrLong/100;
            Getitem(OldNlFile,53);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer05'] := CurrLong/100;
            Getitem(OldNlFile,54);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer06'] := CurrLong/100;
            Getitem(OldNlFile,55);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer07'] := CurrLong/100;
            Getitem(OldNlFile,56);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer08'] := CurrLong/100;
            Getitem(OldNlFile,57);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer09'] := CurrLong/100;
            Getitem(OldNlFile,58);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer10'] := CurrLong/100;
            Getitem(OldNlFile,59);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer11'] := CurrLong/100;
            Getitem(OldNlFile,60);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer12'] := CurrLong/100;
            Getitem(OldNlFile,61);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['ActPer13'] := CurrLong/100;


            Getitem(OldNlFile,65);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer01'] := CurrLong/100;
            Getitem(OldNlFile,66);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer02'] := CurrLong/100;
            Getitem(OldNlFile,67);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer03'] := CurrLong/100;
            Getitem(OldNlFile,68);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer04'] := CurrLong/100;
            Getitem(OldNlFile,69);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer05'] := CurrLong/100;
            Getitem(OldNlFile,70);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer06'] := CurrLong/100;
            Getitem(OldNlFile,71);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer07'] := CurrLong/100;
            Getitem(OldNlFile,72);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer08'] := CurrLong/100;
            Getitem(OldNlFile,73);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer09'] := CurrLong/100;
            Getitem(OldNlFile,74);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer10'] := CurrLong/100;
            Getitem(OldNlFile,75);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer11'] := CurrLong/100;
            Getitem(OldNlFile,76);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer12'] := CurrLong/100;
            Getitem(OldNlFile,77);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.nlfileDB.FieldValues['LstPer13'] := CurrLong/100;
            Accsdatamodule.nlfileDB.post;


        end;
       Accsdatamodule.nlfileDB.close;
       AccsDataModule.NlaccsExtDB.close;

end;

procedure ProcessSLFile(Sender: TObject);
var
   RECNO : Integer;
begin
     // process & dump the Slfile

       SETDB (SlFile);
       Accsdatamodule.SlFileDB.EmptyTable;
       Accsdatamodule.SlFileDB.Open;
       For RECNO:= 1 TO DB1.DBRECHIGH DO
           BEGIN
           Accsdatamodule.slfileDB.Append;
           READREC(SLFile,RECNO);
           if RecActive(SLFile) then Accsdatamodule.slfileDB.FieldValues['Active'] := True
              else Accsdatamodule.slfileDB.FieldValues['Active'] := false;
          //  Accsdatamodule.slfileDB.FieldValues['SLNo'] := RecNo;
            Getitem(SlFile,1);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['Name'] := Currstr;
            Getitem(SlFile,2);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['Address1'] := Currstr;
             Getitem(SlFile,3);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['Address2'] := Currstr;
             Getitem(SlFile,4);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['Address3'] := Currstr;
             Getitem(SlFile,5);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['Address4'] := Currstr;
            Getitem(slFile,6);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slfileDB.FieldValues['BalanceBf'] := CurrLong/100;
            Getitem(slFile,7);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slfileDB.FieldValues['Balance'] := CurrLong/100;
            Getitem(slFile,8);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slfileDB.FieldValues['Turnover'] := CurrLong/100;
            Getitem(slFile,9);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slfileDB.FieldValues['AgeCurr'] := CurrLong/100;
            Getitem(slFile,10);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slfileDB.FieldValues['Age1'] := CurrLong/100;
            Getitem(slFile,11);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slfileDB.FieldValues['Age2'] := CurrLong/100;
            Getitem(slFile,12);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slfileDB.FieldValues['Age3'] := CurrLong/100;
            Getitem(slFile,13);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slfileDB.FieldValues['NotAlloc'] := CurrLong/100;
            Getitem(slFile,14);
            Accsdatamodule.slfileDB.FieldValues['FirstYear'] := Currint;
            Getitem(slFile,15);
            Accsdatamodule.slfileDB.FieldValues['FirstTx'] := Currint;
            Getitem(slFile,16);
            Accsdatamodule.slfileDB.FieldValues['LastTx'] := Currint;
            Getitem(slFile,17);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slfileDB.FieldValues['BalanceSt'] := CurrLong/100;
{            Getitem(slFile,18);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['Pay-Date'] := StrToDate(CurrStr);}
            Getitem(SlFile,19);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['PhoneNo1'] := Currstr;
            Getitem(SlFile,20);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['PhoneNo2'] := Currstr;
            Getitem(SlFile,21);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['FaxNo'] := Currstr;
            Getitem(slFile,22);
            if CurrInt = 8224 then CurrInt := 0;
            Accsdatamodule.slfileDB.FieldValues['AreaCode'] := Currint;
            Getitem(SlFile,23);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['PostCode'] := Currstr;
            Getitem(SlFile,24);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['CustRef'] := Currstr;
            Getitem(SlFile,25);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['Contact1'] := Currstr;
            Getitem(SlFile,26);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['Contact2'] := Currstr;
            Getitem(SlFile,27);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['VatNo'] := Currstr;
            Getitem(SlFile,28);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['Comment1'] := Currstr;
            Getitem(SlFile,29);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['Comment2'] := Currstr;
            Getitem(SlFile,30);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slfileDB.FieldValues['Comment3'] := Currstr;
            Accsdatamodule.slfileDB.post;

           end;
           Accsdatamodule.slfileDB.close;

end;

procedure ProcessPLFile(Sender: TObject);
var
   RECNO : Integer;
begin
     // process & dump the Plfile

       SETDB (SlFile);
       Accsdatamodule.plfileDB.EmptyTable;
       Accsdatamodule.plfileDB.Open;
       For RECNO:= 1 TO DB1.DBRECHIGH DO
           BEGIN
           Accsdatamodule.plfileDB.Append;
           READREC(PLFile,RECNO);
           if RecActive(PLFile) then Accsdatamodule.plfileDB.FieldValues['Active'] := True
              else Accsdatamodule.plfileDB.FieldValues['Active'] := false;
          //  Accsdatamodule.plfileDB.FieldValues['PLNo'] := RecNo;
            Getitem(plFile,1);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['Name'] := Currstr;
            Getitem(plFile,2);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['Address1'] := Currstr;
            Getitem(plFile,3);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['Address2'] := Currstr;
             Getitem(plFile,4);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['Address3'] := Currstr;
             Getitem(plFile,5);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['Address4'] := Currstr;
            Getitem(plFile,6);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.plfileDB.FieldValues['BalanceBf'] := CurrLong/100;
            Getitem(plFile,7);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.plfileDB.FieldValues['Balance'] := CurrLong/100;
            Getitem(plFile,8);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.plfileDB.FieldValues['Turnover'] := CurrLong/100;
            Getitem(plFile,9);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.plfileDB.FieldValues['AgeCurr'] := CurrLong/100;
            Getitem(plFile,10);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.plfileDB.FieldValues['Age1'] := CurrLong/100;
            Getitem(plFile,11);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.plfileDB.FieldValues['Age2'] := CurrLong/100;
            Getitem(plFile,12);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.plfileDB.FieldValues['Age3'] := CurrLong/100;
            Getitem(plFile,13);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.plfileDB.FieldValues['NotAlloc'] := CurrLong/100;
            Getitem(plFile,14);
            Accsdatamodule.plfileDB.FieldValues['FirstYear'] := Currint;
            Getitem(plFile,15);
            Accsdatamodule.plfileDB.FieldValues['FirstTx'] := Currint;
            Getitem(plFile,16);
            Accsdatamodule.plfileDB.FieldValues['LastTx'] := Currint;
            Getitem(plFile,17);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.plfileDB.FieldValues['BalanceSt'] := CurrLong/100;
{            Getitem(slFile,18);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['Pay-Date'] := StrToDate(CurrStr);}
            Getitem(plFile,19);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['PhoneNo1'] := Currstr;
            Getitem(plFile,20);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['PhoneNo2'] := Currstr;
            Getitem(plFile,21);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['FaxNo'] := Currstr;
            Getitem(plFile,22);
            if CurrInt = 8224 then CurrInt := 0;
            Accsdatamodule.plfileDB.FieldValues['AreaCode'] := Currint;
            Getitem(plFile,23);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['PostCode'] := Currstr;
            Getitem(plFile,24);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['CustRef'] := Currstr;
            Getitem(plFile,25);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['Contact1'] := Currstr;
            Getitem(plFile,26);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['Contact2'] := Currstr;
            Getitem(plFile,27);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['VatNo'] := Currstr;
            Getitem(plFile,28);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['Comment1'] := Currstr;
            Getitem(plFile,29);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['Comment2'] := Currstr;
            Getitem(plFile,30);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.plfileDB.FieldValues['Comment3'] := Currstr;
            Accsdatamodule.plfileDB.post;

           end;
           Accsdatamodule.plfileDB.close;

end;

Procedure ProcessTransactionFile(Sender : TObject);
var
   RECNO : Integer;
   Tempstr : shortstring;
begin
       Tempstr := '';
       SETDB (TxFile);
       Accsdatamodule.TransactionsDB.EmptyTable;
       Accsdatamodule.TransactionsDB.Open;
       For RECNO:= 1 TO DB1.DBRECHIGH DO
           BEGIN
           Accsdatamodule.TransactionsDB.Append;
           READREC(TxFile,RECNO);
      //      Accsdatamodule.TransactionsDB.FieldValues['ID'] := RecNo;
            Getitem(TxFile,1);
            Accsdatamodule.TransactionsDB.FieldValues['TxType'] := Currint;
            Getitem(TxFile,2);
            if currint <> 0 then begin
               KDateToStr(Currint,Tempstr);
               Accsdatamodule.TransactionsDB.FieldValues['TxDate'] := StrToDate(Tempstr);
            end;
            Getitem(TxFile,3);
            Accsdatamodule.TransactionsDB.FieldValues['Account'] := Currint;
            Getitem(TxFile,4);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransactionsDB.FieldValues['Reference'] := Currstr;
            Getitem(TxFile,5);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransactionsDB.FieldValues['Descript'] := Currstr;
            Getitem(TxFile,6);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.TransactionsDB.FieldValues['Quantity'] := CurrLong/100;
            Getitem(TxFile,7);
            Accsdatamodule.TransactionsDB.FieldValues['Product'] := Currint;
            Getitem(TxFile,8);
            Accsdatamodule.TransactionsDB.FieldValues['Nominal'] := Currint;
            Getitem(TxFile,9);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.TransactionsDB.FieldValues['Amount'] := CurrLong/100;
            Getitem(TxFile,10);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransactionsDB.FieldValues['TaxCode'] := Currstr;
            Getitem(TxFile,11);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.TransactionsDB.FieldValues['TaxDisc'] := CurrLong/100;
            Getitem(TxFile,12);
            Accsdatamodule.TransactionsDB.FieldValues['Analysis'] := Currint;
            Getitem(TxFile,13);
            Accsdatamodule.TransactionsDB.FieldValues['NextDB'] := Currint;
            Getitem(TxFile,14);
            Accsdatamodule.TransactionsDB.FieldValues['NextCR'] := Currint;
            Getitem(TxFile,16);
            Accsdatamodule.TransactionsDB.FieldValues['NextSP'] := Currint;
            Getitem(TxFile,17);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.TransactionsDB.FieldValues['NomAmount'] := CurrLong/100;
            Getitem(TxFile,18);
            Accsdatamodule.TransactionsDB.FieldValues['DebitAC'] := Currint;
            Getitem(TxFile,19);
            Accsdatamodule.TransactionsDB.FieldValues['CreditAC'] := Currint;
            Getitem(TxFile,23);
            Accsdatamodule.TransactionsDB.FieldValues['OrigType'] := Currint;
            Getitem(TxFile,24);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransactionsDB.FieldValues['Enterprise'] := Currstr;
            Getitem(TxFile,26);
            Accsdatamodule.TransactionsDB.FieldValues['StubNo'] := Currstr;
            Getitem(TxFile,27);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransactionsDB.FieldValues['BankRec'] := Currstr;
            Getitem(TxFile,28);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransactionsDB.FieldValues['EditStat'] := Currstr;
            Getitem(TxFile,29);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.TransactionsDB.FieldValues['AmtPaid'] := CurrLong/100;
            Getitem(TxFile,30);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransactionsDB.FieldValues['Allocated'] := Currstr;
            Getitem(TxFile,31);
            if currint <> 0 then begin
               KDateToStr(Currint,Tempstr);
               Accsdatamodule.TransactionsDB.FieldValues['DateDue'] := StrToDate(Tempstr);
            end;

            Accsdatamodule.TransactionsDB.post;
           end;
           Accsdatamodule.TransactionsDB.close;
end;

procedure ProcessNLGroups;
var
   i : integer;
begin
// group listing

       Accsdatamodule.NLGroupsDB.Open;
       For i:= 1 TO 999 DO
           BEGIN
           Accsdatamodule.NLGroupsDB.locate('GroupNo',i,[]);
           Accsdatamodule.NLGroupsDB.edit;
           ReadTables ( NLFile, i, CurrStr );
           If Currstr <> COPY(SPACE40,1,32) Then Accsdatamodule.NLGroupsDB['Active'] := true
              else Accsdatamodule.NLGroupsDB['Active'] := false;
           Accsdatamodule.NLGroupsDB['GroupDesc'] := currstr;
           Accsdatamodule.NLGroupsDB.post;
           end;
       Accsdatamodule.NLGroupsDB.close;
end;

procedure ProcessEntsFile;
var
   RECNO : Integer;
begin

       SETDB (EntFile);
       Accsdatamodule.EntsFileDB.EmptyTable;
       Accsdatamodule.EntsFileDB.Open;
       For RECNO:= 1 TO DB1.DBRECHIGH DO
           BEGIN
           Accsdatamodule.EntsfileDB.Append;
           READREC(EntFile,RECNO);
           if RecActive(EntFile) then Accsdatamodule.EntsfileDB.FieldValues['Active'] := True
              else Accsdatamodule.EntsfileDB.FieldValues['Active'] := false;
            Getitem(EntFile,1);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.EntsfileDB.FieldValues['EntCode'] := Currstr;
            Getitem(EntFile,2);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.EntsfileDB.FieldValues['EntName'] := Currstr;
            Getitem(EntFile,3);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.EntsfileDB.FieldValues['UnitDiv'] := CurrLong/100;
            Getitem(EntFile,4);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.EntsfileDB.FieldValues['UnitText'] := Currstr;
            Getitem(Entfile,6);
            Accsdatamodule.EntsfileDB.FieldValues['IncFrom'] := Currint;
            Getitem(Entfile,7);
            Accsdatamodule.EntsfileDB.FieldValues['IncTo'] := Currint;
            Getitem(Entfile,8);
            Accsdatamodule.EntsfileDB.FieldValues['ExpFrom'] := Currint;
            Getitem(Entfile,9);
            Accsdatamodule.EntsfileDB.FieldValues['ExpTo'] := Currint;
            Getitem(Entfile,10);
            Accsdatamodule.EntsfileDB.FieldValues['CosFrom'] := Currint;
            Getitem(Entfile,11);
            Accsdatamodule.EntsfileDB.FieldValues['CosTo'] := Currint;
            Accsdatamodule.EntsfileDB.post;
       end;
end;

end.
