unit Form.Main;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes, System.StrUtils,
  System.DateUtils, System.IOUtils, System.Math,
  System.Generics.Collections,
  System.JSON,
  System.RegularExpressions,
  Data.DB,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  ChromeTabs, ChromeTabsClasses, ChromeTabsTypes,
  Frame.Welcome,
  {TODO 3: [D] Resolve dependency on ExtGUI.ListBox.Books. Too tightly coupled}
  // Dependency is requred by attribute TBooksListBoxConfigurator
  ExtGUI.ListBox.Books,
  Cloud.Books.Reviews, Vcl.ComCtrls;

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
    procedure tmrAppReadyTimer(Sender: TObject);
    procedure tmrIdleTimer(Sender: TObject);
    procedure ChromeTabs1ButtonCloseTabClick(Sender: TObject; ATab: TChromeTab;
      var Close: Boolean);
    procedure ChromeTabs1Change(Sender: TObject; ATab: TChromeTab;
      TabChangeType: TTabChangeType);
    procedure Splitter1Moved(Sender: TObject);
    procedure btnBooksfelfsClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnBooksCatalogClick(Sender: TObject);
    procedure btnReviewsCatalogClick(Sender: TObject);

  const
    FirstMonthToFetchBooksData = 8; { 8, 9, 10-empty data }
  public
    pnMain: TPanel;
    ChromeTabs1: TChromeTabs;
  private
    LastSynchonizationDay: TDateTime;
    CloudBookReviews: TCloudBookReviews;
    FApplicationInDeveloperMode: Boolean;
    procedure OnFormReady;
    procedure BuildDBGridForBooks_InternalQA(frm: TFrameWelcome);
    procedure BuildTabbedInterface;
    function FindFrameInTabs(FreameClass: TFrameClass;
      const Caption: string): TFrame;
    function FindTabsWithData(AData: Pointer): TChromeTab;
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
  Frame.Bookshelfs,
  Frame.Base;

const
  Client_API_Token = '20be805d-9cea27e2-a588efc5-1fceb84d-9fb4b67c';

resourcestring
  SWelcomeScreen = 'Welcome screen';
  StrNotSupportedDBVersion = 'Not supported database version. Please' +
    ' update database structures.';

function DBVersionToString(VerDB: integer): string;
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
  CloudBookReviews := TCloudBookReviews.Create(Self);
  BuildTabbedInterface;
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
  VersionNr: integer;
begin
  LastSynchonizationDay := EncodeDate(2019, FirstMonthToFetchBooksData, 1);
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
var
  tab: TChromeTab;
begin
  tab := FindTabsWithData(frm);
  tab.Active := True;
  HideAllChildFrames(pnMain);
  frm.Visible := True;
end;

{ TODO 2: [Helper] Extract into TDBGrid.ForEachRow class helper }
function AutoSizeColumns(DBGrid: TDBGrid; const MaxRows: integer = 25): integer;
var
  DataSet: TDataSet;
  Bookmark: TBookmark;
  Count, i: integer;
  ColumnsWidth: array of integer;
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

