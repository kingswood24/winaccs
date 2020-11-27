unit uOverpayment;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ComCtrls, StdCtrls, Buttons, ExtCtrls, RXCtrls, RXDBCtrl,
  calcs, TJpgImg, Mask;

type
  TOverpaymentForm = class(TForm)
    Panel1: TPanel;
    ExitButton: TBitBtn;
    Save: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ListAccounts: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    CustSuppCode: TEdit;
    ContinueBtn1: TButton;
    GroupBox1: TGroupBox;
    DBGrid1: TDBGrid;
    TabSheet3: TTabSheet;
    Label7: TLabel;
    OverpaymentAmtLbl: TLabel;
    AllocationGrid: TDBGrid;
    Label9: TLabel;
    RemainingAmtlbl: TLabel;
    Label10: TLabel;
    DateLabel: TLabel;
    TxDate: TMaskEdit;
    DateSearch: TDateTimePicker;
    Label18: TLabel;
    IncludeLastYearCB: TCheckBox;
    procedure ExitButtonClick(Sender: TObject);
    procedure ContinueBtn1Click(Sender: TObject);
    procedure ListAccountsClick(Sender: TObject);
    procedure GetCustSupp(Account : integer);
    procedure GatherOverpayments(Account : integer);
    procedure CustSuppCodeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CustSuppCodeChange(Sender: TObject);
    procedure AllocationGridColExit(Sender: TObject);
    procedure TotalAllocatedOverpayments;
    procedure AllocationGridExit(Sender: TObject);
    procedure AllocationGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SaveClick(Sender: TObject);
    procedure MarkInvoiceComplete(TxID : integer; LastYear : Boolean);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DateSearchCloseUp(Sender: TObject);
    procedure TxDateExit(Sender: TObject);
    procedure GatherCreditNotes(Account : integer);
    procedure IncludeLastYearCBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LoadForm(CustSupp : String; Account : Integer);
  end;

var
  OverpaymentForm: TOverpaymentForm;
  TransType : integer;
  OverpaymentToBeAllocated, CreditNoteToBeAllocated : real;
  Rownumber : integer;
  ActiveTXID : integer;
  CreditNoteTx : Boolean;

implementation

uses NewListing, types, DBCore, vars, AccsData, Cashbook;

{$R *.DFM}

procedure TOverpaymentForm.ExitButtonClick(Sender: TObject);
begin
        self.close;
        accsdatamodule.OverpaymentQuery.close;
end;

procedure TOverpaymentForm.LoadForm(CustSupp : String; Account : Integer); // s - supplier, c - customer & account number
begin

        TxDate.Text := Cash11.Default_Date;
        DateSearch.Date := KStrToDate ( Cash11.Default_Date );
        Rownumber := 0;

        accsdatamodule.OverpaymentTempDB.close;
        accsdatamodule.OverpaymentTempDB.active := false;
        accsdatamodule.OverpaymentTempDB.EmptyTable;

        label1.caption := '';
        label2.caption := '';
        label3.caption := '';
        label4.caption := '';
        label5.caption := '';
   //     OverpaymentAmount.text := '0.00';
   //     OverpaymentToBeAllocated := 0.00;

        OverpaymentAmtLbl.caption := '0.00';

        pagecontrol1.ActivePageIndex := 0;
        If custsupp = 's' then Transtype := PurchTX
                else Transtype := SalesTX;

        if Account <> 0 then begin
                CustSuppCode.text := vartostr(Account);
                GetCustSupp(Account);

                if Length ( CustSuppCode.text ) > 0 then begin
                        try GatherOverpayments(strtoint(CustSuppCode.text));
                            GatherCreditNotes(strtoint(CustSuppCode.text));
                        except
                        end;
                end;
        end;

        pagecontrol1.Pages[1].TabVisible := false;
  //      pagecontrol1.Pages[2].TabVisible := false;
        save.Enabled := false;
        self.showmodal;
end;

