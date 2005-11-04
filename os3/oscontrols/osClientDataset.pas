unit osClientDataset;

interface

uses
  sysutils, classes, dbtables, typinfo, contnrs, dbclient, dialogs,
  db, provider, variants;

type
  TosClientDataset = class(TClientDataset)
  private
    FDataProvider : TCustomProvider;
    FIDHighValue: integer;
    FIDLowValue: integer;
    FIDField: TField;
    FRootClientDS: TosClientDataset;
    //FOnUserReconcileError: TReconcileErrorEvent;
    FClosedLookup: boolean;
    FDataLink: TDataLink;
    FHasKey: boolean;
    FBizDatamoduleName: string;
    FIDName: string;
    FDeleteDetails: boolean;
    procedure InitAppServer;
    procedure SetDataProvider(Value : TCustomProvider);
    procedure SetClosedLookup(const Value: boolean);
    procedure RefreshParams;
    function GetMasterDataSource: TDataSource;
    procedure SetMasterDataSource(const Value: TDataSource);
    function GetHasKey: boolean;
    function GetIDField: TField;
    function GetQuotedString(const PStr: string): string;

    procedure ClearDataSet(DataSet: TDataSet);
    procedure ClearDetails(DataSet: TDataSet);
  protected
    FClearing : boolean;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure DoBeforePost; override;
    procedure DoOnNewRecord; override;
    procedure DoBeforeOpen; override;
    procedure DoBeforeDelete; override;
    procedure OpenCursor(InfoQuery: Boolean = False); override;
    {procedure HandleReconcileError(DataSet: TClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction); }
    procedure Loaded; override;

    property RootClientDS: TosClientDataset read FRootClientDS;
    property DataLink: TDataLink read FDataLink;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetNewID: integer;
    procedure RefreshCalcFields;
    function Lookup(const KeyFields: string; const KeyValues: Variant;
      const ResultFields: string): Variant; override;
    procedure GetRecordByID(const PID: integer);
    procedure CloseCursor; override;
    procedure Post; override;
    //procedure LoadFromDataset(PDataset: TDataset);
    property IDField: TField read GetIDField;
  published
    property DataProvider : TCustomProvider read FDataProvider write SetDataProvider;
    property ClosedLookup: boolean read FClosedLookup write SetClosedLookup default False;
    property MasterDataSource: TDataSource read GetMasterDataSource write SetMasterDataSource;
    property HasKey: boolean read GetHasKey;
    property BizDatamoduleName: string read FBizDatamoduleName write FBizDatamoduleName;
    property IDName: string read FIDName write FIDName;
    property DeleteDetails: boolean read FDeleteDetails write FDeleteDetails default True;
    property Active stored False;
  end;

  // Utilizada para estabelecer relacionamentos mestre-detalhe
  TccClientDataLink = class(TDetailDataLink)
  private
    FClientDataset: TosClientDataset;
  protected
    procedure ActiveChanged; override;
    procedure RecordChanged(Field: TField); override;
    function GetDetailDataSet: TDataSet; override;
    procedure CheckBrowseMode; override;
  public
    constructor Create(AClientDataset: TosClientDataset);
  end;

  TStringListExt = class(TStringList)
  private
    FElementFormat: string;
    FSeparator: string;
    function GetAsFmtText: string;
    procedure SetElementFormat(const Value: string);
    procedure SetSeparator(const Value: string);
  public
    constructor Create; virtual;
    procedure PrepareForID;
  published
    property Separator: string read FSeparator write SetSeparator;
    property ElementFormat: string read FElementFormat write SetElementFormat;
    property AsFmtText: string read GetAsFmtText;
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OS Controls', [TosClientDataset]);
end;

{ TosClientDataset }

procedure TosClientDataset.CloseCursor;
begin
  inherited CloseCursor;
  if Assigned(DataProvider) then // Only reset AppServer if we're using a local connection
    InitAppServer;
