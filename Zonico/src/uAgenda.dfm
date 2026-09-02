object frmAgenda: TfrmAgenda
  Left = 0
  Top = 0
  Caption = 'Agenda'
  ClientHeight = 600
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object ToolBar: TAdvToolBar
    Left = 0
    Top = 0
    Width = 1000
    Height = 40
    Align = alTop
    AutoSize = False
    ShowOptionIndicator = False
    ShowRightHandle = False
    Caption = 'ToolBar'
    Version = '7.4.0.0'
    object btnOggi: TAdvToolBarButton
      Left = 4
      Top = 2
      Width = 70
      Height = 34
      Caption = 'Oggi'
      ShowCaption = True
      OnClick = btnOggiClick
    end
    object btnPrec: TAdvToolBarButton
      Left = 74
      Top = 2
      Width = 34
      Height = 34
      Caption = '<'
      ShowCaption = True
      OnClick = btnPrecClick
    end
    object dtGiorno: TAdvDateTimePicker
      Left = 112
      Top = 8
      Width = 150
      Height = 23
      Date = 45000.000000000000000000
      Format = 'ddd dd/MM/yyyy'
      Time = 0.000000000000000000
      DateTime = 45000.000000000000000000
      TabOrder = 0
      Version = '1.6.4.0'
      Kind = dkDate
      OnChange = dtGiornoChange
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
    end
    object btnSucc: TAdvToolBarButton
      Left = 266
      Top = 2
      Width = 34
      Height = 34
      Caption = '>'
      ShowCaption = True
      OnClick = btnSuccClick
    end
    object sep1: TAdvToolBarSeparator
      Left = 300
      Top = 2
      Width = 10
      Height = 34
    end
    object btnNuovo: TAdvToolBarButton
      Left = 310
      Top = 2
      Width = 130
      Height = 34
      Caption = 'Nuovo appuntamento'
      ShowCaption = True
      ShortCut = 16462
      OnClick = btnNuovoClick
    end
    object btnAggiorna: TAdvToolBarButton
      Left = 440
      Top = 2
      Width = 80
      Height = 34
      Caption = 'Aggiorna'
      ShowCaption = True
      ShortCut = 116
      OnClick = btnAggiornaClick
    end
  end
  object Planner: TPlanner
    Left = 0
    Top = 40
    Width = 1000
    Height = 560
    Align = alClient
    Display.ColorNonActive = clWhite
    Display.ColorActive = 16250871
    Display.DisplayStart = 32
    Display.DisplayEnd = 80
    Display.DisplayUnit = 15
    Display.DisplayScale = 1
    Display.ActiveStart = 32
    Display.ActiveEnd = 80
    Display.CurrentPosFrom = 0
    Display.CurrentPosTo = 0
    Display.ScrollStep = 1
    Display.TimeLineHeight = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Header.Color = 15987699
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -12
    Header.Font.Name = 'Segoe UI'
    Header.Font.Style = [fsBold]
    Header.Height = 30
    Header.Captions.Strings = (
      '')
    Mode.PlannerType = plDay
    Mode.Date = 45000.000000000000000000
    Positions = 1
    PositionWidth = 180
    PositionProps = <>
    ReadOnly = False
    Sidebar.Position = spLeft
    Sidebar.ShowMinutes = True
    Sidebar.Hourformat = hf24hour
    Sidebar.Font.Charset = DEFAULT_CHARSET
    Sidebar.Font.Color = clWindowText
    Sidebar.Font.Height = -12
    Sidebar.Font.Name = 'Segoe UI'
    Sidebar.Font.Style = []
    Sidebar.Width = 60
    TabOrder = 1
    TrackProportional = True
    Version = '3.5.0.0'
    OnItemDblClick = PlannerItemDblClick
    OnPlannerDblClick = PlannerPlannerDblClick
    OnItemMove = PlannerItemMove
    OnItemSize = PlannerItemSize
  end
end
