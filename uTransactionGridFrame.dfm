object TransactionGridFrame: TTransactionGridFrame
  Left = 0
  Top = 0
  Width = 1022
  Height = 511
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object TransactionGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 1022
    Height = 511
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfFlat
    object TransactionGridTableView: TcxGridTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      object TransactionGridTableViewTradeAccount: TcxGridColumn
        Caption = 'Trade Account'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.Grouping = False
        Width = 122
      end
      object TransactionGridTableViewDate: TcxGridColumn
        Caption = 'Date'
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.Grouping = False
        Width = 146
      end
      object TransactionGridTableViewReference: TcxGridColumn
        Caption = 'Reference'
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Options.FilteringMRUItemsList = False
        Options.Grouping = False
        Width = 100
      end
      object TransactionGridTableViewComment: TcxGridColumn
        Caption = 'Comment'
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Width = 200
      end
      object TransactionGridTableViewNomCode: TcxGridColumn
        Caption = 'Nom Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Options.Grouping = False
        Width = 100
      end
      object TransactionGridTableViewNomDesc: TcxGridColumn
        Caption = 'Description'
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Width = 200
      end
      object TransactionGridTableViewVatCode: TcxGridColumn
        Caption = 'Vat Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
        Width = 50
      end
      object TransactionGridTableViewVatAmt: TcxGridColumn
        Caption = 'Vat Amount'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
      end
      object ransactionGridTableViewTotalIncVat: TcxGridColumn
        Caption = 'Total Inc Vat'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Filtering = False
      end
    end
    object TransactionGridLevel: TcxGridLevel
    end
  end
end
