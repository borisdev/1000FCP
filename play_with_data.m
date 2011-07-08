clear, clc

% point to files
rootdir='~/Research/data/MRI/1000FCP/raw/';
site='Finland';
dirname=[rootdir site '/'];
parcellation='aal';
thr_dir=[rootdir 'centmat/' site '/'];

fcon_fnames = dir(dirname);
thr_fnames = dir(thr_dir);

demo=importdata([rootdir '0_info/demograph/' site '.txt']);

n_v=90;
n_s=floor(length(fcon_fnames)/4);

Aweighted=nan(n_v,n_v,n_s);
Abin=nan(n_v,n_v,n_s);
ClassIDs=nan(n_s,1);
thr_r=nan(n_s,1);
thr_s=nan(n_s,1);
k=0;
for i=1:length(fcon_fnames)
    if length(fcon_fnames(i).name)>=9
        if strcmp(fcon_fnames(i).name(1:8),['rsfc_' parcellation])
            k=k+1;
            
            % get correlation matrices
            load([dirname fcon_fnames(i).name])
            Aw(:,:,k)=Zf;

            % get thresholds
            load([thr_dir thr_fnames(i).name])
            thr_r(k)=r_thr;
            thr_s(k)=s_thr;
            
            % get genders
            if strcmp(demo{k}(end),'m')
                ys(k)=1;
            elseif strcmp(demo{k}(end),'f')
                ys(k)=0;
            end
        end
    end
end

disp(['# nans in graphs: ' num2str(sum(isnan(Aw(:))))])
disp(['# nans in genders: ' num2str(sum(isnan(ys(:))))])

% get binary adjacency matrices
for i=1:n_s
   temp=Aw(:,:,i);
   temp(abs(temp)<thr_r(i))=0;
   temp(abs(temp)>=thr_r(i))=1;
   Abin(:,:,i)=temp;
end
sum(Abin(:))/numel(Abin)

save([rootdir(1:end-4) 'base/' site '_' parcellation],'Aw','Abin','ys')

%% alg stuff
profile on
clear alg
i=0;

i=i+1;
alg(i).name='naive bayes';
alg(i).edge_list=find(tril(ones(n_v)-diag(ones(n_v,1)),-1));

i=i+1;
alg(i).name='incoherent';
alg(i).edge_list=5; %unique(round(logspace(0,log10(nchoosek(n_v,2)/2),5)));
 
i=i+1;
alg(i).name='coherent';
alg(i).star_list=[1 2]; %1:n_v/2;
alg(i).edge_list{1}=5;
alg(i).edge_list{2}=10;

% for m=1:length(alg(i).star_list)
%     alg(i).edge_list{m}=[5 10]; %1:n_v*alg(i).star_list(m)/2;
% end
% 
% i=i+1;
% alg(i).name='egg';
% alg(i).star_list=1:n_v/2;
% for m=1:length(alg(i).star_list)
%     alg(i).edge_list{m}=1:n_v*alg(i).star_list(m)/2; unique(round(logspace(0,log10(n_v*alg(i).star_list(m)/3),100))); %
% end

nAlgs=numel(alg);

% classify
Out = plugin_classifier_cv_loop(Abin,ClassIDs,alg,'InSample');

%
clear constraints
constraints{1}=NaN;
constraints{2}=5;
constraints{3}=[1 5];
constraints{4}=[2 10];

% classify
[Lhat2 incorrects2 subspace2] = xval_plugin_classifier(Abin,ClassIDs,constraints,'InSample');

profile viewer


%%
%% look at means


A0=mean(Aweighted(:,:,find(ClassIDs==1)),3);
A1=mean(Aweighted(:,:,find(ClassIDs==0)),3);

figure(1), clf
subplot(131), imagesc(A0), colorbar
subplot(132), imagesc(A1), colorbar
subplot(133), imagesc(diff(A0-A1)), colorbar

%% look at distributions of values at edges

for i=1:n_v
    for j=i:n_v
        A0=squeeze(Aweighted(i,j,find(ClassIDs==1)));
        A1=squeeze(Aweighted(i,j,find(ClassIDs==0)));
        
        figure(1), clf
        subplot(121), hist(A0), colorbar
        subplot(122), hist(A1), colorbar
        %        subplot(133), imagesc(diff(A0-A1)), colorbar
        
        keyboard
        
    end
end

%%

figure(1), clf,
subplot(221), imagesc(R), colorbar
subplot(222), imagesc(Reff), colorbar
subplot(223), imagesc(Zf), colorbar
subplot(224), imagesc((Zs)), colorbar

%%

% Abin=Aweighted;
% Abin(abs(Abin)<0.2)=0;
% Abin(abs(Abin)>=0.2)=1;

