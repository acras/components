unit acTrayIcon;


interface 


{ A component to make it easier to create a system tray icon. 
  Drop this component on a form, and the application automatically 
  becomes a tray icon. This means that when the application is 
  minimized, it does not minimize to a normal taskbar icon, but 
  to the little system tray on the side of the taskbar. A popup 
  menu is available from the system tray icon, and your application 
  can process mouse events as the user moves the mouse over 
  the system tray icon, clicks on the icon, etc. 


  Copyright © 1996 Tempest Software. All rights reserved. 
  You may use this software in an application without fee or royalty, 
  provided this copyright notice remains intact. 



} 


uses 
  Windows, Messages, ShellApi, SysUtils, Classes, Graphics, Controls, 
  Forms, Dialogs, Menus; 

{ This message is sent to the special, hidden window for shell 
  notification messages. Only derived classes might need to 
  know about it. } 
const 
  Wm_Callback_Message = Wm_User + 1; 


type 
  TacTrayIcon = class(TComponent) 
  private 
    fData: TNotifyIconData; 
    fIcon: TIcon; 
    fHint: string; 
    fPopupMenu: TPopupMenu; 
    fClicked: Boolean; 
    fOnClick: TNotifyEvent; 
    fOnDblClick: TNotifyEvent; 
    fOnMinimize: TNotifyEvent; 
    fOnMouseMove: TMouseMoveEvent; 
    fOnMouseDown: TMouseEvent; 
    fOnMouseUp: TMouseEvent; 
    fOnRestore: TNotifyEvent;
    fShowOnlyMinimized: boolean;
  protected 
    procedure SetHint(const Hint: string); virtual; 
    procedure SetIcon(Icon: TIcon); virtual; 
    procedure AppMinimize(Sender: TObject); 
    procedure AppRestore(Sender: TObject); 
    procedure DoMenu; virtual; 
    procedure Click; virtual; 
    procedure DblClick; virtual; 
    procedure EndSession; virtual; 
    procedure DoMouseMove(Shift: TShiftState; X, Y: Integer); virtual; 
    procedure DoMouseDown(Button: TMouseButton; Shift: TShiftState; X, 
Y: Integer); virtual; 
    procedure DoMouseUp(Button: TMouseButton; Shift: TShiftState; X, 
Y: Integer); virtual; 
    procedure OnMessage(var Msg: TMessage); virtual; 
    procedure Changed; virtual; 
    property Data: TNotifyIconData read fData; 
  public 
    constructor Create(Owner: TComponent); override; 
    destructor Destroy; override; 
    procedure Minimize; virtual; 
    procedure Restore; virtual;
    procedure hideIcon;
    procedure showIcon;
  published
    property ShowOnlyMinimized: boolean read fShowOnlyMinimized write fShowOnlyMinimized;
    property Hint: string read fHint write SetHint; 
    property Icon: TIcon read fIcon write SetIcon; 
    property PopupMenu: TPopupMenu read fPopupMenu write fPopupMenu; 
    property OnClick: TNotifyEvent read fOnClick write fOnClick; 
    property OnDblClick: TNotifyEvent read fOnDblClick write 
fOnDblClick; 
    property OnMinimize: TNotifyEvent read fOnMinimize write 
fOnMinimize; 
    property OnMouseMove: TMouseMoveEvent read fOnMouseMove write 
fOnMouseMove; 
    property OnMouseDown: TMouseEvent read fOnMouseDown write 
fOnMouseDown; 
    property OnMouseUp: TMouseEvent read fOnMouseUp write fOnMouseUp; 
    property OnRestore: TNotifyEvent read fOnRestore write fOnRestore; 
  end; 


procedure Register; 


implementation 


{ Create the component. At run-time, automatically add a tray icon 
  with a callback to a hidden window. Use the application icon and 
title. } 
constructor TacTrayIcon.Create(Owner: TComponent); 
begin 
  inherited Create(Owner); 
  fIcon := TIcon.Create; 
  fIcon.Assign(Application.Icon); 
  if not (csDesigning in ComponentState) then 
  begin 
    FillChar(fData, SizeOf(fData), 0); 
    fData.cbSize := SizeOf(fData); 
    fData.Wnd := AllocateHwnd(OnMessage); 
    fData.hIcon := Icon.Handle; 
    StrPLCopy(fData.szTip, Application.Title, SizeOf(fData.szTip)-1); 
    fData.uFlags := Nif_Icon or Nif_Message; 
    if Application.Title <> '' then 
      fData.uFlags := fData.uFlags or Nif_Tip; 
    fData.uCallbackMessage := Wm_Callback_Message;
