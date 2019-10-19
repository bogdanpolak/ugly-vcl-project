unit Frame.Bookshelfs;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.StdCtrls,
  ExtGUI.ListBox.Books;

type
  TBookshelfsFrame = class(TFrame)
    grpBooksShelf: TGroupBox;
    lbReadedBooksInfo: TLabel;
    lbxBooksShelf: TListBox;
    grpBooksAvaliable: TGroupBox;
    Splitter1: TSplitter;
    lbAvaliableBooksInfo: TLabel;
    lbxBooksAvaliable: TListBox;
    Image1: TImage;
    lblBookName: TLabel;
    lblBookISBN: TLabel;
    scrlbxBookInfo: TScrollBox;
    Splitter2: TSplitter;
    lblBookAuthors: TLabel;
    tmrFrameReady: TTimer;
    procedure FrameResize(Sender: TObject);
    procedure tmrFrameReadyTimer(Sender: TObject);
  private
    FListBoxConfigurator: TBooksListBoxConfigurator;
    procedure AutoSizeBooksGroupBoxes;
    procedure OnFrameReady;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ListBoxConfigurator: TBooksListBoxConfigurator
      read FListBoxConfigurator write FListBoxConfigurator;
  end;

implementation

{$R *.dfm}

{ TODO 2: [Helper] TWinControl class helper }
function SumHeightForChildrens(Parent: TWinControl;
  ControlsToExclude: TArray<TControl>): integer;
var
  i: integer;
  ctrl: Vcl.Controls.TControl;
  isExcluded: Boolean;
  j: integer;
  sumHeight: integer;
  ctrlHeight: integer;
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

{ TODO 3: Move into TBooksListBoxConfigurator }
procedure TBookshelfsFrame.AutoSizeBooksGroupBoxes();
begin
  // TODO: implement
end;


constructor TBookshelfsFrame.Create(AOwner: TComponent);
begin
  inherited;
  // ----------------------------------------------------------
  // ----------------------------------------------------------
  //
  // TBooksListBoxConfigurator.PrepareListBoxes =
  // 1. Initialize ListBox'es for books
  // 2. (!!!!) Load books form database through experimental IBooksDAO
  // 3. Setup drag&drop functionality for two list boxes
  // 4. Setup OwnerDraw mode
  //
  FListBoxConfigurator := TBooksListBoxConfigurator.Create(Self);
end;

destructor TBookshelfsFrame.Destroy;
begin
  FListBoxConfigurator.Free;
  inherited;
end;

procedure TBookshelfsFrame.FrameResize(Sender: TObject);
begin
  AutoSizeBooksGroupBoxes();
end;

procedure TBookshelfsFrame.OnFrameReady;
begin
  FListBoxConfigurator.PrepareListBoxes(lbxBooksShelf,lbxBooksAvaliable);
end;

procedure TBookshelfsFrame.tmrFrameReadyTimer(Sender: TObject);
begin
  OnFrameReady;
  tmrFrameReady.Enabled := False;
end;

end.

