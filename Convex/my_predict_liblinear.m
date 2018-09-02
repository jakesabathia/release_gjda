function [p_label,acc] = my_predict_liblinear(test_label,test,model)

	if size(model,2) == 1
		coco = model'*test;
		temp = coco;
		coco(find(temp>=0)) = 1;
		coco(find(temp<0)) = 2;
		p_label = coco;
		acc = sum(p_label==test_label')/length(test_label)*100;
		p_label = p_label';
	else
		[~,p_label] = max(model'*test);
		acc = sum(p_label == test_label')/length(test_label)*100;
		p_label = p_label';
	end

end