clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Data/';
cd (path)
currentList = dir ('x*'); 
 
% for each subject
for subjNum = 1 : length (currentList)
    iname = currentList (subjNum).name;
    cd (iname)
    runList = dir ('x*');
    % for each run pre vs. post
    for runNum = 1: length (runList)
        runName = runList(runNum).name;
        if runName == runList(1).name
            runNameOther = runList(2).name;
        end
        if runName == runList(2).name
            runNameOther = runList(1).name;
        end
        cd (runName)
        
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
            inputfile = strcat(runPath, 'reg/', scanName, '/', fileName);
            disp(inputfile)
            %find reference file, first file in the other run with the same
            %first words
            cd ('..');
            beginning = scanName(1:4);
            cd ('..');
            cd (runNameOther);
            cd ('reg')
            refList = dir(strcat(beginning, '*'));
            cd (refList(1).name)
            fileList = dir ('*.nii*');
            reference = fileList(1).name;
            cd ('..')
            cd ('..')
            cd ('..')
            cd (runName);
            cd (scanName);
                        
            ref = strcat(path, iname, '/', runNameOther, '/reg/', refList(1).name, '/', reference);
            disp(ref);
            
            outputfile = strcat(path, iname, '/', runNameOther,'/reg_', runName, '/', scanName,'/', fileName2);
            matFile = strcat(path, iname, '/', runNameOther,'/reg_', runName, '/', scanName,'/', fileName2);
            disp(outputfile);
            disp(matFile);
            runner = ['/usr/local/fsl/bin/flirt -in ' inputfile ' -ref ' ref ' -out ' outputfile ' -omat ' matFile '.mat -bins 256 -cost mutualinfo -searchrx 0 0 -searchry 0 0 -searchrz 0 0 -dof 6  -interp trilinear'];
            disp(runner);
            unix(runner);
            disp ('This has ended')
            cd ('..');
        end
        disp ('This has ended')
        cd ('..');
    end
    cd ('..')
end


          
        