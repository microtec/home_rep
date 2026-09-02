object frmBaseAnag: TfrmBaseAnag
  Left = 0
  Top = 0
  Caption = 'Anagrafica'
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
    object btnNuovo: TAdvToolBarButton
      Left = 4
      Top = 2
      Width = 80
      Height = 34
      Caption = 'Nuovo'
      ShowCaption = True
      ShortCut = 16462
      OnClick = btnNuovoClick
    end
    object btnModifica: TAdvToolBarButton
      Left = 84
      Top = 2
      Width = 80
      Height = 34
      Caption = 'Modifica'
      ShowCaption = True
      OnClick = btnModificaClick
    end
    object btnElimina: TAdvToolBarButton
      Left = 164
      Top = 2
      Width = 80
      Height = 34
      Caption = 'Elimina'
      ShowCaption = True
      OnClick = btnEliminaClick
    end
    object btnSalva: TAdvToolBarButton
      Left = 244
      Top = 2
      Width = 80
      Height = 34
      Caption = 'Salva'
      Enabled = False
      ShowCaption = True
      ShortCut = 16467
      OnClick = btnSalvaClick
    end
    object btnAnnulla: TAdvToolBarButton
      Left = 324
      Top = 2
      Width = 80
      Height = 34
      Caption = 'Annulla'
      Enabled = False
      ShowCaption = True
      OnClick = btnAnnullaClick
    end
    object btnAggiorna: TAdvToolBarButton
      Left = 404
      Top = 2
      Width = 80
      Height = 34
      Caption = 'Aggiorna'
      ShowCaption = True
      ShortCut = 116
      OnClick = btnAggiornaClick
    end
    object sepRicerca: TAdvToolBarSeparator
      Left = 484
      Top = 2
      Width = 10
      Height = 34
    end
    object edRicerca: TAdvEdit
      Left = 500
      Top = 8
      Width = 260
      Height = 23
      EmptyText = 'Cerca...'
      LabelFont.Charset = DEFAULT_CHARSET
      LabelFont.Color = clWindowText
      LabelFont.Height = -11
      LabelFont.Name = 'Tahoma'
      LabelFont.Style = []
      Lookup.Font.Charset = DEFAULT_CHARSET
      Lookup.Font.Color = clWindowText
      Lookup.Font.Height = -11
      Lookup.Font.Name = 'Arial'
      Lookup.Font.Style = []
      Color = clWindow
      TabOrder = 0
      Text = ''
      Visible = True
      Version = '1.9.1.0'
      OnChange = edRicercaChange
    end
  end
  object Grid: TDBAdvGrid
    Left = 0
    Top = 40
    Width = 900
    Height = 436
    Align = alClient
    ColCount = 5
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    ScrollBars = ssBoth
    TabOrder = 1
    OnDblClick = GridDblClick
    GridLineColor = 15790320
    GridFixedLineColor = 13421772
    HoverRowCells = [hcNormal, hcSelected]
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -12
    ActiveCellFont.Name = 'Segoe UI'
    ActiveCellFont.Style = [fsBold]
    ControlLook.FixedGradientHoverFrom = clGray
    ControlLook.FixedGradientHoverTo = clWhite
    ControlLook.FixedGradientDownFrom = clGray
    ControlLook.FixedGradientDownTo = clSilver
    ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
    ControlLook.DropDownHeader.Font.Color = clWindowText
    ControlLook.DropDownHeader.Font.Height = -11
    ControlLook.DropDownHeader.Font.Name = 'Tahoma'
    ControlLook.DropDownHeader.Font.Style = []
    ControlLook.DropDownHeader.Visible = True
    ControlLook.DropDownHeader.Buttons = <>
    ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
    ControlLook.DropDownFooter.Font.Color = clWindowText
    ControlLook.DropDownFooter.Font.Height = -11
    ControlLook.DropDownFooter.Font.Name = 'Tahoma'
    ControlLook.DropDownFooter.Font.Style = []
    ControlLook.DropDownFooter.Visible = True
    ControlLook.DropDownFooter.Buttons = <>
    Filter = <>
    FilterDropDown.Font.Charset = DEFAULT_CHARSET
    FilterDropDown.Font.Color = clWindowText
    FilterDropDown.Font.Height = -11
    FilterDropDown.Font.Name = 'Tahoma'
    FilterDropDown.Font.Style = []
    FilterDropDownClear = '(Tutti)'
    FilterEdit.TypeNames.Strings = (
      'Inizia con'
      'Finisce con'
      'Contiene'
      'Non contiene'
      'Uguale'
      'Diverso'
      'Vuoto'
      'Non vuoto'
      'Maggiore'
      'Maggiore o uguale'
      'Minore'
      'Minore o uguale')
    FixedRowHeight = 26
    FixedFont.Charset = DEFAULT_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -12
    FixedFont.Name = 'Segoe UI'
    FixedFont.Style = [fsBold]
    FloatFormat = '%.2f'
    Look = glWin8
    PrintSettings.DateFormat = 'dd/mm/yyyy'
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
    PrintSettings.PageNumSep = '/'
    SearchFooter.FindNextCaption = 'Trova &successivo'
    SearchFooter.FindPrevCaption = 'Trova &precedente'
    SearchFooter.Font.Charset = DEFAULT_CHARSET
    SearchFooter.Font.Color = clWindowText
    SearchFooter.Font.Height = -11
    SearchFooter.Font.Name = 'Tahoma'
    SearchFooter.Font.Style = []
    SearchFooter.HighLightCaption = 'Evidenzia'
    SearchFooter.HintClose = 'Chiudi'
    SearchFooter.HintFindNext = 'Trova successivo'
    SearchFooter.HintFindPrev = 'Trova precedente'
    SearchFooter.HintHighlight = 'Evidenzia occorrenze'
    SearchFooter.MatchCaseCaption = 'Maiuscole/minuscole'
    SearchFooter.ResultFormat = '(%d di %d)'
    ShowDesignHelper = False
    SortSettings.DefaultFormat = ssAutomatic
    Version = '2.6.0.0'
    AutoCreateColumns = True
    AutoRemoveColumns = True
    Columns = <>
    DataSetType = dtNonSequenced
    DataSource = DS
    ShowBooleanFields = True
    ShowMemoFields = True
    ShowPictureFields = True
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
    object lblStato: TLabel
      Left = 8
      Top = 4
      Width = 40
      Height = 15
      Caption = '0 record'
    end
  end
  object DS: TDataSource
    DataSet = Q
    OnStateChange = DSStateChange
    Left = 32
    Top = 96
  end
  object Q: TFDQuery
    Left = 96
    Top = 96
  end
end
