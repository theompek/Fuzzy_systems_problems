%
%Ta dedomena einai se morfh [input1 input2 input3 input4 output]
All_Data = importdata('Bank.data');
bestNF = 9;
bestRadii = 0.830;
%Efarmogh tou algori8mou relief gia thn euresh twn pio sumantikwn predictor
reliefCall
RANKED = importdata('RANKED.data');
WEIGHT = importdata('WEIGHT.data');
%Dedomena,pernoume tis NF pio sumantikes eisodous kai thn e3odo
data = [All_Data(:,RANKED(1:bestNF)) All_Data(:,end)];
%Mhkos stoixeiwn:60% gia training,20% gia validation,20% gia check
N = length(data); 
Ntr = floor(N*0.6); 
Nval = floor(N*0.2);
Nchk = N - Ntr - Nval;
%Dedomena
trData = data(1:Ntr,:);
valData = data(Ntr+1:Ntr+Nval,:);
chkData = data(Ntr+Nval+1:end,:);
epoch = 600;
error_goal = 0.01; 
trnOpt = [epoch error_goal NaN NaN NaN];
dispOpt = [0, 0, 0, 0];
Hybrid_method = 1;

%Dhmiourgia TSK modelou,exoume parametrous tous kaluterous suntelestes
fis = genfis2(data(:,1:end-1), data(:,end),bestRadii);
[tuned_fis, error, stepsize, valFis, chkErr] = anfis(trData, fis, trnOpt,dispOpt,valData,Hybrid_method);
%Apou8hkeush tou ekpaideumenou modelou
writefis(tuned_fis, 'tuned_fis');
writefis(fis, 'fis');
%Apotelesmata apo ta dedomena me xrhsh tou ekpaideumenou modelou
out_tr = evalfis(trData(:, 1:end-1), tuned_fis);
out_val = evalfis(valData(:, 1:end-1), tuned_fis);
out_chk = evalfis(chkData(:, 1:end-1), tuned_fis);
%}
xLimit1 = 1;
xLimit2 = 2000;
close all
figure(1);
subplot(1, 2, 1);
plot(out_tr);
hold on;
plot(trData(:, end));
xlim([xLimit1 xLimit2]);
title('Train samples');
legend('TrainOut', 'Real');
subplot(1, 2, 2);
plot(out_tr-trData(:, end));
xlim([xLimit1 xLimit2]);
title('Error trainOut-real');

figure(2);
subplot(1, 2, 1);
plot(out_val);
hold on;
plot(valData(:, end));
xlim([xLimit1 xLimit2]);
title('Evaluation samples');
legend('EvaluateOut', 'Real');
subplot(1, 2, 2);
plot(out_val-valData(:, end));
xlim([xLimit1 xLimit2]);
title('Error evaluateOut-real');

figure(3);
subplot(1, 2, 1);
plot(out_chk);
hold on;
plot(chkData(:, end));
xlim([xLimit1 xLimit2]);
title('Check samples');
legend('CkeckOut', 'Real');
subplot(1, 2, 2);
plot(out_chk-chkData(:, end));
title('Error checkOut-real');
xlim([xLimit1 xLimit2]);

figure(4);
plot([error chkErr])
legend('Training Error','Check Error')
xlabel('Epochs')
ylabel('Root Mean Squared Error')
title('Learning Curves/Errors at each epoch')
%}
figure(5);
subplot(2,2,1);
plotmf(fis,'input',5)
title('Mf5 initial');
subplot(2,2,2);
plotmf(fis,'input',6)
title('Mf6 initial');
subplot(2,2,3);
plotmf(fis,'input',7)
title('Mf7 initial');
subplot(2,2,4);
plotmf(fis,'input',8)
title('Mf8 initial');

figure(6);
subplot(2,2,1);
plotmf(tuned_fis,'input',5)
title('Mf5 tuned');
subplot(2,2,2);
plotmf(tuned_fis,'input',6)
title('Mf6 tuned');
subplot(2,2,3);
plotmf(tuned_fis,'input',7)
title('Mf7 tuned');
subplot(2,2,4);
plotmf(tuned_fis,'input',8)
title('Mf8 tuned');
%}
%Metablhtes a3iologhdhs
Al_Values = zeros(3,5);
e1 = out_tr-trData(:, end);
MSE = mean((e1).^2);
RMSE = sqrt(MSE);
R2 = 1 - MSE/var(trData(:, end));
NMSE = MSE/var(trData(:, end));
NDEI = sqrt(NMSE);
Al_Values(1,:)=[MSE RMSE R2 NMSE NDEI];
fprintf('Train performance values\n')
fprintf('MSE = %d RMSE = %d R2 = %d NMSE = %d NDEI = %d \n', MSE, RMSE, R2,NMSE, NDEI);
e2 = out_val-valData(:, end);
MSE = mean((e2).^2);
RMSE = sqrt(MSE);
R2 = 1 - MSE/var(valData(:, end));
NMSE = MSE/var(valData(:, end));
NDEI = sqrt(NMSE);
Al_Values(2,:)=[MSE RMSE R2 NMSE NDEI];
fprintf('Evaluate performance values\n')
fprintf('MSE = %d RMSE = %d R2 = %d NMSE = %d NDEI = %d \n', MSE, RMSE, R2,NMSE, NDEI);
e3 = out_chk-chkData(:,end);
MSE = mean((e3).^2);
RMSE = sqrt(MSE);
R2 = 1 - MSE/var(chkData(:, end));
NMSE = MSE/var(chkData(:, end));
NDEI = sqrt(NMSE);
Al_Values(3,:)=[MSE RMSE R2 NMSE NDEI];
fprintf('Check performance values\n')
fprintf('MSE = %d RMSE = %d R2 = %d NMSE = %d NDEI = %d \n', MSE, RMSE, R2,NMSE, NDEI);
uit = uitable(figure(7),'Data', Al_Values);
uit.Position = [10 210 487 76];
uit.ColumnName = {'MSE', 'RMSE', 'R2', 'NMSE', 'NDEI'};
uit.RowName = {'Training','Evaluation','Check'};
%}