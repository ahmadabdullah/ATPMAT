function[]=SetFaultLocation(fid1,LineToStudy,faultBus,distance,WhichTerminal)%fid1,LineToStudy,distance, WhichTerminal)
%This is a helper function that sets the lengths of the two halfs of the
%line according to the user input for batch proceesing.

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


%Now adjusting the first half
whichCard='BRANCH';
[sendingNode, receivingNode]=strtok(LineToStudy,'-');
receivingNode=receivingNode(2:end);
if strcmp(WhichTerminal,sendingNode)
else
    temp=sendingNode;
    sendingNode=receivingNode;
    receivingNode=temp;
end

sendingEnd=strcat('M',sendingNode,'A');
receivingEnd=strcat('M',receivingNode,'A');

%Now find line length
rowNumber=getRowNumber(sendingEnd,faultBus,whichCard,fid1);
fseek(fid1,0,-1);

for i=1:rowNumber
    line=fgetl(fid1);
end
originalLlineLength=line(3+7*6:3+7*6+6-1);
originalLlineLength=str2num(originalLlineLength);
fseek(fid1,0,-1);
d=originalLlineLength;

%Now making chages to ATP file
f_location=distance/100;

rowNumber=getRowNumber(sendingEnd,faultBus,whichCard,fid1);
fseek(fid1,0,-1);

for i=1:rowNumber-1
    fgetl(fid1); 
end

firstHalfLineLength=d*f_location;
setLength(fid1,firstHalfLineLength);
fseek(fid1,0,-1);


% Adjusting the other half
whichCard='BRANCH';
rowNumber=getRowNumber(receivingEnd,faultBus,whichCard,fid1);
fseek(fid1,0,-1);
for i=1:rowNumber-1
    fgetl(fid1); 
end
secondHalfLineLength=d*(1-f_location);
setLength(fid1,secondHalfLineLength);
fseek(fid1,0,-1);
