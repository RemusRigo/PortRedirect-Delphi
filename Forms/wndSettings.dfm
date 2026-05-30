object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  Caption = 'PortRedirect: Settings'
  ClientHeight = 461
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object grpBoxInput: TGroupBox
    Left = 0
    Top = 0
    Width = 281
    Height = 453
    Caption = 'Input'
    TabOrder = 0
    object lblPort: TLabel
      Left = 16
      Top = 27
      Width = 22
      Height = 15
      Caption = 'Port'
    end
    object lblBaudRate: TLabel
      Left = 16
      Top = 56
      Width = 53
      Height = 15
      Caption = 'Baud Rate'
    end
    object cbPort: TComboBox
      Left = 120
      Top = 24
      Width = 105
      Height = 23
      TabOrder = 0
    end
    object cbBaudRate: TComboBox
      Left = 120
      Top = 53
      Width = 105
      Height = 23
      TabOrder = 1
    end
  end
  object grpBoxOutput: TGroupBox
    Left = 287
    Top = 0
    Width = 489
    Height = 453
    Caption = 'Output'
    TabOrder = 1
  end
end
