
clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Data/';
cd (path)
currentList = dir ('x*'); 
 
% for each subject
for subjNum = 4: length (currentList)
    if subjNum ~= 2
        iname = currentList (subjNum).name;
        cd (iname)
        runList = dir ('x*');
        % for each run pre vs. post
        for runNum = 1: 1 %length (runList)
            runName = runList(runNum).name;
            cd (runName)
            cd ('reg');
            %get the input image
            t1_scan = dir ('xT1_*');
            cd (t1_scan(1).name);
            fileList = dir ('*_brain.nii*');
            fileName = fileList(1).name;
            fileName2 = strtok(fileName,{'.'});
            input_file = strcat(t1_scan(1).name, '/', fileName);
            cd ('..')

            runPath = strcat(path, iname, '/', runName, '/');
            inputfile = [runPath 'reg/' t1_scan(1).name '/' fileName];
            outputfile = [runPath 'reg/' t1_scan(1).name '/' fileName2 '_mni.nii.gz'];
            matFile = [runPath 'reg/' t1_scan(1).name '/' fileName2 '_mni'];
            runner = ['/usr/local/fsl/bin/flirt -in ' inputfile ' -ref /usr/local/fsl/data/standard/MNI152_T1_2mm_brain -out ' outputfile ' -omat ' matFile '.mat -bins 256 -cost mutualinfo -searchrx 0 0 -searchry 0 0 -searchrz 0 0 -dof 6  -interp trilinear'];        

            disp(runner);
            unix(runner);
            cd ('..');
            cd ('..')
            disp ('This has ended')
        end
        cd ('..')
    end
end


          
        