unit uTrialBalanceReport;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls, Dialogs;

type
  TTrialBalanceReport = class(TQuickRep)
    DetailBand1: TQRBand;
    PageFooterBand1: TQRBand;
    QRDBText9: TQRDBText;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    PageHeaderBand1: TQRBand;
    BottomLine: TQRShape;
    Dataset: TQRLabel;
    Company: TQRLabel;
    TopLine1: TQRShape;
    Heading: TQRLabel;
    ReportDateLbl: TQRLabel;
    ReportDate: TQRLabel;
    PrintDateLbl: TQRLabel;
    TimeLbl: TQRSysData;
    KingswoodLbl: TQRLabel;
    PageNumber: TQRSysData;
    TopLine2: TQRShape;
    ColumnHeaderBand1: TQRBand;
    AccountTypeLabel: TQRLabel;
    QRShape1: TQRShape;
    Column1Db: TQRDBText;
    Column1Cr: TQRDBText;
    Column1DbLabel: TQRLabel;
    Column1CrLabel: TQRLabel;
    Column1Label: TQRLabel;
    Column3Cr: TQRDBText;
    Column3Db: TQRDBText;
    Column3CrLabel: TQRLabel;
    Column3DbLabel: TQRLabel;
    Column3Label: TQRLabel;
    Column2Db: TQRDBText;
    Column2Cr: TQRDBText;
    Column2DbLabel: TQRLabel;
    Column2CrLabel: TQRLabel;
    Column2Label: TQRLabel;
    RangeLabel: TQRLabel;
    KingsAccFooter: TQRLabel;
  private

  public
      procedure RunReport(PreviewReport : Boolean);
      procedure ReportByAccount;
      procedure ReportByGroup;
  end;

  type ReportTotals = record
                     Curr_Db : real;
                     Curr_Cr : real;
                     Open_Db : real;
                     Open_Cr : real;
                     Move_Db : real;
                     Move_Cr : real;
                     Close_Db : real;
                     Close_Cr : real;
                  end;

var
  TrialBalanceReport: TTrialBalanceReport;
  UseGroups, ShowExtended, ShowYearMovement, MonthReport, Filtered, SingleMonth, SpanMonthReport, SpanYearMonthReport : Boolean;
  AccFrom, AccTo, ReportMonth, MonthFrom, MonthTo : Integer;
  TotalsArray:array[1..10] of ReportTotals;
  BalanceMonths:array[1..12] of boolean;   // Months included in opening Balance
  ReportMonths:array[1..12] of boolean;    // Months included in the report
  LastYearReportMonths:array[1..12] of boolean;    // Last Years Months included in the report

implementation

uses AccsData, Vars, Params, Types, Nomrpt, DBCore, Calcs, Clears, CalculateMonths;

{$R *.DFM}

procedure TTrialBalanceReport.RunReport(PreviewReport : Boolean);               // Ch025
var
    i : integer;

begin
     UseGroups := False;
     ShowExtended := False;
     ShowYearMovement := False;
     MonthReport := False; // Month only report
     ReportMonth := 0;
     Filtered := False;

     SingleMonth := False;  // TGM AB 09/01/15
     SpanMonthReport := False;   // TGM AB 09/01/15
     SpanYearMonthReport := False;   // TGM AB 09/01/15


     Accsdatamodule.TrialBalanceReportDB.close;
     if FileExists  (Accsdatamodule.AccsDataBase.Directory + 'TrialBalanceReportTable.db' ) then begin
         try DeleteFile  (Accsdatamodule.AccsDataBase.Directory + 'TrialBalanceReportTable.db' );
         except showmessage('Error Deleting Trial Balance Report Table!');
         end;
     end;

     try Accsdatamodule.CreateTrialBalanceReportTable;
     except showmessage('Error Creating Trial Balance Report Table!');
     end;

     Accsdatamodule.TrialBalanceReportDB.open;

     // Gather Report Parameters

     if NominalReportForm.rgAccountGroup.ItemIndex = 0 then UseGroups := False
        else UseGroups := True;

     if NominalReportForm.Extended.checked then ShowExtended := True;
     if NominalReportForm.ShowYearMonth.checked then ShowYearMovement := True;

     if ((ShowExtended) and not (ShowYearMovement)) then begin
                MonthReport := True;
                if NominalReportForm.MonthTypeSelectRG.CheckedIndex = 0 then SingleMonth := True;
                if NominalReportForm.MonthTypeSelectRG.CheckedIndex = 1 then SpanMonthReport := True;
                if NominalReportForm.MonthTypeSelectRG.CheckedIndex = 2 then SpanYearMonthReport := True;
     end;

     if MonthReport then begin
              CalculateMonths.CalculateMonthlyValues;
              Calculatemonths.UpdateNLMonthlyFigures;
     end;

     If UseGroups then begin
                        AccsDatamodule.NLGroupsDB.open;
                        AccFrom := 1;
                        AccTo := AccsDatamodule.NLGroupsDB.RecordCount;

     end else begin
                        Setdb ( NlFile );
                        AccFrom := 1;
                        AccTo := db1.dbrechigh;
              end;

     if ((NominalReportForm.AccFrom.Text <> '') or (NominalReportForm.AccTo.Text <> '')) then filtered := True;

     if NominalReportForm.AccFrom.Text <> '' then AccFrom := StrToInt(NominalReportForm.AccFrom.Text);
     if NominalReportForm.AccTo.Text <> '' then AccTo := StrToInt(NominalReportForm.AccTo.Text);
     if NominalReportForm.CalMonth.Text <> '' then ReportMonth := StrToInt(NominalReportForm.CalMonth.Text);
     if NominalReportForm.MonthFrom.Text <> '' then MonthFrom := StrToInt(NominalReportForm.MonthFrom.Text);
     if NominalReportForm.MonthTo.Text <> '' then MonthTo := StrToInt(NominalReportForm.MonthTo.Text);

     // Setup months array with the month included in starting balance figure

     For i := 1 to 12 do begin
         BalanceMonths[i] := false;
     end;

     // Setup months array with the months included in the report

     For i := 1 to 12 do begin
         ReportMonths[i] := false;
     end;

     // Setup months array with the months last year included in the report

     For i := 1 to 12 do begin
         LastYearReportMonths[i] := false;
     end;

     if Monthreport then begin

        if SingleMonth then begin
                if ReportMonth <> Cash1.XFINMONTH then begin // if = then first month of year and no months included in opening balance
                        i := Cash1.XFINMONTH;
                        While i <> ReportMonth do begin
                        BalanceMonths[i] := true;
                        i := i + 1;
                        if i > 12 then i := i - 12;
                        end;
                end;
        end; //single month
        if SpanMonthReport then begin
                if MonthFrom <> Cash1.XFINMONTH then begin // if = then first month of year and no months included in opening balance
                        i := Cash1.XFINMONTH;
                        While i <> MonthFrom do begin
                        BalanceMonths[i] := true;
                        i := i + 1;
                        if i > 12 then i := i - 12;
                        end;
                end;

                i := MonthFrom;
                While i <> MonthTo do begin
                        ReportMonths[i] := true;
                        i := i + 1;
                        if i > 12 then i := i - 12;

                        if i = MonthTo then ReportMonths[i] := true;
                end;

        end;

        if SpanYearMonthReport then begin
                if MonthTo <> Cash1.XFINMONTH then begin // if = then first month of year and no months included in opening balance
                        i := Cash1.XFINMONTH;
                        While i <> MonthTo do begin
                        ReportMonths[i] := true;
                        i := i + 1;
                        if i > 12 then i := i - 12;
                        if i = MonthTo then ReportMonths[i] := true;
                        end;
                end else begin
                             ReportMonths[MonthTo] := true;
                         end;

                i := MonthFrom;
                LastYearReportMonths[i] := true;
                While i <> Cash1.XFINMONTH do begin
                        LastYearReportMonths[i] := true;
                        i := i + 1;
                        if i > 12 then i := i - 12;
                end;

        end;
     end;



     if UseGroups then ReportByGroup
        else ReportByAccount;

     // Fill out range label

     Rangelabel.caption := '';
     if NominalReportForm.AccFrom.Text <> '' then begin
              if UseGroups then Rangelabel.caption := 'Filter = Groups : ' + NominalReportForm.AccFrom.Text + ' to ' + NominalReportForm.AccTo.Text
                 else Rangelabel.caption := 'Filter = Accounts : ' + NominalReportForm.AccFrom.Text + ' to ' + NominalReportForm.AccTo.Text;
     end;

     If SingleMonth then begin
        If length(Rangelabel.caption) > 0 then Rangelabel.caption := Rangelabel.caption + ' , ' else Rangelabel.caption := 'Filter = ';
        Rangelabel.caption := Rangelabel.caption + 'Month - ' + NominalReportForm.CalMonth.Text;
     end;

     If SpanMonthReport then begin
        If length(Rangelabel.caption) > 0 then Rangelabel.caption := Rangelabel.caption + ' , ' else Rangelabel.caption := 'Filter = ';
        Rangelabel.caption := Rangelabel.caption + 'Month Range ' + NominalReportForm.MonthFrom.Text + ' to ' + NominalReportForm.MonthTo.Text;
     end;

     If SpanYearMonthReport then begin
        If length(Rangelabel.caption) > 0 then Rangelabel.caption := Rangelabel.caption + ' , ' else Rangelabel.caption := 'Filter = ';
        Rangelabel.caption := Rangelabel.caption + 'Month Range (Year Span) ' + NominalReportForm.MonthFrom.Text + ' to ' + NominalReportForm.MonthTo.Text;
     end;


     ReportDate.Caption := Cash11.DEFAULT_DATE;
     KingswoodLbl.caption := 'Kingswood Accounts ' + VerNo;
     Company.Caption := cash1.XCOMPANY;
     dataset.caption := RFarmGate.PLocation[2];
     If UseGroups then Heading.caption := 'Trial Balance - By Report Group'
        else Heading.caption := 'Trial Balance - By Account Number';

     if PreviewReport then Preview;

