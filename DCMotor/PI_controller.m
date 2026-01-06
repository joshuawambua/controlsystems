
%Author :Joshua muthenya Wambua
%date: 26/10/2025.

%% PI_controller.m
% Eliminates steady-state error

clear; close all; clc;
s = tf('s');

Kp = 5; Ki = 20;           % Gains
C = Kp + Ki/s;             % PI controller transfer function

figure('Name','PI Controller');
subplot(1,2,1);
bode(C); grid on;
title('Bode Plot - PI Controller');

subplot(1,2,2);
step(C/(1+C)); grid on;
title('Step Response (unit feedback)');

disp('PI-controller: eliminates steady-state error but slows response and may increase overshoot.');
