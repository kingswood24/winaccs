unit uAccsTransaction;

interface
uses
   Classes, SysUtils, Windows, Messages, uAccounts, Calcs;

type
   TTransactionState = (tsNone, tsUnchanged, tsModified, tsError, tsUpdated, tsCreated);

   TTransactionBase = class
   private
      FTradeAccount: TTradeAccount;
      FComment: String;
      FReference: String;
      FTransactionDate: TDateTime;
      FClientId: string;
      FTransactionId: Integer;
      FTransactionState: TTransactionState;
      function GetTransactionId: Integer;
      procedure SetComment(const Value: String);
      procedure SetTransactionDate(const Value: TDateTime);
      procedure SetTradeAccount(const Value: TTradeAccount);
   protected
      procedure UpdateState();
   public
      constructor create(const ATransactionId: Integer = 0);
      property ClientId : string read FClientId;
      property TradeAccount : TTradeAccount read FTradeAccount write SetTradeAccount;
      property Comment : String read FComment write SetComment;
      property TransactionDate : TDateTime read FTransactionDate write SetTransactionDate;
      property TransactionState: TTransactionState read FTransactionState write FTransactionState;
      property TransactionId : Integer read GetTransactionId;
   end;

   TInvoice = class;
   TInvoiceClass = class of TInvoice;

   TTransactionLine = class
   private
    FDescription: String;
    FQuantity: Double;
    FAmount: Double;
    FClientId: string;
    procedure SetAmount(const Value: Double);
    procedure SetDescription(const Value: String);
    procedure SetQuantity(const Value: Double);
   protected
    procedure UpdateState();virtual;
   public
    constructor create();
    property ClientId : string read FClientId;
    property Description : String read FDescription write SetDescription;
    property Quantity : Double read FQuantity write SetQuantity;
    property Amount : Double read FAmount write SetAmount;
   end;

   TInvoiceLine = class(TTransactionLine)
   private
    FNominal: TNominalAccount;
    //FEnterprise: TEnterpriseAccount;
    FVATCode: String;
    FVATAmount: Double;
    FNominalFreeTxt: String;
    procedure SetNominal(const Value: TNominalAccount);
    procedure SetVATAmount(const Value: Double);
    procedure SetVATCode(const Value: String);
    procedure SetNominalFreeTxt(const Value: String);
      //procedure SetEnterprise(const Value: TEnterpriseAccount);
   protected
    FParent: TInvoice;
    procedure UpdateState();override;
   public
    constructor create(AParent: TInvoice);
    destructor destroy;override;
    property Nominal : TNominalAccount read FNominal write SetNominal;
    //property Enterprise : TEnterpriseAccount read FEnterprise write SetEnterprise;
    property VATCode : String read FVATCode write SetVATCode;
    property VATAmount : Double read FVATAmount write SetVATAmount;
    property NominalFreeTxt : String read FNominalFreeTxt write SetNominalFreeTxt;
   end;

   TInvoiceLines = class(TList)
   private
    function GetCount: Integer;
    function GetLine(Index: Integer): TInvoiceLine;
    procedure SetLine(Index: Integer; const Value: TInvoiceLine);
   public
    constructor create;
    destructor destroy;override;
    function Add(ALine: TInvoiceLine): Integer;
    function Remove(ALine: TInvoiceLine): Integer;
    function IndexOf(AUId : String): TInvoiceLine;
    function Get(const AUId : String) : TInvoiceLine;
    procedure Clear;override;
    property TransactionLine[Index: Integer]: TInvoiceLine read GetLine write SetLine; default;
    property Count : Integer read GetCount;
   end;

   TInvoice = class(TTransactionBase)
   private
      FLines: TInvoiceLines;
      FReference: String;
      FStubNo: Integer;
    procedure SetReference(const Value: String);
    procedure SetStubNo(const Value: Integer);
   protected
      FValidationErrors : TStringList;
      FErrors : TStringList;
   public
      constructor create(const ATransactionId: Integer = 0);
      destructor destroy();override;
      function IsValid() : Boolean;
      procedure AddLine(
        const ANominal : TNominalAccount;
        //const AStubNo : string; const AReference : string;
        const AQuantity: Double; const AAmount: Double;
        const AVATCode: string; const AVATAmount: Double;
        const ANominalFreeTxt : string);
      procedure UpdateLine(const AIndex : Integer;
        const ANominal : TNominalAccount;
        //const AStubNo : string; const AReference : string;
        const AQuantity: Double; const AAmount: Double;
        const AVATCode: string; const AVATAmount: Double);

      property Reference : String read FReference write SetReference;
      property StubNo : Integer read FStubNo write SetStubNo;
      property Lines : TInvoiceLines read FLines write FLines;
      property Errors: TStringList read FErrors;
   end;

   TPurchaseInvoice = class(TInvoice)
   private
      FSupplierId: integer;
      function IsValid() : Boolean; overload;
    procedure SetSupplierId(const Value: integer);
   public
      // Sample
      property SupplierId : integer read FSupplierId write SetSupplierId;
   end;

   TSaleInvoice = class(TInvoice)
   private
      FCustomerId: integer;
      function IsValid() : Boolean; overload;
    procedure SetCustomerId(const Value: integer);
   public
      property CustomerId : integer read FCustomerId write SetCustomerId;
   end;

