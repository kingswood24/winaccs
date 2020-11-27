unit reportdefs;

(* Changes

    24/07/20 - AB - Added new NoPreview variable to allow report table to be generated for CSV export (marked Ch025)
                  - Added new section to deal with Full Nominal being printed By Group as well as Account (marked Ch025)

    31/08/20 - AB - Transaction Listing Report Issues - Bug : Reference not always being shown (marked Ch028)
                                                        Improvement : customer wanted Cust / Supp shown on all ledger transactions - added cust / supp column (marked Ch028)

*)

interface

type TReportType = ( rpNoreport,
                 rpActualCashFlowToDate,
                 rpCashFlowVsBudgetThisMonth,
                 rpCashFlowVsBudgetThisYear,
                 rpProfitAndLoss,
                 rpManagementBalance1,
                 rpManagementBalance2,
                 rpTransactionReport,
                 rpCashBookIncomeExpenditure,
                 rpBankAuditTrail,
                 rpTrialBalance,
                 rpFullNominalAuditTrail,
                 rpCostingReportThisYear,
                 rpThisYearVsPrevYear,
                 rpThisYearVsBudgetAndLastYear,
                 rpThisMonthVsBudgetAndLastYear,
                 rpLastYearMonthly,
                 rpThisYearMonthly,
                 rpCostPerUnit,
                 rpOverheadThisYearOnly,
                 rpOverheadThisYearVsLastYear,
                 rpOverheadThisYearVsLastThreeYears,
                 rpOverheadThisYearMonthly,
                 rpOverheadLastYearMonthly,
                 rpVatReport,
                 rpCustomerAccountListing,
                 rpCustomerAgeOfDebt,
                 rpCustomerInvoiceListing,
                 rpCustomerPaymentListing,
                 rpCustomerCreditNoteListing,
                 rpCustomerTransactionSummary,
                 rpCustomerAnalysis,
                 rpSupplierAccountListing,
                 rpSupplierAgeOfDebt,
                 rpSupplierInvoiceListing,
                 rpSupplierPaymentListing,
                 rpSupplierCreditNoteListing,
                 rpSupplierTransactionSummary,
                 rpSupplierAnalysis,
                 rpStatements,
                 rpLedgerCards,
                 rpRecordCards,
                 rpInvoiceSummary,
                 rpSetupBudget,
                 rpSetupNominal,
                 rpSetupEnterprise,
                 rpSetupCustomer,
                 rpEntSummary1,
                 rpEntSummary2,
                 rpEntSummary3,
                 rpEntSummary4,
                 rpEntSummary5
                 );
var ReportType : TReportType;
var ExportToCSV : boolean;
var NoPreview : boolean;          //Ch025

Procedure RunReport;
Procedure SetupReport(pReportType : TReportType);

implementation

Uses Reports, WinTypes, Graphics, Stat, NewRepUnit,types,vars,
     PARAMS, nomrpt, AccsData, UStatementSetup, Dialogs,sysutils,printers,
     Entreps, Cashflow,Rcslist, RcsInv, SetupBudgetReports, csvexport;

//var ReportType : TReportType;

Procedure PutAccountNumbersAtTheTopOfThePage;
var inFile, outFile : TextFile;
    s, tmp : String;
    p : Integer;
    totals : boolean;
begin
            Totals := false;
            AssignFile(inFile, 'c:\kingsacc\reports\noname.rpt');
            AssignFile(outFile, 'c:\kingsacc\reports\report.rpt');
            Reset(inFile); Rewrite(outFile);
            while not eof (inFile) do begin
                  ReadLn(inFile, s);
                  if pos('ACCOUNT:', s) > 0 then begin
                     p := pos ('CUSTOMER INVOICE/SUMMARY', s);
                     if p = 0 then p := Length(s) + 1;
                     tmp := StringOfChar(' ', 320) + Copy(s, 1, p-1);
                  end;
                  if (Copy(s, 1, 4) = 'DATE') then begin
                     WriteLn(outFile, tmp);
                     WriteLn(outFile, StringOfChar('-', 54));
                  end;

                  if(Copy(s, 1, 6) = 'ACC-NO') then totals := true;
                  if totals then begin
                                 if Copy(s,1,6) <> '------' then s:= StringOfChar(' ', 200) + s;

                  end;

                  //if (Pos('HRS', s) >0) and (Pos('PRICE', s) >0) and (Pos('TOTAL', s) >0) then s:= '';
                  WriteLn(outFile, s);

            end;
            CloseFile(inFile);
            CloseFile(outFile);
            Rewrite(inFile);
            CloseFile(inFile);
end;

Procedure PositionInvoiceSummary(Linesperpage : integer);
var inFile, outFile : TextFile;
    s, tmp : String;
    p,i,linecount,pagecount : Integer;
begin
            // TGM AB File Handing For Invoice Summary
            AssignFile(inFile, 'c:\kingsacc\reports\noname.rpt');
            AssignFile(outFile, 'c:\kingsacc\reports\report.rpt');
            p:=0;
            s := '';
            linecount := 0;
            pagecount := 1;
            Reset(inFile); Rewrite(outFile);
            while not eof (inFile) do begin
                     if linecount = RFarmGate.PLINESPAGE[1] then begin
                                             // PAGE 324 is used to force a new page.
                                             writeln(outfile,StringOfChar(' ', 300) + 'PAGE 324');
                                             writeln(outfile,'--skipthisline');
                                             linecount := 1;
                                             pagecount := pagecount + 1
                                             end
                     else linecount := linecount +1;;

                     ReadLn(inFile, s);

                     if linecount = 1 then begin
                        //if pagecount <> 1 then  writeln(Outfile,'                                                                                          *');
                        if statementForm.PrintFrom.asinteger > 0 then begin
                              for i := 1 to statementForm.PrintFrom.asinteger do begin
                                             writeln(Outfile,'                                                                                          *');
                              end;
                        end;
                        // the line below is needed for some strange reason to put a solid line acros the top of page 1.
                        // subsequent pages put the line on OK.
                        if pagecount = 1 then  writeln(outfile,'----------------');
                     end;
                     if pos('ACCOUNT:', s) > 0 then begin
                         p := pos ('CUSTOMER INVOICE/SUMMARY', s);
                         if p = 0 then p := Length(s) + 1;
                         tmp :=StringOfChar(' ', 240) + Copy(s, 1, p-1);
                         s := tmp;
                     end;
                     Writeln(OutFile,s);
            end;
            CloseFile(inFile);
            CloseFile(outFile);
            // the next 2 lines blank out noname.rpt so that it doesn't get processed!
            Rewrite(inFile);
            CloseFile(inFile);
end;

Procedure PutAccountNumbersAtTheTopOfThePageNominal;
var inFile, outFile : TextFile;
    s, tmp : String;
    p : Integer;
    i,j : integer;
    header : boolean;
begin
            i:=0;
            AssignFile(inFile, 'c:\kingsacc\reports\noname.rpt');
            AssignFile(outFile, 'c:\kingsacc\reports\report.rpt');
            Reset(inFile); Rewrite(outFile);
            while not eof (inFile) do begin
                  i := i+1;
                  ReadLn(inFile, s);
                  header := false;
                  // the bit below inserts the account name into the text file way off to the right so that the current nominal name can be put at the top of each page
                  if pos('ACCOUNT ', s) > 0 then begin
                     header:= true;
                     p := pos ('ACCOUNT ', s);
                     s:= copy(s,1,p-1) + 'Account ' + copy(S,p+8,length(s)-(p+8));
                     inc(p);
                     tmp := Copy(s, p-1, Length(s) - p);
                     p := pos ('Account ', tmp);
                     tmp := StringOfChar(' ', 320) + Copy(tmp, p-1, Length(s) - p);
                  end;
                  if pos('GROUP ', s) > 0 then begin                            //Ch025 start
                     header:= true;
                     p := pos ('GROUP ', s);
                     s:= copy(s,1,p-1) + 'Group ' + copy(S,p+6,length(s)-(p+6));
                     inc(p);
                     tmp := Copy(s, p-1, Length(s) - p);
                     p := pos ('Group ', tmp);
                     tmp := StringOfChar(' ', 320) + Copy(tmp, p-1, Length(s) - p);
                  end;                                                            //Ch025 end
                  if (Copy(s, 1, 8) = 'TRANS-NO') then begin
                     header := true;
                     WriteLn(outFile, tmp);
                     WriteLn(outFile, StringOfChar('-', 54));
                  end;
                  try if strToInt(copy(s,5,1)) < 10 then s:= ' ' + copy(s,1,5) + copy(s,7,length(s));
                  except
                  end;
                  {if ((i - 8) mod 63 = 0) and (s ='') then begin
                  end else}
                  if UpperCase(copy(s,43,7)) = 'ACCOUNT' then for j := 60 to (length(s)-1) do begin
                     if ((s[j] =' ') and (s[j+1] = ' ')) then begin
                          s := copy(s,1,j) + copy (s,j+2,Length(s));
                     end;
                  end;
                  WriteLn(outFile,s); // added by GM 07/03/02 to remove a blank line at line 8 which is in the source text file.


            end;
            CloseFile(inFile);
            CloseFile(outFile);
            Rewrite(inFile);
            CloseFile(inFile);
end;

Procedure SetupReport(pReportType : TReportType);
begin
     ReportType := pReportType;
end;

Procedure RunReport;
var inFile, outFile : TextFile;
    s,tmp,lastline : String;
    i : Integer;
    sIrish : Boolean;
    NIVatAdjust:Boolean;
    RangeLabel:String[60];
    StatementType : Char;  // TGM AB
    fileno : integer; // TGM AB
