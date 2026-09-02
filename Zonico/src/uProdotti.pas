unit uProdotti;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, FireDAC.Comp.Client,
  AdvToolBar, AdvEdit, AdvPanel, AdvGrid, DBAdvGrid, AdvObj, BaseGrid, AdvUtil,
  uBaseAnag;

type
  TfrmProdotti = class(TfrmBaseAnag)
  protected
    procedure ConfiguraGriglia; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TfrmProdotti.Create(AOwner: TComponent);
begin
  FModuloCodice := 'PRODOTTI';
  FTabella := 'PRODOTTI';
  FCampoOrdine := 'DESCRIZIONE';
  FCampiRicerca := 'COALESCE(CODICE,'''')||'' ''||DESCRIZIONE';
  inherited;
  Caption := 'Prodotti';
end;

procedure TfrmProdotti.ConfiguraGriglia;
begin
  inherited;
  Grid.Columns[0].Visible := False;
  Grid.Columns[1].Header := 'Codice';       Grid.Columns[1].Width := 110;
  Grid.Columns[2].Header := 'Descrizione';  Grid.Columns[2].Width := 300;
  Grid.Columns[3].Header := 'Prezzo €';     Grid.Columns[3].Width := 100;
  Grid.Columns[3].FloatFormat := '%.2f';
  Grid.Columns[4].Header := 'Giacenza';     Grid.Columns[4].Width := 80;
  Grid.Columns[5].Header := 'Attivo';       Grid.Columns[5].Width := 60;
  Grid.Columns[5].Editor := edCheckBox;
end;

end.
