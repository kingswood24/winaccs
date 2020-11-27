object Register: TRegister
  Left = 391
  Top = 305
  Width = 468
  Height = 278
  Caption = 'Kingswood Accounts Registration'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 460
    Height = 244
    Align = alClient
    TabOrder = 0
    object Bevel1: TBevel
      Left = 10
      Top = 50
      Width = 439
      Height = 88
      Shape = bsFrame
    end
    object Bevel2: TBevel
      Left = 10
      Top = 143
      Width = 439
      Height = 58
      Shape = bsFrame
    end
    object Label1: TLabel
      Left = 44
      Top = 79
      Width = 96
      Height = 16
      Alignment = taRightJustify
      Caption = 'Serial Number:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 18
      Top = 106
      Width = 122
      Height = 16
      Alignment = taRightJustify
      Caption = 'Authorisation Key:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 147
      Top = 55
      Width = 129
      Height = 13
      Caption = 'Unlock the program'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 147
      Top = 149
      Width = 121
      Height = 13
      Caption = 'Update Executions'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 249
      Top = 171
      Width = 10
      Height = 16
      Caption = 'X'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 23
      Top = 168
      Width = 82
      Height = 16
      Alignment = taRightJustify
      Caption = 'Update Key:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Bevel3: TBevel
      Left = 10
      Top = 9
      Width = 439
      Height = 35
      Shape = bsFrame
    end
    object Label8: TLabel
      Left = 18
      Top = 18
      Width = 163
      Height = 16
      Caption = 'Customer Serial Number:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 184
      Top = 18
      Width = 42
      Height = 16
      Caption = 'Label4'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
    end
    object Label9: TLabel
      Left = 341
      Top = 171
      Width = 10
      Height = 16
      Caption = 'X'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 155
      Top = 171
      Width = 10
      Height = 16
      Caption = 'X'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object SerialNumber: TEdit
      Left = 147
      Top = 72
      Width = 224
      Height = 24
      Color = clMenu
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object AuthorisationKey: TEdit
      Left = 147
      Top = 104
      Width = 224
      Height = 24
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnChange = AuthorisationKeyChange
    end
    object Edit1: TEdit
      Left = 167
      Top = 166
      Width = 80
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnChange = Edit1Change
    end
    object Edit2: TEdit
      Left = 260
      Top = 166
      Width = 80
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnChange = Edit1Change
    end
    object Button1: TButton
      Left = 240
      Top = 213
      Width = 82
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 6
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 354
      Top = 213
      Width = 82
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 7
      OnClick = Button2Click
    end
    object Edit3: TEdit
      Left = 353
      Top = 166
      Width = 80
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnChange = Edit1Change
    end
    object Edit4: TEdit
      Left = 111
      Top = 166
      Width = 42
      Height = 24
      CharCase = ecUpperCase
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnChange = Edit1Change
    end
  end
end
