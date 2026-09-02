program Zonico;

uses
  Vcl.Forms,
  uDM in 'src\uDM.pas' {DM: TDataModule},
  uSessione in 'src\uSessione.pas',
  uLogin in 'src\uLogin.pas' {frmLogin},
  uMain in 'src\uMain.pas' {frmMain},
  uBaseAnag in 'src\uBaseAnag.pas' {frmBaseAnag},
  uClienti in 'src\uClienti.pas' {frmClienti},
  uClienteDett in 'src\uClienteDett.pas' {frmClienteDett},
  uOperatori in 'src\uOperatori.pas' {frmOperatori},
  uServizi in 'src\uServizi.pas' {frmServizi},
  uProdotti in 'src\uProdotti.pas' {frmProdotti},
  uUtenti in 'src\uUtenti.pas' {frmUtenti},
  uAgenda in 'src\uAgenda.pas' {frmAgenda},
  uAppuntamentoDett in 'src\uAppuntamentoDett.pas' {frmAppuntamentoDett},
  uVendite in 'src\uVendite.pas' {frmVendite},
  uVenditaDett in 'src\uVenditaDett.pas' {frmVenditaDett},
  uReport in 'src\uReport.pas' {frmReport};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Zonico - Gestionale Parrucchieri';
  Application.CreateForm(TDM, DM);
  if not TfrmLogin.Esegui then
    Exit;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
