clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Gold_Standard_data/';
cd (path)
currentList = dir ('x*'); 

for subjNum = 1: 1%length (currentList)
    cd(path)
    tic
    iname = currentList (subjNum).name;
    disp(iname);
    cd (iname)
    
    %get classifer outputs
    fileList = dir ('*cv10*');
    t1 = 'mask_prediction_silver_cv10_knn2_original.nii.gz';
    disp(t1);
    combined = fileList(2).name;
    flair = fileList(3).name;
    
    [t1_mask, dims2,scales2,bpp2,endian2] = read_avw(t1);
    [c_mask, dims2,scales2,bpp2,endian2] = read_avw(combined);
    [flair_mask, dims2,scales2,bpp2,endian2] = read_avw(flair);
    
    % T1 Work
    inds = find(t1_mask > 0);
    t1_mask(inds) = 1;

    CC = bwconncomp(t1_mask,26);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggestSize,idx] = max(numPixels);
    BW2 = false(size(t1_mask));
    BW2(CC.PixelIdxList{idx}) = true;

    %CC.PixelIdxList{idx} = '-inf';
    %numPixels = cellfun(@numel,CC.PixelIdxList);
    %[biggestSize,idx] = max(numPixels);
    %BW2(CC.PixelIdxList{idx}) = true;

    save_avw(BW2, 't1_original_component','f',scales2);   
    
     % Combined Work
    inds = find(c_mask > 0); % modified
    c_mask(inds) = 1; % modified
    CC = bwconncomp(c_mask,26); % modified
    BW2 = false(size(c_mask)); % modified

    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggestSize,idx] = max(numPixels);
    BW2(CC.PixelIdxList{idx}) = true;
    CC.PixelIdxList{idx} = '-inf';
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggestSize,idx] = max(numPixels);
    BW2(CC.PixelIdxList{idx}) = true;

    save_avw(BW2, 'c_goldCV10_component','f',scales2); % modified   
    
     % Flair Work
    inds = find(flair_mask > 0); % modified
    flair_mask(inds) = 1; % modified
    CC = bwconncomp(flair_mask,26); % modified
    BW2 = false(size(flair_mask)); % modified

    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggestSize,idx] = max(numPixels);
    BW2(CC.PixelIdxList{idx}) = true;
    CC.PixelIdxList{idx} = '-inf';
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggestSize,idx] = max(numPixels);
    BW2(CC.PixelIdxList{idx}) = true;

    save_avw(BW2, 'flair_goldCV10_component','f',scales2); % modified   
    
end