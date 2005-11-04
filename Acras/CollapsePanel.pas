unit CollapsePanel;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls;

type
  TCollapsePanel = class(TPanel)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Acras', [TCollapsePanel]);
end;

end.
