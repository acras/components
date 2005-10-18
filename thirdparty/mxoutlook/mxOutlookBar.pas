// ****************************************************************************
// * An Outlook style sidebar component for Delphi.
// ****************************************************************************
// * Copyright 2001-2005, Bitvadász Kft. All Rights Reserved.
// ****************************************************************************
// * This component can be freely used and distributed in commercial and
// * private environments, provied this notice is not modified in any way.
// ****************************************************************************
// * Feel free to contact me if you have any questions, comments or suggestions
// * at support@maxcomponents.net
// ****************************************************************************
// * Description:
// *
// * The TmxOutlookBar 100% native VCL  component with many added features to
// * support the look, feel, and behavior introduced in Microsoft  Office 97,
// * 2000, and new Internet Explorer. It has got many features  including
// * scrolling headers, icon  highlighting and positioning, small and large
// * icons,gradient and bitmap Backgrounds. The header sections and buttons
// * can be  added, deleted and  moved  at design time. The  header tabs can
// * have individual  font,  alignment,  tabcolor,  glyph, tiled Background
// * images. And many many more posibilities.
// ****************************************************************************

Unit mxOutlookBar;

Interface

{$I max.inc}
{$R ARROWGLYPH.RES}

{DEFINE HEADERSCROLL}

// *************************************************************************************
// ** List of used units
// *************************************************************************************

Uses
     Windows,
     Messages,
     SysUtils,
     Classes,
     Graphics,
     Dialogs,
     Buttons,
     Controls,
     Forms,
     CommCtrl,
{$IFDEF DELPHI4_UP}
     ActnList,
     Imglist,
{$ENDIF}
     stdctrls,
     Extctrls;

Const
     mxOutlookVersion = $0135; // ** 1.53 **
     DefaultHeaderHeight = 22;

Type
     // ************************************************************************
     // ************************************************************************
     // ************************************************************************

     TViewStyle = ( vsNormal, vsBig, vsAdvanced, vsWindowsXP, vsWindows2000 );
     TButtonStyle = ( bsSmall, bsLarge );
     TSelectionType = ( stStandard, stExpanded );
     TBitmapCopy = ( bcMergeCopy, bcMergePaint, bcSrcCopy, bcSrcErase, bcSrcPaint );
{$IFDEF DELPHI4_UP}
     TGlyphLayout = ( glGlyphLeft, glGlyphRight, glGlyphCenter );
{$ENDIF}
     TArrowStyle = ( asUp, asDown );
     TButtonIndex = -1..32767;

{$IFNDEF Delphi5Up}
     TImageIndex = Type Integer;
{$ENDIF}

     TGradientType = ( gtl2r, gts2c, gtt2b, gttb2c );
     TBackStyle = ( bsNormal, bsGradient );

     // ************************************************************************
     // ************************************************************************
     // ************************************************************************

     TmxOutlookBar = Class;
     TmxOutlookBarHeader = Class;
     TOutlookButton = Class;

     // ************************************************************************
     // ************************************************************************
     // ************************************************************************

     TEventCanChangeHeader = Procedure( Sender: TObject; NewHeader: TmxOutlookBarHeader; Var CanChange: Boolean ) Of Object;
     TEventCanSortButtons = Procedure( Sender: TObject; Var CanSort: Boolean ) Of Object;
     TEventHeaderChange = Procedure( Sender: TObject; OldIndex, NewIndex: Integer ) Of Object;
     TEventCheckScroll = Procedure( Sender: TObject; Var ScrollUpNeed, ScrollDownNeed, Automatic: Boolean ) Of Object;

{$IFDEF DELPHI4_UP}
     TEventOnDrawHeader = Procedure( Sender: TObject; Canvas: TCanvas; Var Rect: TRect; GlypX, GlypY, FImageIndex: Integer; Caption: String ) Of Object;
{$ELSE}
     TEventOnDrawHeader = Procedure( Sender: TObject; Canvas: TCanvas; Var Rect: TRect; Caption: String ) Of Object;
{$ENDIF}

     // ************************************************************************
     // ************************************************************************
     // ************************************************************************

{$IFDEF DELPHI4_UP}

     TOutlookButtonActionLink = Class( TControlActionLink )
     Protected
          FClient: TOutlookButton;
          Procedure AssignClient( AClient: TObject ); Override;
          Function IsCaptionLinked: Boolean; Override;
          Function IsEnabledLinked: Boolean; Override;
          Function IsHelpContextLinked: Boolean; Override;
          Function IsHintLinked: Boolean; Override;
          Function IsImageIndexLinked: Boolean; Override;
          Function IsVisibleLinked: Boolean; Override;
          Function IsOnExecuteLinked: Boolean; Override;
          Procedure SetCaption( Const Value: String ); Override;
          Procedure SetEnabled( Value: Boolean ); Override;
          Procedure SetHelpContext( Value: THelpContext ); Override;
          Procedure SetHint( Const Value: String ); Override;
          Procedure SetImageIndex( Value: Integer ); Override;
          Procedure SetVisible( Value: Boolean ); Override;
          Procedure SetOnExecute( Value: TNotifyEvent ); Override;
     End;

     TOutlookButtonActionLinkClass = Class Of TOutlookButtonActionLink;

{$ENDIF}

     // ************************************************************************
     // ************************************************************************
     // ************************************************************************

     TOutlookButton = Class( TCustomControl )
     Private

          FMouseInButton: Boolean;
          FButtonDown: Boolean;
          FButtonStyle: TButtonStyle;
          FCaption: String;
          FLargeImages: TCustomImageList;
          FSmallImages: TCustomImageList;
          FLargeImageChangeLink: TChangeLink;
          FSmallImageChangeLink: TChangeLink;
          FImageIndex: TImageIndex;
          FTransparent: Boolean;
          FAutoSize: Boolean;
          FResizingEnabled: Boolean; // *** Internal Use Only ***

          Procedure WMSetFocus( Var Message: TWMSetFocus ); Message WM_SETFOCUS;
          Procedure WMKillFocus( Var Message: TWMSetFocus ); Message WM_KILLFOCUS;
          Procedure WMLButtonDown( Var Message: TWMLButtonDown ); Message WM_LBUTTONDOWN;

          Procedure CMDialogChar( Var Message: TCMDialogChar ); Message cm_DialogChar;

          Procedure ImageListChange( Sender: TObject );
          Procedure SetLargeImages( Value: TCustomImageList );
          Procedure SetSmallImages( Value: TCustomImageList );
          Procedure SetButtonStyle( Const Value: TButtonStyle );
          Procedure SetCaption( Value: String );
          Procedure SetImageIndex( Value: TImageIndex );
          Procedure SetButtonIndex( Value: TButtonIndex );
          Procedure SetTransparent( Value: Boolean );
          Procedure SetComponentAutoSize( Value: Boolean );
          Function GetButtonIndex: TButtonIndex;

{$IFDEF DELPHI4_UP}
          Procedure OnButtonResized( Sender: TObject; Var NewWidth, NewHeight: Integer; Var Resize: Boolean );
{$ENDIF}

     Protected

{$IFDEF DELPHI4_UP}
          Procedure ActionChange( Sender: TObject; CheckDefaults: Boolean ); Override;

          Function GetActionLinkClass: TControlActionLinkClass; Override;
{$ENDIF}

          Procedure KeyDown( Var Key: Word; Shift: TShiftState ); Override;
          Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
          Procedure CMMouseEnter( Var Message: TMessage ); Message CM_MOUSEENTER;
          Procedure CMMouseLeave( Var Message: TMessage ); Message CM_MOUSELEAVE;
          Procedure CMTextChanged( Var Msg: TMessage ); Message CM_TEXTCHANGED;
          Procedure CMFontChanged( Var Msg: TMessage ); Message CM_FONTCHANGED;
          Procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); Override;
          Procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); Override;
          Procedure Paint; Override;

     Public

          Constructor Create( AOwner: TComponent ); Override;
          Destructor Destroy; Override;

{$IFDEF DELPHI4_UP}
{$IFDEF DELPHI5_UP}
          Function CanFocus: Boolean; Override;
{$ELSE}
          Function MyCanFocus: Boolean;
{$ENDIF}
{$ENDIF}

     Published

{$IFDEF DELPHI4_UP}
          Property Action;
{$ENDIF}
          Property AutoSize: Boolean Read FAutoSize Write SetComponentAutoSize Default TRUE;
          Property ButtonStyle: TButtonStyle Read FButtonStyle Write SetButtonStyle Default bsLarge;
          Property ButtonIndex: TButtonIndex Read GetButtonIndex Write SetButtonIndex;
          Property Caption: String Read FCaption Write SetCaption;
          Property Color;
          Property Enabled;
          Property Font;
          Property ImageIndex: TImageIndex Read FImageIndex Write SetImageIndex Default -1;
          Property LargeImages: TCustomImageList Read FLargeImages Write SetLargeImages;
          Property ParentColor;
          Property PopupMenu;
          Property SmallImages: TCustomImageList Read FSmallImages Write SetSmallImages;
          Property TabStop;
          Property Transparent: Boolean Read FTransparent Write SetTransparent;

{$IFDEF DELPHI4_UP}
          Property DragCursor;
          Property DragKind;
          Property DragMode;
          Property OnDragDrop;
          Property OnDragOver;
          Property OnEndDrag;
{$ENDIF}
          Property OnClick;
          Property OnEnter;
          Property OnDblClick;
          Property OnExit;
          Property OnKeyDown;
          Property OnKeyPress;
          Property OnKeyUp;
          Property OnMouseDown;
          Property OnMouseMove;
          Property OnMouseUp;
{$IFDEF DELPHI4_UP}
          Property OnMouseWheel;
          Property OnMouseWheelDown;
          Property OnMouseWheelUp;
{$ENDIF}

          Property Visible;
     End;

     // ************************************************************************
     // ************************************************************************
     // ************************************************************************

     TmxXPSettings = Class( TPersistent )
     Private

          FBorder: TColor;
          FBackground: TColor;
          FShadow: TColor;
          FButtonShadow: Boolean;
          FOnChange: TNotifyEvent;

          Procedure SetBorder( AValue: TColor );
          Procedure SetShadow( AValue: TColor );
          Procedure SetBackground( AValue: TColor );
          Procedure SetButtonShadow( AValue: Boolean );

     Protected

          Procedure Change; Dynamic;

     Public

          Constructor Create; Virtual;
          Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;

     Published

          Property Border: TColor Read FBorder Write SetBorder;
          Property Background: TColor Read FBackground Write SetBackground;
          Property ButtonShadow: Boolean Read FButtonShadow Write SetButtonShadow;
          Property Shadow: TColor Read FShadow Write SetShadow;

     End;

     // ************************************************************************
     // ************************************************************************
     // ************************************************************************

     TGradient = Class( TPersistent )
     Private

          FGradientType: TGradientType;
          FStartColor: TColor;
          FEndColor: TColor;
          FBackStyle: TBackStyle;

          FOnChange: TNotifyEvent;

     Protected

          Procedure Change; Dynamic;
          Procedure AssignTo( Dest: TPersistent ); Override;

          Procedure SetColor( Index: Integer; Value: TColor );
          Procedure SetGradientType( Value: TGradientType );
          Procedure SetBackStyle( Value: TBackStyle );

     Public

          Constructor Create; Virtual;
          Procedure PaintGradient( ACanvas: TCanvas; ARect: TRect );

          Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;

     Published

          Property BackStyle: TBackStyle Read FBackStyle Write SetBackStyle Default bsNormal;
          Property GradientType: TGradientType Read FGradientType Write SetGradientType Default gtt2b;
          Property StartColor: TColor Index 1 Read FStartColor Write SetColor Default clBlack;
          Property EndColor: TColor Index 2 Read FEndColor Write SetColor Default clBlue;

     End;

     // ************************************************************************
     // ************************************************************************
     // ************************************************************************

     THeaderSettings = Class( TPersistent )
     Private

          FAlignment: TAlignment;
          FBevelInner: TPanelBevel;
          FBevelOuter: TPanelBevel;
          FBevelWidth: TBevelWidth;
          FHeaderColor: TColor;
          FHeaderFont: TFont;
          FHighlightFont: TFont;
          FButtonFont: TFont;
          FKeySupport: Boolean;
{$IFDEF DELPHI4_UP}
          FLayout: TGlyphLayout;
{$ENDIF}
          FAutoScroll: Boolean;
          FButtonSizes: Array[ 1..3 ] Of Integer;
          FButtonStyle: TButtonStyle;
          FViewStyle: TViewStyle;
          FXPSettings: TmxXPSettings;

          FOnChange: TNotifyEvent;

     Protected

          Procedure Change; Dynamic;
          Procedure AssignTo( Dest: TPersistent ); Override;

          Procedure SetAlignment( Value: TAlignment );
          Procedure SetBevelInner( Value: TPanelBevel );
          Procedure SetBevelOuter( Value: TPanelBevel );
          Procedure SetBevelWidth( Value: TBevelWidth );
          Procedure SetHeaderColor( Value: TColor );
          Procedure SetHeaderFont( Value: TFont );
          Procedure SetHighlightFont( Const Value: TFont );
          Procedure SetButtonFont( Const Value: TFont );
{$IFDEF DELPHI4_UP}
          Procedure SetLayout( Value: TGlyphLayout );
{$ENDIF}
          Procedure SetAutoScroll( Value: Boolean );
          Procedure SetKeySupport( Value: Boolean );
          Procedure SetButtonSize( Index: Integer; Value: Integer );
          Procedure SetButtonStyle( Const Value: TButtonStyle );
          Procedure SetViewStyle( AValue: TViewStyle );

          Function GetButtonSize( Index: Integer ): Integer;

     Public

          Constructor Create( DefaultFont: TFont ); Virtual;
          Destructor Destroy; Override;

          Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;

     Published

          Property Alignment: TAlignment Read FAlignment Write SetAlignment Default taCenter;
          Property AutoScroll: Boolean Read FAutoScroll Write SetAutoScroll Default True;
          Property BevelInner: TPanelBevel Read FBevelInner Write SetBevelInner Default bvNone;
          Property BevelOuter: TPanelBevel Read FBevelOuter Write SetBevelOuter Default bvRaised;
          Property BevelWidth: TBevelWidth Read FBevelWidth Write SetBevelWidth Default 1;
          Property ButtonFont: TFont Read FButtonFont Write SetButtonFont;
          Property ButtonStyle: TButtonStyle Read FButtonStyle Write SetButtonStyle Default bsLarge;
          Property HeaderColor: TColor Read FHeaderColor Write SetHeaderColor;
          Property HeaderFont: TFont Read FHeaderFont Write SetHeaderFont;
          Property HighlightFont: TFont Read FHighlightFont Write SetHighlightFont;
          Property KeySupport: Boolean Read FKeySupport Write SetKeySupport;
{$IFDEF DELPHI4_UP}
          Property Layout: TGlyphLayout Read FLayout Write SetLayout Default glGlyphLeft;
{$ENDIF}
          Property LargeWidth: Integer Index 1 Read GetButtonSize Write SetButtonSize;
          Property LargeHeight: Integer Index 2 Read GetButtonSize Write SetButtonSize;
          Property SmallHeight: Integer Index 3 Read GetButtonSize Write SetButtonSize;
          Property ViewStyle: TViewStyle Read FViewStyle Write SetViewStyle;
          Property XPSettings: TmxXPSettings Read FXPSettings Write FXPSettings;

     End;

     // ************************************************************************
     // ************************************************************************
     // ************************************************************************

     TScrollButton = Class( TSpeedButton )
     Private

          FArrowStyle: TArrowStyle;
          Procedure SetArrowStyle( Value: TArrowStyle );
          Procedure CMDesignHitTest( Var Msg: TCMDesignHitTest ); Message CM_DESIGNHITTEST;

     Public

          Constructor Create( AOwner: TComponent ); Override;

     Published

          Property ArrowStyle: TArrowStyle Read FArrowStyle Write SetArrowStyle;

     End;

     // ************************************************************************
     // ************************************************************************
     // ************************************************************************

     TmxOutlookBarHeader = Class( TCustomControl )
     Private

          FCommonStyle: Boolean;
          FBitmap: TBitmap;
          FImageIndex: TImageIndex;
          FBitmapCopy: TBitmapCopy;
          FMouseInHeader: Boolean;
          FButtonDown: Boolean;
          FGradient: TGradient;
          FHeaderSettings: THeaderSettings;
          FFirstVisibleButton: Integer;
          FLastVisibleButton: Integer;

          FAutoSort: Boolean;
          FScrollUp: TScrollButton;
          FScrollDown: TScrollButton;

          FFirstButtonTop: Integer;

          FOnChange: TNotifyEvent;
          FOnCheckScroll: TEventCheckScroll;
          FOnScroll: TNotifyEvent;
          FOnHide: TNotifyEvent;
          FOnShow: TNotifyEvent;
          FOnCanSort: TEventCanSortButtons;
          FOnSort: TNotifyEvent;
          FOnDrawHeader: TEventOnDrawHeader;

          Procedure DoSettingsChange( Sender: TObject );

          Procedure WMSetFocus( Var Message: TWMSetFocus ); Message WM_SETFOCUS;
          Procedure WMKillFocus( Var Message: TWMSetFocus ); Message WM_KILLFOCUS;
          Function CheckChild( Child: TControl ): Boolean;
          Procedure CMDialogChar( Var Message: TCMDialogChar ); Message cm_DialogChar;
          Procedure CMVisibleChanged( Var Message: TMessage ); Message CM_VISIBLECHANGED;
          Procedure CMColorChanged( Var Message: TMessage ); Message CM_COLORCHANGED;
          Procedure CMMouseEnter( Var Message: TMessage ); Message CM_MOUSEENTER;
          Procedure CMMouseLeave( Var Message: TMessage ); Message CM_MOUSELEAVE;

          Function GetHeaderIndex: Integer;
          Function GetParentBar: TmxOutlookBar;
          Function GetHeaderHeight: Integer;

          Procedure SetBitmap( Const Value: TBitmap );
          Procedure SetHeaderIndex( Value: Integer );
          Procedure SetImageIndex( Value: TImageIndex );
          Procedure SetBitmapCopy( Value: TBitmapCopy );
          Procedure SetAutoSort( Value: Boolean );
          Procedure SetFirstButtonTop( Value: Integer );
          Procedure SetCommonStyle( Value: Boolean );
          Procedure PaintTileBackground( ACanvas: TCanvas; Rect: TRect );

          Procedure OnHeaderResized( Sender: TObject );

          Function GetChild( Child: TControl ): TOutlookButton;
          Function GetChildByIndex( Index: Integer ): TOutlookButton;
          Function CreateNewOutlookButton: TOutlookButton;

     Protected

{$IFDEF DELPHI4_UP}
          Procedure AdjustClientRect( Var Rect: TRect ); Override;
          Procedure DragOver( Source: TObject; X, Y: Integer; State: TDragState; Var Accept: Boolean ); Override;
{$ENDIF}
          Procedure KeyDown( Var Key: Word; Shift: TShiftState ); Override;
          Procedure MouseMove( Shift: TShiftState; X, Y: Integer ); Override;
          Procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); Override;
          Procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); Override;
          Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
          Procedure CMDesignHitTest( Var Msg: TCMDesignHitTest ); Message CM_DESIGNHITTEST;
          Procedure CMTextChanged( Var Msg: TMessage ); Message CM_TEXTCHANGED;
          Procedure CMFontChanged( Var Msg: TMessage ); Message CM_FONTCHANGED;
          Procedure Paint; Override;
          Procedure Change; Virtual;
          Procedure InternalSortButtons;
          Procedure AutoSortButtons;

          Procedure Loaded; Override;

     Public

          Constructor Create( AOwner: TComponent ); Override;
          Destructor Destroy; Override;

          Function GetButtonCount: Integer;
          Function GetButtonByIndex( Index: Integer ): TOutlookButton;

          Function CreateButton( Caption: String ): TOutlookButton;
          Procedure AddButton( OutlookButton: TOutlookButton );
          Procedure DeleteButton( Index: Integer );

          Procedure SortButtons;

          Function IsUpButtonNeed: Boolean;
          Function IsDownButtonNeed: Boolean;

