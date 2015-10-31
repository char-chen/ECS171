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

%%  Parameters
input_layer_size  = 9;
hidden_layer_size = 4;
output_layer_size = 10;
X = [0.58  0.61  0.47  0.13  0.50  0.00  0.48  0.22]; 
Y = zeros(1,1);
y = 
iterations = 10000;

%% ANN
for i = 1:1484
    Y(i,y(i,1)) = 1;
end
net = newff(minmax(X'),[3 10],{'logsig' 'purelin'}, 'traingd');


net.trainParam.epochs = 10000;
    net.trainParam.lr = 0.9;
    

        [net tr] = train(net,X',Y');
        
X = yeast(:, 1:8);
Y = zeros(1484,10);
y = yeast(:, 9);

for i = 1:1484
    Y(i,y(i,1)) = 1;
end

Z = sim(net, X');
hitNum = 0;
[m,I] = max(Z);

for i = 1 : 1484
  if I(i)==y(i)
    hitNum = hitNum +1;
  end
end

correct1 = (hitNum / 1484) * 100;
correct1 = strcat(num2str(correct1),'%')