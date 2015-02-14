function[]=SwitchLine(Scenarios,num, Dir, filename)
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

%now inserting switches at both ends of the line
InsertSwitches(Dir.codePath,sendingNode,receivingNode, filename)

filename=strcat(Dir.codePath,'\',filename,'04');
fid1=fopen(filename,'r+'); % open file for reading and writing

fprintf('\nWhich Case? %5d/%5d:  ', num , Scenarios.numOfCases);
label_1='    ANGLE %5.1f   ';

if  Scenarios.distance(num)==0
    set_switchTime(fid1,12,Scenarios.inctime(num),strcat('P',sendingNode),strcat('M',sendingNode));
else
    set_switchTime(fid1,12,Scenarios.inctime(num),strcat('P',receivingNode),strcat('M',receivingNode));
end

fprintf([label_1 '\n\n'],Scenarios.angle(num));
fclose(fid1); % close file

%now copyin file to ATP directory
copyfile(filename, strcat(Dir.ATPEXEDir,'\','tempEnergisationFile.atp'));

%Now go to ATP and run!
cd(Dir.ATPEXEDir);
ATPOutputDec=system ('runATP.exe tempEnergisationFile.atp > output.txt');
Pl42matOutputDec=system ('pl42mat.exe tempEnergisationFile.pl4');

if ATPOutputDec==0
    fprintf('ATP Simulations completed successfully!\r\n');
end

if Pl42matOutputDec==0
    fprintf('Pl42mat completed successfully!');
end

filenameATP=strcat(Dir.ATPEXEDir,'\','tempEnergisationFile.mat') ;
name1=strcat('Case_',Scenarios.LineToStudy,'_');
name2=strcat(name1,num2str(Scenarios.angle(num)),'d_');
newName=strcat(name2,num2str(Scenarios.distance(num)),'percent', '.mat');
newfile=strcat(Dir.dataPath,'\',newName);
movefile(filenameATP,newfile);

%Closing all streams
fclose('all');
%Now go back to code
cd(Dir.codePath);