procedure TOverpaymentForm.ContinueBtn1Click(Sender: TObject);
begin
          if AccsDataModule.OverpaymentTempDB.locate('Tick','ü',[]) then begin
                OverpaymentAmtlbl.Caption := FormatFloat('#######0.00', (OverpaymentToBeAllocated+CreditNoteToBeAllocated));
                RemainingAmtlbl.Caption := OverpaymentAmtlbl.Caption;

                AccsDataModule.AllocationTempDB.Close;
                AccsDataModule.AllocationTempDB.emptytable;
                AccsDataModule.AllocationTempDB.open;

                if IncludeLastYearCB.checked then Cashbookform.GetUnAllocatedInvoicesPreviousYear(strtoint(custsuppcode.text));         // TGM AB 28/07/17
                Cashbookform.GetUnAllocatedInvoices(strtoint(custsuppcode.text), false);
                pagecontrol1.Pages[1].TabVisible := true;
                pagecontrol1.ActivePageIndex := 1;
                pagecontrol1.Pages[0].TabVisible := false;
         end
            else showmessage('No Overpayment Amount Selected');
end;



procedure TOverpaymentForm.ListAccountsClick(Sender: TObject);
begin
             if Transtype = SalesTX then
                NewListBox.ListIt ( Sender, Customers, 'C' )
             else
                NewListBox.ListIt ( Sender, Suppliers, 'S' );
             if Length ( NewListBox.ListInfo.ReturnValue ) > 0 then begin
                        CustSuppCode.Text := NewListBox.ListInfo.ReturnValue;
                        try GetCustSupp(strtoint(NewListBox.ListInfo.ReturnValue));
                        except
                        end;
                        try GatherOverpayments(strtoint(NewListBox.ListInfo.ReturnValue));
                            GatherCreditNotes(strtoint(NewListBox.ListInfo.ReturnValue));
                        except
                        end;
                end;

end;

procedure TOverpaymentForm.GetCustSupp(Account : integer);
var
        SalesPurchDB : integer;
begin
    if Transtype = SalesTX then SalesPurchDB := SLFile
        else SalesPurchDB := PLFile;
    SetDb ( SalesPurchDB );
    ReadRec ( SalesPurchDB, Account);
    GetItem ( SalesPurchDB, 1 );
    label1.caption := currstr;
    GetItem ( SalesPurchDB, 2 );
    label2.caption := currstr;
    GetItem ( SalesPurchDB, 3 );
    label3.caption := currstr;
    GetItem ( SalesPurchDB, 4 );
    label4.caption := currstr;
    GetItem ( SalesPurchDB, 5 );
    label5.caption := currstr;
end;

procedure TOverpaymentForm.GatherCreditNotes(Account : integer);
var
 i : integer;
begin
    (* code to pick up credit notes  *)

    accsdatamodule.OverpaymentQuery.close;
    accsdatamodule.OverpaymentQuery.SQL.clear;

    if Transtype = SalesTX then accsdatamodule.OverpaymentQuery.sql.add('Select * from Transactions.db where txtype = 3 and account =' +vartostr(Account) + ' and Allocated is null')
        else accsdatamodule.OverpaymentQuery.sql.add('Select * from Transactions.db where txtype = 7 and account =' +vartostr(Account) + ' and Allocated is null');
    accsdatamodule.OverpaymentQuery.open;
    accsdatamodule.OverpaymentQuery.last;    // TGM AB 19/08/16

    for i:=1 to accsdatamodule.OverpaymentQuery.RecordCount do begin
        accsdatamodule.OverpaymentTempDB.append;
        accsdatamodule.OverpaymentTempDB['TxNo'] := accsdatamodule.OverpaymentQuery['TxNo'];
        accsdatamodule.OverpaymentTempDB['TxDate'] := accsdatamodule.OverpaymentQuery['TxDate'];
        accsdatamodule.OverpaymentTempDB['Reference'] := accsdatamodule.OverpaymentQuery['Reference'];
        accsdatamodule.OverpaymentTempDB['TotalAmount'] := ((accsdatamodule.OverpaymentQuery['Amount']+accsdatamodule.OverpaymentQuery['TaxDisc']) * -1);
        accsdatamodule.OverpaymentTempDB['CreditNoteAmount'] := (((accsdatamodule.OverpaymentQuery['Amount']+accsdatamodule.OverpaymentQuery['TaxDisc']) * -1) - accsdatamodule.OverpaymentQuery['AmtPaid']);
        accsdatamodule.OverpaymentTempDB.post;
        accsdatamodule.OverpaymentQuery.prior;
    end;

end;

procedure TOverpaymentForm.GatherOverpayments(Account : integer);
var
 i : integer;
