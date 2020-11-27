unit uEnterpriseLineSeriesData;

interface
uses
   db, dbTables, Classes, SysUtils, Graphics;

type
  TSeriesData = array [1..13] of Double;
  TEnterpriseLineSeriesData = class
  private
     FEntCode : string;
     Dataset : TQuery;
  public
     EnterpriseName : string;
     EnterpriseColour : TColor;
     ThisYearDataInc,
     ThisYearDataExp,
     LastYearDataInc,
     LastYearDataExp,
     ThisYearMargin,
     LastYearMargin  : TSeriesData;
     constructor Create(AEnterpriseName : string);
     destructor destroy;override;
     procedure LoadData;
  end;

implementation
uses
   AccsData, VARS;

{ TEnterpriseLineSeriesData }

constructor TEnterpriseLineSeriesData.Create(AEnterpriseName : string);
begin
   EnterpriseName := AEnterpriseName;

   Dataset := TQuery.create(nil);
   Dataset.DatabaseName := AccsDataModule.AccsDataBase.DatabaseName;

   FillChar( ThisYearDataInc, SizeOf(ThisYearDataInc), 0);
   FillChar( ThisYearDataExp, SizeOf(ThisYearDataExp), 0);
   FillChar( LastYearDataInc, SizeOf(LastYearDataInc), 0);
   FillChar( LastYearDataInc, SizeOf(LastYearDataInc), 0);
   FillChar( ThisYearMargin, SizeOf(ThisYearMargin), 0);
   FillChar( LastYearMargin, SizeOf(LastYearMargin), 0);

   EnterpriseColour := clDefault;
end;

destructor TEnterpriseLineSeriesData.destroy;
begin
   Dataset.Close;
   FreeAndNil(Dataset);
   inherited;
end;

procedure TEnterpriseLineSeriesData.LoadData;
var
   i : Integer;
   MonthIndex : Integer;
