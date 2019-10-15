object Form1: TForm1
  Left = 271
  Top = 114
  Caption = 'CloudyBooks - ver 1.1'
  ClientHeight = 326
  ClientWidth = 368
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
    Width = 362
    Height = 114
    Align = alTop
    Caption = 'Server Controls'
    TabOrder = 0
    object Shape1: TShape
      AlignWithMargins = True
      Left = 303
      Top = 18
      Width = 54
      Height = 91
      Align = alRight
      Pen.Color = clGray
      ExplicitLeft = 208
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
  end
  object grbxOpenBrowser: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 123
    Width = 362
    Height = 200
    Align = alClient
    Caption = 'Open Browser'
    TabOrder = 1
    object Label1: TLabel
      AlignWithMargins = True
      Left = 5
      Top = 49
      Width = 352
      Height = 13
      Align = alTop
      Caption = 'Site path:'
      ExplicitWidth = 47
    end
    object ButtonOpenBrowser: TButton
      AlignWithMargins = True
      Left = 5
      Top = 18
      Width = 352
      Height = 25
      Align = alTop
      Caption = 'Open Browser'
      TabOrder = 0
      OnClick = ButtonOpenBrowserClick
    end
    object ListBox1: TListBox
      AlignWithMargins = True
      Left = 5
      Top = 68
      Width = 352
      Height = 127
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
