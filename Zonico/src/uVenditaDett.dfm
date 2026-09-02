object frmVenditaDett: TfrmVenditaDett
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Vendita'
  ClientHeight = 520
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object pnlTop: TAdvPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 64
    Align = alTop
    UseDockManager = True
    Version = '2.8.0.0'
    Caption.Visible = False
    object lblCliente: TLabel
      Left = 16
      Top = 8
      Width = 38
      Height = 15
      Caption = 'Cliente'
    end
    object lblOperatore: TLabel
      Left = 280
      Top = 8
      Width = 54
      Height = 15
      Caption = 'Operatore'
    end
    object lblPagamento: TLabel
      Left = 464
      Top = 8
      Width = 58
      Height = 15
      Caption = 'Pagamento'
    end
    object cbCliente: TAdvDBLookupComboBox
      Left = 16
      Top = 28
      Width = 250
      Height = 23
      ListSource = DSClienti
      KeyField = 'ID'
      ListField = 'NOMINATIVO'
      Columns = <
        item
          Field = 'NOMINATIVO'
          Title = 'Cliente'
          Width = 240
        end>
      Version = '1.5.0.0'
      TabOrder = 0
    end
    object cbOperatore: TAdvDBLookupComboBox
      Left = 280
      Top = 28
      Width = 170
      Height = 23
      ListSource = DSOperatori
      KeyField = 'ID'
      ListField = 'NOME'
      Columns = <
        item
          Field = 'NOME'
          Title = 'Operatore'
          Width = 160
        end>
      Version = '1.5.0.0'
      TabOrder = 1
    end
    object cbPagamento: TAdvDBLookupComboBox
      Left = 464
      Top = 28
      Width = 160
      Height = 23
      ListSource = DSPagamenti
      KeyField = 'CODICE'
      ListField = 'DESCRIZIONE'
      Columns = <
        item
          Field = 'DESCRIZIONE'
          Title = 'Pagamento'
          Width = 150
        end>
      Version = '1.5.0.0'
      TabOrder = 2
    end
  end
  object pnlAggiungi: TAdvPanel
    Left = 0
    Top = 64
    Width = 640
    Height = 56
    Align = alTop
    UseDockManager = True
    Version = '2.8.0.0'
    Caption.Visible = False
    object lblServizio: TLabel
      Left = 16
      Top = 4
      Width = 43
      Height = 15
      Caption = 'Servizio'
    end
    object lblProdotto: TLabel
      Left = 328
      Top = 4
      Width = 48
      Height = 15
      Caption = 'Prodotto'
    end
    object cbServizio: TAdvDBLookupComboBox
      Left = 16
      Top = 22
      Width = 220
      Height = 23
      ListSource = DSServizi
      KeyField = 'ID'
      ListField = 'DESCRIZIONE'
      Columns = <
        item
          Field = 'DESCRIZIONE'
          Title = 'Servizio'
          Width = 160
        end
        item
          Field = 'PREZZO'
          Title = 'Prezzo'
          Width = 60
        end>
      Version = '1.5.0.0'
      TabOrder = 0
    end
    object btnAddServizio: TAdvGlowButton
      Left = 242
      Top = 20
      Width = 70
      Height = 27
      Caption = '+ Agg.'
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      TabOrder = 1
      OnClick = btnAddServizioClick
    end
    object cbProdotto: TAdvDBLookupComboBox
      Left = 328
      Top = 22
      Width = 220
      Height = 23
      ListSource = DSProdotti
      KeyField = 'ID'
      ListField = 'DESCRIZIONE'
      Columns = <
        item
          Field = 'DESCRIZIONE'
          Title = 'Prodotto'
          Width = 140
        end
        item
          Field = 'PREZZO'
          Title = 'Prezzo'
          Width = 60
        end
        item
          Field = 'GIACENZA'
          Title = 'Giac.'
          Width = 50
        end>
      Version = '1.5.0.0'
      TabOrder = 2
    end
    object btnAddProdotto: TAdvGlowButton
      Left = 554
      Top = 20
      Width = 70
      Height = 27
      Caption = '+ Agg.'
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      TabOrder = 3
      OnClick = btnAddProdottoClick
    end
  end
  object GridRighe: TDBAdvGrid
    Left = 0
    Top = 120
    Width = 640
    Height = 320
    Align = alClient
    ColCount = 4
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
    ScrollBars = ssVertical
    TabOrder = 2
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
    DataSource = DSRighe
    ShowUnicode = True
    PageMode = False
  end
  object pnlBottom: TAdvPanel
    Left = 0
    Top = 440
    Width = 640
    Height = 80
    Align = alBottom
    UseDockManager = True
    Version = '2.8.0.0'
    Caption.Visible = False
    object btnRimuoviRiga: TAdvGlowButton
      Left = 16
      Top = 8
      Width = 110
      Height = 27
      Caption = 'Rimuovi riga'
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      TabOrder = 0
      OnClick = btnRimuoviRigaClick
    end
    object lblImponibile: TLabel
      Left = 320
      Top = 12
      Width = 100
      Height = 15
      Caption = 'Imponibile: € 0,00'
    end
    object lblSconto: TLabel
      Left = 320
      Top = 44
      Width = 40
      Height = 15
      Caption = 'Sconto €'
    end
    object edSconto: TAdvEdit
      Left = 380
      Top = 40
      Width = 80
      Height = 23
      EditType = etFloat
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
      Precision = 2
      Color = clWindow
      TabOrder = 1
      Text = '0,00'
      Visible = True
      Version = '1.9.1.0'
      OnExit = edScontoExit
    end
    object lblTotale: TLabel
      Left = 480
      Top = 8
      Width = 144
      Height = 25
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'TOTALE: € 0,00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 4227072
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnChiudi: TAdvGlowButton
      Left = 480
      Top = 40
      Width = 76
      Height = 32
      Caption = 'Chiudi'
      Default = True
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      TabOrder = 2
      OnClick = btnChiudiClick
    end
    object btnAnnulla: TAdvGlowButton
      Left = 560
      Top = 40
      Width = 64
      Height = 32
      Caption = 'Annulla'
      Cancel = True
      ModalResult = 2
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      TabOrder = 3
    end
  end
  object QRighe: TFDQuery
    AfterPost = QRigheAfterPost
    AfterDelete = QRigheAfterDelete
    Left = 40
    Top = 200
  end
  object DSRighe: TDataSource
    DataSet = QRighe
    Left = 96
    Top = 200
  end
  object QClienti: TFDQuery
    Left = 40
    Top = 248
  end
  object QOperatori: TFDQuery
    Left = 40
    Top = 296
  end
  object QPagamenti: TFDQuery
    Left = 40
    Top = 344
  end
  object QServizi: TFDQuery
    Left = 40
    Top = 392
  end
  object QProdotti: TFDQuery
    Left = 152
    Top = 248
  end
  object DSClienti: TDataSource
    DataSet = QClienti
    Left = 96
    Top = 248
  end
  object DSOperatori: TDataSource
    DataSet = QOperatori
    Left = 96
    Top = 296
  end
  object DSPagamenti: TDataSource
    DataSet = QPagamenti
    Left = 96
    Top = 344
  end
  object DSServizi: TDataSource
    DataSet = QServizi
    Left = 96
    Top = 392
  end
  object DSProdotti: TDataSource
    DataSet = QProdotti
    Left = 208
    Top = 248
  end
end
