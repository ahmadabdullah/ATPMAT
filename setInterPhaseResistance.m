function[]=setInterPhaseResistance(fid1,faultType,faultBus,faultResistance)
%A helper function for writing the fault resitance between phases. 

%This file is part of ATPMAT
%For more information, please go to https://bitbucket.org/ahmadmabdullah/atpmat
% ATPMAT is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published
%   by the Free Software Foundation, either version 3 of the License,
%   or (at your option) any later version.
%
%   ATPMAT is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with MATPOWER. If not, see <http://www.gnu.org/licenses/>.
%
%   Additional permission under GNU GPL version 3 section 7
%
%   If you modify ATPMAT, or any covered work, to interface with
%   other modules (such as MATLAB code and MEX-files) available in a
%   MATLAB(R) or comparable environment containing parts covered
%   under other licensing terms, the licensors of MATPOWER grant
%   you additional permission to convey the resulting work.


%The following give a one to one mapping to the fault block inserted.

BusSA=strcat(faultBus,'SA');
BusSB=strcat(faultBus,'SB');
BusSC=strcat(faultBus,'SC');
whichCard='BRANCH';

switch faultType
    case {2,5}                                       % A-B fault
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusSA,BusSB,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setFaultResistance(fid1,faultResistance);
        fseek(fid1,0,-1);
end

switch faultType
    case {3,5}                                       %  B-C fault
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusSB,BusSC,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setFaultResistance(fid1,faultResistance)
        fseek(fid1,0,-1);
end

switch faultType
    case {4,5}                                       % C-A fault
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusSC,BusSA,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setFaultResistance(fid1,faultResistance)
        fseek(fid1,0,-1);
        
end