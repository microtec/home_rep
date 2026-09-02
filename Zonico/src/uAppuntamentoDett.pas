unit uAppuntamentoDett;

{ Dialogo inserimento/modifica appuntamento. Lavora direttamente su APPUNTAMENTI
  tramite SQL parametrico; restituisce True se salvato. }

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.DateUtils, System.Variants, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs, Data.DB, FireDAC.Comp.Client,
  AdvEdit, AdvGlowButton, AdvPanel, AdvDateTimePicker, AdvCombo, AdvDBLookupComboBox,
  AdvMemo;

type
  TfrmAppuntamentoDett = class(TForm)
    pnlButtons: TAdvPanel;
    btnOk: TAdvGlowButton;
    btnAnnulla: TAdvGlowButton;
    btnElimina: TAdvGlowButton;
    lblCliente: TLabel;
    lblOperatore: TLabel;
    lblServizio: TLabel;
    lblData: TLabel;
    lblInizio: TLabel;
    lblFine: TLabel;
    lblStato: TLabel;
    lblNote: TLabel;
    cbCliente: TAdvDBLookupComboBox;
    cbOperatore: TAdvDBLookupComboBox;
    cbServizio: TAdvDBLookupComboBox;
    dtData: TAdvDateTimePicker;
    dtInizio: TAdvDateTimePicker;
    dtFine: TAdvDateTimePicker;
    cbStato: TAdvComboBox;
    memNote: TAdvMemo;
    QClienti: TFDQuery;
    QOperatori: TFDQuery;
    QServizi: TFDQuery;
    DSClienti: TDataSource;
    DSOperatori: TDataSource;
    DSServizi: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnEliminaClick(Sender: TObject);
    procedure cbServizioChange(Sender: TObject);
  private
    FId: Integer;
    procedure Carica;
    procedure Salva;
  public
    { AId = 0 per nuovo appuntamento; AInizio/AFine/AIdOperatore usati come default }
    class function Esegui(AId: Integer; AInizio, AFine: TDateTime; AIdOperatore: Integer): Boolean;
  end;

implementation

uses
  uDM, uSessione, uStile;

{$R *.dfm}

const
  STATI: array[0..5] of string = ('PRENOTATO', 'CONFERMATO', 'ARRIVATO', 'COMPLETATO', 'ANNULLATO', 'NO_SHOW');

class function TfrmAppuntamentoDett.Esegui(AId: Integer; AInizio, AFine: TDateTime;
  AIdOperatore: Integer): Boolean;
var
  F: TfrmAppuntamentoDett;
begin
  F := TfrmAppuntamentoDett.Create(nil);
  try
    F.FId := AId;
    if AId > 0 then
      F.Carica
    else
    begin
      F.dtData.Date := DateOf(AInizio);
      F.dtInizio.Time := TimeOf(AInizio);
      F.dtFine.Time := TimeOf(AFine);
      if AIdOperatore > 0 then
        F.cbOperatore.KeyValue := AIdOperatore;
      F.cbStato.ItemIndex := 0;
      F.btnElimina.Visible := False;
    end;
    F.btnOk.Enabled := Sessione.PuoScrivere('AGENDA');
    F.btnElimina.Enabled := Sessione.PuoCancellare('AGENDA');
    Result := F.ShowModal in [mrOk, mrAbort];
  finally
    F.Free;
  end;
end;

procedure TfrmAppuntamentoDett.FormCreate(Sender: TObject);
var
  S: string;
