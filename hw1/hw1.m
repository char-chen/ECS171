% 1. mpg:           continuous
% 2. cylinders:     multi-valued discret
% 3. displacement:  continuous
% 4. horsepower:    continuous
% 5. weight:        continuous
% 6. acceleration:  continuous
% 7. model year:    multi-valued discrete
% 8. origin:        multi-valued discrete

% problem 1
load('data.txt');
mpg = data(:,1);
boundary = quantile(mpg, [.33,.66]);

% problem 2
low = (mpg < boundary(1));
med = 2 * (mpg >= boundary(1) & mpg <= boundary(2));
high = 3 * (mpg > boundary(2));
label = low + med + high;
gplotmatrix(data, [], label);

% problem 3 - OLS.m

% problem 4
rng(100);
trainingIndex = randsample(392, 280);
training = [];
testing = [];

for i = 1 : 392
  if ismember(i, trainingIndex)
      training = [training; data(i, :)];
  else
      testing = [testing; data(i, :)];
  end
end

for i = 2:8
  hold off
  figure
  scatter(testing(:,i), testing(:,1))
  hold
  xlabel(sprintf('#%d feature', i));
  ylabel('mpg');
  t = (min(testing(:,i)):0.1:max(testing(:,i)))';
  
  for j = 0:4
    [prediction,mat] = OLS(training(:,i), training(:,1), j);
    MSE_train = sum((training(:,1) -  mat * prediction).^2)/280;
    
    l = [];
    for k = 0:j
      l = [l testing(:,i).^k];
    end
    
    MSE_test = sum((testing(:,1) - l * prediction).^2)/112;
    test = [];
    
    for k = 0:j
      test = [test  t.^k ];
    end

    ypred = test * prediction;
    plot(t, ypred)
  end
end

% problem 5
for i = 0:2
    
    
end