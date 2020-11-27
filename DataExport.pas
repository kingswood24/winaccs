
unit DataExport;

interface

Uses

  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs,
  UTIL,
  Vars,
  TYPES,
  DBCore,
  Params,
  newListing,
  Calcs,
  Clears, AccsData, ChkComp;
  procedure ProcessNLFile(Sender: TObject);
  procedure ProcessSLFile(Sender: TObject);
  procedure ProcessTransFile(Sender : TObject);
  procedure ProcessGroups;
  procedure CompleteExport;

implementation

(* Category Descriptions

   EI - Enterprise Income
   NEI - Non Enterprise Income
   EE - Enterprise Expenditure
   OH - Overheads
   CA - Current Assets
   FA - Fixed Assets
   LI - Liabilities
   BA - Bank
   CTRL - Control Accounts

*)

procedure ProcessNLFile(Sender: TObject);
var
   RECNO : Integer;
   F : textfile;
   DirString, ProgPath : string;
begin

       DirString := RFarmGate.PLocation[2];
       progpath := ExtractFilePath( ParamStr(0)); //copy(paramstr(0),1,11);
       assignFile(F, progpath + DirString + '\WHerdLink.ini');
       rewrite(F);
       writeln(F,'[FINANCIALYEAR]');
       writeln(F,'Year = ' + varToStr(Cash1.xfinYear));
       writeln(F,'StartMonth = ' + varToStr(Cash1.xfinMonth));
       closefile(F);

       // process & dump the Nlfile
       SETDB (NlFile);
       Accsdatamodule.NlaccsDB.EmptyTable;
       Accsdatamodule.NlaccsDB.Open;

       For RECNO:= 1 TO DB1.DBRECHIGH DO
           BEGIN
           Accsdatamodule.NlaccsDB.Append;
           READREC(NLFile,RECNO);
            Accsdatamodule.NlaccsDB.FieldValues['ID'] := RecNo;
            Getitem(NlFile,1);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.NlaccsDB.FieldValues['Name'] := Currstr;
            Getitem(NlFile,2);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Balance'] := CurrLong/100;
            Getitem(NlFile,3);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['StPeriod'] := CurrLong/100;
            Getitem(NlFile,4);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['StYear'] := CurrLong/100;
            Getitem(NlFile,5);
            if CurrStr = '8224' then CurrStr := '0';
            Accsdatamodule.NlaccsDB.FieldValues['RepGroup'] := Currint;
            Getitem(NlFile,6);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['StWeek'] := CurrLong/100;
            Getitem(NlFile,7);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['BudgYear'] := CurrLong/100;
            Getitem(NlFile,14);
            Accsdatamodule.NlaccsDB.FieldValues['FirstBank'] := Currint;
            Getitem(NlFile,15);
            Accsdatamodule.NlaccsDB.FieldValues['FirstTx'] := Currint;
            Getitem(NlFile,16);
            Accsdatamodule.NlaccsDB.FieldValues['LastTx'] := Currint;
            Getitem(NlFile,17);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['YearTot1'] := CurrLong/100;
            Getitem(NlFile,18);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['YearTot2'] := CurrLong/100;
            Getitem(NlFile,19);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['YearTot3'] := CurrLong/100;
            Getitem(NlFile,20);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.NlaccsDB.FieldValues['TaxCode'] := Currstr;
            Getitem(NlFile,21);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.NlaccsDB.FieldValues['RepFlag'] := Currstr;
            Getitem(NlFile,22);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['BalanceSt'] := CurrLong/100;
            Getitem(NlFile,24);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.NlaccsDB.FieldValues['Enterprise'] := Currstr;

            Getitem(NlFile,101);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['DepRate'] := currlong/100;
            Getitem(NlFile,102);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['DepAmount'] := currlong/100;
            Getitem(NlFile,103);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.NlaccsDB.FieldValues['NominalType'] := currstr;

            if ((RECNO >=Cash1.xNomIncFrom) and (RecNo <=Cash1.xNomIncTo)) then Accsdatamodule.NlaccsDB.FieldValues['Category'] := 'EI';
            if ((RECNO >=Cash1.xNomNonFrom) and (RecNo <=Cash1.xNomNonTo)) then Accsdatamodule.NlaccsDB.FieldValues['Category'] := 'NEI';
            if ((RECNO >=Cash1.xNomExpFrom) and (RecNo <=Cash1.xNomExpTo)) then Accsdatamodule.NlaccsDB.FieldValues['Category'] := 'EE';
            if ((RECNO >=Cash1.xNomOhFrom) and (RecNo <=Cash1.xNomOhTo)) then Accsdatamodule.NlaccsDB.FieldValues['Category'] := 'OH';
            if ((RECNO >=Cash1.xNomCaFrom) and (RecNo <=Cash1.xNomCaTo)) then Accsdatamodule.NlaccsDB.FieldValues['Category'] := 'CA';
            if ((RECNO >=Cash1.xNomFaFrom) and (RecNo <=Cash1.xNomFaTo)) then Accsdatamodule.NlaccsDB.FieldValues['Category'] := 'FA';
            if ((RECNO >=Cash1.xNomLiFrom) and (RecNo <=Cash1.xNomLiTo)) then Accsdatamodule.NlaccsDB.FieldValues['Category'] := 'LI';
            if ((RECNO >=Cash1.xBankMin) and (RecNo <=Cash1.xBankMax)) then Accsdatamodule.NlaccsDB.FieldValues['Category'] := 'BA';
            if ((RECNO >=Cash1.xBankMax+1) and (RecNo <=Cash1.xnomopen + cash11.xno_of_partners)) then Accsdatamodule.NlaccsDB.FieldValues['Category'] := 'CTRL';

        (*
            Getitem(NlFile,33);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-01'] := CurrLong/100;
            Getitem(NlFile,34);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-02'] := CurrLong/100;
            Getitem(NlFile,35);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-03'] := CurrLong/100;
            Getitem(NlFile,36);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-04'] := CurrLong/100;
            Getitem(NlFile,37);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-05'] := CurrLong/100;
            Getitem(NlFile,38);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-06'] := CurrLong/100;
            Getitem(NlFile,39);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-07'] := CurrLong/100;
            Getitem(NlFile,40);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-08'] := CurrLong/100;
            Getitem(NlFile,41);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-09'] := CurrLong/100;
            Getitem(NlFile,42);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-10'] := CurrLong/100;
            Getitem(NlFile,43);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-11'] := CurrLong/100;
            Getitem(NlFile,44);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-12'] := CurrLong/100;
            Getitem(NlFile,45);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Bud-Per-13'] := CurrLong/100;


            Getitem(NlFile,49);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-01'] := CurrLong/100;
            Getitem(NlFile,50);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-02'] := CurrLong/100;
            Getitem(NlFile,51);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-03'] := CurrLong/100;
            Getitem(NlFile,52);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-04'] := CurrLong/100;
            Getitem(NlFile,53);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-05'] := CurrLong/100;
            Getitem(NlFile,54);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-06'] := CurrLong/100;
            Getitem(NlFile,55);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-07'] := CurrLong/100;
            Getitem(NlFile,56);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-08'] := CurrLong/100;
            Getitem(NlFile,57);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-09'] := CurrLong/100;
            Getitem(NlFile,58);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-10'] := CurrLong/100;
            Getitem(NlFile,59);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-11'] := CurrLong/100;
            Getitem(NlFile,60);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-12'] := CurrLong/100;
            Getitem(NlFile,61);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Act-Per-13'] := CurrLong/100;


             Getitem(NlFile,65);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-01'] := CurrLong/100;
            Getitem(NlFile,66);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-02'] := CurrLong/100;
            Getitem(NlFile,67);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-03'] := CurrLong/100;
            Getitem(NlFile,68);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-04'] := CurrLong/100;
            Getitem(NlFile,69);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-05'] := CurrLong/100;
            Getitem(NlFile,70);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-06'] := CurrLong/100;
            Getitem(NlFile,71);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-07'] := CurrLong/100;
            Getitem(NlFile,72);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-08'] := CurrLong/100;
            Getitem(NlFile,73);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-09'] := CurrLong/100;
            Getitem(NlFile,74);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-10'] := CurrLong/100;
            Getitem(NlFile,75);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-11'] := CurrLong/100;
            Getitem(NlFile,76);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-12'] := CurrLong/100;
            Getitem(NlFile,77);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.NlaccsDB.FieldValues['Lst-Per-13'] := CurrLong/100;
            Accsdatamodule.NlaccsDB.post;

        *)
        end;
       Accsdatamodule.NlaccsDB.close;
