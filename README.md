# SDS
Source code for the paper "Saliency detection based on structural dissimilarity induced by image quality assessment model", Yang Li and Xuanqin Mou, Journal of Electronic Imaging, 28(2) 023025 (3 April 2019)

SDS means structural-dissimilarity-based saliency.

Yang Li: liyang2012@stu.xjtu.edu.cn

Xuanqin Mou: xqmou@mail.xjtu.edu.cn

The offical website of this code is http://gr.xjtu.edu.cn/web/xqmou/sds_saliency

Citation:
@article{
author = { Yang  Li,Xuanqin  Mou},
title = {Saliency detection based on structural dissimilarity induced by image quality assessment model},
volume = {28},
journal = {Journal of Electronic Imaging},
number = {2},
pages = {023025 - 1 - 14},
year = {2019},
doi = {10.1117/1.JEI.28.2.023025},
}


# Results
![image](https://github.com/yangli-xjtu/SDS/blob/master/results.png)

Scores on the MIT300 benchmark:
Normalized Scanpath Saliency metric (NSS): 1.3880;
AUC (Judd) metric: 0.8148;
AUC (Borji) metric: 0.7646;
Similarity metric: 0.5183;
Cross-correlation metric: 0.5298;
shuffled AUC metric: 0.6004;
KL metric: 0.8903;
Earth Mover Distance metric: 3.1696;

# SDS demo
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
