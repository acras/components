unit osComboFilter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, wwdbedit, Wwdotdot, Wwdbcomb, osFilterInspectorForm,
  osExtStringList, osUtils, dbclient, variants, db, osCustomFilterUn;

type
  TViewDef = class(TObject)
  private
    FAttrList: TStrings;
    FExprList: TStrings;
    FConstrList: TStrings;
    FOrderList: TStrings;
    FQueryText: TStrings;
    FNumber: integer;
  public
    constructor Create;
    destructor Destroy; override;
    property AttrList: TStrings read FAttrList write FAttrList;
    property ExprList: TStrings read FExprList write FExprList;
    property ConstrList: TStrings read FConstrList write FConstrList;
    property OrderList: TStrings read FOrderList write FOrderList;
    property QueryText: TStrings read FQueryText write FQueryText;
    property Number: integer read FNumber write FNumber;
  end;

  TosComboFilter = class(TwwDBComboBox)
  private
    FFilterDefName: string;
    FUserID: string;
    FViewDefault: integer;
    FItemIndexDefault: integer; // indica o item a ser selecionado quando iniciar um novo filtro
    customFilterForm: TosCustomFilter;
    procedure SetClientDS(const Value: TClientDataset);
    function GetAttrList(PIndex: integer): TStrings;
    procedure SetUserID(const Value: string);
    procedure SetFilterDefName(const Value: string);
    procedure SetViewDefault(const Value: integer);
  protected
    function GetExpressionFromConstraint(const PConstraint, PValue: string): string;
  public
    FBaseView: TViewDef;
    FGetParams: TNotifyEvent;
    FParams: TParams;
    FLastExpressions: string;
    FLastOrder: string;
    FClientDS: TClientDataset;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CheckDS;
    procedure PrepareQuery(PQuery: TSQLStringList; const PExpressions, POrder, PDefaultExpressions: string);
    function GetConstrList(PIndex: integer): TStrings;
    function GetOrderList(PIndex: integer): TStrings;
    function GetExprList(PIndex: integer): TStrings;
    function GetQueryText(PIndex: integer): TStrings;
    procedure GetViews(PUserID: string = ''; PClassName: string = '');
    procedure ClearViews;
    procedure ExecuteFilter(PNewFilter: boolean = True);
    function ExecuteView(PNumView, PConstraint: integer; PValue: string): boolean;
    procedure ConfigFields(PIndex: integer);
    procedure ResetToItemDefault;
    function getSQLFilter(var index: integer; PNewFilter: boolean = True): String;
  published
    property ClientDS: TClientDataset read FClientDS write SetClientDS;
    property Params: TParams read FParams write FParams;
    property UserID: string read FUserID write SetUserID;
    property FilterDefName: string read FFilterDefName write SetFilterDefName;
    property ViewDefault: integer read FViewDefault write SetViewDefault;
    property GetParams: TNotifyEvent read FGetParams write FGetParams;
  end;

procedure Register;

implementation

uses osCustomFilterFunctionUn;

procedure Register;
begin
  RegisterComponents('OS Controls', [TosComboFilter]);
end;

{ TPsComboFilter }


procedure TosComboFilter.CheckDS;
begin
  if not Assigned(FClientDS) then
    raise Exception.Create(Self.ClassName + ': propriedade ClientDS não informada');
end;

constructor TosComboFilter.Create(AOwner: TComponent);
begin
  inherited;
  FFilterDefName := '';
  FUserID := '';
  FParams := TParams.Create(Self);
end;

destructor TosComboFilter.Destroy;
begin
  ClearViews;
  inherited;
end;

function TosComboFilter.getSQLFilter(var index: integer; PNewFilter: boolean = True): String;
var
  slQuery: TSQLStringList;
  iIndex: integer;
  slExpr, slConstr, slOrder: TStrings;
  InspectorForm: TosFilterInspector;
  bExecuteFilter: boolean;
  nomeCustomFilterClass: string;
  customFilterFunctionClass: TosCustomFilterFunctionClass;
  customFilterFunction: TosCustomFilterFunction;
