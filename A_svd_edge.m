close all
clear;
addpath('.\subfunctions\');
%% intialization
% This is demo of edge detection of paper entitled "Dual-mode adaptive-SVD ghost imaging"
% Coded by Dajing Wang in 2023
% https://doi.org/10.48550/arXiv.2302.07269

superpixel_size=2;      % size of superpixel
num_pixel = 128;        % num of pixel
noise_level = 0;        % set noise level of measurements, Note the signal is 0.4 around.
K_2 = 0.95;

num_superpixel=ceil(num_pixel/superpixel_size);

file_name = 'test_edge.png';
%% Generat object
im =  im2double((imread(file_name))); 
if (ndims(im)==3)
    im=rgb2gray(im);
end
interp_method="bilinear";
im = imresize(im,[num_pixel,num_pixel],interp_method);

fprintf('image loaded\n' );
total_pixel_num = num_pixel*num_pixel;
im_pre = imresize(im,[num_superpixel,num_superpixel],interp_method);
O_pre = reshape(im_pre,[num_superpixel*num_superpixel,1,]);
O_real = reshape(im,[num_pixel*num_pixel,1]);

%% A-SVD process

tic;    % Timing begins
num_pattern_pre = ceil(num_superpixel * num_superpixel); % number of illumination patterns
patterns =  rand(num_superpixel,num_superpixel,num_pattern_pre);

[result_pre, patterns_pre, ~] = svdGI(patterns,im_pre,noise_level);
fprintf('pre detection done\n' );
result_pre = normalize(result_pre);

[K_1] = 0.3*graythresh(result_pre); % Otsu method embedded in MatlabR2006a or later version

index_notready = [];
[index_notready(:,1),index_notready(:,2)] = find((result_pre>=K_1)&(result_pre<=K_2));

num_patern_further = ceil(size(index_notready,1)*superpixel_size*superpixel_size);
num_total = num_pattern_pre+num_patern_further;

pixel_num_further=size(index_notready,1)*superpixel_size*superpixel_size;
r=(rand(pixel_num_further,1,num_patern_further));
x=svdGI_pattern_generate(r);
fprintf('patterns done\n' );
sampling_ratio=num_total/total_pixel_num;
pattern_further=zeros(num_pixel,num_pixel,size(index_notready,1)*superpixel_size*superpixel_size);

for j=1:num_patern_further
    for i=1:size(index_notready,1)
        pattern_further(superpixel_size*index_notready(i,1)-superpixel_size+1:superpixel_size*index_notready(i,1),...
            superpixel_size*index_notready(i,2)-superpixel_size+1:superpixel_size*index_notready(i,2),j)...
            = reshape(x((superpixel_size*superpixel_size*i-superpixel_size*superpixel_size+1):superpixel_size*superpixel_size*i,1,j),...
            superpixel_size,superpixel_size);    
    end
end

measurements = sum(sum(repmat(im,[1,1,pixel_num_further]) .* pattern_further));
measurements = reshape(measurements,[],1);
[row, col, m] = size(pattern_further);
Fai=reshape(pattern_further, [row*col, m]).';
result_further=normalize(reshape(Fai.'*measurements,row, col));

t_Asvd = toc;   % Timing ends
fprintf(['final image done, time consumption is ',num2str(t_Asvd),'[s]\n']);
%% plot example of patterns
figure;subplot(1,2,1);imagesc((patterns_pre(:,:,i)));
set(gca,'FontName','Arial','FontSize',28);
axis image
title('Low resolution pattern')
% colormap viridis
xticks(0:num_pixel/2/superpixel_size:num_pixel/superpixel_size);yticks(0:num_pixel/2/superpixel_size:num_pixel/superpixel_size);

subplot(1,2,2);imagesc(abs(pattern_further(:,:,i)));
set(gca,'FontName','Arial','FontSize',28);
axis image
title('High resolution pattern')
% colormap viridis
xticks(0:num_pixel/2:num_pixel);yticks(0:num_pixel/2:num_pixel);
%% plot of results
figure;subplot(1,3,1);imagesc(im);axis image
set(gca,'FontName','Arial','FontSize',28);
xticks(0:num_pixel/2:num_pixel);yticks(0:num_pixel/2:num_pixel);
title('Original object')
% colormap viridis

subplot(1,3,2);imagesc(result_pre);axis image
xticks(0:num_pixel/2/superpixel_size:num_pixel/superpixel_size);yticks(0:num_pixel/2/superpixel_size:num_pixel/superpixel_size);
set(gca,'FontName','Arial','FontSize',28);
title('Result-pre')
% colormap viridis

subplot(1,3,3);imagesc(result_further);
axis image
xticks(0:num_pixel/2:num_pixel);yticks(0:num_pixel/2:num_pixel);
set(gca,'FontName','Arial','FontSize',28);
title('Result-final')
% colormap viridis
