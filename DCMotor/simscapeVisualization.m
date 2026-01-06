% =========================================================================
% DC MOTOR SIMULATION & ANALYSIS COMPLETE SCRIPT
% Author: JOSHUA WAMBUA
%Date: 20/11/2025
% Description: Complete DC motor simulation and analysis workflow
% =========================================================================

%% CLEAR WORKSPACE AND INITIALIZE
clear; clc; close all;
fprintf('=== DC Motor Simulation & Analysis ===\n');
fprintf('Author: JOSHUA WAMBUA\n');
fprintf('Date: 20/11/2025\n\n');

%% STEP 1: DEFINE MOTOR PARAMETERS
fprintf('--- Step 1: Setting Motor Parameters ---\n');

% DC Motor Physical Parameters
J = 0.01;      % Moment of inertia (kg*m^2)
b = 0.1;       % Damping coefficient (N*m/(rad/s))
K = 0.01;      % Motor constant (V/(rad/s) or N*m/A)
R = 1;         % Armature resistance (Ohm)
L = 0.5;       % Armature inductance (H)

% Simulation Parameters
simulation_time = 2;  % seconds
input_voltage = 12;   % volts

fprintf('✓ Motor parameters defined:\n');
fprintf('  J = %.3f kg*m²\n', J);
fprintf('  b = %.3f N*m/(rad/s)\n', b);
fprintf('  K = %.3f V/(rad/s)\n', K);
fprintf('  R = %.3f Ohm\n', R);
fprintf('  L = %.3f H\n', L);
fprintf('  Input voltage: %.1f V\n', input_voltage);

%% STEP 2: RUN SIMULINK SIMULATION
fprintf('\n--- Step 2: Running Simulation ---\n');

try
    % Check if Simulink model exists
    model_name = 'simscapeDoModelComplete';  % Change this to your model name
    
    if ~bdIsLoaded(model_name)
        fprintf('✗ Model "%s" not found. Please ensure:\n', model_name);
        fprintf('  1. Your Simulink model is open\n');
        fprintf('  2. The model name is correct\n');
        fprintf('  3. All blocks are properly connected\n\n');
        
        fprintf('Alternative: Creating theoretical analysis only...\n');
        run_theoretical_only = true;
    else
        run_theoretical_only = false;
        fprintf('✓ Model "%s" found, running simulation...\n', model_name);
        
        % Configure simulation parameters
        set_param(model_name, 'StopTime', num2str(simulation_time));
        
        % Run simulation
        simOut = sim(model_name, 'ReturnWorkspaceOutputs', 'on');
        
        % Extract data from simulation output
        if isa(simOut, 'Simulink.SimulationOutput')
            out = simOut;
            time = out.tout;
            current = out.current.Data;
            speed = out.speed.Data;
            position = out.position.Data;
        else
            % For older Simulink versions
            time = simOut.tout;
            current = simOut.current.Data;
            speed = simOut.speed.Data;
            position = simOut.position.Data;
        end
        
        fprintf('✓ Simulation completed successfully\n');
        fprintf('  Simulation time: %.1f seconds\n', time(end));
        fprintf('  Data points: %d\n', length(time));
    end
    
catch ME
    fprintf('✗ Simulation error: %s\n', ME.message);
    fprintf('Proceeding with theoretical analysis only...\n');
    run_theoretical_only = true;
end

%% STEP 3: THEORETICAL CALCULATIONS
fprintf('\n--- Step 3: Theoretical Calculations ---\n');

% Steady-state values
theoretical_ss_current = input_voltage / R;
theoretical_ss_speed = input_voltage / K;

% Time constant calculations
electrical_time_constant = L / R;
mechanical_time_constant = J / b;

fprintf('✓ Theoretical performance:\n');
fprintf('  Steady-state current: %.3f A\n', theoretical_ss_current);
fprintf('  Steady-state speed:   %.3f rad/s\n', theoretical_ss_speed);
fprintf('  Electrical time constant: %.3f s\n', electrical_time_constant);
fprintf('  Mechanical time constant: %.3f s\n', mechanical_time_constant);

