%Author :Joshua muthenya Wambua
%date: 26/10/2025.

%% PD_controller.m
% Speeds up response and reduces overshoot

clear; close all; clc;
s = tf('s');

Kp = 1; Kd = 0.2;
C = Kp + Kd*s;             % PD controller transfer function

figure('Name','PD Controller');
subplot(1,2,1);
bode(C); grid on;
title('Bode Plot - PD Controller');

subplot(1,2,2);
step(C/(1+C)); grid on;
title('Step Response (unit feedback)');

disp('PD-controller: improves damping and response speed but cannot remove steady-state error.');