{
   TTransaction = class
   private
      FTransactionType: TTransactionType;
      FTransactionHead: TTransactionHead;
      FTransactionLines: TTransactionLines;
   public
      property TransactionType : TTransactionType read FTransactionType write FTransactionType;
      property TransactionHead : TTransactionHead read FTransactionHead write FTransactionHead;
      property TransactionLines : TTransactionLines read FTransactionLines write FTransactionLines;
   end;
}

implementation
uses
   AccsUtils;

{ TTransactionLines }

function TInvoiceLines.Add(ALine: TInvoiceLine): Integer;
begin
   Result := inherited Add( TInvoiceLines(ALine) );
end;

procedure TInvoiceLines.Clear;
var
   i : Integer;
begin
  for i := 0 to Count-1 do
     TInvoiceLines(Items[i]).Free;
  Inherited Clear;
end;

constructor TInvoiceLines.create;
begin
   Inherited Create;
end;

destructor TInvoiceLines.destroy;
begin
   Clear;
   inherited;
end;

function TInvoiceLines.Get(const AUId: String): TInvoiceLine;
var
  i : Integer;
  Line : TInvoiceLine;
begin
  Result := nil;
  for i := 0 to Count-1 do
     begin
        Line := TInvoiceLine(Items[i]);
        if (Line <> nil) then
           begin
              if ( Line.ClientId = AUId ) then
                 begin
                    Result := Line;
                    Break;
                 end;
           end;
     end;
end;

function TInvoiceLines.GetCount: Integer;
begin
   Result := inherited Count;
end;

function TInvoiceLines.GetLine(Index: Integer): TInvoiceLine;
begin
   Result := TInvoiceLine(inherited Items[Index] );
end;

function TInvoiceLines.IndexOf(AUId: String): TInvoiceLine;
begin
   Result := Get(AUId);
end;

function TInvoiceLines.Remove(ALine: TInvoiceLine): Integer;
begin
   Result := Inherited Remove ( TInvoiceLine(ALine) ) ;
end;

procedure TInvoiceLines.SetLine(Index: Integer; const Value: TInvoiceLine);
begin
   Items[Index] := Value;
end;

{ TTransactionLine }

constructor TTransactionLine.create();
begin
   FClientId := GUID();
end;

procedure TTransactionLine.SetAmount(const Value: Double);
begin
   if (FAmount <> Value) then
      begin
         FAmount := Value;
         UpdateState();
      end;
end;

procedure TTransactionLine.SetDescription(const Value: String);
begin
   if (FDescription <> Value) then
      begin
         FDescription := Value;
         UpdateState();
      end;
end;

procedure TTransactionLine.SetQuantity(const Value: Double);
begin
   if (FQuantity <> Value) then
      begin
         FQuantity := Value;
         UpdateState();
      end;
end;

procedure TTransactionLine.UpdateState;
begin

end;

{ TInvoice }

procedure TInvoice.AddLine(
  const ANominal : TNominalAccount;
  //const AStubNo : string; const AReference : string;
  const AQuantity: Double; const AAmount: Double;
  const AVATCode: string; const AVATAmount: Double;
  const ANominalFreeTxt : string);
var
   Line : TInvoiceLine;
begin
   Line := TInvoiceLine.Create(self);
   Line.Nominal := ANominal;
   Line.Quantity := AQuantity;
   Line.Amount := AAmount;
   Line.VATCode := AVATCode;
   Line.VATAmount := AVATAmount;
   Line.NominalFreeTxt := ANominalFreeTxt;
   Lines.Add(Line);
end;

constructor TInvoice.create(const ATransactionId: Integer = 0);
begin
   inherited create(ATransactionId);
   FClientId := GUID();
   FValidationErrors := TStringList.Create;
   FErrors := TStringList.Create;
   FLines := TInvoiceLines.create;
end;

destructor TInvoice.destroy;
begin
  inherited;
  if (FLines <> nil) then
     FreeAndNil(FLines);
     
  if (FValidationErrors <> nil) then
     FreeAndNil(FValidationErrors);

  if (FErrors <> nil) then
     FreeAndNil(FErrors);
end;

function TInvoice.IsValid: Boolean;
var
   i, StartDate, EndDate : Integer;
begin
    // Check format of Invoice date???? - CHECK WITH SHANE
     { THIS CODE WAS MOVED OUT OF MoveTxInfo procedure
     if Length ( TestStr ) > 0 then // next line added by TGM - shortens yyyy year to yy
        if length(TestStr) = 10 then TestStr := copy(TestStr,1,6) + copy(TestStr,9,2);
        if NOT DateValid ( TestStr, TDateFormat ) then
           CorrectEntry := FALSE;}

   Result := ( TransactionDate > 0 );
   if ( not(Result) ) then Exit;

   for i := 0 to FLines.Count-1 do
      begin
         Result := ( FLines.TransactionLine[i].FNominal.Id > 0 );
         if ( not(Result) ) then Break;
      end;
