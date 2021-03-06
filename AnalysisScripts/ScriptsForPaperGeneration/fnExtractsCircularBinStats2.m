function [a2fResBinNorm, a2fStimResBinNorm,a2fPValue,a2fResBin, a2fStimResBin]=fnExtractsCircularBinStats2(aiTrialTypesA, aiTrialTypesB, iOutcomeIndex, a2cTrialStats, bUseCue, acIntervals)

iNumTrialTypes=length(aiTrialTypesA);
iNumBins = length(acIntervals);
a2fRes = nans(8,4001);
a2fResStim = nans(8,4001);

for iTrialTypeIter=1:iNumTrialTypes
    if isempty(a2cTrialStats{aiTrialTypesA(iTrialTypeIter) ,iOutcomeIndex})
        continue;
    end;
    if bUseCue
        a2fRes(iTrialTypeIter,:) = mean(a2cTrialStats{aiTrialTypesA(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterCue.m_a2fSmoothRaster,1);
        a2fResStim(iTrialTypeIter,:) = mean(a2cTrialStats{aiTrialTypesB(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterCue.m_a2fSmoothRaster,1);
    else
        a2fRes(iTrialTypeIter,:) = mean(a2cTrialStats{aiTrialTypesA(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterSaccade.m_a2fSmoothRaster,1);
        a2fResStim(iTrialTypeIter,:) = mean(a2cTrialStats{aiTrialTypesB(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterSaccade.m_a2fSmoothRaster,1);
    end
end

a2fResBin= zeros(iNumTrialTypes, iNumBins);
a2fStimResBin= zeros(iNumTrialTypes, iNumBins);
for iTrialTypeIter=1:iNumTrialTypes
    for k=1:iNumBins
        aiBinInterval = acIntervals{k};
        a2fResBin(iTrialTypeIter,k) =  mean(a2fRes(iTrialTypeIter,aiBinInterval));
        a2fStimResBin(iTrialTypeIter,k) =  mean(a2fResStim(iTrialTypeIter,aiBinInterval));
    end
end
fNorm = max([a2fResBin(:);a2fStimResBin(:)]);
a2fResBinNorm = a2fResBin / fNorm;
a2fStimResBinNorm =  a2fStimResBin / fNorm;


% Determine significance per bin using trial data....
a2fPValue = nans(iNumTrialTypes, iNumBins);
for iTrialTypeIter=1:iNumTrialTypes
    if isempty(a2cTrialStats{aiTrialTypesA(iTrialTypeIter) ,iOutcomeIndex})
        continue;
    end;
    for iBinIter=1:iNumBins    
            aiBinInterval = acIntervals{k};
           if bUseCue
               iNumTrialsA = size(a2cTrialStats{aiTrialTypesA(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterCue.m_a2fSmoothRaster,1);
               iNumTrialsB = size(a2cTrialStats{aiTrialTypesB(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterCue.m_a2fSmoothRaster,1);
           else
               iNumTrialsA = size(a2cTrialStats{aiTrialTypesA(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterSaccade.m_a2fSmoothRaster,1);
               iNumTrialsB = size(a2cTrialStats{aiTrialTypesB(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterSaccade.m_a2fSmoothRaster,1);
               
           end
           
           afResBinA = zeros(1,iNumTrialsA);
           afResBinB = zeros(1,iNumTrialsB);
           for iTrialIter=1:iNumTrialsA
                 if bUseCue
                    afResBinA(iTrialIter)= mean(a2cTrialStats{aiTrialTypesA(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterCue.m_a2fSmoothRaster(iTrialIter, aiBinInterval));
                 else
                     afResBinA(iTrialIter)= mean(a2cTrialStats{aiTrialTypesA(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterSaccade.m_a2fSmoothRaster(iTrialIter, aiBinInterval));
                 end
           end
           for iTrialIter=1:iNumTrialsB
               if bUseCue
                afResBinB(iTrialIter)= mean(a2cTrialStats{aiTrialTypesB(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterCue.m_a2fSmoothRaster(iTrialIter, aiBinInterval));
               else
                   afResBinB(iTrialIter)= mean(a2cTrialStats{aiTrialTypesB(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterSaccade.m_a2fSmoothRaster(iTrialIter, aiBinInterval));
               end
           end
           a2fPValue(iTrialTypeIter,iBinIter) = ranksum(afResBinA,afResBinB);
    end
end
% 
%     if bUseCue
%         
%         a2fRes(iTrialTypeIter,:) = mean(a2cTrialStats{aiTrialTypesA(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterCue.m_a2fSmoothRaster,1);
%         a2fResStim(iTrialTypeIter,:) = mean(a2cTrialStats{aiTrialTypesB(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterCue.m_a2fSmoothRaster,1);
%     else
%         a2fRes(iTrialTypeIter,:) = mean(a2cTrialStats{aiTrialTypesA(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterSaccade.m_a2fSmoothRaster,1);
%         a2fResStim(iTrialTypeIter,:) = mean(a2cTrialStats{aiTrialTypesB(iTrialTypeIter) ,iOutcomeIndex}.m_strctRasterSaccade.m_a2fSmoothRaster,1);
%     end
% end


return