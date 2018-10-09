function GetSingleSaliencyMap(MethodName, WkDir, ImgNameNE)
    if ~isempty(strfind(WkDir,'ImgSal'))  
        fileName = sprintf('%sOriginalImages/%s.bmp', WkDir, ImgNameNE);    
    else
        fileName = sprintf('%sOriginalImages/%s.jpg', WkDir, ImgNameNE);    
    end
    
    outName = sprintf('%sSaliency/%s_%s.png', WkDir, ImgNameNE, MethodName);
    fprintf('%sSaliency/%s_%s.png\r', WkDir, ImgNameNE, MethodName);    
    saMap = 0;

%     if (exist(outName, 'file'))
%        return;
%     end
    
    switch MethodName        
        case 'SR'
            saMap = GetSR(fileName);
        case 'CA'
            saMap = GetCA(fileName);
        case 'SWD'
            saMap = GetSWD(fileName);
        case 'SS'
            saMap = GetSS(fileName);
        case 'PCA'
            saMap = GetPCA(fileName);
        case 'SIM'
            saMap = GetSIM(fileName);
        case 'FES'
            saMap = GetFES(fileName);
        case 'SUN'
            saMap = uint8(GetSUN(imread(fileName), 1));
        case 'GBVS'
            saMap = GetGBVS(fileName);
        case 'IT'
            saMap = GetIT(fileName);
        case 'AIM'
            saMap = GetAIM(fileName);
        case 'SSD'
            saMap = GetSSD(fileName);
        case 'LG'
            saMap = GetLG(fileName);
        case 'LDS'
            saMap = GetLDS(fileName);
        case 'SDS'
            saMap = GetSDS(fileName);
        otherwise
            warning(['Unexpected name of methods:' MethodName]);
    end
    imwrite(saMap, outName);
end


function [SalMap] = GetSDS(imgName)
    Features = StructuralFeatureExtraction_GM(imgName);
%     Features = StructuralFeatureExtraction_LC(imgName);
    [SalMap] = StructuralDissimilarity( Features);
end

function [SalMap] = GetLDS(imgName)
    load('model.mat'); % Chose a fast model.       |
    lab_pca_book = load('LAB_pca.mat');
    SalMap = GetSaliencyMap(imgName,x,lab_pca_book);
end

function [SalMap] = GetLG(imgName)
    PS = 3; InitScale = [512 512]; numScales = 1; comb  = 3;
    [salMapLG salMapL salMapG] = myNewSaLModel4NSS(imgName, numScales, PS, InitScale, comb);
    SalMap = salMapLG;
end

function [SalMap] = GetSWD(imgName)
     SalMap = Wu_ImageSaliencyComputing(imgName, 14, 11, 3);
end

function [SalMap] = GetSS(imgName)
    SalMap = signatureSal(imgName);
end

function [SalMap] = GetPCA(imgName)
    SalMap = PCA_Saliency_Core(imread(imgName));
end

function [SalMap] = GetGBVS(imgName)
    tempMap = gbvs(imgName); 
    SalMap = tempMap.master_map_resized;
end

function [SalMap] = GetIT(imgName)
    tempMap = ittikochmap(imgName);
    SalMap = tempMap.master_map_resized;
end

function [SalMap] = GetAIM(imgName)
    SalMap = uint8(AIM(imgName));
end

function [SalMap] = GetSSD(imgName)
    SalMap = mat2gray(salSSD(imgName));
end

function [SalMap] = GetSIM(filename)
    img          = double(imread(filename));
    [m, n, p]      = size(img);
    window_sizes = [13 26];                          % window sizes for computing center-surround contrast
    wlev         = min([7,floor(log2(min([m n])))]); % number of wavelet planes
    gamma        = 2.4;                              % gamma value for gamma correction
    srgb_flag    = 1;                                % 0 if img is rgb; 1 if img is srgb

    % get saliency map:
    SalMap = uint8(SIM(img, window_sizes, wlev, gamma, srgb_flag));
end