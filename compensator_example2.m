%example2compensator
% Define the plant transfer function
G = tf([1], [1 2 10]);  % Example: G(s) = 1 / (s^2 + 2s + 10)
 
% Define Lag compensator parameters
z = 10;  % Zero of the Lag compensator
p = 1;    % Pole of the Lag compensator
K = 1;    % Gain factor
 
% Lag compensator transfer function
G_lag = K * tf([1 p], [1 z]);
 
% Closed-loop system with Lag compensator
G_closed_loop_lag = feedback(G * G_lag, 1);
 
% Plot Bode plots
figure;
bode(G_closed_loop_lag);
grid on;
 
% Step response
figure;
step(G_closed_loop_lag);
title('Step Response of Closed-Loop System with Lag Compensator');
