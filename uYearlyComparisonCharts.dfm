object fmYearlyComparisonCharts: TfmYearlyComparisonCharts
  Left = 343
  Top = 174
  Width = 783
  Height = 580
  Caption = 'Yearly Comparison Charts'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object YearComparisonChart: TDBChart
    Left = 0
    Top = 55
    Width = 775
    Height = 491
    AllowPanning = pmNone
    BackWall.Gradient.EndColor = clWhite
    BackWall.Gradient.StartColor = 15395562
    BackWall.Gradient.Visible = True
    BackWall.Transparent = False
    Border.Color = 14645801
    Border.Width = 7
    BottomWall.Gradient.EndColor = 16580349
    BottomWall.Gradient.StartColor = 3114493
    Foot.Font.Name = 'Verdana'
    Gradient.EndColor = clWhite
    Gradient.MidColor = 15395562
    Gradient.StartColor = 15395562
    Gradient.Visible = True
    LeftWall.Color = 14745599
    LeftWall.Gradient.EndColor = 2413052
    LeftWall.Gradient.StartColor = 900220
    RightWall.Color = 14745599
    SubFoot.Font.Name = 'Verdana'
    SubTitle.Font.Name = 'Verdana'
    Title.Color = clBlack
    Title.Font.Name = 'Verdana'
    Title.Font.Style = [fsBold]
    Title.Frame.Color = 10083835
    Title.Frame.Width = 2
    Title.Shadow.HorizSize = 4
    Title.Shadow.Transparency = 70
    Title.Shadow.VertSize = 4
    Title.Text.Strings = (
      '')
    BottomAxis.Axis.Color = 4210752
    BottomAxis.Grid.Color = 11119017
    BottomAxis.LabelsFont.Name = 'Verdana'
    BottomAxis.MinorGrid.Color = 15066597
    BottomAxis.MinorTicks.Color = clBlack
    BottomAxis.TicksInner.Color = 11119017
    BottomAxis.Title.Font.Name = 'Verdana'
    DepthAxis.Axis.Color = 4210752
    DepthAxis.Grid.Color = 11119017
    DepthAxis.LabelsFont.Name = 'Verdana'
    DepthAxis.MinorTicks.Color = clBlack
    DepthAxis.TicksInner.Color = 11119017
    DepthAxis.Title.Font.Name = 'Verdana'
    DepthTopAxis.Axis.Color = 4210752
    DepthTopAxis.Grid.Color = 11119017
    DepthTopAxis.LabelsFont.Name = 'Verdana'
    DepthTopAxis.MinorTicks.Color = clBlack
    DepthTopAxis.TicksInner.Color = 11119017
    DepthTopAxis.Title.Font.Name = 'Verdana'
    LeftAxis.Axis.Color = 4210752
    LeftAxis.Grid.Color = 11119017
    LeftAxis.LabelsFont.Name = 'Verdana'
    LeftAxis.MinorTicks.Color = clBlack
    LeftAxis.TicksInner.Color = 11119017
    LeftAxis.Title.Font.Name = 'Verdana'
    Legend.Color = clInfoBk
    Legend.DividingLines.Color = clSilver
    Legend.Font.Color = 6553600
    Legend.Font.Name = 'Verdana'
    Legend.Gradient.Direction = gdTopBottom
    Legend.Gradient.EndColor = clYellow
    Legend.Gradient.StartColor = clWhite
    Legend.Shadow.Color = clGray
    Legend.Symbol.Squared = True
    RightAxis.Axis.Color = 4210752
    RightAxis.Grid.Color = 11119017
    RightAxis.LabelsFont.Name = 'Verdana'
    RightAxis.MinorTicks.Color = clBlack
    RightAxis.TicksInner.Color = 11119017
    RightAxis.Title.Font.Name = 'Verdana'
    Shadow.Color = clBlack
    TopAxis.Axis.Color = 4210752
    TopAxis.Grid.Color = 11119017
    TopAxis.LabelsFont.Name = 'Verdana'
    TopAxis.MinorGrid.Color = 15066597
    TopAxis.MinorTicks.Color = clBlack
    TopAxis.TicksInner.Color = 11119017
    TopAxis.Title.Font.Name = 'Verdana'
    View3D = False
    Zoom.Allow = False
    OnGetAxisLabel = YearComparisonChartGetAxisLabel
    Align = alClient
    TabOrder = 0
    PrintMargins = (
      15
      26
      15
      26)
    ColorPaletteIndex = 1
    object DBChart1: TDBChart
      Left = 908
      Top = 4
      Width = 50
      Height = 50
      BackWall.Pen.Visible = False
      BottomWall.Pen.Visible = False
      BottomWall.Size = 4
      LeftWall.Pen.Visible = False
      LeftWall.Size = 4
      Title.Alignment = taLeftJustify
      Title.Color = clInfoBk
      Title.Font.Color = clBlack
      Title.Font.Height = -13
      Title.Frame.Color = clGray
      Title.Shadow.HorizSize = 0
      Title.Shadow.VertSize = 0
      Title.Text.Strings = (
        '')
      Title.Transparent = False
      BottomAxis.Axis.Color = 4210752
      BottomAxis.Grid.Color = 13421772
      BottomAxis.Grid.Visible = False
      Frame.Visible = False
      LeftAxis.Axis.Color = 4210752
      LeftAxis.Grid.Visible = False
      Legend.Color = clInfoBk
      Legend.Frame.Color = clGray
      Legend.Frame.Visible = False
      Legend.Shadow.Color = 13421772
      View3D = False
      OnGetAxisLabel = YearComparisonChartGetAxisLabel
      Color = clWhite
      TabOrder = 0
      Visible = False
      ColorPaletteIndex = 13
      object DefaultEnterpriseSeries: TFastLineSeries
        Marks.Arrow.Visible = True
        Marks.Callout.Brush.Color = clBlack
        Marks.Callout.Arrow.Visible = True
        Marks.Frame.Color = clGray
        Marks.Gradient.EndColor = 15137774
        Marks.Gradient.StartColor = clWhite
        Marks.Shadow.Color = 13421772
        Marks.Shadow.HorizSize = 2
        Marks.Shadow.SmoothBlur = -31
        Marks.Shadow.VertSize = 2
        Marks.Style = smsValue
        Marks.Visible = False
        SeriesColor = 4227327
        Title = 'DefaultEnterpriseSeries'
        LinePen.Color = 4227327
        LinePen.Width = 3
        LinePen.EndStyle = esSquare
        XValues.Name = 'X'
        XValues.Order = loAscending
        YValues.Name = 'Y'
        YValues.Order = loNone
        Data = {02010000000000000000000000FFFFFF1F}
      end
      object GridBandTool2: TGridBandTool
        Band1.Color = 15329769
        Band2.Color = clWhite
        AxisID = 2
      end
    end
    object pEntFilter: TPanel
      Left = 371
      Top = -1
      Width = 332
      Height = 51
      BevelOuter = bvNone
      TabOrder = 1
      object cmboYearType: TcxComboBox
        Left = 185
        Top = 23
        Properties.DropDownListStyle = lsFixedList
        Properties.Items.Strings = (
          'Income'
          'Expenditure')
        Properties.OnCloseUp = cmboYearTypePropertiesCloseUp
        Style.BorderStyle = ebsFlat
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        Style.ButtonStyle = btsDefault
        Style.ButtonTransparency = ebtNone
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 0
        Width = 142
      end
      object cmboEnterprise: TcxComboBox
        Left = 13
        Top = 23
        Properties.DropDownListStyle = lsFixedList
        Properties.OnCloseUp = cmboEnterprisePropertiesCloseUp
        Style.BorderStyle = ebsFlat
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        Style.ButtonStyle = btsDefault
        Style.ButtonTransparency = ebtNone
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 1
        Width = 142
      end
      object cxLabel1: TcxLabel
        Left = 12
        Top = 4
        Caption = 'Enterprise:'
      end
      object cxLabel2: TcxLabel
        Left = 184
        Top = 4
        Caption = 'Select: '
      end
    end
    object GridBandTool1: TGridBandTool
      Band1.Color = 15329769
      Band2.Color = clWhite
      AxisID = 2
    end
    object GridBandTool3: TGridBandTool
      Band1.Color = 15329769
      Band2.Color = clWhite
      AxisID = 2
    end
  end
  object dxBarManager: TdxBarManager
    AllowReset = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI'
    Font.Style = []
    Bars = <
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
        FloatLeft = 330
        FloatTop = 182
        FloatClientWidth = 23
        FloatClientHeight = 22
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemLinks = <
          item
            Item = blbExit
            Visible = True
          end
          item
            BeginGroup = True
            Item = dxBarControlContainerItem1
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
      end>
    CanCustomize = False
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    Images = AccsDataModule.ImageList16x16
    LargeImages = AccsDataModule.ImageList16x16
    LookAndFeel.Kind = lfUltraFlat
    PopupMenuLinks = <>
    UseF10ForMenu = False
    UseSystemFont = False
    Left = 976
    Top = 64
    DockControlHeights = (
      0
      0
      55
      0)
    object blbExit: TdxBarLargeButton
      Caption = 'Exit'
      Category = 0
      Hint = 'Exit'
      Visible = ivAlways
      OnClick = blbExitClick
      AutoGrayScale = False
      Height = 44
      HotGlyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000320B0000320B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF096EB0096EB0086098FF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF096EB0096EB01479B814
        79B8086098FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        096EB0096EB01680BF157DBC147AB91479B8086098394A6B394A6B394A6B394A
        6B394A6B394A6BFF00FFFF00FFFF00FF096EB01886C41783C11680BF157DBC14
        7CBA0860983D5B81085A8E085A8E085A8E085A8E394A6BFF00FFFF00FFFF00FF
        096EB01989C71886C41783C11680BF157FBD0860980F49340F47320F46320F45
        31104531394A6BFF00FFFF00FFFF00FF096EB01A8CCA1989C71886C41783C116
        82C0086098164D38164A36154935164633154431394A6BFF00FFFF00FFFF00FF
        096EB01B90CD1A8CCA1989C71886C41785C30860981C7A5B1C7C5E1D7D601E78
        5B1E7257394A6BFF00FFFF00FFFF00FF096EB01B93CF1B90CD22A6E221A2DE18
        88C60860981F83601E79581E6E4F1D6245205E43394A6BFF00FFFF00FFFF00FF
        096EB01C96D21B93CF22A6E2FFFFFF198BC80860985A7662798370959484AF9C
        8ABB9887394A6BFF00FFFF00FFFF00FF096EB01E9AD61C96D21B93CF1B91CE1A
        8ECB086098F0BAA4F0B297F1BFA8F0BFA8F1BFA9394A6BFF00FFFF00FFFF00FF
        096EB01F9EDA1E9AD61C96D21C94D11B91CE086098F0B79EF2BFA9F4E0D7F2C6
        AEF1A581394A6BFF00FFFF00FFFF00FF096EB021A2DE1F9EDA1E9AD61D98D41C
        94D1086098EE7B45F0A27DF1A986EF7D45F08956394A6BFF00FFFF00FFFF00FF
        096EB022A6E221A2DE1F9EDA1E9CD81D98D4086098ED733BEC6F34EB6F33EC6E
        32EE8655394A6BFF00FFFF00FFFF00FF096EB0096EB022A6E221A2DE20A0DC1E
        9CD8086098E96F3CE65F24E76731EE9D7BED946D394A6BFF00FFFF00FFFF00FF
        FF00FFFF00FF096EB0096EB021A4E020A0DC086098394A6B394A6B394A6B394A
        6B394A6B394A6BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF096EB009
        6EB0086098FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      HotImageIndex = 0
      LargeGlyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000420B0000420B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF4A5E8642557C313F5BFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF4A5E8642557C38619038
        6190313F5BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        4A5E8642557C3F67973C6594396291386190313F5B394A6B394A6B394A6B394A
        6B394A6B394A6BFF00FFFF00FFFF00FF4A5E86446D9C416A993F67973C65943A
        6392313F5B3A577A42638C42638C42638C42638C394A6BFF00FFFF00FFFF00FF
        4A5E86476F9F446D9C416A993F67973D6695313F5B0F49340F47320F46320F45
        31104531394A6BFF00FFFF00FFFF00FF4A5E864A72A2476F9F446D9C416A9940
        6998313F5B164D38164A36154935164633154431394A6BFF00FFFF00FFFF00FF
        4A5E864D75A54A72A2476F9F446D9C436B9B313F5B1C7A5B1C7C5E1D7D601E78
        5B1E7257394A6BFF00FFFF00FFFF00FF4A5E864F77A74D75A56188B96188B946
        6E9E313F5B1F83601E79581E6E4F1D6245205E43394A6BFF00FFFF00FFFF00FF
        4A5E86527AAA4F77A76188B9FFFFFF4871A0313F5B5A7662798370959484AF9C
        8ABB9887394A6BFF00FFFF00FFFF00FF4A5E86567EAE527AAA4F77A74E76A64B
        73A3313F5BF0BAA4F0B297F1BFA8F0BFA8F1BFA9394A6BFF00FFFF00FFFF00FF
        4A5E865A81B2567EAE527AAA5179A94E76A6313F5BF0B79EF2BFA9F4E0D7F2C6
        AEF1A581394A6BFF00FFFF00FFFF00FF4A5E865D85B55A81B2567EAE547CAC51
        79A9313F5BEE7B45F0A27DF1A986EF7D45F08956394A6BFF00FFFF00FFFF00FF
        4A5E866188B95D85B55A81B2587FB0547CAC313F5BED733BEC6F34EB6F33EC6E
        32EE8655394A6BFF00FFFF00FFFF00FF42557C4A5E866188B95D85B55B83B358
        7FB0313F5BE96F3CE65F24E76731EE9D7BED946D394A6BFF00FFFF00FFFF00FF
        FF00FFFF00FF4A5E8642557C5F86B75B83B3313F5B394A6B394A6B394A6B394A
        6B394A6B394A6BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF4A5E8642
        557C313F5BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      Width = 68
    end
    object bsFiller: TdxBarStatic
      Caption = 'bsFiller'
      Category = 0
      Hint = 'bsFiller'
      Visible = ivAlways
      Alignment = taRightJustify
      Height = 40
      ShowCaption = False
    end
    object bbHelp: TdxBarButton
      Category = 0
      Visible = ivAlways
      PaintStyle = psCaptionGlyph
    end
    object bbSearchTransaction: TdxBarButton
      Category = 0
      Visible = ivAlways
      PaintStyle = psCaptionGlyph
    end
    object bbClearSearch: TdxBarButton
      Category = 0
      Visible = ivAlways
      PaintStyle = psCaptionGlyph
    end
    object bsiFile: TdxBarSubItem
      Caption = 'File'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object bbPrintPreview: TdxBarButton
      Category = 0
      Visible = ivAlways
      PaintStyle = psCaptionGlyph
    end
    object BarStatic1: TdxBarStatic
      Align = iaClient
      Category = 0
      Visible = ivAlways
      Width = 50
    end
    object BarControlProgressBar: TdxBarControlContainerItem
      Align = iaRight
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarControlContainerItemSearchPanel: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object blbHelp: TdxBarLargeButton
      Category = 0
      Visible = ivAlways
      Height = 36
      Width = 85
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Category = 0
      Visible = ivAlways
      Height = 36
    end
    object dxBarLargeButton4: TdxBarLargeButton
      Category = 0
      Visible = ivAlways
      Height = 36
    end
    object dxBarLargeButton5: TdxBarLargeButton
      Category = 0
      Visible = ivAlways
      Height = 36
    end
    object dxBarContainerItem1: TdxBarContainerItem
      Caption = 'New Item'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = pEntFilter
    end
  end
end
