minind_an=[];
stats_mat=[];
stats_mat_classes=[];
% Specify the tsne compressed train and val files
mainpath = '/media/sjvision/DATASETDISK/ShapeDatasets_SyntheticSized/PASCAL3D+_release1.1/smgoutput/';

% Get the points for finding the nearest neighbours
% val_data = load(strcat(mainpath,'learned_encodings/','50enc_val.txt'));
val_data = load(strcat(mainpath,'radial_encodings/','rd50_val.txt'));
% val_data = val_data.mappedX;
% train_data = load(strcat(mainpath,'learned_encodings/','50enc_train.txt'));
train_data = load(strcat(mainpath,'radial_encodings/','rd50_train.txt'));
% train_data = train_data.mappedX;

load('../data_out/colors.mat');

% Get the pose params (files in the same sequence)
val_params = load(strcat(mainpath,'pose_mat_allfiles/','val_pose_mat.mat'));
val_pose = val_params.all_file_data.data;
val_pose(:,1) = val_pose(:,1)-pi;
val_name = val_params.all_file_data.name;

train_params = load(strcat(mainpath,'pose_mat_allfiles/','train_pose_mat.mat'));
train_pose = train_params.all_file_data.data;
train_pose(:,1) = train_pose(:,1)-pi;
train_name = train_params.all_file_data.name;

% 10 nearest neighbours
dist_mat = pdist2(val_data,train_data);
dist_mat(dist_mat==0) = Inf;
% Loop overand find minimum value index
neighbours = 50;
for i = 1:neighbours
    [minval, minind] = min(dist_mat,[],2);
    minind_an = [minind_an minind];
    for j=1:size(minind,1)
        dist_mat(j,minind(j))=Inf;
    end
end

% stats over the nns for each image in val
for i=1:size(val_data,1)
    % get the pose info for the min-index
    azi_var = sqrt(sum((abs(val_pose(i,1))-abs(train_pose(minind_an(i,:),1))).^2)/neighbours);
    ele_var = sqrt(sum((val_pose(i,2) - train_pose(minind_an(i,:),2)).^2)/neighbours);
    dis_var = sqrt(sum((val_pose(i,3)-train_pose(minind_an(i,:),3)).^2)/neighbours);
    
    match_cat = mode(train_pose(minind_an(i,:),4)); % which category it matches most with
    match_prop = sum(train_pose(minind_an(i,:),4)==match_cat)/neighbours; % proportion of match
    stats_mat = [stats_mat; [azi_var ele_var dis_var match_cat match_prop]];
end

for i=1:12
    l = i*10;
    f = l-9;
    stats_mat_sub = stats_mat(f:l,:);
    mean_azi_var = mean(stats_mat_sub(:,1));
    mean_ele_var = mean(stats_mat_sub(:,2));
    mean_dis_var = mean(stats_mat_sub(:,3));
    
    mode_cat = mode(stats_mat_sub(:,4));
    mode_count = sum(stats_mat_sub(:,4)==mode_cat);
    correct = mode_cat==i;
    
    
    majority_mode = sum(stats_mat_sub(stats_mat_sub(:,4)==mode_cat,5))/mode_count;
    majority_nonmode = sum(stats_mat_sub(stats_mat_sub(:,4)~=mode_cat,5))/(10-mode_count);
    stats_mat_classes = [stats_mat_classes; [mean_azi_var mean_ele_var mean_dis_var mode_cat mode_count correct majority_mode majority_nonmode]];
end
