%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is for the paper: 
% Runmin Cong, Jianjun Lei, Huazhu Fu, Fatih Porikli, Qingming Huang, and Chunping Hou,
% Video saliency detection via sparsity-based reconstruction and propagation, IEEE Transactions on Image Processing, 2019.
% DOI: 10.1109/TIP.2019.2910377.

% It can only be used for non-comercial purpose. If you use our code, please cite our paper.

% For any questions, please contact rmcong@126.com  runmincong@gmail.com.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all

addpath( genpath( '.' ) );

datasetPath = '.\data\RGB';% input rgb data

OF_SUP_Path = '.\results\OpticalFlow_SLIC500';
mkdir(OF_SUP_Path);
rsultsetPath = '.\results\SRP';
mkdir(rsultsetPath);
run('.\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup')

options.valScale = 60;
options.alpha = 0.05;
options.color_size = 5;
options.vocal = true;
options.regnum = 500;
options.m = 20;
options.gradLambda = 1;
options.beta = 10;
options.lammda1 = 1;
options.lammda2 = 1;
options.lammda3 = 1;
options.bg_num = 250;% background seed number
options.fg_num = 50;% foreground seed number

videoFiles = dir(datasetPath);
videoNUM = length(videoFiles)-2;

intraSaliency = cell( videoNUM, 1 );
interForeSaliency = cell( videoNUM, 1 );
interBackSaliency = cell( videoNUM, 1 );
optSaliency = cell( videoNUM, 1 );

