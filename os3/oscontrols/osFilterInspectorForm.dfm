object osFilterInspector: TosFilterInspector
  Left = 345
  Top = 197
  Width = 303
  Height = 244
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
    287
    209)
  PixelsPerInch = 96
  TextHeight = 13
  object DataInspector: TwwDataInspector
    Left = 0
    Top = 4
    Width = 287
    Height = 171
    DisableThemes = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    Items = <>
    DefaultRowHeight = 18
    CaptionWidth = 103
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
    Left = 130
    Top = 177
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancela: TButton
    Left = 212
    Top = 177
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancela'
    ModalResult = 2
    TabOrder = 2
  end
end
