unit osExtStringList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls;

type

  TExtStringList = class(TStringList)
  private
    FElementFormat: string;
    FSeparator: string;
    function GetAsFmtText: string;
    procedure SetElementFormat(const Value: string);
    procedure SetSeparator(const Value: string);
  public
    constructor Create; virtual;
    procedure PrepareForID;
    procedure SetMacro(Macro: string; Value: string);
    function IndexOfSubstr(Substr: string): integer;
  published
    property Separator: string read FSeparator write SetSeparator;
    property ElementFormat: string read FElementFormat write SetElementFormat;
    property AsFmtText: string read GetAsFmtText;
  end;


  {**
     Utilizado para modificar strings de SQL. Contém métodos para adição de cláusulas WHERE, GROUP BY e ORDER BY.
  }
  TSQLStringList = class(TExtStringList)
  private
    FFieldIndex: integer;
    FFromIndex: integer;
    FWhereIndex: integer;
    FOrderByIndex: integer;
    FGroupByIndex: integer;
    FExpressionIndex: integer;
  protected
    procedure SplitClauses;
    procedure InsertExpression(Expression: string);

  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure RefreshPositionIndexes;
    procedure InsertWhere(Expression: string);
    procedure InsertWhereInt(Field: string; Value: string);
    procedure InsertWhereIntOp(Field: string; Operator: string; Value: string);
    procedure InsertWhereStr(Field: string; Value: string);
    procedure InsertWhereStrLike(Field: string; Value: string);
    procedure InsertWhereStrBetween(Field: string; FirstValue: string; LastValue: string);
    procedure InsertWhereDateBetween(Field: string; FirstValue: string; LastValue: string);overload;
    procedure InsertWhereDateBetween(Field: string; FirstValue: TDateTime; LastValue: TDateTime); overload;
    procedure InsertWhereStrOp(Field: string; Operator: string; Value: string);
    procedure InsertOrderBy(Field: string);
    procedure InsertField(Field: string);
    procedure InsertOrder(Field: string);
    function SplitStringAt(Substr: string): integer;
  end;

const
  FROM = 'FROM';
  WHERE = 'WHERE';
  GROUPBY = 'GROUP BY';
  ORDERBY = 'ORDER BY';
  MACROCHAR = '&';

  SQLDateTimeFormat = 'yyyy/mm/dd';

implementation

constructor TSQLStringList.Create;
begin
  inherited Create;
  FFromIndex := -1;
  FWhereIndex := -1;
  FOrderByIndex := -1;
  FGroupByIndex := -1;
  FExpressionIndex := -1;
end;

destructor TSQLStringList.Destroy;
begin
  inherited Destroy;
end;

function TSQLStringList.SplitStringAt(Substr: string): integer;
var
  iIndex: integer;
  iPos: integer;
  sLinha: string;
  sInicio: string;
  sFim: string;
begin
  result := -1;
  iIndex := IndexOfSubstr(Substr);
  if iIndex <> -1 then
  begin
    sLinha := Strings[iIndex];
    iPos := Pos(Substr, sLinha);
    if iPos > 1 then
    begin
      sInicio := Copy(sLinha, 1, iPos-1);   // Extrai o inicio da linha até a substring
      sFim := Copy(sLinha, iPos, Length(sLinha)-iPos+1); // Extrai o final
      Strings[iIndex] := sInicio;
      Inc(iIndex);
      Insert(iIndex, sFim);
    end;
    result := iIndex;
  end;
end;

// Separa as strings where, group by e order by
procedure TSQLStringList.SplitClauses;
begin
  FFromIndex := SplitStringAt(FROM);
  FWhereIndex := SplitStringAt(WHERE);
  FGroupByIndex := SplitStringAt(GROUPBY);
  FOrderByIndex := SplitStringAt(ORDERBY);
end;

procedure TSQLStringList.RefreshPositionIndexes;
begin
  FFromIndex := IndexOfSubstr(FROM);
  FWhereIndex := IndexOfSubstr(WHERE);
  FGroupByIndex := IndexOfSubstr(GROUPBY);
  FOrderByIndex := IndexOfSubstr(ORDERBY);
  // Determina o ponto de inserção das expressoes
  FExpressionIndex := FGroupByIndex;
  if FExpressionIndex = -1 then  // Sem GROUP BY
    FExpressionIndex := FOrderByIndex;
  // Determina o ponto de inserção dos fields
  FFieldIndex := FFromIndex;
end;

procedure TSQLStringList.InsertExpression(Expression: string);
var
  sConnect: string;
begin
  if FWhereIndex = -1 then  // Sem cláusula WHERE
    sConnect := 'WHERE '
  else
    sConnect := 'AND ';
  if FExpressionIndex = -1 then
    Add(sConnect + Expression) // Adiciona ao final
  else
    Insert(FExpressionIndex, sConnect + Expression);
  RefreshPositionIndexes;
end;

procedure TSQLStringList.InsertOrder(Field: string);
var
  sConnect: string;
