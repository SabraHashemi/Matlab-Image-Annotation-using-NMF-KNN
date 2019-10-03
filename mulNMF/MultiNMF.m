function [U, V, centroidV, log, ac] = MultiNMF(X, K, label, options)
% This is a module of Multi-View Non-negative Matrix Factorization(MultiNMF)
%
% Notation:
% X ... a cell containing all views for the data
% K ... number of hidden factors
% label ... ground truth labels
% Written by Jialu Liu (jliu64@illinois.edu)
% modified by sabrahashembeygi (sabrahashemi@gmail.com)
% A substantial effort was put into this code. If you use it for a
% publication or otherwise, please include an acknowledgement or at least
% notify me by email.

viewNum = length(X);
Rounds = options.rounds;

U_ = [];
V_ = [];

U = cell(1, viewNum);
V = cell(1, viewNum);

j = 0;
log = 0;
ac = 0;

% initialize basis and coefficient matrices
while j < 3
    j = j + 1;
    if j == 1
        [U{1}, V{1}] = NMF(X{1}, K, options, U_, V_);
        %printResult(V{1}, label, K, options.kmeans);
    else
        [U{1}, V{1}] = NMF(X{1}, K, options, U_, V{viewNum});
        %printResult(V{1}, label, K, options.kmeans);        
    end
    for i = 2:viewNum
        [U{i}, V{i}] = NMF(X{i}, K, options, U_, V{i-1});
        %printResult(V{i}, label, K, options.kmeans);
    end
end

optionsForPerViewNMF = options;
oldU = U;
oldV = V;
oldL = 0;
firstRun = 1;

restart = 0;

tic
j = 0;
while j < Rounds
    
     fprintf('Round #%d',j);
    
    j = j + 1;
    if j==1
        centroidV = V{1};
    else
        centroidV = options.alpha(1) * V{1};
        for i = 2:viewNum
            centroidV = centroidV + options.alpha(i) * V{i};
        end
        centroidV = centroidV / sum(options.alpha);
    end
    logL = 0;
    for i = 1:viewNum
        tmp1 = X{i} - U{i}*V{i}';
        tmp2 = V{i} - centroidV;
        logL = logL + sum(sum(tmp1.^2)) + options.alpha(i) * sum(sum(tmp2.^2));
    end
    
    if (firstRun == 1)
        oldL = logL;
        firstRun = 0;
    end
 
    if(oldL < logL || isnan(logL))
        U = oldU;
        V = oldV;
        logL = oldL;
        j = j - 1;
        restart = restart+1;
        fprintf(' => restrart this iteration');
    else
        ac(end+1) = j; %printResult(centroidV, label, K, options.kmeans);
        log(end+1) = logL;
        restart = 0;
    end
    
    if(restart > 5)
        break;
    end
    
    oldU = U;
    oldV = V;
    oldL = logL;
    
    for i = 1:viewNum
        optionsForPerViewNMF.alpha = options.alpha(i);
        [U{i}, V{i}] = PerViewNMF(X{i}, K, centroidV, optionsForPerViewNMF, U{i}, V{i});
    end
    
    fprintf(' :Done\n');
end
toc
end