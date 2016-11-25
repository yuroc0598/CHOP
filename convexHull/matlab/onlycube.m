function incube=onlycube()
%clear;
 trainins=load('defang.train.vector.afterPCA');
 B=load('defang.predict.vector.afterPCA');
% Blabel=load('bc.predict.label');
% trainins=load('defang.train.vector.normal.noIV');
% B=load('defang.predict.vector.noIV');
Blabel=load('defang.predict.label');
numOfTrain=size(trainins,1);
dimension=size(trainins,2);
%build a set for each training instance and union them, use 2D array A to
%represent the set
%A=zeros(numOfTrain,dimension);

% A=sym('A',[numOfTrain,dimension]);
% for i=1:numOfTrain
%     for j=1:dimension
%     assume(A(i,j)>0  & A(i,j)<trainins(i,j));
%     end
% end

numOfTest=size(B,1);
isin=ones(numOfTest,numOfTrain);
tic
for t=1:numOfTest
for i=1:numOfTrain
    for j=1:dimension
    if B(t,j)>trainins(i,j)
        isin(t,i)=0;
        break
    end
    end
end
end
incube=zeros(1,numOfTest);
correct=0;
fpos=0;
fneg=0;
for k=1:numOfTest
    incube(k)=any(isin(k,:));
    if incube(k)==0
        incube(k)=-1;
    end
end
toc
for k=1:numOfTest
    if incube(k)==Blabel(k)
    correct=correct+1;
    end
    if incube(k)==1 && Blabel(k)==-1
    fpos=fpos+1;  
    end
    if incube(k)==-1 && Blabel(k)==1
    fneg=fneg+1;  
   end
    
end

%TODO: add the constraints of being inside convex hull
% 
% isinhull=zeros(numOfTest);
% for  m=1:numOfTest
% isinhull(m)=inhull(B,trainins);
% 
% end



