unit AccDataM;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables;

type
  TAccsData = class(TDataModule)
    PrintSource: TDataSource;
    PrintFile: TTable;
    PrintFilePrinterName: TStringField;
    PrintFilePointSizeSmall: TSmallintField;
    PrintFilePointSizeLarge: TSmallintField;
    PrintFileFontName: TStringField;
    PrintFileLineSpacing: TSmallintField;
    PrintFilePrinterNo: TIntegerField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AccsData: TAccsData;

implementation

{$R *.DFM}


end.
