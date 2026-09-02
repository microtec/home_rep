unit uOperatori;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB, FireDAC.Comp.Client,
  AdvToolBar, AdvEdit, AdvPanel, AdvGrid, DBAdvGrid, AdvObj, BaseGrid, AdvUtil,
  uBaseAnag;

type
  TfrmOperatori = class(TfrmBaseAnag)
  protected
    procedure ConfiguraGriglia; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TfrmOperatori.Create(AOwner: TComponent);
begin
  FModuloCodice := 'OPERATORI';
  FTabella := 'OPERATORI';
  FCampoOrdine := 'NOME';
  FCampiRicerca := 'NOME';
  inherited;
  Caption := 'Operatori';
end;

procedure TfrmOperatori.ConfiguraGriglia;
begin
  inherited;
  Grid.Columns[0].Visible := False;                      // ID
  Grid.Columns[1].Header := 'Nome';        Grid.Columns[1].Width := 250;
  Grid.Columns[2].Header := 'Telefono';    Grid.Columns[2].Width := 140;
  Grid.Columns[3].Header := 'Colore';      Grid.Columns[3].Width := 80;
  Grid.Columns[4].Header := 'Attivo';      Grid.Columns[4].Width := 60;
  Grid.Columns[4].Editor := edCheckBox;
end;

end.
