inherited fmBudgets: TfmBudgets
  Left = 0
  Top = 0
  Width = 1680
  Height = 1020
  ActiveControl = cmboMonthlyComparision
  Caption = 'Budget'
  KeyPreview = True
  OldCreateOrder = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pTransctionGridHeader: TPanel [0]
    Left = 0
    Top = 158
    Width = 1664
    Height = 41
    Align = alTop
    Alignment = taLeftJustify
    BevelInner = bvRaised
    BevelOuter = bvNone
    Caption = '    Budget Records - '
    Color = 16637633
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    object cxLabel12: TcxLabel
      Left = 137
      Top = 12
      Caption = 'Only columns with a white background can be changed '
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
    end
    object cbHideInactiveNominalAccounts: TcxCheckBox
      Left = 439
      Top = 12
      Caption = 'Hide Inactive Nominal Accounts'
      ParentFont = False
      Properties.DisplayGrayed = 'False'
      Properties.FullFocusRect = True
      Properties.ImmediatePost = True
      Properties.ValueGrayed = 'False'
      Properties.OnChange = cbHideInactiveNominalAccountsPropertiesChange
      State = cbsChecked
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      Style.TextStyle = []
      Style.TransparentBorder = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 1
      Width = 212
    end
  end
  inherited StatusBar: TdxStatusBar
    Top = 962
    Width = 1664
  end
  object BudgetGrid: TcxGrid [2]
    Left = 0
    Top = 199
    Width = 1216
    Height = 689
    Align = alClient
    BorderStyle = cxcbsNone
    TabOrder = 6
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    object BudgetGridDBTableView: TcxGridDBTableView
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
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.DataRowHeight = 22
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 26
      OptionsView.Indicator = True
      OptionsView.IndicatorWidth = 15
      object BudgetGridDBTableViewNominalID: TcxGridDBColumn
        Caption = 'Code'
        DataBinding.FieldName = 'NominalID'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 68
      end
      object BudgetGridDBTableViewNomName: TcxGridDBColumn
        DataBinding.FieldName = 'NomName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
      end
      object BudgetGridDBTableViewYearBudget: TcxGridDBColumn
        DataBinding.FieldName = 'YearBudget'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 95
      end
      object BudgetGridDBTableViewJan: TcxGridDBColumn
        Caption = 'JAN'
        DataBinding.FieldName = 'Jan'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewActualJan: TcxGridDBColumn
        Caption = 'JAN'
        DataBinding.FieldName = 'ActualJan'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewLastYearJan: TcxGridDBColumn
        Caption = 'JAN'
        DataBinding.FieldName = 'LastYearJan'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewFeb: TcxGridDBColumn
        Caption = 'FEB'
        DataBinding.FieldName = 'Feb'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 71
      end
      object BudgetGridDBTableViewMar: TcxGridDBColumn
        Caption = 'MAR'
        DataBinding.FieldName = 'Mar'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewApr: TcxGridDBColumn
        Caption = 'APR'
        DataBinding.FieldName = 'Apr'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewMay: TcxGridDBColumn
        Caption = 'MAY'
        DataBinding.FieldName = 'May'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewJun: TcxGridDBColumn
        Caption = 'JUN'
        DataBinding.FieldName = 'Jun'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewJul: TcxGridDBColumn
        Caption = 'JULY'
        DataBinding.FieldName = 'Jul'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewAug: TcxGridDBColumn
        Caption = 'AUG'
        DataBinding.FieldName = 'Aug'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewSep: TcxGridDBColumn
        Caption = 'SEPT'
        DataBinding.FieldName = 'Sep'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewOct: TcxGridDBColumn
        Caption = 'OCT'
        DataBinding.FieldName = 'Oct'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewNov: TcxGridDBColumn
        Caption = 'NOV'
        DataBinding.FieldName = 'Nov'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewDec: TcxGridDBColumn
        Caption = 'DEC'
        DataBinding.FieldName = 'Dec'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object BudgetGridDBTableViewAlteredBudget: TcxGridDBColumn
        DataBinding.FieldName = 'AlteredBudget'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
      object BudgetGridDBTableViewCheckBudget: TcxGridDBColumn
        DataBinding.FieldName = 'CheckBudget'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
    end
    object BudgetGridDBBandedTableView: TcxGridDBBandedTableView
      OnKeyDown = BudgetGridDBBandedTableViewKeyDown
      OnMouseWheel = BudgetGridDBBandedTableViewMouseWheel
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
      FilterBox.CustomizeDialog = False
      OnEditing = BudgetGridDBBandedTableViewEditing
      OnEditKeyDown = BudgetGridDBBandedTableViewEditKeyDown
      OnFocusedItemChanged = BudgetGridDBBandedTableViewFocusedItemChanged
      DataController.DataSource = dsTempBudget
      DataController.Filter.OnChanged = BudgetGridDBBandedTableViewDataControllerFilterChanged
      DataController.Filter.OnFormatFilterTextValue = BudgetGridDBBandedTableViewDataControllerFilterFormatFilterTextValue
      DataController.KeyFieldNames = 'NominalID'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      DataController.Summary.OnAfterSummary = BudgetGridDBBandedTableViewDataControllerSummaryAfterSummary
      Filtering.MRUItemsList = False
      Filtering.ColumnMRUItemsList = False
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnHidingOnGrouping = False
      OptionsCustomize.ColumnHorzSizing = False
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsCustomize.BandMoving = False
      OptionsCustomize.BandSizing = False
      OptionsCustomize.ColumnVertSizing = False
      OptionsCustomize.NestedBands = False
      OptionsView.DataRowHeight = 28
      OptionsView.Footer = True
      OptionsView.FooterAutoHeight = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 38
      OptionsView.BandHeaderHeight = 32
      OptionsView.BandHeaderLineCount = 2
      Styles.Footer = AccsDataModule.cxStyleOffGrazingPlatform
      Styles.Header = AccsDataModule.cxStyleOffGrazingPlatform
      Styles.Indicator = AccsDataModule.cxStyleOffGrazingPlatform
      Styles.BandHeader = AccsDataModule.cxStyleOffGrazingPlatform
      Bands = <
        item
          Caption = 'Nominal Information'
          FixedKind = fkLeft
          Styles.Header = AccsDataModule.cxStyleOffGrazingPlatform
        end
        item
          Caption = 'Yearly Totals (Euro/Pound)'
          FixedKind = fkLeft
          Styles.Header = AccsDataModule.cxStyleOffGrazingPlatform
        end
        item
          Caption = 'Yearly Cost Per Unit (Cent/Pence)'
          FixedKind = fkLeft
        end
        item
          Caption = 'January'
          Styles.Header = cxStyle1stQuarterMonthBand
          Tag = 1
        end
        item
          Caption = 'February'
          Styles.Header = cxStyle1stQuarterMonthBand
          Tag = 1
        end
        item
          Caption = 'March'
          Styles.Header = cxStyle1stQuarterMonthBand
          Tag = 1
        end
        item
          Caption = 'April'
          Styles.Header = cxStyle2ndQuarterMonthBand
          Tag = 1
        end
        item
          Caption = 'May'
          Styles.Header = cxStyle2ndQuarterMonthBand
          Tag = 1
        end
        item
          Caption = 'June'
          Styles.Header = cxStyle2ndQuarterMonthBand
          Tag = 1
        end
        item
          Caption = 'July'
          Styles.Header = cxStyle3rdQuarterMonthBand
          Tag = 1
        end
        item
          Caption = 'August'
          Styles.Header = cxStyle3rdQuarterMonthBand
          Tag = 1
        end
        item
          Caption = 'September'
          Styles.Header = cxStyle3rdQuarterMonthBand
          Tag = 1
        end
        item
          Caption = 'October'
          Styles.Header = cxStyle4thQuarterMonthBand
          Tag = 1
        end
        item
          Caption = 'November'
          Styles.Header = cxStyle4thQuarterMonthBand
          Tag = 1
        end
        item
          Caption = 'December'
          Styles.Header = cxStyle4thQuarterMonthBand
          Tag = 1
        end
        item
          Caption = '1st Quarter'
          Styles.Header = cxStyle1stQuarterHeader
        end
        item
          Caption = '2nd Quarter'
          Styles.Header = cxStyle2ndQuarterHeader
        end
        item
          Caption = '3rd Quarter'
          Styles.Header = cxStyle3rdQuarterHeader
        end
        item
          Caption = '4th Quarter'
          Styles.Header = cxStyle4thQuarterHeader
        end>
      object BudgetGridDBBandedTableViewNominalID: TcxGridDBBandedColumn
        Caption = 'Code'
        DataBinding.FieldName = 'NominalID'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Options.Filtering = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = AccsDataModule.cxStyleOffGrazingPlatform
        Width = 35
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewEnterpriseCode: TcxGridDBBandedColumn
        Caption = 'Ent'
        DataBinding.FieldName = 'EnterpriseCode'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = AccsDataModule.cxStyleOffGrazingPlatform
        Width = 45
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewNomName: TcxGridDBBandedColumn
        Caption = 'Name'
        DataBinding.FieldName = 'NomName'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Options.Filtering = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = AccsDataModule.cxStyleOffGrazingPlatform
        Width = 125
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewYearBudget: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'YearBudget'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Options.Filtering = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = AccsDataModule.cxStyleOffGrazingPlatform
        Width = 55
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLYYearTotal: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYYearTotal'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = AccsDataModule.cxStyleOffGrazingPlatform
        Width = 55
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewBudgetToDate: TcxGridDBBandedColumn
        Tag = 3
        Caption = 'Budget'#13#10'(To Date)'
        DataBinding.FieldName = 'BudgetToDate'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Options.Filtering = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = AccsDataModule.cxStyleOffGrazingPlatform
        Width = 55
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualTotal: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'#13#10'(To Date)'
        DataBinding.FieldName = 'ActualYearTotal'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = AccsDataModule.cxStyleOffGrazingPlatform
        Width = 55
        Position.BandIndex = 1
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewJanuary: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'JAN'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle1stQuarter
        Width = 55
        Position.BandIndex = 3
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualJanuary: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'
        DataBinding.FieldName = 'ActualJAN'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Focusing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = cxStyle1stQuarter
        Width = 55
        Position.BandIndex = 3
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLastYearJanuary: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYJan'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle1stQuarter
        Width = 55
        Position.BandIndex = 3
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewFebruary: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'FEB'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle1stQuarter
        Width = 55
        Position.BandIndex = 4
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualFebruary: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'
        DataBinding.FieldName = 'ActualFEB'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Focusing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = cxStyle1stQuarter
        Width = 55
        Position.BandIndex = 4
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLastYearFebruary: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYFEB'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle1stQuarter
        Width = 55
        Position.BandIndex = 4
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewMarch: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'MAR'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle1stQuarter
        Width = 55
        Position.BandIndex = 5
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualMarch: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'
        DataBinding.FieldName = 'ActualMAR'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Focusing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = cxStyle1stQuarter
        Width = 55
        Position.BandIndex = 5
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLastYearMarch: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYMAR'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle1stQuarter
        Width = 55
        Position.BandIndex = 5
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewApril: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'APR'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle2ndQuarter
        Width = 55
        Position.BandIndex = 6
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualApril: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'
        DataBinding.FieldName = 'ActualAPR'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Focusing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = cxStyle2ndQuarter
        Width = 55
        Position.BandIndex = 6
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLastYearApril: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYAPR'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle2ndQuarter
        Width = 55
        Position.BandIndex = 6
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewMay: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'MAY'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle2ndQuarter
        Width = 55
        Position.BandIndex = 7
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualMay: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'
        DataBinding.FieldName = 'ActualMAY'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Focusing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = cxStyle2ndQuarter
        Width = 55
        Position.BandIndex = 7
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLastYearMay: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYMAY'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle2ndQuarter
        Width = 55
        Position.BandIndex = 7
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewJune: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'JUN'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle2ndQuarter
        Width = 55
        Position.BandIndex = 8
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualJune: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'
        DataBinding.FieldName = 'ActualJUN'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Focusing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = cxStyle2ndQuarter
        Width = 55
        Position.BandIndex = 8
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLastYearJune: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYJUN'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle2ndQuarter
        Width = 55
        Position.BandIndex = 8
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewJuly: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'JUL'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle3rdQuarter
        Width = 55
        Position.BandIndex = 9
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualJuly: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'
        DataBinding.FieldName = 'ActualJUL'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Focusing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = cxStyle3rdQuarter
        Width = 55
        Position.BandIndex = 9
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLastYearJuly: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYJUL'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle3rdQuarter
        Width = 55
        Position.BandIndex = 9
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewAugust: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'AUG'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle3rdQuarter
        Width = 55
        Position.BandIndex = 10
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualAugust: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'
        DataBinding.FieldName = 'ActualAUG'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Focusing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = cxStyle3rdQuarter
        Width = 55
        Position.BandIndex = 10
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLastYearAugust: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYAUG'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle3rdQuarter
        Width = 55
        Position.BandIndex = 10
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewSeptember: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'SEP'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle3rdQuarter
        Width = 55
        Position.BandIndex = 11
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualSeptember: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'
        DataBinding.FieldName = 'ActualSEP'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Focusing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = cxStyle3rdQuarter
        Width = 55
        Position.BandIndex = 11
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLastYearSeptember: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYSEP'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle3rdQuarter
        Width = 55
        Position.BandIndex = 11
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewOctober: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'OCT'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle4thQuarter
        Width = 55
        Position.BandIndex = 12
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualOctober: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'
        DataBinding.FieldName = 'ActualOCT'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Focusing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = cxStyle4thQuarter
        Width = 55
        Position.BandIndex = 12
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLastYearOctober: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYOCT'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle4thQuarter
        Width = 55
        Position.BandIndex = 12
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewNovember: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'NOV'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle4thQuarter
        Width = 55
        Position.BandIndex = 13
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualNovember: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'
        DataBinding.FieldName = 'ActualNOV'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Focusing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = cxStyle4thQuarter
        Width = 55
        Position.BandIndex = 13
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLastYearNovember: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYNOV'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle4thQuarter
        Width = 55
        Position.BandIndex = 13
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewDecember: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'DEC'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle4thQuarter
        Width = 55
        Position.BandIndex = 14
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualDecember: TcxGridDBBandedColumn
        Tag = 2
        Caption = 'Actual'
        DataBinding.FieldName = 'ActualDEC'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Focusing = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Styles.Header = cxStyle4thQuarter
        Width = 55
        Position.BandIndex = 14
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLastYearDecember: TcxGridDBBandedColumn
        Tag = 1
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYDEC'
        RepositoryItem = AccsDataModule.erCurrencyEditNoSymbol
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Styles.Header = cxStyle4thQuarter
        Width = 55
        Position.BandIndex = 14
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewYearBudgetCPU: TcxGridDBBandedColumn
        Caption = 'Budget'
        DataBinding.FieldName = 'YearBudgetCPU'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Width = 52
        Position.BandIndex = 2
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewBudgetToDateCPU: TcxGridDBBandedColumn
        Caption = 'Budget'#13#10'(To Date)'
        DataBinding.FieldName = 'BudgetToDateCPU'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Width = 52
        Position.BandIndex = 2
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewLYYearTotalCPU: TcxGridDBBandedColumn
        Caption = 'Last Year'
        DataBinding.FieldName = 'LYYearTotalCPU'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Width = 52
        Position.BandIndex = 2
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BudgetGridDBBandedTableViewActualTotalCPU: TcxGridDBBandedColumn
        Caption = 'Actual'#13#10'(To Date)'
        DataBinding.FieldName = 'ActualYearTotalCPU'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Filtering = False
        Styles.Content = AccsDataModule.StyleReadOnly
        Width = 52
        Position.BandIndex = 2
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
    end
    object BudgetGridLevel: TcxGridLevel
      GridView = BudgetGridDBBandedTableView
    end
  end
  object pBudgetActions: TPanel [3]
    Left = 147
    Top = 299
    Width = 830
    Height = 106
    BevelOuter = bvNone
    Color = 16637633
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    object pCostPerUnitControls: TPanel
      Left = 2
      Top = 66
      Width = 777
      Height = 35
      BevelOuter = bvNone
      Color = 16637633
      TabOrder = 7
      object cxLabel5: TcxLabel
        Left = 6
        Top = 10
        Caption = 'Budget Figures Are Based On'
      end
      object cmboReportUnitSelection: TcxComboBox
        Left = 162
        Top = 8
        Properties.DropDownListStyle = lsFixedList
        Properties.ImmediatePost = True
        Properties.ItemHeight = 21
        Properties.Items.Strings = (
          'Total Amount (Euro/Pound)'
          'Amount Per Unit (Cent/Pence)')
        Properties.OnChange = cmboReportUnitSelectionPropertiesChange
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 1
        Width = 135
      end
      object lNoOfUnits: TcxLabel
        Left = 308
        Top = 10
        Caption = 'No. Of Units'
      end
      object ceNoOfUnitsLastYear: TcxCurrencyEdit
        Left = 574
        Top = 8
        Properties.DisplayFormat = ',#;-,#'
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 3
        OnExit = ceNoOfUnitsLastYearExit
        Width = 70
      end
      object btnHideCostPerUnitControls: TcxButton
        Left = 648
        Top = 6
        Width = 123
        Height = 25
        Caption = 'Hide Cost Per Unit '
        TabOrder = 4
        OnClick = btnHideCostPerUnitControlsClick
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000230F0000230F00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF4A6B9C10A5D6FF00FFFF00FFFF00FFFF00FF21A5D6
          4A6B9C4A6B9C4A6B9C4A6B9C4A6B9C4A6B9C4A6B9C10A5D6FF00FF007BAD198A
          BB10A5D6FF00FFFF00FFFF00FF21A5D6708EBC708EBC708EBC708EBC708EBC70
          8EBC10A5D6FF00FFFF00FFFF00FF4A6B9C1884C610A5D6FF00FFFF00FF21A5D6
          BCDDF25DA8D856A4D654A0D360A4CF10A5D6FF00FFFF00FFFF00FFFF00FF1E8F
          BE1884C61E8FBEFF00FFFF00FF21A5D6BCDDF266ACDA5DA8D852A1D210A5D6FF
          00FFFF00FFFF00FFFF00FFFF00FF1E8FBE1884C61E8FBEFF00FFFF00FF21A5D6
          BCDDF273B3DE68ADDB5EA8D8459ECE1E8FBEFF00FFFF00FFFF00FFFF00FF007B
          AD1884C61E8FBEFF00FFFF00FF21A5D6BCDDF2A2D0EE73B3DE66ACDA5DA8D845
          9ECE1E8FBEFF00FFFF00FF739CAD3890C6248BC710A5D6FF00FFFF00FF21A5D6
          BCDDF210A5D642A5DEA2D0EE73B3DE5EA8D84DA2D0007BAD1E8FBE3B97CE3593
          CD1E8FBEFF00FFFF00FFFF00FF21A5D610A5D6FF00FFFF00FF42A5DEA2D0EE73
          B3DE5DA8D856A4D64EA0D43F9DD21E8FBEFF00FFFF00FFFF00FFFF00FF21A5D6
          FF00FFFF00FFFF00FFFF00FF42A5DE42A5DE2DA6D72BA5D63FA4D910A5D6FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        LookAndFeel.NativeStyle = True
      end
      object lUnitLastYear: TcxLabel
        Left = 526
        Top = 10
        Caption = 'Last Year'
      end
      object lUnitThisYear: TcxLabel
        Left = 379
        Top = 10
        Caption = 'Budget/Actual'
      end
      object ceNoOfUnitsThisYear: TcxCurrencyEdit
        Left = 452
        Top = 8
        Properties.DisplayFormat = ',#;-,#'
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 7
        OnExit = ceNoOfUnitsLastYearExit
        Width = 70
      end
    end
    object cmboMonthlyComparision: TcxComboBox
      Left = 8
      Top = 43
      Properties.DropDownListStyle = lsFixedList
      Properties.ImmediatePost = True
      Properties.ItemHeight = 21
      Properties.Items.Strings = (
        'Last Year'
        'Actual (Year to Date)'
        'Both'
        'Neither')
      Properties.OnChange = cmboMonthlyComparisionPropertiesChange
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 0
      Width = 145
    end
    object lbMonthlyComparision: TcxLabel
      Left = 8
      Top = 25
      Caption = 'Compare Budget Against'
    end
    object cmboAccountTypeFilter: TcxComboBox
      Left = 164
      Top = 43
      Properties.DropDownListStyle = lsFixedList
      Properties.ImmediatePost = True
      Properties.ItemHeight = 21
      Properties.Items.Strings = (
        'All Income/Expense'
        'Income Only'
        'Expense Only')
      Properties.OnChange = cmboFilterPropertiesChange
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 1
      Text = 'All Income/Expense'
      Width = 135
    end
    object cxLabel1: TcxLabel
      Left = 164
      Top = 25
      Caption = 'Show Headings'
    end
    object cxLabel2: TcxLabel
      Left = 310
      Top = 25
      Caption = 'Select Periods To View'
    end
    object cmboBudgetPeriods: TcxCheckComboBox
      Left = 310
      Top = 43
      Properties.Delimiter = ' | '
      Properties.EmptySelectionText = 'Select Months'
      Properties.ShowEmptyText = False
      Properties.DropDownSizeable = True
      Properties.ImmediatePopup = True
      Properties.ImmediatePost = True
      Properties.Items = <
        item
          Description = '1st Quarter'
        end
        item
          Description = '2nd Quarter'
        end
        item
          Description = '3rd Quarter'
        end
        item
          Description = '4th Quarter'
        end>
      Properties.OnClickCheck = chkcomboBudgetMonthsPropertiesClickCheck
      Properties.OnEditValueChanged = chkcomboBudgetMonthsPropertiesEditValueChanged
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 2
      Width = 336
    end
    object cxLabel3: TcxLabel
      Left = 8
      Top = 0
      Caption = 'Budget Actions'
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object btnShowCostPerUnitControls: TcxButton
      Left = 7
      Top = 72
      Width = 189
      Height = 25
      Caption = 'Include Cost Per Unit Figures'
      TabOrder = 8
      OnClick = btnShowCostPerUnitControlsClick
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000230F0000230F00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF10A5D64A6B9CFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        10A5D6198ABB007BADFF00FF10A5D64A6B9C4A6B9C4A6B9C4A6B9C4A6B9C4A6B
        9C4A6B9C21A5D6FF00FFFF00FF10A5D66AB0DC4A6B9CFF00FFFF00FFFF00FF10
        A5D690C8EC708EBC708EBC708EBC708EBC708EBC21A5D6FF00FFFF00FF1E8FBE
        6AB0DC1E8FBEFF00FFFF00FFFF00FFFF00FF10A5D6278CCA1F88C81884C61884
        C6708EBC21A5D6FF00FFFF00FF1E8FBE6AB0DC1E8FBEFF00FFFF00FFFF00FFFF
        00FFFF00FF10A5D62B8ECB238AC91B86C7708EBC21A5D6FF00FFFF00FF1E8FBE
        6AB0DC007BADFF00FFFF00FFFF00FFFF00FF1E8FBE3A96CF3292CD2B8ECB238A
        C9708EBC21A5D6FF00FFFF00FF10A5D6A2D0EE6AB0DC739CADFF00FFFF00FF1E
        8FBE499ED3429AD13A96CF3292CD2B8ECB708EBC21A5D6FF00FFFF00FFFF00FF
        1E8FBEA2D0EE6AB0DC1E8FBE007BAD64ACDA51A2D5499ED3429AD11884C610A5
        D690C8EC21A5D6FF00FFFF00FFFF00FFFF00FF1E8FBEA2D0EE6AB0DC6AB0DC6A
        B0DC64ACDA51A2D51884C6FF00FFFF00FF10A5D621A5D6FF00FFFF00FFFF00FF
        FF00FFFF00FF12AEE810A5D610A5D610A5D610A5D610A5D6FF00FFFF00FFFF00
        FFFF00FF21A5D6FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      LookAndFeel.Kind = lfFlat
      LookAndFeel.NativeStyle = True
    end
  end
  object pReportActions: TPanel [4]
    Left = 30
    Top = 436
    Width = 773
    Height = 70
    BevelOuter = bvNone
    Color = 16637633
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    object cxLabel4: TcxLabel
      Left = 8
      Top = 0
      Caption = 'Budget Reports'
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object btnBudgetCashflowComparison: TcxButton
      Left = 8
      Top = 24
      Width = 175
      Height = 37
      Action = actBudgetReport
      TabOrder = 1
      LookAndFeel.NativeStyle = True
    end
    object ProgressBar: TcxProgressBar
      Left = 194
      Top = 38
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 2
      Width = 319
    end
  end
  object Splitter: TcxSplitter [5]
    Left = 1216
    Top = 199
    Width = 8
    Height = 689
    HotZoneClassName = 'TcxSimpleStyle'
    AlignSplitter = salRight
    AutoSnap = True
    InvertDirection = True
    ResizeUpdate = True
    Control = pBudgetDiary
  end
  object pBudgetDiary: TPanel [6]
    Left = 1224
    Top = 199
    Width = 440
    Height = 689
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvNone
    Constraints.MaxWidth = 440
    TabOrder = 10
    object cxGroupBox1: TcxGroupBox
      Left = 1
      Top = 1
      Align = alTop
      Caption = 'Budget Notes'
      ParentColor = False
      Style.BorderStyle = ebs3D
      Style.Color = 16637633
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      Style.LookAndFeel.NativeStyle = False
      Style.TextStyle = [fsBold]
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 0
      Height = 84
      Width = 438
      object btnEdit: TcxButton
        Left = 12
        Top = 26
        Width = 127
        Height = 32
        Action = actEditComments
        TabOrder = 0
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00AEAEAE00999C9E00999C9E00999C9E00999C9E00999C9E00999C9E00999C
          9E00999C9E00999C9E00999C9E00999C9E00999C9E00FF00FF00FF00FF00FF00
          FF00AEAEAE00F7F7F700F4F4F400F2F2F200EFEFEF00EDEDED00EAEAEA00E8E8
          E800E2E2E200DDDDDD00D7D7D700D2D2D2009C9FA100FF00FF00FF00FF00FF00
          FF00AEAEAE00F9F9F900F7F7F700F4F4F400F2F2F200EFEFEF00EDEDED00EAEA
          EA00E8E8E800E2E2E200DDDDDD00D7D7D7009C9FA100FF00FF00FF00FF00FF00
          FF00AEAEAE00FCFCFC00A5A6AB00A5A6AB00A5A6AB00A5A6AB00A5A6AB00A5A6
          AB00A5A6AB00A5A6AB00A5A6AB00DDDDDD009C9FA100FF00FF00FF00FF00FF00
          FF00AEAEAE00FEFEFE00FCFCFC00F9F9F900F7F7F700F4F4F400F2F2F200EFEF
          EF00EDEDED00EAEAEA00E8E8E800E2E2E2009C9FA100FF00FF00FF00FF00FF00
          FF00AEAEAE00FFFFFF00FEFEFE00FCFCFC00F9F9F900F7F7F700F4F4F400F2F2
          F200EFEFEF00EDEDED00EAEAEA00E8E8E8009C9FA100FF00FF00FF00FF00FF00
          FF00AEAEAE00FFFFFF00A5A6AB00A5A6AB00A5A6AB00A5A6AB00A5A6AB00A5A6
          AB00A5A6AB00A5A6AB00A5A6AB00EAEAEA009C9FA100FF00FF00FF00FF00FF00
          FF00AEAEAE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FDFDFD00FAFAFA00F8F8
          F800F5F5F500F3F3F300F0F0F000EDEDED009C9FA100FF00FF00FF00FF00FF00
          FF00AEAEAE00FFFFFF00FFFFFF00FFFFFF007595C300215AA500FDFDFD00215A
          A500215AA500CFD6E300F3F3F300F0F0F0009C9FA100FF00FF00FF00FF00FF00
          FF00AEAEAE00FFFFFF00A5A6AB00A5A6AB0070AEDE00377FCC00215AA5003787
          DD002664A00024497700215AA500EAEAEA009C9FA100FF00FF00FF00FF00FF00
          FF00AEAEAE00FFFFFF00FFFFFF00FFFFFF00A5D6F700CEFFFF002E72C0002C74
          B7002F76B7003C71A5005A82A4004F6E9500706565005C3D3D00FF00FF00FF00
          FF00AEAEAE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A5D6F700CEFFFF005FA9
          E1006192B70090C9E90083C0E10071ADD200ADABAB00413C3C00FF00FF00FF00
          FF00AEAEAE00FFFFFF00A5A6AB00A5A6AB00A5A6AB00A5A6AB00A5D6F700CEFF
          FF00ADDFFB00B1E3FD00AFE1FC009DD2F100A4A4A40068686800FF00FF00FF00
          FF00AEAEAE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00A5D6
          F70073B5D60073B5D60073B5D600ADC6CE00ADADAD00A7A7A700FF00FF00FF00
          FF00AEAEAE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
          FF00FFFFFF00A8A9AA009B9D9D00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00AEAEAE009B9B9C009B9B9C009B9B9C009B9B9C009B9B9C009B9B9C009B9B
          9C009B9B9C009C9FA100FF00FF00FF00FF00FF00FF00FF00FF00}
      end
      object cxButton2: TcxButton
        Left = 146
        Top = 26
        Width = 127
        Height = 32
        Action = actSaveComments
        TabOrder = 1
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
      end
      object lDiaryNotesLastUpdated: TcxLabel
        Left = 14
        Top = 62
        AutoSize = False
        Caption = 'lDiaryNotesLastUpdated'
        Height = 17
        Width = 391
      end
      object cxButton3: TcxButton
        Left = 278
        Top = 26
        Width = 127
        Height = 32
        Action = actCancelComments
        TabOrder = 3
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
      end
    end
    object DiaryNotes: TcxDBMemo
      Left = 1
      Top = 85
      Align = alClient
      ParentFont = False
      Properties.ScrollBars = ssVertical
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 1
      Height = 603
      Width = 438
    end
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
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemLinks = <
          item
            Item = blbExit
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = dxBarLargeButton1
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbReports
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbOptions
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
      end
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        Caption = 'TopSubToolbar'
        Color = 16637633
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 48
        DockingStyle = dsTop
        FloatLeft = 604
        FloatTop = 357
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = bcciBudgetActions
            UserGlyph.Data = {00000000}
            Visible = True
          end>
        Name = 'TopSubToolbar'
        OneOnRow = True
        Row = 1
        ShowMark = False
        SizeGrip = False
        UseOwnFont = False
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
        Caption = 'BottomToobar'
        Color = 16637633
        DockedDockingStyle = dsBottom
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsBottom
        FloatLeft = 604
        FloatTop = 357
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = bcciReportActions
            UserGlyph.Data = {00000000}
            Visible = True
          end>
        Name = 'BottomToobar'
        OneOnRow = True
        Row = 0
        ShowMark = False
        SizeGrip = False
        UseOwnFont = False
        UseRestSpace = True
        Visible = True
        WholeRow = True
        BackgroundBitmap.Data = {00000000}
      end>
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    Left = 48
    Top = 210
    DockControlHeights = (
      0
      0
      158
      74)
    inherited blbExit: TdxBarLargeButton
      AutoGrayScale = False
    end
    inherited blbView: TdxBarLargeButton
      Action = actView
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
    object blbReports: TdxBarLargeButton
      Action = actReport
      Category = 0
      AutoGrayScale = False
      Height = 44
      HotImageIndex = 7
      Width = 65
    end
    object bcciBudgetActions: TdxBarControlContainerItem
      Category = 0
      Visible = ivAlways
      Control = pBudgetActions
    end
    object blbOptions: TdxBarLargeButton
      Caption = 'Options'
      Category = 0
      Hint = 'Options'
      Visible = ivAlways
      ButtonStyle = bsDropDown
      DropDownMenu = pmOptions
      OnClick = blbOptionsClick
      AutoGrayScale = False
      Height = 44
      HotImageIndex = 6
      Width = 65
    end
    object dxBarButton1: TdxBarButton
      Action = actCopyLastYearFiguresToBudget
      Caption = 'Use Last Year'#39's Figures as This Year'#39's Budget Figures'
      Category = 0
      ImageIndex = 40
    end
    object bcciReportActions: TdxBarControlContainerItem
      Category = 0
      Visible = ivAlways
      Control = pReportActions
    end
    object dxBarButton2: TdxBarButton
      Action = actZeroiseBudgetFigures
      Category = 0
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = actExport
      Caption = 'Export Budget (html)'
      Category = 0
      AutoGrayScale = False
      Height = 44
      HotImageIndex = 41
      SyncImageIndex = False
      ImageIndex = 41
    end
  end
  inherited ActionList: TActionList
    Left = 80
    Top = 204
    inherited actExport: TAction
      ImageIndex = 41
      OnExecute = actExportExecute
    end
    object actReport: TAction
      Caption = 'Report'
      ImageIndex = 7
      OnExecute = actReportExecute
    end
    object actCopyLastYearFiguresToBudget: TAction
      Caption = 'Use Last Year'#39's figures for this Budget'
      OnExecute = actCopyLastYearFiguresToBudgetExecute
    end
    object actBudgetReport: TAction
      Caption = 'Budget/Cash Flow Report'
      OnExecute = actBudgetReportExecute
    end
    object actZeroiseBudgetFigures: TAction
      Caption = 'Zeroise Budget Figures'
      ImageIndex = 2
      OnExecute = actZeroiseBudgetFiguresExecute
    end
    object actEditComments: TAction
      Caption = 'Edit'
      ImageIndex = 14
      OnExecute = actEditCommentsExecute
    end
    object actSaveComments: TAction
      Caption = 'Save'
      ImageIndex = 9
      OnExecute = actSaveCommentsExecute
    end
    object actCancelComments: TAction
      Caption = 'Cancel'
      ImageIndex = 10
      OnExecute = actCancelCommentsExecute
    end
  end
  object dsTempBudget: TDataSource
    Left = 178
    Top = 202
  end
  object pmOptions: TdxBarPopupMenu
    BarManager = BarManager
    ItemLinks = <
      item
        Item = dxBarButton1
        Visible = True
      end
      item
        BeginGroup = True
        Item = dxBarButton2
        Visible = True
      end>
    UseOwnFont = False
    Left = 364
    Top = 380
  end
  object DefaultStyleRepository: TcxStyleRepository
    Left = 828
    Top = 246
    object StyleReadOnly: TcxStyle
      AssignedValues = [svColor, svTextColor]
      Color = clInfoBk
      TextColor = clNavy
    end
    object cxStyle1stQuarter: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 16500373
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object cxStyle2ndQuarter: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 12776444
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object cxStyle3rdQuarter: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 6416892
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object cxStyle4thQuarter: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 5415657
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
    end
    object cxStyle1stQuarterHeader: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 16500373
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
    end
    object cxStyle2ndQuarterHeader: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 12776444
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
    end
    object cxStyle3rdQuarterHeader: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 6416892
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
    end
    object cxStyle4thQuarterHeader: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 5415657
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
    end
    object cxStyle1stQuarterMonthBand: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 16500373
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
    end
    object cxStyle2ndQuarterMonthBand: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 12776444
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
    end
    object cxStyle3rdQuarterMonthBand: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 6416892
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
    end
    object cxStyle4thQuarterMonthBand: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 5415657
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'html'
    Filter = 'Html File|*.html'
    InitialDir = 'C:\'
    Left = 148
    Top = 202
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 118
    Top = 204
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = 16637633
    end
  end
end
