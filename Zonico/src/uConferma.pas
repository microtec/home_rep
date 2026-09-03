unit uConferma;

interface

uses
  System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  AdvPanel, AdvGlowButton, AdvAppStyler, AdvStyleIF;

type
  TfrmConferma = class(TForm)
    pnlMessaggio: TAdvPanel;
    lblMessaggio: TLabel;
    pnlBottoni: TAdvPanel;
    btnSi: TAdvGlowButton;
    btnNo: TAdvGlowButton;
    styConferma: TAdvFormStyler;
    procedure FormCreate(Sender: TObject);
  public
    // Tutte le richieste di conferma passano di qui e sono sempre modali.
    class function Chiedi(AOwner: TComponent; const ATitolo, AMessaggio: string): Boolean;
    class procedure Avvisa(AOwner: TComponent; const ATitolo, AMessaggio: string);
  end;

implementation

uses
  System.UITypes, uAppTheme;

{$R *.dfm}

{ TfrmConferma }

procedure TfrmConferma.FormCreate(Sender: TObject);
begin
  ApplicaTemaColori(Self, styConferma);
end;

class function TfrmConferma.Chiedi(AOwner: TComponent; const ATitolo, AMessaggio: string): Boolean;
var
  LForm: TfrmConferma;
begin
  LForm := TfrmConferma.Create(AOwner);
  try
    LForm.Caption := ATitolo;
    LForm.lblMessaggio.Caption := AMessaggio;
    Result := LForm.ShowModal = mrYes;
  finally
    LForm.Free;
  end;
end;

class procedure TfrmConferma.Avvisa(AOwner: TComponent; const ATitolo, AMessaggio: string);
var
  LForm: TfrmConferma;
begin
  LForm := TfrmConferma.Create(AOwner);
  try
    LForm.Caption := ATitolo;
    LForm.lblMessaggio.Caption := AMessaggio;
    LForm.btnNo.Visible := False;
    LForm.btnSi.Caption := 'OK';
    LForm.btnSi.Left := LForm.btnNo.Left;
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

end.
