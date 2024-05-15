{
TurboSurfer (TM) - Offline Mail Reader at Light Speed!
(c) 1995 SSG

bugs:
-----
 þ labels should be added to arealist

todo's: (near future)
---------------------
- Cursor control
- Mail reader
- Reply archiver
- Multi system support? Hm? Not urgent.

todo's: (far, far away)
-----------------------
- message style (Normal, lower, CyBeRPuNK, external)
- point system support
- extended mail browsing capabilities...

updates: (skull:2394025)
--------
             Version 0.1 beta
29th Aug 95 - 19:25 - good going...
30th Aug 95 - 14:25 - yes. :)
30th Aug 95 - 18:01 - added main menu.
30th Aug 95 - 21:43 - going on this packet thing...
 1st Sep 95 - 22:55 - working working!!!! NIargh...
 1st Sep 95 - 15:06 - still coding.. fixed bugs.. added features..
 1st Sep 95 - 22:50 - Finished archive base...
 3rd Sep 95 - 12:51 - Finished dos shell & execution routines...
 3rd Sep 95 - 13:36 - going...
 4th Sep 95 - 00:14 - I must rethink the structure of packet routines...
 9th Sep 95 - 00:25 - converted everything to units...
11st Sep 95 - 10:28 - niarrgghh. i've no timeee!!!!
11st Sep 95 - 10:37 - brushed the surface of many technological achievements
                      (msdos 1.1 user's manual)
12th Sep 95 - 22:33 - getting strange stack overflow errors...
14th Sep 95 - 09:57 - fixed a bug in packet info reads...
14th Sep 95 - 10:19 - fixed a bug in duplicate user search of addnewuser...
18th Sep 95 - 21:11 - going cool..
29th Sep 95 - 19:56 - Hey! PCWORLD declared that the last application time
                      of the contest has been expanded to end of Oct. :))
                      Yes. I can finish it NOW! AHAHAH...
24th Feb 96 - 23:02 - removing multi-user support...
}

uses

TTypes,TSetup,TArch,TSign,TExec,TBlue,TPacket,TRes,TVX,

XStr,XIO,XStream,XBuf,XColl,Debris,

Exec,Dos,Dialogs,App,Views,Drivers,Menus,Objects;

{ $I TLogo}  {logo data}

const

  initSP : word = 0;

type

  PPassDialog = ^TPassDialog;
  TPassDialog = object(TXDialog)
    constructor Init;
  end;

  TMain = object(TXApp)
    Clock  : PClock;
    Status : PStatusText;
    Mem    : PPercBar;
    constructor Init;
    procedure   HandleEvent(var Event:TEvent);virtual;
    procedure   Idle;virtual;
    procedure   InitBackground;virtual;
    function    Valid(acmd:word):boolean;virtual;

    function    SetupUser(var asetup:TSetupRec):word;
    procedure   Packets;
    procedure   ProcessSetup;
    procedure   InitLanguage(alan:FnameStr);
    procedure   DosShell;
    procedure   GetEvent(var Event:TEvent);virtual;
  end;

{ -= TPassDialog =- }
constructor TPassDialog.Init;
var
  R:TRect;
begin
  R.Assign(0,0,23,6);
  inherited Init(R,gtid(102));
  Options := Options or ofCentered;
  R.Assign(0,0,19,1);
  R.Move(2,2);
  Insert(New(PXInputLine,Init(R,gtid(104),8,ifUpper+if7bit+ifHidden)));
  Insert(New(PXButton,Init(2,r.a.y+2,mmOk,cmOK)));
  SelectNext(False);
end;

procedure FileError(afile:FnameStr);
var
  s:string;
begin
  FormatStr(s,gtid(1201),afile);
  MsgBox(gtid(1200),s,mfOK);
end;

{ -= TMain =- }

procedure TMain.Packets;
var
  Pc:PPacketColl;
  Pr:PPacketRec;
  dirinfo:SearchRec;
  dir:DirStr;
  aname:NameStr;
  ext:ExtStr;
  Pd:PPacketDialog;
  code:word;
  pkid:string[8];
  function num(c:char):boolean;
  begin
    num := c in ['0'..'9'];
  end;