begin
     fileno := 1;
     report.coverpanel.Enabled := false;
     NIVATAdjust:=false;
     RangeLabel:='';
     Report.ResetReport;
     Report.LinesPerPage := 56;
     Report.PageHeader.Height := 91;
     Report.PageFooter.Height := 56;
     Reports.Report.RangeLabel.caption:='';
     Reports.Report.ReportDate.caption:='';
     Report.ReportDate.enabled:= false;
     Report.PrintDate.enabled:= false;

     Report.CurrReport:='Default'; // initialise report

     Report.Rangelabel.Caption:= '';
     Report.Page.Orientation := poPortrait;
     Report.BottomLine.enabled := true;
     Report.KingswoodLbl.enabled := true;
     Report.TimeLbl.enabled:=true;
 //    Report.PageLbl.enabled:=true;
     Report.PageNumber.enabled := true;
     Report.Topline1.enabled := true;
     Report.Topline2.enabled := true;
     Report.Heading.enabled := true;
     Report.StatementFromLabel.enabled := false;
     Report.StatementName.enabled := false;
     Report.StatementAddress1.enabled := false;
     Report.StatementAddress2.enabled := false;
     Report.StatementAddress3.enabled := false;
     Report.StatementAddress4.enabled := false;
     Report.StatementTelephone.Enabled := false;


     if ReportType = rpActualCashFlowToDate then begin
         Report.ReportDate.caption := 'Report Date: ' + CashFlowReportsForm.RepDate.Text;
         Report.ReportDate.enabled:= true;
         Report.PrintDate.enabled:= true;

        Report.Page.Orientation := PoLandscape;
        Report.LinesPerPage := 35;

        Report.AddLeftAlignedColumn(1);               {1}
        Report.AddTextColumn(31);
        Report.AddTextColumn(39);
        Report.AddTextColumn(47);
        Report.AddTextColumn(55);                        {5}
        Report.AddTextColumn(63);
        Report.AddTextColumn(71);

        Report.AddRightAlignedColumn(33);
        Report.AddRightAlignedColumn(41);
        Report.AddRightAlignedColumn(49);                   {10}
        Report.AddRightAlignedColumn(57);
        Report.AddRightAlignedColumn(65);
        Report.AddRightAlignedColumn(73);

        Report.AddTextColumn(79);
        Report.AddTextColumn(87);                           {15}
        Report.AddTextColumn(95);
        Report.AddTextColumn(103);
        Report.AddTextColumn(111);
        Report.AddTextColumn(119);
        Report.AddTextColumn(127);                          {20}

        Report.AddRightAlignedColumn(81);
        Report.AddRightAlignedColumn(89);
        Report.AddRightAlignedColumn(97);
        Report.AddRightAlignedColumn(105);
        Report.AddRightAlignedColumn(113);                 {25}
        Report.AddRightAlignedColumn(121);
        Report.AddRightAlignedColumn(131);                 {27}


        Report.AddColumn(1,0).Font.Style := [fsBold];

        Report.AddColumn(2,220); //200
        Report.AddColumn(3,285);  //240
        Report.AddColumn(4,350); //280
        Report.AddColumn(5,415); //320
        Report.AddColumn(6,480); //360
        Report.AddColumn(7,545);  //400

        Report.AddColumn(8,220); //200
        Report.AddColumn(9,285);  //240
        Report.AddColumn(10,350); //280
        Report.AddColumn(11,415); //320
        Report.AddColumn(12,480); //360
        Report.AddColumn(13,545);  //400

        Report.AddColumn(14,610); //440
        Report.AddColumn(15,675); //480
        Report.AddColumn(16,730); //520
        Report.AddColumn(17,795); //560
        Report.AddColumn(18,860); //600
        Report.AddColumn(19,925); //640
        Report.AddColumn(20,990); //690

        Report.AddColumn(21,610); //440
        Report.AddColumn(22,675); //480
        Report.AddColumn(23,730); //520
        Report.AddColumn(24,795); //560
        Report.AddColumn(25,860); //600
        Report.AddColumn(26,925); //640
        Report.AddColumn(27,990); //690


        Report.SetHeading('Actual Cashflow to Date');
     end;

     if (ReportType = rpCashFlowVsBudgetThisMonth) then begin
            Report.AddLeftAlignedColumn(1);
            Report.AddTextColumn(50);
            Report.AddTextColumn(74);
            Report.AddTextColumn(96);

            Report.AddRightAlignedColumn(55);
            Report.AddRightAlignedColumn(79);
            Report.AddRightAlignedColumn(103);

            Report.AddColumn(1,0).Font.Style := [fsBold];

            Report.AddColumn(2,300);
            Report.AddColumn(3,400);
            Report.AddColumn(4,500);

            Report.AddColumn(5,300);
            Report.AddColumn(6,400);
            Report.AddColumn(7,500);
            Report.SetHeading('Actual Cashflow vs Budget This Month');
         end;

     if ReportType = rpCashFlowVsBudgetThisYear then begin
            Report.SetHeading('Actual Cashflow vs Budget This Year');

        Report.page.Orientation := polandscape;
        Report.linesperpage := 35;

       //Report.addtextcolumn(1);//
       Report.AddLeftAlignedColumn(1);               {1}

        Report.AddTextColumn(31);
        Report.AddTextColumn(39);
        Report.AddTextColumn(47);
        Report.AddTextColumn(55);                        {5}
        Report.AddTextColumn(63);
        Report.AddTextColumn(71);

        Report.AddRightAlignedColumn(33);
        Report.AddRightAlignedColumn(41);
        Report.AddRightAlignedColumn(49);                   {10}
        Report.AddRightAlignedColumn(57);
        Report.AddRightAlignedColumn(65);
        Report.AddRightAlignedColumn(73);

        Report.AddTextColumn(79);
        Report.AddTextColumn(87);                           {15}
        Report.AddTextColumn(95);
        Report.AddTextColumn(103);
        Report.AddTextColumn(111);
        Report.AddTextColumn(119);
        Report.AddTextColumn(127);                          {20}

        Report.AddRightAlignedColumn(81);
        Report.AddRightAlignedColumn(89);
        Report.AddRightAlignedColumn(97);
        Report.AddRightAlignedColumn(105);
        Report.AddRightAlignedColumn(113);                 {25}
        Report.AddRightAlignedColumn(121);
        Report.AddRightAlignedColumn(131);                 {27}


        Report.AddColumn(1,0).Font.Style := [fsBold];

        Report.AddColumn(2,220); //200
        Report.AddColumn(3,285);  //240
        Report.AddColumn(4,350); //280
        Report.AddColumn(5,415); //320
        Report.AddColumn(6,480); //360
        Report.AddColumn(7,545);  //400

        Report.AddColumn(8,220); //200
        Report.AddColumn(9,285);  //240
        Report.AddColumn(10,350); //280
        Report.AddColumn(11,415); //320
        Report.AddColumn(12,480); //360
        Report.AddColumn(13,545);  //400

        Report.AddColumn(14,610); //440
        Report.AddColumn(15,675); //480
        Report.AddColumn(16,730); //520
        Report.AddColumn(17,795); //560
        Report.AddColumn(18,860); //600
        Report.AddColumn(19,925); //640
        Report.AddColumn(20,990); //690

        Report.AddColumn(21,610); //440
        Report.AddColumn(22,675); //480
        Report.AddColumn(23,730); //520
        Report.AddColumn(24,795); //560
        Report.AddColumn(25,860); //600
        Report.AddColumn(26,925); //640
        Report.AddColumn(27,990); //690

        (*
        Report.AddColumn(2,200).Font.Size := 8;
        Report.AddColumn(3,240).Font.Size := 8;
        Report.AddColumn(4,280).Font.Size := 8;
        Report.AddColumn(5,320).Font.Size := 8;
        Report.AddColumn(6,360).Font.Size := 8;
        Report.AddColumn(7,400).Font.Size := 8;

        Report.AddColumn(8,200).Font.Size := 8;
        Report.AddColumn(9,240).Font.Size := 8;
        Report.AddColumn(10,280).Font.Size := 8;
        Report.AddColumn(11,320).Font.Size := 8;
        Report.AddColumn(12,360).Font.Size := 8;
        Report.AddColumn(13,400).Font.Size := 8;

        Report.AddColumn(14,440).Font.Size := 8;
        Report.AddColumn(15,480).Font.Size := 8;
        Report.AddColumn(16,520).Font.Size := 8;
        Report.AddColumn(17,560).Font.Size := 8;
        Report.AddColumn(18,600).Font.Size := 8;
        Report.AddColumn(19,640).Font.Size := 8;
        Report.AddColumn(20,680).Font.Size := 8;

        Report.AddColumn(21,440).Font.Size := 8;
        Report.AddColumn(22,480).Font.Size := 8;
        Report.AddColumn(23,520).Font.Size := 8;
        Report.AddColumn(24,560).Font.Size := 8;
        Report.AddColumn(25,600).Font.Size := 8;
        Report.AddColumn(26,640).Font.Size := 8;
        Report.AddColumn(27,680).Font.Size := 8;
          *)
     end;

          if ReportType = rpEntSummary1 then begin
         Report.ReportDate.caption := 'Report Date: ' + DateToStr(Date);
         Report.ReportDate.enabled:= true;

        Report.AddLeftAlignedColumn(1);               {1}
        Report.AddLeftAlignedColumn(5);
        Report.AddLeftAlignedColumn(12);
        Report.AddTextColumn(49);
        Report.AddTextColumn(61); // 5
        Report.AddTextColumn(77); // period
        Report.AddTextColumn(86); // Budget
        Report.AddTextColumn(94); // Variance
        Report.AddTextColumn(105);
        Report.AddTextColumn(112); //10
        Report.AddTextColumn(120);


        Report.AddRightAlignedColumn(58);
        Report.AddRightAlignedColumn(72);
        Report.AddRightAlignedColumn(86);
        Report.AddRightAlignedColumn(100);
        Report.AddRightAlignedColumn(114);
        Report.AddRightAlignedColumn(128);


        Report.AddColumn(1,0).Font.Style := [fsBold];

        Report.AddColumn(2,50); //200
        Report.AddColumn(3,80);  //240
        Report.AddColumn(4,250); //280
        Report.AddColumn(5,320); //320
        Report.AddColumn(6,410); // period
        Report.AddColumn(7,460); // Budget

        Report.AddColumn(8,520); // Variance
        Report.AddColumn(9,590);
        Report.AddColumn(10,640);
        Report.AddColumn(11,700);

        Report.AddColumn(12,250); //360
        Report.AddColumn(13,320);  //400
        Report.AddColumn(14,450);  // Budget
        Report.AddColumn(15,520); //Variance
        Report.AddColumn(16,630);
        Report.AddColumn(17,700);

        Report.SetHeading('Enterprise Summary Report');
        Report.ReplaceText('THIS-PERIOD', 'This-Month');
        Report.ReplaceText('Period:', 'Month:');
     end;

     if ReportType = rpEntSummary2 then begin
         Report.ReportDate.caption := 'Report Date: ' + DateToStr(Date);
         Report.ReportDate.enabled:= true;
        Report.AddLeftAlignedColumn(1);               {1}
        Report.AddLeftAlignedColumn(5);
        Report.AddLeftAlignedColumn(12);
        Report.AddTextColumn(43);
        Report.AddTextColumn(63); // 5
        Report.AddTextColumn(69);
        Report.AddTextColumn(82);
        Report.AddTextColumn(104); //8
        Report.AddTextColumn(115);
        Report.AddTextColumn(123);

        Report.AddRightAlignedColumn(54);
        Report.AddRightAlignedColumn(67);
        Report.AddRightAlignedColumn(80);
        Report.AddRightAlignedColumn(93);
        Report.AddRightAlignedColumn(106);
        Report.AddRightAlignedColumn(119);
        Report.AddRightAlignedColumn(132);

        //Report.AddRightAlignedColumn(49);                   {10}
        //Report.AddRightAlignedColumn(57);
        //Report.AddRightAlignedColumn(65);
        //Report.AddRightAlignedColumn(73);  //


        Report.AddColumn(1,0).Font.Style := [fsBold];

        Report.AddColumn(2,50); //200
        Report.AddColumn(3,80);  //240
        Report.AddColumn(4,250); //280
        Report.AddColumn(5,300); //320
        Report.AddColumn(6,350); //320   THIS-PD-BUD
        Report.AddColumn(7,500); //320
        Report.AddColumn(8,565); //320
        Report.AddColumn(9,620); //320
        Report.AddColumn(10,700); //320

        Report.AddColumn(11,250); //360
        Report.AddColumn(12,300);  //400
        Report.AddColumn(13,350); //320
        Report.AddColumn(14,500); //320
        Report.AddColumn(15,560); //320
        Report.AddColumn(16,620); //320
        Report.AddColumn(16,700); //320

        Report.SetHeading('Enterprise Summary - This year Versus Last');
        Report.ReplaceText('Last', 'Last Yr');
        Report.ReplaceText('This Period:Actual', 'This Month:This Yr');
     end;

     if ReportType = rpEntSummary3 then begin
         Report.ReportDate.caption := 'Report Date: ' + DateToStr(Date);
         Report.ReportDate.enabled:= true;
        Report.AddLeftAlignedColumn(1);               {1}
        Report.AddLeftAlignedColumn(5);
        Report.AddLeftAlignedColumn(12);
        Report.AddTextColumn(44);
        Report.AddTextColumn(68); // 5
        Report.AddTextColumn(82);
        Report.AddTextColumn(96);

        Report.AddRightAlignedColumn(58);
        Report.AddRightAlignedColumn(72);
        Report.AddRightAlignedColumn(86);
        Report.AddRightAlignedColumn(100);
        //Report.AddRightAlignedColumn(49);                   {10}
        //Report.AddRightAlignedColumn(57);
        //Report.AddRightAlignedColumn(65);
        //Report.AddRightAlignedColumn(73);  //


        Report.AddColumn(1,0).Font.Style := [fsBold];

        Report.AddColumn(2,50); //200
        Report.AddColumn(3,80);  //240
        Report.AddColumn(4,250); //280
        Report.AddColumn(5,350); //320
        Report.AddColumn(6,450); //320
        Report.AddColumn(7,550); //320
        Report.AddColumn(8,250); //320

        Report.AddColumn(9,350); //360
        Report.AddColumn(10,450);  //400
        Report.AddColumn(11,550); //320

        Report.SetHeading('Enterprise Summary - This year Versus Last 3 Years');
     end;


     if ReportType = rpEntSummary4 then begin
         Report.ReportDate.caption := 'Report Date: ' + DateToStr(Date);
         Report.ReportDate.enabled:= true;

        Report.Page.Orientation := PoLandscape;
        Report.LinesPerPage := 35;

        Report.AddLeftAlignedColumn(1);               {1}
        Report.AddLeftAlignedColumn(5);
        Report.AddLeftAlignedColumn(12);

        Report.AddTextColumn(45);
        Report.AddTextColumn(52);
        Report.AddTextColumn(59);
        Report.AddTextColumn(66);                        {5}
        Report.AddTextColumn(73);
        Report.AddTextColumn(80);

        Report.AddRightAlignedColumn(47);
        Report.AddRightAlignedColumn(54);
        Report.AddRightAlignedColumn(61);                   {10}
        Report.AddRightAlignedColumn(68);
        Report.AddRightAlignedColumn(75);
        Report.AddRightAlignedColumn(82);

        Report.AddTextColumn(87);
        Report.AddTextColumn(94);                           {15}
        Report.AddTextColumn(101);
        Report.AddTextColumn(108);
        Report.AddTextColumn(115);
        Report.AddTextColumn(122);
        Report.AddTextColumn(127);                          {20}

        Report.AddRightAlignedColumn(89);
        Report.AddRightAlignedColumn(96);
        Report.AddRightAlignedColumn(103);
        Report.AddRightAlignedColumn(110);
        Report.AddRightAlignedColumn(117);                 {25}
        Report.AddRightAlignedColumn(124);
        Report.AddRightAlignedColumn(131);                 {27}


        Report.AddColumn(1,0).Font.Style := [fsBold];

        Report.AddColumn(2,50); //200
        Report.AddColumn(3,80);  //240

        Report.AddColumn(4,220); //200
        Report.AddColumn(5,285);  //240
        Report.AddColumn(6,350); //280
        Report.AddColumn(7,415); //320
        Report.AddColumn(8,480); //360
        Report.AddColumn(9,545);  //400

        Report.AddColumn(10,220); //200
        Report.AddColumn(11,285);  //240
        Report.AddColumn(12,350); //280
        Report.AddColumn(13,415); //320
        Report.AddColumn(14,480); //360
        Report.AddColumn(15,545);  //400

        Report.AddColumn(16,610); //440
        Report.AddColumn(17,675); //480
        Report.AddColumn(18,730); //520
        Report.AddColumn(19,795); //560
        Report.AddColumn(20,860); //600
        Report.AddColumn(21,925); //640
        Report.AddColumn(22,990); //690

        Report.AddColumn(23,610); //440
        Report.AddColumn(24,675); //480
        Report.AddColumn(25,730); //520
        Report.AddColumn(26,795); //560
        Report.AddColumn(27,860); //600
        Report.AddColumn(28,925); //640
        Report.AddColumn(29,990); //690


        Report.SetHeading('Enterprise Summary This Year Monthly');
     end;

     if ReportType = rpEntSummary5 then begin
         Report.ReportDate.caption := 'Report Date: ' + DateToStr(Date);
         Report.ReportDate.enabled:= true;

        Report.Page.Orientation := PoLandscape;
        Report.LinesPerPage := 35; //35

        Report.AddLeftAlignedColumn(1);               {1}
        Report.AddLeftAlignedColumn(5);
        Report.AddLeftAlignedColumn(12);

        Report.AddTextColumn(45);
        Report.AddTextColumn(52);
        Report.AddTextColumn(59);
        Report.AddTextColumn(66);                        {5}
        Report.AddTextColumn(73);
        Report.AddTextColumn(80);

        Report.AddRightAlignedColumn(47);
        Report.AddRightAlignedColumn(54);
        Report.AddRightAlignedColumn(61);                   {10}
        Report.AddRightAlignedColumn(68);
        Report.AddRightAlignedColumn(75);
        Report.AddRightAlignedColumn(82);

        Report.AddTextColumn(87);
        Report.AddTextColumn(94);                           {15}
        Report.AddTextColumn(101);
        Report.AddTextColumn(108);
        Report.AddTextColumn(115);
        Report.AddTextColumn(122);
        Report.AddTextColumn(127);                          {20}

        Report.AddRightAlignedColumn(89);
        Report.AddRightAlignedColumn(96);
        Report.AddRightAlignedColumn(103);
        Report.AddRightAlignedColumn(110);
        Report.AddRightAlignedColumn(117);                 {25}
        Report.AddRightAlignedColumn(124);
        Report.AddRightAlignedColumn(131);                 {27}


        Report.AddColumn(1,0).Font.Style := [fsBold];

        Report.AddColumn(2,50); //200
        Report.AddColumn(3,80);  //240

        Report.AddColumn(4,220); //200
        Report.AddColumn(5,285);  //240
        Report.AddColumn(6,350); //280
        Report.AddColumn(7,415); //320
        Report.AddColumn(8,480); //360
        Report.AddColumn(9,545);  //400

        Report.AddColumn(10,220); //200
        Report.AddColumn(11,285);  //240
        Report.AddColumn(12,350); //280
        Report.AddColumn(13,415); //320
        Report.AddColumn(14,480); //360
        Report.AddColumn(15,545);  //400

        Report.AddColumn(16,610); //440
        Report.AddColumn(17,675); //480
        Report.AddColumn(18,730); //520
        Report.AddColumn(19,795); //560
        Report.AddColumn(20,860); //600
        Report.AddColumn(21,925); //640
        Report.AddColumn(22,990); //690

        Report.AddColumn(23,610); //440
        Report.AddColumn(24,675); //480
        Report.AddColumn(25,730); //520
        Report.AddColumn(26,795); //560
        Report.AddColumn(27,860); //600
        Report.AddColumn(28,925); //640
        Report.AddColumn(29,990); //690


        Report.SetHeading('Enterprise Summary Last Year Monthly');
     end;


     if ReportType = rpBankAuditTrail then begin

            Report.SetHeading('Bank Audit Trail');
            Report.ReportDate.caption := 'Report Date: ' + NominalReportForm.BankAuditDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;
            If ((NominalReportForm.BankAuditAccFrom.Text <> '') or (NominalReportForm.BankAuditAccTo.Text <> '')) then
               Report.Rangelabel.Caption:= Report.RangeLabel.Caption + ' Bank Range: ' + NominalReportForm.BankAuditAccFrom.text + ' to ' + NominalReportForm.BankAuditAccTo.text;
            If ((NominalReportForm.DateFrom.Text <> '  /  /  ') or (NominalReportForm.DateTo.Text <> '  /  /  ')) then
               Report.Rangelabel.Caption:= Report.RangeLabel.Caption + ' Date Range: ' + NominalReportForm.DateFrom.text + ' to ' + NominalReportForm.DateTo.text;
            Report.AddLeftAlignedColumn(1);       {1}
            Report.AddLeftAlignedColumn(18);                // TGM AB Changed from 21 29/04/02
            Report.AddDashColumn(25);
            Report.AddRightAlignedColumn(27);
            Report.AddLeftAlignedColumn(30);      {5}       // TGM AB Changed from 34 29/04/02
            Report.AddDashColumn(38);
            Report.AddRightAlignedColumn(40);
            Report.AddLeftAlignedColumn(44);
            Report.AddLeftAlignedColumn(50);
            Report.AddLeftAlignedColumn(54);      {10}
            Report.AddLeftAlignedColumn(62);
            Report.AddTextColumn(76);      {12}

            Report.AddRightAlignedColumn(83);
            Report.AddLeftAlignedColumn(88);
            Report.AddLeftAlignedColumn(90);      {15}
            Report.AddLeftAlignedColumn(112);
            Report.AddLeftAlignedColumn(113);      {17}
            Report.AddLeftAlignedColumn(2);

            Report.AddColumn(1,0).Font.Style := [fsBold];

            Report.AddColumn(2,125);
            Report.AddColumn(3,150);
            Report.AddColumn(4,160);
            Report.AddColumn(5,200);
            Report.AddColumn(6,230);
            Report.AddColumn(7,240);
            Report.AddColumn(8,325).font.Style := [fsBold];

            Report.AddColumn(9,260);
            Report.AddColumn(10,285);
            Report.AddColumn(11,320);
            Report.AddColumn(12,440);

            Report.AddColumn(13,440);
            Report.AddColumn(14,475);
            Report.AddColumn(15,475);
            Report.AddColumn(16,600);
            Report.AddColumn(17,600);
            Report.AddColumn(18,0).Font.Style := [fsBold];

         end;

         if ReportType = rpCashBookIncomeExpenditure then begin
            Report.SetHeading('Cashbook Income/Expenditure Report');
            Report.ReportDate.caption := 'Report Date: ' + NominalReportForm.CashBookDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            If ((NominalReportForm.TxFrom.Text <> '') or (NominalReportForm.TxTo.Text <> '')) then
               Report.Rangelabel.Caption:= Report.RangeLabel.Caption + ' Transaction Range: ' + NominalReportForm.TxFrom.text + ' to ' + NominalReportForm.TxTo.text;
            If ((NominalReportForm.ListingDateFrom.Text <> '  /  /  ') or (NominalReportForm.ListingDateTo.Text <> '  /  /  ')) then
               Report.Rangelabel.Caption:= Report.RangeLabel.Caption + ' Date Range: ' + NominalReportForm.ListingDateFrom.text + ' to ' + NominalReportForm.ListingDateTo.text;


            Report.AddLeftAlignedColumn(1);       {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(9);
            Report.AddLeftAlignedColumn(18);
            Report.AddTextColumn(33);      {5}
            Report.AddRightAlignedColumn(38);
            Report.AddTextColumn(43);
            Report.AddRightAlignedColumn(53);
            Report.AddLeftAlignedColumn(55);
            Report.AddLeftAlignedColumn(58);      {10}
            Report.AddLeftAlignedColumn(77);
            Report.AddLeftAlignedColumn(79);
            Report.AddLeftAlignedColumn(87);
            Report.AddLeftAlignedColumn(90);      {14}


            Report.AddColumn(1,0);
            Report.AddColumn(2,30);
            Report.AddColumn(3,50);
            Report.AddColumn(4,100);
            Report.AddColumn(5,210);
            Report.AddColumn(6,210);
            Report.AddColumn(7,290);
            Report.AddColumn(8,290);
            Report.AddColumn(9,320);
            Report.AddColumn(10,320);
            Report.AddColumn(11,430);
            Report.AddColumn(12,430);
            Report.AddColumn(13,500);
            Report.AddColumn(14,500);
         end;

         if ReportType = rpFullNominalAuditTrail then begin
            //Report.PageHeader.Height := 123;
            Report.PageFooter.Height := 56;
            Report.ReportDate.caption := 'Report Date: ' + NominalReportForm.NomRepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            If (NominalReportForm.rgAccountGroup2.ItemIndex = 0) then Report.SetHeading('Full Nominal Audit Trail - by Nominal Account')
               else Report.SetHeading('Full Nominal Audit Trail - by Report Group');

            If ((NominalReportForm.NomAccFrom.Text <> '') or (NominalReportForm.NomAccTo.Text <> '')) then
               Report.Rangelabel.Caption:= Report.RangeLabel.Caption + 'Accounts: ' + NominalReportForm.NomAccFrom.text + ' to ' + NominalReportForm.NomAccTo.text;
            If ((NominalReportForm.NomTxFrom.Text <> '') or (NominalReportForm.NomTxTo.Text <> '')) then
               Report.Rangelabel.Caption:= Report.RangeLabel.Caption + ' Transactions: ' + NominalReportForm.NomTxFrom.text + ' to ' + NominalReportForm.NomTxTo.text;
            If ((copy(NominalReportForm.NomDateFrom.Text,1,2) <> '  ') or (copy(NominalReportForm.NomDateTo.Text,1,2) <> '  ')) then
               Report.Rangelabel.Caption:= Report.RangeLabel.Caption + 'Dates: ' + NominalReportForm.NomDateFrom.text + ' to ' + NominalReportForm.NomDateTo.text;

            PutAccountNumbersAtTheTopOfThePageNominal;
            Report.AddLeftAlignedColumn(1);       {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(9);
            Report.AddTextColumn(23);
            Report.AddDashColumn(25);             {5}
            Report.AddRightAlignedColumn(27);
            Report.AddTextColumn(32);
            Report.AddDashColumn(38);
            Report.AddRightAlignedColumn(40);
            Report.AddLeftAlignedColumn(42);       {10}
            Report.AddleftAlignedColumn(43);
            Report.AddLeftAlignedColumn(51);
            Report.AddRightAlignedColumn(54);
            Report.AddLeftAlignedColumn(56);
            Report.AddLeftAlignedColumn(60);       {15}
            Report.AddTextColumn(68);
            Report.AddRightAlignedColumn(70);
            Report.AddRightAlignedColumn(83);
            Report.AddLeftAlignedColumn(85);
            Report.AddRightAlignedColumn(94);        {20}
            Report.AddLeftAlignedColumn(96);
            Report.AddLeftAlignedColumn(117);        {22}
            Report.AddLeftAlignedColumn(321);       {23}
            Report.AddTextColumn(29);       {24}

            Report.AddColumn(1,0).font.style := [fsBold];
            Report.AddColumn(2,25).Font.Size := 8;
            Report.AddColumn(3,55).Font.Size := 8;
            Report.AddColumn(4,140).Font.Size := 8;
            Report.AddColumn(5,150).Font.Size := 8;
            Report.AddColumn(6,160).Font.Size := 8;
            Report.AddColumn(7,210).Font.Size := 8;
            Report.AddColumn(8,230).Font.Size := 8;
            Report.AddColumn(9,240).Font.Size := 8;
            Report.AddColumn(10,260).Font.Size := 8;
            Report.AddColumn(11,265).Font.Size := 8;
            Report.AddColumn(12,305).Font.Size := 8;
            Report.AddColumn(13,335).Font.Size := 8;
            Report.AddColumn(14,345).Font.Size := 8;
            Report.AddColumn(15,360).Font.Size := 8;
            Report.AddColumn(16,430).Font.Size := 8; //445
            Report.AddColumn(17,400).Font.Size := 8;
            Report.AddColumn(18,440).Font.Size := 8;   //TGM AB 02/05/02 Changed from 445 to leave more room for Quantity Column
            Report.AddColumn(19,480).Font.Size := 8;
            Report.AddColumn(20,505).Font.Size := 8;
            Report.AddColumn(21,525).Font.Size := 8;
            Report.AddColumn(22,630).Font.Size := 8;
            Report.AddColumn(23,265);
            Report.AddColumn(24,400).Font.style:= [fsBold];  // TGM AB 02/05/02 Changed from 300 to avoid the totals overlapping at the bottom of the trail
            Report.ProcessReport('c:\kingsacc\reports\report.rpt');
         end;


         if ReportType = rpTransactionReport then begin
            Report.SetHeading('Transaction Report');
            Report.ReportDate.caption := 'Report Date: ' + NominalReportForm.TransListingDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;


            If ((NominalReportForm.ListingTxFrom.Text <> '') or (NominalReportForm.ListingTxTo.Text <> '')) then
               Report.Rangelabel.Caption:= Report.RangeLabel.Caption + ' Transaction Range: ' + NominalReportForm.ListingTxFrom.text + ' to ' + NominalReportForm.ListingTxTo.text;
            If ((NominalReportForm.TransListingDateFrom.Text <> '  /  /  ') or (NominalReportForm.TransListingDateTo.Text <> '  /  /  ')) then
               Report.Rangelabel.Caption:= Report.RangeLabel.Caption + ' Date Range: ' + NominalReportForm.TransListingDateFrom.text + ' to ' + NominalReportForm.TransListingDateTo.text;

            Report.AddLeftAlignedColumn(1);      {1}
            Report.AddRightAlignedColumn(6); // was 4
            Report.AddLeftAlignedColumn(9);
            Report.AddTextColumn(11);
            Report.AddTextColumn(20);      {5}
            Report.AddRightAlignedColumn(28);
            Report.AddTextColumn(33);
            Report.AddRightAlignedColumn(40);
            Report.AddLeftAlignedColumn(43);                                 // Ch028 was Report.AddTextColumn(43);
            Report.AddLeftAlignedColumn(54);      {10} // TGM AB was 52
            Report.AddLeftAlignedColumn(68);
            Report.AddLeftAlignedColumn(114);     // TGM AB was 69           // Ch028 was 110
            Report.AddLeftAlignedColumn(84);
            Report.AddLeftAlignedColumn(124);                                // Ch028 new cust / supp column


            Report.AddColumn(1,0).Font.Style := [fsBold];

            Report.AddColumn(2,30).Font.Size := 8;
            Report.AddColumn(3,50).Font.Size := 8;
            Report.AddColumn(4,70).Font.Size := 8;
            Report.AddColumn(5,150).Font.Size := 8;
            Report.AddColumn(6,150).Font.Size := 8;
            Report.AddColumn(7,215).Font.Size := 8;
            Report.AddColumn(8,215).Font.Size := 8;
            Report.AddColumn(9,235).Font.Size := 8;                          // Ch028 was 340
            Report.AddColumn(10,295).Font.Size := 8;
            Report.AddColumn(11,425).Font.Size := 8;
            Report.AddColumn(12,425).Font.Size := 8;
            Report.AddColumn(13,480).Font.Size := 8;
            Report.AddColumn(14,590).Font.Size := 8;                                        // Ch028

            //Ch028 start

            Report.ReplaceText('Standing Order Expenditure', 'Standing Order Exp');
            Report.ReplaceText('Standing Order Income', 'Standing Order Inc');
            Report.ReplaceText('CUST/SUPP', 'Customer/Supplier');

            Report.CurrReport:='TransactionReport';

            //Ch028 end

        //    Report.ReplaceText('ESCRIPTION', 'Description');
         end;

         if ReportType = rpTrialBalance then begin
            If (NominalReportForm.rgAccountGroup.ItemIndex = 0) then Report.SetHeading('Trial Balance - by Nominal Account')
               else Report.SetHeading('Trial Balance - by Report Group');
            If ((NominalReportForm.AccFrom.Text <> '') or (NominalReportForm.AccTo.Text <> '')) then
               Report.Rangelabel.Caption:= Report.RangeLabel.Caption + ' Account Range: ' + NominalReportForm.AccFrom.text + ' to ' + NominalReportForm.AccTo.text;
            Report.PageFooter.Height := 56;
            Report.ReportDate.caption := 'Report Date: ' + NominalReportForm.TrialBalanceDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

                        Report.AddLeftAlignedColumn(1);    {1}
                        Report.AddRightAlignedColumn(4);
                        Report.AddLeftAlignedColumn(7);
                        Report.AddLeftAlignedColumn(9);
                        Report.AddTextColumn(46);
                        Report.AddLeftAlignedColumn(75);      {5}
                        Report.AddLeftAlignedColumn(105);
                        Report.AddDashColumn(53);
                        Report.AddRightAlignedColumn(55);
                        Report.AddDashColumn(65);
                        Report.AddRightAlignedColumn(67);        {10}
                        Report.AddDashColumn(83);
                        Report.AddRightAlignedColumn(85);
                        Report.AddDashColumn(95);
                        Report.AddRightAlignedColumn(97);
                        Report.AddDashColumn(113);                   {15}
                        Report.AddRightAlignedColumn(115);
                        Report.AddDashColumn(125);
                        Report.AddRightAlignedColumn(127);
                        Report.AddLeftAlignedColumn(29);                {19}
                        //            Report.AddRightAlignedColumn(84);

                        Report.AddColumn(1,0).Font.Style := [fsBold];
                        Report.AddColumn(2,20);
                        if nominalreportform.TrialByAccount.checked = false then Report.AddColumn(3,50);
                        if nominalreportform.TrialByAccount.checked = true then Report.AddColumn(4,50);
                        Report.AddColumn(5,340);
                        Report.AddColumn(6,420);
                        Report.AddColumn(7,583);

                        Report.AddColumn(8,250);
                        Report.AddColumn(9,260);

                        Report.AddColumn(10,330);
                        Report.AddColumn(11,340);

                        Report.AddColumn(12,455);
                        Report.AddColumn(13,465);

                        Report.AddColumn(14,510);
                        Report.AddColumn(15,530);

                        Report.AddColumn(16,620);
                        Report.AddColumn(17,630);

                        Report.AddColumn(18,690);
                        Report.AddColumn(19,700);

                        Report.AddColumn(20,250).Font.Style := [fsBold];
                        //            Report.AddColumn(20,400);
   (*           end
                  else begin
                // this section deals with printing by group
                        Report.AddLeftAlignedColumn(1);    {1}
                        Report.AddRightAlignedColumn(4);
                        Report.AddLeftAlignedColumn(7);
                        Report.AddLeftAlignedColumn(9);
                        Report.AddTextColumn(46);
                        Report.AddLeftAlignedColumn(47);
                        Report.AddLeftAlignedColumn(75);
                        Report.AddLeftAlignedColumn(105);
                        Report.AddDashColumn(53);
                        Report.AddRightAlignedColumn(56);
                        Report.AddDashColumn(65);
                        Report.AddRightAlignedColumn(68);
                        Report.AddDashColumn(83);
                        Report.AddRightAlignedColumn(85);
                        Report.AddDashColumn(95);
                        Report.AddRightAlignedColumn(97);
                        Report.AddDashColumn(113);
                        Report.AddRightAlignedColumn(115);
                        Report.AddDashColumn(125);
                        Report.AddRightAlignedColumn(127);
                        Report.AddLeftAlignedColumn(29);
                        Report.AddRightAlignedColumn(54);
                        Report.AddRightAlignedColumn(66);
                        //            Report.AddRightAlignedColumn(84);

                        Report.AddColumn(1,0).Font.Style := [fsBold];

                        Report.AddColumn(2,20);
                        Report.AddColumn(3,50);

                        Report.AddColumn(4,50);
                        Report.AddColumn(5,340);
                        Report.AddColumn(6,214);
                        Report.AddColumn(7,420);
                        Report.AddColumn(8,600);

                        Report.AddColumn(9,250);
                        Report.AddColumn(10,260);

                        Report.AddColumn(11,330);
                        Report.AddColumn(12,340);

                        Report.AddColumn(13,455);
                        Report.AddColumn(14,465);

                        Report.AddColumn(15,510);
                        Report.AddColumn(16,530);

                        Report.AddColumn(17,620);
                        Report.AddColumn(18,630);

                        Report.AddColumn(19,690);
                        Report.AddColumn(20,700);

                        Report.AddColumn(21,250).Font.Style := [fsBold];
                        Report.AddColumn(22,260);
                        Report.AddColumn(23,340);
                        //            Report.AddColumn(20,400);
                end;
        *) end;

         if ReportType = rpProfitAndLoss then begin
            Report.SetHeading('Profit and Loss Account');
            Report.ReportDate.caption := 'Report Date: ' + CashFlowReportsForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.PageFooter.Height := 56;
            Report.AddLeftAlignedColumn(1);
            Report.AddLeftAlignedColumn(4);
            Report.AddRightAlignedColumn(57);
            Report.AddRightAlignedColumn(73);
            Report.AddColumn(1,0).Font.Style := [fsBold];
            Report.AddColumn(2,20);
            Report.AddColumn(3,300);
            Report.AddColumn(4,500);
//            Report.ExcludeLines([1,2,3,4,35,36,37,38,39,40]);
         end;

         if ReportType = rpManagementBalance1 then begin
            Report.ReportDate.caption := 'Report Date: ' + NominalReportForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.PageFooter.Height := 52;
            Report.SetHeading('Management Balance Sheet');
            Report.AddLeftAlignedColumn(1);

            Report.AddLeftAlignedColumn(2);
            Report.AddLeftAlignedColumn(9);

            Report.AddLeftAlignedColumn(46);
            Report.AddLeftAlignedColumn(75);
            Report.AddLeftAlignedColumn(105);

            Report.AddDashColumn(53);
            Report.AddRightAlignedColumn(55);
            Report.AddDashColumn(65);
            Report.AddRightAlignedColumn(67);
            Report.AddDashColumn(83);
            Report.AddRightAlignedColumn(85);
            Report.AddDashColumn(95);
            Report.AddRightAlignedColumn(97);
            Report.AddDashColumn(113);
            Report.AddRightAlignedColumn(115);
            Report.AddDashColumn(125);
            Report.AddRightAlignedColumn(127);

            Report.AddColumn(1,0).Font.Style := [fsBold];

            Report.AddColumn(2,20);
            Report.AddColumn(3,50);

            Report.AddColumn(4,220);
            Report.AddColumn(5,400);
            Report.AddColumn(6,580);

            Report.AddColumn(7,250);
            Report.AddColumn(8,260);

            Report.AddColumn(9,330);
            Report.AddColumn(10,340);

            Report.AddColumn(11,455);
            Report.AddColumn(12,465);

            Report.AddColumn(13,510);
            Report.AddColumn(14,530);

            Report.AddColumn(15,620);
            Report.AddColumn(16,630);

            Report.AddColumn(17,690);
            Report.AddColumn(18,700);
         end;

         if ReportType = rpManagementBalance2 then begin
            Report.SetHeading('Management Balance Sheet');
            Report.ReportDate.caption := 'Report Date: ' + NominalReportForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.PageFooter.Height := 56;
            Report.AddLeftAlignedColumn(1);

            Report.AddLeftAlignedColumn(2);
            Report.AddLeftAlignedColumn(9);

            Report.AddBracketColumn(43);
//            Report.AddBracketColumn(44);
            Report.AddRightAlignedColumn(55);
            Report.AddBracketColumn(56);

            Report.AddBracketColumn(63);    //64
            Report.AddRightAlignedColumn(75);
            Report.AddBracketColumn(76);

            Report.AddDashColumn(53);
            Report.AddDashColumn(72);


            Report.AddColumn(1,0).Font.Style := [fsBold];

            Report.AddColumn(2,20);
            Report.AddColumn(3,50);

            Report.AddColumn(4,270);
            Report.AddColumn(5,280);
            Report.AddColumn(6,290);

            Report.AddColumn(7,300);
            Report.AddColumn(8,400);
            Report.AddColumn(9,410);

            Report.AddColumn(10,250);
            Report.AddColumn(11,350);
         end;

         if ReportType = rpCostingReportThisYear then begin
            Report.SetHeading('Costing Report - This Year');
            Report.ReportDate.caption := 'Report Date: ' + EntCostPerUnit.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1); {1}    // Start Heading
            Report.AddRightAlignedColumn(6);       // Nominal Code
            Report.AddLeftAlignedColumn(10);       // Nominal Description
            Report.AddTextColumn(49);              // THIS-YEAR    // Report.AddLeftAlignedColumn(49);
            Report.AddRightAlignedColumn(57);  {5} // Values
            Report.AddLeftAlignedColumn(61);       // THIS-PERIOD
            Report.AddRightAlignedColumn(71);      // Values
            Report.AddLeftAlignedColumn(77);       // PD-BUDGET
            Report.AddRightAlignedColumn(85);      // Values
            Report.AddLeftAlignedColumn(90);  {10} // PD-BUD-COMP
            Report.AddRightAlignedColumn(99);      // Values
            Report.AddLeftAlignedColumn(105);      // YR-BUDGET
            Report.AddRightAlignedColumn(113);     // Values
            Report.AddLeftAlignedColumn(118);      // YR-BUD-COMP
            Report.AddRightAlignedColumn(127);{15} // Values

            Report.AddColumn(1,0).Font.Style := [fsBold];
            Report.AddColumn(2,15);
            Report.AddColumn(3,40);
            Report.AddColumn(4,285);    //245
            Report.AddColumn(5,290);
            Report.AddColumn(6,498);
            Report.AddColumn(7,545);
            Report.AddColumn(8,580);
            Report.AddColumn(9,630);
            Report.AddColumn(10,655); //490
            Report.AddColumn(11,710);
            Report.AddColumn(12,325);
            Report.AddColumn(13,375);
            Report.AddColumn(14,410);   //660
            Report.AddColumn(15,460);

            Report.ReplaceText('THIS-YEAR','Yr-Actual');
            Report.ReplaceText('THIS-PERIOD','Pd-Actual');
            Report.ReplaceText('PD-BUD-COMP','Pd-Variance');
            Report.ReplaceText('YR-BUD-COMP','Yr-Variance');

         end;

         if ReportType = rpThisYearVsPrevYear then begin
            Report.SetHeading('Costing Report - This Year Vs Previous Year');
            Report.ReportDate.caption := 'Report Date: ' + EntCostPerUnit.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1); {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(10);
            Report.AddLeftAlignedColumn(44);   // TGM AB 02/05/02 Changed from 49 to include 'This-' in header and fix problems will figures in millions
            Report.AddRightAlignedColumn(57);  {5}
            Report.AddLeftAlignedColumn(61);
            Report.AddRightAlignedColumn(71);
            Report.AddLeftAlignedColumn(77);
            Report.AddRightAlignedColumn(85);
            Report.AddLeftAlignedColumn(90);      {10}
            Report.AddRightAlignedColumn(99);
            Report.AddLeftAlignedColumn(105);
            Report.AddRightAlignedColumn(113);
            Report.AddLeftAlignedColumn(118);
            Report.AddRightAlignedColumn(127);        {15}

            Report.AddColumn(1,0).Font.Style := [fsBold];
            Report.AddColumn(2,15);
            Report.AddColumn(3,40);
            Report.AddColumn(4,270);   // TGM AB 02/05/02 Changed from 295 to include 'This-' in header and fix problems will figures in millions
            Report.AddColumn(5,340);
            Report.AddColumn(6,365);
            Report.AddColumn(7,425);
            Report.AddColumn(8,460);
            Report.AddColumn(9,510);
            Report.AddColumn(10,540);
            Report.AddColumn(11,595);
            Report.AddColumn(12,630);
            Report.AddColumn(13,680);
            Report.AddColumn(14,710);
            Report.AddColumn(15,760);
         end;

         if ReportType = rpThisYearVsBudgetAndLastYear then begin
            Report.SetHeading('Costing Report - This Year vs. Budget and Last Year');
            Report.ReportDate.caption := 'Report Date: ' + EntCostPerUnit.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(10);
            Report.Addtextcolumn(85);  //Report.AddLeftAlignedColumn(85);
            Report.AddRightAlignedColumn(92);
            Report.Addtextcolumn(98);//Report.AddLeftAlignedColumn(98);
            Report.AddRightAlignedColumn(106);
            Report.Addtextcolumn(109);//Report.AddLeftAlignedColumn(109);
            Report.AddRightAlignedColumn(118);
            Report.Addtextcolumn(122);//Report.AddLeftAlignedColumn(122);
            Report.AddRightAlignedColumn(131);
            Report.AddRightAlignedColumn(40);
            Report.Addtextcolumn(43);

            if Entreps.EntCostPerUnit.IncludeLastYear.checked then begin
               Report.AddColumn(1,0);
               Report.AddColumn(2,15);
               Report.AddColumn(3,35);
               Report.AddColumn(4,275);
               Report.AddColumn(5,275);                     {5}
               Report.AddColumn(6,340);  // 310
               Report.AddColumn(7,340);
               Report.AddColumn(8,490).Font.Color := clblue;  //380
               Report.AddColumn(9,415).Font.Color := clBlue;
               Report.AddColumn(10,610).Font.Color := clred;  // Variance ... label
               Report.AddColumn(11,490).Font.Color := clblue;  // 500
               Report.AddColumn(12,275); // to no of ent units!!!
               Report.AddColumn(13,685).Font.Color := clred;
               Report.AddColumn(14,600).Font.Color := clred; // these two fields are the variance figures calculated later
               Report.AddColumn(15,685).Font.Color := clred; //


               Report.ReplaceText('THIS-YTD', 'Year To Date -    This Year');
               Report.ReplaceText('LAST-YTD', 'Last Year');
               Report.ReplaceText('BUDGET-YTD', 'Budget    Annual Bud');
               Report.ReplaceText('THIS-PD-ACT','vs Last Year');
               Report.ReplaceText('ANNUAL-BUD', 'Variance : vs Budget');
            end
               else begin
               Report.AddColumn(1,0);
               Report.AddColumn(2,15);
               Report.AddColumn(3,35);   //35
               Report.AddColumn(4,295);
               Report.AddColumn(5,295);                     {5}
        //       Report.AddColumn(6,340);  // 310
        //       Report.AddColumn(7,340);
               Report.AddColumn(8,420).Font.Color := clblue;  //410
               Report.AddColumn(9,425).Font.Color := clBlue;  //415
               Report.AddColumn(10,610).Font.Color := clred;  // Variance ... label
        //       Report.AddColumn(11,490).Font.Color := clblue;  // 500
               Report.AddColumn(12,295); // to no of ent units!!!
          //     Report.AddColumn(13,685).Font.Color := clred;
               Report.AddColumn(14,600).Font.Color := clred; // these two fields are the variance figures calculated later
          //     Report.AddColumn(15,685).Font.Color := clred; //


               Report.ReplaceText('THIS-YTD', 'Year To Date');
               Report.ReplaceText('LAST-YTD', 'Last Year');
              // Report.ReplaceText('BUDGET-YTD', 'Budget    Annual Bud');
              Report.ReplaceText('BUDGET-YTD', 'Budget');
               Report.ReplaceText('THIS-PD-ACT','');
               Report.ReplaceText('ANNUAL-BUD', 'Variance : vs Budget');

               end;

            Report.CurrReport:='ThisYearVsBudgetAndLastYear';
         end;

         if ReportType = rpThisMonthVsBudgetAndLastYear then begin
            Report.SetHeading('Costing Report - This Month vs. Budget and Last Year');
            Report.ReportDate.caption := 'Report Date: ' + EntCostPerUnit.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(10);
            Report.AddLeftAlignedColumn(43);
            Report.AddRightAlignedColumn(53);              {5}
            Report.AddLeftAlignedColumn(56);
            Report.AddRightAlignedColumn(66);
            Report.AddLeftAlignedColumn(69);
            Report.AddRightAlignedColumn(79);
            Report.AddRightAlignedColumn(40);

            Report.AddColumn(1,0);
            Report.AddColumn(2,35);
            Report.AddColumn(3,55);
            Report.AddColumn(4,165);
            Report.AddColumn(5,270);                     {5}
            Report.AddColumn(6,500).Font.Color := clred;  //615    // Last Year Label
            Report.AddColumn(7,360);
            Report.AddColumn(8,415).Font.Color := clblue;
            Report.AddColumn(9,450).Font.Color := clblue;
            Report.AddColumn(10,270);
            Report.AddColumn(11,590).Font.Color := clred; //
            Report.AddColumn(12,670).Font.Color := clred;;

            Report.ReplaceText('THIS-PD-ACT', 'This Month -    Actual            Last Year');
            Report.ReplaceText('THIS-PD-LST', 'Variance : vs Budget      vs Last Year');
            Report.ReplaceText('THIS-PD-BUD','Budget');

            Report.CurrReport:='ThisMonthVsBudgetAndLastYear';
         end;

         if ReportType = rpLastYearMonthly then begin
            Report.SetHeading('Costing Report - Last Year Monthly');
            Report.ReportDate.caption := 'Report Date: ' + EntCostPerUnit.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.LinesPerPage := 35;
            Report.Page.Orientation := poLandscape;
            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(10);
            Report.AddTextColumn(45);
            Report.AddRightAlignedColumn(35);              {5}
            Report.AddTextColumn(52);
            Report.AddRightAlignedColumn(43);
            Report.AddTextColumn(59);
            Report.AddRightAlignedColumn(51);
            Report.AddTextColumn(66);              {10}
            Report.AddRightAlignedColumn(59);
            Report.AddTextColumn(73);
            Report.AddRightAlignedColumn(67);
            Report.AddTextColumn(80);
            Report.AddRightAlignedColumn(75);          {15}
            Report.AddTextColumn(87);
            Report.AddRightAlignedColumn(83);
            Report.AddTextColumn(94);
            Report.AddRightAlignedColumn(91);
            Report.AddTextColumn(101);               {20}
            Report.AddRightAlignedColumn(99);
            Report.AddTextColumn(108);
            Report.AddRightAlignedColumn(107);
            Report.AddTextColumn(115);
            Report.AddRightAlignedColumn(115);             {25}
            Report.AddTextColumn(122);
            Report.AddRightAlignedColumn(123);
            Report.AddTextColumn(127);        {28}
            Report.AddRightAlignedColumn(132);        {28}

            Report.AddColumn(1,0);             {1}
            Report.AddColumn(2,15);
            Report.AddColumn(3,35);
            Report.AddColumn(4,220);              //200
            Report.AddColumn(5,220);                     {5}
            Report.AddColumn(6,285);               //240
            Report.AddColumn(7,285);
            Report.AddColumn(8,350);              //280
            Report.AddColumn(9,350);
            Report.AddColumn(10,415);              //320
            Report.AddColumn(11,415);
            Report.AddColumn(12,480);               //360
            Report.AddColumn(13,480);
            Report.AddColumn(14,545);                //400
            Report.AddColumn(15,545);
            Report.AddColumn(16,610);                //440
            Report.AddColumn(17,610);
            Report.AddColumn(18,675);                 //480
            Report.AddColumn(19,675);
            Report.AddColumn(20,730);                 //520
            Report.AddColumn(21,730);
            Report.AddColumn(22,795);                //580
            Report.AddColumn(23,795);
            Report.AddColumn(24,860);                //600
            Report.AddColumn(25,860);
            Report.AddColumn(26,925);                //640
            Report.AddColumn(27,925);
            Report.AddColumn(28,990);                    //690
            Report.AddColumn(29,990);     //690


       (*     Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(10);
            Report.AddTextColumn(45);
            Report.AddRightAlignedColumn(47);              {5}
            Report.AddTextColumn(52);
            Report.AddRightAlignedColumn(54);
            Report.AddTextColumn(59);
            Report.AddRightAlignedColumn(61);
            Report.AddTextColumn(66);              {10}
            Report.AddRightAlignedColumn(68);
            Report.AddTextColumn(73);
            Report.AddRightAlignedColumn(75);
            Report.AddTextColumn(80);
            Report.AddRightAlignedColumn(82);          {15}
            Report.AddTextColumn(87);
            Report.AddRightAlignedColumn(89);
            Report.AddTextColumn(94);
            Report.AddRightAlignedColumn(96);
            Report.AddTextColumn(101);               {20}
            Report.AddRightAlignedColumn(103);
            Report.AddTextColumn(108);
            Report.AddRightAlignedColumn(110);
            Report.AddTextColumn(115);
            Report.AddRightAlignedColumn(117);             {25}
            Report.AddTextColumn(122);
            Report.AddRightAlignedColumn(124);
            Report.AddTextColumn(127);        {28}
            Report.AddRightAlignedColumn(132);        {28}

            Report.AddColumn(1,0);             {1}
            Report.AddColumn(2,15);
            Report.AddColumn(3,35).Font.Size := 8;
            Report.AddColumn(4,200);
            Report.AddColumn(5,200).Font.Size := 8;                     {5}
            Report.AddColumn(6,240);
            Report.AddColumn(7,240).Font.Size := 8;
            Report.AddColumn(8,280);
            Report.AddColumn(9,280).Font.Size := 8;
            Report.AddColumn(10,320);
            Report.AddColumn(11,320).Font.Size := 8;
            Report.AddColumn(12,360);
            Report.AddColumn(13,360).Font.Size := 8;
            Report.AddColumn(14,400);
            Report.AddColumn(15,400).Font.Size := 8;
            Report.AddColumn(16,440);
            Report.AddColumn(17,440).Font.Size := 8;
            Report.AddColumn(18,480);
            Report.AddColumn(19,480).Font.Size := 8;
            Report.AddColumn(20,520);
            Report.AddColumn(21,520).Font.Size := 8;
            Report.AddColumn(22,560);
            Report.AddColumn(23,560).Font.Size := 8;
            Report.AddColumn(24,600);
            Report.AddColumn(25,600).Font.Size := 8;
            Report.AddColumn(26,640);
            Report.AddColumn(27,640).Font.Size := 8;
            Report.AddColumn(28,690);
            Report.AddColumn(29,690).Font.Size := 8;        *)
         end;

         if ReportType = rpThisYearMonthly then begin
            Report.SetHeading('Costing Report - This Year Monthly');
            Report.ReportDate.caption := 'Report Date: ' + EntCostPerUnit.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.LinesPerPage := 35;
            Report.Page.Orientation := poLandscape;
            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(10);
            Report.AddTextColumn(45);
            Report.AddRightAlignedColumn(35); // was 47              {5}
            Report.AddTextColumn(52);
            Report.AddRightAlignedColumn(43); // was 54
            Report.AddTextColumn(59);
            Report.AddRightAlignedColumn(51); // was 61
            Report.AddTextColumn(66);              {10}
            Report.AddRightAlignedColumn(59); // was 68
            Report.AddTextColumn(73);
            Report.AddRightAlignedColumn(67); // was 75
            Report.AddTextColumn(80);
            Report.AddRightAlignedColumn(75); // was 82         {15}
            Report.AddTextColumn(87);
            Report.AddRightAlignedColumn(83); // was 89
            Report.AddTextColumn(94);
            Report.AddRightAlignedColumn(91); // was 96
            Report.AddTextColumn(101);               {20}
            Report.AddRightAlignedColumn(99); // was 103
            Report.AddTextColumn(108);
            Report.AddRightAlignedColumn(107); // was 110
            Report.AddTextColumn(114);
            Report.AddRightAlignedColumn(115); // was 117            {25}
            Report.AddTextColumn(122);
            Report.AddRightAlignedColumn(123); // was 124
            Report.AddTextColumn(127);        {28}
            Report.AddRightAlignedColumn(132);        {28}

            Report.AddColumn(1,0);             {1}
            Report.AddColumn(2,15);
            Report.AddColumn(3,35);
            Report.AddColumn(4,220);              //200
            Report.AddColumn(5,220);                     {5}
            Report.AddColumn(6,285);               //240
            Report.AddColumn(7,285);
            Report.AddColumn(8,350);              //280
            Report.AddColumn(9,350);
            Report.AddColumn(10,415);              //320
            Report.AddColumn(11,415);
            Report.AddColumn(12,480);               //360
            Report.AddColumn(13,480);
            Report.AddColumn(14,545);                //400
            Report.AddColumn(15,545);
            Report.AddColumn(16,610);                //440
            Report.AddColumn(17,610);
            Report.AddColumn(18,675);                 //480
            Report.AddColumn(19,675);
            Report.AddColumn(20,730);                 //520
            Report.AddColumn(21,730);
            Report.AddColumn(22,795);                //780
            Report.AddColumn(23,795);
            Report.AddColumn(24,860);                //600
            Report.AddColumn(25,860);
            Report.AddColumn(26,925);                //640
            Report.AddColumn(27,925);
            Report.AddColumn(28,990);                    //690
            Report.AddColumn(29,990);     //690
         end;

         if ReportType = rpCostPerUnit then begin
            Report.SetHeading('Costing Report - Cost Per Unit');
            Report.ReportDate.caption := 'Report Date: ' + EntCostPerUnit.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(10);
            Report.AddTextColumn(49);
            Report.AddTextColumn(52);                      {5}
            Report.AddRightAlignedColumn(57);
            Report.AddTextColumn(63);
            Report.AddRightAlignedColumn(71);
            Report.AddTextColumn(86);
            Report.AddRightAlignedColumn(91);      {10}
            Report.AddTextColumn(98);
            Report.AddRightAlignedColumn(107);
            Report.AddTextColumn(73);                  {12}
            Report.AddRightAlignedColumn(75);

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,35);
            Report.AddColumn(3,55);
            Report.AddColumn(4,300);
            Report.AddColumn(5,285);                     {5}
            Report.AddColumn(6,300);
            Report.AddColumn(7,400);     // TGM AB Chagned from 390 to 400
            Report.AddColumn(8,390);
            Report.AddColumn(9,500);
            Report.AddColumn(10,500);
            Report.AddColumn(11,700);
            Report.AddColumn(12,700);

         end;

         if ReportType = rpOverheadThisYearOnly then begin
            Report.SetHeading('Overheads / Other Income - This Year Only');
            Report.ReportDate.caption := 'Report Date: ' + CashflowReportsForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);        {1}
            Report.AddLeftAlignedColumn(4);
            Report.AddLeftAlignedColumn(10);
            Report.AddLeftAlignedColumn(23);
            Report.AddRightAlignedColumn(58);          {5}
            Report.AddLeftAlignedColumn(60);
            Report.AddRightAlignedColumn(72);

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,20);
            Report.AddColumn(3,55);
            Report.AddColumn(4,450);
            Report.AddColumn(5,500);                     {5}
            Report.AddColumn(6,350);
            Report.AddColumn(7,650);
            Report.ReplaceText('OVERHEADS - THIS YEAR ONLTHIS-YEAR ', 'This Year');


         end;

         if ReportType = rpOverheadThisYearVsLastYear then begin
            Report.SetHeading('Overheads / Other Income - This Year vs. Last Year');
            Report.ReportDate.caption := 'Report Date: ' + CashflowReportsForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);        {1}
            Report.AddLeftAlignedColumn(4);
            Report.AddLeftAlignedColumn(10);
            Report.AddLeftAlignedColumn(27);
            Report.AddRightAlignedColumn(54);          {5}
            Report.AddRightAlignedColumn(67);
            Report.AddLeftAlignedColumn(69);
            Report.AddRightAlignedColumn(80);
            Report.Addtextcolumn(85); //Report.AddLeftAlignedColumn(85);
            Report.AddRightAlignedColumn(93);       {10}
            Report.AddLeftAlignedColumn(98);
            Report.AddRightAlignedColumn(106);
            Report.AddLeftAlignedColumn(109);
            Report.AddRightAlignedColumn(119);
            Report.AddTextColumn(122);        {15}
            Report.AddRightAlignedColumn(132);

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,20);
            Report.AddColumn(3,55);
            Report.AddColumn(4,150);
            Report.AddColumn(5,275);                     {5}
            Report.AddColumn(6,345);
            Report.AddColumn(7,375);
            Report.AddColumn(8,415);
            Report.AddColumn(9,490);  //485
            Report.AddColumn(10,485);                     {10}
            Report.AddColumn(11,515);
            Report.AddColumn(12,560);
            Report.AddColumn(13,575);
            Report.AddColumn(14,630);
            Report.AddColumn(15,700);                     {15}
            Report.AddColumn(16,700);

         end;

         if ReportType = rpOverheadThisYearVsLastThreeYears then begin

            Report.SetHeading('Overheads / Other Income - This Year Vs. Last Three Years');
            Report.ReportDate.caption := 'Report Date: ' + CashflowReportsForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);        {1}
            Report.AddLeftAlignedColumn(4);
            Report.AddLeftAlignedColumn(10);

            Report.AddLeftAlignedColumn(24);
            Report.AddRightAlignedColumn(58);          {5}
            Report.AddRightAlignedColumn(72);
            Report.AddLeftAlignedColumn(200);   // AB 29/08/02 changed from 81 setting to 200 ensures no data picked up
            Report.AddRightAlignedColumn(86);
            Report.AddLeftAlignedColumn(200);   // AB 29/08/02 changed from 91 setting to 200 ensures no data picked up
            Report.AddRightAlignedColumn(100);       {10}

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,20);
            Report.AddColumn(3,55);
            Report.AddColumn(4,330);
            Report.AddColumn(5,420);                     {5}
            Report.AddColumn(6,500);
            Report.AddColumn(7,545);
            Report.AddColumn(8,575);
            Report.AddColumn(9,600);
            Report.AddColumn(10,650);                     {10}

         end;

         if ReportType = rpOverheadLastYearMonthly then begin
            Report.SetHeading('Overheads / Other Income - Last Year Monthly');
            Report.ReportDate.caption := 'Report Date: ' + CashflowReportsForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.Page.Orientation := PoLandscape;
            Report.LinesPerPage := 35;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddLeftAlignedColumn(4);
            Report.AddLeftAlignedColumn(10);
            Report.AddTextColumn(48);
            Report.AddRightAlignedColumn(47);              {5}
            Report.AddTextColumn(55);
            Report.AddRightAlignedColumn(54);
            Report.AddTextColumn(62);
            Report.AddRightAlignedColumn(61);
            Report.AddTextColumn(69);              {10}
            Report.AddRightAlignedColumn(68);
            Report.AddTextColumn(76);
            Report.AddRightAlignedColumn(75);
            Report.AddTextColumn(83);
            Report.AddRightAlignedColumn(82);          {15}
            Report.AddTextColumn(90);
            Report.AddRightAlignedColumn(89);
            Report.AddTextColumn(97);
            Report.AddRightAlignedColumn(96);
            Report.AddTextColumn(104);               {20}
            Report.AddRightAlignedColumn(103);
            Report.AddTextColumn(111);
            Report.AddRightAlignedColumn(110);
            Report.AddTextColumn(118);
            Report.AddRightAlignedColumn(117);             {25}
            Report.AddTextColumn(125);
            Report.AddRightAlignedColumn(124);
            Report.AddTextColumn(127);        {28}
            Report.AddRightAlignedColumn(131);

            Report.AddColumn(1,0);             {1}
            Report.AddColumn(2,15);
            Report.AddColumn(3,55);//  .Font.Size := 8;
            Report.AddColumn(4,260);              //200
            Report.AddColumn(5,260);                     {5}
            Report.AddColumn(6,320);               //240
            Report.AddColumn(7,320);
            Report.AddColumn(8,380);              //280
            Report.AddColumn(9,380);
            Report.AddColumn(10,440);              //320
            Report.AddColumn(11,440);
            Report.AddColumn(12,500);               //360
            Report.AddColumn(13,500);
            Report.AddColumn(14,560);                //400
            Report.AddColumn(15,560);
            Report.AddColumn(16,620);                //440
            Report.AddColumn(17,620);
            Report.AddColumn(18,680);                 //480
            Report.AddColumn(19,680);
            Report.AddColumn(20,740);                 //520
            Report.AddColumn(21,740);
            Report.AddColumn(22,800);                //780
            Report.AddColumn(23,800);
            Report.AddColumn(24,860);                //600
            Report.AddColumn(25,860);
            Report.AddColumn(26,920);                //640
            Report.AddColumn(27,920);
            Report.AddColumn(28,990);                    //690
            Report.AddColumn(29,990);     //690

       (*     Report.AddColumn(4,200);
            Report.AddColumn(5,200).Font.Size := 8;                     {5}
            Report.AddColumn(6,240);
            Report.AddColumn(7,240).Font.Size := 8;
            Report.AddColumn(8,280);
            Report.AddColumn(9,280).Font.Size := 8;
            Report.AddColumn(10,320);
            Report.AddColumn(11,320).Font.Size := 8;
            Report.AddColumn(12,360);
            Report.AddColumn(13,360).Font.Size := 8;
            Report.AddColumn(14,400);
            Report.AddColumn(15,400).Font.Size := 8;
            Report.AddColumn(16,440);
            Report.AddColumn(17,440).Font.Size := 8;
            Report.AddColumn(18,480);
            Report.AddColumn(19,480).Font.Size := 8;
            Report.AddColumn(20,520);
            Report.AddColumn(21,520).Font.Size := 8;
            Report.AddColumn(22,560);
            Report.AddColumn(23,560).Font.Size := 8;
            Report.AddColumn(24,600);
            Report.AddColumn(25,600).Font.Size := 8;
            Report.AddColumn(26,640);
            Report.AddColumn(27,640).Font.Size := 8;
            Report.AddColumn(28,690);
            Report.AddColumn(29,690).Font.Size := 8;

            *)
         end;

         if ReportType = rpOverheadThisYearMonthly then begin
            Report.SetHeading('Overheads / Other Income - This Year Monthly');
            Report.ReportDate.caption := 'Report Date: ' + CashflowReportsForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.Page.Orientation := PoLandscape;
            Report.LinesPerPage := 35;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddLeftAlignedColumn(4);
            Report.AddLeftAlignedColumn(10);
            Report.AddTextColumn(48);
            Report.AddRightAlignedColumn(47);              {5}
            Report.AddTextColumn(55);
            Report.AddRightAlignedColumn(54);
            Report.AddTextColumn(62);
            Report.AddRightAlignedColumn(61);
            Report.AddTextColumn(69);              {10}
            Report.AddRightAlignedColumn(68);
            Report.AddTextColumn(76);
            Report.AddRightAlignedColumn(75);
            Report.AddTextColumn(83);
            Report.AddRightAlignedColumn(82);          {15}
            Report.AddTextColumn(90);
            Report.AddRightAlignedColumn(89);
            Report.AddTextColumn(97);
            Report.AddRightAlignedColumn(96);
            Report.AddTextColumn(104);               {20}
            Report.AddRightAlignedColumn(103);
            Report.AddTextColumn(111);
            Report.AddRightAlignedColumn(110);
            Report.AddTextColumn(118);
            Report.AddRightAlignedColumn(117);             {25}
            Report.AddTextColumn(125);
            Report.AddRightAlignedColumn(124);
            Report.AddTextColumn(127);        {28}
            Report.AddRightAlignedColumn(131);

            Report.AddColumn(1,0);             {1}
            Report.AddColumn(2,15);
            Report.AddColumn(3,55); // .Font.Size := 8;

            Report.AddColumn(4,260);              //200
            Report.AddColumn(5,260);                     {5}
            Report.AddColumn(6,320);               //240
            Report.AddColumn(7,320);
            Report.AddColumn(8,380);              //280
            Report.AddColumn(9,380);
            Report.AddColumn(10,440);              //320
            Report.AddColumn(11,440);
            Report.AddColumn(12,500);               //360
            Report.AddColumn(13,500);
            Report.AddColumn(14,560);                //400
            Report.AddColumn(15,560);
            Report.AddColumn(16,620);                //440
            Report.AddColumn(17,620);
            Report.AddColumn(18,680);                 //480
            Report.AddColumn(19,680);
            Report.AddColumn(20,740);                 //520
            Report.AddColumn(21,740);
            Report.AddColumn(22,800);                //780
            Report.AddColumn(23,800);
            Report.AddColumn(24,860);                //600
            Report.AddColumn(25,860);
            Report.AddColumn(26,920);                //640
            Report.AddColumn(27,920);
            Report.AddColumn(28,990);                    //690
            Report.AddColumn(29,990);     //690

            (*
            Report.AddColumn(4,200);
            Report.AddColumn(5,200).Font.Size := 8;                     {5}
            Report.AddColumn(6,240);
            Report.AddColumn(7,240).Font.Size := 8;
            Report.AddColumn(8,280);
            Report.AddColumn(9,280).Font.Size := 8;
            Report.AddColumn(10,320);
            Report.AddColumn(11,320).Font.Size := 8;
            Report.AddColumn(12,360);
            Report.AddColumn(13,360).Font.Size := 8;
            Report.AddColumn(14,400);
            Report.AddColumn(15,400).Font.Size := 8;
            Report.AddColumn(16,440);
            Report.AddColumn(17,440).Font.Size := 8;
            Report.AddColumn(18,480);
            Report.AddColumn(19,480).Font.Size := 8;
            Report.AddColumn(20,520);
            Report.AddColumn(21,520).Font.Size := 8;
            Report.AddColumn(22,560);
            Report.AddColumn(23,560).Font.Size := 8;
            Report.AddColumn(24,600);
            Report.AddColumn(25,600).Font.Size := 8;
            Report.AddColumn(26,640);
            Report.AddColumn(27,640).Font.Size := 8;
            Report.AddColumn(28,690);
            Report.AddColumn(29,690).Font.Size := 8;

            *)
         End;

         if ReportType = rpVatReport then begin
            Report.SetHeading('Vat Report');
            Report.ReportDate.caption := 'Report Date: ' + NominalReportForm.VatRepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            AssignFile(inFile, 'c:\kingsacc\reports\noname.rpt');
            AssignFile(outFile, 'c:\kingsacc\reports\vat1.rpt');
            Reset(inFile);
            Rewrite(outFile);
            sIrish := False;
            i := 1;
            while (true) do begin
                readln(inFile, s);
