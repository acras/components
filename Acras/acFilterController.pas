unit acFilterController;

interface

uses
  SysUtils, Classes;

type
  TFilterInfo = class
    name: string;
    views: variant;
  end;

  TacFilterController = class(TComponent)
  private
    filters: TList;
  public
    constructor Create(owner: TComponent); override;
    destructor Destroy; override;
    procedure addFilter(name: string; views: variant);
    function findFilter(name: string): variant;
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure TacFilterController.addFilter(name: string; views: variant);
var
  filter: TFilterInfo;
begin
  filter := TFilterInfo.Create;
  filter.name := name;
  filter.views := views;
  filters.Add(filter);
end;

constructor TacFilterController.Create(owner: TComponent);
begin
  inherited create(owner);
  filters := TList.Create;
end;

destructor TacFilterController.Destroy;
begin
  inherited;
  FreeAndNil(filters);
end;

function TacFilterController.findFilter(name: string): variant;
var
  i: integer;
begin
  for i := 0 to filters.Count-1 do
  begin
    if UpperCase(TFilterInfo(filters.Items[i]).name)=
      UpperCase(name) then
      result := TFilterInfo(filters.Items[i]).views;
  end;
end;


procedure Register;
begin
  RegisterComponents('Acras', [TacFilterController]);
end;

end.