end;

procedure TTrialBalanceReport.ReportByAccount;
var
    LineCount, i, Tot, RecordCount, r : integer;
    OKToInclude : boolean;
    OpeningBal, CurrBal, ClosingBal, YearMove, RunningDb, RunningCr, TempBal : real;
    TempStr, RunningDbStr,RunningCrStr : Shortstring;

begin

    Linecount := 0;      // Report length = 55
    RecordCount := 0;
    Tot := 0;
    RunningDb := 0;
    RunningCr := 0;

    OpeningBal := 0;
    ClosingBal := 0;
    CurrBal := 0;
    YearMove := 0;

    for r := 1 to 10 do begin
        TotalsArray[r].Curr_Db := 0.00;
        TotalsArray[r].Curr_Cr := 0.00;
        TotalsArray[r].Open_Db := 0.00;
        TotalsArray[r].Open_Cr := 0.00;
        TotalsArray[r].Move_Db := 0.00;
        TotalsArray[r].Move_Cr := 0.00;
        TotalsArray[r].Close_Db := 0.00;
        TotalsArray[r].Close_Cr := 0.00;
    end;


    AccountTypeLabel.Caption := 'Account Number';

    Column1Label.enabled := true;
    Column1CrLabel.enabled := true;
    Column1DbLabel.enabled := true;
    Column1Cr.enabled := true;
    Column1Db.enabled := true;
    Column1Label.Caption := 'Current Balance';
    Column1Db.DataField := 'Curr_Db';
    Column1Cr.DataField := 'Curr_Cr';

    if ShowExtended then begin

         Column2Label.enabled := true;
         Column2CrLabel.enabled := true;
         Column2DbLabel.enabled := true;
         Column2Cr.enabled := true;
         Column2Db.enabled := true;

         Column3Label.enabled := true;
         Column3CrLabel.enabled := true;
         Column3DbLabel.enabled := true;
         Column3Cr.enabled := true;
         Column3Db.enabled := true;

         if ShowYearMovement then begin

              Column1Label.Caption := 'Opening Balance';
              Column1Db.DataField := 'Open_Db';
              Column1Cr.DataField := 'Open_Cr';

         end;

         If MonthReport then begin

              if SingleMonth then Column2Label.Caption := 'Month Movement'
                else Column2Label.Caption := 'Period Movement';

              Column1Label.Caption := 'Opening Balance';
              Column1Db.DataField := 'Open_Db';
              Column1Cr.DataField := 'Open_Cr';

              if SpanYearMonthReport then begin

                  Column1Label.Caption := 'Total Movement';
                  Column1Db.DataField := 'Curr_Db';
                  Column1Cr.DataField := 'Curr_Cr';

                  Column2Label.enabled := False;
                  Column2CrLabel.enabled := False;
                  Column2DbLabel.enabled := False;
                  Column2Cr.enabled := False;
                  Column2Db.enabled := False;

                  Column3Label.enabled := False;
                  Column3CrLabel.enabled := False;
                  Column3DbLabel.enabled := False;
                  Column3Cr.enabled := False;
                  Column3Db.enabled := False;

              end;

         end;

    end else begin

                Column2Label.enabled := false;
                Column2CrLabel.enabled := false;
                Column2DbLabel.enabled := false;
                Column2Cr.enabled := false;
                Column2Db.enabled := false;

                Column3Label.enabled := false;
                Column3CrLabel.enabled := false;
                Column3DbLabel.enabled := false;
                Column3Cr.enabled := false;
                Column3Db.enabled := false;
    end;

    for i := AccFrom to AccTo do begin
        OkToInclude := true;
        Accsdatamodule.NLFileDB.Locate('NLNo',i,[]);
        // exclude records outside no of partner ranges

        if ((( i > Cash1.xnomprvinc+Cash11.xno_of_partners ) And
			     ( i < Cash1.xnomprvexp )) Or
			    (( i > Cash1.xnomprvexp+Cash11.xno_of_partners ) And
			     ( i < Cash1.xnomtax )) Or
			    (( i > Cash1.xnomprofit+Cash11.xno_of_partners ) And
			     ( i < Cash1.xnomopen )) Or
			     ( i > Cash1.xnomopen+Cash11.xno_of_partners )) Then OkToInclude := false;

        // exclude record if not active

        if Accsdatamodule.NLFileDB['Active'] = False then OkToInclude := false;

        // Select correct nominal group to add totals into (Totals held in TotalsArray:array[1..10])

        IF (( i >= Cash1.XNOMINCFROM ) And ( i <= Cash1.XNOMINCTO )) THEN TOT:=1;
	IF (( i >= Cash1.XNOMNONFROM ) And ( i <= Cash1.XNOMNONTO )) THEN TOT:=2;
	IF (( i >= Cash1.XNOMEXPFROM ) And ( i <= Cash1.XNOMEXPTO )) THEN TOT:=3;
	IF (( i >= Cash1.XNOMOHFROM ) And ( i <= Cash1.XNOMOHTO )) THEN TOT:=4;
	IF (( i >= Cash1.XNOMCAFROM ) And ( i <= Cash1.XNOMCATO )) THEN TOT:=5;
	IF (( i >= Cash1.XNOMFAFROM ) And ( i <= Cash1.XNOMFATO )) THEN TOT:=6;
	IF (( i >= Cash1.XNOMLIFROM ) And ( i <= Cash1.XNOMLITO )) THEN TOT:=7;
	IF (( i >= Cash1.XBANKMIN ) And ( i <= Cash1.XBANKMAX )) THEN TOT:=8;
	IF (( i >= Cash1.XNOMPRVINC ) And ( i <= Cash1.XNOMPRVEXP+Cash11.xno_of_partners )) THEN TOT:=9;
	IF (( i >= Cash1.XNOMTAX ) And ( i <= Cash1.XNOMOPEN+Cash11.xno_of_partners )) THEN TOT:=10;

        if OKToInclude then begin

             Accsdatamodule.TrialBalanceReportDB.append;
             inc(Linecount);
             if Linecount = 56 then Linecount := 1;
             inc(Recordcount);
             Accsdatamodule.TrialBalanceReportDB['RecNo'] := i;
             Accsdatamodule.TrialBalanceReportDB['Name'] := Accsdatamodule.NLFileDB['Name'];

             Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=  '-';
             Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=  '-';
             Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=  '-';
             Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=  '-';
             Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=   '-';
             Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=   '-';
             Accsdatamodule.TrialBalanceReportDB['Close_Db'] := '-';
             Accsdatamodule.TrialBalanceReportDB['Close_Cr'] := '-';

             If not MonthReport then begin

                    try CurrBal := accsdatamodule.NLFileDB['Balance'];
                    except CurrBal := 0;
                    end;

                    try OpeningBal := accsdatamodule.NLFileDB['STYear'];
                    except OpeningBal := 0;
                    end;

                    if CurrBal > 0 then begin
                        DoubleToStr ( CurrBal, TempStr, '%f', True, False, 10, False );
                        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] := TempStr;
                        TotalsArray[TOT].Curr_Db := TotalsArray[TOT].Curr_Db + CurrBal;
                        Accsdatamodule.TrialBalanceReportDB['Close_Db'] := TempStr;
                        TotalsArray[TOT].Close_Db := TotalsArray[TOT].Close_Db + CurrBal;
                        RunningDb := RunningDb + CurrBal;
                    end;
                    if CurrBal < 0 then begin
                        DoubleToStr ( CurrBal, TempStr, '%f', True, False, 10, False );
                        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] := TempStr;
                        TotalsArray[TOT].Curr_Cr := TotalsArray[TOT].Curr_Cr - CurrBal;
                        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] := TempStr;
                        TotalsArray[TOT].Close_Cr := TotalsArray[TOT].Close_Cr - CurrBal;
                        RunningCr := RunningCr - CurrBal;
                    end;

                    if OpeningBal > 0 then begin
                        DoubleToStr ( OpeningBal, TempStr, '%f', True, False, 10, False );
                        Accsdatamodule.TrialBalanceReportDB['Open_Db'] := TempStr;
                        TotalsArray[TOT].Open_Db := TotalsArray[TOT].Open_Db + OpeningBal;
                    end;
                    if OpeningBal < 0 then begin
                        DoubleToStr ( OpeningBal, TempStr, '%f', True, False, 10, False );
                        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] := TempStr;
                        TotalsArray[TOT].Open_Cr := TotalsArray[TOT].Open_Cr - OpeningBal;
                    end;

                    // Year Movement

                    YearMove := CurrBal - OpeningBal;

                    if YearMove > 0 then begin
                        DoubleToStr ( YearMove, TempStr, '%f', True, False, 10, False );
                        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] := TempStr;
                        TotalsArray[TOT].Move_Db := TotalsArray[TOT].Move_Db + YearMove;
                    end;
                    if YearMove < 0 then begin
                        DoubleToStr ( YearMove, TempStr, '%f', True, False, 10, False );
                        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] := TempStr;
                        TotalsArray[TOT].Move_Cr := TotalsArray[TOT].Move_Cr - YearMove;
                    end;


             end else begin  // its a MonthReport

                    try CurrBal := accsdatamodule.NLFileDB['Balance'];
                    except CurrBal := 0;
                    end;

                    if CurrBal > 0 then begin
                        RunningDb := RunningDb + CurrBal;
                    end;
                    if CurrBal < 0 then begin
                        RunningCr := RunningCr - CurrBal;
                    end;

                    if SingleMonth or SpanMonthReport then begin

                        if Singlemonth then begin

                                case ReportMonth of   // individual month figures

                                1: YearMove := accsdatamodule.NLFileDB['ActPer01'];
                                2: YearMove := accsdatamodule.NLFileDB['ActPer02'];
                                3: YearMove := accsdatamodule.NLFileDB['ActPer03'];
                                4: YearMove := accsdatamodule.NLFileDB['ActPer04'];
                                5: YearMove := accsdatamodule.NLFileDB['ActPer05'];
                                6: YearMove := accsdatamodule.NLFileDB['ActPer06'];
                                7: YearMove := accsdatamodule.NLFileDB['ActPer07'];
                                8: YearMove := accsdatamodule.NLFileDB['ActPer08'];
                                9: YearMove := accsdatamodule.NLFileDB['ActPer09'];
                                10: YearMove := accsdatamodule.NLFileDB['ActPer10'];
                                11: YearMove := accsdatamodule.NLFileDB['ActPer11'];
                                12: YearMove := accsdatamodule.NLFileDB['ActPer12'];

                                end;

                        end; // singlemonth

                        if SpanMonthReport then begin

                                ReportMonth := MonthFrom;

                                YearMove := 0;
                                if ReportMonths[1] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer01'];
                                if ReportMonths[2] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer02'];
                                if ReportMonths[3] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer03'];
                                if ReportMonths[4] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer04'];
                                if ReportMonths[5] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer05'];
                                if ReportMonths[6] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer06'];
                                if ReportMonths[7] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer07'];
                                if ReportMonths[8] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer08'];
                                if ReportMonths[9] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer09'];
                                if ReportMonths[10] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer10'];
                                if ReportMonths[11] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer11'];
                                if ReportMonths[12] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer12'];

                        end;

                        if YearMove > 0 then begin
                            DoubleToStr ( YearMove, TempStr, '%f', True, False, 10, False );
                            Accsdatamodule.TrialBalanceReportDB['Mov_Db'] := TempStr;
                            TotalsArray[TOT].Move_Db := TotalsArray[TOT].Move_Db + YearMove;
                        end;
                        if YearMove < 0 then begin
                            DoubleToStr ( YearMove, TempStr, '%f', True, False, 10, False );
                            Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] := TempStr;
                            TotalsArray[TOT].Move_Cr := TotalsArray[TOT].Move_Cr - YearMove;
                        end;

                        if ReportMonth = Cash1.XFinMonth then begin // first month of the year

                          try OpeningBal := accsdatamodule.NLFileDB['STYear'];
                          except OpeningBal := 0;
                          end;

                          ClosingBal := OpeningBal + YearMove;


                        end else begin  // ReportMonth = Cash1.XFinMonth
                                try OpeningBal := accsdatamodule.NLFileDB['STYear'];
                                except OpeningBal := 0;
                                end;

                                if BalanceMonths[1] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer01'];
                                if BalanceMonths[2] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer02'];
                                if BalanceMonths[3] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer03'];
                                if BalanceMonths[4] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer04'];
                                if BalanceMonths[5] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer05'];
                                if BalanceMonths[6] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer06'];
                                if BalanceMonths[7] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer07'];
                                if BalanceMonths[8] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer08'];
                                if BalanceMonths[9] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer09'];
                                if BalanceMonths[10] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer10'];
                                if BalanceMonths[11] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer11'];
                                if BalanceMonths[12] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer12'];

                                ClosingBal := OpeningBal + YearMove;

                        end;

                        if OpeningBal > 0 then begin
                            DoubleToStr ( OpeningBal, TempStr, '%f', True, False, 10, False );
                            Accsdatamodule.TrialBalanceReportDB['Open_Db'] := TempStr;
                            TotalsArray[TOT].Open_Db := TotalsArray[TOT].Open_Db + OpeningBal;
                        end;
                        if OpeningBal < 0 then begin
                            DoubleToStr ( OpeningBal, TempStr, '%f', True, False, 10, False );
                            Accsdatamodule.TrialBalanceReportDB['Open_Cr'] := TempStr;
                            TotalsArray[TOT].Open_Cr := TotalsArray[TOT].Open_Cr - OpeningBal;
                        end;

                        if ClosingBal > 0 then begin
                            DoubleToStr ( ClosingBal, TempStr, '%f', True, False, 10, False );
                            Accsdatamodule.TrialBalanceReportDB['Close_Db'] := TempStr;
                            TotalsArray[TOT].Close_Db := TotalsArray[TOT].Close_Db + ClosingBal;
                        end;
                        if ClosingBal < 0 then begin
                            DoubleToStr ( ClosingBal, TempStr, '%f', True, False, 10, False );
                            Accsdatamodule.TrialBalanceReportDB['Close_Cr'] := TempStr;
                            TotalsArray[TOT].Close_Cr := TotalsArray[TOT].Close_Cr - ClosingBal;
                        end;
                    end; // single month

                    if SpanYearMonthReport then begin

                                YearMove := 0;
                                if ReportMonths[1] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer01'];
                                if ReportMonths[2] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer02'];
                                if ReportMonths[3] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer03'];
                                if ReportMonths[4] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer04'];
                                if ReportMonths[5] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer05'];
                                if ReportMonths[6] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer06'];
                                if ReportMonths[7] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer07'];
                                if ReportMonths[8] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer08'];
                                if ReportMonths[9] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer09'];
                                if ReportMonths[10] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer10'];
                                if ReportMonths[11] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer11'];
                                if ReportMonths[12] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer12'];

                                if LastYearReportMonths[1] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer01'];
                                if LastYearReportMonths[2] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer02'];
                                if LastYearReportMonths[3] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer03'];
                                if LastYearReportMonths[4] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer04'];
                                if LastYearReportMonths[5] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer05'];
                                if LastYearReportMonths[6] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer06'];
                                if LastYearReportMonths[7] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer07'];
                                if LastYearReportMonths[8] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer08'];
                                if LastYearReportMonths[9] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer09'];
                                if LastYearReportMonths[10] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer10'];
                                if LastYearReportMonths[11] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer11'];
                                if LastYearReportMonths[12] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer12'];

                                if YearMove > 0 then begin
                                        DoubleToStr ( YearMove, TempStr, '%f', True, False, 10, False );
                                        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] := TempStr;
                                        TotalsArray[TOT].Curr_Db := TotalsArray[TOT].Curr_Db + YearMove;
                                end;
                                if YearMove < 0 then begin
                                        DoubleToStr ( YearMove, TempStr, '%f', True, False, 10, False );
                                        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] := TempStr;
                                        TotalsArray[TOT].Curr_Cr := TotalsArray[TOT].Curr_Cr - YearMove;
                                end;

                    end; // SpanYearMonth
                end;

             Accsdatamodule.TrialBalanceReportDB.post;

        end; // oktoprint

    end; // i := AccFrom .....

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Totals';
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Number of Records - ' + vartostr(RecordCount);
        Accsdatamodule.TrialBalanceReportDB.post;


        if not MonthReport then begin

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);

   //     if MonthReport then Accsdatamodule.TrialBalanceReportDB['Labels'] := '' //filtered then Accsdatamodule.TrialBalanceReportDB['Labels'] := '                              Debit Total : ' + vartostr(RunningDb) + '         Credit Total : ' + vartostr(RunningCr)
  //      if ((Int(RunningDb*100)) = (Int(RunningCr*100))) then Accsdatamodule.TrialBalanceReportDB['Labels'] := '                              Debit Total : ' + FormatFloat('###.##',RunningDb) + '         Credit Total : ' + FormatFloat('###.##',RunningCr)
        if ((round(RunningDb * 100)/100) = (round(RunningCr * 100) / 100)) then Accsdatamodule.TrialBalanceReportDB['Labels'] := '                              Debit Total : ' + FormatFloat('##0.00',RunningDb) + '         Credit Total : ' + FormatFloat('##0.00',RunningCr)                           // TGM AB 17/01/14
                    else Accsdatamodule.TrialBalanceReportDB['Labels'] := '                            Debit Total : ' +FormatFloat('##0.00',RunningDb) + '         Credit Total : ' + FormatFloat('##0.00',RunningCr) + '     *** Error in Totals ***';                                                    // TGM AB 17/01/14

        Accsdatamodule.TrialBalanceReportDB.post;
        end;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        // Display Totals

        if ((Linecount > 40) and (Linecount < 55)) then begin     // need new page if less than 15 lines left at the bottom   //TGM AB 13/12/13
            while Linecount <> 55 do begin
                  Accsdatamodule.TrialBalanceReportDB.append;
                  inc(Linecount);
                  Accsdatamodule.TrialBalanceReportDB.post;
            end;
            Linecount := 1;
        end;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Enterprise Income';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[1].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[1].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[1].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[1].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[1].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[1].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[1].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[1].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Non-Enterprise Income';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[2].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[2].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[2].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[2].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[2].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[2].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[2].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[2].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Enterprise Expense';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[3].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[3].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[3].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[3].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[3].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[3].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[3].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[3].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Overheads';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[4].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[4].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[4].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[4].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[4].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[4].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[4].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[4].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Current Assets';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[5].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[5].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[5].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[5].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[5].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[5].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[5].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[5].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Fixed Assets';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[6].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[6].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[6].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[6].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[6].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[6].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[6].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[6].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Liabilities';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[7].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[7].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[7].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[7].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[7].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[7].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[7].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[7].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Bank Accounts';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[8].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[8].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[8].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[8].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[8].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[8].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[8].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[8].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Private';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[9].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[9].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[9].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[9].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[9].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[9].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[9].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[9].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Control Accounts';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[10].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[10].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[10].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[10].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[10].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[10].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[10].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[10].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Totals';

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Curr_Db;
        Tempbal := TempBal + TotalsArray[2].Curr_Db;
        Tempbal := TempBal + TotalsArray[3].Curr_Db;
        Tempbal := TempBal + TotalsArray[4].Curr_Db;
        Tempbal := TempBal + TotalsArray[5].Curr_Db;
        Tempbal := TempBal + TotalsArray[6].Curr_Db;
        Tempbal := TempBal + TotalsArray[7].Curr_Db;
        Tempbal := TempBal + TotalsArray[8].Curr_Db;
        Tempbal := TempBal + TotalsArray[9].Curr_Db;
        Tempbal := TempBal + TotalsArray[10].Curr_Db;
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Curr_Cr;
        Tempbal := TempBal + TotalsArray[2].Curr_Cr;
        Tempbal := TempBal + TotalsArray[3].Curr_Cr;
        Tempbal := TempBal + TotalsArray[4].Curr_Cr;
        Tempbal := TempBal + TotalsArray[5].Curr_Cr;
        Tempbal := TempBal + TotalsArray[6].Curr_Cr;
        Tempbal := TempBal + TotalsArray[7].Curr_Cr;
        Tempbal := TempBal + TotalsArray[8].Curr_Cr;
        Tempbal := TempBal + TotalsArray[9].Curr_Cr;
        Tempbal := TempBal + TotalsArray[10].Curr_Cr;
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Open_Db;
        Tempbal := TempBal + TotalsArray[2].Open_Db;
        Tempbal := TempBal + TotalsArray[3].Open_Db;
        Tempbal := TempBal + TotalsArray[4].Open_Db;
        Tempbal := TempBal + TotalsArray[5].Open_Db;
        Tempbal := TempBal + TotalsArray[6].Open_Db;
        Tempbal := TempBal + TotalsArray[7].Open_Db;
        Tempbal := TempBal + TotalsArray[8].Open_Db;
        Tempbal := TempBal + TotalsArray[9].Open_Db;
        Tempbal := TempBal + TotalsArray[10].Open_Db;
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Open_Cr;
        Tempbal := TempBal + TotalsArray[2].Open_Cr;
        Tempbal := TempBal + TotalsArray[3].Open_Cr;
        Tempbal := TempBal + TotalsArray[4].Open_Cr;
        Tempbal := TempBal + TotalsArray[5].Open_Cr;
        Tempbal := TempBal + TotalsArray[6].Open_Cr;
        Tempbal := TempBal + TotalsArray[7].Open_Cr;
        Tempbal := TempBal + TotalsArray[8].Open_Cr;
        Tempbal := TempBal + TotalsArray[9].Open_Cr;
        Tempbal := TempBal + TotalsArray[10].Open_Cr;
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Move_Db;
        Tempbal := TempBal + TotalsArray[2].Move_Db;
        Tempbal := TempBal + TotalsArray[3].Move_Db;
        Tempbal := TempBal + TotalsArray[4].Move_Db;
        Tempbal := TempBal + TotalsArray[5].Move_Db;
        Tempbal := TempBal + TotalsArray[6].Move_Db;
        Tempbal := TempBal + TotalsArray[7].Move_Db;
        Tempbal := TempBal + TotalsArray[8].Move_Db;
        Tempbal := TempBal + TotalsArray[9].Move_Db;
        Tempbal := TempBal + TotalsArray[10].Move_Db;
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Move_Cr;
        Tempbal := TempBal + TotalsArray[2].Move_Cr;
        Tempbal := TempBal + TotalsArray[3].Move_Cr;
        Tempbal := TempBal + TotalsArray[4].Move_Cr;
        Tempbal := TempBal + TotalsArray[5].Move_Cr;
        Tempbal := TempBal + TotalsArray[6].Move_Cr;
        Tempbal := TempBal + TotalsArray[7].Move_Cr;
        Tempbal := TempBal + TotalsArray[8].Move_Cr;
        Tempbal := TempBal + TotalsArray[9].Move_Cr;
        Tempbal := TempBal + TotalsArray[10].Move_Cr;
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Close_Db;
        Tempbal := TempBal + TotalsArray[2].Close_Db;
        Tempbal := TempBal + TotalsArray[3].Close_Db;
        Tempbal := TempBal + TotalsArray[4].Close_Db;
        Tempbal := TempBal + TotalsArray[5].Close_Db;
        Tempbal := TempBal + TotalsArray[6].Close_Db;
        Tempbal := TempBal + TotalsArray[7].Close_Db;
        Tempbal := TempBal + TotalsArray[8].Close_Db;
        Tempbal := TempBal + TotalsArray[9].Close_Db;
        Tempbal := TempBal + TotalsArray[10].Close_Db;
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Close_Cr;
        Tempbal := TempBal + TotalsArray[2].Close_Cr;
        Tempbal := TempBal + TotalsArray[3].Close_Cr;
        Tempbal := TempBal + TotalsArray[4].Close_Cr;
        Tempbal := TempBal + TotalsArray[5].Close_Cr;
        Tempbal := TempBal + TotalsArray[6].Close_Cr;
        Tempbal := TempBal + TotalsArray[7].Close_Cr;
        Tempbal := TempBal + TotalsArray[8].Close_Cr;
        Tempbal := TempBal + TotalsArray[9].Close_Cr;
        Tempbal := TempBal + TotalsArray[10].Close_Cr;
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=   FormatFloat('0.00', TempBal);

        Accsdatamodule.TrialBalanceReportDB.post;

