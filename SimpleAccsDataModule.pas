{
   17/09/19 [V4.5 R0.4] /MK Change - If "Auto Fill Comment and First Nominal" preference is ticked then store record in SLPLDefaults table.
                                   - If "Use Last Description as Comment" preference is ticked the set comment of invoice to last lines nominal descriptin if no comment.
}

unit SimpleAccsDataModule;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TYPES, uAccsTransaction, cxStyles, uPreferences, uPreferenceConsts;

type
  TSimpleAccsData = class(TDataModule)
    StyleRepository: TcxStyleRepository;
    cxGridStyleFocused: TcxStyle;
    cxGridStyleNormal: TcxStyle;
    cxGridStyleHeader: TcxStyle;
    cxGridStyleRow: TcxStyle;
  private
    { Private declarations }
    procedure SetVals;
    procedure CreateInvoice(const AInvoice: TPurchaseInvoice);overload;
    procedure CreateInvoice(const AInvoice: TSaleInvoice);overload;
    procedure UpdateInvoice(const AInvoice: TPurchaseInvoice);overload;
    procedure UpdateInvoice(const AInvoice: TSaleInvoice);overload;
  public
    { Public declarations }
    procedure CreateInvoice(AInvoiceList: TList);overload;
    procedure UpdateInvoice(const AInvoice: TInvoice);overload;
    function GetInvoice(const ATransactionId: Integer): TInvoice;

  end;

var
  SimpleAccsData: TSimpleAccsData;

implementation
uses
   VARS, TxWrite, Calcs, Clears, DBGen, uAccounts, AccsData, Cashbook,
   AccsUtils;

{$R *.DFM}

{ TSimpleAccsData }
procedure TSimpleAccsData.CreateInvoice(const AInvoice: TPurchaseInvoice);
var
   LineIndex : Integer;
   TestStr   : ShortString;
   InvoiceLine : TInvoiceLine;

   i : Integer;
