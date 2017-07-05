% read in the mat-files 
dirname = '/media/sjvision/DATASETDISK/ShapeDatasets_SyntheticSized/PASCAL3D+_release1.1/Images';
folders = dir(strcat(dirname,'/*_pascal'));
im_names = {};
for i = 1:size(folders,1)
    files = dir(strcat(dirname,'/', folders(i).name,'/*.jpg'));
    for j = 1:size(files,1)
        im_names{i,j} = files(j).name;
    end
end

dirname_mat = '/media/sjvision/DATASETDISK/ShapeDatasets_SyntheticSized/PASCAL3D+_release1.1/smgoutput';
mat_names = dir(strcat(dirname_mat,'/*.mat'));
for i = 1:size(mat_names,1)
    mat = mat_names(i).name(1:end-6);
    bin_present = strcmp(strcat(mat,'.jpg'), im_names);
    row_index = rem(find(bin_present),12);
end 