sim('car_navigation_model.slx')
figure(1);
clf;
hold on;
title('Trajectory');
ylabel('y');
xlabel('x');
plot(9.1, 4.3, 'ro', 'MarkerSize', 4);
plot(15, 7.2, 'x', 'MarkerSize', 10);
%Perioxh tou empodiou 
obstacleX=[10 10 11 11 12 12 15 15];
obstacleY=[0 5 5 6 6 7 7 0];
fill(obstacleX, obstacleY, 'cyan');
%Apo thn sunolikh poreia toy autokinhtou kratame mexri to shmei x=15 
x = Xcord.Data(Xcord.Data<=15);
y = Ycord.Data(1:length(x));
plot(x, y);
fprintf('Final position : (x, y) = (%2.3f, %2.3f) \n', x(end), y(end));
hold off