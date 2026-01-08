%% DC Motor Physical Parameters

J  = 0.01;   % Moment of inertia (kg.m^2)
b  = 0.1;    % Viscous friction constant (N.m.s)
Ke = 0.01;   % Back EMF constant (V/rad/s)
Kt = 0.01;
K=Ke;% Torque constant (N.m/A)
R  = 1;      % Armature resistance (Ohm)
L  = 0.5;    % Armature inductance (H)

%% Transfer Function of DC Motor (Speed Control)
% Output: Angular speed (rad/s)
% Input : Armature voltage (V)

s = tf('s');

Motor_TF = Kt / ( (J*s + b)*(L*s + R) + Ke*Kt );

%% Display Transfer Function
disp('DC Motor Transfer Function (Speed / Voltage):')
Motor_TF

%% Step Response
figure;
step(Motor_TF)
grid on
title('Step Response of DC Motor Speed')
xlabel('Time (seconds)')
ylabel('Angular Speed (rad/s)')
