%
%event triggered averaging for deuteron
%
function Xs=deuteronETA(Event,X,num)
dispRange=200;

loop=size(Event,2);

figure;
hold on;
Xs=[];
for i=1:loop-1
  tr=Event(i);
  x=X(num,tr-dispRange:tr+dispRange);
  plot(x,'k');
  Xs=[Xs;x];
end


return;