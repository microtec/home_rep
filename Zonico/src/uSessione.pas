unit uSessione;

{ Utente corrente e permessi caricati al login }

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections;

type
  TPermesso = record
    Lettura, Scrittura, Cancella: Boolean;
  end;

  TSessione = class
  private
    FIdUtente: Integer;
    FUsername: string;
    FNome: string;
    FAdmin: Boolean;
    FPermessi: TDictionary<string, TPermesso>;
    function GetLoggato: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function Login(const AUsername, APassword: string): Boolean;
    procedure Logout;
    function PuoLeggere(const AModulo: string): Boolean;
    function PuoScrivere(const AModulo: string): Boolean;
    function PuoCancellare(const AModulo: string): Boolean;
    property IdUtente: Integer read FIdUtente;
    property Username: string read FUsername;
    property Nome: string read FNome;
    property Admin: Boolean read FAdmin;
    property Loggato: Boolean read GetLoggato;
  end;

var
  Sessione: TSessione;

implementation

uses
  uDM, FireDAC.Comp.Client;

constructor TSessione.Create;
begin
  inherited;
  FPermessi := TDictionary<string, TPermesso>.Create;
end;

destructor TSessione.Destroy;
begin
  FPermessi.Free;
  inherited;
end;

function TSessione.GetLoggato: Boolean;
begin
  Result := FIdUtente > 0;
end;

function TSessione.Login(const AUsername, APassword: string): Boolean;
var
  Q: TFDQuery;
  P: TPermesso;
begin
  Logout;
  Q := DM.NewQuery(
    'SELECT ID, USERNAME, NOME, ADMIN FROM UTENTI ' +
    'WHERE UPPER(USERNAME) = UPPER(:U) AND PASSWORD = :P AND ATTIVO = 1');
  try
    Q.ParamByName('U').AsString := AUsername;
    Q.ParamByName('P').AsString := APassword;
    Q.Open;
    Result := not Q.IsEmpty;
    if not Result then
      Exit;
    FIdUtente := Q.FieldByName('ID').AsInteger;
    FUsername := Q.FieldByName('USERNAME').AsString;
    FNome := Q.FieldByName('NOME').AsString;
    FAdmin := Q.FieldByName('ADMIN').AsInteger = 1;

    Q.Close;
    Q.SQL.Text := 'SELECT MODULO, LETTURA, SCRITTURA, CANCELLA FROM PERMESSI WHERE ID_UTENTE = :ID';
    Q.ParamByName('ID').AsInteger := FIdUtente;
    Q.Open;
    while not Q.Eof do
    begin
      P.Lettura := Q.FieldByName('LETTURA').AsInteger = 1;
      P.Scrittura := Q.FieldByName('SCRITTURA').AsInteger = 1;
      P.Cancella := Q.FieldByName('CANCELLA').AsInteger = 1;
      FPermessi.AddOrSetValue(Q.FieldByName('MODULO').AsString, P);
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TSessione.Logout;
begin
  FIdUtente := 0;
  FUsername := '';
  FNome := '';
  FAdmin := False;
  FPermessi.Clear;
end;

function TSessione.PuoLeggere(const AModulo: string): Boolean;
var
  P: TPermesso;
begin
  Result := FAdmin or (FPermessi.TryGetValue(AModulo, P) and P.Lettura);
end;

function TSessione.PuoScrivere(const AModulo: string): Boolean;
var
  P: TPermesso;
begin
  Result := FAdmin or (FPermessi.TryGetValue(AModulo, P) and P.Scrittura);
end;

function TSessione.PuoCancellare(const AModulo: string): Boolean;
var
  P: TPermesso;
begin
  Result := FAdmin or (FPermessi.TryGetValue(AModulo, P) and P.Cancella);
end;

initialization
  Sessione := TSessione.Create;

finalization
  Sessione.Free;

end.
