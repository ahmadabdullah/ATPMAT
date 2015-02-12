function setGroundFaultResistance(fid1,faultType,faultBus, faultResistance)
%This is a helper function to write the ground fault resitance to the ATP
%file. The ground fault resitance which is inserted by default previously
%in the code is now replaced by a resistance supplied by the user.

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



% type='SWITCH';
whichCard='BRANCH';

BusNA=strcat(faultBus,'NA');
BusNB=strcat(faultBus,'NB');
BusNC=strcat(faultBus,'NC');
BusG=' ';


switch faultType
    case {9,11}
        % set position indicator to begining of file
        fseek(fid1,0,-1);
        %find row number
        rowNumber=getRowNumber(BusNA,BusG,whichCard,fid1);
        fseek(fid1,0,-1);
        %move file position indicator
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        %function for switch data
        setFaultResistance(fid1,2*faultResistance);
        fseek(fid1,0,-1);
end


switch faultType
    case {9,10}
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusNB,BusG,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setFaultResistance(fid1,2*faultResistance);
        fseek(fid1,0,-1);
end

switch faultType
    case {10,11}
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusNC,BusG,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setFaultResistance(fid1,2*faultResistance);
        fseek(fid1,0,-1);
end

switch faultType
    case {6}
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusNA,BusG,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setFaultResistance(fid1,faultResistance);
        fseek(fid1,0,-1);
end

switch faultType
    case {7}
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusNB,BusG,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setFaultResistance(fid1,faultResistance);
        fseek(fid1,0,-1);
end

switch faultType
    case {8}
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusNC,BusG,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setFaultResistance(fid1,faultResistance);
        fseek(fid1,0,-1);
end

switch faultType
    case {12}
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusNA,BusG,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setFaultResistance(fid1,3*faultResistance);
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusNB,BusG,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setFaultResistance(fid1,3*faultResistance);
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusNC,BusG,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setFaultResistance(fid1,3*faultResistance);
        fseek(fid1,0,-1);
end