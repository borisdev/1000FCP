% this script goes through all the sites and parcellations and generates
% the base data
clear, clc
root_dir='~/Research/data/MRI/1000FCP/raw/';

parcellations{1}='aal';
parcellations{2}='cameron';
parcellations{3}='dosenbach2010';
parcellations{4}='hoa25';

load([root_dir(1:end-4) 'base/mat/thresholds.mat'])

site_list=dir(root_dir);
site_list(1:2)=[]; % in a mac, the first two entires are always nothing
for i=1:length(site_list)
    goodname=0;
    kk=[];
    for k=1:length(thr)
        if strcmp(site_list(i).name,thr{k,1})
            goodname=1;
            kk=k;
        end
    end
    if goodname==1
        disp(site_list(i).name)
        for j=4%1:3%length(parcellations)
            try
                [Aw Abin genders ages] = generate_base_data(site_list(i).name,parcellations{j},thr{kk,2},0);
            catch err
                disp(['fail: ' site_list(i).name ' ' parcellations{j}])
            end
        end
    end
end