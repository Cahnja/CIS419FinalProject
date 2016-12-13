clear all;close all; clc;
disp ('this has started')
cd /Users/jackcahn/Dropbox/cavity/Data/
currentList = dir ('x*'); 
 
% for each subject
for subjNum = 1: length (currentList)
    iname = currentList (subjNum).name;
    cd (iname)
    runList = dir ('x*');
    % for each run pre vs. post
    for runNum1 = 1: length (runList)
        runName1 = runList(runNum1).name;
        for runNum2 = 1: length (runList)
            % if the run we're looking at is not the core runNum
            if runNum2 ~= runNum1
                runName2 = runList(runNum2).name;
                cd (runName2)
                newName = strcat('reg_', runName1);
                mkdir (newName)
                scanList = dir ('x*');
                for scanNum = 1: length (scanList)
                    scanName = scanList(scanNum).name;
                    cd (newName)
                    mkdir(scanName)
                    cd ('..')
                end
                cd ('..')
            end
        end
    end
    cd ('..')
end


            % fileList = dir ('*.nii*');
            % for each actual scan
            % for fileNum = 1: length (fileList)
            %    fileName = fileList(fileNum).name;
            %    disp (fileName)
            % end
            % cd ('..')         
        