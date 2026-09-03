program Zonico;

uses
  Vcl.Forms,
  uMain in 'src\uMain.pas' {frmMain},
  uDM in 'src\uDM.pas' {dmZonico: TDataModule},
  uLogin in 'src\uLogin.pas' {frmLogin},
  uZonaEdit in 'src\uZonaEdit.pas' {frmZonaEdit},
  uConferma in 'src\uConferma.pas' {frmConferma},
  uZona in 'src\uZona.pas',
  uZonaRepository in 'src\uZonaRepository.pas',
  uUtenteRepository in 'src\uUtenteRepository.pas',
  uDbFirebird in 'src\uDbFirebird.pas',
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