begin
  iIndex := 0;
  bExecuteFilter := True;
  slQuery := TSQLStringList.Create;
  try
    if Text <> '' then
    begin
      // Repassa a query para o ClientDataset
      FClientDS.Close;
      iIndex := Items.IndexOf(Text);

      //se a pesquisa for comum pelo filtro
      if (trim(TViewDef(Items.Objects[iIndex]).queryText.text)='') OR (trim(TViewDef(Items.Objects[iIndex]).queryText.text)[1] <> 'T') then
      begin
        slQuery.Assign(GetQueryText(iIndex));  // Copia o texto da query

        slExpr := GetExprList(iIndex);
        slConstr := GetConstrList(iIndex);
        slOrder := GetOrderList(iIndex);
        FLastOrder := '';
        if (slOrder.Count > 0) and
           (Copy(UpperCase(slOrder.Text), 1, 5) <> 'FALSE') then
            FLastOrder := GetWord(slOrder[0], 2, '=');
        if PNewFilter then
        begin
          if (Copy(UpperCase(slConstr.Text), 1, 5) <> 'FALSE') and (Trim(slConstr.Text) <> '')  then
          begin
            InspectorForm := TosFilterInspector.Create(Self);
            try
              if InspectorForm.Execute(slConstr, slOrder) then
              begin
                FLastExpressions := InspectorForm.Expressions;
                FLastOrder := InspectorForm.Order;
                PrepareQuery(slQuery, FLastExpressions, FLastOrder, slExpr.Text);
              end
              else
              begin
                FLastExpressions := '';
                FLastOrder := '';
                bExecuteFilter := False;
              end;
            finally
              InspectorForm.Free;
            end;
          end
          else
            PrepareQuery(slQuery, '', FLastOrder, slExpr.Text);
        end
        else
          PrepareQuery(slQuery, FLastExpressions, FLastOrder, slExpr.Text);

        if bExecuteFilter then
        begin
          FParams.ParseSQL(slQuery.Text, True);
          if FParams.Count > 0 then
          begin
            if Assigned(FGetParams) then
              FGetParams(Self);
            FClientDS.Params.Assign(FParams);
          end
          else
            if FClientDS.Params.Count > 0 then
              FClientDS.Params.Clear;
          Result := slQuery.Text;
        end;
      end
      else
      begin
        if PNewFilter then
        begin
          nomeCustomFilterClass := trim(TViewDef(Items.Objects[iIndex]).queryText.text);
          customFilterForm := TosCustomFilterClass(OSGetClass(nomeCustomFilterClass)).create(self);
          customFilterForm.execute(FBaseView.QueryText.gettext);
        end;
        Result := customFilterForm.getQuery;


      end;
      //por último faz o tratamento das funções definidas, dando a chance para uma classe que implemente
      //a interface ICustomFilterFunction
      customFilterFunctionClass := TosCustomFilterFunctionClass(OSGetClass('TFilterFunction'));
      if customFilterFunctionClass <> nil then
      begin
        customFilterFunction := customFilterFunctionClass.Create;
        result := customFilterFunction.evaluateFunctionValues(result);
      end;
    end;
  finally
    slQuery.Free;
  end;
  index := iIndex
end;

procedure TosComboFilter.ExecuteFilter(PNewFilter: boolean = True);
var
  OldCursor: TCursor;
  iIndex: integer;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  try
    try
      if Items.Count = 0 then
        raise Exception.Create('Não há filtros na lista');
      CheckDS;
      FClientDS.CommandText := getSQLFilter(iIndex, PNewFilter);
      FClientDS.DisableControls;
      FClientDS.Open;
      ConfigFields(iIndex);
      FClientDS.EnableControls;
    except
//      on EDatabaseError do
      begin
        FClientDS.Close;
      end;
    end;
  finally
    Screen.Cursor := OldCursor;
  end;
end;

function TosComboFilter.GetAttrList(PIndex: integer): TStrings;
var
  ViewSel, ViewInicial: TViewDef;
begin
  ViewSel := TViewDef(Items.Objects[PIndex]);
  ViewInicial := FBaseView;
  if (not Assigned(ViewSel)) and (not Assigned(ViewInicial))  then
    raise Exception.Create('Não há definições de views para os filtros');

  if Trim(ViewSel.AttrList.Text) <> '' then
    Result := ViewSel.AttrList
  else
    Result := ViewInicial.AttrList;
