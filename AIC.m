function [ aic ] = AIC( nParams, logl) 
    aic = 2 * nParams - 2 * logl;
end
