%Event manually produced from EventLog.CSV 
%EStrt=time difference between initStimulus and initLogger
%Interval: sec
%x = X(?,:)
function [Spks,Event]=deuteronMake(Out,EStrt,Interval,x)
verbose=0;

dispRange=.2;%sec
xRange=312;
step=32;


Sampl=31250;
Interval=Interval*Sampl;
EStrt=floor(EStrt*Sampl);
dispRange=ceil(dispRange*Sampl);

len=size(Out,1);
endP=0;
startP=1e23;

for j=1:len
  if Out{j,3}(end) > endP
    endP=Out{j,3}(end);
  end
  if Out{j,3}(1)<startP  
    startP=Out{j,3}(1);
  end
end
startP=EStrt-floor((EStrt-startP)/Interval)*Interval;
%loop=double(floor((endP-EStrt)/Interval));
startLine=floor((EStrt-startP)/Interval);
loop=double(floor((endP-startP)/Interval));


Event=1:loop;
Event=Event*Interval+double(startP);


Spks=zeros(len,dispRange*2+1);

if verbose
c=1;
for i=[101:110]
%for i=1:loop
  for j=[1 5 9 16]
    subplot(10,4,c)
    c=c+1;
    t=Event(i);
    plot(x(j,t-xRange:t+xRange));
    xlim([0 312*2]);
    set(gca,'xtick',[0 312 312*2],'xticklabel',[-100 0 100]);
  end
end
end

%figure;
%hold on;

for i=1:loop
  for j=1:len
    t=double(Out{j,3})-Event(i);
    tNum=t(find(t>-dispRange & t<dispRange))+dispRange;
    Spks(j,tNum)=Spks(j,tNum)+1;
     
    spk=find(t>-xRange & t<xRange);
%    if length(spk)>1
      %      plot(Out{j,1}(1,(spk(1)-1)*step+1:spk(1)*step));
%      t=Out{j,3}(spk(1));
      %plot(x(t-xRange:t+xRange));
%    end
  end
%  plot(x(Event(i)-xRange:Event(i)+xRange));
end

return;
