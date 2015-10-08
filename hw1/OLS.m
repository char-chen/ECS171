function [coef, mat] = OLS(X, y, deg)
    x0 = ones(length(X), 1);
    for i = 1:deg
       x0 = [x0, X.^i];
    end
    X = x0;
    coef = pinv(X'*X)*X'*y;
    mat = X;