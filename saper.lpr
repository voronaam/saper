{$R-}
program saper;
uses graph,crt,dos;
const {field            ='.';}
     bomb_marked      ='b';
     isbomb           ='#';
     bomb_marked_false='!';
     menu:array[1..5] of string = ('Beginer   mode','Normal    mode','Advanced  mode','Nightmare mode','Custom    mode');
     xst:array[1..4] of byte = (8,14,20,20);
     yst:array[1..4] of byte = (8,14,20,30);
     nbst:array[1..4] of byte = (8,28,66,120);
var pole,maska:array[1..100,1..100] of byte;
var nameu:string;
var x,y,zto:byte;
var ch,key_menu,key_pause,key_open,key_flag,field,nulf:char;
var n,i,j,gr1,gr2:integer;
var total_time,time_of_begining,time_pause:word;
var if_begin,if_end,win:boolean;
var max_X,max_Y,NBomb,regim:byte;

procedure m_menu;
begin
regim:=1;
ch:=' ';
repeat
textbackground(black);
clrscr;
for i:=1 to 5 do begin if regim=i then begin
textcolor(black);textbackground(white); end else
begin textcolor(white);textbackground(black);end;
gotoxy(35,8+i);writeln(menu[i]);end;
ch:=readkey;
if ch=#80 then if regim+1<=6 then inc(regim) else regim:=1;
if ch=#72 then if regim-1>0 then dec(regim) else regim:=5;
until ch=#13;
if regim= 5 then begin
textcolor(white);textbackground(black);
write('Enter horizontal size ');readln(max_y);
write('Enter vertical size ');readln(max_x);
write('Enter number of mines ');readln(NBomb);end else begin
max_x:=xst[regim];max_y:=yst[regim];nbomb:=nbst[regim];end;
ch:=key_menu;
end;

procedure read_user_keys;
var fl:file of char;
var cr:char;
var number_of:integer;
begin
assign(fl,'keys.ini');reset(fl);
Writeln('Press F# for default settings nomber #');writeln;
seek(fl,60);
for i:=1 to 10 do begin
write('F',i,' - ');
for j:=1 to 10 do begin
read(fl,cr);write(cr);
end;
writeln;
end;
ch:=readkey;ch:=readkey;
number_of:=ord(ch);
if (number_of>58) and (number_of<69) then
begin
seek(fl,(number_of-59)*6);
read(fl,cr);key_flag:=cr;read(fl,cr);key_open:=cr;
read(fl,cr);key_menu:=cr;read(fl,cr);key_pause:=cr;
read(fl,cr);field:=cr;read(fl,cr);nulf:=cr;
end else
begin
write('Press KEY, meaning FLAG ');ch:=readkey;
key_flag:=ch;writeln;
write('Press KEY, meaning OPEN FIELD ');ch:=readkey;key_open:=ch;writeln;
write('Press KEY, meaning QUIT MENU ');ch:=readkey;key_menu:=ch;writeln;
write('Press KEY, meaning PAUSE ');ch:=readkey;key_pause:=ch;writeln;writeln;
write('Press CHAR, meaning FIELD ');ch:=readkey;field:=ch;writeln(ch);
write('Press CHAR, meaning 0 on the field ');ch:=readkey;nulf:=ch;writeln(ch);
end;
close(fl);
ch:=' ';
end;

procedure simb_key(dfg:char);
begin
 if dfg=#13 then write('Enter') else
 if dfg=' ' then write('Space') else
 if dfg=#9 then write('Tab') else write(dfg);
end;


procedure look;
begin
 clrscr;
 writeln('Mines -- ',n);
 write('  ');
 for i:=1 to max_y do write((i mod 10):2);
 writeln;
 for i:=1 to max_x do begin
  write(i:2,' ');
  for j:=1 to max_y do begin
   if maska[i,j]=1 then write(field,' ');
   if maska[i,j]=2 then write(bomb_marked,' ');
   if maska[i,j]=0 then if pole[i,j]=0 then write(nulf+' ') else write(pole[i,j],' ');
  end;
{  write('  ');for j:=1 to max_y do write(pole[i,j],' ');
  write('  ');for j:=1 to max_y do write(maska[i,j],' ');}
  writeln;
 end;
 if regim<> 5 then begin
 writeln;write(nameu,'  ');
 val(nameu,i,gr1);
 write((i div 60):2,' : ',(i mod 60):2);
 end;
 writeln;
 if (regim<>4)and(regim<>3) then writeln;   {<--- why?}
 write('Key Mark Bomb - ');simb_key(key_flag);
 write('  |  Key Open Field - ');simb_key(key_open);
 write('  |  Key Menu - ');simb_key(key_menu);

