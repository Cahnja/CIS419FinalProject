helpclear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Data/';
cd (path)
currentList = dir ('x*'); 
 
% for each subject
for subjNum = 3: 3%length (currentList)
    iname = currentList (subjNum).name;
    cd (iname)
    runList = dir ('x*');
    % for each run pre vs. post
    for runNum = 1: 1 % length (runList)
        runName = runList(runNum).name;
        cd (runName)
        cd ('reg');
        
        %get the reference image
        t1_scan = dir ('xT1_*');
        cd (t1_scan(1).name);
        fileList = dir ('*.nii*');
        fileName = fileList(1).name;
        fileName2 = strtok(fileName,{'.'});
        reference_file = strcat(t1_scan(1).name, '/', fileName2);
        inputfile = [path iname '/' runName '/reg/' reference_file];
        outputfile = [path iname '/' runName '/reg/' reference_file '_brain'];
        %delete([outputfile '.nii.gz']);
        %delete([outputfile '_mask.nii.gz']);
        runner = ['/usr/local/fsl/bin/bet ' inputfile ' ' outputfile  ' -f 0.5 -g 0 -m'];
        disp(runner);
        unix(runner);
        cd ('..');;
        cd ('..');
        cd ('..');
    end
    cd ('..')
end