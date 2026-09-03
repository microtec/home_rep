unit uControlliMetro;

// Controlli disegnati in stile Metro (superfici piatte, nessun gradiente)
// realizzati con la sola VCL standard: nessuna libreria di terze parti.

interface

uses
  System.Classes, Winapi.Messages, Vcl.Controls, Vcl.Graphics;

type
  // Pulsante rettangolare piatto usato per i comandi e le aree.
  TPulsanteMetro = class(TGraphicControl)
  private
    FCaption: string;
    FColoreBase: TColor;
    FColoreTesto: TColor;
    FSotto: Boolean;
    FSopra: Boolean;
    procedure SetCaption(const AValue: string);
    procedure SetColoreBase(AValue: TColor);
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function ColoreRiempimento: TColor; virtual;
    function ColoreContenuto: TColor; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    class function Crea(AParent: TWinControl; const ACaption: string;
      ALeft, ATop, AWidth, AHeight: Integer;
      AOnClick: TNotifyEvent): TPulsanteMetro;
    property Caption: string read FCaption write SetCaption;
    property ColoreBase: TColor read FColoreBase write SetColoreBase;
    property ColoreTesto: TColor read FColoreTesto write FColoreTesto;
  published
    property Align;
    property Anchors;
    property Enabled;
    property Font;
    property Hint;
    property ShowHint;
    property Tag;
    property Visible;
    property OnClick;
  end;

  // Tasto rotondo del tastierino: stessa logica, forma circolare.
  TTastoTondo = class(TPulsanteMetro)
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TTastoTipo = (ttCifra, ttCancella, ttConferma);

  TTastoEvent = procedure(Sender: TObject; ATipo: TTastoTipo;
    const ACifra: string) of object;

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
  Winapi.Windows, System.SysUtils, System.Types, System.UITypes, uAppTheme;

const
  Colonne = 3;
  Righe = 4;
  // Tag dei tasti: le cifre usano il proprio valore, C e OK valori dedicati.
  TagCancella = 10;
  TagConferma = 11;

{ TPulsanteMetro }

constructor TPulsanteMetro.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 160;
  Height := 40;
  Color := clZonicoBianco;
  FColoreBase := clZonicoAzzurro;
  FColoreTesto := clZonicoBianco;
  Font.Name := ZonicoFontName;
  Font.Height := -14;
end;

class function TPulsanteMetro.Crea(AParent: TWinControl; const ACaption: string;
  ALeft, ATop, AWidth, AHeight: Integer;
  AOnClick: TNotifyEvent): TPulsanteMetro;
begin
  Result := Create(AParent);
  Result.Parent := AParent;
  Result.Caption := ACaption;
  Result.SetBounds(ALeft, ATop, AWidth, AHeight);
  Result.OnClick := AOnClick;
end;

procedure TPulsanteMetro.SetCaption(const AValue: string);
begin
  if FCaption = AValue then
    Exit;
  FCaption := AValue;
  Invalidate;
end;

procedure TPulsanteMetro.SetColoreBase(AValue: TColor);
begin
  if FColoreBase = AValue then
    Exit;
  FColoreBase := AValue;
  Invalidate;
end;

procedure TPulsanteMetro.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  FSopra := True;
  Invalidate;
end;

procedure TPulsanteMetro.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  FSopra := False;
  FSotto := False;
  Invalidate;
end;

procedure TPulsanteMetro.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TPulsanteMetro.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  FSotto := True;
  Invalidate;
end;

procedure TPulsanteMetro.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  FSotto := False;
  Invalidate;
  inherited;
end;

function TPulsanteMetro.ColoreRiempimento: TColor;
begin
  if not Enabled then
    Result := clZonicoGrigioChiaro
  else if FSotto then
    Result := clZonicoAzzurroScuro
  else if FSopra then
    Result := clZonicoAzzurro
  else
    Result := FColoreBase;
end;

function TPulsanteMetro.ColoreContenuto: TColor;
begin
  if not Enabled then
    Result := clZonicoBordo
  else if FSotto or FSopra then
    Result := clZonicoBianco
  else
    Result := FColoreTesto;
end;

procedure TPulsanteMetro.Paint;
var
  LRettangolo: TRect;
begin
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := ColoreRiempimento;
  Canvas.FillRect(ClientRect);

  Canvas.Brush.Style := bsClear;
  Canvas.Font := Font;
  Canvas.Font.Color := ColoreContenuto;
  LRettangolo := ClientRect;
  Canvas.TextRect(LRettangolo, FCaption,
    [tfCenter, tfVerticalCenter, tfSingleLine, tfEndEllipsis]);
end;

{ TTastoTondo }

constructor TTastoTondo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 64;
  Height := 64;
  ColoreBase := clZonicoAzzurroChiaro;
  ColoreTesto := clZonicoGrigio;
  Font.Height := -20;
end;

procedure TTastoTondo.Paint;
var
  LTesto: string;
  LSinistra, LAlto: Integer;
begin
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);

  Canvas.Brush.Color := ColoreRiempimento;
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clZonicoBordo;
  Canvas.Ellipse(0, 0, Width, Height);

  LTesto := Caption;
  Canvas.Brush.Style := bsClear;
  Canvas.Font := Font;
  Canvas.Font.Color := ColoreContenuto;
  LSinistra := (Width - Canvas.TextWidth(LTesto)) div 2;
  LAlto := (Height - Canvas.TextHeight(LTesto)) div 2;
  Canvas.TextOut(LSinistra, LAlto, LTesto);
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
    LTasto.Caption := Etichette[LIndice];
    LTasto.OnClick := TastoClick;

    if Etichette[LIndice] = 'C' then
    begin
      LTasto.Tag := TagCancella;
      LTasto.ColoreBase := clZonicoGrigioChiaro;
    end
    else if Etichette[LIndice] = 'OK' then
    begin
      LTasto.Tag := TagConferma;
      LTasto.ColoreBase := clZonicoAzzurro;
      LTasto.ColoreTesto := clZonicoBianco;
      LTasto.Font.Height := -16;
    end
    else
      LTasto.Tag := StrToInt(Etichette[LIndice]);
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
  if not Assigned(FOnTasto) then
    Exit;

  LTasto := Sender as TTastoTondo;
  case LTasto.Tag of
    TagCancella: FOnTasto(Self, ttCancella, '');
    TagConferma: FOnTasto(Self, ttConferma, '');
  else
    FOnTasto(Self, ttCifra, LTasto.Caption);
  end;
end;

end.
