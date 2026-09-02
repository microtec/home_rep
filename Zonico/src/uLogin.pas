unit uLogin;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs,
  AdvEdit, AdvGlowButton, AdvPanel;

type
  TfrmLogin = class(TForm)
    pnlMain: TAdvPanel;
    lblTitolo: TLabel;
    lblUser: TLabel;
    lblPass: TLabel;
    edUser: TAdvEdit;
    edPass: TAdvEdit;
    btnLogin: TAdvGlowButton;
    btnEsci: TAdvGlowButton;
    procedure btnLoginClick(Sender: TObject);
    procedure btnEsciClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  public
    class function Esegui: Boolean;
  end;

implementation

uses
  uSessione;

{$R *.dfm}

class function TfrmLogin.Esegui: Boolean;
var
  F: TfrmLogin;
begin
  F := TfrmLogin.Create(nil);
  try
    Result := F.ShowModal = mrOk;
  finally
    F.Free;
  end;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  edUser.SetFocus;
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  if Sessione.Login(Trim(edUser.Text), edPass.Text) then
    ModalResult := mrOk
  else
  begin
    MessageDlg('Utente o password non validi.', mtError, [mbOK], 0);
    edPass.Clear;
    edPass.SetFocus;
  end;
end;

procedure TfrmLogin.btnEsciClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
