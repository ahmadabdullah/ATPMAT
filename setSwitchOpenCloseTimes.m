function setSwitchOpenCloseTimes(fid1,ct,ot)
% This is a helper function that write data in a specific format for switches in the ATP file

s1=ftell(fid1); % current position
s2=14; % shifting 1
s3=10; % shifting 2
fseek(fid1,s1+s2,-1);fprintf(fid1,'                     ');
% ct
if ct<0
   flag=floor(log10(-ct));
   switch flag
   case 0
      fseek(fid1,s1+s2,-1);fprintf(fid1,'%8.7f',ct);
   case {-1,-2,-3,-4,-5}
      z1=sprintf('%9.8f',ct);z2=[z1(1) z1(3:11)];
      fseek(fid1,s1+s2,-1);fprintf(fid1,'%10s',z2);
   otherwise
      error('ct is not in required bounds')
   end
elseif ct>0
   flag=floor(log10(ct));
   switch flag
   case 0
      fseek(fid1,s1+s2,-1);fprintf(fid1,'%9.8f',ct);
   case {-1,-2,-3,-4,-5}
      z1=sprintf('%10.9f',ct);z2=z1(2:11);
      fseek(fid1,s1+s2,-1);fprintf(fid1,'%10s',z2);
   otherwise
      error('ct is not in required bounds')
   end
else % ct==0
   fseek(fid1,s1+s2,-1);fprintf(fid1,'%9.8f',ct);
end
% ot
if ot<0
   error('ct is not in required bounds')
end
flag=floor(log10(ot));
switch flag
case 0
   fseek(fid1,s1+s2+s3,-1);fprintf(fid1,'%9.8f',ot);
case {-1,-2,-3,-4,-5}
   z1=sprintf('%10.9f',ot);z2=z1(2:11);
   fseek(fid1,s1+s2+s3,-1);fprintf(fid1,'%10s',z2);
otherwise
   error('ot is not in required bounds')
end
