unit uJobCardCustomerListing;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, cxButtons, ExtCtrls, cxGridCustomTableView, cxGridTableView,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView, cxGrid,
  MSXML2_TLB, ComObj, ShellAPI;

type
  TfmJobCardCustomerListing = class(TForm)
    Panel1: TPanel;
    cxGrid: TcxGrid;
    cxGridTableView: TcxGridTableView;
    cxGridTableViewId: TcxGridColumn;
    cxGridTableViewName: TcxGridColumn;
    cxGridTableViewPendingJobCount: TcxGridColumn;
    cxGridTableViewMostRecentJob: TcxGridColumn;
    cxGridLevel: TcxGridLevel;
    Panel2: TPanel;
    btnSelect: TcxButton;
    btnCancel: TcxButton;
    ChoseAnotherButton: TcxButton;
    procedure btnSelectClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cxGridTableViewDblClick(Sender: TObject);
    procedure ChoseAnotherButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FSelectedCustomer : Integer;
    function LoadCustomers() : Boolean;
    procedure AddCustomerToGrid(ACustomerId, ACustomerName : string; AFinishDate : string);
  public
    { Public declarations }
    class function SelectCustomer : Integer;
  end;

var
  fmJobCardCustomerListing: TfmJobCardCustomerListing;

implementation

uses AccsData;

{$R *.DFM}

{ TfmJobCardCustomerListing }

function TfmJobCardCustomerListing.LoadCustomers() : Boolean;
var
   QueryString : string;
   i, j : Integer;
   FJobNodes : IXMLDOMNodeList;
   JobNode, ChildNode, Node : IXMLDOMNode;
   Id, Name, FinishDate : string;
begin
   Result := False;

   Screen.Cursor := crHourGlass;
   try
      if (AccsDataModule.JobCardXmlDocument = nil) then Exit;

      QueryString := './jobCard[importedOn = ""]';
      FJobNodes := AccsDataModule.JobCardXmlDocument.documentElement
                                                    .selectNodes(QueryString);

      if ((not Assigned(FJobNodes)) or (FJobNodes.length = 0)) then Exit;

      cxGridTableView.DataController.BeginFullUpdate;
      try
         for i := 0 to FJobNodes.Length-1 do
            begin
               Id := '';
               Name  := '';
               FinishDate := '';

               Application.ProcessMessages;

               JobNode := FJobNodes.item[i];

               Node := JobNode.selectSingleNode('customer');
               if Assigned(Node) then
                  begin
                     ChildNode := Node.selectSingleNode('id');
                     if Assigned(ChildNode) then
                        Id := ChildNode.text;
                     ChildNode := Node.selectSingleNode('name');
                     if Assigned(ChildNode) then
                        Name := ChildNode.text;

                     Node := JobNode.selectSingleNode('finishDate');
                     if Assigned(Node) then
                        FinishDate := Node.text;

                     AddCustomerToGrid(Id,Name,FinishDate);
                  end;
            end;
         Result := cxGridTableView.DataController.RecordCount>0;
      finally
         cxGridTableView.DataController.EndFullUpdate;
         JobNode := nil;
         ChildNode := nil;
         Node := nil;
      end;
   finally
      Screen.Cursor := crDefault;
   end;
end;

class function TfmJobCardCustomerListing.SelectCustomer: Integer;
begin
   Result := -1;
   with TfmJobCardCustomerListing.Create(nil) do
      try
         if not (LoadCustomers) then Exit;

         ShowModal;

         Result := FSelectedCustomer;
      finally
         Free;
      end;
end;

procedure TfmJobCardCustomerListing.btnSelectClick(Sender: TObject);
var
   Id : string;
begin
   if (cxGridTableView.DataController.FocusedRecordIndex<0) then
      begin
         MessageDlg('Please select a customer',mtInformation,[mbOK],0); 
         Exit;
      end;
      
   Id := cxGridTableView.DataController.Values[
             cxGridTableView.DataController.FocusedRecordIndex,
             cxGridTableViewId.Index];

   FSelectedCustomer := StrToInt(Id);
   Close;
end;

procedure TfmJobCardCustomerListing.btnCancelClick(Sender: TObject);
begin
   FSelectedCustomer := 0;
   Close;
end;

procedure TfmJobCardCustomerListing.cxGridTableViewDblClick(
  Sender: TObject);
begin
   btnSelectClick(nil);
end;

procedure TfmJobCardCustomerListing.AddCustomerToGrid(ACustomerId, ACustomerName,
  AFinishDate: string);
var
   i : Integer;
   IsFound  : Boolean;
   FinishDate : TDateTime;
   Controller : TcxGridDataController;
begin
   IsFound := False;
   Controller := cxGridTableView.DataController;
   try
      FinishDate := StrToDateTime(AFinishDate);
      for i := 0 to Controller.RecordCount-1 do
      begin
         if (Controller.Values[i, cxGridTableViewId.Index] = ACustomerId) then
            begin
               IsFound := True;

                if (VarIsNull(Controller.Values[i, cxGridTableViewMostRecentJob.Index])) or
                   (FinishDate > Controller.Values[i, cxGridTableViewMostRecentJob.Index]) then
                   begin
                      Controller.Values[i, cxGridTableViewMostRecentJob.Index] := FinishDate;
                   end;
                Controller.Values[i, cxGridTableViewPendingJobCount.Index] :=
                 Controller.Values[i, cxGridTableViewPendingJobCount.Index] + 1;
            end;
      end;

      if not IsFound then
         begin
            Controller.RecordCount := Controller.RecordCount+1;
            Controller.Values[Controller.RecordCount-1, cxGridTableViewId.Index] := ACustomerId;
            Controller.Values[Controller.RecordCount-1, cxGridTableViewName.Index] := ACustomerName;
            Controller.Values[Controller.RecordCount-1, cxGridTableViewPendingJobCount.Index] := 1;
            Controller.Values[Controller.RecordCount-1, cxGridTableViewMostRecentJob.Index] := FinishDate;
         end;
   except

   end;
end;

procedure TfmJobCardCustomerListing.ChoseAnotherButtonClick(Sender: TObject);
begin
   FSelectedCustomer := -1;
   Close;
end;

procedure TfmJobCardCustomerListing.FormCreate(Sender: TObject);
begin
   FSelectedCustomer := -1;
end;

end.