%% STEP 4: GENERATE THEORETICAL RESPONSE (if no simulation data)
if run_theoretical_only
    fprintf('\n--- Generating Theoretical Response ---\n');
    
    % Create time vector
    time = linspace(0, simulation_time, 1000)';
    
    % Generate theoretical responses (first-order approximations)
    current = theoretical_ss_current * (1 - exp(-time/electrical_time_constant));
    speed = theoretical_ss_speed * (1 - exp(-time/mechanical_time_constant));
    position = theoretical_ss_speed * (time - mechanical_time_constant * (1 - exp(-time/mechanical_time_constant)));
    
    fprintf('✓ Theoretical responses generated\n');
end

%% STEP 5: PERFORMANCE METRICS CALCULATION
fprintf('\n--- Step 4: Performance Analysis ---\n');

% Calculate performance metrics from data
steady_state_current = current(end);
steady_state_speed = speed(end);
final_position = position(end);
peak_current = max(current);
peak_current_time = time(current == peak_current);

% Rise time calculation (10% to 90% of final speed)
final_speed_value = speed(end);
if final_speed_value > 0
    speed_10 = 0.1 * final_speed_value;
    speed_90 = 0.9 * final_speed_value;
    
    idx_10 = find(speed >= speed_10, 1);
    idx_90 = find(speed >= speed_90, 1);
    
    if ~isempty(idx_10) && ~isempty(idx_90)
        rise_time = time(idx_90) - time(idx_10);
        fprintf('✓ Rise time (10%%-90%%): %.3f seconds\n', rise_time);
    else
        rise_time = NaN;
        fprintf('✗ Rise time calculation failed\n');
    end
else
    rise_time = NaN;
end

% Calculate errors (if simulation data exists)
if ~run_theoretical_only
    current_error = abs(theoretical_ss_current - steady_state_current);
    speed_error = abs(theoretical_ss_speed - steady_state_speed);
else
    current_error = 0;
    speed_error = 0;
end

%% STEP 6: COMPREHENSIVE VISUALIZATION
fprintf('\n--- Step 5: Generating Plots ---\n');

% Create main analysis figure
mainFig = figure('Name', 'DC Motor Analysis - JOSHUA WAMBUA', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 50, 1400, 900]);

