function J = costFunction(X, y, theta)
  
  m = size(X, 1)          %number of training examples
  predictions = X*theta;  %predictions of hypothesis on all m examples
  sqrErrors = (predictions-y) .^2;  %squared erros
  
  J = 1/(2*m) * sum(sqrErrors);
