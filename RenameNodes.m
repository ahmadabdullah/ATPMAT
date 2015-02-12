function[flag]= RenameNodes(codePath, sendingNode,receivingNode, filename)
%This is a helper function for CreateFault. It renames the nodes of the two halves of the
%line . It also insert measuring current and voltage probes at the
%terminals of the line

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


fid1=fopen(strcat(codePath,'\',filename,'04'),'r+');
sendingNodeLength=length(sendingNode);
receivingNodeLength=length(receivingNode);
flag=0;
while(~feof(fid1))
    s=ftell(fid1);
    line=fgets(fid1);
    if length(line)>14
        if((strcmp(strtrim(line(3:8)),sendingNode)&&strcmp(strtrim(line(9:14)),receivingNode))||(strcmp(strtrim(line(3:8)),receivingNode)&&strcmp(strtrim(line(9:14)),sendingNode)))
            line(3:3+sendingNodeLength)=strcat('M',sendingNode); %adding M to current measuring node
            line(9:11)='F1A'; %other node will be called F1A
            fseek(fid1,s,-1);
            fprintf(fid1,line);
            s=ftell(fid1);
            line=fgets(fid1);
            line(3:3+sendingNodeLength)=strcat('M',sendingNode(1:sendingNodeLength-1),'B'); %adding M to current measuring node
            line(9:11)='F1B'; %other node will be called F1B
            fseek(fid1,s,-1);
            fprintf(fid1,line);
            s=ftell(fid1);
            line=fgets(fid1);
            line(3:3+sendingNodeLength)=strcat('M',sendingNode(1:sendingNodeLength-1),'C'); %adding M to current measuring node
            line(9:11)='F1C'; %other node will be called F1C
            fseek(fid1,s,-1);
            fprintf(fid1,line);
            s=ftell(fid1);
            line=fgets(fid1);
            line(3:5)='F1A';%other node will be called F1A
            line(9:9+receivingNodeLength)=strcat('M',receivingNode);  %adding M to current measuring node
            fseek(fid1,s,-1);
            fprintf(fid1,line);
            s=ftell(fid1);
            line=fgets(fid1);
            line(3:5)='F1B';%other node will be called F1B
            line(9:9+receivingNodeLength)=strcat('M',receivingNode(1:receivingNodeLength-1),'B');  %adding M to current measuring node
            fseek(fid1,s,-1);
            fprintf(fid1,line);
            s=ftell(fid1);
            line=fgets(fid1);
            line(3:5)='F1C';%other node will be called F1C
            line(9:9+receivingNodeLength)=strcat('M',receivingNode(1:receivingNodeLength-1),'C');  %adding M to current measuring node
            fseek(fid1,s,-1);
            fprintf(fid1,line);
            flag=1;
        end
    end
end
fclose(fid1);