begin
  FindFirst(setup.dirDL+'*.*',Archive,dirinfo);
  if (DosError <> 0) and (DosError <> 18) then begin
    MsgBox(gtid(500),gtid(501),mfOk);
    exit;
  end;
  StartJob(gtid(112));
  New(Pc,Init(10,10));
  pkid := '';
  repeat
    FSplit(dirinfo.Name,dir,aname,ext);
    if length(ext)=4 then with dirinfo do begin
      Working;
      if num(ext[2]) or num(ext[4]) then begin
        New(Pr);
        Pr^.Filename := dirinfo.Name;
        Pr^.Packetid := aname;
        Pr^.Size     := dirinfo.Size;
        Pr^.Date     := dirinfo.Time;
        Pr^.Tagged   := false;
        GetExtraPacketInfo(Pr^);
        Pc^.Insert(Pr);
      end;
    end;
    FindNext(dirinfo);
  until DosError <> 0;
  New(Pd,Init(Pc));
  EndJob;
  code := ExecView(Pd);
  Dispose(Pd,Done);
  Dispose(Pc,Done);
end;

function TMain.SetupUser(var asetup:TSetupRec):word;
var
  Pd:PSetupDialog;
  R:TRect;
  code:word;

  procedure OtherSetup;
  var
    Px:PMainSetupDialog;
    acode:word;
  begin
    New(Px,Init);
    Px^.SetData(asetup.dirDL);
    acode := ExecView(Px);
    if acode = cmOK then Px^.GetData(asetup.dirDL);
    Dispose(Px,Done);
  end;

begin
  New(Pd,Init);
  Pd^.SetData(asetup);
  Insert(Pd);
  repeat
    code := ExecView(Pd);
    if code = cmOk then Pd^.GetData(asetup);
    if code = cmYes then OtherSetup;
  until code <> cmYes;
  Dispose(Pd,Done);
  SetupUser := code;
end;

