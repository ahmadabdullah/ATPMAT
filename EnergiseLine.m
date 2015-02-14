function[]=EnergiseLine(Scenarios,num, Dir, filename)
%This is the main fuction for line energisation

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


fprintf('\n')
%create a temporary file for simulation
cd(Dir.codePath);

[sendingNode, receivingNode]=strtok(Scenarios.LineToStudy,'-');
sendingNode=strcat(sendingNode,'A');
receivingNode=receivingNode(2:end);
receivingNode=strcat(receivingNode,'A');

%Now rename the nodes of the line
RenameNodesLineEnergisation(Dir.codePath, sendingNode,receivingNode, filename ) ;

%Now inserting measuring probes
InsertProbes(Dir.codePath,sendingNode,receivingNode, filename, Scenarios);

filename=strcat(Dir.codePath,'\',filename,'03');
fid1=fopen(filename,'r+'); % open file for reading and writing

fprintf('\nWhich Case? %5d/%5d:  ', num , Scenarios.numOfCases);
label_1='    ANGLE %5.1f   ';

if  Scenarios.distance(num)==0
    set_switchTime(fid1,12,Scenarios.inctime(num),sendingNode,strcat('M',sendingNode));
else
    set_switchTime(fid1,12,Scenarios.inctime(num),receivingNode,strcat('M',sendingNode));
end

fprintf([label_1 '\n\n'],Scenarios.angle(num));
fclose(fid1); % close file