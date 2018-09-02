function [A] = solve_A(S,S_Label,S_t_mean,T_t_mean,model,options)
	epoch = 1000;
	class_num = length(unique(S_Label));
	label = -1*ones(length(S_Label),class_num);
	for c = 1:class_num
		label(find(S_Label==c),c) = 1;
	end
	A = zeros(size(S,1),size(T_t_mean,1));
	base_grad = eye(size(S,1))+2*S_t_mean*S_t_mean';
	base_grad2 = -2*S_t_mean*T_t_mean';
	inner = model'*A'*S;
	grad = compute_gradient(A,label,S,base_grad,base_grad2,inner,model,options);
	stop_num = 0.001*norm(grad);
	p = zeros(size(S,1),size(T_t_mean,1));
	A_P = A;
	for i = 1:epoch

		grad = compute_gradient(A,label,S,base_grad,base_grad2,inner,model,options);
		if norm(grad) <= stop_num
			break
		end
		alpha = 0.2;
		beta = 0.5;
		t = 1;
		f = compute_function(A,label,S,S_t_mean,T_t_mean,inner,options);
		if mod(i,1000) == 0
			fprintf('Epoch[%d]:%f\n',i,f);
		end
		num = alpha*norm(grad,'fro')^2;
		s = -compute_gradient(A+(i-2)/(i+1)*(A-A_P),label,S,base_grad,base_grad2,inner,model,options)+...
		(i-2)/(i+1)*p;
		p = s;
		%s = -compute_gradient(A,label,S,base_grad,base_grad2,inner,model,options);
		while true
			A_w = A+t*s;
			inner_w = inner+model'*t*s'*S;
			temp_f = compute_function(A_w,label,S,S_t_mean,T_t_mean,inner_w,options);
			if(temp_f<=f-t*num)
				A_P = A;
				A = A_w;
				inner = inner_w;
				break
			end
			t = beta*t;
		end
	end
end

function [value] = compute_function(A,label,S,S_t_mean,T_t_mean,inner,options)
	c = options.c;
	value = 0.5*norm(A,'fro')^2+c*norm(max(0,1-label.*(inner)'),'fro')^2+...
	        norm(A'*S_t_mean-T_t_mean,'fro')^2;
end

function [grad] = compute_gradient(A,label,S,base_grad,base_grad2,inner,model,options)
	c = options.c;
	grad = base_grad*A+base_grad2;
	if c==0
		return
	end
	map = (1-label.*(inner)')>0;
	data_sum = S*(map.*(label-(inner)'));
	grad = grad - 2*data_sum*model';
end