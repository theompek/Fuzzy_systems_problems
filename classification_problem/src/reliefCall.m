%An o algorithmos relief exei ektelesei kai exoume kathgoriopoihsh tous
%tou pio sumantikous predictor tote den xreiazetai na to 3ana kanoume
if exist('RANKED.data','file') == 0
All_Data = importdata('waveform.data');
%Anakatevoume ta dedomena
N = length(All_Data); 
p = randperm(N);
All_Data = All_Data(p,:);
p = randperm(N);
All_Data = All_Data(p,:);
%Apo ta dedomena pairnoume to prwto 60% pou einai to training set
All_Data = All_Data(1:floor(length(All_Data)*0.6),:);
[RANKED,WEIGHT] = relieff(All_Data(:,1:end-1),All_Data(:,end),20);
save('RANKED.data','RANKED');
save('WEIGHT.data','WEIGHT');
end


