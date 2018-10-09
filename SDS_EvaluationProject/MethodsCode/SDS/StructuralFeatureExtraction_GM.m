function [myFeatures] = StructuralFeatureExtraction_GM(imgName)
    imageRef = resizeImage(imgName);
    % YIQ colorspace
    Color1 = 0.299 * double(imageRef(:,:,1)) + 0.587 * double(imageRef(:,:,2)) + 0.114 * double(imageRef(:,:,3));
    Color2 = 0.596 * double(imageRef(:,:,1)) - 0.274 * double(imageRef(:,:,2)) - 0.322 * double(imageRef(:,:,3));
    Color3 = 0.211 * double(imageRef(:,:,1)) - 0.523 * double(imageRef(:,:,2)) + 0.312 * double(imageRef(:,:,3));
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate the gradient map
    %%%%%%%%%%%%%%%%%%%%%%%%%
    gradientMap1 = gm(Color1);
    gradientMap2 = gm(Color2);
    gradientMap3 = gm(Color3);
    n=1;
    myFeatures{n} = (gradientMap1); n=n+1;
    myFeatures{n} = (gradientMap2); n=n+1;
    myFeatures{n} = (gradientMap3); n=n+1;
return;

function gradientMap = gm(im)
    dx = [1 0 -1; 1 0 -1; 1 0 -1]/3;
    dy = dx';
    IxY1 = imfilter( im, dx, 'replicate');
    IyY1 = imfilter( im, dy, 'replicate');
    gradientMap = sqrt(IxY1.^2 + IyY1.^2);
return;

function newImage = resizeImage(imgName)
    Img = double( imread(imgName));
    % resizing
    smallSideBlkNum = 11; blkSize = 24;
    [mImg, nImg,~] = size(Img);
    ImageSize = [mImg, nImg];
    [maxSize, maxLoc] = max(ImageSize);
    [minSize, minLoc] = min(ImageSize);
    if mImg==nImg
        minLoc = 3-maxLoc;
    end
    scaleMax = round(maxSize/blkSize);
    scaleMin = round(minSize/blkSize);
    largeSideBlkNum = round( smallSideBlkNum * round(scaleMax/scaleMin*10)/10 );
    
    ImageSize(minLoc) = blkSize * smallSideBlkNum;    
    ImageSize(maxLoc) = blkSize * largeSideBlkNum;
    newImage = zeros([ImageSize,3]);
    newImage(:,:,1) = imresize(Img(:,:, 1), ImageSize);
    newImage(:,:,2) = imresize(Img(:,:, 2), ImageSize);
    newImage(:,:,3) = imresize(Img(:,:, 3), ImageSize);
return;