%
warning('off')
%Ta dedomena einai se morfh [input1 input2 input3 input4 output]
All_Data = importdata('waveform.data');
%Anakatevoume ta dedomena
N = length(All_Data); 
p = randperm(N);
All_Data = All_Data(p,:);
p = randperm(N);
All_Data = All_Data(p,:);
bestNF = 12;
bestNR = 3;
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
epoch = 300;
error_goal = 0.01; 
trnOpt = [epoch error_goal NaN NaN NaN];
dispOpt = [0, 0, 0, 0];
Hybrid_method = 1;

%Dhmiourgia TSK modelou,exoume parametrous tous kaluterous suntelestes
fis = genfis3(data(:,1:end-1), data(:,end),'sugeno',bestNR,[NaN NaN NaN NaN 0] );
[tuned_fis, error, stepsize, valFis, chkErr] = anfis(trData, fis, trnOpt,dispOpt,valData,Hybrid_method);
%Apou8hkeush tou ekpaideumenou modelou
writefis(tuned_fis, 'tuned_fis');
writefis(fis, 'fis');
%Apotelesmata apo ta dedomena me xrhsh tou ekpaideumenou modelou
out_tr = round(evalfis(trData(:, 1:end-1), tuned_fis));
out_val = round(evalfis(valData(:, 1:end-1), tuned_fis));
out_chk = round(evalfis(chkData(:, 1:end-1), tuned_fis));
%}
xLimit1 = 1;
xLimit2 = 100;
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
%
figure(5);
subplot(2,2,1);
plotmf(fis,'input',1)
title('Mf1 initial');
subplot(2,2,2);
plotmf(fis,'input',2)
title('Mf2 initial');
subplot(2,2,3);
plotmf(fis,'input',3)
title('Mf3 initial');
subplot(2,2,4);
plotmf(fis,'input',4)
title('Mf4 initial');

figure(6);
subplot(2,1,1);
plotmf(fis,'input',5)
title('Mf5 initial');
subplot(2,1,2);
plotmf(fis,'input',6)
title('Mf6 initial');

figure(7);
subplot(2,2,1);
plotmf(tuned_fis,'input',1)
title('Mf1 tuned');
subplot(2,2,2);
plotmf(tuned_fis,'input',2)
title('Mf2 tuned');
subplot(2,2,3);
plotmf(tuned_fis,'input',3)
title('Mf3 tuned');
subplot(2,2,4);
plotmf(tuned_fis,'input',4)
title('Mf4 tuned');

figure(8);
subplot(2,1,1);
plotmf(tuned_fis,'input',5)
title('Mf5 tuned');
subplot(2,1,2);
plotmf(tuned_fis,'input',6)
title('Mf6 tuned');
%}

classNum = 3;
classes = [0 1 2];
Xij = zeros(classNum);
for i = 1:classNum
for j = 1:classNum
 for k = 1:size(chkData,1)
  if out_chk(k) == classes(i) && chkData(k, end) == classes(j)
   Xij(i,j) = Xij(i,j)+1; 
  end
 end
end
end
Nn = length(out_chk);
OA = sum(diag(Xij))/Nn;
Xir = sum(Xij,2);
Xjc = sum(Xij,1);
PA = diag(Xij)./Xjc';
UA = diag(Xij)./Xir;
K = (Nn^2*OA - Xjc*Xir)/(Nn^2 -Xjc*Xir);

uit = uitable(figure(9),'Data',Xij);
uit.Position = [60 300 359 76];
uit.ColumnName = {'Actual C1','Actual C2','Actual C3'};
uit.RowName = {'Predicted C1','Predicted C2','Predicted C3'};
uit2 = uitable(figure(9),'Data',[PA UA]);
uit2.Position = [40 200 185 76];
uit2.ColumnName = {'PA','UA'};
uit2.RowName = {'C1','C2','C3'};
uit3 = uitable(figure(9),'Data',[OA K]);
uit3.Position = [280 220 182 40];
uit3.ColumnName = {'OA','K'};
uit3.RowName = {''};


%}