//                if (s='') or (s=' ') then s := StringOfChar(' ', i);
                if Length(S) >= 17 then
                   if Copy(S, 1, 17) = 'SALES VAT SUMMARY' then
                      sIrish := true;
                if not sIrish and (i = 60) then break;
                if sIrish and (i=71) and nomrpt.NominalReportForm.VatAuditChecked.checked then begin

                   // new page
                   WriteLn(outFile, '----------------------------------------');
                   WriteLn(outFile, '                                 PAGE 3 ');
                   //WriteLn(outFile, '----------------------------------------');
                end;
                if sIrish and (i = 72) then break;
                writeln(outFile, s);
                inc(i);
             end;
            CloseFile(outFile);
            AssignFile(outFile, 'c:\kingsacc\reports\vat2.rpt');
            Rewrite(outFile);
            while not eof(inFile) do begin
                readln(inFile, s);
                if pos('Transaction',s) = 56 then RangeLabel:=copy(s,56,30);
                Reports.Report.RangeLabel.caption:=RangeLabel;
                writeln(outFile, s);
                if pos('PERIOD',s) > 0 then RangeLabel:=RangeLabel + ', Period: ' + copy(s,pos('PERIOD',s)+7,20);
            end;
            CloseFile(outFile);
            CloseFile(inFile);

            //tgm 17/10/01  the next few lines blank out noname.rpt
            AssignFile(outFile, 'c:\kingsacc\reports\noname.rpt');
            Rewrite(outFile);
            CloseFile(outFile);

            Report.ReplaceText('ngswood Computing Ltd.', '');


            if not sIrish then begin
               Report.AddLeftAlignedColumn(3);                       {1}
               Report.AddLeftAlignedColumn(65);
               Report.AddLeftAlignedColumn(66);
               Report.AddTextColumn(74);
               Report.AddRightAlignedColumn(79);                     {5}
               Report.AddLeftAlignedColumn(83);                      {6}

               Report.AddColumn(1,0);
               Report.AddColumn(2,400);
               Report.AddColumn(3,400);
               Report.AddColumn(4,500);
               Report.AddColumn(5,500);
               Report.AddColumn(6,600);
               i := 6;
            end else begin
               Report.AddLeftAlignedColumn(1);
               Report.AddTextColumn(14);
               Report.AddTextColumn(24);
               Report.AddTextColumn(40);
               Report.AddLeftAlignedColumn(4);
               Report.AddRightAlignedColumn(17);
               Report.AddRightAlignedColumn(33);
               Report.AddRightAlignedColumn(49);

               Report.AddColumn(1,0);
               Report.AddColumn(2,200);
               Report.AddColumn(3,400);
               Report.AddColumn(4,600);
               Report.AddColumn(5,50);
               Report.AddColumn(6,200);
               Report.AddColumn(7,400);
               Report.AddColumn(8,600);

               i := 8;
            end;

            Report.ProcessReport('c:\kingsacc\reports\vat1.rpt');
