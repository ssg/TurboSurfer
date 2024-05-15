(*****************************************************************************)
(*                                                                           *)
(*           The Blue Wave Offline Mail System Packet Structures             *)
(*     Copyright 1990-1994 by George Hatchew and Cutting Edge Computing      *)
(*                 All rights reserved - FidoNet 1:2240/176                  *)
(*                                                                           *)
(*                     Last Updated - January 18, 1994                       *)
(*                                                                           *)
(*        ---------------------------------------------------------          *)
(*            DISTRIBUTION OF THIS FILE IS LIMITED BY THE TERMS              *)
(*           SPECIFIED IN THE BLUE WAVE STRUCTURE DOCUMENTATION!             *)
(*        ---------------------------------------------------------          *)
(*                                                                           *)
(*   NOTE:  Refer to BLUEWAVE.H and the Blue Wave structure documentation    *)
(*          for additional comments and information.                         *)
(*                                                                           *)
(*****************************************************************************)

const
  PACKET_LEVEL=2;                 { Mail packet revision level  }
  ORIGINAL_INF_HEADER_LEN=1230;   { Original *.INF header len   }
  ORIGINAL_INF_AREA_LEN=80;       { Original *.INF area rec len }
  ORIGINAL_MIX_STRUCT_LEN=14;     { Original *.MIX record len   }
  ORIGINAL_FTI_STRUCT_LEN=186;    { Original *.FTI record len   }

type


(*****************************************************************************)
(* >>>>>>>>>>>>>>>>>>>>>  DOOR DATA FILE STRUCTURES  <<<<<<<<<<<<<<<<<<<<<<< *)
(*****************************************************************************)


(*
**  Name of file:   *.INF
**
**  Description:    The *.INF file is the source of information for just about
**                  everything from the host BBS, as well as definitions for
**                  all of the message areas that are available to the user
**                  and their status (Local, EchoMail, NetMail, Read Only,
**                  etc.).
**
**  File format:    INF_HEADER          { only included one time!        }
**                  INF_AREA_INFO       { repeated for as many msg bases }
**                  INF_AREA_INFO       { as are available to the user   }
**                  ...
*)

inf_uflags =
(
  INF_HOTKEYS,          { User uses "hotkeys" in door prompts   }
  INF_XPERT,            { Short menus displayed in door         }
  INF_RES1,             { RESERVED -- DO NOT USE!               }
  INF_GRAPHICS,         { Enable ANSI control sequences in door }
  INF_NOT_MY_MAIL,      { Do not bundle mail from user          }
  INF_UFLAG_RES1,       { RESERVED FOR FUTURE USE               }
  INF_UFLAG_RES2,       { RESERVED FOR FUTURE USE               }
  INF_UFLAG_RES3,       { RESERVED FOR FUTURE USE               }
  INF_UFLAG_RES4,       { RESERVED FOR FUTURE USE               }
  INF_UFLAG_RES5,       { RESERVED FOR FUTURE USE               }
  INF_UFLAG_RES6,       { RESERVED FOR FUTURE USE               }
  INF_UFLAG_RES7,       { RESERVED FOR FUTURE USE               }
  INF_UFLAG_RES8,       { RESERVED FOR FUTURE USE               }
  INF_UFLAG_RES9,       { RESERVED FOR FUTURE USE               }
  INF_UFLAG_RES10,      { RESERVED FOR FUTURE USE               }
  INF_UFLAG_RES11       { RESERVED FOR FUTURE USE               }
);

inf_netmail_flags =
(
  INF_CAN_CRASH,        { Allow Crash status          }
  INF_CAN_ATTACH,       { Allow File Attach messages  }
  INF_CAN_KSENT,        { Allow Kill/Sent status      }
  INF_CAN_HOLD,         { Allow Hold status           }
  INF_CAN_IMM,          { Allow Immediate status      }
  INF_CAN_FREQ,         { Allow File Request messages }
  INF_CAN_DIRECT,       { Allow Direct status         }
  INF_NETMAIL_RES1,     { RESERVED FOR FUTURE USE     }
  INF_NETMAIL_RES2,     { RESERVED FOR FUTURE USE     }
  INF_NETMAIL_RES3,     { RESERVED FOR FUTURE USE     }
  INF_NETMAIL_RES4,     { RESERVED FOR FUTURE USE     }
  INF_NETMAIL_RES5,     { RESERVED FOR FUTURE USE     }
  INF_NETMAIL_RES6,     { RESERVED FOR FUTURE USE     }
  INF_NETMAIL_RES7,     { RESERVED FOR FUTURE USE     }
  INF_NETMAIL_RES8,     { RESERVED FOR FUTURE USE     }
  INF_NETMAIL_RES9      { RESERVED FOR FUTURE USE     }
);

