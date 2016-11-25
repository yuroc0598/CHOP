%function [isinhull,correct,fpos,fneg]=extHull()

% A=[0 0 0 1 5 2
%    1 0 0 5 4 6
%    0 1 0 78 5 2
%    0 0 1 0 2 6
%    1 1 0 1 52 1 
%    1 0 1 14 2 36
%    0 1 1 6 3 2
%    1 1 1 15 5 8];
% B=[0.5 0.5 0.5 15 6 84
%     0 0 0 15 4 5
%     1 1 1 45 689 2
%     2 2 2 1 5 3];


 %trainins=load('defang.train.vector.normal.noIV');
 %preins=load('defang.predict.vector.noIV');
 clear;
 trainins=load('defang.train.vector.afterPCA');
 preins=load('defang.predict.vector.afterPCA');
Blabel=load('defang.predict.label');

% trainins=load('bc.train.vector.normal.noIV');
% preins=load('bc.predict.vector.noIV');
% Blabel=load('bc.predict.label');

numOfTest=size(preins,1);
numOfTrain=size(trainins,1);
%TODO add boundary points to inital hull, first add points in the axis then
%add points in plane
dim=size(trainins,2);
bound=max(trainins,[],1);
for i= 1:dim
A(i,i)=bound(i);
end

B=zeros(dim*(dim-1)/2,dim);
for i=1:dim
    for j=(i+1):dim
        firstInx=dim*(i-1)-i*(i-1)/2+j-i;
        B(firstInx,i)=A(i,i);
        B(firstInx,j)=A(j,j);
    end
end 
C=cat(1,A,B);
%unihull=cat(1,C,trainins);
pointBound=zeros(dim*numOfTrain,dim);

for i=1:numOfTrain
    for j=1:dim
        pointBound((i-1)*dim+j,j)=trainins(i,j);
    end
end
unihull=cat(1,trainins,pointBound);
%unihull=cat(1,trainins,trainins);
boolhull=inhull(preins,unihull);
%boolhull=inhull(preins,trainins);
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
    if isinhull(k)==Blabel(k)
    correct=correct+1;
    end
    if isinhull(k)==1 && Blabel(k)==-1
    fpos=fpos+1;
    disp(k)
    end
    if isinhull(k)==-1 && Blabel(k)==1
    fneg=fneg+1;  
    end
    if isinhull(k)==1 && Blabel(k)==1
    bothin=bothin+1;  
    end
    if isinhull(k)==-1 && Blabel(k)==-1
    bothout=bothout+1;  
    end
    
end

