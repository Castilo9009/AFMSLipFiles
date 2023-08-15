function [ hessian ] = AFMhessian( X, y, w, nStu, lambda=0.0 )

    %Vectorized version
    p = AFMprob(X, w)(:, 2);
    hessian = -1 * X' * diag(p .* (1-p)) * X;
    
    if (lambda > 0)
        % Regularize student intercepts
        hessian(1:nStu, 1:nStu) -= lambda * eye(nStu);
        
        % Regularize all but intercept
        %hessian(1:size(w,1)-1, 1:size(w,1)-1) -= lambda * eye(size(w,1)-1);
    end

end
