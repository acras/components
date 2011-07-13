unit acReportContainer;

interface

uses
  SysUtils, Classes;

type
  TReportInfo = class
    id: Integer;
    name: string;
    template: string;
  end;

  TacReportContainer = class(TComponent)
  private
    reports: TList;
  public
    constructor Create(owner: TComponent); override;
    destructor Destroy; override;
    procedure addReport(id:Integer; name: string; template: string);
    function findReportById(id: Integer): string;
    function findReportByName(name: string): string;
    function findRportIdByName(name: string):Integer;
    procedure removeAll();
  published
    { Published declarations }
  end;

procedure Register;

implementation

constructor TacReportContainer.Create(owner: TComponent);
begin
  inherited create(owner);
  reports := TList.Create;
end;

destructor TacReportContainer.Destroy;
begin
  inherited;
  FreeAndNil(reports);
end;

procedure TacReportContainer.addReport(id: Integer; name: string; template: string);
var
  report: TReportInfo;
begin
  report := TReportInfo.Create;
  report.id := id;
  report.name := name;
  report.template := template;
  reports.Add(report);
end;

function TacReportContainer.findReportById(id: Integer): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to reports.Count-1 do
  begin
    if TReportInfo(reports.Items[i]).id = id then
      Result := TReportInfo(reports.Items[i]).template;
  end;
end;

function TacReportContainer.findReportByName(name: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to reports.Count-1 do
  begin
    if UpperCase(TReportInfo(reports.Items[i]).name) = UpperCase(name) then
      Result := TReportInfo(reports.Items[i]).template;
  end;
end;

function TacReportContainer.findRportIdByName(name: string): Integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to reports.Count-1 do
  begin
    if UpperCase(TReportInfo(reports.Items[i]).name) = UpperCase(name) then
      Result := TReportInfo(reports.Items[i]).id;
  end;
end;

procedure TacReportContainer.removeAll;
begin
  reports.Clear;
end;

procedure Register;
begin
  RegisterComponents('Acras', [TacReportContainer]);
end;

end.
