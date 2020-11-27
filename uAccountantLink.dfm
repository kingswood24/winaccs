object fmAccountantLink: TfmAccountantLink
  Left = 388
  Top = 249
  BorderStyle = bsDialog
  Caption = 'Accountant Link'
  ClientHeight = 188
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 25
  object pAccountantListing: TPanel
    Left = 18
    Top = 12
    Width = 491
    Height = 159
    BevelOuter = bvNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Visible = False
    object btnOK: TcxButton
      Left = 302
      Top = 116
      Width = 85
      Height = 29
      Caption = 'OK'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnOKClick
      LookAndFeel.Kind = lfOffice11
    end
    object btnCancel: TcxButton
      Left = 390
      Top = 116
      Width = 83
      Height = 29
      Caption = 'Cancel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
      LookAndFeel.Kind = lfOffice11
    end
    object cmboAccountant: TcxExtLookupComboBox
      Left = 18
      Top = 58
      ParentFont = False
      Properties.DropDownAutoSize = True
      Properties.DropDownListStyle = lsFixedList
      Properties.DropDownSizeable = True
      Properties.DropDownWidth = 400
      Properties.ImmediatePost = True
      Properties.IncrementalFiltering = False
      Properties.View = AccountantListingTableView
      Properties.KeyFieldNames = 'AccountantAccessKey'
      Properties.ListFieldItem = AccountantListingTableViewName
      Properties.Revertable = True
      Properties.OnEditValueChanged = cmboAccountantPropertiesEditValueChanged
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 2
      Width = 457
    end
    object lHeader: TcxLabel
      Left = 16
      Top = 30
      Caption = 'Select your accountant from the drop down list below '
      ParentFont = False
      Style.Font.Charset = ANSI_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -15
      Style.Font.Name = 'Segoe UI'
      Style.Font.Style = []
      Style.IsFontAssigned = True
    end
    object btnRemoveAccountantLink: TcxButton
      Left = 18
      Top = 116
      Width = 181
      Height = 29
      Caption = 'Remove Accountant Link'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = btnRemoveAccountantLinkClick
      LookAndFeel.Kind = lfOffice11
    end
  end
  object lStatus: TcxLabel
    Left = 0
    Top = 0
    Align = alClient
    Caption = 'Retrieving Accountant Listing, please wait... '#13#10#13#10#13#10
    ParentColor = False
    ParentFont = False
    Properties.Alignment.Horz = taCenter
    Properties.Alignment.Vert = taVCenter
    Style.BorderStyle = ebsFlat
    Style.Color = clWhite
    Style.Edges = []
    Style.Font.Charset = ANSI_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -16
    Style.Font.Name = 'Segoe UI'
    Style.Font.Style = []
    Style.Shadow = False
    Style.TextColor = clGreen
    Style.TextStyle = [fsBold]
    Style.IsFontAssigned = True
  end
  object cxGrid1: TcxGrid
    Left = 20
    Top = 214
    Width = 489
    Height = 147
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Visible = False
    LookAndFeel.Kind = lfFlat
    LookAndFeel.NativeStyle = False
    object AccountantListingTableView: TcxGridDBTableView
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
      DataController.DataSource = dsAccountantListingData
      DataController.KeyFieldNames = 'AccountantAccessKey'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnFiltering = False
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnHidingOnGrouping = False
      OptionsCustomize.ColumnHorzSizing = False
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.CellSelect = False
      OptionsView.FocusRect = False
      OptionsView.DataRowHeight = 26
      OptionsView.GridLines = glHorizontal
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 36
      OptionsView.Indicator = True
      OptionsView.IndicatorWidth = 10
      object AccountantListingTableViewRecId: TcxGridDBColumn
        DataBinding.FieldName = 'RecId'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
      object AccountantListingTableViewName: TcxGridDBColumn
        DataBinding.FieldName = 'Name'
        HeaderAlignmentVert = vaCenter
        Width = 170
      end
      object AccountantListingTableViewAddress1: TcxGridDBColumn
        DataBinding.FieldName = 'Address1'
        HeaderAlignmentVert = vaCenter
        Width = 145
      end
      object AccountantListingTableViewAddress2: TcxGridDBColumn
        DataBinding.FieldName = 'Address2'
        HeaderAlignmentVert = vaCenter
        Width = 145
      end
      object AccountantListingTableViewAddress3: TcxGridDBColumn
        DataBinding.FieldName = 'Address3'
        HeaderAlignmentVert = vaCenter
        Width = 145
      end
      object AccountantListingTableViewAddress4: TcxGridDBColumn
        DataBinding.FieldName = 'Address4'
        HeaderAlignmentVert = vaCenter
        Width = 145
      end
      object AccountantListingTableViewTelNo: TcxGridDBColumn
        DataBinding.FieldName = 'TelNo'
        HeaderAlignmentVert = vaCenter
        Width = 145
      end
      object AccountantListingTableViewAccountantId: TcxGridDBColumn
        DataBinding.FieldName = 'AccountantId'
        Visible = False
        HeaderAlignmentVert = vaCenter
        Hidden = True
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = AccountantListingTableView
    end
  end
  object btnClose: TcxButton
    Left = 408
    Top = 132
    Width = 89
    Height = 29
    Caption = 'Close'
    Default = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 3
    LookAndFeel.NativeStyle = True
  end
  object DownloadTimer: TTimer
    Interval = 500
    OnTimer = DownloadTimerTimer
    Left = 16
    Top = 12
  end
  object AccountantListingData: TdxMemData
    Indexes = <>
    SortOptions = []
    Left = 502
    Top = 160
    object AccountantListingDataName: TStringField
      FieldName = 'Name'
      Size = 50
    end
    object AccountantListingDataAddress1: TStringField
      DisplayLabel = 'Address 1'
      FieldName = 'Address1'
      Size = 45
    end
    object AccountantListingDataAddress2: TStringField
      DisplayLabel = 'Address 2'
      FieldName = 'Address2'
      Size = 45
    end
    object AccountantListingDataAddress3: TStringField
      DisplayLabel = 'Address 3'
      FieldName = 'Address3'
      Size = 45
    end
    object AccountantListingDataAddress4: TStringField
      DisplayLabel = 'Address 4'
      FieldName = 'Address4'
      Size = 45
    end
    object AccountantListingDataTelNo: TStringField
      DisplayLabel = 'Telephone No.'
      FieldName = 'TelNo'
      Size = 30
    end
    object AccountantListingDataAccountantAccessKey: TStringField
      FieldName = 'AccountantAccessKey'
      Visible = False
      Size = 50
    end
  end
  object dsAccountantListingData: TDataSource
    DataSet = AccountantListingData
    Left = 506
    Top = 134
  end
end