end;

constructor TosClientDataset.Create(AOwner: TComponent);
begin
  inherited;
  FIDHighValue := -1;
  FIDLowValue := 0;
  FClosedLookup := False;
  FetchOnDemand := False;
  FDataLink := TccClientDataLink.Create(Self);
  FIDField := nil;
  FHasKey := False;
  FClearing := False;
  FDeleteDetails := True;
end;

destructor TosClientDataset.Destroy;
begin
  FDataLink.Free;
  inherited;
end;

procedure TosClientDataset.DoBeforeOpen;
begin
  inherited;
  if Assigned(DatasetField) then
    if Assigned(TosClientDataset(DatasetField.Dataset).RootClientDS) then
      FRootClientDS := TosClientDataset(DatasetField.Dataset).RootClientDS
    else
      FRootClientDS := TosClientDataset(DatasetField.Dataset);
end;

procedure TosClientDataset.DoOnNewRecord;
begin
  if Assigned(FIDField) then
    FIDField.Value := GetNewID;
    //FIDField.AsString := IntToHex(GetNewID, 12);
  inherited;
end;

function TosClientDataset.GetHasKey: boolean;
begin
  Result := Assigned(IDField);
end;

function TosClientDataset.GetMasterDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TosClientDataset.GetNewID: integer;
var
  v: variant;
  vCmd: OleVariant;
  sName: string;
begin
  // Se estourou a faixa, lê um novo HighValue
  if Assigned(FRootClientDS) then  // Se é detalhe pede o valor para o "raiz"
    Result := FRootClientDS.GetNewID
  else // é o raiz, fornece o valor
  begin
    if (FIDLowValue = 10) or (FIDHighValue = -1) then
    begin
      sName := IDName;
      if sName = '' then
        sName := 'Geral';
      vCmd := VarArrayOf(['_CMD','GET_IDHIGH',sName]);
      v := DataRequest(vCmd);
      if v = NULL then
        raise Exception.Create('Não conseguiu obter o ID do server para inclusão');
      FIDHighValue := v; // por convenção
      FIDLowValue := 0;
    end;
    Result := FIDHighValue * 10 + FIDLowValue;
    Inc(FIDLowValue);
  end;
end;

function TosClientDataset.GetIDField: TField;
var
  i: integer;
begin
  if not Assigned(FIDField) then
  begin
    for i:=0 to Fields.Count-1 do
      if pfInKey in Fields[i].ProviderFlags then
      begin
        FIDField := Fields[i];
        break;
      end;
    if not Assigned(FIDField) then
      FIDField := FindField('ID');
  end;
  Result := FIDField;
end;

procedure TosClientDataset.GetRecordByID(const PID: integer);
begin
  if Assigned(FIDField) then
  begin
    Close;
    Params.ParamByName('ID').AsInteger := PID;
    Open;
  end;
end;

