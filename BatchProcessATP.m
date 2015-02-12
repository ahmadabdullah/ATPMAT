function []= BatchProcessATP(Scenarios, fileName,codePath, OutputPath, fileDir, ATPEXEDir)
%This is the main function for Batch Processing ATP files
% The user inputs whether he wants to create line energization , fault or a
% lightning case. The user passes the parameters for cases and the system will
% start batching.
% Scenarios must come from the function CreateScenarios
% fileName is the name of the file (testSystem.atp for example)
% codePath is the path to the ATPMAT toolbox. When left blank, the toolbox
%uses the current working directiry since th euser won't be able to call BatchProcessATP without changing the directory .
% FilePath is the path to the ATP file to be processed.
% OutputPath is the output directory of toolbox. This is where pl42mat
% saves all files
%fileDir directory of the file
%ATPEXEDir is the directory for ATP related executables.

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


%The following will set the path of the code and the output of ATPMAT
[Dir] = SetBatchDirectories(codePath, OutputPath, fileDir,fileName , ATPEXEDir);

%first Create a c opy of the file
copyfile(strcat(Dir.fileDir,'\',fileName),strcat(Dir.codePath,'\',fileName));

% The following lines will change the end time and the
% integration time step of the atp file.
filename=ChangeSimulationSettings(Scenarios, Dir, fileName );

%Now creating all ATP simulations
if strcmp('fault', Scenarios.eventCode)
    for num=1:Scenarios.numOfCases
        CreateFault(Scenarios,num, Dir, filename);
    end
    %now cleaning ATPEXEDir and codePath
    CleanCodeAndATPDir(Dir,filename );
    fprintf('\r\n ******All Operations Completed Successfully******\r\n');
elseif strcmp('light', Scenarios.eventCode)
    
else
    
end
