unit DigitalVAT;

{

Ch006 - New unit created for UK Digital VAT returns

30/09/19 Ch014 - Report filters updated to show all codes for Northern Ireland Audit Report with exempt codes identifed & totals split out at the bottom between included & exempt.

}

interface

   Type TVatArray = record
      VatCode : String[1];
      VatRate : String;
      VatPercent : String;
      SalesNet : Real;
      SalesVat : Real;
      PurchNet : Real;
      PurchVat : Real;
      NIInclude : boolean;
   end;
   Type TNICodeArray = record
      Box1 : Real;                // VAT Due Sales
      Box2 : Real;                // VAT Due Sales from EC States
      Box3 : Real;                // Total VAT Due
      Box4 : Real;                // VAT Reclaimed (Ine EC States)
      Box5 : Real;                // NET VAT
      Box6 : Real;                // Total Sales Ex VAT
      Box7 : Real;                // Total Purchases Ex VAT
      Box8 : Real;                // Total EC Supplies Ex VAT
      Box9 : Real;                // Total EC Acquisitions Ex VAT
   end;


   Var
   VatCodeArray:array[0..9] of TVatArray;
   NICodeArray:array[0..1] of TNICodeArray;
   FROMDT : TDateTime;
   TODT : TDateTime;
   SalesCount, Purchcount : integer;
   SpanYears : Boolean;


   procedure InitialiseReport(FromDate,ToDate : String);
   procedure CloseReportTable;
   Procedure InvoiceVatAuditTrail(SalePurch : Char; MarkasClaimed : Boolean; ClaimID : Integer; SpanYear : Boolean);
   Procedure GenerateNIFigures;
   Function GetLastSubmissionDate : TDateTime;
   Procedure PaymentVatAuditTrail(SalePurch : Char; MarkasClaimed : Boolean; ClaimID : Integer; SpanYear : Boolean);


implementation

// General Setup / Configuration Procedures

uses AccsData, Vars, SysUtils, FullAudit, Calcs, Clears, DBGen, Types, Dialogs, uDigitalVATForm;

procedure InitialiseReport(FromDate,ToDate : String);
var
        i : integer;
        temprate : real;

begin

        Accsdatamodule.TempVATDB.close;
        Accsdatamodule.TempVATDB.EmptyTable;
        Accsdatamodule.TempVATDB.open;
        Accsdatamodule.TempVATDB.edit;

        // Initialise VAT Array

        for i:= 0 to 9 do begin
         VatCodeArray[i].VatCode := '';
         VatCodeArray[i].VatRate := '';
         VatCodeArray[i].VatPercent := '';
         VatCodeArray[i].SalesNet := 0;
         VatCodeArray[i].SalesVat := 0;
         VatCodeArray[i].PurchNet := 0;
         VatCodeArray[i].PurchVat := 0;
        end;

        for i:= 0 to 9 do Begin
                       VatCodeArray[i].VatCode := Cash1.xTaxIds[i];
                       TempRate := Cash1.xTaxRates[i] / 100;
                       VatCodeArray[i].VatRate := vartostr(Format ( '%f', [TempRate]));
                       if TempRate = 0 then VatCodeArray[i].VatPercent := 'Zero'
                        else VatCodeArray[i].VatPercent := VatCodeArray[i].VatRate + '%';
                       if Cash2.Vat_inc_exc[i] = 'I' then VatCodeArray[i].NIInclude := True
                        else VatCodeArray[i].NIInclude := false;
        End ;



        if FromDate <> '' then begin

                try FROMDT := strtodatetime(FromDate);
                except FROMDT := 0;
                end;

        end;

     //   if  FROMDT < then SpanYears := True;
      //      else SpanYears := False;

   //   CheckDateRange ( TestDate, True, DateBefore, True )

        if ToDate <> '' then begin

                try TODT := strtodatetime(ToDate);
                except TODT := 99999;
                end;

        end;

        SalesCount := 0;
        Purchcount := 0;

        

end;


procedure CloseReportTable;
begin

        Accsdatamodule.TempVATDB.close;
        if FileExists(Accsdata.AccsDataModule.AccsDataBase.Directory + 'TempVAT.db') then deletefile(PCHAR(Accsdata.AccsDataModule.AccsDataBase.Directory + 'TempVAT.db'));



end;




Function GetLastSubmissionDate : TDateTime;
var
        i : integer;
begin


     Result := 0;
     AccsDataModule.VATReturnDB.Open;
     AccsDataModule.VATReturnDB.first;
     for i:= 1 to AccsDataModule.VATReturnDB.recordcount do begin
             if AccsDataModule.VATReturnDB['ReturnDate'] > result then Result :=  AccsDataModule.VATReturnDB['ReturnDate'];
     end;

end;


Procedure GenerateNIFigures;
var
        i, code : integer;
        TextRate : shortstring;
        EuroTransactions : boolean;
        Rate : real;
        TempReal : real;
begin

        NICodeArray[0].Box1 := 0;
        NICodeArray[0].Box2 := 0;
        NICodeArray[0].Box3 := 0;
        NICodeArray[0].Box4 := 0;
        NICodeArray[0].Box5 := 0;
        NICodeArray[0].Box6 := 0;
        NICodeArray[0].Box7 := 0;
        NICodeArray[0].Box8 := 0;
        NICodeArray[0].Box9 := 0;
        EuroTransactions := false;

        for I:= 0 to 9 do Begin
                if VatCodeArray[i].NIInclude then begin
                    NICodeArray[0].Box1 := NICodeArray[0].Box1 + VatCodeArray[i].SalesVat;
                    if ((cash2.XPaymentVAT) and (cash11.xSalesPaymentVAT = 'Y')) then NICodeArray[0].Box6 := NICodeArray[0].Box6 + VatCodeArray[i].SalesNet - VatCodeArray[i].SalesVat
                        else NICodeArray[0].Box6 := NICodeArray[0].Box6 + VatCodeArray[i].SalesNet;
                    NICodeArray[0].Box4 := NICodeArray[0].Box4 + VatCodeArray[i].PurchVat;
                    if ((cash2.XPaymentVAT) and (cash11.xPurchPaymentVAT = 'Y')) then NICodeArray[0].Box7 := NICodeArray[0].Box7 + VatCodeArray[i].PurchNet - VatCodeArray[i].PurchVat
                        else NICodeArray[0].Box7 := NICodeArray[0].Box7 + VatCodeArray[i].PurchNet;
                end;
                if VatCodeArray[i].VatCode = 'E' then begin
                   if ((VatCodeArray[i].PurchNet <> 0.00) or (VatCodeArray[i].SalesNet <> 0)) then EuroTransactions := True;
                end;
        End ;


        if Eurotransactions then begin
        showmessage('Box 9 on your VAT form has a value.' + #13#10
              + 'This comes from transactions entered with VAT Code E.' + #13#10
              + 'VAT Code E should only be used for goods imported from other EC States,' + #13#10
              + 'where these goods would be subject to standard Rate VAT if purchased in UK.' + #13#10
              + 'If you did not import goods in this category, please exit this report and edit the entries where you used VAT Code E, changing the Code E to a UK VAT Code' + #13#10
              + 'otherwise continue, entering the standard rate for VAT when prompted.');
        TextRate := InputBox('VAT Rate For Imports From EC States', 'What VAT Rate to be used for Code E, (Box 9)', '20.0');
        Rate := 0;
        Val(TextRate,Rate,code);
        Rate := (Rate / 100);
                for I:= 0 to 9 do Begin
                        if VatCodeArray[i].VatCode = 'E' then begin
                           Tempreal := (VatCodeArray[i].PurchNet * Rate);

                            // SP 04/04/19 - Round to 2 decimal places
                           Tempreal := Round(Tempreal*100)/100;

                           NICodeArray[0].Box2 := Tempreal;
                           NICodeArray[0].Box4 := NICodeArray[0].box4 + tempreal;
                           NICodeArray[0].Box9 := VatCodeArray[i].PurchNet;
                           NICodeArray[0].Box8 := VatCodeArray[i].SalesNet;
                end;
        End;

        end;

        NICodeArray[0].Box3 := NICodeArray[0].Box1 + NICodeArray[0].Box2;

        // SP 07/05/19 - Round to 2 decimal places
        NICodeArray[0].Box4 := Round(NICodeArray[0].Box4*100)/100;

        NICodeArray[0].box5 := (round(NICodeArray[0].box3*100) - round(NICodeArray[0].box4*100))/100;


