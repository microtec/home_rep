unit uMain;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs, Vcl.ComCtrls,
  AdvToolBar, AdvToolBarStylers, AdvOfficeStatusBar, AdvOfficeStatusBarStylers;

type
  TfrmMain = class(TForm)
    ToolBar: TAdvToolBar;
    btnAgenda: TAdvToolBarButton;
    btnVendite: TAdvToolBarButton;
    sep1: TAdvToolBarSeparator;
    btnClienti: TAdvToolBarButton;
    btnOperatori: TAdvToolBarButton;
    btnServizi: TAdvToolBarButton;
    btnProdotti: TAdvToolBarButton;
    sep2: TAdvToolBarSeparator;
    btnReport: TAdvToolBarButton;
    btnUtenti: TAdvToolBarButton;
    sep3: TAdvToolBarSeparator;
    btnLogout: TAdvToolBarButton;
    StatusBar: TAdvOfficeStatusBar;
    Styler: TAdvToolBarOfficeStyler;
    procedure FormCreate(Sender: TObject);
    procedure btnAgendaClick(Sender: TObject);
    procedure btnVenditeClick(Sender: TObject);
    procedure btnClientiClick(Sender: TObject);
    procedure btnOperatoriClick(Sender: TObject);
    procedure btnServiziClick(Sender: TObject);
    procedure btnProdottiClick(Sender: TObject);
    procedure btnReportClick(Sender: TObject);
    procedure btnUtentiClick(Sender: TObject);
    procedure btnLogoutClick(Sender: TObject);
  private
    procedure ApplicaPermessi;
    procedure ApriForm(AClass: TFormClass);
    procedure ChiudiTutteLeFinestre;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uSessione, uLogin, uClienti, uOperatori, uServizi, uProdotti, uAgenda,
  uVendite, uReport, uUtenti, uStile;

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ApplicaStileMetro(Self);
  ApplicaPermessi;
end;

procedure TfrmMain.ApplicaPermessi;
begin
  btnAgenda.Enabled := Sessione.PuoLeggere('AGENDA');
  btnVendite.Enabled := Sessione.PuoLeggere('VENDITE');
  btnClienti.Enabled := Sessione.PuoLeggere('CLIENTI');
  btnOperatori.Enabled := Sessione.PuoLeggere('OPERATORI');
  btnServizi.Enabled := Sessione.PuoLeggere('SERVIZI');
  btnProdotti.Enabled := Sessione.PuoLeggere('PRODOTTI');
  btnReport.Enabled := Sessione.PuoLeggere('REPORT');
  btnUtenti.Enabled := Sessione.PuoLeggere('UTENTI');
  StatusBar.Panels[0].Text := 'Utente: ' + Sessione.Username;
  if Sessione.Admin then
    StatusBar.Panels[1].Text := 'Amministratore'
  else
    StatusBar.Panels[1].Text := Sessione.Nome;
end;

procedure TfrmMain.ApriForm(AClass: TFormClass);
var
  I: Integer;
begin
  for I := 0 to MDIChildCount - 1 do
    if MDIChildren[I] is AClass then
    begin
      MDIChildren[I].BringToFront;
      Exit;
    end;
  AClass.Create(Self);
end;

procedure TfrmMain.ChiudiTutteLeFinestre;
var
  I: Integer;
begin
  for I := MDIChildCount - 1 downto 0 do
    MDIChildren[I].Close;
end;

procedure TfrmMain.btnAgendaClick(Sender: TObject);    begin ApriForm(TfrmAgenda); end;
procedure TfrmMain.btnVenditeClick(Sender: TObject);   begin ApriForm(TfrmVendite); end;
procedure TfrmMain.btnClientiClick(Sender: TObject);   begin ApriForm(TfrmClienti); end;
procedure TfrmMain.btnOperatoriClick(Sender: TObject); begin ApriForm(TfrmOperatori); end;
procedure TfrmMain.btnServiziClick(Sender: TObject);   begin ApriForm(TfrmServizi); end;
procedure TfrmMain.btnProdottiClick(Sender: TObject);  begin ApriForm(TfrmProdotti); end;
procedure TfrmMain.btnReportClick(Sender: TObject);    begin ApriForm(TfrmReport); end;
procedure TfrmMain.btnUtentiClick(Sender: TObject);    begin ApriForm(TfrmUtenti); end;

procedure TfrmMain.btnLogoutClick(Sender: TObject);
begin
  ChiudiTutteLeFinestre;
  Sessione.Logout;
  Hide;
  if TfrmLogin.Esegui then
  begin
    ApplicaPermessi;
    Show;
  end
  else
    Application.Terminate;
end;

end.
