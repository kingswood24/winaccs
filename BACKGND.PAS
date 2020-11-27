unit Backgnd;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs;

type
  TBackGndForm = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BackGndForm: TBackGndForm;

implementation

{$R *.DFM}
var
  OldWindowProc : Pointer; {Variable for the old windows proc}
  MyMsg : DWord; {custom systemwide message}

function NewWindowProc(WindowHandle : hWnd;
                       TheMessage   : LongInt;
                       ParamW       : LongInt;
                       ParamL       : LongInt) : LongInt stdcall;
begin
  if TheMessage = MyMsg  then begin
   {Tell the application to restore, let it restore the form}
   SendMessage(Application.handle, WM_SYSCOMMAND, SC_RESTORE, 0);
   SetForegroundWindow(Application.Handle);
   {We handled the message - we are done}
    Result := 0;
    exit;
  end;
 {Call the original winproc}
  Result := CallWindowProc(OldWindowProc,
                           WindowHandle,
                           TheMessage,
                           ParamW,
                           ParamL);
end;

procedure TBackGndForm.FormShow(Sender: TObject);
begin
     height := 0;
     width := 0;
                 {if ((screen.height > 600) and (screen.Width > 800)) then begin

                    Height := Screen.Height-27;          // 27 pixels allow the taskbar to be visible
                    Width  := Screen.Width;
                    BackGndForm.Left:= 0;                // TGM AB 23/07/02 - altered the form from Maximised to normaol
                    BackGndForm.Top := 0;                // set top and left to 0
                 end
                 else begin
                      Height := Screen.Height-27;          // 27 pixels allow the taskbar to be visible
                      Width  := Screen.Width;
                      Backgndform.WindowState := wsmaximized;
                 end;}
end;

procedure TBackGndForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If (Key = VK_F4) AND (SHIFT = [ssALT]) Then
        Close;
end;

procedure TBackGndForm.FormCreate(Sender: TObject);
begin
  { Register a custom windows message }
   MyMsg := RegisterWindowMessage('Kingswood Accounts');
  { Set MenuForm's windows proc to ours and remember the old window proc }
   OldWindowProc := Pointer(SetWindowLong(BackGndForm.Handle,
                                         GWL_WNDPROC,
                                         LongInt(@NewWindowProc)));
end;

procedure TBackGndForm.FormDestroy(Sender: TObject);
begin
   { Set MenuForm's window proc back to it's original procedure }
   SetWindowLong(BackGndForm.Handle,
                 GWL_WNDPROC,
                 LongInt(OldWindowProc));
end;

begin
 {Tell Delphi to hide it's hidden application window for now to avoid}
 {a "flash" on the taskbar if we halt due to another instance}
  ShowWindow(Application.Handle, SW_HIDE);
end.