{$IFDEF DELPHI4_UP}
{$IFDEF DELPHI5_UP}
          Function CanFocus: Boolean; Override;
{$ELSE}
          Function MyCanFocus: Boolean;
{$ENDIF}
{$ENDIF}

     Published

          Property AutoSort: Boolean Read FAutoSort Write SetAutoSort;
          Property Bitmap: TBitmap Read FBitmap Write SetBitmap;
          Property BitmapCopy: TBitmapCopy Read FBitmapCopy Write SetBitmapCopy Default bcSrcCopy;
          Property Caption;
          Property Color;
          Property CommonStyle: Boolean Read FCommonStyle Write SetCommonStyle;
          Property FirstButtonTop: Integer Read FFirstButtonTop Write SetFirstButtonTop;
          Property Gradient: TGradient Read FGradient Write FGradient;
          Property HeaderSettings: THeaderSettings Read FHeaderSettings Write FHeaderSettings;
          Property HeaderIndex: Integer Read GetHeaderIndex Write SetHeaderIndex;
          Property ImageIndex: TImageIndex Read FImageIndex Write SetImageIndex Default -1;
          Property PopupMenu;
          Property TabStop;
          Property Visible;

          Property OnDrawHeader: TEventOnDrawHeader Read FOnDrawHeader Write FOnDrawHeader;
          Property OnCanSort: TEventCanSortButtons Read FOnCanSort Write FOnCanSort;
          Property OnChange: TNotifyEvent Read FOnChange Write FOnChange;
          Property OnCheckScroll: TEventCheckScroll Read FOnCheckScroll Write FOnCheckScroll;
          Property OnEnter;
          Property OnClick;
          Property OnDblClick;
          Property OnExit;
          Property OnKeyDown;
          Property OnKeyPress;
          Property OnKeyUp;
          Property OnMouseDown;
          Property OnMouseMove;
          Property OnMouseUp;
{$IFDEF DELPHI4_UP}
          Property OnMouseWheel;
          Property OnMouseWheelDown;
          Property OnMouseWheelUp;
          Property OnResize;
{$ENDIF}
          Property OnScroll: TNotifyEvent Read FOnScroll Write FOnScroll;
          Property OnSort: TNotifyEvent Read FOnSort Write FOnSort;
          Property OnHide: TNotifyEvent Read FOnHide Write FOnHide;
          Property OnShow: TNotifyEvent Read FOnShow Write FOnShow;
     End;

     // ************************************************************************
     // ************************************************************************
     // ************************************************************************

     TmxOutlookBar = Class( TCustomControl )
     Private

{$IFNDEF Delphi6_Up}
          FBevelInner: TPanelBevel;
          FBevelOuter: TPanelBevel;
          FBevelWidth: TBevelWidth;
{$ENDIF}

          FActiveHeader: TmxOutlookBarHeader;
          FMouseInControl: TmxOutlookBarHeader;
          FBorderStyle: TBorderStyle;
          FCommonStyle: Boolean;
          FFlat: Boolean;
          FImages: TCustomImageList;
          FImageChangeLink: TChangeLink;
          FButtonDown: Boolean;
          FScrolling: Boolean; // ***  Internal use only ***
          FHeaderHeight: Integer;
          FVersion: Integer;

{$IFDEF HEADERSCROLL}
          FScrollSpeed: Integer;
{$ENDIF}

          FOnChange: TEventHeaderChange;
          FOnCanChange: TEventCanChangeHeader;

          FHeaderSettings: THeaderSettings;

          Procedure DoSettingsChange( Sender: TObject );
          Procedure BarResized( Sender: TObject );
          Procedure BarCanResize( Sender: TObject; Var NewWidth, NewHeight: Integer; Var Resize: Boolean );
          Procedure CMMouseLeave( Var Message: TMessage ); Message CM_MOUSELEAVE;

{$IFDEF DELPHI4_UP}
          Procedure CMBorderChanged( Var Message: TMessage ); Message CM_BORDERCHANGED;
{$ENDIF}
          Procedure CMCtl3DChanged( Var Message: TMessage ); Message CM_CTL3DCHANGED;
          Procedure CMSysColorChange( Var Message: TMessage ); Message CM_SYSCOLORCHANGE;
          Procedure CMColorChanged( Var Message: TMessage ); Message CM_COLORCHANGED;
          Procedure CMEnabledChanged( Var Message: TMessage ); Message CM_ENABLEDCHANGED;

          Function CheckChild( Child: TControl ): Boolean;
          Function GetChild( Child: TControl ): TmxOutlookBarHeader;
          Function GetChildByIndex( Index: Integer ): TmxOutlookBarHeader;
          Function GetHeaderRect( Index: Integer ): TRect;
          Function GetUnVisibleHeaderCountToIndex( Index: Integer ): Integer;
          Function GetUnVisibleHeaderCountAfterIndex( Index: Integer ): Integer;

          Procedure ImageListChange( Sender: TObject );

          Procedure SetBorderStyle( Value: TBorderStyle );
          Procedure SetCommonStyle( Value: Boolean );
          Procedure SetFlat( Value: Boolean );
          Procedure SetHeaderHeight( Value: Integer );
          Procedure SetHeaderSizes;
          Procedure SetImages( Value: TCustomImageList );
{$IFDEF HEADERSCROLL}
          Procedure SetScrollSpeed( Value: integer );
{$ENDIF}
          Function CreateNewOutlookHeader: TmxOutlookBarHeader;

          Procedure SetVersion( Value: String );
          Function GetVersion: String;

     Protected

          Procedure DefineProperties( Filer: TFiler ); Override;
          Procedure ReadAlign( Reader: TReader );
          Procedure WriteAlign( Writer: TWriter );

          Procedure WMGetDlgCode( Var Msg: TWMGetDlgCode ); Message WM_GETDLGCODE;
          Procedure CMFontChanged( Var Msg: TMessage ); Message CM_FONTCHANGED;
{$IFDEF DELPHI4_UP}
          Procedure AdjustClientRect( Var Rect: TRect ); Override;
{$ENDIF}
          Procedure CreateParams( Var Params: TCreateParams ); Override;
          Procedure ChangeHeader( OutlookSideBarHeader: TmxOutlookBarHeader );
          Procedure Paint; Override;
          Procedure SetActiveHeader( Const Value: TmxOutlookBarHeader );
          Procedure Notification( AComponent: TComponent; Operation: TOperation ); Override;
          Procedure KeyDown( Var Key: Word; Shift: TShiftState ); Override;

{$IFNDEF Delphi6_Up}
          Procedure SetBevelInner( Value: TPanelBevel );
          Procedure SetBevelOuter( Value: TPanelBevel );
          Procedure SetBevelWidth( Value: TBevelWidth );
{$ENDIF}

          Property MouseInControl: TmxOutlookBarHeader Read FMouseInControl Write FMouseInControl;

          Function GetClientRect: TRect; Override;

     Public

          Constructor Create( AOwner: TComponent ); Override;
          Destructor Destroy; Override;

          Function GetHeaderCount: Integer;
          Function GetHeaderIndex: Integer;

          Function GetPrevHeader( OutlookSideBarHeader: TmxOutlookBarHeader ): TmxOutlookBarHeader;
          Function GetNextHeader( OutlookSideBarHeader: TmxOutlookBarHeader ): TmxOutlookBarHeader;

          Procedure CreateHeader( Const Caption: String );
          Procedure AddHeader( OutlookSideBarHeader: TmxOutlookBarHeader );
          Procedure DeleteHeader( Index: Integer );

          Function GetHeaderByIndex( Index: Integer ): TmxOutlookBarHeader;

{$IFDEF DELPHI4_UP}
{$IFDEF DELPHI5_UP}
          Function CanFocus: Boolean; Override;
{$ELSE}
          Function MyCanFocus: Boolean;
{$ENDIF}
{$ENDIF}

     Published

          Property ActiveHeader: TmxOutlookBarHeader Read FActiveHeader Write SetActiveHeader;
{$IFDEF DELPHI4_UP}
          Property Anchors;
          Property Caption;
          Property Font;
{$ENDIF}
          Property Align;

{$IFNDEF Delphi6_Up}
          Property BevelInner: TPanelBevel Read FBevelInner Write SetBevelInner Default bvNone;
          Property BevelOuter: TPanelBevel Read FBevelOuter Write SetBevelOuter Default bvRaised;
          Property BevelWidth: TBevelWidth Read FBevelWidth Write SetBevelWidth Default 1;
{$ELSE}
          Property BevelEdges;
          Property BevelOuter;
          Property BevelKind;
          Property BevelInner;
          Property BevelWidth;
{$ENDIF}

          Property BorderStyle: TBorderStyle Read FBorderStyle Write SetBorderStyle Default bsNone;

{$IFDEF DELPHI4_UP}
          Property BorderWidth;
{$ENDIF}

          Property ButtonDown: Boolean Read FButtonDown Write FButtonDown;

{$IFDEF DELPHI4_UP}
          Property Constraints;
{$ENDIF}
          Property Color;
          Property CommonStyle: Boolean Read FCommonStyle Write SetCommonStyle;
          Property Ctl3D;
          Property Enabled;
          Property Flat: Boolean Read FFlat Write SetFlat Default False;
          Property HeaderHeight: Integer Read FHeaderHeight Write SetHeaderHeight;
          Property HeaderSettings: THeaderSettings Read FHeaderSettings Write FHeaderSettings;
          Property Images: TCustomImageList Read FImages Write SetImages;
          Property PopupMenu;

{$IFDEF HEADERSCROLL}
          Property ScrollSpeed: Integer Read FScrollSpeed Write SetScrollSpeed;
{$ENDIF}

          Property TabStop;
          Property TabOrder;
          Property Version: String Read GetVersion Write SetVersion;
          Property Visible;

          Property OnChange: TEventHeaderChange Read FOnChange Write FOnChange;
          Property OnCanChange: TEventCanChangeHeader Read FOnCanChange Write FOnCanChange;
          Property OnClick;
          Property OnDblClick;

{$IFDEF DELPHI4_UP}
          Property DockSite;
          Property DragCursor;
          Property DragKind;
          Property DragMode;
          Property OnDockDrop;
          Property OnDragDrop;
          Property OnDragOver;
          Property OnEndDock;
          Property OnEndDrag;
          Property OnGetSiteInfo;
          Property OnStartDock;
          Property OnUndock;
{$ENDIF}

{$IFDEF DELPHI4_UP}
          Property OnCanResize;
{$ENDIF}
          Property OnEnter;
          Property OnExit;
          Property OnKeyDown;
          Property OnKeyPress;
          Property OnKeyUp;
          Property OnMouseDown;
          Property OnMouseMove;
          Property OnMouseUp;
{$IFDEF DELPHI4_UP}
          Property OnMouseWheel;
          Property OnMouseWheelDown;
          Property OnMouseWheelUp;
          Property OnResize;
{$ENDIF}
     End;

Implementation

Const
     Alignments: Array[ TAlignment ] Of Longint = ( DT_LEFT, DT_RIGHT, DT_CENTER );

Type
     TWinControlClass = Class( TWinControl );

// *************************************************************************************
// *************************************************************************************
// *************************************************************************************
// ** TOutlookButton.Create, 4/12/01 3:42:02 PM
// *************************************************************************************
// *************************************************************************************
// *************************************************************************************

Constructor TOutlookButton.Create( AOwner: TComponent );
Begin
     Inherited Create( AOwner );
     ControlStyle := [ csCaptureMouse, csClickEvents, csDoubleClicks, csOpaque ];
     FButtonDown := FALSE;
     FMouseInButton := FALSE;
     FButtonStyle := bsLarge;
     Height := 60;
     Width := 60;
     FImageIndex := -1;
     FTransparent := TRUE;
     FAutoSize := TRUE;

     TabStop := TRUE;

     FLargeImageChangeLink := TChangeLink.Create;
     FLargeImageChangeLink.OnChange := ImageListChange;
     FSmallImageChangeLink := TChangeLink.Create;
     FSmallImageChangeLink.OnChange := ImageListChange;

{$IFDEF DELPHI4_UP}
     OnCanResize := OnButtonResized;
{$ENDIF}

     FResizingEnabled := FALSE;
End;

// *************************************************************************************
// ** TOutlookButton.Destroy, 4/12/01 3:42:05 PM
// *************************************************************************************

Destructor TOutlookButton.Destroy;
Begin
     FLargeImageChangeLink.Free;
     FSmallImageChangeLink.Free;
     Inherited Destroy;
End;

// *************************************************************************************
// ** TOutlookButton.ActionChange, 8/10/01 8:54:56 AM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TOutlookButton.ActionChange( Sender: TObject; CheckDefaults: Boolean );
Begin
     Inherited ActionChange( Sender, CheckDefaults );

     If Action Is TCustomAction Then
          With TCustomAction( Sender ) Do
          Begin
               If Not CheckDefaults Or ( Self.Caption = '' ) Or ( Self.Caption = Self.Name ) Then Self.Caption := Caption;
               If Not CheckDefaults Or ( Self.Enabled = True ) Then Self.Enabled := Enabled;
               If Not CheckDefaults Or ( Self.HelpContext = 0 ) Then Self.HelpContext := HelpContext;
               If Not CheckDefaults Or ( Self.Hint = '' ) Then Self.Hint := Hint;
               If Not CheckDefaults Or ( Self.ImageIndex = -1 ) Then Self.ImageIndex := ImageIndex;
               If Not CheckDefaults Or ( Self.Visible = True ) Then Self.Visible := Visible;
               If Not CheckDefaults Or Not Assigned( Self.OnClick ) Then Self.OnClick := OnExecute;
          End;
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButton.GetActionLinkClass, 10/11/01 12:52:54 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Function TOutlookButton.GetActionLinkClass: TControlActionLinkClass;
Begin
     Result := TOutlookButtonActionLink;
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButton.CanFocus, 5/16/01 9:32:48 AM
// *************************************************************************************

{$IFDEF DELPHI4_UP}
{$IFDEF DELPHI5_UP}

Function TOutlookButton.CanFocus: Boolean;
{$ELSE}

Function TOutlookButton.MyCanFocus: Boolean;
{$ENDIF}
Var
     mxOutlookBarHeader: TmxOutlookBarHeader;
     _CanFocus: Boolean;
Begin
{$IFDEF DELPHI5_UP}
     _CanFocus := Inherited CanFocus;
{$ELSE}
     _CanFocus := Self.CanFocus;
{$ENDIF}

     If Parent Is TmxOutlookBarHeader Then
     Begin
          mxOutlookBarHeader := ( Parent As TmxOutlookBarHeader );
          If _CanFocus Then
          Begin
               If mxOutlookBarHeader.GetParentBar <> Nil Then
               Begin
                    If mxOutlookBarHeader.GetParentBar.CommonStyle Then
                         _CanFocus := mxOutlookBarHeader.GetParentBar.HeaderSettings.KeySupport Else
                         _CanFocus := mxOutlookBarHeader.HeaderSettings.KeySupport;

                    If _CanFocus Then
                         _CanFocus := mxOutlookBarHeader.GetParentBar.ActiveHeader = mxOutlookBarHeader;
               End;
          End;
     End;

     Result := _CanFocus;
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButton.WMSetFocus, 5/11/01 4:36:11 PM
// *************************************************************************************

Procedure TOutlookButton.WMSetFocus( Var Message: TWMSetFocus );
Begin
     If Parent Is TmxOutlookBarHeader Then
     Begin
          If ( Parent As TmxOutlookBarHeader ).GetParentBar <> Nil Then
               If ( Parent As TmxOutlookBarHeader ).GetParentBar.ActiveHeader = ( Parent As TmxOutlookBarHeader ) Then
               Begin
                    Windows.SetFocus( TWinControl( Self ).Handle );
                    Invalidate;
               End;
     End
     Else Inherited;
End;

// *************************************************************************************
// ** TOutlookButton.WMKillFocus, 5/11/01 4:44:06 PM
// *************************************************************************************

Procedure TOutlookButton.WMKillFocus( Var Message: TWMSetFocus );
Begin
     Invalidate;
     Inherited;
End;

// *************************************************************************************
// ** TOutlookButton.OnButtonResized, 4/26/01 3:45:56 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TOutlookButton.OnButtonResized( Sender: TObject; Var NewWidth, NewHeight: Integer; Var Resize: Boolean );
Begin
     If FResizingEnabled Then Resize := TRUE Else Resize := Not FAutoSize;
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButton.Notification, 4/17/01 3:11:44 PM
// *************************************************************************************

Procedure TOutlookButton.Notification( AComponent: TComponent; Operation: TOperation );
Begin
     Inherited Notification( AComponent, Operation );

     If Operation = opRemove Then
     Begin
          If AComponent = LargeImages Then LargeImages := Nil;
          If AComponent = SmallImages Then SmallImages := Nil;
          If AComponent = PopupMenu Then PopupMenu := Nil;
{$IFDEF DELPHI4_UP}
          If AComponent = Action Then Action := Nil;
{$ENDIF}
     End;
End;

// *************************************************************************************
// ** TOutlookButton.SetComponentAutoSize, 4/26/01 2:11:55 PM
// *************************************************************************************

Procedure TOutlookButton.SetComponentAutoSize( Value: Boolean );
Begin
     If FAutoSize <> Value Then
     Begin
          FAutoSize := Value;

          If Parent Is TmxOutlookBarHeader Then
               ( Parent As TmxOutlookBarHeader ).DoSettingsChange( ( Parent As TmxOutlookBarHeader ).HeaderSettings );
     End;
End;

// *************************************************************************************
// ** TOutlookButton.GetButtonIndex, 4/18/01 3:56:58 PM
// *************************************************************************************

Function TOutlookButton.GetButtonIndex: TButtonIndex;
Begin
     Result := TabOrder;
End;

// *************************************************************************************
// ** TOutlookButton.SetButtonIndex, 4/18/01 3:55:21 PM
// *************************************************************************************

Procedure TOutlookButton.SetButtonIndex( Value: TButtonIndex );
Begin
     If TabOrder <> Value Then
     Begin
          TabOrder := Value;
          If ( Parent Is TmxOutlookBarHeader ) Then
               ( Parent As TmxOutlookBarHeader ).AutoSortButtons;
     End;
End;

// *************************************************************************************
// ** TOutlookButton.SetTransparent, 4/20/01 1:18:39 PM
// *************************************************************************************

Procedure TOutlookButton.SetTransparent( Value: Boolean );
Begin
     If FTransparent <> Value Then
     Begin
          FTransparent := Value;
          RePaint;
          If ( Parent Is TmxOutlookBarHeader ) Then
               ( Parent As TmxOutlookBarHeader ).AutoSortButtons;
     End;
End;

// *************************************************************************************
// ** TOutlookButton.SetCaption, 4/17/01 2:52:17 PM
// *************************************************************************************

Procedure TOutlookButton.SetCaption( Value: String );
Begin
     If FCaption <> Value Then
     Begin
          FCaption := Value;
          RePaint;
     End;
End;

// *************************************************************************************
// ** TOutlookButton.CMMouseEnter, 4/12/01 3:42:07 PM
// *************************************************************************************

Procedure TOutlookButton.CMMouseEnter( Var Message: TMessage );
Begin
     FMouseInButton := TRUE;
     RePaint;
End;

// *************************************************************************************
// ** TOutlookButton.WMLButtonDown, 5/4/01 1:09:13 PM
// *************************************************************************************

Procedure TOutlookButton.WMLButtonDown( Var Message: TWMLButtonDown );
Begin
     Inherited;
End;

// *************************************************************************************
// ** TOutlookButton.CMMouseLeave, 4/12/01 3:42:10 PM
// *************************************************************************************

Procedure TOutlookButton.CMMouseLeave( Var Message: TMessage );
Begin
     FMouseInButton := FALSE;
     FButtonDown := FALSE;
     RePaint;
End;

// *************************************************************************************
// ** TOutlookButton.SetLargeImages, 4/11/01 2:24:43 PM
// *************************************************************************************

Procedure TOutlookButton.SetLargeImages( Value: TCustomImageList );
Begin
     If FLargeImages <> Nil Then FLargeImages.UnRegisterChanges( FLargeImageChangeLink );

     FLargeImages := Value;

     If FLargeImages <> Nil Then
     Begin
          FLargeImages.RegisterChanges( FLargeImageChangeLink );
          FLargeImages.FreeNotification( Self );
     End;
     ImageListChange( LargeImages );
End;

// *************************************************************************************
// ** TOutlookButton.SetSmallImages, 4/11/01 2:24:43 PM
// *************************************************************************************

Procedure TOutlookButton.SetSmallImages( Value: TCustomImageList );
Begin
     If FSmallImages <> Nil Then FSmallImages.UnRegisterChanges( FSmallImageChangeLink );

     FSmallImages := Value;

     If FSmallImages <> Nil Then
     Begin
          FSmallImages.RegisterChanges( FSmallImageChangeLink );
          FSmallImages.FreeNotification( Self );
     End;
     ImageListChange( SmallImages );
