unit uVendite;

{ Cassa: elenco vendite del giorno + apertura scontrino (uVenditaDett). }

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.DateUtils, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  AdvToolBar, AdvDateTimePicker, AdvPanel, AdvGrid, DBAdvGrid, AdvObj, BaseGrid, AdvUtil;

type
  TfrmVendite = class(TForm)
    ToolBar: TAdvToolBar;
    btnNuova: TAdvToolBarButton;
    btnApri: TAdvToolBarButton;
    btnElimina: TAdvToolBarButton;
    sep1: TAdvToolBarSeparator;
    dtGiorno: TAdvDateTimePicker;
    btnAggiorna: TAdvToolBarButton;
    Grid: TDBAdvGrid;
    pnlBottom: TAdvPanel;
    lblTotale: TLabel;
    DS: TDataSource;
    Q: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNuovaClick(Sender: TObject);
    procedure btnApriClick(Sender: TObject);
    procedure btnEliminaClick(Sender: TObject);
    procedure btnAggiornaClick(Sender: TObject);
    procedure dtGiornoChange(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
  private
    procedure Carica;
  end;

implementation

uses
  uDM, uSessione, uVenditaDett, uStile;

{$R *.dfm}

procedure TfrmVendite.FormCreate(Sender: TObject);
begin
  ApplicaStileMetro(Self);
  Q.Connection := DM.Conn;
  dtGiorno.Date := Date;
  btnNuova.Enabled := Sessione.PuoScrivere('VENDITE');
  btnElimina.Enabled := Sessione.PuoCancellare('VENDITE');
  Grid.PageMode := False;
  Grid.AutoCreateColumns := False;
  Grid.Look := glWin8;
  with Grid.Columns.Add do begin FieldName := 'ID';        Header := 'N.';        Width := 60; end;
  with Grid.Columns.Add do begin FieldName := 'DATA';      Header := 'Ora';       Width := 70; end;
  with Grid.Columns.Add do begin FieldName := 'CLIENTE';   Header := 'Cliente';   Width := 220; end;
  with Grid.Columns.Add do begin FieldName := 'OPERATORE'; Header := 'Operatore'; Width := 150; end;
  with Grid.Columns.Add do begin FieldName := 'PAGAMENTO'; Header := 'Pagamento'; Width := 110; end;
  with Grid.Columns.Add do begin FieldName := 'IMPONIBILE';Header := 'Imponibile';Width := 90; FloatFormat := '%.2f'; end;
  with Grid.Columns.Add do begin FieldName := 'SCONTO';    Header := 'Sconto';    Width := 80; FloatFormat := '%.2f'; end;
  with Grid.Columns.Add do begin FieldName := 'TOTALE';    Header := 'Totale €';  Width := 90; FloatFormat := '%.2f'; end;
  Carica;
end;

procedure TfrmVendite.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmVendite.Carica;
var
  Giorno: TDateTime;
  Tot: Variant;
begin
  Giorno := DateOf(dtGiorno.Date);
  Q.Close;
  Q.SQL.Text :=
    'SELECT V.ID, V.DATA, C.COGNOME||'' ''||COALESCE(C.NOME,'''') AS CLIENTE, O.NOME AS OPERATORE, ' +
    '       P.DESCRIZIONE AS PAGAMENTO, V.IMPONIBILE, V.SCONTO, V.TOTALE ' +
    'FROM VENDITE V ' +
    'LEFT JOIN CLIENTI C ON C.ID = V.ID_CLIENTE ' +
    'LEFT JOIN OPERATORI O ON O.ID = V.ID_OPERATORE ' +
    'LEFT JOIN PAGAMENTI P ON P.CODICE = V.PAGAMENTO ' +
    'WHERE V.DATA >= :D1 AND V.DATA < :D2 ORDER BY V.DATA DESC';
  Q.ParamByName('D1').AsDateTime := Giorno;
  Q.ParamByName('D2').AsDateTime := Giorno + 1;
  Q.Open;
  TDateTimeField(Q.FieldByName('DATA')).DisplayFormat := 'hh:nn';
  Tot := DM.Scalar('SELECT COALESCE(SUM(TOTALE),0) FROM VENDITE WHERE DATA >= :D1 AND DATA < :D2', [Giorno, Giorno + 1]);
  lblTotale.Caption := Format('Vendite: %d   Incasso giornata: € %.2f', [Q.RecordCount, Double(Tot)]);
end;

procedure TfrmVendite.btnNuovaClick(Sender: TObject);
var
  Id: Integer;
begin
  Id := DM.Scalar(
    'INSERT INTO VENDITE (DATA, ID_UTENTE, PAGAMENTO) VALUES (CURRENT_TIMESTAMP, :U, ''CONTANTI'') RETURNING ID',
    [Sessione.IdUtente]);
  if not TfrmVenditaDett.Esegui(Id) then
    DM.ExecSQL('DELETE FROM VENDITE WHERE ID = :ID', [Id]);
  Carica;
end;

procedure TfrmVendite.btnApriClick(Sender: TObject);
begin
  if Q.IsEmpty then
    Exit;
  TfrmVenditaDett.Esegui(Q.FieldByName('ID').AsInteger);
  Carica;
end;

procedure TfrmVendite.GridDblClick(Sender: TObject);
begin
  btnApriClick(Sender);
end;

procedure TfrmVendite.btnEliminaClick(Sender: TObject);
begin
  if Q.IsEmpty then
    Exit;
  if MessageDlg('Eliminare la vendita selezionata?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DM.ExecSQL('DELETE FROM VENDITE WHERE ID = :ID', [Q.FieldByName('ID').AsInteger]);
    Carica;
  end;
end;

procedure TfrmVendite.btnAggiornaClick(Sender: TObject);
begin
  Carica;
end;

procedure TfrmVendite.dtGiornoChange(Sender: TObject);
begin
  Carica;
end;

end.
