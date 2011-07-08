% get thresholds
clear, clc

% point to files
root_dir='~/Research/data/MRI/1000FCP/raw/';
thr_dir=[root_dir 'centmat/'];
thr_fnames = dir(thr_dir);

k=0;
for i=1:length(thr_fnames)
    if length(thr_fnames(i).name)>2
        k=k+1;
        site_dir=[thr_dir thr_fnames(i).name];
        subj_fnames=dir(site_dir);
        load([site_dir '/' subj_fnames(3).name])
        thr{k,2}=r_thr;
        thr{k,1}=thr_fnames(i).name;
    end
end


% make sure base data directories exist
base_dir=[root_dir(1:end-4) 'base/'];
if ~isdir(base_dir), mkdir(base_dir); end

mat_dir=[base_dir 'mat/'];
if ~isdir(mat_dir), mkdir(mat_dir); end

csv_dir=[base_dir 'csv/'];
if ~isdir(csv_dir), mkdir(csv_dir); end


% write .mat and .csv files
fname='thresholds';
save([mat_dir fname],'thr')
% csvwrite([csv_dir fname '_thr_r.csv'],thr)