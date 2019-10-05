unit Data.UpgradeDatabase;

interface

uses
  System.SysUtils, System.Classes,
  FireDAC.UI.Intf, FireDAC.Stan.Async, FireDAC.Stan.Util, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.ScriptCommands, FireDAC.Comp.Script,
  FireDAC.VCLUI.Script, FireDAC.Comp.UI;

type
  TUpgradeDataModule = class(TDataModule)
    FDScriptBuild2001: TFDScript;
  private
    procedure BuildVersion2001;
  public
    procedure ExecuteUpgrade(CurrentDBVersion: integer);
  end;

var
  UpgradeDataModule: TUpgradeDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Data.Main;
{$R *.dfm}

procedure TUpgradeDataModule.BuildVersion2001;
begin
  with FDScriptBuild2001 do
  begin
    Connection := DataModMain.FDConnection1;
    ValidateAll;
    ExecuteAll;
  end;
end;

procedure TUpgradeDataModule.ExecuteUpgrade(CurrentDBVersion: integer);
begin
  if CurrentDBVersion = 0 then
    BuildVersion2001
  else if CurrentDBVersion < 2001 then
    BuildVersion2001
  else
    raise Exception.Create('Unsupported Database version');
    (*
    case CurrentDBVersion of
      2002: begin BuildVersion2003; BuildVersion2004; end;
      2003: begin BuildVersion2004; end;
      else raise Exception.Create('Unsupported Database version');
    end;
    *)
end;

end.
