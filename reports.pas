unit reports;

(* Changes

    31/08/20 - AB - Transaction Listing Report Issues - Bug : Reference not always being shown (marked Ch028)
                                                        Improvement : customer wanted Cust / Supp shown on all ledger transactions - added cust / supp column (marked Ch028)

*)

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Quickrpt, QRCtrls, Db, DBTables, Dialogs,
  RxGIF, Vars, Types, stat, reportdefs, printers, QRExport;

Const MaxFields = 30;

type TPosition = class (TObject)
     Alignment : Char;
     Position  : Integer;
     Fieldname : String;
     Field     : Integer;
end;

type IntSet = set of byte;

type TFieldsArray = Array[1..MaxFields] of String;

type
  TReport = class(TQuickRep)
    Query: TQuery;
    Table: TTable;
    PageFooter: TQRBand;
    PageHeader: TQRBand;
    Heading: TQRLabel;
    TopLine2: TQRShape;
    TopLine1: TQRShape;
    KingswoodLbl: TQRLabel;
    PageNumber: TQRSysData;
    TimeLbl: TQRSysData;
    SubHeading: TQRLabel;
    QRBand: TQRBand;
    BottomLine: TQRShape;
    RangeLabel: TQRLabel;
    StatementName: TQRLabel;
    StatementFromLabel: TQRLabel;
    StatementAddress1: TQRLabel;
    StatementAddress2: TQRLabel;
    StatementAddress3: TQRLabel;
    StatementAddress4: TQRLabel;
    StatementTelephone: TQRLabel;
    ReportDate: TQRLabel;
    Printdate: TQRLabel;
    QRExcelFilter1: TQRExcelFilter;
    QRCSVFilter1: TQRCSVFilter;
    QRTextFilter1: TQRTextFilter;
    QRHTMLFilter1: TQRHTMLFilter;
    QRRTFFilter1: TQRRTFFilter;
    CoverPanel: TQRShape;
    KingsAccFooter: TQRLabel;
  private
     ColumnPositions : Array[1..MaxFields] of TPosition;
//     Excluded : Set of Byte;
     Header : TStringList;
     InHeader : Boolean;
     LastLine : String;
     ReplaceListWhat : TStringList;
     ReplaceListWith : TStringList;
     function AddAlignedColumn (Position : Integer; Alignment: Char) : Integer;
     function AdjustDashes(S : String; var Section : Integer): String;
     function IsEmpty(S : String) : Boolean;
     function IsInHeader(S : String): Boolean;
     function IsSuperfelous(var S : String;NIVATReport:boolean) : Boolean;
     function ParseLine(S: String) : TFieldsArray;
  public
      CurrReport : String;
      CurrentField : Integer;
      LinesPerPage : Integer;
      function AddAlphaColumn (Position : Integer) : Integer;
      function AddBracketColumn (Position : Integer) : Integer;
      function AddColumn(Column, Position : Integer) : TQRDBText;
      function AddDashColumn (Position : Integer) : Integer;
      function AddTextColumn (Position : Integer) : Integer;
      function AddLeftAlignedColumn (Position : Integer) : Integer;
      function AddRightAlignedColumn (Position : Integer) : Integer;

      procedure DisplayReport;
      procedure ForgetColumns;
      procedure ResetColumns;
      procedure ProcessReport (Filename: String);
      procedure ResetTable;
      procedure ResetReport;
//      procedure ExcludeLines(S : IntSet);
      procedure ReplaceText(WhatStr, WithStr : String);
      procedure SetHeading(H : String);
  end;

var
  Report: TReport;

implementation

uses AccsData;              //Ch028

procedure TReport.ReplaceText(WhatStr, WithStr : String);
begin
     ReplaceListWhat.Add(WhatStr);
     ReplaceListWith.Add(WithStr);
end;

procedure TReport.ResetColumns;
var i: Integer;
begin
     Header.Free;
     Header := TStringList.Create;
     for i := 1 to MaxFields do
         ColumnPositions[i] := TPosition.Create;
     for i := ComponentCount - 1 downto 0 do
         if Components[i] is TQRDBText then
            Components[i].Free;
end;

procedure TReport.ForgetColumns;
var i : Integer;
begin
     for i := 1 to MaxFields do
         ColumnPositions[i].Position := -1;
end;

procedure TReport.ResetTable;
begin
//     Table.active:=false;
//     Table.EmptyTable;
//     Table.open;
     Query.Sql.Clear;
     Query.Sql.Add('delete from report');
     Query.ExecSQL;
