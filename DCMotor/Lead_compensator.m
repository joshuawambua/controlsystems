

%Author :Joshua muthenya Wambua
%date: 26/10/2025.

%% lead_compensator.m
% Improves speed and stability (adds positive phase)

clear; close all; clc;
s = tf('s');

% Example lead compensator: C(s) = (s+10)/(s+100)
C = (s + 10) / (s + 100);

figure('Name','Lead Compensator');
subplot(1,2,1);
bode(C); grid on;
title('Bode Plot - Lead Compensator');

subplot(1,2,2);
step(C/(1+C)); grid on;
title('Step Response (unit feedback)');

disp('Lead Compensator: increases speed and phase margin, improves stability but may raise overshoot.');
