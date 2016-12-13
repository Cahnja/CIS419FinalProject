clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Data/';
cd (path)
currentList = dir ('x*'); 
 
% for each subject
for subjNum = 1: length (currentList)
    if subjNum ~= 2
        iname = currentList (subjNum).name;
        cd (iname)
        runList = dir ('x*');
        % for each run pre vs. post
        for runNum = 1: 1 %length (runList)
            runName = runList(runNum).name;
            runNameOther = runList(2).name;
            cd (runName)
            cd ('reg');
            %get the input image
            t1_scan = dir ('xT1_*');
            cd (t1_scan(1).name);
            fileList = dir ('*_brain_mni.mat*');
            fileName = fileList(1).name;
            fileName2 = strtok(fileName,{'.'});
            input_file = strcat(t1_scan(1).name, '/', fileName);
            cd ('..')
            runPath = strcat(path, iname, '/', runName, '/');
            matFile = [runPath 'reg/' t1_scan(1).name '/' fileName];
            
            cd ('..')
            otherDay = ['reg_' runNameOther];
            cd (otherDay);
            t1_scan = dir ('xT1_*');
            cd (t1_scan(1).name);
            fileList = dir ('*1001.nii.gz*');
            fileName = fileList(1).name;
            fileName2 = strtok(fileName,{'.'});
            inputfile = [path, iname, '/diff_image_mask.nii.gz'];
            outputfile = [path, iname, '/diff_image_mask_mni.nii.gz'];
            
            runner = ['/usr/local/fsl/bin/flirt -in ' inputfile ' -applyxfm -init ' matFile ' -out ' outputfile ' -paddingsize 0.0 -interp trilinear -ref /usr/local/fsl/data/standard/MNI152_T1_2mm.nii.gz'];               
         
            disp(runner);
            unix(runner);
               
            cd ('..');
            cd ('..')
            disp ('This has ended')
            cd ('..');
            
        end
        cd ('..')
    end
end


          
        