unit uBaseAnag;

{ Form base per anagrafiche: griglia TMS + toolbar + ricerca.
  Le form derivate impostano ModuloCodice, TabellaSQL e configurano la griglia
  in ConfiguraGriglia. }

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param,
  AdvToolBar, AdvToolBarStylers, AdvEdit, AdvPanel, AdvGrid, DBAdvGrid, AdvObj,
  BaseGrid, AdvUtil, AdvNavBar;

type
  TfrmBaseAnag = class(TForm)
    ToolBar: TAdvToolBar;
    btnNuovo: TAdvToolBarButton;
    btnModifica: TAdvToolBarButton;
    btnElimina: TAdvToolBarButton;
    btnSalva: TAdvToolBarButton;
    btnAnnulla: TAdvToolBarButton;
    btnAggiorna: TAdvToolBarButton;
    sepRicerca: TAdvToolBarSeparator;
    edRicerca: TAdvEdit;
    Grid: TDBAdvGrid;
    DS: TDataSource;
    Q: TFDQuery;
    pnlBottom: TAdvPanel;
    lblStato: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNuovoClick(Sender: TObject);
    procedure btnModificaClick(Sender: TObject);
    procedure btnEliminaClick(Sender: TObject);
    procedure btnSalvaClick(Sender: TObject);
    procedure btnAnnullaClick(Sender: TObject);
    procedure btnAggiornaClick(Sender: TObject);
    procedure edRicercaChange(Sender: TObject);
    procedure DSStateChange(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
  protected
    FModuloCodice: string;
    FTabella: string;
    FCampoOrdine: string;
    FCampiRicerca: string;      // es. 'COGNOME||'' ''||NOME'
    procedure ConfiguraGriglia; virtual;
    procedure ApriDataset; virtual;
    procedure ApplicaPermessi; virtual;
    procedure PrimaDiSalvare; virtual;
    function SqlBase: string; virtual;
    function ModificaRecord: Boolean; virtual;   // True se usa form di dettaglio
  public
    property ModuloCodice: string read FModuloCodice;
  end;

implementation

uses
  uDM, uSessione;

{$R *.dfm}

procedure TfrmBaseAnag.FormCreate(Sender: TObject);
begin
  Q.Connection := DM.Conn;
  Q.UpdateOptions.UpdateTableName := FTabella;
  Q.UpdateOptions.KeyFields := 'ID';
  Q.UpdateOptions.AutoIncFields := '';
  Q.UpdateOptions.RefreshMode := rmAll;
  Grid.DataSource := DS;
  ApriDataset;
  ConfiguraGriglia;
  ApplicaPermessi;
end;

procedure TfrmBaseAnag.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Q.State in dsEditModes then
    Q.Cancel;
  Action := caFree;
end;

function TfrmBaseAnag.SqlBase: string;
begin
  Result := 'SELECT * FROM ' + FTabella;
end;

procedure TfrmBaseAnag.ApriDataset;
var
  SQL: string;
begin
  Q.Close;
  SQL := SqlBase;
  if (FCampiRicerca <> '') and (Trim(edRicerca.Text) <> '') then
  begin
    SQL := SQL + ' WHERE UPPER(' + FCampiRicerca + ') LIKE :RIC';
    Q.SQL.Text := SQL + ' ORDER BY ' + FCampoOrdine;
    Q.ParamByName('RIC').AsString := '%' + UpperCase(Trim(edRicerca.Text)) + '%';
  end
  else
    Q.SQL.Text := SQL + ' ORDER BY ' + FCampoOrdine;
  Q.Open;
  lblStato.Caption := Format('%d record', [Q.RecordCount]);
end;

procedure TfrmBaseAnag.ConfiguraGriglia;
begin
  Grid.Options := Grid.Options - [goEditing];
  Grid.PageMode := False;
  Grid.AutoCreateColumns := True;
  Grid.ShowUnicode := True;
  Grid.Look := glOffice2019White;
  Grid.FixedRowHeight := 26;
  Grid.DefaultRowHeight := 24;
end;

procedure TfrmBaseAnag.ApplicaPermessi;
begin
  btnNuovo.Enabled := Sessione.PuoScrivere(FModuloCodice);
  btnModifica.Enabled := Sessione.PuoScrivere(FModuloCodice);
  btnElimina.Enabled := Sessione.PuoCancellare(FModuloCodice);
end;

function TfrmBaseAnag.ModificaRecord: Boolean;
begin
  Result := False;
end;

procedure TfrmBaseAnag.PrimaDiSalvare;
begin
end;

procedure TfrmBaseAnag.btnNuovoClick(Sender: TObject);
begin
  Q.Append;
  if ModificaRecord then
    Exit;
  Grid.Options := Grid.Options + [goEditing];
  Grid.SetFocus;
end;

procedure TfrmBaseAnag.btnModificaClick(Sender: TObject);
begin
  if Q.IsEmpty then
    Exit;
  Q.Edit;
  if ModificaRecord then
    Exit;
  Grid.Options := Grid.Options + [goEditing];
  Grid.SetFocus;
end;

procedure TfrmBaseAnag.GridDblClick(Sender: TObject);
begin
  if btnModifica.Enabled then
    btnModificaClick(Sender);
end;

procedure TfrmBaseAnag.btnEliminaClick(Sender: TObject);
begin
  if Q.IsEmpty then
    Exit;
  if MessageDlg('Eliminare il record selezionato?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Q.Delete;
    lblStato.Caption := Format('%d record', [Q.RecordCount]);
  end;
end;

procedure TfrmBaseAnag.btnSalvaClick(Sender: TObject);
begin
  if Q.State in dsEditModes then
  begin
    PrimaDiSalvare;
    Q.Post;
  end;
  Grid.Options := Grid.Options - [goEditing];
end;

procedure TfrmBaseAnag.btnAnnullaClick(Sender: TObject);
begin
  if Q.State in dsEditModes then
    Q.Cancel;
  Grid.Options := Grid.Options - [goEditing];
end;

procedure TfrmBaseAnag.btnAggiornaClick(Sender: TObject);
begin
  ApriDataset;
end;

procedure TfrmBaseAnag.edRicercaChange(Sender: TObject);
begin
  if not (Q.State in dsEditModes) then
    ApriDataset;
end;

procedure TfrmBaseAnag.DSStateChange(Sender: TObject);
var
  Editing: Boolean;
begin
  Editing := Q.State in dsEditModes;
  btnSalva.Enabled := Editing;
  btnAnnulla.Enabled := Editing;
  btnNuovo.Enabled := (not Editing) and Sessione.PuoScrivere(FModuloCodice);
  btnModifica.Enabled := (not Editing) and Sessione.PuoScrivere(FModuloCodice);
  btnElimina.Enabled := (not Editing) and Sessione.PuoCancellare(FModuloCodice);
  edRicerca.Enabled := not Editing;
end;

end.
