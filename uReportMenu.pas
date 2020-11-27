unit uReportMenu;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cxStyles, dxNavBarCollns, cxClasses, dxNavBarBase, ExtCtrls, dxNavBar,
  dxNavBarStyles, RXCtrls, ActnList, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxMaskEdit, cxSpinEdit, cxSpinButton,
  StdCtrls, dxBar, cxButtons, dxBarExtDBItems, dxBarExtItems, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, cxLabel, cxLookAndFeels,
  Menus;

type
  TReportMenu = class(TCustomPanel)
  private
    Labels : array [0..6] of TcxLabel;
    UpButton : Tcxbutton;
    DownButton : Tcxbutton;
    FReportMenuItems : TStringList;
    FTopIndex: Integer;
    FPaintMenuItems : Boolean;
    FNavBarPopupMenu: TdxBarPopupMenu;
    FPoint : TPoint;
    FTimer : TTimer;
    FViewStatus: string;
    FNavBar: TdxNavBar;
    procedure SetTopIndex(const Value: Integer);
    function GetLabel(Index: Integer): TcxLabel;
    procedure PanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PanelMouseEnter(Sender: TObject);
    procedure PanelMouseLeave(Sender: TObject);
    procedure LabelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure LabelMouseEnter(Sender: TObject);
    procedure LabelMouseLeave(Sender: TObject);
    procedure LabelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LabelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UpButtonClick(Sender : TObject);
    procedure DownButtonClick(Sender : TObject);
    procedure LabelClick(Sender : TObject);
    procedure OnTimer(Sender: TObject);
    procedure PopupReportsMenu();
    procedure HideNavBarPopupMenu;
    function GetActionByName(AActionName : string) : TContainedAction;
  protected
  public
    ActionList  : TActionList;
    constructor Create(AOwner: TComponent); override;
    destructor destroy; override;
    procedure DrawMenu;
    procedure UpdateMenuItems;
    procedure AddItem(AAction : TAction);
    property TopIndex : Integer read FTopIndex write SetTopIndex;
    property AccessLabels[Index : Integer] : TcxLabel read GetLabel;
    property NavBarPopupMenu : TdxBarPopupMenu read FNavBarPopupMenu write FNavBarPopupMenu;
    property ViewStatus : string read FViewStatus;
    property Navbar : TdxNavBar read FNavBar write FNavBar;
  end;

implementation

{ TReportMenu }

procedure TReportMenu.AddItem(AAction : TAction);
var
   ShowNavButtons : Boolean;
begin
   FReportMenuItems.AddObject(AAction.Caption, AAction);
   Height := Height + 30;
end;

constructor TReportMenu.Create(AOwner: TComponent);
var
   i : Integer;
   LabelTopPosition : Integer;
begin
   inherited Create(AOwner);
   NavBarPopupMenu := nil;
   Width := 302;
   FTopIndex := 0;
   Color := clWhite;
   Align := alClient;
   BevelInner := bvNone;
   BevelOuter := bvNone;
   LabelTopPosition := 8;
   OnMouseMove := PanelMouseMove;
   OnEnter := PanelMouseEnter;
   FPaintMenuItems := True;
   for i := low(Labels) to High(Labels) do
      begin
         Labels[i] := TcxLabel.Create(AOwner);
         Labels[i].Parent := Self;
         Labels[i].AutoSize := False;
         Labels[i].Properties.Alignment.Horz := taCenter;
         Labels[i].Properties.Alignment.Vert := taVCenter;
         Labels[i].Style.TextColor := $006C4D39;
         Labels[i].Width := Width-8;
         Labels[i].Top := LabelTopPosition;
         Labels[i].Left := 8;
         Labels[i].Height := 32;
         Labels[i].Style.Font.Name := 'Segoe UI';
         Labels[i].Style.Font.Size := 11;
         Labels[i].Style.Font.Style := [fsBold];
         Inc(LabelTopPosition, 30);
         Labels[i].Style.BorderStyle := ebsNone;
         Labels[i].Style.LookAndFeel.NativeStyle := False;
         Labels[i].Style.LookAndFeel.Kind := lfUltraFlat;

         Labels[i].StyleHot.TextColor := clRed;
         Labels[i].StyleHot.BorderStyle := ebsNone;

         Labels[i].StyleFocused.TextColor := clBlue;
         Labels[i].StyleFocused.BorderStyle := ebsNone;


         Labels[i].OnMouseDown := LabelMouseDown;
         Labels[i].OnMouseMove := LabelMouseMove;
         Labels[i].OnMouseEnter := LabelMouseEnter;
         Labels[i].OnMouseLeave := LabelMouseLeave;

         Labels[i].OnMouseUp := LabelMouseUp;

         Labels[i].OnClick := LabelClick;
         Labels[i].Cursor := crHandPoint;
      end;

   UpButton := Tcxbutton.Create(AOwner);
   UpButton.Parent := Self;
   UpButton.LookAndFeel.NativeStyle := False;
   UpButton.LookAndFeel.Kind := lfUltraFlat;
   UpButton.Font.Name := 'Segoe UI';
   UpButton.Font.Size := 8;
   UpButton.Width := 20;
   UpButton.Left := 215;
   UpButton.Height := 20;
   UpButton.Top := Labels[0].Top + 2;
   UpButton.Colors.Normal := clWhite;
   UpButton.Colors.Hot := $00F2F2F2;
   UpButton.Colors.Pressed := $00DBDBDB;
   UpButton.Colors.Disabled := clGray;
   UpButton.OnClick := UpButtonClick;
   UpButton.Visible := False;

   DownButton := Tcxbutton.Create(AOwner);
   DownButton.Parent := Self;
   DownButton.LookAndFeel.NativeStyle := False;
   DownButton.LookAndFeel.Kind := lfUltraFlat;
   DownButton.Font.Name := 'Segoe UI';
   DownButton.Font.Size := 8;
   DownButton.Width := 20;
   DownButton.Left := 215;
   DownButton.Height := 20;
   DownButton.Top := Labels[3].Top + 2;
   DownButton.Colors.Normal := clWhite;
   DownButton.Colors.Hot := $00F2F2F2;
   DownButton.Colors.Pressed := $00DBDBDB;
   DownButton.Colors.Disabled := clGray;
   DownButton.OnClick := DownButtonClick;
   DownButton.Visible := False;


   FReportMenuItems := TStringList.Create;
