unit CloudBooks.Reviews_;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TReviewInfo = record
    Books: integer;
    Packets: integer;
    Token: string;
  end;

  TCloudBooksDM = class(TDataModule)
    IdHTTP1: TIdHTTP;
  private
    BaseURL: string;
    function GetStringHttp(const Url: string): string;
    function GetReviewInfo(const Url: string): TReviewInfo;
  public
    function ConstructAndGetReviews(const LastUpdate: string): TJSONArray;
    function GetReviewsAsString(const LastUpdate: string): string;
  end;

var
  CloudBooksDM: TCloudBooksDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
{ TCloudBooksDM }

function TCloudBooksDM.GetStringHttp(const Url: string): string;
begin
  Result := IdHTTP1.Get(BaseURL + Url);
end;

function TCloudBooksDM.GetReviewInfo(const Url: string): TReviewInfo;
var
  s: string;
  jReviewInfo: TJSONObject;
begin
  s := GetStringHttp(Url);
  jReviewInfo := TJSONObject.ParseJSONValue(s) as TJSONObject;
  try
    Result.Token := jReviewInfo.Values['token'].Value;
    Result.Packets := (jReviewInfo.Values['packets'] as TJSONNumber).AsInt;
    Result.Books := (jReviewInfo.Values['books'] as TJSONNumber).AsInt;
  finally
    jReviewInfo.Free;
  end;
end;

function TCloudBooksDM.ConstructAndGetReviews(const LastUpdate: string)
  : TJSONArray;
var
  ReviewInfo: TReviewInfo;
  page: integer;
  jReviews: TJSONArray;
  s: string;
  jArr: TJSONArray;
  jObj: TJSONObject;
begin
  BaseURL := 'http://localhost:4040/books';
  ReviewInfo := GetReviewInfo('/review?startdate=' + LastUpdate);
  jReviews := TJSONArray.Create;
  for page := 1 to ReviewInfo.Packets do
  begin
    s := GetStringHttp(Format('/review/pack?page=%d&token=%s',
      [page, ReviewInfo.Token]));
    jArr := TJSONObject.ParseJSONValue(s) as TJSONArray;
    try
      while jArr.Count > 0 do
      begin
        jObj := jArr.Remove(0) as TJSONObject;
        jReviews.Add(jObj)
      end;
    finally
      FreeAndNil(jArr);
    end;
  end;
  Result := jReviews;
end;

function TCloudBooksDM.GetReviewsAsString(const LastUpdate: string): string;
var
  jReviews: TJSONArray;
begin
  BaseURL := 'http://localhost:4040/books';
  jReviews := ConstructAndGetReviews(LastUpdate);
  try
    Result := jReviews.ToString
  finally
    jReviews.Free;
  end;
end;

end.
