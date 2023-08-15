function [ hessian ] = AFMShessian( X, y, w, Q, sw, lambda=0.0)

    %Vectorized version
    p = AFMSprob(X, w, Q, sw)(:, 2);

    wm = ((1 - p) .* (exp(X*w) .* (p - y) - p) - p .* (p - y)) ./ ((1 +
    exp(X*w)).^2 .* (1 - p).^2);
    whessian = X' * diag(wm) * X;

    swm = ((1 - p) .* (exp(Q*sw) .* (p - y) - p) - p .* (p - y)) ./ ((1 +
    exp(Q*sw)).^2 .* (1 - p).^2);
    shessian = Q' * diag(swm) * Q;

    if (lambda > 0)
        % Regularize Student Intercepts
        % TODO (adjust the size(Q) based on bias term)
        nStu = size(X,2) - 2*(size(Q,2)-1);
        whessian(1:nStu, 1:nStu) -= lambda * eye(nStu);

        % Regularize all but intercept
        %whessian(1:size(w,1)-1, 1:size(w,1)-1) -= lambda * eye(size(w,1)-1);

        % Regularize slips
        shessian(1:size(sw,1)-1, 1:size(sw,1)-1) -= lambda * eye(size(sw,1)-1);
    end

    % Compute the off diagional blocks of the hessian (crossing w with sw and
    % vice versa) 
    offdiagm = ((p .* (y - 1)) ./ ((1 + exp(Q*sw)).^2 .* (1 + exp(X*w)).^2 .* (1
    - p).^2));
    offdiag = Q' * diag(offdiagm) * X;

    %hessian = [whessian zeros(size(offwsw)); zeros(size(offsww)) shessian];
    hessian = [whessian offdiag'; offdiag shessian];
end