for videonum = 1:videoNUM
    fprintf(['Processing Video ' num2str(videonum)]); disp(' ');
    videofolder =  videoFiles(videonum+2).name;
    options.infolder = fullfile( datasetPath, videofolder );
    options.OF_SUP_folder = fullfile( OF_SUP_Path, videofolder );
    % The folder where all the outputs will be stored.
    options.outfolder = fullfile( rsultsetPath, videofolder );
    if( ~exist( options.outfolder, 'dir' ) )
        mkdir( options.outfolder ),
    end;
    if( ~exist( fullfile( options.outfolder, 'intraSal'), 'dir' ) )
        mkdir(fullfile( options.outfolder, 'intraSal'));
    end
    if( ~exist( fullfile( options.outfolder, 'interSal'), 'dir' ) )
        mkdir(fullfile( options.outfolder, 'interSal'));
    end
    if( ~exist( fullfile( options.outfolder, 'videoSal'), 'dir' ) )
        mkdir(fullfile( options.outfolder, 'videoSal'));
    end
    % Cache all frames in memory  imread读入的0-255数据格式
    [data.frames,data.names,height,width,nframe ]= readAllFrames( options );
    
    % Load optical flow (or compute if file is not found)
    data.flow = loadFlow( options );
    if( isempty( data.flow ) )
        data.flow = computeOpticalFlow( options, data.frames );
        for kk = 1:length(data.flow)
            OF = flowToColor(data.flow{kk});
            savePath = fullfile( options.OF_SUP_folder, 'flow', [data.names{kk} '_OF.png']);
            imwrite(OF,savePath,'png');
        end
    end
    
    % Load superpixels (or compute if not found)
    data.superpixels = loadSuperpixels( options );
    if( isempty( data.superpixels ) )
        data.superpixels = computeSuperpixels(  options, data.frames );
    end
    %%% superpixels nFrame-1*1 cell; nodeFrameId - 视频序列所有超像素对应的视频帧标号id labels*1 double;
    %%%　bounds：　1*nFrame double 视频帧分割线  labels：所有视频帧的超像素个数之和 double
    [ superpixels, nodeFrameId, bounds, labels ] = makeSuperpixelIndexUnique( data.superpixels );
    %%% colours - Superpixel mean colour: a single array of length N, where N is the number of superpixels
    %%%           in the video sequence, containing the mean colour (RGB) value of each superpixel.
    %%% centres - Superpixel centre of mass: a single array of length N, containing the centre of mass of each superpixel.
    %%% t - Superpixel size: a single array of length N, containing the size of each superpixel in pixels.
    [ colours, centres, t ] = getSuperpixelStats( data.frames(1:nframe-1), superpixels, double(labels) );
    
    valLAB = [];
    for index = 1:nframe-1
        valLAB = [valLAB;data.superpixels{index}.Sup1, data.superpixels{index}.Sup2, data.superpixels{index}.Sup3];
    end
    
    %% Intra Saliency Calculation
    intraSaliency{videonum} = cell( nframe-1, 1 );
    fprintf(['Calculating the Intra Saliency for Video ' num2str(videonum) ]); disp(' ');
    for index = 1:nframe-1        
        % load color frame data
        frame = data.frames{index}; % double M*N*3 0-255
        frame_norm = norm_img(frame); % double M*N*3 0-1
        frameName = data.names{index};
        nLabel = max(data.superpixels{index}.Label(:));% int32
        Label = data.superpixels{index}.Label; % int32 M*N
        frame_vals = reshape(frame_norm, height*width, 3);
        frame_sup = getFrameSuperpixel( frame_vals, double(Label), double(nLabel), height, width );
        regions = calculateRegionProps(double(nLabel),double(Label));         
        
        % motion information : optical flow data and optical flow mangnitude
        of = data.flow{index};
        of_vals = reshape(of, height*width, 2);
        of_sup = getOFSuperpixel( of_vals, double(Label), double(nLabel) );        
        if max(max(max(of))) == 0
            ismot = 0;
        else
            ismot = 1;
            MOF_norm = calOpticalFlowMagnitude(of);
            MOF_vals = reshape(MOF_norm, height*width, 1);
            MOF_sup = getIntraSuperpixel( MOF_vals, double(Label), double(nLabel) );
        end
       
        % Graph Construction for color frame and optical flow
        [ Sc,Wc,Pc ] = GraphConstruct( frame_sup.rgb, frame_sup.adjc, double(nLabel) );        
        [ Sm,Wm,Pm ] = MotionGraph( of_sup, frame_sup.adjc, double(nLabel), ismot );
        
        %  Static Saliency
        % Compactness prior
        [ CC, BGindex_CC ] = CompactSeeds( frame_sup, Pc, Sc, double(nLabel), options.bg_num );
        % Boundary prior
        bg_all = extract_bg_sp( double(Label), height, width );% extract the boundary of the iamge
        BGindex_BD = bg_all;
        % Uniqueness prior
        clusternum = 20;
        [ BGindex_CU, FGindex_CU ] = UniquenessSeeds3( frame_sup, clusternum, CC, bg_all, double(Label) );        
        % Background Seeds Determination
        CBGseeds = unique( union( union( BGindex_CC, BGindex_BD ), BGindex_CU ) );     
        % intra frame saliency based on sparse reconstruction error and diffusion optimization
        [ ColError, propColError ] = calColorSRRecError( options, frameName, double(Label), CBGseeds );        
        propColErrorDiffusion = Pc*propColError';% spnum*1 Manifold Ranking-based Diffusion                
        % Motion Saliency
        if ismot == 0
            propMotErrorDiffusion = propColErrorDiffusion;
            intraDiffusionSal = propColErrorDiffusion;
            intraSaliency{videonum}{index} = intraDiffusionSal;
        else
            % Compactness prior
            [ MC, BGindex_MC ] = CompactSeeds( frame_sup, Pm, Sm, double(nLabel), options.bg_num );
            % Uniqueness prior
            [ GC, BGindex_MU ] = MotionUniqueSeeds( frame_sup, MOF_sup, double(nLabel), options.bg_num );
            % Background Seeds Determination
            MBGseeds = unique(union(BGindex_MC,BGindex_MU));
            % intra frame saliency based on sparse reconstruction error and diffusion optimization
            [ MotError, propMotError ] = calMotionSRRecError( options, frameName, double(Label), MBGseeds, of_sup,  MOF_sup  );
            propMotErrorDiffusion = Pm*propMotError';% spnum*1 Manifold Ranking-based Diffusion           
            % Intra Saliency
            intraDiffusionSal = propColErrorDiffusion.*propMotErrorDiffusion;
            intraSaliency{videonum}{index} = intraDiffusionSal;
        end
        % Save Intra Results        
