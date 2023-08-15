%function [ wgrad, swgrad ] = AFMSgradient( X, y, w, Q, sw, lambda=0.0)
function [ grad ] = AFMSgradient( X, y, w, Q, sw, lambda=0.0)

    % Vectorized Gradient
    p = AFMSprob(X, w, Q, sw)(:,2);

    wgrad = X' * ((y - p) ./ ((1 + exp(X*w)) .* (1 - p)));
    swgrad = Q' * ((y - p) ./ ((1 + exp(Q*sw)) .* (1 - p)));

    % regularize student intercepts
    % TODO (adjust the size(Q) based on bias term)
    nStu = size(X,2) - 2*(size(Q,2)-1);
    wgrad(1:nStu) -= lambda * w(1:nStu);

    % Regularize all but intercept
    %wgrad(1:size(w,1)-1) -= lambda * w(1:size(w,1)-1);

    % Regularize slips
    swgrad(1:size(sw,1)-1) -= lambda * sw(1:size(sw,1)-1);

    grad = [wgrad; swgrad];

end
