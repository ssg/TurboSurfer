{ TurboExec (tm) - (c) 1995 SSG }

unit TExec;

interface

uses Objects;

function TurboExec(adir,acmd,aparams:FnameStr; hidescreen:boolean):word;

implementation

uses App,Drivers,TVX,Dos{$IFNDEF DPMI},Exec{$ENDIF};

type

  PByte = ^byte;

{$IFNDEF DPMI}
function TurboExec(adir,acmd,aparams:FnameStr; hidescreen:boolean):word;
var
  olddir:FnameStr;
  old10:pointer;
  mode:byte;
  vectim:byte;
  P:PByte;
begin
  for vectim := 0 to 127 do begin
    GetIntVec(vectim,Pointer(P));
    if P^ = $cf then break;
  end;
  if P^ <> $cf then Panic('IRET?');
  if hidescreen then begin
    GetIntVec($10,old10);
    SetIntVec($10,P);
  end else begin
    mode := mem[Seg0040:$49];
    asm
      mov ax,3
      int 10h
    end;
  end;
  DoneEvents;
  DoneSysError;
  GetDir(0,olddir);
  ChDir(adir);
  TurboExec := do_Exec(acmd,aparams,USE_ALL,$ffff,false);
  ChDir(olddir);
  if HideScreen then begin
    SetIntVec($10,Old10);
  end else asm
    xor ah,ah
    mov al,mode
    int 10h
  end;
  InitEvents;
  InitSysError;
  InitSysPalette;
  Application^.ReDraw;
end;
{$ELSE}
This fucking thing isn't compatible with DPMI
{$ENDIF}

end.