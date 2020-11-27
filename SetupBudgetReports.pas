unit SetupBudgetReports;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, Newclass, Mask;

type
  TSetupBudgetReportsForm = class(TForm)
    StandardExitPanel: TPanel;
    ExitButton: TBitBtn;
    RunButton: TBitBtn;
    rgAccountGroup: TRadioGroup;
    GroupBox1: TGroupBox;
    cbIncludeLastYear: TCheckBox;
    ReportDate: TLabel;
    RepDate: TMaskEdit;
    RepSearch: TDateTimePicker;
    procedure ExitButtonClick(Sender: TObject);
    procedure RunButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ValidateMonths;
    procedure RepSearchCloseUp(Sender: TObject);
    procedure RepDateExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  SetupBudgetReportsForm: TSetupBudgetReportsForm;
  ValidationArray:array[1..12] of boolean;

implementation

uses AccsData, BudgetReportForm, CalculateMonths, VARS, Types, calcs;

{$R *.DFM}

procedure TSetupBudgetReportsForm.ValidateMonths;
var
   AYear, CurrentMonth, ADay: Word;
   StartMonth, I : integer;
begin
   DecodeDate(strtodate(Repdate.text), AYear, CurrentMonth, ADay);
   Startmonth := Cash1.XFINMONTH;

   for I :=1 to 12 do begin
       ValidationArray[1] := false;   // True value means already has actual figures then if false then fill in budget
   end;

   Case StartMonth of
                      1 : begin
                                for i:=1 to currentmonth do ValidationArray[i] := true;
                          end;
                      2 : begin
                          if currentmonth = 1 then for i:=1 to 12 do ValidationArray[i] := true
                              else for i:=2 to currentmonth do ValidationArray[i] := true
                          end;
                      3 : begin
                          if currentmonth = 1 then begin
                                                   for i:=3 to 12 do ValidationArray[i] := true;
                                                   ValidationArray[1] := true;
                                                   end
                              else if currentmonth = 2 then begin
                                                   for i:=1 to 12 do ValidationArray[i] := true;
                                                   end
                                   else for i:=3 to currentmonth do ValidationArray[i] := true
                          end;
                      4 : begin
                          if currentmonth = 1 then begin
                                                   for i:=4 to 12 do ValidationArray[i] := true;
                                                   ValidationArray[1] := true;
                                                   end
                              else if currentmonth = 2 then begin
                                                   for i:=4 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 2 do ValidationArray[i] := true;
                                                   end
                                  else if currentmonth = 3 then for i:=1 to 12 do ValidationArray[i] := true
                                       else for i:=4 to currentmonth do ValidationArray[i] := true
                          end;
                      5 : begin
                          if currentmonth = 1 then begin
                                                   for i:=5 to 12 do ValidationArray[i] := true;
                                                   ValidationArray[1] := true;
                                                   end
                              else if currentmonth = 2 then begin
                                                   for i:=5 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 2 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 3 then begin
                                                   for i:=5 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 3 do ValidationArray[i] := true;
                                                   end
                                  else if currentmonth = 4 then for i:=1 to 12 do ValidationArray[i] := true
                                       else for i:=5 to currentmonth do ValidationArray[i] := true
                          end;
                      6 : begin
                          if currentmonth = 1 then begin
                                                   for i:=6 to 12 do ValidationArray[i] := true;
                                                   ValidationArray[1] := true;
                                                   end
                              else if currentmonth = 2 then begin
                                                   for i:=6 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 2 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 3 then begin
                                                   for i:=6 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 3 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 4 then begin
                                                   for i:=6 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 4 do ValidationArray[i] := true;
                                                   end
                                  else if currentmonth = 5 then for i:=1 to 12 do ValidationArray[i] := true
                                       else for i:=6 to currentmonth do ValidationArray[i] := true
                          end;
                      7 : begin
                          if currentmonth = 1 then begin
                                                   for i:=7 to 12 do ValidationArray[i] := true;
                                                   ValidationArray[1] := true;
                                                   end
                              else if currentmonth = 2 then begin
                                                   for i:=7 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 2 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 3 then begin
                                                   for i:=7 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 3 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 4 then begin
                                                   for i:=7 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 4 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 5 then begin
                                                   for i:=7 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 5 do ValidationArray[i] := true;
                                                   end
                                  else if currentmonth = 6 then for i:=1 to 12 do ValidationArray[i] := true
                                       else for i:=7 to currentmonth do ValidationArray[i] := true
                          end;
                      8 : begin
                          if currentmonth = 1 then begin
                                                   for i:=8 to 12 do ValidationArray[i] := true;
                                                   ValidationArray[1] := true;
                                                   end
                              else if currentmonth = 2 then begin
                                                   for i:=8 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 2 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 3 then begin
                                                   for i:=8 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 3 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 4 then begin
                                                   for i:=8 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 4 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 5 then begin
                                                   for i:=8 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 6 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 6 then begin
                                                   for i:=8 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 6 do ValidationArray[i] := true;
                                                   end
                                  else if currentmonth = 7 then for i:=1 to 12 do ValidationArray[i] := true
                                       else for i:=8 to currentmonth do ValidationArray[i] := true
                          end;
                      9 : begin
                          if currentmonth = 1 then begin
                                                   for i:=9 to 12 do ValidationArray[i] := true;
                                                   ValidationArray[1] := true;
                                                   end
                              else if currentmonth = 2 then begin
                                                   for i:=9 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 2 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 3 then begin
                                                   for i:=9 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 3 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 4 then begin
                                                   for i:=9 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 4 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 5 then begin
                                                   for i:=9 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 5 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 6 then begin
                                                   for i:=9 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 6 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 7 then begin
                                                   for i:=9 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 7 do ValidationArray[i] := true;
                                                   end
                                  else if currentmonth = 8 then for i:=1 to 12 do ValidationArray[i] := true
                                       else for i:=9 to currentmonth do ValidationArray[i] := true
                          end;
                      10 : begin
                          if currentmonth = 1 then begin
                                                   for i:=10 to 12 do ValidationArray[i] := true;
                                                   ValidationArray[1] := true;
                                                   end
                              else if currentmonth = 2 then begin
                                                   for i:=10 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 2 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 3 then begin
                                                   for i:=10 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 3 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 4 then begin
                                                   for i:=10 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 4 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 5 then begin
                                                   for i:=10 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 5 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 6 then begin
                                                   for i:=10 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 6 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 7 then begin
                                                   for i:=10 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 7 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 8 then begin
                                                   for i:=10 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 8 do ValidationArray[i] := true;
                                                   end
                                  else if currentmonth = 9 then for i:=1 to 12 do ValidationArray[i] := true
                                       else for i:=10 to currentmonth do ValidationArray[i] := true
                          end;
                      11 : begin
                          if currentmonth = 1 then begin
                                                   for i:=11 to 12 do ValidationArray[i] := true;
                                                   ValidationArray[1] := true;
                                                   end
                              else if currentmonth = 2 then begin
                                                   for i:=11 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 2 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 3 then begin
                                                   for i:=11 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 3 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 4 then begin
                                                   for i:=11 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 4 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 5 then begin
                                                   for i:=11 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 5 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 6 then begin
                                                   for i:=11 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 6 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 7 then begin
                                                   for i:=11 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 7 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 8 then begin
                                                   for i:=11 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 1 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 9 then begin
                                                   for i:=11 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 9 do ValidationArray[i] := true;
                                                   end
                                  else if currentmonth = 10 then for i:=1 to 12 do ValidationArray[i] := true
                                       else for i:=11 to currentmonth do ValidationArray[i] := true
                          end;
                      12 : begin
                          if currentmonth = 1 then begin
                                                   for i:=12 to 12 do ValidationArray[i] := true;
                                                   ValidationArray[1] := true;
                                                   end
                              else if currentmonth = 2 then begin
                                                   for i:=12 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 2 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 3 then begin
                                                   for i:=12 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 3 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 4 then begin
                                                   for i:=12 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 4 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 5 then begin
                                                   for i:=12 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 5 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 6 then begin
                                                   for i:=12 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 6 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 7 then begin
                                                   for i:=12 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 7 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 8 then begin
                                                   for i:=12 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 8 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 9 then begin
                                                   for i:=12 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 9 do ValidationArray[i] := true;
                                                   end
                              else if currentmonth = 10 then begin
                                                   for i:=12 to 12 do ValidationArray[i] := true;
                                                   for i:=1 to 10 do ValidationArray[i] := true;
                                                   end
                                  else if currentmonth = 11 then for i:=1 to 12 do ValidationArray[i] := true
                                       else for i:=12 to currentmonth do ValidationArray[i] := true
                          end;
   end; // case
