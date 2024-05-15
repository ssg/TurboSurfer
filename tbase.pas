{ TurboSurfer base object implementations }

unit TBase;

interface

  PPacket = ^TPacket;
  TPacket = object(TObject)
    constructor Init(apacket:FnameStr);
    function    Open:boolean;virtual;
    function    Close:boolean;virtual;
    function    GetAreaList:PAreaColl;virtual;
  end;

implementation

end.