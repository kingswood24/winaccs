object BankMultiLineTransEditForm: TBankMultiLineTransEditForm
  Left = 542
  Top = 249
  Width = 715
  Height = 450
  Caption = 'Multi Line Editing'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object gbTransactionOptions: TcxGroupBox
    Left = 0
    Top = 0
    Align = alTop
    Caption = 'Multi-Line Transaction Details'
    Style.TextColor = clBlue
    Style.TextStyle = [fsBold]
    TabOrder = 0
    Height = 117
    Width = 707
    object cxLabel1: TcxLabel
      Left = 6
      Top = 88
      Caption = 'Description: '
    end
    object HelpLabel: TcxLabel
      Left = 8
      Top = 17
      AutoSize = False
      Caption = 
        'Select a %s account from the grid below and enter the transactio' +
        'n amount. '#13#10'Please note: The total of all transactions below mus' +
        't equal the amount stated on the initial bank transaction. Use t' +
        'he information below to guide you through the entry process.'
      Properties.WordWrap = True
      Height = 68
      Width = 641
    end
    object DescriptionLabel: TcxLabel
      Left = 82
      Top = 86
      AutoSize = False
      Caption = 'DescriptionLabel '
      ParentColor = False
      Properties.Alignment.Vert = taVCenter
      Style.BorderStyle = ebsSingle
      Style.Color = clInfoBk
      Style.TextColor = clNavy
      Height = 26
      Width = 199
    end
    object Label22: TcxLabel
      Left = 290
      Top = 88
      Caption = 'Date:'
    end
    object cxLabel5: TcxLabel
      Left = 423
      Top = 88
      Caption = 'Total: '
    end
    object cxLabel6: TcxLabel
      Left = 544
      Top = 88
      Caption = 'Remaining: '
    end
    object DateLabel: TcxLabel
      Left = 327
      Top = 86
      AutoSize = False
      Caption = '31/12/20'
      ParentColor = False
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Style.BorderStyle = ebsSingle
      Style.Color = clInfoBk
      Style.TextColor = clNavy
      Height = 26
      Width = 87
    end
    object AmountLabel: TcxLabel
      Left = 463
      Top = 86
      AutoSize = False
      ParentColor = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Style.BorderStyle = ebsSingle
      Style.Color = clInfoBk
      Style.TextColor = clNavy
      Height = 26
      Width = 75
    end
    object RemainingBalanceLabel: TcxLabel
      Left = 614
      Top = 86
      AutoSize = False
      ParentColor = False
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Style.BorderStyle = ebsSingle
      Style.Color = clInfoBk
      Height = 26
      Width = 75
    end
  end
  object cxGroupBox1: TcxGroupBox
    Left = 0
    Top = 117
    Align = alClient
    Style.TextStyle = [fsBold]
    TabOrder = 1
    Height = 302
    Width = 707
    object DeleteLineButton: TcxButton
      Left = 117
      Top = 256
      Width = 105
      Height = 32
      Action = actDeleteLine
      Anchors = [akLeft, akBottom]
      TabOrder = 2
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00002EE4001B48FB00FF00FF001B48
        FB00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00002EE4001B48FB00FF00FF00FF00FF001B48
        FB003E5EFF00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00002EE4001B48FB00FF00FF00FF00FF00FF00FF001B48
        FB001B48FB003E5EFF00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00002EE4001B48FB00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF003E5EFF001B48FB003E5EFF00002EE400FF00FF00FF00FF00FF00FF00FF00
        FF00002EE4001B48FB00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF001B48FB003E5EFF00002EE400FF00FF00FF00FF00002E
        E400002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF001B48FB003E5EFF00002EE400002EE400002E
        E400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF001B48FB001B48FB001B48FB00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF001B48FB003E5EFF001B48FB003E5EFF00002E
        E400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF001B48FB003E5EFF00002EE400FF00FF00FF00FF001B48
        FB00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF001B48FB003E5EFF00002EE400FF00FF00FF00FF00FF00FF00FF00
        FF001B48FB00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF001B48FB003E5EFF00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF001B48FB00002EE400FF00FF00FF00FF00FF00FF00FF00FF001B48
        FB006482FF00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00002EE400FF00FF00FF00FF001B48FB006482
        FF00002EE400FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF001B48FB001B48
        FB00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      LookAndFeel.Kind = lfOffice11
    end
    object CloseButton: TcxButton
      Left = 601
      Top = 256
      Width = 90
      Height = 32
      Action = actClose
      Anchors = [akRight, akBottom]
      Default = True
      TabOrder = 3
      LookAndFeel.Kind = lfOffice11
    end
    object BankImportGrid: TcxGrid
      Left = 2
      Top = 20
      Width = 703
      Height = 227
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      LookAndFeel.Kind = lfFlat
      LookAndFeel.NativeStyle = False
      object BankImportGridTableView: TcxGridDBTableView
        OnKeyPress = BankImportGridTableViewKeyPress
        NavigatorButtons.ConfirmDelete = False
        NavigatorButtons.First.Visible = True
        NavigatorButtons.PriorPage.Visible = True
        NavigatorButtons.Prior.Visible = True
        NavigatorButtons.Next.Visible = True
        NavigatorButtons.NextPage.Visible = True
        NavigatorButtons.Last.Visible = True
        NavigatorButtons.Insert.Visible = True
        NavigatorButtons.Delete.Visible = True
        NavigatorButtons.Edit.Visible = True
        NavigatorButtons.Post.Visible = True
        NavigatorButtons.Cancel.Visible = True
        NavigatorButtons.Refresh.Visible = True
        NavigatorButtons.SaveBookmark.Visible = True
        NavigatorButtons.GotoBookmark.Visible = True
        NavigatorButtons.Filter.Visible = True
        FilterBox.CustomizeDialog = False
        OnCellDblClick = BankImportGridTableViewCellDblClick
        OnEditKeyDown = BankImportGridTableViewEditKeyDown
        OnEditValueChanged = BankImportGridTableViewEditValueChanged
        OnFocusedItemChanged = BankImportGridTableViewFocusedItemChanged
        OnInitEdit = BankImportGridTableViewInitEdit
        DataController.DataSource = AccsDataModule.BankCSVTempTable
        DataController.KeyFieldNames = 'LineId'
        DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoFocusTopRowAfterSorting, dcoImmediatePost]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',#.00'
            Kind = skSum
            FieldName = 'Amount'
            Column = BankImportGridTableViewAmount
          end>
        DataController.Summary.SummaryGroups = <>
        DataController.Summary.OnAfterSummary = BankImportGridTableViewDataControllerSummaryAfterSummary
        OptionsBehavior.CellHints = True
        OptionsBehavior.FocusCellOnTab = True
        OptionsBehavior.FocusFirstCellOnNewRecord = True
        OptionsBehavior.FocusCellOnCycle = True
        OptionsCustomize.ColumnFiltering = False
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsSelection.HideFocusRectOnExit = False
        OptionsSelection.InvertSelect = False
        OptionsSelection.UnselectFocusedRecordOnExit = False
        OptionsView.DataRowHeight = 26
        OptionsView.Footer = True
        OptionsView.GridLines = glHorizontal
        OptionsView.GroupByBox = False
        OptionsView.HeaderHeight = 42
        OptionsView.Indicator = True
        OptionsView.IndicatorWidth = 15
        object BankImportGridTableViewImport: TcxGridDBColumn
          DataBinding.FieldName = 'Import'
          PropertiesClassName = 'TcxCheckBoxProperties'
          Properties.Alignment = taCenter
          Visible = False
          HeaderAlignmentHorz = taCenter
          HeaderGlyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000C30E0000C30E00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF187A2FFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FF187A2F1C902F187A2FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF2383461C902F1C902F1C902F187A2FFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            187A2F1C902F21A43B1E8A3E1C902F187A2FFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FF287B4B1C902F21A43B1B743E1B743E21A43B2B
            8A2D21A43BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF187A2F
            21A43B1B743EFF00FFFF00FF1B743E21A43B187A2FFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF1B743EFF00FFFF00FFFF00FFFF00FF1B
            743E21A43B187A2FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1B743E21A43B21A43BFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FF1B743E1C902FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1B743E1C902FFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FF1B743E1C902FFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1B74
            3E1C902FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FF1B743E1C902FFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FF1B743EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
          HeaderGlyphAlignmentHorz = taCenter
          Options.Filtering = False
          Options.Moving = False
          Options.Sorting = False
          Width = 25
          IsCaptionAssigned = True
        end
        object BankImportGridTableViewTransactionType: TcxGridDBColumn
          Caption = 'Transaction'#13#10'Type'
          DataBinding.FieldName = 'TransactionType'
          Visible = False
          HeaderAlignmentHorz = taCenter
          Width = 99
        end
        object BankImportGridTableViewTxDate: TcxGridDBColumn
          Caption = 'Date'
          DataBinding.FieldName = 'TxDate'
          PropertiesClassName = 'TcxDateEditProperties'
          Properties.Alignment.Vert = taVCenter
          Visible = False
          HeaderAlignmentHorz = taCenter
          Width = 79
        end
        object BankImportGridTableViewDetails: TcxGridDBColumn
          DataBinding.FieldName = 'Details'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Vert = taVCenter
          Visible = False
          HeaderAlignmentHorz = taCenter
          Options.Filtering = False
          Options.Sorting = False
          Width = 148
        end
        object BankImportGridTableViewStubNumber: TcxGridDBColumn
          Caption = 'Stub Number'
          DataBinding.FieldName = 'StubNumber'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Vert = taVCenter
          Visible = False
          HeaderAlignmentHorz = taCenter
          Options.Filtering = False
          Width = 70
        end
        object BankImportGridTableViewIncomeOrExpense: TcxGridDBColumn
          Caption = 'Receipt/'#13#10'Payment (+/-)'
          DataBinding.FieldName = 'IncomeOrExpense'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Vert = taVCenter
          Visible = False
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 91
        end
        object BankImportGridTableViewNominalName: TcxGridDBColumn
          Caption = 'Income/Expense'#13#10'Account'
          DataBinding.FieldName = 'NomName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Alignment.Vert = taVCenter
          Properties.Buttons = <
            item
              Default = True
              Glyph.Data = {
                36030000424D3603000000000000360000002800000010000000100000000100
                18000000000000030000420B0000420B00000000000000000000FF00FF2173B5
                636B73FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FF2173B5218CEF2173B5636B73FF00FFFF00FFFF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF31A5FF52BDFF
                218CEF2173B5636B73FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FF31A5FF52BDFF218CEF2173B5636B73FF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
                31A5FF52BDFF218CEF2173B5636B73FF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF31A5FF52BDFF218CEF5A6B73FF
                00FFD5B9B4D6ADA5D6ADA5D6ADA5D5B9B4FF00FFFF00FFFF00FFFF00FFFF00FF
                FF00FFFF00FF31A5FF31A5FF4A4239B69B8BF0E2C0F9EFC8FDF2CBFEF4CCECD8
                C2D6ADA5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFBB9F88F3
                E3B6FCF3D1FEF6CDFEF7CFFEF9D0FDF7D2F5E6C2D6ADA5FF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFD5B9B4EFE1B5FAEDBDFFF1C1FFF3C2FFF5C4FFF7C5FFFA
                C7FDF8D2D6ADA5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD6ADA5EFE3B6FB
                ECBEFDEFBFFEF1C1FFF2C2FFF4C4FFF7C5FFF9C7EEE2BBD6ADA5FF00FFFF00FF
                FF00FFFF00FFFF00FFD6ADA5EDE1B4F6E9BEFCF1D3FCF0C9FEF0C1FFF1C2FFF4
                C3FFF6C5F6E9C2CBAF9CFF00FFFF00FFFF00FFFF00FFFF00FFD6ADA5EBDEB2F2
                E6BBFCF2D7FCF1D3FCEEC0FEEFC2FFF2C2FEF2C2EFE1BBD2B3A3FF00FFFF00FF
                FF00FFFF00FFFF00FFD5B9B4E4D8B0EDE1B6F3E7BCF8EBC0F9EBBCFBEDBEFAEC
                BDF5E9BAD6ADA5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD6ADA5EA
                DFBCECE0B6F0E3B6F1E5B7F2E5B7EFE3B5F5E7BCD5B9B4FF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFFF00FFD6ADA5E0D4B5EADEB4EBDEB1E8DBB1D6AD
                A5D5B9B4FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
                00FFD5B9B4D6ADA5D6ADA5D9B7A3FF00FFFF00FFFF00FFFF00FF}
              Kind = bkGlyph
            end>
          Properties.CharCase = ecUpperCase
          HeaderAlignmentHorz = taCenter
          Width = 279
        end
        object BankImportGridTableViewEnterprise: TcxGridDBColumn
          DataBinding.FieldName = 'Enterprise'
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 68
        end
        object BankImportGridTableViewCustSuppName: TcxGridDBColumn
          Caption = 'Customer/'#13#10'Supplier'
          DataBinding.FieldName = 'CustSuppName'
          Visible = False
          HeaderAlignmentHorz = taCenter
          Width = 116
        end
        object BankImportGridTableViewQuantity: TcxGridDBColumn
          Caption = 'Quantity'
          DataBinding.FieldName = 'Quantity1'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          HeaderAlignmentHorz = taCenter
          Width = 68
        end
        object BankImportGridTableViewAmount: TcxGridDBColumn
          DataBinding.FieldName = 'Amount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.Alignment.Vert = taVCenter
          HeaderAlignmentHorz = taCenter
          Options.Filtering = False
          Width = 95
        end
        object BankImportGridTableViewVATCode: TcxGridDBColumn
          Caption = 'VAT'#13#10'Code'
          DataBinding.FieldName = 'VATCode'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          Properties.Buttons = <
            item
              Default = True
              Glyph.Data = {
                36030000424D3603000000000000360000002800000010000000100000000100
                18000000000000030000420B0000420B00000000000000000000FF00FF2173B5
                636B73FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FF2173B5218CEF2173B5636B73FF00FFFF00FFFF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF31A5FF52BDFF
                218CEF2173B5636B73FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FF31A5FF52BDFF218CEF2173B5636B73FF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
                31A5FF52BDFF218CEF2173B5636B73FF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF31A5FF52BDFF218CEF5A6B73FF
                00FFD5B9B4D6ADA5D6ADA5D6ADA5D5B9B4FF00FFFF00FFFF00FFFF00FFFF00FF
                FF00FFFF00FF31A5FF31A5FF4A4239B69B8BF0E2C0F9EFC8FDF2CBFEF4CCECD8
                C2D6ADA5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFBB9F88F3
                E3B6FCF3D1FEF6CDFEF7CFFEF9D0FDF7D2F5E6C2D6ADA5FF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFD5B9B4EFE1B5FAEDBDFFF1C1FFF3C2FFF5C4FFF7C5FFFA
                C7FDF8D2D6ADA5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD6ADA5EFE3B6FB
                ECBEFDEFBFFEF1C1FFF2C2FFF4C4FFF7C5FFF9C7EEE2BBD6ADA5FF00FFFF00FF
                FF00FFFF00FFFF00FFD6ADA5EDE1B4F6E9BEFCF1D3FCF0C9FEF0C1FFF1C2FFF4
                C3FFF6C5F6E9C2CBAF9CFF00FFFF00FFFF00FFFF00FFFF00FFD6ADA5EBDEB2F2
                E6BBFCF2D7FCF1D3FCEEC0FEEFC2FFF2C2FEF2C2EFE1BBD2B3A3FF00FFFF00FF
                FF00FFFF00FFFF00FFD5B9B4E4D8B0EDE1B6F3E7BCF8EBC0F9EBBCFBEDBEFAEC
                BDF5E9BAD6ADA5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD6ADA5EA
                DFBCECE0B6F0E3B6F1E5B7F2E5B7EFE3B5F5E7BCD5B9B4FF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFFF00FFD6ADA5E0D4B5EADEB4EBDEB1E8DBB1D6AD
                A5D5B9B4FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
                00FFD5B9B4D6ADA5D6ADA5D9B7A3FF00FFFF00FFFF00FFFF00FF}
              Kind = bkGlyph
            end>
          HeaderAlignmentHorz = taCenter
          Options.Filtering = False
          Width = 60
        end
        object BankImportGridTableViewAnalysis: TcxGridDBColumn
          Caption = 'Analysis'#13#10'Code'
          DataBinding.FieldName = 'Analysis'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Alignment.Vert = taVCenter
          Properties.Buttons = <
            item
              Default = True
              Glyph.Data = {
                36030000424D3603000000000000360000002800000010000000100000000100
                18000000000000030000420B0000420B00000000000000000000FF00FF2173B5
                636B73FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FF2173B5218CEF2173B5636B73FF00FFFF00FFFF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF31A5FF52BDFF
                218CEF2173B5636B73FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FF31A5FF52BDFF218CEF2173B5636B73FF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
                31A5FF52BDFF218CEF2173B5636B73FF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF31A5FF52BDFF218CEF5A6B73FF
                00FFD5B9B4D6ADA5D6ADA5D6ADA5D5B9B4FF00FFFF00FFFF00FFFF00FFFF00FF
                FF00FFFF00FF31A5FF31A5FF4A4239B69B8BF0E2C0F9EFC8FDF2CBFEF4CCECD8
                C2D6ADA5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFBB9F88F3
                E3B6FCF3D1FEF6CDFEF7CFFEF9D0FDF7D2F5E6C2D6ADA5FF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFD5B9B4EFE1B5FAEDBDFFF1C1FFF3C2FFF5C4FFF7C5FFFA
                C7FDF8D2D6ADA5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD6ADA5EFE3B6FB
                ECBEFDEFBFFEF1C1FFF2C2FFF4C4FFF7C5FFF9C7EEE2BBD6ADA5FF00FFFF00FF
                FF00FFFF00FFFF00FFD6ADA5EDE1B4F6E9BEFCF1D3FCF0C9FEF0C1FFF1C2FFF4
                C3FFF6C5F6E9C2CBAF9CFF00FFFF00FFFF00FFFF00FFFF00FFD6ADA5EBDEB2F2
                E6BBFCF2D7FCF1D3FCEEC0FEEFC2FFF2C2FEF2C2EFE1BBD2B3A3FF00FFFF00FF
                FF00FFFF00FFFF00FFD5B9B4E4D8B0EDE1B6F3E7BCF8EBC0F9EBBCFBEDBEFAEC
                BDF5E9BAD6ADA5FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD6ADA5EA
                DFBCECE0B6F0E3B6F1E5B7F2E5B7EFE3B5F5E7BCD5B9B4FF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFFF00FFD6ADA5E0D4B5EADEB4EBDEB1E8DBB1D6AD
                A5D5B9B4FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
                00FFD5B9B4D6ADA5D6ADA5D9B7A3FF00FFFF00FFFF00FFFF00FF}
              Kind = bkGlyph
            end>
          HeaderAlignmentHorz = taCenter
          Options.Filtering = False
          Options.Sorting = False
          Width = 61
        end
      end
      object BankImportGridLevel: TcxGridLevel
        GridView = BankImportGridTableView
      end
    end
    object AddLineButton: TcxButton
      Left = 8
      Top = 256
      Width = 105
      Height = 32
      Action = actAddLine
      Anchors = [akLeft, akBottom]
      TabOrder = 1
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528000FA528000FA528000FA5
        2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0051CD83000FA5
        2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0038C273000FA5
        2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0038C273000FA5
        2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0038C273000FA5
        2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000FA5
        28000FA528000FA528000FA528000FA528000FA528007EE09E0038C273000FA5
        28000FA528000FA528000FA528000FA528000FA52800FF00FF00FF00FF000FA5
        28007EE09E0038C2730038C2730038C2730038C2730038C2730038C2730038C2
        730038C2730038C2730038C2730051CD83000FA52800FF00FF00FF00FF000FA5
        28005FD38B005FD38B005FD38B005FD38B005FD38B0051CD830038C273005FD3
        8B005FD38B005FD38B005FD38B005FD38B000FA52800FF00FF00FF00FF000FA5
        28000FA528000FA528000FA528000FA528000FA528007EE09E0038C273000FA5
        28000FA528000FA528000FA528000FA528000FA52800FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0038C273000FA5
        2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0038C273000FA5
        2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528007EE09E0038C273000FA5
        2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000FA5280051CD83005FD38B000FA5
        2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF000FA528000FA528000FA528000FA5
        2800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
      LookAndFeel.Kind = lfOffice11
    end
  end
  object ActionList1: TActionList
    Images = AccsDataModule.ImageList16x16
    Left = 230
    Top = 264
    object actAddLine: TAction
      Caption = 'Add Line'
      ImageIndex = 16
      OnExecute = actAddLineExecute
      OnUpdate = actAddLineUpdate
    end
    object actDeleteLine: TAction
      Caption = 'Delete Line'
      ImageIndex = 10
      OnExecute = actDeleteLineExecute
      OnUpdate = actDeleteLineUpdate
    end
    object actClose: TAction
      Caption = 'Close'
      OnExecute = actCloseExecute
    end
  end
  object HideHintTimer: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = HideHintTimerTimer
    Left = 258
    Top = 265
  end
end