//            Reports.Report.KingswoodLbl.caption:= 'Kingswood Accounts For Windows ' +  VerNo;
//            Report.DisplayReport;
            Report.ForgetColumns;

           // Report.AddLeftAlignedColumn(1);                      {7}
            Report.AddAlphaColumn(1);
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(11);
            Report.AddLeftAlignedColumn(12);                     {10}
            Report.AddLeftAlignedColumn(22);
            Report.AddLeftAlignedColumn(23);
            Report.AddLeftAlignedColumn(52);
            Report.AddLeftAlignedColumn(62);
            Report.AddRightAlignedColumn(71);                    {15}
            Report.AddLeftAlignedColumn(72);
            Report.AddRightAlignedColumn(85);
            Report.AddLeftAlignedColumn(92);
            Report.AddLeftAlignedColumn(96);
            Report.AddLeftAlignedColumn(104);                     {20}
            Report.AddLeftAlignedColumn(109);                    {21}
            Report.AddLeftAlignedColumn(51);                     {22}
            Report.AddLeftAlignedColumn(56);
            Report.AddRightAlignedColumn(33);              // Totals at bottom of each vat code

            Report.AddColumn(1+i,0);
            Report.AddColumn(2+i,30);
            Report.AddColumn(3+i,60);
            Report.AddColumn(4+i,60);
            Report.AddColumn(5+i,120);
            Report.AddColumn(6+i,120);
            Report.AddColumn(7+i,280);
            Report.AddColumn(8+i,344);    //TGM AB 02/05/02 changed from 350 to align column on the report
            Report.AddColumn(9+i,390);
            Report.AddColumn(10+i,460);
            Report.AddColumn(11+i,460);
            Report.AddColumn(12+i,510);
            Report.AddColumn(13+i,510);
            Report.AddColumn(14+i,600);
            Report.AddColumn(15+i,600);
            Report.AddColumn(16+i,280);
            Report.AddColumn(17+i,300);
            Report.AddColumn(18+i,170);


            Report.ProcessReport('c:\kingsacc\reports\vat2.rpt');