End;

// *************************************************************************************
// ** TOutlookButton.SetImageIndex, 4/17/01 3:17:05 PM
// *************************************************************************************

Procedure TOutlookButton.SetImageIndex( Value: TImageIndex );
Begin
     If FImageIndex <> Value Then
     Begin
          FImageIndex := Value;
          RePaint;
     End;
End;

// *************************************************************************************
// ** TOutlookButton.SetImages, 4/11/01 2:24:43 PM
// *************************************************************************************

Procedure TOutlookButton.ImageListChange( Sender: TObject );
Begin
     Repaint;
End;

// *************************************************************************************
// ** TOutlookButton.MouseDown, 4/12/01 3:42:16 PM
// *************************************************************************************

Procedure TOutlookButton.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
Begin
     Inherited MouseDown( Button, Shift, X, Y );

     If Button = mbLeft Then
     Begin
          FButtonDown := TRUE;
          RePaint;
     End;
End;

// *************************************************************************************
// ** TOutlookButton.MouseUp, 4/12/01 3:42:21 PM
// *************************************************************************************

Procedure TOutlookButton.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
Begin
     If Button = mbLeft Then
     Begin
          FButtonDown := FALSE;

{$IFDEF DELPHI4_UP}
{$IFDEF DELPHI5_UP}
          If CanFocus Then SetFocus;
{$ELSE}
          If MyCanFocus Then SetFocus;
{$ENDIF}
{$ENDIF}
          RePaint;
     End;

     Inherited MouseUp( Button, Shift, X, Y );
End;

// *************************************************************************************
// ** TOutlookButton.TmxOutlookBarHeader, 4/17/01 3:02:16 PM
// *************************************************************************************

Procedure TOutlookButton.CMTextChanged( Var Msg: TMessage );
Begin
     Inherited;
     RePaint;
End;

// *************************************************************************************
// ** TOutlookButton.CMFontChanged, 4/17/01 3:02:13 PM
// *************************************************************************************

Procedure TOutlookButton.CMFontChanged( Var Msg: TMessage );
Begin
     Inherited;
     RePaint;
End;

// *************************************************************************************
// ** TOutlookButton.Paint, 4/20/01 2:34:04 PM
// *************************************************************************************

Procedure TOutlookButton.Paint;
Var
     ARect: TRect;
     Dummy_Rect: TRect;
     TextSize: TSize;
     TextRect: TRect;
     Rect_Picture: TRect;
     Rect_ButtonPicture: TRect;
     Rect_SmallButton: TRect;
     FontHeight: Integer;
     Flags: Longint;
     BitmapImage: TBitmap;
{$IFNDEF DELPHI4_UP}
     D3_Image: TBitmap;
{$ENDIF}
     FocusEnabled: Boolean;
{IFNDEF DELPHI5_UP}
     mxOutlookBarHeader: TmxOutlookBarHeader;
{ENDIF}
     HeaderSettings: THeaderSettings;
     ShadowBitmap: TBitmap;
     _BrushColor: TColor;
     _BrushType: TBrushStyle;

     Procedure SetTransparentBackground( Control: TControl; ACanvas: TCanvas );
     Var
          DC: HDC;
          DCID: Integer;
          I: Integer;
          Rect_Control: TRect;
          Rect_Parent: TRect;
          Rect: TRect;
     Begin
          If ( Control = Nil ) Or ( Control.Parent = Nil ) Then Exit;

          DC := ACanvas.Handle;
          Control.Parent.ControlState := Control.Parent.ControlState + [ csPaintCopy ];

          Rect_Control := Bounds( Control.Left, Control.Top, Control.Width, Control.Height );

          DCID := SaveDC( DC );
          SetViewportOrgEx( DC, -Control.Left, -Control.Top, Nil );
          IntersectClipRect( DC, 0, 0, Control.Parent.ClientWidth, Control.Parent.ClientHeight );
          TWinControlClass( Control.Parent ).PaintWindow( DC );
          RestoreDC( DC, DCID );

          For I := 0 To Control.Parent.ControlCount - 1 Do
          Begin
               If ( Control.Parent.Controls[ I ] <> Control ) Then Break;

               If ( Control.Parent.Controls[ I ] <> Nil ) And ( Control.Parent.Controls[ I ] Is TGraphicControl ) Then
               Begin
                    Rect_Parent := Bounds( Left, Top, Width, Height );

                    If IntersectRect( Rect, Rect_Control, Rect_Parent ) And Visible Then
                    Begin
                         With TGraphicControl( Control.Parent.Controls[ I ] ) Do
                         Begin
                              ControlState := ControlState + [ csPaintCopy ];
                              DCID := SaveDC( DC );
                              Try
                                   SetViewportOrgEx( DC, Left - Control.Left, Top - Control.Top, Nil );
                                   IntersectClipRect( DC, 0, 0, Width, Height );
                                   Perform( WM_PAINT, DC, 0 );
                              Finally
                                   RestoreDC( DC, DCID );
                                   ControlState := ControlState - [ csPaintCopy ];
                              End;
                         End;
                    End;
               End;
          End;

          Control.Parent.ControlState := Control.Parent.ControlState - [ csPaintCopy ];
     End;

Begin
{$IFDEF DELPHI4_UP}
     ControlState := ControlState + [ csCustomPaint ];
{$ELSE}
     D3_Image := TBitmap.Create;
{$ENDIF}

     BitmapImage := TBitmap.Create;
     BitmapImage.Width := Width;
     BitmapImage.Height := Height;

     If ( FTransparent ) And ( Not ( csDesigning In ComponentState ) ) Then
          SetTransparentBackground( Self, BitmapImage.Canvas ) Else
     Begin
          BitmapImage.Canvas.Brush.Color := Color;
          BitmapImage.Canvas.Brush.Style := bsSolid;
          BitmapImage.Canvas.FillRect( ClientRect );
     End;

     If FButtonStyle = bsLarge Then
     Begin
          ARect := Bounds( 0, 0, Width, Height );

          // *** Caption size ***

          BitmapImage.Canvas.Brush.Style := bsClear;
          BitmapImage.Canvas.Font := Self.Font;
          FontHeight := BitmapImage.Canvas.TextHeight( 'W' );

          // ********************

          If ( FLargeImages <> Nil ) And ( FImageIndex >= 0 ) Then
          Begin
{$IFNDEF DELPHI4_UP}
               FLargeImages.GetBitmap( FImageIndex, D3_Image );

               If D3_Image <> Nil Then
                    If Caption <> '' Then
                         Rect_Picture := Bounds( ( Width - D3_Image.Width ) Div 2, 4, D3_Image.Width, D3_Image.Height ) Else
                         Rect_Picture := Bounds( ( Width - D3_Image.Width ) Div 2, 4, D3_Image.Width, D3_Image.Height );
{$ELSE}
               If Caption <> '' Then
                    Rect_Picture := Bounds( ( Width - FLargeImages.Width ) Div 2, 4, FLargeImages.Width, FLargeImages.Height ) Else
                    Rect_Picture := Bounds( ( Width - FLargeImages.Width ) Div 2, 4, FLargeImages.Width, FLargeImages.Height );
{$ENDIF}

               {If FButtonDown Then
                    FLargeImages.Draw( BitmapImage.Canvas, Rect_Picture.Left + 1, Rect_Picture.Top + 1, FImageIndex ) Else
                    FLargeImages.Draw( BitmapImage.Canvas, Rect_Picture.Left, Rect_Picture.Top, FImageIndex );

               InflateRect( Rect_Picture, 2, 2 );}
          End
          Else
          Begin
               If FLargeImages <> Nil Then
                    Dummy_Rect := Bounds( ( Width - FLargeImages.Width ) Div 2, 4, FLargeImages.Width, FLargeImages.Height ) Else
                    Dummy_Rect := ARect;

               {If FButtonDown Then
                    DrawEdge( BitmapImage.Canvas.Handle, Dummy_Rect, BDR_SUNKENINNER, BF_RECT ) Else
                    If FMouseInButton Then DrawEdge( BitmapImage.Canvas.Handle, Dummy_Rect, BDR_RAISEDOUTER, BF_RECT );
                }
               Rect_Picture := Dummy_Rect;
          End;

          // **********************
          // * Draw Border of Button
          // **********************

          {If FButtonDown Then
               DrawEdge( BitmapImage.Canvas.Handle, Rect_Picture, BDR_SUNKENINNER, BF_RECT ) Else
               If FMouseInButton Then
                    DrawEdge( BitmapImage.Canvas.Handle, Rect_Picture, BDR_RAISEDOUTER, BF_RECT ) Else
                    DrawEdge( BitmapImage.Canvas.Handle, Rect_Picture, BDR_SUNKENINNER, BF_FLAT );
           }

          // *** Caption ***   ok

//          Flags := DT_EXPANDTABS Or DT_NOCLIP Or Alignments[ taCenter ];
          Flags := DT_WORDBREAK Or DT_EXPANDTABS Or DT_NOCLIP Or Alignments[ taCenter ];
{$IFDEF DELPHI4_UP}
          Flags := DrawTextBiDiModeFlags( Flags );
{$ENDIF}

          HeaderSettings := Nil;

          If Parent Is TmxOutlookBarHeader Then
          Begin
               mxOutlookBarHeader := ( Parent As TmxOutlookBarHeader );
               If mxOutlookBarHeader.GetParentBar <> Nil Then
               Begin
                    If mxOutlookBarHeader.GetParentBar.CommonStyle Then
                    Begin
                         HeaderSettings := mxOutlookBarHeader.GetParentBar.HeaderSettings;
                         BitmapImage.Canvas.Font.Assign( HeaderSettings.ButtonFont );
                    End
                    Else
                    Begin
                         HeaderSettings := mxOutlookBarHeader.HeaderSettings;

                         If mxOutlookBarHeader.CommonStyle Then
                              BitmapImage.Canvas.Font.Assign( mxOutlookBarHeader.HeaderSettings.ButtonFont ) Else
                              BitmapImage.Canvas.Font.Assign( Font );
                    End;
               End
               Else
               Begin
                    If mxOutlookBarHeader.CommonStyle Then
                    Begin
                         HeaderSettings := mxOutlookBarHeader.GetParentBar.HeaderSettings;
                         BitmapImage.Canvas.Font.Assign( mxOutlookBarHeader.HeaderSettings.ButtonFont );
                    End
                    Else
                    Begin
                         HeaderSettings := mxOutlookBarHeader.HeaderSettings;
                         BitmapImage.Canvas.Font.Assign( Font );
                    End;
               End;
          End
          Else BitmapImage.Canvas.Font.Assign( Font );

          // **********************
          // * Draw Border of Button
          // **********************

          Rect_ButtonPicture := Rect_Picture;

          If HeaderSettings = Nil Then
          Begin
               If FButtonDown Then
                    DrawEdge( BitmapImage.Canvas.Handle, Rect_Picture, BDR_SUNKENINNER, BF_RECT ) Else
                    If FMouseInButton Then
                         DrawEdge( BitmapImage.Canvas.Handle, Rect_Picture, BDR_RAISEDOUTER, BF_RECT ) Else
                         DrawEdge( BitmapImage.Canvas.Handle, Rect_Picture, BDR_SUNKENINNER, BF_FLAT );
          End
          Else
          Begin
               If ( HeaderSettings.ViewStyle In [ vsWindowsXP, vsWindows2000, vsBig, vsAdvanced ] ) Then Rect_Picture := ARect Else
               Begin
                    InflateRect( Rect_Picture, 2, 2 );
               End;

               Case HeaderSettings.ViewStyle Of
                    vsNormal, vsAdvanced, vsBig:
                         Begin
                              If FButtonDown Then
                                   DrawEdge( BitmapImage.Canvas.Handle, Rect_Picture, BDR_SUNKENINNER, BF_RECT ) Else
                                   If FMouseInButton Then
                                        DrawEdge( BitmapImage.Canvas.Handle, Rect_Picture, BDR_RAISEDOUTER, BF_RECT ) Else
                                        DrawEdge( BitmapImage.Canvas.Handle, Rect_Picture, BDR_SUNKENINNER, BF_FLAT );

                              If ( FLargeImages <> Nil ) And ( FImageIndex >= 0 ) Then
                              Begin
                                   FLargeImages.ImageType := itImage;

                                   If FButtonDown Then
                                        FLargeImages.Draw( BitmapImage.Canvas, Rect_ButtonPicture.Left + 1, Rect_ButtonPicture.Top + 1, FImageIndex ) Else
                                        FLargeImages.Draw( BitmapImage.Canvas, Rect_ButtonPicture.Left, Rect_ButtonPicture.Top, FImageIndex );
                              End;
                         End;

                    vsWindowsXP, vsWindows2000:
                         Begin
                              If FButtonDown Or FMouseInButton Then
                              Begin
                                   BitmapImage.Canvas.Brush.Color := HeaderSettings.XPSettings.Border;

                                   BitmapImage.Canvas.FrameRect( Rect_Picture );
                                   BitmapImage.Canvas.Brush.Color := HeaderSettings.XPSettings.Background;

                                   Inc( Rect_Picture.Left );
                                   Inc( Rect_Picture.Top );
                                   Dec( Rect_Picture.Right );
                                   Dec( Rect_Picture.Bottom );

                                   BitmapImage.Canvas.FillRect( Rect_Picture );

                                   // *** Draw Button Bitmap **

                                   If ( FLargeImages <> Nil ) And ( FImageIndex >= 0 ) Then
                                   Begin
                                        If Not FButtonDown Then
                                        Begin
                                             _BrushColor := BitmapImage.Canvas.Brush.Color;
                                             _BrushType := BitmapImage.Canvas.Brush.Style;

                                             If HeaderSettings.XPSettings.ButtonShadow Then
                                             Begin
                                                  BitmapImage.Canvas.Brush.Color := HeaderSettings.XPSettings.Shadow;
                                                  BitmapImage.Canvas.Brush.Style := bsSolid;

                                                  ShadowBitmap := TBitmap.Create;
                                                  ShadowBitmap.Width := FLargeImages.Width;
                                                  ShadowBitmap.Height := FLargeImages.Height;

                                                  FLargeImages.ImageType := itMask;
                                                  FLargeImages.Draw( ShadowBitmap.Canvas, Rect_Picture.Left, Rect_Picture.Top, FImageIndex );

                                                  DrawState( BitmapImage.Canvas.Handle, BitmapImage.Canvas.Brush.Handle, Nil,
                                                       Integer( ShadowBitmap.Handle ),
                                                       0,
                                                       Rect_ButtonPicture.Left,
                                                       Rect_ButtonPicture.Top,
                                                       0,
                                                       0,
                                                       DST_BITMAP Or DSS_MONO );

                                                  ShadowBitmap.Free;
                                             End;

                                             FLargeImages.ImageType := itImage;
                                             FLargeImages.Draw( BitmapImage.Canvas, Rect_ButtonPicture.Left - 1, Rect_ButtonPicture.Top - 1, FImageIndex );

                                             BitmapImage.Canvas.Brush.Color := _BrushColor;
                                             BitmapImage.Canvas.Brush.Style := _BrushType;
                                        End
                                        Else
                                        Begin
                                             FLargeImages.ImageType := itImage;
                                             FLargeImages.Draw( BitmapImage.Canvas, Rect_ButtonPicture.Left, Rect_ButtonPicture.Top, FImageIndex );
                                        End;
                                   End;
                              End
                              Else
                              Begin
                                   If ( FLargeImages <> Nil ) And ( FImageIndex >= 0 ) Then
                                   Begin
                                        FLargeImages.ImageType := itImage;
                                        FLargeImages.Draw( BitmapImage.Canvas, Rect_ButtonPicture.Left, Rect_ButtonPicture.Top, FImageIndex );
                                   End;
                              End;
                         End;
               End;
          End;

          // **********************
          // * Draw Caption of Button
          // **********************

          TextRect := ARect;
          TextRect := ARect;
          TextRect.Top := 36; // TextRect.Bottom - FontHeight - 2;
//          DrawText( BitmapImage.Canvas.Handle, PChar( Caption ), -1, TextRect, Flags );

{$WARNINGS OFF}
//fuck
      //    if BitmapImage.Canvas.TextWidth(caption) < 60 then
            DrawText( BitmapImage.Canvas.Handle, PChar( Caption ), -1, TextRect, Flags );
        //  else
            //DrawText( BitmapImage.Canvas.Handle, PChar( 'fuck' ), -1, TextRect, Flags );
