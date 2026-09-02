object frmVendite: TfrmVendite
  Left = 0
  Top = 0
  Caption = 'Cassa - Vendite'
  ClientHeight = 500
  ClientWidth = 900
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
    Width = 900
    Height = 40
    Align = alTop
    AutoSize = False
    ShowOptionIndicator = False
    ShowRightHandle = False
    Caption = 'ToolBar'
    Version = '7.4.0.0'
    object btnNuova: TAdvToolBarButton
      Left = 4
      Top = 2
      Width = 110
      Height = 34
      Caption = 'Nuova vendita'
      ShowCaption = True
      ShortCut = 16462
      OnClick = btnNuovaClick
    end
    object btnApri: TAdvToolBarButton
      Left = 114
      Top = 2
      Width = 80
      Height = 34
      Caption = 'Apri'
      ShowCaption = True
      OnClick = btnApriClick
    end
    object btnElimina: TAdvToolBarButton
      Left = 194
      Top = 2
      Width = 80
      Height = 34
      Caption = 'Elimina'
      ShowCaption = True
      OnClick = btnEliminaClick
    end
    object sep1: TAdvToolBarSeparator
      Left = 274
      Top = 2
      Width = 10
      Height = 34
    end
    object dtGiorno: TAdvDateTimePicker
      Left = 290
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
    object btnAggiorna: TAdvToolBarButton
      Left = 446
      Top = 2
      Width = 80
      Height = 34
      Caption = 'Aggiorna'
      ShowCaption = True
      ShortCut = 116
      OnClick = btnAggiornaClick
    end
  end
  object Grid: TDBAdvGrid
    Left = 0
    Top = 40
    Width = 900
    Height = 436
    Align = alClient
    ColCount = 8
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    ScrollBars = ssBoth
    TabOrder = 1
    OnDblClick = GridDblClick
    GridLineColor = 15790320
    GridFixedLineColor = 13421772
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -12
    ActiveCellFont.Name = 'Segoe UI'
    ActiveCellFont.Style = [fsBold]
    ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
    ControlLook.DropDownHeader.Font.Color = clWindowText
    ControlLook.DropDownHeader.Font.Height = -11
    ControlLook.DropDownHeader.Font.Name = 'Tahoma'
    ControlLook.DropDownHeader.Font.Style = []
    ControlLook.DropDownHeader.Buttons = <>
    ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
    ControlLook.DropDownFooter.Font.Color = clWindowText
    ControlLook.DropDownFooter.Font.Height = -11
    ControlLook.DropDownFooter.Font.Name = 'Tahoma'
    ControlLook.DropDownFooter.Font.Style = []
    ControlLook.DropDownFooter.Buttons = <>
    Filter = <>
    FilterDropDown.Font.Charset = DEFAULT_CHARSET
    FilterDropDown.Font.Color = clWindowText
    FilterDropDown.Font.Height = -11
    FilterDropDown.Font.Name = 'Tahoma'
    FilterDropDown.Font.Style = []
    FixedRowHeight = 26
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -12
    FixedFont.Name = 'Segoe UI'
    FixedFont.Style = [fsBold]
    Look = glWin8
    PrintSettings.Font.Charset = DEFAULT_CHARSET
    PrintSettings.Font.Color = clWindowText
    PrintSettings.Font.Height = -11
    PrintSettings.Font.Name = 'Tahoma'
    PrintSettings.Font.Style = []
    PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
    PrintSettings.FixedFont.Color = clWindowText
    PrintSettings.FixedFont.Height = -11
    PrintSettings.FixedFont.Name = 'Tahoma'
    PrintSettings.FixedFont.Style = []
    PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
    PrintSettings.HeaderFont.Color = clWindowText
    PrintSettings.HeaderFont.Height = -11
    PrintSettings.HeaderFont.Name = 'Tahoma'
    PrintSettings.HeaderFont.Style = []
    PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
    PrintSettings.FooterFont.Color = clWindowText
    PrintSettings.FooterFont.Height = -11
    PrintSettings.FooterFont.Name = 'Tahoma'
    PrintSettings.FooterFont.Style = []
    SearchFooter.Font.Charset = DEFAULT_CHARSET
    SearchFooter.Font.Color = clWindowText
    SearchFooter.Font.Height = -11
    SearchFooter.Font.Name = 'Tahoma'
    SearchFooter.Font.Style = []
    ShowDesignHelper = False
    Version = '2.6.0.0'
    AutoCreateColumns = False
    AutoRemoveColumns = False
    Columns = <>
    DataSetType = dtNonSequenced
    DataSource = DS
    ShowUnicode = True
    PageMode = False
  end
  object pnlBottom: TAdvPanel
    Left = 0
    Top = 476
    Width = 900
    Height = 24
    Align = alBottom
    UseDockManager = True
    Version = '2.8.0.0'
    Caption.Visible = False
    object lblTotale: TLabel
      Left = 8
      Top = 4
      Width = 100
      Height = 15
      Caption = 'Vendite: 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object DS: TDataSource
    DataSet = Q
    Left = 32
    Top = 96
  end
  object Q: TFDQuery
    Left = 96
    Top = 96
  end
end
