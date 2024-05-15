{
Archive module - Inspired from Tasmin Archer - Sleeping Satellite

updates:
--------
 9th Sep 95 - 11:17 - added GetArchInfo...
 9th Sep 95 - 11:39 - added Pack & UnPack... (untested)
}

unit TArch;

interface

uses Views,XStream,XBuf,App,Dialogs,TTypes,TRes,TVX,XColl,Drivers,Objects;

type

  PArchInfo = ^TArchInfo;
  TArchInfo = record
    desc      : FnameStr;
    cmdArch   : FnameStr;
    cmdUnArch : FnameStr;
    Sign      : FnameStr;
    Flags     : longint;
  end;

  PArchLister = ^TArchLister;
  TArchLister = object(TXListViewer)
    function  GetText(item:integer; maxlen:integer):string;virtual;
  end;

  PArchDialog = ^TArchDialog;
  TArchDialog = object(TXDialog)
    Lister    : PArchLister;
    constructor Init;
    function    Valid(acmd:word):boolean;virtual;
    procedure   HandleEvent(var Event:TEvent);virtual;
  end;

const

  afHideOut = 1;  {archiver flags}
  afDirect  = 2;
  afNoErr   = 4;

  archList  : PSizedCollection = NIL;

function  GetArchInfo(afile:FnameStr):PArchInfo;
function  UnPack(Pa:PArchInfo; afile,where:FnameStr):boolean;
function  Pack(Pa:PArchInfo; afile,wildcard:FnameStr):boolean;
procedure InitArchives;

implementation

uses Dos,XIO,TExec,TSign;

function Pack;
var
  cmd,params:FnameStr;
  b:byte;
  code:word;
begin
  Pack := false;
  if Pa^.Flags and afDirect > 0 then begin
    b := pos(' ',Pa^.cmdArch);
    if b > 0 then begin
      cmd    := copy(Pa^.cmdArch,1,b-1);
      params := copy(Pa^.cmdArch,b+1,255);
    end else begin
      cmd    := Pa^.cmdArch;
      params := '';
    end;
    if not XFileExists(cmd) then begin
      cmd := FSearch(cmd,GetEnv('PATH'));
      if cmd = '' then exit;
    end;
  end else begin
    cmd    := GetEnv('COMSPEC');
    params := '/C '+Pa^.cmdArch;
  end;
  params := params + ' '+afile+' '+wildcard;
  code := TurboExec('',cmd,params,Pa^.Flags and afHideout > 0);
  if (Pa^.Flags and afDirect > 0) and (Pa^.Flags and afNoErr = 0) then Pack := code = 0
                                                                  else Pack := Hi(code) = 0;
end;

function UnPack;
var
  cmd,params:FnameStr;
  b:byte;
  code:word;
begin
  UnPack := false;
  if Pa^.Flags and afDirect > 0 then begin
    b := pos(' ',Pa^.cmdUnarch);
    if b > 0 then begin
      cmd    := copy(Pa^.cmdUnarch,1,b-1);
      params := copy(Pa^.cmdUnarch,b+1,255);
    end else begin
      cmd := Pa^.cmdUnarch;
      params := '';
    end;
    if not XFileExists(cmd) then begin
      cmd := FSearch(cmd,GetEnv('PATH'));
      if cmd = '' then exit;
    end;
  end else begin
    cmd := GetEnv('COMSPEC');
    params := '/C '+Pa^.cmdUnArch;
  end;
  params := params + ' '+afile;
  code := TurboExec(where,cmd,params,Pa^.Flags and afHideout > 0);
  if (Pa^.Flags and afDirect > 0) and (Pa^.Flags and afNoErr = 0) then UnPack := code = 0
                                                                  else UnPack := Hi(code) = 0;
end;

function GetArchInfo;
var
  n:integer;
  Pa:PArchInfo;
  T:TDosStream;
  buf:array[1..128] of byte;
begin
  Pa          := NIL;
  GetArchInfo := NIL;
  ClearBuf(buf,SizeOf(buf));
  T.Init(afile,stOpenRead);
  if T.Status <> stOK then begin
    T.Done;
    exit;
  end;
  T.Read(buf,SizeOf(buf));
  T.Done;
  for n:=0 to ArchList^.Count-1 do begin
    Pa := ArchList^.At(n);
    if CompareSign(buf,Pa^.Sign) then begin
      GetArchInfo := Pa;
      exit;
    end;
  end;
end;

constructor TArchDialog.Init;
var
  R:TRect;
  procedure putbut(aid:longint; acmd:word);
  var
    px:PXButton;
  begin
    New(PX,Init(r.a.x,r.a.y,gtid(aid),acmd));
    PX^.Options := PX^.Options and not ofSelectable;
    Insert(PX);
    R.Move(0,2);
  end;
begin
  R.Assign(0,0,41,10);
  inherited Init(R,gtid(700));
  Options := Options or ofCentered;
  dec(R.B.X, 15);
  R.Move(2,2);
  R.B.Y := R.A.Y+7;
  New(Lister,Init(R,NIL));
  Lister^.NewList(archList);
  Insert(Lister);
  R.A.X := R.B.X+1;
  R.B.Y := R.A.Y+1;
  putbut(701,cmAdd);
  putbut(702,cmChange);
  putbut(703,cmDelete);
  putbut(704,cmOK);
  SelectNext(False);
end;

