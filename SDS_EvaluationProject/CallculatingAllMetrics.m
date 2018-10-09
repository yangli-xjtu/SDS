function [results] = CallculatingAllMetrics(MethodNames, DataDir, SubDataNames, MetricNames)

    methodsNum = length(MethodNames);
    datasetsNum = length(SubDataNames);
    metricsNum = length(MetricNames);

    for methodID = 1 : methodsNum %% for each method
        
      
        for mc = 1: metricsNum %% for each metric
            switch MetricNames{mc}
                case 'AUC_Judd'
                    metricfunc = @getAUCJudd;
                case 'AUC_Borji'
                    metricfunc = @getAUCBorji;
                case 'NSS'
                    metricfunc = @getNSS;
                case 'sAUC'
                    metricfunc = @getSAUC;
                case 'KL'
                    metricfunc = @getKL;
                case 'CC'
                    metricfunc = @getCC;
                case 'EMD'
                    metricfunc = @getEMD;
                case 'SIM'
                    metricfunc = @getSIM;
                otherwise
                    printf(['\n Incorrect metric:', MetricNames{mc}]);
            end
            
            for ds = 1 : datasetsNum %% for each dataset
                switch SubDataNames{ds}
                    case 'AIM120'
                        load([DataDir,SubDataNames{ds},'\origfixdata.mat']);
                        
                        parfor fileID = 1: 120
                            fprintf(['methodID:',num2str(methodID),'..Metric:', num2str(mc),'..Pic:',num2str(fileID),'\n']);
                            bGtMap = eyeData{fileID}; % binary groundtruth
                            saMapName = [DataDir, SubDataNames{ds}, '\Saliency\',num2str(fileID),'_',MethodNames{methodID},'.png'];
                            saMap = double(imread(saMapName));
%                             saMap = saMapCell{fileID};%%test
                            if strcmp(MetricNames{mc}, 'sAUC')
                                idx = 1:120;
                                idx = idx(idx ~= fileID);
                                randIdx = randperm(length(idx));
                                idx = idx(randIdx(1:10)); % only take random 10 pics instead of all 1003
                                otherSaMap = zeros(size(eyeData{1}));
                                for MNidx=idx
                                    otherSaMap = otherSaMap + eyeData{MNidx};
                                end
                                tempresult = metricfunc(saMap, bGtMap, otherSaMap);
                                results(methodID, mc, ds, fileID) = tempresult;
                            else
                                otherSaMap = 0;
                                tempresult = metricfunc(saMap, bGtMap, otherSaMap);
                                results(methodID, mc, ds, fileID) = tempresult;
                            end
                            
                        end
                        
                    case 'MIT1003'
                        load([DataDir,SubDataNames{ds},'\origfixdata_sparse.mat']);
                        
                        parfor fileID = 1: 1003
                            fprintf(['methodID:',num2str(methodID),'..Metric:', num2str(mc),'..Pic:',num2str(fileID),'\n']);
                            bGtMap = full(eyeData{fileID}); % binary groundtruth
                            saMapName = [DataDir, SubDataNames{ds}, '\Saliency\',num2str(fileID),'_',MethodNames{methodID},'.png'];
                            saMap = double(imread(saMapName));
                            if strcmp(MetricNames{mc}, 'sAUC')
                                idx = 1:1003;
                                idx = idx(idx ~= fileID);
                                randIdx = randperm(length(idx));
                                idx = idx(randIdx(1:10)); % only take random 10 pics instead of all 1003
                                otherSaMap = zeros(size(eyeData{fileID}));
                                for MNidx=idx
                                    otherSaMap = otherSaMap + imresize(full(eyeData{MNidx}), size(otherSaMap));
                                end
                                tempresult = metricfunc(saMap, bGtMap, otherSaMap);
                                results(methodID, mc, ds, fileID) = tempresult;
                            else
                                otherSaMap = 0;
                                tempresult = metricfunc(saMap, bGtMap, otherSaMap);
                                results(methodID, mc, ds, fileID) = tempresult;
                            end
                        end
                        
                    case 'ImgSal'
                        load([DataDir,SubDataNames{ds},'\FixationGroundTruth.mat']);
                       parfor fileID = 1: 235
                            fprintf(['methodID:',num2str(methodID),'..Metric:', num2str(mc),'..Pic:',num2str(fileID),'\n']);
                            bGtMap = Fixation{fileID}; % binary groundtruth
                            saMapName = [DataDir, SubDataNames{ds}, '\Saliency\',num2str(fileID),'_',MethodNames{methodID},'.png'];
                            saMap = double(imread(saMapName));
%                             saMap = saMapCell{fileID};%%test
                            if strcmp(MetricNames{mc}, 'sAUC')
                                idx = 1:120;
                                idx = idx(idx ~= fileID);
                                randIdx = randperm(length(idx));
                                idx = idx(randIdx(1:10)); % only take random 10 pics instead of all 1003
                                otherSaMap = zeros(size(Fixation{1}));
                                for MNidx=idx
                                    otherSaMap = otherSaMap + Fixation{MNidx};
                                end
                                tempresult = metricfunc(saMap, bGtMap, otherSaMap);
                                results(methodID, mc, ds, fileID) = tempresult;
                            else
                                otherSaMap = 0;
                                tempresult = metricfunc(saMap, bGtMap, otherSaMap);
                                results(methodID, mc, ds, fileID) = tempresult;
                            end
                            
                        end
                end
                                
            end %% for each dataset

        end %% for each metric
    end %% for each method

end

function [result] = getEMD(saliencyMap, groundtruthMap, othersaliencyMap)
    [fixMap, ~] = antonioGaussian(groundtruthMap, 8);
    [score,~,~] = EMD(saliencyMap, fixMap);
    result = score;
end
function [result] = getSIM(saliencyMap, groundtruthMap, othersaliencyMap)
    [fixMap, ~] = antonioGaussian(groundtruthMap, 8);
    [score] = similarity(saliencyMap, fixMap);
    result = score;
end
function [result] = getCC(saliencyMap, groundtruthMap, othersaliencyMap)
    [fixMap, ~] = antonioGaussian(groundtruthMap, 8);
    [score] = CC(saliencyMap, fixMap);
    result = score;
end

function [result] = getKL(saliencyMap, groundtruthMap, othersaliencyMap)
%     [fixMap, ~] = antonioGaussian(groundtruthMap, 8);
    [score] = KLdiv(saliencyMap, groundtruthMap);
    result = score;
end

function [result] = getAUCJudd(saliencyMap, groundtruthMap, othersaliencyMap)
    [score,~,~,~] = AUC_Judd(saliencyMap, groundtruthMap,0,0);
    result = score;
end

function [result] = getAUCBorji(saliencyMap, groundtruthMap, othersaliencyMap)
    [score,~,~] = AUC_Borji(saliencyMap, groundtruthMap);
    result = score;
end

function [result] = getNSS(saliencyMap, groundtruthMap, othersaliencyMap)
    [score] = NSS(saliencyMap, groundtruthMap);
    result = score;
end

function [result] = getSAUC(saliencyMap, groundtruthMap, othersaliencyMap)
    [score] = AUC_shuffled(saliencyMap, groundtruthMap, othersaliencyMap);
    result = score;
end