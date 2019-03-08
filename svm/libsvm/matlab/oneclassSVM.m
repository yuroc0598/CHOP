clear;
trainlabel=load('defang.train.label.normal');
trainins=load('defang.train.vector.afterPCA');
predictlabel=load('defang.predict.label');
predictins=load('defang.predict.vector.afterPCA');
%disp(trainlabel);
model= svmtrain(trainlabel, trainins,['-t 0 -s 2 -n 10e-100']);


w = model.SVs' * model.sv_coef;
b = -model.rho;
m=2/norm(w);
modelLabel=model.Label;

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

[predicted_label, accuracy, decision_values] = svmpredict(predictlabel,predictins,model,['']);
falneg=0;
falpos=0;
bothsafe=0;
bothunsafe=0;
for i=1:100
    if predicted_label(i)==1 && predictlabel(i)==-1
        falpos=falpos+1;
    end
    if predicted_label(i)==-1 && predictlabel(i)==1
        falneg=falneg+1;
    end
    if predicted_label(i)==1 && predictlabel(i)==1
        bothsafe=bothsafe+1;
    end
    if predicted_label(i)==-1 && predictlabel(i)==-1
        bothunsafe=bothunsafe+1;
    end
end