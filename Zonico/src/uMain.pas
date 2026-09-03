unit uMain;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls,
  uControlliMetro;

type
  TfrmMain = class(TForm)
    pnlTop: TPanel;
    lblTitolo: TLabel;
    lblSottotitolo: TLabel;
    pnlAree: TPanel;
    stbStato: TStatusBar;
    procedure FormCreate(Sender: TObject);
  private
    FPulsanti: array[0..3] of TPulsanteMetro;
    FBtnEsci: TPulsanteMetro;
    procedure CreaPulsanti;
    procedure ApplicaPermessi;
    procedure AreaClick(Sender: TObject);
    procedure EsciClick(Sender: TObject);
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uDM, uConferma, uAppTheme;

{$R *.dfm}

// Codici e titoli delle aree, nello stesso ordine dei pulsanti.
const
  CodiciAree: array[0..3] of string = ('ANAG', 'VEND', 'REPO', 'AMMI');
  TitoliAree: array[0..3] of string = ('Anagrafiche e Magazzino',
    'Vendite e Contabilita', 'Report', 'Amministrazione');
  LarghezzaArea = 340;
  AltezzaArea = 120;
  SpazioArea = 24;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ApplicaTemaColori(Self);
  lblSottotitolo.Caption := Format('%s - %s',
    [dmZonico.UtenteCorrente.Descrizione, dmZonico.UtenteCorrente.Ruolo]);
  CreaPulsanti;
  ApplicaPermessi;
end;

procedure TfrmMain.CreaPulsanti;
var
  LIndice, LRiga, LColonna, LSinistra, LAlto: Integer;
begin
  LSinistra := (pnlAree.Width - (2 * LarghezzaArea + SpazioArea)) div 2;
  LAlto := 60;
  for LIndice := Low(CodiciAree) to High(CodiciAree) do
  begin
    LRiga := LIndice div 2;
    LColonna := LIndice mod 2;
    FPulsanti[LIndice] := TPulsanteMetro.Crea(pnlAree, TitoliAree[LIndice],
      LSinistra + LColonna * (LarghezzaArea + SpazioArea),
      LAlto + LRiga * (AltezzaArea + SpazioArea),
      LarghezzaArea, AltezzaArea, AreaClick);
    FPulsanti[LIndice].Tag := LIndice;
    FPulsanti[LIndice].Font.Height := -17;
  end;

  FBtnEsci := TPulsanteMetro.Crea(pnlAree, 'Esci',
    pnlAree.Width - 150, pnlAree.Height - 60, 120, 36, EsciClick);
  FBtnEsci.Anchors := [akRight, akBottom];
  FBtnEsci.ColoreBase := clZonicoGrigioChiaro;
  FBtnEsci.ColoreTesto := clZonicoGrigio;
end;

procedure TfrmMain.ApplicaPermessi;
var
  LIndice, LAbilitate: Integer;
begin
  LAbilitate := 0;
  for LIndice := Low(CodiciAree) to High(CodiciAree) do
  begin
    FPulsanti[LIndice].Enabled :=
      dmZonico.UtenteCorrente.HaArea(CodiciAree[LIndice]);
    if FPulsanti[LIndice].Enabled then
      Inc(LAbilitate);
  end;

  stbStato.SimpleText := Format('Utente: %s   |   Ruolo: %s   |   Aree abilitate: %d',
    [dmZonico.UtenteCorrente.Descrizione, dmZonico.UtenteCorrente.Ruolo, LAbilitate]);
end;

procedure TfrmMain.AreaClick(Sender: TObject);
var
  LPulsante: TPulsanteMetro;
begin
  LPulsante := Sender as TPulsanteMetro;
  if not dmZonico.UtenteCorrente.HaArea(CodiciAree[LPulsante.Tag]) then
  begin
    TfrmConferma.Avvisa(Self, 'Accesso negato',
      'Il ruolo corrente non e'' abilitato a questa area.');
    Exit;
  end;

  TfrmConferma.Avvisa(Self, LPulsante.Caption,
    'Area non ancora implementata.');
end;

procedure TfrmMain.EsciClick(Sender: TObject);
begin
  if TfrmConferma.Chiedi(Self, 'Esci', 'Chiudere Zonico?') then
    Close;
end;

end.
