function [ yHat ] = AFMpredict( XTrain, yTrain, XTest, nStu, nKC, lambda=0.0)
    
    % Train the model
    f = @(w) -AFMlogLikelihood( XTrain, yTrain, w, nStu, lambda);
    fgrad = @(w) -AFMgradient( XTrain, yTrain, w, nStu, lambda);
    fhess = @(w) -AFMhessian( XTrain, yTrain, w, nStu, lambda);
    w0 = zeros(size(XTrain,2),1);

    % reasonable parameter bounds and positive learning rates
    lb = -15 * ones(size(w0));
    ub = 15 * ones(size(w0));
    lb(1+nStu+nKC:nStu+2*nKC) = 0;

    [w] = sqp(w0, {f, fgrad, fhess}, [], [], lb, ub, 500);
    
    % Vectorized
    yHat = AFMprob(XTest, w)(:,2);
end