//          DrawText( BitmapImage.Canvas.Handle, PChar( 'fuck' ), -1, TextRect, Flags );
//          TextRect.Bottom := TextRect.Bottom + BitmapImage.Canvas.TextHeight('W') + 2;
  //        DrawText( BitmapImage.Canvas.Handle, PChar( 'you' ), -1, TextRect, Flags );
{$WARNINGS ON}
     End
     Else // *** SMALL BUTTONS ***
     Begin
          ARect := Bounds( 0, 0, Width, Height );

          // *** Caption size ***

          BitmapImage.Canvas.Brush.Style := bsClear;
          BitmapImage.Canvas.Font := Self.Font;

          // ********************

          If ( FSmallImages <> Nil ) And ( FImageIndex >= 0 ) Then
          Begin
{$IFNDEF DELPHI4_UP}
               FSmallImages.GetBitmap( FImageIndex, D3_Image );

               If D3_Image <> Nil Then
               Begin
                    Rect_Picture := Bounds( 4, 2 + ( Height - D3_Image.Height ) Div 2, D3_Image.Width, D3_Image.Height );
                    ARect.Right := ARect.Left + D3_Image.Width + 4;
               End
               Else
               Begin
                    Rect_Picture := Bounds( 4, 2 + ( Height - FSmallImages.Height ) Div 2, FSmallImages.Width, FSmallImages.Height );
                    ARect.Right := ARect.Left + FSmallImages.Width + 4;
               End;
{$ELSE}
               Rect_Picture := Bounds( 4, 2 + ( Height - FSmallImages.Height ) Div 2, FSmallImages.Width, FSmallImages.Height );
               ARect.Right := ARect.Left + FSmallImages.Width + 4;
{$ENDIF}

               InflateRect( Rect_Picture, 2, 2 );

               {If FButtonDown Then
               Begin
                    FSmallImages.Draw( BitmapImage.Canvas, Rect_Picture.Left + 1, Rect_Picture.Top + 1, FImageIndex );
                    DrawEdge( BitmapImage.Canvas.Handle, ARect, BDR_SUNKENINNER, BF_RECT );
               End
               Else
               Begin
                    FSmallImages.Draw( BitmapImage.Canvas, Rect_Picture.Left, Rect_Picture.Top, FImageIndex );
                    If FMouseInButton Then DrawEdge( BitmapImage.Canvas.Handle, ARect, BDR_RAISEDOUTER, BF_RECT );
               End;

               ARect.Left := ARect.Right;
               ARect.Right := Width;}
          End
          Else
          Begin
               If FSmallImages <> Nil Then
                    Dummy_Rect := Bounds( 2, 2, FSmallImages.Width, FSmallImages.Height ) Else
                    Dummy_Rect := ARect;

               {If FButtonDown Then
                    DrawEdge( BitmapImage.Canvas.Handle, Dummy_Rect, BDR_SUNKENINNER, BF_RECT ) Else
                    If FMouseInButton Then DrawEdge( BitmapImage.Canvas.Handle, Dummy_Rect, BDR_RAISEDOUTER, BF_RECT );}
          End;

          // *** HeaderSettings ***

          HeaderSettings := Nil;

          If Parent Is TmxOutlookBarHeader Then
          Begin
               mxOutlookBarHeader := ( Parent As TmxOutlookBarHeader );
               If mxOutlookBarHeader.GetParentBar <> Nil Then
               Begin
                    If mxOutlookBarHeader.GetParentBar.CommonStyle Then
                    Begin
                         HeaderSettings := mxOutlookBarHeader.GetParentBar.HeaderSettings;
                         BitmapImage.Canvas.Font.Assign( mxOutlookBarHeader.GetParentBar.HeaderSettings.ButtonFont );
                    End
                    Else
                    Begin
                         HeaderSettings := mxOutlookBarHeader.HeaderSettings;

                         If mxOutlookBarHeader.CommonStyle Then
                              BitmapImage.Canvas.Font.Assign( mxOutlookBarHeader.HeaderSettings.ButtonFont ) Else
                              BitmapImage.Canvas.Font.Assign( Font );
                    End;
               End
               Else
                    If mxOutlookBarHeader.CommonStyle Then
                         BitmapImage.Canvas.Font.Assign( mxOutlookBarHeader.HeaderSettings.ButtonFont ) Else
                         BitmapImage.Canvas.Font.Assign( Font );
          End
          Else BitmapImage.Canvas.Font.Assign( Font );

          // *** Border ***

          If HeaderSettings = Nil Then
          Begin
               If FButtonDown Then
               Begin
                    If Assigned( FSmallImages ) Then
                         FSmallImages.Draw( BitmapImage.Canvas, Rect_Picture.Left + 1, Rect_Picture.Top + 1, FImageIndex );
                    DrawEdge( BitmapImage.Canvas.Handle, ARect, BDR_SUNKENINNER, BF_RECT );
               End
               Else
               Begin
                    If Assigned( FSmallImages ) Then
                         FSmallImages.Draw( BitmapImage.Canvas, Rect_Picture.Left, Rect_Picture.Top, FImageIndex );
                    If FMouseInButton Then DrawEdge( BitmapImage.Canvas.Handle, ARect, BDR_RAISEDOUTER, BF_RECT );
               End;

               ARect.Left := ARect.Right;
               ARect.Right := Width;
          End
          Else
          Begin
               Case HeaderSettings.ViewStyle Of
                    vsNormal:
                         Begin
                              If FButtonDown Then
                              Begin
                                   If Assigned( FSmallImages ) Then
                                        FSmallImages.Draw( BitmapImage.Canvas, Rect_Picture.Left + 1, Rect_Picture.Top + 1, FImageIndex );
                                   DrawEdge( BitmapImage.Canvas.Handle, ARect, BDR_SUNKENINNER, BF_RECT );
                              End
                              Else
                              Begin
                                   If Assigned( FSmallImages ) Then
                                        FSmallImages.Draw( BitmapImage.Canvas, Rect_Picture.Left, Rect_Picture.Top, FImageIndex );
                                   If FMouseInButton Then DrawEdge( BitmapImage.Canvas.Handle, ARect, BDR_RAISEDOUTER, BF_RECT );
                              End;
                         End;

                    vsAdvanced, vsBig:
                         Begin
                              If FButtonDown Then
                              Begin
                                   If Assigned( FSmallImages ) Then
                                        FSmallImages.Draw( BitmapImage.Canvas, Rect_Picture.Left + 1, Rect_Picture.Top + 1, FImageIndex );
                                   Rect_Picture := Bounds( 0, 0, Width, Height );
                                   DrawEdge( BitmapImage.Canvas.Handle, Rect_Picture, BDR_SUNKENINNER, BF_RECT );
                              End
                              Else
                              Begin
                                   If Assigned( FSmallImages ) Then
                                        FSmallImages.Draw( BitmapImage.Canvas, Rect_Picture.Left, Rect_Picture.Top, FImageIndex );
                                   Rect_Picture := Bounds( 0, 0, Width, Height );
                                   If FMouseInButton Then DrawEdge( BitmapImage.Canvas.Handle, Rect_Picture, BDR_RAISEDOUTER, BF_RECT );
                              End;
                         End;

                    vsWindowsXP, vsWindows2000:
                         Begin
                              Rect_Picture.Left := Rect_Picture.Left + 1;
                              Rect_Picture.Top := Rect_Picture.Top + 1;

                              If FButtonDown Or FMouseInButton Then
                              Begin
                                   Rect_SmallButton := Bounds( 0, 0, Width, Height );
                                   BitmapImage.Canvas.Brush.Color := HeaderSettings.XPSettings.Border;

                                   BitmapImage.Canvas.FrameRect( Rect_SmallButton );
                                   BitmapImage.Canvas.Brush.Color := HeaderSettings.XPSettings.Background;

                                   Inc( Rect_SmallButton.Left );
                                   Inc( Rect_SmallButton.Top );
                                   Dec( Rect_SmallButton.Right );
                                   Dec( Rect_SmallButton.Bottom );

                                   BitmapImage.Canvas.FillRect( Rect_SmallButton );

                                   // *** Draw Button Bitmap **

                                   If ( FSmallImages <> Nil ) And ( FImageIndex >= 0 ) Then
                                   Begin
                                        If Not FButtonDown Then
                                        Begin
                                             _BrushColor := BitmapImage.Canvas.Brush.Color;
                                             _BrushType := BitmapImage.Canvas.Brush.Style;

                                             If HeaderSettings.XPSettings.ButtonShadow Then
                                             Begin
                                                  BitmapImage.Canvas.Brush.Color := HeaderSettings.XPSettings.Shadow;
                                                  BitmapImage.Canvas.Brush.Style := bsSolid;

                                                  ShadowBitmap := TBitmap.Create;
                                                  ShadowBitmap.Width := FSmallImages.Width;
                                                  ShadowBitmap.Height := FSmallImages.Height;

                                                  FSmallImages.ImageType := itMask;
                                                  FSmallImages.Draw( ShadowBitmap.Canvas, Rect_Picture.Left, Rect_Picture.Top, FImageIndex );

                                                  DrawState( BitmapImage.Canvas.Handle, BitmapImage.Canvas.Brush.Handle, Nil,
                                                       Integer( ShadowBitmap.Handle ),
                                                       0,
                                                       Rect_Picture.Left,
                                                       Rect_Picture.Top,
                                                       0,
                                                       0,
                                                       DST_BITMAP Or DSS_MONO );

                                                  ShadowBitmap.Free;
                                             End;

                                             FSmallImages.ImageType := itImage;
                                             FSmallImages.Draw( BitmapImage.Canvas, Rect_Picture.Left - 1, Rect_Picture.Top - 1, FImageIndex );

                                             BitmapImage.Canvas.Brush.Color := _BrushColor;
                                             BitmapImage.Canvas.Brush.Style := _BrushType;
                                        End
                                        Else
                                        Begin
                                             FSmallImages.ImageType := itImage;
                                             FSmallImages.Draw( BitmapImage.Canvas, Rect_Picture.Left, Rect_Picture.Top, FImageIndex );
                                        End;
                                   End;
                              End
                              Else
                              Begin
                                   If Assigned( FSmallImages ) Then
                                   Begin
                                        FSmallImages.ImageType := itImage;
                                        FSmallImages.Draw( BitmapImage.Canvas, Rect_Picture.Left, Rect_Picture.Top, FImageIndex );
                                   End;
                              End;
                         End;
               End;

               If Assigned( SmallImages ) Then
               Begin
                    ARect.Left := ARect.Right;
                    ARect.Right := Width;
               End;
          End;

          // *** Caption ***

          Flags := DT_EXPANDTABS Or DT_BOTTOM Or DT_EDITCONTROL Or DT_NOCLIP Or Alignments[ taLeftJustify ];

{$IFDEF DELPHI4_UP}
          Flags := DrawTextBiDiModeFlags( Flags );
{$ENDIF}
          TextRect := ARect;
          TextRect.Left := TextRect.Left + 2;
{$WARNINGS OFF}
          TextSize := BitmapImage.Canvas.TextExtent( PChar( Caption ) );
{$WARNINGS ON}
          TextRect.Top := ( TextRect.Bottom - TextRect.Top - TextSize.CY ) Div 2;

// Calculate heigth of Caption, don't draw
{$WARNINGS OFF}
          TextSize.CY := DrawText( BitmapImage.Canvas.Handle, PChar( Caption ), -1, ARect, DT_CALCRECT );
{$WARNINGS ON}
// New Top
          TextRect.Top := TextRect.Top + ( TextRect.Bottom - TextRect.Top - TextSize.CY ) Div 2;

          If HeaderSettings <> Nil Then
          Begin
               If ( HeaderSettings.ViewStyle In [ vsBig, vsAdvanced ] ) And ( FButtonDown ) Then
               Begin
                    Inc( TextRect.Top );
                    Inc( TextRect.Left );
               End;
          End;

{$WARNINGS OFF}
          DrawText( BitmapImage.Canvas.Handle, PChar( Caption ), -1, TextRect, Flags );
{$WARNINGS ON}
     End;

     Canvas.CopyRect( Rect( 0, 0, Width, Height ), BitmapImage.Canvas, Rect( 0, 0, Width, Height ) );
     BitmapImage.Free;

     FocusEnabled := Focused;

{$IFNDEF DELPHI5_UP}
     If ( Parent Is TmxOutlookBarHeader ) And ( FocusEnabled ) Then
     Begin
          mxOutlookBarHeader := ( Parent As TmxOutlookBarHeader );

          If mxOutlookBarHeader.GetParentBar <> Nil Then
          Begin
               If mxOutlookBarHeader.GetParentBar.CommonStyle Then
                    FocusEnabled := mxOutlookBarHeader.GetParentBar.HeaderSettings.KeySupport Else
                    FocusEnabled := mxOutlookBarHeader.HeaderSettings.KeySupport;

               If FocusEnabled Then
                    FocusEnabled := mxOutlookBarHeader.GetParentBar.ActiveHeader = mxOutlookBarHeader;
          End;
     End;
{$ENDIF}

     If FocusEnabled And Focused And ( Not FMouseInButton ) Then
     Begin
          ARect := Bounds( 0, 0, Width, Height );
          InflateRect( ARect, -1, -1 );
          Canvas.Brush.Style := bsClear;
          Canvas.Pen.Style := psDot;
          Canvas.Rectangle( ARect.Left, ARect.Top, ARect.Right, ARect.Bottom );
     End;

{$IFDEF DELPHI4_UP}
     ControlState := ControlState - [ csCustomPaint ];
{$ELSE}
     D3_Image.Free;
{$ENDIF}
End;

// *************************************************************************************
// ** TOutlookButton.CMDialogChar, 4/20/01 2:55:25 PM
// *************************************************************************************

Procedure TOutlookButton.CMDialogChar( Var Message: TCMDialogChar );
Begin
     With Message Do

          If IsAccel( CharCode, Caption ) And

{$IFDEF DELPHI4_UP}
{$IFDEF DELPHI5_UP}
          CanFocus And
{$ELSE}
          MyCanFocus And
{$ENDIF}
{$ENDIF}

          ( Focused Or ( ( GetKeyState( VK_MENU ) And $8000 ) <> 0 ) ) Then Click Else Inherited;
End;

// *************************************************************************************
// ** TOutlookButton.SetButtonStyle, 4/12/01 4:09:56 PM
// *************************************************************************************

Procedure TOutlookButton.SetButtonStyle( Const Value: TButtonStyle );
Begin
     If FButtonStyle <> Value Then
     Begin
          FButtonStyle := Value;
          Repaint;
     End;
End;

// *************************************************************************************
// ** TOutlookButton.KeyDown, 5/16/01 10:10:26 AM
// *************************************************************************************

Procedure TOutlookButton.KeyDown( Var Key: Word; Shift: TShiftState );
Begin
     Inherited KeyDown( Key, Shift );

     If ( Key In [ VK_RETURN ] ) Then
     Begin
          Case Key Of
               VK_RETURN: Self.Click;
          End;
     End;
End;

// *************************************************************************************
// *************************************************************************************
// *************************************************************************************
// ** Constructor TGradient.Create;
// *************************************************************************************
// *************************************************************************************
// *************************************************************************************

Constructor TGradient.Create;
Begin
     Inherited Create;

     FStartColor := clBlack;
     FEndColor := clBlue;
     FGradientType := gtt2b;
     FBackStyle := bsNormal;
End;

// *************************************************************************************
// ** TGradient.SetGradientType, 4/13/01 5:39:43 PM
// *************************************************************************************

Procedure TGradient.SetGradientType( Value: TGradientType );
Begin
     If FGradientType <> Value Then
     Begin
          FGradientType := Value;
          Change;
     End;
End;

// *************************************************************************************
// ** TGradient.SetBackStyle, 4/13/01 5:43:55 PM
// *************************************************************************************

Procedure TGradient.SetBackStyle( Value: TBackStyle );
Begin
     If FBackStyle <> Value Then
     Begin
          FBackStyle := Value;
          Change;
     End;
End;

// *************************************************************************************
// ** Procedure TGradient.AssignTo;
// *************************************************************************************

Procedure TGradient.AssignTo( Dest: TPersistent );
Begin
     If Dest Is TGradient Then
          With TGradient( Dest ) Do
          Begin
               FStartColor := Self.FStartColor;
               FEndColor := Self.FEndColor;
               FGradientType := Self.FGradientType;
               FBackStyle := Self.FBackStyle;

               Change;
          End
     Else Inherited AssignTo( Dest );
End;

// *************************************************************************************
// ** TGradient.SetColor, 4/13/01 5:36:40 PM
// *************************************************************************************

Procedure TGradient.SetColor( Index: Integer; Value: TColor );
Begin
     Case Index Of
          1: If FStartColor <> Value Then FStartColor := Value;
          2: If FEndColor <> Value Then FEndColor := Value;
     End;

     Change;
End;

// *************************************************************************************
// ** TGradient.Change, 4/11/01 1:37:48 PM
// *************************************************************************************

Procedure TGradient.Change;
Begin
     If Assigned( FOnChange ) Then FOnChange( Self );
End;

// *************************************************************************************
// ** TGradient.PaintGradient, 4/13/01 5:45:50 PM
// *************************************************************************************

Procedure TGradient.PaintGradient( ACanvas: TCanvas; ARect: TRect );
Var
     StartColor_R: Integer;
     StartColor_G: Integer;
     StartColor_B: Integer;
     EndColor_R: Integer;
     EndColor_G: Integer;
     EndColor_B: Integer;
     DestRect: TRect;
     I: Integer;
     H: Integer;
     R, G, B: Byte;

Begin
     If ( ARect.Top >= ARect.Bottom ) Or ( ARect.Left >= ARect.Right ) Then Exit;

     StartColor_R := FStartColor And $000000FF;
     StartColor_G := ( FStartColor Shr 8 ) And $000000FF;
     StartColor_B := ( FStartColor Shr 16 ) And $000000FF;

     EndColor_R := ( FEndColor And $000000FF ) - StartColor_R;
     EndColor_G := ( ( FEndColor Shr 8 ) And $000000FF ) - StartColor_G;
     EndColor_B := ( ( FEndColor Shr 16 ) And $000000FF ) - StartColor_B;

     Case FGradientType Of

          gtl2r:
               Begin
                    DestRect.Top := ARect.Top;
                    DestRect.Bottom := ARect.Bottom;

                    For I := 0 To 255 Do
                    Begin
                         DestRect.Left := ARect.Left + MulDiv( I, ARect.Right - ARect.Left, 256 );
                         DestRect.Right := ARect.Left + MulDiv( I + 1, ARect.Right - ARect.Left, 256 );

                         R := StartColor_R + MulDiv( I, EndColor_R, 255 );
                         G := StartColor_G + MulDiv( I, EndColor_G, 255 );
                         B := StartColor_B + MulDiv( I, EndColor_B, 255 );

                         ACanvas.Brush.Color := RGB( R, G, B );
                         ACanvas.FillRect( DestRect );
                    End;
               End;

          gtt2b:
               Begin
                    DestRect.Left := ARect.Left;
                    DestRect.Right := ARect.Right - ARect.Left;

                    For I := 0 To 255 Do
                    Begin
                         DestRect.Top := ARect.Top + MulDiv( I, ARect.Bottom - ARect.Top, 256 );
                         DestRect.Bottom := ARect.Top + MulDiv( I + 1, ARect.Bottom - ARect.Top, 256 );

                         R := StartColor_R + MulDiv( I, EndColor_R, 255 );
                         G := StartColor_G + MulDiv( I, EndColor_G, 255 );
                         B := StartColor_B + MulDiv( I, EndColor_B, 255 );

                         ACanvas.Brush.Color := RGB( R, G, B );
                         ACanvas.FillRect( DestRect );
                    End;

               End;

          gttb2c:
               Begin
                    H := ( ARect.Bottom - ARect.Top ) Div 2;

                    DestRect.Left := ARect.Left;
                    DestRect.Right := ARect.Right - ARect.Left;

                    For I := 0 To H Do
                    Begin
                         DestRect.Top := ARect.Top + MulDiv( I, H, H );
                         DestRect.Bottom := ARect.Top + MulDiv( I + 1, H, H );

                         R := StartColor_R + MulDiv( I, EndColor_R, H );
                         G := StartColor_G + MulDiv( I, EndColor_G, H );
                         B := StartColor_B + MulDiv( I, EndColor_B, H );

                         ACanvas.Brush.Color := RGB( R, G, B );
                         ACanvas.FillRect( DestRect );

                         DestRect.Top := ARect.Bottom - ( MulDiv( I, H, H ) );
                         DestRect.Bottom := ARect.Top + ( MulDiv( I + 1, H, H ) );

                         ACanvas.FillRect( DestRect );
                    End;

               End;

          gts2c:
               Begin
                    H := ( ARect.Right - ARect.Left ) Div 2;

                    DestRect.Top := ARect.Top;
                    DestRect.Bottom := ARect.Bottom;

                    For I := 0 To H Do
                    Begin
                         DestRect.Left := ARect.Left + MulDiv( I, H, H );
                         DestRect.Right := ARect.Left + MulDiv( I + 1, H, H );

                         R := StartColor_R + MulDiv( I, EndColor_R, H );
                         G := StartColor_G + MulDiv( I, EndColor_G, H );
                         B := StartColor_B + MulDiv( I, EndColor_B, H );

                         ACanvas.Brush.Color := RGB( R, G, B );
                         ACanvas.FillRect( DestRect );

                         DestRect.Left := ARect.Left + ( ARect.Right - ARect.Left ) - ( MulDiv( I, H, H ) );
                         DestRect.Right := ARect.Left + ( ARect.Right - ARect.Left ) - ( MulDiv( I + 1, H, H ) );

                         ACanvas.FillRect( DestRect );
                    End;
               End;
     End;
End;

// *************************************************************************************
// *************************************************************************************
// *************************************************************************************
// ** Constructor TmxXPSettings.Create;
// *************************************************************************************
// *************************************************************************************
// *************************************************************************************

Constructor TmxXPSettings.Create;
Begin
     Inherited Create;
     FBorder := clNavy;
     FBackground := TColor( $D8ACB0 );
     FButtonShadow := True;
End;

Procedure TmxXPSettings.SetBorder( AValue: TColor );
Begin
     If AValue <> FBorder Then
     Begin
          FBorder := AValue;
          Change;
     End;
End;

Procedure TmxXPSettings.SetShadow( AValue: TColor );
Begin
     If AValue <> FShadow Then
     Begin
          FShadow := AValue;
          Change;
     End;
End;

Procedure TmxXPSettings.SetBackground( AValue: TColor );
Begin
     If AValue <> FBackground Then
     Begin
          FBackground := AValue;
          Change;
     End;
End;

Procedure TmxXPSettings.Change;
Begin
     If Assigned( FOnChange ) Then FOnChange( Self );
End;

Procedure TmxXPSettings.SetButtonShadow( AValue: Boolean );
Begin
     If AValue <> FButtonShadow Then
     Begin
          FButtonShadow := AValue;
          Change;
     End;
End;

// *************************************************************************************
// *************************************************************************************
// *************************************************************************************
// ** Constructor THeaderSettings.Create;
// *************************************************************************************
// *************************************************************************************
// *************************************************************************************

Constructor THeaderSettings.Create( DefaultFont: TFont );
Begin
     Inherited Create;

     FAlignment := taCenter;

     FBevelInner := bvNone;
     FBevelOuter := bvRaised;
     FBevelWidth := 1;

     FHeaderColor := clBtnFace;
     FAutoScroll := TRUE;

     FHeaderFont := TFont.Create;
     FHeaderFont.Assign( DefaultFont );

     FButtonFont := TFont.Create;
     FButtonFont.Assign( DefaultFont );

     FHighLightFont := TFont.Create;
     FHighLightFont.Assign( DefaultFont );

     FButtonSizes[ 1 ] := 60;
     FButtonSizes[ 2 ] := 60;
     FButtonSizes[ 3 ] := 20;

     FKeySupport := FALSE;

{$IFDEF DELPHI4_UP}
     FLayout := glGlyphLeft;
{$ENDIF}
     FButtonStyle := bsLarge;

     FViewStyle := vsNormal;

     FXPSettings := TmxXPSettings.Create;
     FXPSettings.OnChange := OnChange;
End;

// *************************************************************************************
// ** Destructor THeaderSettings.Destroy;
// *************************************************************************************

Destructor THeaderSettings.Destroy;
Begin
     FHeaderFont.Free;
     FHighLightFont.Free;
     FButtonFont.Free;
     FXPSettings.Free;
     Inherited Destroy;
End;

// *************************************************************************************
// ** THeaderSettings.SetButtonStyle, 4/26/01 2:02:34 PM
// *************************************************************************************

