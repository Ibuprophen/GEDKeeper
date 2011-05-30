unit GKChartCore; {trans:fin}

{$I GEDKeeper.inc}

interface

uses
  Types, Windows, Messages, Classes, Contnrs, Graphics, Controls, Forms,
  GedCom551, GKEngine, GKCommon, GKLists, GraphCore;

type
  TBranchCut = (bcNone, bcYears, bcPersons);

  TChartFilter = class(TObject)
  private
    Back_SourceMode: TGroupMode;
    Back_SourceRef: string;

    Back_BranchCut: TBranchCut;
    Back_BranchYear: Integer;
    Back_BranchPersons: string;
  public
    SourceMode: TGroupMode;
    SourceRef: string;

    BranchCut: TBranchCut;
    BranchYear: Integer;
    BranchPersons: string;

    constructor Create();

    procedure Clear();
    procedure Backup();
    procedure Restore();
  end;

  TChartKind = (ckAncestors, ckDescendants, ckBoth);
  TPerson = class;

  TCustomChartBox = class(TCustomControl)
  private
    // control fields
    FBorderStyle: TBorderStyle;
    FBorderWidth: Integer;
    FImageHeight: Integer;
    FImageWidth: Integer;
    FKind: TChartKind;
    FLeftPos: Integer;
    FTopPos: Integer;
    FRange: TPoint;
    FSPX, FSPY: Integer;

    // chart fields
    FEngine: TGenEngine;
    FFilter: TPersonsFilter;
    FOptions: TChartOptions;
    FRoot: TPerson;
    FSelected: TPerson;
    FShieldState: TShieldState;
    FTree: TGEDCOMTree;

    function DoScroll(nBar, aOldPos, aMin, aMax: Integer; var Message: TWMScroll): Integer;

    procedure CMCtl3DChanged(var Message: TMessage); message CM_CTL3DCHANGED;
    procedure ScrollRange();
    procedure SetBorderStyle(Value: TBorderStyle);
    procedure SetBorderWidth(Value: Integer);
    procedure SetLeftPos(Value: Integer);
    procedure SetSelected(const Value: TPerson);
    procedure SetTopPos(Value: Integer);
    procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMSize(var Msg: TWMSize); message WM_SIZE;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Draw(aCanvas: TCanvas; aPerson: TPerson; aDirKind: TChartKind); virtual; abstract;
    procedure InternalGenChart(aPerson: TGEDCOMIndividualRecord; aKind: TChartKind); virtual; abstract;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure GenChart(aPerson: TGEDCOMIndividualRecord; aKind: TChartKind);
    procedure SelectBy(aX, aY: Integer); virtual; abstract;
    procedure TreeDraw(aCanvas: TCanvas; Default: Boolean); virtual;

    property Engine: TGenEngine read FEngine write FEngine;
    property Filter: TPersonsFilter read FFilter write FFilter;
    property Options: TChartOptions read FOptions write FOptions;
    property Root: TPerson read FRoot;
    property Selected: TPerson read FSelected write SetSelected;
    property ShieldState: TShieldState read FShieldState write FShieldState;
    property Tree: TGEDCOMTree read FTree write FTree;

    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle default bsSingle;
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth;
    property LeftPos: Integer read FLeftPos write SetLeftPos;
    property TopPos: Integer read FTopPos write SetTopPos;

    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TPersonFlag = (pfDivorced, pfIsDead, pfSelected, pfDescByFather, pfDescByMother);
  TPersonFlags = set of TPersonFlag;
  TPersonList = class;
  TPersonKind = (pkDefault, pkSpouse);

  TCustomPerson = class(TObject)
  private
    FBirthDate, FBirthYear: string;
    FChart: TCustomChartBox;
    FDeathDate, FDeathYear: string;
    FFamily: string;
    FFlags: TPersonFlags;
    FHeight: Integer;
    FKinship: string;
    FName: string;
    FPatronymic: string;
    FPortrait: TGraphic;
    FPortraitWidth: Longint;
    FPtX, FPtY: Longint;
    FRec: TGEDCOMIndividualRecord;
    FSex: TGEDCOMSex;
    FSigns: TChartPersonSigns;
    FWidth: Integer;

    {$IFDEF GEN_DEBUG}
    FPath: string;
    {$ENDIF}

    procedure Calc();
    function GetDestRect(rt: TRect; Portrait: TGraphic): TRect;
    function GetDivorced: Boolean;
    function GetIsDead: Boolean;
    function GetPt: TPoint;
    function GetRect(): TRect;
    function GetSelected: Boolean;
    procedure SetDivorced(const Value: Boolean);
    procedure SetIsDead(const Value: Boolean);
    procedure SetKinship(const Value: string);
    procedure SetPt(const Value: TPoint);
    procedure SetSelected(const Value: Boolean);
  protected
    function GetFullName: string;
    function GetLifeYears: string;
  public
    constructor Create(aChart: TCustomChartBox); virtual;
    destructor Destroy; override;

    procedure BuildBy(iRec: TGEDCOMIndividualRecord);
    procedure Draw(aCanvas: TCanvas; SPX, SPY: Integer); virtual;

    property BirthDate: string read FBirthDate;
    property DeathDate: string read FDeathDate;
    property Divorced: Boolean read GetDivorced write SetDivorced;
    property Family: string read FFamily;
    property Height: Integer read FHeight;
    property IsDead: Boolean read GetIsDead write SetIsDead;
    property Kinship: string read FKinship write SetKinship;
    property Name: string read FName;
    property Patronymic: string read FPatronymic;
    property Pt: TPoint read GetPt write SetPt;
    property PtX: Longint read FPtX write FPtX;
    property PtY: Longint read FPtY write FPtY;
    property Rec: TGEDCOMIndividualRecord read FRec;
    property Rect: TRect read GetRect;
    property Selected: Boolean read GetSelected write SetSelected;
    property Sex: TGEDCOMSex read FSex;
    property Signs: TChartPersonSigns read FSigns;
    property Width: Integer read FWidth;
  end;

  TPerson = class(TCustomPerson)
  private
    FBaseSpouse: TPerson;
    FChilds: TPersonList;
    FFather: TPerson;
    FGeneration: Integer;
    FKind: TPersonKind;
    FMother: TPerson;
    FNode: TGraphNode;
    FSpouses: TPersonList;

    function GetChild(Index: Integer): TPerson;
    function GetChildsCount: Integer;
    function GetSpouse(Index: Integer): TPerson;
    function GetSpousesCount: Integer;
  public
    Parent: TPerson;

    constructor Create(aChart: TCustomChartBox); override;
    destructor Destroy; override;

    procedure AddChild(aChild: TPerson);
    procedure AddSpouse(aSpouse: TPerson);

    property BaseSpouse: TPerson read FBaseSpouse write FBaseSpouse;
    property Childs[Index: Integer]: TPerson read GetChild;
    property ChildsCount: Integer read GetChildsCount;
    property Father: TPerson read FFather write FFather;
    property Generation: Integer read FGeneration write FGeneration;
    property Kind: TPersonKind read FKind write FKind;
    property Mother: TPerson read FMother write FMother;
    property Spouses[Index: Integer]: TPerson read GetSpouse;
    property SpousesCount: Integer read GetSpousesCount;
  end;

  TPersonList = class(TObjectList)
  private
    function GetItem(Index: Integer): TPerson;
    procedure SetItem(Index: Integer; const Value: TPerson);
  public
    property Items[Index: Integer]: TPerson read GetItem write SetItem; default;
  end;

  TEdges = array [Byte] of Longint;

  TAncestryChartBox = class(TCustomChartBox)
  private
    FBranchDistance: Integer;
    FDepthLimit: Integer;
    FHMax, FWMax: Integer;
    FFilter: TChartFilter;
    FGraph: TGraph;
    FKinRoot: TPerson;
    FLevelDistance: Integer;
    FMargin: Integer;
    FPersons: TPersonList;
    FScale: Integer;
    FSpouseDistance: Integer;

    function DoAncestorsStep(aChild: TPerson; aPerson: TGEDCOMIndividualRecord; aGeneration: Integer): TPerson;
    function DoDescendantsStep(aParent: TPerson; aPerson: TGEDCOMIndividualRecord; aLevel: Integer): TPerson;

    function FindRelationship(aTarget: TPerson): string;
    procedure Line(aCanvas: TCanvas; X1, Y1, X2, Y2: Integer);
    procedure Predef(aCanvas: TCanvas);
    procedure RecalcAncestorsChart();
    procedure RecalcDescendantsChart(aPreDef: Boolean);
    procedure RecalcChart();
  protected
    procedure Draw(aCanvas: TCanvas; aPerson: TPerson; aDirKind: TChartKind); override;
    procedure InternalGenChart(aPerson: TGEDCOMIndividualRecord; aKind: TChartKind); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure DoFilter(aRoot: TGEDCOMIndividualRecord);
    procedure RebuildKinships();
    procedure SaveSnapshot(const aFileName: string);
    procedure SelectBy(aX, aY: Integer); override;
    procedure SelectByRec(iRec: TGEDCOMIndividualRecord);

    property BranchDistance: Integer read FBranchDistance write FBranchDistance;
    property DepthLimit: Integer read FDepthLimit write FDepthLimit;
    property Filter: TChartFilter read FFilter;
    property Margin: Integer read FMargin write FMargin;
    property Scale: Integer read FScale write FScale;
  end;

