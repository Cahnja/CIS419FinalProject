clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Gold_Standard_data/';
cd (path)
currentList = dir ('x*'); 


for subjNum = 1: 1 %length (currentList)
    cd (path)
    iname = currentList (subjNum).name;
    disp(iname);
    cd (iname)
    fileList = dir ('*2*');
    brain = fileList(2).name;
    mask = fileList(1).name;
    flair = fileList(3).name;
    brain_path = [path iname '/' brain]; 
    mask_path = [path iname '/' mask];
    flair_path = [path iname '/' flair];
    disp(brain_path);
    disp(mask_path);
    B1 = importdata('model1.mat');
    % create Xtrain, ytrain
    [brain_image, dims1,scales1,bpp1,endian1] = read_avw(brain_path);
    [flair_image, dims1,scales1,bpp1,endian1] = read_avw(flair_path);
    [mask_image, dims2,scales2,bpp2,endian2] = read_avw(mask_path);
    [brainmask, dims1,scales1,bpp1,endian1] = read_avw('/usr/local/fsl/data/standard/MNI152_T1_2mm_brain');
    [ventricle, dims1,scales1,bpp1,endian1] = read_avw('/usr/local/fsl/data/standard/MNI152_T1_2mm_VentricleMask');
    [edges, dims1,scales1,bpp1,endian1] = read_avw('/usr/local/fsl/data/standard/MNI152_T1_2mm_edges.nii.gz');

    brain_size = size(brain_image);
    x = brain_size(1);
    y = brain_size(2);
    z = brain_size(3);   

    mask = zeros(x,y,z);
    mask2 = zeros(x,y,z);
    mask3 = zeros(x,y,z);


    intercept = B1(1,:);
    coefficient = B1(2:end,:);

    %intercept2 = B2(1);
    %coefficient2 = B2(2);

    %intercept3 = B3(1);
    %coefficient3 = B3(2);
    %coefficient3_2 = B3(2);


     for i = m+1 : x - m
        for j = m+1: y - m
            for k = m+1: z - m
                if brainmask(i,j,k) > 0
                    myMatrix = brain_image(i-m:i+m,j-m:j+m,k-m:k+m);
                    myFlair = flair_image(i-m:i+m,j-m:j+m,k-m:k+m);
                    prediction1 = coefficient*myMatrix(:) + intercept;
                    mask(i,j,k) = prediction1;
                    %prediction2 = (coefficient2*myFlair(:)) + intercept2;
                    %mask2(i,j,k) = prediction2;
                    %prediction3 = (coefficient3*myMatrix(:)) + (coefficient3_2*myFlair(:)) + intercept3;
                    %mask3(i,j,k) = prediction3;
                end
            end
        end
     end

   inds=find(brainmask>0);
   indsVent=find(ventricle>0);
   indsEdge=find(edges>0);
   disp(size(inds));

   q1 = quantile(mask(inds), 0.93);
   disp(q1);
   inds1 = find(mask <= q1 | brainmask==0);

   mask(inds1) = 0;
   mask(indsEdge) = 0;

   %q1 = quantile(mask2(inds), 0.93);
   %disp(q1);
   %inds2 = find(mask2 <= q1 | brainmask==0);

   %mask2(inds2) = 0;
   %mask2(indsEdge) = 0;

   %q1 = quantile(mask3(inds), 0.07);
   %disp(q1);
   %inds3 = find(mask3 >= q1 | brainmask==0);

   %mask3(inds3) = 0;
   %mask3(indsEdge) = 0;

   save_avw(mask, 'mask_prediction_largeFrame.nii.gz','f',scales2);   
   %save_avw(mask2, 'mask_prediction_cv10_flair.nii.gz','f',scales2);   
   %save_avw(mask3,'mask_prediction_cv10_combined.nii.gz','f',scales2);   
   processingtime(subjNum)=toc;
end
    
        