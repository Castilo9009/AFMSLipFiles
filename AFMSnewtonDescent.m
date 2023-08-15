function [ w, sw, li ] = AFMSnewtonDescent( f, fgrad, fhess, w0, sw0, step0, niter, nStu, nKC)

    nw = size(w0,1);
    nsw = size(sw0,1);
    li = size(niter,1);
    n = 1;

    % Recommended: (0.01, 0.3)
    amrijo = 0.3;

    % Recommended: (0.1, 0.8)
    shrink = 0.1;

    w = w0;
    sw = sw0;
    fw1 = f(w, sw);
    grad = fgrad(w, sw);
    %direction = pinv(fhess(w,sw)) * -grad;
    direction = grad;
    m = direction' * grad;

    while (0.5 * m > 10^(-3) && n < niter)
        fw0 = fw1;
        step = step0 / shrink;
        once = 1;

        while (once || fw1 - fw0 < amrijo * step * m)
            once = 0;
            step = shrink * step;

            w1 = w + step * direction(1:nw);
            %w1(1+nStu+nKC:nStu+nKC+nKC) = max(0, w1(1+nStu+nKC:nStu+nKC+nKC));
            sw1 = sw + step * direction(nw+1:nw+nsw);

            fw1 = f(w1, sw1);
            grad = fgrad(w, sw);
            %direction = pinv(fhess(w,sw)) * -grad;
            direction = grad;
            m = direction' * grad;
        end

        w = w1;
        sw = sw1;
        li(n) = fw1;
        n += 1;

    end
end