Procedure THeaderSettings.SetButtonStyle( Const Value: TButtonStyle );
Begin
     If FButtonStyle <> Value Then
     Begin
          FButtonStyle := Value;
          Change;
     End;
End;

// *************************************************************************************
// ** THeaderSettings.SetButtonSize, 4/26/01 1:51:14 PM
// *************************************************************************************

Procedure THeaderSettings.SetButtonSize( Index: Integer; Value: Integer );
Begin
     If Not ( Index In [ 1..3 ] ) Then Exit;

     If FButtonSizes[ Index ] <> Value Then
     Begin
          FButtonSizes[ Index ] := Value;
          Change;
     End;
End;

// *************************************************************************************
// * THeaderSettings.SetViewStyle
// * 19-Jun-2002
// * Arguments: AValue: TViewStyle
// * Result:    None
// *************************************************************************************

Procedure THeaderSettings.SetViewStyle( AValue: TViewStyle );
Begin
     If FViewStyle <> AValue Then
     Begin
          FViewStyle := AValue;
          Change;
     End;
End;

// *************************************************************************************
// ** THeaderSettings.GetButtonSize, 4/26/01 1:51:17 PM
// *************************************************************************************

Function THeaderSettings.GetButtonSize( Index: Integer ): Integer;
Begin
     Result := -1;
     If Not ( Index In [ 1..3 ] ) Then Exit;

     Result := FButtonSizes[ Index ];
End;

// *************************************************************************************
// ** THeaderSettings.SetLayout, 4/11/01 2:47:57 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure THeaderSettings.SetLayout( Value: TGlyphLayout );
Begin
     If FLayout <> Value Then
     Begin
          FLayout := Value;
          Change;
     End;
End;

{$ENDIF}

// *************************************************************************************
// ** THeaderSettings.SetAutoScroll, 4/25/01 2:14:26 PM
// *************************************************************************************

Procedure THeaderSettings.SetAutoScroll( Value: Boolean );
Begin
     If FAutoScroll <> Value Then
     Begin
          FAutoScroll := Value;
          Change;
     End;
End;

// *************************************************************************************
// ** THeaderSettings.SetKeySupport, 5/16/01 9:38:43 AM
// *************************************************************************************

Procedure THeaderSettings.SetKeySupport( Value: Boolean );
Begin
     If FKeySupport <> Value Then
     Begin
          FKeySupport := Value;
          Change;
     End;
End;

// *************************************************************************************
// ** Procedure THeaderSettings.AssignTo;
// *************************************************************************************

Procedure THeaderSettings.AssignTo( Dest: TPersistent );
Begin
     If Dest Is THeaderSettings Then
          With THeaderSettings( Dest ) Do
          Begin
               FAlignment := Self.FAlignment;
               FBevelInner := Self.FBevelInner;
               FBevelOuter := Self.FBevelOuter;
               FBevelWidth := Self.FBevelWidth;
               FHeaderColor := Self.FHeaderColor;
               FHeaderFont.Assign( Self.FHeaderFont );
               FHighLightFont.Assign( Self.FHighLightFont );

               Change;
          End
     Else Inherited AssignTo( Dest );
End;

// *************************************************************************************
// ** THeaderSettings.SetHeaderColor, 4/10/01 9:26:07 AM
// *************************************************************************************

Procedure THeaderSettings.SetHeaderColor( Value: TColor );
Begin
     If FHeaderColor <> Value Then
     Begin
          FHeaderColor := Value;
          Change;
     End;
End;

// *************************************************************************************
// ** THeaderSettings.SetHeaderFont, 4/10/01 9:48:02 AM
// *************************************************************************************

Procedure THeaderSettings.SetHeaderFont( Value: TFont );
Begin
     If FHeaderFont <> Value Then
     Begin
          FHeaderFont.Assign( Value );
          Change;
     End;
End;

// *************************************************************************************
// ** THeaderSettings.SetBevelOuter, 4/10/01 9:17:24 AM
// *************************************************************************************

Procedure THeaderSettings.SetBevelOuter( Value: TPanelBevel );
Begin
     If FBevelOuter <> Value Then
     Begin
          FBevelOuter := Value;
          Change;
     End;
End;

// *************************************************************************************
// ** THeaderSettings.SetBevelWidth, 4/10/01 9:17:30 AM
// *************************************************************************************

Procedure THeaderSettings.SetBevelWidth( Value: TBevelWidth );
Begin
     If FBevelWidth <> Value Then
     Begin
          FBevelWidth := Value;
          Change;
     End;
End;

// *************************************************************************************
// ** THeaderSettings.SetBevelInner, 4/10/01 9:17:18 AM
// *************************************************************************************

Procedure THeaderSettings.SetBevelInner( Value: TPanelBevel );
Begin
     If FBevelInner <> Value Then
     Begin
          FBevelInner := Value;
          Change;
     End;
End;

// *************************************************************************************
// ** THeaderSettings.SetAlignment, 4/10/01 11:58:09 AM
// *************************************************************************************

Procedure THeaderSettings.SetAlignment( Value: TAlignment );
Begin
     If FAlignment <> Value Then
     Begin
          FAlignment := Value;
          Change;
     End;
End;

// *************************************************************************************
// ** THeaderSettings.SetHighLightFont, 4/11/01 1:37:48 PM
// *************************************************************************************

Procedure THeaderSettings.SetHighLightFont( Const Value: TFont );
Begin
     If FHighLightFont <> Value Then
     Begin
          FHighLightFont.Assign( Value );
          Change;
     End;
End;

// *************************************************************************************
// ** THeaderSettings.SetButtonFont, 10/12/01 8:27:23 AM
// *************************************************************************************

Procedure THeaderSettings.SetButtonFont( Const Value: TFont );
Begin
     If FButtonFont <> Value Then
     Begin
          FButtonFont.Assign( Value );
          Change;
     End;
End;

// *************************************************************************************
// ** THeaderSettings.Change, 4/11/01 1:37:48 PM
// *************************************************************************************

Procedure THeaderSettings.Change;
Begin
     If Assigned( FOnChange ) Then FOnChange( Self );
End;

// *************************************************************************************
// *************************************************************************************
// *************************************************************************************
// ** TScrollButton.Create, 4/26/01 12:02:57 PM
// *************************************************************************************
// *************************************************************************************
// *************************************************************************************

Constructor TScrollButton.Create( AOwner: TComponent );
Begin
     Inherited Create( AOwner );
     FArrowStyle := asUp;
     Glyph.LoadFromResourceName( HInstance, 'ARROWUP' );
     Width := GetSystemMetrics( SM_CXVSCROLL );
     Height := GetSystemMetrics( SM_CYVSCROLL );
     Transparent := FALSE;
     Height := 10;
     Width := 11;
     Visible := FALSE;
End;

// *************************************************************************************
// ** TScrollButton.CMDesignHitTest, 4/26/01 12:02:55 PM
// *************************************************************************************

Procedure TScrollButton.CMDesignHitTest( Var Msg: TCMDesignHitTest );
Begin
     If PtInRect( Rect( 0, 0, Width, Height ), SmallPointToPoint( Msg.Pos ) ) Then Msg.Result := 1;
End;

// *************************************************************************************
// ** TScrollButton.SetArrowStyle, 4/26/01 12:10:52 PM
// ************************************************************************************

Procedure TScrollButton.SetArrowStyle( Value: TArrowStyle );
Begin
     If Value <> FArrowStyle Then
     Begin
          FArrowStyle := Value;

          Case FArrowStyle Of
               asUp: Glyph.LoadFromResourceName( HInstance, 'ARROWUP' );
               asDown: Glyph.LoadFromResourceName( HInstance, 'ARROWDOWN' );
          End;
     End;
End;

// *************************************************************************************
// *************************************************************************************
// *************************************************************************************
// ** TmxOutlookBarHeader.Create, 4/5/01 1:17:27 PM
// *************************************************************************************
// *************************************************************************************
// *************************************************************************************

Constructor TmxOutlookBarHeader.Create( AOwner: TComponent );
Begin
     Inherited Create( AOwner );

     Text := Name;
     Color := clGray;
     ControlStyle := [ csAcceptsControls, csCaptureMouse, csDoubleClicks, csClickEvents, csOpaque ];
     Caption := '';

     FImageIndex := -1;

     TabStop := True;
     Visible := True;

     FHeaderSettings := THeaderSettings.Create( Font );
     FHeaderSettings.OnChange := DoSettingsChange;

     FGradient := TGradient.Create;
     FGradient.OnChange := DoSettingsChange;

     If ( AOwner Is TmxOutlookBar ) Then
     Begin
          If GetParentBar <> Nil Then
          Begin
               FHeaderSettings.FHeaderColor := GetParentBar.HeaderSettings.HeaderColor;
               FHeaderSettings.FHeaderFont.Assign( GetParentBar.HeaderSettings.HeaderFont );
               FHeaderSettings.FButtonFont.Assign( GetParentBar.HeaderSettings.ButtonFont );
          End;
     End;

     FCommonStyle := TRUE;

     FBitmap := TBitmap.Create;
     FBitmap.OnChange := DoSettingsChange;
     FBitmapCopy := bcSrcCopy;
     FMouseInHeader := FALSE;
     FButtonDown := FALSE;
{$IFDEF DELPHI4_UP}
     OnResize := OnHeaderResized;
{$ENDIF}

     FAutoSort := TRUE;
     FScrollUp := TScrollButton.Create( Self );
     With FScrollUp Do
     Begin
          Parent := Self;
          OnClick := DoSettingsChange;
          SetArrowStyle( asUp );
          BringToFront;
     End;

     FScrollDown := TScrollButton.Create( Self );
     With FScrollDown Do
     Begin
          Parent := Self;
          OnClick := DoSettingsChange;
          SetArrowStyle( asDown );
          BringToFront;
     End;

     FFirstVisibleButton := 0;
     FLastVisibleButton := 0;
     FFirstButtonTop := 5;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.Destroy, 4/5/01 1:22:47 PM
// *************************************************************************************

Destructor TmxOutlookBarHeader.Destroy;
Begin
     FHeaderSettings.Free;
     FGradient.Free;
     FBitmap.Free;
     FScrollUp.Free;
     FScrollDown.Free;
     Inherited Destroy;
End;

Procedure TmxOutlookBarHeader.Loaded;
Begin
     DoSettingsChange( FHeaderSettings );
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.CanFocus, 5/16/01 9:55:34 AM
// *************************************************************************************

{$IFDEF DELPHI4_UP}
{$IFDEF DELPHI5_UP}

Function TmxOutlookBarHeader.CanFocus: Boolean;
{$ELSE}

Function TmxOutlookBarHeader.MyCanFocus: Boolean;
{$ENDIF}
Var
     _CanFocus: Boolean;
Begin
{$IFDEF DELPHI5_UP}
     _CanFocus := Inherited CanFocus;
{$ELSE}
     _CanFocus := Self.CanFocus;
{$ENDIF}

     If GetParentBar <> Nil Then
     Begin
          If GetParentBar.CommonStyle Then
               _CanFocus := GetParentBar.HeaderSettings.KeySupport Else
               _CanFocus := FHeaderSettings.KeySupport;
     End;

     Result := _CanFocus;
End;

{$ENDIF}

// *************************************************************************************
// ** TmxOutlookBarHeader.DragOver, 5/4/01 11:30:11 AM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TmxOutlookBarHeader.DragOver( Source: TObject; X, Y: Integer; State: TDragState; Var Accept: Boolean );
Begin
     Inherited DragOver( Source, X, Y, State, Accept );
     Accept := False;

     If Source Is TOutlookButton Then
     Begin
          If GetParentBar = Nil Then Exit;
          If GetParentBar.ActiveHeader <> Self Then GetParentBar.ActiveHeader := Self;
          If ( Source As TOutlookButton ).Parent <> Self Then ( Source As TOutlookButton ).Parent := Self;
          Accept := True;
     End;
End;

{$ENDIF}

// *************************************************************************************
// ** TmxOutlookBarHeader.AdjustClientRect, 4/26/01 12:23:21 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TmxOutlookBarHeader.AdjustClientRect( Var Rect: TRect );
Begin
     Inherited AdjustClientRect( Rect );
     InflateRect( Rect, 0, -GetHeaderHeight );
     Rect.Bottom := Rect.Bottom + GetHeaderHeight;
End;

{$ENDIF}

// *************************************************************************************
// ** TmxOutlookBarHeader.GetHeaderHeight, 4/26/01 12:30:30 PM
// *************************************************************************************

Function TmxOutlookBarHeader.GetHeaderHeight: Integer;
Begin
     Result := DefaultHeaderHeight;

     If GetParentBar <> Nil Then
          Result := GetParentBar.HeaderHeight;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.AddButton, 4/17/01 4:55:38 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.AddButton( OutlookButton: TOutlookButton );
Begin
     OutlookButton.Parent := Self;

     If GetParentBar <> Nil Then
     Begin
          If GetParentBar.CommonStyle Then
               DoSettingsChange( GetParentBar.FHeaderSettings ) Else
               DoSettingsChange( FHeaderSettings );
     End
     Else DoSettingsChange( FHeaderSettings );
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.CreateNewOutlookButton, 4/17/01 4:55:28 PM
// *************************************************************************************

Function TmxOutlookBarHeader.CreateNewOutlookButton: TOutlookButton;
Begin
     Result := TOutlookButton.Create( Self );
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.CreateButton, 4/17/01 4:55:15 PM
// *************************************************************************************

Function TmxOutlookBarHeader.CreateButton( Caption: String ): TOutlookButton;
Var
     OutlookButton: TOutlookButton;
Begin
     OutlookButton := CreateNewOutlookButton;
     OutlookButton.Caption := Caption;
     OutlookButton.Parent := Self;

     If GetParentBar <> Nil Then
     Begin
          If GetParentBar.CommonStyle Then
               DoSettingsChange( GetParentBar.FHeaderSettings ) Else
               DoSettingsChange( FHeaderSettings );
     End
     Else DoSettingsChange( FHeaderSettings );

     Result := OutlookButton;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.DeleteButton, 4/17/01 4:55:04 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.DeleteButton( Index: Integer );
Var
     OutlookButton: TOutlookButton;
Begin
     If ( Index < 0 ) Or ( Index > GetButtonCount - 1 ) Then Exit;
     OutlookButton := GetChildByIndex( Index );
     OutlookButton.Free;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.Destroy, 4/5/01 1:22:47 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.DoSettingsChange( Sender: TObject );
Var
     I: Integer;
     Button: TOutlookButton;
     CanApplyChanges: Boolean;
Begin
     If ( Sender Is TScrollButton ) Then
     Begin
          If ( Sender As TScrollButton ) = FScrollUp Then
          Begin
               Dec( FFirstVisibleButton );
               If FFirstVisibleButton < 0 Then FFirstVisibleButton := 0;
               If Assigned( FOnScroll ) Then FOnScroll( Self );
               AutoSortButtons;
          End
          Else
               If ( Sender As TScrollButton ) = FScrollDown Then
               Begin
                    Inc( FFirstVisibleButton );
                    If FFirstVisibleButton > GetButtonCount - 1 Then
                         FFirstVisibleButton := GetButtonCount - 1;
                    If Assigned( FOnScroll ) Then FOnScroll( Self );
                    AutoSortButtons;
               End;
          Exit;
     End;

     If ( Sender Is THeaderSettings ) Then
     Begin
          CanApplyChanges := TRUE;

          If Sender = FHeaderSettings Then
          Begin
               If GetParentBar <> Nil Then
                    If GetParentBar.CommonStyle Then
                         CanApplyChanges := FALSE;
          End;

          If CanApplyChanges Then
               For I := 0 To GetButtonCount - 1 Do
               Begin
                    Button := GetButtonByIndex( I );
                    If Button = Nil Then Continue;
                    If Not Button.AutoSize Then Continue;

                    Case ( Sender As THeaderSettings ).ButtonStyle Of
                         bsLarge:
                              Begin
                                   Button.ButtonStyle := bsLarge;
                                   Button.Font.Assign( ( Sender As THeaderSettings ).ButtonFont );
                                   Button.FResizingEnabled := TRUE;
                                   Button.Height := ( Sender As THeaderSettings ).LargeHeight;

                                   If ( ( Sender As THeaderSettings ).ViewStyle In [ vsAdvanced, vsWindows2000 ] ) Then
                                   Begin
                                        Button.Left := 2;
                                        Button.Width := Width - 4;
                                   End
                                   Else
                                   Begin
                                        Button.Width := ( Sender As THeaderSettings ).LargeWidth;
                                        Button.Left := ( Width - Button.Width ) Div 2;
                                   End;

                                   Button.FResizingEnabled := FALSE;
                              End;
                         bsSmall:
                              Begin
                                   Button.ButtonStyle := bsSmall;
                                   Button.Font.Assign( ( Sender As THeaderSettings ).ButtonFont );
                                   Button.FResizingEnabled := TRUE;
                                   Button.Height := ( Sender As THeaderSettings ).SmallHeight;

                                   Button.Left := 2;
                                   Button.Width := ClientWidth - 4;

                                   Button.FResizingEnabled := FALSE;
                              End;
                    End;
               End;

          AutoSortButtons;
     End;

     Realign;
     Invalidate;

     For I := 0 To ControlCount - 1 Do
          If ( Controls[ I ] Is TOutlookButton ) Then
               ( Controls[ I ] As TOutlookButton ).Invalidate;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.Change, 4/12/01 8:03:12 AM
// *************************************************************************************

Procedure TmxOutlookBarHeader.Change;
Begin
     If Assigned( FOnChange ) Then FOnChange( Self );
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.SetAutoSort, 4/18/01 2:35:41 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.SetAutoSort( Value: Boolean );
Begin
     If FAutoSort <> Value Then
     Begin
          FAutoSort := Value;
          AutoSortButtons;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.SetFirstButtonTop, 6/18/01 8:14:15 AM
// *************************************************************************************

Procedure TmxOutlookBarHeader.SetFirstButtonTop( Value: Integer );
Begin
     If FFirstButtonTop <> Value Then
     Begin
          FFirstButtonTop := Value;
          AutoSortButtons;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.SetBitmapCopy, 4/12/01 8:31:31 AM
// *************************************************************************************

Procedure TmxOutlookBarHeader.SetBitmapCopy( Value: TBitmapCopy );
Var
     I: Integer;
Begin
     If FBitmapCopy <> Value Then
     Begin
          FBitmapCopy := Value;
          Invalidate;

          For I := 0 To ControlCount - 1 Do
               If ( Controls[ I ] Is TOutlookButton ) Then ( Controls[ I ] As TOutlookButton ).Invalidate;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.CMTextChanged, 4/10/01 3:21:22 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.CMTextChanged( Var Msg: TMessage );
Begin
     Inherited;
     Invalidate;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.CMFontChanged, 4/10/01 3:22:13 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.CMFontChanged( Var Msg: TMessage );
Begin
     Inherited;
     Invalidate;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.GetParentBar, 4/9/01 2:09:23 PM
// *************************************************************************************

Function TmxOutlookBarHeader.GetParentBar: TmxOutlookBar;
Begin
     Result := Nil;

     If Parent <> Nil Then
          If Parent Is TmxOutlookBar Then
               Result := ( Parent As TmxOutlookBar );
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.SetHeaderIndex, 4/9/01 1:54:34 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.SetHeaderIndex( Value: Integer );
Begin
     If TabOrder <> Value Then
     Begin
          TabOrder := Value;
          If GetParentBar <> Nil Then GetParentBar.SetHeaderSizes;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.SetBitmap, 4/10/01 4:01:29 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.SetBitmap( Const Value: TBitmap );
Begin
     FBitmap.Assign( Value );
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.CMColorChanged, 4/10/01 2:00:36 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.CMVisibleChanged( Var Message: TMessage );
Begin
     Inherited;

     If Visible Then
     Begin
          If Assigned( FOnShow ) Then FOnShow( Self );
     End
     Else
     Begin
          If Assigned( FOnHide ) Then FOnHide( Self );
     End;

     If GetParentBar <> Nil Then GetParentBar.Invalidate;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.CMColorChanged, 4/10/01 2:00:36 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.CMColorChanged( Var Message: TMessage );
Begin
     Inherited;
     RecreateWnd;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.CheckChild, 4/17/01 4:02:05 PM
// *************************************************************************************

Function TmxOutlookBarHeader.CheckChild( Child: TControl ): Boolean;
Begin
     Result := ( Child <> Nil ) And ( Child Is TOutlookButton );
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.GetChild, 4/17/01 4:24:17 PM
// *************************************************************************************

