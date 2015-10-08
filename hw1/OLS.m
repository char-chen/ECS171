function result = OLS(X, y, deg)
    result = pinv(X'*X)*X'*y;