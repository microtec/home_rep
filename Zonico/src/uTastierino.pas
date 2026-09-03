unit uTastierino;

interface

uses
  System.Classes, Winapi.Messages, Vcl.Controls, Vcl.Graphics;

type
  // Tasti del tastierino: cifre, cancellazione e conferma.
  TTastoTipo = (ttCifra, ttCancella, ttConferma);

  TTastoEvent = procedure(Sender: TObject; ATipo: TTastoTipo;
    const ACifra: string) of object;

  // Tasto rotondo disegnato a mano: i pulsanti TMS non sono circolari.
  TTastoTondo = class(TGraphicControl)
  private
    FTesto: string;
    FTipo: TTastoTipo;
    FCifra: string;
    FSotto: Boolean;
    FSopra: Boolean;
    FColoreBase: TColor;
    FColoreTesto: TColor;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    property Testo: string read FTesto write FTesto;
    property Tipo: TTastoTipo read FTipo write FTipo;
    property Cifra: string read FCifra write FCifra;
    property ColoreBase: TColor read FColoreBase write FColoreBase;
    property ColoreTesto: TColor read FColoreTesto write FColoreTesto;
  end;

  // Griglia 3x4 di tasti rotondi: 1-9, cancella, 0, conferma.
  TTastierinoNumerico = class(TCustomControl)
  private
    FOnTasto: TTastoEvent;
    FDiametro: Integer;
    FSpazio: Integer;
    procedure CreaTasti;
    procedure TastoClick(Sender: TObject);
    procedure DisponiTasti;
  protected
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    property Diametro: Integer read FDiametro write FDiametro;
    property OnTasto: TTastoEvent read FOnTasto write FOnTasto;
  end;

implementation

uses
  Winapi.Windows, System.SysUtils, System.Types, uAppTheme;

const
  Colonne = 3;
  Righe = 4;

{ TTastoTondo }

constructor TTastoTondo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 64;
  Height := 64;
  Color := clZonicoBianco;
  FColoreBase := clZonicoAzzurroChiaro;
  FColoreTesto := clZonicoGrigio;
  Font.Name := ZonicoFontName;
  Font.Height := -20;
end;

procedure TTastoTondo.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FSopra := True;
  Invalidate;
end;

procedure TTastoTondo.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FSopra := False;
  FSotto := False;
  Invalidate;
end;

procedure TTastoTondo.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  FSotto := True;
  Invalidate;
end;

procedure TTastoTondo.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  FSotto := False;
  Invalidate;
  inherited;
end;

procedure TTastoTondo.Paint;
var
  LRiempimento: TColor;
  LRettangolo: TRect;
  LLarghezza, LAltezza: Integer;
begin
  if FSotto then
    LRiempimento := clZonicoAzzurroScuro
  else if FSopra then
    LRiempimento := clZonicoAzzurro
  else
    LRiempimento := FColoreBase;

  // Look Metro: superfici piatte, nessun gradiente, bordo sottile.
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);

  Canvas.Brush.Color := LRiempimento;
  Canvas.Pen.Width := 1;
  if FSotto or FSopra then
    Canvas.Pen.Color := LRiempimento
  else
    Canvas.Pen.Color := clZonicoBordo;
  Canvas.Ellipse(0, 0, Width, Height);

  Canvas.Brush.Style := bsClear;
  Canvas.Font := Font;
  if FSotto or FSopra then
    Canvas.Font.Color := clZonicoBianco
  else
    Canvas.Font.Color := FColoreTesto;

  LLarghezza := Canvas.TextWidth(FTesto);
  LAltezza := Canvas.TextHeight(FTesto);
  LRettangolo := Rect((Width - LLarghezza) div 2, (Height - LAltezza) div 2,
    Width, Height);
  Canvas.TextOut(LRettangolo.Left, LRettangolo.Top, FTesto);
end;

{ TTastierinoNumerico }

constructor TTastierinoNumerico.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDiametro := 64;
  FSpazio := 12;
  Color := clZonicoBianco;
  ParentBackground := False;
  ParentColor := False;
  CreaTasti;
end;

procedure TTastierinoNumerico.CreaTasti;
const
  Etichette: array[0..11] of string =
    ('1', '2', '3', '4', '5', '6', '7', '8', '9', 'C', '0', 'OK');
var
  LIndice: Integer;
  LTasto: TTastoTondo;
begin
  for LIndice := Low(Etichette) to High(Etichette) do
  begin
    LTasto := TTastoTondo.Create(Self);
    LTasto.Parent := Self;
    LTasto.Testo := Etichette[LIndice];
    LTasto.Cifra := '';
    LTasto.OnClick := TastoClick;

    if Etichette[LIndice] = 'C' then
    begin
      LTasto.Tipo := ttCancella;
      LTasto.ColoreBase := clZonicoGrigioChiaro;
    end
    else if Etichette[LIndice] = 'OK' then
    begin
      LTasto.Tipo := ttConferma;
      LTasto.ColoreBase := clZonicoAzzurro;
      LTasto.ColoreTesto := clZonicoBianco;
      LTasto.Font.Height := -16;
    end
    else
    begin
      LTasto.Tipo := ttCifra;
      LTasto.Cifra := Etichette[LIndice];
    end;
  end;
  DisponiTasti;
end;

procedure TTastierinoNumerico.DisponiTasti;
var
  LIndice, LRiga, LColonna, LSinistra, LAlto: Integer;
  LTasto: TTastoTondo;
begin
  LSinistra := (Width - (Colonne * FDiametro + (Colonne - 1) * FSpazio)) div 2;
  LAlto := (Height - (Righe * FDiametro + (Righe - 1) * FSpazio)) div 2;
  if LSinistra < 0 then
    LSinistra := 0;
  if LAlto < 0 then
    LAlto := 0;

  for LIndice := 0 to ControlCount - 1 do
    if Controls[LIndice] is TTastoTondo then
    begin
      LTasto := TTastoTondo(Controls[LIndice]);
      LRiga := LIndice div Colonne;
      LColonna := LIndice mod Colonne;
      LTasto.SetBounds(LSinistra + LColonna * (FDiametro + FSpazio),
        LAlto + LRiga * (FDiametro + FSpazio), FDiametro, FDiametro);
    end;
end;

procedure TTastierinoNumerico.Resize;
begin
  inherited;
  DisponiTasti;
end;

procedure TTastierinoNumerico.TastoClick(Sender: TObject);
var
  LTasto: TTastoTondo;
begin
  LTasto := Sender as TTastoTondo;
  if Assigned(FOnTasto) then
    FOnTasto(Self, LTasto.Tipo, LTasto.Cifra);
end;

end.
