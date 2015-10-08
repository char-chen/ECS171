%     1. mpg:           continuous
%     2. cylinders:     multi-valued discrete
%     3. displacement:  continuous
%     4. horsepower:    continuous
%     5. weight:        continuous
%     6. acceleration:  continuous
%     7. model year:    multi-valued discrete
%     8. origin:        multi-valued discrete

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
[coef, mat] = OLS(data(:,2), mpg, 1);

%problem 4
training = data(1:280, :);
testing = data(281:392, :);


for i = 2:8
    hold off
    figure
    plot(training(:,i),mpg(1:280), 'c*')
    hold on
    for j = 0:4
    [prediction, mat] = OLS(training(:, i), mpg(1:280), j);
    ypred = mat*prediction;
    mse = sum(((ypred-mpg(1:280)).^2)/280)
    plot(training(:,i),ypred, 'b*')
    
    end
    

end


