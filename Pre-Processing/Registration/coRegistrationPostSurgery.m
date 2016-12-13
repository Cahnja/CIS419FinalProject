clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Data/';
cd (path)
currentList = dir ('x*'); 
 
% for each subject
for subjNum = 1: 1 % length (currentList)
    iname = currentList (subjNum).name;
    cd (iname)
    runList = dir ('x*');
    % for each run pre vs. post
    
    runName1 = runList(1).name;
    runName2 = runList(2).name;
    
    % go into the post-scan directory
    cd (runName2)
    
    %flair
    flairList = dir ('xFLAIR*');
    flair = flairList(1);
    cd (flair)
    fileList = dir('.nii.gz*');
    fileNameFlair = fileList(1);
    cd ('..')
    
    %t1
    t1list = dir ('xT1_*');
    t1 = t1list(1);
    cd (t1)
    fileList = dir('.nii.gz*');
    fileNameT1 = fileList(1);
    cd ('..')
    
    %t1post
    t1postlist = dir ('xT1post*');
    t1post = t1postlist(1);
    cd (t1post)
    fileList = dir('.nii.gz*');
    fileNameT1post = fileList(1);
    cd ('..')
    
    %t2
    t2list = dir ('xT2_*');
    t2 = t2list(1);
    cd (t2)
    fileList = dir('.nii.gz*');
    fileNameT2 = fileList(1);
    cd ('..')
    
    
    cd (runName1)        
    % go through the scans
    for scanNum = 1: 4
        if scanNum == 1
            toggle = 'xFLAIR';
            toggler = flair;
            name = fileNameFlair;
        end
        if scanNum == 2
            toggle = 'xT1_';
            toggler = t1;
            name = fileNameT1;
        end
        if scanNum == 3
            toggle = 'xT1post';
            toggler = t1post;
            name = fileNameT1post;
        end
        if scanNum == 4
            toggle = 'xT2_';
            toggler = t2;
            name = fileNameT2;
        end
        runPath1 = strcat(path, iname, '/', runName1, '/');
        runPath2 = strcat(path, iname, '/', runName2, '/');

        inputfile = strcat(runPath2,'reg/', toggler,'/', name);
                
        outputfile = strcat(runPath,'reg_', runName2, '/', toggle,'/', name);
        
        matFile = strcat(runPath,'reg_', runName2, '/', toggle,'/', name);
            
        runner = ['/usr/local/fsl/bin/flirt -in ' inputfile ' -ref ' ref ' -out ' outputfile ' -omat ' matFile '.mat -bins 256 -cost mutualinfo -searchrx 0 0 -searchry 0 0 -searchrz 0 0 -dof 6  -interp trilinear'];
        disp(runner);
        unix(runner);
        disp ('This has ended')
    end
    cd ('..')
end


          
        