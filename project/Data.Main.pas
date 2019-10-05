unit Data.Main;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Stan.StorageJSON, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite,
  FireDAC.DApt;

type
  TDataModMain = class(TDataModule)
  const
    ConnectionDefinitionName = 'SDB-Books';
    DBFileName = 'books.db3';
    AppUserName = 'booksapp';
    SecureKey = 'delphi-is-the-best';
    // SecurePassword = AES 128 ('masterkey',SecureKey)
    SecurePassword = 'hC52IiCv4zYQY2PKLlSvBaOXc14X41Mc1rcVS6kyr3M=';
  private
    FBaseDataDirecory: string;
  published
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDConnection1: TFDConnection;
    fdqBooks: TFDQuery;
    fdqReaders: TFDQuery;
    fdqReports: TFDQuery;
  public
    procedure DeleteDatabase;
    procedure SetupConnectionDefinition;
    procedure OpenConnection;
    procedure OpenDataSets;
    function GetDatabaseVersion: integer;
    function FindReaderByEmil(const email: string): Variant;
    { TODO 2: [Helper] Extract into TDataSet helper. This pollutes the Data Module public API }
    function GetMaxValueInDataSet(DataSet: TDataSet;
      const fieldName: string): integer;
    property BaseDataDirecory: string read FBaseDataDirecory
      write FBaseDataDirecory;
  end;

type
  EMainDatamoduleError = class(Exception)
  public
    MessageApplication: string;
    MessageFireDac: string;
    constructor CreateError(const msgApp: string; const msgFireDac: string);
  end;

var
  DataModMain: TDataModMain;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

uses
  System.Variants,
  Consts.SQL,
  Utils.CipherAES128,
  ClientAPI.Books;

resourcestring
  SDBServerGone = 'Database server is gone';
  SDBCantDeleteFile = 'Can''t remove database file.' +
    'Access to a file is locked by other application.';
  SDBConnectionUserPwdInvalid = 'Invalid database configuration.' +
    ' Application database user or password is incorrect.';
  SDBConnectionError = 'Can''t connect to database server. Unknown error.';
  SDBRequireCreate = 'Database is empty. You need to execute script' +
    ' creating required data.';
  SDBErrorSelect = 'Can''t execute SELECT command on the database';
  StrNotSupportedDBVersion = 'Not supported database version. Please' +
    ' update database structures.';

procedure TDataModMain.DeleteDatabase;
begin
  if FileExists(BaseDataDirecory + DBFileName) then
    DeleteFile(BaseDataDirecory + DBFileName);
  if FileExists(BaseDataDirecory + DBFileName) then
    raise EMainDatamoduleError.CreateError(SDBCantDeleteFile,
      'File asses error.');
end;

procedure TDataModMain.SetupConnectionDefinition;
var
  ConnDef: IFDStanConnectionDef;
begin
  ConnDef := FDManager.ConnectionDefs.FindConnectionDef
    (ConnectionDefinitionName);
  if Assigned(ConnDef) then
  begin
    if ConnDef.Params.Database <> BaseDataDirecory + DBFileName then
    begin
      ConnDef.Params.Database := BaseDataDirecory + DBFileName;
      ConnDef.Apply;
    end;
  end
  else
  begin
    ConnDef := FDManager.ConnectionDefs.AddConnectionDef;
    ConnDef.Name := ConnectionDefinitionName;
    with TFDPhysSQLiteConnectionDefParams(ConnDef.Params) do
    begin
      DriverID := 'SQLite';
      Database := BaseDataDirecory + DBFileName;
      UserName := AppUserName;
      OpenMode := omCreateUTF8;
    end;
    ConnDef.MarkPersistent;
    ConnDef.Apply;
  end;
  FDConnection1.ConnectionDefName := ConnectionDefinitionName;
end;

procedure TDataModMain.OpenConnection;
var
  uname: string;
  password: string;
begin
  uname := FDManager.ConnectionDefs.ConnectionDefByName
    (ConnectionDefinitionName).Params.UserName;
  password := AES128_Decrypt(SecurePassword, SecureKey);
  try
    FDConnection1.Open(uname + password, '');
  except
    on E: EFDDBEngineException do
    begin
      case E.kind of
        ekUserPwdInvalid:
          raise EMainDatamoduleError.CreateError(SDBConnectionUserPwdInvalid,
            E.Message);
        ekServerGone:
          raise EMainDatamoduleError.CreateError(SDBServerGone, E.Message);
      else
        raise EMainDatamoduleError.CreateError(SDBConnectionError, E.Message);
      end;
    end;
  end;
end;

procedure TDataModMain.OpenDataSets;
begin
  fdqReaders.Open;
  fdqBooks.Open;
  fdqReports.Open;
end;

function TDataModMain.GetDatabaseVersion: integer;
begin
  try
    Result := FDConnection1.ExecSQLScalar(SQL_SELECT_DatabaseVersion);
  except
    on E: EFDDBEngineException do
    begin
      if E.kind = ekObjNotExists then
        Result := 0
      else
        raise EMainDatamoduleError.CreateError(SDBErrorSelect, E.Message);
    end;
  end;
end;

function TDataModMain.FindReaderByEmil(const email: string): Variant;
var
  ok: Boolean;
begin
  ok := fdqReaders.Locate('email', email, []);
  if ok then
    Result := fdqReaders.FieldByName('ReaderId').Value
  else
    Result := System.Variants.Null()
end;

function TDataModMain.GetMaxValueInDataSet(DataSet: TDataSet;
  const fieldName: string): integer;
var
  v: integer;
begin
  { TODO 2: [Helper] Extract into TDBGrid.ForEachRow class helper }
  Result := 0;
  DataSet.DisableControls;
  DataSet.First;
  while not DataSet.Eof do
  begin
    v := DataSet.FieldByName(fieldName).AsInteger;
    if v > Result then
      Result := v;
    DataSet.Next;
  end;
  DataSet.EnableControls;
end;

{ EMainDatamoduleError }

constructor EMainDatamoduleError.CreateError(const msgApp, msgFireDac: string);
begin
  Inherited Create(msgApp);
  MessageApplication := msgApp;
  MessageFireDac := msgFireDac;
end;

end.
