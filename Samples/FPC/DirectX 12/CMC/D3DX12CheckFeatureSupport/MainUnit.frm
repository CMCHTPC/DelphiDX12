object Form1: TForm1
  Left = 86
  Height = 391
  Top = 85
  Width = 642
  Caption = 'Form1'
  ClientHeight = 391
  ClientWidth = 642
  LCLVersion = '8.7'
  object Button1: TButton
    Left = 50
    Height = 25
    Top = 23
    Width = 75
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edMaxFeatureLevel: TLabeledEdit
    Left = 50
    Height = 23
    Top = 80
    Width = 110
    EditLabel.Height = 15
    EditLabel.Width = 110
    EditLabel.Caption = 'edMaxFeatureLevel'
    TabOrder = 1
    Text = 'Max feature level:'
  end
end
