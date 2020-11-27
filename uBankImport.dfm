object fmBankImport: TfmBankImport
  Left = 279
  Top = 172
  Width = 1500
  Height = 685
  Caption = 'Bank Import'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object gbImportPanel: TcxGroupBox
    Left = 0
    Top = 49
    Align = alTop
    Caption = 'Import Details'
    Style.TextStyle = [fsBold]
    TabOrder = 0
    Height = 175
    Width = 1492
    object Instructions: TLabel
      Left = 478
      Top = 11
      Width = 57
      Height = 13
      Caption = 'Instructions'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object cxLabel1: TcxLabel
      Left = 12
      Top = 30
      Caption = 'Bank Account: '
      Style.TextStyle = []
    end
    object teBankAccount: TcxTextEdit
      Left = 112
      Top = 28
      Properties.OnChange = teBankAccountPropertiesChange
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 1
      OnDblClick = teBankAccountDblClick
      OnExit = teBankAccountExit
      OnKeyDown = teBankAccountKeyDown
      Width = 49
    end
    object BrowseLabel: TcxLabel
      Left = 12
      Top = 74
      Caption = 'Browse For File:'
      Style.TextStyle = []
    end
    object btnSearchAccount: TcxButton
      Left = 161
      Top = 27
      Width = 32
      Height = 26
      Action = actSelectBank
      TabOrder = 3
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF002173
        B500636B7300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF002173B500218C
        EF002173B500636B7300FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0031A5FF0052BD
        FF00218CEF002173B500636B7300FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0031A5
        FF0052BDFF00218CEF002173B500636B7300FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF0031A5FF0052BDFF00218CEF002173B500636B7300FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF0031A5FF0052BDFF00218CEF005A6B7300FF00FF00D5B9B400D6AD
        A500D6ADA500D6ADA500D5B9B400FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF0031A5FF0031A5FF004A423900B69B8B00F0E2C000F9EF
        C800FDF2CB00FEF4CC00ECD8C200D6ADA500FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00BB9F8800F3E3B600FCF3D100FEF6
        CD00FEF7CF00FEF9D000FDF7D200F5E6C200D6ADA500FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00D5B9B400EFE1B500FAEDBD00FFF1C100FFF3
        C200FFF5C400FFF7C500FFFAC700FDF8D200D6ADA500FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00D6ADA500EFE3B600FBECBE00FDEFBF00FEF1
        C100FFF2C200FFF4C400FFF7C500FFF9C700EEE2BB00D6ADA500FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00D6ADA500EDE1B400F6E9BE00FCF1D300FCF0
        C900FEF0C100FFF1C200FFF4C300FFF6C500F6E9C200CBAF9C00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00D6ADA500EBDEB200F2E6BB00FCF2D700FCF1
        D300FCEEC000FEEFC200FFF2C200FEF2C200EFE1BB00D2B3A300FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00D5B9B400E4D8B000EDE1B600F3E7BC00F8EB
        C000F9EBBC00FBEDBE00FAECBD00F5E9BA00D6ADA500FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00D6ADA500EADFBC00ECE0B600F0E3
        B600F1E5B700F2E5B700EFE3B500F5E7BC00D5B9B400FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00D6ADA500E0D4B500EADE
        B400EBDEB100E8DBB100D6ADA500D5B9B400FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00D5B9B400D6AD
        A500D6ADA500D9B7A300FF00FF00FF00FF00FF00FF00FF00FF00}
      LookAndFeel.Kind = lfFlat
      LookAndFeel.NativeStyle = False
    end
    object cmboBankFileFormat: TcxLookupComboBox
      Left = 503
      Top = 30
      Properties.DropDownAutoSize = True
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownRows = 4
      Properties.DropDownSizeable = True
      Properties.ImmediatePost = True
      Properties.KeyFieldNames = 'ID'
      Properties.ListColumns = <
        item
          Caption = 'Bank Name'
          SortOrder = soAscending
          FieldName = 'BankName'
        end>
      Properties.ListOptions.GridLines = glNone
      Properties.ListOptions.RowSelect = False
      Properties.ListOptions.ShowHeader = False
      Properties.ListSource = AccsDataModule.BankCSVDefaults
      Properties.Revertable = True
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 4
      Width = 145
    end
    object SourceBankLabel: TcxLabel
      Left = 411
      Top = 32
      Caption = 'Source Bank: '
      Style.TextStyle = []
    end
    object lBankAccountName: TcxLabel
      Left = 202
      Top = 30
      AutoSize = False
      Caption = 'Bank Account  '
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.TextStyle = []
      Style.IsFontAssigned = True
      Height = 21
      Width = 183
    end
    object teFileToImport: TcxTextEdit
      Left = 112
      Top = 72
      Properties.ReadOnly = True
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 7
      OnClick = teFileToImportClick
      Width = 343
    end
    object btnSelectImportFile: TcxButton
      Left = 454
      Top = 71
      Width = 32
      Height = 26
      Action = actSelectFile
      TabOrder = 8
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF001F8FCF001487
        BC001487BC001F8FCF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF001F8FCF001487BC0040A9D4002A9D
        CE001487BC00838789001F8FCF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF001F8FCF001487BC0053A7CB0066BDDE0056B5DA0040A9
        D4001487BC00838789001487BC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF001F8FCF007ECAE50078C6E20072C4E2006CC1E00066BDDE005AB7
        DC001487BC00838789001487BC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF001487BC0083CCE6007FCAE50078C6E20073C4E2006CC0E00067BD
        DE001487BC00838789001487BC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF001F8FCF0092D3E9008BCFE70086CCE6007FCAE50079C6E30073C4E2006DC1
        E0001487BC00838789001890C7001F8FCF00FF00FF00FF00FF00FF00FF00FF00
        FF001487BC0097D5EB0090D1E9008BCFE70083CCE6007FCAE50078C6E20073C4
        E2001487BC00838789001F97CB001487BC00FF00FF00FF00FF00FF00FF00FF00
        FF001487BC00A0D9ED0099D5EB0093D3EA008BD0E90086CEE6007EC9E3001487
        BC001487BC0083878900279CCE001487BC00FF00FF00FF00FF00FF00FF001F8F
        CF00ABDEEF00A6DCEE009FD8ED0099D5EB0092D3E9001487BC001487BC00FEFE
        FC00FEFEFC00838789002D9ECF002396CA001F8FCF00FF00FF00FF00FF001487
        BC00B4E2F200ADE0EF00A0D9ED001487BC001487BC00FEFEFC00FEFEFC00FEFE
        FC00838789008387890035A4D10030A0D0001487BC00FF00FF00FF00FF001487
        BC00BBE5F3001487BC001487BC00FEFEFC00FEFEFC00FEFEFC00838789008387
        89004BB0D8004BB0D8003DA7D40036A4D3001487BC00FF00FF00FF00FF001487
        BC001487BC00FEFEFC00FEFEFC00FEFEFC0083878900838789004BB0D8004BB0
        D8001487BC003AA5D10045ACD7001487BC001F8FCF00FF00FF00FF00FF00FF00
        FF0083878900FEFEFC0083878900838789004BB0D8004BB0D8001487BC001487
        BC00FF00FF001487BC001487BC00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF008387890083878900FF00FF001F8FCF001487BC001F8FCF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      LookAndFeel.Kind = lfFlat
      LookAndFeel.NativeStyle = False
    end
    object pHelpPanel: TPanel
      Left = 2
      Top = 110
      Width = 1488
      Height = 63
      Align = alBottom
      BevelInner = bvRaised
      BevelOuter = bvLowered
      Color = clInfoBk
      TabOrder = 9
      object TickBoxHelpImage: TImage
        Left = 4
        Top = 9
        Width = 28
        Height = 28
        AutoSize = True
        Picture.Data = {
          07544269746D617066090000424D660900000000000036000000280000001C00
          00001C000000010018000000000030090000D10E0000D10E0000000000000000
          0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9F78579F7857FF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFAB8460D7AF8A7D5944FF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFAB8460D9B28FD9
          B28E7D5944FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFAB8460DAB693DAB592DAB5917D5944FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC6AB8CAB8460DDBA
          99DCB898DCB897DAB693906D579F7857FF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFC6AB8CAB8460DEBD9EDEBC9DDEBC9DDDBB9ADDBA99DCB898DCB7
          95DAB592906D57AB8460FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC6AB8CAB8460E0C0A1E0C0A1
          E0C0A1E0BFA0DEBD9FDEBD9EDEBC9DDDBB9ADDBA99DCB897DAB693DAB591906D
          57FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFAB8460E1C2A5E1C2A5E1C2A5E1C2A5E1C2A5985842821500BD4316
          BD4316821500B46C43DDBA99DCB897DAB693DAB591906D57FF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFAB8460E2C4A7E2C5A9E2
          C5A9E2C5A9E2C5A9E2C5A9E2C4A7E2C4A6841C00781600E0BFA0DEBD9EDDBB9C
          DDBA99DCB897DAB592D9B490906D57FF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFC6AB8CE3C6AAE3C7ABE3C7ACE3C7ACE3C7ACE3C7ACE3C7ACE3
          C7ABE3C6AA841C00721100E1C1A4E0C0A1DEBD9EDDBB9CDDBA99DCB795DAB592
          D9B28FAB8460FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFAB8460E3C7
          ACE5CAAFE5CAB0E5CAB0E5CAB0E5CAB0E5CAB0E5CAAFE3C7AC841C00731100E2
          C4A6E1C1A4E0BFA0DEBD9EDDBB9ADCB898DAB693DAB591906D57FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFC6AB8CE5C9ADE5CAB0E6CBB1E7CEB5E7CEB5E7CE
          B5E7CEB5E7CEB5E6CBB1E5CAB0841C00731100E2C5A9E1C2A5E1C1A3E0BFA0DE
          BC9DDDBA99DCB897DAB592D9B28FAB8460FF00FFFF00FFFF00FFFF00FFFF00FF
          C6AB8CE5CAB0E6CCB2E7CFB7E9D1BBEAD4BFEAD4BFEAD4BFE9D1BBE7CFB7E6CC
          B2841C00731100E3C7ABE2C4A7E1C2A5E0C0A1DEBD9EDDBB9ADCB898DAB693D9
          B490906D57FF00FFFF00FFFF00FFFF00FFFF00FFC6AB8CE6CCB2E9D1BBEAD4BF
          EDD9C5EEDCC9EEDCC9EEDCC9EDD9C5EAD4BFE9D1BB841C00731100E3C7ACE3C6
          AAE2C4A6E1C1A3DEBD9FDEBC9DDDBA99DCB795DAB591906D57FF00FFFF00FFFF
          00FFFF00FFFF00FFC6AB8CE7CFB7EAD4BFEEDCC9F0E1D0F2E3D4F2E3D4F2E3D4
          F0E1D0C59273841C00751000630A00E5CAAFE3C7ABE2C4A7E1C1A4E0BFA0DEBC
          9DDDBA99DCB897DAB592906D57FF00FFFF00FFFF00FFFF00FFFF00FFC6AB8CE9
          D1BBEDD9C5F0E1D0F3E5D7F6EADEF6EADEF6EADEF3E5D7926B576B351C6B351C
          521E08E5CAB0E3C7ACE2C5A9E1C2A5E0C0A1DEBD9EDDBB9ADCB897DAB592906D
          57FF00FFFF00FFFF00FFFF00FFFF00FFC6AB8CEAD4BFEEDCC9F2E3D4F6EADEF8
          EFE5FAF2E9F8EFE5F6EADEF2E3D4EEDCC9EAD4BFE7CEB5E5CAB0E3C7ACE2C5A9
          E1C2A5E0C0A1DEBD9EDDBB9ADCB897DAB592AB8460FF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFC6AB8CEEDCC9F2E3D4F6EADEFAF2E9FEFAF4FAF2E9F6EADEF2
          E3D4C29783841C00DA6B37E5CAB0E3C7ACE2C5A9E1C2A5E0C0A1DEBD9EDDBB9A
          DCB897906D57FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC6AB8CEEDC
          C9F2E3D4F6EADEF8EFE5FAF2E9F8EFE5F6EADEF2E3D45D1C15841C00882007BD
          9079E3C7ACE2C5A9E1C2A5E0C0A1DEBD9EDDBB9ADCB897AB8460FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC6AB8CF0E1D0F3E5D7F6EADEF6EA
          DEF6EADEF3E5D7F0E1D064382D3C0300400600CBB7ACE3C7ACE2C5A9E1C2A5E0
          C0A1DEBD9EDDBB9A906D57FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFC6AB8CF0E1D0F2E3D4F2E3D4F2E3D4F0E1D0EEDCC9EAD4
          BFB4A39CCBC1BDE5CAAFE3C7ABE2C4A7E1C1A4E0BFA0DEBC9D906D57FF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          C6AB8CEEDCC9EEDCC9EEDCC9EDD9C5EAD4BFE9D1BBE6CCB2E5CAB0E3C7ACE3C6
          AAE2C4A6E1C1A3DEBD9F906D57FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFC6AB8CC6AB8CEAD4BF
          E9D1BBE7CFB7E6CCB2E5CAB0E5C9ADE3C7ABE2C4A7E1C2A5906D57AB8460FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFC6AB8CC6AB8CC6AB8CC6AB8CC6AB8C
          C6AB8CC6AB8CC6AB8CAB8460FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        Transparent = True
      end
      object lTickBoxHelp: TcxLabel
        Left = 34
        Top = 2
        Caption = 
          'If you do NOT wish to import a transaction, remove the tick at s' +
          'tart of transaction line.'
        ParentColor = False
        Properties.Alignment.Vert = taVCenter
        Style.Color = clInfoBk
        Style.TextColor = clMaroon
        Transparent = True
      end
      object lSplitTransactionIndicator: TcxLabel
        Left = 34
        Top = 38
        Caption = 
          'Click the Multi-Line Editor button in the second column to split' +
          ' between Income/Expense headings.'
        ParentColor = False
        Properties.Alignment.Vert = taVCenter
        Style.Color = clInfoBk
        Style.TextColor = clMaroon
        Transparent = True
      end
      object lLodgmentInfo: TcxLabel
        Left = 34
        Top = 20
        Caption = 
          'Right click into the Customer/Supplier cell to select more than ' +
          'one Customer/Supplier (Pay/Rec only).'
        ParentColor = False
        Properties.Alignment.Vert = taVCenter
        Style.Color = clInfoBk
        Style.TextColor = clMaroon
        Transparent = True
      end
    end
  end
  object BankImportGrid: TcxGrid
    Left = 0
    Top = 224
    Width = 1492
    Height = 326
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    object BankImportGridTableView: TcxGridDBTableView
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
      OnCellClick = BankImportGridTableViewCellClick
      OnEditing = BankImportGridTableViewEditing
      OnEditKeyDown = BankImportGridTableViewEditKeyDown
      OnEditKeyPress = BankImportGridTableViewEditKeyPress
      OnEditKeyUp = BankImportGridTableViewEditKeyUp
      OnEditValueChanged = BankImportGridTableViewEditValueChanged
      OnFocusedItemChanged = BankImportGridTableViewFocusedItemChanged
      OnFocusedRecordChanged = BankImportGridTableViewFocusedRecordChanged
      OnInitEdit = BankImportGridTableViewInitEdit
      DataController.DataSource = AccsDataModule.BankCSVTempTable
      DataController.KeyFieldNames = 'ID'
      DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoFocusTopRowAfterSorting, dcoImmediatePost]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.CellHints = True
      OptionsBehavior.FocusCellOnTab = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnFiltering = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.HideFocusRectOnExit = False
      OptionsSelection.InvertSelect = False
      OptionsSelection.UnselectFocusedRecordOnExit = False
      OptionsView.DataRowHeight = 26
      OptionsView.GridLines = glHorizontal
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 42
      Styles.OnGetContentStyle = BankImportGridTableViewStylesGetContentStyle
      object BankImportGridTableViewImport: TcxGridDBColumn
        DataBinding.FieldName = 'Import'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.Alignment = taCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C30E0000C30E00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF187A2FFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FF187A2F1C902F187A2FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FF2383461C902F1C902F1C902F187A2FFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          187A2F1C902F21A43B1E8A3E1C902F187A2FFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FF287B4B1C902F21A43B1B743E1B743E21A43B2B
          8A2D21A43BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF187A2F
          21A43B1B743EFF00FFFF00FF1B743E21A43B187A2FFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FF1B743EFF00FFFF00FFFF00FFFF00FF1B
          743E21A43B187A2FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1B743E21A43B21A43BFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF1B743E1C902FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1B743E1C902FFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF1B743E1C902FFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1B74
          3E1C902FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FF1B743E1C902FFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FF1B743EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        HeaderGlyphAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Moving = False
        Options.Sorting = False
        Width = 25
        IsCaptionAssigned = True
      end
      object BankImportGridTableViewSplitTransID: TcxGridDBColumn
        DataBinding.FieldName = 'SplitTransID'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000230F0000230F00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0E61B90E61B9FF
          00FFFF00FFFF00FF0E61B90E61B9FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF066BDB066BDB066BDB0E61B9FF00FF0E61B9066BDB066BDB066B
          DBFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF066BDBFF00FFFF00FF0E
          61B9FF00FF0E61B9FF00FFFF00FF066BDBFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF066BDB3690EBFF00FF0E61B9FF00FF0E61B9FF00FF3690EB066B
          DBFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF4E7ECC066BDB066BDB0E
          61B9A594840E61B9066BDB066BDB4E7ECCFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FF4E7ECC4E7ECC0E61B98C634A0E61B94E7ECC4E7ECCFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF85
          8585E7DED6858585FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FF858585EAEAEA858585EAEAEA858585FF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA0A0A0EA
          EAEAA0A0A0EAEAEAA0A0A0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFFF00FFA0A0A0EAEAEAA0A0A0FF00FFA0A0A0EAEAEAA0A0A0FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF858585A0A0A0FF
          00FFFF00FFFF00FFA0A0A0858585FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF858585EAEAEAB4B4B4FF00FFFF00FFFF00FFB4B4B4EAEAEA8585
          85FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF858585A0A0A0FF00FFFF
          00FFFF00FFFF00FFFF00FFA0A0A0858585FF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FFA0A0A0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFA0A0
          A0FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
        Width = 30
        IsCaptionAssigned = True
      end
      object BankImportGridTableViewMultiLineEdit: TcxGridDBColumn
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              18000000000000030000530B0000530B00000000000000000000FF00FFFF00FF
              FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
              FFFF00FFFF00FFFF00FFFF00FFAFAFAF999C9E999C9E999C9E999C9E999C9E99
              9C9E999C9E999C9E999C9E999C9E999C9E999C9E999C9EFF00FFFF00FFAFAFAF
              FEFEFDFEFEFDFEFEFDFBFBFAF8F8F7F5F5F4F1F1F0EEEEEDEBEBEAE8E8E7DEDE
              DED2D2D2999C9EFF00FFFF00FFAFAFAFFEFEFDF69536F69536F69536F69536F6
              9536F69536F69536F69536F69536F69536DEDEDE999C9EFF00FFFF00FFAFAFAF
              FEFEFDF69536FFFFFFFFFFFFF69536FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF695
              36E8E8E7999C9EFF00FFFF00FFAFAFAFFEFEFDF69536F69536F69536527BC63E
              6ABCF69536F69536F69536F69536F69536EBEBEA999C9EFF00FFFF00FFAFAFAF
              FEFEFDF69536FFFFFFFFFFFF00F7FF527BC63E6ABCFFFFFFFFFFFFFFFFFFF695
              36EEEEED999C9EFF00FFFF00FFAFAFAFFEFEFDF69536F69536F6953639A5FF00
              F7FF527BC63E6ABC3E6ABCF69536F69536F1F1F0999C9EFF00FFFF00FFAFAFAF
              FEFEFDF69536FFFFFFFFFFFFF6953639A5FF94FFFF00F7FF527BC63E6ABCF695
              36F6F6F5999C9EFF00FFFF00FFAFAFAFFEFEFDF69536F695363E6ABC3E6ABC3E
              6ABC3E6ABC94FFFF00F7FF527BC63E6ABCFAFAF9999C9EFF00FFFF00FFAFAFAF
              FEFEFDF69536FFFFFF39A5FF94FFFF00F7FF00F7FF00F7FF00F7FF00F7FF527B
              C63E6ABC999C9EFF00FFFF00FFAFAFAFFEFEFDD4730AD4730AD4730A39A5FF94
              FFFF00F7FF527BC63E6ABCD4730AD4730AFEFEFD999C9EFF00FFFF00FFAFAFAF
              FEFEFDD4730AD4730AD4730AD4730A39A5FF94FFFF00F7FF527BC63E6ABCD473
              0AFEFEFD999C9EFF00FFFF00FFAFAFAFFEFEFDFEFEFDFEFEFDFEFEFDFEFEFD39
              A5FF94FFFF00F7FF00F7FF527BC63E6ABCFEFEFD999C9EFF00FFFF00FFAFAFAF
              999C9E999C9E999C9E999C9E999C9E999C9E39A5FF94FFFF00F7FF00F7FF527B
              C63E6ABC999C9EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
              00FFFF00FF39A5FF94FFFF00F7FF00F7FF527BC63E6ABCFF00FF}
            Kind = bkGlyph
            Stretchable = False
          end>
        Properties.ReadOnly = True
        HeaderAlignmentVert = vaCenter
        HeaderGlyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000530B0000530B00000000000000000000FF00FFFF00FF
          FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFAFAFAF999C9E999C9E999C9E999C9E999C9E99
          9C9E999C9E999C9E999C9E999C9E999C9E999C9E999C9EFF00FFFF00FFAFAFAF
          FEFEFDFEFEFDFEFEFDFBFBFAF8F8F7F5F5F4F1F1F0EEEEEDEBEBEAE8E8E7DEDE
          DED2D2D2999C9EFF00FFFF00FFAFAFAFFEFEFDF69536F69536F69536F69536F6
          9536F69536F69536F69536F69536F69536DEDEDE999C9EFF00FFFF00FFAFAFAF
          FEFEFDF69536FFFFFFFFFFFFF69536FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF695
          36E8E8E7999C9EFF00FFFF00FFAFAFAFFEFEFDF69536F69536F69536F69536F6
          9536F69536F69536F69536F69536F69536EBEBEA999C9EFF00FFFF00FFAFAFAF
          FEFEFDF69536FFFFFFFFFFFFF69536FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF695
          36EEEEED999C9EFF00FFFF00FFAFAFAFFEFEFDF69536F69536F69536F69536F6
          9536F69536F69536F69536F69536F69536F1F1F0999C9EFF00FFFF00FFAFAFAF
          FEFEFDF69536FFFFFFFFFFFFF69536FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF695
          36F6F6F5999C9EFF00FFFF00FFAFAFAFFEFEFDF69536F69536F69536F69536F6
          9536F695361B74AF1B74AF1B74AF1B74AF1B74AF1B74AF1B74AFFF00FFAFAFAF
          FEFEFDF69536FFFFFFFFFFFFF69536FFFFFFFFFFFF1B74AF098DCD098DCD098D
          CD098DCD098DCD1B74AFFF00FFAFAFAFFEFEFDD4730AD4730AD4730AD4730AD4
          730AD4730A1B74AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1B74AFFF00FFAFAFAF
          FEFEFDD4730AD4730AD4730AD4730AD4730AD4730A1B74AF098DCDFFFFFFFFFF
          FFFFFFFF098DCD1B74AFFF00FFAFAFAFFEFEFDFEFEFDFEFEFDFEFEFDFEFEFDFE
          FEFDFEFEFD1B74AF098DCD098DCDFFFFFF098DCD098DCD1B74AFFF00FFAFAFAF
          999C9E999C9E999C9E999C9E999C9E999C9E999C9E1B74AF098DCD098DCD098D
          CD098DCD098DCD1B74AFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
          00FFFF00FF1B74AF1B74AF1B74AF1B74AF1B74AF1B74AF1B74AF}
        MinWidth = 22
        Options.Filtering = False
        Options.IncSearch = False
        Options.ShowEditButtons = isebAlways
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Options.Sorting = False
        Width = 22
        IsCaptionAssigned = True
      end
      object BankImportGridTableViewIncomeOrExpense: TcxGridDBColumn
        Caption = 'Receipt/'#13#10'Payment (+/-)'
        DataBinding.FieldName = 'IncomeOrExpense'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 91
      end
      object BankImportGridTableViewTransactionType: TcxGridDBColumn
        Caption = 'Transaction'#13#10'Type'
        DataBinding.FieldName = 'TransactionType'
        RepositoryItem = erTransactionTypes
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Styles.Header = EmphasizedHeaderStyle
        Width = 130
      end
      object BankImportGridTableViewTxDate: TcxGridDBColumn
        Caption = 'Date'
        DataBinding.FieldName = 'TxDate'
        PropertiesClassName = 'TcxDateEditProperties'
        Properties.Alignment.Vert = taVCenter
        Properties.OnPopup = BankImportGridTableViewTxDatePropertiesPopup
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 79
      end
      object BankImportGridTableViewStubNumber: TcxGridDBColumn
        Caption = 'Stub Number'
        DataBinding.FieldName = 'StubNumber'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Width = 70
      end
      object BankImportGridTableViewDetails: TcxGridDBColumn
        Caption = 'Comment'
        DataBinding.FieldName = 'Details'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Options.Sorting = False
        Width = 148
      end
      object BankImportGridTableViewExtraDetail1: TcxGridDBColumn
        Caption = 'Extra Detail 1'
        DataBinding.FieldName = 'Details1'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 148
      end
      object BankImportGridTableViewExtraDetail2: TcxGridDBColumn
        Caption = 'Extra Detail 2'
        DataBinding.FieldName = 'Details2'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.Alignment.Vert = taVCenter
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 148
      end
      object BankImportGridTableViewCustSuppName: TcxGridDBColumn
        Caption = 'Customer/'#13#10'Supplier'
        DataBinding.FieldName = 'CustSuppName'
        RepositoryItem = erButtonEdit
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 116
      end
      object BankImportGridTableViewNomCode: TcxGridDBColumn
        DataBinding.FieldName = 'NomCode'
        Visible = False
      end
      object BankImportGridTableViewNominalName: TcxGridDBColumn
        Caption = 'Income/Expense '#13#10'Account'
        DataBinding.FieldName = 'NomName'
        RepositoryItem = erButtonEdit
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Styles.Header = EmphasizedHeaderStyle
        Width = 145
      end
      object BankImportGridTableViewNomFreeText: TcxGridDBColumn
        DataBinding.FieldName = 'NomFreeText'
        Visible = False
        IsCaptionAssigned = True
      end
      object BankImportGridTableViewEnterprise: TcxGridDBColumn
        Caption = 'Enter-'#13#10'prise'
        DataBinding.FieldName = 'Enterprise'
        RepositoryItem = erButtonEdit
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 45
      end
      object BankImportGridTableViewQuantity: TcxGridDBColumn
        Caption = 'Quantity'
        DataBinding.FieldName = 'Quantity1'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Alignment.Horz = taLeftJustify
        Properties.Alignment.Vert = taVCenter
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 68
      end
      object BankImportGridTableViewAmount: TcxGridDBColumn
        DataBinding.FieldName = 'Amount'
        RepositoryItem = erCurrency
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Width = 65
      end
      object BankImportGridTableViewDiscount: TcxGridDBColumn
        DataBinding.FieldName = 'Discount'
        RepositoryItem = erCurrency
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
      end
      object BankImportGridTableViewVATCode: TcxGridDBColumn
        Caption = 'VAT'#13#10'Code'
        DataBinding.FieldName = 'VATCode'
        RepositoryItem = erButtonEdit
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Width = 40
      end
      object BankImportGridTableViewAnalysis: TcxGridDBColumn
        Caption = 'Analysis'#13#10'Code'
        DataBinding.FieldName = 'Analysis'
        RepositoryItem = erButtonEdit
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Options.Sorting = False
        Width = 53
      end
      object BankImportGridTableViewIsMultiLineTransaction: TcxGridDBColumn
        DataBinding.FieldName = 'IsMultiLineTransaction'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
      object BankImportGridTableViewTransHash: TcxGridDBColumn
        DataBinding.FieldName = 'Hash'
        Visible = False
      end
      object BankImportGridTableViewSplitTransaction: TcxGridDBColumn
        DataBinding.FieldName = 'IsSplitTransaction'
        Visible = False
        Width = 20
      end
    end
    object BankImportGridLevel: TcxGridLevel
      GridView = BankImportGridTableView
    end
  end
  object StatusBar: TdxStatusBar
    Left = 0
    Top = 634
    Width = 1492
    Height = 20
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
  end
  object gbTransactionLegend: TcxGroupBox
    Left = 0
    Top = 550
    Align = alBottom
    Caption = 'Transaction Type Legend'
    Style.TextStyle = [fsBold]
    TabOrder = 3
    Height = 84
    Width = 1492
    object cxLabel2: TcxLabel
      Left = 6
      Top = 20
      Caption = 'Cash Sale/Purch :'
      Style.TextStyle = [fsBold]
    end
    object cxLabel4: TcxLabel
      Left = 6
      Top = 40
      Caption = 'Receipt / Payment :'
      Style.TextStyle = [fsBold]
    end
    object cxLabel6: TcxLabel
      Left = 136
      Top = 20
      Caption = 'Cash Sale / Cash Purchase'
    end
    object cxLabel7: TcxLabel
      Left = 136
      Top = 40
      Caption = 'Customer Receipt / Supplier Payment'
    end
    object cxLabel8: TcxLabel
      Left = 6
      Top = 60
      Caption = 'DD / DC / SO : '
      Style.TextStyle = [fsBold]
    end
    object cxLabel9: TcxLabel
      Left = 136
      Top = 60
      Caption = 'Direct Debit / Direct Credit / Standing Order'
    end
    object lLegCashbookHead: TcxLabel
      Left = 395
      Top = 40
      Caption = 'Cashbook :'
      Style.TextStyle = [fsBold]
    end
    object lLegCashbookDetail: TcxLabel
      Left = 492
      Top = 40
      Caption = 'Cashbook Income / Expenditure'
    end
    object lBankTransfer: TcxLabel
      Left = 395
      Top = 20
      Caption = 'Bank Transfer :'
      Style.TextStyle = [fsBold]
    end
    object lBankTransferDesc: TcxLabel
      Left = 492
      Top = 18
      Caption = 'Transfer to another Bank Account'
    end
  end
  object BarManager: TdxBarManager
    AllowReset = False
    Font.Charset = ANSI_CHARSET
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
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbSave
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbSelectDeSelectAllTrans
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbSettings
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbHelp
            Visible = True
          end>
        Name = 'TopToolbar'
        OneOnRow = True
        Row = 0
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
    HotImages = AccsDataModule.ImageList16x16
    Images = AccsDataModule.ImageList16x16
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    PopupMenuLinks = <>
    Style = bmsUseLookAndFeel
    UseSystemFont = False
    Left = 860
    Top = 8
    DockControlHeights = (
      0
      0
      49
      0)
    object blbExit: TdxBarLargeButton
      Action = actExit
      Category = 0
      AutoGrayScale = False
      Height = 44
      HotImageIndex = 3
      Width = 65
    end
    object blbSave: TdxBarLargeButton
      Action = actSave
      Category = 0
      AutoGrayScale = False
      Height = 44
      HotImageIndex = 9
      Width = 75
    end
    object blbSettings: TdxBarLargeButton
      Action = actBankFileFormat
      Caption = 'Settings'
      Category = 0
      DropDownMenu = BarPopupMenu
      AutoGrayScale = False
      Height = 44
      HotImageIndex = 6
      Width = 65
    end
    object bbBankFileFormat: TdxBarButton
      Action = actBankFileFormat
      Category = 0
    end
    object blbHelp: TdxBarLargeButton
      Action = actHelp
      Category = 0
      AutoGrayScale = False
      Height = 44
      HotImageIndex = 33
      Width = 65
      SyncImageIndex = False
      ImageIndex = 33
    end
    object dxBarButton1: TdxBarButton
      Action = DeselectAllTransactions
      Category = 0
    end
    object blbSelectDeSelectAllTrans: TdxBarLargeButton
      Action = DeselectAllTransactions
      Category = 0
      AutoGrayScale = False
      Height = 45
      HotImageIndex = 46
      Width = 80
      SyncImageIndex = False
      ImageIndex = 46
    end
    object blbAddLine: TdxBarLargeButton
      Action = actSplitTrans
      Category = 0
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000230B0000230B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0FA5280F
        A5280FA5280FA528FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF0FA5287EE09E51CD830FA528FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0FA5287E
        E09E38C2730FA528FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF0FA5287EE09E38C2730FA528FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0FA5287E
        E09E38C2730FA528FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0FA528
        0FA5280FA5280FA5280FA5280FA5287EE09E38C2730FA5280FA5280FA5280FA5
        280FA5280FA528FF00FFFF00FF0FA5287EE09E38C27338C27338C27338C27338
        C27338C27338C27338C27338C27338C27351CD830FA528FF00FFFF00FF0FA528
        5FD38B5FD38B5FD38B5FD38B5FD38B51CD8338C2735FD38B5FD38B5FD38B5FD3
        8B5FD38B0FA528FF00FFFF00FF0FA5280FA5280FA5280FA5280FA5280FA5287E
        E09E38C2730FA5280FA5280FA5280FA5280FA5280FA528FF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF0FA5287EE09E38C2730FA528FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0FA5287E
        E09E38C2730FA528FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF0FA5287EE09E38C2730FA528FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0FA52851
        CD835FD38B0FA528FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF0FA5280FA5280FA5280FA528FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      Height = 45
      LargeGlyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000230B0000230B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0FA5280F
        A5280FA5280FA528FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF0FA5287EE09E51CD830FA528FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0FA5287E
        E09E38C2730FA528FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF0FA5287EE09E38C2730FA528FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0FA5287E
        E09E38C2730FA528FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0FA528
        0FA5280FA5280FA5280FA5280FA5287EE09E38C2730FA5280FA5280FA5280FA5
        280FA5280FA528FF00FFFF00FF0FA5287EE09E38C27338C27338C27338C27338
        C27338C27338C27338C27338C27338C27351CD830FA528FF00FFFF00FF0FA528
        5FD38B5FD38B5FD38B5FD38B5FD38B51CD8338C2735FD38B5FD38B5FD38B5FD3
        8B5FD38B0FA528FF00FFFF00FF0FA5280FA5280FA5280FA5280FA5280FA5287E
        E09E38C2730FA5280FA5280FA5280FA5280FA5280FA528FF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF0FA5287EE09E38C2730FA528FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0FA5287E
        E09E38C2730FA528FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF0FA5287EE09E38C2730FA528FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0FA52851
        CD835FD38B0FA528FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FF0FA5280FA5280FA5280FA528FF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      Width = 65
    end
  end
  object ActionList: TActionList
    Images = AccsDataModule.ImageList16x16
    Left = 828
    Top = 8
    object actExit: TAction
      Caption = 'Exit'
      ImageIndex = 3
      OnExecute = actExitExecute
    end
    object actHelp: TAction
      Caption = 'Help'
      ImageIndex = 33
    end
    object actImportTransactions: TAction
      Caption = 'Import Transactions'
      OnExecute = actImportTransactionsExecute
      OnUpdate = actImportTransactionsUpdate
    end
    object actSave: TAction
      Caption = 'Save'
      ImageIndex = 9
      OnExecute = actSaveExecute
    end
    object actBankFileFormat: TAction
      Caption = 'Bank File Format'
      ImageIndex = 14
      OnExecute = actBankFileFormatExecute
    end
    object actSelectFile: TAction
      ImageIndex = 43
      OnExecute = actSelectFileExecute
    end
    object actSelectBank: TAction
      ImageIndex = 1
      OnExecute = actSelectBankExecute
    end
    object actSplitTransaction: TAction
      Caption = 'Split Into Multi Line Transaction'
      ImageIndex = 40
    end
    object actRemoveTransactionLine: TAction
      Caption = 'Remove Transaction Line'
      ImageIndex = 10
    end
    object DeselectAllTransactions: TAction
      Caption = 'Deselect All'
      ImageIndex = 46
      OnExecute = DeselectAllTransactionsExecute
    end
    object actSplitTrans: TAction
      Caption = 'Add Customer/Supplier'
      ImageIndex = 16
      OnExecute = actSplitTransExecute
    end
    object SelectAllTransactions: TAction
      Caption = 'Select All'
      ImageIndex = 47
      OnExecute = SelectAllTransactionsExecute
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
        Item = bbBankFileFormat
        Visible = True
      end
      item
        Item = dxBarButton1
        Visible = True
      end>
    UseOwnFont = True
    Left = 796
    Top = 8
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '.csv'
    Filter = 'CSV|*.csv'
    Left = 766
    Top = 8
  end
  object cxEditRepository1: TcxEditRepository
    Left = 734
    Top = 8
    object erTransactionTypes: TcxEditRepositoryComboBoxItem
      Properties.Alignment.Vert = taVCenter
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownSizeable = True
      Properties.ImmediatePost = True
      Properties.ImmediateUpdateText = True
      Properties.ItemHeight = 21
      Properties.PostPopupValueOnTab = True
      Properties.OnChange = erTransactionTypesPropertiesChange
    end
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
    Left = 702
    Top = 8
    object TransGridMultiLineStyle: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 14150126
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsItalic]
    end
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
    object TransGridSplitTransStyle: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 16372072
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsItalic]
    end
  end
  object pmRightBtn: TPopupMenu
    Left = 892
    Top = 8
    object pmiSplitTransaction: TMenuItem
      Action = actSplitTrans
    end
  end
end
