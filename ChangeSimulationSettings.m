function [filename]=ChangeSimulationSettings(P, Dir, filename)
%This is a helper function used by BatchProcessATP to change the
% simulation settings of the ATP file. This function adjust both the
% intergration time step and the total simulation duration. Intergration
% time step has to be from [1e-9 to 1e-4]. The time step has to be in the
% form x.xE-xx. The mantissa part can't be more than 3 characters long. The
% max time can't exceed 10 seconds and the fractional part can't exceed 6
% characters long.

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

system(horzcat('rename ',filename,' ' ,filename(1:length(filename)-4)));
filename=filename(1:length(filename)-4);
FilePath=strcat(Dir.codePath,'\',filename);
fid=fopen(FilePath, 'r+' );
% Jump to 7th Line
for i=1:7
    fgets(fid);
end
s1=ftell(fid);
line=fgets(fid);
SamplingTimeStr=num2str(P.SamplingTime);
[mantissa, expPart]=strtok(SamplingTimeStr,'e');
line(8)=expPart(end);
if length(mantissa)>1
    line(3:5)='   '; %deleting 3 characters
    line(3:5)=mantissa; %replacing with user supplied values
else
    line(3:5)='   ';
    line(5)=mantissa;
end
line(9:16)='        ';% 8 characters to delete in Tmax field
endTimeStr=num2str(P.endTime);
[b4Decimal,afterDecimal]=strtok(endTimeStr,'.');
b4Decimal=b4Decimal(end);
 afterDecimal=afterDecimal(2:end);
if length(afterDecimal)>7
    line(9)=b4Decimal;
    line(10)='.';
    line(11:16)=afterDecimal;
else
    line(15-length(afterDecimal))=b4Decimal;
    line(16-length(afterDecimal))='.';
    line(17-length(afterDecimal):16)=afterDecimal;
end
fseek(fid,s1,-1);
fprintf(fid,line);
fclose(fid);
