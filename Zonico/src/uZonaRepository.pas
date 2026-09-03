unit uZonaRepository;

interface

uses
  FireDAC.Comp.Client, uZona;

type
  TZonaRepository = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    procedure CreaSchema;
    procedure Carica(ADataSet: TFDQuery; const AFiltro: string);
    function Leggi(AId: Integer): TZona;
    function Inserisci(const AZona: TZona): Integer;
    procedure Aggiorna(const AZona: TZona);
    procedure Elimina(AId: Integer);
    function EsisteCodice(const ACodice: string; AEscludiId: Integer): Boolean;
  end;

implementation

uses
  System.SysUtils, uDbFirebird;

{ TZonaRepository }

constructor TZonaRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

procedure TZonaRepository.CreaSchema;
begin
  if not TabellaEsiste(FConnection, 'ZONE') then
  begin
    FConnection.ExecSQL(
      'CREATE TABLE ZONE (' +
      '  ID INTEGER NOT NULL,' +
      '  CODICE VARCHAR(20) NOT NULL,' +
      '  DESCRIZIONE VARCHAR(200) NOT NULL,' +
      '  SUPERFICIE DOUBLE PRECISION DEFAULT 0,' +
      '  ATTIVA SMALLINT DEFAULT 1,' +
      '  CONSTRAINT PK_ZONE PRIMARY KEY (ID))');
    FConnection.ExecSQL(
      'CREATE UNIQUE INDEX IDX_ZONE_CODICE ON ZONE (CODICE)');
    FConnection.Commit;
  end;
  CreaGenerator(FConnection, 'GEN_ZONE_ID');
end;

procedure TZonaRepository.Carica(ADataSet: TFDQuery; const AFiltro: string);
begin
  ADataSet.Close;
  ADataSet.Connection := FConnection;
  ADataSet.SQL.Text :=
    'SELECT ID, CODICE, DESCRIZIONE, SUPERFICIE, ATTIVA FROM ZONE' +
    ' WHERE (:FILTRO = '''')' +
    '    OR (UPPER(CODICE) LIKE :LIKEF)' +
    '    OR (UPPER(DESCRIZIONE) LIKE :LIKEF)' +
    ' ORDER BY CODICE';
  ADataSet.ParamByName('FILTRO').AsString := AFiltro;
  ADataSet.ParamByName('LIKEF').AsString := '%' + AnsiUpperCase(AFiltro) + '%';
  ADataSet.Open;
end;

function TZonaRepository.Leggi(AId: Integer): TZona;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text :=
      'SELECT ID, CODICE, DESCRIZIONE, SUPERFICIE, ATTIVA FROM ZONE WHERE ID = :ID';
    LQuery.ParamByName('ID').AsInteger := AId;
    LQuery.Open;
    if LQuery.IsEmpty then
      raise Exception.CreateFmt('Zona %d non trovata.', [AId]);
    Result.Id := LQuery.FieldByName('ID').AsInteger;
    Result.Codice := LQuery.FieldByName('CODICE').AsString;
    Result.Descrizione := LQuery.FieldByName('DESCRIZIONE').AsString;
    Result.Superficie := LQuery.FieldByName('SUPERFICIE').AsFloat;
    Result.Attiva := LQuery.FieldByName('ATTIVA').AsInteger = 1;
  finally
    LQuery.Free;
  end;
end;

function TZonaRepository.Inserisci(const AZona: TZona): Integer;
var
  LQuery: TFDQuery;
begin
  Result := ProssimoId(FConnection, 'GEN_ZONE_ID');
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text :=
      'INSERT INTO ZONE (ID, CODICE, DESCRIZIONE, SUPERFICIE, ATTIVA)' +
      ' VALUES (:ID, :CODICE, :DESCRIZIONE, :SUPERFICIE, :ATTIVA)';
    LQuery.ParamByName('ID').AsInteger := Result;
    LQuery.ParamByName('CODICE').AsString := AZona.Codice;
    LQuery.ParamByName('DESCRIZIONE').AsString := AZona.Descrizione;
    LQuery.ParamByName('SUPERFICIE').AsFloat := AZona.Superficie;
    LQuery.ParamByName('ATTIVA').AsSmallInt := Ord(AZona.Attiva);
    LQuery.ExecSQL;
    FConnection.Commit;
  finally
    LQuery.Free;
  end;
end;

procedure TZonaRepository.Aggiorna(const AZona: TZona);
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text :=
      'UPDATE ZONE SET CODICE = :CODICE, DESCRIZIONE = :DESCRIZIONE,' +
      ' SUPERFICIE = :SUPERFICIE, ATTIVA = :ATTIVA WHERE ID = :ID';
    LQuery.ParamByName('CODICE').AsString := AZona.Codice;
    LQuery.ParamByName('DESCRIZIONE').AsString := AZona.Descrizione;
    LQuery.ParamByName('SUPERFICIE').AsFloat := AZona.Superficie;
    LQuery.ParamByName('ATTIVA').AsSmallInt := Ord(AZona.Attiva);
    LQuery.ParamByName('ID').AsInteger := AZona.Id;
    LQuery.ExecSQL;
    FConnection.Commit;
  finally
    LQuery.Free;
  end;
end;

procedure TZonaRepository.Elimina(AId: Integer);
begin
  FConnection.ExecSQL('DELETE FROM ZONE WHERE ID = :ID', [AId]);
  FConnection.Commit;
end;

function TZonaRepository.EsisteCodice(const ACodice: string; AEscludiId: Integer): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection;
    LQuery.SQL.Text :=
      'SELECT 1 FROM ZONE WHERE UPPER(CODICE) = :CODICE AND ID <> :ID';
    LQuery.ParamByName('CODICE').AsString := AnsiUpperCase(Trim(ACodice));
    LQuery.ParamByName('ID').AsInteger := AEscludiId;
    LQuery.Open;
    Result := not LQuery.IsEmpty;
  finally
    LQuery.Free;
  end;
end;

end.
