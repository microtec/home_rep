unit uDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBBase, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.DApt,
  uZonaRepository, uUtenteRepository;

type
  TdmZonico = class(TDataModule)
    conZonico: TFDConnection;
    drvFirebird: TFDPhysFBDriverLink;
    guiWait: TFDGUIxWaitCursor;
    qryZone: TFDQuery;
    dsZone: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FRepository: TZonaRepository;
    FUtenti: TUtenteRepository;
    FUtenteCorrente: TUtente;
    function FileConfigurazione: string;
    procedure ConfiguraConnessione;
  public
    property Repository: TZonaRepository read FRepository;
    property Utenti: TUtenteRepository read FUtenti;
    property UtenteCorrente: TUtente read FUtenteCorrente write FUtenteCorrente;
    procedure RicaricaZone(const AFiltro: string = '');
  end;

var
  dmZonico: TdmZonico;

implementation

uses
  System.IOUtils, System.IniFiles;

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
  LDatabase, LUser, LPassword, LProtocol, LServer, LClientLib, LCharset: string;
  LPort: Integer;
begin
  LIni := TIniFile.Create(FileConfigurazione);
  try
    LDatabase := LIni.ReadString(SezioneDatabase, 'Database', 'C:\Zonico\ZONICO.FDB');
    LUser := LIni.ReadString(SezioneDatabase, 'User_Name', 'SYSDBA');
    LPassword := LIni.ReadString(SezioneDatabase, 'Password', 'masterkey');
    LProtocol := LIni.ReadString(SezioneDatabase, 'Protocol', 'TCPIP');
    LServer := LIni.ReadString(SezioneDatabase, 'Server', 'localhost');
    LPort := LIni.ReadInteger(SezioneDatabase, 'Port', 3050);
    LCharset := LIni.ReadString(SezioneDatabase, 'CharacterSet', 'ISO8859_1');
    LClientLib := LIni.ReadString(SezioneDatabase, 'VendorLib', '');
  finally
    LIni.Free;
  end;

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
    conZonico.Params.Add('Server=' + LServer);
    conZonico.Params.Add('Port=' + IntToStr(LPort));
  end;
end;

procedure TdmZonico.DataModuleCreate(Sender: TObject);
begin
  ConfiguraConnessione;
  conZonico.Connected := True;

  FRepository := TZonaRepository.Create(conZonico);
  FRepository.CreaSchema;
  FUtenti := TUtenteRepository.Create(conZonico);
  FUtenti.CreaSchema;
  RicaricaZone;
end;

procedure TdmZonico.DataModuleDestroy(Sender: TObject);
begin
  FreeAndNil(FUtenti);
  FreeAndNil(FRepository);
end;

procedure TdmZonico.RicaricaZone(const AFiltro: string);
begin
  FRepository.Carica(qryZone, AFiltro);
end;

end.
