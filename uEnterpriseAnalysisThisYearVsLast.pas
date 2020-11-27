unit uEnterpriseAnalysisThisYearVsLast;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls, dialogs, shellapi;

type
  TEnterpriseAnalysisThisYearVsLast = class(TQuickRep)
    PageHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    PageFooterBand1: TQRBand;
    BottomLine: TQRShape;
    KingswoodLbl: TQRLabel;
    PageNumber: TQRSysData;
    TimeLbl: TQRSysData;
    PrintDateLbl: TQRLabel;
    ReportDate: TQRLabel;
    ReportDateLbl: TQRLabel;
    Heading: TQRLabel;
    TopLine2: TQRShape;
    TopLine1: TQRShape;
    Company: TQRLabel;
    Dataset: TQRLabel;
    QRDBText4: TQRDBText;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    KingsAccFooter: TQRLabel;
  private
    function GetEntDetails(EntCode: Variant) : Boolean;
    procedure ProcessNominals;
    procedure InsertHeader;
    procedure DateCalculation;
  public
    procedure RunReport;


  end;

var
  EnterpriseAnalysisThisYearVsLast: TEnterpriseAnalysisThisYearVsLast;
  PageLineCount : integer;
  Ent, EntName, UnitText : string;
  IncFrom, IncTo, ExpFrom, ExpTo : Integer;
  UnitDiv : Real;
  CurrMonth : integer;
  MonthArray : array[1..12] of boolean;

implementation

uses
  vars, types, params, AccsData, Entreps;

{$R *.DFM}

procedure TEnterpriseAnalysisThisYearVsLast.Runreport;
var
        i : integer;
begin

     Accsdatamodule.EnterpriseAnalysisReportDB.close;
     if FileExists  (Accsdatamodule.AccsDataBase.Directory + 'EnterpriseAnalysisReportTable.db' ) then begin
         try DeleteFile  (Accsdatamodule.AccsDataBase.Directory + 'EnterpriseAnalysisReportTable.db' );
         except showmessage('Error Deleting Enterprise Analysis Report Table!');
         end;
     end;

     try Accsdatamodule.CreateEnterpriseAnalysisReportTable;
     except showmessage('Error Creating Enterprise Analysis Report Table!');
     end;

     Accsdatamodule.EnterpriseAnalysisReportDB.open;

     try
         // SP 18/01/2011 - try finally
         Application.CreateForm(TEnterpriseAnalysisThisYearVsLast, EnterpriseAnalysisThisYearVsLast);
         with EnterpriseAnalysisThisYearVsLast do
            try

               ReportDate.Caption := Cash11.DEFAULT_DATE;
               KingswoodLbl.caption := 'Kingswood Accounts ' + VerNo;
               Company.Caption := cash1.XCOMPANY;
               dataset.caption := RFarmGate.PLocation[2];
               CurrMonth := strtoint(EntCostPerUnit.Calmonth.text);
               PageLineCount := 0;
               DateCalculation;

               if ((EntCostPerUnit.EntCode.text <> '') and (EntCostPerUnit.EntCode.text <> ' ')) then begin
                      if GetEntDetails(EntCostPerUnit.EntCode.text) then
                         ProcessNominals;
               end else begin

                    Accsdatamodule.EntsFileDB.open;
                    Accsdatamodule.EntsFileDB.first;
                    for i:=1 to Accsdatamodule.EntsFileDB.recordcount do begin
                        if Accsdatamodule.EntsFileDB['Active'] = true then begin
                            if GetEntDetails(Accsdatamodule.EntsFileDB['EntCode']) then
                               ProcessNominals;
                        end;
                    Accsdatamodule.EntsFileDB.next;
                    end;
               end;
               preview;
            finally
               if EnterpriseAnalysisThisYearVsLast <> nil then
                  FreeAndNil(EnterpriseAnalysisThisYearVsLast);
            end;
     except
        on e : Exception do
           ShowMessage(e.message);
     end;

