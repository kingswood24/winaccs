object ProductListingForm: TProductListingForm
  Left = 360
  Top = 156
  Width = 352
  Height = 478
  BorderIcons = []
  Caption = 'Product Listing'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Searchlabel: TLabel
    Left = 12
    Top = 348
    Width = 89
    Height = 16
    Alignment = taRightJustify
    Caption = 'Search Term:'
  end
  object Searchfield: TEdit
    Left = 106
    Top = 344
    Width = 221
    Height = 24
    Hint = 'Enter Product Name to Search For'
    HelpContext = 80
    AutoSelect = False
    AutoSize = False
    Ctl3D = True
    MaxLength = 20
    ParentCtl3D = False
    TabOrder = 0
    OnChange = SearchfieldChange
  end
  object Panel1: TPanel
    Left = 13
    Top = 380
    Width = 314
    Height = 51
    BevelInner = bvLowered
    BevelOuter = bvLowered
    BevelWidth = 3
    BorderStyle = bsSingle
    Color = clSilver
    TabOrder = 1
    object AddRemoveButton: TBitBtn
      Left = 94
      Top = 8
      Width = 126
      Height = 33
      Hint = 'Add / Remove Products'
      Caption = '&Add / Remove'
      TabOrder = 2
      OnClick = AddRemoveButtonClick
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000010000000000000000
        80000080000000808000800000008000800080800000C0C0C000B14E5A00D9A8
        AE00000000000000000000000000000000000000000000000000000000000000
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
        000000000000000000000000000000000000ECD5D800A4A0A000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFF00FFFFFFFF04040404040404FFFFFFFFFF00FF
        FFFF04040404040404FFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        00FFFFFFFFFFFFFFFFFFFFFFFFF9F9FFFF00FFFFFFFFFFFFFFFFFFFFFFF9F9FF
        FFFF00FFFFFFFFFFFFFFFFFFFFF9F9FFFFFFFF00FFFFFFFFFFFFF9F9F9F9F9F9
        F9F9FFFF00FFFFFFFFFFF9F9F9F9F9F9F9F9FFFFFF00FFFFFFFFFFFFFFF9F9FF
        FFFFFFFFFFFF00FFFFFFFFFFFFF9F9FFFFFFFFFFFFFFFF00FFFFFFFFFFF9F9FF
        FFFFFFFFFFFFFFFF00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00}
    end
    object ListSelect: TBitBtn
      Left = 7
      Top = 8
      Width = 87
      Height = 33
      Hint = 'Press To Select'
      Caption = '&Select'
      Default = True
      TabOrder = 0
      OnClick = ListSelectClick
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
    object ListCancel: TBitBtn
      Left = 220
      Top = 8
      Width = 84
      Height = 33
      Hint = 'Press to Cancel'
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = ListCancelClick
      Kind = bkCancel
    end
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 8
    Width = 320
    Height = 321
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 2
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = 'Verdana'
    TitleFont.Style = []
    OnDrawColumnCell = DBGrid1DrawColumnCell
    Columns = <
      item
        Expanded = False
        FieldName = 'Desc1'
        Title.Caption = 'Product Description'
        Width = 188
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DefaultPrice'
        Title.Caption = 'Default Price'
        Width = 102
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ID'
        Width = 0
        Visible = True
      end>
  end
  object ProductsQuery: TQuery
    Left = 56
    Top = 304
  end
  object DataSource1: TDataSource
    DataSet = ProductsQuery
    Left = 24
    Top = 304
  end
end