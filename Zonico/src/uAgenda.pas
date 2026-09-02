unit uAgenda;

{ Agenda giornaliera: una colonna per operatore, TMS TPlanner.
  Gli appuntamenti vengono caricati da APPUNTAMENTI per il giorno selezionato;
  spostamento/ridimensionamento nel planner aggiorna INIZIO/FINE/ID_OPERATORE. }

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.DateUtils, Vcl.Controls,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Dialogs, Vcl.Graphics, Data.DB,
  FireDAC.Comp.Client,
  AdvToolBar, AdvDateTimePicker, Planner, PlanUtil;

type
  TfrmAgenda = class(TForm)
    ToolBar: TAdvToolBar;
    btnOggi: TAdvToolBarButton;
    btnPrec: TAdvToolBarButton;
    btnSucc: TAdvToolBarButton;
    dtGiorno: TAdvDateTimePicker;
    sep1: TAdvToolBarSeparator;
    btnNuovo: TAdvToolBarButton;
    btnAggiorna: TAdvToolBarButton;
    Planner: TPlanner;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOggiClick(Sender: TObject);
    procedure btnPrecClick(Sender: TObject);
    procedure btnSuccClick(Sender: TObject);
    procedure dtGiornoChange(Sender: TObject);
    procedure btnNuovoClick(Sender: TObject);
    procedure btnAggiornaClick(Sender: TObject);
    procedure PlannerItemDblClick(Sender: TObject; Item: TPlannerItem);
    procedure PlannerPlannerDblClick(Sender: TObject);
    procedure PlannerItemMove(Sender: TObject; Item: TPlannerItem;
      FromBegin, FromEnd, FromPos, ToBegin, ToEnd, ToPos: Integer);
    procedure PlannerItemSize(Sender: TObject; Item: TPlannerItem;
      FromBegin, FromEnd, ToBegin, ToEnd: Integer);
  private
    FOperatori: array of Integer;   // ID operatore per posizione (colonna)
    procedure CaricaOperatori;
    procedure CaricaAppuntamenti;
    function IdOperatorePos(APos: Integer): Integer;
    function PosOperatore(AId: Integer): Integer;
    procedure SalvaSpostamento(Item: TPlannerItem);
    function ColoreStato(const AStato: string; ADefault: TColor): TColor;
  end;

implementation

uses
  uDM, uSessione, uAppuntamentoDett;

{$R *.dfm}

const
  ORA_APERTURA = 8;
  ORA_CHIUSURA = 20;
  MINUTI_SLOT  = 15;

procedure TfrmAgenda.FormCreate(Sender: TObject);
begin
  Planner.Mode.PlannerType := plDay;
  Planner.Display.DisplayUnit := MINUTI_SLOT;
  Planner.Display.DisplayStart := ORA_APERTURA * 60 div MINUTI_SLOT;
  Planner.Display.DisplayEnd := ORA_CHIUSURA * 60 div MINUTI_SLOT;
  Planner.Display.DisplayScale := 1;
  Planner.Display.CurrentPosFrom := 0;
  Planner.Sidebar.Position := spLeft;
  Planner.Sidebar.ShowMinutes := True;
  Planner.Sidebar.Hourformat := hf24hour;
  Planner.Header.Height := 30;
  Planner.PositionWidth := 180;
  Planner.ReadOnly := not Sessione.PuoScrivere('AGENDA');
  dtGiorno.Date := Date;
  CaricaOperatori;
  CaricaAppuntamenti;
end;

procedure TfrmAgenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmAgenda.CaricaOperatori;
var
  Q: TFDQuery;
  I: Integer;
begin
  Q := DM.NewQuery('SELECT ID, NOME, COLORE FROM OPERATORI WHERE ATTIVO = 1 ORDER BY NOME');
  try
    Q.Open;
    SetLength(FOperatori, Q.RecordCount);
    Planner.Positions := Q.RecordCount;
    Planner.Header.Captions.Clear;
    Planner.Header.Captions.Add('');   // colonna orari
    I := 0;
    while not Q.Eof do
    begin
      FOperatori[I] := Q.FieldByName('ID').AsInteger;
      Planner.Header.Captions.Add(Q.FieldByName('NOME').AsString);
      Inc(I);
      Q.Next;
    end;
    if Planner.Positions = 0 then
    begin
      Planner.Positions := 1;
      Planner.Header.Captions.Add('(nessun operatore)');
    end;
  finally
    Q.Free;
  end;
end;

function TfrmAgenda.IdOperatorePos(APos: Integer): Integer;
begin
  if (APos >= 0) and (APos < Length(FOperatori)) then
    Result := FOperatori[APos]
  else
    Result := 0;
end;

function TfrmAgenda.PosOperatore(AId: Integer): Integer;
var
  I: Integer;
begin
  for I := 0 to High(FOperatori) do
    if FOperatori[I] = AId then
      Exit(I);
  Result := 0;
end;

function TfrmAgenda.ColoreStato(const AStato: string; ADefault: TColor): TColor;
begin
  if AStato = 'CONFERMATO' then Result := $00C8F0C8
  else if AStato = 'ARRIVATO' then Result := $0080E0FF
  else if AStato = 'COMPLETATO' then Result := $00D0D0D0
  else if (AStato = 'ANNULLATO') or (AStato = 'NO_SHOW') then Result := $00C0C0FF
  else if ADefault <> 0 then Result := ADefault
  else Result := $00F5E6CC;
