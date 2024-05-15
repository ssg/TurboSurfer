{
TurboSurfer Setup Unit

updates:
--------
11th Sep 95 - 10:42 - added setup pointer... (not a serious update:))
16th Oct 95 - 22:23 - changed default colors... (better)
}

unit TSetup;

interface

uses Dialogs,Views,TRes,TVX,Objects;

type

  {- setup record -}
  PSetupRec = ^TSetupRec;
  TSetupRec = record
    userid      : string[8];         { userid as you know }
    password    : string[8];         { entrance password }
    userName    : FnameStr;          { long name of da user }
    dirDL       : FnameStr;          { download dir }
    dirUL       : FnameStr;          { upload dir }
    cmdEditor   : FnameStr;          { editor command }
    cmdFilter   : FnameStr;          { external filter command }
    fnTagline   : FnameStr;          { taglines file }
    fnHeader    : FnameStr;          { header file }
    fnFooter    : FnameStr;          { footer file }
    fnLanguage  : FnameStr;          { language file }
    QuoteStr    : string;            { quote string }
    msgStyle    : byte;              { message style }
    msgSort     : byte;              { sort type }
    tagMode     : byte;              { tagline mode }
    prnPort     : byte;              { printer port }
    videoMode   : byte;              { video mode }

    cNormal     : byte;              { -- colors begin -- }
    cBack       : byte;              {        .         }
    cTagline    : byte;              {        .         }
    cOrigin     : byte;              {        .         }
    cQuote      : byte;              {        .         }
    cOther      : byte;              {        .         }
    cTearline   : byte;              { -- colors end -- }

    Flags       : longint;           { general flags }
    padding     : array[1..1038] of byte; {padded to 2048}
  end;

const

  {- sort flags -}
  sortNone  = 0;    { do not sort }
  sortFrom  = 1;    { sort by sender's name }
  sortTo    = 2;    { sort by receiver's name }
  sortSubj  = 3;    { sort by subject }

  {- screen modes -}
  vm80x25     = 0;  { classic mode }
  vm80x50     = 1;  { non-classic mode }

  {- general flags -}
  gfQuote     = 1;  { Quote replied mail }
  gfHeader    = 2;  { Put header in reply file }
  gfFooter    = 4;  { Put footer in reply file}
  gfPrefix    = 8;  { Prefix replies with "re:" }
  gfWrapText  = 16; { Wrap the text when reading mails }
  gfBBSLogo   = 32; { Put BBS logo in back auto }

  {- tagline flags -}
  tagNone     = 0;  { No taglines in mails }
  tagAuto     = 1;  { Auto-selection of taglines }
  tagPrompt   = 2;  { Prompt da tagline to be added }

  {- message styles -}
  msNone      = 0;  { No filtering of message }
  msNormal    = 1;  { Make text standard }
  msLower     = 2;  { Lower everything }
  msCyberpunk = 3;  { Crazyyy }
  msExternal  = 4;  { Use external filter }

  defaultSetup  : TSetupRec = (
    userid      : '';
    passWord    : '';
    userName    : '';
    dirDL       : '';
    dirUL       : '';
    cmdEditor   : 'EDIT @F';
    cmdFilter   : '';
    fnTagline   : 'TSURFER.TAG';
    fnHeader    : '';
    fnFooter    : '';
    fnLanguage  : '';
    QuoteStr    : '';
    msgStyle    : msNone;
    msgSort     : sortNone;
    tagMode     : tagAuto;
    prnPort     : 1;
    videoMode   : vm80x25;
    cNormal     : White;
    cBack       : Blue;
    cTagline    : LightCyan;
    cOrigin     : LightGreen;
    cQuote      : LightGray;
    cOther      : Brown;
    cTearline   : LightMagenta;
    Flags       : gfQuote+gfBBSLogo+gfPrefix+gfWrapText
  );

var

  setup:TSetupRec;

type

  PSetupDialog = ^TSetupDialog;
  TSetupDialog = object(TXDialog)
    constructor Init;
  end;

  PDirSetupDialog = ^TDirSetupDialog;
  TDirSetupDialog = object(TXDialog)
    constructor Init;
  end;

  PMainSetupDialog = ^TMainSetupDialog;
  TMainSetupDialog = object(TXDialog)
    constructor Init;
{    procedure   GetData(var rec);virtual;
    procedure   SetData(var rec);virtual;}
  end;

implementation

{ --- TMainSetupDialog --- }
constructor TMainSetupDialog.Init;
var
  R:TRect;
  procedure putIt(labelle:FnameStr; cl:PCluster);
  var
    R1:TRect;
  begin
    R1 := R;
    R1.B.Y := R1.A.Y + 1;
    Insert(New(PLabel,Init(R1,labelle,NIL)));
    inc(cl^.Origin.Y);
    Insert(cl);
  end;
begin
  R.Assign(0,0,80,24);
  inherited Init(R,gtid(1700));
  Options := Options or ofCentered;
  GetExtent(R);
  R.Grow(-2,-2);
  R.B.X := R.A.X + 20;
  R.B.Y := R.A.Y + 2;
  putIt(gtid(1701),New(PRadioButtons,Init(R,
    NewSItem(gtid(1702),
    NewSItem(gtid(1703),
    NIL)))));
end;

{ -= TSetupDialog =- }
constructor TSetupDialog.Init;
var
  R:TRect;
  procedure putbut(amsg:fnameStr; acmd:word);
  var
    px:PXButton;
  begin
    px := New(PXButton,Init(r.a.x,r.a.y,amsg,acmd));
    Insert(px);
    px^.GetBounds(r);
    r.a.x := r.b.x+1;
  end;
begin
  R.Assign(0,0,40,10);
  inherited Init(R,gtid(105));
  Options := Options or ofCentered;
  R.Assign(0,0,24,1);
  R.Move(2,2);
  Insert(New(PXInputLine,Init(R,gtid(106),8,ifUpper+if7bit)));
  R.Move(0,2);
  Insert(New(PXInputLine,Init(R,gtid(107),8,ifUpper+if7bit+ifHidden)));
  R.Move(0,2);
  R.B.X := R.A.X+33;
  Insert(New(PXInputLine,Init(R,gtid(108),18,if7bit)));
  R.Move(0,2);
  putbut(gtid(115),cmOk);
  putbut(gtid(116),cmYes);
  putbut(mmCancel,cmCancel);
  SelectNext(False);
end;

{ -= TDirSetupDialog =- }
constructor TDirSetupDialog.Init;
var
  R:TRect;
  w:word;
  procedure PutDirInput;
  begin
    Insert(New(PXInputLine,Init(R,gtid(w),79,ifUpper+if7bit)));
    R.Move(0,2);
  end;
  procedure putbut(amsg:fnameStr; acmd:word);
  var
    px:PXButton;
  begin
    New(Px,Init(r.a.x,r.a.y,amsg,acmd));
    Px^.GetBounds(R);
    r.a.x := r.b.x+1;
    Insert(Px);
  end;
begin
  R.Assign(0,0,50,22);
  inherited Init(R,gtid(117));
  Options := Options or ofCentered;
  R.Assign(0,0,46,1);
  R.Move(2,2);
  for w := 118 to 124 do putDirInput;
  putbut(gtid(115),cmOk); {kaydet}
  putbut(mmCancel,cmCancel);
  SelectNext(False);
end;

end.