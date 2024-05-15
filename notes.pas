{
TurboSurfer

development notes:
------------------
abi sincik birinci sorun: tasarim. yani boyle bir programin kullanimi
en kolay sekli nasil olur?

yeni kullanici hikayesi ok.
giriste sifre sorma da ok. eger single-user'sa sifre sormamasi da ok.

sonra ana menu. hah. ana menu nasil olcek? su anki hali:

paketler| DL edilmis mesaj paketlerini aciyor. ayrica cevap pakedini de
          aciyor. bu cevap pakedi kismini ana menuye alsam hic fena olmaz.
          Hani: "gelen paketler" "giden paketler" diye iki kisma ayiririm.
          woauv. bu guzel fikir. biir.

Kullanici ayarlari: bunun ana menude olmasi iyi bir ozellik. bunda bir sorun
                    yok. sadece language degisiminde cozzzt.

Dusunuyorum da acaba bir global setup koysam mi? En azindan dil secimi
global olsun diyorum. evek evek. bir adet global setup yapilir. buna
simdilik sadece dil secimi konur. daha sonra dil degisince program
restart yapilir. boylece hersey ok olmus olur. NIahahaha.

Diyorum da acaba paketler listesini acilisa mi koysam diyorum. Cart diye
kullanilsin. Menu'yu de sikistiririm bir taraflara. Ovv. bu da fena fikir
degil. Dogru yav. direk paket listesi cikarsa kullanimi daha hizli ve
kolay olur. Ama ekranda menuye yer kalmiyor ki abi. Simdi dusunsene bir.
Yoo aslinda paket listesinin sadece width'i onemli. height'i 15'te tutarsam
uste biyerlere de menu koyarim. miss.

bu arada dil secimi isini lokal yapayim ama restart isi olsun yine diyorum.
cunku iki ayri herif farkli dillerde calismak isteyebilirler. bu onlarin
en dogal hakki degil mi dozer? (ruyamda ciller'i gordum. onla konustum.
ilginc bir ruyaydi netekim telleri birbirine karismis beyaz bir piyano
vardi. ciller'in bir kizi vardi ve onla beraber piyanonun tellerini
duzeltiyorduk. ulan ne bicim ruya. neyse.)

Paketlerin acilmasi kolay. PKUNZIP'i launch edecegim. hah aklima gelmisken:

multi-archiver support dusunuyorum. sanirim bunun icin global setup
yapmam gerekiyor. evet. arsiv ayarlari diye birsey. sart.

multi-archiver support isi oldu. paket acma isi de oldu.

simdi tek sorun temel sistem. yani hem reply'larin hem de maillerin
rahatcana okunabilecegi bir structure dizayn etmem gerekiyor. soyle olmali:

  procedure ReadPacket(apacket:FnameStr); --- cart pakedi okumali
                                          --- high level bir proc
                                          --- dogal olaraktan
                                          --- fakat oyle olmali zaten.

  Sonra bir object'imiz olmali TAreaLister deyu. Listviewer'dan inherit.

  Bu object TAreaColl uzerinden calismali. Her farkli read islemi
  farkli TAreaColl ile yapilacak. Tabi ayri read'ler icin ayri
  dialog'larin dizayn edilmesi sart.

  Ama mail ustunde modification yapan rutinler ayni olmali bu yuzdeeen
  aklima gelen muthis bir teknigi soyleyeyim:

TPacket diye bir object yapilir abi okie? Bu object degisik durumlarda
farkli davranabilir boylece. Degistirmek isteyen inherit alir. Niahaha.

  TPacket = object(TObject)
    constructor Init(afile:FnameStr);
    function    Open:word;virtual;
    function    Close:word;virtual;
    ....
    falan filan
  end;

  TReplyPacket = object(TPacket) NIahahahaha

  TArchivePacket = object(TPacket) MUahahahaha OOP rulez..

Ulam cok iyi fikir be. Yessss. Kesin boyle yapcam. Neyse sincik diger
kisimlara gecelim. Ne option'lar olacak?

  Sound secenegi (Speaker & SB destegi koyarsam iyi olur)
  Message filtering (bu fix olmali)
  Address book (sakin ha unutma cok onemli)
  Default tagline list (benim tagline'larim tabikine. eheheh :)
  Message marking (delete, archive etc)
  Immediate archiving... (cok onemli)
  Reply packet recovery...  (bluewave'de bilem var be)
  Mail packet recovery... (bu yok ama iste. NIahahahah)

