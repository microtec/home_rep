unit uStile;

{ Stile grafico unico dell'applicazione: Metro (Windows 8) applicato a tutti
  i componenti TMS di una form tramite TAdvFormStyler. }

interface

uses
  System.Classes, Vcl.Forms, Vcl.Graphics, AdvStyleIF, AdvFormStyler;

const
  STILE_APP: TTMSStyle = tsWindows8;
  COLORE_SFONDO = clWhite;

procedure ApplicaStileMetro(AForm: TCustomForm);

implementation

procedure ApplicaStileMetro(AForm: TCustomForm);
var
  Styler: TAdvFormStyler;
begin
  if AForm.FindComponent('StilerMetro') <> nil then
    Exit;
  Styler := TAdvFormStyler.Create(AForm);
  Styler.Name := 'StilerMetro';
  Styler.Style := STILE_APP;
  if TForm(AForm).FormStyle <> fsMDIForm then
    TForm(AForm).Color := COLORE_SFONDO;
end;

end.
