unit uDbFirebird;

interface

uses
  FireDAC.Comp.Client;

// Firebird 2.5 non supporta CREATE ... IF NOT EXISTS: la presenza degli oggetti
// va verificata sulle tabelle di sistema.
function TabellaEsiste(AConnection: TFDConnection; const ANomeTabella: string): Boolean;

// Solleva un'eccezione se lo schema di zonico_schema.sql non e' stato caricato.
procedure VerificaSchema(AConnection: TFDConnection);

implementation

uses
  System.SysUtils;

const
  TabelleRichieste: array[0..3] of string = ('RUOLI', 'UTENTI', 'AREE', 'PERMESSI_AREA');

function TabellaEsiste(AConnection: TFDConnection; const ANomeTabella: string): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := AConnection;
    LQuery.SQL.Text :=
      'SELECT COUNT(*) FROM RDB$RELATIONS WHERE TRIM(RDB$RELATION_NAME) = :NOME';
    LQuery.ParamByName('NOME').AsString := AnsiUpperCase(ANomeTabella);
    LQuery.Open;
    Result := LQuery.Fields[0].AsInteger > 0;
  finally
    LQuery.Free;
  end;
end;

procedure VerificaSchema(AConnection: TFDConnection);
var
  LTabella: string;
begin
  for LTabella in TabelleRichieste do
    if not TabellaEsiste(AConnection, LTabella) then
      raise Exception.CreateFmt(
        'Tabella %s mancante: eseguire sql\zonico_schema.sql sul database.',
        [LTabella]);
end;

end.