begin
    accsdatamodule.OverpaymentQuery.close;
    accsdatamodule.OverpaymentQuery.SQL.clear;
     if Transtype = SalesTX then accsdatamodule.OverpaymentQuery.sql.add('Select * from Transactions.db where Overpayment > 0.00 and txtype = 2 and account =' +vartostr(Account))
        else accsdatamodule.OverpaymentQuery.sql.add('Select * from Transactions.db where Overpayment > 0.00 and txtype = 6 and account =' +vartostr(Account));
    accsdatamodule.OverpaymentQuery.open;

    accsdatamodule.OverpaymentQuery.Last;

    accsdatamodule.OverpaymentTempDB.close;
    accsdatamodule.OverpaymentTempDB.active := false;
    accsdatamodule.OverpaymentTempDB.EmptyTable;
    accsdatamodule.OverpaymentTempDB.open;

    for i:=1 to accsdatamodule.OverpaymentQuery.RecordCount do begin
        accsdatamodule.OverpaymentTempDB.append;
        accsdatamodule.OverpaymentTempDB['TxNo'] := accsdatamodule.OverpaymentQuery['TxNo'];
        accsdatamodule.OverpaymentTempDB['TxDate'] := accsdatamodule.OverpaymentQuery['TxDate'];
        accsdatamodule.OverpaymentTempDB['Reference'] := accsdatamodule.OverpaymentQuery['Reference'];
        accsdatamodule.OverpaymentTempDB['TotalAmount'] := accsdatamodule.OverpaymentQuery['Amount'];
        accsdatamodule.OverpaymentTempDB['OverpaymentRemaining'] := accsdatamodule.OverpaymentQuery['Overpayment'];
        accsdatamodule.OverpaymentTempDB['OverpaymentAmount'] := 0;
        accsdatamodule.OverpaymentTempDB.post;
        accsdatamodule.OverpaymentQuery.prior;
    end;

    accsdatamodule.OverpaymentQuery.close;
    accsdatamodule.OverpaymentQuery.SQL.clear;                                                                // Overpayment > 0.00 and




end;

procedure TOverpaymentForm.CustSuppCodeKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
        If Key = VK_F2 Then    { F2 Pressed }
       Begin
          If PROG = SALESTX Then
             NewListBox.ListIt ( Sender, Customers, 'C' )
          Else
             NewListBox.ListIt ( Sender, Suppliers, 'S' );
          If Length ( NewListBox.ListInfo.ReturnValue ) > 0 Then
             CustSuppCode.Text := NewListBox.ListInfo.ReturnValue;
             GetCustSupp(strtoint(NewListBox.ListInfo.ReturnValue));
             GatherOverpayments(strtoint(NewListBox.ListInfo.ReturnValue));
          Key := 0;
       End;
end;

procedure TOverpaymentForm.CustSuppCodeChange(Sender: TObject);
var
        teststr : string;
begin
        teststr := CustSuppCode.text;
     If ((not numeric(CustSuppCode.text)) and (CustSuppCode.text <> '')) then begin
          newlistbox.InitialSearchFieldText:=teststr;
          If PROG = SALESTX Then begin
             newListBox.ListIt ( Sender, Customers, 'C' );
          end Else begin
             newListBox.ListIt ( Sender, Suppliers, 'S' );
          end;

          If Length ( newListBox.ListInfo.ReturnValue ) > 0 Then
             CustSuppCode.Text := newListBox.ListInfo.ReturnValue;
             GetCustSupp(strtoint(NewListBox.ListInfo.ReturnValue));
             GatherOverpayments(strtoint(NewListBox.ListInfo.ReturnValue));
             GatherCreditNotes(strtoint(NewListBox.ListInfo.ReturnValue));
    end;
end;

procedure TOverpaymentForm.AllocationGridColExit(Sender: TObject);
begin
        TotalAllocatedOverpayments;
end;

procedure TOverpaymentForm.TotalAllocatedOverpayments;
var
      i, currenttx : integer;
      Amt, Dis, RowAmt, RowDis, RowOut, TempReal : real;
      AmtStr{, DisStr} : shortstring;

