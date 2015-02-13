function[]=InsertProbes(codePath,sendingNode,receivingNode, filename, P)
%This is a helper function for CreateFault. It inserts probes in the ATP file after the line
%is split and nodes are renamed

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
tempIndex1='04';
tempIndex2='05';
if strcmp('light', P.eventCode)
    tempIndex1='05';
    tempIndex2='06';
end
fid1=fopen(strcat(codePath,'\',filename,tempIndex1), 'r');
filePath2=strcat(codePath,'\',filename,tempIndex2);
fid2=fopen(filePath2,'w');
sendingNodeLength=length(sendingNode);
receivingNodeLength=length(receivingNode);
ProbeLines=fileread(strcat(codePath,'\','CurrentProbes.txt'));

%No inserting two current probes
while(~feof(fid1))
    line=fgets(fid1);
    fprintf(fid2,line);
    if strcmp(line(1:7),'/SWITCH')
        line=fgets(fid1);
        fprintf(fid2,line);
        fprintf(fid2,ProbeLines);
    end
end
fclose(fid1);
fclose(fid2);

%Now changing the node names of the probes
fid1=fopen(strcat(codePath,'\',filename,tempIndex2), 'r+');
while(~feof(fid1))
    line=fgets(fid1);
    if strcmp(line(1:7),'/SWITCH')
        fgets(fid1);
        s=ftell(fid1);
        line=fgets(fid1);
        line(3:8)='      ';%Clearing field
        line(3:2+sendingNodeLength)=sendingNode;
        line(9:14)='      ';%Clearing field
        line(9:9+receivingNodeLength)=strcat('M',sendingNode);
        fseek(fid1,s,-1);
        fprintf(fid1,line);
        s=ftell(fid1);
        line=fgets(fid1);
        line(3:8)='      ';%Clearing field
        line(3:2+sendingNodeLength)=strcat(sendingNode(1:sendingNodeLength-1),'B');
        line(9:14)='      ';%Clearing field
        line(9:9+receivingNodeLength)=strcat('M',strcat(sendingNode(1:sendingNodeLength-1),'B'));
        fseek(fid1,s,-1);
        fprintf(fid1,line);
        s=ftell(fid1);
        line=fgets(fid1);
        line(3:8)='      ';%Clearing field
        line(3:2+sendingNodeLength)=strcat(sendingNode(1:sendingNodeLength-1),'C');
        line(9:14)='      ';%Clearing field
        line(9:9+receivingNodeLength)=strcat('M',strcat(sendingNode(1:sendingNodeLength-1),'C'));
        fseek(fid1,s,-1);
        fprintf(fid1,line);
        s=ftell(fid1);
        line=fgets(fid1);
        line(3:8)='      ';%Clearing field
        line(3:2+receivingNodeLength)=receivingNode;
        line(9:14)='      ';%Clearing field
        line(9:9+sendingNodeLength)=strcat('M',receivingNode);
        fseek(fid1,s,-1);
        fprintf(fid1,line);
        s=ftell(fid1);
        line=fgets(fid1);
        line(3:8)='      ';%Clearing field
        line(3:2+receivingNodeLength)=strcat(receivingNode(1:receivingNodeLength-1),'B');
        line(9:14)='      ';%Clearing field
        line(9:9+sendingNodeLength)=strcat('M',strcat(receivingNode(1:receivingNodeLength-1),'B'));
        fseek(fid1,s,-1);
        fprintf(fid1,line);
        s=ftell(fid1);
        line=fgets(fid1);
        line(3:8)='      ';%Clearing field
        line(3:2+receivingNodeLength)=strcat(receivingNode(1:receivingNodeLength-1),'C');
        line(9:14)='      ';%Clearing field
        line(9:9+sendingNodeLength)=strcat('M',strcat(receivingNode(1:receivingNodeLength-1),'C'));
        fseek(fid1,s,-1);
        fprintf(fid1,line);
        break;
    end
end

%Now inserting voltage probes at the origianl sending and receiving nodes.

while(~feof(fid1))
    line=fgets(fid1);
    if strcmp(line(1:7),'/OUTPUT')
        s=ftell(fid1);
        line=fgets(fid1);
        lineLength=length(line);
        %Now clearing the line
        for i=1:lineLength-2 % -2 to execlude the last two special characters from writing
            line(i)=' ';
        end
        %Now writing the measuring node to the first line
        line(3:2+receivingNodeLength)=strcat(receivingNode(1:receivingNodeLength-1),'A');
        line(9:8+receivingNodeLength)=strcat(receivingNode(1:receivingNodeLength-1),'B');
        line(15:14+receivingNodeLength)=strcat(receivingNode(1:receivingNodeLength-1),'C');
        fseek(fid1, s,-1);
        fprintf(fid1,line);
    end
end
fclose(fid1);

tempIndex1='05';
tempIndex2='06';
if strcmp('light', P.eventCode)
    tempIndex1='06';
    tempIndex2='07';
end
%Now creating another file for the other voltage probes
fid1=fopen(strcat(codePath,'\',filename,tempIndex1), 'r');
filePath2=strcat(codePath,'\',filename,tempIndex2);
fid2=fopen(filePath2,'w');
while(~feof(fid1))
    line=fgets(fid1);
    fprintf(fid2,line);
    if strcmp(line(1:7),'/OUTPUT')
        line=fgets(fid1);
        fprintf(fid2,line);
        line2=line;
        line2(3:2+sendingNodeLength)=strcat(sendingNode(1:sendingNodeLength-1),'A');
        line2(9:8+sendingNodeLength)=strcat(sendingNode(1:sendingNodeLength-1),'B');
        line2(15:14+sendingNodeLength)=strcat(sendingNode(1:sendingNodeLength-1),'C');
        fprintf(fid2,line2);
    end
end
fclose(fid1);
fclose(fid2);
fclose('all');
