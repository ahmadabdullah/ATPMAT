function[sendingNode,receivingNode]=DuplicateFaultedLine(codePath, LineToStudy, filename)
%A helper funciton to duplicate faulted line

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

fid1=fopen(strcat(codePath,'\',filename,'03'), 'r');
fid2=fopen(strcat(codePath,'\',filename,'04'), 'w');
[sendingNode, receivingNode]=strtok(LineToStudy,'-');
sendingNode=strcat(sendingNode,'A');
receivingNode=receivingNode(2:end);
receivingNode=strcat(receivingNode,'A');

while(~feof(fid1))
    s=ftell(fid1);
    line=fgets(fid1);
    fprintf(fid2,line);
    if length(line)>14
        if((strcmp(strtrim(line(3:8)),sendingNode)&&strcmp(strtrim(line(9:14)),receivingNode))||(strcmp(strtrim(line(3:8)),receivingNode)&&strcmp(strtrim(line(9:14)),sendingNode)))
            line=fgets(fid1);
            fprintf(fid2,line);
            line=fgets(fid1);
            fprintf(fid2,line);
            fseek(fid1,s,-1);
            line=fgets(fid1);
            fprintf(fid2,line);
            line=fgets(fid1);
            fprintf(fid2,line);
            line=fgets(fid1);
            fprintf(fid2,line);
        end
    end
end
fclose(fid1);
fclose(fid2);