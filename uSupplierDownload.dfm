inherited fmSupplierDownload: TfmSupplierDownload
  Left = 525
  Width = 981
  Caption = ''
  Font.Height = -13
  Font.Name = 'Segoe UI'
  KeyPreview = True
  OldCreateOrder = True
  WindowState = wsMaximized
  OnClick = FormClick
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnMouseDown = FormMouseDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  inherited StatusBar: TdxStatusBar
    Width = 973
  end
  object gbCoOp: TcxGroupBox [1]
    Left = 0
    Top = 49
    Align = alTop
    Caption = 'gbCoOp'
    ParentFont = False
    Style.Font.Charset = ANSI_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI'
    Style.Font.Style = []
    Style.LookAndFeel.Kind = lfFlat
    Style.LookAndFeel.NativeStyle = False
    Style.TextStyle = []
    Style.IsFontAssigned = True
    StyleDisabled.LookAndFeel.Kind = lfFlat
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfFlat
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfFlat
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 5
    OnClick = gbCoOpClick
    OnEnter = gbCoOpEnter
    Height = 176
    Width = 973
    object cmboSupplier: TcxLookupComboBox
      Left = 68
      Top = 24
      RepositoryItem = AccsDataModule.erSuppliersLookup
      ParentFont = False
      Properties.ListColumns = <>
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      Style.ButtonTransparency = ebtNone
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 0
      OnEnter = cmboSupplierEnter
      Width = 183
    end
    object cxLabel1: TcxLabel
      Left = 15
      Top = 27
      Caption = 'Supplier '
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
    end
    object gbTotals: TcxGroupBox
      Left = 13
      Top = 55
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
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
      TabOrder = 2
      OnClick = gbTotalsClick
      Height = 107
      Width = 236
      object ceTotalVAT: TcxCurrencyEdit
        Left = 105
        Top = 45
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 0
        Width = 121
      end
      object ceTotalLessVAT: TcxCurrencyEdit
        Left = 105
        Top = 15
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 1
        Width = 121
      end
      object ceTotalAmt: TcxCurrencyEdit
        Left = 105
        Top = 75
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 2
        Width = 121
      end
      object cxLabel2: TcxLabel
        Left = 6
        Top = 18
        AutoSize = False
        Caption = 'Total Less VAT'
        Properties.Alignment.Horz = taRightJustify
        Style.TransparentBorder = False
        Height = 17
        Width = 88
      end
      object cxLabel3: TcxLabel
        Left = 6
        Top = 48
        AutoSize = False
        Caption = 'Total VAT'
        Properties.Alignment.Horz = taRightJustify
        Style.TransparentBorder = False
        Height = 16
        Width = 88
      end
      object cxLabel4: TcxLabel
        Left = 6
        Top = 78
        AutoSize = False
        Caption = 'Total'
        Properties.Alignment.Horz = taRightJustify
        Style.TransparentBorder = False
        Height = 16
        Width = 88
      end
    end
    object cxLabel5: TcxLabel
      Left = 281
      Top = 27
      AutoSize = False
      Caption = 'Statement For'
      ParentFont = False
      Properties.Alignment.Horz = taRightJustify
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      Height = 17
      Width = 98
    end
    object teStatementFor: TcxTextEdit
      Left = 384
      Top = 24
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
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
      TabOrder = 4
      Width = 420
    end
    object cxLabel6: TcxLabel
      Left = 253
      Top = 57
      AutoSize = False
      Caption = 'This Statement Date'
      ParentFont = False
      Properties.Alignment.Horz = taRightJustify
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      Height = 17
      Width = 125
    end
    object cxLabel7: TcxLabel
      Left = 529
      Top = 57
      AutoSize = False
      Caption = 'Date'
      ParentFont = False
      Properties.Alignment.Horz = taRightJustify
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      Height = 17
      Width = 33
    end
    object cbVATRegistered: TcxCheckBox
      Left = 690
      Top = 53
      Caption = 'VAT Registered'
      ParentFont = False
      Properties.Alignment = taRightJustify
      Properties.ImmediatePost = True
      Properties.OnChange = cbVATRegisteredPropertiesChange
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 7
      Width = 119
    end
    object cxLabel8: TcxLabel
      Left = 281
      Top = 85
      AutoSize = False
      Caption = 'Reference'
      ParentFont = False
      Properties.Alignment.Horz = taRightJustify
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      Height = 17
      Width = 98
    end
    object teReference: TcxTextEdit
      Left = 384
      Top = 84
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
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
      TabOrder = 9
      Width = 120
    end
    object cxLabel9: TcxLabel
      Left = 506
      Top = 85
      AutoSize = False
      Caption = 'Comment'
      ParentFont = False
      Properties.Alignment.Horz = taRightJustify
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.TransparentBorder = False
      Style.IsFontAssigned = True
      Height = 17
      Width = 57
    end
    object teComment: TcxTextEdit
      Left = 567
      Top = 84
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
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
      TabOrder = 11
      Width = 237
    end
    object teThisDate: TcxTextEdit
      Left = 384
      Top = 54
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
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
      TabOrder = 12
      Width = 120
    end
    object teTxDate: TcxTextEdit
      Left = 567
      Top = 54
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
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
      TabOrder = 13
      Width = 120
    end
  end
  object ImportGrid: TcxGrid [2]
    Left = 0
    Top = 225
    Width = 973
    Height = 275
    Align = alClient
    TabOrder = 6
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    object ImportGridDBTableView: TcxGridDBTableView
      OnMouseEnter = ImportGridDBTableViewMouseEnter
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
      OnCellClick = ImportGridDBTableViewCellClick
      DataController.DataSource = dsImportTable
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnFiltering = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.DataRowHeight = 26
      OptionsView.GridLines = glHorizontal
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 42
      object ImportGridDBTableViewID: TcxGridDBColumn
        DataBinding.FieldName = 'ID'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
      object ImportGridDBTableViewNlAcc: TcxGridDBColumn
        DataBinding.FieldName = 'NlAcc'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
      object ImportGridDBTableViewRecIdent: TcxGridDBColumn
        DataBinding.FieldName = 'RecIdent'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
      object ImportGridDBTableViewAccType: TcxGridDBColumn
        DataBinding.FieldName = 'AccType'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
        Width = 110
      end
      object ImportGridDBTableViewInvDate: TcxGridDBColumn
        DataBinding.FieldName = 'InvDate'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
      object ImportGridDBTableViewCompanyCode: TcxGridDBColumn
        Caption = 'Code'
        DataBinding.FieldName = 'CompanyCode'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 85
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Width = 85
      end
      object ImportGridDBTableViewUnits: TcxGridDBColumn
        DataBinding.FieldName = 'Units'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
      object ImportGridDBTableViewExpCode: TcxGridDBColumn
        DataBinding.FieldName = 'ExpCode'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
      object ImportGridDBTableViewTransRef: TcxGridDBColumn
        DataBinding.FieldName = 'TransRef'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
      object ImportGridDBTableViewNomName: TcxGridDBColumn
        Caption = 'Nominal Acc.'
        DataBinding.FieldName = 'NomName'
        RepositoryItem = erButtonEdit
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.Moving = False
        Styles.Header = EmphasizedHeaderStyle
        Width = 200
      end
      object ImportGridDBTableViewTaxRate: TcxGridDBColumn
        DataBinding.FieldName = 'TaxRate'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
      object ImportGridDBTableViewDocketNo: TcxGridDBColumn
        DataBinding.FieldName = 'DocketNo'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
      object ImportGridDBTableViewDescription: TcxGridDBColumn
        DataBinding.FieldName = 'Description'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentVert = vaCenter
        MinWidth = 300
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.IncSearch = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Width = 300
      end
      object ImportGridDBTableViewAmount: TcxGridDBColumn
        DataBinding.FieldName = 'Amount'
        RepositoryItem = erCurrency
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.Grouping = False
        Options.Moving = False
        Width = 69
      end
      object ImportGridDBTableViewQuantity: TcxGridDBColumn
        DataBinding.FieldName = 'Quantity'
        RepositoryItem = erCurrency
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.Grouping = False
        Options.Moving = False
        Width = 72
      end
      object ImportGridDBTableViewTaxIDS: TcxGridDBColumn
        Caption = 'Tax Code'
        DataBinding.FieldName = 'TaxIDS'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.Grouping = False
        Options.Moving = False
        Width = 76
      end
      object ImportGridDBTableViewVATRate: TcxGridDBColumn
        Caption = 'VAT Rate'
        DataBinding.FieldName = 'VATRate'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.Grouping = False
        Options.Moving = False
        Width = 72
      end
      object ImportGridDBTableViewTaxAmount: TcxGridDBColumn
        Caption = 'VAT Amount'
        DataBinding.FieldName = 'TaxAmount'
        RepositoryItem = erCurrency
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.Grouping = False
        Options.Moving = False
        Width = 83
      end
      object ImportGridDBTableViewEnterprise: TcxGridDBColumn
        Visible = False
      end
    end
    object ImportGridLevel: TcxGridLevel
      GridView = ImportGridDBTableView
    end
  end
  inherited BarManager: TdxBarManager
    Font.Name = 'Segoe UI'
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
            Item = blbSave2
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbImport
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbSkipTransaction
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = dxblbEnterPayment
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbSelectCoOp
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
    Left = 226
    Top = 462
    DockControlHeights = (
      0
      0
      49
      0)
    inherited blbView: TdxBarLargeButton
      ImageIndex = 8
    end
    inherited blbPrint: TdxBarLargeButton
      ImageIndex = 17
    end
    inherited blbHelp: TdxBarLargeButton
      Action = actHelp
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
      Width = 65
      ImageIndex = 9
    end
    inherited blbCancel2: TdxBarLargeButton
      ImageIndex = 10
    end
    inherited blbImport: TdxBarLargeButton
      Width = 115
    end
    object blbSkipTransaction: TdxBarLargeButton
      Action = actSkipTransaction
      Category = 0
      Height = 44
      HotImageIndex = 36
      Width = 115
    end
    object blbSelectCoOp: TdxBarLargeButton
      Action = actSelectCoOp
      Category = 0
      Height = 44
      HotImageIndex = 14
      Width = 95
    end
    object dxblbEnterPayment: TdxBarLargeButton
      Action = actEnterPayment
      Category = 0
      Height = 45
      HotGlyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000430F0000430F00000000000000000000FF00FFFF00FF
        A36849A36849A36849A36849A36849A36849A36849A36849A36849A36849A368
        49A36849FF00FFFF00FFFF00FFD09677E6C5ABE2BDA3E2BDA3E2BDA3E2BDA3D6
        A688D7A689D7A689D29D7ED09879CB8F67C2784CA36849FF00FFFF00FFD09677
        E6C5ABE2BDA3F7D6A5BE7B5AE2BDA3F7D6A5BE7B5AD7A68929C65A006308CB8F
        67C7825CA36849FF00FFFF00FFD09677E6C5ABE2BDA3FFF7E6F7D6A5E2BDA3FF
        F7E6F7D6A5D7A6899CE7B529C65ACB8F67C7825CA36849FF00FFFF00FFD09677
        E6C5ABE2BDA3E2BDA3E2BDA3E2BDA3D6A688D7A689D7A689D29D7ED09879CB8F
        67C7825CA36849FF00FFFF00FFD09677E6C5ABE2BDA3F7D6A5BE7B5AE2BDA3F7
        D6A5BE7B5AD7A689FF9C00BA5E00CB8F67C7825CA36849FF00FFFF00FFD09677
        E6C5ABE2BDA3FFF7E6F7D6A5E2BDA3FFF7E6F7D6A5D7A689FFCE7BFF9C00CB8F
        67C7825CA36849FF00FFFF00FFD09677E6C5ABE2BDA3E2BDA3E2BDA3E2BDA3D6
        A688D7A689D7A689D29D7ED09879CB8F67C7825CA36849FF00FFFF00FFD09677
        E6C5ABE2BDA3F7D6A5BE7B5AE2BDA3F7D6A5BE7B5AD7A6891063D61459A5CB8F
        67C7825CA36849FF00FFFF00FFD09677E6C5ABE2BDA3FFF7E6F7D6A5E2BDA3FF
        F7E6F7D6A5D7A68985A6E01063D6CB8F67C7825CA36849FF00FFFF00FFD09677
        E6C5ABE2BDA3E2BDA3E2BDA3E2BDA3D6A688D6A688D6A688D29D7ED09879CB8F
        67C7825CA36849FF00FFFF00FFD09677B38483CE9494CE9494CE9494CE9494CE
        9494CE9494CE9494CE9494CE9494CE9494C7825CA36849FF00FFFF00FFD09677
        B38483A5D09EA5D09E9ACC9291C9898AC68281C27A7BBF7376BD6E75BD6DCE94
        94C7825CA36849FF00FFFF00FFD09677B38483A5D09EADDFAD9ED99E91D49188
        D1887ECC7E76C9766DC56D68C468CE9494C7825CA36849FF00FFFF00FFD09677
        B38483B38483B38483B38483B38483B38483B38483B38483B38483B38483B384
        83C2784CA36849FF00FFFF00FFFF00FFD09677D09677D09677D09677D09677D0
        9677D09677D09677D09677D09677D09677D09677FF00FFFF00FF}
      Width = 115
    end
  end
  inherited ActionList: TActionList
    Left = 256
    Top = 462
    inherited actHelp: TAction
      OnExecute = actHelpExecute
    end
    inherited actSave2: TAction
      OnExecute = actSave2Execute
    end
    inherited actCancel2: TAction
      ImageIndex = 34
    end
    inherited actImport: TAction
      Caption = 'Read &Import File'
      OnExecute = actImportExecute
    end
    object actSkipTransaction: TAction [18]
      Caption = 'Skip Transaction'
      ImageIndex = 36
      OnExecute = actSkipTransactionExecute
    end
    object actSelectCoOp: TAction [19]
      Caption = 'Select Co-Op'
      ImageIndex = 14
      OnExecute = actSelectCoOpExecute
    end
    object actEnterPayment: TAction
      Caption = 'Enter Payment'
      ImageIndex = 12
      OnExecute = actEnterPaymentExecute
    end
  end
  object dsImportTable: TDataSource
    DataSet = ImportTable
    Left = 164
    Top = 462
  end
  object ImportTable: TTable
    BeforeInsert = ImportTableBeforeInsert
    AfterPost = ImportTableAfterPost
    DatabaseName = 'WinAccsData'
    TableName = 'Import.DB'
    Left = 100
    Top = 462
    object ImportTableID: TAutoIncField
      FieldName = 'ID'
    end
    object ImportTableNLAcc: TIntegerField
      FieldName = 'NlAcc'
    end
    object ImportTableRecIdent: TStringField
      FieldName = 'RecIdent'
      Size = 5
    end
    object ImportTableAccType: TStringField
      FieldName = 'AccType'
      Size = 1
    end
    object ImportTableNomName: TStringField
      FieldName = 'NomName'
      Size = 30
    end
    object ImportTableInvDate: TDateTimeField
      FieldName = 'InvDate'
      OnValidate = ImportTableInvDateValidate
    end
    object ImportTableCompanyCode: TStringField
      FieldName = 'CompanyCode'
      Size = 10
    end
    object ImportTableDescription: TStringField
      FieldName = 'Description'
      Size = 30
    end
    object ImportTableQuantity: TFloatField
      FieldName = 'Quantity'
    end
    object ImportTableUnits: TStringField
      FieldName = 'Units'
      Size = 10
    end
    object ImportTableAmount: TFloatField
      FieldName = 'Amount'
    end
    object ImportTableVATRate: TFloatField
      FieldName = 'VATRate'
    end
    object ImportTableExpCode: TStringField
      FieldName = 'ExpCode'
    end
    object ImportTableTransRef: TStringField
      DisplayWidth = 8
      FieldName = 'TransRef'
      Size = 8
    end
    object ImportTableTaxIDS: TStringField
      FieldName = 'TaxIDS'
      Size = 1
    end
    object ImportTableTaxRate: TIntegerField
      FieldName = 'TaxRate'
    end
    object ImportTableTaxAmount: TFloatField
      FieldName = 'TaxAmount'
    end
    object ImportTableDocketNo: TStringField
      DisplayWidth = 15
      FieldName = 'DocketNo'
      Size = 15
    end
  end
  object VatCodes: TTable
    DatabaseName = 'WinAccsData'
    Left = 68
    Top = 462
  end
  object dsVatCodes: TDataSource
    DataSet = VatCodes
    Left = 132
    Top = 462
  end
  object GetImportFile: TOpenDialog
    Filter = 'Text File (*.txt)|*.txt|All Files (*.*)|*.*'
    Title = 'Supplier Statement Import'
    Left = 36
    Top = 461
  end
  object HintStyleController: TcxHintStyleController
    Global = False
    HintStyle.CaptionFont.Charset = DEFAULT_CHARSET
    HintStyle.CaptionFont.Color = clWindowText
    HintStyle.CaptionFont.Height = -11
    HintStyle.CaptionFont.Name = 'MS Sans Serif'
    HintStyle.CaptionFont.Style = []
    HintStyle.Font.Charset = DEFAULT_CHARSET
    HintStyle.Font.Color = clWindowText
    HintStyle.Font.Height = -11
    HintStyle.Font.Name = 'MS Sans Serif'
    HintStyle.Font.Style = []
    Left = 6
    Top = 462
  end
  object cxEditRepository1: TcxEditRepository
    Left = 196
    Top = 462
    object erCurrency: TcxEditRepositoryCurrencyItem
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DisplayFormat = ',0.00;-,0.00'
    end
    object erButtonEdit: TcxEditRepositoryButtonItem
      Properties.Alignment.Vert = taVCenter
      Properties.Buttons = <
        item
          Default = True
          Kind = bkGlyph
        end>
    end
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 286
    Top = 462
    object TransGridNormalStyle: TcxStyle
      AssignedValues = [svFont]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
    end
    object EmphasizedHeaderStyle: TcxStyle
      AssignedValues = [svFont]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
    end
  end
end
