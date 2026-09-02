# Zonico – Gestionale per parrucchieri

Applicazione desktop Delphi VCL con componenti **TMS VCL UI Pack**, database **Firebird 2.5** (FireDAC).

## Struttura

```
Zonico.dpr / Zonico.dproj   progetto Delphi (Win32)
src/                        unit e form
db/create_db.sql            script creazione database Firebird 2.5
bin/Zonico.ini              configurazione connessione (accanto all'exe)
```

| Unit | Descrizione |
|------|-------------|
| `uDM` | TDataModule: connessione Firebird (da `Zonico.ini`), helper `NewQuery`/`ExecSQL`/`Scalar` |
| `uSessione` | utente loggato e permessi per modulo (lettura/scrittura/cancellazione) |
| `uLogin` | form di accesso |
| `uMain` | form principale MDI con `TAdvToolBar` |
| `uBaseAnag` | form base anagrafiche (`TDBAdvGrid`, ricerca, toolbar) |
| `uClienti`, `uClienteDett` | anagrafica clienti e scheda dettaglio |
| `uOperatori`, `uServizi`, `uProdotti` | anagrafiche operatori, listino servizi, prodotti/magazzino |
| `uUtenti` | gestione utenti e permessi |
| `uAgenda`, `uAppuntamentoDett` | agenda giornaliera per operatore (`TPlanner`) |
| `uVendite`, `uVenditaDett` | cassa: vendite giornaliere e dettaglio scontrino (servizi + prodotti) |
| `uReport` | incassi per periodo (giorno / operatore / pagamento / servizi) |

## Requisiti

- Delphi 10.x o superiore (VCL, FireDAC con driver Firebird/InterBase)
- TMS VCL UI Pack
- Firebird 2.5 server + `fbclient.dll` (32 bit) accanto all'exe o nel PATH

## Installazione database

```
isql -u SYSDBA -p masterkey -i db\create_db.sql
```

Lo script crea `C:\Zonico\ZONICO.FDB` (modificare il percorso nel `CREATE DATABASE` se necessario)
e inserisce l'utente **admin / admin** (amministratore) e i tipi di pagamento base.

## Configurazione

`bin/Zonico.ini`:

```ini
[Database]
Server=localhost
Port=3050
Path=C:\Zonico\ZONICO.FDB
User=SYSDBA
Password=masterkey
ClientLib=fbclient.dll
```

## Utenti e permessi

Le password sono memorizzate in chiaro nella tabella `UTENTI` (scelta di progetto).
Un utente con `ADMIN = 1` ha tutti i permessi; per gli altri si impostano
lettura/scrittura/cancellazione per ogni modulo (`PERMESSI`) dalla form Utenti.

## Note

- Stile grafico: Metro (`tsWindows8`) applicato da `uStile.ApplicaStileMetro` a ogni form.
- Il progetto non è ancora stato compilato: verificare i nomi di proprietà/eventi TMS
  con la versione installata (in particolare `TPlanner` in `uAgenda`).
- Lo scarico magazzino dei prodotti avviene una sola volta alla prima chiusura della vendita (`VENDITE.CHIUSA`).
