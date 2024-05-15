{
User hi-level routines

updates:
--------
12th Sep 95 - 22:01 - finished user add & remove routines...
}

unit TUser;

interface

uses XIO,XStream,Drivers,XStr,TVX,TSetup,TTypes,Dos,Objects;

type

  PUserColl = ^TUserColl;
  TUserColl = object(TSortedCollection)
    procedure FreeItem(item:pointer);virtual;
    function  Compare(k1,k2:pointer):integer;virtual;
  end;

  PUserLister = ^TUserLister;
  TUserLister = object(TXListViewer)
    function  GetText(item:integer; maxlen:integer):string;virtual;
  end;

  PUserDialog = ^TUserDialog;
  TUserDialog = object(TXDialog)
    Lister    : PUserLister;
    constructor Init;
    procedure   HandleEvent(var Event:TEvent);virtual;
  end;

procedure SpringClean;

implementation

uses Views,TRes;

constructor TUserDialog.Init;
var
  Pc:PUserColl;
  P:PSetupRec;
  R:TRect;
  T:TCodedStream;
  procedure putbut(aid:longint; acmd:word);
  begin
    Insert(New(PXButton,Init(r.a.x,r.a.y,gtid(aid),acmd)));
    inc(r.a.y,2);
  end;
begin
  R.Assign(0,0,60,9);
  inherited Init(R,gtid(1300));
  Options := Options or ofCentered;
  New(Pc,Init(10,10));
  T.Init(wkdir+fnSetup,stOpenRead);
  while T.GetPos < T.GetSize do begin
    New(P);
    T.Read(P^,SizeOf(P^));
    if T.Status <> stOK then Panic('cfg file corrupt?');
    Pc^.Insert(P);
  end;
  T.Done;
  R.Grow(-2,-1);
  R.Move(0,1);
  R.B.X := R.A.X + 45;
  dec(r.b.y);
  New(Lister,Init(R,NIL));
  Lister^.NewList(PC);
  Insert(Lister);
  R.A.X := R.B.X + 1;
  putbut(1301,cmAdd);
  putbut(1302,cmDelete);
  putbut(1303,cmClose);
  SelectNext(False);
end;

procedure TUserDialog.HandleEvent;
  procedure UpdateList;
  var
    Pc:PCollection;
    foc:integer;
  begin
    foc := Lister^.Focused;
    Pc := Lister^.List;
    Lister^.List := NIL;
    Lock;
    Lister^.NewList(Pc);
    if foc > Lister^.Range-1 then foc := Lister^.Range-1;
    Lister^.FocusItem(foc);
    Lister^.DrawView;
    UnLock;
  end;

  procedure AddUser;
  begin
    Message(Owner,evCommand,cmAdd,Owner);
    UpdateList;
  end;

  procedure DelUser;
  var
    I,O:TCodedStream;
    rec:TSetupRec;
    P:PSetupRec;
    procedure DelDir(adir:FnameStr);
    var
      dirinfo:SearchRec;
      f:File;
    begin
      FindFirst(adir+'\*.*',directory+archive+readonly+hidden+sysfile,dirinfo);
      while DosError = 0 do begin
        if dirinfo.name[1] <> '.' then begin
          if dirinfo.Attr and Directory > 0 then DelDir(adir+'\'+dirinfo.name) else begin
            Assign(F,adir+'\'+dirinfo.name);
            SetFAttr(F,0);
            Erase(F);
          end;
        end;
        FindNext(dirinfo);
      end;
    end;
  begin
    if Lister^.Range =0 then exit;
    if MsgBox(gtid(1304),gtid(1305),mfYes+mfNo) = cmYes then begin
      StartJob(gtid(1102)); {deleting}
      P := Lister^.List^.At(Lister^.Focused);
      FastUpper(P^.userid);
      I.Init(wkdir+fnSetup,stOpenRead);
      O.Init(wkdir+fnTemp,stCreate);
      while I.GetPos < I.GetSize do begin
        Working;
        I.Read(rec,SizeOf(rec));
        if upper(rec.userid) <> P^.userid then O.Write(rec,SizeOf(rec));
      end;
      I.Done;
      O.Done;
      XDeleteAnyway(wkdir+fnSetup);
      XRenameAnyway(wkdir+fnTemp,wkdir+fnSetup);
      DelDir(wkdir+rec.userid);
      UpdateList;
      EndJob;
    end;
  end;
begin
  inherited HandleEvent(Event);
  case Event.What of
    evKeyDown : case Event.Keycode of
                  kbIns : AddUser;
                  kbDel : DelUser;
                  else exit;
                end; {case}
    evCommand : case Event.Command of
                  cmAdd : if Event.InfoPtr <> Owner then AddUser else exit;
                  cmDelete : DelUser;
                end; {Case}
    else exit;
  end; {case}
  ClearEvent(Event);
end;

procedure TUserColl.FreeItem;
begin
  FreeMem(item,SizeOf(TSetupRec));
end;

function TUserColl.Compare;
var
  p1:PSetupRec;
begin
  p1 := k1;
  with PSetupRec(k2)^ do if p1^.userid > userid then Compare := 1
    else if p1^.userid < userid then Compare := -1 else Compare := 0;
end;

function TUserLister.GetText;
begin
  with PSetupRec(List^.At(item))^ do
    GetText := Fix(userid,10)+Fix(username,20);
end;

procedure SpringClean;
var
  userdir:FnameStr;
  dirinfo:SearchRec;
  F:File;
begin
  userdir := wkdir+setup.userid+'\PAK\';
  FindFirst(userdir+'*.*',Archive,dirinfo);
  while DosError = 0 do begin
    Assign(F,userdir+dirinfo.name);
    SetFAttr(F,0);
    Erase(F);
    Working;
    FindNext(dirinfo);
  end;
end;

end.