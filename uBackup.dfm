inherited BackupForm: TBackupForm
  Width = 537
  Height = 471
  Caption = 'Backup/Restore'
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object UndoPanel: TPanel [0]
    Left = 36
    Top = 66
    Width = 450
    Height = 330
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'UndoPanel'
    TabOrder = 6
    Visible = False
    object label1: TLabel
      Left = 18
      Top = 10
      Width = 424
      Height = 13
      Caption = 
        'Double Click The Required Undo Point To Restore Your System To T' +
        'his Time'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object FileListGrid: TStringGrid
      Left = 18
      Top = 32
      Width = 407
      Height = 281
      ColCount = 2
      DefaultColWidth = 250
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 14
      FixedRows = 0
      ScrollBars = ssVertical
      TabOrder = 0
      OnDblClick = FileListGridDblClick
    end
  end
  object RestorePanel: TPanel [1]
    Left = 38
    Top = 66
    Width = 450
    Height = 330
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = 'RestorePanel'
    TabOrder = 7
    Visible = False
    object Label2: TLabel
      Left = 20
      Top = 10
      Width = 404
      Height = 13
      Caption = 
        'Double Click The Required Backup To Restore Your System To This ' +
        'Time'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object RestoreFilesGrid: TStringGrid
      Left = 20
      Top = 32
      Width = 407
      Height = 285
      ColCount = 2
      DefaultColWidth = 155
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 14
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      ScrollBars = ssVertical
      TabOrder = 0
      OnDblClick = RestoreFilesGridDblClick
    end
  end
  object RemoveablePanel: TPanel [2]
    Left = 38
    Top = 66
    Width = 450
    Height = 330
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 5
    object PanelLabel: TLabel
      Left = 14
      Top = 14
      Width = 189
      Height = 13
      Caption = 'Select Drive to store data backup'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DriveStringGrid: TStringGrid
      Left = 14
      Top = 32
      Width = 419
      Height = 275
      ColCount = 3
      DefaultColWidth = 150
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      ScrollBars = ssVertical
      TabOrder = 0
      OnDblClick = DriveStringGridDblClick
      ColWidths = (
        42
        164
        139)
    end
  end
  inherited StatusBar: TdxStatusBar
    Top = 415
    Width = 521
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        Width = 340
      end
      item
        PanelStyleClassName = 'TdxStatusBarContainerPanelStyle'
        PanelStyle.Container = StatusBarContainer
        Width = 120
      end>
    Font.Charset = ANSI_CHARSET
    Font.Name = 'Tahoma'
    object StatusBarContainer: TdxStatusBarContainerControl
      Left = 345
      Top = 3
      Width = 159
      Height = 16
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
            Item = blbBackup
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            Item = blbRestore
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbUndo
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
    Left = 40
    Top = 144
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
      ImageIndex = 0
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
    object blbBackup: TdxBarLargeButton
      Caption = 'Backup'
      Category = 0
      Hint = 'Backup'
      Visible = ivAlways
      ButtonStyle = bsDropDown
      DropDownMenu = BarPopupMenu
      OnClick = blbBackupClick
      Height = 44
      HotImageIndex = 20
      Width = 65
      SyncImageIndex = False
      ImageIndex = 20
    end
    object blbRestore: TdxBarLargeButton
      Action = actRestore
      Category = 0
      Height = 44
      HotImageIndex = 18
      Width = 65
      SyncImageIndex = False
      ImageIndex = 18
    end
    object blbUndo: TdxBarLargeButton
      Action = actUndo
      Category = 0
      Height = 44
      HotImageIndex = 19
      Width = 55
      SyncImageIndex = False
      ImageIndex = 19
    end
    object dxBarButton1: TdxBarButton
      Action = actBackupToExternal
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actBackupToCD
      Category = 0
    end
  end
  inherited ActionList: TActionList
    Left = 40
    Top = 174
    object actBackupToCD: TAction
      Caption = 'Backup To CD (Windows XP Only)'
      ImageIndex = 21
      OnExecute = actBackupToCDExecute
    end
    object actBackupToExternal: TAction
      Caption = 'Backup Drives (Floppy / USB etc)'
      ImageIndex = 4
      OnExecute = actBackupToExternalExecute
    end
    object actUndo: TAction
      Caption = 'Undo'
      ImageIndex = 19
      OnExecute = actUndoExecute
    end
    object actRestore: TAction
      Caption = 'Restore'
      ImageIndex = 18
      OnExecute = actRestoreExecute
    end
  end
  object BarPopupMenu: TdxBarPopupMenu
    BarManager = BarManager
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemLinks = <
      item
        Item = dxBarButton1
        Visible = True
      end
      item
        Item = dxBarButton2
        Visible = True
      end>
    UseOwnFont = True
    Left = 40
    Top = 206
  end
  object ZipFile1: TZipFile
    OnMinorCallback = ZipFile1MinorCallback
    ZipFormats = []
    wZipSubOptions = []
    Options = [NoDirectoryNamesFlag]
    Top = 72
  end
  object UnzipFile1: TUnzipFile
    IndexofItem = 0
    Options = [OverWriteFlag, DecryptFlag]
    lpszDecryptCode.PChar = {636F7070657200}
    wUnzipSubOptions = []
    Left = 24
    Top = 72
  end
end
