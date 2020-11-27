object fmFarmGateEditForm: TfmFarmGateEditForm
  Left = 734
  Top = 229
  Width = 414
  Height = 207
  Caption = 'FarmGate Editor'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object Name: TLabel
    Left = 16
    Top = 19
    Width = 35
    Height = 17
    Caption = 'Name'
  end
  object SerialNo: TLabel
    Left = 16
    Top = 51
    Width = 50
    Height = 17
    Caption = 'SerialNo'
  end
  object Label1: TLabel
    Left = 16
    Top = 83
    Width = 139
    Height = 17
    Caption = 'Default Company Name'
  end
  object NameEdit: TEdit
    Left = 175
    Top = 16
    Width = 199
    Height = 25
    MaxLength = 31
    TabOrder = 0
  end
  object Button1: TButton
    Left = 296
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object Button2: TButton
    Left = 200
    Top = 120
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
    OnClick = Button2Click
  end
  object SerialNoEdit: TEdit
    Left = 175
    Top = 48
    Width = 199
    Height = 25
    MaxLength = 4
    TabOrder = 3
  end
  object DefaultCompanyNameEdit: TEdit
    Left = 175
    Top = 80
    Width = 199
    Height = 25
    MaxLength = 7
    TabOrder = 4
    Text = 'ACCS'
    OnExit = DefaultCompanyNameEditExit
  end
end
