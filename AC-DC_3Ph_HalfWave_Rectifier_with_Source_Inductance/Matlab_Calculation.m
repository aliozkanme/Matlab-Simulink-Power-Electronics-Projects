% =========================================================================
% PROJECT 05: 3-Phase Half-Wave Rectifier with Source Inductance
% Analytical Solution using MATLAB Symbolic Toolbox
% =========================================================================

clear; clc;

% --- 1. SYSTEM PARAMETERS ---
f = 50;
w = 2 * pi * f;          % Angular frequency (rad/s)
Ls = 0.01;               % Source Inductance (10 mH)
I_load = 20;             % Target Load Current (Assumed Constant 20A)
V_LL_rms = 380;          % Line-to-Line RMS Voltage
Vm_phase = (V_LL_rms / sqrt(3)) * sqrt(2); % Peak Phase Voltage (Vm)
alpha_rad = pi/6;        % Firing Angle (30 degrees)

fprintf('--- PROJECT 05 CALCULATION RESULTS ---\n');
fprintf('Source Inductance (Ls): %.3f H\n', Ls);
fprintf('Load Current (Id):      %.1f A\n', I_load);

% --- 2. COMMUTATION ANGLE CALCULATION (Mu) ---
% The presence of Ls causes current overlap (commutation).
% Formula: cos(alpha + mu) = cos(alpha) - (2*w*Ls*Id) / (sqrt(3)*Vm)

val_cos_alpha_mu = cos(alpha_rad) - ((2 * w * Ls) / (sqrt(3) * Vm_phase)) * I_load;
alpha_plus_mu = acos(val_cos_alpha_mu); % This is (alpha + mu)
mu_rad = alpha_plus_mu - alpha_rad;     % Commutation Angle (radians)
mu_deg = rad2deg(mu_rad);               % Commutation Angle (degrees)

fprintf('Commutation Angle (mu): %.2f degrees\n', mu_deg);

% --- 3. AVERAGE LOAD VOLTAGE (Vdc) ---
% Formula with commutation drop:
% Vdc = (3*sqrt(3)*Vm / 4*pi) * (cos(alpha) + cos(alpha+mu))

V_load_avg = ((3 * sqrt(3) * Vm_phase) / (4 * pi)) * (cos(alpha_rad) + val_cos_alpha_mu);
fprintf('1. Average Load Voltage:    %.2f V\n', V_load_avg);

% --- 4. RMS SOURCE CURRENT (Is_rms) ---
% The source current has a rising edge (during mu), a flat top, and a falling edge.
% We calculate the energy in one period (2*pi) and take the root.

syms theta; % Symbolic angle variable

% Current equation during commutation (Rising Edge)
% i_comm(theta) = (sqrt(3)*Vm / 2*w*Ls) * (cos(alpha) - cos(theta))
% This is valid for theta from 'alpha' to 'alpha + mu'
i_rising = ((sqrt(3) * Vm_phase) / (2 * w * Ls)) * (cos(alpha_rad) - cos(theta));

% A) Energy during rising edge (Commutation 1)
% Integrate i^2 from alpha to alpha+mu
E_rise = int(i_rising^2, theta, alpha_rad, alpha_plus_mu);

% B) Energy during flat top (Conduction)
% Conduction lasts for (2*pi/3 - mu) radians in half-wave 3-phase.
% Constant current = I_load
theta_flat = (2*pi/3) - mu_rad;
E_flat = (I_load^2) * theta_flat;

% C) Energy during falling edge (Commutation 2)
% Due to symmetry in squared integration for linear approximations, 
% we can approximate the falling edge energy as equal to the rising edge energy 
% for the RMS calculation in this topology.
E_fall = E_rise; 

% Total RMS Calculation
% Factor 1/(2*pi) for averaging over full period
val_integral_total = double(E_rise + E_flat + E_fall);
I_source_rms = sqrt((1 / (2 * pi)) * val_integral_total);

fprintf('2. RMS Source Current:      %.2f A\n', I_source_rms);