% Version 1.000
% Code written by Saumya Jetley
% This code reads the pascal3d silhouette val/test images and saves the images into a bin file
% sj1 - no rescaling for the test data

clear;
imsavepath = '/media/sjvision/DATASETDISK/ShapeDatasets_SyntheticSized/PASCAL3D+_release1.1/smgoutput/val_set_immasks_64';
mainpath = '/media/sjvision/DATASETDISK/ShapeDatasets_SyntheticSized/PASCAL3D+_release1.1/smgoutput/val_set';
folders = dir(mainpath);
sil = [];

for i = 1:size(folders,1)
    files = dir(strcat(mainpath,'/',folders(i).name, '/*.mat'));    

    for j=1:size(files,1)
        imname = files(j).name;
        impath = strcat(mainpath,'/',folders(i).name, '/', imname);
        imdata = load(impath);
        imdata = imdata.data(4:end); 
        
        [h,w] = size(imdata);
        imdata_res = reshape(imdata,[256,256]); 
        imdata_res = imresize(imdata_res,[64,64],'nearest'); 
        
%         save the images in similar folder structure
        mkdir(strcat(imsavepath,'/',folders(i).name));
        imwrite(imdata_res,strcat(imsavepath,'/',folders(i).name, '/', imname(1:end-4),'.png'));

        imdata_res = im2bw(imdata_res, 0.5)*255;
        if max(max(imdata_res)) ~= 255
            imdata_res = (imdata_res/max(max(imdata_res)))*255;
        end   
        
        imdata_res = imdata_res';
        sil = [sil reshape(imdata_res, [4096 1])];
        %sil = [sil reshape(imdata_res, [65536 1])]; 

        a = unique(sil)
        if size(a,1)~=2
            break;
        end
    end
end
fid = fopen('pascal3d_val_64.bin','w');
fwrite(fid, sil);
