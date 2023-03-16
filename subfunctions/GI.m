function [img_r_GI] = GI(patterns, measurements)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%ghost imaging%%%%%%%%%%
B_aver  = mean(measurements);
[row, col, m] = size(patterns);
img_r = zeros(row, col);
%% DGI reconstruction
for n = 1:m
    
    pattern_n = patterns(:,:,n);

    B_n = measurements(n);

    % ghost imaging (GI)
    img_r = (B_n - B_aver) .* pattern_n + img_r;
       
end
img_r_GI = img_r ./ m;