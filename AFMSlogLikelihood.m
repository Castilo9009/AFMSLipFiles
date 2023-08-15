function [ logl ] = AFMSlogLikelihood( X, y, w, Q, sw, lambda=0.0)

    % Vectorized operations
    m = [1-y y];

    % Regularize student intercepts 
    % TODO (adjust the size(Q) based on bias term)
    nStu = size(X,2) - 2*(size(Q,2)-1);
    reg = w(1:nStu);

    % Regularize all but intercept
    %reg = w(1:size(w,1)-1);

    % Regularize slips
    slopeReg = sw(1:size(sw,1)-1);
    reg = [reg; slopeReg];

    logl = sum((m .* log(AFMSprob(X, w, Q, sw)))(:));
    
    if lambda > 0
        logl -= (lambda / 2) * reg' * reg;
    end

end
