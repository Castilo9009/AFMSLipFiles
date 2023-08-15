function [ w, li ] = AFMnewtonDescent( f, fgrad, fhess, w0, step0, niter, nStu, nKC)

    li = size(niter,1);
    n = 1;

    % Recommended: (0.01, 0.3)
    amrijo = 0.01;

    % Recommended: (0.1, 0.8)
    shrink = 0.5;

    w = w0;
    fw1 = f(w);
    grad = fgrad(w);
    direction = pinv(fhess(w)) * -grad;
    m = direction' * grad;

    while (0.5 * m > 10^(-3) && n < niter)
        fw0 = fw1;
        step = step0 / shrink;
        once = 1;

        while (once || fw1 - fw0 < amrijo * step * m)
            once = 0;
            step = shrink * step;

            w1 = w + step * direction;
            %w1(1+nStu+nKC:nStu+nKC+nKC) = max(0, w1(1+nStu+nKC:nStu+nKC+nKC));

            fw1 = f(w1);
            grad = fgrad(w);
            direction = pinv(fhess(w)) * -grad;
            m = direction' * grad;
        end

        w = w1;
        li(n) = fw1;
        n += 1;
    end
end

