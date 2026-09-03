unit uZonaEdit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
  Vcl.ExtCtrls, AdvPanel, AdvEdit, AdvGlowButton, AdvAppStyler, AdvStyleIF,
  uZona;

type
  TfrmZonaEdit = class(TForm)
    lblCodice: TLabel;
    edtCodice: TAdvEdit;
    lblDescrizione: TLabel;
    edtDescrizione: TAdvEdit;
    lblSuperficie: TLabel;
    edtSuperficie: TAdvEdit;
    chkAttiva: TCheckBox;
    pnlBottoni: TAdvPanel;
    btnOk: TAdvGlowButton;
    btnAnnulla: TAdvGlowButton;
    styZonaEdit: TAdvFormStyler;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    FZona: TZona;
    procedure SetZona(const AValue: TZona);
  public
    property Zona: TZona read FZona write SetZona;
    class function Modifica(AOwner: TComponent; var AZona: TZona): Boolean;
  end;

implementation

uses
  System.UITypes, uConferma, uAppTheme;

{$R *.dfm}

{ TfrmZonaEdit }

procedure TfrmZonaEdit.FormCreate(Sender: TObject);
begin
  ApplicaTemaColori(Self, styZonaEdit);
end;

procedure TfrmZonaEdit.SetZona(const AValue: TZona);
begin
  FZona := AValue;
  edtCodice.Text := FZona.Codice;
  edtDescrizione.Text := FZona.Descrizione;
  edtSuperficie.Text := FormatFloat('0.##', FZona.Superficie);
  chkAttiva.Checked := FZona.Attiva;
  if FZona.IsNew then
    Caption := 'Nuova zona'
  else
    Caption := 'Modifica zona ' + FZona.Codice;
end;

procedure TfrmZonaEdit.btnOkClick(Sender: TObject);
var
  LErrore: string;
  LSuperficie: Double;
begin
  if not TryStrToFloat(Trim(edtSuperficie.Text), LSuperficie) then
  begin
    if Trim(edtSuperficie.Text) = '' then
      LSuperficie := 0
    else
    begin
      TfrmConferma.Avvisa(Self, 'Dato non valido', 'Superficie non valida.');
      edtSuperficie.SetFocus;
      Exit;
    end;
  end;

  FZona.Codice := Trim(edtCodice.Text);
  FZona.Descrizione := Trim(edtDescrizione.Text);
  FZona.Superficie := LSuperficie;
  FZona.Attiva := chkAttiva.Checked;

  if not FZona.Valida(LErrore) then
  begin
    TfrmConferma.Avvisa(Self, 'Dato non valido', LErrore);
    Exit;
  end;

  ModalResult := mrOk;
end;

class function TfrmZonaEdit.Modifica(AOwner: TComponent; var AZona: TZona): Boolean;
var
  LForm: TfrmZonaEdit;
begin
  LForm := TfrmZonaEdit.Create(AOwner);
  try
    LForm.Zona := AZona;
    Result := LForm.ShowModal = mrOk;
    if Result then
      AZona := LForm.FZona;
  finally
    LForm.Free;
  end;
end;

end.
