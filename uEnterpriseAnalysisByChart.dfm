inherited fmEnterpriseAnalysisByChart: TfmEnterpriseAnalysisByChart
  Left = 377
  Top = 210
  Width = 949
  Height = 789
  Caption = 'Enterprise Analysis By Chart'
  OldCreateOrder = True
  Position = poDesigned
  WindowState = wsMaximized
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  inherited StatusBar: TdxStatusBar
    Top = 731
    Width = 933
    Visible = False
  end
  object pChartContainer: TPanel [1]
    Left = 0
    Top = 52
    Width = 933
    Height = 679
    Align = alClient
    TabOrder = 5
    object Chart3Container: TPanel
      Left = 1
      Top = 232
      Width = 931
      Height = 231
      Align = alTop
      Caption = 'Chart3Container'
      TabOrder = 0
      object DBChart3: TDBChart
        Left = 1
        Top = 1
        Width = 614
        Height = 229
        AllowPanning = pmNone
        BackWall.Gradient.EndColor = clWhite
        BackWall.Gradient.StartColor = 15395562
        BackWall.Gradient.Visible = True
        BackWall.Transparent = False
        Border.Color = 14645801
        Border.Width = 7
        BottomWall.Gradient.EndColor = 16580349
        BottomWall.Gradient.StartColor = 3114493
        Foot.Font.Name = 'Verdana'
        Gradient.EndColor = clWhite
        Gradient.MidColor = 15395562
        Gradient.StartColor = 15395562
        Gradient.Visible = True
        LeftWall.Color = 14745599
        LeftWall.Gradient.EndColor = 2413052
        LeftWall.Gradient.StartColor = 900220
        RightWall.Color = 14745599
        SubFoot.Font.Name = 'Verdana'
        SubTitle.Font.Name = 'Verdana'
        Title.Color = clBlack
        Title.Font.Color = clGray
        Title.Font.Height = -13
        Title.Font.Name = 'Verdana'
        Title.Font.Style = [fsBold]
        Title.Frame.Color = 10083835
        Title.Frame.Width = 2
        Title.Shadow.HorizSize = 4
        Title.Shadow.Transparency = 70
        Title.Shadow.VertSize = 4
        Title.Text.Strings = (
          '')
        BottomAxis.Axis.Color = 4210752
        BottomAxis.Grid.Color = 11119017
        BottomAxis.LabelsFont.Name = 'Verdana'
        BottomAxis.MinorGrid.Color = 15066597
        BottomAxis.MinorTicks.Color = clBlack
        BottomAxis.TicksInner.Color = 11119017
        BottomAxis.Title.Font.Name = 'Verdana'
        DepthAxis.Axis.Color = 4210752
        DepthAxis.Grid.Color = 11119017
        DepthAxis.LabelsFont.Name = 'Verdana'
        DepthAxis.MinorTicks.Color = clBlack
        DepthAxis.TicksInner.Color = 11119017
        DepthAxis.Title.Font.Name = 'Verdana'
        DepthTopAxis.Axis.Color = 4210752
        DepthTopAxis.Grid.Color = 11119017
        DepthTopAxis.LabelsFont.Name = 'Verdana'
        DepthTopAxis.MinorTicks.Color = clBlack
        DepthTopAxis.TicksInner.Color = 11119017
        DepthTopAxis.Title.Font.Name = 'Verdana'
        LeftAxis.Axis.Color = 4210752
        LeftAxis.Grid.Color = 11119017
        LeftAxis.LabelsFont.Name = 'Verdana'
        LeftAxis.MinorTicks.Color = clBlack
        LeftAxis.TicksInner.Color = 11119017
        LeftAxis.Title.Font.Name = 'Verdana'
        Legend.Alignment = laTop
        Legend.DividingLines.Color = clSilver
        Legend.Font.Color = 6553600
        Legend.Font.Name = 'Verdana'
        Legend.Gradient.Direction = gdTopBottom
        Legend.Gradient.EndColor = clYellow
        Legend.Gradient.StartColor = clWhite
        Legend.Shadow.Color = 8553090
        Legend.Shadow.HorizSize = 1
        Legend.Shadow.SmoothBlur = -50
        Legend.Shadow.VertSize = 1
        Legend.Symbol.Squared = True
        RightAxis.Axis.Color = 4210752
        RightAxis.Grid.Color = 11119017
        RightAxis.LabelsFont.Name = 'Verdana'
        RightAxis.MinorTicks.Color = clBlack
        RightAxis.TicksInner.Color = 11119017
        RightAxis.Title.Font.Name = 'Verdana'
        Shadow.Color = clBlack
        TopAxis.Axis.Color = 4210752
        TopAxis.Grid.Color = 11119017
        TopAxis.LabelsFont.Name = 'Verdana'
        TopAxis.MinorGrid.Color = 15066597
        TopAxis.MinorTicks.Color = clBlack
        TopAxis.TicksInner.Color = 11119017
        TopAxis.Title.Font.Name = 'Verdana'
        View3D = False
        Zoom.Allow = False
        OnGetAxisLabel = DBChart1GetAxisLabel
        Align = alClient
        TabOrder = 0
        PrintMargins = (
          15
          26
          15
          26)
        ColorPaletteIndex = 1
        object GridBandTool8: TGridBandTool
          Band1.Color = 15329769
          Band2.Color = clWhite
          AxisID = 2
        end
        object GridBandTool9: TGridBandTool
          Band1.Color = 15329769
          Band2.Color = clWhite
          AxisID = 2
        end
      end
      object PieChart3: TChart
        Left = 615
        Top = 1
        Width = 315
        Height = 229
        BackWall.Gradient.EndColor = clWhite
        BackWall.Gradient.StartColor = 15395562
        BackWall.Gradient.Visible = True
        BackWall.Transparent = False
        Foot.Font.Name = 'Verdana'
        Gradient.EndColor = clWhite
        Gradient.MidColor = 15395562
        Gradient.StartColor = 15395562
        Gradient.Visible = True
        LeftWall.Color = 14745599
        Legend.Font.Name = 'Verdana'
        Legend.Visible = False
        RightWall.Color = 14745599
        SubFoot.Font.Name = 'Verdana'
        SubTitle.Font.Name = 'Verdana'
        Title.Font.Color = clGray
        Title.Font.Name = 'Verdana'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'Showing This Year Enterprise '
          'Expenditure Analysis')
        BottomAxis.Axis.Color = 4210752
        BottomAxis.Grid.Color = 11119017
        BottomAxis.LabelsFont.Name = 'Verdana'
        BottomAxis.TicksInner.Color = 11119017
        BottomAxis.Title.Font.Name = 'Verdana'
        DepthAxis.Axis.Color = 4210752
        DepthAxis.Grid.Color = 11119017
        DepthAxis.LabelsFont.Name = 'Verdana'
        DepthAxis.TicksInner.Color = 11119017
        DepthAxis.Title.Font.Name = 'Verdana'
        DepthTopAxis.Axis.Color = 4210752
        DepthTopAxis.Grid.Color = 11119017
        DepthTopAxis.LabelsFont.Name = 'Verdana'
        DepthTopAxis.TicksInner.Color = 11119017
        DepthTopAxis.Title.Font.Name = 'Verdana'
        LeftAxis.Axis.Color = 4210752
        LeftAxis.Grid.Color = 11119017
        LeftAxis.LabelsFont.Name = 'Verdana'
        LeftAxis.TicksInner.Color = 11119017
        LeftAxis.Title.Font.Name = 'Verdana'
        RightAxis.Axis.Color = 4210752
        RightAxis.Grid.Color = 11119017
        RightAxis.LabelsFont.Name = 'Verdana'
        RightAxis.TicksInner.Color = 11119017
        RightAxis.Title.Font.Name = 'Verdana'
        TopAxis.Axis.Color = 4210752
        TopAxis.Grid.Color = 11119017
        TopAxis.LabelsFont.Name = 'Verdana'
        TopAxis.TicksInner.Color = 11119017
        TopAxis.Title.Font.Name = 'Verdana'
        View3DOptions.Elevation = 315
        View3DOptions.Orthogonal = False
        View3DOptions.Perspective = 0
        View3DOptions.Rotation = 360
        View3DOptions.Zoom = 106
        Align = alRight
        TabOrder = 1
        ColorPaletteIndex = 10
        object MarginPieSeries3: TPieSeries
          Marks.Arrow.Width = 2
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Draw3D = True
          Marks.Callout.Style = psTriangle
          Marks.Callout.Arrow.Width = 2
          Marks.Callout.Arrow.Visible = True
          Marks.BackColor = clWhite
          Marks.Color = clWhite
          Marks.Font.Name = 'Verdana'
          Marks.Frame.Visible = False
          Marks.Gradient.Direction = gdTopBottom
          Marks.Gradient.EndColor = 2152289
          Marks.Gradient.MidColor = 7548915
          Marks.Gradient.StartColor = 10109259
          Marks.Shadow.Color = 13882323
          Marks.Shadow.HorizSize = 2
          Marks.Shadow.SmoothBlur = -54
          Marks.Shadow.VertSize = 2
          Marks.Symbol.Visible = True
          Marks.Visible = True
          Title = 'Enterprise Income Analysis'
          Gradient.Direction = gdRadial
          OtherSlice.Legend.Visible = False
          PieValues.Name = 'Pie'
          PieValues.Order = loNone
        end
        object AntiAliasTool2: TAntiAliasTool
        end
      end
    end
    object Chart2Container: TPanel
      Left = 1
      Top = 1
      Width = 931
      Height = 231
      Align = alTop
      Caption = 'Chart2Container'
      TabOrder = 1
      object DBChart2: TDBChart
        Left = 1
        Top = 1
        Width = 614
        Height = 229
        AllowPanning = pmNone
        BackWall.Gradient.EndColor = clWhite
        BackWall.Gradient.StartColor = 15395562
        BackWall.Gradient.Visible = True
        BackWall.Transparent = False
        Border.Color = 14645801
        Border.Width = 7
        BottomWall.Gradient.EndColor = 16580349
        BottomWall.Gradient.StartColor = 3114493
        Foot.Font.Name = 'Verdana'
        Gradient.EndColor = clWhite
        Gradient.MidColor = 15395562
        Gradient.StartColor = 15395562
        Gradient.Visible = True
        LeftWall.Color = 14745599
        LeftWall.Gradient.EndColor = 2413052
        LeftWall.Gradient.StartColor = 900220
        RightWall.Color = 14745599
        SubFoot.Font.Name = 'Verdana'
        SubTitle.Font.Name = 'Verdana'
        Title.Color = clBlack
        Title.Font.Color = clGray
        Title.Font.Height = -13
        Title.Font.Name = 'Verdana'
        Title.Font.Style = [fsBold]
        Title.Frame.Color = 10083835
        Title.Frame.Width = 2
        Title.Shadow.HorizSize = 4
        Title.Shadow.Transparency = 70
        Title.Shadow.VertSize = 4
        Title.Text.Strings = (
          '')
        BottomAxis.Axis.Color = 4210752
        BottomAxis.Grid.Color = 11119017
        BottomAxis.LabelsFont.Name = 'Verdana'
        BottomAxis.MinorGrid.Color = 15066597
        BottomAxis.MinorTicks.Color = clBlack
        BottomAxis.TicksInner.Color = 11119017
        BottomAxis.Title.Font.Name = 'Verdana'
        DepthAxis.Axis.Color = 4210752
        DepthAxis.Grid.Color = 11119017
        DepthAxis.LabelsFont.Name = 'Verdana'
        DepthAxis.MinorTicks.Color = clBlack
        DepthAxis.TicksInner.Color = 11119017
        DepthAxis.Title.Font.Name = 'Verdana'
        DepthTopAxis.Axis.Color = 4210752
        DepthTopAxis.Grid.Color = 11119017
        DepthTopAxis.LabelsFont.Name = 'Verdana'
        DepthTopAxis.MinorTicks.Color = clBlack
        DepthTopAxis.TicksInner.Color = 11119017
        DepthTopAxis.Title.Font.Name = 'Verdana'
        LeftAxis.Axis.Color = 4210752
        LeftAxis.Grid.Color = 11119017
        LeftAxis.LabelsFont.Name = 'Verdana'
        LeftAxis.MinorTicks.Color = clBlack
        LeftAxis.TicksInner.Color = 11119017
        LeftAxis.Title.Font.Name = 'Verdana'
        Legend.Color = clInfoBk
        Legend.DividingLines.Color = clSilver
        Legend.Font.Color = 6553600
        Legend.Font.Name = 'Verdana'
        Legend.Gradient.Direction = gdTopBottom
        Legend.Gradient.EndColor = clYellow
        Legend.Gradient.StartColor = clWhite
        Legend.Shadow.Color = clGray
        Legend.Symbol.Squared = True
        Legend.Visible = False
        RightAxis.Axis.Color = 4210752
        RightAxis.Grid.Color = 11119017
        RightAxis.LabelsFont.Name = 'Verdana'
        RightAxis.MinorTicks.Color = clBlack
        RightAxis.TicksInner.Color = 11119017
        RightAxis.Title.Font.Name = 'Verdana'
        Shadow.Color = clBlack
        TopAxis.Axis.Color = 4210752
        TopAxis.Grid.Color = 11119017
        TopAxis.LabelsFont.Name = 'Verdana'
        TopAxis.MinorGrid.Color = 15066597
        TopAxis.MinorTicks.Color = clBlack
        TopAxis.TicksInner.Color = 11119017
        TopAxis.Title.Font.Name = 'Verdana'
        View3D = False
        Zoom.Allow = False
        OnGetAxisLabel = DBChart1GetAxisLabel
        Align = alClient
        TabOrder = 0
        PrintMargins = (
          15
          26
          15
          26)
        ColorPaletteIndex = 1
        object GridBandTool5: TGridBandTool
          Band1.Color = 15329769
          Band2.Color = clWhite
          AxisID = 2
        end
        object GridBandTool6: TGridBandTool
          Band1.Color = 15329769
          Band2.Color = clWhite
          AxisID = 2
        end
      end
      object PieChart2: TChart
        Left = 615
        Top = 1
        Width = 315
        Height = 229
        BackWall.Gradient.EndColor = clWhite
        BackWall.Gradient.StartColor = 15395562
        BackWall.Gradient.Visible = True
        BackWall.Transparent = False
        Foot.Font.Name = 'Verdana'
        Gradient.EndColor = clWhite
        Gradient.MidColor = 15395562
        Gradient.StartColor = 15395562
        Gradient.Visible = True
        LeftWall.Color = 14745599
        Legend.Font.Name = 'Verdana'
        Legend.Visible = False
        RightWall.Color = 14745599
        SubFoot.Font.Name = 'Verdana'
        SubTitle.Font.Name = 'Verdana'
        Title.Font.Color = clGray
        Title.Font.Name = 'Verdana'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'Showing This Year Enterprise '
          'Income Analysis')
        BottomAxis.Axis.Color = 4210752
        BottomAxis.Grid.Color = 11119017
        BottomAxis.LabelsFont.Name = 'Verdana'
        BottomAxis.TicksInner.Color = 11119017
        BottomAxis.Title.Font.Name = 'Verdana'
        DepthAxis.Axis.Color = 4210752
        DepthAxis.Grid.Color = 11119017
        DepthAxis.LabelsFont.Name = 'Verdana'
        DepthAxis.TicksInner.Color = 11119017
        DepthAxis.Title.Font.Name = 'Verdana'
        DepthTopAxis.Axis.Color = 4210752
        DepthTopAxis.Grid.Color = 11119017
        DepthTopAxis.LabelsFont.Name = 'Verdana'
        DepthTopAxis.TicksInner.Color = 11119017
        DepthTopAxis.Title.Font.Name = 'Verdana'
        LeftAxis.Axis.Color = 4210752
        LeftAxis.Grid.Color = 11119017
        LeftAxis.LabelsFont.Name = 'Verdana'
        LeftAxis.TicksInner.Color = 11119017
        LeftAxis.Title.Font.Name = 'Verdana'
        RightAxis.Axis.Color = 4210752
        RightAxis.Grid.Color = 11119017
        RightAxis.LabelsFont.Name = 'Verdana'
        RightAxis.TicksInner.Color = 11119017
        RightAxis.Title.Font.Name = 'Verdana'
        TopAxis.Axis.Color = 4210752
        TopAxis.Grid.Color = 11119017
        TopAxis.LabelsFont.Name = 'Verdana'
        TopAxis.TicksInner.Color = 11119017
        TopAxis.Title.Font.Name = 'Verdana'
        View3DOptions.Elevation = 315
        View3DOptions.Orthogonal = False
        View3DOptions.Perspective = 0
        View3DOptions.Rotation = 360
        View3DOptions.Zoom = 106
        Align = alRight
        TabOrder = 1
        ColorPaletteIndex = 10
        object MarginPieSeries2: TPieSeries
          Marks.Arrow.Width = 2
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Draw3D = True
          Marks.Callout.Style = psDownTriangle
          Marks.Callout.Arrow.Width = 2
          Marks.Callout.Arrow.Visible = True
          Marks.Callout.ArrowHeadSize = 12
          Marks.BackColor = clWhite
          Marks.Color = clWhite
          Marks.Font.Name = 'Verdana'
          Marks.Frame.Visible = False
          Marks.Gradient.Direction = gdTopBottom
          Marks.Gradient.EndColor = 2152289
          Marks.Gradient.MidColor = 7548915
          Marks.Gradient.StartColor = 10109259
          Marks.Shadow.Color = 13882323
          Marks.Shadow.HorizSize = 2
          Marks.Shadow.SmoothBlur = -54
          Marks.Shadow.VertSize = 2
          Marks.Symbol.Visible = True
          Marks.Visible = True
          Title = 'Enterprise Income Analysis'
          Gradient.Direction = gdRadial
          OtherSlice.Legend.Visible = False
          PieValues.Name = 'Pie'
          PieValues.Order = loNone
        end
        object AntiAliasTool1: TAntiAliasTool
        end
      end
    end
    object Chart1Container: TPanel
      Left = 1
      Top = 463
      Width = 931
      Height = 215
      Align = alClient
      Caption = 'Chart1Container'
      TabOrder = 2
      object DBChart1: TDBChart
        Left = 1
        Top = 1
        Width = 614
        Height = 213
        AllowPanning = pmNone
        BackWall.Gradient.EndColor = clWhite
        BackWall.Gradient.StartColor = 15395562
        BackWall.Gradient.Visible = True
        BackWall.Transparent = False
        Border.Color = 14645801
        Border.Width = 7
        BottomWall.Gradient.EndColor = 16580349
        BottomWall.Gradient.StartColor = 3114493
        Foot.Font.Name = 'Verdana'
        Gradient.EndColor = clWhite
        Gradient.MidColor = 15395562
        Gradient.StartColor = 15395562
        Gradient.Visible = True
        LeftWall.Color = 14745599
        LeftWall.Gradient.EndColor = 2413052
        LeftWall.Gradient.StartColor = 900220
        RightWall.Color = 14745599
        SubFoot.Font.Name = 'Verdana'
        SubTitle.Font.Name = 'Verdana'
        Title.Color = clBlack
        Title.Font.Color = clGray
        Title.Font.Height = -13
        Title.Font.Name = 'Verdana'
        Title.Font.Style = [fsBold]
        Title.Frame.Color = 10083835
        Title.Frame.Width = 2
        Title.Shadow.HorizSize = 4
        Title.Shadow.Transparency = 70
        Title.Shadow.VertSize = 4
        Title.Text.Strings = (
          '')
        BottomAxis.Axis.Color = 4210752
        BottomAxis.Grid.Color = 11119017
        BottomAxis.LabelsFont.Name = 'Verdana'
        BottomAxis.MinorGrid.Color = 15066597
        BottomAxis.MinorTicks.Color = clBlack
        BottomAxis.TicksInner.Color = 11119017
        BottomAxis.Title.Font.Name = 'Verdana'
        DepthAxis.Axis.Color = 4210752
        DepthAxis.Grid.Color = 11119017
        DepthAxis.LabelsFont.Name = 'Verdana'
        DepthAxis.MinorTicks.Color = clBlack
        DepthAxis.TicksInner.Color = 11119017
        DepthAxis.Title.Font.Name = 'Verdana'
        DepthTopAxis.Axis.Color = 4210752
        DepthTopAxis.Grid.Color = 11119017
        DepthTopAxis.LabelsFont.Name = 'Verdana'
        DepthTopAxis.MinorTicks.Color = clBlack
        DepthTopAxis.TicksInner.Color = 11119017
        DepthTopAxis.Title.Font.Name = 'Verdana'
        LeftAxis.Axis.Color = 4210752
        LeftAxis.Grid.Color = 11119017
        LeftAxis.LabelsFont.Name = 'Verdana'
        LeftAxis.MinorTicks.Color = clBlack
        LeftAxis.TicksInner.Color = 11119017
        LeftAxis.Title.Font.Name = 'Verdana'
        Legend.Alignment = laTop
        Legend.DividingLines.Color = clSilver
        Legend.Font.Color = 6553600
        Legend.Font.Name = 'Verdana'
        Legend.Gradient.Direction = gdTopBottom
        Legend.Gradient.EndColor = clYellow
        Legend.Gradient.StartColor = clWhite
        Legend.Shadow.Color = 8487297
        Legend.Shadow.HorizSize = 2
        Legend.Shadow.SmoothBlur = -36
        Legend.Shadow.VertSize = 2
        Legend.Symbol.Squared = True
        RightAxis.Axis.Color = 4210752
        RightAxis.Grid.Color = 11119017
        RightAxis.LabelsFont.Name = 'Verdana'
        RightAxis.MinorTicks.Color = clBlack
        RightAxis.TicksInner.Color = 11119017
        RightAxis.Title.Font.Name = 'Verdana'
        Shadow.Color = clBlack
        TopAxis.Axis.Color = 4210752
        TopAxis.Grid.Color = 11119017
        TopAxis.LabelsFont.Name = 'Verdana'
        TopAxis.MinorGrid.Color = 15066597
        TopAxis.MinorTicks.Color = clBlack
        TopAxis.TicksInner.Color = 11119017
        TopAxis.Title.Font.Name = 'Verdana'
        View3D = False
        Zoom.Allow = False
        OnGetAxisLabel = DBChart1GetAxisLabel
        Align = alClient
        TabOrder = 0
        PrintMargins = (
          15
          34
          15
          34)
        ColorPaletteIndex = 1
        object GridBandTool1: TGridBandTool
          Band1.Color = 15329769
          Band2.Color = clWhite
          AxisID = 2
        end
        object GridBandTool3: TGridBandTool
          Band1.Color = 15329769
          Band2.Color = clWhite
          AxisID = 2
        end
      end
      object PieChart1: TChart
        Left = 615
        Top = 1
        Width = 315
        Height = 213
        BackWall.Gradient.EndColor = clWhite
        BackWall.Gradient.StartColor = 15395562
        BackWall.Gradient.Visible = True
        BackWall.Transparent = False
        Foot.Font.Name = 'Verdana'
        Gradient.EndColor = clWhite
        Gradient.MidColor = 15395562
        Gradient.StartColor = 15395562
        Gradient.Visible = True
        LeftWall.Color = 14745599
        Legend.Font.Name = 'Verdana'
        Legend.Visible = False
        RightWall.Color = 14745599
        SubFoot.Font.Name = 'Verdana'
        SubTitle.Font.Name = 'Verdana'
        Title.Font.Color = clGray
        Title.Font.Name = 'Verdana'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'Showing This Year Enterprise '
          'Margin Analysis')
        BottomAxis.Axis.Color = 4210752
        BottomAxis.Grid.Color = 11119017
        BottomAxis.LabelsFont.Name = 'Verdana'
        BottomAxis.TicksInner.Color = 11119017
        BottomAxis.Title.Font.Name = 'Verdana'
        DepthAxis.Axis.Color = 4210752
        DepthAxis.Grid.Color = 11119017
        DepthAxis.LabelsFont.Name = 'Verdana'
        DepthAxis.TicksInner.Color = 11119017
        DepthAxis.Title.Font.Name = 'Verdana'
        DepthTopAxis.Axis.Color = 4210752
        DepthTopAxis.Grid.Color = 11119017
        DepthTopAxis.LabelsFont.Name = 'Verdana'
        DepthTopAxis.TicksInner.Color = 11119017
        DepthTopAxis.Title.Font.Name = 'Verdana'
        LeftAxis.Axis.Color = 4210752
        LeftAxis.Grid.Color = 11119017
        LeftAxis.LabelsFont.Name = 'Verdana'
        LeftAxis.TicksInner.Color = 11119017
        LeftAxis.Title.Font.Name = 'Verdana'
        RightAxis.Axis.Color = 4210752
        RightAxis.Grid.Color = 11119017
        RightAxis.LabelsFont.Name = 'Verdana'
        RightAxis.TicksInner.Color = 11119017
        RightAxis.Title.Font.Name = 'Verdana'
        TopAxis.Axis.Color = 4210752
        TopAxis.Grid.Color = 11119017
        TopAxis.LabelsFont.Name = 'Verdana'
        TopAxis.TicksInner.Color = 11119017
        TopAxis.Title.Font.Name = 'Verdana'
        View3DOptions.Elevation = 315
        View3DOptions.Orthogonal = False
        View3DOptions.Perspective = 0
        View3DOptions.Rotation = 360
        View3DOptions.Zoom = 106
        Align = alRight
        TabOrder = 1
        ColorPaletteIndex = 10
        object MarginPieSeries1: TPieSeries
          Marks.Arrow.Width = 2
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Draw3D = True
          Marks.Callout.Style = psTriangle
          Marks.Callout.Arrow.Width = 2
          Marks.Callout.Arrow.Visible = True
          Marks.BackColor = clWhite
          Marks.Color = clWhite
          Marks.Font.Name = 'Verdana'
          Marks.Frame.Visible = False
          Marks.Gradient.Direction = gdTopBottom
          Marks.Gradient.EndColor = 2152289
          Marks.Gradient.MidColor = 7548915
          Marks.Gradient.StartColor = 10109259
          Marks.Shadow.Color = 13882323
          Marks.Shadow.HorizSize = 2
          Marks.Shadow.SmoothBlur = -54
          Marks.Shadow.VertSize = 2
          Marks.Symbol.Visible = True
          Marks.Visible = True
          Title = 'Enterprise Income Analysis'
          Gradient.Direction = gdRadial
          OtherSlice.Legend.Visible = False
          PieValues.Name = 'Pie'
          PieValues.Order = loNone
        end
        object ChartTool1: TAntiAliasTool
        end
      end
    end
  end
  object DBChart5: TDBChart [2]
    Left = 442
    Top = 70
    Width = 133
    Height = 139
    BackWall.Pen.Visible = False
    BottomWall.Pen.Visible = False
    BottomWall.Size = 4
    LeftWall.Pen.Visible = False
    LeftWall.Size = 4
    Title.Alignment = taLeftJustify
    Title.Color = clInfoBk
    Title.Font.Color = clBlack
    Title.Font.Height = -13
    Title.Frame.Color = clGray
    Title.Shadow.HorizSize = 0
    Title.Shadow.VertSize = 0
    Title.Text.Strings = (
      '')
    Title.Transparent = False
    BottomAxis.Axis.Color = 4210752
    BottomAxis.Grid.Color = 13421772
    BottomAxis.Grid.Visible = False
    Frame.Visible = False
    LeftAxis.Axis.Color = 4210752
    LeftAxis.Grid.Visible = False
    Legend.Color = clInfoBk
    Legend.Frame.Color = clGray
    Legend.Frame.Visible = False
    Legend.Shadow.Color = 13421772
    View3D = False
    Color = clWhite
    TabOrder = 6
    Visible = False
    ColorPaletteIndex = 13
    object DefaultEnterpriseSeries: TLineSeries
      OnGetPointerStyle = DefaultEnterpriseSeriesGetPointerStyle
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Frame.Color = clGray
      Marks.Gradient.EndColor = 15137774
      Marks.Gradient.StartColor = clWhite
      Marks.Shadow.Color = 13421772
      Marks.Shadow.HorizSize = 2
      Marks.Shadow.SmoothBlur = -31
      Marks.Shadow.VertSize = 2
      Marks.Style = smsValue
      Marks.Visible = False
      SeriesColor = 4227327
      Title = 'DefaultEnterpriseSeries'
      LinePen.Color = 4227327
      LinePen.Width = 3
      LinePen.EndStyle = esSquare
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = True
      TreatNulls = tnIgnore
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
      Data = {02010000000000000000000000FFFFFF1F}
    end
    object GridBandTool7: TGridBandTool
      Band1.Color = 15329769
      Band2.Color = clWhite
      AxisID = 2
    end
  end
  object pEntFilter: TPanel [3]
    Left = 119
    Top = 1
    Width = 766
    Height = 48
    BevelOuter = bvNone
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    object cmboEnterprise: TcxComboBox
      Left = 13
      Top = 19
      Properties.Alignment.Vert = taVCenter
      Properties.DropDownListStyle = lsFixedList
      Properties.ItemHeight = 24
      Properties.OnEditValueChanged = cmboEnterprisePropertiesEditValueChanged
      Style.BorderStyle = ebsFlat
      Style.LookAndFeel.Kind = lfFlat
      Style.LookAndFeel.NativeStyle = False
      Style.TextColor = clNone
      Style.ButtonStyle = btsDefault
      Style.ButtonTransparency = ebtNone
      StyleDisabled.LookAndFeel.Kind = lfFlat
      StyleDisabled.LookAndFeel.NativeStyle = False
      StyleFocused.LookAndFeel.Kind = lfFlat
      StyleFocused.LookAndFeel.NativeStyle = False
      StyleHot.LookAndFeel.Kind = lfFlat
      StyleHot.LookAndFeel.NativeStyle = False
      TabOrder = 0
      Width = 180
    end
    object cxLabel1: TcxLabel
      Left = 12
      Top = 0
      Caption = 'Select Enterprise:'
    end
    object pYearView: TPanel
      Left = 576
      Top = 0
      Width = 190
      Height = 48
      BevelOuter = bvNone
      TabOrder = 2
      object cxLabel2: TcxLabel
        Left = 3
        Top = 2
        Caption = 'View: '
      end
      object cmboYearType: TcxComboBox
        Left = 4
        Top = 21
        Properties.Alignment.Vert = taVCenter
        Properties.DropDownListStyle = lsFixedList
        Properties.ItemHeight = 24
        Properties.Items.Strings = (
          'Income'
          'Expenditure')
        Properties.OnEditValueChanged = cmboYearTypePropertiesEditValueChanged
        Style.BorderStyle = ebsFlat
        Style.LookAndFeel.Kind = lfFlat
        Style.LookAndFeel.NativeStyle = False
        Style.ButtonStyle = btsDefault
        Style.ButtonTransparency = ebtNone
        StyleDisabled.LookAndFeel.Kind = lfFlat
        StyleDisabled.LookAndFeel.NativeStyle = False
        StyleFocused.LookAndFeel.Kind = lfFlat
        StyleFocused.LookAndFeel.NativeStyle = False
        StyleHot.LookAndFeel.Kind = lfFlat
        StyleHot.LookAndFeel.NativeStyle = False
        TabOrder = 1
        Width = 180
      end
    end
  end
  inherited BarManager: TdxBarManager
    Font.Name = 'Segoe UI'
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
        Hidden = True
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
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemLinks = <
          item
            Item = blbExit
            UserGlyph.Data = {00000000}
            Visible = True
          end
          item
            BeginGroup = True
            Item = dxBarControlContainerItem
            UserGlyph.Data = {00000000}
            Visible = True
          end>
        Name = 'TopToolbar'
        OneOnRow = True
        Row = 0
        UseOwnFont = True
        UseRecentItems = False
        UseRestSpace = True
        Visible = True
        WholeRow = True
        BackgroundBitmap.Data = {00000000}
      end>
    CanCustomize = False
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    Left = 70
    DockControlHeights = (
      0
      0
      52
      0)
    inherited blbExit: TdxBarLargeButton
      AutoGrayScale = False
      Height = 48
      Width = 68
    end
    inherited blbView: TdxBarLargeButton
      ImageIndex = 8
    end
    inherited blbPrint: TdxBarLargeButton
      ImageIndex = 17
    end
    inherited blbHelp: TdxBarLargeButton
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
    object dxBarControlContainerItem: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = pEntFilter
    end
  end
  inherited ActionList: TActionList
    Left = 102
    Top = 80
  end
end
