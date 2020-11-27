{
Author : Michael Cummins.
Date   : 11-04-97.

This Unit Contains Code to Read the 'LangFile.Dat' and pass the text back
to be displayed on buttons screens e.t.c.
The Language Record consists of 5 Language field
ie 1 = English.
   2 = French.
   3 = German.
   4 = ?.
   5 = ?.


   Function ReadLang ( LangId : LongInt; LangType : Integer ) : String;
   LangID is the record number.
   LangType is the array position in the chosen record.
}

unit LangUnit;

interface
Type
    TLangRec = Packed Array [1..5] Of String[50];
    TLangFile = File Of TLangRec;

Var
   LangOpen : Boolean;
   LangRec  : TLangRec;
   LangFile : TLangFile;

    { Pass back a string to be displayed }
    Function ReadLang ( LangId : LongInt; LangType : Integer ) : String;
    Procedure OpenLang;
    Procedure CloseLang;

implementation
Uses
    Vars,
    SysUtils,
    Dialogs;

Var
   Dummy    : Boolean;

Function ShowError ( CurrIO : Integer ) : Boolean;
Begin
     ShowError := False;
     If CurrIO <> 0 Then
        Begin
             MessageDlg('Language File Error ' + IntToStr (CurrIO), mtInformation, [mbOk], 0);
             ShowError := True;
        End;
End;

Procedure OpenLang;
Begin
   LangOpen := True;
   AssignFile ( LangFile, SubDir + 'LangFile.Dat');
   {$i-}
   Reset ( LangFile );
   IF ShowError ( ioresult ) Then
      LangOpen := False;
   {$i+}
End;

Procedure CloseLang;
Begin
   {$i-}
   If LangOpen Then
      Begin
           CloseFile ( LangFile );
           Dummy := ShowError ( ioresult );
      End;
   {$i+}
   LangOpen := False;
End;

Function ReadLang ( LangId : LongInt; LangType : Integer ) : String;
Begin
     ReadLang := '';
     If LangOpen Then
        Begin
             Seek ( LangFile, LangId );
             {$i-}
             Read ( LangFile, LangRec );
             Dummy := ShowError ( ioresult );
             If EOF ( LangFile ) Then
                Begin
                     Reset ( LangFile );
                     Dummy := ShowError ( ioresult );
                     CloseLang;
                End
             Else
                 Begin
                      ReadLang := LangRec[LangType];
                      Dummy := ShowError ( ioresult );
                 End;
             {$i+}
        End;
End;

end.
