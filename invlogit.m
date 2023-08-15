function [p] = invlogit(x)
    p = 1 ./ (1 + exp(x));
end
