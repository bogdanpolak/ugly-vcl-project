program BooksManager;

uses
  Vcl.Forms,
  Form.Main in 'Form.Main.pas' {Form1},
  Frame.Welcome in 'Frame.Welcome.pas' {FrameWelcome: TFrame},
  Consts.Application in 'Consts.Application.pas',
  Utils.CipherAES128 in 'Utils.CipherAES128.pas',
  Frame.Import in 'Frame.Import.pas' {FrameImport: TFrame},
  Utils.General in 'Utils.General.pas',
  Data.Main in 'Data.Main.pas' {DataModMain: TDataModule},
  Utils.Messages in 'Utils.Messages.pas',
  Vcl.Themes,
  Vcl.Styles,
  DataAccess.Base in 'experimental\DataAccess.Base.pas',
  DataAccess.Books in 'experimental\DataAccess.Books.pas',
  DataAccess.Books.FireDAC in 'experimental\DataAccess.Books.FireDAC.pas',
  ClientAPI.Books in 'api\ClientAPI.Books.pas',
  ClientAPI.Readers in 'api\ClientAPI.Readers.pas',
  ExtGUI.ListBox.Books in 'ExtGUI.ListBox.Books.pas',
  Consts.SQL in 'Consts.SQL.pas',
  Data.UpgradeDatabase in 'Data.UpgradeDatabase.pas' {UpgradeDataModule: TDataModule},
  CloudBooks.Reviews_ in 'api\CloudBooks.Reviews_.pas' {CloudBooksDM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModMain, DataModMain);
  Application.CreateForm(TUpgradeDataModule, UpgradeDataModule);
  Application.CreateForm(TCloudBooksDM, CloudBooksDM);
  Application.Run;
end.
