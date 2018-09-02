Domain Adaptation for Cross-Domain Object Recogntion and Cross-Lingual Text Categorization
=========================
Author: Shih-Yen Tao <shihyen@andrew.cmu.edu>
This is my project page for cross-domain object recognition and cross-lingual text categorization with domain adaptation algorithms involved. </br>
I open-source my two approaches toward domain adaptation task: </br>
1. **Generalized Joint Distribution Adaptation** </br>
2. **Domain Adaptation via Convex Optimization** </br>

Generalized Joint Distribution Adaptation:
------
- This is the package with code and demo usage for the paper:</br>
- **Recognizing Heterogeneous Cross Domain Data via Generalized Joint Distribution Adaptation**</br>
- Aut.her: Shih-Yen Tao*, Yuan-Ting Hsieh*, Yao-Hung Hubert Tsai, Yi-Ren Yeh and Yu-Chiang Frank Wang (*equal contribution)
- Published in International Conference on MUltimedia and Expo (ICME) 2016
- Prepare Data
	- Download data from <https://drive.google.com/drive/folders/0B1QmFw8l-GM2TUxadVNqNG1IYkE>
	- Put data in */Data/*
- Download and compile libsvm
	- The path to **libsvm** code available at
        <https://www.csie.ntu.edu.tw/~cjlin/libsvm/#download>
    - Put the library under */GJDA/*
    - Edit the path to **/lib/libsvm-X.XX/matlab**
    - Edit the paramters of *options.k* and *options.lambda* if you want
- Run demo code:
	- Directly run **/GJDA/GJDA_Demo.m**
	- There are three different experiements in this code: cross-feature, cross-domain, and cross-lingual experiement
	- You can choose one of them by yourself

Domain Adaptation via Convex Optimization:
------
- The package is the demo code for the final project for **CMU 10725 (Convex Optimization)**
- In addition, I implemented a **matlab versioin for LIBLINEAR** using **Newtown Method** and **Conjugate Gradient Descent** algorithms
- Prepare Data
	- Download data from <https://drive.google.com/drive/folders/0B1QmFw8l-GM2TUxadVNqNG1IYkE>
	- Put data in */Data/*
- Download and compile libsvm for the baseline comparison
	- The path to **libsvm** code available at
        <https://www.csie.ntu.edu.tw/~cjlin/libsvm/#download>
    - Put the library under */Convex/*
    - Edit the path to **/lib/libsvm-X.XX/matlab**
- Run demo code:
	- Just run **/Convex/Demo.m**
	- Three different experiments can be found in the demo code
- My own MATLAB implementation for LIBLINEAR-LINESEARCH-2.1
	- The original LIBLINEAR software can be found in <https://www.csie.ntu.edu.tw/~cjlin/liblinear/>
	- My svm train function is implemented in **/Convex/my_train_liblinear.m**
	- My svm predict function is implemented in **/Convex/my_test_liblinear.m**
	- You can train and test your own SVM model by
	```
	[model] = my_train_liblinear(train_label,train_data,options)
	[predict_label,acc] = my_test_liblinear(test_label,test_data,model)
	```
