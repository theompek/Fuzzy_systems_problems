%{
Epilogh modelou opws perigrafetai sthn ekfwnhsh
k = 1: Model 1
k = 2: Model 2
k = 3: Model 3
k = 4: Model 4
%}
tic;
k = 4;
warning('off');
%Ta dedomena einai se morfh [input1 input2 input3 input4 output]
data = importdata('CCPP.dat');
%Anakatevoume ta dedomena gia na einai se tuxaia seira
N = length(data); 
p = randperm(N);
data = data(p,:);
p = randperm(N);
data = data(p,:);
%Mhkos stoixeiwn:60% gia training,20% gia validation,20% gia check
Ntr = floor(N*0.6); 
Nval = floor(N*0.2);
Nchk = N - Ntr - Nval;
%Dedomena
trData = data(1:Ntr,:);
valData = data(Ntr+1:Ntr+Nval,:);
chkData = data(Ntr+Nval+1:end,:);
switch(k)
 case 1
  fprintf('Model 1: 2 MF and Sigleton output\n')
  fis = genfis1(trData, 2, 'gbellmf', 'constant');  
 case 2
  fprintf('Model 2: 3 MF and Sigleton output\n')
  fis = genfis1(trData, 3, 'gbellmf', 'constant');  
 case 3
  fprintf('Model 3: 2 MF and Polynomial output\n')
  fis = genfis1(trData, 2, 'gbellmf', 'linear');  
 case 4
  fprintf('Model 4: 3 MF and Polynomial output\n')
  fis = genfis1(trData, 3, 'gbellmf', 'linear');    
end
epoch = 300;
error_goal = 0.01; 
trnOpt = [epoch error_goal NaN NaN NaN];
dispOpt = [0, 0, 0, 0];
Hybrid_method = 1;
[tuned_fis, error, stepsize, valFis, chkErr] = anfis(trData, fis, trnOpt,dispOpt,valData,Hybrid_method);
%Apou8hkeush tou ekpaideumenou modelou
writefis(tuned_fis, 'tuned_fis');
%Apotelesmata apo ta dedomena me xrhsh tou ekpaideumenou modelou
out_tr = evalfis(trData(:, 1:4), tuned_fis);
out_val = evalfis(valData(:, 1:4), tuned_fis);
out_chk = evalfis(chkData(:, 1:4), tuned_fis);
%}
close all;
xLimits1 = 10;
xLimits2 = 2000;
figure(1);
subplot(1, 2, 1);
plot(out_tr);
hold on;
plot(trData(:, 5));
xlim([xLimits1 xLimits2]);
title('Train samples');
legend('TrainOut', 'Real');
subplot(1, 2, 2);
plot(out_tr-trData(:, 5));
xlim([xLimits1 xLimits2]);
title('Error trainOut-real');

figure(2);
subplot(1, 2, 1);
plot(out_val);
hold on;
plot(valData(:, 5));
xlim([xLimits1 xLimits2]);
title('Evaluation samples');
legend('EvaluateOut', 'Real');
subplot(1, 2, 2);
plot(out_val-valData(:, 5));
xlim([xLimits1 xLimits2]);
title('Error evaluateOut-real');

figure(3);
subplot(1, 2, 1);
plot(out_chk);
hold on;
plot(chkData(:, 5));
xlim([xLimits1 xLimits2]);
title('Check samples');
legend('CkeckOut', 'Real');
subplot(1, 2, 2);
plot(out_chk-chkData(:, 5));
title('Error checkOut-real');
xlim([xLimits1 xLimits2]);

figure(4);
plot([error chkErr])
legend('Training Error','Check Error')
xlabel('Epochs')
ylabel('Root Mean Squared Error')
title('Learning Curves/Errors at each epoch')

figure(5);
subplot(2,2,1);
plotmf(fis,'input',1)
title('Mf of temperature');
subplot(2,2,2);
plotmf(fis,'input',2)
title('Mf of pressure');
subplot(2,2,3);
plotmf(fis,'input',3)
title('Mf of relative humidity');
subplot(2,2,4);
plotmf(fis,'input',4)
title('Mf of exhaust vacuum');

figure(6);
subplot(2,2,1);
plotmf(tuned_fis,'input',1)
title('Mf of temperature');
subplot(2,2,2);
plotmf(tuned_fis,'input',2)
title('Mf of pressure');
subplot(2,2,3);
plotmf(tuned_fis,'input',3)
title('Mf of relative humidity');
subplot(2,2,4);
plotmf(tuned_fis,'input',4)
title('Mf of exhaust vacuum');
%}
%Metablhtes a3iologhdhs
Al_Values = zeros(3,5);
e1 = out_tr-trData(:, 5);
MSE = mean((e1).^2);
RMSE = sqrt(MSE);
R2 = 1 - MSE/var(trData(:, 5));
NMSE = MSE/var(trData(:, 5));
NDEI = sqrt(NMSE);
Al_Values(1,:)=[MSE RMSE R2 NMSE NDEI];
fprintf('Train performance values\n')
fprintf('MSE = %d RMSE = %d R2 = %d NMSE = %d NDEI = %d \n', MSE, RMSE, R2,NMSE, NDEI);
e2 = out_val-valData(:, 5);
MSE = mean((e2).^2);
RMSE = sqrt(MSE);
R2 = 1 - MSE/var(valData(:, 5));
NMSE = MSE/var(valData(:, 5));
NDEI = sqrt(NMSE);
Al_Values(2,:)=[MSE RMSE R2 NMSE NDEI];
fprintf('Evaluate performance values\n')
fprintf('MSE = %d RMSE = %d R2 = %d NMSE = %d NDEI = %d \n', MSE, RMSE, R2,NMSE, NDEI);
e3 = out_chk-chkData(:,5);
MSE = mean((e3).^2);
RMSE = sqrt(MSE);
R2 = 1 - MSE/var(chkData(:, 5));
NMSE = MSE/var(chkData(:, 5));
NDEI = sqrt(NMSE);
Al_Values(3,:)=[MSE RMSE R2 NMSE NDEI];
fprintf('Check performance values\n')
fprintf('MSE = %d RMSE = %d R2 = %d NMSE = %d NDEI = %d \n', MSE, RMSE, R2,NMSE, NDEI);
uit = uitable(figure(7),'Data', Al_Values);
uit.Position = [10 210 487 76];
uit.ColumnName = {'MSE', 'RMSE', 'R2', 'NMSE', 'NDEI'};
uit.RowName = {'Training','Evaluation','Check'};
fprintf('Total time: %f sec\n',toc);
%}