unit Setlang;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Printers;

type
  TLangForm = class(TForm)
    LangID: TEdit;
    LangText: TEdit;
    Exit: TBitBtn;
    NewRecord: TBitBtn;
    SaveCurrent: TBitBtn;
    MoveForward: TBitBtn;
    MoveBack: TBitBtn;
    WhichLanguage: TEdit;
    Language: TLabel;
    NameLanguage: TLabel;
    PrintInfo: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure LangIDExit(Sender: TObject);
    procedure LangTextExit(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure NewRecordClick(Sender: TObject);
    procedure SaveCurrentClick(Sender: TObject);
    procedure MoveForwardClick(Sender: TObject);
    procedure MoveBackClick(Sender: TObject);
    procedure WhichLanguageExit(Sender: TObject);
    procedure PrintInfoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LangForm: TLangForm;

implementation
Uses
    DB_Types,
    DB_Vars,
    Calcs,
    LangUnit;
Var
   LangType : Integer;    { 1 to 5 to identify the current language }

{$R *.DFM}

procedure TLangForm.FormActivate(Sender: TObject);
Var
   st : String;
begin
   SubDir := 'c:\winaccs\';
   OpenLang;
end;

procedure TLangForm.LangIDExit(Sender: TObject);
begin
     If Numeric ( LangID.Text ) Then
        If StrToInt ( LangID.Text ) <> 0 Then
           LangText.Text := ReadLang ( StrToInt ( LangId.Text ), LangType);
end;

procedure TLangForm.LangTextExit(Sender: TObject);
begin
     LangRec[LangType] := LangText.Text;
     Seek ( LangFile, StrToInt ( LangId.Text ));
     write ( LangFile, LangRec );
     If EOF ( LangFile ) Then
        Seek(LangFile, FileSize(LangFile));
end;

procedure TLangForm.FormDeactivate(Sender: TObject);
begin
    CloseLang;
end;

procedure TLangForm.ExitClick(Sender: TObject);
begin
     Application.Terminate;
end;

procedure TLangForm.NewRecordClick(Sender: TObject);
begin
     Seek(LangFile, FileSize(LangFile));
     write ( Langfile, LangRec );
     LangID.Text := IntToStr ( FilePos ( LangFile ));
     Seek(LangFile, FileSize(LangFile));
end;

procedure TLangForm.SaveCurrentClick(Sender: TObject);
begin
     LangRec[LangType] := LangText.Text;
     If numeric ( LangID.Text ) Then
        Begin
             Seek ( LangFile, StrToInt ( LangId.Text ));
             write ( LangFile, LangRec );
        End;
end;

procedure TLangForm.MoveForwardClick(Sender: TObject);
begin
     Seek(LangFile, FilePos(LangFile));
     If NOT Eof ( LangFile ) Then
        Begin
             LangID.Text := IntToStr ( FilePos ( LangFile ));
             LangText.Text := ReadLang ( StrToInt ( LangId.Text ), LangType);
        End
     Else
         MessageDlg('End Of File Reached', mtInformation,[mbOk], 0);
end;

procedure TLangForm.MoveBackClick(Sender: TObject);
begin
     Seek(LangFile, FilePos(LangFile)-2);
     LangID.Text := IntToStr ( FilePos ( LangFile ));
     LangText.Text := ReadLang ( StrToInt ( LangId.Text ), LangType);
end;

procedure TLangForm.WhichLanguageExit(Sender: TObject);
begin
     If NOT numeric ( WhichLanguage.Text ) Then
        Begin
             MessageDlg('Enter 1 - 5 for Language', mtInformation,[mbOk], 0);
             WhichLanguage.SetFocus;
        End
     Else
         Begin
              LangType := StrToInt ( WhichLanguage.Text );
              Case LangType Of
                   1 : NameLanguage.Caption := 'ENGLISH';
                   2 : NameLanguage.Caption := 'FRENCH';
                   3 : NameLanguage.Caption := 'GERMAN';
                   4 : NameLanguage.Caption := 'NOT DEFINED';
                   5 : NameLanguage.Caption := 'NOT DEFINED';
                   Else
                       Begin
                            NameLanguage.Caption := '';
                            MessageDlg('Enter 1 - 5 for Language', mtInformation,[mbOk], 0);
                            WhichLanguage.SetFocus;
                       End;
              End;
         End;
end;

procedure TLangForm.PrintInfoClick(Sender: TObject);
Var X,Y,
    RecCounter : Integer;
    FileT      : TextFile;
begin
     {$I-}

     RecCounter := 0;
     X := 0;
     Y := 0;
     Seek(LangFile, RecCounter);
     Printer.BeginDoc;
     Repeat
         Inc ( RecCounter );
         Seek(LangFile, RecCounter );

         If LangOpen Then
            Begin
                 Printer.Canvas.TextOut(x,y, IntToStr ( FilePos ( LangFile )));
                 Printer.Canvas.TextOut(x+Printer.Canvas.TextWidth('12344'),y, ReadLang ( RecCounter, LangType));
            End;
         Inc ( Y, Printer.Canvas.TextHeight('S')+15 );
         If ( Y+Printer.Canvas.TextHeight('S')+15 >= Printer.PageHeight ) Then
            Begin
                 Printer.NewPage;
                 x := 0;
                 y := 0;
            End;
     Until NOT ( LangOpen );
     {
     CloseFile ( FileT );
     }
     Printer.EndDoc;
     {$I+}
end;

end.
