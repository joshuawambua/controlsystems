
%Author :Joshua muthenya Wambua
%date: 26/10/2025.

%% lag_compensator.m
% Improves steady-state accuracy but slows down the response

clear; close all; clc;
s = tf('s');

% Example lag compensator: C(s) = (s+0.2)/(s+0.11)
C = (s + 0.2) / (s + 0.11);

figure('Name','Lag Compensator');
subplot(1,2,1);
bode(C); grid on;
title('Bode Plot - Lag Compensator');

subplot(1,2,2);
step(C/(1+C)); grid on;
title('Step Response (unit feedback)');

disp('Lag Compensator: increases low-frequency gain (accuracy) but slows transient response.');
