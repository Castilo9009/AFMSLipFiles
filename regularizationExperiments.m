% Read all of the data in
Q = dlmread("Qmatrix.tdt", '\t');
Q = Q(2:size(Q,1),:);
S = dlmread("Smatrix.tdt", '\t');
S = S(2:size(S,1),:);
Opp = dlmread("Oppmatrix.tdt", '\t');
Opp = Opp(2:size(Opp,1),:);

y = dlmread("ymatrix.tdt", '\t');
y = y(2:size(y,1),:);

p = dlmread("pmatrix.tdt", '\t');
p = p(2:size(p,1),:);

% Remove rows for students or kcs with only 1 obs.
[S, Q, Opp, y] = RemoveSingular( S, Q, Opp, y);

% Can be added to X to have an intercept, however.. it might cause problems in
% regularization...
int = ones(size(S,1),1);

X = [S Q Opp];

nFolds = 3; 
runs = 40;

printf('# obs = %i\n', size(X,1))
printf('# folds = %i\n', nFolds)
printf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AFM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%px = 0:30;
%py = 0:30;
%
%for inc=1:31
%
%    lambda = (inc-1)*0.1;
%    px(inc) = lambda;
%
%    w = zeros(size(X,2),1);
%    f = @(x) AFMlogLikelihood(X, y, x, size(S,2), lambda);
%    fgrad = @(x) AFMgradient(X, y, x, size(S,2), lambda);
%    fhess = @(x) AFMhessian(X, y, x, size(S,2), lambda);
%    fpredict = @(x, y, t) AFMpredict(x, y, t, size(S,2), size(Q, 2), lambda);
%    ftrain = @(x) AFMnewtonDescent(f, fgrad, fhess, x, 1, 3000, size(S,2),size(Q,2));
%
%    [w, li] = ftrain(w);
%    printf('# params = %i\n', size(w,1))
%    afmll = f(w)
%    afmAIC = AIC(size(w,1), f(w))
%    afmBIC = BIC(size(X, 1), size(w,1), f(w))
%
%    afmCV = zeros(runs,1);
%    afmSSCV = zeros(runs, 1);
%    afmISCV = zeros(runs, 1);
%    for i = 1:runs
%        afmCV(i) = CrossValidate(X, y, fpredict, nFolds);
%        %afmYSCV(i) = CrossValidate(X, y, fpredict, nFolds, y)
%    %    afmSSCV(i) = CrossValidate(X, y, fpredict, nFolds, sum(S*diag(1:size(S,2)),2));
%    %    %afmsKCSCV = CrossValidate(X, y, fpredict, nFolds, sum(Q*diag(1:size(Q,2)),2))
%    %    afmISCV(i) = CrossValidate(X, y, fpredict, nFolds, p);
%    end
%
%    py(inc) = mean(afmCV);
%    %mean(afmCV)
%    %mean(afmSSCV)
%    %mean(afmISCV)
%
%    afmw = w;
%
%    printf('\n')
%end
%
%plot(px, py)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% AFMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
px = 0:30;
py = 0:30;

for inc=1:31

    lambda = (inc-1)*0.1;
    px(inc) = lambda;

    % Whether or not there is a bias term on the slips
    %newQ = Q;
    newQ = [Q int];

    w = zeros(size(X,2),1);
    sw = zeros(size(newQ,2),1);
    f = @(x, x2) AFMSlogLikelihood(X, y, x, newQ, x2, lambda);
    fgrad = @(x, x2) AFMSgradient(X, y, x, newQ, x2, lambda);
    fhess = @(x, x2) AFMShessian(X, y, x, newQ, x2);
    fpredict = @(x, y, t) AFMSpredict(x, y, t, size(S,2), size(Q,2), lambda);
    ftrain = @(x, x2) AFMSnewtonDescent(f, fgrad, fhess, x, x2, 1, 3000, size(S,2),size(Q,2));

    [w, sw, li] = ftrain(w, sw);
    printf('# params = %i\n', size(w,1) + size(sw,1))
    amfsll = f(w, sw)
    afmsAIC = AIC(size(w,1)+size(sw,1), f(w, sw))
    afmsBIC = BIC(size(X, 1), size(w,1)+size(sw,1), f(w, sw))

    afmsCV = zeros(runs,1);
    afmsSSCV = zeros(runs, 1);
    afmsISCV = zeros(runs, 1);
    for i = 1:runs
        afmsCV(i) = CrossValidate(X, y, fpredict, nFolds);
        %afmsYSCV = CrossValidate(X, y, fpredict, nFolds, y)
    %    afmsSSCV(i) = CrossValidate(X, y, fpredict, nFolds, sum(S*diag(1:size(S,2)),2));
        %afmsKCSCV = CrossValidate(X, y, fpredict, nFolds, sum(Q*diag(1:size(Q,2)),2))
    %    afmsISCV(i) = CrossValidate(X, y, fpredict, nFolds, p);
    end

    py(inc) = mean(afmsCV);
    %mean(afmsSSCV)
    %mean(afmsISCV)

    afmsw = w;
end

plot(px, py)
%
%[afmw afmsw abs(afmw - afmsw)];
%
%fplot = @() AFMplot(S,Q,Opp,y);
