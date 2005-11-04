// ***** BEGIN LICENSE BLOCK *****
// * Version: MPL 1.1
// *
// * The contents of this file are subject to the Mozilla Public License Version
// * 1.1 (the "License"); you may not use this file except in compliance with
// * the License. You may obtain a copy of the License at
// * http://www.mozilla.org/MPL/
// *
// * Software distributed under the License is distributed on an "..\source\AS IS" basis,
// * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
// * for the specific language governing rights and limitations under the
// * License.
// *
// * The Original Code is TurboPower Abbrevia
// *
// * The Initial Developer of the Original Code is
// * TurboPower Software
// *
// * Portions created by the Initial Developer are Copyright (C) 1997-2002
// * the Initial Developer. All Rights Reserved.
// *
// * Contributor(s):
// *
// * ***** END LICENSE BLOCK *****
//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("B304_r51.res");
USEUNIT("..\source\Abarctyp.pas");
USEUNIT("..\source\AbBase.pas");
USEUNIT("..\source\AbBitBkt.pas");
USEUNIT("..\source\AbBrowse.pas");
USEUNIT("..\source\AbCabExt.pas");
USEUNIT("..\source\AbCabKit.pas");
USEUNIT("..\source\AbCabMak.pas");
USEUNIT("..\source\Abcabtyp.pas");
USEUNIT("..\source\AbCBrows.pas");
USEUNIT("..\source\Abconst.pas");
USEUNIT("..\source\AbCView.pas");
USEFORMNS("..\source\Abdlgdir.pas", Abdlgdir, DirDlg);
USEFORMNS("..\source\Abdlgpwd.pas", Abdlgpwd, PassWordDlg);
USEUNIT("..\source\AbExcept.pas");
USEUNIT("..\source\AbFciFdi.pas");
USEUNIT("..\source\AbMeter.pas");
USEUNIT("..\source\AbSelfEx.pas");
USEUNIT("..\source\Abunzper.pas");
USEUNIT("..\source\AbUnzPrc.pas");
USEUNIT("..\source\Abutils.pas");
USEUNIT("..\source\Abview.pas");
USEUNIT("..\source\AbVMStrm.PAS");
USEUNIT("..\source\AbZBrows.pas");
USEUNIT("..\source\Abzipext.pas");
USEUNIT("..\source\Abzipkit.pas");
USEUNIT("..\source\AbZipOut.pas");
USEUNIT("..\source\Abzipper.pas");
USEUNIT("..\source\AbZipPrc.pas");
USEUNIT("..\source\Abziptyp.pas");
USEUNIT("..\source\AbZView.pas");
USEPACKAGE("vclx50.bpi");
USEPACKAGE("vcl50.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
