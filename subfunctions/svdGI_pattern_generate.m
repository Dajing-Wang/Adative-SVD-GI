function [pattern_svdGI,U,S,V] = svdGI_pattern_generate(patterns)
%singular value decomposition GI
% Authored by Dajing Wang in Aug/2022
[row, col, m] = size(patterns);
Fai=reshape(patterns, [row*col, m]).';
[U,S,V]=svd(Fai);
% if nargin==2
%     Fai_svd=V(:,1:TsvdGI_index)*inv(S(1:TsvdGI_index,1:TsvdGI_index))*U(:,1:TsvdGI_index).';
% end
if nargin==1
    S(S>0)=1;
    Fai_svd=U*S*V.';
end
pattern_svdGI=reshape(Fai_svd.', [row,col, m]);
end