//    if not Shell_NotifyIcon(Nim_Add, @fData) then
//      raise EOutOfResources.Create('Cannot create shell notificationicon');
    { Replace the application's minimize and restore handlers with 
      special ones for the tray. The TrayIcon component has its own 
      OnMinimize and OnRestore events that the user can set. } 
    Application.OnMinimize := AppMinimize; 
    Application.OnRestore := AppRestore; 
  end; 
end; 


{ Remove the icon from the system tray.} 
destructor TacTrayIcon.Destroy; 
begin 
  fIcon.Free; 
  if not (csDesigning in ComponentState) then 
    Shell_NotifyIcon(Nim_Delete, @fData); 
  inherited Destroy; 
end; 


{ Whenever any information changes, update the system tray. } 
procedure TacTrayIcon.Changed;
begin
  if not (csDesigning in ComponentState) then
    Shell_NotifyIcon(Nim_Modify, @fData);
end;


{ When the Application is minimized, minimize to the system tray.}
procedure TacTrayIcon.AppMinimize(Sender: TObject);
begin
  Minimize
end;


{ When restoring from the system tray, restore the application. }
procedure TacTrayIcon.AppRestore(Sender: TObject);
begin
  Restore
end;


{ Message handler for the hidden shell notification window.
  Most messages use Wm_Callback_Message as the Msg ID, with
  WParam as the ID of the shell notify icon data. LParam is
  a message ID for the actual message, e.g., Wm_MouseMove.
  Another important message is Wm_EndSession, telling the
  shell notify icon to delete itself, so Windows can shut down.


  Send the usual Delphi events for the mouse messages. Also
  interpolate the OnClick event when the user clicks the
  left button, and popup the menu, if there is one, for
  right click events. }


procedure TacTrayIcon.OnMessage(var Msg: TMessage);
  { Return the state of the shift keys. }
  function ShiftState: TShiftState;
  begin
    Result := [];
    if GetKeyState(Vk_Shift) < 0 then
      Include(Result, ssShift);
    if GetKeyState(Vk_Control) < 0 then
      Include(Result, ssCtrl);
    if GetKeyState(Vk_Menu) < 0 then
      Include(Result, ssAlt);
  end;


var
  Pt: TPoint;
  Shift: TShiftState;
begin
  case Msg.Msg of
  Wm_QueryEndSession:
    Msg.Result := 1; 
  Wm_EndSession: 
    if TWmEndSession(Msg).EndSession then 
      EndSession; 
  Wm_Callback_Message: 
    case Msg.lParam of 
    Wm_MouseMove: 
      begin 
        Shift := ShiftState; 
        GetCursorPos(Pt); 
        DoMouseMove(Shift, Pt.X, Pt.Y); 
      end; 
    Wm_LButtonDown: 
      begin 
        Shift := ShiftState + [ssLeft]; 
        GetCursorPos(Pt); 
        DoMouseDown(mbLeft, Shift, Pt.X, Pt.Y); 
        fClicked := True; 
      end; 
    Wm_LButtonUp: 
      begin 
        Shift := ShiftState + [ssLeft]; 
        GetCursorPos(Pt); 
        if fClicked then 
        begin 
          fClicked := False; 
          Click; 
        end; 
        DoMouseUp(mbLeft, Shift, Pt.X, Pt.Y); 
      end; 
    Wm_LButtonDblClk: 
      DblClick; 
    Wm_RButtonDown: 
      begin 
        Shift := ShiftState + [ssRight]; 
        GetCursorPos(Pt); 
        DoMouseDown(mbRight, Shift, Pt.X, Pt.Y); 
        DoMenu; 
      end; 
    Wm_RButtonUp: 
      begin 
        Shift := ShiftState + [ssRight]; 
        GetCursorPos(Pt); 
        DoMouseUp(mbRight, Shift, Pt.X, Pt.Y); 
      end; 
    Wm_RButtonDblClk: 
      DblClick; 
    Wm_MButtonDown: 
      begin 
        Shift := ShiftState + [ssMiddle]; 
        GetCursorPos(Pt); 
        DoMouseDown(mbMiddle, Shift, Pt.X, Pt.Y); 
      end; 
    Wm_MButtonUp: 
      begin 
        Shift := ShiftState + [ssMiddle]; 
        GetCursorPos(Pt); 
        DoMouseUp(mbMiddle, Shift, Pt.X, Pt.Y); 
      end; 
    Wm_MButtonDblClk: 
      DblClick; 
    end; 
  end; 
