function[]=SetPhaseStrokeByLightning(lighttype, fid1, amplitude,inctime)
%adjusts which phase of line being hit by lightning


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
switch lighttype
    case {6}
        [s]=findImpulsePhA(fid1);
        WriteValuesToImpulse(fid1, s,amplitude, inctime);
        getRowNumber('F1A','FA','SWITCH',fid1);
        setSwitchOpenCloseTimes(fid1,inctime,0.1);
    case {7}
        [s]=findImpulsePhB(fid1);
        WriteValuesToImpulse(fid1, s,amplitude, inctime);
        getRowNumber('F1B','FB','SWITCH',fid1);
        setSwitchOpenCloseTimes(fid1,inctime,0.1);
    case {8}
        [s]=findImpulsePhC(fid1);
        WriteValuesToImpulse(fid1, s,amplitude, inctime);
        getRowNumber('F1C','FC','SWITCH',fid1);
        setSwitchOpenCloseTimes(fid1,inctime,0.1);
end
fseek(fid1,0,-1);