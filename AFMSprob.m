function [ p ] = AFMSprob( x, w, q, sw )
    %prob = 0.00001 + 0.99998 * (1 ./ (1 + exp(-q*sw))) .* (1 ./ (1 + exp(-x*w)));
    prob = (1 ./ (1 + exp(-q*sw))) .* (1 ./ (1 + exp(-x*w)));
    p = [1-prob prob];
end
