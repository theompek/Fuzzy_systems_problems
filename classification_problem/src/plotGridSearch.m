NF = importdata('NF.data');
clustNum = importdata('clustNum.data');
MeanValues = importdata('MeanValues.data');

Xdata = [NF' NF' NF' NF'];
xSc = [Xdata(1,:) Xdata(2,:) Xdata(3,:) Xdata(4,:)];
ySc = [clustNum(1,:) clustNum(2,:) clustNum(3,:) clustNum(4,:)];
zSc = [MeanValues(1,:) MeanValues(2,:) MeanValues(3,:) MeanValues(4,:)];
close all
subplot(2,2,[1 3])
scatter3(xSc,ySc,zSc)
hold on
surf(Xdata,clustNum,MeanValues)
%Find best parapemters
minV = min(min(MeanValues));
[x,y]= find(MeanValues==minV);
fprintf('Best model has:\n- Feauters:%d Clusters:%d\n',NF(x),clustNum(x,y))
fprintf('- Mean error:%1.4f\n',minV);
scatter3(NF(x),clustNum(x,y),MeanValues(x,y),150,'o')
view(60,30)
title('GridSearch surface')
xlabel('Number of features')
ylabel('Number of clusters')
zlabel('Mean error of model')

subplot(2,2,2)
scatter3(xSc,ySc,zSc)
hold on
surf(Xdata,clustNum,MeanValues)
scatter3(NF(x),clustNum(x,y),MeanValues(x,y),150,'o')
view(90,0)
title('2D view')
xlabel('Number of features')
ylabel('Number of clusters')
zlabel('Mean error of model')

subplot(2,2,4)
scatter3(xSc,ySc,zSc)
hold on
surf(Xdata,clustNum,MeanValues)
scatter3(NF(x),clustNum(x,y),MeanValues(x,y),150,'o')
view(0,0)
title('2D view')
xlabel('Number of features')
ylabel('Number of clusters')
zlabel('Mean error of model')