end;

procedure TEnterpriseAnalysisThisYearVsLast.DateCalculation;
var
   StartMonth, i : integer;
begin
   StartMonth := Cash1.XFINMONTH;

   for i:= 1 to 12 do begin
       MonthArray[i] := False;
   end;

   if currmonth >= startmonth then begin
       for i:= startmonth to currmonth do begin
            MonthArray[i] := true;
       end;
   end
       else begin
           for i:= startmonth to 12 do begin
                MonthArray[i] := true;
           end;
           for i:= 1 to currmonth do begin
                MonthArray[i] := true;
           end;
       end;
end;



function TEnterpriseAnalysisThisYearVsLast.GetEntDetails(EntCode: Variant) : Boolean;
begin
   Result := False;
   if VarIsNull(EntCode) or VarIsEmpty(EntCode) then Exit;   // SP 18/01/2011

        Accsdatamodule.EntsFileDB.open;
        Accsdatamodule.EntsFileDB.first;

        try Accsdatamodule.EntsFileDB.Locate('EntCode',EntCode,[]);
            if Accsdatamodule.EntsFileDB['Active'] = True then begin
                Ent := Accsdatamodule.EntsFileDB['EntCode'];
                EntName := Copy (Accsdatamodule.EntsFileDB['EntName'], 1, 17 );
     //           UnitText := '';
     //           if Accsdatamodule.EntsFileDB['UnitText'] <> null then UnitText := Accsdatamodule.EntsFileDB['UnitText'];
                IncFrom := Accsdatamodule.EntsFileDB['IncFrom'];
                IncTo := Accsdatamodule.EntsFileDB['IncTo'];
                ExpFrom := Accsdatamodule.EntsFileDB['ExpFrom'];
                ExpTo := Accsdatamodule.EntsFileDB['ExpTo'];
     //           UnitDiv := Accsdatamodule.EntsFileDB['UnitDiv'];

                if Pagelinecount <> 0 then begin
                    while Pagelinecount <> 0 do begin
                          Accsdatamodule.EnterpriseAnalysisReportDB.edit;
                          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
                          Accsdatamodule.EnterpriseAnalysisReportDB.post;
                          inc(Pagelinecount);
                          if Pagelinecount = 50 then pagelinecount := 0;
                    end;
                end;
               Result := True;
            end;
        except
            showmessage ('No Enterprise match found for - ' + EntCode);
        end;
end;

procedure TEnterpriseAnalysisThisYearVsLast.InsertHeader;
begin
                Accsdatamodule.EnterpriseAnalysisReportDB.edit;

                Accsdatamodule.EnterpriseAnalysisReportDB.Append;
                Accsdatamodule.EnterpriseAnalysisReportDB['LineLabel'] := 'Enterprise                                 This Month : This Year       Last Year         Budget         YTD : This Year        Last Year       Budget         Annual Budget';
                Accsdatamodule.EnterpriseAnalysisReportDB.post;
                Pagelinecount := Pagelinecount + 1;
                Accsdatamodule.EnterpriseAnalysisReportDB.Append;
                Accsdatamodule.EnterpriseAnalysisReportDB['LineLabel'] := '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
                Accsdatamodule.EnterpriseAnalysisReportDB.post;
                Pagelinecount := Pagelinecount + 1;
                Accsdatamodule.EnterpriseAnalysisReportDB.Append;
                Accsdatamodule.EnterpriseAnalysisReportDB['BoldLineLabel'] := Ent + ' - ' + EntName;
                Accsdatamodule.EnterpriseAnalysisReportDB.post;
                Pagelinecount := Pagelinecount + 1;
                Accsdatamodule.EnterpriseAnalysisReportDB.Append;
                Accsdatamodule.EnterpriseAnalysisReportDB['LineLabel'] := '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
                Accsdatamodule.EnterpriseAnalysisReportDB.post;
                Pagelinecount := Pagelinecount + 1;
