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
iterations = 10000;

%% ANN
for i = 1:965
    Y(i,y(i,1)) = 1;
end
net = newff(minmax(X'),[3 10],{'logsig' 'purelin'}, 'traingd');

rng(10);
net.IW{1} = rand(3,8);
rng(10);
net.LW{2} = rand(10,3);

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
figure(1);
t = 1: iterations;
plot(t,changew1(1:iterations,:));
title('Weights 1');
xlabel('Iterations');
ylabel('Weight value');
legend('W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7', 'W8', 'Location', 'northwest');
hold off

hold
figure(2);
t = 1: iterations;
plot(t,changew2(1:iterations,:));
title('Weights 2');
xlabel('Iterations');
ylabel('Weight value');
legend('W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7', 'W8', 'Location', 'northwest');
hold off

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
    if I(i) == y(i)
        hitNum = hitNum +1;
    end
end

correct2 = (hitNum / 519) * 100;
correct2 = strcat(num2str(correct2),'%')

%%For p5
sample = [0.5, 0.49, 0.52, 0.2, 0.55, 0.03, 0.50, 0.39];
predict = sim(net, sample')