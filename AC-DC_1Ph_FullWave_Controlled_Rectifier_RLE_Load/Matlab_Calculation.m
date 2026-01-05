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
t_alpha = (alpha_deg / 360) * T; % Firing time (s)

fprintf('--- PROJECT 04 CALCULATION RESULTS ---\n');
fprintf('Vm: %.2f V, E: %.2f V, Alpha: %d deg\n', Vm, E, alpha_deg);

% --- 2. SOLVE DIFFERENTIAL EQUATION ---
% Equation: L(di/dt) + R*i = Vm*sin(wt) - E
% General Solution: i(t) = I_forced + I_natural
% Using dsolve to get the exact symbolic function

syms t i(t)
eqn = L*diff(i, t) + R*i == Vm*sin(w*t) - E;
cond = i(t_alpha) == 0;
i_sym(t) = dsolve(eqn, cond);

% Convert symbolic solution to a fast numeric function handle
i_func = matlabFunction(i_sym(t));

% --- 3. FIND EXTINCTION ANGLE (Beta) ROBUSTLY ---
% Instead of fzero which might return t_alpha, we step forward to find
% where current goes back to zero.

dt_step = 1e-5; % 10 microseconds step
t_search = t_alpha + dt_step;
limit_time = t_alpha + T/2; % Max conduction is 180 degrees (half cycle)

found = false;
while t_search < limit_time
    val = i_func(t_search);
    if val < 0
        found = true;
        break;
    end
    t_search = t_search + dt_step;
end

if found
    % Refine the root with fzero in the small interval where sign changed
    t_beta = fzero(@(x) i_func(x), [t_search - dt_step, t_search]);
else
    % If never goes negative, it might be continuous or limit reached
    t_beta = limit_time;
end

beta_deg = (t_beta / T) * 360;
fprintf('Extinction Angle (Beta): %.2f degrees\n', beta_deg);

% Conduction interval
t_start = t_alpha;
t_end   = t_beta;

% --- 4. CALCULATE OUTPUT VALUES (NUMERIC INTEGRATION) ---

% A) Average Load Voltage (V_dc)
% V_out = |Vs| when conducting, V_out = E when not conducting.
% Since it is Full Wave, calculate for T/2 period.

% Interval 1: Conducting (t_alpha to t_beta) -> v = Vm*sin(wt)
% Note: Use abs(sin) because full wave rectifier flips the negative cycle
v_func_cond = @(x) abs(Vm * sin(w*x));

% Integral during conduction
area_cond = integral(v_func_cond, t_start, t_end);

% Interval 2: Non-Conducting (t_beta to t_alpha + T/2) -> v = E
% The duration where current is zero within one pulse period (T/2)
t_period_end = t_alpha + T/2;
duration_off = t_period_end - t_end;
area_off = E * duration_off;

V_load_avg = (2/T) * (area_cond + area_off);
fprintf('a) Average Load Voltage (Vdc):       %.2f V\n', V_load_avg);

% B) Average Load Current (Idc)
% Integrate current function from start to end
area_current = integral(i_func, t_start, t_end);
I_load_avg = (2/T) * area_current;
fprintf('b) Average Load Current (Idc):       %.2f A\n', I_load_avg);

% C) RMS Load Current (I_rms)
% Integral of i(t)^2
area_current_sq = integral(@(x) i_func(x).^2, t_start, t_end);
I_load_rms = sqrt((2/T) * area_current_sq);
fprintf('c) RMS Load Current:                 %.2f A\n', I_load_rms);

% D) RMS Source Current (Is_rms)
% For Full Wave, Source RMS = Load RMS
fprintf('d) RMS Source Current (Grid):        %.2f A\n', I_load_rms);