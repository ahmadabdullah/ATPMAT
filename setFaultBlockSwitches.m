function []= setFaultBlockSwitches(fid1,faultType,startTime,faultBus, endTime)
%A helper function to set the switches of the fault block inserted
%previously

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


whichCard='SWITCH';

%The following give a one to one mapping to the fault block inserted.
BusA=strcat(faultBus,'A');
BusB=strcat(faultBus,'B');
BusC=strcat(faultBus,'C');
BusS=strcat(faultBus,'S');
BusSA=strcat(faultBus,'SA');
BusSB=strcat(faultBus,'SB');
BusSC=strcat(faultBus,'SC');
BusNA=strcat(faultBus,'NA');
BusNB=strcat(faultBus,'NB');
BusNC=strcat(faultBus,'NC');

switch faultType
    case {2,4,5,6,9,11,12}   % fault on phase A
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusA,BusS,whichCard,fid1);
        fseek(fid1,0,-1);
        % skip all lines till you get to the switch
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setSwitchOpenCloseTimes(fid1,startTime,endTime);
        fseek(fid1,0,-1);
end

switch faultType
    case {2,3,5,7,9,10,12}     % B phase faulted
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusB,BusS,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setSwitchOpenCloseTimes(fid1,startTime,endTime);
        fseek(fid1,0,-1);
end

switch faultType
    case {3,4,5,8,10,11,12}                                       % C phase faulted
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusC,BusS,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setSwitchOpenCloseTimes(fid1,startTime,endTime);
        fseek(fid1,0,-1);
end

switch faultType
    case {6,9,11,12}                                       %ground fault phase A
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusSA,BusNA,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setSwitchOpenCloseTimes(fid1,startTime,endTime);
        fseek(fid1,0,-1);
end

switch faultType
    case {7,9,10,12}                                       %ground fault phase B
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusSB,BusNB,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setSwitchOpenCloseTimes(fid1,startTime,endTime);
        fseek(fid1,0,-1);
end

switch faultType
    case {8,10,11,12}                                       %ground fault phase C
        fseek(fid1,0,-1);
        rowNumber=getRowNumber(BusSC,BusNC,whichCard,fid1);
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);
        end
        setSwitchOpenCloseTimes(fid1,startTime,endTime);
        fseek(fid1,0,-1);
end
