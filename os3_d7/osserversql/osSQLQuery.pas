unit osSQLQuery;

interface

uses
  Windows, Messages, SysUtils, Classes, DB, SqlExpr;

type
  TosSQLQuery = class(TSQLQuery)
  published
    property Active Stored False;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OS Server', [TosSQLQuery]);
end;

end.
