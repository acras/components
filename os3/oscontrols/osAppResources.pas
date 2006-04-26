unit osAppResources;

interface

uses
  Classes, SysUtils, Forms, osUtils;

type

  TResourceType = (rtEdit, rtQuery, rtReport, rtOther);

  { TosAppResource }

  TosAppResource = class(TCollectionItem)
  private
    FDescription: string;
    FFilterDefName: string;
    FName: string;
    FResClass: TPersistentClass;
    FResType: TResourceType;
    FImageIndex: integer;
    FDomainName: string;
    FResClassName: string;
    FDataClassName: string;
    FDataClass: TPersistentClass;
    FReportClassName: string;
    FReportClass: TPersistentClass;
    FViews: variant;
    procedure SetImageIndex(const Value: integer);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(AOwner: TCollection); override;
    property ResClass: TPersistentClass read FResClass write FResClass;
    property DataClass: TPersistentClass read FDataClass write FDataClass;
    property ReportClass: TPersistentClass read FReportClass write FReportClass;
  published
    property Name: string read FName write FName;
    property Description: string read FDescription write FDescription;
    property FilterDefName: string read FFilterDefName write FFilterDefName;
    property ResClassName: string read FResClassName write FResClassName;
    property DataClassName: string read FDataClassName write FDataClassName;
    property ReportClassName: string read FReportClassName write FReportClassName;
    property DomainName: string read FDomainName write FDomainName;
    property ImageIndex: integer read FImageIndex write SetImageIndex;
    property ResType: TResourceType read FResType write FResType;
    property views: variant read FViews;
  end;

  { TosAppResourceCollection }

  TosAppResourceCollection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TosAppResource;
    procedure SetItem(Index: Integer; Value: TosAppResource);
  public
    constructor Create(AOwner: TComponent);
    property Items[Index: Integer]: TosAppResource read GetItem write SetItem; default;
  end;

  { TosAppResourceManager }

  TosAppResourceManager = class(TComponent)
  private
    FCurrentResource: TosAppResource;
    FResources: TosAppResourceCollection;
    procedure SetResources(const Value: TosAppResourceCollection);
  public
    ///////////////////////// alterado por romulo aurélio ceccon
    // esta procedure foi necessária porque a propriedade ResClass só é
    // alterada durante a procedure Loaded. Como o Manager é criado em runtime
    // eu preciso de um modo de recarregar a esta propriedade
    procedure Reload;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;
    procedure AddResource(const PName, PDescription, PFilterDefName, PResClassName,
      PDataClassName, PReportClassName, PDomainName: string; PImageIndex: integer;
      PResType: integer; PViews: variant);
    property CurrentResource: TosAppResource read FCurrentResource write FCurrentResource;
  published
    property Resources: TosAppResourceCollection read FResources write SetResources;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OS Controls', [TosAppResourceManager]);
end;

{ TosAppResource }

constructor TosAppResource.Create(AOwner: TCollection);
begin
  inherited Create(AOwner);
  FResType := rtEdit;
end;

function TosAppResource.GetDisplayName: string;
begin
  Result := FName;
end;

procedure TosAppResource.SetImageIndex(const Value: integer);
begin
  FImageIndex := Value;
end;

{ TosAppResourceCollection }

constructor TosAppResourceCollection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner, TosAppResource);
end;

function TosAppResourceCollection.GetItem(Index: Integer): TosAppResource;
begin
  Result := TosAppResource(inherited GetItem(Index));
end;

procedure TosAppResourceCollection.SetItem(Index: Integer;
  Value: TosAppResource);
begin
  inherited SetItem(Index, Value);
end;

{ TosAppResourceManager }

procedure TosAppResourceManager.AddResource(const PName, PDescription,
  PFilterDefName, PResClassName, PDataClassName, PReportClassName,
  PDomainName: string; PImageIndex, PResType: integer; PViews: variant);
begin
  with TosAppResource(FResources.Add) do
  begin
    Name             := PName;
    Description      := PDescription;
    FilterDefName    := PFilterDefName;
    ResClassName     := PResClassName;
    DataClassName    := PDataClassName;
    ReportClassName  := PReportClassName;
    DomainName       := PDomainName;
    ImageIndex       := PImageIndex;
    if PResType > 2 then
      ResType          := rtOther
    else
      ResType          := TResourceType(PResType);
    FViews := PViews;
  end;
end;

constructor TosAppResourceManager.Create(AOwner: TComponent);
begin
  inherited;
  FResources := TosAppResourceCollection.Create(Self);
end;

destructor TosAppResourceManager.Destroy;
begin
  FResources.Free;
  inherited;
end;

procedure TosAppResourceManager.Loaded;
var
  i: integer;
begin
  inherited;
  if not (csDesigning in ComponentState) then
    for i:=0 to Resources.Count - 1 do
      case Resources[i].ResType of
        rtEdit, rtReport, rtOther:
        begin
          Resources[i].ResClass := OSGetClass(Resources[i].ResClassName);
          Resources[i].DataClass := OSGetClass(Resources[i].DataClassName);
          Resources[i].ReportClass := OSGetClass(Resources[i].ReportClassName);
        end;
      end;


end;

procedure TosAppResourceManager.Reload;
var
  i: integer;
begin
  ///////////////////////// alterado por romulo aurélio ceccon
    for i := 0 to Resources.Count - 1 do
      case Resources[i].ResType of
        rtEdit, rtReport, rtOther:
        begin
          Resources[i].ResClass := OSGetClass(Resources[i].ResClassName);
          Resources[i].DataClass := OSGetClass(Resources[i].DataClassName);
          Resources[i].ReportClass := OSGetClass(Resources[i].ReportClassName);
        end;
      end;
end;

procedure TosAppResourceManager.SetResources(
  const Value: TosAppResourceCollection);
begin
  FResources.Assign(Value);
end;

end.
