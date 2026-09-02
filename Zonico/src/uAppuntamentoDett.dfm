object frmAppuntamentoDett: TfrmAppuntamentoDett
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Appuntamento'
  ClientHeight = 400
  ClientWidth = 480
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
  object lblCliente: TLabel
    Left = 16
    Top = 16
    Width = 38
    Height = 15
    Caption = 'Cliente'
  end
  object lblOperatore: TLabel
    Left = 16
    Top = 64
    Width = 54
    Height = 15
    Caption = 'Operatore'
  end
  object lblServizio: TLabel
    Left = 248
    Top = 64
    Width = 43
    Height = 15
    Caption = 'Servizio'
  end
  object lblData: TLabel
    Left = 16
    Top = 112
    Width = 26
    Height = 15
    Caption = 'Data'
  end
  object lblInizio: TLabel
    Left = 176
    Top = 112
    Width = 31
    Height = 15
    Caption = 'Inizio'
  end
  object lblFine: TLabel
    Left = 288
    Top = 112
    Width = 23
    Height = 15
    Caption = 'Fine'
  end
  object lblStato: TLabel
    Left = 16
    Top = 160
    Width = 29
    Height = 15
    Caption = 'Stato'
  end
  object lblNote: TLabel
    Left = 16
    Top = 208
    Width = 27
    Height = 15
    Caption = 'Note'
  end
  object cbCliente: TAdvDBLookupComboBox
    Left = 16
    Top = 34
    Width = 448
    Height = 23
    ListSource = DSClienti
    KeyField = 'ID'
    ListField = 'NOMINATIVO'
    DropDownWidth = 448
    Columns = <
      item
        Field = 'NOMINATIVO'
        Title = 'Cliente'
        Width = 300
      end
      item
        Field = 'CELLULARE'
        Title = 'Cellulare'
        Width = 140
      end>
    Version = '1.5.0.0'
    TabOrder = 0
  end
  object cbOperatore: TAdvDBLookupComboBox
    Left = 16
    Top = 82
    Width = 216
    Height = 23
    ListSource = DSOperatori
    KeyField = 'ID'
    ListField = 'NOME'
    Columns = <
      item
        Field = 'NOME'
        Title = 'Operatore'
        Width = 200
      end>
    Version = '1.5.0.0'
    TabOrder = 1
  end
  object cbServizio: TAdvDBLookupComboBox
    Left = 248
    Top = 82
    Width = 216
    Height = 23
    ListSource = DSServizi
    KeyField = 'ID'
    ListField = 'DESCRIZIONE'
    Columns = <
      item
        Field = 'DESCRIZIONE'
        Title = 'Servizio'
        Width = 150
      end
      item
        Field = 'DURATA_MIN'
        Title = 'Min'
        Width = 50
      end>
    Version = '1.5.0.0'
    TabOrder = 2
    OnChange = cbServizioChange
  end
  object dtData: TAdvDateTimePicker
    Left = 16
    Top = 130
    Width = 144
    Height = 23
    Date = 45000.000000000000000000
    Format = 'dd/MM/yyyy'
    Time = 0.000000000000000000
    DateTime = 45000.000000000000000000
    TabOrder = 3
    Version = '1.6.4.0'
    Kind = dkDate
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
  end
  object dtInizio: TAdvDateTimePicker
    Left = 176
    Top = 130
    Width = 96
    Height = 23
    Date = 45000.000000000000000000
    Format = 'HH:mm'
    Time = 0.375000000000000000
    DateTime = 45000.375000000000000000
    TabOrder = 4
    Version = '1.6.4.0'
    Kind = dkTime
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
  end
  object dtFine: TAdvDateTimePicker
    Left = 288
    Top = 130
    Width = 96
    Height = 23
    Date = 45000.000000000000000000
    Format = 'HH:mm'
    Time = 0.395833333333333300
    DateTime = 45000.395833333333333300
    TabOrder = 5
    Version = '1.6.4.0'
    Kind = dkTime
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
  end
  object cbStato: TAdvComboBox
    Left = 16
    Top = 178
    Width = 216
    Height = 23
    Style = csDropDownList
    Version = '1.6.0.0'
    TabOrder = 6
  end
  object memNote: TAdvMemo
    Left = 16
    Top = 226
    Width = 448
    Height = 110
    ActiveLineSettings.ShowActiveLine = False
    ActiveLineSettings.ShowActiveLineIndicator = False
    Gutter.Visible = False
    Lines.Strings = ()
    ShowRightMargin = False
    TabOrder = 7
    Version = '3.9.0.0'
    WordWrap = wwClientWidth
  end
  object pnlButtons: TAdvPanel
    Left = 0
    Top = 352
    Width = 480
    Height = 48
    Align = alBottom
    UseDockManager = True
    Version = '2.8.0.0'
    Caption.Visible = False
    object btnElimina: TAdvGlowButton
      Left = 16
      Top = 8
      Width = 100
      Height = 32
      Caption = 'Elimina'
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      TabOrder = 0
      OnClick = btnEliminaClick
    end
    object btnOk: TAdvGlowButton
      Left = 264
      Top = 8
      Width = 100
      Height = 32
      Caption = 'Salva'
      Default = True
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      TabOrder = 1
      OnClick = btnOkClick
    end
    object btnAnnulla: TAdvGlowButton
      Left = 372
      Top = 8
      Width = 100
      Height = 32
      Caption = 'Annulla'
      Cancel = True
      ModalResult = 2
      NotesFont.Charset = DEFAULT_CHARSET
      NotesFont.Color = clWindowText
      NotesFont.Height = -11
      NotesFont.Name = 'Tahoma'
      NotesFont.Style = []
      TabOrder = 2
    end
  end
  object QClienti: TFDQuery
    Left = 400
    Top = 8
  end
  object QOperatori: TFDQuery
    Left = 400
    Top = 56
  end
  object QServizi: TFDQuery
    Left = 400
    Top = 104
  end
  object DSClienti: TDataSource
    DataSet = QClienti
    Left = 440
    Top = 8
  end
  object DSOperatori: TDataSource
    DataSet = QOperatori
    Left = 440
    Top = 56
  end
  object DSServizi: TDataSource
    DataSet = QServizi
    Left = 440
    Top = 104
  end
end
