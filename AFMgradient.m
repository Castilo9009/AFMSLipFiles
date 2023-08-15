function [ grad ] = AFMgradient( X, y, w, nStu, lambda=0.0)

    % Vectorized Gradient
    grad = X' * (y - AFMprob(X, w)(:,2));

    % regularize student intercepts
    grad(1:nStu) -= lambda * w(1:nStu);

    % regularize all but intercept
    %grad(1:size(w,1)-1) -= lambda * w(1:size(w,1)-1);

end
