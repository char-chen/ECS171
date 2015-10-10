function [coef, mat] = OLS(X, y, deg)
    coef = [];%ones(length(X), 1);
    for i = 0:deg
       coef = [coef, X.^i];
    end
    coef = pinv(X'*X)*X'*y;
    mat = X;