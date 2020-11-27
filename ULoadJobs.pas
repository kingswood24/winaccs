unit ULoadJobs;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Buttons, ExtCtrls;

type
  TFLoadJobs = class(TForm)
    DetailGrid: TStringGrid;
    Label1: TLabel;
    accountlabel: TLabel;
    Panel1: TPanel;
    ListCancel: TBitBtn;
    ListSelect: TBitBtn;
    procedure ListCancelClick(Sender: TObject);
    procedure ListJobCards(Autoclose : Boolean);
    procedure ListProformaInvoices(Autoclose : Boolean);
    procedure ListQuotes(Autoclose: boolean);
    procedure ClearGrid(Sender: TObject);
    procedure ListSelectClick(Sender: TObject);
    procedure BuildWindow(ListingType : Char; ShowWindow : Boolean);
    procedure NewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NoToNewJobCard : Boolean;
    NoToNewProforma : Boolean;
    NoToNewQuote : Boolean;
  end;

var
  FLoadJobs: TFLoadJobs;
  JobCard : Boolean;
  Proforma : Boolean;
  Quote : Boolean;
  JobCardsFound : Boolean;
  ProformaFound : Boolean;
  QuoteFound : Boolean;


implementation

{$R *.DFM}

Uses
  Cashbook, Accsdata;

procedure TFLoadJobs.ListCancelClick(Sender: TObject);
begin
     if Jobcard then NoToNewJobCard := true;
     if Proforma then NoToNewProforma := true;
     if Quote then NoToNewQuote := true;
     close;
end;

procedure TFLoadJobs.ClearGrid(Sender: TObject);
var
   i,j: integer;
begin
     For i:= 0 to (detailgrid.colcount-1) do begin
         for j := 1 to (detailgrid.rowcount-1) do begin

             Detailgrid.cells[i,j] := '';

         end;
     end;
end;

procedure TFLoadJobs.BuildWindow(ListingType : Char; ShowWindow : Boolean);
begin
    // Listing Types

//    J - listing of unfinished jobcards
//    P - listing of printed proforma invoices
//    Q - listing of quotes

    Jobcard := false;
    Proforma := false;
    Quote := false;

    if lowercase(listingtype) = 'j' then begin
                                               jobcard := true;
                                               ListJobCards(False);
                                               if (ShowWindow and JobCardsFound) then Self.showmodal;
    end
       else if lowercase(listingtype) = 'p' then begin
                                                       Proforma := true;
                                                       ListProformaInvoices(False);
                                                       if (ShowWindow and ProformaFound) then Self.showmodal;
       end
          else if lowercase(listingtype) = 'q' then begin
                                                       Quote := true;
                                                       ListQuotes(False);
                                                       if (ShowWindow and QuoteFound) then Self.showmodal;

          end;
end;

procedure TFLoadJobs.ListJobCards(Autoclose: boolean);
var
   PrevBatchID, CurrentBatchID, i, gridrow : Integer;
