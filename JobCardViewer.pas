{
   09/04/18 [V5.7 R8.7] /MK Additional Feature - cxGridTableViewImportPropertiesButtonClick - Allow for more than 30 chars to be brought in from the JobCard App. 
}

unit JobCardViewer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGrid, cxContainer, cxEdit,
  cxGroupBox, ExtCtrls, cxLabel, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, Types, dxStatusBar, StdCtrls, cxButtons,
  dxBarExtItems, dxBar, dxPSCore, dxPScxCommon, dxPScxGridLnk, cxMemo,
  cxDBEdit, uAccounts, MSXML2_TLB, ComObj;

type
  TJobCardViewerForm = class(TForm)
    ViewPanel: TPanel;
    ViewTypeCombo: TcxComboBox;
    cxLabel1: TcxLabel;
    cxGrid: TcxGrid;
    cxGridTableView: TcxGridTableView;
    cxGridTableViewImport: TcxGridColumn;
    cxGridTableViewImportedOn: TcxGridColumn;
    cxGridTableViewOperator: TcxGridColumn;
    cxGridTableViewActivity: TcxGridColumn;
    cxGridTableViewUnitAndQuantity: TcxGridColumn;
    cxGridTableViewComment: TcxGridColumn;
    cxGridTableViewStartDateTime: TcxGridColumn;
    cxGridTableViewFinishDateTime: TcxGridColumn;
    cxGridTableViewUploadDate: TcxGridColumn;
    cxGridTableViewClientJobCardId: TcxGridColumn;
    cxGridTableViewActivityId: TcxGridColumn;
    cxGridTableViewQuantity: TcxGridColumn;
    cxGridLevel: TcxGridLevel;
    StatusBar: TdxStatusBar;
    dxBarManager1: TdxBarManager;
    blbClose: TdxBarLargeButton;
    BarControlContainerItem: TdxBarControlContainerItem;
    cxGridTableViewProduct1: TcxGridColumn;
    cxGridTableViewProduct1Id: TcxGridColumn;
    blbPrint: TdxBarLargeButton;
    ComponentPrinter: TdxComponentPrinter;
    GridPrinterLink: TdxGridReportLink;
    cxGroupBox1: TcxGroupBox;
    CommentMemo: TcxMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label45: TLabel;
    StartedOnDateLabel: TLabel;
    FinishedOnDateLabel: TLabel;
    UploadedDateLabel: TLabel;
    cxGridTableViewJobReference: TcxGridColumn;
    cxGridTableViewJobCardId: TcxGridColumn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cxGridTableViewImportPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ViewTypeComboPropertiesEditValueChanged(Sender: TObject);
    function SendData(const copyDataStruct: TCopyDataStruct) : Boolean;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure blbCloseClick(Sender: TObject);
    procedure blbPrintClick(Sender: TObject);
    procedure cxGridTableViewFocusedRecordChanged(
      Sender: TcxCustomGridTableView; APrevFocusedRecord,
      AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  private
    { Private declarations }
    FCustomerId : Integer;
    FViewType : TJobCardViewType;
    FFormShowing : Boolean;
    FNominalProductRelationship : string;
    function LoadJobs() : Boolean;overload;
    procedure DefaultHandler(var Message); override;
    function GetJobCardScreenHandle : Hwnd;
    function CalcGridColumnsWidth : Integer;
    procedure LoadCommentToMemo();
    procedure SyncCustomerName(AJobCard : TAppJobCard);
  public
    { Public declarations }
    class function LoadJobs(const ACustomerName : string; const ACustomerId : Integer;
        const AFormPosition : TPoint; const AViewType : TJobCardViewType = vtToBeImported) : TObject;overload;
  end;

var
  JobCardViewerForm: TJobCardViewerForm;

const
  cNoJobsAvailable    = 'This customer has no previous jobs on file.';
  cNoNewJobsAvailable = 'There are no new jobs available to import for this customer.'+ cCRLFx2 +
                             'Do you want to review previous jobs?';

implementation
uses
   AccsData, cxLookAndFeels, uAccsMessages, SystemDefinition, DBGen;

{$R *.DFM}

{ TJobCardViewerForm }

class function TJobCardViewerForm.LoadJobs(const ACustomerName : string;
    const ACustomerId : Integer;
    const AFormPosition : TPoint;
    const AViewType : TJobCardViewType) : TObject;
begin

   Application.ProcessMessages;
   if (AccsDataModule.JobCardXmlDocument = nil) then Exit;

   with TJobCardViewerForm.Create(nil) do
      try
         Caption := 'Job Items for ' + ACustomerName;
         FCustomerId := ACustomerId;
         FViewType := AViewType;

         Left := AFormPosition.x;
         Top := AFormPosition.y;


         ViewTypeCombo.ItemIndex := 0;
         if LoadJobs() then
            ShowModal
         else if ( FViewType = vtToBeImported ) then
            begin
               if MessageDlg(cNoNewJobsAvailable,mtConfirmation,[mbYes,mbNo],0) = idYes then
                   begin
                      ViewTypeCombo.ItemIndex := 1;
                      FViewType := vtImported;
                      if LoadJobs() then
                         ShowModal
                      else
                         MessageDlg(cNoJobsAvailable,mtInformation,[mbOK],0)
                   end;
             end
          else
             MessageDlg(cNoJobsAvailable,mtInformation,[mbOK],0)
      finally
         Free;
      end;
end;

function TJobCardViewerForm.LoadJobs() : Boolean;
var
   i : Integer;
   JobCards : TAppJobCards;
   JobCard : TAppJobCard;
begin
   Result := False;

   Screen.Cursor := crHourGlass;

   cxGridTableView.DataController.RecordCount := 0;
   try
      cxGridTableViewImportedOn.Visible := FViewType = vtImported;

      Application.ProcessMessages;

      StatusBar.Panels[0].PanelStyle.Font.Color := clRed;
      StatusBar.Panels[0].Text := 'Loading Jobs, please wait...';
      Update;

      JobCards := AccsDataModule.GetAppJobCards(FCustomerId, FViewType);

      if ((not Assigned(JobCards)) or (JobCards.Count = 0)) then
         begin
            StatusBar.Panels[0].Text := '';
            Exit;
         end;

      Result := True;

      cxGridTableView.DataController.BeginFullUpdate;
      try
         cxGridTableView.DataController.RecordCount := JobCards.Count;
         for i := 0 to JobCards.Count-1 do
            begin
               Application.ProcessMessages;

               JobCard := JobCards[i];

               cxGridTableView.DataController.Values[i, cxGridTableViewJobCardId.Index] := JobCard.JobCardId;

               cxGridTableView.DataController.Values[i, cxGridTableViewOperator.Index] := JobCard.Operator.Name;

               cxGridTableView.DataController.Values[i, cxGridTableViewActivityId.Index] := JobCard.Activity.Id;
               cxGridTableView.DataController.Values[i, cxGridTableViewActivity.Index] := JobCard.Activity.Name;
               cxGridTableView.DataController.Values[i, cxGridTableViewProduct1Id.Index] := JobCard.Product1.Id;
               cxGridTableView.DataController.Values[i, cxGridTableViewProduct1.Index] := JobCard.Product1.Name;

               cxGridTableView.DataController.Values[i, cxGridTableViewQuantity.Index]
                   := JobCard.Quantity;

               cxGridTableView.DataController.Values[i, cxGridTableViewUnitAndQuantity.Index]
                  := JobCard.UnitAndQuantityAsString;

               cxGridTableView.DataController.Values[i, cxGridTableViewStartDateTime.Index]
                  := JobCard.StartDateTime;

               cxGridTableView.DataController.Values[i, cxGridTableViewFinishDateTime.Index]
                  := JobCard.FinishDateTime;

               cxGridTableView.DataController.Values[i, cxGridTableViewComment.Index]
                  := JobCard.Comment;

               cxGridTableView.DataController.Values[i, cxGridTableViewJobReference.Index]
                  := JobCard.JobReference;

               cxGridTableView.DataController.Values[i, cxGridTableViewUploadDate.Index]
                  := JobCard.UploadDateTime;

               cxGridTableView.DataController.Values[i, cxGridTableViewClientJobCardId.Index]
                  := JobCard.ClientId;

               cxGridTableView.DataController.Values[i, cxGridTableViewImportedOn.Index]
                  := JobCard.ImportDate;

               if (i = JobCards.Count-1) then
                  begin
                     SyncCustomerName(JobCard);
                  end;
            end;

         StatusBar.Panels[0].PanelStyle.Font.Color := clWindowText;
         StatusBar.Panels[0].Text := Format('Number of Jobs: %d',[JobCards.Count]);

         PostMessage(GetJobCardScreenHandle(), WM_JOBSFOUND,0,0);

         Update;
      finally
         FreeAndNil(JobCards);

         cxGridTableView.DataController.EndFullUpdate;
         if (cxGridTableView.DataController.RecordCount>0) then
            cxGridTableView.Controller.FocusedRecordIndex := 0;
      end;
   finally
      Screen.Cursor := crDefault;
   end;
end;

procedure TJobCardViewerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   OnShow := FormShow;
   AccsDataModule.SaveJobCardXmlDocument();
end;

procedure TJobCardViewerForm.cxGridTableViewImportPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var
   JobCardId, i, j : Integer;
   ClientId,
   stringToSend,
   sComment,
   sPartComment : String;
   copyDataStruct : TCopyDataStruct;
   JobCardRecord : TJobCardRecord;
   AlreadyImported : Boolean;
   Stamp : TDateTime;
begin
   AlreadyImported := VarToDateTime(cxGridTableView.DataController.Values[
                         cxGridTableView.DataController.FocusedRecordIndex,
                         cxGridTableViewImportedOn.Index]) > 0;

   if (AlreadyImported) then
      begin

         if MessageDlgPos('This job has already been imported, do you wish to import it again?',
                        mtWarning,[mbYes,mbNo],0, Left +10, Top + 50) = idNo then Exit;
      end;

   JobCardId := cxGridTableView.DataController.Values[
                  cxGridTableView.DataController.FocusedRecordIndex,
                  cxGridTableViewJobCardId.Index];

   ClientId := cxGridTableView.DataController.Values[
             cxGridTableView.DataController.FocusedRecordIndex,
             cxGridTableViewClientJobCardId.Index];

   JobCardRecord.NominalId := StrToInt( cxGridTableView.DataController.Values[
             cxGridTableView.DataController.FocusedRecordIndex,
             cxGridTableViewActivityId.Index] );

   JobCardRecord.NominalDescription := cxGridTableView.DataController.Values[
             cxGridTableView.DataController.FocusedRecordIndex,
             cxGridTableViewActivity.Index];

   JobCardRecord.Quantity := StrToFloat( cxGridTableView.DataController.Values[
             cxGridTableView.DataController.FocusedRecordIndex,
             cxGridTableViewQuantity.Index] );

   JobCardRecord.ProductId := StrToInt(cxGridTableView.DataController.Values[
             cxGridTableView.DataController.FocusedRecordIndex,
             cxGridTableViewProduct1Id.Index]);

   JobCardRecord.JobDate := StrToDateTime(cxGridTableView.DataController.Values[
             cxGridTableView.DataController.FocusedRecordIndex,
             cxGridTableViewFinishDateTime.Index]);

   sComment := cxGridTableView.DataController.Values[cxGridTableView.DataController.FocusedRecordIndex,
                                                     cxGridTableViewComment.Index];

   //   09/04/18 [V4.3 R0.6] /MK Additional Feature - Allow for more than 30 chars to be brought in from the JobCard App.
   if ( Length(sComment) > 0 ) then
      begin
         sPartComment := Copy(Trim(sComment),1,30);
         JobCardRecord.Comment1 := sPartComment;
         Delete(sComment,1,30);
         sPartComment := Copy(Trim(sComment),1,30);
         JobCardRecord.Comment2 := sPartComment;
      end;

   JobCardRecord.JobReference := Copy( cxGridTableView.DataController.Values[
             cxGridTableView.DataController.FocusedRecordIndex,
             cxGridTableViewJobReference.Index], 1, 20);

   copyDataStruct.dwData := KINGSWOOD_ACCOUNTS_POSTJOBTOJOBCARDSCREEN;
   copyDataStruct.cbData := SizeOf(JobCardRecord);
   copyDataStruct.lpData := @JobCardRecord;

   if ( SendData(copyDataStruct) ) then
      begin
         Stamp := Now();
         AccsDataModule.AddToImportedJobCards(JobCardId);
         if ((AccsDataModule.MarkJobCardAsSeen(ClientId,Stamp)) and (FViewType = vtToBeImported)) then
            begin
               cxGridTableView.DataController.Values[
                         cxGridTableView.DataController.FocusedRecordIndex,
                         cxGridTableViewImportedOn.Index] := Stamp;

               PostMessage(Handle, WM_REMOVERJOBCARDECORD,0,0);
            end;
      end;
end;

procedure TJobCardViewerForm.ViewTypeComboPropertiesEditValueChanged(
  Sender: TObject);
begin
   if not (FFormShowing) then Exit;

   FViewType := TJobCardViewType(ViewTypeCombo.ItemIndex);
   LoadJobs();
end;

procedure TJobCardViewerForm.DefaultHandler(var Message);
begin
  inherited;
  with TMessage(Message) do
    begin
      if (Msg = WM_REMOVERJOBCARDECORD) then
         begin
            cxGridTableView.DataController.DeleteRecord(cxGridTableView.DataController.FocusedRecordIndex);

            if (cxGridTableView.DataController.RecordCount <=0) then
               try
                  Close;
               except
               end;
         end
    end;
end;

function TJobCardViewerForm.SendData(const copyDataStruct: TCopyDataStruct) : Boolean;
var
   ReceiverHandle : THandle;
begin
   ReceiverHandle := GetJobCardScreenHandle();
   if (ReceiverHandle = 0) then
      begin
         MessageDlg('Could not send data to Job Card screen.',mtError,[mbOK],0);
         Exit;
      end;

   Result := SendMessage(ReceiverHandle, WM_COPYDATA, Integer(Handle), Integer(@copyDataStruct)) = 1;
end;

procedure TJobCardViewerForm.FormShow(Sender: TObject);
begin
   OnShow := nil;

   FNominalProductRelationship := GetNomProdRelationship(AccsDataModule.CurrentDatabasePath);
   if ( FNominalProductRelationship = cNomProdRelationship_OnetoOne) then
      begin
         cxGridTableViewProduct1.Visible := False;
      end;
end;

function TJobCardViewerForm.GetJobCardScreenHandle: Hwnd;
begin
   Result := FindWindow(PChar('TCashBookForm'), PChar('Job Cards'));
end;

procedure TJobCardViewerForm.FormCreate(Sender: TObject);
var
   GridWidth : Integer;
begin
   FFormShowing := False;

   cxGrid.LookAndFeel.NativeStyle := False;
   cxGrid.LookAndFeel.Kind := lfFlat;
   ViewTypeCombo.Style.LookAndFeel.NativeStyle := False;
   ViewTypeCombo.Style.LookAndFeel.Kind := lfFlat;

   Width := Screen.Width - (Left + 15);
   GridWidth := CalcGridColumnsWidth() + 45;
   if (Width > GridWidth) then
      Width := GridWidth;

   BarControlContainerItem.Control := ViewPanel;
   ViewPanel.Font.Name := 'Segoe UI';
   ViewTypeCombo.Style.Font.Name :=  ViewPanel.Font.Name;
   cxLabel1.Style.Font.Name :=  ViewPanel.Font.Name;

   CommentMemo.Lines.Clear;

   StartedOnDateLabel.Caption := '';
   FinishedOnDateLabel.Caption := '';
   UploadedDateLabel.Caption := '';
end;

procedure TJobCardViewerForm.FormActivate(Sender: TObject);
begin
   FFormShowing := True;
end;

procedure TJobCardViewerForm.blbCloseClick(Sender: TObject);
begin
   Close;
end;

function TJobCardViewerForm.CalcGridColumnsWidth: Integer;
var
   i : Integer;
begin
   Result := 0;
   for i := 0 to cxGridTableView.ColumnCount-1 do
      if cxGridTableView.Columns[i].Visible then
         Result := Result + cxGridTableView.Columns[i].Width;
end;

procedure TJobCardViewerForm.blbPrintClick(Sender: TObject);
begin
   GridPrinterLink.ReportTitle.Text := Caption;
   if not (GridPrinterLink.PreviewExists) then
      GridPrinterLink.Preview;
end;

procedure TJobCardViewerForm.cxGridTableViewFocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  CommentMemo.Lines.Clear;
  if (AFocusedRecord=nil) then Exit;

  CommentMemo.Text := AFocusedRecord.Values[cxGridTableViewComment.Index];

  StartedOnDateLabel.Caption := AFocusedRecord.Values[cxGridTableViewStartDateTime.Index];
  FinishedOnDateLabel.Caption := AFocusedRecord.Values[cxGridTableViewFinishDateTime.Index];
  UploadedDateLabel.Caption := AFocusedRecord.Values[cxGridTableViewUploadDate.Index];
end;

procedure TJobCardViewerForm.LoadCommentToMemo;
begin
   CommentMemo.Text :=
                    cxGridTableView.DataController.Values[
                    cxGridTableView.DataController.FocusedRecordIndex,
                    cxGridTableViewComment.Index];
end;

procedure TJobCardViewerForm.SyncCustomerName(AJobCard: TAppJobCard);
begin
   AccsDataModule.UpdateCustomerName(FCustomerId, AJobCard.Customer.Name);
end;

initialization
   KINGSWOOD_ACCOUNTS_POSTJOBTOJOBCARDSCREEN := RegisterWindowMessage('KINGSWOOD_ACCOUNTS_POSTJOBTOJOBCARDSCREEN');

end.