begin
 //    save.enabled := false;
     
     try currenttx := AccsDataModule.AllocationTempDB['TxID'];
     except begin
            AccsDataModule.AllocationTempDB.cancel;
            exit;
            end;
     end;
     Amt := 0;
     Dis := 0;


     AccsDataModule.AllocationTempDB.first;
     for i:= 1 to AccsDataModule.AllocationTempDB.RecordCount do begin


         RowAmt := 0;
         RowDis := 0;
         RowOut := 0;
         TempReal := 0;
         Amt := Amt +  AccsDataModule.AllocationTempDB.FieldByName('AmountPaid').asfloat;
         Dis := Dis +  AccsDataModule.AllocationTempDB.FieldByName('Discount').asfloat;
         RowAmt := AccsDataModule.AllocationTempDB.FieldByName('AmountPaid').asfloat;
         RowDis := AccsDataModule.AllocationTempDB.FieldByName('Discount').asfloat;
         RowOut := AccsDataModule.AllocationTempDB.FieldByName('Outstanding').asfloat;
         if RowOut < -10000000 then RowOut := 0; // fixes bug where outstanding is sometimes read as a huge negative number
         TempReal := RowAmt + RowDis;
         if ( ( round(Rowout*100) = round(TempReal*100) ) and (RowOut <> 0) ) then begin
                AccsDataModule.AllocationTempDB.edit;
                AccsDataModule.AllocationTempDB['CompleteAllocation'] := 'Y';
                end else begin
                   if ((AccsDataModule.AllocationTempDB.FieldByName('AmountPaid').asfloat <> 0) or (AccsDataModule.AllocationTempDB.FieldByName('Discount').asfloat <> 0)) then begin
                        AccsDataModule.AllocationTempDB.edit;
                        AccsDataModule.AllocationTempDB['CompleteAllocation'] := '';
                        end;
                   if ( (round(TempReal*100) > round(Rowout*100)) and (Rowout > 0)) then begin
                       showmessage('Error - Cannot allocate more than the outstanding amount selected');
                       AccsDataModule.AllocationTempDB.edit;
                       Amt := Amt - RowAmt;
                       Dis := Dis - RowDis;
                       AccsDataModule.AllocationTempDB['AmountPaid'] := 0;
                       AccsDataModule.AllocationTempDB['Discount'] := 0;
                       AccsDataModule.AllocationTempDB.post;
                   end;
                   end;
         AccsDataModule.AllocationTempDB.next;
     end;

     if round(Amt*100) > round((OverpaymentToBeAllocated+CreditNoteToBeAllocated)*100) then begin
         showmessage('Error - Cannot allocate more than the outstanding amount selected');
         RemainingAmtlbl.Caption := 'Error';
     end else
              begin
                    if round(Amt*100) <= round((OverpaymentToBeAllocated+CreditNoteToBeAllocated)*100) then  RemainingAmtlbl.Caption := FormatFloat('#######0.00', OverpaymentToBeAllocated + CreditNoteToBeAllocated - Amt);
                  //   else RemainingAmtlbl.Caption := FormatFloat('#######0.00', OverpaymentToBeAllocated - Amt) + ('  - Must be allocated to continue');
                    save.enabled := true;
              end;

 //    if round(Amt*100) = round(OverpaymentToBeAllocated*100) then save.enabled := true;
     if Amt = 0 then save.enabled := false;
     AccsDataModule.AllocationTempDB.locate('TxID',currenttx,[]);


end;





procedure TOverpaymentForm.AllocationGridExit(Sender: TObject);
begin
        TotalAllocatedOverpayments;
end;

procedure TOverpaymentForm.AllocationGridKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
        if key in [VK_RETURN,VK_LEFT,VK_RIGHT,VK_DOWN,VK_UP] then TotalAllocatedOverpayments;
end;

procedure TOverpaymentForm.SaveClick(Sender: TObject);
var
      i, txid : integer;
      AmtPaid, Discount, outstanding, temptotal : real;
      complete, tempstr : string;
      RunningVAT, InvoiceTOTAL, InvoiceVAT, VATClaimed : real;
      VATPercentage, AllocatedVAT : real;
      OutstandingVAT, TotalPaymentVAT : real;
      TotalInvoiceTOTAL : real;
      EnteredTotals, CalcTotals : real;      // TGM AB 19/08/16
