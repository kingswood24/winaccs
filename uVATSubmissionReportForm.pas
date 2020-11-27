{

Ch006 - New unit created for UK Digital VAT returns

   27/08/19 [V5.9 R0.1] /MK Change - Added a ShowTheForm class procedure that creates and free's form instead of calling form doing it.
                                   - Added a new type, TViewType, that allows ShowTheForm to change Position of the form depending where it is being called from.

   28/08/19 [V5.9 R0.1] /MK Change - Added ActionList with actRun and actExit actions.
                                   - actRun.Enabled if VatReportQuery.RecordCount > 0.                                    
}

unit uVATSubmissionReportForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, RxLookup, Db, DBTables, ActnList;

type
  TViewType = (vtFromReports, vtFromDigVatRet);

  TVATSubmissionReportForm = class(TForm)
    Panel3: TPanel;
    Exitbtn: TBitBtn;
    ReportLookup: TRxDBLookupCombo;
    Run: TBitBtn;
    ReportLabel: TLabel;
    VATReportQuery: TQuery;
    DSVATReportQuery: TDataSource;
    SummaryCB: TCheckBox;
    AuditCB: TCheckBox;
    ActionList1: TActionList;
    actExit: TAction;
    actRun: TAction;
    procedure FormCreate(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actRunExecute(Sender: TObject);
    procedure actRunUpdate(Sender: TObject);
  private
    { Private declarations }
    FViewType : TViewType;
  public
    { Public declarations }
    class procedure ShowTheForm ( AViewType : TViewType );
  end;

var
  VATSubmissionReportForm: TVATSubmissionReportForm;

implementation

uses
   AccsData, Vars, uDigitalVATForm, uNIVatReport, Types, Calcs,
   uVatAuditReport, uVatReport, clears;

{$R *.DFM}

class procedure TVATSubmissionReportForm.ShowTheForm(AViewType: TViewType);
begin
   with TVATSubmissionReportForm.Create(nil) do
      try
         if ( AViewType = vtFromDigVatRet ) then
            begin
               Position := poDesigned;
               left := DigitalVATForm.left;
               top := DigitalVATForm.top;
            end
         else
            Position := poDesktopCenter;
         ShowModal;
      finally
         Free;
      end;
end;

procedure TVATSubmissionReportForm.FormCreate(Sender: TObject);
begin
   if ( Cash2.xCountry = 2 ) then
      begin
         VATSubmissionReportForm.Caption := 'View Closed Period Reports';
         ReportLabel.Caption := 'Select VAT Period End Date';
         SummaryCB.caption := 'Display Summary Report';
      end
   else
      begin
         VATSubmissionReportForm.Caption := 'Digital VAT Return Report';
         ReportLabel.Caption := 'Select VAT Submission';
         SummaryCB.caption := 'Display VAT Return Report';
      end;

   VATReportQuery.DatabaseName := accsdatamodule.AccsDataBase.databasename;
   VATReportQuery.SQL.clear;
   if ( Cash2.xCountry = 2 ) then
      VATReportQuery.SQL.Add('Select * from VATReturn where FinYear = "' + IntToStr(Cash1.xfinYear) + '"'+ ' and IRLReturn = "True"')
   else
      VATReportQuery.SQL.Add('Select * from VATReturn where FinYear = "' + IntToStr(Cash1.xfinYear) + '"' + ' and UKReturn = "True" and SubmissionComplete = "True"');
   VATReportQuery.open;
end;

procedure TVATSubmissionReportForm.actExitExecute(Sender: TObject);
begin
   Close;
end;

procedure TVATSubmissionReportForm.actRunExecute(Sender: TObject);
var
        st : shortstring;
        MYQuery : TQuery;
        I : Integer;
        Salesrunningnet, Salesrunningvat, Purchrunningnet, Purchrunningvat : Real;
begin
        if ((AuditCB.Checked = False) and (SummaryCB.Checked = False)) then begin
            showmessage('Please Select Some Reports to Display');
            exit;
        end;

        If ( Cash2.xCountry = 2 ) Then begin

                          AccsDataModule.VATTotalsArchiveDB.close;
                          AccsDataModule.VATTotalsArchiveDB.Filter := 'ReturnID =''' +ReportLookup.KeyValue + '''';
                          AccsDataModule.VATTotalsArchiveDB.Filtered := True;
                          AccsDataModule.VATTotalsArchiveDB.open;

                          AccsDataModule.VATTotalsArchiveDB.first;

                        if SummaryCB.Checked = True then begin

                                if not bool(VatReport) then Application.CreateForm(TVatReport, VatReport);

                                VatReport.SalesVatCodes.Lines.Clear;
                                VatReport.SalesVatRates.Lines.Clear;
                                VatReport.SalesNetAmounts.Lines.Clear;
                                VatReport.SalesVatAmounts.Lines.Clear;
                                VatReport.PurchVatCodes.Lines.Clear;
                                VatReport.PurchVatRates.Lines.Clear;
                                VatReport.PurchNetAmounts.Lines.Clear;
                                VatReport.PurchVatAmounts.Lines.Clear;

                                Salesrunningnet := 0;
                                Salesrunningvat := 0;
                                Purchrunningnet := 0;
                                Purchrunningvat := 0;



                                for I:= 0 to 9 do Begin

                                        try VatReport.SalesVatCodes.Lines.add(AccsDataModule.VATTotalsArchiveDB['VATCode']);
                                        except VatReport.SalesVatCodes.Lines.add('');
                                        end;
                                        VatReport.SalesVatRates.Lines.add(AccsDataModule.VATTotalsArchiveDB['VATRate']);
                                        st := '';
                                        DoubleToStr (AccsDataModule.VATTotalsArchiveDB['SalesNetAmount'],st,'%8.2f', true, false, 20, True);
                                        slimleft (st);
                                        VatReport.SalesNetAmounts.Lines.add(st);
                                        st := '';
                                        DoubleToStr (AccsDataModule.VATTotalsArchiveDB['SalesVATAmount'],st,'%8.2f', true, false, 20, True);
                                        slimleft (st);
                                        VatReport.SalesVatAmounts.Lines.add(st);
                                        SalesRunningnet := SalesRunningnet + AccsDataModule.VATTotalsArchiveDB['SalesNetAmount'];
                                        SalesRunningvat := SalesRunningvat + AccsDataModule.VATTotalsArchiveDB['SalesVATAmount'];

                                        try VatReport.PurchVatCodes.Lines.add(AccsDataModule.VATTotalsArchiveDB['VATCode']);
                                        except VatReport.PurchVatCodes.Lines.add('');
                                        end;

                                        VatReport.PurchVatRates.Lines.add(AccsDataModule.VATTotalsArchiveDB['VATRate']);
                                        st := '';
                                        DoubleToStr (AccsDataModule.VATTotalsArchiveDB['PurchNetAmount'],st,'%8.2f', true, false, 20, True);
                                        slimleft (st);
                                        VatReport.PurchNetAmounts.Lines.add(st);
                                        st := '';
                                        DoubleToStr (AccsDataModule.VATTotalsArchiveDB['PurchVATAmount'],st,'%8.2f', true, false, 20, True);
                                        slimleft (st);
                                        VatReport.PurchVatAmounts.Lines.add(st);
                                        PurchRunningnet := PurchRunningnet + AccsDataModule.VATTotalsArchiveDB['PurchNetAmount'];
                                        PurchRunningvat := PurchRunningvat + AccsDataModule.VATTotalsArchiveDB['PurchVATAmount'];

                                        AccsDataModule.VATTotalsArchiveDB.next;
                                End ;

                                st := '';
                                DoubleToStr (SalesRunningnet,st,'%8.2f', true, false, 20, True);
                                slimleft (st);
                                VatReport.SalesTotalNet.Caption := st;
                                st := '';
                                DoubleToStr (SalesRunningvat,st,'%8.2f', true, false, 20, True);
                                slimleft (st);
                                VatReport.SalesTotalVat.Caption := st;

                                st := '';
                                DoubleToStr (PurchRunningnet,st,'%8.2f', true, false, 20, True);
                                slimleft (st);
                                VatReport.PurchTotalNet.Caption := st;
                                st := '';
                                DoubleToStr (PurchRunningvat,st,'%8.2f', true, false, 20, True);
                                slimleft (st);
                                VatReport.PurchTotalVat.Caption := st;
                                (*
        // Purchases

        runningnet := 0;
        runningvat := 0;

        VatReport.PurchVatCodes.Lines.Clear;
        VatReport.PurchVatRates.Lines.Clear;
        VatReport.PurchNetAmounts.Lines.Clear;
        VatReport.PurchVatAmounts.Lines.Clear;
        for I:= 0 to 9 do Begin
                       VatReport.PurchVatCodes.Lines.add(DigitalVAT.VATCodeArray[i].VatCode);
                       VatReport.PurchVatRates.Lines.add(DigitalVAT.VATCodeArray[i].VatRate);
                       st := '';
                       DoubleToStr (DigitalVAT.VATCodeArray[i].PurchNet,st,'%8.2f', true, false, 20, True);
                       slimleft (st);
                       VatReport.PurchNetAmounts.Lines.add(st);
                       st := '';
                       DoubleToStr (DigitalVAT.VATCodeArray[i].PurchVat,st,'%8.2f', true, false, 20, True);
                       slimleft (st);
                       VatReport.PurchVatAmounts.Lines.add(st);
                       Runningnet := Runningnet + DigitalVAT.VATCodeArray[i].PurchNet;
                       Runningvat := Runningvat + DigitalVAT.VATCodeArray[i].PurchVat;
        End ;
        st := '';
        DoubleToStr (Runningnet,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        VatReport.PurchTotalNet.Caption := st;
        st := '';
        DoubleToStr (Runningvat,st,'%8.2f', true, false, 20, True);
        slimleft (st);
        VatReport.PurchTotalVat.Caption := st;

                                  *)

                                AccsDataModule.VATTotalsArchiveDB.Filtered := False;
                                AccsDataModule.VATTotalsArchiveDB.Filter := '';
                                AccsDataModule.VATTotalsArchiveDB.open;

                                VatReport.AccountsName.Caption := Cash1.XCOMPANY;
                                VatReport.KingswoodLbl.caption :=  'Kingswood Accounts ' + Verno;
                                VatReport.Range.Caption := 'VAT Period End Date - ' + ReportLookup.DisplayValue;
                                VatReport.DataSet.Caption :=  Accsdata.AccsDataModule.AccsDataBase.AliasName;

                                VatReport.Preview;


                        end;

                        if AuditCB.Checked = True then begin

                                AccsDataModule.TempVATDB.close;
                                AccsDataModule.TempVATDB.EmptyTable;
                                AccsDataModule.TempVATDB.Open;

                                MyQuery := TQuery.create(self);
                                Myquery.DatabaseName := accsdatamodule.AccsDataBase.databasename;

                                MyQuery.SQL.clear;
                                MyQuery.SQL.add ('INSERT INTO TempVAT');
                                MyQuery.SQL.add ('SELECT * FROM VATArchive where VATID =' + vartostr(ReportLookup.KeyValue));
                                MyQuery.ExecSQL;

                                MyQuery.close;
                                MyQuery.free;

                                AccsDataModule.TempVATDB.Open;

                                if not bool(VatAuditReport) then Application.CreateForm(TVatAuditReport, VatAuditReport);
                                VatAuditReport.AccountsName.Caption := Cash1.XCOMPANY;
                                VatAuditReport.KingswoodLbl.caption :=  'Kingswood Accounts ' + Verno;
                                VatAuditReport.DataSet.Caption :=  Accsdata.AccsDataModule.AccsDataBase.AliasName;
                                VatAuditReport.Range.Caption := 'VAT Period Close - ' + ReportLookup.DisplayValue;
                                VatAuditReport.Preview;
                        end;

        end
              else begin

                        Accsdatamodule.VATReturnDB.open;
                        Accsdatamodule.VATReturnDB.Locate('ReturnID',ReportLookup.KeyValue,[]);


                        if SummaryCB.Checked = True then begin

                                if not bool(NIVatReport) then Application.CreateForm(TNIVatReport, NIVatReport);

                                DoubleToStr (AccsDataModule.VATReturnDB['Box1'],st,'%8.2f', true, false, 20, True);
                                NIVatReport.Box1.Caption := st;
                                DoubleToStr (AccsDataModule.VATReturnDB['Box2'],st,'%8.2f', true, false, 20, True);
                                NIVatReport.Box2.Caption := st;
                                DoubleToStr (AccsDataModule.VATReturnDB['Box3'],st,'%8.2f', true, false, 20, True);
                                NIVatReport.Box3.Caption := st;
                                DoubleToStr (AccsDataModule.VATReturnDB['Box4'],st,'%8.2f', true, false, 20, True);
                                NIVatReport.Box4.Caption := st;
                                DoubleToStr (AccsDataModule.VATReturnDB['Box5'],st,'%8.2f', true, false, 20, True);
                                NIVatReport.Box5.Caption := st;
                                DoubleToStr (AccsDataModule.VATReturnDB['Box6'],st,'%8.2f', true, false, 20, True);
                                NIVatReport.Box6.Caption := st;
                                DoubleToStr (AccsDataModule.VATReturnDB['Box7'],st,'%8.2f', true, false, 20, True);
                                NIVatReport.Box7.Caption := st;
                                DoubleToStr (AccsDataModule.VATReturnDB['Box8'],st,'%8.2f', true, false, 20, True);
                                NIVatReport.Box8.Caption := st;
                                DoubleToStr (AccsDataModule.VATReturnDB['Box9'],st,'%8.2f', true, false, 20, True);
                                NIVatReport.Box9.Caption := st;

                                if AccsDataModule.VATReturnDB['Box3'] > AccsDataModule.VATReturnDB['Box4'] then NIVatReport.Comment.Caption := 'Payable'
                                        else NIVatReport.Comment.Caption := 'Repayable';

                                NIVatReport.AccountsName.Caption := Cash1.XCOMPANY;
                                NIVatReport.KingswoodLbl.caption :=  'Kingswood Accounts ' + Verno;
                                NIVatReport.DataSet.Caption :=  Accsdata.AccsDataModule.AccsDataBase.AliasName;
                                NIVatReport.Range.Caption := 'VAT Period - ' + ReportLookup.DisplayValue;


                                NIVatReport.CommentLabel1.Caption := 'VAT Submission Date - ' + vartostr(AccsDataModule.VATReturnDB['SubmissionDate']);
                                NIVatReport.CommentLabel1.enabled := True;
                                NIVatReport.CommentLabel2.Caption := 'Submission Confirmation - ' + vartostr(AccsDataModule.VATReturnDB['SubmissionReference']);
                                NIVatReport.CommentLabel2.enabled := True;

                                NIVatReport.Preview;


                        end;

                        if AuditCB.Checked = True then begin

                        AccsDataModule.TempVATDB.close;
                        AccsDataModule.TempVATDB.EmptyTable;
                        AccsDataModule.TempVATDB.Open;

                        MyQuery := TQuery.create(self);
                        Myquery.DatabaseName := accsdatamodule.AccsDataBase.databasename;

                        MyQuery.SQL.clear;
                        MyQuery.SQL.add ('INSERT INTO TempVAT');
                        MyQuery.SQL.add ('SELECT * FROM VATArchive where VATID =' + vartostr(ReportLookup.KeyValue));
                        MyQuery.ExecSQL;

                        MyQuery.close;
                        MyQuery.free;

                        AccsDataModule.TempVATDB.Open;

                        if not bool(VatAuditReport) then Application.CreateForm(TVatAuditReport, VatAuditReport);
                        VatAuditReport.AccountsName.Caption := Cash1.XCOMPANY;
                        VatAuditReport.KingswoodLbl.caption :=  'Kingswood Accounts ' + Verno;
                        VatAuditReport.DataSet.Caption :=  Accsdata.AccsDataModule.AccsDataBase.AliasName;
                        VatAuditReport.Range.Caption := 'VAT Period - ' + ReportLookup.DisplayValue;
                        VatAuditReport.Preview;


                        end;

              end;
end;

procedure TVATSubmissionReportForm.actRunUpdate(Sender: TObject);
begin
   actRun.Enabled := ( VATReportQuery.Active ) and ( VATReportQuery.RecordCount > 0 ); 
end;

end.
