function X=deuteronRaw(basename,pre,initP,endP)

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
      tX(zX)=0;
      X=[X tX];
  else
    X=[X tX];
  end
    
end


return;