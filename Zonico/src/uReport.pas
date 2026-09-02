unit uReport;

{ Report incassi per periodo: totali per giorno, per operatore, per pagamento. }

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.DateUtils, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  AdvToolBar, AdvDateTimePicker, AdvOfficePager, AdvPanel, AdvGrid, DBAdvGrid, AdvObj,
  BaseGrid, AdvUtil;

type
  TfrmReport = class(TForm)
    ToolBar: TAdvToolBar;
    lblDal: TLabel;
    dtDal: TAdvDateTimePicker;
    lblAl: TLabel;
    dtAl: TAdvDateTimePicker;
    btnEsegui: TAdvToolBarButton;
    btnMese: TAdvToolBarButton;
    btnStampa: TAdvToolBarButton;
    Pager: TAdvOfficePager;
    pgGiorno: TAdvOfficePage;
    pgOperatore: TAdvOfficePage;
    pgPagamento: TAdvOfficePage;
    pgServizi: TAdvOfficePage;
    GridGiorno: TDBAdvGrid;
    GridOperatore: TDBAdvGrid;
    GridPagamento: TDBAdvGrid;
    GridServizi: TDBAdvGrid;
    QGiorno: TFDQuery;
    QOperatore: TFDQuery;
    QPagamento: TFDQuery;
    QServizi: TFDQuery;
    DSGiorno: TDataSource;
    DSOperatore: TDataSource;
    DSPagamento: TDataSource;
    DSServizi: TDataSource;
    pnlBottom: TAdvPanel;
    lblTotale: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnEseguiClick(Sender: TObject);
    procedure btnMeseClick(Sender: TObject);
    procedure btnStampaClick(Sender: TObject);
  private
    procedure Esegui;
    procedure Apri(Q: TFDQuery; const ASQL: string);
    function GridAttiva: TDBAdvGrid;
  end;

implementation

uses
  uDM;

{$R *.dfm}

procedure TfrmReport.FormCreate(Sender: TObject);
var
  G: TDBAdvGrid;
begin
  QGiorno.Connection := DM.Conn;
  QOperatore.Connection := DM.Conn;
  QPagamento.Connection := DM.Conn;
  QServizi.Connection := DM.Conn;
  for G in [GridGiorno, GridOperatore, GridPagamento, GridServizi] do
  begin
    G.PageMode := False;
    G.AutoCreateColumns := True;
    G.Look := glOffice2019White;
    G.FloatFormat := '%.2f';
    G.Options := G.Options - [goEditing];
  end;
  dtDal.Date := StartOfTheMonth(Date);
  dtAl.Date := Date;
  Esegui;
end;

procedure TfrmReport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmReport.Apri(Q: TFDQuery; const ASQL: string);
begin
  Q.Close;
  Q.SQL.Text := ASQL;
  Q.ParamByName('D1').AsDateTime := DateOf(dtDal.Date);
  Q.ParamByName('D2').AsDateTime := DateOf(dtAl.Date) + 1;
  Q.Open;
end;

procedure TfrmReport.Esegui;
var
  Tot: Variant;
begin
  Apri(QGiorno,
    'SELECT CAST(V.DATA AS DATE) AS GIORNO, COUNT(*) AS N_VENDITE, SUM(V.IMPONIBILE) AS IMPONIBILE, ' +
    '       SUM(V.SCONTO) AS SCONTI, SUM(V.TOTALE) AS INCASSO ' +
    'FROM VENDITE V WHERE V.DATA >= :D1 AND V.DATA < :D2 ' +
    'GROUP BY 1 ORDER BY 1');
  Apri(QOperatore,
    'SELECT COALESCE(O.NOME, ''(nessuno)'') AS OPERATORE, COUNT(*) AS N_VENDITE, SUM(V.TOTALE) AS INCASSO ' +
    'FROM VENDITE V LEFT JOIN OPERATORI O ON O.ID = V.ID_OPERATORE ' +
    'WHERE V.DATA >= :D1 AND V.DATA < :D2 GROUP BY 1 ORDER BY 3 DESC');
  Apri(QPagamento,
    'SELECT COALESCE(P.DESCRIZIONE, ''(n.d.)'') AS PAGAMENTO, COUNT(*) AS N_VENDITE, SUM(V.TOTALE) AS INCASSO ' +
    'FROM VENDITE V LEFT JOIN PAGAMENTI P ON P.CODICE = V.PAGAMENTO ' +
    'WHERE V.DATA >= :D1 AND V.DATA < :D2 GROUP BY 1 ORDER BY 3 DESC');
  Apri(QServizi,
    'SELECT R.DESCRIZIONE, CASE R.TIPO WHEN ''S'' THEN ''Servizio'' ELSE ''Prodotto'' END AS TIPO, ' +
    '       SUM(R.QUANTITA) AS QUANTITA, SUM(R.QUANTITA * R.PREZZO) AS IMPORTO ' +
    'FROM VENDITE_RIGHE R JOIN VENDITE V ON V.ID = R.ID_VENDITA ' +
    'WHERE V.DATA >= :D1 AND V.DATA < :D2 GROUP BY 1, 2 ORDER BY 4 DESC');
  Tot := DM.Scalar('SELECT COALESCE(SUM(TOTALE),0) FROM VENDITE WHERE DATA >= :D1 AND DATA < :D2',
    [DateOf(dtDal.Date), DateOf(dtAl.Date) + 1]);
  lblTotale.Caption := Format('Incasso periodo %s - %s: € %.2f',
    [FormatDateTime('dd/mm/yyyy', dtDal.Date), FormatDateTime('dd/mm/yyyy', dtAl.Date), Double(Tot)]);
end;

procedure TfrmReport.btnEseguiClick(Sender: TObject);
begin
  Esegui;
end;

procedure TfrmReport.btnMeseClick(Sender: TObject);
begin
  dtDal.Date := StartOfTheMonth(Date);
  dtAl.Date := EndOfTheMonth(Date);
  Esegui;
end;

function TfrmReport.GridAttiva: TDBAdvGrid;
begin
  if Pager.ActivePage = pgOperatore then Result := GridOperatore
  else if Pager.ActivePage = pgPagamento then Result := GridPagamento
  else if Pager.ActivePage = pgServizi then Result := GridServizi
  else Result := GridGiorno;
end;

procedure TfrmReport.btnStampaClick(Sender: TObject);
begin
  GridAttiva.PrintSettings.Title := lblTotale.Caption;
  GridAttiva.PrintSettings.Centered := True;
  GridAttiva.PrintSettings.FitToPage := fpGrow;
  GridAttiva.Print;
end;

end.
