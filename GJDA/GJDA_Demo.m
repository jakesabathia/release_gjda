%add libs
addpath('../Data');
addpath('./lib/libsvm-3.22/matlab');
%clean interface
clear all
%==========================================================================
for expi = 1:6
iter = 20;
acc1 = 0; %Acc for Baseline
acc2 = 0; %Acc for GJDA

%Prepare Data (Choose the three setting below by yourself)
%For Cross-Feature Classification 
source_exp = {'randsource_webcam_SURF_L10.mat','randsource_Caltech10_SURF_L10.mat','randsource_amazon_SURF_L10.mat','randsource_webcam_DeCAF6.mat','randsource_Caltech10_DeCAF6.mat','randsource_amazon_DeCAF6.mat'};
target_exp = {'randtarget_webcam_DeCAF6.mat','randtarget_Caltech10_DeCAF6.mat','randtarget_amazon_DeCAF6.mat','randtarget_webcam_SURF_L10.mat','randtarget_Caltech10_SURF_L10.mat','randtarget_amazon_SURF_L10.mat'};

%For Cross-Domain Classification
%source_exp = {'randsource_webcam_SURF_L10.mat','randsource_Caltech10_SURF_L10.mat','randsource_amazon_SURF_L10.mat','randsource_webcam_DeCAF6.mat','randsource_Caltech10_DeCAF6.mat','randsource_amazon_DeCAF6.mat'};
%target_exp = {'randtarget_dslr_DeCAF6.mat','randtarget_dslr_DeCAF6.mat','randtarget_dslr_DeCAF6.mat','randtarget_dslr_SURF_L10.mat','randtarget_dslr_SURF_L10.mat','randtarget_dslr_SURF_L10.mat'};

%For Multi-Lingual Classification
%source_exp = {'rand_EN.mat','rand_EN.mat','rand_FR.mat','rand_FR.mat','rand_GR.mat','rand_GR.mat','rand_IT.mat','rand_IT.mat'};
%target_exp = {'rand_SP_10.mat','rand_SP_20.mat','rand_SP_10.mat','rand_SP_20.mat','rand_SP_10.mat','rand_SP_20.mat','rand_SP_10.mat','rand_SP_20.mat'};

disp(['Source Domain:' source_exp{expi}]);
disp(['Target Domain:' target_exp{expi}]);

for j = 1:iter
	fprintf('===================iteration[%d]===================\n',j);

	load(source_exp{expi});
	load(target_exp{expi});

	T = training_features{j};
	T_Label = training_labels{j};
	%T = T ./ repmat(sqrt(sum(T.^2,2)),1,size(T,2));  %For Multi-Lingual Only!!!!!!!!!!!!!

	S = source_features{j} ;
	S_Label = source_labels{j};
	%S = S ./ repmat(sqrt(sum(S.^2,2)),1,size(S,2));  %For Multi-Lingual Only!!!!!!!!!!!!!

	Ttest = testing_features{j};
	Ttest_Label = testing_labels{j};
	%Ttest = Ttest ./ repmat(sqrt(sum(Ttest.^2,2)),1,size(Ttest,2));  %For Multi-Lingual Only!!!!!!!!!!!!!

	T = T';
	Ttest = Ttest';
	S = S';

	%Baseline
	option = '-q -t 0';
	[model] = svmtrain(T_Label,T',option);
	[predict_Label,acc,b] = svmpredict(Ttest_Label,Ttest',model,'-q' );
	fprintf('Baseline Acc:%f\n',acc(1));
	acc1 = acc1 + acc(1);

	%GJDA
	fprintf('========================GJDA========================\n')

	dim_S = size(S,1);
	S = [S;zeros(size(T,1),size(S,2))];
	T = [zeros(dim_S,size(T,2));T];
	Ttest = [zeros(dim_S,size(Ttest,2));Ttest];

	options.k = 80; %Latent Space Dimentionality
	options.lambda = 1; %Regularirzier Parameter

	L_S = S;
	L_T = T;
	L = [S,T]; %Label Data
	U   = Ttest; %Unlabel Data
	L_Label = [S_Label;T_Label];
	U_Label = Ttest_Label;
	Time =10;
	cls = []; %Psuedo Label
	for t = 1:Time
	        [Z,A] = GJDA(L_S,L_T,U,S_Label,T_Label,cls,options);
	        Z = Z*diag(sparse(1./sqrt(sum(Z.^2))));
	        Zs = Z(:,1:size(L,2));
	        Zt = Z(:,size(L,2)+1:end);
	        [model] = svmtrain(L_Label,Zs',option);
	        [cls,ac3,~] = svmpredict(U_Label,Zt',model,'-q'); %Update Pseudo Label
	        fprintf('in %dth_GJDA:acc:%f\n',t,ac3(1));
    end
    %The Final Test
    Zsout = A'*L;
    Ztout = A'*U;
	[model] =svmtrain(L_Label,Zsout',option);
	[predict_Label,acc,~] = svmpredict(U_Label,Ztout',model,'-q');
	fprintf('GJDA accuracy is:%f\n',acc(1));
	acc2 = acc2 + acc(1);
	%==========================================================================
end
	fprintf('===========================================================\n');
	fprintf('Baseline Total Acc:%f\n',acc1/iter);
	fprintf('GJDA Total Acc:%f\n',acc2/iter);
end