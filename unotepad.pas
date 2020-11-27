unit uNotepad;

// The purpose of this unit is to provide a basic notepad type interface which will remove
// the dependency on Notepad to display reports such as the Data Integrity Check as notepad
// is not part of Windows Vista.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, printers;

type
  TNotepadForm = class(TForm)
    Panel1: TPanel;
    Exit: TBitBtn;
    PrintBtn: TBitBtn;
    RichEdit1: TRichEdit;
    procedure ExitClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure LoadFile(Filename : string);
  end;

var
  NotepadForm: TNotepadForm;

implementation

{$R *.DFM}

(* Set RichEdit margins in Inches (1 in = 2.54 cm) for the active printer *)
procedure SetRichEditMargins(
  const mLeft, mRight,
        mTop, mBottom: extended;
  const re : TRichEdit) ;
var
  ppiX, ppiY : integer;
  spaceLeft, spaceTop : integer;
  r : TRect;
begin
  // pixels per inch
  ppiX := GetDeviceCaps(Printer.Handle, LOGPIXELSX) ;
  ppiY := GetDeviceCaps(Printer.Handle, LOGPIXELSY) ;

  // non-printable margins
  spaceLeft := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETX) ;
  spaceTop := GetDeviceCaps(Printer.Handle, PHYSICALOFFSETY) ;

  //calc margins
  R.Left := Round(ppiX * mLeft) - spaceLeft;
  R.Right := Printer.PageWidth - Round(ppiX * mRight) - spaceLeft;
  R.Top := Round(ppiY * mTop) - spaceTop;
  R.Bottom := Printer.PageHeight - Round(ppiY * mBottom) - spaceTop;

  // set margins
  re.PageRect := r;
end;

class procedure TNotepadForm.LoadFile(Filename : string);
begin
    with TNotepadForm.Create(nil) do
       try
          Richedit1.Lines.LoadFromFile(FileName);
          ShowModal;
       finally
          Free;
       end;
end;

procedure TNotepadForm.ExitClick(Sender: TObject);
begin
        Richedit1.Lines.Clear;
        self.close;
end;

procedure TNotepadForm.PrintBtnClick(Sender: TObject);
begin
        SetRichEditMargins(1, 1, 1, 1, richedit1) ;
        richedit1.Print('Kingswood Accounts');
        Showmessage('Document Sent to Printer');
end;



end.
