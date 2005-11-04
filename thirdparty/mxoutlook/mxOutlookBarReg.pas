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

Unit mxOutlookBarReg;

Interface

{$I max.inc}

// *************************************************************************************
// ** Component registration
// *************************************************************************************

Procedure Register;

Implementation

{$IFDEF DELPHI4_UP}
{$R *.DCR}
{$ENDIF}

// *************************************************************************************
// ** List of used units
// *************************************************************************************

Uses SysUtils,
     Classes,

     {$IFDEF Delphi6_up} DesignIntf, DesignEditors,
     {$ELSE}Dsgnintf,{$ENDIF}

     Dialogs,
     Forms,
     mxOutlookBarAbout,
     mxOutlookBar;

Type

{$IFNDEF DELPHI4_UP}
     IDesigner = TDesigner;
{$ELSE}
  {$IFDEF DELPHI6_UP}
     TFormDesigner = IDesigner;
  {$ELSE}
     TFormDesigner = IFormDesigner;
  {$ENDIF}
{$ENDIF}

     TDesigner = IDesigner;

// *************************************************************************************
// ** Component Editor
// *************************************************************************************

     TmxOutlookBarEditor = Class( TComponentEditor )

          Function GetVerbCount: integer; Override;
          Function GetVerb( Index: integer ): String; Override;
          Procedure ExecuteVerb( Index: integer ); Override;
     End;

// *************************************************************************************
// ** GetVerbCount
// *************************************************************************************

Function TmxOutlookBarEditor.GetVerbCount: integer;
Begin
     Result := 5;
End;

// *************************************************************************************
// ** GetVerb
// *************************************************************************************

Function TmxOutlookBarEditor.GetVerb( Index: integer ): String;
Begin
     Case Index Of
          0: Result := 'TmxOutlookBar (C) 2001-2005 Bitvadász Kft.';
          1: Result := '&Add header';
          2: Result := '&Add button';
          3: Result := '-';
          4: Result := 'Arrange buttons';
     End;
End;

// *************************************************************************************
// ** ExecuteVerb
// *************************************************************************************

Procedure TmxOutlookBarEditor.ExecuteVerb( Index: integer );
Var
     ComponentDesigner: TFormDesigner;
     OutlookSideBar: TmxOutlookBar;
     OutlookSideBarHeader: TmxOutlookBarHeader;
     OutlookButton: TOutlookButton;
Begin
     ComponentDesigner := Designer;

     Case Index Of
          0: ShowAboutBox( 'TmxOutlookBar Component' );
          1:
               Begin
                    If ( Component Is TmxOutlookBar ) Then
                         OutlookSideBar := ( Component As TmxOutlookBar ) Else
                         OutlookSideBar := ( TmxOutlookBarHeader( Component ).Parent As TmxOutlookBar );

                    {$IFDEF DELPHI6_UP}
                      OutlookSideBarHeader := TmxOutlookBarHeader.Create( ComponentDesigner.Root );
                    {$ELSE}
                      OutlookSideBarHeader := TmxOutlookBarHeader.Create( ComponentDesigner.Form );
                    {$ENDIF}

                    With OutlookSideBarHeader Do
                    Begin
                         Name := ComponentDesigner.UniqueName( 'Header' ); //TmxOutlookBarHeader.ClassName );
                         Caption := Name;
                         Parent := OutlookSideBar;
                         HeaderSettings.HeaderColor := OutlookSideBar.HeaderSettings.HeaderColor;
                    End;

                    OutlookSideBar.ActiveHeader := OutlookSideBarHeader;
                    OutlookSideBar.Invalidate;

                    ComponentDesigner.SelectComponent( OutlookSideBarHeader );
               End;
          2:
               Begin
                    If ( Component Is TmxOutlookBarHeader ) Then
                    Begin
                         OutlookSideBarHeader := ( Component As TmxOutlookBarHeader );

                         {$IFDEF Delphi6_UP}
                           OutlookButton := TOutlookButton.Create( ComponentDesigner.Root );
                         {$ELSE}
                           OutlookButton := TOutlookButton.Create( ComponentDesigner.Form );
                         {$ENDIF}

                         With OutlookButton Do
                         Begin
                              Name := ComponentDesigner.UniqueName( 'Button' );
                              Caption := Name;
                         End;

                         OutlookSideBarHeader.AddButton( OutlookButton );
                         ComponentDesigner.SelectComponent( OutlookButton );
                    End
                    Else MessageDlg( 'You cannot add button to this component type. Please select or add a TmxOutlookBarHeader component before.', mtError, [ mbOK ], 0 );
               End;
          4:
               Begin
                    If ( Component Is TmxOutlookBarHeader ) Then
                         ( Component As TmxOutlookBarHeader ).SortButtons Else
                         MessageDlg( 'Please select a TmxOutlookBarHeader component before.', mtError, [ mbOK ], 0 );
               End;
     End;

     ComponentDesigner.Modified;
End;

// *************************************************************************************
// ** Register, 4/5/01 11:46:42 AM
// *************************************************************************************

Procedure Register;
Begin
     RegisterComponents( 'Max', [ TmxOutlookBar ] );
     RegisterClasses( [ TmxOutlookBarHeader, TOutlookButton, TScrollButton, TmxOutlookBarHeader ]);
     RegisterComponentEditor( TmxOutlookBar, TmxOutlookBarEditor );
     RegisterComponentEditor( TmxOutlookBarHeader, TmxOutlookBarEditor );
End;

End.

