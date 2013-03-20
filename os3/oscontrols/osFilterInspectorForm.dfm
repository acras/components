object osFilterInspector: TosFilterInspector
  Left = 345
  Top = 197
  Width = 411
  Height = 380
  BorderIcons = []
  BorderStyle = bsSizeToolWin
  BorderWidth = 4
  Caption = 'Dados para pesquisa'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    395
    345)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 317
    Width = 102
    Height = 13
    Caption = '* Campos obrigat'#243'rios'
  end
  object DataInspector: TwwDataInspector
    Left = 0
    Top = 4
    Width = 395
    Height = 310
    DisableThemes = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    Items = <>
    DefaultRowHeight = 18
    CaptionWidth = 187
    Options = [ovColumnResize, ovRowResize, ovEnterToTab, ovHighlightActiveRow, ovCenterCaptionVert]
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'MS Sans Serif'
    CaptionFont.Style = []
    LineStyleCaption = ovLight3DLine
    LineStyleData = ovLight3DLine
  end
  object btnOK: TButton
    Left = 238
    Top = 320
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancela: TButton
    Left = 320
    Top = 320
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancela'
    ModalResult = 2
    TabOrder = 2
  end
end
