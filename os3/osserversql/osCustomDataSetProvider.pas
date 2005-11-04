unit osCustomDataSetProvider;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Provider, db, dbclient, variants;

type

  TBeforeOSGetRecordsEvent = procedure(Count: Integer; Options: Integer;
      const CommandText: WideString; Params: TParams; var vParams, OwnerData: OleVariant) of object;

  TosCustomDatasetProvider = class(TDataSetProvider)
  private
    FParams: TParams;
    FBeforeOSGetRecords: TBeforeOSGetRecordsEvent;
  protected
    {** Executa a query informada através da interface IProviderSupport }
    procedure DoGetValues(SQL: TStringList; Params: TParams; DataSet: TPacketDataSet);
    {** Implementa o método interno (DataRequest) GET_VIEWS }
    function GetViews(const PUserID, PName: string): OleVariant;
    procedure DoBeforeGetRecords(Count: Integer; Options: Integer;
      const CommandText: WideString; var Params, OwnerData: OleVariant); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {** Métodos customizados internos chamados pelo ClientDataset }
    function DataRequest(Input: OleVariant): OleVariant; override;
    {** Define o método interno (DataRequest) GET_OIDHIGH }
    function GetIDHigh(const PSeqName: string = 'Geral'): OleVariant; virtual; abstract;
  published
    property BeforeOSGetRecords: TBeforeOSGetRecordsEvent read FBeforeOSGetRecords write FBeforeOSGetRecords;
  end;


implementation

{ TccDataSetProvider }

constructor TosCustomDatasetProvider.Create(AOwner: TComponent);
begin
  inherited;
  Options := Options + [poNoReset]; //poIncFieldProps, poNoReset;
end;

function TosCustomDatasetProvider.DataRequest(Input: OleVariant): OleVariant;
var
  sCmd, sUID, sName: string;
begin
  if (VarType(Input) = varOleStr) then
  begin
    sCmd := Input;
    if Copy(sCmd, 1, 5) = '_CMD=' then  // Se for um comando customizado então executa
    begin
      sCmd := Copy(sCmd, 6, Length(sCmd) - 5); // obtém o nome do comando
      if sCmd = 'GET_IDHIGH' then // Obter um OIDHigh para ser utilizado no client
        Result := GetIDHigh
      else if Copy(sCmd, 1, 9)  = 'GET_VIEWS' then // Obter um lista de views
      begin
        sUID := Copy(sCmd, Pos('UID=', sCmd) + 4, Pos('CLASSNAME=', sCmd) + 3);
        sName := Copy(sCmd, Pos('CLASSNAME=', sCmd) + 10, 40);
        Result := GetViews(sUID, sName);
      end;
    end;
  end
  else if (VarType(Input) = 8204) then // ??
  begin
    if Input[0] = '_CMD' then  // Se for um comando customizado então executa
    begin
      sCmd := Input[1];
      if sCmd = 'GET_IDHIGH' then // Obter um OIDHigh para ser utilizado no client
        Result := GetIDHigh(Input[2])
      else if sCmd  = 'GET_VIEWS' then // Obter um lista de views
        Result := GetViews(Input[2], Input[3]);
    end;
  end
  else if VarType(Result) = varEmpty then
    Result := inherited DataRequest(Input);
end;

destructor TosCustomDatasetProvider.Destroy;
begin
  if Assigned(FParams) then
    FParams.Free;
  inherited;
end;

procedure TosCustomDatasetProvider.DoGetValues(SQL: TStringList; Params: TParams;
  DataSet: TPacketDataSet);
var
  DS: TDataSet;
  TempProvider: TDatasetProvider;
begin
  DS := nil;
  IProviderSupport(Self.DataSet).PSExecuteStatement(SQL.Text, Params, @DS);
  if Assigned(DS) then
  begin
    TempProvider := TDataSetProvider.Create(Self);
    Try
      TempProvider.DataSet := DS;
      Dataset.Data := TempProvider.Data;
    finally
      TempProvider.Free;
      DS.Free;
    end;
  end;
end;

function TosCustomDatasetProvider.GetViews(const PUserID, PName: string): OleVariant;
var
  ViewsDataset: TPacketDataset;
  SQL: TStringList;
  iUpperBound, i: integer;
  Params: TParams;
begin
  ViewsDataset := TPacketDataset.Create(Self);
  SQL := TStringList.Create;
  Params := TParams.Create(Self);
  try
    with SQL do
    begin
      Add('SELECT');
      Add('  D.Number,');
      Add('  D.Description,');
      Add('  D.AttributeList,');
      Add('  D.ExpressionList,');
      Add('  D.ConstraintList,');
      Add('  D.OrderList,');
      Add('  D.QueryText');
      Add('FROM XFilterDef F, XFilterDefDetail D');
      Add('WHERE');
      Add('  F.IDXFilterDef = D.IDXFilterDef and');
      Add('  F.Name = ' + QuotedStr(PName));
      Add('ORDER BY');
      Add('  D.Number');
    end;

    DoGetValues(SQL, Params, ViewsDataset);

    with ViewsDataset do
    begin
      if EOF then
        iUpperBound := 0
      else
        iUpperBound := RecordCount - 1;

      Result := VarArrayCreate([0, iUpperBound], varVariant);

      i := 0;
      while not EOF do
      begin
        Result[i] := VarArrayOf([FieldByName('Description').AsString,
                                 FieldByName('QueryText').AsString,
                                 FieldByName('AttributeList').AsString,
                                 FieldByName('ExpressionList').AsString,
                                 FieldByName('ConstraintList').AsString,
                                 FieldByName('OrderList').AsString,
                                 FieldByName('Number').AsString]);
        Inc(i);
        Next;
      end;
      Close;
    end;
  finally
    ViewsDataset.Free;
    Params.Free;
    SQL.Free;
  end;
end;

procedure TosCustomDatasetProvider.DoBeforeGetRecords(Count, Options: Integer;
  const CommandText: WideString; var Params, OwnerData: OleVariant);
begin
  if Assigned(BeforeOSGetRecords) then
  begin
    if not Assigned(FParams) then
      FParams := TParams.Create;
    FParams.Clear;
    UnpackParams(Params, FParams);
    BeforeOSGetRecords(Count, Options, CommandText, FParams, Params, OwnerData);
  end;
  inherited;
end;

end.
