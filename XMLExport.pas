unit XMLExport;

{Changes
16/09/16 - Extended Statement Report

            OutputCustomerExtendedStatementAsXML(CompanyName, AFileName : string;

            CompanyName - Accounts company name eg ACCS - not case sensitive
            AFileName - Filename for export file e.g. 'c:\test.xml'



27/05/16 - Customer Age Of Debt Export

            OutputCustomerAgeOfDebtAsXML(AFileName : string; RepDate: TDateTime; MonthsBy : Integer; IncludeZeroBalances : Boolean);

            CompanyName - Accounts company name eg ACCS - not case sensitive
            AFileName - Filename for export file e.g. 'c:\test.xml'
            RepDate - Start date for the report (should by default be the current date)
            MonthsBy - The number of months included in each field - choices are 1,2,3,6,9 or 12 as per Accounts report
            IncludeZeroBalances - True / False to include zero transactions, including zero balance transactions will give a history breakdown
                                  & turnover figure even though there is no current balance

27/05/16 - New Unit created specifically to generate XML Export files for loading into App

}

interface

uses  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
      Db, DBTables, StdCtrls,COMObj, math;

      procedure OutputCustomerAgeOfDebtAsXML(CompanyName, AFileName : string; RepDate: TDateTime; MonthsBy : Integer; IncludeZeroBalances : Boolean);
      Function OpenCompanyData (CompanyName : string) : Boolean;
      procedure OutputCustomerExtendedStatementAsXML(CompanyName, AFileName : string);          // TGM AB 29/07/16

      //
      // AReportType: 'J', 'P', 'Q'
      // AFileName: Name of file to be generated.
      procedure OutputProformaAsXML(const AReportType: Char; const ACompanyName, AFileName: string);

implementation

uses MSXML2_TLB, vars, params, calculatemonths, rcslist, AccsData, chkcomp, DBGEN, AbortPrg, Types, uLedgerReport,
     JobCardReportSetup;


Function OpenCompanyData (CompanyName : string) : Boolean;
var
        i : integer;
        CompanyFound : boolean;
begin
             CompanyFound := False;
             Result := False;

             FCheckName.OnShow(FCheckName);
             FCheckName.OnActivate(FCheckName);
             FCheckName.GatherCompanies;
             for i:=0 to Fcheckname.CheckCompanyName.Items.Count -1 do begin
                                                                            if (AnsiLowerCase(CompanyName) = (AnsiLowerCase(Fcheckname.CheckCompanyName.Items[i]))) then begin
                                                                                     CompanyName := Fcheckname.CheckCompanyName.Items[i];
                                                                                     CompanyFound := True;
                                                                            end;
                                                                       end;

             if CompanyFound then begin
                                         FCheckname.CheckCompanyName.Text := companyname;
                                         AccsDataModule.UseThisAlias(companyname);
                                         Result := True;
                                      end
                  else begin
                        AbortProgram ('Incorrect Company Name');
                  end;

end;

procedure OutputCustomerAgeOfDebtAsXML(CompanyName, AFileName : string; RepDate: TDateTime; MonthsBy : Integer; IncludeZeroBalances : Boolean);
var
   Document : IXMLDOMDocument;
   Report, ReportHeader, Details, Rows, ChildNode : IXMLDOMNode;
   i : integer;
   AgedBy, tempstr : String;
   IncludeRecord : Boolean;
begin

 if OpenCompanyData(CompanyName) then begin

   If Not OpenAll Then AbortProgram ('Error Opening Database Files - Contact Kingswood');

   // initiallise the form and update the data as per requirements

   case MonthsBy of
        1 : begin
           CustSuppListing.AgeByCombo.ItemIndex := 0;
           AgedBy := '1Month';
        end;
        2 : begin
           CustSuppListing.AgeByCombo.ItemIndex := 1;
           AgedBy := '2Months';
        end;
        3 : begin
           CustSuppListing.AgeByCombo.ItemIndex := 2;
           AgedBy := '3Months';
        end;
        6 : begin
           CustSuppListing.AgeByCombo.ItemIndex := 3;
           AgedBy := '6Months';
        end;
        9 : begin
           CustSuppListing.AgeByCombo.ItemIndex := 4;
           AgedBy := '9Months';
        end;
        12 : begin
           CustSuppListing.AgeByCombo.ItemIndex := 5;
            AgedBy := '12Months';
        end;
   end;

   CalculateMonths.UpdateSLFigures(RepDate,CustSuppListing.AgeByCombo.ItemIndex);
   CalculateMonths.UpdatePLFigures(Repdate,CustSuppListing.AgeByCombo.ItemIndex);

   ReportHeader := nil;
   Details := nil;
   ChildNode := nil;
   Rows := nil;

   try
      Document := CreateOleObject('MSXML2.DOMDocument') as IXMLDOMDocument;
   except
      raise Exception.Create('Error creating MSXML2.DOMDocument. Please contact Kingswood.');
   end;

   try

      Document.appendChild(Document.createProcessingInstruction('xml', 'version="1.0" encoding="UTF-8"'));

      Report := Document.createElement('report'); // Create Report
      Document.appendChild(Report);

      ReportHeader := Document.createElement('header');          // start of header
      ChildNode := Document.createElement('name');
      ChildNode.Set_text('Customer Age Of Debt');
      ReportHeader.appendChild(ChildNode);
      ChildNode := Document.createElement('dataset');
      ChildNode.Set_text(RFarmGate.PLocation[2]);
      ReportHeader.appendChild(ChildNode);
      ChildNode := Document.createElement('agedby');
      ChildNode.Set_text(AgedBy);
      ReportHeader.appendChild(ChildNode);
      Report.appendChild(ReportHeader);                          // end of header


      Details := Document.createElement('rows');                // start of details

      accsdatamodule.SLFileDB.first;

      for i:= 1 to accsdatamodule.SLFileDB.recordcount do begin

      IncludeRecord := True;

      if accsdatamodule.SLFileDB['Balance'] = 0 then begin
          if IncludeZeroBalances then Includerecord := true
              else Includerecord := false;
      end;

      if  accsdatamodule.SLFileDB['Active'] = false then Includerecord := false;

      if Includerecord then begin


                rows := Document.createElement('detailrow');              // new detail row

                ChildNode := Document.createElement('accountno');
                ChildNode.Set_text(vartostr(i));
                rows.appendChild(ChildNode);
                Details.appendChild(rows);

                try tempstr := accsdatamodule.SLFileDB['Name']
                except tempstr := ''
                end;

                ChildNode := Document.createElement('accountname');
                ChildNode.Set_text(tempstr);
                rows.appendChild(ChildNode);
                Details.appendChild(rows);

                try tempstr := vartostr(accsdatamodule.SLFileDB['AreaCode'])
                except tempstr := ''
                end;

                ChildNode := Document.createElement('areacode');
                ChildNode.Set_text(tempstr);
                rows.appendChild(ChildNode);
                Details.appendChild(rows);

                try tempstr := vartostr(accsdatamodule.SLFileDB['PhoneNo1'])
                except tempstr := ''
                end;

                ChildNode := Document.createElement('phoneno1');
                ChildNode.Set_text(tempstr);
                rows.appendChild(ChildNode);
                Details.appendChild(rows);

                try tempstr := vartostr(accsdatamodule.SLFileDB['Balance'])
                except tempstr := ''
                end;

                ChildNode := Document.createElement('balance');
                ChildNode.Set_text(tempstr);
                rows.appendChild(ChildNode);
                Details.appendChild(rows);

                try tempstr := vartostr(accsdatamodule.SLFileDB['AgeCurr'])
                except tempstr := ''
                end;

                ChildNode := Document.createElement('current');
                ChildNode.Set_text(tempstr);
                rows.appendChild(ChildNode);
                Details.appendChild(rows);

                try tempstr := vartostr(accsdatamodule.SLFileDB['Age1'])
                except tempstr := ''
                end;

                ChildNode := Document.createElement('column1');
                ChildNode.Set_text(tempstr);
                rows.appendChild(ChildNode);
                Details.appendChild(rows);

                try tempstr := vartostr(accsdatamodule.SLFileDB['Age2'])
                except tempstr := ''
                end;

                ChildNode := Document.createElement('column2');
                ChildNode.Set_text(tempstr);
                rows.appendChild(ChildNode);
                Details.appendChild(rows);

                try tempstr := vartostr(accsdatamodule.SLFileDB['Age3'])
                except tempstr := ''
                end;

                ChildNode := Document.createElement('column3');
                ChildNode.Set_text(tempstr);
                rows.appendChild(ChildNode);
                Details.appendChild(rows);

                try tempstr := vartostr(accsdatamodule.SLFileDB['Turnover'])
                except tempstr := ''
                end;

                ChildNode := Document.createElement('turnover');
                ChildNode.Set_text(tempstr);
                rows.appendChild(ChildNode);
                Details.appendChild(rows);

                Report.appendChild(Details);

      end;

      accsdatamodule.SLFileDB.next;

      end;

                                   // end of details



      if (FileExists(AFileName)) then
         DeleteFile(AFileName);

      Document.save(AFileName);
   finally
    ReportHeader := nil;
    Details := nil;
    ChildNode := nil;
    Rows := nil;
   end;

  CloseAll ( MaxDatabases );

 end;  // OpenCompanyData

end;



procedure OutputCustomerExtendedStatementAsXML(CompanyName, AFileName : string{; CustSupp : Char; CustSuppNo : integer} );              // TGM AB 29/07/16
var
   Document : IXMLDOMDocument;
   Report, ReportHeader, Details, Rows, ChildNode, Trans, Lines : IXMLDOMNode;
   i : integer;
   LineType, TempStr : string;
   TempReal : Real;
   TxNo : Integer;

begin

   Prog := CUSTSTM;

   if OpenCompanyData(CompanyName) then begin

       If Not OpenAll Then AbortProgram ('Error Opening Database Files - Contact Kingswood');

       LedgerReport.RunStatementReportExport(CompanyName);   // Generate the data & fill into report table

       ReportHeader := nil;
       Details := nil;
       ChildNode := nil;
       Rows := nil;
       Trans := nil;
       Lines := nil;

       try
             Document := CreateOleObject('MSXML2.DOMDocument') as IXMLDOMDocument;
       except
             raise Exception.Create('Error creating MSXML2.DOMDocument. Please contact Kingswood.');
       end;

       Report := Document.createElement('report'); // Create Report
       Document.appendChild(Report);

       ReportHeader := Document.createElement('header');          // start of header
       ChildNode := Document.createElement('name');
       ChildNode.Set_text('Customer Extended Statement');
       ReportHeader.appendChild(ChildNode);
       ChildNode := Document.createElement('dataset');
       ChildNode.Set_text(CompanyName);
       ReportHeader.appendChild(ChildNode);
       ChildNode := Document.createElement('agedby');
       ChildNode.Set_text('12 months');
       ReportHeader.appendChild(ChildNode);
       Report.appendChild(ReportHeader);                          // end of header

       AccsdataModule.LedgerReportDB.open;
       AccsdataModule.LedgerReportDB.First;

       Details := Document.createElement('Customers');                // start of customers

       for i := 1 to AccsdataModule.LedgerReportDB.recordcount do begin

           LineType := '';
           if vartostr(AccsdataModule.LedgerReportDB['LineType']) <> '' then begin
                LineType := AccsdataModule.LedgerReportDB['LineType'];
           end;

           if LineType = 'h1' then begin     // start of new customer

              rows := Document.createElement('Customer');              // new customer
              ChildNode := Document.createElement('accountno');
              ChildNode.Set_text(AccsdataModule.LedgerReportDB['AccNo']);
              rows.appendChild(ChildNode);
              ChildNode := Document.createElement('name');

              if vartostr(AccsdataModule.LedgerReportDB['CustomerAddressLabel']) <> '' then TempStr := AccsdataModule.LedgerReportDB['CustomerAddressLabel']
                        else TempStr := '';
              ChildNode.Set_text(TempStr);
              rows.appendChild(ChildNode);

              While LineType <> 'hb' do begin
                  AccsdataModule.LedgerReportDB.next;
                  if vartostr(AccsdataModule.LedgerReportDB['LineType']) <> '' then LineType := AccsdataModule.LedgerReportDB['LineType'];
              end;

              ChildNode := Document.createElement('openingbalance');
              Tempreal := round(AccsdataModule.LedgerReportDB['Balance']*100)/100;
              ChildNode.Set_text(vartostr(TempReal));

              rows.appendChild(ChildNode);
              Details.appendChild(rows);


              While (LineType <> 'cb') do begin
                  AccsdataModule.LedgerReportDB.next;
                  LineType := '';
                  if vartostr(AccsdataModule.LedgerReportDB['LineType']) <> '' then LineType := AccsdataModule.LedgerReportDB['LineType'];

                  if ((LineType = 'di') or (LineType = 'in') or (LineType = 'pa')) then begin

                    Trans := Document.createElement('Trans');
                    rows.appendChild(Trans);

                    ChildNode := Document.createElement('txno');
                    ChildNode.Set_text(AccsdataModule.LedgerReportDB['TxNo']);
                    trans.appendChild(ChildNode);

                    TxNo :=  AccsdataModule.LedgerReportDB['TxNo'];

                    ChildNode := Document.createElement('txdate');
                    ChildNode.Set_text(AccsdataModule.LedgerReportDB['TxDate']);
                    trans.appendChild(ChildNode);

                    ChildNode := Document.createElement('txtype');
                    ChildNode.Set_text(AccsdataModule.LedgerReportDB['TxType']);
                    trans.appendChild(ChildNode);

                    ChildNode := Document.createElement('txref');
                    if vartostr(AccsdataModule.LedgerReportDB['TxReference']) <> '' then TempStr := AccsdataModule.LedgerReportDB['TxReference']
                        else TempStr := '';
                    ChildNode.Set_text(TempStr);
                    trans.appendChild(ChildNode);

                    ChildNode := Document.createElement('txdesc');
                    if vartostr(AccsdataModule.LedgerReportDB['TxDescription']) <> '' then TempStr := AccsdataModule.LedgerReportDB['TxDescription']
                        else TempStr := '';
                    ChildNode.Set_text(TempStr);
                    trans.appendChild(ChildNode);

                    ChildNode := Document.createElement('lastyear');
                    if vartostr(AccsdataModule.LedgerReportDB['LastYear']) = '*' then ChildNode.Set_text('True')
                        else ChildNode.Set_text('False');
                    trans.appendChild(ChildNode);

                    ChildNode := Document.createElement('debit');
                    if vartostr(AccsdataModule.LedgerReportDB['Debit']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['Debit']*100)/100
                        else Tempreal := 0;
                    ChildNode.Set_text(vartostr(TempReal));
                    trans.appendChild(ChildNode);

                    ChildNode := Document.createElement('credit');
                    if vartostr(AccsdataModule.LedgerReportDB['Credit']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['Credit']*100)/100
                        else Tempreal := 0;
                    ChildNode.Set_text(vartostr(TempReal));
                    trans.appendChild(ChildNode);

                    ChildNode := Document.createElement('balance');
                    if vartostr(AccsdataModule.LedgerReportDB['Balance']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['Balance']*100)/100
                        else Tempreal := 0;
                    ChildNode.Set_text(vartostr(TempReal));;
                    trans.appendChild(ChildNode);


                  end;

                  if (LineType = 'id') then begin

                      lines := Document.createElement('lines');

                      ChildNode := Document.createElement('origtxno');
                      ChildNode.Set_text(vartostr(TxNo));
                      lines.appendChild(ChildNode);

                      ChildNode := Document.createElement('linedate');
                      ChildNode.Set_text(AccsdataModule.LedgerReportDB['LineDate']);
                      lines.appendChild(ChildNode);

                      ChildNode := Document.createElement('linedesc');
                      if vartostr(AccsdataModule.LedgerReportDB['LineDescription']) <> '' then TempStr := AccsdataModule.LedgerReportDB['LineDescription']
                        else TempStr := '';
                      ChildNode.Set_text(TempStr);
                      lines.appendChild(ChildNode);

                      ChildNode := Document.createElement('lineqty');
                      if vartostr(AccsdataModule.LedgerReportDB['LineQty']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['LineQty']*100)/100
                        else Tempreal := 0;
                      ChildNode.Set_text(vartostr(TempReal));
                      lines.appendChild(ChildNode);

                      ChildNode := Document.createElement('lineunitprice');
                      if vartostr(AccsdataModule.LedgerReportDB['LineUnitPrice']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['LineUnitPrice']*100)/100
                        else Tempreal := 0;
                      ChildNode.Set_text(vartostr(TempReal));
                      lines.appendChild(ChildNode);

                      ChildNode := Document.createElement('lineprice');
                      if vartostr(AccsdataModule.LedgerReportDB['LinePrice']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['LinePrice']*100)/100
                        else Tempreal := 0;
                      ChildNode.Set_text(vartostr(TempReal));
                      lines.appendChild(ChildNode);

                      ChildNode := Document.createElement('linevat');
                      if vartostr(AccsdataModule.LedgerReportDB['LineVAT']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['LineVAT']*100)/100
                        else Tempreal := 0;
                      ChildNode.Set_text(vartostr(TempReal));
                      lines.appendChild(ChildNode);

                      ChildNode := Document.createElement('linedebit');
                      if vartostr(AccsdataModule.LedgerReportDB['LineDebit']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['LineDebit']*100)/100
                        else Tempreal := 0;
                      ChildNode.Set_text(vartostr(TempReal));
                      lines.appendChild(ChildNode);

                      ChildNode := Document.createElement('linecredit');
                      if vartostr(AccsdataModule.LedgerReportDB['LineCredit']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['LineCredit']*100)/100
                        else Tempreal := 0;
                      ChildNode.Set_text(vartostr(TempReal));
                      lines.appendChild(ChildNode);
                      
                      trans.appendChild(lines);


                  end;

                    //

              end;

              // TGM AB 14/10/16

              While (LineType <> 'cb') do begin
                  AccsdataModule.LedgerReportDB.next;
                  LineType := '';
                  if vartostr(AccsdataModule.LedgerReportDB['LineType']) <> '' then LineType := AccsdataModule.LedgerReportDB['LineType'];
              end;

              ChildNode := Document.createElement('outstanding');
              if vartostr(AccsdataModule.LedgerReportDB['Balance']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['Balance']*100)/100
                        else Tempreal := 0;
                    ChildNode.Set_text(vartostr(TempReal));
              rows.appendChild(ChildNode);

              // end TGM AB 14/10/16



              While (LineType <> 'cu') do begin
                  AccsdataModule.LedgerReportDB.next;
                  LineType := '';
                  if vartostr(AccsdataModule.LedgerReportDB['LineType']) <> '' then LineType := AccsdataModule.LedgerReportDB['LineType'];
              end;

              ChildNode := Document.createElement('current');
              if vartostr(AccsdataModule.LedgerReportDB['Credit']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['Credit']*100)/100
                        else Tempreal := 0;
                    ChildNode.Set_text(vartostr(TempReal));
              rows.appendChild(ChildNode);

              While (LineType <> 'c1') do begin
                  AccsdataModule.LedgerReportDB.next;
                  LineType := '';
                  if vartostr(AccsdataModule.LedgerReportDB['LineType']) <> '' then LineType := AccsdataModule.LedgerReportDB['LineType'];
              end;

              ChildNode := Document.createElement('age1');
              if vartostr(AccsdataModule.LedgerReportDB['Credit']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['Credit']*100)/100
                        else Tempreal := 0;
                    ChildNode.Set_text(vartostr(TempReal));
              rows.appendChild(ChildNode);

              While (LineType <> 'c2') do begin
                  AccsdataModule.LedgerReportDB.next;
                  LineType := '';
                  if vartostr(AccsdataModule.LedgerReportDB['LineType']) <> '' then LineType := AccsdataModule.LedgerReportDB['LineType'];
              end;
              ChildNode := Document.createElement('age2');
              if vartostr(AccsdataModule.LedgerReportDB['Credit']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['Credit']*100)/100
                        else Tempreal := 0;
                    ChildNode.Set_text(vartostr(TempReal));
              rows.appendChild(ChildNode);

              While (LineType <> 'c3') do begin
                  AccsdataModule.LedgerReportDB.next;
                  LineType := '';
                  if vartostr(AccsdataModule.LedgerReportDB['LineType']) <> '' then LineType := AccsdataModule.LedgerReportDB['LineType'];
              end;

              ChildNode := Document.createElement('age3');
              if vartostr(AccsdataModule.LedgerReportDB['Credit']) <> '' then Tempreal := round(AccsdataModule.LedgerReportDB['Credit']*100)/100
                        else Tempreal := 0;
                    ChildNode.Set_text(vartostr(TempReal));
              rows.appendChild(ChildNode);


           end;


       AccsdataModule.LedgerReportDB.next;

       end;

       Report.appendChild(Details);

       if (FileExists(AFileName)) then DeleteFile(AFileName);

       Document.save(AFileName);

       CloseAll ( MaxDatabases );

   end;  // OpenCompanyData
end;

procedure OutputProformaAsXML(const AReportType: Char; const ACompanyName, AFileName: string);
var
  Success: Boolean;

  Document : IXMLDOMDocument;
  Report, Header, Rows, Row, Child: IXMLDOMNode;
  Query : TQuery;

begin
   if (FileExists(AFileName)) then DeleteFile(AFileName);

   if not OpenCompanyData(ACompanyName) then
      begin
         // Output Error to log
         Exit;
      end;

   try
      Success := TJobCardReportSetupForm.DumpReportData(AReportType);
      if (not Success) then
         begin
            // Output Error to log
            Exit;
         end;

      try
         Query := TQuery.Create(nil);
         Query.DatabaseName := 'C:\Kingsacc\'+ ACompanyName;
         Query.SQL.Text := 'SELECT * FROM JobCardReportTable';
         Query.Active := True;

         Document := CreateOleObject('MSXML2.DOMDocument') as IXMLDOMDocument;
         Document.appendChild(Document.createProcessingInstruction('xml', 'version="1.0" encoding="UTF-8"'));

         Report := Document.createElement('report'); // Create Report
         Document.appendChild(Report);

         Header := Document.createElement('header');          // start of header
         Child := Document.createElement('name');
         Child.Set_text('Job Cards');

         Header.appendChild(Child);
         Child := Document.createElement('dataset');
         Child.Set_text(RFarmGate.PLocation[2]);
         Header.appendChild(Child);

         Report.appendChild(Header);                          // end of header

         Rows := Document.createElement('rows');                // start of details

         Query.First;
         while not Query.Eof do
            begin
               Row := Document.createElement('row');

               Child := Document.createElement('customerId');
               Child.Set_text(Query.FieldByName('Customer').AsString);
               Row.appendChild(Child);

               {Child := Document.createElement('customerName');
               Child.Set_text(Query.FieldByName('CName').AsString);
               Row.appendChild(Child);}

               Child := Document.createElement('jobDate');
               Child.Set_text(DateToStr(Query.FieldByName('JDate').AsDateTime));
               Row.appendChild(Child);

               Child := Document.createElement('reference');
               Child.Set_text(Query.FieldByName('Reference').AsString);
               Row.appendChild(Child);

               Child := Document.createElement('comment');
               Child.Set_text(Query.FieldByName('Comment').AsString);
               Row.appendChild(Child);

               Child := Document.createElement('amount');
               Child.Set_text(Query.FieldByName('Amount').AsString);
               Row.appendChild(Child);

               Child := Document.createElement('vatAmount');
               Child.Set_text(Query.FieldByName('VATAmount').AsString);
               Row.appendChild(Child);

               {Child := Document.createElement('totalAmount');
               Child.Set_text(Query.FieldByName('TotalAmount').AsString);
               Row.appendChild(Child);}

               Rows.appendChild(Row);

               Query.Next;
            end;

          Report.appendChild(Rows);

          Document.save(AFileName);
      except

      end;

   finally
      if (Query<>nil) then
         FreeAndNil(Query);

      CloseAll(MaxDatabases);
      Document := nil;
      Header := nil;
      Rows := nil;
      Row := nil;
      Child := nil;
   end;
end;

end.
