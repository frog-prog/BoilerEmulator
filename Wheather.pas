var t,p:array[0..24] of real;
k:real;i:integer;
success:boolean;
f,f1:file of real;
Begin
  ///взяты данные о температуре воздуха за сутки в Самаре от 12.07.2021
  t[0]:=24.3;p[0]:=751;
  t[1]:=23.6;p[1]:=751;
  t[2]:=23.6;p[2]:=752;
  t[3]:=24.2;p[3]:=752;
  t[4]:=25.4;p[4]:=752;
  t[5]:=26.5;p[5]:=752;
  t[6]:=27.9;p[6]:=752;
  t[7]:=29.6;p[7]:=752;
  t[8]:=30.8;p[8]:=752;
  t[9]:=32.1;p[9]:=751;
  t[10]:=31.6;p[10]:=751;
  t[11]:=31.6;p[11]:=751;
  t[12]:=33.1;p[12]:=751;
  t[13]:=31.5;p[13]:=751;
  t[14]:=27.2;p[14]:=750;
  t[15]:=27.5;p[15]:=750;
  t[16]:=23.3;p[16]:=750;
  t[17]:=23;p[17]:=750;
  t[18]:=23.1;p[18]:=750;
  t[19]:=22.6;p[19]:=751;
  t[20]:=21.9;p[20]:=751;
  t[21]:=21;p[21]:=751;
  t[22]:=20.6;p[22]:=751;
  t[23]:=19.6;p[23]:=751;
  t[24]:=19;p[24]:=751;
  writeln('Введите коэффициент ускорения времени');
  readln(k);
  assign(f,'externalTemperature.bnr');
  assign(f1,'externalPressure.bnr');
  writeln(t);
  writeln('начали');
  i:=0;
  While true do begin
    Rewrite(f);
    Rewrite(f1);
    writeln('запись!');
    success:=false;
    while success=false do begin
      try
        write(f,t[i]);
        write(f1,p[i]);
        close(f);
        close(f1);
        success:=true;
      except
      end;
    end;
    if i=24 then
       i:=0
    else
       inc(i);
    sleep(Round(3600000/k));
  end;
end.