begin
  if Trim(Field) <> '' then
  begin
    if FOrderByIndex = -1 then  // Sem cláusula ORDER BY
      sConnect := 'ORDER BY '
    else
      sConnect := ', ';

    Add(sConnect + Field); // Adiciona ao final
    RefreshPositionIndexes;
  end;
end;

procedure TSQLStringList.InsertWhere(Expression: string);
begin
  if Trim(Expression) <> '' then
    InsertExpression(Expression);
end;

procedure TSQLStringList.InsertWhereInt(Field: string; Value: string);
begin
  if Trim(Value) <> '' then
    InsertExpression(Field + '=' + Value);
end;

procedure TSQLStringList.InsertWhereStr(Field: string; Value: string);
begin
  if Trim(Value) <> '' then
    InsertExpression(Field + '= ''' + Value + '''');
end;

procedure TSQLStringList.InsertWhereStrLike(Field: string; Value: string);
begin
  if Trim(Value) <> '' then
    InsertExpression(Field + ' LIKE ''' + Value + '%''');
end;

procedure TSQLStringList.InsertWhereStrBetween(Field: string; FirstValue: string; LastValue: string);
begin
  if Trim(FirstValue) <> '' then
    InsertExpression(Field + ' >= ''' + FirstValue + '''');
  if Trim(LastValue) <> '' then
    InsertExpression(Field + ' <= ''' + LastValue + '''');
end;

procedure TSQLStringList.InsertWhereDateBetween(Field: string; FirstValue: string; LastValue: string);
begin
  if Trim(Copy(FirstValue,1, 2)) <> '' then
    InsertExpression(Field + ' >= ''' + FormatDateTime(SQLDatetimeFormat, StrToDateTime(FirstValue)) + '''');
  if Trim(Copy(LastValue,1, 2)) <> '' then
    InsertExpression(Field + ' <= ''' + FormatDateTime(SQLDatetimeFormat, StrToDateTime(LastValue)) + '''');
end;

procedure TSQLStringList.InsertWhereDateBetween(Field: string; FirstValue: TDateTime; LastValue: TDateTime);
begin
  if FirstValue <> 0 then
    InsertExpression(Field + ' >= ''' + FormatDateTime(SQLDatetimeFormat, FirstValue) + '''');
  if LastValue <> 0 then
    InsertExpression(Field + ' <= ''' + FormatDateTime(SQLDatetimeFormat, LastValue) + '''');
end;

procedure TSQLStringList.InsertWhereStrOp(Field: string; Operator: string; Value: string);
begin
  if Trim(Value) <> '' then
    InsertExpression(Field + ' ' + Operator + ' ''' + Value + '''');
end;

procedure TSQLStringList.InsertWhereIntOp(Field: string; Operator: string; Value: string);
begin
  if Trim(Value) <> '' then
    InsertExpression(Field + ' ' + Operator + ' ' + Value);
end;

procedure TSQLStringList.InsertOrderBy(Field: string);
begin
  InsertOrder(Field);
end;

procedure TSQLStringList.InsertField(Field: string);
var
  sConnect: string;
begin
  // ToDo: Verificar se existe algum campo para colocar a virgula ou não
  //       Até fazer isto fica uma restrição:
  //       A query Base deve ter pelo menos um campo
  sConnect := ', ';
  if FFieldIndex = -1 then
    Add(sConnect + Field) // Adiciona ao final
  else
    Insert(FFieldIndex, sConnect + Field);
  RefreshPositionIndexes;
end;


{ TExtStringList }

constructor TExtStringList.Create;
begin
  inherited;
  FSeparator := '';
  FElementFormat := '';
end;

function TExtStringList.GetAsFmtText: string;
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

function TExtStringList.IndexOfSubstr(Substr: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i:=0 to Count -1 do
    if Pos(Substr, Strings[i]) <> 0 then
    begin
      Result := i;
      break;
    end;
end;

procedure TExtStringList.PrepareForID;
begin
  FSeparator := ',';
  FElementFormat := '''%s''';
end;

procedure TExtStringList.SetElementFormat(const Value: string);
begin
  FElementFormat := Value;
end;

procedure TExtStringList.SetMacro(Macro, Value: string);
var
  iIndex: integer;
  iPos: integer;
  iMacroLen: integer;
  sLinha: string;
  sInicio: string;
  sFim: string;
begin
  Macro := MACROCHAR + Macro;
  iMacroLen := Length(Macro);
  iIndex := IndexOfSubstr(Macro);
  if iIndex <> -1 then
  begin
    sLinha := Strings[iIndex];
    sInicio := '';
    iPos := Pos(Macro, sLinha);
    if iPos > 1 then
    begin
      sInicio := Copy(sLinha, 1, iPos-1);   // Extrai o inicio da linha até a substring
      sFim := Copy(sLinha, iPos + iMacroLen, Length(sLinha)- iPos + iMacroLen + 1); // Extrai o final
      Strings[iIndex] := sInicio;
    end;
    Strings[iIndex] := sInicio + Value + sFim;
  end;
end;

procedure TExtStringList.SetSeparator(const Value: string);
begin
  FSeparator := Value;
end;


procedure TSQLStringList.Assign(Source: TPersistent);
begin
  inherited;
  RefreshPositionIndexes;
end;

end.


