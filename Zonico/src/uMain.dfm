object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Zonico - Gestionale Parrucchieri'
  ClientHeight = 700
  ClientWidth = 1200
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIForm
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object ToolBar: TAdvToolBar
    Left = 0
    Top = 0
    Width = 1200
    Height = 64
    Align = alTop
    AutoSize = False
    ShowOptionIndicator = False
    ShowRightHandle = False
    ToolBarStyler = Styler
    Caption = 'Zonico'
    Version = '7.4.0.0'
    object btnAgenda: TAdvToolBarButton
      Left = 4
      Top = 2
      Width = 90
      Height = 58
      Caption = 'Agenda'
      ShowCaption = True
      Layout = blGlyphTop
      OnClick = btnAgendaClick
    end
    object btnVendite: TAdvToolBarButton
      Left = 94
      Top = 2
      Width = 90
      Height = 58
      Caption = 'Cassa'
      ShowCaption = True
      Layout = blGlyphTop
      OnClick = btnVenditeClick
    end
    object sep1: TAdvToolBarSeparator
      Left = 184
      Top = 2
      Width = 10
      Height = 58
    end
    object btnClienti: TAdvToolBarButton
      Left = 194
      Top = 2
      Width = 90
      Height = 58
      Caption = 'Clienti'
      ShowCaption = True
      Layout = blGlyphTop
      OnClick = btnClientiClick
    end
    object btnOperatori: TAdvToolBarButton
      Left = 284
      Top = 2
      Width = 90
      Height = 58
      Caption = 'Operatori'
      ShowCaption = True
      Layout = blGlyphTop
      OnClick = btnOperatoriClick
    end
    object btnServizi: TAdvToolBarButton
      Left = 374
      Top = 2
      Width = 90
      Height = 58
      Caption = 'Servizi'
      ShowCaption = True
      Layout = blGlyphTop
      OnClick = btnServiziClick
    end
    object btnProdotti: TAdvToolBarButton
      Left = 464
      Top = 2
      Width = 90
      Height = 58
      Caption = 'Prodotti'
      ShowCaption = True
      Layout = blGlyphTop
      OnClick = btnProdottiClick
    end
    object sep2: TAdvToolBarSeparator
      Left = 554
      Top = 2
      Width = 10
      Height = 58
    end
    object btnReport: TAdvToolBarButton
      Left = 564
      Top = 2
      Width = 90
      Height = 58
      Caption = 'Report'
      ShowCaption = True
      Layout = blGlyphTop
      OnClick = btnReportClick
    end
    object btnUtenti: TAdvToolBarButton
      Left = 654
      Top = 2
      Width = 90
      Height = 58
      Caption = 'Utenti'
      ShowCaption = True
      Layout = blGlyphTop
      OnClick = btnUtentiClick
    end
    object sep3: TAdvToolBarSeparator
      Left = 744
      Top = 2
      Width = 10
      Height = 58
    end
    object btnLogout: TAdvToolBarButton
      Left = 754
      Top = 2
      Width = 90
      Height = 58
      Caption = 'Cambia utente'
      ShowCaption = True
      Layout = blGlyphTop
      OnClick = btnLogoutClick
    end
  end
  object StatusBar: TAdvOfficeStatusBar
    Left = 0
    Top = 676
    Width = 1200
    Height = 24
    Panels = <
      item
        Width = 250
        Text = 'Utente:'
      end
      item
        Width = 250
        Text = ''
      end
      item
        Style = psDate
        Width = 150
      end
      item
        Style = psTime
        Width = 100
      end>
    Version = '1.7.0.0'
  end
  object Styler: TAdvToolBarOfficeStyler
    Style = bsOffice2019White
    Left = 1000
    Top = 100
  end
end
