object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Zonico - Gestione zone'
  ClientHeight = 520
  ClientWidth = 880
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Comfortaa'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object grdZone: TDBAdvGrid
    Left = 0
    Top = 65
    Width = 880
    Height = 436
    Cursor = crDefault
    Align = alClient
    ColCount = 4
    DrawingStyle = gdsClassic
    FixedColor = 15265244
    RowCount = 2
    FixedRows = 1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Comfortaa'
    Font.Style = []
    Options = [goRowSizing, goColSizing, goRowSelect]
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    HoverRowCells = [hcNormal, hcSelected]
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -13
    ActiveCellFont.Name = 'Comfortaa'
    ActiveCellFont.Style = [fsBold]
    ControlLook.FixedGradientFrom = 16510687
    ControlLook.FixedGradientTo = 15265244
    ControlLook.FixedGradientHoverFrom = 15265244
    ControlLook.FixedGradientHoverTo = 13204027
    Filter = <>
    FilterDropDown.Font.Charset = DEFAULT_CHARSET
    FilterDropDown.Font.Color = clWindowText
    FilterDropDown.Font.Height = -13
    FilterDropDown.Font.Name = 'Comfortaa'
    FilterDropDown.Font.Style = []
    FixedRowHeight = 28
    DefaultRowHeight = 26
    SearchFooter.FindNextCaption = 'Trova successivo'
    SearchFooter.FindPrevCaption = 'Trova precedente'
    SearchFooter.HighLightCaption = 'Evidenzia'
    SearchFooter.HintClose = 'Chiudi'
    SearchFooter.MatchCaseCaption = 'Maiuscole/minuscole'
    SearchFooter.Font.Charset = DEFAULT_CHARSET
    SearchFooter.Font.Color = clWindowText
    SearchFooter.Font.Height = -13
    SearchFooter.Font.Name = 'Comfortaa'
    SearchFooter.Font.Style = []
    PrintSettings.Font.Charset = DEFAULT_CHARSET
    PrintSettings.Font.Color = clWindowText
    PrintSettings.Font.Height = -13
    PrintSettings.Font.Name = 'Comfortaa'
    PrintSettings.Font.Style = []
    SortSettings.HeaderColor = 15265244
    SortSettings.HeaderColorTo = 13204027
    SortSettings.Show = True
    SortSettings.IndexShow = True
    Columns = <
      item
        Header = 'Codice'
        FieldName = 'CODICE'
        Width = 100
      end
      item
        Header = 'Descrizione'
        FieldName = 'DESCRIZIONE'
        Width = 420
      end
      item
        Header = 'Superficie (mq)'
        FieldName = 'SUPERFICIE'
        Width = 130
      end
      item
        Header = 'Attiva'
        FieldName = 'ATTIVA'
        Width = 90
      end>
    AutoCreateColumns = False
    AutoRemoveColumns = False
    OnDblClickCell = grdZoneDblClickCell
  end
  object pnlTop: TAdvPanel
    Left = 0
    Top = 0
    Width = 880
    Height = 65
    Align = alTop
    UseDockManager = True
    ParentColor = False
    TabOrder = 1
    Version = '2.4.0.0'
    BorderColor = clNone
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -13
    Caption.Font.Name = 'Comfortaa'
    Caption.Font.Style = []
    Caption.Text = ''
    Caption.Visible = False
    Fill.Color = clWhite
    Fill.ColorTo = 15527152
    Fill.BorderColor = 14209752
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Comfortaa'
    Font.Style = []
    ParentFont = False
    object lblFiltro: TLabel
      Left = 16
      Top = 22
      Width = 34
      Height = 16
      Caption = 'Cerca'
    end
    object edtFiltro: TAdvEdit
      Left = 60
      Top = 18
      Width = 280
      Height = 26
      EmptyTextStyle = []
      Color = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Comfortaa'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Version = '3.5.0.0'
      Visible = True
      EmptyText = 'Codice o descrizione'
      OnChange = edtFiltroChange
    end
    object btnNuova: TAdvGlowButton
      Left = 500
      Top = 16
      Width = 110
      Height = 32
      Caption = 'Nuova'
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Comfortaa'
      NotesFont.Style = []
      TabOrder = 1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Comfortaa'
      Font.Style = []
      ParentFont = False
      Version = '1.7.0.0'
      OnClick = btnNuovaClick
    end
    object btnModifica: TAdvGlowButton
      Left = 620
      Top = 16
      Width = 110
      Height = 32
      Caption = 'Modifica'
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Comfortaa'
      NotesFont.Style = []
      TabOrder = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Comfortaa'
      Font.Style = []
      ParentFont = False
      Version = '1.7.0.0'
      OnClick = btnModificaClick
    end
    object btnElimina: TAdvGlowButton
      Left = 740
      Top = 16
      Width = 110
      Height = 32
      Caption = 'Elimina'
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Comfortaa'
      NotesFont.Style = []
      TabOrder = 3
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Comfortaa'
      Font.Style = []
      ParentFont = False
      Version = '1.7.0.0'
      OnClick = btnEliminaClick
    end
  end
  object stbStato: TStatusBar
    Left = 0
    Top = 501
    Width = 880
    Height = 19
    Panels = <>
    SimplePanel = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Comfortaa'
    Font.Style = []
    UseSystemFont = False
  end
  object styMain: TAdvFormStyler
    Style = tsWindows8
    Left = 424
    Top = 200
  end
end