end;

procedure TReport.ResetReport;
begin
     ResetTable;
     ResetColumns;
     Heading.Caption := '';
     SubHeading.Caption := '';
     LastLine := ' ';
     InHeader := False;
     CurrentField := 1;
     ReplaceListWhat.Free;
     ReplaceListWhat := TStringList.Create;
     ReplaceListWith.Free;
     ReplaceListWith := TStringList.Create;
     ReplaceText('Kingswood Computing Ltd.', '');

end;

function TReport.AddColumn(Column, Position : Integer) : TQRDBText;
Var DBText : TQRDBText;
begin
     DBText := TQRDBText.Create(Self);
     if (ColumnPositions[Column].Alignment = 'L') or (ColumnPositions[Column].Alignment = 'A') then
        DBText.Alignment := taLeftJustify
     else
        DBText.Alignment := taRightJustify;
     DBText.AutoSize := True;
     DBText.AutoStretch := True;
     DBText.DataField := 'F' + IntToStr(Column);
     DBText.DataSet := Table;
     DBText.Height := 17;
     DBText.Left := Position+1;
     DBText.Parent := QRBand;
     DBText.Top := 0;
     DBText.Transparent := True;
     AddColumn := DBText;
     //if ((report.currReport = 'Statement') and (Column = 4)) then DBText.Font.Size := 12;
end;

function TReport.AddAlignedColumn (Position : Integer; Alignment : Char)  : Integer;
begin
    AddAlignedColumn := CurrentField;
    ColumnPositions[CurrentField].Alignment := Alignment;
    ColumnPositions[CurrentField].Fieldname := 'F'  + IntToStr(CurrentField);
    ColumnPositions[CurrentField].Field := CurrentField;
    ColumnPositions[CurrentField].Position := Position;
    inc(CurrentField);
end;

function TReport.AddDashColumn (Position : Integer) : Integer;

begin
     AddDashColumn := AddAlignedColumn (Position, 'D');
end;

function TReport.AddBracketColumn (Position : Integer) : Integer;

begin
     AddBracketColumn := AddAlignedColumn (Position, 'B');
end;

function TReport.AddTextColumn (Position : Integer) : Integer;

begin
     AddTextColumn := AddAlignedColumn (Position, 'T');
end;

function TReport.AddLeftAlignedColumn (Position : Integer) : Integer;

begin
     AddLeftAlignedColumn := AddAlignedColumn (Position, 'L');
end;

function TReport.AddRightAlignedColumn (Position : Integer) : Integer;

begin
     AddRightAlignedColumn := AddAlignedColumn (Position, 'R');
end;

function TReport.AddAlphaColumn (Position : Integer) : Integer;
begin
     AddAlphaColumn := AddAlignedColumn (Position, 'A');
end;

procedure TReport.SetHeading(H : String);
begin
     Heading.Caption := H;
end;


{procedure TReport.ExcludeLines(S : IntSet);
begin
//     Excluded := S;
end;}

function TReport.IsEmpty(S : String) : Boolean;
var i : Integer;
    r : boolean;
begin
     r := true;
     for i := 1 to Length(S) do
         if S[i] <> ' ' then
            r := false;
     IsEmpty := r;
end;


function TReport.IsSuperfelous(var S : String;NIVATReport:boolean) : Boolean;
var i : Integer;

begin
     if (s = 'Kingswood Computing Ltd.') then s := '';
     IsSuperfelous := false;
     if (Length(s) > 0) and (Length(Lastline) > 0) then
        if (s[1] = 'ù') and (LastLine[1] = 'ù') then
           IsSuperfelous := true;
     if InHeader or (IsEmpty(s) and IsEmpty(LastLine)) then begin
        IsSuperfelous := True;
     end;
     if NIVATReport then IsSuperfelous :=false;
     LastLine := s;
end;

function TReport.IsInHeader(S : String): Boolean;
var i : Integer;
begin
     i := Length(S);
     while (i > 1) and (S[i] = ' ') do dec (i);
     while (i > 1) and (S[i] <> ' ') do dec (i);
     while (i > 1) and (S[i] = ' ') do dec (i);
     while (i > 1) and (S[i] <> ' ') do dec (i);
     if (Copy(S, i, 5) = ' PAGE') then begin
        IsInHeader := true;
        exit;
     end;
     if Length(S) > 0 then
        if InHeader and (S[1] = '-') then begin
           IsInHeader := False;
           exit;
        end;
     IsInHeader := InHeader;
