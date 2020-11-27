{
   22/02/17 [V4.2 R6.4] /MK Change - Add new UseLineReference field and tick box.
                                   - Organise layout of tick boxes to the way the columns and footers are in the invoice.
}

unit InvoiceLayout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, Grids, DBGrids, StdCtrls, Mask, DBCtrls, ExtCtrls,
  ExtDlgs, Buttons;

type
  TInvoiceLayoutForm = class(TForm)
    DBGrid14: TDBGrid;
    ToolBar2: TToolBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton15: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton1: TToolButton;
    Panel3: TPanel;
    Label21: TLabel;
    DBEdit15: TDBEdit;
    ToolButton21: TToolButton;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    Stationary: TTabSheet;
    Panel1: TPanel;
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
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label20: TLabel;
    Label29: TLabel;
    Label25: TLabel;
    DBEdit1: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    DBEdit2: TDBEdit;
    DBCheckBox2: TDBCheckBox;
    DBEdit3: TDBEdit;
    DBCheckBox3: TDBCheckBox;
    DBEdit4: TDBEdit;
    DBCheckBox4: TDBCheckBox;
    DBEdit5: TDBEdit;
    DBCheckBox5: TDBCheckBox;
    DBEdit6: TDBEdit;
    DBCheckBox6: TDBCheckBox;
    DBEdit7: TDBEdit;
    DBCheckBox7: TDBCheckBox;
    DBEdit8: TDBEdit;
    DBCheckBox8: TDBCheckBox;
    DBEdit9: TDBEdit;
    DBCheckBox9: TDBCheckBox;
    DBEdit10: TDBEdit;
    DBCheckBox10: TDBCheckBox;
    DBEdit11: TDBEdit;
    DBCheckBox11: TDBCheckBox;
    DBEdit12: TDBEdit;
    DBCheckBox12: TDBCheckBox;
    DBEdit14: TDBEdit;
    DBCheckBox14: TDBCheckBox;
    DBEdit16: TDBEdit;
    DBCheckBox19: TDBCheckBox;
    DBCheckBox20: TDBCheckBox;
    DBEdit17: TDBEdit;
    BitBtn1: TBitBtn;
    Panel4: TPanel;
    Label24: TLabel;
    HeightLabel: TLabel;
    Label28: TLabel;
    DBCheckBox15: TDBCheckBox;
    HeightDBEdit: TDBEdit;
    Columns: TTabSheet;
    Panel5: TPanel;
    Label23: TLabel;
    Label22: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label30: TLabel;
    DBCheckBox16: TDBCheckBox;
    DBCheckBox17: TDBCheckBox;
    DBCheckBox18: TDBCheckBox;
    DBEdit18: TDBEdit;
    Remittance: TTabSheet;
    Panel2: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    DBCheckBox13: TDBCheckBox;
    DBEdit13: TDBEdit;
    Label31: TLabel;
    Label32: TLabel;
    DBCheckBox21: TDBCheckBox;
    DBCheckBox22: TDBCheckBox;
    Label33: TLabel;
    DBCheckBox23: TDBCheckBox;
    WarningCaption: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    NameAddresDBEdit: TDBEdit;
    FooterDBEdit: TDBEdit;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    PageNumberStartDBEdit: TDBEdit;
    Label40: TLabel;
    Comment: TTabSheet;
    Panel6: TPanel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    DBCheckBox24: TDBCheckBox;
    DBMemo1: TDBMemo;
    lIncludeLineReference: TLabel;
    dbcbIncludeLineReference: TDBCheckBox;
    procedure ToolButton17Click(Sender: TObject);
    procedure ToolButton18Click(Sender: TObject);
    procedure ToolButton19Click(Sender: TObject);
    procedure ToolButton20Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton21Click(Sender: TObject);
    procedure DBCheckBox15Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InvoiceLayoutForm: TInvoiceLayoutForm;

implementation
uses
    accsdata;
{$R *.DFM}

