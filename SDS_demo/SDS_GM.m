function SalMap = SDS_GM(imgName)
    tic
    Features = StructuralFeatureExtraction_GM(imgName);
    [SalMap] = StructuralDissimilarity(Features);
    toc
end