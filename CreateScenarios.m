function [P]=CreateScenarios(startTime, endTime, eventCode, eventSamplingTime, eventDistance, eventAngle, eventAmplitude, faultResistance, faultType, LineToStudy, WhichEnd )
%This function creates a batch of scenarios
% The user enters the paramters of the scenarios he wants to create
% along with the type of simulations and the function
% returns a structure to be used with the function 'BatchProcessATP'
%
% endTime is the time at which simulations are terminated.
% eventCode is the code of the event. It has to be one of three values:
% 1)'light', 2)'fault, 3)'energ'. This field is case sensitive.
%
% eventDistance is usually a vector containing all distances -in percentage-
% where the user wants the event to be created. If a user wants to create faults
% at 60% and 90% of the line then he can enter [60 90] as an eventDistance
% vector. The minimum is 5% and the maximum is 95%. In case of line
% energisation the distance has to be either 0 or 100 to convey which end of
% the line is being energized.
%
% eventAngle is another vector specifying the incibient angle of the event.
% If a user want to create a fault at 30 degrees and 60 degrees then he
% enters [30 60].
%
% sysFreq is the system freqeuncy which is either 50 or 60Hz.
%
% faultResistance is the resitnace of the fault.
%
% faultType This is the type of the fault. Itcould be one of the following
% 2)AB 3)BC 4)CA 5)ABC 6)AG 7)BG 8)CG 9)ABG 10)BCG 11)CAG 12)ABCG
% When faultType is used with lightning, one need to select the phases to
% hit. Type is then has to be either one of 6, 7 or 8 for phases A, B and C
% respectively. In case of line enrgisation type has to be 5. Currenlty
% only 3 phase switching is supported, single pole switching will be
% supported next versions.
% One has to note that the start time of the simulations is given by the
% relation:
% start time of simulations (which is the time of changing network
% configuration ) = startTime+ eventAngle/360/60
%
% LineToStudy has to be in the following format B1-B2 to denore the line
% connecting nodes B1 and B2. Nodes of the line has to be two characters
% only. 

% WhichEnd is the which of the nodes of the line where the distance
% vector is measured. 

%/*Copyright (c) 2014, Ahmad Abdullah
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without modification,
% are permitted provided that the following conditions are met:
%
%  Redistributions of source code must retain the above copyright notice, this
% list of conditions and the following disclaimer.
%
% * Redistributions in binary form must reproduce the above copyright notice,
% this list of conditions and the following disclaimer in the documentation
% and/or other materials provided with the distribution.
%
% * The names of its contributors may not be used to endorse or promote products
% derived from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
% USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/
%
%   @author Ahmad Abdullah
%   @e-mail ahmad.abdullah@ieee.org
%
eventStruct.integrationTimeStep=eventSamplingTime;
eventStruct.tend=endTime;

P=struct('eventCode',eventCode,'eventSamplingTime',eventSamplingTime,'endTime',endTime, 'startTime',startTime);

eventStruct.time=startTime; % fault incident time [s]
eventStruct.type=faultType; % type of fault 1)N 2)AB 3)BC 4)CA 5)ABC 6)AG 7)BG 8)CG 9)ABG 10)BCG 11)CAG 12)ABCG
eventStruct.distance=eventDistance;   % fault distance in [%]
eventStruct.resistance=faultResistance;   % fault resistance in [ohm]
eventStruct.angle=eventAngle;   % fault incident angle in [deg]
eventStruct.amplitude=eventAmplitude;
eventStruct.type=sort(eventStruct.type);
eventStruct.distance=sort(eventStruct.distance);
eventStruct.resistance=sort(eventStruct.resistance);
eventStruct.angle=sort(eventStruct.angle);
for k=1:length(eventStruct.resistance) % adjust fault resistance
    eventStruct.resistance(k)=max(eventStruct.resistance(k),1e-6); % This is to get rid of zero fault resistance
end
P.min_dist=5.0; % minimum distance between bus and fault point in %
n=0;
P.endTime=endTime;
P.eventCode=eventCode;
P.SamplingTime=eventSamplingTime;
if strcmp(eventCode,'fault')
    for i=1:length(eventStruct.type)
        for j=1:length(eventStruct.angle)
            for k=1:length(eventStruct.distance)
                for l=1:length(eventStruct.resistance)
                    n=n+1;
                    P.type(n)=eventStruct.type(i);
                    if eventStruct.distance(k)<=50
                        P.distance(n)=max(eventStruct.distance(k), P.min_dist);
                    else
                        P.distance(n)=min(eventStruct.distance(k), 100-P.min_dist);
                    end
                    P.resistance(n)=eventStruct.resistance(l);
                    P.angle(n)=eventStruct.angle(j);
                    P.inctime(n)=eventStruct.time+eventStruct.angle(j)/360/60;
                    if eventStruct.type(i)<6
                        break
                    end
                end
                if eventStruct.type(i)==1
                    break
                end
            end %end of loop k
        end %end of loop j
    end %end of loop i
    P.numOfCases=n;
elseif strcmp(eventCode,'light')
    for i=1:length(eventStruct.type)
        for j=1:length(eventStruct.angle)
            for k=1:length(eventStruct.distance)
                for l=1:length(eventStruct.amplitude)
                    n=n+1;
                    P.type(n)=eventStruct.type(i);
                    if eventStruct.distance(k)<=50
                        P.distance(n)=max(eventStruct.distance(k), P.min_dist);
                    else
                        P.distance(n)=min(eventStruct.distance(k), 100-P.min_dist);
                    end
                    P.amplitude(n)=eventStruct.amplitude(l);
                    P.angle(n)=eventStruct.angle(j);
                    P.inctime(n)=eventStruct.time+eventStruct.angle(j)/360/60;
                end
            end %end of loop k
        end %end of loop j
    end %end of loop i
    P.numOfCases=n;
else %for line energization
    for i=1:length(eventStruct.type)
        for j=1:length(eventStruct.angle)
            for k=1:length(eventStruct.distance)
                n=n+1;
                P.type(n)=eventStruct.type(i);
                P.distance(n)=eventStruct.distance(k);
                P.angle(n)=eventStruct.angle(j);
                P.inctime(n)=eventStruct.time+eventStruct.angle(j)/360/60;
            end %end of loop k
        end %end of loop j
    end %end of loop i
    P.numOfCases=n;
end
P.LineToStudy=LineToStudy;
P.WhichTerminal=WhichEnd;