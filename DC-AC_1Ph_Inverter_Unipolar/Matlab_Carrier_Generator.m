function carrier = Carrier_Generator(f, clock_time)
    %#codegen
    % Generates a triangular carrier wave for PWM
    % f: Frequency (Hz)
    % clock_time: Simulation time
    
    amplitude = 1;
    carrier = 0;
    multiplier = 1;
    
    half_period = 1/(2*f);              % p (Half period duration)
    peak_time = half_period/2;          % tepe_zaman (Time to reach peak)
    
    cycle_time = mod(clock_time, 2*half_period); % t (Current time in full cycle)
    local_time = mod(clock_time, half_period);   % zaman (Current time in half cycle)
    
    % Determine the polarity multiplier based on the cycle half
    if (cycle_time < half_period)
        multiplier = -1;
    else
        multiplier = 1;
    end
    
    % Generate the Triangle Shape
    if (local_time >= peak_time)
        % Falling edge calculation
        carrier = multiplier * ((amplitude/peak_time) * (half_period - local_time));
    else
        % Rising edge calculation
        carrier = multiplier * ((amplitude/peak_time) * local_time);
    end
    
    return
end