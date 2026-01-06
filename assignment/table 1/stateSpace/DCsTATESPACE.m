% Physical parameters
J  = 0.01;     % kg.m^2
b  = 0.1;      % N.m.s
Ke = 0.01;     % V/(rad/s)
Kt = 0.01;     % N.m/A
R  = 1;        % Ohm
L  = 0.5;      % Henry
% State-space matrices
A = [-b/J      Kt/J;
     -Ke/L    -R/L];

B = [0;
     1/L];

C = [1 0];    % Output = motor speed
D = 0;

% Create state-space system
sys = ss(A,B,C,D);
% Time vector
t = 0:0.01:5;

% Open-loop step response
figure;
step(sys, t);
grid on;
title('Open-Loop Step Response of DC Motor Speed');
xlabel('Time (seconds)');
ylabel('Angular Speed (rad/s)');
% Desired closed-loop poles
p = [-3+3i  -3-3i];

% State feedback gain
K = place(A,B,p);

% Closed-loop system
Acl = A - B*K;
sys_cl = ss(Acl,B,C,D);

% Closed-loop step response
figure;
step(sys_cl, t);
grid on;
title('Closed-Loop Step Response with State Feedback');
xlabel('Time (seconds)');
ylabel('Angular Speed (rad/s)');
% Controllability
Co = ctrb(A,B);
rank_Co = rank(Co)

% Observability
Ob = obsv(A,C);
rank_Ob = rank(Ob)
