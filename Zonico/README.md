# Zonico

Applicazione gestionale desktop Delphi 10.2 Tokyo (VCL) su database Firebird 2.5 via FireDAC:
accesso con PIN, ruoli e permessi per area, home con le aree applicative abilitate all'utente.

## Requisiti

- Delphi 10.2 Tokyo (Win32)
- Solo VCL standard e FireDAC: nessuna libreria di componenti di terze parti
- Firebird 2.5 (server o embedded) e relativo `fbclient.dll` / `fbembed.dll` a 32 bit

## Struttura

| Percorso | Contenuto |
| --- | --- |
| `Zonico.dpr` / `Zonico.dproj` | progetto Delphi 10.2 |
| `src/uLogin.pas` | pagina di accesso con PIN (modale), logo e tastierino |
| `src/uControlliMetro.pas` | pulsanti piatti, tasti rotondi e tastierino disegnati |
| `src/uFormBase.pas` | modello di form modale da cui derivare le altre form |
| `src/uMain.pas` | home con le aree applicative abilitate |
| `src/uConferma.pas` | form modale unica per conferme e avvisi |
| `src/uDM.pas` | data module: connessione FireDAC/Firebird |
| `src/uDbFirebird.pas` | verifica presenza dello schema su `RDB$RELATIONS` |
| `src/uUtenteRepository.pas` | autenticazione PIN, ruolo e permessi area |
| `sql/zonico_schema.sql` | script di creazione del database Firebird 2.5 |
| `src/uAppTheme.pas` | palette colori e caricamento font |
| `fonts/` | Comfortaa (OFL) caricato a runtime |
| `images/logo.png` | immagine della login, sostituibile senza ricompilare |

## Interfaccia

- **Font**: Comfortaa su tutte le form. Se non è installato nel sistema viene registrato a runtime
  (`AddFontResourceEx`, solo per il processo) dal file `fonts/Comfortaa-Variable.ttf` che deve essere
  copiato accanto all'eseguibile.
- **Stile**: look Metro ottenuto con controlli disegnati in `uControlliMetro` (superfici piatte,
  nessun gradiente o bevel, stati hover/press sull'accento azzurro). I pulsanti sono creati a
  runtime, quindi non serve installare componenti nell'IDE.
- **Colori**: palette azzurro / grigio / bianco definita in `uAppTheme` (`clZonicoAzzurro`,
  `clZonicoGrigio`, `clZonicoBianco`, ...).
- **Conferme**: ogni conferma o avviso passa da `TfrmConferma`, sempre aperta con `ShowModal`.
- **Login**: pannello azzurro a sinistra con l'immagine `images/logo.png` e, a destra, il PIN
  mascherato con il tastierino numerico (`TTastierinoNumerico`): tasti rotondi flat 1-9, `C`
  (cancella l'ultima cifra), `0` e `OK`. Il PIN si puo' comporre anche da tastiera fisica.

## Accesso

All'avvio viene mostrata la pagina di login modale: l'accesso avviene inserendo un PIN numerico
di minimo 5 e massimo 8 cifre (`PinValido` in `uUtenteRepository`), confrontato con `UTENTI.U_PIN`
sui soli utenti con `U_ATTIVO = 1`. Se la finestra viene chiusa senza autenticarsi l'applicazione
termina. Lo script di creazione inserisce l'utente `admin` con PIN `12345`, da cambiare con
`TUtenteRepository.ImpostaPin`.

Dopo l'accesso vengono caricati ruolo (`RUOLI`) e aree consentite (`PERMESSI_AREA` / `AREE`):
nella home le aree non permesse restano disabilitate.

## Aree

| Codice | Area |
| --- | --- |
| `ANAG` | Anagrafiche e Magazzino |
| `VEND` | Vendite e Contabilita |
| `REPO` | Report |
| `AMMI` | Amministrazione |

I contenuti delle aree non sono ancora implementati: i pulsanti mostrano un avviso modale.

## Nuove form

`TfrmBase` (<code>src/uFormBase.pas</code>) e' il modello per le prossime form: testata azzurra con
`Titolo` / `Descrizione`, corpo vuoto (`pnlCorpo`) e barra comandi con Conferma / Annulla gia'
collegati. La form derivata ridefinisce i punti di estensione:

```pascal
TfrmClienti = class(TfrmBase)
protected
  procedure Inizializza; override;                     // controlli su pnlCorpo
  function Valida(out AMessaggio: string): Boolean; override;
  procedure Salva; override;                           // solo se Valida = True
end;

if TfrmClienti.Esegui(Self) then ...                   // sempre ShowModal
```

Invio conferma, Esc annulla (con richiesta di conferma tramite `TfrmConferma`).

## Database

Firebird 2.5, connessione FireDAC `DriverID=FB` configurata nel file `Zonico.ini` che deve
essere copiato accanto all'eseguibile. Sezione `[DATABASE]`:

| Chiave | Significato |
| --- | --- |
| `IndirizzoIP` | IP o nome host del server Firebird |
| `Port` | porta del servizio (default `3050`) |
| `Alias` | alias del database definito in `aliases.conf` sul server |
| `Percorso` | percorso completo del `.FDB`, usato solo se `Alias` e' vuoto |
| `User_Name` / `Password` | credenziali del database |
| `Protocol` | `TCPIP` per il server, `Local` per embedded |
| `CharacterSet` | set di caratteri della connessione |
| `VendorLib` | `fbclient.dll` 32 bit da caricare (vuoto = ricerca nel PATH) |

Se il file manca o non contiene ne' `Alias` ne' `Percorso` l'avvio si interrompe con un errore.

Lo schema non viene creato dall'applicazione: prima del primo avvio creare il database ed
eseguire `sql/zonico_schema.sql` (tabelle, generatori, trigger e dati iniziali). All'avvio
l'applicazione verifica la presenza di `RUOLI`, `UTENTI`, `AREE` e `PERMESSI_AREA` e si ferma
con un errore esplicito se lo script non e' stato eseguito.

```
isql -u SYSDBA -p masterkey
SQL> CREATE DATABASE 'C:\Zonico\DB\ZONICO.FDB' USER 'SYSDBA' PASSWORD 'masterkey'
     PAGE_SIZE 8192 DEFAULT CHARACTER SET UTF8;
SQL> INPUT 'sql\zonico_schema.sql';
```

Con `DEFAULT CHARACTER SET UTF8` impostare `CharacterSet=UTF8` in `Zonico.ini`.

## Build

Aprire `Zonico.dproj` in Delphi 10.2 e compilare (Win32), oppure da riga di comando:

```
msbuild Zonico.dproj /t:Build /p:Config=Release /p:Platform=Win32
```

Copiare le cartelle `fonts` e `images` accanto all'eseguibile prodotto in `bin\Win32\Release`.
Per personalizzare la login basta sostituire `images/logo.png` (PNG, area 160x160); se il file
manca la login mostra solo il testo.
