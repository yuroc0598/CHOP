clear;
trainlabel=load('test.label.normal');
trainins=load('test.input.normal');
predictlabel=load('test.label.predict');
predictins=load('test.input.predict');
%disp(trainlabel);
model= svmtrain(trainlabel, trainins,['-t 0 ']);


w = model.SVs' * model.sv_coef;
b = -model.rho;
m=2/norm(w);
modelLabel=model.Label;
if model.Label(1) == -1
  w = -w;
  b = -b;
end
disp('coefficients are');
disp(w);
disp('hyperplane offset is ');
disp(b);
disp('distance between hyperplane and normal runs is ');
disp(m);

num=size(trainins,1);
offset=trainins*w;
onplane=0;
for i=1:num
if offset(i)+b-1<1e-50
    onplane=onplane+1;
end
end


[predictResult, accuracy, decision_values] = svmpredict(predictlabel, predictins, model, ['']);


bothNormal=0;
bothbug=0;
falsepositive=0;
falseneg=0;
correctNum=0;
predictDataNum=(size(predictins,1));


for i=1:predictDataNum
if predictResult(i,1)==1 && predictlabel(i,1)==1
    correctNum=correctNum+1;
    bothNormal=bothNormal+1;
end
if predictResult(i,1)==-1 && predictlabel(i,1)==-1
    correctNum=correctNum+1;
    bothbug=bothbug+1;
end
if predictResult(i,1)==1 && predictlabel(i,1)==-1
    falsepositive=falsepositive+1;
end
if predictResult(i,1)==-1 && predictlabel(i,1)==1
    falseneg=falseneg+1;
    
end
end
S1=sprintf('The accuracy of prediction is %3.2f%%\n', 100*correctNum/predictDataNum);
S2=sprintf('False positve number is %3f\n', falsepositive);
S3=sprintf('False negtive number is %3f\n', falseneg);

disp(S1);
disp(S2);
disp(S3);