begin
  ApplicaStileMetro(Self);
  QClienti.Connection := DM.Conn;
  QOperatori.Connection := DM.Conn;
  QServizi.Connection := DM.Conn;
  QClienti.SQL.Text := 'SELECT ID, COGNOME||'' ''||COALESCE(NOME,'''') AS NOMINATIVO, CELLULARE FROM CLIENTI WHERE ATTIVO = 1 ORDER BY COGNOME, NOME';
  QOperatori.SQL.Text := 'SELECT ID, NOME FROM OPERATORI WHERE ATTIVO = 1 ORDER BY NOME';
  QServizi.SQL.Text := 'SELECT ID, DESCRIZIONE, DURATA_MIN, PREZZO FROM SERVIZI WHERE ATTIVO = 1 ORDER BY DESCRIZIONE';
  QClienti.Open;
  QOperatori.Open;
  QServizi.Open;
  cbStato.Items.Clear;
  for S in STATI do
    cbStato.Items.Add(S);
end;

procedure TfrmAppuntamentoDett.Carica;
var
  Q: TFDQuery;
begin
  Q := DM.NewQuery('SELECT * FROM APPUNTAMENTI WHERE ID = :ID');
  try
    Q.ParamByName('ID').AsInteger := FId;
    Q.Open;
    dtData.Date := DateOf(Q.FieldByName('INIZIO').AsDateTime);
    dtInizio.Time := TimeOf(Q.FieldByName('INIZIO').AsDateTime);
    dtFine.Time := TimeOf(Q.FieldByName('FINE').AsDateTime);
    if not Q.FieldByName('ID_CLIENTE').IsNull then
      cbCliente.KeyValue := Q.FieldByName('ID_CLIENTE').AsInteger;
    if not Q.FieldByName('ID_OPERATORE').IsNull then
      cbOperatore.KeyValue := Q.FieldByName('ID_OPERATORE').AsInteger;
    if not Q.FieldByName('ID_SERVIZIO').IsNull then
      cbServizio.KeyValue := Q.FieldByName('ID_SERVIZIO').AsInteger;
    cbStato.ItemIndex := cbStato.Items.IndexOf(Q.FieldByName('STATO').AsString);
    memNote.Lines.Text := Q.FieldByName('NOTE').AsString;
  finally
    Q.Free;
  end;
end;

procedure TfrmAppuntamentoDett.cbServizioChange(Sender: TObject);
var
  Durata: Integer;
begin
  if QServizi.Locate('ID', cbServizio.KeyValue, []) then
  begin
    Durata := QServizi.FieldByName('DURATA_MIN').AsInteger;
    dtFine.Time := IncMinute(dtInizio.Time, Durata);
  end;
end;

procedure TfrmAppuntamentoDett.Salva;
var
  Inizio, Fine: TDateTime;
  Q: TFDQuery;
begin
  Inizio := DateOf(dtData.Date) + TimeOf(dtInizio.Time);
  Fine := DateOf(dtData.Date) + TimeOf(dtFine.Time);
  if Fine <= Inizio then
    raise Exception.Create('L''ora di fine deve essere successiva all''inizio.');
  if cbOperatore.KeyValue = Null then
    raise Exception.Create('Selezionare un operatore.');

  if FId = 0 then
    Q := DM.NewQuery(
      'INSERT INTO APPUNTAMENTI (INIZIO, FINE, ID_CLIENTE, ID_OPERATORE, ID_SERVIZIO, STATO, NOTE) ' +
      'VALUES (:INIZIO, :FINE, :CLI, :OPE, :SER, :STATO, :NOTE)')
  else
    Q := DM.NewQuery(
      'UPDATE APPUNTAMENTI SET INIZIO = :INIZIO, FINE = :FINE, ID_CLIENTE = :CLI, ID_OPERATORE = :OPE, ' +
      'ID_SERVIZIO = :SER, STATO = :STATO, NOTE = :NOTE WHERE ID = :ID');
  try
    Q.ParamByName('INIZIO').AsDateTime := Inizio;
    Q.ParamByName('FINE').AsDateTime := Fine;
    Q.ParamByName('CLI').Value := cbCliente.KeyValue;
    Q.ParamByName('OPE').Value := cbOperatore.KeyValue;
    Q.ParamByName('SER').Value := cbServizio.KeyValue;
    Q.ParamByName('STATO').AsString := STATI[cbStato.ItemIndex];
    Q.ParamByName('NOTE').AsString := Trim(memNote.Lines.Text);
    if FId > 0 then
      Q.ParamByName('ID').AsInteger := FId;
    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TfrmAppuntamentoDett.btnOkClick(Sender: TObject);
begin
  Salva;
  ModalResult := mrOk;
end;

procedure TfrmAppuntamentoDett.btnEliminaClick(Sender: TObject);
begin
  if MessageDlg('Eliminare l''appuntamento?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    DM.ExecSQL('DELETE FROM APPUNTAMENTI WHERE ID = :ID', [FId]);
    ModalResult := mrAbort;
  end;
end;

end.
