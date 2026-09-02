inherited frmUtenti: TfrmUtenti
  Caption = 'Utenti e permessi'
  ClientHeight = 600
  inherited Grid: TDBAdvGrid
    Height = 300
    Align = alTop
  end
  object Splitter: TAdvSplitter
    Left = 0
    Top = 340
    Width = 900
    Height = 6
    Cursor = crVSplit
    Align = alTop
    Version = '1.2.0.0'
  end
  object pnlPermessi: TAdvPanel
    Left = 0
    Top = 346
    Width = 900
    Height = 230
    Align = alClient
    UseDockManager = True
    Version = '2.8.0.0'
    Caption.Text = 'Permessi'
    Caption.Visible = True
    Caption.Font.Charset = DEFAULT_CHARSET
    Caption.Font.Color = clWindowText
    Caption.Font.Height = -12
    Caption.Font.Name = 'Segoe UI'
    Caption.Font.Style = [fsBold]
    FullHeight = 230
    object GridPerm: TDBAdvGrid
      Left = 1
      Top = 24
      Width = 898
      Height = 205
      Align = alClient
      ColCount = 4
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
      ScrollBars = ssVertical
      TabOrder = 0
      OnCheckBoxClick = GridPermCheckBoxClick
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
      Look = glOffice2019White
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
      DataSource = DSPerm
      ShowBooleanFields = True
      ShowUnicode = True
      PageMode = False
    end
  end
  object DSPerm: TDataSource
    DataSet = QPerm
    Left = 32
    Top = 400
  end
  object QPerm: TFDQuery
    Left = 96
    Top = 400
  end
end
