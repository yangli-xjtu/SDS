# Please 'F5andRun'

## Note
% This project is used to get the results of the paper submitted to JEI

% "Saliency detection based on structural dissimilarity induced by image quality assessment model"

% by Yang Li and Xuanqin Mou


<br/> 

% This project is written by Yang Li, 2018, yangli2012@stu.xjtu.edu.cn

% Some codes borrowed from Mingming Cheng's codes.

% mmcheng's Git project page: https://github.com/MingMingCheng/SalBenchmark.

## Usage:

1. Press F5 and you will get the results of the proposed SDS_GM on the Toronto dataset, i.e., AIM120.

2. One can add the other models into this project.

    a. Add a new folder: ./MethodCode/YourModel

    b. Add a get-yourmodel-map function in the GetSingleSaliencyMap.m

    c. set the MethodName as "MethodNames = {'YourModel'};"
