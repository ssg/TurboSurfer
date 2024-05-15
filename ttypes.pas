{ Generic TurboSurfer types & constants }

unit TTypes;

interface

uses Objects;

const

  tsVersion     = '0.1á';
  wkdir         : FnameStr = 'C:\BP';

  fnSetup       : string[12] = 'TSURFER.CFG';
  fnResource    : string[12] = 'TSURFER.LAN';
  fnPktInfo     : string[12] = 'TSURFER.PKT';
  fnArchInfo    : string[12] = 'TSURFER.ARG';
  fnTemp        : string[12] = 'TSURFER.TMP';

  restartTurboSurfer : boolean = false;

  cmSetDirs     = 45000;
  cmSetMail     = 45001;
  cmSetOther    = 45002;
  cmPackets     = 45003;
  cmSetupUser   = 45004;
  cmUserMan     = 45005;
  cmDelete      = 45006;
  cmArchive     = 45007;
  cmReplyPacket = 45008;
  cmAdd         = 45009;
  cmChange      = 45010;
  cmAbout       = 45011;
  cmNewFiles    = 45012;
  cmSearch      = 45013;
  cmPrint       = 45014;

function pc2n(P:PChar):longint;

implementation

uses Strings;

function pc2n;
var
  s:string;
  l:longint;
  code:integer;
begin
  s := StrPas(P);
  Val(s,l,code);
  pc2n := l;
end;

end.