end;



procedure count;
var n1:byte;
begin
 for i:=1 to max_x do for j:=1 to max_y do
 begin
  n1:=0;
  if pole[i,j]<>9 then
  begin
   if (i+1<=max_x) and (j+1<=max_y) then if pole[i+1,j+1]=9 then inc(n1);
   if (j+1<=max_y) then if (pole[i,j+1]=9) then inc(n1);
   if (j+1<=max_y) and (i-1>0) then if pole[i-1,j+1]=9 then inc(n1);
   if (i+1<=max_x) then if (pole[i+1,j]=9) then inc(n1);
   if (i-1>0) then if pole[i-1,j]=9 then inc(n1);
   if (i+1<=max_x) and (j-1>0) then if pole[i+1,j-1]=9 then inc(n1);
   if (j-1>0) then if (pole[i,j-1]=9) then inc(n1);
   if (i-1>0) and (j-1>0) then if pole[i-1,j-1]=9 then inc(n1);
   pole[i,j]:=n1;
  end;
 end;
end;

procedure init;
begin
 randomize;
 if_begin:=false;
 if_end:=false;
 win:=false;
 for i:=1 to max_x do begin for j:=1 to max_y do begin
  pole[i,j]:=0; maska[i,j]:=1; end; end;
 n:=0;
 repeat
  x:=1+random(max_x);
  y:=1+random(max_y);
  if pole[x,y]=0 then begin pole[x,y]:=9; n:=n+1; end;
 until n=Nbomb;
 count;
  x:=1+random(max_x);
  y:=1+random(max_y);
  look;
end;

function timing:word;
var h,m,s,d:word;
var timin:integer;
begin
gettime(h,m,s,d);
timin:=3600*abs(h)+60*abs(m)+abs(s);
timing:=timin;
end;


procedure showtime;
var timingm,timings:word;
begin
total_time:=timing-time_pause-time_of_begining;
timingm:=(total_time) div 60;
timings:=(total_time) mod 60;
gotoxy(15,1);write('Time:  ',Timingm:3,':',Timings:2);
end;

procedure pausen(fgh:word);
begin
clrscr;
repeat
until keypressed;
ch:=readkey;ch:=#220;
look;
time_pause:=time_pause+timing-fgh;
end;




procedure readk(ff:boolean);
var vyxod:boolean;
begin
vyxod:=false;
repeat
{look;}
 textcolor(8);textbackground(7);gotoxy(y*2+2,x+2);
   if maska[x,y]=1 then write(field);
   if maska[x,y]=2 then write(bomb_marked);
   if maska[x,y]=0 then if pole[x,y]=0 then write(nulf) else write(pole[x,y]);
   gotoxy(y*2+2,x+2);
textcolor(white);textbackground(0);
if ff then repeat showtime until keypressed else begin
 gotoxy(15,1);write('time 0');end;
 ch:=readkey;
 gotoxy(y*2+2,x+2);
 if maska[x,y]=1 then write(field);
 if maska[x,y]=2 then write(bomb_marked);
 if maska[x,y]=0 then if pole[x,y]=0 then write(nulf) else write(pole[x,y]);
 if ch=#77 then if y+1<=max_y then inc(y);
 if ch=#75 then if y-1>0 then dec(y);
 if ch=#80 then if x+1<=max_x then inc(x);
 if ch=#72 then if x-1>0 then dec(x);
 if ch=key_flag then begin
 if not(if_begin) then time_of_begining:=timing;
 zto:=2;vyxod:=true;if_begin:=true;end;
 if ch=#27 then begin vyxod:=true;if_end:=true; end;
 if ch=key_menu then begin vyxod:=true;if_end:=true;m_menu;end;
 if ch=key_open then begin
 if not(if_begin) then time_of_begining:=timing;
 zto:=1;vyxod:=true;if_begin:=true;end;
 if ch=key_pause then pausen(timing);
