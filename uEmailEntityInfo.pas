unit uEmailEntityInfo;

interface

uses
   DBCore, Vars;

type
   TEntityInfo = class
   private
     FEntityId : Integer;
     FEmailAddress: string;
     FName: string;
   public
      constructor create(AEntityId : Integer);
      function GetCustSuppInfo(ALedgerDB, ARecID: Integer): TEntityInfo;
      property Name : string read FName write FName;
      property EmailAddress : string read FEmailAddress write FEmailAddress;
   end;

implementation

{ TEntityInfo }

constructor TEntityInfo.create(AEntityId: Integer);
begin
   FEntityId := AEntityId;
   Name := 'Invoice'; // Default to invoice just in case customer/supplier does not contain a name.
end;

function TEntityInfo.GetCustSuppInfo(ALedgerDB, ARecID: Integer): TEntityInfo;
begin
   Result := TEntityInfo.Create(ARecID);
   SetDb ( ALedgerDB );
   ReadRec ( ALedgerDB, ARecID );
   if RecActive ( ALedgerDB ) then
      begin
         // Get the Name
         GetItem ( ALedgerDB, 1 );
         Result.Name := CurrStr;

         // Get the Email Address
         GetItem ( ALedgerDB, 32 );
         Result.EmailAddress := CurrStr;
      end;
end;

end.
 