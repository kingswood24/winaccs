object JobCardViewerForm: TJobCardViewerForm
  Left = 503
  Top = 254
  Width = 1037
  Height = 414
  Caption = 'JobCardViewerForm'
  Color = clBtnFace
  Constraints.MinWidth = 802
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object cxGrid: TcxGrid
    Left = 0
    Top = 44
    Width = 1021
    Height = 206
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    object cxGridTableView: TcxGridTableView
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
      OnFocusedRecordChanged = cxGridTableViewFocusedRecordChanged
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.DataRowHeight = 26
      OptionsView.GridLines = glHorizontal
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 56
      object cxGridTableViewImport: TcxGridColumn
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              18000000000000030000130B0000130B00000000000000000000FF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF988671FF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FF988671988671FF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF988671EEBA8E988671FF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FF988671EEBA8EFFB47B988671FF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FF988671EEBA8EFFB47BFFB47B98867198
              8671988671988671988671988671988671988671988671FF00FFFF00FF988671
              EEBA8EFFB47BFFB47BFFB47BEEBA8EEEBA8EEEBA8EEEBA8EEEBA8EEEBA8EEEBA
              8EEEBA8E988671FF00FF988671EEBA8EFFB47BFFB47BFFB47BFFB47BFFB47BFF
              B47BFFB47BFFB47BFFB47BFFB47BFFB47BEEBA8E988671FF00FFD0A284F1D2AD
              FFBB81FFBB81FFBB81FFBB81FFBB81FFBB81FFBB81FFBB81FFBB81FFBB81FFBB
              81EEBA8E988671FF00FFFF00FFD0A284F1D2ADFFBB81FFBB81FFBB81F8C197F9
              CAA7F9CAA7F9CAA7F9CAA7F9CAA7F9CAA7F8C197988671FF00FFFF00FFFF00FF
              D0A284F1D2ADFFBB81FFBB81988671D0A284D0A284D0A284D0A284D0A284D0A2
              84D0A284D0A284FF00FFFF00FFFF00FFFF00FFD0A284F1D2ADFFBB81988671FF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFD0A284F1D2AD988671FF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD0A284988671FF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFD0A284FF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
            Kind = bkGlyph
          end>
        Properties.OnButtonClick = cxGridTableViewImportPropertiesButtonClick
        BestFitMaxWidth = 23
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 23
        Options.Filtering = False
        Options.ShowEditButtons = isebAlways
        Options.HorzSizing = False
        Options.Moving = False
        Width = 23
        IsCaptionAssigned = True
      end
      object cxGridTableViewImportedOn: TcxGridColumn
        Caption = 'Imported'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 85
      end
      object cxGridTableViewOperator: TcxGridColumn
        Caption = 'Operator'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        BestFitMaxWidth = 160
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 170
      end
      object cxGridTableViewActivity: TcxGridColumn
        Caption = 'Activity'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        BestFitMaxWidth = 160
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 170
      end
      object cxGridTableViewProduct1: TcxGridColumn
        Caption = 'Product'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        BestFitMaxWidth = 160
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 170
      end
      object cxGridTableViewJobReference: TcxGridColumn
        Caption = 'Job Reference'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 125
      end
      object cxGridTableViewUnitAndQuantity: TcxGridColumn
        Caption = 'Unit &'#13#10'Quantity'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Width = 73
      end
      object cxGridTableViewComment: TcxGridColumn
        Caption = 'Comment'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Hidden = True
        Options.Editing = False
        Options.Filtering = False
        Width = 176
      end
      object cxGridTableViewUploadDate: TcxGridColumn
        Caption = 'Operator Sync'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Hidden = True
        Options.Editing = False
        Width = 107
      end
      object cxGridTableViewStartDateTime: TcxGridColumn
        Caption = 'Started'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Hidden = True
        MinWidth = 125
        Options.Editing = False
        Options.Filtering = False
        Width = 140
      end
      object cxGridTableViewFinishDateTime: TcxGridColumn
        Caption = 'Finished'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Hidden = True
        MinWidth = 125
        Options.Editing = False
        Options.Filtering = False
        Width = 125
      end
      object cxGridTableViewClientJobCardId: TcxGridColumn
        Caption = 'clientJobCardId'
        Visible = False
        Hidden = True
      end
      object cxGridTableViewActivityId: TcxGridColumn
        Visible = False
        Hidden = True
      end
      object cxGridTableViewQuantity: TcxGridColumn
        Visible = False
        Hidden = True
      end
      object cxGridTableViewProduct1Id: TcxGridColumn
        Visible = False
        Hidden = True
      end
      object cxGridTableViewJobCardId: TcxGridColumn
        DataBinding.ValueType = 'Integer'
        Hidden = True
        MinWidth = 64
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.Focusing = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.Sorting = False
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridTableView
    end
  end
  object ViewPanel: TPanel
    Left = 82
    Top = 170
    Width = 729
    Height = 34
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    TabOrder = 0
    object ViewTypeCombo: TcxComboBox
      Left = 63
      Top = 7
      Anchors = [akLeft, akTop, akRight]
      ParentFont = False
      Properties.Alignment.Horz = taLeftJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownRows = 2
      Properties.DropDownSizeable = True
      Properties.ImmediatePost = True
      Properties.ItemHeight = 28
      Properties.Items.Strings = (
        'Jobs Pending Import'
        'Jobs Already Imported')
      Properties.Revertable = True
      Properties.OnEditValueChanged = ViewTypeComboPropertiesEditValueChanged
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'MS Sans Serif'
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
      Text = 'Jobs Pending Import'
      Width = 659
    end
    object cxLabel1: TcxLabel
      Left = 1
      Top = 8
      AutoSize = False
      Caption = 'Viewing:'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'MS Sans Serif'
      Style.Font.Style = []
      Style.TextStyle = [fsBold]
      Style.IsFontAssigned = True
      Height = 21
      Width = 63
    end
  end
  object StatusBar: TdxStatusBar
    Left = 0
    Top = 355
    Width = 1021
    Height = 21
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        Width = 220
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
  end
  object cxGroupBox1: TcxGroupBox
    Left = 0
    Top = 250
    Align = alBottom
    Caption = 'JobCard Comments'
    TabOrder = 7
    Height = 105
    Width = 1021
    object Label1: TLabel
      Left = 464
      Top = 24
      Width = 70
      Height = 17
      Caption = 'Started On: '
    end
    object Label2: TLabel
      Left = 464
      Top = 48
      Width = 71
      Height = 17
      Caption = 'Finished On:'
    end
    object Label45: TLabel
      Left = 464
      Top = 72
      Width = 82
      Height = 17
      Caption = 'Uploaded On:'
    end
    object StartedOnDateLabel: TLabel
      Left = 560
      Top = 24
      Width = 70
      Height = 17
      Caption = 'Started On: '
    end
    object FinishedOnDateLabel: TLabel
      Left = 560
      Top = 48
      Width = 70
      Height = 17
      Caption = 'Started On: '
    end
    object UploadedDateLabel: TLabel
      Left = 560
      Top = 72
      Width = 70
      Height = 17
      Caption = 'Started On: '
    end
    object CommentMemo: TcxMemo
      Left = 2
      Top = 20
      Align = alLeft
      Lines.Strings = (
        'CommentMemo')
      Properties.ReadOnly = True
      Properties.ScrollBars = ssVertical
      Style.Color = clInfoBk
      Style.TextColor = clNavy
      TabOrder = 0
      Height = 83
      Width = 455
    end
  end
  object dxBarManager1: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Bars = <
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        BorderStyle = bbsNone
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsTop
        FloatLeft = 496
        FloatTop = 159
        FloatClientWidth = 23
        FloatClientHeight = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemLinks = <
          item
            Item = blbClose
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbPrint
            Visible = True
          end
          item
            BeginGroup = True
            Item = BarControlContainerItem
            Visible = True
          end>
        Name = 'TopToolbar'
        NotDocking = [dsNone]
        OneOnRow = True
        RotateWhenVertical = False
        Row = 0
        ShowMark = False
        SizeGrip = False
        UseOwnFont = True
        UseRecentItems = False
        UseRestSpace = True
        Visible = True
        WholeRow = True
      end>
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    HotImages = AccsDataModule.ImageList16x16
    PopupMenuLinks = <>
    UseSystemFont = False
    Left = 98
    Top = 94
    DockControlHeights = (
      0
      0
      44
      0)
    object blbClose: TdxBarLargeButton
      Caption = 'Close'
      Category = 0
      Visible = ivAlways
      OnClick = blbCloseClick
      AutoGrayScale = False
      Height = 44
      HotGlyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        1800000000000003000000000000000000000000000000000000FF00FFFF00FF
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
      Width = 75
    end
    object BarControlContainerItem: TdxBarControlContainerItem
      Category = 0
      Visible = ivAlways
    end
    object blbPrint: TdxBarLargeButton
      Caption = 'Print'
      Category = 0
      Hint = 'Print'
      Visible = ivAlways
      OnClick = blbPrintClick
      AutoGrayScale = False
      HotImageIndex = 8
      Width = 75
    end
  end
  object ComponentPrinter: TdxComponentPrinter
    AutoUpdateDateTime = False
    CurrentLink = GridPrinterLink
    PreviewOptions.ShowExplorer = True
    PreviewOptions.WindowState = wsMaximized
    PrintTitle = 'Kingswood Accounts'
    Version = 0
    Left = 256
    Top = 112
    object GridPrinterLink: TdxGridReportLink
      Component = cxGrid
      PrinterPage.DMPaper = 9
      PrinterPage.Footer = 6350
      PrinterPage.Header = 6350
      PrinterPage.Margins.Bottom = 6350
      PrinterPage.Margins.Left = 1000
      PrinterPage.Margins.Right = 1000
      PrinterPage.Margins.Top = 6350
      PrinterPage.Orientation = poLandscape
      PrinterPage.PageSize.X = 210000
      PrinterPage.PageSize.Y = 297000
      PrinterPage._dxMeasurementUnits_ = 0
      PrinterPage._dxLastMU_ = 2
      ReportTitle.Text = 'Job Cards'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      OptionsFormatting.LookAndFeelKind = lfFlat
      OptionsFormatting.UseNativeStyles = True
      OptionsSize.AutoWidth = True
      OptionsView.BandHeaders = False
      OptionsView.ExpandButtons = False
      OptionsView.FilterBar = False
      OptionsView.GroupFooters = False
      BuiltInReportLink = True
    end
  end
end
