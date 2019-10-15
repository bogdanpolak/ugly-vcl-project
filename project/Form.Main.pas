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
  Cloud.Books.Reviews;

type
  TFrameClass = class of TFrame;

  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    lbBooksReaded: TLabel;
    Splitter1: TSplitter;
    lbBooksAvaliable: TLabel;
    lbxBooksReaded: TListBox;
    lbxBooksAvaliable2: TListBox;
    btnImport: TButton;
    tmrAppReady: TTimer;
    Splitter2: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure ChromeTabs1ButtonCloseTabClick(Sender: TObject; ATab: TChromeTab;
      var Close: Boolean);
    procedure ChromeTabs1Change(Sender: TObject; ATab: TChromeTab;
      TabChangeType: TTabChangeType);
    procedure FormResize(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure tmrAppReadyTimer(Sender: TObject);
  public
    pnMain: TPanel;
    ChromeTabs1: TChromeTabs;
  private
    FBooksConfig: TBooksListBoxConfigurator;
    CloudBookReviews: TCloudBookReviews;
    FApplicationInDeveloperMode: Boolean;
    procedure AutoSizeBooksGroupBoxes();
    procedure BuildDBGridForBooks_InternalQA(frm: TFrameWelcome);
    procedure BuildTabbedInterface;
    function ConstructNewVisualTab(FreameClass: TFrameClass;
      const Caption: string): TFrame;
    procedure OnFormReady;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  FireDAC.Stan.Error,
  Consts.Application,
  Utils.General,
  Frame.Import,
  Data.Main,
  Data.UpgradeDatabase;

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
  CloudBookReviews := TCloudBookReviews.Create(Self);
  BuildTabbedInterface;
end;

procedure TForm1.tmrAppReadyTimer(Sender: TObject);
begin
  tmrAppReady.Enabled := False;
  OnFormReady;
end;

procedure TForm1.OnFormReady();
var
  frm: TFrameWelcome;
  VersionNr: Integer;
begin
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
  // ----------------------------------------------------------
  //
  // TBooksListBoxConfigurator.PrepareListBoxes =
  //   1. Initialize ListBox'es for books
  //   2. (!!!!) Load books form database through experimental IBooksDAO
  //   3. Setup drag&drop functionality for two list boxes
  //   4. Setup OwnerDraw mode
  //
  FBooksConfig := TBooksListBoxConfigurator.Create(Self);
  FBooksConfig.PrepareListBoxes(lbxBooksReaded, lbxBooksAvaliable2);
  // ----------------------------------------------------------
  if FApplicationInDeveloperMode and InInternalQualityMode then
  begin
    BuildDBGridForBooks_InternalQA(frm);
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  AutoSizeBooksGroupBoxes();
end;

{ TODO 2: [Helper] TWinControl class helper }
function SumHeightForChildrens(Parent: TWinControl;
  ControlsToExclude: TArray<TControl>): Integer;
var
  i: Integer;
  ctrl: Vcl.Controls.TControl;
  isExcluded: Boolean;
  j: Integer;
  sumHeight: Integer;
  ctrlHeight: Integer;
begin
  sumHeight := 0;
  for i := 0 to Parent.ControlCount - 1 do
  begin
    ctrl := Parent.Controls[i];
    isExcluded := False;
    for j := 0 to Length(ControlsToExclude) - 1 do
      if ControlsToExclude[j] = ctrl then
        isExcluded := True;
    if not isExcluded then
    begin
      if ctrl.AlignWithMargins then
        ctrlHeight := ctrl.Height + ctrl.Margins.Top + ctrl.Margins.Bottom
      else
        ctrlHeight := ctrl.Height;
      sumHeight := sumHeight + ctrlHeight;
    end;
  end;
  Result := sumHeight;
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
    if dt>0 then Result := True else  Result := True;
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
  i: Integer;
  mm: Integer;
  yy: Integer;
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
    Rating: Integer;
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

function RatingsToString(const ARattings: array of Integer): string;
var
  i: Integer;
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

{ TODO 2: [A] Method is too large. Comments is showing separate methods }
procedure TForm1.btnImportClick(Sender: TObject);
var
  b: TBook;
  jsBookReviews: TJSONArray;
  jsBook: TJSONObject;
  jsReviewers: TJSONArray;
  i: Integer;
  j: Integer;
  jsReviewer: TJSONObject;
  Review: TReview;
  isbn: string;
  AllRatings: array of Integer;
  RatingsAsString: string;

  frm: TFrameImport;
  DBGrid1: TDBGrid;
  DataSrc1: TDataSource;
  DBGrid2: TDBGrid;
  DataSrc2: TDataSource;
begin
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  //
  // Get Book Reviews from Cloud as TJSONArray
  //
  jsBookReviews := CloudBookReviews.ConstructAndGetReviews('2019-08-01');
  try
    // ----------------------------------------------------------
    // ----------------------------------------------------------
    //
    // Import new Books from json data
    //
    { TODO 2: [A] Extract method. Read comments and use meaningful name }
    for i := 0 to jsBookReviews.Count - 1 do
    begin
      jsBook := jsBookReviews.Items[i] as TJSONObject;
      isbn := jsBook.Values['isbn'].Value;
      if FBooksConfig.GetBookList(blkAll).FindByISBN(isbn) = nil then
      begin
        b := TBook.Create;
        b.title := jsBook.Values['title'].Value;
        b.isbn := jsBook.Values['isbn'].Value;
        b.author := jsBook.Values['author'].Value;
        b.releseDate := BooksToDateTime(jsBook.Values['date'].Value);
        b.pages := (jsBook.Values['pages'] as TJSONNumber).AsInt;
        b.price := StrToCurr(jsBook.Values['price'].Value);
        b.currency := jsBook.Values['currency'].Value;
        b.description := jsBook.Values['description'].Value;
        b.imported := Now();
        FBooksConfig.InsertNewBook(b);
        // ----------------------------------------------------------------
        // Append report into the database:
        // Fields: ISBN, Title, Authors, Status, ReleseDate, Pages, Price,
        // Currency, Imported, Description
        DataModMain.fdqBooks.InsertRecord([b.isbn, b.title, b.author, b.status,
          b.releseDate, b.pages, b.price, b.currency, b.imported,
          b.description]);
      end;
      jsReviewers := jsBook.Values['reviews'] as TJSONArray;
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
        DataModMain.fdqReports.AppendRecord([Review.ReporterID, isbn,
          Review.Rating, Review.Oppinion, Review.Registered]);
        // ----------------------------------------------------------------
        Insert([Review.Rating], AllRatings, maxInt);
      end;
    end;
    RatingsAsString := RatingsToString(AllRatings);
  finally
    jsBookReviews.Free;
  end;
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  //
  // Create and show import frame
  frm := ConstructNewVisualTab(TFrameImport, 'Readers') as TFrameImport;
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  //
  // Dynamically Add TDBGrid to TFrameImport
  //
  { TODO 2: [C] Move code down separate bussines logic from GUI }
  // warning for dataset dependencies, discuss TDBGrid dependencies
  DataSrc1 := TDataSource.Create(frm);
  DBGrid1 := TDBGrid.Create(frm);
  DBGrid1.AlignWithMargins := True;
  DBGrid1.Parent := frm;
  DBGrid1.Align := Vcl.Controls.alClient;
  DBGrid1.DataSource := DataSrc1;
  DataSrc1.DataSet := DataModMain.fdqReaders;
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
  DataSrc2 := TDataSource.Create(frm);
  DBGrid2 := TDBGrid.Create(frm);
  DBGrid2.AlignWithMargins := True;
  DBGrid2.Parent := frm;
  DBGrid2.Align := alBottom;
  DBGrid2.Height := frm.Height div 3;
  DBGrid2.DataSource := DataSrc2;
  DataSrc2.DataSet := DataModMain.fdqReports;
  DBGrid2.Margins.Top := 0;
  AutoSizeColumns(DBGrid2);
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

procedure TForm1.AutoSizeBooksGroupBoxes();
var
  sum: Integer;
  avaliable: Integer;
  labelPixelHeight: Integer;
begin
  { TODO 3: Move into TBooksListBoxConfigurator }
  with TBitmap.Create do
  begin
    Canvas.Font.Size := GroupBox1.Font.Height;
    labelPixelHeight := Canvas.TextHeight('Zg');
    Free;
  end;
  sum := SumHeightForChildrens(GroupBox1, [lbxBooksReaded, lbxBooksAvaliable2]);
  avaliable := GroupBox1.Height - sum - labelPixelHeight;
  if GroupBox1.AlignWithMargins then
    avaliable := avaliable - GroupBox1.Padding.Top - GroupBox1.Padding.Bottom;
  if lbxBooksReaded.AlignWithMargins then
    avaliable := avaliable - lbxBooksReaded.Margins.Top -
      lbxBooksReaded.Margins.Bottom;
  if lbxBooksAvaliable2.AlignWithMargins then
    avaliable := avaliable - lbxBooksAvaliable2.Margins.Top -
      lbxBooksAvaliable2.Margins.Bottom;
  lbxBooksReaded.Height := avaliable div 2;
end;

procedure TForm1.Splitter1Moved(Sender: TObject);
begin
  (Sender as TSplitter).Tag := 1;
end;

end.
