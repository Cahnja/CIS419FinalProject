clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Data/';
cd (path)
currentList = dir ('x*'); 
 
% for each subject
for subjNum = 2: 2 %length (currentList)
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
    pre_image_path = [path iname '/' runName '/reg/' t1_scan(1).name '/' normalized];
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
    
    disp (pre_image_path);
    disp (post_image_path);
    disp ('This has ended')
    
    

    cd ('..'); % exit T1 scan
    cd ('..'); % exit reg
    cd ('..'); % exit run
    
    runner = ['fslmaths ' pre_image_path ' -sub ' post_image_path ' diff_image.nii.gz']
    disp(runner);
    out=unix(runner); 
    cd ('..'); % exit subject
end


          
        