begin
   ACT := 1;
   PROG := PURCHTX;

   InitVals;

   try
      zCustRec[1] := AInvoice.SupplierId;
      zAccount[1] := AInvoice.SupplierId;
      TestStr := DateToStr(AInvoice.TransactionDate);
      if length(TestStr) = 10 then
      TestStr := copy(TestStr,1,6) + copy(TestStr,9,2); // TGM AB Fix 4 digit year problem
      zTxDate[1] := KDateToInt ( TestStr );
      if (AInvoice.StubNo>0) then
         ZStub[1] := AInvoice.StubNo;
      zRef[1] := Copy(AInvoice.Reference,1,SizeOf(zRef[1]));

      if ( Cash11.xUseLastNomDesc ) and ( Length(Trim(AInvoice.Comment)) = 0 ) then
         begin
            if ( Length(AInvoice.Lines[AInvoice.Lines.Count-1].NominalFreeTxt) > 0 ) then
               zComm[1] := AInvoice.Lines[AInvoice.Lines.Count-1].NominalFreeTxt
            else
               zComm[1] := AInvoice.Lines[AInvoice.Lines.Count-1].Nominal.Name
         end
      else if ( Length(Trim(AInvoice.Comment)) > 0 ) then
         zComm[1] := Trim(AInvoice.Comment);

      LineIndex := 1;

      for i := 0 to AInvoice.Lines.Count-1 do
         begin
            InvoiceLine := AInvoice.Lines[i];
            zUse[1,LineIndex] := True;
            ZGen[1,LineIndex] := InvoiceLine.Nominal.Id;

            if ( Length(InvoiceLine.NominalFreeTxt) > 0 ) then
               ZDesc[1,LineIndex] := InvoiceLine.NominalFreeTxt
            else
               ZDesc[1,LineIndex] := Copy(InvoiceLine.Nominal.Name,1,SizeOf(zDesc[1,LineIndex]));

            if (Length(Trim(InvoiceLine.Nominal.EntCode)) > 0) then
               begin
                  zEnt[1,LineIndex] := InvoiceLine.Nominal.EntCode;
               end;

            // Quantity
            TestStr := FloatToStr(InvoiceLine.Quantity);
            SlimAll ( TestStr );
            ChangeToLong ( TestStr );
            StrLong ( TestStr, ZQty[1,LineIndex] );

            // Amount
            TestStr := FloatToStr(InvoiceLine.Amount);
            SlimAll ( TestStr );
            ChangeToLong ( TestStr );
            StrLong ( TestStr, ZAmt[1,LineIndex] );

            // VAT Code
            zTax[1,LineIndex] := InvoiceLine.VATCode;

            // VAT Amount
            TestStr := FloatToStrF(InvoiceLine.VATAmount,ffFixed,8,2);
            SlimAll(TestStr);
            ChangeToLong ( TestStr );
            StrLong(TestStr,zTaxAmt[1,LineIndex]);

            Inc ( LineIndex );
         end;
      CheckEnd;
      SetVals;
      ZStub[1] := 0;
      ZStub[2] := 0;
      WriteTransactions(1, PlFile, Act, FALSE );

      if ( Preferences.ValueAsBoolean[cPref_EnableSLPLDefaults] ) then
         begin
            AccsDataModule.SLPLDefaults.Open;
            if ( AccsDataModule.SLPLDefaults.Locate('SLPLCode;SLPLType',VarArrayOf([AInvoice.SupplierId,'P']),[])) then
               try
                  AccsDataModule.SLPLDefaults.Edit;
                  AccsDataModule.SLPLDefaults.FieldByName('Comment').AsString := AInvoice.Comment;
                  AccsDataModule.SLPLDefaults.FieldByName('Nominal').AsInteger := AInvoice.Lines[0].Nominal.Id;
                  AccsDataModule.SLPLDefaults.FieldByName('Ent').AsString := AInvoice.Lines[0].Nominal.EntCode;
                  AccsDataModule.SLPLDefaults.Post;
               except
                  AccsDataModule.SLPLDefaults.Cancel;
               end
            else
               try
                  AccsDataModule.SLPLDefaults.Append;
                  AccsDataModule.SLPLDefaults.FieldByName('SLPLCode').AsInteger := AInvoice.SupplierId;
                  AccsDataModule.SLPLDefaults.FieldByName('SLPLType').AsString := 'P';
                  AccsDataModule.SLPLDefaults.FieldByName('Comment').AsString := AInvoice.Comment;
                  AccsDataModule.SLPLDefaults.FieldByName('Nominal').AsInteger := AInvoice.Lines[0].Nominal.Id;
                  AccsDataModule.SLPLDefaults.FieldByName('Ent').AsString := AInvoice.Lines[0].Nominal.EntCode;
                  AccsDataModule.SLPLDefaults.Post;
               except
                  AccsDataModule.SLPLDefaults.Cancel;
               end;
            AccsDataModule.SLPLDefaults.Close;
         end;

      AInvoice.TransactionState := tsCreated;
   except
      on e : exception do
         // TODO:  Log Exception
   end;
end;

procedure TSimpleAccsData.CreateInvoice(AInvoiceList: TList);
var
   i : Integer;
   Invoice: TInvoice;
begin
   if (AInvoiceList = nil) or (AInvoiceList.Count = 0) then Exit;

   try
      // Initialise
      GEditing := False;

      PREVENT_TRANSACTIONGRID_LOADING_ON_TRANSACTION_WRITE := True;
      NOTIFY_TRANSACTION_WRITE_SUCCESS := False;

      for i := 0 to AInvoiceList.Count-1 do
         begin
            Invoice := TInvoice(AInvoiceList[i]);
            if (Invoice is TPurchaseInvoice ) then
               CreateInvoice(Invoice as TPurchaseInvoice)
            else if ( Invoice is TSaleInvoice ) then
               CreateInvoice(Invoice as TSaleInvoice);
         end;
   finally
      PREVENT_TRANSACTIONGRID_LOADING_ON_TRANSACTION_WRITE := False;
      NOTIFY_TRANSACTION_WRITE_SUCCESS := True;
   end;
end;

procedure TSimpleAccsData.CreateInvoice(const AInvoice: TSaleInvoice);
var
   LineIndex : Integer;
   TestStr   : ShortString;
   InvoiceLine : TInvoiceLine;

   WasAct,
   WasProg : Integer;

   i : Integer;