end;

procedure TSetupBudgetReportsForm.ExitButtonClick(Sender: TObject);
begin
     self.close;
end;

procedure TSetupBudgetReportsForm.RunButtonClick(Sender: TObject);
var
   i : integer;
   NominalCode : Integer;
begin
     AccsDataModule.GetBudgetReportFigures; // gather all figures
     CalculateMonths.CalculateMonthlyValues; // update this years monthly figures using those calculated.
     ValidateMonths;

     AccsDataModule.TempBudgetReportDB.open;
     AccsDataModule.TempBudgetReportDB.first;
     For i:=1 to AccsDataModule.TempBudgetReportDB.RecordCount do begin
         AccsDataModule.TempBudgetReportDB.edit;
         NominalCode := AccsDataModule.TempBudgetReportDB['NominalID'];
         if ((NominalCode >=Cash1.xNomIncFrom) and (NominalCode <=Cash1.xNomIncTo)) or
            ((NominalCode >=Cash1.xNomNonFrom) and (NominalCode  <=Cash1.xNomNonTo)) then begin
            if ValidationArray[1] = true then AccsDataModule.TempBudgetReportDB['JanActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month1/-100);
            if ValidationArray[2] = true then AccsDataModule.TempBudgetReportDB['FebActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month2/-100);
            if ValidationArray[3] = true then AccsDataModule.TempBudgetReportDB['MarActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month3/-100);
            if ValidationArray[4] = true then AccsDataModule.TempBudgetReportDB['AprActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month4/-100);
            if ValidationArray[5] = true then AccsDataModule.TempBudgetReportDB['MayActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month5/-100);
            if ValidationArray[6] = true then AccsDataModule.TempBudgetReportDB['JunActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month6/-100);
            if ValidationArray[7] = true then AccsDataModule.TempBudgetReportDB['JulActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month7/-100);
            if ValidationArray[8] = true then AccsDataModule.TempBudgetReportDB['AugActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month8/-100);
            if ValidationArray[9] = true then AccsDataModule.TempBudgetReportDB['SepActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month9/-100);
            if ValidationArray[10] = true then AccsDataModule.TempBudgetReportDB['OctActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month10/-100);
            if ValidationArray[11] = true then AccsDataModule.TempBudgetReportDB['NovActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month11/-100);
            if ValidationArray[12] = true then AccsDataModule.TempBudgetReportDB['DecActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month12/-100);
           // AccsDataModule.TempBudgetReportDB['YearActual'] := (CalculateMonths.MonthlyArray[NominalCode].YearTotal/-100);

         end
            else begin
            if ValidationArray[1] = true then AccsDataModule.TempBudgetReportDB['JanActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month1/100);
            if ValidationArray[2] = true then AccsDataModule.TempBudgetReportDB['FebActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month2/100);
            if ValidationArray[3] = true then AccsDataModule.TempBudgetReportDB['MarActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month3/100);
            if ValidationArray[4] = true then AccsDataModule.TempBudgetReportDB['AprActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month4/100);
            if ValidationArray[5] = true then AccsDataModule.TempBudgetReportDB['MayActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month5/100);
            if ValidationArray[6] = true then AccsDataModule.TempBudgetReportDB['JunActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month6/100);
            if ValidationArray[7] = true then AccsDataModule.TempBudgetReportDB['JulActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month7/100);
            if ValidationArray[8] = true then AccsDataModule.TempBudgetReportDB['AugActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month8/100);
            if ValidationArray[9] = true then AccsDataModule.TempBudgetReportDB['SepActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month9/100);
            if ValidationArray[10] = true then AccsDataModule.TempBudgetReportDB['OctActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month10/100);
            if ValidationArray[11] = true then AccsDataModule.TempBudgetReportDB['NovActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month11/100);
            if ValidationArray[12] = true then AccsDataModule.TempBudgetReportDB['DecActual'] := (CalculateMonths.MonthlyArray[NominalCode].Month12/100);
         //   AccsDataModule.TempBudgetReportDB['YearActual'] := (CalculateMonths.MonthlyArray[NominalCode].YearTotal/100);
         end;
         AccsDataModule.TempBudgetReportDB['YearActual'] := AccsDataModule.TempBudgetReportDB['JanActual']
                                                          + AccsDataModule.TempBudgetReportDB['FebActual']
                                                          + AccsDataModule.TempBudgetReportDB['MarActual']
                                                          + AccsDataModule.TempBudgetReportDB['AprActual']
                                                          + AccsDataModule.TempBudgetReportDB['MayActual']
                                                          + AccsDataModule.TempBudgetReportDB['JunActual']
                                                          + AccsDataModule.TempBudgetReportDB['JulActual']
                                                          + AccsDataModule.TempBudgetReportDB['AugActual']
                                                          + AccsDataModule.TempBudgetReportDB['SepActual']
                                                          + AccsDataModule.TempBudgetReportDB['OctActual']
                                                          + AccsDataModule.TempBudgetReportDB['NovActual']
                                                          + AccsDataModule.TempBudgetReportDB['DecActual'];
         AccsDataModule.TempBudgetReportDB.post;
         AccsDataModule.TempBudgetReportDB.next;
     end;
     AccsDataModule.TempBudgetReportDB.first;

     if RGAccountGroup.itemindex = 0 then begin
          AccsDatamodule.BudgetReportSQL.SQL.clear;
          AccsDatamodule.BudgetReportSQL.SQL.add('Select * from TempBudgetReport');
          AccsDatamodule.BudgetReportSQL.ExecSQL;
          AccsDatamodule.BudgetReportSQL.active := true;
          end
          else begin
               AccsDatamodule.BudgetReportSQL.SQL.clear;
               AccsDatamodule.BudgetReportSQL.SQL.add('select reportGrp, max(GrpName) as GrpName, Sum(YearBudget) as YearBudget, Sum(YearActual) as YearActual, sum(LastYear) as LastYear,');
               AccsDatamodule.BudgetReportSQL.SQL.add('sum(Jan) as Jan, sum(Feb) as Feb, sum(mar) as Mar, sum(Apr) as Apr, sum(May) as May, sum(Jun) as Jun,');
               AccsDatamodule.BudgetReportSQL.SQL.add('sum(Jul) as Jul, sum(Aug) as Aug, sum(Sep) as Sep, sum(Oct) as Oct, sum(Nov) as Nov, sum(Decem) as Decem,');
               AccsDatamodule.BudgetReportSQL.SQL.add('sum(JanActual) as Janactual, sum(Febactual) as Febactual, sum(maractual) as Maractual, sum(Apractual) as Apractual, sum(Mayactual) as Mayactual, sum(Junactual) as Junactual,');
               AccsDatamodule.BudgetReportSQL.SQL.add('sum(Julactual) as Julactual, sum(Augactual) as Augactual, sum(Sepactual) as Sepactual, sum(Octactual) as Octactual, sum(Novactual) as Novactual, sum(Decactual) as Decactual,');
               AccsDatamodule.BudgetReportSQL.SQL.add('sum(LastJan) as LastJan, sum(LastFeb) as LastFeb, sum(Lastmar) as LastMar, sum(LastApr) as LastApr, sum(LastMay) as LastMay, sum(LastJun) as LastJun,');
               AccsDatamodule.BudgetReportSQL.SQL.add('sum(LastJul) as LastJul, sum(LastAug) as LastAug, sum(LastSep) as LastSep, sum(LastOct) as LastOct, sum(LastNov) as LastNov, sum(LastDec) as LastDec');
               AccsDatamodule.BudgetReportSQL.SQL.add('from TempBudgetReport');
               AccsDatamodule.BudgetReportSQL.SQL.add('where reportgrp > 0');
               AccsDatamodule.BudgetReportSQL.SQL.add('group by reportgrp');
               AccsDatamodule.BudgetReportSQL.ExecSQL;
               AccsDatamodule.BudgetReportSQL.active := true;
          end;

     if not Bool(BudgetReportForm.BudgetReport) then Application.CreateForm(TBudgetReport, BudgetReport);

     if RGAccountGroup.itemindex = 0 then begin
           BudgetReport.NominalLabel.Caption := 'Nominal Code';
           BudgetReport.QRDBText1.DataField := 'NominalID';
           BudgetReport.QRDBText2.DataField := 'NomName';
        end
        else begin
           BudgetReport.NominalLabel.Caption := 'Report Group';
           BudgetReport.QRDBText1.DataField := 'reportgrp';
           BudgetReport.QRDBText2.DataField := 'grpname';

        end;
     if Validationarray[1] = false then BudgetReport.Actuallbl1.Font.Color := clblue
        else BudgetReport.Actuallbl1.Font.Color := clblack;
     if Validationarray[2] = false then BudgetReport.Actuallbl2.Font.Color := clblue
        else BudgetReport.Actuallbl2.Font.Color := clblack;
     if Validationarray[3] = false then BudgetReport.Actuallbl3.Font.Color := clblue
        else BudgetReport.Actuallbl3.Font.Color := clblack;
     if Validationarray[4] = false then BudgetReport.Actuallbl4.Font.Color := clblue
        else BudgetReport.Actuallbl4.Font.Color := clblack;
     if Validationarray[5] = false then BudgetReport.Actuallbl5.Font.Color := clblue
        else BudgetReport.Actuallbl5.Font.Color := clblack;
     if Validationarray[6] = false then BudgetReport.Actuallbl6.Font.Color := clblue
        else BudgetReport.Actuallbl6.Font.Color := clblack;
     if Validationarray[7] = false then BudgetReport.Actuallbl7.Font.Color := clblue
        else BudgetReport.Actuallbl7.Font.Color := clblack;
     if Validationarray[8] = false then BudgetReport.Actuallbl8.Font.Color := clblue
        else BudgetReport.Actuallbl8.Font.Color := clblack;
     if Validationarray[9] = false then BudgetReport.Actuallbl9.Font.Color := clblue
        else BudgetReport.Actuallbl9.Font.Color := clblack;
     if Validationarray[10] = false then BudgetReport.Actuallbl10.Font.Color := clblue
        else BudgetReport.Actuallbl10.Font.Color := clblack;
     if Validationarray[11] = false then BudgetReport.Actuallbl11.Font.Color := clblue
        else BudgetReport.Actuallbl11.Font.Color := clblack;
     if Validationarray[12] = false then BudgetReport.Actuallbl12.Font.Color := clblue
        else BudgetReport.Actuallbl12.Font.Color := clblack;

     BudgetReport.ActualYear.Font.Color := clblack;

     for i:= 1 to 12 do begin
        if ValidationArray[i] = false then BudgetReport.ActualYear.Font.Color := clblue;
     end;

     if cbIncludeLastYear.checked = False then begin
        BudgetReport.DetailBand1.Height := 44;  //34
        BudgetReport.LastYearLabel.enabled := false;
        BudgetReport.QRDBText29.enabled := False;
        BudgetReport.QRDBText30.enabled := False;
        BudgetReport.QRDBText31.enabled := False;
        BudgetReport.QRDBText32.enabled := False;
        BudgetReport.QRDBText33.enabled := False;
        BudgetReport.QRDBText34.enabled := False;
        BudgetReport.QRDBText35.enabled := False;
        BudgetReport.QRDBText36.enabled := False;
        BudgetReport.QRDBText37.enabled := False;
        BudgetReport.QRDBText38.enabled := False;
        BudgetReport.QRDBText39.enabled := False;
        BudgetReport.QRDBText40.enabled := False;
        BudgetReport.QRDBText41.enabled := False;
     end
        else begin
        BudgetReport.DetailBand1.Height := 58;  //48
        BudgetReport.LastYearLabel.enabled := true;
        BudgetReport.QRDBText29.enabled := True;
        BudgetReport.QRDBText30.enabled := True;
        BudgetReport.QRDBText31.enabled := True;
        BudgetReport.QRDBText32.enabled := True;
        BudgetReport.QRDBText33.enabled := True;
        BudgetReport.QRDBText34.enabled := True;
        BudgetReport.QRDBText35.enabled := True;
        BudgetReport.QRDBText36.enabled := True;
        BudgetReport.QRDBText37.enabled := True;
        BudgetReport.QRDBText38.enabled := True;
        BudgetReport.QRDBText39.enabled := True;
        BudgetReport.QRDBText40.enabled := True;
        BudgetReport.QRDBText41.enabled := True;
     end;

     BudgetReport.KingswoodLbl.caption:= 'Kingswood Accounts ' +  VerNo;

     BudgetReport.preview;

end;

procedure TSetupBudgetReportsForm.FormShow(Sender: TObject);
begin
     rgAccountGroup.itemindex := 0;
     cbIncludeLastYear.checked := false;
     RepSearch.Date := KStrToDate ( Cash11.Default_Date );
     RepDate.Text := Cash1.xDate;

end;

procedure TSetupBudgetReportsForm.RepSearchCloseUp(Sender: TObject);
begin
     RepDate.Text:= DateToStr(RepSearch.Date);
end;

procedure TSetupBudgetReportsForm.RepDateExit(Sender: TObject);
Var
   TestDate : ShortString;
begin
     TestDate := '';
     TestDate := RepDate.Text;
     If NOT DateValid ( RepDate.Text, TDateFormat ) Then
        RepDate.SetFocus
end;

end.
