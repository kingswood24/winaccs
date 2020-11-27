unit UVATSetup;

{

Ch006 - New unit created for UK Digital VAT returns

}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Grids, Db, DBTables, RXSpin, ComCtrls;

type
  TVATSetupForm = class(TForm)
    Panel1: TPanel;
    ExitBtn: TBitBtn;
    Savebtn: TBitBtn;
    Label1: TLabel;
    FinStartLbl: TLabel;
    Label3: TLabel;
    FinYearLbl: TLabel;
    VATPeriodsPanel: TPanel;
    FreqRG: TRadioGroup;
    GroupBox1: TGroupBox;
    VATPeriodGrid: TStringGrid;
    CustomPeriod: TRxSpinEdit;
    GenerateBtn: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MatchingStartCB: TCheckBox;
    VATStartPanel: TPanel;
    Label2: TLabel;
    StartEdit: TEdit;
    VATStartMonthLbl: TLabel;
    Label9: TLabel;
    procedure FormShow(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure StartEditExit(Sender: TObject);
    procedure SavebtnClick(Sender: TObject);
    procedure ReadParams;
    procedure GenerateVATPeriods;
    procedure GenerateBtnClick(Sender: TObject);
    procedure MatchingStartCBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ShowPeriodsPanel : Boolean;
  end;

var
  VATSetupForm: TVATSetupForm;
  VATPeriodLength : Integer;



implementation

Uses
  VARS, Calcs, AccsData, MSXML2_TLB, COMObj;

{$R *.DFM}

function LastDayOfMonth(Date: TDateTime): TDateTime;
var
    Year, Month, Day: Word;
begin
    DecodeDate(Date, Year, Month, Day);
    if Month = 12 then begin Month := 1; inc(Year) end;
    Result := EncodeDate(Year, Month, 1) - 1;
end;

function FirstDayOfMonth(Date: TDateTime): TDateTime;
  var
    Year, Month, Day: Word;
  begin
    DecodeDate(Date, Year, Month, Day);
    Result := EncodeDate(Year, Month, 1);
  end;






Function MonthName(monthno : integer) : String;
begin
     If monthno = 1 Then Result := 'January'
     Else If monthno = 2 Then Result := 'February'
     Else If monthno = 3 Then Result := 'March'
     Else If monthno = 4 Then Result := 'April'
     Else If monthno = 5 Then Result := 'May'
     Else If monthno = 6 Then Result := 'June'
     Else If monthno = 7 Then Result := 'July'
     Else If monthno = 8 Then Result := 'August'
     Else If monthno = 9 Then Result := 'September'
     Else If monthno = 10 Then Result := 'October'
     Else If monthno = 11 Then Result := 'November'
     Else If monthno = 12 Then Result := 'December'
     Else Result := '';

end;


procedure TVATSetupForm.FormShow(Sender: TObject);
var
        i : integer;
begin
        FinStartLbl.caption := IntToStr(Cash1.xfinMonth) + ' (' + MonthName(Cash1.xfinMonth) + ')';
        FinYearLbl.caption := IntToStr(Cash1.xfinYear);
        StartEdit.Text := '';
        VATStartMonthLbl.Caption := '';

        if not fileexists(Accsdatamodule.AccsDataBase.Directory + '\DigitalVAT.xml') then begin
              Exitbtn.enabled := False;
              SaveBtn.Enabled := True;

        end
            else begin
                 Exitbtn.enabled := True;
                 SaveBtn.Enabled := True;
                 ReadParams;

                end;

        VATPeriodsPanel.visible := False;

        if ShowPeriodsPanel then begin

              VATPeriodGrid.Cells[0,0] := 'Return Start Date';
              VATPeriodGrid.Cells[1,0] := 'Return End Date';

              VATPeriodsPanel.visible := True;

    //    VATReturnQuery.DatabaseName := AccsDataModule.AccsDataBase.DatabaseName;

    //    VATReturnQuery.SQL.clear;
    //    VATReturnQuery.SQL.add('Select * from VATReturn where FinYear = "' + IntToStr(Cash1.xfinYear) + '"');
    //    VATReturnQuery.open;

    //    If VATReturnQuery.RecordCount = 0 then begin
    //            GenerateVATPeriods;
    //    end
    //            else begin


    //            end;
        end;

end;

procedure TVATSetupForm.ReadParams;
var
   Node : IXMLDomNode;
   ChildNode : IXMLDomNode;
   NodeList : IXMLDomNodeList;
   Document : IXMLDOMDocument;
   AFileName : string;
   StartMonth : string;
   PeriodLength : string;
   i : integer;
   FinancialYearVATStart : String;

begin
     AFileName := Accsdatamodule.AccsDataBase.Directory + 'DigitalVAT.xml';

     ChildNode := nil;
     Node := nil;
     NodeList := nil;
     Document := nil;

     if not FileExists(AFilename) then Exit;

    try
       Document := CreateOleObject('MSXML2.DOMDocument') as IXMLDOMDocument;
       Document.load(AFilename);

       NodeList := Document.getElementsByTagName('DigitalVAT');

       for i := 0 to NodeList.length -1 do
       begin
            Node := Nodelist[i];
            if (Node = nil) then continue;

            ChildNode := Node.selectSingleNode('Parameters');

            StartMonth := Node.childNodes[0].childNodes[0].text;
            PeriodLength := Node.childNodes[0].childNodes[1].text;
            FinancialYearVATStart := Node.childNodes[0].childNodes[2].text;
       end;
    finally
      ChildNode := nil;
      Node := nil;
      NodeList := nil;
      Document := nil;
    end;

    StartEdit.text := StartMonth;

    If PeriodLength[1] = 'c' then begin
          PeriodLength := COPY(PeriodLength,2,LENGTH(Periodlength)-1);
          FreqRG.ItemIndex := 2;
          CustomPeriod.text := PeriodLength;

    end else begin
          if PeriodLength = '1' then FreqRG.ItemIndex := 0;
          if PeriodLength = '2' then FreqRG.ItemIndex := 1;

        end;

    if FreqRG.ItemIndex = 0 then VATPeriodLength := 1
        else  if FreqRG.ItemIndex = 1 then VATPeriodLength := 3
                else VATPeriodLength := StrToInt(CustomPeriod.text);

    if FinancialYearVATStart = 'True' then begin
        MatchingStartCB.checked := True;
        VATStartPanel.Visible := False;
        end else begin
                 MatchingStartCB.checked := False;
                 VATStartPanel.Visible := True;
                 end;

end;




procedure TVATSetupForm.ExitBtnClick(Sender: TObject);
begin
        close;
        VATSetupForm := nil;
end;

procedure TVATSetupForm.StartEditExit(Sender: TObject);
begin
     If Numeric (StartEdit.Text) Then
        Begin
             VATStartMonthLbl.Caption := MonthName(StrToInt(StartEdit.Text));
        End
                else StartEdit.SetFocus;
end;

procedure TVATSetupForm.SavebtnClick(Sender: TObject);
var
   Document : IXMLDOMDocument;
   Header, VATParams, ChildNode : IXMLDOMNode;
   AFileName, TempStr : string;
   i : integer;
   
begin

      // Add Accounting Periods into Returns Table

         for i:=1 to 12 do begin

               if  VATPeriodGrid.Cells[0,i] <> '' then begin
                        AccsDataModule.VATReturnDB.open;
                        AccsDataModule.VATReturnDB.Append;
                        AccsDataModule.VATReturnDB['UKReturn'] := True;
                        AccsDataModule.VATReturnDB['FinYear'] := IntToStr(Cash1.xfinYear);
                        AccsDataModule.VATReturnDB['ReturnStartDate'] := VATPeriodGrid.Cells[0,i];
                        AccsDataModule.VATReturnDB['ReturnEndDate'] := VATPeriodGrid.Cells[1,i];
                        AccsDataModule.VATReturnDB['SubmissionComplete'] := False;
                        AccsDataModule.VATReturnDB['DisplayString'] := vartostr(VATPeriodGrid.Cells[0,i]) + ' - ' + vartostr(VATPeriodGrid.Cells[1,i]);
                        AccsDataModule.VATReturnDB.post;
               end;

         end;




   Header := nil;
   VATParams := nil;
   ChildNode := nil;

   AFileName := Accsdatamodule.AccsDataBase.Directory + 'DigitalVAT.xml';

   if ((FreqRG.ItemIndex = 2) and (CustomPeriod.Text = '')) then begin
       showmessage('Please Specify Custom Period');
       exit;
   end;

   try
      Document := CreateOleObject('MSXML2.DOMDocument') as IXMLDOMDocument;
   except
      raise Exception.Create('Error creating MSXML2.DOMDocument. Please contact Kingswood.');
   end;

   try

      Document.appendChild(Document.createProcessingInstruction('xml', 'version="1.0" encoding="UTF-8"'));

      Header := Document.createElement('DigitalVAT'); // Create Root Node
      Document.appendChild(Header);

      VATParams := Document.createElement('Parameters');

      if MatchingStartCB.Checked = true then tempstr := vartostr(Cash1.xfinMonth)
        else tempstr := StartEdit.Text;

      ChildNode := Document.createElement('StartMonth');
      ChildNode.Set_text(tempstr);
      VATParams.appendChild(ChildNode);

      if FreqRG.ItemIndex = 0 then TempStr := '1'
        else if FreqRG.ItemIndex = 1 then TempStr := '3'
                else Tempstr := 'c' + CustomPeriod.text;

      ChildNode := Document.createElement('PeriodLength');
      ChildNode.Set_text(TempStr);
      VATParams.appendChild(ChildNode);

      If MatchingStartCB.Checked = true then TempStr := 'True'
        else TempStr := 'False';

      ChildNode := Document.createElement('VATStartAtFinancialYear');
      ChildNode.Set_text(TempStr);
      VATParams.appendChild(ChildNode);



      Header.appendChild(VATParams);

      if (FileExists(AFileName)) then
         DeleteFile(AFileName);

      Document.save(AFileName);
  finally

   Header := nil;
   VATParams := nil;
   ChildNode := nil;

  end;



  // Exitbtn.enabled := True;

  close;
  VATSetupForm := nil;



end;

procedure TVATSetupForm.GenerateVATPeriods;
var
      StartYear, VATStart, FinYear : Integer;
      GridRow : Integer;
      TotalCount : Integer;
      Month : TDateTime;
      i : integer;
      DateString : shortstring;
      DateBefore : Boolean;
      MatchingStart : Boolean;

begin
        StartYear := Cash1.xfinMonth;

        FinYear := Cash1.xfinYear;

        if FreqRG.ItemIndex = 0 then VATPeriodLength := 1
            else  if FreqRG.ItemIndex = 1 then VATPeriodLength := 3
                else VATPeriodLength := StrToInt(CustomPeriod.text);

        for I := 1 to 12 do begin

           VATPeriodGrid.Cells[0,i] := '';
           VATPeriodGrid.Cells[1,i] := '';

        end;

        MatchingStart := MatchingStartCB.checked;

        if Matchingstart then VATStart := StartYear
                else VATStart := StrToInt(StartEdit.text);


        GridRow := 1;   // First Blank Line

        TotalCount := 0;

        if MatchingStart then begin // VAT Starts along with Fin year

            While TotalCount <> 12 do begin
                // Period Start

                Month := FirstDayOfMonth(StrToDate('01/' + VartoStr(VATStart) + '/' + VarToStr(FinYear)));
                VATPeriodGrid.Cells[0,GridRow] := FormatDateTime('dd/mm/yyyy', Month);
                VATStart := VATSTart + VATPeriodLength;
                TotalCount := TotalCount + VATPeriodLength;

                if VATStart > 12 then begin
                    VATStart := VATStart -12;
                    FinYear := FinYear + 1;
                end;

                Month := (StrToDate('01/' + VartoStr(VATStart) + '/' + VarToStr(FinYear)));
                Month := Month -1;
                VATPeriodGrid.Cells[1,GridRow] := FormatDateTime('dd/mm/yyyy', Month);

                DateString := vartostr(Month);

                if not CheckDateRange ( DateString, True, DateBefore, False ) then begin
                          VATPeriodGrid.Cells[0,GridRow] := '';
                          VATPeriodGrid.Cells[1,GridRow] := '';
                end;

                GridRow := GridRow + 1;
            end;


        end
             else begin // VAT Starts in previous year

               if VATStart > StartYear then FinYear := FinYear -1;
                // Work out the cross year period
              While TotalCount <> 12 do begin

                Month := FirstDayOfMonth(StrToDate('01/' + VartoStr(VATStart) + '/' + VarToStr(FinYear)));
                VATPeriodGrid.Cells[0,GridRow] := FormatDateTime('dd/mm/yyyy', Month);
                VATStart := VATSTart + VATPeriodLength;
                TotalCount := TotalCount + VATPeriodLength;

                if VATStart > 12 then begin
                    VATStart := VATStart -12;
                    FinYear := FinYear + 1;
                end;

                Month := (StrToDate('01/' + VartoStr(VATStart) + '/' + VarToStr(FinYear)));
                Month := Month -1;
                VATPeriodGrid.Cells[1,GridRow] := FormatDateTime('dd/mm/yyyy', Month);

                DateString := vartostr(Month);

                if not CheckDateRange ( DateString, True, DateBefore, False ) then begin
                          VATPeriodGrid.Cells[0,GridRow] := '';
                          VATPeriodGrid.Cells[1,GridRow] := '';
                end;

                GridRow := GridRow + 1;
              end;

             end;


end;

procedure TVATSetupForm.GenerateBtnClick(Sender: TObject);
begin
        GenerateVATPeriods;
end;

procedure TVATSetupForm.MatchingStartCBClick(Sender: TObject);
begin
        if MatchingStartCB.checked then VATStartPanel.visible := False
                else VATStartPanel.visible := True;
end;

end.
