unit Calcamt;

interface                          

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TcalcamtForm = class(TForm)
    Panel1: TPanel;
    UnitQuantityLabel: TLabel;
    UnitCostLabel: TLabel;
    UnitTotalLabel: TLabel;
    UnitQuantityEdit: TEdit;
    UnitCostEdit: TEdit;
    UnitTotalEdit: TEdit;
    UnitReset: TBitBtn;
    UnitOk: TBitBtn;
    Bevel1: TBevel;
    procedure FormShow(Sender: TObject);
    procedure UnitQuantityEditExit(Sender: TObject);
    procedure UnitOkClick(Sender: TObject);
    procedure UnitResetClick(Sender: TObject);
    procedure UnitCostEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UnitCostEditEnter(Sender: TObject);
     procedure CalcTotal; // TGM AB 13/06/02 moved from private
  private
    { Private declarations }
    pPrice,
    DefaultCost : LongInt;
    procedure SetDefaultCostPerUnit ( Value : LongInt );

    function GetProductsPrice : LongInt;
    procedure SetProductsPrice ( Value : LongInt);
  public
    { Public declarations }
    TempNom   : Integer;
    SQuantity : Shortstring;
    SCost : Shortstring;
    STotalCost : Shortstring;
    OkClicked : Boolean;
    property DefaultCostPerUnit : LongInt read DefaultCost write SetDefaultCostPerUnit Default 0;
    property ProductPrice : LongInt read GetProductsPrice write SetProductsPrice Default 0;
  end;

var
  calcamtForm: TcalcamtForm;

implementation
uses
    Vars,
    DBGen,
    calcs,
    langunit,
    Types,
    NewListing,
    Clears,
    Grids,
    AccsData,
{}  Cashbook;

Var Quantity, Cost : Double;

{$R *.DFM}

procedure TcalcamtForm.SetDefaultCostPerUnit ( Value : LongInt );
begin
    if Value <> DefaultCost then
       DefaultCost := Value;
end;

procedure TcalcamtForm.SetProductsPrice ( Value : LongInt );
begin
    if Value <> pPrice then
       pPrice := Value;
end;

function TcalcamtForm.GetProductsPrice : LongInt;
begin
    try
       if CashBookForm.DefaultProduct = 0 then
          begin
             if AccsDataModule.NominalList.Locate('Account',TempNom,[] ) then
                if AccsDataModule.Products.Locate('ID',AccsDataModule.NominalList.FieldByName('Product').AsVariant,[] ) then
                   if AccsDataModule.Products.FieldByName('UseDefaultPrice').AsBoolean then
                      RESULT := ROUND(AccsDataModule.Products.FieldByName('DefaultPrice').AsFloat*100);
          end
       else if AccsDataModule.Products.Locate('ID',CashBookForm.DefaultProduct,[] ) then
          if AccsDataModule.Products.FieldByName('UseDefaultPrice').AsBoolean then
             RESULT := ROUND(AccsDataModule.Products.FieldByName('DefaultPrice').AsFloat*100);
    except

    end;
end;

procedure TcalcamtForm.FormShow(Sender: TObject);
var
   LQuantity, LCost : Longint;
Begin
    CalcamtForm.Caption := ReadLang (143, CurrLang);
    UnitCostLabel.Caption := ReadLang (144, CurrLang);
    UnitQuantityLabel.Caption := ReadLang (145, CurrLang);
    UnitTotalLabel.Caption := ReadLang (146, CurrLang);
    Quantity := 0;
    OKClicked := False;
    Cost := 0;
    Slimall(SQuantity);
    StrLong(SQuantity, LQuantity);
    Slimall(SCost);
    if Length (SCost)>0 then
       StrLong(SCost, LCost);
    UnitQuantityEdit.Text := SQuantity;

    // take the default and assign to edit box
    // try and get a Unit Cost from the Products file
    if NOT Cash11.xBilling then
       if ProductPrice <> 0 then
          DefaultCostPerUnit := ProductPrice;

    LCost := DefaultCostPerUnit;
    LongStr ( LCost, SCost, 'L' );

    UnitCostEdit.Text := SCost;
    {SCost := '';}
    STotalCost := '';
    UnitTotalEdit.Text := '';
    UnitQuantityEditExit(UnitQuantityEdit);
    UnitQuantityEditExit(UnitCostEdit);

    // Set Focus to Unit Quantity
    UnitQuantityEdit.SetFocus;
end;

procedure TcalcamtForm.UnitQuantityEditExit(Sender: TObject);
Var TempStr : Shortstring;
    TempLong : LongInt;

begin
     Tempstr := (Sender as Tedit).Text;
     Slimall (TempStr);
     If NOT ChangeToLong (TempStr) then
        (sender as Tedit).SetFocus
     else
        begin
           (Sender as TEdit).Text := TempStr;
           StrLong ( TempStr, TempLong );
           if (Sender as TEdit).Name = 'UnitCostEdit' then
              DefaultCostPerUnit := TempLong;
           CalcTotal;
        end;
end;

procedure TcalcamtForm.CalcTotal;
var
   tStr,
   SQty,
   SCst   : ShortString;
   NTotal : Double;
   LQty,
   LCst   : LongInt;
begin
     SQty := UnitQuantityEdit.Text;
     SCst := UnitCostEdit.Text;
     Strlong(SQty, LQty);
     Strlong(SCst, LCst);

     NTotal := LCst * LQty / 100;
     DoubleToStr ( NTotal, TStr, '%8.2f', True, True, 8, True );
     SLIMALL(TStr);
     UnitTotalEdit.Text := tStr;
end;

procedure TcalcamtForm.UnitOkClick(Sender: TObject);
var
    NewTotal : Double;
    TempStr : ShortString;
    LCost, LQuantity : LongInt;
begin {ON OK Button press: Calulate the Total}
{-->>     NewTotal := 0;}
     SQuantity := UnitQuantityEdit.Text;
     SCost := UnitCostEdit.Text;
     Strlong(SQuantity, LQuantity);
     Strlong(SCost, LCost);

     DefaultCostPerUnit := LCost;

     Quantity := LQuantity;
{     if (LCost > 0 )and(LQuantity > 0)then}
        begin
             Cost := LCost;
             NewTotal := Cost * Quantity / 100;
             DoubleToStr ( NewTotal, TempStr, '%8.2f', True, True, 8, True );
             SLIMALL(TempStr);

             UnitTotalEdit.Text := Tempstr;
             STotalCost := TempStr;

             OkClicked := True;
             Close;
         End;
end;  {End of UnitOkClick}

procedure TcalcamtForm.UnitResetClick(Sender: TObject);
begin {This procedure clears the variables and inputs}
     Close;
end; {End of UnitReset Click}

procedure TcalcamtForm.UnitCostEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If Cash2.XCOUNTRY = 2 Then
        If Key = VK_F5 then
           (Sender As TEdit).Text := EuroConvert( (Sender as TEdit).Text );
end;

procedure TcalcamtForm.UnitCostEditEnter(Sender: TObject);
begin
    UnitCostEdit.SelectAll;
end;

end.


