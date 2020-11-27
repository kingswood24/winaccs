unit uProductListing;

(* TGM AB 17/04/15

Small unit used to display / filter products with the option to allow the user to select the required product or click
to bring up the add / remove product unit.

Typical Useage -

Create from on fly before calling -

eg. If not bool(ProductListingForm) then Application.CreateForm(TProductListingForm, ProductListingForm);

To call the form use ShowProductListing passing in the search string as a parameter (this may be blank and hence
all the products will be shown)

eg ProductListingForm.ShowProductListing('bail') or ProductListingForm.ShowProductListing('')

The ID of the selected product is returned via ProductListingForm.ProductID. The value of 0 is returned if not product
is selected

*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, Db, DBTables, RXDBCtrl;

type
  TProductListingForm = class(TForm)
    Searchfield: TEdit;
    Searchlabel: TLabel;
    Panel1: TPanel;
    AddRemoveButton: TBitBtn;
    ListSelect: TBitBtn;
    ListCancel: TBitBtn;
    ProductsQuery: TQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    procedure SearchfieldChange(Sender: TObject);
    procedure ListSelectClick(Sender: TObject);
    procedure ListCancelClick(Sender: TObject);
    procedure AddRemoveButtonClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    ProductID : integer;
    procedure ShowProductListing(SearchString: String);


  end;

var
  ProductListingForm: TProductListingForm;

implementation

uses uSetUpProducts, AccsData;

{$R *.DFM}

procedure TProductListingForm.ShowProductListing(SearchString: String);
begin
        ProductID := 0;
        ProductsQuery.close;
        ProductsQuery.DatabaseName := AccsDataModule.AccsDatabase.DatabaseName;
        ProductsQuery.sql.Clear;
        ProductsQuery.sql.Add('Select * from Products');
        ProductsQuery.open;
        if SearchString <> '' then begin
                       Searchfield.text := Searchstring;
        end else begin
                       Searchfield.text := '';
                end;
        SearchField.SelStart := Length(SearchField.Text);
        self.showmodal;

end;

procedure TProductListingForm.SearchfieldChange(Sender: TObject);
begin
                ProductsQuery.close;
                ProductsQuery.sql.Clear;
                ProductsQuery.sql.Add('Select * from Products where lower(desc1) like ''%' + lowercase(Searchfield.text) + '%''');
                ProductsQuery.open;
end;

procedure TProductListingForm.ListSelectClick(Sender: TObject);
begin
       ProductID := ProductsQuery['ID'];
       ProductsQuery.close;
       self.close;
end;

procedure TProductListingForm.ListCancelClick(Sender: TObject);
begin
       ProductID := 0;
       ProductsQuery.close;
       self.close;
end;

procedure TProductListingForm.AddRemoveButtonClick(Sender: TObject);
begin
        If not bool(fSetUpProducts) then application.createform(TfSetUpProducts,fSetUpProducts);
        fSetupProducts.showmodal;
        SearchfieldChange(self);
end;

procedure TProductListingForm.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
    TFloatField(ProductsQuery.FieldByName('DefaultPrice')).DisplayFormat := '0.000';            // TGM AB 22/09/17
end;

end.