implementation

uses
  {$IFDEF DELPHI_NET}Borland.Vcl.WinUtils, {$ENDIF}
  {$IFNDEF DELPHI_NET}Jpeg,{$ENDIF}
  SysUtils, Math, Dialogs, GKMain, StdCtrls, GKUtils, GKLangs;

function FindKinship(prev, cur: TRelationKind; var great, level: Integer): TRelationKind;
var
  i: Integer;
  rel: TRelationKind;
begin
  Result := rkUndefined;
  great := 0;
  level := 0;

  for i := 0 to KinshipsCount - 1 do
    if (prev in Kinships[i].PrevRels) and (cur in Kinships[i].CurrRels) then begin
      rel := Kinships[i].FinRel;
      great := Kinships[i].Great;
      level := Kinships[i].Level;
      if (rel = rkSame) then rel := cur;
      Result := rel;
    end;
end;

{==============================================================================}

{ TCustomChartBox }

constructor TCustomChartBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := [csCaptureMouse, csClickEvents, csDoubleClicks];
  DoubleBuffered := True;
  TabStop := True;

  FBorderStyle := bsSingle;

  TopPos := 0;
  LeftPos := 0;
end;

destructor TCustomChartBox.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomChartBox.GenChart(aPerson: TGEDCOMIndividualRecord; aKind: TChartKind);
begin
  InternalGenChart(aPerson, aKind);
  ScrollRange();
  Invalidate;
end;

procedure TCustomChartBox.TreeDraw(aCanvas: TCanvas; Default: Boolean);
begin
  aCanvas.Brush.Color := clWhite;
  aCanvas.Brush.Style := bsSolid;
  aCanvas.FillRect(ClientRect);

  if (Default) then begin
    FSPX := FBorderWidth - FLeftPos;
    FSPY := FBorderWidth - FTopPos;

    if (FImageWidth < ClientWidth)
    then FSPX := FSPX + (ClientWidth - FImageWidth) div 2;

    if (FImageHeight < ClientHeight)
    then FSPY := FSPY + (ClientHeight - FImageHeight) div 2;
  end else begin
    FSPX := 0;
    FSPY := 0;
  end;

  Draw(aCanvas, FRoot, FKind);
end;

procedure TCustomChartBox.Paint();
begin
  TreeDraw(Canvas, True);
end;