begin
   if (AInvoice.TransactionId>0) then
      raise Exception.Create('Cannot create invoice. Invoice update must be used where TransactionId is specified');

   ACT := 1;
   PROG := SALESTX;

   InitVals;

   try
      zCustRec[1] := AInvoice.CustomerId;
      zAccount[1] := AInvoice.CustomerId;
      TestStr := DateToStr(AInvoice.TransactionDate);
      if length(TestStr) = 10 then
      TestStr := copy(TestStr,1,6) + copy(TestStr,9,2);
      zTxDate[1] := KDateToInt ( TestStr );
      if (AInvoice.StubNo>0) then
         ZStub[1] := AInvoice.StubNo;
      zRef[1] := Copy(AInvoice.Reference,1,SizeOf(zRef[1]));

      if ( Cash11.xUseLastNomDesc ) and ( Length(Trim(AInvoice.Comment)) = 0 ) then
         begin
            if ( Length(AInvoice.Lines[AInvoice.Lines.Count-1].NominalFreeTxt) > 0 ) then
               zComm[1] := AInvoice.Lines[AInvoice.Lines.Count-1].NominalFreeTxt
            else
               zComm[1] := AInvoice.Lines[AInvoice.Lines.Count-1].Nominal.Name
         end
      else if ( Length(Trim(AInvoice.Comment)) > 0 ) then
         zComm[1] := Trim(AInvoice.Comment);
      
      LineIndex := 1;

      for i := 0 to AInvoice.Lines.Count-1 do
         begin
            InvoiceLine := AInvoice.Lines[i];
            zUse[1,LineIndex] := True;
            ZGen[1,LineIndex] := InvoiceLine.Nominal.Id;

            if ( Length(InvoiceLine.NominalFreeTxt) > 0 ) then
               ZDesc[1,LineIndex] := InvoiceLine.NominalFreeTxt
            else
               ZDesc[1,LineIndex] := Copy(InvoiceLine.Nominal.Name,1,SizeOf(zDesc[1,LineIndex]));

            if (Length(Trim(InvoiceLine.Nominal.EntCode)) > 0) then
               begin
                  zEnt[1,LineIndex] := InvoiceLine.Nominal.EntCode;
               end;

            // Quantity
            TestStr := FloatToStr(InvoiceLine.Quantity);
            SlimAll ( TestStr );
            ChangeToLong ( TestStr );
            StrLong ( TestStr, ZQty[1,LineIndex] );

            // Amount
            TestStr := FloatToStr(InvoiceLine.Amount);
            SlimAll ( TestStr );
            ChangeToLong ( TestStr );
            StrLong ( TestStr, ZAmt[1,LineIndex] );

            // VAT Code
            zTax[1,LineIndex] := InvoiceLine.VATCode;

            // VAT Amount
            TestStr := FloatToStrF(InvoiceLine.VATAmount,ffFixed,8,2);
            SlimAll(TestStr);
            ChangeToLong ( TestStr );
            StrLong(TestStr,zTaxAmt[1,LineIndex]);

            Inc ( LineIndex );
         end;
      CheckEnd;
      SetVals;
      ZStub[1] := 0;
      ZStub[2] := 0;
      WriteTransactions( 1, SlFile, Act, FALSE );

      if ( Preferences.ValueAsBoolean[cPref_EnableSLPLDefaults] ) then
         begin
            AccsDataModule.SLPLDefaults.Open;
            if ( AccsDataModule.SLPLDefaults.Locate('SLPLCode;SLPLType',VarArrayOf([AInvoice.CustomerId,'S']),[])) then
               try
                  AccsDataModule.SLPLDefaults.Edit;
                  AccsDataModule.SLPLDefaults.FieldByName('Comment').AsString := AInvoice.Comment;
                  AccsDataModule.SLPLDefaults.FieldByName('Nominal').AsInteger := AInvoice.Lines[0].Nominal.Id;
                  AccsDataModule.SLPLDefaults.FieldByName('Ent').AsString := AInvoice.Lines[0].Nominal.EntCode;
                  AccsDataModule.SLPLDefaults.Post;
               except
                  AccsDataModule.SLPLDefaults.Cancel;
               end
            else
               try
                  AccsDataModule.SLPLDefaults.Append;
                  AccsDataModule.SLPLDefaults.FieldByName('SLPLCode').AsInteger := AInvoice.CustomerId;
                  AccsDataModule.SLPLDefaults.FieldByName('SLPLType').AsString := 'S';
                  AccsDataModule.SLPLDefaults.FieldByName('Comment').AsString := AInvoice.Comment;
                  AccsDataModule.SLPLDefaults.FieldByName('Nominal').AsInteger := AInvoice.Lines[0].Nominal.Id;
                  AccsDataModule.SLPLDefaults.FieldByName('Ent').AsString := AInvoice.Lines[0].Nominal.EntCode;
                  AccsDataModule.SLPLDefaults.Post;
               except
                  AccsDataModule.SLPLDefaults.Cancel;
               end;
            AccsDataModule.SLPLDefaults.Close;
         end;

      AInvoice.TransactionState := tsCreated;
   except
   end;
