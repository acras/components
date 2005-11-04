object frm_AboutBox: Tfrm_AboutBox
  Left = 413
  Top = 292
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'About Component'
  ClientHeight = 247
  ClientWidth = 307
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Lbl_ComponentName_2: TLabel
    Left = 10
    Top = 11
    Width = 290
    Height = 24
    AutoSize = False
    Caption = 'TmxExport Components'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object lbl_Copyright: TLabel
    Left = 10
    Top = 55
    Width = 186
    Height = 13
    Caption = 'Copyright 2000 Max. All rights reserved.'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Lbl_Delphi: TLabel
    Left = 10
    Top = 36
    Width = 77
    Height = 16
    Caption = 'for Delphi 5.0'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Lbl_ComponentName: TLabel
    Left = 8
    Top = 9
    Width = 290
    Height = 24
    AutoSize = False
    Caption = 'TmxExport Components'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 10
    Top = 75
    Width = 214
    Height = 13
    Caption = 'This component was created by Lajos Farkas'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 10
    Top = 94
    Width = 163
    Height = 13
    Caption = 'Author'#39's e-mail: wmax@freemail.hu'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 96
    Top = 136
    Width = 112
    Height = 13
    Caption = 'D I S C L A I M E R'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 16
    Top = 152
    Width = 261
    Height = 52
    Alignment = taCenter
    Caption = 
      'This component is provided AS-IS. '#13#10'I will not be responsable fo' +
      'r any dammage due to use it.'#13#10'This component is freeware for '#13#10'c' +
      'ommercial and non-commercial use as well.'
    WordWrap = True
  end
  object Label3: TLabel
    Left = 10
    Top = 113
    Width = 205
    Height = 13
    Caption = 'WEB: www.geocities.com/maxcomponents'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object OKButton: TButton
    Left = 120
    Top = 215
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
end