procedure TArchDialog.HandleEvent;

  function GetDialog(ahdr:FnameStr):PXDialog;
  var
    Px:PXDialog;
    R:TRect;
    PC:PCheckBoxes;
    procedure Putinput(aid:longint; aflags:word);
    begin
      Px^.Insert(New(PXInputLine,Init(R,gtid(aid),79,aflags)));
      R.Move(0,2);
    end;

    procedure putbut(amsg:FnameStr; acmd:word);
    var
      p:pXButton;
    begin
      New(P,Init(r.a.x,r.a.y,amsg,acmd));
      Px^.Insert(P);
      P^.GetBounds(R);
      R.A.X := R.B.X+1;
    end;
  begin
    R.Assign(0,0,39,16);
    New(Px,Init(R,ahdr));
    Px^.Options := Px^.Options or ofCentered;
    R.Assign(0,0,35,1);
    R.Move(2,2);
    putinput(803,0);
    putinput(804,if7bit+ifUpper);
    putinput(805,if7bit+ifUpper);
    putinput(806,if7bit+ifUpper);
    R.A.Y := R.B.Y-1;
    R.B.Y := R.A.Y+3;
    New(PC,Init(R,
      NewSItem(gtid(807),
      NewSItem(gtid(808),
      NewSItem(gtid(809),
      NIL)))));
    Px^.Insert(PC);
    PC^.GetBounds(R);
    R.A.Y := R.B.Y+1;
    putbut(gtid(115),cmOk);
    putbut(mmCancel,cmCancel);
    Px^.SelectNext(False);
    GetDialog := Px;
  end;

  function ValidData(var rec:TArchInfo):boolean;
  begin
    with rec do if (desc='') or (cmdArch='') or (cmdUnArch='')
      or (Sign='') then begin
      MsgBox(gtid(814),gtid(815),mfOK);
      ValidData := false;
    end else ValidData := true;
  end;

  function DoEdit(var rec:TArchInfo):word;
  var
    Px:PXDialog;
    code:word;
    T:TArchInfo;
  begin
    Px := GetDialog(gtid(810));
    Px^.SetData(rec);
    Application^.Insert(Px);
    repeat
      code := ExecView(Px);
      if code = cmOK then begin
        Px^.GetData(T);
        if ValidData(T) then begin
          Move(T,rec,SizeOf(TArchInfo));
          break;
        end;
      end else break;
    until false;
    Dispose(Px,Done);
    DoEdit := code;
  end;

  procedure UpdateList;
  var
    foc:integer;
  begin
    Lister^.List := NIL;
    foc          := Lister^.Focused;
    Lock;
    Lister^.NewList(ArchList);
    if foc > ArchList^.Count-1 then foc := ArchList^.Count-1;
    Lister^.FocusItem(foc);
    Lister^.DrawView;
    UnLock;
  end;

  procedure Add;
  var
    P:PArchInfo;
    T:TArchInfo;
  begin
    ClearBuf(T,SizeOf(T));
    T.Flags := afHideout or afNoErr;
    if DoEdit(T) = cmOK then begin
      New(P);
      Move(T,P^,SizeOf(TArchInfo));
      ArchList^.Insert(P);
      UpdateList;
    end;
  end;

  procedure Change;
  var
    P:PArchInfo;
    T:TArchInfo;
  begin
    if ArchList^.Count = 0 then exit;
    P := ArchList^.At(Lister^.Focused);
    if P = NIL then Panic('TArch.Change: lister sucks');
    Move(P^,T,SizeOf(TArchInfo));
    if DoEdit(T) = cmOK then begin
      Move(T,P^,SizeOf(TArchInfo));
      UpdateList;
    end;
  end;

  procedure Del;
  begin
    if ArchList^.Count > 0 then
    if MsgBox(gtid(812),gtid(813),mfYes+mfNo) = cmYes then begin
      ArchList^.AtFree(Lister^.Focused);
      UpdateList;
    end;
  end;

begin
  if Event.What = evKeydown then case Event.KeyCode of
    kbEnter : begin
      Change;
      ClearEvent(Event);
      exit;
    end;
  end; {case}
  inherited HandleEvent(Event);
  if Event.What = evCommand then case Event.Command of
    cmAdd : Add;
    cmChange : Change;
    cmDelete : Del;
    else exit;
  end else if Event.What = evKeydown then case Event.KeyCode of
    kbIns : Add;
    kbDel : Del;
    else exit;
  end else exit; {everything}
  ClearEvent(Event);
end;

function TArchDialog.Valid;
var
  T:TCodedStream;
  n:integer;
begin
  Valid := true;
  if (acmd = cmOK) or (acmd=cmCancel) then begin
    T.Init(wkdir+fnArchInfo,stCreate);
    if T.Status <> stOK then Panic('ARGHHH '+wkdir+fnArchInfo);
    for n:=0 to ArchList^.Count-1 do T.Write(ArchList^.At(n)^,SizeOf(TArchInfo));
    T.Done;
  end;
end;

{ TArchLister }

function TArchLister.GetText;
begin
  with PArchInfo(List^.At(item))^ do GetText := desc;
end;

procedure InitArchives;
var
  T:TCodedStream;
  P:PArchInfo;
begin
  New(ArchList,Init(10,10,SizeOf(TArchInfo)));
  T.Init(wkdir+fnArchInfo,stOpenRead);
  if T.Status = stOK then while T.GetPos < T.GetSize do begin
    New(P);
    T.Read(P^,SizeOf(P^));
    ArchList^.Insert(P);
  end;
  T.Done;
end;

procedure DoneArchives;
begin
  Dispose(ArchList,Done);
end;

end.