%         propColErrorDiffusionSaliency = Sup2Sal(propColErrorDiffusion', regions, height, width, double(nLabel));%M*N
%         imwrite(propColErrorDiffusionSaliency, [options.outfolder '\intraSal\' frameName '_intra_static'  '.png']);
%                 
%         propMotErrorDiffusionSaliency = Sup2Sal(propMotErrorDiffusion', regions, height, width, double(nLabel));%M*N
%         imwrite(propMotErrorDiffusionSaliency, [options.outfolder '\intraSal\' frameName '_intra_motion'  '.png']);
                       
        intraDiffusionSaliency = Sup2Sal(intraDiffusionSal, regions, height, width, double(nLabel));%M*N
        imwrite(intraDiffusionSaliency, [options.outfolder '\intraSal\' frameName '_intra'  '.png']);
        
        clear regions S W Sm Wm P Pm frame_sup CBGseeds MBGseeds ismot
    end
    %% Inter Saliency Calculation
    % inter frame forward saliency 
    interForeSaliency{videonum} = cell( nframe-1, 1 );
    interBackSaliency{videonum} = cell( nframe-1, 1 );
    SalForward_all = cell( nframe-1, 1 );
    SalBackward_all = cell( nframe-1, 1 );
    fprintf(['Calculating the Forward Inter Saliency for Video ' num2str(videonum)]); disp(' ');
    for index = 1:nframe-1
        curframe_sup = cell(5,1);% current frame information
        preframe_sup = cell(5,1);% previous frame information
        if index == 1
            % load intra saliency
            frameName = data.names{index};
            nLabel = max(data.superpixels{index}.Label(:));% int32
            Label = data.superpixels{index}.Label; % int32
            regions = calculateRegionProps(double(nLabel),double(Label));  
            intra_sup = intraSaliency{videonum}{index};
            SalForward_sup = intra_sup;
            SalForward_all{index} = SalForward_sup;
            interForeSaliency{videonum}{index} = SalForward_all{index};
%             ForwardSaliency = Sup2Sal(SalForward_sup',regions,height,width,double(nLabel));%M*N
%             imwrite(ForwardSaliency, [options.outfolder '\interSal\' frameName '_inter_forward'  '.png']);
        else
            % load current frame information : color; optial flow 
            frame_current = data.frames{index}; % double M*N*3 0-255
            frame_current_norm = norm_img(frame_current); % double M*N*3 0-1
            curframe_sup.Name = data.names{index};
            
            opflow_current = data.flow{index};% double M*N*2
            opflow_current_norm = norm_flow(opflow_current); % double M*N*2 0-1
                        
            % get superpixel-level current frame information:  color; intra flow
            nLabel_current = max(data.superpixels{index}.Label(:));% int32
            curframe_sup.Label = data.superpixels{index}.Label; % int32
            regions_current = calculateRegionProps(double(nLabel_current),double(curframe_sup.Label));  
            
            frame_current_vals = reshape(frame_current_norm, height*width, 3);
            frame_current_sup = getFrameSuperpixel( frame_current_vals, double(curframe_sup.Label), double(nLabel_current), height, width );     
            
            curframe_sup.intra = intraSaliency{videonum}{index};
            
            opflow_current_vals = reshape(opflow_current_norm, height*width, 2);
            curframe_sup.opflow = getFlowSuperpixel( opflow_current_vals, double(curframe_sup.Label), double(nLabel_current) );
            
            MOF_current_norm = calOpticalFlowMagnitude(opflow_current);
            MOF_current_vals = reshape(MOF_current_norm, height*width, 1);
            curframe_sup.MOF = getIntraSuperpixel( MOF_current_vals, double(curframe_sup.Label), double(nLabel_current) );
            
            % Graph Construction for current frame
            [ S_current, W_current, P_current] = GraphConstruct( frame_current_sup.rgb, frame_current_sup.adjc, double(nLabel_current));
            
            % load (index - 1) frame information :  intra saliency
            nLabel_previous = max(data.superpixels{index-1}.Label(:));% int32
            preframe_sup.Label = data.superpixels{index-1}.Label; % int32
            preframe_sup.Name = data.names{index-1};
            preframe_sup.intra = intraSaliency{videonum}{index-1};
            opflow_previous = data.flow{index-1};
            opflow_previous_norm = norm_flow(opflow_previous); % double M*N*2 0-1
            opflow_previous_vals = reshape(opflow_previous_norm, height*width, 2);
            preframe_sup.opflow = getFlowSuperpixel( opflow_previous_vals, double(preframe_sup.Label), double(nLabel_previous) );
            MOF_previous_norm = calOpticalFlowMagnitude(opflow_previous);
            MOF_previous_vals = reshape(MOF_previous_norm, height*width, 1);
            preframe_sup.MOF = getIntraSuperpixel( MOF_previous_vals, double(preframe_sup.Label), double(nLabel_previous) );
            
            if max(max(max(opflow_previous))) ~= 0 && max(max(max(opflow_current))) ~= 0
                ismot = 1;
            else
                ismot = 0;
            end
            
            [ ForwardSRRecError, propForwardSRRecError, diffpropForwardSRRecError ] = ...
                calForwardSRRecError_20170703( options, curframe_sup, preframe_sup, P_current, ismot );% output:1*spnum 1*spnum spnum*1
            SalForward_sup = exp(-options.beta*propForwardSRRecError);
            SalForward_all{index} = norm_minmax(SalForward_sup');
            interForeSaliency{videonum}{index} = SalForward_all{index};
           
%             ForwardSaliency = Sup2Sal(SalForward_sup',regions_current,height,width,double(nLabel_current));%M*N
%             imwrite(ForwardSaliency, [options.outfolder '\interSal\' curframe_sup.Name '_inter_forward'  '.png']);                
        end
        clear regions_current P_current frame_current_sup  intra_previous_sup  SalForward_sup  opflow_current opflow_previous regions curframe_sup preframe_sup ismot
    end
    % inter frame backward saliency 
    fprintf(['Calculating the Backward Inter Saliency for Video ' num2str(videonum)] ); disp(' ');
    for index = nframe-1:-1:1
        curframe_sup = cell(6,1);% current frame information
        backframe_sup = cell(6,1);% previous frame information
        if index == nframe-1
            frameName = data.names{index};
            SalForward_sup = SalForward_all{index};
            SalBackward_sup = SalForward_sup;
            SalBackward_all{index} = SalBackward_sup;
            interBackSaliency{videonum}{index} = SalBackward_all{index};
            nLabel = max(data.superpixels{index}.Label(:));% int32
            Label = data.superpixels{index}.Label; % int32
            regions = calculateRegionProps(double(nLabel),double(Label));
            BackwardSaliency = Sup2Sal(SalBackward_sup',regions,height,width,double(nLabel));%M*N
            imwrite(BackwardSaliency, [options.outfolder '\interSal\' frameName '_inter_backward'  '.png']);
        else
            % load current frame information : color; optial flow 
            frame_current = data.frames{index}; % double M*N*3 0-255
            frame_current_norm = norm_img(frame_current); % double M*N*3 0-1
            curframe_sup.Name = data.names{index};
            opflow_current = data.flow{index};
            opflow_current_norm = norm_flow(opflow_current); % double M*N*2 0-1
            
            % get superpixel-level current frame information:  color; intra flow
            nLabel_current = max(data.superpixels{index}.Label(:));% int32
            curframe_sup.Label = data.superpixels{index}.Label; % int32
            regions_current = calculateRegionProps(double(nLabel_current),double(curframe_sup.Label));             
                 
            opflow_current_vals = reshape(opflow_current_norm, height*width, 2);
            curframe_sup.opflow = getFlowSuperpixel( opflow_current_vals, double(curframe_sup.Label), double(nLabel_current) );
            
            MOF_current_norm = calOpticalFlowMagnitude(opflow_current);
            MOF_current_vals = reshape(MOF_current_norm, height*width, 1);
            curframe_sup.MOF = getIntraSuperpixel( MOF_current_vals, double(curframe_sup.Label), double(nLabel_current) );
            
            curframe_sup.intra = intraSaliency{videonum}{index};
            curframe_sup.forward = SalForward_all{index};
            
            % Graph Construction for current frame
            frame_current_vals = reshape(frame_current_norm, height*width, 3);
            frame_current_sup = getFrameSuperpixel( frame_current_vals, double(curframe_sup.Label), double(nLabel_current), height, width );   
            [ S_current, W_current, P_current ] = GraphConstruct( frame_current_sup.rgb, frame_current_sup.adjc, double(nLabel_current));
            
            % load (current frame + 1 ) information :  intra saliency
            nLabel_back = max(data.superpixels{index+1}.Label(:));% int32
            backframe_sup.Label = data.superpixels{index+1}.Label; % int32
            backframe_sup.Name = data.names{index+1};
            backframe_sup.intra = intraSaliency{videonum}{index+1};
            opflow_back = data.flow{index+1};
            opflow_back_norm = norm_flow(opflow_back); % double M*N*2 0-1
            opflow_back_vals = reshape(opflow_back_norm, height*width, 2);
            backframe_sup.opflow = getFlowSuperpixel( opflow_back_vals, double(backframe_sup.Label), double(nLabel_back) );
            MOF_back_norm = calOpticalFlowMagnitude(opflow_back);
            MOF_back_vals = reshape(MOF_back_norm, height*width, 1);
            backframe_sup.MOF = getIntraSuperpixel( MOF_back_vals, double(backframe_sup.Label), double(nLabel_back) );
            backframe_sup.forward = SalForward_all{index+1};
            
            if max(max(max(opflow_back))) ~= 0 && max(max(max(opflow_current))) ~= 0
                ismot = 1;
            else
                ismot = 0;
            end
            
            [ BackwardSRRecError, propBackwardSRRecError, diffpropBackSRRecError ] = ...
                calBackwardSRRecError_20170703( options, curframe_sup, backframe_sup, P_current, ismot);% output:1*spnum 1*spnum spnum*1
            SalBackward_sup = exp(-options.beta*propBackwardSRRecError);
            
            if length(find(isnan(SalBackward_sup))==1) >=1
                SalBackward_sup = SalForward_all{index};
                SalBackward_all{index} = SalBackward_sup;
                interBackSaliency{videonum}{index} = SalBackward_all{index};
                BackwardSaliency = Sup2Sal(SalBackward_sup',regions_current,height,width,double(nLabel_current));%M*N
                imwrite(BackwardSaliency, [options.outfolder '\interSal\' curframe_sup.Name '_inter'  '.png']);
            else
                SalBackward_all{index} = norm_minmax(SalBackward_sup');
                interBackSaliency{videonum}{index} = SalBackward_all{index};               
                BackwardSaliency = Sup2Sal(SalBackward_sup',regions_current,height,width,double(nLabel_current));%M*N
                imwrite(BackwardSaliency, [options.outfolder '\interSal\' curframe_sup.Name '_inter'  '.png']);
            end                        
        end
        clear regions_current P_current frame_current_sup  intra_back_sup  SalBackward_sup  opflow_current opflow_back  curframe_sup  backframe_sup     
    end
     %% Optimization
    allsals = readallsals( videonum, intraSaliency, interForeSaliency, interBackSaliency );% allsals：labels*1  sals：nframes-1 * 1
    ind = find(isnan(allsals));
    allsals(ind) = 0;
    Sal = allsals;
    supRGBHist = calsupHist( data, options );
    [ConSedge ConSTedge] = ConnectEdge( data, bounds, nframe, centres, height, width );%ConSedge ConSTedge分别为空间邻域和空时邻域
    
    intralength = size(ConSedge,1);
    valDistances = sqrt(sum((valLAB(ConSTedge(:,1),:) - valLAB(ConSTedge(:,2),:)).^2,2));
    
    valSpatialDistances = valDistances(1:intralength);
    valSpatialDistances = norm_minmax(valSpatialDistances);
    SpatialWeights = exp(-options.valScale*valSpatialDistances) + 1e-5;
    SpatialWeights = sparse([ConSedge(:,1);ConSedge(:,2)],[ConSedge(:,2);ConSedge(:,1)], ...
        [SpatialWeights;SpatialWeights],labels,labels); % spnum*spnum
    
    valDistances(intralength+1:end) = valDistances(intralength+1:end)/5;
    valDistances = norm_minmax(valDistances);
    SpatioTemporalWeights = exp(-options.valScale*valDistances) + 1e-5;
    SpatioTemporalWeights = sparse([ConSTedge(:,1);ConSTedge(:,2)],[ConSTedge(:,2);ConSTedge(:,1)], ...
        [SpatioTemporalWeights;SpatioTemporalWeights],labels,labels); % spnum*spnum
    
    W1 = SpatioTemporalWeights;
    d1 = sum(SpatioTemporalWeights,2);%spnum*1
    D1 = sparse(1:labels,1:labels,d1);% spnum*spnum
    
    INN = sparse(1:labels,1:labels,ones(labels,1)); % 单位向量 spnum*spnum
    IN1 = sparse(1:labels,1,1); % 全1列向量 spnum*1
    
    W2 = SpatialWeights;
    fgRGBHist = calfgHist( data, Sal, bounds, height, width, 10 );
    dist = zeros(labels,1);
    for kk = 1:labels
        dist(kk) = DistanceZL(supRGBHist(kk,:), fgRGBHist', 'chi');
    end
    dist = norm_minmax(dist);
    U = sparse(1:labels,1:labels,dist);
    optSaliency{videonum} = (10*options.alpha*INN + options.lammda1*(D1-W1) + options.lammda2*W2 + options.lammda3*U )\...
        ( options.alpha*Sal );
    
    for index = 1:nframe-1
        frameName = data.names{index};
        nLabel = max(data.superpixels{index}.Label(:));% int32
        Label = data.superpixels{index}.Label; % int32
        regions = calculateRegionProps(double(nLabel),double(Label));
        
        optSaliency1 = Sup2Sal(optSaliency{videonum}(bounds(index):bounds(index+1)-1),regions,height,width,double(nLabel));%M*N % double M*N 0-1        
        imwrite(optSaliency1, [options.outfolder '\videoSal\' frameName '_SRP'  '.png']);
    end
end
% t2=clock;
% etime(t2,t1)
% save('.\intraSaliency_SegTrackV1.mat','intraSaliency');
% save('.\interForeSaliency_SegTrackV1.mat','interForeSaliency');
% save('.\interBackSaliency_SegTrackV1.mat','interBackSaliency');
% save('.\videoSaliency_SegTrackV1.mat','optSaliency');