end;

function TReport.AdjustDashes(S : String; var Section : Integer): String;
var i : Integer;
begin
     if (Length(S) > 0) and InHeader then
        if S[1] = '-' then begin
           InHeader := False;
           S := '';
        end;
     if (Length(S) > 2) and (Section = 0) then
        if (S[1] = '-')  then begin
           S := '';
           Section := 1;
        end;

     if Length(S) > 2 then
        if (S[1] = '-') then begin
//           SetLength(S, 54);
           InHeader := false;
           inc (Section);
{           for i := 1 to Length(S) do
               if S[i] = '-' then
                 S[i] := '—';}
                 if copy(S,3,12) <> 'skipthisline' then
                    if Report.Page.Orientation = polandscape then S := StringOfChar('—', 80)
                       else S := StringOfChar('—', 54);
        end;
     AdjustDashes := S;
end;

Const DebugReport = false;

function TReport.ParseLine(S: String) : TFieldsArray;
var i, j, k, l: Integer;
    Fields : TFieldsArray;
    FurthestRight : Integer;
    longline : boolean;
begin
     FurthestRight := 0;
     for i := 1 to CurrentField do Fields[i] := '';
     i := 1; k := 1;
     while i <= Length(S) do begin
           if i > FurthestRight then FurthestRight := i;
           for j := 1 to CurrentField do begin
               if ColumnPositions[j].Position = i then begin
                  // we've found the beginning of this column
                  if (ColumnPositions[j].Alignment = 'T') and ((S[i] >='A') and (S[i] <= 'z')) then begin
                     for k := i to Length(S) - 1 do begin
                         if (S[k] <= ' ') and (S[k+1] <= ' ') then
                            break;
                         Fields[ColumnPositions[j].Field] := Fields[ColumnPositions[j].Field] + S[k];
                     end;
                     i := k;
                     if S[k] > ' ' then Fields[ColumnPositions[j].Field] := Fields[ColumnPositions[j].Field] + S[k];
                  end;
                  if (ColumnPositions[j].Alignment = 'A') and not (((S[i] >= '0') and (S[i] <= '9')) or (S[i] = '.')) then begin
                     for k := i to Length(S) - 1 do begin
                         if (S[k] <= #32) and (S[k+1] <= #32) then
                            break;
                         Fields[ColumnPositions[j].Field] := Fields[ColumnPositions[j].Field] + S[k];
                     end;
                     i := k;
                     if S[k] > ' ' then Fields[ColumnPositions[j].Field] := Fields[ColumnPositions[j].Field] + S[k];
                  end;

                  if (ColumnPositions[j].Alignment = 'L') and (S[i] <> ' ') then begin
                     longline := false;
                     for k := i to Length(S) - 1 do begin
                         if (S[k] = '.') and (S[k+1] = '.') then
                            longline := true;
                         if (S[k] <= #32) and (S[k+1] <= #32) and (not longline) then
                            break;
                         Fields[ColumnPositions[j].Field] := Fields[ColumnPositions[j].Field] + S[k];
                     end;
                     if S[k] > ' ' then Fields[ColumnPositions[j].Field] := Fields[ColumnPositions[j].Field] + S[k];
                     i := k;
                  end;

                  if ColumnPositions[j].Alignment = 'R' then begin     // TGM  and (S[i+1] = ' ') and (currReport = 'TrialBalanceGroup') and (S[i] <> '-'))
                     if S[i] = ' ' then l := i - 1 else l := i;
                     FurthestRight := k;
                     for k := l downto 2 do begin
                         if ((S[k] = ' ')) or (k <= FurthestRight) then
                            break;
                         Fields[ColumnPositions[j].Field] := S[k] + Fields[ColumnPositions[j].Field];
                     end;
                  end;

                  if ColumnPositions[j].Alignment = 'D' then begin
                     if S[i] = '-' then
                        Fields[ColumnPositions[j].Field] := '-'
                     else
                        Fields[ColumnPositions[j].Field] := '';
                  end;
                  if ColumnPositions[j].Alignment = 'B' then begin
                     if (S[i] = ')') then
                        Fields[ColumnPositions[j-1].Field] := Fields[ColumnPositions[j-1].Field] + '(';
                     end;
                  end;

                  if (DebugReport) and (Fields[ColumnPositions[j].Field] <> '') then
                     Fields[ColumnPositions[j].Field] := '[' +  IntToStr(ColumnPositions[j].Field) + ']' + Fields[ColumnPositions[j].Field];
           end;
           inc(i);
     end;
     ParseLine := Fields;
end;

function AllUpperCase(S: String): Boolean;
var i : Integer;
    r : Boolean;

begin
     r := true;
     for i := 1 to Length(S) do begin
         if (S[i] >= 'a') and (S[i] <= 'z') then
            r := false;
     end;
     AllUpperCase := r;
end;

function Capitalise(S: String): String;
var i : Integer;
    r : String;
begin
     if report.CurrReport = 'Statement' then capitalise := s     // TGM AB
     else begin                                                  // TGM AB
     r := ''; Capitalise := '';
     If Length(s) = 0 then exit;
     r := s[1];
     for i := 2 to Length(S) do begin
         if (S[i] >= 'A') and (S[i] <= 'Z') and
            (S[i-1] >= 'A') and (S[i-1] <= 'Z') then begin
               r := r + chr(ord(S[i]) + 32);
         end else
             r := r + S[i];
     end;
     Capitalise := r;
     end;                                                        // TGM AB
end;


procedure TReport.ProcessReport (Filename: String);
Var Fields : TFieldsArray;
    F : TextFile;
    S : String;
    i,j, Section, lines: Integer;
    LastInHeader, done : Boolean;
    SEuro:string[20];
    NIVATReport:boolean;
    Temp : string;
    EVATAmount : real;
    TempCalc : real;
    SEVatAmount : string;
    EVatRate : real;
    Code : integer;
begin
     NIVatReport:=false;
     Table.Open;
     Screen.Cursor := crHourGlass;
     AssignFile(F, FileName);
     Reset(F);
     if (Filename = 'c:\kingsacc\reports\vat1.rpt') then NIVatReport:=true;
     Section := 0;
     LastLine := '';
     lines := 0;
     LastInHeader := true;
     while not eof(F) do begin
           Readln(F, S);
           LastInHeader := InHeader;
           InHeader := IsInHeader(S);
           S := AdjustDashes(S, Section);

           if InHeader then  begin
              Header.Add(S);
              S := '';
           end;

           Fields := ParseLine(S);
           if not IsSuperfelous(S,NIVatReport) and (copy(S,3,12) <> 'skipthisline') then begin
              Table.Append;
              Table['Section'] := Section;

              for i := 1 to MaxFields do begin
                  if Length(Fields[i]) > 0 then
                     if Fields[i][Length(Fields[i])] = '(' then begin
                        Fields[i] := '(' + Fields[i];
                        Fields[i][Length(Fields[i])] := ')';
                     end;
                  for j := 0 to ReplaceListWhat.Count - 1 do begin
                      if ReplaceListWhat[j] = Fields[i] then
                         Fields[i] := ReplaceListWith[j];
                  end;
                  if AllUpperCase(Fields[i]) then Fields[i] := Capitalise(Fields[i]);
                  if Length(Fields[i]) > 2 then
                     if (Fields[i][Length(Fields[i])] = ')') and (Fields[i][Length(Fields[i])-1] = ')') then
                        SetLength(Fields[i], Length(Fields[i]) - 1);
                  Table['F' + IntToStr(i)] := Fields[i];
              end;
              for i := 1 to MaxFields do Fields[i] := '';
              inc(lines);
           end;
           if (Inheader and not LastInHeader) then begin
              //try to remove any pointless lines
              repeat
                    done := true;
                    s := ' ';
                    for i := 1 to MaxFields do s := VarToStr(Table['F'+IntToStr(i)]) + s;
                    if ((S[1] = '—') or
                       (S = ' ') or
                       (S = 'Continued Over ...') or (S = 'Continued ...')) then begin
                          if lines > 0 then begin
                             try
                                Table.Delete;
                                Table.Last;
                                Done := False;
                                dec(lines);
                             except
                                done := true;
                             end;
                          end else
                              done := true;
                    end;
              until done;

              while (lines mod LinesPerPage) <> 0 do begin
                    Table.Append;
                    Table['Section'] := -2;
                    inc(lines);
              end;
           end;
     end;
     If (S = '') and (lines > 0) then begin
        Table.Last;
        Table.Delete;
     end;
     CloseFile(F);
     Screen.Cursor := crDefault;
        if ( (Filename = 'c:\kingsacc\reports\vat1.rpt') and (cash2.Xcountry = 1) ) then begin
           table.first;
           for i := 1 to 29 do table.next;
           If Table['F5'] <> '0.00' then begin
              showmessage('Box 9 on your VAT form has a value.' + #13#10
              + 'This comes from transactions entered with VAT Code E.' + #13#10
              + 'VAT Code E should only be used for goods imported from other EC States,' + #13#10
              + 'where these goods would be subject to standard Rate VAT if purchased in UK.' + #13#10
              + 'If you did not import goods in this category, please exit this report and edit the entries where you used VAT Code E, changing the Code E to a UK VAT Code' + #13#10
              + 'otherwise continue, entering the standard rate for VAT when prompted');
              Val(InputBox('VAT Rate For Imports From EC States', 'What VAT Rate to be used for Code E, (Box 9)', '17.5'),EVatRate, Code);
              EVatAmount := Table['F5'] * EVATRate/100;
              table. first;
              for i:= 1 to 9 do table.next;
              table.edit;
              str(EVATAmount:10:2,SEVatAmount);
              table['F5'] := SEVatAmount;
              table.post;
              table.next;
              table.next;
              Table.edit;
              TempCalc := Table['F5'] + EVatAmount;
              str(TempCalc:10:2,Temp);
              Table['F5'] := Temp;
              Table.post;
              table.next;
              table.next;
              table.next;
              Table.edit;
              TempCalc := Table['F5'] + EVatAmount;
              str(TempCalc:10:2,Temp);
              Table['F5'] := Temp;
              Table.post;
           end;

        end;


     If (currreport = 'ThisYearVsBudgetAndLastYear') then begin       // TGM AB 31/01/03
             table.first;
         for i:= 1 to table.recordcount do begin
             table.edit;
             Temp := '';
             try str((table['F5'] - table['F9']):7:2,Temp);
                 table['F14'] := Temp;
             except  table['F14'] := '';
             end;
             Temp := '';
             try str((table['F5'] - table['F7']):7:2,Temp);
                 table['F15'] := Temp;
             except  table['F15'] := '';
             end;
             table.post;
             if i <> table.recordcount then table.next;
         end;
     end; // This Year Vs

     If (currreport = 'ThisMonthVsBudgetAndLastYear') then begin       // TGM AB 31/01/03
             table.first;
         for i:= 1 to table.recordcount do begin
             table.edit;
             Temp := '';
             try str((table['F5'] - table['F9']):7:2,Temp);
                 table['F11'] := Temp;
             except  table['F11'] := '';
             end;
             Temp := '';
             try str((table['F5'] - table['F7']):7:2,Temp);
                 table['F12'] := Temp;
             except  table['F12'] := '';
             end;
             table.post;
             if i <> table.recordcount then table.next;
         end;
     end; // This Month Vs

     If (currreport = 'TransactionReport') then begin       // Ch028
             table.first;
         for i:= 1 to table.recordcount do begin
             table.edit;
             Temp := '';

             Temp := vartostr(table['F14']);

             if length(Temp) > 0 then begin

                 if Temp[1] = 'S' then begin
                     Temp := copy(Temp,2,(length(Temp)-1));
                     if accsdatamodule.SLFileDB.locate('SLNo',strtoint(Temp),[]) then Temp := accsdatamodule.SLFileDB['Name'];
                     table['F14'] := Temp;
                 end
                     else if Temp[1] = 'P' then begin
                           Temp := copy(Temp,2,(length(Temp)-1));
                           if accsdatamodule.PLFileDB.locate('PLNo',strtoint(Temp),[]) then Temp := accsdatamodule.PLFileDB['Name'];
                           table['F14'] := Temp;
                 end;

             end;

             if table['F10'] = '—' then table['F10'] := '';

             table.post;

             if i <> table.recordcount then table.next;

         end;
     end; // TransactionReport



     If Stat.StatementForm.ShowEuroTotals.checked = true then begin //( Cash2.xCountry = 2 ) then begin
        table.first;
        for i:= 1 to table.recordcount do begin
               table.edit;
               SEuro:='';
            {   if (currreport ='LedgerCards')  then
               try str((table['F12'] / Cash11.xEuroConverter):6:2,SEuro);
                   table['F15']:='(' + SEuro + ')';
               except
                     table['F15']:= '';
               end; }
                if (currreport ='LedgerCards')  then
               try str((table['F12'] / Cash11.xEuroConverter):6:2,SEuro);
                   table['F12']:='€ ' + SEuro + '';
               except
                     table['F15']:= '';
               end;
                if (CurrReport='InvoiceSummary') then
                // next bit not working properly 26/04/02
               try str((table['F13'] / Cash11.xEuroConverter):6:2,SEuro);
                   table['F18']:='(' + SEuro + ')';
               except
                     table['F18']:= '';
               end;
            {   SEuro:='';
               if currreport = 'LedgerCards' then
               try str((table['F8'] / Cash11.xEuroConverter):6:2,SEuro);
                   table['F16']:='(' + SEuro + ')';
               except table['F16']:=''
               end;
               SEuro:='';
               if currreport = 'LedgerCards' then
               try str((table['F10'] / Cash11.xEuroConverter):6:2,SEuro);
                   table['F17']:='(' + SEuro + ')';
               except table['F17'] := '';
               end;
               SEuro:=''; }
               SEuro:='';
               if currreport = 'LedgerCards' then
               try str((table['F8'] / Cash11.xEuroConverter):6:2,SEuro);
                   table['F8']:='€ ' + SEuro + '';
               except table['F16']:=''
               end;
               SEuro:='';
               if currreport = 'LedgerCards' then
               try str((table['F10'] / Cash11.xEuroConverter):6:2,SEuro);
                   table['F10']:='€ ' + SEuro + '';
               except table['F17'] := '';
               end;
               SEuro:='';

               SEuro:='';
               if currreport = 'Statement' then
               try str((table['F10'] / Cash11.xEuroConverter):6:2,SEuro);
                   table['F10']:='€ ' + SEuro + '';
               except
               end;
               SEuro:='';
               if currreport = 'Statement' then
               try str((table['F11'] / Cash11.xEuroConverter):6:2,SEuro);
                   table['F11']:='€ ' + SEuro + '';
               except
               end;
               SEuro:='';
               if currreport = 'Statement' then
               try str((table['F12'] / Cash11.xEuroConverter):6:2,SEuro);
                   table['F12']:='€ ' + SEuro + '';
               except
               end;
               SEuro:='';
               if currreport = 'Statement' then
               try str((table['F14'] / Cash11.xEuroConverter):6:2,SEuro);
                   table['F14']:='€ ' + SEuro + '';
               except
               end;

               table.post;
            if i <> table.recordcount then table.next;
        end;
        if ((currreport = 'LedgerCards') or (CurrReport = 'InvoiceSummary')) then
        addColumn(15,660);
        if currreport = 'LedgerCards' then
        addColumn(16,400);
        if currreport = 'LedgerCards' then
        addColumn(17,525);
     end;

end;

procedure TReport.DisplayReport;
var i : Integer;
    m1, m2, m3: Integer;
    H : String;
begin
     if (Header.Count > 0)  then begin
        H := Capitalise(Copy(Header[0], 1, 100));
        // This gets the name of the person, and the heading of the report
        m1 := 0; m2 := 1;
        m3 := 0;
        for i := 1 to 100 do begin
           if H[i] = '/' then m1 := i - 1;
           if H[i] = '-' then m2  := i + 5;
           if (H[i] <= ' ') and
            (H[i+1] <= ' ') and
            (H[i+2] <= ' ') then m3 := i;
           if m3 > 0 then break;
        end;
        if Heading.Caption = '' then Heading.Caption := Copy(H, m3, 100);
        SubHeading.Caption := Copy(H, 1, m1);
     end;
     Heading.Left := (PageHeader.Width - (Heading.Width)) div 2;
     TopLine1.Width := (PageHeader.Width - (Heading.Width+40)) div 2;
     TopLine2.Width := TopLine1.Width;
     TopLine2.Left := Heading.Left + Heading.Width + 10;

     // TGM AB 03/05/02 Adding code to fix header width with Landscape view

     // Portrail - width = 718, landscape - width = 1047, difference = 329
     if Report.Page.Orientation = PoLandscape then begin
         Bottomline.Width := Heading.width + (Topline1.width*2) + 20 ;
         Timelbl.left := 880;
         Pagenumber.left := 949;
         Kingswoodlbl.left := 753;
         PrintDate.left := 800;
         ReportDate.left := 610;
     end
        else begin
                   Bottomline.Width := 697;
                   Timelbl.left := 550;
                   Pagenumber.left := 620;
                   Kingswoodlbl.left := 424;
                   PrintDate.left := 480;
                   ReportDate.left := 280;
        end;

     // End TGM AB

     // TGM AB Code to Add Accs Name to Report if needed

     if (currreport ='LedgerCards') then begin
          SubHeading.Caption := Cash1.XCOMPANY;
     end;

     Preview;
end;

{$R *.DFM}

end.
