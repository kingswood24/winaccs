unit uSuppDownloadReview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin, IniFiles;


type
  TfSuppDownloadReview = class(TForm)
    StatusBar1: TStatusBar;
    Splitter1: TSplitter;
    ToolBar1: TToolBar;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn6: TBitBtn;
    Grid: TStringGrid;
    DateGrid: TStringGrid;
    procedure ExitButtonClick(Sender: TObject);
    procedure MilkTransTitleClick(Column: TColumn);
    procedure sbPrintClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    OrderBy,
    LastOrderBy,
    LastSortByField : String;
    procedure SetUpTransQuery(SortBy:String);
    function GetSortByField : String;
    procedure SetSortByField ( Value : String );
  public
    { Public declarations }
    property SortByField : String read GetSortByField write SetSortByField;
  end;

var
   fSuppDownloadReview: TfSuppDownloadReview;

//  procedure CreateAndShow;

implementation
uses
    QuickRpt,
    QRExtra;

{$R *.DFM}

procedure CreateAndShow;
begin
{     with TfMilkDiskReview.Create(Application) Do
        try

           qMainMilk.Open;
           OrderBy := 'Asc';
           SortByField := '';
           ShowModal;
        finally
           qMainMilk.Close;
           Free;
        end;}
end;

function TfSuppDownloadReview.GetSortByField : String;
begin
    RESULT := LastSortByField;
end;

procedure TfSuppDownloadReview.SetSortByField ( Value : String );
var i : Integer;
begin
    if Value <> LastSortByField then
       begin
          LastSortByField := Value;
          SetUpTransQuery ( LastSortByField );
       end
    else // Change the Sort Order
       begin
          if OrderBy = 'Asc' then
             OrderBy := 'Desc'
          else
             OrderBy := 'Asc';
          SetUpTransQuery ( LastSortByField );
       end;
{    for i := 0 to MilkTrans.Columns.Count-1 do
       if ( LastSortByField = MilkTrans.Columns[i].Field.FieldName ) then
          MilkTrans.Columns[i].Title.Font.Style := [fsBold]
       else
          MilkTrans.Columns[i].Title.Font.Style := [];}
end;

procedure TfSuppDownloadReview.SetUpTransQuery ( SortBy : String );
begin
{   with qMilkTrans do
      begin
         SQL.Clear;
         SQL.Add('SELECT * FROM MilkDiskTrans');
         SQL.Add('WHERE (MDTID=:ID)');
         if SortBy = '' then
            SQL.Add('ORDER BY AnimalCode ' + OrderBy)
         else
            SQL.Add('ORDER BY ' + SortBy + ' ' + OrderBy );
         Open;
      end;}
end;

procedure TfSuppDownloadReview.ExitButtonClick(Sender: TObject);
begin
     Close;
end;

procedure TfSuppDownloadReview.MilkTransTitleClick(Column: TColumn);
begin
    SortByField := Column.Field.FieldName;
end;

procedure TfSuppDownloadReview.sbPrintClick(Sender: TObject);
var
    MilkReport : TQuickRep;
    MyStrings  : TStringList;
    i : Integer;
begin
    // Build And Print the Report based on the Grids Columns and Sort Order
    try
       MilkReport := TQuickRep.Create(Self);
       MilkReport.Parent := Self;
       MyStrings := TStringList.Create;

{       for i := 0 to MilkTrans.Columns.Count-1 do
          MyStrings.Add(MilkTrans.Columns[i].FieldName);

       QRCreateList(MilkReport,Self,qMilkTrans,'Milk Recording Listing',MyStrings);
       (*
       MilkReport := TQuickRep.Create(Self);
       MilkReport.Parent := Self;
       with MilkReport do
          begin
             DataSet := qMilkTrans;
             Bands.HasTitle := True;
             Bands.HasDetail := True;

             with Bands.DetailBand.AddPrintable(TQRDBText) do
                begin
                   Size.Top := 5;
                   Size.Left := 20;
                   DataSet := qMilkTrans;
                   FieldName := 'AnimalCode';
                end;

          *)
          if (Sender as TRxSpeedButton).Name = 'sbPreview' then
             MilkReport.Preview
          else
             Windata.CallPrintDialog(MilkReport);
          // end;}
    finally
{       MyStrings.Free;
       MilkReport.Free;}
    end;
end;

procedure TfSuppDownloadReview.FormActivate(Sender: TObject);
begin
     Grid.ColWidths[0] := 10; // First - Keep Empty
     Grid.ColWidths[1] := 85; // A/C No.
     Grid.ColWidths[2] := 70; // Trx Type
     Grid.ColWidths[3] := 75; // Docket no
     Grid.ColWidths[4] := 70; // Trx Date
     Grid.ColWidths[5] := 80; // Desc
     Grid.ColWidths[6] := 70; // Quantity
     Grid.ColWidths[7] := 70; // Value
     Grid.ColWidths[8] := 70; // VAT Rate
     Grid.ColWidths[9] := 80; // Unit Of Sale
     Grid.ColWidths[10] := 128; // Product Cat
     Grid.ColWidths[11] := 158; // Product Cat Code;

     Grid.Cols[0].Text := '';
     Grid.Cols[1].Text := 'A/C Number';
     Grid.Cols[2].Text := 'Trx Type';
     Grid.Cols[3].Text := 'Docket No';
     Grid.Cols[4].Text := 'Trx Date';
     Grid.Cols[5].Text := 'Description';
     Grid.Cols[6].Text := 'Quantity';
     Grid.Cols[7].Text := 'Value';
     Grid.Cols[8].Text := 'VAT Rate';
     Grid.Cols[9].Text := 'Unit of Sale';
     Grid.Cols[10].Text := 'Product Category';
     Grid.Cols[11].Text := 'Product Category Code';

     DateGrid.ColWidths[0] := 10; // First - Keep Empty
     DateGrid.ColWidths[1] := 65; // Date
     DateGrid.ColWidths[2] := 160; // Description

     DateGrid.Cols[0].Text := '';
     DateGrid.Cols[1].Text := 'Date';
     DateGrid.Cols[2].Text := 'Description';
end;

end.
