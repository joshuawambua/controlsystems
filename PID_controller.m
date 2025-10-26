
%Author :Joshua muthenya Wambua
%date: 26/10/2025.

%% PID_controller.m
% Combines proportional, integral, and derivative actions

clear; close all; clc;
s = tf('s');

Kp = 2; Ki = 5; Kd = 0.1;
C = Kp + Ki/s + Kd*s;      % PID controller transfer function

figure('Name','PID Controller');
subplot(1,2,1);
bode(C); grid on;
title('Bode Plot - PID Controller');

subplot(1,2,2);
step(C/(1+C)); grid on;
title('Step Response (unit feedback)');

disp('PID-controller: balances speed, stability, and zero steady-state error if tuned properly.');
