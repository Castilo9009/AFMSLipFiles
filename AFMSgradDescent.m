function [ w, sw, li ] = AFMSgradDescent( f, fgrad, w0, sw0, step, niter)

    alpha = 0.5;
    step0 = step;
    w = w0;
    sw = sw0;
    li = size(niter,1);
    n = 1;
    fw1 = f(w, sw);
    fw0 = fw1 + 1;

    while (abs(fw0 - fw1) > 0.01 && n < niter)
        fw0 = fw1;

        [wg, swg] = fgrad(w, sw);
        w1 = w + step * wg;
        sw1 = sw + step * swg;
        fw1 = f(w1, sw1);
        step = step0;

        while (fw1 < fw0)
            step = alpha * step;
            w1 = w + step * wg;
            sw1 = sw + step * swg;
            fw1 = f(w1, sw1);
        end

        w = w1;
        sw = sw1;
        li(n) = fw1;
        n += 1;
    end
end

