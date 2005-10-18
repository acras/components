unit osUtils;

interface

uses
  sysutils, classes, dbtables, typinfo, contnrs, forms, db;

type
  // Restrições a usuario
  TRestricaoUsuario = class
    IdRestricao: integer;
    Id: variant;
    Texto: String;
  end;


  // Registro
  TosClassRef = class(TObject)
  private
    FClassRef: TPersistentClass;
  public
    constructor Create(PClass: TPersistentClass);
    property ClassRef: TPersistentClass read FClassRef;
  end;

  TosClassReg = class(TStringList)
  private
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddClass(PClass: TPersistentClass);
    function GetClass(const PClassName: string): TPersistentClass;
  end;

  var OSClassReg: TosClassReg;
  procedure OSRegisterClass(PClass: TPersistentClass);
  function OSGetClass(const PClassName: string): TPersistentClass;

  // String
  function GetWord(const PStr: string; PIndex: integer; PSeparator: char): string;
  procedure ReplaceConstraintChars(var PStr: string);


  // Parâmetros
  function ExtractParam(const PName: string): string;

  {** Checa se as globais de empresa e estabelecimento estão setadas
      e caso não estejam seta seus valores.}
  procedure CheckDefaultParams;

  // String to Component
  function GetDatamoduleByName(const PName: string): TDatamodule;
  function GetFormByName(const PName: string): TForm;
  function GetComponentByName(POwner: TComponent; const PName: string; PClass: TClass ): TComponent;

  function IsFieldEmpty(PField: TField): boolean; overload;
  function IsFieldEmpty(PDataset: TDataset; const PFieldName: string): boolean; overload;

  function getRestricaoUsuario(PId: integer): TRestricaoUsuario;

  // Globais
  var GlobalEmpresa, GlobalEstabelecimento: string;
  var GlobalExtractParams: boolean = True;
  var GlobalListaRestricoesUsuario: TList = nil;

implementation

function GetWord(const PStr: string; PIndex: integer; PSeparator: char): string;
var
  iNumWord, i, iLen, iIni: integer;
begin
  iLen := Length(PStr);
  iNumWord := 1;
  iIni := 1;
  for i:=1 to iLen do
    if (PStr[i] = PSeparator) then
      if iNumWord = PIndex then
        break
      else
      begin
        iIni := i + 1;
        Inc(iNumWord);
      end;

  if iNumWord = PIndex then
    Result := Trim(Copy(PStr, iIni, i - iIni))
  else
    Result := '';
end;

procedure ReplaceConstraintChars(var PStr: string);
var
  i, iLen: integer;
begin
  iLen := Length(PStr);
  for i:=1 to iLen do
    if PStr[i] = '*' then
      PStr[i] := '%';
end;

// Extração de parâmetros
function ExtractParam(const PName: string): string;
var
  i, iPos: Integer;
  sAux: string;
begin
  Result := '';
  for i:=1 to ParamCount do
  begin
    sAux := ParamStr(i);
    iPos := Pos('=', sAux);
    if (iPos <> 0) and (CompareText(Copy(sAux, 1, iPos-1), PName) = 0) then
    begin
      Result := StringReplace(Copy(sAux, iPos + 1, Length(sAux) - iPos),'_', ' ', [rfReplaceAll]);
      break;
    end;
  end;
end;

procedure CheckDefaultParams;
begin
  if GlobalExtractParams then
  begin
    GlobalEmpresa := ExtractParam('empresa');
    GlobalEstabelecimento := ExtractParam('estab');
    if GlobalEmpresa = '' then
      GlobalEmpresa := '1';
    if GlobalEstabelecimento = '' then
      GlobalEstabelecimento := '1';
    GlobalExtractParams := False;
  end;
end;

function GetDatamoduleByName(const PName: string): TDatamodule;
var
  i: integer;
begin
  Result := nil;
  for i:=0 to Application.Componentcount - 1 do
  begin
    if (Application.Components[i] is TDatamodule) and
       (Application.Components[i].Name = PName) then
    begin
      Result := TDatamodule(Application.Components[i]);
      break;
    end;
  end;
end;

function GetFormByName(const PName: string): TForm;
var
  i: integer;
begin
  Result := nil;
  for i:=0 to Application.Componentcount - 1 do
  begin
    if (Application.Components[i] is TForm) and
       (Application.Components[i].Name = PName) then
    begin
      Result := TForm(Application.Components[i]);
      break;
    end;
  end;
end;

function GetComponentByName(POwner: TComponent; const PName: string; PClass: TClass ): TComponent;
var
  i: integer;
begin
  Result := nil;
  if assigned(POwner) then
  begin
    for i:=0 to POwner.Componentcount - 1 do
    begin
      if (POwner.Components[i] is PClass) and
         (POwner.Components[i].Name = PName) then
      begin
        Result := POwner.Components[i];
        break;
      end;
    end;
  end;
end;

function IsFieldEmpty(PField: TField): boolean;
begin
  Result := ((PField.IsNull) or (Trim(PField.AsString) = ''));
end;

function IsFieldEmpty(PDataset: TDataset; const PFieldName: string): boolean;
begin
  Result := IsFieldEmpty(PDataset.FieldByName(PFieldName));
end;

{ TosClassReg }

procedure TosClassReg.AddClass(PClass: TPersistentClass);
begin
  AddObject(PClass.ClassName, TOsClassRef.Create(PClass));
end;

constructor TosClassReg.Create;
begin
  inherited;
  Sorted := True;
end;

destructor TosClassReg.Destroy;
var
  i: integer;
begin
  for i:=0 to Count - 1 do
    Objects[i].Free;
  inherited;
end;

function TosClassReg.GetClass(const PClassName: string): TPersistentClass;
var
  i: integer;
begin
  i := IndexOf(PClassName);
  if i <> -1 then
    Result := TosClassRef(Objects[i]).ClassRef
  else
    Result := nil;
end;

procedure OSRegisterClass(PClass: TPersistentClass);
begin
  OSClassReg.AddClass(PClass);
end;

function OSGetClass(const PClassName: string): TPersistentClass;
begin
  Result := OSClassReg.GetClass(PClassName);
end;

{ TosClassRef }

constructor TosClassRef.Create(PClass: TPersistentClass);
begin
  FClassRef := PClass;
end;

function getRestricaoUsuario(PId: integer): TRestricaoUsuario;
var
  i: integer;
begin
  result := nil;
  if GlobalListaRestricoesUsuario=nil then
    exit;
  for i := 0 to GlobalListaRestricoesUsuario.Count-1 do
  begin
    if TRestricaoUsuario(GlobalListaRestricoesUsuario.Items[i]).IdRestricao = PId then
      result := GlobalListaRestricoesUsuario.Items[i];
  end;
end;

initialization
  OSClassReg := TosClassReg.Create;

finalization
  OSClassReg.Free;

end.