INF_HEADER =
record
  ver:byte;                       { Packet version type (currently 2)        }
  readerfiles:array[1..5] of      { Files to be displayed by reader          }
              array[1..13] of byte;
  regnum:array[1..9] of byte;     { User's registration number               }
  mashtype:byte;                  { Currently unused (door fills with 0)     }
                                  {   Reserved for Blue Wave reader to store }
                                  {   the compression type the packet uses.  }
  loginname:array[1..43] of byte; { Name user types at BBS login             }
  aliasname:array[1..43] of byte; { User's "other" name                      }
  password:array[1..21] of byte;  { Password                                 }
                                  {   All bytes should be the actually ASCII }
                                  {   value plus 10.  Lame security, yes,    }
                                  {   but it does prevent "TYPE *.INF" from  }
                                  {   showing the password.                  }
  passtype:byte;                  { Password type                            }
                                  {   0=none 1=door 2=reader 3=both          }
  zone:word;                      { Main network address of host BBS         }
  net:word;                       {   (zone:net/node.point)                  }
  node:word;
  point:word;
  sysop:array[1..41] of byte;     { Name of SysOp of host BBS                }
  obsolete1:array[1..2] of byte;  { OBSOLETE -- DO NOT USE!                  }
  systemname:array[1..65]         { Name of host BBS                         }
             of byte;
  maxfreqs:byte;                  { Max number of file requests allowed      }
  obsolete2:array[1..6] of byte;  { OBSOLETE -- DO NOT USE!                  }
  uflags:set of inf_uflags;       { Bit-mapped door options/toggles          }
  keywords:array[1..10] of        { User's entire set of door keywords       }
           array[1..21] of byte;
  filters:array[1..10] of         { User's entire set of door filters        }
          array[1..21] of byte;
  macros:array[1..3] of           { User's door bundling command macros      }
         array[1..80] of byte;
  netmail_flags:set of            { Bit-mapped NetMail options               }
                inf_netmail_flags;
  credits:word;                   { NetMail credits                          }
  debits:word;                    { NetMail debits                           }
  can_forward:byte;               { 0=Message forwarding not allowed         }
  inf_header_len:word;            { Size of INF_HEADER structure             }
  inf_areainfo_len:word;          { Size of INF_AREA_INFO structure          }
  mix_structlen:word;             { Size of MIX_REC structure                }
  fti_structlen:word;             { Size of FTI_REC structure                }
  uses_upl_file:byte;             { If this field is not zero, the door that }
                                  {   created this packet can receive reply  }
                                  {   packets in the new *.UPL file format.  }
                                  {   Otherwise, the old *.UPI and *.NET     }
                                  {   files must be used.                    }
  from_to_len:byte;               { The maximum length of the FROM: and TO:  }
                                  {   fields that the host BBS can support.  }
                                  {   If this value is 0 or is greater than  }
                                  {   35, then 35 must be used (the upload   }
                                  {   file formats only allow for a maximum  }
                                  {   of 35 characters).                     }
  subject_len:byte;               { The maximum length of the SUBJECT: field }
                                  {   that the host BBS can support.  If     }
                                  {   this value is 0 or is greater than 71, }
                                  {   then 71 must be used (the upload file  }
                                  {   formats only allow for a maximum of 71 }
                                  {   characters).                           }
  packet_id:array[1..9] of byte;  { Original root name of the mail packet,   }
                                  {   as specified by the mail door.  All    }
                                  {   files in the packet that are created   }
                                  {   by the mail door will use this root    }
                                  {   name, as will the reader when creating }
                                  {   the upload files.  Thus, even if the   }
                                  {   packets themselves are renamed to      }
                                  {   something completely different, the    }
                                  {   mail doors and readers will still be   }
                                  {   able to work with the proper files.    }
  reserved:array[1..234] of byte; { RESERVED FOR FUTURE USE                  }
                                  {   This field MUST be filled with ASCII   }
                                  {   NUL (0x00) characters in order for     }
                                  {   future additional features to work     }
                                  {   properly!                              }
end;

inf_area_flags =
(
  INF_SCANNING,         { On=User is active for area               }
  INF_ALIAS_NAME,       { On=Alias name, Off=Login name            }
                        {   If ON, use INF_HEADER.ALIASNAME when   }
                        {   addressing new mail or replies for the }
                        {   message area.  If OFF, the reader uses }
                        {   the INF_HEADER.LOGINNAME for this      }
                        {   purpose.                               }
  INF_ANY_NAME,         { On=Allow any name to be entered          }
                        {   If ON, any name can be entered in the  }
                        {   From: field when addressing new mail   }
                        {   or replies for the message area.  If   }
                        {   OFF, the normal rules apply.           }
  INF_ECHO,             { On=Network area, Off=Local area          }
                        {   The style of network mail depends on   }
                        {   the setting of the NETWORK_TYPE field. }
  INF_NETMAIL,          { On=Private network mail                  }
                        {   The style of private mail depends on   }
                        {   the setting of the NETWORK_TYPE field. }
                        {   (If INF_ECHO is off, this field is     }
                        {   ignored.)                              }
  INF_POST,             { On=User can post, Off=User CANNOT post   }
  INF_NO_PRIVATE,       { On=Private messages are NOT allowed      }
  INF_NO_PUBLIC,        { On=Public messages are NOT allowed       }
  INF_NO_TAGLINE,       { On=Taglines are not allowed              }
                        {   (Not yet implemented in Blue Wave.)    }
  INF_NO_HIGHBIT,       { On=ASCII 1-127 only, Off=ASCII 1-255     }
                        {   If ON, only ASCII values 1 to 127 are  }
                        {   allowed in messages.  If OFF, all      }
                        {   values from 1 to 255 are allowed.  Due }
                        {   to the fact that ASCII value 0 is used }
                        {   in C as a string terminator, the value }
                        {   0 should not be allowed in messages at }
                        {   all.                                   }
  INF_NOECHO,           { On=User can prevent messages from being  }
                        {   sent through the network               }
  INF_HASFILE           { On=User can attach files to messages     }
);

inf_network_types =
(
  INF_NET_FIDONET,      { 0=Set up for FidoNet-style network mail  }
  INF_NET_QWKNET,       { 1=Set up for QWK packet network mail     }
  INF_NET_INTERNET      { 2=Set up for Internet/Usenet mail        }
);

INF_AREA_INFO =
record
  areanum:array[1..6] of byte;    { Area number this record corresponds to  }
  echotag:array[1..21] of byte;   { Area tag name (*.BRD name for Telegard) }
  title:array[1..50] of byte;     { Area description/title                  }
  area_flags:set of               { Bit-mapped area options                 }
             inf_area_flags;
  network_type:inf_network_types; { Network mail type (if INF_ECHO set)     }
                                  {   If INF_ECHO is OFF, then this field   }
                                  {   can be ignored.                       }
end;

(*---------------------------------------------------------------------------*)

(*
**  Name of file:   *.MIX
**
**  Description:    The *.MIX file is a very small file, with one record for
**                  every message area that was scanned.  It contains the
**                  information to get into the *.FTI file.
**
**  File format:    MIX_REC     { repeated for each message area scanned }
**                  MIX_REC
**                  ...
*)

MIX_REC =
record
  areanum:array[1..6]       { Area number this record corresponds to         }
          of byte;          {   This is the ASCII representation of the      }
                            {   actual area number shown on the host BBS.    }
  totmsgs:word;             { Total number of messages for this area         }
  numpers:word;             { Total number of personal messages in this area }
  msghptr:longint;          { Pointer to first message header in *.FTI file  }
end;

(*---------------------------------------------------------------------------*)

(*
**  Name of file:   *.FTI
**
**  Description:    The *.FTI file contains the information for each message
**                  in the packet.  Each record includes all of the
**                  information about the message, including the pointer to
**                  the actual message text in the *.DAT file.
**
**                  NOTE:   Messages in the *.FTI file will ALWAYS be in area
**                          number order.  That is to say, if the MIX_REC
**                          indicates there are 100 messages for this area,
**                          all 100 messages will follow in sequential order.
**
**  File format:    FTI_REC     { repeated for as many messages }
**                  FTI_REC     { as obtained from the host BBS }
**                  ...
*)

fti_flags =
(
  FTI_MSGPRIVATE,       { Private = For addressee ONLY         }
  FTI_MSGCRASH,         { Crash = High priority mail           }
  FTI_MSGREAD,          { Read = Message read by addressee     }
  FTI_MSGSENT,          { Sent = Message sent                  }
  FTI_MSGFILE,          { File Attach = Send file(s)           }
  FTI_MSGFWD,           { Forward = Message to/from others     }
  FTI_MSGORPHAN,        { Orphan = Message destination unknown }
  FTI_MSGKILL,          { Kill/Sent = Delete after sending     }
  FTI_MSGLOCAL,         { Local = Message originated here      }
  FTI_MSGHOLD,          { Hold = Hold for pickup, don't send   }
  FTI_MSGIMMEDIATE,     { Immediate = Send message NOW         }
  FTI_MSGFRQ,           { File Request = Request file(s)       }
  FTI_MSGDIRECT,        { Direct = Send direct, no routing     }
  FTI_MSGUNUSED1,       {                                      }
  FTI_MSGUNUSED2,       {                                      }
  FTI_MSGURQ            { Update Request = Req updated file(s) }
);

FTI_REC =
record
  mfrom:array[1..36] of byte; { Person message is from                       }
  mto:array[1..36] of byte;   { Person message is to                         }
  subject:array[1..72]        { Subject/title of message                     }
          of byte;
  date:array[1..20] of byte;  { Origin date of message                       }
                              {   Depending on the host BBS's date storage   }
                              {   format, the EXACT format of this field     }
                              {   will change.  Some will take all 19 bytes, }
                              {   others may take only 10.                   }
  msgnum:word;                { Number of THIS message on BBS                }
  replyto:word;               { "This is a reply to #xx"                     }
                              {   Not used for every message.  When non-     }
                              {   zero, there is a previous message in       }
                              {   the thread.                                }
  replyat:word;               { "There is a reply at #xx"                    }
                              {   Not used for every message.  When non-     }
                              {   zero, there is a reply to this message.    }
  msgptr:longint;             { Offset to start of message in *.DAT file     }
                              {   Seek to this exact offset in the *.DAT     }
                              {   file, then read "msglength" bytes from     }
                              {   the file to load the entire message text.  }
  msglength:longint;          { Length of message text (in bytes)            }
  flags:set of fti_flags;     { Bit-mapped message status flags              }
  orig_zone:word;             { Origin address of message                    }
                              {   These three fields will most likely be 0,  }
                              {   unless the current message belongs to a    }
                              {   NetMail message base.                      }
  orig_net:word;
  orig_node:word;
end;

(*---------------------------------------------------------------------------*)

(*
**  Name of file:   *.DAT
**
**  Description:    The *.DAT file is an unstructured file which contains the
**                  text of every message obtained from the host BBS.
**                  Valid messages begin with an ASCII space (0x20) character
**                  (which is NOT to be considered part of the message!)
**                  followed by zero or more bytes which constitute the
**                  message text.  The pointer to the text for each message is
**                  stored in FTI_REC.MSGPTR, and the length of the text for
**                  each message is stored in FTI_REC.MSGLENGTH.
**
**  File format:    Unstructured
*)


(*****************************************************************************)
(* >>>>>>>>>>>>>>>>>  MISCELLANEOUS DATA FILE STRUCTURES  <<<<<<<<<<<<<<<<<< *)
(*****************************************************************************)


(*
**  Name of file:   *.MSG
**
**  Description:    The Fido *.MSG message (named for the BBS program on which
**                  it originated) has become a de-facto standard among BBS
**                  implementations, due to the sheer number of utilities
**                  available that operate with *.MSG messages.  It is as
**                  close to a universal message format as one can get in
**                  FidoNet (and FidoNet-style networks), and is the reason
**                  why it is used here (well, the *.MSG header, anyway).
**
**                  NOTE:   Most of the fields in the FTI_REC structure (shown
**                          above) correspond to similar fields in MSG_REC.
**                          This was done deliberately, in order to make
**                          *.FTI file processing a little more intuitive for
**                          programmers.  Also note that MSG_REC is only used
**                          by the NET_REC structure, which will soon become
**                          obsolete (replaced by UPL_REC).
**
**  File format:    MSG_REC         { only included one time!                }
**                  message text    { text can be terminated by an ASCII NUL }
**                                  { character (0x00), or by an ASCII CR,   }
**                                  { LF, NUL (0x0D 0x0A 0x00) sequence      }
*)

msg_attr =
(
  MSG_PRIVATE,          { Private                }
  MSG_CRASH,            { Crash mail             }
  MSG_RECEIVED,         { Received               }
  MSG_SENT,             { Sent                   }
  MSG_FATTACH,          { File attached          }
  MSG_INTRANSIT,        { In-transit             }
  MSG_ORPHAN,           { Orphaned               }
  MSG_KILL,             { Kill after sending     }
  MSG_LOCAL,            { Local message          }
  MSG_HOLD,             { Hold for pickup        }
  MSG_RESERVED,         { RESERVED               }
  MSG_FREQ,             { File request           }
  MSG_RREQ,             { Return receipt request }
  MSG_RECEIPT,          { Return receipt message }
  MSG_AREQ,             { Audit request          }
  MSG_FUREQ             { File update request    }
);

MSG_REC =
record
  mfrom:array[1..36]      { Person message is from                           }
       of byte;
  mto:array[1..36]        { Person message is to                             }
     of byte;
  subj:array[1..72]       { Subject/title of message                         }
       of byte;
  date:array[1..20]       { Creation date/time                               }
       of byte;           {   This date/time is usually in either of the     }
                          {   Fido-sanctioned formats "DD MMM YY  HH:MM:SS"  }
                          {   or "WWW DD MMM YY HH:MM", but due to the       }
                          {   chaotic nature of FidoNet-compatible software, }
                          {   this CANNOT be relied upon!                    }
  times:word;             { Number of times read (fairly obsolete)           }
  dest:word;              { Destination node (of net/node)                   }
  orig:word;              { Origin node (of net/node)                        }
  cost:word;              { Cost of sending message (usually in US cents)    }
  orig_net:word;          { Origin net (of net/node)                         }
  destnet:word;           { Destination net (of net/node)                    }
  unused1:longint;        { Undefined                                        }
  unused2:longint;        {   Some software (Opus and Maximus, for example)  }
                          {   uses these fields to store the sent/received   }
                          {   date/time as bit-packed fields, using the same }
                          {   format used in MS-DOS directory entries.       }
  reply:word;             { Message # that this message replies to           }
  attr:set of msg_attr;   { Message attributes and behavior flags            }
  up:word;                { Message # that replies to this message           }
end;

(*---------------------------------------------------------------------------*)

(*
**  Name of file:   *.XTI
**
**  Description:    The *.XTI file contains extended information for each
**                  message in the packet.  The number of records in the *.XTI
**                  file will always equal the number of messages in the
**                  packet, with each record corresponding to a record in the
**                  *.FTI file (i.e. record #1 in the *.XTI file corresponds
**                  to record #1 in the *.FTI file, and so on).
**
**                  NOTE:   This file is currently created ONLY by the Blue
**                          Wave reader, and is not a part of the official
**                          Blue Wave packet specification; it is merely
**                          documented here for third party programmers to use
**                          if they so desire.  How other readers store which
**                          messages have been read/replied-to/marked is left
**                          as an option to be implemented by the individual
**                          reader authors.  You may use this method if you so
**                          desire; however, PLEASE do not name any external
**                          files not conforming to this specification as
**                          <packet-ID>.XTI, due to the fact that the Blue
**                          Wave reader will expect the file to be in the
**                          format described.  If it's not in the expected
**                          format, things will get interesting. :-)
**
**  File format:    XTI_REC     { repeated for as many messages }
**                  XTI_REC     { as obtained from the host BBS }
**                  ...
*)

xti_flags =
(
  XTI_HAS_READ,         { Message has been read       }
  XTI_HAS_REPLIED,      { Message has been replied to }
  XTI_IS_PERSONAL       { Message is personal         }
);

xti_marks =
(
  XTI_MARK_SAVE,        { Message marked for saving   }
  XTI_MARK_REPLY,       { Message marked for replying }
  XTI_MARK_PRINT,       { Message marked for printing }
  XTI_MARK_DELETE       { Message marked for deletion }
);

XTI_REC =
record
  flags:set of xti_flags;     { Bit-mapped message flags   }
  marks:set of xti_marks;     { Bit-mapped message markers }
end;


(*****************************************************************************)
(* >>>>>>>>>>>>>>>>>>>>  READER DATA FILE STRUCTURES  <<<<<<<<<<<<<<<<<<<<<< *)
(*****************************************************************************)


(*
**  Name of file:   *.NET
**
**  Description:    The *.NET file is created ONLY when there is NetMail to be
**                  sent.  It contains the FULL header of the Fido-style *.MSG
**                  structure plus the fields defined below (which aren't part
**                  of the standard *.MSG structure yet required by the door).
**
**  File format:    NET_REC     { repeated for as many NetMail    }
**                  NET_REC     { messages as exist in the packet }
**                  ...
*)

NET_REC =
record
  msg:MSG_REC;                  { The Fido-style *.MSG header                }
  fname:array[1..13] of byte;   { Filename the message text is in            }
  echotag:array[1..21] of byte; { NetMail area tag (*.BRD name for Telegard) }
  zone:word;                    { Destination zone (of zone:net/node.point)  }
  point:word;                   { Destination point (of zone:net/node.point) }
  unix_date:longint;            { Date/time of message                       }
                                {   This Unix-style date/time value (number  }
                                {   of seconds since 01/01/70) is converted  }
                                {   to the date/time storage method used by  }
                                {   the host BBS.                            }
end;

(*---------------------------------------------------------------------------*)

(*
**  Name of file:   *.UPI
**
**  Description:    The *.UPI file contains the information for each message
**                  in the reply packet, as well as information on the reader
**                  version and registration numbers.  Each record includes
**                  all of the information about the message.
**
**  File format:    UPI_HEADER      { only included one time!        }
**                  UPI_REC         { repeated for as many msg bases }
**                  UPI_REC         { as are available to the user   }
**                  ...
*)

UPI_HEADER =
record
  regnum:array[1..9] of byte; { Reader registration number                   }
  vernum:array[1..13]         { Reader version number                        }
         of byte;             {   All bytes should be the actually ASCII     }
                              {   value plus 10.  Lame security, yes, but it }
                              {   does prevent "TYPE *.UPI" from showing the }
                              {   version number.                            }
  future:array[1..33]         { RESERVED FOR FUTURE USE                      }
         of byte;
end;

upi_flags =
(
  UPI_RES1,             { RESERVED FOR FUTURE USE                   }
  UPI_RES2,             { RESERVED FOR FUTURE USE                   }
  UPI_RES3,             { RESERVED FOR FUTURE USE                   }
  UPI_RES4,             { RESERVED FOR FUTURE USE                   }
  UPI_RES5,             { RESERVED FOR FUTURE USE                   }
  UPI_RES6,             { RESERVED FOR FUTURE USE                   }
  UPI_PRIVATE,          { Message is PRIVATE                        }
  UPI_NO_ECHO           { Message is NOT to be echoed               }
                        {   This feature is not yet implemented in  }
                        {   the Blue Wave reader or doors, as none  }
                        {   of the currently supported BBS software }
                        {   has support for this feature.           }
);

UPI_REC =
record
  mfrom:array[1..36] of byte;   { Person message is from                     }
  mto:array[1..36] of byte;     { Person message is to                       }
  subj:array[1..72] of byte;    { Subject/title of message                   }
  unix_date:longint;            { Date/time of message                       }
                                {   This Unix-style date/time value (number  }
                                {   of seconds since 01/01/70) is converted  }
                                {   to the date/time storage method used by  }
                                {   the host BBS.                            }
  fname:array[1..13] of byte;   { Filename the message text is in            }
  echotag:array[1..21] of byte; { Area tag name (*.BRD name for Telegard)    }
  flags:set of upi_flags;       { Bit-mapped flags                           }
  reedit:byte;                  { INTERNAL USE ONLY!                         }
                                {   This flag is used internally by the Blue }
                                {   Wave reader.  Doors should ignore this   }
                                {   field during reply packet processing.    }
end;

(*---------------------------------------------------------------------------*)

(*
**  Name of file:   *.UPL
**
**  Description:    The *.UPL file contains the information for each message
**                  in the reply packet, as well as information on the reader
**                  version and registration numbers.  Each record includes
**                  all of the information about the message.
**
**                  NOTE:   The *.UPL file is only generated by the Blue Wave
**                          reader version 2.11 and later.  *.UPL is intended
**                          to eventually replace the *.NET and *.UPI files,
**                          but door authors should code for the possibility
**                          of both instances (however, *.UPL should be used
**                          if present).
**
**  File format:    UPL_HEADER      { only included one time!       }
**                  UPL_REC         { repeated for as many messages }
**                  UPL_REC         { as are included in the packet }
**                  ...
*)

UPL_HEADER =
record
  regnum:array[1..10]         { Reader registration number (if desired)      }
         of byte;
  vernum:array[1..20]         { Reader version number as a string.           }
         of byte;             {   All bytes should be the actually ASCII     }
                              {   value plus 10.  Lame security, yes, but it }
                              {   does prevent "TYPE *.UPL" from showing the }
                              {   version number.                            }
                              {   Examples:  "2.10a Beta"                    }
                              {              "2.11"                          }
  reader_major:byte;          { Major version of the reader (number to the   }
                              {   left of the decimal point)                 }
  reader_minor:byte;          { Minor version of the reader (number to the   }
                              {   right of the decimal point)                }
  reader_name:array[1..80]    { String containing name of the reader, such   }
              of byte;        {   as "The Blue Wave Offline Mail Reader".    }
                              {   This is provided for door programmers that }
                              {   wish to display the name of the reader     }
                              {   that created the reply packet.  (Filling   }
                              {   it is mandatory but using it is optional.) }
  upl_header_len:word;        { Size of UPL_HEADER structure                 }
  upl_rec_len:word;           { Size of UPL_REC structure                    }
                              {   NOTE:  Refer to the INF_HEADER section for }
                              {          more information on using the size  }
                              {          fields.                             }
  loginname:array[1..44]      { Name found in INF_HEADER.LOGINNAME.  This is }
            of byte;          {   provided for door authors as a security    }
                              {   measure to implement as they wish.         }
  aliasname:array[1..44]      { Name found in INF_HEADER.ALIASNAME           }
            of byte;
  reader_tear:array[1..16]    { String containing abbreviated name of the    }
              of byte;        {   reader, such as "Blue Wave", "Q-Blue",     }
                              {   "Wave Rider", etc.  This is provided for   }
                              {   doors programmers that wish to add to the  }
                              {   tear line the name of the reader that      }
                              {   created the reply packet.  (Filling it is  }
                              {   mandatory but using it is optional.)       }
  pad:array[1..36] of byte;   { RESERVED FOR FUTURE USE, and to pad struct   }
                              {   out to a 'nice' 256 bytes                  }
end;

upl_msg_attr =
(
  UPL_INACTIVE,         { Message is INACTIVE                       }
                        {   Doors should NOT attempt to import this }
                        {   message.                                }
  UPL_PRIVATE,          { Message is PRIVATE                        }
  UPL_NO_ECHO,          { Message is NOT to be echoed               }
                        {   This feature is not yet implemented in  }
                        {   the Blue Wave reader or doors, as none  }
                        {   of the currently supported BBS software }
                        {   has support for this feature.           }
  UPL_HAS_FILE,         { Message has file "attached" to it         }
                        {   It is up to the door to check the       }
                        {   validity of this flag.  If the file is  }
                        {   contained in the mail packet, great.    }
                        {   If not, the door should probably prompt }
                        {   the user to begin uploading the file    }
                        {   after importing the messages.  (Not yet }
                        {   implemented in the Blue Wave reader.)   }
  UPL_NETMAIL,          { Message is NetMail                        }
                        {   Indicates that NetMail-specific fields  }
                        {   are utilized, and should be set for     }
                        {   messages entered in a FidoNet-style     }
                        {   NetMail area.                           }
  UPL_MRES6,            { RESERVED FOR FUTURE USE                   }
  UPL_MRES7,            { RESERVED FOR FUTURE USE                   }
  UPL_MRES8,            { RESERVED FOR FUTURE USE                   }
  UPL_MRES9,            { RESERVED FOR FUTURE USE                   }
  UPL_MRES10,           { RESERVED FOR FUTURE USE                   }
  UPL_MRES11,           { RESERVED FOR FUTURE USE                   }
  UPL_MRES12,           { RESERVED FOR FUTURE USE                   }
  UPL_MRES13,           { RESERVED FOR FUTURE USE                   }
  UPL_MRES14,           { RESERVED FOR FUTURE USE                   }
  UPL_MRES15,           { RESERVED FOR FUTURE USE                   }
  UPL_MRES16            { RESERVED FOR FUTURE USE                   }
);

upl_net_attr =
(
  UPL_NRES1,            { RESERVED FOR FUTURE USE             }
  UPL_NETCRASH,         { Crash = High priority mail          }
  UPL_NRES2,            { RESERVED FOR FUTURE USE             }
  UPL_NRES3,            { RESERVED FOR FUTURE USE             }
  UPL_NETFILE,          { File Attach = Send file(s) listed   }
                        {   in Subject field                  }
  UPL_NRES4,            { RESERVED FOR FUTURE USE             }
  UPL_NRES5,            { RESERVED FOR FUTURE USE             }
  UPL_NETKILL,          { Kill/Sent = Delete after sending    }
  UPL_NETLOCAL,         { Local = Message originated here     }
  UPL_NETHOLD,          { Hold = Hold for pickup, do not send }
  UPL_NETIMMEDIATE,     { Immediate = Send message NOW        }
  UPL_NETFRQ,           { File Request = Request file(s)      }
                        {   listed in Subject field           }
  UPL_NETDIRECT,        { Direct = Send direct, no routing    }
  UPL_NRES6,            { RESERVED FOR FUTURE USE             }
  UPL_NRES7,            { RESERVED FOR FUTURE USE             }
  UPL_NETURQ            { Update Request = Request updated    }
                        {   file(s) listed in Subject field   }
);

UPL_REC =
record
  mfrom:array[1..36] of byte; { Person message is from                        }
                              {   NOTE: Doors should validate this field!     }
  mto:array[1..36] of byte;   { Person message is to                          }
  subj:array[1..72] of byte;  { Subject/Title of message                      }
  destzone:word;              { Destination zone of message (NetMail only)    }
                              {   If the message is not a FidoNet NetMail     }
                              {   message, this field (and the subsequent     }
                              {   three fields as well) should be set to      }
                              {   zero.                                       }
  destnet:word;               { Destination net of message (NetMail only)     }
  destnode:word;              { Destination node of message (NetMail only)    }
  destpoint:word;             { Destination point of message (NetMail only)   }
  msg_attr:set of             { Bit-mapped message attributes                 }
           upl_msg_attr;
  netmail_attr:set of         { Bit-mapped NetMail message attributes         }
               upl_net_attr;
  unix_date:longint;          { Date/time of message                          }
                              {   This Unix-style date/time value (number     }
                              {   of seconds since 01/01/70) is converted to  }
                              {   the date/time storage method used by the    }
                              {   host BBS.                                   }
  replyto:longint;            { This unsigned long word stores the message #  }
                              {   that this message is a reply to.  This      }
                              {   should be the same as FTI.MSGNUM.  Note,    }
                              {   however, that FTI.MSGNUM is a word.  C      }
                              {   programmers especially will need to         }
                              {   properly typecast the value (i.e.           }
                              {   upl.replyto=longint(fti.msgnum)).  As       }
                              {   messaging/BBS systems become more complex,  }
                              {   FTI.MSGNUM may become obsolete, and a       }
                              {   longint variable may be used in its place.  }
  filename:array[1..13]       { Filename the message text is in               }
           of byte;           {   If this file does not exist in the upload   }
                              {   packet then doors should consider this an   }
                              {   invalid record.                             }
  echotag:array[1..21]        { Area tag the message goes in                  }
          of byte;            {   This must correspond exactly to the         }
                              {   INF_AREA_INFO.ECHOTAG field for the message }
                              {   area this message belongs to.  Simple area  }
                              {   number matching has proven not to work      }
                              {   simply because sysops are finicky people,   }
                              {   and seem to constantly renumber/change the  }
                              {   message area numbers on the host BBS.       }
                              {   Using an echotag helps to alleviate this    }
                              {   problem.  C_ECHO will be C_ECHO on the BBS, }
                              {   whether it is msg area 17 on the host BBS   }
                              {   or whether it is area 207. Doors should do  }
                              {   a case-INSENSITIVE compare on this field to }
                              {   find where the message belongs.             }
  area_flags:word;            { The Blue Wave Offline Mail Reader uses this   }
                              {   word internally to store the same value as  }
                              {   in INF_AREA_INFO.AREA_FLAGS.  The purpose   }
                              {   of this word is to hold the original        }
                              {   information about the message area so that  }
                              {   later message editing processes can be      }
                              {   controlled properly.  For example, if a     }
                              {   user later wanted to edit this message, the }
                              {   reader would know instantly whether this is }
                              {   a NETMAIL area, whether PVT messages are    }
                              {   allowed, etc.  This allows re-editing of    }
                              {   the message, even when there is not a       }
                              {   corresponding *.INF file laying around, or  }
                              {   the area is not listed in the *.INF file    }
                              {   you currently have to work with.  DOOR      }
                              {   AUTHORS SHOULD IGNORE THIS FIELD WHEN       }
                              {   IMPORTING MESSAGES!                         }
  f_attach:array[1..13]       { If the UPL_HAS_FILE flag is set, this field   }
           of byte;           {   will contain the file name that is attached }
                              {   to the message.                             }
  user_area:array[1..7]       { User-defined storage.  Doors should ignore    }
            of byte;          {   this field, and reader authors should feel  }
                              {   free to utilize this field for their own    }
                              {   internal use, if necessary.                 }
  net_dest:array[1..100]      { Network destination address                   }
           of byte;           {   If the message is for a non-FidoNet network }
                              {   message area, this field will contain the   }
                              {   ASCII representation of the destination     }
                              {   address.                                    }
end;

(*---------------------------------------------------------------------------*)

(*
**  Name of file:   *.REQ
**
**  Description:    The *.REQ file is simply a list of filenames the user
**                  wants to request from the host BBS.  Wildcard characters
**                  ("*" and "?" under MS-DOS) are allowed, but are not
**                  guaranteed to produce accurate results on all door
**                  implementations.
**
**                  NOTE:   Current Blue Wave doors do not accept wildcard
**                          characters in filenames, and will consider any
**                          filenames which contain them as being invalid.
**                          Additionally, if there are more than 10 entries in
**                          the *.REQ file, current Blue Wave doors will read
**                          the first 10 and discard the rest.  These are
**                          limitations of the Blue Wave doors, not of the
**                          Blue Wave format itself.
**
**  File format:    REQ_REC     { repeated for as many files as }
**                  REQ_REC     { requested from the host BBS   }
**                  ...
*)

REQ_REC =
record
  filename:array[1..13] of byte;    { Name of file to request }
end;

(*---------------------------------------------------------------------------*)

(*
**  Name of file:   *.PDQ
**
**  Description:    The *.PDQ file contains the information used for the
**                  offline configuration feature of the mail door.  After the
**                  header is a series of records which indicate the message
**                  areas to enable for scanning the next time a mail packet
**                  is requested.
**
**                  NOTE:   If the AREA_CHANGES flag in PDQ_HEADER.FLAGS is
**                          set, the door should process the offline
**                          configuration as well as changes to the list of
**                          areas the user wants to download.  In the Blue
**                          Wave door, this is done by first turning OFF all
**                          message areas that were active, then turning ON
**                          the ones specified in the *.PDQ file.  This seems
**                          to be the simplest, most straight-forward method
**                          of accomplishing this task, though other, more
**                          complex schemes could easily have been devised.
**
**  File format:    PDQ_HEADER      { only included one time!
**                  PDQ_REC         { repeated for as many message areas }
**                  PDQ_REC         { as the user wishes to enable       }
**                  ...
*)

pdq_flags =
(
  PDQ_HOTKEYS,          { Toggle "hotkeys" in prompts        }
  PDQ_XPERT,            { Toggle expert mode (menu displays) }
  PDQ_AREA_CHANGES,     { Change active message areas        }
  PDQ_GRAPHICS,         { Toggle IBM 8-bit ASCII characters  }
  PDQ_NOT_MY_MAIL,      { Toggle bundling mail from user     }
  PDQ_RESERVED1,        { RESERVED FOR FUTURE USE            }
  PDQ_RESERVED2,        { RESERVED FOR FUTURE USE            }
  PDQ_RESERVED3,        { RESERVED FOR FUTURE USE            }
  PDQ_RESERVED4,        { RESERVED FOR FUTURE USE            }
  PDQ_RESERVED5,        { RESERVED FOR FUTURE USE            }
  PDQ_RESERVED6,        { RESERVED FOR FUTURE USE            }
  PDQ_RESERVED7,        { RESERVED FOR FUTURE USE            }
  PDQ_RESERVED8,        { RESERVED FOR FUTURE USE            }
  PDQ_RESERVED9,        { RESERVED FOR FUTURE USE            }
  PDQ_RESERVED10,       { RESERVED FOR FUTURE USE            }
  PDQ_RESERVED11        { RESERVED FOR FUTURE USE            }
);

PDQ_HEADER =
record
  keywords:array[1..10] of          { User's entire set of door keywords  }
           array[1..21] of byte;
  filters:array[1..10] of           { User's entire set of door filters   }
          array[1..21] of byte;
  macros:array[1..3] of             { User's door bundling command macros }
         array[1..78] of byte;
  password:array[1..21] of byte;    { Password                            }
  passtype:byte;                    { Password type                       }
                                    {   0=none 1=door 2=reader 3=both     }
  flags:set of pdq_flags;           { Bit-mapped flags                    }
end;

PDQ_REC =
record
  echotag:array[1..21] of byte;   { Echo tag of message area to activate    }
                                  {   With Telegard systems, this should    }
                                  {   be the name of the *.BRD file, rather }
                                  {   than the actual echo tag.             }
end;

