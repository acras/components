program Demo;

uses
  Forms,
  Demou in 'DEMOU.PAS' {Form1};

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
