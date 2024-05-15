{
All the packet routines - All the kings horses

updates:
--------
11th Sep 95 - 13:11 - agh.. slowest coding speed in the world!
12th Sep 95 - 22:17 - i'm in the worst stiuation... damn..
15th Sep 95 - 09:56 - this must be finished!! this have to be!!
15th Sep 95 - 10:07 - yes..
15th Sep 95 - 10:52 - corrected some routines... (about area reads of coz)
17th Sep 95 - 10:15 - fixed some bugs...

bugs:
----
 þ Mails longer than 64k will corrupt everything
 þ Wrapping not supported (yet)

notes:
------
uudecode & encoding mechanism:

first char is number of bytes to out...

read next 4 chars into array a...

output array of three bytes should be prepared this way:

 o[1] := (a[1] shl 2)+(a[2] shr 4);
 o[2] := (a[2] shl 4)+(a[3] shr 2);
 o[3] := (a[3] shl 6)+a[4];
}

unit TPacket;

interface

uses

XIO,Dos,App,TTypes,TArch,Dialogs,Views,TRes,TBlue,Debris,XStr,Drivers,TVX,
Strings,XStream,TExec,TSign,XBuf,Tuser,TSetup,Objects;

type

  PPacketRec = ^TPacketRec;
  TPacketRec = record
    Filename : string[12];
    Packetid : string[8];
    Tagged   : boolean;
    Size     : longint;
    Date     : longint;
    Total    : word;
    Pers     : word;
    Unread   : word;
    Marked   : word;
  end;

  PPacketCache = ^TPacketCache;
  TPacketCache = record
    Filename   : string[12];
    Total      : word;
    Pers       : word;
    Unread     : word;
    Marked     : word;
    Padding    : array[1..15] of byte;
  end;

  PAreaRec = ^TAreaRec;
  TAreaRec = record
    Name     : PString;
    AreaNum  : word;
    Total    : word;
    Pers     : word;
    Unread   : word;
    Flags    : word;
    Offset   : longint;
  end;

  PPacketColl = ^TPacketColl;
  TPacketColl = object(TSortedCollection)
    procedure FreeItem(item:pointer);virtual;
    function  Compare(k1,k2:pointer):integer;virtual;
  end;

  PPacketLister = ^TPacketLister;
  TPacketLister = object(TXTagLister)
    function    GetText(item:integer; maxlen:integer):string;virtual;
{    function    GetColor(item:integer):byte;virtual;
    procedure   HandleEvent(var Event:TEvent);virtual;}
    function    IsTagged(item:integer):boolean;virtual;
    procedure   SetTag(item:integer; enable:boolean);virtual;
  end;

  PPacketDialog = ^TPacketDialog;
  TPacketDialog = object(TXDialog)
    Lister      : PPacketLister;
    constructor Init(alist:PPacketColl);
    procedure   HandleEvent(var Event:TEvent);virtual;
    procedure   OpenPacket;
  end;

  PMail = ^TMail;
  TMail = record
{    Owner    : word; } {why?}
    Flags    : word;
    mFrom    : string[35];
    mTo      : string[35];
    Subject  : string[71];
    Date     : string[19];
    MsgNum   : word;
    Where    : longint;
    Length   : longint;
    Link     : PString;
    Zone     : word;
    Net      : word;
    Node     : word;
    Point    : word;
    xtFlags  : word;
    xtMarks  : word;
  end;

  PAreaColl = ^TAreaColl;
  TAreaColl = object(TSortedCollection)
    procedure FreeItem(item:pointer);virtual;
    function  Compare(k1,k2:pointer):integer;virtual;
  end;

  PAreaLister = ^TAreaLister;
  TAreaLister = object(TXListViewer)
    function    GetText(item:integer; maxlen:integer):string;virtual;
    function    GetColor(item:integer):byte;virtual;
  end;

  PMailColl = ^TMailColl;
  TMailColl = object(TSortedCollection)
    procedure FreeItem(item:pointer);virtual;
    function  Compare(k1,k2:pointer):integer;virtual;
  end;

  PMailPacket = ^TMailPacket;
  TMailPacket = object(TObject)  {<----- base packet object }
    PacketFile  : PString;
    Packetid    : PString;
    Archiver    : PArchInfo;
    OK          : boolean;
    Batman      : boolean; {indicates if the packet has been unpacked}
    constructor Init(apacketfile:FnameStr);
    destructor  Done;virtual;
    function    Classified:boolean;virtual;
    function    Open:boolean;virtual;
    function    Close:boolean;virtual;
    function    Create:boolean;virtual;
    function    ReadAreaList:PAreaColl;virtual;
    function    Check:boolean;virtual;
    function    GetMails(Area:PAreaRec):PMailColl;virtual;
    function    Recover:boolean;virtual;
    function    WhereAmI:FnameStr;virtual;
    function    GetDataStream(amail:PMail):PDosStream;virtual;
    procedure   Run;virtual;
    procedure   UpdatePacketInfo;virtual;
  end;

  PReplyPacket = ^TReplyPacket;
  TReplyPacket = object(TMailPacket)
    constructor Init(apacketfile:FnameStr);
    destructor  Done;virtual;
    function    Classified:boolean;virtual;
    function    Create:boolean;virtual;
    function    ReadAreaList:PAreaColl;virtual;
    function    WhereAmI:FnameStr;virtual;
    function    GetMails(Area:PAreaRec):PMailColl;virtual;
    function    Close:boolean;virtual;
    function    Check:boolean;virtual;
    function    GetDataStream(amail:PMail):PDosStream;virtual;
  end;

  PAreaDialog = ^TAreaDialog;
  TAreaDialog = object(TXDialog)
    Lister    : PAreaLister;
    MasteR    : PMailPacket;
    AreaList  : PAreaColl;
    constructor Init(aMasteR:PMailPacket);
    procedure   HandleEvent(var Event:TEvent);virtual;
    procedure   ObtainAreaList;
  end;

  PMailLister = ^TMailLister;
  TMailLister = object(TXTagLister)
    function  GetText(item:integer; maxlen:integer):string;virtual;
    function  GetColor(item:integer):byte;virtual;
  end;

  PMailListDialog = ^TMailListDialog;
  TMailListDialog = object(TXDialog)
    Lister   : PMailLister;
    Area     : PAreaRec;
    MasteR   : PMailPacket;
    MailList : PMailColl;
    constructor Init(a_acayipsin:PAreaRec; var amaster:PMailPacket);
    procedure   HandleEvent(var Event:TEvent);virtual;
    procedure   ObtainMailList;
  end;

  PMailViewer = ^TMailViewer;
  TMailViewer = object(TView)
    Mail      : PMail;
    BufSize   : word;
    Buffer    : Pointer;
    Start     : word;
    Stream    : PStream;
    constructor Init(var abounds:TRect; amail:PMail; astream:PStream);
    destructor  Done;virtual;
    procedure   Draw;virtual;
    procedure   HandleEvent(var Event:Tevent);virtual;
  end;

  PMailReader = ^TMailReader;
{  PMailInfo = ^TMailInfo;
  TMailInfo = object(TDumbView)
    constructor Init(var abounds:TRect; aparent:PMailReader);
    procedure   Update;
    procedure   Draw;virtual;
  end;}

  TMailReader = object(TXDialog)
    Master    : PMailPacket;
    Area      : PAreaRec;
    Mail      : PMail;
    Viewer    : PMailViewer;
    Stream    : PStream;
    Rep        : PReplyPacket;
{    Info      : PMailInfo;}
    constructor Init(amaster:PMailPacket; aarea:PAreaRec; amail:PMail; astream:PStream);
    procedure   HandleEvent(var Event:TEvent);virtual;
  end;

