unit uClienteDett;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Dialogs, Data.DB,
  AdvEdit, DBAdvEd, AdvGlowButton, AdvPanel, AdvOfficePager, AdvDateTimePicker,
  DBAdvDateTimePicker, AdvCombo, DBAdvCombo;

type
  TfrmClienteDett = class(TForm)
    Pager: TAdvOfficePager;
    pgDati: TAdvOfficePage;
    pgNote: TAdvOfficePage;
    pnlButtons: TAdvPanel;
    btnOk: TAdvGlowButton;
    btnAnnulla: TAdvGlowButton;
    DS: TDataSource;
    lblCognome: TLabel;
    lblNome: TLabel;
    lblSesso: TLabel;
    lblNascita: TLabel;
    lblCell: TLabel;
    lblTel: TLabel;
    lblEmail: TLabel;
    lblIndirizzo: TLabel;
    lblCap: TLabel;
    lblCitta: TLabel;
    lblProv: TLabel;
    lblCF: TLabel;
    edCognome: TDBAdvEdit;
    edNome: TDBAdvEdit;
    cbSesso: TDBAdvComboBox;
    dtNascita: TDBAdvDateTimePicker;
    edCell: TDBAdvEdit;
    edTel: TDBAdvEdit;
    edEmail: TDBAdvEdit;
    edIndirizzo: TDBAdvEdit;
    edCap: TDBAdvEdit;
    edCitta: TDBAdvEdit;
    edProv: TDBAdvEdit;
    edCF: TDBAdvEdit;
    chkAttivo: TDBCheckBox;
    chkPrivacy: TDBCheckBox;
    chkMarketing: TDBCheckBox;
    memNote: TDBMemo;
    procedure btnOkClick(Sender: TObject);
  public
    class function Esegui(ADataSource: TDataSource): Boolean;
  end;

implementation

uses
  uStile;

{$R *.dfm}

class function TfrmClienteDett.Esegui(ADataSource: TDataSource): Boolean;
var
  F: TfrmClienteDett;
begin
  F := TfrmClienteDett.Create(nil);
  ApplicaStileMetro(F);
  try
    F.DS.DataSet := ADataSource.DataSet;
    Result := F.ShowModal = mrOk;
  finally
    F.Free;
  end;
end;

procedure TfrmClienteDett.btnOkClick(Sender: TObject);
begin
  if Trim(DS.DataSet.FieldByName('COGNOME').AsString) = '' then
  begin
    MessageDlg('Il cognome è obbligatorio.', mtWarning, [mbOK], 0);
    edCognome.SetFocus;
    Exit;
  end;
  ModalResult := mrOk;
end;

end.
