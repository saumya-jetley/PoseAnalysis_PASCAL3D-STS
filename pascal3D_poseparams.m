% Version 1.000
% Code written by Saumya Jetley
% This code reads the .mat files for all the images in val and train set folders
% Writes the pose annotations to pose.mat and image names to list.txt files

clear;
mainpath = '/media/sjvision/DATASETDISK/ShapeDatasets_SyntheticSized/PASCAL3D+_release1.1/smgoutput/val_set';
savepath = '/media/sjvision/DATASETDISK/ShapeDatasets_SyntheticSized/PASCAL3D+_release1.1/smgoutput/pose_mat_allfiles/';
folders = dir(mainpath);

imreadlist = fopen(strcat(savepath, 'val_list.txt'),'w');

data = [];
name={};

counter=1;
for i = 1:size(folders,1)
    disp(i);
    files = dir(strcat(mainpath,'/',folders(i).name, '/*.mat'));
    for j=1:size(files,1)
            
        imname = files(j).name;
        fprintf(imreadlist,'%s_%s\n',folders(i).name,imname(1:end-4));
        impath = strcat(mainpath,'/',folders(i).name, '/', imname);
        imdata = load(impath);
        
        imdata = imdata.data(1:3);
        imdata(4)=(i-2);
        
        data = [data; imdata'];
        name{counter} = (folders(i).name);
        counter=counter+1;
    end
end
all_file_data.data = data;
all_file_data.name = name;

save(strcat(savepath,'train_pose_mat.mat'),'all_file_data');
