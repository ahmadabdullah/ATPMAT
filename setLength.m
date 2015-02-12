function setLength(fid1,linelength)
% helper function to write line lengths for  symmetrical clarke line in the ATP file

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
s2=44; % shifting 1
s3=126; % shifting 2
fseek(fid1,s1+s2,-1);
fprintf(fid1,'       '); %clearing the field
fseek(fid1,s1+s3,-1);
fprintf(fid1,'       ');
flag=floor(log10(linelength));
switch flag
    case {4,5}
        s4=45; s5=127;
        fseek(fid1,s1+s4,-1);
        z1=sprintf('%2.1E',linelength);
        z2=[z1(1:4) z1(7)];
        fprintf(fid1,z2);
        fseek(fid1,s1+s5,-1);
        fprintf(fid1,z2);
    case 3
        fseek(fid1,s1+s2+1,-1);
        z1=sprintf('%5.1f',linelength);
        z2=z1(1:5);
        fprintf(fid1,z2);
        fseek(fid1,s1+s3+1,-1);
        fprintf(fid1,z2);
    case 2
        fseek(fid1,s1+s2,-1);
        fprintf(fid1,'%5.2f',linelength);
        fseek(fid1,s1+s3,-1);
        fprintf(fid1,'%5.2f',linelength);
    case 1
        fseek(fid1,s1+s2,-1);
        fprintf(fid1,'%5.3f',linelength);
        fseek(fid1,s1+s3,-1);
        fprintf(fid1,'%5.3f',linelength);
    case 0
        fseek(fid1,s1+s2,-1);
        fprintf(fid1,'%5.4f',linelength);
        fseek(fid1,s1+s3,-1);
        fprintf(fid1,'%5.4f',linelength);
    case {-1,-2,-3,-4,-5}
        z1=sprintf('%5.5f',linelength);
        z2=z1(2:7);
        fseek(fid1,s1+s2,-1);
        fprintf(fid1,'%6s',z2);
        fseek(fid1,s1+s3,-1);
        fprintf(fid1,'%6s',z2);
    otherwise
        error('length is not in allowed bounds')
end
