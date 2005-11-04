unit osDBDateTimePicker;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, wwdbdatetimepicker, wwDataInspector;

type
  TosDBDateTimePicker = class(TwwDBDateTimePicker)
  private
    FRefObject: TObject;
    procedure SetRefObject(const Value: TObject);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    property RefObject: TObject read FRefObject write SetRefObject;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OS Controls', [TosDBDateTimePicker]);
end;

{ TosDBDateTimePicker }

procedure TosDBDateTimePicker.SetRefObject(
  const Value: TObject);
begin
  FRefObject := Value;
end;

end.
