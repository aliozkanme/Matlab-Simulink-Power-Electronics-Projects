function alpha_deg = Calculate_Alpha(V_ref)
    % Initialization of variables
    phi = 2;              % Initial guess for the angle (radians)
    eps_tol = 0.00001;    % Epsilon tolerance
    max_iter = 20;        % Maximum number of iterations
    diff_tol = 0.000001;  % Difference threshold
    alpha_deg = 0;        % Output angle initialization
    f_val = 0;            % Function value
    
    Vm = 220 * sqrt(2);   % Peak Voltage (Vm)
    
    % Newton-Raphson Loop
    for k = 1:max_iter
        % Derivative of the voltage equation: b = f'(phi)
        deriv = (Vm / pi) * sin(phi); 
        
        % Update rule: alpha = phi - f(phi)/f'(phi)
        % Equation being solved: V_ref - (Vm/pi)*(1 + cos(phi)) = 0
        numerator = -(Vm / pi) * (cos(phi) + 1) + V_ref;
        alpha_deg = phi - numerator / deriv;  
        
        % Error Calculation
        err_abs = abs(alpha_deg - phi);
        err_rel = 2 * err_abs / (abs(alpha_deg) + diff_tol);
        
        % Update phi for next step
        phi = alpha_deg;
        
        % Recalculate function residual
        f_val = -(Vm / pi) * (cos(phi) + 1) + V_ref;
        
        % Convergence Check
        if (err_abs < diff_tol) || (err_rel < diff_tol) || (abs(f_val) < eps_tol)
            break
        end 
    end
    
    % Convert result from Radians to Degrees
    alpha_deg = alpha_deg * 180 / pi;
end