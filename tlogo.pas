{ TheDraw Pascal Crunched Screen Image.  Date: 08/29/95 }
const
  TLOGO_WIDTH=80;
  TLOGO_DEPTH=25;
  TLOGO_LENGTH=1194;
  TLOGO : array [1..1194] of Char = (
     #4,#16,#24,#24,#25, #7,#12,'�', #4,#26, #9,'�','�',' ',' ',#12,'�',
     #4,#26, #3,'�',' ',' ',#12,'�', #4,#26, #3,'�',' ',#12,'�', #4,#26,
     #7,'�','�',' ',' ',#12,'�', #4,#26, #7,'�','�',#25, #3,#12,'�', #4,
    #26, #6,'�','�',#24,#25,#21,#12,'�', #4,#26, #3,'�',#25,#13,#12,'�',
     #4,#26, #3,'�',#25, #6,#12,'�', #4,#26, #3,'�',#25, #7,#12,'�', #4,
    #26, #3,'�',#24,#25,#15,#12,'�', #4,#26, #3,'�',' ',#12,'�', #4,#26,
     #3,'�',' ',' ',#12,'�', #4,#26, #3,'�',' ',#12,'�', #4,#26, #7,'�',
    '�',' ',' ',#12,'�', #4,#26, #7,'�','�',' ',' ',#12,'�', #4,#26, #3,
    '�',' ',' ',#12,'�', #4,#26, #3,'�',#24,#25,#15,#12,'�', #4,#26, #3,
    '�',' ',#12,'�', #4,#26, #3,'�',' ',' ',#12,'�', #4,#26, #3,'�',#25,
     #6,#12,'�', #4,#26, #3,'�',' ',#12,'�', #4,'�','�','�',' ',' ',#12,
    '�', #4,#26, #3,'�',' ',#12,'�', #4,#26, #3,'�',' ',' ',#12,'�', #4,
    #26, #3,'�',#24,#25,#15,#12,'�', #1,#20,#26, #3,'�',#16,'�',#12,#17,
    '�', #4,#16,#26, #3,'�',' ',' ',#12,'�', #4,#26, #3,'�',#25, #6,#12,
    '�', #4,#26, #3,'�',' ',#12,'�', #1,#20,'�','�','�',#16,'�',' ',#12,
    '�', #4,#26, #3,'�',' ',#12,'�', #4,#26, #3,'�',' ',' ',#12,'�', #4,
    #26, #3,'�',#24,#25,#14, #1,'�', #9,#17,'�',#16,#26, #5,'�',#17,'�',
     #1,#20,'�', #4,#16,'�','�',' ',' ',#12,'�', #4,#26, #3,'�',#25, #6,
    #12,'�', #4,#26, #3,'�', #1,'�', #9,#17,'�',#16,#26, #3,'�',#17,'�',
    #12,'�', #4,#16,#26, #3,'�',' ',#12,'�', #4,#26, #3,'�',' ',' ',#12,
    '�', #4,#26, #3,'�',#24,#25,#13, #1,'�', #9,'�','�','�', #1,'�', #4,
    #17,'�','�', #1,#16,'�', #9,'�','�','�', #1,'�', #4,#26, #5,'�','�',
    #25, #7,#12,'�', #4,#26, #3,'�', #1,'�', #9,'�','�',#17,'�', #4,'�',
     #9,'�',#16,'�',#17,'�', #1,#20,'�', #4,#16,'�','�',#25, #2,#12,'�',
    #20,'�', #4,#16,#26, #6,'�','�',#24,#25,#13, #1,'�', #9,'�','�','�',
     #1,'�',' ','�', #9,'�','�','�',#17,'�', #1,#16,'�',#25,#17,'�',' ',
    '�', #9,'�','�', #1,'�',' ',' ', #9,#17,'�',#16,'�', #1,'�',#24,#25,
    #14,'�', #9,'�','�','�', #1,'�',' ','�','�','�',#25,#11,'�',' ',' ',
    '�','�','�',' ','�', #9,#17,'�','�','�',#16,'�','�', #1,'�','�',' ',
    ' ','�',#25, #2,'�','�','�',#25, #3,'�',#25, #2,'�','�','�',' ',' ',
     #8,'t','m',#24,#25,#15, #1,'�', #9,'�','�','�', #1,'�',#25, #5,'�',
     #9,#17,'�', #1,#16,'�',' ',' ','�',' ',' ','�', #9,'�', #1,'�', #9,
    #17,'�',#16,'�','�','�','�', #1,'�',' ','�','�', #9,'�','�',#17,'�',
    '�','�', #1,#16,'�',' ',' ','�', #9,#17,'�',#16,'�','�','�',#17,'�',
     #1,#16,'�',' ','�', #9,#17,'�','�', #1,#16,'�', #9,#17,'�',#16,'�',
    '�','�',#17,'�', #1,#16,'�',#24,#25,#16,'�', #9,'�','�','�', #1,'�',
    #25, #3,#17,' ', #9,#16,'�', #1,'�',' ',' ','�', #9,#17,'�','�', #1,
    #16,'�','�','�', #9,'�','�', #1,'�','�','�', #9,#17,'�','�', #1,#16,
    '�','�', #9,'�','�',#17,'�', #1,#16,'�',' ','�',' ','�', #9,#17,'�',
    #16,'�','�',#17,'�', #1,#16,'�','�', #9,'�','�', #1,'�',' ','�', #9,
    '�','�',#17,'�', #1,#16,'�','�','�', #9,#17,'�','�', #1,#16,'�',#24,
    #25,#10,#26, #3,'�',#25, #2,'�', #9,'�','�','�', #1,'�',' ',' ','�',
     #9,'�','�', #1,'�',#25, #2,'�', #9,'�','�', #1,'�','�', #9,'�','�',
     #1,'�',#25, #4,'�', #9,'�','�', #1,'�',#25, #2,'�', #9,'�','�','�',
     #1,'�','�','�', #9,#17,'�',#16,'�','�', #1,'�',' ','�', #9,'�','�',
     #1,'�',#24,#25, #8,'�', #9,#17,'�',#16,#26, #3,'�',#17,'�', #1,#16,
    '�',' ',' ','�', #9,'�','�','�',#17,'�', #1,#16,'�','�', #9,'�','�',
     #1,'�',#25, #2,'�', #9,'�','�', #1,'�','�', #9,'�','�', #1,'�',#25,
     #4,'�', #9,'�','�', #1,'�',#25, #2,'�', #9,'�','�','�',#17,'�',#16,
    '�','�','�',#17,'�', #1,#16,'�',' ',' ','�', #9,'�','�', #1,'�',#24,
    #25, #6,'�', #9,#17,'�',#16,'�','�',#17,'�', #1,#16,'�','�', #9,#17,
    '�',#16,'�','�', #1,'�',' ',' ','�', #9,'�','�','�', #1,'�','�', #9,
    '�','�',#17,'�', #1,#16,'�',' ',' ','�', #9,'�','�', #1,'�','�', #9,
    '�','�', #1,'�',' ','�',#25, #2,'�', #9,'�','�', #1,'�',#25, #2,'�',
     #9,#17,'�',#16,'�','�', #1,'�','�','�','�',' ','�','�',' ','�', #9,
    '�','�', #1,'�',#24,#25, #6,'�', #9,'�','�','�', #1,'�','�','�','�',
    '�','�','�','�','�','�', #9,'�','�','�', #1,'�',' ','�', #9,'�','�',
    #17,'�', #1,#16,'�','�', #9,#17,'�',#16,'�','�', #1,'�','�', #9,'�',
    '�', #1,'�','�', #9,'�',#17,'�', #1,#16,'�','�', #9,'�','�',#17,'�',
     #1,#16,'�',#25, #4, #9,#17,'�',#16,'�','�', #1,'�','�','�', #9,#17,
    '�',#16,'�',#17,'�', #1,#16,'�','�', #9,'�','�', #1,'�',#24,#25, #7,
    '�', #9,#17,'�',#16,#26,#11,'�',#17,'�', #1,#16,'�',#25, #2,'�', #9,
    #26, #4,'�', #1,'�','�', #9,#17,'�',#16,'�',#17,'�', #1,#16,'�',' ',
    ' ','�', #9,#17,'�',#16,'�','�','�',#17,'�', #1,#16,'�',#25, #5,'�',
     #9,#17,'�',#16,#26, #4,'�',#17,'�', #1,#16,'�', #9,#17,'�','�','�',
     #1,#16,'�',#24,#25, #9,#26,#11,'�',#25, #5,#26, #4,'�',' ',' ','�',
    '�',#25, #5,'�','�','�',#25, #9,#26, #4,'�',' ',' ','�',#24,#24,#25,
    #22,#15,'C','o',#11,'p','y','r','i', #3,'g','h','t',' ',#15,'(',#11,
    'c', #3,')',' ',#15,'1',#11,'9', #3,'9','5',' ',#15,'S',#11,'e','d',
     #3,'a','t',' ',#15,'K','a','p',#11,'a','n','o', #3,'g','l','u',#24,
    #24,#24,#24,#24);