{
   05/08/14 [V4.1 R7.3] /MK Bug Fix - FillGrid - Check for blank enterprises.
}

unit uEnterpriseSetup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Buttons, ExtCtrls, DBGrids;

type
  TEnterpriseSetup = class(TForm)
    ButtonPanel: TPanel;
    ExitBtn: TBitBtn;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ChangeBtn: TBitBtn;
    EntGrid: TStringGrid;
    UnitName: TEdit;
    NoOfUnits: TEdit;
    Overheads: TEdit;
    Qty2Name: TEdit;
    Qty3Name: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Procedure SetToLong ( Var StrToChange : TEdit );

    procedure ExitBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FillGrid;
    procedure FillDetails(EntCode : String);
    procedure EntGridClick(Sender: TObject);
    procedure ChangeBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure NoOfUnitsExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EnterpriseSetup: TEnterpriseSetup;

implementation

uses
        AccsData, clears, types, calcs, vars;

{$R *.DFM}

Procedure TEnterpriseSetup.SetToLong ( Var StrToChange : TEdit );
Begin
    If IsItLong ( StrToChange.Text, 'L', CurrLong ) Then
       Begin
            LongStr ( CurrLong, CurrStr, 'L' );
            StrToChange.Text := CurrStr;
       End
    Else
        StrToChange.SetFocus;
End;

procedure TEnterpriseSetup.ExitBtnClick(Sender: TObject);
begin
        self.close;
end;

procedure TEnterpriseSetup.FillGrid;
var
     i, RowNumber : integer;
     tempstr : shortstring;
begin
       // Populate Screen with Enterprises
       Accsdatamodule.EntsFileDB.first;
       RowNumber := 0;

       for i:=1 to Accsdatamodule.EntsFileDB.RecordCount do begin
           if Accsdatamodule.EntsFileDB['Active'] = True then begin

                if rownumber <> 0 then EntGrid.RowCount := EntGrid.RowCount + 1;
                RowNumber := RowNumber + 1;

                //   05/08/14 [V4.1 R7.3] /MK Bug Fix - Check for blank enterprises.
                if ( Accsdatamodule.EntsFileDB.FieldByName('EntCode').AsString <> '' ) then
                   Entgrid.Cells[0,RowNumber] := Accsdatamodule.EntsFileDB['EntCode'];
                if ( Accsdatamodule.EntsFileDB.FieldbyName('EntName').AsString <> '' ) then
                   begin
                      Tempstr :=  Accsdatamodule.EntsFileDB['EntName'];
                      PadRight ( Tempstr, 20 );
                      Entgrid.Cells[1,RowNumber] := trim(Copy ( Tempstr, 1, 17 ));
                      //      Entgrid.Cells[1,RowNumber] := Accsdatamodule.EntsFileDB['EntName'];
                   end;

           end;
           Accsdatamodule.EntsFileDB.next;
       end;

       // default to first record & show the details;

       EntGrid.row := 1;
       FillDetails(Entgrid.Cells[EntGrid.col,EntGrid.row]);

end;

procedure TEnterpriseSetup.FillDetails(EntCode : String);
var
        tempstr : shortstring;
        templong : biglong;
begin
       // Fill in Enterprise Details

       UnitName.Text := '';
       Qty2Name.Text := '';
       Qty3Name.Text := '';
       Overheads.text := '';
       NoOfUnits.text := '';

       if EntCode <> '' then begin
                Accsdatamodule.EntsFileDB.locate('EntCode',EntCode,[]);
                if Accsdatamodule.EntsFileDB['UnitText'] <> Null then begin
                        try UnitName.text := Accsdatamodule.EntsFileDB['UnitText'];
                        except UnitName.text := '';
                        end;
                end;
                if Accsdatamodule.EntsFileDB['Quantity2Name'] <> Null then begin
                        try Qty2Name.text := Accsdatamodule.EntsFileDB['Quantity2Name'];
                        except Qty2Name.text := '';
                        end;
                end;
                if Accsdatamodule.EntsFileDB['Quantity3Name'] <> Null then begin
                        try Qty3Name.text := Accsdatamodule.EntsFileDB['Quantity3Name'];
                        except Qty3Name.text := '';
                        end;
                end;
                Tempstr :=  Accsdatamodule.EntsFileDB['EntName'];
                PadRight ( Tempstr, 20 );
                Overheads.text := trim(Copy ( Tempstr, 18, 3 ));


                templong := 100*(accsdatamodule.EntsFileDB['UnitDiv']);
                LongStr ( tempLong, tempStr, 'L' );
                NoOfUnits.text := tempstr;

       end;
end;

