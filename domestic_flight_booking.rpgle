**free
  ctl-opt option(*nodebugio);
  dcl-f login usage(*update:*input:*output)keyed;
  dcl-f lgnmod workstn;
  dcl-f airmod workstn sfile(manaflt : rrn9);

  dcl-f usrmas usage(*update:*input:*output)keyed;
  dcl-f fltpf usage(*update:*input:*output)keyed;
  dcl-f cnttbl usage(*update:*input:*output)keyed;
  dcl-f grievpf usage(*update:*input:*output)keyed;
  dcl-f psngrpf usage(*update:*input:*output)keyed;
  dcl-f fltlf usage(*input)keyed
                 rename (fltrec: fltlfrec);
  dcl-f grievlf usage(*input)keyed
                  rename (grivrec: grivrec_lf);
  dcl-f bookinglf usage(*input)keyed

                 rename (bookrec: bookrec_lf);
 dcl-f boklf usage(*input)keyed
                 rename(bookrec:boklfrec);
 dcl-f ratingpf usage(*update:*input:*output)keyed;
 dcl-f tktpf usage(*update:*input:*output)keyed;
 dcl-f bookingpf usage(*update:*input:*output)keyed;
 dcl-f admmod workstn sfile(mngairline :rrn1)
                      sfile(mngusr :rrn2)
                      sfile(vwbkpag :rrn3)
                     sfile(vwflt :rrn5)
                     sfile(mngcomp : rrn6)
                     sfile(confset : rrn7)
                     sfile(dltcfset : rrn8)
                     sfile(vbop : rrn20)
                     sfile(vwbook: rrn23);
dcl-f usermod workstn sfile(sfr : rrn11)
                      sfile(umb : rrn12)
                      sfile(vt : rrn13);

dcl-f airmas usage(*update:*input:*output)keyed;
 dcl-s rrn1 zoned(4:0);
 dcl-s rrn2 zoned(4:0);
 dcl-s rrn3 zoned(4:0);
 dcl-s rrn5 zoned(4:0);
 dcl-s rrn6 zoned(4:0);
 dcl-s rrn7 zoned(4:0);
 dcl-s rrn8 zoned(4:0);
 dcl-s rrn9 zoned(4:0);
dcl-s rrn10 zoned(4:0);
 dcl-s rrn11 zoned(4:0);
 dcl-s rrn12 zoned(4:0);
 dcl-s rrn13 zoned(4:0);
 dcl-s rrn20 zoned(4:0);
 dcl-s rrn21 zoned(4:0);
 dcl-s rrn23 zoned(4:0);
 dcl-s chknum int(5);
 dcl-s curr_date int(10);
  dcl-s new int(5);
dcl-s count int(5);
dcl-s j int(5);
dcl-s currdate date;
dcl-s tempdate date;
dcl-s hasupper packed(4);
dcl-s haslower packed(4);
dcl-s hasdigit packed(4);
dcl-s i packed(5);
dcl-s hasSpecial packed(4);
dcl-s z int(5);
dcl-s r int(5);
dcl-s position int(5);
dcl-s chkcty int(5);
dcl-s chkeml int(5);
dcl-s n int(5);
dcl-s newuserid int(5);
dcl-s q int(5);
dcl-s newid char(5);
 dcl-s useridnum packed(5:0);
 dow *in03=*off;
 exfmt lgnscr;
 clear message;

 chain dspuid login;
 if not %found(login)  ;
 message = 'Invalid Username';
 else;
 if usrpas <> dsppas;
 message = 'Invalid Password';
 else;
 if usrrol = 'airname';
 exsr airmodule;
 endif;
 if usrrol = 'admin';
 exsr admdashboard;
endif;

 if usrrol = 'user';
 exsr userdashboard;
 endif;
 endif;
 endif;
if *in05=*on;
 clear dspuid;
 clear dsppas;
 clear message;
 endif;
if *in06=*on;
 clear count;
 exsr registration;
 *in12=*off;
 clear dspuid;
 clear dsppas;
 clear message;

 endif;
if *in07=*on and dspuid <> *blanks;
exsr forgotpass;
clear dspuid;
clear dsppas;
clear message;
clear fgmess;
*in12=*off;
endif;
enddo;
*inlr=*on;
 **************************************************************
   begsr forgotpass;
   dow *in03=*off;
   if *in12=*on;
   leave;
   endif;

   fgid = dspuid;
   fgque = usrque ;
exfmt fgpas;

