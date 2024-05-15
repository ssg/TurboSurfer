{ Hex signature compare unit }

unit TSign;

interface

uses Objects;

function CompareSign(var buf; sign:FnameStr):boolean;

implementation

function CompareSign(var buf; sign:FnameStr):boolean;
var
  b:byte;
  result:byte;
  w:word;
  ok:boolean;
  function getit(c:char):byte;
  begin
    case upcase(c) of
      '0'..'9' : getit := byte(c)-48;
      'A'..'F' : getit := byte(c)-55;
    end; {case}
  end;
begin
  CompareSign := false;
  b := 1;
  w := 0;
  if odd(length(sign)) then exit;
  while b < length(sign) do begin
    if sign[b] <> '?' then begin
      result := (getit(sign[b]) shl 4) or getit(sign[b+1]);
      ok := true;
      asm
        les di,buf
        add di,w
        mov al,es:[di]
        cmp al,result
        je  @ok
        mov ok,false
      @ok:
      end;
      if not ok then exit;
    end;
    inc(b,2);
    inc(w);
  end;
  CompareSign := true;
end;

end.