procedure TInvoiceLayoutForm.ToolButton17Click(Sender: TObject);
begin
     ToolButton1.enabled:=false;
     ToolButton6.enabled:=false;
     ToolButton7.enabled:=false;
     ToolButton9.enabled:=false;
     ToolButton10.enabled:=false;
     ToolButton17.enabled:=false;
     ToolButton18.enabled:=false;
     ToolButton19.enabled:=true;
     ToolButton20.enabled:=true;
     accsdatamodule.InvoiceLayout.Append;
     accsdatamodule.InvoiceLayout['UsePreprinted'] := false;
     accsdatamodule.InvoiceLayout['IncName'] := true;
     accsdatamodule.InvoiceLayout['IncAddress1'] := true;
     accsdatamodule.InvoiceLayout['IncAddress2'] := true;
     accsdatamodule.InvoiceLayout['IncAddress3'] := true;
     accsdatamodule.InvoiceLayout['IncAddress4'] := true;
     accsdatamodule.InvoiceLayout['IncAddress5'] := true;
     accsdatamodule.InvoiceLayout['IncVATNumber'] := true;
     accsdatamodule.InvoiceLayout['IncCompanyReg'] := false;
     accsdatamodule.InvoiceLayout['IncTel1'] := false;
     accsdatamodule.InvoiceLayout['IncTel2'] := false;
     accsdatamodule.InvoiceLayout['IncFax'] := false;
     accsdatamodule.InvoiceLayout['IncMobile'] := false;
     accsdatamodule.InvoiceLayout['IncEmail'] := false;
     accsdatamodule.InvoiceLayout['IncWeb'] := false;
     accsdatamodule.InvoiceLayout['NumberOfCopies'] := 2;
     accsdatamodule.InvoiceLayout['IncludeVAT'] := true;
     accsdatamodule.InvoiceLayout['IncludeNominalDesc'] := false;
     accsdatamodule.InvoiceLayout['IncRemittanceSlip'] := false;
     accsdatamodule.InvoiceLayout['IncludeComment'] := false;
     accsdatamodule.InvoiceLayout['UseLineDate'] := false;
     accsdatamodule.InvoiceLayout['UseLineReference'] := false;

     Panel1.enabled := true;
     Panel2.enabled := true;
     Panel3.enabled := true;
     Panel4.enabled := true;
     Panel5.enabled := true;
     Panel6.enabled := true;
end;

procedure TInvoiceLayoutForm.ToolButton18Click(Sender: TObject);
begin
     ToolButton1.enabled:=false;
     ToolButton6.enabled:=false;
     ToolButton7.enabled:=false;
     ToolButton9.enabled:=false;
     ToolButton10.enabled:=false;
     ToolButton17.enabled:=false;
     ToolButton18.enabled:=false;
     ToolButton19.enabled:=true;
     ToolButton20.enabled:=true;
     Panel1.enabled := true;
     Panel2.enabled := true;
     Panel3.enabled := true;
     Panel4.enabled := true;
     Panel5.enabled := true;
     Panel6.enabled := true;
     Warningcaption.caption := 'Please click on ''Save'' to save any changed details for this layout!';
     accsdatamodule.InvoiceLayout.Edit;
end;

procedure TInvoiceLayoutForm.ToolButton19Click(Sender: TObject);
begin
     if DBEdit15.Text <> '' then begin
        ToolButton1.enabled:=true;
        ToolButton6.enabled:=true;
        ToolButton7.enabled:=true;
        ToolButton9.enabled:=true;
        ToolButton10.enabled:=true;
        ToolButton17.enabled:=true;
        ToolButton18.enabled:=true;
        ToolButton19.enabled:=false;
        ToolButton20.enabled:=false;

        accsdatamodule.InvoiceLayout.Post;
        Panel1.enabled := false;
        Panel2.enabled := false;
        Panel3.enabled := false;
        Panel4.enabled := false;
        Panel5.enabled := false;
        Panel6.enabled := false;
        warningcaption.caption := 'You must click on ''Change'' before you can change any details for this layout!';
     end
        else begin
           showmessage('You must specify a Layout Name for this Invoice / Credit Note Setup');
        end;
end;

procedure TInvoiceLayoutForm.ToolButton20Click(Sender: TObject);
begin
     ToolButton1.enabled:=true;
     ToolButton6.enabled:=true;
     ToolButton7.enabled:=true;
     ToolButton9.enabled:=true;
     ToolButton10.enabled:=true;
     ToolButton17.enabled:=true;
     ToolButton18.enabled:=true;
     ToolButton19.enabled:=false;
     ToolButton20.enabled:=false;
     accsdatamodule.InvoiceLayout.Cancel;
     Panel1.enabled := false;
     Panel2.enabled := false;
     Panel3.enabled := false;
     Panel4.enabled := false;
     Panel5.enabled := false;
     Panel6.enabled := false;
     warningcaption.caption := 'You must click on ''Change'' before you can change any details for this layout!';
end;

