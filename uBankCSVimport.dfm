object BankCSVImportForm: TBankCSVImportForm
  Left = 16
  Top = 72
  Width = 790
  Height = 528
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = []
  Caption = 'Bank Statement Import'
  Color = clBtnFace
  Constraints.MinHeight = 458
  Constraints.MinWidth = 790
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 774
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Instructions: TLabel
      Left = 314
      Top = 5
      Width = 57
      Height = 13
      Caption = 'Instructions'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 291
    Height = 49
    BevelInner = bvLowered
    BevelOuter = bvLowered
    BevelWidth = 3
    BorderStyle = bsSingle
    Color = clSilver
    TabOrder = 0
    TabStop = True
    object Exitbtn: TBitBtn
      Left = 6
      Top = 6
      Width = 81
      Height = 33
      Hint = 'Click Here To Exit'
      HelpContext = 65
      Cancel = True
      Caption = 'E&xit'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = False
      OnClick = ExitbtnClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00330000000000
        03333377777777777F333301111111110333337F333333337F33330111111111
        0333337F333333337F333301111111110333337F333333337F33330111111111
        0333337F333333337F333301111111110333337F333333337F33330111111111
        0333337F3333333F7F333301111111B10333337F333333737F33330111111111
        0333337F333333337F333301111111110333337F33FFFFF37F3333011EEEEE11
        0333337F377777F37F3333011EEEEE110333337F37FFF7F37F3333011EEEEE11
        0333337F377777337F333301111111110333337F333333337F33330111111111
        0333337FFFFFFFFF7F3333000000000003333377777777777333}
      NumGlyphs = 2
    end
    object SaveBtn: TBitBtn
      Left = 87
      Top = 6
      Width = 81
      Height = 33
      HelpContext = 65
      Cancel = True
      Caption = '&Save'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = False
      OnClick = SaveBtnClick
      Glyph.Data = {
        BE060000424DBE06000000000000360400002800000024000000120000000100
        0800000000008802000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
        A600000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
        0303030303030303030303030303030303030303030303030303030303030303
        03030303030303030303030303030303030303030303FF030303030303030303
        03030303030303040403030303030303030303030303030303F8F8FF03030303
        03030303030303030303040202040303030303030303030303030303F80303F8
        FF030303030303030303030303040202020204030303030303030303030303F8
        03030303F8FF0303030303030303030304020202020202040303030303030303
        0303F8030303030303F8FF030303030303030304020202FA0202020204030303
        0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
        040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
        03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
        FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
        0303030303030303030303FA0202020403030303030303030303030303F8FF03
        03F8FF03030303030303030303030303FA020202040303030303030303030303
        0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
        03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
        030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
        0202040303030303030303030303030303F8FF03F8FF03030303030303030303
        03030303FA0202030303030303030303030303030303F8FFF803030303030303
        030303030303030303FA0303030303030303030303030303030303F803030303
        0303030303030303030303030303030303030303030303030303030303030303
        0303}
      NumGlyphs = 2
    end
    object SetupBtn: TBitBtn
      Left = 168
      Top = 6
      Width = 113
      Height = 33
      HelpContext = 65
      Cancel = True
      Caption = 'Bank File Format'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      TabStop = False
      OnClick = SetupBtnClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
        000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
        00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
        F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
        0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
        FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
        FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
        0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
        00333377737FFFFF773333303300000003333337337777777333}
      NumGlyphs = 2
    end
  end
  object DropDownBox: TDBComboBox
    Left = 362
    Top = 108
    Width = 73
    Height = 21
    Style = csDropDownList
    DataField = 'Type'
    DataSource = AccsDataModule.BankCSVTempTable
    ItemHeight = 13
    Items.Strings = (
      'Cash Tx'
      'DD/DC'
      'Pay / Rec'
      'Cashbook')
    TabOrder = 1
    Visible = False
  end
  object TxGrid: TDBGrid
    Left = 0
    Top = 168
    Width = 774
    Height = 324
    Align = alClient
    DataSource = AccsDataModule.BankCSVTempTable
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [dgEditing, dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    ParentFont = False
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnCellClick = TxGridCellClick
    OnColEnter = TxGridColEnter
    OnColExit = TxGridColExit
    OnDrawColumnCell = TxGridDrawColumnCell
    OnDblClick = TxGridDblClick
    OnKeyDown = TxGridKeyDown
    OnKeyPress = TxGridKeyPress
    OnKeyUp = TxGridKeyUp
    Columns = <
      item
        Alignment = taCenter
        DropDownRows = 0
        Expanded = False
        FieldName = 'Import'
        Font.Charset = SYMBOL_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Wingdings'
        Font.Style = []
        ReadOnly = True
        Width = 35
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Type'
        Title.Caption = 'Tx Type'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TxDate'
        Title.Caption = 'Date'
        Width = 55
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Details'
        Width = 140
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'StubNumber'
        Title.Caption = 'Stub No'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Expenditure'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Income'
        Width = 70
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'VATCode'
        Title.Alignment = taCenter
        Title.Caption = 'VAT;Code'
        Width = 30
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Enterprise'
        Title.Alignment = taCenter
        Title.Caption = 'Ents'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NomCode'
        Title.Alignment = taCenter
        Title.Caption = 'Nom;Code'
        Width = 29
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CustSuppName'
        Title.Alignment = taCenter
        Title.Caption = 'Customer/;Supplier'
        Width = 77
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Analysis'
        Title.Caption = 'Analysis;  Code'
        Width = 43
        Visible = True
      end>
  end
  object gbImportPanel: TGroupBox
    Left = 0
    Top = 72
    Width = 774
    Height = 96
    Align = alTop
    Caption = ' Import Details '
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    object SourceBankLabel: TLabel
      Left = 416
      Top = 24
      Width = 74
      Height = 13
      Caption = 'Source Bank - '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BrowseLabel: TLabel
      Left = 16
      Top = 58
      Width = 89
      Height = 13
      Caption = 'Browse For File - '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BankAccountLabel: TLabel
      Left = 16
      Top = 26
      Width = 82
      Height = 13
      Caption = 'Bank Account - '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object ListAccounts: TSpeedButton
      Left = 164
      Top = 20
      Width = 25
      Height = 25
      Hint = 'Click Left Button to Activate F2 List'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      Glyph.Data = {
        42010000424D4201000000000000760000002800000011000000110000000100
        040000000000CC00000000000000000000001000000010000000000000000000
        BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF003333333FBFFF
        FFFFF000000033333333FBBFFFFBF00000003333333FBFFFFBFFFE0000003333
        333FBFFFFBFBF600000033333333FBBFFFFFF70000003333333444FBFFFBF600
        000033333344834FBFFFF1000000333334847F84BFFFF6000000333334484F84
        FBBFB00000003333348F74483FF3F6000000333344FFF7433333300000003344
        8F8444333333300000003448F7433333333330000000348F7733333333333000
        000034F77433333333333F000000344443333333333330000000333333333333
        333337000000}
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = ListAccountsClick
    end
    object BankNameLabel: TLabel
      Left = 200
      Top = 26
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
    object ImportFile: TFilenameEdit
      Left = 112
      Top = 56
      Width = 345
      Height = 21
      Filter = 'CSV files (*.csv)|*.csv'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      NumGlyphs = 1
      ParentFont = False
      TabOrder = 0
      Text = '<Select Location of Bank File>'
      OnClick = ImportFileClick
      OnEnter = ImportFileEnter
    end
    object ImportBtn: TBitBtn
      Left = 464
      Top = 53
      Width = 134
      Height = 25
      Caption = 'Import Transactions'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = ImportBtnClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333330000000
        00003333377777777777333330FFFFFFFFF03FF3F7FFFF33FFF7003000000FF0
        00F077F7777773F77737E00FBFBFB0FFFFF07773333FF7FF33F7E0FBFB00000F
        F0F077F333777773F737E0BFBFBFBFB0FFF077F3333FFFF733F7E0FBFB00000F
        F0F077F333777773F737E0BFBFBFBFB0FFF077F33FFFFFF733F7E0FB0000000F
        F0F077FF777777733737000FB0FFFFFFFFF07773F7F333333337333000FFFFFF
        FFF0333777F3FFF33FF7333330F000FF0000333337F777337777333330FFFFFF
        0FF0333337FFFFFF7F37333330CCCCCC0F033333377777777F73333330FFFFFF
        0033333337FFFFFF773333333000000003333333377777777333}
      NumGlyphs = 2
    end
    object InputFormatLookup: TRxDBLookupCombo
      Left = 504
      Top = 21
      Width = 145
      Height = 22
      DropDownCount = 8
      DisplayEmpty = '<Select Source Bank>'
      EmptyValue = '<Select File Format>'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      LookupField = 'ID'
      LookupDisplay = 'BankName'
      LookupSource = AccsDataModule.BankCSVDefaults
      ParentFont = False
      TabOrder = 2
    end
    object BankAccount: TEdit
      Left = 112
      Top = 21
      Width = 49
      Height = 23
      Hint = 'F2 to List Accounts'
      HelpContext = 15
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      MaxLength = 4
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnDblClick = BankAccountDblClick
      OnExit = BankAccountExit
      OnKeyDown = BankAccountKeyDown
    end
  end
end
