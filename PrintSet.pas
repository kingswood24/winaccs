unit Printset;

interface
    
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids, DB, DBTables, StdCtrls, Buttons, ExtCtrls,
  Mask, DBCtrls;

type
  TPrintForm = class(TForm)
    PrintGrid: TDBGrid;
    Panel1: TPanel;
    Help: TBitBtn;
    Exit: TBitBtn;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Panel5: TPanel;
    Cancel: TBitBtn;
    Delete: TBitBtn;
    Add: TBitBtn;
    Save: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBEdit5: TDBEdit;
    Label5: TLabel;
    Bevel1: TBevel;
    procedure AddClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure HelpClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  PrintForm: TPrintForm;

implementation
Uses
    AccsData,
    DefSecFl,
    params;

{$R *.DFM}

procedure TPrintForm.AddClick(Sender: TObject);
begin
     try Accsdatamodule.PrintFile.open
     except
     end;
     With AccsDataModule.PrintFile Do
          Begin
               Append;
               { Fill in other fields here }
               FieldByName('Printer Name').AsString := 'New Printer';
               FieldByName('Point Size Small').AsString := '7';
               FieldByName('Point Size Large').AsString := '12';
               FieldByName('Line Spacing').AsString := '10';
               FieldByName('Font Name').AsString := 'Courier New';
          End;
end;

procedure TPrintForm.CancelClick(Sender: TObject);
begin
     AccsDataModule.PrintFile.Cancel;
end;

procedure TPrintForm.ExitClick(Sender: TObject);
begin
     Close;
end;

procedure TPrintForm.SaveClick(Sender: TObject);
begin
     With AccsDataModule.PrintFile Do
          Begin
               if State in dsEditModes then
                  Post;
               RFarmGate.xUsePrinter := True;
               RFarmGate.xFontName := AccsDataModule.PrintFile.Fields[3].AsString;
               RFarmGate.xPointSizeCompressed := StrToInt(AccsDataModule.PrintFile.Fields[1].AsString);
               RFarmGate.xPointSizeUnCompressed := StrToInt(AccsDataModule.PrintFile.Fields[2].AsString);
               RFarmGate.xLineSpacing := StrToInt(AccsDataModule.PrintFile.Fields[4].AsString);
               SecWrite;
          End;
     Close;
end;

procedure TPrintForm.DeleteClick(Sender: TObject);
begin
     AccsDataModule.PrintFile.Delete;
end;


procedure TPrintForm.HelpClick(Sender: TObject);
begin
     Application.HelpContext(232);
end;

end.
