inherited fmReportBaseForm: TfmReportBaseForm
  Left = 734
  Top = 219
  VertScrollBar.Range = 0
  BorderStyle = bsDialog
  Caption = 'ReportBaseForm'
  ClientHeight = 390
  ClientWidth = 605
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TdxStatusBar
    Top = 370
    Width = 605
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
        ItemLinks = <
          item
            Item = blbExit
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbView
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            Item = blbPrint
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbHelp
            UserGlyph.Data = {00000000}
            Visible = True
          end>
        MultiLine = True
        Name = 'Main'
        OneOnRow = True
        Row = 0
        UseOwnFont = True
        UseRestSpace = True
        Visible = True
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
        DockedTop = 26
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
        ItemLinks = <>
        Name = 'TopToolbar'
        OneOnRow = True
        Row = 1
        UseOwnFont = True
        UseRestSpace = True
        Visible = False
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
      OnClick = blbViewClick
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
  inherited ActionList: TActionList
    Top = 110
  end
end
