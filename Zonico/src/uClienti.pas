unit uClienti;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, FireDAC.Comp.Client,
  AdvToolBar, AdvEdit, AdvPanel, AdvGrid, DBAdvGrid, AdvObj, BaseGrid, AdvUtil,
  uBaseAnag;

type
  TfrmClienti = class(TfrmBaseAnag)
  protected
    function SqlBase: string; override;
    procedure ConfiguraGriglia; override;
    function ModificaRecord: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  uClienteDett;

{$R *.dfm}

constructor TfrmClienti.Create(AOwner: TComponent);
begin
  FModuloCodice := 'CLIENTI';
  FTabella := 'CLIENTI';
  FCampoOrdine := 'COGNOME, NOME';
  FCampiRicerca := 'COGNOME||'' ''||COALESCE(NOME,'''')||'' ''||COALESCE(CELLULARE,'''')||'' ''||COALESCE(TELEFONO,'''')';
  inherited;
  Caption := 'Anagrafica clienti';
end;

function TfrmClienti.SqlBase: string;
begin
  Result := 'SELECT ID, COGNOME, NOME, CELLULARE, TELEFONO, EMAIL, CITTA, DATA_NASCITA, ATTIVO, ' +
            'SESSO, INDIRIZZO, CAP, PROVINCIA, CODICE_FISCALE, CONSENSO_PRIVACY, CONSENSO_MARKETING, NOTE, DATA_INSERIMENTO ' +
            'FROM CLIENTI';
end;

procedure TfrmClienti.ConfiguraGriglia;
var
  I: Integer;
begin
  inherited;
  for I := 0 to Grid.Columns.Count - 1 do
    Grid.Columns[I].Visible := I in [1..8];
  Grid.Columns[1].Header := 'Cognome';      Grid.Columns[1].Width := 160;
  Grid.Columns[2].Header := 'Nome';         Grid.Columns[2].Width := 140;
  Grid.Columns[3].Header := 'Cellulare';    Grid.Columns[3].Width := 120;
  Grid.Columns[4].Header := 'Telefono';     Grid.Columns[4].Width := 110;
  Grid.Columns[5].Header := 'Email';        Grid.Columns[5].Width := 180;
  Grid.Columns[6].Header := 'Città';        Grid.Columns[6].Width := 120;
  Grid.Columns[7].Header := 'Nascita';      Grid.Columns[7].Width := 90;
  Grid.Columns[8].Header := 'Attivo';       Grid.Columns[8].Width := 60;
  Grid.Columns[8].Editor := edCheckBox;
end;

function TfrmClienti.ModificaRecord: Boolean;
begin
  Result := True;
  if Q.State = dsInsert then
  begin
    Q.FieldByName('ATTIVO').AsInteger := 1;
    Q.FieldByName('CONSENSO_PRIVACY').AsInteger := 0;
    Q.FieldByName('CONSENSO_MARKETING').AsInteger := 0;
  end;
  if TfrmClienteDett.Esegui(DS) then
    Q.Post
  else
    Q.Cancel;
  lblStato.Caption := Format('%d record', [Q.RecordCount]);
end;

end.
