clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Data/';
cd (path)
currentList = dir ('x*'); 
 
% for each subject
for subjNum = 2: length (currentList)
    iname = currentList (subjNum).name;
    disp(iname);
    cd (iname)
    runList = dir ('x*');
    
    %get pre-run image
    runName = runList(1).name;
    cd (runName);
    cd ('reg');
    t1_scan = dir ('xT1_*');
    cd (t1_scan(1).name);
    file_list = dir('*_normalized*');
    normalized = file_list(1).name;
    file_list2 = dir('*_brain_mask*');
    brainmask = file_list2(1).name;

    pre_image_path = [path iname '/' runName '/reg/' t1_scan(1).name '/' normalized];
    brain_mask_path = [path iname '/' runName '/reg/' t1_scan(1).name '/' brainmask];
    [brainmask, dims1,scales1,bpp1,endian1] = read_avw(brain_mask_path);


    cd ('..')
    cd ('..')
    
    %get pre-run image
    runName2 = runList(2).name;
    otherDay = ['reg_' runName2];
    cd (otherDay);
    t1_scan = dir ('xT1_*');
    cd (t1_scan(1).name);
    file_list = dir('*_normalized*');
    normalized = file_list(1).name;
    post_image_path = [path iname '/' runName '/' otherDay '/' t1_scan(1).name '/' normalized];
    
    %load post image and get lower quantile
    [postImage, dims1,scales1,bpp1,endian1] = read_avw(post_image_path);
    z1 = zeros(size(postImage));
    %disp(postImage);
    
    inds=find(brainmask>0);
    q1 = quantile(postImage(inds), 0.7);
    disp(q1);
    inds1 = find(postImage <= q1 & brainmask>0);
    z1(inds1) = 1;
    
    disp (pre_image_path);
    disp (post_image_path);
    
    

    cd ('..'); % exit T1 scan
    cd ('..'); % exit reg
    cd ('..'); % exit run
    
    runner1 = ['fslmaths ' pre_image_path ' -sub ' post_image_path ' diff_image.nii.gz'];
    disp(runner1);
    out=unix(runner1); 
    
    [diffImage, dims1,scales1,bpp1,endian1] = read_avw('diff_image.nii.gz');
    z2 = zeros(size(diffImage));
    q2 = quantile(diffImage(inds), 0.7);
    disp(q2);
    inds2 = find(postImage <= q2 & brainmask>0);
    z2(inds2) = 1;
    
    save_avw(z1, 'post_image_mask.nii.gz','b', scales1);
    save_avw(z2, 'diff_image_mask.nii.gz','b', scales1);
    
    runner2 = 'fslmaths post_image_mask.nii.gz -mul diff_image_mask.nii.gz update_diff_image_mask.nii.gz';
    disp(runner2);
    out=unix(runner2); 
    
    runner3 = 'fslmaths update_diff_image_mask.nii.gz -mul diff_image.nii.gz new_diff_image1.nii.gz';
    disp(runner3);
    out=unix(runner3); 
    
    cd ('..'); % exit subject
end


          
        