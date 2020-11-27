object fmBankFileFormatSelector: TfmBankFileFormatSelector
  Left = 595
  Top = 331
  BorderStyle = bsDialog
  Caption = 'Bank File Import Settings'
  ClientHeight = 269
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 17
  object cxGroupBox1: TcxGroupBox
    Left = 34
    Top = 16
    Caption = 'Bank File Import Settings'
    Style.TextStyle = [fsBold]
    TabOrder = 0
    Height = 179
    Width = 463
    object lBankName: TcxLabel
      Left = 22
      Top = 50
      AutoSize = False
      Caption = 'Bank Account'
      Properties.Alignment.Horz = taRightJustify
      Height = 21
      Width = 85
    end
    object teBankName: TcxTextEdit
      Left = 126
      Top = 48
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 1
      Width = 299
    end
    object cxLabel1: TcxLabel
      Left = 22
      Top = 108
      AutoSize = False
      Caption = 'Source Bank'
      Properties.Alignment.Horz = taRightJustify
      Height = 21
      Width = 85
    end
    object cmboFileFormats: TcxLookupComboBox
      Left = 126
      Top = 106
      Properties.DropDownAutoSize = True
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownRows = 4
      Properties.DropDownSizeable = True
      Properties.ImmediatePost = True
      Properties.KeyFieldNames = 'ID'
      Properties.ListColumns = <
        item
          FieldName = 'BankName'
        end>
      Properties.ListOptions.AnsiSort = True
      Properties.ListOptions.ColumnSorting = False
      Properties.ListOptions.GridLines = glNone
      Properties.ListOptions.RowSelect = False
      Properties.ListOptions.ShowHeader = False
      Properties.ListSource = AccsDataModule.BankCSVDefaults
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 3
      Width = 301
    end
  end
  object btnOK: TcxButton
    Left = 309
    Top = 213
    Width = 90
    Height = 32
    Caption = 'OK'
    Default = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 1
    LookAndFeel.NativeStyle = True
  end
  object btnCancel: TcxButton
    Left = 408
    Top = 213
    Width = 90
    Height = 32
    Caption = 'Cancel'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 2
    LookAndFeel.NativeStyle = True
  end
end