end;

function TosComboFilter.GetConstrList(PIndex: integer): TStrings;
var
  ViewSel, ViewInicial: TViewDef;
begin
  ViewSel := TViewDef(Items.Objects[PIndex]);
  ViewInicial := FBaseView;
  if (not Assigned(ViewSel)) and (not Assigned(ViewInicial))  then
    raise Exception.Create('Não há definições de views para os filtros');

  if Trim(ViewSel.ConstrList.Text) <> '' then
    Result := ViewSel.ConstrList
  else
    Result := ViewInicial.ConstrList;
end;

function TosComboFilter.GetOrderList(PIndex: integer): TStrings;
var
  ViewSel, ViewInicial: TViewDef;
begin
  ViewSel := TViewDef(Items.Objects[PIndex]);
  ViewInicial := FBaseView;
  if (not Assigned(ViewSel)) and (not Assigned(ViewInicial))  then
    raise Exception.Create('Não há definições de views para os filtros');

  if Trim(ViewSel.OrderList.Text) <> '' then
    Result := ViewSel.OrderList
  else
    Result := ViewInicial.OrderList;
end;

function TosComboFilter.GetQueryText(PIndex: integer): TStrings;
var
  ViewSel, ViewInicial: TViewDef;
begin
  ViewSel := TViewDef(Items.Objects[PIndex]);
  ViewInicial := FBaseView;
  if (not Assigned(ViewSel)) and (not Assigned(ViewInicial))  then
    raise Exception.Create('Não há definições de views para os filtros');

  if Trim(ViewSel.QueryText.Text) <> '' then
    Result := ViewSel.QueryText
  else
    Result := ViewInicial.QueryText;
end;

procedure TosComboFilter.GetViews(PUserID: string; PClassName: string);
var
  vViews: variant;
  i, iMax, iViewDefault, iAux: integer;
  ViewDef: TViewDef;
  OldCursor: TCursor;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  try
    if PUserID = '' then
      PUserID := FUserID;
    if PClassName = '' then
      PClassName := FFilterDefName;
    CheckDS;
    vViews := FClientDS.DataRequest('_CMD=GET_VIEWS UID=  CLASSNAME=' + PClassName);
    //FClientDS.ProviderName
    if ViewDefault <> 0 then
      iViewDefault := ViewDefault
    else
      iViewDefault := -1;

    iAux := 0;
    iMax := VarArrayHighBound(vViews, 1);
    for i:=0 to iMax do
    begin
      ViewDef := TViewDef.Create;
      ViewDef.QueryText.Text := vViews[i][1];
      ViewDef.AttrList.Text := vViews[i][2];
      ViewDef.ExprList.Text := vViews[i][3];
      ViewDef.ConstrList.Text := vViews[i][4];
      ViewDef.OrderList.Text := vViews[i][5];
      ViewDef.Number := StrToIntDef(vViews[i][6], 0);
      if ViewDef.Number <> -1 then // View -1 somente utilizada para definições básicas
      begin
        Items.AddObject(vViews[i][0], ViewDef);
        if (iViewDefault = -1) and (ViewDef.Number = 0) then
          iViewDefault := iAux;
        Inc(iAux);
      end
      else
        FBaseView := ViewDef;
    end;
    ItemIndex := iViewDefault;
    FItemIndexDefault := ItemIndex;
    if not Assigned(FBaseView) then
      FBaseView := TViewDef.Create  // Cria em branco caso não exista uma view básica
    else
      Items.AddObject('<genérica>', FBaseView);
  finally
    Screen.Cursor := OldCursor;
  end;
end;

procedure TosComboFilter.PrepareQuery(PQuery: TSQLStringList; const PExpressions, POrder, PDefaultExpressions: string);
begin
  with PQuery do
  begin
    InsertWhere(PDefaultExpressions);
    InsertWhere(PExpressions);
    InsertOrder(POrder);
  end;
end;

procedure TosComboFilter.SetViewDefault(const Value: integer);
begin
  FViewDefault := Value;
end;

procedure TosComboFilter.SetClientDS(const Value: TClientDataset);
begin
  FClientDS := Value;
