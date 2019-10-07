unit WebModuleUnit1;

interface

uses
  System.SysUtils, System.Classes, System.JSON,
  Web.HTTPApp, Web.HTTPProd;

type
  TWebModule1 = class(TWebModule)
    PageProducerBooks1: TPageProducer;
    PageProducerBooks2: TPageProducer;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);
  private
    jsonBooks1: TJSONObject;
    jsonBooks2: TJSONObject;
    class function CountPacketsNumber(AJsonBooks: TJSONObject): integer;
    class function CountBooks(AJsonBooks: TJSONObject): integer;
    class function BuildReviewInfo(const ARequestID: string;
      AJsonBooks: TJSONObject): string;
    function BuildBooksPack: string;
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

type
  TStringUtils = class
    class function CountOccurences(const Substring, Text: string): integer;
  end;

class function TStringUtils.CountOccurences(const Substring,
  Text: string): integer;
var
  offset: integer;
begin
  Result := 0;
  offset := PosEx(Substring, Text, 1);
  while offset <> 0 do
  begin
    inc(Result);
    offset := System.StrUtils.PosEx(Substring, Text,
      offset + length(Substring));
  end;
end;

class function TWebModule1.CountBooks(AJsonBooks: TJSONObject): integer;
var
  jObj: TJSONValue;
begin
  // json
  Result := 0;
  for jObj in AJsonBooks.Values['packets'] as TJSONArray do
    Result := Result + (jObj as TJSONArray).Count;
end;

class function TWebModule1.CountPacketsNumber(AJsonBooks: TJSONObject): integer;
begin
  Result := (AJsonBooks.Values['packets'] as TJSONArray).Count
end;

class function TWebModule1.BuildReviewInfo(const ARequestID: string;
  AJsonBooks: TJSONObject): string;
var
  jObj: TJSONObject;
  token: string;
  packets: integer;
  books: integer;
begin
  jObj := TJSONObject.Create;
  try
    token := ARequestID + System.Hash.THashMD5.GetHashString(DateTimeToStr(Now))
      .Substring(18);
    packets := CountPacketsNumber(AJsonBooks);
    books := CountBooks(AJsonBooks);
    jObj.AddPair('token', token);
    jObj.AddPair('packets', TJSONNumber.Create(packets));
    jObj.AddPair('books', TJSONNumber.Create(books));
    Result := jObj.ToString;
  finally
    jObj.Free;
  end;
end;

function TWebModule1.BuildBooksPack: string;
var
  token: string;
  page: integer;
  s: string;
  jsonPackets: TJSONArray;
begin
  token := Request.QueryFields.Values['token'];
  page := StrToInt(Request.QueryFields.Values['page']);
  s := token.Substring(0, 8);
  if s = '20190801' then
    jsonPackets := (jsonBooks1.Values['packets'] as TJSONArray)
  else if token.Substring(0, 8) = '20190902' then
    jsonPackets := (jsonBooks2.Values['packets'] as TJSONArray)
  else
  begin
    Result := '[]';
    exit;
  end;
  if (page > 0) and (page <= jsonPackets.Count) then
    Result := jsonPackets.Items[page - 1].ToString
  else
    Result := '[]';
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
  token: string;
  page: integer;
  s: string;
begin
  Response.ContentType := 'application/json; charset="utf-8"';
  if Request.PathInfo = '/books/review' then
  begin
    if Request.Query = 'startdate=2019-08-01' then
      Response.Content := BuildReviewInfo('20190801aaaa', jsonBooks1)
    else if Request.Query = 'startdate=2019-09-02' then
      Response.Content := BuildReviewInfo('20190902cccc', jsonBooks2)
    else
      Response.Content := '[]';
  end
  else if Request.PathInfo = '/books/review/pack' then
    Response.Content := BuildBooksPack
  else
    Response.Content := '{"name":"CloudBookservice", "version":"0.9"}';
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
  jsonBooks1 := (TJSONObject.ParseJSONValue(PageProducerBooks1.Content)
    as TJSONObject);
  jsonBooks2 := (TJSONObject.ParseJSONValue(PageProducerBooks2.Content)
    as TJSONObject);
end;

procedure TWebModule1.WebModuleDestroy(Sender: TObject);
begin
  jsonBooks1.Free;
  jsonBooks2.Free;
end;

end.