end;

procedure ProcessSLFile(Sender: TObject);
var
   RECNO : Integer;
begin
     // process & dump the Slfile

       SETDB (SlFile);
       Accsdatamodule.SlaccsDB.close;
       try DeleteFile(pchar(Accsdatamodule.AccsDataBase.Directory + '\slaccs.db'));
       except
       end;
       Accsdatamodule.CreateSlaccsExportTable;
       Accsdatamodule.SlaccsDB.open;

       For RECNO:= 1 TO DB1.DBRECHIGH DO
           BEGIN
           Accsdatamodule.slaccsDB.Append;
           Accsdatamodule.SLFileDB.Locate('SLNo',RecNo,[]);
           if RecActive(Slfile) then
           begin
           READREC(SLFile,RECNO);
            Accsdatamodule.slaccsDB.FieldValues['ID'] := RecNo;
            Getitem(SlFile,1);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Name'] := Currstr;
            Getitem(SlFile,2);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Address1'] := Currstr;
             Getitem(SlFile,3);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Address2'] := Currstr;
             Getitem(SlFile,4);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Address3'] := Currstr;
             Getitem(SlFile,5);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Address4'] := Currstr;
            Getitem(slFile,6);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slaccsDB.FieldValues['BalanceBf'] := CurrLong/100;
            Getitem(slFile,7);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slaccsDB.FieldValues['Balance'] := CurrLong/100;
            Getitem(slFile,8);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slaccsDB.FieldValues['Turnover'] := CurrLong/100;
            Getitem(slFile,9);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slaccsDB.FieldValues['AgeCurr'] := CurrLong/100;
            Getitem(slFile,10);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slaccsDB.FieldValues['Age1'] := CurrLong/100;
            Getitem(slFile,11);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slaccsDB.FieldValues['Age2'] := CurrLong/100;
            Getitem(slFile,12);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slaccsDB.FieldValues['Age3'] := CurrLong/100;
            Getitem(slFile,13);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slaccsDB.FieldValues['NotAlloc'] := CurrLong/100;
            Getitem(slFile,14);
            Accsdatamodule.slaccsDB.FieldValues['FirstYear'] := Currint;
            Getitem(slFile,15);
            Accsdatamodule.slaccsDB.FieldValues['FirstTx'] := Currint;
            Getitem(slFile,16);
            Accsdatamodule.slaccsDB.FieldValues['LastTx'] := Currint;
            Getitem(slFile,17);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.slaccsDB.FieldValues['BalanceSt'] := CurrLong/100;
{            Getitem(slFile,18);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Pay-Date'] := StrToDate(CurrStr);}
            Getitem(SlFile,19);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['PhoneNo1'] := Currstr;
            Getitem(SlFile,20);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['PhoneNo2'] := Currstr;
            Getitem(SlFile,21);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['FaxNo'] := Currstr;
            Getitem(slFile,22);
            Accsdatamodule.slaccsDB.FieldValues['AreaCode'] := Currint;
            Getitem(SlFile,23);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['PostCode'] := Currstr;
            Getitem(SlFile,24);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['CustRef'] := Currstr;
            Getitem(SlFile,25);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Contact1'] := Currstr;
            Getitem(SlFile,26);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Contact2'] := Currstr;
            Getitem(SlFile,27);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['VatNo'] := Currstr;
            Getitem(SlFile,28);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Comment1'] := Currstr;
            Getitem(SlFile,29);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Comment2'] := Currstr;
            Getitem(SlFile,30);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Comment3'] := Currstr;
            Getitem(SlFile,31);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Address5'] := Currstr;
            Getitem(SlFile,32);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.slaccsDB.FieldValues['Email'] := Currstr;
           end;
            Accsdatamodule.slaccsDB.post;
           end;
           Accsdatamodule.slaccsDB.close;
end;


procedure ProcessGroups;
var
   i : integer;
begin
// group listing

       Accsdatamodule.GroupsDB.EmptyTable;
       Accsdatamodule.GroupsDB.Open;
       For i:= 1 TO 999 DO
           BEGIN
           Accsdatamodule.GroupsDB.Append;
           Accsdatamodule.GroupsDB.FieldValues['GroupNo'] := i;
           ReadTables ( NLFile, i, CurrStr );
           Accsdatamodule.GroupsDB.FieldValues['GroupDesc'] := currstr;
           Accsdatamodule.GroupsDB.post;
           end;
       Accsdatamodule.GroupsDB.close;


end;

Procedure ProcessTransFile(Sender : TObject);
var
   RECNO : Integer;
   Tempstr : shortstring;
begin
       Tempstr := '';
       SETDB (TxFile);
       Accsdatamodule.TransDB.EmptyTable;
       Accsdatamodule.TransDB.Open;
       For RECNO:= 1 TO DB1.DBRECHIGH DO
           BEGIN
           Accsdatamodule.TransDB.Append;
           READREC(TxFile,RECNO);
            Accsdatamodule.TransDB.FieldValues['ID'] := RecNo;
            Getitem(TxFile,1);
            Accsdatamodule.TransDB.FieldValues['TxType'] := Currint;
            Getitem(TxFile,2);
            if currint <> 0 then begin
               KDateToStr(Currint,Tempstr);
               Accsdatamodule.TransDB.FieldValues['TxDate'] := StrToDate(Tempstr);
            end;
            Getitem(TxFile,3);
            Accsdatamodule.TransDB.FieldValues['Account'] := Currint;
            Getitem(TxFile,4);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransDB.FieldValues['Reference'] := Currstr;
            Getitem(TxFile,5);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransDB.FieldValues['Descript'] := Currstr;
            Getitem(TxFile,6);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.TransDB.FieldValues['Quantity'] := CurrLong/100;
            Getitem(TxFile,7);
            Accsdatamodule.TransDB.FieldValues['Product'] := Currint;
            Getitem(TxFile,8);
            Accsdatamodule.TransDB.FieldValues['Nominal'] := Currint;
            Getitem(TxFile,9);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.TransDB.FieldValues['Amount'] := CurrLong/100;
            Getitem(TxFile,10);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransDB.FieldValues['TaxCode'] := Currstr;
            Getitem(TxFile,11);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.TransDB.FieldValues['TaxDisc'] := CurrLong/100;
            Getitem(TxFile,12);
            Accsdatamodule.TransDB.FieldValues['Analysis'] := Currint;
            Getitem(TxFile,13);
            Accsdatamodule.TransDB.FieldValues['NextDB'] := Currint;
            Getitem(TxFile,14);
            Accsdatamodule.TransDB.FieldValues['NextCR'] := Currint;
            Getitem(TxFile,16);
            Accsdatamodule.TransDB.FieldValues['NextSP'] := Currint;
            Getitem(TxFile,17);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.TransDB.FieldValues['NomAmount'] := CurrLong/100;
            Getitem(TxFile,18);
            Accsdatamodule.TransDB.FieldValues['DebitAC'] := Currint;
            Getitem(TxFile,19);
            Accsdatamodule.TransDB.FieldValues['CreditAC'] := Currint;
            Getitem(TxFile,23);
            Accsdatamodule.TransDB.FieldValues['OrigType'] := Currint;
            Getitem(TxFile,24);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransDB.FieldValues['Enterprise'] := Currstr;
            Getitem(TxFile,26);
            Accsdatamodule.TransDB.FieldValues['StubNo'] := Currstr;
            Getitem(TxFile,27);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransDB.FieldValues['BankRec'] := Currstr;
            Getitem(TxFile,28);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransDB.FieldValues['EditStat'] := Currstr;
            Getitem(TxFile,29);
            if Currlong = 538976288 then Currlong := 0;
            Accsdatamodule.TransDB.FieldValues['AmtPaid'] := CurrLong/100;
            Getitem(TxFile,30);
            if CurrStr = '8224' then CurrStr := '';
            Accsdatamodule.TransDB.FieldValues['Allocated'] := Currstr;
            Getitem(TxFile,31);
            if currint <> 0 then begin
               KDateToStr(Currint,Tempstr);
               Accsdatamodule.TransDB.FieldValues['DueDate'] := StrToDate(Tempstr);
            end;

            Accsdatamodule.TransDB.post;
           end;
           Accsdatamodule.TransDB.close;
end;



procedure CompleteExport;
Begin

 (*     if accsdatamodule.LinkedToHerd then begin
         FCheckName.CheckForNewFields;
         dataexport.ProcessNLFile(nil);
         dataexport.ProcessSLFile(nil);
         dataexport.Processgroups;
         end
            else begin
                 try Accsdatamodule.NlaccsDB.close
                 except
                 end;
                 Accsdatamodule.NlaccsDB.EmptyTable;
                 Accsdatamodule.NlaccsDB.Open;
                 try Accsdatamodule.SlaccsDB.close
                 except
                 end;
                 Accsdatamodule.SlaccsDB.EmptyTable;
                 Accsdatamodule.SlaccsDB.Open;
            end;
     *)
end;


end.
