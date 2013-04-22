object FilterInspectorFrame: TFilterInspectorFrame
  Left = 0
  Top = 0
  Width = 365
  Height = 88
  Anchors = []
  TabOrder = 0
  DesignSize = (
    365
    88)
  object Label1: TLabel
    Left = 1
    Top = 4
    Width = 37
    Height = 13
    Caption = '&Crit'#233'rios'
    FocusControl = DataInspector
  end
  object DataInspector: TwwDataInspector
    Left = 0
    Top = 20
    Width = 284
    Height = 68
    DisableThemes = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    Items = <>
    DefaultRowHeight = 18
    CaptionWidth = 112
    Options = [ovColumnResize, ovRowResize, ovEnterToTab, ovHighlightActiveRow, ovCenterCaptionVert]
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'MS Sans Serif'
    CaptionFont.Style = []
    LineStyleCaption = ovLight3DLine
    LineStyleData = ovLight3DLine
  end
  object PesquisarButton: TButton
    Left = 290
    Top = 20
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Pesquisar'
    Default = True
    TabOrder = 1
  end
end
