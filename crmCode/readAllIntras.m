function [ intras ] = readAllIntras( options )
% ¶ÁÈ¡intra saliency½á¹û  2017/05/23 
intraFiles = imdir(fullfile(options.intra_folder));
nframe = length( intraFiles);
intras = cell( nframe, 1 );
for index = 1: nframe
    [~, intraName] = fileparts(intraFiles(index).name);
    if exist(fullfile(options.intra_folder, [intraName '.png']),'file')
        intra = imread(fullfile(options.intra_folder, [intraName '.png']));
    elseif exist(fullfile(options.intra_folder, [intraName '.jpg']),'file')
        intra = imread(fullfile(options.intra_folder, [intraName '.jpg']));
    elseif exist(fullfile(options.intra_folder, [intraName '.bmp']),'file')
        intra = imread(fullfile(options.intra_folder, [intraName '.bmp']));
    end
    intras{ index } = double(intra);
end
end

