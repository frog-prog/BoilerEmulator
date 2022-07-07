Uses GraphAbc;
procedure validatedRewrite(f:file of real;v:real);
var valid:boolean;
begin
valid:=false;
  while valid=false do begin
    try begin
      Rewrite(f);
      write(f,v);
      close(f);
      valid:=true;
      end;
    except
    valid:=false;
    end;
  end;
end;
function validatedRead(f:file of real):real;
var valid:boolean; v:real;
begin
valid:=false;
  while valid=false do begin
    try begin
      Reset(f);
      read(f,v);
      close(f);
      valid:=true;
      validatedRead:=v;
      end;
    except
    valid:=false;
    end;
  end;
end;
function validatedInput(message:string):real;
var valid:boolean; a:real;
begin
  valid:=false;
  while valid=false do begin
    writeln(message);
    try
      readln(a);
      validatedInput:=a;
      valid:=true;
      except
        valid:=false;
     end; 
  end;
end;
var tin,prevtin,tmin,tmax,t1,t2,t3:real;
start, time, prevtime:longint;
temperature, gas:file of real;
Begin
  assign(gas,'gasPosition.bnr');
  assign(temperature,'insideTemperature.bnr');
  validatedRewrite(gas,0);
  tmin:=validatedInput('Введите минимальную температуру');
  tmax:=validatedInput('Введите допустимую температуру');
  t1:=validatedInput('Введите задержку открытия клапана подачи газа в миллисекундах');
  if t1<100 then
    t1:=100;
  t2:=validatedInput('Введите задержку включения запального устройства в миллисекундах');
  if t2<100 then
    t2:=100;
  t3:=validatedInput('Введите задержку выключения вентилятора в миллисекундах');
  if t3<100 then
    t3:=100;
  setwindowheight(200);
  setwindowwidth(500);
  ClearWindow();
  setfontsize(10);
  TextOut(20,65,'Температура в котле');
  moveto(20,85);
  lineto(260,85);
  TextOut(20,90,tmin);
  TextOut(20,105,'Температура минимальная');
  moveto(20,120);
  lineto(260,120);
  TextOut(20,125,tmax);
  TextOut(20,140,'Температура допустимая');
  moveto(20,155);
  lineto(260,155);
  start:=0;
  while true do begin
    prevtin:=tin;
    tin:=validatedRead(temperature);
    if prevtin>tin then
      setfontcolor(clBlue);
    if prevtin<tin then
      setfontcolor(clRed);
    if prevtin=tin then
      setfontcolor(clGreen);
    if prevtin<>tin then
      TextOut(20,50,tin);
    
      if tin<tmin then begin
       if start=0 then
       start:=Milliseconds;
       time:=Milliseconds;
      if time-start>=t1 then begin
       setfontcolor(clRed);
       TextOut(270,50,'Газ подан');
      end;
      if time-start>=t2 then begin
       setfontcolor(clRed);
       TextOut(270,65,'Газ подожжен');
       validatedRewrite(gas,1);
       start:=0;
      end;
      end;
      
      if tin>=tmax then begin
        if start=0 then
        start:=Milliseconds;
        time:=Milliseconds;
        setfontcolor(clRed);
        TextOut(270,50,'Клапан закрыт');
      if time-start>=t3 then begin
         setfontcolor(clRed);
         TextOut(270,65,'Вентилятор выключен');
         validatedRewrite(gas,0);
         start:=0;
      end;
      end;
   end;
end.