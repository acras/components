unit osFilterInspectorFrame;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, wwDataInspector;

type
  TFilterInspectorFrame = class(TFrame)
    DataInspector: TwwDataInspector;
    PesquisarButton: TButton;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
