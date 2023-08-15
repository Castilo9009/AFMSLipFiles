% Read all of the data in
Q = dlmread("Qmatrix.tdt", '\t');
Q = Q(2:size(Q,1),:);
S = dlmread("Smatrix.tdt", '\t');
S = S(2:size(S,1),:);
Opp = dlmread("Oppmatrix.tdt", '\t');
Opp = Opp(2:size(Opp,1),:);
R = dlmread("RIDmatrix.tdt", '\t');
R = R(2:size(R,1),:);

y = dlmread("ymatrix.tdt", '\t');
y = y(2:size(y,1),:);

p = dlmread("pmatrix.tdt", '\t');
p = p(2:size(p,1),:);

% Remove rows for students or kcs with only 1 obs.
[R, S, Q, Opp, y, p] = RemoveSingular(R, S, Q, Opp, y, p);

% Can be added to X to have an intercept, however.. it might cause problems in
% regularization...
int = ones(size(S,1),1);

X = [S Q Opp];

lambda = 1;

yhat = [R AFMpredict( X, y, X, size(S,2), size(Q,2), lambda) AFMSpredict( X, y, X, size(S,2), size(Q,2), lambda)];

dlmwrite('Row_AFM_AFMS.csv', yhat); 


