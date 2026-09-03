unit uDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBBase, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.DApt,
  uUtenteRepository;

type
  TdmZonico = class(TDataModule)
    conZonico: TFDConnection;
    drvFirebird: TFDPhysFBDriverLink;
    guiWait: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FUtenti: TUtenteRepository;
    FUtenteCorrente: TUtente;
    function FileConfigurazione: string;
    procedure ConfiguraConnessione;
  public
    property Connessione: TFDConnection read conZonico;
    property Utenti: TUtenteRepository read FUtenti;
    property UtenteCorrente: TUtente read FUtenteCorrente write FUtenteCorrente;
  end;

var
  dmZonico: TdmZonico;

implementation

uses
  System.IOUtils, System.IniFiles, uDbFirebird;

{$R *.dfm}

const
  SezioneDatabase = 'DATABASE';

function TdmZonico.FileConfigurazione: string;
begin
  Result := TPath.ChangeExtension(ParamStr(0), '.ini');
end;

procedure TdmZonico.ConfiguraConnessione;
var
  LIni: TIniFile;
  LAlias, LPercorso, LDatabase, LUser, LPassword, LProtocol, LIndirizzo,
  LClientLib, LCharset: string;
  LPort: Integer;
begin
  if not FileExists(FileConfigurazione) then
    raise Exception.CreateFmt(
      'File di configurazione non trovato: %s', [FileConfigurazione]);

  LIni := TIniFile.Create(FileConfigurazione);
  try
    LIndirizzo := LIni.ReadString(SezioneDatabase, 'IndirizzoIP', 'localhost');
    LAlias := Trim(LIni.ReadString(SezioneDatabase, 'Alias', 'ZONICO'));
    LPercorso := Trim(LIni.ReadString(SezioneDatabase, 'Percorso', ''));
    LUser := LIni.ReadString(SezioneDatabase, 'User_Name', 'SYSDBA');
    LPassword := LIni.ReadString(SezioneDatabase, 'Password', 'masterkey');
    LProtocol := LIni.ReadString(SezioneDatabase, 'Protocol', 'TCPIP');
    LPort := LIni.ReadInteger(SezioneDatabase, 'Port', 3050);
    LCharset := LIni.ReadString(SezioneDatabase, 'CharacterSet', 'UTF8');
    LClientLib := LIni.ReadString(SezioneDatabase, 'VendorLib', '');
  finally
    LIni.Free;
  end;

  // L'alias e' definito in aliases.conf sul server Firebird; il percorso
  // completo del file .FDB e' l'alternativa quando l'alias non e' configurato.
  if LAlias <> '' then
    LDatabase := LAlias
  else
    LDatabase := LPercorso;

  if LDatabase = '' then
    raise Exception.CreateFmt(
      'Configurare Alias o Percorso nella sezione [%s] di %s',
      [SezioneDatabase, FileConfigurazione]);

  // Firebird 2.5: client fbclient.dll (o fbembed.dll con Protocol=Local).
  drvFirebird.VendorLib := LClientLib;

  conZonico.Params.Clear;
  conZonico.Params.Add('DriverID=FB');
  conZonico.Params.Add('Database=' + LDatabase);
  conZonico.Params.Add('User_Name=' + LUser);
  conZonico.Params.Add('Password=' + LPassword);
  conZonico.Params.Add('Protocol=' + LProtocol);
  conZonico.Params.Add('CharacterSet=' + LCharset);
  if SameText(LProtocol, 'TCPIP') then
  begin
    conZonico.Params.Add('Server=' + LIndirizzo);
    conZonico.Params.Add('Port=' + IntToStr(LPort));
  end;
end;

procedure TdmZonico.DataModuleCreate(Sender: TObject);
begin
  ConfiguraConnessione;
  conZonico.Connected := True;

  // Lo schema e' creato da sql\zonico_schema.sql, l'applicazione non lo genera.
  VerificaSchema(conZonico);
  FUtenti := TUtenteRepository.Create(conZonico);
end;

procedure TdmZonico.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FUtenti);
end;

end.
