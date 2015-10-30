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
net = newff(minmax(X'),[100 10],{'logsig' 'purelin'}, 'trainbr');


net.trainParam.epochs = 10000;
net.trainParam.lr = 0.9;

    [net tr] = train(net,X',Y');



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


sample = [0.5, 0.49, 0.52, 0.2, 0.55, 0.03, 0.50, 0.39];
predict = sim(net, sample')