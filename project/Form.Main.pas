﻿unit Form.Main;

interface

{ $DEFINE UseChromeTabs }

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.StrUtils,
  System.DateUtils, System.IOUtils, System.Math,
  System.Generics.Collections,
  System.JSON,
  System.RegularExpressions,
  Data.DB,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.ActnList,
{$IFDEF UseChromeTabs}
  ChromeTabs, ChromeTabsClasses, ChromeTabsTypes,
{$ENDIF}
  Frame.Welcome,
  Cloud.Books.Reviews,
  Vcl.Pattern.Command,
  Command.ImportBooks,
  Helper.TApplication;

type
  TFrameClass = class of TFrame;

  TForm1 = class(TForm)
  published
    btnBooksfelfs: TButton;
    btnBooksCatalog: TButton;
    btnReviewsCatalog: TButton;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    btnImport: TButton;
    tmrAppReady: TTimer;
    Splitter2: TSplitter;
    grbxImportProgress: TGroupBox;
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    tmrIdle: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrAppReadyTimer(Sender: TObject);
    procedure tmrIdleTimer(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure btnBooksfelfsClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnBooksCatalogClick(Sender: TObject);
    procedure btnReviewsCatalogClick(Sender: TObject);

  const
    FirstMonthToFetchBooksData = 8; { 8, 9, 10-empty data }
  public
    pnMain: TPanel;
  private
    Ratings: TRatings;
    SynchonizationInfo: TSynchonizationInfo;
    CloudBookReviews: TCloudBookReviews;
    FApplicationInDeveloperMode: Boolean;
    FrameCounter: Integer;
{$IFDEF UseChromeTabs}
    ChromeTabs1: TChromeTabs;
    procedure ChromeTabs1ButtonCloseTabClick(Sender: TObject; ATab: TChromeTab;
      var Close: Boolean);
    procedure ChromeTabs1Change(Sender: TObject; ATab: TChromeTab;
      TabChangeType: TTabChangeType);
{$ELSE}
    MainPageControl: TPageControl;
{$ENDIF}
    procedure OnFormReady;
    procedure BuildDBGridForBooks_InternalQA(frm: TFrameWelcome);
    procedure BuildTabbedInterface;
    function FindFrameInTabs(const TabCaption: string): TFrame;
    function ConstructNewVisualTab(FreameClass: TFrameClass;
      const Caption: string): TFrame;
    procedure ShitchToTab(frm: TFrame);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  FireDAC.Stan.Error,
  Consts.Application,
  Utils.General,
  Data.Main,
  Data.UpgradeDatabase,
  ExtGUI.ListBox.Books,
  Frame.Bookshelfs,
  Frame.Base;

const
  Client_API_Token = '20be805d-9cea27e2-a588efc5-1fceb84d-9fb4b67c';

resourcestring
  SWelcomeScreen = 'Welcome screen';
  StrNotSupportedDBVersion = 'Not supported database version. Please' +
    ' update database structures.';

function DBVersionToString(VerDB: Integer): string;
begin
  Result := (VerDB div 1000).ToString + '.' + (VerDB mod 1000).ToString;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Extention: string;
  ExeName: string;
  ProjectFileName: string;
begin
  // ----------------------------------------------------------
  // Check: If we are in developer mode
  //
  // Developer mode id used to change application configuration
  // during test
  { TODO 2: [Helper] TApplication.IsDeveloperMode }
{$IFDEF DEBUG}
  Extention := '.dpr';
  ExeName := ExtractFileName(Application.ExeName);
  ProjectFileName := ChangeFileExt(ExeName, Extention);
  FApplicationInDeveloperMode := FileExists(ProjectFileName) or
    FileExists('..\..\' + ProjectFileName);
{$ELSE}
  // To rename attribute (variable in the object) FDevMod I'm using buiid in
  // IDE refactoring which is great, but be aware:
  // Refactoring [Rename Variable] can't find this place :-(
  FDevMod := False;
{$ENDIF}
  if FApplicationInDeveloperMode then
    ReportMemoryLeaksOnShutdown := True;

  SynchonizationInfo := TSynchonizationInfo.Create;
  Ratings := TRatings.Create;
  CloudBookReviews := TCloudBookReviews.Create(Self);
  BuildTabbedInterface;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SynchonizationInfo.Free;
  Ratings.Free;
end;

procedure TForm1.tmrAppReadyTimer(Sender: TObject);
begin
  tmrAppReady.Enabled := False;
  OnFormReady;
  tmrIdle.Enabled := True;
end;

procedure TForm1.tmrIdleTimer(Sender: TObject);
begin
  if grbxImportProgress.Tag > 0 then
  begin
    grbxImportProgress.Tag := grbxImportProgress.Tag - 1;
    grbxImportProgress.Visible := (grbxImportProgress.Tag > 0);
  end;
end;

procedure TForm1.OnFormReady();
var
  frm: TFrameWelcome;
  VersionNr: Integer;
begin
  FrameCounter := 0;
  SynchonizationInfo.LastDay := EncodeDate(2019, FirstMonthToFetchBooksData, 1);
  // ----------------------------------------------------------
  grbxImportProgress.Visible := False;
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  //
  // Create and show Welcome Frame
  //
  frm := ConstructNewVisualTab(TFrameWelcome, 'Welcome') as TFrameWelcome;
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  //
  // 1. Delete SQLite database file (demo application)
  // 2. Check ConnectionDefifnion / define if not avaliable
  // 3. Open connection - connect to database server
  // 4. Read Database Version from SQL server
  // 5. Upgrade DB structureto current version or build it from scratch
  // 3.
  //
  DataModMain.BaseDataDirecory := ExtractFilePath(Application.ExeName);
  try
    DataModMain.DeleteDatabase();
  except
    on E: EMainDatamoduleError do
    begin
      frm.AddInfo(0, E.MessageApplication, True);
      frm.AddInfo(1, E.MessageFireDac, False);
      exit;
    end;
  end;
  DataModMain.SetupConnectionDefinition();
  try
    DataModMain.OpenConnection;
  except
    on E: EMainDatamoduleError do
    begin
      frm.AddInfo(0, E.MessageApplication, True);
      frm.AddInfo(1, E.MessageFireDac, False);
      exit;
    end;
  end;
  VersionNr := DataModMain.GetDatabaseVersion;
  if VersionNr < ExpectedDatabaseVersionNr then
    UpgradeDataModule.ExecuteUpgrade(VersionNr)
  else if VersionNr > ExpectedDatabaseVersionNr then
  begin
    frm.AddInfo(0, StrNotSupportedDBVersion, True);
    frm.AddInfo(1, 'Current supported version by application: ' +
      DBVersionToString(ExpectedDatabaseVersionNr), True);
    frm.AddInfo(1, 'Database version: ' + DBVersionToString(VersionNr), True);
  end;
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  //
  DataModMain.OpenDataSets;
  // ----------------------------------------------------------
  if FApplicationInDeveloperMode and InInternalQualityMode then
  begin
    BuildDBGridForBooks_InternalQA(frm);
  end;
end;

procedure TForm1.ShitchToTab(frm: TFrame);
{$IFDEF UseChromeTabs}
var
  i: Integer;
{$ENDIF}
begin
{$IFDEF UseChromeTabs}
  // Activate ChoromeTab with frame "frm"
  for i := 0 to ChromeTabs1.Tabs.Count - 1 do
    if ChromeTabs1.Tabs[i].Data = frm then
      ChromeTabs1.Tabs[i].Active := True;
  HideAllChildFrames(pnMain);
  frm.Visible := True;
{$ENDIF}
end;

{ TODO 2: [Helper] Extract into TDBGrid.ForEachRow class helper }
function AutoSizeColumns(DBGrid: TDBGrid; const MaxRows: Integer = 25): Integer;
var
  DataSet: TDataSet;
  Bookmark: TBookmark;
  Count, i: Integer;
  ColumnsWidth: array of Integer;
begin
  SetLength(ColumnsWidth, DBGrid.Columns.Count);
  for i := 0 to DBGrid.Columns.Count - 1 do
    if DBGrid.Columns[i].Visible then
      ColumnsWidth[i] := DBGrid.Canvas.TextWidth
        (DBGrid.Columns[i].title.Caption + '   ')
    else
      ColumnsWidth[i] := 0;
  if DBGrid.DataSource <> nil then
    DataSet := DBGrid.DataSource.DataSet
  else
    DataSet := nil;
  if (DataSet <> nil) and DataSet.Active then
  begin
    Bookmark := DataSet.GetBookmark;
    DataSet.DisableControls;
    try
      Count := 0;
      DataSet.First;
      while not DataSet.Eof and (Count < MaxRows) do
      begin
        for i := 0 to DBGrid.Columns.Count - 1 do
          if DBGrid.Columns[i].Visible then
            ColumnsWidth[i] := System.Math.Max(ColumnsWidth[i],
              DBGrid.Canvas.TextWidth(DBGrid.Columns[i].Field.Text + '   '));
        Inc(Count);
        DataSet.Next;
      end;
    finally
      DataSet.GotoBookmark(Bookmark);
      DataSet.FreeBookmark(Bookmark);
      DataSet.EnableControls;
    end;
  end;
  Count := 0;
  for i := 0 to DBGrid.Columns.Count - 1 do
    if DBGrid.Columns[i].Visible then
    begin
      DBGrid.Columns[i].Width := ColumnsWidth[i];
      Inc(Count, ColumnsWidth[i]);
    end;
  Result := Count - DBGrid.ClientWidth;
end;

// ----------------------------------------------------------
//
// Function checks is TJSONValue has field and this field has not null value
//
{ TODO 2: [Helper] TJSONValue Class helpper and more minigful name expected }
function fieldAvaliable(jsValue: TJSONValue): Boolean;
begin
  Result := Assigned(jsValue) and not jsValue.Null;
end;

{ TODO 2: [Helper] TJSONValue Class helpper and this method has two responsibilities }
function JsonValueIsIsoDate(jsValue: TJSONValue): Boolean;
var
  dt: TDateTime;
begin
  try
    dt := System.DateUtils.ISO8601ToDate(jsValue.Value, False);
    if dt > 0 then
      Result := True
    else
      Result := True;
  except
    on E: Exception do
      Result := False;
  end
end;

function JsonValueAsIsoDate(jsValue: TJSONValue): TDateTime;
begin
  Result := System.DateUtils.ISO8601ToDate(jsValue.Value, False);
end;

{$IFDEF UseChromeTabs}

function TForm1.ConstructNewVisualTab(FreameClass: TFrameClass;
  const Caption: string): TFrame;
var
  tab: TChromeTab;
begin
  Result := FreameClass.Create(pnMain);
  with Result do
  begin
    Parent := pnMain;
    Visible := True;
    Align := Vcl.Controls.alClient;
    Inc(FrameCounter);
    Name := Name + FrameCounter.ToString;
  end;
  tab := ChromeTabs1.Tabs.Add;
  tab.Caption := Caption;
  tab.Data := Result;
end;

function TForm1.FindFrameInTabs(const TabCaption: string): TFrame;
var
  i: Integer;
  AObj: TObject;
  ATab: TChromeTab;
begin
  for i := 0 to ChromeTabs1.Tabs.Count - 1 do
  begin
    ATab := ChromeTabs1.Tabs[i];
    AObj := TObject(ATab.Data);
    if (ATab.Caption = TabCaption) and (AObj <> nil) then
    begin
      Result := AObj as TFrame;
      exit;
    end;
  end;
  Result := nil;
end;

{$ELSE}

function TForm1.ConstructNewVisualTab(FreameClass: TFrameClass;
  const Caption: string): TFrame;
var
  tabsh: TTabSheet;
begin
  tabsh := TTabSheet.Create(MainPageControl);
  tabsh.PageControl := MainPageControl;
  tabsh.Caption := Caption;
  MainPageControl.ActivePage := tabsh;
  Result := FreameClass.Create(tabsh);
  with Result do
  begin
    Parent := tabsh;
    Visible := True;
    Align := Vcl.Controls.alClient;
    Inc(FrameCounter);
    Name := Name + FrameCounter.ToString;
  end;
end;

function TForm1.FindFrameInTabs(const TabCaption: string): TFrame;
begin
  Result := TBookImportCommand.FindFrameInTabs(MainPageControl, TabCaption);
end;

{$ENDIF}

procedure TForm1.BuildDBGridForBooks_InternalQA(frm: TFrameWelcome);
var
  datasrc: TDataSource;
  DataGrid: TDBGrid;
begin
  datasrc := TDataSource.Create(frm);
  DataGrid := TDBGrid.Create(frm);
  DataGrid.AlignWithMargins := True;
  DataGrid.Parent := frm;
  DataGrid.Align := alClient;
  DataGrid.DataSource := datasrc;
  datasrc.DataSet := DataModMain.fdqBooks;
  AutoSizeColumns(DataGrid);
end;

procedure TForm1.btnImportClick(Sender: TObject);
begin
  // ----------------------------------------------------------
  //
  // Logger: messages in TGroupBox durring get books from REST server
  //
  grbxImportProgress.Visible := True;
  grbxImportProgress.Tag := 9999;
  with ProgressBar1 do
  begin
    Position := 0;
    Max := 99;
    Step := 1;
  end;
  Application.ProcessMessages;
  // ----------------------------------------------------------
  TCommandVclFactory.ExecuteCommand<TBookImportCommand>
    ([MainPageControl, CloudBookReviews, SynchonizationInfo, ProgressBar1,
    DataModMain, Ratings]);
  // ----------------------------------------------------------
  Label2.Caption := 'Imported books ratings:' + sLineBreak + Ratings.ToString;
  if Application.InDeveloperMode then
    Caption := Ratings.ToString();
  grbxImportProgress.Tag := 80;
end;

procedure TForm1.btnBooksfelfsClick(Sender: TObject);
var
  frm: TBookshelfsFrame;
begin
  frm := FindFrameInTabs('My Bookshelf') as TBookshelfsFrame;
  if frm <> nil then
    ShitchToTab(frm)
  else
    ConstructNewVisualTab(TBookshelfsFrame, 'My Bookshelf');
end;

procedure TForm1.btnBooksCatalogClick(Sender: TObject);
var
  frm: TBaseFrame;
  DBGrid1: TDBGrid;
begin
  frm := FindFrameInTabs('Books catalog') as TBaseFrame;
  if frm = nil then
  begin
    frm := ConstructNewVisualTab(TBaseFrame, 'Books catalog') as TBaseFrame;
    DBGrid1 := TDBGrid.Create(frm);
    DBGrid1.AlignWithMargins := True;
    DBGrid1.Parent := frm;
    DBGrid1.Align := Vcl.Controls.alClient;
    DBGrid1.DataSource := TDataSource.Create(frm);
    DBGrid1.DataSource.DataSet := DataModMain.fdqBooks;
    AutoSizeColumns(DBGrid1);
  end
  else
    ShitchToTab(frm);
end;

procedure TForm1.btnReviewsCatalogClick(Sender: TObject);
var
  frm: TBaseFrame;
  DBGrid1: TDBGrid;
  DBGrid2: TDBGrid;
begin
  frm := FindFrameInTabs('Reviews catalog') as TBaseFrame;
  if frm = nil then
  begin
    frm := ConstructNewVisualTab(TBaseFrame, 'Reviews catalog') as TBaseFrame;
    // ----------------------------------------------------------
    DBGrid1 := TDBGrid.Create(frm);
    DBGrid1.AlignWithMargins := True;
    DBGrid1.Parent := frm;
    DBGrid1.Align := Vcl.Controls.alClient;
    DBGrid1.DataSource := TDataSource.Create(frm);
    DBGrid1.DataSource.DataSet := DataModMain.fdqReaders;
    AutoSizeColumns(DBGrid1);
    DBGrid1.Margins.Bottom := 0;
    // ----------------------------------------------------------------
    with TSplitter.Create(frm) do
    begin
      Align := alBottom;
      Parent := frm;
      Height := 5;
    end;
    // ----------------------------------------------------------------
    DBGrid2 := TDBGrid.Create(frm);
    DBGrid2.AlignWithMargins := True;
    DBGrid2.Parent := frm;
    DBGrid2.Align := alBottom;
    DBGrid2.Height := frm.Height div 3;
    DBGrid2.DataSource := TDataSource.Create(frm);
    DBGrid2.DataSource.DataSet := DataModMain.fdqReports;
    DBGrid2.Margins.Top := 0;
    AutoSizeColumns(DBGrid2);
  end
  else
    ShitchToTab(frm);
end;

{$IFDEF UseChromeTabs}

procedure TForm1.ChromeTabs1ButtonCloseTabClick(Sender: TObject;
  ATab: TChromeTab; var Close: Boolean);
var
  obj: TObject;
begin
  obj := TObject(ATab.Data);
  (obj as TFrame).Free;
end;

procedure TForm1.ChromeTabs1Change(Sender: TObject; ATab: TChromeTab;
  TabChangeType: TTabChangeType);
var
  obj: TObject;
begin
  if Assigned(ATab) then
  begin
    obj := TObject(ATab.Data);
    if (TabChangeType = tcActivated) and Assigned(obj) then
    begin
      HideAllChildFrames(pnMain);
      (obj as TFrame).Visible := True;
    end;
  end;
end;
{$ENDIF}
{$IFDEF UseChromeTabs}

procedure TForm1.BuildTabbedInterface;
begin
  pnMain := TPanel.Create(Self);
  with pnMain do
  begin
    Parent := Self;
    AlignWithMargins := True;
    Margins.Left := 0;
    Align := alClient;
    BevelOuter := bvNone;
    Caption := '';
  end;
  ChromeTabs1 := TChromeTabs.Create(pnMain);
  with ChromeTabs1 do
  begin
    Parent := pnMain;
    AlignWithMargins := True;
    // Height = 30
    OnChange := ChromeTabs1Change;
    OnButtonCloseTabClick := ChromeTabs1ButtonCloseTabClick;
    Align := alTop
  end;
end;

{$ELSE}

procedure TForm1.BuildTabbedInterface;
begin
  MainPageControl := TPageControl.Create(Self);
  with MainPageControl do
  begin
    Parent := Self;
    Align := alClient;
    AlignWithMargins := True;
  end;
end;
{$ENDIF}

procedure TForm1.Splitter1Moved(Sender: TObject);
begin
  (Sender as TSplitter).Tag := 1;
end;

end.