begin

      AmtPaid := 0;
      Discount := 0;
      EnteredTotals := 0;

      AccsDataModule.AllocationTempDB.first;
      for i:= 1 to AccsDataModule.AllocationTempDB.RecordCount do begin
         TxID := AccsDataModule.AllocationTempDB['TxID'];
         if TxID <> 0 then begin
   //          showmessage(vartostr(TXID));
             complete := 'N';
             AmtPaid := AccsDataModule.AllocationTempDB.FieldByName('AmountPaid').asfloat;
             Discount := AccsDataModule.AllocationTempDB.FieldByName('Discount').asfloat;
             Outstanding := AccsDataModule.AllocationTempDB.FieldByName('Outstanding').asfloat;
             try complete := AccsDataModule.AllocationTempDB['CompleteAllocation'];
                except
                end;
             temptotal := (AmtPaid + Discount);
             if (Outstanding = temptotal) then complete := 'Y';
             EnteredTotals := EnteredTotals + temptotal;

             // now locate the invoice in the transactions file and update details

             if AccsDataModule.AllocationTempDB['PreviousYear'] = '*' then begin                                                              // TGM AB 28/07/17
                                                                                                                                              // TGM AB 28/07/17
                        accsdatamodule.TransactionsYr1DB.open;
                        accsdatamodule.TransactionsYr1DB.Locate('TxNo',TxID,[]);                                                              // TGM AB 28/07/17
                        accsdatamodule.TransactionsYr1DB.Edit;                                                                                // TGM AB 28/07/17
                        accsdatamodule.TransactionsYr1DB['AmtPaid'] := accsdatamodule.TransactionsYr1DB['AmtPaid'] + AmtPaid + Discount;      // TGM AB 28/07/17
                        accsdatamodule.TransactionsYr1DB.Post;                                                                                // TGM AB 28/07/17
                                                                                                                                              // TGM AB 28/07/17
             end else begin                                                                                                                   // TGM AB 28/07/17

                        accsdatamodule.TransactionsDB.Locate('TxNo',TxID,[]);
                        accsdatamodule.TransactionsDB.Edit;
                        accsdatamodule.TransactionsDB['AmtPaid'] := accsdatamodule.TransactionsDB['AmtPaid'] + AmtPaid + Discount;
                        accsdatamodule.TransactionsDB.Post;

                end;                                                                                                                          // TGM AB 28/07/17

             if ansiuppercase(complete) = 'Y' then begin
  //              MarkInvoiceComplete(TxID,False);
             end;

         end;

         AccsDataModule.AllocationTempDB.Next;
      end;

      // This section allocates the VAT percentages of each invoice.

      AmtPaid := 0;
      Discount := 0;
      InvoiceTOTAL := 0;
      InvoiceVAT := 0;
      RunningVAT := 0;
      VATPercentage := 0;
      OutstandingVAT := 0;
      TotalPaymentVAT := 0;

      AccsDataModule.AllocationTempDB.first;
      for i:= 1 to AccsDataModule.AllocationTempDB.RecordCount do begin

         TxID := AccsDataModule.AllocationTempDB['TxID'];
         AmtPaid := AccsDataModule.AllocationTempDB.FieldByName('AmountPaid').asfloat;
         Discount := AccsDataModule.AllocationTempDB.FieldByName('Discount').asfloat;

         temptotal := (AmtPaid + Discount);

         allocatedVAT := 0;

         If TxID <> 0 then begin

            if AccsDataModule.AllocationTempDB['PreviousYear'] = '*' then begin       // TGM AB 28/07/17 start

                accsdatamodule.TransactionsYr1DB.Locate('TxNo',TxID,[]);
                InvoiceTOTAL := accsdatamodule.TransactionsYr1DB['Amount'];
                InvoiceVAT := accsdatamodule.TransactionsYr1DB['TaxDisc'];
                InvoiceTOTAL := InvoiceTOTAL + InvoiceVAT;
                VATClaimed := 0;

                try VATClaimed := accsdatamodule.TransactionsYr1DB['VATClaimed'];
                except
                end;
                OutstandingVAT := InvoiceVAT - VATClaimed;

                // Work out percentage of invoice paid

                VATPercentage := temptotal / InvoiceTOTAL;
                AllocatedVAT := VATPercentage *  InvoiceVAT;
                TempStr := FloatToStrF(AllocatedVAT, ffFixed, 9,2);
                AllocatedVAT := StrToFloat(Tempstr);

                if (outstandingVAT - allocatedVAT) < 0.05 then allocatedVAT := outstandingVAT;

                accsdatamodule.TransactionsYr1DB.edit;
                accsdatamodule.TransactionsYr1DB['VATClaimed'] := VATClaimed + allocatedVAT;
                accsdatamodule.TransactionsYr1DB.post;
                RunningVAT := RunningVAT + allocatedVAT;  // Total VAT element of payment

                // check if invoice fully allocated

                if accsdatamodule.TransactionsYr1DB['AmtPaid'] >= accsdatamodule.TransactionsYr1DB['Amount'] + accsdatamodule.TransactionsYr1DB['TaxDisc']
                 then MarkInvoiceComplete(TxID,true);


            end else begin                                                            // TGM AB 28/07/17 end

                accsdatamodule.TransactionsDB.Locate('TxNo',TxID,[]);
                InvoiceTOTAL := accsdatamodule.TransactionsDB['Amount'];
                InvoiceVAT := accsdatamodule.TransactionsDB['TaxDisc'];
                InvoiceTOTAL := InvoiceTOTAL + InvoiceVAT;
                VATClaimed := 0;

                try VATClaimed := accsdatamodule.TransactionsDB['VATClaimed'];
                except
                end;
                OutstandingVAT := InvoiceVAT - VATClaimed;

                // Work out percentage of invoice paid

                VATPercentage := temptotal / InvoiceTOTAL;
                AllocatedVAT := VATPercentage *  InvoiceVAT;
                TempStr := FloatToStrF(AllocatedVAT, ffFixed, 9,2);
                AllocatedVAT := StrToFloat(Tempstr);

                if (outstandingVAT - allocatedVAT) < 0.05 then allocatedVAT := outstandingVAT;

                accsdatamodule.TransactionsDB.edit;
                accsdatamodule.TransactionsDB['VATClaimed'] := VATClaimed + allocatedVAT;
                accsdatamodule.TransactionsDB.post;
                RunningVAT := RunningVAT + allocatedVAT;  // Total VAT element of payment

                // check if invoice fully allocated

                if accsdatamodule.TransactionsDB['AmtPaid'] >= accsdatamodule.TransactionsDB['Amount'] + accsdatamodule.TransactionsDB['TaxDisc']
                 then MarkInvoiceComplete(TxID,false);          // TGM AB 28/07/17

            end;   // TGM AB 28/07/17
         end;

         // Enter Invoice Breakdown Details into AllocatedVAT database table for report purposes

         if temptotal <> 0 then begin
                accsdatamodule.AllocatedVATDB.open;
                accsdatamodule.AllocatedVATDB.append;
                accsdatamodule.AllocatedVATDB['PaymentID'] := ActiveTxID;
                accsdatamodule.AllocatedVATDB['InvoiceID'] := TxID;
                accsdatamodule.AllocatedVATDB['Amount'] := temptotal - allocatedVAT;
                accsdatamodule.AllocatedVATDB['VAT'] := allocatedVAT;
                accsdatamodule.AllocatedVATDB['TotalAmount'] := temptotal;
                accsdatamodule.AllocatedVATDB['AllocatedDate'] := StrToDate(TxDate.text);
                if CreditNoteTx then accsdatamodule.AllocatedVATDB['CreditNote'] := True;
                if AccsDataModule.AllocationTempDB['PreviousYear'] = '*' then accsdatamodule.AllocatedVATDB['PreviousYear'] := True;                // TGM AB 28/07/17
                accsdatamodule.AllocatedVATDB.post;
         end;

         TotalPaymentVAT := TotalPaymentVAT + allocatedVAT;  // total of each line to be added together on the payment line
         TotalInvoiceTOTAL := TotalInvoiceTOTAL + temptotal;

         AccsDataModule.AllocationTempDB.Next;
      end;

         // Update overpayment record with VAT proportions of each line & reduce the overall
         // overpayment amount


         accsdatamodule.TransactionsDB.Locate('TxNo',ActiveTxID,[]);
         accsdatamodule.TransactionsDB.edit;
         accsdatamodule.TransactionsDB['AllocatedVATAmount'] := accsdatamodule.TransactionsDB['AllocatedVATAmount'] + TotalPaymentVAT;

         accsdatamodule.TransactionsDB['Overpayment'] := accsdatamodule.TransactionsDB['Overpayment'] - TotalInvoiceTOTAL;



         // Code to update Credit Note to ensure it doesn't re appear

         if CreditNoteTx then begin

             // TGM AB 19/08/16 start

             CalcTotals := 0;
             Try  CalcTotals := (((accsdatamodule.TransactionsDB.fieldbyname('Amount').asfloat + accsdatamodule.TransactionsDB.fieldbyname('TaxDisc').asfloat) * -1) - accsdatamodule.TransactionsDB.fieldbyname('AmtPaid').asfloat);
             except
             end;

             CalcTotals := Round(CalcTotals*100)/100;                 
             EnteredTotals := Round(EnteredTotals*100)/100;

             // TGM AB 19/08/16 end

             if (EnteredTotals = CalcTotals) then begin //(((accsdatamodule.TransactionsDB.fieldbyname('Amount').asfloat + accsdatamodule.TransactionsDB.fieldbyname('TaxDisc').asfloat) * -1) - accsdatamodule.TransactionsDB.fieldbyname('AmtPaid').asfloat) then begin         // TGM AB 19/08/16
                accsdatamodule.TransactionsDB['AmtPaid'] := ((accsdatamodule.TransactionsDB['Amount']+accsdatamodule.TransactionsDB['TaxDisc']) * -1);
                accsdatamodule.TransactionsDB['Allocated'] := 'Y';
             end
                else accsdatamodule.TransactionsDB['AmtPaid'] := accsdatamodule.TransactionsDB['AmtPaid'] + EnteredTotals;

         // (((accsdatamodule.OverpaymentQuery['Amount']+accsdatamodule.OverpaymentQuery['TaxDisc']) * -1) - accsdatamodule.OverpaymentQuery['AmtPaid']);

         end;

         accsdatamodule.TransactionsDB.post;


         // Change Overpayment Details in AllocatedVAT database

         accsdatamodule.AllocatedVATDB.Filter := 'PaymentID = ''' + vartostr(ActiveTXID) + ''' and InvoiceID = ''0''';
         accsdatamodule.AllocatedVATDB.Filtered := true;
         if accsdatamodule.AllocatedVATDB['TotalAmount'] = TotalInvoiceTOTAL then begin
            accsdatamodule.AllocatedVATDB.edit;
            accsdatamodule.AllocatedVATDB.Delete;
         end
                else begin
                    accsdatamodule.AllocatedVATDB.Edit;
                    accsdatamodule.AllocatedVATDB['TotalAmount'] := accsdatamodule.AllocatedVATDB['TotalAmount'] - TotalInvoiceTOTAL;
                    accsdatamodule.AllocatedVATDB['Amount'] := accsdatamodule.AllocatedVATDB['Amount'] - TotalInvoiceTOTAL;
                    accsdatamodule.AllocatedVATDB.post;
                end;
                
      Cashbookform.GetUnAllocatedInvoices(strtoint(custsuppcode.text), false);    // TGM AB 28/07/17      
      self.close;  // Close the form

