unit uMTDApi;

interface
uses
   Classes, Forms, Dialogs, uAccounts, HTTP, JSON, LoginCredentials;

type
  TMTDApi = class
  private
   FLastError: string;
   FBaseUrl: string;
   FRawReceipt: string;
   FHTTP: THTTP;
   FCustomHeaders : TStringList;
   FLoginCredentials: TLoginCredentials;
   function GetAccessToken(): string;
   procedure LoadParams();
  public
   constructor create(const ALoginCredentials: TLoginCredentials);
   destructor destroy;override;
   function GetReceipt(const ATransactionId: string) : TMTDVATReceipt;
   function ValidateCredentials(): boolean;
   property LastError: string read FLastError;
   property RawReceipt: string read FRawReceipt write FRawReceipt;
  end;

                       //D3E7C10F-63F2-4891-AA42-2A98562DC6EC

const
   BASE_URL = 'https://www.kingswoodfarm.ie/accounts/mtd/api';
   TOKEN_URI = '/token';
   RECEIPT_URI = '/vat/receipt?transactionId=%s';

implementation
uses
   FileCtrl, SysUtils, AccsUtils, IdHTTP;
{ TMTDApi }

constructor TMTDApi.create(const ALoginCredentials: TLoginCredentials);
begin
   FHTTP := THTTP.create();
   FLoginCredentials:= ALoginCredentials;
   FRawReceipt := FRawReceipt;
   FCustomHeaders := TStringList.Create;
   LoadParams();
end;

destructor TMTDApi.destroy;
begin
  inherited;
  if (FHTTP <> nil) then
     FHTTP.Free;
  if (FCustomHeaders <> nil) then
     FCustomHeaders.Free;
end;

function TMTDApi.GetAccessToken: string;
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

function TMTDApi.GetReceipt(const ATransactionId: string): TMTDVATReceipt;
var
   AccessToken: string;
   HttpResponse: string;
   HttpErrorResponse: EIdHTTPProtocolException;
   ErrorHandled: Boolean;
   ErrorMessage: string;
   JSONResponse: JSONItem;
   JSONErrorResponse: JSONItem;
begin
   Result := nil;
   FRawReceipt := '';

   AccessToken := GetAccessToken();
   if (AccessToken='') then Exit;

   ErrorHandled := False;

   FCustomHeaders.Clear;
   FCustomHeaders.Values['Authorization'] := 'Bearer ' + AccessToken;
   FCustomHeaders.Values['client-name'] := 'kw-accs';

   try
      HttpResponse := FHTTP.Get(FBaseUrl + Format(RECEIPT_URI,[ATransactionId]), 'application/json', FCustomHeaders);
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

        Result := TMTDVATReceipt.create;
        Result.ProcessingTimeStamp := JSONResponse['processingDate'].getStr();
        Result.BundleNumber := JSONResponse['formBundleNumber'].getStr();
        Result.PaymentIndicator := JSONResponse['paymentIndicator'].getStr();

        FRawReceipt := JSONResponse.Code;
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

procedure TMTDApi.LoadParams;
var
   FileName: string;
   Params: TStringList;
begin
   FBaseUrl := BASE_URL;
   FileName := ExtractFilePath(Application.ExeName) + 'mtd_params.txt';
   if not (FileExists(FileName)) then Exit;

   Params := TStringList.Create;
   try
      try
         Params.LoadFromFile(FileName);
         FBaseUrl := IfThenElse(Params.IndexOfName('API_URL')>-1,Params.Values['API_URL'],BASE_URL);
      except
         FBaseUrl := BASE_URL;
      end;
   finally
      FreeAndNil(Params);
   end;
end;

function TMTDApi.ValidateCredentials: boolean;
begin
   Result := GetAccessToken() <> '';
end;

end.
