unit osSQLDataSet;

interface

uses
  Windows, Messages, SysUtils, Classes, DB, SqlExpr;

type
  TosSQLDataSet = class(TSQLDataSet)
  published
    property Active Stored False;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OS Server', [TosSQLDataSet]);
end;

end.
