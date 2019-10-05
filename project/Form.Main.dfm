object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 431
  ClientWidth = 745
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter2: TSplitter
    Left = 238
    Top = 0
    Width = 5
    Height = 431
    ExplicitLeft = 193
    ExplicitHeight = 405
  end
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 2
    Width = 235
    Height = 426
    Margins.Top = 2
    Margins.Right = 0
    Align = alLeft
    Caption = 'Manager'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Padding.Left = 2
    Padding.Right = 2
    ParentFont = False
    TabOrder = 0
    object lbBooksReaded: TLabel
      AlignWithMargins = True
      Left = 7
      Top = 52
      Width = 221
      Height = 13
      Margins.Top = 6
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Readed Books:'
      ExplicitWidth = 72
    end
    object Splitter1: TSplitter
      Left = 4
      Top = 211
      Width = 227
      Height = 7
      Cursor = crVSplit
      Align = alTop
      OnMoved = Splitter1Moved
      ExplicitTop = 125
      ExplicitWidth = 190
    end
    object lbBooksAvaliable: TLabel
      AlignWithMargins = True
      Left = 7
      Top = 218
      Width = 221
      Height = 13
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      Caption = 'Avaliable Books:'
      ExplicitWidth = 78
    end
    object lbxBooksReaded: TListBox
      AlignWithMargins = True
      Left = 7
      Top = 68
      Width = 221
      Height = 143
      Margins.Bottom = 0
      Align = alTop
      ItemHeight = 13
      TabOrder = 0
    end
    object lbxBooksAvaliable2: TListBox
      AlignWithMargins = True
      Left = 7
      Top = 234
      Width = 221
      Height = 187
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
    end
    object btnImport: TButton
      AlignWithMargins = True
      Left = 7
      Top = 18
      Width = 221
      Height = 25
      Align = alTop
      Caption = 'btnImport'
      TabOrder = 2
      OnClick = btnImportClick
    end
  end
  object tmrAppReady: TTimer
    Interval = 1
    OnTimer = tmrAppReadyTimer
    Left = 320
    Top = 224
  end
end
