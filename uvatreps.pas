unit uvatreps;
{
  This new unit is used to build the temporary database etc for the new vat Reports
  
}
{Changes

17/05/15, 17/07/15 & 24/07/15 - unit updated to allow a mixed VAT invoice & payment based VAT report

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


    Procedure VatAuditTrail;
    Procedure PrintVatReport;
    Procedure NormalVatReport;
    Procedure NIVatFigures;


var
    VatArray:array[0..9] of TVatArray;
    SalesCount, Purchcount : integer;

implementation

uses
    Accsdata, Vars, Nomrpt, sysutils, dialogs, DBGen, Types, UVatAuditReport, forms, calcs, clears, windows, uvatreport, univatreport, db, upaymentVAT;


Procedure VatAuditTrail;
var
    TaxAudit : Boolean;
    Tx_Start, Tx_End : integer;
    FROMDT : TDateTime;
    TODT : TDateTime;
    TESTDT : TDateTime;
    i, j : integer;
    TxRecord : Integer;
    OKTOPRINT : Boolean;
    Check_9_Types : Boolean;
    RecordType : Integer;
    Sub : INTEGER;
    NEG : BOOLEAN;
    TempInt, TxType, OrigType : Integer;
    Tempstr, tempstring : string;
    AMT, temprate     : real;
    VatCode, PreviousVatCode : string[1];
    RunningAmount, RunningVat : real;
    RunningCount : integer;
    st : shortstring;
    F : textfile;
    TotalAmount, TotalVat : real;


begin

    SchRecf  := NominalReportForm.TransFrom;
    SchRect  := NominalReportForm.TransTo;
    try FROMDT   := strtodatetime(NominalReportForm.VatDateFrom.text);
    except FROMDT := 0;
    end;
    try TODT     := strtodatetime(NominalReportForm.VatDateTo.text);
    except TODT := 99999;
    end;
    TaxAudit := NominalReportForm.VatAuditChecked.Checked;
    Tx_Start := Schrecf;
    Tx_End   := Schrect;

    VatCode := '';
    PreviousVatCode := '';
    RunningAmount := 0;
    RunningVat := 0;
    RunningCount := 0;




    tempstr := '';

    // Initialising The VAT Array

  {  for j:= 0 to 9 do begin
         VatArray[j].VatCode := '';
         VatArray[j].VatRate := '';
         VatArray[j].VatPercent := '';
         VatArray[j].SalesNet := 0;
         VatArray[j].SalesVat := 0;
         VatArray[j].PurchNet := 0;
         VatArray[j].PurchVat := 0;
    end;

    for j:= 0 to 9 do Begin
                       VatArray[j].VatCode := Cash1.xTaxIds[j];
                       TempRate := Cash1.xTaxRates[j] / 100;
                       VatArray[j].VatRate := vartostr(Format ( '%f', [TempRate]));
                       if TempRate = 0 then VatArray[j].VatPercent := 'Zero'
                        else VatArray[j].VatPercent := VatArray[j].VatRate + '%';
                       if Cash2.Vat_inc_exc[j] = 'I' then VatArray[j].NIInclude := True
                        else VatArray[j].NIInclude := false;
    End ;
    }

    Accsdatamodule.TransactionsDB.close;

    Accsdatamodule.SQLUpdate.sql.clear;
    Accsdatamodule.SQLUpdate.sql.Add('CREATE INDEX ByTaxCode ON Transactions (TaxCode)');
    Accsdatamodule.SQLUpdate.ExecSQL;

    Accsdatamodule.TransactionsDB.IndexName := 'ByTaxCode';

    Accsdatamodule.TransactionsDB.open;

    for I := 0 to Accsdatamodule.TransactionsDB.IndexFieldCount - 1 do
        if Accsdatamodule.TransactionsDB.IndexFields[I].Name = 'ByTaxCode' then
           begin
                Accsdatamodule.TransactionsDB.IndexName := Accsdatamodule.TransactionsDB.IndexDefs.Items[I].Name;
           end;

    Accsdatamodule.TransactionsDB.last;

    Accsdatamodule.TempVATDB.edit;

    if Act = 11 then begin

                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB.post;
                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB['Label'] := 'SALES INVOICE VAT AUDIT TRAIL';         // TGM AB 24/07/15 was 'SALES VAT'
                        Accsdatamodule.TempVATDB.post;
                //        Accsdatamodule.TempVATDB.append;
               //         Accsdatamodule.TempVATDB['Label'] := '--------------------------------------';
               //         Accsdatamodule.TempVATDB.post;
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
                        Accsdatamodule.TempVATDB['Label'] := 'PURCHASE INVOICE VAT AUDIT TRAIL';           // TGM AB 24/07/15 was 'PURCHASE VAT'
                        Accsdatamodule.TempVATDB.post;
               //         Accsdatamodule.TempVATDB.append;
               //         Accsdatamodule.TempVATDB['Label'] := '--------------------------------------';
               //         Accsdatamodule.TempVATDB.post;
                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB['Label'] := '======================================';
                        Accsdatamodule.TempVATDB.post;
                        Accsdatamodule.TempVATDB.append;
                        Accsdatamodule.TempVATDB.post;
             end;


    for i:= Accsdatamodule.TransactionsDB.RecordCount downto 1 do begin

      TxRecord := Accsdatamodule.TransactionsDB['TxNo'];

   //   if TxRecord = 55 then begin
   //      showmessage('Here!')
   //   end;

      IF (TxRecord>=SCHRECF) AND (TxRecord<=SCHRECT) THEN
	BEGIN

             OKTOPRINT:=TRUE;
	      { Check the next record to see if its a VAT Record }
	      Check_9_Types := false;
              RecordType := Accsdatamodule.TransactionsDB['TxType'];
              tempstr := '';
              try tempstr := vartostr(Accsdatamodule.TransactionsDB['TaxCode']);
              except
              end;
          //    slimall(tempstr);
              if tempstr = '' then oktoprint := false;
              if tempstr = ' ' then oktoprint := false;

     { Ch014
              if cash2.XCOUNTRY = 1 then begin
                  for j := 0 to 9 do begin
                      if VatArray[j].Vatcode = tempstr then begin
                          if VatArray[j].NIInclude = false then oktoprint := false;
                      end;
                  end;
              end;
       end Ch014   }

       // Ch017
       if ((NominalReportForm.IncludeExemptCB.Checked = False) and (cash2.XCOUNTRY = 1)) then begin
                  for j := 0 to 9 do begin
                      if VatArray[j].Vatcode = tempstr then begin
                          if VatArray[j].NIInclude = false then oktoprint := false;
                      end;
                  end;
              end;
       // end Ch017

          //    if tempstr <> '' then showmessage('Eureka');
              if ((RecordType = 9) and (length (tempstr) = 1)) then begin
                  Accsdatamodule.TransactionsDB.prior;
       			if ((vartostr(Accsdatamodule.TransactionsDB['TaxCode']) <> '') and (vartostr(Accsdatamodule.TransactionsDB['TaxCode']) <> ' ')) then begin  // was ' '
                           if Accsdatamodule.TransactionsDB['TxType'] = 0 then Check_9_Types := True;
                        end;
                  Accsdatamodule.TransactionsDB.Locate('TxNo',Txrecord, []);;
              end;

         //     if vartostr(Accsdatamodule.TransactionsDB['TaxCode']) = ' ' then OKTOPRINT:=FALSE;
         //     if vartostr(Accsdatamodule.TransactionsDB['TaxCode']) = '0' then OKTOPRINT:=FALSE;

              If oktoprint Then
		  Begin
       //		    vat_count := pos ( currstr, testcode );
       //		    If vat_count > 0 Then
       //		      oktoprint := ( Cash2.vat_inc_exc[vat_count-1] = 'I' );
		  End;

             RecordType := Accsdatamodule.TransactionsDB['TxType'];
             if not ((RecordType = 0) or (RecordType = 10)) then OKTOPRINT:=FALSE;

             try TESTDT := Accsdatamodule.TransactionsDB['TxDate'];
             except TESTDT := 0;
             end;

   //	      GETITEM(TxFile,2);
   //	      IF (CURRINT<FROMDT) OR (CURRINT>TODT) THEN OKTOPRINT:=FALSE;

             IF (TESTDT<FROMDT) OR (TESTDT>TODT) THEN OKTOPRINT:=FALSE;

   	     IF OKTOPRINT AND (ACT IN [11,12]) THEN
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
		      IF ((ACT=11) AND (SUB<>1))
		      OR ((ACT=12) AND (SUB<>2)) THEN OKTOPRINT:=FALSE;
		   (*   IF OKTOPRINT THEN
			BEGIN
			  GETITEM (TxFile,10);
			  IF CURRDISP[1]<>LASTCODE THEN
			    BEGIN
			      IF LASTCODE<>CHR(0) THEN SUBTOTAL;
			      LASTCODE:=CURRDISP[1];


			      SUBTAX  :=0;
			      SUBAMT  :=0;
			      SUBREC  :=0;
			    END;
			END; *)
	  	     END;
	   	END;
                if oktoprint then begin
                                       // showmessage(vartostr(TxRecord));

                                        VatCode := vartostr(Accsdatamodule.TransactionsDB['TaxCode']);

                                        if PreviousVatCode <> '' then begin  // not the first record

                                           if PreviousVatCode <> VatCode then begin
                                               Accsdatamodule.TempVATDB.append;
                                               Accsdatamodule.TempVATDB['Label'] := '-----------------------------------------------------------------------------------------------------------------------------------------';     // TGM AB 24/07/15
                                               Accsdatamodule.TempVATDB.post;
                                               Accsdatamodule.TempVATDB.append;
                                               for j:= 0 to 9 do Begin
                                                   if Cash1.xTaxIds[j] = PreviousVatCode then TempString := VatArray[j].VatPercent;
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
                                                    if VatArray[j].VatCode = PreviousVatCode then begin
                                                       if act = 11 then begin
                                                                VatArray[j].SalesNet := RunningAmount;
                                                                VatArray[j].SalesVat := RunningVat;
                                                       end else begin
                                                                VatArray[j].PurchNet := RunningAmount;
                                                                VatArray[j].PurchVat := RunningVat;
                                                                end;
                                                    end;
                                               End ;
                                               if Act = 11 then SalesCount := SalesCount + RunningCount
                                                  else Purchcount := Purchcount + RunningCount;
                                               RunningAmount := 0;
                                               RunningVat := 0;
                                               RunningCount := 0;
                                           end;

                                           Accsdatamodule.TempVATDB.append;
                                           Accsdatamodule.TempVATDB['Record'] := Accsdatamodule.TransactionsDB['TxNo'];
                                           Accsdatamodule.TempVATDB['TxDate'] := Accsdatamodule.TransactionsDB['TxDate'];
                                           Accsdatamodule.TempVATDB['Description'] := Accsdatamodule.TransactionsDB['Descript'];
                                      //     if Act = 11 then Accsdatamodule.TempVATDB['Account'] := GetSLPLAccountName ( SlFile, Accsdatamodule.TransactionsDB['Account'])
                                      //          else Accsdatamodule.TempVATDB['Account'] := GetSLPLAccountName ( PlFile, Accsdatamodule.TransactionsDB['Account']);
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
	   END; // Act 11 or 12
        //end;
        if i = 1 then begin
             Accsdatamodule.TempVATDB.edit;
             Accsdatamodule.TempVATDB.append;
             Accsdatamodule.TempVATDB['Label'] := '-----------------------------------------------------------------------------------------------------------------------------------------';           // TGM AB 24/07/15
             Accsdatamodule.TempVATDB.post;
             Accsdatamodule.TempVATDB.append;
             for j:= 0 to 9 do Begin
                 if Cash1.xTaxIds[j] = PreviousVatCode then TempString := VatArray[j].VatPercent;
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
                  if VatArray[j].VatCode = PreviousVatCode then begin
                        if act = 11 then begin
                                                                VatArray[j].SalesNet := RunningAmount;
                                                                VatArray[j].SalesVat := RunningVat;
                                                       end else begin
                                                                VatArray[j].PurchNet := RunningAmount;
                                                                VatArray[j].PurchVat := RunningVat;
                                                                end;
                        end;
             End;
             if Act = 11 then SalesCount := SalesCount + RunningCount
                else PurchCount := PurchCount + RunningCount;
             RunningAmount := 0;
             RunningVat := 0;
             RunningCount := 0;
           end;
        Accsdatamodule.TransactionsDB.prior;

        end; // For i:=

        Accsdatamodule.TransactionsDB.IndexName := '';

        if Act = 11 then begin
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
                              if VatArray[j].NIInclude = True then begin
                                       TotalAmount := TotalAmount + VatArray[j].SalesNet;
                                       TotalVat := TotalVat + VatArray[j].SalesVat;
                              end;
                          end
                                else begin
                                       TotalAmount := TotalAmount + VatArray[j].SalesNet;
                                       TotalVat := TotalVat + VatArray[j].SalesVat;
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

                        if VatArray[j].NIInclude = False then begin
                                       TotalAmount := TotalAmount + VatArray[j].SalesNet;
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
                              if VatArray[j].NIInclude = True then begin
                                       TotalAmount := TotalAmount + VatArray[j].PurchNet;
                                       TotalVat := TotalVat + VatArray[j].PurchVat;
                              end;
                          end
                                else begin
                                       TotalAmount := TotalAmount + VatArray[j].PurchNet;
                                       TotalVat := TotalVat + VatArray[j].PurchVat;
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

                        if VatArray[j].NIInclude = False then begin
                                       TotalAmount := TotalAmount + VatArray[j].PurchNet;
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


end;

Procedure PrintVatReport;
begin

         NormalVatReport; // TGM AB 17/07/15

  //      if NominalReportForm.PaymentCb.Checked then UPaymentVAT.RunReport        // TGM AB 17/07/15
  //              else NormalVatReport;                                            // TGM AB 17/07/15

end;



Procedure NormalVatReport;
var
        i,j : integer;
        runningnet, runningvat, temprate : real;
        st : shortstring;
begin

        Accsdatamodule.TempVATDB.close;
        Accsdatamodule.TempVATDB.EmptyTable;
        Accsdatamodule.TempVATDB.open;
        Accsdatamodule.TempVATDB.edit;

        for j:= 0 to 9 do begin
         VatArray[j].VatCode := '';
         VatArray[j].VatRate := '';
         VatArray[j].VatPercent := '';
         VatArray[j].SalesNet := 0;
         VatArray[j].SalesVat := 0;
         VatArray[j].PurchNet := 0;
         VatArray[j].PurchVat := 0;
        end;

        for j:= 0 to 9 do Begin
                       VatArray[j].VatCode := Cash1.xTaxIds[j];
                       TempRate := Cash1.xTaxRates[j] / 100;
                       VatArray[j].VatRate := vartostr(Format ( '%f', [TempRate]));
                       if TempRate = 0 then VatArray[j].VatPercent := 'Zero'
                        else VatArray[j].VatPercent := VatArray[j].VatRate + '%';
                       if Cash2.Vat_inc_exc[j] = 'I' then VatArray[j].NIInclude := True
                        else VatArray[j].NIInclude := false;
        End ;

        SalesCount := 0;
        Purchcount := 0;

        // TGM AB 17/05/15
        if cash2.XAllocation and cash2.XPaymentVAT then begin        // TGM AB 09/03/18 - Added cash2.XAllocation to fix issue where some systems have the XPayment varible set accidentally
             // Decide which reports need run,  payment or invoice VAT for both Sales & Purchases
             if cash11.xSalesPaymentVAT = 'Y' then begin
                 UPaymentVAT.AuditReport('S');
             end else begin
                 Act := 11;
                 VATAuditTrail;
             end;
             if cash11.xPurchPaymentVAT = 'Y' then begin
                 UPaymentVAT.AuditReport('P');
             end else begin
                 Act := 12;
                 VATAuditTrail
             end
        end else begin
                 Act := 11;
                 VATAuditTrail;
                 Act := 12;
                 VATAuditTrail;
        end;


        // TGM AB 17/05/15 end

        // Act := 11;          // TGM AB 17/05/15
        // VATAuditTrail;      // TGM AB 17/05/15
        // Act := 12;          // TGM AB 17/05/15
        // VATAuditTrail;      // TGM AB 17/05/15

        runningnet := 0;
        runningvat := 0;
        if not bool(VatReport) then Application.CreateForm(TVatReport, VatReport);
        if not bool(NIVatReport) then Application.CreateForm(TNIVatReport, NIVatReport);
        if not bool(VatAuditReport) then Application.CreateForm(TVatAuditReport, VatAuditReport);

        // sales

        VatReport.SalesVatCodes.Lines.Clear;
        VatReport.SalesVatRates.Lines.Clear;
        VatReport.SalesNetAmounts.Lines.Clear;
        VatReport.SalesVatAmounts.Lines.Clear;
        for I:= 0 to 9 do Begin
                       VatReport.SalesVatCodes.Lines.add(VatArray[i].VatCode);
                       VatReport.SalesVatRates.Lines.add(VatArray[i].VatRate);
                       st := '';
                       DoubleToStr (VatArray[i].SalesNet,st,'%8.2f', true, false, 20, True);
                       slimleft (st);
                       VatReport.SalesNetAmounts.Lines.add(st);
                       st := '';
                       DoubleToStr (VatArray[i].SalesVat,st,'%8.2f', true, false, 20, True);
                       slimleft (st);
                       VatReport.SalesVatAmounts.Lines.add(st);
                       Runningnet := Runningnet + VatArray[i].SalesNet;
                       Runningvat := Runningvat + VatArray[i].SalesVat;
        End ;
        st := '';
        DoubleToStr (Runningnet,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        VatReport.SalesTotalNet.Caption := st;
        st := '';
        DoubleToStr (Runningvat,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        VatReport.SalesTotalVat.Caption := st;

        // Purchases

        runningnet := 0;
        runningvat := 0;
        VatReport.PurchVatCodes.Lines.Clear;
        VatReport.PurchVatRates.Lines.Clear;
        VatReport.PurchNetAmounts.Lines.Clear;
        VatReport.PurchVatAmounts.Lines.Clear;
        for I:= 0 to 9 do Begin
                       VatReport.PurchVatCodes.Lines.add(VatArray[i].VatCode);
                       VatReport.PurchVatRates.Lines.add(VatArray[i].VatRate);
                       st := '';
                       DoubleToStr (VatArray[i].PurchNet,st,'%8.2f', true, false, 20, True);
                       slimleft (st);
                       VatReport.PurchNetAmounts.Lines.add(st);
                       st := '';
                       DoubleToStr (VatArray[i].PurchVat,st,'%8.2f', true, false, 20, True);
                       slimleft (st);
                       VatReport.PurchVatAmounts.Lines.add(st);
                       Runningnet := Runningnet + VatArray[i].PurchNet;
                       Runningvat := Runningvat + VatArray[i].PurchVat;
        End ;
        st := '';
        DoubleToStr (Runningnet,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        VatReport.PurchTotalNet.Caption := st;
        st := '';
        DoubleToStr (Runningvat,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        VatReport.PurchTotalVat.Caption := st;

        VatReport.AccountsName.Caption := Cash1.XCOMPANY;
        NIVatReport.AccountsName.Caption := Cash1.XCOMPANY;
        VatAuditReport.AccountsName.Caption := Cash1.XCOMPANY;
        VatReport.KingswoodLbl.caption :=  'Kingswood Accounts ' + Verno;
        NIVatReport.KingswoodLbl.caption :=  'Kingswood Accounts ' + Verno;
        VatAuditReport.KingswoodLbl.caption :=  'Kingswood Accounts ' + Verno;
        VatReport.DataSet.Caption :=  Accsdata.AccsDataModule.AccsDataBase.AliasName;
        NIVatReport.DataSet.Caption :=  Accsdata.AccsDataModule.AccsDataBase.AliasName;
        VatAuditReport.DataSet.Caption :=  Accsdata.AccsDataModule.AccsDataBase.AliasName;

        if Nomrpt.NominalReportForm.VatDateFrom.Text <> '  /  /  ' then begin
           VatAuditReport.Range.Caption := 'Date Range : ' + Nomrpt.NominalReportForm.VatDateFrom.text + ' to ' + Nomrpt.NominalReportForm.VatDateTo.text;
           NIVatReport.Range.Caption := 'Date Range : ' + Nomrpt.NominalReportForm.VatDateFrom.text + ' to ' + Nomrpt.NominalReportForm.VatDateTo.text;
           VatReport.Range.Caption := 'Date Range : ' + Nomrpt.NominalReportForm.VatDateFrom.text + ' to ' + Nomrpt.NominalReportForm.VatDateTo.text;

        end
            else begin
                      VatAuditReport.Range.Caption := 'Transaction Range : ' + Nomrpt.NominalReportForm.VatTxFrom.text + ' to ' + Nomrpt.NominalReportForm.VatTxTo.text;
                      NIVatReport.Range.Caption := 'Transaction Range : ' + Nomrpt.NominalReportForm.VatTxFrom.text + ' to ' + Nomrpt.NominalReportForm.VatTxTo.text;
                      VatReport.Range.Caption := 'Transaction Range : ' + Nomrpt.NominalReportForm.VatTxFrom.text + ' to ' + Nomrpt.NominalReportForm.VatTxTo.text;
            end;



        if cash2.XCOUNTRY = 2 then VatReport.Preview
                else begin
                        NIVatFigures;
                        NIVatReport.Preview;
                end;
        if NominalReportForm.VatAuditChecked.Checked then begin
                if not bool(VatAuditReport) then Application.CreateForm(TVatAuditReport, VatAuditReport);
                VatAuditReport.Preview;
        end;
end;

Procedure NIVatFigures;
var
        i, code : integer;
        st, TextRate : shortstring;
        EuroTransactions : boolean;
        Box1, Box2, Box3, Box4, Box5, Box6, Box7, Box8, Box9 : real;
        Rate : real;
        TempReal : real;
begin
//     NIVatReport.Box1
        Box1 := 0;
        Box2 := 0;
        Box3 := 0;
        Box4 := 0;
        Box5 := 0;
        Box6 := 0;
        Box7 := 0;
        Box8 := 0;
        Box9 := 0;
        EuroTransactions := false;

        for I:= 0 to 9 do Begin
                if VatArray[i].NIInclude then begin
                    Box1 := Box1 + VatArray[i].SalesVat;
                    if ((cash2.XPaymentVAT) and (cash11.xSalesPaymentVAT = 'Y')) then Box6 := Box6 + VatArray[i].SalesNet - VatArray[i].SalesVat              // TGM AB 21/07/17
                        else Box6 := Box6 + VatArray[i].SalesNet;                                                                                              // TGM AB 21/07/17
                    Box4 := Box4 + VatArray[i].PurchVat;
                    if ((cash2.XPaymentVAT) and (cash11.xPurchPaymentVAT = 'Y')) then Box7 := Box7 + VatArray[i].PurchNet - VatArray[i].PurchVat              // TGM AB 21/07/17
                        else Box7 := Box7 + VatArray[i].PurchNet;                                                                                              // TGM AB 21/07/17
                end;
                if VatArray[i].VatCode = 'E' then begin
                   if ((VatArray[i].PurchNet <> 0.00) or (VatArray[i].SalesNet <> 0)) then EuroTransactions := True;
                end;
        End ;


        if Eurotransactions then begin
        showmessage('Box 9 on your VAT form has a value.' + #13#10
              + 'This comes from transactions entered with VAT Code E.' + #13#10
              + 'VAT Code E should only be used for goods imported from other EC States,' + #13#10
              + 'where these goods would be subject to standard Rate VAT if purchased in UK.' + #13#10
              + 'If you did not import goods in this category, please exit this report and edit the entries where you used VAT Code E, changing the Code E to a UK VAT Code' + #13#10
              + 'otherwise continue, entering the standard rate for VAT when prompted.');
        TextRate := InputBox('VAT Rate For Imports From EC States', 'What VAT Rate to be used for Code E, (Box 9)', '20.0');      // TGM AB 21/04/17 was 17.5
        Rate := 0;
        Val(TextRate,Rate,code);
        Rate := (Rate / 100);
                for I:= 0 to 9 do Begin
                        if VatArray[i].VatCode = 'E' then begin
                           Tempreal := (VatArray[i].PurchNet * Rate);
                           Box2 := Tempreal;
                           Box4 := box4 + tempreal;
                           Box9 := VatArray[i].PurchNet;
                           Box8 := VatArray[i].SalesNet;
                end;
        End ;

        end;

        Box3 := Box1 + Box2;

        NIVatReport.Box1.Caption := '';

        if ((Box4 - Box3) > 0) then begin
            box5 := (round(box4*100) - round(box3*100))/100;         // TGM AB 21/04/17
            NIVatReport.Comment.Caption := '(Repayable)';
        end
                else begin
                     Tempreal := (round(box4*100)-round(box3*100))/100;      // TGM AB 21/04/17
                     Box5 := 0 - Tempreal;
                     NIVatReport.Comment.Caption := '(Payable)';
                end;

        
        st := '';
        DoubleToStr (Box1,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        NIVatReport.Box1.Caption := st;
        st := '';
        DoubleToStr (Box2,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        NIVatReport.Box2.Caption := st;
        st := '';
        DoubleToStr (Box3,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        NIVatReport.Box3.Caption := st;
        st := '';
        DoubleToStr (Box4,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        NIVatReport.Box4.Caption := st;
        st := '';
        DoubleToStr (Box5,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        NIVatReport.Box5.Caption := st;
        st := '';
        DoubleToStr (Box6,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        NIVatReport.Box6.Caption := st;
        st := '';
        DoubleToStr (Box7,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        NIVatReport.Box7.Caption := st;
        st := '';
        DoubleToStr (Box8,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        NIVatReport.Box8.Caption := st;
        st := '';
        DoubleToStr (Box9,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        NIVatReport.Box9.Caption := st;


end;






end.
