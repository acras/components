unit RadioComboPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, StdCtrls, graphics;

type
  TCheckEvent = procedure(Sender: TObject; Value: Boolean) of Object;

  TRadioComboPanel = class(tpanel)
  private
    FCaption: TCaption;
    procedure SetCaption(const Value: TCaption);
  private
    radioButton: TRadioButton;
    pnlTop: TPanel;
    FRadioCaption: TCaption;
    FChecked: boolean;
    FOpenedHeight: integer;
    FClosedHeight: integer;
    FonChangeCheck: TCheckEvent;
    property Caption: TCaption read FCaption write SetCaption;
    procedure SetRadioCaption(const Value: TCaption);
    procedure SetChecked(const Value: boolean);
    procedure RadioButtonClick(Sender: TObject);
    procedure SetClosedHeight(const Value: integer);
    procedure SetOpenedHeight(const Value: integer);
    procedure PanelTopResize(Sender: TObject);
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
  public
    constructor create (AOwner: TComponent); override;
    procedure CreateWnd; override;
    procedure Resize; override;
  published
    property RadioCaption: TCaption read FRadioCaption write SetRadioCaption;
    property Checked: boolean read FChecked write SetChecked stored true;
    property OpenedHeight: integer read FOpenedHeight write SetOpenedHeight;
    property ClosedHeight: integer read FClosedHeight write SetClosedHeight;
    property onChangeCheck: TCheckEvent read FonChangeCheck write FonChangeCheck;
  end;

procedure Register;

implementation

uses
  Dialogs;

procedure Register;
begin
  RegisterComponents('OS Controls', [TRadioComboPanel]);
end;

{ TRadioComboPanel }

procedure TRadioComboPanel.AdjustClientRect(var Rect: TRect);
begin
  inherited AdjustClientRect(Rect);
  if pnlTop <> nil then
    pnlTop.Height := ClosedHeight-2;
end;

constructor TRadioComboPanel.create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TRadioComboPanel.CreateWnd;
begin
  inherited CreateWnd;
  pnlTop := TPanel.Create(self);
  pnlTop.Parent := self;
  pnlTop.Align := alTop;
  pnlTop.BevelInner := bvNone;
  pnlTop.BevelOuter := bvNone;
  pnlTop.OnResize := PanelTopResize;

  radioButton := TRadioButton.Create(self);
  radioButton.Parent := pnlTop;
  radioButton.OnClick := RadioButtonClick;

  if ClosedHeight<1 then ClosedHeight := 17;
  if OpenedHeight<1 then OpenedHeight := 41;
  Height := ClosedHeight;
  pnlTop.Height := ClosedHeight-2;

  if Checked then
  begin
    radioButton.Checked := Checked;
  end;

  Caption := '';
  Align := alTop;
end;

procedure TRadioComboPanel.SetChecked(const Value: boolean);
var
  p: TComponent;
  i: integer;
begin
  FChecked := Value;
  if radioButton=nil then
    exit;
  //setar o checked dos outros componentes para false
  //caso este componente esteja checkado
  if Value then
  begin
    p := Owner;
    for i := 0 to p.ComponentCount-1 do
    begin
      if (p.components[i] is TRadioComboPanel) then
        if p.Components[i] <> self then
          (p.components[i] as TRadioComboPanel).Checked := false;
    end;
  end;
  //setar as propriedades deste componente
  if not value then
    Height := ClosedHeight
  else
    height := OpenedHeight;

  radioButton.Checked := Value;

  if Assigned(FonChangeCheck) then
    FonChangeCheck(Self, Value);
end;

procedure TRadioComboPanel.SetRadioCaption(const Value: TCaption);
begin
  FRadioCaption := Value;
  radioButton.Caption := Value;
end;

procedure TRadioComboPanel.RadioButtonClick(Sender: TObject);
begin
  (Sender as TRadioButton).Checked := True;
  Checked := true;
end;

procedure TRadioComboPanel.SetClosedHeight(const Value: integer);
begin
  FClosedHeight := Value;
end;

procedure TRadioComboPanel.SetOpenedHeight(const Value: integer);
begin
  FOpenedHeight := Value;
end;

procedure TRadioComboPanel.PanelTopResize(Sender: TObject);
begin
  if radioButton=nil then
    exit;
  radioButton.Top := (pnlTop.height div 2) - (radioButton.Height div 2) + 1;
  radioButton.Width := Width - 5;
  radioButton.Left := 5;
  radioButton.Caption := RadioCaption;
end;


procedure TRadioComboPanel.SetCaption(const Value: TCaption);
begin
  FCaption := Value;
end;


procedure TRadioComboPanel.Resize;
begin
  inherited Resize;
{  if Checked then
  begin
    if Height=ClosedHeight then
      Height := OpenedHeight;
    OpenedHeight := Height;
  end
  else
  begin
    OpenedHeight := OpenedHeight + Height - ClosedHeight;
    ClosedHeight := height;
  end; }
end;

end.
