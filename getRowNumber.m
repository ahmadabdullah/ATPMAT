function [rowNumber]=getRowNumber(fromBus,toBus,type,fid1)
%This is a helper function that locate characters in certain line in the
%ATP file. It returns the row number of that line in the ATP file.

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
firstCharacterPlace=3;
secondCharacerPlace=9;
rowNumber=0;
switch type
    case {'BRANCH','SWITCH','SOURCE'}
        rowNumber=1;
        while (1)
            line=fgetl(fid1);
            if line==-1
                rowNumber=0;
                break;
            end
            if length(line)<13
                line='*************';
            end
            if (strcmp(line(firstCharacterPlace:firstCharacterPlace+length(fromBus)-1),fromBus)==1)&&(strcmp(line(secondCharacerPlace:secondCharacerPlace+length(toBus)-1),toBus)==1)
                break;
            end
            rowNumber=rowNumber+1;
        end     
end

if rowNumber==0
    switch type
        case {'BRANCH','SWITCH','SOURCE'}
            rowNumber=1;
            while (1)
                line=fgetl(fid1);
                if line==-1
                    rowNumber=0;
                    break;
                end
                if length(line)<13
                    line='*************';
                end
                if (strcmp(line(firstCharacterPlace:firstCharacterPlace+length(toBus)-1),toBus)==1)&&(strcmp(line(secondCharacerPlace:secondCharacerPlace+length(fromBus)-1),fromBus)==1)
                    break;
                end
                rowNumber=rowNumber+1;
            end
    end
end