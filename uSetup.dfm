inherited fmAccountSetup: TfmAccountSetup
  Left = 364
  Top = 163
  Width = 832
  Height = 585
  Caption = 'Account Setup'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TdxStatusBar
    Top = 529
    Width = 816
  end
  object PageControl: TcxPageControl [1]
    Left = 0
    Top = 48
    Width = 816
    Height = 481
    ActivePage = tsEnterprises
    Align = alClient
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    Style = 9
    TabHeight = 32
    TabOrder = 5
    TabWidth = 140
    OnChange = PageControlChange
    OnPageChanging = PageControlPageChanging
    ClientRectBottom = 481
    ClientRectRight = 816
    ClientRectTop = 33
    object tsNominalAccounts: TcxTabSheet
      Caption = 'Nominal Accounts'
      ImageIndex = 0
      object gbNominalAccounts: TcxGroupBox
        Left = 10
        Top = 9
        Caption = 'Nominal Accounts'
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
        Height = 426
        Width = 795
        object Bevel1: TBevel
          Left = 508
          Top = 18
          Width = 277
          Height = 7
          Shape = bsBottomLine
        end
        object Bevel2: TBevel
          Left = 494
          Top = 71
          Width = 291
          Height = 7
          Shape = bsBottomLine
        end
        object LabelNomCode: TLabel
          Left = 429
          Top = 103
          Width = 39
          Height = 13
          Alignment = taRightJustify
          Caption = 'Account'
        end
        object LabelNomName: TLabel
          Left = 441
          Top = 131
          Width = 27
          Height = 13
          Alignment = taRightJustify
          Caption = 'Name'
        end
        object LabelNomBalance: TLabel
          Left = 431
          Top = 189
          Width = 37
          Height = 13
          Alignment = taRightJustify
          Caption = 'Balance'
        end
        object LabelNomReportGroup: TLabel
          Left = 403
          Top = 217
          Width = 65
          Height = 13
          Alignment = taRightJustify
          Caption = 'Report Group'
        end
        object LabelNomVatCode: TLabel
          Left = 424
          Top = 159
          Width = 44
          Height = 13
          Alignment = taRightJustify
          Caption = 'Vat Code'
        end
        object LabelNomGroupDesc: TLabel
          Left = 383
          Top = 245
          Width = 85
          Height = 13
          Alignment = taRightJustify
          Caption = 'Group Description'
        end
        object lProductsNoms: TLabel
          Left = 431
          Top = 273
          Width = 37
          Height = 13
          Alignment = taRightJustify
          Caption = 'Product'
        end
        object Depreclabel: TLabel
          Left = 563
          Top = 83
          Width = 56
          Height = 13
          Alignment = taRightJustify
          Caption = 'Deprec (%)'
          Visible = False
        end
        object TypeLabel: TLabel
          Left = 404
          Top = 297
          Width = 64
          Height = 13
          Alignment = taRightJustify
          Caption = 'Nominal Type'
        end
        object depreclabel2: TLabel
          Left = 651
          Top = 83
          Width = 56
          Height = 13
          Alignment = taRightJustify
          Caption = 'Deprec Amt'
          Visible = False
        end
        object cxLabel1: TcxLabel
          Left = 382
          Top = 16
          Caption = 'Select Account Type'
          Style.TextStyle = [fsBold]
          Style.TransparentBorder = False
        end
        object cmboNominalAccountTypes: TcxComboBox
          Left = 384
          Top = 40
          Properties.DropDownSizeable = True
          Properties.OnChange = cmboNominalAccountTypesPropertiesChange
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 1
          Width = 401
        end
        object cxLabel2: TcxLabel
          Left = 384
          Top = 67
          Caption = 'Add/Edit Account'
          Style.TextStyle = [fsBold]
        end
        object NomRepGroup: TcxButtonEdit
          Left = 478
          Top = 213
          HelpContext = 142
          Properties.Buttons = <
            item
              Kind = bkGlyph
            end>
          Properties.OnButtonClick = NomRepGroupPropertiesButtonClick
          Properties.OnChange = NomRepGroupPropertiesChange
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 3
          OnExit = NomRepGroupExit
          OnKeyDown = NomRepGroupKeyDown
          Width = 51
        end
        object NomVatCode: TcxButtonEdit
          Left = 478
          Top = 158
          HelpContext = 12
          Properties.Buttons = <
            item
              Kind = bkGlyph
            end>
          Properties.OnButtonClick = NomVatCodePropertiesButtonClick
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 4
          OnDblClick = NomVatCodeDblClick
          OnExit = NomVatCodeExit
          OnKeyDown = NomVatCodeKeyDown
          Width = 51
        end
        object NomBalance: TcxTextEdit
          Left = 478
          Top = 186
          HelpContext = 141
          Properties.OnChange = NomBalancePropertiesChange
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.Color = clWindow
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 5
          OnExit = NomBalanceExit
          Width = 81
        end
        object NomName: TcxTextEdit
          Left = 478
          Top = 130
          HelpContext = 140
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 6
          OnExit = NomNameExit
          Width = 242
        end
        object NomCode: TcxTextEdit
          Left = 478
          Top = 103
          HelpContext = 22
          TabStop = False
          Enabled = False
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 7
          Width = 57
        end
        object NomGroupDesc: TcxTextEdit
          Left = 478
          Top = 241
          HelpContext = 9
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 8
          Width = 242
        end
        object ShowOpening: TRadioButton
          Left = 566
          Top = 196
          Width = 137
          Height = 17
          Action = actCurrentOpeningBalance
          Caption = 'Show Opening'
          TabOrder = 9
        end
        object ShowCurrent: TRadioButton
          Left = 566
          Top = 180
          Width = 133
          Height = 17
          Action = actCurrentOpeningBalance
          Caption = 'Sho&w Current'
          Checked = True
          TabOrder = 10
          TabStop = True
        end
        object NomEntCode: TcxTextEdit
          Left = 532
          Top = 213
          TabStop = False
          Enabled = False
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 11
          Width = 27
        end
        object Deprec_edit: TcxTextEdit
          Left = 542
          Top = 103
          Properties.OnChange = Deprec_editPropertiesChange
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 12
          OnExit = Deprec_editExit
          Width = 81
        end
        object Deprec_edit2: TcxTextEdit
          Left = 630
          Top = 103
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 13
          OnExit = Deprec_edit2Exit
          Width = 89
        end
        object btnNomAccHelp: TcxButton
          Left = 382
          Top = 389
          Width = 75
          Height = 25
          Action = actNomAccHelp
          TabOrder = 14
          LookAndFeel.Kind = lfOffice11
        end
        object btnNomAccSave: TcxButton
          Left = 461
          Top = 389
          Width = 75
          Height = 25
          Action = actNomAccSave
          TabOrder = 15
          LookAndFeel.Kind = lfOffice11
        end
        object btnNomAccDelete: TcxButton
          Left = 540
          Top = 389
          Width = 75
          Height = 25
          Action = actNomAccDelete
          TabOrder = 16
          LookAndFeel.Kind = lfOffice11
        end
        object btnNomAccAdd: TcxButton
          Left = 619
          Top = 389
          Width = 75
          Height = 25
          Action = actNomAccAdd
          TabOrder = 17
          LookAndFeel.Kind = lfOffice11
        end
        object btnNomAccCancel: TcxButton
          Left = 698
          Top = 389
          Width = 75
          Height = 25
          Action = actNomAccCancel
          TabOrder = 18
          LookAndFeel.Kind = lfOffice11
        end
        object cbProductsNoms: TcxDBLookupComboBox
          Left = 478
          Top = 269
          RepositoryItem = AccsDataModule.erNominalLookup
          DataBinding.DataField = 'Product'
          DataBinding.DataSource = AccsDataModule.dsNominalList
          Properties.ListColumns = <>
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 19
          Width = 201
        end
        object btnClearProduct: TcxButton
          Left = 680
          Top = 269
          Width = 39
          Height = 20
          Action = actClearProduct
          TabOrder = 20
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = False
        end
        object NominalTypeDropdown: TcxComboBox
          Left = 478
          Top = 295
          RepositoryItem = AccsDataModule.erNominalTypeLookup
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 21
          Width = 201
        end
        object NomAccsGrid: TcxGrid
          Left = 7
          Top = 18
          Width = 356
          Height = 397
          TabOrder = 22
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = False
          object NomAccsGridTableView: TcxGridTableView
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
            FilterBox.Visible = fvNever
            OnFocusedRecordChanged = NomAccsGridTableViewFocusedRecordChanged
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Options = [dcoAnsiSort, dcoCaseInsensitive, dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoFocusTopRowAfterSorting]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnFiltering = False
            OptionsCustomize.ColumnGrouping = False
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsSelection.CellSelect = False
            OptionsView.DataRowHeight = 26
            OptionsView.GridLines = glHorizontal
            OptionsView.GroupByBox = False
            OptionsView.HeaderHeight = 26
            OptionsView.Indicator = True
            OptionsView.IndicatorWidth = 15
            object NomAccsGridTableViewNo: TcxGridColumn
              Caption = 'No'
              PropertiesClassName = 'TcxTextEditProperties'
              Properties.Alignment.Vert = taVCenter
              OnGetDisplayText = NomAccsGridTableViewNoGetDisplayText
              HeaderAlignmentVert = vaCenter
              Options.SortByDisplayText = isbtOff
              Width = 45
            end
            object NomAccsGridTableViewName: TcxGridColumn
              Caption = 'Name'
              PropertiesClassName = 'TcxTextEditProperties'
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentVert = vaCenter
              Width = 205
            end
            object NomAccsGridTableViewEnt: TcxGridColumn
              Caption = 'Ent'
              PropertiesClassName = 'TcxTextEditProperties'
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentVert = vaCenter
              Width = 40
            end
          end
          object NomAccsGridLevel: TcxGridLevel
            GridView = NomAccsGridTableView
          end
        end
      end
    end
    object tsEnterprises: TcxTabSheet
      Caption = 'Enterprises'
      ImageIndex = 1
      object cxGroupBox1: TcxGroupBox
        Left = 10
        Top = 9
        Caption = 'Enterprises'
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
        Height = 426
        Width = 795
        object Bevel4: TBevel
          Left = 508
          Top = 18
          Width = 277
          Height = 7
          Shape = bsBottomLine
        end
        object LabelEntCode: TLabel
          Left = 384
          Top = 42
          Width = 68
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Code'
        end
        object LabelEntUnitdiv: TLabel
          Left = 384
          Top = 66
          Width = 68
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'No Units'
        end
        object LabelEntName: TLabel
          Left = 555
          Top = 42
          Width = 52
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Name'
        end
        object LabelEntUnitName: TLabel
          Left = 555
          Top = 66
          Width = 52
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Unit Name'
        end
        object LabelEntIncomeRange: TLabel
          Left = 480
          Top = 112
          Width = 69
          Height = 13
          Caption = 'Income Range'
        end
        object LabelEntExpendRange1: TLabel
          Left = 652
          Top = 110
          Width = 92
          Height = 13
          Caption = 'Expenditure Range'
        end
        object LabelEntPercOverheads: TLabel
          Left = 482
          Top = 90
          Width = 124
          Height = 13
          Alignment = taRightJustify
          Caption = 'Percentage of Overheads'
        end
        object Bevel5: TBevel
          Left = 510
          Top = 196
          Width = 277
          Height = 7
          Shape = bsBottomLine
        end
        object LabelEntAccount: TLabel
          Left = 384
          Top = 256
          Width = 68
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Account'
        end
        object LabelEntAccountName: TLabel
          Left = 528
          Top = 256
          Width = 27
          Height = 13
          Alignment = taRightJustify
          Caption = 'Name'
        end
        object LabelEntAccountVatNo: TLabel
          Left = 384
          Top = 304
          Width = 68
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'VAT Code'
        end
        object LabelEntAccountRepGroup: TLabel
          Left = 384
          Top = 280
          Width = 68
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Report Group'
        end
        object LabelEntAccountGroupDesc: TLabel
          Left = 560
          Top = 304
          Width = 85
          Height = 13
          Alignment = taRightJustify
          Caption = 'Group Description'
          Visible = False
        end
        object lProductsEnts: TLabel
          Left = 384
          Top = 352
          Width = 68
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Product'
        end
        object EntTypeLabel: TLabel
          Left = 384
          Top = 328
          Width = 68
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Nominal Type'
        end
        object cxButton1: TcxButton
          Left = 384
          Top = 389
          Width = 75
          Height = 25
          Action = actEntAccountHelp
          TabOrder = 0
          LookAndFeel.Kind = lfOffice11
        end
        object cxButton2: TcxButton
          Left = 463
          Top = 389
          Width = 75
          Height = 25
          Action = actEntAccountSave
          TabOrder = 1
          LookAndFeel.Kind = lfOffice11
        end
        object cxButton3: TcxButton
          Left = 542
          Top = 389
          Width = 75
          Height = 25
          Action = actEntAccountDelete
          TabOrder = 2
          LookAndFeel.Kind = lfOffice11
        end
        object cxButton4: TcxButton
          Left = 621
          Top = 389
          Width = 75
          Height = 25
          Action = actEntAccountAdd
          TabOrder = 3
          LookAndFeel.Kind = lfOffice11
        end
        object btnEntAccountCancel: TcxButton
          Left = 700
          Top = 389
          Width = 75
          Height = 25
          Action = actEntAccountCancel
          TabOrder = 4
          LookAndFeel.Kind = lfOffice11
        end
        object Panel1: TPanel
          Left = 6
          Top = 18
          Width = 368
          Height = 401
          BevelOuter = bvNone
          Constraints.MaxWidth = 368
          TabOrder = 5
          object EntGrid: TcxGrid
            Left = 0
            Top = 0
            Width = 368
            Height = 163
            Align = alTop
            Constraints.MinHeight = 100
            TabOrder = 0
            LookAndFeel.Kind = lfFlat
            LookAndFeel.NativeStyle = False
            object EntGridTableView: TcxGridTableView
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
              FilterBox.Visible = fvNever
              OnFocusedRecordChanged = EntGridTableViewFocusedRecordChanged
              DataController.Filter.Options = [fcoCaseInsensitive]
              DataController.Options = [dcoAnsiSort, dcoCaseInsensitive, dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoFocusTopRowAfterSorting]
              DataController.Summary.DefaultGroupSummaryItems = <>
              DataController.Summary.FooterSummaryItems = <>
              DataController.Summary.SummaryGroups = <>
              OptionsCustomize.ColumnFiltering = False
              OptionsCustomize.ColumnGrouping = False
              OptionsData.CancelOnExit = False
              OptionsData.Deleting = False
              OptionsData.DeletingConfirmation = False
              OptionsData.Editing = False
              OptionsData.Inserting = False
              OptionsSelection.CellSelect = False
              OptionsSelection.UnselectFocusedRecordOnExit = False
              OptionsView.DataRowHeight = 26
              OptionsView.GridLines = glHorizontal
              OptionsView.GroupByBox = False
              OptionsView.HeaderHeight = 26
              OptionsView.Indicator = True
              OptionsView.IndicatorWidth = 15
              object EntGridTableViewNo: TcxGridColumn
                Caption = 'No'
                PropertiesClassName = 'TcxTextEditProperties'
                Properties.Alignment.Vert = taVCenter
                Visible = False
                OnGetDisplayText = NomAccsGridTableViewNoGetDisplayText
                HeaderAlignmentVert = vaCenter
                Hidden = True
                Options.SortByDisplayText = isbtOff
                Width = 45
              end
              object EntGridTableViewEnt: TcxGridColumn
                Caption = 'Ent'
                PropertiesClassName = 'TcxTextEditProperties'
                Properties.Alignment.Vert = taVCenter
                HeaderAlignmentVert = vaCenter
                Width = 35
              end
              object EntGridTableViewName: TcxGridColumn
                Caption = 'Name'
                PropertiesClassName = 'TcxTextEditProperties'
                Properties.Alignment.Vert = taVCenter
                HeaderAlignmentVert = vaCenter
                Width = 295
              end
            end
            object EntGridLevel: TcxGridLevel
              GridView = EntGridTableView
            end
          end
          object cxSplitter1: TcxSplitter
            Left = 0
            Top = 163
            Width = 368
            Height = 8
            HotZoneClassName = 'TcxXPTaskBarStyle'
            AlignSplitter = salTop
            MinSize = 100
            Control = EntGrid
            Visible = False
          end
          object Panel2: TPanel
            Left = 0
            Top = 171
            Width = 368
            Height = 230
            Align = alClient
            BevelOuter = bvNone
            Constraints.MinHeight = 115
            TabOrder = 2
            object EntIncomeGrid: TcxGrid
              Left = 0
              Top = 17
              Width = 180
              Height = 213
              Align = alLeft
              Constraints.MinHeight = 115
              Constraints.MinWidth = 120
              TabOrder = 0
              OnEnter = EntIncomeGridEnter
              LookAndFeel.Kind = lfFlat
              LookAndFeel.NativeStyle = False
              object EntIncomeGridTableView: TcxGridTableView
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
                FilterBox.Visible = fvNever
                OnFocusedRecordChanged = EntIncomeGridTableViewFocusedRecordChanged
                DataController.Filter.Options = [fcoCaseInsensitive]
                DataController.Options = [dcoAnsiSort, dcoCaseInsensitive, dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoFocusTopRowAfterSorting]
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                OptionsCustomize.ColumnFiltering = False
                OptionsCustomize.ColumnGrouping = False
                OptionsData.CancelOnExit = False
                OptionsData.Deleting = False
                OptionsData.DeletingConfirmation = False
                OptionsData.Editing = False
                OptionsData.Inserting = False
                OptionsSelection.CellSelect = False
                OptionsSelection.HideSelection = True
                OptionsSelection.InvertSelect = False
                OptionsSelection.UnselectFocusedRecordOnExit = False
                OptionsView.DataRowHeight = 26
                OptionsView.GridLines = glHorizontal
                OptionsView.GroupByBox = False
                OptionsView.HeaderHeight = 26
                OptionsView.IndicatorWidth = 15
                object EntIncomeGridTableViewNo: TcxGridColumn
                  Caption = 'No'
                  PropertiesClassName = 'TcxTextEditProperties'
                  Properties.Alignment.Vert = taVCenter
                  OnGetDisplayText = NomAccsGridTableViewNoGetDisplayText
                  HeaderAlignmentVert = vaCenter
                  Options.SortByDisplayText = isbtOff
                  Width = 28
                end
                object EntIncomeGridTableViewName: TcxGridColumn
                  Caption = 'Ent'
                  PropertiesClassName = 'TcxTextEditProperties'
                  Properties.Alignment.Vert = taVCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 240
                end
              end
              object EntIncomeGridLevel: TcxGridLevel
                GridView = EntIncomeGridTableView
              end
            end
            object cxSplitter2: TcxSplitter
              Left = 180
              Top = 17
              Width = 8
              Height = 213
              HotZoneClassName = 'TcxXPTaskBarStyle'
              MinSize = 120
              Control = EntIncomeGrid
              Visible = False
            end
            object EntExpendGrid: TcxGrid
              Left = 188
              Top = 17
              Width = 180
              Height = 213
              Align = alClient
              Constraints.MinHeight = 115
              Constraints.MinWidth = 120
              TabOrder = 2
              OnEnter = EntExpendGridEnter
              LookAndFeel.Kind = lfFlat
              LookAndFeel.NativeStyle = False
              object EntExpendGridTableView: TcxGridTableView
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
                FilterBox.Visible = fvNever
                OnFocusedRecordChanged = EntExpendGridTableViewFocusedRecordChanged
                DataController.Filter.Options = [fcoCaseInsensitive]
                DataController.Options = [dcoAnsiSort, dcoCaseInsensitive, dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoFocusTopRowAfterSorting]
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                OptionsCustomize.ColumnFiltering = False
                OptionsCustomize.ColumnGrouping = False
                OptionsData.CancelOnExit = False
                OptionsData.Deleting = False
                OptionsData.DeletingConfirmation = False
                OptionsData.Editing = False
                OptionsData.Inserting = False
                OptionsSelection.CellSelect = False
                OptionsSelection.HideSelection = True
                OptionsSelection.InvertSelect = False
                OptionsSelection.UnselectFocusedRecordOnExit = False
                OptionsView.DataRowHeight = 26
                OptionsView.GridLines = glHorizontal
                OptionsView.GroupByBox = False
                OptionsView.HeaderHeight = 26
                OptionsView.IndicatorWidth = 15
                object EntExpendGridTableViewNo: TcxGridColumn
                  Caption = 'No'
                  PropertiesClassName = 'TcxTextEditProperties'
                  Properties.Alignment.Vert = taVCenter
                  OnGetDisplayText = NomAccsGridTableViewNoGetDisplayText
                  HeaderAlignmentVert = vaCenter
                  Options.SortByDisplayText = isbtOff
                  Width = 28
                end
                object EntExpendGridTableViewName: TcxGridColumn
                  Caption = 'Ent'
                  PropertiesClassName = 'TcxTextEditProperties'
                  Properties.Alignment.Vert = taVCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 240
                end
              end
              object EntExpendGridLevel: TcxGridLevel
                GridView = EntExpendGridTableView
              end
            end
            object Panel3: TPanel
              Left = 0
              Top = 0
              Width = 368
              Height = 17
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 3
              object cxLabel5: TcxLabel
                Left = 0
                Top = 0
                Caption = 'Income Accounts'
              end
              object cxLabel6: TcxLabel
                Left = 188
                Top = 0
                Caption = 'Expenditure  Accounts'
              end
            end
          end
        end
        object cxLabel7: TcxLabel
          Left = 382
          Top = 16
          Caption = 'Add/Edit Enterprise '
          Style.TextStyle = [fsBold]
          Style.TransparentBorder = False
        end
        object EntCode: TcxTextEdit
          Left = 460
          Top = 40
          HelpContext = 7
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 7
          OnEnter = EntCodeEnter
          OnExit = EntCodeExit
          Width = 65
        end
        object EntName: TcxTextEdit
          Left = 611
          Top = 40
          HelpContext = 121
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 8
          Width = 170
        end
        object EntUnitDiv: TcxTextEdit
          Left = 460
          Top = 64
          HelpContext = 124
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 9
          OnExit = EntUnitDivExit
          Width = 83
        end
        object EntUnitName: TcxTextEdit
          Left = 611
          Top = 64
          HelpContext = 122
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 10
          Width = 114
        end
        object EntIncomeFrom: TcxTextEdit
          Left = 452
          Top = 130
          HelpContext = 125
          TabStop = False
          Enabled = False
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 11
          Text = '0'
          OnDblClick = EntIncomeFromDblClick
          Width = 57
        end
        object EntIncomeTo: TcxTextEdit
          Left = 516
          Top = 130
          HelpContext = 125
          TabStop = False
          Enabled = False
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 12
          Text = '0'
          OnDblClick = EntIncomeToDblClick
          Width = 57
        end
        object EntExpendFrom: TcxTextEdit
          Left = 652
          Top = 130
          HelpContext = 125
          TabStop = False
          Enabled = False
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 13
          Text = '0'
          OnDblClick = EntExpendFromDblClick
          Width = 57
        end
        object EntExpendTo: TcxTextEdit
          Left = 716
          Top = 130
          HelpContext = 125
          TabStop = False
          Enabled = False
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 14
          Text = '0'
          OnDblClick = EntExpendToDblClick
          Width = 57
        end
        object EntPercOverheads: TcxTextEdit
          Left = 611
          Top = 88
          HelpContext = 123
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 15
          Width = 33
        end
        object NoOfIncomeAccounts: TcxTextEdit
          Left = 404
          Top = 130
          HelpContext = 125
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 16
          Text = '0'
          OnDblClick = NoOfIncomeAccountsDblClick
          OnExit = NoOfIncomeAccountsExit
          Width = 41
        end
        object NoOfExpendAccounts: TcxTextEdit
          Left = 604
          Top = 130
          HelpContext = 125
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 17
          Text = '0'
          OnDblClick = NoOfExpendAccountsDblClick
          OnExit = NoOfExpendAccountsExit
          Width = 41
        end
        object cxLabel8: TcxLabel
          Left = 384
          Top = 194
          Caption = 'Add/Edit Enterprise '
          Style.TextStyle = [fsBold]
          Style.TransparentBorder = False
        end
        object rgEnterpriseType: TcxRadioGroup
          Left = 384
          Top = 211
          Alignment = alLeftCenter
          Properties.Columns = 2
          Properties.Items = <
            item
              Caption = 'Income'
              Value = False
            end
            item
              Caption = 'Expenditure'
              Value = False
            end>
          Properties.OnChange = rgCustomerSupplierPropertiesChange
          ItemIndex = 0
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 19
          Height = 30
          Width = 401
        end
        object EntAccountGroupNo: TcxButtonEdit
          Left = 460
          Top = 278
          HelpContext = 142
          Properties.Buttons = <
            item
              Kind = bkGlyph
            end>
          Properties.OnButtonClick = EntAccountGroupNoPropertiesButtonClick
          Properties.OnChange = EntAccountGroupNoPropertiesChange
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 20
          OnDblClick = EntAccountGroupNoDblClick
          OnExit = NomRepGroupExit
          OnKeyDown = NomRepGroupKeyDown
          Width = 50
        end
        object EntAccountName: TcxTextEdit
          Left = 560
          Top = 254
          HelpContext = 140
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 21
          OnExit = EntAccountNameExit
          Width = 217
        end
        object EntAccountVatNo: TcxButtonEdit
          Left = 460
          Top = 302
          HelpContext = 12
          Properties.Buttons = <
            item
              Kind = bkGlyph
            end>
          Properties.OnButtonClick = EntAccountVatNoPropertiesButtonClick
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 22
          OnDblClick = EntAccountVatNoDblClick
          OnExit = EntAccountVatNoExit
          OnKeyDown = NomVatCodeKeyDown
          Width = 50
        end
        object EntAccount: TcxTextEdit
          Left = 460
          Top = 254
          HelpContext = 36
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 23
          Width = 50
        end
        object EntAccountGroupDesc: TcxTextEdit
          Left = 560
          Top = 278
          HelpContext = 9
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 24
          Width = 217
        end
        object EntNominalTypeDropdown: TcxComboBox
          Left = 460
          Top = 326
          RepositoryItem = AccsDataModule.erNominalTypeLookup
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 25
          Width = 201
        end
        object cbProductsEnts: TcxDBLookupComboBox
          Left = 460
          Top = 350
          RepositoryItem = AccsDataModule.erNominalLookup
          DataBinding.DataField = 'Product'
          DataBinding.DataSource = AccsDataModule.dsNominalList
          Properties.ListColumns = <>
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 26
          Width = 201
        end
        object btnEntHelp: TcxButton
          Left = 384
          Top = 163
          Width = 75
          Height = 25
          Action = actEntHelp
          TabOrder = 27
          LookAndFeel.Kind = lfOffice11
        end
        object btnEntSave: TcxButton
          Left = 463
          Top = 163
          Width = 75
          Height = 25
          Action = actEntSave
          TabOrder = 28
          LookAndFeel.Kind = lfOffice11
        end
        object btnEntDelete: TcxButton
          Left = 542
          Top = 163
          Width = 75
          Height = 25
          Action = actEntDelete
          TabOrder = 29
          LookAndFeel.Kind = lfOffice11
        end
        object btnEntAdd: TcxButton
          Left = 621
          Top = 163
          Width = 75
          Height = 25
          Action = actEntAdd
          TabOrder = 30
          LookAndFeel.Kind = lfOffice11
        end
        object btnEntCancel: TcxButton
          Left = 700
          Top = 163
          Width = 75
          Height = 25
          Action = actEntCancel
          TabOrder = 31
          LookAndFeel.Kind = lfOffice11
        end
      end
    end
    object tsCustomerSupplier: TcxTabSheet
      Caption = 'Customer/Supplier'
      ImageIndex = 2
      object gbCustomersSuppliers: TcxGroupBox
        Left = 10
        Top = 9
        Caption = 'Customers/Suppliers'
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
        OnEnter = gbCustomersSuppliersEnter
        Height = 426
        Width = 795
        object Bevel3: TBevel
          Left = 490
          Top = 19
          Width = 297
          Height = 7
          Shape = bsBottomLine
        end
        object LabelCustSuppNo: TLabel
          Left = 370
          Top = 77
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'No'
        end
        object LabelCustSuppName: TLabel
          Left = 370
          Top = 100
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Name'
        end
        object LabelCustSuppAddress: TLabel
          Left = 370
          Top = 123
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Address'
        end
        object LabelCustSuppPostCode: TLabel
          Left = 594
          Top = 100
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Post Code'
        end
        object LabelCustSuppComment: TLabel
          Left = 370
          Top = 238
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Comment'
        end
        object LabelCustSuppRefCode: TLabel
          Left = 370
          Top = 215
          Width = 45
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Ref'
        end
        object LabelcustSuppFax: TLabel
          Left = 594
          Top = 123
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Fax'
        end
        object LabelCustSuppContact1: TLabel
          Left = 594
          Top = 146
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Contact'
        end
        object LabelcustSuppContact2: TLabel
          Left = 594
          Top = 169
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Contact'
        end
        object LabelCustSuppPhone1: TLabel
          Left = 594
          Top = 192
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Phone (1)'
        end
        object LabelCustSuppPhone2: TLabel
          Left = 594
          Top = 215
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Phone (2)'
        end
        object LabelCustSuppVATNo: TLabel
          Left = 594
          Top = 238
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'VAT Number'
        end
        object LabelCustSuppAreaCode: TLabel
          Left = 594
          Top = 77
          Width = 60
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Area Code'
        end
        object cxLabel3: TcxLabel
          Left = 382
          Top = 15
          Caption = 'Select Setup Type'
          Style.TextStyle = [fsBold]
        end
        object btnCustSuppHelp: TcxButton
          Left = 382
          Top = 392
          Width = 75
          Height = 25
          Action = actCustSuppHelp
          TabOrder = 1
          LookAndFeel.Kind = lfOffice11
        end
        object btnCustSuppSave: TcxButton
          Left = 461
          Top = 392
          Width = 75
          Height = 25
          Action = actCustSuppSave
          TabOrder = 2
          LookAndFeel.Kind = lfOffice11
        end
        object btnCustSuppDelete: TcxButton
          Left = 540
          Top = 392
          Width = 75
          Height = 25
          Action = actCustSuppDelete
          TabOrder = 3
          LookAndFeel.Kind = lfOffice11
        end
        object btnCustSuppAdd: TcxButton
          Left = 619
          Top = 392
          Width = 75
          Height = 25
          Action = actCustSuppAdd
          TabOrder = 4
          LookAndFeel.Kind = lfOffice11
        end
        object btnCustSuppCancel: TcxButton
          Left = 698
          Top = 392
          Width = 75
          Height = 25
          Action = actCustSuppCancel
          TabOrder = 5
          LookAndFeel.Kind = lfOffice11
        end
        object CustomerSupplierGrid: TcxGrid
          Left = 7
          Top = 20
          Width = 356
          Height = 371
          TabOrder = 6
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = False
          object CustomerSupplierGridTableView: TcxGridTableView
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
            FilterBox.Visible = fvNever
            OnFocusedRecordChanged = CustomerSupplierGridTableViewFocusedRecordChanged
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Options = [dcoAnsiSort, dcoCaseInsensitive, dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoFocusTopRowAfterSorting]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnFiltering = False
            OptionsCustomize.ColumnGrouping = False
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsSelection.CellSelect = False
            OptionsView.DataRowHeight = 26
            OptionsView.GridLines = glHorizontal
            OptionsView.GroupByBox = False
            OptionsView.HeaderHeight = 26
            OptionsView.Indicator = True
            OptionsView.IndicatorWidth = 15
            object CustomerSupplierGridTableViewNo: TcxGridColumn
              Caption = 'No'
              PropertiesClassName = 'TcxTextEditProperties'
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentVert = vaCenter
              Width = 45
            end
            object CustomerSupplierGridTableViewName: TcxGridColumn
              Caption = 'Name'
              PropertiesClassName = 'TcxTextEditProperties'
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentVert = vaCenter
              Width = 205
            end
            object CustomerSupplierGridTableViewBalance: TcxGridColumn
              Caption = 'Balance'
              PropertiesClassName = 'TcxTextEditProperties'
              Properties.Alignment.Vert = taVCenter
              HeaderAlignmentVert = vaCenter
              Width = 74
            end
          end
          object CustomerSupplierGridLevel: TcxGridLevel
            GridView = CustomerSupplierGridTableView
          end
        end
        object rgCustomerSupplier: TcxRadioGroup
          Left = 384
          Top = 37
          Alignment = alLeftCenter
          Properties.Columns = 2
          Properties.Items = <
            item
              Caption = 'Customers'
              Value = False
            end
            item
              Caption = 'Suppliers'
              Value = False
            end>
          Properties.OnChange = rgCustomerSupplierPropertiesChange
          ItemIndex = 0
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 7
          Height = 30
          Width = 401
        end
        object CustSuppNo: TcxTextEdit
          Left = 420
          Top = 75
          HelpContext = 59
          TabStop = False
          Enabled = False
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 8
          Width = 49
        end
        object CustSuppName: TcxTextEdit
          Left = 420
          Top = 98
          HelpContext = 60
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 9
          Width = 170
        end
        object CustSuppAdd2: TcxTextEdit
          Left = 420
          Top = 144
          HelpContext = 61
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 10
          Width = 170
        end
        object CustSuppAdd3: TcxTextEdit
          Left = 420
          Top = 167
          HelpContext = 61
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 11
          Width = 170
        end
        object CustSuppPostCode: TcxTextEdit
          Left = 658
          Top = 98
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 12
          Width = 93
        end
        object CustSuppFaxNo: TcxTextEdit
          Left = 658
          Top = 121
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 13
          Width = 128
        end
        object CustSuppAdd1: TcxTextEdit
          Left = 420
          Top = 121
          HelpContext = 61
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 14
          Width = 170
        end
        object CustSuppAdd4: TcxTextEdit
          Left = 420
          Top = 190
          HelpContext = 61
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 15
          Width = 170
        end
        object CustSuppVATNo: TcxTextEdit
          Left = 658
          Top = 236
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 16
          Width = 96
        end
        object CustSuppPhone2: TcxTextEdit
          Left = 658
          Top = 213
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 17
          Width = 128
        end
        object CustSuppPhone1: TcxTextEdit
          Left = 658
          Top = 190
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 18
          Width = 128
        end
        object CustSuppContact1: TcxTextEdit
          Left = 658
          Top = 144
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 19
          Width = 128
        end
        object CustSuppContact2: TcxTextEdit
          Left = 658
          Top = 167
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 20
          Width = 128
        end
        object CustSuppRefCode: TcxTextEdit
          Left = 420
          Top = 213
          HelpContext = 5
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 21
          Width = 121
        end
        object CustSuppComment: TcxTextEdit
          Left = 420
          Top = 236
          HelpContext = 6
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 22
          Width = 121
        end
        object CustSuppAreaCode: TcxTextEdit
          Left = 658
          Top = 75
          HelpContext = 172
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 23
          OnExit = CustSuppAreaCodeExit
          Width = 57
        end
        object pCustSuppCashbook: TPanel
          Left = 368
          Top = 278
          Width = 405
          Height = 93
          BevelOuter = bvNone
          TabOrder = 24
          object LabelcustSuppTurnover: TLabel
            Left = 1
            Top = 2
            Width = 44
            Height = 13
            Alignment = taRightJustify
            Caption = 'Turnover'
          end
          object LabelCustSuppBalance: TLabel
            Left = 8
            Top = 25
            Width = 37
            Height = 13
            Alignment = taRightJustify
            Caption = 'Balance'
          end
          object LabelCustSuppAgeCurr: TLabel
            Left = 218
            Top = 2
            Width = 65
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Aged Current'
          end
          object LabelCustSuppAged1: TLabel
            Left = 218
            Top = 25
            Width = 65
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Aged (1)'
          end
          object LabelCustSuppAged2: TLabel
            Left = 218
            Top = 48
            Width = 65
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Aged (2)'
          end
          object LabelCustSuppAged3: TLabel
            Left = 218
            Top = 69
            Width = 65
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Aged (3)'
          end
          object CustSuppTurnover: TcxTextEdit
            Left = 52
            Top = 0
            HelpContext = 228
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 0
            OnExit = CustSuppTurnoverExit
            Width = 96
          end
          object CustSuppOpenBalance: TcxTextEdit
            Left = 52
            Top = 23
            HelpContext = 141
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 1
            OnExit = CustSuppOpenBalanceExit
            Width = 96
          end
          object CustSuppAged1: TcxTextEdit
            Left = 290
            Top = 23
            HelpContext = 64
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 2
            OnExit = CustSuppAged1Exit
            Width = 96
          end
          object CustSuppAged2: TcxTextEdit
            Left = 290
            Top = 46
            HelpContext = 64
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 3
            OnExit = CustSuppAged2Exit
            Width = 96
          end
          object CustSuppAged3: TcxTextEdit
            Left = 290
            Top = 69
            HelpContext = 64
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 4
            OnExit = CustSuppAged3Exit
            Width = 96
          end
          object CustSuppAgeCurr: TcxTextEdit
            Left = 290
            Top = 0
            HelpContext = 64
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 5
            OnExit = CustSuppAgeCurrExit
            Width = 96
          end
        end
        object SearchBox: TcxTextEdit
          Left = 80
          Top = 397
          Properties.OnChange = SearchBoxPropertiesChange
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 25
          Width = 283
        end
        object cxLabel4: TcxLabel
          Left = 8
          Top = 399
          Caption = 'Search Name'
        end
      end
    end
  end
  inherited BarManager: TdxBarManager
    Bars = <
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        Caption = 'Main'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsTop
        FloatLeft = 301
        FloatTop = 201
        FloatClientWidth = 0
        FloatClientHeight = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        IsMainMenu = True
        ItemLinks = <>
        MultiLine = True
        Name = 'Main'
        OneOnRow = True
        Row = 0
        UseOwnFont = True
        UseRestSpace = True
        Visible = False
        WholeRow = True
        BackgroundBitmap.Data = {00000000}
      end
      item
        AllowClose = False
        AllowCustomizing = False
        AllowQuickCustomizing = False
        AllowReset = False
        Caption = 'TopToolbar'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsTop
        FloatLeft = 301
        FloatTop = 201
        FloatClientWidth = 0
        FloatClientHeight = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemLinks = <
          item
            Item = blbExit
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbBudgets
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            Item = blbReports
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = blbHelp
            UserGlyph.Data = {00000000}
            Visible = True
          end>
        Name = 'TopToolbar'
        OneOnRow = True
        Row = 0
        UseOwnFont = True
        UseRestSpace = True
        Visible = True
        WholeRow = True
        BackgroundBitmap.Data = {00000000}
      end>
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    Left = 428
    Top = 10
    DockControlHeights = (
      0
      0
      48
      0)
    inherited blbView: TdxBarLargeButton
      ImageIndex = 8
    end
    inherited blbPrint: TdxBarLargeButton
      ImageIndex = 17
    end
    inherited blbHelp: TdxBarLargeButton
      Action = actHelp
      ImageIndex = 33
    end
    inherited blbFirst: TdxBarLargeButton
      ImageIndex = 23
    end
    inherited blbNext: TdxBarLargeButton
      ImageIndex = 24
    end
    inherited blbLast: TdxBarLargeButton
      ImageIndex = 26
    end
    inherited blbPrior: TdxBarLargeButton
      ImageIndex = 24
    end
    inherited blbSave2: TdxBarLargeButton
      ImageIndex = 9
    end
    inherited blbCancel2: TdxBarLargeButton
      ImageIndex = 10
    end
    object blbBudgets: TdxBarLargeButton
      Action = actBudgets
      Category = 0
      Height = 44
      HotImageIndex = 39
      Width = 65
    end
    object blbReports: TdxBarLargeButton
      Caption = 'Reports'
      Category = 0
      Visible = ivAlways
      ButtonStyle = bsDropDown
      DropDownMenu = bpmReports
      OnClick = blbReportsClick
      Height = 44
      HotImageIndex = 7
      LargeImageIndex = 7
      Width = 65
    end
    object dxBarButton1: TdxBarButton
      Action = actRptNominalAccounts
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actRptEnterprises
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actRptCustomerListing
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actRptSupplierListing
      Category = 0
    end
  end
  inherited ActionList: TActionList
    Left = 462
    Top = 12
    inherited actHelp: TAction
      OnExecute = actHelpExecute
    end
    object actBudgets: TAction
      Caption = 'Budgets'
      ImageIndex = 39
      OnExecute = actBudgetsExecute
    end
    object actReports: TAction
      Caption = 'Reports'
      ImageIndex = 7
    end
    object actVATCodeSelect: TAction
      ImageIndex = 1
      OnExecute = actVATCodeSelectExecute
    end
    object actReportGroupSelect: TAction
      ImageIndex = 1
      OnExecute = actReportGroupSelectExecute
    end
    object actClearProduct: TAction
      Caption = 'Clear'
      OnExecute = actClearProductExecute
    end
    object actNomAccHelp: TAction
      Caption = 'Help'
      OnExecute = actNomAccHelpExecute
    end
    object actNomAccSave: TAction
      Caption = 'Save'
      OnExecute = actNomAccSaveExecute
    end
    object actNomAccAdd: TAction
      Caption = 'Add'
      OnExecute = actNomAccAddExecute
    end
    object actNomAccDelete: TAction
      Caption = 'Delete'
      OnExecute = actNomAccDeleteExecute
    end
    object actNomAccCancel: TAction
      Caption = 'Cancel'
      OnExecute = actNomAccCancelExecute
    end
    object actCustSuppHelp: TAction
      Caption = 'Help'
      OnExecute = actCustSuppHelpExecute
    end
    object actCustSuppSave: TAction
      Caption = 'Save'
      OnExecute = actCustSuppSaveExecute
    end
    object actCustSuppDelete: TAction
      Caption = 'Delete'
      OnExecute = actCustSuppDeleteExecute
    end
    object actCustSuppAdd: TAction
      Caption = 'Add'
      OnExecute = actCustSuppAddExecute
    end
    object actCustSuppCancel: TAction
      Caption = 'Cancel'
      OnExecute = actCustSuppCancelExecute
    end
    object actRptNominalAccounts: TAction
      Caption = 'Nominal Accounts'
      OnExecute = actRptNominalAccountsExecute
    end
    object actRptEnterprises: TAction
      Caption = 'Enterprises'
      OnExecute = actRptEnterprisesExecute
    end
    object actRptCustomerListing: TAction
      Caption = 'Customer Listing'
      OnExecute = actRptCustomerListingExecute
    end
    object actRptSupplierListing: TAction
      Caption = 'Supplier Listing'
      OnExecute = actRptSupplierListingExecute
    end
    object actEntHelp: TAction
      Caption = 'Help'
      OnExecute = actEntHelpExecute
    end
    object actEntSave: TAction
      Caption = 'Save'
      OnExecute = actEntSaveExecute
    end
    object actEntDelete: TAction
      Caption = 'Delete'
      OnExecute = actEntDeleteExecute
    end
    object actEntAdd: TAction
      Caption = 'Add'
      OnExecute = actEntAddExecute
    end
    object actEntCancel: TAction
      Caption = 'Cancel'
      OnExecute = actEntCancelExecute
    end
    object actEntAccountHelp: TAction
      Caption = 'Help'
      OnExecute = actEntAccountHelpExecute
    end
    object actEntAccountSave: TAction
      Caption = 'Save'
      OnExecute = actEntAccountSaveExecute
    end
    object actEntAccountDelete: TAction
      Caption = 'Delete'
      OnExecute = actEntAccountDeleteExecute
    end
    object actEntAccountAdd: TAction
      Caption = 'Add'
      OnExecute = actEntAccountAddExecute
    end
    object actEntAccountCancel: TAction
      Caption = 'Cancel'
      OnExecute = actEntAccountCancelExecute
    end
    object actCurrentOpeningBalance: TAction
      OnExecute = actCurrentOpeningBalanceExecute
    end
  end
  object bpmReports: TdxBarPopupMenu
    BarManager = BarManager
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ItemLinks = <
      item
        Item = dxBarButton1
        Visible = True
      end
      item
        Item = dxBarButton4
        Visible = True
      end
      item
        Item = dxBarButton3
        Visible = True
      end
      item
        Item = dxBarButton2
        Visible = True
      end>
    UseOwnFont = True
    Left = 496
    Top = 14
  end
end
