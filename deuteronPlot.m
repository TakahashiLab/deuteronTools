% 30-20180222-01: Out1(2,3),Out2(2,6,7(weak inhibition)),Out3(1,2,4), Out4(6,7,8)
% 53-20180222-01: 38-53: Out3(8,10); 88-104:Out2(11),Out3(1),Out4(15)
%
% 53-20180221-01: Out4(9)
%
%Event manually produced from EventLog.CSV 
%EStrt=time difference between initStimulus and initLogger
%Interval: sec
%Num:cell # for display
function [Spks,Event]=deuteronPlot(Out,EStrt,Interval,Num)
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
%Event=Event*Interval+EStrt;
Event=Event*Interval+double(startP);

Spks=zeros(loop,dispRange*2+1);

for i=1:loop
  t=double(Out{Num,3})-Event(i);
  tNum=t(find(t>-dispRange & t<dispRange))+dispRange;
  Spks(i,tNum)=Spks(i,tNum)+1;
end


t=find(Spks);
[x,y]=ind2sub(size(Spks),t);
plot(y,x,'.');

hold on;
plot([0 size(Spks,2)],[startLine startLine],'r');
plot([3125*2 3125*2],[0 size(Spks,1)],'k');
plot([3125*3 3125*3],[0 size(Spks,1)],'k');
return;
