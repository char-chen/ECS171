function [theta, mat] = OLS(X, y, degree)
    
    mat = [];
    for i = 0: degree
      mat = [mat X.^degree];
    end
    
    theta = pinv(mat' * mat) * mat'*y;
end