{
procedure TosClientDataset.HandleReconcileError(DataSet: TClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  if Assigned(FOnUserReconcileError) then
    FOnUserReconcileError(DataSet, E, UpdateKind, Action);
  ShowMessage(E.Message);
end;
}

procedure TosClientDataset.InitAppServer;
begin
try
  if FDataProvider is TCustomProvider then
    AppServer := TLocalAppServer.Create(TCustomProvider(FDataProvider))
  else
    AppServer := TLocalAppServer.Create(TDataset(FDataProvider));
except
  on EDatabaseError do
    Abort;
end;

end;

procedure TosClientDataset.Loaded;
//var
//  TempParam: TParam;
//  TempComp: TComponent;
begin
  inherited;
  {
  if (not Assigned(DataProvider)) and (Trim(BizDatamoduleName)<>'') then
  begin
    TempComp := GetComponentByName(GetDatamoduleByName(BizDatamoduleName),'prvMaster', TCustomProvider);
    if Assigned(Tempcomp) then
      DataProvider := TCustomProvider(TempComp);
  end;
  }
  {
  if Assigned(OnReconcileError) then
    FOnUserReconcileError := OnReconcileError;
  OnReconcileError := HandleReconcileError;
  }

  { Ex de parâmetros automáticos
  if cfEmpresa in FCustomFilterOptions then
  begin
    TempParam := Params.FindParam('Empresa');
    if not Assigned(TempParam) then
      TempParam := Params.CreateParam(ftString, 'Empresa', ptInput);
    TempParam.AsString := GlobalEmpresa;
  end;
  }
end;

{
procedure TosClientDataset.LoadFromDataset(PDataset: TDataset);
var
  prvTemp: TDataSetProvider;
  bActive: boolean;
begin
  bActive := PDataset.Active;
  prvTemp := TDataSetProvider.Create(Self);
  try
    prvTemp.DataSet := PDataset;
    if not bActive then
      PDataset.Open;
    Self.Data := prvTemp.Data;
    if not bActive then
      PDataset.Close;
  finally
    prvTemp.Free;
  end;
end;
}

function TosClientDataset.Lookup(const KeyFields: string;
  const KeyValues: Variant; const ResultFields: string): Variant;
var
  Param: TParam;
begin
  Result := Null;
  if KeyValues <> Null then
  begin
    if FClosedLookup then
    begin
      //if not ((HasKey) and (KeyFields = IDField.FieldName)) then
      //  raise Exception.Create('Não é possivel fazer ClosedLookup de fields diferentes de ID.');

      if IDField.AsString <> VarToStr(KeyValues) then // Se já estiver na memória
      begin
        Param := Params.FindParam(KeyFields);
        if not Assigned(Param) then
          raise Exception.CreateFmt('O parâmetro chave é necessário para se fazer ClosedLookup - Componente: %s', [Self.Name]);
        Close;
        Param.Value := KeyValues;
        Open;
      end;
      if LocateRecord(KeyFields, KeyValues, [], False) then
      begin
        SetTempState(dsCalcFields);
        try
          CalculateFields(TempBuffer);
          Result := FieldValues[ResultFields];
        finally
          RestoreState(dsBrowse);
        end;
      end;
    end
    else  // Executa o lookup padrão (do ancestral), ou seja com os dados armazenados internamente
    begin
      Result := inherited Lookup(KeyFields, KeyValues, ResultFields);
    end;
  end;
end;

procedure TosClientDataset.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDataProvider) then
    AppServer := nil;
end;

procedure TosClientDataset.OpenCursor(InfoQuery: Boolean);
begin
  inherited OpenCursor(InfoQuery);
  if not InfoQuery then
    GetIDField;
end;

procedure TosClientDataset.RefreshCalcFields;
begin
  GetCalcFields(ActiveBuffer);
end;

procedure TosClientDataset.RefreshParams;
var
  DataSet: TDataSet;
  i: integer;
  sFieldName: string;
begin
  DisableControls;
  try
    if FDataLink.DataSource <> nil then
    begin
      DataSet := FDataLink.DataSource.DataSet;
      if DataSet <> nil then
        if DataSet.Active and (DataSet.State <> dsSetKey) then
        begin
          Close;
          for i := 0 to Params.Count - 1 do
          begin
            sFieldName := Params[i].Name;
            sFieldName := Trim(StringReplace(sFieldName, '*', '', []));
            if not Dataset.FieldByName(sFieldName).IsNull then
              Params[i].Value := Dataset.FieldByName(sFieldName).Value;
          end;
          Open;
        end;
    end;
  finally
    EnableControls;
  end;
end;

procedure TosClientDataset.SetClosedLookup(const Value: boolean);
begin
  FClosedLookup := Value;
end;

