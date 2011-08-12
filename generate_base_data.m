function [Aw Abin genders ages] = generate_base_data(site,parcellation,thr,formats)
% this function generates the 'base' data from the 'raw' data
% 'raw' data should never be modified or touched
% 'base' data is the data that is generated from the raw data, and the data
% that all our code will operate on
%
% this function assumes that the 'raw' data lives in the following format:
% root_dir/(site)/rsfc_(parcellation)_(subjectid).mat
% (note that this means all .mat files are in a single directory for ALL
% site (including harvard and china)
%
% INPUT:
%   site:           name of site
%   parcellation:   name of parcellation
%   formats:        which formats to save: 0=matlab, 1=csv, 2=both
%
% OUTPUT: nothing, but saves a .mat file and .csv files
%   (site)_(parcellation).mat contains: {Aw, Abin, ys}, which are the
%   correlation matrices, binarized correlation matrices (using thresholds
%   from the folder 'centmat'), and class id's, respectively.


% point to files
root_dir='~/Research/data/MRI/1000FCP/raw/';
fcon_dir=[root_dir site '/'];
fcon_fnames = dir(fcon_dir);
demo=importdata([root_dir '0_info/demograph/' site '.txt']);

if strcmp(parcellation(1),'a')
    n=90;
elseif strcmp(parcellation(1),'c')
    n=177;
elseif strcmp(parcellation(1),'d')
    n=140;
elseif strcmp(parcellation(1),'h')
    if strcmp(site,'Bangor') || strcmp(site,'Berlin')
        n=106;
    else
        n=105;
    end
end

numSamp=floor(length(fcon_fnames)/4);

Aw=nan(n,n,numSamp);
Abin=nan(n,n,numSamp);
genders=nan(numSamp,1);
ages=nan(numSamp,1);
k=0;

for i=1:length(fcon_fnames)
    if length(fcon_fnames(i).name)>=9
        if strcmp(fcon_fnames(i).name(6),parcellation(1))
            k=k+1;
            
            % get correlation matrices
            load([fcon_dir fcon_fnames(i).name])
            Aw(:,:,k)=tril(Reff,-1);
            
            % get genders
            if ~isempty(strfind(demo{k}(3:end),'m'))
                genders(k)=1;
            elseif ~isempty(strfind(demo{k}(3:end),'f'))
                genders(k)=0;
            end
            
            % get ages
            ages(k)=str2num(demo{k}(1:end-2));
            
        end
    end
end

% get binary adjacency matrices
for i=1:numSamp
    Abin(:,:,i)=Aw(:,:,i)>thr;
end

% convert to less memory intensive format
Abin=logical(Abin);
Aw=single(Aw);

anynans=[sum(isnan(Aw(:))) sum(isnan(genders(:))) sum(isnan(ages(:)))];
if any(anynans(:)), keyboard, end

% display results
% disp(['site: ' site ' parcellation: ' parcellation])
% disp(['# nans: ' num2str(sum(anynans))])
% disp(['sparsity: ' num2str(sum(Abin(:))/(k*nchoosek(n,2)))])

% make sure base data directories exist
base_dir=[root_dir(1:end-4) 'base/'];
if ~isdir(base_dir), mkdir(base_dir); end

mat_dir=[base_dir 'mat/'];
if ~isdir(mat_dir), mkdir(mat_dir); end

csv_dir=[base_dir 'csv/'];
if ~isdir(csv_dir), mkdir(csv_dir); end


% write .mat and .csv files
fname=[site '_' parcellation(1)];

if nargin==2, formats=0; end
if any(formats==[0 2])
    save([mat_dir fname],'Aw','Abin','genders','ages')
end
if any(formats==[1 2])
    csvwrite([csv_dir fname '_Aw.csv'],Aw)
    csvwrite([csv_dir fname '_Abin.csv'],Abin)
    csvwrite([csv_dir fname '_genders.csv'],genders)
    csvwrite([csv_dir fname '_ages.csv'],ages)
end