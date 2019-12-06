function w = weighting_func1(z)
    %Based on the equation(4) of the paper "Recovering High Dynamic Range
    %Radiance Maps from Photographs", by Paul E. Debevec and Jitendra Malik
    Zmax = 255; Zmin = 0; % jms20190313 - this assumption is not in the
    % paper ... altough it is in the code for gsolve ... should be
    % different depending on content or fix based on range (0..255)?
    
    Zmed = double((Zmax+Zmin)/2); %being a th the casting doesn't mind too much ...
    
    if z > Zmed
        w = double(Zmax-z);
    else
        w = double(z-Zmin);
    end
        
    %w=z; % jms20190313 - remove wiegthing for testing if Zmin=0 ZMax=255 may be a problem
end