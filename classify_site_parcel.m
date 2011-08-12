clear all, clc

root_dir='~/Research/data/MRI/1000FCP/';
base_dir=[root_dir 'base/mat/'];

fnames=dir(base_dir);
fnames(1:2)=[];

k=0;
for i=1:length(fnames)
    
    if strcmp(fnames(i).name(end-5),'_') && strcmp(fnames(i).name(end-3:end),'.mat')
        k=k+1;
        disp(fnames(i).name)
        load([base_dir fnames(i).name])
        [Lhat(k) incorrects{k}] = xval_SigSub_classifier(Abin,genders); %,constraints,'InSample');
    end
    
end

Lhat_reshaped=reshape(Lhat,4,k/4);
save([root_dir 'results/naivebayes.mat'])