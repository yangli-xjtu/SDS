function [saMap] = StructuralDissimilarity(Features)
    S      = 24; %patch size
    sigma  = 3; 
    [M,N]  = size(Features{1});
    rowNum = M/S;
    colNum = N/S;
    featureDim = max(size(Features));
    g_saMap = zeros(rowNum,colNum);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    % global structural dissimialrity computation
    %%%%%%%%%%%%%%%%%%%%%%%%%
    for rowIdx = 1: rowNum
        for colIdx = 1: colNum
            
            r_up = (rowIdx-1)*S+1; r_down = rowIdx*S;
            u_left = (colIdx-1)*S+1; d_right = colIdx*S;
            
            for fidx=1:featureDim
                curfeatureBlk{fidx} = Features{fidx}(r_up:r_down, u_left:d_right);
            end
            
            for rIdx = 1:rowNum
                for cIdx = 1:colNum
                        rup = (rIdx-1)*S+1; rdown = rIdx*S;
                        uleft = (cIdx-1)*S+1; dright = cIdx*S;
                        for fidx=1:featureDim
                            cmpfeatureBlk{fidx} = Features{fidx}(rup:rdown, uleft:dright);
                        end
                        %Dissimilarity Measure
                        disSim = double(zeros(S,S));
                        for fidx=1:featureDim
                            disSim = disSim + keyFunc(curfeatureBlk{fidx},cmpfeatureBlk{fidx}, 20);
                        end                        
                        % Combination
                        disSim = mean2(sqrt(double(disSim)/featureDim));
                        
                        % Spatial Weighting
                        distW2       = (double((rowIdx-rIdx)^2 + (colIdx-cIdx)^2));
                        distWgauss =  exp( -1 * distW2 / (2 * sigma^2) );
                        g_saMap(rowIdx, colIdx) = g_saMap(rowIdx, colIdx) + disSim*distWgauss;
                        g_saMap(rIdx, cIdx)     = g_saMap(rIdx, cIdx) + disSim*distWgauss;
                end
            end

        end
    end
    saMap = mat2gray(g_saMap.^8);
end

function [dissimilaryBlock] = (block1, block2, cScale)
    dissimilaryBlock = (block1 - block2).^2 ./ (block1.^2 + block2.^2 + cScale);
end