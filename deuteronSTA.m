%
%spike triggered averaging for deuteron
%
function Xs=deuteronSTA(Out,num,X)
dispRange=100;

loop=size(Out{num,3},2);


=max(Out{num,1})
Xs=[];

for i=1:loop
  tr=Out{num,3}(i);%trigger
  x=X(num,tr-dispRange:tr+dispRange);
  subplot(2,1,1);
  hold on;
  plot(x,'k');
  Xs=[Xs;x];
end

subplot(2,1,2);
plot(mean(Xs));
return;