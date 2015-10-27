% Attribute Information.
%   1.  Sequence Name: Accession number for the SWISS-PROT database
%   2.  mcg: McGeoch's method for signal sequence recognition.
%   3.  gvh: von Heijne's method for signal sequence recognition.
%   4.  alm: Score of the ALOM membrane spanning region prediction program.
%   5.  mit: Score of discriminant analysis of the amino acid content of
% 	   the N-terminal region (20 residues long) of mitochondrial and 
%            non-mitochondrial proteins.
%   6.  erl: Presence of "HDEL" substring (thought to act as a signal for
% 	   retention in the endoplasmic reticulum lumen). Binary attribute.
%   7.  pox: Peroxisomal targeting signal in the C-terminus.
%   8.  vac: Score of discriminant analysis of the amino acid content of
%            vacuolar and extracellular proteins.
%   9.  nuc: Score of discriminant analysis of nuclear localization signals
% 	   of nuclear and non-nuclear proteins.

close all;
load ('yeast.txt');

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


