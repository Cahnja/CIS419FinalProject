clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Gold_Standard_data/';
cd (path)
currentList = dir ('x*'); 

%instantiate t1 variables
t1_acc_n = 0;
t1_acc_d = 0;
t1_prec_n = 0;
t1_prec_d = 0;
t1_rec_n = 0;
t1_rec_d = 0;

%instantiate t1 variables
c_acc_n = 0;
c_acc_d = 0;
c_prec_n = 0;
c_prec_d = 0;
c_rec_n = 0;
c_rec_d = 0;

%instantiate t1 variables
flair_acc_n = 0;
flair_acc_d = 0;
flair_prec_n = 0;
flair_prec_d = 0;
flair_rec_n = 0;
flair_rec_d = 0;

for subjNum = 1: 1 %length (currentList)
    cd(path)
    tic
    iname = currentList (subjNum).name;
    disp(iname);
    cd (iname)
    
    %get mask
    fileList = dir ('*2*');
    
    
    mask = fileList(1).name;
    mask_path = [path iname '/' mask];
    [label_mask, dims2,scales2,bpp2,endian2] = read_avw(mask_path);
    
    %get classifer outputs
    fileList = dir ('*_silver_cv10.nii.gz*');
    t1 = fileList(3).name;
    disp(t1);
    combined = fileList(1).name;
    flair = fileList(2).name;
    
    [t1_mask, dims2,scales2,bpp2,endian2] = read_avw(t1);
    [c_mask, dims2,scales2,bpp2,endian2] = read_avw(combined);
    [flair_mask, dims2,scales2,bpp2,endian2] = read_avw(flair);
    
    % T1 --- compute accuracy scores for t1
    t1_corr = sum(t1_mask(:) == label_mask(:));
    total_voxels = size(t1_mask(:));
    total_voxels_size = total_voxels(1);
    t1_acc_n = t1_acc_n + t1_corr;
    t1_acc_d = t1_acc_d + total_voxels_size;
    
   % T1 --- compute precision scores for t1 (selected positives / selected)
    t1_selected = sum(t1_mask(:) > 0); %selected positive
    t1_true_selected = sum(label_mask(:) >= 1 & t1_mask(:) > 0); % selected and positive
    t1_prec_n = t1_prec_n + t1_true_selected;
    t1_prec_d = t1_prec_d + t1_selected;
    
    % T1 --- compute recall scores for t1 (true positives / positives)
    true_positives = sum(label_mask(:) >= 1);
    t1_rec_n = t1_rec_n + t1_true_selected;
    t1_rec_d = t1_rec_d + true_positives;
    
     % Combined --- compute accuracy scores for t1
    c_corr = sum(c_mask(:) == label_mask(:));
    total_voxels = size(c_mask(:));
    total_voxels_size = total_voxels(1);
    c_acc_n = c_acc_n + c_corr;
    c_acc_d = c_acc_d + total_voxels_size;
    
     % Combined --- compute precision scores for t1 (true positives / positives)
    c_selected = sum(c_mask(:) >= 1); %selected positive
    c_true_selected = sum(label_mask(:) >= 1 & c_mask(:) >= 1); % selected and positive
    c_prec_n = c_prec_n + c_true_selected;
    c_prec_d = c_prec_d + c_selected;

    % Combined --- compute recall scores for t1 (true positives / positives)
    true_positives = sum(label_mask(:) >= 1);
    c_rec_n = c_rec_n + c_true_selected;
    c_rec_d = c_rec_d + true_positives;
    
     % Flair --- compute accuracy scores for t1
    flair_corr = sum(flair_mask(:) == label_mask(:));
    total_voxels = size(flair_mask(:));
    total_voxels_size = total_voxels(1);
    flair_acc_n = flair_acc_n + flair_corr;
    flair_acc_d = flair_acc_d + total_voxels_size;
    
    % Flair --- compute precision scores for t1 (true positives / positives)
    flair_selected = sum(flair_mask(:) >= 1); %selected positive
    flair_true_selected = sum(label_mask(:) >= 1 & flair_mask(:) >= 1); % selected and positive
    flair_prec_n = flair_prec_n + flair_true_selected;
    flair_prec_d = flair_prec_d + flair_selected;
    
    % Flair --- compute recall scores for t1 (true positives / positives)
    true_positives = sum(label_mask(:) >= 1);
    flair_rec_n = flair_rec_n + flair_true_selected;
    flair_rec_d = flair_rec_d + true_positives;

end

% T1 --- compute results
t1_acc = t1_acc_n / t1_acc_d;
t1_prec = t1_prec_n / t1_prec_d;
t1_rec = t1_rec_n / t1_rec_d;

% T1 --- display results
disp(t1_acc);
disp(t1_prec);
disp(t1_rec);

% Combined --- compute results
c_acc = c_acc_n / c_acc_d;
c_prec = c_prec_n / c_prec_d;
c_rec = c_rec_n / c_rec_d;

% Combined --- display results
disp(c_acc);
disp(c_prec);
disp(c_rec);

% Flair --- compute results
flair_acc = flair_acc_n / flair_acc_d;
flair_prec = flair_prec_n / flair_prec_d;
flair_rec = flair_rec_n / flair_rec_d;

% Flair --- display results
disp(flair_acc);
disp(flair_prec);
disp(flair_rec);