end;

procedure  TEnterpriseAnalysisThisYearVsLast.ProcessNominals;
var
    i: integer;
    YTD_ThisYear, YTD_LastYear, YTD_Budget : real;
    IncThisYr, IncLastYr, IncBudget, Inc_YTD_ThisYr, Inc_YTD_LastYr, Inc_YTD_Budget, Inc_Annual : real;
    ExpThisYr, ExpLastYr, ExpBudget, Exp_YTD_ThisYr, Exp_YTD_LastYr, Exp_YTD_Budget, Exp_Annual : real;
begin

          IncThisYr := 0;
          IncLastYr := 0;
          IncBudget := 0;
          Inc_YTD_ThisYr := 0;
          Inc_YTD_LastYr := 0;
          Inc_YTD_Budget := 0;
          Inc_Annual := 0;

          ExpThisYr := 0;
          ExpLastYr := 0;
          ExpBudget := 0;
          Exp_YTD_ThisYr := 0;
          Exp_YTD_LastYr := 0;
          Exp_YTD_Budget := 0;
          Exp_Annual := 0;

          Accsdatamodule.EnterpriseAnalysisReportDB.open;

          InsertHeader;

          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB['LineLabel'] := '';
          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;
          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB['BoldLineLabel'] := 'Enterprise Income';
          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;
          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB['LineLabel'] := '';
          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;

          Accsdatamodule.NLFileDB.open;
          Accsdatamodule.NLFileDB.locate('NLNo',IncFrom,[]);
          while Accsdatamodule.NLFileDB['NLNo'] <> IncTo+1 do begin
            if Accsdatamodule.NLFileDB['Active'] = True then begin // Ch003
                Accsdatamodule.EnterpriseAnalysisReportDB.Append;
                Accsdatamodule.EnterpriseAnalysisReportDB['Code'] := vartostr(Accsdatamodule.NLFileDB['NLNo']);
                Accsdatamodule.EnterpriseAnalysisReportDB['Description'] := Accsdatamodule.NLFileDB['Name'];
                case CurrMonth of
                    1: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer01'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer01'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer01'] * -1;
                    end;
                    2: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer02'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer02'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer02'] * -1;
                    end;
                    3: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer03'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer03'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer03'] * -1;
                    end;
                    4: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer04'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer04'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer04'] * -1;
                    end;
                    5: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer05'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer05'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer05'] * -1;
                    end;
                    6: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer06'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer06'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer06'] * -1;
                    end;
                    7: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer07'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer07'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer07'] * -1;
                    end;
                    8: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer08'] * -1 ;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer08'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer08'] * -1;
                    end;
                    9: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer09'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer09'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer09'] * -1;
                    end;
                    10: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer10'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer10'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer10'] * -1;
                    end;
                    11: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer11'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer11'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer11'] * -1;
                    end;
                    12: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer12'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer12'] * -1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer12'] * -1;
                    end;

                end;

                IncThisYr := IncThisYr + Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'];
                IncLastYr := IncLastYr + Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'];
                IncBudget := IncBudget + Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'];


                YTD_ThisYear := 0;
                YTD_LastYear := 0;
                YTD_Budget := 0;

                for i:= 1 to 12 do begin
                    if MonthArray[i] = true then begin
                        case i of
                        1 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer01'] * -1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer01'] * -1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer01'] * -1);
                            end;
                        2 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer02'] * -1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer02'] * -1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer02'] * -1);
                            end;
                        3 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer03'] * -1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer03'] * -1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer03'] * -1);
                            end;
                        4 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer04'] * -1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer04'] * -1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer04'] * -1);
                            end;
                        5 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer05'] * -1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer05'] * -1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer05'] * -1);
                            end;
                        6 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer06'] * -1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer06'] * -1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer06'] * -1);
                            end;
                        7 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer07'] * -1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer07'] * -1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer07'] * -1);
                            end;
                        8 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer08'] * -1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer08'] * -1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer08'] * -1);
                            end;
                        9 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer09'] * -1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer09'] * -1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer09'] * -1);
                            end;
                        10 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer10'] * -1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer10'] * -1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer10'] * -1);
                            end;
                        11 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer11'] * -1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer11'] * -1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer11'] * -1);
                            end;
                        12 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer12'] * -1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer12'] * -1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer12'] * -1);
                            end;
                        end;
                    end;
                end;

                Accsdatamodule.EnterpriseAnalysisReportDB['YTD_ThisYear'] := YTD_ThisYear;
                Accsdatamodule.EnterpriseAnalysisReportDB['YTD_LastYear'] := YTD_LastYear;
                Accsdatamodule.EnterpriseAnalysisReportDB['YTD_Budget'] := YTD_Budget;
                Accsdatamodule.EnterpriseAnalysisReportDB['Annual_Budget'] := (Accsdatamodule.NLFileDB['BudPer01'] * -1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer02'] * -1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer03'] * -1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer04'] * -1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer05'] * -1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer06'] * -1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer07'] * -1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer08'] * -1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer09'] * -1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer10'] * -1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer11'] * -1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer12'] * -1);

                Inc_YTD_ThisYr := Inc_YTD_ThisYr + Accsdatamodule.EnterpriseAnalysisReportDB['YTD_ThisYear'];
                Inc_YTD_LastYr := Inc_YTD_LastYr + Accsdatamodule.EnterpriseAnalysisReportDB['YTD_LastYear'];
                Inc_YTD_Budget := Inc_YTD_Budget + Accsdatamodule.EnterpriseAnalysisReportDB['YTD_Budget'];
                Inc_Annual := Inc_Annual + Accsdatamodule.EnterpriseAnalysisReportDB['Annual_Budget'];

                Accsdatamodule.EnterpriseAnalysisReportDB.post;


                Pagelinecount := Pagelinecount + 1;
                If Pagelinecount = 50 then begin
                   Pagelinecount := 0;
                   InsertHeader;
                end;
              end;   // Ch003
                Accsdatamodule.NLFileDB.Next;
          end;

          if Pagelinecount >= 46 then begin
             while Pagelinecount <> 50 do begin
                   Accsdatamodule.EnterpriseAnalysisReportDB.Append;
                   Accsdatamodule.EnterpriseAnalysisReportDB.post;
                   Pagelinecount := Pagelinecount + 1;
             end;
             Pagelinecount := 0;
             InsertHeader;
          end;

          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;
           Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB['BoldLineLabel'] := 'Total Enterprise Income';

          Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := IncThisYr;
          Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := IncLastYr;
          Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := IncBudget;
          Accsdatamodule.EnterpriseAnalysisReportDB['YTD_ThisYear'] := Inc_YTD_ThisYr;
          Accsdatamodule.EnterpriseAnalysisReportDB['YTD_LastYear'] := Inc_YTD_LastYr;
          Accsdatamodule.EnterpriseAnalysisReportDB['YTD_Budget'] := Inc_YTD_Budget;
          Accsdatamodule.EnterpriseAnalysisReportDB['Annual_Budget'] := Inc_Annual;

          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;



          if Pagelinecount > 40 then begin
             while Pagelinecount <> 50 do begin
                   Accsdatamodule.EnterpriseAnalysisReportDB.Append;
                   Accsdatamodule.EnterpriseAnalysisReportDB.post;
                   Pagelinecount := Pagelinecount + 1;
             end;
             Pagelinecount := 0;
             InsertHeader;
          end;

          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB['LineLabel'] := '';
          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;
          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB['BoldLineLabel'] := 'Enterprise Expenditure';
          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;
          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB['LineLabel'] := '';
          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;

          Accsdatamodule.NLFileDB.open;
          Accsdatamodule.NLFileDB.locate('NLNo',ExpFrom,[]);
          while Accsdatamodule.NLFileDB['NLNo'] <> ExpTo+1 do begin
             if Accsdatamodule.NLFileDB['Active'] = True then begin // Ch003
                Accsdatamodule.EnterpriseAnalysisReportDB.Append;
                Accsdatamodule.EnterpriseAnalysisReportDB['Code'] := vartostr(Accsdatamodule.NLFileDB['NLNo']);
                Accsdatamodule.EnterpriseAnalysisReportDB['Description'] := Accsdatamodule.NLFileDB['Name'];
                case CurrMonth of
                    1: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer01'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer01'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer01'] * 1;
                    end;
                    2: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer02'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer02'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer02'] * 1;
                    end;
                    3: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer03'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer03'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer03'] * 1;
                    end;
                    4: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer04'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer04'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer04'] * 1;
                    end;
                    5: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer05'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer05'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer05'] * 1;
                    end;
                    6: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer06'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer06'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer06'] * 1;
                    end;
                    7: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer07'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer07'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer07'] * 1;
                    end;
                    8: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer08'] * 1 ;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer08'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer08'] * 1;
                    end;
                    9: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer09'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer09'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer09'] * 1;
                    end;
                    10: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer10'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer10'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer10'] * 1;
                    end;
                    11: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer11'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer11'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer11'] * 1;
                    end;
                    12: begin
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := Accsdatamodule.NLFileDB['ActPer12'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := Accsdatamodule.NLFileDB['LstPer12'] * 1;
                       Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := Accsdatamodule.NLFileDB['BudPer12'] * 1;
                    end;

                end;

                ExpThisYr := ExpThisYr + Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'];
                ExpLastYr := ExpLastYr + Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'];
                ExpBudget := ExpBudget + Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'];

                YTD_ThisYear := 0;
                YTD_LastYear := 0;
                YTD_Budget := 0;

                for i:= 1 to 12 do begin
                    if MonthArray[i] = true then begin
                        case i of
                        1 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer01'] * 1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer01'] * 1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer01'] * 1);
                            end;
                        2 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer02'] * 1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer02'] * 1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer02'] * 1);
                            end;
                        3 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer03'] * 1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer03'] * 1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer03'] * 1);
                            end;
                        4 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer04'] * 1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer04'] * 1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer04'] * 1);
                            end;
                        5 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer05'] * 1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer05'] * 1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer05'] * 1);
                            end;
                        6 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer06'] * 1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer06'] * 1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer06'] * 1);
                            end;
                        7 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer07'] * 1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer07'] * 1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer07'] * 1);
                            end;
                        8 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer08'] * 1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer08'] * 1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer08'] * 1);
                            end;
                        9 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer09'] * 1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer09'] * 1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer09'] * 1);
                            end;
                        10 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer10'] * 1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer10'] * 1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer10'] * 1);
                            end;
                        11 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer11'] * 1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer11'] * 1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer11'] * 1);
                            end;
                        12 : begin
                            YTD_ThisYear := YTD_ThisYear + (Accsdatamodule.NLFileDB['ActPer12'] * 1);
                            YTD_LastYear := YTD_LastYear + (Accsdatamodule.NLFileDB['LstPer12'] * 1);
                            YTD_Budget := YTD_Budget + (Accsdatamodule.NLFileDB['BudPer12'] * 1);
                            end;
                        end;
                    end;
                end;

                Accsdatamodule.EnterpriseAnalysisReportDB['YTD_ThisYear'] := YTD_ThisYear;
                Accsdatamodule.EnterpriseAnalysisReportDB['YTD_LastYear'] := YTD_LastYear;
                Accsdatamodule.EnterpriseAnalysisReportDB['YTD_Budget'] := YTD_Budget;
                Accsdatamodule.EnterpriseAnalysisReportDB['Annual_Budget'] := (Accsdatamodule.NLFileDB['BudPer01'] * 1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer02'] * 1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer03'] * 1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer04'] * 1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer05'] * 1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer06'] * 1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer07'] * 1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer08'] * 1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer09'] * 1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer10'] * 1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer11'] * 1)
                                                                         + (Accsdatamodule.NLFileDB['BudPer12'] * 1);

                Exp_YTD_ThisYr := Exp_YTD_ThisYr + Accsdatamodule.EnterpriseAnalysisReportDB['YTD_ThisYear'];
                Exp_YTD_LastYr := Exp_YTD_LastYr + Accsdatamodule.EnterpriseAnalysisReportDB['YTD_LastYear'];
                Exp_YTD_Budget := Exp_YTD_Budget + Accsdatamodule.EnterpriseAnalysisReportDB['YTD_Budget'];
                Exp_Annual := Exp_Annual + Accsdatamodule.EnterpriseAnalysisReportDB['Annual_Budget'];

                Accsdatamodule.EnterpriseAnalysisReportDB.post;


                Pagelinecount := Pagelinecount + 1;
                If Pagelinecount = 50 then begin
                   Pagelinecount := 0;
                   InsertHeader;
                end;
             end;  // Ch003
                Accsdatamodule.NLFileDB.Next;
          end;

          if Pagelinecount >= 46 then begin
             while Pagelinecount <> 50 do begin
                   Accsdatamodule.EnterpriseAnalysisReportDB.Append;
                   Accsdatamodule.EnterpriseAnalysisReportDB.post;
                   Pagelinecount := Pagelinecount + 1;
             end;
             Pagelinecount := 0;
             InsertHeader;
          end;

          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;

          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB['BoldLineLabel'] := 'Total Enterprise Expenditure';

          Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := ExpThisYr;
          Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := ExpLastYr;
          Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := ExpBudget;
          Accsdatamodule.EnterpriseAnalysisReportDB['YTD_ThisYear'] := Exp_YTD_ThisYr;
          Accsdatamodule.EnterpriseAnalysisReportDB['YTD_LastYear'] := Exp_YTD_LastYr;
          Accsdatamodule.EnterpriseAnalysisReportDB['YTD_Budget'] := Exp_YTD_Budget;
          Accsdatamodule.EnterpriseAnalysisReportDB['Annual_Budget'] := Exp_Annual;

          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;



          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;
          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB['LineLabel'] := '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;
          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB['BoldLineLabel'] := 'Enterprise Gross Margin';

          Accsdatamodule.EnterpriseAnalysisReportDB['Month_ThisYear'] := IncThisYr - ExpThisYr;
          Accsdatamodule.EnterpriseAnalysisReportDB['Month_LastYear'] := IncLastYr - ExpLastYr;
          Accsdatamodule.EnterpriseAnalysisReportDB['Month_Budget'] := IncBudget - ExpBudget;
          Accsdatamodule.EnterpriseAnalysisReportDB['YTD_ThisYear'] := Inc_YTD_ThisYr - Exp_YTD_ThisYr;
          Accsdatamodule.EnterpriseAnalysisReportDB['YTD_LastYear'] := Inc_YTD_LastYr - Exp_YTD_LastYr;
          Accsdatamodule.EnterpriseAnalysisReportDB['YTD_Budget'] := Inc_YTD_Budget - Exp_YTD_Budget;
          Accsdatamodule.EnterpriseAnalysisReportDB['Annual_Budget'] := Inc_Annual - Exp_Annual;

          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;
          Accsdatamodule.EnterpriseAnalysisReportDB.Append;
          Accsdatamodule.EnterpriseAnalysisReportDB['LineLabel'] := '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
          Accsdatamodule.EnterpriseAnalysisReportDB.post;
          Pagelinecount := Pagelinecount + 1;

end;


end.
