object fmLoginCredentials: TfmLoginCredentials
  Left = 493
  Top = 220
  BorderStyle = bsDialog
  Caption = 'Kingswood MTD Login Credentials'
  ClientHeight = 227
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object cxGroupBox1: TcxGroupBox
    Left = 25
    Top = 24
    Caption = 'Enter your Kingswood MTD Username and Password'
    Style.TextStyle = [fsBold]
    TabOrder = 0
    Height = 138
    Width = 377
    object usernameTextEdit: TdxEdit
      Left = 112
      Top = 40
      Width = 233
      TabOrder = 0
      Text = 'usernameTextEdit'
    end
    object passwordTextEdit: TdxEdit
      Left = 112
      Top = 80
      Width = 233
      TabOrder = 1
      Text = 'passwordTextEdit'
      PasswordChar = '*'
    end
    object lUsername: TcxLabel
      Left = 24
      Top = 40
      Caption = 'Username:'
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI Semibold'
      Style.Font.Style = [fsBold]
      Style.TextStyle = [fsBold]
      Style.IsFontAssigned = True
    end
    object lPassword: TcxLabel
      Left = 24
      Top = 82
      Caption = 'Password:'
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI Semibold'
      Style.Font.Style = [fsBold]
      Style.TextStyle = [fsBold]
      Style.IsFontAssigned = True
    end
    object cxLabel1: TcxLabel
      Left = 24
      Top = 112
      AutoSize = False
      Caption = 'The Username is usually your VAT Number.'
      ParentColor = False
      ParentFont = False
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Style.Color = clInfoBk
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clNavy
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI Semibold'
      Style.Font.Style = [fsBold]
      Style.TextStyle = [fsBold]
      Style.IsFontAssigned = True
      Height = 21
      Width = 323
    end
  end
  object okButton: TcxButton
    Left = 237
    Top = 180
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object cancelButton: TcxButton
    Left = 325
    Top = 180
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object btnEdit: TcxButton
    Left = 26
    Top = 180
    Width = 75
    Height = 25
    Caption = 'Edit'
    Default = True
    TabOrder = 3
    OnClick = btnEditClick
  end
end
