object Form1: TForm1
  Left = 271
  Top = 114
  Caption = 'CloudyBooks - ver 1.3'
  ClientHeight = 393
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object grbxServerControls: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 407
    Height = 174
    Align = alTop
    Caption = 'Server Controls'
    TabOrder = 0
    object Shape1: TShape
      AlignWithMargins = True
      Left = 333
      Top = 18
      Width = 69
      Height = 92
      Align = alRight
      Pen.Color = clGray
      ExplicitLeft = 288
      ExplicitHeight = 75
    end
    object ButtonStart: TButton
      Left = 16
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 0
      OnClick = ButtonStartClick
    end
    object ButtonStop: TButton
      Left = 97
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 1
      OnClick = ButtonStopClick
    end
    object grbxPort: TGroupBox
      Left = 16
      Top = 55
      Width = 156
      Height = 50
      Caption = 'Port'
      TabOrder = 2
      object EditPort: TEdit
        AlignWithMargins = True
        Left = 5
        Top = 18
        Width = 146
        Height = 21
        Align = alTop
        TabOrder = 0
        Text = '4040'
      end
    end
    object GroupBox1: TGroupBox
      AlignWithMargins = True
      Left = 15
      Top = 116
      Width = 387
      Height = 50
      Margins.Left = 13
      Margins.Bottom = 6
      Align = alBottom
      Caption = 'Additional delay (in ieach response)'
      TabOrder = 3
      object SpeedButton1: TSpeedButton
        AlignWithMargins = True
        Left = 5
        Top = 18
        Width = 84
        Height = 27
        Margins.Right = 0
        Align = alLeft
        GroupIndex = 1
        Down = True
        Caption = 'no delay'
        OnClick = SpeedButtonDelayClick
      end
      object SpeedButton2: TSpeedButton
        Tag = 100
        AlignWithMargins = True
        Left = 89
        Top = 18
        Width = 84
        Height = 27
        Margins.Left = 0
        Margins.Right = 0
        Align = alLeft
        GroupIndex = 1
        Caption = '100 ms'
        OnClick = SpeedButtonDelayClick
        ExplicitTop = 20
      end
      object SpeedButton4: TSpeedButton
        Tag = 1000
        AlignWithMargins = True
        Left = 260
        Top = 18
        Width = 84
        Height = 27
        Margins.Left = 0
        Align = alLeft
        GroupIndex = 1
        Caption = '800-1800 ms'
        OnClick = SpeedButtonDelayClick
      end
      object SpeedButton3: TSpeedButton
        Tag = 500
        AlignWithMargins = True
        Left = 173
        Top = 18
        Width = 84
        Height = 27
        Margins.Left = 0
        Align = alLeft
        GroupIndex = 1
        Caption = '500 ms'
        OnClick = SpeedButtonDelayClick
        ExplicitTop = 20
      end
    end
  end
  object grbxOpenBrowser: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 190
    Width = 407
    Height = 200
    Margins.Top = 10
    Align = alClient
    Caption = 'Open Browser'
    TabOrder = 1
    object Label1: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 55
      Width = 397
      Height = 13
      Align = alTop
      Caption = 'Site path:'
      ExplicitWidth = 47
    end
    object ButtonOpenBrowser: TButton
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 397
      Height = 31
      Align = alTop
      Caption = 'Open Browser'
      TabOrder = 0
      OnClick = ButtonOpenBrowserClick
    end
    object ListBox1: TListBox
      AlignWithMargins = True
      Left = 5
      Top = 74
      Width = 397
      Height = 121
      Align = alClient
      ItemHeight = 13
      Items.Strings = (
        '/'
        '/books/review?startdate=2019-08-01'
        '/books/review?startdate=2019-09-02'
        '/books/review/a001vv4782e8c9fe9a29'
        '/books/review/a003vv4782e8c9fe9a29'
        '/books/review/b001vv5be4780927faec')
      PopupMenu = pmnListbox
      TabOrder = 1
      OnDblClick = ListBox1DblClick
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    Left = 200
    Top = 24
  end
  object tmrAppStartup: TTimer
    Interval = 1
    OnTimer = tmrAppStartupTimer
    Left = 200
    Top = 72
  end
  object pmnListbox: TPopupMenu
    Left = 136
    Top = 248
    object pmnItemCopyURL: TMenuItem
      Caption = 'Copy selected URL'
      OnClick = pmnItemCopyURLClick
    end
  end
end