Function TmxOutlookBarHeader.GetChild( Child: TControl ): TOutlookButton;
Begin
     If CheckChild( Child ) Then Result := ( Child As TOutlookButton ) Else Result := Nil;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.GetChildByIndex, 4/9/01 12:25:20 PM
// *************************************************************************************

Function TmxOutlookBarHeader.GetChildByIndex( Index: Integer ): TOutlookButton;
Var
     I: Integer;
Begin
     Result := Nil;

     For I := 0 To ControlCount - 1 Do
     Begin
          If CheckChild( Controls[ I ] ) Then
          Begin
               If GetChild( Controls[ I ] ).ButtonIndex = Index Then
                    Result := GetChild( Controls[ I ] );
          End
          Else If ( Controls[ I ] Is TWinControl ) Then Inc( Index );
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.GetButtonByIndex, 4/17/01 4:25:34 PM
// *************************************************************************************

Function TmxOutlookBarHeader.GetButtonByIndex( Index: Integer ): TOutlookButton;
Begin
     Result := Nil;
     If ( Index < 0 ) Or ( Index > GetButtonCount - 1 ) Then Exit;

     Result := GetChildByIndex( Index );
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.GetButtonCount, 4/17/01 4:01:34 PM
// *************************************************************************************

Function TmxOutlookBarHeader.GetButtonCount: Integer;
Var
     I: Integer;
Begin
     Result := 0;
     For I := 0 To ControlCount - 1 Do
     Begin
          If CheckChild( Controls[ I ] ) Then Inc( Result );
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.Notification, 4/17/01 5:01:39 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.Notification( AComponent: TComponent; Operation: TOperation );
Begin
     Inherited Notification( AComponent, Operation );

     If Operation = opInsert Then
     Begin
     End;

     If Operation = opRemove Then
     Begin
          If AComponent Is TOutlookButton Then Invalidate;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.SortButtons, 4/17/01 3:59:17 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.InternalSortButtons;
Var
     I: Integer;
     X: Integer;
     OutlookButton: TOutlookButton;
     CanSort: Boolean;
Begin
     CanSort := TRUE;

     If Assigned( FOnCanSort ) Then FOnCanSort( Self, CanSort );

     If Not CanSort Then Exit;
     If Not ( Parent Is TmxOutlookBar ) Then Exit;

     X := GetHeaderHeight + FFirstButtonTop;

     If X < FScrollUp.Top + FScrollUp.Height Then X := FScrollUp.Top + FScrollUp.Height + 1;

     For I := 0 To GetButtonCount - 1 Do
     Begin
          OutlookButton := GetButtonByIndex( I );
          If OutlookButton = Nil Then Continue;

          If ( OutlookButton.Visible ) Or ( csDesigning In OutlookButton.ComponentState ) Then
               If I >= FFirstVisibleButton Then
               Begin
                    If OutlookButton.ButtonStyle = bsLarge Then
                         OutlookButton.Left := ( Width - OutlookButton.Width ) Div 2 Else
                         If OutlookButton.Left <> 2 Then OutlookButton.Left := 2;

                    If ( X + OutlookButton.Height ) <= ( Height - FScrollDown.Height ) Then
                    Begin
                         OutlookButton.Top := X;
                         FLastVisibleButton := I;
                    End
                    Else OutlookButton.Top := X + 1000;

                    Inc( X, OutlookButton.Height + 2 );
               End
               Else OutlookButton.Top := -500;

     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.SortButtons, 4/25/01 1:55:26 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.SortButtons;
Begin
     If Assigned( FOnSort ) Then FOnSort( Self );
     InternalSortButtons;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.AutoSortButtons, 4/26/01 1:36:08 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.AutoSortButtons;
Begin
     If FAutoSort Then SortButtons;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.GetHeaderIndex, 4/9/01 2:04:38 PM
// *************************************************************************************

Function TmxOutlookBarHeader.GetHeaderIndex: Integer;
Begin
     Result := TabOrder;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.PaintTileBackground, 4/11/01 12:59:20 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.PaintTileBackground( ACanvas: TCanvas; Rect: TRect );
Var
     X, Y, W, H: LongInt;
     BitmapCopy: DWORD;
Begin
     W := FBitmap.Width;
     H := FBitmap.Height;
     Y := Rect.Top;

     Case FBitmapCopy Of
          bcMergeCopy: BitmapCopy := MergeCopy;
          bcMergePaint: BitmapCopy := MergePaint;
          bcSrcCopy: BitmapCopy := SrcCopy;
          bcSrcErase: BitmapCopy := SrcErase;
          bcSrcPaint: BitmapCopy := SrcPaint;
     Else BitmapCopy := SrcCopy;
     End;

     While Y < Height Do
     Begin
          X := Rect.Left;
          While X < Width Do
          Begin
               BitBlt( ACanvas.Handle, X, Y, W, H, FBitmap.Canvas.Handle, 0, 0, BitmapCopy );
               Inc( X, W );
          End;
          Inc( Y, H );
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.CMDialogChar, 4/26/01 10:10:56 AM
// *************************************************************************************

Procedure TmxOutlookBarHeader.CMDialogChar( Var Message: TCMDialogChar );
Begin
     With Message Do
          If IsAccel( CharCode, Caption ) And

{$IFDEF DELPHI4_UP}
{$IFDEF DELPHI5_UP}
          CanFocus And
{$ELSE}
          MyCanFocus And
{$ENDIF}
{$ENDIF}
          ( Focused Or ( ( GetKeyState( VK_MENU ) And $8000 ) <> 0 ) ) Then
          Begin
               If GetParentBar <> Nil Then
                    If GetParentBar.ActiveHeader <> Self Then
                         GetParentBar.ChangeHeader( Self );
          End
          Else Inherited;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.SetCommonStyle, 10/12/01 8:51:02 AM
// *************************************************************************************

Procedure TmxOutlookBarHeader.SetCommonStyle( Value: Boolean );
Var
     X: Integer;
     Button: TOutlookButton;
Begin
     If FCommonStyle <> Value Then
     Begin
          FCommonStyle := Value;
          Invalidate;

          For X := 0 To GetButtonCount - 1 Do
          Begin
               Button := GetButtonByIndex( X );
               If Button = Nil Then Continue;
               Button.Invalidate;
          End;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.Paint, 4/11/01 12:59:26 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.Paint;
Var
     ARect: TRect;
     TexteRect: TRect;
     FontHeight: Integer;
     TopColor, BottomColor: TColor;
     Flags: Longint;
     GlyphX: Integer;
     GlyphY: Integer;

     ScrollUpNeed: Boolean;
     ScrollDownNeed: Boolean;
     Automatic: Boolean;

     _HeaderSettings: THeaderSettings;
     _MouseInControl: TmxOutlookBarHeader;
     _Flat: Boolean;
     _Enabled: Boolean;
     _HasParent: Boolean;
     _BevelSize: Integer;
     _HasGlyph: Boolean;
     _ButtonDown: Boolean;

     FocusEnabled: Boolean;

     BitmapImage: TBitmap;

     Procedure AdjustColors( Bevel: TPanelBevel );
     Begin
          TopColor := clBtnHighlight;
          If Bevel = bvLowered Then TopColor := clBtnShadow;
          BottomColor := clBtnShadow;
          If Bevel = bvLowered Then BottomColor := clBtnHighlight;
     End;

Begin
{$IFDEF DELPHI4_UP}
     ControlState := ControlState + [ csCustomPaint ];
{$ENDIF}

     _BevelSize := 0;
     _HasParent := TRUE;
     _MouseInControl := Nil;
     _ButtonDown := FALSE;
     _Flat := FALSE;
     _Enabled := TRUE;
     _HeaderSettings := FHeaderSettings;

     If GetParentBar <> Nil Then
     Begin
          _MouseInControl := GetParentBar.MouseInControl;
          _ButtonDown := GetParentBar.ButtonDown;

          If GetParentBar.CommonStyle Then _HeaderSettings := GetParentBar.HeaderSettings;

          _Flat := GetParentBar.Flat;
          _Enabled := GetParentBar.Enabled;
     End;

     // *** Create memory bitmap ***

     BitmapImage := TBitmap.Create;
     BitmapImage.Width := Width;
     BitmapImage.Height := Height;

     // *** Header Area ***

     ARect := GetClientRect;
     ARect.Bottom := ARect.Top + GetHeaderHeight;

     If ( Not _Flat ) Or ( _MouseInControl = Self ) Then
     Begin
          If FButtonDown And _ButtonDown Then
          Begin
               Inc( _BevelSize, 2 );

               AdjustColors( bvNone );
               Frame3D( BitmapImage.Canvas, ARect, TopColor, BottomColor, 1 );

{$IFDEF DELPHI4_UP}
               Frame3D( BitmapImage.Canvas, ARect, Color, Color, BorderWidth );
{$ELSE}
               Frame3D( BitmapImage.Canvas, ARect, Color, Color, 1 );
{$ENDIF}

               AdjustColors( bvLowered );
               Frame3D( BitmapImage.Canvas, ARect, TopColor, BottomColor, 1 );
          End
          Else
               If ( Not FButtonDown ) Or ( Not _ButtonDown ) Then
               Begin
                    If _HeaderSettings.BevelOuter <> bvNone Then
                    Begin
{$IFDEF DELPHI4_UP}
                         Inc( _BevelSize, BevelWidth );
{$ELSE}
                         Inc( _BevelSize, 1 );
{$ENDIF}
                         AdjustColors( _HeaderSettings.BevelOuter );
                         Frame3D( BitmapImage.Canvas, ARect, TopColor, BottomColor, _HeaderSettings.BevelWidth );
                    End;

{$IFDEF DELPHI4_UP}
                    Frame3D( BitmapImage.Canvas, ARect, Color, Color, BorderWidth );
{$ELSE}
                    Frame3D( BitmapImage.Canvas, ARect, Color, Color, 1 );
{$ENDIF}
                    If _HeaderSettings.BevelInner <> bvNone Then
                    Begin
{$IFDEF DELPHI4_UP}
                         Inc( _BevelSize, BevelWidth );
{$ELSE}
                         Inc( _BevelSize, 1 );
{$ENDIF}
                         AdjustColors( _HeaderSettings.BevelInner );
                         Frame3D( BitmapImage.Canvas, ARect, TopColor, BottomColor, HeaderSettings.BevelWidth );
                    End;
               End;
     End
     Else
     Begin
          Dec( ARect.Bottom );
          BitmapImage.Canvas.Brush.Style := bsClear;
          BitmapImage.Canvas.Brush.Color := clBtnFace;
          BitmapImage.Canvas.MoveTo( ARect.Left, ARect.Bottom );
          BitmapImage.Canvas.LineTo( ARect.Right, ARect.Bottom );
     End;

     BitmapImage.Canvas.Brush.Color := _HeaderSettings.HeaderColor;
     BitmapImage.Canvas.FillRect( ARect );

     // *** Draw Glyph ***

     _HasGlyph := FALSE;
     GlyphX := 0;
     GlyphY := 0;

{$IFDEF DELPHI4_UP}

     If _HasParent Then
     Begin
          If ( GetParentBar.Images <> Nil ) And ( FImageIndex >= 0 ) Then
          Begin
               Case _HeaderSettings.Layout Of
                    glGlyphLeft: GlyphX := ARect.Left + 2;
                    glGlyphRight: GlyphX := ARect.Right - GetParentBar.Images.Width - 2;
                    glGlyphCenter: GlyphX := ( ARect.Right - ARect.Left - GetParentBar.Images.Width ) Div 2 + _BevelSize;
               Else GlyphX := ARect.Left + 2;
               End;
               GlyphY := ( ( ARect.Bottom - ARect.Top - GetParentBar.Images.Height ) Div 2 ) + _BevelSize;

               If Not Assigned( FOnDrawHeader ) Then
                    GetParentBar.Images.Draw( BitmapImage.Canvas, GlyphX, GlyphY, FImageIndex );

               _HasGlyph := TRUE;
          End;
     End;
{$ENDIF}

     If Assigned( FOnDrawHeader ) Then
     Begin
{$IFDEF DELPHI4_UP}
          FOnDrawHeader( Self, BitmapImage.Canvas, ARect, GlyphX, GlyphY, FImageIndex, Caption );
{$ELSE}
          FOnDrawHeader( Self, BitmapImage.Canvas, ARect, Caption );
{$ENDIF}
     End;

     // *** Draw focus ***

     FocusEnabled := Focused;

{$IFNDEF DELPHI5_UP}
     If ( GetParentBar <> Nil ) And ( FocusEnabled ) Then
     Begin
          If GetParentBar.CommonStyle Then
               FocusEnabled := GetParentBar.HeaderSettings.KeySupport Else
               FocusEnabled := FHeaderSettings.KeySupport;
     End;
{$ENDIF}

     If FocusEnabled Then
     Begin
          InflateRect( ARect, -1, -1 );
          BitmapImage.Canvas.Brush.Style := bsClear;
          BitmapImage.Canvas.Pen.Style := psDot;
          BitmapImage.Canvas.Rectangle( ARect.Left, ARect.Top, ARect.Right, ARect.Bottom );
     End;

     BitmapImage.Canvas.Pen.Style := psSolid;

     // *** Draw Caption ***

     If Not Assigned( FOnDrawHeader ) Then
     Begin
          BitmapImage.Canvas.Brush.Style := bsClear;
          BitmapImage.Canvas.Font := _HeaderSettings.HeaderFont;
          If _MouseInControl = Self Then BitmapImage.Canvas.Font.Assign( _HeaderSettings.HighLightFont );

          Flags := DT_EXPANDTABS Or DT_VCENTER Or Alignments[ _HeaderSettings.Alignment ];
{$WARNINGS OFF}
          DrawText( BitmapImage.Canvas.Handle, PChar( Caption ), -1, TexteRect, Flags Or DT_CALCRECT );
{$WARNINGS ON}
          FontHeight := TexteRect.Bottom - TexteRect.Top;

          With ARect Do
          Begin
               Top := ( ( Bottom + Top ) - FontHeight ) Div 2;
               Bottom := Top + FontHeight;

{$IFDEF DELPHI4_UP}
               If _HasGlyph Then
               Begin
                    Case _HeaderSettings.Layout Of
                         glGlyphLeft: If _HeaderSettings.Alignment = taLeftJustify Then Left := Left + GetParentBar.Images.Width + 3;
                         glGlyphRight: If _HeaderSettings.Alignment = taRightJustify Then Right := Right - GetParentBar.Images.Width - 4;
                    End;
               End;
{$ENDIF}

               If FButtonDown And _ButtonDown Then Left := Left + ( _BevelSize Div 2 );
          End;

          Flags := DT_EXPANDTABS Or DT_VCENTER Or Alignments[ _HeaderSettings.Alignment ];

{$IFDEF DELPHI4_UP}
          Flags := DrawTextBiDiModeFlags( Flags );
{$ENDIF}

{$WARNINGS OFF}
          If _Enabled Then DrawText( BitmapImage.Canvas.Handle, PChar( Caption ), -1, ARect, Flags ) Else
{$WARNINGS ON}
          Begin
               OffsetRect( ARect, 1, 1 );
               BitmapImage.Canvas.Font.Color := clBtnHighlight;
{$WARNINGS OFF}
               DrawText( BitmapImage.Canvas.Handle, PChar( Caption ), -1, ARect, Flags );
{$WARNINGS ON}
               OffsetRect( ARect, -1, -1 );
               BitmapImage.Canvas.Font.Color := clBtnShadow;
{$WARNINGS OFF}
               DrawText( BitmapImage.Canvas.Handle, PChar( Caption ), -1, ARect, Flags );
{$WARNINGS ON}
          End;
     End;

     // *** Draw Image in the Background ***

     If Height > GetHeaderHeight Then
     Begin
          ARect := GetClientRect;
          ARect.Top := ARect.Top + GetHeaderHeight;
          BitmapImage.Canvas.Brush.Color := Color;

          Case FGradient.BackStyle Of
               bsNormal:
                    Begin
                         If ( FBitmap.Height > 0 ) And ( FBitmap.Width > 0 ) Then
                              PaintTileBackground( BitmapImage.Canvas, ARect ) Else
                              BitmapImage.Canvas.FillRect( ARect );
                    End;
               bsGradient: FGradient.PaintGradient( BitmapImage.Canvas, ARect );
          End;
     End;

     // ** End of Paint ***

     Canvas.CopyRect( Rect( 0, 0, Width, Height ), BitmapImage.Canvas, Rect( 0, 0, Width, Height ) );
     BitmapImage.Free;

     // *** Scroll Button Positions ***

     ARect := GetClientRect;
     ARect.Top := ARect.Top + GetHeaderHeight;

     FScrollUp.Top := ARect.Top + 1;
     FScrollUp.Left := ARect.Right - FScrollUp.Width - 1;

     FScrollUp.Flat := _Flat;
     FScrollDown.Flat := _Flat;

     If ( ARect.Bottom <= ARect.Top ) Or ( ARect.Bottom - FScrollDown.Height - 1 <= GetHeaderHeight ) Then
     Begin
          FScrollUp.Top := GetHeaderHeight + 100;
          FScrollDown.Top := GetHeaderHeight + 100;
     End
     Else
     Begin
          FScrollDown.Top := ARect.Bottom - FScrollDown.Height - 1;
          FScrollDown.Left := ARect.Right - FScrollDown.Width - 1;
     End;

     Automatic := FALSE;
     ScrollUpNeed := IsUpButtonNeed;
     ScrollDownNeed := IsDownButtonNeed;

     If Not _HeaderSettings.AutoScroll Then
          If Assigned( FOnCheckScroll ) Then FOnCheckScroll( Self, ScrollUpNeed, ScrollDownNeed, Automatic );

     If _HeaderSettings.AutoScroll Or Automatic Then
     Begin
          FScrollUp.Visible := IsUpButtonNeed;
          FScrollDown.Visible := IsDownButtonNeed;
     End
     Else
     Begin
          FScrollUp.Visible := ScrollUpNeed;
          FScrollDown.Visible := ScrollDownNeed;
     End;

{$IFDEF DELPHI4_UP}
     ControlState := ControlState + [ csCustomPaint ];
{$ENDIF}

     // *** ReSort Buttons ***

     AutoSortButtons;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.IsUpButtonNeed, 4/25/01 4:41:04 PM
// *************************************************************************************

Function TmxOutlookBarHeader.IsUpButtonNeed: Boolean;
Begin
     If ( csDesigning In ComponentState ) Then
          Result := TRUE Else
          Result := FFirstVisibleButton > 0;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.IsDownButtonNeed, 4/25/01 4:41:01 PM
// *************************************************************************************

Function TmxOutlookBarHeader.IsDownButtonNeed: Boolean;
Var
     OutlookButton: TOutlookButton;
Begin
     Result := TRUE;

     If ( csDesigning In ComponentState ) Then Exit Else
     Begin
          OutlookButton := GetButtonByIndex( GetButtonCount - 1 );
          If OutlookButton <> Nil Then
               Result := OutlookButton.Top + OutlookButton.Height > Height Else //- GetParentBar.HeaderHeight ) Else
               Result := FALSE;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.SetImageIndex, 4/11/01 2:19:21 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.SetImageIndex( Value: TImageIndex );
Begin
     If FImageIndex <> Value Then
     Begin
          FImageIndex := Value;
          If GetParentBar <> Nil Then GetParentBar.Invalidate;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.CMMouseLeave, 4/10/01 1:11:24 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.CMMouseLeave( Var Message: TMessage );
Begin
     Inherited;
     FButtonDown := FALSE;
     //Invalidate;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.CMMouseEnter, 4/12/01 12:44:55 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.CMMouseEnter( Var Message: TMessage );
Var
     OutlookBarHeader: TmxOutlookBarHeader;
Begin
     Inherited;
     If GetParentBar <> Nil Then
     Begin
          If ( GetParentBar.MouseInControl <> Self ) And GetParentBar.Enabled And FMouseInHeader Then
          Begin
               OutlookBarHeader := GetParentBar.MouseInControl;
               GetParentBar.MouseInControl := Self;

               If OutlookBarHeader <> Nil Then OutlookBarHeader.Invalidate;
               Invalidate;
          End;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.WMSetFocus, 5/11/01 4:57:57 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.WMSetFocus( Var Message: TWMSetFocus );
Begin
     Inherited;
     Windows.SetFocus( TWinControl( Self ).Handle );
     Invalidate;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.WMKillFocus, 5/11/01 4:57:54 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.WMKillFocus( Var Message: TWMSetFocus );
