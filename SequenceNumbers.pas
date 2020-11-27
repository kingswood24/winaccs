unit SequenceNumbers;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, AccsData,
  StdCtrls, Mask, DBCtrls;

type
  TSequenceNumbersForm = class(TForm)
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit4: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    DBEdit3: TDBEdit;
    Label3: TLabel;
    SaveBtn: TButton;
    Cancelbtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelbtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SequenceNumbersForm: TSequenceNumbersForm;

implementation
uses cashbook;

{$R *.DFM}

procedure TSequenceNumbersForm.FormShow(Sender: TObject);
begin
     accsdatamodule.InvoiceNumbers.edit;
     savebtn.SetFocus;
end;

procedure TSequenceNumbersForm.SaveBtnClick(Sender: TObject);
begin
     accsdatamodule.InvoiceNumbers.post;
     CashbookForm.Reference.Text := IntToStr(CashbookForm.getRefNumber);
     close;
end;

procedure TSequenceNumbersForm.CancelbtnClick(Sender: TObject);
begin
     accsdatamodule.InvoiceNumbers.cancel;
     close;
end;

end.
