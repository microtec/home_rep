unit uAppTheme;

interface

uses
  Winapi.Windows, Vcl.Graphics, Vcl.Forms, AdvStyleIF, AdvAppStyler;

const
  ZonicoFontName = 'Comfortaa';
  ZonicoTMSStyle = tsWindows8; // look Metro dei TMS VCL UI Pack

  // Palette applicativa: azzurro / grigio / bianco.
  clZonicoAzzurro       = TColor($00E8A15C); // #5CA1E8
  clZonicoAzzurroScuro  = TColor($00C97C3B); // #3B7CC9
  clZonicoAzzurroChiaro = TColor($00FBEEDF); // #DFEEFB
  clZonicoGrigio        = TColor($00787462); // #627478
  clZonicoGrigioChiaro  = TColor($00F0EEEC); // #ECEEF0
  clZonicoBordo         = TColor($00D8D2CC); // #CCD2D8
  clZonicoBianco        = clWhite;

procedure ApplicaTemaColori(AForm: TForm; AStyler: TAdvFormStyler);

// Registra il font Comfortaa incluso in fonts\ senza installarlo nel sistema.
function CaricaFontComfortaa: Boolean;
procedure RilasciaFontComfortaa;

implementation

uses
  System.SysUtils, System.IOUtils;

var
  GFontCaricato: Boolean = False;
  GFontFile: string = '';

procedure ApplicaTemaColori(AForm: TForm; AStyler: TAdvFormStyler);
begin
  if Assigned(AStyler) then
  begin
    AStyler.Style := ZonicoTMSStyle;
    AStyler.AppColor := clZonicoAzzurro;
  end;
  if Assigned(AForm) then
  begin
    AForm.Color := clZonicoBianco;
    AForm.Font.Name := ZonicoFontName;
    AForm.Font.Color := clZonicoGrigio;
  end;
end;

function FontDisponibile(const AFontName: string): Boolean;
begin
  Result := Screen.Fonts.IndexOf(AFontName) >= 0;
end;

function FileFontLocale: string;
begin
  Result := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)),
    TPath.Combine('fonts', 'Comfortaa-Variable.ttf'));
end;

function CaricaFontComfortaa: Boolean;
begin
  if FontDisponibile(ZonicoFontName) then
    Exit(True);

  GFontFile := FileFontLocale;
  if not TFile.Exists(GFontFile) then
    Exit(False);

  GFontCaricato := AddFontResourceEx(PChar(GFontFile), FR_PRIVATE, nil) > 0;
  if GFontCaricato then
    SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
  Result := GFontCaricato;
end;

procedure RilasciaFontComfortaa;
begin
  if not GFontCaricato then
    Exit;
  RemoveFontResourceEx(PChar(GFontFile), FR_PRIVATE, nil);
  GFontCaricato := False;
end;

initialization

finalization
  RilasciaFontComfortaa;

end.
