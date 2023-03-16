function [B] = normalize(A)
%2D normalization to [0 1]
B=(A-min(min(min(A))))./(max(max(max(A)))-min(min(min(A))));
end
