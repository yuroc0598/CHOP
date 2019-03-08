clear;

trainins=load('bc.train.vector.normal.noIV');
actualLabels=load('bc.predict.label');
predictins=load('bc.predict.vector.noIV');


trainDataNum=size(trainins,1);
dim=size(trainins,2);

A=zeros(dim,dim+1);
A(:,end)=-1;






bound=max(trainins,[],1);

for i= 1:dim
A(i,i)=bound(i);
end
hyperplane=null(A);





predictDataNum=(size(predictins,1));
predictins(:,end+1)=-1;
predictValue=zeros(predictDataNum,1);
predictValue=predictins*hyperplane;


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
S2=sprintf('Number of false positve is %3.0f\n', falsepositive);
S3=sprintf('Number of false negtive number is %3.0f\n', falseneg);

disp(S1);
disp(S2);
disp(S3);