end;


procedure TOverpaymentForm.MarkInvoiceComplete(TxID : integer; LastYear : Boolean);
var
        TxType : integer; // holds txtype for invoice 1 for sales 5 for Purchase
        complete : boolean;

begin

    // mark invoice & type 9 & 0 as allocated

    if Prog = SalesTX then TxType := 1
        else TxType := 5;

    if LastYear then begin                           // TGM AB 28/07/17 start

        accsdatamodule.TransactionsYr1DB.Locate('TxNo',TxID,[]);
        accsdatamodule.TransactionsYr1DB.edit;
        accsdatamodule.TransactionsYr1DB['Allocated'] := 'Y';
        accsdatamodule.TransactionsYr1DB.post;

        Complete := false;

        while not complete do begin
        accsdatamodule.TransactionsYr1DB.next;
                if accsdatamodule.TransactionsYr1DB['OrigType'] = TxType then begin
                        if not ((accsdatamodule.TransactionsYr1DB['TxType'] = 0) or (accsdatamodule.TransactionsYr1DB['TxType'] = 9)) then complete := true;
                        if not complete then begin
                                accsdatamodule.TransactionsYr1DB.edit;
                                accsdatamodule.TransactionsYr1DB['Allocated'] := 'Y';
                                accsdatamodule.TransactionsYr1DB.post;
                                if accsdatamodule.TransactionsYr1DB['TxNo'] = accsdatamodule.TransactionsYr1DB.recordcount then complete := true; // TGM AB 30/09/16
                        end;
                end else
                        complete := True;
        end;


    end else begin                                   // TGM AB 28/07/17 end

        accsdatamodule.TransactionsDB.Locate('TxNo',TxID,[]);
        accsdatamodule.TransactionsDB.edit;
        accsdatamodule.TransactionsDB['Allocated'] := 'Y';
        accsdatamodule.TransactionsDB.post;

        Complete := false;

        while not complete do begin
        accsdatamodule.TransactionsDB.next;
                if accsdatamodule.TransactionsDB['OrigType'] = TxType then begin
                        if not ((accsdatamodule.TransactionsDB['TxType'] = 0) or (accsdatamodule.TransactionsDB['TxType'] = 9)) then complete := true;
                        if not complete then begin
                                accsdatamodule.TransactionsDB.edit;
                                accsdatamodule.TransactionsDB['Allocated'] := 'Y';
                                accsdatamodule.TransactionsDB.post;
                                if accsdatamodule.TransactionsDB['TxNo'] = accsdatamodule.TransactionsDB.recordcount then complete := true; // TGM AB 30/09/16
                        end;
                end else
                        complete := True;
        end;

    end;             // TGM AB 28/07/17

