unit Cloud.Books.Reviews;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Contnrs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TCloudBookReviews = class(TComponent)
  const
    BaseURL = 'http://localhost:4040';
  private
    IdHTTP1: TIdHTTP;
    BooksReviewCatalog: TObjectList;
    procedure GetReviewCatalog(const Url: string);
    function GetStringHttp(const Url: string): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ConstructAndGetReviews(const LastUpdate: string): TJSONArray;
    function GetReviewsAsString(const LastUpdate: string): string;
  end;

implementation

(* ----------------------------------------------------------------
 * class TReviewCatalogItem
 * ---------------------------------------------------------------- *)

type
  TReviewCatalogItem = class
    BookReviewID: string;
    constructor CreateAndFill (const ABookReviewID: string);
  end;

constructor TReviewCatalogItem.CreateAndFill(const ABookReviewID: string);
begin
  BookReviewID := ABookReviewID;
end;

(* ----------------------------------------------------------------
 * class TCloudBookReviews
 * ---------------------------------------------------------------- *)

constructor TCloudBookReviews.Create(AOwner: TComponent);
begin
  inherited;
  IdHTTP1 := TIdHTTP.Create(Self);
  BooksReviewCatalog := TObjectList.Create;
end;

destructor TCloudBookReviews.Destroy;
begin
  IdHTTP1.Free;
  BooksReviewCatalog.Free;
  inherited;
end;

function TCloudBookReviews.GetStringHttp(const Url: string): string;
begin
  Result := IdHTTP1.Get(BaseURL + Url);
end;

procedure TCloudBookReviews.GetReviewCatalog(const Url: string);
var
  s: string;
  jsBookReviewC: TJSONArray;
  jv: TJSONValue;
begin
  s := GetStringHttp(Url);
  BooksReviewCatalog.Clear;
  jsBookReviewC := TJSONObject.ParseJSONValue(s) as TJSONArray;
  try
    for jv in jsBookReviewC do
      BooksReviewCatalog.Add(TReviewCatalogItem.CreateAndFill(jv.Value));
  finally
    jsBookReviewC.Free;
  end;
end;

function TCloudBookReviews.ConstructAndGetReviews(const LastUpdate: string)
  : TJSONArray;
var
  jsLoadedReviews: TJSONArray;
  i: integer;
  BookReview: TReviewCatalogItem;
  s: string;
  jsBookReview: TJSONObject;
begin
  GetReviewCatalog('/books/review?startdate=' + LastUpdate);
  jsLoadedReviews := TJSONArray.Create;
  for i:=0 to BooksReviewCatalog.Count-1 do
  begin
    BookReview := BooksReviewCatalog.Items[i] as TReviewCatalogItem;
    s := GetStringHttp('/books/review/'+BookReview.BookReviewID);
    jsBookReview := TJSONObject.ParseJSONValue(s) as TJSONObject;
    jsLoadedReviews.Add(jsBookReview);
  end;
  Result := jsLoadedReviews;
end;

function TCloudBookReviews.GetReviewsAsString(const LastUpdate: string): string;
var
  jReviews: TJSONArray;
begin
  jReviews := ConstructAndGetReviews(LastUpdate);
  try
    Result := jReviews.ToString
  finally
    jReviews.Free;
  end;
end;
end.
