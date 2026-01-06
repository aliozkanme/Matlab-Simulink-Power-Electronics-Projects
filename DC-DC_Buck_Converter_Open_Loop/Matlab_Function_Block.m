function triangle_wave = Carrier_Generator(f, t)
%#codegen
% Generates a triangular carrier wave for PWM
% f: Switching Frequency (Hz)
% t: Simulation Clock Time (s)

amplitude = 1;
triangle_wave = 0;
multiplier = 1;

half_period = 1/(2*f);            % p
peak_time = half_period/2;        % tepe_zaman

cycle_time = mod(t, 2*half_period);   % t (Current position in full cycle)
local_time = mod(t, half_period);     % zaman (Current position in half cycle)

% Determine polarity based on cycle position
if (cycle_time < half_period)
    multiplier = -1;
else
    multiplier = 1;
end

% Generate Triangle Shape
if (local_time >= peak_time)
    % Falling edge calculation
    triangle_wave = multiplier * ((amplitude/peak_time) * (half_period - local_time));
else
    % Rising edge calculation
    triangle_wave = multiplier * ((amplitude/peak_time) * local_time);
end

return