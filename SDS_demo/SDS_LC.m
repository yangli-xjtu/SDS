function SalMap = SDS_LC(imgName)
    Features = StructuralFeatureExtraction_LC(imgName);
    [SalMap] = StructuralDissimilarity(Features);
end