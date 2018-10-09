function [timeUsed] = GettingAllSaliencyMaps(MethodNames, DataDir, SubDataNames)
    addpath('../../');
    methodsNum = length(MethodNames);
    datasetsNum = length(SubDataNames);
    timeUsed = zeros(datasetsNum, methodsNum);

    %%%%%%%%%%%%%%%%%%%%%%%%%
    % methods loop
    %%%%%%%%%%%%%%%%%%%%%%%%%
    for methodID = 1 : methodsNum
        cd(['./MethodsCode/',MethodNames{methodID}]);
        subDirs = genpath('./');
        addpath(subDirs);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%
        % datasets loop
        %%%%%%%%%%%%%%%%%%%%%%%%%
        for ds = 1 : datasetsNum
            WkDir = ['../../',DataDir SubDataNames{ds} '/'];
            InDir = [WkDir 'OriginalImages/'];
            OutDir = [WkDir 'Saliency/'];
            if ~exist(OutDir, 'dir')
                mkdir(OutDir);
            end
            fprintf('Processing dataset: %s\r', WkDir);    
            
            if strcmp(SubDataNames{ds}, 'ImgSal')
                d = dir([InDir, '*.bmp']);
            else     
                d = dir([InDir, '*.jpg']);
            end
            
            imgFiles = natsortfiles({d(~[d.isdir]).name});
            fileNum = length(imgFiles);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%
            % images loop
            %%%%%%%%%%%%%%%%%%%%%%%%%
            clockTimeStart = clock;
            parfor fileID = 1:fileNum % parfor % do not use parfor when computing average running time
                fprintf('%d/%d: ', fileID, length(imgFiles)); 
                ImgNameNumber = (imgFiles{fileID}(1:end-4));
                GetSingleSaliencyMap(MethodNames{methodID}, WkDir, ImgNameNumber);
            end
            timeU = clock - clockTimeStart;
            timeUsed(ds, methodID) = (((timeU(3)*24 + timeU(4))*60 + timeU(5))*60 + timeU(6));

        end        
        rmpath(subDirs);
        cd ../../
    end    
    rmpath('../../');
end