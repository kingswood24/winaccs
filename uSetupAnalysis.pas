unit uSetupAnalysis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, Mask, DBCtrls, Db, DBTables;

type
  TSetupAnalysisForm = class(TForm)
    ButtonPanel: TPanel;
    ExitBtn: TBitBtn;
    SaveBtn: TBitBtn;
    DeleteBtn: TBitBtn;
    AddBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DBGrid1: TDBGrid;
    AddAmendPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    AnalysisQuery: TQuery;
    Analysis: TDataSource;
    Query2: TQuery;
    ChangeBtn: TBitBtn;
    BitBtn1: TBitBtn;
    SelectBtn: TBitBtn;
    SearchBox: TEdit;
    Search: TLabel;
    procedure ExitBtnClick(Sender: TObject);
    procedure ShowWindow(WindowSetup : Integer);
    procedure SearchBoxChange(Sender: TObject);
    procedure SelectBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure ChangeBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    selectedcode : string;
    Window_setup : integer;
  end;

var
  SetupAnalysisForm: TSetupAnalysisForm;

implementation

uses Accsdata, params;

{$R *.DFM}

procedure TSetupAnalysisForm.ShowWindow;
begin
       accsdatamodule.AnalysisDB.open;
       AddAmendPanel.visible := false;
       analysisquery.close;
       analysisquery.DatabaseName := RFarmGate.plocation[2];
       query2.DatabaseName := RFarmGate.plocation[2];
       analysisquery.SQL.clear;
       analysisquery.SQL.add('Select * From Analysis');
       analysisquery.active := true;
       Buttonpanel.visible := true;
       addbtn.enabled := true;
       deletebtn.enabled := true;
       exitbtn.enabled := true;
       savebtn.enabled := false;
       cancelbtn.enabled := false;
       changebtn.enabled := true;
       SetupAnalysisForm.ShowModal;
end;

procedure TSetupAnalysisForm.ExitBtnClick(Sender: TObject);
begin
     Accsdatamodule.AnalysisDB.cancel;
     close;
end;

procedure TSetupAnalysisForm.SearchBoxChange(Sender: TObject);
begin
     if Searchbox.text = '' then begin
          analysisquery.close;
          analysisquery.SQL.clear;
          analysisquery.SQL.add('Select * From Analysis');
          analysisquery.active := true;
     end
     else begin
          analysisquery.close;
          analysisquery.SQL.clear;
          analysisquery.SQL.add('Select * From Analysis where Lower(Description) like ''%' + ansilowercase(searchbox.text) + '%''');
          analysisquery.active := true;

     end;
end;

procedure TSetupAnalysisForm.SelectBtnClick(Sender: TObject);
begin
     selectedcode := analysisquery['Number'];
     Accsdatamodule.AnalysisDB.filtered := False;
     Accsdatamodule.AnalysisDB.filter := '';
     close;
end;

procedure TSetupAnalysisForm.BitBtn1Click(Sender: TObject);
begin
     Accsdatamodule.AnalysisDB.filtered := False;
     Accsdatamodule.AnalysisDB.filter := '';
     searchbox.text := '';
     self.close;
end;

procedure TSetupAnalysisForm.SaveBtnClick(Sender: TObject);
begin
     Accsdatamodule.AnalysisDB.post;
     addbtn.enabled := true;
     deletebtn.enabled := true;
     exitbtn.enabled := true;
     savebtn.enabled := false;
     cancelbtn.enabled := false;
     addamendpanel.visible := false;
     changebtn.enabled := true;
     analysisquery.refresh;
end;

procedure TSetupAnalysisForm.AddBtnClick(Sender: TObject);
begin
     addamendpanel.visible := true;
     Accsdatamodule.AnalysisDB.open;
     Accsdatamodule.AnalysisDB.append;
     query2.sql.clear;
     query2.sql.add('select max(number) as maxnumber from analysis');
     query2.active := true;
     if Accsdatamodule.AnalysisDB.RecordCount = 0 then Accsdatamodule.analysisDB['Number'] := 1
        else Accsdatamodule.analysisDB['Number'] := query2['Maxnumber'] + 1;
     query2.close;
     addbtn.enabled := false;
     deletebtn.enabled := false;
     exitbtn.enabled := false;
     savebtn.enabled := true;
     cancelbtn.enabled := true;
     changebtn.enabled := false;
     analysisquery.refresh;
end;

procedure TSetupAnalysisForm.CancelBtnClick(Sender: TObject);
begin
     Accsdatamodule.AnalysisDB.cancel;
     addbtn.enabled := true;
     deletebtn.enabled := false;
     exitbtn.enabled := true;
     savebtn.enabled := false;
     cancelbtn.enabled := false;
     addamendpanel.visible := false;
     changebtn.enabled := true;
end;

procedure TSetupAnalysisForm.DeleteBtnClick(Sender: TObject);
begin
     accsdatamodule.AnalysisDB.locate('Number',AnalysisQuery['Number'],[]);
     query2.close;
     query2.sql.clear;
     query2.sql.add('select * from trans where analysis = ''' + vartostr(AnalysisQuery['Number']) + '''');
     query2.active := true;
     if query2.recordcount > 0 then begin
        showmessage('This analysis code is used on one or more transactions and cannot be deleted');

     end
        else begin
        Accsdatamodule.AnalysisDB.delete;
        addbtn.enabled := true;
        deletebtn.enabled := false;
        exitbtn.enabled := true;
        savebtn.enabled := false;
        cancelbtn.enabled := false;
        changebtn.enabled := true;
        analysisquery.refresh;
     end;
     query2.close;
end;

procedure TSetupAnalysisForm.ChangeBtnClick(Sender: TObject);
begin
     addbtn.enabled := false;
     deletebtn.enabled := false;
     exitbtn.enabled := false;
     savebtn.enabled := true;
     cancelbtn.enabled := true;
     changebtn.enabled := false;
     accsdatamodule.AnalysisDB.locate('Number',AnalysisQuery['Number'],[]);
     accsdatamodule.analysisdb.Edit;
     Addamendpanel.visible := true;
end;

procedure TSetupAnalysisForm.DBGrid1DblClick(Sender: TObject);
begin
        SelectBtnClick(self);
end;

end.
