function output_signal = Zero_Crossing_Detector(input_voltage)
    % Checks if the input voltage is positive
    
    R = 10;             % Resistance (Ohm)
    epsilon = 0.000001; % Epsilon tolerance
    
    if input_voltage > 0
        output_signal = 1;
    else
        output_signal = 0;
    end
end