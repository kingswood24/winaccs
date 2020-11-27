object NewListBox: TNewListBox
  Left = 518
  Top = 259
  Width = 419
  Height = 453
  Caption = 'NewListBox'
  Color = clBtnFace
  Constraints.MinHeight = 450
  Constraints.MinWidth = 364
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object List: TStringGrid
    Left = 0
    Top = 41
    Width = 403
    Height = 314
    Align = alClient
    ColCount = 2
    DefaultRowHeight = 22
    FixedCols = 0
    RowCount = 7
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goThumbTracking]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnDblClick = ListDblClick
    OnSelectCell = ListSelectCell
    ColWidths = (
      52
      74)
  end
  object pActionPanel: TPanel
    Left = 0
    Top = 355
    Width = 403
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Bevel1: TBevel
      Left = 7
      Top = 9
      Width = 389
      Height = 7
      Anchors = [akLeft, akTop, akRight]
      Shape = bsTopLine
    end
    object pButtons: TPanel
      Left = 0
      Top = 12
      Width = 403
      Height = 48
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object pCancel: TPanel
        Left = 319
        Top = 0
        Width = 84
        Height = 48
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 0
        object btnCancel: TcxButton
          Left = 3
          Top = 8
          Width = 75
          Height = 28
          Action = actCancel
          Anchors = [akTop, akRight]
          ModalResult = 2
          TabOrder = 0
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00002EE4001B48FB00FF00FF001B48
            FB00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00002EE4001B48FB00FF00FF00FF00FF001B48
            FB003E5EFF00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00002EE4001B48FB00FF00FF00FF00FF00FF00FF001B48
            FB001B48FB003E5EFF00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00002EE4001B48FB00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF003E5EFF001B48FB003E5EFF00002EE400FF00FF00FF00FF00FF00FF00FF00
            FF00002EE4001B48FB00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF001B48FB003E5EFF00002EE400FF00FF00FF00FF00002E
            E400002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF001B48FB003E5EFF00002EE400002EE400002E
            E400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF001B48FB001B48FB001B48FB00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF001B48FB003E5EFF001B48FB003E5EFF00002E
            E400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF001B48FB003E5EFF00002EE400FF00FF00FF00FF001B48
            FB00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF001B48FB003E5EFF00002EE400FF00FF00FF00FF00FF00FF00FF00
            FF001B48FB00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF001B48FB003E5EFF00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF001B48FB00002EE400FF00FF00FF00FF00FF00FF00FF00FF001B48
            FB006482FF00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00002EE400FF00FF00FF00FF001B48FB006482
            FF00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF001B48FB001B48
            FB00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          LookAndFeel.NativeStyle = True
        end
      end
      object pNew: TPanel
        Left = 235
        Top = 0
        Width = 84
        Height = 48
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        object btnNew: TcxButton
          Left = 3
          Top = 8
          Width = 75
          Height = 28
          Action = actNew
          Anchors = [akTop, akRight]
          TabOrder = 0
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528000FA528000FA528000FA5
            2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0051CD83000FA5
            2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0038C273000FA5
            2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0038C273000FA5
            2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0038C273000FA5
            2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000FA5
            28000FA528000FA528000FA528000FA528000FA528007EE09E0038C273000FA5
            28000FA528000FA528000FA528000FA528000FA52800FF00FF00FF00FF000FA5
            28007EE09E0038C2730038C2730038C2730038C2730038C2730038C2730038C2
            730038C2730038C2730038C2730051CD83000FA52800FF00FF00FF00FF000FA5
            28005FD38B005FD38B005FD38B005FD38B005FD38B0051CD830038C273005FD3
            8B005FD38B005FD38B005FD38B005FD38B000FA52800FF00FF00FF00FF000FA5
            28000FA528000FA528000FA528000FA528000FA528007EE09E0038C273000FA5
            28000FA528000FA528000FA528000FA528000FA52800FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0038C273000FA5
            2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0038C273000FA5
            2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0038C273000FA5
            2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF000FA5280051CD83005FD38B000FA5
            2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528000FA528000FA528000FA5
            2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          LookAndFeel.NativeStyle = True
        end
      end
      object pSelect: TPanel
        Left = 151
        Top = 0
        Width = 84
        Height = 48
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 2
        object btnSelect: TcxButton
          Left = 3
          Top = 8
          Width = 75
          Height = 28
          Action = actSelect
          Anchors = [akTop, akRight]
          Default = True
          TabOrder = 0
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF002B934800FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF002B93480031A648002B934800FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00399B610031A6480031A6480031A648002B934800FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF002B93480031A6480037B7550033A1580031A648002B934800FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF003F94
            660031A6480037B755002F8D58002F8D580037B7550043A1460037B75500FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF002B93
            480037B755002F8D5800FF00FF00FF00FF002F8D580037B755002B934800FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF002F8D5800FF00FF00FF00FF00FF00FF00FF00FF002F8D580037B755002B93
            4800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF002F8D580037B7
            550037B75500FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF002F8D
            580031A64800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF002F8D580031A64800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF002F8D580031A64800FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF002F8D580031A64800FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF002F8D580031A64800FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF002F8D5800FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = True
        end
      end
    end
  end
  object p: TPanel
    Left = 0
    Top = 0
    Width = 403
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'p'
    TabOrder = 2
    object Searchlabel: TLabel
      Left = 6
      Top = 14
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Anchors = [akLeft, akBottom]
      Caption = 'Search'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Searchfield: TcxTextEdit
      Left = 53
      Top = 9
      Hint = 'Enter Account Name to Search For'
      HelpContext = 80
      Anchors = [akLeft, akRight, akBottom]
      AutoSize = False
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Properties.CharCase = ecUpperCase
      Properties.OnChange = SearchfieldPropertiesChange
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 0
      OnKeyDown = SearchfieldKeyDown
      Height = 24
      Width = 337
    end
  end
  object ActionList1: TActionList
    Images = AccsDataModule.ImageList16x16
    Left = 256
    Top = 134
    object actCancel: TAction
      Caption = 'Cancel'
      ImageIndex = 10
      OnExecute = actCancelExecute
    end
    object actNew: TAction
      Caption = 'New'
      ImageIndex = 16
      OnExecute = actNewExecute
      OnUpdate = actNewUpdate
    end
    object actSelect: TAction
      Caption = 'Select'
      ImageIndex = 9
      OnExecute = actSelectExecute
    end
  end
end