inherited fmSysMain: TfmSysMain
  Left = 499
  Top = 217
  Width = 712
  Height = 496
  Caption = 'System Settings'
  OldCreateOrder = True
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TdxStatusBar
    Top = 445
    Width = 704
  end
  object PageControl: TcxPageControl [1]
    Left = 0
    Top = 48
    Width = 704
    Height = 397
    ActivePage = tsOwnerInformation
    Align = alClient
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    Style = 9
    TabHeight = 32
    TabOrder = 5
    TabWidth = 140
    ClientRectBottom = 397
    ClientRectRight = 704
    ClientRectTop = 33
    object tsPreferences: TcxTabSheet
      Caption = 'Preferences'
      ImageIndex = 0
      object cxGroupBox1: TcxGroupBox
        Left = 12
        Top = 14
        Caption = 'Kingswood Accounts Program Preferences '
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 0
        Height = 330
        Width = 673
        object vgPreferences: TcxVerticalGrid
          Left = 2
          Top = 16
          Width = 669
          Height = 312
          Align = alClient
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = False
          OptionsView.ShowEditButtons = ecsbAlways
          OptionsView.GridLineColor = clActiveBorder
          OptionsView.RowHeaderWidth = 320
          OptionsView.RowHeight = 28
          OptionsView.GridLines = vglHorizontal
          OptionsView.ValueWidth = 40
          OptionsView.ValueMinWidth = 30
          OptionsBehavior.BandSizing = False
          OptionsBehavior.HeaderSizing = False
          TabOrder = 0
          OnEditValueChanged = vgPreferencesEditValueChanged
          object vgcrTransactionInput: TcxCategoryRow
            Height = 18
            Options.ShowExpandButton = False
            Options.TabStop = False
            Properties.Caption = 'Transaction Input'
            Properties.HeaderAlignmentVert = vaCenter
            Styles.Header = cxStyleCategory
            object vgerUseSimpleLayout: TcxEditorRow
              Expanded = False
              Properties.Caption = 'Use Simple Layout'
              Properties.HeaderAlignmentVert = vaCenter
              Properties.EditPropertiesClassName = 'TcxCheckBoxProperties'
              Properties.EditProperties.AllowGrayed = True
              Properties.EditProperties.DisplayGrayed = 'False'
              Properties.EditProperties.ImmediatePost = True
              Properties.EditProperties.NullStyle = nssUnchecked
              Properties.EditProperties.ValueGrayed = 'False'
              Properties.RepositoryItem = AccsDataModule.erCheckBox
              Properties.DataBinding.ValueType = 'Boolean'
              Properties.Value = True
              object vgerPreferencesHideOptionalColumns: TcxEditorRow
                Options.ShowExpandButton = False
                Properties.Caption = 'Hide All Optional Columns'
                Properties.HeaderAlignmentVert = vaCenter
                Properties.RepositoryItem = AccsDataModule.erCheckBox
                Properties.DataBinding.ValueType = 'Boolean'
                Properties.Value = False
                Styles.Header = cxStyle1
                object vgerPreferencesStubNoColumn: TcxEditorRow
                  Properties.Caption = 'Stub No.'
                  Properties.HeaderAlignmentVert = vaCenter
                  Properties.RepositoryItem = AccsDataModule.erCheckBox
                  Properties.DataBinding.ValueType = 'Boolean'
                  Properties.Value = False
                end
                object vgerPreferencesCustomerColumn: TcxEditorRow
                  Properties.Caption = 'Customer'
                  Properties.HeaderAlignmentVert = vaCenter
                  Properties.RepositoryItem = AccsDataModule.erCheckBox
                  Properties.DataBinding.ValueType = 'Boolean'
                  Properties.Value = False
                end
                object vgerPreferencesSupplierColumn: TcxEditorRow
                  Properties.Caption = 'Supplier'
                  Properties.HeaderAlignmentVert = vaCenter
                  Properties.RepositoryItem = AccsDataModule.erCheckBox
                  Properties.DataBinding.ValueType = 'Boolean'
                  Properties.Value = False
                end
                object vgerPreferencesQuantity: TcxEditorRow
                  Properties.Caption = 'Quantity'
                  Properties.HeaderAlignmentVert = vaCenter
                  Properties.RepositoryItem = AccsDataModule.erCheckBox
                  Properties.DataBinding.ValueType = 'Boolean'
                  Properties.Value = False
                end
                object vgerPreferencesComment: TcxEditorRow
                  Properties.Caption = 'Comment'
                  Properties.HeaderAlignmentVert = vaCenter
                  Properties.RepositoryItem = AccsDataModule.erCheckBox
                  Properties.DataBinding.ValueType = 'Boolean'
                  Properties.Value = False
                end
                object vgerPreferencesAnalysisCodeColumn: TcxEditorRow
                  Properties.Caption = 'Analysis Code'
                  Properties.HeaderAlignmentVert = vaCenter
                  Properties.RepositoryItem = AccsDataModule.erCheckBox
                  Properties.DataBinding.ValueType = 'Boolean'
                  Properties.Value = False
                end
              end
            end
          end
          object vgcrDataImport: TcxCategoryRow
            Height = 18
            Options.ShowExpandButton = False
            Options.TabStop = False
            Properties.Caption = 'Data Import'
            Properties.HeaderAlignmentVert = vaCenter
            Styles.Header = cxStyleCategory
            object vgerUseCoOpImport: TcxEditorRow
              Properties.Caption = 'Use CoOp Import'
              Properties.HeaderAlignmentVert = vaCenter
              Properties.EditPropertiesClassName = 'TcxCheckBoxProperties'
              Properties.RepositoryItem = AccsDataModule.erCheckBox
              Properties.DataBinding.ValueType = 'Boolean'
              Properties.Value = False
            end
          end
          object vgcrMiscellaneous: TcxCategoryRow
            Height = 18
            Options.ShowExpandButton = False
            Options.TabStop = False
            Properties.Caption = 'Other'
            Properties.HeaderAlignmentVert = vaCenter
            Styles.Header = cxStyleCategory
            object vgPreferencesUseSalePurchInvGrids: TcxEditorRow
              Properties.Caption = 'Use Sale and Purchase Invoice Grids'
              Properties.HeaderAlignmentVert = vaCenter
              Properties.EditPropertiesClassName = 'TcxCheckBoxProperties'
              Properties.RepositoryItem = AccsDataModule.erCheckBox
              Properties.DataBinding.ValueType = 'Boolean'
              Properties.Value = False
            end
            object vgPreferencesAllowFreeTextForNominalDescription: TcxEditorRow
              Properties.Caption = 'Allow Overwrite of Nominal Description'
              Properties.HeaderAlignmentVert = vaCenter
              Properties.Hint = 
                'This option, if ticked on, gives the user the oppurtunity to ent' +
                'er a Comment '#13#10'which over-writes the Nominal Description. This i' +
                's particularly useful in the '#13#10'Nominal Ledger Audit Trail Report' +
                '.'#13#10#13#10'The option will also apply to comments/details coming in fr' +
                'om the BankLink '#13#10'and Co-Op Link files.'
              Properties.EditPropertiesClassName = 'TcxCheckBoxProperties'
              Properties.RepositoryItem = AccsDataModule.erCheckBox
              Properties.DataBinding.ValueType = 'Boolean'
              Properties.Value = False
            end
            object vgerUseLastDescriptionAsComment: TcxEditorRow
              Properties.Caption = 'Use Last Nominal Description as Invoice Comment'
              Properties.HeaderAlignmentVert = vaCenter
              Properties.EditPropertiesClassName = 'TcxCheckBoxProperties'
              Properties.RepositoryItem = AccsDataModule.erCheckBox
              Properties.DataBinding.ValueType = 'Boolean'
              Properties.Value = False
            end
            object vgerUseAutoEntSelect: TcxEditorRow
              Properties.Caption = 'Use Auto Enterprise Selection'
              Properties.HeaderAlignmentVert = vaCenter
              Properties.Hint = 
                'This option effects how the Enterprise Code selection during tra' +
                'nsaction input. '#13#10#13#10'If this option is ticked, the program will r' +
                'equire your enter the Income/Expense '#13#10'code before selecting the' +
                ' Enterprise code. Upon selecting the'#13#10'correct Income/Expense cod' +
                'e, the program will automatically fill the '#13#10'Enterprise code fie' +
                'ld.'#13#10#13#10'If this option remains un-ticked, the program expects the' +
                ' Enterprise code'#13#10'to be selected by you before making your Incom' +
                'e/Expense account selection.'#13#10#13#10'This option only applies to the ' +
                'Cashbook entry layout.'
              Properties.EditPropertiesClassName = 'TcxCheckBoxProperties'
              Properties.RepositoryItem = AccsDataModule.erCheckBox
              Properties.DataBinding.ValueType = 'String'
              Properties.Value = 'False'
            end
            object vgerPreferencesAllowNominalLedgerAccess: TcxEditorRow
              Properties.Caption = 'Allow Access To Nominal Ledger Setup'
              Properties.HeaderAlignmentVert = vaCenter
              Properties.EditPropertiesClassName = 'TcxCheckBoxProperties'
              Properties.RepositoryItem = AccsDataModule.erCheckBox
              Properties.DataBinding.ValueType = 'Boolean'
              Properties.Value = False
            end
            object vgerEnableTransactionGridColumnGrouping: TcxEditorRow
              Properties.Caption = 'Enable Transaction Grid Column Grouping'
              Properties.HeaderAlignmentVert = vaCenter
              Properties.EditPropertiesClassName = 'TcxCheckBoxProperties'
              Properties.RepositoryItem = AccsDataModule.erCheckBox
              Properties.DataBinding.ValueType = 'Boolean'
              Properties.Value = False
              Visible = False
            end
            object vgerAutoCompleteCommentNominal: TcxEditorRow
              Properties.Caption = 'Auto Complete Comment & 1st Nominal'
              Properties.HeaderAlignmentVert = vaCenter
              Properties.EditPropertiesClassName = 'TcxCheckBoxProperties'
              Properties.RepositoryItem = AccsDataModule.erCheckBox
              Properties.DataBinding.ValueType = 'Boolean'
              Properties.Value = False
            end
          end
        end
      end
    end
    object tsAccountsSettings: TcxTabSheet
      Caption = 'Accounts Settings'
      ImageIndex = 1
      object GroupBox2: TGroupBox
        Left = 12
        Top = 14
        Width = 673
        Height = 330
        HelpContext = 195
        Caption = ' Settings For Current Accounts '
        TabOrder = 0
        object Label1: TLabel
          Left = 37
          Top = 20
          Width = 115
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Current Company Name'
        end
        object Label2: TLabel
          Left = 37
          Top = 46
          Width = 115
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Current Financial Year'
        end
        object Label3: TLabel
          Left = 331
          Top = 20
          Width = 170
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Current Financial Month'
        end
        object Label5: TLabel
          Left = 331
          Top = 46
          Width = 170
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Start Month of Financial Year'
        end
        object Label7: TLabel
          Left = 331
          Top = 73
          Width = 170
          Height = 13
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Alternative Name For Enterprises'
        end
        object CurrentMonth: TLabel
          Left = 553
          Top = 20
          Width = 56
          Height = 13
          Caption = 'Monthname'
        end
        object FinancialLabel: TLabel
          Left = 553
          Top = 46
          Width = 56
          Height = 13
          Caption = 'Monthname'
        end
        object CompanyEdit: TcxTextEdit
          Left = 170
          Top = 20
          Properties.OnChange = OnEditChanged
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 0
          Text = 'CompanyEdit'
          OnKeyDown = FormKeyDown
          Width = 145
        end
        object YearEdit: TcxTextEdit
          Left = 170
          Top = 44
          Properties.OnChange = OnEditChanged
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 1
          Text = 'YearEdit'
          OnExit = YearEditExit
          OnKeyDown = FormKeyDown
          Width = 45
        end
        object MonthEdit: TcxTextEdit
          Left = 518
          Top = 18
          Properties.OnChange = MonthEditPropertiesChange
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 2
          Text = 'MonthEdit'
          OnExit = MonthEditChange
          OnKeyDown = FormKeyDown
          Width = 29
        end
        object StartEdit: TcxTextEdit
          Left = 518
          Top = 44
          Properties.OnChange = OnEditChanged
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 3
          Text = 'StartEdit'
          OnExit = StartEditChange
          OnKeyDown = FormKeyDown
          Width = 29
        end
        object AltEdit: TcxTextEdit
          Left = 518
          Top = 71
          Properties.OnChange = OnEditChanged
          Style.LookAndFeel.Kind = lfFlat
          Style.LookAndFeel.NativeStyle = False
          StyleDisabled.LookAndFeel.Kind = lfFlat
          StyleDisabled.LookAndFeel.NativeStyle = False
          StyleFocused.LookAndFeel.Kind = lfFlat
          StyleFocused.LookAndFeel.NativeStyle = False
          StyleHot.LookAndFeel.Kind = lfFlat
          StyleHot.LookAndFeel.NativeStyle = False
          TabOrder = 4
          OnExit = AltEditExit
          OnKeyDown = FormKeyDown
          Width = 147
        end
        object CurrencyBox: TGroupBox
          Left = 440
          Top = 160
          Width = 225
          Height = 137
          Caption = ' Currency Options '
          TabOrder = 6
          Visible = False
          object Label13: TLabel
            Left = 10
            Top = 105
            Width = 72
            Height = 13
            Caption = '1 Euro is worth'
            Enabled = False
            Visible = False
          end
          object Label20: TLabel
            Left = 182
            Top = 105
            Width = 17
            Height = 13
            Caption = 'IR£'
            Enabled = False
            Visible = False
          end
          object Label14: TLabel
            Left = 6
            Top = 79
            Width = 72
            Height = 13
            Caption = '1 Euro is worth'
          end
          object Label21: TLabel
            Left = 182
            Top = 79
            Width = 21
            Height = 13
            Caption = '£stg'
          end
          object PuntImage: TImage
            Left = 184
            Top = 30
            Width = 27
            Height = 37
            Picture.Data = {
              07544269746D617096080000424D960800000000000036040000280000001C00
              0000280000000100080000000000600400000000000000000000000100000001
              0000000000008080800000008000008080000080000080800000800000008000
              80004080800040400000FF80000080400000FF00400000408000FFFFFF00C0C0
              C0000000FF0000FFFF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF
              0000FFFF8000FF8080008000FF004080FF000200580002006400000000000000
              0000586B0E007000F40000003400020000000000110000000400000000000000
              000000000000000000000000A000B67F000000001C005B00D8005B00B800B47F
              FF00FFFFBC005B002600B37F50005D00000000000A0000000100000000000000
              A4005B00120000006300F7BF000000000A0000000100000000000000EF00EC84
              57000000D0005B002300F7BF00000000870002009900F9BF7900F7BF0C000000
              F4005B002E00F7BFEF00EC8400000000EC00872B00000000460000004A000200
              2E000000A70000003F003F010000872B3F003F015000FA3BC700040000000000
              0000F91AB30000000000010000000A000000FA3B10000000000000003C00347A
              FF00872B5000413CC700FFFF870000000000872B570034438C0000000300F91A
              B300E7828F0000000000000001000A0000005701000008000000A7165900B37F
              14005B0094005B000700B47FFF00FFFFA0005B00E200B37F14005B00AC005B00
              C200B47FFF00FFFFB8005B00B000B37F14005B00C4005B003500B47FFF00FFFF
              D0005B006100410014005B00DC005B006E004100FF00FFFFE8005B00C1004100
              14005B00F4005B00DC004100FF00FFFF00005B001800410014005B00F4005B00
              25004100FF00FFFF00005B009C0041001100000001000000000000009800B67F
              01000000000000000000000000000000EC001201010000000000000000000000
              C6001D8000000000000000000500000000000000000000000000000000000000
              4C000000000000000000000068005D00000000000500000003000000D4005D00
              04000000B4005B004000000000000000C0005D00260008002F003400EC005D00
              00000000F200B47F0000000000000000C800B77F00000000000000006500726F
              2E006D7000005B00570000004400F7BF6400000050005D0020000000F8005B00
              5D00B37F01000000000000000000000020000000640000000000000200005D00
              A8005B004700B37F2000000064000000000000020500A80E0000C80E00002487
              B200D00C0000A80E00003087B2002F0198001A05000000000200980400000000
              160000000000A80E0000728700005A87000000000000010000000000E0000000
              6600B27F2F00B57FD000CF0E4700A0876E002F016400470100000000E0000000
              A000000090000000C8000000CF00000001000000D000000000004701D0005D00
              C8000000AA00B27F2F00B57FC80029790E0016CF1600EF05EC00AC119F00CA12
              8A00040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040400000000000000
              0000000000000004040404040404040404040404040000000000000000000000
              0000000004040404040404040404040404000000000000000000000000000000
              0404040404040404040404040400000000040404040404040400000004040404
              0404040404040404040400000004040404040404040000000404040404040404
              0404040404040400000004040404040404040404040404040404040404040404
              0404040000000004040404040404040404040404040404040404040404040400
              0000040404040404040404040404040404040404040404040404040000000404
              0404040404040404040404040404040404040404040000000000000000000404
              0404040404040404040404040404040404000000000000000000040404040404
              0404040404040404040404040400000000000000000004040404040404040404
              0404040404040404040400000004040404040404040404040404040404040404
              0404040400000000040404040404040404040404040404040404040404040404
              0400000004040404040404040404040404040404040404040404040404000000
              0404040404040000040404040404040404040404040404040400000000040404
              0400000000040404040404040404040404040404040400000000000000000000
              0004040404040404040404040404040404040400000000000000000004040404
              0404040404040404040404040404040400000000000004040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404040404040404040404040404040404040404040404040404040404040404
              0404}
          end
          object EuroImage: TImage
            Left = 184
            Top = 30
            Width = 27
            Height = 37
            Picture.Data = {
              07544269746D617096080000424D960800000000000036040000280000001C00
              0000280000000100080000000000600400000000000000000000000100000001
              0000000000008080800000008000008080000080000080800000800000008000
              80004080800040400000FF80000080400000FF00400000408000FFFFFF00C0C0
              C0000000FF0000FFFF0000FF0000FFFF0000FF000000FF00FF0080FFFF0080FF
              0000FFFF8000FF8080008000FF004080FF000200580002006400000000000000
              0000586B0E007000F40000003400020000000000110000000400000000000000
              000000000000000000000000A000B67F000000001C005B00D8005B00B800B47F
              FF00FFFFBC005B002600B37F50005D00000000000A0000000100000000000000
              A4005B00120000006300F7BF000000000A0000000100000000000000EF00EC84
              57000000D0005B002300F7BF00000000870002009900F9BF7900F7BF0C000000
              F4005B002E00F7BFEF00EC8400000000EC00872B00000000460000004A000200
              2E000000A70000003F003F010000872B3F003F015000FA3BC700040000000000
              0000F91AB30000000000010000000A000000FA3B10000000000000003C00347A
              FF00872B5000413CC700FFFF870000000000872B570034438C0000000300F91A
              B300E7828F0000000000000001000A0000005701000008000000A7165900B37F
              14005B0094005B000700B47FFF00FFFFA0005B00E200B37F14005B00AC005B00
              C200B47FFF00FFFFB8005B00B000B37F14005B00C4005B003500B47FFF00FFFF
              D0005B006100410014005B00DC005B006E004100FF00FFFFE8005B00C1004100
              14005B00F4005B00DC004100FF00FFFF00005B001800410014005B00F4005B00
              25004100FF00FFFF00005B009C0041001100000001000000000000009800B67F
              01000000000000000000000000000000EC001201010000000000000000000000
              C6001D8000000000000000000500000000000000000000000000000000000000
              4C000000000000000000000068005D00000000000500000003000000D4005D00
              04000000B4005B004000000000000000C0005D00260008002F003400EC005D00
              00000000F200B47F0000000000000000C800B77F00000000000000006500726F
              2E006D7000005B00570000004400F7BF6400000050005D0020000000F8005B00
              5D00B37F01000000000000000000000020000000640000000000000200005D00
              A8005B004700B37F2000000064000000000000020500A80E0000C80E00002487
              B200D00C0000A80E00003087B2002F0198001A05000000000200980400000000
              160000000000A80E0000728700005A87000000000000010000000000E0000000
              6600B27F2F00B57FD000CF0E4700A0876E002F016400470100000000E0000000
              A000000090000000C8000000CF00000001000000D000000000004701D0005D00
              C8000000AA00B27F2F00B57FC80029790E0016CF1600EF05EC00AC119F00CA12
              8A00141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141411111111111111111414141414141414141414141414141414141111
              1111111111111111111114141414141414141414141414141411111111111111
              1111111111111114141414141414141414141414111111111114141414141411
              1111111114141414141414141414141111111114141414141414141411111111
              1414141414141414141414111111141414141414141414141411111414141414
              1414141414141111111414141414141414141414141414141414141414141414
              1411111111111111111111111111111414141414141414141414141414111111
              1111111111111111111111141414141414141414141414141414111111141414
              1414141414141414141414141414141414141414141411111114141414141414
              1414141414141414141414141414141414111111111111111111111111111111
              1414141414141414141414141411111111111111111111111111111114141414
              1414141414141414141411111114141414141414141414141411111114141414
              1414141414141411111114141414141414141414141111111414141414141414
              1414141111111114141414141414141414111111141414141414141414141414
              1111111111141414141414111111111114141414141414141414141414111111
              1111111111111111111111111414141414141414141414141414111111111111
              1111111111111111141414141414141414141414141414141111111111111111
              1411111114141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414141414141414141414141414141414141414141414141414141414141414
              1414}
          end
          object EuroConverter: TMaskEdit
            Left = 116
            Top = 76
            Width = 63
            Height = 21
            EditMask = '.999999;1;_'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            MaxLength = 7
            ParentFont = False
            TabOrder = 0
            Text = '.      '
            OnChange = OnEditChanged
          end
          object EuroToPunt: TMaskEdit
            Left = 116
            Top = 102
            Width = 63
            Height = 21
            Enabled = False
            EditMask = '0.00000;1;_'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Verdana'
            Font.Style = []
            MaxLength = 7
            ParentFont = False
            TabOrder = 1
            Text = ' .     '
            Visible = False
            OnChange = OnEditChanged
          end
          object CurrencyGroup: TRadioGroup
            Left = 8
            Top = 22
            Width = 171
            Height = 45
            Caption = 'Base Currency'
            Columns = 2
            Items.Strings = (
              'IR£'
              'Euro')
            TabOrder = 2
            OnClick = CurrencyGroupClick
          end
          object TabControl1: TTabControl
            Left = 224
            Top = 16
            Width = 289
            Height = 193
            TabOrder = 3
          end
        end
        object PasswordGroup: TGroupBox
          Left = 208
          Top = 160
          Width = 227
          Height = 137
          Caption = ' Set System Password '
          TabOrder = 5
          object LPassOld: TLabel
            Left = 30
            Top = 40
            Width = 105
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Old Password'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LPassNew: TLabel
            Left = 30
            Top = 90
            Width = 105
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'New Password'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object LPassConfirm: TLabel
            Left = 30
            Top = 114
            Width = 105
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Confirm Password'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object Label4: TLabel
            Left = 30
            Top = 64
            Width = 105
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Confirm Old Password'
            Font.Charset = ANSI_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object PasswordUse: TcxCheckBox
            Left = 12
            Top = 20
            Caption = 'Use &Password'
            Enabled = False
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 0
            OnClick = PasswordUseClick
            Width = 117
          end
          object PassOld: TcxTextEdit
            Left = 146
            Top = 36
            Properties.CharCase = ecUpperCase
            Properties.EchoMode = eemPassword
            Properties.PasswordChar = '*'
            Properties.OnChange = OnEditChanged
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 1
            OnKeyDown = FormKeyDown
            Width = 77
          end
          object PassConfirm: TcxTextEdit
            Left = 146
            Top = 110
            Enabled = False
            Properties.CharCase = ecUpperCase
            Properties.EchoMode = eemPassword
            Properties.PasswordChar = '*'
            Properties.OnChange = OnEditChanged
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 3
            OnKeyDown = FormKeyDown
            Width = 77
          end
          object PassNew: TcxTextEdit
            Left = 146
            Top = 86
            Enabled = False
            Properties.CharCase = ecUpperCase
            Properties.EchoMode = eemPassword
            Properties.PasswordChar = '*'
            Properties.OnChange = OnEditChanged
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 2
            OnKeyDown = FormKeyDown
            Width = 77
          end
          object ConfirmPassOld: TcxTextEdit
            Left = 146
            Top = 61
            Properties.CharCase = ecUpperCase
            Properties.EchoMode = eemPassword
            Properties.PasswordChar = '*'
            Properties.OnChange = OnEditChanged
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 4
            OnKeyUp = ConfirmPassOldKeyUp
            Width = 77
          end
        end
        object PeriodEnd: TGroupBox
          Left = 9
          Top = 160
          Width = 193
          Height = 137
          Caption = ' Period End Options '
          TabOrder = 7
          object Label22: TLabel
            Left = 7
            Top = 40
            Width = 73
            Height = 13
            Caption = 'Reset Pointer ?'
          end
          object ResetNomCheck: TcxCheckBox
            Left = 28
            Top = 62
            Caption = '&Nominal'
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 1
            Width = 150
          end
          object ResetSalesCheck: TcxCheckBox
            Left = 28
            Top = 84
            Caption = '&Sales'
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 2
            Width = 150
          end
          object ResetPurchCheck: TcxCheckBox
            Left = 28
            Top = 106
            Caption = 'Purc&hases'
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 3
            Width = 150
          end
          object RetainTxCheck: TcxCheckBox
            Left = 8
            Top = 20
            Caption = 'Retain All &Transactions ?'
            State = cbsChecked
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 0
            OnClick = RetainTxCheckClick
            Width = 173
          end
        end
        object gbVat: TGroupBox
          Left = 9
          Top = 102
          Width = 655
          Height = 51
          Caption = 'Vat'
          TabOrder = 8
          object PaymentVatCB: TcxCheckBox
            Left = 9
            Top = 17
            Caption = 'Payment Based VAT Reports'
            ParentShowHint = False
            Properties.Alignment = taRightJustify
            Properties.OnChange = PaymentVatCBPropertiesChange
            ShowHint = False
            Style.LookAndFeel.Kind = lfFlat
            Style.LookAndFeel.NativeStyle = False
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.NativeStyle = False
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.NativeStyle = False
            StyleHot.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.NativeStyle = False
            TabOrder = 0
            OnClick = InvoiceAllocCBClick
            Width = 180
          end
          object rgSalesOrPurchOrBothVat: TcxRadioGroup
            Left = 216
            Top = 10
            Alignment = alCenterCenter
            Properties.Columns = 3
            Properties.Items = <
              item
                Caption = 'Sales Only'
              end
              item
                Caption = 'Purchases Only'
              end
              item
                Caption = 'Both Sales && Purchases'
              end>
            Style.BorderStyle = ebsNone
            Style.LookAndFeel.Kind = lfFlat
            StyleDisabled.LookAndFeel.Kind = lfFlat
            StyleFocused.LookAndFeel.Kind = lfFlat
            StyleHot.LookAndFeel.Kind = lfFlat
            TabOrder = 1
            Height = 35
            Width = 429
          end
        end
      end
    end
    object tsOwnerInformation: TcxTabSheet
      Caption = 'Owner Information'
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 12
        Top = 14
        Width = 673
        Height = 339
        HelpContext = 195
        TabOrder = 0
        OnMouseMove = GroupBox1MouseMove
        object Label17: TLabel
          Left = 476
          Top = 92
          Width = 168
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Kingswood Computing Ltd.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label6: TLabel
          Left = 401
          Top = 110
          Width = 245
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Unit 24, Dublin Chamber Business Centre,'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label16: TLabel
          Left = 476
          Top = 142
          Width = 168
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Tallaght, Dublin 24.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object lEmailTo: TLabel
          Left = 491
          Top = 179
          Width = 153
          Height = 16
          Cursor = crHandPoint
          Alignment = taRightJustify
          Caption = 'E-Mail: info@kingswood.ie'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          OnClick = lEmailToClick
          OnMouseMove = lEmailToMouseMove
        end
        object Label19: TLabel
          Left = 437
          Top = 160
          Width = 206
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Ph: +353-1-4596677 / +353-86-3900990'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Label23: TLabel
          Left = 476
          Top = 126
          Width = 168
          Height = 16
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Whitestown Road,'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object lWebsite: TLabel
          Left = 500
          Top = 199
          Width = 144
          Height = 16
          Cursor = crHandPoint
          Alignment = taRightJustify
          Caption = 'Web : www.kingswood.ie'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          OnClick = lWebsiteClick
          OnMouseMove = lWebsiteMouseMove
        end
        object SerialNumber: TLabel
          Left = 16
          Top = 67
          Width = 53
          Height = 13
          Caption = 'Serial No: -'
        end
        object Label26: TLabel
          Left = 10
          Top = 20
          Width = 137
          Height = 16
          Caption = 'Owner Information'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Verdana'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Ownerlbl: TLabel
          Left = 16
          Top = 43
          Width = 101
          Height = 13
          Caption = 'Registered Owner : -'
        end
        object Image8: TImage
          Left = 402
          Top = 12
          Width = 240
          Height = 76
          Hint = 'Kingswood Computing Ltd.'
          ParentShowHint = False
          Picture.Data = {
            0A544A504547496D6167654D350000FFD8FFE000104A46494600010200006400
            640000FFEC00114475636B79000100040000003C0000FFEE002641646F626500
            64C0000000010300150403060A0D00000E3E000017570000248E0000354BFFDB
            0084000604040405040605050609060506090B080606080B0C0A0A0B0A0A0C10
            0C0C0C0C0C0C100C0E0F100F0E0C1313141413131C1B1B1B1C1F1F1F1F1F1F1F
            1F1F1F010707070D0C0D181010181A1511151A1F1F1F1F1F1F1F1F1F1F1F1F1F
            1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F
            1F1F1F1FFFC2001108007901A603011100021101031101FFC400DF0001000105
            0100000000000000000000000005020304060701010100030101000000000000
            0000000000000102030405100001040103020503030403000000000002000103
            0411101305201230402131065014153233164122243542233411000200030405
            070B030402030000000001020011032131411251229213041020617191324230
            4081A1B1C1D152722333F0E18262B2431450F1A2733412000202020300000000
            0000000000000000011121508010209013010002010302050403010100000000
            0001001121103141516120F07181913040A1B150C1D1E1F1FFDA000C03010002
            110311000001EA80028AC5AAA887904AB95DB2E5A4002D44594654DACC45B408
            F8A4D5B4F5200000000000000000005888B68CB9B0F218D9C51000002A964E93
            5480D269CDCE72E4EAFB77730CB8B61B6BB9DFA79F67C9D6F5EFBD3200000000
            00000000000731CB8B51A61DF3A3D4F21899C790144460615CEDAD72D200F4CA
            D66A90D269CDCE72E4BF332937EBFB77C0D73E6D9F1EFF007EAD169CD59611D5
            35EEE69971E2AB793B85FA351A73D844E4EB8EACFDB58D8A79094B5E06B9E5CC
            EAB4C6466DD435EDD3A9CFA8530CD9B74ED3B355AE3A7539EA3062BDF3A3D4C5
            CA288530C6CEBAFF001678B956B96D3E96D93A580154B2F591A4D39B9CE5C97A
            67C3B3EDE844569CAB2E1E95AF6735CB8FAC6DDDC9F1E1DA2FB6AF4C7B3EFE87
            1BC7CFDCAFD1A5E7CFB05B599B69753015CA3629492B37BF33ABD31EBFB77F35
            CF8E426FAD531EB1B776879F2E74DF57AE1BEDFAA0AB96BB5CBBCEDE9E2E61AF
            F0E589956D5544453090DED37D9A6569600645D76F3A4D39B9CE5C9D776EFE4D
            970CECE9BA5FA39565C5D2B5ECE6B971F78E8F4F83F3F99BBE9D3A467CDB55F7
            D56986F1A74E3C4528D469875CDBBF9263C1356D3C21AB9F55DBBB94E3C3D0B4
            EAD2A9CFB3DB6D36BCFBDDFAB54A61B15B5D46B86D56DE1E3387AE7DCF4F4EDD
            517CD4D7F872A4F4AE5442A965EB6D87BB5BF7902A965EB3035CB57AE3BF5FA7
            5CAE50919EC13AEBF196D56DB55AE3D134EAE779F2ED36DB5AAE37D3A0D397A6
            69DB1519E0C567ADAEE57E8E7F9F2CBCDC44467D034EBD5E986AF5C6426FBDDF
            A60232D5298664DB7CBF540C65AAD30939BE2A37B8EAA6105C59C4F3674407A0
            F0B929FEED64FA2E00CDDA400000001E1A167CB0D19C8CDFA15FAAE4C8000000
            0000000061630350F2F0B3481E1E9E9E15CA53A6F3DDBA8033359B71117CD4C8
            BCFB202CD22A99CBD67071ADBAB376B531154CE265595E9BDCB4800000000000
            00061E51E435FE1CA2B9A954BC80CDDAC31B381B2FA1AE5EB603376984E3CF3F
            7B44F2D047614B93395ACDDB4FA64E96C7A569845F352F5E64BA2F9FB5B376B0
            000000000000004472D2178F3BD7988E5A5CB4E6EB6AA57AF35CA1793399EBD2
            E4CE7EF6BF79AA597ACF90C1C697EF6F65E805EBCE0E35CDD6D6AB1E1E9E1629
            195A4DCB48000000000000004773D74DF2B01E93DDBAD5281E2CB3F6BCCF5DE9
            84573522F9E9917990DED37D9A486F6A4A0000000000000000000000000005D3
            4DF2708EC2A05C95B80F4CEDAD838D7C05EB4EF3ECEF72D20000000000000000
            00000000000063E71A5F93858A4000000546DDEAED27D1716C89268000000029
            23095000001004F8000000000063675D47CBCB0F2A8000176D3B5FA5AC9F4DC0
            C3310B25A2E032CB052785E3C2C16CBE7A6397CB246990479205A2D1B51A999C
            5B304CF2409D000001E421793386E4A60E35F0F4C9D265FAAF3BD9A5DBC80314
            BC601925C05056593C05C2B304C82E10C651960C62D974F4B24B1125F293C22C
            D9CA8000000030F1AEB7C194C756931D7700000000000000002C159700000000
            0621960000FFDA0008010100010502E873665B8EBB9D65D65D77BA636EA39628
            D7DE544CECEC73C11BFDE5452DAAF145F9AE2D33B3B79B39E08DFEF2A6AEF844
            6EFE0313B26767E8F947EC27E422A5C4CF3CB3CBC3710F68B99AB24BC7FE1794
            50B3B43E6FE4FF00FBF477C277CEA64C0325D8D804C4BA59F085F3AFCA3F614B
            3C92AE1E9C56ED88888F3B34B150FC9F22B98B1347C5C5CADE196E72F76C9D7E
            4EF4050F2111D0B9CCDDB075F93BB5CE6E5EF1CBC4F2063C559E66FCE47F9388
            78CE76C84DCA5AE42B5EF8EDE9A67E7791B217B83E46C9DFF915E9A05C55ABF6
            2F725F20988CADDB27ABCCDF80A8DD8AE57E539F91A42B96C9EBF2FC840FC772
            11DD839AE6A5195AE5B62B7726B45A1165D3BB32FB8078E497759771314330C8
            DD0CF87D3E51FB09E195A28A538A4A3702DD6F917FAD5CE7FA743C251FB35B8E
            DF1D43C6536AC63DA742BC96380767670E72DED53BFC34C5F28AEB829B6B92B2
            6566ED691EBDBE7A7DDE4B8E078B8C5C454862E3F948020E4387B250C6B82AB1
            47C7F355C20E43E3B3BC76C89C8BE3FC6D692B73B4E2AB711BE1B4BD3939C33B
            C4BB7B889B04A89B0CD1CE267D11BE9F28FD8434C2D70D2C67149C2F23F6967E
            45FEB5739FE9D47FA153AA567E3E87E45706B2E2EF152E226E668D92E4A8F101
            594D58AC70ACEECFC2C3BBC973306CF22EEEEE1C7BFE0DDB0B8DE7AAC74EED9F
            B9B5C15129AB10909711CDD686A7236FEEEDFC6AAB9CB344514BC37330D48795
            BFF7B6549EEAF49200BE73A763E8CA691DAC4326E47A8FEA5CBF1C77A3FE2F3A
            AD13C55F95E13EF26FE2F3A938CB32F19FC5E75C871E76A97F179D0B607F8BCE
            A857FC6D1B927C76C9D5E3B8268CDD9CF82AC07C4D8F8C49DCDF1AE4151F8E45
            11A9BE33214BC4F0C54A6E5B862BB2C3F1990655C8F0305A37F8D7219ADF182E
            E8A28E28F91E12BDB22F8CDF67AFF189330411411729C2C571FF008CDFCC9F18
            FF00ABF8BCE8BDD72127F793E5FA4CBB9E88B0C7E41D99DAE7C65DCBF8F7279A
            DF1999CA38C238FCABE9339BC9D0FA1165529A31E96F69650880792627B17638
            8EBDD8E6282E472CA57231B32721D9347C846611CCC707E43318727DEA3B4272
            D5BB1D850DB194BF260EF19F787957F757FD644DEA9D9D9D9B2F35438DA0AD24
            A88889440F21D602087A396127823B359C61308B90221979368E4EF8A230B5FE
            47E43ED2661AD6601A1C633B54E27F4D5FFD95E291A0ADDD24356CC034A9CC53
            41E56F4EF0A1BD3B3CF384F12CBBA97B258EA463F736E76794A4ED884489E081
            A16FC8C6A29425143EE9D99DBEC2A774B5E19545045130431C6E50C646D0C6D2
            22A354899999A3863890C1109450C710C5045123A354CA38C231F2B7E2DCAFAD
            59AAE2DD602017C282CC71BB4904CD5ABECAB967BDD4331445F902ECA726EC69
            C9996E0ADC15B82B7056E0ADC15B82B7056E0ADC15B82B7056E0ADC15B82B705
            6E0ADC15B82B7056E0ADC15B82B7056E0ADC15B82B7056E0ADC15B82B7056E0A
            DC15B82B7074BB5F665D7BCBB750B930F445194871C63187D1E784668E588E23
            F0599DDE954D91D2472606B571EBF865DDDB05899EAF8166D5B8EDF8F3D78E61
            B156585FAE38CE42A94861E8B85DB56182C8A90F71A4695AA5A84A3836E7FBBA
            39C5A690AE49DC07FE4471CCDF6F1B0EDDCA911CAA43EFAA51B82EC90EF0C920
            D28E307BBCCFA464169ADD290A390FFBABCE528C35E38BF23DF3DB5077C55736
            2DB58299CA930FDEB65E49876791E2409A1F01D99DA6E3009494AC82C3B6A15A
            7350F16EA38A38C7A2C5719C403B45F8F81D9AB8664884DDA21696BD71803687
            7A4AC2721D48C80AA01471C020A288238FF1D076156123180194F18C6D54CF7A
            7AB14EFF006B1FDC45C6D78D7E26AF61F1B5CD071D5C26FC555EE601606E2AAB
            3CBC7D794C78EAE251F1D5C0A5C7216445847C3B3FA1FDE9F989BF4C7FA3C4AD
            EDD5FFDA0008010200010502E8CACF46567C4CFD3DFA1993AC79D7EB74E6B3E0
            BEADA3E8FA675CE99D33A67464E993E99D33A674CE8EFE077277CEACFE03F4BE
            8FA63C0CE8E9B57D5B46D193A6D193E8FAC8498B1D11BFAB174B68FD0C9F47EA
            CEB9E964FD19D1B467D1B467D5F491FADDFD45FA9D634C2C698D31A63A596161
            634C2664ECB1A6161634C2C2C698585858D647EB751F92C2C2C7997F0232EA77
            C2DD4526109E509E577FABC9EAD2262F4DC5BA98D01E509E56EA6F31274B8610
            8E746643EDD137B31321F42F73C266F5F5EEEC7424DDB17B4283F50B7A0FAB01
            37683E5BCAC8585B8E88B2DA3FAA06F53259D0470B7533E7A76D938B3A61664C
            CB0B1A6DB68CD85DA99B0985993C6C99BCB48D96D45D918E824B2CE84708CB46
            7C2DC40F9FA44838E8CF431BF433653363E904394ED8F0C031F4A21CA20C780C
            D94018FA69449C1FA185D34299B1F502D03E9BFFDA0008010300010502F239D7
            2B2BB9BCF67C8C9A670C845137A76BF9D93C0CF8526A2DA1FB773A2F6EE4E498
            967D1C9312EE42FE8E4EBD509A27740E8DD0123742EE88D65313A67CA23594C4
            E99F2889653BF9293A19F28FD91FB2ECD3FE2BB7466F45DE99D948C83DDD323F
            76F642DE85EE2FA037A137A868028DBA5FA5BC0934C7A217C23F647EDAB37A2E
            FD05F0DDC899B4C7A21F72F758F44269DD0368269DD46DA096113E7A1FC621CA
            DB4C8832B6D76FA6DA765B7A6DA66C27ED4CCDA037A3C6B6DD3069B684708872
            B6F4705B6E9A3D1C32B6D347A10E56DBADB5B7ABF80DE49E35D8E9A3FA0B75E5
            6565656565674CAEE594CEB2BBBCCBF4E16356E9259D3FAE9FD7099D0A14DA32
            674DE59D67A593F467AB1D78EAC7977E864EDA67464EFAE537D21FC0CFD659BE
            978F059BE9B858E9C7D4DBE9BFFFDA0008010202063F02D888E671F65122286F
            A3247829D69FFFDA0008010302063F02F543FFDA0008010101063F02E75FC97F
            90FB8E127F31947E6A7B42262D06E3127A8AA7412047E6A7B4237CEE052F9EF1
            EA8FCE3B0FC201171BBCF24F5154E82408FCD4F68798D1FA8FB3938776B5CD24
            DDA693944355AA66ED7C6F6B0970EBFF00918DCD04990449459608FC07B47C61
            01BC289F9E27FEA1FDCDCF2C6E100A6B138474E8C7C8D1FA8FB3917399E4508B
            D016053AAD2503365F9A584055125160020BD2628D985A23FF00A2A76C53A94D
            CAB92B3617DD08CF5DCA820B09E104EF0D34C114CBFEE03255623E563311FEE1
            B132CD8755E2090E6953F0A2997FDC664AA7E96B476433AD6740C66101B0456E
            2788735376E6FBEE121DA60FDC34D7044B2055635915AE739842D3E21B79498C
            B31BC7A62AD315DC2CE696E06D8AD4EB397612659FAE37546AB22A28985389B6
            053AD559D5C10031C6FF007451A745CA319B311659845346AEE506B3DB80834F
            8439698B37989EA899ACE4FD463F21A8BF2BDBFBC0AA9660CBA0C351E12C0B63
            55F844DAB393F518B2A971F2BEB08DE2D8C2C74D060F0DC3365CB654A82F9E81
            198567CDA731847AB6BAAE49E9B49F7F36661DD6DC9199CEB60B872069DBA62F
            D796B0F2147EA3ECE45AA548A6C64ADD50B510C9D4CC185ACBFC9741D107EA5E
            4A5D69FDBC9BBDD8CE57F2639B4F24BE6AF97D53F7720E1CD252B29132B7AE70
            CBA0CA388A74ED7DE4C0EA0A6246F8DD56095E9FCB50688095B844A2C6E6902B
            FB452E247D0DED1EF8A7A1E687D3FBC3B0B4D57D5F49B229D4366EDC4FD17C3C
            AEA6020FD7598E378BC48DD29EBBFDBC94B544EAA8673A735B15A9258A0CC0EB
            13F7C71A01FF000961D62C1FDDC88F9467AB6B9F74545A624864C0689C38F09A
            649FE36C16379B4C357AC82A12D250D6890895212475CD974734D2F0886909AB
            5E0C5832863210468E4B7C564325CCB87365C947EA3ECE4A345B1A4994E86CB7
            C35371265322224E7EC54B1FA34183F52F252EB4FEDE45EAE4A8896B8A859475
            4B937525CC04855C791EB0A7BC1BF911394A6A2DC63EFF00020CEF7CD6FA8031
            BEE16BEBF869E6CD3F78E4149BF2EE94FF002027131611718A230539CFF1B7DB
            15860C738FE56C4CDA4DF1FEB01F719334BFABBD1237C2D2AF30F4C48484E630
            8A95EECE6C1D184714F70A886921E9FD4A0AB0930B088143889A9A7DD329CC43
            D69494D8A3A0455ACDDC0B93D2DFB43D36EF219186A3581CB3CCA56378065403
            2A03A398B96C9E316DFCBE89F25F746F14DB61F54062253E722AB84C8676C7E6
            5EC314A91B4D34559F50940AD4D8537949E78E88FCCBD86070752A82CA4657B6
            E11F997B0C270EAC14AE5B4F408FCCBD8600D11F997B0C38AAD98292E4818417
            2CC950DEC8089FAA3FD835B788307207AAC30C45809B0414AAB34ACCD31D177B
            A27C3D5197E57F888BE98F49F840A9C43EF48B90777F7E4764AAAA8492A25708
            7A8EE1C95CA2509511C2103299C233D5528082C258721AB4CEEAA9BF418B1A99
            F49F844F89AA25F2A7C4C0A74C6545B846F14EEAB62D81EB11635323ACFC227C
            455017E54B7D66052A4B9516E11BC43BBADA703D71DEA72D333F08A6B4EA0DE0
            9EF18E3A25D51F997B0C1E455D169104E9E77509477A64DA7A3CC646D06F105B
            857001FF001BFC63B8BD798403C43854F956D30B4D04914480F3839FBDCFB80E
            A8C86C2DE2E717732511AB45CA9F1464917A9F2AC1491571E130F4A5265F5C0A
            129B1BCE886A4293395D1150E521A9899431BD95929CA15D6933669DDD11AB45
            8C54A72FC78C1035586062A8965DD5E4FEBA20EEE9B54031101A529E07CE2F94
            85DC92D31237C485F139CE6640089CF2818C01A308082F3015AF1CD53E10DAD0
            32BA8180FDA2B6F4C8B7758C5334ADCA3598455AF4BBF4AA5DD11C3B3F7EA1CC
            62B6E32E6C737A2388AB508351D4892C48B80C01197181D24C55FAA38AF4C7FB
            34BBF4DAD1D1211C615BDA465DB16300EA0EA9D301DAF33BBCD8484F345BAC34
            459632DB23EEE42C6D9C6F01FB83BE3DF0246600CDFAED85556EEDE63768ACA8
            05AF28928998DFD4B242E8EE98CCBD9CC91BA336EEDF4C7DC5CD12A6B9618A09
            66B5A15C8D65EE983500D76BCF26634C4E242E83904A77C3305D67EF18CB4C48
            5F0776B9735F199A9DBD9EC8CA824BA3CD8CAF5B47324350F4FC60D45B185BD7
            18CB1945B4C758BFD712B1BFA4C1B664C645EE0BFA79332C7775F4C6794B0E4F
            D18C764C63B2631D9318EC98C764C63B2631D9318EC98C764C63B2631D9318EC
            98C764C63B2631D9318EC98C764C63B2631D9318EC98C764C63B2631D9318EC9
            8C764C63B2631D9318EC98C764C63B2631D9318EC98C764C63B2631D9318F61E
            4B3B8D68E6659D9A39923AC3A798116F30116E1FF1051BD0632379290BE26DF9
            1AFE5256531A6E8DF8A6996FCB333F2872D8709C6F4AEF189B02D964E5E45290
            CB95C896994F1F30937A0C6B77706F219504CC6636D4D3A39954FF004FB6280C
            FF006D7BC00961D76C57ACEE569529AD300CAD18F6C70E031DF39189C6DB62CA
            8ED56A3002D95A61698AA73149D53F0115758B2E7212667608A4B49CA92096B6
            C02EBA13864CEE259EA48EB754EC85A5393D67D5B73155EB895266CF598202C6
            72E984A68CC41426A4C93E98676A8DBA0E4A5B7CB4987E29DD86698A2A0CBAA3
            84A40907100D925B4C5454A8CA81467B74DB66886656326A92473824E5124663
            4D166DAC48CD38433339CA584514DE1DF103F8FE84715533174A631C4CEC835E
            A39DED469289E18C70DC2219338198F5C6A1CD4E909CFA87C62A365663FE391D
            5585DE99B2ACDA1DF2B334F5247556287065ED90DEB454646FB7494E52C6C803
            88CD9DC8CB56F8019DB238BC9C0D90CE67273AB3D03C8C8DA3444E91CA746116
            A4C6916C5BCBAA87AE2755BF888CA82439B95890B88112996E937C309B49AD94
            EE9E88A66649A53CB3E9842DE039875C354F13C8764645248E98357C4465F446
            F33323CA53532B21566C3219AB036CFACC642CC6DCC1E76CE18CC976BDCDF029
            AF744649B11E199BBAA11F3366A760B7DB152539D4EF184E103E443ADBC7BACF
            0E8834D596A520279D44A47459642179EA5C20F116E730F2CC43891998CBAD7C
            F363099B36A597FB637AB307E5C209D691F0CEC8C92D594A5D11E2CA7C33B215
            DA7AB64A1D84F5E608C2D80D367C9DD0C6728514C114E9F7EA4055B00BBFE1C7
            957FADB9FF00FFDA0008010103013F21F077262BB622BCA77277D03EF17BE3C4
            40858085BE6796FF00B87DC1586447925E372C595EECF2DFF72DAC340E4F7694
            9DBB0B5D9FBCBCEE58B2BAE59E5BFEF5016CEC07D0DA36E90DC7C78BCC071393
            F40732F6B2D7F47620B62B06D57076EACE0CB7A9D0D8C694857A00770FBF2802
            D8EADD70D391990BD46D4F5378614D5057B2CBC9E14564137F3E1F1B78C5E054
            04B68C757A07F70D3176600E094312DF4D33FF006B2CF3C8A56D732F03F1E439
            3DC9D522F00EE95F282C46EC7EC8C0F8E5BE470F90A25FCE65A8774A5428B86E
            CBFAA89A1887270768AFA117B5B62F58365CEE521EA65F78AB925805DCCCA47A
            75BF3D475B9822D57ADB07A5D42CF8976D6DFD23B128C17BCC7648F397020307
            3D913303A1B531FDA37D8A175BE8FAED2D39366FBF6D8E9CCE51E0ABFDC1C9CC
            BA53D5C3D999C36EF73DCFF23D43B60AA6F9E2BBCE64F5BFE90DBCF5D4F9C9EC
            CAB1E7A3A3C4FEF75809C572CAFDFA87EE3B2068E28587BEAF4836D00B283966
            D876B3CF12F135C01B3AEEC5B99415A4E5DA0C29408717E17B3E60D97E0F1D39
            93B2EEA9576AEE898B55C74BDFFC4F3EEBA79E7568D37BDEE397AF1B69BB7173
            D3FD746D5030B35EA5F799A6EEB7A350C4C9EBF15EA862200A18477B9C156366
            CD992BA7331568C81DDA18C24EAF1670D1FB159F8132AE35F60FC54CF0107B2C
            3E25455B07A16FE4826C17D743F569412258B68C1EC0D43429BA20ABED15D2F6
            26B341290DAB9456BD010FA551DA8C87BCE0729DF03FB8D8DBA9DDCB132988A2
            8E36B5822971E0AD10ED8D3D45D401582FADD7FD9481AA7487FECB97322E0ED7
            1986D54A6D8D28EAA95F565355C96E439F0E0ECF0794645EE882BE5BCB41777C
            4A2A94F417F4F3DA2B736FEED3CF3AB4FC27EB43DBBB3270F72E2561DE1CBDBD
            986C35B5E998ACDB2DDAB9620DCF00B6FD54AF59538AAA464738E03AE852AD25
            EF5FF24A86DEC586E24B90B57B0A7E92852BDA393F371D3D8B4F2CEA70BBBB3E
            7111214308C6F76F40B857358CC458DCF40607C11645917516BECC3206AADC4D
            C8BE59028237C725CADD5156E1517EBBC15334BD772BD07E606749F586A2B7E1
            61DF7114E9732FC6DCA8ADB5CABA2BAF4D049B6367F5323837BD4514E2DF4BAD
            0B940391FF00270E027D46F1ADC701BF03A1A28E15216ECAE34F118B046CA56F
            C4B4B1825C37639AC69E61A1D3D90F736D3C52A6925331FDE9E76201F1A794C6
            B5D8A1C6F8A9953E588EA8A218DECA215D49676E61B768F405DA110709CE1FBC
            DE29C2D13B50DFC114D24EAFF54038CB055BBDE7429318AB46C3DA62CB24956D
            BBFA4C4D4E96CBB36F560D358AB4393DF4DC83D85BF54C53DC86A01C3FED1595
            1DEF6FE2AF880A4147B047571D82FE133DE5038D3443CF2A5A9ED401F0C011B4
            3F6F56617529AD89B53AF79B3F21774248AC9DDD5406C51D3C57EB69813F119D
            A2F5FAFCF82F4A46A801EC5662D40D007E0FD8BA3A149B2332172C98F417F923
            8961E83FD9CF0F657B5A01F99522A1701F6DB9D172E6C6CA7B42B98B6DEDA0F6
            8AEB15456974704A765D7331EDACAAAC18BF0EC7A680000AC0A298FF003F3071
            63D8F59CD836FF00B41626B57D0D350C6A801B27885B806E7E779645CC634748
            68A12EA63FF260EC8565586F5D6E0AE4A94CD43731BDF554A9AE4F58EA4C5015
            331CE61058E2AC4C8EAEF90BFB6C5FAE94E89D237B78742A0EEABB4441430910
            02D6020662B585AA5C77A487D4E9185036800948192AFB170ADABB1EFE036801
            2C48F6AB96FE28BC1EC454B666294B757E91E53B69CF3E8D4CDCC8EE4B714357
            5FDF687660DCAAF440D679B5D7FA969C3ADBB35473772E12AC1E97A1796EF2F3
            67F73FEC9473FB024F8868BB6407DB8BB6557DD6D861AFB6B75ED8BB152F2CEC
            03E126D56737EB9B68B022C6F6CF5C4673020F8BE2911FB03218F662815973D2
            E3F0470542C775DBD7ACB40E905C1B665F5DB67EA36B54F0E25E4F55B9EBA0B2
            68802D61194D000D99A7C5D42C069B3B3F2531B043BF57D5732E837C997CB2CE
            FD7312AD7833E7CD69D4B1770F81A80028600870AEEF76FEF282DD4331259DB1
            DFDFD22CC3A1E6BFF65105B7A5FD840352D87DB7FE215BFE352029DBBF5C0581
            6D5B025ADC2C05567498623D6855CF2727C411C66F1415FF00B2E5FA8EAFF9A6
            0E2A523D22F401F07C4DF95F05E6B4DE6FD87F4B9DAF37B4ED79BDA76BCDED3B
            5E6F69DAF37B4ED79BDA76BCDED3B5E6F69DAF37B4ED79BDA76BCDED3B5E6F69
            DAF37B4ED79BDA76BCDED3B5E6F69DAF37B4ED79BDA76BCDED3B5E6F69DAF37B
            4ED79BDA76BCDED3B5E6F69DAF37B4ED79BDA76BCDED3B5E6F69DAF37B4ED79B
            DA76BCDED3B5E6F69DAF37B4ED79BDA76BCDED3B1E7F6D1D69E453C0A84D3B5B
            1A8A64865BC75BBE77F06EB8F966D18D7FDFE23960F61EB1C8D26CF09D4FA400
            2D60216FDF00E9FEEB81C56667BAAE5CC114EA75B57F7F537814E42CBEE6265F
            643770CDF4FA28562905B29BBFAFB0A9F936F7250C5F0367FCFA0392FD3FB85E
            EFECF4783D7D07AE1FDC0E9A46525622DB74040856BEF61BAE045DFA2C57BF83
            90DA37B69AE16E02A8DF11C828BB805A388ED38E572E6C6EF562C4ADB752E179
            9897D2658B45AD0BDE0B84D97E46F72470619CDCF745F456630CEE9B830329BD
            85592F18DA6F148B217581BAB96E3977CB810650C6589E066651DABE3025FE7D
            9B5B25BE9296D7D8CAF39C6E4C18DE0B48ACA9002C92F1BB15D8665B8C377707
            D6A355CE1F0F474E23814D7673C1E977312EB5ADF53F28ACAF8055939EF50E48
            A4DF6CEFCD1331381501BA7C47C826077F7E682585F4946C5BD3765B22B0A8A7
            A1608F51C447932D0A0AB3D9DA38FB195F73E8BE31375925F77173FE89B89E65
            8CC51429E8EBBFA3A8A3E5A261523CB99527DAE7D5E7C3D4BE1ABE73876A9558
            CE5BF9475D92369EE4D57CC12B2C15F467D3896F5B6F185661EEEA4EC744C80F
            B2F75E94103C9ABD946F1EF0F002DCA6EA70CB646CA556EE4DE0454165C9D917
            07C4A7376DB75B762BB1365E68B9B919BAC48DD6147C45BD6586E3D9CCB12B37
            6676AC7A449BB8A6186142EB50D646866DEA2B137C92C1A335BFC40F30559706
            2B07A4002547C4FA0749DDDC83671B5567A42CEC68EE4BBA5EF3B0081F4D5540
            809DF35F46D7F981061A776CAA8A1BE67F98BFCC3A2C0A1C21B0F31493525A01
            A400EF88ABDD2A1E80086F08098B2F60FD42C29D03A1F536A6E7ACDE79EBF71F
            B7EB0F2CEBE3FFDA0008010203013F21F117A5FD12F5B9729F7D7E05FA0307C5
            BA3504B7F035D55106B10B7887C51AAE6C9718B9718BD0388C6610B145145063
            170818C5E81BD0B8BAAEB5A5389CADF4B65FEBE11F1C66CD36781C695A1B6A13
            4EED09BA1B68231683C008345AE4AD255C74A2016B9F0AF06B1A29B34D9E00C7
            8038D0869C69BB5563421835161D45BF01031E0AD09BC9617E03417ADD1AC694
            F06623500D366B9AF44B35BE06F81BE0774CD17C4AE0A3EC99B43EE6DBCF8D60
            18F118B616E180AB761E1B30554492A6957051ED2C86DBA617E19629D20C85BB
            4AF02C565FDB3A6ED089A342C2DCB9A8532F088A786216140815A3718E33BB37
            63026E90DA7E5EBA07C3B8E922EE8F63F6E08077B4B9517CE872623428BA8173
            7094863435ECCDE26D104DA256F9811BE7455BAD076400DF587B26D113C400A3
            EE93D3C14B8304E21A1D7E0DB4752F5DE56BFE22D76F05BC02EFE0B952857F10
            02A3AA7E9D5EFF00C509CC4FA14D907D7FC624176C41F1E05713AD0767F21B7F
            8FFF00FFDA0008010303013F21FB0594D1494883EFA5253EC76698916E5FE92E
            C348FBCDDF41FA4D9A2DCB9D1547723481456210DE8AC422E6E98A987589CC03
            2F8B78897995C433A32D052B4E025A0A569C64B4B3C571751FA1B34A8352A786
            695A5FE5A52AA32E7A5BD62F72724550AD8A98AE314E9540A8AAFD351543CE85
            57287C2A0F863E3D9A6558952F76F0C9A59A6F5A7CA44BB9296346DA4DC1AD1C
            7A05665CDCB47420A65CDE8254AD996BC0FC6B983E396828D05A29A4B4BCA96D
            2D2AC4A6EE3A0E86857BE8EAD8D04E875205428B4EA40AD50C5B57F75E869273
            03EE1FA0BC4BA5A42D0B4DD5192471AC4590D03EF6C16D0F13640430CDE2B981
            999D00A9B346E6062E729822B3ED95695BD5CC198A5E8159D23E1AC4B8150254
            AD2BA04A81025607DB0C7811A8458C15A835A55FF103E81E0043F884B89F4E8F
            E292E34FA0128FE359B782A121FC83FC7BFFDA000C0301000211031100001092
            464294C924C865B9924924924924924924926526E00000924854263D24924924
            924924924924EA6801EC001490A3C88A333593D44D7614CD43E5D4E379D90000
            21505C820AAB4B753FB95CC5383FA6036B824001C284FD05505145D4FEF9FB67
            6634546703160007823D1472C45DC4091F33E9ABAA3F004640E7A00124924924
            9309E492492492492492603F9D8640034BEDAF5A2182C9249249249249248382
            DF69700053628F7A8E209249249249249248190129CD40099E1B6830980B2492
            49249249249348B6EBAD1B924924924924924924924924924924F24723E24464
            9249249249249249249249249249849249247649249249249049249209249249
            249219249249E4820120804000124804004004924924888F072E492490002492
            09209200248001249249248CE924924924924924924124924924824924FFDA00
            08010103013F10F06307B07FB36803E5FCCDCBE4A9DC7CC0B6F919BF50EE7F93
            1B97BEDF3044B32785DE55234668597A50052A6401621844D9816DA24935604D
            634A07CB045655148BE4D0557D389C858E7B7DE141A1924A0026AC73E0A16C68
            9813D139F5FA0FE57C96D2F1B8DF91E2E2B56F5685D2BABAD7F691005F1D8360
            380C04E6E901237B7AF17A19B477B30B91541401C682AFC9D9C044C77FBFF0E7
            689F070E9AAC68ED057A6C4A01CB1C0DDFC08CC0A8C5A14DC1A7C21129252584
            D9D3C3C2403B6204CE305BD5CC1E4B014BC5F130DF2ABAEA0797000AA00D821E
            9E665E3659D679AFFB85F955C97019CA5B2C81D0EA5A969A2A2C515E9CD2E975
            7D951A88881672699EA53DE619301B3A0DADF58C4432702476F5E178E8112465
            927C894CF529E8CAA9103B971E1C44458EB706D15F02EE3F5C3D858A9DFB45DF
            69DD1B94CA648E89A285DD1CC4B859ADBA227ED4180DD36FC58AF45B95D21781
            FCE041070816ADBD68616EC275383F210ABF3AF004A70AFC22FD2B9B1DE3661E
            F86EDE4024C3903F6756368244DB383D45C3681A5276C408C4B95B2C04815ADC
            CDAE48F0D5557A80B00E30578AE5FDC193D3DB87B43AC5B003A66FB14136B0A6
            D62F0F3BCBFC946C2E53FD5B0CDE3159C81C14DE4EAEEF780A862114198E16BA
            6B8A1E2FF5A2F1E72801EEC1F4D006150B1F575940822B598727E0AF7962E828
            0A0ADA144198B8632F6807746EC4070ECEFC38F0921B70EA400191C8F8380E02
            E5575576BFDF4620B09B84BF71E4E65759F3AD1177CDF508CF20EAF05DA5C35A
            BDE68DB39FB15A09958E715C7E9974A284715A71657394C28C7FB375BDEA623A
            C37681EE1EA8881A8C803488EC902293BA281B2DD119B31E438C4D60DD47A95D
            596ECAF74BF33B4DDE10BAC4166FD27A87E804371E59E88DEB62054394D92C27
            4931842B8F7FC7A121D04488B77001B4354296C707B6022C2BBA5E0895B37A14
            206422573C131B5DC08003E9092180CD03631134AF1CF07B029EF2D3D67BAB67
            CB0115B009647B8394E310EC142B66ECDB703BF4D2F03A27F7AA581DE1964DE1
            8162CCA825095BDB8822BD5196C64F7AB2E1D6739860D76D062B62822820BB9B
            453F514055131EDE1BDADF23D1F0704A2D1DBC4ABBBD429CC4B8B170B4FB7463
            5AA06BD17BA6BFC084A2D209B25BC177CBFA344001B6EE93DD41DE22428611DC
            6162E4D84166D6273D7722AAAB6B956308205B405B3A1B398C37C1A1682E3C6C
            4204C621481CE6555C56FA37047655D0BD6D3D6269198A42C47A8CCB421E962F
            C04E070CC08947A31ED13CA895A8DAAC03A964195C2EF92B2941A8D489844666
            5429E466C145875B8D84B21B4031EA15CDB34081F6183F2E904F0C749521D448
            C8E1A93137A2232555407E6D862C6506960776285BCC610372771E894D66E899
            562F87725C2B162542B0974575602B06833065163B3DB3A7640FCB9D0D1666D6
            C72E2EEE1217B28DAC4C537A5B55C7485F09BC1C57F976D19B33EB4A8FE5060D
            AC40BB480EB6D90325EBA829433DCCF82FBC2D3EFA0FE8640C034704B4822210
            0F0C0E118098CEC993B569C349B308E73B9E03D2B4E18C854163419CE8E1D76D
            5539A569C0ABB5ED80F35BACB72ADBE3966AEE80BD6262B6FA74B858DDEC616D
            2F28104A1D080B48A4E62CA44C0992B10CAF5A41BB07D500A99BB21F2B1D3195
            50ECBC03A5075BD1FF005CEA24A6306A5099C5605DEEAC4DDBC393AFB2428727
            4522B8C0AD2C5AB29CDEDA4E53BA2C55C0E8D9E83036A56743D10F5A9FACF5EF
            BBC73955CAB95CB11083868519BB146FADE235E025DEE38B04CAA4817FA1607A
            8AAD3BE546D472AC005330CCA054D360718471453676A6E95D6A482C695BCE27
            A832DFB138B177681765370B6ADC72D1F98A42954DEAD7BB9D45366AF0C10270
            EF83400BAE3295158B65F6F0364501C3BF8069B388360F5FA8165422C0A44771
            228004202F9A334E87B9024F407EC27E107B845A93FD0703076870E83397D5FB
            6FCA741983405405580388CB8294E06B358FCCB8A16E0DB402F06CACF1DC948D
            55C42972B6F7CD444AB37DA05D432145C8757987B775506581295CD7AF87F1DF
            A8158B97755D80E5656754C373578BE5029306AB4393D499A20003A86906EAED
            C9BC120C5A2064A74E91CE2A2282C5DEB31E541D2106E8160080651772DEB8CC
            3FEADA34695701567E77ED87B1E92803805A27AD189947FA44B931F116A10482
            AE307470CBA3A3258B2F605B78C12AD9E7B197E6A363EFB6A174FDB1A3D17EF4
            74DB2E1668B50F15BE9849264D64D17EF1EF355E1137236C482DD568235B4009
            82C576E2E24381095428015B56F04278691D9B795ADD62D23296AB4E1E92E9F4
            B61C2D322F5F00A0742A25A29FA282F76BDE55242A7DE2D223C5542167543040
            58CD3E2A1F772D1A85F0C382DDEA0164AA45A3E065DB274583984771668F7776
            7F4E2CECEABA966E2F9A21C8338810C28C82C95C9A06D1CD85AF9C17F89F85FD
            33CD77C66AABDF0D12BB5AFB7A44F30CC36D273AEE2313E9242D1B3B06DE90EF
            2400D0A30AF4FB6489B76B30370CBF32F7AEEE8FA01F9B85EEB602D4C365EB5B
            B051137339CFEE651B0C118B5119C6F55333D7D95AA1CE5F8966C5D903725BFF
            008216678DB05B556ED9B732BF895D6574AA1BDD92A62C65DE54734449132020
            BCB3AD80200958D945EB65E3E608C231504E80D3D7EB7D0CE8000A8C22384460
            4E2D0208DEDFD13951DEC4E8351EF37794CB68DAC2BDD8406D415916F2BD5081
            EF9436EC350969E9360570B5C344AF2702C5CDA47F100014180030004297518A
            BEAC985FAE54A6EDB76D7C404AF8551402E4F0226910D8D64AC2A156DA3E4DAD
            14AF28060CFB39145B6EF7F6CB5578C376987BDB5A59659C86310385D765ABB2
            FF0091C00528016DD735B31DEC8E50DCB3D3D99DA28B07DD37EC90D947A00872
            E96A2BB6F61416A0DD84B9570520670F45A2C1A04A8A4784E936CD46775E5B67
            DAE5A309BDD500576684096383FAEFF08366CD9B366CD9B366CD9B366CD9B366
            CD9B366CD9B366CD9B366CD9B366CDFB5CA8223B3BC40A1D5361FE9FD7837F15
            E917D0DB540444D930C6647157E09583E0057750780DD5D83309EA30795E5775
            CBFC41115B8373D84FEBD6C09D1FA4E91A0F2AB8022320599937AAEA19D34560
            65B0555DA1665408C36032DDC82E8BDF9AFA6103D5683C10527BC18EB3889A28
            BA8FD15D4A2F9BEA80B4FD831B973BAFB76EA4456E68FF00FB3B3F438EB06C0E
            AB60EEC10E129E03B97FCBE0CF54DB740AFE612CECAE8C581665941CC44584F0
            E559605B899CC540A6E1944F4712F3D3750154D461E8E90ACEAF49F07B512AD6
            F30DA515AC4A4CD564B6601921437DE55DEAE36921E36D56B70375EF0DFF0076
            33A45748C6FBCCA80B366C0DD8B7D6A1D175570EEB67A68857792E642C4D6BDD
            6F496D2A0492CF154E46273DFACE39094DDF48DA64071D0D36064305D65967D4
            90EF7EDAD9EACB15DED814A5D937B1DA555526D8A40DD100F58EFAA4B98B1E45
            EEA621F26D9A973336FCC7B1C40330D3D7B36968DD730A95DE8ADE90A37B4371
            A1DAB6AB131B0C92E4D541A03E5898F6C37AB577702E5305B11CEE10569D3ACC
            DA91626D4781CF78E5CB8468C8D46F865214C9AB1D8DF087118408582A536C9D
            18895161CDC1BB9553DBE88B17A2887718F5AD9CAAF67FD23CD13B34EB583DC8
            C185B823F0E80AD1BC6CBA6D068B41DC72AF65947B105725725D532BD7C226FD
            B105506765AC4E6DEDF57D6844B55505EB6505EA1986B8ED29B38E698E888C24
            00820822B3571C4692A20500D62EED94571512B2AE00B5BDA5E059AA511515CA
            CE657F73E57EE793A66075196985DC367371BB0C2C36D941C14ED1C1540C0040
            2005B0010096E12B5155B4ADEE5F6405084D750299DD5CC314A24B645B2970CD
            25C46E0D828B58EB00DA258A1B57302B572747398C360ED952C81CB11DB571A4
            52688DED8D076ACAAB880987585D42E25E38DC8E0C0F9C0DE284CF17621884D3
            F7B5C0BBADA998B2AA84056C2C8F22B11585DE25DECB4F5837D49362942BB5C7
            586674BC2674C0CF582C7C15E3EC8E074461E8C41560460165751DD1B8486CE3
            89B4334C0720363670E59CDD620DD136A0283EA7E67F64FCF7EE7E29FAFB86CF
            A7F4CFC77F6FDA09FFDA0008010203013F10F0208B9696CB41403E2594D14948
            8333B9F7AA4A6AB515FA0A407C1B34C48B72CDF696144EC436FBCDDAAD4B3516
            5D886B64BC42F574F08D4B35D9A2DCB1D1D12FD62481F588C190C6E2306454DF
            3119847BCC61DE33BC7BC45BCC6368CBBC7E25A212C27192D044AD3809688EB7
            3A2816CB331152D7A388B286F98677D99F0D0C34D9A541A9617E1AA5697F9E95
            AA8C16F4B7311B90731D42DB1531DC1A4E9410D328BD2A20A63A7434B654E941
            AA2B891ED458CCD82858694D0327388E360F0F169B34CA912A52F868D2CD37AD
            2AB443B92A58E897A05C0A74E2D0C3315B72E1D00299737392254A0A65CD1E74
            35B2E3779D46FC5E83F11CADCE3F514D781D3AAB40A25CDCB45B49697952DA5A
            0A44E6EA30C3D12D28DF462C680D06CB43AA054265A1D502A5D2D18B4DDA611D
            258AF5F15A87BB77F8FB2E86927302BED9DF462E508BA0C5D2EE2A64985E7C26
            D102621AC55D662C7A045DA21C314ED4FCC315B5974523A46CA445D42C4E2644
            35DEDDA711A156CDB8612286ABFF007FE451C44AEA55FDB6ED33DFB1A0BC441A
            602B4432D6ED99FD8EB1F0E912A730D1BBC04643C0E63851E9FF0026CA97658E
            195194F79E5BBB9B88370E2AFBFB4091B66D2B0A5838E6143EACDB2FD980FF00
            95512C83769FDCC210038EF05EE7DB2D68DE19CE49886075FEB4536BCC74EE1B
            FF00B0D14DD17E7E61245B7331B0A6F5E778AA82E09E811E8B2D0682DD104A66
            7BDDEF365DC068D45D455EF0E230DA2D265A59194002897D4AB8D019DD06A144
            B0AD5C4EDCBE3F529451F6D7B5B99F018A32EFFEC707092A8BE7FD7E7FE41AB0
            F69939B5967FF4697A23C48D895FC46C7BB6F02855E35B8053877F0280DD8603
            63F88B1BE9E8056899C77F9AFE2AA10D676EBF41CA16CCE39FD7F8C04A769947
            FD26FB6F4CC44DF5D9D46DDFB10AA15FC8CEFF00C77FFFDA0008010303013F10
            F05CBF05CBF101BB3BE7CC1B82DD9DF3E6096B89DF837F782DD9DF3E7C17F576
            B44A9DE88EADDE5DB7FEA350276E1A0FBCDBF4FF007C6B45C1AC41BFA3B5A2EE
            835B000A22D8353B88251CE20D2D637BD112C30DE8C7F7A2258635B148E34BA7
            FC8A6F51AADA4135911196C6B0B70D55551155771A80D4265B5116B6C5F96729
            7EB02C23DFE58BEEB39087611C605F76C762EF5ABAD694966FA5B05FA1B5A2C2
            F888AC8361ADB1EDA18759D30D0364829A8C637BFF003429A68778E50136BD92
            B3BCB37AB28DE8CBCED0FC0E821DE1A0441A0007961204A5FA45B6E22C2E0E3D
            9D1D73D4A655C4D153056BC269B5A04BB088A99BE6ED6D8F6D3668EE1BDE81D3
            F3A5CB57FF0011FF00ED81B2D1AA77A8352B25E4587AEAD044DC4B2EA888EA54
            4AC33A0497F16ABC6D1923C43A2339C68E8818F05684DC4B8BF120019DE94074
            25CB1A9DE960B3BD1CED3BD0277A58DB19BBA653CAC8AD84D5D98BCBE67A1055
            ABD195471152ADCB4235184B7476CC31EC4EABE200A36998D98F662F2F88628D
            A1E4619E84C25399DED72545F12DC147D8A4CD6A76258CA0051F709BCF8D6198
            F1005B0BF0C355CC3C39869224850D54047B4B6D365D42DC4B14E90609BED29C
            0B1597F71BB4226884685B82DA810A7C2628618C5B8A05415A3862017766E54B
            D2BBB012239E89B06E4C8A4025AC7EDF0A18D2E505F3A0CB88D0A205CDF25602
            63C3D883BA0EC806D10B70037A28DD6826D023700DA09B453880147DB5DE1004
            B8308E21A05760D114BD4A17FC456F82DF029E0B1A828AFE2285441A7E9D4EFF
            00C518CC6FA04769EEBF8C482ED12F00DE275601B7F21B7F8F7FFFD9}
          ShowHint = True
          Stretch = True
        end
        object lMTDCodeEntered: TLabel
          Left = 24
          Top = 301
          Width = 188
          Height = 13
          Caption = 'MTD Client Code has been stored.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object btnRegisterProgram: TcxButton
          Left = 460
          Top = 220
          Width = 185
          Height = 32
          Action = actRegisterProgram
          TabOrder = 0
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = True
        end
        object btnEmailSettings: TcxButton
          Left = 460
          Top = 256
          Width = 185
          Height = 32
          Action = actEmailSettings
          TabOrder = 1
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FF7B9292828C8CFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF68838369848492B2B682
            B4B0789595878C8C90A4A7FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            848888799295597A7F5773746E8C8B54787B728F8EA0BCBC90B4B8FF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF506665597472627F835976775D7F7E73
            969A607D797997977E9E9E839395899A9C92A9ACFF00FFFF00FFFF00FF768888
            5B767B4D6767546E6E6688866A908F6D939179A9A483ADAF81A6A47896959DB8
            BCFF00FFFF00FFFF00FFFF00FF747D7B506968586F6E6F8B896E8C8A6D928F86
            B5B083B4B0689291557976748C8E8CAFB58295978A9191FF00FF8B9191738B8B
            5B747257726F5774725874705E7D796F98936A928E5E828070979391B5BA6E98
            9D7EA3A49DB5B4FF00FF878C8C6F8786627B796A88886A88885E77756F817E68
            75736D8E896E999588AFAD7AAAA64B6E6C89A6A5FF00FFFF00FFFF00FF7E8282
            829C996E8C8C5E797A586E6E677F7E878B8B62787478A39EA0CBCAA5D4D080A4
            A57DA0A496B5B8939A9AFF00FF758281889E9C607F7E59747553696A4D66664E
            6360546A677E9E99ADDAD7B4DCDC86ABAD749FA3B4D8D8A7BCBAFF00FF767D7D
            839A97749291415E5F3C55582E4648354B4B46625F769591B7DEDE95C1C15C80
            7D70919099A6A6FF00FFFF00FFFF00FF80908E7E9C9F3F5F622942472A43452E
            4544506E6C789A989AC2C47DA09F73929688ACB291A1A3FF00FFFF00FFFF00FF
            767D7B647A77739397678488526D6D5574736584826C8A894E6C684D726C82AA
            ADAAD0CEFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF8088886A88876C888766
            838057736F49625F6E8E8B789E9E84A4A3939999FF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FF768180FF00FF60706F89A1A36B7A7B819C999CAFAFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7B
            8181899291FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = True
          Spacing = 14
        end
        object cxButton3: TcxButton
          Left = 460
          Top = 292
          Width = 185
          Height = 32
          Action = actEmailTemplates
          TabOrder = 2
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00ADADAD009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C
            9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C00FF00FF00FF00FF00FF00
            FF00ADADAD00F7F7F700F7F7F700F7F7F700EFEFEF00EFEFEF00EFEFEF00EFEF
            EF00E7E7E700DEDEDE00D6D6D600D6D6D6009C9CA500FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF00F7F7F700F7F7F700F7F7F700EFEFEF00EFEFEF00EFEF
            EF00EFEFEF009C9C9C009C9C9C00D6D6D6009C9CA500FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF00FFFFFF00F7F7F700F7F7F700F7F7F700EFEFEF00EFEF
            EF00EFEFEF00EFEFEF00E7E7E700DEDEDE009C9CA500FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF009C9C9C009C9C9C00F7F7F7009C9C9C009C9C9C009C9C
            9C00EFEFEF009C9C9C009C9C9C00E7E7E7009C9CA500FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F7F700F7F7F700F7F7
            F700EFEFEF00EFEFEF00EFEFEF00EFEFEF009C9CA500FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF009C9C9C009C9C9C00FFFFFF009C9C9C009C9C9C009C9C
            9C00F7F7F7009C9C9C009C9C9C00EFEFEF009C9CA500FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00F7F7F700F7F7F700F7F7F700EFEFEF009C9CA500FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF009C9C9C009C9C9C00FFFFFF009C9C9C009C9C9C009C9C
            9C00FFFFFF009C9C9C009C9C9C00F7F7F7009C9CA500FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00F7F7F700EFEFEF009C9CA500FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00EFEFEF00E7E7E700DEDEDE009C9CA500FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C
            9C00FFFFFF00ADADAD009C9CA5009C9CA5009C9CA500FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00ADADAD00FFFFFF00E7E7E7009C9CA500FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF009C9C9C009C9C9C009C9C9C00FFFFFF009C9C9C009C9C
            9C00FFFFFF00ADADAD00E7E7E7009C9C9C00FF00FF00FF00FF00FF00FF00FF00
            FF00ADADAD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00ADADAD009C9C9C00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00ADADAD009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C
            9C009C9C9C009C9CA500FF00FF00FF00FF00FF00FF00FF00FF00}
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = True
          Spacing = 14
        end
        object btnEnterMTDSecret: TcxButton
          Left = 12
          Top = 292
          Width = 213
          Height = 32
          Action = actEnterKingswoodMTDClientCode
          TabOrder = 3
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = True
        end
        object MTDUsernameAndPasswordButton: TcxButton
          Left = 236
          Top = 292
          Width = 189
          Height = 32
          Action = actMTDUsernameAndPassword
          TabOrder = 4
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = True
        end
        object cxButton4: TcxButton
          Left = 236
          Top = 256
          Width = 189
          Height = 32
          Action = actBillingAppLoginDetails
          TabOrder = 5
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = True
        end
      end
    end
    object tsMaintenance: TcxTabSheet
      Caption = 'System Maintenance'
      ImageIndex = 3
      object cxGroupBox2: TcxGroupBox
        Left = 12
        Top = 14
        Caption = 'Kingswood Accounts System '
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 0
        Height = 330
        Width = 673
        object btnDataIntegrityCheck: TcxButton
          Left = 20
          Top = 32
          Width = 185
          Height = 25
          Action = actDataIntegrityCheck
          TabOrder = 0
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = True
        end
        object TempEdit: TEdit
          Left = 592
          Top = 22
          Width = 69
          Height = 21
          TabStop = False
          CharCase = ecLowerCase
          MaxLength = 15
          TabOrder = 1
          Visible = False
        end
      end
    end
    object tsFarmSync: TcxTabSheet
      Caption = 'App Sync'
      ImageIndex = 4
      object cxGroupBox3: TcxGroupBox
        Left = 12
        Top = 14
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'App Sync'
        Style.TextStyle = [fsBold]
        TabOrder = 0
        Height = 336
        Width = 681
        object AgeByLabel: TLabel
          Left = 28
          Top = 153
          Width = 123
          Height = 13
          Caption = 'Age Of Debt - Output By:'
        end
        object SyncSettingsBtn: TcxButton
          Left = 10
          Top = 281
          Width = 115
          Height = 35
          Action = actSyncSettings
          Anchors = [akLeft, akBottom]
          TabOrder = 7
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0094A8A8009AA3A300FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00829B9B00839C9C00A8C3C6009AC4C10091AAAA009EA3
            A300A6B7BA00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF009C9F9F0092A8AA0074939700728C8D0088A3A2006F9194008BA5A400B4CB
            CB00A6C4C800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF006B807F00748D8B007C979B00748F9000789796008CABAF007B95920092AC
            AC0096B2B2009BA9AA00A0AFB000A8BBBE00FF00FF00FF00FF00FF00FF008F9F
            9F00768F9400688181006F888800809F9D0084A6A50087A9A70092BBB7009BBF
            C00099B9B70091ABAA00B1C8CB00FF00FF00FF00FF00FF00FF00FF00FF008D95
            94006B8382007389880089A2A00088A3A10087A8A5009DC5C1009BC4C10082A8
            A70070928F008DA3A400A3C0C5009AAAAC00A1A7A700FF00FF00A2A7A7008CA2
            A200768D8B00728B8900728D8B00738D8A007995920089ADA90084A8A400799A
            98008AACA900A7C5C90088ADB10096B6B700B1C5C400FF00FF009EA3A300899E
            9D007C949200849F9F00849F9F0079908E0089999600828E8C0087A4A00088AE
            AA009FC0BF0093BCB90066888600A0B9B800FF00FF00FF00FF00FF00FF00969A
            9A009AB0AE0088A3A3007992930073888800819796009EA2A2007C918D0091B6
            B200B4D7D600B8DEDB0098B7B80095B4B700ABC5C800A9AFAF00FF00FF008E9A
            99009FB2B0007B979600748D8E006E83840068808000697D7B006F84810096B2
            AE00BFE3E000C4E4E4009DBDBF008DB3B600C4E1E100BACBC900FF00FF008F95
            95009BAFAC008DA8A7005C797A0056707300476163004E666600617C7A008FAA
            A700C7E6E600AACFCF00779895008AA7A600AEB9B900FF00FF00FF00FF00FF00
            FF0098A6A40096B0B300597A7C00415D6200425E600047605F006B88860091AF
            AD00AFD0D10095B4B3008CA8AB009FBEC300A7B5B600FF00FF00FF00FF00FF00
            FF008F9594007E9390008CA9AC00819C9F006D878700708D8C007F9C9A0086A1
            A00069868200688B86009ABCBF00BCDBD900FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00989F9F00849F9E00869F9E00809B9800728C8900647C
            7A0088A4A20091B2B2009CB7B600A9AEAE00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF008F999800FF00FF007B8A8900A0B5B6008593
            940099B0AE00B0C0C000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0094999900A0A8A700FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          LookAndFeel.Kind = lfOffice11
          LookAndFeel.NativeStyle = True
        end
        object cxButton1: TcxButton
          Left = 130
          Top = 281
          Width = 115
          Height = 35
          Action = actResetSyncFlags
          Anchors = [akLeft, akBottom]
          TabOrder = 8
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF002373
            8A00327C91004894A9005A98AA0066A9BB0066A9BB005A98AA005993A4003B7C
            8F0020677B002A718600FF00FF00FF00FF00FF00FF00FF00FF003F8296003E95
            AE0078B9CC004D95AA0076BACE0099CFDE00D4EBF100BCD5DB0097BDC7006DA2
            B10044889C001C677D00005D7800FF00FF00FF00FF00FF00FF001C687E00449E
            B80082C1D3004890A50070B7CB0098CEDD00D7EEF500C1D8DE009CC0CA0073A6
            B4004A8C9F00206E840017576A00FF00FF00FF00FF00FF00FF001C687E00449E
            B80082C1D3004890A5002D2D2D0058534E00D7EEF500C1D8DE009CC0CA0073A6
            B4004A8C9F00206E840017576A00FF00FF00FF00FF00FF00FF001C687E00197D
            9900428FA5004B93A80058534E00454442005160610081B2C000689EAD004C89
            9A00317386001B677D0017576A00FF00FF00FF00FF00FF00FF00005D78004495
            AC0082C1D3004890A50070B7CB0054777B001A9CC20018556F00425A940073A6
            B4004A8C9F001861760000465A00FF00FF00FF00FF00FF00FF001C687E00449E
            B80082C1D3004890A50070B7CB0054777B0029799A00947E75001A9CC200425A
            94004A8C9F00206E840017576A00FF00FF00FF00FF00FF00FF001C687E00449E
            B80082C1D3004890A50070B7CB0098CEDD001A9CC20027D1FC0004B8EC001A9C
            C200425A9400206E840017576A00FF00FF00FF00FF00FF00FF001C687E002488
            A400529BB0004A92A7006BAFC2008AC3D3001A9CC200ACEDFC0027D1FC0004B8
            EC001A9CC200425A940017576A00FF00FF00FF00FF00FF00FF00005D7800398A
            A20072B5C8004991A5006FB4C80093CADA00C7E3EC001A9CC200ACEDFC0027D1
            FC0004B8EC001A9CC200425A9400FF00FF00FF00FF00FF00FF001C687E00449E
            B80082C1D3004890A50070B7CB0098CEDD00D7EEF500C1D8DE001A9CC200ACED
            FC0027D1FC0004B8EC001A9CC200425A9400FF00FF00FF00FF001C687E00449E
            B80082C1D3004890A50070B7CB0098CEDD00D7EEF500C1D8DE009CC0CA001A9C
            C200ACEDFC0027D1FC0035A8F500222F9B0011087500FF00FF001C687E00469F
            B90073A6B4004A8C9F002B819A002B819A002B819A002B819A003B7C8F003B7C
            8F001A9CC2004A9EED000018C600455FC400222F9B0011087500397F93002B81
            9A004890A50070B7CB0066A9BB009CC0CA00C1D8DE009CC0CA0070B7CB004890
            A50024697D000018C600889FE1008997DF000018C600FF00FF00FF00FF001972
            8B00196C83003B879C003A8CA2005A98AA005A98AA003A8CA200478699003272
            85001C5E72003E899E000018C6000018C600FF00FF00FF00FF00}
          LookAndFeel.Kind = lfOffice11
          LookAndFeel.NativeStyle = True
        end
        object teCompanyId: TcxTextEdit
          Left = 10
          Top = 48
          TabOrder = 0
          Width = 271
        end
        object btnUpdateCompanyId: TcxButton
          Left = 289
          Top = 45
          Width = 66
          Height = 25
          Action = actUpdateCompanyId
          TabOrder = 1
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = True
        end
        object cxLabel1: TcxLabel
          Left = 10
          Top = 26
          Caption = 'Company Id (Only to be supplied by Kingswood)'
        end
        object cbSyncWhenJobCardOpens: TcxCheckBox
          Left = 10
          Top = 78
          Caption = 'Check for new job card entries when Job Card screen opens'
          TabOrder = 2
          Width = 327
        end
        object JobCardActiveEntGrid: TcxGrid
          Left = 375
          Top = 48
          Width = 298
          Height = 268
          Anchors = [akLeft, akTop, akRight, akBottom]
          TabOrder = 12
          LookAndFeel.Kind = lfFlat
          LookAndFeel.NativeStyle = False
          object JobCardActiveEntGridTableView: TcxGridTableView
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
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnFiltering = False
            OptionsCustomize.ColumnGrouping = False
            OptionsCustomize.ColumnHidingOnGrouping = False
            OptionsCustomize.ColumnHorzSizing = False
            OptionsCustomize.ColumnMoving = False
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Inserting = False
            OptionsView.DataRowHeight = 21
            OptionsView.GroupByBox = False
            OptionsView.HeaderHeight = 28
            OptionsView.Indicator = True
            object JobCardActiveEntGridTableViewEnterpriseName: TcxGridColumn
              Caption = 'Enterprise Name'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Options.Filtering = False
              Width = 148
            end
            object JobCardActiveEntGridTableViewUse: TcxGridColumn
              Caption = 'Available On App'
              DataBinding.ValueType = 'Boolean'
              PropertiesClassName = 'TcxCheckBoxProperties'
              Properties.ImmediatePost = True
              Properties.OnEditValueChanged = JobCardActiveEntGridTableViewUsePropertiesEditValueChanged
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Filtering = False
              Width = 92
            end
            object JobCardActiveEntGridTableViewId: TcxGridColumn
              Caption = 'Id'
              DataBinding.ValueType = 'Integer'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Hidden = True
              Options.Editing = False
              Options.Filtering = False
            end
          end
          object JobCardActiveEntGridLevel: TcxGridLevel
            GridView = JobCardActiveEntGridTableView
          end
        end
        object cxLabel2: TcxLabel
          Left = 375
          Top = 24
          Caption = 'Select Enterprises to use with the Job Card app '
        end
        object cxButton2: TcxButton
          Left = 250
          Top = 281
          Width = 115
          Height = 35
          Action = actFullSync
          Anchors = [akLeft, akBottom]
          Caption = 'Sync Now'
          TabOrder = 9
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00416F41001B4F1B00245F2400235E2300154F
            15001B541B00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF0020512000275A270072C07400A4F4A500A3EFA500A4EFA600ACF7
            AD0081D1820011551200094A0900FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00416F4100448B460062B4650070C9740077D3790079D77B0079D57B0075D0
            78006FC973006EC2700046934700416F4100FF00FF00FF00FF00FF00FF00FF00
            FF002D5E2D0051A3540065BB680076D479001E701F0028812B0028812B007ADA
            7F0074D1770067BF6A005BAD5E0009500A00FF00FF00FF00FF00FF00FF00FF00
            FF00337A350063BD670074D477002575250062C2650088EF8C0088EF8B0083EA
            88007BDE800070D0750064C0680032803500FF00FF00FF00FF00FF00FF00416F
            410037883C006ED3740077DE7D000A4E0A0089F890008CFC93008CFB920088F6
            8E001C6A1D0074D878006CCE72004195450026692800FF00FF00FF00FF001F62
            20004096440053B558000A4E0A000A4E0A000A4E0A0078E57F008CFF95001D6C
            1D000A4E0A000A4E0A003E98410048A34E0008520800FF00FF00FF00FF001F62
            20003E9643006ED8750057BC5C000A4E0A001C6C1D008BFF93008AFF93002E87
            30000A4E0A00287D2A00277A280046A14D0009530900FF00FF00FF00FF00416F
            4100348E3B0067D36F006FDE780058C15E0081F88A0083FC8E0083FC8C007FF6
            88000A4E0A006CD9740065CF6C003A96410026692800FF00FF00FF00FF00FF00
            FF002B82340054C05E0065D46F006FE3790076EE800078F0830078F0820055C1
            5C00094C090063D16B0056C05F0029843100FF00FF00FF00FF00FF00FF00FF00
            FF003669360037A043004FBD5A0062D56C0068DE73006AE276006AE1760067DC
            720060D36A0051C05C003DA7490009540A00FF00FF00FF00FF00FF00FF00FF00
            FF004C814C002F903A003EAB4B0059CC66005FD46B0062D86E0062D76D005DD3
            6A0059CC660046B453002C903600416F4100FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00366936003574380041B050008BF29900A0F6AF00A1F6B00097F6
            A4004BBA590019641B000C520C00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF002F6B30002B672C002A732D0028722B001E5F
            1F00185E1800FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          LookAndFeel.Kind = lfOffice11
          LookAndFeel.NativeStyle = True
        end
        object AgeByCombo: TComboBox
          Left = 175
          Top = 149
          Width = 162
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 5
          Items.Strings = (
            '1 Month'
            '2 Months'
            '3 Months'
            '6 Months'
            '9 Months'
            '12 Months')
        end
        object cbOutputAgeOfDebtOnSync: TcxCheckBox
          Left = 10
          Top = 126
          Caption = 'Output Age of Debt during sync operation'
          TabOrder = 4
          Width = 327
        end
        object cbOutputExtStatementOnSync: TcxCheckBox
          Left = 10
          Top = 176
          Caption = 'Output Extended Statement during sync operation'
          TabOrder = 6
          Width = 327
        end
        object cbDownloadJobCardOncePerSession: TcxCheckBox
          Left = 10
          Top = 102
          Caption = 'Limit download of Job Cards to once per program session'
          Properties.OnChange = cbDownloadJobCardOncePerSessionPropertiesChange
          TabOrder = 3
          Width = 319
        end
        object cbOutputJobCardRptOnSync: TcxCheckBox
          Left = 10
          Top = 200
          Caption = 'Output Job Card Report during sync operation'
          TabOrder = 13
          Width = 327
        end
        object cbOutputProformaRptOnSync: TcxCheckBox
          Left = 10
          Top = 224
          Caption = 'Output Proforma Report during sync operation'
          TabOrder = 14
          Width = 327
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
        ShowMark = False
        SizeGrip = False
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
            Item = blbSave2
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
        ShowMark = False
        SizeGrip = False
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
    Left = 216
    Top = 7
    DockControlHeights = (
      0
      0
      48
      0)
    inherited blbExit: TdxBarLargeButton
      Width = 70
    end
    inherited blbView: TdxBarLargeButton
      ImageIndex = 8
    end
    inherited blbPrint: TdxBarLargeButton
      ImageIndex = 17
    end
    inherited blbHelp: TdxBarLargeButton
      Visible = ivNever
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
      Width = 70
      ImageIndex = 9
    end
    inherited blbCancel2: TdxBarLargeButton
      ImageIndex = 10
    end
  end
  inherited ActionList: TActionList
    Left = 246
    Top = 7
    inherited actHelp: TAction
      OnExecute = actHelpExecute
    end
    inherited actSave2: TAction
      OnExecute = actSave2Execute
    end
    object actDataIntegrityCheck: TAction
      Caption = 'Data Integrity Check'
      OnExecute = actDataIntegrityCheckExecute
    end
    object actRegisterProgram: TAction
      Caption = 'Register Program'
      OnExecute = actRegisterProgramExecute
    end
    object actSyncSettings: TAction
      Caption = 'Sync Settings'
      ImageIndex = 6
      OnExecute = actSyncSettingsExecute
    end
    object actResetSyncFlags: TAction
      Caption = 'Reset Sync Flags'
      ImageIndex = 18
      OnExecute = actResetSyncFlagsExecute
    end
    object actUpdateCompanyId: TAction
      Caption = 'Update'
      OnExecute = actUpdateCompanyIdExecute
      OnUpdate = actUpdateCompanyIdUpdate
    end
    object actFullSync: TAction
      Caption = 'Full Sync'
      ImageIndex = 44
      OnExecute = actFullSyncExecute
    end
    object actEmailSettings: TAction
      Caption = 'Email Settings'
      ImageIndex = 6
      OnExecute = actEmailSettingsExecute
    end
    object actEmailTemplates: TAction
      Caption = 'Email Templates'
      ImageIndex = 7
      OnExecute = actEmailTemplatesExecute
    end
    object actEnterKingswoodMTDClientCode: TAction
      Caption = 'Enter MTD Client Code'
      OnExecute = actEnterKingswoodMTDClientCodeExecute
    end
    object actMTDUsernameAndPassword: TAction
      Caption = 'MTD Username && Password'
      OnExecute = actMTDUsernameAndPasswordExecute
    end
    object actBillingAppLoginDetails: TAction
      Caption = 'Billing App Username && Password'
      OnExecute = actBillingAppLoginDetailsExecute
    end
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 277
    Top = 7
    object cxStyleCategory: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 16637633
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      TextColor = clInfoText
    end
    object cxStyle1: TcxStyle
      AssignedValues = [svFont]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
    end
  end
  object PreferencesEditRepos: TcxEditRepository
    Left = 306
    Top = 7
    object erPayVatOptionsRG: TcxEditRepositoryRadioGroupItem
      Properties.Columns = 3
      Properties.DefaultValue = False
      Properties.Items = <
        item
          Caption = 'Sales'
          Value = False
        end
        item
          Caption = 'Purchases'
          Value = False
        end
        item
          Caption = 'Both Sales and Purchases Based VAT'
          Value = False
        end>
    end
  end
end
