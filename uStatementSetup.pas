unit uStatementSetup;

// Ch032 - added tick box, memo etc onto form to add comment onto the statements

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, AccsData, DBCtrls, Mask, Reportdefs, Buttons, RxLookup,
  ToolEdit, RXDBCtrl;

type
  TFormStatementSetup = class(TForm)
    ExitButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBEdit6: TDBEdit;
    StatementTypeDBEdit: TDBEdit;
    Label25: TLabel;
    DBCheckBox20: TDBCheckBox;
    DBEdit7: TDBEdit;
    BrowseBtn: TBitBtn;
    OpenDialog1: TOpenDialog;
    Label41: TLabel;
    DBCheckBox24: TDBCheckBox;
    DBMemo1: TDBMemo;
    procedure ExitButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BrowseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormStatementSetup: TFormStatementSetup;
  StatementType: Char;

implementation

uses NewRepUnit,Vars;

{$R *.DFM}

procedure TFormStatementSetup.ExitButtonClick(Sender: TObject);
begin
     Accsdatamodule.Statement.post;
     Accsdatamodule.Statement.append;
     Accsdatamodule.Statement.cancel;
//     Accsdatamodule.Statement.close;
//     Accsdatamodule.Statement.First;
     close;
end;

procedure TFormStatementSetup.FormShow(Sender: TObject);
begin

     AccsDataModule.Statement.open;
//     AccsDataModule.Statement.first;
     if NewRepForm.CustRadio.checked then begin
                                          StatementType := 'S';
                                          FormStatementSetup.Caption := 'Sales Statement Layout';

     end
     else begin
          StatementType := 'P';
          FormStatementSetup.Caption := 'Purchase Statement Layout';
     end;

     if Accsdatamodule.Statement.Locate('StateType',StatementType,[]) = false then begin

              Accsdatamodule.Statement.append;
              Accsdatamodule.Statement.FieldValues['StateType'] := Statementtype;
              Accsdatamodule.Statement.FieldValues['Showheader'] := True;
              Accsdatamodule.Statement.FieldValues['StatementFrom'] := True;
              Accsdatamodule.Statement.FieldValues['Name'] := Cash1.XCompany;
              Accsdatamodule.Statement.FieldValues['UseGraphicsFile'] := False;        // TGM AB 17/03/17
              Accsdatamodule.Statement.FieldValues['IncludeComment'] := False;         // Ch032
     end else Accsdatamodule.Statement.edit;
end;

procedure TFormStatementSetup.BrowseBtnClick(Sender: TObject);         // TGM AB 17/03/17
begin
        if OpenDialog1.Execute then
              DBEdit7.Field.Value := OpenDialog1.FileName;
end;



end.
