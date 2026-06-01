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
  Position = poOwnerFormCenter
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
      Left = 5
      Top = 18
      Width = 22
      Height = 15
      Caption = 'Port'
    end
    object lblBaudRate: TLabel
      Left = 5
      Top = 48
      Width = 53
      Height = 15
      Caption = 'Baud Rate'
    end
    object lblDataBits: TLabel
      Left = 5
      Top = 78
      Width = 46
      Height = 15
      Caption = 'Data Bits'
    end
    object lblParity: TLabel
      Left = 5
      Top = 108
      Width = 30
      Height = 15
      Caption = 'Parity'
    end
    object lblStopBits: TLabel
      Left = 5
      Top = 138
      Width = 46
      Height = 15
      Caption = 'Stop Bits'
    end
    object lblFlowControl: TLabel
      Left = 5
      Top = 168
      Width = 68
      Height = 15
      Caption = 'Flow Control'
    end
    object cbPort: TComboBox
      Left = 70
      Top = 15
      Width = 105
      Height = 23
      TabOrder = 0
    end
    object cbBaudRate: TComboBox
      Left = 70
      Top = 45
      Width = 105
      Height = 23
      TabOrder = 1
    end
    object cbDataBits: TComboBox
      Left = 70
      Top = 75
      Width = 105
      Height = 23
      TabOrder = 2
    end
    object cbParity: TComboBox
      Left = 70
      Top = 105
      Width = 105
      Height = 23
      TabOrder = 3
    end
    object cbStopBits: TComboBox
      Left = 70
      Top = 135
      Width = 105
      Height = 23
      TabOrder = 4
    end
    object cbFlowControl: TComboBox
      Left = 70
      Top = 165
      Width = 105
      Height = 23
      TabOrder = 5
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
