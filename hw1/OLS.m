function [theta, mat] = OLS(X, y, feature, degree)
    theta = [];
    mat = [];
    mat = [mat X.^degree];
    theta = pinv(mat' * mat) * mat'*y;
    