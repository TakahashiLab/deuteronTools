%flash off:22-27
%flash on:28-33
%
%20180221-01: 12-24,EStrt=0, tet1 weak, tet2 weak, tet3 noise?,tet4 very weak
%
%20180222-01:25-37,EStrt=0, tet2,3,4 weak
%            :38-53,EStrt=69.6397, tet2 long duration,  tet3,
%            start&stop, tet4,weak
%            :54-70, EStrt=92.1698, tet3,4 very weak
%            :71-87, EStrt=72.5483, tet4, strong
%            :88-104, EStrt=68.4035, tet2,3 strong?
%
%30-20180222-01:
%              :6-21, EStrt=69.6702, tet1-4, ,big clear,stimulus-locked spikes
%               only ICA can capture such spikes
function [Out,X,oX,sX]=deuteron(basename,pre,initP,endP,Th,animal,sX,activeNums)


dataOff=1;
sampl=31250;%Hz

if strcmp(animal,'fish')
step=30;%32, 80
  elseif strcmp(animal,'bird')
    step=40;
end

if nargin>6
  dataOff=0;
end


if dataOff
X=deuteronRaw(basename,pre,initP,endP);
%    X=filterAmp(X,7,sampl);%notch filter 50Hz
oX=X;
if 0
Out=[];
sX=[];
return;
end
X=filterAmp(X,0,sampl,0);
X=X-median(X);
sX=int16(X);
  
if nargin<=7
    activeNums=1:16;
end
else
    if nargin<=7
        activeNums=1:16;
    end
  oX=[];
  X=[];
end



%mapping=[8 10 12 13 1 3 4 5 7 14 16 2 6 9 11 15 ];
%mapping=[1 3 4 5 7 8 9 10 12 13 14 16 2 6 11 15];%for 2017
%X=X(mapping,:);
%%%%%%%%%%%%%%%%%%sampl=1/31.25*10^6;%Hz mistake?


%sampl=sampl/2;% sampling rate error?
Th
tet=4;
%tet=16;%silicon probe
%median referencing

%Th=25;%hombemode=40, tsusumu=60, bird2018=20

%stdV=-ones(4,1)*Th;%250;80
stdV=ones(tet,1)*Th;%250;80

%stdV=std(X,[],2)*5;

Th=250;%400;1000;150
stdV2=ones(tet,1)*Th;%250;80
%Th=50;

Out=[];


%save test.mat sX stdV step
%return;


for k=1:tet
    %for k=1
	an=1+(k-1)*tet:k*tet;

  an=intersect(activeNums,an);

  
  if ~isempty(an)
    ssX=sX(an,:);

     %preProcess for large outliers
 %    usedT=[];
 %    for i=1:size(ssX,1)
 %      usedT=[usedT find(abs(ssX(i,:))>stdV2(i))];
 %    end
 %    usedT=unique(usedT);
 %    length(usedT)
     

     if strcmp(animal,'fish')
           [tmp,tmps]=extractSpDodeca4Fish(abs(ssX),stdV,step,ssX);
     elseif strcmp(animal,'bird')
         [tmp,tmps]=extractSpDodeca4Bird(abs(ssX),stdV,step,ssX);
     end
     %[~,~,usedT]=extractSpDueteron(ssX,step,stdV2);
    %[tmp,tmps]=extractSpDueteron(ssX,step,stdV,usedT);
    %[tmp,tmps]=extractSpDueteron(ssX,step,stdV);
    tmps=double(tmps);
    
    d=[];
    for i=1:size(tmps,2)
      if i*step>size(tmp,2)
	break;
      end
      t=abs(tmp(:,1+(i-1)*step:i*step)) > Th;
      if sum(t(:))
	d=[d i];
      end
    end
    
    ind=setdiff(1:size(tmps,2),d);
    %    save test.mat d  ind tmp step tmps   
    tmp=getSpikesS(tmp,step,ind);
        %tmp=getSpikesD(tmp,step,ind);
    tmps=tmps(ind);
    
    Out{k,1}=tmp;
    Out{k,3}=double(tmps);
  end
  
end

return;
