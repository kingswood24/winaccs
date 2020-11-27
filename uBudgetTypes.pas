unit uBudgetTypes;

{  calculates the nominal account actual figure for each month  }
interface
uses
   Classes, SysUtils, Windows, Messages, TYPES, uAccounts;


type
  TMonthlyData = class
  private
    FDecTotal: double;
    FMayTotal: double;
    FJulTotal: double;
    FJanTotal: double;
    FOctTotal: double;
    FMarTotal: double;
    FNovTotal: double;
    FSepTotal: double;
    FAprTotal: double;
    FAugTotal: double;
    FYearTotal: double;
    FFebTotal: double;
    FJunTotal: double;
    function GetYearTotal: double;
  public
    constructor create;
    property YearTotal : double read GetYearTotal;
    property JanTotal : double read FJanTotal write FJanTotal;
    property FebTotal : double read FFebTotal write FFebTotal;
    property MarTotal : double read FMarTotal write FMarTotal;
    property AprTotal : double read FAprTotal write FAprTotal;
    property MayTotal : double read FMayTotal write FMayTotal;
    property JunTotal : double read FJunTotal write FJunTotal;
    property JulTotal : double read FJulTotal write FJulTotal;
    property AugTotal : double read FAugTotal write FAugTotal;
    property SepTotal : double read FSepTotal write FSepTotal;
    property OctTotal : double read FOctTotal write FOctTotal;
    property NovTotal : double read FNovTotal write FNovTotal;
    property DecTotal : double read FDecTotal write FDecTotal;
  end;

  TBudgetRecord = class(TNominalAccount)
  public
     { BudgetData : TMonthlyData; }
     ActualData : TMonthlyData;
     { LastYearData : TMonthlyData; }
     constructor create;
     destructor destroy;override;
  end;

  TValidationArray = array[1..12] of boolean;
  TBudgetCalculator = class(TList)
  private
    FValidationArray : TValidationArray;
    FCurrentMonth : Integer;
    function GetCount: Integer;
    function GetValidationArray: TValidationArray;
  protected
    procedure CalcMonthlyFigures(); // Calulates monthly figures (used as actual figures for this year) to output to budget;
    procedure ValidateMonths;
  public
    constructor create(const ACurrentMonth : Integer);
    destructor destroy;override;
    function Add(ABudgetRecord : TBudgetRecord): Integer;
    procedure Load;
    function GetBudgetRecordByNominalId(ANominalId : Integer) : TBudgetRecord;
    property Count : Integer read GetCount;
    property ValidationArray : TValidationArray read GetValidationArray;
  end;

implementation
uses
   AccsData,CalculateMonths, VARS;


{ TMonthlyData }

constructor TMonthlyData.create;
begin
   FDecTotal:= 0;
   FMayTotal:= 0;
   FJulTotal:= 0;
   FJanTotal:= 0;
   FOctTotal:= 0;
   FMarTotal:= 0;
   FNovTotal:= 0;
   FSepTotal:= 0;
   FAprTotal:= 0;
   FAugTotal:= 0;
   FYearTotal:= 0;
   FFebTotal:= 0;
   FJunTotal:= 0;
end;

function TMonthlyData.GetYearTotal: double;
begin
   Result := JanTotal + FebTotal + MarTotal + AprTotal +
             MayTotal + JunTotal + JulTotal + AugTotal +
             SepTotal + OctTotal + NovTotal + DecTotal ;
end;

{ TBudgetRecord }

constructor TBudgetRecord.create;
begin
  inherited create;
  ActualData := TMonthlyData.Create;

end;

destructor TBudgetRecord.destroy;
begin
  inherited;
  FreeAndNil(ActualData);
end;

{ TBudget }

function TBudgetCalculator.Add(ABudgetRecord: TBudgetRecord): Integer;
begin
   Result := inherited Add( TBudgetRecord(ABudgetRecord) );
end;

procedure TBudgetCalculator.CalcMonthlyFigures;
begin
   AccsDataModule.GetBudgetReportFigures; // gather all figures
   CalculateMonths.CalculateMonthlyValues; // update this years monthly figures using those calculated.
   ValidateMonths;
