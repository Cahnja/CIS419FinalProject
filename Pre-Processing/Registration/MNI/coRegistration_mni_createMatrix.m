]clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Data/';
cd (path)
currentList = dir ('x*'); 
 
% for each subject
for subjNum = 3: 3 %length (currentList)
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
            matFile1 = [runPath 'reg/' t1_scan(1).name '/' fileName];
            cd ('..')
            otherDay = ['reg_' runNameOther];
            cd (otherDay);
            t1_scan = dir ('xT1_*');
            cd (t1_scan(1).name);
            fileList = dir ('*1001.mat*');
            fileName = fileList(1).name;
            fileName2 = strtok(fileName,{'.'});
            
            matFile2 = [runPath 'reg_' runNameOther '/' t1_scan(1).name '/' fileName];
            outputfile = [runPath 'reg_' runNameOther '/' t1_scan(1).name '/' fileName2 '_toPreSurgeryMNI.mat'];
            
            runner = ['/usr/local/fsl/bin/convert_xfm -omat ' outputfile ' -concat ' matFile1 ' ' matFile2];               
         
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


          
        