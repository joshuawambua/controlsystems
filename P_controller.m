
%Author :Joshua muthenya Wambua
%date: 26/10/2025.

%% P_controller.m
% Author: Joshua Muthenya Wambua
% Description: Basic proportional controller

clear; close all; clc;
s = tf('s');

Kp = 10;                  % Proportional gain
C = Kp;                   % Controller transfer function

% Frequency and step response
figure('Name','Proportional Controller');
subplot(1,2,1);
bode(C); grid on;
title('Bode Plot - Proportional (P) Controller');

subplot(1,2,2);
step(C/(1+C)); grid on;
title('Step Response (unit feedback)');

disp('P-controller: faster response, reduces steady-state error but may cause overshoot.');
P