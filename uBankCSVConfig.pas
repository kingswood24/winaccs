{
   25/10/17 [V4.2 R8.9] /MK Change - Added 2 extra details fields columns - Brendan Brady.
}

unit uBankCSVConfig;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, StdCtrls, Mask, DBCtrls, ExtCtrls, Grids, DBGrids,
  cxControls, cxContainer, cxEdit, cxCheckBox, cxDBEdit;

type
  TBankCSVConfigForm = class(TForm)
    ToolBar2: TToolBar;
    ExitBtn: TToolButton;
    ToolButton5: TToolButton;
    FirstBtn: TToolButton;
    PriorBtn: TToolButton;
    NextBtn: TToolButton;
    LastBtn: TToolButton;
    ToolButton15: TToolButton;
    AddBtn: TToolButton;
    ChangeBtn: TToolButton;
    SaveBtn: TToolButton;
    CancelBtn: TToolButton;
    DeleteBtn: TToolButton;
    DBGrid14: TDBGrid;
    Panel1: TPanel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ImportFileName: TDBEdit;
    Label21: TLabel;
    WarningCaption: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    DBEdit11: TDBEdit;
    Label13: TLabel;
    DBEdit12: TDBEdit;
    lDebCredIndicColumn: TLabel;
    dbDebCredIndicColumn: TDBEdit;
    dbcbAllowDebCredIndicColumn: TcxDBCheckBox;
    pTotalColumn: TPanel;
    Label10: TLabel;
    DBEdit10: TDBEdit;
    procedure ExitBtnClick(Sender: TObject);
    procedure FirstBtnClick(Sender: TObject);
    procedure PriorBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure LastBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure ChangeBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbcbAllowDebCredIndicColumnPropertiesChange(Sender: TObject);
  private
    procedure EnableDisableDebCreIndCol;
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowTheForm;
  end;

var
  BankCSVConfigForm: TBankCSVConfigForm;

implementation

{$R *.DFM}

uses
  AccsData;

class procedure TBankCSVConfigForm.ShowTheForm;
begin
   with TBankCSVConfigForm.Create(nil) do
      try
         ShowModal;
      finally
         Free;
      end;
end;

procedure TBankCSVConfigForm.ExitBtnClick(Sender: TObject);
begin
        close;
end;

procedure TBankCSVConfigForm.FirstBtnClick(Sender: TObject);
begin
     accsdatamodule.BankCSVDefaultsDB.first;
     Panel1.enabled := false;
end;

procedure TBankCSVConfigForm.PriorBtnClick(Sender: TObject);
begin
     accsdatamodule.BankCSVDefaultsDB.Prior;
     Panel1.enabled := false;
end;

procedure TBankCSVConfigForm.NextBtnClick(Sender: TObject);
begin
     accsdatamodule.BankCSVDefaultsDB.next;
     Panel1.enabled := false;
end;

procedure TBankCSVConfigForm.LastBtnClick(Sender: TObject);
begin
     accsdatamodule.BankCSVDefaultsDB.last;
     Panel1.enabled := false;
end;

procedure TBankCSVConfigForm.AddBtnClick(Sender: TObject);
begin
     ExitBtn.enabled:=false;
     FirstBtn.enabled:=false;
     PriorBtn.enabled:=false;
     NextBtn.enabled:=false;
     LastBtn.enabled:=false;
     AddBtn.enabled:=false;
     ChangeBtn.enabled:=false;
     CancelBtn.enabled:=true;
     SaveBtn.enabled:=true;

     Warningcaption.caption := 'Please click on ''Save'' to save any changed details for this Import Configuration!';

     accsdatamodule.BankCSVDefaultsDB.Append;
     accsdatamodule.BankCSVDefaultsDB['Delimiter'] := ',';
     accsdatamodule.BankCSVDefaultsDB['ChequeIdentifier'] := 'CHQ';
     accsdatamodule.BankCSVDefaultsDB['LodgementIdentifier'] := 'LDG';
     Panel1.enabled := true;

end;

procedure TBankCSVConfigForm.ChangeBtnClick(Sender: TObject);
begin
     ExitBtn.enabled:=false;
     FirstBtn.enabled:=false;
     PriorBtn.enabled:=false;
     NextBtn.enabled:=false;
     LastBtn.enabled:=false;
     AddBtn.enabled:=false;
     ChangeBtn.enabled:=false;
     CancelBtn.enabled:=true;
     SaveBtn.enabled:=true;

     Panel1.enabled := true;

     Warningcaption.caption := 'Please click on ''Save'' to save any changed details for this Import Configuration!';
     accsdatamodule.BankCSVDefaultsDB.Edit;
end;

procedure TBankCSVConfigForm.SaveBtnClick(Sender: TObject);
begin
     if ImportFileName.Text <> '' then begin

        ExitBtn.enabled:=true;
        FirstBtn.enabled:=true;
        PriorBtn.enabled:=true;
        NextBtn.enabled:=true;
        LastBtn.enabled:=true;
        AddBtn.enabled:=true;
        ChangeBtn.enabled:=true;
        CancelBtn.enabled:=false;
        SaveBtn.enabled:=false;



        accsdatamodule.BankCSVDefaultsDB.Post;
        Panel1.enabled := false;

        warningcaption.caption := 'You must click on ''Change'' before you can change any details for this Import Configuration!';
     end
        else begin
           showmessage('You must specify a Import Name for this Import Configuration');
        end;
end;

procedure TBankCSVConfigForm.CancelBtnClick(Sender: TObject);
begin
        ExitBtn.enabled:=true;
        FirstBtn.enabled:=true;
        PriorBtn.enabled:=true;
        NextBtn.enabled:=true;
        LastBtn.enabled:=true;
        AddBtn.enabled:=true;
        ChangeBtn.enabled:=true;
        CancelBtn.enabled:=false;
        SaveBtn.enabled:=false;

        accsdatamodule.BankCSVDefaultsDB.Cancel;
        Panel1.enabled := false;

        warningcaption.caption := 'You must click on ''Change'' before you can change any details for this Import Configuration!';
        
end;

procedure TBankCSVConfigForm.DeleteBtnClick(Sender: TObject);
begin
     if messagedlg('Are you sure you wish to delete this import configuration?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
     accsdatamodule.BankCSVDefaultsDB.Delete;
  end;
     Panel1.enabled := false;

     warningcaption.caption := 'You must click on ''Change'' before you can change any details for this Import Configuration!';
end;

procedure TBankCSVConfigForm.FormShow(Sender: TObject);
begin
   Panel1.enabled := false;
   EnableDisableDebCreIndCol;
end;

procedure TBankCSVConfigForm.dbcbAllowDebCredIndicColumnPropertiesChange(
  Sender: TObject);
begin
   EnableDisableDebCreIndCol;
end;

procedure TBankCSVConfigForm.EnableDisableDebCreIndCol;
begin
   lDebCredIndicColumn.Enabled := dbcbAllowDebCredIndicColumn.Checked;
   dbDebCredIndicColumn.Enabled := lDebCredIndicColumn.Enabled;
end;

end.
