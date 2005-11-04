// ****************************************************************************
// * ABOUT BOX FOR MY COMPONENTS
// ****************************************************************************
// * Copyright 2001, Lajos Farkas. All Rights Reserved.
// ****************************************************************************
// * Date last modified: 2001.06.16
// ****************************************************************************

Unit mxNativeExcelAbout;

Interface

// *************************************************************************************
// ** List of used units
// *************************************************************************************

Uses
     SysUtils,
     Windows,
     Messages,
     Classes,
     Graphics,
     Controls,
     Forms,
     Dialogs,
     StdCtrls,
     Buttons,
     ExtCtrls;

Type
     Tfrm_AboutBox = Class( TForm )

          OKButton: TButton;
          lbl_Copyright: TLabel;
          Lbl_Delphi: TLabel;
          Lbl_ComponentName: TLabel;
    Lbl_ComponentName_2: TLabel;
          Label1: TLabel;
          Label4: TLabel;
          Label5: TLabel;
          Label6: TLabel;
          Label3: TLabel;

     Private
     End;

Procedure ShowAboutBox( Const ComponentName: String );

// *************************************************************************************
// ** End of Interface section
// *************************************************************************************

Implementation

{$R *.DFM}

// *************************************************************************************
// ** ShowAboutBox, 4/11/01 10:13:27 AM
// *************************************************************************************

Procedure ShowAboutBox( Const ComponentName: String );
Begin
     With Tfrm_AboutBox.Create( Application ) Do
     Try
          Lbl_ComponentName.Caption := ComponentName;
          Lbl_ComponentName_2.Caption := ComponentName;

          Lbl_Delphi.Caption := 'Compiled in ' +

{$IFDEF VER80} 'Delphi 1.0'{$ENDIF}
{$IFDEF VER90} 'Delphi 2.0'{$ENDIF}
{$IFDEF VER100} 'Delphi 3.0'{$ENDIF}
{$IFDEF VER120} 'Delphi 4.0'{$ENDIF}
{$IFDEF VER130} 'Delphi 5.0'{$ENDIF}
{$IFDEF VER140} 'Delphi 6.0'{$ENDIF}
{$IFDEF VER93} 'C++Builder 1.0'{$ENDIF}
{$IFDEF VER110} 'C++Builder 3.0'{$ENDIF}
{$IFDEF VER125} 'C++Builder 4.0'{$ENDIF};

          ShowModal;

     Finally
          Free;
     End;
End;

End.

