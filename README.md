# SDS
Source code for the paper entitled "Saliency detection based on structural dissimilarity induced by image quality assessment model" submitted to Journal of Electronic Imaging by Yang Li and Xuanqin Mou.

SDS means structural-dissimilarity-based saliency.

# SDS demo:
./SDS_demo/demo.m     % the demo script showing the usage of the functions SDS_GM.m and SDS_LC.m

./SDS_demo/SDS_GM.m   % the SDS model based on the gradient magnitude

./SDS_demo/SDS_LC.m   % the SDS model based on the local contrast

# Evaluation Project

Usage:
1. Press F5 and you will get the results of the proposed SDS_GM on the Toronto dataset, i.e., AIM120.

2. One can add the other models into this project.

    a. Add a new folder: ./MethodCode/YourModel

    b. Add a get-yourmodel-map function in the GetSingleSaliencyMap.m

    c. set the MethodName as "MethodNames = {'YourModel'};"
