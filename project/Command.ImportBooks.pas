unit Command.ImportBooks;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  Vcl.Pattern.Command,
  Vcl.Forms,
  Vcl.ComCtrls,

  Cloud.Books.Reviews,
  ExtGUI.ListBox.Books,
  Frame.Bookshelfs;

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

type
  TBookImportCommand = class (TCommand)
  private
    FMainPageControl: TPageControl;
    FCloudBookReviews: TCloudBookReviews;
    FLastSynchonizationDay: TDateTime;
    FProgressBar1: TProgressBar;
  strict protected
    procedure Guard; override;
  public
    class function FindFrameInTabs(const MainPageControl:TPageControl; const TabCaption: string): TFrame;
    procedure Execute; override;
    property MainPageControl: TPageControl read FMainPageControl write FMainPageControl;
    property CloudBookReviews: TCloudBookReviews read FCloudBookReviews write FCloudBookReviews;
    property LastSynchonizationDay: TDateTime read FLastSynchonizationDay write FLastSynchonizationDay;
    property ProgressBar1: TProgressBar read FProgressBar1 write FProgressBar1;
  end;

implementation


class function TBookImportCommand.FindFrameInTabs(const MainPageControl:TPageControl; const TabCaption: string): TFrame;
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
  Assert (MainPageControl<>nil);
  Assert (CloudBookReviews<>nil);
  Assert (LastSynchonizationDay<>0);
  Assert (ProgressBar1<>nil);
  // Assert (
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
  AllRatings: array of Integer;
  RatingsAsString: string;
  FrameBookshelfs: TBookshelfsFrame;
begin
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  FrameBookshelfs := FindFrameInTabs(MainPageControl, 'My Bookshelf') as TBookshelfsFrame;
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  //
  // Get Book Reviews from Cloud as TJSONArray
  //
  BookReviewsCatalog := CloudBookReviews.GetCatalog(LastSynchonizationDay);
  LastSynchonizationDay := IncMonth(LastSynchonizationDay, 1);
  BooksCounter := Length(BookReviewsCatalog);
  ProgressBar1.Max := BooksCounter;
(*
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
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  if FApplicationInDeveloperMode then
    Caption := RatingsAsString;
  grbxImportProgress.Tag := 80;
*)
end;

end.
