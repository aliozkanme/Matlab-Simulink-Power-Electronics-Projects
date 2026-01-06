function [carrier, signal1, signal2] = PWM_Generator(Vs, t, f)
% In this program, the triangular wave is in DC signal form within T/2.

% --- Initialization ---
signal1 = 0;
signal2 = 0;

T = 1/f;        % Period
V = 1;          % Amplitude
slope = 2*f*V;  % Slope (m)
carrier = 0;    % Triangular wave (e)

index = fix(t/T); % Cycle index (b)

% --- Triangular Wave Generation ---
% Rising part
if (t >= index*T) && (t <= (index + 0.5)*T)
    carrier = slope * (t - (index + 0.5)*T) + V;
end

% Falling part
if (t > (0.5 + index)*T) && (t <= (index + 1)*T)
    carrier = -slope * (t - (index + 0.5)*T) + V;
end

% Absolute value to make it positive (Unipolar triangle)
carrier = abs(carrier);

% --- PWM Comparator Logic ---
% Compare Control Signal (Vs) with Carrier Wave
if Vs > carrier  % Corrected from '0' to 'carrier' based on Project PDF logic
    signal1 = 1;
    signal2 = 0;
else
    signal1 = 0;
    signal2 = 1;
end