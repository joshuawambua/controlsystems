
% Define the plant transfer function
G = tf([1], [1 2 10]);  % Example: G(s) = 1 / (s^2 + 2s + 10)
 
% Define Lead compensator parameters
z = 1;  % Zero of the Lead compensator
p = 10; % Pole of the Lead compensator
K = 1;  % Gain factor
 
% Lead compensator transfer function
G_lead = K * tf([1 z], [1 p]);
 
% Closed-loop system with Lead compensator
G_closed_loop_lead = feedback(G * G_lead, 1);
 
% Plot Bode plots
figure;
bode(G_closed_loop_lead);
grid on;
 
% Step response
figure;
step(G_closed_loop_lead);
title('Step Response of Closed-Loop System with Lead Compensator');
