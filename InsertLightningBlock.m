function[]=InsertLightningBlock(codePath,TempLightningFile)
%This function inserts a standard lightning block in the ATP file.

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


filePath1=strcat(codePath,'\',TempLightningFile);
filePath2=strcat(codePath,'\',TempLightningFile,'02');
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
            BranchLines=fileread(strcat(codePath,'\','LightningBlockBranches.txt'));
            fprintf(fid2,BranchLines);
        end
    end
end
fclose(fid1);
fclose(fid2);
% Now finding /Switch in the ATP file and inserting some switches
filePath3=strcat(codePath,'\',TempLightningFile,'03');
fid3=fopen(filePath3,'w');
fid2=fopen(filePath2,'r');
while(~feof(fid2))
    line=fgets(fid2);
    fprintf(fid3,line);
    if length(line)>6
        if strcmp(line(1:7),'/SWITCH')
            line=fgets(fid2);
            fprintf(fid3,line);
            BranchLines=fileread(strcat(codePath,'\','LightningBlockSwitches.txt'));
            fprintf(fid3,BranchLines);
        end
    end
end
fclose(fid2);
fclose(fid3);

%Now finding source section and inserting lightning source
filePath4=strcat(codePath,'\',TempLightningFile,'04');
fid4=fopen(filePath4,'w');
fid3=fopen(filePath3,'r');
while(~feof(fid3))
    line=fgets(fid3);
    fprintf(fid4,line);
    if length(line)>6
        if strcmp(line(1:7),'/SOURCE')
            line=fgets(fid3);
            fprintf(fid4,line);
            BranchLines=fileread(strcat(codePath,'\','LightningBlockSources.txt'));
            fprintf(fid4,BranchLines);
        end
    end
end
fclose(fid4);
fclose(fid3);