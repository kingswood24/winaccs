unit uAccountsAPI;

interface
uses
   Classes, Forms, Dialogs, uAccounts, HTTP, JSON, LoginCredentials, SysUtils;

type
   TCustomers = array of TAccountBase;
   TAccountsAPI = class
   private
      FBaseUrl: string;
      FLastError: string;
      FRawReceipt: string;
      FHTTP: THTTP;
      FCustomHeaders : TStringList;
      FLoginCredentials: TLoginCredentials;
      function GetAccessToken: string;
   public
      constructor create(const ALoginCredentials: TLoginCredentials);
      destructor destroy;override;
      function GetCustomers: TCustomers;
      function ValidateCredentials: boolean;
   end;

const
   BASE_URL = 'https://www.kingswoodfarm.ie/accounts/api';
   TOKEN_URI = '/token';
   CUSTOMERS_URI = '/customers';
   PRODUCTS_URI = '/products';

implementation
uses
   FileCtrl, AccsUtils, IdHTTP;

{ TAccountsAPI }

constructor TAccountsAPI.create(const ALoginCredentials: TLoginCredentials);
begin
   FHTTP := THTTP.create();
   FLoginCredentials:= ALoginCredentials;
   FRawReceipt := FRawReceipt;
   FCustomHeaders := TStringList.Create;
end;

destructor TAccountsAPI.destroy;
begin
  inherited;
  if (FHTTP <> nil) then
     FHTTP.Free;
  if (FCustomHeaders <> nil) then
     FCustomHeaders.Free;
end;

function TAccountsAPI.GetAccessToken: string;
var
   Content: String;
   HttpResponse: string;
   JSONResponse: JSONItem;
begin
   Result := '';
   if (FLoginCredentials=nil) then
      begin
         if (FLastError='') then
            FLastError := 'It appears that you haven''t entered your login details.';
         Exit;
      end;

   Content := Format('grant_type=password&username=%s&password=%s',
         [FLoginCredentials.Username,FLoginCredentials.Password]);

   FCustomHeaders.Clear;
   FCustomHeaders.Values['client-name'] := 'kw-accs';

   try
      HttpResponse := FHTTP.Post(FBaseUrl + TOKEN_URI, Content, 'application/x-www-form-urlencoded', FCustomHeaders);
      if (Trim(HttpResponse) = '') then
         begin
            FLastError := 'HttpResponse parse error.';
            Exit;
         end;

      JSONResponse := JSONItem.Parse(HttpResponse);
      if (JSONResponse<>nil) then
         Result := JSONResponse['access_token'].getStr('')
   except
     on E: Exception do
        FLastError := 'Login error: ' + E.Message;
   end;
end;

function TAccountsAPI.GetCustomers: TCustomers;
var
   AccessToken: string;
   HttpResponse: string;
   HttpErrorResponse: EIdHTTPProtocolException;
   ErrorHandled: Boolean;
   ErrorMessage: string;
   JSONResponse: JSONItem;
   JSONErrorResponse: JSONItem;
   Customer: TAccountBase;
   I : Integer;
   Item, NestItem : JSONItem;
begin
   SetLength(Result, 0);

   FRawReceipt := '';

   AccessToken := GetAccessToken();
   if (AccessToken='') then Exit;

   ErrorHandled := False;

   FCustomHeaders.Clear;
   FCustomHeaders.Values['Authorization'] := 'Bearer ' + AccessToken;
   FCustomHeaders.Values['client-name'] := 'kw-accs';

   try
      HttpResponse := FHTTP.Get(FBaseUrl + CUSTOMERS_URI, 'application/json', FCustomHeaders);
      if (Trim(HttpResponse) = '') then
         begin
            FLastError := 'HttpResponse parse error.';
            Exit;
         end;

        JSONResponse := JSONItem.Parse(HttpResponse);
        if (JSONResponse=nil) then
           begin
              FLastError := 'JSON parse error.';
              Exit;
           end;

        for i := 0 to JSONResponse.Count-1 do
           begin
              Item := JSONResponse.Value[i];
              Customer := TAccountBase.create;
              Customer.Id := Item['transactionId'].getInt;
              {
              NestItem := Item['return'];
              with VATReceipt.VATReturn do
                 begin
                    VATDueSales := NestItem['vatduesales'].getNum();
                    VATDueAcquisitions := NestItem['vatdueacquisitions'].getNum();
                    TotalVATDue := NestItem['totalVatDue'].getNum();
                    VATReclaimedCurrPeriod :=NestItem['vatReclaimedCurrPeriod'].getNum();
                    NetVATDue := NestItem['netVatDue'].getNum();
                    totalValueSalesExVAT := NestItem['totalValueSalesExVAT'].getNum();
                    TotalValuePurchasesExVAT := NestItem['totalValuePurchasesExVAT'].getNum();
                    TotalValueGoodsSuppliedExVAT := NestItem['totalValueGoodsSuppliedExVAT'].getNum();
                    TotalAcquisitionsExVAT := NestItem['totalAcquisitionsExVAT'].getNum();
                    Finalised := LowerCase(NestItem['finalised'].getStr())='true';
                 end;
              }
              SetLength(Result, i+1);
              Result[i] := Customer;
           end;
      except
        on E: Exception do
          begin
             if (E is EIdHTTPProtocolException) then
                begin
                   HttpErrorResponse := (E as EIdHTTPProtocolException);
                   if (HttpErrorResponse<>nil) then
                      begin
                         if (HttpErrorResponse.ReplyErrorCode = 400) then
                            begin
                               ErrorHandled := True;
                               JSONErrorResponse := JSONItem.Parse(HttpErrorResponse.ErrorMessage);
                               if (JSONErrorResponse<>nil) then
                                  begin
                                     ErrorMessage := JSONErrorResponse.Item['message'].getStr();
                                     ErrorMessage := IfThenElse(ErrorMessage <> '',ErrorMessage, 'An error occurred while processing request');
                                     FLastError := Format('  Http Status(%d): %s ', [HttpErrorResponse.ReplyErrorCode, ErrorMessage]);
                                  end;
                            end;
                      end;
                end;

             if (not ErrorHandled) then
                FLastError := E.Message;
          end;
     end;
end;

function TAccountsAPI.ValidateCredentials: boolean;
begin
   Result := GetAccessToken() <> '';
end;

end.
