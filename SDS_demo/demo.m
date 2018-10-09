clear all;
close all;

imageName = '86.jpg';
figure, imshow(imread(imageName),[])

% Computing the saliency maps for evaluation
% SDS_GM
SalMap_GM = SDS_GM(imageName);

% SDS_LC
SalMap_LC = SDS_LC(imageName);

% show the saliency map
figure,imagesc(SalMap_GM)
figure,imagesc(SalMap_LC)