end;

destructor TReportMenu.destroy;
var
   i : Integer;
begin
  FreeAndNil(FReportMenuItems);
   for i := low(Labels) to High(Labels) do
      FreeAndNil(Labels[i]);
  FreeAndNil(UpButton);
  FreeAndNil(DownButton);
  inherited;
end;

procedure TReportMenu.DrawMenu;
var
   i, j, cc : Integer;
   LabelIndex, BottomIndex, LabelLeft, LabelWidth : Integer;
   Index : Integer;
   Action : TAction;

begin
   LabelIndex := 0;

   // this needs further work when accounts reports are expanded. This
   // code will break if report item count is less than 4
   if ( FReportMenuItems.Count < 4 ) then
      begin
         if ( FReportMenuItems.Count = 3 ) then
            Labels[3].Visible := false
         else if ( FReportMenuItems.Count = 2 ) then
            begin
               Labels[3].Visible := false;
               Labels[2].Visible := false;

            end
         else if ( FReportMenuItems.Count = 1 ) then
            begin
               Labels[3].Visible := false;
               Labels[2].Visible := false;
               Labels[1].Visible := false;

            end
         else
            begin
               Labels[3].Visible := false;
               Labels[2].Visible := false;
               Labels[1].Visible := false;
               Labels[0].Visible := false;

            end;
      end;

   BottomIndex := FReportMenuItems.Count-1;
   if ( BottomIndex > 5 ) then
      begin
         BottomIndex := FTopIndex+Length(Labels)-1;
      end;

   for i := 0 to FReportMenuItems.Count-1 do
      begin
         Labels[LabelIndex].Caption := FReportMenuItems.Strings[i];
         Labels[LabelIndex].Width := 260;
         LabelLeft := Trunc((Width - Labels[LabelIndex].Width) / 2);
         Labels[LabelIndex].Left := LabelLeft;
         Index := FReportMenuItems.IndexOf(Labels[LabelIndex].Caption);
         Action := TAction(FReportMenuItems.Objects[Index]);
         if Action <> nil then
            begin
               Labels[LabelIndex].Visible := True;
               Labels[LabelIndex].Enabled := Action.Enabled;
            end
         else
            Labels[LabelIndex].Visible := False;
         Inc(LabelIndex);
      end;
end;

procedure TReportMenu.LabelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  r : TRect;
begin
   if ( not FPaintMenuItems ) or (( Sender as TcxLabel).Caption='') then  Exit;
   if ( button = mbLeft ) and ( ssLeft in Shift ) then
      begin
         ( Sender as TcxLabel).Style.Color := $00FBC695;
         ( Sender as TcxLabel).Style.TextColor := Color;
         ( Sender as TcxLabel).Style.BorderStyle := ebsSingle;
         ( Sender as TcxLabel).invalidate;
         ( Sender as TcxLabel).Repaint;
         ( Sender as TcxLabel).Update;
      end;
end;

procedure TReportMenu.LabelMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
   if ( not FPaintMenuItems ) or (( Sender as TcxLabel).Caption='') then  Exit;

   ( Sender as TcxLabel).Style.TextColor := $006C4D39;
   ( Sender as TcxLabel).Style.Color := $00FEEAD8;
   ( Sender as TcxLabel).Style.BorderStyle := ebsSingle;
         ( Sender as TcxLabel).invalidate;
         ( Sender as TcxLabel).Repaint;
   ( Sender as TcxLabel).Update;

end;

