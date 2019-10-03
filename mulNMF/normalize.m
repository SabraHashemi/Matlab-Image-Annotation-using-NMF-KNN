function [ mat ] = normalize( mat )
%normalize Matrix value Between 0 and 1
%   Originally written by sabrahashembeygi (sabrahashemi@gmail.com)
% A substantial effort was put into this code. If you use it for a
% publication or otherwise, please include an acknowledgement or at least
% notify me by email.

    mat = double(mat);

    minval = min(min(mat));
    maxval = max(max(mat));
    
    if(minval == maxval)
        mat = zeros(size(mat));
        return;
    end

    mat = (mat - minval)/(maxval - minval);

end

