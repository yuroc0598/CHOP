clear;
% A=[0 0 0
%     1 0 0 
%    0 1 0 
%    0 0 1 
%    1 1 0  
%    1 0 1 
%    0 1 1  
%    1 1 1];
% B=[0.5 0.5 0.5 
%     0 0 0 
%     1 1 1 
%     2 2 2 ];
% 
% C=[0 0 1
%    0 1 0
%    0 1 1
%    1 0 0
%    1 0 1
%    1 1 0
%    1 1 1
%    0 0 0];
% 
% D=[0 0
%    1 0
%    2 1
%    1 1
%    0 1];
train=load('defang.train.vector.afterPCA');
%train=load('convexhull.txt');
%pre=load('defang.predict.vector.afterPCA');
test=load('test.predcit.vector');
numOfTest=size(test,1);
dim=size(train,2);
bound=max(train,[],1);
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
unihull=cat(1,C,train);
%TODO solve linear system to determine if test is in convex hull
CC=unihull';

dd=test';
AA=CC;
%A=[];
bb=dd;
%b=[];
Aeq=ones(1,99);
beq=1;

lb=zeros(99,1);
ub=ones(99,1);

x = lsqlin(CC,dd,AA,bb,Aeq,beq,lb,ub);
 tess = convhulln(train);
boolhull=inhull(test,unihull);

fittest=0.0253*unihull(1,:)+0.03*unihull(9,:)+0.2447*unihull(13,:)+0.0702*unihull(22,:)+0.283*unihull(31,:)+0.3468*unihull(84,:);

% fittest=0.1003*train(6,:)+0.0636*train(20,:)+0.0555*train(23,:)+0.7806*train(39,:);
 cof=0.0253+0.03+0.2447+0.0702+0.283+0.3468;