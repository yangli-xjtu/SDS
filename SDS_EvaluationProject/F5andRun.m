% This project is used to get the results of the paper submitted to JEI
% "Saliency detection based on structural dissimilarity induced by image quality assessment model"
% by Yang Li and Xuanqin Mou

% This project is written by Yang Li, 2018
% Some codes borrowed from Mingming Cheng's codes.
% mmcheng's Git project page: https://github.com/MingMingCheng/SalBenchmark.

% Usage:
% 1) Press F5 and you will get the results of the
% proposed SDS_GM on the Toronto dataset, i.e., AIM120.

% 2) One can add the other models into this project.
% a. Add a new folder: ./MethodCode/YourModel
% b. Add a get-yourmodel-map function in the GetSingleSaliencyMap.m
% c. set the MethodName as "MethodNames = {'YourModel'};"


clear; close all; clc;
addpath(genpath(pwd));
addpath(genpath('Metrics'));
p1 = mfilename('fullpath');
i=findstr(p1,'\');
p1=p1(1:i(end));
cd(p1);
DataDir = 'Data/'; % images dir

%% select one dataset
% available selections: {'AIM120'} or {'MIT1003'} or {'ImgSal'}
SubDataNames = {'AIM120'};

%% set the methods for evaluation
% the proposed SDS_GM is the default method.
% the methodName can be modified like {'IT','GBVS','JUDD','LG','CA','SWD','FES','HFT','SSD','BMS','LDS'}
% we did not include these codes due to the consideration of the copyright

% To obtain the results of the proposed SDS_LC, 
% please go to the function "GetSingleSaliencyMap".
% Then comment: Features = StructuralFeatureExtraction_GM(imgName);
% and uncomment: Features = StructuralFeatureExtraction_LC(imgName);
MethodNames = {'SDS'}; 

%% set the evaluation metrics
MetricNames = {'EMD','AUC_Judd','CC','NSS'};
% four metrics adopted in our paper
% NSS is valid and fast. One can set MetricNames = {'NSS'}.

%% time, mean and std of the results
% diable the parallel processing when computing the mean running time
[timeUsed] = GettingAllSaliencyMaps( MethodNames, DataDir, SubDataNames);
results = CallculatingAllMetrics( MethodNames, DataDir, SubDataNames, MetricNames );
for methodidx = 1: size(results, 1) % method
    for metricidx = 1 :size(results, 2) % metric
        result{metricidx} = mean(results(methodidx, metricidx, 1 , :)); %mean
        stds(methodidx, metricidx) = std(results(methodidx, metricidx, 1 , :)); %std
    end
end
disp(['SDS_GM: EMD, AUC, CC, and NSS scores are ' num2str(cell2mat(result))]);