%% lag_lead_compensator.m
% Combines lag (accuracy) and lead (speed) effects

clear; close all; clc;
s = tf('s');

% Example lag-lead: C(s) = [(s+0.1)/(s+0.01)] * [(s+10)/(s+100)]
C = ((s + 0.1)/(s + 0.01)) * ((s + 10)/(s + 100));

figure('Name','Lag-Lead Compensator');
subplot(1,2,1);
bode(C); grid on;
title('Bode Plot - Lag–Lead Compensator');

subplot(1,2,2);
step(C/(1+C)); grid on;
title('Step Response (unit feedback)');

disp('Lag–Lead Compensator: combines speed of lead and accuracy of lag for balanced performance.');
