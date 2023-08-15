function [ rmse ] = CrossValidate( X, y, fPredict, nFolds, indicator=ones(size(y)) )
    
    % Sort by random pertebation of indicator
    stratify = floor(100 * indicator)+unifrnd(0,1, size(indicator));
    Xy = [X y stratify];
    Xy = sortrows(Xy,size(Xy,2));

    % Re-extract X and y
    X = Xy(:,1:size(X,2));
    y = Xy(:,size(X,2)+1:size(X,2)+1);

    % Generate fold assignment
    idx = 1:1:size(X,1);

    % Vector for rmse values
    rmse = ones(nFolds, 1);

    for i = 0:nFolds-1
        XTest = X(find(mod(idx,nFolds)==i),:);
        yTest = y(find(mod(idx,nFolds)==i),:);
        
        XTrain = X(find(mod(idx,nFolds)!=i),:);
        yTrain = y(find(mod(idx,nFolds)!=i),:);

        [yHat] = fPredict(XTrain, yTrain, XTest);

        e = yHat - yTest;
        rmse(i+1) = sqrt(1/size(yTest, 1) * e'*e);
    end

    rmse = mean(rmse);

end
