function [t,hr]=deuteronTimeConvert(str,init)
if nargin==1
  init=[];
end

strt=findstr(str,'=')+1;
stp=findstr(str,' ')-1;

str=str(strt:stp);
cs=findstr(str,':');

hr=str(1:cs(1)-1);
mn=str(cs(1)+1:cs(2)-1);
sc=str(cs(2)+1:end);
cs=findstr(sc,'.');
scd=sc(1:cs-1);
nn=sc(cs+1:end);

hr=str2num(hr)*60*60;
if ~isempty(init)
  hr=hr-init;
end
mn=str2num(mn)*60;
scd=str2num(scd);
nn=str2num(nn);

t=hr+mn+scd;
t=t*1000+nn/1000;
%t=t*1000000+nn;
return;

