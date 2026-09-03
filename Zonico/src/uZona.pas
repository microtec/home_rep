unit uZona;

interface

type
  TZona = record
    Id: Integer;
    Codice: string;
    Descrizione: string;
    Superficie: Double;
    Attiva: Boolean;
    function IsNew: Boolean;
    function Valida(out AErrore: string): Boolean;
  end;

implementation

uses
  System.SysUtils;

{ TZona }

function TZona.IsNew: Boolean;
begin
  Result := Id <= 0;
end;

function TZona.Valida(out AErrore: string): Boolean;
begin
  AErrore := '';
  if Trim(Codice) = '' then
    AErrore := 'Il codice zona e'' obbligatorio.'
  else if Length(Trim(Codice)) > 20 then
    AErrore := 'Il codice zona non puo'' superare 20 caratteri.'
  else if Trim(Descrizione) = '' then
    AErrore := 'La descrizione e'' obbligatoria.'
  else if Superficie < 0 then
    AErrore := 'La superficie non puo'' essere negativa.';
  Result := AErrore = '';
end;

end.
