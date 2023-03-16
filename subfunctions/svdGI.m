function [img_r_svd_GI, pattern_svd_GI, t_svd] = svdGI(random_pattern,im,noise_level)
%svd GI
[pattern_svd_GI,~] = svdGI_pattern_generate(random_pattern);
tic
measurements_svdGI = sum(sum(repmat(im,[1,1,size(pattern_svd_GI,3)]) .* pattern_svd_GI))+ noise_level.*rand(1,1,size(pattern_svd_GI,3));
measurements_svdGI = measurements_svdGI(:);
img_r_svd_GI = GI(pattern_svd_GI, measurements_svdGI);

t_svd=toc;
end