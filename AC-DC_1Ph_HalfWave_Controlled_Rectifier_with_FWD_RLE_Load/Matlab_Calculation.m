% =========================================================================
% PROJECT: Single-Phase Controlled Rectifier with Freewheeling Diode
% Load Type: R-L-E (Resistor + Inductor + Back EMF)
% Analytical Solution using MATLAB Symbolic Toolbox
% =========================================================================

clear; clc;

% --- 1. SYSTEM PARAMETERS ---
Vm = 220 * sqrt(2); % Peak Voltage
f = 50;             % Frequency
w = 2 * pi * f;     % Angular Frequency
R = 1;              % Resistance
L = 0.01;           % Inductance (10 mH)
E = 220;            % Back EMF

% Firing Angle (Must be > 45 deg since E=220V and Vm=311V) that's why used t=1/200s which is 90 degrees.

syms wt;            % Symbolic variable for angle

% =========================================================================
% --- 2. SOLVING DIFFERENTIAL EQUATION ---
% Differential Equation: Vm*sin(wt) - E = L(di/dt) + R*i
% Initial Condition: Current is 0 at t = 1/200s (90 degrees or pi/2)
% =========================================================================

i_load_sym = vpa(dsolve('220*sqrt(2)*sin(2*pi*50*t)-220 = 0.01*Dx + 1*x', 'x(1/200)=0'), 3);

% Substitute time variable 't' with angular variable 'wt' (theta)
% t = wt / w
q = subs(i_load_sym, 't', (wt/(2*pi*50)));

% =========================================================================
% --- 3. CALCULATIONS ---
% =========================================================================
disp('--- CALCULATION RESULTS ---');

% A) AVERAGE LOAD CURRENT
% Integration limits used in original file: pi/2 to (pi - pi/18)
I_avg_val = (1/(2*pi)) * int(q, pi/2, pi - pi/18);
I_load_avg = double(I_avg_val);
fprintf('1. Average Load Current:      %.4f A\n', I_load_avg);

% B) RMS LOAD CURRENT
% Calculation of effective (RMS) current squared, then sqrt
val_rms_int = (1/(2*pi)) * int(q^2, pi/2, pi - pi/18);
I_load_rms = double(sqrt(val_rms_int));
fprintf('2. RMS Load Current:          %.4f A\n', I_load_rms);

% C) AVERAGE LOAD VOLTAGE
% Using the loop equation average: V_avg = I_avg * R + E
V_load_avg = R * (double(I_load_avg)) + 220;
fprintf('3. Average Load Voltage:      %.4f V\n', double(V_load_avg));

% D) RMS SOURCE CURRENT
% In this logic, Source Current is calculated identically to Load RMS
val_src_int = (1/(2*pi)) * int(q^2, pi/2, pi - pi/18);
I_source_rms = double(sqrt(val_src_int));
fprintf('4. RMS Source Current:        %.4f A\n', I_source_rms);