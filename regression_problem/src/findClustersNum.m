function [arrAy] = findClustersNum( NF,m )

All_Data = importdata('Bank.data');
%Apo ta dedomena pairnoume to prwto 60% pou einai to training set
All_Data = All_Data(1:floor(length(All_Data)*0.6),:);
RANKED = importdata('RANKED.data');

%{
radii = [0.4   0.3  0.2  0.17 0.13;...
         0.75  0.61 0.54 0.5  0.48;...
         0.95  0.8  0.72 0.7  0.68;...
         0.98  0.9  0.85 0.8  0.77];
%}
     
%m1 = [0.35 0.22 0.185 0.153 0.128];
%m2 = [0.83 0.75 0.68 0.64 0.61];
%m3 = [0.97 0.84 0.8 0.75 0.72];
%m4 = [1 0.96 0.9 0.87 0.84];
arrAy = zeros(length(NF),length(m));
%Grid search
for i = 1:length(NF)  
for k = 1:length(m)
 %Dedomena,pernoume tis NF pio sumantikes eisodous kai thn e3odo
 data = [All_Data(:,RANKED(1:NF(i))) All_Data(:,end)];
 fis = genfis2(data(:,1:end-1), data(:,end), m(k));
 arrAy(i,k) = length(fis.output.mf);
 fprintf('Number of cluster: %d for radii: %1.3f\n',length(fis.output.mf),m(k))
  if length(fis.output.mf) >= 30
    fprintf('Stop...\n');
   break;    
  end
end
end
