unit uLogin;

interface

uses
  System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  uUtenteRepository, uControlliMetro;

type
  TfrmLogin = class(TForm)
    pnlBrand: TPanel;
    imgLogo: TImage;
    lblTitolo: TLabel;
    lblSottotitolo: TLabel;
    pnlAccesso: TPanel;
    lblPin: TLabel;
    edtPin: TEdit;
    lblRegola: TLabel;
    pnlTastierino: TPanel;
    pnlComandi: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FUtente: TUtente;
    FTastierino: TTastierinoNumerico;
    FBtnEsci: TPulsanteMetro;
    procedure CaricaImmagine;
    procedure CreaTastierino;
    procedure CreaComandi;
    procedure EsciClick(Sender: TObject);
    procedure TastoPremuto(Sender: TObject; ATipo: TTastoTipo;
      const ACifra: string);
    procedure AggiungiCifra(const ACifra: string);
    procedure Cancella;
    procedure Conferma;
  public
    property Utente: TUtente read FUtente;
    // Login sempre modale: True se il PIN e' valido e riconosciuto.
    class function Esegui(AOwner: TComponent; out AUtente: TUtente): Boolean;
  end;

implementation

uses
  Winapi.Windows, System.SysUtils, System.IOUtils, System.UITypes,
  Vcl.Imaging.pngimage, uDM, uConferma, uAppTheme;

{$R *.dfm}

const
  FileLogo = 'logo.png';
  CartellaImmagini = 'images';

{ TfrmLogin }

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  ApplicaTemaColori(Self);
  KeyPreview := True;
  edtPin.MaxLength := PinLunghezzaMax;
  edtPin.PasswordChar := #9679;
  edtPin.ReadOnly := True;
  lblRegola.Caption := Format('PIN numerico da %d a %d cifre',
    [PinLunghezzaMin, PinLunghezzaMax]);
  CaricaImmagine;
  CreaTastierino;
  CreaComandi;
end;

// Immagine di personalizzazione: images\logo.png accanto all'eseguibile,
// sostituibile senza ricompilare. Se manca resta solo il testo.
procedure TfrmLogin.CaricaImmagine;
var
  LFile: string;
  LPng: TPngImage;
begin
  LFile := TPath.Combine(TPath.Combine(TPath.GetDirectoryName(ParamStr(0)),
    CartellaImmagini), FileLogo);
  if not TFile.Exists(LFile) then
  begin
    imgLogo.Visible := False;
    Exit;
  end;

  LPng := TPngImage.Create;
  try
    LPng.LoadFromFile(LFile);
    imgLogo.Picture.Assign(LPng);
  finally
    LPng.Free;
  end;
end;

procedure TfrmLogin.CreaTastierino;
begin
  FTastierino := TTastierinoNumerico.Create(Self);
  FTastierino.Parent := pnlTastierino;
  FTastierino.Align := alClient;
  FTastierino.OnTasto := TastoPremuto;
end;

procedure TfrmLogin.CreaComandi;
begin
  FBtnEsci := TPulsanteMetro.Crea(pnlComandi, 'Esci',
    pnlComandi.Width - 110, 3, 110, 34, EsciClick);
  FBtnEsci.ColoreBase := clZonicoGrigioChiaro;
  FBtnEsci.ColoreTesto := clZonicoGrigio;
end;

procedure TfrmLogin.EsciClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLogin.TastoPremuto(Sender: TObject; ATipo: TTastoTipo;
  const ACifra: string);
begin
  case ATipo of
    ttCifra: AggiungiCifra(ACifra);
    ttCancella: Cancella;
    ttConferma: Conferma;
  end;
end;

procedure TfrmLogin.AggiungiCifra(const ACifra: string);
begin
  if Length(edtPin.Text) >= PinLunghezzaMax then
    Exit;
  edtPin.Text := edtPin.Text + ACifra;
end;

procedure TfrmLogin.Cancella;
begin
  // Un tocco cancella l'ultima cifra, sul PIN vuoto non fa nulla.
  if edtPin.Text <> '' then
    edtPin.Text := Copy(edtPin.Text, 1, Length(edtPin.Text) - 1);
end;

procedure TfrmLogin.Conferma;
var
  LErrore: string;
begin
  if not PinValido(Trim(edtPin.Text), LErrore) then
  begin
    TfrmConferma.Avvisa(Self, 'PIN non valido', LErrore);
    edtPin.Text := '';
    Exit;
  end;

  if not dmZonico.Utenti.Autentica(edtPin.Text, FUtente) then
  begin
    TfrmConferma.Avvisa(Self, 'Accesso negato', 'PIN non riconosciuto.');
    edtPin.Text := '';
    Exit;
  end;

  ModalResult := mrOk;
end;

// Il PIN si digita anche da tastiera fisica, oltre che dal tastierino.
procedure TfrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    '0'..'9':
      AggiungiCifra(Key);
    #8:
      Cancella;
    #13:
      Conferma;
  else
    Exit;
  end;
  Key := #0;
end;

class function TfrmLogin.Esegui(AOwner: TComponent; out AUtente: TUtente): Boolean;
var
  LForm: TfrmLogin;
begin
  AUtente := Default(TUtente);
  LForm := TfrmLogin.Create(AOwner);
  try
    Result := LForm.ShowModal = mrOk;
    if Result then
      AUtente := LForm.Utente;
  finally
    LForm.Free;
  end;
end;

end.