end;

constructor TBudgetCalculator.create(const ACurrentMonth: Integer);
begin
   inherited create;
   FCurrentMonth := ACurrentMonth;
   Load;
end;

destructor TBudgetCalculator.destroy;
var
   i : Integer;
begin
  for i := 0 to Count-1 do
     TBudgetRecord(Items[i]).Free;
  Inherited Clear;
end;

function TBudgetCalculator.GetBudgetRecordByNominalId(
  ANominalId: Integer): TBudgetRecord;
var
  i : Integer;
  BudgetRecord : TBudgetRecord;
begin
  Result := nil;
  for i := 0 to Count-1 do
     begin
        BudgetRecord := TBudgetRecord(Items[i]);
        if (BudgetRecord <> nil) then
           begin
              if ( BudgetRecord.Id = ANominalId ) then
                 begin
                    Result := BudgetRecord;
                    Break;
                 end;
           end;
     end;
end;

function TBudgetCalculator.GetCount: Integer;
begin
   Result := inherited Count;
end;

function TBudgetCalculator.GetValidationArray: TValidationArray;
begin
   Result := FValidationArray;
end;

procedure TBudgetCalculator.Load;
var
   BudgetRecord : TBudgetRecord;
   Value : Double;
   siValue : SmallInt;
begin
   CalcMonthlyFigures;

   with AccsDataModule.TempBudgetReportDB do
      try
         Open;
         First;
         while not eof do
            begin
               Edit;
               BudgetRecord := TBudgetRecord.create;
               BudgetRecord.Id := AccsDataModule.TempBudgetReportDB['NominalID'];
               siValue := BudgetRecord.Id;
               if ((( BudgetRecord.Id >= Cash1.xNomIncFrom) and (BudgetRecord.Id <= Cash1.xNomIncTo)) or
                   (( BudgetRecord.Id >= Cash1.xNomNonFrom) and (BudgetRecord.Id <= Cash1.xNomNonTo))  or
                   (( BudgetRecord.Id >= Cash1.xnomprvinc) and (BudgetRecord.Id <= Cash1.xnomprvexp-1))) then
                  begin
                     if FValidationArray[1] = true then
                        begin
                           Value := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month1/-100);
                           BudgetRecord.ActualData.JanTotal := Value;
                        end;
                        
                     if FValidationArray[2] = true then BudgetRecord.ActualData.FebTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month2/-100);
                     if FValidationArray[3] = true then BudgetRecord.ActualData.MarTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month3/-100);
                     if FValidationArray[4] = true then BudgetRecord.ActualData.AprTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month4/-100);
                     if FValidationArray[5] = true then BudgetRecord.ActualData.MayTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month5/-100);
                     if FValidationArray[6] = true then BudgetRecord.ActualData.JunTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month6/-100);
                     if FValidationArray[7] = true then BudgetRecord.ActualData.JulTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month7/-100);
                     if FValidationArray[8] = true then BudgetRecord.ActualData.AugTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month8/-100);
                     if FValidationArray[9] = true then BudgetRecord.ActualData.SepTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month9/-100);
                     if FValidationArray[10] = true then BudgetRecord.ActualData.OctTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month10/-100);
                     if FValidationArray[11] = true then BudgetRecord.ActualData.NovTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month11/-100);
                     if FValidationArray[12] = true then BudgetRecord.ActualData.DecTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month12/-100);
                  end
               else
                  begin
                     if FValidationArray[1] = true then BudgetRecord.ActualData.JanTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month1/100);
                     if FValidationArray[2] = true then BudgetRecord.ActualData.FebTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month2/100);
                     if FValidationArray[3] = true then BudgetRecord.ActualData.MarTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month3/100);
                     if FValidationArray[4] = true then BudgetRecord.ActualData.AprTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month4/100);
                     if FValidationArray[5] = true then BudgetRecord.ActualData.MayTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month5/100);
                     if FValidationArray[6] = true then BudgetRecord.ActualData.JunTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month6/100);
                     if FValidationArray[7] = true then BudgetRecord.ActualData.JulTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month7/100);
                     if FValidationArray[8] = true then BudgetRecord.ActualData.AugTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month8/100);
                     if FValidationArray[9] = true then BudgetRecord.ActualData.SepTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month9/100);
                     if FValidationArray[10] = true then BudgetRecord.ActualData.OctTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month10/100);
                     if FValidationArray[11] = true then BudgetRecord.ActualData.NovTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month11/100);
                     if FValidationArray[12] = true then BudgetRecord.ActualData.DecTotal := (CalculateMonths.MonthlyArray[BudgetRecord.Id].Month12/100);
                 end;
               Add(BudgetRecord);
               Next;
            end;
      finally
         Close;
      end;
