function [Z,A] = GJDA(S,T,Ttest,S_Label,T_Label,Ttest_Label,options)

	k = options.k;
	lambda = options.lambda;

	% Set Predefined Variables
	X = [S,T,Ttest];
	X = X*diag(sparse(1./sqrt(sum(X.^2))));
	n  = size(X,2);
	ns = size(S,2);
	nt = size(T,2);
	nttest = size(Ttest,2);
	C = length(unique(S_Label));

	%Construct MMD0 matrix
	num_t = nt+nttest;
	num_s = ns;
	e = [1/num_s*ones(num_s,1);-1/num_t*ones(num_t,1)];
	M = e*e';

	%Construct MMD1~C matrix
	for c = reshape(unique(S_Label),1,C)
	    e = zeros(num_s+num_t,1);
	    e(find(S_Label==c)) = 1/length(find(S_Label==c));
	    Target_Label = [T_Label;Ttest_Label];
	    e(ns+find(Target_Label==c)) = -1/length(find(Target_Label==c));
	    e(isinf(e)) = 0;
	    M = M + e*e';
	end

	M = M/norm(M,'fro');

	%Construct Centering Matrix
	H = eye(n)-1/(n)*ones(n,n);

	%Solve Transformation A
	[A,~] = eigs(X*M*X'+lambda*eye(size(X*X')),X*H*X',k,'SM');
	Z = A'*X;
end