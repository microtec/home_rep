unit uMain;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls,
  AdvPanel, AdvGlowButton, AdvObj, AdvAppStyler, AdvStyleIF;

type
  TfrmMain = class(TForm)
    pnlTop: TAdvPanel;
    lblTitolo: TLabel;
    lblSottotitolo: TLabel;
    btnEsci: TAdvGlowButton;
    pnlAree: TAdvPanel;
    btnAreaAnag: TAdvGlowButton;
    btnAreaVend: TAdvGlowButton;
    btnAreaRepo: TAdvGlowButton;
    btnAreaAmmi: TAdvGlowButton;
    stbStato: TStatusBar;
    styMain: TAdvFormStyler;
    procedure FormCreate(Sender: TObject);
    procedure AreaClick(Sender: TObject);
    procedure btnEsciClick(Sender: TObject);
  private
    function PulsantiAree: TArray<TAdvGlowButton>;
    function CodiceArea(APulsante: TAdvGlowButton): string;
    procedure ApplicaPermessi;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.UITypes, uDM, uConferma, uAppTheme, uUtenteRepository;

{$R *.dfm}

// Codici delle aree in AREE.AR_CODICE, nello stesso ordine di PulsantiAree.
const
  CodiciAree: array[0..3] of string = ('ANAG', 'VEND', 'REPO', 'AMMI');

function TfrmMain.PulsantiAree: TArray<TAdvGlowButton>;
begin
  Result := [btnAreaAnag, btnAreaVend, btnAreaRepo, btnAreaAmmi];
end;

function TfrmMain.CodiceArea(APulsante: TAdvGlowButton): string;
var
  LIndice: Integer;
begin
  for LIndice := Low(CodiciAree) to High(CodiciAree) do
    if PulsantiAree[LIndice] = APulsante then
      Exit(CodiciAree[LIndice]);
  Result := '';
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ApplicaTemaColori(Self, styMain);
  lblSottotitolo.Caption := Format('%s - %s',
    [dmZonico.UtenteCorrente.Descrizione, dmZonico.UtenteCorrente.Ruolo]);
  ApplicaPermessi;
end;

procedure TfrmMain.ApplicaPermessi;
var
  LIndice: Integer;
  LPulsante: TAdvGlowButton;
  LAbilitate: Integer;
begin
  LAbilitate := 0;
  for LIndice := Low(CodiciAree) to High(CodiciAree) do
  begin
    LPulsante := PulsantiAree[LIndice];
    LPulsante.Enabled := dmZonico.UtenteCorrente.HaArea(CodiciAree[LIndice]);
    if LPulsante.Enabled then
      Inc(LAbilitate);
  end;

  stbStato.SimpleText := Format('Utente: %s   |   Ruolo: %s   |   Aree abilitate: %d',
    [dmZonico.UtenteCorrente.Descrizione, dmZonico.UtenteCorrente.Ruolo, LAbilitate]);
end;

procedure TfrmMain.AreaClick(Sender: TObject);
var
  LPulsante: TAdvGlowButton;
begin
  LPulsante := Sender as TAdvGlowButton;
  if not dmZonico.UtenteCorrente.HaArea(CodiceArea(LPulsante)) then
  begin
    TfrmConferma.Avvisa(Self, 'Accesso negato',
      'Il ruolo corrente non e'' abilitato a questa area.');
    Exit;
  end;

  TfrmConferma.Avvisa(Self, LPulsante.Caption,
    'Area non ancora implementata.');
end;

procedure TfrmMain.btnEsciClick(Sender: TObject);
begin
  if TfrmConferma.Chiedi(Self, 'Esci', 'Chiudere Zonico?') then
    Close;
end;

end.
