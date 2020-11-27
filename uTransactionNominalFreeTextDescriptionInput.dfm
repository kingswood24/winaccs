object fmTransactionNominalFreeTextDescriptionInput: TfmTransactionNominalFreeTextDescriptionInput
  Left = 256
  Top = 219
  Width = 461
  Height = 191
  Caption = 'Nominal Free Text Description Input'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 17
  object cxGroupBox1: TcxGroupBox
    Left = 18
    Top = 8
    Caption = 'Nominal Free Text Description'
    TabOrder = 0
    Height = 89
    Width = 411
    object lQuantity2: TcxLabel
      Left = 13
      Top = 35
      AutoSize = False
      Caption = 'Description'
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Height = 21
      Width = 75
    end
    object teDescription: TcxTextEdit
      Left = 99
      Top = 34
      Properties.MaxLength = 30
      TabOrder = 1
      Width = 289
    end
  end
  object btnOK: TcxButton
    Left = 276
    Top = 110
    Width = 75
    Height = 32
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TcxButton
    Left = 354
    Top = 110
    Width = 75
    Height = 32
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
