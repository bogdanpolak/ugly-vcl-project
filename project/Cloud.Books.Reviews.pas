unit Cloud.Books.Reviews;

interface

uses
  System.Classes, System.SysUtils, System.JSON, System.Contnrs,
  System.Generics.Collections,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TReviewCatalogItem = record
    BookReviewID: string;
    function Create(const ABookReviewID: string): TReviewCatalogItem;
  end;

type
  TCloudBookReviews = class(TComponent)
  const
    BaseURL = 'http://localhost:4040';
  private
    IdHTTP1: TIdHTTP;
    function GetStringHttp(const Url: string): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetCatalog(const LastSyncDay: TDateTime)
      : TArray<TReviewCatalogItem>;
    function GetReview(const BookReviewID: string): string;
  end;

implementation

(* ----------------------------------------------------------------
  * class TReviewCatalogItem
  * ---------------------------------------------------------------- *)

function TReviewCatalogItem.Create(const ABookReviewID: string)
  : TReviewCatalogItem;
begin
  Result.BookReviewID := ABookReviewID;
end;

(* ----------------------------------------------------------------
  * class TCloudBookReviews
  * ---------------------------------------------------------------- *)

constructor TCloudBookReviews.Create(AOwner: TComponent);
begin
  inherited;
  IdHTTP1 := TIdHTTP.Create(Self);
end;

destructor TCloudBookReviews.Destroy;
begin
  IdHTTP1.Free;
  inherited;
end;

function TCloudBookReviews.GetStringHttp(const Url: string): string;
begin
  Result := IdHTTP1.Get(BaseURL + Url);
end;

function TCloudBookReviews.GetCatalog(const LastSyncDay: TDateTime)
  : TArray<TReviewCatalogItem>;
var
  Url: string;
  sCatalog: string;
  jsBookReviewCatalog: TJSONArray;
  i: Integer;
  str: string;
  item: TReviewCatalogItem;
begin
  Url := '/books/review?startdate=' + FormatDateTime('yyyy-mm-dd', LastSyncDay);
  sCatalog := GetStringHttp(Url);
  jsBookReviewCatalog := TJSONObject.ParseJSONValue(sCatalog) as TJSONArray;
  try
    Result := [];
    for i := 0 to jsBookReviewCatalog.Count - 1 do
    begin
      str := jsBookReviewCatalog.Items[i].Value;
      item.BookReviewID := str;
      Result := Result + [item];
    end;
  finally
    jsBookReviewCatalog.Free;
  end;
end;

function TCloudBookReviews.GetReview(const BookReviewID: string): string;
begin
  Result := GetStringHttp('/books/review/' + BookReviewID);
end;

end.
