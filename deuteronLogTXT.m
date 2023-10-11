function [ts,fP,tP]=deuteronLogTXT(fn,csvfn,from,to)


[fP,tP]=CSVread(csvfn,from,to)

csv=readtable(fn,'delimiter',',');

txt=csv.(3);
loop=size(txt,1);

ts=[];
init=[];
txts=[];

for i=1:loop
  
  if strncmp(txt(i),'t=',2) 
    [tts]=deuteronTimeConvert(txt{i});
    ts=[ts tts];
  end
end

return;
%%%%%%%%%%%%%%%%%%%%%%%%
function [sP,eP]=CSVread(fn,startP,endP)
csv=readtable(fn,'delimiter',',');

s=sprintf('File index: %03d',startP);
stP=find(strcmp(csv.Details,s));
s=sprintf('File index: %03d',endP);
endP=find(strcmp(csv.Details,s));


sP=csv.Time_msFromMidnight_(stP);
eP=csv.Time_msFromMidnight_(endP);

return;