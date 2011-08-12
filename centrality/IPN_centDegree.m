function   dc = IPN_centDegree(CIJ)
% INPUTS
%   CIJ - connection/adjacent matrix
%
% OUTPUTS
%   dc - degree (i.e., num of edges linking to a node)
% AUTHOR:
%   Xi-Nian Zuo, Ph.D. of Applied Mathematics
%   Institute of Psychology, Chinese Academy of Sciences.
%   Email: ZuoXN@psych.ac.cn
%   Website: lfcd.psych.ac.cn

dc = sum(CIJ);
dc = reshape(dc, length(dc), 1);