if  %len(%trim(fgnpas)) >= 8;
for i=1 to %len(%trim(fgnpas));

 if %scan(%subst(fgnpas:i:1) : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') >0;
 hasupper=1;
 endif;
if %scan(%subst(fgnpas:i:1) : 'abcdefghijklmnopqrstuvwxyz') >0;
haslower=1;
endif;
if %scan(%subst(fgnpas:i:1) : '0123456789') >0;
hasdigit=1;
endif;
if %scan(%subst(fgnpas:i:1) : '!@#$%^&*') >0;
hasSpecial=1;
endif;
endfor;
endif;
Select;
when usrans<>fgans;
fgmess='Wrong answer';

when fgnpas = *blanks or fgcpas = *blanks
or fgnpas <>fgcpas and fgid <> *blanks;
fgmess='invalid password';
when %len(%trim(fgnpas)) < 8;
   fgmess = 'Password must be at least 8 characters';

 when hasupper=0 or haslower=0 or hasdigit=0 or hasSpecial=0;
   fgmess='Invalid Password';
 when fgnpas <> fgcpas;
  fgmess = 'Invalid Password';
other;
  clear fgmess;
 if *in06=*on;
 usrpas = fgnpas;
 update lgnrec;
 fgmess='Password changed successfully';
  clear fgid;
  clear fgans;
  clear fgnpas;
  clear fgcpas;
  clear fgque;
 endif;
 endsl;
if *in05=*on;
clear fgid;
clear fgque;
clear fgans;
clear fgnpas;
clear fgcpas;
clear fgmess;
endif;
 enddo;
endsr;
*****************************************************
  begsr registration;

  dow *in03=*off;
  if *in12=*on;
  leave;
  endif;
    SETLL *HIVAL usrmas;
    readp usrmas;
     if %eof(usrmas);
       regid='1';
     else;
       new = %int(userid);
       new = new + 1;
       regid = %char(new);
     endif;
   exfmt regscr;

 position=%check('ABCDEFGHIJKLMNOPQRSTUVWXYZ ' : regnme);
chknum=%check('0123456789' : regmob);
n=%len(%trim(regmob));
chkeml = 1;
dow %scan('@' : regmail : chkeml) > 0;
  chkeml = %scan('@' : regmail : chkeml);
   count += 1;
   chkeml += 1;
 enddo;
  chkcty=%check('ABCDEFGHIJKLMNOPQRSTUVWXYZ ' : regcty);
  j=%check('ABCDEFGHIJKLMNOPQRSTUVWXYZ ' : regstate);
  //z=%check('ABCDEFGHIJKLMNOPQRSTUVWXYZ ' : regadd);
 for i=1 to %len(%trim(regpas));
  if %scan(%subst(regpas:i:1) : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') >0;
  hasupper=1;
  endif;
  if %scan(%subst(regpas:i:1) : 'abcdefghijklmnopqrstuvwxyz') >0;
  haslower=1;
  endif;
  if %scan(%subst(regpas:i:1) : '0123456789') >0;
  hasdigit=1;
  endif;
  if %scan(%subst(regpas:i:1) : '!@#$%^&*') >0;
  hasSpecial=1;
  endif;
 endfor;
  q=%len(regaadhar);
  r=%len(regpincode);
  currdate = %date();
  curr_date = %dec(currdate);

 if FLD = 'REGGEN' and *in04 = *on;
 exfmt regprompt;
 Select;
 when gprompt = 1;
 reggen = 'm';
 when gprompt = 2;
 reggen ='f';
when gprompt = 3;
 reggen = 'o';
 endsl;
 if *in12 =*on;
 leave;
 endif;
 endif;
 Select;
when position>0;
  regmess='invalid username';
when chknum>0 or n<>10 or %subst(regmob : 1 : 1) = '0';
  regmess='invalid number';
when count <>1 or %subst(regmail : 1 : 1) =
 'abcdefghijklmnopqrstuvwxyz';
  regmess='invalid email';
when regcty = *blanks or chkcty > 0;
  regmess='invalid city';
when %len(%trim(regpas)) < 8;
   regmess = 'Password must be at least 8 characters';
 when hasupper=0 or haslower=0 or hasdigit=0 or hasSpecial=0;
   regmess='Invalid Password';
 when q<>12 or regaadhar= 0;
 regmess='Invalid Aadhar';
  when r<>6 or regpincode = 0;
regmess = 'Invalid Pincode';
 when j >0 or regstate = *blanks;
  regmess = 'Invalid State';
 when regadd = *blanks;
 regmess = 'Invalid Address';
 when regqstn = *blanks;
 regmess = 'Invalid question';
when regans = *blanks;
 regmess = 'Invalid answer';
 when regdob  < curr_date;
 regmess='invalid dob';
 usrdob = %date(regdob);
userid = regid;
username = regnme;
usrmobnum = regmob;
usremail = regmail;
usrcity = regcty;
usrpas = regpas;
usraadhar = regaadhar;
usrpincode = regpincode;
usrdob = %date(regdob);
 write usrrec;

 if *in06 = *on;
 usrid = regid;
 usrpas = regpas;
 usrque = regqstn;
 usrans = regans;
 status = 'A';
remark = 'active';
 usraddress = regadd;
 usrpincode = regpincode;
 usrmobnum  = regmob;
 username  = regnme;
 usrstate  = regstate;
  usrcity  = regcty;
 usraadhar = regaadhar;
 usrdob = %date(regdob);
   write lgnrec;
   clear regscr;
   regmess='registration sucessfully';
   endif;
  endsl;
  clear count;
 enddo;
       endsr;
 ******************************************************
   begsr admdashboard;

   dow *in03 = *off;
   read login;
   chain dspuid login;
   usrentry = usrrol;
   read usrmas;
chain dspuid usrmas;
if not %found(usrmas)  ;
message = 'Invalid Username';
endif;
exfmt admdhb;
Select;
 when dshentry = 1;
 exsr clear1;
 exsr load1;
 exsr display1;

 when dshentry = 2;
 exsr clear2;
exsr load2;
 exsr display2;

 when dshentry = 3;
 exsr clear3;
 exsr load3;
 exsr display3;

 when dshentry = 4;
exsr clear5;
exsr load5;
exsr display5;

when dshentry = 5;
exsr clear6;
exsr load6;
exsr display6;
when dshentry = 6;
 exsr clear7;
 exsr load7;
 exsr display7;

 when dshentry = 7;
 exsr changepassword;

 other;
admess = 'Invalid Entry';
 endsl;
 enddo;
 endsr;

************************************************
 begsr clear1;
 *in97 =*on;
 clear rrn1;
write mngarlnctl;
 *in97 = *off;
 endsr;
**********************************************
 begsr load1;
 read login;
 chain dspuid login;
   ux = usrrol;
 SETLL *LOVAL airmas;
read airmas;
 dow not %eof(airmas);

 mngalairid = airid;
 mngalname = airname;
 mngalflsz = airfleet;
 mngalsta = airstatus;
 rrn1 = rrn1 +1 ;
    write mngairline;
  read airmas;

  enddo;
  endsr;
***********************************************
  begsr display1;
  *in99 = *on;
 *in98 = *on;
if rrn1<= 0;
*in99 = *off;
endif;

write mngairfoot;
ux = username;
dow *in03=*off;
exfmt mngarlnctl;
readc mngairline;
if *in12=*on;
leave;
endif;
Select;

 when mngalopt = 5;
 chain airid airmas;
 dow *in03 = *off;

  auser = username;
  aid = airid;
  aname = airname;
adoe = %dec(airestdate);
 aflsz = airfleet;
 astatus = airstatus;
  aemail = airemail;
  apincode = airpincode;
  astate = airstate;
  acity = aircity;
 aaddress = airaddress;
exfmt dspaldet;
 if *in12 = *on;
  *in12 =*off;
 leave;
 endif;
 enddo;

 when mngalopt = 2;
 dow *in03 = *off;
chain updtaid airmas;
 updtuser = username;
 updtaid =  airid;

 updtaname = airname;
 updtdate = %dec(airestdate);
 updtapinco = airpincode;
 updtcty = aircity;
 updtstate = airstate;
updtadd = airaddress;
updtflsz = airfleet;
updtemail = airemail;
updtsta = airstatus;
 exfmt upaldts;
if *in12 = *on;
leave;
endif;
if *in06 =*on;
chain updtaid airrec;
if %found(airmas);
airname = updtaname;
airestdate = %date(updtdate);
airpincode = updtapinco;
aircity = updtcty;
airstate = updtstate;
 airaddress = updtadd;
 airfleet = updtflsz;
 airemail = updtemail;
 update airrec;
 dow *in03 = *off;
 exfmt dpdeti;
 if *in12 = *on;
 leave;
endif;
enddo;
endif;
endif;
enddo;
endsl;
enddo;
  endsr;
***********************************************
  begsr clear2;
  *in92 =*on;
  clear rrn2;
  write mngusrctl;
  *in92 = *off;
  endsr;
***********************************************
begsr load2;
 SETLL *LOVAL usrmas;
 read login;
 chain dspuid login;
 mnguser = usrrol;
 read usrmas;
 dow not %eof(usrmas);
   mngusruid = userid;
   mngusrname = username;
   mngusrmob =  usrmobnum;
   mngusrgen =  usrgen;
   mngusrsta =  usrstatus;
  rrn2 = rrn2 +1 ;
  write mngusr;
  read usrmas;
  enddo;
  endsr;
***********************************************
  begsr display2;
  *in90 = *on;
  *in91 = *on;
  if rrn2<= 0;
  *in90 = *off;
  endif;
  write mngusrfoot;
read usrmas;
 chain dspuid usrmas;
 mnguser = username;
 dow *in03 = *off;
 exfmt mngusrctl;
 readc mngusr;
 if *in12 = *on;
 leave;
 endif;
Select;
when mngusropt = 2;

  dow *in03 = *off;
  read login;
  chain dspuid login;
  upcpuser = usrrol;
  read usrmas;
  chain upcpuid usrmas;
upcpuid = userid;
 upcpname = username;
 upcpdob = %dec(usrdob);
 upcpgen = usrgen;
 upcpemail = usremail;
 upcpcty = usrcity;
 upcppincod = usrpincode;
 upcpstate = usrstate;
 upcpaadhar = usraadhar;
upcpadd = usraddress;
 upcpmob = usrmobnum;
   exfmt upcupro;
  if *in12 = *on;
  leave;
  endif;

 if *in06 = *on;
 chain upcpuid usrmas;
    userid =  upcpuid;
    username = upcpname;
    usrdob = %date(upcpdob);
    usrgen = upcpgen;
    usremail = upcpemail;
    usrcity = upcpcty;
    usrpincode = upcppincod;
    usrstate = upcpstate;
    usraadhar = upcpaadhar;
    usraddress = upcpadd;
    usrmobnum = upcpmob;
   update usrrec;
   endif;
   enddo;
   when mngusropt = 5;
   dow *in03 = *off;
     read login;
 chain dspuid login;
 udsdi = usrrol;
 read usrmas;
 chain dspuid  usrmas;
 if %found(usrmas);
  detid = userid;
   detname = username;
detnum = usrmobnum;
detimail = usremail;
deticity = usrcity;
detistate = usrstate;
detiadd = usraddress;
detigender = usrgen;
detipc = usrpincode;
detiadhr = usraadhar;
 detidob =  %dec(usrdob);
 endif;
 exfmt dpdeti;
  if *in12 = *on;
 leave;
 endif;
 enddo;
 when mngusropt = 6;
 exsr clear20;
 exsr load20;
 exsr display20;
endsl;
enddo;

endsr;
****************************************************
   begsr clear3;
    *in87 =*on;
    clear rrn3;
    write vwbkpagctl;
    *in87 = *off;
   endsr;
 ***************************************************
   begsr load3;
   read airmas;
   read airmas;
chain dspuid airmas;
 vwbkpsarln = airname;

read usrmas;
chain dspuid usrmas;
vwpaguid = userid;
vwpagusrnm = usrpas;
 read login;
 chain dspuid login;
  vwpagadmin = usrrol;

 SETLL *LOVAL fltpf;
 read fltpf;

 dow not %eof(fltpf);
 vwbkpasfid = fltid;
 vwbkpsorg  = fltorigin;
 vwbkpsdes   = fltdest;
vwbkpssta = fltstatus;
 rrn3 = rrn3 +1;
 write vwbkpag;
 read fltpf;
 enddo;

 endsr;
**************************************************
 begsr display3;
  *in89 = *on;
  *in88 = *on;
  if rrn3 <= 0;
  *in89 = *off;
  endif;
 write vwbkpagfot;
 dow *in03 = *off;
exfmt vwbkpagctl;
readc vwbkpag;
if *in12 = *on;
leave;
endif;
enddo;
endsr;
*************************************************
begsr clear5;
*in62 =*on;
clear rrn5;
write vwfltctl;
*in62 = *off;
endsr;
************************************************
begsr load5;
read usrmas;
chain dspuid usrmas;
if %found(usrmas);
vwfltadmin = username;
endif;
read airmas;
chain dspuid airmas;
if %found(airmas);
vwfltairl = airname;
endif;
read fltpf;
 dow not %eof(fltpf);

 vwfltfid = fltid;
 vwfltorg = fltorigin;
 vwfltdes = fltdest;
 vwfltsta = fltstatus;
 rrn5 = rrn5 +1;
 write vwflt;
read fltpf;
 enddo;
 endsr;
*************************************************
 begsr display5;
  *in60 = *on;
  *in61 = *on;
  if rrn5 <= 0;
  *in60 = *off;
  endif;
 write vwfltfoot;
 dow *in03 = *off;
 exfmt vwfltctl;
 readc vwflt;
 Select;
 when vwfltopt = 2;
 dow *in03 = *off;
read bookingpf;
 chain fltid2 boklf;

 ufddate = %dec(bkdepdate);

 read fltpf;
  upfltfid = fltid;
  upfltorg = fltorigin;
  upfltdes = fltdest;
upfltairc = airmodel;
 upfltrng = fltrange;
 upfltfcap = fltfuelcap;
 upfltseat = flttoseat;
 upflttp = flttkprice;
 ufdtime = %dec(fltdeptime);

 exfmt updflt;
 if *in06 =*on;
  chain upfltfid fltpf;
  if %found(fltpf);
  fltid =upfltfid;
  fltorigin = upfltorg;
  fltdest = upfltdes;
  airmodel = upfltairc;
  fltrange = upfltrng;
  fltfuelcap = upfltfcap;
  flttoseat = upfltseat;
  flttkprice = upflttp;
  fltdeptime = %time(ufdtime);

  update fltrec;
  endif;
  endif;
 if *in12 =*on;
 leave;
 endif;
enddo;

 when vwfltopt = 5;
 dow *in03 = *off;
 fid1 = fltid;
 dspfltorg = fltorigin;
 dspfltdest = fltdest;
 dspfltac = airmodel;
 dspfltrnge = fltrange;
dspfltfc = fltfuelcap;
 dspfltseat = flttoseat;
 dspfltsta = fltstatus;
 read airmas;
 chain dspuid airmas;
 if %found(airmas);
 dspalnme = airname;
 endif;
 exfmt dspfltdet;
if *in12 = *on;
 leave;
 endif;

 enddo;
 endsl;

 enddo;
 endsr;
****************************************************
  begsr clear6;
  *in72 =*on;
  clear rrn6;
  write mngcompctl;
  *in72 = *off;
  endsr;
***************************************************
begsr load6;
 read airmas;
 chain dspuid airmas;
 if %found(airmas);
 mngcomparl = airname;
 endif;
 read usrmas;
 chain dspuid usrmas;
 if %found(usrmas);
 mngcompnme = username;
endif;
SETLL *LOVAL grievpf;
 read grievpf;
 dow not %eof(grievpf);
 read grievlf;
 chain dspuid grievlf;
if %found(grievpf);
  mngcompcid = grvid;
  mngcompfid = fltid1;

  mngcompsta = status1;
 endif;
 rrn6 = rrn6 +1 ;
 write mngcomp;
 read grievpf;
enddo;
endsr;
****************************************************
begsr display6;
  *in70 = *on;
  *in71 = *on;
  if rrn6 <= 0;
  *in70 = *off;
   endif;
  write mngcompfot;
  dow *in03 = *off;
  exfmt mngcompctl;
  readc mngcomp;

  Select;
  when mngcompopt = 2;
  dow *in03 = *off;
read grievlf;
 chain dspuid grievlf;
 if %found(grievpf);
 cid1 =   grvid;

 fid1 =   fltid1;
 complaint1 = complaint;
 response1 =  response;
 sta1 =  status1;
endif;
 read usrmas;
 chain dspuid  usrmas;
 if %found(usrmas);
 name1 = username;
 endif;
 read bookingpf;
 chain dspuid bookinglf;
 if %found(bookinglf);
bkid1 = bookingid;
 mctd  = %dec(bkdepdate);
 endif;

 read airmas;
 chain dspuid airmas;
 if %found(airmas);
 airline1 = airname;
endif;
 read fltpf;
 chain dspuid fltlf;
 if %found(fltlf);
 fid1  = fltid;
 orgn1 =  fltorigin;
 destn1 = fltdest;
endif;
 exfmt mngcom;
 enddo;


 when mngcompopt = 5;
 dow *in03 = *off;

 read airmas;
chain dspuid airmas;
 if %found(airmas);
 dcairline = airname;
 endif;

 read grievpf;
 chain dspuid grievlf;
 if %found(grievpf);
 dccid = grvid;
dcsta = status1;
 dccomp = complaint;
 dcres =  response;
 endif;
 read bookingpf;
 chain dspuid bookinglf;
 if %found(bookinglf);
 dcbokid = bookingid;
 dptd  = %dec(bkdepdate);
endif;

 read usrmas;
 chain dspuid usrmas;
 if %found(usrmas);
 dcusrnme = username;
 endif;

 read fltpf;
chain dspuid fltlf;
 if %found(fltlf);
 dcfid  = fltid;
 dcorgn =  fltorigin;
 dcdestn = fltdest;

 endif;

 exfmt dpcom;
  enddo;
 endsl;
 enddo;

 endsr;
*****************************************************
 begsr clear7;
 *in52 =*on;
 clear rrn7;
write mngcompctl;
 *in52 = *off;
 endsr;
*****************************************************
 begsr load7;
 read login;
 chain dspuid login;
 if %found(login);
 cfuy = usrrol;
endif;
 SETLL *LOVAL cnttbl;
 read cnttbl;
 dow not %eof(cnttbl);
 cntkf1 = keyfld1;
 cntkf2 = keyfld2;
 cntvalue = value;
 cntdes   = descrp;
 rrn7 = rrn7 +1 ;
write confset;
 read cnttbl;
 enddo;
 endsr;
****************************************************
 begsr display7;
 *in50 = *on;
 *in51 = *on;
 if rrn7<= 0;
*in50 = *off;
endif;
write confsetfot;


dow *in03 = *off;

exfmt confsetctl;
readc confset;
dow *in06 =*on;
read login;
chain dspuid login;
if %found(login);
anrusr = usrrol;
endif;
exfmt anr;
if *in12 = *on;
leave;
endif;
 if *in05 = *on;
 clear  anrkf1;
 clear  anrkf2;
 clear  anrval;
 clear  anrdes;
 endif;
 enddo;
 if *in06 =*on;
  read cnttbl;
 chain cntkf1 cnttbl;
 if %found(cnttbl);

  keyfld1 = anrkf1;
  keyfld2 = anrkf2;
  value = anrval;
  descrp = anrdes;
  write cntrec;
endif;

 endif;

 Select;
 when cntfsetopt = 2;
 dow *in03= *off;

 exfmt updrec;
if *in06 = *on;
 chain anrkf1 cnttbl;
 if %found(cnttbl);

  keyfld1 = anrkf1;
  keyfld2 = anrkf2;
  value = anrval;
  descrp = anrdes;
  write cntrec;

  ucfkf1 = keyfld1;
  ucfkf2 = keyfld2;
  ucfval = value;
  ucfdes = descrp;

  exfmt updrec;
  endif;
endif;
 if *in12 = *on;
 leave;
 endif;
 enddo;

 when cntfsetopt = 4;
 dow *in03 = *off;
 exsr clear8;
exsr load8;
 exsr display8;
 enddo;

 endsl;
 if *in12 = *on;
 leave;
 endif;
 enddo;
endsr;
***************************************************
 begsr clear8;
 *in23 =*on;
 clear rrn8;
 write dltcfstctl;
 *in23 = *off;
 endsr;
****************************************************
  begsr load8;
  read login;
  chain dspuid login;
  drusr = usrrol;
  SETLL *LOVAL cnttbl;
  read cnttbl;
  dow not %eof(cnttbl);
  dltf1 = keyfld1;
dltf2 = keyfld2;
 dltval = value;
 dltdes = descrp;
 rrn8 = rrn8 +1 ;
 write dltcfset;
 read cnttbl;
 enddo;
 endsr;
***************************************************
begsr display8;
 *in21 = *on;
 *in22 = *on;
 if rrn8<= 0;
 *in21 = *off;
 endif;
 dow *in03 = *off;
 exfmt dltcfstctl;
 readc dltcfset;
  enddo;
  endsr;

******************************
  begsr airmodule;
  dow *in03 = *off;

  read usrmas;
  chain dspuid usrmas;
unme = username;
 if not %found(usrmas)  ;
 message = 'Invalid Username';
 else;
 unme = username;
 endif;
 exfmt userdsh;

 Select;
when udentry = 2;
 read airmas;
 chain dspuid airmas;
 viewpuser = airname;
 dow *in03 = *off;
 read airmas;
 chain dspuid airmas;
 usrairid = airid;
 usrn =  airname;
usrpc =  airpincode;
 usraddr = airaddress;
 usrem =   airemail;
 usrstat = airstatus;
 usrcy =   aircity;
 usrste =  airstate;
 countryvp = country;
 helplinevp = helpline;
 vpdate = %dec(airestdate);
exfmt vewpro;
 if *in12 = *on;
 leave;
 endif;
 if *in06 =*on;
 read airmas;
 chain dspuid airmas;
 uspuser = airname;
 chain usrairid airmas;
if %found(airmas);
 uspairid = usrairid;
 uspname = usrn;
 usppincode = usrpc;
 uspaddress = usraddr;
 uspemail = usrem;
 uspfltsize = usrfltsze;
 uspcity = usrcy;
 uspstate = usrste;
uspcountry =countryvp;
 usphelplin = helplinevp;
 uspdoe = vpdate;

 exfmt upro;
 if *in12 = *on;
 leave;
 endif;
 if *in06 = *on;
leave;
endif;
if *in06 = *on;
chain usrairid airmas;
if %found(airmas);
airid = uspairid;
airname = uspname;
airfleet = uspfltsize;
airpincode = usppincode;
airaddress = uspaddress;
airemail = uspemail;
aircity =uspcity;
airstate = uspstate;
 country = uspcountry;
 helpline = usphelplin;
 airestdate  = %date(uspdoe);
 update airrec;
endif;
endif;
endif;
endif;
enddo;

when udentry = 1;
dow *in03 = *off;
read airmas;
chain dspuid airmas;
 sfuser = airname;
 read fltpf;
 chain dspuid fltpf;
 idscd = fltid;
 orgscd = fltorigin;
 acscd =  airmodel;
 tpscd =  flttkprice;
 tsscd =  flttoseat;
rngscd = fltrange;
 desscd = fltdest;
 fcscd = fltfuelcap;
 dtsf = %dec(fltdeptime);
 exfmt scdflt;
 if *in12 = *on;
 leave;
 endif;
if *in05 = *on;
idscd = fltid;
orgscd = fltorigin;
acscd =  airmodel;
tpscd =  flttkprice;
tsscd =  flttoseat;
rngscd = fltrange;
desscd = fltdest;
fcscd = fltfuelcap;
dtsf = %dec(fltdeptime);
 endif;

 enddo;
  when udentry = 3;
  read airmas;
  chain dspuid airmas;
  uyy =airname;
  exsr clear9;
   exsr load9;
   exsr display9;
  when udentry = 5;
  exsr chngpas;
  other;
  www = 'Invalid Entry';
  endsl;
enddo;
endsr;
*********************************
begsr cp;
dow *in03 = *off;
Select;
when cpold <> dsppas;
m = 'Wrong Password';
when cpnew <> cpcnp;
m = 'Password mismatching';



endsl;
enddo;
endsr;
 begsr clear9;
 *in37 =*on;
 clear rrn9;
 write manafltctl;
 *in37 = *off;
 endsr;
******************
 begsr load9;
 read airmas;
chain dspuid airmas;
 manau = airname;
 read bookingpf;
 chain dspuid bookinglf;
 if %found(bookingpf);
 manaddate = %dec(bkdepdate);
 endif;
 SETLL *LOVAL fltpf;
 read fltpf;
dow not %eof(fltpf);
 manaid =  fltid;
 manaorg = fltorigin;
 manades = fltdest;
 manasta = fltstatus;
 manarange = fltrange;
 manats =  flttoseat;
 manatp =  flttkprice;
 manaac  = airmodel;
manafc =  fltfuelcap;
 manadtime  = %dec(fltdeptime);
 rrn9 = rrn9 +1 ;
 write manaflt;
 read fltpf;

 enddo;
 endsr;
*******************************
 begsr display9;
 *in35 = *on;
 *in36 = *on;
 if rrn9<= 0;
 *in35 = *off;
 endif;
 write manafoot;
 dow *in03 = *off;
 exfmt manafltctl;
readc manaflt;
Select;
when manaopt = 2;
dow *in03 = *off;

upmanaid = fltid;
manaorg =  fltorigin;
manaac = airmodel;
manafc =  fltfuelcap;
manatp = flttkprice;
 manades =  fltdest;
 manarange = fltrange;
 manats = flttoseat;
 exfmt ufmana;
 if *in12 = *on;
 leave;
 endif;
 if *in05 = *on;
upmanaid = fltid;
manaorg =  fltorigin;
manaac = airmodel;
manafc =  fltfuelcap;
manatp = flttkprice;
manades =  fltdest;
manarange = fltrange;
manats = flttoseat;
endif;
if *in06 = *on;
chain upmanaid fltpf;
if %found(fltpf);
fltid = upmanaid;
fltorigin = manaorg;
airmodel = manaac;
fltfuelcap = manafc;
 flttkprice = manatp;
 fltdest = manades;
update fltrec;
 endif;
 endif;

 enddo;
when manaopt = 5;
  dow *in03 = *off;
  dfid =  fltid;
  dforg = fltorigin;
  dfdes = fltdest;
  dfac =  airmodel;
  dffc =  fltfuelcap;
  dftp =  flttkprice;
  dfs =   fltstatus;
  dfr =   fltrange;
  dfts =  flttoseat;
  dfdtime = %dec(fltdeptime);
 exfmt dfmana;
 if *in03 = *on;
 leave;
 endif;
 enddo;
 endsl;
enddo;
 endsr;
*****************************
 begsr userdashboard;
dow *in03 =*off;
exfmt ud;

Select;
when udentry = 1;
dow *in03 = *off;
chain dspuid usrmas;
uvid = userid;
 uvname = username;
 uvnumber = usrmobnum;
 uvemail = usremail;
 uvcity = usrcity;
 uvstate = usrstate;
 uvaddress = usraddress;
 uvpincode = usrpincode;
 uvgender =  usrgen;
uvadhar =  usraadhar;
 exfmt uvp;

 if *in12 =*on;
 leave;
 endif;
 if *in06 = *on;
 chain uvid usrmas;
 if %found(usrmas);
uuid = uvid;
   uuname = uvname;
  uunumber = uvnumber;
 uumail   = uvemail;
 uucity = uvcity;
 uustate = uvstate;
  uuaddress = uvaddress;
  uupincode = uvpincode;
  uugender = uvgender;
  uuaadhar =  uvadhar;
 endif;


 exfmt uvu;
 if *in05 = *off;
  if %found(usrmas);
 uvid = userid;
 uuname =   username;
uunumber =  usrmobnum;
 uumail = usremail;
 uucity = usrcity;
 uustate = usrstate;
 uuaddress =  usraddress;
 uupincode =  usrpincode;
 uugender =  usrgen;
 uuaadhar = usraadhar;
 endif;
endif;

 if *in06 =*on;
 chain uvid usrmas;
 if %found(usrmas);
 userid = uvid;
   username = uuname;
  usrmobnum = uunumber;
 usremail   = uumail;
usrcity = uucity;
usrstate = uustate;
 usraddress = uuaddress;
 usrpincode = uupincode;
 usrgen = uugender;
usraadhar =  uuaadhar;


update usrrec;
endif;
 endif;
 endif;
 enddo;

 when udentry = 2;
 dow *in03 = *off;
if *in12 = *on;
 leave;
 endif;
 exfmt usf;
 if *in05 = *on;
 usforg = *blanks;
 usfdes = *blanks;
 endif;
  exsr clear11;
  exsr load11;
  exsr display11;
exfmt sfrsflctl;
enddo;
when udentry = 3;
exsr clear12;
exsr load12;
exsr display12;
when udentry = 4;
 dow *in03 = *off;
 exfmt ucp;
 if *in12 =*on;
 leave;
 endif;
 enddo;





 other;
 udmess = 'Invalid Entry';

 endsl;
 if *in12 = *on;
leave;
 endif;
 enddo;
 endsr;
*************************
 begsr clear11;
 *in57 =*on;
 clear rrn11;
 write sfrsflctl;
  *in57 = *off;
  endsr;
***********************************
  begsr load11;
   sfrorg =  usforg;
   sfrdes =  usfdes;
  dow not %eof(fltpf);
  sfrfid = fltid;
  sfrprice = flttkprice;
read airmas;
 chain fltid airmas;
 sfrairl = airname;


 rrn11 = rrn11 +1 ;
 write sfr;
 read fltpf;
 enddo;
  endsr;
***********************************
  begsr display11;
  *in55 = *on;
  *in56 = *on;
  if rrn11<= 0;
  *in55 = *off;
  endif;
  write sfrfoot;
dow *in03 = *off;
 exfmt sfrsflctl;
  readc sfr;
  if *in12 = *on;
  leave;
   endif;
   enddo;
   endsr;
***************************
  begsr clear12;
  *in43 =*on;
  clear rrn11;
  write umbsflctl;
  *in43 = *off;
endsr;
********************************
 begsr load12;
 SETLL *LOVAL bookingpf;
 read bookingpf;
 read fltpf;
 dow not %eof(bookingpf);
 umbbid = bookingid;
 umbstatus = bookingsta;
read fltpf;
 chain umbbid fltpf;
 umborg = fltorigin;
 umbdes = fltdest;

 rrn12 = rrn12 +1 ;
 write umb;
 read bookingpf;
 enddo;
endsr;
******************************
 begsr display12;
 *in41 = *on;
 *in42 = *on;
 if rrn12<= 0;
 *in41 = *off;
 endif;
 write umbfot;
dow *in03 = *off;
 exfmt umbsflctl;
 readc umb;
 Select;
 when umbopt =5;
 exsr clear13;
 exsr load13;
 exsr display13;
endsl;

 if *in12 = *on;
 leave;
 endif;
 enddo;
 endsr;
**************************************
   begsr clear13;
   *in47 =*on;
   clear rrn13;
   write vtsflctl;
   *in47 = *off;
   endsr;
**************************************
   begsr load13;
   SETLL *LOVAL psngrpf;
   read bookingpf;
chain umbbid bookingpf;
 bidvt1 = bookingid;
 read fltpf;
 chain umbbid fltpf;
vtorg1 = fltorigin;
 vtdes1 = fltdest;
 read psngrpf;
 read tktpf;
 dow not %eof(psngrpf);
  vtpid = psgid;
  vtpname = psgname;
  read tktpf;
  chain umbbid tktpf;
  vtsta = tktstatus;
  vttid  = tktid;
  rrn13 = rrn13 +1 ;
  write vt;
  read psngrpf;
enddo;
 endsr;
**********************
 begsr display13;
 *in45 = *on;
 *in46 = *on;
 if rrn12<= 0;
 *in45 = *off;
 endif;
  write vtfoot;

  dow *in03 = *off;
  readc vt;
  exfmt vtsflctl;
  Select;
  when vtopt = 2;
  dow *in03 = *off;
  read bookingpf;
chain bidvt1 bookingpf;
 ubdbid = bookingid;


 read tktpf;
 chain vttid tktpf;
 ubdtid = tktid;
 ubdsn =tktstnum;
read fltpf;
 chain bidvt1 fltpf;
 ubdfid = fltid;
 ubdorg = fltorigin;
 ubddes = fltdest;
 ubdtp = flttkprice;
 ubdstatus = fltstatus;

 read psngrpf;
chain vtpid psngrpf;
ubdpid = psgid;
ubdpname = psgname;
exfmt upbook;
if *in12 = *off;
 leave;
 endif;
 enddo;
 endsl;

  if *in12 = *on;
  leave;
  endif;
  enddo;
 endsr;
   begsr clear20;
   *in47 =*on;
   clear rrn13;
   write vbopsflctl;
   *in47 = *off;
   endsr;
*******************************
   begsr load20;

  SETLL *LOVAL usrmas;
  read usrmas;
  chain dspuid usrmas;
  vbopuid = usrid;
   vbopuname = usrpas;
  read fltpf;
  dow not %eof(fltpf);
read fltpf;

 vfid = fltid;
 vs =  fltstatus;
 vorg = fltorigin;
 vdes = fltdest;
 read airmas;
 chain dspuid airmas;
 val =airname;
rrn20 = rrn20 +1 ;
 write vbop;
 read fltpf;
 enddo;
 endsr;
****************************

 begsr display20;
 *in46 = *on;
*in47 = *on;
 if rrn20<= 0;
 *in46 = *off;
 endif;
 write vbopfot;
 dow *in03 = *off;
 read usrmas;
 chain dspuid usrmas;
 vbopu = username;
exfmt vbopsflctl;
readc vbop;
if *in12 = *on;
leave;
endif;
enddo;
endsr;
*****************************************
 begsr changepassword;
 dow *in03 = *off;
 if *in12=*on;
 leave;
 endif;
 exfmt cpadmin;
 if dsppas <> cpold or cpold = *blanks;
 m = 'invalid old password';
 else;
if  %len(%trim(cpnew)) >= 8;
 for i=1 to %len(%trim(cpnew));

  if %scan(%subst(cpnew:i:1) : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') >0;
  hasupper=1;
  endif;
  if %scan(%subst(cpnew:i:1) : 'abcdefghijklmnopqrstuvwxyz') >0;
  haslower=1;
  endif;
   if %scan(%subst(cpnew:i:1) : '0123456789') >0;
 hasdigit=1;
 endif;
 if %scan(%subst(cpnew:i:1) : '!@#$%^&*') >0;
 hasSpecial=1;
 endif;
 endfor;
 endif;
 Select;
when %len(%trim(cpnew)) < 8;
   m = 'Password must be at least 8 characters';

 when hasupper=0 or haslower=0 or hasdigit=0 or hasSpecial=0;
   m='Invalid Password';

 when cpnew <> cpcnp;
  m = 'Invalid Password';
other;
 clear m;
  if *in06=*on;
  usrpas = cpnew;
  update lgnrec;
  m='Password changed successfully';
   clear cpnew;
   clear cpcnp;
  clear cpold;


 endif;
  if *in05 = *on;
  clear cpnew;
  clear cpcnp;
  clear cpold;
  clear m;
    endif;


   endsl;
 endif;
 enddo;
 endsr;
******************************
 begsr chngpas;
dow *in03 = *off;
 if *in12=*on;
 leave;
 endif;
 exfmt cpair;
 if dsppas <> op or op = *blanks;
 d = 'invalid old password';
 else;
 if  %len(%trim(np)) >= 8;
for i=1 to %len(%trim(np));

  if %scan(%subst(np:i:1) : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') >0;
  hasupper=1;
  endif;
  if %scan(%subst(np:i:1) : 'abcdefghijklmnopqrstuvwxyz') >0;
  haslower=1;
  endif;
  if %scan(%subst(np:i:1) : '0123456789') >0;
hasdigit=1;
 endif;
 if %scan(%subst(np:i:1) : '!@#$%^&*') >0;
 hasSpecial=1;
 endif;
 endfor;
 endif;
 Select;
when %len(%trim(np)) < 8;
   d = 'Password must be at least 8 characters';

 when hasupper=0 or haslower=0 or hasdigit=0 or hasSpecial=0;
   d='Invalid Password';

 when np <> cnp;
    d = 'Invalid Password';
other;
 clear d;
  if *in06=*on;
  usrpas = np;
  update lgnrec;
  d='Password changed successfully';
   clear np;

    update lgnrec;
    d='Password changed successfully';
     clear np;
     clear cnp;
     clear op;
      endif;
     if *in05 = *on;
     clear np;
clear cnp;
 clear op;
 clear d;
endif;
  endsl;
  endif;
  enddo;
endsr;
