% for bird 32ch
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
function [Out,X,oX]=duetron(basename,pre,initP,endP)
Out=[];
[path,name,ext]=fileparts(basename);

dataFolder=fullfile(path,name);
d=dir(fullfile(path,name));
loop=size(d,1);

Suffix='DAT';
SuffixLen=size(Suffix,2)-1;
PreLen=size(pre,2);

if nargin==2
%find the last file name
endP=0;
initP=-1;


while 1
  fn=sprintf('%s%04d.DAT',pre,endP);
  
  for i=1:loop
    if strcmp(d(i).name,fn)
      if initP==-1
	initP=endP;
      end
      break;
    end
  end
  
  if i==loop & initP~=-1
    endP=endP-1;
    break;
  end
  
  
  endP=endP+1;
end

%initP=71;%22
%endP=87;
end

%saving data
X=[];
errorFile=0;
for i=initP:endP
  fn=sprintf('%s%04d.DAT',pre,i);
  fp=fopen(fn);
  %  tX=fread(fp,[16 2^19],'uint16');
  
%  tX=fread(fp,[2^19 16],'uint16')';
%  tX=reshape(tX,2^19,16)';


%tX=reshape(tX,2^19,16)';

%tX=fread(fp,[2^19*16],'uint16');
%tX=reshape(tX,16,2^19);
tX=fread(fp,[16 2^19],'uint16');


  zX=(tX==0);
  %  tX(tX==0)=2048;% sometimes zero output
  tX=(tX-2048)*3.3;%uV
  %  tX=remmean(tX);
  %  tX=detrend(tX);
  fclose(fp);
  
  if sum(zX(:))> 10000
    fprintf('error:zeros:%s\n',fn);
  else
    X=[X tX];
  end
    
end


%mapping=[8 10 12 13 1 3 4 5 7 14 16 2 6 9 11 15 ];
%mapping=[1 3 4 5 7 8 9 10 12 13 14 16 2 6 11 15];%for 2017
%X=X(mapping,:);
%%%%%%%%%%%%%%%%%%sampl=1/31.25*10^6;%Hz mistake?
sampl=31250;%Hz
%sampl=sampl/2;% sampling rate error?
oX=X;
X=filterAmp(X,0,sampl);
stdV=-ones(4,1)*50;%250;80
%stdV=std(X,[],2)*5;
sX=int16(X);
step=80;%32

Th=50;%400;1000

Out=[];

tet=4;
for k=1:4
%tet=1;
%for k=1:16
  ssX=sX(1+(k-1)*tet:k*tet,:);
  [tmp,tmps]=extractSpDodeca(ssX,stdV,step);

  d=[];
  for i=1:size(tmps,2)
    t=abs(tmp(:,1+(i-1)*step:i*step)) > Th;
    if sum(t(:))
      d=[d i];
    end
  end

  ind=setdiff(1:size(tmps,2),d);
%  tmp=getSpikesS(tmp,step,ind);
%  tmps=tmps(ind);
  
  Out{k,1}=tmp;
  Out{k,3}=double(tmps);
end

return;