end;

procedure TBudgetCalculator.ValidateMonths;
var
   StartMonth, I : integer;
begin

   Startmonth := Cash1.XFINMONTH;

   for I :=1 to 12 do begin
       FValidationArray[1] := false;   // True value means already has actual figures then if false then fill in budget
   end;

   case StartMonth of
      1 : begin
             for i:=1 to FCurrentMonth do FValidationArray[i] := true;
          end;
      2 : begin
          if FCurrentMonth = 1 then for i:=1 to 12 do FValidationArray[i] := true
              else for i:=2 to FCurrentMonth do FValidationArray[i] := true
          end;
      3 : begin
          if FCurrentMonth = 1 then begin
                                   for i:=3 to 12 do FValidationArray[i] := true;
                                   FValidationArray[1] := true;
                                   end
              else if FCurrentMonth = 2 then begin
                                   for i:=1 to 12 do FValidationArray[i] := true;
                                   end
                   else for i:=3 to FCurrentMonth do FValidationArray[i] := true
          end;
      4 : begin
          if FCurrentMonth = 1 then begin
                                   for i:=4 to 12 do FValidationArray[i] := true;
                                   FValidationArray[1] := true;
                                   end
              else if FCurrentMonth = 2 then begin
                                   for i:=4 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 2 do FValidationArray[i] := true;
                                   end
                  else if FCurrentMonth = 3 then for i:=1 to 12 do FValidationArray[i] := true
                       else for i:=4 to FCurrentMonth do FValidationArray[i] := true
          end;
      5 : begin
          if FCurrentMonth = 1 then begin
                                   for i:=5 to 12 do FValidationArray[i] := true;
                                   FValidationArray[1] := true;
                                   end
              else if FCurrentMonth = 2 then begin
                                   for i:=5 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 2 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 3 then begin
                                   for i:=5 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 3 do FValidationArray[i] := true;
                                   end
                  else if FCurrentMonth = 4 then for i:=1 to 12 do FValidationArray[i] := true
                       else for i:=5 to FCurrentMonth do FValidationArray[i] := true
          end;
      6 : begin
          if FCurrentMonth = 1 then begin
                                   for i:=6 to 12 do FValidationArray[i] := true;
                                   FValidationArray[1] := true;
                                   end
              else if FCurrentMonth = 2 then begin
                                   for i:=6 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 2 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 3 then begin
                                   for i:=6 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 3 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 4 then begin
                                   for i:=6 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 4 do FValidationArray[i] := true;
                                   end
                  else if FCurrentMonth = 5 then for i:=1 to 12 do FValidationArray[i] := true
                       else for i:=6 to FCurrentMonth do FValidationArray[i] := true
          end;
      7 : begin
          if FCurrentMonth = 1 then begin
                                   for i:=7 to 12 do FValidationArray[i] := true;
                                   FValidationArray[1] := true;
                                   end
              else if FCurrentMonth = 2 then begin
                                   for i:=7 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 2 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 3 then begin
                                   for i:=7 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 3 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 4 then begin
                                   for i:=7 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 4 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 5 then begin
                                   for i:=7 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 5 do FValidationArray[i] := true;
                                   end
                  else if FCurrentMonth = 6 then for i:=1 to 12 do FValidationArray[i] := true
                       else for i:=7 to FCurrentMonth do FValidationArray[i] := true
          end;
      8 : begin
          if FCurrentMonth = 1 then begin
                                   for i:=8 to 12 do FValidationArray[i] := true;
                                   FValidationArray[1] := true;
                                   end
              else if FCurrentMonth = 2 then begin
                                   for i:=8 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 2 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 3 then begin
                                   for i:=8 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 3 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 4 then begin
                                   for i:=8 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 4 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 5 then begin
                                   for i:=8 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 6 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 6 then begin
                                   for i:=8 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 6 do FValidationArray[i] := true;
                                   end
                  else if FCurrentMonth = 7 then for i:=1 to 12 do FValidationArray[i] := true
                       else for i:=8 to FCurrentMonth do FValidationArray[i] := true
          end;
      9 : begin
          if FCurrentMonth = 1 then begin
                                   for i:=9 to 12 do FValidationArray[i] := true;
                                   FValidationArray[1] := true;
                                   end
              else if FCurrentMonth = 2 then begin
                                   for i:=9 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 2 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 3 then begin
                                   for i:=9 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 3 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 4 then begin
                                   for i:=9 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 4 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 5 then begin
                                   for i:=9 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 5 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 6 then begin
                                   for i:=9 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 6 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 7 then begin
                                   for i:=9 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 7 do FValidationArray[i] := true;
                                   end
                  else if FCurrentMonth = 8 then for i:=1 to 12 do FValidationArray[i] := true
                       else for i:=9 to FCurrentMonth do FValidationArray[i] := true
          end;
      10 : begin
          if FCurrentMonth = 1 then begin
                                   for i:=10 to 12 do FValidationArray[i] := true;
                                   FValidationArray[1] := true;
                                   end
              else if FCurrentMonth = 2 then begin
                                   for i:=10 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 2 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 3 then begin
                                   for i:=10 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 3 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 4 then begin
                                   for i:=10 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 4 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 5 then begin
                                   for i:=10 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 5 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 6 then begin
                                   for i:=10 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 6 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 7 then begin
                                   for i:=10 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 7 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 8 then begin
                                   for i:=10 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 8 do FValidationArray[i] := true;
                                   end
                  else if FCurrentMonth = 9 then for i:=1 to 12 do FValidationArray[i] := true
                       else for i:=10 to FCurrentMonth do FValidationArray[i] := true
          end;
      11 : begin
          if FCurrentMonth = 1 then begin
                                   for i:=11 to 12 do FValidationArray[i] := true;
                                   FValidationArray[1] := true;
                                   end
              else if FCurrentMonth = 2 then begin
                                   for i:=11 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 2 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 3 then begin
                                   for i:=11 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 3 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 4 then begin
                                   for i:=11 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 4 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 5 then begin
                                   for i:=11 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 5 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 6 then begin
                                   for i:=11 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 6 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 7 then begin
                                   for i:=11 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 7 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 8 then begin
                                   for i:=11 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 1 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 9 then begin
                                   for i:=11 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 9 do FValidationArray[i] := true;
                                   end
                  else if FCurrentMonth = 10 then for i:=1 to 12 do FValidationArray[i] := true
                       else for i:=11 to FCurrentMonth do FValidationArray[i] := true
          end;
      12 : begin
          if FCurrentMonth = 1 then begin
                                   for i:=12 to 12 do FValidationArray[i] := true;
                                   FValidationArray[1] := true;
                                   end
              else if FCurrentMonth = 2 then begin
                                   for i:=12 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 2 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 3 then begin
                                   for i:=12 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 3 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 4 then begin
                                   for i:=12 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 4 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 5 then begin
                                   for i:=12 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 5 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 6 then begin
                                   for i:=12 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 6 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 7 then begin
                                   for i:=12 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 7 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 8 then begin
                                   for i:=12 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 8 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 9 then begin
                                   for i:=12 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 9 do FValidationArray[i] := true;
                                   end
              else if FCurrentMonth = 10 then begin
                                   for i:=12 to 12 do FValidationArray[i] := true;
                                   for i:=1 to 10 do FValidationArray[i] := true;
                                   end
                  else if FCurrentMonth = 11 then for i:=1 to 12 do FValidationArray[i] := true
                       else for i:=12 to FCurrentMonth do FValidationArray[i] := true
          end;
   end; // case
end;





end.