procedure TosClientDataset.SetDataProvider(Value: TCustomProvider);
begin

  if Value <> FDataProvider then
  begin
    FDataProvider := Value;
    {Calling FreeNotification ensures that this component will receive an}
    {opRemove when Value is either removed from its owner or when it is destroyed.}
    if FDataProvider <> nil then
    begin
      FDataProvider.FreeNotification(Self);
      {Assign the provider from the host provider component to the ClientDataset (ourself)}
      InitAppServer;
    end
    else
      AppServer := nil;
  end;
end;

procedure TosClientDataset.SetMasterDataSource(const Value: TDataSource);
begin
  if IsLinkedTo(Value) then
    DatabaseError('Referência circular', Self);
  FDataLink.DataSource := Value;
end;

procedure TosClientDataset.DoBeforePost;
begin
  inherited;

end;

procedure TosClientDataset.Post;
begin
  try
    inherited;
  except
    On E: EDatabaseError do
    begin
      if Pos('must have', E.Message) <> 0 then
        raise Exception.Create('Obrigatório: ' + GetQuotedString(E.Message))
      else
        raise;
    end;
  end;

end;

function TosClientDataset.GetQuotedString(const PStr: string): string;
var
  i, iLen: integer;
  bCapture: boolean;
begin
  Result := '';
  bCapture := False;
  iLen := Length(PStr);
  for i:=1 to iLen do
    if bCapture then
      if PStr[i] <> '''' then
        Result := Result + PStr[i]
      else
        break
    else
      if PStr[i] = '''' then
        bCapture := True;
end;

procedure TosClientDataset.DoBeforeDelete;
begin
  inherited;
  if FDeleteDetails and not FClearing then
    ClearDetails(Self);

  if DataSetField <> nil then
    DataSetField.DataSet.Edit;
end;

procedure TosClientDataset.ClearDataSet(DataSet: TDataSet);
begin
  if DataSet is TosClientDataSet then
    TosClientDataSet(DataSet).FClearing := True;
  try
    DataSet.First;
    while not DataSet.Eof do
    begin
      ClearDetails(DataSet);
      DataSet.Delete;
    end;
  finally
    if DataSet is TosClientDataSet then
      TosClientDataSet(DataSet).FClearing := False;
  end;
end;

procedure TosClientDataset.ClearDetails(DataSet: TDataSet);
var
  i: integer;
begin
  for i := 0 to DataSet.FieldCount - 1 do
    if ftDataSet = DataSet.Fields[i].DataType then
      ClearDataSet(TDataSetField(DataSet.Fields[i]).NestedDataSet);
end;

{ TccClientDataLink }

procedure TccClientDataLink.ActiveChanged;
begin
  if FClientDataset.Active then FClientDataset.RefreshParams;
end;

procedure TccClientDataLink.CheckBrowseMode;
begin
  if FClientDataset.Active then FClientDataset.CheckBrowseMode;
end;

constructor TccClientDataLink.Create(AClientDataset: TosClientDataset);
begin
  inherited Create;
  FClientDataset := AClientDataset;
end;

function TccClientDataLink.GetDetailDataSet: TDataSet;
begin
  Result := FClientDataset;
end;

procedure TccClientDataLink.RecordChanged(Field: TField);
begin
  if (Field = nil) and FClientDataset.Active then FClientDataset.RefreshParams;
end;

{ TStringListExt }

constructor TStringListExt.Create;
begin
  inherited;
  FSeparator := '';
  FElementFormat := '';
end;

function TStringListExt.GetAsFmtText: string;
var
  i: integer;
  sSep: string;
begin
  Result := '';
  sSep := '';
  for i:=0 to Count - 1 do
  begin
    Result := Result + sSep + Format(FElementFormat, [Strings[i]]);
    sSep := FSeparator;
  end;
end;

procedure TStringListExt.PrepareForID;
begin
  FSeparator := ',';
  FElementFormat := '''%s''';
end;

procedure TStringListExt.SetElementFormat(const Value: string);
begin
  FElementFormat := Value;
end;

procedure TStringListExt.SetSeparator(const Value: string);
begin
  FSeparator := Value;
end;

end.


