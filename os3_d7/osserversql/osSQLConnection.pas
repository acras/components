unit osSQLConnection;

interface

uses
  Windows, Messages, SysUtils, Classes, DB, SqlExpr;

type
  TosSQLConnection = class(TSQLConnection)
  published
    property Connected Stored False;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OS Server', [TosSQLConnection]);
end;

end.