Begin
     Invalidate;
     Inherited;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.MouseMove, 4/12/01 12:49:06 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.MouseMove( Shift: TShiftState; X, Y: Integer );
Begin
     Inherited MouseMove( Shift, X, Y );

     FMouseInHeader := Y < GetHeaderHeight;

     If GetParentBar <> Nil Then
     Begin
          If GetParentBar.Enabled Then
          Begin
               If ( GetParentBar.MouseInControl = Self ) And ( Not FMouseInHeader ) Then
               Begin
                    GetParentBar.MouseInControl := Nil;
                    Invalidate;
               End;

               If ( GetParentBar.MouseInControl = Nil ) And FMouseInHeader Then
               Begin
                    GetParentBar.MouseInControl := Self;
                    Invalidate;
               End;
          End;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHEader.CMDesignHitTest, 4/10/01 3:23:48 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.CMDesignHitTest( Var Msg: TCMDesignHitTest );
Begin
     If ( GetParentBar <> Nil ) And ( Msg.Keys = 1 ) Then
     Begin
          If GetParentBar.ActiveHeader <> Self Then
          Begin
               GetParentBar.ChangeHeader( Self );
               Exit;
          End;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.MouseDown, 4/12/01 1:29:14 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
Begin
     Inherited MouseDown( Button, Shift, X, Y );

     If FMouseInHeader And ( Button = mbLeft ) Then
     Begin
          FButtonDown := TRUE;

{$IFDEF DELPHI4_UP}
{$IFDEF DELPHI5_UP}
          If CanFocus Then SetFocus;
{$ELSE}
          If MyCanFocus Then SetFocus;
{$ENDIF}
{$ENDIF}

          Invalidate;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.MouseUp, 4/10/01 2:33:57 PM
// *************************************************************************************

Procedure TmxOutlookBarHeader.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
Var
     NeedRedraw: Boolean;
Begin
     Inherited MouseUp( Button, Shift, X, Y );

     NeedRedraw := FButtonDown;

     {If ( GetParentBar <> Nil ) And ( Button = mbLeft ) And FButtonDown Then
     Begin
          If ( GetParentBar.ActiveHeader <> Self ) And ( FMouseInHeader ) And
               ( Y > 0 ) And ( Y < GetHeaderHeight ) And
               ( X > 0 ) And ( X < Width ) Then
          Begin
               NeedRedraw := FALSE;
               GetParentBar.ChangeHeader( Self );
          End;
     End;}

     If ( FMouseInHeader ) And
          ( Y > 0 ) And ( Y < GetHeaderHeight ) And
          ( X > 0 ) And ( X < Width ) Then
     Begin
          If ( GetParentBar.ActiveHeader <> Self ) Then
          Begin
               NeedRedraw := FALSE;
               GetParentBar.ChangeHeader( Self )
          End
          Else
          Begin
               NeedRedraw := True;
               GetParentBar.ChangeHeader( GetParentBar.GetHeaderByIndex( GetParentBar.GetHeaderCount - 1 ) )
          End
     End;

     FButtonDown := FALSE;

     If NeedRedraw Then Repaint;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.OnHeaderResized, 4/11/01 10:44:23 AM
// *************************************************************************************

Procedure TmxOutlookBarHeader.OnHeaderResized( Sender: TObject );
Begin
     Inherited;
     Invalidate;
End;

// *************************************************************************************
// ** TmxOutlookBarHeader.KeyDown, 5/16/01 10:05:04 AM
// *************************************************************************************

Procedure TmxOutlookBarHeader.KeyDown( Var Key: Word; Shift: TShiftState );
Begin
     Inherited KeyDown( Key, Shift );

     If GetParentBar <> Nil Then
          If ( Key In [ VK_PRIOR, VK_NEXT, VK_RETURN ] ) Then
          Begin
               Case Key Of
                    VK_PRIOR: GetParentBar.ChangeHeader( GetParentBar.GetPrevHeader( GetParentBar.ActiveHeader ) );
                    VK_NEXT: GetParentBar.ChangeHeader( GetParentBar.GetNextHeader( GetParentBar.ActiveHeader ) );
                    VK_RETURN:
                         If ( GetParentBar.ActiveHeader <> Self ) Then
                         Begin
                              GetParentBar.ChangeHeader( Self );
                         End;
               End;
          End;
End;

// *************************************************************************************
// *************************************************************************************
// ** TmxOutlookBar.Create, 4/5/01 11:50:23 AM
// *************************************************************************************
// *************************************************************************************

Constructor TmxOutlookBar.Create( AOwner: TComponent );
Begin
     Inherited Create( AOwner );

     Align := alLeft;

{$IFNDEF Delphi6_up}
     FBevelInner := bvNone;
     FBevelOuter := bvLowered;
     FBevelWidth := 1;
{$ENDIF}

{$IFDEF DELPHI4_UP}
{$IFDEF Delphi6_Up}
     BorderWidth := 0;
{$ELSE}
     BorderWidth := 1;
{$ENDIF}
     OnResize := BarResized;
     OnCanResize := BarCanResize;
     Caption := 'mxOutlookBar';
{$ENDIF}

     Color := clbtnFace;
     ControlStyle := [ csCaptureMouse, csClickEvents, csOpaque ];
     FCommonStyle := TRUE;
     FFlat := FALSE;
{$IFDEF Delphi6_Up}
     FBorderStyle := bsSingle;
{$ELSE}
     FBorderStyle := bsNone;
{$ENDIF}
     FButtonDown := TRUE;
     FMouseInControl := Nil;
     FHeaderHeight := 22;
     TabStop := True;
     Width := 120;

     FHeaderSettings := THeaderSettings.Create( Font );
     FHeaderSettings.OnChange := DoSettingsChange;

     FImageChangeLink := TChangeLink.Create;
     FImageChangeLink.OnChange := ImageListChange;
     FScrolling := FALSE;

     FVersion := mxOutlookVersion;

{$IFDEF HEADERSCROLL}
     FScrollSpeed := 25;
{$ENDIF}
End;

// *************************************************************************************
// ** TmxOutlookBar.Destroy, 4/5/01 11:50:20 AM
// *************************************************************************************

Destructor TmxOutlookBar.Destroy;
Begin
     FImageChangeLink.Free;
     FHeaderSettings.Free;
     Inherited Destroy;
End;

// *************************************************************************************
// ** TmxOutlookBar.SetHeaderHeight, 4/26/01 12:33:16 PM
// *************************************************************************************

Procedure TmxOutlookBar.SetHeaderHeight( Value: Integer );
Var
     I: Integer;
Begin
     If Value <> FHeaderHeight Then
     Begin
          FHeaderHeight := Value;
          Invalidate;

          For I := 0 To GetHeaderCount - 1 Do
               GetHeaderByIndex( I ).AutoSortButtons;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.CMFontChanged, 4/10/01 3:23:03 PM
// *************************************************************************************

Procedure TmxOutlookBar.CMFontChanged( Var Msg: TMessage );
Begin
     Inherited;
     Invalidate;
End;

// *************************************************************************************
// ** TmxOutlookBar.ChangeHeader, 4/10/01 2:49:40 PM
// *************************************************************************************

Procedure TmxOutlookBar.ChangeHeader( OutlookSideBarHeader: TmxOutlookBarHeader );
Var
     _ParentForm: TCustomForm;
     DesignTime: Boolean;
     CanChange: Boolean;
     OldIndex: Integer;
     NewIndex: Integer;
     I: Integer;

{$IFDEF HEADERSCROLL}

     T: Integer;
     H: Integer;
     J: Integer;

     Function GetMaxHeight( Index, Top: Integer ): Integer;
     Begin
          Result := GetClientRect.Bottom - GetClientRect.Top;
          Result := Result - ( ( GetHeaderCount - Index ) * FHeaderHeight );
          Result := Result - Top;
     End;

{$ENDIF}

Begin
     _ParentForm := GetParentForm( Self );
     DesignTime := csDesigning In ComponentState;
     CanChange := True;

     If ( Not DesignTime ) And Assigned( FOnCanChange ) Then FOnCanChange( Self, OutlookSideBarHeader, CanChange );

     If CanChange Then
     Begin
          // *** Call Bar Onchange Event ***

          If FActiveHeader = Nil Then OldIndex := -1 Else OldIndex := FActiveHeader.HeaderIndex;
          If OutlookSideBarHeader = Nil Then NewIndex := -1 Else NewIndex := OutlookSideBarHeader.HeaderIndex;

          If ( Not DesignTime ) And Assigned( FOnChange ) And ( Not ( csDestroying In ComponentState ) ) Then
               FOnChange( Self, OldIndex, NewIndex );

          // *** Call Headers Onchange Events ***

          If Not DesignTime Then
          Begin
               For I := 0 To ControlCount - 1 Do
                    If CheckChild( Controls[ I ] ) Then
                         If GetChild( Controls[ I ] ).Parent = Self Then
                              GetChild( Controls[ I ] ).Change;

               // *** Header Scrolling *******

{$IFDEF HEADERSCROLL}

               If ( OutlookSideBarHeader <> Nil ) And ( FActiveHeader <> Nil ) Then
               Begin
                    FScrolling := TRUE;

                    OutlookSideBarHeader.SendToBack;
                    OutlookSideBarHeader.Height := FActiveHeader.Height;
                    OutlookSideBarHeader.Invalidate;

                    For H := 0 To GetHeaderCount - 1 Do
                    Begin
                         GetChildByIndex( H ).BringToFront;
                    End;

                    If FActiveHeader.HeaderIndex < OutlookSideBarHeader.HeaderIndex Then
                         T := OutlookSideBarHeader.Top Else
                         T := FActiveHeader.Top;

                    I := 1;
                    J := FScrollSpeed;

                    While I <= 370 Do
                    Begin
                         If FActiveHeader.HeaderIndex < OutlookSideBarHeader.HeaderIndex Then
                         Begin
                              OutlookSideBarHeader.Top := T - Round( ( FActiveHeader.Height / 390 ) * I );

                              For H := OutlookSideBarHeader.HeaderIndex - 1 Downto FActiveHeader.HeaderIndex + 1 Do
                              Begin
                                   GetChildByIndex( H ).Top := GetChildByIndex( H + 1 ).Top - FHeaderHeight;
                              End;
                         End
                         Else
                         Begin
                              FActiveHeader.Top := T + Round( ( FActiveHeader.Height / 390 ) * I );

                              For H := FActiveHeader.HeaderIndex - 1 Downto OutlookSideBarHeader.HeaderIndex + 1 Do
                              Begin
                                   GetChildByIndex( H ).Top := GetChildByIndex( H + 1 ).Top - FHeaderHeight;
                              End;
                         End;

                         Application.ProcessMessages;
                         Inc( I, J );
                    End;

                    FScrolling := FALSE;
               End;
{$ENDIF}
               // ************************************

               If OutlookSideBarHeader = Nil Then FActiveHeader := Nil Else
                    If OutlookSideBarHeader.Visible Then
                         FActiveHeader := OutlookSideBarHeader Else FActiveHeader := Nil;
          End
          Else FActiveHeader := OutlookSideBarHeader;

          If FMouseInControl <> Nil Then
          Begin
               FMouseInControl.Invalidate;
               FMouseInControl := Nil;
          End;

          If DesignTime And ( _ParentForm <> Nil ) Then
               If ( _ParentForm.Designer <> Nil ) And ( Not ( csLoading In ComponentState ) ) Then _ParentForm.Designer.Modified;

          If Not ( csDestroying In ComponentState ) Then SetHeaderSizes;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.SetActiveHeader, 4/9/01 11:11:23 AM
// *************************************************************************************

Procedure TmxOutlookBar.SetActiveHeader( Const Value: TmxOutlookBarHeader );
Begin
     If ( FActiveHeader <> Value ) Then
     Begin
          ChangeHeader( Value );
          Invalidate;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.CMColorChanged, 4/10/01 2:00:52 PM
// *************************************************************************************

Procedure TmxOutlookBar.CMColorChanged( Var Message: TMessage );
Begin
     Inherited;
     RecreateWnd;
End;

// *************************************************************************************
// ** TmxOutlookBar.CheckChild, 4/9/01 11:45:55 AM
// *************************************************************************************

Function TmxOutlookBar.CheckChild( Child: TControl ): Boolean;
Begin
     Result := ( Child <> Nil ) And ( Child Is TmxOutlookBarHeader );
End;

// *************************************************************************************
// ** TmxOutlookBar.GetChild, 4/9/01 11:47:27 AM
// *************************************************************************************

Function TmxOutlookBar.GetChild( Child: TControl ): TmxOutlookBarHeader;
Begin
     If CheckChild( Child ) Then Result := ( Child As TmxOutlookBarHeader ) Else Result := Nil;
End;

// *************************************************************************************
// ** TmxOutlookBar.GetChildByIndex, 4/9/01 12:25:20 PM
// *************************************************************************************

Function TmxOutlookBar.GetChildByIndex( Index: Integer ): TmxOutlookBarHeader;
Var
     I: Integer;
Begin
     Result := Nil;

     For I := 0 To ControlCount - 1 Do
     Begin
          If CheckChild( Controls[ I ] ) Then
               If GetChild( Controls[ I ] ).HeaderIndex = Index Then
                    Result := GetChild( Controls[ I ] );
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.GetHeaderCount, 4/9/01 11:52:17 AM
// *************************************************************************************

Function TmxOutlookBar.GetHeaderCount: Integer;
Var
     I: Integer;
Begin
     Result := 0;
     For I := 0 To ControlCount - 1 Do
     Begin
          If CheckChild( Controls[ I ] ) Then Inc( Result );
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.GetUnVisibleHeaderCountToIndex, 4/11/01 10:37:38 AM
// *************************************************************************************

Function TmxOutlookBar.GetUnVisibleHeaderCountToIndex( Index: Integer ): Integer;
Var
     I: Integer;
Begin
     Result := 0;

     If ( csDesigning In ComponentState ) Then Exit;

     For I := 0 To ControlCount - 1 Do
     Begin
          If CheckChild( Controls[ I ] ) Then
               If ( Not GetChild( Controls[ I ] ).Visible ) And ( GetChild( Controls[ I ] ).HeaderIndex < Index ) Then
                    Inc( Result );
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.GetUnVisibleHeaderCountAfterIndex, 4/11/01 11:14:44 AM
// *************************************************************************************

Function TmxOutlookBar.GetUnVisibleHeaderCountAfterIndex( Index: Integer ): Integer;
Var
     I: Integer;
Begin
     Result := 0;

     If ( csDesigning In ComponentState ) Then Exit;

     For I := 0 To ControlCount - 1 Do
     Begin
          If CheckChild( Controls[ I ] ) Then
               If ( Not GetChild( Controls[ I ] ).Visible ) And ( GetChild( Controls[ I ] ).HeaderIndex > Index ) Then
                    Inc( Result );
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.GetHeaderRect, 4/9/01 1:08:31 PM
// *************************************************************************************

Function TmxOutlookBar.GetHeaderRect( Index: Integer ): TRect;
{$IFNDEF Delphi6_Up}
Var
     ABevelSize: Integer;
{$ENDIF}
Begin
     If ( Index < 0 ) Or ( Index > ( GetHeaderCount - 1 ) ) Then Result := Rect( 0, 0, 0, 0 ) Else
     Begin
          Result := GetClientRect;

          // *** Client Rect Calculation ***

{$IFNDEF Delphi6_Up}
{$IFDEF DELPHI4_UP}
          InflateRect( Result, -BorderWidth, -BorderWidth );
{$ELSE}
          InflateRect( Result, -1, -1 );
{$ENDIF}
          ABevelSize := 0;
          If BevelOuter <> bvNone Then Inc( ABevelSize, BevelWidth );
          If BevelInner <> bvNone Then Inc( ABevelSize, BevelWidth );
          InflateRect( Result, -ABevelSize, -ABevelSize );
{$ENDIF}

          // *******************************

          If FActiveHeader = Nil Then
          Begin
               Result.Top := Result.Top + ( ( Index - GetUnVisibleHeaderCountToIndex( Index ) ) * GetHeaderByIndex( Index ).GetHeaderHeight );
               Result.Bottom := Result.Top + GetHeaderByIndex( Index ).GetHeaderHeight;
          End
          Else
               If Index < FActiveHeader.HeaderIndex Then
               Begin
                    Result.Top := Result.Top + ( ( Index - GetUnVisibleHeaderCountToIndex( Index ) ) * GetHeaderByIndex( Index ).GetHeaderHeight );
                    Result.Bottom := Result.Top + GetHeaderByIndex( Index ).GetHeaderHeight;
               End
               Else
               Begin
                    Result.Bottom := Result.Bottom - ( ( ( GetHeaderCount - GetUnVisibleHeaderCountAfterIndex( Index ) ) - Index - 1 ) * GetHeaderByIndex( Index ).GetHeaderHeight );

                    If Index = FActiveHeader.HeaderIndex Then Result.Top := Result.Top + ( ( Index - GetUnVisibleHeaderCountToIndex( Index ) ) * GetHeaderByIndex( Index ).GetHeaderHeight );
                    If Index > FActiveHeader.HeaderIndex Then Result.Top := Result.Bottom - GetHeaderByIndex( Index ).GetHeaderHeight;
               End;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.SetHeaderSizes, 4/9/01 2:11:40 PM
// *************************************************************************************

Procedure TmxOutlookBar.SetHeaderSizes;
Var
     I: Integer;
     _OldRect: TRect;
     _NewRect: TRect;
     NeedUpdate: Boolean;
Begin
     If FScrolling Then Exit;

     For I := 0 To ControlCount - 1 Do
     Begin
          If CheckChild( Controls[ I ] ) Then
          Begin
               _NewRect := GetHeaderRect( I );
               _OldRect := GetChildByIndex( I ).BoundsRect;

               NeedUpdate := False;
               If _NewRect.Left <> _OldRect.Left Then NeedUpdate := TRUE;
               If _NewRect.Right <> _OldRect.Right Then NeedUpdate := TRUE;
               If _NewRect.Top <> _OldRect.Top Then NeedUpdate := TRUE;
               If _NewRect.Bottom <> _OldRect.Bottom Then NeedUpdate := TRUE;

               If NeedUpdate Then
               Begin
                    GetChildByIndex( I ).Canvas.Lock;
                    GetChildByIndex( I ).BoundsRect := _NewRect;
               End;
          End;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.WMGetDlgCode, 4/12/01 12:22:32 PM
// *************************************************************************************

Procedure TmxOutlookBar.WMGetDlgCode( Var Msg: TWMGetDlgCode );
Begin
     Msg.Result := DLGC_WANTARROWS;
End;

// *************************************************************************************
// ** TmxOutlookBar.SetBorderStyle, 4/9/01 4:30:16 PM
// *************************************************************************************

Procedure TmxOutlookBar.SetBorderStyle( Value: TBorderStyle );
Begin
     If FBorderStyle <> Value Then
     Begin
          FBorderStyle := Value;
          RecreateWnd;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.AdjustClientRect, 4/9/01 4:20:59 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TmxOutlookBar.AdjustClientRect( Var Rect: TRect );
Var
     ABevelSize: Integer;
Begin
     Inherited AdjustClientRect( Rect );

     InflateRect( Rect, -BorderWidth, -BorderWidth );
     ABevelSize := 0;
     If BevelOuter <> bvNone Then Inc( ABevelSize, BevelWidth );
     If BevelInner <> bvNone Then Inc( ABevelSize, BevelWidth );
     InflateRect( Rect, -ABevelSize, -ABevelSize );
End;

{$ENDIF}

// *************************************************************************************
// ** TmxOutlookBar.Notification, 4/9/01 3:46:09 PM
// *************************************************************************************

Procedure TmxOutlookBar.Notification( AComponent: TComponent; Operation: TOperation );
Begin
     Inherited Notification( AComponent, Operation );

     If ( AComponent = Images ) And ( Operation = opRemove ) Then Images := Nil;

     If AComponent Is TmxOutlookBarHeader Then
     Begin
          Case Operation Of
               opInsert:
                    Begin
                         If TmxOutlookBarHeader( AComponent ).Owner = Self Then
                              ActiveHeader := TmxOutlookBarHeader( AComponent );
                    End;
               opRemove:
                    Begin
                         If ( TmxOutlookBarHeader( AComponent ).Owner = Self ) And ( ControlCount = 0 ) Then
                              ActiveHeader := Nil Else
                              ActiveHeader := GetChildByIndex( 0 );
                    End;
          End;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.CMBorderChanged, 4/10/01 9:37:52 AM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TmxOutlookBar.CMBorderChanged( Var Message: TMessage );
