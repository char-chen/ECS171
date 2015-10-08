%     1. mpg:           continuous
%     2. cylinders:     multi-valued discrete
%     3. displacement:  continuous
%     4. horsepower:    continuous
%     5. weight:        continuous
%     6. acceleration:  continuous
%     7. model year:    multi-valued discrete
%     8. origin:        multi-valued discrete
%     9. car name:      string (unique for each instance)

%problem 1
load('data.txt');
mpg = data(:,1);
boundary = quantile(mpg, [.33,.66]);

%problem 2
low = (mpg < boundary(1));
med = 2 * (mpg >= boundary(1) & mpg <= boundary(2));
high = 3 * (mpg > boundary(2));

label = low + med + high;
gplotmatrix(data, [], label);

%problem 3
result = OLS([ones(392,1), data(:,2)], mpg);

%problem 4
training = data(1:280, :);
testing = data(281:392, :)
