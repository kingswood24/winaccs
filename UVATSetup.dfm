object VATSetupForm: TVATSetupForm
  Left = 469
  Top = 117
  Width = 645
  Height = 657
  Caption = 'Digital VAT Setup'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 64
    Width = 134
    Height = 13
    Caption = 'Financial Year Start Month - '
  end
  object FinStartLbl: TLabel
    Left = 248
    Top = 64
    Width = 45
    Height = 13
    Caption = 'FinStart'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 32
    Top = 88
    Width = 134
    Height = 13
    Caption = 'Financial Year Start Month - '
  end
  object FinYearLbl: TLabel
    Left = 248
    Top = 88
    Width = 61
    Height = 13
    Caption = 'FinYearLbl'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 180
    Height = 49
    BevelInner = bvLowered
    BevelOuter = bvLowered
    BevelWidth = 3
    BorderStyle = bsSingle
    Color = clSilver
    TabOrder = 0
    object ExitBtn: TBitBtn
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
      OnClick = ExitBtnClick
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
    object Savebtn: TBitBtn
      Left = 88
      Top = 6
      Width = 81
      Height = 33
      Hint = 'Click Here To Save Changes'
      HelpContext = 203
      Caption = '&Save'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = SavebtnClick
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
  end
  object MatchingStartCB: TCheckBox
    Left = 32
    Top = 112
    Width = 281
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Opening VAT Period lines up with financial year start'
    Checked = True
    State = cbChecked
    TabOrder = 2
    OnClick = MatchingStartCBClick
  end
  object VATStartPanel: TPanel
    Left = 24
    Top = 136
    Width = 353
    Height = 57
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object Label2: TLabel
      Left = 8
      Top = 12
      Width = 204
      Height = 13
      Caption = 'VAT Acounting Period Yearly Start Month - '
    end
    object VATStartMonthLbl: TLabel
      Left = 263
      Top = 12
      Width = 66
      Height = 13
      Caption = 'Monthname'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 26
      Top = 33
      Width = 295
      Height = 16
      Caption = '*** Note : Enter VAT Period Start Month in previous year***'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Myriad Pro'
      Font.Style = [fsItalic]
      ParentFont = False
    end
    object StartEdit: TEdit
      Left = 228
      Top = 4
      Width = 29
      Height = 21
      MaxLength = 2
      TabOrder = 0
      Text = 'StartEdit'
      OnExit = StartEditExit
    end
  end
  object VATPeriodsPanel: TPanel
    Left = 16
    Top = 56
    Width = 593
    Height = 545
    TabOrder = 1
    object Label4: TLabel
      Left = 16
      Top = 40
      Width = 283
      Height = 26
      Caption = 
        'Step 1 - Ensure VAT Period Start month is correct'#13#10'            &' +
        '& then Select VAT Return Frequency'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 16
      Top = 8
      Width = 261
      Height = 20
      Caption = 'Set-Up VAT Periods for Current Year'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label6: TLabel
      Left = 336
      Top = 40
      Width = 218
      Height = 13
      Caption = 'Step 2 - Generate VAT Return Periods'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 304
      Top = 112
      Width = 276
      Height = 39
      Caption = 
        '*** Note should a period include dates in the next financial '#13#10'y' +
        'ear this period will not be included in the current year ***'#13#10' '
    end
    object Label8: TLabel
      Left = 16
      Top = 232
      Width = 234
      Height = 13
      Caption = 'Step 3 - Confirm VAT Accounting Periods'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object FreqRG: TRadioGroup
      Left = 16
      Top = 80
      Width = 249
      Height = 129
      Caption = ' Accounting Period Return Frequency '
      ItemIndex = 1
      Items.Strings = (
        'Monthly'
        'Quarterly'
        'Other (Specify in months)')
      TabOrder = 0
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 256
      Width = 345
      Height = 265
      Caption = ' VAT Return Periods '
      TabOrder = 1
      object VATPeriodGrid: TStringGrid
        Left = 8
        Top = 24
        Width = 321
        Height = 225
        ColCount = 2
        DefaultRowHeight = 15
        FixedCols = 0
        RowCount = 13
        TabOrder = 0
        ColWidths = (
          158
          148)
      end
    end
    object CustomPeriod: TRxSpinEdit
      Left = 176
      Top = 176
      Width = 49
      Height = 21
      Decimal = 0
      MaxValue = 12
      MinValue = 1
      Value = 1
      TabOrder = 2
    end
    object GenerateBtn: TButton
      Left = 344
      Top = 72
      Width = 177
      Height = 25
      Caption = 'Generate VAT Return Periods'
      TabOrder = 3
      OnClick = GenerateBtnClick
    end
  end
end
