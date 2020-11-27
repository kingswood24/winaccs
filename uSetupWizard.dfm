object fmSetupWizard: TfmSetupWizard
  Left = 471
  Top = 305
  Width = 687
  Height = 430
  ActiveControl = cmboFinancialYears
  Caption = 'Accounts Setup'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pcSetupWizard: TcxPageControl
    Left = 24
    Top = 24
    Width = 619
    Height = 293
    ActivePage = tsGettingStarted
    HideTabs = True
    ShowFrame = True
    Style = 9
    TabHeight = 28
    TabOrder = 0
    ClientRectBottom = 292
    ClientRectLeft = 1
    ClientRectRight = 618
    ClientRectTop = 1
    object tsGettingStarted: TcxTabSheet
      Caption = 'Getting Started'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 0
      ParentFont = False
      object btnUpdate: TcxButton
        Left = 308
        Top = 184
        Width = 95
        Height = 32
        Caption = 'Update'
        Enabled = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnUpdateClick
        LookAndFeel.NativeStyle = True
      end
      object cxLabel1: TcxLabel
        Left = 68
        Top = 64
        AutoSize = False
        Caption = 'Current Financial Year:'
        Properties.Alignment.Horz = taRightJustify
        Height = 20
        Width = 230
      end
      object cxLabel2: TcxLabel
        Left = 62
        Top = 6
        AutoSize = False
        Caption = 
          'Please specify the following information to begin working with t' +
          'he Kingswood Accounts program.'
        ParentFont = False
        ParentShowHint = False
        Properties.Alignment.Horz = taCenter
        Properties.WordWrap = True
        ShowHint = False
        Style.Font.Charset = ANSI_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        Height = 40
        Width = 491
      end
      object cmboFinancialYears: TcxComboBox
        Left = 308
        Top = 64
        Properties.Alignment.Horz = taRightJustify
        Properties.DropDownListStyle = lsFixedList
        Properties.OnEditValueChanged = seCurrentBalancePropertiesChange
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 0
        Width = 95
      end
      object cmboFinancialMonth: TcxComboBox
        Left = 308
        Top = 100
        Properties.Alignment.Horz = taRightJustify
        Properties.DropDownListStyle = lsFixedList
        Properties.OnEditValueChanged = seCurrentBalancePropertiesChange
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 1
        Width = 95
      end
      object cxLabel3: TcxLabel
        Left = 68
        Top = 100
        AutoSize = False
        Caption = 'Start Month of Financial Year:'
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Style.Font.Charset = ANSI_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        Height = 20
        Width = 230
      end
      object cxLabel4: TcxLabel
        Left = 68
        Top = 136
        AutoSize = False
        Caption = 'Bank Balance (at data entry start date):'
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Style.Font.Charset = ANSI_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        Height = 20
        Width = 230
      end
      object seCurrentBalance: TcxSpinEdit
        Left = 308
        Top = 136
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.AssignedValues.EditFormat = True
        Properties.DisplayFormat = '0.00; -0.00'
        Properties.ImmediatePost = True
        Properties.ValueType = vtFloat
        Properties.OnChange = seCurrentBalancePropertiesChange
        Style.Font.Charset = ANSI_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
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
        Width = 95
      end
      object lbInfo: TcxLabel
        Left = 70
        Top = 228
        AutoSize = False
        Caption = 
          'You are now ready to start entering transactions in '#13#10'the '#39'Enter' +
          ' Cashbook Transaction'#39' section on the main screen.'#13#10'Click the '#39'C' +
          'lose'#39' button to go back to the main screen.'
        ParentFont = False
        ParentShowHint = False
        Properties.Alignment.Horz = taCenter
        Properties.WordWrap = True
        ShowHint = False
        Style.Font.Charset = ANSI_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.TextColor = clGreen
        Style.IsFontAssigned = True
        Height = 55
        Width = 491
      end
    end
  end
  object btnClose: TcxButton
    Left = 552
    Top = 339
    Width = 90
    Height = 32
    Caption = 'Close'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 1
  end
end
