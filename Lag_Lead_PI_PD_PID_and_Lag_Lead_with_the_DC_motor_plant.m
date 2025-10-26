
%Author :Joshua muthenya Wambua
%date: 26/10/2025.


%% compensator_comparison.m
% Compare Lag, Lead, PI, PD, PID, and Lag-Lead on the DC motor plant

clear; close all; clc;

% --- Plant parameters (from your doc) ---
J = 0.01;
b = 0.1;
K = 0.01;
R = 1;
L = 0.5;
s = tf('s');

% Plant transfer function: Omega(s)/V(s)
P = K/((J*s + b)*(L*s + R) + K^2);
P = minreal(P);     % simplify
disp('Plant (P):');
zpk(P)

% --- Define compensators ---
% 1) Lag (from your doc)
C_lag = tf([44 44],[1 0.01]);

% 2) Lead (from your doc)
C_lead = tf([160000 5.6e6],[1 1035]);

% 3) PI example (common form: Kp (1 + 1/(Ti*s)) )
Kp_PI = 20; Ti = 0.5;         % example starting values - you can tune
C_PI = Kp_PI*(1 + 1/(Ti*s));

% 4) PD example (with small filter on derivative to avoid noise)
Kp_PD = 2; Td = 0.01;
N = 50;                       % derivative filter coeff -> D*s/(1+1/(N*s))
C_PD = Kp_PD*(1 + Td*s/(1 + Td*s/N));

% 5) PID via pidtune (auto tuning, good starting point)
try
    [C_pid_aut,info] = pidtune(P,'PID');  % automatic tuning
    C_PID = C_pid_aut;
catch
    % fallback: manual PID if pidtune not available
    Kp = 50; Ki = 100; Kd = 0.1;
    C_PID = pid(Kp,Ki,Kd);
end

% 6) Lag-Lead (cascade)
C_laglead = minreal(C_lag * C_lead);

% Put controllers in an array for looping
controllers = { ...
    C_lag, 'Lag'; ...
    C_lead, 'Lead'; ...
    C_PI,  'PI'; ...
    C_PD,  'PD'; ...
    C_PID, 'PID'; ...
    C_laglead, 'Lag-Lead' ...
};

% --- Plot Bode of open-loop L = C*P for each controller ---
figure('Name','Bode: Open-loop L = C*P','Units','normalized','Position',[0.05 0.55 0.9 0.4]);
hold on;
for k = 1:size(controllers,1)
    C = controllers{k,1};
    L = minreal(C*P);
    bodeplot(L,{1e-1,1e4}); % frequency range
end
grid on; legend(controllers(:,2));
title('Bode plots of L(s)=C(s)P(s) for each compensator');
hold off;

% --- Closed-loop responses and control effort ---
tfinal = 2; t = linspace(0,tfinal,2000);
figure('Name','Closed-loop step responses','Units','normalized','Position',[0.05 0.05 0.43 0.45]);
hold on;
colors = lines(size(controllers,1));
stepResults = struct();
for k = 1:size(controllers,1)
    C = controllers{k,1};
    name = controllers{k,2};
    L = minreal(C*P);
    CL = feedback(L,1);                 % closed-loop from reference to output
    % Obtain step response
    [y,tt] = step(CL,t);
    plot(tt,y,'Color',colors(k,:),'LineWidth',1.5);
    % Control effort U(s) = C(s) / (1 + C(s)P(s))  for unit step reference
    U = minreal(C/(1 + L));
    [u,~] = step(U,t);
    stepResults.(name).t = tt;
    stepResults.(name).y = y;
    stepResults.(name).u = u;
    % compute performance metrics
    si = stepinfo(y,tt);
    ess = 1 - dcgain(CL); % steady-state error for unit step
    stepResults.(name).stepinfo = si;
    stepResults.(name).ess = ess;
end
legend(controllers(:,2),'Location','best');
xlabel('Time (s)'); ylabel('Speed (rad/s)');
title('Closed-loop step responses (reference = 1)');
grid on; hold off;

% --- Plot Control Effort ---
figure('Name','Control Effort (U) for unit step','Units','normalized','Position',[0.5 0.05 0.43 0.45]);
hold on;
for k = 1:size(controllers,1)
    name = controllers{k,2};
    plot(stepResults.(name).t, stepResults.(name).u,'Color',colors(k,:),'LineWidth',1.2);
end
legend(controllers(:,2),'Location','best');
xlabel('Time (s)'); ylabel('Control effort (V)');
title('Control effort u(t) for unit step reference');
grid on; hold off;

% --- Compute margins and display summary table ---
fprintf('\nSummary (steady-state error, rise time, settling time, overshoot):\n');
fprintf('Controller\t ess\t\trise(s)\t\tsettle(s)\tovershoot(%%)\tGainMargin(dB) PhaseMargin(deg)\n');
for k = 1:size(controllers,1)
    C = controllers{k,1};
    name = controllers{k,2};
    L = minreal(C*P);
    CL = feedback(L,1);
    si = stepResults.(name).stepinfo;
    ess = stepResults.(name).ess;
    % margins
    try
        [Gm,Pm,Wcg,Wcp] = margin(L);
        GmdB = 20*log10(Gm);
    catch
        GmdB = NaN; Pm = NaN;
    end
    fprintf('%-10s\t%6.3f\t%6.3f\t%6.3f\t%8.2f\t%8.2f\t%8.2f\n', name, ess, si.RiseTime, si.SettlingTime, si.Overshoot, GmdB, Pm);
end

% --- Display PID controller if auto tuned ---
if exist('info','var')
    fprintf('\nPID autotune info:\n');
    info
    disp('Auto tuned PID controller:'); C_PID
else
    disp('PID controller used (manual or fallback):'); C_PID
end

% End
