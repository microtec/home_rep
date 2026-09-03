# Zonico

Applicazione desktop Delphi 10.2 Tokyo (VCL) per la gestione delle zone: ricerca, inserimento,
modifica ed eliminazione con persistenza su database Firebird 2.5 via FireDAC.

## Requisiti

- Delphi 10.2 Tokyo (Win32)
- TMS VCL UI Pack installato (TAdvPanel, TAdvEdit, TAdvGlowButton, TDBAdvGrid, TAdvFormStyler)
- Firebird 2.5 (server o embedded) e relativo `fbclient.dll` / `fbembed.dll` a 32 bit

## Struttura

| Percorso | Contenuto |
| --- | --- |
| `Zonico.dpr` / `Zonico.dproj` | progetto Delphi 10.2 |
| `src/uLogin.pas` | pagina di accesso con PIN (modale) |
| `src/uMain.pas` | elenco zone, ricerca e comandi |
| `src/uZonaEdit.pas` | form modale di inserimento/modifica |
| `src/uConferma.pas` | form modale unica per conferme e avvisi |
| `src/uDM.pas` | data module: connessione FireDAC/Firebird e dataset |
| `src/uZona.pas` | record `TZona` con validazione |
| `src/uZonaRepository.pas` | accesso dati zone (schema + CRUD) |
| `src/uDbFirebird.pas` | helper DDL Firebird (tabelle, generator, ID) |
| `src/uUtenteRepository.pas` | accesso dati utenti e validazione PIN |
| `src/uAppTheme.pas` | palette colori, stile TMS e caricamento font |
| `fonts/` | Comfortaa (OFL) caricato a runtime |

## Interfaccia

- **Font**: Comfortaa su tutte le form. Se non è installato nel sistema viene registrato a runtime
  (`AddFontResourceEx`, solo per il processo) dal file `fonts/Comfortaa-Variable.ttf` che deve essere
  copiato accanto all'eseguibile.
- **Stile**: look Metro tramite `TAdvFormStyler` (`tsWindows8`) impostato in `uAppTheme`.
- **Colori**: palette azzurro / grigio / bianco definita in `uAppTheme` (`clZonicoAzzurro`,
  `clZonicoGrigio`, `clZonicoBianco`, ...).
- **Conferme**: ogni conferma o avviso passa da `TfrmConferma`, sempre aperta con `ShowModal`.

## Accesso

All'avvio viene mostrata la pagina di login modale: l'accesso avviene inserendo un PIN numerico
di minimo 5 e massimo 8 cifre (`PinValido` in `uUtenteRepository`). Se la finestra viene chiusa
senza autenticarsi l'applicazione termina. Al primo avvio viene creato l'utente `Amministratore`
con PIN `12345`, da cambiare con `TUtenteRepository.ImpostaPin`.

## Database

Firebird 2.5, connessione FireDAC `DriverID=FB` configurata in `Zonico.ini` accanto
all'eseguibile (vedi `Zonico.ini.sample`: percorso `.FDB`, credenziali, `Protocol=TCPIP` per il
server o `Local` per l'embedded, `VendorLib` per il client Firebird da caricare).

Il database deve esistere: creare il file `.FDB` con `gbak`/`isql` prima del primo avvio.
Le tabelle vengono create dall'applicazione se mancanti (Firebird 2.5 non supporta
`IF NOT EXISTS`, quindi il DDL e' condizionato leggendo `RDB$RELATIONS`):

- `ZONE` (`ID`, `CODICE` univoco, `DESCRIZIONE`, `SUPERFICIE`, `ATTIVA`) con generator `GEN_ZONE_ID`
- `UTENTI` (`ID`, `NOME`, `PIN`) con generator `GEN_UTENTI_ID`

## Build

Aprire `Zonico.dproj` in Delphi 10.2 e compilare (Win32), oppure da riga di comando:

```
msbuild Zonico.dproj /t:Build /p:Config=Release /p:Platform=Win32
```

Copiare la cartella `fonts` accanto all'eseguibile prodotto in `bin\Win32\Release`.
