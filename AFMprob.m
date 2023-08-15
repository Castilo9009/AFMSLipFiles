function [ p ] = AFMprob( x, w )
    % Filler code, replace with your own.
    prob = 0.00001 + 0.99998 * (1 ./ (1 + exp(-x*w)));
    p = [1-prob prob];
end
