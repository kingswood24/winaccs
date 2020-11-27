{
   06/03/12 [V4.1 R1.4] /MK Additional Feature - New Export To PDF Option.

   09/02/17 [V4.2 R6.2] /MK Bug Fix - Company Reg No on print out was overwriting Vat Number.
                            Change - Changed order of Email, Web, Company Reg No and Vat Number so they are in this order - GL request.

   22/02/17 [V4.2 R6.4] /MK Change - SetColumnDefaults, SetColumns - Changes made to these procedures based on new layout changes - GL request.

   21/03/17 [V4.2 R7.2] /MK Bug Fix - TotExcVATLabel1, TotalVATLabel1 and TotalIncVATLabel1.Enabled were not showing on invoice - Tom O'Keeffe reported.
}

unit InvoicePrint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, InvoiceReport,
  StdCtrls, RxLookup, Quickrpt, QRCtrls, Registry, Buttons, ExtCtrls, Db,
  DBTables, QRExportHelper, cxButtons, cxControls, cxContainer, cxEdit,
  cxGroupBox, dxStatusBar, ActnList, dxBar, dxBarExtItems, uEmailEntityInfo;

type
  TInvoicePrintForm = class(TForm)
    LayoutName: TEdit;
    Query1: TQuery;
    SaveDialog: TSaveDialog;
    gbInvoiceOptions: TcxGroupBox;
    btnSendByEmail: TcxButton;
    btnSave: TcxButton;
    btnInvoiceLayouts: TcxButton;
    btnSequenceNumbers: TcxButton;
    btnPreview: TcxButton;
    StatusBar: TdxStatusBar;
    LayoutDropDown: TRxDBLookupCombo;
    Label1: TLabel;
    btnPrint: TcxButton;
    ClearTimer: TTimer;
    ActionList1: TActionList;
    actClose: TAction;
    dxBarManager: TdxBarManager;
    blbClose: TdxBarLargeButton;
    procedure FormShow(Sender: TObject);
    procedure LayoutDropDownChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnInvoiceLayoutsClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSendByEmailClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnSequenceNumbersClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClearTimerTimer(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
  private
    { Private declarations }
    HeaderImage : TQRImage;
    FEntityInfo : TEntityInfo;
    procedure SetHeaderDetails;
    procedure SetRemittanceDetails;
    procedure SetColumnDefaults;
    procedure SetColumns;
    procedure BuildReport;
    procedure ClearStatusPanel;
    procedure UpdateStatusPanel(const AText : string; const AColor : TColor = clWindowText);
    function GetCustSuppInfo(ALedgerDB, ARecID: Integer): TEntityInfo;
  public
    { Public declarations }
    InvoiceType : string;
    EntityId : Integer;
    InvoiceNumber : string;

    procedure Clear;
  end;

var
  InvoicePrintForm: TInvoicePrintForm;

implementation

uses AccsData, Cashbook, InvoiceLayout,chkcomp,vars,types, SequenceNumbers, calcs,
  DbCore, uEmailTemplates, AccsUtils, FileCtrl;

{$R *.DFM}

procedure TInvoicePrintForm.SetHeaderDetails;
var
   headerheight : integer;
   RHeaderHeight : Real;
   i : integer;
   RNameAddressStart : Real;
   NameAddressStart : integer;
   RPageNumberStart : Real;
   PageNumberStart : integer;
    LineCount : integer;  // TGM AB 23/02/18
    CommentString : string; // TGM AB 23/02/18
    J : integer;  // TGM AB 23/02/18

begin
   with InvoiceReportForm do
      begin
         ToName.top := 160;
         ToAddress1.top := 184;
         ToAddress2.top := 202;     //208
         ToAddress3.top := 220;     //232
         ToAddress4.top := 238;     //256
         ToAddress5.top := 256;

         QRLabel1.Enabled := True;
         QRLabel1.Caption := '';
         QRLabel2.Enabled := True;
         QRLabel2.Caption := '';

         HeaderImage.Parent := nil;

         if not (accsdatamodule.invoicelayout['UsePrePrinted'] = true) then
            begin
               QRLabel2.top :=  24;
               QRSysData1.top := 24;

               if ( accsdatamodule.invoicelayout['UseGraphicsFile'] = true ) and
                  ( accsdatamodule.invoicelayout['GraphicsFileName'] <> '' ) and
                  FileExists( accsdatamodule.invoicelayout['GraphicsFileName'] ) then
                     begin
                        HeaderImage.Parent := PageHeader;
                        Headerimage.Enabled := True;
                        HeaderImage.Left := 1;
                        HeaderImage.Top := 4;
                        HeaderImage.AutoSize := True;
                        HeaderImage.Picture.LoadFromFile(accsdatamodule.invoicelayout['GraphicsFileName']);
                        Headerimage.height := 119;

                        QRLabel15.Left := 12; // Invoice Number Label
                        InvoiceNumber.Left := 124;
                        QRShape2.Left := 116;  // box
                        QRLabel13.Left := 220; // date Label
                        Date.Left := 268;
                        Date.top := 124;
                        QRShape5.Left := 260; // box

                      QRShape2.top := 122;                    // TGM AB 23/02/18     was 120
                      QRShape5.top := 122;                    // TGM AB 23/02/18     was 120
                      InvoiceNumber.top := 126;               // TGM AB 23/02/18     was 124
                      QRLabel15.top := 126;                   // TGM AB 23/02/18     was 124
                      QRLabel13.top := 124;
                      Fromname.Top := 128;
                      Address1.Top := 144;
                      Address2.Top := 160;
                      Address3.Top := 176;
                      Address4.Top := 192;
                      Address5.Top := 208;
                      Tellabel.top := 160;
                      Tel1.top := 160;
                      Tel2.top := 176;
                      Faxlabel.Top := 192;
                      Fax.top := 192;
                      MobileLabel.top := 208;
                      Mobile.top := 208;
                      emaillabel.top := 224;
                      email.top := 224;
                      weblabel.top := 240;            // TGM AB 03/02/17 was 272
                      web.top := 240;                 // TGM AB 03/02/17 was 272
                      Companyreglabel.Top := 256;
                      Companyreg.Top := 256;
                      Vatnumberlabel.top := 272;      // TGM AB 03/02/17 was 252
                      vatnumber.top := 272;           // TGM AB 03/02/17 was 252
                   end
                else begin // not using graphics
                      QRLabel15.Left := 12; // Invoice Number Label
                      InvoiceNumber.Left := 124;
                      QRShape2.Left := 116;  // box
                      QRLabel13.Left := 12; // date Label
                      Date.Left := 126;               // TGM AB 23/02/18     was 122

                      QRLabel13.top := 94;
                      Date.top := 94;
                      QRShape2.top := 122;            // TGM AB 23/02/18     was 120
                      InvoiceNumber.top := 126;       // TGM AB 23/02/18     was 124
                      QRLabel15.top := 126;           // TGM AB 23/02/18     was 124
                      QRShape5.Left := 116; // box
                      QRShape5.top := 90;
                      Fromname.Top := 94;
                      Address1.Top := 110;
                      Address2.Top := 126;
                      Address3.Top := 142;
                      Address4.Top := 158;
                      Address5.Top := 174;
                      Tellabel.top := 110;
                      Tel1.top := 110;
                      Tel2.top := 126;
                      Faxlabel.Top := 150;
                      Fax.top := 150;
                      MobileLabel.top := 166;
                      Mobile.top := 166;
                      emaillabel.top := 208;
                      email.top := 208;
                      weblabel.top := 224;                  // TGM AB 03/02/17 was 255
                      web.top := 224;                       // TGM AB 03/02/17 was 255
                      Companyreglabel.Top := 240;
                      Companyreg.Top := 240;
                      Vatnumberlabel.top := 256;            // TGM AB 03/02/17 was 232
                      vatnumber.top := 256;                 // TGM AB 03/02/17 was 232
                end;
             EMailLabel.Left := WebLabel.Left;
             email.left := Web.Left;

               for i:= 0 to componentcount - 1 do
                  begin
                     if Components[i] is TQRLabel then
                        if TQRLabel(Components[i]).Tag = 4 then
                           TQRLabel(Components[i]).enabled := true;
                     if Components[i] is TQRShape then
                        if TQRShape(Components[i]).Tag = 4 then
                           TQRShape(Components[i]).enabled := true;
                  end;

               DescriptionLabel.Enabled := true;
               LineDateLabel.Enabled := true;
               LineRefLabel.Enabled := true;
               DetailsLabel.Enabled := true;
               QTYLabel.Enabled := true;
               EachLabel.Enabled := true;
               TotalLabel.Enabled := true;
               VATRateLabel.Enabled := true;
               VATLabel.Enabled := true;
               TotalIncVATLabel.Enabled := true;
               TotalIncVATDBText.Enabled := true;
               QRShape6.Enabled := true;
               QRShape8.Enabled := true;

               Pagefooter.Enabled := true;

               //QRBand1.Enabled := True;
               PageHeader.Height := 347; //299;

               if PROG = SALESTX then begin
                if ((cashbookform.caption = 'Sales Invoice') or (cashbookform.caption = 'Job Card to Sales Invoice') or (cashbookform.caption = 'Proforma Invoice to Sales Invoice')) then begin
                   QRLabel1.Caption := 'Sales Invoice';
                   QRLabel15.Caption := 'Invoice Number:';
                end;
                if cashbookform.caption = 'Sales Credit Note' then begin
                   QRLabel1.Caption := 'Sales Credit Note';
                   QRLabel15.Caption := ' Credit Number:';
                end;
                if cashbookform.caption = 'Quotation' then begin
                   QRLabel1.Caption := 'Quotation';
                   QRLabel15.Caption := 'Quote Number:';
                end;
                if cashbookform.Caption = 'Proforma Invoicing' then begin
                   QRLabel1.Caption := 'Proforma Invoice - This Is Not A Tax Invoice';
                   QRLabel15.Caption := 'Proforma Number';
                end;
                QRLabel14.Caption := 'To';
               end else begin
                 QRLabel1.Caption := 'Invoice';
                 QRLabel15.Caption := 'Invoice Number:';
                 QRLabel14.Caption := 'From';
               end;

               if ( accsdatamodule.invoicelayout['UseGraphicsFile'] = true ) then
                  begin
                     QRLabel1.Enabled := False;
                     QRLabel1.Caption := '';
                     QRLabel2.Enabled := False;
                     QRLabel2.Caption := '';
                  end;

               if accsdatamodule.invoicelayout['incname'] = true then begin
                  FromName.caption:=varToStr(accsdatamodule.invoicelayout['name']);
               end else begin
                   FromName.caption:='';
               end;

               if accsdatamodule.invoicelayout['incaddress1'] = true then address1.caption:=varToStr(accsdatamodule.invoicelayout['address1'])
                  else address1.caption:='';
               if accsdatamodule.invoicelayout['incaddress2'] = true then address2.caption:=varToStr(accsdatamodule.invoicelayout['address2'])
                  else address2.caption:='';
               if accsdatamodule.invoicelayout['incaddress3'] = true then address3.caption:=varToStr(accsdatamodule.invoicelayout['address3'])
                  else address3.caption:='';
               if accsdatamodule.invoicelayout['incaddress4'] = true then address4.caption:=varToStr(accsdatamodule.invoicelayout['address4'])
                  else address4.caption:='';
               if accsdatamodule.invoicelayout['incaddress5'] = true then address5.caption:=varToStr(accsdatamodule.invoicelayout['address5'])
                  else address5.caption:='';
               if accsdatamodule.invoicelayout['incTel1'] = true then Tel1.caption:=varToStr(accsdatamodule.invoicelayout['Tel1'])
                  else Tel1.caption:='';
               if accsdatamodule.invoicelayout['incTel2'] = true then Tel2.caption:=varToStr(accsdatamodule.invoicelayout['Tel2'])
                  else Tel2.caption:='';
               If (Tel1.Caption = '') and (Tel2.caption = '') then TelLabel.enabled:=false
                  else TelLabel.enabled:=true;
               if accsdatamodule.invoicelayout['incFax'] = true then begin
                  FaxLabel.enabled:=true;
                  Fax.caption:=varToStr(accsdatamodule.invoicelayout['Fax']);
               end else begin
                   Fax.caption:='';
                   FaxLabel.enabled:=false;
               end;
               if accsdatamodule.invoicelayout['incMobile'] = true then begin
                  MobileLabel.enabled:=true;
                  Mobile.caption:=varToStr(accsdatamodule.invoicelayout['Mobile']);
               end else begin
                   MobileLabel.enabled:=false;
                   Mobile.caption:='';
               end;
               if accsdatamodule.invoicelayout['incemail'] = true then begin
                  emailLabel.enabled:=true;
                  email.caption:=varToStr(accsdatamodule.invoicelayout['email']);
               end else begin
                   EmailLabel.enabled:=false;
                   email.caption:='';
               end;
               if accsdatamodule.invoicelayout['incweb'] = true then begin
                  webLabel.enabled:=true;
                  web.caption:=varToStr(accsdatamodule.invoicelayout['web']);
               end else begin
                   WebLabel.enabled:=false;
                   web.caption:='';
               end;
               if accsdatamodule.invoicelayout['incVATNumber'] = true then begin
                  VATNumberLabel.enabled:=true;
                  VATNumber.caption:=varToStr(accsdatamodule.invoicelayout['VATNumber']);
               end else begin
                   VATNumberLabel.enabled:=false;
                   VATNumber.caption:='';
               end;
               if accsdatamodule.invoicelayout['incCompanyReg'] = true then begin
                  CompanyRegLabel.enabled:=true;
                  CompanyReg.caption:=varToStr(accsdatamodule.invoicelayout['CompanyRegNumber']);
               end else begin
                   CompanyRegLabel.enabled:=false;
                   CompanyReg.caption:='';
               end;
               if accsdatamodule.invoicelayout['includeVAT'] = true then begin
                  VATLabel.enabled:=true;
                  TotalLabel.enabled:=true;
                  VATDBText.enabled := true;
                  TotalDBText.enabled := true;
               end else begin
                   VATLabel.enabled:=false;
                   TotalLabel.enabled:=false;
                   VATDBText.enabled := false;
                   TotalDBText.enabled := false;
               end;
           end
         else
            begin //  if using preprinted stationary
               RNameAddressStart := accsdatamodule.invoicelayout['NameAddressStart']*30;
               NameAddressStart := Round(RNameAddressStart);
               for i:= 0 to componentcount - 1 do begin
                  If Components[i] is TQRLabel then
                     if  TQRLabel(Components[i]).Tag = 4 then // total labels
                         TQRLabel(Components[i]).enabled:=false;
                  If Components[i] is TQRShape then
                     if  TQRShape(Components[i]).Tag = 4 then
                         TQRShape(Components[i]).enabled:=false;
               end;
               for i:= 0 to componentcount - 1 do begin
                   If Components[i] is TQRLabel then
                      if  TQRLabel(Components[i]).Tag = 6 then // to name and address
                          TQRLabel(Components[i]).top:= TQRLabel(Components[i]).top - (160-NameAddressStart);
               end;

               FromName.Caption := '';
               Address1.caption := '';
               Address2.caption := '';
               Address3.caption := '';
               Address4.caption := '';
               Address5.caption := '';
               Tel1.Caption := '';
               Tel2.Caption := '';
               Fax.caption := '';
               Mobile.caption:='';
               VatNumber.Caption := '';
               CompanyReg.caption := '';
               Email.Caption := '';
               Web.Caption := '';

               DescriptionLabel.Enabled := false;
               LineDateLabel.Enabled := false;
               LineRefLabel.Enabled := false;
               DetailsLabel.Enabled := false;
               QTYLabel.Enabled := false;
               EachLabel.Enabled := false;
               TotalLabel.Enabled := false;
               VATRateLabel.Enabled := false;
               VATLabel.Enabled := false;
               TotalIncVATLabel.Enabled := false;
               TotalIncVATDBText.Enabled := False;
               QRShape6.Enabled := false;
               QRShape8.Enabled := false;

               RPageNumberStart := accsdatamodule.invoicelayout['PageNumberStart']*33;
               PageNumberStart := Round(RPageNumberStart);

               QRLabel2.top :=  PageNumberStart; //285;
               QRSysData1.top := PageNumberStart; //285;
               Date.top := ToName.Top;
               Date.left := 484;
               InvoiceNumber.top := Date.top + 50; //175;
               InvoiceNUmber.left := 484;
               RHeaderHeight := accsdatamodule.invoicelayout['HeaderHeight']*33;
               HeaderHeight := Round(RHeaderHeight);
               PageHeader.Height := HeaderHeight;
            end;
      end;

              // TGM AB - Comment Information
              // TGM AB 23/02/18 - updated for new label

         if accsdatamodule.invoicelayout['includecomment'] = true then begin
             InvoiceReportForm.ChildBand1.Enabled := true;

             LineCount := 1;

             try
                CommentString := accsdatamodule.invoicelayout.FieldByName('Comment').asString;
             except    CommentString :=  '';
             end;

             If length(CommentString) > 0 then begin

                for j:= 0 to length(CommentString) do begin
                  if CommentString[j] = #13 then LineCount := LineCount + 1;
                end;
             end;

             // Set the correct height - each line = 15

             InvoiceReportForm.CommentLabel.height := 15 * Linecount;
             InvoiceReportForm.CommentLabel.Caption := CommentString;
             InvoiceReportForm.ChildBand1.height := InvoiceReportForm.CommentLabel.height + 10;

         end else
                  InvoiceReportForm.ChildBand1.Enabled := false;

             // TGM AB 23/02/18 end
end;

procedure TInvoicePrintForm.SetRemittanceDetails;
var
   i : integer;
begin
   with InvoiceReportForm do
      begin
         if ( AccsDataModule.InvoiceLayout.FieldByName('incRemittanceSlip').AsBoolean ) then
            begin
               RemittanceLine1.enabled := True;
               RemittanceBox1.enabled := True;
               for i:= 0 to componentcount - 1 do
                  begin
                     if ( Components[i] is TQRLabel ) then
                        if ( TQRLabel(Components[i]).Tag = 3 ) then
                           TQRLabel(Components[i]).enabled := True;
                  end;
               if ( Length(AccsDataModule.InvoiceLayout.FieldByName('RemittanceComment').AsString) > 0 ) then
                  RemittanceComment.Caption := VarToStr(AccsDataModule.InvoiceLayout.FieldByName('RemittanceComment').AsString);
               RemittanceComment.Enabled := ( Length(RemittanceComment.Caption) > 0 );
               if ( RemittanceComment.Enabled ) then
                  Summary.Height := 250
               else
                  Summary.Height := 200;
            end
         else
            begin
               RemittanceLine1.Enabled := False;
               RemittanceBox1.Enabled := False;
               for i:= 0 to componentcount - 1 do
                  begin
                     if ( Components[i] is TQRLabel ) then
                        if ( TQRLabel(Components[i]).Tag = 3 ) then
                           TQRLabel(Components[i]).enabled := False;
                  end;
               Summary.Height := 105;                               // TGM AB 5/09/02 Changed from 115
            end;
      end;
end;

procedure TInvoicePrintForm.SetColumnDefaults;
var i : integer;
begin
         With InvoiceReportForm do begin
                                                        // TGM AB 15/09/17 begin - Copied in Kingswood values & modified slightly to allow for extra digit in each column
              DescriptionLabel.Left := 4;
              DescriptionLabel.Width := 104;
              DescriptionDBText.Left := 4;
              DescriptionDBText.Width := 104;
              LineDateLabel.Left := 112; //95
              LineDateDBText.Left := 112; //95
              LineRefLabel.Left := 170; //95
              LineRefDBText.Left := 170; //95
              DetailsLabel.Left := 273; //267
              Line1DBText.Left := DetailsLabel.Left; //241
              Line1DBText.Width := 156;
              Line2DBText.Left := DetailsLabel.Left; //241
              Line2DBText.Width := 156;
              Line3DBText.Left := DetailsLabel.Left; //241
              Line3DBText.Width := 156;
              QtyLabel.Left := 452; //492
              QtyDBText.Left := 434; //488
              EachLabel.Left := 453; //532
              EachDBText.Left := 453; //528       // TGM AB 15/09/17 moved from 447 to 453
              EachIncVATDBtext.Left := 468;       // TGM AB 15/09/17 moved from 462 to 468
              TotalLabel.Left := 546; //580       // TGM AB 15/09/17 moved from 540 to 546
              TotalDBText.Left := 503; //544      // TGM AB 15/09/17 moved from 497 to 503
              VatRatelabel.Left := 573;
              VATRateDBText.Left := 553;
              VATLabel.Left := 617;
              VATDBText.Left := 597;
              TotalIncVATLabel.Left := 672;
              TotalIncVATDBtext.Left := 648;
                                                           // TGM AB 15/09/17 end
              DescriptionLabel.enabled := true;
              DescriptionDBtext.enabled := true;

              LineDateLabel.Enabled:= true;
              LineRefLabel.Enabled:= true;
              LineDateDBText.enabled:=true;
              LineRefDBText.enabled:=true;
              VATLabel.Enabled:= true;
              TotalLabel.Enabled:= true;
              VATDBText.enabled:=true;
              TotalDBText.enabled:=true;
              EachDBText.enabled:= true;
              VatRatelabel.enabled := true;
              VatRateDBText.enabled := true;
              EachIncVATDBtext.enabled := false;
              TotalIncVATDBText.enabled := true;

              VatAnalysisLabel.enabled := true;
              VATCodeRateLabel.enabled := True;             // TGM AB 23/02/18
              AmountTableLabel.enabled := True;             // TGM AB 23/02/18
              VATTableLabel.enabled := True;                // TGM AB 23/02/18
              EuroAmountTableLabel.enabled := False;        // TGM AB 23/02/18
              EuroVATTableLabel.enabled := False;           // TGM AB 23/02/18
              TotalQuantLabel.enabled := True;
              SumQuantity.enabled := True;

              TotExcVAT.top := 24;                     // TGM AB 23/02/18 was 32
              TotVAT.Top := 48;                        // TGM AB 23/02/18 was 56
              TotIncVAT.top := 72;                     // TGM AB 23/02/18 was 80
          end;
end;

procedure TInvoicePrintForm.SetColumns;
var
   i : integer;
   DetailLineCount : Integer;
   RFooterHeight : real;
   FooterHeight : integer;
   bUseLineReference,
   bUseLineDate,
   bIncludeVat,
   bIncludeNominalDesc,
   bIncludeEach,
   bIncludePrePrinted,
   bIncludeVatSummary,
   bIncludeRemitSlip,
   bIncludeQuantSummary,
   Continue : Boolean;
begin
   with InvoiceReportForm do
      begin
         TotExcVATLabel1.Enabled := true;
         TotExcVAT.Enabled := true;

         TotalVATLabel1.Enabled := true;
         TotVAT.Enabled := true;

         TotalIncVATLabel1.Caption := 'Total Including VAT';
         TotalIncVATLabel.Caption := 'Total inc VAT';

         bUseLineDate := AccsDataModule.InvoiceLayout.FieldByName('UseLinedate').AsBoolean;
         bUseLineReference := AccsDataModule.InvoiceLayout.FieldByName('UseLineReference').AsBoolean;
         bIncludeVat := AccsDataModule.InvoiceLayout.FieldByName('IncludeVat').AsBoolean;
         bIncludeNominalDesc := AccsDataModule.InvoiceLayout.FieldByName('IncludeNominalDesc').AsBoolean;
         bIncludeEach := AccsDataModule.InvoiceLayout.FieldByName('IncludeEachColumn').AsBoolean;
         bIncludePrePrinted := AccsDataModule.InvoiceLayout.FieldByName('UsePreprinted').AsBoolean;
         bIncludeVatSummary := AccsDataModule.InvoiceLayout.FieldByName('IncludeVatSummary').AsBoolean;
         bIncludeRemitSlip := AccsDataModule.InvoiceLayout.FieldByName('incRemittanceSlip').AsBoolean;
         bIncludeQuantSummary := AccsDataModule.InvoiceLayout.FieldByName('IncludeQuantSummary').AsBoolean;

         try
            LineDateLabel.Enabled := bUseLineDate;
            LineDateDBText.Enabled := bUseLineDate;
            LineRefLabel.Enabled := bUseLineReference;
            LineRefDBText.Enabled := bUseLineReference;
            if ( (not(bUseLineDate)) and (not(bUseLineReference)) ) or
               ( bUseLineDate and (not(bUseLineReference)) ) then
               begin
                  DetailsLabel.Left := 174;
                  Line1DBText.Left := DetailsLabel.Left;
                  Line1DBText.Width := 257;
                  Line2DBText.Left := DetailsLabel.Left;
                  Line2DBText.Width := Line1DBText.Width;
                  Line3DBText.Left := DetailsLabel.Left;
                  Line3DBText.Width := Line1DBText.Width;
               end;
            if ( (not(bUseLineDate)) and (not(bUseLineReference)) ) then
               begin
                  DescriptionLabel.Width := 167;
                  DescriptionDBText.Width := DescriptionLabel.Width;
               end;

            if ( (not(bUseLineDate)) and bUseLineReference ) then
               begin
                  LineRefLabel.Left := 112;
                  LineRefDBText.Left := 112;
                  DetailsLabel.Left := 215;
                  Line1DBText.Left := DetailsLabel.Left;
                  Line1DBText.Width := 214;
                  Line2DBText.Left := DetailsLabel.Left;
                  Line2DBText.Width := Line1DBText.Width;
                  Line3DBText.Left := DetailsLabel.Left;
                  Line3DBText.Width := Line1DBText.Width;
               end;

         except
         end;

         try
            if ( not(bIncludeVat) ) then
               begin
                  EachDBtext.Enabled := True;
                  TotalLabel.Enabled := True;
                  TotalDBText.Enabled := True;
                  EachLabel.Left := 479;
                  EachDBText.Left := 490;
                  TotalLabel.Left := 620;
                  TotalDBText.Left := 600;
                  VATLabel.Enabled := False;
                  VATDBText.Enabled := False;
                  VatRateLabel.Enabled := False;
                  VatRateDBText.Enabled := False;
                  TotalIncVATDBText.Enabled := False;
                  TotalIncVatLabel.Enabled := False;
                  TotExcVATLabel1.Enabled := False;
                  TotExcVAT.Enabled := False;
                  TotalVATLabel1.Enabled := False;
                  TotVAT.Enabled := False;
                  QRLabel18.Enabled := False;
                  RTotExcVAT.Enabled := False;
                  QRLabel19.Enabled := False;
                  RTotVAT.Enabled := False;
                  TotalIncVATLabel1.Caption := '              Total';
                  QRLabel20.caption := '              Total';
                  TotalIncVATLabel.Caption := 'Total';
               end;
         except
         end;

         try
            DescriptionLabel.enabled := bIncludeNominalDesc;
            DescriptionDBtext.enabled := bIncludeNominalDesc;
            if ( not(bIncludeNominalDesc) ) then
               begin
                  LinedateLabel.Left := LineDateLabel.Left - 90;
                  LinedateDBtext.Left := LinedateLabel.Left;
                  LineRefLabel.Left := LineRefLabel.Left - 90;
                  LineRefDBtext.Left := LineRefLabel.Left;
                  DetailsLabel.Left := DetailsLabel.Left - 90;
                  Line1DBText.Left := DetailsLabel.Left;
                  Line2DBText.Left := DetailsLabel.Left;
                  Line3DBText.Left := DetailsLabel.Left;
               end;
         except
         end;

         //   28/02/18 [V4.3 R0.4] /MK Change - If Nominal is not showing but Line Date and Reference are then allow for longer detail - Donal Browne.
         if ( (not(bIncludeNominalDesc)) and (bUseLineDate) and (bUseLineReference) ) then
            try
               DetailsLabel.Width := 264;
               Line1DBText.Width := DetailsLabel.Width;
               Line2DBText.Width := DetailsLabel.Width;
               Line3DBText.Width := DetailsLabel.Width
            except
            end;

         try
            EachLabel.Enabled := bIncludeEach;
            EachDBText.Enabled := bIncludeEach;
            EachIncVatDBText.Enabled := False;
         except
         end;

         // ***************** PRE PRINTED  *****************
         try
            if ( bIncludePrePrinted ) then
               begin
                  QtyDBText.left := 60; // was 25;
                  QtyDBText.Font.Size := 10;
                  DescriptionDBtext.left := 140; // was 110;
                  EachIncVATDBText.font.size := 10;
                  TotalQuantLabel.font.size := 10;
                  SumQuantity.font.size := 10;
                  try
                     DescriptionDBText.Width := 100; // default 81 on form
                     LineRefDBtext.left := 268;
                     LineRefDBtext.font.Size := 9;
                     LineDateDBText.left := 222;
                     LineDateDBText.Font.Size := 9;
                     if ( bUseLineDate ) then
                        begin
                           DescriptionDBtext.Font.Size := 9;
                           Line1DBText.left := 332;
                           Line1DBText.Font.Size := 9;
                           Line2DBText.left := 332;
                           Line2DBText.Font.Size := 9;
                           Line3DBText.left := 332;
                           Line3DBText.Font.Size := 9;
                        end
                     else
                        begin
                           DescriptionDBtext.Font.Size := 10;
                           Line1DBText.left := 280;
                           Line1DBText.Font.Size := 10;
                           Line2DBText.left := 280;
                           Line2DBText.Font.Size := 10;
                           Line3DBText.left := 280;
                           Line3DBText.Font.Size := 10;
                        end;
                  except
                     DescriptionDBText.Width := 110; // default 81 on form
                     DescriptionDBtext.Font.Size := 10;
                     Line1DBText.left := 280;
                     Line1DBText.Font.Size := 10;
                     Line2DBText.left := 280;
                     Line2DBText.Font.Size := 10;
                     Line3DBText.left := 280;
                     Line3DBText.Font.Size := 10;
                  end;

                  TotalIncVATDBText.Left := 570;
                  TotalIncVATDBText.Font.Size := 10;
                  for i:= 0 to componentcount - 1 do
                     if Components[i] is TQRLabel then
                        if TQRLabel(Components[i]).Tag = 7 then // column titles tag set to 7
                           TQRLabel(Components[i]).enabled:=false;
                  for i:= 0 to componentcount - 1 do
                      if Components[i] is TQRLabel then
                         if TQRLabel(Components[i]).Tag = 4 then // total labels
                            TQRLabel(Components[i]).enabled:=false;

                  RFooterHeight := accsdatamodule.invoicelayout['FooterStart']*33;
                  FooterHeight := Round(RFooterHeight);

                  Summary.Height := FooterHeight; // was 265 increasing this puts footer further up the page

                  TotExcVat.enabled := true;
                  TotExcVAT.top := 0; //22;
                  TotExcVAT.left := 610;

                  TotVat.Enabled:= true;
                  TotVAT.Top := 38; //62;
                  TotVAT.left := 610;

                  TotIncVat.Enabled := true;
                  TotIncVAT.top := 75; //92;
                  TotIncVAT.left := 610;
               end;
         except
         end;

         // ****************** END PRE PRINTED ****************
         try
            VatAnalysisLabel.Enabled := ( bIncludeVatSummary );
            VATCodeRateLabel.Enabled := VatAnalysisLabel.Enabled;
            AmountTableLabel.Enabled := VatAnalysisLabel.Enabled;
            VATTableLabel.Enabled := VatAnalysisLabel.Enabled;
            TotExcVATLabel1.Enabled := VatAnalysisLabel.Enabled;
            TotExcVAT.Enabled := VatAnalysisLabel.Enabled;
            TotalIncVATLabel.Caption := 'Total inc VAT';
            TotExcVATLabel1.Enabled := ( bIncludeVat );
            TotalVATLabel1.Enabled := TotExcVATLabel1.Enabled;
            TotalIncVATLabel1.Enabled := TotExcVATLabel1.Enabled;
            RTotExcVAT.Enabled := bIncludeRemitSlip;
            RTotVAT.Enabled := RTotExcVAT.Enabled;
            QRLabel18.Enabled := RTotExcVAT.Enabled;
            QRLabel19.Enabled := RTotExcVAT.Enabled;
         except
         end;

         try
            TotExcVat.Enabled := bIncludeVat;
            TotVAT.enabled := TotExcVat.Enabled;
            try
               if ( TotExcVat.Enabled ) then
                  begin
                     TotExcVATLabel1.Enabled := bIncludeVat;
                     TotalVATLabel1.Enabled := TotExcVATLabel1.Enabled;
                     TotalIncVATLabel1.Enabled := TotExcVATLabel1.Enabled;
                  end;
            except
            end;
         except
         end;

         try
            TotalQuantLabel.Enabled := bIncludeQuantSummary;
            SumQuantity.Enabled := TotalQuantLabel.Enabled;
         except
         end;

         InvoiceReportForm.Bands.DetailBand.Height := 28;
         InvoiceReportForm.DescriptionDBText.Height := 28;

         AccsDataModule.InvoiceReportTable.Close;
         AccsDataModule.InvoiceReportTable.Open;
      end;
end;

procedure TInvoicePrintForm.FormShow(Sender: TObject);
var registry:TRegistry;
    InvoiceID:integer;
begin
    registry:=Tregistry.Create;
    Registry.OpenKey('Software\Kingswood\Kingsacc\' + Chkcomp.FCheckName.CheckCompanyName.text, True);
    if not (Registry.ReadString('SaleInvoiceID') = '') then
       InvoiceID:= StrToInt(Registry.ReadString('SaleInvoiceID'))
    else InvoiceID:=1;
    Registry.Free;
    try accsdatamodule.InvoiceLayout.locate('ID',InvoiceID,[]);
        //layoutname.text:=accsdatamodule.InvoiceLayout['ReportName'];
        LayoutDropDown.KeyValue := InvoiceID;
    except showmessage('Please Setup An Invoice Layout - Before Printing This Invoice');
    end;

    btnSendByEmail.Enabled := ( (AccsDataModule.MailboxExists) and (EntityId > 0) and ((InvoiceType='Sale') or (InvoiceType='Purchase')) );
    if (btnSendByEmail.Enabled) then
       begin
          if (InvoiceType='Sale') then
             FEntityInfo := GetCustSuppInfo(SLFile,EntityId)
          else if (InvoiceType='Purchase') then
             FEntityInfo := GetCustSuppInfo(PLFile,EntityId)
          else
             raise Exception.Create(Format('Invoice type [%s] is not supported',[InvoiceType]));

          if (FEntityInfo <> nil) then
             begin
                btnSendByEmail.Enabled := FEntityInfo.EmailAddress<>'';
             end;
       end;
end;

function TInvoicePrintForm.GetCustSuppInfo(ALedgerDB, ARecID: Integer): TEntityInfo;
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

procedure TInvoicePrintForm.LayoutDropDownChange(Sender: TObject);
var registry:TRegistry;
    InvoiceID:integer;
begin

    registry:=Tregistry.Create;
    InvoiceID:= accsdatamodule.invoicelayout['ID'];
    Registry.OpenKey('Software\Kingswood\Kingsacc\' + Chkcomp.FCheckName.CheckCompanyName.text, True);
//    Registry.OpenKey('Software\Kingswood\Kingsacc\' + accsdatamodule.accsdatabase.directory, True);
//    Registry.OpenKey('Software\Kingswood\Kingsacc\' + accsdatamodule.accsdatabase.DatabaseName + 'SaleInvoiceID', True);
    Registry.WriteString('SaleInvoiceID',IntToStr(InvoiceID));
    Registry.Free;
    if (accsdatamodule.InvoiceLayout.locate('ID',InvoiceID,[])) then

    //layoutname.text:=accsdatamodule.InvoiceLayout['ReportName'];
end;

procedure TInvoicePrintForm.BuildReport;
begin
   SetHeaderDetails;
   SetRemittanceDetails;
   SetColumnDefaults;
   SetColumns;
end;

procedure TInvoicePrintForm.FormCreate(Sender: TObject);
begin
   HeaderImage := TQRImage.Create(nil);
   ClearStatusPanel();
end;

procedure TInvoicePrintForm.FormDestroy(Sender: TObject);
begin
   if HeaderImage <> nil then
      FreeAndNil(HeaderImage);
end;

procedure TInvoicePrintForm.btnInvoiceLayoutsClick(Sender: TObject);
begin
     If not Bool (InvoiceLayoutForm) then Application.CreateForm(TInvoiceLayoutForm, InvoiceLayoutForm);
     InvoiceLayoutForm.showmodal;
end;

procedure TInvoicePrintForm.btnPreviewClick(Sender: TObject);
begin
   BuildReport;
   InvoiceReportForm.EuroLabel.Caption:=' ';
   InvoiceReportForm.Preview;
end;

procedure TInvoicePrintForm.btnSaveClick(Sender: TObject);
begin
   BuildReport;
   SaveDialog.Execute;
   if ( SaveDialog.FileName <> '' ) then
      SaveAsPDF( InvoiceReportForm, SaveDialog.FileName );
end;

procedure TInvoicePrintForm.btnSendByEmailClick(Sender: TObject);
var
   Result : Integer;
   Files : TStringList;
   ConfirmedEmailAddress : string;
   EmailTemplate : TEmailTemplate;
   FileName : string;
   TempDir : string;
begin
   ClearTimer.Enabled := False;

   if (FEntityInfo = nil) then
      begin
         MessageDlg('An error occurred while preparing email.',mtError,[mbOK],0);
         Exit;
      end;

   TempDir := IncludeTrailingBackslash(AccsDataModule.CurrentDatabasePath) + 'temp';
   if not DirectoryExists(TempDir) then
      CreateDir(TempDir);

   if Length(Trim(FEntityInfo.Name)) = 0 then
      FEntityInfo.Name := 'Invoice';

   Screen.Cursor := crHourGlass;
   try
      btnSendByEmail.Enabled := False;
      ClearStatusPanel();
      BuildReport;

      FileName := Format('%s%s_%s_%s.pdf',
                         [IncludeTrailingBackSlash(TempDir),
                         StripAllNomNumAlpha(FEntityInfo.Name),
                         FormatDateTime('dd-MM-yy',Date),
                         StripAllNomNumAlpha(InvoiceNumber)]);

      SaveAsPDF( InvoiceReportForm, FileName );

      if not(FileExists(FileName)) then Exit;

      try
         Files := TStringList.Create();
         Files.Add(FileName);

         EmailTemplate := TfmEmailTemplates.ShowTheForm(TSelecting);
         if (EmailTemplate <> nil) then
            begin
               ConfirmedEmailAddress := FEntityInfo.EmailAddress;

               if (not (InputQuery('Confirm Email Address', 'Email Address', ConfirmedEmailAddress))) or
                  (Trim(ConfirmedEmailAddress)='') then
                  Exit;

               UpdateStatusPanel('Sending email...');

               if (EmailTemplate.Attachments <> nil) and (EmailTemplate.Attachments.Count>0) then
                  Files.AddStrings(EmailTemplate.Attachments);

               Result := AccsDataModule.SendEMail(ConfirmedEmailAddress, EmailTemplate.Subject, EmailTemplate.Body, Files);
               if (Result=1) then
                  UpdateStatusPanel('Email successfully sent.')
               else
                  UpdateStatusPanel('Error sending email.',clRed)
            end
         else
            UpdateStatusPanel('Template not found. The email has not been sent.');

      finally
         DeleteFile(FileName);
         FreeAndNil(EmailTemplate);
         FreeAndNil(Files);
      end;

   finally
      ClearTimer.Enabled := True;
      btnSendByEmail.Enabled := True;
      Screen.Cursor := crDefault;
   end;
end;

procedure TInvoicePrintForm.btnPrintClick(Sender: TObject);
var i,k,Code,j:integer;
    SEach,SVat,STotalExcVAT, STotalIncVAT :string;
    Each,VAT,TotalExcVAT,TotalIncVAT : real;
    FooterTotalExcVAT, FooterVAT, FooterTotalIncVAT :real;
    TempString:string;
    NumberCopies : integer;
    Tempstr : shortstring;
    TempVATStr : string;
    TempVAT : real;

begin
     BuildReport;
     try NumberCopies := accsdatamodule.InvoiceLayout['NumberOfCopies']
     except numbercopies := 2
     end;
     InvoiceReportForm.EuroLabel.Caption:=' ';
     InvoiceReportForm.Print;
     if NumberCopies > 1 then begin
     If ((Cash11.xEuroConverter > 0) or (Cash11.xEuroConverter < 0)) then
     if messagedlg('Print 2nd Copy as Euro Invoice? ',mtConfirmation, [mbNo, mbYes], 0) = mrYes then
      begin

           Val(Cashbook.CashbookForm.TotalLessVAT.text,FooterTotalExcVAT,Code);
           Val(Cashbook.CashbookForm.TotalVAT.text,FooterVAT,Code);
           Val(Cashbook.CashbookForm.TotalAmt.text,FooterTotalIncVAT,Code);
           if Cash11.xSaveAsEuro then begin
              FooterTotalExcVAT:=FooterTotalExcVAT * Cash11.xEuroConverter / 100;
              FooterVAT:=FooterVAT * Cash11.xEuroConverter /100;
              FooterTotalIncVAT:=FooterTotalIncVAT * Cash11.xEuroConverter /100;
           end else begin
              FooterTotalExcVAT:=FooterTotalExcVAT / Cash11.xEuroConverter / 100;
              FooterVAT:=FooterVAT / Cash11.xEuroConverter / 100;
              FooterTotalIncVAT:=FooterTotalIncVAT / Cash11.xEuroConverter / 100;

           end;
           Str(FooterTotalExcVAT:8:2,TempString);
           InvoiceReport.Invoicereportform.TotExcVAT.caption := TempString;
           InvoiceReport.Invoicereportform.RTotExcVAT.caption:= TempString;
           Str(FooterVAT:5:2,TempString);
           InvoiceReport.Invoicereportform.TotVAT.caption:= TempString;
           InvoiceReport.Invoicereportform.RTotVAT.caption:= TempString;
           Str(FooterTotalIncVAT:8:2,TempString);
           InvoiceReport.Invoicereportform.TotIncVAT.caption:= TempString;
           InvoiceReport.Invoicereportform.RTotIncVAT.caption:= TempString;

           // TGM AB - Showing Euro VAT Summary Table for 2nd Invoice
           InvoiceReport.Invoicereportform.AmountTablelabel.enabled := False;
           InvoiceReport.Invoicereportform.VATTablelabel.enabled := False;
           InvoiceReport.Invoicereportform.EuroAmountTableLabel.enabled := true;
           InvoiceReport.Invoicereportform.EuroVatTableLabel.enabled := true;

        accsdatamodule.InvoiceReportTable.first;
        for i:= 1 to accsdatamodule.InvoiceReportTable.recordcount do begin
            if length(vartostr(accsdatamodule.InvoiceReportTable['VATRate'])) > 0 then begin
                accsdatamodule.InvoiceReportTable.edit;
                SEach:= accsdatamodule.InvoiceReportTable['Each'];
                SVat := accsdatamodule.InvoiceReportTable['VAT'];
                STotalExcVAT := accsdatamodule.InvoiceReportTable['TotalExcVAT'];
                STotalIncVAT := accsdatamodule.InvoiceReportTable['TotalIncVAT'];
                Val(SVat,VAT,Code);
                //If SVat[1] = '-' then VAT := VAT * -1;
                //VAT := VAT / 100;
                Val(SEach,Each,Code);
                //If SEach[1] = '-' then Each := Each * -1;
                //Each := Each / 100;
                Val(STotalExcVAT,TotalExcVAT,Code);
                If STotalExcVAT[1] = '-' then TotalExcVAT := TotalExcVAT * -1;
                //TotalExcVAT := TotalExcVAT / 100;
                Val(STotalIncVAT,TotalIncVAT,Code);
                //If STotalIncVAT[1] = '-' then TotalIncVAT := TotalIncVAT * -1;
                //TotalIncVAT := TotalIncVAT / 100;

                try
                   if Cash11.xSaveAsEuro then begin
                        VAT:=VAT* Cash11.xEuroConverter;
                        Each:=Each* Cash11.xEuroConverter;
                        TotalExcVAT:=TotalExcVAT* Cash11.xEuroConverter;
                        TotalIncVAT:=TotalIncVAT* Cash11.xEuroConverter;
                   end else begin
                        VAT:=VAT/ Cash11.xEuroConverter;
                        Each:=Each / Cash11.xEuroConverter;
                        TotalExcVAT:=TotalExcVAT / Cash11.xEuroConverter;
                        TotalIncVAT:=TotalIncVAT / Cash11.xEuroConverter;
                   end;
                Str(VAT:5:2,SVAT);
                //if Vat < 0 then SVat := SVat;
                Str(Each:5:2,SEach);
                //if Each < 0 then SEach := SEach;
                Str(TotalExcVAT:8:2,STotalExcVAT);
                Str(TotalIncVAT:8:2,STotalIncVAT);
                accsdatamodule.InvoiceReportTable['Each'] := SEach;
                accsdatamodule.InvoiceReportTable['TotalExcVAT'] := STotalExcVAT;
                accsdatamodule.InvoiceReportTable['VAT'] := SVAT;
                accsdatamodule.InvoiceReportTable['TotalIncVAT'] := STotalIncVAT;
                except
                end;
                accsdatamodule.InvoiceReportTable.post;
            end; // if
                if i <> accsdatamodule.invoiceReportTable.recordcount then  accsDataModule.InvoiceReportTable.next;
                end;
            InvoiceReportForm.EuroLabel.Caption:='All amounts shown in Euros.';
     end; // if i =1 to ..

     {AccsDataModule.InvoiceReportTable.refresh;
     with AccsDataModule.InvoiceVatQuery do begin
            Active := False;
            sql.clear;
            sql.add('select max(vatrate) as vatrate, sum(cast (totalexcvat as numeric)) as amount, sum(cast (vat as numeric)) as vat ');
            sql.add('from "C:\kingsacc\invoicereport.db"');
            sql.add('group by vatrate');
            execsql;
            active := true;
     end;
     InvoiceReportForm.VatRateTable.lines.Clear;
     InvoiceReportForm.VatRateTable.Lines.add('Rate');
     InvoiceReportForm.AmountTable.lines.Clear;
     InvoiceReportForm.AmountTable.Lines.add('Amount');
     InvoiceReportForm.VatTable.lines.Clear;
     InvoiceReportForm.VatTable.Lines.add('Vat Amount');
     AccsDataModule.InvoiceVatQuery.first;

     for k := 1 to AccsDataModule.InvoiceVatQuery.RecordCount do begin
                 InvoiceReportForm.VatRateTable.Lines.add(AccsDataModule.InvoiceVatQuery['vatrate']);
                 DoubletoStr(AccsDataModule.InvoiceVatQuery['amount'], TempStr , '%8.2f', True, False, 10, True);
                 InvoiceReportForm.AmountTable.lines.add(TempStr);
                 DoubletoStr(AccsDataModule.InvoiceVatQuery['VAT'], TempStr , '%8.2f', True, False, 10, True);
                 InvoiceReportForm.VatTable.Lines.add(Tempstr);
                 AccsDataModule.InvoiceVatQuery.next;
     end;

     AccsDataModule.InvoiceVatQuery.Close;}

     InvoiceReportForm.Print;
     end;
     If numberCopies > 2 then for i := 3 to NumberCopies do InvoiceReportForm.Print;
end;

procedure TInvoicePrintForm.btnSequenceNumbersClick(Sender: TObject);
begin
     If not Bool (SequenceNumbersForm) then Application.CreateForm(TSequenceNumbersForm, SequenceNumbersForm);
     accsdatamodule.InvoiceNumbers.open;
     SequenceNumbersForm.showmodal;
end;

procedure TInvoicePrintForm.ClearStatusPanel;
begin
   StatusBar.Panels[0].Text := '';
   StatusBar.Panels[0].PanelStyle.Font.Color := clWindowText;
   Update;
   Application.ProcessMessages;
end;

procedure TInvoicePrintForm.UpdateStatusPanel(const AText: string;
  const AColor : TColor);
begin
   StatusBar.Panels[0].Text := AText;
   StatusBar.Panels[0].PanelStyle.Font.Color := AColor;
   Update;
   Application.ProcessMessages;
end;

procedure TInvoicePrintForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Clear();
   if (FEntityInfo <> nil) then
      FreeAndNil(FEntityInfo);
end;

procedure TInvoicePrintForm.Clear;
begin
   EntityId := 0;
   InvoiceType := '';
   InvoiceNumber := '';
end;

procedure TInvoicePrintForm.ClearTimerTimer(Sender: TObject);
begin
   ClearTimer.Enabled := False;
   UpdateStatusPanel('');
end;

procedure TInvoicePrintForm.actCloseExecute(Sender: TObject);
begin
   Close;
end;



end.