function FindDir(daystobelived:nameStr):FnameStr;
  procedure Blooming(adir:FnameStr);
  var
    dirinfo:SearchRec;
    counter:word;
  begin
    FindFirst(adir+'*.*',Directory,dirinfo);
    counter := 0;
    while DosError = 0 do begin
      if dirinfo.Attr and Directory > 0 then if dirinfo.name[1] <> '.' then begin
          inc(counter);
          if counter mod 2 = 0 then Working;
          if pos(daystobelived,dirinfo.name) = 1 then begin
          FindDir := FExpand(adir+dirinfo.name);
          exit;
        end else Blooming(adir+dirinfo.name+'\');
      end;
      FindNext(dirinfo);
    end;
  end;
begin
  FindDir := '';
  Blooming('\');
end;

procedure TMain.ProcessSetup;
begin
  with setup do begin
    XMakeDirStr(dirDL,true);
    XMakeDirStr(dirUL,true);
    InitLanguage(fnLanguage);
  end;
  Status^.SetText(gtid(300)+setup.Username);
end;

procedure TMain.InitLanguage(alan:FnameStr);
begin
  if alan = '' then exit;
  DoneTRes;
  InitTRes(wkdir+alan);
  mmYes    := gtid(1);
  mmNo     := gtid(2);
  mmOk     := gtid(3);
  mmCancel := gtid(4);
  mmRetry  := gtid(5);
  with defaultSetup do begin
    QuoteStr := gtid(101);
  end;
end;

constructor TMain.Init;

  function AddNewUser(var asetup:TSetupRec):boolean;
  var
    temp:TSetupRec;
    code:word;
    T:TCodedStream;
    procedure Pic(w:word); {in fact this thing does the skeleton part of setup}
    var
      check:string[8];
    begin
      if w <> 24 then Panic('Nostalgia error');
      code := Input(gtid(114),gtid(257),79,0,asetup.userName);
      if code <> cmOK then exit;
      code := Input(gtid(114),gtid(258),8,ifUpper+if7bit,asetup.userid);
      if code <> cmOK then exit;
      repeat
        asetup.password := '';
        code := Input(gtid(114),gtid(259),8,ifUpper+if7bit+ifHidden,asetup.password);
        if code <> cmOK then exit;
        check := '';
        code := Input(gtid(114),gtid(260),8,ifUpper+if7bit+ifHidden,check);
        if code <> cmOK then exit;
        if check <> asetup.Password then MsgBox(gtid(261),gtid(262),mfOK);
      until check = asetup.Password;
      code := Input(gtid(114),gtid(118),79,ifUpper+if7bit,asetup.dirDL);
      if code <> cmOK then exit;
      code := Input(gtid(114),gtid(119),79,ifUpper+if7bit,asetup.dirUL);
      if code <> cmOK then exit;
    end;
  begin
    AddNewUser := false;
    asetup := DefaultSetup;
    StartJob(gtid(200));
    asetup.dirDL := FindDir('DOWN');
    asetup.dirUL := FindDir('UP');
    EndJob;
    repeat
      PIC(24);
      if code = cmOK then begin
        if asetup.userid = '' then begin
          MsgBox(gtid(201),gtid(202),mfOk);
          continue;
        end;
        T.Init(wkdir+fnSetup,stCreate);
        T.Write(asetup,SizeOf(asetup));
        T.Done;
        MkDir(wkdir+asetup.userid);
        EndJob;
        AddNewUser := true;
        exit;
      end;
    until code <> cmOk;
  end;

  procedure InitSetup;
  var
    T:TCodedStream;
    P:PPassDialog;
    code:word;
    temp:TSetupRec;
    function okUser:boolean;
    begin
      okuser := false;
      StartJob(gtid(112));
      T.Reset;
      T.Seek(0);
      while T.GetPos < T.GetSize do begin
        T.Read(temp,SizeOf(temp));
        if T.Status <> stOK then begin
          EndJob;
          MsgBox('Argh',gtid(207),mfOk);
          exit;
        end;
        if temp.userid = setup.userid then begin
          if temp.password = setup.password then begin
            EndJob;
            okUser := true;
            exit;
          end else begin
            EndJob;
            MsgBox('Heh heh',#3'Sifreniz yanlis',mfOk);
            exit;
          end;
        end else Working;
      end;
      EndJob;
    end;
  begin
    T.Init(wkdir+fnSetup,stOpenRead);
    if T.Status = stOK then begin
      T.Read(temp,SizeOf(temp));
      if T.Status = stOK then begin
        if temp.password<>'' then begin {multiuser}
          New(P,Init);
          repeat
            code := ExecView(P);
            if code <> cmOk then begin
              Done;
              halt;
            end;
            P^.GetData(setup);
          until okUser;
          if P <> NIL then Dispose(P,Done);
        end;
        setup := temp;
      end else Panic(wkdir+fnSetup+' :~( setup file fucked up');
      if not XFileExists(wkdir+setup.userid) then MkDir(wkdir+setup.userid);
      T.Done;
    end else begin
      T.Done;
      MsgBox(gtid(114),gtid(208),mfOk);
      if not AddNewUser(setup) then begin
        Done;
        halt;
      end;
    end;
    ProcessSetup;
  end;

  procedure InitStatus;
  var
    R:TRect;
    w:word;
  begin
    Lock;
    GetExtent(R);
    R.A.Y := R.B.Y-1;
    R.B.X := R.A.X+40;
    New(Status,Init(R));
    Status^.GrowMode := gfGrowAll;
    Insert(Status);
    R.A.X := R.B.X;
    R.B.X := Size.X-16;
    New(Mem,Init(R,initSP));
    Mem^.GrowMode := gfGrowAll;
    Insert(mem);
    R.A.X := R.B.X;
    R.B.X := Size.X;
    New(Clock,Init(R,coDate+coTime));
    Clock^.GrowMode := gfGrowAll;
    Insert(Clock);
    UnLock;
  end;

  procedure InitMenu;
  var
    Pd:PXDialog;
    R:TRect;
    w:word;
    procedure Putbut(ai:longint; acmd:word);
    begin
      Pd^.Insert(New(PXButton,Init(r.a.x,r.a.y,gtid(ai),acmd)));
      R.Move(0,2);
    end;
  begin
    R.Assign(0,0,32,11);
    R.Move(2,2);
    New(Pd,Init(R,'Secenekler'));
    Pd^.GrowMode := 0;
    R.Assign(0,0,28,1);
    R.Move(2,2);
    putbut(400,cmPackets);
    putbut(401,cmReplypacket);
    putbut(402,cmSetupUser);
    putbut(403,cmQuit);
    Pd^.SelectNext(False);
    Insert(Pd);
  end;

begin
  inherited Init;
  wkdir := XGetWorkDir;
  InitStatus;
  InitLanguage(fnResource);
  InitArchives;  {archive info initialisation}
  InitSetup;
  InitMenu;
end;

var
  shellmsg:string;

function mycheck(cmdbat: integer; swapping: integer;
                              var execfn: string; var progpars: string)
                             : integer;
begin
  PrintStr(shellmsg+#13#10#13#10);
  mycheck := 0;
end;

procedure TMain.DosShell;
begin
  shellmsg := gtid(1000);
  spawn_check := mycheck;
  TurboExec('','','',false);
  spawn_check := NIL;
end;

procedure TMain.Idle;
begin
  if Clock <> NIL then Clock^.Idle;
  if Mem <> NIL then Mem^.Idle;
end;

function TMain.Valid;
begin
  if acmd <> cmQuit then Valid := true else
    Valid := MsgBox(gtid(600),gtid(601),mfYes+mfNo) = cmYes;
end;

procedure TMain.InitBackground;
var
  R:TRect;
begin
  GetExtent(R);
  {Background := New(PLogoView,Init(R,@TLOGO,TLOGO_WIDTH,TLOGO_DEPTH,TLOGO_LENGTH));}
  Background := New(PXBackground,Init(R,#32,$30));
end;

procedure TMain.HandleEvent;

  procedure doSetup;
  var
    code:word;
    temp:TSetupRec;
    rd:TSetupRec;
    T:TCodedStream;
  begin
    temp := setup;
    repeat
      code := SetupUser(temp);
      if (code = cmOK) then begin
      {  if temp.userid = '' then begin
          MsgBox(gtid(201),gtid(202),mfOk);
          Continue;
        end;
        if temp.userid <> setup.userid then begin
          MsgBox(gtid(205),gtid(206),mfOk);
          temp.userid := setup.userid;
        end;}
        T.Init(wkdir+fnSetup,stCreate);
        if T.Status <> stOK then begin
          MsgBox(gtid(209),gtid(210),mfOk);
          T.Done;
          exit;
        end;
        T.Write(temp,SizeOf(temp));
        T.Done;
        setup := temp;
        ProcessSetup;
        code := cmYes;
      end;
    until code <> cmOk;
  end;

  procedure ArchiveSetup;
  var
    P:PArchDialog;
    code:word;
  begin
    New(P,Init);
    code := ExecView(P);
    Dispose(P,Done);
  end;

{  procedure UserMan;
  var
    P:PUserDialog;
  begin
    New(P,Init);
    ExecView(P);
    Dispose(P,Done);
  end;}

  procedure selectSetupType;
  var
    P:PxPopUp;
    R:TRect;
    code:word;
  begin
    R.Assign(0,0,1,1);
    New(P,Init(R,NewMenu(
      NewItem(gtid(800),'',0,cmSetupUser,0,
      NewItem(gtid(802),'',0,cmArchive,0,
      NewLine(
      NewItem(mmOk,'',0,cmCancel,0,
      NIL)))))));
    P^.Options := P^.Options or ofCentered;
    repeat
      code := ExecView(P);
      case code of
        cmSetupUser : doSetup;
        cmUserMan   : begin
                        Event.Command := cmUserMan;
                        PutEvent(Event);
                      end;
        cmArchive   : ArchiveSetup;
      end; {case}
    until (code = 0) or (code = cmCancel);
    Dispose(P,Done);
  end;

{  procedure AddUser;
  var
    ham:TSetupRec;
  begin
    if Event.InfoPtr <> @Self then Panic('InfoPtr suxxx');
    Move(defaultSetup,ham,SizeOf(TSetupRec));
    AddNewUser(ham);
  end;}

begin
  inherited HandleEvent(Event);
  case Event.What of
    evKeyDown : case Event.KeyCode of
                  kbEsc  : Message(@Self,evCommand,cmQuit,@Self);
                  kbAltD : DosShell;
                end; {case}
    evCommand : case Event.Command of
{                  cmAdd       : AddUser;}
                  cmPackets   : Packets;
                  cmSetupUser : selectSetupType;
{                  cmUserMan   : UserMan;}
                end; {case}
  end; {case}
end;

procedure TMain.GetEvent;
begin
  inherited GetEvent(Event);
  if Event.What = evKeyDown then case Event.KeyCode of
    kbAltD  : DosShell;
    kbAltF9 : if setup.VideoMode = vm80x25 then begin
                SetScreenMode(smFont8x8 or smCO80);
                InitSysPalette;
                setup.VideoMode := vm80x50;
              end else begin
                SetScreenMode(smCO80);
                InitSysPalette;
                setup.VideoMode := vm80x25;
              end;
    else exit;
  end else exit;
  ClearEvent(Event);
end;

var
  TurboSurfer:TMain;
begin
  asm
    mov ax,sp
    mov initSP,ax
  end;
  repeat
    TurboSurfer.Init;
    TurboSurfer.Run;
    TurboSurfer.Done;
  until not restartTurboSurfer;
end.