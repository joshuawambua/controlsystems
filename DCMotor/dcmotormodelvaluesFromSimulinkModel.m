%This is the control effort of the lead and lag compensators

t = out.tout;

lag  = out.lagCompensatorG;
lead = out.leadCompensatorG;

figure;

subplot(2,1,1)
plot(t, lag, 'LineWidth', 1.3);
grid on
title("Lag Compensator Output");
xlabel("Time (seconds)");
ylabel("Voltage(control effort)");

subplot(2,1,2)
plot(t, lead, 'LineWidth', 1.3);
grid on
title("Lead Compensator Output");
xlabel("Time (seconds)");
ylabel("Voltage(control effort)");