end; 


{ Set a new hint, which is the tool tip for the shell icon. } 
procedure TacTrayIcon.SetHint(const Hint: string); 
begin 
  if fHint <> Hint then 
  begin 
    fHint := Hint; 
    StrPLCopy(fData.szTip, Hint, SizeOf(fData.szTip)-1); 
    if Hint <> '' then 
      fData.uFlags := fData.uFlags or Nif_Tip 
    else 
      fData.uFlags := fData.uFlags and not Nif_Tip; 
    Changed; 
  end; 
end; 


{ Set a new icon. Update the system tray. } 
procedure TacTrayIcon.SetIcon(Icon: TIcon); 
begin 
  if fIcon <> Icon then 
  begin 
    fIcon.Assign(Icon); 
    fData.hIcon := Icon.Handle; 
    Changed; 
  end; 
end; 


{ When the user right clicks the icon, call DoMenu. 
  If there is a popup menu, and if the window is minimized, 
  then popup the menu. } 
procedure TacTrayIcon.DoMenu; 
var 
  Pt: TPoint; 
begin 
  if (fPopupMenu <> nil) and not IsWindowVisible(Application.Handle) 
then 
  begin 
    GetCursorPos(Pt); 
    fPopupMenu.Popup(Pt.X, Pt.Y); 
  end; 
end; 


procedure TacTrayIcon.Click; 
begin 
  if Assigned(fOnClick) then 
    fOnClick(Self); 
end; 


procedure TacTrayIcon.DblClick; 
begin 
  if Assigned(fOnDblClick) then 
    fOnDblClick(Self); 
end; 


procedure TacTrayIcon.DoMouseMove(Shift: TShiftState; X, Y: Integer); 
begin 
  if Assigned(fOnMouseMove) then 
    fOnMouseMove(Self, Shift, X, Y); 
end; 


procedure TacTrayIcon.DoMouseDown(Button: TMouseButton; Shift: 
TShiftState; X, Y: Integer); 
begin 
  if Assigned(fOnMouseDown) then 
    fOnMouseDown(Self, Button, Shift, X, Y); 
end; 


procedure TacTrayIcon.DoMouseUp(Button: TMouseButton; Shift: 
TShiftState; X, Y: Integer); 
begin 
  if Assigned(fOnMouseUp) then 
    fOnMouseUp(Self, Button, Shift, X, Y); 
end; 


{ When the application minimizes, hide it, so only the icon 
  in the system tray is visible. } 
procedure TacTrayIcon.Minimize;
begin
  ShowWindow(Application.Handle, Sw_Hide);
  if Assigned(fOnMinimize) then
    fOnMinimize(Self);
  if fShowOnlyMinimized then
    showIcon;
end;


{ Restore the application by making its window visible again,
  which is a little weird since its window is invisible, having
  no height or width, but that's what determines whether the button
  appears on the taskbar. }
procedure TacTrayIcon.Restore;
begin
  ShowWindow(Application.Handle, Sw_Restore);
  if Assigned(fOnRestore) then
    fOnRestore(Self);
  if fShowOnlyMinimized then
    hideIcon;
  SetForegroundWindow(Application.Handle);
end;


{ Allow Windows to exit by deleting the shell notify icon. }
procedure TacTrayIcon.EndSession;
begin
  Shell_NotifyIcon(Nim_Delete, @fData);
end;


procedure TacTrayIcon.hideIcon;
begin
  Shell_NotifyIcon(Nim_Delete, @fData);
end;

procedure TacTrayIcon.showIcon;
begin
  Shell_NotifyIcon(Nim_Add, @fData);
end;

procedure Register;
begin
  RegisterComponents('Acras', [TacTrayIcon]);
end;





end.