end;

function TSimpleAccsData.GetInvoice(const ATransactionId: Integer): TInvoice;
var
   PurchaseInvoice: TPurchaseInvoice;
   SaleInvoice: TSaleInvoice;
   NominalAccount: TNominalAccount;
   TempStr : ShortString;
   i : Integer;

   Quantity: Double;
   Amount: Double;
   VATAmount: Double;
   VATCode: String;
   Description: String;

   function GetInvoiceDate: TDateTime;
   begin
      KDateToStr ( zTxDate[1], TempStr );
      Result := StrToDate(TempStr);
   end;

begin

   if not LoadTrans then Exit;

   if (PROG = PURCHTX) then
      begin
        PurchaseInvoice := TPurchaseInvoice.Create(ATransactionId);
        try
           PurchaseInvoice.TransactionDate := GetInvoiceDate();
        except
           PurchaseInvoice.Errors.Add(Format('Conversion error TransactionId[%d] -> TransactionDate',[ATransactionId]));
        end;

        PurchaseInvoice.SupplierId := zAccount[1];
        PurchaseInvoice.Reference := zRef[1];
        PurchaseInvoice.Comment := zComm[1];

        for i := 1 to MaxGridLines do
        begin
           if ( zGen[1,i] = 0 ) then Continue;

           Quantity := 0;
           Amount := 0;
           VATAmount := 0;
           VATCode := '';
           Description := '';

           NominalAccount := AccsDataModule.Accounts.GetNominalAccount(zGen[1,i]);
           if (NominalAccount=nil) then
              begin
                 PurchaseInvoice.Errors.Add(Format('Not Found: TransactionId[%d] -> NominalAccount[%d]',[ATransactionId,zGen[1,i]]));
                 Continue;
              end;

           try
              LongStr ( zQty[1,i], TempStr, 'L' );
              Quantity := StrToFloat(FlipNegative(TempStr));
           except
              PurchaseInvoice.Errors.Add(Format('Conversion Error: TransactionId[%d] -> Quantity',[ATransactionId]));
           end;

           Description := zDesc[1,i];

           try
              LongStr ( zAmt[1,i], TempStr, 'L' );
              Amount := StrToFloat(FlipNegative(TempStr));
           except
              PurchaseInvoice.Errors.Add(Format('Conversion Error: TransactionId[%d] -> Amount',[ATransactionId]));
           end;

           VATCode := zTax[1,i];

           try
              LongStr ( zTaxAmt[1,i], TempStr, 'L' );
              VATAmount := StrToFloat(FlipNegative(TempStr));
           except
              PurchaseInvoice.Errors.Add(Format('Conversion Error: TransactionId[%d] -> VATAmount',[ATransactionId]));
           end;

           PurchaseInvoice.AddLine(NominalAccount, Quantity, Amount, VATCode, VATAmount, Description);
        end;

        PurchaseInvoice.TransactionState := tsUnchanged;

        Result := PurchaseInvoice;
      end
   else if (PROG = SALESTX) then
      begin
         SaleInvoice := TSaleInvoice.Create(ATransactionId);
         try
            SaleInvoice.TransactionDate := GetInvoiceDate();
         except
            SaleInvoice.Errors.Add(Format('Conversion error TransactionId[%d] -> TransactionDate',[ATransactionId]));
         end;

         SaleInvoice.CustomerId := zAccount[1];
         SaleInvoice.Reference := zRef[1];
         SaleInvoice.Comment := zComm[1];

         for i := 1 to MaxGridLines do
         begin
            if ( zGen[1,i] = 0 ) then Continue;

            Quantity := 0;
            Amount := 0;
            VATAmount := 0;
            VATCode := '';
            Description := '';

            NominalAccount := AccsDataModule.Accounts.GetNominalAccount(zGen[1,i]);
            if (NominalAccount=nil) then
               begin
                  SaleInvoice.Errors.Add(Format('Not Found: TransactionId[%d] -> NominalAccount[%d]',[ATransactionId,zGen[1,i]]));
                  Continue;
               end;

            try
               LongStr ( zQty[1,i], TempStr, 'L' );
               Quantity := StrToFloat(FlipNegative(TempStr));
            except
               SaleInvoice.Errors.Add(Format('Conversion Error: TransactionId[%d] -> Quantity',[ATransactionId]));
            end;

            Description := zDesc[1,i];

            try
               LongStr ( zAmt[1,i], TempStr, 'L' );
               Amount := StrToFloat(FlipNegative(TempStr));
            except
               SaleInvoice.Errors.Add(Format('Conversion Error: TransactionId[%d] -> Amount',[ATransactionId]));
            end;

            VATCode := zTax[1,i];

            try
               LongStr ( zTaxAmt[1,i], TempStr, 'L' );
               VATAmount := StrToFloat(TempStr);
            except
               SaleInvoice.Errors.Add(Format('Conversion Error: TransactionId[%d] -> VATAmount',[ATransactionId]));
            end;

            SaleInvoice.AddLine(NominalAccount, Quantity, Amount, VATCode, VATAmount, Description);
         end;

         SaleInvoice.TransactionState := tsUnchanged;

         Result := SaleInvoice;
      end
   else
      raise Exception.Create('Transaction Type not supported.');
