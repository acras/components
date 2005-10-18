unit osActionList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList;

type
  TosActionList = class(TActionList)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    function GetActionByName(const PName: string): TAction;
    procedure EnableActions(const PCategory: string; const PState: boolean);
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OS Controls', [TosActionList]);
end;

{ TosActionList }

procedure TosActionList.EnableActions(const PCategory: string;
  const PState: boolean);
var
  i: integer;
begin
  for i:=0 to ActionCount - 1 do
    if Actions[i].Category = PCategory then
      TAction(Actions[i]).Enabled := PState;
end;

function TosActionList.GetActionByName(const PName: string): TAction;
var
  i: integer;
begin
  Result := nil;
  for i:=0 to ActionCount - 1 do
    if Actions[i].Name = PName then
    begin
      Result := TAction(Actions[i]);
      break;
    end;
end;

end.
