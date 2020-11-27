object OverpaymentForm: TOverpaymentForm
  Left = 85
  Top = 86
  Width = 842
  Height = 577
  Caption = 'Allocate Overpayments / Credit Notes to Invoices'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 177
    Height = 45
    BevelInner = bvLowered
    BevelOuter = bvLowered
    BevelWidth = 2
    BorderStyle = bsSingle
    Color = clSilver
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object ExitButton: TBitBtn
      Left = 6
      Top = 4
      Width = 81
      Height = 33
      Hint = 'Click Here To Exit'
      HelpContext = 65
      Caption = 'E&xit'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = False
      OnClick = ExitButtonClick
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
    object Save: TBitBtn
      Left = 88
      Top = 4
      Width = 81
      Height = 33
      Hint = 'Click Here To Save Details'
      HelpContext = 203
      Caption = '&Save'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = False
      OnClick = SaveClick
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
  object PageControl1: TPageControl
    Left = 8
    Top = 56
    Width = 801
    Height = 481
    ActivePage = TabSheet3
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Step 1 - Select Customer / Supplier'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Microsoft Sans Serif'
      Font.Style = []
      ParentFont = False
      object ListAccounts: TSpeedButton
        Left = 200
        Top = 16
        Width = 25
        Height = 25
        Hint = 'Click Left Button to Activate F2 List'
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
        ParentShowHint = False
        ShowHint = True
        OnClick = ListAccountsClick
      end
      object Label1: TLabel
        Left = 256
        Top = 24
        Width = 39
        Height = 13
        Caption = 'Label1'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 256
        Top = 40
        Width = 32
        Height = 13
        Caption = 'Label2'
      end
      object Label3: TLabel
        Left = 256
        Top = 56
        Width = 32
        Height = 13
        Caption = 'Label3'
      end
      object Label4: TLabel
        Left = 256
        Top = 72
        Width = 32
        Height = 13
        Caption = 'Label4'
      end
      object Label5: TLabel
        Left = 256
        Top = 88
        Width = 32
        Height = 13
        Caption = 'Label5'
      end
      object Label6: TLabel
        Left = 16
        Top = 16
        Width = 121
        Height = 13
        Caption = 'Customer / Supplier Code'
      end
      object Label9: TLabel
        Left = 8
        Top = 112
        Width = 347
        Height = 13
        Caption = 
          'Select the Overpayment / Credit Note to be Allocated and click '#39 +
          'Continue'#39
      end
      object CustSuppCode: TEdit
        Left = 148
        Top = 16
        Width = 49
        Height = 21
        Hint = 'F2 to List Accounts'
        HelpContext = 15
        MaxLength = 4
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnChange = CustSuppCodeChange
        OnExit = CustSuppCodeChange
        OnKeyUp = CustSuppCodeKeyUp
      end
      object ContinueBtn1: TButton
        Left = 704
        Top = 424
        Width = 75
        Height = 25
        Caption = 'Continue >>'
        Enabled = False
        TabOrder = 1
        OnClick = ContinueBtn1Click
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 136
        Width = 769
        Height = 281
        Caption = ' Transactions '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object DBGrid1: TDBGrid
        Left = 14
        Top = 160
        Width = 758
        Height = 241
        DataSource = AccsDataModule.OverpaymentTempDS
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 3
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        OnDblClick = DBGrid1DblClick
        Columns = <
          item
            Expanded = False
            FieldName = 'Tick'
            Font.Charset = SYMBOL_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Wingdings'
            Font.Style = []
            Title.Caption = 'Select'
            Title.Font.Charset = ANSI_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -12
            Title.Font.Name = 'Verdana'
            Title.Font.Style = []
            Width = 44
            Visible = True
          end
          item
            Color = clActiveBorder
            Expanded = False
            FieldName = 'TxNo'
            ReadOnly = True
            Title.Caption = 'Tx No'
            Title.Font.Charset = ANSI_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -12
            Title.Font.Name = 'Verdana'
            Title.Font.Style = []
            Width = 68
            Visible = True
          end
          item
            Color = clActiveBorder
            Expanded = False
            FieldName = 'TxDate'
            ReadOnly = True
            Title.Caption = 'Tx Date'
            Title.Font.Charset = ANSI_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -12
            Title.Font.Name = 'Verdana'
            Title.Font.Style = []
            Width = 67
            Visible = True
          end
          item
            Color = clActiveBorder
            Expanded = False
            FieldName = 'Reference'
            ReadOnly = True
            Title.Font.Charset = ANSI_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -12
            Title.Font.Name = 'Verdana'
            Title.Font.Style = []
            Visible = True
          end
          item
            Color = clActiveBorder
            Expanded = False
            FieldName = 'TotalAmount'
            ReadOnly = True
            Title.Caption = 'Transaction Amount'
            Title.Font.Charset = ANSI_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -12
            Title.Font.Name = 'Verdana'
            Title.Font.Style = []
            Width = 132
            Visible = True
          end
          item
            Color = clActiveBorder
            Expanded = False
            FieldName = 'OverpaymentRemaining'
            ReadOnly = True
            Title.Caption = 'Overpayment Remaining'
            Title.Font.Charset = ANSI_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -12
            Title.Font.Name = 'Verdana'
            Title.Font.Style = []
            Width = 160
            Visible = True
          end
          item
            Color = clActiveBorder
            Expanded = False
            FieldName = 'CreditNoteAmount'
            ReadOnly = True
            Title.Caption = 'Credit Note Amount'
            Title.Font.Charset = ANSI_CHARSET
            Title.Font.Color = clWindowText
            Title.Font.Height = -12
            Title.Font.Name = 'Verdana'
            Title.Font.Style = []
            Width = 130
            Visible = True
          end>
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Step 2 - Allocate To Invoices'
      ImageIndex = 2
      object Label7: TLabel
        Left = 4
        Top = 9
        Width = 105
        Height = 16
        Alignment = taCenter
        Caption = 'Total Amount - '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object OverpaymentAmtLbl: TLabel
        Left = 212
        Top = 9
        Width = 25
        Height = 16
        Alignment = taCenter
        Caption = 'amt'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object RemainingAmtlbl: TLabel
        Left = 212
        Top = 33
        Width = 25
        Height = 16
        Alignment = taCenter
        Caption = 'amt'
        Font.Charset = ANSI_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 4
        Top = 33
        Width = 137
        Height = 16
        Alignment = taCenter
        Caption = 'Remaining Amount - '
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object DateLabel: TLabel
        Left = 588
        Top = 14
        Width = 72
        Height = 13
        Alignment = taRightJustify
        Caption = 'Allocation Date'
        Transparent = True
      end
      object Label18: TLabel
        Left = 24
        Top = 432
        Width = 291
        Height = 14
        Caption = '(Ensure VAT not previously claimed on invoice)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
      end
      object AllocationGrid: TDBGrid
        Left = 11
        Top = 64
        Width = 770
        Height = 353
        DataSource = AccsDataModule.AllocationTemp
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        Options = [dgEditing, dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        TabOrder = 0
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -13
        TitleFont.Name = 'Verdana'
        TitleFont.Style = []
        OnColExit = AllocationGridColExit
        OnExit = AllocationGridExit
        OnKeyDown = AllocationGridKeyDown
        Columns = <
          item
            Expanded = False
            FieldName = 'PreviousYear'
            Title.Caption = ' '
            Width = 10
            Visible = True
          end
          item
            Color = clActiveBorder
            Expanded = False
            FieldName = 'TxID'
            ReadOnly = True
            Title.Caption = 'Tx No'
            Width = 72
            Visible = True
          end
          item
            Color = clActiveBorder
            Expanded = False
            FieldName = 'InvDate'
            ReadOnly = True
            Title.Caption = 'Date'
            Visible = True
          end
          item
            Color = clInactiveBorder
            Expanded = False
            FieldName = 'InvComment'
            ReadOnly = True
            Title.Caption = 'Comment'
            Width = 165
            Visible = True
          end
          item
            Color = clInactiveBorder
            Expanded = False
            FieldName = 'InvTotal'
            ReadOnly = True
            Title.Caption = 'Total'
            Visible = True
          end
          item
            Color = clActiveBorder
            Expanded = False
            FieldName = 'Outstanding'
            ReadOnly = True
            Width = 86
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'AmountPaid'
            Title.Caption = 'Amt Paid'
            Width = 85
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Discount'
            Width = 87
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CompleteAllocation'
            Title.Caption = 'Complete'
            Width = 67
            Visible = True
          end>
      end
      object TxDate: TMaskEdit
        Left = 666
        Top = 12
        Width = 69
        Height = 21
        HelpContext = 4
        AutoSelect = False
        EditMask = '!99/99/00;1;_'
        MaxLength = 8
        TabOrder = 1
        Text = '  /  /  '
        OnExit = TxDateExit
      end
      object DateSearch: TDateTimePicker
        Left = 736
        Top = 12
        Width = 21
        Height = 24
        CalAlignment = dtaRight
        Date = 0.419326851850201
        Time = 0.419326851850201
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 2
        OnCloseUp = DateSearchCloseUp
      end
      object IncludeLastYearCB: TCheckBox
        Left = 8
        Top = 416
        Width = 257
        Height = 17
        Caption = 'Include Last Years Transactions (*)'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = IncludeLastYearCBClick
      end
    end
  end
end
