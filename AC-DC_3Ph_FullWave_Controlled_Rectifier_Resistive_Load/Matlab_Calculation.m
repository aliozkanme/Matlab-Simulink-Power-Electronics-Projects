% =========================================================================
% PROJECT 04: 1-Phase Full-Wave Controlled Rectifier with RLE Load
% Analytical Solution using MATLAB Symbolic Toolbox
% =========================================================================

clear; clc;

% --- 1. SYSTEM PARAMETERS ---
V_rms_grid = 220;                % Grid Voltage (V)
Vm = V_rms_grid * sqrt(2);       % Peak Voltage (V)
f = 50;                          % Frequency (Hz)
w = 2*pi*f;                      % Angular Frequency (rad/s)
T = 1/f;                         % Period (s)

R = 1;                           % Resistance (Ohm)
L = 0.01;                        % Inductance (10 mH)
E = 220;                         % Back EMF / Battery Voltage (V)
alpha_deg = 90;                  % Firing Angle (Degrees)

% Time conversions
alpha_rad = deg2rad(alpha_deg);
t_alpha = (alpha_deg / 360) * T; % Firing time (s)

fprintf('--- PROJECT 04 CALCULATION RESULTS ---\n');
fprintf('Vm: %.2f V, E: %.2f V, Alpha: %d deg\n', Vm, E, alpha_deg);

% --- 2. CURRENT EQUATION & EXTINCTION ANGLE ---
% Circuit Equation: Vm*sin(wt) = L(di/dt) + R*i + E
% Current starts at t_alpha with i(t_alpha) = 0.

syms t positive
i_sym = dsolve(Vm*sin(w*t) == L*diff(t) + R*t + E, ...
               sprintf('y(%f) = 0', t_alpha), 't');
i_sym = simplify(i_sym);

% Find Extinction Time (t_beta) where Current becomes 0 again.
% We search for a solution after t_alpha.
% Since symbolic solve can be slow/fail on transcendental eq, use numerical fzero.
i_func = matlabFunction(i_sym); 
guess = t_alpha + 0.005; % Guess a bit after alpha
t_beta = fzero(i_func, guess);
beta_deg = (t_beta / T) * 360;

fprintf('Extinction Angle (Beta): %.2f degrees\n', beta_deg);

% Check Conduction Mode
if beta_deg < (180 + alpha_deg)
    fprintf('Mode: Discontinuous Conduction\n');
    t_end = t_beta;
else
    fprintf('Mode: Continuous Conduction (Warning: Code logic assumes discontinuous)\n');
    t_end = t_alpha + T/2;
end

% --- 3. CALCULATE OUTPUT VALUES ---

% A) Average Load Voltage (V_dc)
% Interval 1 (Conducting: t_alpha to t_beta): v_o = |Vm*sin(wt)| (Rectified sine)
% Interval 2 (Non-conducting: t_beta to Next Firing): v_o = E (Battery dominates)
% Full Wave Period is T/2 (0.01s). Next firing is at t_alpha + T/2.

% Note: Since it is full wave, we integrate over T/2.
% V_avg = (2/T) * [ Integral(Vm*sin(wt))_alpha^beta + Integral(E)_beta^(alpha+T/2) ]

v_conducting = Vm * sin(w*t); % Absolute is implied by limits in 1st half cycle
val_v1 = int(v_conducting, t, t_alpha, t_end);
val_v2 = E * ((t_alpha + T/2) - t_end); % Constant E part

V_load_avg = double( (2/T) * (val_v1 + val_v2) );
fprintf('a) Average Load Voltage (Vdc):       %.2f V\n', V_load_avg);


% B) Average Load Current (Idc)
% I_avg = (2/T) * Integral(i(t))_alpha^beta
val_i_avg = integral(i_func, t_alpha, t_end);
I_load_avg = (2/T) * val_i_avg;
fprintf('b) Average Load Current (Idc):       %.2f A\n', I_load_avg);


% C) RMS Load Current (I_rms)
% I_rms = sqrt( (2/T) * Integral(i(t)^2)_alpha^beta )
val_i_rms = integral(@(x) i_func(x).^2, t_alpha, t_end);
I_load_rms = sqrt((2/T) * val_i_rms);
fprintf('c) RMS Load Current:                 %.2f A\n', I_load_rms);


% D) RMS Source Current (Is_rms)
% For Full Wave Rectifier, Source Current shape:
% Positive pulse during + cycle, Negative pulse during - cycle.
% Since i(t)^2 is same for positive and negative, RMS Source = RMS Load.
fprintf('d) RMS Source Current (Grid):        %.2f A\n', I_load_rms);