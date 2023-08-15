function [ rmse ] = CrossValidateDS( X, y, fPredict, nFolds, indicator=ones(size(y)) )
    
    labels = unique(indicator);
    
    if (size(labels,1) <= nFolds)
        warning("less labels than folds in cross validation");
    end

    % randomize order of labels
    random = unifrnd(0,1,size(labels));
    labels = [labels random];
    labels = sortrows(labels, size(labels,2));
    labels = labels(:,1);

    % assign labels to folds
    assignments = mod(1:1:size(labels,1), nFolds)+1;

    % Vector for rmse values
    rmse = ones(nFolds, 1);

    % split train and test
    for i = 1:nFolds
        fLabels = sort(labels(find(assignments == i)));
        idx = lookup(fLabels, indicator);
        idx(find(idx == 0)) = 1;

        key = fLabels(idx) == indicator;
        XTest = X(find(key), :);
        yTest = y(find(key), :);

        key = fLabels(idx) != indicator;
        XTrain = X(find(key), :);
        yTrain = y(find(key), :);

        [yHat] = fPredict(XTrain, yTrain, XTest);
        e = yHat - yTest;
        rmse(i) = sqrt(1/size(yTest, 1) * e'*e);
    end

    rmse = mean(rmse);

end
