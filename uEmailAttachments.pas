unit uEmailAttachments;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, cxButtons;

type
  TfmEmailAttachments = class(TForm)
    FileAttachmentList: TListBox;
    btnFileBrowse: TcxButton;
    btnRemove: TcxButton;
    Label1: TLabel;
    OpenDialog: TOpenDialog;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    procedure btnFileBrowseClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure FileAttachmentListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    class function ShowEmailAttachments(Attachments : TStringList) : TStringList;
  end;

var
  fmEmailAttachments: TfmEmailAttachments;

implementation

{$R *.DFM}

procedure TfmEmailAttachments.btnFileBrowseClick(Sender: TObject);
begin
   if (not OpenDialog.Execute) or (not FileExists(OpenDialog.FileName)) then Exit;

   if (FileAttachmentList.Items.IndexOf(OpenDialog.FileName) > -1) then Exit;

   FileAttachmentList.Items.Add(OpenDialog.FileName);
end;

class function TfmEmailAttachments.ShowEmailAttachments(
  Attachments: TStringList) : TStringList;
begin
   Result := nil;
   with TfmEmailAttachments.Create(nil) do
      try
         if (Attachments <> nil) then
            FileAttachmentList.Items.AddStrings(Attachments);

         if (ShowModal=mrOK) then
            begin
               Result := TStringList.Create;

               Result.AddStrings(FileAttachmentList.Items);
            end;
      finally
         Free;
      end;
end;

procedure TfmEmailAttachments.btnRemoveClick(Sender: TObject);
begin
   if (FileAttachmentList.ItemIndex > -1) and
      (MessageDlg(Format('Do you want to remove attachment %s?',
          [FileAttachmentList.Items[FileAttachmentList.ItemIndex]]),mtConfirmation,[mbYes,mbNo],0) = idYes) then
      begin
         FileAttachmentList.Items.BeginUpdate;
         FileAttachmentList.Items.Delete(FileAttachmentList.ItemIndex);
         FileAttachmentList.Items.EndUpdate;
      end;
end;

procedure TfmEmailAttachments.FileAttachmentListKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
   if (Key = VK_DELETE) then
      btnRemove.Click();
end;

end.
