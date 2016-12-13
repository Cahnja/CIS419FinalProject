clear all;close all; clc;
disp ('this has started')
path = '/Users/jackcahn/Dropbox/cavity/Gold_Standard_data/';
cd (path)
currentList = dir ('x*'); 

% global variables / assumtions
l = 3;
frameIndex = 1;
hardcode = 277657;

% for each subject
for subjNum1 = 1: 1%length (currentList)
    cd(path);
    for subjNum = 1: 1 %length (currentList)
        %if subjNum ~= subjNum1
            tic
            iname = currentList (subjNum).name;
            iname2 = currentList (subjNum1).name;
            disp(iname);
            disp(iname2);
            cd (iname)
            fileList = dir ('*2*');
            brain = fileList(2).name;
            mask = fileList(1).name;
            flair = fileList(3).name;

            brain_path = [path iname '/' brain]; 
            mask_path = [path iname '/' mask];
            flair_path = [path iname '/' flair];

            fileList = dir ('*diff_image_mask*');
            silver = fileList(1).name;
            silver_path = [path iname '/' silver]; 

            mask_path = silver_path;

            disp(brain_path);
            disp(mask_path);

            % create Xtrain, ytrain
            [brain_image, dims1,scales1,bpp1,endian1] = read_avw(brain_path);
            [mask_image, dims2,scales2,bpp2,endian2] = read_avw(mask_path);
            [flair_image, dims2,scales2,bpp2,endian2] = read_avw(flair_path);
            [brainmask, dims1,scales1,bpp1,endian1] = read_avw('/usr/local/fsl/data/standard/MNI152_T1_2mm_brain');

            brain_size = size(brain_image);
            x = brain_size(1);
            y = brain_size(2);
            z = brain_size(3);   

            if subjNum == 1
                brain_image_vector = brain_image(:);
                voxel_size = size(brain_image_vector);
                voxel_size = voxel_size(1);
                vector_size = ceil(voxel_size / l^3);
                Xtrain = zeros(l,l,l, vector_size * length(currentList));
                ytrain = Xtrain;
                flairtrain = Xtrain;
                disp(size(Xtrain));
                disp(size(ytrain));
            end

            m = floor(l/2);

            for i = m+1 : x - m
                for j = m+1: y - m
                    for k = m+1: z - m
                        if brainmask(i,j,k) > 0
                            %disp(frameIndex);
                            myMatrix = brain_image(i-m:i+m,j-m:j+m,k-m:k+m);
                            myMask = mask_image(i-m:i+m,j-m:j+m,k-m:k+m);
                            myFlair = flair_image(i-m:i+m,j-m:j+m,k-m:k+m);
                            % fix this by binarizing the mask
                            inds = find(myMask > 0);
                            myMask(inds) = 1;
                            Xtrain(:,:,:,frameIndex) = myMatrix;
                            ytrain(:,:,:,frameIndex) = myMask;
                            flairtrain(:,:,:,frameIndex) = myFlair;
                            frameIndex = frameIndex + 1;
                        end
                    end
                end
            end
        cd (path)
      %end
    end

    %train the classifer
    frame = Xtrain(:,:,:,1);
    frame_size = size(frame);
    frame_size = frame_size(1);
    disp(frame_size);
    X_train_vectorized = zeros(frameIndex, frame_size^3);
    y_train_vectorized = zeros(frameIndex, frame_size^3);
    flair_train_vectorized = zeros(frameIndex, frame_size^3);
    count = 1
    for i = 1: frameIndex -1
       Xframe = Xtrain(:,:,:,i);
       yframe = ytrain(:,:,:,i);
       flairframe = flairtrain(:,:,:,i);
       a = zeros(size(yframe(:)));
       X_train_vectorized(i,:) = Xframe(:);
       y_train_vectorized(i,:) = yframe(:);
       flair_train_vectorized(i,:) = flairframe(:);
    end

    X1 = X_train_vectorized;
    X2 = flair_train_vectorized;
    X3 = horzcat(X1,X2);
    
    Y = y_train_vectorized;   
    Y = Y + 1;
    
    hiddenLayerSize = 20;
    net = feedforwardnet(hiddenLayerSize);
    disp('begin T1 training');
    %KNNMod = fitlm(X1,Y);
    [net,tr] = train(net,transpose(X3),transpose(Y));
    %B1 = mnrfit(X1,Y);
    disp('end T1 training');
    %disp('begin flair training');
    %B2 = mnrfit(X2,Y);
    %disp('end flair training');
    %disp('begin combined training');
    %B3 = mnrfit(X3,Y);
    %disp('end combined training');

    %save('B1_cv_gold.mat', 'B1');
    %save('B2_cv_gold.mat', 'B2');
    %save('B3_cv_gold.mat', 'B3');

    %save(['model' num2str(subjNum) '.mat'], 'B1');

    cd (path)

    for subjNum = 1: 1%length (currentList)
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


        %intercept = B1(1);
        %coefficient = B1(2);

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
                        %prediction1 = predict(KNNMod,myMatrix(:));
                        prediction1 = net([myMatrix(:) myFlair(:)]);
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

       %mask = mask * -1;
       mask1 = mask;
       q1 = quantile(mask1(inds), 0.8);
       disp(q1);
       inds1 = find(mask1 <= q1 | brainmask==0);

       mask1(inds1) = 0;
       mask1(indsEdge) = 0;

       %q1 = quantile(mask2(inds), 0.93);
       %disp(q1);
       %inds2 = find(mask2 <= q1 | brainmask==0);

       %mask2 = mask2 * -1; 
       %mask2(inds2) = 0;
       %mask2(indsEdge) = 0;

       %q1 = quantile(mask3(inds), 0.07);
       %disp(q1);
       %inds3 = find(mask3 >= q1 | brainmask==0);

       %mask3 = mask3 * -1; 
       %mask3(inds3) = 0;
       %mask3(indsEdge) = 0;

       save_avw(mask1, 'tester3.nii.gz','f',scales2);   
       %save_avw(mask2, 'mask_prediction_flair_silver_cv10.nii.gz','f',scales2);   
       %save_avw(mask3, 'mask_prediction_combined_silver_cv10.nii.gz','f',scales2);   
       processingtime(subjNum)=toc;
    end        
end
        