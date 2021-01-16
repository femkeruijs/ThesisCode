function F = onedogc(x,xdata)

%%% function for derivative of gaussian parameter estimation
F = x(1) .* xdata .* x(2).* (sqrt(2)/exp(-0.5)) .* exp(-(x(2).*xdata).^2)  + x(3);
