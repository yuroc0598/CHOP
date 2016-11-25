 clear;
 trainins=load('defang.train.vector.afterPCA');
 preins=load('defang.predict.vector.afterPCA');
Blabel=load('defang.predict.label');
fileID=fopen('inhullResultMat','a');

% trainins=load('bc.train.vector.normal.noIV');
% preins=load('bc.predict.vector.noIV');
% Blabel=load('bc.predict.label');

numOfTest=size(preins,1);
%TODO add boundary points to inital hull, first add points in the axis then
%add points in plane


boolhull=inhull(preins,trainins);
isinhull=ones(1,numOfTest);
correct=0;
fpos=0;
fneg=0;
bothin=0;
bothout=0;
for k=1:numOfTest
    if boolhull(k)==0
        isinhull(k)=-1;
    end
end

for k=1:numOfTest
    fprintf(fileID,'%2.0f\n',isinhull(k));
    
    
    
    if isinhull(k)==1
        disp(k);
    end
    if isinhull(k)==1&&Blabel(k)==1
    correct=correct+1;
    bothin=bothin+1;
    end
    if isinhull(k)==-1&&Blabel(k)==-1
    correct=correct+1;
    bothout=bothout+1;
    end
    if isinhull(k)==1 && Blabel(k)==-1
    fpos=fpos+1;
    disp('false positive occurs')
    end
    if isinhull(k)==-1 && Blabel(k)==1
    fneg=fneg+1;  
   end
    
end
