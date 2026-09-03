unit uUtenteRepository;

interface

uses
  FireDAC.Comp.Client;

const
  PinLunghezzaMin = 5;
  PinLunghezzaMax = 8;

type
  TUtente = record
    Id: Integer;
    Nome: string;
  end;

  TUtenteRepository = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    procedure CreaSchema;
    function Autentica(const APin: string; out AUtente: TUtente): Boolean;
    procedure ImpostaPin(AIdUtente: Integer; const APin: string);
  end;

// Il PIN deve contenere solo cifre, da PinLunghezzaMin a PinLunghezzaMax.
function PinValido(const APin: string; out AErrore: string): Boolean;

implementation

uses
  System.SysUtils, System.Character, uDbFirebird;

const
  UtenteIniziale = 'Amministratore';
  PinIniziale = '12345';

function PinValido(const APin: string; out AErrore: string): Boolean;
var
  LCarattere: Char;
begin
  AErrore := '';
  for LCarattere in APin do
    if not LCarattere.IsDigit then
    begin
      AErrore := 'Il PIN puo'' contenere solo cifre.';
      Exit(False);
    end;

  if (Length(APin) < PinLunghezzaMin) or (Length(APin) > PinLunghezzaMax) then
    AErrore := Format('Il PIN deve avere da %d a %d cifre.',
      [PinLunghezzaMin, PinLunghezzaMax]);

  Result := AErrore = '';
end;

{ TUtenteRepository }

constructor TUtenteRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

procedure TUtenteRepository.CreaSchema;
var
  LQuery: TFDQuery;
begin
  if not TabellaEsiste(FConnection, 'UTENTI') then
  begin
    FConnection.ExecSQL(
      'CREATE TABLE UTENTI (' +
      '  ID INTEGER NOT NULL,' +
      '  NOME VARCHAR(120) NOT NULL,' +
      '  PIN VARCHAR(8) NOT NULL,' +
      '  CONSTRAINT PK_UTENTI PRIMARY KEY (ID))');
    FConnection.ExecSQL('CREATE UNIQUE INDEX IDX_UTENTI_PIN ON UTENTI (PIN)');
    FConnection.Commit;
  end;
  CreaGenerator(FConnection, 'GEN_UTENTI_ID');

  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text := 'SELECT COUNT(*) FROM UTENTI';
    LQuery.Open;
    if LQuery.Fields[0].AsInteger = 0 then
    begin
      FConnection.ExecSQL('INSERT INTO UTENTI (ID, NOME, PIN) VALUES (:I, :N, :P)',
        [ProssimoId(FConnection, 'GEN_UTENTI_ID'), UtenteIniziale, PinIniziale]);
      FConnection.Commit;
    end;
  finally
    LQuery.Free;
  end;
end;

function TUtenteRepository.Autentica(const APin: string; out AUtente: TUtente): Boolean;
var
  LQuery: TFDQuery;
begin
  AUtente := Default(TUtente);
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text := 'SELECT ID, NOME FROM UTENTI WHERE PIN = :P';
    LQuery.ParamByName('P').AsString := Trim(APin);
    LQuery.Open;
    Result := not LQuery.IsEmpty;
    if Result then
    begin
      AUtente.Id := LQuery.FieldByName('ID').AsInteger;
      AUtente.Nome := LQuery.FieldByName('NOME').AsString;
    end;
  finally
    LQuery.Free;
  end;
end;

procedure TUtenteRepository.ImpostaPin(AIdUtente: Integer; const APin: string);
var
  LErrore: string;
begin
  if not PinValido(APin, LErrore) then
    raise Exception.Create(LErrore);
  FConnection.ExecSQL('UPDATE UTENTI SET PIN = :P WHERE ID = :I', [Trim(APin), AIdUtente]);
  FConnection.Commit;
end;

end.
