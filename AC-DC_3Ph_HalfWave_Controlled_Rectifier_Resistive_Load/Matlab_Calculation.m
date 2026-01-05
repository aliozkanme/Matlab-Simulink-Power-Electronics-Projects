% =========================================================================
% PROJECT: 3-Phase Half-Wave Controlled Rectifier (Resistive Load)
% Analytical Solution using MATLAB Symbolic Toolbox
% =========================================================================

clear; clc;

% --- 1. SYSTEM PARAMETERS ---
V_LL_rms = 380;                  % Line-to-Line RMS Voltage (V)
V_ph_rms = V_LL_rms / sqrt(3);   % Phase-to-Neutral RMS Voltage (V)
Vm = V_ph_rms * sqrt(2);         % Peak Phase Voltage (V)

R = 10;                          % Load Resistance (Ohm)
alpha_deg = 45;                  % Firing Angle (Degrees)
alpha_rad = deg2rad(alpha_deg);  % Firing Angle (Radians)

syms wt; % Symbolic variable for angle (omega * t)

% --- 2. DEFINE CONDUCTION INTERVALS ---
% For 3-Phase Half-Wave with R-Load:
% Natural commutation point is at 30 degrees (pi/6).
% Firing instant: theta_start = 30 + alpha
% Extinction instant: For R load, current stops when Vphase < 0 (at 180 degrees/pi).
% Check if alpha implies discontinuous mode (alpha > 30 for R-load in 3-ph half-wave)

theta_start = (pi/6) + alpha_rad; 
theta_end   = pi; % Due to Resistive load, conduction stops at zero crossing.

% --- 3. CALCULATE POWER ---
% Instantaneous Power p(t) = v(t)^2 / R
% We integrate over one output pulse (which repeats 3 times per grid cycle).
% The factor 3/(2*pi) averages it over the full grid cycle (2*pi).

p_inst = (Vm * sin(wt))^2 / R;

% Calculate Average Active Power (P_load)
P_load_sym = (3 / (2*pi)) * int(p_inst, wt, theta_start, theta_end);
P_load = double(P_load_sym);

fprintf('--- CALCULATION RESULTS ---\n');
fprintf('1. Total Active Power Absorbed by Load: %.2f W\n', P_load);

% For a pure rectifier without losses, Grid Power = Load Power
fprintf('2. Total Active Power Drawn from Grid:  %.2f W\n', P_load);

% --- Validation Parameters for Simulink ---
fprintf('\n--- VALIDATION PARAMETERS ---\n');
fprintf('Phase Voltage Peak (Vm): %.2f V\n', Vm);
fprintf('Start Angle (deg):       %.2f\n', rad2deg(theta_start));
fprintf('End Angle (deg):         %.2f\n', rad2deg(theta_end));