%   Originally written by sabrahashembeygi (sabrahashemi@gmail.com)
% A substantial effort was put into this code. If you use it for a
% publication or otherwise, please include an acknowledgement or at least
% notify me by email.

function [ac] = printResult(X, label, K, kmeansFlag)

if kmeansFlag == 1
    indic = litekmeans(X, K, 'Replicates',20);
else
    [~, indic] = max(X, [] ,2);
end
result = bestMap(label, indic);
[ac, nmi_value, cnt] = CalcMetrics(label, indic);
disp(sprintf('ac: %0.4f\t%d/%d\tnmi:%0.4f\t', ac, cnt, length(label), nmi_value));