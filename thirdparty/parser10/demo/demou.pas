unit Demou;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Parser10;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    IterationEdit: TEdit;
    Button1: TButton;
    Button2: TButton;
    CountLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Parser1: TParser;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure IterationEditKeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    DynaParser: TParser;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  { use an instance of TParser on the form if it exists }
  DynaParser := FindComponent('Parser1') as TParser;

  if DynaParser = nil then
    DynaParser := TParser.Create(Self);
end;

procedure TForm1.IterationEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9',#8]) then
    Key := #0;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #32 then
  begin
    Key := #0;
    ShowMessage('The parser cannot handle expressions containing blanks.');
  end;
end;

{$IFDEF Win32}
  {$HINTS OFF}
{$ENDIF}
procedure TForm1.Button1Click(Sender: TObject);
var
  StartTime,
  counter: longint;

  dummy : extended;
begin
  DynaParser.Expression := Edit1.Text;

  StartTime := GetTickCount;

  { this does the calculation }
  for counter := 1 to StrToInt(IterationEdit.Text) do
  begin
    dummy := DynaParser.Value; { ignore the compiler hint }
  end;

  StartTime := GetTickCount - StartTime;

  ShowMessage(Format('Result: %g', [DynaParser.Value]));

  ShowMessage( Format('Did that seem slow?'#13+
               'Well, this expression was evaluated '+IterationEdit.Text+' times in just %d milliseconds!'#13+
               '  (see the little edit box below the button)', [StartTime]));
end;
{$IFDEF Win32}
  {$HINTS ON}
{$ENDIF}

procedure TForm1.Button2Click(Sender: TObject);
var
  StartTime1,
  StartTime2,
  i : longint;

  pf: PParserFloat;
begin
  { This is the slowest way...}
  ShowMessage('This is the slowest way to set variables...');

  Screen.Cursor := crHourGlass;
  try
    DynaParser.Variable['Counter1'] := StrToFloat(CountLabel.Caption);
    DynaParser.Expression := 'Counter1+1';

    StartTime1 := GetTickCount;
    for i := 1 to 10000 do
    begin
      DynaParser.Variable['Counter1'] := DynaParser.Value; { calculate and assign to "Counter" }

  (*  CountLabel.Caption := FloatToStr( DynaParser.Variable['Counter1'] );
      Application.ProcessMessages;    *)
    end;
    CountLabel.Caption := FloatToStr( DynaParser.Variable['Counter1'] );
    StartTime1 := GetTickCount - StartTime1;
  finally
    Screen.Cursor := crDefault;
  end;

  ShowMessage(Format('Time: %d ms', [StartTime1]));





  { This is the FAST way...}
  ShowMessage('This is the FAST way to do it...');
  Screen.Cursor := crHourGlass;
  try
    { we remember where the component actually stored the variable and
      access the memory directly }
    pf := DynaParser.SetVariable('Counter2', StrToFloat(CountLabel.Caption));
    { BTW, this is yet another way to change variables;
      if the variable already exists only the pointer to existing memory
      is returned }

    DynaParser.Expression := 'Counter2+1';

    StartTime2 := GetTickCount;
    for i := 1 to 10000 do
    begin
      pf^ := DynaParser.Value; { calculate and assign to "Counter" }

  (*  CountLabel.Caption := FloatToStr( DynaParser.Variable['Counter2'] );
      Application.ProcessMessages; *)
    end;

    CountLabel.Caption := FloatToStr( DynaParser.Variable['Counter2'] );
    StartTime2 := GetTickCount - StartTime2;
  finally
    Screen.Cursor := crDefault;
  end;

  ShowMessage(Format('Time: %d ms'#13#13'Just %d times faster...', [StartTime2, Trunc(StartTime1/StartTime2)]));
end;

end.
