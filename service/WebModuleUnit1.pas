unit WebModuleUnit1;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  Web.HTTPApp, Web.HTTPProd;

type
  TWebModule1 = class(TWebModule)
    PageProducerBooks1: TPageProducer;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    jsonBooksCatalog: TJSONObject;
    function BuildReviewsList(const StartDate: string): string;
    function GetBookReview (const BookReviewID: string): string;
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

uses
  System.StrUtils, System.Hash, System.Generics.Collections,
  FormUnit1;

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

function TWebModule1.BuildReviewsList(const StartDate: string): string;
var
  ListName: string;
begin
  ListName := 'list_' + StartDate.Substring(0, 4) + StartDate.Substring(5, 2);
  Result := (jsonBooksCatalog.Values[ListName] as TJSONArray).ToString
end;

function TWebModule1.GetBookReview (const BookReviewID: string): string;
var
  jsBookReview: TJSONObject;
begin
  if jsonBooksCatalog.TryGetValue<TJSONObject>(BookReviewID,jsBookReview) then
    Result := jsBookReview.ToString
  else
    raise Exception.Create('');
end;

(*
  'Sandeman','Marten','asandeman1z@trellian.com','',1
  'Pesak','Gussi','gpesako@koepp.com','Koepp LLC',1
  'Oldknow','Bondon','boldknow1g@gizmodo.com','',1
  'Sorton','Gib','gsorton1f@un.org','',1
  'McKellar','Göran','emckellaro@jenkinsparisian.com','Jenkins-Parisian',1
*)

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  StartDate: string;
  BookReviewID: string;
begin
  Response.ContentType := 'application/json; charset="utf-8"';
  if Request.PathInfo = '/books/review' then
  begin
    try
      StartDate := Request.QueryFields.Values['startdate'];
      Response.Content := BuildReviewsList(StartDate)
    except
      Response.StatusCode := 400;
      Response.Content := '{"message":"Invalid startdate"}';
    end;
  end
  else if Request.PathInfo.Contains('/books/review/') then
  begin
    try
      BookReviewID := Request.PathInfo.Substring(14,99);
      Response.Content := GetBookReview(BookReviewID);
    except
      Response.StatusCode := 400;
      Response.Content := '{"message":"Invalid BookReview ID"}';
    end;
  end
  else
    Response.Content := '{"name":"CloudBookservice", "version":"0.9"}';
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
  jsonBooksCatalog := (TJSONObject.ParseJSONValue(PageProducerBooks1.Content)
    as TJSONObject);
end;

procedure TWebModule1.WebModuleDestroy(Sender: TObject);
begin
  jsonBooksCatalog.Free;
end;

end.
