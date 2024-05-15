{ BlueWave data types & encode & decode procs }

unit TBlue;

interface

const

  iufHotKeys   = 1;
  iufXPert     = 2;
  iufGraphics  = 8; {sad but true}
  iufNotMyMail = 16;

  infCanCrash  = 1;
  infCanAttach = 2;
  infCanKSent  = 4;
  infCanHold   = 8;
  infCanImm    = 16;
  infCanFReq   = 32;
  infCanDirect = 64;

  ptDoor       = 1;
  ptReader     = 2;

  iafScanning  = 1;     {user reads this area}
  iafAlias     = 2;     {aliases allowed}
  iafAnyName   = 4;     {allow any name to be entered}
  iafEcho      = 8;     {if set hitnet area, else local area}
  iafNetmail   = 16;    {Netmail area}
  iafPost      = 32;    {User can post}
  iafNoPrivate = 64;    {No private messages can be entered}
  iafNoPublic  = 128;   {No public messages allowed}
  iafNoTagline = 256;   {No taglines allowed}
  iaf7bit      = 512;   {No high bits}
  iafNoEcho    = 1024;  {user can prevent messages go to net - NIMP}
  iafHasFile   = 2048;  {file attach operations welcome}
  iafPersOnly  = 4096;  {user downloads only personal msgs in this area}
  iafPAll      = 8192;  {user downloads P+All messages in this area}

  intFidonet   = 1;  {network types}
  intQwkNet    = 2;
  intInternet  = 3;

  ftiPrivate   = 1;
  ftiCrash     = 2;
  ftiRead      = 4;
  ftiSent      = 8;
  ftiFile      = 16;
  ftiForward   = 32;
  ftiOrphan    = 64;
  ftiKill      = 128;
  ftiLocal     = 256;
  ftiHold      = 512;
  ftiImmediate = 1024;
  ftiFReq      = 2048;
  ftiDirect    = 4096;
  ftiUReq      = 32768;

  xtfHasRead    = 1;
  xtfHasReplied = 2;
  xtfIsPersonal = 4;

  xtmSave       = 1;
  xtmReply      = 2;
  xtmPrint      = 4;
  xtmDelete     = 8;

  umfInactive   = 1;
  umfPrivate    = 2;
  umfNoEcho     = 4;
  umfHasFile    = 8;
  umfNetmail    = 16;

  unfCrash      = 2;
  unfFile       = 16; {file attach}
  unfKill       = 128;
  unfLocal      = 256;
  unfHold       = 512;
  unfImmediate  = 1024;
  unfFReq       = 2048;
  unfDirect     = 4096;
  unfUReq       = 32768;

  pdqHotkeys    = 1;
  pdqXPert      = 2;
  pdqAreaChange = 4;
  pdq8bit       = 8;
  pdqNotMyMail  = 16;

  tsmfNetmail   = 1;
  tsmfCrash     = 2;
  tsmfRead      = 4;
  tsmfFile      = 8;
  tsmfHidden    = 16;

type

  TInfHeader = record
    ver          : byte;
    ReaderFiles  : array[1..5] of array[1..13] of char;
    RegNum       : array[1..9] of char;
    MashType     : byte; {zero}
    LoginName    : array[1..43] of char;
    AliasName    : array[1..43] of char;
    password     : array[1..21] of char;
    Passtype     : byte;
    zone,net,node,point:word;
    SysOp        : array[1..41] of char;
    Unused1      : word;
    SystemName   : array[1..65] of char;
    MaxFReqs     : byte;
    Unused2      : array[1..6] of byte;
    UFlags       : word;
    Keywords     : array[1..10] of array[1..21] of char;
    Filters      : array[1..10] of array[1..21] of char;
    Macros       : array[1..3] of array[1..80] of char;
    NetmailFlags : word;
    Credits      : word;
    Debits       : word;
    Can_Forward  : boolean;
    HeaderLen    : word;
    Areainfo_Len : word;
    MixLen       : word;
    FtiLen       : word;
    UsesUPL      : boolean;
    FromToLen    : byte; {Fix to 35 even if zero}
    SubjLen      : byte; {Fix 71 vice versa}
    PacketId     : array[1..9] of char;
    Reserved     : array[1..234] of byte;
  end;

  TInfRec = record
    AreaNum : array[1..6] of char;
    echoTag : array[1..21] of char;
    Title   : array[1..50] of char;
    Flags   : word;
    NetType : byte;
  end;

  TMixRec = record
    Areanum   : array[1..6] of char;
    Total     : word;
    Pers      : word;
    FTIStart  : longint;
  end;

  TFTIRec = record
    mFrom     : array[1..36] of char;
    mTo       : array[1..36] of char;
    Subject   : array[1..72] of char;
    Date      : array[1..20] of char;
    MsgNum    : word;
    ReplyTo   : word;
    ReplyAt   : word;
    Where     : longint;
    MsgLength : longint;
    Flags     : word;
    Orig_Zone : word;
    Orig_Net  : word;
    Orig_Node : word;
  end;

  TXTIRec = record
    Flags : byte;
    Marks : byte;
  end;

  TUPLHeader = record
    RegNum    : array[1..10] of char;
    Version   : array[1..20] of char; {encoded}
    MajVer    : byte;
    MinVer    : byte;
    RdrName   : array[1..80] of char;
    HdrLen    : word;
    RecLen    : word;
    LoginName : array[1..44] of char;
    AliasName : array[1..44] of char;
    TearLine  : array[1..16] of char;
    Pad       : array[1..36] of byte; {zeroed}
  end;

  TUPLRec = record
    mFrom     : array[1..36] of char;
    mTo       : array[1..36] of char;
    Subject   : array[1..72] of char;
    dZone,dNet,dNode,dPoint:word;
    MsgAttr   : word;
    NetAttr   : word;
    Date      : longint;
    ReplyTo   : longint;
    Filename  : array[1..13] of char;
    EchoTag   : array[1..21] of char;
    AreaFlags : word;
    Attach    : array[1..13] of char;
    UserArea  : array[1..7] of byte;
    Dest      : array[1..100] of char;
  end;

  TREQRec = record
    Filename : array[1..13] of char;
  end;

  TPDQHeader = record
    Keywords : array[1..10] of array[1..21] of char;
    Filters  : array[1..10] of array[1..21] of char;
    Macros   : array[1..3] of array[1..78] of char;
    Password : array[1..21] of char;
    PassType : byte;
    Flags    : word;
  end;

  TPDQRec = record
    echoTag : array[1..21] of char;
  end;

procedure BWEncode(var buf; count:word);
procedure BWDecode(var buf; count:word);

implementation

const

  MAXFACTOR = 10;

procedure BWEncode(var buf; count:word);assembler;
asm
  cld
  les  di,buf
  mov  cx,count
@loop:
  mov  al,es:[di]
  or   al,al
  je   @contiyugard
  add  al,MAXFACTOR
  mov  es:[di],al
@contiyugard:
  inc  di
  loop @loop
end;

procedure BWDecode(var buf; count:word);assembler;
asm
  cld
  les  di,buf
  mov  cx,count
@loop:
  mov  al,es:[di]
  or   al,al
  je   @contiyugard
  sub  al,MAXFACTOR
  mov  es:[di],al
@contiyugard:
  inc  di
  loop @loop
end;

end.