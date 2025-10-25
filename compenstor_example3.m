% Define the plant transfer function
G = tf([1], [1 2 10]);  % Example: G(s) = 1 / (s^2 + 2s + 10)
 
% Define Lead-Lag compensator parameters
z1 = 1;   % Zero of the Lead part
p1 = 10;  % Pole of the Lead part
z2 = 0.1; % Zero of the Lag part
p2 = 1;   % Pole of the Lag part
K = 1;    % Gain factor
 
% Lead compensator transfer function
G_lead = K * tf([1 z], [1 p]);
 
% Lag compensator transfer function
G_lag =  tf([1 p], [1 z]);
 
 
% Lead-Lag compensator transfer function
%G_lead_lag = K * tf([1 z1] * [1 p2], [1 p1] * [1 z2]);
 
G_lead_lag = G_lead , G_lag;
% Closed-loop system with Lead-Lag compensator
G_closed_loop_lead_lag = feedback(G * G_lead_lag, 1);
 
% Plot Bode plots
figure;
bode(G_closed_loop_lead_lag);
grid on;
 
% Step response
figure;
step(G_closed_loop_lead_lag);
title('Step Response of Closed-Loop System with Lead-Lag Compensator');

