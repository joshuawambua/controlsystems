% =========================================================
% CONTROL SYSTEMS II – COMPENSATOR DESIGN
% Author: Joshua Wambua
% Reg No: EG209/109705/22
% Table 1 – Question 1 (First-Order System)
% =========================================================
clc; 
clear; 
close all;

% --- Defining the First-Order System ---
a = 7; 
G = tf(1, [1 a]);

% --- Define Lead Compensator Parameters ---
z_lead = 1; 
p_lead = 10;
K_lead = 2;
G_lead = K_lead * tf([1 z_lead], [1 p_lead]);

% --- Define Lag Compensator Parameters ---
z_lag = 0.1;
p_lag = 0.01;
K_lag = 2;
G_lag = K_lag * tf([1 z_lag], [1 p_lag]);

% --- Combine Lead and Lag (Cascade Compensator) ---
G_lead_lag = G_lead * G_lag;

% --- Closed-Loop System with Compensation ---
G_closed = feedback(G * G_lead_lag, 1);

% --- Define a common simulation time vector ---
t = 0:0.01:10;  % 0 to 10 seconds, step of 0.01

% --- Compute Step Responses ---
y1 = step(G, t);         % Uncompensated system
y2 = step(G_closed, t);  % Compensated system

% --- Plot Step Responses ---
figure;
plot(t, y1, 'b', 'LineWidth', 1.5);
hold on;
plot(t, y2, 'r', 'LineWidth', 1.5);
grid on;
legend('Uncompensated', 'Lead-Lag Compensated');
title('Table 1 – Question 5: First-Order System Compensation (Joshua Wambua)');
xlabel('Time (s)');
ylabel('Response');

% --- Display Performance Information ---
info = stepinfo(G_closed);
disp('Performance Metrics (Compensated System):');
disp(info);
fprintf('Steady-State Error: %.4f\n', abs(1 - dcgain(G_closed)));