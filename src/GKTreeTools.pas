unit GKTreeTools; {prepare:partial; trans:fin}

{$I GEDKeeper.inc}

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ComCtrls,
  StdCtrls, Buttons, ExtCtrls, Contnrs, GedCom551, GKImport, GKLists, GKBase,
  GKEngine, GKCtrls, GKLangs;

type
  TMergeMode = (mmPerson, mmNote, mmFamily, mmSource);

  TCheckDiag = (cdPersonLonglived, cdPersonSexless, cdLiveYearsInvalid,
    cdStrangeSpouse, cdStrangeParent);

  TCheckSolve = (csSkip, csSetIsDead, csDefineSex);

  TCheckObj = class(TObject)
  private
    FComment: string;
    FDiag: TCheckDiag;
    FRec: TGEDCOMRecord;
    FSolve: TCheckSolve;

    function GetRecName(): string;
  public
    property Comment: string read FComment write FComment;
    property Diag: TCheckDiag read FDiag write FDiag;
    property Rec: TGEDCOMRecord read FRec write FRec;
    property RecName: string read GetRecName;
    property Solve: TCheckSolve read FSolve write FSolve;
  end;

  TfmTreeTools = class(TForm, ILocalization)
    PageControl: TPageControl;
    SheetChoice: TTabSheet;
    SheetTreeCompare: TTabSheet;
    ListCompare: TMemo;
    btnClose: TBitBtn;
    rgOperation: TRadioGroup;
    btnBack: TBitBtn;
    btnNext: TBitBtn;
    Label1: TLabel;
    edCompareFile: TEdit;
    btnFileChoose: TBitBtn;
    OpenDialog1: TOpenDialog;
    SheetTreeMerge: TTabSheet;
    SheetTreeSplit: TTabSheet;
    SaveDialog1: TSaveDialog;
    btnSelectAll: TBitBtn;
    ListSelected: TListBox;
    ListSkipped: TListBox;
    btnSelectFamily: TBitBtn;
    btnSelectAncestors: TBitBtn;
    btnSelectDescendants: TBitBtn;
    btnDelete: TBitBtn;
    btnSave: TBitBtn;
    SheetRecMerge: TTabSheet;
    PageControl1: TPageControl;
    SheetMerge: TTabSheet;
    Lab1: TLabel;
    Lab2: TLabel;
    btnSearch: TBitBtn;
    Edit1: TEdit;
    Edit2: TEdit;
    btnRec1Select: TBitBtn;
    btnRec2Select: TBitBtn;
    Memo1: TMemo;
    Memo2: TMemo;
    btnMergeToLeft: TBitBtn;
    btnMergeToRight: TBitBtn;
    btnSkip: TBitBtn;
    ProgressBar1: TProgressBar;
    SheetOptions: TTabSheet;
    rgMode: TRadioGroup;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    rbDirectMatching: TRadioButton;
    rbIndistinctMatching: TRadioButton;
    edNameAccuracy: TEdit;
    udNameAccuracy: TUpDown;
    edYearInaccuracy: TEdit;
    udYearInaccuracy: TUpDown;
    chkBirthYear: TCheckBox;
    SheetTreeImport: TTabSheet;
    Label3: TLabel;
    edImportFile: TEdit;
    btnImportFileChoose: TBitBtn;
    ListBox1: TListBox;
    OpenDialog2: TOpenDialog;
    SheetFamilyGroups: TTabSheet;
    TreeView1: TTreeView;
    SheetTreeCheck: TTabSheet;
    btnBaseRepair: TBitBtn;
    Panel1: TPanel;
    Label4: TLabel;
    edMasterBase: TEdit;
    Label7: TLabel;
    edUpdateBase: TEdit;
    btnUpdateSelect: TBitBtn;
    gbSyncType: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    mSyncRes: TMemo;
    SheetPatSearch: TTabSheet;
    btnPatSearch: TBitBtn;
    Panel3: TPanel;
    Label8: TLabel;
    edMinGens: TEdit;
    udMinGens: TUpDown;
    SheetPlaceManage: TTabSheet;
    Panel4: TPanel;
    rgTreeMergeType: TRadioGroup;
    btnHelp: TBitBtn;
    btnSetPatriarch: TBitBtn;
    chkOnlyNP: TCheckBox;
    btnIntoList: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnFileChooseClick(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnSelectFamilyClick(Sender: TObject);
    procedure btnSelectAncestorsClick(Sender: TObject);
    procedure btnSelectDescendantsClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnRec1SelectClick(Sender: TObject);
    procedure btnRec2SelectClick(Sender: TObject);
    procedure btnMergeToLeftClick(Sender: TObject);
    procedure btnMergeToRightClick(Sender: TObject);
    procedure rgModeClick(Sender: TObject);
    procedure btnSkipClick(Sender: TObject);
    procedure btnImportFileChooseClick(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure btnBaseRepairClick(Sender: TObject);
    procedure btnUpdateSelectClick(Sender: TObject);
    procedure btnPatSearchClick(Sender: TObject);
    procedure rgTreeMergeTypeClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnSetPatriarchClick(Sender: TObject);
    procedure btnIntoListClick(Sender: TObject);
  private
    FSplitList: TList;
    FTree: TGEDCOMTree;

    FRec1, FRec2: TGEDCOMRecord;
    FRMMode: TMergeMode;
    FRMSkip: TStringList;
    FRMIndex: Integer;

    FPlaces: TStringList;
    ListPlaces: TGKListView;

    FChecksList: TObjectList;
    ListChecks: TGKListView;

    ListPatriarchs: TGKListView;

    procedure SearchDups();
    procedure RecordMerge(aRecBase, aRecCopy: TGEDCOMRecord);
    procedure SetRec1(const Value: TGEDCOMRecord);
    procedure SetRec2(const Value: TGEDCOMRecord);

    procedure Select(aPerson: TGEDCOMIndividualRecord; aMode: TTreeWalkMode);
    procedure CheckRelations();
    procedure UpdateSplitLists();

    procedure TreeCompare(aMainTree: TGEDCOMTree; aFileName: string);

    procedure CheckGroups();

    procedure SelectTool(aToolIndex: Integer);
    function GetBase: TfmBase;

    procedure PrepareChecksList();
    procedure CheckBase();
    procedure ListChecksDblClick(Sender: TObject);

    procedure PreparePatriarchsList();
    procedure ListPatriarchsDblClick(Sender: TObject);

    procedure PreparePlacesList();
    procedure PlacesClear();
    procedure PlacesCheck();
    procedure ListPlacesDblClick(Sender: TObject);
  public
    property Base: TfmBase read GetBase;

    procedure SetLang();
  end;

implementation

uses
  {$IFDEF DELPHI_NET}System.IO,{$ENDIF}
  GKUtils, GKMain, GKRecordSelect, GKProgress, GKSexCheck;

{$R *.dfm}

const
  HelpTopics: array [0..8] of string = (
    '::/gkhTools_TreeCompare.htm',
    '::/gkhTools_TreeMerge.htm',
    '::/gkhTools_TreeSplit.htm',
    '::/gkhTools_DubsMerge.htm',
    '::/gkhTools_TreeImport.htm',
    '::/gkhTools_FamiliesConnectivity.htm',
    '::/gkhTools_TreeCheck.htm',
    '::/gkhTools_PatSearch.htm',
    '::/gkhTools_PlacesManage.htm'
  );

{==============================================================================}

{ TCheckObj }

function TCheckObj.GetRecName(): string;
begin
  Result := '';

  if (FRec is TGEDCOMIndividualRecord)
  then Result := GetNameStr(TGEDCOMIndividualRecord(FRec));
end;

{==============================================================================}

procedure TfmTreeTools.FormCreate(Sender: TObject);
begin
  FTree := Base.Tree;
  PageControl.ActivePageIndex := 0;

  FSplitList := TList.Create;

  FRMSkip := TStringList.Create;
  SetRec1(nil);
  SetRec2(nil);
  FRMMode := mmPerson;
  rgMode.ItemIndex := 0;

  FPlaces := TStringList.Create;
  FPlaces.Sorted := True;

  FChecksList := TObjectList.Create(True);

  PrepareChecksList();
  PreparePatriarchsList();
  PreparePlacesList();

  SetLang();
end;

procedure TfmTreeTools.FormDestroy(Sender: TObject);
begin
  FChecksList.Free;

  PlacesClear();
  FPlaces.Free;

  FRMSkip.Free;

  FSplitList.Free;
end;

procedure TfmTreeTools.SetLang();
begin
  btnClose.Caption := LSList[LSID_DlgClose];
  btnHelp.Caption := LSList[LSID_MIHelp];
  btnBack.Caption := '< ' + LSList[LSID_Backward];
  btnNext.Caption := LSList[LSID_Forward] + ' >';

  rgOperation.Caption := LSList[LSID_Operation];
  rgOperation.Items[0] := LSList[LSID_ToolOp_1];
  rgOperation.Items[1] := LSList[LSID_ToolOp_2];
  rgOperation.Items[2] := LSList[LSID_ToolOp_3];
  rgOperation.Items[3] := LSList[LSID_ToolOp_4];
  rgOperation.Items[4] := LSList[LSID_ToolOp_5];
  rgOperation.Items[5] := LSList[LSID_ToolOp_6];
  rgOperation.Items[6] := LSList[LSID_ToolOp_7];
  rgOperation.Items[7] := LSList[LSID_ToolOp_8];
  rgOperation.Items[8] := LSList[LSID_ToolOp_9];

  Label1.Caption := LSList[LSID_MIFile];
  btnFileChoose.Caption := LSList[LSID_DlgSelect] + '...';

  {fixme!}
  //Label4
  //edMasterBase
  //Label7
  btnUpdateSelect.Caption := LSList[LSID_DlgSelect] + '...';
  //rgTreeMergeType
  //gbSyncType

  btnSelectAll.Caption := LSList[LSID_SelAll];
  btnSelectFamily.Caption := LSList[LSID_SelFamily];
  btnSelectAncestors.Caption := LSList[LSID_SelAncestors];
  btnSelectDescendants.Caption := LSList[LSID_SelDescendants];
  btnDelete.Caption := LSList[LSID_DoDelete];
  btnSave.Caption := LSList[LSID_MIFileSave];

  SheetMerge.Caption := LSList[LSID_RecMerge];
  SheetOptions.Caption := LSList[LSID_MIOptions];
  btnRec1Select.Caption := LSList[LSID_DlgSelect] + '...';
  btnRec2Select.Caption := LSList[LSID_DlgSelect] + '...';
  btnSearch.Caption := LSList[LSID_RM_Search];
  btnSkip.Caption := LSList[LSID_RM_Skip];
  rgMode.Caption := LSList[LSID_RM_Records];
  rgMode.Items[0] := LSList[LSID_RPIndividuals];
  rgMode.Items[1] := LSList[LSID_RPNotes];
  rgMode.Items[2] := LSList[LSID_RPFamilies];
  rgMode.Items[3] := LSList[LSID_RPSources];

  GroupBox1.Caption := LSList[LSID_RM_SearchPersons];
  rbDirectMatching.Caption := LSList[LSID_RM_DirectMatching];
  rbIndistinctMatching.Caption := LSList[LSID_RM_IndistinctMatching];
  chkOnlyNP.Caption := LSList[LSID_RM_OnlyNP];
  chkBirthYear.Caption := LSList[LSID_RM_BirthYear];
  Label5.Caption := LSList[LSID_RM_NameAccuracy];
  Label6.Caption := LSList[LSID_RM_YearInaccuracy];

  Label3.Caption := LSList[LSID_MIFile];
  btnImportFileChoose.Caption := LSList[LSID_DlgSelect] + '...';

  btnBaseRepair.Caption := LSList[LSID_Repair];

  Label8.Caption := LSList[LSID_MinGenerations];
  btnSetPatriarch.Caption := LSList[LSID_SetPatFlag];
  btnPatSearch.Caption := LSList[LSID_Search];

  btnIntoList.Caption := LSList[LSID_InsertIntoBook];
end;

procedure TfmTreeTools.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) then Close;
end;

procedure TfmTreeTools.TreeCompare(aMainTree: TGEDCOMTree; aFileName: string);

  procedure AddDiag(aDiag: string);
  begin
    ListCompare.Lines.Add(aDiag);
    Application.ProcessMessages();
  end;

var
  tempTree: TGEDCOMTree;
  i, idx, k: Integer;
  iRec: TGEDCOMIndividualRecord;
  fams, names: TStringList;
  fam, nam, pat, tm: string;
  lst: TList;
begin
  ListCompare.Clear;

  tempTree := TGEDCOMTree.Create;
  tempTree.LoadFromFile(aFileName);
  fams := TStringList.Create;
  names := TStringList.Create;
  try
    AddDiag(LSList[LSID_SearchMatches]);

    for i := 0 to aMainTree.RecordsCount - 1 do
      if (aMainTree.Records[i] is TGEDCOMIndividualRecord) then begin
        iRec := aMainTree.Records[i] as TGEDCOMIndividualRecord;

        idx := names.AddObject(GetNameStr(iRec), TList.Create);
        TList(names.Objects[idx]).Add(iRec);

        GetNameParts(iRec, fam, nam, pat);
        fams.AddObject(PrepareRusFamily(fam, (iRec.Sex = svFemale)), nil);
      end;

    for i := 0 to tempTree.RecordsCount - 1 do
      if (tempTree.Records[i] is TGEDCOMIndividualRecord) then begin
        iRec := tempTree.Records[i] as TGEDCOMIndividualRecord;
        tm := GetNameStr(iRec);

        idx := names.IndexOf(tm);
        if (idx >= 0)
        then TList(names.Objects[idx]).Add(iRec);

        GetNameParts(iRec, fam, nam, pat);
        tm := PrepareRusFamily(fam, (iRec.Sex = svFemale));

        idx := fams.IndexOf(tm);
        if (idx >= 0)
        then fams.Objects[idx] := TObject(1);
      end;

    for i := fams.Count - 1 downto 0 do
      if (fams.Objects[i] = nil) or (fams[i] = '?') then fams.Delete(i);

    for i := names.Count - 1 downto 0 do
      if (TList(names.Objects[i]).Count = 1) then begin
        TList(names.Objects[i]).Free;
        names.Delete(i);
      end;

    if (fams.Count <> 0) then begin
      AddDiag(LSList[LSID_SimilarSurnames]);
      for i := 0 to fams.Count - 1 do AddDiag('    ' + fams[i]);
    end;

    if (names.Count <> 0) then begin
      AddDiag(LSList[LSID_SimilarNames]);
      for i := 0 to names.Count - 1 do begin
        AddDiag('    ' + names[i]);
        lst := TList(names.Objects[i]);
        for k := 0 to lst.Count - 1 do begin
          iRec := TGEDCOMIndividualRecord(lst[k]);
          AddDiag('      * ' + GetNameStr(iRec) + ' ' + GetLifeStr(iRec));
        end;
      end;
    end;
  finally
    for i := 0 to names.Count - 1 do TObject(names.Objects[i]).Free;
    names.Free;

    fams.Free;
    tempTree.Destroy;
  end;
end;

procedure TfmTreeTools.SelectTool(aToolIndex: Integer);
begin
  case aToolIndex of
    0..4: ;
    5: CheckGroups();
    6: CheckBase();
    7: ;
    8: PlacesCheck();
  end;
end;

procedure TfmTreeTools.btnBackClick(Sender: TObject);
begin
  PageControl.ActivePageIndex := 0;
  btnBack.Enabled := False;
  btnNext.Enabled := True;
end;

procedure TfmTreeTools.btnNextClick(Sender: TObject);
begin
  PageControl.ActivePageIndex := rgOperation.ItemIndex + 1;
  btnBack.Enabled := True;
  btnNext.Enabled := False;

  SelectTool(rgOperation.ItemIndex);
end;

procedure TfmTreeTools.btnFileChooseClick(Sender: TObject);
begin
  if OpenDialog1.Execute() then begin
    edCompareFile.Text := OpenDialog1.FileName;
    TreeCompare(FTree, edCompareFile.Text);
  end;
end;

procedure TfmTreeTools.Select(aPerson: TGEDCOMIndividualRecord; aMode: TTreeWalkMode);
begin
  FSplitList.Clear;
  TreeWalk(aPerson, aMode, FSplitList);

  UpdateSplitLists();
end;

procedure TfmTreeTools.UpdateSplitLists();
var
  i, cnt: Integer;
  i_rec: TGEDCOMIndividualRecord;
begin
  ListSelected.Items.BeginUpdate;
  ListSelected.Items.Clear;

  ListSkipped.Items.BeginUpdate;
  ListSkipped.Items.Clear;

  try
    cnt := 0;
    for i := 0 to FTree.RecordsCount - 1 do
      if (FTree.Records[i] is TGEDCOMIndividualRecord) then begin
        Inc(cnt);

        i_rec := (FTree.Records[i] as TGEDCOMIndividualRecord);

        if (FSplitList.IndexOf(i_rec) < 0)
        then ListSkipped.Items.Add(i_rec.XRef + ' / ' + GetNameStr(i_rec))
        else ListSelected.Items.Add(i_rec.XRef + ' / ' + GetNameStr(i_rec));
      end;

    Caption := IntToStr(FSplitList.Count) + ' / ' + IntToStr(cnt);
  finally
    ListSelected.Items.EndUpdate;
    ListSkipped.Items.EndUpdate;
  end;
end;

procedure TfmTreeTools.CheckRelations();

  procedure AddRel(aRec: TGEDCOMRecord);
  begin
    if (FSplitList.IndexOf(aRec) < 0)
    then FSplitList.Add(aRec);
  end;

  procedure CheckRecord(rec: TGEDCOMRecord);
  var
    i: Integer;
  begin
    for i := 0 to rec.MultimediaLinksCount - 1 do AddRel(rec.MultimediaLinks[i].Value);
    for i := 0 to rec.NotesCount - 1 do AddRel(rec.Notes[i].Value);
    for i := 0 to rec.SourceCitationsCount - 1 do AddRel(rec.SourceCitations[i].Value);
  end;

  procedure CheckTag(tag: TGEDCOMTagWithLists);
  var
    i: Integer;
  begin
    for i := 0 to tag.MultimediaLinksCount - 1 do AddRel(tag.MultimediaLinks[i].Value);
    for i := 0 to tag.NotesCount - 1 do AddRel(tag.Notes[i].Value);
    for i := 0 to tag.SourceCitationsCount - 1 do AddRel(tag.SourceCitations[i].Value);
  end;

  procedure CheckIndividual(iRec: TGEDCOMIndividualRecord);
  var
    i: Integer;
  begin
    CheckRecord(iRec);

    // PersonalNames
    for i := 0 to iRec.ChildToFamilyLinksCount - 1 do AddRel(iRec.ChildToFamilyLinks[i].Family);
    for i := 0 to iRec.SpouseToFamilyLinksCount - 1 do AddRel(iRec.SpouseToFamilyLinks[i].Family);
    for i := 0 to iRec.IndividualEventsCount - 1 do CheckTag(iRec.IndividualEvents[i].Detail);
    for i := 0 to iRec.IndividualOrdinancesCount - 1 do CheckTag(iRec.IndividualOrdinances[i]);
    for i := 0 to iRec.SubmittorsCount - 1 do AddRel(iRec.Submittors[i].Value);
    for i := 0 to iRec.AssociationsCount - 1 do AddRel(iRec.Associations[i].Value);
    for i := 0 to iRec.AliassesCount - 1 do AddRel(iRec.Aliasses[i].Value);
    for i := 0 to iRec.AncestorsInterestCount - 1 do AddRel(iRec.AncestorsInterest[i].Value);
    for i := 0 to iRec.DescendantsInterestCount - 1 do AddRel(iRec.DescendantsInterest[i].Value);
    // UserReferencesCount
    for i := 0 to iRec.GroupsCount - 1 do AddRel(iRec.Groups[i].Value);
  end;

  procedure CheckFamily(fRec: TGEDCOMFamilyRecord);
  var
    i: Integer;
  begin
    CheckRecord(fRec);

    for i := 0 to fRec.FamilyEventCount - 1 do CheckTag(fRec.FamilyEvents[i].Detail);
    AddRel(fRec.Submitter.Value);
    for i := 0 to fRec.SpouseSealingCount - 1 do CheckTag(fRec.SpouseSealing[i]);
  end;

  procedure CheckSource(sRec: TGEDCOMSourceRecord);
  var
    i: Integer;
  begin
    CheckRecord(sRec);

    for i := 0 to sRec.RepositoryCitationsCount - 1 do AddRel(sRec.RepositoryCitations[i].Value);
  end;

var
  i: Integer;
  rec: TGEDCOMRecord;
begin
  i := 0;
  while (i < FSplitList.Count) do begin
    rec := TGEDCOMRecord(FSplitList[i]);

    {fixme}
    case rec.RecordType of
      rtFamily: CheckFamily(rec as TGEDCOMFamilyRecord);
      rtIndividual: CheckIndividual(rec as TGEDCOMIndividualRecord);
      rtMultimedia: CheckRecord(rec);
      rtNote: CheckRecord(rec);
      rtRepository: CheckRecord(rec);
      rtSource: CheckSource(rec as TGEDCOMSourceRecord);
      rtSubmission: ;
      rtSubmitter: CheckRecord(rec);
      rtGroup: {!};
    end;

    Inc(i);
  end;
end;

procedure TfmTreeTools.btnSelectAllClick(Sender: TObject);
begin
  Select(Base.GetSelectedPerson(), twmAll);
end;

procedure TfmTreeTools.btnSelectFamilyClick(Sender: TObject);
begin
  Select(Base.GetSelectedPerson(), twmFamily);
end;

procedure TfmTreeTools.btnSelectAncestorsClick(Sender: TObject);
begin
  Select(Base.GetSelectedPerson(), twmAncestors);
end;

procedure TfmTreeTools.btnSelectDescendantsClick(Sender: TObject);
begin
  Select(Base.GetSelectedPerson(), twmDescendants);
end;

procedure TfmTreeTools.btnDeleteClick(Sender: TObject);
var
  i: Integer;
  obj: TObject;
begin
  for i := 0 to FSplitList.Count - 1 do begin
    obj := TObject(FSplitList[i]);

    if (obj is TGEDCOMIndividualRecord)
    then Base.DeleteIndividualRecord(TGEDCOMIndividualRecord(obj), False);
  end;

  MessageDlg(LSList[LSID_RecsDeleted], mtInformation, [mbOk], 0);

  FSplitList.Clear;
  UpdateSplitLists();

  Base.ListsRefresh();
end;

procedure TfmTreeTools.btnSaveClick(Sender: TObject);
var
  fs: TFileStream;
  subm: string;
  i: Integer;
  rec: TGEDCOMRecord;
begin
  if not(SaveDialog1.Execute) then Exit;

  CheckRelations();

  subm := FTree.Header.GetTagStringValue('SUBM');

  FTree.Header.Clear;
  FTree.Header.Source := AppName;
  FTree.Header.ReceivingSystemName := AppName;
  FTree.Header.CharacterSet := fmGEDKeeper.Options.DefCharacterSet;
  FTree.Header.Language := 'Russian';
  FTree.Header.GEDCOMVersion := '5.5';
  FTree.Header.GEDCOMForm := 'LINEAGE-LINKED';
  FTree.Header.FileName := ExtractFileName(SaveDialog1.FileName);
  FTree.Header.TransmissionDate.Date := Now();

  if (subm <> '')
  then FTree.Header.SetTagStringValue('SUBM', subm);

  fs := TFileStream.Create(SaveDialog1.FileName, fmCreate);
  try
    FTree.SaveHeaderToStream(fs);

    for i := 0 to FTree.RecordsCount - 1 do begin
      rec := TGEDCOMRecord(FTree.Records[i]);

      if (FSplitList.IndexOf(rec) >= 0)
      then rec.SaveToStream(fs);
    end;

    FTree.SaveFooterToStream(fs);

    FTree.Header.CharacterSet := csASCII;
  finally
    fs.Destroy;
  end;
end;

procedure TfmTreeTools.FormShow(Sender: TObject);
begin
  rgOperation.Left := (SheetChoice.Width - rgOperation.Width) div 2;
  rgOperation.Top := (SheetChoice.Height - rgOperation.Height) div 2;
end;

procedure TfmTreeTools.SearchDups();
var
  only_np: Boolean;

  function GetIndivName(iRec: TGEDCOMIndividualRecord; var aName: string): Boolean;
  var
    np: TGEDCOMPersonalName;
    f, n, p: string;
  begin
    if (only_np) then begin
      GetNameParts(iRec, f, n, p);
      aName := n + ' ' + p;
      Result := (Length(aName) > 3);
    end else begin
      np := iRec.PersonalNames[0];
      aName := np.StringValue;
      Result := (Length(np.FirstPart) > 3);
    end;
  end;

  procedure SearchPersonDups();
  begin
  end;

  procedure SearchNoteDups();
  begin
  end;

  procedure SearchFamilyDups();
  begin
  end;

  procedure SearchSourceDups();
  begin
  end;

var
  i, k: Integer;
  iRec, kRec: TGEDCOMRecord;
  iInd, kInd: TGEDCOMIndividualRecord;
  iName, kName: string;
  iNote, kNote: TGEDCOMNoteRecord;
  iFam, kFam: TGEDCOMFamilyRecord;
  iSrc, kSrc: TGEDCOMSourceRecord;
  res: Boolean;
  year1, year2, nameAccuracy, yearInaccuracy: Integer;
  ev: TGEDCOMCustomEvent;
begin
  nameAccuracy := udNameAccuracy.Position;
  yearInaccuracy := udYearInaccuracy.Position;
  only_np := chkOnlyNP.Checked;

  res := False;

  btnSkip.Enabled := False;
  try
    ProgressBar1.Min := 0;
    ProgressBar1.Max := FTree.RecordsCount;
    ProgressBar1.Position := FRMIndex;

    for i := FRMIndex to FTree.RecordsCount - 1 do begin
      FRMIndex := i;
      iRec := FTree.Records[i];

      case FRMMode of
        mmPerson: if (iRec is TGEDCOMIndividualRecord) then begin
          iInd := iRec as TGEDCOMIndividualRecord;
          if not(GetIndivName(iInd, iName)) then Continue;

          for k := i + 1 to FTree.RecordsCount - 1 do begin
            kRec := FTree.Records[k];

            if (kRec is TGEDCOMIndividualRecord) then begin
              kInd := kRec as TGEDCOMIndividualRecord;
              if not(GetIndivName(kInd, kName)) then Continue;

              if (iInd.Sex <> kInd.Sex)
              or (FRMSkip.IndexOf(iInd.XRef + '-' + kInd.XRef) >= 0)
              or (only_np and ((iInd.Sex <> svFemale) or (kInd.Sex <> svFemale)))
              then Continue;

              if (rbDirectMatching.Checked)
              then res := (iName = kName)
              else
              if (rbIndistinctMatching.Checked)
              then res := (IndistinctMatching(4, iName, kName) > nameAccuracy);

              if (res) and (chkBirthYear.Checked) then begin
                ev := GetIndividualEvent(iInd, 'BIRT');
                if (ev = nil)
                then year1 := 0
                else year1 := TGEDCOMDate(ev.Detail.Date.Value).Year;

                ev := GetIndividualEvent(kInd, 'BIRT');
                if (ev = nil)
                then year2 := 0
                else year2 := TGEDCOMDate(ev.Detail.Date.Value).Year;

                res := res and ((year1 >= 0) and (year2 >= 0))
                           and (Abs(year1 - year2) <= yearInaccuracy);
              end;

              if (res) then begin
                SetRec1(iInd);
                SetRec2(kInd);
                Break;
              end;
            end;
          end;
        end;

        mmNote: if (iRec is TGEDCOMNoteRecord) then begin
          iNote := iRec as TGEDCOMNoteRecord;
          iName := iNote.Notes.Text;

          for k := i + 1 to FTree.RecordsCount - 1 do begin
            kRec := FTree.Records[k];

            if (kRec is TGEDCOMNoteRecord) then begin
              kNote := kRec as TGEDCOMNoteRecord;
              kName := kNote.Notes.Text;

              res := (iName = kName)
                and (FRMSkip.IndexOf(iNote.XRef + '-' + kNote.XRef) < 0);

              if (res) then begin
                SetRec1(iNote);
                SetRec2(kNote);
                Break;
              end;
            end;
          end;
        end;

        mmFamily: if (iRec is TGEDCOMFamilyRecord) then begin
          iFam := iRec as TGEDCOMFamilyRecord;
          iName := GetFamilyStr(iFam);

          for k := i + 1 to FTree.RecordsCount - 1 do begin
            kRec := FTree.Records[k];

            if (kRec is TGEDCOMFamilyRecord) then begin
              kFam := kRec as TGEDCOMFamilyRecord;
              kName := GetFamilyStr(kFam);

              res := (iName = kName)
                and (FRMSkip.IndexOf(iFam.XRef + '-' + kFam.XRef) < 0);

              if (res) then begin
                SetRec1(iFam);
                SetRec2(kFam);
                Break;
              end;
            end;
          end;
        end;

        mmSource: if (iRec is TGEDCOMSourceRecord) then begin
          iSrc := iRec as TGEDCOMSourceRecord;
          iName := iSrc.FiledByEntry;

          for k := i + 1 to FTree.RecordsCount - 1 do begin
            kRec := FTree.Records[k];

            if (kRec is TGEDCOMSourceRecord) then begin
              kSrc := kRec as TGEDCOMSourceRecord;
              kName := kSrc.FiledByEntry;

              res := (iName = kName)
                and (FRMSkip.IndexOf(iSrc.XRef + '-' + kSrc.XRef) < 0);

              if (res) then begin
                SetRec1(iSrc);
                SetRec2(kSrc);
                Break;
              end;
            end;
          end;
        end;
      end;

      if (res) then Break;

      ProgressBar1.StepIt();
    end;
  finally
    btnSkip.Enabled := True;
  end;
end;

procedure TfmTreeTools.btnSearchClick(Sender: TObject);
begin
  FRMIndex := 0;
  FRMSkip.Clear;

  SearchDups();
end;

procedure TfmTreeTools.btnSkipClick(Sender: TObject);
begin
  if (FRec1 <> nil) and (FRec2 <> nil)
  then FRMSkip.Add(FRec1.XRef + '-' + FRec2.XRef);

  SearchDups();
end;

procedure TfmTreeTools.SetRec1(const Value: TGEDCOMRecord);
begin
  FRec1 := Value;

  btnMergeToLeft.Enabled := (FRec1 <> nil) and (FRec2 <> nil);
  btnMergeToRight.Enabled := (FRec1 <> nil) and (FRec2 <> nil);

  if (FRec1 = nil) then begin
    Lab1.Caption := 'XXX1';
    Edit1.Text := '';
    Memo1.Lines.Clear;
  end else begin
    Lab1.Caption := FRec1.XRef;

    case FRMMode of
      mmPerson: begin
        Edit1.Text := GetNameStr(TGEDCOMIndividualRecord(FRec1));
        Base.ShowPersonInfo(TGEDCOMIndividualRecord(FRec1), Memo1.Lines);
      end;

      mmNote: begin
        Edit1.Text := TGEDCOMNoteRecord(FRec1).Notes[0];
        Base.ShowNoteInfo(TGEDCOMNoteRecord(FRec1), Memo1.Lines);
      end;

      mmFamily: begin
        Edit1.Text := GetFamilyStr(TGEDCOMFamilyRecord(FRec1));
        Base.ShowFamilyInfo(TGEDCOMFamilyRecord(FRec1), Memo1.Lines);
      end;

      mmSource: begin
        Edit1.Text := TGEDCOMSourceRecord(FRec1).FiledByEntry;
        Base.ShowSourceInfo(TGEDCOMSourceRecord(FRec1), Memo1.Lines);
      end;
    end;
  end;
end;

procedure TfmTreeTools.SetRec2(const Value: TGEDCOMRecord);
begin
  FRec2 := Value;

  btnMergeToLeft.Enabled := (FRec1 <> nil) and (FRec2 <> nil);
  btnMergeToRight.Enabled := (FRec1 <> nil) and (FRec2 <> nil);

  if (FRec2 = nil) then begin
    Lab2.Caption := 'XXX2';
    Edit2.Text := '';
    Memo2.Lines.Clear;
  end else begin
    Lab2.Caption := FRec2.XRef;

    case FRMMode of
      mmPerson: begin
        Edit2.Text := GetNameStr(TGEDCOMIndividualRecord(FRec2));
        Base.ShowPersonInfo(TGEDCOMIndividualRecord(FRec2), Memo2.Lines);
      end;

      mmNote: begin
        Edit2.Text := TGEDCOMNoteRecord(FRec2).Notes[0];
        Base.ShowNoteInfo(TGEDCOMNoteRecord(FRec2), Memo2.Lines);
      end;

      mmFamily: begin
        Edit2.Text := GetFamilyStr(TGEDCOMFamilyRecord(FRec2));
        Base.ShowFamilyInfo(TGEDCOMFamilyRecord(FRec2), Memo2.Lines);
      end;

      mmSource: begin
        Edit2.Text := TGEDCOMSourceRecord(FRec2).FiledByEntry;
        Base.ShowSourceInfo(TGEDCOMSourceRecord(FRec2), Memo2.Lines);
      end;
    end;
  end;
end;

procedure TfmTreeTools.btnRec1SelectClick(Sender: TObject);
var
  irec: TGEDCOMRecord;
  sm: TGEDCOMRecordType;
begin
  case FRMMode of
    mmPerson: sm := rtIndividual;
    mmNote: sm := rtNote;
  end;

  irec := Base.SelectRecord(sm, []);
  if (irec <> nil) then SetRec1(irec);
end;

procedure TfmTreeTools.btnRec2SelectClick(Sender: TObject);
var
  irec: TGEDCOMRecord;
  sm: TGEDCOMRecordType;
begin
  case FRMMode of
    mmPerson: sm := rtIndividual;
    mmNote: sm := rtNote;
  end;

  irec := Base.SelectRecord(sm, []);
  if (irec <> nil) then SetRec2(irec);
end;

procedure TfmTreeTools.RecordMerge(aRecBase, aRecCopy: TGEDCOMRecord);
var
  repMap: TXRefReplaceMap;
  i: Integer;
begin
  repMap := TXRefReplaceMap.Create;
  try
    repMap.AddXRef(aRecCopy, aRecCopy.XRef, aRecBase.XRef);
    for i := 0 to FTree.RecordsCount - 1 do
      FTree.Records[i].ReplaceXRefs(repMap);

    case FRMMode of
      mmPerson: begin
        TGEDCOMIndividualRecord(aRecCopy).MoveTo(aRecBase);
        Base.DeleteIndividualRecord(TGEDCOMIndividualRecord(aRecCopy), False);
      end;

      mmNote: begin
        TGEDCOMNoteRecord(aRecCopy).MoveTo(aRecBase);
        Base.DeleteNoteRecord(TGEDCOMNoteRecord(aRecCopy), False);
      end;

      mmFamily: begin
        TGEDCOMFamilyRecord(aRecCopy).MoveTo(aRecBase);
        Base.DeleteFamilyRecord(TGEDCOMFamilyRecord(aRecCopy), False);
      end;

      mmSource: begin
        TGEDCOMSourceRecord(aRecCopy).MoveTo(aRecBase);
        Base.DeleteSourceRecord(TGEDCOMSourceRecord(aRecCopy), False);
      end;
    end;

    Base.ChangeRecord(aRecBase);
    Base.ListsRefresh();
  finally
    repMap.Free;
  end;
end;

procedure TfmTreeTools.btnMergeToLeftClick(Sender: TObject);
begin
  RecordMerge(FRec1, FRec2);
  SetRec1(FRec1);
  SetRec2(nil);
end;

procedure TfmTreeTools.btnMergeToRightClick(Sender: TObject);
begin
  RecordMerge(FRec2, FRec1);
  SetRec1(nil);
  SetRec2(FRec2);
end;

procedure TfmTreeTools.rgModeClick(Sender: TObject);
begin
  FRMMode := TMergeMode(rgMode.ItemIndex);

  btnRec1Select.Enabled := (FRMMode <> mmFamily);
  btnRec2Select.Enabled := (FRMMode <> mmFamily);
end;

procedure TfmTreeTools.btnImportFileChooseClick(Sender: TObject);
var
  imp: TGKImporter;
begin
  if OpenDialog2.Execute() then begin
    edImportFile.Text := OpenDialog2.FileName;

    imp := TGKImporter.Create(Base.Engine, ListBox1.Items);
    try
      imp.TreeImportEx(edImportFile.Text);
    finally
      imp.Free;
    end;

    ListBox1.ItemIndex := ListBox1.Items.Count - 1;
    Base.ListsRefresh(False);
  end;
end;

procedure TfmTreeTools.CheckGroups();
var
  i, k, group: Integer;
  iRec: TGEDCOMIndividualRecord;
  prepared: TList;
  root: TTreeNode;
  pn: string;
begin
  ProgressInit(FTree.RecordsCount, LSList[LSID_CheckFamiliesConnection]);
  prepared := TList.Create;
  //TreeView1.Items.BeginUpdate();
  try
    group := 0;
    TreeView1.Items.Clear();
    for i := 0 to FTree.RecordsCount - 1 do begin
      if (FTree.Records[i] is TGEDCOMIndividualRecord) then begin
        iRec := FTree.Records[i] as TGEDCOMIndividualRecord;
        if (prepared.IndexOf(iRec) >= 0) then Continue;

        Inc(group);
        FSplitList.Clear();
        TreeWalk(iRec, twmAll, FSplitList);

        root := TreeView1.Items.AddChild(nil, IntToStr(group) + ' '+AnsiLowerCase(LSList[LSID_Group])+' (' + IntToStr(FSplitList.Count) + ')');
        for k := 0 to FSplitList.Count - 1 do begin
          iRec := TObject(FSplitList[k]) as TGEDCOMIndividualRecord;
          prepared.Add(iRec);

          pn := GetNameStr(iRec);
          if (iRec.Patriarch) then pn := '(*) ' + pn;

          TreeView1.Items.AddChildObject(root, pn, iRec);
        end;
        root.Expand(True);
      end;

      ProgressStep();
      Application.ProcessMessages();
    end;
  finally
    FSplitList.Clear();
    //TreeView1.Items.EndUpdate();
    prepared.Free;
    ProgressDone();
  end;
end;

procedure TfmTreeTools.TreeView1DblClick(Sender: TObject);
var
  node: TTreeNode;
  i_rec: TGEDCOMIndividualRecord;
begin
  node := TreeView1.Selected;
  if (node = nil) then Exit;

  i_rec := TGEDCOMIndividualRecord(node.Data);
  if (i_rec = nil) then Exit;

  Base.SelectRecordByXRef(i_rec.XRef);
  Close;
end;

procedure TfmTreeTools.PrepareChecksList();
begin
  Base.CreateListView(Self, Panel1, ListChecks);
  ListChecks.Checkboxes := True;
  ListChecks.OnDblClick := ListChecksDblClick;
  AddListColumn(ListChecks, LSList[LSID_Record], 400);
  AddListColumn(ListChecks, LSList[LSID_Problem], 200);
  AddListColumn(ListChecks, LSList[LSID_Solve], 200);
end;

procedure TfmTreeTools.CheckBase();
var
  i, iAge: Integer;
  iRec: TGEDCOMIndividualRecord;
  item: TListItem;
  dead_event: TGEDCOMCustomEvent;
  age: string;
  checkObj: TCheckObj;
  y_birth, y_death: Integer;
begin
  try
    ProgressInit(FTree.RecordsCount, LSList[LSID_ToolOp_7]);

    FChecksList.Clear;
    for i := 0 to FTree.RecordsCount - 1 do begin
      ProgressStep();

      if (FTree.Records[i] is TGEDCOMIndividualRecord) then begin
        iRec := FTree.Records[i] as TGEDCOMIndividualRecord;

        //
        dead_event := GetIndividualEvent(iRec, 'DEAT');
        if (dead_event = nil) then begin
          age := GetAge(iRec);
          if (age <> '') and (age <> '?') then begin
            iAge := StrToInt(age);
            if (iAge >= 130) then begin
              checkObj := TCheckObj.Create;
              checkObj.Rec := iRec;
              checkObj.Diag := cdPersonLonglived;
              checkObj.Solve := csSetIsDead;
              checkObj.Comment := Format(LSList[LSID_PersonLonglived], [age]);
              FChecksList.Add(checkObj);
            end;
          end;
        end;

        //
        if not(iRec.Sex in [svMale, svFemale]) then begin
          checkObj := TCheckObj.Create;
          checkObj.Rec := iRec;
          checkObj.Diag := cdPersonSexless;
          checkObj.Solve := csDefineSex;
          checkObj.Comment := LSList[LSID_PersonSexless];
          FChecksList.Add(checkObj);
        end;

        //
        y_birth := GetIndependentYear(iRec, 'BIRT');
        y_death := GetIndependentYear(iRec, 'DEAT');
        if (y_birth > -1) and (y_death > -1) and (y_death < y_birth)
        then begin
          checkObj := TCheckObj.Create;
          checkObj.Rec := iRec;
          checkObj.Diag := cdLiveYearsInvalid;
          checkObj.Solve := csSkip;
          checkObj.Comment := LSList[LSID_LiveYearsInvalid];
          FChecksList.Add(checkObj);
        end;

        //
        iAge := GetMarriageAge(iRec);
        if (iAge > 0) and ((iAge <= 13) or (iAge >= 50)) then begin
          checkObj := TCheckObj.Create;
          checkObj.Rec := iRec;
          checkObj.Diag := cdStrangeSpouse;
          checkObj.Solve := csSkip;
          checkObj.Comment := Format(LSList[LSID_StrangeSpouse], [IntToStr(iAge)]);
          FChecksList.Add(checkObj);
        end;

        //
        iAge := GetFirstbornAge(iRec);
        if (iAge > 0) and ((iAge <= 13) or (iAge >= 50)) then begin
          checkObj := TCheckObj.Create;
          checkObj.Rec := iRec;
          checkObj.Diag := cdStrangeParent;
          checkObj.Solve := csSkip;
          checkObj.Comment := Format(LSList[LSID_StrangeParent], [IntToStr(iAge)]);
          FChecksList.Add(checkObj);
        end;
      end;
    end;

    ///

    ListChecks.Items.Clear();
    for i := 0 to FChecksList.Count - 1 do begin
      checkObj := TCheckObj(FChecksList[i]);

      item := ListChecks.Items.Add();
      item.Caption := checkObj.RecName;
      item.SubItems.Add(checkObj.Comment);
      item.Data := checkObj;
    end;
  finally
    ProgressDone();
  end;
end;

procedure TfmTreeTools.btnBaseRepairClick(Sender: TObject);
var
  i: Integer;
  item: TListItem;
  iRec: TGEDCOMIndividualRecord;
  checkObj: TCheckObj;
begin
  try
    for i := 0 to ListChecks.Items.Count - 1 do begin
      item := ListChecks.Items[i];
      checkObj := TCheckObj(item.Data);

      if item.Checked then begin
        case checkObj.Diag of
          cdPersonLonglived: begin
            iRec := TGEDCOMIndividualRecord(checkObj.Rec);
            CreateEventEx(FTree, iRec, 'DEAT', '', '');
            Base.ChangeRecord(iRec);
          end;

          cdPersonSexless: begin
            iRec := TGEDCOMIndividualRecord(checkObj.Rec);
            CheckPersonSex(iRec, fmGEDKeeper.NamesTable);
            Base.ChangeRecord(iRec);
          end;

          cdLiveYearsInvalid: begin
            // dummy
          end;

          cdStrangeSpouse: begin
            // dummy
          end;

          cdStrangeParent: begin
            // dummy
          end;
        end;
      end;
    end;
  finally
    Base.ListsRefresh();
    CheckBase();
  end;
end;

procedure TfmTreeTools.ListChecksDblClick(Sender: TObject);
var
  item: TListItem;
  i_rec: TGEDCOMIndividualRecord;
begin
  item := ListChecks.Selected;
  if (item = nil) then Exit;

  i_rec := TGEDCOMIndividualRecord(TCheckObj(item.Data).FRec);
  if (i_rec = nil) then Exit;

  Base.SelectRecordByXRef(i_rec.XRef);
  Close;
end;

procedure TfmTreeTools.btnPatSearchClick(Sender: TObject);
var
  lst: TObjectList;

  function GetLinks(pObj: TPatriarchObj): string;
  var
    i: Integer;
  begin
    Result := '';

    for i := 0 to lst.Count - 1 do begin
      if (i in pObj.ILinks) then begin
        if (Result <> '') then Result := Result + ', ';
        Result := Result + GetNameStr(TPatriarchObj(lst[i]).IRec);
      end;
    end;
  end;

var
  i: Integer;
  p_obj: TPatriarchObj;
  item: TListItem;
  p_sign: string;
begin
  ListPatriarchs.Items.BeginUpdate();
  lst := TObjectList.Create(True);
  try
    ListPatriarchs.Clear();
    Base.Engine.GetPatriarchsList(True, False, lst, udMinGens.Position);

    for i := 0 to lst.Count - 1 do begin
      p_obj := TPatriarchObj(lst[i]);

      if not(p_obj.IRec.Patriarch) then p_sign := '' else p_sign := '[*] ';

      item := ListPatriarchs.Items.Add();
      item.Caption := p_sign + GetNameStr(p_obj.IRec);
      item.SubItems.Add(IntToStr(p_obj.IBirthYear));
      item.SubItems.Add(IntToStr(p_obj.IDescendantsCount));
      item.SubItems.Add(IntToStr(p_obj.IDescGenerations));
      item.Data := p_obj.IRec;
      //item.SubItems.Add(GetLinks(p_obj));
    end;
  finally
    lst.Free;
    ListPatriarchs.Items.EndUpdate();
  end;
end;

procedure TfmTreeTools.ListPatriarchsDblClick(Sender: TObject);
var
  item: TListItem;
  i_rec: TGEDCOMIndividualRecord;
begin
  item := ListPatriarchs.Selected;
  if (item = nil) then Exit;

  i_rec := TGEDCOMIndividualRecord(item.Data);
  if (i_rec = nil) then Exit;

  Base.SelectRecordByXRef(i_rec.XRef);
  Close;
end;

procedure TfmTreeTools.btnSetPatriarchClick(Sender: TObject);
var
  item: TListItem;
  i_rec: TGEDCOMIndividualRecord;
begin
  try
    item := ListPatriarchs.Selected;
    if (item = nil) then Exit;

    i_rec := TGEDCOMIndividualRecord(item.Data);
    if (i_rec = nil) then Exit;

    i_rec.Patriarch := True;
  finally
    btnPatSearchClick(nil);
    Base.ListsRefresh();
  end;
end;

procedure TfmTreeTools.PreparePatriarchsList();
begin
  Base.CreateListView(Self, Panel3, ListPatriarchs);
  //ListPatriarchs.Checkboxes := True;
  ListPatriarchs.OnDblClick := ListPatriarchsDblClick;
  AddListColumn(ListPatriarchs, LSList[LSID_Patriarch], 400);
  AddListColumn(ListPatriarchs, LSList[LSID_Birth], 90);
  AddListColumn(ListPatriarchs, LSList[LSID_Descendants], 90);
  AddListColumn(ListPatriarchs, LSList[LSID_Generations], 90);
end;

function TfmTreeTools.GetBase: TfmBase;
begin
  Result := TfmBase(Owner);
end;

procedure TfmTreeTools.btnUpdateSelectClick(Sender: TObject);
begin
  if OpenDialog1.Execute() then begin
    edUpdateBase.Text := OpenDialog1.FileName;

    case rgTreeMergeType.ItemIndex of
      0: begin
        TreeMerge(Base.Tree, edUpdateBase.Text, mSyncRes.Lines);
      end;

      1: begin
        TreeSync(Base.Tree, edUpdateBase.Text, mSyncRes.Lines);
      end;
    end;

    Base.ListsRefresh();
  end;
end;

procedure TfmTreeTools.rgTreeMergeTypeClick(Sender: TObject);
begin
  gbSyncType.Enabled := (rgTreeMergeType.ItemIndex = 1);
end;

procedure TfmTreeTools.PreparePlacesList();
begin
  Base.CreateListView(Self, Panel4, ListPlaces);
  //ListPlaces.Checkboxes := True;
  ListPlaces.OnDblClick := ListPlacesDblClick;
  AddListColumn(ListPlaces, LSList[LSID_Place], 400);
  AddListColumn(ListPlaces, LSList[LSID_LinksCount], 100);
end;

type
  TPlaceObj = class(TObject)
  public
    Name: string;
    Facts: TList;

    constructor Create;
    destructor Destroy; override;
  end;

{ TPlaceObj }

constructor TPlaceObj.Create;
begin
  inherited Create;
  Facts := TList.Create;
end;

destructor TPlaceObj.Destroy;
begin
  Facts.Free;
  inherited Destroy;
end;

procedure TfmTreeTools.PlacesClear();
var
  i: Integer;
begin
  for i := FPlaces.Count - 1 downto 0 do
    FPlaces.Objects[i].Free;

  FPlaces.Clear;
end;

procedure TfmTreeTools.PlacesCheck();

  procedure PrepareEvent(aEvent: TGEDCOMCustomEvent);
  var
    place_obj: TPlaceObj;
    place_str: string;
    loc: TGEDCOMLocationRecord;
    idx: Integer;
  begin
    place_str := aEvent.Detail.Place.StringValue;
    if (place_str = '') then Exit;    

    loc := TGEDCOMLocationRecord(aEvent.Detail.Place.Location.Value);
    if (loc <> nil) then place_str := '[*] ' + place_str;

    idx := FPlaces.IndexOf(place_str);
    if (idx >= 0) then begin
      place_obj := TPlaceObj(FPlaces.Objects[idx]);
    end else begin
      place_obj := TPlaceObj.Create;
      place_obj.Name := place_str;
      FPlaces.AddObject(place_str, place_obj);
    end;

    place_obj.Facts.Add(aEvent);
  end;

var
  i, k: Integer;
  iRec: TGEDCOMIndividualRecord;
  fRec: TGEDCOMFamilyRecord;
  item: TListItem;
  place_obj: TPlaceObj;
begin
  ProgressInit(FTree.RecordsCount, LSList[LSID_PlacesPrepare]);
  ListPlaces.Items.BeginUpdate();
  try
    PlacesClear();

    for i := 0 to FTree.RecordsCount - 1 do begin
      ProgressStep();

      if (FTree.Records[i] is TGEDCOMIndividualRecord) then begin
        iRec := FTree.Records[i] as TGEDCOMIndividualRecord;
        for k := 0 to iRec.IndividualEventsCount - 1 do PrepareEvent(iRec.IndividualEvents[k]);
      end
      else
      if (FTree.Records[i] is TGEDCOMFamilyRecord) then begin
        fRec := FTree.Records[i] as TGEDCOMFamilyRecord;
        for k := 0 to fRec.FamilyEventCount - 1 do PrepareEvent(fRec.FamilyEvents[k]);
      end;
    end;

    ListPlaces.Items.Clear();
    for i := 0 to FPlaces.Count - 1 do begin
      place_obj := TPlaceObj(FPlaces.Objects[i]);

      item := ListPlaces.Items.Add();
      item.Caption := FPlaces[i];
      item.SubItems.Add(IntToStr(place_obj.Facts.Count));
      item.Data := place_obj;
    end;
  finally
    ListPlaces.Items.EndUpdate();
    ProgressDone();
  end;
end;

procedure TfmTreeTools.ListPlacesDblClick(Sender: TObject);
var
  item: TListItem;
  p_obj: TPlaceObj;
  loc: TGEDCOMLocationRecord;
  i: Integer;
  event: TGEDCOMCustomEvent;
begin
  item := ListPlaces.Selected;
  if (item = nil) then Exit;

  p_obj := TPlaceObj(item.Data);
  if (p_obj = nil) then Exit;

  if (Pos('[*]', p_obj.Name) = 1) then begin
    MessageDlg(LSList[LSID_PlaceAlreadyInBook], mtWarning, [mbOk], 0);
    Exit;
  end;

  loc := TGEDCOMLocationRecord(Base.SelectRecord(rtLocation, [p_obj.Name]));
  if (loc <> nil) then begin
    for i := 0 to p_obj.Facts.Count - 1 do begin
      event := TGEDCOMCustomEvent(p_obj.Facts[i]);
      event.Detail.Place.StringValue := loc.Name;
      event.Detail.Place.Location.Value := loc;
    end;
    ///
    PlacesCheck();
    Base.ListsRefresh(False);
  end;
end;

procedure TfmTreeTools.btnIntoListClick(Sender: TObject);
begin
  ListPlacesDblClick(nil);
end;

procedure TfmTreeTools.btnHelpClick(Sender: TObject);
begin
  fmGEDKeeper.ShowHelpTopic(HelpTopics[rgOperation.ItemIndex]);
end;

end.
