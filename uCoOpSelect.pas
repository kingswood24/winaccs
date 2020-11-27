{
   02/03/16 [V4.2 R1.9] /MK Change - Stopped user from editing the Co-Op name field in this screen as it was not posting change to the database.
}

unit uCoOpSelect;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  uBaseForm, ActnList, dxBar, dxBarExtItems, cxControls, dxStatusBar,
  cxContainer, cxEdit, cxLabel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridLevel, cxClasses, cxGridCustomView, cxGrid,
  db, dbTables;

type
  TfmCoOpSelect = class(TBaseForm)
    CoOpGridDBTableView: TcxGridDBTableView;
    CoOpGridLevel: TcxGridLevel;
    CoOpGrid: TcxGrid;
    CoOpGridDBTableViewID: TcxGridDBColumn;
    CoOpGridDBTableViewCoOpName: TcxGridDBColumn;
    CoOpGridDBTableViewUseAsDefault: TcxGridDBColumn;
    cxLabel1: TcxLabel;
    procedure CoOpGridDBTableViewUseAsDefaultPropertiesChange(
      Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function GetCoOpName : string; // returns user selected CoOp
    class function GetDefaultCoOpName : string; // returns CoOp saved from DB.
  end;

  function GetDefaultCoOp : string;

var
  fmCoOpSelect: TfmCoOpSelect;

implementation

uses AccsData;

{$R *.DFM}

procedure TfmCoOpSelect.CoOpGridDBTableViewUseAsDefaultPropertiesChange(
  Sender: TObject);
begin
  inherited;
    try
       with TQuery.Create(nil) do
          try
             DatabaseName := AccsDataModule.AccsDataBase.AliasName;
             SQL.Clear;
             SQL.Add('UPDATE ' + AccsDataModule.ImportDefaults.TableName);
             SQL.Add('SET UseAsDefault = FALSE');
             SQL.Add('WHERE ( ID <> :ID ) ');
             Params[0].asInteger := AccsDataModule.ImportDefaultsID.AsInteger;
             ExecSQL;
          finally
             Free;
          end;

       CoOpGridDBTableView.DataController.RefreshExternalData;
    except
       MessageDlg('Cannot Set Co-Op Default',mtError,[mbOK],0);
    end;
end;

class function TfmCoOpSelect.GetCoOpName: string;
begin
   with TfmCoOpSelect.Create(nil) do
      try
         Result := GetDefaultCoOp;
         if not AccsDataModule.ImportDefaults.Locate('CoOpName', Result, []) then
            AccsDataModule.ImportDefaults.First;
         ShowModal;
      finally
         Result := GetDefaultCoOp;
         Free;
      end;
end;

function GetDefaultCoOp: string;
begin
   Result := 'Unknown';
   with TQuery.Create(nil) do
      try
         DatabaseName := AccsDataModule.AccsDataBase.AliasName;
         SQL.Clear;
         SQL.Add('SELECT CoOpName');
         SQL.Add('FROM ' + AccsDataModule.ImportDefaults.TableName);
         SQL.Add('WHERE UseAsDefault = TRUE');
         Open;
         try
            First;
            Result := Fields[0].AsString;
         finally
            Close;
         end;
         // Ensure record is positioned on correct coop record.
         AccsDataModule.ImportDefaults.Locate('CoOpName', Result, []);
      finally
         Free;
      end;
end;

class function TfmCoOpSelect.GetDefaultCoOpName: string;
begin
   Result := GetDefaultCoOp;
end;

end.