end;

procedure TInvoice.SetReference(const Value: String);
begin
   if (FReference <> Value) then
      begin
         FReference := Value;
         UpdateState();
      end;
end;

procedure TInvoice.SetStubNo(const Value: Integer);
begin
   if (FStubNo <> Value) then
      begin
         FStubNo := Value;
         UpdateState();
      end;
end;

procedure TInvoice.UpdateLine(const AIndex : Integer;
  const ANominal: TNominalAccount;
  const AQuantity, AAmount: Double;
  const AVATCode: string;
  const AVATAmount: Double);
begin
   if (AIndex > FLines.Count-1) then
      raise Exception.Create('Invoice line index out of bounds.');
   FLines[AIndex].Nominal := ANominal;
   FLines[AIndex].Quantity := AQuantity;
   FLines[AIndex].Amount := AAmount;
   FLines[AIndex].VATCode := AVATCode;
   FLines[AIndex].VATAmount := AVATAmount;
   //FLines[AIndex].Description := ADescription;
end;

{ TPurchaseInvoice }

function TPurchaseInvoice.IsValid: Boolean;
begin
   Result := inherited IsValid;
   if ( not(Result) ) then Exit;
   Result := ( SupplierId > 0 );
end;

procedure TPurchaseInvoice.SetSupplierId(const Value: integer);
begin
   if (FSupplierId <> Value) then
      begin
         FSupplierId := Value;
         UpdateState();
      end;
end;

{ TSaleInvoice }

function TSaleInvoice.IsValid: Boolean;
begin
   //
end;

procedure TSaleInvoice.SetCustomerId(const Value: integer);
begin
   if (FCustomerId <> Value) then
      begin
         FCustomerId := Value;
         UpdateState();
      end;
end;

{ TInvoiceLine }

constructor TInvoiceLine.create(AParent: TInvoice);
begin
  inherited create;
  FParent := AParent;
  FNominal:= TNominalAccount.Create;
//  FEnterprise:= TEnterpriseAccount.Create;
end;

destructor TInvoiceLine.destroy;
begin
  inherited;
  if (FNominal <> nil) then
     FreeAndNil(FNominal);
  {if (FEnterprise <> nil) then
     FreeAndNil(FEnterprise); }
end;

{procedure TInvoiceLine.SetEnterprise(const Value: TEnterpriseAccount);
begin
   if (Value <> nil) then
      begin
         FEnterprise.Id := FEnterprise.Id;
         FEnterprise.Name := FEnterprise.Name;
      end;
end;}

procedure TInvoiceLine.SetNominal(const Value: TNominalAccount);
begin
   if (Value = nil) then Exit;

   if (FNominal.Id <> Value.Id) then
      begin
         FNominal.Id := Value.Id;
         FNominal.Name := Value.Name;
         FNominal.EntCode := Value.EntCode;
         UpdateState();
      end;
end;

procedure TInvoiceLine.SetNominalFreeTxt(const Value: String);
begin
   if (FNominalFreeTxt <> Value) then
      begin
         FNominalFreeTxt := Value;
         UpdateState();
      end;
end;

procedure TInvoiceLine.SetVATAmount(const Value: Double);
begin
   if (FVATAmount <> Value) then
      begin
         FVATAmount := Value;
         UpdateState();
      end;
end;

procedure TInvoiceLine.SetVATCode(const Value: String);
begin
   if (FVATCode <> Value) then
      begin
         FVATCode := Value;
         UpdateState();
      end;
end;

procedure TInvoiceLine.UpdateState;
begin
   if (FParent <> nil) and (FParent.TransactionState = tsUnchanged) then
      FParent.TransactionState := tsModified;
end;

{ TTransactionBase }

constructor TTransactionBase.create(const ATransactionId: Integer = 0);
begin
   FTransactionState := tsNone;
   if (ATransactionId>0) then
      FTransactionId := ATransactionId;
end;

function TTransactionBase.GetTransactionId: Integer;
begin
   Result := FTransactionId;
end;

procedure TTransactionBase.SetComment(const Value: String);
begin
   if (FComment <> Value) then
      begin
         FComment := Value;
         UpdateState();
      end;
end;

procedure TTransactionBase.SetTradeAccount(const Value: TTradeAccount);
begin
   if (FTradeAccount <> Value) then
      begin
         FTradeAccount := Value;
         UpdateState();
      end;
end;

procedure TTransactionBase.SetTransactionDate(const Value: TDateTime);
begin
   if FTransactionDate <> Value then
      begin
         FTransactionDate := Value;
         UpdateState();
      end;
end;

procedure TTransactionBase.UpdateState;
begin
   if (TransactionState = tsUnchanged) then
      TransactionState := tsModified;
end;

end.