begin
        Label1.caption := 'Uncomplete Job Cards for : -';
        DetailGrid.ColCount := 4;
        Detailgrid.ColWidths[0] := 62;
        Detailgrid.Cells[0,0] := 'Job Date';
        Detailgrid.ColWidths[1] := 162;
        Detailgrid.Cells[1,0] := 'Comment';
        Detailgrid.ColWidths[2] := 120;
        Detailgrid.Cells[2,0] := 'Job Card No.';
        Detailgrid.ColWidths[3] := 0;
        FLoadJobs.Caption := 'Load A JobCard';
        JobCardsFound := false;
        NoToNewJobCard := false;

        accsdatamodule.ProformaDB.filter:= ' CustID = ''' + CashbookForm.custsuppcode.text + '''' +  ' and Complete = ''False'' and Proforma = ''False'' and Quote = ''False'' and BatchID > 0';
        accsDataModule.ProformaDB.Filtered := true;
        accsdatamodule.ProformaDB.open;
        accsdatamodule.ProformaDB.first;
        PrevBatchID := 0;
        Gridrow := 1;
        with accsdataModule.ProformaDB do begin
             if RecordCount > 0 then begin
                JobCardsFound := true;
                For i := 1 to Recordcount do begin
                     CurrentBatchId := StrToInt(FieldValues['BatchID']);
                     if CurrentBatchID <> PrevBatchID then begin
                                 Detailgrid.cells[0,gridrow] := VartoStr(FieldValues['JobDate']);
                                 Detailgrid.cells[1,gridrow] := VartoStr(FieldValues['Comment']);
                                 Detailgrid.cells[2,gridrow] := VartoStr(FieldValues['JobCardNumber']);
                                 Detailgrid.cells[3,gridrow] := VartoStr(CurrentBatchID);
                                 inc(Gridrow);
                                 PrevBatchID := CurrentBatchID;
                     end;
                     next;
               end;
             end
                else begin
                     if Messagedlg('No Unfinished Job Cards For This Customer.' +#10#13 +'Would You Like To Create A New Job Card For This Customer?',
                                       mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
                                                                                           EditingJobCard := false;
                                                                                           AccsDataModule.ProdsTxTemp.active:=false;
                                                                                           AccsDataModule.ProdsTxTemp.EmptyTable;
                                                                                           AccsDataModule.ProdsTxTemp.open;
                                                                                           _BatchID := Cashbookform.FindHighestJobCardNumber +1;
                                                                                           Cashbookform.DeleteJobCard.Enabled := false;
                                                                                           Cashbookform.CreateNewJobCard(Cashbookform.CustSuppCode.text);
                                                                                           Cashbookform.CustSuppCodeexit(self);
                                                                                           close;
                                                                                           end
                        else begin
                             NoToNewJobCard := true;
                             close;
                        end;
                     end;

        end;
        if Autoclose then close;

end;

procedure TFLoadJobs.ListProformaInvoices(Autoclose: boolean);
var
   PrevBatchID, CurrentBatchID, i, gridrow : Integer;
begin
        Label1.caption := 'Uncomplete Proforma Invoices for : -';
        DetailGrid.ColCount := 4;
        Detailgrid.ColWidths[0] := 62;
        Detailgrid.Cells[0,0] := 'Date';
        Detailgrid.ColWidths[1] := 90;
        Detailgrid.Cells[1,0] := 'Comment';
        Detailgrid.ColWidths[2] := 120;
        Detailgrid.Cells[2,0] := 'Proforma Invoice No.';
        Detailgrid.ColWidths[3] := 0;
        FLoadJobs.Caption := 'Load A Proforma Invoice';
        ProformaFound := false;
        NoToNewProforma := false;

        accsdatamodule.ProformaDB.filter:= ' CustID = ''' + CashbookForm.custsuppcode.text + '''' +  ' and Complete = ''False'' and Proforma = ''True'' and BatchID > 0';
        accsDataModule.ProformaDB.Filtered := true;
        accsdatamodule.ProformaDB.open;
        accsdatamodule.ProformaDB.first;
        PrevBatchID := 0;
        Gridrow := 1;
        with accsdataModule.ProformaDB do begin
             if RecordCount > 0 then begin
                ProformaFound := true;
                For i := 1 to Recordcount do begin
                     CurrentBatchId := StrToInt(FieldValues['BatchID']);
                     if CurrentBatchID <> PrevBatchID then begin
                                 Detailgrid.cells[0,gridrow] := VartoStr(FieldValues['JobDate']);
                                 Detailgrid.cells[1,gridrow] := VartoStr(FieldValues['Comment']);
                                 Detailgrid.cells[2,gridrow] := VartoStr(FieldValues['ProformaNumber']);
                                 Detailgrid.cells[3,gridrow] := VartoStr(CurrentBatchID);
                                 inc(Gridrow);
                                 PrevBatchID := CurrentBatchID;
                     end;
                     next;
               end;
             end
                else begin
                     if Messagedlg('No Unfinished Proforma Invoices For This Customer.' +#10#13 +'Would You Like To Create A New Proforma Invoice For This Customer?',
                                       mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
                                                                                           EditingJobCard := false;
                                                                                           AccsDataModule.ProdsTxTemp.active:=false;
                                                                                           AccsDataModule.ProdsTxTemp.EmptyTable;
                                                                                           AccsDataModule.ProdsTxTemp.open;
                                                                                           _BatchID := Cashbookform.FindHighestJobCardNumber +1;
                                                                                           Cashbookform.DeleteProforma.Enabled := false;
                                                                                           Cashbookform.CreateNewJobCard(Cashbookform.CustSuppCode.text);
                                                                                           Cashbookform.CustSuppCodeexit(self);
                                                                                           close;
                                                                                           end
                        else begin
                             NoToNewProforma := true;
                             close;
                        end;
                     end;

        end;
        if Autoclose then close;

end;

procedure TFLoadJobs.ListQuotes(Autoclose: boolean);
var
   PrevBatchID, CurrentBatchID, i, gridrow : Integer;
begin
        Label1.caption := 'Quotations for : -';
        DetailGrid.ColCount := 4;
        Detailgrid.ColWidths[0] := 62;
        Detailgrid.Cells[0,0] := 'Date';
        Detailgrid.ColWidths[1] := 90;
        Detailgrid.Cells[1,0] := 'Comment';
        Detailgrid.ColWidths[2] := 120;
        Detailgrid.Cells[2,0] := 'Quote No.';
        Detailgrid.ColWidths[3] := 0;
        FLoadJobs.Caption := 'Load A Quotation';
        QuoteFound := false;
        NoToNewQuote := false;

        accsdatamodule.ProformaDB.filter:= ' CustID = ''' + CashbookForm.custsuppcode.text + '''' +  ' and Complete = ''False'' and Quote = ''True'' and BatchID > 0';
        accsDataModule.ProformaDB.Filtered := true;
        accsdatamodule.ProformaDB.open;
        accsdatamodule.ProformaDB.first;
        PrevBatchID := 0;
        Gridrow := 1;
        with accsdataModule.ProformaDB do begin
             if RecordCount > 0 then begin
                QuoteFound := true;
                For i := 1 to Recordcount do begin
                     CurrentBatchId := StrToInt(FieldValues['BatchID']);
                     if CurrentBatchID <> PrevBatchID then begin
                                 Detailgrid.cells[0,gridrow] := VartoStr(FieldValues['JobDate']);
                                 Detailgrid.cells[1,gridrow] := VartoStr(FieldValues['Comment']);
                                 Detailgrid.cells[2,gridrow] := VartoStr(FieldValues['QuoteNumber']);
                                 Detailgrid.cells[3,gridrow] := VartoStr(CurrentBatchID);
                                 inc(Gridrow);
                                 PrevBatchID := CurrentBatchID;
                     end;
                     next;
               end;
             end
                else begin
                     if Messagedlg('No Quotations For This Customer.' +#10#13 +'Would You Like To Create A New Quotation For This Customer?',
                                       mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
                                                                                           EditingJobCard := false;
                                                                                           AccsDataModule.ProdsTxTemp.active:=false;
                                                                                           AccsDataModule.ProdsTxTemp.EmptyTable;
                                                                                           AccsDataModule.ProdsTxTemp.open;
                                                                                           _BatchID := Cashbookform.FindHighestJobCardNumber +1;
                                                                                           Cashbookform.DeleteProforma.Enabled := false;
                                                                                           Cashbookform.CreateNewJobCard(Cashbookform.CustSuppCode.text);
                                                                                           Cashbookform.CustSuppCodeexit(self);
                                                                                           close;
                                                                                           end
                        else begin
                             NoToNewQuote := true;
                             close;
                        end;
                     end;

        end;
        if Autoclose then close;

end;



procedure TFLoadJobs.ListSelectClick(Sender: TObject);
begin
   if Length(Trim(Detailgrid.cells[3,Detailgrid.row])) = 0 then Exit;

   try
     _BatchID := StrToInt(Detailgrid.cells[3,Detailgrid.row]);
   except
      MessageDlg('An error occurred while loading the details for the selected record.',mtError,[mbOK],0);
      Exit;
   end;

     if jobcard then cashbookform.loadjobcards(detailgrid.cells[3,Detailgrid.row],'J');  // load batch number in column 2 on current row
     if proforma then cashbookform.loadjobcards(detailgrid.cells[3,Detailgrid.row],'P');
     if Quote then cashbookform.loadjobcards(detailgrid.cells[3,Detailgrid.row],'Q');
     close;
end;

procedure TFLoadJobs.NewClick(Sender: TObject);
begin
     close;
end;

end.
