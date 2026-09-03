unit uDbFirebird;

interface

uses
  FireDAC.Comp.Client;

// Firebird 2.5 non supporta CREATE ... IF NOT EXISTS: il DDL va condizionato
// interrogando le tabelle di sistema.
function TabellaEsiste(AConnection: TFDConnection; const ANomeTabella: string): Boolean;
function GeneratorEsiste(AConnection: TFDConnection; const ANomeGenerator: string): Boolean;
procedure CreaGenerator(AConnection: TFDConnection; const ANomeGenerator: string);
function ProssimoId(AConnection: TFDConnection; const ANomeGenerator: string): Integer;

implementation

uses
  System.SysUtils;

function ContaOggetti(AConnection: TFDConnection; const ASql, ANome: string): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := AConnection;
    LQuery.SQL.Text := ASql;
    LQuery.ParamByName('NOME').AsString := AnsiUpperCase(ANome);
    LQuery.Open;
    Result := LQuery.Fields[0].AsInteger > 0;
  finally
    LQuery.Free;
  end;
end;

function TabellaEsiste(AConnection: TFDConnection; const ANomeTabella: string): Boolean;
begin
  Result := ContaOggetti(AConnection,
    'SELECT COUNT(*) FROM RDB$RELATIONS WHERE TRIM(RDB$RELATION_NAME) = :NOME',
    ANomeTabella);
end;

function GeneratorEsiste(AConnection: TFDConnection; const ANomeGenerator: string): Boolean;
begin
  Result := ContaOggetti(AConnection,
    'SELECT COUNT(*) FROM RDB$GENERATORS WHERE TRIM(RDB$GENERATOR_NAME) = :NOME',
    ANomeGenerator);
end;

procedure CreaGenerator(AConnection: TFDConnection; const ANomeGenerator: string);
begin
  if GeneratorEsiste(AConnection, ANomeGenerator) then
    Exit;
  AConnection.ExecSQL('CREATE GENERATOR ' + ANomeGenerator);
  AConnection.Commit;
end;

function ProssimoId(AConnection: TFDConnection; const ANomeGenerator: string): Integer;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := AConnection;
    LQuery.SQL.Text := Format('SELECT GEN_ID(%s, 1) FROM RDB$DATABASE', [ANomeGenerator]);
    LQuery.Open;
    Result := LQuery.Fields[0].AsInteger;
  finally
    LQuery.Free;
  end;
end;

end.