procedure TReportMenu.LabelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if ( not FPaintMenuItems ) or (( Sender as TcxLabel).Caption='') then  Exit;
         ( Sender as TcxLabel).Style.Color := clWindow;
         ( Sender as TcxLabel).Style.TextColor := $006C4D39;
         ( Sender as TcxLabel).Style.BorderStyle := ebsNone;
         ( Sender as TcxLabel).invalidate;
         ( Sender as TcxLabel).Repaint;
         ( Sender as TcxLabel).Update;
end;

procedure TReportMenu.PanelMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
   UpdateMenuItems;
end;

procedure TReportMenu.SetTopIndex(const Value: Integer);
begin
   FTopIndex := Value;
   DrawMenu;
end;

procedure TReportMenu.UpButtonClick(Sender: TObject);
begin
   if ( FTopIndex > 0 ) then
      begin
         Dec(FTopIndex);
         DrawMenu;
      end
end;

procedure TReportMenu.DownButtonClick(Sender: TObject);
begin
   if ( (FReportMenuItems.Count-1) - (FTopIndex+3)) > 0 then
      begin
         Inc(FTopIndex);
         DrawMenu;
      end;
end;

procedure TReportMenu.UpdateMenuItems;
var
   i, cc : Integer;
begin
   if not FPaintMenuItems then  Exit;

   cc := ControlCount-1;
   for i := 0 to cc do
      begin
         if ( Controls[i] is TcxLabel) then
            begin
               ( Controls[i] as TcxLabel).Style.TextColor := $0074523D;
               ( Controls[i] as TcxLabel).Style.Color := clWhite;
               ( Controls[i] as TcxLabel).Style.BorderStyle := ebsNone;
               ( Controls[i] as TcxLabel).invalidate;
               ( Controls[i] as TcxLabel).Repaint;
               ( Controls[i] as TcxLabel).Update;
            end;
      end;
end;

function TReportMenu.GetLabel(Index: Integer): TcxLabel;
begin
   Result := Labels[Index];
end;

procedure TReportMenu.LabelClick(Sender: TObject);
var
   Index : Integer;
   Action : TAction;
begin
   try
   FPaintMenuItems := False;
   if (Sender is TcxLabel) then
      begin
         Index := FReportMenuItems.IndexOf((Sender as TcxLabel).Caption);
         if ( Index > -1 ) then
            begin
               Action := TAction(FReportMenuItems.Objects[Index]);
               if Action <> nil then
                  begin
                     UpdateMenuItems;
                     Action.Execute;
                  end;
            end;
      end;
   finally
      FPaintMenuItems := True;
   end;

end;

procedure TReportMenu.OnTimer(Sender: TObject);
begin
end;

procedure TReportMenu.PanelMouseLeave(Sender: TObject);
begin

end;

procedure TReportMenu.PopupReportsMenu;
var
   NavBarName : string;
   BarItemLink : TdxBarItemLink;
   BarButton : TdxBarButton;
   i : Integer;
   ParentTag : Integer;
begin
   if FNavBarPopupMenu <> nil then
      FNavBarPopupMenu.ItemLinks.Clear;

   if (Self.Parent = nil) or (FNavBarPopupMenu = nil) then Exit;

   NavBarName := '';

   if (Self.Parent is TdxNavBarGroupControl) then
      begin
         ParentTag := Self.Parent.Tag;
         if ((Self.Parent as TdxNavBarGroupControl).Parent is TdxNavBar ) then
            begin
               NavBarName := ((Self.Parent as TdxNavBarGroupControl).Parent as TdxNavBar ).Name;
            end;
      end;

   for i := 0 to ActionList.ActionCount-1 do
      begin
         if (ActionList.Actions[i].Tag = ParentTag ) then
            begin
               BarButton := TdxBarButton.Create(FNavBarPopupMenu);
               BarButton.Action := ActionList.Actions[i];
               BarItemLink := FNavBarPopupMenu.ItemLinks.Add;
               BarItemLink.Item := BarButton;
            end
      end;

   GetCursorPos(FPoint);
   FNavBarPopupMenu.Popup(FPoint.x, FPoint.Y);
end;

function TReportMenu.GetActionByName(AActionName: string): TContainedAction;
var
  i : Integer;
begin
   Result := nil;
   for i := 0 to ActionList.ActionCount-1 do
      if ActionList.Actions[i].Name = AActionName then
         Result := ActionList.Actions[i];
end;

procedure TReportMenu.LabelMouseEnter(Sender: TObject);
begin
end;

procedure TReportMenu.LabelMouseLeave(Sender: TObject);
begin
end;

procedure TReportMenu.HideNavBarPopupMenu;
var
   pt : TPoint;
begin
   GetCursorPos(pt);
   if (FNavBarPopupMenu <> nil ) and (FNavBarPopupMenu.SubMenuControl <> nil) then
      begin
         pt := FNavBarPopupMenu.SubMenuControl.ScreenToClient(pt);
         if (FNavBarPopupMenu.SubMenuControl.ItemAtPos(pt) = nil) then
            FNavBarPopupMenu.SubMenuControl.Hide;
      end;
end;

procedure TReportMenu.PanelMouseEnter(Sender: TObject);
begin
end;

end.
