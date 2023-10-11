function X=deuteronRead(basename,pre,initP,endP)

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


end

%saving data
X=[];
errorFile=0;
for i=initP:endP
  fn=sprintf('%s%04d.DAT',pre,i);
  fp=fopen(fn);
  tX=fread(fp,[16 2^19],'uint16');
  tX=(tX-2048)*3.3;%uV
  fclose(fp);
  
  X=[X tX];
end


return;