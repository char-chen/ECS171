% 1. mpg:           continuous
% 2. cylinders:     multi-valued discret
% 3. displacement:  continuous
% 4. horsepower:    continuous
% 5. weight:        continuous
% 6. acceleration:  continuous
% 7. model year:    multi-valued discrete
% 8. origin:        multi-valued discrete

% problem 1
close all
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
rng(50);
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
  xlabel(sprintf('Feature #%d', i));
  ylabel('MPG');
  t = (min(testing(:,i)):0.2:max(testing(:,i)))';
  
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
    mat2 = ones(280,1);
    t2 = ones(112, 1);
    
    for j = 1 : i
        mat2 = [mat2 training(:, 2:8) .^j];
    end
    
    theta = pinv(mat2' * mat2) * mat2' * training(:,1);
    MSE_train2 = sum((training(:,1) - mat2 * theta ).^2 )/280;
    
    for j = 1 : i
      t2 = [t2 testing(:,2:8).^j];
    end
    
    MSE_test2 = sum((testing(:,1) - t2 * theta ).^2 )/112;
end
% problem 6
rate = 0.1;

mat2 = ones(280,1);
t2 = ones(112, 1);
iterations = 100000;   
    
mat2 = [mat2 training(:, 2:8)];
t2 = [t2 testing(:,2:8)];
    
    result = [];
    for k = 1:280
        if training(k, 1) < boundary(1)
            result = [result; 1];
        else
            result = [result; 0];
        end
    end
    classifier1 = ones(8, 1);
    
    for k = 1 : iterations
    classifier1 = classifier1 + rate * mat2' * (result - 1./(1 + exp(-mat2 * classifier1)));
    end
    
    MSE_trainc1 = sum((result - 1./(1 + exp(-mat2 * classifier1 ))).^2 )/280 
    
    
 
    
    result1 = [];
    
    for k = 1:112
      if testing(k, 1) < boundary(1)
            result1 = [result1; 1];
      else
            result1 = [result1; 0];
      end
    end
    MSE_testt1 = sum((result1 - 1./(1 + exp(-t2 * classifier1 ))).^2) /112
    
    


    result2 = [];
    for k = 1:280
        if training(k, 1) >= boundary(1) && training(k, 1) <= boundary(2)
            result2 = [result2; 1];
        else
            result2 = [result2; 0];
        end
    end
    iterations = 10000;
    classifier2 = ones(8, 1);
    
    for k = 1 : iterations
    classifier2 = classifier2 + rate * mat2' * (result2 - 1./(1 + exp(-mat2 * classifier2)));
    end
    
    MSE_trainc2 = sum((result2 - 1./(1 + exp(-mat2 * classifier2) )).^2 )/280 
  
    
    result3 = [];
    
    for k = 1:112
      if testing(k, 1) >= boundary(1) && training(k, 1) <= boundary(2)
            result3 = [result3; 1];
      else
            result3 = [result3; 0];
      end
    end
    MSE_testt2 = sum((result3 - 1./(1 + exp(-t2 * classifier2) )).^2) /112
    
    
    
    
    
    result4 = [];
    for k = 1:280
        if training(k, 1) > boundary(2)
            result4 = [result4; 1];
        else
            result4 = [result4; 0];
        end
    end
    iterations = 10000;
    classifier3 = ones(8, 1);
    
    for k = 1 : iterations
    classifier3 = classifier3 + rate * mat2' * (result4 - 1./(1 + exp(-mat2 * classifier3)));
    end
    
    MSE_trainc3 = sum((result4 -  1./(1 + exp(-mat2 * classifier3) )).^2 )/280 
    
 
    
    result5 = [];
    
    for k = 1:112
      if testing(k, 1) > boundary(2)
            result5 = [result5; 1];
      else
            result5 = [result5; 0];
      end
    end
    MSE_testt3 = sum((result5 - 1./(1 + exp(-t2 * classifier3) )).^2) /112
    
    % problem #7
    
    car = [6 300 170 3600 9 80 1];
    car = [1 car car.^2];
    prediction_car_mpg = car * theta
    car = [1 6 300 170 3600 9 80 1];
    p1 = 1/(1 + exp(-car * classifier1))
    p2 = 1/(1 + exp(-car * classifier2))
    p3 = 1/(1 + exp(-car * classifier3))
    
