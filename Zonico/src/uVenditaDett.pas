unit uVenditaDett;

{ Scontrino: testata (cliente, operatore, pagamento, sconto) + righe servizi/prodotti.
  Le righe sono salvate subito su VENDITE_RIGHE; il trigger ricalcola i totali. }

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Variants, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  AdvEdit, AdvGlowButton, AdvPanel, AdvDBLookupComboBox, AdvGrid, DBAdvGrid, AdvObj,
  BaseGrid, AdvUtil;

type
  TfrmVenditaDett = class(TForm)
    pnlTop: TAdvPanel;
    lblCliente: TLabel;
    lblOperatore: TLabel;
    lblPagamento: TLabel;
    cbCliente: TAdvDBLookupComboBox;
    cbOperatore: TAdvDBLookupComboBox;
    cbPagamento: TAdvDBLookupComboBox;
    pnlAggiungi: TAdvPanel;
    lblServizio: TLabel;
    lblProdotto: TLabel;
    cbServizio: TAdvDBLookupComboBox;
    cbProdotto: TAdvDBLookupComboBox;
    btnAddServizio: TAdvGlowButton;
    btnAddProdotto: TAdvGlowButton;
    btnRimuoviRiga: TAdvGlowButton;
    GridRighe: TDBAdvGrid;
    pnlBottom: TAdvPanel;
    lblImponibile: TLabel;
    lblSconto: TLabel;
    edSconto: TAdvEdit;
    lblTotale: TLabel;
    btnChiudi: TAdvGlowButton;
    btnAnnulla: TAdvGlowButton;
    QRighe: TFDQuery;
    DSRighe: TDataSource;
    QClienti: TFDQuery;
    QOperatori: TFDQuery;
    QPagamenti: TFDQuery;
    QServizi: TFDQuery;
    QProdotti: TFDQuery;
    DSClienti: TDataSource;
    DSOperatori: TDataSource;
    DSPagamenti: TDataSource;
    DSServizi: TDataSource;
    DSProdotti: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnAddServizioClick(Sender: TObject);
    procedure btnAddProdottoClick(Sender: TObject);
    procedure btnRimuoviRigaClick(Sender: TObject);
    procedure btnChiudiClick(Sender: TObject);
    procedure edScontoExit(Sender: TObject);
    procedure QRigheAfterPost(DataSet: TDataSet);
    procedure QRigheAfterDelete(DataSet: TDataSet);
  private
    FId: Integer;
    procedure CaricaTestata;
    procedure AggiornaTotali;
    procedure ApriRighe;
    procedure AggiungiRiga(const ATipo: string; AIdRif: Integer; const ADescr: string; APrezzo: Double);
  public
    class function Esegui(AId: Integer): Boolean;
  end;

implementation

uses
  uDM, uSessione, uStile;

{$R *.dfm}

class function TfrmVenditaDett.Esegui(AId: Integer): Boolean;
var
  F: TfrmVenditaDett;
begin
  F := TfrmVenditaDett.Create(nil);
  try
    F.FId := AId;
    F.CaricaTestata;
    F.ApriRighe;
    Result := F.ShowModal = mrOk;
  finally
    F.Free;
  end;
end;

