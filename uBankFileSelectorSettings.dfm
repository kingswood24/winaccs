object fmBankFileSelectorSettings: TfmBankFileSelectorSettings
  Left = 454
  Top = 345
  BorderStyle = bsDialog
  Caption = 'Bank File Import Settings'
  ClientHeight = 336
  ClientWidth = 532
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object cxGroupBox1: TcxGroupBox
    Left = 26
    Top = 22
    Caption = 'Settings'
    Style.LookAndFeel.Kind = lfFlat
    Style.LookAndFeel.NativeStyle = False
    Style.TextStyle = [fsBold]
    StyleDisabled.LookAndFeel.Kind = lfFlat
    StyleDisabled.LookAndFeel.NativeStyle = False
    StyleFocused.LookAndFeel.Kind = lfFlat
    StyleFocused.LookAndFeel.NativeStyle = False
    StyleHot.LookAndFeel.Kind = lfFlat
    StyleHot.LookAndFeel.NativeStyle = False
    TabOrder = 0
    Height = 253
    Width = 479
    object Label2: TLabel
      Left = 16
      Top = 26
      Width = 450
      Height = 37
      AutoSize = False
      Caption = 
        'Specify a default directory where the program can search for new' +
        ' bank transaction files'
      WordWrap = True
    end
    object shlcbDefaultDirectory: TcxShellComboBox
      Left = 16
      Top = 70
      Properties.Alignment.Vert = taVCenter
      Properties.DropDownWidth = 500
      Properties.FastSearch = True
      Properties.TreeViewOptions = [tvoShowButtons, tvoShowRoot]
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 0
      Width = 442
    end
  end
  object btnOK: TcxButton
    Left = 316
    Top = 288
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
    Left = 415
    Top = 288
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
