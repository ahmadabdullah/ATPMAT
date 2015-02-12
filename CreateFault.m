function CreateFault(P,n,Dir,filename)
%This function creates a fault on the line under study with the parameters
%supplied by the user.
%P must come from the function CreateScenarios.m
%n is the current fault case
%Dir comes from SetBatchDirectories.m
%filename comes from ChangeSimulationSettings.m

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

%The following function inserts the fault block given the IPST paper
%into the file 'TempFaultFile'

InsertFaultBlock(Dir.codePath,filename);

%The following function duplicates the line aunder study.
[sendingNode,receivingNode ]=DuplicateLine(Dir.codePath, P.LineToStudy,filename );

%The following will reneame the nodes of the two halves of the line
RenameNodes(Dir.codePath,sendingNode,receivingNode, filename);

%Now inserting measuring probes
InsertProbes(Dir.codePath,sendingNode,receivingNode, filename);

switch P.type(n)
    case 1
        faultTypeStr='Normal';
    case 2
        faultTypeStr='AB_';
    case 3
        faultTypeStr='BC_';
    case 4
        faultTypeStr='CA_';
    case 5
        faultTypeStr='ABC_';
    case 6
        faultTypeStr='AG_';
    case 7
        faultTypeStr='BG_';
    case 8
        faultTypeStr='CG_';
    case 9
        faultTypeStr='ABG_';
    case 10
        faultTypeStr='BCG_';
    case 11
        faultTypeStr='CAG_';
    case 12
        faultTypeStr='ABCG_';
end

filename=strcat(Dir.codePath,'\',filename,'06');
fid1=fopen(filename,'r+'); % open file for reading and writing

fprintf('\nWhich Case? %5d/%5d:  ', n , P.numOfCases);
label_1='FAULT %6s   DISTANCE %5.1f   RESISTANCE %6.1f   ANGLE %5.1f   ';

%The following will change the paramters of the fault bloak according to
%the fault being created in the batch process
setFaultType(fid1,P.type(n),P.inctime(n),'F1',P.resistance(n), P.endTime)

%Now setting the lengths of both halves of the line
SetFaultLocation(fid1,P.LineToStudy,'F1',P.distance(n), P.WhichTerminal);

%Priting the case under consideration to screen
fprintf([label_1 '\n\n'],faultTypeStr,P.distance(n),P.resistance(n),P.angle(n));
fclose(fid1); % close file

%now copyin file to ATP directory
copyfile(filename, strcat(Dir.ATPEXEDir,'\','tempFaultFile.atp'));


%Now go to ATP and run!
cd(Dir.ATPEXEDir);
ATPOutputDec=system ('runATP.exe tempFaultFile.atp > output.txt');
Pl42matOutputDec=system ('pl42mat.exe tempFaultFile.pl4');

if ATPOutputDec==0
    fprintf('ATP Simulations completed successfully!\r\n');
end

if Pl42matOutputDec==0
    fprintf('Pl42mat completed successfully!');
end

%Now reneaming and moving mat files

filenameATP=strcat(Dir.ATPEXEDir,'\','tempFaultFile.mat') ;
name1=strcat('Case_',P.LineToStudy,'_');
name2=strcat(name1,faultTypeStr);
name3=name2;
if P.resistance(n)==1e-6
    name3=strcat(name3,'0Ohms_');
else
    name3=strcat(name3,num2str(P.resistance(n)),'Ohms_');
end
name4=strcat(name3,num2str(P.angle(n)),'d_');
newName=strcat(name4,num2str(P.distance(n)),'percent', '.mat');
newfile=strcat(Dir.dataPath,'\',newName);
movefile(filenameATP,newfile);

%Now go back to code
cd(Dir.codePath);