end;

procedure TSimpleAccsData.SetVals;
begin						     { begin SETVALS }
    If ( ACT=62 ) THEN
       ZTOTAMT[2]:=ZTOTAMT[1]
    Else
       ZTOTAMT[2]:=0-ZTOTAMT[1];
    If ( ACT=62 ) Then
       ZAMT[2][1]:=ZAMT[1][1]
    Else
        ZAMT[2][1]:=0-ZAMT[1][1];
    ZBANK  [2]:=ZBANK  [1];
    ZTXDATE[2]:=ZTXDATE[1];
    ZDUESTR[2]:=ZDUESTR[1];
    ZDUEINT[2]:=ZDUEINT[1];
    ZREF   [2]:=ZREF   [1];
    ZCOMM  [2]:=ZCOMM  [1];
    ZUSE[2][1]:=ZUSE[1][1];
end;						     { end SETVALS }

procedure TSimpleAccsData.UpdateInvoice(const AInvoice: TInvoice);
begin
   if (AInvoice is TPurchaseInvoice) then
      UpdateInvoice(AInvoice as TPurchaseInvoice)
   else if (AInvoice is TSaleInvoice) then
      UpdateInvoice(AInvoice as TSaleInvoice)
   else
      raise Exception.Create('Unsupported invoice type.');
end;

procedure TSimpleAccsData.UpdateInvoice(const AInvoice: TPurchaseInvoice);
var
   TestStr : ShortString;
   i: Integer;
   LineIndex : Integer;
   InvoiceLine : TInvoiceLine;
begin
   ACT := 1;
   PROG := PURCHTX;

   if not GEditing then
      raise Exception.Create('Invoice update failed. Not in Edit Mode');
   if (AInvoice.TransactionId<=0) then
      raise Exception.Create('Cannot update invoice. Invoice create must be used where TransactionId is not specified');

   try
      zCustRec[1] := AInvoice.SupplierId;
      zAccount[1] := AInvoice.SupplierId;
      TestStr := DateToStr(AInvoice.TransactionDate);
      if length(TestStr) = 10 then
      TestStr := copy(TestStr,1,6) + copy(TestStr,9,2); // TGM AB Fix 4 digit year problem
      zTxDate[1] := KDateToInt ( TestStr );
      if (Length(Trim(AInvoice.Comment)) > 0) then
         zComm[1] := Trim(AInvoice.Comment);
      if (AInvoice.StubNo>0) then
         ZStub[1] := AInvoice.StubNo;
      zRef[1] := Copy(AInvoice.Reference,1,SizeOf(zRef[1]));

      LineIndex := 1;

      for i := 0 to AInvoice.Lines.Count-1 do
         begin
            InvoiceLine := AInvoice.Lines[i];
            zUse[1,LineIndex] := True;
            ZGen[1,LineIndex] := InvoiceLine.Nominal.Id;
            ZDesc[1,LineIndex] := Copy(InvoiceLine.Nominal.Name,1,SizeOf(zDesc[1,LineIndex]));
            if (Length(Trim(InvoiceLine.Nominal.EntCode)) > 0) then
               zEnt[1,LineIndex] := InvoiceLine.Nominal.EntCode
            else
               zEnt[1,LineIndex] := '';

            // Quantity
            TestStr := FloatToStr(InvoiceLine.Quantity);
            SlimAll ( TestStr );
            ChangeToLong ( TestStr );
            StrLong ( TestStr, ZQty[1,LineIndex] );

            // Amount
            TestStr := FloatToStr(InvoiceLine.Amount);
            SlimAll ( TestStr );
            ChangeToLong ( TestStr );
            StrLong ( TestStr, ZAmt[1,LineIndex] );

            // VAT Code
            zTax[1,LineIndex] := InvoiceLine.VATCode;

            // VAT Amount
            TestStr := FloatToStrF(InvoiceLine.VATAmount,ffFixed,8,2);
            SlimAll(TestStr);
            ChangeToLong ( TestStr );
            StrLong(TestStr,zTaxAmt[1,LineIndex]);

            Inc ( LineIndex );
         end;
      CheckEnd;
      SetVals;

      WriteTransactions ( 2, PLFile, 0, FALSE );
      WriteTransactions ( 1, PLFile, 0, FALSE );
      ResetPointers ( nil );

      AInvoice.TransactionState := tsUpdated;
   except
      on e : exception do
         // TODO:  Log Exception
   end;
