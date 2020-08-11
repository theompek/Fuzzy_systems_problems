clear;
s = tf('s');
c = 1.3;
%Open loop system
sys = (10*(s+c))/(s*(s+1)*(s+9));
figure(1);
rlocus(sys);
%We choose a kp value
Kp = 3.5;
sys = Kp*sys;
figure(2);
opt = stepDataOptions('StepAmplitude',60);
step(feedback(sys, 1, -1),opt)
Ki = Kp*c;
fprintf('Kp = %2.3f Ki = %2.3f c = %2.1f\n',Kp,Ki,c)