object SimpleInvoiceBaseFrame: TSimpleInvoiceBaseFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Lucida Sans'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object SimpleInvoiceActionList: TActionList
    Images = AccsDataModule.ImageList16x16
    Left = 128
    Top = 24
    object actCreateInvoice: TAction
      Caption = 'Create Invoices(s)'
      ImageIndex = 9
      OnExecute = actCreateInvoiceExecute
      OnUpdate = actCreateInvoiceUpdate
    end
    object actUpdateInvoice: TAction
      Caption = 'Update Invoice'
      ImageIndex = 9
      OnExecute = actUpdateInvoiceExecute
      OnUpdate = actUpdateInvoiceUpdate
    end
    object actCancelInvoice: TAction
      Caption = 'Cancel'
      ImageIndex = 10
      OnExecute = actCancelInvoiceExecute
      OnUpdate = actCancelInvoiceUpdate
    end
    object actDeleteInvoiceLine: TAction
      Caption = 'Delete Invoice Line'
      ImageIndex = 10
      OnExecute = actDeleteInvoiceLineExecute
    end
    object actDeleteInvoice: TAction
      Caption = 'Delete Invoice ( Caution! )'
      ImageIndex = 10
      OnExecute = actDeleteInvoiceExecute
    end
  end
  object FocusGridItemTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = FocusGridItemTimerTimer
    Left = 144
    Top = 104
  end
  object PopupMenu: TPopupMenu
    Images = AccsDataModule.ImageList16x16
    OnPopup = PopupMenuPopup
    Left = 280
    Top = 88
    object pmDeleteInvoiceLine: TMenuItem
      Action = actDeleteInvoiceLine
    end
    object pmDeleteInvoice: TMenuItem
      Action = actDeleteInvoice
      SubMenuImages = AccsDataModule.ImageList16x16
    end
  end
end