end;

procedure TSimpleAccsData.UpdateInvoice(const AInvoice: TSaleInvoice);
var
   TestStr : ShortString;
   i: Integer;
   LineIndex : Integer;
   InvoiceLine : TInvoiceLine;
begin
   ACT := 1;
   PROG := SALESTX;

   if not GEditing then
      raise Exception.Create('Invoice update failed. Not in Edit Mode');
   if (AInvoice.TransactionId<=0) then
      raise Exception.Create('Cannot update invoice. Invoice create must be used where TransactionId is not specified');

   try
      zCustRec[1] := AInvoice.CustomerId;
      zAccount[1] := AInvoice.CustomerId;
      TestStr := DateToStr(AInvoice.TransactionDate);
      if length(TestStr) = 10 then
      TestStr := copy(TestStr,1,6) + copy(TestStr,9,2); // TGM AB Fix 4 digit year problem
      zTxDate[1] := KDateToInt ( TestStr );
      if (Length(Trim(AInvoice.Comment)) > 0) then
         zComm[1] := Trim(AInvoice.Comment);
      if (AInvoice.StubNo>0) then
         ZStub[1] := AInvoice.StubNo;
      zRef[1] := Copy(AInvoice.Reference,1,SizeOf(zRef[1]));

      LineIndex := 1;

      for i := 0 to AInvoice.Lines.Count-1 do
         begin
            InvoiceLine := AInvoice.Lines[i];
            zUse[1,LineIndex] := True;
            ZGen[1,LineIndex] := InvoiceLine.Nominal.Id;
            ZDesc[1,LineIndex] := Copy(InvoiceLine.Nominal.Name,1,SizeOf(zDesc[1,LineIndex]));
            if (Length(Trim(InvoiceLine.Nominal.EntCode)) > 0) then
               zEnt[1,LineIndex] := InvoiceLine.Nominal.EntCode
            else
               zEnt[1,LineIndex] := '';

            // Quantity
            TestStr := FloatToStr(InvoiceLine.Quantity);
            SlimAll ( TestStr );
            ChangeToLong ( TestStr );
            StrLong ( TestStr, ZQty[1,LineIndex] );

            // Amount
            TestStr := FloatToStr(InvoiceLine.Amount);
            SlimAll ( TestStr );
            ChangeToLong ( TestStr );
            StrLong ( TestStr, ZAmt[1,LineIndex] );

            // VAT Code
            zTax[1,LineIndex] := InvoiceLine.VATCode;

            // VAT Amount
            TestStr := FloatToStrF(InvoiceLine.VATAmount,ffFixed,8,2);
            SlimAll(TestStr);
            ChangeToLong ( TestStr );
            StrLong(TestStr,zTaxAmt[1,LineIndex]);

            Inc ( LineIndex );
         end;
      CheckEnd;
      SetVals;

      WriteTransactions ( 2, SLFile, 0, FALSE );
      WriteTransactions ( 1, SLFile, 0, FALSE );
      ResetPointers ( nil );

      AInvoice.TransactionState := tsUpdated;
   except
      on e : exception do
         // TODO:  Log Exception
   end;
end;

end.
