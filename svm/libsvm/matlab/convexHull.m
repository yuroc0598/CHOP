clear;

trainins=load('defang.train.vector.afterPCA');bound
actualLabels=load('defang.predict.label');
predictins=load('defang.predict.vector.afterPCA');
%trainins=load('test.train.vector');
%actualLabels=load('test.predict.label');
%predictins=load('test.predict.vector');

trainDataNum=size(trainins,1);
dim=size(trainins,2);

A=zeros(dim,dim+1);
A(:,end)=-1;




% model= svmtrain(trainlabel, trainins,['-t 0']);
% 
% 
% w = model.SVs' * model.sv_coef;
% b = -model.rho;
% m=2/norm(w);
% modelLabel=model.Label;
% if model.Label(1) == -1
%   w = -w;
%   b = -b;
% end
% disp('coefficients are');
% disp(w);
% disp('hyperplane offset is ');
% disp(b);
% disp('distance between hyperplane and normal runs is ');
% disp(m);

bound=max(trainins,[],1);

for i= 1:dim
A(i,i)=bound(i);
end
hyperplane=null(A);





predictDataNum=(size(predictins,1));
predictins(:,end+1)=-1;
predictValue=zeros(predictDataNum,1);
disp('predictins');
disp(predictins);
disp('hyperplane');
disp(hyperplane);
predictValue=predictins*hyperplane;
disp('predictValue');
disp(predictValue);

predictResult=zeros(predictDataNum,1);
for i=1:predictDataNum
if predictValue(i,1)>0
    predictResult(i,1)=-1;
else
     predictResult(i,1)=1;
end
end

bothNormal=0;
bothbug=0;
falsepositive=0;
falseneg=0;
correctNum=0;
for i=1:predictDataNum
if predictResult(i,1)==1 && actualLabels(i,1)==1
    correctNum=correctNum+1;
    bothNormal=bothNormal+1;
end
if predictResult(i,1)==-1 && actualLabels(i,1)==-1
    correctNum=correctNum+1;
    bothbug=bothbug+1;
end
if predictResult(i,1)==1 && actualLabels(i,1)==-1
    falsepositive=falsepositive+1;
end
if predictResult(i,1)==-1 && actualLabels(i,1)==1
    falseneg=falseneg+1;
    
end
end
S1=sprintf('The accuracy of prediction is %3.2f%%\n', 100*correctNum/predictDataNum);
S2=sprintf('False positve number is %3f\n', falsepositive);
S3=sprintf('False negtive number is %3f\n', falseneg);

disp(S1);
disp(S2);
disp(S3);

