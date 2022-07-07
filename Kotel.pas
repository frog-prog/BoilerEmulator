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
      on e:Exception do begin 
      writeln(e.Message);
      writeln(e.Data);
      writeln(e.InnerException);
      end;
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
var gasoned,form,
k,d,m,s,v,kpd,
prevte,tepem,
plot,tin,w,tk,
h,t0,prevtin,
te,pe,l,Qs,
r,p,proc:real;
valid:boolean;
start, time, prevtime:longint;
temperature, gas, inTemp, pressure:file of real;
Begin
  while valid=false do begin
    form:=validatedInput('Бак круглый(введите 1) или квадратный(введите 2)?');
    if (form=1) or (form=2) then valid:=true;
  end;
  if form=1 then begin 
  h:=validatedInput('Введите высоту в метрах');
  r:=validatedInput('Введите радиус в метрах');
  s:=2*pi*r*h+pi*r*r;
  v:=pi*r*r*h;
  end
  else begin
    h:=validatedInput('Введите высоту в метрах');
    w:=validatedInput('Введите ширину в метрах');
    l:=validatedInput('Введите длину в метрах');
    s:=l*h*2+w*h*2+w*l;
    v:=l*w*h;
 end;
 k:=validatedInput('Введите коэффициент теплопередачи материала бака');
 proc:=validatedInput('Введите процент заполнения бака');
 tepem:=validatedInput('Введите теплоемкость вещества в баке');
 plot:=validatedInput('Введите плотность вещества в баке');
 kpd:=validatedInput('Введите КПД котла в процентах');
 d:=validatedInput('Введите диаметр сечения газовой трубы в метрах');
 p:=validatedInput('Введите давление газа в паскалях');
 t0:=validatedInput('Введите начальную температуру котла');
 tk:=validatedInput('Введите коэффициент ускорения времени');
 m:=v*(proc/100)*plot;
 if form=1 then begin
      writeln('У вас круглый бак с радиусом ',r,'м. и высотой ',h,'м.');
      writeln(' С коэффициентом теплопроводности стенок ',k,', площадью поверхности площадью ',s);
 end
 else begin
      writeln('У вас квадратный бак с шириной ',w,'м и длиной ',l,'м. и высотой ',h,'м.');
      writeln('С коэффициентом теплопроводности стенок ',k,', и площадью ',s);
 end;
 assign(temperature,'externalTemperature.bnr');
 assign(pressure,'externalPressure.bnr');
 assign(gas,'gasPosition.bnr');
 assign(inTemp,'insideTemperature.bnr');
 gasoned:=0;
 start:=Milliseconds;
 prevtime:=Milliseconds-start;
 time:=Milliseconds-start;
 prevtin:=t0;
 tin:=t0;
 Rewrite(inTemp);
 write(inTemp,t0);
 close(inTemp);
 while true do begin
  prevte:=te;
  te:=validatedRead(temperature);
  gasoned:=validatedRead(gas);
  pe:=validatedRead(pressure);
  time:=Milliseconds-start;
  if (prevte<>te) or (prevtin<>tin) then begin
    Qs:=k*s*((tin+273.5)-(te+273.5));
  end;
  if time-prevtime>=1000/tk then begin
    prevtime:=time;
    writeln('');
    writeln('Газ: ',gasoned);
    writeln('Скорость падения температуры: ',Qs);
    writeln('Скорость роста: ',((pi*d*d)/4)*sqrt(7*((p+pe*133.32)/(16*(p+pe*133.32)/(8.34*(te+273.5))))*(1-exp(ln(((pe*133.32)/(p+pe*133.32)))*0.285)))*33500000*kpd/100);
    writeln('Температура внутри: ',tin,' gr.C');
    writeln('Время: ',time,' ms');
    writeln('Температура снаружи: ',te,' gr.C');
    writeln('Давление снаружи: ',pe*133.32/1000,' KPa');
    if gasoned=1 then begin
      prevtin:=tin;
      tin:=(m*tepem*tin-Qs+((pi*d*d)/4)*sqrt(7*((p+pe*133.32)/(16*(p+pe*133.32)/(8.34*(te+273.5))))*(1-exp(ln(((pe*133.32)/(p+pe*133.32)))*0.285)))*33500000*kpd/100)/tepem/m;
      validatedRewrite(inTemp,tin);
      end
    else begin
      prevtin:=tin;
      tin:=(m*tepem*tin-Qs)/tepem/m;
      validatedRewrite(inTemp,tin);
      end;
  end;
 end;
  
 
end.