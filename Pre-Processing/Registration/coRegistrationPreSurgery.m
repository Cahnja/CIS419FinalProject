clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Data/';
cd (path)
currentList = dir ('x*'); 
 
% for each subject
for subjNum = 2: length (currentList)
    iname = currentList (subjNum).name;
    cd (iname)
    runList = dir ('x*');
    % for each run pre vs. post
    for runNum = 1: length (runList)
        runName = runList(runNum).name;
        cd (runName)
        
        %get the reference image
        t1_scan = dir ('xT1_*');
        cd (t1_scan(1).name);
        fileList = dir ('*.nii*');
        reference_file = strcat(t1_scan(1).name, '/', fileList(1).name);
        cd ('..')
        
        % go through the scans
        scanList = dir ('x*');
    	for scanNum = 1 : length (scanList)
            scanName = scanList(scanNum).name;    
            cd (scanName);
            fileList = dir ('*.nii*');
            % for each actual scan
            fileName = fileList(1).name;
            fileName2 = strtok(fileName,{'.'});
            %array = strtok(fileName,{'.'});
            %fileName = array(1);
            runPath = strcat(path, iname, '/', runName, '/');
            inputfile = strcat(runPath, scanName, '/', fileName);
            outputfile = strcat(runPath,'reg/', scanName,'/', fileName2);
            matFile = strcat(runPath,'reg/', scanName,'/', fileName2);
            ref = strcat(runPath, reference_file);
            runner = ['/usr/local/fsl/bin/flirt -in ' inputfile ' -ref ' ref ' -out ' outputfile ' -omat ' matFile '.mat -bins 256 -cost mutualinfo -searchrx 0 0 -searchry 0 0 -searchrz 0 0 -dof 6  -interp trilinear'];
            disp(runner);
            unix(runner);
            cd ('..');
        end
        disp ('This has ended')
        cd ('..');
    end
    cd ('..')
end


          
        