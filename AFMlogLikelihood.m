function [ logl ] = AFMlogLikelihood( X, y, w, nStu, lambda=0.0)

    % Vectorized operations
    m = [1-y y];

    % Regularize student intercepts
    reg = w(1:nStu);

    % Regularize all but intercept
    %reg = w(1:size(w,1)-1);

    logl = sum((m .* log(AFMprob(X, w)))(:));

    if lambda > 0
        logl -= (lambda / 2) * reg' * reg;
    end

end
