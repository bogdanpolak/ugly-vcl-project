unit Command.ImportBooks;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Variants,
  System.Generics.Collections,
  Vcl.Pattern.Command,
  Vcl.Forms,
  Vcl.ComCtrls,

  Cloud.Books.Reviews,
  ExtGUI.ListBox.Books,
  Frame.Bookshelfs, Data.Main, Helper.TJSONObject, Helper.TApplication;

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

  TSynchonizationInfo = class
    LastDay: TDateTime;
  end;

  TRatings = class
    Values: array of Integer;
    function ToString: string; override;
  end;

  TBookImportCommand = class(TCommand)
  private
    FMainPageControl: TPageControl;
    FCloudBookReviews: TCloudBookReviews;
    FSynchonizationInfo: TSynchonizationInfo;
    FProgressBar1: TProgressBar;
    FDataModMain: TDataModMain;
    FRatings: TRatings;
  strict protected
    procedure Guard; override;
  public
    RatingsAsString: string;
    class function FindFrameInTabs(const MainPageControl: TPageControl;
      const TabCaption: string): TFrame;
    class function BooksToDateTime(const s: string): TDateTime;
    class procedure ValidateJsonReviewer(jsReviewer: TJSONObject);
    class function RatingsToString(const ARattings: array of Integer): string;
    procedure Execute; override;
  published
    property MainPageControl: TPageControl read FMainPageControl
      write FMainPageControl;
    property CloudBookReviews: TCloudBookReviews read FCloudBookReviews
      write FCloudBookReviews;
    property SynchonizationInfo: TSynchonizationInfo read FSynchonizationInfo
      write FSynchonizationInfo;
    property ProgressBar1: TProgressBar read FProgressBar1 write FProgressBar1;
    property DataModMain: TDataModMain read FDataModMain write FDataModMain;
    property Ratings: TRatings read FRatings write FRatings;
  end;

implementation

class function TBookImportCommand.BooksToDateTime(const s: string): TDateTime;
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

class procedure TBookImportCommand.ValidateJsonReviewer
  (jsReviewer: TJSONObject);
var
  isValid: Boolean;
begin
  isValid := jsReviewer.Values['rating'] is TJSONNumber and
    jsReviewer.IsValidIsoDateUtc('registered');
  if not isValid then
    raise Exception.Create('Invalid reviewer JOSN record: ' +
      jsReviewer.ToString);
end;

class function TBookImportCommand.RatingsToString(const ARattings
  : array of Integer): string;
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

class function TBookImportCommand.FindFrameInTabs(const MainPageControl
  : TPageControl; const TabCaption: string): TFrame;
var
  i: Integer;
  tsh: TTabSheet;
begin
  Result := nil;
  for i := 0 to MainPageControl.PageCount - 1 do
  begin
    tsh := MainPageControl.Pages[i];
    if tsh.Caption = TabCaption then
    begin
      MainPageControl.ActivePage := tsh;
      if (tsh.ControlCount > 0) and (tsh.Controls[0] is TFrame) then
        Result := tsh.Controls[0] as TFrame;
      exit;
    end;
  end;
end;

{ TBookImportCommand }

procedure TBookImportCommand.Guard;
begin
  Assert(MainPageControl <> nil);
  Assert(CloudBookReviews <> nil);
  Assert(SynchonizationInfo <> nil);
  Assert(ProgressBar1 <> nil);
  Assert(DataModMain <> nil);
  Assert(Ratings <> nil);
end;

procedure TBookImportCommand.Execute;
var
  BookReviewsCatalog: TArray<TReviewCatalogItem>;
  BooksCounter: Integer;
  b: TBook;
  StrBookReview: string;
  jsBookReview: TJSONObject;
  jsReviewers: TJSONArray;
  i: Integer;
  j: Integer;
  jsReviewer: TJSONObject;
  Review: TReview;
  FrameBookshelfs: TBookshelfsFrame;
begin
  inherited;
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  FrameBookshelfs := FindFrameInTabs(MainPageControl, 'My Bookshelf')
    as TBookshelfsFrame;
  // ----------------------------------------------------------
  Ratings.Values := [];
  // ----------------------------------------------------------
  //
  // Get Book Reviews from Cloud as TJSONArray
  //
  BookReviewsCatalog := CloudBookReviews.GetCatalog(SynchonizationInfo.LastDay);
  SynchonizationInfo.LastDay := IncMonth(SynchonizationInfo.LastDay, 1);
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
      b.Pages := (jsBookReview.Values['pages'] as TJSONNumber).AsInt;
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
          b.releseDate, b.Pages, b.price, b.currency, b.imported,
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
          Registered := jsReviewer.GetFieldDateIsoUtc('registered');
          Rating := (jsReviewer.Values['rating'] as TJSONNumber).AsInt;
          FirstName := jsReviewer.GetFieldOrEmpty('firstname');
          LastName := jsReviewer.GetFieldOrEmpty('lastname');
          Oppinion := jsReviewer.GetFieldOrEmpty('review');
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
        Insert([Review.Rating], Ratings.Values, maxInt);
      end;
    finally
      b.Free;
      jsBookReview.Free;
    end;
  end;
end;

{ TRatings }

function TRatings.ToString: string;
begin
  Result := TBookImportCommand.RatingsToString(Self.Values);
end;

end.
