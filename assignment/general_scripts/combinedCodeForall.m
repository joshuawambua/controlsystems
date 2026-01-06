
% =========================================================
% CONTROL SYSTEMS II – COMPENSATOR DESIGN
% Author: Joshua Wambua
% Reg No: EG209/109705/22
% Table 1 – Question 1 (First-Order System)
% =========================================================
clc; clear; close all;

% --- Lead compensator ---
G_lead = tf([1 1], [1 3]);   

% --- Lag compensator ---
G_lag = tf([1 0.5], [1 0.05]); 

G_comp = G_lead * G_lag;  % Combined compensator

% --- Time vector ---
t = 0:0.01:5;

% --- Colors for plotting ---
colors = lines(8);  % 8 distinguishable colors

% --- Figure ---
figure; hold on;

for a = 3:10
    % Define first-order system
    G = tf(1, [1 a]);
    
    % Step response (uncompensated)
    y_uncomp = step(G, t);
    
    % Closed-loop with compensator
    G_closed = feedback(G * G_comp, 1);
    
    % Step response (compensated)
    y_comp = step(G_closed, t);
    
    % Plot uncompensated (dashed)
    plot(t, y_uncomp, '--', 'Color', colors(a-2,:), 'LineWidth', 1);
    
    % Plot compensated (solid)
    plot(t, y_comp, 'Color', colors(a-2,:), 'LineWidth', 1.5);
end

grid on;
xlabel('Time (s)');
ylabel('Response');
title('Step Responses of First-Order Systems with Lead-Lag Compensation (a = 3 to 10)');
legend('Uncomp a=3','Comp a=3','Uncomp a=4','Comp a=4','Uncomp a=5','Comp a=5',...
       'Uncomp a=6','Comp a=6','Uncomp a=7','Comp a=7','Uncomp a=8','Comp a=8',...
       'Uncomp a=9','Comp a=9','Uncomp a=10','Comp a=10');