end;

procedure TfrmAgenda.CaricaAppuntamenti;
var
  Q: TFDQuery;
  It: TPlannerItem;
  Giorno: TDateTime;
begin
  Giorno := DateOf(dtGiorno.Date);
  Planner.Mode.Date := Giorno;
  Planner.Items.BeginUpdate;
  try
    Planner.Items.Clear;
    Q := DM.NewQuery(
      'SELECT A.ID, A.INIZIO, A.FINE, A.ID_OPERATORE, A.STATO, A.NOTE, ' +
      '       C.COGNOME||'' ''||COALESCE(C.NOME,'''') AS CLIENTE, S.DESCRIZIONE AS SERVIZIO, O.COLORE ' +
      'FROM APPUNTAMENTI A ' +
      'LEFT JOIN CLIENTI C ON C.ID = A.ID_CLIENTE ' +
      'LEFT JOIN SERVIZI S ON S.ID = A.ID_SERVIZIO ' +
      'LEFT JOIN OPERATORI O ON O.ID = A.ID_OPERATORE ' +
      'WHERE A.INIZIO >= :D1 AND A.INIZIO < :D2 ORDER BY A.INIZIO');
    try
      Q.ParamByName('D1').AsDateTime := Giorno;
      Q.ParamByName('D2').AsDateTime := Giorno + 1;
      Q.Open;
      while not Q.Eof do
      begin
        It := Planner.CreateItem;
        It.DBKey := Q.FieldByName('ID').AsString;
        It.ItemStartTime := Q.FieldByName('INIZIO').AsDateTime;
        It.ItemEndTime := Q.FieldByName('FINE').AsDateTime;
        It.ItemPos := PosOperatore(Q.FieldByName('ID_OPERATORE').AsInteger);
        It.CaptionText := Q.FieldByName('CLIENTE').AsString;
        It.CaptionType := ctText;
        It.Text.Text := Q.FieldByName('SERVIZIO').AsString;
        if Q.FieldByName('NOTE').AsString <> '' then
          It.Text.Add(Q.FieldByName('NOTE').AsString);
        It.Color := ColoreStato(Q.FieldByName('STATO').AsString, Q.FieldByName('COLORE').AsInteger);
        It.Update;
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  finally
    Planner.Items.EndUpdate;
  end;
  Caption := 'Agenda - ' + FormatDateTime('dddd d mmmm yyyy', Giorno);
end;

procedure TfrmAgenda.btnOggiClick(Sender: TObject);
begin
  dtGiorno.Date := Date;
end;

procedure TfrmAgenda.btnPrecClick(Sender: TObject);
begin
  dtGiorno.Date := dtGiorno.Date - 1;
end;

procedure TfrmAgenda.btnSuccClick(Sender: TObject);
begin
  dtGiorno.Date := dtGiorno.Date + 1;
end;

procedure TfrmAgenda.dtGiornoChange(Sender: TObject);
begin
  CaricaAppuntamenti;
end;

procedure TfrmAgenda.btnAggiornaClick(Sender: TObject);
begin
  CaricaOperatori;
  CaricaAppuntamenti;
end;

procedure TfrmAgenda.btnNuovoClick(Sender: TObject);
var
  Inizio, Fine: TDateTime;
  IdOperatore: Integer;
  Tmp: TPlannerItem;
begin
  if not Sessione.PuoScrivere('AGENDA') then
    Exit;
  { item temporaneo sulla selezione corrente per ricavare orario e colonna }
  Tmp := Planner.CreateItemAtSelection;
  try
    Inizio := Tmp.ItemStartTime;
    Fine := Tmp.ItemEndTime;
    IdOperatore := IdOperatorePos(Tmp.ItemPos);
  finally
    Planner.FreeItem(Tmp);
  end;
  if Fine <= Inizio then
    Fine := IncMinute(Inizio, 30);
  if TfrmAppuntamentoDett.Esegui(0, Inizio, Fine, IdOperatore) then
    CaricaAppuntamenti;
end;

procedure TfrmAgenda.PlannerPlannerDblClick(Sender: TObject);
begin
  btnNuovoClick(Sender);
end;

procedure TfrmAgenda.PlannerItemDblClick(Sender: TObject; Item: TPlannerItem);
begin
  if TfrmAppuntamentoDett.Esegui(StrToIntDef(Item.DBKey, 0), 0, 0, 0) then
    CaricaAppuntamenti;
end;

procedure TfrmAgenda.SalvaSpostamento(Item: TPlannerItem);
begin
  DM.ExecSQL(
    'UPDATE APPUNTAMENTI SET INIZIO = :I, FINE = :F, ID_OPERATORE = :O WHERE ID = :ID',
    [Item.ItemStartTime, Item.ItemEndTime, IdOperatorePos(Item.ItemPos), StrToIntDef(Item.DBKey, 0)]);
end;

procedure TfrmAgenda.PlannerItemMove(Sender: TObject; Item: TPlannerItem;
  FromBegin, FromEnd, FromPos, ToBegin, ToEnd, ToPos: Integer);
begin
  SalvaSpostamento(Item);
end;

procedure TfrmAgenda.PlannerItemSize(Sender: TObject; Item: TPlannerItem;
  FromBegin, FromEnd, ToBegin, ToEnd: Integer);
begin
  SalvaSpostamento(Item);
end;

end.