function BooksToDateTime(const s: string): TDateTime;
const
  months: array [1 .. 12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
var
  m: string;
  y: string;
  i: integer;
  mm: integer;
  yy: integer;
begin
  m := s.Substring(0, 3);
  y := s.Substring(4);
  mm := 0;
  for i := 1 to 12 do
    if months[i].ToUpper = m.ToUpper then
      mm := i;
  if mm = 0 then
    raise ERangeError.Create('Incorect mont name in the date: ' + s);
  yy := y.ToInteger();
  Result := EncodeDate(yy, mm, 1);
end;

function TForm1.FindFrameInTabs(FreameClass: TFrameClass;
  const Caption: string): TFrame;
var
  i: integer;
  ATab: TChromeTab;
  AObj: TObject;
begin
  for i := 0 to ChromeTabs1.Tabs.Count - 1 do
  begin
    ATab := ChromeTabs1.Tabs[i];
    AObj := TObject(ATab.Data);
    if (ATab.Caption = Caption) and (AObj <> nil) and
      (AObj.ClassType = FreameClass) then
    begin
      Result := AObj as TFrame;
      exit;
    end;
  end;
  Result := nil;
end;

function TForm1.FindTabsWithData(AData: Pointer): TChromeTab;
var
  i: integer;
begin
  for i := 0 to ChromeTabs1.Tabs.Count - 1 do
    if ChromeTabs1.Tabs[i].Data = AData then
    begin
      Result := ChromeTabs1.Tabs[i];
      exit;
    end;
  Result := nil;
end;

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
  end;
  tab := ChromeTabs1.Tabs.Add;
  tab.Caption := Caption;
  tab.Data := Result;
end;

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

type
  TReview = record
    ReporterID: string;
    FirstName: string;
    LastName: string;
    Contact: string;
    Registered: TDateTime;
    Rating: integer;
    Oppinion: string;
  end;

procedure ValidateJsonReviewer(jsReviewer: TJSONObject);
var
  isValid: Boolean;
begin
  isValid := jsReviewer.Values['rating'] is TJSONNumber and
    JsonValueIsIsoDate(jsReviewer.Values['registered']);
  if not isValid then
    raise Exception.Create('Invalid reviewer JOSN record: ' +
      jsReviewer.ToString);
end;

function RatingsToString(const ARattings: array of integer): string;
var
  i: integer;
begin
  Result := '[';
  for i := 0 to Length(ARattings) - 1 do
  begin
    if i = 0 then
      Result := Result + ARattings[i].ToString
    else
      Result := Result + ', ' + ARattings[i].ToString;
  end;
  Result := Result + ']';
end;

procedure TForm1.btnBooksfelfsClick(Sender: TObject);
var
  frm: TBookshelfsFrame;
begin
  frm := FindFrameInTabs(TBookshelfsFrame, 'Bookshelfs') as TBookshelfsFrame;
  if frm <> nil then
    ShitchToTab(frm)
  else
    ConstructNewVisualTab(TBookshelfsFrame, 'Bookshelfs');
end;

procedure TForm1.btnBooksCatalogClick(Sender: TObject);
var
  frm: TBaseFrame;
  DBGrid1: TDBGrid;
begin
  frm := FindFrameInTabs(TBaseFrame, 'Books catalog') as TBaseFrame;
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

procedure TForm1.btnImportClick(Sender: TObject);
var
  BookReviewsCatalog: TArray<TReviewCatalogItem>;
  BooksCounter: integer;
  b: TBook;
  StrBookReview: string;
  jsBookReview: TJSONObject;
  jsReviewers: TJSONArray;
  i: integer;
  j: integer;
  jsReviewer: TJSONObject;
  Review: TReview;
  AllRatings: array of integer;
  RatingsAsString: string;
  FrameBookshelfs: TBookshelfsFrame;
begin
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  //
  // Visual raport TGroupBox
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
  FrameBookshelfs := FindFrameInTabs(TBookshelfsFrame, 'Bookshelfs')
    as TBookshelfsFrame;
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  //
  // Get Book Reviews from Cloud as TJSONArray
  //
  BookReviewsCatalog := CloudBookReviews.GetCatalog(LastSynchonizationDay);
  LastSynchonizationDay := IncMonth(LastSynchonizationDay, 1);
  BooksCounter := Length(BookReviewsCatalog);
  ProgressBar1.Max := BooksCounter;
  for i := 0 to BooksCounter - 1 do
  begin
    StrBookReview := CloudBookReviews.GetReview
      (BookReviewsCatalog[i].BookReviewID);
    ProgressBar1.StepIt;
    Application.ProcessMessages;
    jsBookReview := TJSONObject.ParseJSONValue(StrBookReview) as TJSONObject;
    b := TBook.Create;
    try
      // ----------------------------------------------------------
      // ----------------------------------------------------------
      //
      // Import new Book Review from json data
      //
      { TODO 2: [A] Extract method. Read comments and use meaningful name }
      b.title := jsBookReview.Values['title'].Value;
      b.isbn := jsBookReview.Values['isbn'].Value;
      b.author := jsBookReview.Values['author'].Value;
      // potnecial memory leaks - if exceptiom will be raised
      b.releseDate := BooksToDateTime(jsBookReview.Values['date'].Value);
      // potnecial memory leaks - if exceptiom will be raised
      b.pages := (jsBookReview.Values['pages'] as TJSONNumber).AsInt;
      // potnecial memory leaks - if exceptiom will be raised
      b.price := StrToCurr(jsBookReview.Values['price'].Value);
      b.currency := jsBookReview.Values['currency'].Value;
      b.description := jsBookReview.Values['description'].Value;
      b.imported := Now();
      if not DataModMain.fdqBooks.Locate('ISBN', b.isbn, []) then
      begin
        if FrameBookshelfs <> nil then
        begin
          FrameBookshelfs.ListBoxConfigurator.InsertNewBook
            (TBook.CreateAndClone(b));
        end;
        // ----------------------------------------------------------------
        // Append report into the database:
        // Fields: ISBN, Title, Authors, Status, ReleseDate, Pages, Price,
        // Currency, Imported, Description
        DataModMain.fdqBooks.InsertRecord([b.isbn, b.title, b.author, b.status,
          b.releseDate, b.pages, b.price, b.currency, b.imported,
          b.description]);
      end;
      jsReviewers := jsBookReview.Values['reviews'] as TJSONArray;
      // ----------------------------------------------------------
      // ----------------------------------------------------------
      //
      // - Extract new Reviewers reports reviews (JSON)
      // - Validate JSON and insert new a Readers into the Database
      //
      for j := 0 to jsReviewers.Count - 1 do
      begin
        { TODO 3: [A] Extract Reader Report code into the record TReaderReport (model layer) }
        { TODO 2: [F] Repeated code. Violation of the DRY rule }
        // Use TJSONObject helper Values return Variant.Null
        // ----------------------------------------------------------------
        //
        // Read JSON object
        //
        { TODO 3: [A] Move this code into record TReaderReport.LoadFromJSON }
        jsReviewer := jsReviewers.Items[j] as TJSONObject;
        // ----------------------------------------------------------------
        ValidateJsonReviewer(jsReviewer);
        // ----------------------------------------------------------------
        with Review do
        begin
          ReporterID := jsReviewer.Values['reporter-id'].Value;
          Registered := JsonValueAsIsoDate(jsReviewer.Values['registered']);
          Rating := (jsReviewer.Values['rating'] as TJSONNumber).AsInt;
          // Contact: string;
          if fieldAvaliable(jsReviewer.Values['firstname']) then
            FirstName := jsReviewer.Values['firstname'].Value
          else
            FirstName := '';
          if fieldAvaliable(jsReviewer.Values['lastname']) then
            LastName := jsReviewer.Values['lastname'].Value
          else
            LastName := '';
          if fieldAvaliable(jsReviewer.Values['review']) then
            Oppinion := jsReviewer.Values['review'].Value
          else
            Oppinion := '';
        end;
        // ----------------------------------------------------------------
        // Find the Reader / Reporter in then database using an ID
        // Append a new reader into the database if requred:
        // ----------------------------------------------------------------
        if not DataModMain.IsReaderExists(Review.ReporterID) then
        begin
          //
          // Fields: ReaderId, FirstName, LastName, Email, Company, BooksRead,
          // LastReport, ReadersCreated
          //
          DataModMain.fdqReaders.AppendRecord
            ([Review.ReporterID, Review.FirstName, Review.LastName, Null,
            Review.Registered]);
        end;
        // ----------------------------------------------------------------
        //
        // Append report into the database:
        // Fields: ReaderId, ISBN, Rating, Oppinion, Reported
        //
        DataModMain.fdqReports.AppendRecord([Review.ReporterID, b.isbn,
          Review.Rating, Review.Oppinion, Review.Registered]);
        // ----------------------------------------------------------------
        Insert([Review.Rating], AllRatings, maxInt);
      end;
    finally
      b.Free;
      jsBookReview.Free;
    end;
  end;
  RatingsAsString := RatingsToString(AllRatings);
  grbxImportProgress.Tag := 9999;
end;

procedure TForm1.btnReviewsCatalogClick(Sender: TObject);
begin
  (*
    frm: TFrameImport;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    // ----------------------------------------------------------
    // ----------------------------------------------------------
    //
    // Dynamically Add TDBGrid to TFrameImport
    //
    { TODO 2: [C] Move code down separate bussines logic from GUI }
    // warning for dataset dependencies, discuss TDBGrid dependencies
    DBGrid1 := TDBGrid.Create(frm);
    DBGrid1.AlignWithMargins := True;
    DBGrid1.Parent := frm;
    DBGrid1.Align := Vcl.Controls.alClient;
    DBGrid1.DataSource := TDataSource.Create(frm);
    DBGrid1.DataSource.DataSet := DataModMain.fdqReaders;
    AutoSizeColumns(DBGrid1);
    // ----------------------------------------------------------
    // ----------------------------------------------------------
    if FApplicationInDeveloperMode then
    Caption := RatingsAsString;
    // ----------------------------------------------------------------
    with TSplitter.Create(frm) do
    begin
    Align := alBottom;
    Parent := frm;
    Height := 5;
    end;
    DBGrid1.Margins.Bottom := 0;
    DBGrid2 := TDBGrid.Create(frm);
    DBGrid2.AlignWithMargins := True;
    DBGrid2.Parent := frm;
    DBGrid2.Align := alBottom;
    DBGrid2.Height := frm.Height div 3;
    DBGrid2.DataSource := TDataSource.Create(frm);
    DBGrid2.DataSource.DataSet := DataModMain.fdqReports;
    DBGrid2.Margins.Top := 0;
    AutoSizeColumns(DBGrid2);
  *)
end;

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


procedure TForm1.Splitter1Moved(Sender: TObject);
begin
  (Sender as TSplitter).Tag := 1;
end;

end.
