function []=InsertFaultBlock(codePath,TempFaultFile)
%This function inserts a default fault block in temporary fault file for
%ATP settings.

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


filePath1=strcat(codePath,'\',TempFaultFile);
filePath2=strcat(codePath,'\',TempFaultFile,'02');
fid1=fopen(filePath1,'r');
fid2=fopen(filePath2,'w');
%Now finding the /BRANCH keyword in ATP file
while(~feof(fid1))
    line=fgets(fid1);
    fprintf(fid2,line);
    if length(line)>6
        if strcmp(line(1:7),'/BRANCH')
            line=fgets(fid1);
            fprintf(fid2,line);
            line=fgets(fid1);
            fprintf(fid2,line);
            BranchLines=fileread(strcat(codePath,'\','FaultBlockBranches.txt'));
            fprintf(fid2,BranchLines);
        end
    end
end
fclose(fid1);
fclose(fid2);
% Now finding /Switch in the ATP file and inserting some switches
filePath3=strcat(codePath,'\',TempFaultFile,'03');
fid3=fopen(filePath3,'w');
fid2=fopen(filePath2,'r');
flag=0;
while(~feof(fid2))
    line=fgets(fid2);
    fprintf(fid3,line);
    if length(line)>6
        if strcmp(line(1:7),'/SWITCH')
            line=fgets(fid2);
            fprintf(fid3,line);
            BranchLines=fileread(strcat(codePath,'\','FaultBlockSwitches.txt'));
            fprintf(fid3,BranchLines);
            flag=1;
        end
    end
end
fclose(fid2);
fclose(fid3);
if flag==0 % Means no switches were present in the file
    error('Original ATP file does not have any switches!');
end