procedure TCustomChartBox.CreateParams(var Params: TCreateParams);
const
  BorderStyles: array[TBorderStyle] of DWORD = (0, WS_BORDER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_HSCROLL or WS_VSCROLL;

  with Params do begin
    Style := Style or BorderStyles[FBorderStyle];
    if NewStyleControls and Ctl3D and (FBorderStyle = bsSingle) then begin
      Style := Style and not WS_BORDER;
      ExStyle := ExStyle or WS_EX_CLIENTEDGE;
    end;
  end;
end;

procedure TCustomChartBox.CMCtl3DChanged(var Message: TMessage);
begin
  if NewStyleControls and (FBorderStyle = bsSingle) then RecreateWnd;
  inherited;
end;

procedure TCustomChartBox.SetBorderStyle(Value: TBorderStyle);
begin
  if (Value <> FBorderStyle) then begin
    FBorderStyle := Value;
    RecreateWnd();
  end;
end;

procedure TCustomChartBox.SetBorderWidth(Value: Integer);
begin
  if (FBorderWidth <> Value) then begin
    FBorderWidth := Value;
    Invalidate;
  end;
end;

procedure TCustomChartBox.WMSize(var Msg: TWMSize);
begin
  ScrollRange();
end;

procedure TCustomChartBox.WMGetDlgCode(var Msg: TWMGetDlgCode);
begin
  inherited;
  Msg.Result := Msg.Result
    or DLGC_WANTARROWS or DLGC_WANTTAB or DLGC_WANTCHARS or DLGC_WANTALLKEYS;
end;

procedure TCustomChartBox.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if not Focused then SetFocus;
end;

procedure TCustomChartBox.ScrollRange();
begin
  if (FImageWidth < ClientWidth) then begin
    FRange.X := 0;
    LeftPos := (ClientWidth - FImageWidth) div 2;
  end else FRange.X := FImageWidth - ClientWidth;

  if (FImageHeight < ClientHeight) then begin
    FRange.Y := 0;
    TopPos := (ClientHeight - FImageHeight) div 2;
  end else FRange.Y := FImageHeight - ClientHeight;

  SetScrollRange(Handle, SB_HORZ, 0, FRange.X, False);
  SetScrollRange(Handle, SB_VERT, 0, FRange.Y, False);
end;

function TCustomChartBox.DoScroll(nBar, aOldPos, aMin, aMax: Integer; var Message: TWMScroll): Integer;
var
  NewPos: Longint;
  ScrollInfo: TScrollInfo;
begin
  NewPos := aOldPos;

  case TScrollCode(Message.ScrollCode) of
    scLineUp:
      Dec(NewPos, 1);
    scLineDown:
      Inc(NewPos, 1);
    scPageUp:
      Dec(NewPos, 1);
    scPageDown:
      Inc(NewPos, 1);
    scPosition, scTrack:
      with ScrollInfo do begin
        cbSize := SizeOf(ScrollInfo);
        fMask := SIF_ALL;
        GetScrollInfo(Handle, nBar, ScrollInfo);
        NewPos := nTrackPos;
      end;
    scTop:
      NewPos := 0;
    scBottom:
      NewPos := aMax;
  end;

  if (NewPos < aMin) then NewPos := aMin;
  if (NewPos > aMax) then NewPos := aMax;

  Result := NewPos;
end;

procedure TCustomChartBox.WMVScroll(var Msg: TWMVScroll);
var
  new_pos: Integer;
begin
  new_pos := DoScroll(SB_VERT, TopPos, 0, FRange.Y, Msg);
  SetTopPos(new_pos);
end;

procedure TCustomChartBox.WMHScroll(var Msg: TWMHScroll);
var
  new_pos: Integer;
begin
  new_pos := DoScroll(SB_HORZ, LeftPos, 0, FRange.X, Msg);
  SetLeftPos(new_pos);
end;

procedure TCustomChartBox.SetTopPos(Value: Integer);
var
  {$IFDEF DELPHI_NET}dummy,{$ENDIF} R: TRect;
begin
  if (Value < 0) then Value := 0;
  if (Value > FRange.Y) then Value := FRange.Y;

  if (FTopPos <> Value) then begin
    {$IFNDEF DELPHI_NET}
    ScrollWindowEx(Handle, 0, FTopPos - Value, nil, nil, 0, @R, 0);
    {$ELSE}
    dummy.Empty();
    ScrollWindowEx(Handle, 0, FTopPos - Value, dummy, dummy, 0, R, 0);
    {$ENDIF}
    SetScrollPos(Handle, SB_VERT, FTopPos, True);

    Invalidate;
    FTopPos := Value;
  end;
end;

procedure TCustomChartBox.SetLeftPos(Value: Integer);
var
  {$IFDEF DELPHI_NET}dummy,{$ENDIF} R: TRect;
begin
  if (Value < 0) then Value := 0;
  if (Value > FRange.X) then Value := FRange.X;

  if (FLeftPos <> Value) then begin
    {$IFNDEF DELPHI_NET}
    ScrollWindowEx(Handle, FLeftPos - Value, 0, nil, nil, 0, @R, 0);
    {$ELSE}
    dummy.Empty();
    ScrollWindowEx(Handle, FLeftPos - Value, 0, dummy, dummy, 0, R, 0);
    {$ENDIF}
    SetScrollPos(Handle, SB_HORZ, FLeftPos, True);

    Invalidate;
    FLeftPos := Value;
  end;
end;

procedure TCustomChartBox.SetSelected(const Value: TPerson);
begin
  if (FSelected <> nil) then FSelected.Selected := False;
  FSelected := Value;
  if (FSelected <> nil) then FSelected.Selected := True;

  Invalidate;
end;

{==============================================================================}

{$R res\gk.res}

var
  SignsData: array [TChartPersonSign] of record
    Name: string;
    Pic: TBitmap;
  end = (
    (Name: 'GEORGE_CROSS'),
    (Name: 'SOLDIER'),
    (Name: 'SOLDIER_FALL'),
    (Name: 'VETERAN_REAR')
  );

procedure InitSigns();
var
  ps: TChartPersonSign;
begin
  for ps := Low(TChartPersonSign) to High(TChartPersonSign) do begin
    SignsData[ps].Pic := TBitmap.Create;
    SignsData[ps].Pic.LoadFromResourceName(HInstance, SignsData[ps].Name);
    SignsData[ps].Pic.Transparent := True;
    SignsData[ps].Pic.TransparentMode := tmFixed;
    //SignsData[ps].Pic.TransparentColor := Signs[ps].Pic.Canvas.Pixels[0, 0];
  end;
end;

procedure DoneSigns();
var
  ps: TChartPersonSign;
begin
  for ps := Low(TChartPersonSign) to High(TChartPersonSign) do
    SignsData[ps].Pic.Free;
end;

function GetPersonSign(iRec: TGEDCOMIndividualRecord): TChartPersonSigns;
var
  rs: string;
  cps: TChartPersonSign;
  i: Integer;
begin
  Result := [];

  for i := 0 to iRec.UserReferencesCount - 1 do begin
    rs := iRec.UserReferences[i].StringValue;

    for cps := Low(TChartPersonSign) to High(TChartPersonSign) do
      if (rs = UserRefs[cps].Name)
      then Include(Result, cps);
  end;
end;

{ TCustomPerson }

constructor TCustomPerson.Create(aChart: TCustomChartBox);
begin
  inherited Create();
  FChart := aChart;
  FPortrait := nil;
end;

destructor TCustomPerson.Destroy;
begin
  if (FPortrait <> nil) then FPortrait.Free;

  inherited Destroy;
end;

procedure TCustomPerson.BuildBy(iRec: TGEDCOMIndividualRecord);
var
  fam, nam, pat: string;
begin
  FRec := iRec;

  if (iRec <> nil) then begin
    GetNameParts(iRec, fam, nam, pat);

    FFamily := fam;
    FName := nam;
    FPatronymic := pat;
    FBirthDate := GetBirthDate(iRec, dfDD_MM_YYYY);
    FDeathDate := GetDeathDate(iRec, dfDD_MM_YYYY);
    IsDead := not(IsLive(iRec));
    FSex := iRec.Sex;
    FSigns := GetPersonSign(iRec);

    FBirthYear := GetBirthDate(iRec, dfYYYY);
    FDeathYear := GetDeathDate(iRec, dfYYYY);

    if (FChart.Options.PortraitsVisible)
    then FPortrait := FChart.FEngine.GetPrimaryBitmap(iRec);
  end else begin
    FFamily := '';
    FName := '< ? >';
    FPatronymic := '';
    FBirthDate := '';
    FDeathDate := '';
    IsDead := False;
    FSex := svNone;
    FSigns := [];
  end;

  Calc();
end;

function TCustomPerson.GetLifeYears: string;
begin
  if (FBirthYear = '')
  then Result := '?'
  else Result := FBirthYear;

  if (IsDead) then begin
    if (FDeathYear = '')
    then Result := Result + ' - ?'
    else Result := Result + ' - ' + FDeathYear;
  end;

  Result := '[ ' + Result + ' ]';
end;

function TCustomPerson.GetPt: TPoint;
begin
  Result.X := FPtX;
  Result.Y := FPtY;
end;

procedure TCustomPerson.SetPt(const Value: TPoint);
begin
  FPtX := Value.X;
  FPtY := Value.Y;
end;

function TCustomPerson.GetFullName: string;
begin
  Result := FName + ' ' + FPatronymic;
end;

function TCustomPerson.GetDestRect(rt: TRect; Portrait: TGraphic): TRect;
var
  w, h, cw, ch: Integer;
  xyaspect: Double;
begin
  w := Portrait.Width;
  h := Portrait.Height;
  cw := (rt.Right - rt.Left) + 1;
  ch := (rt.Bottom - rt.Top) + 1;

  // always stretch and proportional
  xyaspect := w / h;
  if (w > h) then begin
    w := cw;
    h := Trunc(cw / xyaspect);
    if (h > ch) then begin // woops, too big
      h := ch;
      w := Trunc(ch * xyaspect);
    end;
  end else begin
    h := ch;
    w := Trunc(ch * xyaspect);
    if (w > cw) then begin // woops, too big
      w := cw;
      h := Trunc(cw / xyaspect);
    end;
  end;

  Result.Left := rt.Left;
  Result.Top := rt.Top;
  Result.Right := rt.Left + w;
  Result.Bottom := rt.Top + h;

  OffsetRect(Result, (cw - w) div 2, (ch - h) div 2);
end;

procedure TCustomPerson.Draw(aCanvas: TCanvas; SPX, SPY: Integer);

  procedure DrawBorder(rt: TRect; dead: Boolean);
  begin
    case FSex of
      svMale: begin
        if not(dead) then begin
          if Divorced
          then aCanvas.Brush.Color := FChart.Options.UnHusbandColor
          else aCanvas.Brush.Color := FChart.Options.MaleColor;
        end else aCanvas.Brush.Color := clBlack;
        aCanvas.Rectangle(rt);
      end;

      svFemale: begin
        if not(dead) then begin
          if Divorced
          then aCanvas.Brush.Color := FChart.Options.UnWifeColor
          else aCanvas.Brush.Color := FChart.Options.FemaleColor;
        end else aCanvas.Brush.Color := clBlack;
        aCanvas.RoundRect(rt.Left, rt.Top, rt.Left + FWidth - 1, rt.Top + FHeight - 1, 13, 13);
      end;

      svNone, svUndetermined: begin
        if not(dead) then begin
          aCanvas.Brush.Color := FChart.Options.UnkSexColor;
        end else aCanvas.Brush.Color := clBlack;
        aCanvas.Rectangle(rt);
      end;
    end;
  end;

  procedure xOffsetRect(var Rect: TRect; DX: Integer; DY: Integer);
  begin
    Inc(Rect.Left, DX);
    Dec(Rect.Right, DX);

    Inc(Rect.Top, DY);
    Dec(Rect.Bottom, DY);
  end;

  procedure TextOut(rt: TRect; s: string; h: Integer; var line: Integer);
  var
    rx, ry, rw: Integer;
  begin
    rw := rt.Right - rt.Left + 1;

    rx := rt.Left + (rw - aCanvas.TextWidth(s)) div 2;
    ry := rt.Top + 10 + (h * line);

    aCanvas.TextOut(rx, ry, s);

    Inc(line);
  end;

var
  rt, dt, port_rt: TRect;
  h, line, i: Integer;
  cps: TChartPersonSign;
  has_port: Boolean;
begin
  rt := GetRect();
  OffsetRect(rt, SPX, SPY);
  h := aCanvas.TextHeight('A');
  has_port := (FChart.Options.PortraitsVisible) and (FPortrait <> nil);

  aCanvas.Pen.Color := clBlack;
  aCanvas.Pen.Width := 1;

  if (IsDead) then begin
    dt := rt;
    OffsetRect(dt, -2, -2);
    DrawBorder(dt, True);
  end;

  if (Selected) then begin
    aCanvas.Pen.Width := 2;
    case FSex of
      svMale: aCanvas.Pen.Color := clBlue;//clNavy;
      svFemale: aCanvas.Pen.Color := clRed;//clMaroon;
      svNone, svUndetermined: aCanvas.Pen.Color := clBlack;
    end;
  end;

  DrawBorder(rt, False);

  aCanvas.Pen.Color := clBlack;
  aCanvas.Pen.Width := 1;

  if (has_port) then begin
    port_rt := rt;
    port_rt.Right := port_rt.Left + FPortraitWidth;
    xOffsetRect(port_rt, 3, 3);
    aCanvas.StretchDraw(GetDestRect(port_rt, FPortrait), FPortrait);
    rt.Left := rt.Left + FPortraitWidth;
  end;

  line := 0;

  TextOut(rt, FFamily, h, line);

  if not(FChart.Options.DiffLines) then begin
    TextOut(rt, GetFullName(), h, line);
  end else begin
    TextOut(rt, FName, h, line);
    TextOut(rt, FPatronymic, h, line);
  end;

  if not(FChart.Options.OnlyYears) then begin
    if (FChart.Options.BirthDateVisible)
    then TextOut(rt, FBirthDate, h, line);

    if (FChart.Options.DeathDateVisible)
    then TextOut(rt, FDeathDate, h, line);
  end else begin
    TextOut(rt, GetLifeYears(), h, line);
  end;

  if (FChart.Options.Kinship)
  then TextOut(rt, FKinship, h, line);

  if (FChart.Options.SignsVisible) and (FSigns <> []) then begin
    i := 0;
    for cps := Low(TChartPersonSign) to High(TChartPersonSign) do
      if (cps in FSigns) then begin
        aCanvas.Draw(rt.Right, rt.Top - 21 + (i * (SignsData[cps].Pic.Height)), SignsData[cps].Pic);
        Inc(i);
      end;
  end;

  {$IFDEF GEN_DEBUG}
  TextOut(rt, FPath, h, line);
  {$ENDIF}
end;

procedure TCustomPerson.SetKinship(const Value: string);
begin
  FKinship := Value;
  Calc();
end;

function TCustomPerson.GetRect(): TRect;
begin
  Result.Left := FPtX - (FWidth div 2);
  Result.Right := Result.Left + FWidth - 1;

  Result.Top := FPtY;
  Result.Bottom := Result.Top + FHeight - 1;
end;

procedure TCustomPerson.Calc();
var
  wt, maxwid, lines: Integer;
  prt: TRect;
begin
  lines := 2;
  maxwid := FChart.Canvas.TextWidth(FFamily);
  if not(FChart.Options.DiffLines) then begin
    wt := FChart.Canvas.TextWidth(GetFullName());
    if (maxwid < wt) then maxwid := wt;
  end else begin
    wt := FChart.Canvas.TextWidth(FName);
    if (maxwid < wt) then maxwid := wt;
    wt := FChart.Canvas.TextWidth(FPatronymic);
    if (maxwid < wt) then maxwid := wt;
    Inc(lines);
  end;

  if not(FChart.Options.OnlyYears) then begin
    if (FChart.Options.BirthDateVisible) then begin
      wt := FChart.Canvas.TextWidth(FBirthDate);
      if (maxwid < wt) then maxwid := wt;
      Inc(lines);
    end;

    if (FChart.Options.DeathDateVisible) then begin
      wt := FChart.Canvas.TextWidth(FDeathDate);
      if (maxwid < wt) then maxwid := wt;
      Inc(lines);
    end;
  end else begin
    wt := FChart.Canvas.TextWidth(GetLifeYears());
    if (maxwid < wt) then maxwid := wt;
    Inc(lines);
  end;

  if (FChart.Options.Kinship) then begin
    wt := FChart.Canvas.TextWidth(FKinship);
    if (maxwid < wt) then maxwid := wt;
    Inc(lines);
  end;

  {$IFDEF GEN_DEBUG}
  wt := FChart.Canvas.TextWidth(FPath);
  if (maxwid < wt) then maxwid := wt;
  Inc(lines);
  {$ENDIF}

  FWidth := maxwid + 20;
  FHeight := FChart.Canvas.TextHeight('A') * lines + 20;

  if (FChart.Options.PortraitsVisible) and (FPortrait <> nil) then begin
    prt := GetDestRect(Types.Rect(0, 0, FHeight, FHeight), FPortrait);
    FPortraitWidth := (prt.Right - prt.Left) + 1;
    FWidth := FWidth + FPortraitWidth;
  end;
end;

function TCustomPerson.GetDivorced: Boolean;
begin
  Result := (pfDivorced in FFlags);
end;

procedure TCustomPerson.SetDivorced(const Value: Boolean);
begin
  if (Value)
  then Include(FFlags, pfDivorced)
  else Exclude(FFlags, pfDivorced);
end;

function TCustomPerson.GetIsDead: Boolean;
begin
  Result := (pfIsDead in FFlags);
end;

procedure TCustomPerson.SetIsDead(const Value: Boolean);
begin
  if (Value)
  then Include(FFlags, pfIsDead)
  else Exclude(FFlags, pfIsDead);
end;

function TCustomPerson.GetSelected: Boolean;
begin
  Result := (pfSelected in FFlags);
end;

procedure TCustomPerson.SetSelected(const Value: Boolean);
begin
  if (Value)
  then Include(FFlags, pfSelected)
  else Exclude(FFlags, pfSelected);
end;

{ TPerson }

constructor TPerson.Create(aChart: TCustomChartBox);
begin
  inherited Create(aChart);
  FSpouses := nil;
  FChilds := nil;
end;

destructor TPerson.Destroy;
begin
  if (FChilds <> nil) then FChilds.Free;
  if (FSpouses <> nil) then FSpouses.Free;
  inherited Destroy;
end;

procedure TPerson.AddChild(aChild: TPerson);
begin
  if (FChilds = nil)
  then FChilds := TPersonList.Create(False);

  if (aChild <> nil)
  then FChilds.Add(aChild);
end;

procedure TPerson.AddSpouse(aSpouse: TPerson);
begin
  if (FSpouses = nil)
  then FSpouses := TPersonList.Create(False);

  FSpouses.Add(aSpouse);
end;

function TPerson.GetChild(Index: Integer): TPerson;
begin
  if (FChilds = nil)
  then Result := nil
  else Result := FChilds.GetItem(Index);
end;

function TPerson.GetChildsCount: Integer;
begin
  if (FChilds = nil)
  then Result := 0
  else Result := FChilds.Count;
end;

function TPerson.GetSpouse(Index: Integer): TPerson;
begin
  if (FSpouses = nil)
  then Result := nil
  else Result := FSpouses.GetItem(Index);
end;

function TPerson.GetSpousesCount: Integer;
begin
  if (FSpouses = nil)
  then Result := 0
  else Result := FSpouses.Count;
end;

{ TPersonList }

function TPersonList.GetItem(Index: Integer): TPerson;
begin
  {$IFNDEF DELPHI_NET}
  Result := TPerson(inherited GetItem(Index));
  {$ELSE}
  Result := TPerson(inherited Get(Index));
  {$ENDIF}
end;

procedure TPersonList.SetItem(Index: Integer; const Value: TPerson);
begin
  {$IFNDEF DELPHI_NET}
  inherited SetItem(Index, Value);
  {$ELSE}
  inherited Put(Index, Value);
  {$ENDIF}
end;

{ TAncestryChartBox }

constructor TAncestryChartBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPersons := TPersonList.Create(True);
  FFilter := TChartFilter.Create;
  FSpouseDistance := 10;
  FBranchDistance := 40;
  FLevelDistance := 46;
  FMargin := 40;
  FDepthLimit := -1;
  FSelected := nil;

  FGraph := TGraph.Create;
end;

destructor TAncestryChartBox.Destroy;
begin
  FGraph.Destroy;

  FFilter.Destroy;
  FPersons.Free;
  inherited Destroy;
end;

const
  ACSpouseDistance = 10;
  ACBranchDistance = 40;
  ACLevelDistance = 46;
  ACMargin = 40;

procedure TAncestryChartBox.Predef(aCanvas: TCanvas);
var
  sc: Single;
  fsz: Integer;
begin
  sc := (FScale / 100);

  fsz := Round(FOptions.DefFont.Size * sc);
  if (fsz <= 7)
  then aCanvas.Font.Name := 'Small Fonts'
  else aCanvas.Font.Name := FOptions.DefFont.Name;
  aCanvas.Font.Size := fsz;

  FSpouseDistance := Round(ACSpouseDistance * sc);
  FBranchDistance := Round(ACBranchDistance * sc);
  FLevelDistance := Round(ACLevelDistance * sc);
  FMargin := Round(ACMargin * sc);
end;

procedure TAncestryChartBox.Line(aCanvas: TCanvas; X1, Y1, X2, Y2: Integer);
var
  pc: TColor;
  sX1, sY1, sX2, sY2: Integer;
begin
  sX1 := FSPX + X1;
  sX2 := FSPX + X2;
  sY1 := FSPY + Y1;
  sY2 := FSPY + Y2;

  aCanvas.MoveTo(sX1, sY1);
  aCanvas.LineTo(sX2, sY2);

  if (FOptions.Decorative) then begin
    pc := aCanvas.Pen.Color;
    aCanvas.Pen.Color := clSilver;
    if (sX1 = sX2) then begin
      aCanvas.MoveTo(sX1 + 1, sY1 + 1);
      aCanvas.LineTo(sX2 + 1, sY2 + 0);
    end else if (sY1 = sY2) then begin
      aCanvas.MoveTo(sX1 + 1, sY1 + 1);
      aCanvas.LineTo(sX2 + 0, sY2 + 1);
    end;
    aCanvas.Pen.Color := pc;
  end;
end;

procedure TAncestryChartBox.Draw(aCanvas: TCanvas; aPerson: TPerson; aDirKind: TChartKind);

  procedure DrawAncestors();
  var
    cr_y: Integer;
  begin
    Draw(aCanvas, aPerson.Father, ckAncestors);
    Draw(aCanvas, aPerson.Mother, ckAncestors);

    cr_y := aPerson.PtY - FLevelDistance div 2;

    if (aPerson.Father <> nil) or (aPerson.Mother <> nil) then begin
      Line(aCanvas, aPerson.PtX, aPerson.PtY, aPerson.PtX, cr_y);
    end;

    if (aPerson.Father <> nil) then begin
      Line(aCanvas, aPerson.Father.PtX, cr_y, aPerson.PtX, cr_y);
      Line(aCanvas, aPerson.Father.PtX, aPerson.Father.PtY + aPerson.Father.Height - 1, aPerson.Father.PtX, cr_y + 1);
    end;

    if (aPerson.Mother <> nil) then begin
      Line(aCanvas, aPerson.PtX, cr_y, aPerson.Mother.PtX, cr_y);
      Line(aCanvas, aPerson.Mother.PtX, aPerson.Mother.PtY + aPerson.Mother.Height - 1, aPerson.Mother.PtX, cr_y + 1);
    end;
  end;

  procedure DrawDescendants();
  var
    cr_y, i, bpx, epx, cx, spb_beg, spb_ofs, spb_v: Integer;
    child_pt: TPoint;
  begin
    for i := 0 to aPerson.ChildsCount - 1 do
      Draw(aCanvas, aPerson.Childs[i], ckDescendants);

    spb_ofs := {FLevelDistance div 3} ((aPerson.Height - 10) div (aPerson.SpousesCount + 1));
    spb_beg := aPerson.PtY + (aPerson.Height - spb_ofs * (aPerson.SpousesCount - 1)) div 2;

    case aPerson.Sex of
      svMale: begin
        for i := 0 to aPerson.SpousesCount - 1 do begin
          spb_v := spb_beg + (spb_ofs * i);
          Line(aCanvas, aPerson.Rect.Right, spb_v, aPerson.Spouses[i].Rect.Left, spb_v);
        end;
      end;

      svFemale: begin
        for i := 0 to aPerson.SpousesCount - 1 do begin
          spb_v := spb_beg + (spb_ofs * i);
          Line(aCanvas, aPerson.Spouses[i].Rect.Right, spb_v, aPerson.Rect.Left, spb_v);
        end;
      end;
    end;

    for i := 0 to aPerson.SpousesCount - 1 do
      Draw(aCanvas, aPerson.Spouses[i], ckDescendants);

    cr_y := aPerson.PtY + aPerson.Height + FLevelDistance div 2;

    if (aPerson.BaseSpouse = nil)
    or ((aPerson.BaseSpouse <> nil) and (aPerson.BaseSpouse.SpousesCount > 1))
    then begin
      cx := aPerson.PtX;
      spb_beg := aPerson.PtY + aPerson.Height - 1;
    end else begin
      case aPerson.Sex of
        svMale: cx := (aPerson.Rect.Right + aPerson.BaseSpouse.Rect.Left) div 2;
        svFemale: cx := (aPerson.BaseSpouse.Rect.Right + aPerson.Rect.Left) div 2;
      end;

      spb_beg := spb_beg - spb_ofs div 2;
    end;

    if (aPerson.ChildsCount <> 0) then begin
      Line(aCanvas, cx, spb_beg, cx, cr_y); // vert, from fam to childs

      if (aPerson.ChildsCount = 1) then begin
        child_pt := aPerson.Childs[0].Pt;
        Line(aCanvas, child_pt.X, cr_y, child_pt.X, child_pt.Y); // vert, connect from ? to child
      end else begin
        bpx := aPerson.Childs[0].PtX;
        epx := aPerson.Childs[aPerson.ChildsCount-1].PtX;

        Line(aCanvas, bpx, cr_y, epx, cr_y); // horiz, merge childs

        for i := 0 to aPerson.ChildsCount - 1 do begin
          child_pt := aPerson.Childs[i].Pt;
          Line(aCanvas, child_pt.X, cr_y, child_pt.X, child_pt.Y); // vert
        end;
      end;
    end;
  end;

begin
  if (aPerson = nil) then Exit;

  case FKind of
    ckAncestors: DrawAncestors();
    ckDescendants: DrawDescendants();
    ckBoth: begin
      if (aPerson = FRoot) or (aDirKind = ckAncestors) then DrawAncestors();
      if (aPerson = FRoot) or (aDirKind = ckDescendants) then DrawDescendants();
    end;
  end;

  aPerson.Draw(aCanvas, FSPX, FSPY);
end;

function TAncestryChartBox.DoAncestorsStep(aChild: TPerson; aPerson: TGEDCOMIndividualRecord; aGeneration: Integer): TPerson;
var
  family: TGEDCOMFamilyRecord;
  iFather, iMother: TGEDCOMIndividualRecord;
  divorced: Boolean;
begin
  if (aPerson = nil) then begin
    Result := nil;
    Exit;
  end;

  Result := TPerson.Create(Self);
  Result.BuildBy(aPerson);
  Result.Generation := aGeneration;
  FPersons.Add(Result);

  if (aChild <> nil)
  then Result.AddChild(aChild);

  if (FOptions.Kinship)
  then Result.FNode := FGraph.CreateNode(TGraphNode, Result);

  if (FDepthLimit > -1) and (aGeneration = FDepthLimit) then Exit;

  if (aPerson.ChildToFamilyLinksCount > 0) then begin
    family := aPerson.ChildToFamilyLinks[0].Family;

    if (IsRecordAccess(family.Restriction, FShieldState)) then begin
      iFather := TGEDCOMIndividualRecord(family.Husband.Value);
      iMother := TGEDCOMIndividualRecord(family.Wife.Value);

      divorced := (family.GetTagStringValue('_STAT') = 'NOTMARR');

      if (iFather <> nil) and (IsRecordAccess(iFather.Restriction, FShieldState)) then begin
        Result.Father := DoAncestorsStep(Result, iFather, aGeneration + 1);
        if (Result.Father <> nil) then begin
          Result.Father.Divorced := divorced;

          if (FOptions.Kinship)
          then FGraph.CreateLink(Result.FNode, Result.Father.FNode, 1, Ord(rkParent), Ord(rkChild));
        end;
      end else Result.Father := nil;

      if (iMother <> nil) and (IsRecordAccess(iMother.Restriction, FShieldState)) then begin
        Result.Mother := DoAncestorsStep(Result, iMother, aGeneration + 1);
        if (Result.Mother <> nil) then begin
          Result.Mother.Divorced := divorced;

          if (FOptions.Kinship)
          then FGraph.CreateLink(Result.FNode, Result.Mother.FNode, 1, Ord(rkParent), Ord(rkChild));
        end;
      end else Result.Mother := nil;

      if (Result.Father <> nil) and (Result.Mother <> nil) then begin
        if (FOptions.Kinship)
        then FGraph.CreateLink(Result.Father.FNode, Result.Mother.FNode, 1, Ord(rkSpouse), Ord(rkSpouse));
      end;
    end;
  end;
end;

function TAncestryChartBox.DoDescendantsStep(aParent: TPerson; aPerson: TGEDCOMIndividualRecord; aLevel: Integer): TPerson;

  function AddPerson(aParent: TPerson; iRec: TGEDCOMIndividualRecord;
    aKind: TPersonKind; aGeneration: Integer): TPerson;
  begin
    if (FRoot <> nil) and (FRoot.Rec = iRec) then begin
      Result := FRoot;
      Result.Parent := aParent;
      Result.Kind := aKind;
      Exit;
    end;

    Result := TPerson.Create(Self);
    Result.BuildBy(iRec);
    Result.Generation := aGeneration;
    Result.Parent := aParent;
    Result.Kind := aKind;
    FPersons.Add(Result);

    if (FOptions.Kinship)
    then Result.FNode := FGraph.CreateNode(TGraphNode, Result);

    if (aKind <> pkSpouse) and (aParent <> nil)
    then aParent.AddChild(Result);
  end;

  function IsChildless(iRec: TGEDCOMIndividualRecord): Boolean;
  var
    exp: string;
  begin
    exp := GetLifeExpectancy(iRec);
    if (exp = '') or (exp = '?')
    then Result := False
    else Result := (StrToInt(exp) < 15);
  end;

var
  res, res_parent, ft, mt, child: TPerson;
  family: TGEDCOMFamilyRecord;
  child_rec, sp: TGEDCOMIndividualRecord;
  i, k: Integer;
  filter_source: TGEDCOMSourceRecord;
  desc_flag: TPersonFlag;
begin
  Result := nil;
  if (aPerson = nil) then Exit;

  if (FOptions.ChildlessExclude) and (aLevel > 1) then begin
    if (aPerson.SpouseToFamilyLinksCount = 0) and IsChildless(aPerson)
    then Exit;
  end;

  case FFilter.SourceMode of
    gmAll: ;
    gmNone: if (aPerson.SourceCitationsCount <> 0) then Exit;
    gmAny: if (aPerson.SourceCitationsCount = 0) then Exit;
    gmSelected: begin
      if (FFilter.SourceRef = '')
      then filter_source := nil
      else filter_source := FTree.XRefIndex_Find(FFilter.SourceRef) as TGEDCOMSourceRecord;

      if (aPerson.IndexOfSource(filter_source) < 0) then Exit;
    end;
  end;

  case FFilter.BranchCut of
    bcNone: ;
    bcYears, bcPersons: if (Boolean(aPerson.ExtData) = False) then Exit;
  end;

  res := AddPerson(aParent, aPerson, pkDefault, aLevel);
  Result := res;

  for k := 0 to aPerson.SpouseToFamilyLinksCount - 1 do begin
    family := aPerson.SpouseToFamilyLinks[k].Family;
    if not(IsRecordAccess(family.Restriction, FShieldState)) then Continue;

    res_parent := nil;
    case aPerson.Sex of
      svMale: begin
        sp := TGEDCOMIndividualRecord(family.Wife.Value);
        res_parent := AddPerson(nil, sp, pkSpouse, aLevel);
        res_parent.FSex := svFemale;

        ft := res;
        mt := res_parent;
        desc_flag := pfDescByMother;
      end;
      svFemale: begin
        sp := TGEDCOMIndividualRecord(family.Husband.Value);
        res_parent := AddPerson(nil, sp, pkSpouse, aLevel);
        res_parent.FSex := svMale;

        ft := res_parent;
        mt := res;
        desc_flag := pfDescByFather;
      end;
    end;

    if (FOptions.Kinship)
    then FGraph.CreateLink(res.FNode, res_parent.FNode, 1, Ord(rkSpouse), Ord(rkSpouse));

    if (res_parent <> nil) then begin
      res.AddSpouse(res_parent);
      res_parent.BaseSpouse := res;
    end else res_parent := res;

    if (FDepthLimit > -1) and (aLevel = FDepthLimit) then Continue;

    for i := 0 to family.ChildrenCount - 1 do begin
      child_rec := TGEDCOMIndividualRecord(family.Children[i].Value);
      if not(IsRecordAccess(child_rec.Restriction, FShieldState)) then Continue;

      child := DoDescendantsStep(res_parent, child_rec, aLevel + 1);
      if (child <> nil) then begin
        child.Father := ft;
        child.Mother := mt;
        child.FFlags := child.FFlags + [desc_flag];

        if (FOptions.Kinship) then begin
          FGraph.CreateLink(child.FNode, ft.FNode, 1, Ord(rkParent), Ord(rkChild));
          FGraph.CreateLink(child.FNode, mt.FNode, 1, Ord(rkParent), Ord(rkChild));
        end;
      end;
    end;
  end;
end;

procedure TAncestryChartBox.DoFilter(aRoot: TGEDCOMIndividualRecord);

  function DoDescendantsFilter(aPerson: TGEDCOMIndividualRecord): Boolean;
  var
    family: TGEDCOMFamilyRecord;
    child: TGEDCOMIndividualRecord;
    i, k, year: Integer;
    res_child: Boolean;
  begin
    Result := False;
    if (aPerson = nil) then Exit;

    case FFilter.BranchCut of
      bcYears: begin
        year := GetIndependentYear(aPerson, 'BIRT');
        Result := (year >= FFilter.BranchYear);
      end;
      bcPersons: begin
        Result := (Pos(aPerson.XRef + ';', FFilter.BranchPersons) > 0);
      end;
    end;

    for k := 0 to aPerson.SpouseToFamilyLinksCount - 1 do begin
      family := aPerson.SpouseToFamilyLinks[k].Family;

      for i := 0 to family.ChildrenCount - 1 do begin
        child := TGEDCOMIndividualRecord(family.Children[i].Value);
        res_child := DoDescendantsFilter(child);
        Result := Result or res_child;
      end;
    end;

    aPerson.ExtData := TObject(Result);
  end;

begin
  if (FFilter.BranchCut <> bcNone) then begin
    InitExtCounts(FTree, Ord(False));
    DoDescendantsFilter(aRoot);
    aRoot.ExtData := TObject(True);
  end;
end;

procedure InitEdges(var edges: TEdges);
var
  i: Byte;
begin
  for i := Low(Byte) to High(Byte) do edges[i] := 0;
end;

procedure TAncestryChartBox.RecalcAncestorsChart();
var
  prev: TList;
  edges: TEdges;

  procedure ShiftAnc(aPerson: TPerson; aOffset: Integer);
  var
    pp: TPerson;
  begin
    pp := aPerson;
    while (pp <> nil) do begin
      pp.PtX := pp.PtX + aOffset;
      edges[pp.Generation] := pp.Rect.Right;

      if (pp.ChildsCount < 1)
      then pp := nil
      else pp := pp.Childs[0];
    end;
  end;

  procedure RecalcAnc(aPerson: TPerson; aPt: TPoint);
  var
    offset, i, gen: Integer;
    pp: TPerson;
    xpt: TPoint;
  begin
    if (aPerson = nil) then Exit;

    aPerson.Pt := aPt;
    gen := aPerson.Generation;

    /// prepare intersects

    // horizontal adjustment
    if (edges[gen] > 0) then offset := FBranchDistance else offset := FMargin;
    if (aPerson.Rect.Left <= edges[gen] + offset)
    then ShiftAnc(aPerson, ((edges[gen] + offset) - aPerson.Rect.Left));

    edges[gen] := aPerson.Rect.Right;

    // vertical adjustment
    prev.Add(aPerson);
    if (aPerson.Rect.Top < 0) then begin
      offset := (0 - aPerson.Rect.Top) + Margin;

      for i := 0 to prev.Count - 1 do begin
        pp := TPerson(prev[i]);
        pp.PtY := pp.PtY + offset;
      end;
    end;

    /// adjust parents

    if (aPerson.Father <> nil) and (aPerson.Mother <> nil) then begin
      // calc father
      xpt := Point(aPerson.PtX - (FSpouseDistance + (aPerson.Father.Width div 2)),
                   aPerson.PtY - FLevelDistance - aPerson.Height);
      RecalcAnc(aPerson.Father, xpt);

      // calc mother
      xpt := Point(aPerson.PtX + (FSpouseDistance + (aPerson.Mother.Width div 2)),
                   aPerson.PtY - FLevelDistance - aPerson.Height);
      RecalcAnc(aPerson.Mother, xpt);

      // align child
      aPerson.PtX := (aPerson.Father.PtX + aPerson.Mother.PtX) div 2;
      edges[aPerson.Generation] := aPerson.Rect.Right;
    end else begin
      xpt := Point(aPerson.PtX, aPerson.PtY - FLevelDistance - aPerson.Height);

      if (aPerson.Father <> nil) then RecalcAnc(aPerson.Father, xpt)
      else
      if (aPerson.Mother <> nil) then RecalcAnc(aPerson.Mother, xpt);
    end;

    if (FWMax < aPerson.Rect.Right) then FWMax := aPerson.Rect.Right;
    if (FHMax < aPerson.Rect.Bottom) then FHMax := aPerson.Rect.Bottom;
  end;

begin
  InitEdges(edges);

  prev := TList.Create;
  try
    RecalcAnc(FRoot, Point(FMargin, FMargin));
  finally
    prev.Destroy;
  end;
end;

procedure TAncestryChartBox.RecalcDescendantsChart(aPreDef: Boolean);
var
  edges: TEdges;

  procedure ShiftDesc(aPerson: TPerson; aOffset: Integer; aSingle: Boolean);
  var
    p: TPerson;
  begin
    {p := aPerson;
    while (p <> nil) do begin
      p.PtX := p.PtX + aOffset;

      if (p.BaseSpouse <> nil)
      and ((p.BaseSpouse.Sex = svFemale) or (p.BaseSpouse.SpousesCount = 1))
      then p := p.BaseSpouse
      else p := p.Parent;
    end;}

    p := aPerson;
    if (p = nil) then Exit;
    if (p = FRoot) then aSingle := False;

    p.PtX := p.PtX + aOffset;

    if (p.BaseSpouse <> nil)
    and ((p.BaseSpouse.Sex = svFemale) or (p.BaseSpouse.SpousesCount = 1))
    then begin
      ShiftDesc(p.BaseSpouse, aOffset, aSingle);
    end else begin
      if not(aSingle) then begin
        ShiftDesc(p.Father, aOffset, aSingle);
        ShiftDesc(p.Mother, aOffset, aSingle);
      end else begin
        if (pfDescByFather in p.FFlags)
        then ShiftDesc(p.Father, aOffset, aSingle)
        else
        if (pfDescByMother in p.FFlags)
        then ShiftDesc(p.Mother, aOffset, aSingle);
      end;
    end;
  end;

  procedure RecalcDesc(aPerson: TPerson; aPt: TPoint; aPreDef: Boolean = True);

    procedure RecalcChilds();
    var
      childs_width, i, cur_x, cur_y, cent_x: Integer;
      child: TPerson;
      fix_pair: Boolean;
    begin
      if (aPerson.ChildsCount = 0) then Exit;

      fix_pair := (aPerson.BaseSpouse <> nil) and (aPerson.BaseSpouse.SpousesCount = 1);

      if (fix_pair) then begin
        case aPerson.Sex of
          svMale: cent_x := (aPerson.Rect.Right + aPerson.BaseSpouse.Rect.Left) div 2;
          svFemale: cent_x := (aPerson.BaseSpouse.Rect.Right + aPerson.Rect.Left) div 2;
        end;
      end else cent_x := aPerson.PtX;

      cur_y := aPerson.PtY + FLevelDistance + aPerson.Height;

      childs_width := (aPerson.ChildsCount - 1) * FBranchDistance;
      for i := 0 to aPerson.ChildsCount - 1 do begin
        childs_width := childs_width + aPerson.Childs[i].Width;
      end;
      cur_x := cent_x - (childs_width div 2);

      for i := 0 to aPerson.ChildsCount - 1 do begin
        child := aPerson.Childs[i];
        RecalcDesc(child, Point(cur_x + (child.Width div 2), cur_y));
        cur_x := child.Rect.Right + FBranchDistance;
      end;

      /// adjusting
      cur_x := aPerson.Childs[0].PtX;
      if (aPerson.ChildsCount > 1)
      then cur_x := cur_x + ((aPerson.Childs[aPerson.ChildsCount - 1].PtX - cur_x) div 2);

      if (fix_pair) then begin
        case aPerson.Sex of
          svMale: begin
            //aPerson.PtX := cur_x - ((BranchDistance + aPerson.Width) div 2) + 1;
            //aPerson.BaseSpouse.PtX := cur_x + ((BranchDistance + aPerson.BaseSpouse.Width) div 2);

            ShiftDesc(aPerson, (cur_x - ((BranchDistance + aPerson.Width) div 2) + 1) - aPerson.PtX, True);
            ShiftDesc(aPerson.BaseSpouse, (cur_x + ((BranchDistance + aPerson.BaseSpouse.Width) div 2)) - aPerson.BaseSpouse.PtX, True);
          end;
          svFemale: begin
            //aPerson.PtX := cur_x + ((BranchDistance + aPerson.Width) div 2);
            //aPerson.BaseSpouse.PtX := cur_x - ((BranchDistance + aPerson.BaseSpouse.Width) div 2) + 1;

            ShiftDesc(aPerson, (cur_x + ((BranchDistance + aPerson.Width) div 2)) - aPerson.PtX, True);
            ShiftDesc(aPerson.BaseSpouse, (cur_x - ((BranchDistance + aPerson.BaseSpouse.Width) div 2) + 1) - aPerson.BaseSpouse.PtX, True);
          end;
        end;
      end else begin
        //aPerson.PtX := cur_x;
        ShiftDesc(aPerson, cur_x - aPerson.PtX, True);
      end;
    end;
    
  var
    i, offset, gen: Integer;
    sp, prev: TPerson;
    sp_pt: TPoint;
  begin
    if (aPerson = nil) then Exit;

    gen := aPerson.Generation;

    if (aPreDef)
    then aPerson.Pt := aPt;

    /// prepare intersects
    if (edges[gen] > 0) then offset := FBranchDistance else offset := FMargin;
    if (aPerson.Rect.Left <= edges[gen] + offset)
    then ShiftDesc(aPerson, ((edges[gen] + offset) - aPerson.Rect.Left), True);

    ///
    if (aPerson.Sex = svMale) then begin
      RecalcChilds();
      edges[gen] := aPerson.Rect.Right;
    end;

    if (aPerson.SpousesCount > 0) then begin
      prev := aPerson;
      for i := 0 to aPerson.SpousesCount - 1 do begin
        sp := aPerson.Spouses[i];

        case aPerson.Sex of
          svMale: sp_pt := Point(prev.Rect.Right + (FBranchDistance + (sp.Width div 2)), aPerson.PtY);
          svFemale: sp_pt := Point(prev.Rect.Left - (FBranchDistance + (sp.Width div 2)), aPerson.PtY);
        end;

        RecalcDesc(sp, sp_pt);

        if (sp.Sex <> svMale)
        then prev := sp;
      end;
    end;

    if (aPerson.Sex = svFemale) then begin
      RecalcChilds();
      edges[gen] := aPerson.Rect.Right;
    end;
    ///

    if (FWMax < aPerson.Rect.Right) then FWMax := aPerson.Rect.Right;
    if (FHMax < aPerson.Rect.Bottom) then FHMax := aPerson.Rect.Bottom;
  end;

begin
  InitEdges(edges);

  RecalcDesc(FRoot, Point(FMargin, FMargin), aPreDef);
end;

procedure TAncestryChartBox.InternalGenChart(aPerson: TGEDCOMIndividualRecord; aKind: TChartKind);
begin
  FKind := aKind;

  FSelected := nil;
  FPersons.Clear;

  Predef(Canvas);

  FGraph.Clear;

  DoFilter(aPerson);

  FRoot := nil;
  case FKind of
    ckAncestors: FRoot := DoAncestorsStep(nil, aPerson, 1);
    ckDescendants: FRoot := DoDescendantsStep(nil, aPerson, 1);
    ckBoth: begin
      FRoot := DoAncestorsStep(nil, aPerson, 1);
      DoDescendantsStep(nil, aPerson, 1);
    end;
  end;

  FKinRoot := FRoot;

  RecalcChart();
end;

procedure TAncestryChartBox.RecalcChart();
var
  i: Integer;
  p: TPerson;
begin
  if (FOptions.Kinship) then begin
    FGraph.FindPathTree(FKinRoot.FNode);

    for i := 0 to FPersons.Count - 1 do begin
      p := FPersons[i];
      p.Kinship := FindRelationship(p);
    end;
  end;

  FHMax := 0;
  FWMax := 0;

  case FKind of
    ckAncestors: RecalcAncestorsChart();
    ckDescendants: RecalcDescendantsChart(True);
    ckBoth: begin
      RecalcAncestorsChart();
      RecalcDescendantsChart(False);
    end;
  end;

  FHMax := FHMax + FMargin - 1;
  FWMax := FWMax + FMargin - 1;

  FImageHeight := FHMax;
  FImageWidth := FWMax;
end;

procedure TAncestryChartBox.SaveSnapshot(const aFileName: string);
var
  pic: TGraphic;
  canv: TCanvas;
  ext: string;
{$IFNDEF DELPHI_NET}
  jpg: TJPEGImage;
{$ENDIF}
begin
  ext := AnsiLowerCase(ExtractFileExt(aFileName));

  if (ext = '.bmp') or (ext = '.jpg') then begin
    if (FImageWidth >= High(Word)) then begin
      MessageDlg(LSList[LSID_TooMuchWidth], mtError, [mbOk], 0);
      Exit;
    end;

    pic := TBitmap.Create;
    pic.Width := FImageWidth;
    pic.Height := FImageHeight;
    TBitmap(pic).PixelFormat := pf8bit;
    canv := TBitmap(pic).Canvas;
  end
  else
  if (ext = '.emf') then begin
    pic := TMetafile.Create;
    pic.Width := FImageWidth;
    pic.Height := FImageHeight;
    TMetafile(pic).Enhanced := True;
    canv := TMetafileCanvas.Create(TMetafile(pic), 0);
  end;

  try
    try
      Predef(canv);
      TreeDraw(canv, False);
    finally
      if (canv is TMetafileCanvas) then canv.Destroy;
    end;

    if (ext = '.bmp') or (ext = '.emf')
    then pic.SaveToFile(aFileName)
    else
    if (ext = '.jpg')
    then begin
      {$IFNDEF DELPHI_NET}
      jpg := TJPEGImage.Create;
      try
        jpg.Assign(pic);
        jpg.CompressionQuality := 100;
        jpg.Compress();
        jpg.SaveToFile(aFileName);
      finally
        jpg.Destroy;
      end;
      {$ENDIF}
    end;
  finally
    pic.Destroy;
  end;
end;

procedure TAncestryChartBox.SelectBy(aX, aY: Integer);
var
  i: Integer;
  p: TPerson;
begin
  aX := aX - FSPX;
  aY := aY - FSPY;

  for i := 0 to FPersons.Count - 1 do begin
    p := FPersons[i];

    if PtInRect(p.Rect, Point(aX, aY)) then begin
      SetSelected(p);
      Exit;
    end;
  end;

  SetSelected(nil);
end;

procedure TAncestryChartBox.SelectByRec(iRec: TGEDCOMIndividualRecord);
var
  i: Integer;
  p: TPerson;
begin
  for i := 0 to FPersons.Count - 1 do begin
    p := FPersons[i];

    if (p.Rec = iRec) then begin
      SetSelected(p);
      Exit;
    end;
  end;

  SetSelected(nil);
end;

procedure TAncestryChartBox.RebuildKinships();
var
  p: TPerson;
begin
  if (FOptions.Kinship) then begin
    p := FSelected;

    if (p <> nil) then begin
      FKinRoot := p;
      RecalcChart();
      ScrollRange();
      Invalidate;
    end;
  end;
end;

procedure TAncestryChartBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
end;

type
  TRelLink = class(TObject)
  public
    xFrom, xTo: TPerson;
    xRel: TRelationKind; // ��� ���� xTo �� ��������� � xFrom
  end;

function TAncestryChartBox.FindRelationship(aTarget: TPerson): string;
var
  path: TObjectList;

  procedure FixLink(f, t: TPerson; rel: TRelationKind);
  var
    L: TRelLink;
  begin
    L := TRelLink.Create;
    L.xFrom := f;
    L.xTo := t;

    case rel of
      rkParent:
        case L.xTo.Sex of
          svMale: L.xRel := rkFather;
          svFemale: L.xRel := rkMother;
        end;
      rkSpouse:
        case L.xTo.Sex of
          svMale: L.xRel := rkHusband;
          svFemale: L.xRel := rkWife;
        end;
      rkChild:
        case L.xTo.Sex of
          svMale: L.xRel := rkSon;
          svFemale: L.xRel := rkDaughter;
        end;
      else L.xRel := rel;
    end;

    path.Add(L);
  end;

  function GetGreat(n: Integer): string;
  var
    i: Integer;
  begin
    Result := '';
    for i := 1 to n do Result := Result + '���';
  end;

  function FixRelation(Rel: TRelationKind; Great: Integer): string;
  var
    tmp: string;
  begin
    if (Great <> 0) then begin
      if (Rel in [rkUncle, rkAunt{, rkCousinM, rkCousinF}]) then begin
        tmp := Numerals[Great + 1] + NumKinship[aTarget.Sex] + ' ';

        if (Rel = rkUncle) then Rel := rkGrandfather;
        if (Rel = rkAunt) then Rel := rkGrandmother;

        {if (Rel = rkCousinM) then Rel := rkBrother;
        if (Rel = rkCousinF) then Rel := rkSister;}
      end else begin
        if (Rel <> rkUndefined)
        then tmp := GetGreat(Great);
      end;
    end else tmp := '';

    Result := tmp + LSList[RelationKinds[Rel]];
  end;

var
  i, great, g, lev: Integer;
  L: TRelLink;
  prev_rel, cur_rel, fin_rel: TRelationKind;
  link: TGraphLink;
  {$IFDEF GEN_DEBUG}
  tmp: string;
  {$ENDIF}
begin
  Result := '';

  path := TObjectList.Create(True);
  try
    link := aTarget.FNode.LinkIn;
    while (link <> nil) do begin
      FixLink(TPerson(link.Node1.ExtObj), TPerson(link.Node2.ExtObj), TRelationKind(link.ExtData));
      link := link.Node1.LinkIn;
    end;

    {$IFDEF GEN_DEBUG}
    tmp := '';
    {$ENDIF}

    prev_rel := rkNone;
    fin_rel := rkNone;
    great := 0;
    for i := path.Count - 1 downto 0 do begin
      L := TRelLink(path[i]);
      cur_rel := L.xRel;

      {$IFDEF GEN_DEBUG}
      if (tmp <> '') then tmp := tmp + ', ';
      if (L.xFrom.Rec <> nil) then tmp := tmp + L.xFrom.Rec.XRef + '>' + RelationSigns[cur_rel] + '>';
      if (L.xTo.Rec <> nil) then tmp := tmp + L.xTo.Rec.XRef;
      {$ENDIF}

      if (prev_rel <> rkUndefined) then begin
        fin_rel := FindKinship(prev_rel, cur_rel, g, lev);
        great := great + g;

        //if (great <> 0) and (lev <> 0) then Inc(great, lev); // fool

        prev_rel := fin_rel;
      end;
    end;

    {$IFDEF GEN_DEBUG}
    if (aTarget.Rec <> nil) then aTarget.FPath := aTarget.Rec.XRef + ' ';
    aTarget.FPath := aTarget.FPath + ' [' + tmp + ']';
    {$ENDIF}

    Result := '[' + FixRelation(fin_rel, great) + ']';
  finally
    path.Free;
  end;
end;

{==============================================================================}

{ TChartFilter }

constructor TChartFilter.Create;
begin
  inherited Create;
  Clear();
end;

procedure TChartFilter.Backup;
begin
  Back_SourceMode := SourceMode;
  Back_SourceRef := SourceRef;

  Back_BranchCut := BranchCut;
  Back_BranchYear := BranchYear;
  Back_BranchPersons := BranchPersons;
end;

procedure TChartFilter.Clear;
begin
  SourceMode := gmAll;
  BranchCut := bcNone;

  /// remared for saving in session
  //SourceRef := '';
  //BranchYear := 0;
  //BranchPersons := '';
end;

procedure TChartFilter.Restore;
begin
  SourceMode := Back_SourceMode;
  SourceRef := Back_SourceRef;

  BranchCut := Back_BranchCut;
  BranchYear := Back_BranchYear;
  BranchPersons := Back_BranchPersons;
end;

initialization
  InitSigns();

finalization
  DoneSigns();

end.
