unit uConferma;

interface

uses
  System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls,
  uControlliMetro;

type
  TfrmConferma = class(TForm)
    pnlMessaggio: TPanel;
    lblMessaggio: TLabel;
    pnlBottoni: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FBtnSi: TPulsanteMetro;
    FBtnNo: TPulsanteMetro;
    procedure CreaBottoni;
    procedure SiClick(Sender: TObject);
    procedure NoClick(Sender: TObject);
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
  ApplicaTemaColori(Self);
  KeyPreview := True;
  CreaBottoni;
end;

procedure TfrmConferma.CreaBottoni;
begin
  FBtnSi := TPulsanteMetro.Crea(pnlBottoni, 'Si',
    pnlBottoni.Width - 232, 14, 100, 32, SiClick);

  FBtnNo := TPulsanteMetro.Crea(pnlBottoni, 'No',
    pnlBottoni.Width - 120, 14, 100, 32, NoClick);
  FBtnNo.ColoreBase := clZonicoGrigioChiaro;
  FBtnNo.ColoreTesto := clZonicoGrigio;
end;

procedure TfrmConferma.SiClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

procedure TfrmConferma.NoClick(Sender: TObject);
begin
  ModalResult := mrNo;
end;

// I pulsanti sono disegnati e non intercettano Invio/Esc: lo fa la form.
procedure TfrmConferma.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      ModalResult := mrYes;
    #27:
      if FBtnNo.Visible then
        ModalResult := mrNo
      else
        ModalResult := mrYes;
  else
    Exit;
  end;
  Key := #0;
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
    LForm.FBtnNo.Visible := False;
    LForm.FBtnSi.Caption := 'OK';
    LForm.FBtnSi.Left := LForm.FBtnNo.Left;
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

end.