procedure TfrmVenditaDett.FormCreate(Sender: TObject);
begin
  ApplicaStileMetro(Self);
  QClienti.Connection := DM.Conn;
  QOperatori.Connection := DM.Conn;
  QPagamenti.Connection := DM.Conn;
  QServizi.Connection := DM.Conn;
  QProdotti.Connection := DM.Conn;
  QRighe.Connection := DM.Conn;
  QClienti.SQL.Text := 'SELECT ID, COGNOME||'' ''||COALESCE(NOME,'''') AS NOMINATIVO FROM CLIENTI WHERE ATTIVO = 1 ORDER BY COGNOME, NOME';
  QOperatori.SQL.Text := 'SELECT ID, NOME FROM OPERATORI WHERE ATTIVO = 1 ORDER BY NOME';
  QPagamenti.SQL.Text := 'SELECT CODICE, DESCRIZIONE FROM PAGAMENTI ORDER BY DESCRIZIONE';
  QServizi.SQL.Text := 'SELECT ID, DESCRIZIONE, PREZZO FROM SERVIZI WHERE ATTIVO = 1 ORDER BY DESCRIZIONE';
  QProdotti.SQL.Text := 'SELECT ID, DESCRIZIONE, PREZZO, GIACENZA FROM PRODOTTI WHERE ATTIVO = 1 ORDER BY DESCRIZIONE';
  QClienti.Open; QOperatori.Open; QPagamenti.Open; QServizi.Open; QProdotti.Open;

  QRighe.UpdateOptions.UpdateTableName := 'VENDITE_RIGHE';
  QRighe.UpdateOptions.KeyFields := 'ID';

  GridRighe.PageMode := False;
  GridRighe.AutoCreateColumns := False;
  GridRighe.Look := glWin8;
  GridRighe.Options := GridRighe.Options + [goEditing];
  with GridRighe.Columns.Add do begin FieldName := 'TIPO';        Header := 'T';           Width := 30;  ReadOnly := True; end;
  with GridRighe.Columns.Add do begin FieldName := 'DESCRIZIONE'; Header := 'Descrizione'; Width := 330; end;
  with GridRighe.Columns.Add do begin FieldName := 'QUANTITA';    Header := 'Q.tà';        Width := 60;  Editor := edSpinEdit; end;
  with GridRighe.Columns.Add do begin FieldName := 'PREZZO';      Header := 'Prezzo €';    Width := 90;  Editor := edFloat; FloatFormat := '%.2f'; end;

  pnlAggiungi.Enabled := Sessione.PuoScrivere('VENDITE');
  GridRighe.Enabled := pnlAggiungi.Enabled;
  edSconto.Enabled := pnlAggiungi.Enabled;
end;

procedure TfrmVenditaDett.CaricaTestata;
var
  Q: TFDQuery;
begin
  Q := DM.NewQuery('SELECT * FROM VENDITE WHERE ID = :ID');
  try
    Q.ParamByName('ID').AsInteger := FId;
    Q.Open;
    Caption := Format('Vendita n. %d del %s', [FId, FormatDateTime('dd/mm/yyyy hh:nn', Q.FieldByName('DATA').AsDateTime)]);
    if not Q.FieldByName('ID_CLIENTE').IsNull then
      cbCliente.KeyValue := Q.FieldByName('ID_CLIENTE').AsInteger;
    if not Q.FieldByName('ID_OPERATORE').IsNull then
      cbOperatore.KeyValue := Q.FieldByName('ID_OPERATORE').AsInteger;
    if not Q.FieldByName('PAGAMENTO').IsNull then
      cbPagamento.KeyValue := Q.FieldByName('PAGAMENTO').AsString;
    edSconto.FloatValue := Q.FieldByName('SCONTO').AsFloat;
  finally
    Q.Free;
  end;
  AggiornaTotali;
end;

procedure TfrmVenditaDett.ApriRighe;
begin
  QRighe.Close;
  QRighe.SQL.Text := 'SELECT ID, ID_VENDITA, TIPO, ID_SERVIZIO, ID_PRODOTTO, DESCRIZIONE, QUANTITA, PREZZO ' +
                     'FROM VENDITE_RIGHE WHERE ID_VENDITA = :ID ORDER BY ID';
  QRighe.ParamByName('ID').AsInteger := FId;
  QRighe.Open;
end;

procedure TfrmVenditaDett.AggiornaTotali;
var
  Q: TFDQuery;
begin
  Q := DM.NewQuery('SELECT IMPONIBILE, SCONTO, TOTALE FROM VENDITE WHERE ID = :ID');
  try
    Q.ParamByName('ID').AsInteger := FId;
    Q.Open;
    lblImponibile.Caption := Format('Imponibile: € %.2f', [Q.FieldByName('IMPONIBILE').AsFloat]);
    lblTotale.Caption := Format('TOTALE: € %.2f', [Q.FieldByName('TOTALE').AsFloat]);
  finally
    Q.Free;
  end;
end;

procedure TfrmVenditaDett.AggiungiRiga(const ATipo: string; AIdRif: Integer;
  const ADescr: string; APrezzo: Double);
var
  Q: TFDQuery;
begin
  Q := DM.NewQuery(
    'INSERT INTO VENDITE_RIGHE (ID_VENDITA, TIPO, ID_SERVIZIO, ID_PRODOTTO, DESCRIZIONE, QUANTITA, PREZZO) ' +
    'VALUES (:V, :T, :S, :P, :D, 1, :PR)');
  try
    Q.ParamByName('V').AsInteger := FId;
    Q.ParamByName('T').AsString := ATipo;
    if ATipo = 'S' then
    begin
      Q.ParamByName('S').AsInteger := AIdRif;
      Q.ParamByName('P').Clear;
    end
    else
    begin
      Q.ParamByName('S').Clear;
      Q.ParamByName('P').AsInteger := AIdRif;
    end;
    Q.ParamByName('D').AsString := ADescr;
    Q.ParamByName('PR').AsFloat := APrezzo;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
  ApriRighe;
  QRighe.Last;
  AggiornaTotali;
end;

procedure TfrmVenditaDett.btnAddServizioClick(Sender: TObject);
begin
  if VarIsNull(cbServizio.KeyValue) then
    Exit;
  if QServizi.Locate('ID', cbServizio.KeyValue, []) then
    AggiungiRiga('S', QServizi.FieldByName('ID').AsInteger,
      QServizi.FieldByName('DESCRIZIONE').AsString, QServizi.FieldByName('PREZZO').AsFloat);
end;

procedure TfrmVenditaDett.btnAddProdottoClick(Sender: TObject);
begin
  if VarIsNull(cbProdotto.KeyValue) then
    Exit;
  if QProdotti.Locate('ID', cbProdotto.KeyValue, []) then
    AggiungiRiga('P', QProdotti.FieldByName('ID').AsInteger,
      QProdotti.FieldByName('DESCRIZIONE').AsString, QProdotti.FieldByName('PREZZO').AsFloat);
end;

procedure TfrmVenditaDett.btnRimuoviRigaClick(Sender: TObject);
begin
  if not QRighe.IsEmpty then
    QRighe.Delete;
end;

procedure TfrmVenditaDett.QRigheAfterPost(DataSet: TDataSet);
begin
  AggiornaTotali;
end;

procedure TfrmVenditaDett.QRigheAfterDelete(DataSet: TDataSet);
begin
  AggiornaTotali;
end;

procedure TfrmVenditaDett.edScontoExit(Sender: TObject);
begin
  DM.ExecSQL('UPDATE VENDITE SET SCONTO = :S, TOTALE = IMPONIBILE - :S2 WHERE ID = :ID',
    [edSconto.FloatValue, edSconto.FloatValue, FId]);
  AggiornaTotali;
end;

procedure TfrmVenditaDett.btnChiudiClick(Sender: TObject);
begin
  if QRighe.State in dsEditModes then
    QRighe.Post;
  if QRighe.IsEmpty then
  begin
    MessageDlg('Inserire almeno una riga.', mtWarning, [mbOK], 0);
    Exit;
  end;
  DM.ExecSQL(
    'UPDATE VENDITE SET ID_CLIENTE = :C, ID_OPERATORE = :O, PAGAMENTO = :P, SCONTO = :S, ' +
    'TOTALE = IMPONIBILE - :S2 WHERE ID = :ID',
    [cbCliente.KeyValue, cbOperatore.KeyValue, cbPagamento.KeyValue,
     edSconto.FloatValue, edSconto.FloatValue, FId]);
  { scarico magazzino prodotti, solo alla prima chiusura }
  if DM.Scalar('SELECT CHIUSA FROM VENDITE WHERE ID = :ID', [FId]) = 0 then
  begin
    DM.ExecSQL(
      'UPDATE PRODOTTI P SET P.GIACENZA = P.GIACENZA - ' +
      '(SELECT COALESCE(SUM(R.QUANTITA),0) FROM VENDITE_RIGHE R WHERE R.ID_VENDITA = :V AND R.ID_PRODOTTO = P.ID AND R.TIPO = ''P'') ' +
      'WHERE EXISTS (SELECT 1 FROM VENDITE_RIGHE R2 WHERE R2.ID_VENDITA = :V2 AND R2.ID_PRODOTTO = P.ID)',
      [FId, FId]);
    DM.ExecSQL('UPDATE VENDITE SET CHIUSA = 1 WHERE ID = :ID', [FId]);
  end;
  ModalResult := mrOk;
end;

end.
