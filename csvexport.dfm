object CSVExportForm: TCSVExportForm
  Left = 169
  Top = 135
  Width = 326
  Height = 167
  Caption = 'CSVExportForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.csv'
    Filter = '*.csv|*.csv'
    Title = 'Save Export File To ....'
    Left = 48
    Top = 24
  end
end