//            Reports.Report.KingswoodLbl.caption:= 'Kingswood Accounts For Windows ' +  VerNo;
//            Report.DisplayReport;

         end;

         if ReportType = rpCustomerAccountListing then begin
            Report.SetHeading('Account Listing');
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);        {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(9);
            Report.AddLeftAlignedColumn(41);
            Report.AddRightAlignedColumn(51);       {5}
            Report.AddLeftAlignedColumn(53);
            Report.AddLeftAlignedColumn(84);
            Report.AddLeftAlignedColumn(110);

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,30);
            Report.AddColumn(3,50);
            Report.AddColumn(4,250);
            Report.AddColumn(5,300);                     {5}
            Report.AddColumn(6,370);
            Report.AddColumn(7,480);
            Report.AddColumn(8,605);

         end;

         if ReportType = rpCustomerAgeOfDebt then begin
            Report.SetHeading('Age Of Debt - Aged By ' + CustSuppListing.AgeByCombo.Text);
            Report.ReportDate.caption := 'Report Date: ' + CustSuppListing.RepDate.Text;
      //      Report.ReportDate.enabled:= true; Removed TGM AB
            Report.ReportDate.enabled:= false;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(9);
            Report.AddLeftAlignedColumn(40);
            Report.AddTextColumn(60);    // TGM AB  Report.AddLeftAlignedColumn(60);            {5}
            Report.AddRightAlignedColumn(67);
            Report.AddRightAlignedColumn(80);
            Report.Addtextcolumn(72); //TGM AB Report.AddLeftAlignedColumn(72);
            Report.Addtextcolumn(88); //TGM ABR eport.AddLeftAlignedColumn(88);
            Report.AddRightAlignedColumn(93);           {10}
            Report.Addtextcolumn(101); //TGM AB Report.AddLeftAlignedColumn(101);
            Report.AddRightAlignedColumn(106);
            Report.Addtextcolumn(114); //TGM AB Report.AddLeftAlignedColumn(114);
            Report.AddRightAlignedColumn(119);
            Report.Addtextcolumn(124); //TGM AB Report.AddLeftAlignedColumn(124);           {15}
            Report.AddRightAlignedColumn(132);          {16}
            Report.AddLeftAlignedColumn(7);

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,15);
            Report.AddColumn(3,30);
            Report.AddColumn(4,235);    // TGM AB Moved from 250 to tighten up report
            Report.AddColumn(5,365);    // TGM AB Was 330                 {5}
            Report.AddColumn(6,370);
            Report.AddColumn(7,440);
            Report.AddColumn(8,435);    // TGM AB Was 400
            Report.AddColumn(9,515);    // TGM AB Was 485
            Report.AddColumn(10,510);                     {10}
            Report.AddColumn(11,585);   // TGM AB Was 555
            Report.AddColumn(12,585);
            Report.AddColumn(13,655);   // TGM AB Was 625
            Report.AddColumn(14,655);
            Report.AddColumn(15,715);   // TGM AB Was 680                  {15}
            Report.AddColumn(16,725);                    {16}
            Report.AddColumn(17,30);
         end;


         if ReportType = rpCustomerInvoiceListing then begin
            Report.SetHeading('Invoice Listing');
            Report.ReportDate.caption := 'Report Date: ' + CustSuppInvListing.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(9);
            Report.AddLeftAlignedColumn(13);
            Report.AddRightAlignedColumn(31);            {5}
            Report.AddTextColumn (42);   //Report.AddLeftAlignedColumn(42);
            Report.AddRightAlignedColumn(48);
            Report.AddLeftAlignedColumn(53);
            Report.AddRightAlignedColumn(61);
            Report.AddLeftAlignedColumn(63);           {10}
            Report.AddLeftAlignedColumn(72);
            Report.AddLeftAlignedColumn(88);
            Report.AddRightAlignedColumn(91);
            Report.AddRightAlignedColumn(100);
            Report.AddRightAlignedColumn(110);           {15}
            Report.AddLeftAlignedColumn(116);          {16}

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,15);
            Report.AddColumn(3,50);
            Report.AddColumn(4,70);
            Report.AddColumn(5,170);                     {5}
            Report.AddColumn(6,260);   //230
            Report.AddColumn(7,265);
            Report.AddColumn(8,290);
            Report.AddColumn(9,335);
            Report.AddColumn(10,345);                     {10}
            Report.AddColumn(11,395);
            Report.AddColumn(12,485);
            Report.AddColumn(13,500);
            Report.AddColumn(14,550);
            Report.AddColumn(15,605);                    {15}
            Report.AddColumn(16,640);                    {16}
         end;

         if ReportType = rpCustomerPaymentListing then begin
            Report.SetHeading('Payment Listing');
            Report.ReportDate.caption := 'Report Date: ' + CustSuppInvListing.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(9);
            Report.AddLeftAlignedColumn(13);
            Report.AddRightAlignedColumn(31);            {5}
            Report.AddTextColumn (42);   //Report.AddLeftAlignedColumn(42);
            Report.AddRightAlignedColumn(48);
            Report.AddLeftAlignedColumn(53);
            Report.AddRightAlignedColumn(61);
            Report.AddLeftAlignedColumn(63);           {10}
            Report.AddLeftAlignedColumn(79);
            Report.AddRightAlignedColumn(82);
            Report.AddRightAlignedColumn(91);
            Report.AddRightAlignedColumn(101);
            Report.AddLeftAlignedColumn(107);           {15}

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,15);
            Report.AddColumn(3,50);
            Report.AddColumn(4,70);
            Report.AddColumn(5,170);                     {5}
            Report.AddColumn(6,260);
            Report.AddColumn(7,265);
            Report.AddColumn(8,290);
            Report.AddColumn(9,315);
            Report.AddColumn(10,345);                     {10}
            Report.AddColumn(11,435);
            Report.AddColumn(12,450);
            Report.AddColumn(13,500);
            Report.AddColumn(14,550);
            Report.AddColumn(15,605);                    {15}

         end;

         if ReportType = rpCustomerCreditNoteListing then begin
            Report.SetHeading('Credit Note Listing');
            Report.ReportDate.caption := 'Report Date: ' + CustSuppInvListing.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(9);
            Report.AddLeftAlignedColumn(13);
            Report.AddRightAlignedColumn(31);            {5}
            Report.AddTextColumn (42);   //Report.AddLeftAlignedColumn(42);
            Report.AddRightAlignedColumn(48);
            Report.AddLeftAlignedColumn(53);
            Report.AddRightAlignedColumn(61);
            Report.AddLeftAlignedColumn(63);           {10}
            Report.AddLeftAlignedColumn(72);
            Report.AddLeftAlignedColumn(88);
            Report.AddRightAlignedColumn(91);
            Report.AddRightAlignedColumn(100);
            Report.AddRightAlignedColumn(110);           {15}
            Report.AddLeftAlignedColumn(116);          {16}

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,15);
            Report.AddColumn(3,50);
            Report.AddColumn(4,70);
            Report.AddColumn(5,170);                     {5}
            Report.AddColumn(6,260);
            Report.AddColumn(7,265);
            Report.AddColumn(8,290);
            Report.AddColumn(9,335);
            Report.AddColumn(10,345);                     {10}
            Report.AddColumn(11,395);
            Report.AddColumn(12,485);
            Report.AddColumn(13,500);
            Report.AddColumn(14,550);
            Report.AddColumn(15,605);                    {15}
            Report.AddColumn(16,640);                    {16}
         end;

         if ReportType = rpCustomerTransactionSummary then begin
            Report.SetHeading('Transaction Summary');
            Report.ReportDate.caption := 'Report Date: ' + CustSuppInvListing.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddLeftAlignedColumn(19);
            Report.AddRightAlignedColumn(34);
            Report.AddRightAlignedColumn(43);
            Report.AddRightAlignedColumn(56);            {5}
            Report.AddLeftAlignedColumn(63);
            Report.AddRightAlignedColumn(80);            {7}

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,200);
            Report.AddColumn(3,300);
            Report.AddColumn(4,400);
            Report.AddColumn(5,500);                     {5}
            Report.AddColumn(6,600);
            Report.AddColumn(7,700);
         end;

         if ReportType = rpCustomerAnalysis then begin
            Report.SetHeading('Analysis Report');
            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(10);
            Report.AddRightAlignedColumn(39);
            Report.AddLeftAlignedColumn(40);
            Report.AddRightAlignedColumn(51);            {5}
            Report.AddLeftAlignedColumn(57);
            Report.AddRightAlignedColumn(62);
            Report.AddAlphaColumn(80);
            Report.AddRightAlignedColumn(76);             {9}
            Report.AddLeftAlignedColumn(68);
            Report.AddLeftAlignedColumn(28);

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,40);
            Report.AddColumn(3,60);
            Report.AddColumn(4,200);
            Report.AddColumn(5,270);
            Report.AddColumn(6,305);                     {5}
            Report.AddColumn(7,350);
            Report.AddColumn(8,375);
            Report.AddColumn(9,200);
            Report.AddColumn(10,550);
            Report.AddColumn(11,525);
            Report.AddColumn(12,180);
         end;

         if ReportType = rpStatements then begin
            Report.ReportDate.enabled:= false;
            Report.PrintDate.enabled:= false;
            Report.CurrReport:='Statement'; // initialise report
            If NewRepForm.CustRadio.checked then begin
                                                 Report.SetHeading('Sales Statement');
                                                 StatementType := 'S';
            end
            else begin
                 Report.SetHeading('Remittance Advice');
                 StatementType := 'P'
            end;
  //          Report.SetHeading('Sales Statement');

            Report.ReplaceText('S A L E', '');
            Report.ReplaceText(StringOfChar('=', 31), '');
            Report.ReplaceText(StringOfChar('=', 80), StringOfChar('—', 54));

            AccsDataModule.Statement.open;
            AccsDataModule.Statement.first;
            if AccsDataModule.Statement.Locate('StateType',StatementType,[]) = false then begin
                 Showmessage('You do not have a layout for this type of Statement. Please Use Statement Setup');
                 exit;
            end;

            if Accsdatamodule.statement['Showheader'] = false then begin
               Report.topline1.enabled := false;
               Report.topline2.enabled := false;
               Report.heading.enabled := false;
            end;

            if Accsdatamodule.statement['StatementFrom'] = true then begin
               Report.StatementFromLabel.enabled := true;
               try Report.StatementName.caption := Accsdatamodule.statement['Name'];
               except Report.StatementName.caption :='';
               end;
               Report.StatementName.enabled := true;
               try Report.StatementAddress1.caption := Accsdatamodule.statement['Address1'];
               except Report.StatementAddress1.caption :='';
               end;
               Report.StatementAddress1.enabled := true;
               try Report.StatementAddress2.caption := Accsdatamodule.statement['Address2'];
               except Report.StatementAddress2.caption :='';
               end;
               Report.StatementAddress2.enabled := true;
               try Report.StatementAddress3.caption := Accsdatamodule.statement['Address3'];
               except Report.StatementAddress3.caption :='';
               end;
               Report.StatementAddress3.enabled := true;
               try Report.StatementAddress4.caption := Accsdatamodule.statement['Address4'];
               except Report.StatementAddress4.caption :='';
               end;
               Report.StatementAddress4.enabled := true;
               try Report.StatementTelephone.caption := Accsdatamodule.statement['Telephone'];
               except Report.StatementTelephone.caption :='';
               end;
               Report.StatementTelephone.enabled := true;
            end;

            Report.LinesPerPage := 53;
            Report.PageHeader.Height := 137; // 27
            Report.BottomLine.enabled := false;
            Report.KingswoodLbl.enabled := false;
            Report.TimeLbl.enabled:=false;
     //       Report.PageLbl.enabled:=false;;
            Report.PageNumber.enabled := false;
            AssignFile(inFile, 'c:\kingsacc\reports\noname.rpt');
            AssignFile(outFile, 'c:\kingsacc\reports\statements.rpt');
            Reset(inFile);
            Rewrite(outFile);

            while not eof(inFile) do begin
                  // next line puts in the word PAGE so that reports knows it's in the header and leaves it out!
                  WriteLn(outFile, '--skipthisline');
                  WriteLn(outFile, '                                                   PAGE 324 ');
                  WriteLn(outFile, '--skipthisline');
                  repeat
                        ReadLn(inFile, s);
                        if pos('S T A T E M E N T', s) > 0 then tmp := StringOfChar(' ', 200);
                        if pos('================================', s) > 0 then tmp := '';
                        if (pos('EOFILE', s) = 0) then WriteLn(outFile, tmp + s);
                        //WriteLn(outFile, tmp + s);
                 // until (pos('90+ days:', s) <> 0) or eof(inFile);
                 until (pos('EOFILE', s) <> 0) or eof(inFile);
            end;

            CloseFile(outFile);
            CloseFile(inFile);
            ReWrite(inFile);
            CloseFile(inFile);

            Report.AddLeftAlignedColumn(206);                // To:
            Report.AddColumn(1,40);
            Report.AddLeftAlignedColumn(210);                // Underscore
            Report.AddColumn(2,60);
            Report.AddLeftAlignedColumn(212);                // S A L E  S T A T E M E N T
            Report.AddColumn(3,70);
            Report.AddLeftAlignedColumn(211);                // Address Lines
            Report.AddColumn(4,65).Font.style := [fsBold];
 //           Report.AddColumn(4,65);
            Report.AddLeftAlignedColumn(246);                // Date
            Report.AddColumn(5,400).Font.Style := [fsBold];
            Report.AddLeftAlignedColumn(1);                  // Transaction Date
            Report.AddColumn(6,0);
            Report.AddLeftAlignedColumn(10);                 // Transaction Type
            Report.AddColumn(7,50);
            Report.AddLeftAlignedColumn(15);                 // Transaction Reference
            Report.AddColumn(8,90);
            Report.AddLeftAlignedColumn(26);                       // Description
            Report.AddColumn(9,145);
            Report.AddRightAlignedColumn(54);                // Debit Column
            Report.AddColumn(10,445);
            Report.AddRightAlignedColumn(66);                // Credit Column
            Report.AddColumn(11,525);
            Report.AddRightAlignedColumn(78);                // Balance Column
            Report.AddColumn(12,650);
        //    Report.AddLeftAlignedColumn(62);                 // Credit Label
        //    Report.AddColumn(14,525);
        //    Report.AddLeftAlignedColumn(74);                 // Balance Label
        //    Report.AddColumn(15,650);
            Report.AddLeftAlignedColumn(2);                  // Current/30/60/90 Days
            Report.AddColumn(13,50);
            Report.AddRightAlignedColumn(25);                // age of debt values
            Report.AddColumn(14,200);
            Report.AddLeftAlignedColumn(37);                 // Balance Outstanding
            Report.AddColumn(15,400);
            Report.AddLeftAlignedColumn(3);                 // Account No label/ Bottom
            Report.AddColumn(16,20);
            case custsupplisting.AgeByCombo.itemindex of
                 1: begin
                    report.ReplaceText('Current:', '0-1 Months:');
                    report.ReplaceText('30+ days:', '2-3 Months:');
                    report.ReplaceText('60+ days:', '4-5 Months:');
                    report.ReplaceText('90+ days:', '6+ Months:');
                  end;
                 2: begin
                    report.ReplaceText('Current:', '0-2 Months:');
                    report.ReplaceText('30+ days:', '3-5 Months:');
                    report.ReplaceText('60+ days:', '6-8 Months:');
                    report.ReplaceText('90+ days:', '9+ Months:');
                  end;
                 3: begin
                    report.ReplaceText('Current:', '0-5 Months:');
                    report.ReplaceText('30+ days:', '6-11 Months:');
                    report.ReplaceText('60+ days:', '12-17 Months:');
                    report.ReplaceText('90+ days:', '18+ Months:');
                  end;
                 4: begin
                    report.ReplaceText('Current:', '0-8 Months:');
                    report.ReplaceText('30+ days:', '9-17 Months:');
                    report.ReplaceText('60+ days:', '18-26 Months:');
                    report.ReplaceText('90+ days:', '27+ Months:');
                  end;
                 5: begin
                    report.ReplaceText('Current:', '0-11 Months:');
                    report.ReplaceText('30+ days:', '12-23 Months:');
                    report.ReplaceText('60+ days:', '24-35 Months:');
                    report.ReplaceText('90+ days:', '36+ Months:');
                  end;
            end;
            Report.ProcessReport('c:\kingsacc\reports\statements.rpt');