{"Stick It Out" - rush - kicks ass man}

procedure GetExtraPacketInfo(var rec:TPacketRec);

implementation

{--------------------- TMAILVIEWER -------------------}
constructor TMailViewer.Init;
begin
  inherited Init(abounds);
  Mail     := AMail;
  Stream   := AStream;
  Options  := Options or ofPreProcess;
  GrowMode := gfGrowHix+gfGrowHiY;
  BufSize  := 65000;
  if Mail^.Length > BufSize then Panic('It''s too big. Really big');
  if BufSize > Mail^.Length then BufSize := Mail^.Length-1;
  if BufSize > MaxAvail then Panic('Cannot allocate buffer for mail');
  GetMem(Buffer,BufSize);
  Start := 0;
  Stream^.Seek(Mail^.Where+1);
  Stream^.Read(Buffer^,BufSize);
  if Stream^.Status <> stOK then Panic('stream error');
end;

destructor TMailViewer.Done;
begin
  FreeMem(Buffer,BufSize);
  inherited Done;
end;

procedure TMailViewer.Draw;
var
  T:TDrawBuffer;
  y:integer;
  P:PChar;
  s:string;
  counter:word;
  color:byte;
  b:byte;
begin
  P := Buffer;
  inc(word(P),Start);
  counter := word(P)-word(Buffer);
  if counter <> start then
    Panic('Damn. Look at this shit: real_dif = '+word2Str(counter,0)+' start = '+word2Str(start,0));
  counter := start;
  for y:=0 to Size.Y-1 do begin
    MoveChar(T,#32,(setup.cBack shl 4) or setup.cNormal,Size.X);
    s := '';
    if counter < bufsize-1 then begin
      while (P^ <> #13) and (counter < bufsize-1) do begin
        if (P^ > #31) and (length(s) < Size.X) then begin
          inc(byte(s[0]));
          s[length(s)] := P^;
        end;
        inc(word(P));
        inc(counter);
      end;
      if P^ = #13 then begin
        inc(word(P));
        inc(counter);
      end;
    end;
    if s <> '' then begin
      b := pos('>',s);
      with setup do
      if pos('... ',s) = 1 then color := cTagline else
      if pos('--- ',s) = 1 then color := cTearline else
      if (b > 0) and (b < 6) then color := cQuote else
      if pos(' * ',s) = 1 then color := cOrigin else
      if pos('@',s) = 1 then color := cOther else color := cNormal;
      color := color or (setup.cBack shl 4);
      MoveStr(T,s,color);
    end;
    WriteBuf(0,y,Size.X,1,T);
  end;
end;

procedure TMailViewer.HandleEvent;
  procedure GoHome;
  begin
    if Start = 0 then exit;
    Start := 0;
    DrawView;
  end;

  procedure GoEnd;
  var
    P:PChar;
    YourLoveIsBadForMe:word;
    procedure incit;
    begin
      inc(word(P));
      inc(start);
    end;
  begin
    P := Buffer;
    Start := BufSize-1;
    inc(word(P),Start);
    YourLoveIsBadForMe := 1;
    while (Start > 0) and (YourLoveIsBadForMe <= Size.Y) do begin
      dec(word(P));
      dec(start);
      if P^ = #13 then inc(YourLoveIsBadForMe);
    end;
    if P^ = #13 then incit;
    DrawView;
  end;

  procedure GoUp;
  var
    P:PChar;
    procedure incit;
    begin
      inc(word(P));
      inc(start);
    end;
  begin
    if Start = 0 then exit;
    P := Buffer;
    dec(start,2);
    inc(word(P),start);
    while (start > 0) and (P^ <> #13) do begin
      dec(word(P));
      dec(start);
    end;
    if P^ = #13 then incit;
    DrawView;
  end;

  procedure GoDown;
  var
    P:PChar;
    startMeUp:word;
    procedure incit;
    begin
      inc(word(P));
      inc(startMeUp);
    end;
  begin
    startMeUp := Start;
    P         := Buffer;
    inc(word(P),startMeUp);
    while (P^ <> #13) and (startMeUp < BufSize-1) do begin
      inc(word(P));
      inc(startMeUp);
    end;
    if P^ = #13 then incit;
    if GetByteCount(P^,BufSize-Start,13) < Size.Y then exit;
    Start := startMeUp;
    DrawView;
  end;

  procedure PageUp;
  var
    P:PChar;
    lines:word;
    procedure incit;
    begin
      inc(word(P));
      inc(start);
    end;
  begin
    if Start = 0 then exit;
    P := Buffer;
    inc(word(P),start);
    lines := 0;
    while (start > 0) and (lines <= Size.Y) do begin
      dec(word(P));
      dec(start);
      if P^ = #13 then inc(lines);
    end;
    if P^ = #13 then incit;
    DrawView;
  end;

  procedure PageDown;
  var
    P:PChar;
    lines:word;
    oss:word;
    procedure incit;
    begin
      inc(word(P));
      inc(start);
    end;
  begin
    P := Buffer;
    oss:= Start;
    inc(word(P),oss);
    lines := 0;
    while (oss < BufSize-1) and (lines < Size.Y) do begin
      if P^ = #13 then inc(lines);
      inc(word(P));
      inc(oss);
    end;
    if lines < Size.Y then exit;
    if GetByteCount(P^,BufSize-oss,13) < Size.Y then begin
      GoEnd;
      exit;
    end;
    Start := oss;
    if P^ = #13 then incit;
    DrawView;
  end;

begin
  inherited HandleEvent(Event);
  case Event.What of
    evKeyDown : case Event.KeyCode of
                  kbUp : GoUp;
                  kbDown : GoDown;
                  kbPgUp : PageUp;
                  kbPgDn : PageDown;
                  kbHome : GoHome;
                  kbEnd  : GoEnd;
                  else exit;
                end; {Case}
    else exit;
  end; {case}
  ClearEvent(Event);
end;

{ ToolBar: Cevapla, Arsivle, Kaydet, Yazdir,
           Kopyala, Sonraki, Onceki, Geri don

}

{--------------------- TMAILREADER -----------------------}
constructor TMailReader.Init;
var
  R:TRect;
  procedure InitUpperRegions;
  begin
    GetExtent(R);
    R.Grow(-2,-1);
    R.B.Y := R.A.Y + 2;
    R.B.X := R.A.X + 46;

  end;

begin
  Application^.GetExtent(R);
  dec(r.b.y);
  inherited Init(R,AArea^.Name^);
  Master := AMaster;
  Area   := AArea;
  Mail   := AMail;
  Stream := AStream;
  GetExtent(R);
  R.Grow(-2,-1);
  inc(r.a.y,5);
  New(Viewer,Init(R,Mail,Stream));
  Insert(Viewer);
  InitUpperRegions;
end;

procedure TMailReader.HandleEvent;

  procedure NextMsg;
  begin
  end;

  procedure PrevMsg;
  begin
  end;

  procedure ReplyMsg;
  begin
    if TypeOf(Self) <> TypeOf(TReplyPacket) then begin
      if Rep = NIL then New(Rep,Init(setup.dirUL));
    end;
  end;

begin
  if Event.What = evKeyDown then case Event.KeyCode of
    kbLeft  : PrevMsg;
    kbRight : NextMsg;
  end; {Case}
  if Event.What <> evNothing then inherited HandleEvent(Event);
  case Event.What of
    evKeyDown : case upcase(Event.CharCode) of
                  #0  : {case Event.KeyCode of
                        end}; {case}
                  'R' : ReplyMsg;
                  else exit;
                end; {case}
    else exit;
  end; {case}
  ClearEvent(Event);
end;

{---------------------  TMaiLLiSTeR     ---------------------}
function TMaiLLIstER.GetText(item:integer; maxlen:integer):string;
var
  Pm:PMail;
begin
  Pm := List^.At(item);
  with Pm^ do GetText := Fix(mFrom,22)+Fix(mTo,22)+Fix(Subject,32);
end;

function TMailLister.GetColor(item:integer):byte;
var
  Pm:PMail;
  color:byte;
begin
  Pm := List^.At(item);
  color := 0;
  if Pm^.xtFlags and xtfHasRead > 0 then color := 8 else begin
    if Pm^.xtFlags and xtfIsPersonal > 0 then color := 2;
    if Pm^.xtFlags and xtfHasReplied > 0 then inc(color);
  end;
  GetColor := (inherited GetColor(item) and $f0) or color;
end;

{---------------------   TMAILLISTDIALOG  --------------------}
constructor TMailListDialog.Init;
var
  R:TRect;
  procedure putbut(aid:longint; acmd:word);
  var
    Px:PXButton;
  begin
    New(Px,Init(R.a.x,r.a.y,gtid(aid),acmd));
    Insert(Px);
    Px^.GetBounds(R);
    R.A.X := R.B.X+1;
  end;
begin
  Application^.GetExtent(R);
  dec(r.b.y);
  inherited Init(R,gtid(1500)+' ('+a_acayipsin^.Name^+')');
  R.Grow(-2,-2);
  R.B.Y := R.A.Y+1;
  Insert(New(PLabel,Init(R,Fix(gtid(1501),22)+
                           Fix(gtid(1502),22)+
                           gtid(1503),NIL)));
  GetExtent(R);
  R.Grow(-2,-4);
  inc(r.b.y);
  Area   := a_acayipsin;
  MasteR := amaster;
  ObtainMailList;
  if MailList = NIL then Panic('Mail list? NIL? why me? :~(');
  New(Lister,Init(R,NIL));
  Lister^.NewList(MailList);
  Insert(Lister);
  R.A.Y := R.B.Y+1;
  R.B.Y := R.A.Y+1;
  putbut(1504,cmOpen);
  putbut(1505,cmArchive);
  putbut(1506,cmSave);
  putbut(1507,cmPrint);
  putbut(1508,cmClose);
  SelectNext(False);
end;

procedure TMailListDialog.HandleEvent;
  procedure ReadMail;
  var
    P:PMailReader;
    Patriarch: PMail;
    code:word;
    dataStream:PDosStream;
    WanagiWachipi:TMail;
    WhereWasI:integer;
  begin
    if Lister^.Range = 0 then exit;
    WhereWasI := Lister^.Focused;
    Patriarch := Lister^.List^.At(Lister^.Focused);
    if Patriarch = NIL then Panic('Andoni the Minder Amiri is NIL');
    dataStream := Master^.GetDataStream(Patriarch);
    WanagiWachipi := Patriarch^;
    New(P,Init(MasteR, area, @WanagiWachipi, dataStream));
    Application^.Insert(P);
    Lister^.List := NIL;
    Dispose(MailList,Done);
    MailList := NIL;
    Hide;
    code := Application^.ExecView(P);
    Show;
    Dispose(dataStream,Done);
    Dispose(P,Done);
    ObtainMailList;
    Lock;
    Lister^.NewList(MailList);
    Lister^.FocusItem(WhereWasI);
    Lister^.DrawView;
    UnLock;
  end;
begin
  if (Event.What <> evKeyDown) or (Event.KeyCode <> kbEnter) then inherited HandleEvent(Event);
  case Event.What of
    evCommand : case Event.Command of
                  cmOpen : ReadMail;
                  else exit;
                end; {case}
    evKeyDown : case Event.KeyCode of
                  kbEnter : ReadMail;
                  kbLeft  : EndModal(cmClose);
                  else exit;
                end; {case}
    evBroadcast : if Event.Command = cmListItemSelected then ReadMail else exit;
    else exit;
  end; {case}
  ClearEvent(Event);
end;

procedure TMailListDialog.ObtainMailList;
begin
  if MailList <> NIL then Dispose(MailList,Done);
  MailList := Master^.GetMails(Area);
end;

{--------------------   TAREADIALOG        -----------------}
constructor TAreaDialog.Init;
var
  R:TRect;
  procedure putbut(aid:longint; acmd:word);
  var
    P:PXButton;
  begin
    New(P,Init(r.a.x,r.a.y,gtid(aid),acmd));
    P^.Options := P^.Options and not ofSelectable;
    Insert(P);
    P^.GetBounds(R);
    r.a.x := r.b.x+1;
  end;
begin
  Application^.GetExtent(R);
  dec(r.b.y);
  inherited Init(R,gtid(1400));
  R.Grow(-2,-2);
  r.b.y := r.a.y + 1;
(*    s := {RFix(Word2Str(AreaNum,0),5)+' '+}Fix(Name^,55);
    if Total > 0 then s := s + ' '+RFix(Word2Str(Total,0),6)+
                                   RFix(Word2Str(Pers,0),6)+
                                   RFix(Word2Str(Unread,0),6);*)
  Insert(New(PColorText,Init(R,Fix(gtid(1800),56)+
                               Fix(gtid(1801),6)+
                               Fix(gtid(1802),6)+
                               gtid(1803),0,$71)));
  inc(r.a.y,2);
  r.b.y := size.y-3;
  New(Lister,Init(R,NIL));
  MasteR := AMAsteR;
  ObtainAreaList;
  if AreaList = NIL then Panic('AreaList = NIL!! NIaaaa!');
  Lister^.NewList(AreaList);
  Insert(Lister);
  R.A.Y := R.B.Y+1;
  putbut(1401,cmOpen);
  putbut(1402,cmReplyPacket);
  putbut(1403,cmNewFiles);
  putbut(1404,cmSearch);
  putbut(1405,cmClose);
end;

procedure TAreaDialog.HandleEvent;
  procedure OpenArea;
  var
    P:PMailListDialog;
    Pr:PAreaRec;
    rec:TAreaRec;
    WhereWasI :integer;
  begin
    Pr := Lister^.List^.At(Lister^.Focused);
    WhereWasI := Lister^.Focused;
    rec := Pr^;
    rec.Name := NewStr(Pr^.Name^);
    if Pr = NIL then Panic('Focused = NIL whadda hell?');
    Lister^.NewList(NIL);
    New(P,Init(@rec,Master));
    Owner^.Insert(P);
    Hide;
    Owner^.ExecView(P);
    Show;
    Dispose(P,Done);
    ObtainAreaList;
    Lock;
    Lister^.NewList(AreaList);
    Lister^.FocusItem(WhereWasI);
    Lister^.DrawView;
    UnLock;
  end;
begin
  if Event.What = evKeyDown then case Event.KeyCode of
    kbEnter : begin
                OpenArea;
                ClearEvent(Event);
                exit;
              end;
    kbLeft : begin
               EndModal(cmClose);
               exit;
             end;
  end; {case}
  inherited HandleEvent(Event);
  case Event.What of
    evBroadcast: if Event.Command = cmListItemSelected then OpenArea else exit;
    evCommand : case Event.Command of
                  cmOpen : OpenArea;
                  else exit;
                end;
    else exit;
  end; {case}
  ClearEvent(Event);
end;

procedure TAreaDialog.ObtainAreaList;
begin
  if Master = NIL then Panic('MasteR alooo??');
{  StartJob(gtid(200));}
  AreaList := Master^.ReadAreaList;
{  EndJob;}
end;

{--------------------   TMailColl     ----------------------}
procedure TMailColl.FreeItem(item:pointer);
begin
  FreeMem(item,SizeOf(TMail));
end;

function TMailColl.Compare(k1,k2:pointer):integer;
var
  p1:PMail;
begin
  p1 := k1;
  with PMail(k2)^ do if MsgNum > p1^.MsgNum then Compare :=1 else
    if MsgNum < p1^.MsgNum then Compare := -1 else Compare := 0;
end;

{------------------->>>>>>> TMailPacket <<<<<<<--------------------}
constructor TMailPacket.Init;
var
  dir:DirStr;
  Name:NameStr;
  ext:ExtStr;
begin
  inherited Init;
  FSplit(APacketFile,dir,name,ext);
  Packetid   := NewStr(name);
  PacketFile := NewStr(APacketFile);
  Archiver   := GetArchInfo(PacketFile^);
  OK         := Archiver <> NIL;
  Batman     := false;
end;

function TMailPacket.GetDataStream;
begin
  GetDataStream := New(PDosStream,Init(WhereAmI+Packetid^+'.DAT',stOpen));
end;

procedure TMailPacket.Run;
var
  P:PAreaDialog;
begin
  New(P,Init(@Self));
  Application^.ExecView(P);
  Close;
end;

function FTI2TSMF(w:word):word;
var
  rez:word;
begin
  rez := 0;
  if w and ftiPrivate > 0 then rez := rez or tsmfNetmail;
  if w and ftiCrash > 0 then rez := rez or tsmfCrash;
  if w and ftiFile > 0 then rez := rez or tsmfFile;
  if w and ftiRead > 0 then rez := rez or tsmfRead;
  FTI2TSMF := rez;
end;

function TMailPacket.GetMails;
var
  userdir:FnameStr;
  T,xti:TDosStream;
  xtiRec:TXTIRec;
  fti:TFTIRec;
  xtiExists:boolean;
  w:word;
  where:longint;
  P:PMail;
  MailList:PMailColl;
begin
  New(MailList,Init(10,10));
  userdir := WhereAmI+Packetid^;
  T.Init(userdir+'.FTI',stOpenRead);
  T.Seek(Area^.Offset);
  if T.Status <> stOK then Panic('FTI? who cares');
  xti.Init(userdir+'.XTI',stOpenRead);
  xtiExists := xti.Status = stOK;
  if not xtiExists then xti.Done;
  ClearBuf(xtiRec,SizeOf(xtiRec));
  if Area^.Total > 0 then
  for w := 1 to Area^.Total do begin
    if xtiExists then begin
      where := (T.GetPos div SizeOf(TFTIRec))*SizeOf(TXTIRec);
      if where < xti.GetSize then begin
        xti.Seek(where);
        if xti.Status <> stOK Then Panic('seekiyim ben boyle xtiyi');
        xti.Read(xtiRec,SizeOf(xtiRec));
        if xti.Status <> stOK then Panic('I''ll be around. XTI will not');
      end else ClearBuf(xtiRec,SizeOf(xtiRec));
    end;
    T.Read(fti,SizeOf(fti));
{    Working;}
    if T.Status <> stOK then Panic('Spit it out. Don''t swallow FTIRec');
    New(P);
    ClearBuf(P^,SizeOf(P^));
    with P^ do begin
      Flags    := FTI2TSMF(fti.Flags);
      mFrom    := StrPas(@fti.mFrom);
      mTo      := StrPas(@fti.mTo);
      Subject  := StrPas(@fti.Subject);
      Date     := StrPas(@fti.Date);
      MsgNum   := fti.MsgNum;
      Where    := fti.Where;
      Length   := fti.MsgLength;
      Zone     := fti.orig_Zone;
      Net      := fti.orig_Net;
      Node     := fti.orig_Node;
      Point    := 0; {?}
      xtFlags  := xtiRec.Flags;
      xtMarks  := xtiRec.Marks;
    end;
    MailList^.Insert(P);
  end;
  T.Done;
  xti.Done;
  GetMails := MailList;
end;

function TMailPacket.Classified;
begin
  Classified := true;
end;

function TMailPacket.Recover;
begin
  Recover := false;
end;

function TMailPacket.Check;
  function CE(aext:ExtStr):boolean;
  begin
    CE := XFileExists(WhereAmI+PacketId^+'.'+aext);
  end;
begin
  OK := CE('INF') and CE('FTI') and CE('MIX') and CE('DAT');
  Check := OK;
end;

procedure TMailPacket.UpdatePacketInfo;
var
  I,O:TDosStream;
  buf:pointer;
  bufsize:word;
begin
  if not Batman then exit;
  I.Init(WhereAmI+Packetid^+'.INF',stOpenRead);
  if I.Status <> stOK then Panic(Packetid^+'.INF???');
  O.Init(wkdir+setup.userid+'\'+Packetid^+'.INF',stCreate);
  while I.GetPos < I.GetSize do begin
    BufSize := 65000;
    if BufSize > I.GetSize-I.GetPos then BufSize := I.GetSize-I.GetPos;
    if BufSize > MaxAvail then BufSize := MaxAvail;
    GetMem(buf,BufSize);
    I.Read(buf^,BufSize);
    O.Write(buf^,BufSize);
    FreeMem(buf,BufSize);
  end;
  I.Done;
  O.Done;
end;

function TMailPacket.ReadAreaList;
var
  P:PAreaRec;
  rInf:TInfRec;
  rMix:TMixRec;
  TInf,TMix:TDosStream;
  userdir:FnameStr;
  AreaList:PAreaColl;
  h:TInfHeader;
  found:boolean;
begin
  ReadAreaList := NIL;
  userdir := WhereAmI+Packetid^;
  TInf.Init(userdir+'.INF',stOpenRead);
  if TInf.Status <> stOK then begin
    TInf.Done;
    exit;
  end;
  TMix.Init(userdir+'.MIX',stOpenRead);
  if TMix.Status <> stOK then begin
    TMix.Done;
    exit;
  end;
  New(AreaList,Init(10,10));
  TInf.Read(h,SizeOf(TInfHeader));
  if h.HeaderLen <> SizeOf(TInfHeader) then Panic('header len mismatch');
  if h.AreaInfo_len <> SizeOf(TInfRec) then Panic('inf rec mismatch');
  if h.MixLen <> SizeOf(TMixRec) then Panic('mix rec mismatch');
  if h.FtiLen <> SizeOf(TFTIRec) then Panic('fti mismatch');
  while TMix.GetPos < TMix.GetSize do begin
    TInf.Read(rInf,SizeOf(rInf));
    if rInf.Flags and iafScanning > 0 then begin
      TMix.Seek(0);
      found := false;
      while TMix.GetPos < TMix.GetSize do begin
        TMix.Read(rMix,SizeOf(rMix));
        if pc2n(@rMix.AreaNum) = pc2n(@rInf.AreaNum) then begin
          found := true;
          break;
        end;
      end;
      if not found then Panic('mix<->inf inconsistency');
{      Working;}
      New(P);
      P^.Name    := NewStr(StrPas(@rInf.Title));
      P^.AreaNum := pc2n(@rInf.AreaNum);
      P^.Flags   := rInf.Flags;
      P^.Total   := rMix.Total;
      P^.Pers    := rMix.Pers;
      P^.Unread  := rMix.Total;
      P^.Offset  := rMix.FTIStart;
      AreaList^.Insert(P);
    end;
  end;
  TInf.Done;
  TMix.Done;
  ReadAreaList := AreaList;
end;

function TMailPacket.Create;
begin
  Create := false; {not supported on mail packets}
end;

function TMailPacket.WhereAmI;
begin
  WhereAmI := wkdir+setup.userid+'\PAK\';
end;

function TMailPacket.Close;
begin
  StartJob(gtid(913));
  Close := Pack(Archiver,PacketFile^,WhereAmI+Packetid^+'.XTI');
  XDeleteWild(WhereAmI+'*.*');
  Batman := false;
  EndJob;
end;

function TMailPacket.Open;
var
  pakdir:FnameStr;
  Pa:PArchInfo;
begin
  Open := false;
  Batman := false;
  pakdir := WhereAmI;
  dec(byte(pakdir[0]));
  MkDir(pakdir);
  if IOResult <> 0 then SpringClean;
  Pa := GetArchInfo(PacketFile^);
  if Pa = NIL then begin
    MsgBox(gtid(900),gtid(905),mfOK); {malesef}
    exit;
  end;
  if not UnPack(Pa,PacketFile^,pakdir) then begin
    MsgBox(gtid(907),gtid(908),mfOK);
    exit;
  end;
  Open   := true;
  Batman := true;
end;

destructor TMailPacket.Done;
  procedure beavis(butthead:PString);
  begin
    if butthead <> NIL then DisposeStr(butthead);
  end;
begin
  if Batman and OK then Close;
  beavis(PacketFile);
  beavis(Packetid);
  inherited Done;
end;

{--------------------<<<<<< TReplyPacket >>>>>>>----------------------}
constructor TReplyPacket.Init;
var
  dirtobemade:FnameStr;
begin
  inherited Init(apacketfile);
  dirtobemade := WhereAmI;
  dec(byte(dirtobemade[0]));
  MkDir(dirtobemade);
end;

function TReplyPacket.Close;
begin
  StartJob(gtid(913));
  Close := Pack(Archiver,PacketFile^,WhereAmI+'*.*');
  XDeleteWild(WhereAmI+'*.*');
  Batman := false;
  EndJob;
end;

function TReplyPacket.GetDataStream;
begin
  GetDataStream := NIL;
end;

function TReplyPacket.Check;
begin
  Check := true;
end;

function TReplyPacket.Classified;
begin
  Classified := false;
end;

function UPL2TSMF(var rec:TUPLRec):word;
var
  rez:word;
begin
  rez := 0;
  with rec do begin
    if msgattr and umfInactive > 0 then rez := rez or tsmfHidden;
    if msgattr and umfNetmail > 0 then rez := rez or tsmfNetmail;
    if netattr and unfFile > 0 then rez := rez or tsmfFile;
    if netattr and unfCrash > 0 then rez := rez or tsmfCrash;
  end;
  UPL2TSMF := rez;
end;

function TReplyPacket.GetMails;
var
  T:TDosStream;
  P:PMail;
  MailList:PMailColl;
  rec:TUPLRec;
begin
  if Area <> NIL then Panic('Areas not supported in reply packets!');
  New(MailList,Init(10,10));
  T.Init(WhereAmI+Packetid^+'.UPL',stOpenRead);
  if T.Status <> stOK then Panic('UPL panics and attempts to flee!');
  T.Seek(SizeOf(TUPLHeader));
  while T.GetPos < T.GetSize do begin
    T.Read(rec,SizeOf(rec));
    if T.Status <> stOK then Panic('UPL couldnt be read');
    New(P);
    ClearBuf(P^,SizeOf(P^));
    with P^ do begin
      Flags    := UPL2TSMF(rec);
      mFrom    := StrPas(@rec.mFrom);
      mTo      := StrPas(@rec.mTo);
      Subject  := StrPas(@rec.Subject);
      Zone     := rec.dZone;
      Net      := rec.dNet;
      Node     := rec.dNode;
      Point    := rec.dPoint;
      Link     := NewStr(StrPas(@rec.Filename));
    end;
    MailList^.Insert(P);
  end;
  T.Done;
  GetMails := MailList;
end;

function TReplyPacket.WhereAmI;
begin
  WhereAmI := wkdir+setup.userid+'\REP\';
end;

function TReplyPacket.ReadAreaList;
begin
  ReadAreaList := NIL;
end;

destructor TReplyPacket.Done;
var
  dirtoberem:fnameStr;
begin
  inherited Done;
  dirtoberem := WhereAmI;
  dec(byte(dirtoberem[0]));
  RmDir(dirtoberem);
end;

function TReplyPacket.Create;
begin
  Create := IOResult = 0;
end;

{ ## TAreaLister ## }
function TAreaLister.GetText;
var
  P:PAreaRec;
  s:string;
begin
  P := List^.At(item);
  with P^ do begin
    s := {RFix(Word2Str(AreaNum,0),5)+' '+}Fix(Name^,55);
    if Total > 0 then s := s + ' '+RFix(Word2Str(Total,0),6)+
                                   RFix(Word2Str(Pers,0),6)+
                                   RFix(Word2Str(Unread,0),6);
  end;
  GetText := s;
end;

function TAreaLister.GetColor;
var
  P:PAreaRec;
  color:byte;
begin
  P := List^.At(item);
  if P^.Flags and iafNetmail > 0 then color := $E
    else if P^.Flags and iafPost = 0 then color := 0
      else if P^.Flags and iafEcho > 0 then color := 4
        else color := 5;
  if item = Focused then begin
    if color in [5,2] then color := 0;
    color := color or $30;
  end else color := color or $70;
  GetColor := color;
end;

{ @@ TAreaColl @@ }
function TAreaColl.Compare;
var
  P2 : PAreaRec;
begin
  P2 := k2;
  with PAreaRec(k1)^ do if AreaNum < P2^.AreaNum then Compare := -1
    else if AreaNum > P2^.AreaNum then Compare := 1 else Compare := 0;
end;

procedure TAreaColl.FreeItem;
begin
  with PAreaRec(Item)^ do begin
    if Name <> NIL then DisposeStr(Name);
    FreeMem(Item,SizeOf(TAreaRec));
  end;
end;

{ >> TPacketDialog << }
constructor TPacketDialog.Init;
var
  R:TRect;
  procedure putbut(msg:longint; cmd:word);
  var
    px:PXButton;
  begin
    New(Px,Init(r.a.x,r.a.y,gtid(msg),cmd));
    Insert(Px);
    Px^.GetBounds(R);
    R.A.X := R.B.X+1;
  end;
begin
  Application^.GetExtent(R);
  R.Grow(0,-4);
  inherited Init(R,gtid(502));
  Options := Options or ofCentered;
  R.Assign(0,0,76,1);
  R.Move(2,2);
  Insert(New(PStaticText,Init(R,Fix(gtid(503),14)+Fix(gtid(504),12)+
                           Fix(gtid(505),10)+Fix(gtid(506),7)+
                           Fix(gtid(507),7)+Fix(gtid(508),7)+
                           Fix(gtid(509),7)+gtid(510))));
  R.Move(0,2);
  R.B.Y := Size.Y-3;
  New(Lister,Init(R,NIL));
  Lister^.NewList(alist);
  Insert(Lister);
  R.A.Y := R.B.Y+1;
  putbut(511,cmOpen);
  putbut(512,cmDelete);
  putbut(513,cmArchive);
  putbut(514,cmReplyPacket);
  putbut(515,cmClose);
  SelectNext(False);
end;

procedure TPacketDialog.OpenPacket;
var
  P:PPacketRec;
  Pkt:PMailPacket;
begin
  if Lister^.Range = 0 then exit;
  if ArchList^.Count = 0 then begin
    MsgBox(gtid(903),gtid(904),mfOK);
    exit;
  end;
  StartJob(gtid(906));
  P := Lister^.List^.At(Lister^.Focused);
  New(Pkt,Init(setup.dirDL+P^.Filename));
  if not Pkt^.Open then begin
    Dispose(Pkt,Done);
    EndJob;
    exit;
  end;
  if not Pkt^.Check then begin
    MsgBox(gtid(903),gtid(914),mfOK);
    Dispose(Pkt,Done);
    EndJob;
    exit;
  end;{if not Pkt^.Recover then begin
    Dispose(Pkt,Done);
    exit;
  end;}
  EndJob;
  Pkt^.Run;
end;

procedure TPacketDialog.HandleEvent;
  function ifTag:boolean;
  var
    n:integer;
  begin
    ifTag := false;
    for n:=0 to Lister^.List^.Count-1 do
      if PPacketRec(Lister^.List^.At(n))^.Tagged then begin
      ifTag := true;
      exit;
    end;
  end;
  procedure DeletePacket;
  var
    P:PPacketRec;
    n:integer;
    Px:PCollection;
    procedure UpdateList;
    var
      ofo:integer;
    begin
      ofo := Lister^.Focused;
      Lock;
      Lister^.List := NIL;
      Lister^.NewList(Px);
      if ofo > Lister^.Range-1 then ofo := Lister^.Range-1;
      Lister^.FocusItem(ofo);
      Lister^.DrawView;
      UnLock;
    end;
  begin
    if Lister^.Range = 0 then exit;
    Px := Lister^.List;
    if ifTag then begin
      if MsgBox(gtid(1100),gtid(1101),mfYes+mfNo) <> cmYes then exit;
      StartJob(gtid(1102));
      n := 0;
      while n <= Px^.Count-1 do begin
        P := Px^.At(n);
        if P^.Tagged then begin
          XDeleteAnyway(setup.dirDL+P^.Filename);
          Working;
          Px^.AtFree(n);
          UpdateList;
        end else inc(n);
      end;
      EndJob;
    end else if MsgBox(gtid(1100),gtid(1103),mfYes+mfNo) = cmYes then begin
      n := Lister^.Focused;
      P := Px^.At(n);
      XDeleteAnyway(setup.dirDL+P^.Filename);
      Px^.AtFree(n);
      UpdateList;
    end;
  end;
begin
  if Event.KeyCode <> kbEnter then inherited HandleEvent(Event);
  case Event.What of
    evBroadcast : if (Event.Command = cmListItemSelected) and
      (Event.InfoPtr = Lister) then OpenPacket else exit;
    evCommand : case Event.Command of
                  cmOpen   : OpenPacket;
                  cmClose  : EndModal(cmClose);
                  cmDelete : DeletePacket;
                  else exit;
                end; {case}
    evKeyDown : case Event.KeyCode of
                  kbDel   : DeletePacket;
                  kbEnter : OpenPacket;
                  else exit;
                end; {case}
    else exit;
  end; {case}
  ClearEvent(Event);
end;

procedure GetExtraPacketInfo(var rec:TPacketRec);
var
  T:TCodedStream;
  arec:TPacketCache;
begin
  FillChar(rec.Total,8,0);
  T.Init(wkdir+fnPktInfo,stOpenRead);
  if T.Status <> stOK then begin
    T.Done;
    exit;
  end;
  while T.GetPos < T.GetSize do begin
    T.Read(arec,SizeOf(arec));
    if rec.Filename = arec.Filename then begin
      Move(arec.Total,rec.Total,8);
      break;
    end;
  end;
  T.Done;
end;

function TPacketLister.GetText;
var
  P:PPacketRec;
  function w2s(w:word):fnameStr;
  begin
    if w = 0 then w2s := '' else w2s := Word2Str(w,0);
  end;
begin
  P := List^.At(Item);
  with P^ do
  GetText := Fix(Lower(Filename),14)+RFix(LInt2Str(Size,0),10)+'  '+
             Date2Str(LongRec(Date).Hi,False)+'  '+
             Time2Str(LongRec(Date).Lo,False,True)+'  '+
             RFix(w2s(Total),5)+'  '+
             RFix(w2s(Pers),5)+'  '+
             RFix(w2s(Marked),5)+'  '+
             RFix(w2s(Unread),5);
end;

procedure TPacketLister.SetTag;
begin
  PPacketRec(List^.At(Item))^.Tagged := enable;
end;

function TPacketLister.IsTagged;
begin
  IsTagged := PPacketRec(List^.At(Item))^.Tagged;
end;

{function TPacketLister.GetColor;
var
  color:byte;
begin
  with PPacketRec(List^.At(Item))^ do begin
    if Tagged then color := $E else
      if Unread = 0 then color := 4 else color := 0;
  end;
  if item = Focused then color := color or $30 else color := color or $70;
  GetColor := color;
end;}

{procedure TPacketLister.HandleEvent;
var
  P:PPacketRec;
begin
  inherited HandleEvent(Event);
  if Event.What = evKeyDown then case Event.KeyCode of
    kbSpace,kbIns : begin
      P := List^.At(Focused);
      P^.Tagged := not P^.Tagged;
      if Focused < Range-1 then FocusItem(Focused+1);
      DrawView;
    end;
  end;
end;}

{--- TPacketColl ---}
procedure TPacketColl.FreeItem;
begin
  Dispose(PPacketRec(Item));
end;

function TPacketColl.Compare;
var
  date1,date2:longint;
  t1,t2:DateTime;
  function comp(w1,w2:word):integer;
  begin
    if w1 = w2 then begin
      comp := 0;
      exit;
    end;
    if w1 > w2 then Compare := -1 else Compare := 1;
    comp := 1;
  end;
begin
  date1 := PPacketRec(k1)^.Date;
  date2 := PPacketRec(k2)^.Date;
  UnPackTime(date1,t1);
  UnPackTime(date2,t2);
  if comp(t1.year,t2.year) = 0 then if comp(t1.month,t2.month) = 0
  then if comp(t1.day,t2.day) = 0 then if comp(t1.hour,t2.hour) = 0
  then if comp(t1.min,t2.min) = 0 then if comp(t1.sec,t2.sec) = 0 then
    Compare := 1;
end;

end.