begin
   FillChar( ThisYearDataInc, SizeOf(ThisYearDataInc), 0);
   FillChar( ThisYearDataExp, SizeOf(ThisYearDataExp), 0);
   FillChar( LastYearDataInc, SizeOf(LastYearDataInc), 0);
   FillChar( LastYearDataExp, SizeOf(LastYearDataExp), 0);
   FillChar( ThisYearMargin, SizeOf(ThisYearMargin), 0);
   FillChar( LastYearMargin, SizeOf(LastYearMargin), 0);

   with TQuery.Create(nil) do
      try
         DatabaseName := AccsDataModule.AccsDataBase.DatabaseName;
         SQL.Clear;
         SQL.Add('SELECT E.EntCode, E.EntColor');
         SQL.Add('FROM tEntsTable E ');
         SQL.Add('WHERE E.EntName =:ENTNAME');
         Params[0].AsString := EnterpriseName;
         Open;
         First;
         FEntCode := Fields[0].AsString;
         if (Length(Trim(Fields[1].AsString))>0) then
            EnterpriseColour := StringToColor(Fields[1].AsString);
      finally
         Free;
      end;

   with Dataset do
      begin
         Close;
         SQL.Clear;
         // This year Inc
         SQL.Add('SELECT SUM(ActualJan), SUM(ActualFeb), SUM(ActualMar), SUM(ActualApr), SUM(ActualMay),');
         SQL.Add('       SUM(ActualJun), SUM(ActualJul), SUM(ActualAug), SUM(ActualSep), SUM(ActualOct),');
         SQL.Add('       SUM(ActualNov), SUM(ActualDec)');
         SQL.Add('FROM tmpYearlyData ');
         SQL.Add('WHERE (EnterpriseCode =:EntCode)');
         SQL.Add('AND (NomType =:NomType)');

         Params[0].AsString := FEntCode;
         Params[1].AsString := 'Income';
         Open;

         First;
         try
             MonthIndex := 1;
             for i:=cash1.xfinmonth to 12 do
                begin
                   ThisYearDataInc[MonthIndex] := Fields[i-1].AsFloat;
                   Inc(MonthIndex);
                end;

             for i := 1 to cash1.xfinmonth-1 do
                begin
                   ThisYearDataInc[MonthIndex] := Fields[i-1].AsFloat;
                   Inc(MonthIndex);
                end;

             {ThisYearDataInc[1] := Fields[0].AsFloat;
             ThisYearDataInc[2] := Fields[1].AsFloat;
             ThisYearDataInc[3] := Fields[2].AsFloat;
             ThisYearDataInc[4] := Fields[3].AsFloat;
             ThisYearDataInc[5] := Fields[4].AsFloat;
             ThisYearDataInc[6] := Fields[5].AsFloat;
             ThisYearDataInc[7] := Fields[6].AsFloat;
             ThisYearDataInc[8] := Fields[7].AsFloat;
             ThisYearDataInc[9] := Fields[8].AsFloat;
             ThisYearDataInc[10] := Fields[9].AsFloat;
             ThisYearDataInc[11] := Fields[10].AsFloat;
             ThisYearDataInc[12] := Fields[11].AsFloat;}

             for i := 1 to 12 do
                ThisYearDataInc[13] := ThisYearDataInc[13] + ThisYearDataInc[i];

         finally
            Close;
         end;

         Params[0].AsString := FEntCode;
         Params[1].AsString := 'Expense';
         Open;

         First;
         try
             MonthIndex := 1;
             for i:=cash1.xfinmonth to 12 do
                begin
                   ThisYearDataExp[MonthIndex] := Fields[i-1].AsFloat;
                   Inc(MonthIndex);
                end;

             for i := 1 to cash1.xfinmonth-1 do
                begin
                   ThisYearDataExp[MonthIndex] := Fields[i-1].AsFloat;
                   Inc(MonthIndex);
                end;


             {ThisYearDataExp[1] := Fields[0].AsFloat;
             ThisYearDataExp[2] := Fields[1].AsFloat;
             ThisYearDataExp[3] := Fields[2].AsFloat;
             ThisYearDataExp[4] := Fields[3].AsFloat;
             ThisYearDataExp[5] := Fields[4].AsFloat;
             ThisYearDataExp[6] := Fields[5].AsFloat;
             ThisYearDataExp[7] := Fields[6].AsFloat;
             ThisYearDataExp[8] := Fields[7].AsFloat;
             ThisYearDataExp[9] := Fields[8].AsFloat;
             ThisYearDataExp[10] := Fields[9].AsFloat;
             ThisYearDataExp[11] := Fields[10].AsFloat;
             ThisYearDataExp[12] := Fields[11].AsFloat;}

             for i := 1 to 12 do
                ThisYearDataExp[13] := ThisYearDataExp[13] + ThisYearDataExp[i];

         finally
            Close;
         end;

         // Last Year
         SQL.Clear;
         SQL.Add('SELECT SUM(LYJan), SUM(LYFeb), SUM(LYMar), SUM(LYApr), SUM(LYMay),');
         SQL.Add('       SUM(LYJun), SUM(LYJul), SUM(LYAug), SUM(LYSep), SUM(LYOct),');
         SQL.Add('       SUM(LYNov), SUM(LYDec)');
         SQL.Add('FROM tmpYearlyData ');
         SQL.Add('WHERE (EnterpriseCode =:EntCode)');
         SQL.Add('AND (NomType =:NomType)');

         Params[0].AsString := FEntCode;
         Params[1].AsString := 'Income';
         Open;

         First;
         try
             MonthIndex := 1;
             for i:=cash1.xfinmonth to 12 do
                begin
                   LastYearDataInc[MonthIndex] := Fields[i-1].AsFloat;
                   Inc(MonthIndex);
                end;

             for i := 1 to cash1.xfinmonth-1 do
                begin
                   LastYearDataInc[MonthIndex] := Fields[i-1].AsFloat;
                   Inc(MonthIndex);
                end;

             {LastYearDataInc[1] := Fields[0].AsFloat;
             LastYearDataInc[2] := Fields[1].AsFloat;
             LastYearDataInc[3] := Fields[2].AsFloat;
             LastYearDataInc[4] := Fields[3].AsFloat;
             LastYearDataInc[5] := Fields[4].AsFloat;
             LastYearDataInc[6] := Fields[5].AsFloat;
             LastYearDataInc[7] := Fields[6].AsFloat;
             LastYearDataInc[8] := Fields[7].AsFloat;
             LastYearDataInc[9] := Fields[8].AsFloat;
             LastYearDataInc[10] := Fields[9].AsFloat;
             LastYearDataInc[11] := Fields[10].AsFloat;
             LastYearDataInc[12] := Fields[11].AsFloat;}

             for i := 1 to 12 do
                LastYearDataInc[13] := LastYearDataInc[13] + LastYearDataInc[i];
         finally
            Close;
         end;

         Params[0].AsString := FEntCode;
         Params[1].AsString := 'Expense';
         Open;

         First;
         try
             {LastYearDataExp[1] := Fields[0].AsFloat;
             LastYearDataExp[2] := Fields[1].AsFloat;
             LastYearDataExp[3] := Fields[2].AsFloat;
             LastYearDataExp[4] := Fields[3].AsFloat;
             LastYearDataExp[5] := Fields[4].AsFloat;
             LastYearDataExp[6] := Fields[5].AsFloat;
             LastYearDataExp[7] := Fields[6].AsFloat;
             LastYearDataExp[8] := Fields[7].AsFloat;
             LastYearDataExp[9] := Fields[8].AsFloat;
             LastYearDataExp[10] := Fields[9].AsFloat;
             LastYearDataExp[11] := Fields[10].AsFloat;
             LastYearDataExp[12] := Fields[11].AsFloat;}

             MonthIndex := 1;
             for i:=cash1.xfinmonth to 12 do
                begin
                   LastYearDataExp[MonthIndex] := Fields[i-1].AsFloat;
                   Inc(MonthIndex);
                end;

             for i := 1 to cash1.xfinmonth-1 do
                begin
                   LastYearDataExp[MonthIndex] := Fields[i-1].AsFloat;
                   Inc(MonthIndex);
                end;

             for i := 1 to 12 do
                LastYearDataExp[13] := LastYearDataExp[13] + LastYearDataExp[i];
         finally
            Close;
         end;

         for i := 1 to 12 do
            begin
               ThisYearMargin[i] := ThisYearDataInc[i] - ThisYearDataExp[i];
               LastYearMargin[i] := LastYearDataInc[i] - LastYearDataExp[i];
               ThisYearMargin[13] := ThisYearMargin[13] + ThisYearMargin[i];
               LastYearMargin[13] := LastYearMargin[13] + LastYearMargin[i];
            end;

      end;
end;

end.
