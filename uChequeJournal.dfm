inherited fmChequeJournal: TfmChequeJournal
  Caption = 'Cheque Journal'
  OldCreateOrder = True
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ChequeJournalGrid: TcxGrid [1]
    Left = 0
    Top = 74
    Width = 830
    Height = 421
    Align = alClient
    TabOrder = 5
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    object ChequeJournalGridDBTableView: TcxGridDBTableView
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
      DataController.DataSource = ChequeJournal
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnFiltering = False
      OptionsView.GridLines = glHorizontal
      OptionsView.GroupByBox = False
    end
    object ChequeJournalGridLevel: TcxGridLevel
      GridView = ChequeJournalGridDBTableView
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
            Item = blbExport
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
      end
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        Caption = 'TopSub'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 48
        DockingStyle = dsTop
        FloatLeft = 604
        FloatTop = 357
        FloatClientWidth = 23
        FloatClientHeight = 22
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemLinks = <
          item
            Item = beBankAccount
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            Item = bbSelectBankAccount
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = bbGenerateBankJournal
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = bbGenerateNonBankJournal
            UserGlyph.Data = {00000000}
            Visible = True
          end>
        Name = 'TopSub'
        NotDocking = [dsNone, dsLeft, dsRight, dsBottom]
        OneOnRow = True
        Row = 1
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
    Left = 370
    Top = 12
    DockControlHeights = (
      0
      0
      74
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
    inherited blbExport: TdxBarLargeButton
      Width = 85
    end
    object beBankAccount: TdxBarEdit
      Caption = 'Bank Account'
      Category = 0
      Hint = 'Bank Account'
      Visible = ivAlways
      ShowCaption = True
      Width = 220
    end
    object bbGenerateBankJournal: TdxBarButton
      Action = actGenerateBankJournal
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object bbGenerateNonBankJournal: TdxBarButton
      Action = actGenerateNonBankJournal
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object bbSelectBankAccount: TdxBarButton
      Action = actSelectBankAccount
      Category = 0
    end
  end
  inherited ActionList: TActionList
    Left = 400
    Top = 12
    inherited actHelp: TAction
      Enabled = False
    end
    inherited actExport: TAction
      Caption = 'Export To File'
      OnExecute = actExportExecute
    end
    object actGenerateBankJournal: TAction
      Caption = 'Generate Bank Journal'
      ImageIndex = 38
      OnExecute = actGenerateBankJournalExecute
    end
    object actGenerateNonBankJournal: TAction
      Caption = 'Generate Non-Bank Journal'
      ImageIndex = 38
      OnExecute = actGenerateNonBankJournalExecute
    end
    object actSelectBankAccount: TAction
      ImageIndex = 1
      OnExecute = actSelectBankAccountExecute
    end
  end
  object ChequeJournalDB: TTable
    DatabaseName = 'WinAccsData'
    TableName = 'ChequeJournalTable.db'
    Left = 616
    Top = 8
  end
  object ChequeJournal: TDataSource
    DataSet = ChequeJournalDB
    Left = 648
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Comma Seperated Files (*.csv)|*.CSV'
    InitialDir = 'a:\'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Export Cheque Journal'
    Left = 432
    Top = 12
  end
end