end;

procedure TTrialBalanceReport.ReportByGroup;
var
    LineCount, i, j, Tot, RecordCount, r : integer;
    OKToInclude : boolean;
    OpeningBal, CurrBal, ClosingBal, YearMove, RunningDb, RunningCr, TempBal : real;
    TempStr : Shortstring;

begin

    Linecount := 0;      // Report length = 55
    RecordCount := 0;
    Tot := 0;
    RunningDb := 0;
    RunningCr := 0;
    TempBal := 0;

    OpeningBal := 0;
    ClosingBal := 0;
    CurrBal := 0;
    YearMove := 0;

    for r := 1 to 10 do begin
        TotalsArray[r].Curr_Db := 0.00;
        TotalsArray[r].Curr_Cr := 0.00;
        TotalsArray[r].Open_Db := 0.00;
        TotalsArray[r].Open_Cr := 0.00;
        TotalsArray[r].Move_Db := 0.00;
        TotalsArray[r].Move_Cr := 0.00;
        TotalsArray[r].Close_Db := 0.00;
        TotalsArray[r].Close_Cr := 0.00;
    end;


    AccountTypeLabel.Caption := 'Group';

    Column1Label.enabled := true;
    Column1CrLabel.enabled := true;
    Column1DbLabel.enabled := true;
    Column1Cr.enabled := true;
    Column1Db.enabled := true;

    Column1Label.Caption := 'Current Balance';
    Column1Db.DataField := 'Curr_Db';
    Column1Cr.DataField := 'Curr_Cr';

    if ShowExtended then begin

         Column2Label.enabled := true;
         Column2CrLabel.enabled := true;
         Column2DbLabel.enabled := true;
         Column2Cr.enabled := true;
         Column2Db.enabled := true;

         Column3Label.enabled := true;
         Column3CrLabel.enabled := true;
         Column3DbLabel.enabled := true;
         Column3Cr.enabled := true;
         Column3Db.enabled := true;

         if ShowYearMovement then begin

              Column1Label.Caption := 'Opening Balance';
              Column1Db.DataField := 'Open_Db';
              Column1Cr.DataField := 'Open_Cr';

         end;

         If MonthReport then begin

              if SingleMonth then Column2Label.Caption := 'Month Movement'
                else Column2Label.Caption := 'Period Movement';
              
              Column1Label.Caption := 'Opening Balance';
              Column1Db.DataField := 'Open_Db';
              Column1Cr.DataField := 'Open_Cr';

              if SpanYearMonthReport then begin

                  Column1Label.Caption := 'Total Movement';
                  Column1Db.DataField := 'Curr_Db';
                  Column1Cr.DataField := 'Curr_Cr';

                  Column2Label.enabled := False;
                  Column2CrLabel.enabled := False;
                  Column2DbLabel.enabled := False;
                  Column2Cr.enabled := False;
                  Column2Db.enabled := False;

                  Column3Label.enabled := False;
                  Column3CrLabel.enabled := False;
                  Column3DbLabel.enabled := False;
                  Column3Cr.enabled := False;
                  Column3Db.enabled := False;

              end;

         end;

    end else begin

                Column2Label.enabled := false;
                Column2CrLabel.enabled := false;
                Column2DbLabel.enabled := false;
                Column2Cr.enabled := false;
                Column2Db.enabled := false;

                Column3Label.enabled := false;
                Column3CrLabel.enabled := false;
                Column3DbLabel.enabled := false;
                Column3Cr.enabled := false;
                Column3Db.enabled := false;
    end;

    for i := AccFrom to AccTo do begin
        OkToInclude := true;
        Accsdatamodule.NLGroupsDB.Locate('GroupNo',i,[]);
        // exclude records outside no of partner ranges

        if ((( i > Cash1.xnomprvinc+Cash11.xno_of_partners ) And
			     ( i < Cash1.xnomprvexp )) Or
			    (( i > Cash1.xnomprvexp+Cash11.xno_of_partners ) And
			     ( i < Cash1.xnomtax )) Or
			    (( i > Cash1.xnomprofit+Cash11.xno_of_partners ) And
			     ( i < Cash1.xnomopen )) Or
			     ( i > Cash1.xnomopen+Cash11.xno_of_partners )) Then OkToInclude := false;

        // exclude record if not active

        if Accsdatamodule.NLGroupsDB['Active'] = False then OkToInclude := false;

        // Select correct nominal group to add totals into (Totals held in TotalsArray:array[1..10])

        IF (( i >= Cash1.XNOMINCFROM ) And ( i <= Cash1.XNOMINCTO )) THEN TOT:=1;
	IF (( i >= Cash1.XNOMNONFROM ) And ( i <= Cash1.XNOMNONTO )) THEN TOT:=2;
	IF (( i >= Cash1.XNOMEXPFROM ) And ( i <= Cash1.XNOMEXPTO )) THEN TOT:=3;
	IF (( i >= Cash1.XNOMOHFROM ) And ( i <= Cash1.XNOMOHTO )) THEN TOT:=4;
	IF (( i >= Cash1.XNOMCAFROM ) And ( i <= Cash1.XNOMCATO )) THEN TOT:=5;
	IF (( i >= Cash1.XNOMFAFROM ) And ( i <= Cash1.XNOMFATO )) THEN TOT:=6;
	IF (( i >= Cash1.XNOMLIFROM ) And ( i <= Cash1.XNOMLITO )) THEN TOT:=7;
	IF (( i >= Cash1.XBANKMIN ) And ( i <= Cash1.XBANKMAX )) THEN TOT:=8;
	IF (( i >= Cash1.XNOMPRVINC ) And ( i <= Cash1.XNOMPRVEXP+Cash11.xno_of_partners )) THEN TOT:=9;
	IF (( i >= Cash1.XNOMTAX ) And ( i <= Cash1.XNOMOPEN+Cash11.xno_of_partners )) THEN TOT:=10;

        Accsdatamodule.NLFileDB.Filter := 'REPGROUP = ''' + vartostr(i) + '''';
        Accsdatamodule.NLFileDB.Filtered := true;
        If Accsdatamodule.NLFileDB.RecordCount = 0 then OkToInclude := false;

        if OKToInclude then begin

             Accsdatamodule.TrialBalanceReportDB.append;
             inc(Linecount);
             if Linecount = 56 then Linecount := 1;
             inc(Recordcount);
             Accsdatamodule.TrialBalanceReportDB['RecNo'] := i;
             Accsdatamodule.TrialBalanceReportDB['Name'] := Accsdatamodule.NLGroupsDB['GroupDesc'];  //Currstr;

             Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=  '-';    // '         -  ';
             Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=  '-';
             Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=  '-';
             Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=  '-';
             Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=   '-';
             Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=   '-';
             Accsdatamodule.TrialBalanceReportDB['Close_Db'] := '-';
             Accsdatamodule.TrialBalanceReportDB['Close_Cr'] := '-';

             OpeningBal := 0;
             ClosingBal := 0;
             CurrBal := 0;
             YearMove := 0;

             Accsdatamodule.NLFileDB.First;
             for j := 1 to Accsdatamodule.NLFileDB.recordcount do begin

             If not MonthReport then begin

                    try TempBal := accsdatamodule.NLFileDB['Balance'];
                    except TempBal := 0;
                    end;

                    CurrBal := CurrBal + TempBal;

                    try  TempBal := accsdatamodule.NLFileDB['STYear'];
                    except TempBal := 0;
                    end;

                    OpeningBal := OpeningBal + TempBal




             end else begin  // not MonthReport

                    try TempBal := accsdatamodule.NLFileDB['Balance'];
                    except TempBal := 0;
                    end;

                    CurrBal := CurrBal + TempBal;

            //        if CurrBal > 0 then begin
            //            RunningDb := RunningDb + CurrBal;
            //        end;
            //        if CurrBal < 0 then begin
            //            RunningCr := RunningCr - CurrBal;
            //        end;

                    if SingleMonth or SpanMonthReport then begin

                        if Singlemonth then begin

                                case ReportMonth of   // individual month figures

                                        1: YearMove := YearMove + accsdatamodule.NLFileDB['ActPer01'];
                                        2: YearMove := YearMove + accsdatamodule.NLFileDB['ActPer02'];
                                        3: YearMove := YearMove + accsdatamodule.NLFileDB['ActPer03'];
                                        4: YearMove := YearMove + accsdatamodule.NLFileDB['ActPer04'];
                                        5: YearMove := YearMove + accsdatamodule.NLFileDB['ActPer05'];
                                        6: YearMove := YearMove + accsdatamodule.NLFileDB['ActPer06'];
                                        7: YearMove := YearMove + accsdatamodule.NLFileDB['ActPer07'];
                                        8: YearMove := YearMove + accsdatamodule.NLFileDB['ActPer08'];
                                        9: YearMove := YearMove + accsdatamodule.NLFileDB['ActPer09'];
                                        10: YearMove := YearMove + accsdatamodule.NLFileDB['ActPer10'];
                                        11: YearMove := YearMove + accsdatamodule.NLFileDB['ActPer11'];
                                        12: YearMove := YearMove + accsdatamodule.NLFileDB['ActPer12'];
                                end;

                        end;   // singlemonth

                        if SpanMonthReport then begin

                                ReportMonth := MonthFrom;

                                if ReportMonths[1] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer01'];
                                if ReportMonths[2] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer02'];
                                if ReportMonths[3] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer03'];
                                if ReportMonths[4] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer04'];
                                if ReportMonths[5] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer05'];
                                if ReportMonths[6] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer06'];
                                if ReportMonths[7] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer07'];
                                if ReportMonths[8] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer08'];
                                if ReportMonths[9] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer09'];
                                if ReportMonths[10] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer10'];
                                if ReportMonths[11] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer11'];
                                if ReportMonths[12] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer12'];

                        end;


                        if ReportMonth = Cash1.XFinMonth then begin // first month of the year

                                try TempBal := accsdatamodule.NLFileDB['STYear'];
                                except TempBal := 0;
                                end;

                                OpeningBal := OpeningBal + TempBal


                        end else begin

                                try TempBal := accsdatamodule.NLFileDB['STYear'];
                                except TempBal := 0;
                                end;

                                OpeningBal := OpeningBal + TempBal;

                                if BalanceMonths[1] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer01'];
                                if BalanceMonths[2] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer02'];
                                if BalanceMonths[3] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer03'];
                                if BalanceMonths[4] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer04'];
                                if BalanceMonths[5] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer05'];
                                if BalanceMonths[6] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer06'];
                                if BalanceMonths[7] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer07'];
                                if BalanceMonths[8] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer08'];
                                if BalanceMonths[9] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer09'];
                                if BalanceMonths[10] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer10'];
                                if BalanceMonths[11] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer11'];
                                if BalanceMonths[12] then OpeningBal := OpeningBal + accsdatamodule.NLFileDB['ActPer12'];

                        end;
                    end; // single month


                    if SpanYearMonthReport then begin

                                if ReportMonths[1] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer01'];
                                if ReportMonths[2] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer02'];
                                if ReportMonths[3] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer03'];
                                if ReportMonths[4] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer04'];
                                if ReportMonths[5] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer05'];
                                if ReportMonths[6] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer06'];
                                if ReportMonths[7] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer07'];
                                if ReportMonths[8] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer08'];
                                if ReportMonths[9] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer09'];
                                if ReportMonths[10] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer10'];
                                if ReportMonths[11] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer11'];
                                if ReportMonths[12] = True then YearMove := YearMove + accsdatamodule.NLFileDB['ActPer12'];

                                if LastYearReportMonths[1] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer01'];
                                if LastYearReportMonths[2] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer02'];
                                if LastYearReportMonths[3] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer03'];
                                if LastYearReportMonths[4] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer04'];
                                if LastYearReportMonths[5] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer05'];
                                if LastYearReportMonths[6] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer06'];
                                if LastYearReportMonths[7] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer07'];
                                if LastYearReportMonths[8] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer08'];
                                if LastYearReportMonths[9] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer09'];
                                if LastYearReportMonths[10] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer10'];
                                if LastYearReportMonths[11] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer11'];
                                if LastYearReportMonths[12] = True then YearMove := YearMove + accsdatamodule.NLFileDB['LstPer12'];

                                
                    end; // SpanYearMonth

             end;

             Accsdatamodule.NLFileDB.next;

        end;  // for j :=

                    If MonthReport then begin

                        if SpanYearMonthReport then begin

                                if YearMove > 0 then begin
                                        DoubleToStr ( YearMove, TempStr, '%f', True, False, 10, False );
                                        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] := TempStr;
                                        TotalsArray[TOT].Curr_Db := TotalsArray[TOT].Curr_Db + YearMove;
                                end;
                                if YearMove < 0 then begin
                                        DoubleToStr ( YearMove, TempStr, '%f', True, False, 10, False );
                                        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] := TempStr;
                                        TotalsArray[TOT].Curr_Cr := TotalsArray[TOT].Curr_Cr - YearMove;
                                end;
                                
                        end
                                else begin

                                        ClosingBal := OpeningBal + YearMove;


                                        if YearMove > 0 then begin
                                                DoubleToStr ( YearMove, TempStr, '%f', True, False, 10, False );
                                                Accsdatamodule.TrialBalanceReportDB['Mov_Db'] := TempStr;
                                                TotalsArray[TOT].Move_Db := TotalsArray[TOT].Move_Db + YearMove;
                                        end;
                                        if YearMove < 0 then begin
                                                DoubleToStr ( YearMove, TempStr, '%f', True, False, 10, False );
                                                Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] := TempStr;
                                                TotalsArray[TOT].Move_Cr := TotalsArray[TOT].Move_Cr - YearMove;
                                        end;

                                        if OpeningBal > 0 then begin
                                                DoubleToStr ( OpeningBal, TempStr, '%f', True, False, 10, False );
                                                Accsdatamodule.TrialBalanceReportDB['Open_Db'] := TempStr;
                                                TotalsArray[TOT].Open_Db := TotalsArray[TOT].Open_Db + OpeningBal;
                                        end;
                                        if OpeningBal < 0 then begin
                                                DoubleToStr ( OpeningBal, TempStr, '%f', True, False, 10, False );
                                                Accsdatamodule.TrialBalanceReportDB['Open_Cr'] := TempStr;
                                                TotalsArray[TOT].Open_Cr := TotalsArray[TOT].Open_Cr - OpeningBal;
                                        end;

                                        if ClosingBal > 0 then begin
                                                DoubleToStr ( ClosingBal, TempStr, '%f', True, False, 10, False );
                                                Accsdatamodule.TrialBalanceReportDB['Close_Db'] := TempStr;
                                                TotalsArray[TOT].Close_Db := TotalsArray[TOT].Close_Db + ClosingBal;
                                        end;
                                        if ClosingBal < 0 then begin
                                                DoubleToStr ( ClosingBal, TempStr, '%f', True, False, 10, False );
                                                Accsdatamodule.TrialBalanceReportDB['Close_Cr'] := TempStr;
                                                TotalsArray[TOT].Close_Cr := TotalsArray[TOT].Close_Cr - ClosingBal;
                                        end;
                                end;

                    end else begin

                    if CurrBal > 0 then begin
                        DoubleToStr ( CurrBal, TempStr, '%f', True, False, 10, False );
                        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] := TempStr;
                        TotalsArray[TOT].Curr_Db := TotalsArray[TOT].Curr_Db + CurrBal;
                        Accsdatamodule.TrialBalanceReportDB['Close_Db'] := TempStr;
                        TotalsArray[TOT].Close_Db := TotalsArray[TOT].Close_Db + CurrBal;
                        RunningDb := RunningDb + CurrBal;
                    end;
                    if CurrBal < 0 then begin
                        DoubleToStr ( CurrBal, TempStr, '%f', True, False, 10, False );
                        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] := TempStr;
                        TotalsArray[TOT].Curr_Cr := TotalsArray[TOT].Curr_Cr - CurrBal;
                        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] := TempStr;
                        TotalsArray[TOT].Close_Cr := TotalsArray[TOT].Close_Cr - CurrBal;
                        RunningCr := RunningCr - CurrBal;
                    end;

                    if OpeningBal > 0 then begin
                        DoubleToStr ( OpeningBal, TempStr, '%f', True, False, 10, False );
                        Accsdatamodule.TrialBalanceReportDB['Open_Db'] := TempStr;
                        TotalsArray[TOT].Open_Db := TotalsArray[TOT].Open_Db + OpeningBal;
                    end;
                    if OpeningBal < 0 then begin
                        DoubleToStr ( OpeningBal, TempStr, '%f', True, False, 10, False );
                        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] := TempStr;
                        TotalsArray[TOT].Open_Cr := TotalsArray[TOT].Open_Cr - OpeningBal;
                    end;

                    // Year Movement

                    YearMove := CurrBal - OpeningBal;

                    if YearMove > 0 then begin
                        DoubleToStr ( YearMove, TempStr, '%f', True, False, 10, False );
                        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] := TempStr;
                        TotalsArray[TOT].Move_Db := TotalsArray[TOT].Move_Db + YearMove;
                    end;
                    if YearMove < 0 then begin
                        DoubleToStr ( YearMove, TempStr, '%f', True, False, 10, False );
                        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] := TempStr;
                        TotalsArray[TOT].Move_Cr := TotalsArray[TOT].Move_Cr - YearMove;
                    end;
                    end;

        Accsdatamodule.TrialBalanceReportDB.post;

        end; // oktoprint

        Accsdatamodule.NLFileDB.Filtered := false;

    end; // i := AccFrom .....

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Totals';
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Number of Records - ' + vartostr(RecordCount);
        Accsdatamodule.TrialBalanceReportDB.post;


        if not Monthreport then begin

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);

      //  if MonthReport then Accsdatamodule.TrialBalanceReportDB['Labels'] := '' //filtered then Accsdatamodule.TrialBalanceReportDB['Labels'] := '                              Debit Total : ' + vartostr(RunningDb) + '         Credit Total : ' + vartostr(RunningCr)


      //  if ((Int(RunningDb*100)) = (Int(RunningCr*100))) then Accsdatamodule.TrialBalanceReportDB['Labels'] := '                              Debit Total : ' + FormatFloat('###.##', RunningDb) + '         Credit Total : ' + FormatFloat('###.##',RunningCr)
        if ((round(RunningDb * 100)/100) = (round(RunningCr * 100) / 100)) then Accsdatamodule.TrialBalanceReportDB['Labels'] := '                              Debit Total : ' + FormatFloat('##0.00', RunningDb) + '         Credit Total : ' + FormatFloat('##0.00',RunningCr)      // TGM AB 17/01/14
                    else Accsdatamodule.TrialBalanceReportDB['Labels'] := '                            Debit Total : ' + FormatFloat('###.##0.00',RunningDb) + '         Credit Total : ' + FormatFloat('##0.00',RunningCr) + '     *** Error in Totals ***';                            // TGM AB 17/01/14

        Accsdatamodule.TrialBalanceReportDB.post;

        end;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        // Display Totals

        if ((Linecount > 40) and (Linecount < 55)) then begin     // need new page     // TGM AB 12/02/16 was - Linecount > 40
            while Linecount <> 55 do begin
                  Accsdatamodule.TrialBalanceReportDB.append;
                  inc(Linecount);
                  Accsdatamodule.TrialBalanceReportDB.post;
            end;
            Linecount := 1;
        end;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Enterprise Income';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[1].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[1].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[1].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[1].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[1].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[1].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[1].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[1].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Non-Enterprise Income';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[2].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[2].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[2].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[2].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[2].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[2].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[2].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[2].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Enterprise Expense';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[3].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[3].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[3].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[3].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[3].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[3].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[3].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[3].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Overheads';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[4].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[4].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[4].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[4].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[4].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[4].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[4].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[4].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Current Assets';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[5].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[5].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[5].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[5].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[5].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[5].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[5].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[5].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Fixed Assets';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[6].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[6].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[6].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[6].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[6].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[6].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[6].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[6].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Liabilities';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[7].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[7].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[7].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[7].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[7].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[7].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[7].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[7].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Bank Accounts';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[8].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[8].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[8].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[8].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[8].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[8].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[8].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[8].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Private';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[9].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[9].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[9].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[9].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[9].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[9].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[9].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[9].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Control Accounts';
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TotalsArray[10].Curr_Db);
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TotalsArray[10].Curr_Cr);
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TotalsArray[10].Open_Db);
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TotalsArray[10].Open_Cr);
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=    FormatFloat('0.00', TotalsArray[10].Move_Db);
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=    FormatFloat('0.00', TotalsArray[10].Move_Cr);
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=  FormatFloat('0.00', TotalsArray[10].Close_Db);
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=  FormatFloat('0.00', TotalsArray[10].Close_Cr);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB.post;

        Accsdatamodule.TrialBalanceReportDB.append;
        inc(Linecount);
        Accsdatamodule.TrialBalanceReportDB['Labels'] := 'Totals';

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Curr_Db;
        Tempbal := TempBal + TotalsArray[2].Curr_Db;
        Tempbal := TempBal + TotalsArray[3].Curr_Db;
        Tempbal := TempBal + TotalsArray[4].Curr_Db;
        Tempbal := TempBal + TotalsArray[5].Curr_Db;
        Tempbal := TempBal + TotalsArray[6].Curr_Db;
        Tempbal := TempBal + TotalsArray[7].Curr_Db;
        Tempbal := TempBal + TotalsArray[8].Curr_Db;
        Tempbal := TempBal + TotalsArray[9].Curr_Db;
        Tempbal := TempBal + TotalsArray[10].Curr_Db;
        Accsdatamodule.TrialBalanceReportDB['Curr_Db'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Curr_Cr;
        Tempbal := TempBal + TotalsArray[2].Curr_Cr;
        Tempbal := TempBal + TotalsArray[3].Curr_Cr;
        Tempbal := TempBal + TotalsArray[4].Curr_Cr;
        Tempbal := TempBal + TotalsArray[5].Curr_Cr;
        Tempbal := TempBal + TotalsArray[6].Curr_Cr;
        Tempbal := TempBal + TotalsArray[7].Curr_Cr;
        Tempbal := TempBal + TotalsArray[8].Curr_Cr;
        Tempbal := TempBal + TotalsArray[9].Curr_Cr;
        Tempbal := TempBal + TotalsArray[10].Curr_Cr;
        Accsdatamodule.TrialBalanceReportDB['Curr_Cr'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Open_Db;
        Tempbal := TempBal + TotalsArray[2].Open_Db;
        Tempbal := TempBal + TotalsArray[3].Open_Db;
        Tempbal := TempBal + TotalsArray[4].Open_Db;
        Tempbal := TempBal + TotalsArray[5].Open_Db;
        Tempbal := TempBal + TotalsArray[6].Open_Db;
        Tempbal := TempBal + TotalsArray[7].Open_Db;
        Tempbal := TempBal + TotalsArray[8].Open_Db;
        Tempbal := TempBal + TotalsArray[9].Open_Db;
        Tempbal := TempBal + TotalsArray[10].Open_Db;
        Accsdatamodule.TrialBalanceReportDB['Open_Db'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Open_Cr;
        Tempbal := TempBal + TotalsArray[2].Open_Cr;
        Tempbal := TempBal + TotalsArray[3].Open_Cr;
        Tempbal := TempBal + TotalsArray[4].Open_Cr;
        Tempbal := TempBal + TotalsArray[5].Open_Cr;
        Tempbal := TempBal + TotalsArray[6].Open_Cr;
        Tempbal := TempBal + TotalsArray[7].Open_Cr;
        Tempbal := TempBal + TotalsArray[8].Open_Cr;
        Tempbal := TempBal + TotalsArray[9].Open_Cr;
        Tempbal := TempBal + TotalsArray[10].Open_Cr;
        Accsdatamodule.TrialBalanceReportDB['Open_Cr'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Move_Db;
        Tempbal := TempBal + TotalsArray[2].Move_Db;
        Tempbal := TempBal + TotalsArray[3].Move_Db;
        Tempbal := TempBal + TotalsArray[4].Move_Db;
        Tempbal := TempBal + TotalsArray[5].Move_Db;
        Tempbal := TempBal + TotalsArray[6].Move_Db;
        Tempbal := TempBal + TotalsArray[7].Move_Db;
        Tempbal := TempBal + TotalsArray[8].Move_Db;
        Tempbal := TempBal + TotalsArray[9].Move_Db;
        Tempbal := TempBal + TotalsArray[10].Move_Db;
        Accsdatamodule.TrialBalanceReportDB['Mov_Db'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Move_Cr;
        Tempbal := TempBal + TotalsArray[2].Move_Cr;
        Tempbal := TempBal + TotalsArray[3].Move_Cr;
        Tempbal := TempBal + TotalsArray[4].Move_Cr;
        Tempbal := TempBal + TotalsArray[5].Move_Cr;
        Tempbal := TempBal + TotalsArray[6].Move_Cr;
        Tempbal := TempBal + TotalsArray[7].Move_Cr;
        Tempbal := TempBal + TotalsArray[8].Move_Cr;
        Tempbal := TempBal + TotalsArray[9].Move_Cr;
        Tempbal := TempBal + TotalsArray[10].Move_Cr;
        Accsdatamodule.TrialBalanceReportDB['Mov_Cr'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Close_Db;
        Tempbal := TempBal + TotalsArray[2].Close_Db;
        Tempbal := TempBal + TotalsArray[3].Close_Db;
        Tempbal := TempBal + TotalsArray[4].Close_Db;
        Tempbal := TempBal + TotalsArray[5].Close_Db;
        Tempbal := TempBal + TotalsArray[6].Close_Db;
        Tempbal := TempBal + TotalsArray[7].Close_Db;
        Tempbal := TempBal + TotalsArray[8].Close_Db;
        Tempbal := TempBal + TotalsArray[9].Close_Db;
        Tempbal := TempBal + TotalsArray[10].Close_Db;
        Accsdatamodule.TrialBalanceReportDB['Close_Db'] :=   FormatFloat('0.00', TempBal);

        TempBal := 0;
        Tempbal := TempBal + TotalsArray[1].Close_Cr;
        Tempbal := TempBal + TotalsArray[2].Close_Cr;
        Tempbal := TempBal + TotalsArray[3].Close_Cr;
        Tempbal := TempBal + TotalsArray[4].Close_Cr;
        Tempbal := TempBal + TotalsArray[5].Close_Cr;
        Tempbal := TempBal + TotalsArray[6].Close_Cr;
        Tempbal := TempBal + TotalsArray[7].Close_Cr;
        Tempbal := TempBal + TotalsArray[8].Close_Cr;
        Tempbal := TempBal + TotalsArray[9].Close_Cr;
        Tempbal := TempBal + TotalsArray[10].Close_Cr;
        Accsdatamodule.TrialBalanceReportDB['Close_Cr'] :=   FormatFloat('0.00', TempBal);

        Accsdatamodule.TrialBalanceReportDB.post;


end;



end.

