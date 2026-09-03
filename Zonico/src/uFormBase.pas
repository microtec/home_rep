unit uFormBase;

// Modello delle form modali di Zonico: testata azzurra con titolo e
// descrizione, corpo vuoto da riempire nella form derivata e barra comandi
// con i pulsanti Conferma / Annulla in stile Metro.
//
// Uso tipico in una form derivata (File > New > Other > Inherited Form,
// oppure dichiarando TfrmClienti = class(TfrmBase)):
//
//   procedure TfrmClienti.Inizializza;
//   begin
//     inherited;                       // tema, font e comandi
//     Titolo := 'Clienti';
//     Descrizione := 'Anagrafica dei clienti';
//     // creare qui i controlli con Parent = pnlCorpo
//   end;
//
//   function TfrmClienti.Valida(out AMessaggio: string): Boolean;
//   begin
//     Result := edtRagioneSociale.Text <> '';
//     if not Result then
//       AMessaggio := 'Indicare la ragione sociale.';
//   end;
//
//   procedure TfrmClienti.Salva;
//   begin
//     // scrittura su database, eseguita solo se Valida ha dato True
//   end;
//
//   TfrmClienti.Esegui(Self);          // sempre modale

interface

uses
  System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  uControlliMetro;

type
  TfrmBase = class(TForm)
    pnlTestata: TPanel;
    lblTitolo: TLabel;
    lblDescrizione: TLabel;
    pnlCorpo: TPanel;
    pnlComandi: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FBtnConferma: TPulsanteMetro;
    FBtnAnnulla: TPulsanteMetro;
    procedure CreaComandi;
    procedure ConfermaClick(Sender: TObject);
    procedure AnnullaClick(Sender: TObject);
    function GetTitolo: string;
    procedure SetTitolo(const AValue: string);
    function GetDescrizione: string;
    procedure SetDescrizione(const AValue: string);
  protected
    // Punto di estensione principale: creare qui i controlli su pnlCorpo.
    procedure Inizializza; virtual;
    // False blocca la conferma e mostra AMessaggio in una form modale.
    function Valida(out AMessaggio: string): Boolean; virtual;
    // Eseguita solo dopo una validazione riuscita, prima di chiudere.
    procedure Salva; virtual;
    // Chiesta conferma prima di annullare le modifiche.
    function ChiediConfermaAnnulla: Boolean; virtual;
    property BtnConferma: TPulsanteMetro read FBtnConferma;
    property BtnAnnulla: TPulsanteMetro read FBtnAnnulla;
  public
    property Titolo: string read GetTitolo write SetTitolo;
    property Descrizione: string read GetDescrizione write SetDescrizione;
    // Tutte le form dell'applicazione si aprono modali.
    class function Esegui(AOwner: TComponent): Boolean;
  end;

implementation

uses
  System.UITypes, uConferma, uAppTheme;

{$R *.dfm}

const
  LarghezzaComando = 130;
  AltezzaComando = 36;
  MargineComando = 24;

{ TfrmBase }

procedure TfrmBase.FormCreate(Sender: TObject);
begin
  ApplicaTemaColori(Self);
  CreaComandi;
  Inizializza;
end;

procedure TfrmBase.CreaComandi;
var
  LAlto: Integer;
begin
  LAlto := (pnlComandi.Height - AltezzaComando) div 2;

  FBtnConferma := TPulsanteMetro.Crea(pnlComandi, 'Conferma',
    pnlComandi.Width - 2 * LarghezzaComando - MargineComando - 12, LAlto,
    LarghezzaComando, AltezzaComando, ConfermaClick);
  FBtnConferma.Anchors := [akRight, akBottom];

  FBtnAnnulla := TPulsanteMetro.Crea(pnlComandi, 'Annulla',
    pnlComandi.Width - LarghezzaComando - MargineComando, LAlto,
    LarghezzaComando, AltezzaComando, AnnullaClick);
  FBtnAnnulla.Anchors := [akRight, akBottom];
  FBtnAnnulla.ColoreBase := clZonicoGrigioChiaro;
  FBtnAnnulla.ColoreTesto := clZonicoGrigio;
end;

procedure TfrmBase.Inizializza;
begin
  // Nessuna inizializzazione nel modello.
end;

function TfrmBase.Valida(out AMessaggio: string): Boolean;
begin
  AMessaggio := '';
  Result := True;
end;

procedure TfrmBase.Salva;
begin
  // Nessuna persistenza nel modello.
end;

function TfrmBase.ChiediConfermaAnnulla: Boolean;
begin
  Result := TfrmConferma.Chiedi(Self, 'Annulla',
    'Annullare le modifiche non salvate?');
end;

procedure TfrmBase.ConfermaClick(Sender: TObject);
var
  LMessaggio: string;
begin
  if not Valida(LMessaggio) then
  begin
    TfrmConferma.Avvisa(Self, 'Dati non validi', LMessaggio);
    Exit;
  end;

  Salva;
  ModalResult := mrOk;
end;

procedure TfrmBase.AnnullaClick(Sender: TObject);
begin
  if ChiediConfermaAnnulla then
    ModalResult := mrCancel;
end;

procedure TfrmBase.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      ConfermaClick(FBtnConferma);
    #27:
      AnnullaClick(FBtnAnnulla);
  else
    Exit;
  end;
  Key := #0;
end;

function TfrmBase.GetTitolo: string;
begin
  Result := lblTitolo.Caption;
end;

procedure TfrmBase.SetTitolo(const AValue: string);
begin
  lblTitolo.Caption := AValue;
  Caption := AValue;
end;

function TfrmBase.GetDescrizione: string;
begin
  Result := lblDescrizione.Caption;
end;

procedure TfrmBase.SetDescrizione(const AValue: string);
begin
  lblDescrizione.Caption := AValue;
end;

class function TfrmBase.Esegui(AOwner: TComponent): Boolean;
var
  LForm: TfrmBase;
begin
  LForm := Create(AOwner);
  try
    Result := LForm.ShowModal = mrOk;
  finally
    LForm.Free;
  end;
end;

end.
