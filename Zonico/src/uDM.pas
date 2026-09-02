unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.DApt,
  FireDAC.Stan.Param;

type
  TDM = class(TDataModule)
    Conn: TFDConnection;
    DriverLink: TFDPhysFBDriverLink;
    WaitCursor: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure LoadConnectionParams;
  public
    function IniPath: string;
    function NewQuery(const ASQL: string = ''): TFDQuery;
    procedure ExecSQL(const ASQL: string; const AParams: array of Variant);
    function Scalar(const ASQL: string; const AParams: array of Variant): Variant;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TDM.IniPath: string;
begin
  Result := ChangeFileExt(ParamStr(0), '.ini');
end;

procedure TDM.LoadConnectionParams;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(IniPath);
  try
    Conn.Params.Clear;
    Conn.Params.DriverID := 'FB';
    Conn.Params.Add('Server=' + Ini.ReadString('Database', 'Server', 'localhost'));
    Conn.Params.Add('Port=' + Ini.ReadString('Database', 'Port', '3050'));
    Conn.Params.Database := Ini.ReadString('Database', 'Path', 'C:\Zonico\ZONICO.FDB');
    Conn.Params.UserName := Ini.ReadString('Database', 'User', 'SYSDBA');
    Conn.Params.Password := Ini.ReadString('Database', 'Password', 'masterkey');
    Conn.Params.Add('CharacterSet=UTF8');
    Conn.Params.Add('SQLDialect=3');
    DriverLink.VendorLib := Ini.ReadString('Database', 'ClientLib', 'fbclient.dll');
  finally
    Ini.Free;
  end;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  LoadConnectionParams;
  Conn.LoginPrompt := False;
  Conn.UpdateOptions.AutoCommitUpdates := True;
  Conn.Connected := True;
end;

function TDM.NewQuery(const ASQL: string): TFDQuery;
begin
  Result := TFDQuery.Create(Self);
  Result.Connection := Conn;
  Result.SQL.Text := ASQL;
end;

procedure TDM.ExecSQL(const ASQL: string; const AParams: array of Variant);
begin
  Conn.ExecSQL(ASQL, AParams);
end;

function TDM.Scalar(const ASQL: string; const AParams: array of Variant): Variant;
begin
  Result := Conn.ExecSQLScalar(ASQL, AParams);
end;

end.
