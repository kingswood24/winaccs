unit uEmailTemplates;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, cxButtons, ActnList, dxBar, dxBarExtItems, ExtCtrls,
  cxControls, cxContainer, cxEdit, cxLabel;

type
  TEmailTemplateMode = (TEditing, TSelecting);

  TEmailTemplate = class
  private
    FSubject: string;
    FBody: string;
    FAttachments : TStringList;
  public
    constructor create;
    destructor destroy;override;
    property Subject : string read FSubject write FSubject;
    property Body : string read FBody write FBody;
    property Attachments : TStringList read FAttachments write FAttachments;
  end;

  TfmEmailTemplates = class(TForm)
    dxBarManager: TdxBarManager;
    TemplatesCombo2: TdxBarCombo;
    blbClose: TdxBarLargeButton;
    dxBarSubItem1: TdxBarSubItem;
    blbAddLayout: TdxBarLargeButton;
    ActionList1: TActionList;
    actClose: TAction;
    actAddTemplate: TAction;
    actSaveTemplate: TAction;
    actCancelTemplate: TAction;
    actSelectTemplate: TAction;
    Panel1: TPanel;
    Label3: TLabel;
    TemplatesCombo: TComboBox;
    Label1: TLabel;
    SubjectEdit: TEdit;
    Label2: TLabel;
    BodyMemo: TMemo;
    pEditActions: TPanel;
    btnSaveOrSelect: TcxButton;
    btnCancel: TcxButton;
    pChooseActions: TPanel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    actCancelSelect: TAction;
    ChangesWarningLabel: TcxLabel;
    actAttachments: TAction;
    btnAttachments: TcxButton;
    procedure actAddTemplateExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure SubjectEditChange(Sender: TObject);
    procedure actSaveTemplateUpdate(Sender: TObject);
    procedure TemplatesComboChange(Sender: TObject);
    procedure actSaveTemplateExecute(Sender: TObject);
    procedure TemplatesComboDropDown(Sender: TObject);
    procedure actCancelTemplateExecute(Sender: TObject);
    procedure BodyMemoChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actSelectTemplateExecute(Sender: TObject);
    procedure actCancelSelectExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actAttachmentsExecute(Sender: TObject);
  private
    { Private declarations }
    HasChanges : Boolean;
    FMode : TEmailTemplateMode;
    FAttachments : TStringList;
    function ValidateTemplateName(const ATemplateName : string) : string;
    procedure Load();
    procedure Save();
    procedure Add();
    procedure SetEditingFlag();

  public
    { Public declarations }
    class function ShowTheForm(AMode : TEmailTemplateMode) : TEmailTemplate;
  end;

var
  fmEmailTemplates: TfmEmailTemplates;

implementation

uses AccsData, Types, uEmailAttachments;

{$R *.DFM}

class function TfmEmailTemplates.ShowTheForm(AMode : TEmailTemplateMode) : TEmailTemplate;
begin
   Result := nil;
   with TfmEmailtemplates.Create(nil) do
      try
        FMode := AMode;
        if (FMode = TEditing) then
           begin
              actAttachments.Visible := False;
              SubjectEdit.Width :=  546;
           end;

        if (ShowModal = mrOK ) and (TemplatesCombo.ItemIndex > -1) then
           begin
              Result := TEmailTemplate.Create;
              Result.Subject := SubjectEdit.Text;
              Result.Body := BodyMemo.Text;
              if (AMode = TSelecting) and (FAttachments <> nil) and (FAttachments.Count>0) then
                 Result.Attachments.AddStrings(FAttachments);
           end;
      finally
         Free;
      end;
end;

function TfmEmailTemplates.ValidateTemplateName(
  const ATemplateName: string): string;
begin
   if Length(Trim(ATemplateName)) = 0 then
      begin
         Result := 'Invalid';
         Exit;
      end;

   if AccsDataModule.EmailTemplateExists(Trim(ATemplateName)) then
      begin
         Result := 'InUse';
         Exit;
      end;

   Result := 'Ok';
end;

procedure TfmEmailTemplates.actAddTemplateExecute(Sender: TObject);
begin
   Add();
end;

procedure TfmEmailTemplates.actCloseExecute(Sender: TObject);
begin
   ModalResult := mrNone;
   Close;
end;

procedure TfmEmailTemplates.SubjectEditChange(Sender: TObject);
begin
   SetEditingFlag();
end;

procedure TfmEmailTemplates.BodyMemoChange(Sender: TObject);
begin
   SetEditingFlag();
end;

procedure TfmEmailTemplates.actSaveTemplateUpdate(Sender: TObject);
begin
   (Sender as TAction).Enabled := HasChanges;
end;

procedure TfmEmailTemplates.TemplatesComboChange(Sender: TObject);
begin
   Load();
end;

