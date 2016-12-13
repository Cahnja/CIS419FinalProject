clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Data/';
cd (path)
currentList = dir ('x*'); 
 
% for each subject
for subjNum = 1: 1
    iname = currentList (subjNum).name;
    cd (iname)
    runList = dir ('x*');
    % for each run pre vs. post
    for runNum = 1: 1
        runName = runList(runNum).name;
        cd (runName)
        
        %get the reference image
        t1_scan = dir ('xT1_*');
        cd (t1_scan(1).name);
        fileList = dir ('*.nii*');
        fileName = fileList(1).name;
        fileName2 = strtok(fileName,{'.'});
        reference_file = strcat(t1_scan(1).name, '/', fileName2);
        disp([path iname '/' runName '/reg/' reference_file '.nii.gz']);
        [refFile, dims1,scales1,bpp1,endian1] = read_avw([path iname '/' runName '/reg/' reference_file '.nii.gz']);
        disp([path iname '/' runName '/reg/' reference_file '_brain_mask.nii.gz']);
        [refMask, dims2,scales2,bpp2,endian2] = read_avw([path iname '/' runName '/reg/' reference_file '_brain_mask.nii.gz']);
        cd ('..');
    end
end

cd (path)
currentList = dir ('x*'); 
% for each subject
for subjNum = 8: length (currentList)
    iname = currentList (subjNum).name;
    cd (iname)
    runList = dir ('x*');
    % for each run pre vs. post
    for runNum = 1: 1
        runName = runList(runNum).name;
        if runName == runList(1).name
            runNameOther = runList(2).name;
        end
        if runName == runList(2).name
            runNameOther = runList(1).name;
        end
        cd (runName)
        cd ('reg');
        
        %get the reference image
        t1_scan = dir ('xT1_*');
        cd (t1_scan(1).name);
        fileList = dir ('*.nii*');
        fileName = fileList(1).name;
        fileName2 = strtok(fileName,{'.'});
        reference_file = strcat(t1_scan(1).name, '/', fileName2);
        disp([path iname '/' runName '/reg/' reference_file '_brain_mask.nii.gz'])
        [inputMask, dims1,scales1,bpp1,endian1] = read_avw([path iname '/' runName '/reg/' reference_file '_brain_mask.nii.gz']);
        cd ('..');
        
        cd ('..');
        otherDay = ['reg_' runNameOther];
        cd(otherDay);
        % go through the scans
        scanList = dir ('xT1_*');
    	for scanNum = 1 : length (scanList)
            scanName = scanList(scanNum).name;    
            cd (scanName);
            fileList = dir ('*1001.nii.gz*');
            
            % for each actual scan
            fileName = fileList(1).name;
            fileName2 = strtok(fileName,{'.'});
            %array = strtok(fileName,{'.'});
            %fileName = array(1);
            disp([path iname '/' runName '/' otherDay '/' scanName '/' fileName]);
            [inputFile, dims1,scales1,bpp1,endian1] = read_avw([path iname '/' runName '/' otherDay '/' scanName '/' fileName]);
            normalized = histnorm2(refFile, refMask, inputFile, inputMask);
            save_avw(normalized,[fileName2 '_normalized.nii.gz'],'f', scales1);
            disp ('This has ended')
            cd ('..');
        end
        disp ('This has ended')
        cd ('..');
    end
    cd ('..')
    cd ('..')
end


          
        