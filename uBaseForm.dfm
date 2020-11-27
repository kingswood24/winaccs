object BaseForm: TBaseForm
  Left = 667
  Top = 223
  Width = 800
  Height = 551
  Caption = 'BaseForm'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TdxStatusBar
    Left = 0
    Top = 493
    Width = 784
    Height = 20
    Panels = <>
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
  end
  object BarManager: TdxBarManager
    AllowReset = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
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
        Visible = True
        WholeRow = True
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
        ShowMark = False
        SizeGrip = False
        UseOwnFont = True
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
    Images = AccsDataModule.ImageList16x16
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    PopupMenuLinks = <>
    UseSystemFont = False
    Left = 64
    Top = 80
    DockControlHeights = (
      0
      0
      52
      0)
    object blbExit: TdxBarLargeButton
      Action = actExit
      Category = 0
      Height = 44
      HotImageIndex = 3
      Width = 55
    end
    object blbView: TdxBarLargeButton
      Caption = 'View'
      Category = 0
      Hint = 'View'
      Visible = ivAlways
      Height = 44
      HotImageIndex = 8
      Width = 55
      SyncImageIndex = False
      ImageIndex = 8
    end
    object blbPrint: TdxBarLargeButton
      Caption = 'Print'
      Category = 0
      Hint = 'Print'
      Visible = ivAlways
      Height = 44
      HotImageIndex = 17
      Width = 55
      SyncImageIndex = False
      ImageIndex = 17
    end
    object blbHelp: TdxBarLargeButton
      Caption = 'Help'
      Category = 0
      Hint = 'Help'
      Visible = ivAlways
      Height = 44
      HotImageIndex = 33
      Width = 55
      SyncImageIndex = False
      ImageIndex = 33
    end
    object blbFirst: TdxBarLargeButton
      Caption = 'First'
      Category = 0
      Hint = 'First'
      Visible = ivAlways
      Height = 44
      HotImageIndex = 23
      Width = 55
      SyncImageIndex = False
      ImageIndex = 23
    end
    object blbNext: TdxBarLargeButton
      Caption = 'Next'
      Category = 0
      Hint = 'Next'
      Visible = ivAlways
      Height = 44
      HotImageIndex = 24
      Width = 55
      SyncImageIndex = False
      ImageIndex = 24
    end
    object blbLast: TdxBarLargeButton
      Caption = 'Last'
      Category = 0
      Hint = 'Last'
      Visible = ivAlways
      Height = 44
      HotImageIndex = 26
      Width = 55
      SyncImageIndex = False
      ImageIndex = 26
    end
    object blbPrior: TdxBarLargeButton
      Caption = 'Prior'
      Category = 0
      Hint = 'Prior'
      Visible = ivAlways
      Height = 44
      HotImageIndex = 24
      Width = 55
      SyncImageIndex = False
      ImageIndex = 24
    end
    object blbAdd: TdxBarLargeButton
      Action = actAdd
      Category = 0
      Height = 44
      HotImageIndex = 28
      Width = 55
    end
    object blbSave: TdxBarLargeButton
      Action = actSave
      Category = 0
      Height = 44
      HotImageIndex = 32
      Width = 55
    end
    object blbEdit: TdxBarLargeButton
      Action = actEdit
      Category = 0
      Height = 44
      HotImageIndex = 31
      Width = 55
    end
    object blbCancel: TdxBarLargeButton
      Action = actCancel
      Category = 0
      Height = 44
      HotImageIndex = 29
      Width = 55
    end
    object blbRefesh: TdxBarLargeButton
      Action = actRefresh
      Category = 0
      Height = 44
      HotImageIndex = 27
      Width = 55
    end
    object blbSave2: TdxBarLargeButton
      Action = actSave2
      Category = 0
      Height = 44
      HotImageIndex = 9
      Width = 55
      SyncImageIndex = False
      ImageIndex = 9
    end
    object blbCancel2: TdxBarLargeButton
      Action = actCancel2
      Category = 0
      Height = 44
      HotImageIndex = 10
      Width = 55
      SyncImageIndex = False
      ImageIndex = 10
    end
    object blbDelete2: TdxBarLargeButton
      Action = actDelete2
      Category = 0
      Height = 44
      HotImageIndex = 35
      Width = 55
    end
    object blbImport: TdxBarLargeButton
      Action = actImport
      Category = 0
      Height = 44
      HotImageIndex = 15
      Width = 55
    end
    object blbSelect: TdxBarLargeButton
      Action = actSelect
      Category = 0
      Height = 44
      HotImageIndex = 9
      Width = 55
    end
    object blbExport: TdxBarLargeButton
      Action = actExport
      Category = 0
      Height = 44
      HotImageIndex = 37
      Width = 55
    end
  end
  object ActionList: TActionList
    Images = AccsDataModule.ImageList16x16
    Left = 64
    Top = 114
    object actExit: TAction
      Caption = 'Exit'
      ImageIndex = 3
      OnExecute = actExitExecute
    end
    object actView: TAction
      Caption = 'View'
      ImageIndex = 8
    end
    object actPrint: TAction
      Caption = 'Print'
      ImageIndex = 17
    end
    object actHelp: TAction
      Caption = 'Help'
      ImageIndex = 33
    end
    object actFirst: TAction
      Caption = 'First'
      ImageIndex = 23
    end
    object actPrior: TAction
      Caption = 'Prior'
      ImageIndex = 24
    end
    object actNext: TAction
      Caption = 'Next'
      ImageIndex = 25
    end
    object actLast: TAction
      Caption = 'Last'
      ImageIndex = 26
    end
    object actRefresh: TAction
      Caption = 'Refresh'
      ImageIndex = 27
    end
    object actSave: TAction
      Caption = 'Save'
      ImageIndex = 32
    end
    object actCancel: TAction
      Caption = 'Cancel'
      ImageIndex = 29
    end
    object actEdit: TAction
      Caption = 'Edit'
      ImageIndex = 31
    end
    object actDelete: TAction
      Caption = 'Delete'
      ImageIndex = 30
    end
    object actAdd: TAction
      Caption = 'Add'
      ImageIndex = 28
    end
    object actSave2: TAction
      Caption = 'Save'
      ImageIndex = 9
    end
    object actDelete2: TAction
      Caption = 'Delete'
      ImageIndex = 35
    end
    object actCancel2: TAction
      Caption = 'Cancel'
      ImageIndex = 10
    end
    object actImport: TAction
      Caption = 'Import'
      ImageIndex = 15
    end
    object actSelect: TAction
      Caption = 'Select'
      ImageIndex = 9
    end
    object actExport: TAction
      Caption = 'Export'
      ImageIndex = 37
    end
  end
end