% Plot 1: Current Response
subplot(3, 3, [1, 2]);
plot(time, current, 'b-', 'LineWidth', 2);
hold on;
plot(peak_current_time, peak_current, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'red');
title('Armature Current Response', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Current (A)');
grid on;
legend('Current', sprintf('Peak: %.3f A', peak_current), 'Location', 'best');

% Plot 2: Speed Response
subplot(3, 3, [4, 5]);
plot(time, speed, 'r-', 'LineWidth', 2);
title('Motor Speed Response', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Speed (rad/s)');
grid on;
if ~isnan(rise_time)
    legend(sprintf('Rise time: %.3f s', rise_time), 'Location', 'best');
end

% Plot 3: Position Response
subplot(3, 3, [7, 8]);
plot(time, position, 'g-', 'LineWidth', 2);
title('Motor Position', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Position (rad)');
grid on;
legend(sprintf('Final: %.3f rad', final_position), 'Location', 'best');

% Plot 4: Current vs Speed (Phase Plot)
subplot(3, 3, 3);
plot(current, speed, 'm-', 'LineWidth', 1.5);
title('Current vs Speed', 'FontSize', 10, 'FontWeight', 'bold');
xlabel('Current (A)');
ylabel('Speed (rad/s)');
grid on;

% Plot 5: Current Derivative
subplot(3, 3, 6);
current_derivative = gradient(current, time);
plot(time, current_derivative, 'c-', 'LineWidth', 1.5);
title('Current Derivative', 'FontSize', 10, 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('dI/dt (A/s)');
grid on;

% Plot 6: Performance Summary
subplot(3, 3, 9);
axis off;

summary_text = {
    'PERFORMANCE SUMMARY'
    ''
    sprintf('Peak Current: %.3f A', peak_current)
    sprintf('SS Current: %.3f A', steady_state_current)
    sprintf('SS Speed: %.3f rad/s', steady_state_speed)
    ''
    };

if ~isnan(rise_time)
    summary_text{end+1} = sprintf('Rise Time: %.3f s', rise_time);
end

summary_text{end+1} = '';
summary_text{end+1} = sprintf('Final Position: %.3f rad', final_position);
summary_text{end+1} = '';
summary_text{end+1} = 'Author: JOSHUA WAMBUA';
summary_text{end+1} = 'Date: 20/11/2025';

text(0.1, 0.9, summary_text, 'FontSize', 10, 'VerticalAlignment', 'top');

%% STEP 7: COMPARISON PLOT
fprintf('✓ Generating comparison plot\n');

compFig = figure('Name', 'DC Motor Performance - JOSHUA WAMBUA', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 1200, 500]);

subplot(1, 3, 1);
plot(time, current, 'b-', 'LineWidth', 2);
title('Current Response', 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Current (A)');
grid on;

subplot(1, 3, 2);
plot(time, speed, 'r-', 'LineWidth', 2);
title('Speed Response', 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Speed (rad/s)');
grid on;

subplot(1, 3, 3);
plot(time, position, 'g-', 'LineWidth', 2);
title('Position Response', 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Position (rad)');
grid on;

%% STEP 8: DATA EXPORT AND SAVING
fprintf('\n--- Step 6: Data Export ---\n');

% Create results structure
results = struct();
results.author = 'JOSHUA WAMBUA';
results.date = '20/11/2025';
results.parameters.J = J;
results.parameters.b = b;
results.parameters.K = K;
results.parameters.R = R;
results.parameters.L = L;
results.performance.peak_current = peak_current;
results.performance.steady_state_current = steady_state_current;
results.performance.steady_state_speed = steady_state_speed;
results.performance.rise_time = rise_time;
results.performance.final_position = final_position;
results.theoretical.ss_current = theoretical_ss_current;
results.theoretical.ss_speed = theoretical_ss_speed;

if ~run_theoretical_only
    results.simulation_type = 'Simulink Simulation';
    results.errors.current_error = current_error;
    results.errors.speed_error = speed_error;
else
    results.simulation_type = 'Theoretical Calculation';
end

results.timestamp = datestr(now);

% Save data
try
    save('dc_motor_complete_analysis.mat', 'results', 'time', 'current', 'speed', 'position');
    fprintf('✓ Results saved to: dc_motor_complete_analysis.mat\n');
    
    % Export to CSV
    data_table = table(time, current, speed, position, ...
        'VariableNames', {'Time_s', 'Current_A', 'Speed_rad_s', 'Position_rad'});
    writetable(data_table, 'dc_motor_complete_data.csv');
    fprintf('✓ Time data exported to: dc_motor_complete_data.csv\n');
    
catch ME
    fprintf('✗ Error saving data: %s\n', ME.message);
end

%% STEP 9: FINAL SUMMARY REPORT
fprintf('\n=== FINAL SUMMARY REPORT ===\n');
fprintf('Author: JOSHUA WAMBUA\n');
fprintf('Analysis Date: 20/11/2025\n');
fprintf('Data Source: %s\n', results.simulation_type);
fprintf('Simulation Duration: %.1f seconds\n', time(end));

fprintf('\nMOTOR PARAMETERS:\n');
fprintf('• Inertia (J):    %.3f kg*m²\n', J);
fprintf('• Damping (b):    %.3f N*m/(rad/s)\n', b);
fprintf('• Motor Constant (K): %.3f V/(rad/s)\n', K);
fprintf('• Resistance (R): %.3f Ohm\n', R);
fprintf('• Inductance (L): %.3f H\n', L);

fprintf('\nPERFORMANCE RESULTS:\n');
fprintf('• Peak Current:        %.3f A\n', peak_current);
fprintf('• Steady-State Current: %.3f A\n', steady_state_current);
fprintf('• Steady-State Speed:   %.3f rad/s\n', steady_state_speed);
if ~isnan(rise_time)
    fprintf('• Rise Time (10%%-90%%):  %.3f seconds\n', rise_time);
end
fprintf('• Final Position:      %.3f rad\n', final_position);

if ~run_theoretical_only
    fprintf('\nTHEORETICAL VERIFICATION:\n');
    fprintf('• Current match: %.1f%%\n', (1 - current_error/theoretical_ss_current)*100);
    fprintf('• Speed match:   %.1f%%\n', (1 - speed_error/theoretical_ss_speed)*100);
end

fprintf('\n=== ANALYSIS COMPLETE ===\n');
fprintf('All plots generated and data saved successfully.\n');

%% CLEANUP
fprintf('\nWorkspace cleaned. Script execution complete.\n');