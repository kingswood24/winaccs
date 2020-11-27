unit uEditAssocItem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxControls, cxPC, db, dbTables, StdCtrls, cxButtons, DBCtrls,
  Mask, cxContainer, cxEdit, cxLabel, Global, Types, ActnList,
  uDefImgStore;

type
  TAssocItemType = (itProducts);
  TfmEditAssocItem = class(TForm)
    pcItemType: TcxPageControl;
    tsProducts: TcxTabSheet;
    btnCancel: TcxButton;
    btnSave: TcxButton;
    lDefaultPrice: TLabel;
    DefaultPrice: TDBEdit;
    cbUseDefaultPrice: TDBCheckBox;
    ProductUnitComboBox: TDBComboBox;
    lUnit: TLabel;
    lItemDesc: TcxLabel;
    ActionList: TActionList;
    actSave: TAction;
    actCancel: TAction;
    actExit: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
  private
    { Private declarations }
    FTable : TTable;
    FDataSource : TDataSource;
    FTableName : String;
    FAssocItemType : TAssocItemType;
    FItemID : Integer;
  public
    { Public declarations }
    class procedure ShowTheForm ( AItemID : Integer; AAssocItemType : TAssocItemType );
  end;

var
  fmEditAssocItem: TfmEditAssocItem;

implementation

{$R *.DFM}

{ TfmEditAssocItem }

procedure TfmEditAssocItem.FormCreate(Sender: TObject);
begin
   if ( FTable = nil ) then
      FTable := TTable.Create(nil);
   FTable.DatabaseName := Global.AliasName;

   FDataSource := TDataSource.Create(nil);
   FDataSource.DataSet := FTable;
end;

class procedure TfmEditAssocItem.ShowTheForm ( AItemID : Integer; AAssocItemType : TAssocItemType );
begin
   with TfmEditAssocItem.Create(nil) do
      try
         FAssocItemType := AAssocItemType;
         case AAssocItemType of
            itProducts : begin
                            Caption := 'Edit Product';
                            FTableName := 'Products';
                            pcItemType.ActivePageIndex := tsProducts.PageIndex;
                         end;
         end;
         FItemID := AItemID;
         ShowModal;
      finally
         Free;
      end;
end;

procedure TfmEditAssocItem.FormActivate(Sender: TObject);
var
   i : Integer;
begin
   FTable.TableName := FTableName;
   if ( not(FTable.Exists) ) then
      begin
         MessageDlg(Format('&s table does not exist in the database.'+#13#10+
                           'Contact Kingswood Computing Ltd.',[FTableName]),mtError,[mbOK],0);
         PostMessage(Handle, WM_CLOSE,0,0);
      end;
   FTable.Open;
   if ( not(FTable.Locate('ID',FItemID,[])) ) then
      begin
         MessageDlg(Format('Unable to locate ItemID &d in the table.'+#13#10+
                           'Contact Kingswood Computing Ltd.',[FTableName]),mtError,[mbOK],0);
         PostMessage(Handle, WM_CLOSE,0,0);
      end
   else
      begin
         case FAssocItemType of
            itProducts : begin
                            lItemDesc.Caption := FTable.FieldByName('Desc1').AsString;
                            DefaultPrice.DataSource := FDataSource;
                            cbUseDefaultPrice.DataSource := FDataSource;
                            ProductUnitComboBox.DataSource := FDataSource;
                            ProductUnitComboBox.Items.Clear;
                            for i := 0 to Length(ProductUnitTypes)-1 do
                               ProductUnitComboBox.Items.Add(ProductUnitTypes[i]);
                         end;
         end;
         if ( not(FTable.State in dsEditModes) ) then
            FTable.Edit;
      end;
   OnActivate := nil;
end;

procedure TfmEditAssocItem.actSaveExecute(Sender: TObject);
begin
   if ( FTable.State in dsEditModes ) then
      begin
         FTable.Post;
         btnCancel.Action := actExit;
         actSave.Enabled := False;
      end;
end;

procedure TfmEditAssocItem.actCancelExecute(Sender: TObject);
var
   sAssocItem : String;
begin
   if ( FTable.State in dsEditModes ) then
      FTable.Cancel;
   case FAssocItemType of
      itProducts : sAssocItem := 'Product';
   end;
   if ( MessageDlg(Format('%s update cancelled.'+#13#10+
                          'Exit now?',[sAssocItem]),mtConfirmation,[mbYes,mbNo],0) = mrYes ) then
      PostMessage(Handle, WM_CLOSE,0,0)
   else
      actSave.Enabled := True;
end;

procedure TfmEditAssocItem.actExitExecute(Sender: TObject);
begin
   Close;
end;

procedure TfmEditAssocItem.FormDestroy(Sender: TObject);
begin
   if ( FTable <> nil ) then
      begin
         FTable.Free;
         FTable := nil;
      end;
   if ( FDataSource <> nil ) then
      begin
         FDataSource.Free;
         FDataSource := nil;
      end;
end;

end.
