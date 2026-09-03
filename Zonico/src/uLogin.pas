unit uLogin;

interface

uses
  System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  AdvPanel, AdvEdit, AdvGlowButton, AdvAppStyler, AdvStyleIF,
  uUtenteRepository;

type
  TfrmLogin = class(TForm)
    pnlTestata: TAdvPanel;
    lblTitolo: TLabel;
    lblSottotitolo: TLabel;
    pnlCampi: TAdvPanel;
    lblPin: TLabel;
    edtPin: TAdvEdit;
    lblRegola: TLabel;
    pnlBottoni: TAdvPanel;
    btnAccedi: TAdvGlowButton;
    btnEsci: TAdvGlowButton;
    styLogin: TAdvFormStyler;
    procedure FormCreate(Sender: TObject);
    procedure btnAccediClick(Sender: TObject);
  private
    FUtente: TUtente;
  public
    property Utente: TUtente read FUtente;
    // Login sempre modale: True se il PIN e' valido e riconosciuto.
    class function Esegui(AOwner: TComponent; out AUtente: TUtente): Boolean;
  end;

implementation

uses
  System.SysUtils, System.UITypes, uDM, uConferma, uAppTheme;

{$R *.dfm}

{ TfrmLogin }

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  ApplicaTemaColori(Self, styLogin);
  edtPin.MaxLength := PinLunghezzaMax;
  edtPin.PasswordChar := #9679;
  lblRegola.Caption := Format('PIN numerico da %d a %d cifre',
    [PinLunghezzaMin, PinLunghezzaMax]);
end;

procedure TfrmLogin.btnAccediClick(Sender: TObject);
var
  LErrore: string;
begin
  if not PinValido(Trim(edtPin.Text), LErrore) then
  begin
    TfrmConferma.Avvisa(Self, 'PIN non valido', LErrore);
    edtPin.SelectAll;
    edtPin.SetFocus;
    Exit;
  end;

  if not dmZonico.Utenti.Autentica(edtPin.Text, FUtente) then
  begin
    TfrmConferma.Avvisa(Self, 'Accesso negato', 'PIN non riconosciuto.');
    edtPin.Text := '';
    edtPin.SetFocus;
    Exit;
  end;

  ModalResult := mrOk;
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
