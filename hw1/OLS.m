function theta = OLS(X, y, f)
    theta = [];
    
    for i = 0:f
       theta = [theta X.^i];
    end
    
    theta = pinv(theta'*theta)*theta'*y;
    