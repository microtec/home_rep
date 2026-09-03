unit uUtenteRepository;

interface

uses
  System.Generics.Collections, FireDAC.Comp.Client;

const
  PinLunghezzaMin = 5;
  PinLunghezzaMax = 8;

type
  TArea = record
    Codice: string;
    Descrizione: string;
    Ordine: Integer;
  end;

  TUtente = record
    Id: Integer;
    Username: string;
    NomeCompleto: string;
    IdRuolo: Integer;
    Ruolo: string;
    Aree: TArray<TArea>;
    function Descrizione: string;
    function HaArea(const ACodice: string): Boolean;
  end;

  TUtenteRepository = class
  private
    FConnection: TFDConnection;
    function CaricaAree(AIdRuolo: Integer): TArray<TArea>;
  public
    constructor Create(AConnection: TFDConnection);
    function Autentica(const APin: string; out AUtente: TUtente): Boolean;
    procedure ImpostaPin(AIdUtente: Integer; const APin: string);
  end;

// Il PIN deve contenere solo cifre, da PinLunghezzaMin a PinLunghezzaMax.
function PinValido(const APin: string; out AErrore: string): Boolean;

implementation

uses
  System.SysUtils, System.Character;

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

{ TUtente }

function TUtente.Descrizione: string;
begin
  if NomeCompleto <> '' then
    Result := NomeCompleto
  else
    Result := Username;
end;

function TUtente.HaArea(const ACodice: string): Boolean;
var
  LArea: TArea;
begin
  for LArea in Aree do
    if SameText(LArea.Codice, ACodice) then
      Exit(True);
  Result := False;
end;

{ TUtenteRepository }

constructor TUtenteRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TUtenteRepository.CaricaAree(AIdRuolo: Integer): TArray<TArea>;
var
  LQuery: TFDQuery;
  LAree: TList<TArea>;
  LArea: TArea;
begin
  LAree := TList<TArea>.Create;
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text :=
      'SELECT A.AR_CODICE, A.AR_DESCRIZIONE, A.AR_ORDINE' +
      '  FROM AREE A' +
      '  JOIN PERMESSI_AREA P ON P.PA_CODICE_AREA = A.AR_CODICE' +
      ' WHERE P.PA_ID_RUOLO = :IDRUOLO' +
      ' ORDER BY A.AR_ORDINE';
    LQuery.ParamByName('IDRUOLO').AsInteger := AIdRuolo;
    LQuery.Open;
    while not LQuery.Eof do
    begin
      LArea.Codice := Trim(LQuery.FieldByName('AR_CODICE').AsString);
      LArea.Descrizione := LQuery.FieldByName('AR_DESCRIZIONE').AsString;
      LArea.Ordine := LQuery.FieldByName('AR_ORDINE').AsInteger;
      LAree.Add(LArea);
      LQuery.Next;
    end;
    Result := LAree.ToArray;
  finally
    LQuery.Free;
    LAree.Free;
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
    LQuery.SQL.Text :=
      'SELECT U.ID, U.U_USERNAME, U.U_NOME_COMPLETO, U.U_ID_RUOLO, R.R_DESCRIZIONE' +
      '  FROM UTENTI U' +
      '  JOIN RUOLI R ON R.ID = U.U_ID_RUOLO' +
      ' WHERE U.U_PIN = :PIN AND U.U_ATTIVO = 1';
    LQuery.ParamByName('PIN').AsString := Trim(APin);
    LQuery.Open;
    Result := not LQuery.IsEmpty;
    if not Result then
      Exit;

    AUtente.Id := LQuery.FieldByName('ID').AsInteger;
    AUtente.Username := LQuery.FieldByName('U_USERNAME').AsString;
    AUtente.NomeCompleto := LQuery.FieldByName('U_NOME_COMPLETO').AsString;
    AUtente.IdRuolo := LQuery.FieldByName('U_ID_RUOLO').AsInteger;
    AUtente.Ruolo := LQuery.FieldByName('R_DESCRIZIONE').AsString;
  finally
    LQuery.Free;
  end;
  AUtente.Aree := CaricaAree(AUtente.IdRuolo);
end;

procedure TUtenteRepository.ImpostaPin(AIdUtente: Integer; const APin: string);
var
  LErrore: string;
begin
  if not PinValido(APin, LErrore) then
    raise Exception.Create(LErrore);
  FConnection.ExecSQL('UPDATE UTENTI SET U_PIN = :PIN WHERE ID = :ID',
    [Trim(APin), AIdUtente]);
  FConnection.Commit;
end;

end.
