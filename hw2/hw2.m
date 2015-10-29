%%  Attribute Information
%   1.  mcg: McGeoch's method for signal sequence recognition.
%   2.  gvh: von Heijne's method for signal sequence recognition.
%   3.  alm: Score of the ALOM membrane spanning region prediction program.
%   4.  mit: Score of discriminant analysis of the amino acid content of
% 	   the N-terminal region (20 residues long) of mitochondrial and 
%            non-mitochondrial proteins.
%   5.  erl: Presence of "HDEL" substring (thought to act as a signal for
% 	   retention in the endoplasmic reticulum lumen). Binary attribute.
%   6.  pox: Peroxisomal targeting signal in the C-terminus.
%   7.  vac: Score of discriminant analysis of the amino acid content of
%            vacuolar and extracellular proteins.
%   8.  nuc: Score of discriminant analysis of nuclear localization signals
% 	   of nuclear and non-nuclear proteins.

clc
clear

close all;
load ('yeast.txt');

%%  Split data
%   Random set of 65% of the samples as the training set and the rest 35% as the testing set.
rng(50);
trainingIndex = randsample(1484, 965);
training = [];
testing = [];

for i = 1 : 1484
  if ismember(i, trainingIndex)
      training = [training; yeast(i, :)];
  else
      testing = [testing; yeast(i, :)];
  end
end

%%  Parameters
input_layer_size  = 9;
hidden_layer_size = 4;
output_layer_size = 10;
X = training(:, 1:8);
Y = zeros(965,10);
y = training(:, 9);
iterations = 20000;

for i = 1:965
    
    Y(i,y(i,1)) = 1;
end
net = newff(minmax(X'),[3 10],{'logsig' 'purelin'}, 'trainbr');

rng(10);
net.IW{1} = rand(3,8);
rng(10);
net.LW{2} =rand(10,3);



net.trainParam.epochs = 1;
    net.trainParam.lr = 1;
    net.trainParam.showWindow = false;
    changew1 = [];
    changew2 = [];
    changeb1 = [];
    changeb2 = [];
  
    for i=1:iterations
        changew1 = [changew1; net.IW{1}(1,:)];
        changew2 = [changew2; net.LW{2}(1,:)];
        changeb1 = [changeb1; net.b{1}(1,:)];
        changeb2 = [changeb2; net.b{2}(1,:)];
        [net tr] = train(net,X',Y');
        
    end

    
    
hold
    t = 1: iterations;
    plot(t,changew1(1:iterations,:));



X = training(:, 1:8);
Y = zeros(965,10);
y = training(:, 9);

for i = 1:965
    
    Y(i,y(i,1)) = 1;
end

Z = sim(net, X');

hitNum = 0;

[m,I] = max(Z);

for i = 1 : 965
    if I(i)==y(i)
        hitNum = hitNum +1;
    end
end

correct1 = (hitNum / 519) * 100;

correct1 = strcat(num2str(correct1),'%')

X = testing(:, 1:8);
Y = zeros(519,10);
y = testing(:, 9);

for i = 1:519
    
    Y(i,y(i,1)) = 1;
end

Z = sim(net, X');

hitNum = 0;

[m,I] = max(Z);

for i = 1 : 519
    if I(i)==y(i)
        hitNum = hitNum +1;
    end
end

correct2 = (hitNum / 519) * 100;

correct2 = strcat(num2str(correct2),'%')
% 
% %%  Random Initialization
% initial_Theta1 = randomInitialize(input_layer_size, hidden_layer_size);
% initial_Theta2 = randomInitialize(hidden_layer_size, output_layer_size);
% 
% initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];
% 
% %%  Training
% fprintf('\nTraining Neural Network... \n')
% 
% %  After you have completed the assignment, change the MaxIter to a larger
% %  value to see how more training helps.
% options = optimset('MaxIter', 50);
% 
% %  You should also try different values of lambda
% lambda = 1;
% 
% % Create "short hand" for the cost function to be minimized
% ANNCost(p, input_layer_size, hidden_layer_size, output_layer_size, X, y, lambda);
% 
% %%  Prediction
% pred = predict(Theta1, Theta2, X);
% fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);