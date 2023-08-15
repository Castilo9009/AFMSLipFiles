function [ ] = AFMplot( S, Q, Opp, y, lambda=0)
    X = [S Q Opp];
    O1 = Opp + Q;
    yh1 = AFMpredict( X, y, X, size(S,2), size(Q,2), lambda);
    yh2 = AFMSpredict( X, y, X, size(S,2), size(Q,2), lambda);

    % plot the overall curve
    m = max(O1(:));
    xd = 1:1:m;
    actual = zeros(size(xd));
    afm = zeros(size(xd));
    afms = zeros(size(xd));

    for i = 1:m
        actual(i) = mean(y(find(sum(O1==i,2)>0)));
        afm(i) = mean(yh1(find(sum(O1==i,2)>0)));
        afms(i) = mean(yh2(find(sum(O1==i,2)>0)));
    end
    
    plot(xd, 1-actual, '-1', xd, 1-afm, '-2', xd, 1-afms, '-3');
    axis([0 m 0 1], "autox");
    disp('Press any key to continue')
    pause()

    % Plot each individual KC curve
    nk = size(O1,2);

    for kc = 1:nk
        m = max(O1(:,kc));
        xd = 1:1:m;
        actual = zeros(size(xd));
        afm = zeros(size(xd));
        afms = zeros(size(xd));

        for i = 1:m
            actual(i) = mean(y(find(O1(:,kc)==i)));
            afm(i) = mean(yh1(find(O1(:,kc)==i)));
            afms(i) = mean(yh2(find(O1(:,kc)==i)));
        end

        plot(xd, 1-actual, '-1', xd, 1-afm, '-2', xd, 1-afms, '-3')
        axis([0 m 0 1], "autox");
        disp('Press any key to continue')
        pause()

    end
end