until vyxod;
{gotoxy(1,max_x+3); for i:=1 to 2 do writeln('   ');
gotoxy(1,max_x+3); readln(x);readln(y);readln(zto);}
end;

procedure queek_open(x1,y1:byte);
begin
 maska[x1,y1]:=0;
 gotoxy(y1*2+2,x1+2);
 if pole[x1,y1]=0 then write(nulf) else write(pole[x1,y1]);
 if pole[x1,y1]=0 then
 begin
  if (x1+1<=max_x) and (y1+1<=max_y) and (maska[x1+1,y1+1]=1) then queek_open(x1+1,y1+1);
  if (y1+1<=max_y) and (maska[x1,y1+1]=1) then queek_open(x1,y1+1);
  if (x1-1>0) and (y1+1<=max_y) and (maska[x1-1,y1+1]=1) then queek_open(x1-1,y1+1);
  if (x1+1<=max_x) and (maska[x1+1,y1]=1) then queek_open(x1+1,y1);
  if (x1-1>0) and (maska[x1-1,y1]=1) then queek_open(x1-1,y1);
  if (x1+1<=max_x) and (y1-1>0) and (maska[x1+1,y1-1]=1) then queek_open(x1+1,y1-1);
  if (y1-1>0) and (maska[x1,y1-1]=1) then queek_open(x1,y1-1);
  if (x1-1>0) and (y1-1>0) and (maska[x1-1,y1-1]=1) then queek_open(x1-1,y1-1);
 end;
end;

function check_this:boolean;
var che:boolean;
begin
che:=true;
for i:=1 to max_x do begin
for j:=1 to max_y do begin
if (pole[i,j]=9) and (maska[i,j]<>2) then che:=false;
end;end;
check_this:=che;
end;



procedure pointing;
begin
 if maska[x,y]=1 then
 begin
  if (zto=2) {and (n>0)} then begin  maska[x,y]:=2;dec(n);
  gotoxy(y*2+2,x+2);write(bomb_marked);gotoxy(10,1);write(n,'  ');end;
  if zto=1 then
  begin
   if pole[x,y]=9 then if_end:=true else queek_open(x,y);
  end;
 end
 else if (maska[x,y]=2) and (zto=2) then begin maska[x,y]:=1;inc(n);
 gotoxy(y*2+2,x+2);write(field);gotoxy(10,1);write(n,' ');end;
 if (zto=2) and (n=0) and (check_this) then begin if_end:=true;win:=true;end;

end;


begin
ch:=' ';
clrscr;
read_user_keys;
m_menu;
repeat
init;
repeat
{ look;}
 readk(if_begin);
 pointing;
until if_end;
 clrscr;
if win then write('Mines -- 0    ') else write('Mines -- ',n,'  ');
showtime;

 gotoxy(0,2);writeln;
 write('  ');
 for i:=1 to max_y do write((i mod 10):2);
 writeln;
 for i:=1 to max_x do begin
  write(i:2,' ');
  for j:=1 to max_y do begin
   if (maska[i,j]=2) and (pole[i,j]=9) then write(bomb_marked,' ');
   if (maska[i,j]<>2) and (pole[i,j]<>9) then if pole[i,j]=0 then write(nulf,' ') else write(pole[i,j],' ');
   if (maska[i,j]<>2) and (pole[i,j]=9) then write(isbomb,' ');
   if (maska[i,j]=2) and (pole[i,j]<>9) then write(bomb_marked_false,' ');
  end;
  writeln;
 end;
 if win then
 begin
  writeln('WW II NN EE RR !! !! !! UURRAA');
  if regim<>5 then
  begin
   val(nameu,i,gr2);
{   writeln(i,' ',total_time);}
   if i>total_time then begin
   writeln('Yoy are new RECORDSMEN !!!');
   str(total_time,nameu);
   write('Enter your name : ');readln(nameu);
   end;
  end;
 end;
if (ch<>#27) and (ch<>key_menu) then ch:=readkey;
until ch=#27;
end.