procedure TfmEmailTemplates.actSaveTemplateExecute(Sender: TObject);
begin
   Save();
end;

procedure TfmEmailTemplates.TemplatesComboDropDown(Sender: TObject);
begin
   if ( TemplatesCombo.Items.Count = 0 ) and
      ( MessageDlg('You don''t have any templates created.'
                               +#13#10+#13#10+
                   'Do you want to add a template now?',mtConfirmation,[mbYes,mbNo],0) = idYes) then
      actAddTemplate.Execute();
end;

procedure TfmEmailTemplates.actCancelTemplateExecute(Sender: TObject);
begin
   Load();
   HasChanges := False;
end;

procedure TfmEmailTemplates.Load();
var
   Subject : string;
   Body : string;
begin
   AccsDataModule.GetTemplate(TemplatesCombo.Text,Subject,Body);
   SubjectEdit.Text := Subject;
   BodyMemo.Text := Body;
   HasChanges := False;
end;

procedure TfmEmailTemplates.Save;
var
   TemplateName : string;
begin
   TemplateName := TemplatesCombo.Text;

   if AccsDataModule.UpdateTemplate(TemplateName, Trim(SubjectEdit.Text), Trim(BodyMemo.Text)) then
      begin
         if (TemplatesCombo.Items.IndexOf(TemplateName) = -1) then
            TemplatesCombo.Items.Add(TemplateName);
         HasChanges := False;
      end
   else
      MessageDlg(Format('Failed to create email template %s', [TemplateName]), mtError,[mbok],0);
end;

procedure TfmEmailTemplates.Add;
var
   TemplateName : string;
   ValidationResult : string;
begin

   TemplateName := InputBox('Create New Template','Enter Name:', '');

   ValidationResult := ValidateTemplateName(TemplateName);
   if (ValidationResult = 'Invalid') then
      begin
         MessageDlg('Template name is not valid.', mtError,[mbok],0);
      end
   else if (ValidationResult = 'InUse') then
      begin
         MessageDlg(Format('Template name ''%s'' is already in use.', [TemplateName]), mtError,[mbok],0);
      end;

   if AccsDataModule.CreateTemplate(TemplateName) then
      begin
         TemplatesCombo.Items.Add(TemplateName);
         TemplatesCombo.ItemIndex := TemplatesCombo.Items.IndexOf(TemplateName);
         Load();

         MessageDlg(Format('''%s'' template has been created.',[TemplateName]) + #13#10 + #13#10 +
                           'To finish the new template, fill in the Subject && Body fields and click Save.',mtInformation,[mbOK],0);
      end
   else
      MessageDlg(Format('Failed to create email template %s', [TemplateName]), mtError,[mbok],0);
end;

procedure TfmEmailTemplates.FormShow(Sender: TObject);
var
   TemplateNames : TDynamicStringArray;
   i : Integer;
begin
   TemplatesCombo.Items.Clear;

   TemplateNames := AccsDataModule.GetTemplateNames();
   for i := 0 to Length(TemplateNames) -1 do
      TemplatesCombo.Items.Add(TemplateNames[i]);

   if (TemplatesCombo.Items.Count>0) then
      begin
         TemplatesCombo.ItemIndex := 0;
         Load();
      end;

   HasChanges := False;

   if (FMode = TSelecting) then
      begin
         Caption := 'Choose a template to email...';
         pEditActions.Hide;
         pChooseActions.Show;
         dxBarManager.Bars[0].Visible := False;
      end
   else
      begin
         Caption := 'Email Templates';
         pEditActions.Show;
         pChooseActions.Hide;
         dxBarManager.Bars[0].Visible := True;
      end;
end;

procedure TfmEmailTemplates.actSelectTemplateExecute(
  Sender: TObject);
begin
   ModalResult := mrOK;
end;

procedure TfmEmailTemplates.actCancelSelectExecute(Sender: TObject);
begin
   ModalResult := mrCancel;
end;

procedure TfmEmailTemplates.SetEditingFlag;
begin
   HasChanges := True;
   if (FMode = TEditing) and (not (ChangesWarningLabel.Visible)) then
      ChangesWarningLabel.Visible := True;
end;

procedure TfmEmailTemplates.FormDestroy(Sender: TObject);
begin
   if (FAttachments <> nil) then
      FreeAndNil(FAttachments);
end;

procedure TfmEmailTemplates.actAttachmentsExecute(Sender: TObject);
begin
   if (FAttachments = nil) then
      FAttachments := TStringList.Create;

   FAttachments := TfmEmailAttachments.ShowEmailAttachments(FAttachments);
end;

{ TEmailTemplate }

constructor TEmailTemplate.create;
begin
   FAttachments := TStringList.Create();
end;

destructor TEmailTemplate.destroy;
begin
  inherited;
  FreeAndNil(FAttachments);
end;

end.