end;









// These Procedures are all for Invoice Based VAT


Procedure InvoiceVatAuditTrail(SalePurch : Char; MarkasClaimed : Boolean; ClaimID : Integer; SpanYear : Boolean);
var

    TESTDT : TDateTime;
    i, j, ID : integer;
    TxRecord : Integer;
    OKTOPRINT : Boolean;
    Check_9_Types : Boolean;
    RecordType : Integer;
    Sub : INTEGER;
    NEG : BOOLEAN;
    TempInt, TxType, OrigType : Integer;
    Tempstr, tempstring : string;
    AMT     : real;
    VatCode, PreviousVatCode : string[1];
    RunningAmount, RunningVat : real;
    RunningCount : integer;
    st : shortstring;
    TotalAmount, TotalVat : real;


begin

  



    VatCode := '';
    PreviousVatCode := '';
    RunningAmount := 0;
    RunningVat := 0;
    RunningCount := 0;
    tempstr := '';


    Accsdatamodule.TransactionsDB.close;

 //   Accsdatamodule.SQLUpdate.sql.clear;
 //   Accsdatamodule.SQLUpdate.sql.Add('Alter Table Transactions Drop Index ByTaxCode.Primary');
 //   Accsdatamodule.SQLUpdate.ExecSQL;

    Accsdatamodule.SQLUpdate.sql.clear;
    Accsdatamodule.SQLUpdate.sql.Add('CREATE INDEX ByTaxCode ON Transactions (TaxCode,TxDate)');
    Accsdatamodule.SQLUpdate.ExecSQL;

    Accsdatamodule.TransactionsDB.IndexName := 'ByTaxCode';

    Accsdatamodule.TransactionsDB.open;

    for I := 0 to Accsdatamodule.TransactionsDB.IndexFieldCount - 1 do
        if Accsdatamodule.TransactionsDB.IndexFields[I].Name = 'ByTaxCode' then
           begin
                Accsdatamodule.TransactionsDB.IndexName := Accsdatamodule.TransactionsDB.IndexDefs.Items[I].Name;
           end;

    Accsdatamodule.TransactionsDB.last;

    Accsdatamodule.TempVATDB.last;
    Accsdatamodule.TempVATDB.edit;

    if SalePurch = 'S' then begin

                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB.post;
                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB['Label'] := 'SALES INVOICE VAT AUDIT TRAIL';
                        Accsdatamodule.TempVATDB.post;
                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB['Label'] := '======================================';
                        Accsdatamodule.TempVATDB.post;
                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB.post;

                     end
        else begin
                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB.post;
                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB['Label'] := '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
                        Accsdatamodule.TempVATDB.post;
                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB['Label'] := 'PURCHASE INVOICE VAT AUDIT TRAIL';
                        Accsdatamodule.TempVATDB.post;
                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB['Label'] := '======================================';
                        Accsdatamodule.TempVATDB.post;
                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB.post;
             end;


    // Pick-up Transactions from Last Year

    if SpanYear then begin

     if FileExists(Accsdata.AccsDataModule.AccsDataBase.Directory + 'Year-1.db') then begin


     Accsdatamodule.TransactionsYr1DB.close;


     Accsdatamodule.SQLUpdate.sql.clear;
     Accsdatamodule.SQLUpdate.sql.Add('CREATE INDEX ByTaxCode ON "Year-1" (TaxCode,TxDate)');
     Accsdatamodule.SQLUpdate.ExecSQL;

     Accsdatamodule.TransactionsYr1DB.IndexName := 'ByTaxCode';

     Accsdatamodule.TransactionsYr1DB.open;

     for I := 0 to Accsdatamodule.TransactionsYr1DB.IndexFieldCount - 1 do
        if Accsdatamodule.TransactionsYr1DB.IndexFields[I].Name = 'ByTaxCode' then
           begin
                Accsdatamodule.TransactionsYr1DB.IndexName := Accsdatamodule.TransactionsYr1DB.IndexDefs.Items[I].Name;
           end;

     Accsdatamodule.TransactionsYr1DB.last;


     SchRecf  := 1;                             // doesn't matter a only going back partially in the year
     SchRect  := Accsdatamodule.TransactionsYr1DB.RecordCount;

     for i:= Accsdatamodule.TransactionsYr1DB.RecordCount downto 1 do begin

     TxRecord := Accsdatamodule.TransactionsYr1DB['TxNo'];

      IF (TxRecord>=SCHRECF) AND (TxRecord<=SCHRECT) THEN
	BEGIN

              OKTOPRINT:=TRUE;

	      // Check the next record to see if its a VAT Record
	      Check_9_Types := false;
              RecordType := Accsdatamodule.TransactionsYr1DB['TxType'];
              tempstr := '';
              try tempstr := vartostr(Accsdatamodule.TransactionsYr1DB['TaxCode']);
              except
              end;


              if tempstr = '' then oktoprint := false;
              if tempstr = ' ' then oktoprint := false;

        { Ch014

              if cash2.XCOUNTRY = 1 then begin
                  for j := 0 to 9 do begin
                      if VatCodeArray[j].Vatcode = tempstr then begin
                          if VatCodeArray[j].NIInclude = false then oktoprint := false;
                      end;
                  end;
              end;

        end Ch014}

        // Ch017
        if (cash2.XCOUNTRY = 1) then begin
               if (DigitalVATForm.IncludeExemptCB.Checked = False) then begin
                  for j := 0 to 9 do begin
                      if VatCodeArray[j].Vatcode = tempstr then begin
                          if VatCodeArray[j].NIInclude = false then oktoprint := false;
                      end;
                  end;
              end;
        end;
       // end Ch017

              if ((RecordType = 9) and (length (tempstr) = 1)) then begin
                  Accsdatamodule.TransactionsYr1DB.prior;
       			if ((vartostr(Accsdatamodule.TransactionsYr1DB['TaxCode']) <> '') and (vartostr(Accsdatamodule.TransactionsYr1DB['TaxCode']) <> ' ')) then begin  // was ' '
                           if Accsdatamodule.TransactionsYr1DB['TxType'] = 0 then Check_9_Types := True;
                        end;
                  Accsdatamodule.TransactionsYr1DB.Locate('TxNo',Txrecord, []);;
              end;

             RecordType := Accsdatamodule.TransactionsYr1DB['TxType'];
             if not ((RecordType = 0) or (RecordType = 10)) then OKTOPRINT:=FALSE;

             try TESTDT := Accsdatamodule.TransactionsYr1DB['TxDate'];
             except TESTDT := 0;
             end;

             IF (TESTDT>TODT) THEN OKTOPRINT:=FALSE;

             // Check if already claimed

             If Accsdatamodule.TransactionsYr1DB['VATProcessed'] = True then OKTOPRINT := False;

       	     IF OKTOPRINT THEN
		BEGIN
                  tempint := 0;
	     	  tempint := Accsdatamodule.TransactionsYr1DB['Nominal'];

     	     	  If (( tempint >= Cash1.xnomprvinc ) And ( tempint <= Cash1.xnomprvexp+Cash11.xno_of_partners )) Then oktoprint := False;

                  tempstr := '';
                  try tempstr := vartostr(Accsdatamodule.TransactionsYr1DB['EditStat']);
                  except
                  end;
                  If ((ansilowercase(tempstr) = 'e') or (ansilowercase(tempstr) = 'r')) then oktoprint := False;


      		  IF OKTOPRINT THEN
		     BEGIN
		      SUB:=0;
		      NEG:=FALSE;
                      TxType := Accsdatamodule.TransactionsYr1DB['TxType'];

   		      If ( TxType=0 ) Or (( Cash2.xcountry In [1,2] ) And
			 ( check_9_types )) THEN
			BEGIN
                          OrigType := Accsdatamodule.TransactionsYr1DB['OrigType'];
     			  IF OrigType IN [1,2,3,4,11,12] THEN SUB:=1;
			  IF OrigType IN [5,6,7,8,15,16] THEN SUB:=2;
			END;
		      IF OrigType=10 THEN SUB:=1;
              	      IF SUB>0 THEN
			BEGIN
			  AMT:=Accsdatamodule.TransactionsYr1DB['Amount'];
                          TxType := Accsdatamodule.TransactionsYr1DB['TxType'];

			  IF ( TxType=0 )  Or (( Cash2.xcountry In [1,2] ) And
			     ( check_9_types )) THEN
			    IF ((NOT (OrigType IN [3,7])) AND (AMT<0))
			    OR ((     OrigType IN [3,7] ) AND (AMT>0)) THEN
			      BEGIN
				IF SUB=1 THEN SUB:=2 ELSE SUB:=1;
				NEG:=TRUE;
			      END;
			  IF TxType=10 THEN NEG:=TRUE;
		        END;
		      IF ((SalePurch = 'S') AND (SUB<>1))
		      OR ((SalePurch = 'P') AND (SUB<>2)) THEN OKTOPRINT:=FALSE;

	  	     END;
	   	END;
                if oktoprint then begin


                                        VatCode := vartostr(Accsdatamodule.TransactionsYr1DB['TaxCode']);

                                        if MarkasClaimed then begin

                                              ID :=  Accsdatamodule.TransactionsYr1DB['TxNo'];

                                              Accsdatamodule.SQLUpdate.sql.clear;
                                              Accsdatamodule.SQLUpdate.sql.Add('Update "Year-1" set VATProcessed = true, ReturnID = ' + vartostr(ClaimID) + ' where Txno = ' + vartostr(ID));
                                              Accsdatamodule.SQLUpdate.ExecSQL;



                                        end;

                                        if PreviousVatCode <> '' then begin  // not the first record

                                           if PreviousVatCode <> VatCode then begin
                                            if RunningCount <> 0 then begin
                                               Accsdatamodule.TempVATDB.append;
                                               Accsdatamodule.TempVATDB['Label'] := '-----------------------------------------------------------------------------------------------------------------------------------------';     // TGM AB 24/07/15
                                               Accsdatamodule.TempVATDB.post;
                                               Accsdatamodule.TempVATDB.append;
                                               for j:= 0 to 9 do Begin
                                                   if Cash1.xTaxIds[j] = PreviousVatCode then TempString := VatCodeArray[j].VatPercent;
                                               End;
                                               Accsdatamodule.TempVATDB['Label'] := 'Total For V-A-T Code ' + PreviousVatCode + ' In Previous Year (' + vartostr(RunningCount) + ' Records) ..... ' + TempString;

                                               // Ch014 start
                                                  st := '';
                                                  for j:= 0 to 9 do Begin
                                                      if Cash1.xTaxIds[j] = PreviousVatCode then begin
                                                                if Cash2.Vat_inc_exc[j] <> 'I' then st := '    (Exempt VAT Code)';
                                                      end;
                                                  end;
                                                  Accsdatamodule.TempVATDB['Label'] :=  Accsdatamodule.TempVATDB['Label'] + ' ' + st;
                                               // Ch014 end

                                               st := '';
                                               DoubleToStr (RunningAmount,st,'%8.2f', true, false, 20, True);
                                               slimleft (st);
                                               Accsdatamodule.TempVATDB['AmountText'] := st;
                                               Accsdatamodule.TempVATDB['Amount'] := RunningAmount;
                                               st := '';
                                               DoubleToStr (RunningVat,st,'%8.2f', true, false, 20, True);
                                               slimleft (st);
                                               Accsdatamodule.TempVATDB['VATText'] := st;
                                               Accsdatamodule.TempVATDB['VAT'] := RunningVat;
                                               Accsdatamodule.TempVATDB.post;
                                               Accsdatamodule.TempVATDB.append;
                                               Accsdatamodule.TempVATDB['Label'] := '-----------------------------------------------------------------------------------------------------------------------------------------';       // TGM AB 24/07/15
                                               Accsdatamodule.TempVATDB.post;
                                               for j:= 0 to 9 do Begin
                                                    if VatCodeArray[j].VatCode = PreviousVatCode then begin
                                                       if SalePurch = 'S' then begin
                                                                VatCodeArray[j].SalesNet := RunningAmount;
                                                                VatCodeArray[j].SalesVat := RunningVat;
                                                       end else begin
                                                                VatCodeArray[j].PurchNet := RunningAmount;
                                                                VatCodeArray[j].PurchVat := RunningVat;
                                                                end;
                                                    end;
                                               End ;
                                               if SalePurch = 'S' then SalesCount := SalesCount + RunningCount
                                                  else Purchcount := Purchcount + RunningCount;
                                               RunningAmount := 0;
                                               RunningVat := 0;
                                               RunningCount := 0;
                                            end; // RunningCount
                                           end;

                                           Accsdatamodule.TempVATDB.append;
                                           Accsdatamodule.TempVATDB['Record'] := Accsdatamodule.TransactionsYr1DB['TxNo'];
                                           Accsdatamodule.TempVATDB['TxDate'] := Accsdatamodule.TransactionsYr1DB['TxDate'];
                                           Accsdatamodule.TempVATDB['Description'] := Accsdatamodule.TransactionsYr1DB['Descript'];
                                           Accsdatamodule.TempVATDB['PreviousYear'] := '*';
                                           if OrigType IN [1,2,3,4,11,12]  then Accsdatamodule.TempVATDB['Account'] := GetSLPLAccountName ( SlFile, Accsdatamodule.TransactionsYr1DB['Account'])
                                                else Accsdatamodule.TempVATDB['Account'] := GetSLPLAccountName ( PlFile, Accsdatamodule.TransactionsYr1DB['Account']);
                                           Accsdatamodule.TempVATDB['Reference'] := Accsdatamodule.TransactionsYr1DB['Reference'];

                                           if NEG then begin
                                                        Accsdatamodule.TempVATDB['Amount'] := ((Accsdatamodule.TransactionsYr1DB['Amount']) * -1);
                                                        st := '';
                                                        DoubleToStr (((Accsdatamodule.TransactionsYr1DB['Amount'])*-1),st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['AmountText'] := st;
                                                        Accsdatamodule.TempVATDB['VAT'] := ((Accsdatamodule.TransactionsYr1DB['TaxDisc']) * -1);
                                                        st := '';
                                                        DoubleToStr (((Accsdatamodule.TransactionsYr1DB['TaxDisc'])*-1),st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['VATText'] := st;
                                                        Accsdatamodule.TempVATDB['VATCode'] := Accsdatamodule.TransactionsYr1DB['TaxCode'];
                                                        Accsdatamodule.TempVATDB.post;
                                                        RunningAmount := RunningAmount - Accsdatamodule.TransactionsYr1DB['Amount'];
                                                        RunningVat := RunningVat - Accsdatamodule.TransactionsYr1DB['TaxDisc'];
                                           end
                                                else begin
                                                        Accsdatamodule.TempVATDB['Amount'] := Accsdatamodule.TransactionsYr1DB['Amount'];
                                                        st := '';
                                                        DoubleToStr (Accsdatamodule.TransactionsYr1DB['Amount'],st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['AmountText'] := st;
                                                        Accsdatamodule.TempVATDB['VAT'] := Accsdatamodule.TransactionsYr1DB['TaxDisc'];
                                                        st := '';
                                                        DoubleToStr (Accsdatamodule.TransactionsYr1DB['TaxDisc'],st,'%8.2f', true, false, 20, True);      // TGM AB 19/04/19
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['VATText'] := st;
                                                        Accsdatamodule.TempVATDB['VATCode'] := Accsdatamodule.TransactionsYr1DB['TaxCode'];
                                                        Accsdatamodule.TempVATDB.post;
                                                        RunningAmount := RunningAmount + Accsdatamodule.TransactionsYr1DB['Amount'];
                                                        RunningVat := RunningVat + Accsdatamodule.TransactionsYr1DB['TaxDisc'];
                                                end;



                                        end
                                            else begin

                                            Accsdatamodule.TempVATDB.append;
                                            Accsdatamodule.TempVATDB['Record'] := Accsdatamodule.TransactionsYr1DB['TxNo'];
                                            Accsdatamodule.TempVATDB['TxDate'] := Accsdatamodule.TransactionsYr1DB['TxDate'];
                                            Accsdatamodule.TempVATDB['Description'] := Accsdatamodule.TransactionsYr1DB['Descript'];
                                            Accsdatamodule.TempVATDB['PreviousYear'] := '*';
                                            if OrigType IN [1,2,3,4,11,12] then Accsdatamodule.TempVATDB['Account'] := GetSLPLAccountName ( SlFile, Accsdatamodule.TransactionsYr1DB['Account'])
                                                else Accsdatamodule.TempVATDB['Account'] := GetSLPLAccountName ( PlFile, Accsdatamodule.TransactionsYr1DB['Account']);
                                            Accsdatamodule.TempVATDB['Reference'] := Accsdatamodule.TransactionsYr1DB['Reference'];
                                            if NEG then begin
                                                        Accsdatamodule.TempVATDB['Amount'] := ((Accsdatamodule.TransactionsYr1DB['Amount']) * -1);
                                                        st := '';
                                                        DoubleToStr (((Accsdatamodule.TransactionsYr1DB['Amount'])*-1),st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['AmountText'] := st;
                                                        Accsdatamodule.TempVATDB['VAT'] := ((Accsdatamodule.TransactionsYr1DB['TaxDisc']) * -1);
                                                        st := '';
                                                        DoubleToStr (((Accsdatamodule.TransactionsYr1DB['TaxDisc'])*-1),st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['VATText'] := st;
                                                        Accsdatamodule.TempVATDB['VATCode'] := Accsdatamodule.TransactionsYr1DB['TaxCode'];
                                                        Accsdatamodule.TempVATDB.post;
                                                        RunningAmount := RunningAmount - Accsdatamodule.TransactionsYr1DB['Amount'];
                                                        RunningVat := RunningVat - Accsdatamodule.TransactionsYr1DB['TaxDisc'];
                                           end
                                                else begin
                                                        Accsdatamodule.TempVATDB['Amount'] := Accsdatamodule.TransactionsYr1DB['Amount'];
                                                        st := '';
                                                        DoubleToStr (Accsdatamodule.TransactionsYr1DB['Amount'],st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['AmountText'] := st;
                                                        Accsdatamodule.TempVATDB['VAT'] := Accsdatamodule.TransactionsYr1DB['TaxDisc'];
                                                        st := '';
                                                        DoubleToStr (Accsdatamodule.TransactionsYr1DB['TaxDisc'],st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['VATText'] := st;
                                                        Accsdatamodule.TempVATDB['VATCode'] := Accsdatamodule.TransactionsYr1DB['TaxCode'];
                                                        Accsdatamodule.TempVATDB.post;
                                                        RunningAmount := RunningAmount + Accsdatamodule.TransactionsYr1DB['Amount'];
                                                        RunningVat := RunningVat + Accsdatamodule.TransactionsYr1DB['TaxDisc'];
                                                end;



                                            end;
                                        inc(RunningCount);

                                        PreviousVatCode := VatCode;
                                end;
	   END; // S or P


        if i = 1 then begin
          if RunningCount <> 0 then begin
             Accsdatamodule.TempVATDB.edit;
             Accsdatamodule.TempVATDB.append;
             Accsdatamodule.TempVATDB['Label'] := '-----------------------------------------------------------------------------------------------------------------------------------------';           // TGM AB 24/07/15
             Accsdatamodule.TempVATDB.post;
             Accsdatamodule.TempVATDB.append;
             for j:= 0 to 9 do Begin
                 if Cash1.xTaxIds[j] = PreviousVatCode then TempString := VatCodeArray[j].VatPercent;
             End;
             Accsdatamodule.TempVATDB['Label'] := 'Total For V-A-T Code ' + PreviousVatCode + ' In Previous Year (' + vartostr(RunningCount) + ' Records) ..... ' + TempString;

             // Ch014 start
             st := '';
             for j:= 0 to 9 do Begin
                if Cash1.xTaxIds[j] = PreviousVatCode then begin
                        if Cash2.Vat_inc_exc[j] <> 'I' then st := '    (Exempt VAT Code)';
                        end;
                end;
             Accsdatamodule.TempVATDB['Label'] :=  Accsdatamodule.TempVATDB['Label'] + ' ' + st;
             // Ch014 end

             st := '';
             DoubleToStr (RunningAmount,st,'%8.2f', true, false, 20, True);
             slimleft (st);
             Accsdatamodule.TempVATDB['AmountText'] := st;
             Accsdatamodule.TempVATDB['Amount'] := RunningAmount;
             st := '';
             DoubleToStr (RunningVat,st,'%8.2f', true, false, 20, True);
             slimleft (st);
             Accsdatamodule.TempVATDB['VATText'] := st;
             Accsdatamodule.TempVATDB['VAT'] := RunningVat;
             Accsdatamodule.TempVATDB.post;
             Accsdatamodule.TempVATDB.append;
             Accsdatamodule.TempVATDB['Label'] := '-----------------------------------------------------------------------------------------------------------------------------------------';          // TGM AB 24/07/15
             Accsdatamodule.TempVATDB.post;
             for j:= 0 to 9 do Begin
                  if VatCodeArray[j].VatCode = PreviousVatCode then begin
                        if SalePurch = 'S' then begin
                                                                VatCodeArray[j].SalesNet := RunningAmount;
                                                                VatCodeArray[j].SalesVat := RunningVat;
                                                       end else begin
                                                                VatCodeArray[j].PurchNet := RunningAmount;
                                                                VatCodeArray[j].PurchVat := RunningVat;
                                                                end;
                        end;
             End;
             if SalePurch = 'S' then SalesCount := SalesCount + RunningCount
                else PurchCount := PurchCount + RunningCount;
             RunningAmount := 0;
             RunningVat := 0;
             RunningCount := 0;
            end; // RunningCount
           end;
        Accsdatamodule.TransactionsYr1DB.prior;

     end; // For i:=

     end;   // if file exists

    end;   // SpanYear




    // Pick-up Transactions from This Year

    // Set-up Variables

    VatCode := '';
    PreviousVatCode := '';
    RunningCount := 0;
    tempstr := '';

    SchRecf  := AuditFiles.FirstTxThisYear;
    SchRect  := Accsdatamodule.TransactionsDB.RecordCount;
    
    Accsdatamodule.TransactionsDB.last;

    for i:= Accsdatamodule.TransactionsDB.RecordCount downto 1 do begin

      TxRecord := Accsdatamodule.TransactionsDB['TxNo'];

      IF (TxRecord>=SCHRECF) AND (TxRecord<=SCHRECT) THEN
	BEGIN

              OKTOPRINT:=TRUE;

	      // Check the next record to see if its a VAT Record
	      Check_9_Types := false;
              RecordType := Accsdatamodule.TransactionsDB['TxType'];
              tempstr := '';
              try tempstr := vartostr(Accsdatamodule.TransactionsDB['TaxCode']);
              except
              end;


              if tempstr = '' then oktoprint := false;
              if tempstr = ' ' then oktoprint := false;

       {  Ch014

              if cash2.XCOUNTRY = 1 then begin
                  for j := 0 to 9 do begin
                      if VatCodeArray[j].Vatcode = tempstr then begin
                          if VatCodeArray[j].NIInclude = false then oktoprint := false;
                      end;
                  end;
              end;
        end CH014  }

        // Ch017
        if (cash2.XCOUNTRY = 1) then begin
               if (DigitalVATForm.IncludeExemptCB.Checked = False) then begin
                  for j := 0 to 9 do begin
                      if VatCodeArray[j].Vatcode = tempstr then begin
                          if VatCodeArray[j].NIInclude = false then oktoprint := false;
                      end;
                  end;
              end;
        end;
       // end Ch017

              if ((RecordType = 9) and (length (tempstr) = 1)) then begin
                  Accsdatamodule.TransactionsDB.prior;
       			if ((vartostr(Accsdatamodule.TransactionsDB['TaxCode']) <> '') and (vartostr(Accsdatamodule.TransactionsDB['TaxCode']) <> ' ')) then begin  // was ' '
                           if Accsdatamodule.TransactionsDB['TxType'] = 0 then Check_9_Types := True;
                        end;
                  Accsdatamodule.TransactionsDB.Locate('TxNo',Txrecord, []);;
              end;

             RecordType := Accsdatamodule.TransactionsDB['TxType'];
             if not ((RecordType = 0) or (RecordType = 10)) then OKTOPRINT:=FALSE;

             try TESTDT := Accsdatamodule.TransactionsDB['TxDate'];
             except TESTDT := 0;
             end;

             IF (TESTDT>TODT) THEN OKTOPRINT:=FALSE;

             // Check if already claimed

             If Accsdatamodule.TransactionsDB['VATProcessed'] = True then OKTOPRINT := False;

   	     IF OKTOPRINT THEN
		BEGIN
                  tempint := 0;
	     	  tempint := Accsdatamodule.TransactionsDB['Nominal'];

     	     	  If (( tempint >= Cash1.xnomprvinc ) And ( tempint <= Cash1.xnomprvexp+Cash11.xno_of_partners )) Then oktoprint := False;

                  tempstr := '';
                  try tempstr := vartostr(Accsdatamodule.TransactionsDB['EditStat']);
                  except
                  end;
                  If ((ansilowercase(tempstr) = 'e') or (ansilowercase(tempstr) = 'r')) then oktoprint := False;


      		  IF OKTOPRINT THEN
		     BEGIN
		      SUB:=0;
		      NEG:=FALSE;
                      TxType := Accsdatamodule.TransactionsDB['TxType'];

   		      If ( TxType=0 ) Or (( Cash2.xcountry In [1,2] ) And
			 ( check_9_types )) THEN
			BEGIN
                          OrigType := Accsdatamodule.TransactionsDB['OrigType'];
     			  IF OrigType IN [1,2,3,4,11,12] THEN SUB:=1;
			  IF OrigType IN [5,6,7,8,15,16] THEN SUB:=2;
			END;
		      IF OrigType=10 THEN SUB:=1;
              	      IF SUB>0 THEN
			BEGIN
			  AMT:=Accsdatamodule.TransactionsDB['Amount'];
                          TxType := Accsdatamodule.TransactionsDB['TxType'];

			  IF ( TxType=0 )  Or (( Cash2.xcountry In [1,2] ) And
			     ( check_9_types )) THEN
			    IF ((NOT (OrigType IN [3,7])) AND (AMT<0))
			    OR ((     OrigType IN [3,7] ) AND (AMT>0)) THEN
			      BEGIN
				IF SUB=1 THEN SUB:=2 ELSE SUB:=1;
				NEG:=TRUE;
			      END;
			  IF TxType=10 THEN NEG:=TRUE;
		        END;
		      IF ((SalePurch = 'S') AND (SUB<>1))
		      OR ((SalePurch = 'P') AND (SUB<>2)) THEN OKTOPRINT:=FALSE;

	  	     END;
	   	END;
                if oktoprint then begin


                                        VatCode := vartostr(Accsdatamodule.TransactionsDB['TaxCode']);

                                        if MarkasClaimed then begin

                                              ID :=  Accsdatamodule.TransactionsDB['TxNo'];

                                              Accsdatamodule.SQLUpdate.sql.clear;
                                              Accsdatamodule.SQLUpdate.sql.Add('Update Transactions set VATProcessed = true, ReturnID = ' + vartostr(ClaimID) + ' where Txno = ' + vartostr(ID));
                                              Accsdatamodule.SQLUpdate.ExecSQL;



                                        end;

                                        if PreviousVatCode <> '' then begin  // not the first record

                                           if PreviousVatCode <> VatCode then begin
                                               Accsdatamodule.TempVATDB.append;
                                               Accsdatamodule.TempVATDB['Label'] := '-----------------------------------------------------------------------------------------------------------------------------------------';     // TGM AB 24/07/15
                                               Accsdatamodule.TempVATDB.post;
                                               Accsdatamodule.TempVATDB.append;
                                               for j:= 0 to 9 do Begin
                                                   if Cash1.xTaxIds[j] = PreviousVatCode then TempString := VatCodeArray[j].VatPercent;
                                               End;
                                               Accsdatamodule.TempVATDB['Label'] := 'Total For V-A-T Code ' + PreviousVatCode + ' (' + vartostr(RunningCount) + ' Records) ..... ' + TempString;

                                               // Ch014 start
                                                  st := '';
                                                  for j:= 0 to 9 do Begin
                                                      if Cash1.xTaxIds[j] = PreviousVatCode then begin
                                                                if Cash2.Vat_inc_exc[j] <> 'I' then st := '    (Exempt VAT Code)';
                                                      end;
                                                  end;
                                                  Accsdatamodule.TempVATDB['Label'] :=  Accsdatamodule.TempVATDB['Label'] + ' ' + st;
                                               // Ch014 end

                                               st := '';
                                               DoubleToStr (RunningAmount,st,'%8.2f', true, false, 20, True);
                                               slimleft (st);
                                               Accsdatamodule.TempVATDB['AmountText'] := st;
                                               Accsdatamodule.TempVATDB['Amount'] := RunningAmount;
                                               st := '';
                                               DoubleToStr (RunningVat,st,'%8.2f', true, false, 20, True);
                                               slimleft (st);
                                               Accsdatamodule.TempVATDB['VATText'] := st;
                                               Accsdatamodule.TempVATDB['VAT'] := RunningVat;
                                               Accsdatamodule.TempVATDB.post;
                                               Accsdatamodule.TempVATDB.append;
                                               Accsdatamodule.TempVATDB['Label'] := '-----------------------------------------------------------------------------------------------------------------------------------------';       // TGM AB 24/07/15
                                               Accsdatamodule.TempVATDB.post;
                                               for j:= 0 to 9 do Begin
                                                    if VatCodeArray[j].VatCode = PreviousVatCode then begin
                                                       if SalePurch = 'S' then begin
                                                                VatCodeArray[j].SalesNet := VatCodeArray[j].SalesNet + RunningAmount;
                                                                VatCodeArray[j].SalesVat := VatCodeArray[j].SalesVat + RunningVat;
                                                       end else begin
                                                                VatCodeArray[j].PurchNet := VatCodeArray[j].PurchNet + RunningAmount;
                                                                VatCodeArray[j].PurchVat := VatCodeArray[j].PurchVat + RunningVat;
                                                                end;
                                                    end;
                                               End ;
                                               if SalePurch = 'S' then SalesCount := SalesCount + RunningCount
                                                  else Purchcount := Purchcount + RunningCount;
                                               RunningAmount := 0;
                                               RunningVat := 0;
                                               RunningCount := 0;
                                           end;

                                           Accsdatamodule.TempVATDB.append;
                                           Accsdatamodule.TempVATDB['Record'] := Accsdatamodule.TransactionsDB['TxNo'];
                                           Accsdatamodule.TempVATDB['TxDate'] := Accsdatamodule.TransactionsDB['TxDate'];
                                           Accsdatamodule.TempVATDB['Description'] := Accsdatamodule.TransactionsDB['Descript'];
                                           if OrigType IN [1,2,3,4,11,12]  then Accsdatamodule.TempVATDB['Account'] := GetSLPLAccountName ( SlFile, Accsdatamodule.TransactionsDB['Account'])
                                                else Accsdatamodule.TempVATDB['Account'] := GetSLPLAccountName ( PlFile, Accsdatamodule.TransactionsDB['Account']);
                                           Accsdatamodule.TempVATDB['Reference'] := Accsdatamodule.TransactionsDB['Reference'];

                                           if NEG then begin
                                                        Accsdatamodule.TempVATDB['Amount'] := ((Accsdatamodule.TransactionsDB['Amount']) * -1);
                                                        st := '';
                                                        DoubleToStr (((Accsdatamodule.TransactionsDB['Amount'])*-1),st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['AmountText'] := st;
                                                        Accsdatamodule.TempVATDB['VAT'] := ((Accsdatamodule.TransactionsDB['TaxDisc']) * -1);
                                                        st := '';
                                                        DoubleToStr (((Accsdatamodule.TransactionsDB['TaxDisc'])*-1),st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['VATText'] := st;
                                                        Accsdatamodule.TempVATDB['VATCode'] := Accsdatamodule.TransactionsDB['TaxCode'];
                                                        Accsdatamodule.TempVATDB.post;
                                                        RunningAmount := RunningAmount - Accsdatamodule.TransactionsDB['Amount'];
                                                        RunningVat := RunningVat - Accsdatamodule.TransactionsDB['TaxDisc'];
                                           end
                                                else begin
                                                        Accsdatamodule.TempVATDB['Amount'] := Accsdatamodule.TransactionsDB['Amount'];
                                                        st := '';
                                                        DoubleToStr (Accsdatamodule.TransactionsDB['Amount'],st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['AmountText'] := st;
                                                        Accsdatamodule.TempVATDB['VAT'] := Accsdatamodule.TransactionsDB['TaxDisc'];
                                                        st := '';
                                                        DoubleToStr (Accsdatamodule.TransactionsDB['TaxDisc'],st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['VATText'] := st;
                                                        Accsdatamodule.TempVATDB['VATCode'] := Accsdatamodule.TransactionsDB['TaxCode'];
                                                        Accsdatamodule.TempVATDB.post;
                                                        RunningAmount := RunningAmount + Accsdatamodule.TransactionsDB['Amount'];
                                                        RunningVat := RunningVat + Accsdatamodule.TransactionsDB['TaxDisc'];
                                                end;



                                        end
                                            else begin

                                            Accsdatamodule.TempVATDB.append;
                                            Accsdatamodule.TempVATDB['Record'] := Accsdatamodule.TransactionsDB['TxNo'];
                                            Accsdatamodule.TempVATDB['TxDate'] := Accsdatamodule.TransactionsDB['TxDate'];
                                            Accsdatamodule.TempVATDB['Description'] := Accsdatamodule.TransactionsDB['Descript'];
                                      //      if Act = 11 then Accsdatamodule.TempVATDB['Account'] := GetSLPLAccountName ( SlFile, Accsdatamodule.TransactionsDB['Account'])
                                      //          else Accsdatamodule.TempVATDB['Account'] := GetSLPLAccountName ( PlFile, Accsdatamodule.TransactionsDB['Account']);
                                            if OrigType IN [1,2,3,4,11,12] then Accsdatamodule.TempVATDB['Account'] := GetSLPLAccountName ( SlFile, Accsdatamodule.TransactionsDB['Account'])
                                                else Accsdatamodule.TempVATDB['Account'] := GetSLPLAccountName ( PlFile, Accsdatamodule.TransactionsDB['Account']);
                                            Accsdatamodule.TempVATDB['Reference'] := Accsdatamodule.TransactionsDB['Reference'];
                                            if NEG then begin
                                                        Accsdatamodule.TempVATDB['Amount'] := ((Accsdatamodule.TransactionsDB['Amount']) * -1);
                                                        st := '';
                                                        DoubleToStr (((Accsdatamodule.TransactionsDB['Amount'])*-1),st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['AmountText'] := st;
                                                        Accsdatamodule.TempVATDB['VAT'] := ((Accsdatamodule.TransactionsDB['TaxDisc']) * -1);
                                                        st := '';
                                                        DoubleToStr (((Accsdatamodule.TransactionsDB['TaxDisc'])*-1),st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['VATText'] := st;
                                                        Accsdatamodule.TempVATDB['VATCode'] := Accsdatamodule.TransactionsDB['TaxCode'];
                                                        Accsdatamodule.TempVATDB.post;
                                                        RunningAmount := RunningAmount - Accsdatamodule.TransactionsDB['Amount'];
                                                        RunningVat := RunningVat - Accsdatamodule.TransactionsDB['TaxDisc'];
                                           end
                                                else begin
                                                        Accsdatamodule.TempVATDB['Amount'] := Accsdatamodule.TransactionsDB['Amount'];
                                                        st := '';
                                                        DoubleToStr (Accsdatamodule.TransactionsDB['Amount'],st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['AmountText'] := st;
                                                        Accsdatamodule.TempVATDB['VAT'] := Accsdatamodule.TransactionsDB['TaxDisc'];
                                                        st := '';
                                                        DoubleToStr (Accsdatamodule.TransactionsDB['TaxDisc'],st,'%8.2f', true, false, 20, True);
                                                        slimleft (st);
                                                        Accsdatamodule.TempVATDB['VATText'] := st;
                                                        Accsdatamodule.TempVATDB['VATCode'] := Accsdatamodule.TransactionsDB['TaxCode'];
                                                        Accsdatamodule.TempVATDB.post;
                                                        RunningAmount := RunningAmount + Accsdatamodule.TransactionsDB['Amount'];
                                                        RunningVat := RunningVat + Accsdatamodule.TransactionsDB['TaxDisc'];
                                                end;


                                         (*   Accsdatamodule.TempVATDB['Amount'] := Accsdatamodule.TransactionsDB['Amount'];
                                            st := '';
                                            DoubleToStr (Accsdatamodule.TransactionsDB['Amount'],st,'%8.2f', true, false, 20, True);
                                            slimleft (st);
                                            Accsdatamodule.TempVATDB['AmountText'] := st;
                                            Accsdatamodule.TempVATDB['VAT'] := Accsdatamodule.TransactionsDB['TaxDisc'];
                                            st := '';
                                            DoubleToStr (Accsdatamodule.TransactionsDB['TaxDisc'],st,'%8.2f', true, false, 20, True);
                                            slimleft (st);
                                            Accsdatamodule.TempVATDB['VATText'] := st;
                                            Accsdatamodule.TempVATDB['VATCode'] := Accsdatamodule.TransactionsDB['TaxCode'];
                                            Accsdatamodule.TempVATDB.post;
                                            RunningAmount := RunningAmount + Accsdatamodule.TransactionsDB['Amount'];
                                            RunningVat := RunningVat + Accsdatamodule.TransactionsDB['TaxDisc'];
                                           *)
                                            end;
                                        inc(RunningCount);

                                        PreviousVatCode := VatCode;
                                end;
	   END; // S or P


        if i = 1 then begin
             Accsdatamodule.TempVATDB.edit;
             Accsdatamodule.TempVATDB.append;
             Accsdatamodule.TempVATDB['Label'] := '-----------------------------------------------------------------------------------------------------------------------------------------';           // TGM AB 24/07/15
             Accsdatamodule.TempVATDB.post;
             Accsdatamodule.TempVATDB.append;
             for j:= 0 to 9 do Begin
                 if Cash1.xTaxIds[j] = PreviousVatCode then TempString := VatCodeArray[j].VatPercent;
             End;
             Accsdatamodule.TempVATDB['Label'] := 'Total For V-A-T Code ' + PreviousVatCode + ' (' + vartostr(RunningCount) + ' Records) ..... ' + TempString;

             // Ch014 start
             st := '';
             for j:= 0 to 9 do Begin
                if Cash1.xTaxIds[j] = PreviousVatCode then begin
                        if Cash2.Vat_inc_exc[j] <> 'I' then st := '    (Exempt VAT Code)';
                        end;
                end;
             Accsdatamodule.TempVATDB['Label'] :=  Accsdatamodule.TempVATDB['Label'] + ' ' + st;
             // Ch014 end

             st := '';
             DoubleToStr (RunningAmount,st,'%8.2f', true, false, 20, True);
             slimleft (st);
             Accsdatamodule.TempVATDB['AmountText'] := st;
             Accsdatamodule.TempVATDB['Amount'] := RunningAmount;
             st := '';
             DoubleToStr (RunningVat,st,'%8.2f', true, false, 20, True);
             slimleft (st);
             Accsdatamodule.TempVATDB['VATText'] := st;
             Accsdatamodule.TempVATDB['VAT'] := RunningVat;
             Accsdatamodule.TempVATDB.post;
             Accsdatamodule.TempVATDB.append;
             Accsdatamodule.TempVATDB['Label'] := '-----------------------------------------------------------------------------------------------------------------------------------------';          // TGM AB 24/07/15
             Accsdatamodule.TempVATDB.post;
             for j:= 0 to 9 do Begin
                  if VatCodeArray[j].VatCode = PreviousVatCode then begin
                        if SalePurch = 'S' then begin
                                                                VatCodeArray[j].SalesNet := VatCodeArray[j].SalesNet + RunningAmount;
                                                                VatCodeArray[j].SalesVat := VatCodeArray[j].SalesVat + RunningVat;
                                                       end else begin
                                                                VatCodeArray[j].PurchNet := VatCodeArray[j].PurchNet + RunningAmount;
                                                                VatCodeArray[j].PurchVat := VatCodeArray[j].PurchVat + RunningVat;
                                                                end;
                        end;
             End;
             if SalePurch = 'S' then SalesCount := SalesCount + RunningCount
                else PurchCount := PurchCount + RunningCount;
             RunningAmount := 0;
             RunningVat := 0;
             RunningCount := 0;
           end;
        Accsdatamodule.TransactionsDB.prior;

        end; // For i:=

        Accsdatamodule.TransactionsDB.IndexName := '';

        if SalePurch = 'S' then begin
              Accsdatamodule.TempVATDB.edit;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB['Label'] := 'Totals ...';
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB['Label'] := 'Number Of Records .... ' + VarTostr(SalesCount);
              Accsdatamodule.TempVATDB.post;
              TotalAmount := 0;
              TotalVat := 0;

              for j:= 0 to 9 do Begin
                          if cash2.XCOUNTRY = 1 then begin
                              if VatCodeArray[j].NIInclude = True then begin
                                       TotalAmount := TotalAmount + VatCodeArray[j].SalesNet;
                                       TotalVat := TotalVat + VatCodeArray[j].SalesVat;
                              end;
                          end
                                else begin
                                       TotalAmount := TotalAmount + VatCodeArray[j].SalesNet;
                                       TotalVat := TotalVat + VatCodeArray[j].SalesVat;
                          end;

              end;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB['Label'] := 'Amount Total (Included in VAT Return) .... ';            //Ch014 was  'Amount Total .... '
              st := '';
              DoubleToStr (TotalAmount,st,'%8.2f', true, false, 20, True);
              slimleft (st);
              Accsdatamodule.TempVATDB['AmountText'] := st;
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB['Label'] := 'VAT / Discount (Included in VAT Return) .... ';          //Ch014 was 'VAT / Discount .... '
              st := '';
              DoubleToStr (TotalVat,st,'%8.2f', true, false, 20, True);
              slimleft (st);
              Accsdatamodule.TempVATDB['AmountText'] := st;
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB['Label'] := 'Grand Total (Included in VAT Return) .... ';             //Ch014 was 'Grand Total .... ';
              st := '';
              DoubleToStr ((TotalAmount+TotalVat),st,'%8.2f', true, false, 20, True);
              slimleft (st);
              Accsdatamodule.TempVATDB['AmountText'] := st;
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;

              // Ch014 start
              if cash2.XCOUNTRY = 1 then begin
                TotalAmount := 0;
                for j:= 0 to 9 do Begin

                        if VatCodeArray[j].NIInclude = False then begin
                                       TotalAmount := TotalAmount + VatCodeArray[j].SalesNet;
                        end;
                end;

                if TotalAmount <> 0 then begin

                     Accsdatamodule.TempVATDB.edit;
                     Accsdatamodule.TempVATDB.append;
                     Accsdatamodule.TempVATDB.post;
                     Accsdatamodule.TempVATDB.append;
                     Accsdatamodule.TempVATDB['Label'] := 'Exempt Total (Not Included in VAT Return) .... ';
                     st := '';
                     DoubleToStr (TotalAmount,st,'%8.2f', true, false, 20, True);
                     slimleft (st);
                     Accsdatamodule.TempVATDB['AmountText'] := st;
                     Accsdatamodule.TempVATDB.post;

                end

              end;
              // Ch014 end

        end
           else begin
              Accsdatamodule.TempVATDB.edit;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB['Label'] := 'Totals ...';
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB['Label'] := 'Number Of Records .... ' + VarTostr(PurchCount);
              Accsdatamodule.TempVATDB.post;
              TotalAmount := 0;
              TotalVat := 0;

              for j:= 0 to 9 do Begin
                          if cash2.XCOUNTRY = 1 then begin
                              if VatCodeArray[j].NIInclude = True then begin
                                       TotalAmount := TotalAmount + VatCodeArray[j].PurchNet;
                                       TotalVat := TotalVat + VatCodeArray[j].PurchVat;
                              end;
                          end
                                else begin
                                       TotalAmount := TotalAmount + VatCodeArray[j].PurchNet;
                                       TotalVat := TotalVat + VatCodeArray[j].PurchVat;
                          end;
              end;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB['Label'] := 'Amount Total  (Included in VAT Return) .... ';                 //Ch014 was  'Amount Total .... '
              st := '';
              DoubleToStr (TotalAmount,st,'%8.2f', true, false, 20, True);
              slimleft (st);
              Accsdatamodule.TempVATDB['AmountText'] := st;
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB['Label'] := 'VAT / Discount  (Included in VAT Return) .... ';               //Ch014 was 'VAT / Discount .... '
              st := '';
              DoubleToStr (TotalVat,st,'%8.2f', true, false, 20, True);
              slimleft (st);
              Accsdatamodule.TempVATDB['AmountText'] := st;
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;
              Accsdatamodule.TempVATDB['Label'] := 'Grand Total  (Included in VAT Return) .... ';                  //Ch014 was 'Grand Total .... ';
              st := '';
              DoubleToStr ((TotalAmount+TotalVat),st,'%8.2f', true, false, 20, True);
              slimleft (st);
              Accsdatamodule.TempVATDB['AmountText'] := st;
              Accsdatamodule.TempVATDB.post;
              Accsdatamodule.TempVATDB.append;

              // Ch014 start
              if cash2.XCOUNTRY = 1 then begin
                TotalAmount := 0;
                for j:= 0 to 9 do Begin

                        if VatCodeArray[j].NIInclude = False then begin
                                       TotalAmount := TotalAmount + VatCodeArray[j].PurchNet;
                        end;
                end;

                if TotalAmount <> 0 then begin

                     Accsdatamodule.TempVATDB.edit;
                     Accsdatamodule.TempVATDB.append;
                     Accsdatamodule.TempVATDB.post;
                     Accsdatamodule.TempVATDB.append;
                     Accsdatamodule.TempVATDB['Label'] := 'Exempt Total (Not Included in VAT Return) .... ';
                     st := '';
                     DoubleToStr (TotalAmount,st,'%8.2f', true, false, 20, True);
                     slimleft (st);
                     Accsdatamodule.TempVATDB['AmountText'] := st;
                     Accsdatamodule.TempVATDB.post;

                end

              end;
              // Ch014 end

           end;



  //   Accsdatamodule.SQLUpdate.sql.clear;
  //   Accsdatamodule.SQLUpdate.sql.Add('alter table "Year-1"');
  //   Accsdatamodule.SQLUpdate.sql.Add('Drop INDEX ByTaxCode');
  //   Accsdatamodule.SQLUpdate.ExecSQL;

  //   Accsdatamodule.SQLUpdate.sql.clear;
  //   Accsdatamodule.SQLUpdate.sql.Add('Drop INDEX ON "Transactions"');
  //   Accsdatamodule.SQLUpdate.ExecSQL;


        

end;



// End Invoice based VAT




// These Procedures are all for Payment Based VAT

Procedure PaymentVatAuditTrail(SalePurch : Char; MarkasClaimed : Boolean; ClaimID : Integer; SpanYear : Boolean);

begin
        if SalePurch = 'S' then Showmessage('Code goes here to generate Sales Payment Based Figures');
        if SalePurch = 'P' then Showmessage('Code goes here to generate Purchase Payment Based Figures');





end;





// End Payment based VAT

end.
