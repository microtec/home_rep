unit uUtenti;

{ Gestione utenti e permessi per modulo (lettura / scrittura / cancellazione). }

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  AdvToolBar, AdvEdit, AdvPanel, AdvGrid, DBAdvGrid, AdvObj, BaseGrid, AdvUtil,
  AdvSplitter,
  uBaseAnag;

type
  TfrmUtenti = class(TfrmBaseAnag)
    pnlPermessi: TAdvPanel;
    Splitter: TAdvSplitter;
    GridPerm: TDBAdvGrid;
    DSPerm: TDataSource;
    QPerm: TFDQuery;
    procedure DSDataChange(Sender: TObject; Field: TField);
    procedure GridPermCheckBoxClick(Sender: TObject; ACol, ARow: Integer; State: Boolean);
  private
    procedure CreaPermessiMancanti(AIdUtente: Integer);
    procedure ApriPermessi;
  protected
    procedure ConfiguraGriglia; override;
    procedure PrimaDiSalvare; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  uDM, uSessione;

{$R *.dfm}

constructor TfrmUtenti.Create(AOwner: TComponent);
begin
  FModuloCodice := 'UTENTI';
  FTabella := 'UTENTI';
  FCampoOrdine := 'USERNAME';
  FCampiRicerca := 'USERNAME||'' ''||COALESCE(NOME,'''')';
  inherited;
  Caption := 'Utenti e permessi';
  QPerm.Connection := DM.Conn;
  QPerm.UpdateOptions.UpdateTableName := 'PERMESSI';
  QPerm.UpdateOptions.KeyFields := 'ID_UTENTE;MODULO';
  DS.OnDataChange := DSDataChange;
  ApriPermessi;
end;

procedure TfrmUtenti.ConfiguraGriglia;
begin
  inherited;
  Grid.Columns[0].Visible := False;
  Grid.Columns[1].Header := 'Username';  Grid.Columns[1].Width := 140;
  Grid.Columns[2].Header := 'Password';  Grid.Columns[2].Width := 140;
  Grid.Columns[3].Header := 'Nome';      Grid.Columns[3].Width := 220;
  Grid.Columns[4].Header := 'Admin';     Grid.Columns[4].Width := 60;
  Grid.Columns[4].Editor := edCheckBox;
  Grid.Columns[5].Header := 'Attivo';    Grid.Columns[5].Width := 60;
  Grid.Columns[5].Editor := edCheckBox;

  GridPerm.DataSource := DSPerm;
  GridPerm.PageMode := False;
  GridPerm.AutoCreateColumns := False;
  GridPerm.Look := glWin8;
  GridPerm.Options := GridPerm.Options + [goEditing];
  with GridPerm.Columns.Add do begin FieldName := 'DESCRIZIONE'; Header := 'Modulo'; Width := 260; ReadOnly := True; end;
  with GridPerm.Columns.Add do begin FieldName := 'LETTURA';   Header := 'Lettura';   Width := 90; Editor := edCheckBox; CheckTrue := '1'; CheckFalse := '0'; end;
  with GridPerm.Columns.Add do begin FieldName := 'SCRITTURA'; Header := 'Scrittura'; Width := 90; Editor := edCheckBox; CheckTrue := '1'; CheckFalse := '0'; end;
  with GridPerm.Columns.Add do begin FieldName := 'CANCELLA';  Header := 'Cancella';  Width := 90; Editor := edCheckBox; CheckTrue := '1'; CheckFalse := '0'; end;
  GridPerm.Enabled := Sessione.PuoScrivere(FModuloCodice);
end;

procedure TfrmUtenti.CreaPermessiMancanti(AIdUtente: Integer);
begin
  DM.ExecSQL(
    'INSERT INTO PERMESSI (ID_UTENTE, MODULO, LETTURA, SCRITTURA, CANCELLA) ' +
    'SELECT :ID, M.CODICE, 0, 0, 0 FROM MODULI M ' +
    'WHERE NOT EXISTS (SELECT 1 FROM PERMESSI P WHERE P.ID_UTENTE = :ID2 AND P.MODULO = M.CODICE)',
    [AIdUtente, AIdUtente]);
end;

procedure TfrmUtenti.ApriPermessi;
var
  IdUtente: Integer;
begin
  QPerm.Close;
  if Q.IsEmpty or (Q.State = dsInsert) then
    Exit;
  IdUtente := Q.FieldByName('ID').AsInteger;
  CreaPermessiMancanti(IdUtente);
  QPerm.SQL.Text :=
    'SELECT P.ID_UTENTE, P.MODULO, M.DESCRIZIONE, P.LETTURA, P.SCRITTURA, P.CANCELLA ' +
    'FROM PERMESSI P JOIN MODULI M ON M.CODICE = P.MODULO ' +
    'WHERE P.ID_UTENTE = :ID ORDER BY M.DESCRIZIONE';
  QPerm.ParamByName('ID').AsInteger := IdUtente;
  QPerm.Open;
  QPerm.FieldByName('DESCRIZIONE').ReadOnly := True;
  QPerm.FieldByName('ID_UTENTE').ReadOnly := True;
  QPerm.FieldByName('MODULO').ReadOnly := True;
  pnlPermessi.Caption.Text := 'Permessi di: ' + Q.FieldByName('USERNAME').AsString;
end;

procedure TfrmUtenti.DSDataChange(Sender: TObject; Field: TField);
begin
  if (Field = nil) and not (Q.State in dsEditModes) then
    ApriPermessi;
end;

procedure TfrmUtenti.GridPermCheckBoxClick(Sender: TObject; ACol, ARow: Integer; State: Boolean);
begin
  if QPerm.State in dsEditModes then
    QPerm.Post;
end;

procedure TfrmUtenti.PrimaDiSalvare;
begin
  inherited;
  if Trim(Q.FieldByName('USERNAME').AsString) = '' then
    raise Exception.Create('Username obbligatorio.');
  if Trim(Q.FieldByName('PASSWORD').AsString) = '' then
    raise Exception.Create('Password obbligatoria.');
  if Q.FieldByName('ADMIN').IsNull then
    Q.FieldByName('ADMIN').AsInteger := 0;
  if Q.FieldByName('ATTIVO').IsNull then
    Q.FieldByName('ATTIVO').AsInteger := 1;
end;

end.