procedure TEnterpriseSetup.FormActivate(Sender: TObject);
begin
        EntGrid.RowCount := 2;
        Entgrid.Cells[0,0] := 'Code';
        Entgrid.Cells[1,0] := 'Enterprise Name';
        FillGrid;
        UnitName.ReadOnly := true;
        UnitName.Color := clsilver;
        NoOfUnits.ReadOnly := true;
        NoOfUnits.Color := clsilver;
        Overheads.ReadOnly := true;
        Overheads.Color := clsilver;
        Qty2Name.ReadOnly := true;
        Qty2Name.Color := clsilver;
        Qty3Name.ReadOnly := true;
        Qty3Name.Color := clsilver;
end;

procedure TEnterpriseSetup.EntGridClick(Sender: TObject);
begin
       FillDetails(Entgrid.Cells[EntGrid.col,EntGrid.row]);
end;

procedure TEnterpriseSetup.ChangeBtnClick(Sender: TObject);
begin
        UnitName.ReadOnly := false;
        UnitName.Color := clwhite;
        NoOfUnits.ReadOnly := false;
        NoOfUnits.Color := clwhite;
        Overheads.ReadOnly := false;
        Overheads.Color := clwhite;
        Qty2Name.ReadOnly := false;
        Qty2Name.Color := clwhite;
        Qty3Name.ReadOnly := false;
        Qty3Name.Color := clwhite;
        ChangeBtn.enabled := False;
        SaveBtn.Enabled := True;
        CancelBtn.Enabled := True;
        ExitBtn.enabled := False;
        EntGrid.enabled := False;
end;

procedure TEnterpriseSetup.CancelBtnClick(Sender: TObject);
begin

        FillDetails(Entgrid.Cells[EntGrid.col,EntGrid.row]);    // refill the boxes with the old data

        UnitName.ReadOnly := true;
        UnitName.Color := clsilver;
        NoOfUnits.ReadOnly := true;
        NoOfUnits.Color := clsilver;
        Overheads.ReadOnly := true;
        Overheads.Color := clsilver;
        Qty2Name.ReadOnly := true;
        Qty2Name.Color := clsilver;
        Qty3Name.ReadOnly := true;
        Qty3Name.Color := clsilver;
        ChangeBtn.enabled := true;
        SaveBtn.Enabled := false;
        CancelBtn.Enabled := false;
        ExitBtn.enabled := true;
        EntGrid.enabled := true;
end;

procedure TEnterpriseSetup.SaveBtnClick(Sender: TObject);
var
        EntCode : string;
        Tempstr, tempstr2 : shortstring;
        templong : biglong;

begin
        EntCode := Entgrid.Cells[0,Entgrid.row];

        Accsdatamodule.EntsFileDB.locate('EntCode',EntCode,[]);
        Accsdatamodule.EntsFileDB.edit;

        Accsdatamodule.EntsFileDB['UnitText'] := UnitName.Text;

        Tempstr :=  Accsdatamodule.EntsFileDB['EntName'];
        PadRight ( Tempstr, 20 );
        Tempstr := Copy ( Tempstr, 1, 17 );
        Tempstr2 := Overheads.Text;
        PadRight ( Tempstr2, 3 );
        TempStr := Tempstr + Tempstr2;
        Accsdatamodule.EntsFileDB['EntName'] := Tempstr;

        Accsdatamodule.EntsFileDB['Quantity2Name'] := Qty2Name.text;
        Accsdatamodule.EntsFileDB['Quantity3Name'] := Qty3Name.text;

        StrLong (NoOfUnits.Text, templong );
        accsdatamodule.EntsFileDB['UnitDiv'] := templong/100;

        Accsdatamodule.EntsFileDB.post;

        FillDetails(Entgrid.Cells[EntGrid.col,EntGrid.row]);    // refill the boxes with the data

        UnitName.ReadOnly := true;
        UnitName.Color := clsilver;
        NoOfUnits.ReadOnly := true;
        NoOfUnits.Color := clsilver;
        Overheads.ReadOnly := true;
        Overheads.Color := clsilver;
        Qty2Name.ReadOnly := true;
        Qty2Name.Color := clsilver;
        Qty3Name.ReadOnly := true;
        Qty3Name.Color := clsilver;
        ChangeBtn.enabled := true;
        SaveBtn.Enabled := false;
        CancelBtn.Enabled := false;
        ExitBtn.enabled := true;
        EntGrid.enabled := true;
end;

procedure TEnterpriseSetup.NoOfUnitsExit(Sender: TObject);
begin
         SetToLong ( EnterpriseSetup.NoOfUnits);
end;

end.
