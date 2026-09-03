program Zonico;

uses
  Vcl.Forms,
  uMain in 'src\uMain.pas' {frmMain},
  uDM in 'src\uDM.pas' {dmZonico: TDataModule},
  uLogin in 'src\uLogin.pas' {frmLogin},
  uConferma in 'src\uConferma.pas' {frmConferma},
  uUtenteRepository in 'src\uUtenteRepository.pas',
  uDbFirebird in 'src\uDbFirebird.pas',
  uControlliMetro in 'src\uControlliMetro.pas',
  uFormBase in 'src\uFormBase.pas' {frmBase},
  uAppTheme in 'src\uAppTheme.pas';

{$R *.res}

var
  LUtente: TUtente;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Zonico';
  CaricaFontComfortaa;
  Application.CreateForm(TdmZonico, dmZonico);

  if not TfrmLogin.Esegui(Application, LUtente) then
    Exit;
  dmZonico.UtenteCorrente := LUtente;

  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
