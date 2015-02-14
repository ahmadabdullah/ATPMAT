function set_switchTime(fid1,ftyp,fint,BeginBus,EndBus)

%Helper function for setting switches

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

type='SWITCH';
BeginBus=BeginBus(1:length(BeginBus)-1);
EndBus=EndBus(1:length(EndBus)-1);
fend=fint+0.5;
BusA=strcat(BeginBus,'A');
BusB=strcat(BeginBus,'B');
BusC=strcat(BeginBus,'C');
BusSA=strcat(EndBus,'A');
BusSB=strcat(EndBus,'B');
BusSC=strcat(EndBus,'C');

switch ftyp
    case {2,4,5,6,9,11,12}                                        % A phase faulted
        fseek(fid1,0,-1);                                          % set position indicator to begining of file
        rowNumber=getRowNumber(BusA,BusSA,type,fid1);                   %find row number
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);                                         % move file position indicator
        end
        setSwitchOpenCloseTimes(fid1,fint,fend);                                % function for writing breaker data
        fseek(fid1,0,-1);
        
end

switch ftyp
    case {2,3,5,7,9,10,12}                                        % B phase faulted
        fseek(fid1,0,-1);                                          % set position indicator to begining of file
        rowNumber=getRowNumber(BusB,BusSB,type,fid1);                   %find row number
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);                                         % move file position indicator
        end
        setSwitchOpenCloseTimes(fid1,fint,fend);                                % function for writing breaker data
        fseek(fid1,0,-1);
end

switch ftyp
    case {3,4,5,8,10,11,12}                                       % C phase faulted
        fseek(fid1,0,-1);                                          % set position indicator to begining of file
        rowNumber=getRowNumber(BusC,BusSC,type,fid1);                   %find row number
        fseek(fid1,0,-1);
        for i=1:rowNumber-1
            fgetl(fid1);                                         % move file position indicator
        end
        setSwitchOpenCloseTimes(fid1,fint,fend);                                % function for writing breaker data
        fseek(fid1,0,-1);
end


