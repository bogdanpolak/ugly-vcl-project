object DataModMain: TDataModMain
  OldCreateOrder = False
  Height = 216
  Width = 336
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 224
    Top = 144
  end
  object FDConnection1: TFDConnection
    LoginPrompt = False
    Left = 41
    Top = 16
  end
  object fdqBooks: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM Books')
    Left = 228
    Top = 75
  end
  object fdqReaders: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM Readers')
    Left = 36
    Top = 73
  end
  object fdqReports: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * FROM Reports')
    Left = 132
    Top = 74
  end
end
