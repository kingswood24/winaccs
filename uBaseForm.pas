unit uBaseForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, dxBar, dxBarExtItems, cxControls, dxStatusBar;

type
  TBaseForm = class(TForm)
    BarManager: TdxBarManager;
    blbExit: TdxBarLargeButton;
    blbView: TdxBarLargeButton;
    blbPrint: TdxBarLargeButton;
    blbHelp: TdxBarLargeButton;
    ActionList: TActionList;
    actExit: TAction;
    actView: TAction;
    actPrint: TAction;
    actHelp: TAction;
    StatusBar: TdxStatusBar;
    blbFirst: TdxBarLargeButton;
    blbNext: TdxBarLargeButton;
    blbLast: TdxBarLargeButton;
    actFirst: TAction;
    actNext: TAction;
    actPrior: TAction;
    actLast: TAction;
    actRefresh: TAction;
    actSave: TAction;
    actCancel: TAction;
    actEdit: TAction;
    actDelete: TAction;
    actAdd: TAction;
    blbPrior: TdxBarLargeButton;
    blbAdd: TdxBarLargeButton;
    blbSave: TdxBarLargeButton;
    blbEdit: TdxBarLargeButton;
    blbCancel: TdxBarLargeButton;
    blbRefesh: TdxBarLargeButton;
    blbSave2: TdxBarLargeButton;
    blbCancel2: TdxBarLargeButton;
    blbDelete2: TdxBarLargeButton;
    actSave2: TAction;
    actDelete2: TAction;
    actCancel2: TAction;
    blbImport: TdxBarLargeButton;
    actImport: TAction;
    blbSelect: TdxBarLargeButton;
    actSelect: TAction;
    blbExport: TdxBarLargeButton;
    actExport: TAction;
    procedure actExitExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  protected
    FFormShowing : Boolean;
    procedure SetupForm;dynamic;
    procedure CleanUp();dynamic;
    procedure CallHelp(AContext : Integer);
  public
    { Public declarations }
  end;

var
  BaseForm: TBaseForm;

implementation

uses AccsData, Mainunit;

{$R *.DFM}

procedure TBaseForm.actExitExecute(Sender: TObject);
begin
   Close;
end;

procedure TBaseForm.CallHelp(AContext: Integer);
begin
   Application.HelpContext(AContext);
end;

procedure TBaseForm.SetupForm;
begin
   //
end;

procedure TBaseForm.FormCreate(Sender: TObject);
begin
   {SetupForm;}
end;

procedure TBaseForm.CleanUp;
begin

end;

procedure TBaseForm.FormDestroy(Sender: TObject);
begin
   CleanUp();
end;

procedure TBaseForm.FormActivate(Sender: TObject);
begin
   FFormShowing := True;
end;

end.
