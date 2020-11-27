object BankCSVConfigForm: TBankCSVConfigForm
  Left = 527
  Top = 158
  BorderStyle = bsDialog
  Caption = 'Source Bank - File Format'
  ClientHeight = 520
  ClientWidth = 661
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object WarningCaption: TLabel
    Left = 192
    Top = 48
    Width = 432
    Height = 13
    Caption = 
      'You must click on '#39#39'Change'#39#39' before you can change any details f' +
      'or this Import Configuration!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ToolBar2: TToolBar
    Left = 0
    Top = 0
    Width = 661
    Height = 29
    BorderWidth = 1
    ButtonHeight = 24
    ButtonWidth = 67
    Caption = 'ToolBar1'
    Color = clSilver
    EdgeBorders = [ebTop, ebBottom]
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Indent = 4
    ParentColor = False
    ParentFont = False
    ShowCaptions = True
    TabOrder = 1
    Wrapable = False
    object ExitBtn: TToolButton
      Left = 4
      Top = 0
      Caption = 'E&xit'
      ImageIndex = 8
      OnClick = ExitBtnClick
    end
    object ToolButton5: TToolButton
      Left = 71
      Top = 0
      Width = 16
      Caption = 'ToolButton12'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object FirstBtn: TToolButton
      Left = 87
      Top = 0
      Hint = 'First'
      AutoSize = True
      Caption = '||<<  &First'
      ImageIndex = 0
      OnClick = FirstBtnClick
    end
    object PriorBtn: TToolButton
      Left = 149
      Top = 0
      Hint = 'Prior'
      AutoSize = True
      Caption = '<< &Prior'
      ImageIndex = 3
      OnClick = PriorBtnClick
    end
    object NextBtn: TToolButton
      Left = 205
      Top = 0
      Hint = 'Next'
      AutoSize = True
      Caption = '&Next >>'
      ImageIndex = 2
      OnClick = NextBtnClick
    end
    object LastBtn: TToolButton
      Left = 260
      Top = 0
      Hint = 'Last'
      AutoSize = True
      Caption = '&Last >>||'
      ImageIndex = 1
      OnClick = LastBtnClick
    end
    object ToolButton15: TToolButton
      Left = 319
      Top = 0
      Width = 16
      Caption = 'ToolButton8'
      ImageIndex = 5
      Style = tbsSeparator
    end
    object AddBtn: TToolButton
      Left = 335
      Top = 0
      Caption = 'Add'
      ImageIndex = 9
      OnClick = AddBtnClick
    end
    object ChangeBtn: TToolButton
      Left = 402
      Top = 0
      Hint = 'Edit'
      AutoSize = True
      Caption = 'C&hange'
      ImageIndex = 6
      OnClick = ChangeBtnClick
    end
    object SaveBtn: TToolButton
      Left = 460
      Top = 0
      Hint = 'Post'
      AutoSize = True
      Caption = '&Save'
      Enabled = False
      ImageIndex = 10
      OnClick = SaveBtnClick
    end
    object CancelBtn: TToolButton
      Left = 503
      Top = 0
      Hint = 'Cancel'
      Caption = '&Cancel'
      Enabled = False
      ImageIndex = 7
      OnClick = CancelBtnClick
    end
    object DeleteBtn: TToolButton
      Left = 570
      Top = 0
      Caption = 'Delete'
      ImageIndex = 8
      OnClick = DeleteBtnClick
    end
  end
  object DBGrid14: TDBGrid
    Tag = -1
    Left = 7
    Top = 40
    Width = 169
    Height = 273
    DataSource = AccsDataModule.BankCSVDefaults
    Options = [dgTitles, dgIndicator, dgColLines, dgRowLines]
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'BankName'
        Title.Caption = 'Source Bank'
        Width = 148
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 204
    Top = 74
    Width = 441
    Height = 430
    TabOrder = 2
    object Label1: TLabel
      Left = 24
      Top = 56
      Width = 49
      Height = 13
      Caption = 'Delimiter - '
    end
    object Label2: TLabel
      Left = 24
      Top = 82
      Width = 101
      Height = 13
      Caption = 'No of Header Lines - '
    end
    object Label3: TLabel
      Left = 24
      Top = 108
      Width = 87
      Height = 13
      Caption = 'Date Column No - '
    end
    object Label4: TLabel
      Left = 24
      Top = 145
      Width = 91
      Height = 13
      Caption = 'Detail Column No - '
    end
    object Label5: TLabel
      Left = 24
      Top = 237
      Width = 89
      Height = 13
      Caption = 'Debit Column No - '
    end
    object Label6: TLabel
      Left = 24
      Top = 263
      Width = 91
      Height = 13
      Caption = 'Credit Column No - '
    end
    object Label7: TLabel
      Left = 24
      Top = 289
      Width = 103
      Height = 13
      Caption = 'Balance Column No - '
    end
    object Label8: TLabel
      Left = 24
      Top = 315
      Width = 89
      Height = 13
      Caption = 'Cheque Identifier - '
    end
    object Label9: TLabel
      Left = 24
      Top = 341
      Width = 102
      Height = 13
      Caption = 'Lodgement Identifier -'
    end
    object Label21: TLabel
      Left = 24
      Top = 16
      Width = 110
      Height = 13
      Caption = 'Bank File Format Name'
    end
    object Label11: TLabel
      Left = 221
      Top = 263
      Width = 203
      Height = 13
      Caption = '(Leave blank if credit/debit is not specified)'
    end
    object Label12: TLabel
      Left = 24
      Top = 171
      Width = 135
      Height = 13
      Caption = '1st Extra Detail Column No - '
    end
    object Label13: TLabel
      Left = 24
      Top = 197
      Width = 139
      Height = 13
      Caption = '2nd Extra Detail Column No - '
    end
    object lDebCredIndicColumn: TLabel
      Left = 24
      Top = 396
      Width = 139
      Height = 13
      Caption = 'Debit/Credit Indicator Column'
    end
    object DBEdit1: TDBEdit
      Left = 170
      Top = 52
      Width = 121
      Height = 21
      AutoSize = False
      DataField = 'delimiter'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 1
    end
    object DBEdit2: TDBEdit
      Left = 170
      Top = 104
      Width = 49
      Height = 21
      AutoSize = False
      DataField = 'Datefieldno'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 3
    end
    object DBEdit3: TDBEdit
      Left = 170
      Top = 141
      Width = 49
      Height = 21
      AutoSize = False
      DataField = 'Detailfieldno'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 4
    end
    object DBEdit4: TDBEdit
      Left = 170
      Top = 233
      Width = 49
      Height = 21
      AutoSize = False
      DataField = 'debitfieldno'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 5
    end
    object DBEdit5: TDBEdit
      Left = 170
      Top = 259
      Width = 49
      Height = 21
      AutoSize = False
      DataField = 'creditfieldno'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 6
    end
    object DBEdit6: TDBEdit
      Left = 170
      Top = 285
      Width = 49
      Height = 21
      AutoSize = False
      DataField = 'balancefieldno'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 7
    end
    object DBEdit7: TDBEdit
      Left = 170
      Top = 78
      Width = 49
      Height = 21
      DataField = 'headerlines'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 2
    end
    object DBEdit8: TDBEdit
      Left = 170
      Top = 311
      Width = 193
      Height = 21
      DataField = 'chequeidentifier'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 8
    end
    object DBEdit9: TDBEdit
      Left = 170
      Top = 337
      Width = 193
      Height = 21
      DataField = 'lodgementidentifier'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 9
    end
    object ImportFileName: TDBEdit
      Left = 170
      Top = 12
      Width = 233
      Height = 21
      DataField = 'BankName'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 0
    end
    object DBEdit11: TDBEdit
      Left = 170
      Top = 167
      Width = 49
      Height = 21
      AutoSize = False
      DataField = 'ExtraDetailField1No'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 10
    end
    object DBEdit12: TDBEdit
      Left = 170
      Top = 193
      Width = 49
      Height = 21
      AutoSize = False
      DataField = 'ExtraDetailField2No'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 11
    end
    object dbDebCredIndicColumn: TDBEdit
      Left = 172
      Top = 392
      Width = 49
      Height = 21
      AutoSize = False
      DataField = 'DebCredIndicCol'
      DataSource = AccsDataModule.BankCSVDefaults
      TabOrder = 12
    end
    object dbcbAllowDebCredIndicColumn: TcxDBCheckBox
      Left = 21
      Top = 365
      Caption = 'Allow Debit/Credit Indicator Column'
      DataBinding.DataField = 'AllowDebCredIndicCol'
      DataBinding.DataSource = AccsDataModule.BankCSVDefaults
      Properties.DisplayGrayed = 'False'
      Properties.NullStyle = nssUnchecked
      Properties.OnChange = dbcbAllowDebCredIndicColumnPropertiesChange
      Style.BorderStyle = ebsFlat
      TabOrder = 13
      Width = 198
    end
    object pTotalColumn: TPanel
      Left = 236
      Top = 371
      Width = 185
      Height = 41
      TabOrder = 14
      Visible = False
      object Label10: TLabel
        Left = 6
        Top = 14
        Width = 99
        Height = 13
        Caption = 'Total Column Count -'
        Enabled = False
        Visible = False
      end
      object DBEdit10: TDBEdit
        Left = 124
        Top = 10
        Width = 49
        Height = 25
        DataField = 'fieldcount'
        DataSource = AccsDataModule.BankCSVDefaults
        Enabled = False
        TabOrder = 0
        Visible = False
      end
    end
  end
end
