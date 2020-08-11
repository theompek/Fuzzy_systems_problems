%Arxika kaloume na tre3oun ta Fuzzy modela poy sxediasame sto simulink 
%kai na epistre3oun ta dedomena twn parastasewn apokrishs tous
sim('systemModel_Initial.slx')
sim('systemModel_Final.slx')
%Sthn sunexeia sxediazoume ton grammiko PI controller
s = tf('s');
c = 1.3;
Kp = 3.5;
sys = Kp*(10*(s+c))/(s*(s+1)*(s+9));
%Telos sxediazoume oles tis grafikes parastaseis mazi
figure(1);
hold on
title('Step responses')
opt = stepDataOptions('StepAmplitude',50);
step(feedback(sys, 1, -1),opt,5,'g')
hold on
plot(OutInitial.Time,OutInitial.Data,'red')
plot(OutFinal.Time,OutFinal.Data,'b')
legend('linear PI','Initial FZ-PI','Final FZ-PI')