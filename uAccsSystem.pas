unit uAccsSystem;

interface

type
   TSystemType = (stCashbook, stLedger, stLedgerWithCashbook);
   TSystemOption = (soVAT, soEnterprises, soBilling, soInvoicerJobcards);
   TSystemOptions = set of TSystemOption;

   AccsSystem = class
   public
     class function SystemType : TSystemType;
     class function SystemOptions : TSystemOptions;
     class function Region: string;
   end;

implementation
uses
   VARS, SysUtils;

{ TSystemModule }

class function AccsSystem.SystemOptions: TSystemOptions;
begin
   Result := [];

   // if cash11.XUse_Vat value is False - the System is using VAT Module.
   // Not sure why this approach was taken.
   if not cash11.XUse_Vat then
      Include( Result, soVAT);

   if not cash11.Xuse_enterprise then
      Include( Result, soEnterprises);

   if not cash11.xbilling then
      Include( Result, soBilling);

   if cash2.XWININV then
      Include( Result, soInvoicerJobcards);
end;

class function AccsSystem.SystemType: TSystemType;
begin
    if ((cash1.Xcashbook = true) and (Cash11.xuse_inc_exp = false)) then
       Result := stCashbook
    else if ((cash1.Xcashbook = false) and (Cash11.xuse_inc_exp = true)) then
       Result := stLedger
    else if ((cash1.Xcashbook = false) and (Cash11.xuse_inc_exp = false)) then
       Result := stLedgerWithCashbook
    else
       Exception.Create('Invalid System Type');
end;

class function AccsSystem.Region: string;
begin
   Result := 'Unknown';
   if (cash2.xcountry = 1) then
      Result := 'UK'
   else if (cash2.xcountry = 2) then
      Result := 'ROI';
end;

end.
