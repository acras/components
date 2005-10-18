unit acCollapsePanel;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls,


       Windows,
     Messages,
     Graphics,
     Buttons,
     Forms,
     CommCtrl,
     stdctrls;

type
  TCollapsePanel = class(TPanel)
  private
    Fcollapsed: boolean;
    FcollapsedTitle: TCaption;
    FexpandedHeight: integer;
    FexpandedTitle: TCaption;
    FonCollapse: TNotifyEvent;
    FOnExpand: TNotifyEvent;
    procedure Setcollapsed(const Value: boolean);
    procedure SetcollapsedTitle(const Value: TCaption);
    procedure SetexpandedHeight(const Value: integer);
    procedure SetexpandedTitle(const Value: TCaption);
    procedure SetonCollapse(const Value: TNotifyEvent);
    procedure SetOnExpand(const Value: TNotifyEvent);
    { Private declarations }
  protected
    Procedure Paint; Override;
    procedure Resize; override;
  public
    { Public declarations }
    procedure CreateWnd; override;
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  published
    { Published declarations }
    property collapsed: boolean read Fcollapsed write Setcollapsed;
    property collapsedTitle: TCaption read FcollapsedTitle write SetcollapsedTitle;
    property expandedTitle: TCaption read FexpandedTitle write SetexpandedTitle;
    property expandedHeight: integer read FexpandedHeight write SetexpandedHeight;
    property OnCollapse: TNotifyEvent read FonCollapse write SetonCollapse;
    property OnExpand: TNotifyEvent read FOnExpand write SetOnExpand;
  end;

procedure Register;

implementation

uses
  Dialogs;

procedure Register;
begin
  RegisterComponents('Acras', [TCollapsePanel]);
end;

{ TCollapsePanel }

procedure TCollapsePanel.Paint;
begin
  inherited;
  Canvas.Rectangle(1,1,12,12);
  Canvas.Rectangle(2,2,11,11);
  if collapsed then
  begin
    Canvas.TextOut(3,-1,'+');
    canvas.Font.Style := [fsBold];
    Canvas.TextOut(15, -1, FcollapsedTitle);
  end
  else
  begin
    Canvas.TextOut(4,-1,'-');
    canvas.Font.Style := [fsBold];
    Canvas.TextOut(15, -1, FexpandedTitle);
  end;
end;

procedure TCollapsePanel.Setcollapsed(const Value: boolean);
begin
  if Fcollapsed<>Value then
  begin
    if value then
    begin
      if Assigned(FonCollapse) then
        FonCollapse(self);
    end
    else
    begin
      if Assigned(FonExpand) then
        FOnExpand(self);
    end;
  end;
  Fcollapsed := Value;
  if Fcollapsed then
    Height := 15
  else
    if FexpandedHeight<15 then
      Height := 15
    else
      Height := FexpandedHeight;
  Repaint;
end;

procedure TCollapsePanel.SetcollapsedTitle(const Value: TCaption);
begin
  FcollapsedTitle := Value;
end;

procedure TCollapsePanel.SetexpandedHeight(const Value: integer);
begin
  FexpandedHeight := Value;
end;

procedure TCollapsePanel.CreateWnd;
begin
  inherited CreateWnd;
  OnMouseDown := MouseDown;
end;

procedure TCollapsePanel.MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (x<15) and (y<15) then
    collapsed := not collapsed;
end;



procedure TCollapsePanel.SetexpandedTitle(const Value: TCaption);
begin
  FexpandedTitle := Value;
end;

procedure TCollapsePanel.Resize;
begin
  inherited Resize;
  if csDesigning in Self.ComponentState then
  begin
    if collapsed then
      height := 15
    else
    begin
      if Height < 15 then
        expandedHeight := 15
      else
        expandedHeight := height;
    end;
  end;
end;


procedure TCollapsePanel.SetonCollapse(const Value: TNotifyEvent);
begin
  FonCollapse := Value;
end;

procedure TCollapsePanel.SetOnExpand(const Value: TNotifyEvent);
begin
  FOnExpand := Value;
end;

end.
