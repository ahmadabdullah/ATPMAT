function setFaultResistance(fid1,faultResistance)
% This is a helper function that writes fault resistance between phases in the ATP file

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
s1=ftell(fid1); % current position
s2=26; % shifting with respect to the begining of the line
fseek(fid1,s1+s2,-1);
fprintf(fid1,'       ');%Clearing the field
% rf
flag=floor(log10(faultResistance)); % format of faultResistance depends on the value supplied
switch flag
case 4
   fseek(fid1,s1+s2-1,-1);
   fprintf(fid1,'%6.0f.',faultResistance);
case 3
   fseek(fid1,s1+s2,-1);
   fprintf(fid1,'%5.1f',faultResistance);
case 2
   fseek(fid1,s1+s2,-1);
   fprintf(fid1,'%5.2f',faultResistance);
case 1
   fseek(fid1,s1+s2,-1);
   fprintf(fid1,'%5.3f',faultResistance);
case 0
   fseek(fid1,s1+s2,-1);
   fprintf(fid1,'%5.4f',faultResistance);
case {-1,-2,-3,-4,-5}
   z1=sprintf('%5.5f',faultResistance);
   z2=z1(2:7);
   fseek(fid1,s1+s2,-1);
   fprintf(fid1,'%6s',z2);
case {-6,-7,-8,-9}
   z1=sprintf('%2.1E',faultResistance);
   z2=[z1(1:5) z1(7)];
   fseek(fid1,s1+s2,-1);
   fprintf(fid1,'%6s',z2);
otherwise
   error('Fault Resistance is not in the allowed bounds')
end
