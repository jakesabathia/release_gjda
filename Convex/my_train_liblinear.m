function [model] = my_train_liblinear(train_label,train_x,options)

	epoch = 10000;
	verbose = options.verbose;
	class_num = length(unique(train_label));
	num = length(train_label);
	if class_num == 2
		label_c = ones(length(train_label),1);
		label_c(find(train_label==2)) = -1;
		model = zeros(size(train_x,1),1);
		class_num = 1;
	else
		label_c = -1*ones(num,class_num);
		for c = 1:class_num
			label_c(find(train_label==c),c) = 1;
		end
		model = zeros(size(train_x,1),class_num);	
	end

	for temp_class = 1:class_num
		w = model(:,temp_class);
		label = label_c(:,temp_class);
		inner = w'*train_x; 
		options.kasid = 0.1;
		epilson = options.epsilon;
		lo = 0.01;
		stopnum = norm(compute_gradient(w,inner,label,train_x,options));
		[f] = compute_function(w,inner,label,train_x,options);
		for i = 1:epoch
			if verbose 
				fprintf('\niter[%d]:',i);
			end
			[f_g] = compute_gradient(w,inner,label,train_x,options);
			[f] = compute_function(w,inner,label,train_x,options);
			if verbose 
				fprintf(' f:%f',f);
			end
			f_g_norm = norm(f_g);
			if verbose 
				fprintf(' |f_g|:%f ',f_g_norm);
			end
			if f_g_norm <= epilson*stopnum
				break
			end
			[s,i_t] = compute_s(w,inner,f_g,label,train_x,options);
			if verbose
				fprintf('  CG:%f',i_t);
			end
			num = s'*f_g*lo;
			s_inner_x = s'*train_x;
			alpha = 1;
			while true
				a_inner = inner +alpha*s_inner_x;
				a_w = w + alpha*s;
				[a_f] = compute_function(a_w,a_inner,label,train_x,options);
				if a_f <= (f + alpha*num)
					break
				end
				alpha = 0.5*alpha;
			end
			if verbose 
				fprintf(' stepsize:%f',alpha)
			end
			w = a_w;
			inner = a_inner;
		end
		model(:,temp_class) = w;
	end
end

function [gradient] = compute_gradient(w,inner,y,x,options)
	c = options.c;
	map = (1 - y.*inner')>0;
	gradient = w - 2*c*x*(map.*(y-inner'));
end

function [value] = compute_function(w,inner,y,x,options)
	c = options.c;
	map = (1 - y.*inner')>0;
	value = 1/2*(norm(w,'fro'))^2 + c * (norm((max(0,1-y.*(inner'))),'fro'))^2;
end

function [x] = compute_hessian_mul(s,C,D,X)
	temp = X'*s;
	temp = D.*temp;
	x = s + 2*C*X*temp;
end

function [s,t] = compute_s(w,inner,f_g,y,x,options)

	D = (1 - y.*inner')>0;
	X = x;
	n = size(x,1);
	kasid = options.kasid;
	C = options.c;
	s = zeros(n,1);
	r = -f_g;
	d = r;
	t = 0;
	stop = norm(f_g);
	while true
		r_norm = norm(r);
		if r_norm <= kasid*stop
			break
		end
		h_f_d = compute_hessian_mul(d,C,D,X);
		alpha = r_norm^2/(d'*h_f_d);
		s = s + alpha*d;
		r = r - alpha*h_f_d;
		beta = norm(r)^2/(r_norm^2);
		d = r + beta*d;
		t = t+1;
	end
end