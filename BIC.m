function [ bic ] = BIC( n, nParams, logl)
    bic = nParams * log(n) - 2 * logl;
end
