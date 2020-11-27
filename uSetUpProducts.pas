unit uSetUpProducts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Mask, DBCtrls, Grids, DBGrids;

type
  TfSetUpProducts = class(TForm)
    Panel7: TPanel;
    ExitProducts: TBitBtn;
    sbSave: TBitBtn;
    sbDelete: TBitBtn;
    sbAdd: TBitBtn;
    sbCancel: TBitBtn;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    DBEdit4: TDBEdit;
    Label2: TLabel;
    DBCheckBox1: TDBCheckBox;
    ProductUnitComboBox: TDBComboBox;
    Label3: TLabel;
    procedure sbSaveClick(Sender: TObject);
    procedure sbAddClick(Sender: TObject);
    procedure sbCancelClick(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
    procedure ExitProductsClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSetUpProducts: TfSetUpProducts;

implementation
uses
   db,
   AccsData;

{$R *.DFM}

procedure TfSetUpProducts.sbSaveClick(Sender: TObject);
begin
    if AccsDataModule.Products.Active then
       if AccsDataModule.Products.State in dsEditmodes then
          AccsDataModule.Products.Post;
end;

procedure TfSetUpProducts.sbAddClick(Sender: TObject);
begin
    if not AccsDataModule.Products.Active then AccsDataModule.Products.open;
       AccsDataModule.Products.Append;
       AccsDataModule.Products['UseDefaultPrice'] := True;
       AccsDataModule.Products['DefaultPrice'] := 0;
end;

procedure TfSetUpProducts.sbCancelClick(Sender: TObject);
begin
    if AccsDataModule.Products.Active then
       AccsDataModule.Products.Cancel;
end;

procedure TfSetUpProducts.sbDeleteClick(Sender: TObject);
begin
    if AccsDataModule.Products.Active then
       if MessageDLG('OK to Delete',mtWarning,[mbYes,mbNo],0) = mrYes then
          AccsDataModule.Products.Delete;
end;

procedure TfSetUpProducts.ExitProductsClick(Sender: TObject);
begin
    Close;
end;

procedure TfSetUpProducts.FormActivate(Sender: TObject);
begin
    //if AccsDataModule.Products.Active then
    //   AccsDataModule.Products.Append;
end;

procedure TfSetUpProducts.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    // Make sure to call cancel so drop down list still works
    if AccsDataModule.Products.Active then
       AccsDataModule.Products.Cancel;
end;

procedure TfSetUpProducts.FormCreate(Sender: TObject);
begin
   AccsDataModule.GetProductUnits(ProductUnitComboBox.Items);
end;

end.
