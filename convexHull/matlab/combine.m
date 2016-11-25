incube=onlycube;
inhull=extHull;
num=size(incube,2);


result=ones(1,num);
for i=1:num
   
    if incube(i)==-1&&inhull(i)==-1
        result(i)=-1;
    end
end

Blabel=load('defang.predict.label');
correct=0;
fpos=0;
fneg=0;
for k=1:num
     if result(k)==Blabel(k)
    correct=correct+1;
    end
    if result(k)==1 && Blabel(k)==-1
    fpos=fpos+1;  
    end
    if result(k)==-1 && Blabel(k)==1
    fneg=fneg+1;  
   end
    
end