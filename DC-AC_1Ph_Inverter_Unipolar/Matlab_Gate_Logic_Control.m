function [S1, S2, S3, S4] = Unipolar_Gate_Logic(carrier, V_ref_n, V_ref_p)
    % Unipolar PWM Switching Logic Generation
    % carrier: Triangular carrier wave
    % V_ref_n: Negative reference control signal
    % V_ref_p: Positive reference control signal
    
    S1 = 0;
    S2 = 0;
    S3 = 0;
    S4 = 0;
    
    % Leg 1 Control (Controlled by V_ref_p)
    if (V_ref_p >= carrier)
        S1 = 1;  % Switch 1 ON
    end
    if (V_ref_p < carrier)
        S3 = 1;  % Switch 3 ON (Complementary to S1)
    end
    
    % Leg 2 Control (Controlled by V_ref_n)
    if (V_ref_n >= carrier)
        S4 = 1;  % Switch 4 ON
    end  
    if (V_ref_n < carrier)
        S2 = 1;  % Switch 2 ON (Complementary to S4)
    end
    
    return
end