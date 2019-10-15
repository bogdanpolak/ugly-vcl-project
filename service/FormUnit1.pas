unit FormUnit1;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp, Vcl.ExtCtrls,
  Vcl.Menus;

type
  TForm1 = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    ApplicationEvents1: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    tmrAppStartup: TTimer;
    grbxPort: TGroupBox;
    grbxServerControls: TGroupBox;
    grbxOpenBrowser: TGroupBox;
    ListBox1: TListBox;
    Label1: TLabel;
    Shape1: TShape;
    pmnListbox: TPopupMenu;
    pmnItemCopyURL: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure tmrAppStartupTimer(Sender: TObject);
    procedure pmnItemCopyURLClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    procedure OnFormReady;
    procedure ExecuteOpenBrowser;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  System.Math,
  Winapi.Windows, Winapi.ShellApi,
  Vcl.Clipbrd;

procedure TForm1.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
  ButtonOpenBrowser.Enabled := FServer.Active;
  ListBox1.Enabled := FServer.Active;
  Shape1.Brush.Color := IfThen(FServer.Active, $70D060, $6060F0);
end;

procedure TForm1.ExecuteOpenBrowser();
var
  LURL: string;
begin
  LURL := Format('http://localhost:%s%s',
    [EditPort.Text, ListBox1.Items[ListBox1.ItemIndex]]);
  ShellExecute(0, nil, PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TForm1.ButtonOpenBrowserClick(Sender: TObject);
begin
  ExecuteOpenBrowser;
end;

procedure TForm1.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TForm1.ButtonStopClick(Sender: TObject);
begin
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  ExecuteOpenBrowser;
end;

procedure TForm1.OnFormReady;
begin
  ListBox1.ItemIndex := 0;
  StartServer;
end;

procedure TForm1.pmnItemCopyURLClick(Sender: TObject);
begin
  Clipboard.AsText := Format('http://localhost:%s%s',
    [EditPort.Text, ListBox1.Items[ListBox1.ItemIndex]]);
end;

procedure TForm1.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

procedure TForm1.tmrAppStartupTimer(Sender: TObject);
begin
  tmrAppStartup.Enabled := False;
  OnFormReady;
end;

end.