//           Report.AddColumn(1,40);                       {1}
//            Report.AddColumn(2,60);
//            Report.AddColumn(3,70);
//            Report.AddColumn(4,500);
//            Report.AddColumn(5,500);                     {5}
//            Report.AddColumn(6,550);
//            Report.AddColumn(6,0);
//            Report.AddColumn(7,50);
//            Report.AddColumn(8,90);
//            Report.AddColumn(10,90);                       {10}
//            Report.AddColumn(10,145); //170
//            Report.AddColumn(11,445);
//            Report.AddColumn(13,525);
//            Report.AddColumn(12,525);
//            Report.AddColumn(15,650);                   {15}
//            Report.AddColumn(13,650);
//            Report.AddColumn(14,100);
//            Report.AddColumn(15,100);
//            Report.AddColumn(16,300);
//            Report.AddColumn(17,400);                     {20}
//
{            Report.AddLeftAlignedColumn(1);
            Report.AddLeftAlignedColumn(2);
            Report.AddLeftAlignedColumn(10);
            Report.AddLeftAlignedColumn(24);
            Report.AddRightAlignedColumn(54);
            Report.AddRightAlignedColumn(66);
            Report.AddLeftAlignedColumn(63);
            Report.AddRightAlignedColumn(78);

            Report.AddColumn(1,10);
            Report.AddColumn(2,70);
            Report.AddColumn(3,150);
            Report.AddColumn(3,250);
            Report.AddColumn(5,350);
            Report.AddColumn(6,450);
            Report.AddColumn(7,550);
            Report.AddColumn(8,650);}

         end;

         if ReportType = rpLedgerCards then begin
            If NewRepForm.CustRadio.checked then Report.SetHeading('Customer Ledger Card')
            else Report.SetHeading('Supplier Ledger Card');
            Report.ReportDate.caption := 'Report Date: ' + StatementForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            PutAccountNumbersAtTheTopOfThePage;
            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddTextColumn(10); // TGM AB Report.AddLeftAlignedColumn(10);
            Report.AddRightAlignedColumn(14);
            Report.AddLeftAlignedColumn(16);
            Report.AddLeftAlignedColumn(20);            {5}
            Report.AddAlphaColumn(29);
            Report.AddTextColumn(49);
            Report.AddRightAlignedColumn(53);
            Report.AddTextColumn(60);
            Report.AddRightAlignedColumn(65);             {10}
            Report.AddTextColumn(69);
            Report.AddRightAlignedColumn(77);
            Report.AddLeftAlignedColumn(350);
            Report.AddLeftAlignedColumn(364);             {14}


            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,125);   // was 55
            Report.AddColumn(3,85);
            Report.AddColumn(4,100);
            Report.AddColumn(5,180);                     {5}
            Report.AddColumn(6,225);
            Report.AddColumn(7,350);
            Report.AddColumn(8,350);
            Report.AddColumn(9,450);
            Report.AddColumn(10,450);                       {10}
            Report.AddColumn(11,600);
            Report.AddColumn(12,600);                       {12}
            Report.AddColumn(13,300);
            Report.AddColumn(14,450);
            Report.Currreport:='LedgerCards';
            Report.ProcessReport('c:\kingsacc\reports\report.rpt');

         end;

            // TGM AB 07/05/02 - This type is OK
         if (ReportType = rpRecordCards) and not (StatementForm.PerUnit.Checked) then begin  //TGM AB 07/05/02 orStatementForm.InvoiceSubTotal.Checked
            If NewRepForm.CustRadio.checked then Report.SetHeading('Customer Record Card')
            else Report.SetHeading('Supplier Record Card');
            Report.ReportDate.caption := 'Report Date: ' + StatementForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            PutAccountNumbersAtTheTopOfThePage;
            Report.AddLeftAlignedColumn(1);               {1}
            Report.AddTextColumn(6);
            Report.AddRightAlignedColumn(14);
            Report.AddLeftAlignedColumn(16);
            Report.AddTextColumn(32);                     {5}
            Report.AddRightAlignedColumn(34);
            Report.AddTextColumn(37);
            Report.AddRightAlignedColumn(44);
            Report.AddTextColumn(50);
            Report.AddRightAlignedColumn(55);             {10}
            Report.AddTextColumn(64);
            Report.AddRightAlignedColumn(66);
            Report.AddTextColumn(73);
            Report.AddRightAlignedColumn(77);             {14}
            Report.AddLeftAlignedColumn(350);             {15}
            Report.AddLeftAlignedColumn(364);             {16}
            if statementform.TotalSelected.Checked = true then begin
                Report.AddLeftAlignedColumn(201);
                Report.AddLeftAlignedColumn(207);
                Report.AddRightAlignedColumn(232);
                Report.AddTextColumn(237);
                Report.AddRightAlignedColumn(244);
                Report.AddRightAlignedColumn(254);
                Report.AddTextColumn(250);
                Report.AddRightAlignedColumn(266);
                Report.AddTextColumn(273);
                Report.AddRightAlignedColumn(278);
            end;

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,100);
            Report.AddColumn(3,125);
            Report.AddColumn(4,145);
            Report.AddColumn(5,255);                     {5}
            Report.AddColumn(6,260);
            Report.AddColumn(7,400);
            Report.AddColumn(8,400);
            Report.AddColumn(9,500);
            Report.AddColumn(10,500);                       {10}
            Report.AddColumn(11,600);
            Report.AddColumn(12,600);
            Report.AddColumn(13,700);
            Report.AddColumn(14,700);                     {14}
            Report.Currreport:='RecordCards';
            Report.AddColumn(15,300);
            Report.AddColumn(16,400);

            if statementform.TotalSelected.Checked = true then begin
                Report.AddColumn(17,0);
                Report.AddColumn(18,50);
                Report.AddColumn(19,250);
                Report.AddColumn(20,355);
                Report.AddColumn(21,355);
                Report.AddColumn(22,450);
                Report.AddColumn(23,450);
                Report.AddColumn(24,550);
                Report.AddColumn(25,645);
                Report.AddColumn(26,645);
            end;


            Report.ProcessReport('c:\kingsacc\reports\report.rpt');
         end;

         if (ReportType = rpRecordCards) and  (StatementForm.PerUnit.Checked) then begin   // TGM AB 07/05/02 or StatementForm.InvoiceSubTotal.Checked
            If NewRepForm.CustRadio.checked then Report.SetHeading('Customer Record Card')
            else Report.SetHeading('Supplier Record Card');
            Report.ReportDate.caption := 'Report Date: ' + StatementForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            PutAccountNumbersAtTheTopOfThePage;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddLeftAlignedColumn(10);
            Report.AddRightAlignedColumn(14);
            Report.AddLeftAlignedColumn(20);
            Report.AddLeftAlignedColumn(16);            {5}

            Report.AddTextColumn(27);       // TGM AB 07/05/02
            Report.AddRightAlignedColumn(29);     // TGM AB 07/05/02

            Report.AddRightAlignedColumn(37);
            Report.AddTextColumn(42);
            Report.AddRightAlignedColumn(47);
            Report.AddRightAlignedColumn(58);
            Report.AddTextColumn(65);             {10}
            Report.AddRightAlignedColumn(68);
            Report.AddTextColumn(73);
            Report.AddRightAlignedColumn(77);           {13}
            Report.AddLeftAlignedColumn(350);
            Report.AddLeftAlignedColumn(364);
            if statementform.TotalSelected.Checked = true then begin
                Report.AddLeftAlignedColumn(201);
                Report.AddLeftAlignedColumn(207);
                Report.AddRightAlignedColumn(232);
                Report.AddTextColumn(237);
                Report.AddRightAlignedColumn(244);
                Report.AddRightAlignedColumn(254);
                Report.AddTextColumn(250);
                Report.AddRightAlignedColumn(266);
                Report.AddTextColumn(273);
                Report.AddRightAlignedColumn(278);
            end;


            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,55);
            Report.AddColumn(3,70);
            Report.AddColumn(4,120);
            Report.AddColumn(5,85);                     {5}
            Report.AddColumn(6,190);
            Report.AddColumn(7,190);
            Report.AddColumn(8,250);
            Report.AddColumn(9,350);
            Report.AddColumn(10,350);
            Report.AddColumn(11,450);
            Report.AddColumn(12,500);                       {10}
            Report.AddColumn(13,510);
            Report.AddColumn(14,600);
            Report.AddColumn(15,600);                   {13}
            Report.AddColumn(16,300);
            Report.AddColumn(17,400);

             if statementform.TotalSelected.Checked = true then begin
                Report.AddColumn(18,0);
                Report.AddColumn(19,50);
                Report.AddColumn(20,250);
                Report.AddColumn(21,355);
                Report.AddColumn(22,355);
                Report.AddColumn(23,450);
                Report.AddColumn(24,450);
                Report.AddColumn(25,550);
                Report.AddColumn(26,645);
                Report.AddColumn(27,645);
            end;

            Report.ReplaceText('QUAN', 'Qty');
            Report.ProcessReport('c:\kingsacc\reports\report.rpt');
         end;

         if ReportType = rpInvoiceSummary then begin
            If NewRepForm.CustRadio.checked then Report.SetHeading('Customer Invoice Summary')
            else Report.SetHeading('Supplier Invoice Summary');
            If Stat.StatementForm.PrePrintedStationary.Checked then report.coverpanel.enabled := true;  //Report.PageHeader.Height := 0;
            Report.ReportDate.caption := 'Report Date: ' + StatementForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

          //  PutAccountNumbersAtTheTopOfThePage;
             Report.LinesPerPage:=56;      //56
             PositionInvoiceSummary(56);   //56    // 56 specifies the number of lines per page = Report.linesperpage
            //Report.ReplaceText('TALS', 'Totals');


               fileno := 1;
               Report.AddLeftAlignedColumn(1);
               Report.AddColumn(fileno,0);
               fileno := fileno +1;
               Report.AddLeftAlignedColumn(10);
               Report.AddColumn(fileno,55);
               fileno := fileno +1;
               If Stat.StatementForm.ShowEuroTotals.checked = true then Report.AddTextColumn(30)
               else Report.AddTextColumn(30);         // 53
               Report.AddColumn(fileno,275);
               fileno := fileno +1;
        //       Report.AddRightAlignedColumn(39);
        //       Report.AddColumn(fileno,275);
        //       fileno := fileno +1;
               Report.AddRightAlignedColumn(40);
               Report.AddColumn(fileno,275);
               fileno := fileno +1;
               Report.AddLeftAlignedColumn(41);
               Report.AddColumn(fileno,325);
               fileno := fileno +1;
               Report.AddRightAlignedColumn(46);
               Report.AddColumn(fileno,350);
               fileno := fileno +1;
               If Stat.StatementForm.ShowEuroTotals.checked = true then Report.AddTextColumn(43)
               else Report.AddTextColumn(52);
               Report.AddColumn(fileno,425);
               fileno := fileno +1;
               Report.AddRightAlignedColumn(57);
               Report.AddColumn(fileno,425);
               fileno := fileno +1;
               If Stat.StatementForm.ShowEuroTotals.checked = true then Report.AddTextColumn(54)
               else Report.AddTextColumn(64);
               Report.AddColumn(fileno,500);
               fileno := fileno +1;
               Report.AddRightAlignedColumn(67);
               Report.AddColumn(fileno,500);
               fileno := fileno +1;
               If Stat.StatementForm.ShowEuroTotals.checked = true then Report.AddTextColumn(61)
               else Report.AddTextColumn(71);
               Report.AddColumn(fileno,600);
               fileno := fileno +1;
               Report.AddTextColumn(72);
               Report.AddColumn(fileno,600);
               fileno := fileno +1;
               Report.AddRightAlignedColumn(77);
               Report.AddColumn(fileno,625);
               fileno := fileno +1;
       //        Report.AddTextColumn(68);
               Report.AddLeftAlignedColumn(241);
               Report.AddColumn(fileno,50);
               fileno := fileno +1;
               Report.AddLeftAlignedColumn(254);
               Report.AddColumn(fileno,150);
               fileno := fileno +1;
               Report.AddLeftAlignedColumn(14);
               Report.AddColumn(fileno,150);
               fileno := fileno +1;


  (*

            // Duncans Code
            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddLeftAlignedColumn(10);
            If Stat.StatementForm.ShowEuroTotals.checked = true then //( Cash2.xCountry = 2 ) then
               Report.AddTextColumn(30) else
               Report.AddTextColumn(35);
            Report.AddRightAlignedColumn(39);
            Report.AddLeftAlignedColumn(40);            {5}
            Report.AddRightAlignedColumn(46);
            If Stat.StatementForm.ShowEuroTotals.checked = true then //( Cash2.xCountry = 2 ) then
               Report.AddTextColumn(43) else
               Report.AddTextColumn(52);
            Report.AddRightAlignedColumn(57);
            If Stat.StatementForm.ShowEuroTotals.checked = true then //( Cash2.xCountry = 2 ) then
               Report.AddTextColumn(54) else
               Report.AddTextColumn(64);
            Report.AddRightAlignedColumn(67);             {10}
            If Stat.StatementForm.ShowEuroTotals.checked = true then //( Cash2.xCountry = 2 ) then
               Report.AddTextColumn(61) else
               Report.AddTextColumn(71);
            Report.AddRightAlignedColumn(77);             {12}
            Report.AddTextColumn(68);             {13}
            Report.AddLeftAlignedColumn(334);             {14}
//            Report.AddLeftAlignedColumn(68);


            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,55);
            Report.AddColumn(3,275);
            Report.AddColumn(4,275);
            Report.AddColumn(5,325);                     {5}
            Report.AddColumn(6,350);
            Report.AddColumn(7,425);
            Report.AddColumn(8,425);
            Report.AddColumn(9,500);
            Report.AddColumn(10,500);                       {10}
            Report.AddColumn(11,575);
            Report.AddColumn(12,575);                       {12}
            Report.AddColumn(13,650);
            Report.AddColumn(14,350);

          end; //else
          *)
            Report.CurrReport:='InvoiceSummary';