procedure TInvoiceLayoutForm.ToolButton6Click(Sender: TObject);
begin
     accsdatamodule.InvoiceLayout.first;
     Panel1.enabled := false;
     Panel2.enabled := false;
     Panel3.enabled := false;
     Panel4.enabled := false;
     Panel5.enabled := false;
     Panel6.enabled := false;
end;

procedure TInvoiceLayoutForm.ToolButton7Click(Sender: TObject);
begin
     accsdatamodule.InvoiceLayout.prior;
     Panel1.enabled := false;
     Panel2.enabled := false;
     Panel3.enabled := false;
     Panel4.enabled := false;
     Panel5.enabled := false;
     Panel6.enabled := false;
     
end;

procedure TInvoiceLayoutForm.ToolButton9Click(Sender: TObject);
begin
     accsdatamodule.InvoiceLayout.next;
     Panel1.enabled := false;
     Panel2.enabled := false;
     Panel3.enabled := false;
     Panel4.enabled := false;
     Panel5.enabled := false;
     Panel6.enabled := false;

end;

procedure TInvoiceLayoutForm.ToolButton10Click(Sender: TObject);
begin
     accsdatamodule.InvoiceLayout.last;
     Panel1.enabled := false;
     Panel2.enabled := false;
     Panel3.enabled := false;
     Panel4.enabled := false;
     Panel5.enabled := false;
     Panel6.enabled := false;
     
end;

procedure TInvoiceLayoutForm.ToolButton1Click(Sender: TObject);
begin
     close;
end;

procedure TInvoiceLayoutForm.ToolButton21Click(Sender: TObject);
begin
     if messagedlg('Are you sure you wish to delete this invoice layout?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
     accsdatamodule.InvoiceLayout.Delete;
  end;
     Panel1.enabled := false;
     Panel2.enabled := false;
     Panel3.enabled := false;
     Panel4.enabled := false;
     Panel5.enabled := false;
     Panel6.enabled := false;
     warningcaption.caption := 'You must click on ''Change'' before you can change any details for this layout!';
end;

procedure TInvoiceLayoutForm.DBCheckBox15Click(Sender: TObject);
begin
     If DBCheckBox15.Checked then begin
        Panel1.Enabled := false;
        Panel1.visible := false;
        HeightLabel.visible := true;
        HeightDBEdit.visible := true;
        Panel4.Height := 406;
        DBedit1.Color := clBtnFace;
        DBedit2.Color := clBtnFace;
        DBedit3.Color := clBtnFace;
        DBedit4.Color := clBtnFace;
        DBedit5.Color := clBtnFace;
        DBedit6.Color := clBtnFace;
        DBedit7.Color := clBtnFace;
        DBedit8.Color := clBtnFace;
        DBedit9.Color := clBtnFace;
        DBedit10.Color := clBtnFace;
        DBedit11.Color := clBtnFace;
        DBedit12.Color := clBtnFace;
        DBedit16.Color := clBtnFace;
     end
     else begin
          Panel1.enabled := true;
          Panel1.visible := true;
          HeightLabel.visible := false;
          HeightDBEdit.visible := false;
          Panel4.Height := 41;
          DBedit1.Color := clWindow;
          DBedit2.Color := clWindow;
          DBedit3.Color := clWindow;
          DBedit4.Color := clWindow;
          DBedit5.Color := clWindow;
          DBedit6.Color := clWindow;
          DBedit7.Color := clWindow;
          DBedit8.Color := clWindow;
          DBedit9.Color := clWindow;
          DBedit10.Color := clWindow;
          DBedit11.Color := clWindow;
          DBedit12.Color := clWindow;
          DBedit16.Color := clWindow;
     end;
end;

procedure TInvoiceLayoutForm.FormShow(Sender: TObject);
begin
     Panel1.enabled := false;
     Panel2.enabled := false;
     Panel3.enabled := false;
     Panel4.enabled := false;
     Panel5.enabled := false;
     Panel6.enabled := false;
     Pagecontrol1.ActivePage := Stationary; 

end;

procedure TInvoiceLayoutForm.FormClick(Sender: TObject);
begin
{     If not panel1.Enabled then begin
        showmessage('You must click on ''Change'' before you can change any details for this layout!');
     end;
 }
end;

procedure TInvoiceLayoutForm.BitBtn1Click(Sender: TObject);
begin
       if OpenDialog1.Execute then
        DBEdit17.Field.Value := OpenDialog1.FileName;
end;

end.
