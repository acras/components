unit osBatchSQL;

interface
uses
  Classes, Variants, SysUtils, provider, sqlexpr, db;

type
  TosQueryDef = class(TCollectionItem)
  private
    FSQL: TStrings;
    procedure SetSQL(const Value: TStrings);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(AOwner: TCollection); override;
    destructor Destroy; override;
  published
    property SQL: TStrings read FSQL write SetSQL;
  end;

  TosQueryDefCollection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TosQueryDef;
    procedure SetItem(Index: Integer; Value: TosQueryDef);
  public
    constructor Create(AOwner: TComponent);
    property Items[Index: Integer]: TosQueryDef read GetItem write SetItem;  default;
  end;

  TosBatchSQL = class(TComponent)
  private
    FParameters: TParams;
    FQueriesDelete: TosQueryDefCollection;
    FQueriesUpdate: TosQueryDefCollection;
    FQueriesInsert: TosQueryDefCollection;
    FApplyQuery: TSQLQuery;    procedure SetQueriesDelete(const Value: TosQueryDefCollection);
    procedure SetQueriesInsert(const Value: TosQueryDefCollection);
    procedure SetQueriesUpdate(const Value: TosQueryDefCollection);
    procedure SetConnection(const Value: TSQLConnection);
    function GetConnection: TSQLConnection;
  protected
    procedure Exec(QueryDefCollection: TosQueryDefCollection; Dataset: TDataset);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Apply(Dataset: TDataset; UpdateKind: TUpdateKind): boolean;
    procedure SetParams(Dataset: TDataset); virtual;
  published
    property QueriesInsert: TosQueryDefCollection read FQueriesInsert write SetQueriesInsert;
    property QueriesUpdate: TosQueryDefCollection read FQueriesUpdate write SetQueriesUpdate;
    property QueriesDelete: TosQueryDefCollection read FQueriesDelete write SetQueriesDelete;
    property Connection: TSQLConnection read GetConnection write SetConnection;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OS Server', [TosBatchSQL]);
end;

{ TosQueryDef }
constructor TosQueryDef.Create(AOwner: TCollection);
begin
  inherited Create(AOwner);
  FSQL := TStringList.Create;
end;

destructor TosQueryDef.Destroy;
begin
  FreeAndNil(FSQL);
  inherited;
end;

function TosQueryDef.GetDisplayName: string;
begin
  Result := inherited GetDisplayName;
end;
procedure TosQueryDef.SetSQL(const Value: TStrings);
begin
  FSQL.Assign(Value);
end;

{ TosQueryDefCollection }
constructor TosQueryDefCollection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner, TosQueryDef);
end;

function TosQueryDefCollection.GetItem(Index: Integer): TosQueryDef;
begin
  Result := TosQueryDef(inherited GetItem(Index));
end;

procedure TosQueryDefCollection.SetItem(Index: Integer; Value: TosQueryDef);
begin
  inherited SetItem(Index, Value);
end;

{ TosBatchSQL }
function TosBatchSQL.Apply(Dataset: TDataset; UpdateKind: TUpdateKind): boolean;
begin
  if not Assigned(Connection) then
    raise Exception.Create('Não definida a propriedade Connection');
  case UpdateKind of
    ukModify: Exec(QueriesUpdate, Dataset);
    ukInsert: Exec(QueriesInsert, Dataset);
    ukDelete: Exec(QueriesDelete, Dataset);
  end;
  Result := True;
end;

constructor TosBatchSQL.Create(AOwner: TComponent);
begin
  inherited;
  FParameters := TParams.Create(Self);
  FQueriesInsert := TosQueryDefCollection.Create(Self);
  FQueriesUpdate := TosQueryDefCollection.Create(Self);
  FQueriesDelete := TosQueryDefCollection.Create(Self);
  FApplyQuery := TSQLQuery.Create(Self);
end;

destructor TosBatchSQL.Destroy;
begin
  FQueriesInsert.Free;
  FQueriesUpdate.Free;
  FQueriesDelete.Free;
  FParameters.Free;
  FApplyQuery.Free;
  inherited;
end;

procedure TosBatchSQL.Exec(QueryDefCollection: TosQueryDefCollection; Dataset: TDataset);
var
  i: integer;
begin
  for i:=0 to QueryDefCollection.Count - 1 do
  begin
    FApplyQuery.SQL.Assign(QueryDefCollection[i].SQL);
    SetParams(Dataset);
    FApplyQuery.ExecSQL;
  end;
end;

function TosBatchSQL.GetConnection: TSQLConnection;
begin
  Result := FApplyQuery.SQLConnection;
end;

procedure TosBatchSQL.SetConnection(const Value: TSQLConnection);
begin
  if FApplyQuery.SQLConnection <> Value then
    FApplyQuery.SQLConnection := Value;
end;

procedure TosBatchSQL.SetParams(Dataset: TDataset);
var
  I: Integer;
  Old: Boolean;
  Param: TParam;
  PName: string;
  Field: TField;
  Value: Variant;
begin
  with FApplyQuery do
  begin
    for I := 0 to Params.Count - 1 do
    begin
      Param := Params[I];
      PName := Param.Name;
      Old := CompareText(Copy(PName, 1, 4), 'OLD_') = 0;
      if Old then System.Delete(PName, 1, 4);
      Field := DataSet.FindField(PName);
      if not Assigned(Field) then Continue;

      if Old then
        Param.AssignFieldValue(Field, Field.OldValue)
      else
      begin
        Value := Field.NewValue;
        if VarIsClear(Value) then
          Value := Field.OldValue;
        Param.AssignFieldValue(Field, Value);
      end;
    end;
  end;
end;

procedure TosBatchSQL.SetQueriesDelete(const Value: TosQueryDefCollection);
begin
  FQueriesDelete.Assign(Value);
end;

procedure TosBatchSQL.SetQueriesInsert(const Value: TosQueryDefCollection);
begin
  FQueriesInsert.Assign(Value);
end;

procedure TosBatchSQL.SetQueriesUpdate(const Value: TosQueryDefCollection);
begin
  FQueriesUpdate.Assign(Value);
end;

end.