//            Report.AddColumn(15,600);
            Report.ProcessReport('c:\kingsacc\reports\report.rpt');
         end;

         if ReportType =  rpSetupBudget then begin
            Report.SetHeading('Budget and Balance Report');
            Report.ReportDate.caption := 'Report Date: ' + CashFlowReportsForm.RepDate.text; //SetupBudgetReportsForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(33);
            Report.AddRightAlignedColumn(41);
            Report.AddRightAlignedColumn(49);
            Report.AddRightAlignedColumn(57);            {5}
            Report.AddRightAlignedColumn(73);
            Report.AddRightAlignedColumn(65);
            Report.AddRightAlignedColumn(81);
            Report.AddRightAlignedColumn(89);
            Report.AddRightAlignedColumn(97);            {10}
            Report.AddRightAlignedColumn(105);
            Report.AddRightAlignedColumn(113);
            Report.AddRightAlignedColumn(121);
            Report.AddRightAlignedColumn(131);             {14}


            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,200).Font.Size := 8;
            Report.AddColumn(3,240).Font.Size := 8;
            Report.AddColumn(4,280).Font.Size := 8;
            Report.AddColumn(5,320).Font.Size := 8;                     {5}
            Report.AddColumn(6,360).Font.Size := 8;
            Report.AddColumn(7,400).Font.Size := 8;
            Report.AddColumn(8,440).Font.Size := 8;
            Report.AddColumn(9,480).Font.Size := 8;
            Report.AddColumn(10,520).Font.Size := 8;                       {10}
            Report.AddColumn(11,560).Font.Size := 8;
            Report.AddColumn(12,600).Font.Size := 8;                       {12}
            Report.AddColumn(13,640).Font.Size := 8;
            Report.AddColumn(14,700).Font.Size := 8;

         end;

         if ReportType =  rpSetupNominal then begin
            Report.SetHeading('Print Nominal Accounts');
            Report.ReportDate.caption := 'Report Date: ' + NominalReportForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddRightAlignedColumn(4);
            Report.AddLeftAlignedColumn(17);
            Report.AddLeftAlignedColumn(30);
            Report.AddLeftAlignedColumn(50);            {5}
            Report.AddLeftAlignedColumn(55);
            Report.AddLeftAlignedColumn(80);                    // TGM AB 29/09/17 - added new column


            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,40);
            Report.AddColumn(3,60);
            Report.AddColumn(4,300);
            Report.AddColumn(5,300);
            Report.AddColumn(6,525);                     {6}    // TGM AB 29/09/17 was 400
            Report.AddColumn(7,330);                            // TGM AB 29/09/17 - added new column

         end;

         if ReportType =  rpSetupEnterprise then begin
            Report.SetHeading('Enterprise Accounts');
            Report.ReportDate.caption := 'Report Date: ' + StatementForm.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);            {1}
            Report.AddTextColumn(5);
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(10);

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,80);
            Report.AddColumn(3,40);
            Report.AddColumn(4,100);                    {4}

         end;

         if ReportType =  rpSetupCustomer then begin
            Report.SetHeading('Customer/Supplier Accounts');
            Report.ReportDate.caption := 'Report Date: ' + CustSuppListing.RepDate.Text;
            Report.ReportDate.enabled:= true;
            Report.PrintDate.enabled:= true;

            Report.AddLeftAlignedColumn(1);        {1}
            Report.AddRightAlignedColumn(6);
            Report.AddLeftAlignedColumn(9);
            Report.AddLeftAlignedColumn(41);
            Report.AddRightAlignedColumn(51);       {5}
            Report.AddLeftAlignedColumn(53);
            Report.AddLeftAlignedColumn(84);
            Report.AddLeftAlignedColumn(110);

            Report.AddColumn(1,0);                       {1}
            Report.AddColumn(2,30);
            Report.AddColumn(3,50);
            Report.AddColumn(4,250);
            Report.AddColumn(5,300);                     {5}
            Report.AddColumn(6,370);
            Report.AddColumn(7,480);
            Report.AddColumn(8,605);

         end;

         Report.ReplaceText('NOMINALENT REPORTS-5', 'Nominal');
         Report.ProcessReport('c:\KingsAcc\Reports\NoName.Rpt');
         Reports.Report.KingswoodLbl.caption:= 'Kingswood Accounts ' +  VerNo;
         if ExportToCSV then begin
            ExportToCSV := false;
            csvexport.CSVExportForm.runexport;
         end
            else if not NoPreview then Report.DisplayReport;           //Ch025

end;

end.
