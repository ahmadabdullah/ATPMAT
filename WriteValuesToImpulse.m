function []=WriteValuesToImpulse(fid1, s,amplitude, startTime)

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

fseek(fid1,0,-1);
s1=17;% this is the place to change the amplitude. Format is 1.E5 to mean 100000
s2=66; %This goes to the time of the start of the wave
fseek(fid1,s+s1-2,-1);%Now at starting of changing amplitude
exponentAmp=floor(log10(amplitude));
mantissa=amplitude/10^exponentAmp;
mantissaSTR=num2str(mantissa);
%mantissaToBeWritten='';
if length(mantissaSTR)>=3
    mantissaToBeWritten=mantissaSTR(1:3);
else
    mantissaToBeWritten=[mantissaSTR(1) '.0'];
end
mantissaSTR2=strcat([mantissaToBeWritten 'E'],num2str(exponentAmp));
fprintf(fid1,mantissaSTR2);%Now we just wrote the amplitude
fseek(fid1,0,-1);
fseek(fid1,s+s2-3,-1); %we are about to write the opening time
startTimeSTR=num2str(startTime);
zerosVec='0000';
if length(startTimeSTR)<=6
    startTimeSTR2=startTimeSTR(3:length(startTimeSTR));
    startTimeSTR2=strcat(startTimeSTR2,zerosVec(1:(5-length(startTimeSTR2))));
else
    startTimeSTR2=startTimeSTR(3:7);
end
startTimeSTR2=strcat('0.',startTimeSTR2);
fprintf(fid1,startTimeSTR2);