unit uMain;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Data.DB,
  AdvPanel, AdvEdit, AdvGlowButton, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,
  AdvAppStyler, AdvStyleIF;

type
  TfrmMain = class(TForm)
    pnlTop: TAdvPanel;
    lblFiltro: TLabel;
    edtFiltro: TAdvEdit;
    btnNuova: TAdvGlowButton;
    btnModifica: TAdvGlowButton;
    btnElimina: TAdvGlowButton;
    grdZone: TDBAdvGrid;
    stbStato: TStatusBar;
    styMain: TAdvFormStyler;
    procedure FormCreate(Sender: TObject);
    procedure edtFiltroChange(Sender: TObject);
    procedure btnNuovaClick(Sender: TObject);
    procedure btnModificaClick(Sender: TObject);
    procedure btnEliminaClick(Sender: TObject);
    procedure grdZoneDblClickCell(Sender: TObject; ARow, ACol: Integer);
  private
    function ZonaSelezionata(out AId: Integer): Boolean;
    procedure AggiornaVista;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.UITypes, uDM, uZona, uZonaEdit, uConferma, uAppTheme;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ApplicaTemaColori(Self, styMain);
  grdZone.DataSource := dmZonico.dsZone;
  AggiornaVista;
end;

procedure TfrmMain.AggiornaVista;
begin
  dmZonico.RicaricaZone(Trim(edtFiltro.Text));
  stbStato.SimpleText := Format('Utente: %s   |   Zone visualizzate: %d',
    [dmZonico.UtenteCorrente.Nome, dmZonico.qryZone.RecordCount]);
end;

function TfrmMain.ZonaSelezionata(out AId: Integer): Boolean;
begin
  AId := 0;
  Result := not dmZonico.qryZone.IsEmpty;
  if Result then
    AId := dmZonico.qryZone.FieldByName('ID').AsInteger;
end;

procedure TfrmMain.edtFiltroChange(Sender: TObject);
begin
  AggiornaVista;
end;

procedure TfrmMain.btnNuovaClick(Sender: TObject);
var
  LZona: TZona;
begin
  LZona := Default(TZona);
  LZona.Attiva := True;
  if not TfrmZonaEdit.Modifica(Self, LZona) then
    Exit;
  if dmZonico.Repository.EsisteCodice(LZona.Codice, 0) then
  begin
    TfrmConferma.Avvisa(Self, 'Zonico', 'Esiste gia'' una zona con questo codice.');
    Exit;
  end;
  dmZonico.Repository.Inserisci(LZona);
  AggiornaVista;
end;

procedure TfrmMain.btnModificaClick(Sender: TObject);
var
  LId: Integer;
  LZona: TZona;
begin
  if not ZonaSelezionata(LId) then
    Exit;
  LZona := dmZonico.Repository.Leggi(LId);
  if not TfrmZonaEdit.Modifica(Self, LZona) then
    Exit;
  if dmZonico.Repository.EsisteCodice(LZona.Codice, LZona.Id) then
  begin
    TfrmConferma.Avvisa(Self, 'Zonico', 'Esiste gia'' una zona con questo codice.');
    Exit;
  end;
  dmZonico.Repository.Aggiorna(LZona);
  AggiornaVista;
end;

procedure TfrmMain.btnEliminaClick(Sender: TObject);
var
  LId: Integer;
begin
  if not ZonaSelezionata(LId) then
    Exit;
  if not TfrmConferma.Chiedi(Self, 'Elimina zona', 'Eliminare la zona selezionata?') then
    Exit;
  dmZonico.Repository.Elimina(LId);
  AggiornaVista;
end;

procedure TfrmMain.grdZoneDblClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  btnModificaClick(Sender);
end;

end.
