unit uServizi;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, FireDAC.Comp.Client,
  AdvToolBar, AdvEdit, AdvPanel, AdvGrid, DBAdvGrid, AdvObj, BaseGrid, AdvUtil,
  uBaseAnag;

type
  TfrmServizi = class(TfrmBaseAnag)
  protected
    procedure ConfiguraGriglia; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TfrmServizi.Create(AOwner: TComponent);
begin
  FModuloCodice := 'SERVIZI';
  FTabella := 'SERVIZI';
  FCampoOrdine := 'DESCRIZIONE';
  FCampiRicerca := 'DESCRIZIONE';
  inherited;
  Caption := 'Listino servizi';
end;

procedure TfrmServizi.ConfiguraGriglia;
begin
  inherited;
  Grid.Columns[0].Visible := False;
  Grid.Columns[1].Header := 'Descrizione';   Grid.Columns[1].Width := 300;
  Grid.Columns[2].Header := 'Durata (min)';  Grid.Columns[2].Width := 100;
  Grid.Columns[3].Header := 'Prezzo €';      Grid.Columns[3].Width := 100;
  Grid.Columns[3].FloatFormat := '%.2f';
  Grid.Columns[4].Header := 'Attivo';        Grid.Columns[4].Width := 60;
  Grid.Columns[4].Editor := edCheckBox;
end;

end.
