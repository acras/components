unit osSQLDataSetProvider;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Provider, db, dbclient, variants, sqlexpr, osCustomDataSetProvider;

type
  TosSQLDataSetProvider = class(TosCustomDataSetProvider)
  private
    FInternalDataset: TSQLDataset;
    function GetInternalDataset: TSQLDataset;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {** Dataset interno utilizado para submeter atualizações customizadas
        e Executar métodos internos do DataRequest }
    property InternalDataset: TSQLDataset read GetInternalDataset;
    {** Implementa o método interno (DataRequest) GET_OIDHIGH }
    function GetIDHigh(const PSeqName: string = 'Geral'): OleVariant; override;

  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OS Server', [TosSQLDataSetProvider]);
end;

{ TccDataSetProvider }

constructor TosSQLDataSetProvider.Create(AOwner: TComponent);
begin
  inherited;
  FInternalDataset := TSQLDataset.Create(Self);
end;

destructor TosSQLDataSetProvider.Destroy;
begin
  FInternalDataset.Free;
  inherited;
end;

function TosSQLDataSetProvider.GetInternalDataset: TSQLDataset;
begin
  if Assigned(Dataset) then
  begin
    if Assigned(FInternalDataset.SQLConnection) then
      Result := FInternalDataset
    else
      if (Dataset is TSQLDataset) then
      begin
        FInternalDataset.SQLConnection := TSQLDataset(Dataset).SQLConnection;
        Result := FInternalDataset;
      end
      else
        raise Exception.Create('O Dataset deve ser dbExpress');
  end
  else
    raise Exception.Create('Dataset não informado');
end;

function TosSQLDataSetProvider.GetIDHigh(const PSeqName: string = 'Geral'): OleVariant;
begin
  Result := 0;
  with InternalDataset do
  begin
    if Active then
      Close;
    CommandType := ctStoredProc;
    CommandText := 'OS_GETIDHIGH';
    Params.Clear;
    with Params.CreateParam(ftstring, 'SEQNAME', ptInput) do
      AsString := PSeqName;
    Params.CreateParam(ftInteger, 'HIGHVALUE', ptOutput);
    ExecSQL;
    Result := Params.ParamByName('HighValue').Value;
  end;
end;

end.