end;


procedure TOverpaymentForm.DBGrid1DblClick(Sender: TObject);
var
        RowSelected, i : integer;
begin

     RowSelected := AccsDataModule.OverpaymentTempDB['TxNo'];

     if AccsDataModule.OverpaymentTempDB['Tick'] = 'ü' then begin
                AccsDataModule.OverpaymentTempDB.edit;
                AccsDataModule.OverpaymentTempDB['Tick'] := '';
                AccsDataModule.OverpaymentTempDB.post;
                ContinueBtn1.enabled := false;
     end
        else begin
              AccsDataModule.OverpaymentTempDB.first;
              for i:=1 to AccsDataModule.OverpaymentTempDB.recordcount do begin
                   AccsDataModule.OverpaymentTempDB.edit;
                   AccsDataModule.OverpaymentTempDB['Tick'] := '';
                   AccsDataModule.OverpaymentTempDB.post;
                   AccsDataModule.OverpaymentTempDB.next;
                end;

          AccsDataModule.OverpaymentTempDB.locate('TxNo',Rowselected,[]);
          AccsDataModule.OverpaymentTempDB.edit;
          AccsDataModule.OverpaymentTempDB['Tick'] := 'ü';
          AccsDataModule.OverpaymentTempDB.post;
          ContinueBtn1.enabled := true;
          ActiveTXID := AccsDataModule.OverpaymentTempDB['TxNo'];
          try OverpaymentToBeAllocated := AccsDataModule.OverpaymentTempDB['OverpaymentRemaining']
          except
          end;
          try CreditNoteToBeAllocated := AccsDataModule.OverpaymentTempDB['CreditNoteAmount']
          except
          end;

          if CreditNoteToBeallocated <> 0 then CreditNoteTx := True
                else CreditNoteTx := False;

          OverpaymentAmtlbl.Caption := FormatFloat('#######0.00', (OverpaymentToBeAllocated+CreditNoteToBeAllocated));
     end;
end;

procedure TOverpaymentForm.DateSearchCloseUp(Sender: TObject);
begin
        TxDate.Text:= DateToStr(DateSearch.Date);
        TxDate.SetFocus;
end;

procedure TOverpaymentForm.TxDateExit(Sender: TObject);
Var
   TestDate : ShortString;
   DateBefore : Boolean;
begin
     TestDate := '';
     TestDate := TxDate.Text;
     If NOT DateValid ( TxDate.Text, TDateFormat ) Then
        TxDate.SetFocus
     Else If NOT CheckDateRange ( TestDate, True, DateBefore, True ) Then
        Begin
             TxDate.Text := TestDate;
             TxDate.SetFocus;
        End;

end;

procedure TOverpaymentForm.IncludeLastYearCBClick(Sender: TObject);
begin
        ContinueBtn1Click(self);
end;

end.
