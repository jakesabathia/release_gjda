%add libs
addpath('../Data');
addpath('./lib/libsvm-3.22/matlab');

%clean interface
clear all
%==========================================================================
for expi = 1:3
iter = 10;
acc1 = 0; %Acc for Baseline
acc2 = 0; %Acc for Convex

%Prepare Data (Choose the three setting below by yourself)
%For Cross-Feature Classification 
source_exp = {'randsource_webcam_SURF_L10.mat','randsource_Caltech10_SURF_L10.mat','randsource_amazon_SURF_L10.mat'};
target_exp = {'randtarget_webcam_DeCAF6.mat','randtarget_Caltech10_DeCAF6.mat','randtarget_amazon_DeCAF6.mat'};

%For Cross-Domain Classification
%source_exp = {'randsource_webcam_SURF_L10.mat','randsource_Caltech10_SURF_L10.mat','randsource_amazon_SURF_L10.mat'};
%target_exp = {'randtarget_dslr_DeCAF6.mat','randtarget_dslr_DeCAF6.mat','randtarget_dslr_DeCAF6.mat'};

%For Multi-Lingual Classification
%source_exp = {'rand_EN.mat','rand_FR.mat','rand_GR.mat','rand_IT.mat'};
%target_exp = {'rand_SP_10.mat','rand_SP_10.mat','rand_SP_10.mat','rand_SP_10.mat'};


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

	%parameters
	svm_options.epsilon = 0.01;
	svm_options.c = 1;
	svm_options.verbose = false;
	[model] = my_train_liblinear(T_Label,T,svm_options);
	[predict_label,acc] = my_predict_liblinear(Ttest_Label,Ttest,model);
	fprintf('My liblinear Acc:%f\n',acc)

	%GJDA
	fprintf('========================Convex========================\n')

	%Precompute Class-Wise Mean
	class_num = length(unique(S_Label));
	S_c_mean = [];
	T_c_mean = [];
	for i = 1:class_num
		S_c_mean = [S_c_mean,mean(S(:,find(S_Label==i)),2)];
		T_c_mean = [T_c_mean,mean(T(:,find(T_Label==i)),2)];
	end
	S_t_mean = [S_c_mean];
	T_t_mean = [T_c_mean];
	options.c = svm_options.c;
	Time = 5;
	cls = []; %Psuedo Label
	type = 2;
	L_Label = [S_Label;T_Label];
	model = zeros(size(model));
	for t = 1:Time    
	    if t == 1
	    	A = inv(eye(size(S,1))+2*S_t_mean*S_t_mean')*2*S_t_mean*T_t_mean';
	    else
	    	[A] = solve_A(S,S_Label,S_t_mean,T_t_mean,model,options);
	    end
	    options.c = svm_options.c;
	    L = [A'*S,T];
	    L_Label = [S_Label;T_Label];
	    c = svm_options.c;
	    label = -1*ones(length(L_Label),length(unique(L_Label)));
		for c = 1:class_num
			label(find(L_Label==c),c) = 1;
		end
	    obj = 1/2*(norm(A,'fro')^2+norm(model,'fro')^2)+...
	    norm(A'*S_t_mean-T_t_mean,'fro')^2+norm(max(0,1-label.*(model'*L)'),'fro')^2;
	    fprintf('objective:%f\n',obj);
	        	
	    [model] = my_train_liblinear(L_Label,L,svm_options);
		[cls,acc] = my_predict_liblinear(Ttest_Label,Ttest,model);
	    fprintf('in %dth_Convex:acc:%f\n',t,acc);
	    temp_Label = [T_Label;cls];
	    temp_T = [T,Ttest];
	    T_c_mean = [];
		for i = 1:class_num
			T_c_mean = [T_c_mean,mean(temp_T(:,find(temp_Label==i)),2)];
		end
		T_t_mean = [T_c_mean];
    end
	fprintf('Convex accuracy is:%f\n',acc);
	acc2 = acc2 + acc;
	%==========================================================================
	fprintf('===========================================================\n');
	fprintf('Baseline Total Acc:%f\n',acc1/iter);	
	fprintf('Convex Total Acc:%f\n',acc2/iter);
end
end