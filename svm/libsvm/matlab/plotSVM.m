% Labels are 0 or 1
% trainlabel=load('test.label.normal');
% trainins=load('test.input.normal');
% predictlabel=load('test.label.predict');
% predictins=load('test.input.predict');
% model= svmtrain(trainlabel, trainins,['-t 0 -s 2 -n 1e-20']);
% d=trainins;
% 
% w = model.SVs' * model.sv_coef;
% b = -model.rho;
% % if model.Label(1) == 0
% %   w = -w;
% %   b = -b;
% % end
% 
% figure
% 
% % plot training data
% hold on;
% pos = find(trainlabel==1);
% scatter(d(pos,1), d(pos,2), 'b')
% pos = find(trainlabel==-1);
% scatter(d(pos,1), d(pos,2), 'r')
% 
% % now plot support vectors
% hold on;
% sv = full(model.SVs);
% plot(sv(:,1),sv(:,2),'--');
% 
% % now plot decision area
% [xi,yi] = meshgrid([min(d(:,1)):0.01:max(d(:,1))],[min(d(:,2)):0.01:max(d(:,2))]);
% dd = [xi(:),yi(:)];
% tic;[predicted_label, accuracy, decision_values] = svmpredict(predictlabel,predictins,model,['']);toc
% pos = find(predicted_label==1);
% hold on;
% redcolor = [1 0.8 0.8];
% bluecolor = [0.8 0.8 1];
% h1 = plot(dd(pos,1),dd(pos,2),'s','color',redcolor,'MarkerSize',10,'MarkerEdgeColor',redcolor,'MarkerFaceColor',redcolor);
% pos = find(predicted_label==-1);
% hold on;
% h2 = plot(dd(pos,1),dd(pos,2),'s','color',bluecolor,'MarkerSize',10,'MarkerEdgeColor',bluecolor,'MarkerFaceColor',bluecolor);
% uistack(h1, 'bottom');
% uistack(h2, 'bottom');
% 



% Labels are -1 or 1
groundTruth = load('test.label.predict');
d = load('test.input.normal');
trainlabel=load('test.label.normal');
model= svmtrain(trainlabel, d,['-t 0 -s 2 -n 1e-20']);
figure

% plot training data
hold on;
pos = find(groundTruth==1);
scatter(d(pos,1), d(pos,2), 'r')
pos = find(groundTruth==-1);
scatter(d(pos,1), d(pos,2), 'b')

% now plot support vectors
hold on;
sv = full(model.SVs);
plot(sv(:,1),sv(:,2),'ko');

% now plot decision area
[xi,yi] = meshgrid([min(d(:,1)):0.01:max(d(:,1))],[min(d(:,2)):0.01:max(d(:,2))]);
dd = [xi(:),yi(:)];
tic;[predicted_label, accuracy, decision_values] = svmpredict(zeros(size(dd,1),1), dd, model);toc
pos = find(predicted_label==1);
hold on;
redcolor = [1 0.8 0.8];
bluecolor = [0.8 0.8 1];
h1 = plot(dd(pos,1),dd(pos,2),'s','color',redcolor,'MarkerSize',10,'MarkerEdgeColor',redcolor,'MarkerFaceColor',redcolor);
pos = find(predicted_label==-1);
hold on;
h2 = plot(dd(pos,1),dd(pos,2),'s','color',bluecolor,'MarkerSize',10,'MarkerEdgeColor',bluecolor,'MarkerFaceColor',bluecolor);
uistack(h1, 'bottom');
uistack(h2, 'bottom');