end;

procedure TosComboFilter.SetUserID(const Value: string);
begin
  FUserID := Value;
end;

procedure TosComboFilter.SetFilterDefName(const Value: string);
begin
  FFilterDefName := Value;
end;

{ TPsViewDef }

constructor TViewDef.Create;
begin
  FAttrList := TStringList.Create;
  FExprList := TStringList.Create;
  FConstrList := TStringList.Create;
  FOrderList := TStringList.Create;
  FQueryText := TStringList.Create;
end;

destructor TViewDef.Destroy;
begin
  FAttrList.Free;
  FExprList.Free;
  FConstrList.Free;
  FOrderList.Free;
  FQueryText.Free;
  inherited;
end;


function TosComboFilter.ExecuteView(PNumView, PConstraint: integer;
  PValue: string): boolean;
var
  slQuery: TSQLStringList;
  slConstr, slExpr: TStrings;
  //slOrder: TStrings;
  sExpr: string;
  OldCursor: TCursor;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  Result := False;
  slQuery := TSQLStringList.Create;
  try
    FClientDS.Close;
    if PNumView = -1 then
    begin
      // Repassa a query para o ClientDataset
      slQuery.Assign(FBaseView.QueryText);
      slExpr := FBaseView.ExprList;
      slConstr := FBaseView.ConstrList;
      //slOrder := FBaseView.OrderList;
      if slConstr.Count > PConstraint then
      begin
        sExpr := GetExpressionFromConstraint(slConstr[PConstraint], PValue);
        PrepareQuery(slQuery, sExpr, '', slExpr.Text);
        FClientDS.CommandText := slQuery.Text;
        FClientDS.DisableControls;
        FClientDS.Open;
        FClientDS.EnableControls;
        Result := True;
      end;
    end;
  finally
    slQuery.Free;
    Screen.Cursor := OldCursor;
  end;
end;

function TosComboFilter.GetExpressionFromConstraint(const
  PConstraint, PValue: string): string;
var
  sAux: string;
begin
  sAux := GetWord(PConstraint, 2, ';'); // Expressão
  Result := Format(sAux,[PValue]);
  ReplaceConstraintChars(Result);
end;

procedure TosComboFilter.ConfigFields(PIndex: integer);
var
  i: integer;
  slAttr: TStrings;
  sLabel: string;
begin
  // Ajusta os fields
  slAttr := GetAttrList(PIndex);
  for i:=0 to FClientDS.Fields.Count - 1 do
  begin
    if FClientDS.Fields[i].FieldName = 'OID' then
      FClientDS.Fields[i].Visible := False;
    sLabel := slAttr.Values[FClientDS.Fields[i].FieldName];
    if sLabel <> '' then
    begin
      if Pos(';', sLabel) <> 0 then  // contém o DisplayWidth
      begin
        FClientDS.Fields[i].DisplayWidth := StrToIntDef(GetWord(sLabel, 2, ';'), FClientDS.Fields[i].DisplayWidth);
        sLabel := GetWord(sLabel, 1, ';');
      end;
      FClientDS.Fields[i].DisplayLabel := sLabel;
    end
    else
      FClientDS.Fields[i].Visible := False;
  end;
end;

procedure TosComboFilter.ResetToItemDefault;
begin
  ItemIndex := FItemIndexDefault;
end;

procedure TosComboFilter.ClearViews;
var
  i: integer;
begin
  for i:=0 to Items.Count - 1 do
    if Assigned(Items.Objects[i]) then
    begin
      Items.Objects[i].Free;
      Items.Objects[i] := nil;
    end;
  Items.Clear;
  Text := '';
end;

function TosComboFilter.GetExprList(PIndex: integer): TStrings;
var
  ViewSel, ViewInicial: TViewDef;
begin
  ViewSel := TViewDef(Items.Objects[PIndex]);
  ViewInicial := FBaseView;
  if (not Assigned(ViewSel)) and (not Assigned(ViewInicial))  then
    raise Exception.Create('Não há definições de views para os filtros');

  if Trim(ViewSel.ExprList.Text) <> '' then
    Result := ViewSel.ExprList
  else
    Result := ViewInicial.ExprList;
end;


end.
