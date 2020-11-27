inherited fmCoOpSelect: TfmCoOpSelect
  Left = 487
  Top = 346
  Width = 396
  Height = 354
  ActiveControl = CoOpGrid
  Caption = 'Select CoOp Name'
  Font.Height = -13
  Font.Name = 'Segoe UI'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 17
  inherited StatusBar: TdxStatusBar
    Top = 303
    Width = 388
    Visible = False
  end
  object CoOpGrid: TcxGrid [1]
    Left = 20
    Top = 90
    Width = 343
    Height = 203
    TabOrder = 5
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    object CoOpGridDBTableView: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      NavigatorButtons.First.Visible = True
      NavigatorButtons.PriorPage.Visible = True
      NavigatorButtons.Prior.Visible = True
      NavigatorButtons.Next.Visible = True
      NavigatorButtons.NextPage.Visible = True
      NavigatorButtons.Last.Visible = True
      NavigatorButtons.Insert.Visible = True
      NavigatorButtons.Delete.Visible = True
      NavigatorButtons.Edit.Visible = True
      NavigatorButtons.Post.Visible = True
      NavigatorButtons.Cancel.Visible = True
      NavigatorButtons.Refresh.Visible = True
      NavigatorButtons.SaveBookmark.Visible = True
      NavigatorButtons.GotoBookmark.Visible = True
      NavigatorButtons.Filter.Visible = True
      DataController.DataSource = AccsDataModule.dsImportDefaults
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnFiltering = False
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnHidingOnGrouping = False
      OptionsCustomize.ColumnHorzSizing = False
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.DataRowHeight = 22
      OptionsView.GridLines = glHorizontal
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 21
      object CoOpGridDBTableViewID: TcxGridDBColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        Hidden = True
      end
      object CoOpGridDBTableViewUseAsDefault: TcxGridDBColumn
        DataBinding.FieldName = 'UseAsDefault'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.OnChange = CoOpGridDBTableViewUseAsDefaultPropertiesChange
        HeaderGlyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000920B0000920B00000000000000000000FF00FF097EC9
          096EB0096EB0096EB0096EB0096EB0096EB0096EB0096EB0096EB0096EB0096E
          B0096EB0096EB0FF00FFFF00FF0B8ADA4AC8FD4AC8FD4AC8FD4AC8FD4AC8FD4A
          C8FD4AC8FD4AC8FD4AC8FD4AC8FD4AC8FD4AC8FD096EB0FF00FFFF00FF0B8ADA
          4AC8FDACABAB9A9D9E9A9D9E9A9D9E9A9D9E9A9D9E9A9D9E9A9D9E9A9D9E9A9D
          9E4AC8FD096EB0FF00FFFF00FF0B8ADA4AC8FDACABABFEFEFDFEFEFDFEFEFDFE
          FEFDFEFEFDFEFEFDFEFEFDFEFEFD9A9D9E4AC8FD096EB0FF00FFFF00FF0B8ADA
          4AC8FDACABABFEFEFDFBFBFC5454D4E3E3F7FEFEFDFEFEFDFEFEFDFEFEFD9A9D
          9E4AC8FD096EB0FF00FFFF00FF0B8ADA4AC8FDACABABFEFEFDB3B3EB0000C024
          24C9FBFBFCFEFEFDFEFEFDFEFEFD9A9D9E4AC8FD096EB0FF00FFFF00FF0B8ADA
          4AC8FDACABABFEFEFD4040CF0C0CC30000C09B9BE5FEFEFDFEFEFDFEFEFD9A9D
          9E4AC8FD096EB0FF00FFFF00FF0B8ADA4AC8FDACABAB8B8BE10000C07070DB64
          64D81818C6EFEFF9FEFEFDFEFEFD9A9D9E4AC8FD096EB0FF00FFFF00FF0B8ADA
          4AC8FDACABAB8787E11C1CC7E3E3F7EFEFF92020C86060D7FEFEFDFEFEFD9A9D
          9E4AC8FD096EB0FF00FFFF00FF0B8ADA4AC8FDACABABFEFEFDFEFEFDFEFEFDFE
          FEFDCBCBF10C0CC3AFAFEAFEFEFD9A9D9E4AC8FD096EB0FF00FFFF00FF0B8ADA
          4AC8FDACABABFEFEFDFEFEFDFEFEFDFEFEFDFEFEFDABABE91414C5DFDFF69A9D
          9E4AC8FD096EB0FF00FFFF00FF0B8ADA4AC8FDACABABFEFEFDFEFEFDFEFEFDFE
          FEFDFEFEFDFEFEFDABABE93434CC93969F4AC8FD096EB0FF00FFFF00FF0B8ADA
          4AC8FDACABABFEFEFDFEFEFDFEFEFDFEFEFDFEFEFDFEFEFDFEFEFDABABE92B2C
          B647BFFA096EB0FF00FFFF00FF0B84D14AC8FDACABABACABAB8D92956C707261
          6160616160616160616160ACABAB8C8BAF235EDD0A7BC4FF00FFFF00FFFF00FF
          0B84D10B84D10B84D19DA1A3FFFFFFE5E6E7E5E6E7B5B7B96161600A70B10A7B
          C40A7BC4FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9DA1A39D
          A1A39DA1A38D9295FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        HeaderGlyphAlignmentHorz = taCenter
        Width = 34
        IsCaptionAssigned = True
      end
      object CoOpGridDBTableViewCoOpName: TcxGridDBColumn
        Caption = 'CoOp Name'
        DataBinding.FieldName = 'CoOpName'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        SortIndex = 0
        SortOrder = soAscending
        Width = 285
      end
    end
    object CoOpGridLevel: TcxGridLevel
      GridView = CoOpGridDBTableView
    end
  end
  object cxLabel1: TcxLabel [2]
    Left = 18
    Top = 68
    AutoSize = False
    Caption = 'To select a CoOp, click on the tick box left of the Name.'
    Style.TextStyle = []
    Height = 21
    Width = 347
  end
  inherited BarManager: TdxBarManager
    Bars = <
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        Caption = 'Main'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsTop
        FloatLeft = 301
        FloatTop = 201
        FloatClientWidth = 0
        FloatClientHeight = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        IsMainMenu = True
        ItemLinks = <>
        MultiLine = True
        Name = 'Main'
        OneOnRow = True
        Row = 0
        ShowMark = False
        SizeGrip = False
        UseOwnFont = True
        UseRestSpace = True
        Visible = False
        WholeRow = True
        BackgroundBitmap.Data = {00000000}
      end
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        Caption = 'TopToolbar'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsTop
        FloatLeft = 301
        FloatTop = 201
        FloatClientWidth = 0
        FloatClientHeight = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemLinks = <
          item
            Item = blbExit
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbHelp
            UserGlyph.Data = {00000000}
            Visible = True
          end>
        Name = 'TopToolbar'
        OneOnRow = True
        Row = 0
        ShowMark = False
        SizeGrip = False
        UseOwnFont = True
        UseRestSpace = True
        Visible = True
        WholeRow = True
        BackgroundBitmap.Data = {00000000}
      end>
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    DockControlHeights = (
      0
      0
      48
      0)
    inherited blbView: TdxBarLargeButton
      ImageIndex = 8
    end
    inherited blbPrint: TdxBarLargeButton
      ImageIndex = 17
    end
    inherited blbHelp: TdxBarLargeButton
      ImageIndex = 33
    end
    inherited blbFirst: TdxBarLargeButton
      ImageIndex = 23
    end
    inherited blbNext: TdxBarLargeButton
      ImageIndex = 24
    end
    inherited blbLast: TdxBarLargeButton
      ImageIndex = 26
    end
    inherited blbPrior: TdxBarLargeButton
      ImageIndex = 24
    end
    inherited blbSave2: TdxBarLargeButton
      ImageIndex = 9
    end
    inherited blbCancel2: TdxBarLargeButton
      ImageIndex = 10
    end
  end
end
