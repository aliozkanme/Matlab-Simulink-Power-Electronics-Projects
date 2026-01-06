% =========================================================================
% PROJECT 06: 3-Phase Full-Wave Rectifier with Source Inductance
% Analytical Solution using MATLAB Symbolic Toolbox
% =========================================================================

clear; clc;

% --- 1. SYSTEM PARAMETERS ---
f = 50;
w = 2 * pi * f;           % Angular frequency (rad/s)
Ls = 0.01;                % Source Inductance (10 mH)
I_load = 20;              % Target Load Current (Assumed Constant 20A)
V_LL_rms = 380;           % Line-to-Line RMS Voltage
Vm_LL = V_LL_rms * sqrt(2); % Peak Line-to-Line Voltage (Vm)
alpha_deg = 30;           % Firing Angle
alpha_rad = deg2rad(alpha_deg);

fprintf('--- PROJECT 06 CALCULATION RESULTS ---\n');
fprintf('Source Inductance (Ls): %.3f H\n', Ls);
fprintf('Load Current (Id):      %.1f A\n', I_load);

% --- 2. COMMUTATION ANGLE CALCULATION (Mu) ---
% For 3-Phase Full Bridge, commutation is governed by Line Voltage.
% Formula: cos(alpha + mu) = cos(alpha) - (2*w*Ls*Id) / (Vm_LL)

val_cos_alpha_mu = cos(alpha_rad) - ((2 * w * Ls * I_load) / Vm_LL);
alpha_plus_mu = acos(val_cos_alpha_mu); % This is (alpha + mu)
mu_rad = alpha_plus_mu - alpha_rad;     % Commutation Angle (radians)
mu_deg = rad2deg(mu_rad);               % Commutation Angle (degrees)

fprintf('Commutation Angle (mu): %.2f degrees\n', mu_deg);

% --- 3. AVERAGE LOAD VOLTAGE (Vdc) ---
% Formula for Full Converter with overlap:
% Vdc = (3*Vm_LL / pi) * cos(alpha) - (3*w*Ls*Id / pi)
% Term 1: Ideal Voltage
% Term 2: Voltage Drop due to Commutation (3*w*Ls*Id/pi)

V_ideal = (3 * Vm_LL / pi) * cos(alpha_rad);
V_drop  = (3 * w * Ls * I_load) / pi;
V_load_avg = V_ideal - V_drop;

fprintf('1. Average Load Voltage:    %.2f V\n', V_load_avg);

% --- 4. RMS SOURCE CURRENT (Is_rms) ---
% In a 3-Phase Full Converter, current flows in two pulses per cycle 
% (Positive and Negative), each lasting 120 degrees (2*pi/3).
% With Ls, the pulses are trapezoidal (rising edge mu, flat top, falling edge mu).

% Ideal RMS (without Ls) approximation:
I_ideal_rms = I_load * sqrt(2/3); 
fprintf('   (Ideal Rectangular RMS): %.2f A\n', I_ideal_rms);

% Exact RMS with Commutation:
syms theta; 

% Current equation during rising commutation (from 0 to Id)
% Driven by Line Voltage commutation loop
% i_rise(theta) = (Vm_LL / (2*w*Ls)) * (cos(alpha) - cos(theta))
% Valid for theta from alpha to alpha+mu
coeff = Vm_LL / (2 * w * Ls);
i_rising = coeff * (cos(alpha_rad) - cos(theta));

% Energy Calculation:
% 1. Rising Edge (alpha to alpha+mu)
E_rise = int(i_rising^2, theta, alpha_rad, alpha_plus_mu);

% 2. Flat Top (Conduction)
% Total pulse width is 120 deg (2*pi/3). Flat part = 2*pi/3 - mu
theta_flat = (2*pi/3) - mu_rad;
E_flat = (I_load^2) * theta_flat;

% 3. Falling Edge
% Assuming symmetry for RMS energy contribution
E_fall = E_rise;

% Total RMS Calculation
% Source current has 2 pulses (positive and negative) in one period (2*pi)
% I_rms = sqrt( (1/2pi) * 2 * (E_rise + E_flat + E_fall) )
val_integral_total = double(E_rise + E_flat + E_fall);
I_source_rms = sqrt((2 / (2 * pi)) * val_integral_total);

fprintf('2. RMS Source Current:      %.2f A\n', I_source_rms);