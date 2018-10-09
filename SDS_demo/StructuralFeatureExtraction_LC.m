function [myFeatures] = StructuralFeatureExtraction_LC(imgName)
    imageRef = resizeImage(imgName);
    % YIQ colorspace
    Color1 = 0.299 * double(imageRef(:,:,1)) + 0.587 * double(imageRef(:,:,2)) + 0.114 * double(imageRef(:,:,3));
    Color2 = 0.596 * double(imageRef(:,:,1)) - 0.274 * double(imageRef(:,:,2)) - 0.322 * double(imageRef(:,:,3));
    Color3 = 0.211 * double(imageRef(:,:,1)) - 0.523 * double(imageRef(:,:,2)) + 0.312 * double(imageRef(:,:,3));
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate the LC map
    %%%%%%%%%%%%%%%%%%%%%%%%%    
    [~, lc1] = lmlc(Color1);
    [~, lc2] = lmlc(Color2);
    [~, lc3] = lmlc(Color3);
    n=1;
    myFeatures{n} = (lc1);n=n+1;
    myFeatures{n} = (lc2);n=n+1;
    myFeatures{n} = (lc3);n=n+1;
return;

function [lm, lc] = lmlc(im)
    window = fspecial('gaussian', 11, 1.5);
    window = window/sum(sum(window));
    lm   = imfilter(im,window, 'replicate');
    mu1_sq = lm.*lm;
    lc = imfilter(im.*im,window, 'replicate') - mu1_sq;
return;

function logmap = logfilt(im)
    sigma=1.5;
    fsize = ceil(sigma*4) * 2 + 1;
    op = fspecial('log',fsize,sigma);
    op = op/sum(abs(op(:)));
    logmap = (imfilter(im,op,'replicate'));
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