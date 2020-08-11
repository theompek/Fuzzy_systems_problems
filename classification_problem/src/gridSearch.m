%
tic;
warning('off')
%Ta dedomena einai se morfh [input1 input2 ... input32 output]
All_Data = importdata('waveform.data');
%Anakatevoume ta dedomena
N = length(All_Data); 
p = randperm(N);
All_Data = All_Data(p,:);
p = randperm(N);
All_Data = All_Data(p,:);
%Apo ta dedomena pairnoume to prwto 60% pou einai to training set
All_Data = All_Data(1:floor(length(All_Data)*0.6),:);
%Efarmogh tou algori8mou relief gia thn euresh twn pio sumantikwn predictor
reliefCall
RANKED = importdata('RANKED.data');
WEIGHT = importdata('WEIGHT.data');
N = length(All_Data); 
N80tr = floor(N*0.8); % 80% dedomenwn
N20tr = N - N80tr;    % 20% dedomenwn
epoch = 110;
error_goal = 0.01; 
trnOpt = [epoch error_goal NaN NaN NaN];
dispOpt = [0, 0, 0, 0];
Hybrid_method = 1;
%Number of Features and clusters
NF = [4 8 12 16];
NR = [3 9 15 21];
MeanValues = zeros(length(NF),length(NR));
clustNum = zeros(length(NF),length(NR));

%Grid search
for i = 1:length(NF)
for j = 1:length(NR)
 %Dedomena,pernoume tis NF pio sumantikes eisodous kai thn e3odo
 data = [All_Data(:,RANKED(1:NF(i))) All_Data(:,end)];
 %Dhmiourgia TSK modelou,exoume parametro thn aktina radii twn cluster
 fis = genfis3(data(:,1:end-1), data(:,end),'sugeno',NR(j),[NaN NaN NaN NaN 0] );
 clustNum(i,j) = NR(j);
 %5-fold cross validation
 fprintf('5-fold process for model (i,j)=(%d,%d)\n',i,j)
 for k = 1:5 
 %Diaxwrizoume ta dedomena se 5 tmhmata kai se ka8e epanalhsh xrhsimopoioume 
 %to 1 apo ta tmhmata gia epikyrwsh kai ta upoloipa gia ekpaideush.
     x1 = (k-1)*N20tr+1;
     x2 = k*N20tr;
    trData = [data(1:x1,:) ; data(x2:end,:)]; %dedomena gia ekpaideush 80% h 4/5
    valData = data(x1:x2,:); %dedomena gia epikurwsh h 20% h 1/5
    tuned_fis = anfis(trData, fis, trnOpt,dispOpt);
    %A3iologhsh tou ekpaideumenou modelou
    out_val = round(evalfis(valData(:, 1:end-1), tuned_fis));
    e1 = out_val - valData(:,end);
    MeanValues(i,j) = MeanValues(i,j) + mean(e1.^2)/5;
 end
end
end
toc
fprintf('Total time: %f sec\n',toc);
save('clustNum.data','clustNum');
save('MeanValues.data','MeanValues');
save('NF.data','NF');
plotGridSearch