Begin
     Inherited;
     Invalidate;
End;

{$ENDIF}

// *************************************************************************************
// ** TmxOutlookBar.SetFlat, 4/10/01 12:14:42 PM
// *************************************************************************************

Procedure TmxOutlookBar.SetFlat( Value: Boolean );
Begin
     If Value <> FFlat Then
     Begin
          FFlat := Value;
          Invalidate;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.CMCtl3DChanged, 4/10/01 9:39:18 AM
// *************************************************************************************

Procedure TmxOutlookBar.CMCtl3DChanged( Var Message: TMessage );
Begin
     If NewStyleControls And ( FBorderStyle = bsSingle ) Then RecreateWnd;
     Inherited;
End;

// *************************************************************************************
// ** TmxOutlookBar.SetCommonStyle, 4/10/01 9:54:28 AM
// *************************************************************************************

Procedure TmxOutlookBar.SetCommonStyle( Value: Boolean );
Var
     X: Integer;
     Header: TmxOutlookBarHeader;
Begin
     If FCommonStyle <> Value Then
     Begin
          FCommonStyle := Value;
          Invalidate;

          If FCommonStyle Then DoSettingsChange( FHeaderSettings ) Else
               For X := 0 To GetHeaderCount - 1 Do
               Begin
                    Header := GetHeaderByIndex( X );
                    If Header = Nil Then Continue;
                    Header.DoSettingsChange( Header.HeaderSettings );
               End;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.CMSysColorChange, 4/10/01 12:41:45 PM
// *************************************************************************************

Procedure TmxOutlookBar.CMSysColorChange( Var Message: TMessage );
Begin
     Inherited;
     If Not ( csLoading In ComponentState ) Then
     Begin
          Message.Msg := WM_SYSCOLORCHANGE;
          DefaultHandler( Message );
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.CMEnabledChanged, 4/10/01 4:58:18 PM
// *************************************************************************************

Procedure TmxOutlookBar.CMEnabledChanged( Var Message: TMessage );
Begin
     Inherited;
     Invalidate;
End;

// *************************************************************************************
// ** TmxOutlookBar.BarResized, 4/10/01 3:38:50 PM
// *************************************************************************************

Procedure TmxOutlookBar.BarResized( Sender: TObject );
Begin
     SetHeaderSizes;
     Inherited;
     Invalidate;
End;

// *************************************************************************************
// ** TmxOutlookBar.BarCanResize, 10/11/01 4:27:40 PM
// *************************************************************************************

Procedure TmxOutlookBar.BarCanResize( Sender: TObject; Var NewWidth, NewHeight: Integer; Var Resize: Boolean );
Begin
     Resize := TRUE;
End;

// *************************************************************************************
// ** TmxOutlookBar.CreateParams, 4/10/01 8:29:42 AM
// *************************************************************************************

Procedure TmxOutlookBar.CreateParams( Var Params: TCreateParams );
Const
     BorderStyles: Array[ TBorderStyle ] Of DWORD = ( 0, WS_BORDER );
Begin
     Inherited CreateParams( Params );
     With Params Do
     Begin
          Style := Style Or BorderStyles[ FBorderStyle ];
          If NewStyleControls And Ctl3D And ( FBorderStyle = bsSingle ) Then
          Begin
               Style := Style And Not WS_BORDER;
               ExStyle := ExStyle Or WS_EX_CLIENTEDGE;
          End;
          WindowClass.Style := WindowClass.Style And Not ( CS_HREDRAW Or CS_VREDRAW );
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.GetPrevHeader, 4/11/01 11:49:16 AM
// *************************************************************************************

Function TmxOutlookBar.GetPrevHeader( OutlookSideBarHeader: TmxOutlookBarHeader ): TmxOutlookBarHeader;
Var
     I: Integer;
Begin
     Result := OutlookSideBarHeader;
     If OutlookSideBarHeader = Nil Then Exit;
     If OutlookSideBarHeader.HeaderIndex = 0 Then Exit;

     For I := 0 To ControlCount - 1 Do
     Begin
          If CheckChild( Controls[ I ] ) Then
               If GetChildByIndex( I ).HeaderIndex = OutlookSideBarHeader.HeaderIndex - 1 Then
               Begin
                    If GetChildByIndex( I ).Visible Then
                         Result := GetChildByIndex( I ) Else
                         Result := GetPrevHeader( GetChildByIndex( I ) );
               End;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.GetNextHeader, 4/11/01 11:49:12 AM
// *************************************************************************************

Function TmxOutlookBar.GetNextHeader( OutlookSideBarHeader: TmxOutlookBarHeader ): TmxOutlookBarHeader;
Var
     I: Integer;
Begin
     Result := OutlookSideBarHeader;
     If OutlookSideBarHeader = Nil Then Exit;
     If OutlookSideBarHeader.HeaderIndex = GetHeaderCount Then Exit;

     For I := 0 To ControlCount - 1 Do
     Begin
          If CheckChild( Controls[ I ] ) Then
               If GetChildByIndex( I ).HeaderIndex = OutlookSideBarHeader.HeaderIndex + 1 Then
               Begin
                    If GetChildByIndex( I ).Visible Then
                         Result := GetChildByIndex( I ) Else
                         Result := GetNextHeader( GetChildByIndex( I ) );
               End;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.KeyDown, 4/11/01 11:46:33 AM
// *************************************************************************************

Procedure TmxOutlookBar.KeyDown( Var Key: Word; Shift: TShiftState );
Begin
     Inherited KeyDown( Key, Shift );

     If ( Key In [ VK_PRIOR, VK_NEXT ] ) Then
     Begin
          Case Key Of
               VK_PRIOR: ChangeHeader( GetPrevHeader( FActiveHeader ) );
               VK_NEXT: ChangeHeader( GetNextHeader( FActiveHeader ) );
          End;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.GetHeaderIndex, 4/11/01 1:34:17 PM
// *************************************************************************************

Function TmxOutlookBar.GetHeaderIndex: Integer;
Begin
     If FActiveHeader = Nil Then Result := -1 Else Result := FActiveHeader.HeaderIndex;
End;

// *************************************************************************************
// ** TmxOutlookBar.SetImages, 4/11/01 2:24:43 PM
// *************************************************************************************

Procedure TmxOutlookBar.SetImages( Value: TCustomImageList );
Begin
     If FImages <> Nil Then FImages.UnRegisterChanges( FImageChangeLink );

     FImages := Value;

     If FImages <> Nil Then
     Begin
          FImages.RegisterChanges( FImageChangeLink );
          FImages.FreeNotification( Self );
     End;
     ImageListChange( Images );
End;

// *************************************************************************************
// ** TmxOutlookBar.DoSettingsChange, 4/11/01 2:59:37 PM
// *************************************************************************************

Procedure TmxOutlookBar.DoSettingsChange( Sender: TObject );
Var
     X: Integer;
     Header: TmxOutlookBarHeader;
Begin
     If FCommonStyle Then Invalidate;

     If ( Sender Is THeaderSettings ) Then
     Begin
          If FCommonStyle Then
          Begin
               For X := 0 To GetHeaderCount - 1 Do
               Begin
                    Header := GetHeaderByIndex( X );
                    If Header = Nil Then Continue;
                    Header.DoSettingsChange( FHeaderSettings );
               End;
          End;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.ImageListChange, 4/11/01 2:27:05 PM
// *************************************************************************************

Procedure TmxOutlookBar.ImageListChange( Sender: TObject );
Var
     I: Integer;
Begin
     If ( Sender = Images ) And ( Images <> Nil ) Then
     Begin
          For I := 0 To ControlCount - 1 Do
               If CheckChild( Controls[ I ] ) Then GetChild( Controls[ I ] ).Invalidate;
     End;
     Refresh;
End;

// *************************************************************************************
// ** TmxOutlookBar.Paint, 4/9/01 10:57:47 AM
// *************************************************************************************

Procedure TmxOutlookBar.Paint;
Var
{$IFNDEF Delphi6_Up}
     ARect: TRect;
{$ENDIF}
     TopColor, BottomColor: TColor;

     Procedure AdjustColors( Bevel: TPanelBevel );
     Begin
          TopColor := clBtnHighlight;
          If Bevel = bvLowered Then TopColor := clBtnShadow;
          BottomColor := clBtnShadow;
          If Bevel = bvLowered Then BottomColor := clBtnHighlight;
     End;

Begin
     SetHeaderSizes;

{$IFNDEF Delphi6_Up}

     // *** Clear Client Area ***

     With Canvas Do
     Begin
          ARect := GetClientRect;

          Pen.Style := psSolid;
          Pen.Width := 1;
          Pen.Color := Color;
          Brush.Color := Color;
          If GetHeaderCount = 0 Then FillRect( ARect );

          // *** Draw borders ***

          If BevelOuter <> bvNone Then
          Begin
               AdjustColors( BevelOuter );
               Frame3D( Canvas, ARect, TopColor, BottomColor, BevelWidth );
          End;

{$IFDEF DELPHI4_UP}
          Frame3D( Canvas, ARect, Color, Color, BorderWidth );
{$ELSE}
          Frame3D( Canvas, ARect, Color, Color, 1 );
{$ENDIF}

          If BevelInner <> bvNone Then
          Begin
               AdjustColors( BevelInner );
               Frame3D( Canvas, ARect, TopColor, BottomColor, BevelWidth );
          End;
     End;
{$ENDIF}
End;

// *************************************************************************************
// ** TmxOutlookBar.AddHeader, 4/12/01 2:48:47 PM
// *************************************************************************************

Procedure TmxOutlookBar.AddHeader( OutlookSideBarHeader: TmxOutlookBarHeader );
Begin
     OutlookSideBarHeader.Parent := Self;
     OutlookSideBarHeader.HeaderSettings.HeaderColor := FHeaderSettings.HeaderColor;

     ChangeHeader( OutlookSideBarHeader );

     If CommonStyle Then
          OutlookSideBarHeader.DoSettingsChange( HeaderSettings ) Else
          OutlookSideBarHeader.DoSettingsChange( OutlookSideBarHeader.HeaderSettings );
End;

// *************************************************************************************
// ** TmxOutlookBar.CreateNewOutlookHeader, 4/12/01 2:51:57 PM
// *************************************************************************************

Function TmxOutlookBar.CreateNewOutlookHeader: TmxOutlookBarHeader;
Begin
     Result := TmxOutlookBarHeader.Create( Self );
End;

// *************************************************************************************
// ** TmxOutlookBar.CreateHeader, 4/12/01 2:51:55 PM
// *************************************************************************************

Procedure TmxOutlookBar.CreateHeader( Const Caption: String );
Var
     OutlookSideBarHeader: TmxOutlookBarHeader;
Begin
     OutlookSideBarHeader := CreateNewOutlookHeader;
     OutlookSideBarHeader.Caption := Caption;
     OutlookSideBarHeader.Parent := Self;
     OutlookSideBarHeader.HeaderSettings.HeaderColor := FHeaderSettings.FHeaderColor;
     ChangeHeader( OutlookSideBarHeader );
End;

// *************************************************************************************
// ** TmxOutlookBar.DeleteHeader, 4/12/01 2:59:35 PM
// *************************************************************************************

Procedure TmxOutlookBar.DeleteHeader( Index: Integer );
Var
     OutlookSideBarHeader: TmxOutlookBarHeader;
Begin
     If ( Index < 0 ) Or ( Index > GetHeaderCount - 1 ) Then Exit;
     OutlookSideBarHeader := GetChildByIndex( Index );
     OutlookSideBarHeader.Free;
End;

// *************************************************************************************
// ** TmxOutlookBar.GetHeaderByIndex, 4/12/01 3:03:54 PM
// *************************************************************************************

Function TmxOutlookBar.GetHeaderByIndex( Index: Integer ): TmxOutlookBarHeader;
Begin
     Result := Nil;
     If ( Index < 0 ) Or ( Index > GetHeaderCount - 1 ) Then Exit;

     Result := GetChildByIndex( Index );
End;

{$IFNDEF Delphi6_Up}

// *************************************************************************************
// ** THeaderSettings.SetBevelOuter, 4/10/01 9:17:24 AM
// *************************************************************************************

Procedure TmxOutlookBar.SetBevelOuter( Value: TPanelBevel );
Begin
     If FBevelOuter <> Value Then
     Begin
          FBevelOuter := Value;
          Invalidate;
     End;
End;

// *************************************************************************************
// ** THeaderSettings.SetBevelWidth, 4/10/01 9:17:30 AM
// *************************************************************************************

Procedure TmxOutlookBar.SetBevelWidth( Value: TBevelWidth );
Begin
     If FBevelWidth <> Value Then
     Begin
          FBevelWidth := Value;
          Invalidate;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.SetBevelInner, 4/10/01 9:17:18 AM
// *************************************************************************************

Procedure TmxOutlookBar.SetBevelInner( Value: TPanelBevel );
Begin
     If FBevelInner <> Value Then
     Begin
          FBevelInner := Value;
          Invalidate;
     End;
End;

{$ENDIF}

// *************************************************************************************
// ** TmxOutlookBar.SetScrollSpeed, 4/10/01 9:17:30 AM
// *************************************************************************************

{$IFDEF HEADERSCROLL}

Procedure TmxOutlookBar.SetScrollSpeed( Value: integer );
Begin
     If ( FScrollSpeed <> Value ) And ( Value In [ 1..100 ] ) Then
     Begin
          FScrollSpeed := Value;
     End;
End;

{$ENDIF}

// *************************************************************************************
// ** TmxOutlookBar.CMMouseLeave, 4/25/01 1:42:24 PM
// *************************************************************************************

Procedure TmxOutlookBar.CMMouseLeave( Var Message: TMessage );
Var
     OutlookBarHeader: TmxOutlookBarHeader;
Begin
     Inherited;
     If MouseInControl <> Nil Then
     Begin
          OutlookBarHeader := MouseInControl;
          MouseInControl := Nil;
          OutlookBarHeader.FButtonDown := FALSE;
          OutlookBarHeader.Invalidate;
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.CanFocus, 5/16/01 9:58:02 AM
// *************************************************************************************

{$IFDEF DELPHI4_UP}
{$IFDEF DELPHI5_UP}

Function TmxOutlookBar.CanFocus: Boolean;
{$ELSE}

Function TmxOutlookBar.MyCanFocus: Boolean;
{$ENDIF}
Begin
     Result := FALSE;
End;
{$ENDIF}

// *************************************************************************************
// ** TmxOutlookBar.SetVersion, 5/16/01 10:20:16 AM
// *************************************************************************************

Procedure TmxOutlookBar.SetVersion( Value: String );
Begin
        // *** Does nothing ***
End;

// *************************************************************************************
// ** TmxOutlookBar.GetVersion, 5/16/01 10:20:13 AM
// *************************************************************************************

Function TmxOutlookBar.GetVersion: String;
Begin
{$WARNINGS OFF}
     Result := Format( '%d.%d', [ Hi( FVersion ), Lo( FVersion ) ] );
{$WARNINGS ON}
End;

// *************************************************************************************
// ** TmxOutlookBar.ReadAlign, 9/4/01 9:14:05 AM
// *************************************************************************************

Procedure TmxOutlookBar.ReadAlign( Reader: TReader );
Var
     S: String;
Begin
     S := Reader.ReadString;

     If S = 'alNone' Then Align := alNone Else
          If S = 'alTop' Then Align := alTop Else
               If S = 'alBottom' Then Align := alBottom Else
                    If S = 'alLeft' Then Align := alLeft Else
                         If S = 'alRight' Then Align := alRight Else
                              If S = 'alClient' Then Align := alClient;
End;

// *************************************************************************************
// ** TmxOutlookBar.WriteAlign, 9/4/01 9:14:08 AM
// *************************************************************************************

Procedure TmxOutlookBar.WriteAlign( Writer: TWriter );
Begin
     Case Align Of
          alNone: Writer.WriteString( 'alNone' );
          alTop: Writer.WriteString( 'alTop' );
          alBottom: Writer.WriteString( 'alBottom' );
          alLeft: Writer.WriteString( 'alLeft' );
          alRight: Writer.WriteString( 'alRight' );
          alClient: Writer.WriteString( 'alClient' );
     End;
End;

// *************************************************************************************
// ** TmxOutlookBar.DefineProperties, 9/4/01 9:12:31 AM
// *************************************************************************************

Procedure TmxOutlookBar.DefineProperties( Filer: TFiler );
Begin
     Inherited DefineProperties( Filer );
     Filer.DefineProperty( 'AlignInfo', ReadAlign, WriteAlign, TRUE );
End;

// *************************************************************************************
// ** TOutlookButtonActionLink.AssignClient, 10/11/01 12:53:58 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TOutlookButtonActionLink.AssignClient( AClient: TObject );
Begin
     Inherited AssignClient( AClient );
     FClient := AClient As TOutlookButton;
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.IsImageIndexLinked, 10/11/01 12:56:40 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Function TOutlookButtonActionLink.IsImageIndexLinked: Boolean;
Begin
     Result := Inherited IsImageIndexLinked And
          ( FClient.ImageIndex = ( Action As TCustomAction ).ImageIndex );
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.SetImageIndex, 10/11/01 12:58:06 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TOutlookButtonActionLink.SetImageIndex( Value: Integer );
Begin
     If IsImageIndexLinked Then FClient.ImageIndex := Value;
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.IsCaptionLinked, 10/11/01 1:01:30 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Function TOutlookButtonActionLink.IsCaptionLinked: Boolean;
Begin
     Result := FClient.Caption = ( Action As TCustomAction ).Caption;
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.IsCheckedLinked, 10/11/01 1:01:40 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Function TOutlookButtonActionLink.IsEnabledLinked: Boolean;
Begin
     Result := Inherited IsEnabledLinked And
          ( FClient.Enabled = ( Action As TCustomAction ).Enabled );
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.IsHelpContextLinked, 10/11/01 1:02:08 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Function TOutlookButtonActionLink.IsHelpContextLinked: Boolean;
Begin
     Result := Inherited IsHelpContextLinked And
          ( FClient.HelpContext = ( Action As TCustomAction ).HelpContext );
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.IsHintLinked, 10/11/01 1:02:12 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Function TOutlookButtonActionLink.IsHintLinked: Boolean;
Begin
     Result := Inherited IsHintLinked And
          ( FClient.Hint = ( Action As TCustomAction ).Hint );
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.IsVisibleLinked, 10/11/01 1:02:26 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Function TOutlookButtonActionLink.IsVisibleLinked: Boolean;
Begin
     Result := Inherited IsVisibleLinked And
          ( FClient.Visible = ( Action As TCustomAction ).Visible );
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.IsOnExecuteLinked, 10/11/01 1:02:30 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Function TOutlookButtonActionLink.IsOnExecuteLinked: Boolean;
Begin
{$WARNINGS OFF}
     Result := Inherited IsOnExecuteLinked And
          ( @FClient.OnClick = @Action.OnExecute );
{$WARNINGS ON}
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.SetCaption, 10/11/01 1:02:56 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TOutlookButtonActionLink.SetCaption( Const Value: String );
Begin
     If IsCaptionLinked Then FClient.Caption := Value;
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.SetEnabled, 10/11/01 1:03:00 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TOutlookButtonActionLink.SetEnabled( Value: Boolean );
Begin
     If IsEnabledLinked Then FClient.Enabled := Value;
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.SetHelpContext, 10/11/01 1:03:02 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TOutlookButtonActionLink.SetHelpContext( Value: THelpContext );
Begin
     If IsHelpContextLinked Then FClient.HelpContext := Value;
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.SetHint, 10/11/01 1:03:07 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TOutlookButtonActionLink.SetHint( Const Value: String );
Begin
     If IsHintLinked Then FClient.Hint := Value;
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.SetVisible, 10/11/01 1:03:13 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TOutlookButtonActionLink.SetVisible( Value: Boolean );
Begin
     If IsVisibleLinked Then FClient.Visible := Value;
End;

{$ENDIF}

// *************************************************************************************
// ** TOutlookButtonActionLink.SetOnExecute, 10/11/01 1:03:15 PM
// *************************************************************************************

{$IFDEF DELPHI4_UP}

Procedure TOutlookButtonActionLink.SetOnExecute( Value: TNotifyEvent );
Begin
     If IsOnExecuteLinked Then FClient.OnClick := Value;
End;

{$ENDIF}

// *************************************************************************************
// *** TmxOutlookBar.GetClientRect, 10/16/01 1:02:22 PM
// *************************************************************************************

Function TmxOutlookBar.GetClientRect: TRect;
Begin
     Result := Inherited GetClientRect;
End;

End.

